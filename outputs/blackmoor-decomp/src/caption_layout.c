#include "caption_layout.h"

#include <stdlib.h>
#include <string.h>

/* FONT record offsets (relative to 0x5a4c24 + font * 0x7f3). */
#define FONT_COLOR_X 0x3f       /* int32 per colour, stride 8 */
#define FONT_COLOR_Y 0x43
#define FONT_SPACE_WIDTH 0x4f   /* int16 */
#define FONT_CHAR_SPACING 0x51  /* int16 */
#define FONT_UPPER_BASE 0x53    /* int16 glyph index of 'A' */
#define FONT_LOWER_BASE 0x55
#define FONT_DIGIT_BASE 0x57
#define FONT_GLYPH_RECTS 0xc3   /* 115 x { left, top, right, bottom } int32 */
/* float at 0x52e2d4 */
#define UNDERLINE_FACTOR 0.9f

/* TBOX offsets (relative to 0x5b0a12). */
#define TBOX_FRAME_VIEW_TOP 0x04     /* 0x5b0a16 */
#define TBOX_FRAME_VIEW_BOTTOM 0x0c  /* 0x5b0a1e */
#define TBOX_FRAME_LEFT 0x10         /* 0x5b0a22 */
#define TBOX_FRAME_TOP 0x14          /* 0x5b0a26 */
#define TBOX_FRAME_RIGHT 0x18        /* 0x5b0a2a */
#define TBOX_FRAME_BOTTOM 0x1c       /* 0x5b0a2e */
#define TBOX_FRAME_FIRST_Y 0x20      /* 0x5b0a32 */
#define TBOX_FRAME_BOTTOM_PAD 0x22   /* 0x5b0a34 */
#define TBOX_FRAME_LEFT_MARGIN 0x24  /* 0x5b0a36 */
#define TBOX_FRAME_RIGHT_PAD 0x26    /* 0x5b0a38 */
#define TBOX_CAPTION_VIEW_TOP 0x2c   /* 0x5b0a3e */
#define TBOX_CAPTION_VIEW_BOTTOM 0x34 /* 0x5b0a46 */
#define TBOX_CAPTION_LEFT 0x38       /* 0x5b0a4a */
#define TBOX_CAPTION_TOP 0x3c        /* 0x5b0a4e */
#define TBOX_CAPTION_RIGHT 0x40      /* 0x5b0a52 */
#define TBOX_CAPTION_BOTTOM 0x44     /* 0x5b0a56 */
#define TBOX_CAPTION_FIRST_Y 0x48    /* 0x5b0a5a */
#define TBOX_CAPTION_LEFT_MARGIN 0x4c /* 0x5b0a5e */
#define TBOX_CAPTION_RIGHT_PAD 0x4e  /* 0x5b0a60 */
#define TBOX_DEFAULT_COLOR 0x52      /* 0x5b0a64 */
#define TBOX_TAB_SPACES 0x58         /* 0x5b0a6a */

static int16_t rd16(const uint8_t *bytes, size_t offset)
{
    return (int16_t)(uint16_t)(bytes[offset] | ((uint16_t)bytes[offset + 1] << 8));
}

static int32_t rd32(const uint8_t *bytes, size_t offset)
{
    return (int32_t)((uint32_t)bytes[offset] | ((uint32_t)bytes[offset + 1] << 8) |
                     ((uint32_t)bytes[offset + 2] << 16) |
                     ((uint32_t)bytes[offset + 3] << 24));
}

static int16_t s16(int32_t value)
{
    return (int16_t)(uint16_t)(uint32_t)value;
}

/* 32-bit two's-complement arithmetic as the x86 code performs it; used for
 * values read from FONT/TBOX records, which may hold any int32. */
static int32_t wadd(int32_t a, int32_t b)
{
    return (int32_t)((uint32_t)a + (uint32_t)b);
}

static int32_t wsub(int32_t a, int32_t b)
{
    return (int32_t)((uint32_t)a - (uint32_t)b);
}

/* ---- pixel format (0x4c2f09..0x4c3149) -------------------------------- */

static int channel(uint32_t mask, uint8_t *shift, uint8_t *bits_mask, uint8_t *bits)
{
    uint8_t count = 0u;

    if (mask == 0u) {
        return 0; /* the original loop would not terminate */
    }
    while ((mask & 1u) == 0u) {
        mask >>= 1;
        ++count;
    }
    *shift = count;
    *bits_mask = (uint8_t)mask;
    *bits = mask == 0x1fu ? 5u : 6u;
    return 1;
}

int caption_pixel_format_from_masks(uint32_t red_mask,
                                    uint32_t green_mask,
                                    uint32_t blue_mask,
                                    const uint8_t transparent_rgb[3],
                                    CaptionPixelFormat *format)
{
    CaptionPixelFormat local;
    uint8_t red;
    uint8_t green;
    uint8_t blue;

    if (format == NULL || transparent_rgb == NULL) {
        return CAPTION_ERR_ARGUMENT;
    }
    memset(&local, 0, sizeof(local));
    if (!channel(red_mask, &local.shifts[2], &local.masks[2], &local.channel_bits[2]) ||
        !channel(green_mask, &local.shifts[1], &local.masks[1], &local.channel_bits[1]) ||
        !channel(blue_mask, &local.shifts[0], &local.masks[0], &local.channel_bits[0])) {
        return CAPTION_ERR_ARGUMENT;
    }
    /* 0x4c304f..0x4c3089: mask the BOOT values by channel. */
    red = (uint8_t)(transparent_rgb[0] & local.masks[2]);
    green = (uint8_t)(transparent_rgb[1] & local.masks[1]);
    blue = (uint8_t)(transparent_rgb[2] & local.masks[0]);
    /* 0x4c30a0..0x4c30ec: widen 5-bit BOOT values for 6-bit channels. */
    if (local.channel_bits[2] != 5u) {
        red = (uint8_t)(red << 1);
    }
    if (local.channel_bits[1] != 5u) {
        green = (uint8_t)(green << 1);
    }
    if (local.channel_bits[0] != 5u) {
        blue = (uint8_t)(blue << 1);
    }
    local.color_key = (uint16_t)(((uint32_t)red << local.shifts[2]) |
                                 ((uint32_t)green << local.shifts[1]) |
                                 ((uint32_t)blue << local.shifts[0]));
    *format = local;
    return CAPTION_OK;
}

