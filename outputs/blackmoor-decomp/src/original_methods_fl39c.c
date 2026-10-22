#include "original_methods_fl39c.h"

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

/* ---- 0x4a3aec clamp_rect ---- */
/* 0x4a3aec, thiscall, plain `ret`, no return value, no calls: two bounds of a rectangle clamped against the signed globals. y: when the signed dword [self+0x22c] < [0x58319a] it becomes that value and [self+0x234] = it + the signed word [self+0x832]; then when [self+0x234] > [0x5831a2] (signed) it becomes that value and [self+0x22c] = it - the word. x: the same with [self+0x228], [self+0x230], [0x583196], [0x58319e] and the signed word [self+0x830]. */
void m4a3aec_clamp_rect(uint8_t *self, const Fl39cWorld *world)
{
    if ((int32_t)rd32(self, 0x22c) < world->value_58319a) {
        wr32(self, 0x22c, (uint32_t)world->value_58319a);
        wr32(self, 0x234, rd32(self, 0x22c) + (uint32_t)rds16(self, 0x832));
    }
    if ((int32_t)rd32(self, 0x234) > world->value_5831a2) {
        wr32(self, 0x234, (uint32_t)world->value_5831a2);
        wr32(self, 0x22c, rd32(self, 0x234) - (uint32_t)rds16(self, 0x832));
    }
    if ((int32_t)rd32(self, 0x228) < world->value_583196) {
        wr32(self, 0x228, (uint32_t)world->value_583196);
        wr32(self, 0x230, rd32(self, 0x228) + (uint32_t)rds16(self, 0x830));
    }
    if ((int32_t)rd32(self, 0x230) > world->value_58319e) {
        wr32(self, 0x230, (uint32_t)world->value_58319e);
        wr32(self, 0x228, rd32(self, 0x230) - (uint32_t)rds16(self, 0x830));
    }
}

/* ---- 0x4a7f08 clamp_rect ---- */
/* 0x4a7f08, thiscall, plain `ret`, no return value, no calls: two bounds of a rectangle clamped against the signed globals. y: when the signed dword [self+0xe2a] < [0x58319a] it becomes that value and [self+0xe32] = it + the signed word [self+0x13a6]; then when [self+0xe32] > [0x5831a2] (signed) it becomes that value and [self+0xe2a] = it - the word. x: the same with [self+0xe26], [self+0xe2e], [0x583196], [0x58319e] and the signed word [self+0x13a4]. */
void m4a7f08_clamp_rect(uint8_t *self, const Fl39cWorld *world)
{
    if ((int32_t)rd32(self, 0xe2a) < world->value_58319a) {
        wr32(self, 0xe2a, (uint32_t)world->value_58319a);
        wr32(self, 0xe32, rd32(self, 0xe2a) + (uint32_t)rds16(self, 0x13a6));
    }
    if ((int32_t)rd32(self, 0xe32) > world->value_5831a2) {
        wr32(self, 0xe32, (uint32_t)world->value_5831a2);
        wr32(self, 0xe2a, rd32(self, 0xe32) - (uint32_t)rds16(self, 0x13a6));
    }
    if ((int32_t)rd32(self, 0xe26) < world->value_583196) {
        wr32(self, 0xe26, (uint32_t)world->value_583196);
        wr32(self, 0xe2e, rd32(self, 0xe26) + (uint32_t)rds16(self, 0x13a4));
    }
    if ((int32_t)rd32(self, 0xe2e) > world->value_58319e) {
        wr32(self, 0xe2e, (uint32_t)world->value_58319e);
        wr32(self, 0xe26, rd32(self, 0xe2e) - (uint32_t)rds16(self, 0x13a4));
    }
}

/* ---- 0x4ada0d check_bytes ---- */
/* 0x4ada0d, thiscall, plain `ret`, no return value: the dword [self+0xc17] is the address of an object; `repe cmpsb` of the nine bytes at [object+0x296] against the nine bytes at 0x5511d4; when they differ, 0x4fb2e3(this = 0x5c3a67) (thiscall, one argument) with the word [object+0x2b7] (zero-extended: edx is cleared first); otherwise nothing. */
void m4ada0d_check_bytes(const uint8_t *self, const Fl39cWorld *world, const Fl18Host *host)
{
    const uint8_t *k = world->bytes_5511d4;
    const uint8_t *p = res(host, rd32(self, 0xc17));
    int i;
    for (i = 0; i < 9; i++)
        if (p[0x296 + i] != k[i]) break;
    if (i != 9) {
        p = res(host, rd32(self, 0xc17));
        (void)call1(host, 0x4fb2e3, 0x5c3a67, (uintptr_t)rd16(p, 0x2b7));
    }
}

