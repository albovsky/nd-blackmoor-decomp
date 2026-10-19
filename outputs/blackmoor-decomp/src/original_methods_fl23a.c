#include "original_methods_fl23a.h"

#include <string.h>

static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v) { memcpy(base + off, &v, sizeof v); }

static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v) { memcpy(base + off, &v, sizeof v); }

/* a signed dword (compared with jl/jg) and a signed word (movsx) */
static int32_t rds32(const uint8_t *base, ptrdiff_t off) { return (int32_t)rd32(base, off); }
static int32_t rds16(const uint8_t *base, ptrdiff_t off) { return (int16_t)rd16(base, off); }

static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    uintptr_t args[1];
    args[0] = a0;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 1) : 0;
}

static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    uintptr_t args[2];
    args[0] = a0;
    args[1] = a1;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 2) : 0;
}

static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    uintptr_t args[3];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 3) : 0;
}

/* 0x46ebbd takes x, y (sign-extended words) and a 16-byte structure by value (four dwords copied from `src`, the lowest address first) */
static uint32_t call_46ebbd(const Fl18Host *host, uintptr_t this_ptr, int16_t x, int16_t y, const uint8_t *src)
{
    uintptr_t args[6];
    int k;
    args[0] = (uint32_t)(int32_t)x;
    args[1] = (uint32_t)(int32_t)y;
    for (k = 0; k < 4; k++) args[2 + k] = rd32(src, 4 * k);
    return host->call != NULL ? host->call(host->context, 0x46ebbd, this_ptr, args, 6) : 0;
}

/* the object of an original address (an address that a record or an object keeps), as host memory */
static const uint8_t *object_at(const Fl18Host *host, uint32_t address) { return host->resolve(host->context, address); }

/* the address of the object of record `index` (a signed word, `imul index, 0x8d`) of 0x5bb5e5 */
static uint32_t record_va(const Fl23aWorld *world, int32_t index) { return rd32(world->records_5bb5e5, (ptrdiff_t)index * 0x8d); }

static const uint8_t *record_object(const Fl23aWorld *world, const Fl18Host *host, int32_t index)
{
    return object_at(host, record_va(world, index));
}

/* the four compares of a rectangle, in the original's order (y low, y high, x low, x high; each a signed dword against a sign-extended
 * word): 1 when the point is inside. The object `o` is read only as far as the compares go. */
static int in_rect(const uint8_t *o, ptrdiff_t ylo, ptrdiff_t yhi, ptrdiff_t xlo, ptrdiff_t xhi, int16_t x, int16_t y)
{
    if ((int32_t)y < rds32(o, ylo)) return 0;
    if ((int32_t)y > rds32(o, yhi)) return 0;
    if ((int32_t)x < rds32(o, xlo)) return 0;
    if ((int32_t)x > rds32(o, xhi)) return 0;
    return 1;
}

/* the stores that finish a click arm of 0x46ea16 and 0x4b7389: 0x5d162d = [0x5d0377], 0x5d1631 = 0x5b160c + (row << 5) + (column << 4)
 * from the current 0x5b44f0 and 0x5b44f4, 0x5d1639 = 1 */
static void finish_cell(Fl23aWorld *world)
{
    world->value_5d162d = world->value_5d0377;
    world->value_5d1631 = (world->value_5b44f0 << 5) + (world->value_5b44f4 << 4) + 0x5b160cu;
    world->value_5d1639 = 1;
}

/* ---- 0x47d734 ------------------------------------------------------------------------------------------------------------------ */

int32_t m47d734_store_point(uint8_t *self, int16_t x, int16_t y)
{
    if (self[0x57] != 0) {
        wr16(self, 0x25, (uint16_t)x);
        wr16(self, 0x27, (uint16_t)y);
    }
    return 0;
}

/* ---- 0x4a1e16 ------------------------------------------------------------------------------------------------------------------ */

int32_t m4a1e16_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host)
{
    (void)world;
    if (rd32(self, 0x60) == 0) return 0;
    if (!in_rect(object_at(host, rd32(self, 0x20)), 0x141, 0x149, 0x13d, 0x145, x, y)) return 0;
    if (rd32(self, 0x50) != 2) return 0;
    call1(host, 0x4a1e93, (uintptr_t)self, 0x2760);
    return 1;
}

/* ---- 0x4ba377 ------------------------------------------------------------------------------------------------------------------ */

int32_t m4ba377_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host)
{
    (void)world;
    if (rd32(self, 0x34) == 0) return 0;
    wr32(self, 0x2d4, 0xffffffffu);
    /* the loop counter lives in the object itself (+0x310), as in the original: a store per iteration */
    for (wr32(self, 0x310, 0); rds32(self, 0x310) < 2; wr32(self, 0x310, rd32(self, 0x310) + 1)) {
        int32_t i = rds32(self, 0x310);
        if (rd32(self, (ptrdiff_t)i * 8 + 0x24) != 0) continue;
        if (!in_rect(object_at(host, rd32(self, 0x18)) + ((ptrdiff_t)i << 4), 0x7f0, 0x7f8, 0x7ec, 0x7f4, x, y)) continue;
        call1(host, 0x4ba486, (uintptr_t)self, rd16(self, 0x310));
        return 1;
    }
    return 0;
}

