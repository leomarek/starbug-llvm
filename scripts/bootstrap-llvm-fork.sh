#!/usr/bin/env bash
set -euo pipefail

# Bootstraps an LLVM fork checkout and initial build directory.
# Usage:
#   ./scripts/bootstrap-llvm-fork.sh /path/to/llvm-fork

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <llvm-fork-root>"
  exit 1
fi

LLVM_ROOT="$1"

if [[ ! -d "$LLVM_ROOT" ]]; then
  git clone https://github.com/llvm/llvm-project.git "$LLVM_ROOT"
fi

cmake -S "$LLVM_ROOT/llvm" -B "$LLVM_ROOT/build-starbug" -G Ninja \
  -DLLVM_ENABLE_PROJECTS="clang;lld" \
  -DLLVM_TARGETS_TO_BUILD="RISCV" \
  -DCMAKE_BUILD_TYPE=Release

echo "Bootstrap complete. Build with:"
echo "  cmake --build $LLVM_ROOT/build-starbug --target clang llc llvm-mc"
