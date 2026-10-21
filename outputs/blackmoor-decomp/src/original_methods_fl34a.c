#include "original_methods_fl34a.h"

#include <string.h>

#if defined(__GNUC__)
#define FL34A_UNUSED __attribute__((unused))
#else
#define FL34A_UNUSED
#endif

FL34A_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL34A_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL34A_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, NULL, 0) : 0;
}

/* ---- 0x402962 toggle_dword (the body shared by all 21 symbols below; each cites its own address and carries its own table base) ----
 * `table` is the host memory of the original address 0x5e60da; `delta` = (base of the row) - 0x5e60da in bytes, negative for the base 0x5e60d6. The index [self+0x5c] is a 32-bit register in the
 * original's address computation (wraps in 32 bits); the port takes it as a signed index. It is read again for the store, as in the original. */
static void toggle_dword(uint8_t *self, uint8_t *table, ptrdiff_t delta)
{
    if (rd32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4 + delta) == 1)
        wr32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4 + delta, 0);
    else
        wr32(table, (ptrdiff_t)(int32_t)rd32(self, 0x5c) * 4 + delta, 1);
}

/* ---- 0x402962 toggle_5e60d6 (table base 0x5e60d6) ---- */
void m402962_toggle_5e60d6(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e60d6 - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402a7e toggle_5e60e6 (table base 0x5e60e6) ---- */
void m402a7e_toggle_5e60e6(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e60e6 - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402ac5 toggle_5e60ea (table base 0x5e60ea) ---- */
void m402ac5_toggle_5e60ea(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e60ea - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402b0c toggle_5e60ee (table base 0x5e60ee) ---- */
void m402b0c_toggle_5e60ee(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e60ee - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402b53 toggle_5e60f2 (table base 0x5e60f2) ---- */
void m402b53_toggle_5e60f2(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e60f2 - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402b9a toggle_5e60f6 (table base 0x5e60f6) ---- */
void m402b9a_toggle_5e60f6(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e60f6 - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402be1 toggle_5e60fa (table base 0x5e60fa) ---- */
void m402be1_toggle_5e60fa(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e60fa - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402c28 toggle_5e60fe (table base 0x5e60fe) ---- */
void m402c28_toggle_5e60fe(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e60fe - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402c6f toggle_5e6102 (table base 0x5e6102) ---- */
void m402c6f_toggle_5e6102(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e6102 - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402cb6 toggle_5e6106 (table base 0x5e6106) ---- */
void m402cb6_toggle_5e6106(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e6106 - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402cfd toggle_5e610a (table base 0x5e610a) ---- */
void m402cfd_toggle_5e610a(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e610a - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402d44 toggle_5e610e (table base 0x5e610e) ---- */
void m402d44_toggle_5e610e(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e610e - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402d8b toggle_5e6112 (table base 0x5e6112) ---- */
void m402d8b_toggle_5e6112(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e6112 - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402dd2 toggle_5e6116 (table base 0x5e6116) ---- */
void m402dd2_toggle_5e6116(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e6116 - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402e19 toggle_5e611a (table base 0x5e611a) ---- */
void m402e19_toggle_5e611a(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e611a - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402e60 toggle_5e611e (table base 0x5e611e) ---- */
void m402e60_toggle_5e611e(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e611e - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402ea7 toggle_5e6122 (table base 0x5e6122) ---- */
void m402ea7_toggle_5e6122(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e6122 - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402eee toggle_5e6126 (table base 0x5e6126) ---- */
void m402eee_toggle_5e6126(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e6126 - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402f35 toggle_5e612a (table base 0x5e612a) ---- */
void m402f35_toggle_5e612a(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e612a - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402f7c toggle_5e612e (table base 0x5e612e) ---- */
void m402f7c_toggle_5e612e(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e612e - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* ---- 0x402fc3 toggle_5e6132 (table base 0x5e6132) ---- */
void m402fc3_toggle_5e6132(uint8_t *self, Fl34aWorld *world, const Fl18Host *host)
{
    toggle_dword(self, world->table_5e60da, 0x5e6132 - 0x5e60da);
    call0(host, 0x40236a, (uintptr_t)self);
}

/* FNS-END */
