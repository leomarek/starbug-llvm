# Reproduction

Everything needed for an artefact appendix. All numbers in
[`02-results.md`](02-results.md) come from these commands.

## 1. Repositories and commits

| repo | remote | branch | commit |
|---|---|---|---|
| superproject | `github.com/leomarek/starbug-llvm` | `main` | `d343098` |
| LLVM back end | `github.com/leomarek/llvm-project` | `codex/starbug-vliw` | `4a1edc71c7c9` |
| RTL + benchmarks | `github.com/rvru/cvw` ¹ | `lm/fp` | `a3daf96b4` |
| kernel benchmarks | `github.com/leomarek/starbug-benchmarks` | `main` | `56535e3` |

¹ `origin` is configured as `github.com/leomarek/cvw`, which GitHub now
redirects to `rvru/cvw`. The `lm/fp` branch lives on `rvru/cvw`.

### Relevant commits, newest first

**llvm-project (`codex/starbug-vliw`)**
- `4a1edc71c7c9` — I-cache-line-aware bundle layout pass
- `5032bf2e6931` — opcode-based classification; FP/logic/compare/move in worker
  lanes; `DBG_VALUE` transparency; WAR separated from RAW/WAW; unroll retune
- `4ec3fb1fdbfb` — trace scheduling improvements

**cvw (`lm/fp`)**
- `a3daf96b4` — FPGA utilization data
- `4d353231e` — `WALLY-starbug-hint-01` architectural test
- `3bd08637d` — Embench DSP benchmark suite
- `93eb1c3d8` — FP enabled on the worker lanes (RTL)

**starbug-llvm (`main`)**
- `d343098` — submodule bump
- `74e22ea` — bundle verifier, hardware contract, benchmark harness

## 2. Building the compiler

```bash
cd starbug-llvm/llvm-project/build-starbug-make
ninja -j3 clang llc
```

> **`-j3` is required on the development machine** (8 cores / 31 GB RAM).
> Default parallelism is OOM-killed with exit 137. Warm rebuild of `clang` is
> 1–2 minutes at `-j3`.

Configuration: Ninja, Release, **statistics disabled**, no assertions. Note the
consequences — `LLVM_DEBUG` is compiled out and `-stats` reports nothing, which
is why the layout pass carries its own `-starbug-vliw-bundle-layout-verbose`
tracing (levels 1–3) rather than relying on either.

## 3. Building and running the benchmarks

```bash
cd cvw/examples/C/embench_starbug

# three binaries per benchmark: GCC scalar, hand-scheduled VLIW, compiled VLIW
make scalar-wally vliw-wally starbug-compile

# static bundle legality, both bundled variants
make verify

# RTL cycles, one configuration at a time
NO_COLOR=1 python3 run_questa_vliw.py --build-target scalar-wally    --configs rv32gc
NO_COLOR=1 python3 run_questa_vliw.py --build-target vliw-wally      --configs starbug
NO_COLOR=1 python3 run_questa_vliw.py --build-target starbug-compile --configs starbug
```

`run_questa_vliw.py` flags: `--bench` (repeatable), `--configs`,
`--build-target`, `--dry-run`.

> **Logs are overwritten on every run.** Output goes to
> `logs/questa_vliw/<bench>/starbug_compile_starbug.log`. Copy anything you
> need to keep *before* the next run — this is how the SNR values for the
> `-mno-relax` configurations were lost.

### Injecting compiler flags

`STARBUG_EXTRA ?= $(EXTRA)` in `common/bench_common.mk`, so:

```bash
make starbug-compile EXTRA="-mllvm -starbug-vliw-bundle-layout=false"
```

Force a clean rebuild between A/B arms — the object rule does not depend on the
flags:

```bash
rm -rf */.build-starbug */*_starbug.elf
```

## 4. The layout-pass A/B

```bash
cd cvw/examples/C/embench_starbug

# arm A: layout off
rm -rf */.build-starbug */*_starbug.elf
make starbug-compile EXTRA="-mllvm -starbug-vliw-bundle-layout=false"
NO_COLOR=1 python3 run_questa_vliw.py --build-target starbug-compile --configs starbug
#   ... save logs ...

# arm B: layout on (the default)
rm -rf */.build-starbug */*_starbug.elf
make starbug-compile
NO_COLOR=1 python3 run_questa_vliw.py --build-target starbug-compile --configs starbug
```

Benchmarks measured: `fir_f32_taps256_n128`, `biquad_cascade_df2T_f32_sos3_n128`,
`lms_f32_taps256_n128`, `dct4_512_f32`, `rfft512_f32`.

For the `-mno-relax` variant add `-Wl,--no-relax -mno-relax` to
`STARBUG_LINKFLAGS`; it is **not** there by default.

## 5. Verification

### Bundle legality

```bash
python3 starbug-llvm/tools/starbug_bundle_check.py <elf-or-object> \
    --objdump $RISCV/bin/riscv64-unknown-elf-objdump --warnings --max-report 20
```

