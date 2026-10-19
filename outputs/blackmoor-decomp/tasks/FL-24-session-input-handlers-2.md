# FL-24 packet: session input handlers, second pass (scenario extension plus one-to-one ports)

Read first: `tasks/FL-23-session-input-handlers.md` (same bar, same file shapes, same rules; this packet only changes the list and the numbering), the FL-23 handoff in `COORDINATION-STATUS.md`, and `tasks/fl23a-handoff.md` / `tasks/fl23b-handoff.md`. Copy the shape of `src/original_methods_fl23b.c/.h`, `tests/fl23b_direct_test.c`, `tests/fl23b_differential_shim.c`, `tests/test_fl23b_differential.py`, `tests/test_fl23b_direct.py`, `tests/fl23b_fixtures.py`, `tests/fl23b_original_oracle.py`, `tasks/fl23b-acceptances.json`.

## Why

`tests/session_input_original_oracle.py` reaches these handlers (hit-test handlers from `0x4f0059`, click and state handlers from `0x43a7ca`, plus a few constructor-style methods), but only their first 30 to 75 bytes, so the ledger records `executed_partial` windows. A function counts as fully executed only when a recorded oracle run executed every code byte of it. FL-23 fixed 23 of the 73; these are the next ones, by size. Each function is a chain of guards on the object (`this` = ecx), the record state `dword [n*0x8d + 0x5bb632]`, and the selector `[0x5c39e5]`; the fixtures must walk every arm.

## Batches (span in bytes from the ledger; smallest first; commit after each)

- Batch a (`fl24a`): 0x4d3bef (46), 0x44edfb (466), 0x4cb3ab (475), 0x44eab1 (510), 0x46ebff (545), 0x4571e1 (572), 0x47b4aa (607), 0x4a6574 (639), 0x4a6946 (664), 0x470ffe (690), 0x482724 (740), 0x465c99 (757).
- Batch b (`fl24b`): 0x4dad60 (159), 0x466073 (468), 0x467740 (506), 0x4b7563 (538), 0x459e49 (562), 0x482359 (572), 0x46793a (612), 0x4ad310 (640), 0x4acf45 (672), 0x4aa0f0 (738), 0x487ed5 (756), 0x464c59 (764).

Both batches share nothing: disjoint symbols (`m<va>_<name>`), world structs (`Fl24aWorld`, `Fl24bWorld`), shims, tests, fixtures, oracle scripts. No shared file edits.
Do not touch `0x469057`, `0x4897cd`, `0x4b42d3`, `0x4e0978` (receipt blockers), `0x4f0059`, `0x43a7ca`, `0x4d3073`, `0x4477d1`, or anything outside your list.

## What differs from FL-23

- These are bigger (up to 760 bytes) and some contain a `jmp [reg*4+table]` switch whose index table and jump table sit inside the span (for example 0x466073: table at 0x466237). The ledger counts only code bytes as executed, so tables are not part of the coverage target, but every switch arm must be reached and ported, and the out-of-range default arm too.
- `rep movsd` / `movsb` copies of a nine-byte-compared record, `repe cmpsb`, `imul`, `movsx`, `sbb`/`neg` boolean idioms: port them with the same width and order. Callees are host calls (stubs record and pop their arguments, scripted `eax`); a callee that changes `self` is not exercised (state it in the handoff).
- 0x4dad60 calls the IAT slot `0x52a498` (argument 0x17); stub it at the host boundary like GetTickCount in FL-23 and script both results (zero and non-zero). 0x4d3bef tests the byte `0x61c6ae`; the existing oracle never makes it non-zero, so the fixture must.
- The fixtures decide success: the profile cycle must fail each guard in turn and pass each selector, switch value, loop count and flag combination, so that the oracle reports N/N instructions per function. A function whose last unreached instruction cannot be reached by any legal fixture is reported as an unreachable edge with the disassembly reason (as 0x4b2bdf in FL-23); if the instruction itself cannot run, drop the function.
- Drop (with a written reason) what you cannot finish. The default is to land the finished ports; the rest go back to the pool.

## Per function (same as FL-23 items 1 to 5)

1. One native C function in `src/original_methods_fl24<x>.c/.h`, original address cited, control flow, field widths and call/store order one to one.
2. Direct test (`tests/fl24<x>_direct_test.c`, `tests/test_fl24<x>_direct.py`): whole-object checks, ordered host calls, call-time probes, both sides of every branch, signed and word boundaries, hand-derived from the disassembly.
3. Unicorn differential (`tests/fl24<x>_differential_shim.c`, `tests/test_fl24<x>_differential.py`, generator in `tests/fl24<x>_fixtures.py`): original bytes vs native on the same fixtures, callee state snapshotted at host calls.
4. Oracle script `tests/fl24<x>_original_oracle.py` (original bytes only, no native library, name contains `oracle`, not `test_`), asserting N/N instructions per function, one summary line per function with a digest, exit 0 only if all assigned functions are fully covered; clean as a plain script from `outputs/blackmoor-decomp` and under `BLACKMOOR_EXEC_TRACE_DIR=<dir> PYTHONPATH=scripts/exec_trace`. Hooks at OS or host boundaries only.
5. `tasks/fl24<x>-acceptances.json` (shape of `tasks/fl23b-acceptances.json`; window = start to `start + span`). Do not edit `function-ledger.json`, `function-ledger-overrides.json`, `function-evidence.json` or `function-execution.json`.
6. A mutation script `tests/fl24<x>_mutation_check.py` as in FL-23 (survivors listed and explained in the handoff).

## Environment and rules

- `export PATH=/tmp/claude-0/shim:$PATH` (xcrun wrapper, already installed), `/private/tmp` links to `/tmp`, `pip` has `unicorn capstone pefile`. Evidence: `work/original/GAME.EXE` (a `work` symlink exists at `/home/user/nd-blackmoor-decomp/work`; symlink it at the worktree root). Disassembly is the source of truth, not ledger names. A disassembly helper: `python3 /tmp/claude-0/disasm_va.py <nbytes> 0x<va>`.
- Uninitialised locals zero; unguarded divisions as in the original; word args compare by their low 16 bits; list every deliberate divergence.
- Run slice tests only (`python3 -m unittest tests.test_fl24<x>_direct tests.test_fl24<x>_differential` from `outputs/blackmoor-decomp`), not the full suite.
- No `rm`, no `worktree remove`, nothing chained; the container is ephemeral. Do not call any `mcp__hearthbot__` tool. Do not push. Commit only your owned files with a `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>` trailer.
- Budget: stop at about 120 tool calls. Write `tasks/fl24<x>-handoff.md`: functions ported (symbols), dropped (why), divergences and unverified branches, hooks, test commands and results, oracle instruction coverage per function, branch and commit.
