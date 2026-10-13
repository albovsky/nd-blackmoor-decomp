# I01/I02 scoped scene-runtime integration plan

> **Status:** partial integration ready for root review. This plan is authorized by the root orchestration message dated 2026-10-13; it does not close the original gated I01/I02 packets.

## Goal

Integrate source-proven BOOT/New Game state, typed scene boundaries for actions 0x62 and 0x64, the supported 0x64 clock callback, and timed host-side Bink frame advancement into the native headless scene path. Preserve unsupported branches as explicit errors. Do not claim BinkWait equivalence or live gameplay while prerequisites remain unresolved.

## Binding limits

- Original `GAME.EXE` and installed assets remain read-only.
- Root authorized this worktree as the exclusive shared integration checkout. Root will not edit its parser/executor/app/build files while this integration is active.
- A-28 and A-51 modules remain unavailable until their reviewed commits arrive. Do not include or edit their owned files.
- A-62 parser registration is allowed; A-62 interaction/host-provider execution stays unsupported. Do not synthesize phase 2, event `0x271d`, event storage, selector mappings, or completion.
- A-64 receives the two source-order tick reads supplied by the host callback. Host pacing uses decoded timestamps; original `BinkWait` timing policy remains unproved.
- A successful bounded native/headless fixture does not close I01/I02 or imply full gameplay equivalence.

## Task 1 — parser boundaries

1. Add failing fixtures for raw type 0x64 exact five-byte bodies and raw type 0x62 count-driven `12 + 18*n` bodies; include a separate 16-byte dependency tail.
2. Cover 0x62 truncated prefix and each short count-1 entry prefix, negative count, max accepted count 1819 and rejected 1820, malformed dependency remainder, and opaque sibling 0x63.
3. Register the layouts in `scene_resource.c` without changing `SceneActionInfo` ABI.
4. Run parser tests and parse every actual SCEN DATA record in the available HIFF corpus, comparing 0x62/0x64 body and tail splits with count/layout evidence.

Expected: 0x64 exposes five typed bytes; 0x62 exposes exactly `12 + 18*count` typed bytes with the remainder independently aligned as dependency records. Malformed resources fail before any body read beyond the available payload. Raw 0x63 remains opaque.

## Task 2 — A-64 scheduler callback

1. Add tests for eligibility, subtype lifecycle/completion/dependency reset, state visibility to later rows, and two ordered tick reads in active controller mode.
2. Add an optional executor extension/callback path without changing legacy public struct layouts or function signatures.
3. Bridge the actual host tick source to `action_family64_step`, commit world state only for applied rows, and publish updated minutes to dependency evaluation.
4. Keep unsupported/failed host calls atomic and observable.

Expected: legacy executor ABI stays unchanged; type 0x64 only runs after scheduler eligibility; false eligibility mutates nothing; supported subtypes match the leaf reducer’s result.

## Task 3 — New Game world inputs

1. Compose `world_init_apply_new_game` with the verified BOOT settings and caller-owned world spans.
2. Initialize the BOOT UICL phone rows through the bounded source-record getter, preserving source rows before the existing native UI sorting.
3. Keep cold-process zero-fill distinct from same-process New Game reset behavior.

Expected: New Game initializes the proven clock/start tuple/phone rows and selected reset spans; unknown global capacities and the remaining initializer are still documented as unknown.

## Task 4 — timed video provider

1. Integrate `BinkPlayer` as a timestamp-paced host provider in the headless/native scene path.
2. Advance and expose frames according to source media timestamps, preserving non-looping boundaries and explicit provider failure.
3. Label this as host adaptation; do not claim proprietary decoder or BinkWait parity.

Expected: an automated headless test advances a real opening resource on a deterministic injected monotonic clock, with no GUI/audio output.

## Task 5 — combined evidence

1. Run focused parser, executor, world-init, Bink, and scene-inspector tests; run actual-resource corpus checks and applicable original oracles.
2. Build affected libraries and the native app; run headless OPEN_A checks.
3. Generate a bounded receipt with source/test hashes, actual resource identifiers, observed result, and explicit unsupported paths.
4. Self-review the diff; root owns independent integration review and combined suite/merge.

Expected: the report identifies exactly where live execution stops when a required A-28/A-51/A-62 provider is absent. I01/I02 remain partial until their packet acceptance conditions are satisfied.

## Partial integration evidence (2026-10-13)

The shared parser registrations for A-62, A-64, and A-51 are in the predecessor commits. A-62 parser coverage walks all 2,078 decoded SCEN resources (19,612 actions; 1,802 type-0x62 rows) and confirms each count-derived 12 + 18*n body plus a separately aligned dependency tail. A-64 source coverage has seven exact five-byte rows. These facts do not provide an A-62 selector/provider.

This integration binds the A-64 clock kernel after scheduler eligibility, commits its snapshot and completion/phase state, requests dependency reset for subtype 2, and makes updated minutes visible to later rows in source order. A caller-owned clock snapshot survives inspector scene transitions; the New Game clock initializes its original BOOT values, and the host supplies ordered monotonic tick reads. A-62 interaction remains explicitly unsupported; event `0x271d` is not used as an A-62 completion.

The native New Game command applies only the verified S01 fields to bounded caller views, uses the BOOT start tuple/clock, performs the selected scene-clear span, and records the loaded scene visit. UICL phone records are read as 41-byte source-order rows and copied/sorted through the existing native UI layer. Caller view lengths are not original global-capacity claims.

Native and headless scene paths use `BinkPlayer` in forward non-looping mode. The app copies borrowed RGBA before the next player advance; the inspector advances its frame input against offline-audio-derived timestamps. Installed S0 and S5900 backgrounds each contain one frame, so the installed-resource fixture reaches frame zero and terminal state. Player-level tests cover the 504-frame opener in both directions and timestamp boundaries. FFmpeg timestamp pacing is a host adaptation; original BinkWait timing, proprietary decode parity, AVF, caption rendering, full UI/input behavior, and complete scene execution remain unverified or unsupported. The headless S0 -> S5900 transition is a bounded diagnostic fixture, not live gameplay.

Focused validation on this partial handoff: native app build; `test_world_init.py` (12), `test_action_family_62.py` (13), `test_action_family_64.py` (14), `test_scene_resource.py` (17), `test_scene_executor.py` (26), `test_bink_player.py` (5), and `test_native_app.py` (6) passed. Original isolated oracles compared the bounded A-62 fixture set (10) and A-64 set (25, zero mismatches). The installed-resource headless fixture exited 0 through S0 -> S5900. These checks do not satisfy I01/I02 acceptance: caption rendering, A-62 interaction/provider behavior, unsupported A-51 runtime cases, sound/UI integration gaps, and actual live gameplay are still open.
