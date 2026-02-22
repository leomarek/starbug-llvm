#ifndef LLVM_LIB_TARGET_RISCV_STARBUGVLIWPACKETIZER_H
#define LLVM_LIB_TARGET_RISCV_STARBUGVLIWPACKETIZER_H

#include "StarbugVLIWConfig.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/MachineFunctionPass.h"

namespace llvm {

class RISCVSubtarget;

class StarbugVLIWPacketizerPass : public MachineFunctionPass {
public:
  static char ID;

  StarbugVLIWPacketizerPass();
  bool runOnMachineFunction(MachineFunction &MF) override;

private:
  RISCVVLIW::StarbugVLIWConfig Config;

  bool packetizeBasicBlock(MachineBasicBlock &MBB, const RISCVSubtarget &ST);
};

MachineFunctionPass *createStarbugVLIWPacketizerPass();

} // namespace llvm

#endif
