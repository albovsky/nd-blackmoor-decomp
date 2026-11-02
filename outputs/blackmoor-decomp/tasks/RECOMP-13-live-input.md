# RECOMP-13: live ordinary-input batches

Jane's glyph board changes between launches, and an original UI save does not preserve it. The fixed startup INPUT could not react to observed cells in the same process. Add opt-in `RC_CONTROL_FIFO` to the headless frontend, reusing the existing parser, scheduler and normal game input queue. The guest puzzle, RNG, story state and clock are unchanged; the driver never pauses the guest or calls puzzle handlers. Root retains original-chat review/publication/squash-merge authority; delegates prepare private candidates and gameplay evidence only.

## Contract

Caller creates a private FIFO and keeps one writer open. Nonempty INPUT and control mode are mutually exclusive. Open read-only/nonblocking/CLOEXEC, NOFOLLOW where supported, and require FIFO via fstat. Lines are `<consecutive id> <existing INPUT batch>`, starting1; only `<id> finish` ends successfully. Limits:512steps/65536bytes per batch,4096requests including finish,16MiB total bytes. One bounded4096-byte read, one request start and one script poll per MAIN guest poll; workers ignore it. A full buffer applies normal FIFO backpressure.

Each batch is destroyed and ACKed immediately after all steps deliver successfully, before the shared script's automatic tail-stop branch could run. Static INPUT semantics stay intact. Numeric1/101 offsets preserve100ms spacing when the first delivery is late; named anchors retain their process-wide first-seen times. ACK means delivery/capture, not completed animation or puzzle victory. Use ordinary settle time before a shot. Header documentation now permits serialized MAIN-token parsing; parser implementation is unchanged.

Shots have process-global numbers, exclusive fresh-file creation and checked pixel writes/close. Observations remain read-only. Logs flush in control mode so the client can see ACKs while the process runs. Finish requires a later poll confirming drained FIFO; queued/partial/trailing data, early EOF, missing HWND delivery, failed output, abnormal guest exit or incomplete termination cannot succeed. Configuration/start failures return2; runtime/output failures return6. Existing import/idle/outer guards remain. No network service or OS-input injection is added. A terminal session cannot account for writes made after its confirmed finish boundary.

## Acceptance, 2026-11-02 Pacific

Two discoverable unittest methods pass in0.750s:25 finite FIFO/unchanged-parser scenarios plus actual headless capture code with synthetic1x1 pixels. They cover ordered/split batches, spacing, worker exclusion, no inter-batch tail stop, unique shots, explicit finish, bounded syntax/size/sequence errors, early EOF, missing delivery and shot failure. Failures are ordinary checks/exit codes; no guest/fault/oracle/sanitizer/mutation test executes. Private `live-input-root-tests/` retains commands, source/native hashes and per-case results. The predecessor's normal static tail-stop boundary is recorded separately, not labeled an engine defect.

Actual native default-mode regressions also pass with control unset: fresh New Game/Junior→m0 in34.38s and genuine m16→Moon-column→m17 in7.23s, own script stops, original UI saves and observation checks. Private `live-input-default-regressions/` records source/copy/input/save hashes. These are selected regressions, not a repeat of every earlier campaign leg.

The new native host runs genuine m28 through the original glyph rules into3588. Actual live attempt01 delivers179/179steps,31closed captures and explicit finish27/26ACKs, exits0 and scores two matches before an authored timeout;2001 stays0. This proves feedback/delivery, not a win. A separate39-step probe with250ms holds/500ms cell spacing scores150 and completes cleanly;40ms holds were unreliable for original polling. No selected-cell highlight is claimed. Actual attempts02/03 win2001→1299 but private reward/caption expectations stop before a safe save; both remain rejected checkpoint attempts.

Attempt04 reaches original1299/2001→1294→1945/1357, scrolls the original caption to Bye150,438 and returns3510/view4. Actual bag pixels show4 in the first slot; ordinary60,100 selection records held4, followed by PUT/X and original UI m29. Save SHA `9a825ff55f438f5499fc4c783a713bfba12d682d8a6c194f7ea04385b79e2050`. All240steps/33captures/25batches ACK, explicit finish26, failed0, exit0.76.6s wall/7.48M virtual elapsed includes live observation while the guest continues; no pause or clock write. Fresh save-only persistence verification is pending. All failed probes and raw requests/captures remain retained; no state was forced.

Gameplay evidence is under `work/recomp-playability-20261101/columns-continuation/glyph-live-{attempt-01,selection-probe,attempt-02,attempt-03,attempt-04}/`. The source m28 remains `94f51b21346547546d0744af6e4568e87402c8c1acef6dd31ce44013c7eb29d9`. The pixels-only planner/controller is private test tooling, not a replacement puzzle implementation. Protocol completion alone never establishes a story win.

Native SHA `cc7ce16f33aee31714b8d8586adeffcc6e2036e58f6522394626ed6f2e0eed56`; a fresh rebuild after the header-comment clarification is byte-identical. All24 reused lifted objects match the preceding reviewed0c5fc594 build (`live-input-build-receipt.json`). Original GAME.EXE remains afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45. The Mac app is unchanged and not rebuilt for this headless-only transport.

## Review and limits

Required registered-test hashes are refreshed from clean bfc94bd2; `live-input-refresh-receipt.json` verifies unchanged function statuses/classes/counts/native lift fields and1763peer claims. Independent Sonnet review and final static freshness checks are pending. No function-port acceptance is added. Actual Linux execution, disk-full/write-close/flush errors, EINTR, prolonged full-buffer backpressure, aggregate16MiB exhaustion and other framebuffer sizes are unverified. Host correctness under real guest lifecycle failures is statically classified but not fault-tested. Broad crash-producing suites remain excluded by the owner's instruction. Full campaigns and final native credits remain incomplete; current public fixed-route story endsm17 while private Junior/Senior continuations proceed separately.

## Source pins

- `recomp/rc_headless.c`: `a352e3a874a2c2d5ab749ee56a320a9fc0ef5e217980864dead872ca68aa77c1`
- `recomp/rc_input_control.c`: `db58b5a54c0fa325cb8b6c3227d7fcea3da6d8ba032159383d73226d13f2efd3`
- `recomp/rc_input_control.h`: `6cf0d612b8f4a63e283a2b24d7052e811a430394a0881b4dbeb4efeb059d0fa9`
- `recomp/rc_input_script.h`: `5101fc4d135026737b89362c6525747799aa20f1f2fd042b0fae83565dd6e9c9`
- `recomp/build_linux.sh`: `bc0c311be4124d72712d790ec8a13adb69351727c40d74d4a9b1b0bbedefb9cd`
- `tests/recomp_input_control_fixture.c`: `d302ee47070a549848059a4a20aa02ae19d11ef380f4e9643757d06e5044dce0`
- `tests/recomp_control_capture_fixture.c`: `0b178b10f8c5f6e0e02ce3aad73c29ba069bbdaeae314e020a092b87d558acb1`
- `tests/test_recomp_input_control.py`: `3c9685c532f6fe2e0af77ba9ca36cef4c45f6be2d75c999dd670b1cbd1d66a85`
