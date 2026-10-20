#ifndef BLACKMOOR_ORIGINAL_METHODS_FL30B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL30B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-30 (batch b): methods of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-29 batch a (see original_methods_fl29a.h, whose conventions
 * apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment,
 * `self` is the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names
 * are descriptive hints, not recovered source names.
 *
 * Calls into original code, the CRT, the imports and the COM-style vtable entries go through Fl18Host.call (callee address, ecx value, stack arguments with
 * args[0] the LAST one pushed = the first argument of a C prototype). An argument that is an address of the original is a 32-bit original address here, as in the
 * original; Fl18Host.resolve turns it into host memory when the function reads or writes through it. Only `self` and the Fl30bWorld table pointers are host
 * pointers. A callee that changes `self` or a global that the function reads again afterwards is not exercised (tasks/fl30b-handoff.md). Word arguments are taken
 * from the low 16 bits of the stack dword. Nothing here claims original source structure. */

typedef struct Fl30bWorld {
    uint8_t *records_5bb5e5;    /* 0x44b26a: records of stride 0x8d, the dword at +0 is the original address of a 4 byte item (kind, flag, word) */
    uint8_t *words_58c959;      /* 0x44b26a: words indexed by the kind byte 0 .. 0x1d */
    uint8_t *floats_58c91d;     /* 0x44b26a: floats indexed by the kind byte 0x1e .. 0x27 (the pointer names the original address 0x58c91d) */
    int16_t word_63a4cd;        /* 0x44b26a, 0x488e9c: the debug flag: a non-zero word turns on the report / the trace output */
    uint32_t value_5bb57b;      /* 0x488e9c: the dword in the allocation-failure report */
    int16_t word_5c39e3;        /* 0x488e9c: the word in the allocation-failure report (sign-extended) */
    int16_t word_639895;        /* 0x4c5b3a: bytes per pixel (a signed word) */
    /*WORLD-NEXT*/
} Fl30bWorld;

/* 0x44b26a, ecx unused, `ret 4`, the stack argument is the word `index` (signed): item = dword [0x5bb5e5 + index*0x8d] (an original address), kind = byte [item], flag = byte [item+1],
 * delta = word [item+2]. kind > 0x27: when the signed word 0x63a4cd is non-zero: 0x50ca3e(0x63888b, 0x549028, kind) (cdecl, 3 arguments) and 0x52139c(0x63888b, 0, 0) (stdcall, 3 arguments).
 * kind <= 0x1d: word w = [0x58c959 + kind*2]; when flag != 0 or signed w == 0x270f: w = delta, else w = w + delta (16-bit wrap). kind 0x1e .. 0x27: float f = [0x58c91d + kind*4]; when flag == 0
 * and f is not equal to 9999.0f (x87 fcomp: an equal or unordered result keeps the other branch): f = (float)(sum in 53-bit precision of (float)(signed delta) and f), otherwise f =
 * (float)(signed delta). In every case then 0x42ba3a(index) (cdecl, 1 argument, the low 16 bits). */
void m44b26a_apply_delta(uint32_t index, const Fl30bWorld *world, const Fl18Host *host);

/* 0x488e9c, thiscall, `ret 0xc`, the stack arguments are the original addresses p0, p1, p2 of three dwords: buf = 0x51dc43(0xaba) (cdecl, 1 argument) is stored to dword [p0]. When buf == 0:
 * 0x50ca3e(0x63888b, 0x54df58, dword 0x5bb57b, sign-extended word 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x54df84, 0x63888b) (thiscall, 2 arguments) and 0x4c97b4(this 0x5cf659).
 * THE ORIGINAL THEN GOES ON AND WRITES THROUGH THE NULL POINTER (rep movsd to address 0): this port returns 1 there (native rejection, not original behaviour). Otherwise: dword [self+0x1c] =
 * dword [self+0x20] = dword [p0] (= buf); the 0xac bytes at q = dword [p1] are copied to buf (dwords, as rep movsd); dword [p1] += 0xac; dword [p2] += 0xac; d = signed word [buf+0x29]; n = (d == 2) ?
 * (word [buf+0x35] - word [buf+0x33] + 1, signed 16-bit) : signed word [buf+0x2b]; n*16 bytes are copied from dword [p1] to buf+0xac (dwords, then bytes) and dword [p1], [p2] += n*16; m = signed word
 * [buf+0xaa] (read after the first copy); m*0x26 bytes are copied from dword [p1] to buf+0x6ec and dword [p1], [p2] += m*0x26; when the signed word 0x63a4cd is non-zero: 0x44a2b7(0x54dfa0) (cdecl, 1
 * argument). Returns 0. NATIVE REJECTIONS (return 1, the effects before the offending copy stay): n or m negative (the original's `shr ecx, 2` of a negative byte count copies about 4 GB), or a copy that
 * would end behind the 0xaba bytes of buf (the original overruns the allocation). Every pointer is an original address resolved through Fl18Host. */
int32_t m488e9c_init_record(uint8_t *self, uint32_t p0, uint32_t p1, uint32_t p2, const Fl30bWorld *world, const Fl18Host *host);

/* 0x4c5b3a, thiscall, `ret 0x14`, the stack arguments are the original addresses `from`, `to` (surface descriptors: dword [s] the pixel base, signed word [s + 0x2f] the pitch), `fr`, `tr` (rectangles of
 * dwords x0, y0, x1, y1) and the value `tag`. When the signed word 0x63a4cd is non-zero and NOT (width and height of fr equal those of tr (x1 - x0, y1 - y0, 32-bit) and from != 0 and to != 0):
 * 0x50ca3e(text, 0x554be8, tag, fr.x0, fr.y0, fr.x1, fr.y1, tr.x0, tr.y0, tr.x1, tr.y1) (cdecl, 11 arguments, text = a local buffer), 0x52139c(text, 0, 0) (stdcall, 3 arguments), 0x4c97b4(this self)
 * and nothing else. Otherwise bpp = signed word 0x639895; p = dword [from] + fr.y0 * pitch(from) + fr.x0 * bpp, q = dword [to] + tr.y0 * pitch(to) + tr.x0 * bpp, rows = fr.y1 - fr.y0 + 1,
 * bytes = (fr.x1 - fr.x0 + 1) * bpp (32-bit); for each of `rows` (signed) rows: for j = 0, 2, 4 ... while j < bytes (signed): v = word [p + j]; when v != word [self + 0x38d0]: word [q + j] = v; then p += pitch(from),
 * q += pitch(to). Returns 0. NATIVE REJECTION (returns 1, nothing done): from or to is 0 on the copy path (the original reads the descriptor at address 0x2f and faults). */
int32_t m4c5b3a_copy_keyed(const uint8_t *self, uint32_t from, uint32_t to, uint32_t fr, uint32_t tr, uint32_t tag, const Fl30bWorld *world, const Fl18Host *host);

/* NEXT-DECL */

#ifdef __cplusplus
}
#endif

#endif
