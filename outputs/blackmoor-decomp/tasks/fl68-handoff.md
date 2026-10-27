# FL-68 handoff: the CRT/MFC rows of the tested-equivalent tier

Scope: the 280 CRT/MFC rows that were still pending after FL-66 (277 translated but partial, 3 without a translation). Reported as `verified X, tested equivalent Y, translated only Z` (`python3 scripts/fl66_tested.py status`).

## Batch 1 (this PR): tested equivalent 1,315 -> 1,446 (+131 CRT/MFC rows)

- `scripts/fl68_search.py`: goal-directed scenario search on the ORIGINAL bytes (Unicorn only; the translation is compared afterwards by `fl66_tested.py check`). Moves: compare flips (cell, register, callee return or start register set to the other operand of a compare in front of an untaken jump), boundary values of input cells, start registers, callee returns, then random pairs. Works where the concolic generators (fl61/fl62) stop at "Unsupported indirect call" (about 90 of the 277 rows). Run `gc.freeze()` after loading tables: `W.run_original` calls `gc.collect()` per run and a big heap made every run cost 0.15 s (now 20 ms).
- Harness fixes found by it (all in `tests/fl41_world.py` / `scripts/lift_fl41.py` / `scripts/fl66_tested.py`):
  - indirect calls and tail `jmp`s through a register or pointer that the FL-58 driver did not register as sites: `tests/fl68_sites.json` (built by `scripts/fl68_sites.py` from the translation text), and `site_hook` plays a `jmp` site as a tail call (no return address pushed or logged);
  - self-recursive rows (the entry is also a callee stub): the first instruction at the entry is the row itself;
  - import thunks (`jmp [slot]`) as callees: the pop count was guessed from the first `ret` after the thunk (16 for most); it is now the import's own stdcall argument count, or the followed `jmp` target. Seven rows re-translated by `scripts/fl68_relift.py` (replaces only those rows in the FL-57 file and table);
  - `__chkstk` (0x50c920) is a row now: pool `fl68`, `tests/fl68_rows.json`.
- `fl66_tested.py merge` keeps the committed partial/mismatch/error lists of earlier batches (their per-row result files are not committed) and only replaces the rows of the results directory. `FL66_ROWS` and `FL66_SCEN` pick the results and scenario directories (this thread used `tasks/fl68/rows`, `tasks/fl68/scen`, not committed).

## What is left (CRT/MFC pending after batch 1: see `status`)

- Directions that cannot be taken (`jb` then `jae` after an unsigned add, a compare against an immediate that is never zero, ...): wait for the FL-67 T-EQ-INFEASIBLE rule, then apply it to the partial rows; do not build a second one.
- Tail jumps to another function while the row has extra words pushed (`push edx; ... jmp 0x513ccb` in the x87 math wrappers): the callee stub returns to the pushed word, so the original runs on into garbage; the translation ends. Needs the stub to know the extra stack height.
- Fragments entered mid-function and rows whose original faults on every scenario.
- 0x50ed50 (memmove) and 0x50fa90 (memcpy): the census left the span unsplit (a floor: cannot be ported or not needed) and the lifter refuses them (jump tables into code).
