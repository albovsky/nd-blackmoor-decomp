# S0 hotspot runtime validation

This report covers the two S0 runtime-`0x6a` event-flag hotspots and the S0
raw-`0x15` row whose body byte zero maps it to runtime `0x0d`. It does not claim
whole-game equivalence.

The existing `SceneActionRuntimeState` and `SceneActionHandlerResult` layouts
remain unchanged. The frame-aware entry point and hotspot query use separate
structures. `scene_executor_step` remains the compatibility entry point and
supplies frame zero without pointer or activation input.

## Recovered event and tick sequence

The original message-map rows at file offset `0x12c810` use 24-byte records.
The `WM_LBUTTONUP` row (`0x0202`) points to `0x43ec4a`, whose callback path
reaches `0x4db000` and consumes the original input latch at `+0`. The adjacent
`WM_LBUTTONDOWN` row (`0x0201`) points to a different callback (`0x43ec85`).
The oracle checks the raw bytes of both rows, plus the neighboring button and
double-click message rows, against the pinned executable. The executor's
`hotspot_activation_event` therefore means an accepted primary-button release;
hover and button-down alone do not activate a candidate.

The input path consumes that event and the candidate already cached by the
previous cursor scan before dispatching ACT rows. The post-dispatch `0x4d3073`
scan clears and refreshes the candidate from active, frame-matched rectangles.
The implemented order is therefore:

1. Tick N dispatches the hotspot action and scans the cursor after dispatch,
   caching the matching action row.
2. On a later tick with an accepted `WM_LBUTTONUP`, the caller consumes that
   cached candidate before ACT dispatch. The executor rechecks completion and
   dependencies; a ready hotspot enters phase 2 before its row is dispatched.
3. Phase-2 effects run in that same dispatch tick. A frame match or hover by
   itself never synthesizes activation.

The host supplies the cursor hot point in scene coordinates after viewport
origin subtraction, scene-scroll addition to Y, and cursor-sprite hot-point
offset addition. The recovered rectangle comparisons are inclusive. Clipping,
scroll, and cursor-sprite transforms remain the host boundary.

## Runtime behavior

For `0x6a`, phase zero advances to phase one and scans the records for the
current frame. A match publishes the rectangle for cursor hit-testing. In
phase two, the action applies its ten `(flag, value)` pairs, skipping flag
`-1`, then runs the original subtype completion behavior; subtype two returns
the action to phase zero and resets its dependencies.

For the S0 raw-`0x15` body, the parser retains type `0x15`. Runtime dispatch
maps it to `0x0d` only when the raw body is exactly 20 bytes and byte zero is
`0x0d`. The normalized payload uses the target at raw `+2`, frame zero, loader
defaults for the other payload fields, and the four rectangle dwords at raw
`+4..+19`. As in the original handler, live hit bounds are the signed low
16-bit values exported from those dwords. Phase zero exports the rectangle,
advances to phase one, and checks frame zero in that same dispatch; phase one
checks it again on later passes. The original dispatcher oracle compares
phase-zero frame-match and frame-miss cases, plus phase-one frame-match and
frame-miss cases. A later accepted candidate enters phase two, which completes
the action and reports the delayed scene-transition request.

For blocked runtime-`0x9f` rows, subtype two resets `completed`, `phase`, and
dependencies on each blocked pass; subtype one leaves them unchanged. External
handlers can also stage a transition request during their callback. It commits
only after a successful callback with a valid disposition, then stops later
ACT rows in that pass. Existing handler-result ABI is preserved.

## Validation evidence

The original comparison uses `GAME.EXE` SHA-256
`afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45` and S0
resource SHA-256
`ecf2410dafe20b9d0b8609d88faef89c144518c01719bb3c1cd42fa7931bd2b8`. The
isolated Unicorn 2.1.4 fixture executes the original dispatcher and hotspot
handlers; it hooks only the dependency-ready boundary. It compared 13 original
and native snapshots across both `0x6a` rows and the raw-`0x15`/runtime-`0x0d`
row, with zero mismatches. The raw input-message-map table bytes are separately
validated against the same executable.

Native validation passed: 22 `test_scene_executor.py` tests, including ABI,
candidate/event sequencing, modal and stale-candidate guards, dependency
rechecks, inclusive bounds, raw-body normalization, delayed transition, and
the `0x9f` blocked-pass reset. The raw `0x0d` phase-zero frame-zero activation
and phase-one frame-miss behavior also have a direct native regression.

The original input-event/cursor loop itself is not executed under Unicorn; its
platform-heavy boundaries are reported rather than stubbed into a claimed
end-to-end input comparison. The Unicorn fixture seeds the dependency-ready
gate true for the tested handler passes. No rendering, audio, world loading,
or full-game behavior is covered here.
