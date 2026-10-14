# RT-1: live audio channel provider

Branch: `claude/rt-1-live-audio-channels`, from the `main` commit root gives you. Owner: a `slice-implementer`. Integrator (root thread) wires the module into `src/blackmoor_app.mm` after review; you do not edit the app.

## Why

The persistent S0 session applies ACT rows 0-30, renders the row-31 caption and then stops because the app's `load_sound`/`play_sound` callbacks return `ACTION_SOUND_BACKEND_UNSUPPORTED` (`reason=live-audio-channel-provider-unavailable`, `src/blackmoor_app.mm`, `native_action_sound_load`/`native_action_sound_play`). Every later scene also plays sound through the same `0x9f` handler, so this is the first runtime blocker on the way to a playable game.

## Outcome

A native audio channel provider that implements the `ActionSoundBackend` sound callbacks (`load_sound`, `play_sound`, `is_playing`, `unload_sound`; see `src/action_sound.h`) on top of the reviewed host pieces:

- `his_audio_decode_memory` / `his_audio_decode_file` (`src/his_audio.h`): HIS v2 to interleaved float PCM.
- `mac_audio_*` (`src/macos_audio.h`): the AVAudioEngine host, with `MAC_AUDIO_MODE_OUTPUT` for the app and `MAC_AUDIO_MODE_OFFLINE` for automated runs.

This is a native platform/codec adapter. It is not a reconstruction of the original CSound stream protocol (S04-2.2 stays paused) and must say so in its header comment. Do not claim original decoder or timing parity.

## Required behavior

1. **Asset lookup.** `<asset_stem> + ".his"` is resolved case-insensitively in the game directory's `CDSound` directory (the app's `inspect_audio_graph` shows the current lookup; do not copy its fixed 37-byte limit blindly, verify against `ACTION_SOUND_STEM_BYTES`). Exactly one match is required. Not found maps to `ACTION_SOUND_BACKEND_NO_RESOURCE` (the kernel then advances the phase without PlaySound), a decode or format failure to `ACTION_SOUND_BACKEND_ERROR`. Log the reason through a callback, not stdout.
2. **Channels.** `ACTION_SOUND_CHANNEL_COUNT` (32) independent channels indexed by `command->channel`. Reloading a loaded channel replaces its sound. Playing an unloaded channel is an error, not a silent success.
3. **Gain.** Final gain from the two independent gains in the command (`first_gain`, `second_gain`) multiplied, then the channel's volume category scalar from a provider-settable table that defaults to 1.0. Do not invent a mapping from `control_word`; retain it on the channel and expose it for inspection. If the recovered S04-1 `sound_control` module already defines a volume/gain contract (`src/sound_control.h`), read it and use it rather than duplicating it; report in the handoff what you reused.
4. **Playing state.** `is_playing` reports 1 from `play_sound` until natural completion as observed through `mac_audio_is_playing`, and 0 after completion, stop or unload. It must not block, drain the whole sound or synthesize completion from elapsed wall time. `unload_sound` stops and frees the channel. A looping sound is out of scope unless the command's mode requires it; if it does, report what you found rather than guessing.
5. **Ownership.** All host calls run on the main thread, as `macos_audio.h` requires. The provider owns decoded PCM per channel and frees it on unload and destroy. `destroy` stops everything and closes the host it created (or leaves a caller-supplied host alone; pick one and document it).
6. **Modes.** Output mode for the live app. Offline mode for automated tests, with a way for tests (and later the headless session driver) to advance the offline render by a given number of frames, so completion can be observed deterministically over several ticks.
7. **Stale completion.** Channel generations: a completion callback or poll from a replaced/unloaded sound must not mark the new sound complete.

## Ownership

New files only: `src/live_audio.h`, `src/live_audio.mm` (or `.c` plus an `.mm` shim if you can keep the C part pure), `scripts/build_live_audio.sh`, `tests/test_live_audio.py`, `tests/live_audio_fixture.c` (or `.mm`) as needed, and uniquely named evidence under `work/analysis/slices/RT-1.*`. Existing `macos_audio`, `his_audio`, `action_sound` and `sound_control` are read-only; propose interface changes in the handoff instead of editing them.

## Acceptance

- Fixture tests written first and seen to fail before the implementation: asset lookup (case-insensitive, missing, ambiguous, oversized stem), channel bounds, reload, play-before-load, gain composition, is_playing lifecycle over repeated polls with an offline host advancing a few thousand frames per poll (no early completion, then completion), stop/unload mid-play, stale completion after reload, free-everything on destroy.
- One end-to-end test with the real shipped `NSHT01.HIS` from the owner's install (path from `work/analysis/game-source.json`; skip cleanly if absent): load on a channel, play, poll to completion in offline mode, assert rendered frame count matches the decoded frame count and PCM is finite and non-silent. Do not commit or print resource bytes.
- ASan/UBSan run of the unit fixtures, and a mutation check (e.g. skip the generation check, ignore the gain product, drop the NO_RESOURCE mapping) that the tests detect.
- `scripts/build_live_audio.sh` is warning-clean under the same flags as the other module scripts (`-Wall -Wextra -Wpedantic -Werror`).
- Handoff `work/analysis/slices/RT-1.handoff.json`: commit, baseline, files, build and test commands, what was reused from `sound_control`, hashes of the module sources, enumerated host hooks, and an explicit list of unverified behavior (hardware output, original attenuation curve, control_word semantics, looping).

The Mac is unlocked, so a short real-output smoke test is allowed: play a few hundred milliseconds of NSHT01 in output mode, check the call sequence succeeds, then stop. Nobody can hear it in this environment; do not claim it sounds right.

Do not edit `blackmoor_app.mm`, the central build script, or the sound action kernel. Do not mark any larger gate complete.
