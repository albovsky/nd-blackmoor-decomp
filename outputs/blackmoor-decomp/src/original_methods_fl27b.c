#include "original_methods_fl27b.h"

#include <string.h>

static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

static uint32_t calln(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, int n, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3, uintptr_t a4)
{
    uintptr_t args[5];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    args[3] = a3;
    args[4] = a4;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return calln(host, callee, this_ptr, 0, 0, 0, 0, 0, 0);
}

static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    return calln(host, callee, this_ptr, 1, a0, 0, 0, 0, 0);
}

static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    return calln(host, callee, this_ptr, 2, a0, a1, 0, 0, 0);
}

/* the object of an original address (an address that an object keeps), as host memory */
static uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

/* `movsx eax, word ptr [0x63a4cd]; test eax, eax`: the debug flag, read at every use */
static int debug_on(const Fl27bWorld *world)
{
    return world->word_63a4cd != 0;
}

/* ---- 0x449bff ------------------------------------------------------------------------------------------------------------------ */

/* 0x449bff, plain ret: see the header. [ebp-8] / [ebp-0xc] are the object address read from [self+0x36] (the loop reads it again on every pass), [ebp-4] the
 * result of the import (the previous suspend count of the thread: 0xffffffff is the failure value). The two compares `cmp [ebp-4], 1; jbe` are unsigned.
 * The trace calls pass the host pointers self+4 (an address of `self`) and the 32-bit values the original pushes. */
int32_t m449bff_resume_thread(uint8_t *self, const Fl27bWorld *world, const Fl18Host *host)
{
    uint32_t obj, result;
    if (rd32(self, 0x36) == 0) return 0;
    obj = rd32(self, 0x36);
    result = call1(host, 0x52a284, 0, rd32(object_at(host, obj), 0x28));
    if (debug_on(world)) {
        calln(host, 0x50ca3e, 0, 5, 0x63888b, 0x5489e4, rd32(self, 0x3a), (uintptr_t)(self + 4), result);
        call1(host, 0x44a2b7, 0, 0x63888b);
    }
    if (result == 0xffffffffu) {
        call1(host, 0x4264e8, 0x583979, 0x548a38);
        call0(host, 0x4c97b4, 0x5cf659);
        return 0;
    }
    while (result > 1u) {
        obj = rd32(self, 0x36);
        result = call1(host, 0x52a284, 0, rd32(object_at(host, obj), 0x28));
        if (debug_on(world)) {
            calln(host, 0x50ca3e, 0, 5, 0x63888b, 0x548a54, rd32(self, 0x3a), (uintptr_t)(self + 4), result);
            call1(host, 0x44a2b7, 0, 0x63888b);
        }
        /* native rejection: the original would call the import again for ever (0xffffffff is above 1) */
        if (result == 0xffffffffu) return 1;
    }
    wr32(self, 0x42, 2);
    return 0;
}

/* ---- 0x449a94 ------------------------------------------------------------------------------------------------------------------ */

/* 0x449a94, plain ret: see the header. [ebp-4] is the dword `code` that the import 0x52a280 stores through its second argument, [ebp-0x68] a 100-byte trace buffer. The
 * object address [self+0x36] is read again at the loop head, and for the stores after the loop. The virtual call: ecx = the object, the function is the dword at
 * [vtable + 0x78] with vtable = the dword at [object]. */
int32_t m449a94_stop_thread(uint8_t *self, const Fl27bWorld *world, const Fl18Host *host)
{
    uint32_t code = 0;
    uint8_t text[100];
    uint32_t obj, result;
    if (rd32(self, 0x36) == 0) return 0;
    if (rd32(self, 0x36) != 0 && rd32(self, 0x42) == 1) {
        call0(host, 0x449bff, (uintptr_t)self);
        call1(host, 0x52a2b0, 0, 0);
    }
    wr32(self, 0x3e, 1);
    call1(host, 0x52a2b0, 0, 0);
    while (rd32(self, 0x36) != 0) {
        result = call2(host, 0x52a280, 0, rd32(object_at(host, rd32(self, 0x36)), 0x28), (uintptr_t)&code);
        if (result != 0) {
            if (code == 0) break;
        } else if (debug_on(world)) {
            uint32_t t = call0(host, 0x426367, 0x583979);
            call1(host, 0x44a2b7, 0, t);
        }
        call1(host, 0x52a2b0, 0, 0);
    }
    obj = rd32(self, 0x36);
    /* native rejection: with [self+0x36] zero the original stores 1 at address 0x24 (an access violation); here nothing more is done */
    if (obj == 0) return 1;
    wr32(object_at(host, obj), 0x24, 1);
    obj = rd32(self, 0x36);
    {
        uint32_t vtable = rd32(object_at(host, obj), 0);
        call0(host, rd32(object_at(host, vtable), 0x78), obj);
    }
    wr32(self, 0x36, 0);
    wr32(self, 0x42, 3);
    if (debug_on(world)) {
        calln(host, 0x50ca3e, 0, 4, (uintptr_t)text, 0x5489a0, rd32(self, 0x3a), (uintptr_t)(self + 4), 0);
        call1(host, 0x44a2b7, 0, (uintptr_t)text);
    }
    return 0;
}

