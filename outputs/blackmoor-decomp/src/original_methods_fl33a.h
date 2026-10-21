#ifndef BLACKMOOR_ORIGINAL_METHODS_FL33A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL33A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-33 (batch a): eight pending functions of GAME.EXE (SHA-256 afd337a2...5c45) around 0x4dae88, 0x4234dd, 0x4c7070 ported one to one, in the style of FL-31 (see original_methods_fl31a.h
 * and original_methods_fl31c.h, whose conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its
 * leading comment, `self` is the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names are
 * descriptive hints, not recovered source names.
 *
 * Calls into original code, the CRT and the imports go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first argument of a C
 * prototype; an import is called by the address of its import slot). A dword that holds an address of the original is a 32-bit original address and goes through Fl18Host.resolve; the
 * address of a local that the original passes to a callee is a host pointer. Strings and tables that live in the original's data (0x552494 ...) are read through Fl18Host.resolve /
 * the world pointers; no original bytes are in this file. A callee that changes `self` or a global that the function reads again afterwards is not exercised (tasks/fl33a-handoff.md).
 * Nothing here claims original source structure. */

typedef struct Fl33aWorld {
    uint8_t *table_5d15a5;     /* 0x473117: records of stride 0x4a at the original address 0x5d15a5 (the dword at +0 is set); the caller leaves slack for a negative index */
    const uint8_t *table_5d1599;  /* 0x47d24e: the dwords of stride 0x4a at 0x5d1599, indexed by the signed word 0x61e39c (slack for a negative index) */
    const uint8_t *table_5b3790;  /* 0x4db993: pairs of signed words (x extent, y extent) at 0x5b3790, stride 8 per index of 0x5b44f0 (read only) */
    uint32_t value_61e3a4, value_61e3ac, value_61e3bc, value_61e3c8, value_61e618, value_61e624, value_5cf665, value_5d15e3;    /* 0x47d24e */
    uint32_t value_5c3a53, value_5c3a57, value_5b377c, value_5b3780, value_5b3784, value_5b3788, value_5b44f0, value_5b44f4, value_5d162d, value_5d0377, value_571ad3;    /* 0x4db993 */
    uint32_t value_583106, value_58310e, value_583102, value_58310a;    /* 0x4db993 */
    int16_t word_61e39c, word_583a29, word_63a4cd, word_639895;     /* 0x47d24e, 0x4db993, 0x4234dd, 0x4c7070 */
} Fl33aWorld;

/* 0x4dae88, thiscall, `ret 8`, stack arguments x ([ebp+8]) and y ([ebp+0xc]): dword [self+0x18] = x, dword [self+0x1c] = y, then the import USER32 SetCursorPos (slot 0x52a488, stdcall, 2 arguments:
 * x is the LAST one pushed = args[0], y = args[1]) is called and its result (eax) is returned. */
uint32_t m4dae88_set_cursor(uint8_t *self, uint32_t x, uint32_t y, const Fl18Host *host);

/* 0x473117, thiscall, plain `ret`: when dword [self+0x7a] == 0 nothing. Otherwise i = signed word [self+0x14]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m473117_mark_entry(const uint8_t *self, const Fl33aWorld *world);

/* 0x4234dd, thiscall, `ret 8`, stack arguments a ([ebp+8]) and b ([ebp+0xc]): n = dword [self+4]. When n >= 0x80 (SIGNED compare): the string at 0x5444cc is copied to 0x63888b with 0x50ca3e (cdecl, 2 arguments,
 * dest = args[0] = 0x63888b, src = args[1] = 0x5444cc); 0x52139c(0x63888b, 0, 0) (stdcall, 3 arguments, the first is args[0] = 0x63888b); when the signed word 0x63a4cd != 0: 0x44a2b7(0x63888b) (cdecl, 1 argument); then
 * 0x4c97b4(this 0x5cf659) (thiscall, 0 arguments). The original goes on after that exactly as in the other case (the callees are expected not to return; this port keeps going as the code does). Then, with n read
 * again and m = n * 12 (32-bit wrap): dword [self + m + 0xc] = a, dword [self + m + 0x10] = b, then dword [self+4] = [self+4] + 1 (read after the two stores: for n == -1 the second store hits [self+4] itself). */
