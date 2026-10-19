#include "original_methods_fl26a.h"

#include <string.h>

static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static int32_t rds32(const uint8_t *base, ptrdiff_t off)
{
    return (int32_t)rd32(base, off);
}

static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* a signed word, sign-extended (movsx) */
static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, NULL, 0) : 0;
}

static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    uintptr_t args[1];
    args[0] = a0;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 1) : 0;
}

/* the object of an original address (an address that a record or an object keeps), as host memory */
static const uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return host->resolve(host->context, address);
}

/* `movsx ecx, word [self + idx]; imul ecx, ecx, 0x8d; mov eax, [ecx + 0x5bb5e5]`: the original address of the object of record n */
static uint32_t record_object_address(const Fl26aWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    return rd32(world->records_5bb5e5, (ptrdiff_t)(rds16(self, idx_off) * 0x8d));
}

/* `lo <= v <= hi` for the signed compares `cmp v, lo; jl` and `cmp v, hi; jg` */
static int in_range(int32_t v, int32_t lo, int32_t hi)
{
    return !(v < lo) && !(v > hi);
}

/* the 32-bit `add` / `sub` of the original (wraps; the compare that follows is signed) */
static int32_t add32(int32_t a, uint32_t b)
{
    return (int32_t)((uint32_t)a + b);
}

/* ---- 0x4d3073 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4d3073, plain `ret`: see the header. The stack local [ebp-4] holds [0x583204] - 2 and is compared as an unsigned dword with 3
 * (`ja`); the jump table at 0x4d3127 has the four arm addresses 0x4d30f5, 0x4d3101, 0x4d310d, 0x4d3119 in index order. The callees are
 * host calls with the constant ecx of the singleton they work on; [0x583204] and [0x5a161f] are read after the calls before them, as
 * the original does. */
void m4d3073_session_tick(Fl26aWorld *world, const Fl18Host *host)
{
    uint32_t index;
    call0(host, 0x4db38a, 0x5830ce);
    world->value_5a4c18 = 0;
    world->value_5c39e5 = 0xffffffffu;
    call0(host, 0x4e8d72, 0x571442);
    world->value_5b44f8 = 0;
    index = world->value_583204 - 2u;
    if (index > 3u) {
        call0(host, 0x4f0059, 0x583182);
        call0(host, 0x4e075a, 0x570508);
        if (world->byte_5a161f != 0) call0(host, 0x4de322, 0x61f864);
        return;
    }
    switch (index) {
    case 0: call0(host, 0x4e77b8, 0x582711); break;
    case 1: call0(host, 0x4e89eb, 0x571442); break;
    case 2: call0(host, 0x4ebd85, 0x57fd34); break;
    default: call0(host, 0x4e412d, 0x57975c); break;
    }
}

/* ---- 0x469057 ------------------------------------------------------------------------------------------------------------------ */

/* 0x469057, thiscall, `ret 8`: x is the word at [ebp+8], y the word at [ebp+0xc]. The six rows of 16 bytes sit in the object itself, then
 * the rectangle of the object of the record of the word [+0x7e] (read at every use in the original; nothing changes it before the
 * last call, so it is resolved once). The edges are widened in 32 bits (`sub ecx, 5` / `add eax, 5` / `sub edx, 6` / `add ecx, 0xa`)
 * and compared as signed dwords with the sign-extended words. The argument pushed from `ax` (the row index) is a word. */
int32_t m469057_hit_test(uint8_t *self, int16_t x, int16_t y, const Fl26aWorld *world, const Fl18Host *host)
{
    const uint8_t *obj;
    int16_t i;
    if (rd32(self, 0x55c) == 0) return 0;
    wr16(self, 0x554, 0xffff);
    wr16(self, 0x552, 0xffff);
    wr16(self, 0x548, 0xffff);
    for (i = 0; (int32_t)i < 6; i++) {
        ptrdiff_t e = (ptrdiff_t)((int32_t)i << 4);
        if ((int32_t)y < add32(rds32(self, e + 0x20), (uint32_t)-5)) continue;
        if ((int32_t)y > add32(rds32(self, e + 0x28), 5u)) continue;
        if ((int32_t)x < add32(rds32(self, e + 0x1c), (uint32_t)-6)) continue;
        if ((int32_t)x > add32(rds32(self, e + 0x24), 0xau)) continue;
        wr16(self, 0x552, (uint16_t)x);
        wr16(self, 0x554, (uint16_t)y);
        call1(host, 0x4691ee, (uintptr_t)self, (uint16_t)i);
        return 1;
    }
    obj = object_at(host, record_object_address(world, self, 0x7e));
    if ((int32_t)y < add32(rds32(obj, 0x35), (uint32_t)-5)) return 0;
    if ((int32_t)y > add32(rds32(obj, 0x3d), 5u)) return 0;
    if ((int32_t)x < add32(rds32(obj, 0x31), (uint32_t)-6)) return 0;
    if ((int32_t)x > add32(rds32(obj, 0x39), 0xau)) return 0;
    call1(host, 0x4691ee, (uintptr_t)self, 0x64);
    return 1;
}

