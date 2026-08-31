# Related work and positioning

The framing that matters: STARBUG is not a new VLIW scheduling algorithm. It is
a new *encoding* of the bundle, and the paper's compiler contribution is
identifying which classical techniques still apply, which need modification, and
which obligation is genuinely new.

## 1. Classical VLIW scheduling — what carries over unchanged

| work | relevance |
|---|---|
| **Fisher, trace scheduling** (IEEE ToC 1981; *Trace Scheduling: A Technique for Global Microcode Compaction*) | The origin of scheduling beyond the basic block. `StarbugVLIWTraceScheduler` is in this lineage. The compensation-code machinery is what makes cross-block motion legal. |
| **Hwu et al., the superblock** (*J. Supercomputing* 1993) | Single-entry multiple-exit regions formed by tail duplication. The natural scope for STARBUG's missing cross-block bundling ([`03-compiler.md`](03-compiler.md) §7.1). |
| **Rau, iterative modulo scheduling** (MICRO 1994) | The named fix for the `arm_fir_f32` gap. Recurrence-constrained II from the `fa4` accumulator chain, resource-constrained II from the single LSU — this is a textbook modulo scheduling problem and the paper should say so rather than describe it in ad-hoc terms. |
| **Bernstein & Rodeh** (PLDI 1991; *Global instruction scheduling for superscalar machines*) | The taxonomy the paper should borrow for §7.1: **useful** motion (executes on all paths, free), **speculative** (needs domination), **duplication-requiring** (needs compensation). Explains precisely why the pointer bumps in biquad cannot currently be hoisted. |
| **Lam, software pipelining** (PLDI 1988) | Modulo variable expansion; relevant to the register pressure ceiling that caps useful unrolling at 8 ([`03-compiler.md`](03-compiler.md) §6). |

**The honest framing:** none of these are novel here, and the paper is stronger
for saying so. The contribution is not a scheduling algorithm — it is showing
that a NOP-encoded hint admits a sound compiler at all, and characterising the
three obligations it adds.

## 2. Layout-aware instruction placement — the actual precedent

This is where STARBUG's genuinely new compiler obligation has company, and this
section is worth writing carefully because it is the paper's most defensible
novelty claim.

| architecture | the layout constraint | how the compiler handles it |
|---|---|---|
| **Itanium / IA-64** | Instructions are grouped into 128-bit bundles with a template field; certain templates and stops are only legal in certain positions | The compiler emits the bundle structure directly — layout is *part of the encoding*, so there is nothing to discover after the fact |
| **TI C6x** | 32-byte fetch packets; parallelism is marked by a p-bit chain, and an execute packet **may not cross a fetch-packet boundary** | The assembler pads with NOPs to align execute packets. Layout is handled, but by *insertion*, and the cost is code size |
| **STARBUG** | A bundle is discarded if the hint and members do not fit in the remaining bytes of a 64-byte I-cache line | Split at the boundary — no instruction moves, no padding, no size cost |

The C6x comparison is the sharpest. **C6x pads; STARBUG splits.** Splitting is
available precisely *because* the hint is advisory rather than structural: two
smaller bundles are as valid as one large one, whereas a C6x execute packet
cannot be halved without changing its meaning. That is a real, specific
advantage of the hint encoding, and it is the kind of concrete architectural
consequence a PACT audience wants from a paper about an encoding.

Also worth noting: C6x's constraint is on *fetch packets*, which the assembler
knows about. STARBUG's is on *I-cache lines*, which the assembler does not —
and which linker relaxation can invalidate after the fact
([`03-compiler.md`](03-compiler.md) §4.5). The constraint is not just
layout-aware scheduling; it is layout-aware scheduling in a toolchain that does
not preserve layout.

## 3. Hint-based and compatibility-preserving parallelism

Position STARBUG against approaches that also try to get parallelism without
breaking the ISA:

- **Transmeta Crusoe / code morphing** — binary translation to a VLIW at
  runtime. Same goal (run existing binaries on a VLIW), completely different
  mechanism, and the cost is a translation layer. STARBUG's cost is a
  recompile for speedup and *nothing at all* for compatibility.
- **Intel/AMD µop fusion, macro-op fusion in RISC-V** — hardware discovers
  adjacent-instruction parallelism with no software involvement. STARBUG moves
  that discovery to the compiler and pays two bytes to communicate it. The
  trade is: no fusion-detection hardware, but the compiler must be right.
- **The RISC-V HINT space** generally — the ISA reserves NOP-like encodings for
  exactly this kind of use. STARBUG is a substantial, working instance, and if
  the paper can say something about whether the mechanism generalises (other
  hint-encoded microarchitectural requests) that broadens its appeal well
  beyond one core.
- **EPIC's explicit-parallelism thesis** — Schlansker & Rau's EPIC report is
  the right citation for "the compiler tells the hardware what is parallel."
  STARBUG is EPIC's thesis with an *optional* channel: the hardware may ignore
  the message and stay correct, which no EPIC machine can do.

That last point deserves emphasis. **In every prior explicitly-parallel
architecture, the parallelism annotation is binding.** STARBUG's is advisory,
and advisory-ness is what buys binary compatibility, what makes splitting legal,
and what forces the sequential-correctness obligation on the compiler. It is
the single axis on which the design is genuinely different, and the paper should
organise its contribution around it.

## 4. Verification of compiler-generated parallelism

The verifier ([`01-claim.md`](01-claim.md) §3.4) is unusual enough to place:

- Most VLIW toolchains do not need one, because the assembler enforces bundle
  legality — an illegal bundle is unrepresentable.
- Here the bundle is a hint over ordinary instructions, so **every legal
  instruction sequence is a representable bundle**, including wrong ones, and
  the hardware has no interlock.
- The closest analogue is separation-logic-style checking of hand-written
  assembly, or the alignment/padding assertions in a C6x assembler — but
  neither has to prove *dependence* properties.

Finding real defects in the hand-written reference (4 of 10 binaries) is
evidence that this checking is necessary rather than ceremonial. That is a
publishable observation in its own right: **hint-based parallelism moves a
class of errors from "unrepresentable" to "silent."**

## 5. Suggested citation set

Minimum viable:

1. Fisher 1981 — trace scheduling
2. Hwu et al. 1993 — superblock
3. Rau 1994 — iterative modulo scheduling
4. Bernstein & Rodeh 1991 — global scheduling taxonomy
5. Lam 1988 — software pipelining
6. Schlansker & Rau — EPIC
7. TI C6x architecture reference — fetch packets and padding
8. Itanium architecture — bundles and templates
9. CORE-V Wally — the host core
10. CMSIS-DSP — the benchmark source

Add, if the paper leans on the compatibility argument:

11. Transmeta code morphing
12. RISC-V ISA manual, HINT encoding space
13. Embench — benchmark methodology
