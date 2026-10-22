#ifndef BLACKMOOR_ORIGINAL_METHODS_FL39C_H
#define BLACKMOOR_ORIGINAL_METHODS_FL39C_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-39 (batch c): 33 functions of GAME.EXE (SHA-256 afd337a2...5c45) at or above 0x480000 ported one to one, in the style of FL-36 (see original_methods_fl36f.h, whose conventions
 * apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment, `self` is the
 * original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names are descriptive hints, not
 * recovered source names. The constants of every row (field offsets, callees, stored values, sizes) were read from that row's own disassembly by the generator, which also
 * asserted that every row of a kind has the identical masked instruction stream. A dword of `self` that holds an address of the original goes through Fl18Host.resolve;
 * a callee that changes `self` or a global that the function reads again afterwards is not exercised. */

typedef struct Fl39cWorld {
    int32_t value_58319a, value_5831a2, value_583196, value_58319e; /* the clip bounds: x low / x high (0x583196, 0x58319e) and y low / y high (0x58319a, 0x5831a2) */
    const uint8_t *bytes_5511d4; /* the nine bytes at 0x5511d4 that the function compares with */
    const uint8_t *bytes_5511e0; /* the nine bytes at 0x5511e0 that the function compares with */
    const uint8_t *bytes_5511ec; /* the nine bytes at 0x5511ec that the function compares with */
    const uint8_t *bytes_55214c; /* the nine bytes at 0x55214c that the function compares with */
    const uint8_t *bytes_552158; /* the nine bytes at 0x552158 that the function compares with */
    const uint8_t *bytes_552164; /* the nine bytes at 0x552164 that the function compares with */
    const uint8_t *bytes_552170; /* the nine bytes at 0x552170 that the function compares with */
    const uint8_t *bytes_55217c; /* the nine bytes at 0x55217c that the function compares with */
    int16_t word_63a4cd; /* the debug flag: a non-zero word turns the trace on */
} Fl39cWorld;

/* 0x4a3aec, thiscall, plain `ret`, no return value, no calls: two bounds of a rectangle clamped against the signed globals. y: when the signed dword [self+0x22c] < [0x58319a] it becomes that value and [self+0x234] = it + the signed word [self+0x832]; then when [self+0x234] > [0x5831a2] (signed) it becomes that value and [self+0x22c] = it - the word. x: the same with [self+0x228], [self+0x230], [0x583196], [0x58319e] and the signed word [self+0x830]. */
void m4a3aec_clamp_rect(uint8_t *self, const Fl39cWorld *world);

/* 0x4a7f08, thiscall, plain `ret`, no return value, no calls: two bounds of a rectangle clamped against the signed globals. y: when the signed dword [self+0xe2a] < [0x58319a] it becomes that value and [self+0xe32] = it + the signed word [self+0x13a6]; then when [self+0xe32] > [0x5831a2] (signed) it becomes that value and [self+0xe2a] = it - the word. x: the same with [self+0xe26], [self+0xe2e], [0x583196], [0x58319e] and the signed word [self+0x13a4]. */
void m4a7f08_clamp_rect(uint8_t *self, const Fl39cWorld *world);

/* 0x4ada0d, thiscall, plain `ret`, no return value: the dword [self+0xc17] is the address of an object; `repe cmpsb` of the nine bytes at [object+0x296] against the nine bytes at 0x5511d4; when they differ, 0x4fb2e3(this = 0x5c3a67) (thiscall, one argument) with the word [object+0x2b7] (zero-extended: edx is cleared first); otherwise nothing. */
void m4ada0d_check_bytes(const uint8_t *self, const Fl39cWorld *world, const Fl18Host *host);

/* 0x4ada56, thiscall, plain `ret`, no return value: the dword [self+0xc17] is the address of an object; `repe cmpsb` of the nine bytes at [object+0x234] against the nine bytes at 0x5511e0; when they differ, 0x4fb2e3(this = 0x5c3a67) (thiscall, one argument) with the word [object+0x255] (zero-extended: edx is cleared first); otherwise nothing. */
void m4ada56_check_bytes(const uint8_t *self, const Fl39cWorld *world, const Fl18Host *host);

/* 0x4ada9f, thiscall, plain `ret`, no return value: the dword [self+0xc17] is the address of an object; `repe cmpsb` of the nine bytes at [object+0x265] against the nine bytes at 0x5511ec; when they differ, 0x4fb2e3(this = 0x5c3a67) (thiscall, one argument) with the word [object+0x286] (zero-extended: edx is cleared first); otherwise nothing. */
void m4ada9f_check_bytes(const uint8_t *self, const Fl39cWorld *world, const Fl18Host *host);

