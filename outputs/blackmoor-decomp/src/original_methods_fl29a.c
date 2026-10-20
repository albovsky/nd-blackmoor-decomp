#include "original_methods_fl29a.h"

#include <string.h>

static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* host memory behind an original address (writable: the host owns the memory; the interface only says const) */
static uint8_t *res(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    const uintptr_t a[2] = {a0, a1};
    return callv(host, callee, this_ptr, a, 2);
}

static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    const uintptr_t a[3] = {a0, a1, a2};
    return callv(host, callee, this_ptr, a, 3);
}

static uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3)
{
    const uintptr_t a[4] = {a0, a1, a2, a3};
    return callv(host, callee, this_ptr, a, 4);
}

static uint32_t call5(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3, uintptr_t a4)
{
    const uintptr_t a[5] = {a0, a1, a2, a3, a4};
    return callv(host, callee, this_ptr, a, 5);
}

/* ---- 0x4d39f9 find_free_entry ---------------------------------------------------------------------------------------------------- */
int32_t m4d39f9_find_free_entry(const Fl29aWorld *world, const Fl18Host *host)
{
    int16_t i;
    for (i = 0x18; i <= 0x3f; i++)
        if (rd32(world->table_5d15a5, (ptrdiff_t)i * 0x4a + 4) == 0) return i;
    call3(host, 0x52139c, 0, 0x55a448, 0, 0);
    call0(host, 0x4c97b4, 0x5cf659);
    return -1;
}

/* ---- 0x4c4202 check_vtable_call -------------------------------------------------------------------------------------------------- */
void m4c4202_check_vtable_call(const uint8_t *self, uint32_t obj, uint32_t arg, const Fl18Host *host)
{
    uint32_t vtable, entry, hr, text;
    if (obj == rd32(self, 0xc)) return;
    vtable = rd32(res(host, obj), 0);
    entry = rd32(res(host, vtable + 0x80), 0);
    hr = call2(host, entry, vtable, obj, arg);
    if (hr == 0) return;
    text = call1(host, 0x4c88c7, (uintptr_t)self, hr);
    call2(host, 0x42639d, 0x583979, 0x5543f0, text);
    call0(host, 0x4c97b4, (uintptr_t)self);
}

/* ---- 0x4c948f find_free_slot ----------------------------------------------------------------------------------------------------- */
int32_t m4c948f_find_free_slot(const uint8_t *self, const Fl18Host *host)
{
    int16_t i;
    for (i = 0; i < 0x18; i++)
        if (rd32(self, 0xc72 + (ptrdiff_t)i * 4) == 0) return i;
    call3(host, 0x52139c, 0, 0x557ae4, 0, 0);
    call0(host, 0x4c97b4, (uintptr_t)self);
    return -1;
}

/* ---- 0x4d3992 clear_entry -------------------------------------------------------------------------------------------------------- */
void m4d3992_clear_entry(uint32_t index, const Fl29aWorld *world, const Fl18Host *host)
{
    int32_t i = (int16_t)index;
    if (i < 0 || i >= 0x58) {
        call3(host, 0x50ca3e, 0, 0x63888b, 0x55a400, (uint32_t)i);
        call3(host, 0x52139c, 0, 0x63888b, 0, 0);
        call0(host, 0x4c97b4, 0x5cf659);
    }
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 0);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a + 4, 0);
}

/* ---- 0x4c92c5 count_down --------------------------------------------------------------------------------------------------------- */
void m4c92c5_count_down(uint32_t index, const Fl29aWorld *world, const Fl18Host *host)
{
    int32_t i = (int16_t)index;
    uint8_t *words = world->words_5afbda;
    if (rd32(world->dwords_5d032f, (ptrdiff_t)i * 4) != 0) {
        wr16(words, (ptrdiff_t)i * 2, (uint16_t)(rd16(words, (ptrdiff_t)i * 2) - 1));
        if (rds16(words, (ptrdiff_t)i * 2) == 0)
            call1(host, 0x4c2dfb, 0x5cf659, 0x5d032fu + (uint32_t)i * 4u);
    }
    if (rds16(words, (ptrdiff_t)i * 2) < 0) wr16(words, (ptrdiff_t)i * 2, 0);
}

