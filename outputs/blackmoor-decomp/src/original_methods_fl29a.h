#ifndef BLACKMOOR_ORIGINAL_METHODS_FL29A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL29A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-29 (batch a): small methods of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-28 batch b (see original_methods_fl28b.h, whose
 * conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its
 * leading comment, `self` is the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the
 * original. The names are descriptive hints, not recovered source names.
 *
 * Calls into original code, the CRT, the imports and the COM-style vtable entries go through Fl18Host.call (callee address, ecx value, stack arguments with
 * args[0] the LAST one pushed = the first argument of a C prototype). An argument that is an address of the original (a surface, a rectangle, a descriptor, a
 * string, a vtable) is a 32-bit original address here, as in the original; Fl18Host.resolve turns it into host memory when the function reads or writes through it.
 * Only `self` and the Fl29aWorld table pointers are host pointers. A callee that changes `self` or a global that the function reads again afterwards is not
 * exercised (tasks/fl29a-handoff.md). Word arguments are taken from the low 16 bits of the stack dword, as the original reads them (`movsx eax, word ptr [ebp+8]`).
 * Nothing here claims original source structure. */

typedef struct Fl29aWorld {
    uint8_t *table_5d15a5;     /* 0x4d39f9, 0x4d3992: records of stride 0x4a at the original address 0x5d15a5 (dword at +0 and at +4); the caller leaves slack below it for a negative index */
    uint8_t *words_5afbda;     /* 0x4c92c5: words at 0x5afbda indexed by a signed word */
    uint8_t *dwords_5d032f;    /* 0x4c92c5: dwords at 0x5d032f indexed by a signed word */
    int16_t word_639895;       /* 0x4c9340: bytes per pixel (a signed word) */
    uint32_t value_5bb57b;     /* 0x4895cc: the dword in the allocation-failure report */
    int16_t word_5c39e3;       /* 0x4895cc: the word in the allocation-failure report (sign-extended) */
    int16_t word_63a4cd;       /* 0x4895cc: the debug flag: a non-zero word turns on the trace output */
} Fl29aWorld;

/* 0x4d39f9, cdecl, plain `ret`, returns ax: the first i = 0x18 .. 0x3f (a word) whose dword [0x5d15a9 + i*0x4a] is 0. When there is none: 0x52139c(0x55a448, 0, 0) (stdcall, 3
 * arguments) and 0x4c97b4(this 0x5cf659), and ax = 0xffff. The upper half of eax is stale in the original and not part of the result. */
int32_t m4d39f9_find_free_entry(const Fl29aWorld *world, const Fl18Host *host);

/* 0x4c4202, thiscall, `ret 0xc` (the third stack dword is not used), the first two stack dwords are `obj` and `arg`: when obj == dword [self+0xc] nothing happens.
 * Otherwise hr = (the vtable entry dword [vtable + 0x80], vtable = dword [obj]) called with ecx = vtable and the stack arguments (obj, arg) (a stdcall callee: it pops 8 bytes);
 * when hr != 0: text = 0x4c88c7(this self, hr) (thiscall, 1 argument), 0x42639d(this 0x583979, 0x5543f0, text) (thiscall, 2 arguments), 0x4c97b4(this self). */
void m4c4202_check_vtable_call(const uint8_t *self, uint32_t obj, uint32_t arg, const Fl18Host *host);

/* 0x4c948f, thiscall, plain `ret`, returns ax: the first i = 0 .. 0x17 (a word) whose dword [self + 0xc72 + i*4] is 0. When there is none: 0x52139c(0x557ae4, 0, 0) (stdcall, 3
 * arguments) and 0x4c97b4(this self), and ax = 0xffff. */
int32_t m4c948f_find_free_slot(const uint8_t *self, const Fl18Host *host);

/* 0x4d3992, cdecl, plain `ret`, the stack argument is the word `index` (signed): when index < 0 or index >= 0x58: 0x50ca3e(0x63888b, 0x55a400, sign-extended index) (cdecl, 3 arguments),
 * 0x52139c(0x63888b, 0, 0) (stdcall, 3 arguments) and 0x4c97b4(this 0x5cf659); the function goes on. Then dword [0x5d15a5 + index*0x4a] = 0 and dword [0x5d15a9 + index*0x4a] = 0
 * (also for an index the report was made about: nothing is bounds checked). */
void m4d3992_clear_entry(uint32_t index, const Fl29aWorld *world, const Fl18Host *host);

/* 0x4c92c5, thiscall (ecx is stored and not used), `ret 4`, the stack argument is the word `index` (signed): when dword [0x5d032f + index*4] != 0: word [0x5afbda + index*2] -= 1
 * (16-bit wrap), and when the signed word is then 0: 0x4c2dfb(this 0x5cf659, 0x5d032f + index*4) (thiscall, 1 argument: the ORIGINAL ADDRESS of the dword). Then, in every case, the
 * signed word [0x5afbda + index*2] < 0 is set to 0. */
void m4c92c5_count_down(uint32_t index, const Fl29aWorld *world, const Fl18Host *host);

/* 0x4c9340, thiscall, `ret 8`, returns ax, the stack arguments are the original addresses `surface` and `rect` (rect: dwords x0, y0, x1, y1 at +0, +4, +8, +0xc): when surface == 0 the
 * result is 0. Otherwise pitch = signed word [surface + 0x2f], bpp = signed word 0x639895, p = dword [surface] + y0*pitch + x0*bpp, rows = y1 - y0 + 1, bytes = (x1 - x0 + 1)*bpp (32-bit);
 * for each of `rows` (signed) rows: for j = 0, 2, 4 ... while j < bytes (signed): v = word [p + j]; if v != word [self + 0x38d0] the result is v; p += pitch after each row. When no word
 * differs the result is 0. The upper half of eax is stale in the original and not part of the result. */
