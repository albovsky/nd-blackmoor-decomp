#include "autotext_writer.h"

#include <stdlib.h>
#include <string.h>

#include "caption_layout_internal.h"

/* 0x43 body-prefix offsets (see autotext_writer.h). */
#define ENT_MODE 0x00
#define ENT_SURFACE 0x02
#define ENT_FONT 0x04
#define ENT_COLOR 0x06
#define ENT_LEFT 0x08
#define ENT_TOP 0x0a
#define ENT_WIDTH 0x0c
#define ENT_HEIGHT 0x0e
#define ENT_PICTURE_COUNT 0x31
#define ENT_PICTURE_TABLE 0x33

/* FONT record fields (relative to 0x5a4c24 + font * 0x7f3). */
#define FONT_UPPER_BASE 0x53
#define FONT_GLYPH_RECTS 0xc3

/* Largest pending-text index that still leaves a NUL inside the 40000-byte
 * buffer ([ebp-0x9c9c..-0x5c) is followed by the tag letter). */
#define TEXT_LAST_INDEX (AUTOTEXT_TEXT_BUFFER_BYTES - 2u)
/* The tag argument buffer is 25 bytes; keep its NUL inside. */
#define TAG_LAST_INDEX (AUTOTEXT_TAG_BUFFER_BYTES - 2u)
/* The flusher's source index is a 16-bit local ([ebp-0xc]). */
#define SOURCE_LIMIT 32767
/* Outer flusher iterations without progress before native gives up. */
#define FLUSH_ITERATION_LIMIT 100000u

static uint8_t sim_marker;

typedef struct engine {
    const CaptionFonts *fonts;
    const CaptionPixelFormat *format;
    const AutotextBackend *backend;
    CaptionBackend sheet_backend;
    int simulate;
    AutotextOwner *owner;
    AutotextGlobals *globals;
    CaptionGlobals *fontg;
    AutotextOwner owner_copy;
    AutotextGlobals globals_copy;
    CaptionGlobals fontg_copy;
    uint8_t entry[AUTOTEXT_ENTRY_BYTES];
    uint8_t *caller_entry;
    int16_t font;
    int16_t color;
    int16_t cw;         /* width of "o" in the current font ([ebp-0x44]) */
    int16_t width_arg;  /* entry +0xc ([ebp-0x9ccc]) */
    int16_t height_arg; /* [ebp-0x9ce8] */
    int16_t x;          /* [ebp-8] */
    int16_t y;          /* [ebp-0x20] */
    int16_t line;       /* [ebp-0x48] */
    int16_t last_pic_line; /* [ebp-0x9cf4] */
    int16_t max_x;      /* [ebp-0x9cf0] */
    int16_t k;          /* [ebp-0x9cc4]: shared by marks, <H> and <L> */
    int k_valid;
    int newline_pending; /* [ebp-0x54] */
    int stop;            /* [ebp-0x24] */
    int debug;
    AutotextRect *rects;
    size_t rect_capacity;
    size_t rect_used;
    int16_t *rect_count;
    int16_t acquired[CAPTION_MAX_FONTS];
    int overlay_loaded_here;
    size_t text_len;
    char *text;
    char *line_buf;
    AutotextResult result;
} Engine;

static int16_t s16(int32_t value)
{
    return (int16_t)(uint16_t)(uint32_t)value;
}

static int16_t ent16(const Engine *e, size_t offset)
{
    return (int16_t)(uint16_t)(e->entry[offset] | ((uint16_t)e->entry[offset + 1u] << 8));
}

static int32_t ent32(const Engine *e, size_t offset)
{
    return (int32_t)((uint32_t)e->entry[offset] | ((uint32_t)e->entry[offset + 1u] << 8) |
                     ((uint32_t)e->entry[offset + 2u] << 16) |
                     ((uint32_t)e->entry[offset + 3u] << 24));
}

static int32_t rec32(const uint8_t *record, size_t offset)
{
    return (int32_t)((uint32_t)record[offset] | ((uint32_t)record[offset + 1u] << 8) |
                     ((uint32_t)record[offset + 2u] << 16) |
                     ((uint32_t)record[offset + 3u] << 24));
}

static int16_t rec16(const uint8_t *record, size_t offset)
{
    return (int16_t)(uint16_t)(record[offset] | ((uint16_t)record[offset + 1u] << 8));
}

static int32_t wadd(int32_t a, int32_t b)
{
    return (int32_t)((uint32_t)a + (uint32_t)b);
}

static int32_t wsub(int32_t a, int32_t b)
{
    return (int32_t)((uint32_t)a - (uint32_t)b);
}

static int font_valid(const Engine *e, int16_t font)
{
    return font >= 0 && font < e->fonts->count;
}

/* Caption statuses share their numbering with AutotextWriteStatus except for the
 * framed "too long" result, which the AUTOTEXT writer never produces. */
static int map_caption(int status)
{
    return status == CAPTION_ERR_TOO_LONG ? AUTOTEXT_WRITE_ERR_LIMIT : status;
}

