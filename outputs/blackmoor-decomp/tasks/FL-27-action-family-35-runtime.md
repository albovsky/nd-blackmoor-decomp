# FL-27 packet: action family 0x35 runtime rows (the `action_family_35_runtime` pending pool)

Read first: `tasks/FL-26-session-input-and-62-interaction.md`, `tasks/FL-25-session-input-handlers-3.md`, `tasks/FL-24-session-input-handlers-2.md` (same bar, same file shapes, same "Per function" items 1 to 6 and "Environment and rules"; this packet only changes the list and the numbering), the FL-26 handoff in `COORDINATION-STATUS.md`, `tasks/fl26a-handoff.md`. Copy the shape of `src/original_methods_fl26a.c/.h`, `tests/fl26a_direct_test.c`, `tests/fl26a_differential_shim.c`, `tests/test_fl26a_differential.py`, `tests/test_fl26a_direct.py`, `tests/fl26a_fixtures.py`, `tests/fl26a_original_oracle.py`, `tests/fl26a_mutation_check.py`, `tasks/fl26a-acceptances.json`. The differential test also requires both directions of every conditional jump (allowlist of untaken edges with a reason).

## Why

These pending rows belong to the action 0x35 (movie) runtime (`src/action_family_35_runtime.c` and the 0x4bxxxx / 0x4c0xxx / 0x449xxx / 0x414xxx movie-player methods). Existing oracles run only part of their bodies or none (`executed_partial` or no window). A new original-only oracle scenario must run every code byte (N/N instructions) before a port is credited. `function-evidence.json` / `function-ledger.json` are read-only for you.

## Batches (span in bytes; smallest first; commit after each finished function)

- Batch a (`fl27a`): 0x4de214 (19), 0x4de1f5 (31), 0x44c479 (50), 0x4bee2c (51), 0x449d90 (55), 0x4bef85 (67), 0x4de2d8 (74), 0x4bee5f (84), 0x4befc8 (92), 0x4c2dfb (96), 0x4bef11 (116), 0x4bf098 (119), 0x4bf315 (119), 0x4159db (134), 0x4bf10f (139), 0x4c0c7d (194).
- Batch b (`fl27b`): 0x449bff (253), 0x449a94 (273), 0x4bf773 (308), 0x4161d1 (346), 0x4c2c3a (449), 0x4c0d3f (497), 0x4c5377 (532), 0x4c04e3 (657), 0x415db9 (722), 0x4497a0 (728), 0x414ceb (806), 0x4c2e97 (1208), 0x44c4c1 (1306).

Disjoint symbols (`m<va>_<name>`), world structs (`Fl27aWorld`, `Fl27bWorld`), shims, tests, fixtures, oracle scripts, handoffs: no shared file edits. Do not touch any function outside your list, nor `0x4bf9bb` (2,122) and `0x413187` (4,873), which are out of this slice. Other native code that already names these addresses (`action35_runtime_step`, `action35_runtime_worker_poll`, ...) stays as it is; the new one-to-one `m<va>_*` function is separate. A callee inside the list may be called natively or host-stubbed; say which in the handoff.

## What differs from FL-26

- Receipt blockers (`function-evidence.json` `functions[].blockers`): `0x4de2d8` (A-51 unverified item 1) and `0x4c5377` (S05 unverified item 0). A blocker clears only through `blockers_reviewed` in the acceptance, one `{"id": ..., "rationale": ...}` per blocker, rationale of at least 40 characters (shape in `tasks/fl26a-acceptances.json` / `tasks/fl21a-acceptances.json`). Read the located item in the disassembly first; if the oracle cannot reach the located branch, drop the function.
- Fixtures decide: the profile cycle must fail each guard in turn and take every switch arm, loop exit and default arm; the oracle prints N/N instructions per function. A last instruction no legal fixture can reach (for example behind `mov reg,1; test reg,reg; je`) means the function stays pending: drop it with the disassembly reason, do not credit it (owner ruling).
- Several of these call the movie/Bink layer or Win32 imports through IAT slots: stub at the host boundary (recording stubs that pop their arguments and return scripted `eax`), script both outcomes. A callee that changes `self` or a global the function re-reads is not exercised (say so in the handoff). x87 code, `rep` string moves and loops that call out: same width and order as the original.
- The default is to land finished ports and send the rest back to the pool with a written reason.
- Existing hits on these addresses in `tests/` (action 0x35 oracles) are evidence of partial windows only; the new oracle is `tests/fl27<x>_original_oracle.py` and must stand on its own.

## Per function, environment and rules

Same as FL-24 (items 1 to 6, environment, rules) with the numbering `fl27<x>`. Setup already in this container: `export PATH=/tmp/claude-0/shim:$PATH` (xcrun wrapper), `/private/tmp` links to `/tmp`, `pip` has `unicorn capstone pefile`, `work` must be symlinked at your worktree root to `/home/user/nd-blackmoor-decomp/work` (evidence: `work/original/GAME.EXE`), disassembly helper `python3 /tmp/claude-0/disasm_va.py <nbytes> 0x<va>`. Run slice tests only. No `rm`, no `worktree remove`, nothing chained. Do not call any `mcp__hearthbot__` tool. Do not push. Commit only your owned files with a `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>` trailer. Budget about 120 tool calls; write `tasks/fl27<x>-handoff.md` (ported symbols, dropped with reason, divergences and unverified branches, hooks, test commands/results, oracle N/N per function, mutation survivors, branch and commit).
