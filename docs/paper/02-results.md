# Results

Every number in this file is either measured or derived from measured numbers,
and each table says which. **Two vintages exist** and must not be mixed:

- **V1** — before the I-cache-line layout pass. This is what
  [`../EMBENCH_DSP_COMPARISON.md`](../EMBENCH_DSP_COMPARISON.md) §5 reports.
- **V2** — with the layout pass. Measured in a controlled A/B on five
  benchmarks; the other five have **not** been re-measured.

Where a V2 number does not exist, say so rather than assuming the pass is
neutral there.

---

## 1. Headline table (V2, five-benchmark A/B set)

Questa RTL simulation, kernel region only (`mcycle` read around the kernel
call). Same compiler binary throughout; the only thing toggled between the
"layout off" and "layout on" columns is
`-mllvm -starbug-vliw-bundle-layout`.

| benchmark | scalar (rv32gc) | hand | clang, layout off | clang, layout on | hand ×  | clang × | clang/hand |
|---|---:|---:|---:|---:|---:|---:|---:|
| `fir_f32_taps256_n128` | 233,653 | 121,898 | 126,983 | **126,546** | 1.917 | 1.846 | 0.963 |
| `biquad_..._sos3_n128` | 4,635 | 3,079 | 3,279 | **3,134** | 1.505 | 1.479 | 0.982 |
| `lms_f32_taps256_n128` | 497,726 | 295,351 | 358,752 | **345,839** | 1.685 | 1.439 | 0.854 |
| `dct4_512_f32` † | 64,849 | 50,903 | 55,179 | **54,972** | 1.274 | 1.180 | 0.926 |
| `rfft512_f32` | 27,739 | 25,422 | 23,984 | **23,775** | 1.091 | **1.167** | **1.069** |
| **geomean** | | | | | **1.465** | **1.402** | **0.956** |

**The compiler recovers 95.6% of the hand-scheduled speedup**, and beats it on
`rfft512`.

† `dct4_512` fails its SNR threshold in *every* configuration including scalar
clang with no packetizer at all. See §6.

## 2. What the layout pass is worth (V1 → V2)

Same five benchmarks, isolating the pass.

| benchmark | layout off | layout on | gain |
|---|---:|---:|---:|
| `fir_n128` | 126,983 | 126,546 | +0.34% |
| `biquad_n128` | 3,279 | 3,134 | **+4.42%** |
| `lms_n128` | 358,752 | 345,839 | +3.60% |
| `dct4_512` | 55,179 | 54,972 | +0.38% |
| `rfft512` | 23,984 | 23,775 | +0.87% |
| **geomean** | | | **+1.98%** |

### 2.1 Interaction with linker relaxation

Linker relaxation deletes bytes *inside functions after the pass has run*,
invalidating every offset it computed. Building with `-mno-relax` therefore
makes the pass much more effective:

| benchmark | `-mno-relax`, off | `-mno-relax`, on | gain |
|---|---:|---:|---:|
| `fir_n128` | 134,774 | 126,567 | +6.09% |
| `biquad_n128` | 3,213 | 3,115 | +3.05% |
| `lms_n128` | 361,975 | 345,841 | +4.46% |
| `dct4_512` | 54,601 | 54,161 | +0.81% |
| `rfft512` | 24,048 | 23,134 | +3.80% |
| **geomean** | | | **+3.80%** |

**Do not report +3.80% as the pass's value.** `-mno-relax` costs `fir` about 6%
on its own (calls stay as 8-byte `auipc`+`jalr`), so most of that 6.09% is the
pass buying back what the flag spent. Taking the best configuration per
benchmark against the true starting point gives **+2.97% geomean**, which is
the defensible number if you want a single figure that accounts for the flag.

The honest framing for the paper: **+1.98% as shipped; the mechanism is worth
more than that, and recovering the rest requires either running the pass after
relaxation or teaching the linker about bundles.** That is a real finding about
hint-based VLIW — a fact of the *toolchain*, not of the architecture — and it
is the kind of thing a PACT audience finds interesting rather than
embarrassing.

## 3. Full ten-benchmark table (V1 — layout pass NOT included)

