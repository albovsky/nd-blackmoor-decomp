#ifndef BLACKMOOR_ORIGINAL_METHODS_FL28C_H
#define BLACKMOOR_ORIGINAL_METHODS_FL28C_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-28 (batch c): methods of the action 0x2d runtime object of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-27 batch c (see
 * original_methods_fl27c.h, whose conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol that cites the original
 * address in its leading comment, `self` is the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep
 * the order of the original. The names are descriptive hints, not recovered source names.
 *
 * Calls into original code and into the CRT go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first
 * argument of a C prototype); a host that binds a callee to an m<va>_* symbol says so itself. A dword that holds an address of the original is read as a dword;
 * Fl18Host.resolve turns it into host memory where the function reads or writes through it (it is called UNCHECKED). A pointer argument of a function (a stack
 * argument that is the address of a local or of a field of the caller) is a host pointer here and is passed on to the callees as such.
 *
 * Host contract (as in FL-21, FL-25..FL-27): the Fl28cWorld scalars are a snapshot. A host that backs a callee with real original code must flush the world to the
 * original's memory BEFORE each Fl18Host.call and resync it AFTER the call. A callee that changes `self`, an object or a global that the function reads again
 * afterwards is not exercised except where a function's own re-reads are the point of a scenario (named in tasks/fl28c-handoff.md). Nothing here claims
 * original source structure. */

typedef struct Fl28cWorld {
    int16_t word_63a4cd;       /* the debug flag: a non-zero word turns on the trace output */
    int32_t origin_x_583186, origin_y_58318a;   /* 0x4ceb8c: the origin that is added to the rectangle of the record */
} Fl28cWorld;

/* 0x4cf026, thiscall (`self` = ecx), `ret 4`, returns eax: the index of the first record whose compare callee answers 0, or -1. `self` keeps [+0x222] = the original address of a header
 * (the signed word at [+0x23] is the record count) and [+0x226] = the original address of the table of records of 0x35 bytes. Either dword zero returns -1. Otherwise for i = 0, 1, ...
 * while i (signed) < the signed word [[self+0x222]+0x23] (re-read at every step, like [+0x226]): r = 0x516530(key, [self+0x226] + i * 0x35) (cdecl, two arguments; the original
 * address of the record is passed on); r == 0 returns i. The loop ending returns -1. `key` is the stack argument, passed on unchanged. */
int32_t m4cf026_find_record(uint8_t *self, uint32_t key, const Fl18Host *host);

/* 0x4cec6c, thiscall (`self` = ecx), plain `ret`, no result: bumps the word at [self+0x1ca] by one (16-bit wrap), clamped to the record's limit. Returns without any effect when [self+0x222] or [self+0x226] is zero or
 * the dword [self+0x246] is 0xffffffff. Otherwise rec = [self+0x226] + [self+0x246] * 0x35 (32-bit), the word [self+0x1ca] = [self+0x1ca] + 1, and when that word (signed) is above the signed word [rec+0x23]
 * (read again after the store) it is replaced by [rec+0x23]. */
void m4cec6c_bump_counter(uint8_t *self, const Fl18Host *host);

/* 0x4cf1e4, thiscall (`self` = ecx, unused by the body), `ret 8`, returns eax = 1 or 0: allocates and clears. p = 0x51dc43(size) (cdecl, one argument); the dword at `out` (a host pointer to a dword of the caller, the first stack
 * argument) is set to p. p == 0 (failure report): 0x50ca3e(0x63888b, 0x559b94) (cdecl, two arguments), 0x4264e8(this 0x583979, 0x63888b), with the debug word 0x44a2b7(0x63888b), 0x4c97b4(this 0x5cf659), returns 0. Otherwise
 * `size` bytes at the original address p (the dword at `out` read again) are cleared, dwords first (size / 4 of them) and then size % 4 bytes, forward, and 1 is returned. The two stack arguments are `out` and `size`, in that order.
 * Caller-validated: Fl18Host.resolve must give size bytes at p when size is non-zero (it is not called for a size of 0). */
int32_t m4cf1e4_alloc_clear(uint8_t *out, uint32_t size, const Fl28cWorld *world, const Fl18Host *host);

/* 0x4ceb8c, thiscall (`self` = ecx), plain `ret`, no result: loads a rectangle from a record. Returns without effect when [self+0x222] or [self+0x22a] is zero or the dword [self+0x24a] is 0xffffffff. Otherwise
 * rec = [self+0x22a] + [self+0x24a] * 0x22 (32-bit) and, in this order, the dwords [self+0x1e6] = [rec+6], [+0x1ee] = [rec+0xe], [+0x1e2] = [rec+2], [+0x1ea] = [rec+0xa], [+0x1f6] = [rec+0x16] + y, [+0x1fe] = [rec+0x1e] + y,
 * [+0x1f2] = [rec+0x12] + x, [+0x1fa] = [rec+0x1a] + x (32-bit sums) with x = [0x583186], y = [0x58318a] (read at the store). Caller-validated: Fl18Host.resolve must give the record (0x22 bytes). */
void m4ceb8c_load_rect(uint8_t *self, const Fl28cWorld *world, const Fl18Host *host);

/*HEADER-INSERT*/

#ifdef __cplusplus
}
#endif

#endif
