#include "original_methods_fl33c.h"

#include <string.h>

#if defined(__GNUC__)
#define FL33C_UNUSED __attribute__((unused))
#else
#define FL33C_UNUSED
#endif

FL33C_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL33C_UNUSED static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL33C_UNUSED static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

FL33C_UNUSED static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL33C_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* host memory behind an original address (writable: the host owns the memory; the interface only says const) */
FL33C_UNUSED static uint8_t *res(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

FL33C_UNUSED static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

FL33C_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

FL33C_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

FL33C_UNUSED static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    const uintptr_t a[2] = {a0, a1};
    return callv(host, callee, this_ptr, a, 2);
}

FL33C_UNUSED static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    const uintptr_t a[3] = {a0, a1, a2};
    return callv(host, callee, this_ptr, a, 3);
}

/* ---- 0x4c6929 copy_masked ------------------------------------------------------------------------------------------------------ */
/* the three calls of the two size/argument error reports (the formats differ) */
static void report_4c6929(uint8_t *self, uint32_t format, uint32_t d, uint32_t r1, uint32_t r2, const Fl18Host *host)
{
    uint8_t msg[0x120];
    uintptr_t args[11];
    const uint8_t *p1 = res(host, r1), *p2 = res(host, r2);
    memset(msg, 0, sizeof msg);
    args[0] = (uintptr_t)msg;
    args[1] = format;
    args[2] = d;
    args[3] = rd32(p1, 0); args[4] = rd32(p1, 4); args[5] = rd32(p1, 8); args[6] = rd32(p1, 0xc);
    args[7] = rd32(p2, 0); args[8] = rd32(p2, 4); args[9] = rd32(p2, 8); args[10] = rd32(p2, 0xc);
    callv(host, 0x50ca3e, 0, args, 11);
    call3(host, 0x52139c, 0, (uintptr_t)msg, 0, 0);
    call0(host, 0x4c97b4, (uintptr_t)self);
}

int m4c6929_copy_masked(uint8_t *self, uint32_t a, uint32_t b, uint32_t c, uint32_t r1, uint32_t r2, uint32_t r3, uint32_t d, const Fl33cWorld *world, const Fl18Host *host)
{
    uint8_t desc[0x80];
    uintptr_t five[5];
    uint32_t v1, v2, src, dst, mask, rows, cols, r, col;
    int32_t sstep, dstep;
    const uint8_t *p1 = res(host, r1), *p2 = res(host, r2), *p3 = res(host, r3), *pa;
    if (world->word_63a4cd != 0) {
        uint32_t dx1 = rd32(p1, 8) - rd32(p1, 0), dy1 = rd32(p1, 0xc) - rd32(p1, 4);
        uint32_t dx2 = rd32(p2, 8) - rd32(p2, 0), dy2 = rd32(p2, 0xc) - rd32(p2, 4);
        if (dx1 != dx2 || dy1 != dy2) {
            report_4c6929(self, 0x555054, d, r1, r2, host);
            return 0;
        }
        if (a == 0 || b == 0) {
            report_4c6929(self, 0x5550e8, d, r1, r2, host);
            return 0;
        }
    }
    memset(desc, 0, sizeof desc);
    five[0] = b; five[1] = r2; five[2] = (uintptr_t)desc; five[3] = d; five[4] = 0x20;
    callv(host, 0x4c4067, (uintptr_t)self, five, 5);
    if (a == 0) return 1;                                  /* the original reads the word at 0x2f here and faults */
    pa = res(host, a);
    v1 = rd32(desc, 0x10);
    v2 = rd32(desc, 0x24);
    sstep = (int32_t)rds16(pa, 0x2f) / 2;
    dstep = (int32_t)v1 / 2;
    src = rd32(pa, 0) + rd32(p1, 4) * (uint32_t)rds16(pa, 0x2f) + rd32(p1, 0) * (uint32_t)(int32_t)world->word_639895;
    mask = c + rd32(p3, 4) * (rd32(p3, 8) + 1u) + rd32(p3, 0);
    rows = rd32(p1, 0xc) - rd32(p1, 4) + 1u;
    cols = rd32(p1, 8) - rd32(p1, 0) + 1u;
    dst = v2;
    for (r = 0; (int32_t)r < (int32_t)rows; r++) {
        for (col = 0; (int32_t)col < (int32_t)cols; col++) {
            if (*res(host, mask + col) != 0) wr16(res(host, dst + col * 2u), 0, rd16(res(host, src + col * 2u), 0));
        }
        src += (uint32_t)sstep * 2u;
        dst += (uint32_t)dstep * 2u;
        mask += rd32(p3, 8) + 1u;
    }
    call3(host, 0x4c4202, (uintptr_t)self, b, r2, 0x555164);
    if (b == rd32(self, 0xc)) call1(host, 0x4c952f, (uintptr_t)self, r2);
    return 0;
}


