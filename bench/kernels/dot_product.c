// Integer MAC reduction. Classic DSP kernel: high ILP once the reduction is
// split into independent partial sums.
#include <stdint.h>
#include "../common/bench.h"

#define N 512
static int32_t a[N], b[N];
static int32_t result;

static void init(void) {
  for (int i = 0; i < N; ++i) { a[i] = (i * 7 + 3) & 0xFFFF; b[i] = (i * 13 + 5) & 0xFFFF; }
}

__attribute__((noinline)) static int32_t dot(const int32_t *x, const int32_t *y, int n) {
  int32_t acc = 0;
  for (int i = 0; i < n; ++i) acc += x[i] * y[i];
  return acc;
}

BENCH_MAIN("dot_product", init(), result = dot(a, b, N), result)
