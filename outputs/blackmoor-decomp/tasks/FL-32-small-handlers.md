# FL-32 packet: 27 small pending game rows (50 to 103 bytes), no receipt blocker

Read first: `tasks/FL-31-struct-methods-47b-47d.md` and `tasks/FL-29-small-executed-rows.md` (same bar, same file shapes, same "Per function, environment and rules"; this packet changes the list and the numbering to `fl32<x>`), the FL-31 handoff in `COORDINATION-STATUS.md`, `tasks/fl31a-handoff.md` and the files it names (`src/original_methods_fl31a.c/.h`, `tests/fl31a_*`, `tests/test_fl31a_direct.py`, `tests/test_fl31a_differential.py`, `tasks/fl31a-acceptances.json`). Through it `tasks/FL-24-session-input-handlers-2.md` items 1 to 6.

## Why

Pending game rows (ledger class `none`, a few `partial_native`) of 50 to 103 bytes with no receipt blocker, no x87, no indirect jump, no `rep` string move except where named. None needs a recorded oracle window: the new original-only oracle (N/N instructions per function, both directions of every conditional jump) is what earns credit. `function-evidence.json`, `function-ledger.json`, `function-execution.json` and `function-ledger-overrides.json` are read-only for you. FL-30 (parallel thread) owns a disjoint list; do not touch its files.

## Batches (commit after each finished function)

- `fl32a` (toggle and scene-message handler families): 0x40425d (59), 0x404298 (59), 0x4042d3 (59), 0x4029a9 (71), 0x4029f0 (71), 0x402a37 (71), 0x4067eb (71), 0x406832 (71), 0x406879 (71).
- `fl32b`: 0x40a613 (82, `repe cmpsb`), 0x40a665 (82), 0x4a9f27 (60), 0x4b71f7 (50), 0x4781fa (68), 0x4afd3a (68), 0x4e04f3 (76), 0x454565 (75), 0x4a638a (82).
- `fl32c`: 0x44e78e (73), 0x44e7d7 (52), 0x44e95b (83), 0x43edac (63), 0x43ee69 (103), 0x4db090 (70), 0x4de53e (70), 0x4ea229 (64), 0x4fb2a6 (61).
- Spill (only if a row above is dropped early and you have budget; say so): 0x4d0abc (64), 0x4d0c17 (64), 0x4e01fb (64), 0x4cca9c (51), 0x446f77 (51), 0x4fce5e (50), 0x4d3ffe (69), 0x47a3d9 (61).

Many rows come in near-identical families (same shape, different constants or callee addresses). Write one symbol per row, citing its own address and carrying its own constants; a shared static helper is fine (as the three FL-31 `pick_variant` rows). Verify each row's constants against the disassembly separately; do not assume family members are identical. Disjoint symbols (`m<va>_<name>`), world structs (`Fl32aWorld` ...), shims, tests, fixtures, oracle scripts, handoffs: no shared file edits. Do not touch any function outside your list. Other native code naming these addresses stays as it is; the new one-to-one function is separate.

## Rulings (root, from the coordinator and AGENTS.md)

- A function with an unreachable block behind an always-true guard (`mov reg,1; test reg,reg; je`, a `jns` after a callee that cannot return negative) stays pending: drop it and write the disassembly reason in the handoff.
- A function where only some jump directions can never be taken but every instruction runs may be credited; flag each such edge in the handoff and in the differential's allowlist with a reason.
- Library rows never count. A receipt blocker clears only via `blockers_reviewed` with a 40+ character reason (none expected).
- Over about 25 tool calls per function: drop it back to the pool with a written reason.
- Callees, vtable entries, renderer, sound, text, scene layer and Win32 imports through IAT slots: host stubs that pop their arguments and return scripted `eax`; script both outcomes of every callee result that feeds a branch. `rep` string moves and loops that call out: same width and order as the original.

## Environment

`work` is a real directory at `/home/user/nd-blackmoor-decomp/work` (GAME.EXE and evidence, gitignored); in your worktree symlink it at the worktree root. `pip` has `unicorn capstone pefile`. Disassembly helper: `python3 /tmp/claude-0/disasm_va.py <nbytes> 0x<va>`. No xcrun: tests fall back to clang. Run slice tests only (`python3 -m unittest tests.test_fl32<x>_direct tests.test_fl32<x>_differential` from `outputs/blackmoor-decomp`). No `rm`, no `worktree remove`, nothing chained, never touch `/dev`. Do not call any `mcp__hearthbot__` tool. Do not push. Commit only your owned files with the trailer `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>`. Budget about 120 tool calls (stop and write the handoff if you pass it); write `tasks/fl32<x>-handoff.md` (ported symbols, dropped with reason, divergences and unverified branches, hooks, test commands and results, oracle N/N per function, mutation survivors, branch and commit) and `tasks/fl32<x>-acceptances.json` in the shape of `fl31a-acceptances.json` (notes 80 to 240 characters).
