# RT-34: raw 0x44 scroll list entry runtime (the Peephole puzzle view, runtime type 0xd8)

Owner thread: Claude Sonnet (cloud). Follows RT-33. Raw 0x44 was next in the `scene-action-coverage.json` ranking after 0x43/0x94/0xd1/0x2e (0x44: 10 scenes, 27 records, 10 where it is the only missing type). Raw 0xd1 (Turning Puzzle) is its own slice.

## The original (GAME.EXE, SHA-256 afd337a2...5c45)

Loader `0x40b34a` arm `0x40c4b5` -> `0x41166e` (A-44.1, `src/action_family_44.[ch]`): the row's pData is a 528-byte header plus the NUL-terminated AUTOTEXT line (all 27 corpus rows: keyed, subtype 1, 544 or 560 raw bytes with one or two dependency records). The debug text in the builder names the row `AT_SCROLL_LIST_ENTRY`, replaced by `PEEPHOLE AR`.

* Dispatcher `0x427a50` arm `0x44`: gate `0x423f57(deps, 0)`, then `0x4121b8(ECX = 0x619a41, row)`.
* `0x4121b8`: `[0x619a41 + 0x102a] := 0`; `0x413187(object, object + 0x210, 0, 0)` (the text writer: renders the line into surface table entry `word@object+4`, fills the link table 0 at `0x59fbdb`/`0x59fbe1` and the link rectangles at `0x619a41 + 0x102e`); `0x42ba3a(row)` (subtype 1 completion, subtype 2 dependency reset, phase 0); `0x411b16(object, row, 0)`.
* `0x411b16` builds a record in a zeroed 0x868-byte buffer: name `"USE_LISTPAGE" + itoa(sword(object+2) - 2)`, second name = string at `object+0xea`, word `object+0` at +0x42, sign-extended words `object+0xc/0xe` at +0x4c/+0x50 (dwords), 16 bytes `object+0x10b` at +0x54, 16 bytes `+0x11b` at +0x64, 64 bytes `+0x12b` at +0x74, `+0x16b` at +0xb4, `+0x1ab` at +0xf4, byte `+0x1eb` at +0x134 (frames per second), link count word at +0x15e and link entries (0x12 bytes each: word value, 16-byte rect) at +0x160 for every writer table value except 0x270f. It frees the old pData, allocates `0x868 - (100 - count) * 0x12` bytes, copies, sets row type byte `0xd8`, subtype `1`, completion byte `0`, phase `0` and frees the buffer. No bound check on the 100 entries (native refuses more).
* Runtime type `0xd8`: dispatcher arm at `0x42a354`: gate `0x423f57(deps, 0)`, then `0x48c1c0(ECX = 0x624686, row)` on a static singleton (the `CPeepholePuzzle` object, 0x56 bytes). Phase 0: active, start flag, limits, button rect flags, two generic Z entries (`0x4d39f9`, type 10, callback `0x48cc70`), surface 1 by name (`USE_AUTOTEXT1..3`, `USE_LISTPAGE<n>` = text writer surface table entries 0..5, anything else a CIFTREE image), surface 2 (empty or same name ignoring case = surface 1, else a CIFTREE image), start position clamp, phase 1. Phase 1: when a button is held (`0x48c148`) the view scrolls by `elapsed / (1000 / fps)` units in the held direction, limited by the four limits. Phase 2 (a click on the exit rectangle or a link, `0x48c0ac`): scene change, `0x42ba3a`, cleanup `0x48bb86`.
* Methods used by the host: `0x48bd91` hit test (pointer cascade `0x4f0f5f`), `0x48c0ac` click (`0x43b2dc`), `0x48c148` press (`0x43b18a`), `0x48bc38` redraw request (`0x43d9a1`), `0x48bb86` cleanup (scene clear `0x438be9`, `0x43dec0`), `0x48cc70` render callback.

## Native implementation (written by the thread)

`src/action_family_d8_runtime.[ch]` (the 0xd8 kernel), `src/action_family_44_runtime.[ch]` (the 0x411b16 record builder), `src/session_bindings_a44.[ch]` (binding: one handler registered for raw 0x44; the first true-gate visit is `0x4121b8`, later visits are `0x48c1c0` on the replaced record), `scripts/build_action_family_44_runtime.sh`. Read the headers for the exact API.

