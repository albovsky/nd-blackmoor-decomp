#include "original_methods_fl28a.h"

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

HELPER uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    uintptr_t args[3];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 3) : 0;
}

HELPER uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3)
{
    uintptr_t args[4];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    args[3] = a3;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 4) : 0;
}

/* the memory of an original address (an address that an argument, a slot or an object keeps), as writable host memory */
HELPER uint8_t *mem_at(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

/* the fatal tail shared by 0x4237f7, 0x4236d6 (at 0x42383f / 0x42371e) and 0x42356d (at 0x423592): 0x52139c(0x63888b, 0, 0); the debug word
 * non-zero: 0x44a2b7(0x63888b); 0x4c97b4 with ecx 0x5cf659 (ends the process in the original). */
static void fatal_tail(const Fl28aWorld *world, const Fl18Host *host)
{
    call3(host, 0x52139c, 0, 0x63888b, 0, 0);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x63888b);
    call0(host, 0x4c97b4, 0x5cf659);
}

/* ---- 0x4235fd ------------------------------------------------------------------------------------------------------------------ */

/* 0x4235fd, thiscall, plain `ret`: see the header. The address is computed in 32 bits as the original does (imul, lea). */
uint8_t *m4235fd_pop(uint8_t *self)
{
    uint32_t count = rd32(self, 4);
    if (count == 0) return NULL;
    count -= 1;
    wr32(self, 4, count);
    count = rd32(self, 4);
    return (uint8_t *)((uintptr_t)self + (uint32_t)(count * 12u + 8u));
}

/* ---- 0x4fc808 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4fc808, thiscall, `ret 4`: see the header. [ebp-4] is `self`. */
void m4fc808_clear_slot(uint8_t *self, uint32_t slot, const Fl28aWorld *world, const Fl18Host *host)
{
    uint32_t slot16 = slot & 0xffffu;
    if (world->word_63a4cd != 0) {
        call3(host, 0x50ca3e, 0, 0x63888b, 0x56090c, slot16);
        call1(host, 0x44a2b7, 0, 0x63888b);
    }
    call1(host, 0x4f356e, 0x5cf1eb, slot16);
    wr16(self, (ptrdiff_t)(slot16 * 0x5bbu + 0x132u), 0);
}

/* ---- 0x4237f7 ------------------------------------------------------------------------------------------------------------------ */

/* the common body of 0x4237f7 and 0x4236d6: allocate `size` bytes (0x51dc43), on failure report `message` and take the fatal tail, else clear the block */
static uint32_t new_block(uint32_t size, uint32_t message, const Fl28aWorld *world, const Fl18Host *host)
{
    uint32_t p = call1(host, 0x51dc43, 0, size);
    if (p == 0) {
        call2(host, 0x50ca3e, 0, 0x63888b, message);
        fatal_tail(world, host);
        return 0;       /* native stop: the original does not come back from 0x4c97b4 */
    }
    memset(mem_at(host, p), 0, size);
    return p;
}

/* 0x4237f7, plain `ret`: see the header. Locals [ebp-4] / [ebp-8] both hold the allocation. */
uint32_t m4237f7_new_block(const Fl28aWorld *world, const Fl18Host *host)
{
    return new_block(0x4c, 0x5446e0, world, host);
}

/* ---- 0x4236d6 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4236d6, plain `ret`: see the header. */
uint32_t m4236d6_new_block(const Fl28aWorld *world, const Fl18Host *host)
{
    return new_block(0x1c, 0x5445f8, world, host);
}

/* ---- 0x4f80d3 ------------------------------------------------------------------------------------------------------------------ */

/* the call of the vtable entry `slot` of the object `obj` (`mov eax,[obj]; call [eax+slot]`): the callee address is the entry */
static uint32_t vcall(const Fl18Host *host, uint32_t obj, uint32_t slot, const uintptr_t *args, int nargs)
{
    uint32_t vtable = rd32(mem_at(host, obj), 0);
    uint32_t entry = rd32(mem_at(host, vtable), (ptrdiff_t)slot);
    return host->call(host->context, entry, 0, args, nargs);
}

