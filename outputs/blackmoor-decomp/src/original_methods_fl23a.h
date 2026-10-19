#ifndef BLACKMOOR_ORIGINAL_METHODS_FL23A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL23A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-23 (batch a): the per-action hit-test handlers of GAME.EXE (SHA-256 afd337a2...5c45) that the session input dispatcher 0x4f0059
 * calls, ported one to one in the style of FL-22 (see original_methods_fl22b.h, whose conventions apply unchanged: `self` is the
 * original `this` object (ecx) as raw bytes at the original offsets, Fl18Host from original_methods_fl18.h, calls into original code
 * through Fl18Host.call with args[0] the LAST argument pushed, "word" arguments compare by their low 16 bits, nothing is bounds-checked).
 *
 * Every handler has the shape `thiscall, two word arguments x ([ebp+8]) and y ([ebp+0xc]), ret 8`, returns 1 when the point hits one of its
 * rectangles (after calling the action routine of that rectangle through the host) and 0 otherwise. A rectangle is four dwords compared with
 * the sign-extended words (jl/jg, signed): low y, high y, low x, high x, at the offsets named in each function. The objects that the records
 * keep (the dword at the start of a record of stride 0x8d of 0x5bb5e5, or a pointer stored in `self`) are addresses of the original; the
 * port reads through them with Fl18Host.resolve, which is called UNCHECKED where a function reads such an object.
 *
 * Host contract (as in FL-21/22): the Fl23aWorld scalars are a snapshot; a host that backs a callee with real original code must flush the
 * world to the original's memory BEFORE each Fl18Host.call and resync it AFTER the call. Only Fl18Host.call may be NULL (calls return 0).
 * The item counts and record indices (signed words and bytes read from the objects) are the caller's contract: nothing bounds them, as in
 * the original (a count that no rectangle satisfies and that exceeds the object reads past it). Nothing here claims original source
 * structure. */

typedef struct Fl23aWorld {
    uint8_t *records_5bb5e5;   /* records of stride 0x8d: the dword at +0 is the address of the object of record n (index: a signed word of `self`) */
    /* the globals that the click arms of 0x46ea16 and 0x4b7389 write (and 0x4b7389 reads back) */
    uint32_t value_5c39e5;     /* the selector (event) */
    uint32_t value_5d0377;     /* copied to 0x5d162d */
    uint32_t value_5d162d;
    uint32_t value_5b44f0, value_5b44f4;   /* row and column of the table of 32 * row + 16 * column bytes at 0x5b160c */
    uint32_t value_5d1631;     /* 0x5b160c + (value_5b44f0 << 5) + (value_5b44f4 << 4) */
    uint32_t value_5d1639;     /* set to 1 */
} Fl23aWorld;

/* 0x47d734: when the byte at +0x57 is non-zero the word at +0x25 gets x and the word at +0x27 gets y. Always returns 0. The record read at the
 * start (word +0x1d times 0x8d into 0x5bb5e5) is stored in an unused local, so it is not ported. ret 8. */
int32_t m47d734_store_point(uint8_t *self, int16_t x, int16_t y);

int32_t m4a1e16_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host);   /* callee 0x4a1e93 */
int32_t m4ba377_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host);   /* callee 0x4ba486 */
int32_t m459cc9_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host);   /* callee 0x459ddc */
int32_t m487c92_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host);   /* callee 0x487dcf */
int32_t m48a920_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host);   /* callee 0x48aa66 */
int32_t m48e628_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host);   /* callee 0x48e776 */
int32_t m479deb_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host);   /* callees 0x478396, 0x479f72 */
int32_t m46ea16_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host);   /* callee 0x46ebbd; writes globals */
int32_t m4b7389_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host);   /* no callee; writes globals */
int32_t m4ab528_hit_test(uint8_t *self, int16_t x, int16_t y, Fl23aWorld *world, const Fl18Host *host);   /* callee 0x4ab706 */

#ifdef __cplusplus
}
#endif

#endif