/* ---- 0x4ada56 check_bytes ---- */
/* 0x4ada56, thiscall, plain `ret`, no return value: the dword [self+0xc17] is the address of an object; `repe cmpsb` of the nine bytes at [object+0x234] against the nine bytes at 0x5511e0; when they differ, 0x4fb2e3(this = 0x5c3a67) (thiscall, one argument) with the word [object+0x255] (zero-extended: edx is cleared first); otherwise nothing. */
void m4ada56_check_bytes(const uint8_t *self, const Fl39cWorld *world, const Fl18Host *host)
{
    const uint8_t *k = world->bytes_5511e0;
    const uint8_t *p = res(host, rd32(self, 0xc17));
    int i;
    for (i = 0; i < 9; i++)
        if (p[0x234 + i] != k[i]) break;
    if (i != 9) {
        p = res(host, rd32(self, 0xc17));
        (void)call1(host, 0x4fb2e3, 0x5c3a67, (uintptr_t)rd16(p, 0x255));
    }
}

/* ---- 0x4ada9f check_bytes ---- */
/* 0x4ada9f, thiscall, plain `ret`, no return value: the dword [self+0xc17] is the address of an object; `repe cmpsb` of the nine bytes at [object+0x265] against the nine bytes at 0x5511ec; when they differ, 0x4fb2e3(this = 0x5c3a67) (thiscall, one argument) with the word [object+0x286] (zero-extended: edx is cleared first); otherwise nothing. */
void m4ada9f_check_bytes(const uint8_t *self, const Fl39cWorld *world, const Fl18Host *host)
{
    const uint8_t *k = world->bytes_5511ec;
    const uint8_t *p = res(host, rd32(self, 0xc17));
    int i;
    for (i = 0; i < 9; i++)
        if (p[0x265 + i] != k[i]) break;
    if (i != 9) {
        p = res(host, rd32(self, 0xc17));
        (void)call1(host, 0x4fb2e3, 0x5c3a67, (uintptr_t)rd16(p, 0x286));
    }
}

/* ---- 0x4b3e99 clamp_rect ---- */
/* 0x4b3e99, thiscall, plain `ret`, no return value, no calls: two bounds of a rectangle clamped against the signed globals. y: when the signed dword [self+0x6e0] < [0x58319a] it becomes that value and [self+0x6e8] = it + the signed word [self+0x722]; then when [self+0x6e8] > [0x5831a2] (signed) it becomes that value and [self+0x6e0] = it - the word. x: the same with [self+0x6dc], [self+0x6e4], [0x583196], [0x58319e] and the signed word [self+0x71e]. */
void m4b3e99_clamp_rect(uint8_t *self, const Fl39cWorld *world)
{
    if ((int32_t)rd32(self, 0x6e0) < world->value_58319a) {
        wr32(self, 0x6e0, (uint32_t)world->value_58319a);
        wr32(self, 0x6e8, rd32(self, 0x6e0) + (uint32_t)rds16(self, 0x722));
    }
    if ((int32_t)rd32(self, 0x6e8) > world->value_5831a2) {
        wr32(self, 0x6e8, (uint32_t)world->value_5831a2);
        wr32(self, 0x6e0, rd32(self, 0x6e8) - (uint32_t)rds16(self, 0x722));
    }
    if ((int32_t)rd32(self, 0x6dc) < world->value_583196) {
        wr32(self, 0x6dc, (uint32_t)world->value_583196);
        wr32(self, 0x6e4, rd32(self, 0x6dc) + (uint32_t)rds16(self, 0x71e));
    }
    if ((int32_t)rd32(self, 0x6e4) > world->value_58319e) {
        wr32(self, 0x6e4, (uint32_t)world->value_58319e);
        wr32(self, 0x6dc, rd32(self, 0x6e4) - (uint32_t)rds16(self, 0x71e));
    }
}

