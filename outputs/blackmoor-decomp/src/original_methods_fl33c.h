#ifndef BLACKMOOR_ORIGINAL_METHODS_FL33C_H
#define BLACKMOOR_ORIGINAL_METHODS_FL33C_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-33 (batch c): six pending functions of GAME.EXE (SHA-256 afd337a2...5c45) around 0x4c6929, 0x416af3, 0x4db38a, 0x4d2c20, 0x4f379c and 0x4c36b2 ported one to one, in the style of FL-33a (see
 * original_methods_fl33a.h, whose conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading
 * comment, `self` is the original object (ecx) as raw bytes at the original offsets, and the effects keep the order of the original. The names are descriptive hints, not recovered source names.
 *
 * Calls into original code, the CRT and the imports go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first argument of a C prototype). A dword
 * that holds an address of the original is a 32-bit original address and goes through Fl18Host.resolve; the address of a local that the original passes to a callee is a host pointer. Strings and tables
 * that live in the original's data are read through Fl18Host.resolve / the world pointers; no original bytes are in this file. A callee that changes `self` or a global that the function reads again
 * afterwards is not exercised (tasks/fl33c-handoff.md). Functions that can fault, run endlessly or read an indeterminate stack slot in the original return an int status: 0 = ran as the original,
 * 1 = the port stops where the original would fault / never finish / use garbage (documented per function; the host must not rely on anything after a 1).
 * Nothing here claims original source structure. */

typedef struct Fl33cWorld {
    int16_t word_63a4cd, word_639895;     /* 0x4c6929 (both), 0x4d2c20 .. */
    uint32_t value_5d16cd, value_5d1683, value_583204, value_583186, value_58318a, value_58318e, value_583192;    /* 0x4db38a */
    uint32_t value_5b44f0, value_5b44f4, value_583106, value_583102, value_5c3a53, value_5c3a57;                /* 0x4db38a */
    int16_t word_5d2f0d, word_5d2f0f;                                                                           /* 0x4db38a */
    const uint8_t *table_5b3790;     /* 0x4db38a: pairs of signed words (x extent at +0, y extent at +2) at 0x5b3790, indexed by (value_5b44f4 << 2) + value_5b44f0 * 8 (32-bit; slack below it) */
    const uint8_t *table_5b30cc;     /* 0x4db38a: dwords at 0x5b30cc (+0) and 0x5b30d0 (+4), indexed by (value_5b44f0 << 4) + value_5b44f4 * 8 (32-bit; slack below it) */
    uint32_t value_63a8e0, value_63a8e4, value_63a8e8, value_63a8ec;                                            /* 0x4d2c20 */
    /* WORLD-END */
} Fl33cWorld;

