# NATIVE-02: recover the D1 app pointer path

Baseline: `37cb43c7ec6de43f91556571f26f9b107ae779ec` (NATIVE-01 sound candidate).
This packet concerns one app integration bug. It does not claim a complete
playable game, original cursor geometry, sound equivalence or an x86 match.

## Authorization and ownership

The original human scope and publication authority stay with the root chat.
The root delegated these three new files to the Codex regression worker:
`tasks/NATIVE-02-d1-pointer-path.md`, `tests/native_d1_pointer_glue_test.mm`,
and `tests/test_native_puzzle_pointer.py`. The worker branch is
`codex/native-02-pointer-regression`, in `/private/tmp/blackmoor-pointer-regression`.
The worker may commit these files after demonstrating the meaningful baseline
failure. It may not push, merge, publish, edit production/shared files, run
Unicorn or dispatch helpers. Root owns production integration, independent
review, combined verification and publication.

Do not modify the original installation/EXE, game-source descriptor, ledgers,
evidence/source pins, extracted resources, build/ledger outputs, `tests/fl40_*`
or `tasks/flNN-handoff.md`. Build the new regression only in temporary storage.
Read assets in place; never save or commit copied resource payloads. No GUI or
audio output device is needed. All expected native test failures use exit 1;
fixture errors use a normal nonzero exit. Signal handlers are installed before
fixture allocation and use only async-signal-safe writes and `_exit`, reporting
the fault number if an unexpected native fault occurs.

## Concrete failure

`native_pointer_context` requires `nav_members_idle` for `priority_clear`.
`session_navigation_members_idle` correctly regards a D1 row as a possible
non-generic cascade owner. `session_input_tick` nevertheless uses that generic
fallthrough declaration while projecting the pointer. Consequently an ordinary
overlapping pointer in a D1 scene returns `SESSION_INPUT_LIMIT_PRIORITY_PATH`.
The app gates its D1 pointer/click calls on successful projection, and its scan
gates candidate publication on successful generic/navigation scanning. The
reconstructed D1 receiver and click kernel exist but cannot be reached normally.

The regression reads the complete real S4376 scene, resource 2622, in place.
Its SHA-256 is `3a1237be948adf4f9e4212ff9cb4ffda65e5ab366bf62675dfe6c1f075312599`.
Row 1 is raw D1, has no dependency tail, and its 927-byte body SHA-256 is
`1c2b1597d48d262968cadec10cb3943369759362e2be43b9df94cfdea81e0473`.
The literal tile-0 hit rectangle is `(200,238,249,303)` in view-relative space.
With origin `(10,10)`, a MOVE to `(234,280)` must hit tile 0 and publish `0x276c`.
A primary DOWN followed by UP, with no intervening MOVE, must then turn tile 0.
The UP deliberately carries `(11,11)` to check that message coordinates do not
replace the retained MOVE/candidate/hit-list state.

The real native app `pointer`, `native_pointer_consume`, `native_pointer_scan`
and `native_ad1_handler` run through a real `SceneSession` and
`SessionAd1Binding`. The fixture never writes a candidate, latch, last-tile,
moving flag or puzzle phase; phase 0 and phase 1 come from normal dispatch.
Expected output on the frozen baseline is an ordinary exit-1 pointer failure:

```text
D1_PATH fixture=real-S4376 hover_consume=3 hover_scan=3 candidate=-1 tile=0 release_consume=3 state=0 moving0=0
FAIL: a real D1 tile must publish candidate 0x276c and turn through the actual app release path
```

## Immutable-byte anchors and required order

The local original is 1,511,424 bytes, SHA-256
`afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`.
Direct original-file reads confirmed these ranges (ends exclusive):

| Range | Role | SHA-256 |
|---|---|---|
| `0x4b5d17..0x4b6097` | D1 pointer receiver | `e117e759992c878ceac68d51b408bd7c1cdc673925c349a406aafa96ae8bb92a` |
| `0x4b617a..0x4b6355` | D1 accepted-release click | `8fbbf29fc408c2ecc47c6b647f72e8e8c01301b3825e1c08362be2d4ff36f4cb` |
| `0x4daf3f..0x4daf6e` | Primary edge consumer | `d14f2737a806fb01ffd15002d2d0d291d9bff0f9c77849a4524bc55567db6fcc` |
| `0x4f0b23..0x4f0b36` | D1 cascade call and successful early return | `2d68df4ffe87a2593db35b50b9a6d99be97bff980fe45ab55ea4ba2fbd4822eb` |

Original loop: primary consumption at `0x43b199`, D1 click at `0x43b287`,
ACT dispatcher at `0x43cf2f`, then pointer scan `0x4d3073` at `0x43d13d`.
Thus consume/click uses the preceding scan's retained candidate and `last_tile`;
the receiver belongs in the post-ACT scan, not before ACT in consume.

The earlier receiver order in `0x4f0059` is:

| Type | Call site | Receiver |
|---|---|---|
| `0xc8` | `0x4f097e` | `0x469057` |
| `0xc9` | `0x4f09ad` | `0x4b42d3` |
| `0xca` | `0x4f09d5` | `0x459cc9` |
| `0xcb` | `0x4f0a04` | `0x4a3f40` |
| `0xcf` | `0x4f0a33` | `0x4acf45` |
| `0xcc` | `0x4f0a5b` | `0x48a920` |
| `0xcd` | `0x4f0a83` | `0x4a1e16` |
| `0xe7` | `0x4f0aab` | `0x48e628` |
| `0xd0` | `0x4f0ad3` | `0x48d1e8` |
| `0xd2` | `0x4f0afb` | `0x4a6574` |
| `0xd1` | `0x4f0b23` | `0x4b5d17` |

