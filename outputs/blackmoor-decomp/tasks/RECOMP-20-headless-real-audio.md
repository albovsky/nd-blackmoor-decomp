# RECOMP-20: consume real-clock headless audio silently

Fix the confirmed missing mixer consumer in `rc_headless` when RC_REAL is set. Original Load case0x4da8e0 plays channel0x17, then0x4da97a–9a4 waits deadline AND channel completion before opening Load. `rc_dsound.c` correctly uses consumed source frames in real-clock mode; only `rc_audio_render` advances them. Headless installs a real clock but never renders. Mac's existing muted producer renders every10ms and passes the same menu path. Do not fake completion, switch to elapsed-time DirectSound status, skip sound or change original code.

Root retains shared integration/replay/review/publication in the original authorizing chat. Delegate reads AGENTS, PROJECT-SPEC, RECOMP-09, current headless/DirectSound/Mac silent-pacer code and private read-only real-load diagnosis. Prepare a private candidate against mainb4ecfd283bc9373ca0cbbd9be4fbc89080fede27 only. No shared/protected/ledger/evidence/override/flNN/original edits, full game/app builds, game/GUI/audio-device/oracle/prover/fault/sanitizer/mutation execution or publication. A tiny finite C/C++ fixture may be compiled/run without game data or output devices; every assertion exits normally. Root owns full-host build/actual replay/docs/generated metadata/independent frozen review.

## Evidence and ownership

Junior failed real attempts01/02 are retained under `work/recomp-playability-20261101/columns-continuation/typing-live-attempt-02/` (requests/receipt/log/closedMAIN image). All7steps/ACK/finish completed, same hwnd0x158, actual MAIN/Load hover, click buffer Play/GetStatus, no source-save read. Delayed identical virtual attempt03 passes the gate and actually wins2014 later. Existing Mac real reference `scripted-app-save-reload-20261102` shows the same Play→FindFirstFile/app12 read with silent rendering. Read-only agent's original assembly/source ranges and exact trace comparison are the primary diagnosis. This is not a key/deadline or menu-coordinate correction.

Private candidates may touch `recomp/rc_headless.c`, a small headless-only pump helper/header if justified, `build_linux.sh` linkage and one narrow finite fixture/wrapper. Keep the Mac app and its producer/pacer unchanged; avoid automatically adding the new module to the Mac build. No generic audio framework or unrelated refactor.

## Required behavior

Only real-clock headless starts a device-free consumer after successful `rc_start`, before `rc_main`. Render/discard actual signed stereo PCM through existing `rc_audio_render` at44100Hz,441frames per10ms, with monotonic fixed-deadline pacing. Match existing silent-producer overrun policy: bound/rebase rather than an unbounded catch-up burst; never inject a guest clock/timer or synthesize missing samples/completions. No CoreAudio/AudioUnit/device/GUI or system volume/preference access; never audible output. Optional bounded render/frame/elapsed diagnostics are appropriate.

Own thread lifetime explicitly: startup failure fails clearly, normal stop joins the consumer before exit/resource teardown, no detached work, no render-after-stop/use-after-free. Use existing mixer locking, don't alter DS status/cursors/notifications or original semantics. Preserve default virtual behavior, existing INPUT/FIFO/strict capture/protocol/error contracts and quiet logs. Real pump is independent of whether INPUT/FIFO is configured. Treat existing RC_REAL presence semantics consistently; do not add unrelated env parsing changes.

Add the smallest normal-exit component fixture for repeated render consumption/start-stop/restart/deadline behavior, using synthetic samples/callback stubs only as necessary. Reuse pacing logic conceptually without importing AppKit/C++ into a C-only headless host. No deliberate thread/resource faults, broad test suite, timing-flaky FPS benchmark or device test. Capture the regression reason and any untested lifecycle/error branches explicitly; actual original menu replay is the final integration acceptance.

## Root collection

