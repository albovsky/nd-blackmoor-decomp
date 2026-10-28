# FL-77 handoff: Mac-port rows by scenarios, and the documented-exception tier

Thread: "Clear remaining Mac-port rows (FL-77)". Stopped at Glib's request ("Go with your recs", Oct 28, 2026 1:41 PM PDT: stop the ledger tail). No row is in progress.

## Result

- PR 263 (batch 1): tested equivalent 0x41c7f4 0x4662d8 0x480e02 0x4deed7 0x452576 0x4ec9a2 0x4eeb23 0x4bca71 0x46f986; proved 0x4181c6.
- PR 267 (batch 2): tested equivalent 0x4899ca 0x4e4cb6; proved 0x41e647 (971/971 instructions, 83/84 directions plus one proved direction).
- FL-75's PR 266 (using FL-77 scenario files) proved 0x4a2180 0x420c17 0x4a4f58.
- Ledger after all three: verified ported 2,210 of 4,188 (unchanged), tested equivalent 1,732 (103 by proof). Mac-port view (Game + Vorbis, 2,685): ported 2,209, tested equivalent 457, documented exceptions 19, pending 0.
- This PR (tier): the documented-exception tier below.

## Documented exceptions (new tier)

A documented exception is a pending function the project stopped working on and wrote down why. It is never ported, never tested equivalent, never in the verified count, and it changes no status or class: it is a slice of pending listed beside the entries, exactly like the tested-equivalent tier.

- Manifest: `tasks/fl77-exceptions.json` (schema `blackmoor-documented-exceptions/1`, rule `X-DOC-EXCEPTION`): reason codes with texts, and one row per function with a reason and a note. Written by `python3 tasks/fl77/make_exceptions.py --write`, which refuses to run while any pending function that is not tested equivalent has no entry (Mac-port rows are listed in `MAC_ROWS` in that script; CRT/MFC rows by rule). Rerun it, then `build_function_ledger.py --write`, after any change to the tested-equivalent or infeasible manifests.
- Ledger: key `documented_exceptions` (count, vas, by_reason, reasons, rows). `validate_documented_exceptions` refuses a function that is not pending, is tested equivalent, has an unknown reason or is counted wrongly. Tests: `tests/test_fl77_exceptions.py`.
- Map: `decomp-progress/generate.py` and `template.html` show a fifth tier (purple hatched) beside tested equivalent in the Mac-port panel, the region bars and the table (status filter "Documented exception", reason and note in the row details). The Mac-port panel's pending figure is pending minus tested equivalent minus exceptions. Rows of the compact table have a new eighth element (the exception flag).
- The committed `decomp-progress/` outputs (index.html, progress.json, REPORT.md, preview.png) were NOT regenerated in this PR: `generate.py` fails on main with "evidence stale" until `record_playable_status.py --seed` is rerun, and the playable status is Codex's to refresh. The next map build (fresh clone, seed, generate, as in the usual recipe) shows the tier.

### Mac-port rows (19)

