# RT-32 (part 2): raw 0x43 AUTOTEXT text overlay runtime

Owner thread: Claude Sonnet (cloud). Raw 0x43 was the other small family left in `scene-action-coverage.json`: 13 scenes, 13 records. The text writer it needs is RT-32a (`tasks/RT-32a-autotext-writer.md`, `src/autotext_writer.[ch]`, own Unicorn oracle).

## The original (GAME.EXE, SHA-256 afd337a2...5c45)

* Loader arm `0x40c487` builds the row object with `0x41137f` (A-43.1, already ported as `action_family_43`): the 301-byte prefix, then the resolved AUTOTEXT string (keyed rows, selector byte `+0x109`, key `+0x10a`) or the inline text.
* Dispatcher arm `0x428465`: gate mode 0 (`0x423f57`), then `0x411f24(row)` as a thiscall on the text owner `0x619a41`. The arm runs again on every pass until the row stops being type 0x43.
* Handler `0x411f24`, one visit, no phases:
  1. `0x413187(object, object+0x12d, 0, 0)`: render the text into AUTOTEXT surface slot `word(+2)` (RT-32a);
  2. `0x42ba3a(row)`: the generic completion with the raw subtype;
  3. allocate and zero a 0xABA overlay image, run the overlay defaults `0x48945b` over the rectangle at `object+0xe9`, store the name `USE_AUTOTEXT` + decimal(`(short)word(+2) + 1`), the option words `word(+0)` at `+0x23` and `word(+0xe7)` at `+0x27`, and four geometry dwords from `object+0xf9..+0x105` at `+0xac..+0xb8`;
  4. free the old object, install the image as the row body, and store completion 0, type 0x36, subtype 1, phase 0 (the `0x42ba3a` completion byte is therefore overwritten; only its subtype-2 dependency reset `0x423d33` survives).
* From the next pass the row is an ordinary runtime-0x36 overlay (gate mode 1, `COverlay::Process`), the same machinery raw 0x37 and 0x38 rows use, reading the AUTOTEXT surface through `0x5d0397[k]`.
* Corpus (decoded scene resources): 13 scenes, 13 rows, all keyed, all subtype 1, surface index 0, no dependency record.

## Native implementation

* `src/session_bindings_a43.[ch]`: the executor handler. First visit: AUTOTEXT lookup (host), `action_family_43` construction, the text writer, the overlay image (built through the raw 0x37 constructor from the same 69 bytes), `session_a36_adopt_row`, result `PENDING_BECOME_OVERLAY36` phase 0 (`RESET_BECOME_OVERLAY36` for subtype 2, which also resets the dependencies). Later visits: the 0x36 binding, with its COMPLETED mapped to DIRECT_COMPLETED when the raw subtype is not 1 (the original stores subtype 1).
* `scene_executor`: two new handler dispositions (`SCENE_ACTION_HANDLER_PENDING_BECOME_OVERLAY36`, `SCENE_ACTION_HANDLER_RESET_BECOME_OVERLAY36`) and an executor-private per-row flag (`scene_executor_get_action_overlay36`); no public struct changed. The gate then uses mode 1 for that row from the next visit on (tested with an extension leaf that records the mode).
* `session_bindings_a36`: `session_a36_adopt_row` and a served-type check that accepts adopted 0x43 rows.
* `src/blackmoor_app.mm` glue (`bindings[26]`, 28 bindings with the RT-33 0x2e binding): AUTOTEXT lookup from the captions' decoded resource, caption fonts/format/font-sheet counts shared with `0x448d11`, host buffers for the AUTOTEXT slots (handles `0xf0000010 + slot`), overlay picture as a CIFTREE image.

## Verification

* `tests/action_family_43_runtime_original_oracle.py`: the real dispatcher `0x427a50` (arm `0x428465`, real loader `0x424aa8`, gate `0x423f57`, handler `0x411f24` with the real `0x42ba3a`, `0x48945b`, `_itoa 0x5193ca`, allocator) against the native binding; only the text writer is replaced on both sides by a recorder (native through the `write_text` seam). 88 scenarios, 335 dispatcher passes, 147 rows visited, 0 mismatches: the whole 0xABA image (403,662 bytes), the entry and text handed to the writer (61,122 text bytes), the generic completion and dependency reset calls, both frees, the row's type/subtype/completion/phase, gate/arm entry against the open-row model. Scenarios: the 13 corpus rows, keyed and inline text (empty, 5,000, 40,000, high bytes), surface indexes 0..9, 0x7fff, -1, -2, -32768, random option/rectangle/geometry words, allocator fill 0xCD/0xAA, subtypes 0/1/2/3/255 with dependencies, event gating, scene mode 4, preset phases, offset first rows, 40 random scenes. 13 native mutants are caught by the quick set.
* `tests/test_action_family_43_runtime.py`: the production executor drives synthetic rows (`tests/session_bindings_a43_test.c`: render, conversion, overlay visits, completion with subtype 1 for raw subtype 2 and 0, refused writer, missing key) clean under ASan/UBSan with gcc; 5 executor mutants caught; the corpus driver runs the 13 real rows (13 converted); the quick oracle set.
* The writer: RT-32a, 254 cases against the original `0x413187`, 0 mismatches, 13 mutants caught.

## Limits

* The macOS glue is not compiled or run in the cloud (AppKit is absent); only its new functions were syntax-checked against stub types.
* The oracle replaces the text writer on both sides, so the rendered pixels are verified by RT-32a (synthetic font sheets), not by this oracle. Real CIFTREE font and overlay sheets are not exercised.
* A key missing from AUTOTEXT is refused (UNSUPPORTED); the original's behaviour there is not recovered. Allocation failures in `0x411f24` (`0x411f4d`, `0x411fd8`) are not modelled. Entry marks (sheet `0x5d0377`) are not provided by the host, so a text using them is refused by the writer before any effect.
* Surface indexes 3..5 produce names `USE_AUTOTEXT4..6`, which the overlay runtime does not map to a slot (it knows three); they would try a CIFTREE load by name, as the original's name test also only matches 1..3. No corpus row uses them.
* The later overlay visits of a converted row are the raw 0x36 binding's (its own oracle); the 0x43-specific part (conversion, subtype 1 completion) is covered by the executor test, the subtype-1 completion not by the oracle.
