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

