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
    uint32_t value_5d15a5, value_5bb1d2, value_5bb1ce, value_5b15d6, value_5bb1da, value_5bb1d6, value_5b1606;       /* 0x43d7f0 */
    uint8_t byte_5b5158, byte_5b51ab, byte_5b51c6, byte_5b615e, byte_5b61af, byte_5b51f6;
    uint32_t value_5d1a8f, value_5d1ad9, value_5d1b23, value_5d1bb7, value_5d1c01, value_5d1b6d;
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

/* 0x43d7f0, plain `ret` (no arguments; ecx is not read): the start-of-scene initialiser. dword [0x5d15a5] = 1; then 0x4d3ced(this 0x61c387) (thiscall, no arguments); when dword [0x5bb1d2] is
 * not zero: dword [0x5b15d6] = dword [0x5bb1ce] and [0x5bb1d2] = 0; when dword [0x5bb1da] is not zero: dword [0x5b1606] = dword [0x5bb1d6] and [0x5bb1da] = 0; each of the six bytes
 * 0x5b5158, 0x5b51ab, 0x5b51c6, 0x5b615e, 0x5b61af, 0x5b51f6 that is not zero sets its flag dword to 1 (0x5d1a8f, 0x5d1ad9, 0x5d1b23, 0x5d1bb7, 0x5d1c01, 0x5d1b6d in that order). Then the 46
 * initialisers of the other scene objects, each a thiscall with no arguments on its object address, in the order of the table kInitCalls in the source (the first call above is entry 0 of it). The
 * results are ignored, a callee that changes one of the globals above is not exercised. */
void m43d7f0_init_scenes(Fl30cWorld *world, const Fl18Host *host);

/* 0x434025, thiscall (`self` = ecx), plain `ret` (no arguments, no result): builds the table of record offsets of the object. dword [self+0x5f68] = 0; sel = 0 (a local that keeps its value over the
 * whole function); for i = 0 while i < (signed dword [self+0x5f64]) (read again every pass): p = dword [self + 0x1144 + i*4] + 4 (4 = the length of the constant string "DATA" at 0x545e7c, measured by
 * `repne scasb`); n = 0x4347b8(this self, p) (thiscall, one argument); n <= 8 (unsigned): the report 0x42639d(this 0x583979, 0x545e98, 0x545e84) (thiscall, two arguments) and 0x4c97b4(this 0x5cf659),
 * and the function goes on. p += 8; q = 5. Then the loop (the original's `mov eax, 1; test eax, eax; je` guard is always true): when 0x434773(this self, p) (thiscall, one argument) returns 1: for j = 0 while
 * j < (signed dword [self+0x5f64]) (read again): j == i is skipped, and the first j with dword [self + 0x1144 + j*4] == p sets sel = j and ends the scan; then p += dword [self + 0x3084 + sel*4],
 * q += the same dword, and q >= n (unsigned) leaves the loop. Then (also when the call did not return 1): a signed dword [self+0x5f68] > 0x3e6: the report 0x42639d(this 0x583979, 0x545ed0, 0x545ebc)
 * and 0x4c97b4(this 0x5cf659) (the original goes on); dword [self + 0x20e4 + [self+0x5f68]*4] = p; [self+0x5f68] += 1; p += 4; q += 4; m = 0x4347b8(this self, p); an odd m is made even (+1); p += 4; q += 4;
 * p += m; q += m; q > n (unsigned) leaves the loop, otherwise it goes on. Not bounds checked, as in the original: the entries from index 0x3e8 on overwrite the dwords from self+0x3084 (the table that the
 * loop above reads), and the count is not limited at all; the caller guarantees an object big enough. */
void m434025_scan_entries(uint8_t *self, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
