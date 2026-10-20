#ifndef BLACKMOOR_ORIGINAL_METHODS_FL33C_H
#define BLACKMOOR_ORIGINAL_METHODS_FL33C_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-33 (batch c): six pending functions of GAME.EXE (SHA-256 afd337a2...5c45) around 0x4c6929, 0x416af3, 0x4db38a, 0x4d2c20, 0x4f379c and 0x4c36b2 ported one to one, in the style of FL-33a (see
 * original_methods_fl33a.h, whose conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading
 * comment, `self` is the original object (ecx) as raw bytes at the original offsets, and the effects keep the order of the original. The names are descriptive hints, not recovered source names.
 *
 * Calls into original code, the CRT and the imports go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first argument of a C prototype). A dword
 * that holds an address of the original is a 32-bit original address and goes through Fl18Host.resolve; the address of a local that the original passes to a callee is a host pointer. Strings and tables
 * that live in the original's data are read through Fl18Host.resolve / the world pointers; no original bytes are in this file. A callee that changes `self` or a global that the function reads again
 * afterwards is not exercised (tasks/fl33c-handoff.md). Functions that can fault, run endlessly or read an indeterminate stack slot in the original return an int status: 0 = ran as the original,
 * 1 = the port stops where the original would fault / never finish / use garbage (documented per function; the host must not rely on anything after a 1).
 * Nothing here claims original source structure. */

typedef struct Fl33cWorld {
    int16_t word_63a4cd, word_639895;     /* 0x4c6929 (both), 0x4d2c20 .. */
    /* WORLD-END */
} Fl33cWorld;

/* 0x4c6929, thiscall, `ret 0x1c`, stack arguments a ([ebp+8], an original address of an object), b ([ebp+0xc]), c ([ebp+0x10], an original address of a byte mask), r1 ([ebp+0x14]), r2 ([ebp+0x18]),
 * r3 ([ebp+0x1c]) (original addresses of four dwords each, unaligned: x0 y0 x1 y1) and d ([ebp+0x20]).
 * When the signed word 0x63a4cd != 0 (a debug check, a word compare): dx1 = r1.x1 - r1.x0, dy1 = r1.y1 - r1.y0, dx2, dy2 likewise for r2 (32-bit); when dx1 != dx2 or dy1 != dy2: 0x50ca3e(msg, 0x555054, d, r1.x0,
 * r1.y0, r1.x1, r1.y1, r2.x0, r2.y0, r2.x1, r2.y1) (cdecl, 11 arguments, msg = a 0x120-byte local, a host pointer), 0x52139c(msg, 0, 0) (stdcall, 3 arguments) and 0x4c97b4(this self); else, when a == 0 or b == 0: the
 * same three calls with the format 0x5550e8; either way nothing else happens. Otherwise (and for equal sizes with a, b != 0): 0x4c4067(this self, b, r2, desc, d, 0x20) (thiscall, 5 arguments; desc = a 0x80-byte
 * local, a host pointer; the callee stores dword v1 at desc+0x10 and dword v2 at desc+0x24). hw = signed word [a+0x2f] (unaligned); sstep = hw / 2 (C division, truncated toward zero), dstep = v1 / 2;
 * src = dword [a] + r1.y0 * hw + r1.x0 * (signed word 0x639895), mask = c + r3.y0 * (r3.x1 + 1) + r3.x0, dst = v2 (all 32-bit original addresses); rows = r1.y1 - r1.y0 + 1, cols = r1.x1 - r1.x0 + 1 (32-bit, SIGNED
 * compares): for each row (while the row number < rows) for each column (while the column number < cols): when the byte at mask + column is non-zero, the word at dst + 2 * column = the word at src + 2 * column;
 * after each row src += 2 * sstep, dst += 2 * dstep, mask += r3.x1 + 1. Then 0x4c4202(this self, b, r2, 0x555164) (thiscall, 3 arguments) and, when b == dword [self+0xc], 0x4c952f(this self, r2) (thiscall, 1
 * argument). The local desc is zero filled here (the original leaves stack garbage there except the two dwords the callee stores). With the debug word zero and a == 0 the original reads the word at address 0x2f
 * after the first callee and faults: the port returns 1 right after the call to 0x4c4067 and changes nothing else. The pointers (a, c, r1, r2, r3 and the three addresses above) must be original addresses that
 * Fl18Host.resolve can resolve, like the original dereferences them. */
int m4c6929_copy_masked(uint8_t *self, uint32_t a, uint32_t b, uint32_t c, uint32_t r1, uint32_t r2, uint32_t r3, uint32_t d, const Fl33cWorld *world, const Fl18Host *host);

/* FNS-END */

#ifdef __cplusplus
}
#endif

#endif
