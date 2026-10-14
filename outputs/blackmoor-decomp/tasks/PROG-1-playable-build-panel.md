# PROG-1: "Playable build" panel in the progress report

Branch: `codex/prog-1-playable-panel`. Worker: Codex `gpt-6.1-sol` at `xhigh`. One independent reviewer.

## Why

`outputs/blackmoor-decomp/decomp-progress/generate.py` (PR 2) only tracks x86 match bytes, so none of the playable-build work moves the map. Glib wants to see progress after every merged slice.

## Outcome

Extend the generator (and `template.html`, `README.md`, `test_progress.py`) with a "Playable build" panel computed from repo data only (no original bytes, no private `work/` data):

1. **Scenes reached** by the scripted live run, out of the total scene count (2,078 scenes in the corpus per `action-census-current.json`), plus the ordered list of reached scenes and the current stop (scene, row, action type, provider).
2. **Action types**: typed vs opaque (census), and for typed ones handled natively vs unsupported in the live session. Derive "handled" from source, not by hand: built-in executor types (`scene_executor.c`/`action_core`), session bindings registered in `blackmoor_app.mm` / `session_bindings_*`, and external handlers. State the derivation in the README and fail the test if the derived list and the registrations drift.
3. **Tests**: discovered/passed/skipped from a committed status field.
4. A short "Next blocker" line.

Because the live run needs the owner's game files, commit a small evidence file, `outputs/blackmoor-decomp/playable-status.json` (schema-versioned), written by a new script `scripts/record_playable_status.py` that runs `--inspect-live-session --live-click-row 34 --live-ticks 3000` (when the game is available), parses the log lines `scene_transition_applied`, `live_session_end`, `scene_session_blocked`, `scene_transition_error`, and merges the test totals from `status.json`. The generator reads only the committed JSON. Never embed log lines containing resource bytes; scene ids, row numbers, type codes and counts only. Seed the file from the current state: reached S0, S5900, S5907, S5901-S5906; stop = S5906 -> S4700 load failure on opaque 0x35 row 3 (other rows 0x97 now typed in main); 774 tests, 769 passed, 5 skipped.

Keep the existing x86 panel and treemap unchanged. Render the new panel at the top (it is what is moving). Regenerate `index.html`, `REPORT.md`, `progress.json` and `preview.png` (as the existing generator does) and make sure `test_progress.py` passes with the pinned schema. Write times, if any, in US Pacific time (never UTC).

## Ownership

`decomp-progress/*`, `scripts/record_playable_status.py`, `playable-status.json`, `tests/test_record_playable_status.py`. Do not edit native sources or other status docs. Never touch GAME.EXE or the game install. Commit only owned files; end commit messages with `Co-Authored-By: Codex <noreply@openai.com>`. Handoff in `work/analysis/slices/PROG-1.handoff.json`.
