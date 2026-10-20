#ifndef BLACKMOOR_ORIGINAL_METHODS_FL30D_H
#define BLACKMOOR_ORIGINAL_METHODS_FL30D_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-30 (batch d): methods of GAME.EXE (SHA-256 afd337a2...5c45) of 421 to 751 bytes ported one to one, in the style of FL-29 batch a (see original_methods_fl29a.h,
 * whose conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading
 * comment, `self` is the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked except where a native rejection is named, and the effects
 * keep the order of the original. The names are descriptive hints, not recovered source names.
 *
 * Calls into original code, the CRT and the imports go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first
 * argument of a C prototype). An argument that is an address of the original (a string, a cell, a record) is a 32-bit original address here, as in the original;
 * Fl18Host.resolve turns it into host memory when the function reads or writes through it. Only `self` and the Fl30dWorld pointers are host pointers. A callee that
 * changes `self` or a global that the function reads again afterwards is not exercised (tasks/fl30d-handoff.md). Nothing here claims original source structure. */

#define FL30D_BLOCK_5A1E54_SIZE 0x2540u   /* bytes of the mirror of the globals 0x5a1e54 .. 0x5a4394 that 0x4e2e05 writes */

typedef struct Fl30dWorld {
    uint8_t *block_5a1e54;     /* 0x4e2e05: host mirror of the original addresses 0x5a1e54 .. 0x5a1e54 + FL30D_BLOCK_5A1E54_SIZE (the destination globals) */
    uint8_t byte_63a9e4;       /* 0x4e2e05: first byte compared with the first byte of the string at self + 0x139d */
    uint8_t byte_63a9e8;       /* 0x4e2e05: first byte compared with the first byte of the string at self + 0x13e3 */
    int16_t word_639895;       /* 0x4c2a8d: bytes per pixel (a signed word) */
    uint16_t word_639893;      /* 0x4c2a8d: the word stored at +0x33 of the new record */
    uint8_t *table_5bb5e5;     /* 0x48d3cb: records of stride 0x8d at the original address 0x5bb5e5 (the dword at +0 is read); the caller leaves slack for a negative index */
    uint32_t dword_5b44f0;     /* 0x48d3cb: written and read again */
    uint32_t dword_5b44f4;     /* 0x48d3cb: written and read again */
    uint32_t dword_5d0377;     /* 0x48d3cb: read */
    uint32_t dword_5d162d;     /* 0x48d3cb: written */
    uint32_t dword_5d1631;     /* 0x48d3cb: written */
    uint32_t dword_5d1639;     /* 0x48d3cb: written */
    uint32_t dword_5c39e5;     /* 0x48d3cb: written */
    int16_t word_63a4cd;       /* 0x4f684a: the debug flag: a non-zero signed word turns on the trace output */
} Fl30dWorld;

/* 0x4e2e05, thiscall, plain `ret`, no result. Native rejection (NOT original behaviour): when the signed word [self+0x1471] is negative, or its product with 0x29 does not fit
 * between 0x5a1e62 and the end of the mirror, the original would copy a huge or out-of-table byte count over its globals; the port returns 1 and does nothing at all. Otherwise
 * returns 0 and: dword [0x5a1e54] = dword [0x5a1e58] = 0; the n = word * 0x29 bytes at self + 0x457b are copied to 0x5a1e62 (dwords then bytes); word [0x5a1e5c] = the word;
 * 0x4e3ade(this self) (thiscall, 0 arguments). Then, when byte [self+0x139d] != byte 0x63a9e4: word [0x5a1e5e] = 1, the NUL-terminated strings (NUL included) at self + 0x139d
 * and self + 0x13be are copied to 0x5a2664 and 0x5a2685 (in this order, so a first string over 0x21 bytes is overwritten by the second), word [0x5a26a6] = word [self+0x13df], word
 * [0x5a26a8] = word [self+0x13e1], dword [0x5a26aa] = 0; otherwise word [0x5a1e5e] = 0. Then, when byte [self+0x13e3] != byte 0x63a9e8: word [0x5a1e60] = 1, the string at
 * self + 0x13e3 is copied to 0x5a434c, dword [0x5a4371] = sign-extended word [self+0x1404], word [0x5a436d] = word [self+0x1406], word [0x5a436f] = word [self+0x1408] (in this
 * order, the dword at 0x5a4371 overlaps nothing of the others); otherwise word [0x5a1e60] = 0. */
int32_t m4e2e05_copy_state(uint8_t *self, const Fl30dWorld *world, const Fl18Host *host);