static int text_width(const Engine *e, const char *text, int16_t *width)
{
    return map_caption(caption_internal_text_width(e->fonts, e->font, text, width));
}

static void trace(const Engine *e, int kind, const char *text, int32_t a, int32_t b,
                  int32_t c, int32_t d, const int32_t rects[8])
{
    if (!e->simulate && e->backend->trace != NULL) {
        e->backend->trace(e->backend->context, kind, text, a, b, c, d, rects);
    }
}

/* ---- surfaces ---------------------------------------------------------- */

/* The original addresses surface words linearly (pixels + row * pitch +
 * column * 2) without clipping; only addresses outside pitch * height are
 * rejected here. */
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

/* 0x4c5b3a: colour-keyed copy of the source rectangle (left, top, right,
 * bottom, inclusive) to the destination's left/top. */
static int blit_keyed(const Engine *e, const CaptionSurface *src, const int32_t s[4],
                      CaptionSurface *dst, const int32_t d[4])
{
    int64_t rows = (int64_t)s[3] - s[1] + 1;
    int64_t columns = (int64_t)s[2] - s[0] + 1;
    int64_t row;
    int64_t column;

    for (row = 0; row < rows; ++row) {
        for (column = 0; column < columns; ++column) {
            const uint8_t *from = word_at(src, (int64_t)s[1] + row, (int64_t)s[0] + column);
            uint8_t *to;
            uint16_t word;

            if (from == NULL) {
                return AUTOTEXT_WRITE_ERR_BOUNDS;
            }
            word = (uint16_t)(from[0] | (from[1] << 8));
            if (word == e->format->color_key) {
                continue;
            }
            to = word_at(dst, (int64_t)d[1] + row, (int64_t)d[0] + column);
            if (to == NULL) {
                return AUTOTEXT_WRITE_ERR_BOUNDS;
            }
            to[0] = (uint8_t)word;
            to[1] = (uint8_t)(word >> 8);
        }
    }
    return AUTOTEXT_WRITE_OK;
}

static int blit(Engine *e, const CaptionSurface *src, const int32_t s[4], const int32_t d[4],
                const char *name)
{
    int32_t rects[8];

    if (src == NULL || src->pixels == NULL || e->owner->target.pixels == NULL) {
        /* The original blits from or to a null surface (0x4c5b3a faults, or in
         * debug mode reports and quits). */
        return AUTOTEXT_WRITE_ERR_UNSUPPORTED;
    }
    if (e->simulate) {
        return AUTOTEXT_WRITE_OK;
    }
    memcpy(rects, s, 4u * sizeof(int32_t));
    memcpy(rects + 4, d, 4u * sizeof(int32_t));
    trace(e, AUTOTEXT_TRACE_BLIT, name, 0, 0, 0, 0, rects);
    return blit_keyed(e, src, s, &e->owner->target, d);
}

static int acquire_font(Engine *e, int16_t font)
{
    int status;

    if (!font_valid(e, font)) {
        return AUTOTEXT_WRITE_ERR_FONT;
    }
    if (e->simulate) {
        status = caption_internal_acquire_font(e->fonts, e->fontg, &e->sheet_backend, font, 1);
    } else {
        status = caption_internal_acquire_font(e->fonts, e->fontg, &e->sheet_backend, font, 0);
    }
    if (status != CAPTION_OK) {
        return status == CAPTION_ERR_BACKEND ? AUTOTEXT_WRITE_ERR_BACKEND : AUTOTEXT_WRITE_ERR_FONT;
    }
    if (!e->simulate) {
        ++e->acquired[font];
    }
    return AUTOTEXT_WRITE_OK;
}

static void release_font(Engine *e, int16_t font)
{
    if (!e->simulate && e->acquired[font] > 0) {
        --e->acquired[font];
    }
    (void)caption_internal_release_font(e->fonts, e->fontg, &e->sheet_backend, font, e->simulate);
}

static int draw_text(Engine *e, const char *text)
{
    const CaptionSurface *sheet = &e->fontg->sheets[e->font];

    trace(e, AUTOTEXT_TRACE_DRAW, text, e->font, e->x, e->y, e->color, NULL);
    return map_caption(caption_internal_draw_text(
        e->fonts, e->format, e->font, sheet, e->simulate ? NULL : &e->owner->target, text, e->x,
        e->y, e->color, e->owner->underline != 0, e->owner->underline_color,
        &e->result.glyphs_drawn, &e->result.underline_fills));
}

/* ---- FUN_00412db8: line flusher ---------------------------------------- */

