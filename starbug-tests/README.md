# Starbug C Kernel Tests

Simple C kernels for Starbug backend smoke testing:

- `dot_product.c`
- `fir_filter.c`
- `matmul.c`

## Build

```bash
./compile_starbug.sh
```

Outputs are written to `./build`:

- `*.s` assembly with Starbug bundle hints (`c.li zero, <len>`)
- `*.o` object files
- single-instruction hints are disabled by default (`c.li zero, 1` suppressed)

## Useful overrides

```bash
STARBUG_UNROLL_FACTOR=16 STARBUG_MAX_UNROLL=64 ./compile_starbug.sh
STARBUG_LANE_OP_CLASSES='0:any;1:alu;2:alu;3:alu' ./compile_starbug.sh
STARBUG_EMIT_SINGLE_HINTS=true ./compile_starbug.sh
OUT_DIR=/tmp/starbug-tests ./compile_starbug.sh
```
