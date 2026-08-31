# The compiler

LLVM 23 fork, `codex/starbug-vliw` branch of `leomarek/llvm-project`. Target
`riscv32`, `-mcpu=starbug-vliw`. Everything STARBUG-specific lives in
`llvm/lib/Target/RISCV/Starbug*`.

## 1. Where the passes sit, and why

```
  ... normal RISC-V codegen ...
  Register allocation
  ├─ StarbugVLIWTraceScheduler      (pre-RA-ish: forms hot traces)
  ├─ StarbugVLIWPacketizer          (post-RA: builds packets, emits hints)
  ...
  addPreEmitPass2():
    RISCVMakeCompressibleOpt
    BranchRelaxation
    RISCVExpandPseudo
    CFIInstrInserter
    └─ StarbugVLIWBundleLayout      ← LAST. Instruction sizes are final here.
  AsmPrinter (runs RISCVRVC::compress on every instruction)
```

The ordering is the interesting part. **The packetizer must run post-RA**,
because bundle legality is a statement about physical registers — two virtual
registers may or may not collide after allocation, so a pre-RA packetizer would
be either unsound or uselessly conservative.

**The layout pass must run last**, because it needs byte offsets, and byte
offsets do not exist until every pass that can insert or resize an instruction
has finished. Putting it anywhere earlier makes its offsets fiction.

That leaves a residual hazard worth stating in the paper as a limitation:
`RISCVMakeCompressibleOpt`, `BranchRelaxation`, `RISCVMoveMerge` and
`RISCVExpandPseudo` all run *after* the packetizer and could in principle insert
an instruction between a hint and its members. Nothing observed has done so, but
nothing prevents it either. A verifier run on the final binary is the current
mitigation.

## 2. The packetizer

### 2.1 The dependence rules, and why WAR is the subtle one

Between two members of one bundle:

| | inside a bundle | if the emission order changes |
|---|---|---|
| RAW | **forbidden** — consumer reads the stale value; no same-cycle E-to-E forwarding | forbidden |
| WAW | **forbidden** — two lanes writing one register in one cycle has no defined winner | forbidden |
| WAR | **safe** — every lane reads before any lane writes back | **forbidden** |

The last cell is the whole design problem. WAR is harmless for parallel issue,
so a packetizer that rejects it leaves parallelism on the table. But the fetch
unit may decline the bundle and execute the same bytes *sequentially*, and a
stock RV32C core always does — so the emitted byte order has to be a correct
sequential program in its own right.

The resolution: **the two concerns are separated, not merged.**

- `hasPacketHazard` covers RAW and WAW. Always fatal.
- `hasPacketAntiDependence` covers WAR. Accepted only while the packet is still
  exactly the original instruction sequence — the candidate must be at the
  head, no earlier member spliced in — and `flushPacket` then refuses the one
  permutation it could still perform (hoisting a lane-0-only member to the
  front).

Before this, WAR was rejected along with RAW and WAW because a single test
guarded both concerns. This is a nice, small, *explainable* result for a paper:
the naive implementation conflates "can these issue together" with "can these be
reordered", and separating them is worth measurable bundling (see
[`02-results.md`](02-results.md) §5, `arm_cfft_radix8_f32`: 195 → 237).

### 2.2 Lane legality

Lane 0 is a full IEU. Worker lanes 1–3 are the same `ieu` module with paths
disconnected. **Lane 0 only:**

| class | reason |
|---|---|
| load / store / AMO | single LSU, wired to lane 0. `MemRWM_1/_2/_3` are driven but connected to nothing — a memory op in a worker lane is *silently dropped*, not trapped |
| branch / jump | `PCSrcE` disconnected on worker lanes |
| CSR, `ecall`, `ebreak`, `fence` | privileged/ordering state is lane 0 only |
| `auipc`, PC-relative setup | every lane is fed the same `PCE`, so a worker lane computes against the bundle's PC, not its own |

At most **one** memory operation per bundle, in lane 0.

**Floating point is *not* lane-0-only** — this was the single largest compiler
defect. See §3.1.

