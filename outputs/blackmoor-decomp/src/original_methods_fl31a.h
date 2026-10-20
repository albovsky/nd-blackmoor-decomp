#ifndef BLACKMOOR_ORIGINAL_METHODS_FL31A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL31A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-31 (batch a): small struct methods of GAME.EXE (SHA-256 afd337a2...5c45) around 0x47b200 ported one to one, in the style of FL-29 batch a (see
 * original_methods_fl29a.h, whose conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the
 * original address in its leading comment, `self` is the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep
 * the order of the original. The names are descriptive hints, not recovered source names.
 *
 * Calls into original code, the CRT and the imports go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first
 * argument of a C prototype); GetTickCount (import 0x52a23c) is Fl18Host.tick. A dword of `self` that holds an address of the original is a 32-bit original address
 * and goes through Fl18Host.resolve; only `self` and the Fl31aWorld table pointer are host pointers. The address of a field of `self` that the original passes to a
 * callee (0x47b321: self + 8) is passed as the host pointer of that field. A callee that changes `self` or a global that the function reads again afterwards is not
 * exercised (tasks/fl31a-handoff.md). Nothing here claims original source structure. */

typedef struct Fl31aWorld {
    uint8_t *table_5d15a5;     /* 0x47b3bc, 0x47d640: records of stride 0x4a at the original address 0x5d15a5 (the dword at +0 is set); the caller leaves slack for a negative index */
    uint32_t value_5c39e5, value_5d0377, value_5d162d, value_5b44f0, value_5b44f4, value_5d1631, value_5d1639;    /* 0x47b709 */
} Fl31aWorld;

/* 0x47b200, thiscall, plain `ret`, returns this (eax): dword [self] = 0x52d568 (the table pointer of the object), then 0x47b23b(this self) (thiscall, no arguments). */
uint8_t *m47b200_construct(uint8_t *self, const Fl18Host *host);

/* 0x47b3bc, thiscall, plain `ret`: when dword [self+0x24] == 0 nothing. Otherwise i = signed word [self+4]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m47b3bc_mark_entry(const uint8_t *self, const Fl31aWorld *world);

/* 0x47d640, thiscall, plain `ret`: when byte [self+0x57] == 0 nothing. Otherwise i = signed word [self+0x23] (unaligned); when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m47d640_mark_entry(const uint8_t *self, const Fl31aWorld *world);

/* 0x47b709, thiscall (ecx is stored and not used), `ret 4`, the stack argument is the word `sel` (signed): dword [0x5c39e5] = the sign-extended word; dword [0x5b44f0] = 0; dword [0x5b44f4] = 1;
 * dword [0x5d162d] = dword [0x5d0377]; dword [0x5d1631] = 0x5b160c + (dword [0x5b44f0] << 5) + (dword [0x5b44f4] << 4) (read back after the stores: 0x5b161c); dword [0x5d1639] = 1. */
void m47b709_set_selector(uint32_t sel, Fl31aWorld *world);

/* 0x47ba79, thiscall, plain `ret`: when dword [self+0x34] == 0 nothing. Otherwise now = GetTickCount() (import 0x52a23c); when now <= dword [self+0x38] (UNSIGNED) nothing. Otherwise (in this order):
 * dword [ [self+0x1c] + 4 ] = 0, dword [ [self+0x20] + 4 ] = 0 (both pointers are original addresses, resolved through Fl18Host, the second one read after the first store), then
 * dwords [self+0x1c], [self+0x20], [self+0x34], [self+0x38] = 0. */
void m47ba79_expire_links(uint8_t *self, const Fl18Host *host);

/* 0x47badf, thiscall, plain `ret`: with a = signed dword [self+0x290], b = [self+0x2a0], c = [self+0x294], d = signed dword [ [self+0xc] + 0x341 ] (an unaligned dword behind an original address):
 * when a >= b and c <= d: dword [self+0x28] = 1 and nothing else. Otherwise, when a < b and c >= d: dword [self+0x2c] = 1. (All comparisons are signed; every field is read again at each use.) */
void m47badf_check_range(uint8_t *self, const Fl18Host *host);

/* 0x47b321, thiscall, plain `ret`: when dword [self+8] != 0: 0x4c2dfb(this 0x5cf659, self + 8) (thiscall, 1 argument: the ADDRESS of the field, a host pointer here). When p = dword [self+0x14] != 0:
 * 0x51dc6c(p) (cdecl, 1 argument), then dword [self+0x14] = 0; the same for dword [self+0x18]. When the signed word [self+4] != -1: 0x4d3992(i) (cdecl, 1 argument; the original pushes eax whose upper half
 * is left over from `this`, the callee reads a word, so only the low 16 bits are the argument and the port passes the zero-extended word). Finally 0x47b23b(this self) (thiscall, no arguments). */
void m47b321_release(uint8_t *self, const Fl18Host *host);

/* 0x47c049, thiscall, plain `ret`, returns eax. n = signed dword [self+0x2a4] (read again at every use), slots = dword [self+0x18] (an original address, read again at every use). Scan: i = 0 while i < n: when
 * dword [slots + i*4] == 0 the scan stops with "a free slot exists". When none (including n <= 0): r = 0x50cd50() (cdecl, no arguments, the CRT rand), the result is r % n (signed idiv; the slot is NOT marked).
 * When one exists: repeat: r = 0x50cd50(); k = r % n (signed); when dword [slots + k*4] == 0: it is set to 1 and k is the result; otherwise draw again. The loop is unbounded, as in the original (it ends when
 * the host's rand names a free slot). NATIVE REJECTION (not original behaviour): n == 0, or r == INT32_MIN with n == -1, makes the original fault (#DE) at the idiv; this port returns INT32_MIN there (it can
 * never be a remainder) after the one rand call. */
int32_t m47c049_pick_slot(const uint8_t *self, const Fl18Host *host);

/* 0x47b23b, thiscall, plain `ret`: words [self+6] and [self+4] = 0xffff; then dwords at self + 0xc, 0x24, 0x28, 0x2c, 0x30, 0x34, 0x2a8, 8, 0x14, 0x18, 0x1c, 0x20, 0x280, 0x29c, 0x288, 0x2a0, 0x28c, 0x2a4 = 0
 * (in this order). No calls. */
void m47b23b_reset_fields(uint8_t *self);

/* FNS-END */

#ifdef __cplusplus
}
#endif

#endif
