# FL-44 handoff: rows below 0x480000, third round (2026-10-23 PDT, cloud thread)

Ledger: **1,926 ported** (1,917 on main after PR 168 + 9). 128 not needed, 2,134 pending. `tests/fl40_corpus.json` now holds **337 translated rows** (327 + 10 new); **155 are credited**, 182 are held (`tasks/fl40-held-rows.json`, written by `scripts/fl44_final.py --write`). Main had 146 clean rows below 0x480000.

## Result

- Every credited FL-40/FL-42 row was rechecked with the exhaustive mutant check under the **guarded harness**; the held rows were rescued with new seeds and survivor rules. Net: 28 held rows are credited, 19 previously credited rows are held again, 9 net new rows. Final verdict per row: `scripts/fl44_final.py` (reads every log below; `--write` rewrites the held list).
- 10 new rows from long-string seeds (`tests/fl40_world.py` `LONG_SEEDS`) all stay held: survivors no rule explains.
- Logs and requests: `tasks/fl44-recheck-credited-log*.txt`, `tasks/fl44-recheck-big5-log.txt`, `tasks/fl44-new-rows-mutation-log.txt`, `tasks/fl44-*rescue*.txt`, `tasks/fl44-*survivors*.json`, `tasks/fl44-*equivalence*.json`, `tasks/fl44-requests-held-fl42.json`.

## What changed in the method

1. **Harness guard** (`tests/fl40_mutation_check.py`, tests `tests/test_fl40_mutation_guard.py`): `signal.alarm(10)` per scenario instead of one alarm over the seed list, so a timeout is never a kill (hangs are listed as `hang-kills`, reported separately). Scenarios where the unmutated port differs from the original are dropped (`guard-dropped-scenarios`); on a corpus seed that is an error. New flags `--corpus` (two runs at once no longer clobber each other) and `--base`.
2. **New seed ranges** (`tests/fl40_world.py`): `STUB_SEEDS = 40000` use boundary callee results (style 5/6); `LONG_SEEDS = 60000` fill 15 of 16 pages with nonzero bytes (long strings). `fl40_generate.py --more-from` adds them to the search.
3. **New survivor rules** (`scripts/fl40_survivors.py`, `scripts/fl44_ranges.py`, soundness test `tests/test_fl44_ranges.py`):
   - rep count: GAME.EXE is not large-address-aware (characteristics 0x10f), so user pointers are below 2 GiB and a `rep` count of a `shr`/`sar`-ed length cannot reach the sign bit.
   - masked read: a narrower read of a value later masked to that width.
   - range: interval analysis on frame slots (compare-immediate widening, 4 narrowing rounds). Refused for address-taken frames, indexed ebp operands, esp-relative memory, ebp/esp as plain operands, non-JCC conditional jumps and loops. Slots are cleared at `leave`/`mov esp,..`/`pop ebp`. Needs a one-line statement with exactly one RD/WR token.
   - flow repeat / flow dead: same data-flow idea as FL-43.
4. `fl44_status.py` is an intermediate script (superseded by `fl44_final.py`).

## Not done / next

- Held rows `0x41aaa1 0x41aeaa 0x41b2e6 0x4595f1` have 74-100 unexplained survivors each. `0x41a4c9` and `0x4033db` need windowed runs (`--window` slices; very large mutant counts hit compile OOM).
- About 28 incomplete rows were not tried; the 10 new long-string rows still have unexplained survivors.
- Dead-direction jumps (`mov eax,1; test eax,eax; je`) were not handled: the oracle requires both directions and Glib has an open question on untaken directions.
- Remaining width/global-load survivors need targeted seeds or range reasoning.
- Reviewed assumptions: callees are recording stubs; the rep-count rule rests on the 2 GiB user-space argument.
