#ifndef BLACKMOOR_ORIGINAL_METHODS_FL39A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL39A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-39 (batch a): 28 functions of GAME.EXE (SHA-256 afd337a2...5c45) at or above 0x480000 ported one to one, in the style of FL-36 (see original_methods_fl36f.h, whose conventions
 * apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment, `self` is the
 * original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names are descriptive hints, not
 * recovered source names. The constants of every row (field offsets, callees, stored values, sizes) were read from that row's own disassembly by the generator, which also
 * asserted that every row of a kind has the identical masked instruction stream. A dword of `self` that holds an address of the original goes through Fl18Host.resolve;
 * a callee that changes `self` or a global that the function reads again afterwards is not exercised. */

typedef struct Fl39aWorld {
    uint8_t *table_5d15a5; /* records of stride 0x4a at the original address 0x5d15a5 (the dword at +0 is set); the caller leaves slack for a negative index */
} Fl39aWorld;

/* 0x48220e, thiscall, plain `ret`: when byte [self+0xa8] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m48220e_mark_entry(const uint8_t *self, const Fl39aWorld *world);

/* 0x487b4f, thiscall, plain `ret`, returns the eax of the last callee: when dword [self+0x20] != 0, 0x4c2dfb(this = 0x5cf659) with the stack argument self + 0x20 (thiscall, one argument); when the signed word [self+0x1c] != -1, 0x4d3992(word) (cdecl, one argument pushed from edx, whose upper half is left-over: the callee reads a word); then 0x487b1a(this self) (thiscall, no arguments). */
uint32_t m487b4f_release_entry(uint8_t *self, const Fl18Host *host);

/* 0x487b98, thiscall, plain `ret`: when dword [self+0x71] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m487b98_mark_entry(const uint8_t *self, const Fl39aWorld *world);

/* 0x48a7e5, thiscall, plain `ret`, returns the eax of the last callee: when dword [self+0x20] != 0, 0x4c2dfb(this = 0x5cf659) with the stack argument self + 0x20 (thiscall, one argument); when the signed word [self+0x1c] != -1, 0x4d3992(word) (cdecl, one argument pushed from edx, whose upper half is left-over: the callee reads a word); then 0x48a70a(this self) (thiscall, no arguments). */
uint32_t m48a7e5_release_entry(uint8_t *self, const Fl18Host *host);

/* 0x48a82e, thiscall, plain `ret`: when dword [self+0x1aa] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m48a82e_mark_entry(const uint8_t *self, const Fl39aWorld *world);

/* 0x48e393, thiscall, plain `ret`: when dword [self+0x462] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m48e393_mark_entry(const uint8_t *self, const Fl39aWorld *world);

/* 0x490547, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52daf8u at [this], then 0x490d50(this) and 0x51d730(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52852d) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m490547_destroy_with_frame(uint8_t *self, const Fl18Host *host);

/* 0x493a10, thiscall, plain `ret`: when dword [self+0x1f77] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m493a10_mark_entry(const uint8_t *self, const Fl39aWorld *world);

/* 0x49c59f, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52dbc8u at [this], then 0x49c68a(this) and 0x51d730(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x528570) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m49c59f_destroy_with_frame(uint8_t *self, const Fl18Host *host);

/* 0x4a1ce0, thiscall, plain `ret`: when dword [self+0x60] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4a1ce0_mark_entry(const uint8_t *self, const Fl39aWorld *world);

/* 0x4a3910, thiscall, plain `ret`: when dword [self+0x26e] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4a3910_mark_entry(const uint8_t *self, const Fl39aWorld *world);

/* 0x4a6477, thiscall, plain `ret`: when dword [self+0x86] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4a6477_mark_entry(const uint8_t *self, const Fl39aWorld *world);

/* 0x4a7da5, thiscall, plain `ret`: when dword [self+0xe72] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4a7da5_mark_entry(const uint8_t *self, const Fl39aWorld *world);

/* 0x4a9fcb, thiscall, plain `ret`: when byte [self+0x45] == 0 nothing. Otherwise i = signed word [self+0x29]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4a9fcb_mark_entry(const uint8_t *self, const Fl39aWorld *world);

/* 0x4ab3dc, thiscall, plain `ret`, returns the eax of the last callee: when dword [self+0x20] != 0, 0x4c2dfb(this = 0x5cf659) with the stack argument self + 0x20 (thiscall, one argument); when the signed word [self+0x1c] != -1, 0x4d3992(word) (cdecl, one argument pushed from edx, whose upper half is left-over: the callee reads a word); then 0x4ab3a7(this self) (thiscall, no arguments). */
uint32_t m4ab3dc_release_entry(uint8_t *self, const Fl18Host *host);

