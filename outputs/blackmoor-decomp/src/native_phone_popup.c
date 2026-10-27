#include "native_phone_popup.h"

#include <limits.h>
#include <string.h>

/* Static recovery of GAME.EXE afd337a2...485c45:0x4e3093,0x4e4cb6,
 *0x4e3a64,0x4e6658 and0x4ee86f. REA batch02240 evidence
 *ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763,
 * corroborated against the immutable original and committed mnemonic assembly.
 * This is a bounded native reconstruction and host composition plan, not
 * original source, original execution evidence or complete phone UI parity. */

static uint16_t u16(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | (uint16_t)((uint16_t)p[1] << 8));
}

static uint32_t u32(const uint8_t *p)
{
    return (uint32_t)p[0] | (uint32_t)p[1] << 8 |
           (uint32_t)p[2] << 16 | (uint32_t)p[3] << 24;
}

static int32_t i32(const uint8_t *p)
{
    uint32_t bits = u32(p);
    int32_t value;
    memcpy(&value, &bits, sizeof value);
    return value;
}

static int asset_name(const uint8_t *p, char out[33], int allow_empty)
{
    const uint8_t *end = memchr(p, 0, 33);
    if (end == NULL || (!allow_empty && end == p)) return 0;
    for (const uint8_t *c = p; c < end; ++c) {
        if (*c < 32 || *c >= 127 || *c == '/' || *c == '\\') return 0;
    }
    memset(out, 0, 33);
    memcpy(out, p, (size_t)(end - p));
    return 1;
}

int native_phone_popup_assets(const uint8_t *u, size_t bytes,
    char base[33], char extras[33], uint8_t pickup[NATIVE_PHONE_SOUND_BYTES])
{
    char b[33], e[33], name[33];
    uint8_t sound[NATIVE_PHONE_SOUND_BYTES];
    if (u == NULL || base == NULL || extras == NULL || pickup == NULL)
        return NATIVE_PHONE_ARGUMENT;
    if (bytes < NATIVE_PHONE_UICL_MIN_BYTES || !asset_name(u, b, 0) ||
        !asset_name(u + 0x2f0, e, 0) || !asset_name(u + 0xd5d, name, 1))
        return NATIVE_PHONE_FORMAT;
    /*0x4e498d copies the full template first, then only the terminated name.
     * Trailing bytes after the terminator remain from the template. */
    memcpy(sound, u + 0x3ae, sizeof sound);
    memcpy(sound, name, strlen(name) + 1u);
    if (u16(sound + 0x21) >= 32u) return NATIVE_PHONE_FORMAT;
    memcpy(base, b, sizeof b);
    memcpy(extras, e, sizeof e);
    memcpy(pickup, sound, sizeof sound);
    return NATIVE_PHONE_OK;
}

static int complete_host(const NativePhoneHost *h)
{
    return h != NULL && h->open != NULL && h->transition_ready != NULL &&
           h->sound_prepare != NULL && h->sound_play != NULL &&
           h->sound_busy != NULL && h->sound_unload != NULL &&
           h->request_transition != NULL && h->close != NULL;
}

int native_phone_popup_open(NativePhonePopup *p, Action80Object *a,
    NativePhoneWorld *w, const uint8_t *u, size_t bytes, const NativePhoneHost *h)
{
    char base[33], extras[33];
    NativePhonePopup next;
    int status;
    if (p == NULL || a == NULL || w == NULL) return NATIVE_PHONE_ARGUMENT;
    if (p->active || a->state_4528 != 0 || a->word_6b2 == 9999 ||
        w->unavailable_5a1e58 != 0 || w->cells.cell_583204 != 5 ||
        w->cells.cell_5bb22a != 0) return NATIVE_PHONE_UNSUPPORTED;
    if (!complete_host(h)) return NATIVE_PHONE_UNSUPPORTED;
    memset(&next, 0, sizeof next);
    status = native_phone_popup_assets(u, bytes, base, extras, next.pickup);
    if (status != NATIVE_PHONE_OK) return status;
    if (h->open(h->context) != 0) return NATIVE_PHONE_HOST;
    next.active = 1;
    next.requested_mode = 2; /*0x4e3525(2), preserve currentmode0 until Process */
    *p = next;
    return NATIVE_PHONE_OK;
}