Root builds a new isolated headless host without relifting; all24 lifted guest objects must remain byte-identical to reviewedcc7ce16f baseline. Original GAME.EXE staysafd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45. Use fresh APFS data/source clones. Replay the exact failed real input sequence with the new host: actual original menu click-sound completes, Load enumerates/reads the supplied genuine source save and reaches its scene, full steps/own stop or explicit clean FIFO finish/exit0, source/copy unchanged. No adjusted guessed delay or rewritten original/story/RNG/clock/save. Preserve failed old receipts and pin new native/source hashes. A small existing default virtual story/load regression must still pass. No full campaign claim.

Root runs required registered-input metadata refresh/static checks, opens draft PR early, arranges independent Sonnet high review against frozen commit, then merges only reviewed passing exact candidate. Keep unverified branches honest; no new function-port acceptance or Mac hardware-audio claim. Deliver private exact patch/tree/pins/test log and concise handoff; root remains the sole publisher.

## Root acceptance, 2026-11-02 Pacific

The finite fixture passes lifecycle/consumption/join/restart and fixed-deadline/overrun cases (one unittest, two normal-exit subcases); root applied-path run0.383s. No game/device execution in that fixture. Native headless builds with unchanged known unused-variable warnings; new SHA256 `74229ec82fe4b60508a665e3f95363c0de44d5374e7f84c8ee0712cf9ac09124`. All24 lifted guest object hashes equal reviewedcc7ce16f baseline, original GAME.EXE remainsafd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45. Mac source/build list/installedapp are unchanged.

Exact previously refused real request bytes (SHA847f0df02058d28d7dbed68460949252afd961357d3e73df767b210e45b89971), source m46d466e826 andRC_FLAGS replay in a fresh clone now pass: original sound gate completes, FindFirstFile/source reads at41964ms then54555ms, actual4120/view0/held-1,7/7steps/ACK1/finish2/failed0/exit0 in58.642s. No new delay/coordinate/phase input is used. Actual441-frame consumer5806calls/2560446frames,14deadline rebases,error0; no general A/V synchronization claim. Source and copied save remain unchanged.

The same input/source/newhost in default virtual mode also passes7/7steps/finish2/exit0 in1.506s and emits no HEADLESS_AUDIO producer diagnostic. Root independent raw/byte/hash audit is `work/recomp-playability-20261101/headless-real-audio-root-acceptance.json`; build/fixture receipts and logs share that prefix. Actual runs are under `columns-continuation/root-headless-{real,virtual}-load-m46-v1/`; prior refused01/02 remain unchanged. Focused menu replay is a host regression, not a new canonical campaign source or typing win. No original/game/story/RNG/clock/save values were artificially changed.

Normal shutdown joins the consumer; render/clock/thread startup/join failure branches are handled but not fault-injected/tested. The callback stop request uses existing C11 atomic stop_requested. The pump consumes existing PCM and discards it, with no output device or system settings access. Other real-time scenes/media/long-running shutdown loads remain unverified by this slice. No function-port/full-campaign claim. Required generated metadata and independent frozen review are pending.

## Source pins

- `recomp/rc_headless.c`: `7e38581cb0ab9e45f9f5eb701178826de31ec976b2f4d0dc5989b1d6c234a860`
- `recomp/rc_headless_audio.c`: `1a94fa26bbbb18bd877938a4e0b4c1da1ab57beb504279ca678b40efa856a207`
- `recomp/rc_headless_audio.h`: `c0f89906bc5e331563e3252e9f0798fde2e78343fa3e27bb1a32dbdc9e3f011e`
- `recomp/build_linux.sh`: `edbef46d08845761835db2fe088c3ad13011c3546b0dfe01ec6c674c19e0b997`
- `tests/recomp_headless_audio_fixture.c`: `1291c2bb3729f2a278cf6dbe7b570ffa3ffac002d5b5aab45938f47be0d2cb53`
- `tests/test_recomp_headless_audio.py`: `b033a1c8aa4279801fe1c34c7b4f092d3b6868228bc896b99ad294a30904d49a`

Review follow-up tightens only the synthetic cadence bounds and renames a local test identifier that the evidence scanner mistook for an unrelated native symbol. Production/native74229ec8 is unchanged; no game replay or fault/mutation test is repeated for this test-only change. Generated evidence cleanup/final independent delta review remain pending.
