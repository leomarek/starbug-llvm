#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LLVM_BUILD="${LLVM_BUILD:-$SCRIPT_DIR/../llvm-project/build-starbug-make}"
CLANG="${CLANG:-$LLVM_BUILD/bin/clang}"
OUT_DIR="${OUT_DIR:-$SCRIPT_DIR/build}"

TARGET="${TARGET:-riscv32-unknown-elf}"
ARCH="${ARCH:-rv32imac}"
ABI="${ABI:-ilp32}"
CPU="${CPU:-starbug-vliw}"
OPT_LEVEL="${OPT_LEVEL:--O3}"

STARBUG_FORCE_UNROLL="${STARBUG_FORCE_UNROLL:-true}"
STARBUG_UNROLL_FACTOR="${STARBUG_UNROLL_FACTOR:-32}"
STARBUG_MAX_UNROLL="${STARBUG_MAX_UNROLL:-128}"
STARBUG_EMIT_SINGLE_HINTS="${STARBUG_EMIT_SINGLE_HINTS:-false}"
STARBUG_LANE_OP_CLASSES="${STARBUG_LANE_OP_CLASSES:-}"

if [[ ! -x "$CLANG" ]]; then
  echo "error: clang not found at $CLANG"
  echo "set LLVM_BUILD or CLANG and try again"
  exit 1
fi

mkdir -p "$OUT_DIR"

COMMON_FLAGS=(
  "--target=$TARGET"
  "-march=$ARCH"
  "-mcpu=$CPU"
  "-mabi=$ABI"
  "$OPT_LEVEL"
  "-ffreestanding"
  "-fno-builtin"
  "-Wall"
)

MLLVM_FLAGS=(
  -mllvm "-starbug-vliw-force-unroll=$STARBUG_FORCE_UNROLL"
  -mllvm "-starbug-vliw-unroll-factor=$STARBUG_UNROLL_FACTOR"
  -mllvm "-starbug-vliw-max-unroll=$STARBUG_MAX_UNROLL"
  -mllvm "-starbug-vliw-emit-single-hints=$STARBUG_EMIT_SINGLE_HINTS"
)

if [[ -n "$STARBUG_LANE_OP_CLASSES" ]]; then
  MLLVM_FLAGS+=(-mllvm "-starbug-vliw-lane-op-classes=$STARBUG_LANE_OP_CLASSES")
fi

compile_one() {
  local src="$1"
  local base
  base="$(basename "$src" .c)"

  "$CLANG" "${COMMON_FLAGS[@]}" "${MLLVM_FLAGS[@]}" -S "$src" -o "$OUT_DIR/$base.s"
  "$CLANG" "${COMMON_FLAGS[@]}" "${MLLVM_FLAGS[@]}" -c "$src" -o "$OUT_DIR/$base.o"

  echo "built: $OUT_DIR/$base.s"
  echo "built: $OUT_DIR/$base.o"
}

for src in "$SCRIPT_DIR"/*.c; do
  compile_one "$src"
done

echo "done"
