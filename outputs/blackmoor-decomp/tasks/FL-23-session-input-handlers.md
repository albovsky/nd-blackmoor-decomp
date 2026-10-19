# FL-23 packet: session input handlers (new oracle scenarios plus one-to-one ports)

Read first: the FL-22 handoff in `COORDINATION-STATUS.md` ("Handoff: FL-22"), `tasks/FL-22-large-ports.md` (same bar, same file shapes) and `tasks/fl22b-handoff.md`. Copy the shape of `src/original_methods_fl22b.c/.h`, `tests/fl22b_direct_test.c`, `tests/fl22b_differential_shim.c`, `tests/test_fl22b_direct.py`, `tests/test_fl22b_differential.py`.

## Why

`tests/session_input_original_oracle.py` reaches 73 pending game functions (per-action hit-test and click handlers called from `0x4f0059` and `0x43a7ca`), but only their first 20 to 60 bytes: the oracle's hotspot has one type, so every handler leaves at its type guard. Ledger rows with `executed_partial` windows cannot be credited. A function counts as fully executed only when a recorded oracle run executed every byte of it (`function-execution.json`, FL-8).

## What each batch delivers

For each assigned function (smallest first; commit after each; drop with a written reason what you cannot finish):

1. One native C function in `src/original_methods_fl23<x>.c/.h` (`m<va>_<name>`, world struct `Fl23<x>World`, `Fl18Host` convention), following the original's control flow, field widths and call/store order one to one, citing the address. Callees are host calls (`args[0]` is the last pushed argument). The `this` object is ecx. Do not edit the runtime kernels.
2. A direct test (`tests/fl23<x>_direct_test.c`, `tests/test_fl23<x>_direct.py`): whole-object checks, ordered host calls with arguments, call-time probes, both sides of every branch, signed and word boundaries.
3. A Unicorn differential (`tests/fl23<x>_differential_shim.c`, `tests/test_fl23<x>_differential.py`): original bytes vs native on the same random and profile-driven fixtures, callee state snapshotted at host calls, every instruction of the function reached. The profile cycle must hit each guard combination (the handlers are chains of type and state guards; random data alone will not reach the deep arm).
4. **A new oracle script** `tests/fl23<x>_original_oracle.py` (the name must contain `oracle` and not start with `test_`, so `scripts/record_function_execution.py` discovers it). It runs ONLY the original bytes (no native library) through the same fixture generator the differential uses (put the generator and the original-run function at module level in the differential test module, or in a helper module you own, and import it; the differential test calls the same function). For each function it asserts that every instruction of the body ran, prints one summary line per function (`0x... instructions N/N scenarios M digest <sha256 of the ordered call and memory observations>`), and exits 0 only if all assigned functions are fully covered. It must also run clean as a plain script from `outputs/blackmoor-decomp` (`python3 tests/fl23<x>_original_oracle.py`) and under the FL-8 recorder shim (`BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace python3 tests/fl23<x>_original_oracle.py`). No original bytes or memory dumps in output. Hooks only at OS or host boundaries (callee entry stubs), listed in the handoff; nothing inside the function under test is patched.
5. The acceptance snippet `tasks/fl23<x>-acceptances.json` (shape of `tasks/fl22b-acceptances.json`): `class native_oracle_verified`, `native_source`, three `tests` pointers, `oracle` = {path `tests/fl23<x>_original_oracle.py`, window = the function's start and `start + span` from `function-ledger.json`}, `parts_accounted []`, a `note` of at most 240 characters, `reviewer` at most 80. Root records the oracle runs and merges the snippet; do NOT edit `function-ledger.json`, `function-ledger-overrides.json`, `function-evidence.json` or `function-execution.json`. If `audit_port_candidates.py --va 0x...` shows receipt blockers for a function, write `blockers_reviewed` (40+ characters each) or drop the function.

## Batches (span in bytes, from the ledger)

Batch a (`fl23a`, hit-test handlers called from `0x4f0059`): 0x47d734 (73), 0x4a1e16 (125, callee 0x4a1e93), 0x4ba377 (271, callee 0x4ba486), 0x459cc9 (275, callee 0x459ddc), 0x487c92 (317, callee 0x487dcf), 0x48a920 (326, callee 0x48aa66), 0x48e628 (334, callee 0x48e776), 0x479deb (391), 0x46ea16 (423, callee 0x46ebbd), 0x4b7389 (474), 0x4ab528 (478, callee 0x4ab706).

Batch b (`fl23b`, click and state handlers called from `0x43a7ca`): 0x4a1efd (92), 0x4ba4f2 (120), 0x46957d (122), 0x4b45ed (137), 0x473ffc (162, callee 0x4e26fc), 0x48e851 (237), 0x45e587 (246, callee 0x45e6bd), 0x48ab49 (329), 0x4ab899 (353), 0x4574e4 (358), 0x47a03c (365), 0x4b2a9e (404).

Both batches share nothing; no shared file edits. Use disjoint symbol, world, shim, test and oracle names (`fl23a`/`fl23b`). Leave the rows with a receipt blocker (0x469057, 0x4897cd, 0x4b42d3, 0x4e0978), `0x4f0059`, `0x43a7ca`, `0x4d3073` and everything outside your list alone.

## Rules (same as FL-22)

- Disassemble from `work/original/GAME.EXE` (capstone, pefile, unicorn are installed); the disassembly is the source of truth, not the ledger names or older native code.
- A function that cannot be ported faithfully (x87 loop, `__chkstk`, self-modifying, unreachable branch you cannot fixture) is dropped and reported, not faked.
- Uninitialised locals zero; unguarded divisions as in the original; word args compare by their low 16 bits; list every deliberate divergence.
- Tests proportional: direct + differential + oracle per function, no new frameworks.
- Environment: `export PATH=/tmp/claude-0/shim:$PATH` (an `xcrun` wrapper for clang), `/private/tmp` links to `/tmp`; `pip` has `unicorn capstone pefile`. Work in your worktree; symlink the evidence first: `ln -s /home/user/nd-blackmoor-decomp/work work` at the worktree root. Run slice tests only (`python3 -m unittest tests.test_fl23<x>_direct tests.test_fl23<x>_differential`), not the full suite.
- No `rm`, no `worktree remove`, nothing chained; the container is ephemeral. Do not call any `mcp__hearthbot__` tool. Commit only your owned files, with a `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>` trailer.
- Budget: stop at about 120 tool calls. Commit what is finished and write `tasks/fl23<x>-handoff.md`: functions ported (symbols), dropped (why), divergences and unverified branches, hooks, test commands and results, oracle instruction coverage per function, branch and commit.
