#ifndef BLACKMOOR_CAPTION_LAYOUT_INTERNAL_H
#define BLACKMOOR_CAPTION_LAYOUT_INTERNAL_H

/* Primitives that the caption writer (0x448d11) shares with the AUTOTEXT
 * writer (0x413187): text width 0x4d3836, glyph draw 0x4d270b, colour scan
 * 0x4c9340, surface clear 0x4c46d1 and the font-sheet reference count
 * 0x4c924d / 0x4c92c5.
 *
 * These are thin wrappers over the static functions of caption_layout.c, so
 * both writers run the same verified code. They are not part of the public
 * caption API and may change with it. Every function validates the font index
 * itself and returns a CaptionStatus value. */

#include "caption_layout.h"

#ifdef __cplusplus
extern "C" {
#endif

/* 0x4d3836: advance width of `text` in `font` (16-bit accumulation). */
int caption_internal_text_width(const CaptionFonts *fonts, int16_t font,
                                const char *text, int16_t *width);

/* 0x4d270b: draws `text` with its glyph baseline at `bottom` and its left
 * edge at `left` (both 16-bit in the original), colour variant `color`, from
 * `sheet` into `dst`. `dst` == NULL runs the layout and validation only (no
 * pixel is read or written). `underline` != 0 adds the 0x4d270b underline
 * fill in `underline_color`. Counters are incremented, not reset. */
int caption_internal_draw_text(const CaptionFonts *fonts,
                               const CaptionPixelFormat *format, int16_t font,
                               const CaptionSurface *sheet, CaptionSurface *dst,
                               const char *text, int16_t left, int16_t bottom,
                               int16_t color, int underline,
                               uint16_t underline_color, uint32_t *glyphs_drawn,
                               uint32_t *underline_fills);

/* 0x4c9340: first sheet word in the inclusive rectangle that is not the
 * colour key, else 0. CAPTION_ERR_BOUNDS when a word lies outside `sheet`. */
int caption_internal_scan_color(const CaptionPixelFormat *format,
                                const CaptionSurface *sheet, int32_t left,
                                int32_t top, int32_t right, int32_t bottom,
                                uint16_t *color);

/* 0x4c46d1: fills surface->width * surface->height words (pitch ignored) with
 * the packed colour. */
void caption_internal_clear_surface(const CaptionPixelFormat *format,
                                    CaptionSurface *surface, uint8_t red,
                                    uint8_t green, uint8_t blue);

/* 0x4c924d / 0x4c92c5 on `globals->sheet_refcount` / `globals->sheets`.
 * `simulate` != 0 changes only the counts (no backend call). The backend
 * needs load_font_sheet / release_font_sheet. Acquire returns
 * CAPTION_ERR_BACKEND when the sheet cannot be loaded. */
int caption_internal_acquire_font(const CaptionFonts *fonts,
                                  CaptionGlobals *globals,
                                  const CaptionBackend *backend, int16_t font,
                                  int simulate);
int caption_internal_release_font(const CaptionFonts *fonts,
                                  CaptionGlobals *globals,
                                  const CaptionBackend *backend, int16_t font,
                                  int simulate);

/* Colour-variant offsets read from the FONT record (+0x3f + 8 * color and
 * +0x43 + 8 * color). CAPTION_ERR_UNSUPPORTED when the offsets would lie
 * outside the record. */
int caption_internal_color_offsets(const CaptionFonts *fonts, int16_t font,
                                   int16_t color, int32_t *dx, int32_t *dy);

/* 0x50cb1b: MSVC atoi in the C locale (wraps modulo 2^32). */
int32_t caption_internal_atoi(const char *text);

#ifdef __cplusplus
}
#endif

#endif
