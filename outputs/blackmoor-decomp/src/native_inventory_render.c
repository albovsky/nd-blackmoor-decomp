#include "native_inventory_render.h"
#include <limits.h>
#include <string.h>

static uint32_t u32(const uint8_t *p)
{
    return (uint32_t)p[0] | (uint32_t)p[1] << 8 | (uint32_t)p[2] << 16 | (uint32_t)p[3] << 24;
}
static int32_t i32(const uint8_t *p)
{
    uint32_t bits = u32(p); int32_t value; memcpy(&value, &bits, sizeof value); return value;
}
static NativeInventoryRect rect(const uint8_t *p)
{
    NativeInventoryRect r = {i32(p), i32(p + 4), i32(p + 8), i32(p + 12)}; return r;
}
static int offset(NativeInventoryRect *r, int32_t x, int32_t y)
{
    int64_t v[4] = {(int64_t)r->left + x, (int64_t)r->top + y,
                    (int64_t)r->right + x, (int64_t)r->bottom + y};
    for (unsigned i = 0; i < 4; ++i) if (v[i] < INT32_MIN || v[i] > INT32_MAX) return 0;
    r->left = (int32_t)v[0]; r->top = (int32_t)v[1]; r->right = (int32_t)v[2]; r->bottom = (int32_t)v[3];
    return 1;
}
static int valid(NativeInventoryRect r, uint32_t w, uint32_t h)
{
    return r.left >= 0 && r.top >= 0 && r.right >= r.left && r.bottom >= r.top &&
           (uint32_t)r.right < w && (uint32_t)r.bottom < h;
}
static int name(const uint8_t *p, char out[33])
{
    const uint8_t *end = memchr(p, 0, 33);
    if (end == NULL || end == p) return 0;
    for (const uint8_t *c = p; c < end; ++c)
        if (*c < 32 || *c >= 127 || *c == '/' || *c == '\\') return 0;
    memset(out, 0, 33); memcpy(out, p, (size_t)(end - p)); return 1;
}
int native_inventory_names(const uint8_t *uiiv, size_t ub, const uint8_t *inv, size_t ib,
                           char frame[33], char items[33])
{
    if (!uiiv || !inv || !frame || !items || ub < INVVIEW_UIIV_BYTES || ib < INVVIEW_INV_BYTES)
        return NATIVE_INV_INVALID;
    return name(uiiv, frame) && name(inv + 2, items) ? NATIVE_INV_OK : NATIVE_INV_INVALID;
}
int native_inventory_close_control(const uint8_t *uiiv, size_t bytes, int32_t x, int32_t y,
                                   NativeInventoryClose *out)
{
    if (!uiiv || !out || bytes < INVVIEW_UIIV_BYTES) return NATIVE_INV_INVALID;
    NativeInventoryClose c = {0};
    c.enabled = u32(uiiv + 0x133) != 0;
    if (c.enabled) {
        const uint8_t *cfg = uiiv + 0x137;
        c.rectangle = rect(cfg + 0x96);
        if (u32(cfg + 0xa6) && !offset(&c.rectangle, x, y)) return NATIVE_INV_INVALID;
        if (!valid(c.rectangle, 640, 480)) return NATIVE_INV_INVALID;
        c.delay_ms = u32(cfg + 0xba);
        c.channel = (uint16_t)(uiiv[NATIVE_INV_CLOSE_SOUND + 0x21] |
                              (uint16_t)uiiv[NATIVE_INV_CLOSE_SOUND + 0x22] << 8);
    }
    *out = c; return NATIVE_INV_OK;
}
static int emit(NativeInventoryPlan *p, unsigned items, NativeInventoryRect src,
                NativeInventoryRect dst, uint32_t fw, uint32_t fh, uint32_t iw, uint32_t ih)
{
    if (p->count >= NATIVE_INV_BLITS || !valid(src, items ? iw : fw, items ? ih : fh) ||
        !valid(dst, 640, 480) || (int64_t)src.right - src.left != (int64_t)dst.right - dst.left ||
        (int64_t)src.bottom - src.top != (int64_t)dst.bottom - dst.top) return 0;
    NativeInventoryBlit b = {items, src, dst}; p->blits[p->count++] = b; return 1;
}
/* Shipped controls borrow the frame sheet for both art and restoration. */
static int control(const uint8_t *cfg, const char *frame, size_t transparency)
{
    char art[33], bg[33];
    return name(cfg, art) && name(cfg + 0x21, bg) && strcmp(art, frame) == 0 &&
           strcmp(bg, frame) == 0 && u32(cfg + transparency) == 0;
}
int native_inventory_plan(const uint8_t *u, size_t ub, const uint8_t *inv, size_t ib,
                          const InventoryView *v, const InventoryViewLayout *layout,
                          int32_t x, int32_t y, int close_state,
                          uint32_t fw, uint32_t fh, uint32_t iw, uint32_t ih,
                          NativeInventoryPlan *out)
{
    char frame[33], items[33];
    if (!v || !layout || !out || native_inventory_names(u, ub, inv, ib, frame, items) != NATIVE_INV_OK)
        return NATIVE_INV_INVALID;
    if ((v->mode != 2 && v->mode != 3) || v->tab != 100 || v->page != 0 || close_state < 0 || close_state > 3)
        return NATIVE_INV_UNSUPPORTED;
    NativeInventoryPlan plan = {0};
    NativeInventoryRect src = rect(u + 0x27), dst = rect(u + 0x47);
#define EMIT(which, a, b) do { if (!emit(&plan, (which), (a), (b), fw, fh, iw, ih)) return NATIVE_INV_INVALID; } while (0)
    if (u32(u + 0x67) && !offset(&dst, x, y)) return NATIVE_INV_INVALID;
    EMIT(0, src, dst);
    NativeInventoryClose close;
    if (native_inventory_close_control(u, ub, x, y, &close) != NATIVE_INV_OK) return NATIVE_INV_INVALID;
    if (close.enabled) {
        const uint8_t *cfg = u + 0x137;
        if (!control(cfg, frame, 0xb2)) return NATIVE_INV_UNSUPPORTED;
        EMIT(0, rect(cfg + 0x86), close.rectangle);
        EMIT(0, rect(cfg + 0x46 + (size_t)close_state * 16), close.rectangle);
    }
    if (u32(u + 0x226)) {
        const uint8_t *cfg = u + 0x22a;
        if (!control(cfg, frame, 0xbe)) return NATIVE_INV_UNSUPPORTED;
        dst = rect(cfg + 0x96);
        if (u32(cfg + 0xa6) && !offset(&dst, x, y)) return NATIVE_INV_INVALID;
        EMIT(0, rect(cfg + 0x86), dst);
        src = rect(cfg + 0x46);
        int64_t right = (int64_t)dst.left + src.right - src.left;
        int64_t bottom = (int64_t)dst.top + src.bottom - src.top;
        if (right > INT32_MAX || bottom > INT32_MAX || right < INT32_MIN || bottom < INT32_MIN)
            return NATIVE_INV_INVALID;
        dst.right = (int32_t)right; dst.bottom = (int32_t)bottom;
        EMIT(0, src, dst); /* page-zero thumb at the top of the vertical track */
    }
    int selected = -1;
    for (size_t i = 0; i < INVVIEW_PANELS; ++i) {
        const uint8_t *panel = u + 0x4f2 + i * 0xf7;
        if (!u32(panel)) continue;
        const uint8_t *cfg = panel + 8;
        if (!control(cfg, frame, 0xb2)) return NATIVE_INV_UNSUPPORTED;
        int chosen = i32(panel + 4) == v->tab;
        if (chosen) selected = (int)i;
        dst = rect(cfg + 0x96);
        if (u32(cfg + 0xa6) && !offset(&dst, x, y)) return NATIVE_INV_INVALID;
        EMIT(0, rect(cfg + (chosen ? 0x46 : 0x66)), dst);
        if (chosen) EMIT(0, rect(u + 0xabc + i * 16), rect(u + 0xb1c));
    }
    if (selected < 0) return NATIVE_INV_UNSUPPORTED;
    for (size_t i = 0; i < INVVIEW_SLOTS; ++i) {
        dst.left = layout->rect[i][0]; dst.top = layout->rect[i][1];
        dst.right = layout->rect[i][2]; dst.bottom = layout->rect[i][3];
        const int id = v->slot_item[i];
        if (id == -1) { EMIT(0, rect(u + 0x2f0 + i * 16), dst); }
        else {
            if (id < 0 || id >= (int)INVVIEW_ITEMS) return NATIVE_INV_INVALID;
            src = rect(inv + 0xb1 + (size_t)id * 0x16d + (v->slot_lit[i] == 1 ? 0x46 : 0x36));
            EMIT(1, src, dst);
        }
    }
#undef EMIT
    *out = plan; return NATIVE_INV_OK;
}
