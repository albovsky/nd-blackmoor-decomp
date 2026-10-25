# NATIVE-07: muted native alarm wake-up timing

Base merged main 9613077bc28e68fc00b41fde148d82f1e0b39101. Original human authorization in this root chat: native ARM64 Mac port, real-data room navigation, one slice per PR, tests, frozen independent review then merge. Root alone publishes. Claude owns full decompilation/matching. Keep persistent game mute=1. Never edit original game files/GAME.EXE/game-source, function ledger/evidence/extract/build ledger outputs, tests/fl40_* or tasks/flNN-handoff.md. No broad discovery, sanitizer/mutation/Unicorn/original-x86/deliberate-fault/audio-output tests. User says Mac unlocked but CUA still reports locked; no GUI claim or repeated unlock prompt.

NATIVE06 fixed Cancel/input. Next reachable progression is setting the bedside alarm: S2175 set block targets2176, cancel targets2020. Installed49-byte button/final descriptors are Beep12/SILENCE on channel 9, loaderflags 2 loop mode 1 gains 100/100, final delay 1 second. Native callbacks native_aaa_sound_prepare/stop/play/busy currently log NOT PLAYED and busy always0, so FINAL_SOUND completes without a real channel. Existing puzzle_sound adapter already handles these exact descriptor forms through the live_audio backend; do not reconstruct its kernel again.

Root owns blackmoor_app.mm including audio fields/callbacks and the diagnostic click scheduler. Tests worker owns ONLY tests/native_alarm_clock_glue_test.mm and tests/test_native_alarm_clock_input.py in its separate worktree; no publication. Prefer extend existing fixture/runner instead of duplicate infrastructure. Kernel/binding and existing tests remain unchanged in meaning.

Implement clock-specific PuzzleSound host state on the same live_audio provider as scene sounds. Prepare/load, separate play, actual busy, stop/unload, missing-resource/no-resource and backend-error semantics follow the existing D1 adapter. Refresh loaded state before play/busy because scene owners share channels. Do not claim original DirectSound/hardware parity. Keep all ordinary/movie/game output master-muted and natural completion operational.

To run a real alarm-set route, the existing diagnostic --live-click-at must replay multiple one-shot gestures in one scene. It currently hard-codes scene ticks 12/14/15, so only the first matching entry can fire. Preserve first-gesture timing and existing CLI; schedule later queued gestures at bounded later scene ticks, reset at the existing scene-ID-change boundary, never inject candidates/flags/phases/time/targets. This is diagnostic input only, not a gameplay shortcut. Actual route: Junior34, nav2010:left 11, scene2010:9, scene2013:3, click2020:472,217, then clock Alarm117,216 and Set259,265 (centres + real viewport origin10). Each pointer gesture MOVE/DOWN/UP, with enough ticks for original press delay. Trace real S2175->S2176 then whatever real actions/conditions do; do not predeclare later wake outcome.

Acceptance: tests first normal RED. Real clock fixture with production native sound callbacks and offline live_audio: original button and final descriptor load/play, busy=1 while active, natural completion (no stop forcing), clock FINAL_SOUND holds phase1 until idle then completes/updates time/requests original settarget 2176. Cancel unload and scene/channel replacement behavior meaningful where cheap. No output device, no speaker test; explicit fixture mute. Existing seven sink-host clock components remain sink-only and clearly scoped. At least one actual entry route performs both Alarm and Set with the existing pointer callbacks and reaches 2176 with no frozen session/error; repeated scripted clicks must really occur. Test a finite descriptor/basic missing or shared-channel refresh path, avoid expanding into an unrelated audio-test project.

Record original/source/native pins, real resource metadata, native audio timing and reached scenes, exact checks, independent review/disposition, unverified GUI/wake branches. Keep short playability log accurate. Full suite failures remain unresolved and excluded crash tests are not rerun. Never claim complete game or whole-file x86 match.

## Root implementation and validation (2026-10-25)

The clock now owns a PuzzleSound cache bound to the existing live_audio provider. Its prepare/play/busy/stop callbacks use real native channels; play/busy refresh the provider's loaded state so external scene/channel replacement is authoritative. A missing clip remains a supported no-resource boundary; invalid descriptors/backend errors remain failures. D1's callbacks and state are unchanged. No kernel, binding, decoder, audio engine or device preference logic changed. Master mute remains enabled.

The inspection-only click queue preserves MOVE/DOWN/UP at scene ticks 12/14/15 for the first gesture. Later matching queued gestures start 20 ticks after the previous MOVE; the counter resets with the existing scene-ID-change boundary. This makes the real Alarm-then-Set route expressible using two actual pointer gestures. Same-scene-ID reentry timing, arbitrary button delays and mixing these gestures with scripted inventory operations remain unverified; this is not a general input-replay framework.

