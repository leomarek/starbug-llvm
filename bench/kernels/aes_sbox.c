// AES-style SubBytes + row mixing over a table. Load-heavy with a data
// dependent index, representative of crypto inner loops.
#include <stdint.h>
#include "../common/bench.h"

#define NBLK 128
static uint8_t sbox[256];
static uint8_t state[NBLK][16];
static uint32_t digest;

static void init(void) {
  for (int i = 0; i < 256; ++i) sbox[i] = (uint8_t)(((i * 167) ^ 0x63) & 0xFF);
  for (int b = 0; b < NBLK; ++b) for (int i = 0; i < 16; ++i) state[b][i] = (uint8_t)((b * 16 + i) & 0xFF);
}

__attribute__((noinline)) static uint32_t rounds(void) {
  uint32_t h = 0;
  for (int b = 0; b < NBLK; ++b) {
    uint8_t *s = state[b];
    for (int r = 0; r < 4; ++r)
      for (int i = 0; i < 16; ++i) s[i] = sbox[s[i]];
    for (int i = 0; i < 16; ++i) h = h * 31u + s[i];
  }
  return h;
}

BENCH_MAIN("aes_sbox", init(), digest = rounds(), digest)
