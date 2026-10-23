# FL-45 handoff: rows at or above 0x480000, fourth round (2026-10-23 PDT, cloud thread)

Ledger: **1,934 ported** (1,926 on main after PR 169 + 8). 128 not needed, 2,126 pending. `src/original_methods_fl41.c` holds **35 rows** (27 credited before + 8 new). GAME.EXE SHA-256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (read only).

## Result

- 168 rows were regenerated (`scripts/fl41_generate.py`, every instruction run, both directions of every jump taken, equal to the original on the corpus; 195 in the pool with the 27 credited before); 83 of them were checked exhaustively (`tasks/fl45-mutation-log-final.txt`, every mutant, `--extended`) and the 80 larger ones were not checked.
- 36 rows had every survivor killed or explained. **28 of them were held back** because at least one mutant is killed only by a hang (an infinite loop: no output tells it from the original). Timeouts never count as kills (Glib's ruling), and the strict rerun (`FL45_STRICT_HANG`, `tasks/fl45-strict-hang-log.txt`: 260 mutants, 75 killed by a seed, 185 survive) leaves each of the 28 with unexplained survivors, since no proof rule covers non-termination. Their translations, corpus entries and hang counts are kept in `tasks/fl45-hang-dependent-rows.json`; `tests/fl41_pending.json` marks them "mutation survivor". **Open question for Glib:** may a mutant that loops forever where the original terminates count as killed? If yes, the 28 rows (+28, 1,962) can be restored from that file in a follow-up with no new generation.
- The 8 rows credited: `0x4cd645 0x4d3d48 0x4d42e0 0x4d4377 0x4d46b3 0x4de743 0x4e1d34 0x4eff03`. Blockers cleared through `tasks/fl45-blockers.json` (3 rows, receipt items are caller-side gaps; reasons written per slice).
- Of the 27 earlier rows none depends on a hang kill.

## What changed in the method

1. **`scripts/fl45_ranges.py`** (interval analysis on the original instructions): each register and each `[ebp+k]` slot carries a pair (signed-32 interval, signed-16 low-half interval); widening to the function's constants, refinement of compared operands on conditional-jump edges (signed and unsigned), jump tables, alias bookkeeping for slot copies. It also prunes edges no state can take (`feasible`), which `scripts/fl43_equiv.py` now uses for its repeat/dead facts. Soundness test `tests/test_fl45_ranges.py` runs the original under Unicorn with a probe at every instruction and checks every register and slot interval and every executed edge (165 rows pass at 6 seeds; 33 rows / 8 seeds after the merge).
2. **New survivor classes in `scripts/fl41_survivors.py`:** `range` (a narrower or wider read, a jump or a compare that the interval of the operand shows equal), `masked read` (width change under a mask/cast with the store operand identical), `copy count` (`shr ecx,N` before `rep movs/stos`: a top-bit-set count would copy 2 GiB or more, which faults in the original; faulting runs are not compared), `flags` (dead flags after a widened `repne scas`/`repe cmps`), relation-based jump equivalence (neighbouring condition equal when the compared values are proven in a relation).
3. **Targeted hardening** (`scripts/fl45_targeted.py`): probes the cells and values at the mutated instruction and tries those as seeds; stub-return values can now be overridden per scenario (`tests/fl41_world.py` `STUB_OVR`, cells `0xfff00000 + 16k + {0,4,8}`).
4. **`tests/fl41_mutation_check.py`:** killers are added to the corpus on disk (fresh read) instead of a stale copy; `FL45_STRICT_HANG=<json {row: [mutant hash]}>` reruns only those mutants, each scenario in its own child with a 2-5 s alarm (`FL45_STRICT_ALARM`), a hang kills nothing, a crash by another signal does.
5. Pipeline scripts: `fl45_merge.py` (a `fl41_generate.py --out-dir` run into src/corpus/tests/pending), `fl45_merge_logs.py` (last run per row), `fl45_prune.py` (credited-before rows + clean rows stay; the rest go to pending).

## Assumptions the new proofs make (review these)

- Frame: a plain `push ebp; mov ebp, esp` prologue, no address of a slot taken, pushes land below the named slots (same as FL-43).
- Callee-saved registers are preserved across calls (same as the translation's model); callees are recording stubs.
- 2 GiB user address space (the copy-count rule); the masked-read rule ignores a fault on an extra byte read past the original's.

## Not done / next

- 47 of the 83 checked rows still have unexplained survivors (`width` on arguments and stub-return slots; `drop` reloads needing store-to-load forwarding, e.g. `0x4a140b`, `0x4a3884`; `literal`/`jump` neighbours). Ideas: store-forwarding with value numbering on `[reg+disp]`, `lea` of frame slots allowed in the frame check, a step-budget non-termination argument for the hang-only rows (only if Glib accepts it).
- 80 larger rows were never mutation-checked (hours each).
- `tests/fl40_mutation_check.py` was guarded by FL-44; no remaining alarm bug known there.
- Verification: full suite on the branch before the merge of main (359 files, 4 at a time): 136 failing files; the same 136 on clean main (`d7ca9d8a`) leave 132 failing there; the other four were `test_extract_function_evidence` and `test_function_ledger` (stale evidence hash after an edit of the mutation checker; pass after regeneration) and `test_fl29c_differential` and `test_action_family_ee_runtime` (load flakes; pass alone). After merging main (PR 169) the FL-40/41/43/44 tests, function names/ledger/evidence/xrefs tests, fl29c and ee pass; `test_record_function_execution` fails as on main. The whole suite was not rerun after that merge.