/* ---- fonts and geometry ---------------------------------------------- */

int caption_fonts_init(const uint8_t *font_chunk,
                       size_t font_chunk_length,
                       int16_t font_count,
                       CaptionFonts *fonts)
{
    int16_t font;

    if (font_chunk == NULL || fonts == NULL) {
        return CAPTION_ERR_ARGUMENT;
    }
    if (font_count <= 0 || font_count > (int16_t)CAPTION_MAX_FONTS ||
        font_chunk_length < (size_t)font_count * CAPTION_FONT_RECORD_BYTES) {
        return CAPTION_ERR_FORMAT;
    }
    memset(fonts, 0, sizeof(*fonts));
    fonts->count = font_count;
    for (font = 0; font < font_count; ++font) {
        size_t glyph;
        const uint8_t *record = font_chunk + (size_t)font * CAPTION_FONT_RECORD_BYTES;

        if (memchr(record, 0, CAPTION_FONT_NAME_BYTES) == NULL) {
            return CAPTION_ERR_FORMAT;
        }
        memcpy(fonts->records[font], record, CAPTION_FONT_RECORD_BYTES);
        /* 0x436c3a..0x436cb2. */
        for (glyph = 0u; glyph < CAPTION_FONT_GLYPHS; ++glyph) {
            size_t rect = FONT_GLYPH_RECTS + glyph * 16u;
            fonts->glyph_size[font][glyph][0] =
                s16(wadd(wsub(rd32(record, rect + 8u), rd32(record, rect)), 1));
            fonts->glyph_size[font][glyph][1] =
                s16(wadd(wsub(rd32(record, rect + 12u), rd32(record, rect + 4u)), 1));
        }
    }
    return CAPTION_OK;
}

const char *caption_font_sheet_name(const CaptionFonts *fonts, int16_t font)
{
    if (fonts == NULL || font < 0 || font >= fonts->count) {
        return NULL;
    }
    return (const char *)fonts->records[font];
}

int caption_geometry_init(const uint8_t *tbox, size_t tbox_length,
                          CaptionGeometry *geometry)
{
    if (tbox == NULL || geometry == NULL) {
        return CAPTION_ERR_ARGUMENT;
    }
    if (tbox_length != CAPTION_TBOX_BYTES) {
        return CAPTION_ERR_FORMAT;
    }
    memcpy(geometry->tbox, tbox, CAPTION_TBOX_BYTES);
    /* 0x437300..0x437359. */
    geometry->framed_surface_width =
        s16(wadd(wsub(rd32(tbox, TBOX_FRAME_RIGHT), rd32(tbox, TBOX_FRAME_LEFT)), 1));
    geometry->framed_surface_height =
        s16(wadd(wsub(rd32(tbox, TBOX_FRAME_BOTTOM), rd32(tbox, TBOX_FRAME_TOP)), 1));
    geometry->caption_surface_width =
        s16(wadd(wsub(rd32(tbox, TBOX_CAPTION_RIGHT), rd32(tbox, TBOX_CAPTION_LEFT)), 1));
    geometry->caption_surface_height =
        s16(wadd(wsub(rd32(tbox, TBOX_CAPTION_BOTTOM), rd32(tbox, TBOX_CAPTION_TOP)), 1));
    return CAPTION_OK;
}

/* ---- writer engine ---------------------------------------------------- */

typedef struct engine {
    const CaptionFonts *fonts;
    const CaptionGeometry *geometry;
    const CaptionPixelFormat *format;
    const CaptionBackend *backend;
    CaptionSurface *target;
    /* Pass 2 draws into a private copy of the target, committed on success. */
    CaptionSurface canvas;
    /* Pass 1 works on copies; pass 2 on the caller's objects, so backend
     * callbacks observe the live state in source order. */
    CaptionTextBox *box;
    CaptionGlobals *globals;
    CaptionTextBox box_copy;
    CaptionGlobals globals_copy;
    /* Sheet references taken by this call (released after a failure). */
    int16_t acquired[CAPTION_MAX_FONTS];
    uint8_t *caller_text;
    size_t caller_length;
    int appended;
    int16_t mode;
    int simulate;
    int measure;
    int debug;
    int frame;
    int16_t font;
    int16_t color;
    int16_t x;
    int16_t y;
    int16_t y_limit;
    int16_t right;
    int16_t lines;
    int32_t newline_pending;
    int status;
    CaptionResult result;
    char text[CAPTION_TEXT_BUFFER_BYTES];
    char line[CAPTION_TEXT_BUFFER_BYTES];
} Engine;

static const uint8_t *font_record(const Engine *e, int16_t font)
{
    return e->fonts->records[font];
}

static int font_valid(const Engine *e, int16_t font)
{
    return font >= 0 && font < e->fonts->count;
}

