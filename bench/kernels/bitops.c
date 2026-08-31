// Register-resident bit mixing (xorshift + finalizer). No memory traffic at
// all, so it isolates worker-lane ALU throughput from the single-LSU
// bottleneck.
#include <stdint.h>
#include "../common/bench.h"

#define ITER 4096
static uint32_t out;

__attribute__((noinline)) static uint32_t mix(uint32_t seed) {
  uint32_t x = seed, y = seed ^ 0x9E3779B9u, z = seed + 0x7F4A7C15u, w = seed * 5u + 1u;
  for (int i = 0; i < ITER; ++i) {
    x ^= x << 13; x ^= x >> 17; x ^= x << 5;
    y ^= y << 11; y ^= y >> 19; y ^= y << 3;
    z ^= z << 7;  z ^= z >> 9;  z ^= z << 17;
    w ^= w << 15; w ^= w >> 4;  w ^= w << 23;
  }
  return x ^ y ^ z ^ w;
}

BENCH_MAIN("bitops", (void)0, out = mix(0x12345678u), out)