/* ---- 0x416af3 apply_patches ---------------------------------------------------------------------------------------------------- */
static uint32_t rdd(const Fl18Host *host, uint32_t a) { return rd32(res(host, a), 0); }
static uint32_t rdw(const Fl18Host *host, uint32_t a) { return rd16(res(host, a), 0); }
static uint32_t rdb(const Fl18Host *host, uint32_t a) { return *res(host, a); }

/* mov ecx, count; shr ecx, 2; rep movsd; mov ecx, count; and ecx, 3; rep movsb: forward, dwords first */
static void rep_movs(const Fl18Host *host, uint32_t dst, uint32_t src, uint32_t count)
{
    uint32_t n = count >> 2, i;
    uint8_t *d;
    const uint8_t *s;
    if (count == 0) return;
    d = res(host, dst);
    s = res(host, src);
    for (i = 0; i < n; i++) {
        uint8_t t[4];
        memcpy(t, s + 4u * i, 4);
        memcpy(d + 4u * i, t, 4);
    }
    for (i = 4u * n; i < count; i++) d[i] = s[i];
}

int m416af3_apply_patches(uint32_t hdr, uint32_t out, uint32_t size, uint32_t stream, uint32_t base, uint32_t flag, const Fl18Host *host)
{
    uint32_t count = rdd(host, hdr + 0xa);
    uint32_t kind = rdb(host, hdr + 0xe);
    uint32_t idx = 0, p, data, k, off, m;
    if (kind == 1) {
        while ((int32_t)idx < (int32_t)count) {
            uint32_t op = rdb(host, stream + idx);
            if (op == 0x20) {
                p = stream + idx;
                idx += 9;
                rep_movs(host, out + rdd(host, p + 1) * 2u, stream + idx, rdd(host, p + 5) << 1);
                idx = idx + rdd(host, p + 5) * 2u;
            } else if (op == 0x40) {
                p = stream + idx;
                idx += 0xb;
                call3(host, 0x43ef77, 0x5d2f2d, out + rdd(host, p + 3) * 2u, rdw(host, p + 1), rdd(host, p + 7));
            } else if (op == 0x80) {
                p = stream + idx;
                idx += 6;
                data = stream + idx;
                idx = idx + rdb(host, p + 1) * 2u;
                for (k = 0; (int32_t)k < (int32_t)rdd(host, p + 2); k++) {
                    off = rdd(host, stream + idx);
                    rep_movs(host, out + off * 2u, data, rdb(host, p + 1) * 2u);
                    idx += 4;
                }
            } else {
                return 1;                                  /* the original jumps to the loop head again and again */
            }
        }
        call2(host, 0x4c7314, 0x5cf659, out, size);
    } else if (kind == 2) {
        if (flag == 0) rep_movs(host, out, base, size);
        while ((int32_t)idx < (int32_t)count) {
            uint32_t op = rdb(host, stream + idx);
            if (op == 0x20) {
                p = stream + idx;
                idx += 9;
                rep_movs(host, out + rdd(host, p + 1) * 2u, stream + idx, rdd(host, p + 5) << 1);
                call2(host, 0x4c7314, 0x5cf659, out + rdd(host, p + 1) * 2u, rdd(host, p + 5) << 1);
                idx = idx + rdd(host, p + 5) * 2u;
            } else if (op == 0x40) {
                p = stream + idx;
                idx += 0xb;
                call3(host, 0x43ef77, 0x5d2f2d, out + rdd(host, p + 3) * 2u, rdw(host, p + 1), rdd(host, p + 7));
                call2(host, 0x4c7314, 0x5cf659, out + rdd(host, p + 3) * 2u, rdd(host, p + 7) << 1);
            } else if (op == 0x80) {
                p = stream + idx;
                idx += 6;
                data = stream + idx;
                idx = idx + rdb(host, p + 1) * 2u;
                for (k = 0; (int32_t)k < (int32_t)rdd(host, p + 2); k++) {
                    off = rdd(host, stream + idx);
                    m = rdb(host, p + 1);
                    rep_movs(host, out + off * 2u, data, m * 2u);
                    call2(host, 0x4c7314, 0x5cf659, out + off * 2u, rdb(host, p + 1) * 2u);
                    idx += 4;
                }
            } else {
                return 1;
            }
        }
    }
    return 0;
}

/* ---- 0x4db38a update_cursor ---------------------------------------------------------------------------------------------------- */
static uint32_t abs_cdq(uint32_t v)
{
    uint32_t s = (int32_t)v < 0 ? 0xffffffffu : 0u;
    return (v ^ s) - s;
}

