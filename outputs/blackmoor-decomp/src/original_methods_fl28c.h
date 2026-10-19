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
    int16_t word_5c39e3;       /* 0x4cd243: the scene number (read as signed): stored in [self+0x23e] and passed to the reports */
    uint32_t value_5bb57b;     /* 0x4cd243: a dword that the failure reports print */
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

/* 0x4ccef1, thiscall (`self` = ecx), plain `ret`, no result: releases the movie player and the movie record of the object. When the dword [self+0x1d6] (the original address of a player object) is non-zero:
 * 0x44c479(self+4) (cdecl, one argument), [self+4] = 2, 0x449a94(this = [self+0x1d6]), then o = [self+0x1d6] (read again): o non-zero calls the virtual method at [[o]+0] with this = o and the one stack argument 1
 * (the deleting destructor of the object, whose result is discarded), then [self+0x1d6] = 0, 0x44c4ab(self+4) (cdecl, one argument), [self+4] = 0. Whether the player was set or not: 0x415011(this 0x5e2dbe, self+8),
 * 0x41632b(this 0x5e2dbe, self+8) and 0x4bedfa(this 0x6201f9, self+0x18e) (all thiscall, one stack argument; `self+n` is a host pointer into the object). The callees are host calls; a callee that changes `self`
 * is exercised only where tasks/fl28c-handoff.md says so (0x449a94 clearing [self+0x1d6]). Caller-validated: Fl18Host.resolve must give the player object and its vtable. */
void m4ccef1_release_movie(uint8_t *self, const Fl18Host *host);

/* 0x4ce8ea, thiscall (`self` = ecx), plain `ret`, no result: one step of the scan state machine of the object. rec = [self+0x226] + [self+0x246] * 0x35 (32-bit, no guard, taken before the switch). The state is the
 * dword [self+0x1da]: 0 and 4 are the two arms, every other value (as a dword) returns at once. Arm 0: 0x4bef85(this 0x6201f9, [self+0x18e]) (thiscall, one argument) zero returns. Otherwise the common
 * sequence: 0x4befc8(this 0x6201f9, [self+0x18e]); 0x4bf098(this 0x6201f9, [self+0x18e], dword [[self+0x212]], signed word [[self+0x212]+0x2f], signed word [[self+0x212]+0x2d], 0, 0) (thiscall, six arguments;
 * the two words are sign-extended to 32 bits); [self+0x232] = 0x4bee2c(this 0x6201f9, [self+0x18e]) - 1; [self+0x206] = 1; [self+0x20a] = 1 (arm 0 only); 0x4ceb8c(this self) (thiscall, no argument; a callee, host-called
 * here); r = 0x4bf10f(this 0x6201f9, [self+0x18e]). r non-zero and the dword [self+0x232] (read again) different from the signed word [rec+0x23]: [self+0x1da] = 4 and return (arm 0 only). Otherwise
 * [self+0x1de] = 3 and, with the debug word, 0x44a2b7(0x559a28). Arm 4: the same, but without the store to [self+0x20a], without the [self+0x1da] store (r non-zero and different returns without any store) and with the
 * debug text 0x559aa8. Caller-validated: Fl18Host.resolve must give the player record ([self+0x212], 0x31 bytes) and rec (0x25 bytes). */
void m4ce8ea_scan_step(uint8_t *self, const Fl28cWorld *world, const Fl18Host *host);

/* 0x4cd243, thiscall (`self` = ecx), `ret 0xc`, returns eax = 1 or 0: reads the scene tables from a stream. The three stack arguments are host pointers to dwords of the caller: `dst` (the dword holds the original address of the
 * header buffer that 0x4cf1e4 fills in), `src` (the read cursor: the dword holds the original address of the stream) and `tail` (a second cursor, only advanced). A failure report is 0x50ca3e(0x63888b, text, [0x5bb57b], signed
 * word [0x5c39e3]) (cdecl, four arguments), 0x42639d(this 0x583979, text2, 0x63888b) (thiscall, two arguments), 0x4c97b4(this 0x5cf659), and the function returns 0.
 * 1. [self+0x216] non-zero: with the debug word 0x50ca3e(0x63888b, 0x55907c, signed word [0x5c39e3]) (three arguments) and 0x44a2b7(0x63888b); return 0 (nothing else is touched).
 * 2. [self+0x23e] = signed word [0x5c39e3]; 0x4cf1e4(this self, dst, 0x27) (thiscall, two arguments; the alloc-and-clear function of this batch, host-called here); 0 = report (0x5590f8, 0x559124), return 0.
 * 3. 0x27 bytes from the stream [src] to the buffer [dst] (dwords first, forward); [tail] += 0x27; [src] += 0x27; [self+0x222] = [dst].
 * 4. 0x4cf1e4(this self, self+0x226, signed word [[self+0x222]+0x23] * 0x35): 0 = report (0x559140, 0x559184), return 0.
 * 5. For i = 0 .. while i < the signed word [[self+0x222]+0x23] (read again): rec = [self+0x226] + i * 0x35 and c (a running offset, 0 at first) into the stream: s = [src] + c; 0x21 bytes from s to rec (8 dwords, 1 byte), c += 0x21;
 * word [rec+0x21] = word [s+0x21], c += 2; word [+0x23] likewise, c += 2; dword [+0x25], c += 4; dword [+0x29], c += 4; word [+0x2d], c += 2; word [+0x2f], c += 2 (the fields are copied from s, which does not move);
 * 0x4cf1e4(this self, rec+0x31, signed word [rec+0x2f] * 0x23): 0 = report (0x5591a0, 0x5591e4), return 0; then m = signed word [rec+0x2f] * 0x23 bytes from [src] + c to the buffer at [rec+0x31] (dwords first), c += m.
 * 6. [tail] += c; [src] += c. 0x4cf1e4(this self, self+0x22a, signed word [[self+0x222]+0x25] * 0x22): 0 = report (0x559200, 0x559240), return 0. Then that many bytes from [src] to the buffer [self+0x22a],
 * and [tail] += k; [src] += k with k the same product read again. With the debug word 0x4cf276(this self) (thiscall, no argument) and 0x44a2b7(0x55925c). Returns 1.
 * Native rejection (not in the original, whose copy count would be about 4 GB): a size m or k that is negative as a signed 32-bit value after its allocation succeeded returns 0 at once, before the copy and before any later store.
 * Caller-validated: the pointers `dst`, `src`, `tail` must point to dwords; Fl18Host.resolve must give the stream, the buffers that the host-called allocations returned and the header (it is called UNCHECKED, but not for a size of 0).
 * The host-called allocations are not exercised for effects on anything but the pointers they store (the scripted writes of the oracle model them). */
int32_t m4cd243_read_tables(uint8_t *self, uint8_t *dst, uint8_t *src, uint8_t *tail, const Fl28cWorld *world, const Fl18Host *host);

/*HEADER-INSERT*/

#ifdef __cplusplus
}
#endif

#endif
