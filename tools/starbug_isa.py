"""RV32IMAFC instruction decoder for STARBUG bundle analysis.

Decodes raw instruction words (not objdump text) so that register
dependence and lane-legality analysis is exact rather than heuristic.

The single source of truth for lane legality is the STARBUG RTL:
  - cvw/src/ifu/ifu.sv            (bundle extraction, HINT encoding)
  - cvw/src/wally/wallypipelinedcore.sv (per-lane IEU and FPU wiring)
  - cvw/src/fpu/fregfile_widened.sv     (4-write-port f-register file)

Worker lanes (1..3) have IEUAdrE / PCSrcE disconnected and their MemRWM
outputs are wired to nothing, so anything touching memory, control flow,
CSRs or the PC must be placed in lane 0.

Floating point is *not* in that list. wallypipelinedcore.sv instantiates
fpu_1/fpu_2/fpu_3 alongside the lane IEUs and feeds them from
fregfile_widened, which has four write ports and three read ports per lane.
FP arithmetic is therefore legal in every lane; only FP *memory* (flw/fsw and
their compressed forms) is restricted, and that falls out of the single-LSU
rule rather than out of anything FP-specific.

Integer and floating-point registers live in separate architectural files, so
this decoder numbers them in separate ranges: x0..x31 are 0..31 and f0..f31 are
FREG_BASE+0..FREG_BASE+31. Conflating the two produced false RAW reports on
code like `fmv.w.x fa1, zero` followed by `addi a4, a1, 16`.
"""

# Instruction classes.
ALU = "alu"        # integer ALU, legal in any lane
MUL = "mul"        # M-extension, legal in any lane but shares the MDU
LOAD = "load"      # lane 0 only
STORE = "store"    # lane 0 only
BRANCH = "branch"  # lane 0 only
JUMP = "jump"      # lane 0 only
SYSTEM = "system"  # CSR / ecall / ebreak / fence, lane 0 only
ATOMIC = "atomic"  # lane 0 only
PCREL = "pcrel"    # AUIPC: reads PC, which is the bundle PC, lane 0 only
FPU = "fpu"        # FP arithmetic: legal in any lane (fpu_1/2/3 exist)
FPDIV = "fpdiv"    # fdiv/fsqrt: legal in any lane, but stalls E core-wide
UNKNOWN = "unknown"

LANE0_ONLY = {LOAD, STORE, BRANCH, JUMP, SYSTEM, ATOMIC, PCREL, UNKNOWN}

# Registers are numbered in two disjoint ranges so an integer and a
# floating-point register with the same index never alias.
FREG_BASE = 32


def F(n):
    """Architectural f-register n as a dependence-analysis register number."""
    return FREG_BASE + (n & 31)


def regname(n):
    """Render a dependence-analysis register number for a diagnostic."""
    return f"f{n - FREG_BASE}" if n >= FREG_BASE else f"x{n}"

# Classes that occupy the single shared LSU.
LSU_CLASSES = {LOAD, STORE, ATOMIC}


class Insn:
    """A decoded instruction.

    reads/writes are sets of architectural register numbers: x0..x31 map to
    0..31 and f0..f31 map to FREG_BASE..FREG_BASE+31. x0 is excluded because it
    is hardwired to zero and can never carry a dependence; f0 is a normal
    register and is kept.
    """

    __slots__ = ("addr", "word", "size", "cls", "reads", "writes", "text")

    def __init__(self, addr, word, size, cls, reads, writes, text=""):
        self.addr = addr
        self.word = word
        self.size = size
        self.cls = cls
        self.reads = {r for r in reads if r != 0}
        self.writes = {w for w in writes if w != 0}
        self.text = text

    @property
    def is_lane0_only(self):
        return self.cls in LANE0_ONLY

    @property
    def uses_lsu(self):
        return self.cls in LSU_CLASSES

    def __repr__(self):
        return f"<Insn {self.addr:#x} {self.text or hex(self.word)} cls={self.cls}>"


