#!/usr/bin/env bash
# Self-test for the STARBUG bundle verifier.
#
# bundles.S contains eight hand-written bundles whose safety is known by
# construction. The verifier is the oracle the whole benchmark flow trusts, so
# it must flag exactly cases 2-6 and pass cases 1, 7 and 8.
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AS="${RISCV:-/rs23/shared/riscv}/bin/riscv64-unknown-elf-as"
OBJDUMP="${RISCV:-/rs23/shared/riscv}/bin/riscv64-unknown-elf-objdump"

"$AS" -march=rv32imac -mabi=ilp32 "$HERE/bundles.S" -o "$HERE/bundles.o" || {
  echo "FAIL: could not assemble test cases"; exit 1; }

out="$(python3 "$HERE/../starbug_bundle_check.py" "$HERE/bundles.o" \
        --objdump "$OBJDUMP" --warnings --max-report 20 2>&1)"

fail=0
check() { # description, pattern
  if grep -qF -- "$2" <<<"$out"; then
    echo "  pass: $1"
  else
    echo "  FAIL: $1 (missing: $2)"; fail=1
  fi
}

echo "=== bundle verifier self-test ==="
check "exactly 5 unsafe bundles detected"      "UNSAFE bundles         : 5"
check "case 2 RAW hazard flagged"              "RAW dependence on x10"
check "case 3 WAW hazard flagged"              "WAW dependence on x10"
check "case 4 load in worker lane flagged"     "worker lanes cannot execute it"
check "case 5 dual memory ops flagged"         "2 memory operations in one bundle"
check "case 6 branch in worker lane flagged"   "lane 1 holds a branch instruction"
check "case 8 WAR allowed (warning only)"      "WAR (anti-dependence) on x11"

if [[ $fail -eq 0 ]]; then
  echo "=== all verifier self-tests passed ==="
else
  echo "=== verifier self-test FAILED ==="
fi
exit $fail
