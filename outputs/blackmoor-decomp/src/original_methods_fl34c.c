#include "original_methods_fl34c.h"

#include <string.h>

#if defined(__GNUC__)
#define FL34C_UNUSED __attribute__((unused))
#else
#define FL34C_UNUSED
#endif

FL34C_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL34C_UNUSED static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL34C_UNUSED static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL34C_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* host memory behind an original address (the host owns the memory; the interface only says const) */
FL34C_UNUSED static const uint8_t *res(const Fl18Host *host, uint32_t address)
{
    return host->resolve(host->context, address);
}

FL34C_UNUSED static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

/* ---- 0x4d0abc, 0x4d0c17, 0x4e01fb post_message ---------------------------------------------------------------------------------- */
/* The three are one body with different constants: the three globals g1 < g2 < g3 (dwords read in the order g3, g2, 0x5cf665, g1), the constant `text` pushed first, and the
 * word that is cleared (`clear`; the word 0x5bb1c4 = 2 is the same in all three). All the reads happen before the call, the stores after it, as in the original. */
static uint32_t post_message(Fl34cWorld *world, uint16_t *clear, uint32_t g1, uint32_t g2, uint32_t g3, uint32_t text, const Fl18Host *host)
{
    uintptr_t a[5];
    uint32_t r;
    a[3] = rd32(res(host, g3), 0);
    a[2] = rd32(res(host, g2), 0);
    a[1] = rd32(res(host, 0x5cf665), 0);
    a[0] = rd32(res(host, g1), 0);
    a[4] = text;
    r = callv(host, 0x4c5377, 0x5cf659, a, 5);
    world->word_5bb1c4 = 2;
    *clear = 0;
    return r;
}

/* 0x4d0abc m4d0abc_post_message: globals 0x5d2a1f / 0x5d2a23 / 0x5d2a27, text 0x55a05c, word 0x63a97c (see post_message above) */
uint32_t m4d0abc_post_message(Fl34cWorld *world, const Fl18Host *host)
{
    return post_message(world, &world->word_63a97c, 0x5d2a1f, 0x5d2a23, 0x5d2a27, 0x55a05c, host);
}

/* 0x4d0c17 m4d0c17_post_message: globals 0x5d2bdb / 0x5d2bdf / 0x5d2be3, text 0x55a0e8, word 0x63a97e (see post_message above) */
uint32_t m4d0c17_post_message(Fl34cWorld *world, const Fl18Host *host)
{
    return post_message(world, &world->word_63a97e, 0x5d2bdb, 0x5d2bdf, 0x5d2be3, 0x55a0e8, host);
}

/* 0x4e01fb m4e01fb_post_message: globals 0x5d2819 / 0x5d281d / 0x5d2821, text 0x55ba9c, word 0x63a9d0 (see post_message above) */
uint32_t m4e01fb_post_message(Fl34cWorld *world, const Fl18Host *host)
{
    return post_message(world, &world->word_63a9d0, 0x5d2819, 0x5d281d, 0x5d2821, 0x55ba9c, host);
}

/* ---- 0x4cca9c fill_record ------------------------------------------------------------------------------------------------------ */
/* 0x4cca9c m4cca9c_fill_record: the call comes first, the three stores after it (rec may be changed by the callee and may alias self) */
uint32_t m4cca9c_fill_record(uint8_t *self, uint8_t *rec, uint32_t a1, uint32_t a2, uint32_t a3, const Fl18Host *host)
{
    uintptr_t a[1];
    a[0] = (uintptr_t)rec;
    (void)callv(host, 0x4cc962, (uintptr_t)self, a, 1);
    wr32(rec, 0, a1);
    wr32(rec, 0x14, a2);
    wr32(rec, 0x28, a3);
    return a3;
}

/* ---- 0x446f77 construct --------------------------------------------------------------------------------------------------------- */
/* 0x446f77 m446f77_construct: the call comes first (its writes to self are overwritten by the stores below); the offsets +0x31 and +0x35 are unaligned */
uint8_t *m446f77_construct(uint8_t *self, const Fl18Host *host)
{
    (void)callv(host, 0x51d716, (uintptr_t)self, NULL, 0);
    wr32(self, 0, 0x52ca58);
    wr32(self, 0x31, 0);
    wr32(self, 0x35, 0);
    return self;
}

/* ---- 0x4fce5e call_with_record_dword -------------------------------------------------------------------------------------------- */
/* 0x4fce5e m4fce5e_call_with_record_dword: movsx of the word, 32-bit imul by 0x8d, unaligned dword read of the table, then the call */
uint32_t m4fce5e_call_with_record_dword(int16_t index, const Fl18Host *host)
{
    uintptr_t a[1];
    uint32_t offset = (uint32_t)((int32_t)index * 0x8d);
    a[0] = rd32(res(host, 0x5bb5e5u + offset), 0);
    return callv(host, 0x4f7e93, 0x5cf1eb, a, 1);
}

/* ---- 0x4d3ffe start_flag -------------------------------------------------------------------------------------------------------- */
/* 0x4d3ffe m4d3ffe_start_flag: the store of 1 comes before the call, the byte at 0x61c6ae is read after it (mov dl, byte: zero-extended, only the byte counts) */
uintptr_t m4d3ffe_start_flag(uint8_t *self, const Fl18Host *host)
{
    uint32_t r;
    wr32(self, 0x440, 1);
    r = callv(host, 0x4dad60, 0x5830a6, NULL, 0);
    wr32(self, 0x462, 0);
    if (res(host, 0x61c6ae)[0] != 0) return r;
    wr32(self, 0x1c, 0);
    return (uintptr_t)self;
}

/* ---- 0x47a3d9 set_flags --------------------------------------------------------------------------------------------------------- */
/* 0x47a3d9 m47a3d9_set_flags: test eax, eax on the full 32-bit result of 0x4789d6 */
uintptr_t m47a3d9_set_flags(uint8_t *self, const Fl18Host *host)
{
    uint32_t x = callv(host, 0x4789d6, (uintptr_t)self, NULL, 0);
    if (x != 0) {
        wr32(self, 0x1576, 1);
        wr32(self, 0x24, 1);
        return (uintptr_t)self;
    }
    wr32(self, 0x1576, 0);
    return 0;
}