def is_compressed(word):
    return (word & 3) != 3


# ---------------------------------------------------------------------------
# HINT detection
# ---------------------------------------------------------------------------

def hint_length(word):
    """Return the bundle length encoded by a STARBUG HINT, else None.

    Mirrors ifu.sv exactly:
        op_c     == 2'b01
        funct3_c == 3'b010   (C.LI)
        rd_c     == 5'b00000
        imm_c    == {instr[12], instr[6:2]}, nonzero

    Note this is the *raw* 6-bit immediate. The RTL only forms a bundle
    when 1 <= imm_c <= 4; other values fall back to scalar execution.
    """
    if (word & 3) != 1:
        return None
    if ((word >> 13) & 7) != 2:
        return None
    if ((word >> 7) & 0x1F) != 0:
        return None
    imm = ((word >> 12) & 1) << 5 | ((word >> 2) & 0x1F)
    if imm == 0:
        return None
    return imm


MAX_BUNDLE = 4  # ifu.sv: (imm_c >= 1) && (imm_c <= 4)


# ---------------------------------------------------------------------------
# 32-bit decode
# ---------------------------------------------------------------------------

# OP-FP (opcode 0x53) sub-decode. funct7[1:0] selects the format (S/D/H/Q) and
# never changes which register file an operand comes from, so the table is
# keyed on funct7[6:2].
_OPFP_FF = 0    # rd:f  rs1:f  rs2:f
_OPFP_FF1 = 1   # rd:f  rs1:f          (single-source, e.g. fsqrt, fcvt.s.d)
_OPFP_XFF = 2   # rd:x  rs1:f  rs2:f   (feq/flt/fle)
_OPFP_XF = 3    # rd:x  rs1:f          (fcvt.w.s, fmv.x.w, fclass)
_OPFP_FX = 4    # rd:f  rs1:x          (fcvt.s.w, fmv.w.x)

_OPFP_SHAPE = {
    0x00: _OPFP_FF,    # FADD
    0x01: _OPFP_FF,    # FSUB
    0x02: _OPFP_FF,    # FMUL
    0x03: _OPFP_FF,    # FDIV
    0x04: _OPFP_FF,    # FSGNJ / FSGNJN / FSGNJX
    0x05: _OPFP_FF,    # FMIN / FMAX
    0x08: _OPFP_FF1,   # FCVT.fmt.fmt
    0x0B: _OPFP_FF1,   # FSQRT
    0x14: _OPFP_XFF,   # FEQ / FLT / FLE
    0x18: _OPFP_XF,    # FCVT.int.fmt
    0x1A: _OPFP_FX,    # FCVT.fmt.int
    0x1C: _OPFP_XF,    # FMV.X.W / FCLASS
    0x1E: _OPFP_FX,    # FMV.W.X
}

# fdiv and fsqrt drive FDivBusyE, which is ORed across lanes into a core-wide
# execute stall (wallypipelinedcore.sv:636, hazard.sv:87). They are still legal
# in a worker lane; they are just not free.
_OPFP_LONG_LATENCY = {0x03, 0x0B}


def _decode_op_fp(addr, w, rd, rs1, rs2, funct3, funct7):
    f5 = funct7 >> 2
    shape = _OPFP_SHAPE.get(f5)
    cls = FPDIV if f5 in _OPFP_LONG_LATENCY else FPU
    if shape is None:
        return Insn(addr, w, 4, UNKNOWN, (F(rs1), F(rs2)), (F(rd),))
    if shape == _OPFP_FF:
        return Insn(addr, w, 4, cls, (F(rs1), F(rs2)), (F(rd),))
    if shape == _OPFP_FF1:
        return Insn(addr, w, 4, cls, (F(rs1),), (F(rd),))
    if shape == _OPFP_XFF:
        return Insn(addr, w, 4, cls, (F(rs1), F(rs2)), (rd,))
    if shape == _OPFP_XF:
        return Insn(addr, w, 4, cls, (F(rs1),), (rd,))
    return Insn(addr, w, 4, cls, (rs1,), (F(rd),))