/* 0x4c2a8d, thiscall, `ret 0x10`, returns eax (the original address of the new 0x59 byte record, 0 on failure). Stack arguments (first pushed last): the words w and h (low 16 bits of the
 * stack dwords, signed), the dword `tag` and the original address `name` of a NUL-terminated string. rec = 0x51dc43(0x59) (cdecl, 1 argument); when 0: 0x42639d(this 0x583979, 0x553dbc,
 * name) (thiscall, 2 arguments), 0x4c97b4(this self) and the result is 0. Otherwise the 0x59 bytes at rec are cleared (0x16 dwords and a byte); size = w * (signed word 0x639895) * h (32-bit
 * products); pix = 0x51dc43(size) is stored to dword [rec]; when 0: 0x42639d(this 0x583979, 0x553e14, name), 0x4c97b4(this self) and the result is 0 (rec is not freed). Otherwise, when
 * strlen(name) >= 0x19 the byte name[0x18] is set to 0 (the caller's string is shortened); the string (NUL included) is copied to rec + 8; dword [rec+4] = tag; word [rec+0x21] = 0x59;
 * dword [rec+0x23] = size; dword [rec+0x27] = size + 0x59; word [rec+0x2b] = w; word [rec+0x2d] = h; word [rec+0x2f] = w * bpp (16 bits); word [rec+0x31] = h; word [rec+0x33] = word
 * 0x639893; dword [rec+0x55] = [rec+0x35] = [rec+0x39] = 0; dword [rec+0x3d] = w - 1; dword [rec+0x41] = h - 1; the four dwords at rec + 0x45 = 0; the result is rec. */
uint32_t m4c2a8d_make_record(uint8_t *self, uint32_t w, uint32_t h, uint32_t tag, uint32_t name, const Fl30dWorld *world, const Fl18Host *host);

/* 0x48d3cb, thiscall, `ret 8`, no result; stack arguments: the words `sel` and `k` (low 16 bits of the stack dwords, signed). p = dword [0x5bb5e5 + signed word [self+0x1e] * 0x8d] (an original
 * address). sel == 0x2766: [0x5b44f0] = 9, [0x5b44f4] = 1, [0x5d162d] = [0x5d0377], [0x5d1631] = 0x5b160c + 9 * 32 + 1 * 16, [0x5d1639] = 1, [0x5c39e5] = 0x2766, byte [self+0x24] = 1, word [self+0x27]
 * = 0xffff. sel == 0x2765: [0x5b44f4] = 1, [0x5d162d] = [0x5d0377]; e(a) = dword [p + k * 16 + a] (signed 32-bit, k signed); the first box passes when e(0x207) >= [p+0x2f9] and e(0x20f) <= [p+0x301]
 * and e(0x203) >= [p+0x2f5] and e(0x20b) <= [p+0x2fd] (tested in this order, the first failing test ends the box): then [0x5b44f0] = signed word [p+0x2f3]; otherwise the same four tests against
 * [p+0x30b], [p+0x313], [p+0x307], [p+0x30f]: when they all pass [0x5b44f0] = signed word [p+0x305], else 0. Then [0x5d1631] = 0x5b160c + [0x5b44f0] * 32 + [0x5b44f4] * 16 (32-bit), [0x5d1639] = 1,
 * [0x5c39e5] = 0x2765, byte [self+0x24] = 1 and, when byte [self+0x26] == 0, word [self+0x27] = k. Any other sel: word [self+0x27] = 0xffff. */
void m48d3cb_select_entry(uint8_t *self, uint32_t sel, uint32_t k, Fl30dWorld *world, const Fl18Host *host);

/* 0x4f684a, thiscall, `ret 4`, returns eax; the stack argument is the dword `a0`. dword [self+0x3c2] = 0x3e8, dword [self+0x3ca] = 0; q = dword [self+0x3ce] + a0 * 0x5bb (32-bit; an original address);
 * 0x4f709c(this self) (thiscall, 0 arguments): when it returns 0: dword [self+0x3c2] = 0x3ea, dword [self+0x3be] = 0, result 0. When dword [q+0x28f] == 0: dword [self+0x3c2] = 0x3ef,
 * dword [self+0x3be] = 0, result 0. Otherwise the signed dwords [q+0x13c] and [q+0x140] are each replaced by min(value, 0), and then each by the C conversion (truncation toward zero, as 0x50ce04
 * does: it sets the x87 rounding control to truncate for the FISTP and restores the control word) of max(double(value), -2857.142857142857) (the constant at 0x52e4d8; the original takes the
 * constant when the double compares below or equal to it); [q+0x13c] first. Then hr = the vtable entry dword [vt + 0x3c] (vt = dword [obj], obj = dword [q+0x28f]) called with ecx = obj and
 * the stack arguments (obj, dword [q+0x13c]) (a stdcall callee, pops 8); dword [self+0x3ca] = hr. When hr == 0: when the signed word 0x63a4cd is non-zero: 0x50ca3e(0x63888b, 0x55e8fc, dword
 * [q+0x13c], a0, q + 4) (cdecl, 5 arguments), 0x44a2b7(0x63888b) (cdecl, 1 argument); the result is 1. Otherwise (hr != 0): dword [self+0x3c2] = 0x408, dword [self+0x3be] = 0, result 0. */
uint32_t m4f684a_prepare_entry(uint8_t *self, uint32_t a0, const Fl30dWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
