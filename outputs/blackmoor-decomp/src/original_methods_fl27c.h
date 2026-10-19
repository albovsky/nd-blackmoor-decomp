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
    uint32_t value_63a58a;     /* 0x414ceb: set to 4 on every failure report */
    uint8_t byte_5b0257, byte_5b0258, byte_5b0259;   /* 0x4c2e97: the three colour byte masks, each ANDed with a field and shifted left by one */
    uint32_t value_5bb20c;     /* 0x44c4c1: set to 1 when the video cannot be opened */
    int16_t word_639895;       /* 0x44c4c1: the bytes per pixel factor (read as signed) */
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

/* 0x414ceb, thiscall (`self` = ecx, only forwarded to 0x415011), `ret 4`: the stack argument `arg` is the chunk-streamer record (a host pointer here); a failure report is the sequence 0x42639d(this
 * 0x583979, message, text) (thiscall, 2 stack arguments), [0x63a58a] = 4, 0x4c97b4(this 0x5cf659), and every report except the ones inside the first four steps ends the function.
 * 1. [arg+0x21] non-zero: report (0x5418d0, arg+0x151), and the function goes on. 2. The dwords [+0x21], [+0x31], [+0x35], [+0x39], [+0x3d], [+0x41], [+0x25], [+0x29], [+0x2d], [+0x49] = 0 and [+0x45] =
 * 0xffffffff. 3. The string at arg+0x4d empty: report (0x541900, arg+0x151) and the function goes on. 4. h = the import 0x52a2bc(arg+0x4d, 0x80000000, 0, 0, 3, 0x8000000, 0) (stdcall, 7 arguments), [+0x25] = h;
 * [+0x25] == 0xffffffff (re-read): report (0x541924, arg+0x4d), end. 5. m = the import 0x52a2c0([+0x25], 0, 2, 0, 0, 0) (6 arguments), [+0x29] = m; zero: report (0x54193c, arg+0x4d), end. 6. v = the
 * import 0x52a2c4([+0x29], 4, 0, 0, 0) (5 arguments), [+0x2d] = v; zero: report (0x54195c, arg+0x4d), end. 7. The 0x21 bytes at the original address v are copied to arg (`rep movsd` of 8 dwords, then one byte);
 * the 15 bytes at arg are compared with the signature at 0x541978 and the words [+0x10] == 2 and [+0x12] == 0 are required; otherwise 0x415011(this self, arg) and the report (0x541988, arg+0x4d), end.
 * 8. n = (signed word [+0x15]) * 0x13 in 32 bits; [+0x21] = a = 0x51dc43(n); a == 0: 0x415011(this self, arg), the report (0x5419ec, 0x5419dc), end. 9. n bytes are copied from [+0x2d] + 0x21 to a (dwords first, then
 * bytes, forward) and [+0x41] = (signed word [+0x17]) * (signed word [+0x19]) * (byte [+0x1b] >> 3), all in 32 bits. Returns 0.
 * Native rejection (not in the original, whose copy would run for 4 GB): when n is above 0x7fffffff as an unsigned count (a negative word) and the allocation succeeded, the function returns 1 after the store of [+0x21]
 * and before the copy. Caller-validated: the string at arg+0x4d must be terminated inside the record, `arg` must hold the record (0x151 bytes plus the text), and Fl18Host.resolve must give memory valid for the 0x21 header
 * bytes at v, the n bytes after them and the n bytes at a (it is called unchecked). The callees are host calls and are not exercised for effects on `arg` (the scripted writes of the oracle model a mapped file). */
int32_t m414ceb_open_map(uint8_t *self, uint8_t *arg, Fl27cWorld *world, const Fl18Host *host);

/* 0x4c2e97, thiscall (`self` = ecx, a large object of at least 0x38d4 bytes), `ret 4`, returns ax (1 or 0): the stack argument `surf` is the original address of a surface object (a COM-style object: the dword [surf]
 * is the vtable, the entry 0x58 is the method that fills a 0x7c-byte descriptor). A zeroed descriptor with [0] = 0x7c and [4] = 0x1000 is passed to that method as (surf, &descriptor) (stdcall, this = surf in
 * ecx too). A non-zero result hr: t = 0x4c88c7(this self, hr), 0x42639d(this 0x583979, 0x553f14, t), return 0. Otherwise the three masks red = descriptor[+0x58], green = [+0x5c], blue = [+0x60] are
 * processed in that order, each: count the low zero bits (cnt, a byte) while shifting the mask right, store cnt in the byte [self + 0x38c2 / 0x38c1 / 0x38c0], the shifted mask's low byte in
 * [self + 0x38c6 / 0x38c5 / 0x38c4] and the kind 5 (the shifted mask == 0x1f as a dword) or 6 in [self + 0x38ca / 0x38c9 / 0x38c8]. Then the three byte globals are ANDed with the three mask bytes (0x5b0257
 * with [0x38c6], 0x5b0258 with [0x38c5], 0x5b0259 with [0x38c4]), each global whose kind is not 5 is shifted left by one (as a byte), and the word [self + 0x38d0] = (g57 << [0x38c2]) | (g58 << [0x38c1]) |
 * (g59 << [0x38c0]) (32-bit, low word stored), the bytes [self + 0x38d2] and [0x38d3] are its low and high bytes, and the dword [self + 0x38a8] is 0 when all three kinds are 5, else 1. With the
 * debug word: 0x50ca3e(0x63888b, 0x553f30, 14 more values: the bytes 38c2 38c6 38ca 38c1 38c5 38c9 38c0 38c4 38c8, the dword 38a8, the word 38d0, the bytes 38d3 38d2, descriptor[+0x54]) and 0x44a2b7(0x63888b);
 * then 0x44a2b7 with 0x55400c / 0x55403c / 0x554074 / 0x5540a0 for the descriptor flags [+0x4c] bits 0x2 / 0x20 / 0x40 / 0x400, in that order. Returns 1.
 * Native rejection (not in the original, whose shift loop never ends on a zero mask): a mask of 0 returns 2 at its own loop, after the stores of the masks before it. Caller-validated: `self` holds the object,
 * Fl18Host.resolve must give the surface object and its vtable (the host call is unchecked). The descriptor is a local; the method must fill it (the port does not model its effect on anything else). */
