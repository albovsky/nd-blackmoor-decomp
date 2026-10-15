# RT-17: view navigation producer (selector writers and the edge/arrow pointer cascade), the tutorial gallery becomes clickable

Root assigns this to a Sonnet (high) `slice-implementer`; one independent `slice-reviewer` afterwards. Base: `claude/rt-15-a17-runtime` (RT-13 0x79, RT-14 0x36 and RT-15 0x16..0x19 are in it; RT-16 raw 0x0b is built separately). Supersedes the never-run `RT-10-edge-cascade` packet for the navigation half of the pointer cascade.

## Why

RT-15's review confirmed that S6401's raw 0x17 hotspot (row 6) is hot only when the view selector word `0x5bb50b` is 2..6. S6400 enters S6401 with selector 1. The original moves the selector with the tick's navigation block (`0x43c1f4..0x43c941`) driven by the edge/arrow state `0x5a4c18`, which the pointer cascade `0x4f0059` computes from the cursor position (`0x4f18fa..0x4f1dc4`) and which also makes the cascade return before its generic row loop (`0x4f1e78`). Native sets the selector at scene entry and never moves it; the cascade tail is not modelled; the cascade members before `0x4f104f` rest on an assumed `priority_clear`.

## Outcome

1. Recovery from the original (addresses, widths, signedness, ordering) of: the zone decision and the arrow cursor choice, the tick navigation step (gates, rate limit, selector and scroll updates), the cascade's early-out structure `0x4f0059..0x4f1e78`, the producers of every global these read, and their values in the tutorial scenes (S6400..S6409) and S0/S5900/S4700.
2. `src/session_navigation.[ch]`: pure kernel (zone decision, step, cascade early-out contract) with an original-x86 Unicorn oracle (enumerated OS/host hooks only, state and ordered effects compared after every step), tests written first, sanitizer driver, mutation check.
3. Wired into the app's pointer path: `priority_clear` / the early-out and the selector update come from the recovered logic; the chosen cursor index is logged (no cursor sprite is drawn: the app has no cursor path). Unrecovered producers are named and use the value the scenes provably have.
4. Live (`--inspect-live-session`, scripted, no `--test-selector`): from S6401 a hover on the navigation zone moves the selector 1 to 2, row 6 becomes hot, a click on it reaches S6402. `--live-click-row 34` stays unchanged.

## Ownership

New `src/session_navigation.[ch]`, `scripts/build_session_navigation.sh`, sanitizer driver, tests and oracle, evidence `work/analysis/slices/RT-17.*`. Minimal edits only where evidence requires: `src/blackmoor_app.mm`, `scripts/build_native_app.sh`, `tests/test_native_app.py`, session_input / RT-14 / RT-15 files. Not `scene_resource.c`, other families' kernels, `decomp-progress/`, status docs, `playable-status.json`. Never modify `work/original`, the GOG install or GAME.EXE. No GUI, no audio device.

## Acceptance

Failing tests first; every branch cited to addresses; unverified list explicit; full suite `work/tools/oracle-python/bin/python -m unittest discover -s outputs/blackmoor-decomp/tests -p 'test_*.py'` passes twice; `-Wall -Wextra -Wpedantic -Werror`; mutation check runs the oracle and the native tests; ASan/UBSan on bounded malformed input; handoff `work/analysis/slices/RT-17.handoff.json`. If the whole navigation is too large, stop at the cleanest boundary and say what remains. Commit early and often, no push.
