#ifndef BLACKMOOR_AUTOTEXT_WRITER_H
#define BLACKMOOR_AUTOTEXT_WRITER_H

/* Original AUTOTEXT text writer for the 0x43 action family.
 *
 * Writer:       FUN_00413187 (thiscall on the text-owner object 0x619a41,
 *               ret 0x10: entry, text, rect array, rect count).
 * Line flusher: FUN_00412db8 (thiscall, ret 0x28): word wrap and glyph draw.
 * Shared with the caption writer 0x448d11 (caption_layout.c): text width
 * 0x4d3836, glyph map 0x4d214b, glyph draw 0x4d270b, colour scan 0x4c9340,
 * surface clear 0x4c46d1, font-sheet refcount 0x4c924d / 0x4c92c5.
 * Surface blit 0x4c5b3a (colour-keyed copy), surface create 0x4c2a8d,
 * surface free 0x4c2dfb and picture load 0x4c2790 are host boundaries.
 *
 * The writer renders one 0x43 entry's resolved text into the global AUTOTEXT
 * surface slot table 0x5d0397[0..5] (surface "AUTO TEXT SURFACE", created or
 * re-created when too small), optionally blits an overlay picture
 * ("AutoText Overlays Surface") and entry marks, and stores the final pen Y
 * at owner+0x12+4*index.
 *
 * Native results are not original return values: the original returns void.
 * Unsafe original behaviour (stack overruns, division by zero, uninitialised
 * locals, null surfaces, endless loops) is rejected before any state changes
 * where it can be detected from the layout alone (pass 1) and as a pass-2
 * failure otherwise (see autotext_write).
 */

#include <stddef.h>
#include <stdint.h>

#include "caption_layout.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Body prefix of a 0x43 action (ACTION_FAMILY_43_PREFIX_BYTES). Layout used
 * by the writer (all little-endian):
 *   +0x00 word  mode: 2 clears the surface to (0,31,0), else to black
 *   +0x02 word  surface index 0..5
 *   +0x04 word  font
 *   +0x06 word  colour variant
 *   +0x08 word  left margin
 *   +0x0a word  top margin
 *   +0x0c word  surface width / right limit
 *   +0x0e word  surface height - 20
 *   +0x10 char[33] overlay picture name
 *   +0x31 word  picture count (clamped to 10 when the overlay is loaded)
 *   +0x33 picture table: count * { word line; int32 left, top, right, bottom }
 */
#define AUTOTEXT_ENTRY_BYTES 301u
#define AUTOTEXT_ENTRY_NAME_OFFSET 0x10u
#define AUTOTEXT_ENTRY_NAME_BYTES 33u
#define AUTOTEXT_PICTURE_COUNT_OFFSET 0x31u
#define AUTOTEXT_PICTURE_TABLE_OFFSET 0x33u
#define AUTOTEXT_PICTURE_RECORD_BYTES 0x12u
/* Pictures the 301-byte prefix can hold. */
#define AUTOTEXT_PICTURE_LIMIT 13u
/* Overlay load clamps the count to this value (0x41353b). */
#define AUTOTEXT_PICTURE_CLAMP 10

#define AUTOTEXT_SURFACE_SLOTS 6u
/* Entry-mark records 0x5afc7e..0x5afccd (BOOT MARK chunk, 80 bytes). */
#define AUTOTEXT_MARK_RECORDS 5u
/* Hotspot records owner+0x102e..+0x292e (tags H and L). */
#define AUTOTEXT_HOTSPOT_RECORDS 400u
/* The pending-text buffer (40000 bytes) and tag buffer (25 bytes). */
#define AUTOTEXT_TEXT_BUFFER_BYTES 40000u
#define AUTOTEXT_LINE_BUFFER_BYTES 5000u
#define AUTOTEXT_TAG_BUFFER_BYTES 25u
/* Native resource limit (not in the original): bytes of a created surface. */
#define AUTOTEXT_MAX_SURFACE_BYTES 0x4000000u