- Tests-first RED: fresh normal real-muted-offline fixture prepared no channel (loaded=0/started=0/frame_count=0) under old callbacks, CHECK exit1. Worker /private/tmp/native-07-alarm-audio-red.log,15.381s. Tests-only worker f3680ebf collected as 047d5cdf. Root alone publishes.
- Existing diagnostic route RED: actual Alarm UP117,216 occurs, Set UP259,265 never occurs and no2175->2176 transition; ordinary check exit1, final S2175 status=0 (alarm-wake-route-red.log). This identifies the old one-click-per-scene diagnostic limitation separately from the real sound stub.
- GREEN focused clock suite: 12 passed in 69.073s (alarm-wake-tests-green.log), comprising prior 8 checks plus 3 real-audio components and 1 real Alarm/Set route. Beep12 loads 2,575 frames at 44,100 Hz without starting; the real release plays it and it completes naturally. SILENCE loads 4,410 frames and keeps phase1/FINAL_SOUND busy before natural completion. Component rendered 12,288 muted frames with zero nonfinite/nonzero samples, observed busy gating, then original clock writer set 09:00 and requested 2176. Cancel unloads its real channel. Missing resource and external shared-channel load/unload refresh pass. Prior sink-host components stay explicitly sink-only.
- Normal native route: actual entry472,217 in S2020, Alarm117,216 then Set259,265 in S2175; no candidate/phase/world/clock/target injection. It reaches 2176 ->2180 ->2181 ->2010 and ends S2010 status=0: 30 distinct scenes/31 entries. Log alarm-wake-route-green.log. The full fixture route independently reports the same subsequent scenes. This is one bounded wake path, not all alarm times/campaign branches.
- Existing D1 app-audio regression: 1 passed in 7.034s, all 20 named clips/11 solve/11 exit lifecycles and 37 busy-wait ticks (alarm-wake-d1-audio-regression.log). Offline adapter produces finite PCM without an output device; it does not change the main app's mute preference.
- Normal ARM64 app builds and git diff --check pass. Final rebuild follows a comment-only wording correction; production behavior and tests are unchanged. GUI tool still says locked after the owner confirmed unlocked; no GUI check is claimed, no unlock workaround or repeated prompt used.

No broad suite, sanitizer/mutation, Unicorn/original-x86, deliberate fault or audio-output tests were run. Existing full-suite gaps remain unresolved; no test was skipped or weakened to get these passes.

## Pins (SHA-256)

| Item | SHA-256 |
|---|---|
| Original GAME.EXE, 1,511,424B | afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45 |
| Original 0x44da08..44e025 handler | 7b9503e2e027595bd67bc7be695113fbc8ac466700059ddd3e48e6d89585e6e5 |
| Original 0x4fb77a..4fba69 descriptor loader | 2ce29dc83367fe0fbde3a901b3fc7e1c9e98397a66754680f8fa74707c8ce556 |
| Original 0x4f6334..4f646c busy | 48cdda17186b7ccc8d331394776ccdd0454d847fb5c751bc4f73cc1468916062 |
| S2175 1,764B | 2f6147efdc98af936815ff153ffa3b7811f1bf4de84ca153c017b2cb705964c4 |
| Beep12.HIS 5,180B | a61dae861a905feaaf01bea782e89cdbc6c18a134738fa940f853f019403df38 |
| silence.his 8,850B | d0cb1ed5e7d76b95f8feb221d030f7ab656e30d19aab6c919adab6ea2e8eb2e2 |
| blackmoor_app.mm | 6936601e91da3958417ce47b32b9f1776e06a401160788321a4fbc6301b20ff0 |
| Normal ARM64 executable | ae6ce9e4f54796eb6454a96ea4f2caf6d511cccd450257aa0880b77aeec4fb88 |
| native_alarm_clock_glue_test.mm | 99b8cb20dd5da9ea3108a99808ab6a8ad0c663ea277409f21fb2076e0aaea01e |
| test_native_alarm_clock_input.py | a0cbbc09b1692ecd5c7c7851f2223fa02cc04f71fb57605f446dbfc1950fd4a2 |

Original hashes are read-only checks against immutable local bytes. No original code execution, codec/hardware parity or new function-ledger claim is made. Native callbacks reuse the previously reviewed bounded descriptor adapter and the existing recovered clock state machine. Only source, tests and reports are committed; no game data/audio/decoded payload is published.

## Residual limits

