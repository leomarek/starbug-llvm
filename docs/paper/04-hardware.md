# The hardware, as the compiler sees it

[`../HARDWARE_CONTRACT.md`](../HARDWARE_CONTRACT.md) is the authority — it is
read out of the RTL and consumed by both the back end and the verifier. This
file is the paper-facing summary plus the parts that need framing rather than
just stating.

## 1. The hint

16-bit RVC `C.LI x0, imm`, detected **before** decompression (`ifu.sv:346–354`):

```
op_c     == 2'b01
funct3_c == 3'b010
rd_c     == 5'b00000
imm_c    == {instr[12], instr[6:2]}   // 6 bits, nonzero
```

`rd == x0` ⇒ architecturally a NOP ⇒ a STARBUG binary runs unmodified on any
RV32C core. This is the property the whole design rests on, and it is also what
lets Spike serve as a functional reference for STARBUG binaries.

## 2. Bundle length: 4, and it is a bundle, not a window

`ifu.sv:395–396` forms a bundle only when `is_vliw_hint && imm_c >= 1 && imm_c <= 4`.

A hint of 5 or more does **not** produce a wider bundle and does **not** degrade
into a scheduling window — the entire condition fails, `VLIWModeF` stays low,
and everything after the hint executes scalar. The hint costs two bytes and buys
nothing.

Worth stating explicitly in the paper, because "what happens at N > lanes" is a
question a reviewer will ask about any hint encoding, and "it is silently
rejected" is a cleaner answer than most alternatives. The compiler never emits
one; the verifier treats `imm_c > 4` as an error, not a missed opportunity.

## 3. Asymmetric lanes, with no interlock

Lane 0 is a full IEU. Worker lanes 1–3 are the same module with paths
disconnected (`wallypipelinedcore.sv:408–460` and the lane 2/3 blocks):

- `IEUAdrE` commented out — no address reaches the LSU.
- `PCSrcE` commented out — a worker lane cannot redirect the PC.
- `MemRWM_1/_2/_3` declared and driven but **connected to nothing**.

**That last point is the dangerous one, and it is the paper's best argument for
having a verifier.** A load or store in a worker lane does not trap and does not
stall. It is silently dropped, and the destination register keeps its stale
value. There is no hardware check.

The same is true of the dependence rules. `controller.sv:523` states the
assumption in a comment:

> Following logic assumes that multiple instructions in STARBUG VLIW bundles
> cannot write to the same register.

A violated assumption is a **silent wrong answer, not a fault**.

This is a defensible design choice — checking would cost the area the hint
encoding was meant to save — but it must be presented as a deliberate trade with
a named mitigation (the verifier), not left for a reviewer to discover.

## 4. The dependence rules

All lanes read the register file in one cycle and write back in one cycle.

- **RAW forbidden** — the consumer reads the stale value. There is no
  same-cycle E-to-E forwarding path; forwarding reaches back only to M and W of
  any lane (`controller.sv:516–560`).
- **WAW forbidden** — no defined winner.
- **WAR safe** — every lane reads before any lane writes back.

Integer and floating-point registers are separate architectural files, so these
rules apply *within* each file and never across. Tooling that conflates them
reports false RAW on sequences like `fmv.w.x fa1, zero` / `addi a4, a1, 16` —
which is exactly the verifier bug described in §6.

### 4.1 The scalar-fallback invariant

The single most important rule for the compiler, and the one worth the most
space in the paper.

When the fetch unit declines a bundle it sets `BundleBytesF = 2`, skips the
two-byte hint, and executes the following instructions **scalar, in memory
order** (`ifu.sv:514–521`). A branch landing mid-bundle does the same. And the
ISA-compatibility claim requires that a stock RV32C core, which always executes
sequentially, gets the right answer.

Therefore: **the emitted byte order must be a correct sequential program in its
own right.** Any permutation the packetizer performs must be justified by *full*
independence — RAW and WAW (needed for parallel issue) *plus* WAR (needed once
the order changes).

