#include "original_methods_fl39e.h"

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

FL39_UNUSED static uint32_t call5(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3, uintptr_t a4)
{
    const uintptr_t a[5] = {a0, a1, a2, a3, a4};
    return callv(host, callee, this_ptr, a, 5);
}

/* ---- 0x487b1a init_fields5 ---- */
/* 0x487b1a, thiscall, plain `ret`, no return value, no calls: stores, in this order, the immediates word [self+0x1e] = 0xffff; word [self+0x1c] = 0xffff; dword [self+0x71] = 0x0; byte [self+0x75] = 0x0; byte [self+0x70] = 0x0. */
void m487b1a_init_fields5(uint8_t *self)
{
    wr16(self, 0x1e, 0xffff);
    wr16(self, 0x1c, 0xffff);
    wr32(self, 0x71, 0x0);
    self[0x75] = 0x0;
    self[0x70] = 0x0;
}

/* ---- 0x48e2f5 release_word ---- */
/* 0x48e2f5, thiscall, plain `ret`, returns the eax of the last callee: when the signed word [self+0x1c] != -1, 0x4d3992(word) (cdecl, one argument pushed from eax, whose upper half is left-over: the callee reads a word); then 0x48e28a(this = self) (thiscall, no arguments). */
uint32_t m48e2f5_release_word(uint8_t *self, const Fl18Host *host)
{
    if (rds16(self, 0x1c) != -1) (void)call1(host, 0x4d3992, 0, (uintptr_t)rd16(self, 0x1c));
    return call0(host, 0x48e28a, (uintptr_t)self);
}

/* ---- 0x49c5f0 zero_fields11 ---- */
/* 0x49c5f0, thiscall, plain `ret`, no return value, no calls: stores, in this order, the immediates dword [self+0xde0] = 0x0; dword [self+0xdec] = 0x0; dword [self+0xde4] = 0x0; dword [self+0xe30] = 0x0; dword [self+0xe34] = 0x0; dword [self+0xe38] = 0x0; dword [self+0xe3c] = 0x0; dword [self+0xe40] = 0x0; dword [self+0xe44] = 0x0; dword [self+0xe48] = 0x0; dword [self+0xe18] = 0x0. */
void m49c5f0_zero_fields11(uint8_t *self)
{
    wr32(self, 0xde0, 0x0);
    wr32(self, 0xdec, 0x0);
    wr32(self, 0xde4, 0x0);
    wr32(self, 0xe30, 0x0);
    wr32(self, 0xe34, 0x0);
    wr32(self, 0xe38, 0x0);
    wr32(self, 0xe3c, 0x0);
    wr32(self, 0xe40, 0x0);
    wr32(self, 0xe44, 0x0);
    wr32(self, 0xe48, 0x0);
    wr32(self, 0xe18, 0x0);
}

/* ---- 0x4a1b12 get_constant ---- */
/* 0x4a1b12, thiscall, plain `ret`, returns the constant 0x52dba8 (an address in the image of the original); `self` (ecx) is only saved and not used. */
uint32_t m4a1b12_get_constant(void)
{
    return 0x52dba8u;
}

/* ---- 0x4a1c47 init_fields11 ---- */
/* 0x4a1c47, thiscall, plain `ret`, no return value, no calls: stores, in this order, the immediates word [self+0x1e] = 0xffff; word [self+0x1c] = 0xffff; dword [self+0x60] = 0x0; byte [self+0x4b] = 0x0; byte [self+0x58] = 0x0; byte [self+0x59] = 0x0; byte [self+0x5a] = 0x0; dword [self+0x20] = 0x0; dword [self+0x24] = 0x0; dword [self+0x5b] = 0x0; word [self+0x49] = 0xffff. */
void m4a1c47_init_fields11(uint8_t *self)
{
    wr16(self, 0x1e, 0xffff);
    wr16(self, 0x1c, 0xffff);
    wr32(self, 0x60, 0x0);
    self[0x4b] = 0x0;
    self[0x58] = 0x0;
    self[0x59] = 0x0;
    self[0x5a] = 0x0;
    wr32(self, 0x20, 0x0);
    wr32(self, 0x24, 0x0);
    wr32(self, 0x5b, 0x0);
    wr16(self, 0x49, 0xffff);
}