| Row | Reason | Note |
| --- | --- | --- |
| 0x4090ab | `no_scenarios_yet` | 4,446-byte function; no scenario got past the entry (0 of 1,421 instructions). |
| 0x40b34a | `partial_coverage_gate_not_built` | Large loader with two switches (0x40b4ff, 0x40bab7); baseline 1,568 of 5,261 instructions and 87 of 362 directions, the hand-built switch state was not finished. |
| 0x413187 | `no_scenarios_yet` | 0 of 1,123 instructions; every search run timed out. |
| 0x418e52 | `needs_frame_assumption_in_prover` | Left: the je at 0x419886 taken. Eight lea of frame objects are passed to member calls. Coverage reached: 545 of 716 instructions, 47 of 68 jump directions. |
| 0x425b8b | `no_scenarios_yet` | 0 of 246 instructions; every search run timed out. |
| 0x448d11 | `no_scenarios_yet` | 0 of 647 instructions; no scenario got past the entry. |
| 0x456516 | `needs_alias_model_in_prover` | Left: the jns at 0x456a0b fall-through. Needs a pointer into the stack (19 lea of frame addresses). Coverage reached: 459 of 462 instructions, 65 of 66 jump directions. |
| 0x471722 | `needs_alias_model_in_prover` | One direction needs the `this` pointer aliased onto the record table (the only wild store is at 0x472063); a large dispatcher, and the solver ran out of memory. |
| 0x47c0f0 | `needs_alias_model_in_prover` | 758 of 758 instructions; one direction needs pointer overlap (3 KB function). |
| 0x48f181 | `impossible_direction_unproved` | 1,076 of 1,076 instructions and 145 of 146 directions; the jump at 0x48f3a2 taken is impossible by construction. check --prove ran for 722 s with the committed scenarios and did not discharge it. |
| 0x496410 | `partial_coverage_gate_not_built` | 24 KB function; baseline 366 of 4,985 instructions and 10 of 534 directions. |
| 0x49d945 | `needs_loop_invariants` | Crash path (idiv [ebp-0x70] at 0x49e06b), paired with 0x4a0ec3; the forward window loses the frame cell at three counting-loop headers. Coverage reached: 563 of 599 instructions, 73 of 76 jump directions. |
| 0x4a14c6 | `needs_callee_footprint_model` | One direction left; a copy is compared against its own source. Coverage reached: 437 of 437 instructions, 45 of 46 jump directions. |
| 0x4ba56a | `prover_window_times_out` | 71 of 98 directions from feasible gates; the function copies this+0x1bc..0x1c8 to this+0x1cc..0x1d8 and compares them. check --prove times out at 1,500 s (scenarios in tasks/fl76/out/0x4ba56a.json). Coverage reached: 690 of 761 instructions, 64 of 98 jump directions. |
| 0x4c1716 | `partial_coverage_gate_not_built` | Best search reached 495 of 1,019 instructions and 68 of 160 directions; the rest needs hand-built state. |
| 0x4e5fdb | `partial_coverage_gate_not_built` | Hand-built recipes reached 221 of 365 instructions and 18 of 32 directions (scenarios not committed); the long-string and second-switch cases are open. |
| 0x4e812f | `prover_window_times_out` | 10 directions and 39 instructions left, behind loops at 0x4e8212 and 0x4e851f; every window times out. |
| 0x4f0059 | `partial_coverage_gate_not_built` | Baseline 165 of 2,237 instructions and 31 of 510 directions; searches timed out. |
| 0x4f7207 | `needs_frame_assumption_in_prover` | Left: the jne at 0x4f74da fall-through (0x4f74e0). A frame buffer is handed to sprintf. Coverage reached: 568 of 569 instructions, 57 of 58 jump directions. |

FL-75's table (`tasks/fl75-handoff.md`) says what would clear its ten rows. For FL-77's nine rows the way forward is more hand-built state, not a prover: see "Lessons".

### CRT/MFC rows (99)

- `needs_multi_cell_or_aliased_state` (92): The search reached everything except a few jump directions that need three or more cells to line up (a pointer aliasing the function's own pushes, wrapped address arithmetic, tail jumps with moved stacks), and the prover answers reachable.
- `translation_mismatch_open` (3): New scenarios disagree between the translation and the original; the translation has a defect that has not been fixed.
  - 0x50c635 0x50c82b 0x51f4ec
- `census_unsplit_floor` (2): The census left this span unsplit (a floor), and the lifter refuses its jump tables into code, so it cannot be ported or tested.
  - 0x50ed50 0x50fa90
- `original_faults_on_every_scenario` (2): The original faults on every generated scenario, so there is nothing to compare against.
  - 0x510eda 0x510f3b

The full address list is in `tasks/fl77-exceptions.json`; CRT/MFC is supplied by macOS in the Mac-port view and still counts in the x86 view.

## Tools and lessons

- `tasks/fl77/pipe.py ROW OUT "[recipes]" base.json`: one recipe tool for stub returns (`ret`), callee stores (`wr`, with `('d', reg, [chain])` targets), compares (`cp`), register-relative cells (`cell`, `cellv`, `cells`) and call-index shifts (`shift`). Pointer chains are walked at the hook (Codex finding on PR 263). `pipef.py` reads the recipe list from a file; `rec4e.py` builds slot recipes for 0x4e4cb6; `thiscombo2.py` adds absolute paths.
- Image `.data` constants (for example 0x5438b4) are randomised per seed: a compare against one needs the constant overridden (`g` step).
- An extra stub call inserted by a recipe shifts the random draws of every later call; use `shift`, or make a later callee return an error value (`('ret', pc, 0, 0xffff)`) so the function leaves through its error path (0x4181c6).
- Filter out any scenario override inside the image (0x400000 to 0x530000) before `check`: a table pointer moved by `psetall.py` can land in code and make the original and translation disagree (0x4899ca).
- A markup parser such as 0x41e647 needs sequences, not single tags: flags carried between tags (0x13f8, 0x141c) are only set by an earlier tag, and a tag argument beginning with `r` selects another path. A generator of random tag sequences over a few letters, run through `pipe.py` with `MAXHIT=1`, took it from 794 to 971 instructions.
- `fl68_search.py` accepts `--scen` seeds and works for rows with zero coverage; it did not finish the large rows in 20 minutes (0x4c1716 reached 495 of 1,019 instructions, 0x4e5fdb 221 of 365).
- Helpers' own results are credited only after `check --redo --prove` in a clean tree; run the long `--prove` checks in the background and one row per process.
