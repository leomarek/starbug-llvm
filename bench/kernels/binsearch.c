// Repeated binary search over a sorted table. Almost pure control flow with a
// serial pointer-chase; near-zero exploitable ILP by construction.
#include <stdint.h>
#include "../common/bench.h"

#define N 1024
#define NQ 512
static int32_t tab[N];
static uint32_t hits;

static void init(void) { for (int i = 0; i < N; ++i) tab[i] = i * 3; }

__attribute__((noinline)) static uint32_t search_all(void) {
  uint32_t found = 0;
  for (int q = 0; q < NQ; ++q) {
    int32_t key = (int32_t)((q * 7) % (N * 3));
    int lo = 0, hi = N - 1;
    while (lo <= hi) {
      int mid = (lo + hi) >> 1;
      if (tab[mid] == key) { ++found; break; }
      if (tab[mid] < key) lo = mid + 1; else hi = mid - 1;
    }
  }
  return found;
}

BENCH_MAIN("binsearch", init(), hits = search_all(), hits)
