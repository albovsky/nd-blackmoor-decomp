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

/* ---- 0x44c479 ------------------------------------------------------------------------------------------------------------------ */

/* a dword read that the compiler may not hoist out of a waiting loop (another thread changes it); it may sit at an odd address */
static uint32_t rd32_volatile(const uint8_t *p)
{
    const volatile uint8_t *v = p;
    return (uint32_t)v[0] | (uint32_t)v[1] << 8 | (uint32_t)v[2] << 16 | (uint32_t)v[3] << 24;
}

/* 0x44c479, cdecl, plain `ret`, one argument: the address of a state dword (0x637fd3 in the program; an odd address). While the dword is 1
 * the function calls Sleep(1) (import 0x52a2b0) and reads it again (another thread ends the wait); then, reading it once more, it returns
 * 2 when the dword is 2, otherwise stores 1 and returns 1. Only `ax` is set by the original (the upper half of eax is the upper half of the
 * address); the port returns 1 or 2. Native rejection: after Fl27aWorld.native_spin_limit (0 = FL27A_SPIN_LIMIT) Sleep calls without the
 * dword leaving 1 the port returns FL27A_REJECTED (the original would spin without end). The state dword is read and written through
 * Fl18Host.resolve (4 writable bytes). */
int32_t m44c479_wait_state(uint32_t state, const Fl27aWorld *world, const Fl18Host *host)
{
    uint8_t *p = mem_at(host, state);
    uint32_t limit = world->native_spin_limit != 0 ? world->native_spin_limit : FL27A_SPIN_LIMIT;
    uint32_t spins = 0;
    while (rd32_volatile(p) == 1) {
        call1(host, 0x52a2b0, 0, 1);
        if (++spins >= limit) return FL27A_REJECTED;
    }
    if (rd32_volatile(p) == 2) return 2;
    wr32(p, 0, 1);
    return 1;
}

/* ---- 0x4bee2c ------------------------------------------------------------------------------------------------------------------ */

/* 0x4bee2c, thiscall, `ret 4`: calls 0x4bf38c (this = self); with a zero argument stores [self + 0x2c0] = 0xfffffffd and returns -1,
 * otherwise returns the dword [argument + 0xc] (the frame number of a Bink handle). The handle is read through Fl18Host.resolve (0x10 bytes). */
int32_t m4bee2c_get_field(uint8_t *self, uint32_t handle, const Fl18Host *host)
{
    call0(host, 0x4bf38c, (uintptr_t)self);
    if (handle == 0) {
        wr32(self, 0x2c0, 0xfffffffdu);
        return -1;
    }
    return (int32_t)rd32(mem_at(host, handle), 0xc);
}

/* ---- 0x4bef85 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4bef85, thiscall, `ret 4`: calls 0x4bf38c (this = self); with a zero argument stores [self + 0x2c0] = 0xfffffffd and returns 0,
 * otherwise calls _BinkWait@4 (import 0x52a52c, the handle) and returns 0 when its result is non-zero, else 1. */
int32_t m4bef85_bink_wait(uint8_t *self, uint32_t handle, const Fl18Host *host)
{
    call0(host, 0x4bf38c, (uintptr_t)self);
    if (handle == 0) {
        wr32(self, 0x2c0, 0xfffffffdu);
        return 0;
    }
    return call1(host, 0x52a52c, 0, handle) != 0 ? 0 : 1;
}

/* ---- 0x4bee5f ------------------------------------------------------------------------------------------------------------------ */

/* 0x4bee5f, thiscall, `ret 4`: calls 0x4bf38c (this = self); with a zero argument clears 0x1f dwords (`rep stosd`, 124 bytes) at self + 8,
 * stores [self + 0x2c0] = 0xfffffffd and returns 0; otherwise calls _BinkGetSummary@8 (import 0x52a508: the handle, self + 8) and returns
 * self + 8 (the host pointer; the original returns the address of the object plus 8). The result of the import is ignored. */
