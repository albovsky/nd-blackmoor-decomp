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
    uint8_t *dwords_585801;     /* 0x42e844: dwords indexed by a signed word (the pointer names the original address 0x585801; the caller leaves slack on both sides) */
    uint32_t value_5bb1ca;      /* 0x42e844: set to 1 when a record leaves state 0 */
    int16_t word_5bb50b;        /* 0x42e844: the key word compared with the entries */
    uint32_t value_5bb1fa;      /* 0x4cbba9: selects the file name format */
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

/* 0x42e844, cdecl, plain `ret`, the stack argument is the word `index` (signed): record r = 0x5bb5e5 + index*0x8d (the dword at r+0 is the original address P of the item list), state = dword [r+0x4d]
 * (0x5bb632). State 0: dword 0x5bb1ca = 1 and state = 1, then as state 1. State 1: dword [r+0x41] = 0; for i = 0 .. (while signed word i < signed word [P+0x28]): the entry at P + i*0x12 whose signed
 * word [+0x2a] equals the signed word 0x5bb50b stops the loop after dword [r+0x41] = 1 and the words [r+0x45], [r+0x47], [r+0x49], [r+0x4b] = the words at entry +0x2c, +0x30, +0x34, +0x38. State 2:
 * byte [r+0x40] = 1, dword [r+0x41] = 0, then for k = 0 .. 9: a = signed word [P + k*4], when a != -1: dword [0x585801 + a*4] = signed word [P + k*4 + 2] (sign-extended); then 0x42ba3a(index) (cdecl, 1
 * argument, the low 16 bits). Any other state: nothing. P is read again at every use. The count [P+0x28] is caller-validated (nothing is bounds checked, as in the original). */
void m42e844_step_record(uint32_t index, Fl30bWorld *world, const Fl18Host *host);

/* 0x411f24, thiscall, `ret 4`, the stack argument is the word `index` (signed): record r = 0x5bb5e5 + index*0x8d, P = dword [r+0] (an original address), Q = P + 0xe7. 0x413187(this self, P, P + 0x12d, 0, 0)
 * (thiscall, 4 arguments), 0x42ba3a(index) (cdecl, 1 argument, the low 16 bits). buf = 0x51dc43(0xaba) (cdecl, 1 argument); when buf == 0: 0x50ca3e(0x63888b, 0x541564, dword 0x5bb57b, sign-extended word
 * 0x5c39e3) (cdecl, 4 arguments), 0x42639d(this 0x583979, 0x5415ac, 0x63888b) (thiscall, 2 arguments), 0x4c97b4(this 0x5cf659) and THE ORIGINAL GOES ON AND WRITES THROUGH THE NULL POINTER: this port returns
 * 1 there (native rejection). Otherwise: the 0xaba bytes at buf are cleared; 0x48945b(this 0x619935, buf, Q + 2) (thiscall, 2 arguments); the NUL-terminated string at the original address 0x5415c8
 * (a 12 byte string in the original's data, resolved through Fl18Host.resolve) is copied to buf with its NUL (dwords, then bytes); 0x5193ca(signed word [P+2] + 1, num, 10) (cdecl, 3 arguments, a number to
 * text conversion that writes into the 8 byte local `num`); the text in num is appended to buf (its NUL included); word [buf+0x23] = word [P], word [buf+0x27] = word [Q]; the 16 bytes at Q + 0x12 go to buf +
 * 0xac; 0x51dc6c(dword [r+0]) (cdecl, 1 argument); dword [r+0] = 0; buf2 = 0x51dc43(0xaba) is stored to dword [r+0]; when buf2 == 0 the same report with 0x5415d8 and 0x54161c (and the original then writes
 * through the null pointer: native rejection, return 1, buf is not freed). Otherwise the 0xaba bytes at buf are copied to buf2, byte [r+0x40] = 0, byte [r-2] = 0x36, byte [r-1] = 1, dword [r+0x4d] = 0 and
 * 0x51dc6c(buf) (cdecl, 1 argument). Returns 0. NATIVE REJECTION (return 1) also when num holds no NUL in its 8 bytes (the original overwrites the local that follows). Every pointer is an original address. */
