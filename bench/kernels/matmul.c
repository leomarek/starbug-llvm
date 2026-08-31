// Dense 24x24 integer matrix multiply.
#include <stdint.h>
#include "../common/bench.h"

#define M 24
static int32_t A[M][M], B[M][M], C[M][M];

static void init(void) {
  for (int i = 0; i < M; ++i)
    for (int j = 0; j < M; ++j) { A[i][j] = (i + j) & 0x7F; B[i][j] = (i * j + 1) & 0x7F; }
}

__attribute__((noinline)) static void mm(void) {
  for (int i = 0; i < M; ++i)
    for (int j = 0; j < M; ++j) {
      int32_t acc = 0;
      for (int k = 0; k < M; ++k) acc += A[i][k] * B[k][j];
      C[i][j] = acc;
    }
}

static uint32_t sum(void) { uint32_t s = 0; for (int i = 0; i < M; ++i) for (int j = 0; j < M; ++j) s += (uint32_t)C[i][j]; return s; }

BENCH_MAIN("matmul", init(), mm(), sum())