The consequence is a nice piece of compiler reasoning: the final hint gate needs
only RAW/WAW, but the *reordering* step needs WAR too, and conflating the two
either loses bundling or loses correctness.

## 5. Fetch-side constraints (performance, not correctness)

Bundle formation is suppressed when (`ifu.sv:395`, `407–510`):

- the fetch is not cacheable, comes from the IROM, or is a spill fetch;
- the bundle's bytes do not all fit in the current I-cache line.

Both cost performance only — the fallback is always correct. The second is what
[`03-compiler.md`](03-compiler.md) §4 exists to address.

Compressed instructions are supported inside bundles; the extractor handles
mixed 16/32-bit members and computes `BundleBytesF` accordingly.

## 6. Shared resources: legal ≠ free

Independence is necessary but not sufficient for single-cycle issue. Lanes
contend for:

- the single **LSU** (structural — enforced as a legality rule above);
- the **MDU** — `MDUActiveE_*` is broadcast between lanes and feeds `MDUStallD`
  (`controller.sv:678–684`), so multiple multiplies in flight stall decode;
- **`fdiv`/`fsqrt`** — `FDivBusyE` is ORed across lanes into a core-wide execute
  stall (`hazard.sv:87`);
- the **writeback** path and widened register file ports.

The legality rules make a bundle *safe*; they do not make it *free*. Cycle-level
cost has to come from RTL simulation — which is why the evaluation uses Questa
and not an issue-slot model. Worth a sentence: static bundle counts and dynamic
ILP estimates both overstate what the hardware delivers, and the paper's tables
should be explicit about which quantity each one measures.

## 7. FP in the worker lanes (this cycle's RTL work)

The `starbug` config previously had `F`, `D`, `Q`, `Zfh` and `Zfa` all disabled
— an integer-only machine, which is the wrong machine for a DSP workload. The
FP datapath is now wired out to the worker lanes:

- `fregfile_widened.sv` — four write ports, three read ports per lane.
- `fpu_1`/`fpu_2`/`fpu_3` instantiated beside the lane IEUs, each fed from its
  own decode slice.
- Each lane's FP-to-integer results routed back into that lane's own IEU
  writeback, so `fmv.x.w` and `fcvt.w.s` land in the right register file.
- `SetFflagsM` ORed across lanes, so accrued exception flags are not lost.
- `fhazard.sv` checks all four lanes for RAW against D and forwards from
  whichever lane produced the value.

`config/starbugi` preserves the integer-only configuration, so the FP
contribution can be **measured** against it rather than asserted. Doing that
measurement is an open item — see [`08-open-questions.md`](08-open-questions.md).

### 7.1 Two bugs that fall out, and apply to the scalar core too

Both are worth mentioning as evidence that the multi-lane work found latent
defects in the baseline, not just in the extension:

- **`fhazard.sv`**: the M-stage forward was gated on `FResSelM == 2'b00`, which
  excludes the load/store path by construction rather than by intent. Now an
  explicit `FpLoadStoreM` says what is meant. And `FPUStallD` was
  `MatchDE & FRegWriteE`, but `MatchDE` did not itself account for
  `FRegWriteE` per source — so the write-enable was checked once against a term
  that had already collapsed the lanes together.
- **`fctrl.sv`**: `fadd`/`fsub` carry their addend on the Z port but encode it
  in **rs2, not rs3**, so `Adr3D` read the wrong instruction field and the
  hazard logic watched a register the instruction never uses.

### 7.2 And in `controller.sv`

The integer hazard unit treated FP opcodes as if they used rs1/rs2 like integer
ones. In fact: FP loads use rs1 as address base; FP stores use rs1 only (rs2 is
an FP source); and in the FP arithmetic opcode space only `fmv.*.x`,
`fcvt.*.<int>` and `fmvp.*.x` source integer registers. These are now decoded
explicitly rather than assumed.

## 8. FPGA cost

See [`02-results.md`](02-results.md) §9 — **including the warning that the
baseline column needs to be re-established before publication.** The most likely
reading of the current spreadsheets is that they compare integer-STARBUG against
FP-STARBUG, not stock Wally against STARBUG.
