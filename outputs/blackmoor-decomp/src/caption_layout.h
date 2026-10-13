#ifndef BLACKMOOR_CAPTION_LAYOUT_H
#define BLACKMOOR_CAPTION_LAYOUT_H

/* Original closed-caption / framed text-box writer.
 *
 * Writer:      0x448d11 (thiscall on the text-box object 0x619a05).
 * Line layout: 0x44887c.  Width: 0x4d3836.  Glyph map: 0x4d214b.
 * Glyph draw:  0x4d270b.  Blit: 0x4c5b3a.  Clear: 0x4c46d1.
 * Pixel scan:  0x4c9340.  Font sheet refcount: 0x4c924d / 0x4c92c5.
 * Pixel format and colour key: 0x4c2f09..0x4c3149.
 * Fonts: BOOT FONT chunk copied to 0x5a4c24 (0x436ba7); derived glyph sizes
 * at 0x5adb3a (0x436bba..0x436cba). Geometry: BOOT TBOX copied to 0x5b0a12
 * (0x43603d); surface sizes from 0x437300..0x437359.
 *
 * Every pixel operation of the original is a CPU loop over 16-bit surface
 * words, so pixels produced here are original-derived, not host text layout.
 */

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define CAPTION_FONT_RECORD_BYTES 0x7f3u
#define CAPTION_FONT_GLYPHS 115u
#define CAPTION_MAX_FONTS 18u
#define CAPTION_FONT_NAME_BYTES 33u
#define CAPTION_TBOX_BYTES 98u
/* Writer and line buffers are 0x4e2 dwords. */
#define CAPTION_TEXT_BUFFER_BYTES 5000u
/* Tag argument buffer: six dwords and one byte. */
#define CAPTION_TAG_BUFFER_BYTES 25u
/* Tab text buffer [ebp-0x14..-0x6]: 15 bytes. */
#define CAPTION_TAB_BUFFER_BYTES 15u

/* Writer mode (third argument of 0x448d11). Values >= 0 select a font and
 * the caption geometry. */
#define CAPTION_MODE_CAPTION INT16_C(-1)
#define CAPTION_MODE_FRAMED INT16_C(-2)
#define CAPTION_DEFAULT_FONT INT16_C(9)

typedef enum caption_status {
    CAPTION_OK = 0,
    CAPTION_ERR_ARGUMENT = 1,
    /* Malformed FONT/TBOX/BSUM input or a glyph outside its record. */
    CAPTION_ERR_FORMAT = 2,
    /* Text, tag or line buffer would overflow the original stack buffer. */
    CAPTION_ERR_LIMIT = 3,
    /* A blit, fill or scan would leave a surface. */
    CAPTION_ERR_BOUNDS = 4,
    /* A font index outside the loaded FONT table. */
    CAPTION_ERR_FONT = 5,
    /* Original behaviour is undefined or does not terminate (see header). */
    CAPTION_ERR_UNSUPPORTED = 6,
    CAPTION_ERR_BACKEND = 7,
    /* Framed text reached the original fatal "text is too long" path. */
    CAPTION_ERR_TOO_LONG = 8
} CaptionStatus;

/* Graphics-object fields +0x38c0..+0x38ca and +0x38d0, derived as 0x4c2f09
 * does from DirectDraw channel masks. Index 0 is blue, 1 green, 2 red. */
typedef struct caption_pixel_format {
    uint8_t shifts[3];
    uint8_t masks[3];
    uint8_t channel_bits[3];
    /* BOOT transparent RGB (BSUM bytes 324..326), widened for 6-bit
     * channels and packed (0x4c30c3..0x4c3149). */
    uint16_t color_key;
} CaptionPixelFormat;

int caption_pixel_format_from_masks(uint32_t red_mask,
                                    uint32_t green_mask,
                                    uint32_t blue_mask,
                                    const uint8_t transparent_rgb[3],
                                    CaptionPixelFormat *format);

/* Surface object fields used by the renderer: +0 pixels, +0x2b width,
 * +0x2d height, +0x2f pitch in bytes. Pixels are 16-bit words. */
typedef struct caption_surface {
    uint8_t *pixels;
    int16_t width;
    int16_t height;
    int16_t pitch;
} CaptionSurface;

/* BOOT FONT records and the derived per-glyph size table. */
typedef struct caption_fonts {
    int16_t count;
    uint8_t records[CAPTION_MAX_FONTS][CAPTION_FONT_RECORD_BYTES];
    /* [font][glyph] = { right-left+1, bottom-top+1 } (0x5adb3a/0x5adb3c). */
    int16_t glyph_size[CAPTION_MAX_FONTS][CAPTION_FONT_GLYPHS][2];
} CaptionFonts;

/* `font_chunk` is the FONT chunk payload; `font_count` is BSUM byte 337. */
int caption_fonts_init(const uint8_t *font_chunk,
                       size_t font_chunk_length,
                       int16_t font_count,
                       CaptionFonts *fonts);
/* Sheet image name (record +0), NUL-terminated within 33 bytes. */
const char *caption_font_sheet_name(const CaptionFonts *fonts, int16_t font);

/* BOOT TBOX record as copied to 0x5b0a12, plus the surface sizes the boot
 * code derives from it. */
typedef struct caption_geometry {
    uint8_t tbox[CAPTION_TBOX_BYTES];
    int16_t framed_surface_width;   /* 0x5b0a74 */
    int16_t framed_surface_height;  /* 0x5b0a76 */
    int16_t caption_surface_width;  /* 0x5b15ee */
    int16_t caption_surface_height; /* 0x5b15f0 */
} CaptionGeometry;

