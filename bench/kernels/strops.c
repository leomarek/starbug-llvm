// String scanning and copying through char pointers. Pointer arithmetic with
// unknown aliasing is exactly what makes hint-based bundling hard outside DSP
// code.
#include <stdint.h>
#include "../common/bench.h"

#define NBUF 1024
static char src[NBUF], dst[NBUF];
static uint32_t acc;

static void init(void) {
  for (int i = 0; i < NBUF - 1; ++i) src[i] = (char)('a' + ((i * 7) % 26));
  src[NBUF - 1] = '\0';
}

__attribute__((noinline)) static uint32_t work(char *d, const char *s) {
  uint32_t h = 0;
  char *dp = d;
  while (*s) { *dp++ = *s; h = h * 31 + (uint32_t)(uint8_t)*s; ++s; }
  *dp = '\0';
  for (char *p = d; *p; ++p) if (*p == 'q') h ^= (uint32_t)(p - d);
  return h;
}

BENCH_MAIN("strops", init(), acc = work(dst, src), acc)
