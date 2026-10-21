# FL-33 packet: pending game rows of 45 to 1,451 bytes (0x47d.., 0x4c.., 0x4f.. and neighbours), no receipt blocker

Read first: `tasks/FL-31-struct-methods-47b-47d.md` and `tasks/FL-30-executed-rows-370-to-1700.md` (same bar, same file shapes, same rules, same environment; this packet changes the list and the numbering to `fl33<x>`), the FL-30 and FL-31 handoffs in `COORDINATION-STATUS.md`, and `tasks/fl31a-handoff.md` with the files it names (`src/original_methods_fl31a.c/.h`, `tests/fl31a_*`, `tests/test_fl31a_direct.py`, `tests/test_fl31a_differential.py`, `tasks/fl31a-acceptances.json`). For the larger rows also `tasks/fl30a-handoff.md`.

## Why

22 pending game rows with ledger class `candidate_port`, no receipt blocker, no x87. None has a recorded oracle window, so the new original-only oracle (N/N instructions per function) is what earns credit. `function-evidence.json`, `function-ledger.json`, `function-execution.json` and `function-ledger-overrides.json` are read-only for you. FL-32 (parallel thread) owns a disjoint list of small rows in 0x40.. and 0x4a..0x4f; do not touch its files.

## Batches (smallest first; commit after each finished function)

- `fl33a`: 0x4dae88 (45), 0x473117 (52), 0x4234dd (144), 0x4c7623 (333), 0x4bf3b8 (370), 0x4db993 (384), 0x47d24e (388), 0x4c7070 (393).
- `fl33b`: 0x47d02d (406), 0x4c51a5 (466), 0x47df57 (477), 0x4c2898 (501), 0x4f594d (515), 0x41e3c0 (647), 0x4f5b50 (741), 0x41db40 (745).
- `fl33c`: 0x4c6929 (769), 0x416af3 (870), 0x4db38a (998), 0x4d2c20 (1107), 0x4f379c (1162), 0x4c36b2 (1451).

Disjoint symbols (`m<va>_<name>`), world structs (`Fl33aWorld` ...), shims, tests, fixtures, oracle scripts, handoffs: no shared file edits. Do not touch any function outside your list. Other native code naming these addresses stays as it is; the new one-to-one function is separate.

## Rulings (root, from the coordinator and AGENTS.md)

- A function with an unreachable block behind an always-true guard (`mov reg,1; test reg,reg; je`, a `jns` after a callee that cannot return negative, e.g. `rand & 0x7fff`, a zero-extended byte tested with `jl`) stays pending: drop it and write the disassembly reason in the handoff. (0x44cde2 and 0x4cf687 were checked already: thread loops behind `mov reg,1; test reg,reg; je`, left out of this packet.)
- A function where only some jump directions can never be taken but every instruction runs may be credited; flag each such edge in the handoff and in the differential's allowlist with a reason.
- Library rows never count. A receipt blocker clears only via `blockers_reviewed` with a 40+ character reason (none expected).
- Over about 25 tool calls per function: drop it back to the pool with a written reason. The larger rows go last in each batch; skip them early rather than spend the run on them.
- Callees (including CRT calls such as 0x50cd50, 0x516530, 0x51dc6c), vtable entries, renderer, sound, text, scene layer and Win32 imports through IAT slots: host stubs that pop their arguments and return scripted `eax`; script both outcomes of every callee result that feeds a branch. `rep` string moves, `jmp [reg*4+table]` switches and loops that call out: same width and order as the original.

## Environment

`work` is a real directory at `/home/user/nd-blackmoor-decomp/work` (GAME.EXE and evidence); in your worktree symlink it at the worktree root. `pip` has `unicorn capstone pefile`. Disassembly helper: `python3 /tmp/claude-0/-home-user-nd-blackmoor-decomp/ead61099-c8c8-517d-9f7f-56971a7f7924/scratchpad/disasm_va.py <nbytes> 0x<va>`. No xcrun: tests fall back to clang. Run slice tests only (`python3 -m unittest tests.test_fl33<x>_direct tests.test_fl33<x>_differential` from `outputs/blackmoor-decomp`). No `rm`, no `worktree remove`, nothing chained, never touch `/dev`. Do not call any `mcp__hearthbot__` tool. Do not push. Commit only your owned files with the trailer `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>`. Budget about 120 tool calls (stop and write the handoff if you pass it); write `tasks/fl33<x>-handoff.md` (ported symbols, dropped with reason, divergences and unverified branches, hooks, test commands and results, oracle N/N per function, mutation survivors, branch and commit) and `tasks/fl33<x>-acceptances.json` in the shape of `fl31a-acceptances.json` (notes 80 to 240 characters). The oracle run recording, acceptances merge, evidence, ledger and names regeneration are done by root afterwards; do not run `record_function_execution.py`, `extract_function_evidence.py` or `build_function_ledger.py` with `--write`.
