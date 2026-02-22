# LLVM Toolchain Integration Template

This folder contains Makefile snippets to switch VLIW targets from GCC to clang
built from your LLVM fork.

## Intended migration model

- Keep scalar GCC targets unchanged.
- Switch only VLIW targets to clang with `-mcpu=starbug-vliw`.
- Keep your existing linker scripts and crt/syscalls files.

## Starter include

- `clang-vliw.mk`

Use the variables in that file to replace only these commands for VLIW targets:
- compiler (`CC`/`WALLY_CC` equivalent)
- objdump/size tools
- optional Starbug tuning:
  - `STARBUG_VLIW_MLLVM` for ILP/unroll knobs
  - `STARBUG_VLIW_LANE_OP_CLASSES` for per-lane op support

## Notes

If you depend on GCC sysroot bits, pass:
- `--gcc-toolchain=/opt/homebrew`

until your LLVM runtime/toolchain path is fully standalone.
