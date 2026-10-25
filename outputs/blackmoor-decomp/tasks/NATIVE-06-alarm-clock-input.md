# NATIVE-06: leave the bedroom alarm clock through native input

Original human chat authorizes the native ARM64 port, real-data room navigation, focused checks, independent review, one PR per slice then merge. Root in this chat alone publishes. Keep game mute on. Never modify original game/GAME.EXE/game-source, ledger/evidence/extract/build ledger outputs, tests/fl40_* or tasks/flNN-handoff.md. Claude owns full decompilation/matching. No broad discovery, sanitizer/mutation/Unicorn/deliberate-fault or audio-output tests. Read project AGENTS and PROJECT-SPEC.

Base merged main ae8e1bbb. Actual muted normal app reaches S2175 via New Game/Junior row 34, S2010 left 11 selector 16 -> row 9 -> S2013 row 3 -> S2020 row 2. S2175 row 3 raw 0xaa draws, but input returns LIMIT_PRIORITY_PATH 3 and never hits/clicks. Baseline local navigation-alarm-baseline.log: 27 scene entries, last S2175, status 0, controls unusable.

Root owns shared blackmoor_app.mm and integration. Worker owns only NEW tests/native_alarm_clock_glue_test.mm and tests/test_native_alarm_clock_input.py, in its own worktree. No worker publication. Existing runtime/binding kernels stay unchanged.

Implement bounded readiness: exactly one raw 0xaa and no other possible cascade-owner family; existing UI/producer/modal/overlap guards stay. Execute existing clock pointer at original cascade 0x4f1004, before overlay/navigation/generic; preserve non-hit clock over/button/dirty effects and held-item prelude. Pointer projection uses a state copy; only real consume consumes edge. Publish candidate/cursor on hit, early return. Accepted release invokes existing clock click at0x43b3bd with real row phase; remove app's extra candidate gate (original method guards itself and takes no candidate). Correct lifetime/reset, avoid old stale pre-ACT pointer call and post-navigation override. Keep unknown owners explicitly limited.

Acceptance: tests first, actual app callbacks and real S2175 resources loaded read-only (no resource bytes committed). Meaningful observable alarm mode -> increase/decrease/time/cancel and timed state progression, candidate retention/release with absent candidate, no-hit and inactive states, modal/producer guard and unknown-other-owner refusal. Keep tests proportional. At least actual-app route must click Cancel and return to S2020 through real transition; no candidate/flags/scene injection in that route. Component fixture may stub non-input sinks explicitly, like existing native_d1_pointer_glue_test.mm. Build fresh production C module inventory; normal signal handlers and CHECK exit1, no faults. No audio output; offline normal route may need host execution because sandbox AVFAudio manual-rendering refuses normally.

Record precise source/native/original pins, independent frozen review and unverified sound/idle timer/render layering/campaign/GUI limits. Never claim whole-game or whole-file matching completion.

## Implementation and evidence

Root added a readiness predicate admitting exactly one raw 0xaa and no other possible owner, retaining the three original UI guards and all session_input mode/producer/projection semantics. Existing modal propagation is unchanged; modal_event is not an invented hover veto. The post-ACT scan projects from a copy and runs clock pointer 0x44d28c before overlay/navigation/generic, preserving non-hit effects and the held-item cursor prelude. A hit publishes candidate 10094 (0x276e) and original cursor cells and returns. The old pre-ACT pointer poll and later candidate override are removed. Accepted release calls 0x44d624 without the app's extra candidate gate, using the real row phase; pointer/click errors are explicit failures. No kernel, binding or world reconstruction changed.

Static original anchors were read from existing disassembly and checked against original GAME.EXE bytes (no original-x86 execution):

| Range | SHA-256 |
|---|---|
| GAME.EXE, 1,511,424 bytes | afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45 |
| 0x44d28c..0x44d597 pointer | 5122b89df40c45c230f74e9cc21d9a09296e413aaa44038595344255321cf200 |
| 0x44d624..0x44d711 release | 5e2e0bcb06613a9fc6bb1fa2b89eae56bd1f6f5c0629433ba3aef70f4c64f2e4 |
| 0x4f0fef..0x4f1017 cascade call/early return | 865ed108a52e2563e85aea45fc9fb736c39b96787cc78a449df50c640ed04339 |
| 0x43b3ae..0x43b3c2 accepted release call | 138bd23bdf21b434b3a19c4805be1fced0198bc122f9ed7507707c44b1bd8992 |
| Owner-local S2175, 1,764 bytes | 2f6147efdc98af936815ff153ffa3b7811f1bf4de84ca153c017b2cb705964c4 |
| blackmoor_app.mm | 618c561e446051126e70ac8a9335633ee7fea59e7dc4476df7b12599c1dc0dfe |
| Normal ARM64 executable | b6665c42b692d16bc19e119be08674416267a26fdaf17487c0346e0aab57aa64 |
| native_alarm_clock_glue_test.mm | be00b9a715395cbef15f664df17d4576733e414c37c0a7206f7790e842d1ee23 |
| test_native_alarm_clock_input.py | 7f4a7b09cf425563cde009ab7f4a1aacf10a2021c66205fc3c3f2f86e0e4a53e |

