#include "original_methods_fl31a.h"

#include <limits.h>
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

/* ---- 0x47b709 set_selector ----------------------------------------------------------------------------------------------------- */
void m47b709_set_selector(uint32_t sel, Fl31aWorld *world)
{
    world->value_5c39e5 = (uint32_t)(int32_t)(int16_t)sel;
    world->value_5b44f0 = 0;
    world->value_5b44f4 = 1;
    world->value_5d162d = world->value_5d0377;
    world->value_5d1631 = (world->value_5b44f0 << 5) + (world->value_5b44f4 << 4) + 0x5b160c;
    world->value_5d1639 = 1;
}

/* ---- 0x47ba79 expire_links ------------------------------------------------------------------------------------------------------ */
void m47ba79_expire_links(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x34) == 0) return;
    if (host->tick(host->context) <= rd32(self, 0x38)) return;
    wr32(res(host, rd32(self, 0x1c)), 4, 0);
    wr32(res(host, rd32(self, 0x20)), 4, 0);
    wr32(self, 0x1c, 0);
    wr32(self, 0x20, 0);
    wr32(self, 0x34, 0);
    wr32(self, 0x38, 0);
}

/* ---- 0x47badf check_range ------------------------------------------------------------------------------------------------------- */
void m47badf_check_range(uint8_t *self, const Fl18Host *host)
{
    if ((int32_t)rd32(self, 0x290) >= (int32_t)rd32(self, 0x2a0)) {
        if ((int32_t)rd32(self, 0x294) <= (int32_t)rd32(res(host, rd32(self, 0xc)), 0x341)) {
            wr32(self, 0x28, 1);
            return;
        }
    }
    if ((int32_t)rd32(self, 0x290) < (int32_t)rd32(self, 0x2a0)) {
        if ((int32_t)rd32(self, 0x294) >= (int32_t)rd32(res(host, rd32(self, 0xc)), 0x341)) wr32(self, 0x2c, 1);
    }
}

/* ---- 0x47b321 release ------------------------------------------------------------------------------------------------------------ */
void m47b321_release(uint8_t *self, const Fl18Host *host)
{
    uint32_t p, q;
    if (rd32(self, 8) != 0) call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 8));
    if (rd32(self, 0x14) != 0) {
        p = rd32(self, 0x14);
        call1(host, 0x51dc6c, 0, p);
        wr32(self, 0x14, 0);
    }
    if (rd32(self, 0x18) != 0) {
        q = rd32(self, 0x18);
        call1(host, 0x51dc6c, 0, q);
        wr32(self, 0x18, 0);
    }
    if (rds16(self, 4) != -1) call1(host, 0x4d3992, 0, rd16(self, 4));
    call0(host, 0x47b23b, (uintptr_t)self);
}

/* ---- 0x47c049 pick_slot ------------------------------------------------------------------------------------------------------------ */
int32_t m47c049_pick_slot(const uint8_t *self, const Fl18Host *host)
{
    int32_t free_exists = 1, i, r, n, k;
    uint8_t *slots;
    for (i = 0; i < (int32_t)rd32(self, 0x2a4); i++) {
        if (rd32(res(host, rd32(self, 0x18)), (ptrdiff_t)i * 4) == 0) {
            free_exists = 0;
            break;
        }
    }
    if (free_exists) {
        r = (int32_t)call0(host, 0x50cd50, 0);
        n = (int32_t)rd32(self, 0x2a4);
        if (n == 0 || (n == -1 && r == INT32_MIN)) return INT32_MIN;         /* the original faults (#DE) here */
        return r % n;
    }
    for (;;) {
        r = (int32_t)call0(host, 0x50cd50, 0);
        n = (int32_t)rd32(self, 0x2a4);
        if (n == 0 || (n == -1 && r == INT32_MIN)) return INT32_MIN;         /* the original faults (#DE) here */
        k = r % n;
        slots = res(host, rd32(self, 0x18));
        if (rd32(slots, (ptrdiff_t)k * 4) == 0) {
            wr32(slots, (ptrdiff_t)k * 4, 1);
            return k;
        }
    }
}

/* ---- 0x47b23b reset_fields ----------------------------------------------------------------------------------------------------- */
void m47b23b_reset_fields(uint8_t *self)
{
    wr16(self, 6, 0xffff);
    wr16(self, 4, 0xffff);
    wr32(self, 0xc, 0);
    wr32(self, 0x24, 0);
    wr32(self, 0x28, 0);
    wr32(self, 0x2c, 0);
    wr32(self, 0x30, 0);
    wr32(self, 0x34, 0);
    wr32(self, 0x2a8, 0);
    wr32(self, 8, 0);
    wr32(self, 0x14, 0);
    wr32(self, 0x18, 0);
    wr32(self, 0x1c, 0);
    wr32(self, 0x20, 0);
    wr32(self, 0x280, 0);
    wr32(self, 0x29c, 0);
    wr32(self, 0x288, 0);
    wr32(self, 0x2a0, 0);
    wr32(self, 0x28c, 0);
    wr32(self, 0x2a4, 0);
}

/* FNS-END */
