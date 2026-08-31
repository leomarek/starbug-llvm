# STARBUG paper source material

Everything here exists to support one resubmission. PACT 2026 rejected the
STARBUG paper on a single load-bearing objection: the evaluation rested on
hand-scheduled kernels, and the compiler was described in the submission as a
work in progress. A reviewer reading that concludes the architecture has not
been shown to be *compilable*, which for a compiler-visible ISA extension is the
whole claim.

So the resubmission's job is narrow and specific: show that a compiler, not a
person, produces the bundles, and report by how much it still trails a person.

## Reading order

| file | what it is for |
|---|---|
| [`01-claim.md`](01-claim.md) | The thesis, the PACT objection, and the argument that answers it. Read first. |
| [`02-results.md`](02-results.md) | Every measured number, with provenance and confidence. The evaluation section is built from this. |
| [`03-compiler.md`](03-compiler.md) | How the back end works, pass by pass, and why each decision went the way it did. |
| [`04-hardware.md`](04-hardware.md) | The ISA/microarchitecture contract as the compiler sees it. Summarises [`../HARDWARE_CONTRACT.md`](../HARDWARE_CONTRACT.md), which is the authority. |
| [`05-related-work.md`](05-related-work.md) | Positioning against VLIW compilation literature and against layout-aware precedent (Itanium, TI C6x). |
| [`06-threats.md`](06-threats.md) | What a hostile reviewer will attack, and what is genuinely weak. Written adversarially on purpose. |
| [`07-reproduction.md`](07-reproduction.md) | Exact commands, commits, and flags for an artefact appendix. |
| [`08-open-questions.md`](08-open-questions.md) | What is not done, ranked by how much it would improve the submission. |

## Source-of-truth documents these draw on

These are the primary records; the files above summarise and interpret them.

- [`../HARDWARE_CONTRACT.md`](../HARDWARE_CONTRACT.md) — the RTL rules, read out of
  the Verilog rather than inferred. If the RTL changes, this changes first.
- [`../EMBENCH_DSP_COMPARISON.md`](../EMBENCH_DSP_COMPARISON.md) — the
  compiler-vs-hand study, including the defects found on both sides.
- `cvw/examples/C/embench_starbug/presentation_assets/benchmark_summary.csv` —
  raw per-benchmark cycles, sizes, and speedups.

## A standing caution about the numbers

Two of the tables in `../EMBENCH_DSP_COMPARISON.md` predate the I-cache-line
layout pass and therefore report the compiler as slower than it now is.
[`02-results.md`](02-results.md) states which vintage each number belongs to.
Do not mix them in one table.
