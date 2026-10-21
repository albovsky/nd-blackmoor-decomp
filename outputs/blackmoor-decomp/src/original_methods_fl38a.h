#ifndef BLACKMOOR_ORIGINAL_METHODS_FL38A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL38A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-38 (batch a): 27 functions of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-36 / FL-35 (see original_methods_fl35b.h, whose conventions apply
 * unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment, `self` is the original
 * object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names are descriptive hints, not recovered
 * source names.
 *
 * guard       10 rows: if (dword [this+A] != 0 && (int16)[this+B] != -1) dword [0x5d15a5 + 0x4a * (int16)[this+B]] := 1; returns this in eax on every path.
 * release     7 rows: if (dword [this+A]) 0x4c2dfb(ecx 0x5cf659, this+A); if ((int16)[this+B] != -1) 0x4d3992(word [this+B]) (cdecl); returns 0x<tail>(this).
 * releaseclr  3 rows: the same, and dword [this+A] := 0 right after the first call; returns 0x<tail>(this).
 * nosound     3 rows: `repe cmpsb` of 9 bytes at this+A against the 9 bytes "NO SOUND\0" of the image; when they differ calls 0x4fb2e3(ecx 0x5c3a67, word [this+B]); eax is 0 when equal.
 * get         4 rows: returns a constant (the span of these rows includes int3 padding after the 16 code bytes).
 * The constants of every row (offsets, the tail callee, the string address and its 9 bytes, the returned value) were read from that row's own disassembly by the generator, which also
 * asserted that every row of a kind has the identical masked instruction stream. A callee that changes `self` is not exercised (the functions read nothing again after a call, except the
 * word [this+B], which no callee of the oracle changes). */

typedef struct Fl38aWorld {
    /* The host memory of the original address 0x5d15a5, the base of the table that the `guard` rows index with 0x4a * a signed 16-bit index; the caller leaves slack on both sides for the indices it uses. */
    uint8_t *table_5d15a5;
} Fl38aWorld;

/* 0x414c6d, thiscall, plain `ret`: returns the constant 0x52c4d0u in eax; `this` is only saved in a local and not read. */
uint32_t m414c6d_get_constant(uint8_t *self);

/* 0x447cc4, thiscall, plain `ret`: returns the constant 0x52ca38u in eax; `this` is only saved in a local and not read. */
uint32_t m447cc4_get_constant(uint8_t *self);

/* 0x4487de, thiscall, plain `ret`: returns the constant 0x52cae8u in eax; `this` is only saved in a local and not read. */
uint32_t m4487de_get_constant(uint8_t *self);

/* 0x44be44, thiscall, plain `ret`: returns the constant 0x52cb78u in eax; `this` is only saved in a local and not read. */
uint32_t m44be44_get_constant(uint8_t *self);

/* 0x4542b5, thiscall, plain `ret`, returns 0 when the 9 bytes at [self+0x550] equal the 9 bytes at 0x549de0 ("NO SOUND" and its terminating zero; `repe cmpsb`), else the eax of 0x4fb2e3 (thiscall, ecx 0x5c3a67) called with the word [self+0x571] (pushed from dx). */
uint32_t m4542b5_check_no_sound_call(uint8_t *self, const Fl18Host *host);

/* 0x4542f2, thiscall, plain `ret`, returns 0 when the 9 bytes at [self+0x581] equal the 9 bytes at 0x549dec ("NO SOUND" and its terminating zero; `repe cmpsb`), else the eax of 0x4fb2e3 (thiscall, ecx 0x5c3a67) called with the word [self+0x5a2] (pushed from dx). */
uint32_t m4542f2_check_no_sound_call(uint8_t *self, const Fl18Host *host);

/* 0x45441d, thiscall, plain `ret`, returns 0 when the 9 bytes at [self+0x676] equal the 9 bytes at 0x549e1c ("NO SOUND" and its terminating zero; `repe cmpsb`), else the eax of 0x4fb2e3 (thiscall, ecx 0x5c3a67) called with the word [self+0x697] (pushed from dx). */
uint32_t m45441d_check_no_sound_call(uint8_t *self, const Fl18Host *host);

/* 0x454de6, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0x20] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0x20 and then stores the dword 0 at [self+0x20] (after the call); when the signed word [self+0x1c] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x454d9e(this self) (thiscall, no arguments). */
uint32_t m454de6_release_surface_clear_call_tail(uint8_t *self, const Fl18Host *host);

