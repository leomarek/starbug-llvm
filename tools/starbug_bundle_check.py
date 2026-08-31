#!/usr/bin/env python3
"""Validate and profile STARBUG VLIW bundles in a linked ELF.

Two jobs:

  1. Safety.  STARBUG hardware trusts the HINT unconditionally: there is no
     interlock that detects a bundle whose members are actually dependent, and
     a memory or control op placed in a worker lane is silently dropped.  This
     checker is the missing backstop.  It re-derives every bundle from the
     instruction encodings and proves the members are mutually independent and
     lane-legal.

  2. Profiling.  Reports bundle-size distribution, per-lane utilisation and
     the reason each un-bundled instruction stayed scalar, so lost ILP can be
     attributed to a cause (dependence / lane legality / LSU conflict).

Usage:
    starbug_bundle_check.py ELF [--objdump PATH] [--json OUT] [--quiet]

Exit status is nonzero if any *unsafe* bundle is found.
"""

import argparse
import collections
import json
import os
import re
import shutil
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from starbug_isa import (  # noqa: E402
    MAX_BUNDLE,
    decode,
    hint_length,
    regname,
)

# Wally's default I-cache line, used to flag bundles the fetch unit will
# reject because they straddle a line (ifu.sv falls back to scalar there).
DEFAULT_ICACHE_LINE_BYTES = 64

OBJDUMP_LINE = re.compile(
    r"^\s*([0-9a-f]+):\s+([0-9a-f]{4}(?:[0-9a-f]{4})?)\s+(.*)$", re.I
)
SYMBOL_LINE = re.compile(r"^([0-9a-f]+)\s+<(.+)>:\s*$", re.I)


class Bundle:
    def __init__(self, hint_addr, declared_len, members):
        self.hint_addr = hint_addr
        self.declared_len = declared_len
        self.members = members
        self.errors = []
        self.warnings = []
        self.func = ""

    @property
    def safe(self):
        return not self.errors


def find_objdump(explicit=None):
    if explicit:
        return explicit
    for name in (
        "riscv64-unknown-elf-objdump",
        "riscv32-unknown-elf-objdump",
        "llvm-objdump",
    ):
        path = shutil.which(name)
        if path:
            return path
    riscv = os.environ.get("RISCV")
    if riscv:
        cand = os.path.join(riscv, "bin", "riscv64-unknown-elf-objdump")
        if os.path.exists(cand):
            return cand
    raise SystemExit("error: no objdump found; pass --objdump")


def disassemble(elf, objdump):
    """Return an address-ordered list of (addr, word, size, text, func)."""
    out = subprocess.run(
        [objdump, "-d", "--no-show-raw-insn" if False else "-z", elf],
        capture_output=True, text=True, check=True,
    ).stdout

    insns = []
    func = ""
    for line in out.splitlines():
        msym = SYMBOL_LINE.match(line.strip())
        if msym:
            func = msym.group(2)
            continue
        m = OBJDUMP_LINE.match(line)
        if not m:
            continue
        addr = int(m.group(1), 16)
        raw = m.group(2)
        text = m.group(3).strip()
        # objdump prints the halfwords of a 32-bit instruction as one
        # little-endian hex blob; length tells us the instruction size.
        word = int(raw, 16)
        size = 2 if len(raw) == 4 else 4
        insns.append((addr, word, size, text, func))
    return insns


