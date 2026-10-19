#ifndef BLACKMOOR_ORIGINAL_METHODS_FL27B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL27B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-27 (batch b): movie-player (action 0x35 runtime) methods of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of
 * FL-26 (see original_methods_fl26a.h, whose conventions apply unchanged, and whose Fl18Host from original_methods_fl18.h is reused): each
 * is its own symbol that cites the original address in its leading comment, `self` is the original `this` object (ecx) as raw bytes at
 * the original offsets, nothing is bounds-checked, and the effects keep the order of the original. The names are descriptive hints, not
 * recovered source names.
 *
 * Calls into original code and into the imports go through Fl18Host.call (callee address or the address of the import slot, ecx value,
 * stack arguments with args[0] the LAST one pushed = the first argument of a C prototype). A singleton that the original names by a constant
 * ecx (0x583979, 0x5cf659, 0x5e2dbe, ...) is passed as its 32-bit original address. A dword inside an object that holds an address of
 * the original is read as a dword; Fl18Host.resolve turns it into host memory where the function has to read or write through it (it is
 * called UNCHECKED, and the memory behind a written object must be writable). A virtual call is Fl18Host.call with the vtable entry that the
 * port read from the object (the original address stored in the vtable) as `callee`. The callees of this batch are all host calls, also the
 * ones that are in the batch or in batch a (0x449bff, 0x449a94, 0x44c479, 0x44c4ab, ...): a host that binds them to the m<va>_* symbols
 * says so itself.
 *
 * Host contract (as in FL-21, FL-25, FL-26): the Fl27bWorld scalars are a snapshot. A host that backs a callee with real original code must
 * flush the world to the original's memory BEFORE each Fl18Host.call and resync it AFTER the call. A callee that changes `self`, an object or
 * a global that the function reads again afterwards is not exercised by the oracle of the original except where the function's own re-reads
 * are the point of a scenario (named in the handoff). Nothing here claims original source structure. */

typedef struct Fl27bWorld {
    int16_t word_63a4cd;       /* the debug flag: a non-zero word turns on the trace output (sprintf into 0x63888b, then 0x44a2b7) */
    uint32_t value_63a58a;     /* 0x4161d1: set to 4 on an allocation failure */
} Fl27bWorld;

/* 0x449bff, plain ret, `self` = this: returns 0; with the object address [+0x36] clear nothing happens. Otherwise calls the import slot 0x52a284 (stdcall, one
 * argument: the dword [object + 0x28]; the object is the address [self + 0x36]) and, with the debug flag, 0x50ca3e(0x63888b, 0x5489e4, [self+0x3a], self+4, result)
 * and 0x44a2b7(0x63888b). A result of 0xffffffff: 0x4264e8(this 0x583979, 0x548a38), 0x4c97b4(this 0x5cf659) and return, nothing else stored. While the
 * result is above 1 (unsigned): the object [self+0x36] is read again, the import called again, the debug trace with the format 0x548a54. Then dword [self+0x42] = 2.
 * Native rejection (not in the original): a repeated result of 0xffffffff inside the loop would call the import forever in the original; the port stops
 * and returns 1 without storing [self+0x42]. */
int32_t m449bff_resume_thread(uint8_t *self, const Fl27bWorld *world, const Fl18Host *host);

/* 0x449a94, plain ret, `self` = this: nothing happens when the object address [+0x36] is clear. When it is non-zero and dword [+0x42] is 1: 0x449bff(this self), then
 * the import slot 0x52a2b0(0). Then dword [+0x3e] = 1 and 0x52a2b0(0), then the poll loop: while [self+0x36] is non-zero, call the import slot 0x52a280(dword [object + 0x28], &code)
 * (code is a local dword, 0 first): a non-zero result with code 0 leaves the loop; a zero result with the debug flag calls 0x426367(this 0x583979) and 0x44a2b7(its result);
 * every other pass sleeps 0x52a2b0(0). After the loop: dword [object + 0x24] = 1, the virtual call [[object] + 0x78](this object), [self+0x36] = 0, [self+0x42] = 3, and with the
 * debug flag 0x50ca3e(local buffer, 0x5489a0, [self+0x3a], self+4) and 0x44a2b7(buffer). Returns 0. Native rejection (not in the original): when [self+0x36] is zero
 * after the loop (a callee cleared it) the original stores through the null object (address 0x24, an access violation); the port returns 1 at that point, before any store. */
int32_t m449a94_stop_thread(uint8_t *self, const Fl27bWorld *world, const Fl18Host *host);

/* 0x4bf773, plain ret, `self` = this: with the object address [+0x1d6] non-zero: 0x44c479(self+4), dword [self+4] = 2, 0x449a94(this = the object address), the virtual
 * call [[object]](this object, 1) (the scalar deleting destructor flag), dword [+0x1d6] = 0, 0x44c4ab(self+4), dword [self+4] = 0. Then always: the debug trace 0x44a2b7(0x5525dc), 0x415011(this
 * 0x5e2dbe, self+8), the trace 0x552620, 0x4c2dfb(this 0x5cf659, self+0x222) when dword [+0x222] is non-zero, the trace 0x552664, 0x41632b(this 0x5e2dbe, self+8) and
 * 0x4bedfa(this 0x6201f9, self+0x18e) (each trace only with the debug flag, read at its place). */
void m4bf773_release_player(uint8_t *self, const Fl27bWorld *world, const Fl18Host *host);

/* 0x4161d1, thiscall without use of ecx, `ret 4` (the one stack argument `arg` is a record, a host pointer here): the dword [arg+0x172] selects: 0 -> [arg+0x17a] = 0x51dc43([arg+0x1c8]);
 * 1 -> the same, then [arg+0x17e] = 0x51dc43([arg+0x1c8]); anything else (as a dword) -> nothing. After each allocation whose result is 0 the failure path runs: 0x50ca3e(0x63888b,
 * format) with the format 0x541e7c (kind 0), 0x541ed4 (kind 1, first buffer) or 0x541f2c (kind 1, second buffer), 0x52139c(0x63888b, 0, 0) (stdcall), [0x63a58a] = 4 and 0x4c97b4
 * (this 0x5cf659); the flow then continues (the kind 1 second allocation is attempted even after a failed first one). Finally the words [arg+0x182] and [arg+0x184] are cleared. */
void m4161d1_alloc_buffers(uint8_t *arg, Fl27bWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
