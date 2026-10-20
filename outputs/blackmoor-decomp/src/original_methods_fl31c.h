#ifndef BLACKMOOR_ORIGINAL_METHODS_FL31C_H
#define BLACKMOOR_ORIGINAL_METHODS_FL31C_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-31 (batch c): eight methods of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-31 batch b and FL-29 batch a (see original_methods_fl31b.h and
 * original_methods_fl29a.h, whose conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original
 * address in its leading comment, `self` is the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the
 * original. The names are descriptive hints, not recovered source names.
 *
 * Calls into original code and the CRT go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first argument of a C prototype).
 * An argument that is an address of the original (a string, a record, a destination) is a 32-bit original address here, as in the original, and Fl18Host.resolve turns it into host
 * memory when the function reads or writes through it; an address inside `self` is a host pointer (as in FL-18). A callee that changes `self` or a global that the function reads
 * again afterwards is not exercised (tasks/fl31c-handoff.md). Word arguments are taken from the low 16 bits of the stack dword, as the callee reads them. */

typedef struct Fl31cWorld {
    uint8_t *words_59f27b;         /* 0x4eba54: the words at the original address 0x59f27b (indexed by a dword counter; row 0 only); host memory, writable */
    const uint8_t *table_5b3790;   /* 0x4db870: the words at the original address 0x5b3790 (the entry is [sel * 8 + count * 4]; the caller leaves slack on both sides) */
    uint32_t dword_5d0377;         /* 0x4db870: copied to dword_5d162d when word_583a29 == -1 */
    uint32_t dword_571ad3;         /* 0x4db870: copied to dword_5d162d otherwise */
    uint32_t dword_5b44f0;         /* 0x4db870: written (0, or word_583a29 + 0x25) */
    uint32_t dword_5d162d;         /* 0x4db870: written */
    uint32_t dword_5b44f4;         /* 0x4db870: written (0) and read back */
    uint32_t dword_583106;         /* 0x4db870: written, then read back */
    uint32_t dword_58310e;         /* 0x4db870: written, then read back */
    uint32_t dword_583102;         /* 0x4db870: written, then read back */
    uint32_t dword_58310a;         /* 0x4db870: written, then read back */
    int16_t word_583a29;           /* 0x4db870: -1 selects the first arm (signed compare) */
    uint16_t word_639893;          /* 0x4c2790: copied to the word [record + 0x33] */
} Fl31cWorld;

/* 0x4e2faa, thiscall, plain `ret`: for i = 0 .. 0x19 (a signed dword counter): 0x4e1d34(this self + 0x1ca2 + i * 0x18f) (thiscall, 0 arguments). Then 0x4e2dd3(this self) (thiscall, 0
 * arguments), 0x4c92c5(this 0x5cf659, word [self+0x140a]) and 0x4c92c5(this 0x5cf659, word [self+0x140c]) (thiscall, 1 argument, a word: the original pushes ecx / eax whose upper half
 * is stale, so only the low 16 bits count). Then, when dword [self+0x6ce] != 0: 0x4c2dfb(this 0x5cf659, self + 0x6ce) (thiscall, 1 argument: the address of the dword inside self, a host
 * pointer here). */
void m4e2faa_release_cells(uint8_t *self, const Fl18Host *host);

/* 0x4c2790, thiscall, `ret 0x10`, the stack arguments are a (the first), b, c and the original address `text` of a NUL-terminated string; returns eax. buf = 0x51dc43(0x59) (cdecl, 1
 * argument). When buf == 0: 0x42639d(this 0x583979, 0x553be8, b) (thiscall, 2 arguments), 0x4c97b4(this self) (thiscall, 0 arguments), returns 0. Otherwise: the 0x59 bytes at buf are
 * set to zero (0x16 dwords, then one byte); when the length of `text` (up to the NUL) is >= 0x19 the byte text[0x18] is set to zero (in place); the string including its NUL (its length is
 * measured again) is copied to buf + 8 (dwords for length >> 2, then the tail bytes); dword [buf+4] = c; word [buf+0x21] = 0x59; word [buf+0x33] = word 0x639893; dword [buf+0x55] = 0; then
 * 0x4181c6(this 0x5d2f31, a, b, buf) (thiscall, 3 arguments; the callee fills dword [buf]). When dword [buf] == 0: 0x42639d(this 0x583979, 0x553c40, b), 0x4c97b4(this self), returns 0;
 * otherwise returns buf. */
uint32_t m4c2790_new_record(uint8_t *self, uint32_t a, uint32_t b, uint32_t c, uint32_t text, const Fl31cWorld *world, const Fl18Host *host);