/* 0x4f80d3, thiscall, `ret 8`: see the header. [ebp-4] is `self`. */
uint32_t m4f80d3_play_retry(uint8_t *self, uint32_t obj, uint32_t arg, const Fl18Host *host)
{
    uintptr_t args[4];
    wr32(self, 0x3ca, 0);
    args[0] = obj;
    args[1] = 0;
    args[2] = 0;
    args[3] = arg;
    wr32(self, 0x3ca, vcall(host, obj, 0x30, args, 4));
    if (rd32(self, 0x3ca) == 0x88780096u) {
        uintptr_t one[1];
        one[0] = obj;
        vcall(host, obj, 0x50, one, 1);
        args[0] = obj;
        args[1] = 0;
        args[2] = 0;
        args[3] = arg;
        wr32(self, 0x3ca, vcall(host, obj, 0x30, args, 4));
    }
    return rd32(self, 0x3ca) == 0 ? 1u : 0u;
}

/* ---- 0x42356d ------------------------------------------------------------------------------------------------------------------ */

/* 0x42356d, thiscall, `ret 8`: see the header. [ebp-4] is `self`; the count is read at every use. */
void m42356d_push(uint8_t *self, uint32_t a, uint32_t b, const Fl28aWorld *world, const Fl18Host *host)
{
    if ((int32_t)rd32(self, 4) >= 0x80) {
        call2(host, 0x50ca3e, 0, 0x63888b, 0x544514);
        fatal_tail(world, host);
        return;         /* native stop: the original does not come back from 0x4c97b4 */
    }
    wr32(self, (ptrdiff_t)(int32_t)(rd32(self, 4) * 12u) + 8, a);
    wr32(self, (ptrdiff_t)(int32_t)(rd32(self, 4) * 12u) + 0x10, b);
    wr32(self, 4, rd32(self, 4) + 1u);
}

/* ---- 0x4fb2e3 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4fb2e3, thiscall, `ret 4`: see the header. [ebp-4] is `self`. */
void m4fb2e3_start_slot(uint8_t *self, uint32_t slot, const Fl28aWorld *world, const Fl18Host *host)
{
    uint32_t slot16 = slot & 0xffffu;
    if (world->word_63a4cd != 0) {
        call3(host, 0x50ca3e, 0, 0x63888b, 0x560794, slot16);
        call1(host, 0x44a2b7, 0, 0x63888b);
    }
    if (call1(host, 0x4f6059, 0x5cf1eb, slot16) == 0 && world->word_63a4cd != 0) {
        uint32_t x = call0(host, 0x4fa2a8, 0x5cf1eb);
        call4(host, 0x50ca3e, 0, 0x63888b, 0x5607c4, slot16, x);
        call1(host, 0x44a2b7, 0, 0x63888b);
    }
    wr16(self, (ptrdiff_t)(slot16 * 0x5bbu + 0x132u), 1);
}

/* ---- 0x423368 ------------------------------------------------------------------------------------------------------------------ */

/* the remainder idiom `and eax,0x800003ff; jns; dec eax; or eax,0xfffffc00; inc eax` */
static uint32_t rem1024(uint32_t v)
{
    v &= 0x800003ffu;
    if ((v & 0x80000000u) != 0) v = ((v - 1u) | 0xfffffc00u) + 1u;
    return v;
}

