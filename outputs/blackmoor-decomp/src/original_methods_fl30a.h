#ifndef BLACKMOOR_ORIGINAL_METHODS_FL30A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL30A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-30 (batch a): methods of GAME.EXE (SHA-256 afd337a2...5c45) of 333 to 1,451 bytes ported one to one, in the style of FL-29 batch a (see original_methods_fl29a.h, whose
 * conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment,
 * `self` is the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names are
 * descriptive hints, not recovered source names.
 *
 * Calls into original code, the CRT, the imports and the COM-style vtable entries go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one
 * pushed = the first argument of a C prototype). An argument or a stored pointer that is an address of the original (a record, an object, a vtable) is a 32-bit original address
 * here, as in the original; Fl18Host.resolve turns it into host memory when the function reads or writes through it. Only `self` and the Fl30aWorld table pointers are host
 * pointers. A callee that changes `self`, a record or a global that the function reads again afterwards is not exercised (tasks/fl30a-handoff.md). Word arguments are taken from
 * the low 16 bits of the stack dword, as the original reads them. Nothing here claims original source structure. */

typedef struct Fl30aWorld {
    uint8_t *table_5bb5e5;     /* 0x484ac0, 0x47ef0f, 0x44b3c8, 0x4c36b2: records of stride 0x8d at the original address 0x5bb5e5: dword at +0 (an original address of a record), dword at +0x4d (state); slack for a negative index */
    uint8_t *tab_58c91d;       /* 0x44b3c8: the 0xa0 bytes at the original address 0x58c91d: float (dword) cells at 0x58c91d + 4*k, and, from 0x58c959 (= +0x3c), the word table indexed by a byte */
    int16_t word_63a4cd;       /* the debug flag: a non-zero word turns on the trace output */
} Fl30aWorld;

/* 0x4f61e7, thiscall, `ret 4`, the stack argument is the dword `index`, returns eax: dword [self+0x3c2] = 0x3e8, dword [self+0x3ca] = 0; rec = dword [self+0x3ce] + index*0x5bb (32 bits).
 * 0x4f709c(this self) (thiscall, no arguments) == 0: dword [self+0x3c2] = 0x3ea, dword [self+0x3be] = 0, returns dword [self+0x3be] (0). Otherwise when dword [rec+0x162] == 0 or dword [rec+0x28f] == 0:
 * dword [self+0x3c2] = 0x3ef, dword [self+0x3be] = 0, returns 0. Otherwise dword [rec+0x287] = 1; obj = dword [rec+0x28f]; vt = dword [obj]; r = (the dword [vt + 0x48] called with ecx = vt and the
 * stack argument obj, stdcall: pops 4 bytes) is stored to dword [self+0x3ca]. When r == 0: when the signed word 0x63a4cd is non-zero 0x50ca3e(0x63888b, 0x55e7bc, index, rec + 4) (cdecl, 4 arguments)
 * and 0x44a2b7(0x63888b) (cdecl, 1 argument); returns 1. Otherwise dword [self+0x3c2] = 0x40b, dword [self+0x3be] = 0, returns dword [self+0x3be] (0). */
uint32_t m4f61e7_start_record(uint8_t *self, uint32_t index, const Fl30aWorld *world, const Fl18Host *host);