static int flush(Engine *e)
{
    int32_t count = 0;
    int32_t source = 0;
    int wrapped = 0;
    uint32_t iterations = 0u;
    int status = AUTOTEXT_WRITE_OK;

    memset(e->line_buf, 0, AUTOTEXT_LINE_BUFFER_BYTES);
    ++e->result.flushes;
    trace(e, AUTOTEXT_TRACE_FLUSH, e->text, e->font, e->x, e->y, e->line, NULL);
    for (;;) {
        if (++iterations > FLUSH_ITERATION_LIMIT) {
            return AUTOTEXT_WRITE_ERR_UNSUPPORTED; /* the original does not terminate */
        }
        if (e->newline_pending != 0) {
            int16_t h = e->fonts->glyph_size[e->font][0][1];

            if (e->owner->tight_spacing != 0) {
                e->y = s16(e->y + h);
            } else if (e->owner->half_spacing != 0) {
                e->y = s16(e->y + s16((h / 9 + h) / 2));
                e->owner->half_spacing = 0;
            } else {
                e->y = s16(e->y + s16(h + h / 9));
            }
            if (e->y >= e->height_arg) {
                if (e->debug) {
                    if (!e->simulate && e->backend->debug_log != NULL) {
                        e->backend->debug_log(e->backend->context, AUTOTEXT_DEBUG_TOO_MUCH_TEXT);
                    }
                }
                break;
            }
            e->newline_pending = 0;
        }
        if (e->text_len == 0u) {
            break;
        }
        for (;;) {
            int16_t width;

            status = text_width(e, e->line_buf, &width);
            if (status != AUTOTEXT_WRITE_OK) {
                return status;
            }
            if ((int32_t)e->x + width >= (int32_t)e->width_arg || e->text[source] == '\0') {
                break;
            }
            if (count >= (int32_t)AUTOTEXT_LINE_BUFFER_BYTES - 2 || source >= SOURCE_LIMIT) {
                return AUTOTEXT_WRITE_ERR_LIMIT;
            }
            e->line_buf[count++] = e->text[source++];
        }
        if (e->text[source] != '\0') {
            --count;
            --source;
            if (count >= 0) {
                e->line_buf[count] = '\0';
            }
            while (count >= 0 && e->line_buf[count] != ' ') {
                --count;
                --source;
            }
            ++count;
            ++source;
            e->line_buf[count] = '\0';
            wrapped = 1;
        }
        if (e->line_buf[0] != '\0') {
            int16_t width;

            status = draw_text(e, e->line_buf);
            if (status != AUTOTEXT_WRITE_OK) {
                return status;
            }
            status = text_width(e, e->line_buf, &width);
            if (status != AUTOTEXT_WRITE_OK) {
                return status;
            }
            e->x = s16(e->x + width);
        }
        if (wrapped) {
            wrapped = 0;
            e->x = e->owner->left_margin;
            e->newline_pending = 1;
        }
        memset(e->line_buf, 0, AUTOTEXT_LINE_BUFFER_BYTES);
        count = 0;
        if (e->text[source] == '\0') {
            break;
        }
    }
    memset(e->text, 0, AUTOTEXT_TEXT_BUFFER_BYTES);
    e->text_len = 0u;
    return AUTOTEXT_WRITE_OK;
}

/* ---- tags --------------------------------------------------------------- */

static int hotspot_ok(const Engine *e)
{
    return e->k >= 0 && (size_t)e->k < AUTOTEXT_HOTSPOT_RECORDS;
}

/* Digit tags 1-5 and 7: entry mark. */
static int tag_mark(Engine *e, char tag)
{
    int32_t dst[4];
    int32_t src[4];
    int32_t mark_width;
    int status;

    e->k = s16(((int32_t)tag - '0') - 1);
    if ((int32_t)e->k + 1 == 7) {
        e->k = 0;
    }
    e->k_valid = 1;
    if ((size_t)e->k >= AUTOTEXT_MARK_RECORDS) {
        return AUTOTEXT_WRITE_ERR_LIMIT;
    }
    memcpy(src, e->globals->mark_rects[e->k], sizeof(src));
    if (e->line == 0) {
        e->y = ent16(e, ENT_TOP);
        dst[1] = (int32_t)e->y + e->cw - 9;
    } else {
        dst[1] = (int32_t)e->y - 1;
    }
    dst[3] = wsub(wadd(dst[1], src[3]), src[1]);
    dst[0] = e->x;
    dst[2] = wsub(wadd(dst[0], src[2]), src[0]);
    if (e->globals->mark_sheet.pixels == NULL) {
        return AUTOTEXT_WRITE_ERR_UNSUPPORTED;
    }
    status = blit(e, &e->globals->mark_sheet, src, dst, "Drawing entry mark");
    if (status != AUTOTEXT_WRITE_OK) {
        return status;
    }
    ++e->result.marks_drawn;
    if (e->rects != NULL) {
        if (e->rect_used >= e->rect_capacity) {
            return AUTOTEXT_WRITE_ERR_LIMIT;
        }
        if (!e->simulate) {
            AutotextRect *out = &e->rects[e->rect_used];

            out->left = dst[0];
            out->top = dst[1];
            out->right = dst[2];
            out->bottom = dst[3];
            *e->rect_count = s16((int32_t)*e->rect_count + 1);
        }
        ++e->rect_used;
    }
    mark_width = wsub(src[2], src[0]);
    e->x = s16((int32_t)e->x + wadd(mark_width, 3));
    status = flush(e);
    if (status != AUTOTEXT_WRITE_OK) {
        return status;
    }
    if (e->line == 0) {
        e->y = s16((int32_t)e->y + wsub(dst[3], dst[1]));
    }
    return AUTOTEXT_WRITE_OK;
}

