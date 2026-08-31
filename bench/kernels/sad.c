// Sum-of-absolute-differences block match, as used in video codecs.
#include <stdint.h>
#include "../common/bench.h"

#define BW 16
#define NBLK 64
static uint8_t cur[BW * BW], ref[BW * BW + NBLK];
static uint32_t best;

static void init(void) {
  for (int i = 0; i < BW * BW; ++i) cur[i] = (uint8_t)((i * 7) & 0xFF);
  for (int i = 0; i < BW * BW + NBLK; ++i) ref[i] = (uint8_t)((i * 5 + 2) & 0xFF);
}

__attribute__((noinline)) static uint32_t sad_search(void) {
  uint32_t bestv = 0xFFFFFFFFu;
  for (int off = 0; off < NBLK; ++off) {
    uint32_t acc = 0;
    for (int i = 0; i < BW * BW; ++i) {
      int d = (int)cur[i] - (int)ref[i + off];
      acc += (uint32_t)(d < 0 ? -d : d);
    }
    if (acc < bestv) bestv = acc;
  }
  return bestv;
}

BENCH_MAIN("sad", init(), best = sad_search(), best)
