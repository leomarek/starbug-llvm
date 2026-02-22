#include <stdint.h>

int32_t dot_product_i32(const int32_t *a, const int32_t *b, int n) {
  int64_t acc = 0;

  for (int i = 0; i < n; ++i)
    acc += (int64_t)a[i] * (int64_t)b[i];

  return (int32_t)acc;
}
