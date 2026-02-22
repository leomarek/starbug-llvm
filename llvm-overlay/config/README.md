# Starbug Config Schema

This directory defines editable defaults for Starbug VLIW target behavior.

## Intended usage

- Keep this YAML as human-editable source of truth.
- Translate it into C++ defaults (or generated `.inc`) during backend updates.
- Allow selective runtime overrides with `-mllvm` flags for experimentation.

## Why this exists

The packetizer and scheduler should not hard-code:
- lane count,
- lane operation constraints,
- unroll aggressiveness,
- packet formation preferences.

When hardware changes, update this file and regenerate backend defaults rather than rewriting packetizer logic.
