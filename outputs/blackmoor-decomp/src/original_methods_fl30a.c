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

/* ---- 0x44b3c8 sum_kinds ------------------------------------------------------------------------------------------------------ */
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

void m44b3c8_sum_kinds(uint32_t index, const Fl30aWorld *world, const Fl18Host *host)
{
    uint32_t rec = rd32(world->table_5bb5e5, (ptrdiff_t)(int32_t)((uint32_t)(int32_t)(int16_t)index * 0x8du));
    uint8_t kind = res(host, rec)[0];
    int16_t i;
    if (kind < 0x1e || kind > 0x27) {
        if (world->word_63a4cd != 0) {
            call3(host, 0x50ca3e, 0, 0x63888b, 0x549054, kind);
            call3(host, 0x52139c, 0, 0x63888b, 0, 0);
        }
    } else {
        wrf32(world->tab_58c91d, (ptrdiff_t)kind * 4, 0.0f);
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
            wrf32(world->tab_58c91d, (ptrdiff_t)kind * 4, (float)((double)v + (double)rdf32(world->tab_58c91d, (ptrdiff_t)kind * 4)));
        }
    }
    call1(host, 0x42ba3a, 0, index & 0xffffu);
}
