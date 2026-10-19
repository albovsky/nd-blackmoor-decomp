#ifndef BLACKMOOR_ORIGINAL_METHODS_FL26A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL26A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-26 (batch a): the last session input rows of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-25 (see
 * original_methods_fl25a.h, whose conventions apply unchanged and whose Fl18Host from original_methods_fl18.h is reused): each is its
 * own symbol that cites the original address in its leading comment, `self` is the original `this` object (ecx) as raw bytes at the
 * original offsets, nothing is bounds-checked, and the effects keep the order of the original.
 *
 * Calls into original code go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed). A
 * stack argument that the original pushes from a 16-bit register is a "word" (only its low 16 bits are meaningful). A singleton object
 * that the original names by a constant ecx (0x5830ce, 0x571442, ...) is passed as its 32-bit original address. An address that a
 * record or an object keeps is the 32-bit original address; Fl18Host.resolve turns it into host memory where the function reads through
 * it. Fl18Host.resolve is called UNCHECKED; only Fl18Host.call may be NULL (the calls then return 0).
 *
 * Caller-validated (the port does not check, like the original, and no native rejection exists in this batch): the object count [+0xcc] of 0x4897cd (the list at
 * [+0x2c + 4i] holds 40 addresses, so a count above 40 reads past it; a count whose signed value is not positive is a valid empty loop), the row count word [+0xaa] of an
 * object (the rows at +0x6ec + 0x26 j must exist), every address that Fl18Host.resolve is called with (it is called UNCHECKED: a NULL result is dereferenced), the
 * record number words (the record table must cover the signed word times 0x8d, -1 .. 4 are exercised), and the rectangle address of 0x4b42d3. Resolve width contract:
 * Fl18Host.resolve(a) must return memory valid for the bytes read through it: 16 bytes for the rectangle of 0x4b42d3, 0x8ae bytes for an object of 0x4b42d3
 * (the tail rectangle ends at +0x8ae), 0x41 bytes for one of 0x469057, and for an object of 0x4897cd 0xab6 bytes and the rows up to +0x6ec + 0x26 * (row count).
 *
 * Host contract (as in FL-21, FL-25): the Fl26aWorld scalars are a snapshot. A host that backs a callee with real original code must
 * flush the world to the original's memory BEFORE each Fl18Host.call and resync it AFTER the call. A callee that changes `self`, the
 * record table, an object or a global that the function reads again afterwards is not exercised by the tests of this slice.
 * Nothing here claims original source structure. */

typedef struct Fl26aWorld {
    uint8_t *records_5bb5e5;   /* records of stride 0x8d: the dword at +0 is the address of the object of record n, the dword at +0x4d its state */
    uint32_t value_5a4c18, value_5c39e5, value_5b44f8, value_583204;   /* 0x4d3073: reset, reset to -1, cleared, and the switch value (minus 2) */
    uint32_t value_5b44f0, value_5b44f4, value_5d0377, value_5d162d, value_5d1631, value_5d1639, value_571ad3;   /* 0x4897cd: the announcement globals */
    int16_t word_583a29, word_5bb50b;   /* 0x4897cd: the selected cursor (-1 = none) and the word that a row must equal */
    uint8_t byte_5a161f;       /* 0x4d3073: the flag that decides the extra call of the default arm */
} Fl26aWorld;

/* 0x4d3073: per-tick session input step (plain `ret`, no `self`): calls 0x4db38a (ecx 0x5830ce); [0x5a4c18] = 0; [0x5c39e5] = -1; calls 0x4e8d72 (ecx 0x571442); [0x5b44f8] = 0;
 * then the switch on [0x583204] - 2 (unsigned compare against 3): 0 -> 0x4e77b8 (ecx 0x582711), 1 -> 0x4e89eb (ecx 0x571442), 2 -> 0x4ebd85 (ecx 0x57fd34), 3 -> 0x4e412d (ecx 0x57975c);
 * any other value: 0x4f0059 (ecx 0x583182), 0x4e075a (ecx 0x570508), and 0x4de322 (ecx 0x61f864) when the byte [0x5a161f] is non-zero. No callee takes a stack argument. */
void m4d3073_session_tick(Fl26aWorld *world, const Fl18Host *host);

/* 0x469057: hit test (ret 8; x, y the stack words): returns 0 when dword [+0x55c] is clear; words [+0x554], [+0x552], [+0x548] = 0xffff; for i (a word counter) below 6, row i of
 * 16 bytes in the object (y low at +0x20, y high +0x28, x low +0x1c, x high +0x24, each widened by -5, +5, -6, +10 in 32 bits before the signed compare): the first row that holds the point
 * stores the words [+0x552] = x, [+0x554] = y, calls 0x4691ee(this = self, word i) and returns 1. Otherwise the rectangle of the object of the record (signed word [+0x7e]) at +0x35 /
 * +0x3d (y) and +0x31 / +0x39 (x), widened the same way: a hit calls 0x4691ee(this = self, 0x64) and returns 1; else 0. */
int32_t m469057_hit_test(uint8_t *self, int16_t x, int16_t y, const Fl26aWorld *world, const Fl18Host *host);

/* 0x4b42d3: hit test (ret 0xc; the third argument is the original address of four dwords, a rectangle that it stores into the object): returns 0 when dword [+0x76e] is clear;
 * words [+0x75c], [+0x75a], [+0x758] = 0xffff; [+0x762] = rect[1], [+0x76a] = rect[3], [+0x75e] = rect[0], [+0x766] = rect[2]; calls 0x4b3f98(this = self); for i (a word counter)
 * below 3, row i of 16 bytes of the object of the record (signed word [+0x728]; y low at +0xed, y high +0xf5, x low +0xe9, x high +0xf1, signed compares): the first row that holds the
 * point stores the words [+0x75a] = x, [+0x75c] = y, calls 0x4b450f(this = self, word i) and returns 1. Then, when the signed word [+0x750] is zero: the rectangle at +0x8a2 / +0x8aa
 * (y) and +0x89e / +0x8a6 (x): a hit calls 0x4b450f(this = self, 0x64) and returns 1; else 0. */
int32_t m4b42d3_hit_test(uint8_t *self, int16_t x, int16_t y, uint32_t rect, const Fl26aWorld *world, const Fl18Host *host);

/* 0x4897cd: hit test (ret 8; x, y the stack words; no callee): returns 0 when dword [+0xcc] is clear; for i (a dword counter, signed compare) below [+0xcc]: the object address
 * [+0x2c + 4i] is stored to [+0x1c] and [+0x20]; the object is skipped when its dword [+0xab2] is clear or the record state (dword at +0x4d of the record of its word [+0xab0]) is not 1;
 * for j (a dword counter) below its signed word [+0xaa]: the row address object + 0x6ec + 0x26 j is stored to [+0x24]; the row hits when its word [0] equals the word [0x5bb50b], its
 * word [4] is 1 and the point is inside y [+0x1a, +0x22], x [+0x16, +0x1e] (signed dword compares). A hit sets the announcement globals 0x5b44f0, 0x5b44f4 = 1, 0x5d162d, 0x5d1631,
 * 0x5d1639 = 1 (the world is written; the first two depend on the word 0x583a29 and the dword 0x5b44f8), [0x5c39e5] = the signed word [object + 0xab0] and returns 1. No hit returns 0. */
int32_t m4897cd_hit_test(uint8_t *self, int16_t x, int16_t y, Fl26aWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
