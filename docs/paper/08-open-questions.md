# Open questions and remaining work

Ranked by value to the resubmission, not by engineering interest.

---

## Tier 1 — do these before submitting

### 1.1 Lockstep verification against Spike

**The single most valuable missing experiment.** See
[`06-threats.md`](06-threats.md) §1.

The paper argues that the hardware has no interlock and that a malformed bundle
is a silent wrong answer. It then evaluates correctness with SNR thresholds that
`lms` and `rfft` clear by 1 dB. A reviewer will connect those two facts.

The hint is architecturally a NOP, so **Spike is a valid reference model for a
STARBUG binary** — this is already stated as a design property in
[`../HARDWARE_CONTRACT.md`](../HARDWARE_CONTRACT.md) §1 and is not currently
exploited for verification. RVVI/lockstep against Spike or ImperasDV would turn
"passes its own self-check" into "instruction-by-instruction equivalent to the
reference," which is what the claim actually needs.

### 1.2 Add a clang scalar baseline

The `scalar` column is GCC `-O3`; the bundled builds are clang. Some of the
reported speedup is compiler difference, not bundling. One extra build target
isolates it. Cheap, and closes a real hole.

### 1.3 Re-establish the FPGA baseline

The current "baseline" spreadsheet appears to already contain the four-lane
structure. Re-synthesise against stock `rv32gc`, and report the three-way
comparison stock / `starbugi` / `starbug` — which is a better table than the
current two-way one anyway, because it separates the cost of the lanes from the
cost of FP. See [`06-threats.md`](06-threats.md) §5.

### 1.4 Fix or footnote the dct4 threshold

A bare FAIL in a results table is a reading-stopper. See
[`06-threats.md`](06-threats.md) §2.

### 1.5 Complete the layout A/B

Five of ten benchmarks were measured. Run the other five so the +1.98% geomean
covers the same set as the rest of the tables.

---

## Tier 2 — significant strengthening, moderate effort

### 2.1 Fixpoint branch-distance model in the layout pass

**The highest-value remaining compiler work.**

`C.BEQZ`/`C.BNEZ` are 2 bytes only when the target is within ±256 bytes;
otherwise the backend relaxes to 4. The pass currently guesses statically, and
neither setting dominates:

| | fir | biquad | lms | dct4 | rfft |
|---|---:|---:|---:|---:|---:|
| predict on | 9 | 6 | 15 | 27 | 24 |
| predict off | 5 | 0 | 6 | 45 | 32 |

Compute block offsets iteratively the way `BranchRelaxation` does, then size
each `BEQ`/`BNE` by whether its target is in range. That should take all five
toward zero straddles under **one** configuration instead of a best-of, and it
removes a hedge from the paper.

### 2.2 Run the 13 integer kernels in `bench/`

`sort`, `crc32`, `aes_sbox`, `binsearch`, `strops`, `bitops`, `conv2d`, `sad`,
`saxpy`, `dot_product`, `matmul`, `fir`, `iir`. Control-flow-heavy and
integer-heavy code that the DSP suite does not cover.

Directly relevant: the opcode-classification fix unblocked logic-op kernels that
were previously pinned to lane 0 by the name-matching bug. `aes_sbox`, `crc32`
and `bitops` are exactly that shape. **There is a natural experiment here that
has not been run**, and "the compiler covers the program" is a coverage claim
that needs breadth to stand up.

Even null results help — they bound the claim honestly.

### 2.3 Decide the `-mno-relax` question

Relaxation invalidates the layout pass's offsets, but `-mno-relax` costs `fir`
~6% on its own. Three options:

1. Ship as-is, report +1.98%, explain the interaction. **Cheapest, honest.**
2. Move the layout pass after relaxation — a linker-side or post-link tool.
   Architecturally the right answer, meaningful work.
3. Teach the linker to preserve bundle placement. Most work, most general.

Option 1 for this paper; mention 2 and 3 as future work. The observation that
**layout-sensitive hint architectures need whole-toolchain support** is itself a
contribution, and it is more interesting stated as an open problem than papered
over.

