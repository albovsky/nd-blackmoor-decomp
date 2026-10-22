#include "original_methods_fl39b.h"

#include <limits.h>
#include <string.h>

#if defined(__GNUC__)
#define FL39_UNUSED __attribute__((unused))
#else
#define FL39_UNUSED
#endif

FL39_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL39_UNUSED static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL39_UNUSED static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

FL39_UNUSED static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL39_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* host memory behind an original address (writable: the host owns the memory; the interface only says const) */
FL39_UNUSED static uint8_t *res(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

FL39_UNUSED static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

FL39_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

FL39_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

FL39_UNUSED static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    const uintptr_t a[2] = {a0, a1};
    return callv(host, callee, this_ptr, a, 2);
}

FL39_UNUSED static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    const uintptr_t a[3] = {a0, a1, a2};
    return callv(host, callee, this_ptr, a, 3);
}

FL39_UNUSED static uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3)
{
    const uintptr_t a[4] = {a0, a1, a2, a3};
    return callv(host, callee, this_ptr, a, 4);
}

/* the copy of the original: dwords (rep movsd), then a word, then a byte, forward and one unit at a time (a unit is read before it is written) */
static void clone_copy(uint8_t *dst, const uint8_t *src, uint32_t size)
{
    uint32_t k;
    for (k = 0; k < size / 4u; k++) {
        uint32_t v;
        memcpy(&v, src, 4);
        memcpy(dst, &v, 4);
        src += 4;
        dst += 4;
    }
    if ((size & 2u) != 0) {
        uint16_t v;
        memcpy(&v, src, 2);
        memcpy(dst, &v, 2);
        src += 2;
        dst += 2;
    }
    if ((size & 1u) != 0) *dst = *src;
}

/* ---- 0x484110 clone_record ---- */
/* 0x484110, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0xf07) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x54da20, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x54da4c, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659); on a null block the original goes on and stores through the null pointer: THIS PORT RETURNS 1 THERE (native rejection, not original behaviour; the oracle maps a zero page so that the rest of the original is executed). Otherwise (returns 0): the 0xf07 bytes at the address in dword [p1] are copied to the address in dword [p0] (rep movsd, movsw, movsb); dword [p2] += 0xf07, then dword [p1] += 0xf07; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x54da68) (cdecl, 1 argument). */
int32_t m484110_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0xf07);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x54da20, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x54da4c, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0xf07);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0xf07);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0xf07);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x54da68);
    return 0;
}

/* ---- 0x487bd7 clone_record ---- */
/* 0x487bd7, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0x5b3) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x54dd88, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x54ddb4, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659); on a null block the original goes on and stores through the null pointer: THIS PORT RETURNS 1 THERE (native rejection, not original behaviour; the oracle maps a zero page so that the rest of the original is executed). Otherwise (returns 0): the 0x5b3 bytes at the address in dword [p1] are copied to the address in dword [p0] (rep movsd, movsw, movsb); dword [p2] += 0x5b3, then dword [p1] += 0x5b3; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x54ddd0) (cdecl, 1 argument). */
int32_t m487bd7_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0x5b3);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x54dd88, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x54ddb4, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0x5b3);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0x5b3);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0x5b3);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x54ddd0);
    return 0;
}

/* ---- 0x48a865 clone_record ---- */
/* 0x48a865, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0x41b) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x54e2e4, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x54e310, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659); on a null block the original goes on and stores through the null pointer: THIS PORT RETURNS 1 THERE (native rejection, not original behaviour; the oracle maps a zero page so that the rest of the original is executed). Otherwise (returns 0): the 0x41b bytes at the address in dword [p1] are copied to the address in dword [p0] (rep movsd, movsw, movsb); dword [p2] += 0x41b, then dword [p1] += 0x41b; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x54e32c) (cdecl, 1 argument). */
int32_t m48a865_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0x41b);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x54e2e4, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x54e310, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0x41b);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0x41b);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0x41b);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x54e32c);
    return 0;
}

/* ---- 0x48d12d clone_record ---- */
/* 0x48d12d, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0x7bb) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x54e814, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x54e840, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659); on a null block the original goes on and stores through the null pointer: THIS PORT RETURNS 1 THERE (native rejection, not original behaviour; the oracle maps a zero page so that the rest of the original is executed). Otherwise (returns 0): the 0x7bb bytes at the address in dword [p1] are copied to the address in dword [p0] (rep movsd, movsw, movsb); dword [p2] += 0x7bb, then dword [p1] += 0x7bb; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x54e85c) (cdecl, 1 argument). */
int32_t m48d12d_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0x7bb);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x54e814, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x54e840, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0x7bb);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0x7bb);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0x7bb);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x54e85c);
    return 0;
}