## Oracle tasks

Two original-x86 oracles in the style of `tests/action_family_d9_runtime_original_oracle.py` / `..._oracle_driver.c` (base harness `conditions_nested_original_oracle.OriginalMachine`, private evidence under `work/`).

1. `tests/action_family_d8_runtime_original_oracle.py` + `tests/action_family_d8_runtime_oracle_driver.c`: the real dispatcher `0x427a50` with rows of runtime type 0xd8 and built records, plus direct calls of the original methods.
2. `tests/action_family_44_runtime_original_oracle.py` + `tests/action_family_44_runtime_oracle_driver.c`: the real dispatcher with raw 0x44 rows (the constructed object as pData), the text writer `0x413187` replaced by a scripted hook that writes the writer outputs (documented), comparing the 0x4121b8 / 0x411b16 effects with the native binding.

## Verification (re-run in the cloud from work-private.tar.gz)

* `tests/action_family_d8_runtime_original_oracle.py`: the real dispatcher 0x427a50 with 0xd8 rows plus direct calls of the original methods; 308 scenarios, 7,700 dispatcher calls, 33,601 ordered effects, 347,072 object fields, 70.6 MB of entry-table bytes, 3,000 malformed records, 0 mismatches; 41 of 41 native mutants caught. The oracle found nothing in valid input; a UBSan run of its malformed cases found signed overflow in the four limit subtractions, fixed (they now wrap as the original `sub` does).
* `tests/action_family_44_runtime_original_oracle.py`: the real dispatcher with raw 0x44 rows, the real loader 0x424aa8, gate 0x423f57, 0x4121b8, 0x42ba3a, 0x411b16 and the CRT itoa; 1,212 scenarios, 1,644 visits compared (865,320 record bytes, 3,316 malloc/free calls, 16,405 ordered stores, 388 dependency resets), 0 mismatches; 38 of 38 native mutants caught; 27 corpus headers included.
* C unit tests (`tests/action_family_d8_runtime_test.c`, 11 cases, ASan/UBSan clean with gcc), the executor test (`tests/action_family_44_runtime_executor.c`: both row subtypes end to end, direct first visit with the dependency reset, a failed scene build), and `tests/test_action_family_44_runtime.py` (33 unit mutants and 8 executor mutants).

## Limits and unverified branches

* The macOS glue (`blackmoor_app.mm`) is not compiled or run in the cloud.
* The text writer (`write_text` host of the binding) is NOT wired in the app: RT-32's writer port (`src/autotext_writer.[ch]`) has no link-value table (0x59fbdb/0x59fbe1), which the 0x44 record needs, so in the app the first 0x44 visit reports an UNSUPPORTED blocker and nothing changes. The 0x44 oracle scripts the writer's outputs through a documented hook; the writer itself is not run there. The kernel's render/surface/slot/input host callbacks are not wired either (hit test, click, press, dirty and render plan have no app caller).
* Native safety rejections that differ from the original (it runs on and corrupts memory or faults): more than 100 accepted link entries or a link count above 400 (the original overruns its 0x868-byte buffer), a second name (+0xea) without a NUL inside 33 bytes, an object of exactly 0x210 bytes, a text page index outside the six writer surfaces, a zero frame-rate byte in phase 1 (the original divides by it), an exit event flag index outside the table, a `hot` index out of range in click and press, a row index of -1, a failed scene build (rows stay unowned).
* Hooked in the oracle, not original code: image load and release (0x4c2790, 0x4c2dfb), the blit bodies (0x4c5377, 0x4c5d4b), GetTickCount and IsRectEmpty; the pointer cascade 0x4f0f5f is not run; the gate model covers type-2 condition tails only; engine mode 4 and the scene cells are modelled by the host. The debug flag 0x63a4cd is modelled as 0. `has_links` is read from the dword at 0x619a41+0x102a as nonzero.
* Not modelled: allocation failure in 0x411b16, `d8_cleanup` when only the second surface of a failed init is set (it calls release_surface(0)), the rows of a scene revisited after becoming 0xd8 inside one oracle dispatcher pass.