Private logs and metadata remain under work/playability-20261024/; no original resource payload or executable is committed. Original calls 0x4f1004 and0x43b3bd are direct evidence for order and absence of candidate gate. Existing RT52 recovery is prior evidence, not a new oracle result.

## Validation

- Baseline component RED: fresh inventory compiled, actual real-scene callbacks returned consume 3/scan 3/candidate -1, ordinary CHECK exit1. Worker log /private/tmp/native-06-alarm-component-red.log. Collected tests-only worker 402fff1d as b65e2d81; root alone publishes.
- Proper-coordinate normal app RED: enters S2175, receives Cancel UP at 421,265, never returns to S2020; ordinary regression check exit1. Log navigation-alarm-cancel-red.log. Earlier exploratory click 320,350 was outside Cancel and is NOT counted as Cancel regression evidence.
- Normal app GREEN: one-shot entry 472,217 in S2020 and Cancel 421,265 in S2175, actual candidate 10094/button 8, real click/phase 2/completion/cancel block; transition2175->2020, final S2020 status 0. 27 distinct scenes/28 scene entries on this path. No candidate/phase/flag/target injection. Log navigation-alarm-cancel-green.log. Exact CLI: `--mute --inspect-live-session --live-click-row 34 --live-nav 2010:left:11 --live-scene-row 2010:9 --live-scene-row 2013:3 --live-click-at 2020:472,217 --live-click-at 2175:421,265 --live-ticks 3000 --rand-seed 1`.
- Seven component checks passed against root source in worker 15.637s: mode buttons, +/- hours, time mode and press delay, cursor cells, early generic priority, retained accepted-edge callback interleaving with candidate cleared, Cancel completion/inactive fallback, miss effects, all three UI guards, mode2/disabled producer and unknown CF priority refusal. Component render/sound/finish hosts are explicit sinks; this does not claim real sound playback or rendering equivalence.
- Existing D1 pointer regression: 9 passed in 15.823s (alarm-d1-regression.log). Existing IV regression: 2 passed in 41.080s (alarm-iv-regression.log), including cradle flag/dependent S2188 transition and unknown-owner refusal.
- Normal ARM64 app build and diff whitespace check pass (alarm-first-build.log). Main app persistent mute preference 1 confirmed. No broad discovery, sanitizers, mutation, Unicorn/original-x86, deliberate-fault or audio-output tests were run. Earlier full-suite failures remain unresolved; owner explicitly excluded crash-popup tests.
- Root full clock suite: 8 passed in 40.862s (alarm-input-green.log), including the actual muted one-shot Cancel route. Independent frozen Sonnet review accepted below.

## Unverified branches

No new GUI check while the Mac was last reported locked; no live visual/speaker claim for this slice. Real alarm setting/wake-up/final-sound flow, clock sounds (existing app callbacks still log NOT PLAYED), idle-timer integration, cursor sprites, exact layer ordering, overlapping live overlay/clock hotspots, held-item-specific geometry and both complete campaigns remain unverified. Component retained-edge interleaving is a callback-contract check, not a claim about normal app tick scheduling. Modal propagation is unchanged and not separately exercised by the new tests. Unknown or multiple cascade-owner families remain explicitly limited. No full-game playability, whole-file matching, original compiler provenance or function-ledger status claim is made.

## Independent review and root disposition

Independent Sonnet slice-reviewer statically reviewed frozen cb5878f89c2a203a4ca22518f7aecde0ea3fa0fb against main ae8e1bbb and the original disassembly. Verdict: no P1 or blocking P2; accepted for collection. It confirmed the original early-return cascade order, candidate-independent release, consume-before-ACT/post-ACT-scan timing, copied projection, ownership exclusions and explicit error behavior. Private report: independent-alarm-review.txt. Root accepts the review and records the following dispositions; production and tests remain unchanged after the freeze.

- P2.1 in-bounds non-button release is already covered by retained_release: the real digit rectangle scan asserts candidate-1, over nonzero, retained button1 and an unconsumed accepted edge, then consume asserts PRESSED and edge0. This meets the proposed missing check. Its callback-interleaving limitation remains explicit.
- P2.2 error returns are unexercised: accepted as a residual coverage limit. No new failure-injection test or deliberate fault is run; the failure paths freeze rather than fall through by static review. No claim that these branches passed a live app test.
- P2.3 modal event and cursor modes3..5 are unexercised by these tests; mode2 and producer-disabled are covered. Existing shared semantics remain unchanged. Accepted as a residual limit.
- P2.4 mutation checking is intentionally excluded by the owner's crash-popup restriction. Consume-before-scan ordering is source-verified, but a separate timing regression that detects reintroducing a stale pointer poll is unexercised. The accepted-edge test catches the removed candidate gate.
- P3 held prelude supports the native-reachable held-flag0 arm. The original0x5b44f8-nonzero arm and cursor sprite globals0x5d162d/0x5d1631 remain unmodeled. On a scan error, the cursor/nav prelude may already have run; the session then freezes. Inactive clocks safely fall through even without render registration. The cursor-field assertion is a wiring check against the real body, not a new original-code oracle.

Publication stays in the original authorizing root chat. NATIVE06 changes only app glue, new tests, this packet and the short playability log. No reserved files or original game content changed. Full native gameplay and whole-file x86 matching remain incomplete.