/* 0x4b3e99, thiscall, plain `ret`, no return value, no calls: two bounds of a rectangle clamped against the signed globals. y: when the signed dword [self+0x6e0] < [0x58319a] it becomes that value and [self+0x6e8] = it + the signed word [self+0x722]; then when [self+0x6e8] > [0x5831a2] (signed) it becomes that value and [self+0x6e0] = it - the word. x: the same with [self+0x6dc], [self+0x6e4], [0x583196], [0x58319e] and the signed word [self+0x71e]. */
void m4b3e99_clamp_rect(uint8_t *self, const Fl39cWorld *world);

/* 0x4be3d3, thiscall, plain `ret`, no return value: `repe cmpsb` of the nine bytes at [self+0x31c] against the nine bytes at 0x55214c; when they differ, 0x4fb2e3(this = 0x5c3a67) (thiscall, one argument) with the word [self+0x33d] (pushed from edx whose upper half is left-over: the callee reads a word); otherwise nothing. */
void m4be3d3_check_bytes(const uint8_t *self, const Fl39cWorld *world, const Fl18Host *host);

/* 0x4be410, thiscall, plain `ret`, no return value: `repe cmpsb` of the nine bytes at [self+0x34d] against the nine bytes at 0x552158; when they differ, 0x4fb2e3(this = 0x5c3a67) (thiscall, one argument) with the word [self+0x36e] (pushed from edx whose upper half is left-over: the callee reads a word); otherwise nothing. */
void m4be410_check_bytes(const uint8_t *self, const Fl39cWorld *world, const Fl18Host *host);

/* 0x4be44d, thiscall, plain `ret`, no return value: `repe cmpsb` of the nine bytes at [self+0x37e] against the nine bytes at 0x552164; when they differ, 0x4fb2e3(this = 0x5c3a67) (thiscall, one argument) with the word [self+0x39f] (pushed from edx whose upper half is left-over: the callee reads a word); otherwise nothing. */
void m4be44d_check_bytes(const uint8_t *self, const Fl39cWorld *world, const Fl18Host *host);

/* 0x4be48a, thiscall, plain `ret`, no return value: `repe cmpsb` of the nine bytes at [self+0x3af] against the nine bytes at 0x552170; when they differ, 0x4fb2e3(this = 0x5c3a67) (thiscall, one argument) with the word [self+0x3d0] (pushed from edx whose upper half is left-over: the callee reads a word); otherwise nothing. */
void m4be48a_check_bytes(const uint8_t *self, const Fl39cWorld *world, const Fl18Host *host);

/* 0x4be4c7, thiscall, plain `ret`, no return value: `repe cmpsb` of the nine bytes at [self+0x411] against the nine bytes at 0x55217c; when they differ, 0x4fb2e3(this = 0x5c3a67) (thiscall, one argument) with the word [self+0x432] (pushed from edx whose upper half is left-over: the callee reads a word); otherwise nothing. */
void m4be4c7_check_bytes(const uint8_t *self, const Fl39cWorld *world, const Fl18Host *host);

/* 0x4be619, cdecl-style stack arguments (out, size), `ret 8`, returns the eax of the failure path (0 otherwise): p = 0x51dc43(size) (cdecl); dword [out] = p; when p == 0: 0x50ca3e(0x63888b, 0x552190) (cdecl), 0x4264e8(0x63888b) on 0x583979 (thiscall), 0x44a2b7(0x63888b) (cdecl) only when the debug word 0x63a4cd is non-zero, then the eax of 0x4c97b4 on 0x5cf659 (thiscall); otherwise `size` bytes at p are zeroed (`rep stosd`, then `rep stosb` for size & 3). `self` (ecx) is not used. */
uint32_t m4be619_alloc_zero(uint8_t *out, uint32_t size, const Fl39cWorld *world, const Fl18Host *host);

/* 0x4bf542, cdecl-style stack arguments (out, size), `ret 8`, returns the eax of the failure path (0 otherwise): p = 0x51dc43(size) (cdecl); dword [out] = p; when p == 0: 0x50ca3e(0x63888b, 0x5525ac) (cdecl), 0x4264e8(0x63888b) on 0x583979 (thiscall), 0x44a2b7(0x63888b) (cdecl) only when the debug word 0x63a4cd is non-zero, then the eax of 0x4c97b4 on 0x5cf659 (thiscall); otherwise `size` bytes at p are zeroed (`rep stosd`, then `rep stosb` for size & 3). `self` (ecx) is not used. */
uint32_t m4bf542_alloc_zero(uint8_t *out, uint32_t size, const Fl39cWorld *world, const Fl18Host *host);