/* 0x4d214b: punctuation and Latin-1 glyph slots in the FONT header. */
static int special_slot(uint8_t c)
{
    switch (c) {
    case 0x21: return 0x65; case 0x23: return 0xb5; case 0x24: return 0xb7;
    case 0x25: return 0x67; case 0x26: return 0x69; case 0x27: return 0x73;
    case 0x28: return 0x6d; case 0x29: return 0x6f; case 0x2a: return 0x6b;
    case 0x2b: return 0x71; case 0x2c: return 0x5b; case 0x2d: return 0x61;
    case 0x2e: return 0x59; case 0x2f: return 0x77; case 0x3a: return 0x5f;
    case 0x3b: return 0x75; case 0x3c: return 0xb9; case 0x3d: return 0x5d;
    case 0x3e: return 0xbb; case 0x3f: return 0x63; case 0x5f: return 0xaf;
    case 0x7b: return 0xbd; case 0x7d: return 0xbf; case 0x80: return 0xc1;
    case 0xa1: return 0x9b; case 0xbf: return 0x9d; case 0xc0: return 0x87;
    case 0xc4: return 0x8f; case 0xc5: return 0xb1; case 0xc9: return 0xa3;
    case 0xd1: return 0x9f; case 0xd6: return 0x93; case 0xdc: return 0x97;
    case 0xdf: return 0xad; case 0xe0: return 0x79; case 0xe1: return 0xa5;
    case 0xe2: return 0x89; case 0xe4: return 0x91; case 0xe5: return 0xb3;
    case 0xe7: return 0x7b; case 0xe8: return 0x7d; case 0xe9: return 0x7f;
    case 0xea: return 0x81; case 0xeb: return 0x83; case 0xed: return 0xa7;
    case 0xee: return 0x8b; case 0xf1: return 0xa1; case 0xf3: return 0xa9;
    case 0xf4: return 0x85; case 0xf6: return 0x95; case 0xf9: return 0x8d;
    case 0xfa: return 0xab; case 0xfc: return 0x99;
    default: return -1;
    }
}

/* Glyph index for one byte (0x4d214b, then C-locale ctype for ASCII), or
 * -1 for a byte drawn as a space. */
static int glyph_index(const uint8_t *record, uint8_t c, int *index)
{
    int slot = special_slot(c);
    int16_t value;

    if (slot >= 0) {
        value = rd16(record, (size_t)slot);
    } else if (c >= 'A' && c <= 'Z') {
        value = s16((int8_t)c - 0x41 + rd16(record, FONT_UPPER_BASE));
    } else if (c >= 'a' && c <= 'z') {
        value = s16((int8_t)c - 0x61 + rd16(record, FONT_LOWER_BASE));
    } else if (c >= '0' && c <= '9') {
        value = s16((int8_t)c - 0x30 + rd16(record, FONT_DIGIT_BASE));
    } else {
        *index = -1;
        return CAPTION_OK;
    }
    if (value < 0 || value >= (int16_t)CAPTION_FONT_GLYPHS) {
        /* Index >= 115 reads the next font's size row; native rejects it. */
        return CAPTION_ERR_FORMAT;
    }
    *index = value;
    return CAPTION_OK;
}

/* 0x4d3836 with 16-bit accumulation. */
static int text_width(const Engine *e, const char *text, int16_t *width)
{
    const uint8_t *record = font_record(e, e->font);
    int16_t total = 0;

    for (; *text != '\0'; ++text) {
        int index;
        int status = glyph_index(record, (uint8_t)*text, &index);

        if (status != CAPTION_OK) {
            return status;
        }
        if (index < 0) {
            total = s16(total + rd16(record, FONT_SPACE_WIDTH));
        } else {
            total = s16(total + e->fonts->glyph_size[e->font][index][0] +
                        rd16(record, FONT_CHAR_SPACING));
        }
    }
    *width = total;
    return CAPTION_OK;
}

static int color_offsets(const Engine *e, int32_t *dx, int32_t *dy)
{
    int32_t offset = FONT_COLOR_X + (int32_t)e->color * 8;

    if (offset < 0 || offset + 8 > (int32_t)CAPTION_FONT_RECORD_BYTES) {
        /* Offsets past this record read neighbouring FONT table bytes;
         * native rejects them. */
        return CAPTION_ERR_UNSUPPORTED;
    }
    *dx = rd32(font_record(e, e->font), (size_t)offset);
    *dy = rd32(font_record(e, e->font), (size_t)offset + 4u);
    return CAPTION_OK;
}

/* The original addresses surface words linearly (pixels + row * pitch +
 * column * 2) without clipping: a glyph past the right edge continues on the
 * next row. Only addresses outside the pitch * height buffer are rejected. */
static uint8_t *word_at(const CaptionSurface *surface, int64_t row, int64_t column)
{
    int64_t offset;
    int64_t size;

    if (surface == NULL || surface->pixels == NULL || surface->pitch <= 0 ||
        surface->height <= 0) {
        return NULL;
    }
    if (row < INT32_MIN || row > INT32_MAX || column < INT32_MIN || column > INT32_MAX) {
        return NULL;
    }
    offset = row * surface->pitch + column * 2;
    size = (int64_t)surface->pitch * surface->height;
    if (offset < 0 || offset + 2 > size) {
        return NULL;
    }
    return surface->pixels + offset;
}

/* Pass 2 stages pixels in `canvas`; before every backend call the staged
 * pixels are copied to the caller's target so callbacks observe the surface
 * as the original would have it at that point. */
static void sync_target(const Engine *e)
{
    if (!e->simulate && e->target != NULL && e->canvas.pixels != NULL &&
        e->canvas.pixels != e->target->pixels) {
        memcpy(e->target->pixels, e->canvas.pixels,
               (size_t)e->target->pitch * (size_t)e->target->height);
    }
}

