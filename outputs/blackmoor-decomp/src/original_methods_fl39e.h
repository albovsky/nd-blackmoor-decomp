#ifndef BLACKMOOR_ORIGINAL_METHODS_FL39E_H
#define BLACKMOOR_ORIGINAL_METHODS_FL39E_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-39 (batch e): 35 functions of GAME.EXE (SHA-256 afd337a2...5c45) at or above 0x480000 ported one to one, in the style of FL-36 (see original_methods_fl36f.h, whose conventions
 * apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment, `self` is the
 * original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names are descriptive hints, not
 * recovered source names. The constants of every row (field offsets, callees, stored values, sizes) were read from that row's own disassembly by the generator, which also
 * asserted that every row of a kind has the identical masked instruction stream. A dword of `self` that holds an address of the original goes through Fl18Host.resolve;
 * a callee that changes `self` or a global that the function reads again afterwards is not exercised. */

typedef struct Fl39eWorld {
    uint32_t value_5cf665; /* the dword at 0x5cf665 */
    int16_t word_5aff57; /* the signed word at 0x5aff57 */
    int16_t word_5b0010; /* the signed word at 0x5b0010 */
    uint32_t value_5d2b47; /* the dword at 0x5d2b47 */
    uint32_t value_5d2a1f; /* the dword at 0x5d2a1f */
    uint32_t value_5d2d03; /* the dword at 0x5d2d03 */
    uint32_t value_5d2bdb; /* the dword at 0x5d2bdb */
    uint32_t value_5d1963; /* the dword at 0x5d1963 */
    uint32_t value_5d19ad; /* the dword at 0x5d19ad */
    uint32_t value_5d03bb; /* the dword at 0x5d03bb */
    uint32_t value_5d195f; /* the dword at 0x5d195f */
    uint32_t value_5d19a9; /* the dword at 0x5d19a9 */
    uint32_t value_5d195b; /* the dword at 0x5d195b */
    uint32_t value_5d19a5; /* the dword at 0x5d19a5 */
    uint32_t value_5d03c7; /* the dword at 0x5d03c7 */
    uint32_t value_5d03cb; /* the dword at 0x5d03cb */
    int16_t word_5b4e8d; /* the signed word at 0x5b4e8d */
    int16_t word_5b5104; /* the signed word at 0x5b5104 */
    uint32_t value_55cd94; /* the dword at 0x55cd94 */
    uint32_t value_63aa10; /* the dword at 0x63aa10 */
    int16_t word_63a4cd; /* the signed word at 0x63a4cd */
} Fl39eWorld;

/* 0x487b1a, thiscall, plain `ret`, no return value, no calls: stores, in this order, the immediates word [self+0x1e] = 0xffff; word [self+0x1c] = 0xffff; dword [self+0x71] = 0x0; byte [self+0x75] = 0x0; byte [self+0x70] = 0x0. */
void m487b1a_init_fields5(uint8_t *self);

/* 0x48e2f5, thiscall, plain `ret`, returns the eax of the last callee: when the signed word [self+0x1c] != -1, 0x4d3992(word) (cdecl, one argument pushed from eax, whose upper half is left-over: the callee reads a word); then 0x48e28a(this = self) (thiscall, no arguments). */
uint32_t m48e2f5_release_word(uint8_t *self, const Fl18Host *host);

/* 0x49c5f0, thiscall, plain `ret`, no return value, no calls: stores, in this order, the immediates dword [self+0xde0] = 0x0; dword [self+0xdec] = 0x0; dword [self+0xde4] = 0x0; dword [self+0xe30] = 0x0; dword [self+0xe34] = 0x0; dword [self+0xe38] = 0x0; dword [self+0xe3c] = 0x0; dword [self+0xe40] = 0x0; dword [self+0xe44] = 0x0; dword [self+0xe48] = 0x0; dword [self+0xe18] = 0x0. */
void m49c5f0_zero_fields11(uint8_t *self);

/* 0x4a1b12, thiscall, plain `ret`, returns the constant 0x52dba8 (an address in the image of the original); `self` (ecx) is only saved and not used. */
uint32_t m4a1b12_get_constant(void);