/* ---- 0x4be3d3 check_bytes ---- */
/* 0x4be3d3, thiscall, plain `ret`, no return value: `repe cmpsb` of the nine bytes at [self+0x31c] against the nine bytes at 0x55214c; when they differ, 0x4fb2e3(this = 0x5c3a67) (thiscall, one argument) with the word [self+0x33d] (pushed from edx whose upper half is left-over: the callee reads a word); otherwise nothing. */
void m4be3d3_check_bytes(const uint8_t *self, const Fl39cWorld *world, const Fl18Host *host)
{
    const uint8_t *k = world->bytes_55214c;
    int i;
    for (i = 0; i < 9; i++)
        if (self[0x31c + i] != k[i]) break;
    if (i != 9) (void)call1(host, 0x4fb2e3, 0x5c3a67, (uintptr_t)rd16(self, 0x33d));
}

/* ---- 0x4be410 check_bytes ---- */
/* 0x4be410, thiscall, plain `ret`, no return value: `repe cmpsb` of the nine bytes at [self+0x34d] against the nine bytes at 0x552158; when they differ, 0x4fb2e3(this = 0x5c3a67) (thiscall, one argument) with the word [self+0x36e] (pushed from edx whose upper half is left-over: the callee reads a word); otherwise nothing. */
void m4be410_check_bytes(const uint8_t *self, const Fl39cWorld *world, const Fl18Host *host)
{
    const uint8_t *k = world->bytes_552158;
    int i;
    for (i = 0; i < 9; i++)
        if (self[0x34d + i] != k[i]) break;
    if (i != 9) (void)call1(host, 0x4fb2e3, 0x5c3a67, (uintptr_t)rd16(self, 0x36e));
}

/* ---- 0x4be44d check_bytes ---- */
/* 0x4be44d, thiscall, plain `ret`, no return value: `repe cmpsb` of the nine bytes at [self+0x37e] against the nine bytes at 0x552164; when they differ, 0x4fb2e3(this = 0x5c3a67) (thiscall, one argument) with the word [self+0x39f] (pushed from edx whose upper half is left-over: the callee reads a word); otherwise nothing. */
void m4be44d_check_bytes(const uint8_t *self, const Fl39cWorld *world, const Fl18Host *host)
{
    const uint8_t *k = world->bytes_552164;
    int i;
    for (i = 0; i < 9; i++)
        if (self[0x37e + i] != k[i]) break;
    if (i != 9) (void)call1(host, 0x4fb2e3, 0x5c3a67, (uintptr_t)rd16(self, 0x39f));
}

/* ---- 0x4be48a check_bytes ---- */
/* 0x4be48a, thiscall, plain `ret`, no return value: `repe cmpsb` of the nine bytes at [self+0x3af] against the nine bytes at 0x552170; when they differ, 0x4fb2e3(this = 0x5c3a67) (thiscall, one argument) with the word [self+0x3d0] (pushed from edx whose upper half is left-over: the callee reads a word); otherwise nothing. */
void m4be48a_check_bytes(const uint8_t *self, const Fl39cWorld *world, const Fl18Host *host)
{
    const uint8_t *k = world->bytes_552170;
    int i;
    for (i = 0; i < 9; i++)
        if (self[0x3af + i] != k[i]) break;
    if (i != 9) (void)call1(host, 0x4fb2e3, 0x5c3a67, (uintptr_t)rd16(self, 0x3d0));
}

/* ---- 0x4be4c7 check_bytes ---- */
/* 0x4be4c7, thiscall, plain `ret`, no return value: `repe cmpsb` of the nine bytes at [self+0x411] against the nine bytes at 0x55217c; when they differ, 0x4fb2e3(this = 0x5c3a67) (thiscall, one argument) with the word [self+0x432] (pushed from edx whose upper half is left-over: the callee reads a word); otherwise nothing. */
void m4be4c7_check_bytes(const uint8_t *self, const Fl39cWorld *world, const Fl18Host *host)
{
    const uint8_t *k = world->bytes_55217c;
    int i;
    for (i = 0; i < 9; i++)
        if (self[0x411 + i] != k[i]) break;
    if (i != 9) (void)call1(host, 0x4fb2e3, 0x5c3a67, (uintptr_t)rd16(self, 0x432));
}

