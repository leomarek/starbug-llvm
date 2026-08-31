# STARBUG Benchmark and Verification Flow

## Why this exists

The published STARBUG results were produced from hand-scheduled assembly
kernels. That leaves two questions unanswered: whether a compiler can reach the
same bundling density unaided, and whether the bundles a compiler emits are
even *correct*. STARBUG hardware trusts the HINT unconditionally, so a bad
bundle is a silent wrong answer rather than a fault.

This flow answers both. Every binary is verified before it is timed, and every
timing number comes from RTL simulation of the real core.

## Layout

```
bench/
  common/bench.h     timing harness (mcycle/minstret) + checksum reporting
  kernels/*.c        13 kernels: DSP, general-purpose, and negative controls
  run_bench.py       build -> verify -> simulate -> report
tools/
  starbug_isa.py            RV32IMAC decoder (raw encodings, not objdump text)
  starbug_bundle_check.py   bundle safety verifier + static profile
  starbug_profile.py        execution-weighted (dynamic) bundle profile
  test/run_tests.sh         self-test for the verifier
docs/
  HARDWARE_CONTRACT.md      the RTL-derived rules both tools implement
```

## Methodology

Each kernel is measured three ways:

| run | codegen | RTL config | what it tells you |
|---|---|---|---|
| `baseline` | scalar (no `-mcpu=starbug-vliw`) | `starbug_scalar` | reference performance |
| `starbug` | STARBUG (hints emitted) | `starbug` | bundled performance |
| `compat` | STARBUG binary, unchanged | `starbug_scalar` | ISA compatibility, and the honest denominator |

The two RTL configurations differ in exactly one localparam
(`STARBUG_SUPPORTED`); `config/deriv/starbug_scalar/config.vh` is generated
from `config/starbug/config.vh` by flipping that single line, and the flow
asserts nothing else differs.

`compat` is the important column. Comparing `starbug` against `baseline` mixes
two effects: the bundling mechanism and whatever the STARBUG compiler pipeline
did to the schedule. Comparing `starbug` against `compat` holds the instruction
stream *byte-for-byte identical* and varies only whether the fetch unit forms
bundles, which isolates the mechanism itself.

Correctness is enforced two ways:
- the bundle verifier must report zero unsafe bundles, and
- the checksum printed by all three runs must agree.

A kernel with a checksum mismatch or an unsafe bundle is reported `ok=NO` and
its timing is not to be believed.

## Kernels

DSP (the intended sweet spot): `dot_product`, `fir`, `matmul`, `conv2d`, `sad`,
`saxpy`.

General-purpose (the reviewers' stated gap): `crc32`, `sort`, `strops`,
`aes_sbox`, `binsearch`.

Negative controls, included deliberately so the suite cannot flatter the design:
`iir` has a loop-carried dependence that caps ILP regardless of lane count, and
`binsearch` is a serial pointer chase. `bitops` is the opposite extreme: no
memory traffic at all, isolating worker-lane ALU throughput from the
single-LSU bottleneck.

## Running

```bash
source $WALLY/setup.sh
cd bench
./run_bench.py                       # everything
./run_bench.py --kernels fir matmul  # a subset
./run_bench.py --skip-sim            # build + verify only (fast)
```

Verify a single binary by hand:

```bash
python3 tools/starbug_bundle_check.py path/to.elf --warnings
python3 tools/starbug_profile.py      path/to.elf   # needs spike
```

Check the verifier itself still works:

```bash
tools/test/run_tests.sh
```
