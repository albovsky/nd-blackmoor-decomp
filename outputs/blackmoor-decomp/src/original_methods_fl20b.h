#ifndef BLACKMOOR_ORIGINAL_METHODS_FL20B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL20B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-20 (batch b): more scene-session methods of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-19 (see
 * original_methods_fl19b.h, whose conventions apply unchanged and whose Fl18Host from original_methods_fl18.h is reused): each is its
 * own symbol that cites the original address in its leading comment, `self` is the original `this` object as raw bytes at the
 * original offsets, nothing is bounds-checked, and the effects keep the order of the original.
 *
 * Calls into original code go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed). A
 * stack argument that the original pushes from a 16-bit register is a "word": only its low 16 bits are meaningful. The locals the
 * original hands to a callee are host pointers. An address that the original keeps in an object or a record is a 32-bit original
 * address: Fl18Host.resolve turns it into host memory where the function reads through it.
 *
 * Nothing here claims original source structure. */

/* The globals and tables of the original that the batch touches (named by their address). A table pointer points at the byte that the
 * original address names; for a table that a signed index addresses the caller leaves slack below it. */
typedef struct Fl20bWorld {
    uint8_t *block_638600;          /* 0x446688: the globals and tables at 0x638600 .. 0x6388ff (indexed from the byte of 0x638600) */
    const uint8_t *table_5d1599;    /* 0x446688: records of stride 0x4a, the dword at +0 is used */
    int32_t origin_x_583186, origin_y_58318a;
    uint32_t value_5cf665, value_5d15e3;
    uint8_t *records_5bb5e5;        /* 0x48d5f4: dwords of stride 0x8d (the address of the object of record n; record +0x4d is also used in place) */
    uint32_t value_5c39e5, value_5bb1ca, value_54e898, value_5d03b3;  /* 0x48d5f4: the selector, a flag, the 4 bytes appended to the message, the first argument of the message call */
    const uint8_t *bytes_54e88c;    /* 0x48d5f4: the nine bytes that a record field is compared with */
    int16_t word_6246ac, word_6246b4, word_6246b6, word_6246c7, word_6246c9;  /* 0x48cc70: record index, two table indices, two offsets */
    uint8_t byte_6246a2, byte_6246a3, byte_6246c6;                           /* 0x48cc70: selected slot, gate, flag */
    const uint8_t *bytes_6246ba, *bytes_6246be, *bytes_6246c2;               /* 0x48cc70: four flag bytes each, indexed by the slot */
    const uint8_t *items_6252d5;    /* 0x4876ed: items of stride 0x85 (indexed by a signed word; the caller leaves slack below) */
    int16_t word_6252d3, word_625d4b;                                        /* 0x4876ed: record index, the selected item */
    uint32_t value_625d43, value_625d3f, value_625d47, value_625e40, value_625e3c, value_6252cf, value_6252cb;  /* 0x4876ed: flags and two draw arguments */
} Fl20bWorld;

void m446688_draw_digits(Fl20bWorld *world, const Fl18Host *host);
void m4876ed_redraw_items(Fl20bWorld *world, const Fl18Host *host);
void m48cc70_draw_slots(const Fl20bWorld *world, const Fl18Host *host);
void m48d5f4_confirm_pick(uint8_t *self, Fl20bWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