/* ---- 0x4be619 alloc_zero ---- */
/* 0x4be619, cdecl-style stack arguments (out, size), `ret 8`, returns the eax of the failure path (0 otherwise): p = 0x51dc43(size) (cdecl); dword [out] = p; when p == 0: 0x50ca3e(0x63888b, 0x552190) (cdecl), 0x4264e8(0x63888b) on 0x583979 (thiscall), 0x44a2b7(0x63888b) (cdecl) only when the debug word 0x63a4cd is non-zero, then the eax of 0x4c97b4 on 0x5cf659 (thiscall); otherwise `size` bytes at p are zeroed (`rep stosd`, then `rep stosb` for size & 3). `self` (ecx) is not used. */
uint32_t m4be619_alloc_zero(uint8_t *out, uint32_t size, const Fl39cWorld *world, const Fl18Host *host)
{
    uint32_t p = call1(host, 0x51dc43, 0, size);
    wr32(out, 0, p);
    if (p == 0) {
        (void)call2(host, 0x50ca3e, 0, 0x63888b, 0x552190);
        (void)call1(host, 0x4264e8, 0x583979, 0x63888b);
        if (world->word_63a4cd != 0) (void)call1(host, 0x44a2b7, 0, 0x63888b);
        return call0(host, 0x4c97b4, 0x5cf659);
    }
    memset(res(host, rd32(out, 0)), 0, size);
    return 0;
}

/* ---- 0x4bf542 alloc_zero ---- */
/* 0x4bf542, cdecl-style stack arguments (out, size), `ret 8`, returns the eax of the failure path (0 otherwise): p = 0x51dc43(size) (cdecl); dword [out] = p; when p == 0: 0x50ca3e(0x63888b, 0x5525ac) (cdecl), 0x4264e8(0x63888b) on 0x583979 (thiscall), 0x44a2b7(0x63888b) (cdecl) only when the debug word 0x63a4cd is non-zero, then the eax of 0x4c97b4 on 0x5cf659 (thiscall); otherwise `size` bytes at p are zeroed (`rep stosd`, then `rep stosb` for size & 3). `self` (ecx) is not used. */
uint32_t m4bf542_alloc_zero(uint8_t *out, uint32_t size, const Fl39cWorld *world, const Fl18Host *host)
{
    uint32_t p = call1(host, 0x51dc43, 0, size);
    wr32(out, 0, p);
    if (p == 0) {
        (void)call2(host, 0x50ca3e, 0, 0x63888b, 0x5525ac);
        (void)call1(host, 0x4264e8, 0x583979, 0x63888b);
        if (world->word_63a4cd != 0) (void)call1(host, 0x44a2b7, 0, 0x63888b);
        return call0(host, 0x4c97b4, 0x5cf659);
    }
    memset(res(host, rd32(out, 0)), 0, size);
    return 0;
}

/* ---- 0x4cb8d5 get_via_out ---- */
/* 0x4cb8d5, thiscall, plain `ret`, returns the local: a dword local is cleared, 0x4cc70f(this = self, &local, 0x18) (thiscall, two arguments) may store through the pointer, and the function returns the local (not the eax of the callee). */
uint32_t m4cb8d5_get_via_out(uint8_t *self, const Fl18Host *host)
{
    uint32_t out = 0;
    (void)call2(host, 0x4cc70f, (uintptr_t)self, (uintptr_t)&out, 0x18);
    return out;
}

/* ---- 0x4cb8fa get_via_out ---- */
/* 0x4cb8fa, thiscall, plain `ret`, returns the local: a dword local is cleared, 0x4cc70f(this = self, &local, 0xd) (thiscall, two arguments) may store through the pointer, and the function returns the local (not the eax of the callee). */
uint32_t m4cb8fa_get_via_out(uint8_t *self, const Fl18Host *host)
{
    uint32_t out = 0;
    (void)call2(host, 0x4cc70f, (uintptr_t)self, (uintptr_t)&out, 0xd);
    return out;
}

/* ---- 0x4cb91f get_via_out ---- */
/* 0x4cb91f, thiscall, plain `ret`, returns the local: a dword local is cleared, 0x4cc70f(this = self, &local, 0x29) (thiscall, two arguments) may store through the pointer, and the function returns the local (not the eax of the callee). */
uint32_t m4cb91f_get_via_out(uint8_t *self, const Fl18Host *host)
{
    uint32_t out = 0;
    (void)call2(host, 0x4cc70f, (uintptr_t)self, (uintptr_t)&out, 0x29);
    return out;
}