### 2.3 Classification by opcode, not by name

The original `classifyOpClass` substring-matched instruction names. This failed
in both directions:

- `XOR`, `OR`, `AND`, `SLT` matched no pattern and fell through to
  `OpClass::Any`, which is lane-0-only. **Any kernel built from logic ops was
  pinned to a single lane** — hashing, crypto, bit manipulation, all capped at
  bundles of one.
- `"SH"` matched store-halfword; `"ADD"` matched `AMOADD`. Memory ops classed
  as ALU ops, which is the unsafe direction.

Now classification comes from the opcode and from `mayLoad`/`mayStore`, which
are authoritative because they come from the instruction description. Anything
genuinely unrecognised still lands on `Any` and stays in lane 0 — failing safe.

Worth a sentence in the paper: an op-class table for a VLIW is normally derived
from a scheduling model, and doing it by name is the kind of shortcut that
survives testing on the workload you tried and silently mis-schedules the one
you didn't.

## 3. The three defects, and what each was worth

Full ablation table in [`02-results.md`](02-results.md) §5.

### 3.1 Floating point was excluded from the worker lanes

The hardware contract document *itself* used to list FP as lane-0-only, and the
back end faithfully implemented that. On a suite whose inner loops are `fmadd`
chains, a FIR or FFT loop could bundle its address arithmetic and nothing else.

The claim was simply wrong about the RTL.
`wallypipelinedcore.sv` instantiates `fpu_1`, `fpu_2`, `fpu_3` beside the lane
IEUs (lines 772, 813, 854), backs them with `fregfile_widened` (line 934 — four
write ports, three read ports per lane), and routes each lane's FP-to-integer
results (`FIntResM_n`, `FCvtIntResW_n`, `FIntDivResultW_n`) back into that
lane's own IEU writeback. So `fmv.x.w`, `fclass.s` and `fcvt.w.s` are as legal
in a worker lane as `fadd.s`.

Two things stay restricted, and both follow from rules already stated rather
than anything FP-specific:

- **FP loads and stores** are memory ops → single-LSU rule. The worker FPUs
  have `ReadDataW` tied to `'0`, consistent with this.
- **`fdiv`/`fsqrt`** are legal anywhere but not free: `FDivBusyE` is ORed
  across lanes into a core-wide execute stall (`hazard.sv:87`). They get their
  own op class (`OpClass::FPUDivSqrt`) so a sweep can exclude them, but
  correctness does not require it.

Classification is now by register file — any operand in `FPR32`/`FPR64`/`FPR16`
makes the instruction FP — which covers F, D and Zfh at once and cannot
silently miss an encoding the way an opcode list can.

**Methodological point for the paper:** the documentation was the bug. The
contract file is now derived from the RTL by reading it, and is consumed by both
the back end and the verifier, so the two cannot drift apart silently.

### 3.2 Every `DBG_VALUE` ended the packet in flight

`isPacketizableMI` rejects meta-instructions, and the packetizer used
`!isPacketizableMI` as its **barrier** test. So under `-g` — which every
benchmark Makefile in this tree uses — each debug instruction flushed the packet
being built.

Building `arm_biquad_cascade_df2T_f32`:

| | bundled instructions |
|---|---:|
| no `-g` | 156 |
| `-gdwarf-2`, before | **40** |
| `-gdwarf-2`, after | 144 |

Debug instructions emit no bytes, so a packet whose members straddle one is
still contiguous in the encoded stream. They are now stepped over everywhere:
barrier test, candidate scan, hoist legality, reorder walk, and the final safety
gate.

This cost the compiler only — hand-written assembly carries its hints literally
and never noticed. Which is precisely the kind of asymmetry that makes a
hand-scheduled evaluation misleading about compiler feasibility, and is worth
saying out loud in the paper.

### 3.3 Anti-dependences rejected outright

Covered in §2.1.

## 4. The I-cache-line layout pass

The novel one. `StarbugVLIWBundleLayout.cpp`, ~400 lines.

### 4.1 The problem