uint8_t *m4bee5f_bink_summary(uint8_t *self, uint32_t handle, const Fl18Host *host)
{
    call0(host, 0x4bf38c, (uintptr_t)self);
    if (handle == 0) {
        memset(self + 8, 0, 0x1f * 4);
        wr32(self, 0x2c0, 0xfffffffdu);
        return NULL;
    }
    call2(host, 0x52a508, 0, handle, (uintptr_t)(self + 8));
    return self + 8;
}

/* ---- 0x4befc8 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4befc8, thiscall, `ret 4`: calls 0x4bf38c (this = self); [self + 0xbc] = 0; with a zero argument stores [self + 0x2c0] = 0xfffffffd and
 * returns [self + 0xbc] (0); otherwise calls _BinkDoFrame@4 (import 0x52a528, the handle), stores its result in [self + 0xbc] and returns
 * [self + 0xbc]. */
int32_t m4befc8_bink_do_frame(uint8_t *self, uint32_t handle, const Fl18Host *host)
{
    call0(host, 0x4bf38c, (uintptr_t)self);
    wr32(self, 0xbc, 0);
    if (handle == 0) {
        wr32(self, 0x2c0, 0xfffffffdu);
        return (int32_t)rd32(self, 0xbc);
    }
    wr32(self, 0xbc, call1(host, 0x52a528, 0, handle));
    return (int32_t)rd32(self, 0xbc);
}

/* ---- 0x4bef11 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4bef11, thiscall, `ret 8` (handle, mode): calls 0x4bf38c (this = self); with a zero handle stores [self + 0x2c0] = 0xfffffffd and
 * returns 0xfffffffd; otherwise [self + 0x2c4] = mode and, reading it back (a dword compare with 1): mode 1 calls _BinkGoto@12 (import
 * 0x52a530: handle, the dword [handle + 8], 0), any other mode calls it with (handle, 1, 0); returns 0 (the import's result is ignored).
 * The handle is read through Fl18Host.resolve (12 bytes) for mode 1 only. */
int32_t m4bef11_bink_goto(uint8_t *self, uint32_t handle, uint32_t mode, const Fl18Host *host)
{
    uintptr_t args[3];
    call0(host, 0x4bf38c, (uintptr_t)self);
    if (handle == 0) {
        wr32(self, 0x2c0, 0xfffffffdu);
        return (int32_t)0xfffffffd;
    }
    wr32(self, 0x2c4, mode);
    args[0] = handle;
    args[1] = rd32(self, 0x2c4) != 1 ? 1 : rd32(mem_at(host, handle), 8);
    args[2] = 0;
    if (host->call != NULL) host->call(host->context, 0x52a530, 0, args, 3);
    return 0;
}

/* ---- 0x4bf098 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4bf098, thiscall, `ret 0x18` (handle, dest, pitch, height, x, y): calls 0x4bf38c (this = self); [self + 0xbc] = 0; with a zero handle
 * stores [self + 0x2c0] = 0xfffffffd and returns [self + 0xbc] (0); otherwise calls _BinkCopyToBuffer@28 (import 0x52a524: the six
 * arguments in order and, last, the dword [self + 4]), stores its result in [self + 0xbc] and returns [self + 0xbc]. */
int32_t m4bf098_bink_copy_to_buffer(uint8_t *self, uint32_t handle, uint32_t dest, uint32_t pitch, uint32_t height, uint32_t x, uint32_t y,
                                    const Fl18Host *host)
{
    uintptr_t args[7];
    call0(host, 0x4bf38c, (uintptr_t)self);
    wr32(self, 0xbc, 0);
    if (handle == 0) {
        wr32(self, 0x2c0, 0xfffffffdu);
        return (int32_t)rd32(self, 0xbc);
    }
    args[0] = handle;
    args[1] = dest;
    args[2] = pitch;
    args[3] = height;
    args[4] = x;
    args[5] = y;
    args[6] = rd32(self, 4);
    wr32(self, 0xbc, host->call != NULL ? host->call(host->context, 0x52a524, 0, args, 7) : 0);
    return (int32_t)rd32(self, 0xbc);
}

/* ---- 0x4bf10f ------------------------------------------------------------------------------------------------------------------ */

