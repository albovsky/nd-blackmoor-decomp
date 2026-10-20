#ifndef BLACKMOOR_ORIGINAL_METHODS_FL30A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL30A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-30 (batch a): methods of GAME.EXE (SHA-256 afd337a2...5c45) of 333 to 1,451 bytes ported one to one, in the style of FL-29 batch a (see original_methods_fl29a.h, whose
 * conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment,
 * `self` is the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names are
 * descriptive hints, not recovered source names.
 *
 * Calls into original code, the CRT, the imports and the COM-style vtable entries go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one
 * pushed = the first argument of a C prototype). An argument or a stored pointer that is an address of the original (a record, an object, a vtable) is a 32-bit original address
 * here, as in the original; Fl18Host.resolve turns it into host memory when the function reads or writes through it. Only `self` and the Fl30aWorld table pointers are host
 * pointers. A callee that changes `self`, a record or a global that the function reads again afterwards is not exercised (tasks/fl30a-handoff.md). Word arguments are taken from
 * the low 16 bits of the stack dword, as the original reads them. Nothing here claims original source structure. */

typedef struct Fl30aWorld {
    uint8_t *table_5bb5e5;     /* 0x484ac0, 0x47ef0f, 0x44b3c8, 0x4c36b2: records of stride 0x8d at the original address 0x5bb5e5: dword at +0 (an original address of a record), dword at +0x4d (state); slack for a negative index */
    int16_t word_63a4cd;       /* the debug flag: a non-zero word turns on the trace output */
} Fl30aWorld;

/* 0x4f61e7, thiscall, `ret 4`, the stack argument is the dword `index`, returns eax: dword [self+0x3c2] = 0x3e8, dword [self+0x3ca] = 0; rec = dword [self+0x3ce] + index*0x5bb (32 bits).
 * 0x4f709c(this self) (thiscall, no arguments) == 0: dword [self+0x3c2] = 0x3ea, dword [self+0x3be] = 0, returns dword [self+0x3be] (0). Otherwise when dword [rec+0x162] == 0 or dword [rec+0x28f] == 0:
 * dword [self+0x3c2] = 0x3ef, dword [self+0x3be] = 0, returns 0. Otherwise dword [rec+0x287] = 1; obj = dword [rec+0x28f]; vt = dword [obj]; r = (the dword [vt + 0x48] called with ecx = vt and the
 * stack argument obj, stdcall: pops 4 bytes) is stored to dword [self+0x3ca]. When r == 0: when the signed word 0x63a4cd is non-zero 0x50ca3e(0x63888b, 0x55e7bc, index, rec + 4) (cdecl, 4 arguments)
 * and 0x44a2b7(0x63888b) (cdecl, 1 argument); returns 1. Otherwise dword [self+0x3c2] = 0x40b, dword [self+0x3be] = 0, returns dword [self+0x3be] (0). */
uint32_t m4f61e7_start_record(uint8_t *self, uint32_t index, const Fl30aWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
