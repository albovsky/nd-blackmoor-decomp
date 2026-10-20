#include "original_methods_fl31c.h"

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

/* ---- 0x4e2faa release_cells ------------------------------------------------------------------------------------------------------ */
void m4e2faa_release_cells(uint8_t *self, const Fl18Host *host)
{
    int32_t i;
    for (i = 0; i < 0x1a; i++) call0(host, 0x4e1d34, (uintptr_t)self + (uintptr_t)(uint32_t)((uint32_t)i * 0x18fu + 0x1ca2u));
    call0(host, 0x4e2dd3, (uintptr_t)self);
    call1(host, 0x4c92c5, 0x5cf659, rd16(self, 0x140a));
    call1(host, 0x4c92c5, 0x5cf659, rd16(self, 0x140c));
    if (rd32(self, 0x6ce) != 0) call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)self + 0x6ce);
}

/* ---- 0x4c2790 new_record --------------------------------------------------------------------------------------------------------- */
uint32_t m4c2790_new_record(uint8_t *self, uint32_t a, uint32_t b, uint32_t c, uint32_t text, const Fl31cWorld *world, const Fl18Host *host)
{
    uint32_t buf = call1(host, 0x51dc43, 0, 0x59);
    uint8_t *rec, *str;
    uint32_t len;
    if (buf == 0) {
        call2(host, 0x42639d, 0x583979, 0x553be8, b);
        call0(host, 0x4c97b4, (uintptr_t)self);
        return 0;
    }
    rec = res(host, buf);
    memset(rec, 0, 0x59);                        /* rep stosd (0x16 dwords), stosb */
    str = res(host, text);
    for (len = 0; str[len] != 0; len++) {
    }
    if (len >= 0x19) str[0x18] = 0;
    for (len = 0; str[len] != 0; len++) {        /* the length is measured again, counting the NUL */
    }
    len += 1;
    memcpy(rec + 8, str, len);                   /* rep movsd (len >> 2 dwords), rep movsb (len & 3 bytes): the same bytes */
    wr32(rec, 4, c);
    wr16(rec, 0x21, 0x59);
    wr16(rec, 0x33, world->word_639893);
    wr32(rec, 0x55, 0);
    call3(host, 0x4181c6, 0x5d2f31, a, b, buf);
    if (rd32(res(host, buf), 0) == 0) {
        call2(host, 0x42639d, 0x583979, 0x553c40, b);
        call0(host, 0x4c97b4, (uintptr_t)self);
        return 0;
    }
    return buf;
}

/* ---- 0x4eba54 retarget_words ----------------------------------------------------------------------------------------------------- */
void m4eba54_retarget_words(uint8_t *self, const Fl31cWorld *world, const Fl18Host *host)
{
    int16_t row = 0;                             /* the word local [ebp-4], never changed */
    wr32(self, 0xfc6, 0);
    while ((int32_t)rd32(self, 0xfc6) < 2) {
        uint32_t i = rd32(self, 0xfc6);
        if (rd32(self, (ptrdiff_t)(uint32_t)(i * 0xf7u) + 0x985) != 0)
            call0(host, 0x4e1d34, (uintptr_t)self + (uintptr_t)(uint32_t)(i * 0x18fu + 0xca8u));
        wr32(self, 0xfc6, rd32(self, 0xfc6) + 1);
    }
    wr32(self, 0xfc6, 0);
    while ((int32_t)rd32(self, 0xfc6) < rds16(self, 0x28da)) {
        uint32_t j = rd32(self, 0xfc6);
        ptrdiff_t at = (ptrdiff_t)(int32_t)((uint32_t)((int32_t)row * 0x320) + j * 2u);
        if (rds16(world->words_59f27b, at) == 8) wr16(world->words_59f27b, at, rd16(self, 0xb85));
        wr32(self, 0xfc6, rd32(self, 0xfc6) + 1);
    }
    call0(host, 0x4eb9c8, (uintptr_t)self);
}

/* ---- 0x4edb97 release_members ---------------------------------------------------------------------------------------------------- */
void m4edb97_release_members(uint8_t *self, const Fl18Host *host)
{
    static const struct {
        uint16_t flag, arg;
    } members[4] = {{0x675, 0x9b}, {0x679, 0xcc}, {0x67d, 0xfd}, {0x681, 0x12e}};
    int k;
    if (rd32(self, 0x15f) != 0) call0(host, 0x4e1d34, (uintptr_t)self + 0x31c);
    if (rd32(self, 0x252) != 0) call0(host, 0x4eead0, (uintptr_t)self + 0x4b7);
    if (rd32(self, 0x4ab) != 0) call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)self + 0x4ab);
    for (k = 0; k < 4; k++) {
        if (rd32(self, members[k].flag) != 0) {
            call1(host, 0x4fba69, 0x5c3a67, (uintptr_t)self + members[k].arg);
            wr32(self, members[k].flag, 0);
        }
    }
    call0(host, 0x4edae5, (uintptr_t)self);
}

