#ifndef BLACKMOOR_ORIGINAL_METHODS_FL32C_H
#define BLACKMOOR_ORIGINAL_METHODS_FL32C_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-32 (batch c): nine small methods and handlers of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-31 batch a (see original_methods_fl31a.h, whose
 * conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment,
 * `self` is the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names are
 * descriptive hints, not recovered source names.
 *
 * Calls into original code, the CRT and MFC go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first argument of a
 * C prototype). A dword of the original that is an address of the original (a constant such as 0x55b8d0) is passed as that number; the address of a field of `self` or of
 * a local that the original passes to a callee is passed as the host pointer of that field or local. A callee that changes `self` or a global that the function reads again
 * afterwards is exercised only where tasks/fl32c-handoff.md says so. Nothing here claims original source structure. */

typedef struct Fl32cWorld {
    uint8_t *table_5d15a5;     /* 0x44e7d7: records of stride 0x4a at the original address 0x5d15a5 (the dword at +0 is set); the caller leaves slack for a negative index */
    uint32_t value_583186, value_58318a;    /* 0x44e95b: the two offsets added to the rectangle (x at 0x583186, y at 0x58318a) */
    uint32_t value_5c39e5;     /* 0x4db090: compared with -1 */
    uint32_t value_5cf665;     /* 0x4de53e: the dword that is the third argument of 0x4c5377 */
    uint32_t value_5d1717;     /* 0x4ea229: cleared */
    int16_t word_63a4cd;       /* 0x4ea229: the debug word */
} Fl32cWorld;

/* 0x44e78e, thiscall, plain `ret`: when dword [self+0x20] != 0: 0x4c2dfb(this 0x5cf659, self + 0x20) (thiscall, 1 argument: the ADDRESS of the field, a host pointer here).
 * Then, when the signed word [self+0x1c] (read again after that call) != -1: 0x4d3992(w) (cdecl, 1 argument; the original pushes edx whose upper half is the left-over of `this`,
 * so only the low 16 bits are the argument and the port passes the zero-extended word). Finally 0x44e767(this self) (thiscall, no arguments). */
void m44e78e_release_entry(uint8_t *self, const Fl18Host *host);

/* 0x44e7d7, thiscall, plain `ret`: when dword [self+0x6b] (unaligned) == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m44e7d7_mark_entry(const uint8_t *self, const Fl32cWorld *world);

/* 0x44e95b, `ret 8` (ecx is stored and not used), stack arguments src, dst (rectangles of four dwords, host pointers): in this order dword [dst+4] = [src+4] + [0x58318a],
 * [dst+0xc] = [src+0xc] + [0x58318a], [dst+0] = [src+0] + [0x583186], [dst+8] = [src+8] + [0x583186] (wrapping 32-bit adds; src is read again after each store, so overlapping
 * rectangles give the original's result). */
void m44e95b_offset_rect(const uint8_t *src, uint8_t *dst, const Fl32cWorld *world);

/* 0x43edac, thiscall, `ret 0xc`, three dword stack arguments a8 (at [ebp+8]), ac, a10; returns eax. Calls 0x437774(ecx 0x583208, &a8, &ac, &a10) (thiscall, three pointer arguments to the
 * argument slots themselves, popped by the callee; the callee may write them), then copies a10, ac, a8 into three locals that nothing reads (dead stores; the port keeps them
 * as locals), then returns 0x51ab4b(this self) (thiscall, no arguments; MFC's CWnd::Default by shape, which takes the message from the thread state and not from this frame). */
uint32_t m43edac_default_after_query(uint8_t *self, uint32_t a8, uint32_t ac, uint32_t a10, const Fl18Host *host);

/* 0x43ee69, thiscall, `ret 0xc`, stack arguments msg ([ebp+8]), wparam, lparam; returns eax: msg == 0x14 -> 1. msg == 0x112 and (wparam & 0xfff0) is 0xf140 or 0xf170 -> 0. Anything else:
 * 0x51b461(this self, msg, wparam, lparam) (thiscall, three stack arguments pushed lparam first, popped by the callee) and its result. All compares are dword compares. */
uint32_t m43ee69_filter_message(uint8_t *self, uint32_t msg, uint32_t wparam, uint32_t lparam, const Fl18Host *host);

/* 0x4db090, thiscall, `ret 8` (two stack dwords that are popped and never read), plain: when dword [0x5c39e5] != -1 and dword [self+4] == 0: dword [self+4] = 1. When dword [self+0x10] == 1: it
 * becomes 2. Then dword [self+0xc] = 0. */
void m4db090_normalize_state(uint8_t *self, const Fl32cWorld *world);

/* 0x4de53e, thiscall, plain `ret`: p = 0x4ee630(this self) (thiscall, no arguments); when p != 0: 0x4c5377(this 0x5cf659, p, dword [0x5cf665] (read after the first call), self + 0x981 (a host
 * pointer), 0x5b0227, 0x55b8d0) (thiscall, five stack arguments, the callee pops them). */
void m4de53e_report(uint8_t *self, const Fl32cWorld *world, const Fl18Host *host);

/* 0x4ea229, thiscall, plain `ret`: 0x4c2dfb(this 0x5cf659, self + 0x699) (thiscall, 1 argument: the address of the field); dword [0x5d1717] = 0; when the signed word [0x63a4cd] != 0: 0x44a2b7(0x55cb10) (cdecl,
 * 1 argument). */
void m4ea229_clear_pending(uint8_t *self, Fl32cWorld *world, const Fl18Host *host);

/* 0x4fb2a6, thiscall, `ret 8`, stack arguments a ([ebp+8]) and b ([ebp+0xc]): idx = (b & 0xffff) * 0x5bb (32-bit); when the word [self + idx + 0x132] == 0: 0x4faf98(this self, a, e) (thiscall, two stack
 * arguments, popped by the callee) with e = the pushed eax = (idx & 0xffff0000) | (b & 0xffff). */
void m4fb2a6_check_slot(uint8_t *self, uint32_t a, uint32_t b, const Fl18Host *host);

/* FNS-END */

#ifdef __cplusplus
}
#endif

#endif