/* ---- 0x4a1cb1 release_word ---- */
/* 0x4a1cb1, thiscall, plain `ret`, returns the eax of the last callee: when the signed word [self+0x1c] != -1, 0x4d3992(word) (cdecl, one argument pushed from eax, whose upper half is left-over: the callee reads a word); then 0x4a1c47(this = self) (thiscall, no arguments). */
uint32_t m4a1cb1_release_word(uint8_t *self, const Fl18Host *host)
{
    if (rds16(self, 0x1c) != -1) (void)call1(host, 0x4d3992, 0, (uintptr_t)rd16(self, 0x1c));
    return call0(host, 0x4a1c47, (uintptr_t)self);
}

/* ---- 0x4ab3a7 init_fields5 ---- */
/* 0x4ab3a7, thiscall, plain `ret`, no return value, no calls: stores, in this order, the immediates word [self+0x1e] = 0xffff; word [self+0x1c] = 0xffff; dword [self+0x54] = 0x0; byte [self+0x58] = 0x0; byte [self+0x59] = 0x0. */
void m4ab3a7_init_fields5(uint8_t *self)
{
    wr16(self, 0x1e, 0xffff);
    wr16(self, 0x1c, 0xffff);
    wr32(self, 0x54, 0x0);
    self[0x58] = 0x0;
    self[0x59] = 0x0;
}

/* ---- 0x4ae452 copy_sub_dword ---- */
/* 0x4ae452, thiscall, `ret 4`, no return value, no calls: rec = self + idx*0xc7 + 0x6e (idx = the stack argument, 32-bit multiply); sub = rec + (unsigned byte [rec+0x26])*0x28 + 0x27; dword [sub+0x8] = dword [sub+0x4]. */
void m4ae452_copy_sub_dword(uint8_t *self, uint32_t idx)
{
    uint8_t *rec = self + (int32_t)(idx * 0xc7u + 0x6eu);
    uint8_t *sub = rec + (int32_t)((uint32_t)rec[0x26] * 0x28u + 0x27u);
    wr32(sub, 0x8, rd32(sub, 0x4));
}

/* ---- 0x4ae495 copy_sub_dword ---- */
/* 0x4ae495, thiscall, `ret 4`, no return value, no calls: rec = self + idx*0xc7 + 0x6e (idx = the stack argument, 32-bit multiply); sub = rec + (unsigned byte [rec+0x26])*0x28 + 0x27; dword [sub+0x8] = dword [sub+0x0]. */
void m4ae495_copy_sub_dword(uint8_t *self, uint32_t idx)
{
    uint8_t *rec = self + (int32_t)(idx * 0xc7u + 0x6eu);
    uint8_t *sub = rec + (int32_t)((uint32_t)rec[0x26] * 0x28u + 0x27u);
    wr32(sub, 0x8, rd32(sub, 0x0));
}

/* ---- 0x4c87ba fill_stride ---- */
/* 0x4c87ba, thiscall, stack arguments (pp, x, y, count, val), `ret 0x14`, no return value: p = the dword [pp] (an address of the original); while i < count (signed, from 0): byte [p] = the low byte of val, p += the second scalar argument (stack +0x10); then p += the first scalar argument (stack +0xc); dword [pp] = p. `self` (ecx) is only saved. */
void m4c87ba_fill_stride(uint8_t *pp, uint32_t x, uint32_t y, int32_t count, uint32_t val, const Fl18Host *host)
{
    uint32_t p = rd32(pp, 0);
    int32_t i;
    for (i = 0; i < count; i++) {
        *res(host, p) = (uint8_t)val;
        p += y;
    }
    p += x;
    wr32(pp, 0, p);
}

/* ---- 0x4c8872 fill_stride ---- */
/* 0x4c8872, thiscall, stack arguments (pp, x, y, count, val), `ret 0x14`, no return value: p = the dword [pp] (an address of the original); while i < count (signed, from 0): byte [p] = the low byte of val, p += the first scalar argument (stack +0xc); then p += the second scalar argument (stack +0x10); dword [pp] = p. `self` (ecx) is only saved. */
void m4c8872_fill_stride(uint8_t *pp, uint32_t x, uint32_t y, int32_t count, uint32_t val, const Fl18Host *host)
{
    uint32_t p = rd32(pp, 0);
    int32_t i;
    for (i = 0; i < count; i++) {
        *res(host, p) = (uint8_t)val;
        p += x;
    }
    p += y;
    wr32(pp, 0, p);
}

