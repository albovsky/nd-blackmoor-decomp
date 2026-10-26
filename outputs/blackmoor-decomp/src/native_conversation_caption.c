#include "native_conversation_caption.h"
#include "caption_layout_internal.h"
#include <limits.h>
#include <stdio.h>
#include <string.h>

static int16_t word(const uint8_t *p) { uint16_t u = (uint16_t)(p[0] | (uint16_t)p[1] << 8); int16_t v; memcpy(&v, &u, 2); return v; }
static int32_t dword(const uint8_t *p) { uint32_t u = (uint32_t)p[0] | (uint32_t)p[1]<<8 | (uint32_t)p[2]<<16 | (uint32_t)p[3]<<24; int32_t v; memcpy(&v, &u, 4); return v; }
typedef struct {
    const CaptionFonts *fonts;
    const CaptionPixelFormat *format;
    const CaptionSurface *sheet;
    CaptionSurface *target;
    CaptionGlobals *globals;
    const CaptionBackend *backend;
    int font_owned;
    int16_t font, color;
    int x, y, left, right;
    int pending, half, suppress, limit_y, first_y;
    uint32_t glyphs;
    int captions_enabled, open_choice, choice_count;
    NativeConversationChoice choices[CONVO3F_MAX_RESPONSES];
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
    size_t start = 0;
    if (!w->captions_enabled) {
        /* 0x41ea54 starts immediately after the first <o>, rather than
         * executing markup in the closed-caption prefix. */
        while (start + 2u < length && memcmp(text + start, "<o>", 3)) ++start;
        if (start + 2u >= length) return CAPTION_ERR_FORMAT;
        start += 3;
    }
    for (size_t at = start; at < length;) {
        const uint8_t *source = text;
        size_t pos = at;
        size_t available = length - at;
        if (source[pos] == '\\') { ++at; continue; }
        if (source[pos] == '>') return CAPTION_ERR_UNSUPPORTED;
        if (source[pos] != '<') {
            if (count + 1 >= sizeof buffer) return CAPTION_ERR_LIMIT;
            buffer[count++] = (char)source[pos]; buffer[count] = 0; ++at; continue;
        }
        const uint8_t *end = memchr(source + pos, '>', available);
        if (!end || end - (source + pos) < 2 || end - (source + pos) > 26) return CAPTION_ERR_FORMAT;
        const char tag = (char)source[pos + 1];
        char argument[25] = {0};
        size_t n = (size_t)(end - (source + pos + 2));
        memcpy(argument, source + pos + 2, n);
        at += (size_t)(end - (source + pos)) + 1u;
        if (tag == 'e') return CAPTION_OK; /* original stops without flushing */
        if (tag == 'i' || tag == 'o') {
            if (n) return CAPTION_ERR_UNSUPPORTED;
            continue;
        }
        if (tag == 's') {
            if (n < 2 || argument[0] < '0' || argument[0] > '9' || argument[1] < '0' || argument[1] > '9')
                return CAPTION_ERR_FORMAT;
            int index = 10 * (argument[0] - '0') + argument[1] - '0';
            if (index >= CONVO3F_MAX_RESPONSES || n - 2 >= sizeof w->choices[index].sound_name)
                return CAPTION_ERR_LIMIT;
            memcpy(w->choices[index].sound_name, argument + 2, n - 2);
            continue; /* s does not flush */
        }
        if (tag != 'c' && tag != 'n' && tag != 'w' && tag != 'h' && tag != 'f') return CAPTION_ERR_UNSUPPORTED;
        if ((tag == 'n' || tag == 'w') && w->suppress) { w->suppress = 0; continue; }
        int status = flush(w, buffer);
        if (status != CAPTION_OK) return status;
        count = 0; buffer[0] = 0;
        if (tag == 'h') {
            const int h = w->fonts->glyph_size[w->font][0][1];
            if (n) {
                if (w->open_choice >= 0 || n != 2 || argument[0] < '0' || argument[0] > '9' ||
                    argument[1] < '0' || argument[1] > '9') return CAPTION_ERR_UNSUPPORTED;
                int index = 10 * (argument[0] - '0') + argument[1] - '0';
                if (index != w->choice_count || index >= CONVO3F_MAX_RESPONSES) return CAPTION_ERR_LIMIT;
                w->open_choice = index; ++w->choice_count;
                w->choices[index].rect[0] = (int16_t)w->left;
                w->choices[index].rect[1] = (int16_t)(w->y - h);
            } else {
                if (w->open_choice < 0) return CAPTION_ERR_UNSUPPORTED;
                int16_t *r = w->choices[w->open_choice].rect;
                r[2] = (int16_t)w->right; r[3] = (int16_t)(w->y + h / 2);
                if (r[3] - r[1] < 6) {
                    r[1] = (int16_t)(r[1] - h / 2); r[3] = (int16_t)(r[3] + h / 2);
                    if (r[1] < w->first_y) r[1] = (int16_t)w->first_y;
                    if (r[3] > w->limit_y) r[3] = (int16_t)w->limit_y;
                }
                w->open_choice = -1;
            }
        } else if (tag == 'f') {
            /* 0x41ee13: flush above uses the OLD font, even for an empty
             * pending newline. atoi's low AX is an absolute font on BOTH
             * surfaces; neither pen nor color is reset. */
            const uint16_t bits = (uint16_t)(uint32_t)caption_internal_atoi(argument);
            int16_t next;
            memcpy(&next, &bits, sizeof next);
            if (next < 0 || next >= w->fonts->count || next >= (int)CAPTION_MAX_FONTS)
                return CAPTION_ERR_FONT;
            if (w->target) {
                status = caption_internal_release_font(w->fonts, w->globals, w->backend, w->font, 0);
                if (status != CAPTION_OK) return status;
                w->font_owned = 0;
                w->sheet = NULL;
            }
            w->font = next;
            if (w->target) {
                status = caption_internal_acquire_font(w->fonts, w->globals, w->backend, next, 0);
                if (status != CAPTION_OK) return status;
                w->font_owned = 1;
                w->sheet = &w->globals->sheets[next];
            }
        } else if (tag == 'c') {
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
    const CaptionBackend *backend, CaptionSurface surfaces[2], NativeConversationCaptionResult *result, int draw, int captions_enabled)
{
    if (!text || length > 14999 || memchr(text, 0, length) || !fonts || !geometry || !format || !result || (draw && (!globals || !backend || !surfaces)))
        return CAPTION_ERR_ARGUMENT;
    int in_marker = 0, out_marker = 0;
    for (size_t i = 0; i + 2 < length && i < 1500u; ++i) {
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
        Writer w = {0};
        w.fonts = fonts; w.format = format; w.font = (int16_t)font; w.color = word(t + 0x52);
        w.x = w.left = left; w.y = w.first_y = first_y; w.right = (int)right;
        w.limit_y = (int)limit_y; w.open_choice = -1; w.captions_enabled = captions_enabled;
        if (pass >= 2u) {
            w.target = &surfaces[i];
            const size_t rgb = 0x5cu + 3u * i;
            caption_internal_clear_surface(format, w.target, t[rgb], t[rgb + 1], t[rgb + 2]);
            int status = caption_internal_acquire_font(fonts, globals, backend, (int16_t)font, 0);
            if (status != CAPTION_OK) return status;
            w.sheet = &globals->sheets[font];
            w.globals = globals; w.backend = backend; w.font_owned = 1;
        }
        int status = write_one(&w, text, length);
        if (status == CAPTION_OK && w.open_choice != -1) status = CAPTION_ERR_FORMAT;
        int final_y = w.y + 3 * pad;
        if (status == CAPTION_OK && (final_y >= limit_y || final_y > INT16_MAX)) status = CAPTION_ERR_TOO_LONG;
        if (pass >= 2u && w.font_owned) {
            /* A switch may have released the initial font, or failed while
             * acquiring its replacement. Release only this pass's live ref. */
            const int released = caption_internal_release_font(fonts, globals, backend, w.font, 0);
            if (status == CAPTION_OK) status = released;
        }
        if (!draw || pass >= 2u) { r.glyphs[i] = w.glyphs; r.bottom[i] = (int16_t)final_y;
            if (i == 1) { r.response_count = (int16_t)w.choice_count; memcpy(r.choices, w.choices, sizeof r.choices); } }
        if (status != CAPTION_OK) return status;
    }
    const int viewport_bottom = dword(t + 0x0c);
    r.scroll_lines = (int16_t)(r.bottom[1] > viewport_bottom ? r.bottom[1] - viewport_bottom : 1);
    *result = r;
    return CAPTION_OK;
}


/* The original builder reserves 0x3a98 bytes, appends <w> after the caption
 * only with CC enabled, then numbered h/s tags and the eligible pool strings. */
static int build_text(const Convo3fLayoutRequest *request, int captions, uint8_t text[15000], size_t *length)
{
    if (!request || !request->caption || request->caption_length > 1499 ||
        memchr(request->caption, 0, request->caption_length) || request->response_count < 0 ||
        request->response_count > CONVO3F_MAX_RESPONSES || (request->response_count && !request->responses))
        return CAPTION_ERR_ARGUMENT;
    size_t used = request->caption_length;
    memcpy(text, request->caption, used);
    if (captions) { memcpy(text + used, "<w>", 3); used += 3; }
    for (int i = 0; i < request->response_count; ++i) {
        const Convo3fResponse *r = &request->responses[i];
        const uint8_t *end = memchr(r->text, 0, sizeof r->text);
        if (!end || !memchr(r->name, 0, sizeof r->name)) return CAPTION_ERR_FORMAT;
        char prefix[56];
        int n = snprintf(prefix, sizeof prefix, "%s<h%02d><s%02d%s>", i ? "<w>" : "", i, i, (const char *)r->name);
        size_t count = (size_t)(end - r->text);
        if (n < 0 || (size_t)n >= sizeof prefix || used + (size_t)n + count + 4u > 15000u)
            return CAPTION_ERR_LIMIT;
        memcpy(text + used, prefix, (size_t)n); used += (size_t)n;
        memcpy(text + used, r->text, count); used += count;
    }
    memcpy(text + used, "<e>", 4); *length = used + 3;
    return CAPTION_OK;
}
static int layout_choices(const Convo3fLayoutRequest *request, int captions,
    const CaptionFonts *fonts, const CaptionGeometry *geometry, const CaptionPixelFormat *format,
    CaptionGlobals *globals, const CaptionBackend *backend, CaptionSurface surfaces[2],
    NativeConversationCaptionResult *result, int draw)
{
    uint8_t text[15000]; size_t length = 0;
    int status = build_text(request, captions, text, &length);
    if (status != CAPTION_OK) return status;
    NativeConversationCaptionResult out = {0};
    status = write_caption(text, length, fonts, geometry, format, globals, backend, surfaces, &out, draw, captions);
    if (status != CAPTION_OK) return status;
    if (out.response_count != request->response_count) return CAPTION_ERR_UNSUPPORTED;
    *result = out;
    return CAPTION_OK;
}
int native_conversation_choices_validate(const Convo3fLayoutRequest *request, int captions,
    const CaptionFonts *fonts, const CaptionGeometry *geometry, const CaptionPixelFormat *format)
{
    NativeConversationCaptionResult out;
    return layout_choices(request, captions, fonts, geometry, format, NULL, NULL, NULL, &out, 0);
}
int native_conversation_choices_write(const Convo3fLayoutRequest *request, int captions,
    const CaptionFonts *fonts, const CaptionGeometry *geometry, const CaptionPixelFormat *format,
    CaptionGlobals *globals, const CaptionBackend *backend, CaptionSurface surfaces[2],
    NativeConversationCaptionResult *result)
{
    if (!result) return CAPTION_ERR_ARGUMENT;
    return layout_choices(request, captions, fonts, geometry, format, globals, backend, surfaces, result, 1);
}
int native_conversation_caption_validate(const uint8_t *text, size_t length,
    const CaptionFonts *fonts, const CaptionGeometry *geometry, const CaptionPixelFormat *format)
{
    const Convo3fLayoutRequest request = {0, text, length, 0, NULL, 0, 1};
    return native_conversation_choices_validate(&request, 1, fonts, geometry, format);
}
int native_conversation_caption_write(const uint8_t *text, size_t length,
    const CaptionFonts *fonts, const CaptionGeometry *geometry,
    const CaptionPixelFormat *format, CaptionGlobals *globals,
    const CaptionBackend *backend, CaptionSurface surfaces[2], NativeConversationCaptionResult *result)
{
    const Convo3fLayoutRequest request = {0, text, length, 0, NULL, 0, 1};
    return native_conversation_choices_write(&request, 1, fonts, geometry, format, globals, backend, surfaces, result);
}
