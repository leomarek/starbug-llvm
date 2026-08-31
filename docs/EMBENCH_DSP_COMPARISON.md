# Compiler vs hand-scheduled: the Embench DSP suite

This is the measurement the PACT reviewers asked for and the paper did not have:
the same ten CMSIS-DSP benchmarks, built two ways — by hand and by the compiler
— and run on the same RTL.

Everything here is reproducible from
`cvw/examples/C/embench_starbug`:

```
make scalar-wally vliw-wally starbug-compile   # three binaries per benchmark
make verify                                    # bundle legality, both variants
make questa-vliw-check ARGS='--build-target starbug-compile --configs starbug'
```

## 1. What is being compared

| variant | how the bundles got there | core |
|---|---|---|
| `scalar` | none; plain GCC `-O3` | `rv32gc` (STARBUG_SUPPORTED = 0) |
| `vliw` | hand-inserted hints in `common/vliw_asm/*.S`, seeded from GCC | `starbug` |
| `starbug` | STARBUG clang back end (`-mcpu=starbug-vliw`) | `starbug` |

The two RTL configurations differ in one localparam, so nothing but bundle
formation changes between them.

The DSP kernels are `float32_t` throughout. That turns out to be the whole
story of why the compiler was so far behind, and it is covered in section 3.

## 2. Three defects found in the compiler

### 2.1 Floating point was excluded from the worker lanes

`docs/HARDWARE_CONTRACT.md` used to list floating point as lane-0-only, and the
back end implemented that: every FP opcode fell through `classifyOpClass` to
`OpClass::Any`, which is lane-0-only, so a FIR or FFT loop could bundle its
address arithmetic and nothing else. On a suite whose inner loops are `fmadd`
chains this is close to a total loss.

The claim was wrong. `wallypipelinedcore.sv` instantiates `fpu_1`, `fpu_2` and
`fpu_3` beside the lane IEUs (lines 772, 813, 854), backs them with
`fregfile_widened` (line 934 — four write ports, three read ports per lane), and
routes each lane's FP-to-integer results back into that lane's own IEU. FP
arithmetic is legal in every lane. Only FP *memory* is restricted, and that
follows from the single-LSU rule, not from anything FP-specific.

Classification is now done by register file rather than by opcode list:
if any operand is in `FPR32`/`FPR64`/`FPR16`, the instruction is FP. That covers
F, D and Zfh at once and cannot silently miss an encoding.

### 2.2 Every `DBG_VALUE` ended the packet in flight

`isPacketizableMI` rejects meta instructions, and the packetizer used
`!isPacketizableMI` as its *barrier* test. So under `-g` — which every benchmark
Makefile in this tree uses — each debug instruction flushed the packet.

Building `arm_biquad_cascade_df2T_f32` with and without `-gdwarf-2`:

| | bundled instructions |
|---|---|
| no `-g` | 156 |
| `-gdwarf-2` (before) | 40 |
| `-gdwarf-2` (after) | 144 |

Debug instructions emit no bytes, so a packet whose members straddle one is
still contiguous in the encoded stream. They are now stepped over everywhere:
barrier test, candidate scan, hoist legality, the reorder walk, and the final
safety gate. `-g` no longer costs three quarters of all bundling.

This cost the compiler only. Hand-written assembly carries its hints literally
and never noticed.

### 2.3 Anti-dependences were rejected outright

WAR is safe inside a bundle — every lane reads the register file before any lane
writes back — but the packet builder rejected it along with RAW and WAW, because
the same test also guarded reordering (see HARDWARE_CONTRACT.md §4.1: a
permuted packet must still be a correct sequential program, since the fetch unit
can decline the bundle and run the same bytes in order).

The two concerns are now separate. `hasPacketHazard` covers RAW and WAW and is
always fatal; `hasPacketAntiDependence` covers WAR and is accepted only while
the packet is still exactly the original instruction sequence — the candidate
must be at the head, no earlier member may have been spliced in, and
`flushPacket` then refuses the one permutation it could still perform (hoisting
a lane-0-only member to the front). Ablate with
`-mllvm -starbug-vliw-allow-intra-packet-war=false`.

