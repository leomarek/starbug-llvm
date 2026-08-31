#!/usr/bin/env python3
"""Execution-weighted I-cache-line straddle rate for STARBUG bundles.

ifu.sv forms a bundle only when the hint and every member fit inside the
current I-cache line (`bits_remaining` runs out otherwise and `bundle_ok`
drops). A straddling bundle is therefore not slow -- it does not exist: the
core skips the two-byte hint and runs the same instructions scalar.

Static straddle counts understate or overstate this badly, because one bundle
in an inner loop outweighs a hundred in setup code. This weights every bundle
by how often its hint is actually fetched.

Usage: starbug_straddle.py ELF [--isa STR] [--line-bytes N] [--json OUT]
"""

import argparse
import collections
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from starbug_bundle_check import (  # noqa: E402
    analyse, disassemble, find_objdump, DEFAULT_ICACHE_LINE_BYTES,
)
from starbug_profile import (  # noqa: E402
    isa_from_elf, spike_histogram, FALLBACK_ISA,
)


def straddles(bundle, line_bytes):
    start = bundle.hint_addr
    end = bundle.members[-1].addr + bundle.members[-1].size - 1
    return start // line_bytes != end // line_bytes


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("elf")
    ap.add_argument("--spike")
    ap.add_argument("--isa")
    ap.add_argument("--objdump")
    ap.add_argument("--memory", default="0x80000000:0x10000000")
    ap.add_argument("--line-bytes", type=int, default=DEFAULT_ICACHE_LINE_BYTES)
    ap.add_argument("--json")
    ap.add_argument("--top", type=int, default=6)
    args = ap.parse_args()

    objdump = find_objdump(args.objdump)
    insns = disassemble(args.elf, objdump)
    bundles, _ = analyse(insns, args.line_bytes)

    isa = args.isa or isa_from_elf(args.elf) or FALLBACK_ISA
    hist, raw = spike_histogram(args.elf, args.spike or "spike", isa,
                                args.memory)
    if not hist and "bad --isa option" in raw and not args.isa:
        isa = FALLBACK_ISA
        hist, raw = spike_histogram(args.elf, args.spike or "spike", isa,
                                    args.memory)

    live = dead = 0            # dynamic hint executions
    live_slots = dead_slots = 0  # dynamic payload instructions behind them
    by_func = collections.defaultdict(lambda: [0, 0, 0, 0])
    for b in bundles:
        if not b.safe:
            continue
        n = hist.get(b.hint_addr, 0)
        slots = n * len(b.members)
        rec = by_func[b.func]
        if straddles(b, args.line_bytes):
            dead += n
            dead_slots += slots
            rec[1] += n
            rec[3] += slots
        else:
            live += n
            live_slots += slots
            rec[0] += n
            rec[2] += slots

    tot = live + dead
    tot_slots = live_slots + dead_slots
    print(f"=== dynamic bundle straddle: {os.path.basename(args.elf)} "
          f"(line = {args.line_bytes} B) ===")
    print(f"  bundle executions      : {tot}")
    print(f"  declined (straddle)    : {dead} "
          f"({100.0 * dead / tot if tot else 0:.1f}%)")
    print(f"  payload slots in bundles: {tot_slots}")
    print(f"  slots lost to straddle : {dead_slots} "
          f"({100.0 * dead_slots / tot_slots if tot_slots else 0:.1f}%)")
    # A declined bundle costs the scalar issue of every member plus one cycle
    # for the hint the core still fetches and retires as a NOP.
    print(f"  extra issue cycles     : {dead_slots - dead + dead}"
          f"  (= {dead_slots} scalar issues vs {dead} bundled)")

    rows = sorted(by_func.items(), key=lambda kv: -(kv[1][2] + kv[1][3]))
    print(f"\n  {'function':<40}{'live':>10}{'declined':>10}{'declined%':>11}")
    for fn, (l, d, ls, ds) in rows[:args.top]:
        t = l + d
        print(f"  {fn[:39]:<40}{l:>10}{d:>10}"
              f"{(100.0 * d / t if t else 0):>10.1f}%")

    if args.json:
        json.dump({"elf": args.elf, "line_bytes": args.line_bytes,
                   "bundle_executions": tot, "declined": dead,
                   "slots": tot_slots, "slots_declined": dead_slots,
                   "by_function": {k: {"live": v[0], "declined": v[1],
                                       "live_slots": v[2],
                                       "declined_slots": v[3]}
                                   for k, v in by_func.items()}},
                  open(args.json, "w"), indent=1)


main()