/* 0x454e39, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0x150] is non-zero and the signed word [self+0x1c] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x1c]); the word is read again for the store (a signed 16-bit index, no bounds check). */
uint8_t *m454e39_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world);

/* 0x456d2e, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0x20] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0x20; when the signed word [self+0x1c] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x456d07(this self) (thiscall, no arguments). */
uint32_t m456d2e_release_surface_call_tail(uint8_t *self, const Fl18Host *host);

/* 0x456d77, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0x3e] is non-zero and the signed word [self+0x1c] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x1c]); the word is read again for the store (a signed 16-bit index, no bounds check). */
uint8_t *m456d77_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world);

/* 0x457fc2, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0x1c] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0x1c and then stores the dword 0 at [self+0x1c] (after the call); when the signed word [self+0x24] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x457f7a(this self) (thiscall, no arguments). */
uint32_t m457fc2_release_surface_clear_call_tail(uint8_t *self, const Fl18Host *host);

/* 0x458045, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0x98] is non-zero and the signed word [self+0x24] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x24]); the word is read again for the store (a signed 16-bit index, no bounds check). */
uint8_t *m458045_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world);

/* 0x459b87, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0xc8] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0xc8; when the signed word [self+0x22] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x459aea(this self) (thiscall, no arguments). */
uint32_t m459b87_release_surface_call_tail(uint8_t *self, const Fl18Host *host);

/* 0x45dd4d, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0x20] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0x20; when the signed word [self+0x1c] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x45dc8a(this self) (thiscall, no arguments). */
uint32_t m45dd4d_release_surface_call_tail(uint8_t *self, const Fl18Host *host);

/* 0x464076, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0x20] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0x20 and then stores the dword 0 at [self+0x20] (after the call); when the signed word [self+0x1c] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x46402e(this self) (thiscall, no arguments). */
uint32_t m464076_release_surface_clear_call_tail(uint8_t *self, const Fl18Host *host);

/* 0x4640c9, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0xb8] is non-zero and the signed word [self+0x1c] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x1c]); the word is read again for the store (a signed 16-bit index, no bounds check). */
uint8_t *m4640c9_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world);

/* 0x465b9f, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0x49] is non-zero and the signed word [self+0x1c] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x1c]); the word is read again for the store (a signed 16-bit index, no bounds check). */
uint8_t *m465b9f_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world);

/* 0x467651, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0x1ae] is non-zero and the signed word [self+0x10] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x10]); the word is read again for the store (a signed 16-bit index, no bounds check). */
uint8_t *m467651_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world);

/* 0x468f19, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0x52c] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0x52c; when the signed word [self+0x7c] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x468e5a(this self) (thiscall, no arguments). */
uint32_t m468f19_release_surface_call_tail(uint8_t *self, const Fl18Host *host);

/* 0x468f68, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0x55c] is non-zero and the signed word [self+0x7c] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x7c]); the word is read again for the store (a signed 16-bit index, no bounds check). */
uint8_t *m468f68_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world);

/* 0x46b707, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0x4a48] is non-zero and the signed word [self+0x1c] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x1c]); the word is read again for the store (a signed 16-bit index, no bounds check). */
uint8_t *m46b707_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world);

/* 0x46e7a6, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0x20] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0x20; when the signed word [self+0x1c] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x46e6c1(this self) (thiscall, no arguments). */
uint32_t m46e7a6_release_surface_call_tail(uint8_t *self, const Fl18Host *host);

/* 0x46e7ef, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0x46] is non-zero and the signed word [self+0x1c] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x1c]); the word is read again for the store (a signed 16-bit index, no bounds check). */
uint8_t *m46e7ef_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world);

/* 0x470ddc, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0xd24] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0xd24; when the signed word [self+0xd38] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x470d7a(this self) (thiscall, no arguments). */
uint32_t m470ddc_release_surface_call_tail(uint8_t *self, const Fl18Host *host);

/* 0x47823e, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0x20] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0x20; when the signed word [self+0x1c] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x4781fa(this self) (thiscall, no arguments). */
uint32_t m47823e_release_surface_call_tail(uint8_t *self, const Fl18Host *host);

/* 0x478287, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0x157a] is non-zero and the signed word [self+0x1c] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x1c]); the word is read again for the store (a signed 16-bit index, no bounds check). */
uint8_t *m478287_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world);

#ifdef __cplusplus
}
#endif

#endif