### Ablation

Bundled instructions per kernel, adding one fix at a time. Left half is built
without `-g` so the FP fix is visible on its own; right half is the real build
(`-gdwarf-2`), where the debug fix is what unlocks the rest.

| kernel | base | +FP | +FP+WAR | | base `-g` | +FP | +FP+dbg | +FP+dbg+WAR |
|---|---|---|---|---|---|---|---|---|
| `arm_biquad_cascade_df2T_f32` | 69 | 155 | 156 | | 40 | 40 | 144 | 144 |
| `arm_fir_f32` | 151 | 163 | 165 | | 71 | 77 | 159 | 161 |
| `arm_cfft_radix8_f32` | 80 | 195 | 237 | | 64 | 100 | 190 | 232 |
| `arm_dct4_f32` | 221 | 233 | 237 | | | | | |

## 3. Two defects found in the hand-scheduled reference

`tools/starbug_bundle_check.py` was run over the hand-written binaries for the
first time. Nothing had ever checked them: the hints in `common/vliw_asm/*.S`
are inserted by hand and `sanitize_vliw_asm.py` only strips comments.

**A branch in a worker lane, on a live path.** In `arm_dct4_f32`:

```
80002 1c2:  c.li  x0,2              <- bundle of 2
80002 1c4:  fsw   fa5,-4(t4)        lane 0
80002 1c8:  beqz  t5,8000224a       lane 1
```

`PCSrcE` is commented out on lanes 1-3 (`wallypipelinedcore.sv:433`), so this
branch cannot redirect the PC. A Spike histogram of `dct4_512_f32` shows the
branch executes once and its target — reachable from nowhere else — also
executes once, so it is *taken* on that one execution. On STARBUG the core
instead falls through into an eight-way-unrolled body with the trip count at
zero. It still reports `TEST PASS` because the overrun misses the checked
output, but it is a silent out-of-bounds read and write on real hardware.

**A RAW pair inside a bundle.** In `arm_bitreversal_16`:

```
lane1: srli a6,t3,0x2
lane2: slli t6,a6,0x1     <- reads a6 in the same cycle it is written
```

Forwarding only reaches back to the M and W stages of any lane
(`controller.sv:516-560`); there is no same-cycle E-to-E path. Lane 2 reads the
stale `a6`. This one is in dead code for these benchmark sizes, so it has never
misbehaved — but nothing was stopping it.

Both are now caught by `make verify`, which has been wired into the benchmark
Makefiles for the hand-scheduled variant as well as the compiled one. Over all
twenty binaries in the suite:

| variant | binaries | with illegal bundles |
|---|---|---|
| hand-scheduled (`*_vliw_wally.elf`) | 10 | 4 (`dct4_512`, `dct4_2048`, `rfft512`, `rfft2048`) |
| compiled (`*_starbug.elf`) | 10 | 0 |

## 4. A verifier bug that hid all of this

The verifier decoded FP registers as integer registers, so `fmv.w.x fa1, zero`
followed by `addi a4, a1, 16` was reported as a RAW hazard on `x11`. It also
inherited the wrong lane rule and flagged every `fmadd` in a worker lane as an
error. Both are fixed: `starbug_isa.py` now numbers f-registers from
`FREG_BASE` so the two files cannot alias, and classifies FP arithmetic as
worker-legal with FP loads and stores falling under the memory rule.

Separately, `starbug_profile.py` ran Spike with a hard-coded `rv32imac_zicsr`.
On an FP binary Spike traps on the first `flw`, spins in the handler, and still
prints a perfectly well-formed histogram — of the trap loop. It now reads the
ISA from the ELF's own `Tag_RISCV_arch` and prints the program's output next to
the profile, so a trap loop cannot masquerade as a profile again.

## 5. Results: RTL cycles