/* ---- 0x493b7a clone_record ---- */
/* 0x493b7a, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0xc6) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x54f784, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x54f7b0, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659); on a null block the original goes on and stores through the null pointer: THIS PORT RETURNS 1 THERE (native rejection, not original behaviour; the oracle maps a zero page so that the rest of the original is executed). Otherwise (returns 0): the 0xc6 bytes at the address in dword [p1] are copied to the address in dword [p0] (rep movsd, movsw); dword [p2] += 0xc6, then dword [p1] += 0xc6; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x54f7cc) (cdecl, 1 argument). */
int32_t m493b7a_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0xc6);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x54f784, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x54f7b0, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0xc6);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0xc6);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0xc6);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x54f7cc);
    return 0;
}

/* ---- 0x4a3a33 clone_record ---- */
/* 0x4a3a33, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0x6c1) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x5504f0, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x55051c, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659); on a null block the original goes on and stores through the null pointer: THIS PORT RETURNS 1 THERE (native rejection, not original behaviour; the oracle maps a zero page so that the rest of the original is executed). Otherwise (returns 0): the 0x6c1 bytes at the address in dword [p1] are copied to the address in dword [p0] (rep movsd, movsb); dword [p2] += 0x6c1, then dword [p1] += 0x6c1; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x550538) (cdecl, 1 argument). */
int32_t m4a3a33_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0x6c1);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x5504f0, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x55051c, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0x6c1);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0x6c1);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0x6c1);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x550538);
    return 0;
}

/* ---- 0x4a64b9 clone_record ---- */
/* 0x4a64b9, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0x3d7) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x5508f0, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x55091c, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659); on a null block the original goes on and stores through the null pointer: THIS PORT RETURNS 1 THERE (native rejection, not original behaviour; the oracle maps a zero page so that the rest of the original is executed). Otherwise (returns 0): the 0x3d7 bytes at the address in dword [p1] are copied to the address in dword [p0] (rep movsd, movsw, movsb); dword [p2] += 0x3d7, then dword [p1] += 0x3d7; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x550938) (cdecl, 1 argument). */
int32_t m4a64b9_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0x3d7);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x5508f0, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x55091c, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0x3d7);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0x3d7);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0x3d7);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x550938);
    return 0;
}

/* ---- 0x4a7e50 clone_record ---- */
/* 0x4a7e50, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0x44c) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x550b2c, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x550b58, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659); on a null block the original goes on and stores through the null pointer: THIS PORT RETURNS 1 THERE (native rejection, not original behaviour; the oracle maps a zero page so that the rest of the original is executed). Otherwise (returns 0): the 0x44c bytes at the address in dword [p1] are copied to the address in dword [p0] (rep movsd); dword [p2] += 0x44c, then dword [p1] += 0x44c; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x550b74) (cdecl, 1 argument). */
int32_t m4a7e50_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0x44c);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x550b2c, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x550b58, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0x44c);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0x44c);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0x44c);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x550b74);
    return 0;
}

/* ---- 0x4ab46d clone_record ---- */
/* 0x4ab46d, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0xbbf) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x550f40, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x550f6c, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659); on a null block the original goes on and stores through the null pointer: THIS PORT RETURNS 1 THERE (native rejection, not original behaviour; the oracle maps a zero page so that the rest of the original is executed). Otherwise (returns 0): the 0xbbf bytes at the address in dword [p1] are copied to the address in dword [p0] (rep movsd, movsw, movsb); dword [p2] += 0xbbf, then dword [p1] += 0xbbf; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x550f88) (cdecl, 1 argument). */
int32_t m4ab46d_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0xbbf);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x550f40, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x550f6c, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0xbbf);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0xbbf);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0xbbf);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x550f88);
    return 0;
}

