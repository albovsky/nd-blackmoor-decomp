#include "original_methods_fl36a.h"

#include <string.h>

#if defined(__GNUC__)
#define FL36A_UNUSED __attribute__((unused))
#else
#define FL36A_UNUSED
#endif

FL36A_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL36A_UNUSED static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL36A_UNUSED static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

FL36A_UNUSED static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL36A_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* host memory behind an original address (writable: the host owns the memory; the interface only says const) */
FL36A_UNUSED static uint8_t *res(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

FL36A_UNUSED static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

FL36A_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

FL36A_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

FL36A_UNUSED static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    const uintptr_t a[2] = {a0, a1};
    return callv(host, callee, this_ptr, a, 2);
}

FL36A_UNUSED static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    const uintptr_t a[3] = {a0, a1, a2};
    return callv(host, callee, this_ptr, a, 3);
}

/* ---- 0x4f379c open_entry ------------------------------------------------------------------------------------------------------- */
/* the error exits: [self+0x3c2] = code, [self+0x3be] = 0, eax = [self+0x3be] */
static uint32_t fail_4f379c(uint8_t *self, uint32_t code)
{
    wr32(self, 0x3c2, code);
    wr32(self, 0x3be, 0);
    return rd32(self, 0x3be);
}

/* 0x4f379c m4f379c_open_entry */
int m4f379c_open_entry(uint8_t *self, uint32_t id, uint32_t *result, const Fl36aWorld *world, const Fl18Host *host)
{
    uint8_t local[0x24];
    uintptr_t a[5];
    uint32_t entry, fp, size, p, q, t, len;
    uint8_t *o;
    id &= 0xffffu;
    memset(local, 0, sizeof local);
    wr16(local, 0, (uint16_t)world->word_63aa14);
    wr32(self, 0x3be, 1);
    wr32(self, 0x3c2, 0x3e8);
    entry = rd32(self, 0x3ce) + id * 0x5bbu;
    o = res(host, entry);
    if (rd32(o, 0x162) != 0) call1(host, 0x4f356e, (uintptr_t)self, id);
    fp = call2(host, 0x50d0a9, 0, entry + 4u, 0x55dab0);
    wr32(o, 0x156, fp);
    if (rd32(o, 0x156) == 0) {
        *result = fail_4f379c(self, 0x3ed);
        return 0;
    }
    a[0] = entry + 0x10au; a[1] = 0x1e; a[2] = 1; a[3] = rd32(o, 0x156);
    if (callv(host, 0x50cf61, 0, a, 4) == 0) {
        *result = fail_4f379c(self, 0x3ec);
        return 0;
    }
    if (memcmp(o + 0x10a, res(host, 0x55dab4), 4) != 0 || rds16(o, 0x10e) != 2 || rds16(o, 0x110) != 0) {
        call1(host, 0x4f356e, (uintptr_t)self, id);
        *result = fail_4f379c(self, 0x3f9);
        return 0;
    }
    wr32(o, 0x162, 1);
    wr32(o, 0x152, 0);
    p = rd32(o, 0x1aa);
    q = rd32(o, 0x1ae);
    if (!((p != 0 || q != 0) && (int32_t)(q - p) > 0)) {
        wr32(o, 0x1aa, rd32(self, 0x446));
        wr32(o, 0x1ae, rd32(self, 0x44a));
    }
    if ((int32_t)rd32(o, 0x1b2) > (int32_t)rd32(o, 0x1b6)) {
        t = rd32(o, 0x1b6);
        wr32(o, 0x1b6, rd32(o, 0x1b2));
        wr32(o, 0x1b2, t);
    }
    if ((int32_t)rd32(o, 0x1ba) > (int32_t)rd32(o, 0x1be)) {
        t = rd32(o, 0x1be);
        wr32(o, 0x1be, rd32(o, 0x1ba));
        wr32(o, 0x1ba, t);
    }
    if ((int32_t)rd32(o, 0x1c2) > (int32_t)rd32(o, 0x1c6)) {
        t = rd32(o, 0x1c6);
        wr32(o, 0x1c6, rd32(o, 0x1c2));
        wr32(o, 0x1c2, t);
    }
    if ((int32_t)rd32(o, 0x1d6) <= 1) wr32(o, 0x1d6, rd32(self, 0x466));
    if ((int32_t)rd32(o, 0x1da) <= 1) wr32(o, 0x1da, rd32(self, 0x46a));
    wr32(o, 0x287, 0);
    wr32(o, 0x19e, 0);
    wr32(o, 0x28b, 0);
    wr32(o, 0x15e, rd32(o, 0x122));
    size = rd32(o, 0x15e);
    if ((int32_t)size < 0) {
        if (world->word_63a4cd != 0) {
            call1(host, 0x4f356e, (uintptr_t)self, id);
            call3(host, 0x50ca3e, 0, 0x63888b, 0x55dab8, entry + 4u);
            call3(host, 0x52139c, 0, 0x63888b, 0, 0);
        }
        *result = 0;
        return 0;
    }
    if (rds16(o, 0x126) == 2) {
        len = (uint32_t)strlen((const char *)res(host, 0x55dafc)) + 1u;
        if (len > sizeof local) return 1;                 /* the original would run over its saved registers */
        memcpy(local, res(host, 0x55dafc), len);
    }
    if ((int32_t)size > 0x56220) {
        wr32(o, 0x166, 1);
        if (world->word_63a4cd != 0) {
            a[0] = 0x63888b; a[1] = 0x55db08; a[2] = (uintptr_t)local; a[3] = id; a[4] = entry + 4u;
            callv(host, 0x50ca3e, 0, a, 5);
            call1(host, 0x44a2b7, 0, 0x63888b);
        }
        if (call1(host, 0x4f438f, (uintptr_t)self, id) == 0) {
            *result = 0;
            return 0;
        }
    } else {
        wr32(o, 0x166, 0);
        if (world->word_63a4cd != 0) {
            a[0] = 0x63888b; a[1] = 0x55db40; a[2] = id; a[3] = entry + 4u;
            callv(host, 0x50ca3e, 0, a, 4);
            call1(host, 0x44a2b7, 0, 0x63888b);
        }
        if (call1(host, 0x4f3c26, (uintptr_t)self, id) == 0) {
            *result = 0;
            return 0;
        }
    }
    *result = rd32(self, 0x3be);
    return 0;
}

/* FNS-END */
