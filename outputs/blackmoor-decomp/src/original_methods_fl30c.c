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