/* ---- 0x4bf773 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4bf773, plain ret: see the header. [ebp-0xc] is `self`, [ebp-8] / [ebp-4] the object address [self+0x1d6], and [ebp-0x10] the result of the virtual call (unused afterwards). A
 * zero object address skips the virtual call (the original stores 0 into [ebp-0x10]). The deleting-destructor call pushes the flag 1 and the callee pops it (thiscall). */
void m4bf773_release_player(uint8_t *self, const Fl27bWorld *world, const Fl18Host *host)
{
    if (rd32(self, 0x1d6) != 0) {
        uint32_t obj;
        call1(host, 0x44c479, 0, (uintptr_t)(self + 4));
        wr32(self, 4, 2);
        call0(host, 0x449a94, rd32(self, 0x1d6));
        obj = rd32(self, 0x1d6);
        if (obj != 0) {
            uint32_t vtable = rd32(object_at(host, obj), 0);
            call1(host, rd32(object_at(host, vtable), 0), obj, 1);
        }
        wr32(self, 0x1d6, 0);
        call1(host, 0x44c4ab, 0, (uintptr_t)(self + 4));
        wr32(self, 4, 0);
    }
    if (debug_on(world)) call1(host, 0x44a2b7, 0, 0x5525dc);
    call1(host, 0x415011, 0x5e2dbe, (uintptr_t)(self + 8));
    if (debug_on(world)) call1(host, 0x44a2b7, 0, 0x552620);
    if (rd32(self, 0x222) != 0) call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x222));
    if (debug_on(world)) call1(host, 0x44a2b7, 0, 0x552664);
    call1(host, 0x41632b, 0x5e2dbe, (uintptr_t)(self + 8));
    call1(host, 0x4bedfa, 0x6201f9, (uintptr_t)(self + 0x18e));
}

/* ---- 0x4161d1 ------------------------------------------------------------------------------------------------------------------ */

/* the failure path shared by the three allocation sites (the same instructions, three copies in the original): 0x50ca3e(0x63888b, format); 0x52139c(0x63888b, 0, 0); [0x63a58a] = 4; 0x4c97b4 */
static void alloc_failed(Fl27bWorld *world, const Fl18Host *host, uintptr_t format)
{
    call2(host, 0x50ca3e, 0, 0x63888b, format);
    calln(host, 0x52139c, 0, 3, 0x63888b, 0, 0, 0, 0);
    world->value_63a58a = 4;
    call0(host, 0x4c97b4, 0x5cf659);
}

/* 0x4161d1, `ret 4`: see the header. [ebp-0x14] holds the dword kind [arg+0x172] (compared with 0, then with 1); [ebp-4] / [ebp-8] / [ebp-0xc] hold the three allocation results. */
void m4161d1_alloc_buffers(uint8_t *arg, Fl27bWorld *world, const Fl18Host *host)
{
    uint32_t kind = rd32(arg, 0x172);
    uint32_t p;
    if (kind == 0) {
        p = call1(host, 0x51dc43, 0, rd32(arg, 0x1c8));
        wr32(arg, 0x17a, p);
        if (p == 0) alloc_failed(world, host, 0x541e7c);
    } else if (kind == 1) {
        p = call1(host, 0x51dc43, 0, rd32(arg, 0x1c8));
        wr32(arg, 0x17a, p);
        if (p == 0) alloc_failed(world, host, 0x541ed4);
        p = call1(host, 0x51dc43, 0, rd32(arg, 0x1c8));
        wr32(arg, 0x17e, p);
        if (p == 0) alloc_failed(world, host, 0x541f2c);
    }
    wr16(arg, 0x182, 0);
    wr16(arg, 0x184, 0);
}