static int tag_underline(Engine *e)
{
    int status;

    if (e->owner->underline == 0) {
        const uint8_t *record = e->fonts->records[e->font];
        int16_t glyph = rec16(record, FONT_UPPER_BASE);
        int32_t dx;
        int32_t dy;
        size_t rect;

        if (glyph < 0 || glyph >= (int16_t)CAPTION_FONT_GLYPHS) {
            return AUTOTEXT_WRITE_ERR_FORMAT;
        }
        status = caption_internal_color_offsets(e->fonts, e->font, e->color, &dx, &dy);
        if (status != CAPTION_OK) {
            return AUTOTEXT_WRITE_ERR_UNSUPPORTED;
        }
        rect = FONT_GLYPH_RECTS + (size_t)glyph * 16u;
        if (!e->simulate) {
            uint16_t found = 0u;

            status = caption_internal_scan_color(
                e->format, &e->fontg->sheets[e->font], wadd(rec32(record, rect), dx),
                wadd(rec32(record, rect + 4u), dy), wadd(rec32(record, rect + 8u), dx),
                wadd(rec32(record, rect + 12u), dy), &found);
            if (status != CAPTION_OK) {
                return AUTOTEXT_WRITE_ERR_BOUNDS;
            }
            e->owner->underline_color = found;
        }
        status = flush(e);
        if (status != AUTOTEXT_WRITE_OK) {
            return status;
        }
        e->owner->underline = 1;
    } else {
        status = flush(e);
        if (status != AUTOTEXT_WRITE_OK) {
            return status;
        }
        e->owner->underline = 0;
    }
    return AUTOTEXT_WRITE_OK;
}

/* Returns 1 for <e> (stop), AUTOTEXT_WRITE_OK to continue or an error. */
static int dispatch(Engine *e, uint8_t tag, const char *argument)
{
    int status;

    switch (tag) {
    case '1': case '2': case '3': case '4': case '5': case '7':
        status = tag_mark(e, (char)tag);
        return status;
    case 'H': {
        AutotextHotspot *spot;

        e->max_x = 0;
        e->k = (int16_t)caption_internal_atoi(argument);
        e->k_valid = 1;
        if (!hotspot_ok(e)) {
            return AUTOTEXT_WRITE_ERR_LIMIT;
        }
        spot = &e->owner->hotspots[e->k];
        spot->x_start = e->x;
        spot->y_start = e->line == 0 ? 0 : (int32_t)e->y;
        spot->x_start = e->x;
        return AUTOTEXT_WRITE_OK;
    }
    case 'L': {
        AutotextHotspot *spot;

        if (!e->k_valid) {
            return AUTOTEXT_WRITE_ERR_UNSUPPORTED; /* [ebp-0x9cc4] is uninitialised */
        }
        if (!hotspot_ok(e)) {
            return AUTOTEXT_WRITE_ERR_LIMIT;
        }
        spot = &e->owner->hotspots[e->k];
        spot->y_end = e->y;
        if ((int32_t)e->max_x > spot->x_end) {
            spot->x_end = e->max_x;
        }
        return AUTOTEXT_WRITE_OK;
    }
    case 'c':
        status = flush(e);
        if (status != AUTOTEXT_WRITE_OK) {
            return status;
        }
        e->color = (int16_t)caption_internal_atoi(argument);
        return AUTOTEXT_WRITE_OK;
    case 'e':
        e->stop = 1;
        return AUTOTEXT_WRITE_OK;
    case 'f': {
        int16_t font;

        status = flush(e);
        if (status != AUTOTEXT_WRITE_OK) {
            return status;
        }
        font = (int16_t)caption_internal_atoi(argument);
        if (!font_valid(e, font)) {
            return AUTOTEXT_WRITE_ERR_FONT;
        }
        release_font(e, e->font);
        e->font = font;
        status = acquire_font(e, font);
        if (status != AUTOTEXT_WRITE_OK) {
            return status;
        }
        status = text_width(e, "o", &e->cw);
        if (status != AUTOTEXT_WRITE_OK) {
            return status;
        }
        if (e->line == 0 && e->last_pic_line != 0) {
            e->y = s16((int32_t)ent16(e, ENT_TOP) + (int32_t)e->cw * 2);
        } else if (e->line == 0 && e->last_pic_line == 0) {
            e->y = s16((int32_t)e->y + ((int32_t)ent16(e, ENT_TOP) + (int32_t)e->cw * 2));
        }
        e->owner->left_margin = s16((int32_t)ent16(e, ENT_LEFT) + e->cw);
        return AUTOTEXT_WRITE_OK;
    }
    case 'l':
        status = flush(e);
        if (status != AUTOTEXT_WRITE_OK) {
            return status;
        }
        e->owner->tight_spacing = e->owner->tight_spacing == 0 ? 1 : 0;
        return AUTOTEXT_WRITE_OK;
    case 'n':
    case 'w':
        status = flush(e);
        if (status != AUTOTEXT_WRITE_OK) {
            return status;
        }
        if (e->max_x < e->x) {
            e->max_x = e->x;
        }
        e->newline_pending = 1;
        if (tag == 'w') {
            e->owner->half_spacing = 1;
        }
        e->line = s16((int32_t)e->line + 1);
        return AUTOTEXT_WRITE_OK;
    case 'r': {
        int16_t width;

        status = text_width(e, e->text, &width);
        if (status != AUTOTEXT_WRITE_OK) {
            return status;
        }
        e->x = s16((int32_t)e->width_arg - width);
        status = flush(e);
        if (status != AUTOTEXT_WRITE_OK) {
            return status;
        }
        e->newline_pending = 1;
        e->line = s16((int32_t)e->line + 1);
        return AUTOTEXT_WRITE_OK;
    }
    case 't':
        /* strcat(text, &[ebp-0x1c]): the source is a zeroed local, so the
         * tab tag appends nothing. */
        return AUTOTEXT_WRITE_OK;
    case 'u':
        return tag_underline(e);
    default:
        return AUTOTEXT_WRITE_OK;
    }
}

