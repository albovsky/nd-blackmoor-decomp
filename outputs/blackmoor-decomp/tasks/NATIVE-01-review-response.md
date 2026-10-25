# NATIVE-01 review response

Independent slice-reviewer reviewed frozen 2caa5a65 against b4cbef99. No P1 defects. ASan/UBSan random descriptor validation was clean (2 million records/lengths), and the reviewer verified offsets, independent gain clamps and category table against immutable original bytes. Private review: work/playability-20261024/independent-review.txt.

P2.1 accepted. The extended native app fixture now creates a real SessionAd1Binding for every original D1 scene and solves/exits every row with the actual app audio callbacks, advancing offline audio between visits. All11 solve paths and11 exit paths complete; win sound yields38–39 waiting ticks before phase2; completion unloads record0, and WIN_SOUND unloads record1. Only render handles, inventory and transition/event sinks are fixture host boundaries. The existing D1 x86 oracle separately validates the kernel's ordered effects.

P2.2 accepted as a reporting gap. PLAYABILITY-LOG now records exact commands, normal/test-hook binary hashes, immutable original hash, named baseline build failures and unverified branches. Canonical rebuild was attempted; full discovery is running after the independent build audit. No passing full-suite claim. Final results will be recorded before publication.

P2.3 policy retained deliberately: NO_RESOURCE is a silent absence, while malformed/unsupported descriptors and backend errors are explicit failures. This is the packet's required failure contract, consistent with native conversation sound handling and the project rule against silently completing unsupported paths. The final glue test injects load/unload/busy backend failures, checks the app returns an error and preserves a failed busy query's caller output. No original host-failure parity is claimed.

P3 limits recorded: PCM overshoot, hardware audibility/completion/suspension and GUI D1 input. Backend is created once and outlives the binding; any future backend recreation must reset the cached adapter.

Final P3 test details: each named win clip must be observed busy on its own solve path; counters are actual successful solve/exit counts; all lifecycle PCM stats reject nonfinite samples. Exit explicitly verifies the win clip stays prepared/unstarted, and the subsequent manual unload is labeled test isolation with channels derived from the body. Play-backend error propagation is also injected and checked. Native callbacks and adapter production code are unchanged from both independent reviews.

## Detailed NATIVE-01 validation record

# Native playability log

2026-10-24, baseline `b4cbef99`, NATIVE-01 candidate `2caa5a65` (ARM64 macOS, original GOG data). The whole game remains incomplete.

- GUI: launched the real native app, clicked New Game and Junior Detective, observed S0 captions and the opening letter, then reached S2010 through the opening sequence. Fullscreen preserves 4:3 with side bars on the current widescreen display. Local captures: `work/playability-20261024/gui-S0.png`, `gui-S2010.png`, `title-fullscreen.png`. Mouse automation is intermittent (`noWindowsAvailable`); fullscreen activation enabled the two verified clicks. Right-click and room-hotspot GUI checks remain unverified.
- Headless: 24 distinct scenes through S2010; original S2010 row 5 enters S2008 (25 scenes). S4808 raw 0x83 row 6 applies. S2008 stays running at the tick limit, with no session error; further interaction is unverified.
- Movies/audio: all 504 opening-movie frames and 12 movie sequences complete on the S2010 path. Offline soundtrack PCM is nonzero and finite. The hardware-output smoke plays a real clip and unloads successfully; speaker audibility and device-completion/suspension are unverified.
- NATIVE-01: D1 turning-puzzle sound now loads, plays, waits and unloads through live_audio. Regression failed on the original silent callback and now passes all 20 named clips across 11 original rows, plus 11 solved and 11 exit lifecycles through the binding with real audio (positive per-row win-sound wait ticks). Shared-channel replacement/unload and callback host errors are checked. The 14 adapter tests, six existing D1 tests and four combined app checks pass. The existing x86 D1 oracle passes 509 scenarios / 16,096 steps / 39,879 effects, zero mismatches. Two independent review passes found no P1 or blocking P2 issues; coverage/reporting requests and the remaining test-detail nits are addressed.
- Failure policy: missing clips and the backend's NO_RESOURCE load/output failures continue silently. Invalid/unsupported descriptors, ambiguous or corrupt assets and other backend failures return a named host error rather than silently completing. This follows the packet and existing native conversation policy; it is a deliberate native safety difference from the original's void sound calls.
- Full-suite limit: canonical rebuild stops at `build_action_family_1b_runtime.sh` (missing scene parser symbols). A read-only audit also finds non-executable `build_action_family_45_runtime.sh`, `build_action_family_47_runtime.sh`, `build_action_family_4b_runtime.sh`, `build_action_family_65_68_69_runtime.sh`; `build_game_exe.sh` lacks the pinned i686 ld tool. These predate the slice. Full discovery was stopped after 1,418 reported cases because legacy mutation-test aborts generated macOS crash dialogs. A temporary signal handler did not contain every sanitizer abort, so broad discovery was not restarted again. No full-suite pass is claimed. The changed-path tests all pass.
- Next playability blocker: static investigation finds the generic pointer fallthrough guard also suppresses reconstructed puzzle projection/hit/click paths. Fix that guard before secondary-button rotation. Remaining broad gaps include popup/state-machine integration, saves/restores, right-button input, cursor rendering and both campaign playthroughs.

