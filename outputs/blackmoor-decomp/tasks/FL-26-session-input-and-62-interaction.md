# FL-26 packet: last session-input rows and the 0x62 interaction rows

Read first: `tasks/FL-25-session-input-handlers-3.md` and `tasks/FL-24-session-input-handlers-2.md` (same bar, same file shapes, same "Per function" items 1 to 6 and "Environment and rules"; this packet only changes the list and the numbering), the FL-25 handoff in `COORDINATION-STATUS.md`, `tasks/fl25a-handoff.md` .. `tasks/fl25d-handoff.md`. Copy the shape of `src/original_methods_fl25a.c/.h`, `tests/fl25a_direct_test.c`, `tests/fl25a_differential_shim.c`, `tests/test_fl25a_differential.py`, `tests/test_fl25a_direct.py`, `tests/fl25a_fixtures.py`, `tests/fl25a_original_oracle.py`, `tests/fl25a_mutation_check.py`, `tasks/fl25a-acceptances.json`. The differential test also requires both directions of every conditional jump (allowlist of untaken edges with a reason).

## Why

These rows still have `executed_partial` windows (the existing oracles run only part of the body) or no full window. A new original-only oracle scenario must run every code byte (N/N instructions) before a port is credited. The ledger tools that cite them are `function-evidence.json` / `function-ledger.json` (read-only for you).

## Batches (span in bytes from the ledger; smallest first; commit after each finished function)

- Batch a (`fl26a`, session input): 0x4d3073 (196, a `jmp [edx*4+0x4d3127]` switch on `[0x583204]-2`, four arms plus `ja` default, callees are host calls), 0x469057 (407), 0x4897cd (509), 0x4b42d3 (572), 0x4e0978 (1203).
- Batch b (`fl26b`, 0x62 interaction path): 0x423fbb (62), 0x4eb107 (125), 0x424201 (325), 0x42406d (404), 0x42ea87 (717), 0x4eb184 (1134), 0x424346 (1890).

Disjoint symbols (`m<va>_<name>`), world structs (`Fl26aWorld`, `Fl26bWorld`), shims, tests, fixtures, oracle scripts, handoffs: no shared file edits. Do not touch any function outside your list, nor `0x4b5d17`, `0x47b767`, `0x43a7ca`, `0x4f0059`, `0x4477d1`. Other native code that already names these addresses (for example `scene_dependencies_reduce`, `evaluate_random`, `session_navigation_scan`) stays as it is; the new one-to-one `m<va>_*` function is separate.

## What differs from FL-25

- Several rows have receipt blockers in `function-evidence.json` (`functions[].blockers`: items like `unverified` / `unverified_branches` with an id). A blocker clears only through `blockers_reviewed` in the acceptance, one `{"id": ..., "rationale": ...}` per blocker, rationale of at least 40 characters that says what covers the item (shape in `tasks/fl21a-acceptances.json`, `tasks/fl21b-acceptances.json`). Read the located item in the disassembly before writing the rationale; if the oracle cannot reach the located branch, say so and drop the function.
- Fixtures decide: the profile cycle must fail each guard in turn and take every switch arm, loop exit and the out-of-range default arm; the oracle prints N/N instructions per function. A last instruction no legal fixture can reach is an unreachable edge with a disassembly reason (as `0x4b5d17` in FL-25: that one was dropped); if the instruction itself cannot run, drop the function.
- Callees are host calls (recording stubs that pop their arguments and return scripted `eax`); a callee that changes `self` or a global the function re-reads is not exercised (state it in the handoff). Loops that call out, x87 and `rep` string moves: same width and order as the original.
- The default is to land finished ports and send the rest back to the pool with a written reason. 0x424346 (1,890 bytes) is the most likely drop.