/* 0x4bf10f, thiscall, `ret 4`: calls 0x4bf38c (this = self); with a zero handle stores [self + 0x2c0] = 0xfffffffd and returns 0. Reading
 * the dword [self + 0x2c4]: not 1 -> returns 0 when [handle + 0xc] equals [handle + 8], otherwise calls _BinkNextFrame@4 (import 0x52a520:
 * handle) and returns 1; 1 -> returns 0 when [handle + 0xc] is 1, otherwise calls _BinkGoto@12 (import 0x52a530: handle,
 * [handle + 0xc] - 1, 0) and returns 1. The handle is read through Fl18Host.resolve (0x10 bytes). */
int32_t m4bf10f_bink_next(uint8_t *self, uint32_t handle, const Fl18Host *host)
{
    const uint8_t *h;
    uintptr_t args[3];
    call0(host, 0x4bf38c, (uintptr_t)self);
    if (handle == 0) {
        wr32(self, 0x2c0, 0xfffffffdu);
        return 0;
    }
    h = mem_at(host, handle);
    if (rd32(self, 0x2c4) != 1) {
        if (rd32(h, 0xc) == rd32(h, 8)) return 0;
        call1(host, 0x52a520, 0, handle);
        return 1;
    }
    if (rd32(h, 0xc) == 1) return 0;
    args[0] = handle;
    args[1] = rd32(h, 0xc) - 1u;
    args[2] = 0;
    if (host->call != NULL) host->call(host->context, 0x52a530, 0, args, 3);
    return 1;
}

/* ---- 0x4bf315 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4bf315, thiscall, `ret 8` (name, flags): calls 0x4bf38c and then 0x4bede7 (this = self for both); measures the zero-terminated name
 * (`repne scasb`); an empty name stores [self + 0x2c0] = 0xfffffffb and returns 0; otherwise calls _BinkOpen@8 (import 0x52a518: name,
 * flags): a zero result stores [self + 0x2c0] = 0xfffffffa and returns 0, any other result is returned (the Bink handle). The scan only
 * decides whether the length is zero, so the port reads the first byte; the original scans on to the terminator (a name without one
 * runs off the memory: caller-validated). The name is read through Fl18Host.resolve (1 byte). */
uint32_t m4bf315_bink_open(uint8_t *self, uint32_t name, uint32_t flags, const Fl18Host *host)
{
    uint32_t bink;
    call0(host, 0x4bf38c, (uintptr_t)self);
    call0(host, 0x4bede7, (uintptr_t)self);
    if (mem_at(host, name)[0] == 0) {
        wr32(self, 0x2c0, 0xfffffffbu);
        return 0;
    }
    bink = call2(host, 0x52a518, 0, name, flags);
    if (bink == 0) {
        wr32(self, 0x2c0, 0xfffffffau);
        return 0;
    }
    return bink;
}

/* ---- 0x4c2dfb ------------------------------------------------------------------------------------------------------------------ */

/* 0x4c2dfb, thiscall, `ret 4`: the argument is the address of a slot that holds a pointer p. A zero p does nothing. Otherwise: when the low
 * bit of the dword [p + 0x55] is clear, calls 0x4c2e5b (this = self, argument p); when it is set, stores the dword [p] = 0. Then reads the
 * slot AGAIN (the callee may have replaced it), calls 0x51dc6c (cdecl, that value) and clears the slot. The slot is read and written
 * through Fl18Host.resolve (4 bytes), p through it as well (0x59 bytes; 4 writable bytes at p for the set bit). */
void m4c2dfb_free_pair(uint8_t *self, uint32_t slot, const Fl18Host *host)
{
    uint8_t *s = mem_at(host, slot);
    uint32_t p = rd32(s, 0);
    uint8_t *obj;
    if (p == 0) return;
    obj = mem_at(host, p);
    if ((rd32(obj, 0x55) & 1u) == 0)
        call1(host, 0x4c2e5b, (uintptr_t)self, p);
    else
        wr32(obj, 0, 0);
    call1(host, 0x51dc6c, 0, rd32(s, 0));
    wr32(s, 0, 0);
}

/*NEXT*/
