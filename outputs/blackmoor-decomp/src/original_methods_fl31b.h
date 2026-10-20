#ifndef BLACKMOOR_ORIGINAL_METHODS_FL31B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL31B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-31 (batch b): small methods of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-29 batch a (see original_methods_fl29a.h, whose conventions
 * apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment, `self` is
 * the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names are descriptive
 * hints, not recovered source names.
 *
 * Calls into original code, the CRT and the imports go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first
 * argument of a C prototype); an import is called by its IAT slot address (0x52a484, 0x52a4b4). An argument that is an address of the original (a destination cell) is a
 * 32-bit original address here, as in the original, and Fl18Host.resolve turns it into host memory when the function reads or writes through it; an address inside `self` or a
 * local of the function is a host pointer (as in FL-18). A callee that changes `self` or a global that the function reads again afterwards is not exercised
 * (tasks/fl31b-handoff.md). Word arguments are taken from the low 16 bits of the stack dword, as the original reads them. */

typedef struct Fl31bWorld {
    const uint8_t *table_5d02cb;   /* 0x420b9e: dwords at the original address 0x5d02cb indexed by a signed word; the caller leaves slack on both sides of index 0 */
    uint32_t dword_5b15da;         /* 0x420b9e: selects the message (non-zero: word [self+0xf75] / string 0x543b60, zero: word [self+0xf73] / string 0x543b88) */
    uint32_t dword_5d03af;         /* 0x420b9e: the dword passed on to 0x4c51a5 */
    uint8_t byte_58321d;           /* 0x4dadff: 1 when the key polled for [self+0x20] is down (bit 15 of the result), else 0 (written) */
    uint8_t byte_58321e;           /* 0x4dadff: the same for [self+0x24] (written) */
    int16_t word_63a4cd;           /* 0x47d1c3, 0x4fc878: the debug flag: a non-zero word turns on the trace output */
} Fl31bWorld;

/* 0x4c946b, thiscall, `ret 4`, the stack argument is the word `index` (signed): 0x4c2dfb(this self, self + 0xc72 + index * 4) (thiscall, 1 argument; the argument is the address
 * of the slot inside self, a host pointer here). Nothing else. */
void m4c946b_call_slot(const uint8_t *self, uint32_t index, const Fl18Host *host);

/* 0x4ee673, thiscall, `ret 4`, the stack argument is the dword `arg`: when dword [self+0x252] != 0: 0x4ef4f0(this self + 0x4b7, arg) (thiscall, 1 argument). */
void m4ee673_forward_if_set(const uint8_t *self, uint32_t arg, const Fl18Host *host);

/* 0x4daeb5, thiscall, `ret 4`, the stack argument is the original address `out` of two dwords, returns `out` in eax: (x, y) = the 8 bytes that the import in slot 0x52a484
 * (stdcall, one argument: the address of a local pair of dwords) stores; dword [self+0x18] = x, dword [self+0x1c] = y, then dword [out] = x and dword [out+4] = y, in this order. */
uint32_t m4daeb5_read_cursor(uint8_t *self, uint32_t out, const Fl18Host *host);

/* 0x4dadff, thiscall, plain `ret`: r = the import in slot 0x52a4b4 (stdcall, 1 argument) called with the dword [self+0x20]; byte 0x58321d = 1 when bit 15 of ax is set (the upper half of
 * eax is not looked at), else 0; then the same for the dword [self+0x24] and byte 0x58321e. The first store happens before the second call. */
void m4dadff_poll_keys(const uint8_t *self, Fl31bWorld *world, const Fl18Host *host);

/* 0x420b9e, thiscall, plain `ret`: when dword 0x5b15da != 0: m = signed word [self+0xf75], s = 0x543b60, else m = signed word [self+0xf73], s = 0x543b88. Then
 * 0x4c51a5(this 0x5cf659, dword [0x5d02cb + m*4], dword 0x5d03af, 0x5b15de, 0x5b15de, s) (thiscall, 5 arguments, `ret 0x14`). */
void m420b9e_report_name(const uint8_t *self, const Fl31bWorld *world, const Fl18Host *host);

/* 0x47d1c3, thiscall (ecx is stored and not used), `ret 8`, the stack arguments are the original address `out` of a dword and the dword `size`: buf = 0x51dc43(size) (cdecl, 1 argument) is
 * stored to dword [out]. When buf == 0: 0x50ca3e(0x63888b, 0x54d168) (cdecl, 2 arguments), 0x4264e8(this 0x583979, 0x63888b) (thiscall, 1 argument), then, when the signed word 0x63a4cd is
 * non-zero, 0x44a2b7(0x63888b) (cdecl, 1 argument), then 0x4c97b4(this 0x5cf659); nothing is cleared. Otherwise `size` bytes (unsigned; dwords for size >> 2, then size & 3 bytes) at the
 * address that is read again from dword [out] are set to zero. */
void m47d1c3_alloc_zeroed(uint32_t out, uint32_t size, const Fl31bWorld *world, const Fl18Host *host);

/* 0x4fc878, thiscall, `ret 4`, the stack argument is the word `index` (the low 16 bits, unsigned): when the signed word 0x63a4cd != 0: 0x50ca3e(0x63888b, 0x560940, index) (cdecl, 3 arguments),
 * 0x44a2b7(0x63888b) (cdecl, 1 argument). Then, when the word [self + index * 0x5bb + 0x132] (unsigned compare) == 1: 0x4f61e7(this 0x5cf1eb, index) (thiscall, 1 argument) and the word
 * [self + index * 0x5bb + 0x132] = 2 (after the call). */
void m4fc878_activate_record(uint8_t *self, uint32_t index, const Fl31bWorld *world, const Fl18Host *host);

/* 0x47d4f7, thiscall, plain `ret`: words [self+0x1d] = [self+0x23] = 0xffff, [self+0x27] = [self+0x25] = 0xfe0c, byte [self+0x57] = 0, and the dwords at self + 0x29, 0x41, 0x31, 0x39, 0x2d,
 * 0x45, 0x35, 0x3d, 0x49, 0x4d, 0x51 = 0 (in this order). */
void m47d4f7_reset_fields(uint8_t *self);

/* 0x47d59b, thiscall, plain `ret`: when dword [self+0x1f] != 0: 0x4c2dfb(this 0x5cf659, self + 0x1f) (thiscall, 1 argument: the address of the dword inside self, a host pointer). For each of the
 * dwords [self+0x49], [self+0x4d], [self+0x51] in this order: when it is non-zero, 0x51dc6c(that value) (cdecl, 1 argument). When the signed word [self+0x23] != -1: 0x4d3992(word [self+0x23])
 * (cdecl, 1 argument, a word: only the low 16 bits are compared; the original pushes edx whose upper half is stale). Finally 0x47d4f7(this self) (thiscall, no arguments; it is a host call
 * here, and its effect on self is not performed by this symbol). */
void m47d59b_release_fields(uint8_t *self, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