A successful D1 receiver returns 1 and jumps to the cascade epilogue at
`0x4f2578`, before overlays, navigation zones and generic rows. A D1 miss may
fall through only when other earlier owners are proved idle.

All eleven D1 corpus scenes were inspected: S4376/resource 2622 has types
`37,d1,97`; S4377–S4386/resources 2623–2632 have `37,61,d1,97`. D1 is the
only cascade-member type in every one. Absence of other member rows establishes
idle objects for this bounded scope; `nav_members_idle == false` alone does
not establish that any object is currently active.

Saved REA/Ghidra navigation evidence is
`ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa`
(D1), `ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a`
(cascade), and `work/analysis/slices/RT-17.cascade-members.json` (type mapping).
Pseudocode is navigation; the original bytes and mnemonic assembly govern.

## Minimal production proposal, reserved to root

Keep this fix app-only so evidence-pinned `session_input.*` need not change.
Derive a D1 scope from the actual loaded scene: at least one D1 row, and no
other `session_navigation_member_type`, with all existing guard cells honored.
In that scope the app may declare projection readiness because it will actually
run the modeled D1 receiver. In scan, derive guarded projection from a copy of
input state using the existing module; never consume the real edge twice or
publish an activation from the copy. Move the existing D1 pointer call from
pre-ACT consume to this scan boundary. A D1 hit clears stale navigation state,
publishes its candidate, and returns immediately. A miss uses the existing
overlay/navigation/generic path under the sole-modeled-member proof.

Do not set readiness globally, treat every non-idle member as active, fabricate
a cursor sprite/hot point, call the click on DOWN, re-hit-test the release
position, change modal/producer/mode guards, or alter right-button/UI behavior.

## Regression safety fixture and acceptance

The negative fixture appends one synthetic opaque CF row to the scene in memory
and gives that parsed scene view to the actual app callbacks. The native
executor correctly rejects opaque CF rows, so this negative scope test retains
the original complete S4376 session/binding for row phases; it does not claim
the augmented scene can execute or that Tangram is reconstructed. The actual
app's scene-derived ownership check must still return an explicit priority
limit, leave the candidate absent and leave the D1 tile stationary. It catches
an indiscriminate readiness override without modifying input state.

The original S4376 ambient-sound dependency uses opcode 17. Its fixture
extension keeps only that unrelated sound action inactive and refuses other
extension opcodes. Overlay/sound callbacks are inert non-input host boundaries.
Using the real native D1 sound backend here would additionally require the
PuzzleSound/LiveAudio setup and asset/caption lookup providers; those are
separately tested by NATIVE-01 and would obscure the pointer regression.
No output device is opened, and no assertions target the stand-ins.

Run:

```sh
python3 -m unittest discover -s outputs/blackmoor-decomp/tests -p test_native_puzzle_pointer.py -v
```

Before the fix: real-tile test fails with the expected pointer error and exit 1;
the explicit-unknown-priority test passes. After root's fix: both pass, the real
candidate is `0x276c`, tile 0 has exactly the expected tile-frame increments (substeps is 1, so this release tick completes the turn and clears moving flags), and
the unknown owner remains limited. The runner builds fresh production modules
and the included actual app source into a temporary directory. Original data
is read and hash checked in place. Root must independently review the frozen
candidate and rerun meaningful combined checks before publication.

Unverified branches: other puzzles/cascade combinations, multiple eligible D1
rows in one scene, D1 solved/exit paths, original cursor sprite lifecycle,
hardware UI/audio, and both complete difficulty playthroughs. This regression
does not extend any ledger or oracle claim.

Test observation correction after root integration: S4376 has 7 frames and one animation substep. The release callback starts ANIMATE, then the same tick's real ACT visit advances the clicked tile and its declared links and returns to IDLE with moving flags cleared. The regression now checks all six resulting frames, deriving affected tiles from the immutable body link table and wrapping modulo 7. It still fails on the baseline because no frame advances. This is an observable-result assertion, not a relaxed transient-state check.

## Root integration and targeted checks

Root merged main after PR178 before final validation. Production changes are confined to blackmoor_app.mm: a loaded-scene ownership proof admits exactly one D1 member and no other possible unmodeled member; the original UI guard cells remain required. The real release is consumed once before ACT, and a copied state supplies only projection fields for the post-ACT D1 receiver. Hits return before overlays/navigation/generic rows; misses retain the existing fallback. The startup pointer-provider diagnostic now reports the same scoped readiness. No session_input/navigation kernel or ledger/evidence source changed.

The regression now has four cases, including the real live_audio backend in offline mode: a playing turn clip rejects the second release, and actual completion permits the next frame advance. Other host fixtures remain rendering/inventory/event/transition sinks; no output device or GUI is opened. Test-only signal handlers turn unexpected fixture faults into explicit nonzero exits.

Amended frame-based regression was also compiled against unchanged pre-fix app source37cb43c7: it still fails normally with priority limit3, candidate-1 and frame0=4->4. With the fix, tile0 advances4->5 and linked tiles match the original body; no candidates, latches, phases or moving flags are forced by the fixture.

Targeted command: `python3 -m unittest discover -s outputs/blackmoor-decomp/tests -p test_native_puzzle_pointer.py -v`. Four cases pass. Normal and test-hook ARM64 bundles build. Combined startup/session/phone/movie and real-audio lifecycle checks, native hashes and independent frozen-commit review are recorded in the final validation addendum before publication. Broad suite status remains the explicitly interrupted/failing baseline from NATIVE-01; it will not be restarted while legacy sanitizer children raise crash dialogs.
