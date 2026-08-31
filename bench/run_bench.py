#!/usr/bin/env python3
"""Build, verify and measure the STARBUG benchmark suite.

Methodology
-----------
Every kernel is measured three ways so that the effect of the bundling
mechanism is isolated from the effect of the compiler's scheduling:

  baseline : scalar codegen (no -mcpu=starbug-vliw), run on the scalar core.
  starbug  : STARBUG codegen (hints emitted), run on the STARBUG core.
  compat   : the *same STARBUG binary*, run on the scalar core.

The `compat` run matters twice over. It proves the hinted binary still executes
correctly where the HINTs decode as plain NOPs, and its cycle count is the
honest denominator for "what did bundling actually buy", because it holds the
instruction stream fixed and changes only whether the fetch unit forms bundles.

The two RTL configurations differ in exactly one localparam
(STARBUG_SUPPORTED), so nothing else about the core varies between runs.

Correctness is checked by comparing the checksum printed by each build against
the baseline, and by running the bundle verifier over every STARBUG binary.
"""

import argparse
import concurrent.futures
import json
import os
import re
import shutil
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
TOOLS = os.path.join(os.path.dirname(HERE), "tools")
KERNELS = os.path.join(HERE, "kernels")
BUILD = os.path.join(HERE, "build")

WALLY = os.environ.get("WALLY", "/rs23/lnm7/open_hw/cvw")
RISCV = os.environ.get("RISCV", "/rs23/shared/riscv")
COMMON = os.path.join(WALLY, "examples", "C", "common")
LINKER_SCRIPT = os.path.join(COMMON, "test.ld")

CLANG = os.environ.get(
    "STARBUG_CC",
    "/rs23/lnm7/open_hw/starbug-llvm/llvm-project/build-starbug-make/bin/clang",
)
GCC = os.path.join(RISCV, "bin", "riscv64-unknown-elf-gcc")
OBJDUMP = os.path.join(RISCV, "bin", "riscv64-unknown-elf-objdump")

ARCH = "rv32imac_zicsr"
ABI = "ilp32"

BENCH_RE = re.compile(
    r"STARBUG_BENCH\s+name=(\S+)\s+cycles=(\d+)\s+instret=(\d+)\s+checksum=([0-9a-fA-F]+)"
)


def sh(cmd, **kw):
    return subprocess.run(cmd, capture_output=True, text=True, **kw)


import functools


@functools.lru_cache(maxsize=1)
def sysroot():
    return sh([GCC, "-print-sysroot"]).stdout.strip()


@functools.lru_cache(maxsize=1)
def gcc_include():
    return sh([GCC, "-print-file-name=include"]).stdout.strip()


def compile_kernel(src, variant, backend_flags, outdir):
    """Compile one kernel to an ELF. Returns (elf_path, log) or (None, log)."""
    name = os.path.splitext(os.path.basename(src))[0]
    vdir = os.path.join(outdir, variant)
    os.makedirs(vdir, exist_ok=True)

    kobj = os.path.join(vdir, f"{name}.o")
    crtobj = os.path.join(vdir, "crt.o")
    sysobj = os.path.join(vdir, "syscalls.o")
    elf = os.path.join(vdir, f"{name}.elf")

    common_cc = [
        CLANG, "--target=riscv32-unknown-elf",
        f"-march={ARCH}", f"-mabi={ABI}",
        "-O3", "-mcmodel=medany", "-nostdlib", "-static",
        "-ffreestanding", "-fno-builtin",
        "-isystem", os.path.join(sysroot(), "include"),
        "-isystem", gcc_include(),
        "-I", COMMON,
    ]
    if variant == "starbug":
        common_cc += ["-mcpu=starbug-vliw"] + backend_flags

    log = []
    for cmd in (
        common_cc + ["-c", src, "-o", kobj],
        common_cc + ["-c", os.path.join(COMMON, "crt.S"), "-o", crtobj],
    ):
        r = sh(cmd)
        log.append(" ".join(cmd))
        if r.returncode:
            return None, "\n".join(log + [r.stderr])

    # syscalls.c uses a GCC nested-function extension, so it is always built
    # with GCC and never bundled. It is identical in every variant.
    r = sh([GCC, "-O2", "-mcmodel=medany", "-nostdlib", "-static",
            f"-march={ARCH}", f"-mabi={ABI}", "-I", COMMON,
            "-c", os.path.join(COMMON, "syscalls.c"), "-o", sysobj])
    if r.returncode:
        return None, r.stderr

    r = sh([GCC, f"-march={ARCH}", f"-mabi={ABI}", "-mcmodel=medany",
            "-nostdlib", "-static", f"-T{LINKER_SCRIPT}", "-I", COMMON,
            crtobj, kobj, sysobj, "-lgcc", "-o", elf])
    if r.returncode:
        return None, r.stderr

    return elf, ""


