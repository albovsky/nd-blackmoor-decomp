#include "original_methods_fl30a.h"

#include <string.h>

static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static __attribute__((unused)) uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static __attribute__((unused)) int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

static __attribute__((unused)) void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
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

static __attribute__((unused)) uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

static __attribute__((unused)) uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    const uintptr_t a[2] = {a0, a1};
    return callv(host, callee, this_ptr, a, 2);
}

static __attribute__((unused)) uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    const uintptr_t a[3] = {a0, a1, a2};
    return callv(host, callee, this_ptr, a, 3);
}

static __attribute__((unused)) uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3)
{
    const uintptr_t a[4] = {a0, a1, a2, a3};
    return callv(host, callee, this_ptr, a, 4);
}

static __attribute__((unused)) uint32_t call5(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3, uintptr_t a4)
{
    const uintptr_t a[5] = {a0, a1, a2, a3, a4};
    return callv(host, callee, this_ptr, a, 5);
}

/* ---- 0x4f61e7 start_record ------------------------------------------------------------------------------------------------------ */
uint32_t m4f61e7_start_record(uint8_t *self, uint32_t index, const Fl30aWorld *world, const Fl18Host *host)
{
    uint32_t rec, obj, vtable, entry, hr;
    wr32(self, 0x3c2, 0x3e8);
    wr32(self, 0x3ca, 0);
    rec = rd32(self, 0x3ce) + index * 0x5bbu;
    if (call0(host, 0x4f709c, (uintptr_t)self) == 0) {
        wr32(self, 0x3c2, 0x3ea);
        wr32(self, 0x3be, 0);
        return rd32(self, 0x3be);
    }
    if (rd32(res(host, rec), 0x162) == 0 || rd32(res(host, rec), 0x28f) == 0) {
        wr32(self, 0x3c2, 0x3ef);
        wr32(self, 0x3be, 0);
        return rd32(self, 0x3be);
    }
    wr32(res(host, rec), 0x287, 1);
    obj = rd32(res(host, rec), 0x28f);
    vtable = rd32(res(host, obj), 0);
    entry = rd32(res(host, vtable + 0x48), 0);
    hr = call1(host, entry, vtable, obj);
    wr32(self, 0x3ca, hr);
    if (rd32(self, 0x3ca) == 0) {
        if (world->word_63a4cd != 0) {
            call4(host, 0x50ca3e, 0, 0x63888b, 0x55e7bc, index, rec + 4);
            call1(host, 0x44a2b7, 0, 0x63888b);
        }
        return 1;
    }
    wr32(self, 0x3c2, 0x40b);
    wr32(self, 0x3be, 0);
    return rd32(self, 0x3be);
}

