#ifndef BLACKMOOR_ORIGINAL_METHODS_FL33B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL33B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-33 (batch b): methods of GAME.EXE (SHA-256 afd337a2...5c45) of 406 to 745 bytes ported one to one, in the style of FL-30 batch b (see original_methods_fl30b.h,
 * whose conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment,
 * `self` is the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked unless a rejection below says so, and the effects keep the order of the original.
 * The names are descriptive hints, not recovered source names.
 *
 * Calls into original code, the CRT and the imports go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first argument of a C
 * prototype). An argument that is an address of the original is a 32-bit original address here, as in the original; Fl18Host.resolve turns it into host memory when the function reads
 * or writes through it, and so does the address of a string constant or of a global (0x54d158, 0x54388c, ...: the host supplies the bytes of the original's data). Only `self`, the
 * Fl33bWorld table pointers and the locals of a function (a buffer or a struct that a callee fills in) are host pointers. A callee that changes `self` or a global that the function
 * reads again afterwards is not exercised (tasks/fl33b-handoff.md). Word arguments are taken from the low 16 bits of the stack dword. Nothing here claims original source structure. */

typedef struct Fl33bWorld {
    uint8_t *records_5bb5e5;     /* 0x41e3c0, 0x41db40, 0x47df57: records of stride 0x8d at the original address 0x5bb5e5 (the dword at +0 is the original address of the item); the caller leaves slack for a negative index */
    const uint8_t *table_5d1599; /* 0x47df57: dwords of stride 0x4a at the original address 0x5d1599, indexed by the signed word word_6246ff */
    int16_t word_63a4cd;         /* 0x4c51a5, 0x4f5b50, 0x41db40: the debug flag (non-zero: report / trace output; 0x4f5b50 also compares it with 2) */
    int16_t word_639895;         /* 0x4c51a5, 0x4c2898: bytes per pixel (signed word) */
    int16_t word_639893;         /* 0x4c2898: stored into the surface record */
    uint32_t value_5bb202;       /* 0x47d02d, 0x41e3c0: dword flag */
    uint32_t value_5d03b3;       /* 0x47d02d: first argument of 0x448d11 */
    int16_t word_6246f9;         /* 0x47df57: index of the record (signed word) */
    uint8_t byte_6246f8;         /* 0x47df57: enable byte */
    int16_t word_624731;         /* 0x47df57: half of the view size (signed word) */
    int16_t word_6246ff;         /* 0x47df57: index of the dword table 0x5d1599 (signed word) */
    uint32_t value_624705, value_624709, value_62470d, value_624711;     /* 0x47df57: rectangle x0, y0, x1, y1 */
    uint32_t value_624715, value_624719, value_62471d, value_624721;     /* 0x47df57: second rectangle x0, y0, x1, y1 */
    uint32_t value_624729, value_62472d;                                 /* 0x47df57: arguments of 0x4c62f0 / 0x4c6929 */
    uint32_t value_583186, value_58318a;                                 /* 0x47df57: origin x, y (added to the rectangle values) */
    uint32_t value_5cf665, value_5d15e3;                                 /* 0x47df57: arguments of 0x4c5377, 0x4c62f0, 0x4c6929 */
    /*WORLD-NEXT*/
} Fl33bWorld;

/* 0x47d02d, thiscall (ecx stored, not used), `ret 4`, the stack argument is the original address `rec` of a record. When 0x516530(rec, 0x54d14c) (cdecl, 2 arguments) returns non-zero: r =
 * 0x4fb77a(this 0x5c3a67, rec) (thiscall, 1 argument) and 0x4fb2e3(this 0x5c3a67, (r & 0xffff0000) | word [rec+0x21]) (thiscall, 1 argument; the original pushes eax whose upper half is the left-over of r).
 * Then, only when dword 0x5bb202 != 0: t = 0; when the string at rec+0x31 is not empty: t = 0x423259(this 0x619a6b, rec+0x31) (thiscall, 1 argument); when t != 0 and strlen(t) <= 0x9c40 the string at t
 * (with its NUL) is copied into the 0x68 byte local buffer and the 7 bytes at the original addresses 0x54d158 (dword), 0x54d15c (word), 0x54d15e (byte) are stored over its NUL (so the buffer holds the
 * string, then those 7 bytes), then 0x448d11(this 0x619a05, dword 0x5d03b3, buffer, -1, 0) (thiscall, 4 arguments; the buffer is a host pointer); when strlen(t) > 0x9c40 t is cleared. When t == 0 (the
 * string at rec+0x31 was empty, 0x423259 returned 0 or the string was too long) and the string at rec+0x52 is not empty: the same with that string, the 7 bytes at 0x54d160 (dword), 0x54d164 (word) and
 * 0x54d166 (byte) and the same call 0x448d11. Returns 0. NATIVE REJECTION (returns 1; the calls made so far stay): a string of 0x62 bytes or more (length + 7 > 0x68) that would be copied into the local
 * buffer: the original overruns its stack frame (the buffer ends at [ebp-4], the pointer `t`). Strings are NUL terminated (nothing is bounds checked, as in the original). */
int32_t m47d02d_show_names(uint32_t rec, const Fl33bWorld *world, const Fl18Host *host);

/* 0x4c51a5, thiscall, `ret 0x14`, the stack arguments are the original addresses `a`, `b` (surface descriptors: dword [s] the pixel base, signed word [s + 0x2f] the pitch), `fr`, `tr` (rectangles of dwords
 * x0, y0, x1, y1) and the value `tag`. When the signed word 0x63a4cd is non-zero and NOT (width and height of fr equal those of tr (x1 - x0, y1 - y0, 32-bit) and a != 0 and b != 0): 0x50ca3e(text, 0x554848,
 * tag, fr.x0, fr.y0, fr.x1, fr.y1, tr.x0, tr.y0, tr.x1, tr.y1) (cdecl, 11 arguments, text = a local buffer), 0x52139c(text, 0, 0) (stdcall, 3 arguments), 0x4c97b4(this self) and nothing else. Otherwise
 * bpp = signed word 0x639895; p = dword [a] + fr.y0 * pitch(a) + fr.x0 * bpp, q = dword [b] + tr.y0 * pitch(b) + tr.x0 * bpp, rows = fr.y1 - fr.y0 + 1, bytes = (fr.x1 - fr.x0 + 1) * bpp (32-bit); for each of
 * `rows` (signed) rows: `bytes` bytes (dwords, then the rest as bytes, as rep movsd / rep movsb) are copied from p to q, then p += pitch(a), q += pitch(b) (the pitch words are read again). Returns 0.
 * NATIVE REJECTIONS (return 1, nothing done): a or b is 0 on the copy path (the original reads the descriptor at address 0x2f and faults), and bytes negative with rows > 0 (the original's `shr ecx, 2` of a
 * negative count copies about 4 GB). */
int32_t m4c51a5_copy_rows(uint8_t *self, uint32_t a, uint32_t b, uint32_t fr, uint32_t tr, uint32_t tag, const Fl33bWorld *world, const Fl18Host *host);

/* 0x47df57, cdecl, plain `ret`, no arguments (the original has no this). item = dword [0x5bb5e5 + signed word 0x6246f9 * 0x8d] (read first). When byte 0x6246f8 == 0: nothing more. Otherwise
 * size = (signed word 0x624731) * 2; width = dword 0x62470d - dword 0x624705 + 1, height = dword 0x624711 - dword 0x624709 + 1 (32-bit); the rectangle R1 = (dword 0x624715 + dword 0x583186, dword 0x624719 +
 * dword 0x58318a, dword 0x62471d + dword 0x583186, dword 0x624721 + dword 0x58318a) is built and 0x4c5377(this 0x5cf659, dword 0x5d15e3, dword 0x5cf665, 0x624715, &R1, 0x54d3ec) (thiscall, 5 arguments; &R1 is
 * a host pointer to the 16 bytes) is called; then R2 = (dword 0x624705 + dword 0x583186, dword 0x624709 + dword 0x58318a, dword 0x62470d + dword 0x583186, dword 0x624711 + dword 0x58318a) and the offsets
 * P = (0, 0, size - 1, size - 1); when width < size (signed) and dword 0x624705 == 0: P.x = size - width; when height < size and dword 0x624709 == 0: P.y = size - height. T = dword [0x5d1599 + signed word
 * 0x6246ff * 0x4a]. When byte [item + 0x22] != 0: 0x4c62f0(this 0x5cf659, T, dword 0x5d15e3, dword 0x5cf665, dword 0x624729, 0x624705, 0x624705, &R2, &P, 0x54d408) (thiscall, 9 arguments); otherwise
 * 0x4c6929(this 0x5cf659, T, dword 0x5cf665, dword 0x62472d, 0x624705, &R2, &P, 0x54d434) (thiscall, 7 arguments). All compares are signed. */
void m47df57_update_view(const Fl33bWorld *world, const Fl18Host *host);

/* 0x4c2898, thiscall, `ret 0x14`, the stack arguments are `pp` (the original address of a dword cell), the words `w` and `h`, the dword `extra` and `name` (the original address of a NUL terminated string). When
 * dword [pp] != 0: 0x42639d(this 0x583979, 0x553c94, name) (thiscall, 2 arguments), 0x4c97b4(this self) and return. Otherwise p = 0x51dc43(0x59) (cdecl, 1 argument) is stored to dword [pp]; p == 0: 0x42639d(this
 * 0x583979, 0x553d10, name), 0x4c97b4(this self), return. Otherwise the 0x59 bytes at p are cleared (rep stosd 0x16 dwords, one byte); size = signed word w * signed word 0x639895 * signed word h (32-bit);
 * q = 0x51dc43(size) is stored to dword [p] (p read again from [pp]); q == 0: 0x42639d(this 0x583979, 0x553d68, name), 0x4c97b4(this self), return. Otherwise when strlen(name) >= 0x19 byte [name+0x18] = 0; the
 * string at name (with its NUL, as rep movsd / movsb) is copied to p + 8; dword [p+4] = extra; word [p+0x21] = 0x59; dword [p+0x23] = size; dword [p+0x27] = size + 0x59; word [p+0x2b] = w; word [p+0x2d] = h;
 * word [p+0x2f] = low 16 bits of w * bpp; word [p+0x31] = h; word [p+0x33] = word 0x639893; dwords [p+0x55], [p+0x35], [p+0x39] = 0; dword [p+0x3d] = signed w - 1; dword [p+0x41] = signed h - 1; the four dwords
 * at p + 0x45 .. p + 0x54 = 0. [pp] is read again at every use. Returns nothing observable. */
void m4c2898_alloc_surface(uint8_t *self, uint32_t pp, uint32_t w, uint32_t h, uint32_t extra, uint32_t name, const Fl33bWorld *world, const Fl18Host *host);

/* 0x4f594d, thiscall, `ret 0xc`, returns eax: the stack arguments are `idx`, `buf` (an original address) and `len` (dword). rec = dword [self+0x3ce] + idx * 0x5bb (an original address), item = rec + 0x18a. ok = 1;
 * k = (len == dword [rec+0x15e] and buf == 0) ? 2 : 0. The local struct S of 7 dwords is cleared, S[0] = buf, S[1] = len, S[6] = k. 0x4f5e95(this self, dword [rec+0x28f], &S) (thiscall, 2 arguments; &S is a host
 * pointer: the callee fills S[2..4]) == 0: dword [self+0x3c2] = 0x405, return 0. When S[3] != len or S[4] != 0: 0x4f5e35(this self, dword [rec+0x28f], &S), dword [self+0x3c2] = 0x406, return 0. n = 0x4f5b50(this
 * self, idx, S[2], len) (thiscall, 3 arguments). n < 0 (signed): ok = 0. n < len: when dword [rec+0x130] == 0: len -= n, n = 0x4f5b50(this self, idx, S[2] + n, len); n < 0: ok = 0; n < len: dword
 * [self+0x3c2] = 0x3ec, ok = 0. Otherwise (dword [rec+0x130] != 0) when dword [item+0x10] != -1: len - n bytes at S[2] + n are filled (rep stosd, then stosb) with 0x80 when the word [rec+0x2ed] == 8 and with 0
 * otherwise, then dword [item+0xc] = 1. Finally 0x4f5e35(this self, dword [rec+0x28f], &S) == 0: dword [self+0x3c2] = 0x407, ok = 0. Returns ok. Every pointer except self and S is an original address. */
int32_t m4f594d_read_checked(uint8_t *self, uint32_t idx, uint32_t buf, uint32_t len, const Fl33bWorld *world, const Fl18Host *host);

/* 0x41e3c0, thiscall, `ret 4`, the stack argument is the word `idx` (signed). The callee object is self + 0xf1d (a host pointer here, this of the calls): 0x51e745(this) (thiscall, no arguments), buf =
 * 0x51ea75(this, 0x3a98) (thiscall, 1 argument; an original address); the 0x3a98 bytes at buf are cleared; item = dword [0x5bb5e5 + idx*0x8d]; off (a signed 16-bit offset) = 0. Then the NUL terminated string at item
 * + 0x16b is copied to buf (without its NUL), off += its length; when dword 0x5bb202 != 0: the dword at the original address 0x54388c is stored over the NUL of the text at buf + off and off += strlen of the string
 * at 0x543890. Then for i = 0 while signed word i < signed word [self+0xf21]: when i != 0 the dword at 0x543894 is stored over the NUL of the text at buf + off and off += strlen(0x543898); text =
 * 0x50ca3e(buf2, 0x54389c, i, i, self + i*0x3a + 0x7d9) (cdecl, 5 arguments: buf2 is a host pointer to a local buffer of 0x34 bytes that the callee fills, the last is a host pointer into self); text is appended
 * (strcat, with its NUL) to the text at buf + off and off += strlen(text); then A = dword [self + i*4 + 0xea5] (an original address of a NUL terminated string): its bytes (without NUL) are copied to
 * buf + off and, with A read again, off += strlen(A). After the loop the dword at 0x5438b0 is stored over the NUL of the text at buf + off. Finally 0x51eac4(this, -1) (thiscall, 1 argument). The offset
 * and the loop counter are 16-bit. NATIVE REJECTIONS (return 1; the calls and stores made so far stay): buf == 0 (the original's `rep stosd` faults at address 0, after the two calls); a store that would
 * leave the 0x3a98 bytes of buf, a text without NUL in buf, or a callee text of 0x34 bytes or more without a NUL (the original overruns the allocation or its stack frame). Returns 0. */
int32_t m41e3c0_build_text(uint8_t *self, uint32_t idx, const Fl33bWorld *world, const Fl18Host *host);

/* 0x4f5b50, thiscall, `ret 0xc`, returns eax: the stack arguments are `idx` (dword), `buf` (an original address) and `len` (dword). dword [self+0x3c2] = 0x3e8; rec = dword [self+0x3ce] + idx * 0x5bb, mode = signed word
 * [rec+0x126]. Mode 2: s = rec + 0x2f1, (a, b) = (1, 0) when the word [rec+0x2ed] == 8 else (2, 1); when signed word 0x63a4cd == 2: 0x50ca3e(0x63888b, 0x55e63c, idx) (cdecl, 3 arguments) and 0x44a2b7(0x63888b)
 * (cdecl, 1 argument). pos = 0, go = 1, flag = 0 (a local dword): while pos < len (signed) and go != 0: go = 0x4fe2d0(s, buf + pos, len - pos, 0, a, b, &flag) (cdecl, 7 arguments; &flag is a host pointer the callee
 * fills in); when go < 0 or flag != 0: when the word 0x63a4cd != 0: 0x50ca3e(0x63888b, 0x55e680, rec + 4, go) and 0x44a2b7(0x63888b); dword [self+0x3c2] = 0x3ec and return -1; otherwise when go == 0:
 * 0x4fdc70(s, 0, 0) (cdecl, 3 arguments); pos += go. After the loop, when the word 0x63a4cd == 2: 0x50ca3e(0x63888b, 0x55e6c8, idx, pos) and 0x44a2b7(0x63888b). Returns pos. Mode 1: n = 0x50cf61(buf, 1, len,
 * f) (cdecl, 4 arguments, f = dword [rec+0x156]); n != len: when dword [f+0xc] has bit 0x10 set and bit 0x20 clear: 0x50ce2b(f, 0x1e, 0) (cdecl, 3 arguments) and n is returned; otherwise (bit 0x20 set, or bit 0x10 clear) when the word 0x63a4cd is
 * non-zero: 0x50ca3e(0x63888b, 0x55e718, rec + 4) and 0x44a2b7(0x63888b); dword [self+0x3c2] = 0x3ec and return -1. Any other mode: when the word 0x63a4cd is non-zero 0x52139c(0x55e754, 0, 0) (stdcall, 3
 * arguments); dword [self+0x3c2] = 0x3f9 and return -1. Every pointer except self and flag is an original address. */
int32_t m4f5b50_read_block(uint8_t *self, uint32_t idx, uint32_t buf, uint32_t len, const Fl33bWorld *world, const Fl18Host *host);

/* 0x41db40, thiscall (ecx stored, not used), `ret 4`, the stack argument is the word `idx` (signed). When the signed word 0x63a4cd is non-zero: 0x44a2b7(0x5437a8) (cdecl, 1 argument). p = dword [0x5bb5e5 +
 * idx*0x8d] (an original address); p == 0: return (also past the closing trace). Three tables hanging off p, each (count word, pointer dword, stride, offset of the pointer in each entry): (word [p+0x793], dword
 * [p+0x795], 0x1d1), (word [p+0x799], dword [p+0x79b], 0x1c), (word [p+0x79f], dword [p+0x7a1], 0xa); for each, when the signed count word > 0 and the pointer != 0: for i = 0 while signed word i < the count word (read
 * again): the entry e = pointer + i*stride (the pointer is read again); when signed word [e] > 0 and dword [e+2] != 0: 0x51dc6c(dword [e+2]) (cdecl, 1 argument); after the loop 0x51dc6c(pointer) and the pointer
 * dword is set to 0. Then 0x51dc6c(dword [0x5bb5e5 + idx*0x8d]) (read again) and that dword = 0; when the word 0x63a4cd is non-zero: 0x44a2b7(0x5437d4). Nothing is returned. */
void m41db40_free_record(uint32_t idx, const Fl33bWorld *world, const Fl18Host *host);

/* NEXT-DECL */

#ifdef __cplusplus
}
#endif

#endif