/* ---- pictures ----------------------------------------------------------- */

static void picture_src(const Engine *e, int16_t index, int32_t src[4])
{
    size_t base = ENT_PICTURE_TABLE + (size_t)index * AUTOTEXT_PICTURE_RECORD_BYTES + 2u;

    src[0] = ent32(e, base);
    src[1] = ent32(e, base + 4u);
    src[2] = ent32(e, base + 8u);
    src[3] = ent32(e, base + 12u);
}

static int16_t picture_line(const Engine *e, int16_t index)
{
    return ent16(e, ENT_PICTURE_TABLE + (size_t)index * AUTOTEXT_PICTURE_RECORD_BYTES);
}

static int picture_blit(Engine *e, int32_t dst[4], const int32_t src[4])
{
    if (e->owner->overlay.pixels == NULL) {
        return AUTOTEXT_WRITE_ERR_UNSUPPORTED;
    }
    ++e->result.pictures_drawn;
    return blit(e, &e->owner->overlay, src, dst, "Autotext picture");
}

/* 0x413629..0x4137d4: pictures whose line equals the current line. */
static int pictures_at_line(Engine *e)
{
    int16_t index;
    int16_t count = ent16(e, ENT_PICTURE_COUNT);

    for (index = 0; index < count; ++index) {
        int32_t src[4];
        int32_t dst[4];
        int status;

        if (e->line != picture_line(e, index)) {
            continue;
        }
        if (e->line == 0) {
            e->y = ent16(e, ENT_TOP);
        }
        picture_src(e, index, src);
        dst[1] = (int32_t)e->y + e->cw;
        dst[3] = wsub(wadd(dst[1], src[3]), src[1]);
        dst[0] = e->x;
        dst[2] = wsub(wadd(dst[0], src[2]), src[0]);
        status = picture_blit(e, dst, src);
        if (status != AUTOTEXT_WRITE_OK) {
            return status;
        }
        if (e->line == 0) {
            e->y = s16((int32_t)e->y + wadd(wsub(dst[3], dst[1]), (int32_t)e->cw * 3));
        } else {
            e->y = s16((int32_t)e->y + wadd(wsub(dst[3], dst[1]), (int32_t)e->cw * 2));
        }
    }
    e->last_pic_line = e->line;
    e->owner->left_margin = s16((int32_t)ent16(e, ENT_LEFT) + e->cw);
    e->x = e->owner->left_margin;
    return AUTOTEXT_WRITE_OK;
}

/* 0x4142a2..0x4143b6: remaining pictures after the text. */
static int pictures_tail(Engine *e)
{
    int16_t index;
    int16_t count = ent16(e, ENT_PICTURE_COUNT);

    for (index = 0; index < count; ++index) {
        int32_t src[4];
        int32_t dst[4];
        int status;

        if (e->line > picture_line(e, index)) {
            continue;
        }
        picture_src(e, index, src);
        dst[1] = (int32_t)e->y + e->cw;
        dst[3] = wsub(wadd(dst[1], src[3]), src[1]);
        dst[0] = e->x;
        dst[2] = wsub(wadd(dst[0], src[2]), src[0]);
        status = picture_blit(e, dst, src);
        if (status != AUTOTEXT_WRITE_OK) {
            return status;
        }
        e->y = s16((int32_t)e->y + wadd(wsub(dst[3], dst[1]), (int32_t)e->cw));
    }
    return AUTOTEXT_WRITE_OK;
}

/* ---- surfaces of the slot table ---------------------------------------- */