void m4db38a_update_cursor(uint8_t *self, Fl33cWorld *world, const Fl18Host *host)
{
    uint32_t pair[2] = {0, 0};                   /* the local that 0x4daeb5 is given the address of */
    const uint8_t *p;
    uint32_t x, y, rp, v, e, f;
    call0(host, 0x4dadff, 0x5830a6);
    world->value_5d16cd = 0;
    world->value_5d1683 = 0;
    rp = call1(host, 0x4daeb5, 0x5830a6, (uintptr_t)pair);
    p = rp == (uint32_t)(uintptr_t)pair ? (const uint8_t *)pair : res(host, rp);
    x = rd32(p, 0);
    y = rd32(p, 4);
    wr32(self, 0x14, x);
    wr32(self, 0x18, y);
    call0(host, 0x4dbb13, (uintptr_t)self);
    wr32(self, 0x94, abs_cdq(rd32(self, 0x14) - rd32(self, 0x34)));
    wr32(self, 0x98, abs_cdq(rd32(self, 0x18) - rd32(self, 0x38)));
    if ((int32_t)rd32(self, 0x94) > (int32_t)world->word_5d2f0d) {
        if ((int32_t)(rd32(self, 0x14) - rd32(self, 0x34)) > 0) wr32(self, 0x14, rd32(self, 0x34) + (uint32_t)(int32_t)world->word_5d2f0d);
        else wr32(self, 0x14, rd32(self, 0x34) - (uint32_t)(int32_t)world->word_5d2f0d);
    }
    if ((int32_t)rd32(self, 0x98) > (int32_t)world->word_5d2f0f) {
        if ((int32_t)(rd32(self, 0x18) - rd32(self, 0x38)) > 0) wr32(self, 0x18, rd32(self, 0x38) + (uint32_t)(int32_t)world->word_5d2f0f);
        else wr32(self, 0x18, rd32(self, 0x38) - (uint32_t)(int32_t)world->word_5d2f0f);
    }
    call0(host, 0x4dbb13, (uintptr_t)self);
    v = world->value_583204 - 2u;
    if (v > 3) {
        if (call2(host, 0x4d57e8, 0x570450, (uintptr_t)(self + 0x34), 0x583186) != 0) {
            call0(host, 0x4db780, (uintptr_t)self);
        } else if (call2(host, 0x4d5834, 0x570450, (uintptr_t)(self + 0x34), 0x583186) != 0) {
            call0(host, 0x4db817, (uintptr_t)self);
        } else {
            uint32_t r;
            wr32(self, 0x28, rd32(self, 0x38));
            wr32(self, 0x30, rd32(self, 0x40));
            wr32(self, 0x24, rd32(self, 0x34));
            wr32(self, 0x2c, rd32(self, 0x3c));
            world->value_5d1683 = 1;
            r = call2(host, 0x4d5316, 0x570450, (uintptr_t)(self + 0x34), 0x583186);
            if (r != 0) {
                wr32(self, 0x54, rd32(self, 0x34));
                wr32(self, 0x58, rd32(self, 0x38));
                wr32(self, 0x5c, rd32(self, 0x3c));
                wr32(self, 0x60, rd32(self, 0x40));
                wr32(self, 0x44, rd32(self, 0x34) - world->value_583186);
                wr32(self, 0x4c, rd32(self, 0x3c) - world->value_583186);
                wr32(self, 0x48, rd32(self, 0x38) - world->value_58318a);
                wr32(self, 0x50, rd32(self, 0x40) - world->value_58318a);
                call3(host, 0x4d56e2, 0x570450, (uintptr_t)(self + 0x44), (uintptr_t)(self + 0x54), r);
                world->value_5d16cd = 1;
            } else if (world->word_63a4cd != 0) {
                uintptr_t a[10];
                a[0] = 0x63888b; a[1] = 0x55af64; a[2] = rd32(self, 0x24); a[3] = rd32(self, 0x28); a[4] = rd32(self, 0x2c); a[5] = rd32(self, 0x30);
                a[6] = world->value_583186; a[7] = world->value_58318a; a[8] = world->value_58318e; a[9] = world->value_583192;
                callv(host, 0x50ca3e, 0, a, 10);
                call1(host, 0x44a2b7, 0, 0x63888b);
            }
        }
    }
    wr32(self, 0x38, rd32(self, 0x18));
    e = (world->value_5b44f4 << 2) + world->value_5b44f0 * 8u;
    wr32(self, 0x40, rd32(self, 0x38) + (uint32_t)rds16(world->table_5b3790, (ptrdiff_t)(int32_t)e + 2) - 1u);
    wr32(self, 0x34, rd32(self, 0x14));
    e = (world->value_5b44f4 << 2) + world->value_5b44f0 * 8u;
    wr32(self, 0x3c, rd32(self, 0x34) + (uint32_t)rds16(world->table_5b3790, (ptrdiff_t)(int32_t)e) - 1u);
    call2(host, 0x4dae88, 0x5830a6, rd32(self, 0x14), rd32(self, 0x18));
    wr32(self, 0x1c, rd32(self, 0x14));
    wr32(self, 0x20, rd32(self, 0x18));
    f = (world->value_5b44f0 << 4) + world->value_5b44f4 * 8u;
    wr32(self, 0x9c, world->value_583106 + rd32(world->table_5b30cc, (ptrdiff_t)(int32_t)f + 4));
    f = (world->value_5b44f0 << 4) + world->value_5b44f4 * 8u;
    wr32(self, 0xa0, world->value_583102 + rd32(world->table_5b30cc, (ptrdiff_t)(int32_t)f));
    world->value_5c3a53 = rd32(self, 0xa0);
    world->value_5c3a57 = rd32(self, 0x9c);
}

