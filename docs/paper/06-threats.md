# Threats to validity, written adversarially

Assume the PACT reviewer who rejected the last submission gets it again, is
mildly annoyed, and is looking for a reason. This file is what they will find.
Everything here should be addressed in the paper *before* they raise it —
either fixed, or stated with a reason it does not undermine the claim.

Ordered by how much damage each does.

---

## 1. There is no lockstep verification against a reference model

**Severity: highest.** This is the one that can sink the paper.

The testbench prints *"Single Elf file tests are not signature verified."*
Correctness rests on two things: each benchmark's own SNR self-check, and the
static bundle verifier.

Why a reviewer will care more here than for a normal compiler paper: the
hardware has **no interlock** for a malformed bundle. A dependent bundle is a
silent wrong answer; a memory op in a worker lane is silently dropped. The
paper's own §3 says so. A reviewer will observe that the paper argues the
mechanism is dangerous without a hardware check, then evaluates it without a
software check strong enough to catch what the hardware misses.

An SNR threshold is a weak oracle for this. `lms` passes at 81 dB against a
threshold of 80, and `rfft` at 139 against 138 — **1 dB of margin**. A wrong
bundle that perturbs a few samples could pass.

**Fix:** run RVVI/lockstep against Spike or the ImperasDV reference on the
STARBUG binaries. The hint is architecturally a NOP, so Spike is a valid
reference — this is *stated as a design property in the hardware contract* and
not currently exploited. This is the highest-value experiment remaining and it
should be done before submission.

## 2. `dct4_512` fails its correctness check

**Severity: high, but fully explainable.**

Required 118 dB, achieved 114. A reviewer scanning tables will see a FAIL and
stop reading.

The explanation is solid: building the same source with the same clang and **no
`-mcpu=starbug-vliw` at all** reaches 110 dB. The threshold was calibrated
against GCC's `-ffast-math` contraction; clang's differs. `dct4_2048`, threshold
100 dB, passes at 109.

**Fix:** either recalibrate the threshold against clang and report it, or drop
`dct4_512` from the headline table with a footnote. Do **not** leave a bare FAIL
in a table with the explanation three pages away.

## 3. The benchmark suite is narrow

**Severity: high.**

Five CMSIS-DSP kernels at two sizes. All float32. All from one library, with a
similar loop structure.

Anticipated reviewer question: *does this generalise, or does it work because
DSP inner loops are exactly the shape a 4-wide in-order VLIW likes?*

Honest answers available:

- It is the workload the architecture targets, and the paper should say that
  plainly rather than implying generality.
- The `bench/` directory has 13 additional kernels (sort, crc32, aes_sbox,
  binsearch, strops, bitops, conv2d, sad, ...) that exercise integer, control-
  flow-heavy, and branch-dominated code. **They are not in the evaluation.**
  Running them — even if some show no speedup — would substantially strengthen
  the paper, because "the compiler covers the program" is a coverage claim and
  coverage claims need breadth.
- The opcode-classification fix specifically unblocked logic-op kernels
  (hashing, crypto, bit manipulation) that were previously pinned to lane 0.
  There is a natural experiment here that has not been run.

## 4. `lms_n128` trails hand scheduling by 17%

**Severity: medium.** The single worst row.

The cause is understood — no modulo scheduling, and `lms` has the same
LSU-bound structure as `fir` but a longer dependence chain. But a 17% gap in a
paper claiming the compiler is competitive invites the response *"so it is
competitive on four of five."*

**Options:** (a) implement modulo scheduling — large; (b) report the geomean
prominently and the per-benchmark table honestly, with `lms` explicitly called
out and its cause named; (c) show a hand-annotated `lms` upper bound to
demonstrate the ceiling is a compiler limitation, not an architectural one.

(b) is achievable now. (c) is cheap and would preempt the objection well.

## 5. The FPGA baseline is probably the wrong baseline

**Severity: medium, but it is an accuracy problem, not just a presentation one.**

`UTILIZATION.xlsx` — the "baseline" — already contains a `regfile_widened`
instance (671 LUTs) and 4 DSPs. A stock single-issue Wally has neither. The
likely reading is that the two spreadsheets compare **integer-STARBUG against
FP-STARBUG**, which measures the cost of adding FP to the worker lanes, not the
cost of STARBUG over stock Wally.

Publishing "+69% LUTs for STARBUG" when the number actually means "+69% LUTs
for adding FP to a machine that already has four lanes" is the kind of error
that damages credibility well beyond the one table.

**Fix:** re-synthesise against an unmodified `rv32gc` Wally config. The
`config/starbugi` config exists and makes the three-way comparison
(stock / integer-STARBUG / FP-STARBUG) straightforward, which would be a
*better* table than the current two-way one.