/* ---- 0x4db870 load_cursor -------------------------------------------------------------------------------------------------------- */
void m4db870_load_cursor(uint8_t *self, Fl31cWorld *world, const Fl18Host *host)
{
    uint32_t pair[2] = {0, 0};                   /* the local that 0x4daeb5 is given the address of */
    const uint8_t *p;
    uint32_t x, y, e;
    call2(host, 0x4dae88, 0x5830a6, 0, 0);
    if ((int32_t)world->word_583a29 == -1) {
        world->dword_5b44f0 = 0;
        world->dword_5d162d = world->dword_5d0377;
    } else {
        world->dword_5b44f0 = (uint32_t)((int32_t)world->word_583a29 + 0x25);
        world->dword_5d162d = world->dword_571ad3;
    }
    world->dword_5b44f4 = 0;
    p = res(host, call1(host, 0x4daeb5, 0x5830a6, (uintptr_t)pair));
    x = rd32(p, 0);                              /* both are read before anything is stored (the pair may lie inside self) */
    y = rd32(p, 4);
    wr32(self, 0x14, x);
    wr32(self, 0x18, y);
    wr32(self, 0x1c, rd32(self, 0x14));
    wr32(self, 0x20, rd32(self, 0x18));
    world->dword_583106 = rd32(self, 0x18);
    wr32(self, 0x28, world->dword_583106);
    e = (world->dword_5b44f4 << 2) + world->dword_5b44f0 * 8u;
    world->dword_58310e = rd32(self, 0x18) + (uint32_t)rds16(world->table_5b3790, (ptrdiff_t)(int32_t)e + 2) - 1u;
    wr32(self, 0x30, world->dword_58310e);
    world->dword_583102 = rd32(self, 0x14);
    wr32(self, 0x24, world->dword_583102);
    e = (world->dword_5b44f4 << 2) + world->dword_5b44f0 * 8u;
    world->dword_58310a = rd32(self, 0x14) + (uint32_t)rds16(world->table_5b3790, (ptrdiff_t)(int32_t)e) - 1u;
    wr32(self, 0x2c, world->dword_58310a);
}

/* ---- 0x47cd90 pick_variant: the body shared by the three near-identical methods 0x47cd90, 0x47ce6f and 0x47cf4e (they differ only in the constants below) ------- */
static uint32_t record_address(const uint8_t *self, uint32_t index, uint32_t base)
{
    return rd32(self, 0xc) + index * 0xb6u + base;
}

static void pick_variant(uint8_t *self, const Fl18Host *host, uint32_t sel, uint32_t base, int32_t count, uint32_t s1, uint32_t s2)
{
    int32_t i;
    int found = 0;
    wr32(self, sel, 0xffffffffu);
    for (i = 0; i < count; i++) {
        if (call2(host, 0x516530, 0, record_address(self, (uint32_t)i, base), s1) != 0) {
            found = 1;
            break;
        }
    }
    if (!found) return;
    for (;;) {
        int32_t r = (int32_t)call0(host, 0x50cd50, 0);
        wr32(self, sel, (uint32_t)(r % count));                    /* cdq, idiv: the remainder has the sign of r */
        if (call2(host, 0x516530, 0, record_address(self, rd32(self, sel), base), s2) != 0) {
            call1(host, 0x47d02d, (uintptr_t)self, record_address(self, rd32(self, sel), base));
            return;
        }
    }
}

/* ---- 0x47cd90 pick_variant_a: record offset 0x4c8, selector +0x2b8, 5 records, strings 0x54d104 / 0x54d110 -------------------------------------- */
void m47cd90_pick_variant_a(uint8_t *self, const Fl18Host *host)
{
    pick_variant(self, host, 0x2b8, 0x4c8, 5, 0x54d104, 0x54d110);
}

/* ---- 0x47ce6f pick_variant_b: record offset 0x856, selector +0x2bc, 10 records, strings 0x54d11c / 0x54d128 ------------------------------------- */
void m47ce6f_pick_variant_b(uint8_t *self, const Fl18Host *host)
{
    pick_variant(self, host, 0x2bc, 0x856, 10, 0x54d11c, 0x54d128);
}

/* ---- 0x47cf4e pick_variant_c: record offset 0xf72, selector +0x2c0, 10 records, strings 0x54d134 / 0x54d140 ------------------------------------- */
void m47cf4e_pick_variant_c(uint8_t *self, const Fl18Host *host)
{
    pick_variant(self, host, 0x2c0, 0xf72, 10, 0x54d134, 0x54d140);
}
