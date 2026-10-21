#ifndef BLACKMOOR_ORIGINAL_METHODS_FL36A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL36A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-36 (batch a): two large functions of GAME.EXE (SHA-256 afd337a2...5c45), 0x4f379c and 0x4c36b2, ported one to one in the style of FL-33c (see original_methods_fl33c.h, whose
 * conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in the comment directly above it, `self` is
 * the original object (ecx) as raw bytes at the original offsets, and the effects keep the order of the original. The names are descriptive hints, not recovered source names.
 *
 * Calls into original code, the CRT and the imports go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first argument of a C prototype). A
 * dword that holds an address of the original is a 32-bit original address and goes through Fl18Host.resolve; the address of a local that the original passes to a callee is a host pointer. Strings,
 * tables and records that live in the original's data are read through Fl18Host.resolve; no original bytes are in this file. A callee that changes `self` or a global that the function reads
 * again afterwards is only exercised where the fixtures script it (tasks/fl36a-handoff.md). Functions that can fault, run endlessly, overrun their frame or read an indeterminate stack slot in the
 * original return an int status: 0 = ran as the original, 1 = the port stops where the original would do that (documented per function; the host must not rely on anything after a 1). */

typedef struct Fl36aWorld {
    int16_t word_63a4cd, word_63aa14;                                          /* 0x4f379c (the debug word is also read by 0x4c36b2) */
    /* WORLD-END */
} Fl36aWorld;

/* 0x4f379c, thiscall, `ret 4`, one stack argument id ([ebp+8]; only the low 16 bits are read, zero extended). Returns (eax) the dword [self+0x3be] in every path.
 * local = a 0x24-byte frame area at [ebp-0x24]: the word 0x63aa14 followed by zeros (the original zero fills 30 bytes behind the word). [self+0x3be] = 1, [self+0x3c2] = 0x3e8;
 * entry = dword [self+0x3ce] + id * 0x5bb (32-bit, an original address; every field below is at an offset into entry, unaligned allowed, read through Fl18Host.resolve).
 * When dword [entry+0x162] != 0: 0x4f356e(this self, id) (thiscall, 1 argument). fp = 0x50d0a9(entry + 4, 0x55dab0) (cdecl, 2 arguments); dword [entry+0x156] = fp; fp == 0: [self+0x3c2] = 0x3ed,
 * [self+0x3be] = 0, return 0. Then 0x50cf61(entry + 0x10a, 0x1e, 1, fp) (cdecl, 4 arguments) == 0: [self+0x3c2] = 0x3ec, [self+0x3be] = 0, return 0. The header must be: the 4 bytes at entry+0x10a equal
 * the 4 bytes at 0x55dab4, signed word [entry+0x10e] == 2 and signed word [entry+0x110] == 0; otherwise 0x4f356e(this self, id), [self+0x3c2] = 0x3f9, [self+0x3be] = 0, return 0.
 * Then [entry+0x162] = 1, [entry+0x152] = 0; the range pair p = [entry+0x1aa], q = [entry+0x1ae] is replaced by the defaults [self+0x446], [self+0x44a] unless (p != 0 || q != 0) and (q - p) > 0 (32-bit
 * difference, SIGNED); the pairs ([+0x1b2], [+0x1b6]), ([+0x1ba], [+0x1be]), ([+0x1c2], [+0x1c6]) are swapped when the first is greater than the second (SIGNED); [+0x1d6] <= 1 (signed) becomes [self+0x466]
 * and [+0x1da] <= 1 (signed) becomes [self+0x46a]; [+0x287] = 0, [+0x19e] = 0, [+0x28b] = 0; size = dword [entry+0x122] is stored at [+0x15e].
 * size < 0 (signed): when the signed word 0x63a4cd != 0: 0x4f356e(this self, id), 0x50ca3e(0x63888b, 0x55dab8, entry + 4) (cdecl, THREE arguments) and 0x52139c(0x63888b, 0, 0) (stdcall); return 0 (also with the
 * debug word zero). Otherwise, when signed word [entry+0x126] == 2: the NUL-terminated string at 0x55dafc is copied with its NUL to the start of the frame area (dwords first, then bytes): the original's
 * area is 0x20 bytes plus a 4-byte temporary below it, so a string of 0x24 bytes or more with its NUL would run over the saved registers: the port returns status 1 right there (everything before has
 * happened). size > 0x56220 (signed): [+0x166] = 1; debug word != 0: 0x50ca3e(0x63888b, 0x55db08, the address of the frame area (a host
 * pointer), id, entry + 4) (cdecl, FIVE arguments) and 0x44a2b7(0x63888b) (cdecl); 0x4f438f(this self, id) (thiscall, 1 argument; the original pushes the word from cx with a stale upper half, the port
 * passes it zero extended) == 0: return 0; else return dword [self+0x3be] (read again). Otherwise (size <= 0x56220): [+0x166] = 0; debug word != 0: 0x50ca3e(0x63888b, 0x55db40, id, entry + 4) (cdecl, FOUR
 * arguments) and 0x44a2b7(0x63888b); 0x4f3c26(this self, id) (thiscall, 1 argument, word as above) == 0: return 0; else return dword [self+0x3be] (read again). The result is stored at *result.
 * Callees that change [self+0x3be] are only exercised through the fixtures' scripted stores. Status 1: see the string copy above; *result is not set then. */
int m4f379c_open_entry(uint8_t *self, uint32_t id, uint32_t *result, const Fl36aWorld *world, const Fl18Host *host);

/* FNS-END */

#ifdef __cplusplus
}
#endif

#endif
