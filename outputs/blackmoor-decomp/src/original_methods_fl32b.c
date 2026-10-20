#include "original_methods_fl32b.h"

#include <string.h>

#if defined(__GNUC__)
#define FL32B_UNUSED __attribute__((unused))
#else
#define FL32B_UNUSED
#endif

FL32B_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL32B_UNUSED static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL32B_UNUSED static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL32B_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* host memory behind an original address (the host owns the memory; the interface only says const) */
FL32B_UNUSED static const uint8_t *res(const Fl18Host *host, uint32_t address)
{
    return host->resolve(host->context, address);
}

FL32B_UNUSED static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

FL32B_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

FL32B_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

/* ---- 0x40a613 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40a613 and 0x40a665 are the same body with three different constants. `field` is the offset of the string field (0xcc / 0x10c), `tag` the original address of the
 * four bytes that the local buffer is compared with (the compare ends at the first differing byte; only the final "all four equal" decides), world word `out` receives
 * the low 16 bits of the CRT result. The word store happens before the last call, as in the original. */
static uint32_t read_tag_word(uint8_t *self, uint16_t *out, uint32_t field, uint32_t tag, const Fl18Host *host)
{
    uint8_t buf[0x14];
    uintptr_t a[2];
    memset(buf, 0, sizeof buf);                               /* the original leaves the local uninitialised; the callee below fills it */
    a[0] = (uintptr_t)buf;
    a[1] = 0x13;
    callv(host, 0x51d5b2, (uintptr_t)self + field, a, 2);
    if (memcmp(buf, res(host, tag), 4) != 0) *out = (uint16_t)call1(host, 0x50cb1b, 0, (uintptr_t)buf);
    return call0(host, 0x4090ab, (uintptr_t)self);
}

/* 0x40a613: string field self + 0xcc, tag at the original address 0x53ec5c, word 0x5ec2d8 (see read_tag_word above) */
uint32_t m40a613_read_tag_word(uint8_t *self, Fl32bWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2d8, 0xcc, 0x53ec5c, host);
}

/* ---- 0x40a665 read_tag_word ---------------------------------------------------------------------------------------------------- */
/* 0x40a665: string field self + 0x10c, tag at the original address 0x53ec60, word 0x5ec2da (see read_tag_word above) */
uint32_t m40a665_read_tag_word(uint8_t *self, Fl32bWorld *world, const Fl18Host *host)
{
    return read_tag_word(self, &world->word_5ec2da, 0x10c, 0x53ec60, host);
}

/* ---- 0x4a9f27 reset_fields ------------------------------------------------------------------------------------------------------ */
uint8_t *m4a9f27_reset_fields(uint8_t *self)
{
    wr16(self, 0x21, 0xffff);
    wr16(self, 0x29, 0xffff);
    wr32(self, 0x1d, 0);
    self[0x45] = 0;
    self[0x46] = 0;
    self[0x47] = 0;
    return self;
}

/* ---- 0x4b71f7 reset_fields ------------------------------------------------------------------------------------------------------ */
uint8_t *m4b71f7_reset_fields(uint8_t *self)
{
    wr16(self, 0x21, 0xffff);
    wr16(self, 0x2f, 0xffff);
    self[0x35] = 0;
    self[0x36] = 0;
    self[0x3b] = 0;
    return self;
}

/* ---- 0x4781fa reset_fields ------------------------------------------------------------------------------------------------------ */
uint8_t *m4781fa_reset_fields(uint8_t *self)
{
    wr16(self, 0x1e, 0xffff);
    wr16(self, 0x1c, 0xffff);
    wr32(self, 0x157a, 0);
    wr32(self, 0x157e, 0);
    wr32(self, 0x1576, 0);
    return self;
}

/* ---- 0x4afd3a reset_fields ------------------------------------------------------------------------------------------------------ */
uint8_t *m4afd3a_reset_fields(uint8_t *self)
{
    wr16(self, 0x1e, 0xffff);
    wr16(self, 0x1c, 0xffff);
    wr32(self, 0x1515, 0);
    wr32(self, 0x1519, 0);
    wr32(self, 0x151d, 0);
    return self;
}

/* ---- 0x4e04f3 reset_fields ------------------------------------------------------------------------------------------------------ */
uint8_t *m4e04f3_reset_fields(uint8_t *self)
{
    wr32(self, 0xf2a, 0);
    wr32(self, 0x74f, 0);
    wr32(self, 0xf2e, 0);
    wr32(self, 0xf32, 0xffffffffu);
    wr32(self, 0xf36, 0xffffffffu);
    return self;
}

/* ---- 0x454565 cross_product ----------------------------------------------------------------------------------------------------- */
int32_t m454565_cross_product(const uint8_t *a, const uint8_t *b, const uint8_t *c)
{
    uint32_t first = (rd32(b, 0) - rd32(a, 0)) * (rd32(c, 4) - rd32(a, 4));        /* imul edx, eax: the low 32 bits of the product */
    uint32_t second = (rd32(c, 0) - rd32(a, 0)) * (rd32(b, 4) - rd32(a, 4));
    return (int32_t)(first - second);
}

/* ---- 0x4a638a reset_fields ------------------------------------------------------------------------------------------------------ */
uint8_t *m4a638a_reset_fields(uint8_t *self)
{
    wr16(self, 0x1e, 0xffff);
    wr16(self, 0x1c, 0xffff);
    wr32(self, 0x21, 0);
    wr32(self, 0x25, 0);
    wr32(self, 0x86, 0);
    self[0x8a] = 0;
    self[0x8b] = 0;
    return self;
}

/* FNS-END */
