#include "original_methods_fl32a.h"

#include <string.h>

#if defined(__GNUC__)
#define FL32A_UNUSED __attribute__((unused))
#else
#define FL32A_UNUSED
#endif

FL32A_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL32A_UNUSED static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL32A_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL32A_UNUSED static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

FL32A_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

FL32A_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

FL32A_UNUSED static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    const uintptr_t a[2] = {a0, a1};
    return callv(host, callee, this_ptr, a, 2);
}

/* ---- 0x40425d read_text_word (the body shared by 0x40425d, 0x404298 and 0x4042d3; each symbol below cites its own address and carries its own field offset) -------- */
static uint16_t read_text_word(uint8_t *self, ptrdiff_t field, const Fl18Host *host)
{
    uint8_t buffer[0x14] = {0};
    uint32_t r;
    call2(host, 0x51d5b2, (uintptr_t)(self + field), (uintptr_t)buffer, 0x13);
    r = call1(host, 0x50cb1b, 0, (uintptr_t)buffer);
    return (uint16_t)r;
}

/* ---- 0x4029a9 toggle_dword (the body shared by 0x4029a9, 0x4029f0 and 0x402a37): `table` is the host memory of the dword array base (0x5e60da, 0x5e60de or 0x5e60e2) ---- */
static void toggle_dword(uint8_t *self, uint8_t *table)
{
    if (rd32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4) == 1)
        wr32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4, 0);
    else
        wr32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4, 1);
}

/* ---- 0x40425d read_text_cc ---------------------------------------------------------------------------------------------------- */
void m40425d_read_text_cc(uint8_t *self, Fl32aWorld *world, const Fl18Host *host)
{
    world->word_5ec33e = read_text_word(self, 0xcc, host);
    call0(host, 0x4033db, (uintptr_t)self);
}

/* ---- 0x404298 read_text_10c --------------------------------------------------------------------------------------------------- */
void m404298_read_text_10c(uint8_t *self, Fl32aWorld *world, const Fl18Host *host)
{
    world->word_5ec340 = read_text_word(self, 0x10c, host);
    call0(host, 0x4033db, (uintptr_t)self);
}

/* ---- 0x4042d3 read_text_1cc --------------------------------------------------------------------------------------------------- */
void m4042d3_read_text_1cc(uint8_t *self, Fl32aWorld *world, const Fl18Host *host)
{
    world->word_5e5688 = read_text_word(self, 0x1cc, host);
    call0(host, 0x4033db, (uintptr_t)self);
}

/* ---- 0x4029a9 toggle_5e60da ---------------------------------------------------------------------------------------------------- */
void m4029a9_toggle_5e60da(uint8_t *self, Fl32aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da + 0);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x4029f0 toggle_5e60de ---------------------------------------------------------------------------------------------------- */
void m4029f0_toggle_5e60de(uint8_t *self, Fl32aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da + 4);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402a37 toggle_5e60e2 ---------------------------------------------------------------------------------------------------- */
void m402a37_toggle_5e60e2(uint8_t *self, Fl32aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da + 8);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x4067eb toggle_5e350e ---------------------------------------------------------------------------------------------------- */
void m4067eb_toggle_5e350e(uint8_t *self, Fl32aWorld *world, const Fl18Host *host)
{
    if (world->dword_5e350e == 1) {
        world->dword_5e350e = 0;
    } else {
        world->dword_5e350e = 1;
        if ((int16_t)world->word_5e335e == 1) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406832 toggle_5e3512 ---------------------------------------------------------------------------------------------------- */
void m406832_toggle_5e3512(uint8_t *self, Fl32aWorld *world, const Fl18Host *host)
{
    if (world->dword_5e3512 == 1) {
        world->dword_5e3512 = 0;
    } else {
        world->dword_5e3512 = 1;
        if ((int16_t)world->word_5e335e == 2) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* ---- 0x406879 toggle_5e3516 ---------------------------------------------------------------------------------------------------- */
void m406879_toggle_5e3516(uint8_t *self, Fl32aWorld *world, const Fl18Host *host)
{
    if (world->dword_5e3516 == 1) {
        world->dword_5e3516 = 0;
    } else {
        world->dword_5e3516 = 1;
        if ((int16_t)world->word_5e335e == 3) world->word_5e335e = 0xffff;
    }
    call0(host, 0x404be1, (uintptr_t)self);
}

/* FNS-END */