/* 0x4cb8d5, thiscall, plain `ret`, returns the local: a dword local is cleared, 0x4cc70f(this = self, &local, 0x18) (thiscall, two arguments) may store through the pointer, and the function returns the local (not the eax of the callee). */
uint32_t m4cb8d5_get_via_out(uint8_t *self, const Fl18Host *host);

/* 0x4cb8fa, thiscall, plain `ret`, returns the local: a dword local is cleared, 0x4cc70f(this = self, &local, 0xd) (thiscall, two arguments) may store through the pointer, and the function returns the local (not the eax of the callee). */
uint32_t m4cb8fa_get_via_out(uint8_t *self, const Fl18Host *host);

/* 0x4cb91f, thiscall, plain `ret`, returns the local: a dword local is cleared, 0x4cc70f(this = self, &local, 0x29) (thiscall, two arguments) may store through the pointer, and the function returns the local (not the eax of the callee). */
uint32_t m4cb91f_get_via_out(uint8_t *self, const Fl18Host *host);

/* 0x4cc70f, cdecl-style stack arguments (out, size), `ret 8`, returns the eax of the failure path (0 otherwise): p = 0x51dc43(size) (cdecl); dword [out] = p; when p == 0: 0x50ca3e(0x63888b, 0x559038) (cdecl), 0x4264e8(0x63888b) on 0x583979 (thiscall), 0x44a2b7(0x63888b) (cdecl) only when the debug word 0x63a4cd is non-zero, then the eax of 0x4c97b4 on 0x5cf659 (thiscall); otherwise `size` bytes at p are zeroed (`rep stosd`, then `rep stosb` for size & 3). `self` (ecx) is not used. */
uint32_t m4cc70f_alloc_zero(uint8_t *out, uint32_t size, const Fl39cWorld *world, const Fl18Host *host);

/* 0x4d9910, cdecl-style stack arguments (out, size), `ret 8`, returns the eax of the failure path (0 otherwise): p = 0x51dc43(size) (cdecl); dword [out] = p; when p == 0: 0x50ca3e(0x63888b, 0x55aa34) (cdecl), 0x4264e8(0x63888b) on 0x583979 (thiscall), 0x44a2b7(0x63888b) (cdecl) only when the debug word 0x63a4cd is non-zero, then the eax of 0x4c97b4 on 0x5cf659 (thiscall); otherwise `size` bytes at p are zeroed (`rep stosd`, then `rep stosb` for size & 3). `self` (ecx) is not used. */
uint32_t m4d9910_alloc_zero(uint8_t *out, uint32_t size, const Fl39cWorld *world, const Fl18Host *host);

/* 0x4de394, thiscall, stack arguments (src, limit), `ret 8`, no return value: copies 192 dwords (0x300 bytes) from src to [self+0x691]; when 0x300 > limit (signed): 0x50ca3e(0x63888b, 0x55b87c, 0x300, limit) (cdecl, four arguments), 0x4264e8(0x63888b) on 0x583979 (thiscall), 0x4c97b4 on 0x5cf659 (thiscall, no argument). */
void m4de394_copy_block(uint8_t *self, const uint8_t *src, int32_t limit, const Fl18Host *host);

/* 0x4e2d63, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52e4ecu at [this], then 0x4e2faa(this) (thiscall, no arguments), 0x50cba8(this + 0x1ca2, 0x18f, 26, 0x4e1c83) (cdecl, four arguments: the vector iterator) and 0x4eda7c(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5289f2) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m4e2d63_destroy_vector(uint8_t *self, const Fl18Host *host);

/* 0x4e3525, thiscall, `ret 4`, returns the eax of the callee: stores the stack argument in the dword [self+0x452c], then 0x4edf96(this = self, the same argument) (thiscall, one argument). */
uint32_t m4e3525_set_field_forward(uint8_t *self, uint32_t arg, const Fl18Host *host);

/* 0x4e37bd, thiscall, plain `ret`, returns the eax of the last callee: 0x4e2940(this = self+0x3d5d, 0), 0x4e2940(this = self+0x3eec, 0) and 0x4e2940(this = self+0x4399, 0), each thiscall with one argument 0. */
uint32_t m4e37bd_call_three_zero(uint8_t *self, const Fl18Host *host);

