#include "original_methods_fl30c.h"

#include <string.h>

#define FL30_UNUSED __attribute__((unused))

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

FL30_UNUSED static int32_t rds16(const uint8_t *base, ptrdiff_t off)
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

static float rdf(const uint8_t *base, ptrdiff_t off)
{
    float v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

FL30_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

FL30_UNUSED static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    const uintptr_t a[2] = {a0, a1};
    return callv(host, callee, this_ptr, a, 2);
}

FL30_UNUSED static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    const uintptr_t a[3] = {a0, a1, a2};
    return callv(host, callee, this_ptr, a, 3);
}

FL30_UNUSED static uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3)
{
    const uintptr_t a[4] = {a0, a1, a2, a3};
    return callv(host, callee, this_ptr, a, 4);
}

/* the memory of an original address (an address that an object or a cell keeps), as host memory */
FL30_UNUSED static uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return host->resolve != NULL ? (uint8_t *)host->resolve(host->context, address) : NULL;
}

/* the CRT helper 0x50ce04 (__ftol): fistp qword with the truncating control word; the low dword of the 64-bit result; NaN and a value outside the int64 range give the integer
 * indefinite 0x8000000000000000 (low dword 0) */
static uint32_t ftol_low32(double x)
{
    if (!(x >= -9223372036854775808.0 && x < 9223372036854775808.0)) return 0;
    return (uint32_t)(int64_t)x;
}

/* ---- 0x4fcb5c ------------------------------------------------------------------------------------------------------------------ */

/* 0x4fcb5c, thiscall: see the header. [ebp-8] is `self`. */
void m4fcb5c_set_category_master(uint8_t *self, int32_t idx, const Fl18Host *host)
{
    const ptrdiff_t vol = 0xb764 + (ptrdiff_t)idx * 4;
    int c;
    /* fld [vol]; fcomp 0.0f; test ah, 1: C0 = less than or unordered */
    if (!(rdf(self, vol) >= 0.0f)) wr32(self, vol, 0);
    else wr32(self, vol, rd32(self, vol));
    /* fld [vol]; fcomp 1.0f; test ah, 0x41: C0 | C3 = less, equal or unordered keeps the value */
    if (!(rdf(self, vol) > 1.0f)) wr32(self, vol, rd32(self, vol));
    else wr32(self, vol, 0x3f800000u);
    for (c = 0; c < 0x20; c++) {
        uint8_t *ch = self + (ptrdiff_t)c * 0x5bb;
        double t;
        if (rds16(ch, 0x10c) != idx) continue;
        if (rd16(ch, 0x132) != 1) continue;
        t = (double)rdf(ch, 0x138) * (double)rdf(self, vol);
        t = t * (double)2857.142822265625f;
        t = t + (-2857.142857142857);
        wr32(ch, 0x140, ftol_low32(t));
        t = (double)rdf(ch, 0x13c) * (double)rdf(self, vol);
        t = t * (double)2857.142822265625f;
        t = t + (-2857.142857142857);
        wr32(ch, 0x144, ftol_low32(t));
        call1(host, 0x4f684a, 0x5cf1eb, (uint32_t)(int32_t)c);
    }
}

/* ---- 0x43d7f0 ------------------------------------------------------------------------------------------------------------------ */

/* {ecx, callee} of the 47 thiscalls (no arguments) of 0x43d7f0; entry 0 is made first, the other 46 after the flag stores */
static const struct {
    uint32_t object, callee;
} kInitCalls[47] = {
    {0x61c387, 0x4d3ced},
    {0x616ab2, 0x468f68},
    {0x61c8cf, 0x4a3910},
    {0x61d10f, 0x48a82e},
    {0x617066, 0x4b3da2},
    {0x61c7ed, 0x459bd6},
    {0x61d2dd, 0x4a1ce0},
    {0x624dc9, 0x48e393},
    {0x61d345, 0x48d0e5},
    {0x61d3a1, 0x4a6477},
    {0x61d449, 0x4b5c11},
    {0x61d6c1, 0x4ab425},
    {0x61d723, 0x465b9f},
    {0x61d779, 0x4618ab},
    {0x61d7d8, 0x487b98},
    {0x6204c1, 0x4afdc7},
    {0x61d873, 0x44fb54},
    {0x61e398, 0x47b3bc},
    {0x61df56, 0x4ba22e},
    {0x638603, 0x446075},
    {0x621a02, 0x478287},
    {0x622fa2, 0x4758e8},
    {0x62387c, 0x470e31},
    {0x624686, 0x48bc38},
    {0x6246dc, 0x47d640},
    {0x624734, 0x45b477},
    {0x6248ed, 0x456d77},
    {0x624931, 0x44e7d7},
    {0x6249a0, 0x4b7272},
    {0x6249dc, 0x454e39},
    {0x6252ad, 0x4840d9},
    {0x625ee8, 0x47e440},
    {0x627335, 0x4a7da5},
    {0x61e65c, 0x467651},
    {0x61e95c, 0x473117},
    {0x61ed7b, 0x458045},
    {0x61f4b1, 0x45dd96},
    {0x61ee6e, 0x4b80a5},
    {0x630a34, 0x4a9fcb},
    {0x624b50, 0x4640c9},
    {0x628732, 0x46b707},
    {0x624c2a, 0x46e7ef},
    {0x624cbf, 0x44d19d},
    {0x624d12, 0x48220e},
    {0x6369e4, 0x4acbba},
    {0x63847b, 0x4cafc1},
    {0x619935, 0x489722}
};

