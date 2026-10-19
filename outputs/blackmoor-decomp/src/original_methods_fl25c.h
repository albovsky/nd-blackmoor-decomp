#ifndef BLACKMOOR_ORIGINAL_METHODS_FL25C_H
#define BLACKMOOR_ORIGINAL_METHODS_FL25C_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-25 (batch c): the larger session input handlers of GAME.EXE (SHA-256 afd337a2...5c45), ported one to one in the style of FL-25
 * (see original_methods_fl24b.h, whose conventions apply unchanged and whose Fl18Host from original_methods_fl18.h is reused): each is
 * its own symbol `m<va>_<name>` that cites the original address in its leading comment, `self` is the original `this` object (ecx) as
 * raw bytes at the original offsets, nothing is bounds-checked, and the effects keep the order of the original. Calls into original code
 * go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed; a "word" argument is pushed
 * from a 16-bit register, only its low 16 bits are meaningful). The Fl25cWorld scalars are a snapshot of the original globals at the
 * address in their name; a pointer is the host memory of the table at that address. Nothing here claims original source structure. */


typedef struct Fl25cWorld {
    uint8_t *records_5bb5e5;   /* records of stride 0x8d: the dword at +0 is the address of the object of record n, the dword at +0x4d its state */
    uint32_t value_5c39e5;     /* the selector (the event) that the handler dispatches on */
    /* FL25C-WORLD-FIELDS */
    uint32_t value_5bb202, value_5d03b3, value_550e50;   /* 0x4aa3d2: a flag dword, the first argument of 0x448d11, the dword stored after a copied string */
    uint8_t *buf_630a60;                                  /* 0x4aa3d2: the byte array at that address (host memory) */
    const uint8_t *bytes_550e2c, *bytes_550e38, *bytes_550e44;   /* 0x4aa3d2: nine-byte constants */
    uint32_t value_5bb1ca;     /* 0x4a8818: a flag dword (non-zero: the nine-byte compares and the callee calls are made) */
    uint8_t *buf_5a110f;       /* 0x4a8818: the 0x1e6-byte buffer at that address (host memory), a copy of self + 0xa40 */
    const uint8_t *bytes_550bac, *bytes_550bb8;   /* 0x4a8818: nine-byte constants */
    uint8_t *buf_5a14df;                                  /* 0x46c6a9: the 0x140-byte buffer at that address (host memory) */
    const uint8_t *bytes_54bd00, *bytes_54bd0c;           /* 0x46c6a9: nine-byte constants */
    uint8_t *buf_591a28;                                  /* 0x4a44c0: the word matrices at 0x591a28 and 0x591a64 (0x3c bytes apart) as one area (host memory) */
    const uint8_t *bytes_550570, *bytes_55057c, *bytes_550588;   /* 0x4a44c0: nine-byte constants */
    /* FL25C-WORLD-END */
} Fl25cWorld;

/* 0x4a8818: events 0x279a, 0x2798 and 0x2799 (record state, a 6-byte cell of the object, two nine-byte compares, calls 0x4f6334, 0x4fb2e3
 * and 0x4a8bf2, a 0x1e6-byte copy to the buffer at 0x5a110f and a loop over its cells) */
void m4a8818_click_2798_279a(uint8_t *self, Fl25cWorld *world, const Fl18Host *host);
/* 0x4aa3d2: events 0x276f, 0x2770 and 0x2771 (a record state, nine-byte compares against three constants, strlen and a copy into a local
 * buffer; calls 0x4fb2e3, 0x4fb77a, 0x423259 and 0x448d11). Rejects instead of overrunning its 0xcc-byte buffer (see the .c file). */
void m4aa3d2_click_276f_2771(uint8_t *self, Fl25cWorld *world, const Fl18Host *host);
/* 0x46c6a9: events 0x27e2 .. 0x27e6, 0x27e8 and 0x27ea (a table of 16-byte cells at [+0x48a0], two nine-byte compares, calls 0x46cc8b, 0x4f6334 and
 * 0x4fb2e3, a 0x140-byte copy to the buffer at 0x5a14df) */
void m46c6a9_click_27e2_27ea(uint8_t *self, Fl25cWorld *world, const Fl18Host *host);
/* 0x4a44c0: events 0x274c .. 0x274f (a switch through a jump table on a word of a global matrix, a signed division by a byte of the record object,
 * three nine-byte compares; calls 0x4f6334, 0x4fb2e3 and 0x4a4d55). Rejects the divide error of the original (see the .c file). */
void m4a44c0_click_274c_274f(uint8_t *self, Fl25cWorld *world, const Fl18Host *host);
/* FL25C-PROTOS-END */

#ifdef __cplusplus
}
#endif

#endif
