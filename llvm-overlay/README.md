# LLVM Overlay for Starbug VLIW

This overlay contains planning artifacts and starter source snippets for adding a
Starbug VLIW extension to LLVM's RISC-V backend.

## What this is

- Not a complete backend patch yet.
- A structured starting point with configurable lane/op policies and pass skeletons.

## Apply strategy

1. Fork `llvm-project`.
2. Build baseline clang for RISC-V.
3. Copy snippets into `llvm/lib/Target/RISCV/` and wire them using `patch-map.md`.
4. Add lit tests and iterate on packetization legality/perf.

## Design requirements this overlay preserves

- ILP-first defaults with aggressive unrolling.
- Lane count and lane operation support are configurable.
- Bundle size hint lowered to `c.li x0,<len>`.

See:
- `../docs/STARBUG_VLIW_BACKEND_PLAN.md`
- `config/starbug_vliw_lanes.yaml`
- `patch-map.md`