int32_t m4c9340_scan_surface(const uint8_t *self, uint32_t surface, uint32_t rect, const Fl29aWorld *world, const Fl18Host *host);

/* 0x4c46d1, thiscall, `ret 0x10`, the stack arguments are the original address `surface` and the three bytes (the low bytes of the stack dwords) r, g, b: r &= byte [self+0x38c6],
 * g &= byte [self+0x38c5], b &= byte [self+0x38c4]; each is then shifted left by one, as a byte, when the byte [self+0x38ca] (r), [self+0x38c9] (g), [self+0x38c8] (b) is not 5. The
 * colour word is (r << byte[self+0x38c2]) | (g << byte[self+0x38c1]) | (b << byte[self+0x38c0]) (32-bit shifts, count taken modulo 32 as the CPU does), truncated to 16 bits; it is
 * stored to the words [dword[surface] + i*2] for i = 0 while i < (signed word [surface+0x2b]) * (signed word [surface+0x2d]) (32-bit signed). The pixel buffer address is read again for
 * every pixel, like the sizes. */
void m4c46d1_fill_surface(const uint8_t *self, uint32_t surface, uint32_t r, uint32_t g, uint32_t b, const Fl18Host *host);

/* 0x4cb9d1, thiscall, plain `ret`: s = dword [self+0x12]; when s == 0 nothing. Otherwise dword [self+0x15c] = 0x4c0c69(this 0x637fcf) (thiscall, no arguments); when that is 0 stop. Then
 * dword [self+0x132] = 0 and, while the dword [self+0x132] (signed) < signed word [dword[self+0x12] + 2]: e = dword [dword[self+0x12] + 9] + [self+0x132]*0x18 is stored to [self+0x126],
 * and with o = dword [self+0x15c]: [e+4] += [o+0x12], [e+0xc] += [o+0x12], [e+8] += [o+0x16], [e+0x10] += [o+0x16] (each read and written through [self+0x126], in this order);
 * the counter [self+0x132] is incremented after each pass. Every pointer is an original address resolved through Fl18Host. */
void m4cb9d1_relocate_entries(uint8_t *self, const Fl18Host *host);

/* 0x4895cc, thiscall, `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: buf = 0x51dc43(0xaba) (cdecl, 1 argument) is stored to dword [p0]. When buf == 0:
 * 0x50ca3e(0x63888b, 0x54e064, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x54e090, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this
 * 0x5cf659). THE ORIGINAL THEN GOES ON AND WRITES THROUGH THE NULL POINTER (rep stosd at address 0): this port returns 1 there (native rejection, not original behaviour; the oracle
 * runs the original with a zero page mapped so that the reporting block is executed). Otherwise (returns 0): the 0xaba bytes at buf are cleared; dword [self+0x1c] = [self+0x20] = dword [p0];
 * q = dword [p1]; 0x48945b(this self, dword [self+0x1c], q + 0x25) (thiscall, 2 arguments); the NUL-terminated string at q (including the NUL) is copied to dword [self+0x20] (dwords, then
 * bytes; a string longer than the buffer overruns it, as in the original); word [[self+0x20] + 0x23] = word [q+0x21], then word [[self+0x20] + 0x27] = word [q+0x23] (read after the copy
 * and in this order); the four dwords at q+0x35 are copied to dword[self+0x1c] + 0xac; dword [p1] += 0x45, dword [p2] += 0x45; when the signed word 0x63a4cd is non-zero:
 * 0x44a2b7(0x54e0ac) (cdecl, 1 argument). */
int32_t m4895cc_init_buffer(uint8_t *self, uint32_t p0, uint32_t p1, uint32_t p2, const Fl29aWorld *world, const Fl18Host *host);

/* 0x4c3efb, thiscall, `ret 0x10`, the stack arguments are the original addresses `surface`, `rect` (0 or a rectangle of dwords x0, y0, x1, y1), `desc` and the value `tag`; no result is used.
 * When surface == dword [self+0xc]: desc[0x24] = [self+0x14] and desc[8], desc[0xc] = signed words [self+0x1a], [self+0x18] when rect == 0, else desc[0x24] = [self+0x14] + y0*[self+0x1c] +
 * x0*(signed word [self+0x20]), desc[8] = y1 - y0 + 1, desc[0xc] = x1 - x0 + 1; then desc[0] = 0x6c, desc[4] = [self+0x42], desc[0x10] = [self+0x1c] and the eight dwords at self+0x22 to
 * desc+0x48. Otherwise desc[0] = 0x6c, then repeat: hr = (vtable entry dword [vt + 0x64], vt = dword [surface]) called with the stack arguments (surface, rect, desc, 0x800, 0) (stdcall, pops 20
 * bytes; ecx is not an argument); hr == 0 ends the function; 0x887601c2: 0x4c4dc3(this self) and repeat; 0x8876021c: repeat; any other: text = 0x4c88c7(this self, hr),
 * 0x50ca3e(0x63888b, 0x554368, tag, text) (cdecl, 4 arguments), 0x4264e8(this 0x583979, 0x63888b) and repeat. */
void m4c3efb_lock_surface(const uint8_t *self, uint32_t surface, uint32_t rect, uint32_t desc, uint32_t tag, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