/* 0x43d7f0, plain call: see the header. */
void m43d7f0_init_scenes(Fl30cWorld *world, const Fl18Host *host)
{
    int i;
    world->value_5d15a5 = 1;
    call0(host, kInitCalls[0].callee, kInitCalls[0].object);
    if (world->value_5bb1d2 != 0) {
        world->value_5b15d6 = world->value_5bb1ce;
        world->value_5bb1d2 = 0;
    }
    if (world->value_5bb1da != 0) {
        world->value_5b1606 = world->value_5bb1d6;
        world->value_5bb1da = 0;
    }
    if (world->byte_5b5158 != 0) world->value_5d1a8f = 1;
    if (world->byte_5b51ab != 0) world->value_5d1ad9 = 1;
    if (world->byte_5b51c6 != 0) world->value_5d1b23 = 1;
    if (world->byte_5b615e != 0) world->value_5d1bb7 = 1;
    if (world->byte_5b61af != 0) world->value_5d1c01 = 1;
    if (world->byte_5b51f6 != 0) world->value_5d1b6d = 1;
    for (i = 1; i < 47; i++) call0(host, kInitCalls[i].callee, kInitCalls[i].object);
}

/* ---- 0x434025 ------------------------------------------------------------------------------------------------------------------ */

/* 0x434025, thiscall: see the header. [ebp-0x20] is `self`, [ebp-0x14] i, [ebp-0x18] p, [ebp-8] n, [ebp-0x1c] q, [ebp-0xc] m, [ebp-0x10] j, [ebp-4] sel. */
void m434025_scan_entries(uint8_t *self, const Fl18Host *host)
{
    int32_t i;
    uint32_t sel = 0;
    wr32(self, 0x5f68, 0);
    for (i = 0; i < (int32_t)rd32(self, 0x5f64); i++) {
        uint32_t p = rd32(self, 0x1144 + (ptrdiff_t)i * 4) + 4;       /* + the length of "DATA" at 0x545e7c */
        uint32_t n = call1(host, 0x4347b8, (uintptr_t)self, p);
        uint32_t q = 5;
        if (n <= 8) {
            call2(host, 0x42639d, 0x583979, 0x545e98, 0x545e84);
            call0(host, 0x4c97b4, 0x5cf659);
        }
        p += 4;
        p += 4;
        for (;;) {
            uint32_t m;
            if (call1(host, 0x434773, (uintptr_t)self, p) == 1) {
                int32_t j;
                for (j = 0; j < (int32_t)rd32(self, 0x5f64); j++) {
                    if (j == i) continue;
                    if (rd32(self, 0x1144 + (ptrdiff_t)j * 4) == p) {
                        sel = (uint32_t)j;
                        break;
                    }
                }
                p += rd32(self, 0x3084 + (ptrdiff_t)(int32_t)sel * 4);
                q += rd32(self, 0x3084 + (ptrdiff_t)(int32_t)sel * 4);
                if (!(q < n)) break;
            }
            if ((int32_t)rd32(self, 0x5f68) > 0x3e6) {
                call2(host, 0x42639d, 0x583979, 0x545ed0, 0x545ebc);
                call0(host, 0x4c97b4, 0x5cf659);
            }
            wr32(self, 0x20e4 + (ptrdiff_t)(int32_t)rd32(self, 0x5f68) * 4, p);
            wr32(self, 0x5f68, rd32(self, 0x5f68) + 1);
            p += 4;
            q += 4;
            m = call1(host, 0x4347b8, (uintptr_t)self, p);
            if ((m & 1) == 1) m += 1;
            p += 4;
            q += 4;
            p += m;
            q += m;
            if (q > n) break;
        }
    }
}

