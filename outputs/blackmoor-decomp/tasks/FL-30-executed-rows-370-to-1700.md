# FL-30 packet: pending game rows of 333 to 1,650 bytes, no receipt blocker

Read first: `tasks/FL-29-small-executed-rows.md` (same bar, same file shapes, same rules, same environment; this packet changes the list and the numbering to `fl30<x>`), the FL-29 handoff in `COORDINATION-STATUS.md`, `tasks/fl29a-handoff.md` and the files it names (`src/original_methods_fl29a.c/.h`, `tests/fl29a_*`, `tasks/fl29a-acceptances.json`). Through it `tasks/FL-24-session-input-handlers-2.md` items 1 to 6.

## Why

27 pending game rows with a recorded oracle window and no receipt blocker, larger than FL-29's rows. `function-evidence.json`, `function-ledger.json`, `function-execution.json` and `function-ledger-overrides.json` are read-only for you. A new original-only oracle must run every code byte (N/N) before a port is credited.

## Batches (smallest first; commit after each finished function)

- `fl30a`: 0x4f61e7 (333), 0x484762 (467), 0x484ac0 (495), 0x44b3c8 (633), 0x47ef0f (654), 0x4d270b (1301), 0x4c36b2 (1451).
- `fl30b`: 0x44b26a (350), 0x488e9c (447), 0x4c5b3a (529), 0x42e844 (579), 0x411f24 (660), 0x4cbba9 (969), 0x4d214b (1472).
- `fl30c`: 0x4fcb5c (406), 0x423876 (442), 0x434025 (536), 0x41b6e2 (579), 0x43d7f0 (675), 0x4c334f (867), 0x4763b3 (1650).
- `fl30d`: 0x4e2e05 (421), 0x4c2a8d (429), 0x48d3cb (553), 0x4f684a (564), 0x414692 (693), 0x41137f (751).

Disjoint symbols (`m<va>_<name>`), world structs (`Fl30aWorld` ...), shims, tests, fixtures, oracle scripts, handoffs: no shared file edits. Do not touch any function outside your list. Other native code naming these addresses stays as it is; the new one-to-one function is separate.

## Rulings (root, from the coordinator and AGENTS.md)

- A function with an unreachable block behind an always-true guard (for example `mov reg,1; test reg,reg; je`, a `jns` after a callee that cannot return negative) stays pending: drop it and write the disassembly reason in the handoff.
- A function where only some jump directions can never be taken but every instruction runs may be credited; flag each such edge in the handoff and in the differential's allowlist with a reason.
- Library rows never count. A receipt blocker clears only via `blockers_reviewed` with a 40+ character reason (none expected here).
- Functions over about 25 tool calls each: drop them back to the pool with a written reason. Larger rows (the 1,300 to 1,650 byte ones) go last in each batch; skip them early rather than spend the run on them.
- Callees, vtable entries, renderer, sound, text, scene layer and Win32 imports through IAT slots: host stubs that pop their arguments and return scripted `eax`; script both outcomes of every callee result that feeds a branch. `rep` string moves, x87, `jmp [reg*4+table]` switches and loops that call out: same width and order as the original.

## Environment

`work` is a real directory at `/home/user/nd-blackmoor-decomp/work` (GAME.EXE and evidence); in your worktree symlink it at the worktree root. `pip` has `unicorn capstone pefile`. Disassembly helper: `python3 /tmp/claude-0/-home-user-nd-blackmoor-decomp/68962358-cdf6-5334-a7f1-9cb0742eea8a/scratchpad/disasm_va.py <nbytes> 0x<va>`. No xcrun: tests fall back to clang. Run slice tests only (`python3 -m unittest tests.test_fl30<x>_direct tests.test_fl30<x>_differential` from `outputs/blackmoor-decomp`). No `rm`, no `worktree remove`, nothing chained, never touch `/dev`. Do not call any `mcp__hearthbot__` tool. Do not push. Commit only your owned files with the trailer `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>`. Budget about 120 tool calls (stop and write the handoff if you pass it); write `tasks/fl30<x>-handoff.md` (ported symbols, dropped with reason, divergences and unverified branches, hooks, test commands and results, oracle N/N per function, mutation survivors, branch and commit).