/* ---- 0x459cc9 ------------------------------------------------------------------------------------------------------------------ */

int32_t m459cc9_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host)
{
    int16_t i;
    if (self[0xd6] == 0) return 0;
    wr16(self, 0xcc, 0xffffu);
    for (i = 0; i < 4; i = (int16_t)(i + 1)) {
        if (!in_rect(record_object(world, host, rds16(self, 0x1c)) + ((ptrdiff_t)i << 4), 0x65, 0x6d, 0x61, 0x69, x, y)) continue;
        if (self[0x1e + i] != 0) return 0;
        call1(host, 0x459ddc, (uintptr_t)self, (uint16_t)i);
        return 1;
    }
    return 0;
}

/* ---- 0x487c92 ------------------------------------------------------------------------------------------------------------------ */

int32_t m487c92_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host)
{
    const uint8_t *o;
    int16_t i;
    if (rd32(self, 0x71) == 0) return 0;
    o = record_object(world, host, rds16(self, 0x1e));
    if (self[0x65] == 0 && in_rect(o, 0x5a7, 0x5af, 0x5a3, 0x5ab, x, y)) {
        call2(host, 0x487dcf, (uintptr_t)self, 0x2789, 0);
        return 1;
    }
    for (i = 0; i < rds16(o, 0x21); i = (int16_t)(i + 1)) {
        if (!in_rect(o + ((ptrdiff_t)i << 4), 0x329, 0x331, 0x325, 0x32d, x, y)) continue;
        call2(host, 0x487dcf, (uintptr_t)self, 0x2788, (uint16_t)i);
        self[0x24] = 1;   /* after the call */
        return 1;
    }
    return 0;
}

/* ---- 0x48a920 ------------------------------------------------------------------------------------------------------------------ */

int32_t m48a920_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host)
{
    const uint8_t *o;
    int32_t i;
    if (rd32(self, 0x1aa) == 0) return 0;
    o = record_object(world, host, rds16(self, 0x1e));
    wr16(self, 0x1b0, 0xffffu);
    for (i = 0; i < (int32_t)o[0x21]; i++) {   /* the count is an unsigned byte */
        if (!in_rect(o + ((ptrdiff_t)i << 4), 0x168, 0x170, 0x164, 0x16c, x, y)) continue;
        if (self[i + 0x24] != 0) continue;
        if (rd32(self, 0x44) != 0) continue;
        call2(host, 0x48aa66, (uintptr_t)self, 0x2756, (uint16_t)i);
        return 1;
    }
    if (in_rect(o, 0x40f, 0x417, 0x40b, 0x413, x, y)) {
        call2(host, 0x48aa66, (uintptr_t)self, 0x2757, 0);
        return 1;
    }
    return 0;
}

/* ---- 0x48e628 ------------------------------------------------------------------------------------------------------------------ */

int32_t m48e628_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host)
{
    const uint8_t *o = record_object(world, host, rds16(self, 0x1e));
    int16_t i;
    if (rd32(self, 0x462) == 0) return 0;
    if (in_rect(o, 0x9e, 0xa6, 0x9a, 0xa2, x, y)) {
        call2(host, 0x48e776, (uintptr_t)self, 0x27b9, 0);
        return 1;
    }
    for (i = 0; i < rds16(o, 0xb0); i = (int16_t)(i + 1)) {
        if (!in_rect(o + (ptrdiff_t)i * 0xd0, 0xb6, 0xbe, 0xb2, 0xba, x, y)) continue;
        if ((int32_t)i == rds16(self, 0x3fe)) continue;
        call2(host, 0x48e776, (uintptr_t)self, 0x27b8, (uint16_t)i);
        return 1;
    }
    return 0;
}

/* ---- 0x479deb ------------------------------------------------------------------------------------------------------------------ */

