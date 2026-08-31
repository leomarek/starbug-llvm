// Minimal bare-metal timing harness for STARBUG benchmarks.
//
// Every kernel is measured the same way: warm the data, read the machine
// counters, run the kernel, read the counters again, then print a checksum so
// the scalar and STARBUG builds can be proved to compute the same answer.
//
// Counters are read with mcycle/minstret (CSRs 0xB00/0xB02) because the
// benchmarks run in machine mode; the user-mode shadows would need mcounteren.

#ifndef STARBUG_BENCH_H
#define STARBUG_BENCH_H

#include <stdint.h>

int printf(const char *, ...);

static inline uint32_t rd_mcycle(void) {
  uint32_t v;
  __asm__ volatile("csrr %0, mcycle" : "=r"(v));
  return v;
}

static inline uint32_t rd_minstret(void) {
  uint32_t v;
  __asm__ volatile("csrr %0, minstret" : "=r"(v));
  return v;
}

// Keep the optimiser from sinking, hoisting or deleting the kernel call, and
// from treating memory as unchanged across it.
static inline void bench_barrier(void) {
  __asm__ volatile("" ::: "memory");
}

// Force a value to be materialised so a checksum cannot be optimised away.
static inline void bench_consume(uint32_t v) {
  __asm__ volatile("" :: "r"(v) : "memory");
}

#define BENCH_MAIN(NAME, SETUP, RUN, CHECKSUM)                                 \
  int main(void) {                                                             \
    uartInit();                                                                \
    SETUP;                                                                     \
    bench_barrier();                                                           \
    uint32_t c0 = rd_mcycle();                                                 \
    uint32_t i0 = rd_minstret();                                               \
    bench_barrier();                                                           \
    RUN;                                                                       \
    bench_barrier();                                                           \
    uint32_t c1 = rd_mcycle();                                                 \
    uint32_t i1 = rd_minstret();                                               \
    bench_barrier();                                                           \
    /* Deliberately obscure name: CHECKSUM is caller code and may well call a  \
       helper named sum(), which a plain local would shadow. */                \
    uint32_t bench_checksum_ = (uint32_t)(CHECKSUM);                           \
    printf("STARBUG_BENCH name=%s cycles=%lu instret=%lu checksum=%08lx\n",    \
           NAME, (unsigned long)(c1 - c0), (unsigned long)(i1 - i0),           \
           (unsigned long)bench_checksum_);                                    \
    return 0;                                                                  \
  }

void uartInit(void);

#endif // STARBUG_BENCH_H
