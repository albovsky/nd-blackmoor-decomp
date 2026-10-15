# RT-11: do sounds persist across scene transitions in the original? Replace the blanket unload

Root (Claude Code) assigns this to a Codex `gpt-6.1-sol` xhigh implementer; one independent `slice-reviewer` afterwards. Base: current `main`.

## Why

`perform_session_transition` in `src/blackmoor_app.mm` (~line 3668) calls `live_audio_unload_all` on every scene change. That was an unverified choice: the original may keep looping/ambient sounds across a continuation transition, stop only some channels, or fade them. The handoff recorded that S5907 row 6 behaves differently with the blanket unload. Audio is half of the game's atmosphere (S4700's cinematic and every ambient bed), so a wrong rule is audible in the first minutes.

## Outcome

1. Recover from the original (REA skill in AGENTS.md; objdump of `work/original/GAME.EXE`) exactly what happens to sound channels, streams and loop state when a scene change is requested and applied: the scene-teardown path (find it from the scene loader `0x40b34a` caller, `session_exit`/RT-5 notes, the sound manager `0x4f5651..`, `0x4f6334`, the 0x9f/0x97 completion code with its unload mode and transition tuple globals, `0x42ba3a`), the continuation vs fresh-scene distinction, whether channels carry over, per-channel flags (loop, music vs effect), and any fade. Cite addresses and hash the code windows. Check against the scripted live run: which sounds are playing when each of the transitions S0->S5900->S5907->S5901..S5906->S4700->S4710... happens (the log has `live_audio loaded/started` lines) and what the original rule would do for each.
2. Implement the recovered rule in the audio/transition path (`src/live_audio.c`, `src/session_exit.[ch]`, `perform_session_transition`), with an original-x86 oracle where the teardown code is runnable (hooks only for OS/mixer boundaries, enumerated) or, if it is not isolable, the strongest static evidence plus a driven scenario test; say plainly which. Where the original rule cannot be proven, keep the current behaviour and name the unproven part.
3. Tests: failing first; scenario tests over the transition sequences above asserting which channels survive; mutation checks (always-unload, never-unload, wrong channel set). Re-run the scripted live run and report channel state across each transition with log lines. Offline audio only; the root pass does the listening check.

## Ownership
`src/live_audio.[ch]`, `src/session_exit.[ch]`, `src/blackmoor_app.mm` (transition path, minimal), `src/action_sound.[ch]` only for a proven defect, new tests/oracle files, `scripts/build_native_app.sh`, `tests/test_native_app.py`. Not `decomp-progress/`, status docs or `playable-status.json`. Evidence in `work/analysis/slices/RT-11.*`. Never modify `work/original`, the GOG install or GAME.EXE. No GUI, no computer use, no audio device.

## Acceptance
As RT-10: failing tests first, addresses cited, unproven listed, full suite passes (run twice after a fresh merge), `-Wall -Wextra -Wpedantic -Werror`, handoff `work/analysis/slices/RT-11.handoff.json`, commit on your branch only (no push), message ends `Co-Authored-By: Codex <noreply@openai.com>`, no model identifiers.