/* 0x4eba54, thiscall, plain `ret`: for the dword counter [self+0xfc6] = 0, 1 (while it is < 2, signed, re-read each pass): when dword [self + counter * 0xf7 + 0x985] != 0:
 * 0x4e1d34(this self + counter * 0x18f + 0xca8) (thiscall, 0 arguments). Then [self+0xfc6] = 0 again and, while it is < the signed word [self+0x28da] (both re-read each pass): when the signed
 * word at 0x59f27b + counter * 2 (row 0: the original keeps a word local, set to 0, as the row) equals 8, that word = word [self+0xb85]. The counter is stored in self at every step and ends equal to
 * max(0, the word) (or 0 when the word is <= 0). Finally 0x4eb9c8(this self) (thiscall, 0 arguments). */
void m4eba54_retarget_words(uint8_t *self, const Fl31cWorld *world, const Fl18Host *host);

/* 0x4edb97, thiscall, plain `ret`: when dword [self+0x15f] != 0: 0x4e1d34(this self + 0x31c); when dword [self+0x252] != 0: 0x4eead0(this self + 0x4b7) (both thiscall, 0 arguments); when dword
 * [self+0x4ab] != 0: 0x4c2dfb(this 0x5cf659, self + 0x4ab) (thiscall, 1 argument: the address inside self, a host pointer); then for the dwords [self+0x675], [self+0x679], [self+0x67d], [self+0x681]
 * in this order: when it is non-zero: 0x4fba69(this 0x5c3a67, self + 0x9b / 0xcc / 0xfd / 0x12e) (thiscall, 1 argument: the address inside self), then that dword = 0 (after the call). Finally
 * 0x4edae5(this self) (thiscall, 0 arguments). */
void m4edb97_release_members(uint8_t *self, const Fl18Host *host);

/* 0x4db870, thiscall, plain `ret`: 0x4dae88(this 0x5830a6, 0, 0) (thiscall, 2 arguments). When the signed word 0x583a29 == -1: dword 0x5b44f0 = 0 and dword 0x5d162d = dword 0x5d0377; otherwise
 * 0x5b44f0 = word 0x583a29 (sign-extended) + 0x25 and 0x5d162d = dword 0x571ad3. Then dword 0x5b44f4 = 0 and p = 0x4daeb5(this 0x5830a6, the address of a local pair of dwords) (thiscall, 1 argument,
 * a host pointer; the result is an original address of two dwords, which the original reads through, possibly inside self: both are read before anything is stored). Then dword [self+0x14] = [p],
 * dword [self+0x18] = [p+4], dword [self+0x1c] = [self+0x14], dword [self+0x20] = [self+0x18], dword 0x583106 = [self+0x18] and [self+0x28] = 0x583106, e = (0x5b44f4 << 2) + 0x5b44f0 * 8 (32-bit),
 * dword 0x58310e = [self+0x18] + signed word at 0x5b3792 + e - 1 and [self+0x30] = 0x58310e, dword 0x583102 = [self+0x14] and [self+0x24] = 0x583102, dword 0x58310a = [self+0x14] + signed
 * word at 0x5b3790 + e - 1 and [self+0x2c] = 0x58310a. The globals are stored in this order and read back from the globals where the original does. */
void m4db870_load_cursor(uint8_t *self, Fl31cWorld *world, const Fl18Host *host);

/* 0x47cd90, 0x47ce6f and 0x47cf4e (three copies of one method, one static helper in the source, one symbol each): thiscall, plain `ret`; selector field S (+0x2b8, +0x2bc, +0x2c0), record base
 * offset B (0x4c8, 0x856, 0xf72), count N (5, 10, 10), strings s1 and s2 (0x54d104 / 0x54d110, 0x54d11c / 0x54d128, 0x54d134 / 0x54d140); the final callee is 0x47d02d in all three. The record `i`
 * is at the 32-bit address dword [self+0xc] + i * 0xb6 + B. dword [self+S] = 0xffffffff. found = 0. For i = 0 .. N-1 (signed dword counter): when 0x516530(record i, s1) (cdecl, 2 arguments)
 * returns non-zero: found = 1 and leave the loop. When found: repeat: r = 0x50cd50() (cdecl, 0 arguments); dword [self+S] = r % N (signed idiv, the remainder keeps the sign of r); when
 * 0x516530(record [self+S], s2) returns non-zero: 0x47d02d(this self, record [self+S]) (thiscall, 1 argument) and stop; otherwise draw again. The loop has no bound in the original either (it
 * ends when the host's compare answers non-zero). */
void m47cd90_pick_variant_a(uint8_t *self, const Fl18Host *host);
void m47ce6f_pick_variant_b(uint8_t *self, const Fl18Host *host);
void m47cf4e_pick_variant_c(uint8_t *self, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
