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