/* ---- 0x41b6e2 ------------------------------------------------------------------------------------------------------------------ */

/* 0x41b6e2, thiscall (ecx unused): see the header. [ebp+8] src, [ebp+0xc] dst, [ebp+0x10] srclen, [ebp+0x14] out, [ebp-0x1c] si, [ebp-0x10] key, [ebp-8] r, [ebp-4] flags. */
void m41b6e2_lz_decode(const uint8_t *src, uint8_t *dst, uint32_t srclen, uint32_t unused, const Fl30cWorld *world)
{
    uint8_t *ring = world->ring_56f354;
    uint8_t key = 0;
    uint32_t out = 0, si = 0xffffffffu, r, flags = 0;
    (void)unused;
    memset(ring, 0x20, 0x1000 - 0x12);
    r = 0x1000 - 0x12;
    for (;;) {
        flags >>= 1;
        if ((flags & 0x100) == 0) {
            uint8_t c;
            si += 1;
            if (si == srclen) return;
            c = (uint8_t)(src[si] - key);
            key = (uint8_t)(key + 1);
            flags = (uint32_t)c | 0xff00u;
        }
        if ((flags & 1) != 0) {
            uint8_t c;
            si += 1;
            if (si == srclen) return;
            c = (uint8_t)(src[si] - key);
            key = (uint8_t)(key + 1);
            dst[out] = c;
            out += 1;
            ring[r] = c;
            r = (r + 1) & 0xfff;
        } else {
            uint8_t lo, hi;
            uint32_t pos, len, k;
            si += 1;
            if (si == srclen) return;
            lo = (uint8_t)(src[si] - key);
            key = (uint8_t)(key + 1);
            si += 1;
            if (si == srclen) return;
            hi = (uint8_t)(src[si] - key);
            key = (uint8_t)(key + 1);
            pos = (uint32_t)lo | (((uint32_t)hi & 0xf0u) << 4);
            len = ((uint32_t)hi & 0xfu) + 2;
            for (k = 0; k <= len; k++) {
                uint8_t b = ring[(pos + k) & 0xfff];
                dst[out] = b;
                out += 1;
                ring[r] = b;
                r = (r + 1) & 0xfff;
            }
        }
    }
}

/* ---- 0x4763b3 ------------------------------------------------------------------------------------------------------------------ */

/* the cell of the grid at self + 0x30: rows of 0xc8 bytes, cells of 0x14 bytes (the row and the column are 32-bit values as the original multiplies them) */
#define CELL(self, row, col) ((self) + 0x30 + (ptrdiff_t)(int32_t)(row) * 0xc8 + (ptrdiff_t)(int32_t)(col) * 0x14)

static void add_score(uint8_t *self, const uint8_t *rec, ptrdiff_t cells_off, ptrdiff_t thousands_off)
{
    wr32(self, 0x8c2, rd32(self, 0x8c2) + (uint32_t)rds16(rec, cells_off));
    wr32(self, 0x8c6, rd32(self, 0x8c6) + (uint32_t)(rds16(rec, thousands_off) * 1000));
}