## 6. Speedups are measured against a GCC scalar baseline

**Severity: medium.**

`scalar` is GCC `-O3` on `rv32gc`; the STARBUG builds are clang. Some of the
reported speedup is therefore clang-vs-GCC, not bundling.

The rfft rows make this concrete: the compiled build emits **fewer dynamic
instructions** than the hand-written one (119k vs 143k) for the same work. Some
of that is better bundling; some is just a different compiler.

**Fix:** add a **clang scalar** column — same compiler, `-mcpu` without the
VLIW extension. That isolates bundling from compiler differences and is a
single extra build target. This is cheap and closes a real hole.

## 7. The layout pass is evaluated on five of ten benchmarks

**Severity: low-medium.**

The A/B was run on `fir_n128`, `biquad_n128`, `lms_n128`, `dct4_512`,
`rfft512`. The `_n1` and `_2048` variants were not re-measured. The +1.98%
geomean is over five, while the suite-wide tables are over ten.

**Fix:** run the other five. It is one command and removes an inconsistency a
careful reviewer will notice.

## 8. The `-mno-relax` result is easy to misread

**Severity: low, but self-inflicted if reported carelessly.**

+3.80% geomean with `-mno-relax` looks better than +1.98% without. But
`-mno-relax` costs `fir` ~6% on its own, so most of the larger figure is the
pass buying back what the flag spent.

**Fix:** report +1.98% as the shipped value, present +2.97% (best configuration
per benchmark vs. the true starting point) as the bounded claim, and use
`-mno-relax` only to *explain the mechanism* — that relaxation invalidates
layout — rather than as a headline. Reported that way it is an interesting
finding; reported as a headline it looks like flag-shopping.

## 9. `biquad_sos3_n1` is 0.79× — slower than scalar

**Severity: low if captioned, embarrassing if not.**

126 cycles total: one sample through three biquad sections, almost entirely
prologue. *Both* bundled builds are slower than scalar, including the hand-
scheduled one at 0.926×.

**Fix:** keep it in the table for completeness, caption it, and never let it
appear without the explanation adjacent.

## 10. Passes running after the packetizer could break bundles

**Severity: low in practice, but a reviewer who knows LLVM will ask.**

`RISCVMakeCompressibleOpt`, `BranchRelaxation`, `RISCVMoveMerge` and
`RISCVExpandPseudo` all run after the packetizer and could insert an instruction
between a hint and its members. Nothing observed has, but nothing prevents it.

**Fix:** the honest answer is that the verifier runs on the *final linked
binary*, so any such breakage would be caught. Say that — it converts a design
weakness into a demonstration of why the verifier is part of the architecture,
not an afterthought.

## 11. Bundle-count metrics measure different things in different tables

**Severity: low, but it is the kind of thing that erodes trust.**

The document set contains static bundle counts, execution-weighted ILP,
per-function coverage percentages, whole-program ILP, and RTL cycles. They tell
different and occasionally opposing stories — most notably, the straddle
analysis predicted `fir` would gain ~20% from layout fixes and it gained 0.34%
([`03-compiler.md`](03-compiler.md) §5).

**Fix:** define each metric once, state what it does and does not capture, and
lead with RTL cycles as the ground truth. The 20%-vs-0.34% discrepancy is worth
*including* as a cautionary result — it is a genuine and useful observation that
issue-slot metrics overstate delivered performance on a machine with a single
LSU and long FPU latency.

## 12. Single core configuration, single simulator, single run

**Severity: low.** No cache-size sweep, no frequency effects, one Questa
configuration, and cycle counts are deterministic so there is no variance to
report. Worth one sentence in the methodology so it reads as a choice rather
than an oversight.

---

## Pre-submission checklist

Ranked by (value to the paper) ÷ (effort):

| # | action | effort | value |
|---|---|---|---|
| 1 | Add a **clang scalar** baseline column (§6) | low | high |
| 2 | Run the layout A/B on the remaining five benchmarks (§7) | low | medium |
| 3 | Re-synthesise FPGA area against stock `rv32gc` (§5) | low | high |
| 4 | Recalibrate or footnote the `dct4` threshold (§2) | low | high |
| 5 | Run **RVVI/lockstep against Spike** (§1) | medium | **highest** |
| 6 | Run the 13 `bench/` integer kernels (§3) | medium | high |
| 7 | Hand-annotated `lms` upper bound (§4) | medium | medium |
| 8 | Fixpoint branch-distance model in the layout pass ([`08`](08-open-questions.md)) | medium | medium |
| 9 | Modulo scheduling (§4) | high | high |
