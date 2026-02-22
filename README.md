# Starbug Compiler Workspace

Custom LLVM-based compiler workspace for a Starbug VLIW RISC-V extension.

Current design intent:
- maximize ILP and throughput over code size,
- emit bundle hints as `c.li zero, <len>`,
- keep lane count and per-lane op legality configurable.

## Repository Layout

- `llvm-project/` - local LLVM fork with Starbug backend changes under `llvm/lib/Target/RISCV/`.
- `starbug-tests/` - C kernel tests (`dot_product`, `fir_filter`, `matmul`) and compile script.
- `toolchain/` - Makefile include for switching VLIW builds from GCC to clang.
- `docs/` - backend plan and ILP strategy notes.
  - includes `docs/COMPILER_ADDITIONS_DIAGRAM.md` for architecture flow.
- `llvm-overlay/` - overlay/snippets and patch map for replaying Starbug changes.

## Quick Start

1. Compile simple kernels for Starbug:

```bash
cd /Users/leomarek/ZedProjects/starbug_compiler/starbug-tests
./compile_starbug.sh
```

2. Check generated bundle hints:

```bash
rg "c\\.li\\s+zero" /Users/leomarek/ZedProjects/starbug_compiler/starbug-tests/build/*.s
```

3. Use Starbug clang in your own project:

```bash
/Users/leomarek/ZedProjects/starbug_compiler/llvm-project/build-starbug-make/bin/clang \
  --target=riscv32-unknown-elf -march=rv32imac -mcpu=starbug-vliw -mabi=ilp32 -O3 \
  -mllvm -starbug-vliw-force-unroll=true \
  -mllvm -starbug-vliw-unroll-factor=32 \
  -mllvm -starbug-vliw-max-unroll=128 \
  -S input.c -o output.s
```

## High-Impact Starbug Knobs

- `-mllvm -starbug-vliw-unroll-factor=<N>`
- `-mllvm -starbug-vliw-max-unroll=<N>`
- `-mllvm -starbug-vliw-lane-op-classes='0:any;1:alu;2:alu;3:alu'`
- `-mllvm -starbug-vliw-emit-single-hints=false` (default; suppresses `c.li zero, 1`)

## ILP and Hot Trace Strategy

If the objective is larger bundles in hot traces (and code size is not a concern), use the strategy in:

- `docs/HOT_TRACE_ILP_STRATEGIES.md`

That document gives a prioritized implementation roadmap, concrete LLVM hooks to modify, and references.

Top priorities from that roadmap:
- profile-guided trace bias in packetization/scheduling,
- superblock (hot trace) formation with cold compensation paths,
- aggressive loop software pipelining on innermost hot loops,
- aggressive if-conversion to reduce packet flushes at hot branches,
- false-dependence breaking (register renaming) before packetization.