def _decode32(addr, w):
    opcode = w & 0x7F
    rd = (w >> 7) & 0x1F
    funct3 = (w >> 12) & 7
    rs1 = (w >> 15) & 0x1F
    rs2 = (w >> 20) & 0x1F
    funct7 = (w >> 25) & 0x7F

    if opcode == 0x37:                      # LUI
        return Insn(addr, w, 4, ALU, (), (rd,))
    if opcode == 0x17:                      # AUIPC (reads PC)
        return Insn(addr, w, 4, PCREL, (), (rd,))
    if opcode == 0x6F:                      # JAL
        return Insn(addr, w, 4, JUMP, (), (rd,))
    if opcode == 0x67:                      # JALR
        return Insn(addr, w, 4, JUMP, (rs1,), (rd,))
    if opcode == 0x63:                      # BRANCH
        return Insn(addr, w, 4, BRANCH, (rs1, rs2), ())
    if opcode == 0x03:                      # LOAD
        return Insn(addr, w, 4, LOAD, (rs1,), (rd,))
    if opcode == 0x23:                      # STORE
        return Insn(addr, w, 4, STORE, (rs1, rs2), ())
    if opcode == 0x13:                      # OP-IMM
        return Insn(addr, w, 4, ALU, (rs1,), (rd,))
    if opcode == 0x33:                      # OP (incl. M extension)
        cls = MUL if funct7 == 0x01 else ALU
        return Insn(addr, w, 4, cls, (rs1, rs2), (rd,))
    if opcode == 0x0F:                      # MISC-MEM (fence)
        return Insn(addr, w, 4, SYSTEM, (rs1,), (rd,))
    if opcode == 0x73:                      # SYSTEM (ecall/ebreak/CSR)
        return Insn(addr, w, 4, SYSTEM, (rs1,), (rd,))
    if opcode == 0x2F:                      # AMO
        return Insn(addr, w, 4, ATOMIC, (rs1, rs2), (rd,))
    if opcode == 0x07:                      # LOAD-FP (flw/fld): int base, f dest
        return Insn(addr, w, 4, LOAD, (rs1,), (F(rd),))
    if opcode == 0x27:                      # STORE-FP (fsw/fsd): int base, f data
        return Insn(addr, w, 4, STORE, (rs1, F(rs2)), ())
    if opcode in (0x43, 0x47, 0x4B, 0x4F):  # FMADD/FMSUB/FNMSUB/FNMADD
        rs3 = (w >> 27) & 0x1F
        return Insn(addr, w, 4, FPU, (F(rs1), F(rs2), F(rs3)), (F(rd),))
    if opcode == 0x53:                      # OP-FP
        return _decode_op_fp(addr, w, rd, rs1, rs2, funct3, funct7)

    return Insn(addr, w, 4, UNKNOWN, (rs1, rs2), (rd,))


# ---------------------------------------------------------------------------
# 16-bit (RVC) decode -- RV32 encodings
# ---------------------------------------------------------------------------

def _rvc_reg(x):
    """Map a 3-bit compressed register field to x8..x15."""
    return (x & 7) + 8