/* 0x4e37f8, thiscall, plain `ret`, returns the eax of the last callee: 0x4e2940(this = self+0x3d5d, 0), 0x4e2940(this = self+0x3eec, 0) and 0x4e2940(this = self+0x4399, 0), each thiscall with one argument 0. */
uint32_t m4e37f8_call_three_zero(uint8_t *self, const Fl18Host *host);

/* 0x4e3833, thiscall, plain `ret`, returns the eax of the last callee: 0x4e2940(this = self+0x3d5d, 0), 0x4e2940(this = self+0x3eec, 0) and 0x4e2940(this = self+0x407b, 0), each thiscall with one argument 0. */
uint32_t m4e3833_call_three_zero(uint8_t *self, const Fl18Host *host);

/* 0x4e7843, thiscall, stack arguments (src, limit), `ret 8`, no return value: copies 192 dwords (0x300 bytes) from src to [self+0x691]; when 0x300 > limit (signed): 0x50ca3e(0x63888b, 0x55c4c4, 0x300, limit) (cdecl, four arguments), 0x4264e8(0x63888b) on 0x583979 (thiscall), 0x4c97b4 on 0x5cf659 (thiscall, no argument). */
void m4e7843_copy_block(uint8_t *self, const uint8_t *src, int32_t limit, const Fl18Host *host);

/* 0x4e7b37, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52e4f4u at [this], then 0x4e7bf3(this) (thiscall, no arguments), 0x50cba8(this + 0x7654, 0x18f, 6, 0x4e1c83) (cdecl, four arguments: the vector iterator) and 0x4eda7c(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x528a82) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m4e7b37_destroy_vector(uint8_t *self, const Fl18Host *host);

/* 0x4e7d2e, thiscall, stack arguments (src, limit), `ret 8`, no return value: copies 715 dwords (0xb2c bytes) from src to [self+0x6b20]; when 0xb2c > limit (signed): 0x50ca3e(0x63888b, 0x55c530, 0xb2c, limit) (cdecl, four arguments), 0x4264e8(0x63888b) on 0x583979 (thiscall), 0x4c97b4 on 0x5cf659 (thiscall, no argument). */
void m4e7d2e_copy_block(uint8_t *self, const uint8_t *src, int32_t limit, const Fl18Host *host);

/* 0x4e8994, thiscall, `ret 4`, returns the eax of the callee: stores the stack argument in the dword [self+0x7650], then 0x4edf96(this = self, the same argument) (thiscall, one argument). */
uint32_t m4e8994_set_field_forward(uint8_t *self, uint32_t arg, const Fl18Host *host);

/* 0x4eb8fe, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52e4f8u at [this], then 0x4eba54(this) (thiscall, no arguments), 0x50cba8(this + 0xca8, 0x18f, 2, 0x4e1c83) (cdecl, four arguments: the vector iterator) and 0x4eda7c(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x528ae2) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m4eb8fe_destroy_vector(uint8_t *self, const Fl18Host *host);

/* 0x4ebd2e, thiscall, `ret 4`, returns the eax of the callee: stores the stack argument in the dword [self+0xca4], then 0x4edf96(this = self, the same argument) (thiscall, one argument). */
uint32_t m4ebd2e_set_field_forward(uint8_t *self, uint32_t arg, const Fl18Host *host);

/* 0x4fcd4d, thiscall, `ret 4`, returns the eax of the callee: 0x4fccf2(this = self, word, 0) (thiscall, two arguments: the stack argument word, pushed from ax with a left-over upper half (the callee reads a word), and the constant 0 pushed first). */
uint32_t m4fcd4d_forward_word(uint8_t *self, uint16_t arg, const Fl18Host *host);

/* 0x4fcd69, thiscall, `ret 4`, returns the eax of the callee: 0x4fccf2(this = self, word, 1) (thiscall, two arguments: the stack argument word, pushed from ax with a left-over upper half (the callee reads a word), and the constant 1 pushed first). */
uint32_t m4fcd69_forward_word(uint8_t *self, uint16_t arg, const Fl18Host *host);

/* 0x4fcd85, thiscall, `ret 4`, returns the eax of the callee: 0x4fccf2(this = self, word, 2) (thiscall, two arguments: the stack argument word, pushed from ax with a left-over upper half (the callee reads a word), and the constant 2 pushed first). */
uint32_t m4fcd85_forward_word(uint8_t *self, uint16_t arg, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