static int create_slot_surface(Engine *e, int index)
{
    CaptionSurface *slot = &e->globals->slots[index];

    if (e->width_arg <= 0 || e->height_arg <= 0) {
        return AUTOTEXT_WRITE_ERR_FORMAT; /* the original allocates a negative size */
    }
    if (e->width_arg > 16383 ||
        (size_t)e->width_arg * (size_t)e->height_arg * 2u > AUTOTEXT_MAX_SURFACE_BYTES) {
        return AUTOTEXT_WRITE_ERR_LIMIT; /* pitch is a 16-bit word; native size cap */
    }
    if (e->simulate) {
        if (e->backend->create_surface == NULL) {
            return AUTOTEXT_WRITE_ERR_UNSUPPORTED;
        }
        slot->pixels = &sim_marker;
        slot->width = e->width_arg;
        slot->height = e->height_arg;
        slot->pitch = s16((int32_t)e->width_arg * 2);
    } else {
        CaptionSurface made;

        memset(&made, 0, sizeof(made));
        if (e->backend->create_surface(e->backend->context, e->width_arg, e->height_arg,
                                       AUTOTEXT_SURFACE_NAME, &made) != AUTOTEXT_BACKEND_OK ||
            made.pixels == NULL || made.width != e->width_arg ||
            made.height != e->height_arg || made.pitch != s16((int32_t)e->width_arg * 2)) {
            return AUTOTEXT_WRITE_ERR_BACKEND;
        }
        *slot = made;
    }
    e->result.surface_created = 1u;
    return AUTOTEXT_WRITE_OK;
}

static void free_slot_surface(Engine *e, int index)
{
    CaptionSurface *slot = &e->globals->slots[index];

    if (!e->simulate) {
        e->backend->free_surface(e->backend->context, index, slot);
    }
    memset(slot, 0, sizeof(*slot));
}

static void free_overlay(Engine *e)
{
    if (e->owner->overlay.pixels != NULL) {
        if (!e->simulate) {
            e->backend->free_surface(e->backend->context, -1, &e->owner->overlay);
        }
        memset(&e->owner->overlay, 0, sizeof(e->owner->overlay));
    }
}

/* ---- FUN_00413187 ------------------------------------------------------- */