Questa, kernel region only (`CCNT`, read from `mcycle` around the kernel call).
`hand x` and `clang x` are speedups over the GCC scalar build on `rv32gc`;
`ratio` is `clang x / hand x`, i.e. how much of the hand-scheduled speedup the
compiler recovers.

| benchmark | rv32gc | hand | clang | hand x | clang x | ratio |
|---|---|---|---|---|---|---|
| biquad_sos3_n1 | 126 | 136 | 159 | 0.926 | 0.792 | 0.855 |
| biquad_sos3_n128 | 4635 | 3079 | 3279 | 1.505 | 1.414 | 0.939 |
| dct4_512 † | 64849 | 50903 | 55179 | 1.274 | 1.175 | 0.923 |
| dct4_2048 | 304097 | 228987 | 242222 | 1.328 | 1.255 | 0.945 |
| fir_n1 | 3660 | 2123 | 2235 | 1.724 | 1.638 | 0.950 |
| fir_n128 | 233653 | 121898 | 126983 | 1.917 | 1.840 | 0.960 |
| lms_n1 | 5737 | 3619 | 3984 | 1.585 | 1.440 | 0.908 |
| lms_n128 | 497726 | 295351 | 358752 | 1.685 | 1.387 | 0.823 |
| rfft512 | 27739 | 25422 | 23984 | 1.091 | **1.157** | **1.060** |
| rfft2048 | 128281 | 98300 | 94704 | 1.305 | **1.355** | **1.038** |
| **geomean** | | | | **1.404** | **1.316** | **0.938** |

All runs report `TEST PASS` except † — see below.

Note `biquad_sos3_n1`: at 126 cycles the kernel is one sample through three
biquad sections, so the measurement is almost entirely prologue and both
bundled builds are *slower* than scalar. It is in the table for completeness,
not as evidence about bundling.

† **dct4_512 fails its SNR threshold for a reason unrelated to bundling.** The
benchmark requires 118 dB; the STARBUG build reaches 114. Building the same
source with the same clang and *no* `-mcpu=starbug-vliw` at all — no packetizer
in the pipeline — reaches 110. The threshold is calibrated against GCC's
`-ffast-math` contraction, and clang's differs. The cycle count is still a valid
measurement of the same work; the correctness flag is a toolchain artefact.
`dct4_2048`, whose threshold is 100 dB, passes at 109.

## 6. Results: where the issue slots go

RTL cycles fold together bundling, cache behaviour and stalls. This is the
bundling component on its own: Spike executes the hints as NOPs, so a PC
histogram joined with the static bundle map gives an execution-weighted count of
issue slots. Numbers are for the dominant function only — whole-program figures
flatter the compiler, because it bundles the printf and SNR harness that the
hand-written assembly leaves alone.

| benchmark | hot function | hand ILP | clang ILP | hand cov% | clang cov% |
|---|---|---|---|---|---|
| biquad_sos3_n1 | `arm_biquad_cascade_df2T_f32` | 2.537 | 2.074 | 94.0 | 90.0 |
| biquad_sos3_n128 | `arm_biquad_cascade_df2T_f32` | 2.608 | 2.141 | 95.6 | 93.2 |
| dct4_512 | `arm_dct4_f32` | 1.333 | 1.109 | 43.8 | 19.4 |
| dct4_2048 | `arm_dct4_f32` | 1.331 | 1.105 | 43.7 | 18.9 |
| fir_n1 | `arm_fir_f32` | 1.386 | 1.304 | 51.0 | 43.9 |
| fir_n128 | `arm_fir_f32` | 1.560 | 1.423 | 67.8 | 59.0 |
| lms_n1 | `arm_lms_f32` | 1.381 | 1.263 | 47.9 | 40.0 |
| lms_n128 | `arm_lms_f32` | 1.462 | 1.295 | 55.0 | 45.2 |
| rfft2048 | `arm_radix8_butterfly_f32` | 2.616 | 2.330 | 87.3 | 82.4 |
| rfft512 | `arm_radix8_butterfly_f32` | **1.000** | **2.316** | **0.0** | **81.4** |