/* ---- 0x4b42d3 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4b42d3, thiscall, `ret 0xc`: x is the word at [ebp+8], y the word at [ebp+0xc], rect the address at [ebp+0x10] of four dwords. The
 * record object is re-read at every row (the word [+0x728] and the table, after the call 0x4b3f98 that may change the object). The
 * argument pushed from `cx` (the row index) is a word. */
int32_t m4b42d3_hit_test(uint8_t *self, int16_t x, int16_t y, uint32_t rect, const Fl26aWorld *world, const Fl18Host *host)
{
    const uint8_t *r, *obj;
    int16_t i;
    if (rd32(self, 0x76e) == 0) return 0;
    wr16(self, 0x75c, 0xffff);
    wr16(self, 0x75a, 0xffff);
    wr16(self, 0x758, 0xffff);
    r = object_at(host, rect);
    wr32(self, 0x762, rd32(r, 4));
    wr32(self, 0x76a, rd32(r, 0xc));
    wr32(self, 0x75e, rd32(r, 0));
    wr32(self, 0x766, rd32(r, 8));
    call0(host, 0x4b3f98, (uintptr_t)self);
    for (i = 0; (int32_t)i < 3; i++) {
        ptrdiff_t e = (ptrdiff_t)((int32_t)i << 4);
        obj = object_at(host, record_object_address(world, self, 0x728));
        if (!in_range(y, rds32(obj, e + 0xed), rds32(obj, e + 0xf5))) continue;
        if (!in_range(x, rds32(obj, e + 0xe9), rds32(obj, e + 0xf1))) continue;
        wr16(self, 0x75a, (uint16_t)x);
        wr16(self, 0x75c, (uint16_t)y);
        call1(host, 0x4b450f, (uintptr_t)self, (uint16_t)i);
        return 1;
    }
    if (rds16(self, 0x750) != 0) return 0;
    obj = object_at(host, record_object_address(world, self, 0x728));
    if (!in_range(y, rds32(obj, 0x8a2), rds32(obj, 0x8aa))) return 0;
    if (!in_range(x, rds32(obj, 0x89e), rds32(obj, 0x8a6))) return 0;
    call1(host, 0x4b450f, (uintptr_t)self, 0x64);
    return 1;
}

/* ---- 0x4897cd ------------------------------------------------------------------------------------------------------------------ */

/* 0x4897cd, thiscall, `ret 8`: x is the word at [ebp+8], y the word at [ebp+0xc]. The object list is the dwords at [+0x2c + 4i] (original
 * addresses), the count the signed dword [+0xcc]; the three stores into `self` ([+0x1c], [+0x20], [+0x24]) are original addresses. The
 * row words are compared sign-extended (movsx) with the sign-extended word [0x5bb50b] and with 1. */
int32_t m4897cd_hit_test(uint8_t *self, int16_t x, int16_t y, Fl26aWorld *world, const Fl18Host *host)
{
    int32_t i, j;
    if (rd32(self, 0xcc) == 0) return 0;
    for (i = 0; i < rds32(self, 0xcc); i++) {
        uint32_t address = rd32(self, 0x2c + 4 * (ptrdiff_t)i);
        const uint8_t *obj;
        wr32(self, 0x1c, address);
        wr32(self, 0x20, address);
        obj = object_at(host, address);
        if (rd32(obj, 0xab2) == 0) continue;
        if (rd32(world->records_5bb5e5, (ptrdiff_t)(rds16(obj, 0xab0) * 0x8d) + 0x4d) != 1) continue;
        for (j = 0; j < rds16(obj, 0xaa); j++) {
            uint32_t row_address = address + (uint32_t)j * 0x26u + 0x6ecu;
            const uint8_t *row;
            wr32(self, 0x24, row_address);
            row = object_at(host, row_address);
            if (rds16(row, 0) != (int32_t)world->word_5bb50b) continue;
            if (rds16(row, 4) != 1) continue;
            if (y < rds32(row, 0x1a)) continue;
            if (y > rds32(row, 0x22)) continue;
            if (x < rds32(row, 0x16)) continue;
            if (x > rds32(row, 0x1e)) continue;
            if ((int32_t)world->word_583a29 != -1) {
                if (world->value_5b44f8 == 0) {
                    world->value_5b44f0 = (uint32_t)(int32_t)world->word_583a29 + 0x25u;
                    world->value_5d162d = world->value_571ad3;
                }
            } else {
                if (world->value_5b44f8 == 0) {
                    world->value_5b44f0 = 0;
                    world->value_5d162d = world->value_5d0377;
                }
            }
            world->value_5b44f4 = 1;
            world->value_5d1631 = (world->value_5b44f0 << 5) + (world->value_5b44f4 << 4) + 0x5b160cu;
            world->value_5d1639 = 1;
            world->value_5c39e5 = (uint32_t)rds16(obj, 0xab0);
            return 1;
        }
    }
    return 0;
}