/* Backends may write through their live context. Pull allowed target-pixel
 * writes back into the staging image so later writer work cannot overwrite
 * them with a stale copy. */
static void capture_target(const Engine *e)
{
    if (!e->simulate && e->target != NULL && e->canvas.pixels != NULL &&
        e->canvas.pixels != e->target->pixels) {
        memcpy(e->canvas.pixels, e->target->pixels,
               (size_t)e->target->pitch * (size_t)e->target->height);
    }
}

static uint16_t get16(const uint8_t *p)
{
    return (uint16_t)(p[0] | (p[1] << 8));
}

static void put16(uint8_t *p, uint16_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
}

/* 0x4c9340: first non-key word in a sheet rectangle, else 0. */
static int scan_color(const Engine *e, const CaptionSurface *sheet,
                      int32_t left, int32_t top, int32_t right, int32_t bottom,
                      uint16_t *color)
{
    int64_t row;
    int64_t column;

    *color = 0u;
    if (sheet == NULL || sheet->pixels == NULL) {
        return CAPTION_OK;
    }
    for (row = top; row <= (int64_t)bottom; ++row) {
        for (column = left; column <= (int64_t)right; ++column) {
            const uint8_t *p = word_at(sheet, row, column);
            uint16_t word;

            if (p == NULL) {
                return CAPTION_ERR_BOUNDS;
            }
            word = get16(p);
            if (word != e->format->color_key) {
                *color = word;
                return CAPTION_OK;
            }
        }
    }
    return CAPTION_OK;
}

/* 0x4c924d / 0x4c92c5. */
static int acquire_font(Engine *e, int16_t font)
{
    CaptionGlobals *g = e->globals;

    if (!font_valid(e, font)) {
        return CAPTION_ERR_FONT;
    }
    if (g->sheet_refcount[font] == 0 && g->sheets[font].pixels == NULL && !e->simulate) {
        CaptionSurface sheet = {NULL, 0, 0, 0};

        sync_target(e);
        /* 0x4c2790 reports a failed load (0x42639d) and quits (0x4c97b4). */
        {
            int load_status = e->backend->load_font_sheet(
                e->backend->context, font, caption_font_sheet_name(e->fonts, font), &sheet);
            capture_target(e);
            if (load_status != CAPTION_BACKEND_OK || sheet.pixels == NULL) {
                return CAPTION_ERR_BACKEND;
            }
        }
        g->sheets[font] = sheet;
    }
    g->sheet_refcount[font] = s16(g->sheet_refcount[font] + 1);
    if (!e->simulate) {
        ++e->acquired[font];
    }
    return CAPTION_OK;
}

static void release_font(Engine *e, int16_t font)
{
    CaptionGlobals *g = e->globals;

    if (!e->simulate && e->acquired[font] > 0) {
        --e->acquired[font];
    }
    if (g->sheets[font].pixels != NULL) {
        g->sheet_refcount[font] = s16(g->sheet_refcount[font] - 1);
        if (g->sheet_refcount[font] == 0) {
            if (!e->simulate) {
                sync_target(e);
                e->backend->release_font_sheet(e->backend->context, font,
                                               &g->sheets[font]);
                capture_target(e);
            }
            memset(&g->sheets[font], 0, sizeof(g->sheets[font]));
        }
    }
    if (g->sheet_refcount[font] < 0) {
        g->sheet_refcount[font] = 0;
    }
}

/* 0x4d270b. */
static int draw_line(Engine *e, const char *text)
{
    const uint8_t *record = font_record(e, e->font);
    const CaptionSurface *sheet = &e->globals->sheets[e->font];
    int32_t left = e->x;
    int32_t bottom = e->y;
    int32_t start = left;
    int32_t last_right = 0;
    int32_t underline_row = 0;
    int have_row = 0;
    int32_t dx = 0;
    int32_t dy = 0;
    int status;

    for (; *text != '\0'; ++text) {
        int index;

        status = glyph_index(record, (uint8_t)*text, &index);
        if (status != CAPTION_OK) {
            return status;
        }
        if (index < 0) {
            left += rd16(record, FONT_SPACE_WIDTH);
            last_right = left - 1 + rd16(record, FONT_SPACE_WIDTH);
            continue;
        }
        {
            size_t rect = FONT_GLYPH_RECTS + (size_t)index * 16u;
            int16_t w = e->fonts->glyph_size[e->font][index][0];
            int16_t h = e->fonts->glyph_size[e->font][index][1];
            int32_t top = bottom - h + 1;
            int32_t right = left - 1 + w;
            int32_t src_left;
            int32_t src_top;
            int32_t src_right;
            int32_t src_bottom;

            status = color_offsets(e, &dx, &dy);
            if (status != CAPTION_OK) {
                return status;
            }
            src_left = wadd(rd32(record, rect), dx);
            src_top = wadd(rd32(record, rect + 4u), dy);
            src_right = wadd(rd32(record, rect + 8u), dx);
            src_bottom = wadd(rd32(record, rect + 12u), dy);
            last_right = right;
            (void)right;
            if (!e->simulate) {
                int64_t row;
                int64_t column;
                int64_t rows = (int64_t)src_bottom - src_top + 1;
                int64_t columns = (int64_t)src_right - src_left + 1;

                if (sheet->pixels == NULL) {
                    return CAPTION_ERR_BACKEND; /* original blits from a null sheet */
                }
                /* 0x4c5b3a: source-height rows, source-width words; only words
                 * other than the colour key are written. */
                for (row = 0; row < rows; ++row) {
                    for (column = 0; column < columns; ++column) {
                        const uint8_t *src = word_at(sheet, (int64_t)src_top + row,
                                                     (int64_t)src_left + column);
                        uint16_t word;
                        uint8_t *dst;

                        if (src == NULL) {
                            return CAPTION_ERR_BOUNDS;
                        }
                        word = get16(src);
                        if (word == e->format->color_key) {
                            continue;
                        }
                        dst = word_at(&e->canvas, top + row, left + column);
                        if (dst == NULL) {
                            return CAPTION_ERR_BOUNDS;
                        }
                        put16(dst, word);
                    }
                }
            }
            ++e->result.glyphs_drawn;
            if (e->box->underline != 0 && !have_row) {
                /* 0x4d2b41..0x4d2b67: __ftol((float)h * 0.9f) + top. The
                 * product of two 24-bit floats is exact in double, and
                 * __ftol (0x50ce04) truncates toward zero. */
                underline_row = (int32_t)((double)(float)(bottom - top + 1) *
                                          (double)UNDERLINE_FACTOR) + top;
                have_row = 1;
            }
            left = rd16(record, FONT_CHAR_SPACING) + left + w;
        }
    }
    if (e->box->underline != 0) {
        int32_t count = last_right - start + 1;

        if (!have_row) {
            return CAPTION_ERR_UNSUPPORTED; /* row is an uninitialized local */
        }
        if (!e->simulate) {
            int32_t i;

            for (i = 0; i < count; ++i) {
                uint8_t *p = word_at(&e->canvas, underline_row, start + i);
                if (p == NULL) {
                    return CAPTION_ERR_BOUNDS;
                }
                put16(p, e->box->underline_color);
            }
        }
        ++e->result.underline_fills;
    }
    return CAPTION_OK;
}

