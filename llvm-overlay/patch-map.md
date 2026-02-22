# Patch Map: Starbug VLIW into LLVM RISCV Backend

## New files to add

Copy from `llvm-overlay/llvm-snippets/` to LLVM fork paths:

- `StarbugVLIWConfig.h` -> `llvm/lib/Target/RISCV/StarbugVLIWConfig.h`
- `StarbugVLIWConfig.cpp` -> `llvm/lib/Target/RISCV/StarbugVLIWConfig.cpp`
- `StarbugVLIWPacketizer.h` -> `llvm/lib/Target/RISCV/StarbugVLIWPacketizer.h`
- `StarbugVLIWPacketizer.cpp` -> `llvm/lib/Target/RISCV/StarbugVLIWPacketizer.cpp`
- `StarbugVLIWInstrInfo.td` -> `llvm/lib/Target/RISCV/StarbugVLIWInstrInfo.td`

## Existing LLVM files to edit

1. `llvm/lib/Target/RISCV/CMakeLists.txt`
- Add new `.cpp` files to target sources.
- Ensure TableGen includes `StarbugVLIWInstrInfo.td`.

2. `llvm/lib/Target/RISCV/RISCVFeatures.td`
- Add `FeatureStarbugVLIW` subtarget feature.

3. `llvm/lib/Target/RISCV/RISCVProcessors.td`
- Add `Proc<"starbug-vliw", ...>` entry.

4. `llvm/lib/Target/RISCV/RISCVSubtarget.{h,cpp}`
- Add feature bit + accessor `hasStarbugVLIW()`.
- Initialize `StarbugVLIWConfig` when feature enabled.

5. `llvm/lib/Target/RISCV/RISCVTargetMachine.cpp`
- Choose custom pass config for Starbug CPU.
- Wire packetizer pass before emit.

6. `llvm/lib/Target/RISCV/RISCVAsmPrinter.cpp`
- Lower pseudo `STARBUG_BUNDLE_HINT` to `c.li x0,<len>`.
- See `StarbugVLIWAsmPrinterSnippet.cpp`.

7. Loop-unroll hooks (target dependent tuning)
- `llvm/lib/Target/RISCV/RISCVTargetTransformInfo.cpp`
- Raise unroll thresholds for `-mcpu=starbug-vliw`.
- Respect `-mllvm -starbug-vliw-*` overrides.

## Suggested lit tests

- `llvm/test/CodeGen/RISCV/starbug-vliw-bundle-hints.ll`
- `llvm/test/CodeGen/RISCV/starbug-vliw-lane-constraints.ll`
- `llvm/test/CodeGen/RISCV/starbug-vliw-unroll-defaults.ll`