int32_t m4c2e97_read_pixel_format(uint8_t *self, uint32_t surf, Fl27cWorld *world, const Fl18Host *host);

/* 0x44c4c1, plain `ret` (cdecl, one stack argument `arg`, a record, a host pointer here): opens a movie by name. The extension text is ".BIK" when the dword [arg+0x176] is 1, else ".AVF". The word [arg+0x1c4] = 1. Then
 * 0x50cd72(text1, 0x639dae, 0x639eb5, arg+0x151, ext) (cdecl, five arguments; text1, ext are 0x100-byte locals) and 0x449d90(text1) (cdecl, one argument); a result of 0: 0x50cd72(text2, 0x639dab, 0x639fb9,
 * arg+0x151, ext) and the string text2 (with its terminator) is copied to arg+0x4d, else the string text1 is copied there. [arg+0x176] is read again: not 1 (the AVF path): 0x414ceb(this 0x5e2dbe, arg), then the
 * word [+0x18c] = 0, [+0x190] = signed word [+0x15], word [+0x18e] = signed word [+0x18c] + [+0x190] - 1, [+0x19e] = 0, [+0x19a] = 0, [+0x1a6] = [+0x19e] + signed word [+0x19] - 1, [+0x1a2] = [+0x19a] + signed word
 * [+0x17] - 1, words [+0x194] = word [+0x17], [+0x198] = word [+0x19], [+0x196] = low word of signed word [+0x194] * (byte [+0x1b] >> 3), [+0x1ba] = [+0x1c], [+0x1c8] = signed word [+0x196] * signed word [+0x198]
 * (all products in 32 bits), and the common tail. Equal to 1 (the BINK path): h = 0x4bf315(this 0x6201f9, arg+0x4d, 0), [+0x186] = h. [+0x186] zero: with the debug word 0x44a2b7(0x4bf3b8(this 0x6201f9, arg+0x4d)), then
 * 0x4264e8(this 0x583979, 0x4bf3b8(this 0x6201f9, arg+0x4d)), [0x5bb20c] = 1, 0x4c97b4(this 0x5cf659), return. Otherwise info = 0x4bee5f(this 0x6201f9, [+0x186]); [+0x186] zero (re-read) or info zero: 0x50ca3e(0x63888b,
 * 0x54939c, arg+0x4d) (cdecl, three arguments), with the debug word 0x44a2b7(0x63888b), 0x4264e8(this 0x583979, 0x63888b), [0x5bb20c] = 1, 0x4c97b4, return. Else (the info record at the original address info): word [+0x18c] = 0,
 * [+0x190] = info[+0x20], word [+0x18e] = [+0x190] - 1, [+0x19e] = [+0x19a] = 0, [+0x1a6] = info[+4] - 1, [+0x1a2] = info[+0] - 1, words [+0x194] = word info[+0], [+0x198] = word info[+4], [+0x196] = low word of info[+0] *
 * signed word 0x639895, [+0x1ba] = the 32-bit result of __ftol (0x50ce04) applied to 1.0 / ((float)info[+0xc] / (float)info[+0x10]) * 1000.0 (the dwords are converted as unsigned 64-bit integers by fild qword and stored as
 * single-precision floats; the divisions and the product run in 53-bit x87 precision, the process default control word 0x27f: the port uses IEEE doubles), [+0x1c8] = signed word [+0x196] * signed word [+0x198]; then the common
 * tail (at 0x44c98d): [+0x1ae] = [+0x19e], [+0x1b6] = [+0x1a6], [+0x1aa] = [+0x19a], [+0x1b2] = [+0x1a2]. The common tail is not reached by the error returns.
 * __ftol keeps the low dword of the truncated 64-bit integer; a quotient of zero (info[+0xc] zero, or both zero: NaN) or an out-of-range value gives 0. Caller-validated: the strings written into text1 / text2 by the
 * callees must be terminated inside the 0x100-byte locals and short enough for the 0x104-byte name field [+0x4d .. +0x151) (the port zero-fills the locals, the original leaves them to the callee); Fl18Host.resolve must
 * give the info record (0x24 bytes). The callees are host calls; the effects they have on `arg` that the function re-reads are named in tasks/fl27c-handoff.md. */
void m44c4c1_open_video(uint8_t *arg, Fl27cWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
