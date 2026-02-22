#include <stdint.h>

void fir_filter_i32(const int32_t *input, const int32_t *coeffs,
                    int32_t *output, int n, int taps) {
  for (int i = 0; i < n; ++i) {
    int64_t acc = 0;

    for (int k = 0; k < taps; ++k) {
      int idx = i - k;
      if (idx >= 0)
        acc += (int64_t)input[idx] * (int64_t)coeffs[k];
    }

    output[i] = (int32_t)acc;
  }
}
