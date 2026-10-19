#ifndef BLACKMOOR_ORIGINAL_METHODS_FL25D_H
#define BLACKMOOR_ORIGINAL_METHODS_FL25D_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-25 (batch d): the larger session input handlers of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-25 batch a
 * (see original_methods_fl25a.h, whose conventions apply unchanged and whose Fl18Host from original_methods_fl18.h is reused): each is its
 * own symbol that cites the original address in its leading comment, `self` is the original `this` object (ecx) as raw bytes at the
 * original offsets, nothing is bounds-checked, and the effects keep the order of the original.
 *
 * Calls into original code go through Fl18Host.call (callee address, ecx value (0 for a cdecl callee), stack arguments with args[0]
 * the LAST one pushed); a stack argument that the original pushes from a 16-bit register is a "word" (only its low 16 bits are
 * meaningful). An address that a record or an object keeps is the 32-bit original address; Fl18Host.resolve turns it into host memory
 * where the function reads through it. GetTickCount (import 0x52a23c) is Fl18Host.tick. Fl18Host.resolve and Fl18Host.tick are called
 * UNCHECKED; only Fl18Host.call may be NULL (the calls then return 0).
 *
 * Host contract (as in FL-21): the Fl25dWorld scalars are a snapshot. A host that backs a callee with real original code must flush the
 * world to the original's memory BEFORE each Fl18Host.call and resync it AFTER the call. A callee that changes `self`, the record table
 * or an object is not exercised by the tests of this slice. Nothing here claims original source structure. */

typedef struct Fl25dWorld {
    uint8_t *records_5bb5e5;   /* records of stride 0x8d: the dword at +0 is the address of the object of record n, the dword at +0x4d is its state (written by 0x4712bd) */
    uint32_t value_5c39e5;     /* the selector (the event) that the handler dispatches on */
    uint32_t value_5bb1ca;     /* a flag: non-zero = compare a field of the record object with a nine-byte constant and maybe announce it through 0x4fb2e3 */
    const uint8_t *bytes_54c480, *bytes_54c48c;   /* 0x4712bd: the nine-byte constants (repe cmpsb, ecx = 9) */
    uint32_t value_583186, value_58318a;   /* 0x4b2250: the offsets that are added to the x and y of the point */
} Fl25dWorld;

/* 0x4712bd (plain `ret`): events 0x27a6 and 0x27ad. Gates: byte [+0xd3e], dword [+0xd2c] == 0, record state 1 (record = signed word [+0xd28]).
 * For a slot s = signed word [+0xd2a] other than 0x28 and the selector 0x27a6: the byte [+0xc9c + s] and the byte [R+0x23] of the record object R
 * (the dword at the start of the record) steer three arms over the word list at +0xd4a (count word [+0xd32]); then the list at +0xdc2
 * (count word [+0xd30]); then (flag 0x5bb1ca) the nine bytes at R+0x66 against 0x54c480 -> 0x4fb2e3(this = 0x5c3a67, word [R+0x87]); then for
 * byte [R+0x24] and s == 0x28 the byte [+0xd3a] = 1, [+0xe00] = GetTickCount + 0x12c and the same announcement against 0x54c48c; at last the
 * selector 0x27ad sets byte [+0xd3f] and the record state 2. */
void m4712bd_click_27a6_27ad(uint8_t *self, Fl25dWorld *world, const Fl18Host *host);

/* 0x4b2250: hit test (ret 8): the grid of cells at self + 0x43 (rows of 0x1e4, cells of 0x2c) of the object, four overlapping tests per cell, then two rectangles of the
 * record object; calls 0x4afec1 and 0x4b2917 (see the comment at the definition); returns 1 on a hit that 0x4afec1 confirms with exactly 1 or on a rectangle hit, else 0 */
int32_t m4b2250_hit_test(uint8_t *self, int16_t x, int16_t y, const Fl25dWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
