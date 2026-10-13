# S05 writer and lifecycle review repairs (Luna 6)

**Owner:** `/root/sound_control_luna6`; **baseline:** `bf1c094ff8286f4de47ad1622cf3a58df3278a02`; **branch:** `codex/blackmoor-s05-review-repairs`.

This child repairs the three writer review findings and two lifecycle safety findings recorded in `S05-review-repairs.md` in the canonical project task. It owns only `src/caption_layout.[ch]`, `src/caption_lifecycle.[ch]`, their two tests, original-oracle/build files if required, this child packet, and uniquely named private evidence. It does not close S05, claim pixel composition, or modify integration/runtime files.

## Callback contract

Existing callback signatures remain unchanged. During `caption_layout_write`, backend context may refer to the caller's target `CaptionSurface`, `CaptionTextBox`, and `CaptionGlobals`; those objects remain valid until the function returns. At each callback, target pixels, box, and globals expose writer effects that precede that callback in source order. Mutations a callback makes to these objects remain visible after it returns when the context permits writes, including pixel writes. The writer retains no references after return. A failure after a callback preserves the already observable committed prefix; this API does not promise rollback before callbacks.

## Repair and acceptance checklist

- [x] Add regressions that expose stale restore pixels/flags and absent release ownership before changing the implementation.
- [x] Synchronize source-order writer effects around callbacks; preserve callback mutations and exact cleanup/refcount behavior on success/failure/pre-held sheets.
- [x] Replace signed-overflow-prone writer geometry arithmetic with defined source-compatible wrap operations or checked wide calculations and bounded rejection.
- [x] Validate slider visual selector values 0..3 before indexing; value 4 remains the hidden state. Cover malformed configuration and corrupted live state.
- [x] Define lifecycle geometry arithmetic and fix scene-reset, slider init/drag, and popup-hover overflow paths without changing valid input behavior.
- [x] Run native suites, sanitizer extremes, writer's full original 3,828-case oracle and lifecycle's 19-sequence/333-step oracle; save uniquely named reports.
- [ ] Record hashes, hooks, exact tests, independent review, and unresolved behavior in the private claim/handoff. (Evidence is recorded; independent review is pending.)

## Validation and remaining scope

- Native writer: 26 tests passed, including the ASan/UBSan extreme-input driver. Native lifecycle: 16 tests passed, including ASan/UBSan selector and geometry extremes.
- Original writer: 3,828 cases, zero mismatches. Outcomes: 3,813 `ok`, 1 intentional undefined case, 3 nonterminating, 6 outside-surface, 1 trapped, 2 fatal-too-long, and 2 fatal-missing-sheet. Report: `work/analysis/slices/S05-review-repairs-writer-20261013.json`.
- Original lifecycle: 19 sequences / 333 steps, zero mismatches. Report: `work/analysis/slices/S05-review-repairs-lifecycle-20261013.json`.
- Original executable SHA-256: `afd337a2468e0cd540f487db2c121ccb9ccb9757836578c15d2d8a52f3485c45`. Oracle reports pin each final native-library hash; the private handoff pins source/oracle hashes.
- Oracle interception is limited to documented external boundaries: writer font-sheet load/free, taskbar close/update/restore, error/quit/log; lifecycle sheet load/free, blits, writer, sound load/play/unload, input/time imports, conversation restore, report/quit, and non-caption UI calls. The original layout, glyph, clear, refcount, popup, slider, scene, and main-loop code runs unmodified.
- Remaining explicit branches: `CUIButton` object behavior is unsupported for `CTB_HAS_BUTTON`; slider shared-art configuration returns unsupported; there is no claim for full caption pixel composition or overall S05/game completion. No GUI or audio-device checks were run.
- Independent narrow review is pending; freeze this snapshot until the reviewer reports.

The original executable and installed assets remain immutable. Oracle differences caused by original unsafe memory behavior must be reported separately from successful parity.
