# Starbug VLIW LLVM Fork Plan

## Scope
This plan implements a custom VLIW RISC-V extension by extending LLVM's existing RISC-V backend in a fork of `llvm-project`.

Goals:
- Maximize ILP by default, accepting code-size growth.
- Emit VLIW bundle length hints as `c.li x0, <bundle_len>`.
- Keep lane count and per-lane op support configurable.
- Preserve compatibility with existing RISC-V ELF flows (linker scripts, crt, objdump, bare-metal).

## Architecture Contract (v1)

- Bundle width: configurable (default `4`).
- Lane 0: accepts any instruction class allowed in packetized region.
- Lanes 1..N-1: constrained by config-defined op classes.
- Bundle marker: inserted as pseudo instruction, lowered to `c.li x0, immediate`.
- If fewer than max issue slots can be filled, emit actual packet length (no mandatory NOP fill by default).

## Configurability Model

Configuration must be data-driven and loaded at target init time:
- `NumLanes` integer.
- Per-lane allowed op-class bitmasks.
- Scheduler weights (load/store latency, pointer-bump priority, reduction priority).
- Unroll policy controls (`DefaultUnrollFactor`, `MaxUnrollFactor`, `ForceUnroll`).

Source of truth:
- `llvm-overlay/config/starbug_vliw_lanes.yaml` for editable configuration.
- C++ config layer (`StarbugVLIWConfig`) maps machine opcodes to abstract op classes.

## LLVM Integration Strategy

Fork base:
- Start from upstream `llvm-project` `main`.
- Keep implementation under RISCV target to maximize code reuse.

Subtarget exposure:
- `-mcpu=starbug-vliw`
- `-mattr=+starbug-vliw`

Target tuning options (via `-mllvm`):
- `-starbug-vliw-force-unroll=[true|false]`
- `-starbug-vliw-unroll-factor=<N>`
- `-starbug-vliw-max-unroll=<N>`
- `-starbug-vliw-lanes=<N>` (debug/override only)
- `-starbug-vliw-lane-op-classes=<spec>` (per-lane op class override)
- `-starbug-vliw-emit-single-hints=[true|false]` (default `false`)
  - format: `lane:class[,class];lane:class[,class]`
  - example: `0:any;1:alu_addsub,alu_muldiv,alu_shift;2:alu;3:alu`

## Pass Pipeline

1. IR-level loop transforms
- Force strong unroll bias in TTI and loop unroll preferences.
- Prefer unroll-and-jam for legal nested loops.

2. MI scheduling and packetization
- Build packets post-RA using dependency DAG and lane constraints.
- Lane selection policy:
  - place unconstrained or hard-to-place ops first (often lane 0),
  - prioritize pointer bumps to free future ALU slots,
  - avoid creating stall-heavy packets.

3. Bundle marker emission
- Emit `STARBUG_BUNDLE_HINT <len>` pseudo before each packet.
- Lower pseudo in MC/AsmPrinter to `c.li x0, <len>`.

## File-Level Worklist in LLVM Fork

Core RISCV backend:
- `llvm/lib/Target/RISCV/RISCV.td`
- `llvm/lib/Target/RISCV/RISCVSubtarget.{h,cpp}`
- `llvm/lib/Target/RISCV/RISCVTargetMachine.{h,cpp}`
- `llvm/lib/Target/RISCV/RISCVSched*.td` (new model additions)

New Starbug components (recommended path under RISCV):
- `llvm/lib/Target/RISCV/StarbugVLIWConfig.{h,cpp}`
- `llvm/lib/Target/RISCV/StarbugVLIWPacketizer.{h,cpp}`
- `llvm/lib/Target/RISCV/StarbugVLIWInstrInfo.td` (pseudo defs)

MC/Asm emission:
- `llvm/lib/Target/RISCV/RISCVAsmPrinter.cpp`
- `llvm/lib/Target/RISCV/MCTargetDesc/RISCVMCCodeEmitter.cpp` (if encoding path needs changes)

Tests:
- `llvm/test/CodeGen/RISCV/starbug-vliw-*.ll`
- `llvm/test/MC/RISCV/starbug-vliw-*.s`

## Aggressive Unroll Policy

Default behavior for `-mcpu=starbug-vliw`:
- Optimize for ILP and throughput over code size.
- Set unroll thresholds high and allow full unroll when compile-time trip count is known and bounded.
- Back off when spill-cost exceeds configurable threshold.

This is intentionally performance-first. Users can opt out with:
- `-mllvm -starbug-vliw-force-unroll=false`
- lower `-starbug-vliw-unroll-factor`.

## Compatibility with Existing Makefiles

Migration pattern:
- Replace `riscv64-unknown-elf-gcc` with clang from LLVM fork build.
- Keep linker and CRT flow unchanged where possible.

Example compiler command shape:

```sh
<llvm-build>/bin/clang --target=riscv32-unknown-elf \
  -mcpu=starbug-vliw -mabi=ilp32 -O3 \
  -mllvm -starbug-vliw-force-unroll=true \
  -mllvm -starbug-vliw-unroll-factor=32 \
  -mllvm -starbug-vliw-max-unroll=128
```

## Delivery Phases

Phase 1: Bring-up
- Subtarget feature flags.
- Config loader with defaults.
- Pseudo for bundle hint and textual asm emission.

Phase 2: Packetizer
- Lane legality checks.
- Packet construction with short packet support.
- Initial scheduling heuristics.

Phase 3: ILP maximization
- Aggressive loop unroll tuning and spill guards.
- Bench validation and regression tests.

Phase 4: Productization
- Better diagnostics (`-Rpass` style remarks).
- Stabilize option surface and docs.

## Success Criteria

- Generated assembly includes valid `c.li x0,<len>` bundle hints.
- No packet violates configured lane legality.
- Loop kernels show throughput gains vs baseline RISC-V scheduling.
- Lane count and lane op-classes can be changed without rewriting packetizer logic.
