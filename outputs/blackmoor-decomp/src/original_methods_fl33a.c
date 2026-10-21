#include "original_methods_fl33a.h"

#include <string.h>

#if defined(__GNUC__)
#define FL33A_UNUSED __attribute__((unused))
#else
#define FL33A_UNUSED
#endif

FL33A_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL33A_UNUSED static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL33A_UNUSED static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

FL33A_UNUSED static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL33A_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* host memory behind an original address (writable: the host owns the memory; the interface only says const) */
FL33A_UNUSED static uint8_t *res(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

FL33A_UNUSED static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

FL33A_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

FL33A_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

FL33A_UNUSED static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    const uintptr_t a[2] = {a0, a1};
    return callv(host, callee, this_ptr, a, 2);
}

FL33A_UNUSED static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    const uintptr_t a[3] = {a0, a1, a2};
    return callv(host, callee, this_ptr, a, 3);
}

/* ---- 0x4dae88 set_cursor ------------------------------------------------------------------------------------------------------- */
uint32_t m4dae88_set_cursor(uint8_t *self, uint32_t x, uint32_t y, const Fl18Host *host)
{
    wr32(self, 0x18, x);
    wr32(self, 0x1c, y);
    return call2(host, 0x52a488, 0, x, y);     /* SetCursorPos(x, y): stdcall, x pushed last */
}