/* ---- 0x4cc70f alloc_zero ---- */
/* 0x4cc70f, cdecl-style stack arguments (out, size), `ret 8`, returns the eax of the failure path (0 otherwise): p = 0x51dc43(size) (cdecl); dword [out] = p; when p == 0: 0x50ca3e(0x63888b, 0x559038) (cdecl), 0x4264e8(0x63888b) on 0x583979 (thiscall), 0x44a2b7(0x63888b) (cdecl) only when the debug word 0x63a4cd is non-zero, then the eax of 0x4c97b4 on 0x5cf659 (thiscall); otherwise `size` bytes at p are zeroed (`rep stosd`, then `rep stosb` for size & 3). `self` (ecx) is not used. */
uint32_t m4cc70f_alloc_zero(uint8_t *out, uint32_t size, const Fl39cWorld *world, const Fl18Host *host)
{
    uint32_t p = call1(host, 0x51dc43, 0, size);
    wr32(out, 0, p);
    if (p == 0) {
        (void)call2(host, 0x50ca3e, 0, 0x63888b, 0x559038);
        (void)call1(host, 0x4264e8, 0x583979, 0x63888b);
        if (world->word_63a4cd != 0) (void)call1(host, 0x44a2b7, 0, 0x63888b);
        return call0(host, 0x4c97b4, 0x5cf659);
    }
    memset(res(host, rd32(out, 0)), 0, size);
    return 0;
}

/* ---- 0x4d9910 alloc_zero ---- */
/* 0x4d9910, cdecl-style stack arguments (out, size), `ret 8`, returns the eax of the failure path (0 otherwise): p = 0x51dc43(size) (cdecl); dword [out] = p; when p == 0: 0x50ca3e(0x63888b, 0x55aa34) (cdecl), 0x4264e8(0x63888b) on 0x583979 (thiscall), 0x44a2b7(0x63888b) (cdecl) only when the debug word 0x63a4cd is non-zero, then the eax of 0x4c97b4 on 0x5cf659 (thiscall); otherwise `size` bytes at p are zeroed (`rep stosd`, then `rep stosb` for size & 3). `self` (ecx) is not used. */
uint32_t m4d9910_alloc_zero(uint8_t *out, uint32_t size, const Fl39cWorld *world, const Fl18Host *host)
{
    uint32_t p = call1(host, 0x51dc43, 0, size);
    wr32(out, 0, p);
    if (p == 0) {
        (void)call2(host, 0x50ca3e, 0, 0x63888b, 0x55aa34);
        (void)call1(host, 0x4264e8, 0x583979, 0x63888b);
        if (world->word_63a4cd != 0) (void)call1(host, 0x44a2b7, 0, 0x63888b);
        return call0(host, 0x4c97b4, 0x5cf659);
    }
    memset(res(host, rd32(out, 0)), 0, size);
    return 0;
}

/* ---- 0x4de394 copy_block ---- */
/* 0x4de394, thiscall, stack arguments (src, limit), `ret 8`, no return value: copies 192 dwords (0x300 bytes) from src to [self+0x691]; when 0x300 > limit (signed): 0x50ca3e(0x63888b, 0x55b87c, 0x300, limit) (cdecl, four arguments), 0x4264e8(0x63888b) on 0x583979 (thiscall), 0x4c97b4 on 0x5cf659 (thiscall, no argument). */
void m4de394_copy_block(uint8_t *self, const uint8_t *src, int32_t limit, const Fl18Host *host)
{
    memcpy(self + 0x691, src, 0x300);
    if ((int32_t)0x300 > limit) {
        (void)call4(host, 0x50ca3e, 0, 0x63888b, 0x55b87c, 0x300, (uintptr_t)(uint32_t)limit);
        (void)call1(host, 0x4264e8, 0x583979, 0x63888b);
        (void)call0(host, 0x4c97b4, 0x5cf659);
    }
}

/* ---- 0x4e2d63 destroy_vector ---- */
/* 0x4e2d63, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52e4ecu at [this], then 0x4e2faa(this) (thiscall, no arguments), 0x50cba8(this + 0x1ca2, 0x18f, 26, 0x4e1c83) (cdecl, four arguments: the vector iterator) and 0x4eda7c(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5289f2) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m4e2d63_destroy_vector(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e4ecu);
    (void)call0(host, 0x4e2faa, (uintptr_t)self);
    (void)call4(host, 0x50cba8, 0, (uintptr_t)(self + 0x1ca2), 0x18f, 26, 0x4e1c83);
    return call0(host, 0x4eda7c, (uintptr_t)self);
}

/* ---- 0x4e3525 set_field_forward ---- */
/* 0x4e3525, thiscall, `ret 4`, returns the eax of the callee: stores the stack argument in the dword [self+0x452c], then 0x4edf96(this = self, the same argument) (thiscall, one argument). */
uint32_t m4e3525_set_field_forward(uint8_t *self, uint32_t arg, const Fl18Host *host)
{
    wr32(self, 0x452c, arg);
    return call1(host, 0x4edf96, (uintptr_t)self, arg);
}