def validate_bundles(elf):
    r = sh([sys.executable, os.path.join(TOOLS, "starbug_bundle_check.py"),
            elf, "--objdump", OBJDUMP, "--quiet",
            "--json", elf + ".bundles.json"])
    try:
        with open(elf + ".bundles.json") as fh:
            data = json.load(fh)
    except (OSError, ValueError):
        return {"error": r.stderr or "bundle check failed"}
    return data


def simulate(elf, config, timeout=1800):
    """Run one ELF on one RTL config; return parsed benchmark record."""
    cmd = [os.path.join(WALLY, "bin", "wsim"), config, "--elf", elf,
           "-s", "questa"]
    env = dict(os.environ)
    env.setdefault("WALLY", WALLY)
    env.setdefault("RISCV", RISCV)
    try:
        r = subprocess.run(cmd, capture_output=True, text=True,
                           timeout=timeout, env=env, cwd=WALLY)
    except subprocess.TimeoutExpired:
        return {"error": "simulation timeout"}

    m = BENCH_RE.search(r.stdout)
    if not m:
        tail = "\n".join(r.stdout.splitlines()[-15:])
        return {"error": "no benchmark line found", "tail": tail}
    return {
        "name": m.group(1),
        "cycles": int(m.group(2)),
        "instret": int(m.group(3)),
        "checksum": m.group(4).lower(),
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--kernels", nargs="*", help="subset of kernel names")
    ap.add_argument("--jobs", "-j", type=int, default=4,
                    help="parallel simulations (Questa licences permitting)")
    ap.add_argument("--out", default=os.path.join(HERE, "results.json"))
    ap.add_argument("--backend-flags", default="",
                    help="extra -mllvm flags, space separated")
    ap.add_argument("--skip-sim", action="store_true",
                    help="build and verify only")
    args = ap.parse_args()

    backend_flags = []
    for tok in args.backend_flags.split():
        backend_flags += ["-mllvm", tok] if not tok.startswith("-mllvm") else [tok]

    srcs = sorted(
        os.path.join(KERNELS, f) for f in os.listdir(KERNELS) if f.endswith(".c")
    )
    if args.kernels:
        want = set(args.kernels)
        srcs = [s for s in srcs
                if os.path.splitext(os.path.basename(s))[0] in want]
    if not srcs:
        sys.exit("no kernels selected")

    os.makedirs(BUILD, exist_ok=True)
    results = {}

    # ---- build -----------------------------------------------------------
    print("=== building ===")
    for src in srcs:
        name = os.path.splitext(os.path.basename(src))[0]
        entry = {"kernel": name}
        for variant in ("baseline", "starbug"):
            elf, err = compile_kernel(src, variant, backend_flags, BUILD)
            if not elf:
                entry[variant] = {"error": err[-2000:]}
                print(f"  {name:12s} {variant:9s} BUILD FAILED")
                continue
            entry[variant] = {"elf": elf}
            print(f"  {name:12s} {variant:9s} ok")
        results[name] = entry

    # ---- verify bundles --------------------------------------------------
    print("\n=== verifying bundles ===")
    unsafe_total = 0
    for name, entry in results.items():
        sb = entry.get("starbug", {})
        if "elf" not in sb:
            continue
        data = validate_bundles(sb["elf"])
        sb["bundles"] = data.get("stats", {})
        sb["unsafe"] = data.get("unsafe", [])
        n_unsafe = len(sb["unsafe"])
        unsafe_total += n_unsafe
        st = sb["bundles"]
        print(f"  {name:12s} hints={st.get('hint_instructions', 0):5d} "
              f"cover={st.get('bundle_coverage_pct', 0):5.1f}% "
              f"staticILP={st.get('static_ilp', 0):.3f} "
              f"UNSAFE={n_unsafe}")

    if unsafe_total:
        print(f"\n  *** {unsafe_total} UNSAFE BUNDLES -- results are not trustworthy ***")

    if args.skip_sim:
        with open(args.out, "w") as fh:
            json.dump(results, fh, indent=2)
        return 1 if unsafe_total else 0

    # ---- simulate --------------------------------------------------------
    print("\n=== simulating ===")
    jobs = []
    for name, entry in results.items():
        if "elf" in entry.get("baseline", {}):
            jobs.append((name, "baseline", entry["baseline"]["elf"], "starbug_scalar"))
        if "elf" in entry.get("starbug", {}):
            jobs.append((name, "starbug", entry["starbug"]["elf"], "starbug"))
            jobs.append((name, "compat", entry["starbug"]["elf"], "starbug_scalar"))

    with concurrent.futures.ThreadPoolExecutor(max_workers=args.jobs) as ex:
        futs = {ex.submit(simulate, elf, cfg): (n, run)
                for (n, run, elf, cfg) in jobs}
        for fut in concurrent.futures.as_completed(futs):
            name, run = futs[fut]
            rec = fut.result()
            results[name].setdefault("runs", {})[run] = rec
            status = rec.get("error", f"{rec.get('cycles')} cycles")
            print(f"  {name:12s} {run:9s} {status}")

    # ---- report ----------------------------------------------------------
    print("\n=== results ===")
    hdr = (f"{'kernel':14s} {'base_cyc':>10s} {'sb_cyc':>10s} {'compat':>10s} "
           f"{'speedup':>8s} {'vs_compat':>9s} {'cover%':>7s} {'ok':>4s}")
    print(hdr)
    print("-" * len(hdr))
    speedups = []
    for name, entry in sorted(results.items()):
        runs = entry.get("runs", {})
        base = runs.get("baseline", {})
        sb = runs.get("starbug", {})
        cm = runs.get("compat", {})
        bc, sc, cc = base.get("cycles"), sb.get("cycles"), cm.get("cycles")

        checks = [r.get("checksum") for r in (base, sb, cm) if r.get("checksum")]
        ok = "yes" if checks and len(set(checks)) == 1 else "NO"
        if entry.get("starbug", {}).get("unsafe"):
            ok = "NO"

        sp = (bc / sc) if (bc and sc) else None
        vc = (cc / sc) if (cc and sc) else None
        if sp:
            speedups.append(sp)
        cover = entry.get("starbug", {}).get("bundles", {}).get("bundle_coverage_pct", 0)
        print(f"{name:14s} {bc if bc else '-':>10} {sc if sc else '-':>10} "
              f"{cc if cc else '-':>10} "
              f"{(f'{sp:.3f}x' if sp else '-'):>8} "
              f"{(f'{vc:.3f}x' if vc else '-'):>9} "
              f"{cover:7.1f} {ok:>4s}")

    if speedups:
        geo = 1.0
        for s in speedups:
            geo *= s
        geo **= 1.0 / len(speedups)
        print(f"\ngeomean speedup vs scalar baseline: {geo:.3f}x "
              f"over {len(speedups)} kernels")

    with open(args.out, "w") as fh:
        json.dump(results, fh, indent=2)
    print(f"\nwrote {args.out}")

    bad = [n for n, e in results.items() if e.get("starbug", {}).get("unsafe")]
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
