// Table-driven CRC32. Serial dependence through the running CRC plus a
// data-dependent table load every iteration: memory-bound and hard to bundle.
#include <stdint.h>
#include "../common/bench.h"

#define NBYTE 2048
static uint8_t buf[NBYTE];
static uint32_t table[256];
static uint32_t crc_out;

static void init(void) {
  for (int i = 0; i < NBYTE; ++i) buf[i] = (uint8_t)((i * 31 + 7) & 0xFF);
  for (uint32_t i = 0; i < 256; ++i) {
    uint32_t c = i;
    for (int k = 0; k < 8; ++k) c = (c & 1) ? (0xEDB88320u ^ (c >> 1)) : (c >> 1);
    table[i] = c;
  }
}

__attribute__((noinline)) static uint32_t crc32(const uint8_t *p, int n) {
  uint32_t c = 0xFFFFFFFFu;
  for (int i = 0; i < n; ++i) c = table[(c ^ p[i]) & 0xFF] ^ (c >> 8);
  return c ^ 0xFFFFFFFFu;
}

BENCH_MAIN("crc32", init(), crc_out = crc32(buf, NBYTE), crc_out)