/* 0x44887c. */
static int flush(Engine *e)
{
    const char *text = e->text;
    int16_t source = 0;
    int16_t count;
    int wrapped = 0;
    int status;

    memset(e->line, 0, sizeof(e->line));
    count = 0;
    for (;;) {
        int16_t line_start_x;
        int16_t source_start;

        if (e->newline_pending != 0) {
            int16_t h = e->fonts->glyph_size[e->font][0][1];

            if (e->box->tight_spacing != 0) {
                e->y = s16(e->y + h);
            } else if (e->box->half_spacing != 0) {
                e->y = s16(e->y + s16((h / 9 + h) / 2));
                e->box->half_spacing = 0;
            } else {
                e->y = s16(e->y + s16(h + h / 9));
            }
            if (e->y >= e->y_limit &&
                ((e->lines > 2 && !e->frame) || (e->lines > 6 && e->frame)) &&
                !e->measure && e->debug && e->box->too_long_reported == 0) {
                if (!e->simulate && e->backend->debug_log != NULL) {
                    sync_target(e);
                    e->backend->debug_log(e->backend->context, CAPTION_DEBUG_TOO_MUCH_TEXT);
                    capture_target(e);
                }
                e->box->too_long_reported = 1;
            }
            e->newline_pending = 0;
        }
        if (text[0] == '\0') {
            break;
        }
        line_start_x = e->x;
        source_start = source;
        for (;;) {
            int16_t width;

            status = text_width(e, e->line, &width);
            if (status != CAPTION_OK) {
                return status;
            }
            if ((int32_t)e->x + width >= e->right || text[source] == '\0') {
                break;
            }
            e->line[count++] = text[source++];
        }
        if (text[source] == '\0') {
            e->lines = s16(e->lines + 1);
        }
        if (text[source] != '\0') {
            --count;
            --source;
            if (count >= 0) {
                e->line[count] = '\0';
            }
            while (count >= 0 && e->line[count] != ' ') {
                --count;
                --source;
            }
            ++count;
            ++source;
            e->line[count] = '\0';
            wrapped = 1;
            if (count == 0 && source == source_start && line_start_x == e->box->left_margin) {
                /* The same word restarts at the margin forever. */
                return CAPTION_ERR_UNSUPPORTED;
            }
        }
        if (e->line[0] != '\0' && e->box->too_long_reported == 0) {
            int16_t width;

            if (!e->measure) {
                status = draw_line(e, e->line);
                if (status != CAPTION_OK) {
                    return status;
                }
            }
            status = text_width(e, e->line, &width);
            if (status != CAPTION_OK) {
                return status;
            }
            e->x = s16(e->x + width);
        }
        if (wrapped) {
            wrapped = 0;
            e->x = e->box->left_margin;
            e->newline_pending = 1;
            e->lines = s16(e->lines + 1);
        }
        memset(e->line, 0, sizeof(e->line));
        count = 0;
        if (text[source] == '\0') {
            break;
        }
    }
    memset(e->text, 0, sizeof(e->text));
    return CAPTION_OK;
}

/* MSVC atoi (0x50ca90) in the C locale. */
static int32_t original_atoi(const char *s)
{
    uint32_t value = 0u;
    int negative = 0;

    while (*s == ' ' || (*s >= '\t' && *s <= '\r')) {
        ++s;
    }
    if (*s == '-' || *s == '+') {
        negative = *s == '-';
        ++s;
    }
    while (*s >= '0' && *s <= '9') {
        value = value * 10u + (uint32_t)(*s - '0');
        ++s;
    }
    return negative ? (int32_t)(0u - value) : (int32_t)value;
}