/* ---- 0x4acbf1 clone_record ---- */
/* 0x4acbf1, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0x33a) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x551158, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x551184, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659); on a null block the original goes on and stores through the null pointer: THIS PORT RETURNS 1 THERE (native rejection, not original behaviour; the oracle maps a zero page so that the rest of the original is executed). Otherwise (returns 0): the 0x33a bytes at the address in dword [p1] are copied to the address in dword [p0] (rep movsd, movsw); dword [p2] += 0x33a, then dword [p1] += 0x33a; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x5511a0) (cdecl, 1 argument). */
int32_t m4acbf1_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0x33a);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x551158, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x551184, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0x33a);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0x33a);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0x33a);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x5511a0);
    return 0;
}

/* ---- 0x4afe09 clone_record ---- */
/* 0x4afe09, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0x37c) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x5516e8, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x551714, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659); on a null block the original goes on and stores through the null pointer: THIS PORT RETURNS 1 THERE (native rejection, not original behaviour; the oracle maps a zero page so that the rest of the original is executed). Otherwise (returns 0): the 0x37c bytes at the address in dword [p1] are copied to the address in dword [p0] (rep movsd); dword [p2] += 0x37c, then dword [p1] += 0x37c; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x551730) (cdecl, 1 argument). */
int32_t m4afe09_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0x37c);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x5516e8, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x551714, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0x37c);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0x37c);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0x37c);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x551730);
    return 0;
}

/* ---- 0x4b3ddf clone_record ---- */
/* 0x4b3ddf, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0x8ae) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x5518e0, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x55190c, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659); on a null block the original goes on and stores through the null pointer: THIS PORT RETURNS 1 THERE (native rejection, not original behaviour; the oracle maps a zero page so that the rest of the original is executed). Otherwise (returns 0): the 0x8ae bytes at the address in dword [p1] are copied to the address in dword [p0] (rep movsd, movsw); dword [p2] += 0x8ae, then dword [p1] += 0x8ae; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x551928) (cdecl, 1 argument). */
int32_t m4b3ddf_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0x8ae);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x5518e0, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x55190c, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0x8ae);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0x8ae);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0x8ae);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x551928);
    return 0;
}

/* ---- 0x4b72cf clone_record ---- */
/* 0x4b72cf, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0x3c6) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x551bd8, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x551c04, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659); on a null block the original goes on and stores through the null pointer: THIS PORT RETURNS 1 THERE (native rejection, not original behaviour; the oracle maps a zero page so that the rest of the original is executed). Otherwise (returns 0): the 0x3c6 bytes at the address in dword [p1] are copied to the address in dword [p0] (rep movsd, movsw); dword [p2] += 0x3c6, then dword [p1] += 0x3c6; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x551c20) (cdecl, 1 argument). */
int32_t m4b72cf_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0x3c6);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x551bd8, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x551c04, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0x3c6);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0x3c6);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0x3c6);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x551c20);
    return 0;
}

/* ---- 0x4b80d9 clone_record ---- */
/* 0x4b80d9, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0x56e) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x551d34, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x551d60, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659); on a null block the original goes on and stores through the null pointer: THIS PORT RETURNS 1 THERE (native rejection, not original behaviour; the oracle maps a zero page so that the rest of the original is executed). Otherwise (returns 0): the 0x56e bytes at the address in dword [p1] are copied to the address in dword [p0] (rep movsd, movsw); dword [p2] += 0x56e, then dword [p1] += 0x56e; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x551d7c) (cdecl, 1 argument). */
int32_t m4b80d9_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0x56e);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x551d34, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x551d60, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0x56e);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0x56e);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0x56e);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x551d7c);
    return 0;
}

/* ---- 0x4ba2bd clone_record ---- */
/* 0x4ba2bd, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0xae2) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x551edc, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x551f08, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659); on a null block the original goes on and stores through the null pointer: THIS PORT RETURNS 1 THERE (native rejection, not original behaviour; the oracle maps a zero page so that the rest of the original is executed). Otherwise (returns 0): the 0xae2 bytes at the address in dword [p1] are copied to the address in dword [p0] (rep movsd, movsw); dword [p2] += 0xae2, then dword [p1] += 0xae2; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x551f24) (cdecl, 1 argument). */
int32_t m4ba2bd_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0xae2);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x551edc, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x551f08, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0xae2);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0xae2);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0xae2);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x551f24);
    return 0;
}