/* ---- 0x4cca42 forward_struct ---- */
/* 0x4cca42, thiscall, stack arguments (a, rec), `ret 8`, returns the eax of the callee: 0x4cca0e(this = self, a, dword [rec], dword [rec+4], dword [rec+8]) (thiscall, four arguments; rec is the address of a record, a host pointer for the port). */
uint32_t m4cca42_forward_struct(uint8_t *self, uint32_t a, const uint8_t *rec, const Fl18Host *host)
{
    return call4(host, 0x4cca0e, (uintptr_t)self, a, rd32(rec, 0), rd32(rec, 4), rd32(rec, 8));
}

/* ---- 0x4cca6f forward_struct ---- */
/* 0x4cca6f, thiscall, stack arguments (a, rec), `ret 8`, returns the eax of the callee: 0x4cca9c(this = self, a, dword [rec], dword [rec+4], dword [rec+8]) (thiscall, four arguments; rec is the address of a record, a host pointer for the port). */
uint32_t m4cca6f_forward_struct(uint8_t *self, uint32_t a, const uint8_t *rec, const Fl18Host *host)
{
    return call4(host, 0x4cca9c, (uintptr_t)self, a, rd32(rec, 0), rd32(rec, 4), rd32(rec, 8));
}

/* ---- 0x4ccd25 get_constant ---- */
/* 0x4ccd25, thiscall, plain `ret`, returns the constant 0x52e258 (an address in the image of the original); `self` (ecx) is only saved and not used. */
uint32_t m4ccd25_get_constant(void)
{
    return 0x52e258u;
}

/* ---- 0x4d0b68 log_loop ---- */
/* 0x4d0b68, no `this` (a plain frame), no return value: for the signed word i = 0 .. 8: when i == the signed word [0x5aff57] 0x4c5377(this = 0x5cf659, [0x5d2b47], dword 0x5cf665, i*16 + 0x5afeb5, i*16 + 0x5afd05, 0x55a098), otherwise 0x4c5377(this = 0x5cf659, [0x5d2a1f], dword 0x5cf665, i*16 + 0x5afd05, i*16 + 0x5afd05, 0x55a0bc) (thiscall, five arguments each, the one pushed last first). */
void m4d0b68_log_loop(const Fl39eWorld *world, const Fl18Host *host)
{
    int32_t i;
    for (i = 0; i < 9; i++) {
        if (i == (int32_t)world->word_5aff57)
            (void)call5(host, 0x4c5377, 0x5cf659, world->value_5d2b47, world->value_5cf665, (uint32_t)(i << 4) + 0x5afeb5u, (uint32_t)(i << 4) + 0x5afd05u, 0x55a098);
        else
            (void)call5(host, 0x4c5377, 0x5cf659, world->value_5d2a1f, world->value_5cf665, (uint32_t)(i << 4) + 0x5afd05u, (uint32_t)(i << 4) + 0x5afd05u, 0x55a0bc);
    }
}

/* ---- 0x4d0c57 log_loop ---- */
/* 0x4d0c57, no `this` (a plain frame), no return value: for the signed word i = 0 .. 0: when i == the signed word [0x5b0010] 0x4c5377(this = 0x5cf659, [0x5d2d03], dword 0x5cf665, i*16 + 0x5afff2, i*16 + 0x5affd2, 0x55a0f8), otherwise 0x4c5377(this = 0x5cf659, [0x5d2bdb], dword 0x5cf665, i*16 + 0x5affd2, i*16 + 0x5affd2, 0x55a118) (thiscall, five arguments each, the one pushed last first). */
void m4d0c57_log_loop(const Fl39eWorld *world, const Fl18Host *host)
{
    int32_t i;
    for (i = 0; i < 1; i++) {
        if (i == (int32_t)world->word_5b0010)
            (void)call5(host, 0x4c5377, 0x5cf659, world->value_5d2d03, world->value_5cf665, (uint32_t)(i << 4) + 0x5afff2u, (uint32_t)(i << 4) + 0x5affd2u, 0x55a0f8);
        else
            (void)call5(host, 0x4c5377, 0x5cf659, world->value_5d2bdb, world->value_5cf665, (uint32_t)(i << 4) + 0x5affd2u, (uint32_t)(i << 4) + 0x5affd2u, 0x55a118);
    }
}

