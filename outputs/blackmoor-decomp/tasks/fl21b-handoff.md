# FL-21 batch b handoff

Branch `worktree-agent-a3efd1b0a84ffbb94` (worktree `.claude/worktrees/agent-a3efd1b0a84ffbb94`), baseline 12229e36. The commit is the tip of that branch (see the final report). All five functions are ported, each with a direct C test and a Unicorn differential test, and the acceptance snippet has five entries. An independent slice-reviewer pass has not been done.

## Ported symbols (src/original_methods_fl21b.c/.h, `Fl18Host` convention, `Fl21bWorld`)

| va | symbol | differential (300 scenarios, full instruction coverage) | direct C test |
|---|---|---|---|
| 0x4468fe | `m4468fe_draw_clock` | PASS | PASS |
| 0x47f421 | `m47f421_pointer_hit` | PASS | PASS |
| 0x48569e | `m48569e_handle_key` | PASS | PASS |
| 0x44e035 | `m44e035_draw_panel` | PASS | PASS |
| 0x44da08 | `m44da08_run_state` | PASS | PASS |

Dropped: none. No x87 loop, `__chkstk` frame or self-modifying code was found in any of the five.

## Acceptance snippet

`tasks/fl21b-acceptances.json` holds five `native_oracle_verified` entries shaped like the FL-20 `port_acceptances`, each with three test pointers, the oracle window (start, start plus the span) and `parts_accounted []`. 0x44da08 carries `blockers_reviewed` for `A-AA.1:3ee7bd6086aa9352`: the A-AA.1 receipt lists the handler 0x44da08 (reached from the 0xaa arm 0x42a66e) as an unverified branch; this port is that handler and its states are covered; the arm and its gate 0x423f57 are not part of the port. Root merges the snippet; the ledger files were not touched.

## Test commands and results

- `cd outputs/blackmoor-decomp && python3 -m unittest tests.test_fl21b_direct tests.test_fl21b_differential` : 11 tests OK (6 direct including the all-cases check, 5 differential).
- Differential: original bytes under Unicorn with recording stubs at callee entry; per scenario it compares all writable memory, the return value, the ordered call log (tick included), bytes behind pointer arguments and call-time probes. 300 scenarios per function, 1500 total. Instruction coverage is full for every function body: 1478, 1520, 1539, 1519 and 1529 bytes.
- Direct tests (`tests/fl21b_direct_test.c`): expectations are hand-derived from the disassembly, not taken from the port. They check whole objects (self, table, flag table, record state), the ordered host-call log (callee, ecx, arguments, bytes behind host pointers) and call-time probes of state at each call, and branch boundaries (strict vs inclusive compares, unsigned tick compares, signed word fields, dword tests with zero low words).
- Hooks (all are host boundaries, none replaces a decision of the original): the callees 0x4c5d4b, 0x4c5377, 0x47f275, 0x47fd65, 0x47ec06, 0x44d9b5 (0x4468fe, 0x47f421, 0x44e035); 0x484622, 0x4853b0, 0x485f12, 0x485ca1, 0x4846c2, 0x484f0d, 0x4841cb, 0x485d52, 0x484935 (0x48569e); 0x44d711, 0x4d39f9, 0x4c2790, 0x4fb77a, 0x44d8ad, 0x4fb2e3, 0x4f6334, 0x4fba69, 0x44d946, 0x42ba3a, 0x44d154 (0x44da08); and GetTickCount (IAT slot 0x52a23c) as a `tick` event in both logs.
- ASan/UBSan: the direct binary built with `-fsanitize=address,undefined` (-O1 and -O2) runs all five cases clean. The Python differential runs cannot be sanitised (capstone uses RTLD_DEEPBIND), so the sanitisers cover the direct binary only; the differential fixtures are bounded by construction (record indices 0..3, slack, planted terminators).
- Mutation check on the direct tests (copies of the port in the scratchpad, script `mutate.py` and `mutate2.py`): 32 mutations tried, 31 detected. The one that is not detected is an equivalent mutant (swapping the two non-overlapping string copies at the end of 0x4468fe). Detected: 0x4468fe rectangle right edge without the -1; 0x47f421 bottom bound `<` to `<=`, pick-list x bound `<=` to `<`, 0x278e swapped for 0x278d, fallback byte test 1 changed to 2; 0x48569e selector 0x277c changed, extent word stored at the wrong offset, the 0xa92 test inverted, branch A storing 0 in 0xb83, 0x485d52 called after the 0xa92 store, the -1 test changed; 0x44e035 mode 8 not plain, mode 2 plain test changed, a constant off by one (sub-mode 4 and an outline), redraw flag not cleared, byte 0x624ce3 set to 1, destination built from the source offset, selector b zero-extended; 0x44da08 tick compares `>` instead of `>=` (both), word 0x2af zero-extended, flag word compared with 2, flag index -1 test changed, state 7 stored as 8, 0x4f6334 argument zero-extended, the 0x20 gate inverted, string copied one byte off, last two calls swapped, nine-byte compare shortened to eight, byte 0x49 not cleared.

## Changes made while finishing

- `m44e035_draw_panel`: the selector shifts are now `(uint32_t)(int32_t)(int16_t)a << 4` instead of a shift of the negative signed value (UBSan flagged the signed left shift; the resulting bits are the same as the original's `shl`). The differential tests were re-run after the change.
- A direct-test fixture that let a patterned flag-table index run far outside the table was corrected (the original would write wild there too; the table index is the caller's contract).

## Divergences and known limits

- Uninitialised locals are zero. Unguarded divisions follow the original (`half_toward_zero` is `cdq; sub eax,edx; sar eax,1`). Word arguments compare by their low 16 bits.
- Pointers into the 0x5bb5e5 records are 32-bit original addresses resolved through `host->resolve`; pointers to locals and `self` are host pointers. `block_638600`, `table_5d1599`, `records_5bb5e5` and `flags_585801` are host buffers addressed at original offsets.
- The inlined string idioms (`strlen` via `repne scasb`, strcpy via `rep movsd` then `rep movsb`) are reproduced as forward copies. With an overlapping source and destination (0x4468fe, a first string longer than 0x1e) the original corrupts its own terminator and the next `strlen` runs on; the native port does the same, which is unsafe on unterminated input. The direct test plants a zero byte to bound that read. No native rejection of this case was added (no behaviour invented); it is a documented limit.
- 0x44da08 writes the flag table at a signed word index from the record without a range check, as the original does; the native port does not reject an out-of-range index either.
- The differential fixture for 0x44da08 uses record indices 0..3 and no slack, because the globals 0x5bb57b.. overlap record -1.
- `tests/test_fl21b_dbg.py` is an untracked debug copy and is not part of the commit.

## Unverified branches

Values that the fixtures cannot reach by construction (a table or flag index outside the slack, unterminated strings other than the planted case) are not covered. The callers of these functions (the dispatcher arm 0x42a66e and its gate 0x423f57 for 0x44da08, and the callees listed under hooks) are not part of this slice. No independent review has been done.
