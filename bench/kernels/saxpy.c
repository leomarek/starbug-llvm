// y = a*x + y over int32. Two independent input streams and one output
// stream: the aliasing question the reviewers raised, in its simplest form.
#include <stdint.h>
#include "../common/bench.h"

#define N 1024
static int32_t x[N], y[N];

static void init(void) { for (int i = 0; i < N; ++i) { x[i] = (i * 3 + 1) & 0xFFF; y[i] = (i * 5 + 2) & 0xFFF; } }

__attribute__((noinline)) static void saxpy(int32_t a, const int32_t *xx, int32_t *yy, int n) {
  for (int i = 0; i < n; ++i) yy[i] = a * xx[i] + yy[i];
}

static uint32_t sum(void) { uint32_t s = 0; for (int i = 0; i < N; ++i) s += (uint32_t)y[i]; return s; }

BENCH_MAIN("saxpy", init(), saxpy(7, x, y, N), sum())
