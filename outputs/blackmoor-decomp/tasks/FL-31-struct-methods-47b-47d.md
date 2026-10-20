# FL-31 packet: pending game rows of 31 to 290 bytes (the 0x47b..0x47d cluster and neighbours), no receipt blocker

Read first: `tasks/FL-29-small-executed-rows.md` (same bar, same file shapes, same "Per function, environment and rules"; this packet changes the list and the numbering to `fl31<x>`), the FL-29 handoff in `COORDINATION-STATUS.md`, `tasks/fl29a-handoff.md` and the files it names (`src/original_methods_fl29a.c/.h`, `tests/fl29a_*`, `tests/test_fl29a_direct.py`, `tests/test_fl29a_differential.py`, `tasks/fl29a-acceptances.json`). Through it `tasks/FL-24-session-input-handlers-2.md` items 1 to 6.

## Why

26 pending game rows whose ledger class is `candidate_port`, no receipt blocker, no x87, no indirect jump, 290 bytes or less. None has a recorded oracle window, so the new original-only oracle (N/N instructions per function, both directions of every conditional jump) is what earns credit. `function-evidence.json`, `function-ledger.json`, `function-execution.json` and `function-ledger-overrides.json` are read-only for you. FL-30 (parallel thread) owns a disjoint list; do not touch its files.

## Batches (smallest first; commit after each finished function)

- `fl31a` (struct accessors around 0x47b200): 0x47b200 (31), 0x47b3bc (52), 0x47d640 (55), 0x47b709 (94), 0x47ba79 (102), 0x47badf (119), 0x47b321 (155), 0x47c049 (167), 0x47b23b (230).
- `fl31b`: 0x4c946b (36), 0x4ee673 (43), 0x4daeb5 (60), 0x4dadff (103), 0x420b9e (121), 0x47d1c3 (139), 0x4fc878 (145), 0x47d4f7 (164), 0x47d59b (165).
- `fl31c`: 0x4e2faa (145), 0x4c2790 (264), 0x4eba54 (263), 0x4edb97 (282), 0x4db870 (291), and the three near-identical rows 0x47cd90, 0x47ce6f, 0x47cf4e (223 each; share one static helper like the FL-29 record copies, one symbol each citing its own address).
- Spill (only if a row above is dropped early and you have budget; say so): 0x4c7623 (333).

Disjoint symbols (`m<va>_<name>`), world structs (`Fl31aWorld` ...), shims, tests, fixtures, oracle scripts, handoffs: no shared file edits. Do not touch any function outside your list. Other native code naming these addresses stays as it is; the new one-to-one function is separate.

## Rulings (root, from the coordinator and AGENTS.md)

- A function with an unreachable block behind an always-true guard (`mov reg,1; test reg,reg; je`, a `jns` after a callee that cannot return negative, e.g. `rand & 0x7fff`) stays pending: drop it and write the disassembly reason in the handoff.
- A function where only some jump directions can never be taken but every instruction runs may be credited; flag each such edge in the handoff and in the differential's allowlist with a reason.
- Library rows never count. A receipt blocker clears only via `blockers_reviewed` with a 40+ character reason (none expected).
- Over about 25 tool calls per function: drop it back to the pool with a written reason.
- Callees (including CRT calls such as 0x50cd50, 0x516530, 0x51dc6c), vtable entries, renderer, sound, text, scene layer and Win32 imports through IAT slots: host stubs that pop their arguments and return scripted `eax`; script both outcomes of every callee result that feeds a branch. `rep` string moves and loops that call out: same width and order as the original.

## Environment

`work` is a real directory at `/home/user/nd-blackmoor-decomp/work` (GAME.EXE and evidence); in your worktree symlink it at the worktree root. `pip` has `unicorn capstone pefile`. Disassembly helper: `python3 /tmp/claude-0/disasm_va.py <nbytes> 0x<va>`. No xcrun: tests fall back to clang. Run slice tests only (`python3 -m unittest tests.test_fl31<x>_direct tests.test_fl31<x>_differential` from `outputs/blackmoor-decomp`). No `rm`, no `worktree remove`, nothing chained, never touch `/dev`. Do not call any `mcp__hearthbot__` tool. Do not push. Commit only your owned files with the trailer `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>`. Budget about 120 tool calls (stop and write the handoff if you pass it); write `tasks/fl31<x>-handoff.md` (ported symbols, dropped with reason, divergences and unverified branches, hooks, test commands and results, oracle N/N per function, mutation survivors, branch and commit) and `tasks/fl31<x>-acceptances.json` in the shape of `fl29a-acceptances.json` (notes 80 to 240 characters).
