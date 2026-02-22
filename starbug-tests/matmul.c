#include <stdint.h>

void matmul_i32(const int32_t *a, const int32_t *b, int32_t *c,
                int m, int n, int kdim) {
  for (int i = 0; i < m; ++i) {
    for (int j = 0; j < n; ++j) {
      int64_t acc = 0;

      for (int k = 0; k < kdim; ++k) {
        int32_t av = a[i * kdim + k];
        int32_t bv = b[k * n + j];
        acc += (int64_t)av * (int64_t)bv;
      }

      c[i * n + j] = (int32_t)acc;
    }
  }
}
