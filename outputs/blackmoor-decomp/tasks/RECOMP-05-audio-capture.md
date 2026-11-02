# Recompiled app: offline mixer capture

Continue the human's authorized native macOS port, one independently reviewed squash PR at a time. Root integrates/publishes. Base is PR286/e021a67b. Original game data, executable, reserved ledger/evidence and the headless runtime remain unchanged.

## Change

Add `--capture-audio FILE.wav` to the recompiled Mac frontend. The tap copies the actual stereo PCM16 mix before playback suppression/conversion, so `--mute` can retain useful diagnostic samples while bypassing AVAudioEngine and its output device. No actual game capture has been run yet: startup still activates a window and must first gain a separate background launch path.

A bounded single-producer ring feeds a writer thread. The producer performs bounded copies/lock-free atomic operations without allocation, waiting or file I/O. The writer serializes little-endian classic WAV, drains pending frames and finalizes header/length on finish. Overflow or I/O/size failures report failure and retain the accepted prefix rather than silently dropping audio. Classic WAV is limited to4 GiB; RF64/restart/multiple producers are outside the contract.

The frontend now joins its silent mixer clock, gates callbacks and waits for in-flight render/capture calls before finalizing. Game completion uses an atomic flag. Capture errors produce exit4; original game-stop/fallback behavior is otherwise retained. Unmuted hardware callbacks and actual app shutdown are not runtime-verified by this slice.

## Drain race fixed

The initial writer could observe an empty queue, then see finish's stop flag after the producer appended its final frames, and exit without writing those accepted samples. The writer now observes stop before its acquire-load of the queue position. If stop is true, the final producer writes happen-before the queue read; if false, an empty snapshot cannot end the loop.

A deterministic fixture pauses after the empty snapshot, appends3 frames, starts finish, observes stop, then releases the writer. The prior load ordering exits1 normally and loses all3 frames; the fixed writer saves them exactly. Hooks exist only under RC_AUDIO_CAPTURE_TESTING and are absent from the app. Bounded hook failures are recorded; assertions happen on the fixture main thread after release/join, avoiding uncaught worker exceptions or crash dialogs.

## Acceptance

Six synthetic PCM tests pass in1.097s: exact extrema/channels/silence/ring wrap, finish/destructor drain, the stop race, empty finalized WAV, overflow with preserved prefix, and invalid/open failures. They link no audio device/engine or game. Private regression receipt: `work/recomp-playability-20261101/audio-capture-drain-race-6n5xcsox/receipt.json`; root run: `audio-capture-tests.log`.

ARM64 bundle builds and signs (`audio-capture-app-build.log`), with executable SHA-256 `bb5bca1f7ea59b2f7a7258b8f39df9c349ae4dbf581cfecdf6ff94011fe5e413`. No launch or actual game PCM/timing/quality claim is made. Remaining acceptance is a background `--mute` app launch, real mixer capture, movie/audio synchronization and clean native Quit. Independent frozen review pending.

Source pins:
- `recomp/audio_capture.cpp`: `59dcb9852d92ce10b47c3ee7265555f665758f932ca43fbfcbc6d33bce1212f8`
- `recomp/audio_capture.h`: `b4a5c8faa825ad9798c4bbce022a9e8cf8d26764ad70b1851b0db34827fa788f`
- `recomp/macos_recomp.mm`: `639f440d128036ff9e2fc6c89128ae1206a83f498d6d5000f5f2141fbb218eac`
- `recomp/build_macos.sh`: `2f806cd3305912e3edaa67c4913d9e3b9dd54becf0fd2c40e54b6f1e5a81d21f`
- `tests/recomp_audio_capture_fixture.cpp`: `6d600118576051a099a8d3f24389e56f584055899af0cd76ca54a976e4181233`
- `tests/test_recomp_audio_capture.py`: `3056a09d2a5b588cae8275fba8a93ef45138d4f1f81c51a5f61181bd1dd60752`