int caption_geometry_init(const uint8_t *tbox, size_t tbox_length,
                          CaptionGeometry *geometry);

/* Text-box object 0x619a05 fields touched by the writer. */
typedef struct caption_text_box {
    int32_t too_long_reported;  /* +0x10 (debug-mode line overflow) */
    int16_t left_margin;        /* +0x2c */
    int32_t underline;          /* +0x2e */
    uint16_t underline_color;   /* +0x32 */
    int32_t tight_spacing;      /* +0x34, toggled by <l> */
    int32_t half_spacing;       /* +0x38, set by <w> */
} CaptionTextBox;

/* Process globals read or written by the writer. Shared with A-51
 * (ActionFamily51World) and the S05-2 UI lifecycle. */
typedef struct caption_globals {
    int32_t caption_finish_flag;   /* 0x5b1602: cleared by caption draw */
    int32_t caption_visible_flag;  /* 0x5b1606: set by caption draw */
    int32_t framed_ready;          /* 0x5b15d6: set by framed draw */
    int16_t framed_scroll_lines;   /* 0x5b0a7c */
    uint8_t frame_open;            /* 0x5a161f: open frame box is closed first */
    int16_t sheet_refcount[CAPTION_MAX_FONTS]; /* 0x5afbda */
    CaptionSurface sheets[CAPTION_MAX_FONTS];  /* 0x5d032f (NULL pixels = none) */
} CaptionGlobals;

typedef enum caption_backend_status {
    CAPTION_BACKEND_OK = 0,
    CAPTION_BACKEND_ERROR = 1
} CaptionBackendStatus;

/* Unreplaced platform boundaries. */
typedef struct caption_backend {
    void *context;
    /* 0x4c2790("CIFTREE", name, 6, "DF FONT Surface"): decoded sheet in the
     * display pixel format (cif_pixels_convert_555). */
    CaptionBackendStatus (*load_font_sheet)(void *context, int16_t font,
                                            const char *name,
                                            CaptionSurface *sheet);
    /* 0x4c2dfb on the sheet handle. */
    void (*release_font_sheet)(void *context, int16_t font,
                               CaptionSurface *sheet);
    /* 0x4de2d8 on 0x61f864 (S05-2 frame box close), when frame_open. */
    CaptionBackendStatus (*close_frame_text)(void *context);
    /* 0x4e1157 on 0x570508: CUITaskBar::RestoreCCTextBox, after a caption
     * draw. */
    CaptionBackendStatus (*restore_caption_box)(void *context);
    /* 0x44a2b7, debug mode only (optional): CAPTION_DEBUG_TOO_MUCH_TEXT. */
    void (*debug_log)(void *context, const char *message);
} CaptionBackend;

/* sprintf format at 0x5487b8 (no arguments). */
#define CAPTION_DEBUG_TOO_MUCH_TEXT "CC Text::ProcessTextLine() - Too much Text"

typedef struct caption_request {
    /* Mutable C string. As in the original, "<e>\0" is written over the
     * terminator when the text contains no "<e>"; `text_capacity` must
     * leave room for it. */
    uint8_t *text;
    size_t text_capacity;
    int16_t mode;
    /* Nonzero: count lines only (0x448d11 fourth argument). */
    uint8_t measure;
    /* Original debug global 0x63a4cd. */
    uint8_t debug_mode;
} CaptionRequest;

typedef struct caption_result {
    /* Writer return value (line count). */
    int16_t lines;
    uint8_t terminator_appended;
    uint8_t surface_cleared;
    uint32_t glyphs_drawn;
    uint32_t underline_fills;
    /* Final pen position. */
    int16_t pen_x;
    int16_t pen_y;
} CaptionResult;

/* Runs 0x448d11 in two passes.
 *
 * Pass 1 lays the text out without side effects and rejects malformed input,
 * font indices outside the FONT table, buffer overruns, non-terminating
 * wraps and the framed "too long" path before any backend call or state
 * change. A font sheet that fails to load is a pass-2 failure.
 *
 * Pass 2 runs in original order: frame close, sheet loads/releases and the
 * taskbar restore are real backend calls; pixels go to a private copy of
 * `target`. Pixel bounds depend on sheet contents (only non-key words are
 * written), so CAPTION_ERR_BOUNDS can arise here, as can backend failures.
 * On any pass-2 failure the target pixels, text, text box and `globals` are
 * left unchanged, except that sheets loaded by this call are released and
 * an already performed frame close is reflected (frame_open = 0,
 * framed_ready = 0). Such failures are fatal in the original (quit or a
 * fault); callers must not retry blindly.
 *
 * Measure mode is not side-effect free, as in the original: it closes an
 * open frame box and loads/releases font sheets. `target` may be NULL only
 * in measure mode.
 *
 * `globals` is copied in and written back whole: backends must not modify
 * it during the call. `globals->sheets[]` point at backend-owned memory;
 * the writer passes them back to release_font_sheet when their count
 * reaches zero. Invariant: a non-NULL sheet has sheet_refcount > 0 (the
 * writer never produces anything else); callers must not pass a held
 * sheet with a zero count. The debug_log callback may already have run
 * when a later pass-2 failure discards too_long_reported. */
int caption_layout_write(const CaptionFonts *fonts,
                         const CaptionGeometry *geometry,
                         const CaptionPixelFormat *format,
                         CaptionTextBox *box,
                         CaptionGlobals *globals,
                         const CaptionBackend *backend,
                         CaptionSurface *target,
                         const CaptionRequest *request,
                         CaptionResult *result);

const char *caption_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
