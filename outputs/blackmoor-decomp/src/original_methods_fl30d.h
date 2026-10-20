#ifndef BLACKMOOR_ORIGINAL_METHODS_FL30D_H
#define BLACKMOOR_ORIGINAL_METHODS_FL30D_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-30 (batch d): methods of GAME.EXE (SHA-256 afd337a2...5c45) of 421 to 751 bytes ported one to one, in the style of FL-29 batch a (see original_methods_fl29a.h,
 * whose conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading
 * comment, `self` is the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked except where a native rejection is named, and the effects
 * keep the order of the original. The names are descriptive hints, not recovered source names.
 *
 * Calls into original code, the CRT and the imports go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first
 * argument of a C prototype). An argument that is an address of the original (a string, a cell, a record) is a 32-bit original address here, as in the original;
 * Fl18Host.resolve turns it into host memory when the function reads or writes through it. Only `self` and the Fl30dWorld pointers are host pointers. A callee that
 * changes `self` or a global that the function reads again afterwards is not exercised (tasks/fl30d-handoff.md). Nothing here claims original source structure. */

#define FL30D_BLOCK_5A1E54_SIZE 0x2540u   /* bytes of the mirror of the globals 0x5a1e54 .. 0x5a4394 that 0x4e2e05 writes */

typedef struct Fl30dWorld {
    uint8_t *block_5a1e54;     /* 0x4e2e05: host mirror of the original addresses 0x5a1e54 .. 0x5a1e54 + FL30D_BLOCK_5A1E54_SIZE (the destination globals) */
    uint8_t byte_63a9e4;       /* 0x4e2e05: first byte compared with the first byte of the string at self + 0x139d */
    uint8_t byte_63a9e8;       /* 0x4e2e05: first byte compared with the first byte of the string at self + 0x13e3 */
} Fl30dWorld;

/* 0x4e2e05, thiscall, plain `ret`, no result. Native rejection (NOT original behaviour): when the signed word [self+0x1471] is negative, or its product with 0x29 does not fit
 * between 0x5a1e62 and the end of the mirror, the original would copy a huge or out-of-table byte count over its globals; the port returns 1 and does nothing at all. Otherwise
 * returns 0 and: dword [0x5a1e54] = dword [0x5a1e58] = 0; the n = word * 0x29 bytes at self + 0x457b are copied to 0x5a1e62 (dwords then bytes); word [0x5a1e5c] = the word;
 * 0x4e3ade(this self) (thiscall, 0 arguments). Then, when byte [self+0x139d] != byte 0x63a9e4: word [0x5a1e5e] = 1, the NUL-terminated strings (NUL included) at self + 0x139d
 * and self + 0x13be are copied to 0x5a2664 and 0x5a2685 (in this order, so a first string over 0x21 bytes is overwritten by the second), word [0x5a26a6] = word [self+0x13df], word
 * [0x5a26a8] = word [self+0x13e1], dword [0x5a26aa] = 0; otherwise word [0x5a1e5e] = 0. Then, when byte [self+0x13e3] != byte 0x63a9e8: word [0x5a1e60] = 1, the string at
 * self + 0x13e3 is copied to 0x5a434c, dword [0x5a4371] = sign-extended word [self+0x1404], word [0x5a436d] = word [self+0x1406], word [0x5a436f] = word [self+0x1408] (in this
 * order, the dword at 0x5a4371 overlaps nothing of the others); otherwise word [0x5a1e60] = 0. */
int32_t m4e2e05_copy_state(uint8_t *self, const Fl30dWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
