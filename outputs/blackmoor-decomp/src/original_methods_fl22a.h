#ifndef BLACKMOOR_ORIGINAL_METHODS_FL22A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL22A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-22 (batch a): four of the largest functions of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-21 (see
 * original_methods_fl21a.h, whose conventions apply unchanged): each is its own symbol that cites the original address in its leading
 * comment, `self` is the original `this` object as raw bytes at the original offsets, nothing is bounds-checked, and the effects keep the
 * order of the original. Fl18Host from original_methods_fl18.h is reused: Fl18Host.call (callee address, ecx value, stack arguments with
 * args[0] the LAST one pushed), Fl18Host.resolve (the original address kept in a record -> host memory, called unchecked) and Fl18Host.tick
 * (GetTickCount). A stack argument that the original pushes from a 16-bit register is a "word": only its low 16 bits are meaningful.
 *
 * Fl22aWorld holds by-value snapshots of the original's globals and pointers to its tables: a ported function reads and writes them in the
 * same order as the original, but an integration host that backs a callee with real original code must resync the world from the original's
 * memory after each Fl18Host.call and flush it to the original's memory before each call (0x463392 state 2 writes 0x5bb57b ... 0x583999
 * and 0x5bb1ca before it calls 0x42ba3a).
 *
 * Nothing here claims original source structure. */

/* The globals and tables of the original that the batch touches (named by their address). A table pointer points at the byte that the
 * original address names; for a table that a signed index addresses the caller leaves slack below it. */
typedef struct Fl22aWorld {
    uint8_t *records_5bb5e5;       /* records of stride 0x8d (record n is addressed by a signed word): +0 dword = the address of the object of the record,
                                      +0x4d dword = state (0x5bb632) */
    uint8_t *table_5d1591;         /* records of stride 0x4a, record n at 0x5d1591 + n * 0x4a (n = a signed word; the caller leaves slack) */
    const uint8_t *data_54b164;    /* 0x463392: the constant bytes of the image from 0x54b164 (a zero-terminated string) up to 0x54b210 (0xac bytes): the
                                      nine-byte patterns at 0x54b1a4, 0x54b1b0, 0x54b1bc, 0x54b1c8, 0x54b1d4, 0x54b1e0, 0x54b1ec, 0x54b1f8, 0x54b204 */
    uint8_t *flags_585801;         /* dwords at 0x585801, indexed by a signed word (the caller leaves slack on both sides) */
    uint32_t value_5bb1ca, value_583999;                                    /* 0x463392: written */
    uint32_t value_5bb57b, value_5bb59b, value_5bb59f, value_5bb5a3;       /* 0x463392: written */
    uint16_t word_5bb599, word_5bb595, word_5c39ff;                         /* 0x463392: written */
} Fl22aWorld;

void m463392_step_scene(uint8_t *self, int16_t index, Fl22aWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