static int close_popup(NativePhonePopup *p, Action80Object *a,
    NativePhoneWorld *w, const NativePhoneHost *h, NativePhoneResult *r)
{
    if (h->close(h->context) != 0) return NATIVE_PHONE_HOST;
    a->state_4528 = 0;  /*0x4e2dd3, called by0x4e2faa */
    a->word_6b2 = 9999; /*0x4e305d;65d2 is reset by next mode0, not here */
    w->cells.cell_583204 = 0;
    w->cells.cell_5bb22a = 0;
    p->requested_mode = 0;
    p->active = 0;
    p->pickup_loaded = 0;
    r->event = NATIVE_PHONE_EVENT_CLOSED;
    r->redraw = 1; /*0x4d36ed */
    return NATIVE_PHONE_OK;
}

static int process_step(NativePhonePopup *p, Action80Object *a,
    NativePhoneWorld *w, const NativePhoneHost *h, NativePhoneResult *r)
{
    int ready = 0, playing = 0;
    uint16_t channel;
    if (p == NULL || a == NULL || w == NULL || r == NULL)
        return NATIVE_PHONE_ARGUMENT;
    memset(r, 0, sizeof *r);
    if (!complete_host(h) || !p->active || w->unavailable_5a1e58 != 0 ||
        w->cells.cell_583204 != 5 || w->cells.cell_5bb22a != 0 ||
        p->requested_mode != 2) return NATIVE_PHONE_UNSUPPORTED;

    /* Mode0 and4 break; mode5 alone falls through into the stable mode2.
     * Host readiness replaces the platform transition boundary, not its time. */
    switch (a->state_4528) {
    case 0:
    case 4:
        if (h->transition_ready(h->context, &ready) != 0 ||
            (ready != 0 && ready != 1)) return NATIVE_PHONE_HOST;
        if (a->state_4528 == 0) {
            a->dword_4530 = 0;
            a->dword_65d2 = 0;
        }
        a->state_4528 = ready ? 5 : 4;
        r->event = NATIVE_PHONE_EVENT_WAIT_OPEN;
        return NATIVE_PHONE_OK;
    case 5:
        a->state_4528 = p->requested_mode;
        r->redraw = 1;
        break;
    case 2:
        break;
    default:
        return NATIVE_PHONE_UNSUPPORTED;
    }

    switch (a->dword_4530) {
    case 0:
        if (a->dword_65d2 != 0) return close_popup(p, a, w, h, r);
        if (a->word_6b2 == 9999) return NATIVE_PHONE_UNSUPPORTED;
        if (p->pickup[0] == 0 || strcmp((const char *)p->pickup, "NO SOUND") == 0) {
            a->dword_4530 = 6;
            return NATIVE_PHONE_OK;
        }
        channel = u16(p->pickup + 0x21);
        if (h->sound_prepare(h->context, p->pickup, sizeof p->pickup) != 0)
            return NATIVE_PHONE_HOST;
        if (h->sound_play(h->context, channel) != 0) return NATIVE_PHONE_HOST;
        p->pickup_loaded = 1;
        a->dword_4530 = 5;
        r->event = NATIVE_PHONE_EVENT_PICKUP_STARTED;
        return NATIVE_PHONE_OK;
    case 5:
        if (!p->pickup_loaded) return NATIVE_PHONE_UNSUPPORTED;
        channel = u16(p->pickup + 0x21);
        if (h->sound_busy(h->context, channel, &playing) != 0 ||
            (playing != 0 && playing != 1)) return NATIVE_PHONE_HOST;
        if (playing) return NATIVE_PHONE_OK;
        if (h->sound_unload(h->context, p->pickup, sizeof p->pickup) != 0)
            return NATIVE_PHONE_HOST;
        p->pickup_loaded = 0;
        a->dword_4530 = 6;
        r->event = NATIVE_PHONE_EVENT_PICKUP_FINISHED;
        return NATIVE_PHONE_OK;
    case 6: {
        SceneTransitionRequest request;
        if (a->word_6b2 == 9999) return NATIVE_PHONE_UNSUPPORTED;
        memset(&request, 0, sizeof request);
        request.target_scene = a->word_6b2;
        request.opaque_words[2] = 1;
        request.opaque_dwords[2] = 1;
        /*0x4e3a64: the duplicate6c6 write is original;6ca is untouched.
         * Raw0x80 reads6ba as return scene, never the saved6b8 word. */
        p->saved_current_scene_6b8 = (int16_t)(uint16_t)w->cells.scene_5bb57b;
        a->scene_6ba = (int16_t)(uint16_t)w->cells.scene_5bb57f;
        a->word_6bc = w->frame_5bb50b;
        a->word_6be = w->vertical_5bb593;
        a->dword_6c2 = w->dword_5bb5a7;
        a->dword_6c6 = w->dword_5bb5ab;
        a->dword_6c6 = w->dword_5bb5af;
        if (h->request_transition(h->context, &request) != 0)
            return NATIVE_PHONE_HOST;
        w->cells.scene_5bb57b = request.target_scene;
        w->cells.word_5bb599 = 0;
        w->cells.word_5bb595 = 0;
        w->cells.word_5c39ff = 1;
        w->cells.dword_5bb59b = 0;
        w->cells.dword_5bb59f = 0;
        w->cells.dword_5bb5a3 = 1;
        w->cells.engine_mode_583999 = 4;
        w->cells.cell_583204 = 0;
        w->cells.cell_5bb22a = 1;
        a->dword_4530 = 0;
        r->event = NATIVE_PHONE_EVENT_CALL_REQUESTED;
        return NATIVE_PHONE_OK;
    }
    default:
        return NATIVE_PHONE_UNSUPPORTED;
    }
}

