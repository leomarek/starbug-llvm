#!/usr/bin/env bash
# End-to-end correctness check for the STARBUG compiler.
#
# Rebuilds the reference dot-product benchmark with the STARBUG toolchain and
# checks three independent things:
#
#   1. every emitted bundle is provably safe (static verifier),
#   2. the program computes the same answer as the GCC-built scalar reference
#      when executed scalar on Spike (HINTs decode as NOPs there), and
#   3. it computes that same answer on the STARBUG RTL, where the HINTs
#      actually form bundles.
#
# (2) catches a compiler that reordered code wrongly; (3) catches a bundle that
# is unsafe in a way only parallel issue reveals.
set -uo pipefail

DP="${WALLY:?set WALLY}/examples/C/starbug_benchmarks/dp"
TOOLS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fail=0

echo "=== rebuilding dp_starbug.elf ==="
make -C "$DP" starbug-compile >/dev/null 2>&1 || { echo "BUILD FAILED"; exit 1; }

echo
echo "=== 1. static bundle verification ==="
if python3 "$TOOLS/starbug_bundle_check.py" "$DP/dp_starbug.elf"; then
  echo "  PASS: no unsafe bundles"
else
  echo "  FAIL: unsafe bundles present"; fail=1
fi

echo
echo "=== 2. Spike: STARBUG binary vs GCC scalar reference ==="
ref=$(spike --isa=rv32imac_zicsr -m0x80000000:0x10000000 "$DP/dp_scalar_wally.elf" 2>&1 | md5sum)
got=$(spike --isa=rv32imac_zicsr -m0x80000000:0x10000000 "$DP/dp_starbug.elf"     2>&1 | md5sum)
if [[ "$ref" == "$got" ]]; then
  echo "  PASS: identical output"
else
  echo "  FAIL: output differs from scalar reference"
  echo "    reference: $ref"
  echo "    starbug:   $got"
  fail=1
fi

echo
echo "=== 3. STARBUG RTL: bundles actually execute correctly ==="
# Questa prefixes every line of program output with "# "; strip it before
# comparing, or the hashes can never match regardless of the actual results.
rtl=$("$WALLY/bin/wsim" starbug --elf "$DP/dp_starbug.elf" -s questa 2>&1 \
      | sed -n 's/^# \(output\[.*\)$/\1/p' | md5sum)
spk=$(spike --isa=rv32imac_zicsr -m0x80000000:0x10000000 "$DP/dp_starbug.elf" 2>&1 \
      | sed -n 's/^\(output\[.*\)$/\1/p' | md5sum)
if [[ "$rtl" == "$spk" ]]; then
  echo "  PASS: RTL bundled execution matches scalar semantics"
else
  echo "  FAIL: RTL result differs from scalar execution of the same binary"
  echo "    rtl:   $rtl"
  echo "    spike: $spk"
  fail=1
fi

echo
[[ $fail -eq 0 ]] && echo "=== ALL CORRECTNESS CHECKS PASSED ===" \
                  || echo "=== CORRECTNESS CHECKS FAILED ==="
exit $fail
