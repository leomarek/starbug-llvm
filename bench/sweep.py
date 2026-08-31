#!/usr/bin/env python3
"""Design-space sweep for the STARBUG compiler.

Two axes, answering two different questions.

`--axis unroll` sweeps the loop unroll factor and measures real RTL cycles.
Unrolling is the main lever the compiler has for exposing independent work to
the four lanes, but every unroll step also raises register pressure, and on a
32-register machine the spills it eventually causes are memory operations that
serialise on the single lane-0 LSU. The curve therefore has a knee, and the
sweep locates it rather than assuming it.

`--axis lanes` sweeps the lane count the *compiler* targets. The RTL is fixed
at four lanes, so cycle counts past four are not meaningful and are not
reported; what this measures is how much additional independent work the
compiler could place if lanes were available. It is a compiler-side answer to
"what happens beyond four lanes" -- an upper bound on what widening the machine
could buy, measured before anyone builds it.
"""

import argparse
import json
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import run_bench  # noqa: E402


def build_and_measure(kernel_src, flags, tag, want_cycles):
    outdir = os.path.join(run_bench.BUILD, f"sweep_{tag}")
    elf, err = run_bench.compile_kernel(kernel_src, "starbug", flags, outdir)
    if not elf:
        return {"error": err[-400:]}

    data = run_bench.validate_bundles(elf)
    stats = data.get("stats", {})
    rec = {
        "coverage_pct": stats.get("bundle_coverage_pct", 0.0),
        "static_ilp": stats.get("static_ilp", 0.0),
        "bundle_sizes": stats.get("bundle_size_histogram", {}),
        "unsafe": len(data.get("unsafe", [])),
    }
    if want_cycles:
        sim = run_bench.simulate(elf, "starbug")
        rec["cycles"] = sim.get("cycles")
        rec["instret"] = sim.get("instret")
        rec["checksum"] = sim.get("checksum")
        if "error" in sim:
            rec["sim_error"] = sim["error"]
    return rec


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--axis", choices=["unroll", "lanes"], default="unroll")
    ap.add_argument("--kernels", nargs="*",
                    default=["dot_product", "fir", "bitops", "matmul"])
    ap.add_argument("--values", nargs="*", type=int)
    ap.add_argument("--out")
    args = ap.parse_args()

    if args.values:
        values = args.values
    elif args.axis == "unroll":
        values = [1, 2, 4, 8, 16, 32]
    else:
        values = [2, 3, 4, 6, 8]

    # Cycles are only meaningful where the RTL matches the compiler's model.
    want_cycles = args.axis == "unroll"

    results = {}
    for name in args.kernels:
        src = os.path.join(run_bench.KERNELS, f"{name}.c")
        if not os.path.exists(src):
            print(f"skip {name}: no such kernel")
            continue
        results[name] = {}
        print(f"\n=== {name} : sweeping {args.axis} ===")
        hdr = f"{args.axis:>8s} {'cover%':>8s} {'staticILP':>10s} {'unsafe':>7s}"
        if want_cycles:
            hdr += f" {'cycles':>9s} {'speedup':>8s}"
        print(hdr)

        ref_cycles = None
        for v in values:
            if args.axis == "unroll":
                flags = ["-mllvm", f"-starbug-vliw-unroll-factor={v}",
                         "-mllvm", "-starbug-vliw-force-unroll=true"]
            else:
                flags = ["-mllvm", f"-starbug-vliw-lanes={v}"]
            rec = build_and_measure(src, flags, f"{args.axis}{v}", want_cycles)
            results[name][v] = rec
            if "error" in rec:
                print(f"{v:>8d}  build error: {rec['error'][:60]}")
                continue

            line = (f"{v:>8d} {rec['coverage_pct']:>8.1f} "
                    f"{rec['static_ilp']:>10.3f} {rec['unsafe']:>7d}")
            if want_cycles:
                cyc = rec.get("cycles")
                if ref_cycles is None and cyc:
                    ref_cycles = cyc
                sp = (ref_cycles / cyc) if (cyc and ref_cycles) else None
                line += f" {cyc if cyc else '-':>9}"
                line += f" {(f'{sp:.3f}x' if sp else '-'):>8}"
            print(line)

    out = args.out or os.path.join(HERE, f"sweep_{args.axis}.json")
    with open(out, "w") as fh:
        json.dump(results, fh, indent=2)
    print(f"\nwrote {out}")

    if args.axis == "lanes":
        print("\nNote: cycle counts are omitted for the lane sweep. The RTL has "
              "four lanes;\nvalues above four measure only the additional "
              "independent work the compiler\ncould place, i.e. an upper bound "
              "on what a wider machine could recover.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