From [`../EMBENCH_DSP_COMPARISON.md`](../EMBENCH_DSP_COMPARISON.md) §5. Use
this for suite-wide coverage; use §1 for the headline. Do not average the two.

| benchmark | rv32gc | hand | clang | hand × | clang × | ratio |
|---|---:|---:|---:|---:|---:|---:|
| `biquad_sos3_n1` | 126 | 136 | 159 | 0.926 | 0.792 | 0.855 |
| `biquad_sos3_n128` | 4,635 | 3,079 | 3,279 | 1.505 | 1.414 | 0.939 |
| `dct4_512` † | 64,849 | 50,903 | 55,179 | 1.274 | 1.175 | 0.923 |
| `dct4_2048` | 304,097 | 228,987 | 242,222 | 1.328 | 1.255 | 0.945 |
| `fir_n1` | 3,660 | 2,123 | 2,235 | 1.724 | 1.638 | 0.950 |
| `fir_n128` | 233,653 | 121,898 | 126,983 | 1.917 | 1.840 | 0.960 |
| `lms_n1` | 5,737 | 3,619 | 3,984 | 1.585 | 1.440 | 0.908 |
| `lms_n128` | 497,726 | 295,351 | 358,752 | 1.685 | 1.387 | 0.823 |
| `rfft512` | 27,739 | 25,422 | 23,984 | 1.091 | **1.157** | **1.060** |
| `rfft2048` | 128,281 | 98,300 | 94,704 | 1.305 | **1.355** | **1.038** |
| **geomean** | | | | **1.404** | **1.316** | **0.938** |

`biquad_sos3_n1` at 126 cycles is one sample through three biquad sections —
almost entirely prologue, and *both* bundled builds are slower than scalar. It
belongs in the table for completeness, not as evidence about bundling. Say so
in the caption; a reviewer who spots an unexplained 0.79× will assume the worst.

## 4. Issue-slot accounting (V1)

RTL cycles fold bundling together with cache behaviour and stalls. This
isolates the bundling component: Spike executes hints as NOPs, so a PC histogram
joined with the static bundle map gives execution-weighted issue slots.

**Dominant function only.** Whole-program figures flatter the compiler, because
it bundles the printf and SNR harness that the hand-written assembly leaves
alone. Report the per-function numbers and say why.

| benchmark | hot function | hand ILP | clang ILP | hand cov% | clang cov% |
|---|---|---:|---:|---:|---:|
| `biquad_sos3_n1` | `arm_biquad_cascade_df2T_f32` | 2.537 | 2.074 | 94.0 | 90.0 |
| `biquad_sos3_n128` | `arm_biquad_cascade_df2T_f32` | 2.608 | 2.141 | 95.6 | 93.2 |
| `dct4_512` | `arm_dct4_f32` | 1.333 | 1.109 | 43.8 | 19.4 |
| `dct4_2048` | `arm_dct4_f32` | 1.331 | 1.105 | 43.7 | 18.9 |
| `fir_n1` | `arm_fir_f32` | 1.386 | 1.304 | 51.0 | 43.9 |
| `fir_n128` | `arm_fir_f32` | 1.560 | 1.423 | 67.8 | 59.0 |
| `lms_n1` | `arm_lms_f32` | 1.381 | 1.263 | 47.9 | 40.0 |
| `lms_n128` | `arm_lms_f32` | 1.462 | 1.295 | 55.0 | 45.2 |
| `rfft2048` | `arm_radix8_butterfly_f32` | 2.616 | 2.330 | 87.3 | 82.4 |
| `rfft512` | `arm_radix8_butterfly_f32` | **1.000** | **2.316** | **0.0** | **81.4** |

The `rfft512` row is the coverage argument in one line. See
[`01-claim.md`](01-claim.md) §3.2.

Before the FP/debug/WAR fixes, whole-program compiler ILP was 1.010 on
`biquad_n1` and 1.029 on `biquad_n128`, against 1.227 and 1.379 hand-written.
It is now 1.187 and 1.371.

## 5. Ablation: what each compiler fix was worth

