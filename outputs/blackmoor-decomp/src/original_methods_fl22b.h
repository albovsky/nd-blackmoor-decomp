#ifndef BLACKMOOR_ORIGINAL_METHODS_FL22B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL22B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-22 (batch b): large functions of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-21 (see
 * original_methods_fl21b.h, whose conventions apply unchanged and whose Fl18Host from original_methods_fl18.h is reused): each is its
 * own symbol that cites the original address in its leading comment, `self` is the original `this` object as raw bytes at the
 * original offsets, nothing is bounds-checked, and the effects keep the order of the original.
 *
 * Calls into original code go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed). A
 * stack argument that the original pushes from a 16-bit register is a "word": only its low 16 bits are meaningful. The locals the
 * original hands to a callee are host pointers; a pointer into a record object (an address that the original keeps in a record) is the
 * 32-bit original address. Fl18Host.resolve turns such an address into host memory where the function reads through it. GetTickCount
 * (import 0x52a23c) is Fl18Host.tick.
 *
 * Host contract (as in FL-21): the Fl22bWorld scalars are a snapshot. A host that backs a callee with real original code must flush
 * the world (the scalars and the memory behind the table pointers) to the original's memory BEFORE each Fl18Host.call and resync it
 * AFTER the call, because the ports store into the world before they call. Fl18Host.resolve and Fl18Host.tick are called UNCHECKED; only
 * Fl18Host.call may be NULL (the calls then return 0). Nothing here claims original source structure. */

typedef struct Fl22bWorld {
    uint8_t *records_5bb5e5;      /* records of stride 0x8d: the dword at +0 is the address of the object of record n, +0x4d (0x5bb632) is its state dword */
    uint8_t *flags_585801;        /* the dword table at 0x585801, indexed by a signed word (the caller leaves slack below) */
    /* 0x42ed54 */
    uint8_t *bytes_5b5128;        /* the 16 bytes at 0x5b5128 */
    uint8_t *words_5b5138;        /* the 16 words at 0x5b5138 (read with a signed word index; the caller keeps the record's count within 16) */
    uint8_t byte_5b5158, byte_5b516a, byte_5b515d;
    uint16_t word_5b5159, word_5b5166, word_5b5168;
    uint32_t value_5b515e, value_5b5162, value_5d03cf, value_5d1a83, value_5d1a8f;
    uint32_t value_5bb1ca, value_5bb57b, value_5bb59b, value_5bb59f, value_5bb5a3, value_583999;
    uint16_t word_5bb599, word_5bb595, word_5c39ff;
    const uint8_t *bytes_545b48, *bytes_545b54, *bytes_545b60;   /* the nine bytes that a record field is compared with (three variants) */
    /* 0x47ff0e */
    uint32_t value_5c39e5;        /* the selector (the event) that the handler dispatches on */
    uint32_t value_5bb202;        /* a flag: non-zero = look up and show the caption strings */
    uint32_t value_5d03b3;        /* pushed as the first argument of 0x448d11 */
    uint32_t dword_54d5b0, dword_54d5b4;   /* the read-only dwords (the bytes "<e>" and a NUL, twice) written over the terminator of a caption string */
    const uint8_t *bytes_54d5a4;  /* the nine bytes that a record field is compared with */
} Fl22bWorld;

void m42ed54_run_state(int16_t index, Fl22bWorld *world, const Fl18Host *host);

/* 0x47ff0e: the result is FL22B_47FF0E_OK, or FL22B_47FF0E_REJECT_LONG_STRING when a caption string (the one that 0x423259 returns, or the
 * record's string at +0x7fa) is longer than the 200 bytes that the original's 0xcc-byte frame buffer can take before it overwrites its own
 * locals (the original overruns its stack frame there: this is a native rejection, not original behaviour); the stores made before the
 * rejected copy stay made and the call to 0x448d11 is not made. */
#define FL22B_47FF0E_OK 0
#define FL22B_47FF0E_REJECT_LONG_STRING 1
int32_t m47ff0e_handle_click(uint8_t *self, Fl22bWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
