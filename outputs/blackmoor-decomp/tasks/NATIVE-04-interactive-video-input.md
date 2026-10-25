# NATIVE-04: restore Newton's cradle interactive video

Original human goal: playable native ARM64 macOS game, real-data checks, one slice per PR, tests then independent review then merge. Latest steering: continue room navigation and fix the next blocker, avoid tests that caused crash alerts, and keep game audio completely muted while the owner uses other Mac audio. Original authorizing root chat is the sole publisher; delegates only prepare reviewed commits. Never edit original installation/EXE/game-source, ledger/evidence/extract-build outputs, tests/fl40_* or tasks/flNN-handoff.md.

Baseline reviewed navigation: main `8c0e693d` (PR179). NATIVE-03 mute is being reviewed separately and must merge before this slice is published. Root owns shared app/binding/build integration. Codex gpt-6.1-sol xhigh worker may create only `src/interactive_video_input.[ch]` and `tests/test_interactive_video_input.py` in its separate worktree after confirming an API proposal with root. The worker may read existing original_methods files and evidence but must never edit them. Root will add actual app integration and a focused real-scene regression separately.

## Reproduced blocker

S2008 row3 returns to S2010 correctly. The next route is one left edge step from selector5 to6, S2010 row7 -> S2011 row5 -> S2019 row3 -> S2186 (Newton's cradle). Use the normal native app with:

```
--inspect-live-session --live-click-row 34 --live-nav 2010:left:1 --live-scene-row 2010:7 --live-scene-row 2011:5 --live-scene-row 2019:3 --live-click-at 2186:330,160 --live-ticks 2450 --rand-seed 1
```

The run returns status0/provider none but the interaction is unusable. IV row6 stays phase0 because app getters return state0/empty name/-1/no origin. The normal gesture has candidate-1 and scan priority limit3. The scene repeatedly reloads. Private exact commands and logs are `work/playability-20261024/room-investigator-2186-reproduction.txt` and `room-investigator-2186-click-main.log`.

## Required semantics and boundaries

Original handler `0x4cb586..0x4cb8d5` SHA256 `91e675c3a72629218d9b961ae84b177a59581568d0f19b4e52b8f4110288ab76` is already in `action_family_1c_runtime.c`; do not rewrite it. Original hover `0x4cb058..0x4cb3ab` SHA256 `568624cd62497da9fc1e586881fcf96b7ebac155ecb597534087bfeef8da33f8`, release `0x4cb3ab..0x4cb586` SHA256 `da3fefcf655fa56e0f65469e029f17b2833668ce865d5bb9a76f7751c73b8aca`. Existing original_methods_fl25b.c:m4cb058_hit_test and original_methods_fl24a.c:m4cb3ab_store_flag are navigation aids; immutable original bytes and assembly govern. Never claim new original-x86 coverage or ledger acceptance from native-only checks.

Expose actual A35 snapshot/name/origin. `shown` is player state +0x240; `presented` is frame +0x244 (not the selected view-record index). Name must be the actually opened movie. Player origin comes from selected record's view-relative destination (+0x12/+0x16), not a second viewport offset. IV has20 frame entries ids0..19. Raw1c must activate through its existing handler, then use original IV rectangle/outer-hit candidate0x27b0/0x27b2 and retained-hover release to store the configured flag pair (S2186:1000,1). Keep release before ACT and hover after ACT. The original IV hover call0x4f107c follows the overlay call0x4f104f and precedes navigation/generic rows; do not copy D1's earlier-than-overlay order.

Scope projection readiness only when the real scene has exactly one1c owner, no other possible unmodeled member, and all existing UI/mode/producer/geometry guards pass. Unknown earlier owners must retain explicit limit. Preserve actual held-item branch effects or explicitly refuse unsupported host effects; never invent success. Cursor drawing remains a separate host limit.

## Acceptance

Native normal-exit tests first against meaningful missing behavior; no assertions that abort, sanitizer/mutation/Unicorn/deliberate-fault runs or output devices. Synthetic helper tests should exercise original observable rectangle order, inclusive bounds, retained release/flag effects and failure boundaries without duplicating the implementation. Root's complete owner-local S2186/IV scene integration must activate through the actual A35/1c bindings, hover, primary release, set flag1000 to1 and continue through the real scene dependency/transition, plus a guarded unknown-owner case. No forced candidates/latches/puzzle phases. Read local resources in place; commit no resource payloads. Keep scene-generation/lifetime reset and pointer invalidation explicit.

Freeze exact source/native hashes, commands/results, independent review and unverified branches before publication. Full suite remains not green and the crash-producing tests remain stopped. Neither whole-game playability nor whole-file x86 completion is claimed.

## Additional owner steering

The owner clarified that this chat owns the native ARM64 Mac port while Claude owns the full decompilation/matching project. Code fixes are welcome; keep native playability work moving and do not imply offline checks prove a continuous GUI playthrough. The owner also requested widescreen support. Current presentation only fits the original4:3 framebuffer with side bars. Plan a separate native presentation slice after this blocker: inspect actual source image bounds, avoid distorting/cropping gameplay or controls, and keep input mapped to640x480 logical coordinates for all sizes. Do not synthesize or modify original assets. A final full-width layout choice is not yet settled.

Owner's widescreen decision: offer BOTH proportional and stretch-to-fill modes. Implement as a separate native presentation slice with a persistent display setting and correct640x480 logical input in either mode; preserve original assets. This replaces the previously unsettled layout choice.

## Root native integration

Root began implementation from merged mute main `3b09101fd4a2c9cebbb05e135237e4907d2eb360`. The worker supplied the typed helper (`daf4109e`, collected06c368a1) and two new actual-app fixture files (`10ae8393`, collected5b65b517). No worker published or edited shared files. Root alone added the two read/borrow accessors, native app glue and build registration.

The A35 session exposes its actual controller snapshot without mutation. The app records the row and exact33-byte name only when its native Bink open succeeds, and clears ownership/name on close. IV getters use `shown`/`presented`, not the view-record number. The selected record's four raw destination dwords are read from the validated35 body without the presentation's added viewport origin. The origin rectangle is retained when the existing1c handler requests its origin, matching the retained original record pointer. Existing1c handler/file/render logic is unchanged.

The separate input sidecar represents original pointer identities with object/IV/body identity, generation and entry/rectangle indices; original32-bit pointer fields154/158 are not populated with truncated host addresses. It resets on scene/IV lifetime replacement, not ordinary frame selection. The actual flag span is shared with scene conditions. Original held-item restoration is implemented by the helper but the app's0x4ea06c host remains an explicit refusal when that branch is reached; freshS2186 needs no restoration. Cursor index/variant/layer metadata is committed; original sprite/surface drawing remains unmodeled.

Projection is admitted only for exactly one1c member and no other possible unmodeled member, with existing UI/mode/producer/geometry guards. IV release runs on the real consumed primary edge beforeACT, independent of the generic0..239 candidate range. A copied input state supplies projection only; it cannot consume the real edge twice. A copied overlay probe determines whether the original earlier overlay claimed the point. Only overlay miss reaches IV hover; a hit returns before zones/generic rows. A miss uses the existing pipeline. The held-item cursor prelude is preserved even when IV's cursor selector is-1. Unknown owners retain an explicit priority limit.

## Acceptance evidence

- Helper tests first:10 meaningful failures against ordinary-return stubs; then10 pass, root rerun0.232s (`ivi-helper-root.log`). No native fault/abort, original-x86, sanitizer or mutation execution.
- Actual-app regression first: fresh baseline main3b09101f plus unused helper compiled, but both cases failed normally: noIV activation/hover/flag/transition; sole1c projection limited3. The opaque-CF negative case remained limited3 (`/private/tmp/native-04-iv-app-red.log`).
- Final actual-app regression:2 cases pass43.984s (`ivi-app-final.log`). The complete owner-local scene/movie/IV path uses the actual app entry, actual35/1c bindings and normal scripted MOVE/DOWN/UP. It activates phase1, observes presented frames beyond0 while the selected view record stays0 and raw origin stays207,74, publishes10160 (0x27b0), storesflag1000=1 on release, and the real dependent raw0x0a row entersS2188. The script later re-entersS2186 after the animation/return; final status0/provider none does not imply a full puzzle campaign or a monotonically increasing route.
- The ownership negative case is explicitly a component fixture: realS2186, genuine row-type derivation and actual native_pointer_context/session_input_tick. A sole1c owner projectsOK; an opaqueCF row appended in memory yields limit3, pointer invalid and candidate-1. It does not claim the executor can executeCF or force any puzzle phase.
- Earlier native D1 pointer regression:9 cases pass17.295s (`ivi-d1-regression.log`), including real offline audio gating and original guards.
- Normal and test-hook ARM64 apps build from the final source (`ivi-final-build.log`, `ivi-final-testhook-build.log`). All fixture compilation uses fresh temporary objects, no shared build outputs or copied proprietary fixture bytes.

These are native-port checks. No new original oracle coverage, ledger acceptance, whole-file matching or green-full-suite claim follows. The broad crash-producing tests remain stopped. All game assets and reserved ledger/evidence files are unchanged.

## Pins

| Artifact | SHA-256 |
|---|---|
| Owner's original GAME.EXE | `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` |
| Owner's NewtonCradle.iv (697B) | `dcc2d719d1d29a7daea1719f15e112dd9a34e135966ad9fa459aae79b73c36b2` |
| Owner's NewtonCradleANIM.bik (483868B) | `1dc6bbab3899fced94fbbb79935be9d7d361efb91ad93af750b0b407412fc01c` |
| `src/interactive_video_input.c` | `c8fea6af4befe81835f9dcfc3ee49b778e2051931ee7a817902801a159efe8d8` |
| `src/interactive_video_input.h` | `790cb5226750cbae18b879ff22cba96b6c49bc4152d972f2bad57ac0bf65c7b8` |
| `src/blackmoor_app.mm` | `dce9981795ccb8e2808559360dbc6d508473e5142768a2d4a0971f3ed11db65b` |
| `src/session_bindings_a35.c` | `371c03c4f5283be0c745f0586b6a372634b0441f0cea75201a91def078c2fb02` |
| `src/session_bindings_a1c.c` | `3328091c367f5424b925f64e2c231f750dff0ece662aa1223c2f1076d7b26dfa` |
| Normal ARM64 app | `944e6cff163286f3184208d1c174b00dcdd3fab5f01a534beeae288c74171aa3` |
| Test-hook ARM64 app | `ce701cde9625a16a41ccf198eb05601632c1051cd0ca14d2f2c4fb3f50a019ba` |

## Unverified branches and remaining limits

Live GUI cradle play, S3420's separate content, held-item restore in the actual app, overlapping live overlay/IV hits, physical cursor sprites and provisional hot-point geometry, movie-selector changes with a retained origin, and both complete difficulty campaigns remain unverified. Helper unit cases cover retained rectangle identity across current-record changes, outer fallback, inclusive hit order, held/cursor/flag effects and native refusal bounds; this does not promote the app's unbound restore callback to supported. There is no new original-x86 oracle run. Full-suite failures remain as documented inNATIVE01.

GUI room evidence remains separate: the muted real GUI reachesS2010, and an ordinary primary release at210,85 consumescandidate5 and entersS2008 (`muted-gui.log`, screenshotsmuted-room-S2010/S2008.png). CUA returned a desktop-change guard during one action, so the click's automation attribution is uncertain; no continuous GUI click-through or GUI cradle success is claimed. The native game stays muted; current display remains proportional4:3 with side bars. Owner-selected proportional/stretch modes are the next independent presentation slice.