def _decode16(addr, w):
    op = w & 3
    funct3 = (w >> 13) & 7

    rd_full = (w >> 7) & 0x1F
    rs2_full = (w >> 2) & 0x1F
    rdp = _rvc_reg(w >> 2)
    rs1p = _rvc_reg(w >> 7)
    rs2p = _rvc_reg(w >> 2)

    if op == 0:
        if funct3 == 0:                     # C.ADDI4SPN -> addi rd', x2, imm
            if w == 0:
                return Insn(addr, w, 2, UNKNOWN, (), ())   # illegal
            return Insn(addr, w, 2, ALU, (2,), (rdp,))
        if funct3 == 2:                     # C.LW
            return Insn(addr, w, 2, LOAD, (rs1p,), (rdp,))
        if funct3 == 6:                     # C.SW
            return Insn(addr, w, 2, STORE, (rs1p, rs2p), ())
        if funct3 in (1, 3):                # C.FLD / C.FLW
            return Insn(addr, w, 2, LOAD, (rs1p,), (F(rs2p),))
        if funct3 in (5, 7):                # C.FSD / C.FSW
            return Insn(addr, w, 2, STORE, (rs1p, F(rs2p)), ())
        return Insn(addr, w, 2, UNKNOWN, (), ())

    if op == 1:
        if funct3 == 0:                     # C.ADDI (rd==0 -> NOP/HINT)
            if rd_full == 0:
                return Insn(addr, w, 2, ALU, (), ())
            return Insn(addr, w, 2, ALU, (rd_full,), (rd_full,))
        if funct3 == 1:                     # C.JAL (RV32)
            return Insn(addr, w, 2, JUMP, (), (1,))
        if funct3 == 2:                     # C.LI
            return Insn(addr, w, 2, ALU, (), (rd_full,))
        if funct3 == 3:                     # C.ADDI16SP (rd==2) / C.LUI
            if rd_full == 2:
                return Insn(addr, w, 2, ALU, (2,), (2,))
            return Insn(addr, w, 2, ALU, (), (rd_full,))
        if funct3 == 4:                     # MISC-ALU
            sub = (w >> 10) & 3
            if sub in (0, 1):               # C.SRLI / C.SRAI
                return Insn(addr, w, 2, ALU, (rs1p,), (rs1p,))
            if sub == 2:                    # C.ANDI
                return Insn(addr, w, 2, ALU, (rs1p,), (rs1p,))
            # sub == 3: register-register ops
            return Insn(addr, w, 2, ALU, (rs1p, rs2p), (rs1p,))
        if funct3 == 5:                     # C.J
            return Insn(addr, w, 2, JUMP, (), ())
        if funct3 in (6, 7):                # C.BEQZ / C.BNEZ
            return Insn(addr, w, 2, BRANCH, (rs1p,), ())
        return Insn(addr, w, 2, UNKNOWN, (), ())

    if op == 2:
        if funct3 == 0:                     # C.SLLI
            return Insn(addr, w, 2, ALU, (rd_full,), (rd_full,))
        if funct3 == 2:                     # C.LWSP
            return Insn(addr, w, 2, LOAD, (2,), (rd_full,))
        if funct3 in (1, 3):                # C.FLDSP / C.FLWSP
            return Insn(addr, w, 2, LOAD, (2,), (F(rd_full),))
        if funct3 == 4:
            bit12 = (w >> 12) & 1
            if bit12 == 0:
                if rs2_full == 0:           # C.JR
                    return Insn(addr, w, 2, JUMP, (rd_full,), ())
                return Insn(addr, w, 2, ALU, (rs2_full,), (rd_full,))   # C.MV
            if rd_full == 0 and rs2_full == 0:                          # C.EBREAK
                return Insn(addr, w, 2, SYSTEM, (), ())
            if rs2_full == 0:                                           # C.JALR
                return Insn(addr, w, 2, JUMP, (rd_full,), (1,))
            return Insn(addr, w, 2, ALU, (rd_full, rs2_full), (rd_full,))  # C.ADD
        if funct3 == 6:                     # C.SWSP
            return Insn(addr, w, 2, STORE, (2, rs2_full), ())
        if funct3 in (5, 7):                # C.FSDSP / C.FSWSP
            return Insn(addr, w, 2, STORE, (2, F(rs2_full)), ())
        return Insn(addr, w, 2, UNKNOWN, (), ())

    return Insn(addr, w, 2, UNKNOWN, (), ())


def decode(addr, word, text=""):
    insn = _decode16(addr, word & 0xFFFF) if is_compressed(word) else _decode32(addr, word)
    insn.text = text
    return insn