def check_bundle(bundle, icache_line_bytes):
    """Populate bundle.errors / bundle.warnings."""
    members = bundle.members
    n = len(members)

    if bundle.declared_len > MAX_BUNDLE:
        # ifu.sv only forms a bundle for 1..4.  Anything larger is silently
        # ignored by hardware: the hint costs 2 bytes and buys nothing.
        bundle.errors.append(
            f"HINT length {bundle.declared_len} exceeds hardware maximum "
            f"{MAX_BUNDLE}; hardware ignores this bundle entirely"
        )
        return

    if n < bundle.declared_len:
        bundle.errors.append(
            f"HINT declares {bundle.declared_len} instructions but only {n} "
            f"could be decoded before end of section"
        )
        return

    # --- lane legality -----------------------------------------------------
    for idx, insn in enumerate(members):
        if idx == 0:
            continue
        if insn.is_lane0_only:
            bundle.errors.append(
                f"lane {idx} holds a {insn.cls} instruction "
                f"({insn.text or hex(insn.word)}) at {insn.addr:#x}; "
                f"worker lanes cannot execute it"
            )

    # --- single shared LSU -------------------------------------------------
    lsu_idx = [i for i, m in enumerate(members) if m.uses_lsu]
    if len(lsu_idx) > 1:
        bundle.errors.append(
            f"{len(lsu_idx)} memory operations in one bundle (lanes {lsu_idx}); "
            f"only one LSU exists"
        )
    elif lsu_idx and lsu_idx[0] != 0:
        bundle.errors.append(
            f"memory operation in lane {lsu_idx[0]}; the LSU is wired to lane 0 only"
        )

    # --- register independence --------------------------------------------
    # All lanes read the architectural register file in the same cycle and
    # write back in the same cycle, so a RAW pair cannot be satisfied and a
    # WAW pair has no defined winner.  Both are hard errors.
    for i in range(n):
        for j in range(i + 1, n):
            a, b = members[i], members[j]
            raw = a.writes & b.reads
            if raw:
                bundle.errors.append(
                    f"RAW dependence on {regname(sorted(raw)[0])} between lane {i} "
                    f"({a.text or hex(a.word)}) and lane {j} "
                    f"({b.text or hex(b.word)})"
                )
            waw = a.writes & b.writes
            if waw:
                bundle.errors.append(
                    f"WAW dependence on {regname(sorted(waw)[0])} between lane {i} "
                    f"({a.text or hex(a.word)}) and lane {j} "
                    f"({b.text or hex(b.word)})"
                )
            war = a.reads & b.writes
            if war:
                # Anti-dependence is architecturally safe here (all lanes read
                # before any lane writes back) but worth surfacing, because a
                # packetizer that forbids it is leaving ILP on the table.
                bundle.warnings.append(
                    f"WAR (anti-dependence) on {regname(sorted(war)[0])} between lane "
                    f"{i} and lane {j}; safe, but check intent"
                )

    # --- fetch-unit constraints -------------------------------------------
    start = bundle.hint_addr
    end = members[-1].addr + members[-1].size - 1
    if start // icache_line_bytes != end // icache_line_bytes:
        bundle.warnings.append(
            f"bundle spans an I-cache line boundary ({start:#x}..{end:#x}); "
            f"hardware will fall back to scalar execution"
        )


def analyse(insns, icache_line_bytes):
    bundles = []
    # Map address -> index for locating bundle members.
    order = list(range(len(insns)))
    idx = 0
    covered = set()

    while idx < len(insns):
        addr, word, size, text, func = insns[idx]
        n = hint_length(word) if size == 2 else None
        if n is None:
            idx += 1
            continue

        members = []
        take = min(n, MAX_BUNDLE) if n <= MAX_BUNDLE else n
        j = idx + 1
        while j < len(insns) and len(members) < take:
            a2, w2, s2, t2, _f = insns[j]
            members.append(decode(a2, w2, t2))
            covered.add(j)
            j += 1

        b = Bundle(addr, n, members)
        b.func = func
        check_bundle(b, icache_line_bytes)
        bundles.append(b)
        covered.add(idx)
        idx = j

    return bundles, covered