static int dispatch(Engine *e, char tag, const char *argument)
{
    const uint8_t *tbox = e->geometry->tbox;
    int status;

    switch (tag) {
    case 'c':
        status = flush(e);
        if (status != CAPTION_OK) {
            return status;
        }
        e->color = s16(original_atoi(argument));
        return CAPTION_OK;
    case 'e':
        return 1; /* stop */
    case 'f': {
        int16_t font;

        status = flush(e);
        if (status != CAPTION_OK) {
            return status;
        }
        font = s16(original_atoi(argument));
        if (!font_valid(e, font)) {
            return CAPTION_ERR_FONT;
        }
        release_font(e, e->font);
        e->font = font;
        return acquire_font(e, font);
    }
    case 'l':
        status = flush(e);
        if (status != CAPTION_OK) {
            return status;
        }
        e->box->tight_spacing = e->box->tight_spacing == 0 ? 1 : 0;
        return CAPTION_OK;
    case 'n':
    case 'w':
        status = flush(e);
        if (status != CAPTION_OK) {
            return status;
        }
        e->x = e->box->left_margin;
        e->newline_pending = 1;
        if (tag == 'w') {
            e->box->half_spacing = 1;
        }
        return CAPTION_OK;
    case 'r': {
        int16_t width;

        status = text_width(e, e->text, &width);
        if (status != CAPTION_OK) {
            return status;
        }
        e->x = s16((int32_t)e->right - width);
        status = flush(e);
        if (status != CAPTION_OK) {
            return status;
        }
        e->x = e->box->left_margin;
        e->newline_pending = 1;
        return CAPTION_OK;
    }
    case 't': {
        size_t length = strlen(e->text);
        int16_t spaces = rd16(tbox, TBOX_TAB_SPACES);

        if (length + (size_t)spaces >= CAPTION_TEXT_BUFFER_BYTES) {
            return CAPTION_ERR_LIMIT;
        }
        memset(e->text + length, ' ', (size_t)spaces);
        return CAPTION_OK;
    }
    case 'u':
        if (e->box->underline == 0) {
            const uint8_t *record = font_record(e, e->font);
            int16_t glyph = rd16(record, FONT_UPPER_BASE);
            int32_t dx;
            int32_t dy;
            size_t rect;

            if (glyph < 0 || glyph >= (int16_t)CAPTION_FONT_GLYPHS) {
                return CAPTION_ERR_FORMAT;
            }
            status = color_offsets(e, &dx, &dy);
            if (status != CAPTION_OK) {
                return status;
            }
            rect = FONT_GLYPH_RECTS + (size_t)glyph * 16u;
            if (!e->simulate) {
                status = scan_color(e, &e->globals->sheets[e->font],
                                    wadd(rd32(record, rect), dx), wadd(rd32(record, rect + 4u), dy),
                                    wadd(rd32(record, rect + 8u), dx),
                                    wadd(rd32(record, rect + 12u), dy),
                                    &e->box->underline_color);
                if (status != CAPTION_OK) {
                    return status;
                }
            }
            status = flush(e);
            if (status != CAPTION_OK) {
                return status;
            }
            e->box->underline = 1;
        } else {
            status = flush(e);
            if (status != CAPTION_OK) {
                return status;
            }
            e->box->underline = 0;
        }
        return CAPTION_OK;
    default:
        return CAPTION_OK; /* 'd','g'..'k','m','o'..'q','s','v' and others */
    }
}

/* 0x4c46d1: fills width * height words contiguously (pitch is ignored). */
static void clear_surface(const Engine *e, CaptionSurface *surface, uint8_t red,
                          uint8_t green, uint8_t blue)
{
    const CaptionPixelFormat *f = e->format;
    uint16_t value;
    int32_t i;
    int32_t words = (int32_t)surface->width * (int32_t)surface->height;

    red &= f->masks[2];
    green &= f->masks[1];
    blue &= f->masks[0];
    if (f->channel_bits[2] != 5u) {
        red = (uint8_t)(red << 1);
    }
    if (f->channel_bits[1] != 5u) {
        green = (uint8_t)(green << 1);
    }
    if (f->channel_bits[0] != 5u) {
        blue = (uint8_t)(blue << 1);
    }
    value = (uint16_t)(((uint32_t)red << f->shifts[2]) |
                       ((uint32_t)green << f->shifts[1]) |
                       ((uint32_t)blue << f->shifts[0]));
    for (i = 0; i < words; ++i) {
        put16(surface->pixels + (size_t)i * 2u, value);
    }
}