/* 0x4c6929, thiscall, `ret 0x1c`, stack arguments a ([ebp+8], an original address of an object), b ([ebp+0xc]), c ([ebp+0x10], an original address of a byte mask), r1 ([ebp+0x14]), r2 ([ebp+0x18]),
 * r3 ([ebp+0x1c]) (original addresses of four dwords each, unaligned: x0 y0 x1 y1) and d ([ebp+0x20]).
 * When the signed word 0x63a4cd != 0 (a debug check, a word compare): dx1 = r1.x1 - r1.x0, dy1 = r1.y1 - r1.y0, dx2, dy2 likewise for r2 (32-bit); when dx1 != dx2 or dy1 != dy2: 0x50ca3e(msg, 0x555054, d, r1.x0,
 * r1.y0, r1.x1, r1.y1, r2.x0, r2.y0, r2.x1, r2.y1) (cdecl, 11 arguments, msg = a 0x120-byte local, a host pointer), 0x52139c(msg, 0, 0) (stdcall, 3 arguments) and 0x4c97b4(this self); else, when a == 0 or b == 0: the
 * same three calls with the format 0x5550e8; either way nothing else happens. Otherwise (and for equal sizes with a, b != 0): 0x4c4067(this self, b, r2, desc, d, 0x20) (thiscall, 5 arguments; desc = a 0x80-byte
 * local, a host pointer; the callee stores dword v1 at desc+0x10 and dword v2 at desc+0x24). hw = signed word [a+0x2f] (unaligned); sstep = hw / 2 (C division, truncated toward zero), dstep = v1 / 2;
 * src = dword [a] + r1.y0 * hw + r1.x0 * (signed word 0x639895), mask = c + r3.y0 * (r3.x1 + 1) + r3.x0, dst = v2 (all 32-bit original addresses); rows = r1.y1 - r1.y0 + 1, cols = r1.x1 - r1.x0 + 1 (32-bit, SIGNED
 * compares): for each row (while the row number < rows) for each column (while the column number < cols): when the byte at mask + column is non-zero, the word at dst + 2 * column = the word at src + 2 * column;
 * after each row src += 2 * sstep, dst += 2 * dstep, mask += r3.x1 + 1. Then 0x4c4202(this self, b, r2, 0x555164) (thiscall, 3 arguments) and, when b == dword [self+0xc], 0x4c952f(this self, r2) (thiscall, 1
 * argument). The local desc is zero filled here (the original leaves stack garbage there except the two dwords the callee stores). With the debug word zero and a == 0 the original reads the word at address 0x2f
 * after the first callee and faults: the port returns 1 right after the call to 0x4c4067 and changes nothing else. The pointers (a, c, r1, r2, r3 and the three addresses above) must be original addresses that
 * Fl18Host.resolve can resolve, like the original dereferences them. */
int m4c6929_copy_masked(uint8_t *self, uint32_t a, uint32_t b, uint32_t c, uint32_t r1, uint32_t r2, uint32_t r3, uint32_t d, const Fl33cWorld *world, const Fl18Host *host);

/* 0x416af3, thiscall (ecx is stored and never read), `ret 0x18`, stack arguments hdr ([ebp+8]), out ([ebp+0xc]), size ([ebp+0x10]), stream ([ebp+0x14]), base ([ebp+0x18]) and flag ([ebp+0x1c]), all 32-bit
 * original values (addresses of the original, resolved through Fl18Host.resolve; unaligned fields are read as such). count = dword [hdr+0xa] (SIGNED compares below), kind = byte [hdr+0xe]. The stream is a
 * list of ops at byte offsets idx (idx starts at 0, 32-bit arithmetic, `p` = stream + idx at the op); the opcode byte is [p]:
 *  0x20: idx += 9; n = dword [p+5]; the n * 2 bytes (32-bit; `shl 1`) at stream + idx are copied to out + dword [p+1] * 2 (dwords first, then bytes); idx += n * 2 (n read again). Kind 2 also calls
 *        0x4c7314(this 0x5cf659, out + dword [p+1] * 2, dword [p+5] * 2) (thiscall, 2 arguments) between the copy and the idx update.
 *  0x40: idx += 0xb; 0x43ef77(this 0x5d2f2d, out + dword [p+3] * 2, word [p+1], dword [p+7]) (thiscall, 3 arguments; the word is pushed from cx with a stale upper half, the port passes it zero extended);
 *        kind 2 also calls 0x4c7314(this 0x5cf659, out + dword [p+3] * 2, dword [p+7] * 2).
 *  0x80: m = byte [p+1] (zero extended); idx += 6; data = stream + idx; idx += m * 2; for k = 0 while k < SIGNED dword [p+2] (read again each pass): off = dword [stream + idx]; the m * 2 bytes at data are copied to
 *        out + off * 2; kind 2 then calls 0x4c7314(this 0x5cf659, out + off * 2, m * 2); idx += 4.
 * Kind 1: while idx < count (signed): the op; after the loop 0x4c7314(this 0x5cf659, out, size). Kind 2: first, when dword flag == 0, size bytes are copied from base to out (dwords, then bytes); then the same loop
 * (without the final call). Any other kind: nothing. Any other opcode byte: the original jumps back to the loop head without moving idx and NEVER finishes: the port returns 1 there (everything the ops before it
 * did has happened, the final call has not), otherwise 0. */
