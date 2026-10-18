#ifndef BLACKMOOR_ORIGINAL_METHODS_FL20C_H
#define BLACKMOOR_ORIGINAL_METHODS_FL20C_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-20 (batch c): more functions of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-19 and FL-20b (see
 * original_methods_fl19b.h, whose conventions apply unchanged and whose Fl18Host from original_methods_fl18.h is reused): each is its
 * own symbol that cites the original address in its leading comment, `self` is the original `this` object as raw bytes at the
 * original offsets, nothing is bounds-checked, and the effects keep the order of the original.
 *
 * Calls into original code go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed). A
 * stack argument that the original pushes from a 16-bit register is a "word": only its low 16 bits are meaningful, unless the leading
 * comment of the port says that the upper half is a deterministic leftover of a register (then the port passes the full dword the
 * original pushes). The locals the original hands to a callee are host pointers. An address that the original keeps in an object or
 * a record is a 32-bit original address: Fl18Host.resolve turns it into host memory where the function reads through it.
 *
 * Fl20cWorld holds by-value snapshots of the original's globals and records: a ported function reads and writes them in the same order
 * as the original, but an integration host that backs a callee with real original code must resync the world from the original's
 * memory after each Fl18Host.call (for example the real 0x4b8e42 writes slot state 3, which 0x4b9a88 re-reads in a later turn).
 *
 * Nothing here claims original source structure. */

/* The globals and tables of the original that the batch touches (named by their address). A table pointer points at the byte that the
 * original address names; for a table that a signed index addresses the caller leaves slack below it. */
typedef struct Fl20cWorld {
    uint8_t *records_5bb5e5;       /* dwords of stride 0x8d: the address of the object of record n (n = a signed word) */
    uint8_t *cells_594db5;         /* 0x4619be, 0x463b10: cells of stride 0x28 in rows of 0x140 bytes, cell(r, c) = this + r * 0x140 + c * 0x28 (signed indices; the caller leaves slack) */
    const uint8_t *table_5d1599;   /* records of stride 0x4a, the dword at +0 is used (indexed by a signed word) */
    uint8_t *slots_61eeb8;         /* 0x4b9a88: slots of stride 0x37 (the slot array of the singleton at 0x61ee6e: its slot n is at +0x4a + n * 0x37) */
    int32_t origin_x_583186, origin_y_58318a, origin_x2_58318e, origin_y2_583192;
    uint32_t value_5cf665, value_5d15e3, value_5d0357;
    uint32_t value_61ee82, value_61ee8e, value_61eea2, value_61ee76;  /* 0x4b9a88: two flags, a flag that is cleared, the address of the owner object */
    const uint8_t *slots_62669c;   /* 0x481cb9: slots of stride 0x25 (indexed by a signed word; the caller leaves slack below) */
    const uint8_t *table_625f08;   /* 0x481cb9: the dword table at 0x625f08 (entries 0x18 apart in groups of 0x60) */
    int16_t word_625f06, word_62728a, word_627238;   /* 0x481cb9: record index, number of cells, the selected cell */
    uint32_t value_627230, value_62722c, value_627234, value_62728c, value_627290, value_627294;  /* 0x481cb9: flags and three draw arguments */
    uint8_t byte_627299, byte_62729a, byte_62729b;   /* 0x481cb9: flags */
    int16_t word_61d797, word_61d795, word_61d7b2;   /* 0x463b10: record index, index of the dword table at 0x5d1599, the selected marker */
    uint32_t value_61d79d, value_61d7b4;             /* 0x463b10: two mode flags */
    uint32_t value_61d7a2, value_61d7a6, value_61d7aa, value_61d7ae;  /* 0x463b10: the rectangle of the marker (x0, y0, x1, y1) */
    const uint8_t *records_5adb3a; /* 0x412db8: font records of stride 0x1d0 (indexed by a signed word; the word at +2 is read) */
    const uint8_t *dwords_5d032f;  /* 0x412db8: dwords indexed by a signed word */
    int16_t word_63a4cd;           /* 0x412db8: a flag word */
    int16_t word_61ee72;           /* 0x4b9a88: index of the dword table at 0x5d1599 */
} Fl20cWorld;

void m4b9a88_draw_slots(Fl20cWorld *world, const Fl18Host *host);
void m412db8_wrap_text(uint8_t *self, uint8_t *text, int16_t font, uint8_t *flag, uint8_t *x, int16_t limit_e, int16_t limit_f, uint8_t *y,
                       uint32_t arg8, int16_t arg9, uint32_t arg10, const Fl20cWorld *world, const Fl18Host *host);
void m463b10_draw_grid(Fl20cWorld *world, const Fl18Host *host);
void m481cb9_draw_cells(Fl20cWorld *world, const Fl18Host *host);
int32_t m4619be_check_direction(uint8_t *self, int16_t direction, const Fl20cWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