static int run(Engine *e, const char *text, size_t length)
{
    AutotextOwner *owner = e->owner;
    uint8_t tag = 0;
    int have_tag_letter = 0;
    int tag_seen = 0;
    int in_tag = 0;
    char argument[AUTOTEXT_TAG_BUFFER_BYTES + 1u];
    size_t argument_length = 0u;
    const char *p = text;
    size_t i;
    int status;
    int16_t picture_count;

    /* 0x4131e2..0x41321b, 0x413221: state words and the rect count. */
    owner->underline = 0;
    owner->underline_color = 0u;
    owner->tight_spacing = 0;
    owner->half_spacing = 0;
    if (!e->simulate && e->rect_count != NULL) {
        *e->rect_count = 0;
    }
    e->font = ent16(e, ENT_FONT);
    e->color = ent16(e, ENT_COLOR);
    if (!font_valid(e, e->font)) {
        return AUTOTEXT_WRITE_ERR_FONT;
    }
    e->width_arg = ent16(e, ENT_WIDTH);
    e->height_arg = s16((int32_t)ent16(e, ENT_HEIGHT) + 0x14);
    status = text_width(e, "o", &e->cw);
    if (status != AUTOTEXT_WRITE_OK) {
        return status;
    }
    e->y = s16((int32_t)ent16(e, ENT_TOP) + (int32_t)e->cw * 2);
    owner->left_margin = s16((int32_t)ent16(e, ENT_LEFT) + e->cw);
    e->x = owner->left_margin;
    owner->surface_index = ent16(e, ENT_SURFACE);
    if (owner->overlay.pixels != NULL && e->backend->free_surface == NULL) {
        return AUTOTEXT_WRITE_ERR_UNSUPPORTED; /* the overlay is freed at exit */
    }
    if (e->width_arg == 0) {
        return AUTOTEXT_WRITE_ERR_FORMAT; /* idiv by zero */
    }
    {
        int16_t needed = s16(((int32_t)length * 0x90) / (int32_t)e->width_arg);

        if (e->height_arg < needed) {
            e->height_arg = needed;
        }
    }
    if (owner->surface_index < 0 || owner->surface_index >= (int16_t)AUTOTEXT_SURFACE_SLOTS) {
        return AUTOTEXT_WRITE_ERR_SURFACE_INDEX;
    }
    {
        int index = owner->surface_index;
        CaptionSurface *slot = &e->globals->slots[index];

        if (slot->pixels == NULL) {
            status = create_slot_surface(e, index);
        } else {
            if (slot->width <= 0 || slot->height <= 0 || slot->pitch < slot->width * 2) {
                return AUTOTEXT_WRITE_ERR_ARGUMENT;
            }
            status = AUTOTEXT_WRITE_OK;
            if ((int32_t)e->height_arg > slot->height || (int32_t)e->width_arg > slot->width) {
                if (e->backend->free_surface == NULL) {
                    return AUTOTEXT_WRITE_ERR_UNSUPPORTED;
                }
                free_slot_surface(e, index);
                status = create_slot_surface(e, index);
            }
        }
        if (status != AUTOTEXT_WRITE_OK) {
            return status;
        }
        owner->target = *slot;
    }

    /* 0x4134d2..0x41354f: overlay picture surface. */
    picture_count = ent16(e, ENT_PICTURE_COUNT);
    if (picture_count > 0) {
        const uint8_t *name = e->entry + AUTOTEXT_ENTRY_NAME_OFFSET;
        const uint8_t *name_end = (const uint8_t *)memchr(name, 0, AUTOTEXT_ENTRY_NAME_BYTES);

        if (name_end == NULL) {
            return AUTOTEXT_WRITE_ERR_FORMAT; /* strlen runs into the picture count */
        }
        if (name_end != name && owner->overlay.pixels == NULL) {
            if (e->simulate) {
                if (e->backend->load_overlay == NULL || e->backend->free_surface == NULL) {
                    return AUTOTEXT_WRITE_ERR_UNSUPPORTED;
                }
                owner->overlay.pixels = &sim_marker;
            } else {
                CaptionSurface loaded;

                memset(&loaded, 0, sizeof(loaded));
                if (e->backend->load_overlay(e->backend->context, (const char *)name,
                                             &loaded) != AUTOTEXT_BACKEND_OK ||
                    loaded.pixels == NULL) {
                    return AUTOTEXT_WRITE_ERR_BACKEND;
                }
                owner->overlay = loaded;
                e->overlay_loaded_here = 1;
                e->result.overlay_loaded = 1u;
            }
            if (picture_count > AUTOTEXT_PICTURE_CLAMP) {
                e->entry[ENT_PICTURE_COUNT] = (uint8_t)AUTOTEXT_PICTURE_CLAMP;
                e->entry[ENT_PICTURE_COUNT + 1u] = 0u;
                if (!e->simulate) {
                    e->caller_entry[ENT_PICTURE_COUNT] = (uint8_t)AUTOTEXT_PICTURE_CLAMP;
                    e->caller_entry[ENT_PICTURE_COUNT + 1u] = 0u;
                }
            }
            owner->pictures_seen = 1;
        }
    }
    picture_count = ent16(e, ENT_PICTURE_COUNT);
    if (owner->pictures_seen != 0 && picture_count > 0 &&
        (size_t)picture_count > AUTOTEXT_PICTURE_LIMIT) {
        return AUTOTEXT_WRITE_ERR_FORMAT; /* the table would extend past the prefix */
    }

    /* 0x41355f..0x4135aa: clear the surface, take the font. */
    if (!e->simulate) {
        if (ent16(e, ENT_MODE) == 2) {
            caption_internal_clear_surface(e->format, &owner->target, 0u, 0x1fu, 0u);
        } else {
            caption_internal_clear_surface(e->format, &owner->target, 0u, 0u, 0u);
        }
    }
    status = acquire_font(e, e->font);
    if (status != AUTOTEXT_WRITE_OK) {
        return status;
    }

    memset(e->text, 0, AUTOTEXT_TEXT_BUFFER_BYTES);
    e->text_len = 0u;
    memset(argument, 0, sizeof(argument));
    e->line = 0;
    e->last_pic_line = -1;
    e->max_x = 0;
    e->newline_pending = 0;
    e->stop = 0;

    for (i = 0u; i < length; ++i, ++p) {
        char c;

        if (owner->pictures_seen != 0 && e->line != e->last_pic_line) {
            status = pictures_at_line(e);
            if (status != AUTOTEXT_WRITE_OK) {
                return status;
            }
        }
        c = *p;
        if (c == '\0') {
            /* unreachable: the loop is bounded by strlen */
        } else if (c == '<') {
            in_tag = 1;
            have_tag_letter = 0;
        } else if (c == '>') {
            in_tag = 0;
            if (!tag_seen) {
                return AUTOTEXT_WRITE_ERR_UNSUPPORTED; /* dispatches on an uninitialised byte */
            }
            status = dispatch(e, tag, argument);
            if (status != AUTOTEXT_WRITE_OK) {
                return status;
            }
            memset(argument, 0, sizeof(argument));
            argument_length = 0u;
        } else if (in_tag && !have_tag_letter) {
            tag = (uint8_t)c;
            have_tag_letter = 1;
            tag_seen = 1;
        } else if (in_tag) {
            if (argument_length > TAG_LAST_INDEX) {
                return AUTOTEXT_WRITE_ERR_LIMIT; /* spills into the neighbouring locals */
            }
            argument[argument_length++] = c;
        } else {
            if (e->text_len > TEXT_LAST_INDEX) {
                return AUTOTEXT_WRITE_ERR_LIMIT;
            }
            e->text[e->text_len++] = c;
        }
        if (e->newline_pending != 0) {
            owner->left_margin = s16((int32_t)ent16(e, ENT_LEFT) + e->cw);
            e->x = owner->left_margin;
        }
        if (e->stop) {
            e->result.stopped_by_e = 1u;
            break;
        }
    }

    /* 0x4141ff..0x414405. */
    owner->left_margin = s16((int32_t)ent16(e, ENT_LEFT) + e->cw);
    e->x = owner->left_margin;
    if (e->text_len != 0u) {
        status = flush(e);
        if (status != AUTOTEXT_WRITE_OK) {
            return status;
        }
    }
    if (owner->pictures_seen != 0) {
        status = pictures_tail(e);
        if (status != AUTOTEXT_WRITE_OK) {
            return status;
        }
    }
    owner->final_y[owner->surface_index] = e->y;
    release_font(e, e->font);
    free_overlay(e);
    e->result.lines = e->line;
    e->result.final_x = e->x;
    e->result.final_y = e->y;
    return AUTOTEXT_WRITE_OK;
}