`ifu.sv:395–520`, with `P.ICACHE_LINELENINBITS = 512`: a bundle forms only if
the hint **and every member** fit in the remaining bytes of the current 64-byte
I-cache line. Otherwise `bundle_ok = 0`, the hint retires as a NOP, and every
member issues scalar.

So a bundle's existence depends on where the linker put it. The packetizer,
running on machine IR, has no idea. A useful fraction of the bundles it emitted
were dead on arrival.

This is the compiler obligation that has no analogue in a conventional VLIW,
where the bundle is a fact of the encoding. Its closest relatives are Itanium's
16-byte bundles and TI C6x's 32-byte fetch packets — see
[`05-related-work.md`](05-related-work.md).

### 4.2 The transformation: split, don't pad

The pass walks each function tracking byte offsets and **splits** any bundle
that straddles a line boundary into two bundles at the boundary.

Why splitting is obviously safe, and worth stating as such:

- it **never moves an instruction**;
- a subsequence of an independent set is still independent, so both halves
  satisfy the dependence rules the original satisfied;
- program order is preserved, so the scalar-fallback invariant (§2.1) still
  holds;
- the lane-0-only member, if any, stays at index 0 of the first part.

And unlike padding with NOPs, it costs **no code size** — which matters, because
inserting padding would shift everything downstream and require iterating to a
fixpoint.

### 4.3 Two bugs that had to be fixed before offsets meant anything

Both are worth a sentence in the paper as evidence that byte-accurate reasoning
at this stage of a compiler is harder than it looks.

**Member double-counting.** Handling a hint and then `continue`-ing advanced
the iterator by one, so the members were re-walked and their sizes added a
second time. Offsets drifted 6 bytes by the second bundle in a typical function
and everything after was fiction. Fixed by stepping the iterator past the
members explicitly. This is why the first end-to-end measurement showed
essentially no improvement — and it was found by instrumenting the pass to dump
predicted offsets and diffing against `objdump`, since only the *first*
divergence in such a diff is trustworthy.

**`getInstSizeInBytes` is an upper bound, not the emitted size.** It is what
`BranchRelaxation` wants, so it reports the *uncompressed* form for branch
pseudos. But `RISCVAsmPrinter::EmitToStreamer` runs `RISCVRVC::compress` on
every instruction before the streamer, so `PseudoBR` leaves codegen as a 2-byte
`c.j`. Believing the upper bound makes every offset past the first branch two
bytes too large, and the drift accumulates. A `predictedSize()` helper now
models what is actually emitted.

### 4.4 The unresolved part: conditional branch sizes

`C.BEQZ`/`C.BNEZ` exist only for a compare against `x0` with the source in the
8-register C set, **and** only when the target is within ±256 bytes — otherwise
the backend relaxes back to 4 bytes. The pass currently guesses statically
(`-starbug-vliw-layout-predict-cond-branch`, default on).

Neither setting dominates. Straddling bundles remaining:

| | fir | biquad | lms | dct4 | rfft |
|---|---:|---:|---:|---:|---:|
| predict on | 9 | 6 | 15 | 27 | 24 |
| predict off | 5 | 0 | 6 | 45 | 32 |

The correct fix is a fixpoint branch-distance model — compute block offsets
iteratively the way `BranchRelaxation` does, then size each `BEQ`/`BNE` by
whether its target is in range. That should take all five toward zero straddles
under one configuration instead of trading benchmarks against each other.
**This is the highest-value remaining compiler work**; see
[`08-open-questions.md`](08-open-questions.md).

### 4.5 Linker relaxation

Relaxation deletes bytes inside functions *after* the pass runs, invalidating
its offsets. `-mno-relax` roughly doubles the pass's benefit but costs `fir`
~6% on its own. Discussed with numbers in [`02-results.md`](02-results.md) §2.1.

This is a real and quotable finding: **for a layout-sensitive hint architecture,
instruction placement is a whole-toolchain property, and the compiler cannot
own it alone.** Either the pass moves after relaxation, or the linker learns
about bundles.

## 5. A correction worth recording