/* ---- 0x4d3728 log_three ---- */
/* 0x4d3728, no `this` (a plain frame), no return value: 0x4c5377(this = 0x5cf659, [0x5d03bb], dword 0x5cf665, 0x5b4e58, [0x5d1963], 0x55a388) and 0x4c5d4b(this = 0x5cf659, [0x5d195b], dword 0x5cf665, [0x5d195f], [0x5d1963], 0x55a398) (thiscall, five arguments each, the one pushed last first); then, when the signed word [0x5b4e8d] is non-zero, 0x4c5d4b(this = 0x5cf659, [0x5d03c7], dword 0x5cf665, 0x5b4e38, 0x5b4e48, 0x55a3a8). */
void m4d3728_log_three(const Fl39eWorld *world, const Fl18Host *host)
{
    (void)call5(host, 0x4c5377, 0x5cf659, world->value_5d03bb, world->value_5cf665, 0x5b4e58, world->value_5d1963, 0x55a388);
    (void)call5(host, 0x4c5d4b, 0x5cf659, world->value_5d195b, world->value_5cf665, world->value_5d195f, world->value_5d1963, 0x55a398);
    if (world->word_5b4e8d != 0) (void)call5(host, 0x4c5d4b, 0x5cf659, world->value_5d03c7, world->value_5cf665, 0x5b4e38, 0x5b4e48, 0x55a3a8);
}

/* ---- 0x4d37af log_three ---- */
/* 0x4d37af, no `this` (a plain frame), no return value: 0x4c5377(this = 0x5cf659, [0x5d03bb], dword 0x5cf665, 0x5b50cf, [0x5d19ad], 0x55a3c4) and 0x4c5d4b(this = 0x5cf659, [0x5d19a5], dword 0x5cf665, [0x5d19a9], [0x5d19ad], 0x55a3d4) (thiscall, five arguments each, the one pushed last first); then, when the signed word [0x5b5104] is non-zero, 0x4c5d4b(this = 0x5cf659, [0x5d03cb], dword 0x5cf665, 0x5b50af, 0x5b50bf, 0x55a3e4). */
void m4d37af_log_three(const Fl39eWorld *world, const Fl18Host *host)
{
    (void)call5(host, 0x4c5377, 0x5cf659, world->value_5d03bb, world->value_5cf665, 0x5b50cf, world->value_5d19ad, 0x55a3c4);
    (void)call5(host, 0x4c5d4b, 0x5cf659, world->value_5d19a5, world->value_5cf665, world->value_5d19a9, world->value_5d19ad, 0x55a3d4);
    if (world->word_5b5104 != 0) (void)call5(host, 0x4c5d4b, 0x5cf659, world->value_5d03cb, world->value_5cf665, 0x5b50af, 0x5b50bf, 0x55a3e4);
}

/* ---- 0x4de227 call_pair ---- */
/* 0x4de227, thiscall, plain `ret`, returns the eax of the last callee: 0x4edcb1(this = self, self + 0x691, 1) (thiscall, two arguments), then 0x4ee6c7(this = self, 0) (thiscall, one argument). */
uint32_t m4de227_call_pair(uint8_t *self, const Fl18Host *host)
{
    (void)call2(host, 0x4edcb1, (uintptr_t)self, (uintptr_t)(self + 0x691), 1);
    return call1(host, 0x4ee6c7, (uintptr_t)self, 0);
}

/* ---- 0x4de413 call_unless_01 ---- */
/* 0x4de413, thiscall, plain `ret`, no return value: when the dword [self+0x991] is neither 0 nor 1 (unsigned compare for equality only), 0x4ee517(this = self) (thiscall, no arguments). */
void m4de413_call_unless_01(uint8_t *self, const Fl18Host *host)
{
    uint32_t v = rd32(self, 0x991);
    if (v != 0 && v != 1) (void)call0(host, 0x4ee517, (uintptr_t)self);
}

/* ---- 0x4de584 call_unless_01 ---- */
/* 0x4de584, thiscall, plain `ret`, no return value: when the dword [self+0x991] is neither 0 nor 1 (unsigned compare for equality only), 0x4ee86f(this = self) (thiscall, no arguments). */
void m4de584_call_unless_01(uint8_t *self, const Fl18Host *host)
{
    uint32_t v = rd32(self, 0x991);
    if (v != 0 && v != 1) (void)call0(host, 0x4ee86f, (uintptr_t)self);
}