/* ---- 0x4e37bd call_three_zero ---- */
/* 0x4e37bd, thiscall, plain `ret`, returns the eax of the last callee: 0x4e2940(this = self+0x3d5d, 0), 0x4e2940(this = self+0x3eec, 0) and 0x4e2940(this = self+0x4399, 0), each thiscall with one argument 0. */
uint32_t m4e37bd_call_three_zero(uint8_t *self, const Fl18Host *host)
{
    (void)call1(host, 0x4e2940, (uintptr_t)(self + 0x3d5d), 0);
    (void)call1(host, 0x4e2940, (uintptr_t)(self + 0x3eec), 0);
    return call1(host, 0x4e2940, (uintptr_t)(self + 0x4399), 0);
}

/* ---- 0x4e37f8 call_three_zero ---- */
/* 0x4e37f8, thiscall, plain `ret`, returns the eax of the last callee: 0x4e2940(this = self+0x3d5d, 0), 0x4e2940(this = self+0x3eec, 0) and 0x4e2940(this = self+0x4399, 0), each thiscall with one argument 0. */
uint32_t m4e37f8_call_three_zero(uint8_t *self, const Fl18Host *host)
{
    (void)call1(host, 0x4e2940, (uintptr_t)(self + 0x3d5d), 0);
    (void)call1(host, 0x4e2940, (uintptr_t)(self + 0x3eec), 0);
    return call1(host, 0x4e2940, (uintptr_t)(self + 0x4399), 0);
}

/* ---- 0x4e3833 call_three_zero ---- */
/* 0x4e3833, thiscall, plain `ret`, returns the eax of the last callee: 0x4e2940(this = self+0x3d5d, 0), 0x4e2940(this = self+0x3eec, 0) and 0x4e2940(this = self+0x407b, 0), each thiscall with one argument 0. */
uint32_t m4e3833_call_three_zero(uint8_t *self, const Fl18Host *host)
{
    (void)call1(host, 0x4e2940, (uintptr_t)(self + 0x3d5d), 0);
    (void)call1(host, 0x4e2940, (uintptr_t)(self + 0x3eec), 0);
    return call1(host, 0x4e2940, (uintptr_t)(self + 0x407b), 0);
}

/* ---- 0x4e7843 copy_block ---- */
/* 0x4e7843, thiscall, stack arguments (src, limit), `ret 8`, no return value: copies 192 dwords (0x300 bytes) from src to [self+0x691]; when 0x300 > limit (signed): 0x50ca3e(0x63888b, 0x55c4c4, 0x300, limit) (cdecl, four arguments), 0x4264e8(0x63888b) on 0x583979 (thiscall), 0x4c97b4 on 0x5cf659 (thiscall, no argument). */
void m4e7843_copy_block(uint8_t *self, const uint8_t *src, int32_t limit, const Fl18Host *host)
{
    memcpy(self + 0x691, src, 0x300);
    if ((int32_t)0x300 > limit) {
        (void)call4(host, 0x50ca3e, 0, 0x63888b, 0x55c4c4, 0x300, (uintptr_t)(uint32_t)limit);
        (void)call1(host, 0x4264e8, 0x583979, 0x63888b);
        (void)call0(host, 0x4c97b4, 0x5cf659);
    }
}

