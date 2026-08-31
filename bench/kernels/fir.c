// 32-tap FIR filter. Inner loop is a sliding-window MAC with no loop-carried
// memory dependence, so it is the best case for bundling.
#include <stdint.h>
#include "../common/bench.h"

#define NTAP 32
#define NSAMP 512
static int32_t coef[NTAP], in[NSAMP + NTAP], out[NSAMP];

static void init(void) {
  for (int i = 0; i < NTAP; ++i) coef[i] = (i * 3 + 1) & 0xFF;
  for (int i = 0; i < NSAMP + NTAP; ++i) in[i] = (i * 11 + 7) & 0x3FF;
}

__attribute__((noinline)) static void fir(const int32_t *x, const int32_t *c, int32_t *y) {
  for (int i = 0; i < NSAMP; ++i) {
    int32_t acc = 0;
    for (int j = 0; j < NTAP; ++j) acc += c[j] * x[i + j];
    y[i] = acc;
  }
}

static uint32_t sum(void) { uint32_t s = 0; for (int i = 0; i < NSAMP; ++i) s += (uint32_t)out[i]; return s; }

BENCH_MAIN("fir", init(), fir(in, coef, out), sum())