/* ---- 0x4de66e destroy_subobjects ---- */
/* 0x4de66e, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52e4d0u at [this], then 0x4de6fc(this), 0x4ee99f(this + 0x57e) and 0x4e1c83(this + 0x3ef) (thiscall, no arguments). The function links a structured-exception frame (handler 0x528946) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m4de66e_destroy_subobjects(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e4d0u);
    (void)call0(host, 0x4de6fc, (uintptr_t)self);
    (void)call0(host, 0x4ee99f, (uintptr_t)(self + 0x57e));
    return call0(host, 0x4e1c83, (uintptr_t)(self + 0x3ef));
}

/* ---- 0x4e053f set_field_sx ---- */
/* 0x4e053f, thiscall, `ret 4`, no return value: stores the stack argument's low word, sign-extended to a dword (movsx), in [self+0xf2a] (the upper half of the pushed dword is not read). */
void m4e053f_set_field_sx(uint8_t *self, uint32_t arg)
{
    wr32(self, 0xf2a, (uint32_t)(int32_t)(int16_t)(uint16_t)arg);
}

/* ---- 0x4e1113 log_guarded ---- */
/* 0x4e1113, thiscall, plain `ret`, no return value: when dword [self+0x74f] != 0, 0x4c5377(this = 0x5cf659, [self+0x74f], dword [0x5cf665], self+0x25, self+0x35, 0x55be0c) (thiscall, five arguments; the dword [self+0x74f] is pushed last, so it is the first argument). */
void m4e1113_log_guarded(uint8_t *self, const Fl39eWorld *world, const Fl18Host *host)
{
    if (rd32(self, 0x74f) != 0) (void)call5(host, 0x4c5377, 0x5cf659, rd32(self, 0x74f), world->value_5cf665, (uintptr_t)(self + 0x25), (uintptr_t)(self + 0x35), 0x55be0c);
}

/* ---- 0x4e1157 log_guarded ---- */
/* 0x4e1157, thiscall, plain `ret`, no return value: when dword [self+0x74f] != 0, 0x4c5377(this = 0x5cf659, [self+0x74f], dword [0x5cf665], self+0x55, self+0x55, 0x55be54) (thiscall, five arguments; the dword [self+0x74f] is pushed last, so it is the first argument). */
void m4e1157_log_guarded(uint8_t *self, const Fl39eWorld *world, const Fl18Host *host)
{
    if (rd32(self, 0x74f) != 0) (void)call5(host, 0x4c5377, 0x5cf659, rd32(self, 0x74f), world->value_5cf665, (uintptr_t)(self + 0x55), (uintptr_t)(self + 0x55), 0x55be54);
}

/* ---- 0x4e7700 call_pair ---- */
/* 0x4e7700, thiscall, plain `ret`, returns the eax of the last callee: 0x4edcb1(this = self, self + 0x691, 1) (thiscall, two arguments), then 0x4ee6c7(this = self, 1) (thiscall, one argument). */
uint32_t m4e7700_call_pair(uint8_t *self, const Fl18Host *host)
{
    (void)call2(host, 0x4edcb1, (uintptr_t)self, (uintptr_t)(self + 0x691), 1);
    return call1(host, 0x4ee6c7, (uintptr_t)self, 1);
}

/* ---- 0x4e7a10 call_unless_01 ---- */
/* 0x4e7a10, thiscall, plain `ret`, no return value: when the dword [self+0x991] is neither 0 nor 1 (unsigned compare for equality only), 0x4ee86f(this = self) (thiscall, no arguments). */
void m4e7a10_call_unless_01(uint8_t *self, const Fl18Host *host)
{
    uint32_t v = rd32(self, 0x991);
    if (v != 0 && v != 1) (void)call0(host, 0x4ee86f, (uintptr_t)self);
}

/* ---- 0x4eda7c destroy_subobjects ---- */
/* 0x4eda7c, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52e4fcu at [this], then 0x4edb97(this), 0x4ee99f(this + 0x4b7) and 0x4e1c83(this + 0x31c) (thiscall, no arguments). The function links a structured-exception frame (handler 0x528b36) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m4eda7c_destroy_subobjects(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e4fcu);
    (void)call0(host, 0x4edb97, (uintptr_t)self);
    (void)call0(host, 0x4ee99f, (uintptr_t)(self + 0x4b7));
    return call0(host, 0x4e1c83, (uintptr_t)(self + 0x31c));
}

/* ---- 0x4ee5b8 store_global ---- */
/* 0x4ee5b8, thiscall, `ret 4`, no return value: stores the stack argument in the dword global 0x55cd94. `self` (ecx) is not used. */
void m4ee5b8_store_global(Fl39eWorld *world, uint32_t arg)
{
    world->value_55cd94 = arg;
}

/* ---- 0x4ee5dd store_global ---- */
/* 0x4ee5dd, thiscall, `ret 4`, no return value: stores the stack argument in the dword global 0x63aa10. `self` (ecx) is not used. */
void m4ee5dd_store_global(Fl39eWorld *world, uint32_t arg)
{
    world->value_63aa10 = arg;
}