static int run(Engine *e, char *text)
{
    const uint8_t *tbox = e->geometry->tbox;
    char tag = 0;
    int have_tag_letter = 0;
    int tag_seen = 0;
    int in_tag = 0;
    char argument[CAPTION_TAG_BUFFER_BYTES + 1];
    const char *p;
    int status;

    /* 0x448d73..0x448dba. */
    e->box->too_long_reported = 0;
    e->box->underline = 0;
    e->box->underline_color = 0u;
    e->box->tight_spacing = 0;
    e->box->half_spacing = 0;
    if (e->frame) {
        e->y = rd16(tbox, TBOX_FRAME_FIRST_Y);
        e->box->left_margin = rd16(tbox, TBOX_FRAME_LEFT_MARGIN);
        e->x = e->box->left_margin;
        e->y_limit = s16(wsub(rd32(tbox, TBOX_FRAME_BOTTOM), rd16(tbox, TBOX_FRAME_BOTTOM_PAD)));
        e->right = s16(wsub(rd32(tbox, TBOX_FRAME_RIGHT), rd16(tbox, TBOX_FRAME_RIGHT_PAD)));
    } else {
        int16_t edge;

        e->y = rd16(tbox, TBOX_CAPTION_FIRST_Y);
        e->box->left_margin = rd16(tbox, TBOX_CAPTION_LEFT_MARGIN);
        e->x = e->box->left_margin;
        e->y_limit = s16(wadd(wsub(rd32(tbox, TBOX_CAPTION_VIEW_BOTTOM),
                                   rd32(tbox, TBOX_CAPTION_VIEW_TOP)), 4));
        edge = s16(wsub(rd32(tbox, TBOX_CAPTION_RIGHT), rd16(tbox, TBOX_CAPTION_RIGHT_PAD)));
        e->right = s16((int32_t)edge - e->x + 1);
        if (!e->measure) {
            e->globals->caption_finish_flag = 0;
        }
    }
    if (e->globals->frame_open != 0) {
        if (!e->simulate) {
            sync_target(e);
            int close_status = e->backend->close_frame_text(e->backend->context);
            capture_target(e);
            if (close_status != CAPTION_BACKEND_OK) {
                return CAPTION_ERR_BACKEND;
            }
        }
        /* 0x4de2d8 itself clears 0x5b15d6 (0x4de302) and, through
         * 0x4de214 -> 0x4de1f5, 0x5a161f. Its other effects (UI mode +0x991,
         * 0x5d17f5, taskbar calls) belong to the backend (S05-2). */
        e->globals->frame_open = 0u;
        e->globals->framed_ready = 0;
    }
    memset(e->text, 0, sizeof(e->text));
    memset(argument, 0, sizeof(argument));
    /* 0x448f1c fills the 15-byte tab buffer at entry with the TBOX count;
     * other counts overrun neighbouring locals. */
    {
        int16_t spaces = rd16(tbox, TBOX_TAB_SPACES);
        if (spaces < 0 || spaces >= (int16_t)CAPTION_TAB_BUFFER_BYTES) {
            return CAPTION_ERR_FORMAT;
        }
    }
    if (!e->measure) {
        if (!e->simulate) {
            /* 0x448f3f: the caption mode clears to (0,31,0), others to black. */
            if (e->mode == CAPTION_MODE_CAPTION) {
                clear_surface(e, &e->canvas, 0u, 0x1fu, 0u);
            } else {
                clear_surface(e, &e->canvas, 0u, 0u, 0u);
            }
        }
    }
    status = acquire_font(e, e->font);
    if (status != CAPTION_OK) {
        return status;
    }
    /* 0x448f8d..0x448fa9: "<e>\0" written over the caller's terminator. */
    if (!e->simulate && e->appended) {
        memcpy(e->caller_text + e->caller_length, "<e>", 4u);
    }

    for (p = text;; ++p) {
        char c = *p;

        if (c == '\0') {
            /* unreachable: "<e>" precedes the terminator */
            return CAPTION_ERR_UNSUPPORTED;
        } else if (c == '<') {
            in_tag = 1;
            have_tag_letter = 0;
        } else if (c == '>') {
            in_tag = 0;
            if (!tag_seen) {
                /* dispatches on an uninitialized stack byte */
                return CAPTION_ERR_UNSUPPORTED;
            }
            status = dispatch(e, tag, argument);
            if (status == 1) {
                break;
            }
            if (status != CAPTION_OK) {
                return status;
            }
            memset(argument, 0, sizeof(argument));
        } else if (in_tag && !have_tag_letter) {
            tag = c;
            have_tag_letter = 1;
            tag_seen = 1;
        } else if (in_tag) {
            size_t length = strlen(argument);
            /* Longer arguments spill into neighbouring locals ([ebp-0x1f..]);
             * the result depends on stack bytes, so native rejects them. */
            if (length >= CAPTION_TAG_BUFFER_BYTES) {
                return CAPTION_ERR_LIMIT;
            }
            argument[length] = c;
        } else {
            size_t length = strlen(e->text);
            /* Native keeps a terminator inside the 5000-byte buffer; the
             * original's next append would read into [ebp-0x4c]. */
            if (length + 1u >= CAPTION_TEXT_BUFFER_BYTES) {
                return CAPTION_ERR_LIMIT;
            }
            e->text[length] = c;
        }
    }

    if (!e->measure) {
        if (e->frame) {
            e->y = s16(e->y + rd16(tbox, TBOX_FRAME_BOTTOM_PAD) * 3);
            if (e->y >= e->y_limit) {
                return CAPTION_ERR_TOO_LONG; /* 0x449684 message + quit */
            }
            if ((int32_t)e->y > wadd(rd32(tbox, TBOX_FRAME_TOP),
                                     rd32(tbox, TBOX_FRAME_VIEW_BOTTOM))) {
                e->globals->framed_scroll_lines =
                    s16(wsub(wadd(wsub((int32_t)e->y, rd32(tbox, TBOX_FRAME_TOP)), 1),
                             wadd(wsub(rd32(tbox, TBOX_FRAME_VIEW_BOTTOM),
                                       rd32(tbox, TBOX_FRAME_VIEW_TOP)), 1)));
            } else {
                e->globals->framed_scroll_lines = 1;
            }
            if (e->globals->framed_scroll_lines <= 0) {
                e->globals->framed_scroll_lines = 1;
            }
            e->globals->framed_ready = 1;
        } else {
            e->globals->caption_visible_flag = 1;
            if (!e->simulate) {
                sync_target(e);
                int restore_status = e->backend->restore_caption_box(e->backend->context);
                capture_target(e);
                if (restore_status != CAPTION_BACKEND_OK) {
                    return CAPTION_ERR_BACKEND;
                }
            }
        }
    }
    release_font(e, e->font);
    sync_target(e);
    return CAPTION_OK;
}