typedef enum autotext_write_status {
    AUTOTEXT_WRITE_OK = 0,
    AUTOTEXT_WRITE_ERR_ARGUMENT = 1,
    /* Malformed entry, FONT data or glyph outside its record. */
    AUTOTEXT_WRITE_ERR_FORMAT = 2,
    /* A buffer or table of the original would overflow. */
    AUTOTEXT_WRITE_ERR_LIMIT = 3,
    /* A blit, fill or scan would leave a surface. */
    AUTOTEXT_WRITE_ERR_BOUNDS = 4,
    /* A font index outside the loaded FONT table. */
    AUTOTEXT_WRITE_ERR_FONT = 5,
    /* Original behaviour is undefined or does not terminate. */
    AUTOTEXT_WRITE_ERR_UNSUPPORTED = 6,
    /* A host callback failed (the original reports and quits). */
    AUTOTEXT_WRITE_ERR_BACKEND = 7,
    /* Surface index outside 0..5: the original reports
     * "ERROR- invalid AUTOTEXT surface specified" (0x52139c) and quits
     * (0x4c97b4), then keeps going with a stale surface. */
    AUTOTEXT_WRITE_ERR_SURFACE_INDEX = 8
} AutotextWriteStatus;

/* One entry-mark rectangle written to the caller's rect array:
 * { left, top, right, bottom }, 16 bytes in the original. */
typedef struct autotext_rect {
    int32_t left;
    int32_t top;
    int32_t right;
    int32_t bottom;
} AutotextRect;

/* Hotspot record owner+0x102e+16*k (tags H and L). */
typedef struct autotext_hotspot {
    int32_t x_start;  /* +0x102e: pen X at <H> */
    int32_t y_start;  /* +0x1032: 0 on line 0, else pen Y at <H> */
    int32_t x_end;    /* +0x1036: widest X seen by <n>/<w> after <H> */
    int32_t y_end;    /* +0x103a: pen Y at <L> */
} AutotextHotspot;

/* Text-owner object 0x619a41: the fields this writer touches. */
typedef struct autotext_owner {
    int16_t surface_index;   /* +0x04 */
    CaptionSurface overlay;  /* +0x06 (pixels NULL = 0): picture surface */
    CaptionSurface target;   /* +0x0a: the slot surface being drawn into */
    int32_t final_y[AUTOTEXT_SURFACE_SLOTS]; /* +0x12 + 4*index */
    AutotextHotspot hotspots[AUTOTEXT_HOTSPOT_RECORDS]; /* +0x102e */
    int16_t left_margin;     /* +0x292e: entry left margin + one glyph 'o' */
    int32_t pictures_seen;   /* +0x2930: set once an overlay was loaded;
                              * never cleared by the writer */
    int32_t underline;       /* +0x2938 */
    uint16_t underline_color; /* +0x293c */
    int32_t tight_spacing;   /* +0x293e */
    int32_t half_spacing;    /* +0x2942 */
} AutotextOwner;

/* Process globals read or written. Font-sheet state (0x5afbda refcounts,
 * 0x5d032f handles) is the CaptionGlobals shared with the caption writer and
 * is passed separately. */
typedef struct autotext_globals {
    /* 0x5d0397 + 4*index: AUTOTEXT surface slots (pixels NULL = none). */
    CaptionSurface slots[AUTOTEXT_SURFACE_SLOTS];
    /* 0x5d0377: entry-mark sheet (pixels NULL = not loaded). */
    CaptionSurface mark_sheet;
    /* 0x5afc7e: BOOT MARK records { left, top, right, bottom }. */
    int32_t mark_rects[AUTOTEXT_MARK_RECORDS][4];
    /* 0x63a4cd debug flag. */
    int16_t debug_mode;
} AutotextGlobals;

typedef enum autotext_backend_status {
    AUTOTEXT_BACKEND_OK = 0,
    AUTOTEXT_BACKEND_ERROR = 1
} AutotextBackendStatus;

/* Observer events (optional trace callback), emitted in pass 2 only, in
 * original order, immediately before the corresponding original call. */
typedef enum autotext_trace_kind {
    /* FUN_00412db8: text = pending text; a..d = font, pen X, pen Y, line. */
    AUTOTEXT_TRACE_FLUSH = 1,
    /* 0x4d270b: text = line; a..d = font, pen X, pen Y, color. */
    AUTOTEXT_TRACE_DRAW = 2,
    /* 0x4c5b3a from the writer: text = "Autotext picture" /
     * "Drawing entry mark"; rects = source then destination. */
    AUTOTEXT_TRACE_BLIT = 3
} AutotextTraceKind;