/* 0x44b3c8, thiscall (ecx is stored and not used), `ret 4`, no result, x87 code at 53-bit precision (control word 0x27f): the stack argument is the word `index` (signed). rec = dword [0x5bb5e5 + index*0x8d]
 * (an original address) and kind = byte [rec]. When kind < 0x1e or kind > 0x27: when the signed word 0x63a4cd is non-zero 0x50ca3e(0x63888b, 0x549054, kind) (cdecl, 3 arguments) and 0x52139c(0x63888b, 0, 0)
 * (stdcall, 3 arguments). Otherwise float [0x58c91d + kind*4] = 0 and, for i = 0 .. 9 (signed word counter): e = byte [rec + 1 + 3i] (e == 0x63: next i); value = signed word [rec + 2 + 3i]; v = by e (a byte, so the
 * `jl` after the 0x63 test is never taken): e > 0x27: e == 0x64 gives v = (float)value, any other e reports (0x50ca3e(0x63888b, 0x549088, e) and 0x52139c(0x63888b, 0, 0)) and gives v = 0; e <= 0x1d: t = signed word
 * [0x58c959 + e*2], t == 0x270f gives v = 0, else v = (float)(((double)(float)value / 100.0) * (double)(float)t); 0x1e <= e <= 0x27: f = float [0x58c91d + e*4], f equal to 9999.0 or unordered (NaN) gives v = 0, else
 * v = (float)(((double)(float)value / 100.0) * (double)f). Then float [0x58c91d + kind*4] = (float)((double)v + (double)float [0x58c91d + kind*4]) (read again at each pass). At the end in every case
 * 0x42ba3a(index) (cdecl, 1 word argument). The two constants 100.0 and 9999.0 are the floats at 0x52cbec and 0x52cbe8 of the original. */
void m44b3c8_sum_kinds(uint32_t index, const Fl30aWorld *world, const Fl18Host *host);

/* 0x484ac0, thiscall, plain `ret`, no result: w = signed word [self+0x26]; rec = dword [0x5bb5e5 + w*0x8d] (an original address; the table is the Fl30aWorld pointer) and the state dword [0x5bb632 + w*0x8d]
 * (the same table, +0x4d). Returns at once (nothing else happens) unless dword [self+0xba7] != 0, byte [rec+0x24] != 0, byte [rec+0x25] == 0, byte [self+0xbb0] == 0, dword [self+0xbac] == 0, the state == 1 and the
 * signed word [self+0xbf9] != 0. Then, when dword [self+0xa92] != 0: h = word [self+0xa9e] and 0x4853b0(this self, h) (thiscall, 1 word argument); otherwise h = ax of 0x4846c2(this self) (thiscall, no arguments),
 * and h == -1 (signed) returns; 0x4853b0(this self, h); dword [self+0xa92] = 1; word [self+0xa9e] = h. In both cases (h read again from [self+0xa9e] in the second case, as a signed word): word [self+0xbc5] =
 * dword [self + h*0x85 + 0x32] - dword [self + h*0x85 + 0x2a] and word [self+0xbc7] = dword [self + h*0x85 + 0x36] - dword [self + h*0x85 + 0x2e] (low 16 bits of the 32-bit differences); then 0x485f12(this self)
 * (thiscall, no arguments) and 0x484935(this self, h) (thiscall, 1 word argument). */
void m484ac0_latch_hit(uint8_t *self, const Fl30aWorld *world, const Fl18Host *host);

/* 0x484762, thiscall, `ret 8`, returns eax (0 or 1), no host calls: the stack arguments are the signed dwords `a` and `b`. r1 = self + a*0x85 + 0x28 and r2 = self + b*0x85 + 0x28 are two records of stride
 * 0x85 (32-bit product); A = r1 + 2 and B = r2 + 2 each hold the dwords x0, y0, x1, y1 at +0, +4, +8, +0xc (all comparisons are signed). The function intersects the rectangles A and B: on the x axis
 * when A.x0 < B.x0: A.x1 < B.x0 gives 0, else rx0 = B.x0; otherwise A.x0 > B.x1 gives 0, else rx0 = A.x0; then rx1 = B.x1 when A.x1 > B.x1, else A.x1. The y axis is the same with the dwords at +4 and +0xc.
 * The result is 0 when any of ry0, ry1, rx0, rx1 is -1 (the initial value; a computed coordinate of -1 is not told apart), else 1. The original also loads the word at r*[0x24 + byte[r*+0x22]*0x18 + 0x14]
 * into two locals that nothing reads (these loads are made here as well, so that a sanitiser sees the reach). */
uint32_t m484762_intersect_rects(const uint8_t *self, uint32_t a, uint32_t b);

#ifdef __cplusplus
}
#endif

#endif
