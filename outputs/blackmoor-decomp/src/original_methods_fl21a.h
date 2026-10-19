#ifndef BLACKMOOR_ORIGINAL_METHODS_FL21A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL21A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-21 (batch a): five larger functions of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-19 and FL-20 (see
 * original_methods_fl20c.h, whose conventions apply unchanged and whose Fl18Host from original_methods_fl18.h is reused): each is its
 * own symbol that cites the original address in its leading comment, `self` is the original `this` object as raw bytes at the
 * original offsets, nothing is bounds-checked, and the effects keep the order of the original.
 *
 * Calls into original code go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed). A
 * stack argument that the original pushes from a 16-bit register is a "word": only its low 16 bits are meaningful, unless the leading
 * comment of the port says that the upper half is a deterministic leftover of a register (then the port passes the full dword the
 * original pushes). The locals the original hands to a callee are host pointers. An address that the original keeps in an object or
 * a record is a 32-bit original address: Fl18Host.resolve turns it into host memory where the function reads through it.
 *
 * Fl21aWorld holds by-value snapshots of the original's globals and records: a ported function reads and writes them in the same order
 * as the original, but an integration host that backs a callee with real original code must resync the world from the original's
 * memory after each Fl18Host.call and must also flush it to the original's memory before each call (0x48d914 state 2 writes
 * 0x5bb57b, 0x5bb59b, 0x5bb59f, 0x5bb5a3, 0x583999, 0x5bb599, 0x5bb595, 0x5c39ff and 0x5bb1ca before it calls 0x42ba3a and 0x48d09c, and
 * 0x42caa8 stores its 0x5b4e.. values before 0x42cecd).
 *
 * Fl18Host.resolve is called unchecked (no NULL test; a NULL result is dereferenced) and a host supplies it. Fl18Host.tick is called
 * through a guard that yields 0 when the pointer is NULL, but a host should supply it: 0x48d914 compares the tick with stored deadlines.
 * Where a port writes through memory that resolve returned, resolve must return writable memory: 0x484f42 clears the word [rec+0x2b] of
 * the record object it resolved (0x4cb586, 0x462c39 and 0x48d914 only read through resolve, 0x42caa8 stores into the records table).
 *
 * Nothing here claims original source structure. */

/* The globals and tables of the original that the batch touches (named by their address). A table pointer points at the byte that the
 * original address names; for a table that a signed index addresses the caller leaves slack below it. */
typedef struct Fl21aWorld {
    uint8_t *records_5bb5e5;       /* records of stride 0x8d (record n is addressed by a signed word): +0 dword = the address of the object of the record,
                                      +0x40 byte (0x5bb625), +0x41 dword (0x5bb626), +0x45 / +0x47 / +0x49 / +0x4b words (0x5bb62a ... 0x5bb630), +0x4d dword = state (0x5bb632) */
    uint8_t *table_5d1591;         /* 0x4cb586, 0x48d914: records of stride 0x4a, record n at 0x5d1591 + n * 0x4a (n = a signed word; the caller leaves slack) */
    const uint8_t *string_558c30;  /* 0x4cb586: the zero-terminated string at 0x558c30 that is copied into a record of the table above */
    const uint8_t *string_54e89c;  /* 0x48d914: the zero-terminated string at 0x54e89c */
    const uint8_t *bytes_54e8d4;   /* 0x48d914: the nine bytes at 0x54e8d4 */
    uint8_t *flags_585801;         /* 0x48d914: dwords at 0x585801, indexed by a signed word (the caller leaves slack on both sides) */
    const uint8_t *entries_5b4ea9; /* 0x42caa8: the memory that the dword at 0x5b4ea9 points to: entries of stride 0x42 (indexed by a signed word) */
    const uint8_t *cells_594db5;   /* 0x462c39: cells of stride 0x28 in rows of 0x140 bytes, cell(r, c) = 0x594db5 + r * 0x140 + c * 0x28 */
    int32_t origin_x_583186, origin_y_58318a;
    int16_t word_583a29;           /* 0x4cb586 */
    int16_t word_5b4ea3, word_5b4e89, word_5b4e8b;   /* 0x42caa8: a mode word, the record index, a mode word */
    uint32_t value_5b4e1c, value_5b4e24, value_5b4e18, value_5b4e20, value_5b4e2c, value_5b4e34, value_5b4e28, value_5b4e30;  /* 0x42caa8: written */
    uint32_t value_5b4e5c, value_5b4e64, value_5b4e58, value_5b4e60, value_5d1967;                                              /* 0x42caa8: written */
    uint32_t value_5bb1ca, value_583999;                                    /* 0x48d914: written */
    uint32_t value_5bb57b, value_5bb59b, value_5bb59f, value_5bb5a3;       /* 0x48d914: written */
    uint16_t word_5bb599, word_5bb595, word_5c39ff;                         /* 0x48d914: written */
    uint8_t byte_63a8ac;           /* 0x48d914: read (the byte that the first byte of a record's string is compared with) */
} Fl21aWorld;

void m4cb586_visit(uint8_t *self, int16_t index, Fl21aWorld *world, const Fl18Host *host);
void m42caa8_clip_rect(int16_t index, const uint8_t *clip, Fl21aWorld *world, const Fl18Host *host);
int32_t m462c39_pointer_move(uint8_t *self, int16_t x, int16_t y, const Fl21aWorld *world, const Fl18Host *host);
int32_t m484f42_pointer_move(uint8_t *self, int16_t x, int16_t y, const uint8_t *rect, const Fl21aWorld *world, const Fl18Host *host);
void m48d914_step_scene(uint8_t *self, int16_t index, Fl21aWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