/* 0x4a1c47, thiscall, plain `ret`, no return value, no calls: stores, in this order, the immediates word [self+0x1e] = 0xffff; word [self+0x1c] = 0xffff; dword [self+0x60] = 0x0; byte [self+0x4b] = 0x0; byte [self+0x58] = 0x0; byte [self+0x59] = 0x0; byte [self+0x5a] = 0x0; dword [self+0x20] = 0x0; dword [self+0x24] = 0x0; dword [self+0x5b] = 0x0; word [self+0x49] = 0xffff. */
void m4a1c47_init_fields11(uint8_t *self);

/* 0x4a1cb1, thiscall, plain `ret`, returns the eax of the last callee: when the signed word [self+0x1c] != -1, 0x4d3992(word) (cdecl, one argument pushed from eax, whose upper half is left-over: the callee reads a word); then 0x4a1c47(this = self) (thiscall, no arguments). */
uint32_t m4a1cb1_release_word(uint8_t *self, const Fl18Host *host);

/* 0x4ab3a7, thiscall, plain `ret`, no return value, no calls: stores, in this order, the immediates word [self+0x1e] = 0xffff; word [self+0x1c] = 0xffff; dword [self+0x54] = 0x0; byte [self+0x58] = 0x0; byte [self+0x59] = 0x0. */
void m4ab3a7_init_fields5(uint8_t *self);

/* 0x4ae452, thiscall, `ret 4`, no return value, no calls: rec = self + idx*0xc7 + 0x6e (idx = the stack argument, 32-bit multiply); sub = rec + (unsigned byte [rec+0x26])*0x28 + 0x27; dword [sub+0x8] = dword [sub+0x4]. */
void m4ae452_copy_sub_dword(uint8_t *self, uint32_t idx);

/* 0x4ae495, thiscall, `ret 4`, no return value, no calls: rec = self + idx*0xc7 + 0x6e (idx = the stack argument, 32-bit multiply); sub = rec + (unsigned byte [rec+0x26])*0x28 + 0x27; dword [sub+0x8] = dword [sub+0x0]. */
void m4ae495_copy_sub_dword(uint8_t *self, uint32_t idx);

/* 0x4c87ba, thiscall, stack arguments (pp, x, y, count, val), `ret 0x14`, no return value: p = the dword [pp] (an address of the original); while i < count (signed, from 0): byte [p] = the low byte of val, p += the second scalar argument (stack +0x10); then p += the first scalar argument (stack +0xc); dword [pp] = p. `self` (ecx) is only saved. */
void m4c87ba_fill_stride(uint8_t *pp, uint32_t x, uint32_t y, int32_t count, uint32_t val, const Fl18Host *host);

/* 0x4c8872, thiscall, stack arguments (pp, x, y, count, val), `ret 0x14`, no return value: p = the dword [pp] (an address of the original); while i < count (signed, from 0): byte [p] = the low byte of val, p += the first scalar argument (stack +0xc); then p += the second scalar argument (stack +0x10); dword [pp] = p. `self` (ecx) is only saved. */
void m4c8872_fill_stride(uint8_t *pp, uint32_t x, uint32_t y, int32_t count, uint32_t val, const Fl18Host *host);

/* 0x4cca42, thiscall, stack arguments (a, rec), `ret 8`, returns the eax of the callee: 0x4cca0e(this = self, a, dword [rec], dword [rec+4], dword [rec+8]) (thiscall, four arguments; rec is the address of a record, a host pointer for the port). */
uint32_t m4cca42_forward_struct(uint8_t *self, uint32_t a, const uint8_t *rec, const Fl18Host *host);

/* 0x4cca6f, thiscall, stack arguments (a, rec), `ret 8`, returns the eax of the callee: 0x4cca9c(this = self, a, dword [rec], dword [rec+4], dword [rec+8]) (thiscall, four arguments; rec is the address of a record, a host pointer for the port). */
uint32_t m4cca6f_forward_struct(uint8_t *self, uint32_t a, const uint8_t *rec, const Fl18Host *host);

/* 0x4ccd25, thiscall, plain `ret`, returns the constant 0x52e258 (an address in the image of the original); `self` (ecx) is only saved and not used. */
uint32_t m4ccd25_get_constant(void);

/* 0x4d0b68, no `this` (a plain frame), no return value: for the signed word i = 0 .. 8: when i == the signed word [0x5aff57] 0x4c5377(this = 0x5cf659, [0x5d2b47], dword 0x5cf665, i*16 + 0x5afeb5, i*16 + 0x5afd05, 0x55a098), otherwise 0x4c5377(this = 0x5cf659, [0x5d2a1f], dword 0x5cf665, i*16 + 0x5afd05, i*16 + 0x5afd05, 0x55a0bc) (thiscall, five arguments each, the one pushed last first). */
void m4d0b68_log_loop(const Fl39eWorld *world, const Fl18Host *host);