Bundled instructions per kernel, adding one fix at a time. Left half built
without `-g` so the FP fix is visible alone; right half is the real build
(`-gdwarf-2`), where the debug fix unlocks the rest.

| kernel | base | +FP | +FP+WAR | | base `-g` | +FP | +FP+dbg | +FP+dbg+WAR |
|---|---:|---:|---:|---|---:|---:|---:|---:|
| `arm_biquad_cascade_df2T_f32` | 69 | 155 | 156 | | 40 | 40 | 144 | 144 |
| `arm_fir_f32` | 151 | 163 | 165 | | 71 | 77 | 159 | 161 |
| `arm_cfft_radix8_f32` | 80 | 195 | 237 | | 64 | 100 | 190 | 232 |
| `arm_dct4_f32` | 221 | 233 | 237 | | | | | |

The `-g` column is a good story on its own: building with debug info cost
**three quarters of all bundling** (156 → 40 on biquad), because `DBG_VALUE`
was being used as a packet barrier. Debug instructions emit no bytes, so this
was pure loss. Every benchmark Makefile in the tree uses `-gdwarf-2`, so this
was silently costing the real builds — and it cost *only* the compiler, since
hand-written assembly carries its hints literally.

Ablation flags, all defaulting to the correct behaviour:

| flag | setting it false reproduces |
|---|---|
| `-mllvm -starbug-vliw-packetize-fp=false` | FP pinned to lane 0 |
| `-mllvm -starbug-vliw-debug-instrs-transparent=false` | `DBG_VALUE` ends the packet |
| `-mllvm -starbug-vliw-allow-intra-packet-war=false` | WAR rejected along with RAW/WAW |
| `-mllvm -starbug-vliw-bundle-layout=false` | no I-cache-line awareness |

## 6. Correctness verification

Each benchmark computes an SNR against a golden reference and prints PASS/FAIL
against a per-kernel threshold.

| benchmark | threshold | SNR, layout off | SNR, layout on | verdict |
|---|---:|---:|---:|---|
| `fir` | 123 dB | 129 | 129 | PASS both |
| `biquad` | 100 dB | 104 | 104 | PASS both |
| `lms` | 80 dB | 81 | 81 | PASS both |
| `dct4_512` | 118 dB | 114 | 114 | **FAIL both** |
| `rfft512` | 138 dB | 139 | 139 | PASS both |

Also verified for the layout A/B:

- `starbug_bundle_check.py` on all five layout-on ELFs: exit 0, **zero unsafe
  bundles**.
- Hint-stripped disassembly diff between the two builds: 12–30 differing lines
  out of 3.8k–6.3k instructions, and every one is a `%pcrel_lo` immediate in an
  `auipc`+`addi` pair shifted by code movement. No instruction reordered,
  added, or removed apart from hints.

### 6.1 The dct4 failure is pre-existing and not about bundling

Required 118 dB; STARBUG build reaches 114 dB. Building the same source with the
same clang and **no `-mcpu=starbug-vliw` at all** — no packetizer in the
pipeline — reaches 110 dB. The threshold was calibrated against GCC's
`-ffast-math` contraction and clang's differs. `dct4_2048`, threshold 100 dB,
passes at 109 dB.

The cycle count remains a valid measurement of the same work. **Say this in the
paper, in the table caption, before a reviewer finds it.** Better still, fix the
threshold or report dct4 against a clang-calibrated reference.

### 6.2 What is NOT verified

- **No lockstep / RVVI signature verification.** The testbench prints "Single
  Elf file tests are not signature verified." Correctness rests on the SNR
  self-checks plus the static bundle verifier, not on ISA-level equivalence
  against a reference model. This is the single most valuable missing
  experiment — see [`08-open-questions.md`](08-open-questions.md).
- **SNR was not captured for the two `-mno-relax` configurations.** The runner
  reported the same 4-PASS/1-FAIL shape but the logs were overwritten.
- `lms` passes at 81 vs threshold 80 and `rfft` at 139 vs 138 — **1 dB of
  margin**, in every configuration. Independent of this work, but it means the
  thresholds are not much of a safety net.
- The testbench's objdump/memfile trace helper aborts on `dct4` and `rfft`.
  That is trace-file generation only; cycles and program output are unaffected.