/* ---- 0x4e7b37 destroy_vector ---- */
/* 0x4e7b37, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52e4f4u at [this], then 0x4e7bf3(this) (thiscall, no arguments), 0x50cba8(this + 0x7654, 0x18f, 6, 0x4e1c83) (cdecl, four arguments: the vector iterator) and 0x4eda7c(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x528a82) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m4e7b37_destroy_vector(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e4f4u);
    (void)call0(host, 0x4e7bf3, (uintptr_t)self);
    (void)call4(host, 0x50cba8, 0, (uintptr_t)(self + 0x7654), 0x18f, 6, 0x4e1c83);
    return call0(host, 0x4eda7c, (uintptr_t)self);
}

/* ---- 0x4e7d2e copy_block ---- */
/* 0x4e7d2e, thiscall, stack arguments (src, limit), `ret 8`, no return value: copies 715 dwords (0xb2c bytes) from src to [self+0x6b20]; when 0xb2c > limit (signed): 0x50ca3e(0x63888b, 0x55c530, 0xb2c, limit) (cdecl, four arguments), 0x4264e8(0x63888b) on 0x583979 (thiscall), 0x4c97b4 on 0x5cf659 (thiscall, no argument). */
void m4e7d2e_copy_block(uint8_t *self, const uint8_t *src, int32_t limit, const Fl18Host *host)
{
    memcpy(self + 0x6b20, src, 0xb2c);
    if ((int32_t)0xb2c > limit) {
        (void)call4(host, 0x50ca3e, 0, 0x63888b, 0x55c530, 0xb2c, (uintptr_t)(uint32_t)limit);
        (void)call1(host, 0x4264e8, 0x583979, 0x63888b);
        (void)call0(host, 0x4c97b4, 0x5cf659);
    }
}

/* ---- 0x4e8994 set_field_forward ---- */
/* 0x4e8994, thiscall, `ret 4`, returns the eax of the callee: stores the stack argument in the dword [self+0x7650], then 0x4edf96(this = self, the same argument) (thiscall, one argument). */
uint32_t m4e8994_set_field_forward(uint8_t *self, uint32_t arg, const Fl18Host *host)
{
    wr32(self, 0x7650, arg);
    return call1(host, 0x4edf96, (uintptr_t)self, arg);
}

/* ---- 0x4eb8fe destroy_vector ---- */
/* 0x4eb8fe, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52e4f8u at [this], then 0x4eba54(this) (thiscall, no arguments), 0x50cba8(this + 0xca8, 0x18f, 2, 0x4e1c83) (cdecl, four arguments: the vector iterator) and 0x4eda7c(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x528ae2) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m4eb8fe_destroy_vector(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e4f8u);
    (void)call0(host, 0x4eba54, (uintptr_t)self);
    (void)call4(host, 0x50cba8, 0, (uintptr_t)(self + 0xca8), 0x18f, 2, 0x4e1c83);
    return call0(host, 0x4eda7c, (uintptr_t)self);
}

/* ---- 0x4ebd2e set_field_forward ---- */
/* 0x4ebd2e, thiscall, `ret 4`, returns the eax of the callee: stores the stack argument in the dword [self+0xca4], then 0x4edf96(this = self, the same argument) (thiscall, one argument). */
uint32_t m4ebd2e_set_field_forward(uint8_t *self, uint32_t arg, const Fl18Host *host)
{
    wr32(self, 0xca4, arg);
    return call1(host, 0x4edf96, (uintptr_t)self, arg);
}

/* ---- 0x4fcd4d forward_word ---- */
/* 0x4fcd4d, thiscall, `ret 4`, returns the eax of the callee: 0x4fccf2(this = self, word, 0) (thiscall, two arguments: the stack argument word, pushed from ax with a left-over upper half (the callee reads a word), and the constant 0 pushed first). */
uint32_t m4fcd4d_forward_word(uint8_t *self, uint16_t arg, const Fl18Host *host)
{
    return call2(host, 0x4fccf2, (uintptr_t)self, (uintptr_t)arg, 0);
}

/* ---- 0x4fcd69 forward_word ---- */
/* 0x4fcd69, thiscall, `ret 4`, returns the eax of the callee: 0x4fccf2(this = self, word, 1) (thiscall, two arguments: the stack argument word, pushed from ax with a left-over upper half (the callee reads a word), and the constant 1 pushed first). */
uint32_t m4fcd69_forward_word(uint8_t *self, uint16_t arg, const Fl18Host *host)
{
    return call2(host, 0x4fccf2, (uintptr_t)self, (uintptr_t)arg, 1);
}

/* ---- 0x4fcd85 forward_word ---- */
/* 0x4fcd85, thiscall, `ret 4`, returns the eax of the callee: 0x4fccf2(this = self, word, 2) (thiscall, two arguments: the stack argument word, pushed from ax with a left-over upper half (the callee reads a word), and the constant 2 pushed first). */
uint32_t m4fcd85_forward_word(uint8_t *self, uint16_t arg, const Fl18Host *host)
{
    return call2(host, 0x4fccf2, (uintptr_t)self, (uintptr_t)arg, 2);
}