/* Unreplaced platform boundaries. All surface callbacks run in pass 2. */
typedef struct autotext_backend {
    void *context;
    /* 0x4c2a8d(0x5cf659, width, height, 6, "AUTO TEXT SURFACE"). On
     * success `out` has pixels (width * 2 * height bytes), width, height and
     * pitch = width * 2; the writer clears it before drawing. */
    AutotextBackendStatus (*create_surface)(void *context, int16_t width,
                                            int16_t height, const char *name,
                                            CaptionSurface *out);
    /* 0x4c2dfb on the slot (index 0..5) or, with index -1, on owner+6. The
     * callback frees the surface; the writer clears its own descriptor. */
    void (*free_surface)(void *context, int index, CaptionSurface *surface);
    /* 0x4c2790("CIFTREE", name, 6, "AutoText Overlays Surface"): picture
     * surface in the display pixel format. */
    AutotextBackendStatus (*load_overlay)(void *context, const char *name,
                                          CaptionSurface *out);
    /* Font sheets, as in CaptionBackend. */
    CaptionBackendStatus (*load_font_sheet)(void *context, int16_t font,
                                            const char *name,
                                            CaptionSurface *sheet);
    void (*release_font_sheet)(void *context, int16_t font,
                               CaptionSurface *sheet);
    /* 0x4264e8 on 0x583979 after sprintf(0x63888b, 0x54167c); debug mode only
     * (optional): AUTOTEXT_DEBUG_TOO_MUCH_TEXT. */
    void (*debug_log)(void *context, const char *message);
    /* Optional observer for tests. */
    void (*trace)(void *context, int kind, const char *text, int32_t a,
                  int32_t b, int32_t c, int32_t d, const int32_t rects[8]);
} AutotextBackend;

#define AUTOTEXT_DEBUG_TOO_MUCH_TEXT "ERROR - CText::ProcessAutoTextLine() - Too much Text"
#define AUTOTEXT_SURFACE_NAME "AUTO TEXT SURFACE"

typedef struct autotext_result {
    int16_t lines;          /* line counter at exit */
    int16_t final_x;
    int16_t final_y;        /* stored at owner->final_y[index] */
    uint8_t surface_created;
    uint8_t overlay_loaded;
    uint8_t stopped_by_e;
    uint32_t glyphs_drawn;
    uint32_t underline_fills;
    uint32_t marks_drawn;
    uint32_t pictures_drawn;
    uint32_t flushes;
} AutotextResult;

/* Runs 0x413187 in two passes.
 *
 * `entry` points at the 301-byte body prefix. The writer reads it and, as in
 * the original, rewrites the picture count word to 10 when it loads the
 * overlay and the count was larger. `text` is the resolved NUL-terminated
 * AUTOTEXT string (the original never modifies it); `text_capacity` must
 * cover its NUL. `rects` (optional, may be NULL together with `rect_count`)
 * receives one AutotextRect per entry mark and `*rect_count` is zeroed at
 * entry and incremented per mark; `rect_capacity` bounds it.
 *
 * Pass 1 lays the whole text out on private copies without side effects and
 * rejects what the original cannot do safely: invalid arguments and
 * surface index, a font outside the FONT table, zero or negative surface
 * extent (the original divides by the width), pending text beyond the
 * 40000-byte buffer, a tag argument beyond its 25-byte buffer, an unset
 * hotspot index for <L>, a hotspot index outside the 400 owner records, a
 * tag close without a tag letter, a colour variant outside the FONT record,
 * a picture table beyond the 301-byte prefix, a rect array too small, a
 * missing mark or overlay surface, and a flush loop that does not
 * terminate. Nothing changes when pass 1 fails.
 *
 * Pass 2 runs in original order on the caller's live `owner`, `globals`,
 * `font_state` and `entry`. A host callback that fails, a font sheet that
 * does not load, or a pixel read or write outside a surface (which depends on
 * surface contents) is a pass-2 failure: state and pixels stay as the
 * original order left them, and the font references and overlay taken by
 * this call are released through the backend. Slot surfaces created by this
 * call stay in `globals->slots` as they would in the original. */
int autotext_write(const CaptionFonts *fonts, const CaptionPixelFormat *format,
                   AutotextOwner *owner, AutotextGlobals *globals,
                   CaptionGlobals *font_state, const AutotextBackend *backend,
                   uint8_t *entry, const char *text, size_t text_capacity,
                   AutotextRect *rects, size_t rect_capacity,
                   int16_t *rect_count, AutotextResult *result);

const char *autotext_write_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
