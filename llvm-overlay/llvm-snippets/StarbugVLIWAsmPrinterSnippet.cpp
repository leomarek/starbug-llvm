// Snippet for RISCVAsmPrinter.cpp integration.
// Inside RISCVAsmPrinter::emitInstruction(const MachineInstr *MI)
// add a case for STARBUG_BUNDLE_HINT to print c.li x0,<len>.

if (MI->getOpcode() == RISCV::STARBUG_BUNDLE_HINT) {
  unsigned Len = MI->getOperand(0).getImm();

  MCInst Hint;
  Hint.setOpcode(RISCV::C_LI);
  Hint.addOperand(MCOperand::createReg(RISCV::X0));
  Hint.addOperand(MCOperand::createImm(Len));
  OutStreamer->emitInstruction(Hint, getSubtargetInfo());
  return;
}
