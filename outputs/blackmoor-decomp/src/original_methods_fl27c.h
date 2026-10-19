#ifndef BLACKMOOR_ORIGINAL_METHODS_FL27C_H
#define BLACKMOOR_ORIGINAL_METHODS_FL27C_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-27 (batch c): the four largest movie-player (action 0x35 runtime) methods of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-27
 * batch b (see original_methods_fl27b.h, whose conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol that cites the
 * original address in its leading comment, `self` / `arg` is the original object (ecx or a stack argument) as raw bytes at the original offsets, nothing is bounds
 * checked, and the effects keep the order of the original. The names are descriptive hints, not recovered source names.
 *
 * Calls into original code (also the ones that are ports of batch a, b or c: 0x414ceb, 0x449d90, ...) and into the imports go through Fl18Host.call (callee
 * address or the address of the import slot, ecx value, stack arguments with args[0] the LAST one pushed = the first argument of a C prototype); a host that binds
 * them to the m<va>_* symbols says so itself. A dword that holds an address of the original is read as a dword; Fl18Host.resolve turns it into host memory where the
 * function reads or writes through it (it is called UNCHECKED). A virtual call is Fl18Host.call with the vtable entry that the port read from the object.
 *
 * Host contract (as in FL-21, FL-25, FL-26, FL-27b): the Fl27cWorld scalars are a snapshot. A host that backs a callee with real original code must flush the world
 * to the original's memory BEFORE each Fl18Host.call and resync it AFTER the call. A callee that changes `self`, an object or a global that the function reads again
 * afterwards is not exercised except where a function's own re-reads are the point of a scenario (named in tasks/fl27c-handoff.md). Nothing here claims original
 * source structure. */

typedef struct Fl27cWorld {
    int16_t word_63a4cd;       /* the debug flag: a non-zero word turns on the trace output */
} Fl27cWorld;

/* 0x4497a0, constructor of the thread wrapper, `ret 0x10`, `self` = this (ecx): the stack arguments are `arg8` (a dword passed on to 0x524aff), `name` (the original address of a
 * zero-terminated string), `timeout` (a dword passed on to the import 0x52a2ac) and `flags` (a dword). It first stores the vtable address 0x52cb5c in [self], [self+0x36] = 0,
 * [self+0x42] = 3, [self+0x3a] = 0xffffffff, [self+0x3e] = 0, then copies the string (with its terminator) to self+4 (forward, dwords first; the destination reaches
 * +0x3a .. +0x45 when the string is 0x36 characters or longer: those fields are then the string's bytes, as in the original). Then obj = 0 or, when 0x51dc43(0x68) is non-zero,
 * 0x524aff(this = that result, arg8, self+0x3e); [self+0x36] = obj. obj == 0: 0x4264e8(this 0x583979, 0x548844), 0x4c97b4(this 0x5cf659) and return. Otherwise
 * [[self+0x36] + 0x24] = 1 and 0x51ed8c(this = [self+0x36], flags | 4, 0, 0) (thiscall, 3 stack arguments); a result of 0: the virtual call [[o] + 0x78](this o) with o = [self+0x36],
 * 0x4264e8(0x583979, 0x548894), 0x4c97b4, return. Then the import 0x52a2ac([o + 0x28], timeout) (stdcall); a result of 0: the virtual call, 0x4264e8(.., 0x5488d8), 0x4c97b4, return.
 * With bit 2 of `flags` clear: the import 0x52a284([o + 0x28]); a result of 0xffffffff: the virtual call, 0x4264e8(.., 0x548920), 0x4c97b4, return. Success: [[o] + 0x24] = 0, [self+0x3a] =
 * [o + 0x2c], [self+0x42] = 1 when flags == 4 (the whole dword) else 2, and with the debug word 0x50ca3e(local text, 0x548968, [self+0x3a], self+4) + 0x44a2b7(local text).
 * Returns `self` (the original returns this in eax). The object address [self+0x36] is read again at every use, like the original.
 * Not modelled: the structured-exception frame the original links into fs:[0] (the handler 0x527f1a runs only when a callee throws; the frame is unlinked again before every return).
 * Native rejection (not in the original, which would fault on address 0x24 / 0x28 / 0): returns NULL when [self+0x36] is zero at one of its re-reads after a callee ran (the host's
 * callee cleared it). Caller-validated: the string must be terminated and `self` must have room for it. */
uint8_t *m4497a0_construct(uint8_t *self, uint32_t arg8, uint32_t name, uint32_t timeout, uint32_t flags, const Fl27cWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