void m4234dd_push_pair(uint8_t *self, uint32_t a, uint32_t b, const Fl33aWorld *world, const Fl18Host *host);

/* 0x4c7623, thiscall, `ret 0xc`, stack arguments a ([ebp+8]), rect ([ebp+0xc], an original address of four dwords r0 r4 r8 rc) and the word w (low 16 bits of [ebp+0x10]; the callee reads a word, the upper half of the
 * pushed dword is left over, so the port passes the zero-extended word). desc = a local of 0x80 bytes; 0x4c4067(this self, a, 0, desc, 0x5553a8, 0x20) (thiscall, 5 arguments: args[2] is the host pointer of the local);
 * v1 = dword [desc+0x10], v2 = dword [desc+0x24] (stored by the callee). Then four times 0x4c808f(this self) with seven arguments {v2, v1, p, q, r, s, w}: {r0, r4, r8, r4}, {r0, rc, r8, rc}, {r0, r4, r0, rc},
 * {r8, r4, r8, rc} for (p q r s) (every r.. is read from the rect again for each push). Then 0x4c4202(this self, a, rect, 0x5553d0) (thiscall, 3 arguments: args[0] = a, args[1] = rect, args[2] = 0x5553d0);
 * when a == dword [self+0xc]: 0x4c952f(this self, rect) (thiscall, 1 argument). The local desc is zero filled here; the original reads stack bytes the callee has stored. */
void m4c7623_draw_frame(uint8_t *self, uint32_t a, uint32_t rect, uint32_t w, const Fl18Host *host);

/* 0x4bf3b8, thiscall, `ret 4`, one stack argument `code`, returns eax = self + 0xc0 (a host pointer). v = dword [self+0x2c0] + 6 (32-bit); the text buffer is at self + 0xc0. By v (UNSIGNED compare, v > 5 is the default):
 * 0: e = the import binkw32 _BinkGetError@0 (slot 0x52a514, stdcall, 0 arguments) and 0x50ca3e(self+0xc0, 0x552564, e) (cdecl, 3 arguments); 1: 0x50ca3e(self+0xc0, 0x552540, code); 2: the NUL-terminated string
 * at 0x552508 is copied (with its NUL) to self+0xc0; 3: 0x5524e4; 4: 0x552494; 5: 0x5524bc; default: 0x552594. The strings are read through Fl18Host.resolve; the copy is dwords first, then the remaining bytes. */
uint8_t *m4bf3b8_set_text(uint8_t *self, uint32_t code, const Fl18Host *host);

/* 0x4db993, thiscall, `ret 8`, stack arguments a ([ebp+8]) and b ([ebp+0xc]). 0x4dae88(this 0x5830a6, a, b) (thiscall, 2 arguments: a is args[0]); p = 0x4daeb5(this 0x5830a6, the address of a local pair of dwords)
 * (thiscall, 1 argument, a host pointer; in the game the callee returns its argument, so Fl18Host.call returns the LOW 32 BITS of the local's address and a result equal to them means the local pair; any other result
 * is an original address of two dwords, read through Fl18Host.resolve); dword [self+0x14] = [p], dword [self+0x18] = [p+4]; dwords 0x5c3a53 = [self+0x14] and 0x5c3a57 = [self+0x18] (re-read). Then, with x = [self+0x14]
 * and y = [self+0x18] (SIGNED): out of range when x < dword 0x5b377c or x > 0x5b3784 or y < 0x5b3780 or y > 0x5b3788. Out of range: dword 0x5b44f0 = 4 and 0x5d162d = dword 0x5d0377. In range: when the signed word 0x583a29 == -1:
 * 0x5b44f0 = 0 and 0x5d162d = dword 0x5d0377, otherwise 0x5b44f0 = word (sign-extended) + 0x25 and 0x5d162d = dword 0x571ad3. Then 0x5b44f4 = 0; [self+0x28] = dword 0x583106; [self+0x30] = 0x58310e; [self+0x24] = 0x583102;
 * [self+0x2c] = 0x58310a (the OLD values); dword 0x583106 = [self+0x18]; e = (0x5b44f4 << 2) + 0x5b44f0 * 8 (32-bit, both read back from the globals); dword 0x58310e = [self+0x18] + signed word at 0x5b3792 + e - 1;
 * dword 0x583102 = [self+0x14]; dword 0x58310a = [self+0x14] + signed word at 0x5b3790 + e - 1 (the word table is read through Fl33aWorld.table_5b3790). */
