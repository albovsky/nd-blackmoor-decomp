#ifndef BLACKMOOR_ORIGINAL_METHODS_FL24A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL24A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-24 (batch a): more session input handlers of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-23 (see
 * original_methods_fl23b.h, whose conventions apply unchanged and whose Fl18Host from original_methods_fl18.h is reused): each is
 * its own symbol that cites the original address in its leading comment, `self` is the original `this` object (ecx) as raw bytes at the
 * original offsets, nothing is bounds-checked, and the effects keep the order of the original.
 *
 * Calls into original code go through Fl18Host.call (callee address, ecx value (0 for a cdecl callee), stack arguments with args[0]
 * the LAST one pushed); a stack argument that the original pushes from a 16-bit register is a "word" (only its low 16 bits are
 * meaningful). An address that a record or an object keeps is the 32-bit original address; Fl18Host.resolve turns it into host memory
 * where the function reads through it. GetTickCount (import 0x52a23c) is Fl18Host.tick. Fl18Host.resolve and Fl18Host.tick are called
 * UNCHECKED; only Fl18Host.call may be NULL (the calls then return 0).
 *
 * Host contract (as in FL-21): the Fl24aWorld scalars are a snapshot. A host that backs a callee with real original code must flush the
 * world to the original's memory BEFORE each Fl18Host.call and resync it AFTER the call. A callee that changes `self`, the record table
 * or an object is not exercised by the tests of this slice. Nothing here claims original source structure. */

typedef struct Fl24aWorld {
    uint8_t *records_5bb5e5;   /* records of stride 0x8d: the dword at +0 is the address of the object of record n, the dword at +0x4d is its state */
    uint32_t value_5c39e5;     /* the selector (the event) that the handler dispatches on */
    uint32_t value_5bb1ca;     /* a flag: non-zero = compare a record field with a constant and maybe announce it through 0x4f6334 / 0x4fb2e3 */
    const uint8_t *bytes_549824, *bytes_54c140;   /* the nine bytes that a field of the object is compared with (repe cmpsb, ecx = 9) */
    uint8_t byte_61c6ae;       /* 0x4d3bef: tested as a byte */
    uint8_t *flags_585801;     /* the dword table at 0x585801, indexed by a signed word (0x4cb3ab); the caller leaves slack on both sides */
    int16_t word_63a4cd;       /* 0x4cb3ab: tested as a signed word */
    uint32_t value_5d03b3;     /* 0x46ebff: the dword passed to 0x448d11 */
    uint32_t value_61d3c2;     /* 0x4a6574: the tail compares it with 6 */
    uint32_t value_5b44f0, value_5b44f4, value_5d0377, value_5d162d, value_5d1631, value_5d1639;   /* 0x470ffe: the announcement globals */
    const uint8_t *bytes_550964;   /* 0x4a6946: the nine bytes that the kept string is compared with */
} Fl24aWorld;

/* 0x4d3bef: clears [+0x462]; sets [+0x1c] when the byte at 0x61c6ae is non-zero */
void m4d3bef_reset_flags(uint8_t *self, const Fl24aWorld *world);
/* 0x44edfb: events 0x2787, 0x2786 and 0x2785, then the announcement with the flag at 0x5bb1ca (tick, 0x4f6334, 0x4fb2e3) */
void m44edfb_click_2785_2787(uint8_t *self, const Fl24aWorld *world, const Fl18Host *host);
/* 0x4cb3ab: no selector; stores into the flag table and prints through the cdecl 0x50ca3e and 0x44a2b7 */
void m4cb3ab_store_flag(uint8_t *self, const Fl24aWorld *world, const Fl18Host *host);
/* 0x44eab1: hit test (ret 8) over the rectangles of the object of the record; calls 0x44ecaf and returns 1, else 0 */
int32_t m44eab1_hit_test(uint8_t *self, int16_t x, int16_t y, const Fl24aWorld *world, const Fl18Host *host);
/* 0x46ebff: events 0x27c2 and 0x27c3 (tick, 0x4f6334, 0x4fb2e3, 0x4709bb, 0x4709de, 0x448d11) */
void m46ebff_click_27c2_27c3(uint8_t *self, const Fl24aWorld *world, const Fl18Host *host);
/* 0x4571e1: hit test (ret 8): three rectangles with margins, a loop of rectangles (the one at the index of the word [+0x2a] is silent) and
 * a last rectangle; calls 0x45741d and returns 1, else 0 */
int32_t m4571e1_hit_test(uint8_t *self, int16_t x, int16_t y, const Fl24aWorld *world, const Fl18Host *host);
/* 0x47b4aa: hit test (ret 8) over the three rows behind the signed byte [object + 0x35b] and the item rows; stores [+0x27c], [+0x2b4];
 * calls 0x47b709 and returns 1, else 0 */
int32_t m47b4aa_hit_test(uint8_t *self, int16_t x, int16_t y, const Fl24aWorld *world, const Fl18Host *host);
/* 0x4a6574: hit test (ret 8) over five rectangles of the record object (calls 0x4a67f3) and a tail that sets the byte [+0x20]; returns 1 on a hit, else 0 */
int32_t m4a6574_hit_test(uint8_t *self, int16_t x, int16_t y, const Fl24aWorld *world, const Fl18Host *host);
/* 0x465c99: hit test (ret 8): a row of the record object split at its middle, three rectangles and a last one (calls 0x465f8e with three arguments); returns 1 on a hit, else 0 */
int32_t m465c99_hit_test(uint8_t *self, int16_t x, int16_t y, const Fl24aWorld *world, const Fl18Host *host);
/* 0x482724: events 0x27b6 and 0x27b5 (state machine over the words 0x39e, 0x3a0, 0x3a2, 0x3a4 of the record object; calls 0x482595) */
void m482724_click_27b5_27b6(uint8_t *self, const Fl24aWorld *world, const Fl18Host *host);
/* 0x470ffe: hit test (ret 8) over the rectangles of the record object and of the object itself; a hit announces through the globals 0x5b44f0, 0x5b44f4, 0x5d162d, 0x5d1631, 0x5d1639 and 0x5c39e5 (the world is written) */
int32_t m470ffe_hit_test(uint8_t *self, int16_t x, int16_t y, Fl24aWorld *world, const Fl18Host *host);
/* 0x4a6946: events 0x2770 and 0x276f (a four-way switch on [+0x25] - 1 with a jump table inside the span; strings copied into a local buffer, then the announcement through 0x4f6334 and 0x4fb2e3) */
void m4a6946_click_276f_2770(uint8_t *self, const Fl24aWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
