#include "native_conversation_caption.h"
#include "caption_layout_internal.h"
#include <limits.h>
#include <string.h>

static int16_t word(const uint8_t *p) { uint16_t u = (uint16_t)(p[0] | (uint16_t)p[1] << 8); int16_t v; memcpy(&v, &u, 2); return v; }
static int32_t dword(const uint8_t *p) { uint32_t u = (uint32_t)p[0] | (uint32_t)p[1]<<8 | (uint32_t)p[2]<<16 | (uint32_t)p[3]<<24; int32_t v; memcpy(&v, &u, 4); return v; }
typedef struct {
    const CaptionFonts *fonts;
    const CaptionPixelFormat *format;
    const CaptionSurface *sheet;
    CaptionSurface *target;
    int16_t font, color;
    int x, y, left, right;
    int pending, half, suppress, limit_y;
    uint32_t glyphs;
} Writer;

/* 0x41f5b1 consumes a pending newline even when the buffered text is empty.
 * Its width comparison is strict; a wrapped span retains the boundary space. */
static int flush(Writer *w, const char *text)
{
    size_t at = 0, length = strlen(text);
    do {
        if (w->pending) {
            int h = w->fonts->glyph_size[w->font][0][1];
            w->y += w->half ? (h + h / 9) / 2 : h + h / 9;
            w->half = 0; w->pending = 0;
            if (w->y >= w->limit_y) return CAPTION_ERR_TOO_LONG;
        }
        if (at == length) break;
        char line[1500] = {0};
        size_t count = 0, start = at;
        int16_t width = 0;
        while (w->x + width < w->right && at < length) {
            line[count++] = text[at++]; line[count] = 0;
            int status = caption_internal_text_width(w->fonts, w->font, line, &width);
            if (status != CAPTION_OK) return status;
        }
        int wrap = at < length;
        if (wrap) {
            if (!count) {
                if (w->x == w->left) return CAPTION_ERR_UNSUPPORTED;
                w->x = w->left; w->pending = 1; continue;
            }
            --count; --at; line[count] = 0;
            while (count > 0 && line[count] != ' ') { --count; --at; }
            if (line[count] != ' ') {
                if (w->x == w->left) return CAPTION_ERR_UNSUPPORTED;
                at = start; w->x = w->left; w->pending = 1; continue;
            }
            ++count; ++at; line[count] = 0;
        }
        if (at <= start || w->x < INT16_MIN || w->x > INT16_MAX || w->y < INT16_MIN || w->y > INT16_MAX)
            return CAPTION_ERR_LIMIT;
        uint32_t fills = 0;
        int status = caption_internal_draw_text(w->fonts, w->format, w->font,
            w->sheet, w->target, line, (int16_t)w->x, (int16_t)w->y, w->color, 0, 0, &w->glyphs, &fills);
        if (status != CAPTION_OK) return status;
        status = caption_internal_text_width(w->fonts, w->font, line, &width);
        if (status != CAPTION_OK) return status;
        w->x += width;
        if (wrap) { w->x = w->left; w->pending = 1; }
    } while (at < length);
    return CAPTION_OK;
}

static int write_one(Writer *w, const uint8_t *text, size_t length)
{
    char buffer[1500] = {0}; size_t count = 0;
    /* The original builder appends <w><e> after a caption when CC is enabled. */
    for (size_t at = 0; at < length + 6u;) {
        const uint8_t *source = at < length ? text : (const uint8_t *)"<w><e>";
        size_t pos = at < length ? at : at - length;
        size_t available = at < length ? length - at : length + 6u - at;
        if (source[pos] == '\\') { ++at; continue; }
        if (source[pos] == '>') return CAPTION_ERR_UNSUPPORTED;
        if (source[pos] != '<') {
            if (count + 1 >= sizeof buffer) return CAPTION_ERR_LIMIT;
            buffer[count++] = (char)source[pos]; buffer[count] = 0; ++at; continue;
        }
        const uint8_t *end = memchr(source + pos, '>', available);
        if (!end || end - (source + pos) < 2 || end - (source + pos) > 25) return CAPTION_ERR_FORMAT;
        const char tag = (char)source[pos + 1];
        char argument[25] = {0};
        size_t n = (size_t)(end - (source + pos + 2));
        memcpy(argument, source + pos + 2, n);
        at += (size_t)(end - (source + pos)) + 1u;
        if (tag == 'e') return CAPTION_OK; /* original stops without flushing */
        if (tag == 'i' || tag == 'o') { if (n) return CAPTION_ERR_UNSUPPORTED; continue; }
        if (tag != 'c' && tag != 'n' && tag != 'w') return CAPTION_ERR_UNSUPPORTED;
        if ((tag == 'n' || tag == 'w') && w->suppress) { w->suppress = 0; continue; }
        int status = flush(w, buffer);
        if (status != CAPTION_OK) return status;
        count = 0; buffer[0] = 0;
        if (tag == 'c') {
            const int32_t color = caption_internal_atoi(argument);
            if (color < 0 || color > INT16_MAX) return CAPTION_ERR_UNSUPPORTED;
            int32_t dx = 0, dy = 0;
            status = caption_internal_color_offsets(w->fonts, w->font, (int16_t)color, &dx, &dy);
            if (status != CAPTION_OK) return status;
            w->color = (int16_t)color; w->suppress = w->pending != 0;
        } else {
            if (n) return CAPTION_ERR_UNSUPPORTED;
            w->x = w->left; w->pending = 1;
            if (tag == 'w') w->half = 1;
        }
    }
    return CAPTION_ERR_FORMAT;
}

