# RT-9: Bink playback for the 0x35 MOVIE controller (frames, audio, completion)

Root (Claude Code) assigns this to a Codex `gpt-6.1-sol` xhigh implementer; one independent `slice-reviewer` afterwards. Branch `codex/rt-9-bink-movie` is stacked on `codex/rt-8-a97-runtime` (PR to follow) which is stacked on RT-7 (PR 15). Keep that history; root merges in order.

## Where the live game stops

After RT-7 and RT-8 the scripted run (`--inspect-live-session --live-click-row 34 --live-ticks 3000`, offline audio, no window) reaches S4700, initializes the row-3 movie (a Bink branch, EXT_OpnCin_ANIM, 504 frames, mode word +0x27 = 2, nine frame events, view selector 0), runs the 0x97 rows 11-13, then stops at `scene_session_blocked stage=3 provider=action-family-35 action=3 type=0x35` (phase 1 visit): "Bink frame/audio or rectangle provider" is unbound. All 113 corpus 0x35 rows are Bink (A-35.1 corpus, RT-7 review), so this is the whole family's playback.

## What exists

`src/action_family_35_runtime.[ch]` (RT-7) is the reviewed lifecycle kernel and `src/session_bindings_a35.[ch]` binds it with typed host callbacks; the phase-1 helper is `0x4c04e3` (Bink) and the original calls into the Bink SDK per tick (BinkDoFrame / BinkNextFrame / BinkWait / BinkCopyToBuffer and the audio mix). The native timed Bink player is `src/bink_player.[ch]` + `src/bink_adapter.[ch]` (FFmpeg decode, timestamp pacing, `bink_player_set_mode`, RGBA frame borrow). **It ignores audio packets.** RT-7's handoff (`work/analysis/slices/RT-7.handoff.json`, `RT-7.controller.dis`) lists exactly which providers the kernel leaves to the host. `src/blackmoor_app.mm` already opens a Bink for the S0 background (`scene_video_open`, `app->video`) and one for A-28 (`app->movie_video`): reuse that machinery, do not duplicate it.

## Outcome

Make the S4700 row-3 movie actually run in the live session, in the original's tick order, as far as recovered evidence honestly allows:

1. **Recover** the exact per-tick contract of the Bink branch from the original (`0x4c04e3`, `0x4c0ab1`, `0x4c08d3`, the due/decode/next/render/copy sequence, frame events/triggers, the rectangle path, completion into phase 2 and the scene trigger/event flags the nine frame events and the final entry fire). Cite addresses; keep the RT-7 oracle style (original-x86 where the original code is runnable with hooks only for the Bink SDK, OS and surface boundaries, every hook enumerated).
2. **Implement the providers** in a new `src/session_bindings_a35_bink.[ch]` (or an extension you justify) behind the existing RT-7 host interface: frame due/decode/advance against `bink_player`, rectangle/surface presentation into the scene viewport surface the app already composes, frame events and triggers, completion. Audio: Bink embeds its soundtrack; add a minimal native extraction (new module, e.g. `src/bink_audio.[ch]`, FFmpeg audio decode of the same file) that feeds the existing `live_audio` mixer through a channel, with a headless PCM-hash evidence path (no output device in tests). If the original's audio mixing rules (volume, track select, pan, start/stop with the movie, interaction with the scene's other sounds) cannot be proven, name the unproven rule and keep the behaviour minimal, never invent a gain or channel.
3. **Wire** into `src/blackmoor_app.mm` and `scripts/build_native_app.sh` only as needed; keep the unbound-provider UNSUPPORTED behaviour for anything left out.
4. **Drive the live run**; report the new stop row/provider with log lines and, for frames, a presented-frame count and a hash of a few frames' RGBA (no pixel dumps committed). If the movie completes, report where the scene goes next. The Mac is unlocked, but window and listening checks are a root pass afterwards; do not open a window or an audio device.

## Ownership

You may edit: new `src/session_bindings_a35_bink.[ch]`, `src/bink_audio.[ch]`, build scripts and tests/oracles for them; minimally `src/session_bindings_a35.[ch]`, `src/action_family_35_runtime.[ch]` (only for a defect you prove against the original; say so loudly), `src/blackmoor_app.mm`, `src/scene_session.[ch]`, `scripts/build_native_app.sh`, `tests/test_native_app.py`, `tests/test_scene_session.py`. Do not edit `bink_player.[ch]`/`bink_adapter.[ch]` except for a proven defect, other families' kernels, `scene_resource.c`, `decomp-progress/`, status docs or `playable-status.json`. Evidence in `work/analysis/slices/RT-9.*`. Never modify `work/original`, the GOG install or GAME.EXE. No GUI, no computer use, no audio device.

## Acceptance

- Failing tests first, baseline recorded; every provider cited to original addresses; unproven items listed.
- `work/tools/oracle-python/bin/python -m unittest discover -s outputs/blackmoor-decomp/tests -p 'test_*.py'` passes (1,094 tests, 5 skips today); build clean under `-Wall -Wextra -Wpedantic -Werror`.
- Mutation checks that actually kill wrong due/advance/trigger/completion rules (RT-7's oracle was found weak on unmatched-view-after-frame sequences and same-frame duplicate events; cover those).
- Handoff `work/analysis/slices/RT-9.handoff.json` (commit, baseline, files, commands, results, hashes, unverified list, new live stop). Commit only owned files on your branch, no push; message ends `Co-Authored-By: Codex <noreply@openai.com>`, no model identifiers.
