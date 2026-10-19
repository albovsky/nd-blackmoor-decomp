#ifndef BLACKMOOR_ORIGINAL_METHODS_FL24B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL24B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-24 (batch b): twelve more handlers of GAME.EXE (SHA-256 afd337a2...5c45), ported one to one in the style of FL-23 (see
 * original_methods_fl23b.h, whose conventions apply unchanged and whose Fl18Host from original_methods_fl18.h is reused): each is its
 * own symbol `m<va>_<name>` that cites the original address in its leading comment, `self` is the original `this` object (ecx) as raw
 * bytes at the original offsets, nothing is bounds-checked, and the effects keep the order of the original.
 *
 * Calls into original code go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed). A
 * stack argument that the original pushes from a 16-bit register is a "word" (only its low 16 bits are meaningful). An import is called
 * through Fl18Host.call with its IAT slot as the callee (this_ptr 0). Fl18Host.resolve turns an address that a record keeps into host
 * memory. The Fl24bWorld scalars are a snapshot of the original globals at the address in their name (the world is passed non-const
 * where the function stores to a global); a pointer is the host memory of the table at that address. Host contract as in FL-21:
 * flush the world to the original's memory before each Fl18Host.call and resync it afterwards. Nothing here claims original source
 * structure. */

typedef struct Fl24bWorld {
    uint8_t *records_5bb5e5;   /* records of stride 0x8d: the dword at +0 is the address of the object of record n, the dword at +0x4d its state */
    uint32_t value_5c39e5;     /* the selector (the event) that the handler dispatches on */
    uint32_t value_5bb1ca;     /* a flag: non-zero = compare a record field with a constant and maybe announce it through 0x4fb2e3 */
    uint8_t value_58321d, value_58321e;
    const uint8_t *bytes_54b54c;   /* the nine bytes at 0x54b54c (0x466073) */
    /* FL24B-WORLD-END */
} Fl24bWorld;

/* 0x4dad60: constructor-style init of a 0x28-byte object (stores, then GetSystemMetrics(0x17) through the import slot 0x52a498) */
void m4dad60_init_swap_buttons(uint8_t *self, Fl24bWorld *world, const Fl18Host *host);
/* 0x466073: events 0x27d3 and 0x27d2 (the second switches on the word [+0x28], 1 to 4, then compares the 49-byte copy of a record field) */
void m466073_click_27d2_27d3(uint8_t *self, Fl24bWorld *world, const Fl18Host *host);
/* FL24B-PROTOS-END */

#ifdef __cplusplus
}
#endif

#endif
