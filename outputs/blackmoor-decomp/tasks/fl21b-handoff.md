# FL-21 batch b handoff

Branch `worktree-agent-a3efd1b0a84ffbb94` (worktree `.claude/worktrees/agent-a3efd1b0a84ffbb94`), baseline 12229e36. The commit is the tip of that branch (see the final report). The run was split at the tool-call budget: all five ports and all five differential tests are done, direct tests exist for two of the five functions.

## Ported symbols (src/original_methods_fl21b.c/.h, `Fl18Host` convention, `Fl21bWorld`)

| va | symbol | differential (300 scenarios, full instruction coverage) | direct C test |
|---|---|---|---|
| 0x4468fe | `m4468fe_draw_clock` | PASS | PASS |
| 0x47f421 | `m47f421_pointer_hit` | PASS | PASS |
| 0x48569e | `m48569e_handle_key` | PASS | NOT WRITTEN |
| 0x44e035 | `m44e035_draw_panel` | PASS | NOT WRITTEN |
| 0x44da08 | `m44da08_run_state` | PASS | NOT WRITTEN |

Dropped: none. No x87 loop, `__chkstk` frame or self-modifying code was found in any of the five.

## What remains (for the next worker)

1. Direct C tests `test_m48569e_handle_key`, `test_m44e035_draw_panel`, `test_m44da08_run_state` in `tests/fl21b_direct_test.c` (add `RUN(...)` in `main` before `/* RUN-END */`, new cases before `/* TESTS-CONTINUE */`), plus their entries in `EXPECTED` and one method each in `tests/test_fl21b_direct.py`. The harness helpers (call log with probes, queued returns and out-writes, tick events, regions) are already there; `test_m47f421_pointer_hit` is the template. Planned coverage is the one in the packet: 0x48569e gates, keys 0x2779/0x277c/0x2778/0x2777/0x277b/0x277a, common tail; 0x44e035 plain and non-plain sub-modes, outline loop, flag cleared; 0x44da08 states 0/1/2/other, each `self[0x2d]` case, tick events, 0x4f6334 results.
2. Acceptance entries for those three functions (the snippet `tasks/fl21b-acceptances.json` deliberately contains only 0x4468fe and 0x47f421, because the other three would otherwise point at tests that do not exist). 0x44da08 must carry `blockers_reviewed` for `A-AA.1:3ee7bd6086aa9352` with a rationale of at least 40 characters.
3. Mutation checks for those three (see below for what was done).
4. Independent slice-reviewer pass over the whole batch.

## Test commands and results

- `cd outputs/blackmoor-decomp && python3 -m unittest tests.test_fl21b_direct tests.test_fl21b_differential` : 8 tests OK (3 direct incl. the all-cases check, 5 differential).
- Differential: original bytes under Unicorn with recording stubs at callee entry; per scenario it compares all writable memory, the return value, the ordered call log (tick included), bytes behind pointer arguments and call-time probes. 300 scenarios per function, 1500 total. Instruction coverage is full for every function body: 1478, 1520, 1539, 1519 and 1529 bytes.
- Hooks (all are host boundaries, none replaces a decision of the original): the callees 0x4c5d4b, 0x47f275, 0x47fd65, 0x47ec06 (0x47f421 and 0x4468fe); 0x484622, 0x4853b0, 0x485f12, 0x485ca1, 0x4846c2, 0x484f0d, 0x4841cb, 0x485d52, 0x484935 (0x48569e); the 0x44e035 callees recorded in the differential test; 0x44d711, 0x4d39f9, 0x4c2790, 0x4fb77a, 0x44d8ad, 0x4fb2e3, 0x4f6334, 0x4fba69, 0x44d946, 0x42ba3a, 0x44d154 (0x44da08); and GetTickCount (IAT slot 0x52a23c) as a `tick` event in both logs.
- ASan/UBSan: the direct binary built with `-fsanitize=address,undefined` runs both direct cases clean. Python differential runs cannot be sanitised (capstone uses RTLD_DEEPBIND), so sanitisers cover only the direct binary. Bounded malformed inputs in the direct tests: gate zero, empty strings, x wrap, negative table index.
- Mutation check (direct test, copy of the port in the scratchpad, script `mutate.py`): detected - 0x4468fe rectangle right edge without the -1; 0x47f421 bottom bound `<` to `<=`; pick-list x bound `<=` to `<`; 0x278e swapped for 0x278d; fallback byte test 1 changed to 2. Not detected, and an equivalent mutant: swapping the order of the two string copies at the end of 0x4468fe (the two destinations do not overlap, so the order is unobservable). No mutation run yet for 0x48569e, 0x44e035, 0x44da08.

## Divergences and known limits

- Uninitialised locals are zero. Unguarded divisions follow the original (`half_toward_zero` is `cdq; sub eax,edx; sar eax,1`). Word arguments compare by their low 16 bits.
- Pointers into the 0x5bb5e5 records are 32-bit original addresses resolved through `host->resolve`; pointers to locals and `self` are host pointers. `block_638600`, `table_5d1599`, `records_5bb5e5` and `flags_585801` are host buffers addressed at original offsets.
- The inlined string idioms (`strlen` via `repne scasb`, strcpy via `rep movsd` then `rep movsb`) are reproduced as forward copies. With an overlapping source and destination (0x4468fe, a first string longer than 0x1e) the original corrupts its own terminator and the next `strlen` runs on; the native port does the same, which is unsafe on unterminated input. The direct test plants a zero byte to bound that read. No native rejection of this case was added (no behaviour invented); it is a documented limit.
- The differential fixture for 0x44da08 uses record indices 0..3 and no slack, because the globals 0x5bb57b.. overlap record -1.
- `tests/test_fl21b_dbg.py` is an untracked debug copy and is not part of the commit.

## Unverified branches

Direct (hand-derived) coverage is missing for 0x48569e, 0x44e035 and 0x44da08; they are verified only by the differential test (every instruction reached, 300 scenarios). Branch values the random fixtures cannot reach by construction (for example a table index outside the slack) are not covered.