int m416af3_apply_patches(uint32_t hdr, uint32_t out, uint32_t size, uint32_t stream, uint32_t base, uint32_t flag, const Fl18Host *host);

/* 0x4db38a, thiscall, plain `ret`, no stack arguments. 0x4dadff(this 0x5830a6) (thiscall, 0 arguments); dwords 0x5d16cd = 0 and 0x5d1683 = 0; p = 0x4daeb5(this 0x5830a6, the address of a local pair of
 * dwords) (thiscall, 1 argument, a host pointer; in the game the callee returns its argument, so Fl18Host.call returns the LOW 32 BITS of the local's address and a result equal to them means the local pair; any
 * other result is an original address of two dwords, read through Fl18Host.resolve); dword [self+0x14] = [p], dword [self+0x18] = [p+4]; 0x4dbb13(this self) (thiscall, 0 arguments). dx = [self+0x14] - [self+0x34],
 * dy = [self+0x18] - [self+0x38] (32-bit); dword [self+0x94] = |dx| and [self+0x98] = |dy| (abs by cdq/xor/sub: |0x80000000| stays 0x80000000). When [self+0x94] > signed word 0x5d2f0d (SIGNED compare, the word
 * sign-extended): [self+0x14] = [self+0x34] + word when dx > 0 (signed), else [self+0x34] - word; likewise for y with [self+0x98], the word 0x5d2f0f and the fields +0x18 / +0x38. 0x4dbb13(this self) again.
 * v = dword 0x583204 - 2; when v > 3 (UNSIGNED; the four cases 0..3 all go straight to the common tail): if 0x4d57e8(this 0x570450, self + 0x34, 0x583186) (thiscall, 2 arguments) != 0: 0x4db780(this self);
 * else if 0x4d5834(this 0x570450, self + 0x34, 0x583186) != 0: 0x4db817(this self); else [self+0x28] = [self+0x38], [self+0x30] = [self+0x40], [self+0x24] = [self+0x34], [self+0x2c] = [self+0x3c], dword 0x5d1683 = 1,
 * r = 0x4d5316(this 0x570450, self + 0x34, 0x583186) (thiscall, 2 arguments); when r != 0: the four dwords at self + 0x34 are copied to self + 0x54, [self+0x44] = [self+0x34] - dword 0x583186, [self+0x4c] =
 * [self+0x3c] - dword 0x583186, [self+0x48] = [self+0x38] - dword 0x58318a, [self+0x50] = [self+0x40] - dword 0x58318a, 0x4d56e2(this 0x570450, self + 0x44, self + 0x54, r) (thiscall, 3 arguments), dword 0x5d16cd = 1;
 * else when the signed word 0x63a4cd != 0: 0x50ca3e(0x63888b, 0x55af64, [self+0x24], [self+0x28], [self+0x2c], [self+0x30], dword 0x583186, 0x58318a, 0x58318e, 0x583192) (cdecl, 10 arguments) and 0x44a2b7(0x63888b) (cdecl, 1 argument).
 * Common tail, in this order: [self+0x38] = [self+0x18]; e = (dword 0x5b44f4 << 2) + dword 0x5b44f0 * 8 (32-bit, read from the globals); [self+0x40] = [self+0x38] + signed word at 0x5b3792 + e - 1; [self+0x34] = [self+0x14];
 * [self+0x3c] = [self+0x34] + signed word at 0x5b3790 + e - 1 (e recomputed); 0x4dae88(this 0x5830a6, [self+0x14], [self+0x18]) (thiscall, 2 arguments); [self+0x1c] = [self+0x14]; [self+0x20] = [self+0x18]; with f = (dword 0x5b44f0 << 4) +
 * dword 0x5b44f4 * 8: [self+0x9c] = dword 0x583106 + dword at 0x5b30d0 + f; [self+0xa0] = dword 0x583102 + dword at 0x5b30cc + f (f recomputed); dwords 0x5c3a53 = [self+0xa0] and 0x5c3a57 = [self+0x9c].
 * The callees 0x4dbb13, 0x4db780 and 0x4db817 are given self and may change it; that is not exercised (tasks/fl33c-handoff.md). */
