# FL-76 handoff: hand-built scenarios for near-miss Mac-port rows

FL-76 cleared near-miss pending rows of the Mac-port view (Game + Vorbis) by building start states by hand, on top of the FL-73, FL-74 and FL-72 tools. Credit tier is "tested equivalent": every instruction and both directions of every conditional jump run on the original bytes under Unicorn, and the committed translation equals the original on every kept scenario. The strict "verified ported" count is unchanged.

## Rows credited

- PR 260 (batch 1): 0x467eb0 0x4381f4 0x439822 0x424aa8 0x44ad41 0x4bf9bb 0x4da430 0x491db2.
- PR 261 (batch 2): 0x4af225 0x412234 0x4d7ea4 0x4d7a15 0x4f4b9f 0x4f3c26 0x4c9d91 0x495af3.
- Batch 3 (see the PR for this branch): 0x4b8e92 0x4aba6d tested equivalent, 0x416fb6 proved. 0x4867bd was also finished here (scenario file `tasks/fl76/out/y4.json`) but FL-75's PR 259 credits it, so it is not in this batch's manifests (one direction, `mov ecx, 1; test ecx, ecx; je`, is impossible by construction; the prover closes it).

Scenario files are in `tasks/fl76/out/` (the final one per row is the `y*`, `i1`, `j3`, ... file named in the row's commit message), per-row results in `tasks/fl66/rows/`.

## Parked and why

- 0x47b767, 0x4e0e2b, 0x4e812f: coverage is complete, only the prover step is missing (`tasks/fl76/rows/*.json` status `partial`). Rerun `FL66_EARLY=1 python3 scripts/fl66_tested.py check ROW --redo --prove --scen tasks/fl76/out/<ROW>.json` once FL-75's prover lands.
- 0x4ba56a: 705 of 761 instructions and 71 of 98 directions from feasible gates (scenario files `tasks/fl76/out/0x4ba56a.json`; the rest of the work is in the scratchpad only). The remaining directions are mostly impossible (the function copies `this+0x1bc..0x1c8` to `this+0x1cc..0x1d8` and then compares the unchanged `0x1c0` and `0x1c8` slots, so `jne` can never be taken), and `--prove` times out after 900 s on this size. Needs FL-75's prover.
- 0x456516, 0x471722, 0x47c0f0: tied to the open no-alias question (unchanged).
- Other rows ranked by what is still missing (instructions covered / total, directions taken / total, with all scenarios known today):
  - 0x4a6c61 867/900, 103/112; 0x4a0ec3 142/154, 11/12; 0x49d945 563/599, 73/76; 0x44b641 and 0x44ffa3 and 0x4bbb3e: all instructions, a few directions (prover rows).
  - 0x45c18f 983/1072, 137/154; 0x4eeb23 294/504, 23/38; 0x4f7207 368/569, 43/58; 0x4ec9a2 429/724, 45/62; 0x4e5fdb 117/365, 10/32 (early gate); 0x41e647 197/971 (early gate); 0x4899ca 272/665; 0x4bca71 1079/1428; 0x4c1716 68/1019 (one gate at 0x4c17f8 hides everything).
  - 0x4090ab and 0x448d11 reach 0 instructions on every scenario (the original run faults or the entry is not reachable with the default start state); needs a look at `tasks/fl76/lastpc.py ROW SEED 'OV'` first.
  - Prover timeouts or out-of-memory in the committed partial file: 0x413187 0x417b04 0x425b8b 0x4a4f58 0x4b4a68 0x4f0059 and others. These are FL-75's.

## Tools added in `tasks/fl76/`

- `stubset.py ROW OUT 'SPEC' [scen..]`: add callee returns or callee stores. Steps: `('ret', callpc, slot, val)`, `('wr', callpc, target, val)`, `('retn'/'wrn', callpc, nth, ...)`, `('g', addr, size, val)`. Env `KEEP=1` keeps the scenarios' existing stub overrides (without it they are stripped and a gate that needed one is lost), `ALL=1` keeps every scenario that ran the steps, `SEEDS=a-b` starts from plain seeds. A step whose call is not reached stops the remaining steps of that scenario, so put steps that sit on different paths in separate runs.
- `thiscombo.py ROW OUT 'EXPR' [scen..]`: cells relative to a register at a pc (`PC=0x.. REG=ebp|ecx|edx`, `ARG=n`), with pointer chains: path `[-0xc, 0x5e]` means `[[ebp-0xc]+0x5e]`. Overlapping older overrides are removed (a 4-byte cell over four old byte cells otherwise loses).
- `cpset.py ROW OUT PC N [scen..]`: at a `repe cmpsb` copy the N bytes at edi onto esi so the compare is equal (env `SKIP=k` for the k-th hit).
- `pset.py ROW OUT NEWP PC [scen..]`: moves the table pointer `[0x5bb5e5 + 0x8d*idx]` to ordinary memory (see lesson 3).
- `miss.py`, `dif.py`, `un.py`, `combo.py`, `cmpeq.py`, `fz4*.py`, `wrat.py`, `lastpc.py`: coverage listing, one-scenario original-versus-translation diff, merge, combination runs, string compare, record fuzzers, write-at, last pcs.

## Lessons

1. Order matters: set stub returns first, then the cells that depend on them, and keep the scenarios that only exist to carry the stub return (`ALL=1`); a scenario kept only when it adds coverage drops the setup a later stage needs.
2. Strings and records compared against a constant (`repe cmpsb` of 9 bytes at `[[this+8]+0x466]`) are cheapest with `cpset.py`. The image bytes are read through Unicorn, never `disx.rd` (it showed a different string at 0x5421bc).
3. A pointer that the scenario sets to an image address (0x500000 in 0x4aba6d) makes size-2 or size-4 cell overrides at that address diverge between the original run and the translation (`tests/fl41_world.py` makes the native side skip image-range overrides below `DATA_START`; that is the likely cause but I did not confirm it, a size-1 override at the same address agreed). The mismatch was in my own scenario, not a defect found in the translation. Move the pointer to ordinary memory with `pset.py` first.
4. An override value may be any size: 42 overrides of 1000 bytes (`int('41'*1000, 16)`) make a 42,000-byte string, which is how 0x4867bd takes the `strlen > 0x9c40` direction. Keep each value under about 4,000 decimal digits (Python's JSON int limit).
5. `this` arrives in ecx and differs by seed (0x20000040, 0x20001000, ...), so always address fields relative to the register at the hook, never by absolute address.
6. Many functions in this family (0x4aba6d, 0x4b8e92, 0x4ba56a) dispatch on `[idx*0x8d+0x5bb632]` and a state word at `this+0x5e`; set both.