/* ---- 0x4c9340 scan_surface ------------------------------------------------------------------------------------------------------- */
int32_t m4c9340_scan_surface(const uint8_t *self, uint32_t surface, uint32_t rect, const Fl29aWorld *world, const Fl18Host *host)
{
    const uint8_t *s, *r;
    uint32_t pitch, p, bpp;
    int32_t rows, bytes, i, j;
    if (surface == 0) return 0;
    s = res(host, surface);
    r = res(host, rect);
    pitch = (uint32_t)rds16(s, 0x2f);
    bpp = (uint32_t)(int32_t)world->word_639895;
    p = rd32(s, 0) + rd32(r, 4) * pitch + rd32(r, 0) * bpp;
    rows = (int32_t)(rd32(r, 0xc) - rd32(r, 4) + 1);
    bytes = (int32_t)((rd32(r, 8) - rd32(r, 0) + 1) * bpp);
    for (i = 0; i < rows; i++) {
        for (j = 0; j < bytes; j = (int32_t)((uint32_t)j + 2)) {
            uint16_t v = rd16(res(host, p + (uint32_t)j), 0);
            if (v != rd16(self, 0x38d0)) return v;
        }
        p += pitch;
    }
    return 0;
}

/* ---- 0x4c46d1 fill_surface ------------------------------------------------------------------------------------------------------- */
void m4c46d1_fill_surface(const uint8_t *self, uint32_t surface, uint32_t r, uint32_t g, uint32_t b, const Fl18Host *host)
{
    uint8_t rr = (uint8_t)((uint8_t)r & self[0x38c6]);
    uint8_t gg = (uint8_t)((uint8_t)g & self[0x38c5]);
    uint8_t bb = (uint8_t)((uint8_t)b & self[0x38c4]);
    uint32_t colour;
    uint16_t pixel;
    int32_t i;
    if (self[0x38ca] != 5) rr = (uint8_t)(rr << 1);
    if (self[0x38c9] != 5) gg = (uint8_t)(gg << 1);
    if (self[0x38c8] != 5) bb = (uint8_t)(bb << 1);
    colour = ((uint32_t)rr << (self[0x38c2] & 31u)) | ((uint32_t)gg << (self[0x38c1] & 31u)) | ((uint32_t)bb << (self[0x38c0] & 31u));
    pixel = (uint16_t)colour;
    for (i = 0;; i++) {
        const uint8_t *s = res(host, surface);
        if (i >= (int32_t)((uint32_t)rds16(s, 0x2b) * (uint32_t)rds16(s, 0x2d))) break;
        wr16(res(host, rd32(s, 0) + (uint32_t)i * 2u), 0, pixel);
    }
}

/* ---- 0x4cb9d1 relocate_entries --------------------------------------------------------------------------------------------------- */
void m4cb9d1_relocate_entries(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x12) == 0) return;
    wr32(self, 0x15c, call0(host, 0x4c0c69, 0x637fcf));
    if (rd32(self, 0x15c) == 0) return;
    wr32(self, 0x132, 0);
    for (;; wr32(self, 0x132, rd32(self, 0x132) + 1)) {
        uint8_t *entry;
        if ((int32_t)rd32(self, 0x132) >= rds16(res(host, rd32(self, 0x12)), 2)) break;
        wr32(self, 0x126, rd32(res(host, rd32(self, 0x12)), 9) + rd32(self, 0x132) * 0x18u);
        entry = res(host, rd32(self, 0x126));
        wr32(entry, 4, rd32(entry, 4) + rd32(res(host, rd32(self, 0x15c)), 0x12));
        entry = res(host, rd32(self, 0x126));
        wr32(entry, 0xc, rd32(entry, 0xc) + rd32(res(host, rd32(self, 0x15c)), 0x12));
        entry = res(host, rd32(self, 0x126));
        wr32(entry, 8, rd32(entry, 8) + rd32(res(host, rd32(self, 0x15c)), 0x16));
        entry = res(host, rd32(self, 0x126));
        wr32(entry, 0x10, rd32(entry, 0x10) + rd32(res(host, rd32(self, 0x15c)), 0x16));
    }
}

