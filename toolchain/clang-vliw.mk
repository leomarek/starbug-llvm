# Include this file from your project Makefile to build VLIW targets with LLVM.
# Example:
#   include toolchain/clang-vliw.mk
#   VLIW_CC := $(CLANG)

LLVM_BUILD ?= /path/to/llvm-project/build-starbug
CLANG      ?= $(LLVM_BUILD)/bin/clang
LLVM_OBJDUMP ?= $(LLVM_BUILD)/bin/llvm-objdump
LLVM_SIZE    ?= $(LLVM_BUILD)/bin/llvm-size

RISCV_TRIPLE ?= riscv32-unknown-elf
VLIW_CPU     ?= starbug-vliw
VLIW_ABI     ?= ilp32

# ILP-first defaults; tune as needed.
STARBUG_VLIW_MLLVM ?= \
  -mllvm -starbug-vliw-force-unroll=true \
  -mllvm -starbug-vliw-unroll-factor=32 \
  -mllvm -starbug-vliw-max-unroll=128

STARBUG_VLIW_EMIT_SINGLE_HINTS ?= false
STARBUG_VLIW_MLLVM += -mllvm -starbug-vliw-emit-single-hints=$(STARBUG_VLIW_EMIT_SINGLE_HINTS)

# Optional per-lane op-class map:
#   0:any;1:alu_addsub,alu_muldiv,alu_shift;2:...;3:...
STARBUG_VLIW_LANE_OP_CLASSES ?=
ifneq ($(strip $(STARBUG_VLIW_LANE_OP_CLASSES)),)
STARBUG_VLIW_MLLVM += -mllvm -starbug-vliw-lane-op-classes=$(STARBUG_VLIW_LANE_OP_CLASSES)
endif

VLIW_COMMON_FLAGS ?= \
  --target=$(RISCV_TRIPLE) \
  -mcpu=$(VLIW_CPU) \
  -mabi=$(VLIW_ABI) \
  -O3 \
  $(STARBUG_VLIW_MLLVM)

# Semihost-style example
VLIW_CFLAGS ?= $(VLIW_COMMON_FLAGS) -Wall
VLIW_LDFLAGS ?= $(VLIW_COMMON_FLAGS)

# Bare-metal (Wally-like) example
VLIW_WALLY_FLAGS ?= \
  $(VLIW_COMMON_FLAGS) -gdwarf-2 -mcmodel=medany \
  -nostdlib -static
