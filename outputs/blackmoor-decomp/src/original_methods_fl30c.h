#ifndef BLACKMOOR_ORIGINAL_METHODS_FL30C_H
#define BLACKMOOR_ORIGINAL_METHODS_FL30C_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-30 (batch c): methods of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-29 batch c (see original_methods_fl29c.h, whose conventions apply
 * unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment, nothing is bounds
 * checked, and the effects keep the order of the original. The names are descriptive hints, not recovered source names.
 *
 * Calls into original code and into the imports go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first argument of a C
 * prototype); a host that binds them to other m<va>_* symbols says so itself. Host contract: the Fl30cWorld scalars are a snapshot; a host that backs a callee with real original
 * code must flush the world to the original's memory BEFORE each Fl18Host.call and resync it AFTER the call. A callee that changes `self` or a global that the function reads again
 * afterwards is not exercised (tasks/fl30c-handoff.md). Pointer-valued stack arguments are host pointers to the memory they name; 32-bit values stored in objects, cells and tables
 * are original addresses that Fl18Host.resolve turns into memory. Nothing here claims original source structure. */

typedef struct Fl30cWorld {
    int16_t word_63a4cd;       /* the debug flag: a non-zero word turns on the trace calls */
} Fl30cWorld;

/* 0x4fcb5c, thiscall (`self` = ecx), `ret 4`, the stack argument `idx` is a signed dword: the float table at self + 0xb764 (indexed by idx) holds a master volume per category.
 * v = the float at self + 0xb764 + idx*4. v is first clamped from below (x87 compare with 0.0f, constant at 0x52db78): when !(v >= 0.0f), which includes a NaN, the dword becomes 0;
 * otherwise it is rewritten with its own bits. The value just stored is then clamped from above (compare with 1.0f, constant at 0x52cbf4): when !(v > 1.0f) it is rewritten with its own
 * bits, otherwise it becomes 0x3f800000. Then for every channel c = 0 .. 0x1f (a word) at self + c*0x5bb: when the signed word [ch+0x10c] equals idx (sign-extended against the dword) and
 * the unsigned word [ch+0x132] is 1: dword [ch+0x140] = ftol(float [ch+0x138] * v * 2857.142822265625f + (-2857.142857142857)) and dword [ch+0x144] = ftol(float [ch+0x13c] * v * the same
 * constants), where v is read again from the table for every product (x87 with the 53-bit precision control word 0x27f, so each step is one rounding to double: the port uses doubles),
 * constants at 0x52e4e0 (float) and 0x52e4d8 (double), and ftol is the CRT helper 0x50ce04 (fistp with truncation: the low dword of the 64-bit result, 0 for NaN or a value out of the
 * 64-bit range; the helper is original library code that the oracle runs as it is, the port reproduces it with ftol_low32). Then 0x4f684a(this 0x5cf1eb, c sign-extended) (thiscall, one
 * argument) per matching channel; the loop goes on. */
void m4fcb5c_set_category_master(uint8_t *self, int32_t idx, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