/* 0x4d0c57, no `this` (a plain frame), no return value: for the signed word i = 0 .. 0: when i == the signed word [0x5b0010] 0x4c5377(this = 0x5cf659, [0x5d2d03], dword 0x5cf665, i*16 + 0x5afff2, i*16 + 0x5affd2, 0x55a0f8), otherwise 0x4c5377(this = 0x5cf659, [0x5d2bdb], dword 0x5cf665, i*16 + 0x5affd2, i*16 + 0x5affd2, 0x55a118) (thiscall, five arguments each, the one pushed last first). */
void m4d0c57_log_loop(const Fl39eWorld *world, const Fl18Host *host);

/* 0x4d3728, no `this` (a plain frame), no return value: 0x4c5377(this = 0x5cf659, [0x5d03bb], dword 0x5cf665, 0x5b4e58, [0x5d1963], 0x55a388) and 0x4c5d4b(this = 0x5cf659, [0x5d195b], dword 0x5cf665, [0x5d195f], [0x5d1963], 0x55a398) (thiscall, five arguments each, the one pushed last first); then, when the signed word [0x5b4e8d] is non-zero, 0x4c5d4b(this = 0x5cf659, [0x5d03c7], dword 0x5cf665, 0x5b4e38, 0x5b4e48, 0x55a3a8). */
void m4d3728_log_three(const Fl39eWorld *world, const Fl18Host *host);

/* 0x4d37af, no `this` (a plain frame), no return value: 0x4c5377(this = 0x5cf659, [0x5d03bb], dword 0x5cf665, 0x5b50cf, [0x5d19ad], 0x55a3c4) and 0x4c5d4b(this = 0x5cf659, [0x5d19a5], dword 0x5cf665, [0x5d19a9], [0x5d19ad], 0x55a3d4) (thiscall, five arguments each, the one pushed last first); then, when the signed word [0x5b5104] is non-zero, 0x4c5d4b(this = 0x5cf659, [0x5d03cb], dword 0x5cf665, 0x5b50af, 0x5b50bf, 0x55a3e4). */
void m4d37af_log_three(const Fl39eWorld *world, const Fl18Host *host);

/* 0x4de227, thiscall, plain `ret`, returns the eax of the last callee: 0x4edcb1(this = self, self + 0x691, 1) (thiscall, two arguments), then 0x4ee6c7(this = self, 0) (thiscall, one argument). */
uint32_t m4de227_call_pair(uint8_t *self, const Fl18Host *host);

/* 0x4de413, thiscall, plain `ret`, no return value: when the dword [self+0x991] is neither 0 nor 1 (unsigned compare for equality only), 0x4ee517(this = self) (thiscall, no arguments). */
void m4de413_call_unless_01(uint8_t *self, const Fl18Host *host);

/* 0x4de584, thiscall, plain `ret`, no return value: when the dword [self+0x991] is neither 0 nor 1 (unsigned compare for equality only), 0x4ee86f(this = self) (thiscall, no arguments). */
void m4de584_call_unless_01(uint8_t *self, const Fl18Host *host);

/* 0x4de66e, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52e4d0u at [this], then 0x4de6fc(this), 0x4ee99f(this + 0x57e) and 0x4e1c83(this + 0x3ef) (thiscall, no arguments). The function links a structured-exception frame (handler 0x528946) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m4de66e_destroy_subobjects(uint8_t *self, const Fl18Host *host);

/* 0x4e053f, thiscall, `ret 4`, no return value: stores the stack argument's low word, sign-extended to a dword (movsx), in [self+0xf2a] (the upper half of the pushed dword is not read). */
void m4e053f_set_field_sx(uint8_t *self, uint32_t arg);

/* 0x4e1113, thiscall, plain `ret`, no return value: when dword [self+0x74f] != 0, 0x4c5377(this = 0x5cf659, [self+0x74f], dword [0x5cf665], self+0x25, self+0x35, 0x55be0c) (thiscall, five arguments; the dword [self+0x74f] is pushed last, so it is the first argument). */
void m4e1113_log_guarded(uint8_t *self, const Fl39eWorld *world, const Fl18Host *host);

