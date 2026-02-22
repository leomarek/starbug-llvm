# Hot Trace ILP Strategy (Starbug VLIW)

Goal: increase average bundle length in hot traces and maximize sustained issue width. Code-size growth is acceptable.

## Why Bundle Sizes Collapse

Common causes in current VLIW packetizers:
- conservative dependence barriers (especially WAR/WAW without renaming),
- branch-heavy traces with frequent packet flush points,
- weak hot/cold separation (optimizer spends effort on cold paths),
- insufficient loop software pipelining,
- lane constraints interacting with schedule order.

## Priority Roadmap

## P0: Do First

1. Profile-guided trace bias for packetization and scheduling.
- Collect execution profiles and mark hot traces/blocks.
- In packetizer cost model, optimize bundle fill for hot traces first; allow more code duplication on hot paths.
- Treat cold path quality as secondary.

2. Superblock/trace formation before packetization.
- Tail-duplicate and form larger single-entry traces so scheduler sees longer straight-line regions.
- Keep compensation code in cold exits.

3. Enable and tune software pipelining for loop kernels.
- Use machine pipeliner aggressively on innermost hot loops.
- This is often the highest ROI for sustained multi-issue VLIW utilization in DSP-style kernels.

4. Aggressive if-conversion on hot diamonds.
- Convert predictable hot branches to predicated/select-like forms where legal.
- Fewer control edges means fewer packet flush boundaries.

## P1: High Value Next

5. False-dependence breaking before packetization.
- Add a targeted renaming pass (or integrate into packetizer) to reduce WAR/WAW stalls.
- This directly unlocks bigger packets when true RAW dependencies are sparse.

6. Lane-aware list scheduling objective tuned for fill.
- Score candidates by expected bundle occupancy and downstream slack.
- Prefer instructions that avoid painting into a corner for lanes 1..N.

7. Raise transform aggressiveness on hot loops.
- Stronger full unroll, unroll-and-jam, loop unswitching, and peeling where profitable for ILP.
- Since code size is not a constraint, allow much higher thresholds on hot loops.

## P2: Infrastructure/Advanced

8. Integrate post-link basic-block reordering for hot paths.
- Improve I-cache/BTB behavior and keep hot traces contiguous.
- This does not create ILP directly but reduces front-end disruption, improving realized throughput.

9. Add profile-driven trace cloning.
- Clone ambiguous regions so the hot version is more schedulable (fewer side exits, cleaner deps).

## Concrete LLVM Hooks

- Hot/cold and branch probability data:
  - `BlockFrequencyInfo`, `BranchProbabilityInfo`, profile metadata.
- Trace shaping and if-conversion:
  - machine-level if-conversion and tail duplication paths.
- Loop kernel throughput:
  - machine pipeliner (`MachinePipeliner` / Swing Modulo Scheduling).
- RISC-V integration points already relevant in this workspace:
  - `llvm/lib/Target/RISCV/RISCVTargetMachine.cpp` (pass pipeline),
  - `llvm/lib/Target/RISCV/RISCVTargetTransformInfo.cpp` (unroll policy),
  - `llvm/lib/Target/RISCV/StarbugVLIWPacketizer.cpp` (bundle formation).

## Measurement Plan

Track these on representative workloads (top hot kernels and full apps):

1. Bundle fill ratio:
- `(sum of hinted bundle lengths) / (number_of_hints * lane_count)`

2. Hot-trace large-bundle share:
- `% of bundle hints with len >= 3 in top 10% hottest blocks`

3. Realized throughput:
- cycles per output element for dot/FIR/matmul and app-level hotspots.

4. Compiler diagnostics:
- missed packetization reasons (dependency, lane legality, control barrier).

## Immediate Experiments

1. PGO-driven compile pipeline.
- Instrument:
  - `-fprofile-instr-generate`
- Train on representative data.
- Merge:
  - `llvm-profdata merge`
- Rebuild with:
  - `-fprofile-instr-use=<profile>`

2. Machine pipeliner stress test on hot loops.
- Turn on/tune pipeliner options and compare bundle-fill and cycles.

3. Trace-forming packetizer prototype.
- Form superblocks in hot regions and compare len>=3/4 bundle rates.

## Sources

LLVM / Clang primary docs:
- [LLVM Code Generator](https://llvm.org/docs/CodeGenerator.html)
- [LLVM Passes Reference (loop-unroll-and-jam)](https://llvm.org/docs/Passes.html)
- [Clang Users Manual: Profile Guided Optimization](https://clang.llvm.org/docs/UsersManual.html#profile-guided-optimization)
- [llvm-profdata command guide](https://llvm.org/docs/CommandGuide/llvm-profdata.html)
- [LLVM BOLT project docs](https://github.com/llvm/llvm-project/tree/main/bolt/docs)

Classic ILP / VLIW scheduling papers:
- J. A. Fisher, "Trace Scheduling: A Technique for Global Microcode Compaction" (1981), [DOI](https://doi.org/10.1109/TC.1981.1675827)
- D. I. August et al., "The Hyperblock: A Compilation Technique for VLIW Architectures" (1995), [ACM DOI](https://doi.org/10.1145/207110.207157)
- S. Mahlke et al., "Effective Compiler Support for Predicated Execution Using the Hyperblock" (1992), [DOI](https://doi.org/10.1145/143095.143137)
- W. W. Hwu et al., "The Superblock: An Effective Technique for VLIW and Superscalar Compilation" (1993), [DOI](https://doi.org/10.1007/BF01205185)
- J. Llosa et al., "Lifetime-Sensitive Modulo Scheduling in a Production Environment" (2001), [DOI](https://doi.org/10.1109/TC.2001.10010)
