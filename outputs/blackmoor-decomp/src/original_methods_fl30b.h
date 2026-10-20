#ifndef BLACKMOOR_ORIGINAL_METHODS_FL30B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL30B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-30 (batch b): methods of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-29 batch a (see original_methods_fl29a.h, whose conventions
 * apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment,
 * `self` is the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names
 * are descriptive hints, not recovered source names.
 *
 * Calls into original code, the CRT, the imports and the COM-style vtable entries go through Fl18Host.call (callee address, ecx value, stack arguments with
 * args[0] the LAST one pushed = the first argument of a C prototype). An argument that is an address of the original is a 32-bit original address here, as in the
 * original; Fl18Host.resolve turns it into host memory when the function reads or writes through it. Only `self` and the Fl30bWorld table pointers are host
 * pointers. A callee that changes `self` or a global that the function reads again afterwards is not exercised (tasks/fl30b-handoff.md). Word arguments are taken
 * from the low 16 bits of the stack dword. Nothing here claims original source structure. */

typedef struct Fl30bWorld {
    uint8_t *records_5bb5e5;    /* 0x44b26a: records of stride 0x8d, the dword at +0 is the original address of a 4 byte item (kind, flag, word) */
    uint8_t *words_58c959;      /* 0x44b26a: words indexed by the kind byte 0 .. 0x1d */
    uint8_t *floats_58c91d;     /* 0x44b26a: floats indexed by the kind byte 0x1e .. 0x27 (the pointer names the original address 0x58c91d) */
    int16_t word_63a4cd;        /* 0x44b26a: the debug flag: a non-zero word turns on the report */
} Fl30bWorld;

/* 0x44b26a, ecx unused, `ret 4`, the stack argument is the word `index` (signed): item = dword [0x5bb5e5 + index*0x8d] (an original address), kind = byte [item], flag = byte [item+1],
 * delta = word [item+2]. kind > 0x27: when the signed word 0x63a4cd is non-zero: 0x50ca3e(0x63888b, 0x549028, kind) (cdecl, 3 arguments) and 0x52139c(0x63888b, 0, 0) (stdcall, 3 arguments).
 * kind <= 0x1d: word w = [0x58c959 + kind*2]; when flag != 0 or signed w == 0x270f: w = delta, else w = w + delta (16-bit wrap). kind 0x1e .. 0x27: float f = [0x58c91d + kind*4]; when flag == 0
 * and f is not equal to 9999.0f (x87 fcomp: an equal or unordered result keeps the other branch): f = (float)(sum in 53-bit precision of (float)(signed delta) and f), otherwise f =
 * (float)(signed delta). In every case then 0x42ba3a(index) (cdecl, 1 argument, the low 16 bits). */
void m44b26a_apply_delta(uint32_t index, const Fl30bWorld *world, const Fl18Host *host);

/* NEXT-DECL */

#ifdef __cplusplus
}
#endif

#endif
