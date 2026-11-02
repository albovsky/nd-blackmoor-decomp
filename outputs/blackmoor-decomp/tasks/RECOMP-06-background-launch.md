# RECOMP-06: background native startup and capture

The recompiled Mac frontend now accepts `--background --mute`, creating the existing AppKit view and timer without ordering a window or activating the app. The legacy opener and its header remain unchanged. `--stop-after-ms N` accepts decimal1..600000; background mode defaults to5000ms. The deadline sends `NSApp terminate:` once through the normal Quit delegate and controlled cleanup. `--snapshot FILE.ppm` writes the640x480 logical framebuffer only after guest/worker and mixer threads have stopped and joined. This is framebuffer evidence, not a screenshot of a displayed window.

Authorization remains in the original Codex chat01a170c4-6fa4-7831-9a46-f076fbcfab37: the owner's pasted request says “Finish the native ARM64 macOS port”, “One slice per PR”, and “merge your own PR (squash).” This chat remains publisher. Background-only operation, no output device, immutable originals, scratch data and no prohibited crash/oracle tests apply. The owner explicitly reported the desktop unlocked; the passive session check here confirms an active logged-in console. No other app was controlled.

## Acceptance at 2026-11-02, 00:25 Pacific

A signed ARM64 candidate built at `/private/tmp/blackmoor-recomp-background-20261102.app`; executable SHA256 `8e765784cd8e634b38ab8ad747bc4648ae601f632a190fbbb105f8a4f6a499d9`. It used an independent APFS clone, scratch Documents5 and the read-only original executable SHA256 `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` (the receipt carries the authoritative full pin). Native run returned0 in5.49s. At open and stop: active0/key0/visible0/activation notifications0. It exercised `NSApp.terminate` once; no forced shutdown occurred. The captured logical frame shows the Nancy Drew/Blackmoor title splash. Assets/executable/INI inputs hashed before and after remain unchanged.

Private evidence: `work/recomp-playability-20261101/background-app-20261102/receipt.json`, `run.log`, `primary.ppm`/`primary.png`, `mixer.wav`. WAV is finalized PCM16 stereo44100Hz,164493frames/3.73s, peak4980,316958nonzero samples, RMS702.13. Nothing was played. Its duration is shorter than wall runtime; mixer startup time and the prior10ms-after-render cadence are not measured separately. This establishes nonempty capture and clean finalization, not real-time media synchronization or audio quality. Do not infer a timing pass from it.

The opt-in synthetic actual-AppKit fixture passed four timer ticks and five accepted presentations, checked inactive/hidden/nonkey state every tick and after close, and observed no activation. It uses no game, device, or OS input. `BLACKMOOR_BACKGROUND_UI_TEST=1 python3 tests/test_recomp_background_platform.py -v`; private fixture receipt under `work/background-platform-test-results/native-va4gbf5t/`. Existing focused geometry8/8 and device-free capture6/6 checks pass with this candidate; logs are `background-geometry-tests-20261102.log` and `background-audio-tests-20261102.log`. Five invalid deadline CLI inputs return2 before opening a platform. Total15 focused test cases plus five CLI checks pass. `BLACKMOOR_BUNDLE_PATH` permits isolated builds without replacing the normal app bundle.

## Limits and next slice

This is title startup and normal Quit-selector coverage, not physical Cmd-Q or room input coverage. Window sizing, fit/stretch mapping, movie synchronization, app saves and an app campaign still need runtime checks. Hidden windows deliberately do not test displayed pixels or a physical mouse. The primary snapshot is taken after successful guest join to avoid concurrent buffer access; errors use status6. Forced cleanup and filesystem failure paths are not deliberately exercised. The silent mixer, capture queue and foreground opener behavior are unchanged. Quiet monitoring samples open/stop and observes own-process workspace activations; it is not a proof against every transient platform-window state. The opt-in fixture checks each synthetic tick separately.

Next: share ordinary game-local scripted input with the Mac frontend, verify first scenes and media without OS input/focus, and promote the genuine headless seedlings/crank saves m11/m12. Full campaigns and final background credits remain incomplete.

Independent Sonnet review is pending against the frozen candidate. No completion claim is made before review/merge.

## Source pins

- `recomp/macos_recomp.mm`: `4042a1d3f939810ee46ce4683119456172cfd583ec6718acb2f7507644cc17cf`
- `recomp/build_macos.sh`: `4af98f73b34d9b31409397143dd3198aef21fa7388ed73e30f0be1b16d97075e`
- `src/macos_platform.mm`: `8d0d38127bb460f6ffb4a65461f5f0d6a1c989d85db25f8e670229c986422caf`
- `src/macos_platform_background.h`: `49304442c0687784f196d00bba414ff0b0741c4e0c1d71f22aaf536a6bce1aab`
- `tests/recomp_background_platform_fixture.mm`: `8064c3b8a62f9f79b22d7c0b51a7a5ed175ea610926a10b77e2db112c40352b1`
- `tests/test_recomp_background_platform.py`: `54dd79a23072b61c06b8bf142ae3d924078ce281d3671250f0649a4d79adea88`
