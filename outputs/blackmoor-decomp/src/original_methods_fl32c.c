#include "original_methods_fl32c.h"

#include <string.h>

#if defined(__GNUC__)
#define FL32C_UNUSED __attribute__((unused))
#else
#define FL32C_UNUSED
#endif

FL32C_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL32C_UNUSED static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL32C_UNUSED static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

FL32C_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL32C_UNUSED static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

FL32C_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

FL32C_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

/* ---- 0x44e78e release_entry ---------------------------------------------------------------------------------------------------- */
void m44e78e_release_entry(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x20) != 0) call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x20));
    if (rds16(self, 0x1c) != -1) call1(host, 0x4d3992, 0, rd16(self, 0x1c));
    call0(host, 0x44e767, (uintptr_t)self);
}

/* ---- 0x44e7d7 mark_entry ------------------------------------------------------------------------------------------------------- */
void m44e7d7_mark_entry(const uint8_t *self, const Fl32cWorld *world)
{
    int32_t i;
    if (rd32(self, 0x6b) == 0) return;
    if (rds16(self, 0x1c) == -1) return;
    i = rds16(self, 0x1c);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x44e95b offset_rect ------------------------------------------------------------------------------------------------------ */
void m44e95b_offset_rect(const uint8_t *src, uint8_t *dst, const Fl32cWorld *world)
{
    wr32(dst, 4, rd32(src, 4) + world->value_58318a);
    wr32(dst, 0xc, rd32(src, 0xc) + world->value_58318a);
    wr32(dst, 0, rd32(src, 0) + world->value_583186);
    wr32(dst, 8, rd32(src, 8) + world->value_583186);
}

/* ---- 0x43edac default_after_query ---------------------------------------------------------------------------------------------- */
uint32_t m43edac_default_after_query(uint8_t *self, uint32_t a8, uint32_t ac, uint32_t a10, const Fl18Host *host)
{
    uint32_t slots[3];                  /* the three stack argument slots [ebp+8], [ebp+0xc], [ebp+0x10], contiguous as in the original */
    volatile uint32_t dead[3];          /* [ebp-0xc], [ebp-8], [ebp-4]: stored and never read by the original */
    uintptr_t args[3];
    slots[0] = a8;
    slots[1] = ac;
    slots[2] = a10;
    args[0] = (uintptr_t)&slots[0];
    args[1] = (uintptr_t)&slots[1];
    args[2] = (uintptr_t)&slots[2];
    callv(host, 0x437774, 0x583208, args, 3);
    dead[0] = slots[2];
    dead[1] = slots[1];
    dead[2] = slots[0];
    (void)dead;
    return call0(host, 0x51ab4b, (uintptr_t)self);
}

/* ---- 0x43ee69 filter_message --------------------------------------------------------------------------------------------------- */
uint32_t m43ee69_filter_message(uint8_t *self, uint32_t msg, uint32_t wparam, uint32_t lparam, const Fl18Host *host)
{
    uintptr_t args[3];
    if (msg == 0x14) return 1;
    if (msg == 0x112) {
        uint32_t command = wparam & 0xfff0;
        if (command == 0xf140 || command == 0xf170) return 0;
    }
    args[0] = msg;
    args[1] = wparam;
    args[2] = lparam;
    return callv(host, 0x51b461, (uintptr_t)self, args, 3);
}

/* ---- 0x4db090 normalize_state -------------------------------------------------------------------------------------------------- */
void m4db090_normalize_state(uint8_t *self, const Fl32cWorld *world)
{
    if (world->value_5c39e5 != 0xffffffffu) {
        if (rd32(self, 4) == 0) wr32(self, 4, 1);
    }
    if (rd32(self, 0x10) == 1) wr32(self, 0x10, 2);
    wr32(self, 0xc, 0);
}

/* ---- 0x4de53e report ------------------------------------------------------------------------------------------------------------ */
void m4de53e_report(uint8_t *self, const Fl32cWorld *world, const Fl18Host *host)
{
    uint32_t p = call0(host, 0x4ee630, (uintptr_t)self);
    uintptr_t args[5];
    if (p == 0) return;
    args[0] = p;
    args[1] = world->value_5cf665;
    args[2] = (uintptr_t)(self + 0x981);
    args[3] = 0x5b0227;
    args[4] = 0x55b8d0;
    callv(host, 0x4c5377, 0x5cf659, args, 5);
}

/* ---- 0x4ea229 clear_pending ----------------------------------------------------------------------------------------------------- */
void m4ea229_clear_pending(uint8_t *self, Fl32cWorld *world, const Fl18Host *host)
{
    call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x699));
    world->value_5d1717 = 0;
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x55cb10);
}

/* ---- 0x4fb2a6 check_slot --------------------------------------------------------------------------------------------------------- */
void m4fb2a6_check_slot(uint8_t *self, uint32_t a, uint32_t b, const Fl18Host *host)
{
    uint32_t idx = (b & 0xffff) * 0x5bb;
    uintptr_t args[2];
    if (rd16(self, (ptrdiff_t)idx + 0x132) == 0) {
        args[0] = a;
        args[1] = (idx & 0xffff0000u) | (b & 0xffff);
        callv(host, 0x4faf98, (uintptr_t)self, args, 2);
    }
}

/* FNS-END */
