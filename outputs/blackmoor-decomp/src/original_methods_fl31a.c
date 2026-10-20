#include "original_methods_fl31a.h"

#include <string.h>

#if defined(__GNUC__)
#define FL31A_UNUSED __attribute__((unused))
#else
#define FL31A_UNUSED
#endif

FL31A_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL31A_UNUSED static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL31A_UNUSED static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

FL31A_UNUSED static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL31A_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* host memory behind an original address (writable: the host owns the memory; the interface only says const) */
FL31A_UNUSED static uint8_t *res(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

FL31A_UNUSED static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

FL31A_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

FL31A_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

/* ---- 0x47b200 construct ------------------------------------------------------------------------------------------------------- */
uint8_t *m47b200_construct(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d568);
    call0(host, 0x47b23b, (uintptr_t)self);
    return self;
}

/* ---- 0x47b3bc mark_entry ------------------------------------------------------------------------------------------------------- */
void m47b3bc_mark_entry(const uint8_t *self, const Fl31aWorld *world)
{
    int32_t i;
    if (rd32(self, 0x24) == 0) return;
    if (rds16(self, 4) == -1) return;
    i = rds16(self, 4);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x47d640 mark_entry ------------------------------------------------------------------------------------------------------- */
void m47d640_mark_entry(const uint8_t *self, const Fl31aWorld *world)
{
    int32_t i;
    if (self[0x57] == 0) return;
    if (rds16(self, 0x23) == -1) return;
    i = rds16(self, 0x23);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* FNS-END */