- **Exit status is nonzero iff an unsafe bundle is found.** Use the exit status,
  not output parsing.
- `--json` takes a **file path argument**, not a bare flag.
- The flag is `--warnings`, not `--verbose`.
- Bundles reported with warnings are I-cache-line straddles — performance, not
  safety. Do not conflate the two counts.

Self-test of the verifier itself (eight bundles whose safety is known by
construction; must flag exactly five):

```bash
./starbug-llvm/tools/test/run_tests.sh
```

### Correctness

SNR values are in the run logs. The two print formats differ:

```bash
grep -hoE "SNR ?= ?-?[0-9]+" <log>
```

`fir` and `lms` print `SNR=%d`; `biquad`, `dct4` and `rfft` print `SNR = %d`. A
pattern that assumes spaces silently misses two benchmarks.

### Execution-weighted profiling

```bash
python3 starbug-llvm/tools/starbug_profile.py --top 5 \
    fir_f32_taps256_n128/fir_f32_taps256_n128_starbug.elf

python3 starbug-llvm/tools/starbug_straddle.py <elf>   # execution-weighted straddle rate
```

`starbug_profile.py` reads the ISA from the ELF's own `Tag_RISCV_arch`. This
matters: it previously hard-coded `rv32imac_zicsr`, and on an FP binary Spike
traps on the first `flw`, spins in the handler, and **still prints a
well-formed histogram — of the trap loop**.

## 6. Ablation flags

All default to the correct behaviour.

| flag | setting it false reproduces |
|---|---|
| `-starbug-vliw-packetize-fp=false` | FP pinned to lane 0 |
| `-starbug-vliw-debug-instrs-transparent=false` | `DBG_VALUE` ends the packet |
| `-starbug-vliw-allow-intra-packet-war=false` | WAR rejected with RAW/WAW |
| `-starbug-vliw-bundle-layout=false` | no I-cache-line awareness |
| `-starbug-vliw-layout-predict-cond-branch=false` | assume `BEQ`/`BNE` are 4 bytes |

Tuning knobs:

| flag | default | note |
|---|---:|---|
| `-starbug-vliw-unroll-factor` | 8 | measured knee; 64 was the old value |
| `-starbug-vliw-max-unroll` | 16 | 512 was the old value |
| `-starbug-vliw-icache-line-bytes` | 64 | must match `P.ICACHE_LINELENINBITS/8` |
| `-starbug-vliw-align-bundled-functions` | true | |
| `-starbug-vliw-bundle-layout-verbose` | 0 | 1 = per bundle, 2 = per instruction, 3 = full MI dump |

All are `-mllvm` options when passed through clang.

## 7. Configurations

| config | `STARBUG_SUPPORTED` | F/D/Q/Zfh/Zfa |
|---|---|---|
| `rv32gc` | 0 | on |
| `starbugi` | 1 | **off** (integer-only STARBUG) |
| `starbug` | 1 | on |

`rv32gc` and `starbug` differ in one localparam, so nothing but bundle formation
changes between them. `starbugi` exists so the FP contribution can be measured
rather than asserted.

## 8. Unit and architectural tests

```bash
# LLVM lit test (llvm-lit cannot self-configure in the partial build —
# llvm-config is not built — so invoke llc and FileCheck directly)
cd starbug-llvm/llvm-project
B=build-starbug-make/bin
$B/llc -mtriple=riscv32 -mcpu=starbug-vliw -mattr=+m,+c \
    < llvm/test/CodeGen/RISCV/starbug-vliw-packetizer.ll | \
    $B/FileCheck llvm/test/CodeGen/RISCV/starbug-vliw-packetizer.ll

# verifier self-test
./starbug-llvm/tools/test/run_tests.sh

# architectural test for the hint (runs against the reference model)
# cvw/tests/wally-riscv-arch-test/.../src/WALLY-starbug-hint-01.S
```

`bin/regression-wally` now defaults to Questa rather than Verilator, because the
STARBUG lane instantiations are not currently Verilator-clean.

## 9. Known environment gotchas

Collected because each one cost time.

- **`ninja -j3`.** Anything more is OOM-killed (exit 137).
- **Questa logs overwrite.** Copy before rerunning.
- **`--json` takes a path**, not a bare flag.
- **`--warnings`**, not `--verbose`.
- **SNR grep must tolerate both spacing formats.**
- **Straddle warnings ≠ unsafe bundles.** Different counts, different meanings.
- **Only the *first* divergence in an offset diff is meaningful.** Once offsets
  drift, every subsequent comparison is against the wrong instruction — an
  early diff script produced 230 bogus "mismatches" this way.
- **Members print before the hint's summary line** in verbose traces; a script
  that assumes the opposite order mis-pairs them.
- **The testbench's objdump/memfile trace helper aborts on `dct4` and `rfft`.**
  Trace-file generation only; cycles and program output are valid.
