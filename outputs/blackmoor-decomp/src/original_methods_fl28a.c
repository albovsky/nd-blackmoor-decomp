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

/* a host call with a prepared argument array (NULL-guarded like the helpers above) */
HELPER uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, nargs) : 0;
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
    return callv(host, entry, 0, args, nargs);
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
    callv(host, entry, 0, args, 1);
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

/* ---- 0x4fadc4 ------------------------------------------------------------------------------------------------------------------ */

/* The library routine __ftol at 0x50ce04 (called with the value on the x87 stack): fnstcw / fldcw with the rounding control forced to truncation, `fistp qword`, and
 * eax = the low dword of the 64-bit result. A NaN or a value outside the 64-bit range gives the integer indefinite 0x8000000000000000, whose low dword is 0. */
static uint32_t ftol_low_dword(double value)
{
    if (value != value) return 0;
    if (value >= 9223372036854775808.0 || value < -9223372036854775808.0) return 0;
    return (uint32_t)(int64_t)value;
}

static float rdf32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t bits = rd32(base, off);
    float f;
    memcpy(&f, &bits, sizeof f);
    return f;
}

/* the expression of one __ftol argument: fld dword [rec + field]; fmul dword [self + 4 * index + 0xb764]; fmul dword [0x52e4e0]; fadd qword [0x52e4d8] */
static uint32_t scaled_ftol(const uint8_t *self, ptrdiff_t rec, ptrdiff_t field)
{
    static const uint32_t scale_bits = 0x45329249u;                 /* the float at 0x52e4e0: 2857.142822265625 */
    static const uint64_t offset_bits = 0xc0a6524924924924ull;      /* the double at 0x52e4d8: -2857.142857142857 */
    float scale;
    double offset, v;
    int16_t index = (int16_t)rd16(self, rec + 0x10c);
    memcpy(&scale, &scale_bits, sizeof scale);
    memcpy(&offset, &offset_bits, sizeof offset);
    v = (double)rdf32(self, rec + field);
    v = v * (double)rdf32(self, (ptrdiff_t)index * 4 + 0xb764);
    v = v * (double)scale;
    v = v + offset;
    return ftol_low_dword(v);
}

/* 0x4fadc4, thiscall, `ret 8`: see the header. [ebp-4] is `self`. */
uint32_t m4fadc4_set_name(uint8_t *self, uint32_t name, uint32_t slot, const Fl28aWorld *world, const Fl18Host *host)
{
    uint32_t slot16 = slot & 0xffffu;
    ptrdiff_t rec = (ptrdiff_t)(slot16 * 0x5bbu);
    uint32_t second, r;
    if (world->word_63a4cd != 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x5605e0, slot16, name);
        call1(host, 0x44a2b7, 0, 0x63888b);
    }
    {
        const uint8_t *src = mem_at(host, name);
        size_t n = strlen((const char *)src) + 1u, i;
        uint8_t *dst = self + rec + 8;
        /* rep movsd then rep movsb, forward (defined on overlap: each dword is read, then written; the bytes follow) */
        for (i = 0; i + 4 <= n; i += 4) wr32(dst, (ptrdiff_t)i, rd32(src, (ptrdiff_t)i));
        for (; i < n; i++) dst[i] = src[i];
    }
    wr32(self, rec + 0x140, scaled_ftol(self, rec, 0x138));
    second = scaled_ftol(self, rec, 0x13c);
    wr32(self, rec + 0x144, second);
    r = call1(host, 0x4f379c, 0x5cf1eb, (second & 0xffff0000u) | slot16);
    if (r == 0) {
        uint32_t x = call0(host, 0x4fa2a8, 0x5cf1eb);
        uintptr_t args[5];
        args[0] = 0x63888b;
        args[1] = 0x560610;
        args[2] = slot16;
        args[3] = name;
        args[4] = x;
        callv(host, 0x50ca3e, 0, args, 5);
        call3(host, 0x52139c, 0, 0x63888b, 0, 0);
        if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x63888b);
        return 0;
    }
    wr16(self, rec + 0x132, 1);
    return 1;
}

/* ---- 0x423142 ------------------------------------------------------------------------------------------------------------------ */

#define INSERT_CHAIN_LIMIT 0x100000u

/* 0x423142, thiscall, `ret 8`: see the header. [ebp-0x24] is `self`, [ebp-0x14] the index, [ebp-0x10] the cell, [ebp-0x1c] the new node, [ebp-0x18] the constructor
 * result, [ebp-0x20] the buffer. */
uint32_t m423142_insert(uint8_t *self, uint32_t name, uint32_t value, const Fl18Host *host)
{
    uint32_t idx = call1(host, 0x423368, (uintptr_t)self, name);
    uint8_t *cell = self + (ptrdiff_t)(int32_t)(idx * 4u);
    uint32_t steps = 0, node, r, len, buf, name_len;
    const uint8_t *value_ptr, *name_ptr;
    uint8_t *object, *dest;
    while (rd32(cell, 0) != 0) {
        if (++steps > INSERT_CHAIN_LIMIT) return 0;
        cell = mem_at(host, rd32(cell, 0) + 0x25u);
        if (cell == NULL) return 0;
    }
    node = call1(host, 0x51dc43, 0, 0x29);
    r = node != 0 ? call0(host, 0x423000, node) : 0;
    wr32(cell, 0, r);
    value_ptr = mem_at(host, value);
    if (value_ptr == NULL) return 0;
    len = (uint32_t)strlen((const char *)value_ptr) + 1u;
    buf = call1(host, 0x51dc43, 0, len + 1u);
    object = mem_at(host, rd32(cell, 0));
    if (object == NULL) return 0;
    wr32(object, 0, buf);
    name_ptr = mem_at(host, name);
    if (name_ptr == NULL) return 0;
    name_len = (uint32_t)strlen((const char *)name_ptr) + 1u;
    if (name_len > 0x25u) return 0;
    memcpy(object + 4, name_ptr, name_len);
    dest = mem_at(host, rd32(object, 0));
    if (dest == NULL) return 0;
    memcpy(dest, value_ptr, len);
    return len;
}

/*NEXT*/