/* 0x4ab425, thiscall, plain `ret`: when dword [self+0x54] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4ab425_mark_entry(const uint8_t *self, const Fl39aWorld *world);

/* 0x4acbba, thiscall, plain `ret`: when dword [self+0xc1b] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4acbba_mark_entry(const uint8_t *self, const Fl39aWorld *world);

/* 0x4afd7e, thiscall, plain `ret`, returns the eax of the last callee: when dword [self+0x20] != 0, 0x4c2dfb(this = 0x5cf659) with the stack argument self + 0x20 (thiscall, one argument); when the signed word [self+0x1c] != -1, 0x4d3992(word) (cdecl, one argument pushed from edx, whose upper half is left-over: the callee reads a word); then 0x4afd3a(this self) (thiscall, no arguments). */
uint32_t m4afd7e_release_entry(uint8_t *self, const Fl18Host *host);

/* 0x4afdc7, thiscall, plain `ret`: when dword [self+0x1515] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4afdc7_mark_entry(const uint8_t *self, const Fl39aWorld *world);

/* 0x4b3d4d, thiscall, plain `ret`, returns the eax of the last callee: when dword [self+0x754] != 0, 0x4c2dfb(this = 0x5cf659) with the stack argument self + 0x754 (thiscall, one argument); when the signed word [self+0x726] != -1, 0x4d3992(word) (cdecl, one argument pushed from edx, whose upper half is left-over: the callee reads a word); then 0x4b3c5a(this self) (thiscall, no arguments). */
uint32_t m4b3d4d_release_entry(uint8_t *self, const Fl18Host *host);

/* 0x4b3da2, thiscall, plain `ret`: when dword [self+0x76e] == 0 nothing. Otherwise i = signed word [self+0x726]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4b3da2_mark_entry(const uint8_t *self, const Fl39aWorld *world);

/* 0x4b7229, thiscall, plain `ret`, returns the eax of the last callee: when dword [self+0x1d] != 0, 0x4c2dfb(this = 0x5cf659) with the stack argument self + 0x1d (thiscall, one argument); when the signed word [self+0x2f] != -1, 0x4d3992(word) (cdecl, one argument pushed from edx, whose upper half is left-over: the callee reads a word); then 0x4b71f7(this self) (thiscall, no arguments). */
uint32_t m4b7229_release_entry(uint8_t *self, const Fl18Host *host);

/* 0x4b7272, thiscall, plain `ret`: when byte [self+0x35] == 0 nothing. Otherwise i = signed word [self+0x2f]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4b7272_mark_entry(const uint8_t *self, const Fl39aWorld *world);

/* 0x4ba22e, thiscall, plain `ret`: when dword [self+0x34] == 0 nothing. Otherwise i = signed word [self+0x4]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4ba22e_mark_entry(const uint8_t *self, const Fl39aWorld *world);

/* 0x4cafc1, thiscall, plain `ret`: when dword [self+0xe] == 0 nothing. Otherwise i = signed word [self+0xc]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4cafc1_mark_entry(const uint8_t *self, const Fl39aWorld *world);

/* 0x4dbf6e, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52e478u at [this], then 0x4dc043(this) and 0x51d730(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5288b0) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m4dbf6e_destroy_with_frame(uint8_t *self, const Fl18Host *host);

/* 0x4de1a4, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52e4ccu at [this], then 0x4de214(this) and 0x4eda7c(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5288ec) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m4de1a4_destroy_with_frame(uint8_t *self, const Fl18Host *host);

/* 0x4e7684, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52e4f0u at [this], then 0x4e76ed(this) and 0x4eda7c(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x528a1c) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m4e7684_destroy_with_frame(uint8_t *self, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
