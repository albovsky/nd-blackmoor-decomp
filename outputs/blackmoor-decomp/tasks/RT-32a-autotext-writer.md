# RT-32a AUTOTEXT text writer (0x413187) and line flusher (0x412db8)

Status: implemented and compared with the original under Unicorn; awaiting independent review. This slice
does not claim the parent action-family slice or the game complete.

## Original functions

| Address | Role |
| --- | --- |
| 0x413187 | AUTOTEXT writer, thiscall on the owner 0x619a41, `ret 0x10` (entry, text, rects, count) |
| 0x412db8 | line flusher (wrap, draw, pen advance), `ret 0x28` |
| 0x4d3836, 0x4d214b, 0x4d270b, 0x4c9340, 0x4c46d1, 0x4c924d, 0x4c92c5, 0x50cb1b | shared caption primitives, reused from `src/caption_layout.c` |
| 0x4c5b3a, 0x4c2a8d, 0x4c2dfb | keyed blit, surface create, surface free (ported inline / behind the backend) |

## Native files

- `src/autotext_writer.[ch]`: `autotext_write()`, `autotext_write_status_string()`; symbols are prefixed
  `AUTOTEXT_WRITE_*` / `AutotextWriteStatus` so the header can be included together with `autotext.h`.
- `src/caption_layout_internal.h` and an additive block at the end of `src/caption_layout.c`: wrappers that expose the
  already verified static caption primitives; caption behaviour is unchanged.
- `scripts/build_autotext_writer.sh` (`SANITIZE=1` for ASan/UBSan), `tests/test_autotext_writer.py`,
  `tests/autotext_writer_original_oracle.py`.

## API

```c
int autotext_write(const CaptionFonts *fonts, const CaptionPixelFormat *format,
                   AutotextOwner *owner, AutotextGlobals *globals, CaptionGlobals *font_state,
                   const AutotextBackend *backend, uint8_t *entry /* 301 bytes */,
                   const char *text, size_t text_capacity,
                   AutotextRect *rects, size_t rect_capacity, int16_t *rect_count,
                   AutotextResult *result);
```

Returns `AUTOTEXT_WRITE_OK` or a native safety status (`ARGUMENT`, `FORMAT`, `LIMIT`, `BOUNDS`, `FONT`,
`UNSUPPORTED`, `BACKEND`, `SURFACE_INDEX`). These statuses are not original return values. The backend supplies the
host boundaries only: surface create/free, the overlay and font-sheet loads, the debug log and an optional trace.
Pass 1 validates on copies of the owner, globals and entry and changes nothing when it rejects; pass 2 repeats the work
in the original order and reports a late failure (pixel bounds, backend) after releasing this call's font references and
overlay.

## Verification (run from the repository root)

```
sh outputs/blackmoor-decomp/scripts/build_autotext_writer.sh
python3 -m unittest outputs/blackmoor-decomp/tests/test_autotext_writer.py        # 20 tests
python3 outputs/blackmoor-decomp/tests/autotext_writer_original_oracle.py          # original-x86 oracle
python3 outputs/blackmoor-decomp/tests/autotext_writer_original_oracle.py --mutants
```

The oracle runs the real 0x413187 and everything below it (see the file header for the intercepted boundaries and the
observed addresses). The counts and hashes are in `work/analysis/slices/RT-32a.handoff.json` and `.validation.json`.
The font, entry-mark and overlay sheets are deterministic synthetic pixels given identically to both sides, because the
CIFTREE images are not in the private evidence set; BOOT FONT and MARK records and the AUTOTEXT strings are real.

## Native rejections of unsafe original behaviour

Division by zero when the entry width is 0; an uninitialised tag byte on `>` without a tag letter; an uninitialised
hotspot index for `<L>` before any `<H>`; a tag argument of 24 or more characters (25-byte buffer); text longer than
39998 bytes; a flusher source index above 32767; a line buffer over 5000 bytes; a hotspot index outside 0..399; more
mark rectangles than the caller's capacity; a missing overlay or entry-mark sheet at a blit; a picture table past the
301-byte prefix (count above 13 with the picture flag set); colour offsets outside the font record; a flush that never
ends (iteration cap 100000); surface width above 16383 or over 64 MiB; non-positive extents when a surface must be
created; a surface index outside 0..5; mark and picture blits that leave their surface.

## Unverified branches

See `work/analysis/slices/RT-32a.handoff.json` (`unverified_branches`).
