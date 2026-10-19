#ifndef BLACKMOOR_ORIGINAL_METHODS_FL25B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL25B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-25 (batch b): the larger session input handlers of GAME.EXE (SHA-256 afd337a2...5c45), ported one to one in the style of FL-25
 * (see original_methods_fl24b.h, whose conventions apply unchanged and whose Fl18Host from original_methods_fl18.h is reused): each is
 * its own symbol `m<va>_<name>` that cites the original address in its leading comment, `self` is the original `this` object (ecx) as
 * raw bytes at the original offsets, nothing is bounds-checked, and the effects keep the order of the original. Calls into original code
 * go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed; a "word" argument is pushed
 * from a 16-bit register, only its low 16 bits are meaningful). The Fl25bWorld scalars are a snapshot of the original globals at the
 * address in their name; a pointer is the host memory of the table at that address. Nothing here claims original source structure. */


typedef struct Fl25bWorld {
    uint8_t *records_5bb5e5;   /* records of stride 0x8d: the dword at +0 is the address of the object of record n, the dword at +0x4d its state */
    uint32_t value_5c39e5;     /* the selector (the event) that the handler dispatches on */
    int16_t value_583a29;      /* 0x4cb058: compared with the word [+0x152], stored when it changes */
    uint32_t value_5b44f0, value_5b44f4, value_5d0377, value_5d162d, value_5d1631, value_5d1639;   /* 0x4cb058: the armed globals */
    uint32_t value_571ad3;     /* 0x4cb058: a dword that is copied to 0x5d162d */
    int16_t value_5a4c08;      /* 0x4588ad: the count of the word stack at 0x5a4bd4 */
    uint32_t value_5d03b3;     /* 0x4588ad: the first argument of 0x448d11 */
    uint8_t *words_5a4bd4;     /* 0x4588ad: the word stack (host memory of the table at that address) */
    const uint8_t *bytes_54a5f8, *bytes_54a604, *bytes_54a610, *bytes_54a61c;   /* 0x4588ad: nine-byte constants */
    /* FL25B-WORLD-END */
} Fl25bWorld;

/* 0x455180 (ret 0xc): hit test of the point (x, y) (two words) with a block of four dwords (a pointer, host memory): stores the block, then
 * the rectangles of the record's object (a selected entry or three fixed ones) and a loop over its entries of 0x96 bytes; calls 0x45504b
 * and 0x4554bb with this = self; returns 1 or 0 */
int32_t m455180_hit_test(uint8_t *self, int16_t x, int16_t y, const uint8_t *block, const Fl25bWorld *world, const Fl18Host *host);
/* 0x4cb058 (ret 8): hit test of the point (x, y) (two words) against the entries of the list object at [+0x12] (addresses kept in the
 * object), then its outer rectangle; arms the globals 0x5b44f0.. and 0x5c39e5 (0x27b0 / 0x27b2); returns 1 or 0 */
int32_t m4cb058_hit_test(uint8_t *self, int16_t x, int16_t y, Fl25bWorld *world, const Fl18Host *host);
/* 0x4a3f40 (ret 0xc): hit test of the point (x, y) (two words) with a block of four dwords: stores the block, then scans cells of
 * 16 bytes at three bases of the object (rows of 0x60 bytes, counts from the record's object) and its outer rectangle; calls 0x4a3beb
 * and 0x4a42c0 with this = self; returns 1 or 0 */
int32_t m4a3f40_hit_test(uint8_t *self, int16_t x, int16_t y, const uint8_t *block, const Fl25bWorld *world, const Fl18Host *host);
/* 0x4588ad: events 0x279f, 0x27a4 and 0x27a5 (a record state, a word stack at 0x5a4bd4 with the count 0x5a4c08, nine-byte compares against
 * four constants, a 49-byte copy and the tick; calls 0x448d11, 0x4fb77a, 0x4fb2e3 and 0x458c32) */
void m4588ad_click_279f_27a5(uint8_t *self, Fl25bWorld *world, const Fl18Host *host);
/* FL25B-PROTOS-END */

#ifdef __cplusplus
}
#endif

#endif