/* ---- 0x4d2c20 layout_text ------------------------------------------------------------------------------------------------------ */
static uint32_t sdw(const Fl18Host *host, uint32_t a) { return (uint32_t)(int32_t)(int16_t)rdw(host, a); }     /* movsx eax, word ptr [a] */

uint32_t m4d2c20_layout_text(uint32_t text, uint32_t font, uint32_t metrics, uint32_t x, uint32_t y, uint32_t a, uint32_t b, uint32_t sel, Fl33cWorld *world, const Fl18Host *host)
{
    uint32_t s = (uint32_t)(int32_t)(int16_t)sel * 8u;
    if (world->word_63a4cd != 0) {
        if (a == 0 || b == 0) {
            call3(host, 0x52139c, 0, 0x55a344, 0, 0);
            call0(host, 0x4c97b4, 0x5cf659);
        }
    }
    world->value_63a8ec = (uint32_t)(int32_t)(int16_t)y;
    world->value_63a8e4 = 0;
    world->value_63a8e0 = (uint32_t)(int32_t)(int16_t)x;
    world->value_63a8e8 = 0;
    for (;; text++) {
        uint32_t c = (uint32_t)(int32_t)(int8_t)rdb(host, text);
        uint16_t idx = 0;                         /* the local word that 0x4d214b stores into */
        uint32_t r, i16, rect[4];
        int emit = 0;
        if (c == 0) break;
        r = call3(host, 0x4d214b, 0, c & 0xffu, font, (uintptr_t)&idx);
        if (r != 0) {
            emit = 1;
        } else if (call1(host, 0x50d651, 0, c) != 0 && call1(host, 0x50d67f, 0, c) != 0 && (c & 0xffu) < 0x80) {
            idx = (uint16_t)(c + sdw(host, font + 0x53) - 0x41u);
            emit = 1;
        } else if (call1(host, 0x50d651, 0, c) != 0 && call1(host, 0x50d6a7, 0, c) != 0 && (c & 0xffu) < 0x80) {
            idx = (uint16_t)(c + sdw(host, font + 0x55) - 0x61u);
            emit = 1;
        } else if (call1(host, 0x50d6cf, 0, c) != 0 && (c & 0xffu) < 0x80) {
            idx = (uint16_t)(c + sdw(host, font + 0x57) - 0x30u);
            emit = 1;
        }
        if (!emit) {
            world->value_63a8e0 += sdw(host, font + 0x4f);
            world->value_63a8e8 = world->value_63a8e0 + sdw(host, font + 0x4f) - 1u;
            continue;
        }
        i16 = (uint32_t)(int32_t)(int16_t)idx * 16u;
        rect[1] = rdd(host, font + i16 + 0xc7) + rdd(host, font + s + 0x43);
        rect[3] = rdd(host, font + i16 + 0xcf) + rdd(host, font + s + 0x43);
        rect[0] = rdd(host, font + i16 + 0xc3) + rdd(host, font + s + 0x3f);
        rect[2] = rdd(host, font + i16 + 0xcb) + rdd(host, font + s + 0x3f);
        {
            uint32_t m4 = (uint32_t)(int32_t)(int16_t)idx * 4u;
            uintptr_t args[5];
            world->value_63a8e4 = world->value_63a8ec - sdw(host, metrics + m4 + 2u) + 1u;
            world->value_63a8e8 = world->value_63a8e0 + sdw(host, metrics + m4) - 1u;
            args[0] = a; args[1] = b; args[2] = (uintptr_t)rect; args[3] = 0x63a8e0; args[4] = 0x55a37c;
            callv(host, 0x4c5d4b, 0x5cf659, args, 5);
            m4 = (uint32_t)(int32_t)(int16_t)idx * 4u;
            world->value_63a8e0 = sdw(host, font + 0x51) + world->value_63a8e0 + sdw(host, metrics + m4);
            world->value_63a8e8 = world->value_63a8e0 + sdw(host, metrics + m4) - 1u;
        }
    }
    return 0x63a8e0;
}
