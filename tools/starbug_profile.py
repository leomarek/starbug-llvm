#!/usr/bin/env python3
"""Dynamic (execution-weighted) bundle profile for a STARBUG binary.

Static bundle counts are misleading: one bundle inside a hot inner loop is
worth more than a hundred in setup code. This joins the static bundle map with
a Spike PC histogram so every number below is weighted by how often the code
actually ran.

Spike executes the HINT as a plain NOP, so the histogram it produces is a
faithful record of what the STARBUG core fetches -- with the single caveat that
a bundle straddling an I-cache line is counted here as bundled even though the
fetch unit would decline it. Those are reported separately by
starbug_bundle_check.py.

Reports, for the dynamic instruction stream:
  * how many issue cycles bundling actually removes,
  * per-lane occupancy (how often lanes 1..3 are filled at all),
  * why the un-bundled instructions stayed scalar, by class.

Usage:
    starbug_profile.py ELF [--spike PATH] [--isa STR] [--json OUT]
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

from starbug_bundle_check import (  # noqa: E402
    analyse,
    disassemble,
    find_objdump,
    DEFAULT_ICACHE_LINE_BYTES,
)
from starbug_isa import decode  # noqa: E402

# Tag_RISCV_arch spells out every extension with a version suffix, e.g.
# "rv32i2p1_m2p0_a2p1_f2p2_c2p0_zicsr2p0". Strip the versions and hand the
# result to Spike, so an FP binary is never run under an integer-only ISA
# string. Getting that wrong does not fail loudly: Spike traps on the first
# flw, spins in the handler, and still prints a perfectly well-formed
# histogram -- of the trap loop.
ARCH_TAG = re.compile(r'Tag_RISCV_arch:\s*"([^"]+)"')
FALLBACK_ISA = "rv32imafc_zicsr"

# Spike prints histogram entries as "<hex> <count>", with the PC sign-extended
# to 64 bits and no 0x prefix (e.g. "ffffffff80000210 16"). Accept either form
# and truncate to 32 bits so the keys line up with RV32 ELF addresses.
HIST_LINE = re.compile(r"^(?:0x)?([0-9a-f]+)\s+(\d+)\s*$", re.I)
ADDR_MASK = (1 << 32) - 1


def isa_from_elf(elf, readelf=None):
    """Return the ELF's own ISA string, or None if it cannot be read."""
    tool = readelf or shutil.which("riscv64-unknown-elf-readelf") or \
        shutil.which("llvm-readelf") or shutil.which("readelf")
    if tool is None:
        return None
    try:
        r = subprocess.run([tool, "-A", elf], capture_output=True, text=True,
                           timeout=120)
    except (OSError, subprocess.SubprocessError):
        return None
    m = ARCH_TAG.search(r.stdout)
    if not m:
        return None
    parts = []
    for tok in m.group(1).split("_"):
        # Drop the trailing version, e.g. "m2p0" -> "m", "zicsr2p0" -> "zicsr".
        parts.append(re.sub(r"\d+p\d+$", "", tok))
    # Spike wants the single-letter extensions concatenated onto the base and
    # only the multi-letter ones underscore-separated: rv32imafc_zicsr, not
    # rv32i_m_a_f_c_zicsr.
    base = parts[0]
    single = "".join(t for t in parts[1:] if len(t) == 1)
    multi = [t for t in parts[1:] if len(t) > 1]
    return "_".join([base + single] + multi)


