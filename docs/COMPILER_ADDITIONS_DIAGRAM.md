# Starbug Compiler Additions Diagram

```mermaid
flowchart TD
  A["C/C++ Source"] --> B["clang Frontend"]
  B --> C["LLVM IR"]
  C --> D["RISCVTargetTransformInfo<br/>Starbug unroll policy"]
  D --> E["Standard RISCV codegen passes"]
  E --> F["StarbugVLIWPacketizer<br/>(post-RA MI pass)"]
  F --> G["Insert STARBUG_BUNDLE_HINT(len)<br/>before bundled ops"]
  G --> H["RISCVAsmPrinter"]
  H --> I["Lower hint pseudo to c.li zero, len"]
  I --> J[".s / .o output"]
  J --> K["Starbug CPU"]
  K --> L["Straight-line execution"]
  K --> M["On hint: issue next bundle across lanes"]

  N["StarbugVLIWConfig<br/>- lanes<br/>- lane op classes<br/>- unroll knobs<br/>- hint policy"] --> D
  N --> F
```

## Main Added Components

- `llvm/lib/Target/RISCV/StarbugVLIWConfig.h`
- `llvm/lib/Target/RISCV/StarbugVLIWConfig.cpp`
- `llvm/lib/Target/RISCV/StarbugVLIWPacketizer.h`
- `llvm/lib/Target/RISCV/StarbugVLIWPacketizer.cpp`
- `llvm/lib/Target/RISCV/StarbugVLIWInstrInfo.td`

## Main Touched Components

- `llvm/lib/Target/RISCV/RISCVTargetTransformInfo.cpp`
- `llvm/lib/Target/RISCV/RISCVTargetMachine.cpp`
- `llvm/lib/Target/RISCV/RISCVAsmPrinter.cpp`
- `llvm/lib/Target/RISCV/RISCVFeatures.td`
- `llvm/lib/Target/RISCV/RISCVProcessors.td`
- `llvm/lib/Target/RISCV/RISCVInstrInfo.td`