int native_phone_popup_process(NativePhonePopup *p, Action80Object *a,
    NativePhoneWorld *w, const NativePhoneHost *h, NativePhoneResult *r)
{
    NativePhonePopup next_popup;
    Action80Object next_object;
    NativePhoneWorld next_world;
    NativePhoneResult result;
    int status;
    if (p == NULL || a == NULL || w == NULL || r == NULL)
        return NATIVE_PHONE_ARGUMENT;
    next_popup = *p;
    next_object = *a;
    next_world = *w;
    status = process_step(&next_popup, &next_object, &next_world, h, &result);
    if (status != NATIVE_PHONE_OK) return status;
    *p = next_popup;
    *a = next_object;
    *w = next_world;
    *r = result;
    return NATIVE_PHONE_OK;
}

static NativePhoneRect rect_at(const uint8_t *p)
{
    NativePhoneRect r = {i32(p), i32(p + 4), i32(p + 8), i32(p + 12)};
    return r;
}

static int offset_rect(NativePhoneRect *r, int64_t x, int64_t y)
{
    int64_t v[4] = {(int64_t)r->left + x, (int64_t)r->top + y,
                    (int64_t)r->right + x, (int64_t)r->bottom + y};
    for (unsigned i = 0; i < 4; ++i)
        if (v[i] < INT32_MIN || v[i] > INT32_MAX) return 0;
    r->left = (int32_t)v[0]; r->top = (int32_t)v[1];
    r->right = (int32_t)v[2]; r->bottom = (int32_t)v[3];
    return 1;
}

static int valid_rect(NativePhoneRect r, uint32_t width, uint32_t height)
{
    return r.left >= 0 && r.top >= 0 && r.right >= r.left && r.bottom >= r.top &&
           (uint32_t)r.right < width && (uint32_t)r.bottom < height;
}

static int emit(NativePhonePlan *p, unsigned sheet, NativePhoneRect source,
    NativePhoneRect destination, const uint32_t widths[2], const uint32_t heights[2])
{
    if (p->count == NATIVE_PHONE_MAX_BLITS || sheet > 1 ||
        !valid_rect(source, widths[sheet], heights[sheet]) ||
        !valid_rect(destination, 640, 480) ||
        (int64_t)source.right - source.left != (int64_t)destination.right - destination.left ||
        (int64_t)source.bottom - source.top != (int64_t)destination.bottom - destination.top)
        return 0;
    NativePhoneBlit b = {sheet, source, destination};
    p->blits[p->count++] = b;
    return 1;
}

