# STARBUG Hardware Contract

Everything below was read out of the RTL, not inferred from the paper. These
are the rules the compiler back end and `tools/starbug_bundle_check.py` both
implement; if the RTL changes, change this file and both consumers.

Sources:
- `cvw/src/ifu/ifu.sv` — HINT decode, bundle extraction, PC advance
- `cvw/src/wally/wallypipelinedcore.sv` — per-lane IEU and FPU wiring
- `cvw/src/ieu/controller.sv` — cross-lane hazard and forwarding logic
- `cvw/src/fpu/fregfile_widened.sv` — four-write-port f-register file
- `cvw/src/hazard/hazard.sv` — divide-busy stall

## 1. HINT encoding

The bundle marker is a 16-bit RVC `C.LI x0, imm`, detected *before*
decompression (`ifu.sv:346-354`):

```
op_c     == 2'b01
funct3_c == 3'b010
rd_c     == 5'b00000
imm_c    == {instr[12], instr[6:2]}   // 6 bits, must be nonzero
```

Because `rd == x0`, the instruction is architecturally a NOP. A STARBUG binary
therefore runs unmodified on any RV32C core — this is the property that makes
the whole approach ISA-compatible, and it is what lets Spike serve as a
functional reference for STARBUG binaries.

## 2. Bundle length is capped at 4, and it is a bundle, not a window

`ifu.sv:395-396` forms a bundle only when

```
is_vliw_hint && (imm_c >= 1) && (imm_c <= 4)
```

A HINT of 5 or more does **not** produce a wider bundle and does **not**
degrade into a scheduling window: the entire condition fails, `VLIWModeF` stays
low, and every instruction after the hint executes scalar. The hint costs two
bytes and buys nothing.

So the answer to "are HINT values larger than the lane count bundles or
windows?" is neither — they are rejected. The compiler must never emit one, and
the verifier treats `imm_c > 4` as an error rather than a missed opportunity.

## 3. Lane capabilities are asymmetric

Lane 0 is a full IEU. Worker lanes 1-3 are instantiated from the same `ieu`
module but with their memory and control paths disconnected
(`wallypipelinedcore.sv:408-460` and the corresponding lane 2/3 blocks):

- `IEUAdrE` is commented out — no address ever reaches the LSU.
- `PCSrcE` is commented out — a worker lane cannot redirect the PC.
- `MemRWM_1/_2/_3` are declared and driven but **connected to nothing**.

The last point is the dangerous one. A load or store placed in a worker lane
does not trap and does not stall; it is silently dropped, and the destination
register keeps its stale value. There is no hardware check for this.

Consequently the following must appear in lane 0 only:

| Class | Reason |
|---|---|
| load / store / AMO | single LSU, wired to lane 0 |
| branch / jump | `PCSrcE` disconnected on worker lanes |
| CSR, `ecall`, `ebreak`, `fence` | privileged/ordering state is lane 0 only |
| `auipc` and PC-relative setup | every lane is fed the same `PCE`, so a worker lane would compute against the bundle's PC, not its own |

At most **one** memory operation per bundle, and it must be in lane 0.

### 3.1 Floating point is *not* lane 0 only

An earlier version of this file listed floating point as lane-0-only. That was
wrong, and it cost the compiler every DSP kernel: with FP excluded, a FIR or FFT
loop could bundle only its address arithmetic while the `fmadd` chain that
dominates the loop ran scalar.

The RTL instantiates a full FPU per lane. `wallypipelinedcore.sv:772`, `:813`
and `:854` create `fpu_1`, `fpu_2` and `fpu_3` next to the lane IEUs, each fed
from its own decode slice (`InstrD(LaneInstrD1)` and so on). They share
`fregfile_widened` (`:934`), which has four write ports and three read ports per
lane — the FP analogue of the widened integer register file.

FP results that land in an *integer* register also work on a worker lane:
`FIntResM_n`, `FCvtIntResW_n`, `FCvtIntW_n` and `FIntDivResultW_n` are each
routed back into that lane's own `ieu` (`:413`, `:426`, `:429`, `:430` for lane
1). So `fmv.x.w`, `fclass.s` and `fcvt.w.s` are as legal in a worker lane as
`fadd.s`. `SetFflagsM` is ORed across the lanes (`:638`), so accrued exception
flags are not lost either.

