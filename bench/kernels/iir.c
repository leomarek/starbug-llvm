// Biquad IIR cascade. Deliberately low-ILP: every output depends on the two
// previous outputs, so the loop-carried dependence caps achievable bundling.
// Included as a negative control -- a compiler that claims speedup here is
// wrong.
#include <stdint.h>
#include "../common/bench.h"

#define NSAMP 512
static int32_t in[NSAMP], out[NSAMP];

static void init(void) { for (int i = 0; i < NSAMP; ++i) in[i] = (i * 17 + 3) & 0x1FF; }

__attribute__((noinline)) static void iir(const int32_t *x, int32_t *y) {
  int32_t y1 = 0, y2 = 0, x1 = 0, x2 = 0;
  for (int i = 0; i < NSAMP; ++i) {
    int32_t acc = (x[i] * 3 + x1 * 5 + x2 * 3 - y1 * 2 - y2) >> 3;
    x2 = x1; x1 = x[i]; y2 = y1; y1 = acc; y[i] = acc;
  }
}

static uint32_t sum(void) { uint32_t s = 0; for (int i = 0; i < NSAMP; ++i) s += (uint32_t)out[i]; return s; }

BENCH_MAIN("iir", init(), iir(in, out), sum())
