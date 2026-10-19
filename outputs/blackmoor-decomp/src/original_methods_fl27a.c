#include "original_methods_fl27a.h"

#include <string.h>

#define HELPER static __attribute__((unused))

HELPER uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

HELPER void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

HELPER uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

HELPER void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

HELPER uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, NULL, 0) : 0;
}

HELPER uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    uintptr_t args[1];
    args[0] = a0;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 1) : 0;
}

HELPER uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    uintptr_t args[2];
    args[0] = a0;
    args[1] = a1;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 2) : 0;
}

/* the memory of an original address (an address that an argument, a slot or an object keeps), as writable host memory */
HELPER uint8_t *mem_at(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

/* ---- 0x4de1f5 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4de1f5, thiscall, plain `ret`: [self + 0x991] = 0 (dword, unaligned) and the byte [0x5a161f] = 0. */
void m4de1f5_clear_flags(uint8_t *self, Fl27aWorld *world)
{
    wr32(self, 0x991, 0);
    world->byte_5a161f = 0;
}

/* ---- 0x4de214 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4de214, thiscall, plain `ret`: calls 0x4de1f5 with this = self (called natively: it is in this batch). */
void m4de214_clear_flags_thunk(uint8_t *self, Fl27aWorld *world)
{
    m4de1f5_clear_flags(self, world);
}

/* ---- 0x4de2d8 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4de2d8, thiscall, plain `ret`: [self + 0x991] = 1; calls 0x4e053f (ecx 0x570508, argument 1) and 0x4e1113 (ecx 0x570508); the
 * dwords [0x5b15d6] and [0x5d17f5] = 0; then calls 0x4de214 (this = self; natively, it clears [self + 0x991] and the byte [0x5a161f]
 * again). The callees see [self + 0x991] = 1 and the two dwords still set. */
void m4de2d8_reset_caption(uint8_t *self, Fl27aWorld *world, const Fl18Host *host)
{
    wr32(self, 0x991, 1);
    call1(host, 0x4e053f, 0x570508, 1);
    call0(host, 0x4e1113, 0x570508);
    world->value_5b15d6 = 0;
    world->value_5d17f5 = 0;
    m4de214_clear_flags_thunk(self, world);
}

/* ---- 0x449d90 ------------------------------------------------------------------------------------------------------------------ */

/* 0x449d90, cdecl, plain `ret`, one argument (an address of the original: a path string, only passed on): calls 0x50d0a9 (path, 0x548aac)
 * (fopen: args[0] = the path, the last one pushed, args[1] = the mode string 0x548aac); returns 0 when the result is zero, otherwise
 * calls 0x50cee4 (that result) (fclose) and returns 1. */
int32_t m449d90_file_exists(uint32_t path, const Fl18Host *host)
{
    uint32_t file = call2(host, 0x50d0a9, 0, path, 0x548aac);
    if (file == 0) return 0;
    call1(host, 0x50cee4, 0, file);
    return 1;
}

/*NEXT*/
