#ifndef BLACKMOOR_ORIGINAL_METHODS_FL21B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL21B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-21 (batch b): five large functions of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-19 and FL-20 (see
 * original_methods_fl20b.h, whose conventions apply unchanged and whose Fl18Host from original_methods_fl18.h is reused): each is its
 * own symbol that cites the original address in its leading comment, `self` is the original `this` object as raw bytes at the
 * original offsets, nothing is bounds-checked, and the effects keep the order of the original.
 *
 * Calls into original code go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed). A
 * stack argument that the original pushes from a 16-bit register is a "word": only its low 16 bits are meaningful (every callee of
 * this batch that receives one reads it with movsx / and 0xffff, checked in the disassembly). The locals the original hands to a
 * callee are host pointers; a pointer into `self` is a host pointer into `self`; a pointer into a record object (an address that the
 * original keeps in a record) is the 32-bit original address. Fl18Host.resolve turns such an address into host memory where the
 * function reads through it. GetTickCount (import 0x52a23c) is Fl18Host.tick.
 *
 * The Fl21bWorld scalars are snapshots taken before the call: a function that clears one of them does so in the struct it was given,
 * and an integration host that backs a callee with real original code must resync them after each Fl18Host.call. The blocks and
 * tables (`block_638600`, `records_5bb5e5`, `table_5d1599`, `flags_585801`) are live host memory addressed at the original offsets.
 *
 * Host contract, in both directions: the world is a snapshot, so a host that backs a callee with real original code must flush
 * world->memory (the scalars, and the memory behind the table pointers) to the original's memory BEFORE each Fl18Host.call as well as
 * resync it AFTER the call. The ports store into the world before they call: 0x44da08 state 2 writes 0x5bb57b, 0x5bb59b, 0x5bb59f,
 * 0x5bb5a3, 0x583999, 0x5bb599, 0x5bb595, 0x5c39ff and 0x5bb1ca (value_5bb1ca) and the flag dword of the table at 0x585801 BEFORE it calls
 * 0x42ba3a and 0x44d154, which read them; a host that only resynced after the calls would run those callees on the old values.
 *
 * Fl18Host.tick and Fl18Host.resolve are called UNCHECKED (the ports do not test either pointer for NULL, and a NULL result of resolve is
 * dereferenced); a host supplies both. No port of this batch writes through memory that resolve returned (the record objects are only
 * read; every store goes to `self`, the world or the tables), but a host that hands out a view of the original's memory must still return
 * writable memory if a later change adds such a store. Only Fl18Host.call may be NULL (the calls then return 0).
 * Nothing here claims original source structure. */

/* The globals and tables of the original that the batch touches (named by their address). A table pointer points at the byte that the
 * original address names; for a table that a signed index addresses the caller leaves slack below it. */
typedef struct Fl21bWorld {
    uint8_t *block_638600;        /* 0x4468fe: the globals and tables at 0x638600 .. 0x6388ff (indexed from the byte of 0x638600) */
    uint8_t *table_5d1599;        /* 0x4468fe, 0x44e035, 0x44da08: records of stride 0x4a; the dword at +0 is read, 0x44da08 writes -8 .. +0x1a + the string */
    uint8_t *records_5bb5e5;      /* records of stride 0x8d: the dword at +0 is the address of the object of record n, +0x4d (0x5bb632) is a state dword */
    int32_t origin_x_583186, origin_y_58318a;
    uint32_t value_5cf665, value_5d15e3;
    uint32_t value_5c39e5;        /* 0x48569e: the selector */
    /* 0x44e035 */
    int16_t word_624cdd, word_624cdb;                       /* record index, index of the table at 0x5d1599 */
    uint32_t value_624cec, value_624cf0;                    /* mode, sub-mode */
    uint16_t word_624cf4, word_624cf6, word_624cfc, word_624cfe;   /* two pairs of selectors */
    uint32_t value_624cf8, value_624d00, value_624d04;      /* two flags and the redraw flag (cleared) */
    uint8_t byte_624ce3;                                    /* cleared */
    /* 0x44da08 */
    uint32_t value_5bb1ca, value_5bb57b, value_5bb59b, value_5bb59f, value_5bb5a3, value_583999;  /* globals it stores */
    uint16_t word_5bb599, word_5bb595, word_5c39ff;          /* words it stores */
    uint8_t *flags_585801;        /* the dword table at 0x585801, indexed by a signed word (the caller leaves slack below) */
    const uint8_t *bytes_5495bc;  /* the zero-terminated string at 0x5495bc (copied into the table entry) */
    const uint8_t *bytes_5495f0, *bytes_5495fc, *bytes_549608;   /* the nine bytes that a record field is compared with (three variants) */
} Fl21bWorld;

void m4468fe_draw_clock(Fl21bWorld *world, const Fl18Host *host);
int32_t m47f421_pointer_hit(uint8_t *self, int16_t x, int16_t y, const uint8_t *rect, const Fl21bWorld *world, const Fl18Host *host);
void m48569e_handle_key(uint8_t *self, Fl21bWorld *world, const Fl18Host *host);
void m44e035_draw_panel(Fl21bWorld *world, const Fl18Host *host);
void m44da08_run_state(uint8_t *self, int16_t index, Fl21bWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