/* ---- 0x4895cc init_buffer -------------------------------------------------------------------------------------------------------- */
int32_t m4895cc_init_buffer(uint8_t *self, uint32_t p0, uint32_t p1, uint32_t p2, const Fl29aWorld *world, const Fl18Host *host)
{
    uint32_t buf = call1(host, 0x51dc43, 0, 0xaba);
    uint32_t q, k, len;
    const uint8_t *src;
    uint8_t *dst;
    wr32(res(host, p0), 0, buf);
    if (buf == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x54e064, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x54e090, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    memset(res(host, rd32(res(host, p0), 0)), 0, 0xaba);
    wr32(self, 0x1c, rd32(res(host, p0), 0));
    wr32(self, 0x20, rd32(self, 0x1c));
    q = rd32(res(host, p1), 0);
    call2(host, 0x48945b, (uintptr_t)self, rd32(self, 0x1c), q + 0x25);
    src = res(host, q);
    len = (uint32_t)strlen((const char *)src) + 1;
    dst = res(host, rd32(self, 0x20));
    for (k = 0; k < len / 4; k++) memmove(dst + 4 * k, src + 4 * k, 4);
    for (k = len / 4 * 4; k < len; k++) dst[k] = src[k];
    wr16(res(host, rd32(self, 0x20)), 0x23, rd16(res(host, q), 0x21));
    wr16(res(host, rd32(self, 0x20)), 0x27, rd16(res(host, q), 0x23));
    src = res(host, q + 0x35);
    dst = res(host, rd32(self, 0x1c) + 0xac);
    wr32(dst, 0, rd32(src, 0));
    wr32(dst, 4, rd32(src, 4));
    wr32(dst, 8, rd32(src, 8));
    wr32(dst, 0xc, rd32(src, 0xc));
    wr32(res(host, p1), 0, rd32(res(host, p1), 0) + 0x45);
    wr32(res(host, p2), 0, rd32(res(host, p2), 0) + 0x45);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x54e0ac);
    return 0;
}

/* ---- 0x4c3efb lock_surface ------------------------------------------------------------------------------------------------------- */
void m4c3efb_lock_surface(const uint8_t *self, uint32_t surface, uint32_t rect, uint32_t desc, uint32_t tag, const Fl18Host *host)
{
    uint8_t *d;
    if (surface == rd32(self, 0xc)) {
        d = res(host, desc);
        if (rect == 0) {      /* the original tests the same value again at 0x4c3f1b: it cannot fail there */
            wr32(d, 0x24, rd32(self, 0x14));
            wr32(d, 8, (uint32_t)rds16(self, 0x1a));
            wr32(d, 0xc, (uint32_t)rds16(self, 0x18));
        } else {
            const uint8_t *r = res(host, rect);
            wr32(d, 0x24, rd32(self, 0x14) + rd32(r, 4) * rd32(self, 0x1c) + rd32(r, 0) * (uint32_t)rds16(self, 0x20));
            wr32(d, 8, rd32(r, 0xc) - rd32(r, 4) + 1);
            wr32(d, 0xc, rd32(r, 8) - rd32(r, 0) + 1);
        }
        wr32(d, 0, 0x6c);
        wr32(d, 4, rd32(self, 0x42));
        wr32(d, 0x10, rd32(self, 0x1c));
        memcpy(d + 0x48, self + 0x22, 8 * 4);
        return;
    }
    wr32(res(host, desc), 0, 0x6c);
    for (;;) {
        uint32_t vtable = rd32(res(host, surface), 0);
        uint32_t entry = rd32(res(host, vtable + 0x64), 0);
        uint32_t hr = call5(host, entry, 0, surface, rect, desc, 0x800, 0);
        uint32_t text;
        if (hr == 0) return;
        if (hr == 0x887601c2u) {
            call0(host, 0x4c4dc3, (uintptr_t)self);
            continue;
        }
        if (hr == 0x8876021cu) continue;
        text = call1(host, 0x4c88c7, (uintptr_t)self, hr);
        call4(host, 0x50ca3e, 0, 0x63888b, 0x554368, tag, text);
        call1(host, 0x4264e8, 0x583979, 0x63888b);
    }
}