int autotext_write(const CaptionFonts *fonts, const CaptionPixelFormat *format,
                   AutotextOwner *owner, AutotextGlobals *globals,
                   CaptionGlobals *font_state, const AutotextBackend *backend,
                   uint8_t *entry, const char *text, size_t text_capacity,
                   AutotextRect *rects, size_t rect_capacity, int16_t *rect_count,
                   AutotextResult *result)
{
    Engine *e;
    const void *nul;
    size_t length;
    int pass;
    int status = AUTOTEXT_WRITE_OK;

    if (result != NULL) {
        memset(result, 0, sizeof(*result));
    }
    if (fonts == NULL || format == NULL || owner == NULL || globals == NULL ||
        font_state == NULL || backend == NULL || entry == NULL || text == NULL ||
        result == NULL || (rects != NULL && rect_count == NULL)) {
        return AUTOTEXT_WRITE_ERR_ARGUMENT;
    }
    nul = memchr(text, 0, text_capacity);
    if (nul == NULL) {
        return AUTOTEXT_WRITE_ERR_ARGUMENT;
    }
    length = (size_t)((const char *)nul - text);
    if (backend->load_font_sheet == NULL || backend->release_font_sheet == NULL) {
        return AUTOTEXT_WRITE_ERR_UNSUPPORTED;
    }
    e = (Engine *)malloc(sizeof(*e));
    if (e == NULL) {
        return AUTOTEXT_WRITE_ERR_LIMIT;
    }
    e->text = (char *)malloc(AUTOTEXT_TEXT_BUFFER_BYTES);
    e->line_buf = (char *)malloc(AUTOTEXT_LINE_BUFFER_BYTES);
    if (e->text == NULL || e->line_buf == NULL) {
        free(e->text);
        free(e->line_buf);
        free(e);
        return AUTOTEXT_WRITE_ERR_LIMIT;
    }
    for (pass = 0; pass < 2; ++pass) {
        char *text_buffer = e->text;
        char *line_buffer = e->line_buf;

        memset(e, 0, sizeof(*e));
        e->text = text_buffer;
        e->line_buf = line_buffer;
        e->fonts = fonts;
        e->format = format;
        e->backend = backend;
        e->sheet_backend.context = backend->context;
        e->sheet_backend.load_font_sheet = backend->load_font_sheet;
        e->sheet_backend.release_font_sheet = backend->release_font_sheet;
        e->simulate = pass == 0;
        e->debug = globals->debug_mode != 0;
        e->rects = rects;
        e->rect_capacity = rect_capacity;
        e->rect_count = rect_count;
        e->caller_entry = entry;
        memcpy(e->entry, entry, AUTOTEXT_ENTRY_BYTES);
        if (pass == 0) {
            e->owner_copy = *owner;
            e->globals_copy = *globals;
            e->fontg_copy = *font_state;
            e->owner = &e->owner_copy;
            e->globals = &e->globals_copy;
            e->fontg = &e->fontg_copy;
        } else {
            e->owner = owner;
            e->globals = globals;
            e->fontg = font_state;
        }
        status = run(e, text, length);
        if (status != AUTOTEXT_WRITE_OK) {
            if (!e->simulate) {
                int16_t font;

                /* Pass 2 failed after host-visible effects: nothing is rolled
                 * back; only this call's font references and overlay are
                 * released so no handle or count is left behind. */
                for (font = 0; font < (int16_t)CAPTION_MAX_FONTS; ++font) {
                    while (e->acquired[font] > 0) {
                        release_font(e, font);
                    }
                }
                if (e->overlay_loaded_here) {
                    free_overlay(e);
                }
            }
            break;
        }
        if (!e->simulate) {
            *result = e->result;
        }
    }
    free(e->text);
    free(e->line_buf);
    free(e);
    return status;
}

const char *autotext_write_status_string(int status)
{
    switch (status) {
    case AUTOTEXT_WRITE_OK: return "ok";
    case AUTOTEXT_WRITE_ERR_ARGUMENT: return "invalid argument";
    case AUTOTEXT_WRITE_ERR_FORMAT: return "malformed entry or font data";
    case AUTOTEXT_WRITE_ERR_LIMIT: return "original buffer or table limit exceeded";
    case AUTOTEXT_WRITE_ERR_BOUNDS: return "drawing outside a surface";
    case AUTOTEXT_WRITE_ERR_FONT: return "font not loaded";
    case AUTOTEXT_WRITE_ERR_UNSUPPORTED: return "undefined or non-terminating original path";
    case AUTOTEXT_WRITE_ERR_BACKEND: return "autotext backend failure";
    case AUTOTEXT_WRITE_ERR_SURFACE_INDEX: return "invalid AUTOTEXT surface index";
    default: return "unknown autotext status";
    }
}
