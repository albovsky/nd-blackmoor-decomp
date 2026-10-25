# NATIVE-03: persistent game-only audio mute

The human requested complete game mute while using other Mac audio, and continued room navigation without the crash-producing tests. The original root chat retains publication authority (tests, independent review, one PR per slice, merge). Existing restrictions on original installation/EXE, game-source descriptor, ledger/evidence/extract/build outputs, tests/fl40_* and tasks/flNN-handoff.md remain in force. Root owns shared app/audio integration; the Codex gpt-6.1-sol xhigh audio worker owns only the two new mute test files in its separate worktree. No delegate publishes.

Baseline main: `8c0e693d10593ed74b8a8e94f770c911b8fb9a0c` (PR179 merged). Native gameplay remains incomplete.

## Behavior

Persist `BlackmoorAudioMuted` in this app's NSUserDefaults domain, `com.blackmoor.reconstruction`, with `--mute` and `--unmute` launch options. Defaults remain unchanged when neither is supplied. At audio host creation, the native engine's main mixer reads the setting and sets its output volume to zero when muted. This covers ordinary channels and the independent movie-audio bus, including later-created players. It does not change the Mac's system volume, other apps, original game data, per-channel gains, play/stop state, decoding, scheduled frames or completion callbacks.

This is a native host convenience requested by the owner, not an original-engine reconstruction or sound-equivalence claim. Mute is applied before playback can start. Existing runs must be relaunched to pick up the preference; changing a live mixer through an app settings screen is outside this slice. Root immediately paused only BlackmoorNative while preparing this change, so repeated dialogue stopped without changing system settings.

## Focused acceptance

- Offline real AVAudioEngine integration with synthetic PCM: an unmuted control produces finite nonzero output; the muted master produces only zero samples for multiple simultaneous slots and natural completion still occurs for each. A late-created slot must remain muted too.
- The test uses a volatile NSArgumentDomain preference in its own process; it must not write persistent user preferences, use original assets or open an output device. Normal failures return nonzero; no deliberate faults, assert/abort, sanitizer, mutation or original-x86 runs.
- App build passes. Launch `--mute` against the real data; verify the preference and app log, visible startup/input, and persistence across a subsequent launch without the flag.
- Record source/native hashes, meaningful baseline failure, focused results, independent frozen-commit review and remaining limits before merge.

No broad suite will run: its existing sanitizer/mutation children caused macOS crash dialogs. The known broader build/test failures remain recorded in NATIVE-01; no green-suite claim follows from this slice.

## Validation and pins

Meaningful baseline failure against main8c0e: synthetic ordinary/movie peaks0.25/0.375 while mute was requested; both natural completions occurred, then the check returned1 normally. The identical focused test passes after integration: muted peaks0/0, unmuted control0.25/0.375, two natural completions in each subcase (1test,1.918s; `work/playability-20261024/mute-focused.log`). The second slot is connected after the first play starts the engine, so the test also covers a player added to the running graph. It uses only process-local volatile preferences and an offline graph.

Normal ARM64 app builds (`mute-build.log`). Root launched the real-data GUI with `--mute`: `muted-gui.log` reports `native_audio_output_muted=1`; `defaults read com.blackmoor.reconstruction BlackmoorAudioMuted` returns1. A second metadata-only invocation without either flag also reports1 (`mute-persisted-no-flag.log`), proving saved preference lookup without another output device. Root did not run `--unmute` on a real GUI, to honor the owner's request for continued silence. Physical speaker capture is unverified; the real mixer’s zero PCM output is measured by the offline check.

| Artifact | SHA-256 |
|---|---|
| Original GAME.EXE, unchanged | `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` |
| `src/blackmoor_app.mm` | `8cecca24f3271831e892f31550edc1218062844d024c995902f504efcf733555` |
| `src/macos_audio.mm` | `b2875c62dc36afca0f919bdcae7a94cb41e6d918bc01080094d026ee6eeef6df` |
| Normal ARM64 app | `bb647c3ec8d48742322647085d3826fea5f64e49206c85eb7719e117c831cbcf` |

A broad SIGTERM restart command was rejected by automatic review because it could affect other native test instances. Root inspected actual process state and used the supported safer alternative: only the specific paused GUI test PID62360 was replaced. The independent offline room-investigation process was preserved. No system audio preference or original game file changed.

Remaining limits: mute is read at host creation; no live settings UI or hardware capture was added. Command-line `--unmute` is implemented but not exercised in a real GUI. Offline audio naturally completes under mute; exact original sound timing/mixer parity remains unverified. No ledger, function evidence or whole-game completion claim is changed.
