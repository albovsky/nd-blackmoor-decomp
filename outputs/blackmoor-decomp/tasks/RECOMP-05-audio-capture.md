# Recompiled app: offline mixer capture

Continue the human's authorized native macOS port, one independently reviewed squash PR at a time. Root integrates/publishes. Base is PR286/e021a67b. Original game data, executable, reserved ledger/evidence and the headless runtime remain unchanged.

## Change

Add `--capture-audio FILE.wav` to the recompiled Mac frontend. The tap copies the actual stereo PCM16 mix before playback suppression/conversion, so `--mute` can retain useful diagnostic samples while bypassing AVAudioEngine and its output device. No actual game capture has been run yet: startup still activates a window and must first gain a separate background launch path.

A bounded single-producer ring feeds a writer thread. The producer performs bounded copies/lock-free atomic operations without allocation, waiting or file I/O. The writer serializes little-endian classic WAV, drains pending frames and finalizes header/length on finish. Overflow or I/O/size failures report failure and retain the accepted prefix rather than silently dropping audio. Classic WAV is limited to4 GiB; RF64/restart/multiple producers are outside the contract.

The frontend now joins its silent mixer clock, gates callbacks and waits for in-flight render/capture calls before finalizing. Game completion uses an atomic flag. Capture startup failures exit3; finalized capture failures exit4; forced/stuck shutdown exits5. Unmuted hardware callbacks and actual app shutdown are not runtime-verified by this slice.

## Drain race fixed

The initial writer could observe an empty queue, then see finish's stop flag after the producer appended its final frames, and exit without writing those accepted samples. The writer now observes stop before its acquire-load of the queue position. If stop is true, the final producer writes happen-before the queue read; if false, an empty snapshot cannot end the loop.

A deterministic fixture pauses after the empty snapshot, appends3 frames, starts finish, observes stop, then releases the writer. The prior load ordering exits1 normally and loses all3 frames; the fixed writer saves them exactly. Hooks exist only under RC_AUDIO_CAPTURE_TESTING and are absent from the app. Bounded hook failures are recorded; assertions happen on the fixture main thread after release/join, avoiding uncaught worker exceptions or crash dialogs.

## Acceptance

Six synthetic PCM tests pass in1.097s: exact extrema/channels/silence/ring wrap, finish/destructor drain, the stop race, empty finalized WAV, overflow with preserved prefix, and invalid/open failures. They link no audio device/engine or game. Private regression receipt: `work/recomp-playability-20261101/audio-capture-drain-race-6n5xcsox/receipt.json`; root run: `audio-capture-tests.log`.

ARM64 bundle builds and signs (`audio-capture-app-build.log`), with executable SHA-256 `e5a6d367e59ff839996d2cd77b7dee06f3859fac5794f596c3a7f060893a0994`. No launch or actual game PCM/timing/quality claim is made. Remaining acceptance is a background `--mute` app launch, real mixer capture, movie/audio synchronization and clean native Quit. Initial review rejected6f940bba over Cmd-Q cleanup bypass; the correction below is frozen for follow-up review.

Source pins:
- `recomp/audio_capture.cpp`: `59dcb9852d92ce10b47c3ee7265555f665758f932ca43fbfcbc6d33bce1212f8`
- `recomp/audio_capture.h`: `b4a5c8faa825ad9798c4bbce022a9e8cf8d26764ad70b1851b0db34827fa788f`
- `recomp/macos_recomp.mm`: `3e578592254dc85ecd42eaba6256cd40878a126b2d10b6a0f460f6162a49ba1f`
- `recomp/build_macos.sh`: `2f806cd3305912e3edaa67c4913d9e3b9dd54becf0fd2c40e54b6f1e5a81d21f`
- `tests/recomp_audio_capture_fixture.cpp`: `6d600118576051a099a8d3f24389e56f584055899af0cd76ca54a976e4181233`
- `tests/test_recomp_audio_capture.py`: `3056a09d2a5b588cae8275fba8a93ef45138d4f1f81c51a5f61181bd1dd60752`

## Review correction

A retained NSApplicationDelegate now intercepts normal Quit, cancels immediate AppKit termination and schedules the existing platform stop. Control returns from the run loop to main, which stops producers, finalizes WAV and joins the game before global destruction. This prevents Cmd-Q from destroying capture while a joinable mixer still runs. [Apple documents this Quit interception point](https://developer.apple.com/documentation/appkit/nsapplicationdelegate/applicationshouldterminate%28_%3A%29?language=objc). Actual Cmd-Q execution is deferred to the first background app check; compilation/signing passes (`audio-capture-followup-app-build.log`).

The original10ms-after-render silent-clock cadence is restored, avoiding catch-up bursts after stalls. A main-thread tick reports the first capture rejection without file I/O on the producer. A5-second shutdown watchdog bounds a stuck game/producer/filesystem path and returns failure5; that path may leave an unfinalized capture and is not claimed clean. The watchdog is not exercised with deliberate stalls/faults.

Coverage gaps: actual app/audio callbacks and Cmd-Q have not run; continuous overlapping ring streaming,4GiB limit, short writes, disk/flush/truncate/header failures and combined errors have only static review. A filesystem failure can zero-fill or leave an incomplete tail despite a rewritten header; captures with failure status are not trustworthy audio evidence. Six synthetic queue tests remain the runtime evidence. Original game PCM, timing and hardware remain unverified.

Final static follow-up accepts17d2fdda with no P1 or blocking P2 (`audio-followup-review.txt`). Cmd-Q bypass is resolved by design; actual quiet app/Cmd-Q execution is the first gate of the next background slice. The watchdog covers run-loop return through fclose, not subsequent global destructors/atexit, and communicates only exit status5. Status precedence is5 over4 over0. A non-polling guest can delay Quit for up to3s before forced failure. NSTerminateCancel may cancel a system logout request before the app exits; normal Quit is the supported path, with logout coordination unverified. The final source change after review only clarifies a comment; compiled behavior is unchanged.