/* ---- 0x484762 intersect_rects ---------------------------------------------------------------------------------------------------- */
uint32_t m484762_intersect_rects(const uint8_t *self, uint32_t a, uint32_t b)
{
    const uint8_t *r1 = self + (ptrdiff_t)(int32_t)(a * 0x85u) + 0x28;
    const uint8_t *r2 = self + (ptrdiff_t)(int32_t)(b * 0x85u) + 0x28;
    const uint8_t *ra = r1 + (ptrdiff_t)r1[0x22] * 0x18 + 0x24;
    const uint8_t *rb = r2 + (ptrdiff_t)r2[0x22] * 0x18 + 0x24;
    const uint8_t *A = r1 + 2, *B = r2 + 2;
    uint16_t unused_a = rd16(ra, 0x14), unused_b = rd16(rb, 0x14);
    int32_t rx0 = -1, ry0 = -1, rx1 = -1, ry1 = -1;
    (void)unused_a;
    (void)unused_b;
    if ((int32_t)rd32(A, 0) < (int32_t)rd32(B, 0)) {
        if ((int32_t)rd32(A, 8) < (int32_t)rd32(B, 0)) return 0;
        rx0 = (int32_t)rd32(B, 0);
        rx1 = (int32_t)rd32(A, 8) > (int32_t)rd32(B, 8) ? (int32_t)rd32(B, 8) : (int32_t)rd32(A, 8);
    } else {
        if ((int32_t)rd32(A, 0) > (int32_t)rd32(B, 8)) return 0;
        rx0 = (int32_t)rd32(A, 0);
        rx1 = (int32_t)rd32(A, 8) > (int32_t)rd32(B, 8) ? (int32_t)rd32(B, 8) : (int32_t)rd32(A, 8);
    }
    if ((int32_t)rd32(A, 4) < (int32_t)rd32(B, 4)) {
        if ((int32_t)rd32(A, 0xc) < (int32_t)rd32(B, 4)) return 0;
        ry0 = (int32_t)rd32(B, 4);
        ry1 = (int32_t)rd32(A, 0xc) > (int32_t)rd32(B, 0xc) ? (int32_t)rd32(B, 0xc) : (int32_t)rd32(A, 0xc);
    } else {
        if ((int32_t)rd32(A, 4) > (int32_t)rd32(B, 0xc)) return 0;
        ry0 = (int32_t)rd32(A, 4);
        ry1 = (int32_t)rd32(A, 0xc) > (int32_t)rd32(B, 0xc) ? (int32_t)rd32(B, 0xc) : (int32_t)rd32(A, 0xc);
    }
    if (ry0 == -1 || ry1 == -1 || rx0 == -1 || rx1 == -1) return 0;
    return 1;
}

/* ---- 0x484ac0 latch_hit ----------------------------------------------------------------------------------------------------------- */
void m484ac0_latch_hit(uint8_t *self, const Fl30aWorld *world, const Fl18Host *host)
{
    ptrdiff_t slot = (ptrdiff_t)(int32_t)((uint32_t)(int32_t)(int16_t)rd16(self, 0x26) * 0x8du);
    uint32_t rec = rd32(world->table_5bb5e5, slot);
    int16_t h;
    if (rd32(self, 0xba7) == 0) return;
    if (res(host, rec)[0x24] == 0) return;
    if (res(host, rec)[0x25] != 0) return;
    if (self[0xbb0] != 0) return;
    if (rd32(self, 0xbac) != 0) return;
    if (rd32(world->table_5bb5e5, slot + 0x4d) != 1) return;
    if ((int16_t)rd16(self, 0xbf9) == 0) return;
    if (rd32(self, 0xa92) != 0) {
        h = (int16_t)rd16(self, 0xa9e);
        call1(host, 0x4853b0, (uintptr_t)self, (uint16_t)h);
        wr16(self, 0xbc5, (uint16_t)(rd32(self, (ptrdiff_t)h * 0x85 + 0x32) - rd32(self, (ptrdiff_t)h * 0x85 + 0x2a)));
        wr16(self, 0xbc7, (uint16_t)(rd32(self, (ptrdiff_t)h * 0x85 + 0x36) - rd32(self, (ptrdiff_t)h * 0x85 + 0x2e)));
    } else {
        h = (int16_t)call0(host, 0x4846c2, (uintptr_t)self);
        if (h == -1) return;
        call1(host, 0x4853b0, (uintptr_t)self, (uint16_t)h);
        wr32(self, 0xa92, 1);
        wr16(self, 0xa9e, (uint16_t)h);
        wr16(self, 0xbc5, (uint16_t)(rd32(self, (ptrdiff_t)(int16_t)rd16(self, 0xa9e) * 0x85 + 0x32) - rd32(self, (ptrdiff_t)(int16_t)rd16(self, 0xa9e) * 0x85 + 0x2a)));
        wr16(self, 0xbc7, (uint16_t)(rd32(self, (ptrdiff_t)(int16_t)rd16(self, 0xa9e) * 0x85 + 0x36) - rd32(self, (ptrdiff_t)(int16_t)rd16(self, 0xa9e) * 0x85 + 0x2e)));
    }
    call0(host, 0x485f12, (uintptr_t)self);
    call1(host, 0x484935, (uintptr_t)self, (uint16_t)h);
}