/* ---- 0x4e9a2c clone_record ---- */
/* 0x4e9a2c, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0x72) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x55c7b0, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x55c7dc, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659); on a null block the original goes on and stores through the null pointer: THIS PORT RETURNS 1 THERE (native rejection, not original behaviour; the oracle maps a zero page so that the rest of the original is executed). Otherwise (returns 0): the 0x72 bytes at the address in dword [p1] are copied to the address in dword [p0] (rep movsd, movsw); dword [p2] += 0x72, then dword [p1] += 0x72; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x55c7f8) (cdecl, 1 argument). */
int32_t m4e9a2c_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0x72);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x55c7b0, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x55c7dc, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0x72);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0x72);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0x72);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x55c7f8);
    return 0;
}

/* ---- 0x4e9add clone_record ---- */
/* 0x4e9add, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0x2) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x55c834, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x55c860, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659); on a null block the original goes on and stores through the null pointer: THIS PORT RETURNS 1 THERE (native rejection, not original behaviour; the oracle maps a zero page so that the rest of the original is executed). Otherwise (returns 0): the 0x2 bytes at the address in dword [p1] are copied to the address in dword [p0] (one word move); dword [p2] += 0x2, then dword [p1] += 0x2; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x55c87c) (cdecl, 1 argument). */
int32_t m4e9add_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0x2);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x55c834, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x55c860, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0x2);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0x2);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0x2);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x55c87c);
    return 0;
}

/* ---- 0x4e9b87 clone_record ---- */
/* 0x4e9b87, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0x4) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x55c8b8, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x55c8e4, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659); on a null block the original goes on and stores through the null pointer: THIS PORT RETURNS 1 THERE (native rejection, not original behaviour; the oracle maps a zero page so that the rest of the original is executed). Otherwise (returns 0): the 0x4 bytes at the address in dword [p1] are copied to the address in dword [p0] (one dword move); dword [p2] += 0x4, then dword [p1] += 0x4; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x55c900) (cdecl, 1 argument). */
int32_t m4e9b87_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0x4);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x55c8b8, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x55c8e4, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0x4);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0x4);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0x4);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x55c900);
    return 0;
}

/* ---- 0x4e9cdf clone_record ---- */
/* 0x4e9cdf, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0x6) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x55c9b4, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x55c9e0, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659); on a null block the original goes on and stores through the null pointer: THIS PORT RETURNS 1 THERE (native rejection, not original behaviour; the oracle maps a zero page so that the rest of the original is executed). Otherwise (returns 0): the 0x6 bytes at the address in dword [p1] are copied to the address in dword [p0] (a dword move and a word move); dword [p2] += 0x6, then dword [p1] += 0x6; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x55c9fc) (cdecl, 1 argument). */
int32_t m4e9cdf_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0x6);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x55c9b4, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x55c9e0, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;      /* native rejection: the original goes on and stores through the null pointer */
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0x6);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0x6);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0x6);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x55c9fc);
    return 0;
}

/* ---- 0x4fcda1 clone_record ---- */
/* 0x4fcda1, thiscall (ecx is stored in a local and never read), `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: blk = 0x51dc43(0x16) (cdecl, 1 argument) is stored to dword [p0]. When blk == 0: 0x50ca3e(0x63888b, 0x5609f0, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x560a1c, 0x63888b) (thiscall, 2 arguments), dword 0x63a58a = 5 (before 0x4c97b4) and 0x4c97b4(this 0x5cf659); the exit of the reporting path is `jmp` to the end (dword 0x63a58a = 5 is stored before 0x4c97b4 and nothing is copied). Otherwise (returns 0): the 0x16 bytes at the address in dword [p1] are copied to the address in dword [p0] (rep movsd, movsw); dword [p2] += 0x16, then dword [p1] += 0x16; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x560a38) (cdecl, 1 argument). */
int32_t m4fcda1_clone_record(uint32_t dst_cell, uint32_t src_cell, uint32_t count_cell, Fl39bWorld *world, const Fl18Host *host)
{
    uint32_t blk = call1(host, 0x51dc43, 0, 0x16);
    wr32(res(host, dst_cell), 0, blk);
    if (blk == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x5609f0, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x560a1c, 0x63888b);
        world->value_63a58a = 5;
        call0(host, 0x4c97b4, 0x5cf659);
        return 0;
    }
    clone_copy(res(host, rd32(res(host, dst_cell), 0)), res(host, rd32(res(host, src_cell), 0)), 0x16);
    wr32(res(host, count_cell), 0, rd32(res(host, count_cell), 0) + 0x16);
    wr32(res(host, src_cell), 0, rd32(res(host, src_cell), 0) + 0x16);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x560a38);
    return 0;
}