/* 0x4e1157, thiscall, plain `ret`, no return value: when dword [self+0x74f] != 0, 0x4c5377(this = 0x5cf659, [self+0x74f], dword [0x5cf665], self+0x55, self+0x55, 0x55be54) (thiscall, five arguments; the dword [self+0x74f] is pushed last, so it is the first argument). */
void m4e1157_log_guarded(uint8_t *self, const Fl39eWorld *world, const Fl18Host *host);

/* 0x4e7700, thiscall, plain `ret`, returns the eax of the last callee: 0x4edcb1(this = self, self + 0x691, 1) (thiscall, two arguments), then 0x4ee6c7(this = self, 1) (thiscall, one argument). */
uint32_t m4e7700_call_pair(uint8_t *self, const Fl18Host *host);

/* 0x4e7a10, thiscall, plain `ret`, no return value: when the dword [self+0x991] is neither 0 nor 1 (unsigned compare for equality only), 0x4ee86f(this = self) (thiscall, no arguments). */
void m4e7a10_call_unless_01(uint8_t *self, const Fl18Host *host);

/* 0x4eda7c, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52e4fcu at [this], then 0x4edb97(this), 0x4ee99f(this + 0x4b7) and 0x4e1c83(this + 0x31c) (thiscall, no arguments). The function links a structured-exception frame (handler 0x528b36) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m4eda7c_destroy_subobjects(uint8_t *self, const Fl18Host *host);

/* 0x4ee5b8, thiscall, `ret 4`, no return value: stores the stack argument in the dword global 0x55cd94. `self` (ecx) is not used. */
void m4ee5b8_store_global(Fl39eWorld *world, uint32_t arg);

/* 0x4ee5dd, thiscall, `ret 4`, no return value: stores the stack argument in the dword global 0x63aa10. `self` (ecx) is not used. */
void m4ee5dd_store_global(Fl39eWorld *world, uint32_t arg);

/* 0x4ee616, thiscall, `ret 4`, no return value: stores the stack argument's low word, sign-extended to a dword (movsx), in [self+0x4af] (the upper half of the pushed dword is not read). */
void m4ee616_set_field_sx(uint8_t *self, uint32_t arg);

/* 0x4f872e, thiscall, plain `ret`, returns the eax of the callee: 0x4f861c(this = self, [self+0x240], [self+0x244], [self+0x248]) (thiscall, three arguments; the dword [self+0x240] is pushed last, so it is the first argument). */
uint32_t m4f872e_forward_fields(uint8_t *self, const Fl18Host *host);

/* 0x4f88ad, thiscall, plain `ret`, returns the eax of the callee: 0x4f875f(this = self, [self+0x24c], [self+0x250], [self+0x254]) (thiscall, three arguments; the dword [self+0x24c] is pushed last, so it is the first argument). */
uint32_t m4f88ad_forward_fields(uint8_t *self, const Fl18Host *host);

/* 0x4fc909, thiscall, plain `ret`, no return value: when the signed word 0x63a4cd (debug flag) is non-zero, 0x44a2b7(0x56095c) (cdecl); r = 0x4f67be(this = 0x5cf1eb) (thiscall, no arguments); when r == 0 and the flag is (still) non-zero: t = 0x4fa2a8(this = 0x5cf1eb), 0x50ca3e(0x63888b, 0x560974, t) (cdecl, three arguments), 0x52139c(0x63888b, 0, 0) (stdcall: the callee pops) and 0x44a2b7(0x63888b) (cdecl). `self` is only saved. */
void m4fc909_check_trace(const Fl39eWorld *world, const Fl18Host *host);

/* 0x4fc97d, thiscall, plain `ret`, no return value: when the signed word 0x63a4cd (debug flag) is non-zero, 0x44a2b7(0x560994) (cdecl); r = 0x4f6810(this = 0x5cf1eb) (thiscall, no arguments); when r == 0 and the flag is (still) non-zero: t = 0x4fa2a8(this = 0x5cf1eb), 0x50ca3e(0x63888b, 0x5609b0, t) (cdecl, three arguments), 0x52139c(0x63888b, 0, 0) (stdcall: the callee pops) and 0x44a2b7(0x63888b) (cdecl). `self` is only saved. */
void m4fc97d_check_trace(const Fl39eWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
