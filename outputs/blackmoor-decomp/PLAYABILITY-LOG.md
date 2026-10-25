# Native playability log

2026-10-24, baseline `b4cbef99`, NATIVE-01 candidate `2caa5a65` (ARM64 macOS, original GOG data). The whole game remains incomplete.

- GUI: launched the real native app, clicked New Game and Junior Detective, observed S0 captions and the opening letter, then reached S2010 through the opening sequence. Fullscreen preserves 4:3 with side bars on the current widescreen display. Local captures: `work/playability-20261024/gui-S0.png`, `gui-S2010.png`, `title-fullscreen.png`. Mouse automation is intermittent (`noWindowsAvailable`); fullscreen activation enabled the two verified clicks. Right-click and room-hotspot GUI checks remain unverified.
- Headless: 24 distinct scenes through S2010; original S2010 row 5 enters S2008 (25 scenes). S4808 raw 0x83 row 6 applies. S2008 stays running at the tick limit, with no session error; further interaction is unverified.
- Movies/audio: all 504 opening-movie frames and 12 movie sequences complete on the S2010 path. Offline soundtrack PCM is nonzero and finite. The hardware-output smoke plays a real clip and unloads successfully; speaker audibility and device-completion/suspension are unverified.
- NATIVE-01: D1 turning-puzzle sound now loads, plays, waits and unloads through live_audio. Regression failed on the original silent callback and now passes all 20 named clips across 11 original rows, plus 11 solved and 11 exit lifecycles through the binding with real audio (38–39 win-sound wait ticks). Shared-channel replacement/unload and callback host errors are checked. The 14 adapter tests, six existing D1 tests and four combined app checks pass. The existing x86 D1 oracle passes 509 scenarios / 16,096 steps / 39,879 effects, zero mismatches. Independent review found no P1 issues; lifecycle coverage and reporting requests are addressed, final re-review pending.
- Failure policy: missing clips and the backend's NO_RESOURCE output failures continue silently. Invalid/unsupported descriptors, ambiguous or corrupt assets and other backend failures return a named host error rather than silently completing. This follows the packet and existing native conversation policy; it is a deliberate native safety difference from the original's void sound calls.
- Full-suite limit: canonical rebuild stops at `build_action_family_1b_runtime.sh` (missing scene parser symbols). A read-only audit also finds non-executable `build_action_family_45_runtime.sh`, `build_action_family_47_runtime.sh`, `build_action_family_4b_runtime.sh`, `build_action_family_65_68_69_runtime.sh`; `build_game_exe.sh` lacks the pinned i686 ld tool. These predate the slice. Full discovery after the audit is running; no full-suite pass is claimed.
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