/* ---- sum_kinds helpers ------------------------------------------------------------------------------------------------------ */
static float rdf32(const uint8_t *base, ptrdiff_t off)
{
    float v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static void wrf32(uint8_t *base, ptrdiff_t off, float v)
{
    memcpy(base + off, &v, sizeof v);
}

/* 0x44b3c8 m44b3c8_sum_kinds */
void m44b3c8_sum_kinds(uint32_t index, const Fl30aWorld *world, const Fl18Host *host)
{
    uint32_t rec = rd32(world->table_5bb5e5, (ptrdiff_t)(int32_t)((uint32_t)(int32_t)(int16_t)index * 0x8du));
    uint8_t kind = res(host, rec)[0];      /* the record byte is read again at each use, as in the original (a report callee may change it) */
    int16_t i;
    if (kind < 0x1e || kind > 0x27) {
        if (world->word_63a4cd != 0) {
            call3(host, 0x50ca3e, 0, 0x63888b, 0x549054, res(host, rec)[0]);
            call3(host, 0x52139c, 0, 0x63888b, 0, 0);
        }
    } else {
        wrf32(world->tab_58c91d, (ptrdiff_t)res(host, rec)[0] * 4, 0.0f);
        for (i = 0; i < 10; i++) {
            const uint8_t *r = res(host, rec);
            uint8_t e = r[1 + i * 3];
            int32_t value = (int16_t)rd16(r, 2 + i * 3);
            float v;
            if (e == 0x63) continue;
            if (e > 0x27) {
                if (e == 0x64) {
                    v = (float)value;
                } else {
                    call3(host, 0x50ca3e, 0, 0x63888b, 0x549088, e);
                    call3(host, 0x52139c, 0, 0x63888b, 0, 0);
                    v = 0.0f;
                }
            } else if (e <= 0x1d) {
                int32_t t = (int16_t)rd16(world->tab_58c91d, 0x3c + (ptrdiff_t)e * 2);
                if (t == 0x270f) {
                    v = 0.0f;
                } else {
                    float count = (float)value;
                    float scale = (float)t;
                    v = (float)(((double)count / 100.0) * (double)scale);
                }
            } else {
                float f = rdf32(world->tab_58c91d, (ptrdiff_t)e * 4);
                if (!(f < 9999.0f) && !(f > 9999.0f)) {
                    v = 0.0f;
                } else {
                    float count = (float)value;
                    v = (float)(((double)count / 100.0) * (double)f);
                }
            }
            wrf32(world->tab_58c91d, (ptrdiff_t)res(host, rec)[0] * 4, (float)((double)v + (double)rdf32(world->tab_58c91d, (ptrdiff_t)res(host, rec)[0] * 4)));
        }
    }
    call1(host, 0x42ba3a, 0, index & 0xffffu);
}

/* ---- 0x47ef0f latch_hit_counter ---------------------------------------------------------------------------------------------- */
void m47ef0f_latch_hit_counter(uint8_t *self, const Fl30aWorld *world, const Fl18Host *host)
{
    ptrdiff_t slot = (ptrdiff_t)(int32_t)((uint32_t)(int32_t)(int16_t)rd16(self, 0x1e) * 0x8du);
    uint32_t rec = rd32(world->table_5bb5e5, slot);
    int16_t h;
    if (rd32(self, 0x13c5) == 0) return;
    if (res(host, rec)[0x48] == 0) return;
    if (res(host, rec)[0x49] != 0) return;
    if (self[0x13ce] != 0) return;
    if (rd32(self, 0x13ca) != 0) return;
    if (rd32(world->table_5bb5e5, slot + 0x4d) != 1) return;
    if ((int16_t)rd16(self, 0x1417) == 0) return;
    if (rd32(self, 0x1344) != 0) {
        h = (int16_t)rd16(self, 0x1350);
        call1(host, 0x47fa11, (uintptr_t)self, (uint16_t)h);
        wr16(self, 0x13e3, (uint16_t)(rd32(self, (ptrdiff_t)h * 0x25 + 0x7be) - rd32(self, (ptrdiff_t)h * 0x25 + 0x7b6)));
        wr16(self, 0x13e5, (uint16_t)(rd32(self, (ptrdiff_t)h * 0x25 + 0x7c2) - rd32(self, (ptrdiff_t)h * 0x25 + 0x7ba)));
    } else {
        ptrdiff_t base;
        uint8_t k;
        h = (int16_t)call0(host, 0x47e9d3, (uintptr_t)self);
        if (h == -1) return;
        call1(host, 0x47fa11, (uintptr_t)self, (uint16_t)h);
        wr32(self, 0x1344, 1);
        wr16(self, 0x1350, (uint16_t)h);
        base = (ptrdiff_t)(int16_t)rd16(self, 0x1350) * 0x25;       /* [self+0x1350] is read again for every use, as in the original */
        wr16(self, 0x13e3, (uint16_t)(rd32(self, base + 0x7be) - rd32(self, base + 0x7b6)));
        wr16(self, 0x13e5, (uint16_t)(rd32(self, base + 0x7c2) - rd32(self, base + 0x7ba)));
        k = self[base + 0x7d7];
        if (self[k + 0x7a0] != 0 && res(host, rec)[(ptrdiff_t)k * 0x53 + 0xe9] == 0) self[k + 0x7a0] = (uint8_t)(self[k + 0x7a0] - 1);
    }
    call0(host, 0x480abe, (uintptr_t)self);
    call1(host, 0x47ed96, (uintptr_t)self, (uint16_t)h);
}

/* ---- draw_text helpers -------------------------------------------------------------------------------------------------------- */
/* The library routine __ftol at 0x50ce04 (the value on the x87 stack): truncation to a 64-bit integer, eax = its low dword; a NaN or a value outside the 64-bit range gives 0 (the integer indefinite's low dword). */
static uint32_t ftol_low_dword(double value)
{
    if (value != value) return 0;
    if (value >= 9223372036854775808.0 || value < -9223372036854775808.0) return 0;
    return (uint32_t)(int64_t)value;
}

/* the four rectangle dwords of a glyph row: rect = { [ebp-0x28], [ebp-0x24], [ebp-0x20], [ebp-0x1c] } */
static void glyph_rect(const uint8_t *layout, int16_t idx, uint16_t sel, uint32_t rect[4])
{
    ptrdiff_t row = (ptrdiff_t)(int32_t)((uint32_t)(int32_t)idx << 4);
    ptrdiff_t s = (ptrdiff_t)(int16_t)sel * 8;
    rect[1] = rd32(layout, row + 0xc7) + rd32(layout, s + 0x43);
    rect[3] = rd32(layout, row + 0xcf) + rd32(layout, s + 0x43);
    rect[0] = rd32(layout, row + 0xc3) + rd32(layout, s + 0x3f);
    rect[2] = rd32(layout, row + 0xcb) + rd32(layout, s + 0x3f);
}

/* 0x4d270b m4d270b_draw_text */
uint32_t m4d270b_draw_text(uint32_t str, uint32_t layout, uint32_t extents, uint32_t x, uint32_t y, uint32_t dest_a, uint32_t dest_b, uint32_t sel, uint32_t flag, uint32_t color,
                           Fl30aWorld *world, const Fl18Host *host)
{
    uint32_t rect[4] = {0, 0, 0, 0};
    uint16_t idx = 0;
    int32_t x0, x1 = 0, ofs = 0;
    int drawn = 0;
    if (world->word_63a4cd != 0 && (dest_a == 0 || dest_b == 0)) {
        call3(host, 0x52139c, 0, 0x55a2fc, 0, 0);
        call0(host, 0x4c97b4, 0x5cf659);
    }
    world->dword_63a8fc = (int16_t)y;
    world->dword_63a8f4 = 0;
    world->dword_63a8f0 = (int16_t)x;
    world->dword_63a8f8 = 0;
    x0 = world->dword_63a8f0;
    for (;; str++) {
        int32_t c = (int8_t)res(host, str)[0];
        int found;
        if (c == 0) break;
        found = call3(host, 0x4d214b, 0, (uint32_t)c & 0xffu, layout, (uintptr_t)&idx) != 0;
        if (!found) {
            const uint8_t *lay = res(host, layout);
            if (call1(host, 0x50d651, 0, (uint32_t)c) != 0 && call1(host, 0x50d67f, 0, (uint32_t)c) != 0 && (uint8_t)c < 0x80) {
                idx = (uint16_t)(c + (int16_t)rd16(lay, 0x53) - 0x41);
            } else if (call1(host, 0x50d651, 0, (uint32_t)c) != 0 && call1(host, 0x50d6a7, 0, (uint32_t)c) != 0 && (uint8_t)c < 0x80) {
                idx = (uint16_t)(c + (int16_t)rd16(lay, 0x55) - 0x61);
            } else if (call1(host, 0x50d6cf, 0, (uint32_t)c) != 0 && (uint8_t)c < 0x80) {
                idx = (uint16_t)(c + (int16_t)rd16(lay, 0x57) - 0x30);
            } else {
                world->dword_63a8f0 = (int32_t)((uint32_t)world->dword_63a8f0 + (uint32_t)(int32_t)(int16_t)rd16(lay, 0x4f));
                world->dword_63a8f8 = (int32_t)((uint32_t)world->dword_63a8f0 + (uint32_t)(int32_t)(int16_t)rd16(lay, 0x4f) - 1u);
                x1 = world->dword_63a8f8;
                continue;
            }
        }
        glyph_rect(res(host, layout), (int16_t)idx, (uint16_t)sel, rect);
        world->dword_63a8f4 = (int32_t)((uint32_t)world->dword_63a8fc - (uint32_t)(int32_t)(int16_t)rd16(res(host, extents), (ptrdiff_t)(int16_t)idx * 4 + 2) + 1u);
        world->dword_63a8f8 = (int32_t)((uint32_t)world->dword_63a8f0 + (uint32_t)(int32_t)(int16_t)rd16(res(host, extents), (ptrdiff_t)(int16_t)idx * 4) - 1u);
        x1 = world->dword_63a8f8;
        call5(host, 0x4c5b3a, 0x5cf659, dest_a, dest_b, (uintptr_t)rect, 0x63a8f0, 0x55a338);
        if (flag != 0 && !drawn) {
            float count = (float)(int32_t)((uint32_t)world->dword_63a8fc - (uint32_t)world->dword_63a8f4 + 1u);
            ofs = (int32_t)(ftol_low_dword((double)count * (double)0.9f) + (uint32_t)world->dword_63a8f4);     /* 0.9f: the float at 0x52e2d4 */
            drawn = 1;
        }
        world->dword_63a8f0 = (int32_t)((uint32_t)(int32_t)(int16_t)rd16(res(host, layout), 0x51) + (uint32_t)world->dword_63a8f0 + (uint32_t)(int32_t)(int16_t)rd16(res(host, extents), (ptrdiff_t)(int16_t)idx * 4));
        world->dword_63a8f8 = (int32_t)((uint32_t)world->dword_63a8f0 + (uint32_t)(int32_t)(int16_t)rd16(res(host, extents), (ptrdiff_t)(int16_t)idx * 4) - 1u);
    }
    if (flag != 0 && drawn) {      /* NATIVE REJECTION: without a drawn glyph the original uses the uninitialised locals ofs and (for an empty string) x1 and writes through an address made of stack garbage */
        uint32_t p = rd32(res(host, dest_b), 0) + (uint32_t)ofs * (uint32_t)(int32_t)(int16_t)rd16(res(host, dest_b), 0x2f) + (uint32_t)x0 * (uint32_t)(int32_t)world->word_639895;
        int32_t k;
        for (k = 0; k < (int32_t)((uint32_t)x1 - (uint32_t)x0 + 1u); k++) {
            wr16(res(host, p), 0, (uint16_t)color);
            p += 2;
        }
    }
    return 0x63a8f0;
}