### 2.4 Run `starbug_straddle.py` on the current binaries

The execution-weighted straddle tool was built but has not been run against the
post-layout-pass binaries. It would quantify how much straddle cost remains, and
cross-check §2.1's static counts against dynamic weight — the two have disagreed
badly before ([`03-compiler.md`](03-compiler.md) §5).

### 2.5 Hand-annotated `lms` upper bound

`lms_n128` trails hand scheduling by 17.1%. Showing that a hand-annotated
version of the *compiler's* output closes the gap would demonstrate the ceiling
is a scheduling-algorithm limitation, not an architectural one. Cheap relative
to implementing modulo scheduling, and preempts the obvious objection.

---

## Tier 3 — real compiler work, probably beyond this submission

### 3.1 Modulo scheduling

The named fix for `fir` and `lms`. Rau's iterative modulo scheduling; II bounded
below by the single-LSU resource constraint and the accumulator recurrence.
This is the largest single remaining performance opportunity and the most
defensible "future work" item.

### 3.2 Cross-block bundling

Costs biquad 2.14 ILP against hand-written 2.61. Needs superblock or trace
scope plus the Bernstein–Rodeh legality taxonomy (useful / speculative /
duplication-requiring). See [`03-compiler.md`](03-compiler.md) §7.1.

### 3.3 Branch bundling

The hand-written code bundles branches; the compiler will not. Legal only when
the worker-lane operations are dead on the taken path, since they commit either
way. Needs post-RA liveness at the branch.

### 3.4 Packetizer cleanups

1. `hasMemoryBaseDefHazard` is redundant with the general dependence test and
   rejects packets that are provably fine.
2. Replace the coarse `PacketInProgramOrder` / `PacketHasAntiDep` flags with an
   original-program-order index map, so WAR can be accepted precisely rather
   than only while the packet is untouched. This directly increases bundling and
   is the smaller of the two.

### 3.5 Harden against post-packetizer passes

`RISCVMakeCompressibleOpt`, `BranchRelaxation`, `RISCVMoveMerge` and
`RISCVExpandPseudo` all run after the packetizer and could insert an instruction
between a hint and its members. Nothing observed has. A machine-verifier
assertion would make it structural rather than fortunate.

---

## Documentation debt

- [`../EMBENCH_DSP_COMPARISON.md`](../EMBENCH_DSP_COMPARISON.md) §5 and §6
  predate the layout pass and report the compiler as slower than it now is.
  Update or date-stamp them.
- [`../HARDWARE_CONTRACT.md`](../HARDWARE_CONTRACT.md) has no section on the
  I-cache-line layout constraint as a *compiler obligation*. §5 mentions the
  straddle as a fetch-side performance issue; it should cross-reference the pass.
- Decide whether to keep `-starbug-vliw-bundle-layout-verbose`. It defaults to 0
  and is harmless, and it was essential for finding both offset bugs in a build
  with statistics disabled and `LLVM_DEBUG` compiled out. Recommend keeping it
  and saying why in the artefact appendix.

---

## Questions the data cannot currently answer

Worth knowing which claims are simply not supported yet.

1. **Does this generalise beyond DSP?** No integer/control-heavy results exist.
   §2.2 would start to answer it.
2. **What is FP-in-worker-lanes worth architecturally?** `config/starbugi`
   exists to answer this and the experiment has not been run. The compiler-side
   ablation exists; the hardware-side one does not.
3. **How much does the 4-lane width matter vs. 2 or 3?** No width sweep. The
   lane configuration is parameterised (`-starbug-vliw-lane-op-classes`), so a
   compiler-side approximation is possible without re-synthesis.
4. **What does the hint cost when it fails?** The 2-byte hint that gets declined
   is pure overhead. The straddle counts bound it statically; §2.4 would bound
   it dynamically.
5. **Is 64 bytes the right I-cache line?** The constraint is a line-size
   artefact. A larger line would mechanically reduce straddles. Nobody has
   checked whether that is a cheaper fix than the compiler pass.