int caption_layout_write(const CaptionFonts *fonts,
                         const CaptionGeometry *geometry,
                         const CaptionPixelFormat *format,
                         CaptionTextBox *box,
                         CaptionGlobals *globals,
                         const CaptionBackend *backend,
                         CaptionSurface *target,
                         const CaptionRequest *request,
                         CaptionResult *result)
{
    Engine *e;
    char *work;
    size_t length;
    int appended = 0;
    int status;
    int pass;
    uint8_t *canvas = NULL;
    size_t canvas_bytes = 0u;

    if (result != NULL) {
        memset(result, 0, sizeof(*result));
    }
    if (fonts == NULL || geometry == NULL || format == NULL || box == NULL ||
        globals == NULL || backend == NULL || request == NULL || result == NULL ||
        request->text == NULL) {
        return CAPTION_ERR_ARGUMENT;
    }
    {
        const void *nul = memchr(request->text, 0, request->text_capacity);
        if (nul == NULL) {
            return CAPTION_ERR_ARGUMENT;
        }
        length = (size_t)((const uint8_t *)nul - request->text);
    }
    if (request->mode < CAPTION_MODE_FRAMED) {
        return CAPTION_ERR_ARGUMENT;
    }
    /* Every backend call the request can reach must exist up front: sheets
     * are loaded and released through the backend. */
    if (backend->load_font_sheet == NULL || backend->release_font_sheet == NULL ||
        (globals->frame_open != 0u && backend->close_frame_text == NULL) ||
        (!request->measure && request->mode != CAPTION_MODE_FRAMED &&
         backend->restore_caption_box == NULL)) {
        return CAPTION_ERR_UNSUPPORTED;
    }
    /* 0x448f8d: strstr(text, "<e>"); if absent "<e>\0" overwrites the NUL. */
    work = malloc(length + 4u);
    if (work == NULL) {
        return CAPTION_ERR_LIMIT;
    }
    memcpy(work, request->text, length + 1u);
    if (strstr(work, "<e>") == NULL) {
        if (length + 4u > request->text_capacity) {
            free(work);
            return CAPTION_ERR_LIMIT;
        }
        memcpy(work + length, "<e>", 4u);
        appended = 1;
    }
    e = malloc(sizeof(*e));
    if (e == NULL) {
        free(work);
        return CAPTION_ERR_LIMIT;
    }
    if (!request->measure) {
        if (target == NULL || target->pixels == NULL || target->width < 0 ||
            target->height <= 0 || target->pitch <= 0 ||
            (int32_t)target->pitch < (int32_t)target->width * 2) {
            free(e);
            free(work);
            return CAPTION_ERR_ARGUMENT;
        }
        canvas_bytes = (size_t)target->pitch * (size_t)target->height;
        canvas = malloc(canvas_bytes);
        if (canvas == NULL) {
            free(e);
            free(work);
            return CAPTION_ERR_LIMIT;
        }
        memcpy(canvas, target->pixels, canvas_bytes);
    }

    for (pass = 0; pass < 2; ++pass) {
        memset(e, 0, sizeof(*e));
        e->fonts = fonts;
        e->geometry = geometry;
        e->format = format;
        e->backend = backend;
        e->target = target;
        if (canvas != NULL) {
            e->canvas = *target;
            e->canvas.pixels = canvas;
        }
        if (pass == 0) {
            e->box_copy = *box;
            e->globals_copy = *globals;
            e->box = &e->box_copy;
            e->globals = &e->globals_copy;
        } else {
            e->box = box;
            e->globals = globals;
        }
        e->caller_text = request->text;
        e->caller_length = length;
        e->appended = appended;
        e->mode = request->mode;
        e->simulate = pass == 0;
        e->measure = request->measure != 0u;
        e->debug = request->debug_mode != 0u;
        e->frame = request->mode == CAPTION_MODE_FRAMED;
        e->font = request->mode < 0 ? CAPTION_DEFAULT_FONT : request->mode;
        e->color = rd16(geometry->tbox, TBOX_DEFAULT_COLOR);
        if (!font_valid(e, e->font)) {
            status = CAPTION_ERR_FONT;
            break;
        }
        status = run(e, work);
        if (status != CAPTION_OK) {
            if (!e->simulate) {
                int16_t font;

                /* Pass 2 failed after host-visible effects. State written so
                 * far stays as the original order left it (no rollback);
                 * only this call's sheet references are released so no
                 * handle or count is left behind. */
                for (font = 0; font < (int16_t)CAPTION_MAX_FONTS; ++font) {
                    while (e->acquired[font] > 0) {
                        release_font(e, font);
                    }
                }
            }
            break;
        }
        if (!e->simulate) {
            *result = e->result;
            result->lines = e->lines;
            result->terminator_appended = (uint8_t)appended;
            result->surface_cleared = e->measure ? 0u : 1u;
            result->pen_x = e->x;
            result->pen_y = e->y;
        }
    }
    free(canvas);
    free(e);
    free(work);
    return status;
}

const char *caption_status_string(int status)
{
    switch (status) {
    case CAPTION_OK: return "ok";
    case CAPTION_ERR_ARGUMENT: return "invalid argument";
    case CAPTION_ERR_FORMAT: return "malformed font or text-box data";
    case CAPTION_ERR_LIMIT: return "original buffer limit exceeded";
    case CAPTION_ERR_BOUNDS: return "drawing outside a surface";
    case CAPTION_ERR_FONT: return "font not loaded";
    case CAPTION_ERR_UNSUPPORTED: return "undefined or non-terminating original path";
    case CAPTION_ERR_BACKEND: return "caption backend failure";
    case CAPTION_ERR_TOO_LONG: return "framed text too long";
    default: return "unknown caption status";
    }
}