void m4db38a_update_cursor(uint8_t *self, Fl33cWorld *world, const Fl18Host *host);

/* 0x4d2c20, cdecl (plain `ret`, the arguments stay on the stack), stack arguments text ([ebp+8]), font ([ebp+0xc]), metrics ([ebp+0x10]) (original addresses), x ([ebp+0x14]), y ([ebp+0x18]) and sel ([ebp+0x24])
 * (WORDS: only the low 16 bits are read, sign-extended; the upper half is left over from the caller) and a ([ebp+0x1c]), b ([ebp+0x20]) (dwords). Returns the address 0x63a8e0 (the original loads it into eax last).
 * When the signed word 0x63a4cd != 0 (a word compare) and (a == 0 or b == 0): 0x52139c(0x55a344, 0, 0) (stdcall, 3 arguments) and 0x4c97b4(this 0x5cf659) (thiscall, 0 arguments); the original goes on after them as in the
 * other case. Then dwords 0x63a8ec = y, 0x63a8e4 = 0, 0x63a8e0 = x, 0x63a8e8 = 0 (x, y sign extended), and for each byte c of the NUL-terminated string (c = the SIGNED byte; the terminator is a signed compare against 0), in order:
 *  - r = 0x4d214b(c, font, the address of a local word) (cdecl, 3 arguments; the char is pushed from cl with a stale upper part: the port passes the zero-extended byte, the comparison masks to 8 bits; the callee stores the
 *    glyph index word into the local); r != 0: the glyph with that index (a signed word) is emitted;
 *  - else when 0x50d651(c) != 0 and 0x50d67f(c) != 0 (cdecl, 1 argument each, the SIGN-EXTENDED byte) and the zero-extended byte < 0x80: index = (word)(c + signed word [font+0x53] - 0x41), emitted;
 *  - else when 0x50d651(c) != 0 and 0x50d6a7(c) != 0 and the zero-extended byte < 0x80: index = (word)(c + signed word [font+0x55] - 0x61), emitted;
 *  - else when 0x50d6cf(c) != 0 and the zero-extended byte < 0x80: index = (word)(c + signed word [font+0x57] - 0x30), emitted;
 *  - else: dword 0x63a8e0 += signed word [font+0x4f]; dword 0x63a8e8 = dword 0x63a8e0 + signed word [font+0x4f] - 1.
 * Emitting glyph i (signed word) with s = sel * 8: rect = {dword [font + i*16 + 0xc3] + dword [font + s + 0x3f], dword [font + i*16 + 0xc7] + dword [font + s + 0x43], dword [font + i*16 + 0xcb] + dword [font + s + 0x3f],
 * dword [font + i*16 + 0xcf] + dword [font + s + 0x43]} (32-bit; a local of four dwords, a host pointer); dword 0x63a8e4 = dword 0x63a8ec - signed word [metrics + i*4 + 2] + 1; dword 0x63a8e8 = dword 0x63a8e0 + signed word
 * [metrics + i*4] - 1; 0x4c5d4b(this 0x5cf659, a, b, rect, 0x63a8e0, 0x55a37c) (thiscall, 5 arguments); dword 0x63a8e0 = signed word [font+0x51] + dword 0x63a8e0 + signed word [metrics + i*4] (the global is read again after
 * the call); dword 0x63a8e8 = dword 0x63a8e0 + signed word [metrics + i*4] - 1. The index local is read again (as a word) after the call. */
uint32_t m4d2c20_layout_text(uint32_t text, uint32_t font, uint32_t metrics, uint32_t x, uint32_t y, uint32_t a, uint32_t b, uint32_t sel, Fl33cWorld *world, const Fl18Host *host);

/* FNS-END */

#ifdef __cplusplus
}
#endif

#endif