void m4db993_move_cursor(uint8_t *self, uint32_t a, uint32_t b, Fl33aWorld *world, const Fl18Host *host);

/* 0x47d24e, plain `ret`, no arguments and no ecx: p = dword 0x61e3a4. When dword 0x61e3bc == 0 nothing. When dword 0x61e3c8 != 0: 0x4c5377(this 0x5cf659, {dword 0x5d15e3, dword 0x5cf665, 0x583196, 0x61e5f4, 0x54d1a0})
 * (thiscall, 5 arguments) and dword 0x61e3c8 = 0. When the SIGNED byte [p + 0x35b] != 0: 0x4c5377(this 0x5cf659, {t, dword 0x5cf665, p + (dword 0x61e624 << 4) + 0xe1, 0x61e554, 0x54d1c8}) with t = dword at
 * 0x5d1599 + signed word 0x61e39c * 0x4a. Then base = dword 0x61e624 * dword 0x61e618 (32-bit) and for i = 0 while i < signed dword 0x61e618 (read again each pass), base + 1 each pass: e = dword 0x61e3ac + base * 12;
 * when dword [e+4] == 1: 0x4c5377(this 0x5cf659, {t, dword 0x5cf665, p + (dword [e] << 4) + 0x21, 0x61e3d4 + (i << 4), 0x54d1e4}) (t read again), else 0x4c5377(this 0x5cf659, {dword 0x5d15e3, dword 0x5cf665,
 * p + (i << 4) + 0x111, 0x61e3d4 + (i << 4), 0x54d20c}). Every argument is a 32-bit original value (addresses are not dereferenced by the callee here). */
void m47d24e_report_fields(Fl33aWorld *world, const Fl18Host *host);

/* 0x4c7070, thiscall, `ret 8`, stack arguments desc (an original address, [ebp+8]) and arg2 ([ebp+0xc]). Fields of desc: dword [+0] = image (an original address), dword [+0x23] = size, words [+0x2b] w1, [+0x2d] w2,
 * [+0x2f] w3, [+0x31] (all unaligned). buf = 0x51dc43(size) (cdecl, 1 argument). When 0: 0x42639d(this 0x583979, 0x5552e8, arg2) (thiscall, 2 arguments) and 0x4c97b4(this self) (thiscall, 0 arguments), nothing else.
 * Otherwise `size` bytes are copied from image to buf (dwords first, then bytes), and for i = 0 while i < signed w1, for j = signed w2 - 1 down to 0: the word at image + k (k counts up by 2 over the whole loop) =
 * the word at buf + j * signed w3 + i * signed word 0x639895 (all 32-bit, unaligned). Then words [desc+0x2b] = w2, [desc+0x2d] = w1, [desc+0x2f] = low 16 bits of signed w2 * signed word 0x639895, [desc+0x31] = w1;
 * 0x51dc6c(buf) (cdecl, 1 argument). The reads of buf beyond the copied bytes are the caller's to keep inside the block the allocator returned (the original does not check them either). */
void m4c7070_rotate_image(uint8_t *self, uint32_t desc, uint32_t arg2, const Fl33aWorld *world, const Fl18Host *host);

/* FNS-END */

#ifdef __cplusplus
}
#endif

#endif
