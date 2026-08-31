// Insertion sort. Data-dependent, unpredictable branches and a short inner
// loop -- the control-flow-heavy case the design is least suited to.
#include <stdint.h>
#include "../common/bench.h"

#define N 384
static int32_t arr[N];

static void init(void) {
  uint32_t s = 12345;
  for (int i = 0; i < N; ++i) { s = s * 1103515245u + 12345u; arr[i] = (int32_t)((s >> 16) & 0x7FFF); }
}

__attribute__((noinline)) static void isort(int32_t *v, int n) {
  for (int i = 1; i < n; ++i) {
    int32_t key = v[i];
    int j = i - 1;
    while (j >= 0 && v[j] > key) { v[j + 1] = v[j]; --j; }
    v[j + 1] = key;
  }
}

static uint32_t sum(void) { uint32_t s = 0; for (int i = 0; i < N; ++i) s += (uint32_t)arr[i] * (uint32_t)(i + 1); return s; }

BENCH_MAIN("sort", init(), isort(arr, N), sum())