/* ---- 0x473117 mark_entry ------------------------------------------------------------------------------------------------------- */
void m473117_mark_entry(const uint8_t *self, const Fl33aWorld *world)
{
    int32_t i;
    if (rd32(self, 0x7a) == 0) return;
    if (rds16(self, 0x14) == -1) return;
    i = rds16(self, 0x14);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x4234dd push_pair -------------------------------------------------------------------------------------------------------- */
void m4234dd_push_pair(uint8_t *self, uint32_t a, uint32_t b, const Fl33aWorld *world, const Fl18Host *host)
{
    uint32_t m;
    if ((int32_t)rd32(self, 4) >= 0x80) {
        call2(host, 0x50ca3e, 0, 0x63888b, 0x5444cc);
        call3(host, 0x52139c, 0, 0x63888b, 0, 0);
        if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
    }
    m = rd32(self, 4) * 12u;
    wr32(self, (ptrdiff_t)(int32_t)m + 0xc, a);
    m = rd32(self, 4) * 12u;
    wr32(self, (ptrdiff_t)(int32_t)m + 0x10, b);
    wr32(self, 4, rd32(self, 4) + 1u);
}

/* ---- 0x4c7623 draw_frame ------------------------------------------------------------------------------------------------------- */
#define RECT(off) rd32(res(host, rect), (off))
/* 0x4c7623 m4c7623_draw_frame */
void m4c7623_draw_frame(uint8_t *self, uint32_t a, uint32_t rect, uint32_t w, const Fl18Host *host)
{
    uint8_t desc[0x80];
    uint32_t v1, v2;
    uintptr_t five[5];
    uintptr_t seven[7];
    memset(desc, 0, sizeof desc);
    w &= 0xffff;
    five[0] = a;
    five[1] = 0;
    five[2] = (uintptr_t)desc;
    five[3] = 0x5553a8;
    five[4] = 0x20;
    callv(host, 0x4c4067, (uintptr_t)self, five, 5);
    v1 = rd32(desc, 0x10);
    v2 = rd32(desc, 0x24);
    seven[0] = v2; seven[1] = v1; seven[6] = w;
    seven[2] = RECT(0); seven[3] = RECT(4); seven[4] = RECT(8); seven[5] = RECT(4);
    callv(host, 0x4c808f, (uintptr_t)self, seven, 7);
    seven[0] = v2; seven[1] = v1; seven[6] = w;
    seven[2] = RECT(0); seven[3] = RECT(0xc); seven[4] = RECT(8); seven[5] = RECT(0xc);
    callv(host, 0x4c808f, (uintptr_t)self, seven, 7);
    seven[0] = v2; seven[1] = v1; seven[6] = w;
    seven[2] = RECT(0); seven[3] = RECT(4); seven[4] = RECT(0); seven[5] = RECT(0xc);
    callv(host, 0x4c808f, (uintptr_t)self, seven, 7);
    seven[0] = v2; seven[1] = v1; seven[6] = w;
    seven[2] = RECT(8); seven[3] = RECT(4); seven[4] = RECT(8); seven[5] = RECT(0xc);
    callv(host, 0x4c808f, (uintptr_t)self, seven, 7);
    call3(host, 0x4c4202, (uintptr_t)self, a, rect, 0x5553d0);
    if (a == rd32(self, 0xc)) call1(host, 0x4c952f, (uintptr_t)self, rect);
}
#undef RECT

/* ---- 0x4bf3b8 set_text --------------------------------------------------------------------------------------------------------- */
/* repne scasb for the length (the NUL included), rep movsd for the dwords, rep movsb for the rest */
static void copy_string(uint8_t *dst, const uint8_t *src)
{
    size_t len = 1, n, i;
    while (src[len - 1] != 0) len++;
    n = len >> 2;
    for (i = 0; i < n; i++) memcpy(dst + 4 * i, src + 4 * i, 4);
    for (i = 4 * n; i < len; i++) dst[i] = src[i];
}

/* 0x4bf3b8 m4bf3b8_set_text */
uint8_t *m4bf3b8_set_text(uint8_t *self, uint32_t code, const Fl18Host *host)
{
    uint32_t v = rd32(self, 0x2c0) + 6u;
    uint8_t *text = self + 0xc0;
    uint32_t string = 0x552594;
    if (v > 5) {
        copy_string(text, res(host, string));
        return self + 0xc0;
    }
    switch (v) {
    case 0: {
        uint32_t e = call0(host, 0x52a514, 0);          /* binkw32 _BinkGetError@0 */
        call3(host, 0x50ca3e, 0, (uintptr_t)text, 0x552564, e);
        return self + 0xc0;
    }
    case 1:
        call3(host, 0x50ca3e, 0, (uintptr_t)text, 0x552540, code);
        return self + 0xc0;
    case 2: string = 0x552508; break;
    case 3: string = 0x5524e4; break;
    case 4: string = 0x552494; break;
    default: string = 0x5524bc; break;
    }
    copy_string(text, res(host, string));
    return self + 0xc0;
}

/* ---- 0x4db993 move_cursor ------------------------------------------------------------------------------------------------------ */
void m4db993_move_cursor(uint8_t *self, uint32_t a, uint32_t b, Fl33aWorld *world, const Fl18Host *host)
{
    uint32_t pair[2] = {0, 0};                   /* the local that 0x4daeb5 is given the address of */
    const uint8_t *p;
    uint32_t x, y, e, rp;
    int out;
    call2(host, 0x4dae88, 0x5830a6, a, b);
    rp = call1(host, 0x4daeb5, 0x5830a6, (uintptr_t)pair);
    /* in the game 0x4daeb5 returns its own argument, the address of the local pair; Fl18Host.call returns 32 bits, so a 64-bit host pointer comes back truncated:
     * a result equal to the low 32 bits of the pair's address is the pair itself. Any other result is an original address. */
    p = rp == (uint32_t)(uintptr_t)pair ? (const uint8_t *)pair : res(host, rp);
    x = rd32(p, 0);
    y = rd32(p, 4);
    wr32(self, 0x14, x);
    wr32(self, 0x18, y);
    world->value_5c3a53 = rd32(self, 0x14);
    world->value_5c3a57 = rd32(self, 0x18);
    out = (int32_t)rd32(self, 0x14) < (int32_t)world->value_5b377c
       || (int32_t)rd32(self, 0x14) > (int32_t)world->value_5b3784
       || (int32_t)rd32(self, 0x18) < (int32_t)world->value_5b3780
       || (int32_t)rd32(self, 0x18) > (int32_t)world->value_5b3788;
    if (out) {
        world->value_5b44f0 = 4;
        world->value_5d162d = world->value_5d0377;
    } else if ((int32_t)world->word_583a29 == -1) {
        world->value_5b44f0 = 0;
        world->value_5d162d = world->value_5d0377;
    } else {
        world->value_5b44f0 = (uint32_t)((int32_t)world->word_583a29 + 0x25);
        world->value_5d162d = world->value_571ad3;
    }
    world->value_5b44f4 = 0;
    wr32(self, 0x28, world->value_583106);
    wr32(self, 0x30, world->value_58310e);
    wr32(self, 0x24, world->value_583102);
    wr32(self, 0x2c, world->value_58310a);
    world->value_583106 = rd32(self, 0x18);
    e = (world->value_5b44f4 << 2) + world->value_5b44f0 * 8u;
    world->value_58310e = rd32(self, 0x18) + (uint32_t)rds16(world->table_5b3790, (ptrdiff_t)(int32_t)e + 2) - 1u;
    world->value_583102 = rd32(self, 0x14);
    e = (world->value_5b44f4 << 2) + world->value_5b44f0 * 8u;
    world->value_58310a = rd32(self, 0x14) + (uint32_t)rds16(world->table_5b3790, (ptrdiff_t)(int32_t)e) - 1u;
}

/* ---- 0x47d24e report_fields ---------------------------------------------------------------------------------------------------- */
static uint32_t table_dword(const Fl33aWorld *world)
{
    return rd32(world->table_5d1599, (ptrdiff_t)((int32_t)world->word_61e39c * 0x4a));
}

/* 0x47d24e m47d24e_report_fields */
void m47d24e_report_fields(Fl33aWorld *world, const Fl18Host *host)
{
    uint32_t p = world->value_61e3a4;
    uintptr_t a[5];
    int32_t i;
    uint32_t base;
    if (world->value_61e3bc == 0) return;
    if (world->value_61e3c8 != 0) {
        a[0] = world->value_5d15e3; a[1] = world->value_5cf665; a[2] = 0x583196; a[3] = 0x61e5f4; a[4] = 0x54d1a0;
        callv(host, 0x4c5377, 0x5cf659, a, 5);
        world->value_61e3c8 = 0;
    }
    if ((int8_t)*res(host, p + 0x35b) != 0) {
        a[0] = table_dword(world); a[1] = world->value_5cf665; a[2] = p + (world->value_61e624 << 4) + 0xe1; a[3] = 0x61e554; a[4] = 0x54d1c8;
        callv(host, 0x4c5377, 0x5cf659, a, 5);
    }
    base = world->value_61e624 * world->value_61e618;
    for (i = 0; i < (int32_t)world->value_61e618; i++, base++) {
        uint32_t e = world->value_61e3ac + base * 12u;
        if (rd32(res(host, e + 4), 0) == 1) {
            a[0] = table_dword(world); a[1] = world->value_5cf665; a[2] = p + (rd32(res(host, e), 0) << 4) + 0x21;
            a[3] = 0x61e3d4 + ((uint32_t)i << 4); a[4] = 0x54d1e4;
        } else {
            a[0] = world->value_5d15e3; a[1] = world->value_5cf665; a[2] = p + ((uint32_t)i << 4) + 0x111;
            a[3] = 0x61e3d4 + ((uint32_t)i << 4); a[4] = 0x54d20c;
        }
        callv(host, 0x4c5377, 0x5cf659, a, 5);
    }
}

/* ---- 0x4c7070 rotate_image ----------------------------------------------------------------------------------------------------- */
void m4c7070_rotate_image(uint8_t *self, uint32_t desc, uint32_t arg2, const Fl33aWorld *world, const Fl18Host *host)
{
    uint32_t size, bufva, k;
    int32_t w1, w2, w3, i, j;
    uint16_t product;
    uint8_t *d, *image, *buf;
    d = res(host, desc);
    image = res(host, rd32(d, 0));
    w1 = rds16(d, 0x2b);
    w2 = rds16(d, 0x2d);
    w3 = rds16(d, 0x2f);
    product = (uint16_t)((uint32_t)rds16(d, 0x2d) * (uint32_t)(int32_t)world->word_639895);
    size = rd32(d, 0x23);
    bufva = call1(host, 0x51dc43, 0, size);
    if (bufva == 0) {
        call2(host, 0x42639d, 0x583979, 0x5552e8, arg2);
        call0(host, 0x4c97b4, (uintptr_t)self);
        return;
    }
    buf = res(host, bufva);
    {
        size_t n = size >> 2, r = size & 3, q;
        for (q = 0; q < n; q++) memcpy(buf + 4 * q, image + 4 * q, 4);
        for (q = 0; q < r; q++) buf[4 * n + q] = image[4 * n + q];
    }
    k = 0;
    for (i = 0; i < w1; i++) {
        for (j = w2 - 1; j >= 0; j--) {
            uint16_t word = rd16(buf, (ptrdiff_t)((int32_t)((uint32_t)j * (uint32_t)w3) + (int32_t)((uint32_t)i * (uint32_t)(int32_t)world->word_639895)));
            wr16(image, (ptrdiff_t)k, word);
            k += 2;
        }
    }
    wr16(d, 0x2b, (uint16_t)w2);
    wr16(d, 0x2d, (uint16_t)w1);
    wr16(d, 0x2f, product);
    wr16(d, 0x31, (uint16_t)w1);
    call1(host, 0x51dc6c, 0, bufva);
}
