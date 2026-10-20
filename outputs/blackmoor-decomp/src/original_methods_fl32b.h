#ifndef BLACKMOOR_ORIGINAL_METHODS_FL32B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL32B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-32 (batch b): nine small functions of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-31 batch a (see original_methods_fl31a.h, whose
 * conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment,
 * `self` is the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names are
 * descriptive hints, not recovered source names.
 *
 * Calls into original code and the CRT go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first argument of a C
 * prototype). The address of a local or of a field of `self` that the original passes to a callee is passed as the host pointer of that memory. A constant address of the
 * original that the function reads through (0x53ec5c, 0x53ec60) goes through Fl18Host.resolve. A callee that changes `self` or a global that the function reads again
 * afterwards is not exercised (tasks/fl32b-handoff.md). Nothing here claims original source structure. */

typedef struct Fl32bWorld {
    /* the four words at 0x5ec2d6.. : 0x40a613 stores the word 0x5ec2d8 and 0x40a665 the word 0x5ec2da; the other two are not touched by these functions (the
     * callee 0x4090ab reads 0x5ec2d6) and are carried so that a store of the wrong width or at the wrong place shows */
    uint16_t word_5ec2d6, word_5ec2d8, word_5ec2da, word_5ec2dc;
} Fl32bWorld;

/* 0x40a613, thiscall, plain `ret`, returns eax of its last callee. Local buffer b of 0x14 bytes; 0x51d5b2(this self + 0xcc, b, 0x13) (thiscall, 2 stack arguments, the callee pops them);
 * then the 4 bytes b[0..3] are compared with the 4 bytes at the original address 0x53ec5c (the compare ends at the first differing byte). When they are NOT all equal:
 * x = 0x50cb1b(b) (cdecl, 1 argument) and the word [0x5ec2d8] = low 16 bits of x. Finally returns 0x4090ab(this self) (thiscall, no arguments). */
uint32_t m40a613_read_tag_word(uint8_t *self, Fl32bWorld *world, const Fl18Host *host);

/* 0x40a665, thiscall, plain `ret`, returns eax of its last callee: the same as 0x40a613 with the object field self + 0x10c, the tag at the original address 0x53ec60
 * and the word [0x5ec2da]. */
uint32_t m40a665_read_tag_word(uint8_t *self, Fl32bWorld *world, const Fl18Host *host);

/* 0x4a9f27, thiscall, plain `ret`, returns this (eax): words [self+0x21] and [self+0x29] = 0xffff; dword [self+0x1d] = 0; bytes [self+0x45], [self+0x46], [self+0x47] = 0 (in this order). No calls. */
uint8_t *m4a9f27_reset_fields(uint8_t *self);

/* 0x4b71f7, thiscall, plain `ret`, returns this: words [self+0x21] and [self+0x2f] = 0xffff; bytes [self+0x35], [self+0x36], [self+0x3b] = 0 (in this order). No calls. */
uint8_t *m4b71f7_reset_fields(uint8_t *self);

/* 0x4781fa, thiscall, plain `ret`, returns this: words [self+0x1e] and [self+0x1c] = 0xffff; dwords [self+0x157a], [self+0x157e], [self+0x1576] = 0 (in this order). No calls. */
uint8_t *m4781fa_reset_fields(uint8_t *self);

/* 0x4afd3a, thiscall, plain `ret`, returns this: words [self+0x1e] and [self+0x1c] = 0xffff; dwords [self+0x1515], [self+0x1519], [self+0x151d] = 0 (in this order). No calls. */
uint8_t *m4afd3a_reset_fields(uint8_t *self);

/* 0x4e04f3, thiscall, plain `ret`, returns this: dwords [self+0xf2a], [self+0x74f], [self+0xf2e] = 0; [self+0xf32], [self+0xf36] = 0xffffffff (in this order). No calls. */
uint8_t *m4e04f3_reset_fields(uint8_t *self);

/* 0x454565, thiscall (ecx is stored and not used), `ret 0xc`, three pointer arguments a, b, c (host pointers here) to points of two dwords (x at +0, y at +4): returns eax =
 * (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y), every difference, product and the final difference modulo 2^32 (32-bit imul, sub). The points are only read; the three
 * pointers may alias. */
int32_t m454565_cross_product(const uint8_t *a, const uint8_t *b, const uint8_t *c);

/* 0x4a638a, thiscall, plain `ret`, returns this: words [self+0x1e] and [self+0x1c] = 0xffff; dwords [self+0x21], [self+0x25], [self+0x86] = 0; bytes [self+0x8a], [self+0x8b] = 0 (in this order). No calls. */
uint8_t *m4a638a_reset_fields(uint8_t *self);

/* FNS-END */

#ifdef __cplusplus
}
#endif

#endif
