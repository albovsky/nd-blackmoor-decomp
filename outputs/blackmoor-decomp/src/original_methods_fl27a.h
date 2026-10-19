#ifndef BLACKMOOR_ORIGINAL_METHODS_FL27A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL27A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-27 (batch a): sixteen small methods of the action 0x35 (movie) runtime of GAME.EXE (SHA-256 afd337a2...5c45), ported one to one in
 * the style of FL-26 (see original_methods_fl26a.h, whose conventions apply unchanged; Fl18Host from original_methods_fl18.h is reused):
 * each is its own symbol that cites the original address in its leading comment, `self` is the original `this` object (ecx) as raw bytes
 * at the original offsets, and the effects keep the order of the original.
 *
 * Calls into original code and the imports go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST
 * one pushed, i.e. the first argument of the callee). An import is named by its IAT slot address: Sleep 0x52a2b0, _BinkOpen@8 0x52a518,
 * _BinkNextFrame@4 0x52a520, _BinkCopyToBuffer@28 0x52a524, _BinkDoFrame@4 0x52a528, _BinkWait@4 0x52a52c, _BinkGoto@12 0x52a530,
 * _BinkGetSummary@8 0x52a508. A pointer or handle that the original passes on is passed as the 32-bit original value; one that the
 * function reads or writes through (a Bink handle, a string, a slot, the state dword) goes through Fl18Host.resolve (original address ->
 * host memory; writable where the function writes). `self` is a host pointer, so a callee that is given `this` or a pointer into
 * `self` receives the host pointer cast to uintptr_t (an original callee gets the same object).
 *
 * Callees inside this batch are called natively: 0x4de1f5 from 0x4de214, 0x4de214 from 0x4de2d8, 0x44c479 from 0x4c0c7d. Every
 * other callee is a host call (recording stubs in the oracle) and its effect on `self`, the Bink handle, or a global that the function
 * reads again afterwards is the host's to supply (the tests do not exercise a callee that changes them), except where the function
 * itself re-reads such a value and the port re-reads it too (0x44c479, 0x4c2dfb, 0x4159db: stated in the comments).
 *
 * Native rejection (documented apart from the valid-input behaviour; it changes no valid input): 0x44c479 and 0x4c0c7d wait in a loop that
 * another thread ends. Fl27aWorld.native_spin_limit (0 = FL27A_SPIN_LIMIT) bounds the Sleep calls of one wait without the awaited change;
 * when it is reached the port stops and returns FL27A_REJECTED. The original would spin without end.
 * Caller-validated, as in FL-26 (the port does not check, like the original): every address that Fl18Host.resolve is called with must
 * resolve (a NULL result is dereferenced) and the memory behind it must cover the bytes read or written through it (stated per function).
 * Nothing here claims original source structure. */

#define FL27A_SPIN_LIMIT 1000000u
#define FL27A_REJECTED ((int32_t)-1)   /* native rejection; 0x44c479 returns only 1 or 2 and 0x4c0c7d never returns in the original */

typedef struct Fl27aWorld {
    uint32_t value_5b15d6, value_5d17f5;   /* 0x4de2d8: cleared */
    uint32_t value_63a58a;                 /* 0x4159db: set to 4 */
    uint32_t native_spin_limit;            /* native only (not an original global): the bound of the waiting loops, 0 = FL27A_SPIN_LIMIT */
    uint8_t byte_5a161f;                   /* 0x4de1f5: cleared */
} Fl27aWorld;

/* 0x4de1f5: thiscall, plain `ret`: [self + 0x991] = 0 (a dword at an odd offset) and the byte [0x5a161f] = 0. */
void m4de1f5_clear_flags(uint8_t *self, Fl27aWorld *world);

/* 0x4de214: thiscall, plain `ret`: calls 0x4de1f5 (this = self), i.e. m4de1f5_clear_flags. */
void m4de214_clear_flags_thunk(uint8_t *self, Fl27aWorld *world);

/* 0x4de2d8: thiscall, plain `ret`: [self + 0x991] = 1; calls 0x4e053f (ecx 0x570508, argument 1) and 0x4e1113 (ecx 0x570508); [0x5b15d6] = 0;
 * [0x5d17f5] = 0; then 0x4de214 (this = self, native: clears [self + 0x991] and [0x5a161f]). The effects of the two callees (their own
 * writes to the caption objects, the globals 0x5b1602 / 0x5b1606) are the host's: not modelled here (receipt items A-51 #1 and #5). */
void m4de2d8_reset_caption(uint8_t *self, Fl27aWorld *world, const Fl18Host *host);

/*DECLS*/

#ifdef __cplusplus
}
#endif

#endif
