#!/usr/bin/env bash
set -euo pipefail

# Copies scaffold snippets into an LLVM fork RISCV backend directory.
# Usage:
#   ./scripts/apply-overlay.sh /path/to/llvm-project

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <llvm-project-root>"
  exit 1
fi

LLVM_ROOT="$1"
SRC_DIR="$(cd "$(dirname "$0")/.." && pwd)/llvm-overlay/llvm-snippets"
DST_DIR="$LLVM_ROOT/llvm/lib/Target/RISCV"

if [[ ! -d "$DST_DIR" ]]; then
  echo "error: target directory not found: $DST_DIR"
  exit 1
fi

cp "$SRC_DIR/StarbugVLIWConfig.h" "$DST_DIR/StarbugVLIWConfig.h"
cp "$SRC_DIR/StarbugVLIWConfig.cpp" "$DST_DIR/StarbugVLIWConfig.cpp"
cp "$SRC_DIR/StarbugVLIWPacketizer.h" "$DST_DIR/StarbugVLIWPacketizer.h"
cp "$SRC_DIR/StarbugVLIWPacketizer.cpp" "$DST_DIR/StarbugVLIWPacketizer.cpp"
cp "$SRC_DIR/StarbugVLIWInstrInfo.td" "$DST_DIR/StarbugVLIWInstrInfo.td"

echo "Overlay files copied to $DST_DIR"
echo "Next: edit files listed in llvm-overlay/patch-map.md"