int native_phone_popup_plan(const NativePhonePopup *p, const Action80Object *a,
    const NativePhoneWorld *w, const uint8_t *u, size_t bytes,
    int32_t x, int32_t y, uint32_t bw, uint32_t bh, uint32_t ew, uint32_t eh,
    NativePhonePlan *out)
{
    const uint32_t widths[2] = {bw, ew}, heights[2] = {bh, eh};
    NativePhonePlan plan = {0};
    NativePhoneRect source, destination;
    char base[33], extras[33];
    uint8_t pickup[NATIVE_PHONE_SOUND_BYTES];
    if (p == NULL || a == NULL || w == NULL || u == NULL || out == NULL)
        return NATIVE_PHONE_ARGUMENT;
    if (!p->active || (a->state_4528 == 0 || a->state_4528 == 4 || a->state_4528 == 5)) {
        *out = plan;
        return NATIVE_PHONE_OK;
    }
    if (a->state_4528 != 2 || w->unavailable_5a1e58 != 0 ||
        (w->cells.cell_5bb22a == 0 &&
         (w->cells.cell_583204 != 5 || (a->dword_4530 != 5 && a->dword_4530 != 6))))
        return NATIVE_PHONE_UNSUPPORTED;
    if (w->cells.cell_5bb22a != 0 && a->dword_4530 != 0)
        return NATIVE_PHONE_UNSUPPORTED;
    int status = native_phone_popup_assets(u, bytes, base, extras, pickup);
    if (status != NATIVE_PHONE_OK) return status;
#define EMIT(sheet, src, dst) do { if (!emit(&plan, (sheet), (src), (dst), widths, heights)) return NATIVE_PHONE_FORMAT; } while (0)
    source = rect_at(u + 0x27);
    destination = rect_at(u + 0x47);
    if (u32(u + 0x67) && !offset_rect(&destination, x, y)) return NATIVE_PHONE_FORMAT;
    EMIT(NATIVE_PHONE_SHEET_BASE, source, destination);
    /* The generic popup's opaque stock close button uses its named sheet,
     * which is the extras sheet in the actual UICL. Its opaque state0 art
     * covers its full restore rectangle, so one transfer suffices here. */
    if (u32(u + 0x133)) {
        const uint8_t *cfg = u + 0x137;
        char art[33];
        unsigned sheet;
        if (!asset_name(cfg, art, 0)) return NATIVE_PHONE_FORMAT;
        if (strcmp(art, base) == 0) sheet = NATIVE_PHONE_SHEET_BASE;
        else if (strcmp(art, extras) == 0) sheet = NATIVE_PHONE_SHEET_EXTRAS;
        else return NATIVE_PHONE_UNSUPPORTED;
        if (u32(cfg + 0xb2) != 0) return NATIVE_PHONE_UNSUPPORTED;
        source = rect_at(cfg + 0x46);
        destination = rect_at(cfg + 0x96);
        if (u32(cfg + 0xa6) && !offset_rect(&destination, x, y)) return NATIVE_PHONE_FORMAT;
        if (source.bottom != source.top) EMIT(sheet, source, destination);
    }
    /*0x4e6658's empty-screen restore:EA0..EA8 and F50, with source
     * origin719/71d AND VIEW origin subtracted, destinations absolute. */
    destination = rect_at(u + 0x7ce);
    destination.bottom = i32(u + 0x87e);
    source = destination;
    if (!offset_rect(&source, -(int64_t)i32(u + 0x47) - x,
                              -(int64_t)i32(u + 0x4b) - y)) return NATIVE_PHONE_FORMAT;
    EMIT(NATIVE_PHONE_SHEET_BASE, source, destination);
    if (w->cells.cell_5bb22a != 0) {
        /* State0 status art remains visible even when the call scene owns
         * screen0/2. Signal and welcome, keypad and connecting art are skipped. */
        EMIT(NATIVE_PHONE_SHEET_EXTRAS,
             rect_at(u + (w->battery_5a1e54 == 0 ? 0x923 : 0x933)), rect_at(u + 0x943));
        EMIT(NATIVE_PHONE_SHEET_EXTRAS, rect_at(u + 0x862), rect_at(u + 0x872));
        EMIT(NATIVE_PHONE_SHEET_EXTRAS, rect_at(u + 0x882), rect_at(u + 0x892));
    } else {
        /*0x4e49e2/4e35e8 leave controls0..15 at state0,16..25 disabled4.
         * Actual template normal art is empty for the first15 keys. Other
         * templates would require an expanded keypad renderer, so refuse. */
        NativePhoneRect key_normal = rect_at(u + 0x2f0 + 0x46);
        if (key_normal.bottom != key_normal.top || u32(u + 0x2f0 + 0xb2) != 0)
            return NATIVE_PHONE_UNSUPPORTED;
        EMIT(NATIVE_PHONE_SHEET_EXTRAS, rect_at(u + 0x8a2), rect_at(u + 0x8c2));
        if (a->dword_4530 == 6)
            EMIT(NATIVE_PHONE_SHEET_EXTRAS, rect_at(u + 0x973), rect_at(u + 0x983));
        EMIT(NATIVE_PHONE_SHEET_EXTRAS, rect_at(u + 0x993), rect_at(u + 0x9b3));
    }
#undef EMIT
    plan.visible = 1;
    *out = plan;
    return NATIVE_PHONE_OK;
}