def summarise(insns, bundles, covered):
    total_insns = len(insns)
    hint_count = len(bundles)
    bundled_insns = sum(len(b.members) for b in bundles if b.safe)

    sizes = collections.Counter(len(b.members) for b in bundles)
    lane_use = collections.Counter()
    class_by_lane = collections.defaultdict(collections.Counter)
    for b in bundles:
        if not b.safe:
            continue
        for i, m in enumerate(b.members):
            lane_use[i] += 1
            class_by_lane[i][m.cls] += 1

    # Payload instructions = everything that is not a hint.
    payload = total_insns - hint_count
    scalar_insns = payload - bundled_insns

    # Issue slots consumed if every safe bundle issues in one cycle.
    issue_cycles = scalar_insns + sum(1 for b in bundles if b.safe)
    static_ilp = (payload / issue_cycles) if issue_cycles else 0.0

    return {
        "total_instructions": total_insns,
        "hint_instructions": hint_count,
        "payload_instructions": payload,
        "bundled_instructions": bundled_insns,
        "scalar_instructions": scalar_insns,
        "bundle_size_histogram": dict(sorted(sizes.items())),
        "lane_utilisation": {f"lane{k}": v for k, v in sorted(lane_use.items())},
        "lane_class_mix": {
            f"lane{k}": dict(v) for k, v in sorted(class_by_lane.items())
        },
        "bundle_coverage_pct": (100.0 * bundled_insns / payload) if payload else 0.0,
        "static_ilp": static_ilp,
        "unsafe_bundles": sum(1 for b in bundles if not b.safe),
        "bundles_with_warnings": sum(1 for b in bundles if b.warnings),
    }


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("elf")
    ap.add_argument("--objdump")
    ap.add_argument("--json")
    ap.add_argument("--quiet", "-q", action="store_true")
    ap.add_argument("--max-report", type=int, default=20,
                    help="max unsafe bundles to print (default 20)")
    ap.add_argument("--icache-line-bytes", type=int,
                    default=DEFAULT_ICACHE_LINE_BYTES)
    ap.add_argument("--warnings", action="store_true",
                    help="also print non-fatal warnings")
    args = ap.parse_args()

    objdump = find_objdump(args.objdump)
    insns = disassemble(args.elf, objdump)
    bundles, covered = analyse(insns, args.icache_line_bytes)
    stats = summarise(insns, bundles, covered)

    unsafe = [b for b in bundles if not b.safe]

    if not args.quiet:
        name = os.path.basename(args.elf)
        print(f"=== STARBUG bundle report: {name} ===")
        print(f"  instructions           : {stats['total_instructions']}")
        print(f"  HINTs                  : {stats['hint_instructions']}")
        print(f"  instructions in bundles: {stats['bundled_instructions']} "
              f"({stats['bundle_coverage_pct']:.1f}% of payload)")
        print(f"  bundle sizes           : {stats['bundle_size_histogram']}")
        print(f"  lane utilisation       : {stats['lane_utilisation']}")
        print(f"  static ILP (issue/cyc) : {stats['static_ilp']:.3f}")
        print(f"  UNSAFE bundles         : {stats['unsafe_bundles']}")
        print(f"  bundles with warnings  : {stats['bundles_with_warnings']}")

        for b in unsafe[: args.max_report]:
            print(f"\n  !! unsafe bundle at {b.hint_addr:#x} in <{b.func}> "
                  f"(len={b.declared_len})")
            for i, m in enumerate(b.members):
                print(f"       lane{i}: {m.addr:#010x}  {m.text}")
            for e in b.errors:
                print(f"       ERROR: {e}")
        if len(unsafe) > args.max_report:
            print(f"\n  ... {len(unsafe) - args.max_report} more unsafe bundles")

        if args.warnings:
            for b in bundles:
                for w in b.warnings:
                    print(f"  warn @{b.hint_addr:#x}: {w}")

    if args.json:
        with open(args.json, "w") as fh:
            json.dump(
                {
                    "elf": args.elf,
                    "stats": stats,
                    "unsafe": [
                        {
                            "hint_addr": b.hint_addr,
                            "func": b.func,
                            "declared_len": b.declared_len,
                            "errors": b.errors,
                        }
                        for b in unsafe
                    ],
                },
                fh,
                indent=2,
            )

    return 1 if unsafe else 0


if __name__ == "__main__":
    sys.exit(main())