## 7. Static bundle legality across the suite

`make verify`, all twenty binaries:

| variant | binaries | with illegal bundles |
|---|---:|---:|
| hand-scheduled (`*_vliw_wally.elf`) | 10 | **4** (`dct4_512`, `dct4_2048`, `rfft512`, `rfft2048`) |
| compiled (`*_starbug.elf`) | 10 | **0** |

The two specific defects are described in [`01-claim.md`](01-claim.md) §3.4.

## 8. Code size

From `presentation_assets/benchmark_summary.csv`. All growth is `.text`;
`.rodata` is byte-identical in every case, which is the expected signature of a
transformation that only inserts 2-byte hints and does not change data.

| benchmark | scalar text | VLIW text | delta |
|---|---:|---:|---:|
| `fir_n128` | 9,968 | 10,548 | +580 B (+5.8%) |
| `lms_n128` | 10,152 | 11,094 | +942 B (+9.3%) |
| `biquad_n128` | 9,886 | 10,150 | +264 B (+2.7%) |
| `dct4_512` | 13,852 | 19,250 | +5,398 B (+39.0%) |
| `rfft512` | 13,380 | 15,946 | +2,566 B (+19.2%) |
| `dct4_2048` | 13,958 | 19,554 | +5,596 B (+40.1%) |
| `rfft2048` | 13,484 | 16,250 | +2,766 B (+20.5%) |

Suite total **+19,898 B**, geomean size ratio **1.057×**.

Note these are the *hand-scheduled* VLIW binaries. The dct4 and rfft rows are
large because those kernels were restructured by hand, not because hints are
expensive — a hint is 2 bytes. If the paper reports code growth for the
compiled binaries, re-measure; do not reuse this table for that claim.

## 9. FPGA area

Vivado post-synthesis, from `cvw/fpga/generator/UTILIZATION*.xlsx`.

| resource | baseline | STARBUG | delta |
|---|---:|---:|---:|
| `wallypipelinedcore` CLB LUTs | 22,271 | 37,695 | **+69.3%** |
| `wallypipelinedcore` CLB registers | 12,419 | 14,001 | +12.7% |
| `regfile_widened` LUTs | 671 | 4,750 | +608% |
| DSPs | 4 | 16 | 4× |
| CARRY8 | 479 | 615 | +28.4% |
| F7 muxes | 1,383 | 2,438 | +76.3% |
| Block RAM | 32.5 | 32.5 | unchanged |
| `wallypipelinedsoc` LUTs | 25,445 | 40,883 | +60.7% |
| `fpgaTop` LUTs | 46,789 | 62,283 | +33.1% |

Clock: 300.12 MHz target (3.332 ns), from `Table.xlsx`.

> **⚠ Verify what the baseline column is before publishing this.** The
> "baseline" spreadsheet already contains a `regfile_widened` instance (671
> LUTs) and 4 DSPs, which a stock single-issue Wally should not have. The most
> likely reading is that `UTILIZATION.xlsx` is the **integer-only STARBUG**
> (the `starbugi` config) and `UTILIZATION_STARBUG.xlsx` is the FP-enabled
> STARBUG — in which case this table measures *the cost of adding FP to the
> worker lanes*, not the cost of STARBUG over stock Wally. Those are very
> different claims and a reviewer will ask. Re-synthesise against an unmodified
> `rv32gc` config before this goes in a paper.

## 10. Numbers you can quote, ranked by strength

1. **95.6%** of hand-scheduled speedup recovered (five-benchmark A/B, V2).
2. **0 of 10** compiled binaries contain illegal bundles vs **4 of 10**
   hand-scheduled.
3. `rfft512`: hand-scheduled coverage **0.0%** vs compiled **81.4%**, and the
   compiled build is **6.9% faster** than hand-scheduled.
4. Debug info was costing **three quarters of all bundling** (156 → 40 bundled
   instructions on biquad).
5. I-cache-line-aware layout: **+1.98% geomean**, +4.4% best case.
6. 1.40× geomean over scalar compiled, 1.47× hand-scheduled.