Two things remain restricted, and both fall out of rules already stated rather
than out of anything FP-specific:

- **FP loads and stores** (`flw`/`fsw` and the compressed forms) are memory
  operations, so the single-LSU rule applies: lane 0, at most one per bundle.
  The worker FPUs have `ReadDataW` tied to `'0`, which is consistent with this —
  no load data path reaches them.
- **`fdiv` and `fsqrt`** are legal in any lane but are not free. `FDivBusyE` is
  ORed across the lanes into `FDivBusyE_OR` (`:636`) and stalls the execute
  stage core-wide (`hazard.sv:87`). The compiler models them as a separate op
  class (`OpClass::FPUDivSqrt`) so a sweep can exclude them from worker lanes,
  but correctness does not require it.

Integer and floating-point registers are separate architectural files, so the
dependence rules in section 4 apply within each file and never across. Tooling
that conflates them reports false RAW on sequences like `fmv.w.x fa1, zero` /
`addi a4, a1, 16`; `tools/starbug_isa.py` numbers f-registers from `FREG_BASE`
to keep them disjoint.

## 4. Register dependence rules

All lanes read the architectural register file in the same cycle and write back
in the same cycle. The controller's forwarding logic states the assumption
explicitly (`controller.sv:523`):

> Following logic assumes that multiple instructions in STARBUG VLIW bundles
> cannot write to the same register.

Therefore, between any two members of one bundle:

- **RAW is forbidden.** The consumer cannot observe the producer's result; it
  reads the stale value.
- **WAW is forbidden.** Two lanes writing one register in one cycle has no
  defined winner.
- **WAR is safe.** Every lane reads before any lane writes back, so an
  anti-dependence carries no hazard. A packetizer that rejects WAR is leaving
  parallelism on the table for no reason.

There is no interlock for any of this. A violated assumption is a silent wrong
answer, not a fault — which is why `starbug_bundle_check.py` exists and why the
back end re-verifies every packet against the final instruction sequence before
emitting a hint.

### 4.1 The scalar-fallback invariant (constrains reordering)

WAR being safe *inside* a bundle does not make it safe to **reorder** across.

When the fetch unit declines a bundle (section 5) it sets `BundleBytesF = 2`,
skips the two-byte hint and executes the following instructions **scalar, in
memory order** (`ifu.sv:514-521`). A branch landing mid-bundle does the same.
And the entire ISA-compatibility claim is that the binary runs correctly on a
stock RV32C core, which executes it sequentially, always.

So the emitted byte order must be a correct sequential program in its own
right. Any permutation the packetizer performs — including sorting members into
lane order — must therefore be justified by **full** independence: RAW and WAW
(required for parallel issue) *plus* WAR (required once the order changes).

That is why `StarbugVLIWPacketizer` checks full independence before permuting a
packet and abandons the packet in place if the check fails, while the final
hint gate only needs RAW/WAW. Relaxing WAR to win extra bundling would require
also proving the emission order preserves each WAR pair's original order; it is
not a free win.

## 5. Fetch-side constraints (performance, not correctness)

Bundle formation is additionally suppressed when
(`ifu.sv:395`, `ifu.sv:407-510`):

- the fetch is not cacheable, comes from the IROM, or is a spill fetch;
- the bundle's bytes do not all fit in the current I-cache line.

In each case `bundle_ok` goes low and the core executes the same instructions
scalar. These cost performance only. The verifier reports a cache-line straddle
as a warning so that a bundle placed across a line boundary can be recognised
as dead weight rather than mistaken for achieved ILP.

Compressed (16-bit) instructions are supported inside bundles; the extractor
handles mixed 16/32-bit members and computes `BundleBytesF` accordingly.

## 6. Shared resources that limit issue even when a bundle is legal

Independence is necessary but not sufficient for a bundle to issue in one
cycle. The lanes contend for:

- the single **LSU** (structural: enforced as a legality rule above);
- the **MDU** — `MDUActiveE_*` is broadcast between lanes and feeds
  `MDUStallD` (`controller.sv:678-684`), so multiple multiplies in flight can
  stall decode;
- the **writeback** path and the widened register file ports.

The legality rules in sections 3 and 4 make a bundle *safe*. They do not make
it *free*. Cycle-level cost must come from RTL simulation, which is what
`bench/run_bench.py` measures.
