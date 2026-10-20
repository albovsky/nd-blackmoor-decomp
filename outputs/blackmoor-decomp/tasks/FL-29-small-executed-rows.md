# FL-29 packet: small pending rows already executed by recorded oracles (no receipt blockers)

Read first: `tasks/FL-28-action-family-a1-3f-3e-2d-runtime.md` (same bar, same file shapes, same "Per function" items and "Environment and rules"; this packet only changes the list and the numbering), the FL-28 handoff in `COORDINATION-STATUS.md`, `tasks/fl28b-handoff.md`, and through it `tasks/FL-24-session-input-handlers-2.md`. Copy the shape of `src/original_methods_fl28b.c/.h`, `tests/fl28b_direct_test.c`, `tests/fl28b_differential_shim.c`, `tests/test_fl28b_differential.py`, `tests/test_fl28b_direct.py`, `tests/fl28b_fixtures.py`, `tests/fl28b_original_oracle.py`, `tests/fl28b_mutation_check.py`, `tasks/fl28b-acceptances.json`. The differential test also requires both directions of every conditional jump (allowlist of untaken edges with a reason).

## Why

These are the pending game rows under 370 bytes with no receipt blocker that some recorded oracle already executes (`function-execution.json`), but not through every code byte under a function-level oracle. A new original-only oracle scenario must run every code byte (N/N instructions) before a port is credited. `function-evidence.json`, `function-ledger.json`, `function-execution.json` and `function-ledger-overrides.json` are read-only for you.

## Batches (span in bytes from the ledger; smallest first; commit after each finished function)

- Batch a (`fl29a`, autotext, 36/37, 1c, 28 and caption families): 0x4d39f9 (89), 0x4c4202 (92), 0x4c948f (93), 0x4d3992 (103), 0x4c92c5 (123), 0x4c9340 (232), 0x4c46d1 (277), 0x4cb9d1 (303), 0x4895cc (342), 0x4c3efb (364).
- Batch b (`fl29b`, 78/79, 20/70/80, 33, 76, 83, 47, sound and UI families): 0x4ee69e (41), 0x423aae (67), 0x4fccf2 (91), 0x423a30 (126), 0x42e72c (140), 0x4e9c2f (176), 0x4e45be (193), 0x437dcd (212), 0x4e4337 (241), 0x411a22 (244).
- Batch c (`fl29c`, bink, hiff, 28, da, d1, d3 families): 0x4bf19a (86), 0x434814 (108), 0x4471ca (176), 0x45b4ae (186), 0x461903 (187), 0x4b5c5c (187), 0x45bbd8 (233), 0x4630a3 (302), 0x43423d (357), 0x4344bf (369).
- Spill (only if a row above is dropped early and you have budget): 0x4f61e7 (333), 0x44b26a (350). Say so in the handoff.

Disjoint symbols (`m<va>_<name>`), world structs (`Fl29aWorld`, `Fl29bWorld`, `Fl29cWorld`), shims, tests, fixtures, oracle scripts, handoffs: no shared file edits. Do not touch any function outside your list. Other native code that already names these addresses (`action_family_*`, `hiff*`, `bink*` sources) stays as it is; the new one-to-one `m<va>_*` function is separate. A callee inside the list may be called natively or host-stubbed; say which in the handoff.

## What differs from FL-28

- None of these has a receipt blocker. Several are `partial_native` (a native window exists but the oracle executes only part of it); the new original-only oracle is what counts.
- Fixtures decide: the profile cycle must fail each guard in turn and take every switch arm, loop exit and default arm; the oracle prints N/N instructions per function. A last instruction no legal fixture can reach (for example behind `mov reg,1; test reg,reg; je`) means the function stays pending: drop it with the disassembly reason, do not credit it (owner ruling: unreachable blocks behind always-true guards stay pending).
- Callees, vtable entries, renderer, sound, text or scene layer and Win32 imports through IAT slots: stub at the host boundary (recording stubs that pop their arguments and return scripted `eax`), script both outcomes. A callee that changes `self` or a global the function re-reads is not exercised (say so in the handoff). x87 code, `rep` string moves, `jmp [reg*4+table]` switches and loops that call out: same width and order as the original.
- The default is to land finished ports and send the rest back to the pool with a written reason. If a function needs more than about 25 tool calls, drop it.
- Existing hits on these addresses in `tests/` (action oracles) are evidence of partial windows only; the new oracle is `tests/fl29<x>_original_oracle.py` and must stand on its own.

## Per function, environment and rules

Same as FL-24 (items 1 to 6, environment, rules) with the numbering `fl29<x>`. Setup in this container: no xcrun is needed (tests fall back to clang); `pip` has `unicorn capstone pefile`; `work` must be symlinked at your worktree root to `/home/user/nd-blackmoor-decomp/work` (evidence: `work/original/GAME.EXE`); disassembly helper `python3 /tmp/claude-0/disasm_va.py <nbytes> 0x<va>`. Run slice tests only (`python3 -m unittest tests.test_fl29<x>_direct tests.test_fl29<x>_differential` from `outputs/blackmoor-decomp`). No `rm`, no `worktree remove`, nothing chained. Do not call any `mcp__hearthbot__` tool. Do not push. Commit only your owned files with a `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>` trailer. Budget about 120 tool calls (split the run if you pass it); write `tasks/fl29<x>-handoff.md` (ported symbols, dropped with reason, divergences and unverified branches, hooks, test commands/results, oracle N/N per function, mutation survivors, branch and commit).