int32_t m479deb_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host)
{
    const uint8_t *o;
    int16_t i;
    if (rd32(self, 0x157a) == 0) return 0;
    if (rd32(self, 0x24) == 2) return 0;
    if (rd32(self, 0x1528) != 0) return 0;
    o = record_object(world, host, rds16(self, 0x1e));
    for (i = 0; i < 5; i = (int16_t)(i + 1)) {
        const uint8_t *e = o + ((ptrdiff_t)i << 4);
        /* a rectangle shrunk by 10 on every side (add / sub on the dword, wrapping) */
        if ((int32_t)y < (int32_t)(uint32_t)(rd32(e, 0x174) + 10u)) continue;
        if ((int32_t)y > (int32_t)(uint32_t)(rd32(e, 0x17c) - 10u)) continue;
        if ((int32_t)x < (int32_t)(uint32_t)(rd32(e, 0x170) + 10u)) continue;
        if ((int32_t)x > (int32_t)(uint32_t)(rd32(e, 0x178) - 10u)) continue;
        if (call3(host, 0x478396, (uintptr_t)self, (uint32_t)(i + 1), rd16(self, 0x158e), rd16(self, 0x1590)) != 1) continue;
        call2(host, 0x479f72, (uintptr_t)self, 0x279c, (uint32_t)(i + 1));
        return 1;
    }
    if (in_rect(o, 0x28f, 0x297, 0x28b, 0x293, x, y)) {
        call2(host, 0x479f72, (uintptr_t)self, 0x279d, 0);
        return 1;
    }
    return 0;
}

/* ---- 0x46ea16 ------------------------------------------------------------------------------------------------------------------ */

int32_t m46ea16_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host)
{
    uint32_t o_va;
    int32_t i;
    if (rd32(self, 0x46) == 0) return 0;
    if (rd32(self, 0x5f) != 0) return 0;
    o_va = record_va(world, rds16(self, 0x1e));
    if (call_46ebbd(host, (uintptr_t)self, x, y, object_at(host, o_va + 0xf23u)) != 0) {
        world->value_5c39e5 = 0x27c3;
        world->value_5b44f0 = 9;
        world->value_5b44f4 = 1;
        finish_cell(world);
        return 1;
    }
    wr32(self, 0x24, o_va + 0x23cu);
    for (i = 0; i < 0x10; i++) {
        /* [self + 0x24] is read again for every entry: the callee may have changed it */
        if (call_46ebbd(host, (uintptr_t)self, x, y, object_at(host, rd32(self, 0x24) + ((uint32_t)i << 4))) == 0) continue;
        world->value_5b44f0 = 0x16;
        world->value_5b44f4 = 1;
        finish_cell(world);
        world->value_5c39e5 = 0x27c2;
        self[0x52] = (uint8_t)i;
        return 1;
    }
    return 0;
}

/* ---- 0x4b7389 ------------------------------------------------------------------------------------------------------------------ */

int32_t m4b7389_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host)
{
    const uint8_t *o = record_object(world, host, rds16(self, 0x21));
    if (self[0x35] == 0) return 0;
    if (in_rect(o, 0x3ba, 0x3c2, 0x3b6, 0x3be, x, y)) {
        world->value_5b44f0 = 9;
        world->value_5b44f4 = 1;
        finish_cell(world);
        world->value_5c39e5 = 0x27c1;
        return 1;
    }
    /* the two rectangles that follow are not exclusive; the stores below are made for each one that hits, and then the common tail runs */
    if (in_rect(o, 0x2f, 0x37, 0x2b, 0x33, x, y)) {
        world->value_5b44f4 = 1;
        world->value_5b44f0 = o[0x25] != 0 ? 0x14u : 0x15u;
        world->value_5c39e5 = 0x27bf;
    }
    if (in_rect(o, 0x3f, 0x47, 0x3b, 0x43, x, y)) {
        world->value_5b44f4 = 1;
        world->value_5b44f0 = o[0x25] != 0 ? 0x14u : 0x15u;
        world->value_5c39e5 = 0x27c0;
    }
    finish_cell(world);
    return 1;
}

/* ---- 0x4ab528 ------------------------------------------------------------------------------------------------------------------ */

int32_t m4ab528_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host)
{
    const uint8_t *o;
    int32_t i;
    if (rd32(self, 0x54) == 0) return 0;
    if (rd32(self, 0x24) != 0) return 0;
    if (rd32(self, 0x5e) != 0) return 0;
    o = record_object(world, host, rds16(self, 0x1e));
    for (i = 0; i < rds16(o, 0x21); i++) {
        if (!in_rect(o + ((ptrdiff_t)i << 4), 0xa3, 0xab, 0x9f, 0xa7, x, y)) continue;
        call2(host, 0x4ab706, (uintptr_t)self, 0x27cf, (uint16_t)i);
        return 1;
    }
    for (i = 0; i < rds16(o, 0x21); i++) {
        if (!in_rect(o + ((ptrdiff_t)i << 4), 0x1c3, 0x1cb, 0x1bf, 0x1c7, x, y)) continue;
        if (rds16(self, (ptrdiff_t)i * 2 + 0x3c) <= 0) continue;
        call2(host, 0x4ab706, (uintptr_t)self, 0x27ce, (uint16_t)i);
        return 1;
    }
    if (in_rect(o, 0xbb3, 0xbbb, 0xbaf, 0xbb7, x, y)) {
        call2(host, 0x4ab706, (uintptr_t)self, 0x27d0, 0);
        return 1;
    }
    return 0;
}
