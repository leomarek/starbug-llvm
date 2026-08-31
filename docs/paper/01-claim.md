# The claim, and what has to be true for it to hold

## 1. What STARBUG is

A 4-wide VLIW built inside CORE-V Wally, where the bundle is announced by a
**hint that is architecturally a NOP**: the RVC encoding `c.li x0, N`, with
`N` in 1..4 giving the number of instructions that follow in the bundle.

Because the destination is `x0`, a stock RV32C core decodes the hint, writes
nothing, and executes the following instructions one at a time. The same binary
runs on both machines. That is the design's central bet: you get VLIW issue
width without an incompatible ISA, without a fat instruction encoding, and
without a recompile to move between the two.

The bet has a price, and the price is what the paper is about. A conventional
VLIW encodes the bundle in the instruction word, so the bundle is a fact. Here
the bundle is a *request*, and the hardware may decline it — on an I-cache line
straddle, on an uncacheable fetch, on a branch landing mid-bundle. Declining is
always safe, because the fallback is exactly sequential execution of the same
bytes. So:

> **Every bundle the compiler emits must be correct both as a parallel issue
> group and as a sequential instruction stream.**

This single sentence generates most of the compiler's design, and it is the
most interesting thing about the compiler from a paper's point of view. It is
stated formally as §4.1 of [`../HARDWARE_CONTRACT.md`](../HARDWARE_CONTRACT.md).

## 2. Why PACT rejected it

The submitted evaluation used hand-scheduled assembly kernels. The compiler was
described as a work in progress.

The objection is not pedantry. For an ISA extension whose entire value
proposition is "your existing toolchain still works, and a new toolchain can
exploit it," hand-scheduled kernels demonstrate the *upper bound* of the
hardware and say nothing about whether the mechanism is reachable by a
compiler. A reviewer is entitled to suspect that the hint discipline is exactly
the kind of thing only a human can satisfy — and, as it turns out, the
hand-written kernels contained bundles that violate the hardware contract (§2.4
below), which is evidence *for* that suspicion, not against it.

## 3. The argument that answers it

Four claims, in the order a reader needs them.

### 3.1 A compiler can produce these bundles

An LLVM back-end pass produces the hints automatically from ordinary C. On the
five-benchmark A/B set the compiled code reaches **1.40× geomean over scalar**
against hand-scheduled **1.47×** — the compiler recovers **95.6%** of the
hand-scheduled speedup. Details and the full table in
[`02-results.md`](02-results.md).

### 3.2 The compiler covers code a human would not bother with

This is the strongest single result in the set, and it should not be buried.

`arm_radix8_butterfly_f32` has a size-dependent path. The hand-written hints
cover only the path a 2048-point transform takes. At 512 points, the
hand-scheduled kernel runs **entirely unbundled** — bundle coverage 0.0%, ILP
1.000 — while the compiler covers both paths at 81.4% coverage and ILP 2.316.
The compiled build is consequently *faster than the hand-scheduled build* on
both rfft sizes.

The same effect appears away from the hot loop: on `rfft2048` the compiler
bundles 51.7% of `arm_bitreversal_32` and 53.9% of `snr_f32`, both of which the
hand-written build leaves completely scalar.

The framing to use: **hand scheduling covers the paths its author tuned; a
compiler covers the program.** For a design whose selling point is that
existing software keeps working, coverage is the argument, not peak ILP on one
loop.

### 3.3 The mechanism is layout-sensitive, and that is a compiler problem

A bundle is accepted only if the hint and all its members fit in the remaining
bytes of the current 64-byte I-cache line. So whether a bundle exists depends on
where the linker put it. No conventional VLIW compiler has to think about this,
because a conventional VLIW's bundle is in the encoding.

This makes STARBUG a member of a small family — Itanium's 16-byte bundles, TI
C6x's 32-byte fetch packets — where instruction *placement* is part of
scheduling. It is a genuinely novel compiler obligation for a hint-based design,
and a pass that splits straddling bundles at the line boundary is worth
**+1.98% geomean** on its own (up to +4.4% on biquad). See
[`03-compiler.md`](03-compiler.md) §4.

### 3.4 The contract is checkable, and checking it found real bugs

There is no interlock for a malformed bundle. A dependent bundle is a silent
wrong answer; a memory op in a worker lane is silently dropped. So the flow has
a verifier (`tools/starbug_bundle_check.py`) that re-derives every bundle from
the encodings and proves independence and lane legality.

Run over the hand-written kernels for the first time, it found:

- **A branch in a worker lane, on a live path** (`arm_dct4_f32`). Worker lanes
  have `PCSrcE` disconnected, so the branch cannot redirect the PC. A Spike
  histogram shows the branch is taken on its single execution; on real STARBUG
  hardware the core instead falls through into an eight-way-unrolled body with
  trip count zero — a silent out-of-bounds read and write. It reports `TEST
  PASS` only because the overrun misses the checked output.
- **A RAW pair inside a bundle** (`arm_bitreversal_16`): `srli a6,...` in lane 1
  and `slli t6,a6,...` in lane 2. There is no same-cycle E-to-E forwarding path,
  so lane 2 reads the stale value. Dead code at these benchmark sizes, but
  nothing was preventing it.

Over all twenty binaries: **4 of 10 hand-scheduled binaries contain illegal
bundles; 0 of 10 compiled binaries do.**

This inverts the usual framing of a compiler paper. The compiler is not merely
approaching hand-written quality — it is the only one of the two producers that
is *sound*, and the verifier is what makes that a claim rather than an
assertion.

## 4. The one-sentence version

> A bundle hint that is architecturally a NOP makes VLIW issue reachable from a
> stock RISC-V binary, but it moves three obligations onto the compiler —
> dependence under *both* parallel and sequential execution, lane legality with
> no hardware interlock, and I-cache-line placement — and a back end that
> discharges all three recovers 95.6% of hand-scheduled performance while
> covering code paths hand scheduling misses entirely.

## 5. What this argument does *not* establish

Stated here so it is not discovered by a reviewer first; expanded in
[`06-threats.md`](06-threats.md).

- The benchmark suite is five DSP kernels from CMSIS at two sizes. It is the
  workload the design targets, but it is not a general-purpose suite, and no
  claim about general code is supported.
- There is no lockstep/RVVI verification against a reference model. Correctness
  rests on each benchmark's own SNR self-check plus the static bundle verifier.
- `lms_n128` still trails hand scheduling by 17.1%, and the reason (no modulo
  scheduling) is understood but unfixed.
