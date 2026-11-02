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

Initial independent Sonnet review of573784df found noP1 but required stale evidence pins to be corrected. It also found diagnostic guest-abort success reporting. Both corrections below are prepared for follow-up review; no completion claim precedes that review/merge.

## Source pins

- `recomp/macos_recomp.mm`: `4042a1d3f939810ee46ce4683119456172cfd583ec6718acb2f7507644cc17cf`
- `recomp/build_macos.sh`: `4af98f73b34d9b31409397143dd3198aef21fa7388ed73e30f0be1b16d97075e`
- `src/macos_platform.mm`: `8d0d38127bb460f6ffb4a65461f5f0d6a1c989d85db25f8e670229c986422caf`
- `src/macos_platform_background.h`: `49304442c0687784f196d00bba414ff0b0741c4e0c1d71f22aaf536a6bce1aab`
- `tests/recomp_background_platform_fixture.mm`: `8064c3b8a62f9f79b22d7c0b51a7a5ed175ea610926a10b77e2db112c40352b1`
- `tests/test_recomp_background_platform.py`: `54dd79a23072b61c06b8bf142ae3d924078ce281d3671250f0649a4d79adea88`

## Review corrections and final candidate

The latest owner pasted request expressly requires extractor and ledger `--write` in the same PR when a hashed source changes. The platform is such a source. Both generated records were refreshed from clean frozen b16cd7a1 in an isolated detached checkout, excluding the parked/untracked telephone files. Coverage counts, every function status and all lifter input fields remain identical. Neither generator nor protected original methods/tests/acceptances were changed. Private `background-refresh-receipt-20261102.json` and static refresh/check logs record provenance. This is a hash refresh, not new function-port credit.

Diagnostic runs now classify the game result after join. An ordinary return, an exact `stop requested` reason or `ExitProcess(0)` (optionally followed by a space/native trace) is accepted; another nonzero guest result produces status6. A device-free C matrix checks14 normal/abnormal/boundary strings without executing or faulting game code. Existing foreground exit behavior is retained. Background/title acceptance still checks the actual STOP_AFTER and stop-reason lines, rather than trusting exit0 alone.

The corrected signed executable is `8ab5e6cc80c95a071b2a8cd25314639bf34b89eb7e34f546f9c2cb45669145fa`. Fresh-clone repeat returned0 in5.47s, reported the one Quit-selector request and controlled game stop, and again remained inactive/key0/visible0/activation0. Title frame hash is identical to the first run. Its finalized WAV is176841frames/4.01s, peak4980 and340736nonzero samples. See `background-reviewfix-app-20261102/receipt.json`; the duration variation reinforces that this slice makes no synchronization claim. Empty snapshot CLI input also returns2 before opening a platform. Total focused test evidence is16 cases and6 early CLI rejection checks.

For quiet verification, exec the bundle's `Contents/MacOS/BlackmoorRecompiled` directly with explicit `--background --mute`. LaunchServices/open activation behavior is untested and must not be used for these checks. The deadline includes setup; a slow start may stop before a usable primary and correctly fail6. Use a new private output directory for each run; a failed run can leave an old or partial snapshot, including on the shutdown watchdog. Never trust its outputs without both successful status and expected log observations. The watchdog covers snapshot writing too. Build targets must end in `.app`; normal bundle defaults are unchanged.

Final source pins supersede earlier pins where the path repeats:

- `recomp/macos_recomp.mm`: `26d71b1e044b441c98d9088c173637c10afe530a3d6a5dfbb85e3f819326a1df`
- `recomp/build_macos.sh`: `69c7d2aa457b3bb4c28c2821a3326c0fa3bb5e3a682af8df37d0806cb5f23505`
- `recomp/diagnostic_result.h`: `0d9bcf7ebd2ecc9af0949f19f279be4e39b3160288ef76012e02a77d6c9d4c8f`
- `src/macos_platform.mm`: `8d0d38127bb460f6ffb4a65461f5f0d6a1c989d85db25f8e670229c986422caf`
- `src/macos_platform_background.h`: `49304442c0687784f196d00bba414ff0b0741c4e0c1d71f22aaf536a6bce1aab`
- `tests/recomp_background_platform_fixture.mm`: `8064c3b8a62f9f79b22d7c0b51a7a5ed175ea610926a10b77e2db112c40352b1`
- `tests/test_recomp_background_platform.py`: `54dd79a23072b61c06b8bf142ae3d924078ce281d3671250f0649a4d79adea88`
- `tests/test_recomp_diagnostic_result.py`: `7168d9430f5d60a71977af5ebe36c4e787155524ca183afe3a090ca8484fdc35`
