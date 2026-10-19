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
    int16_t word_639895, word_639893;   /* 0x4c2c3a: the bytes per pixel factor (read as signed) and the word copied to [+0x33] */
    uint8_t *player_637fd7;    /* the movie player object at 0x637fd7: 0x4c0d3f reads the flags at +0x20e (0x6381e5), +0x212 (0x6381e9), +0x216 (0x6381ed), the dwords +0x172 / +0x176, the rectangle at +0x1d6 (0x6381ad) and +0x1e6 (0x6381bd), and clears the word +0x1cc */
    uint8_t *rect_583122;      /* the rectangle of four dwords at 0x583122 */
    uint32_t value_5d19f7, value_5d19f3, value_5cf665, value_5d19ef;   /* 0x4c0d3f: the dwords passed on to 0x4c5377 */
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

/* 0x4c2c3a, thiscall (`self` = ecx, only forwarded to 0x4c97b4), `ret 0x14`: the stack arguments a, b (words, sign-extended), v10, flags (dwords) and name (the original address of a
 * zero-terminated string). Allocates the 0x59-byte record with 0x51dc43(0x59); a result of 0: 0x42639d(this 0x583979, 0x553e68, name), 0x4c97b4(this self), returns 0. Otherwise
 * zeroes the 0x59 bytes and computes size = a * (signed word 0x639895) * b in 32 bits; with bit 0 of flags clear [rec] = 0x51dc43(size) (a result of 0: 0x42639d(this 0x583979, 0x553ec0, name),
 * 0x4c97b4(this self), returns 0), else [rec] = 0. A name of 0x19 or more characters is truncated IN PLACE (name[0x18] = 0); the string (with its terminator) is copied to rec+8. Then
 * [+4] = v10, word [+0x21] = 0x59, [+0x23] = size, [+0x27] = size + 0x59, words [+0x2b] = a, [+0x2d] = b, [+0x2f] = low 16 bits of a * 0x639895, [+0x31] = b, [+0x33] = word 0x639893,
 * [+0x55] = flags, [+0x35] = [+0x39] = 0, [+0x3d] = a - 1, [+0x41] = b - 1 (sign-extended), the dwords at +0x45 .. +0x54 = 0. Returns the record's original address (rec).
 * Caller-validated: the string must be terminated (an unterminated one overruns, like the original). */
uint32_t m4c2c3a_make_record(uint8_t *self, int16_t a, int16_t b, uint32_t v10, uint32_t flags, uint32_t name, const Fl27bWorld *world, const Fl18Host *host);

/* 0x4c0d3f, plain ret (no this, no stack arguments; its callee takes the constant ecx 0x5cf659): with the dword 0x6381e5 (player + 0x20e) non-zero: it is cleared, then 0x4c5377(this 0x5cf659,
 * [0x5d19ef], [0x5cf665], [0x5d19f3], [0x5d19f7], 0x552b7c) is called (stdcall `ret 0x14`) and, with the dword 0x6381ed (player + 0x216) clear, the word at player + 0x1cc (0x6381a3) is cleared; return.
 * Else, with the dword 0x6381e9 (player + 0x212) non-zero and ((dword player + 0x176 == 0 and dword player + 0x172 == 1) or dword player + 0x176 == 1): the rectangle D (0x583122) is intersected with the
 * rectangle C (0x6381bd) (four signed dwords: x0, y0, x1, y1, offsets 0, 4, 8, 0xc): nothing happens when D.x0 > C.x1, D.x1 < C.x0, D.y0 > C.y1 or D.y1 < C.y0 (signed); else isect = (max(D.x0, C.x0), max(D.y0, C.y0),
 * min(D.x1, C.x1), min(D.y1, C.y1)) and out = (isect.x0 - C.x0 + B.x0, isect.y0 - C.y0 + B.y0, isect.x1 - C.x0 + B.x0, isect.y1 - C.y0 + B.y0) with B = (dwords 0 and 4 at 0x6381ad), all in 32 bits;
 * 0x4c5377(this 0x5cf659, [0x5d19ef], [0x5cf665], &out, &isect, 0x552b90) with host pointers to the two local arrays of four int32. The callee may change the player object (the port re-reads it). */
void m4c0d3f_present_rect(Fl27bWorld *world, const Fl18Host *host);

/* 0x4c5377, thiscall (`self` = ecx; the dword [self+0xc] is compared with `idx`), `ret 0x14`: the stack arguments surf (the original address of a surface record: the dword [surf] is the pixel base,
 * the signed word [surf+0x2f] the row pitch), idx (a dword), r1 and r2 (original addresses of rectangles of four signed dwords x0, y0, x1, y1) and arg (a dword that is only passed on).
 * With the debug word 0x63a4cd non-zero the rectangles are checked first: when (r1.x1 - r1.x0) != (r2.x1 - r2.x0) or the same for y or surf == 0 or idx == 0, a diagnostic follows and the function ends
 * (no pixels are copied): 0x50ca3e(local text, 0x5548ec, arg, r1.x0, r1.y0, r1.x1, r1.y1, r2.x0, r2.y0, r2.x1, r2.y1), 0x52139c(text, 0, 0) (stdcall), 0x4c97b4(this self).
 * Otherwise: src = [surf] + r1.y0 * pitch + r1.x0 * (signed word 0x639895) (32-bit); 0x4c4067(this self, idx, r2, &desc, arg, 0x20) fills the local descriptor desc (the dword at +0x10 is the
 * destination row stride, the dword at +0x24 the destination base address); h = r1.y1 - r1.y0 + 1 rows (signed; none when h <= 0) of rowbytes = (r1.x1 - r1.x0 + 1) * (word 0x639895) bytes are copied
 * (forward `rep movsd` of rowbytes / 4 dwords, then `rep movsb` of rowbytes % 4 bytes, exactly in that order, also where source and destination overlap) from src (advanced by the CURRENT word
 * [surf+0x2f] after each row) to dst (advanced by desc[+0x10]); then 0x4c4202(this self, idx, r2, 0x554990) and, when idx == dword [self+0xc], 0x4c952f(this self, r2).
 * Returns 0. Native rejections (not in the original; each is an access violation or an endless copy there): returns 1 BEFORE anything else happens when the surface address is 0 on the non-diagnostic
 * path (the original reads the word at address 0x2f), and returns 1 after 0x4c4067 when rows are to be copied (h > 0) and rowbytes is above 0x7fffffff as an unsigned count (a negative width). The
 * descriptor desc is a zero-initialised local of 0x7c bytes (the original leaves it to the callee; the callee must fill the two fields). Caller-validated: the addresses must resolve to memory valid for
 * the rows that are read and written (Fl18Host.resolve is called unchecked on the source and destination of every row). */
int32_t m4c5377_blit_rows(uint8_t *self, uint32_t surf, uint32_t idx, uint32_t r1, uint32_t r2, uint32_t arg, const Fl27bWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