An earlier analysis predicted straddling bundles cost `fir` ~20% of runtime,
from a 12.7% dynamic bundle-decline rate. Cutting `fir`'s straddles from 16 to 5
bought **0.34%**.

The declined bundles were real, but the wasted issue slots were not on the
critical path — `fir` is limited by something else, most likely FPU and load
latency through the single LSU. The straddle work is worth ~2–3% overall, not
20%.

Keep this in the paper if there is room. A dynamic decline *rate* is not a
performance model, and the gap between the two is exactly the kind of thing
readers of a VLIW paper should be reminded of.

## 6. Unroll factors: less is more

The configuration originally forced unroll factors of 64 with a maximum of 512.

A 4-wide machine with 32 architectural registers needs only enough unrolling to
fill four lanes and cover load latency. Past that it spills — and **every spill
is a memory op that serialises on the single lane-0 LSU**, so over-unrolling
actively fights the mechanism it is meant to feed. The measured knee is 8
(max 16); sweep with `-starbug-vliw-unroll-factor`.

Separately, the aggressive knobs are now gated on a constant trip count, a
simple CFG, and no calls or vector ops. The old unconditional settings produced
**wrong code** on some RV32 runtime-trip loops (observed as bad pointer
materialization).

Also worth noting for honesty: neither `-starbug-vliw-force-unroll` nor
`-starbug-vliw-enable-machine-pipeliner` changes these kernels by a single
instruction, because CMSIS already unrolls in the source.

## 7. What still separates the compiler from hand scheduling

Two structural limits account for essentially all of the remaining gap.

### 7.1 Bundles cannot span basic blocks

The packetizer is a single-block pass. In `arm_biquad_cascade_df2T_f32` the hand
version folds the pointer bumps into the FP bundles:

```
  hand                          clang
  c.li x0,3                     c.li zero,3
  flw     fa3,0(a1)             fmadd.s ft2,ft1,fa5,ft0
  addi    a5,a2,4               fmadd.s fa0,ft1,fa4,fa0
  addi    a1,a1,4               fmul.s  ft1,ft1,fa3
  (3-wide, load anchored)       (3-wide, no load, no bumps)
```

Clang's `addi a1,a1,4` lives in a different basic block — the loop is peeled
into an if-cascade and the pointer updates sit past the branch. This costs
biquad 2.14 ILP against 2.61.

The fix is cross-block speculative hoisting in the Bernstein–Rodeh sense: a
*useful* motion (the instruction executes on all paths) is free; a *speculative*
one needs the target block to dominate; a *duplication-requiring* one needs
compensation code. Trace or superblock formation would supply the scope.

### 7.2 No modulo scheduling

`arm_fir_f32` is LSU-bound: two loads per tap through one LSU sets a floor of
two cycles per tap, and the `fa4` accumulator chain means consecutive `fmadd`s
can never share a bundle. The ideal schedule pairs each load with the *previous*
tap's `fmadd` — software pipelining. The compiler achieves that across most of
the unrolled body and leaves three unpaired loads per eight taps at the seam,
which is the 1.42-vs-1.56 gap.

Iterative modulo scheduling (Rau) is the fix. Unrolling is not.

### 7.3 A third, smaller one: branches are packet barriers

The hand-written code puts branches in bundles; the compiler will not, because a
terminator ends the packet. Bundling `{branch, op, op, op}` is legal on this
hardware **only when the worker-lane operations are dead on the taken path**,
since they commit either way. That needs post-RA liveness at the branch, which
the pass does not compute.

## 8. Diagnosed but not fixed

Ranked, from `StarbugVLIWPacketizer.cpp`:

1. `hasMemoryBaseDefHazard` is redundant with the general dependence test and
   over-restrictive; it rejects packets that are provably fine.
2. The coarse `PacketInProgramOrder` / `PacketHasAntiDep` flags should be
   replaced with an original-program-order index map, so WAR can be accepted
   precisely rather than only while the packet is untouched.
3. Cross-block speculative hoisting (§7.1).
4. Branch bundling with dead-on-taken-path liveness (§7.3).