def spike_histogram(elf, spike, isa, memory):
    """Return {pc: execution_count} from a Spike run with -g."""
    cmd = [spike, "-g", f"--isa={isa}", f"-m{memory}", elf]
    r = subprocess.run(cmd, capture_output=True, text=True, timeout=3600)
    text = r.stdout + r.stderr

    # Spike does not reliably delimit the histogram, and program stdout can be
    # interleaved with it, so match entries anywhere and keep only addresses
    # that look like instruction PCs.
    hist = {}
    for line in text.splitlines():
        m = HIST_LINE.match(line.strip())
        if not m:
            continue
        addr = int(m.group(1), 16) & ADDR_MASK
        hist[addr] = hist.get(addr, 0) + int(m.group(2))
    return hist, text


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("elf")
    ap.add_argument("--spike", default=shutil.which("spike") or "spike")
    ap.add_argument("--isa", default=None,
                    help="ISA string for Spike. Default: read from the ELF.")
    ap.add_argument("--memory", default="0x80000000:0x10000000")
    ap.add_argument("--objdump")
    ap.add_argument("--json")
    ap.add_argument("--top", type=int, default=8,
                    help="How many hot functions to break out (default 8).")
    args = ap.parse_args()

    objdump = find_objdump(args.objdump)
    insns = disassemble(args.elf, objdump)
    bundles, _covered = analyse(insns, DEFAULT_ICACHE_LINE_BYTES)

    isa = args.isa or isa_from_elf(args.elf) or FALLBACK_ISA
    hist, raw = spike_histogram(args.elf, args.spike, isa, args.memory)
    if not hist and "bad --isa option" in raw and not args.isa:
        # The ELF named an extension this Spike build does not know. Retry with
        # the base set the STARBUG core implements rather than silently
        # profiling nothing.
        isa = FALLBACK_ISA
        hist, raw = spike_histogram(args.elf, args.spike, isa, args.memory)

    # A histogram is not evidence the program ran. Show whatever the binary
    # printed so a trap loop cannot masquerade as a profile.
    program_output = [ln for ln in raw.splitlines()
                      if not HIST_LINE.match(ln.strip())
                      and not ln.startswith("PC Histogram")]
    if not hist:
        print("error: Spike produced no PC histogram", file=sys.stderr)
        print(raw[-1500:], file=sys.stderr)
        return 2

    # Address -> bundle it belongs to (hint PC keys the execution count).
    bundle_at = {}
    member_addrs = set()
    for b in bundles:
        if not b.safe:
            continue
        bundle_at[b.hint_addr] = b
        for m in b.members:
            member_addrs.add(m.addr)

    dyn_total = 0            # dynamic instructions retired (excl. hints)
    dyn_hints = 0
    dyn_in_bundles = 0
    dyn_bundle_execs = 0
    lane_occupancy = collections.Counter()
    size_weighted = collections.Counter()
    scalar_by_class = collections.Counter()
    # Per-function payload / bundled counts. A suite-wide coverage number hides
    # the only thing that matters -- whether the hot loop is bundled -- so keep
    # the breakdown and print the functions that actually dominate.
    fn_payload = collections.Counter()
    fn_bundled = collections.Counter()
    fn_cycles = collections.Counter()

    decoded = {a: decode(a, w, t) for (a, w, _s, t, _f) in insns}

    for (addr, word, size, text, func) in insns:
        count = hist.get(addr, 0)
        if count == 0:
            continue
        b = bundle_at.get(addr)
        if b is not None:
            dyn_hints += count
            dyn_bundle_execs += count
            size_weighted[len(b.members)] += count
            for lane in range(len(b.members)):
                lane_occupancy[lane] += count
            dyn_in_bundles += count * len(b.members)
            fn_payload[func] += count * len(b.members)
            fn_bundled[func] += count * len(b.members)
            fn_cycles[func] += count
            continue
        if addr in member_addrs:
            # Counted through its bundle above. Spike also retires it, so skip
            # to avoid double counting.
            continue
        # A scalar instruction (or a hint the hardware rejects).
        from starbug_isa import hint_length
        if size == 2 and hint_length(word) is not None:
            dyn_hints += count
            continue
        dyn_total += count
        fn_payload[func] += count
        fn_cycles[func] += count
        scalar_by_class[decoded[addr].cls] += count

    payload = dyn_total + dyn_in_bundles
    issue_cycles = dyn_total + dyn_bundle_execs
    dyn_ilp = (payload / issue_cycles) if issue_cycles else 0.0

    # Fraction of available worker slots actually filled.
    slots_available = dyn_bundle_execs * 4
    slots_filled = dyn_in_bundles
    fill = (100.0 * slots_filled / slots_available) if slots_available else 0.0

    print(f"=== STARBUG dynamic profile: {os.path.basename(args.elf)} ===")
    print(f"  spike --isa={isa}")
    if program_output:
        print("  program output              : " +
              " | ".join(ln.strip() for ln in program_output[:4]))
    print(f"  dynamic payload instructions : {payload}")
    print(f"  ... issued inside bundles    : {dyn_in_bundles} "
          f"({100.0 * dyn_in_bundles / payload if payload else 0:.1f}%)")
    print(f"  ... issued scalar            : {dyn_total}")
    print(f"  hint NOPs retired            : {dyn_hints}")
    print(f"  bundle executions            : {dyn_bundle_execs}")
    print(f"  issue cycles (ideal)         : {issue_cycles}")
    print(f"  dynamic ILP (issue/cycle)    : {dyn_ilp:.3f}")
    print(f"  4-lane slot fill             : {fill:.1f}%")
    print(f"  bundle size mix (dynamic)    : {dict(sorted(size_weighted.items()))}")
    print("  lane occupancy (dynamic)     : " +
          str({f"lane{k}": v for k, v in sorted(lane_occupancy.items())}))
    print("  scalar residue by class      : " +
          str(dict(scalar_by_class.most_common())))

    hot = fn_payload.most_common(args.top)
    if hot:
        print(f"  hottest functions (top {len(hot)}):")
        print(f"    {'function':40} {'payload':>10} {'%prog':>6} "
              f"{'bundled%':>9} {'ILP':>6}")
        for name, pay in hot:
            cyc = fn_cycles[name] or 1
            print(f"    {name[:40]:40} {pay:10d} "
                  f"{100.0 * pay / payload if payload else 0:6.1f} "
                  f"{100.0 * fn_bundled[name] / pay if pay else 0:9.1f} "
                  f"{pay / cyc:6.3f}")

    if args.json:
        with open(args.json, "w") as fh:
            json.dump({
                "elf": args.elf,
                "dynamic_payload": payload,
                "dynamic_in_bundles": dyn_in_bundles,
                "dynamic_scalar": dyn_total,
                "bundle_executions": dyn_bundle_execs,
                "issue_cycles_ideal": issue_cycles,
                "dynamic_ilp": dyn_ilp,
                "slot_fill_pct": fill,
                "bundle_size_mix": dict(size_weighted),
                "lane_occupancy": dict(lane_occupancy),
                "scalar_residue_by_class": dict(scalar_by_class),
                "by_function": {
                    name: {"payload": pay,
                           "bundled": fn_bundled[name],
                           "issue_cycles": fn_cycles[name]}
                    for name, pay in fn_payload.most_common()
                },
            }, fh, indent=2)
    return 0


if __name__ == "__main__":
    sys.exit(main())
