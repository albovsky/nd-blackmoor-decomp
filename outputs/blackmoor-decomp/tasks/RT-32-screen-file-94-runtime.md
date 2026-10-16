# RT-32 (part 1): raw 0x94 screen-file runtime

Owner thread: Claude Sonnet (cloud). Follows RT-23 to RT-31. Raw 0x94 was second in `scene-action-coverage.json` after RT-31: 12 scenes, 12 records, all 12 scenes with 0x94 as the only missing type (type-level scenes with every row handled 1,946 to 1,958 of 2,078).

## The original (GAME.EXE, SHA-256 afd337a2...5c45)

* Loader arm `0x40ea5e` (A-94.1): a 50-byte body copied verbatim; body `+0x00` file name (33 bytes), `+0x21/+0x25/+0x29/+0x2d` the rectangle x0, y0, x1, y1 (signed dwords), `+0x31` the format byte. The tail is the usual dependency list.
* Dispatcher arm `0x429747`: gate mode 0 (`0x423f57`), then `0x4c36b2(row)` as a thiscall on the CDirectDraw object `0x5cf659`. The original's own debug string calls it AT_MAKE_SCREEN_FILE ("PrintScreen").
* Handler `0x4c36b2` is a three-phase state machine on the row's phase dword (`0x5bb632`):
  * phase 0: `DAT_005839a9 := 1`, the redraw request `0x4d36ed` (`0x5831c8 := 1`, `0x5831c6 := 0`), phase := 2;
  * phase 2: nothing while `y1 > height` or `x1 > width` (signed compares at `0x4c3777`; the row waits in phase 2 for ever). Otherwise: two allocations (whole screen, crop), the front-buffer lock `0x4c4067`, the row copy `0x43f04b`, the unlock `0x4c4202`, the crop (origin `x0, y0`, size `x1-x0` by `y1-y0`), then a file: format byte 0 calls `0x4c334f` (24-bit bottom-up BMP, rows padded to four bytes, pixels first brought to 5-5-5 by `0x4c7481`), anything else writes an 18-byte TGA header (type 2, top-left origin bit `0x20`, bits per pixel from `DAT_00639893`) followed by the cropped 5-5-5 words. The path is `_makepath(path, DAT_00639a9f, DAT_00639aa2, name, ".BMP" or ".TGA")` (`0x50cd72`), opened `"wb"`; a failed open is silent. The flag `DAT_005839a9` is cleared at the end and the phase becomes 3 even when an allocation failed;
  * phase 3: the generic completion `0x42ba3a` (subtype behaviour, phase := 0). Any other phase value does nothing.
* Corpus (decoded scene resources): 12 scenes, 12 rows, all subtype 1, one identical body: the name `Award`, rectangle (52, 18)-(587, 309), format 0 (a 535 x 291 BMP, three padding bytes per row), no dependency record.

## Native implementation

`src/action_family_94_runtime.[ch]` (pure: body decode, reachability and validity tests, `_makepath`, BMP/TGA encoders, the 5-5-5 conversion) and `src/session_bindings_a94.[ch]` (executor handler: PENDING with the new phase, COMPLETED with phase 0 at phase 3; host callbacks for the capture flag, the redraw request, the display state, the front buffer and the file write, all required). Registration `bindings[25]` in `src/blackmoor_app.mm` (count 26, provider ACTION_KERNEL) with glue that packs the composed 640x480 frame to 5-6-5, writes the file under `~/Library/Application Support/Blackmoor Reconstruction/Screenshots/` and records the two flags; `scripts/build_action_family_94_runtime.sh`; modules added to `scripts/build_native_app.sh`.

## Verification

* `tests/action_family_94_runtime_test.c`: 9 unit cases (ASan/UBSan clean with gcc) and 19 unit mutants caught (`tests/test_action_family_94_runtime.py`); an executor-level test (production `scene_executor`, gated row, three phases, completion) with one executor mutant caught; the corpus driver runs all 12 rows through the binding.
* `tests/action_family_94_runtime_original_oracle.py`: the real dispatcher `0x427a50` (arm `0x429747`, real loader `0x424aa8`, gate `0x423f57`, handler `0x4c36b2`, lock/unlock in the original's memory back-buffer mode, `0x43f04b`, `0x4c334f`, `0x4c7481`, `_makepath`, completion `0x42ba3a`) runs under Unicorn against the native binding; compared per tick: handler entries against the gate model, completion byte and phase of every row, dependency resets, and the ordered effects (flag stores, redraw requests, every file the CRT was asked to open: path, mode, bytes with the BMP padding masked). 27 native mutants caught.

## Limits

* The macOS glue (`blackmoor_app.mm`) is not compiled or run in the cloud. The renderer's readers of `DAT_005839a9`, `0x5831c8` and `0x5831c6` are host behaviour outside this slice.
* The oracle takes the memory back-buffer branch of the lock (`CDirectDraw+8 == +0xc`); the DirectDraw COM lock path and its error branches (`0x4c4067` retry loop, `0x4c4202` failure) are not run. Allocation failure inside the handler is unverified (native treats it like the original: no file, flag cleared, phase 3).
* Outside the native domain, native refuses before any effect (HANDLER_ERROR): a rectangle with `x0 >= x1`, `y0 >= y1` or a negative origin (the original allocates a non-positive size or reads before the buffer), a non-16-bit display, and a BMP stride above 0x7fff. A name without a NUL inside its 33 bytes makes the original read on into the next body fields; native stops at 33 bytes.
* BMP row padding bytes are uninitialised heap in the original; native writes zeros.