int32_t m411f24_replace_record(uint8_t *self, uint32_t index, const Fl30bWorld *world, const Fl18Host *host);

/* 0x4cbba9, thiscall, `ret 4`, the stack argument is the original address `path` of a NUL-terminated string. When dword [self+0x1a] != 0: 0x4cbb00(this self) (thiscall, no arguments). When the string is
 * empty: 0x50ca3e(0x63888b, 0x558c48, path) (cdecl; the original's call has 3 arguments) and the failure block. Otherwise 0x50cd72(self+0x1e, 0x639da2 or 0x639dae, 0x639db1, path, 0x558c98 or
 * 0x558c9c) (cdecl, 5 arguments; the first pair when dword 0x5bb1fa != 0), dword [self+0x12a] = 0, file = 0x50d0a9(self+0x1e, 0x558ca0) (cdecl, 2 arguments) stored to dword [self+0x12a]; file == 0:
 * 0x50ca3e(0x63888b, 0x558ca4, self+0x1e) and the failure block. Then 0x4cc70f(this self; self+0x1a, 0x29) (thiscall, 2 arguments: it stores the header address to dword [self+0x1a]);
 * 0x50cf61(h, 0x21, 1, file) and 0x50cf61(h + 0x21, 4, 1, file) (cdecl, 4 arguments; h = dword [self+0x1a], a result other than 1 is a failure: 0x50ca3e(0x63888b, 0x558cf4, self+0x1e) and the failure block);
 * n = dword [h+0x21]; 0x4cc70f(this self; h + 0x25, n*0xd); dword [self+0x12e] = k = 0 and, while signed k < signed dword [h+0x21]: e = dword [h+0x25] + k*0xd is stored to dword [self+0x122]; the reads
 * 0x50cf61(e, 2, 1, file), (e+2, 2, 1, file), (e+4, 1, 1, file), (e+5, 2, 1, file), (e+7, 2, 1, file) must each return 1 (else 0x50ca3e(0x63888b, 0x558d64, k, self+0x1e) and the failure block);
 * m = signed word [e+2]; 0x4cc70f(this self; e + 9, m*0x18); 0x50cf61(dword [e+9], m*0x18, 1, file) must return 1 (else 0x50ca3e(0x63888b, 0x558dc8, k, self+0x1e) and the failure block); k is
 * incremented. When the loop ends: 0x50cee4(dword [self+0x12a]) (cdecl, 1 argument) and the function returns. Failure block: 0x4264e8(this 0x583979, 0x63888b) (thiscall, 1 argument); when the signed word
 * 0x63a4cd is non-zero 0x44a2b7(0x63888b) (cdecl, 1 argument); when dword [self+0x12a] != 0 (for an empty string this is the stale value) 0x50cee4(that dword); 0x4c97b4(this 0x5cf659). Pointers into `self` are
 * host pointers, every other pointer an original address resolved through Fl18Host. The count n is caller-validated (nothing is bounds checked, as in the original). Callee effects on `self` and on the header are
 * made by the host (0x4cc70f stores the allocation addresses). */
void m4cbba9_load_file(uint8_t *self, uint32_t path, const Fl30bWorld *world, const Fl18Host *host);

/* 0x4d214b, cdecl, plain `ret`, returns eax: the stack arguments are `ch` (only the low byte is read, as a signed byte), `obj` (an original address) and `out` (an original address of a word). The 53 byte
 * values listed in the switch of the port (a `jmp [idx*4+table]` through an index table of 0xfe bytes in the original, bytes above 0x7d and every other value go to the default arm) select the
 * word at obj + 0x59 + 2*k (k = 0 .. 52, one arm each): that word is stored to [out] and the result is 1. Every other value: the result is 0 and nothing is stored. */
int32_t m4d214b_lookup_word(uint32_t ch, uint32_t obj, uint32_t out, const Fl18Host *host);

/* NEXT-DECL */

#ifdef __cplusplus
}
#endif

#endif