static int write_caption(const uint8_t *text, size_t length,
    const CaptionFonts *fonts, const CaptionGeometry *geometry,
    const CaptionPixelFormat *format, CaptionGlobals *globals,
    const CaptionBackend *backend, CaptionSurface surfaces[2], NativeConversationCaptionResult *result, int draw)
{
    if (!text || length > 1499 || memchr(text, 0, length) || !fonts || !geometry || !format || !result || (draw && (!globals || !backend || !surfaces)))
        return CAPTION_ERR_ARGUMENT;
    int in_marker = 0, out_marker = 0;
    for (size_t i = 0; i + 2 < length; ++i) {
        if (memcmp(text + i, "<i>", 3) == 0) in_marker = 1;
        if (memcmp(text + i, "<o>", 3) == 0) out_marker = 1;
    }
    if (!in_marker || !out_marker) return CAPTION_ERR_UNSUPPORTED;
    const uint8_t *t = geometry->tbox;
    const int left = word(t + 0x24);
    const int64_t right = (int64_t)dword(t + 0x18) - word(t + 0x26);
    const int first_y = word(t + 0x20), pad = word(t + 0x22);
    const int64_t limit_y = (int64_t)dword(t + 0x1c) - pad;
    int16_t selected[2] = {word(t + 0x54), word(t + 0x56)};
    NativeConversationCaptionResult r = {0};
    if (left < 0 || right <= left || right > geometry->framed_surface_width || first_y < 0 || pad < 0 || limit_y <= first_y || limit_y > geometry->framed_surface_height)
        return CAPTION_ERR_FORMAT;
    /* Dry layout precedes every acquire, clear or pixel write. */
    for (unsigned pass = 0; pass < (draw ? 4u : 2u); ++pass) {
        unsigned i = pass % 2u;
        const int font = selected[i];
        if (font < 0 || font >= fonts->count || font >= (int)CAPTION_MAX_FONTS) return CAPTION_ERR_FONT;
        if (draw && (surfaces[i].width != geometry->framed_surface_width ||
            surfaces[i].height != geometry->framed_surface_height || !surfaces[i].pixels || surfaces[i].pitch != surfaces[i].width * 2))
            return CAPTION_ERR_ARGUMENT;
        Writer w = {fonts, format, NULL, NULL, (int16_t)font, word(t + 0x52), left, first_y, left, (int)right, 0, 0, 0, (int)limit_y, 0};
        if (pass >= 2u) {
            w.target = &surfaces[i];
            const size_t rgb = 0x5cu + 3u * i;
            caption_internal_clear_surface(format, w.target, t[rgb], t[rgb + 1], t[rgb + 2]);
            int status = caption_internal_acquire_font(fonts, globals, backend, (int16_t)font, 0);
            if (status != CAPTION_OK) return status;
            w.sheet = &globals->sheets[font];
        }
        int status = write_one(&w, text, length);
        int final_y = w.y + 3 * pad;
        if (status == CAPTION_OK && (final_y >= limit_y || final_y > INT16_MAX)) status = CAPTION_ERR_TOO_LONG;
        if (pass >= 2u) {
            const int released = caption_internal_release_font(fonts, globals, backend, (int16_t)font, 0);
            if (status == CAPTION_OK) status = released;
        }
        if (!draw || pass >= 2u) { r.glyphs[i] = w.glyphs; r.bottom[i] = (int16_t)final_y; }
        if (status != CAPTION_OK) return status;
    }
    const int viewport_bottom = dword(t + 0x0c);
    r.scroll_lines = (int16_t)(r.bottom[1] > viewport_bottom ? r.bottom[1] - viewport_bottom : 1);
    *result = r;
    return CAPTION_OK;
}

int native_conversation_caption_validate(const uint8_t *text, size_t length,
    const CaptionFonts *fonts, const CaptionGeometry *geometry, const CaptionPixelFormat *format)
{
    NativeConversationCaptionResult result;
    return write_caption(text, length, fonts, geometry, format, NULL, NULL, NULL, &result, 0);
}
int native_conversation_caption_write(const uint8_t *text, size_t length,
    const CaptionFonts *fonts, const CaptionGeometry *geometry,
    const CaptionPixelFormat *format, CaptionGlobals *globals,
    const CaptionBackend *backend, CaptionSurface surfaces[2], NativeConversationCaptionResult *result)
{
    return write_caption(text, length, fonts, geometry, format, globals, backend, surfaces, result, 1);
}
