#ifndef BLACKMOOR_ORIGINAL_METHODS_FL25A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL25A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-25 (batch a): the larger session input handlers of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-24 (see
 * original_methods_fl24a.h, whose conventions apply unchanged and whose Fl18Host from original_methods_fl18.h is reused): each is its
 * own symbol that cites the original address in its leading comment, `self` is the original `this` object (ecx) as raw bytes at the
 * original offsets, nothing is bounds-checked, and the effects keep the order of the original.
 *
 * Calls into original code go through Fl18Host.call (callee address, ecx value (0 for a cdecl callee), stack arguments with args[0]
 * the LAST one pushed); a stack argument that the original pushes from a 16-bit register is a "word" (only its low 16 bits are
 * meaningful). An address that a record or an object keeps is the 32-bit original address; Fl18Host.resolve turns it into host memory
 * where the function reads through it. GetTickCount (import 0x52a23c) is Fl18Host.tick. Fl18Host.resolve and Fl18Host.tick are called
 * UNCHECKED; only Fl18Host.call may be NULL (the calls then return 0).
 *
 * Host contract (as in FL-21): the Fl25aWorld scalars are a snapshot. A host that backs a callee with real original code must flush the
 * world to the original's memory BEFORE each Fl18Host.call and resync it AFTER the call. A callee that changes `self`, the record table
 * or an object is not exercised by the tests of this slice. Nothing here claims original source structure. */

typedef struct Fl25aWorld {
    uint8_t *records_5bb5e5;   /* records of stride 0x8d: the dword at +0 is the address of the object of record n, the dword at +0x4d is its state */
    uint32_t value_5c39e5;     /* the selector (the event) that the handler dispatches on */
    uint32_t value_5b44f0, value_5b44f4, value_5d0377, value_5d162d, value_5d1631, value_5d1639;   /* 0x4a835c: the announcement globals */
    int16_t word_5a4c08;       /* 0x45841e: tested as a signed word */
} Fl25aWorld;

/* 0x45e1ca: hit test (ret 8): the rows of the object behind [+0x31d] (two loops and a tail rectangle); calls 0x45e4d4 with 0x27ed, 0x27ec or 0x27ef and returns 1, else 0 */
int32_t m45e1ca_hit_test(uint8_t *self, int16_t x, int16_t y, const Fl18Host *host);

/* 0x464792: hit test (ret 0xc; the third argument is the original address of four dwords, a rectangle that it stores into the object): the rectangles of the object of the record, then five rows; calls 0x46465d and 0x464ab5; returns 1 on a hit, else 0 */
int32_t m464792_hit_test(uint8_t *self, int16_t x, int16_t y, uint32_t rect, const Fl25aWorld *world, const Fl18Host *host);

/* 0x4a835c: hit test (ret 0xc; the third argument is the original address of four dwords that it stores into the object): rows of 16 bytes in blocks of 0x90 behind [+0xe94]; calls 0x4a8007 and 0x4a8697; with the flag [+0xe5e] a miss announces through the globals 0x5b44f0, 0x5b44f4, 0x5d162d, 0x5d1631, 0x5d1639 (the world is written) and returns 1 */
int32_t m4a835c_hit_test(uint8_t *self, int16_t x, int16_t y, uint32_t rect, Fl25aWorld *world, const Fl18Host *host);

/* 0x45841e: hit test (ret 0xc; the third argument is the original address of four dwords that it stores into the object; the record is indexed by the word [+0x26]): calls 0x458262, 0x45839e (with the pointers self + 0x3e and the rectangle of the object or of a local) and 0x45879e; returns 1 on a hit, else 0 */
int32_t m45841e_hit_test(uint8_t *self, int16_t x, int16_t y, uint32_t rect, const Fl25aWorld *world, const Fl18Host *host);

/* 0x45565f: events 0x27c7, 0x27c6, 0x27c5, 0x27c4 and 0x27c8 (state machine over the words 0x8a, 0x8c, 0x36, 0x38 of the object and rows of 0x96 bytes of the record object; calls 0x455ab8, 0x455a63, 0x455a0e, 0x455b2e, 0x455c4f; writes the record object). Plain `ret`. */
void m45565f_click_27c4_27c8(uint8_t *self, const Fl25aWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