/* 0x423368, thiscall, `ret 4`: see the header. [ebp-8] = len (16 bit), [ebp-4] = i (16 bit), [ebp-0xc] = h (16 bit), all word-sized. */
int32_t m423368_hash_name(uint32_t name, const Fl18Host *host)
{
    const uint8_t *s = mem_at(host, name);
    uint32_t n = 0;
    int16_t len, i, h;
    while (s[n] != 0) n++;
    len = (int16_t)n;
    h = (int16_t)rem1024(call1(host, 0x50cb1b, 0, name + 3u));
    if (h != 0) return h;
    for (i = 0; i < len; i = (int16_t)(i + 1)) {
        if (call1(host, 0x50d6cf, 0, (uintptr_t)(uint32_t)(int32_t)(int8_t)s[i]) != 0) {
            h = (int16_t)rem1024(call1(host, 0x50cb1b, 0, name + (uint32_t)(int32_t)i));
            return h;
        }
    }
    if (h == 0) h = (int16_t)(int8_t)s[0];
    return h;
}

/* ---- 0x4f356e ------------------------------------------------------------------------------------------------------------------ */

/* the Release of the object that the dword [rec + field] holds: `mov edx,[rec+f]; mov ecx,[rec+f]; mov eax,[ecx]; push edx; call [eax+8]` */
static void release_field(const Fl18Host *host, const uint8_t *rec, ptrdiff_t field)
{
    uintptr_t args[1];
    uint32_t obj = rd32(rec, field);
    uint32_t vtable = rd32(mem_at(host, obj), 0);
    uint32_t entry = rd32(mem_at(host, vtable), 8);
    args[0] = obj;
    host->call(host->context, entry, 0, args, 1);
}

/* 0x4f356e, thiscall, `ret 4`: see the header. [ebp-0x10] is `self`, [ebp-4] the record; [ebp-8] / [ebp-0xc] hold the dword [rec + 0x297]. */
uint32_t m4f356e_unload(uint8_t *self, uint32_t idx, const Fl18Host *host)
{
    uint8_t *rec;
    wr32(self, 0x3c2, 0x3e8);
    rec = NULL;
    {
        uint32_t rec_va = rd32(self, 0x3ce) + idx * 0x5bbu;
        if (call0(host, 0x4f709c, (uintptr_t)self) == 0) return 1;
        rec = mem_at(host, rec_va);
        if (rd32(rec, 0x162) != 0 && rd32(rec, 0x29b) != 0 && rd32(rec, 0x28f) != 0 && rd32(rec, 0x28b) != 0 && rd32(self, 0x3d6) > 0) {
            wr32(self, 0x3d6, rd32(self, 0x3d6) - 1u);
            wr32(rec, 0x28b, 0);
        }
        if (rd32(rec, 0x28f) != 0) {
            if (call1(host, 0x4f6334, (uintptr_t)self, idx) != 0) call1(host, 0x4f61e7, (uintptr_t)self, idx);
        }
        if (rd32(rec, 0x293) != 0) {
            release_field(host, rec, 0x293);
            wr32(rec, 0x293, 0);
        }
        if (rd32(rec, 0x297) != 0) {
            if (rd32(rec, 0x166) != 0)
                call1(host, 0x51dc6c, 0, rd32(rec, 0x297));
            else
                call1(host, 0x51dc6c, 0, rd32(rec, 0x297));
            wr32(rec, 0x297, 0);
        }
        if (rd32(rec, 0x29b) != 0) {
            release_field(host, rec, 0x29b);
            wr32(rec, 0x29b, 0);
        }
        if (rd32(rec, 0x28f) != 0) {
            release_field(host, rec, 0x28f);
            wr32(rec, 0x28f, 0);
        }
        if (rd32(rec, 0x2f1) != 0) {
            call1(host, 0x4fcef0, 0, rec_va + 0x2f1u);
            wr32(rec, 0x2f1, 0);
        }
        if (rd32(rec, 0x156) != 0) {
            call1(host, 0x50cee4, 0, rd32(rec, 0x156));
            wr32(rec, 0x156, 0);
        }
        wr32(rec, 0x162, 0);
        wr32(rec, 0x152, 0);
    }
    return 1;
}

/*NEXT*/