Before these fixes, the same measurement gave the compiler whole-program ILP of
1.010 on biquad_n1 and 1.029 on biquad_n128, against 1.227 and 1.379 for the
hand-written version. It is now 1.187 and 1.371.

The `rfft512` row is the clearest argument for a compiler.
`arm_radix8_butterfly_f32` has a size-dependent path, and the hand-written hints
only cover the one a 2048-point transform takes; at 512 points the kernel runs
entirely unbundled. The compiler covers both.

That coverage difference is why both rfft sizes are the two benchmarks where the
compiled build beats the hand-scheduled one in RTL. It is not confined to the
butterfly: for `rfft2048` the compiler bundles 51.7% of `arm_bitreversal_32` and
53.9% of `snr_f32`, both of which the hand-written build leaves completely
scalar, and it emits fewer dynamic instructions overall (119k against 143k) for
the same work. Hand scheduling covers the paths its author tuned; the compiler
covers the program.

## 7. What still separates the compiler from hand scheduling

Two structural limits account for essentially all of the remaining 6%.

**Bundles cannot span basic blocks.** In `arm_biquad_cascade_df2T_f32` the hand
version folds the pointer bumps into the FP bundles:

```
c.li x0,3                       c.li zero,3
flw     fa3,0(a1)               fmadd.s ft2,ft1,fa5,ft0
addi    a5,a2,4                 fmadd.s fa0,ft1,fa4,fa0
addi    a1,a1,4                 fmul.s  ft1,ft1,fa3
   (hand: 3-wide, load anchored)   (clang: 3-wide, no load, no bumps)
```

Clang's `addi a1,a1,4` lives in a different basic block — the loop is peeled
into an if-cascade and the pointer updates sit past the branch. The packetizer
is a single-block pass and cannot reach them. This is what costs biquad
2.14 against 2.61.

**No modulo scheduling.** `arm_fir_f32` is LSU-bound: two loads per tap through
one load/store unit sets a floor of two cycles per tap, and the `fa4`
accumulator chain means consecutive `fmadd`s can never share a bundle. The ideal
schedule pairs each load with the previous tap's `fmadd` — software pipelining.
The compiler achieves that across most of the unrolled body and leaves three
unpaired loads per eight taps at the seam, which is the 1.42-vs-1.56 gap. A
modulo scheduler is the fix; unrolling is not (both
`-starbug-vliw-force-unroll` and `-starbug-vliw-enable-machine-pipeliner` change
these kernels by zero instructions — CMSIS unrolls in the source).

A third, smaller one: the compiler will not put a branch in a bundle, while the
hand-written code does — a terminator is a packet barrier. Bundling
`{branch, op, op, op}` is legal on this hardware only when the worker-lane
operations are dead on the taken path, since they commit either way. That needs
post-RA liveness at the branch, which the pass does not currently compute.

## 8. Reproducing

```
cd cvw/examples/C/embench_starbug
make scalar-wally vliw-wally starbug-compile
make verify                                     # bundle legality, both variants
NO_COLOR=1 python3 run_questa_vliw.py --build-target scalar-wally    --configs rv32gc
NO_COLOR=1 python3 run_questa_vliw.py --build-target vliw-wally      --configs starbug
NO_COLOR=1 python3 run_questa_vliw.py --build-target starbug-compile --configs starbug

# execution-weighted profile, per function
python3 ../../../../starbug-llvm/tools/starbug_profile.py --top 5 \
    fir_f32_taps256_n128/fir_f32_taps256_n128_starbug.elf
```

Ablation switches, all defaulting to the correct behaviour:

| flag | off reproduces |
|---|---|
| `-mllvm -starbug-vliw-packetize-fp=false` | FP pinned to lane 0 |
| `-mllvm -starbug-vliw-debug-instrs-transparent=false` | `DBG_VALUE` ends the packet |
| `-mllvm -starbug-vliw-allow-intra-packet-war=false` | WAR rejected with RAW and WAW |
