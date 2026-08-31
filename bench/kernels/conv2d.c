// 3x3 2D convolution over a 32x32 image.
#include <stdint.h>
#include "../common/bench.h"

#define W 32
static int32_t img[W][W], ker[3][3], dst[W][W];

static void init(void) {
  for (int i = 0; i < W; ++i) for (int j = 0; j < W; ++j) img[i][j] = (i * 5 + j * 3) & 0xFF;
  for (int i = 0; i < 3; ++i) for (int j = 0; j < 3; ++j) ker[i][j] = (i * 3 + j) - 4;
}

__attribute__((noinline)) static void conv(void) {
  for (int i = 1; i < W - 1; ++i)
    for (int j = 1; j < W - 1; ++j) {
      int32_t acc = 0;
      for (int ki = 0; ki < 3; ++ki)
        for (int kj = 0; kj < 3; ++kj) acc += img[i + ki - 1][j + kj - 1] * ker[ki][kj];
      dst[i][j] = acc;
    }
}

static uint32_t sum(void) { uint32_t s = 0; for (int i = 0; i < W; ++i) for (int j = 0; j < W; ++j) s += (uint32_t)dst[i][j]; return s; }

BENCH_MAIN("conv2d", init(), conv(), sum())