/* ---- 0x4ee616 set_field_sx ---- */
/* 0x4ee616, thiscall, `ret 4`, no return value: stores the stack argument's low word, sign-extended to a dword (movsx), in [self+0x4af] (the upper half of the pushed dword is not read). */
void m4ee616_set_field_sx(uint8_t *self, uint32_t arg)
{
    wr32(self, 0x4af, (uint32_t)(int32_t)(int16_t)(uint16_t)arg);
}

/* ---- 0x4f872e forward_fields ---- */
/* 0x4f872e, thiscall, plain `ret`, returns the eax of the callee: 0x4f861c(this = self, [self+0x240], [self+0x244], [self+0x248]) (thiscall, three arguments; the dword [self+0x240] is pushed last, so it is the first argument). */
uint32_t m4f872e_forward_fields(uint8_t *self, const Fl18Host *host)
{
    return call3(host, 0x4f861c, (uintptr_t)self, rd32(self, 0x240), rd32(self, 0x244), rd32(self, 0x248));
}

/* ---- 0x4f88ad forward_fields ---- */
/* 0x4f88ad, thiscall, plain `ret`, returns the eax of the callee: 0x4f875f(this = self, [self+0x24c], [self+0x250], [self+0x254]) (thiscall, three arguments; the dword [self+0x24c] is pushed last, so it is the first argument). */
uint32_t m4f88ad_forward_fields(uint8_t *self, const Fl18Host *host)
{
    return call3(host, 0x4f875f, (uintptr_t)self, rd32(self, 0x24c), rd32(self, 0x250), rd32(self, 0x254));
}

/* ---- 0x4fc909 check_trace ---- */
/* 0x4fc909, thiscall, plain `ret`, no return value: when the signed word 0x63a4cd (debug flag) is non-zero, 0x44a2b7(0x56095c) (cdecl); r = 0x4f67be(this = 0x5cf1eb) (thiscall, no arguments); when r == 0 and the flag is (still) non-zero: t = 0x4fa2a8(this = 0x5cf1eb), 0x50ca3e(0x63888b, 0x560974, t) (cdecl, three arguments), 0x52139c(0x63888b, 0, 0) (stdcall: the callee pops) and 0x44a2b7(0x63888b) (cdecl). `self` is only saved. */
void m4fc909_check_trace(const Fl39eWorld *world, const Fl18Host *host)
{
    if (world->word_63a4cd != 0) (void)call1(host, 0x44a2b7, 0, 0x56095c);
    if (call0(host, 0x4f67be, 0x5cf1eb) != 0) return;
    if (world->word_63a4cd == 0) return;
    {
        uint32_t t = call0(host, 0x4fa2a8, 0x5cf1eb);
        (void)call3(host, 0x50ca3e, 0, 0x63888b, 0x560974, t);
        (void)call3(host, 0x52139c, 0, 0x63888b, 0, 0);
        (void)call1(host, 0x44a2b7, 0, 0x63888b);
    }
}

/* ---- 0x4fc97d check_trace ---- */
/* 0x4fc97d, thiscall, plain `ret`, no return value: when the signed word 0x63a4cd (debug flag) is non-zero, 0x44a2b7(0x560994) (cdecl); r = 0x4f6810(this = 0x5cf1eb) (thiscall, no arguments); when r == 0 and the flag is (still) non-zero: t = 0x4fa2a8(this = 0x5cf1eb), 0x50ca3e(0x63888b, 0x5609b0, t) (cdecl, three arguments), 0x52139c(0x63888b, 0, 0) (stdcall: the callee pops) and 0x44a2b7(0x63888b) (cdecl). `self` is only saved. */
void m4fc97d_check_trace(const Fl39eWorld *world, const Fl18Host *host)
{
    if (world->word_63a4cd != 0) (void)call1(host, 0x44a2b7, 0, 0x560994);
    if (call0(host, 0x4f6810, 0x5cf1eb) != 0) return;
    if (world->word_63a4cd == 0) return;
    {
        uint32_t t = call0(host, 0x4fa2a8, 0x5cf1eb);
        (void)call3(host, 0x50ca3e, 0, 0x63888b, 0x5609b0, t);
        (void)call3(host, 0x52139c, 0, 0x63888b, 0, 0);
        (void)call1(host, 0x44a2b7, 0, 0x63888b);
    }
}