/* 0x4763b3, thiscall: see the header. [ebp-0x14] is `self`, [ebp-4] rec, [ebp-0xc] ref, [ebp-0x10] the flag byte, [ebp-8] k. */
void m4763b3_mark_runs(uint8_t *self, uint32_t x, uint32_t y, const Fl30cWorld *world, const Fl18Host *host)
{
    uint8_t *rec = object_at(host, rd32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x22) * 0x8d));
    int32_t ref;
    int flag;
    int16_t k;
    if (rec == NULL) return;                                    /* NATIVE REJECTION */
    if (world->word_63a4cd != 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x54c868, y, x);
        call1(host, 0x44a2b7, 0, 0x63888b);
    }
    self[0x8d6] = 0;
    self[0x8d7] = 0;
    ref = rds16(CELL(self, y, x), 2);
    wr16(self, 0x8ce, (uint16_t)y);
    for (flag = 1; flag;) {
        if (rds16(self, 0x8ce) == 0) {
            flag = 0;
        } else {
            wr16(self, 0x8ce, (uint16_t)(rd16(self, 0x8ce) - 1));
            if (ref != rds16(CELL(self, rds16(self, 0x8ce), x), 2)) {
                flag = 0;
                wr16(self, 0x8ce, (uint16_t)(rd16(self, 0x8ce) + 1));
            }
        }
    }
    wr16(self, 0x8d0, (uint16_t)y);
    for (flag = 1; flag;) {
        if (rds16(self, 0x8d0) == rds16(rec, 0x42) - 1) {
            flag = 0;
        } else {
            wr16(self, 0x8d0, (uint16_t)(rd16(self, 0x8d0) + 1));
            if (ref != rds16(CELL(self, rds16(self, 0x8d0), x), 2)) {
                flag = 0;
                wr16(self, 0x8d0, (uint16_t)(rd16(self, 0x8d0) - 1));
            }
        }
    }
    wr16(self, 0x8d2, (uint16_t)x);
    for (flag = 1; flag;) {
        if (rds16(self, 0x8d2) == 0) {
            flag = 0;
        } else {
            wr16(self, 0x8d2, (uint16_t)(rd16(self, 0x8d2) - 1));
            if (ref != rds16(CELL(self, y, rds16(self, 0x8d2)), 2)) {
                flag = 0;
                wr16(self, 0x8d2, (uint16_t)(rd16(self, 0x8d2) + 1));
            }
        }
    }
    wr16(self, 0x8d4, (uint16_t)x);
    for (flag = 1; flag;) {
        if (rds16(self, 0x8d4) == rds16(rec, 0x44) - 1) {
            flag = 0;
        } else {
            wr16(self, 0x8d4, (uint16_t)(rd16(self, 0x8d4) + 1));
            if (ref != rds16(CELL(self, y, rds16(self, 0x8d4)), 2)) {
                flag = 0;
                wr16(self, 0x8d4, (uint16_t)(rd16(self, 0x8d4) - 1));
            }
        }
    }
    if (rds16(self, 0x8d0) - rds16(self, 0x8ce) >= 2) {
        self[0x8d6] = 1;
        for (k = (int16_t)rd16(self, 0x8ce); k <= rds16(self, 0x8d0); k = (int16_t)(k + 1)) {
            CELL(self, k, x)[1] = 1;
            wr32(self, 0x8c2, rd32(self, 0x8c2) + (uint32_t)rds16(rec, 0x644));
        }
        if (rds16(self, 0x8d4) - rds16(self, 0x8d2) == 2) {
            wr32(self, 0x8c6, rd32(self, 0x8c6) + (uint32_t)(rds16(rec, 0x656) * 1000));
        } else if (rds16(self, 0x8d0) - rds16(self, 0x8ce) == 3) {
            add_score(self, rec, 0x658, 0x65a);
        } else if (rds16(self, 0x8d0) - rds16(self, 0x8ce) == 4) {
            add_score(self, rec, 0x65c, 0x65e);
        }
        call3(host, 0x50ca3e, 0, (uintptr_t)(self + 0x835), 0x54c898, rd32(self, 0x8c2));
        self[0x801] = 1;
    }
    if (rds16(self, 0x8d4) - rds16(self, 0x8d2) >= 2) {
        self[0x8d7] = 1;
        for (k = (int16_t)rd16(self, 0x8d2); k <= rds16(self, 0x8d4); k = (int16_t)(k + 1)) {
            CELL(self, y, k)[1] = 1;
            wr32(self, 0x8c2, rd32(self, 0x8c2) + (uint32_t)rds16(rec, 0x644));
        }
        if (rds16(self, 0x8d4) - rds16(self, 0x8d2) == 2) {
            wr32(self, 0x8c6, rd32(self, 0x8c6) + (uint32_t)(rds16(rec, 0x656) * 1000));
        } else if (rds16(self, 0x8d4) - rds16(self, 0x8d2) == 3) {
            add_score(self, rec, 0x658, 0x65a);
        } else if (rds16(self, 0x8d4) - rds16(self, 0x8d2) == 4) {
            add_score(self, rec, 0x65c, 0x65e);
        }
        call3(host, 0x50ca3e, 0, (uintptr_t)(self + 0x835), 0x54c89c, rd32(self, 0x8c2));
        self[0x801] = 1;
    }
}