Physical GUI/speaker checks, exact original audio timing/attenuation/DirectSound parity, backend-error injection, idle-timer object, cursor sprites/layer ordering, other wake times and subsequent story progression remain unverified. The original conditional idle timer stays explicitly logged as unmodeled. Missing-resource handling is host integration, not original loader equivalence. NATIVE06 modal/held-item/extreme-coordinate and complete-campaign limits still apply. Whole native gameplay and whole-file x86 matching remain incomplete. Initial frozen independent review accepted; corrections below.

## Initial independent review and corrections

Independent Sonnet slice-reviewer accepted frozen 5c215782 against main 9613077b with no P1 or blocking P2. It confirmed descriptor bounds, existing kernel effect order, per-call shared-channel refresh, backend lifetime, idempotent double unload on channel 9 and safe queued-gesture iterator/timing behavior. Root accepts this review (private independent-alarm-wake-review.txt) and strengthened both nonblocking test gaps before publication; production code and native artifact are unchanged.

- The full app wake route now requires two successful native prepares (button then final), three successful channel 9 plays (Alarm, Set, final) and two successful unloads (final completion then phase2), rejects any nonzero native sound status and verifies a successful play after Set. A missing resource can no longer make that real-data route pass vacuously.
- The real-audio Cancel fixture now asserts busy=1, loaded=1 and started=1 immediately after the actual Cancel release, before settling. It then confirms the original phase2 path unloads the playing beep.
- Only these two affected checks were rerun: 2 passed in 42.225s (alarm-wake-review-checks.log), including full native wake route. CLOCK_AUDIO_CANCEL busy_before_cleanup=1 started=1. No production behavior changed after the prior 12-check and D1-audio passes.
- A second normal native route uses 15 actual Increase gestures before Set (no clock injection). Original clock writer sets 09:00, then reaches 2176 ->2177 ->2183 ->2184 ->2182 ->2010, final status=0: 32 distinct scenes/33 entries. All 15 actual UPs are logged (alarm-wake-morning-route.log). This is one additional morning branch; other wake times/complete campaigns remain unverified.
- P3 duplication with D1 is accepted for the narrow slice. Both families retain separate caches over the authoritative shared provider. Refactoring is not needed to establish this host integration.
- P3 fixture defaults persist mute in the temporary test executable's own defaults domain; no restoration to audible output is performed, and the real app remains muted. Existing replay same-ID reentry and fixed-spacing limits remain disclosed.
- Primary GREEN evidence exists at the absolute shared paths /Users/albovsky/Projects/nd-blackmoor-decomp/work/playability-20261024/alarm-wake-tests-green.log (12 passed in 69.073s), alarm-wake-d1-audio-regression.log (1 passed in 7.034s), alarm-wake-review-checks.log (2 passed in 42.225s). Initial reviewer did not independently reverify those durations; root ran and checked each output. No claim of independent test execution is made.

Superseding test-source SHA-256 pins after stronger assertions: native_alarm_clock_glue_test.mm f6c8fd85aba65b0cabd81f372b896d3b0d3fd0a997d54b45b98ab116bd72a00a; test_native_alarm_clock_input.py 4566c027910bb63648061fff6a967fbad66abb646700c0045caa86197730bfec. All production/native/original pins above remain unchanged. Final frozen correction review accepted below.

## Final independent acceptance

Independent Sonnet slice-reviewer statically accepted frozen 4463e3d5d471b4e27f65a3041ee986d22eb30384 with no P1 or blocking P2. It read the private evidence, confirmed the strengthened route and playing-Cancel assertions are non-vacuous, matched test-source pins and verified production source was unchanged from its initial acceptance. Root accepts this disposition. Private report: independent-alarm-wake-final-review.txt. Only documentation changes follow this freeze.

The 09:00 morning branch is root-run evidence, not covered by the committed regression suite. Its full pointer sequence is entry 2020:472,217, Alarm 2175:117,216, Increase 2175:555,173 repeated 15 times, then Set 2175:259,265, with --live-ticks 3500 --rand-seed 1 --mute and the same Junior row 34 / nav 2010:left:11 / scene row 2010:9 / scene row 2013:3 prefix. It logs 15 actual Increase UPs and writer 09:00. The two modified regression methods were rerun separately; the morning command was additional exploration, not counted in the 13 focused suite checks.

Residual route-test clip/channel identity is supplied by the component fixtures and native provider logs; the route asserts successful clock host calls, not every channel payload field. Offline adapter completion is driven by explicit rendering, so the pre-cleanup playing check has no hardware/wall-clock audibility claim. No physical device check or new oracle claim follows from this acceptance. Full game and whole-file x86 matching remain incomplete; root alone publishes in the original authorized chat.
