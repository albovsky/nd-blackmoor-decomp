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
} Fl20bWorld;

void m446688_draw_digits(Fl20bWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