Reproduction (repository root, original resources read-only; Unicorn and audio-host commands outside the sandbox):

```sh
outputs/blackmoor-decomp/scripts/build_native_app.sh
python3 -m unittest discover -s outputs/blackmoor-decomp/tests -p test_puzzle_sound.py -v
python3 -m unittest discover -s outputs/blackmoor-decomp/tests -p test_native_puzzle_audio.py -v
work/tools/oracle-python/bin/python -m unittest discover -s outputs/blackmoor-decomp/tests -p test_action_family_d1_runtime.py -v
PYTHONPATH=/private/tmp/blackmoor-native-validation-deps work/tools/oracle-python/bin/python outputs/blackmoor-decomp/tests/action_family_d1_runtime_original_oracle.py --result work/playability-20261024/d1-original-oracle2.json
LIVE_AUDIO_OUTPUT_SMOKE=1 python3 -m unittest discover -s outputs/blackmoor-decomp/tests -p test_live_audio.py -k test_output_mode_smoke -v
script/run_test_suite.sh -v
```

Pinned SHA-256: original GAME.EXE `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`; native app `2b2d4660934a70502b0bcf2270d29b403797f49d14b6a369284bfac2eede7517`; test-hook app `57f36dab7697fb3ed9f7b5dd738b755abee5f224bc56e51c956fcbd6b56945c7`. Full local logs and original-code hashes remain in `work/playability-20261024/` and the existing immutable RT-35 evidence. No ledger/evidence outputs were changed.

Unverified branches: descriptor loader flags other than 2 or loop mode other than 1 are explicitly rejected (none in the D1 corpus); original DirectSound/decoder/mixing parity, real-device completion and suspension, D1 via live GUI input, all other puzzle audio adapters, complete saves and both end-to-end difficulty campaigns. The mixer peak 1.274239 in the clip sweep exceeds unity; output clipping/gain parity is not established. Sandboxed Unicorn initialization caused two Python crash alerts; outside-sandbox initialization and the oracle pass. New native regression failures use normal exits, not aborts.

Interrupted discovery reported these existing failures: `test_action_family_1b_runtime.BuildAndCorpus.test_build_script`; `test_action_family_1c_runtime.UnitTests.test_mutations_are_detected`; `test_action_family_43_runtime.OriginalOracle.test_quick_scenarios_against_the_original_dispatcher`; `test_action_family_4b_runtime.BuildAndCorpus.test_build_script`; `test_action_family_6d_9a_runtime_oracle.QuickOracleAgainstTheOriginal.test_scenario_list_covers_both_families`; `test_action_family_76_runtime.UnitTests.test_sanitizers_on_the_unit_cases`; `test_action_family_77_runtime.UnitTests.test_sanitizers_on_the_unit_cases`; `test_action_family_94_runtime.OriginalOracle.test_quick_scenarios_against_the_original_dispatcher`; `test_action_family_aa_runtime.UnitTests.test_sanitizers_on_the_unit_cases`. Missing NumPy also skips some original-oracle classes. These paths are outside NATIVE-01; neither tests nor reserved evidence were weakened or rewritten.
