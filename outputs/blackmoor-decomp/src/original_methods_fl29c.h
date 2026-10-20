#ifndef BLACKMOOR_ORIGINAL_METHODS_FL29C_H
#define BLACKMOOR_ORIGINAL_METHODS_FL29C_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-29 (batch c): small methods of the bink, hiff, 28, da, d1 and d3 families of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-28 batch b (see
 * original_methods_fl28b.h, whose conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original
 * address in its leading comment, nothing is bounds checked, and the effects keep the order of the original. The names are descriptive hints, not recovered source names.
 *
 * Calls into original code and into the imports go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first argument of
 * a C prototype); a host that binds them to other m<va>_* symbols says so itself. Host contract: the Fl29cWorld scalars are a snapshot; a host that backs a callee with real
 * original code must flush the world to the original's memory BEFORE each Fl18Host.call and resync it AFTER the call. A callee that changes `self` or a global that the function
 * reads again afterwards is not exercised (tasks/fl29c-handoff.md). Pointer-valued stack arguments are host pointers to the memory they name; 32-bit values stored in objects,
 * cells and tables are original addresses that Fl18Host.resolve turns into memory. Nothing here claims original source structure. */

typedef struct Fl29cWorld {
    int16_t word_63a4cd;       /* the debug flag: a non-zero word turns on the trace calls */
    int16_t word_5c39e3;       /* the allocation-failure report passes this word (sign-extended) and value_5bb57b */
    uint32_t value_5bb57b;
    uint32_t value_5b44f0, value_5b44f4, value_5d0377, value_5d162d, value_5d1631, value_5d1639, value_5c39e5;   /* 0x4630a3 */
    uint8_t *records_5bb5e5;   /* 0x45bbd8: host memory of the records of stride 0x8d at 0x5bb5e5 (the dword at +0 is the address of the object of record n; a negative index lies below the base) */
    uint8_t *buf_63a590;       /* 0x434814: host memory of the 5-byte global buffer at 0x63a590 */
} Fl29cWorld;

/* 0x4bf19a, thiscall (`self` = ecx), `ret 8`, the stack arguments are `handle` (a host pointer to the binkw32 movie structure, or NULL) and `frame`: first the thiscall 0x4bf38c(this self)
 * (no arguments, plain `ret`). handle == NULL: dword [self+0x2c0] = 0xfffffffd, return 0. frame < 1 (signed) or frame > dword [handle+8] (unsigned): return 0. Otherwise the import
 * _BinkGoto@12 (slot 0x52a530, stdcall: handle, frame, 0 as the three arguments; its result is ignored) and return 1. */
uint32_t m4bf19a_bink_goto(uint8_t *self, const uint8_t *handle, uint32_t frame, const Fl18Host *host);

/* 0x434814, thiscall (ecx is stored and never read), `ret 4`, the stack argument `src` is a host pointer to a string: for i = 0 .. 3 (a word, signed compare) while the byte (sign-extended) src[i]
 * is not zero: byte [0x63a590 + i] = src[i]; then byte [0x63a590 + i] = 0 (i is 4 when no zero byte was met). Returns the constant 0x63a590 (the address of the global buffer, which the
 * port reaches through world->buf_63a590). The buffer holds 5 bytes. */
uint32_t m434814_copy_name(const uint8_t *src, const Fl29cWorld *world);

/* The four allocate-and-copy methods 0x4471ca (0x15 bytes), 0x45b4ae (0xb8e), 0x461903 (0x357) and 0x4b5c5c (0x39f): thiscall (ecx is stored and never read), `ret 0xc`, three stack arguments that are
 * host pointers to 4-byte cells holding original addresses: `a`, `b`, `c`. p = 0x51dc43(size) (cdecl, one argument); dword [a] = p. p == 0: with the report 0x50ca3e(0x63888b, <format>,
 * value_5bb57b, sign-extended word_5c39e3) (cdecl, four arguments), 0x42639d(this 0x583979, <message>, 0x63888b) (thiscall, two arguments) and 0x4c97b4(this 0x5cf659) (the original goes on).
 * Then size bytes are copied forward from the address [b] to the address [a] (the dwords with `rep movsd`, then the word and/or the byte that make up the rest), dword [c] += size, dword [b] += size
 * (in that order, so with c == b the cell advances twice), and with the debug word 0x44a2b7(<trace>) (cdecl, one argument). The format/message/trace strings are the addresses (formats 0x548450 /
 * 0x54aae4 / 0x54b0dc / 0x551a9c, messages 0x54847c / 0x54ab10 / 0x54b108 / 0x551ac8, traces 0x548498 / 0x54ab2c / 0x54b124 / 0x551ae4, in the order of the functions above). NATIVE REJECTION (not original
 * behaviour): after the allocation failure the original writes through the address 0; the port returns without copying and without advancing the cells when Fl18Host.resolve gives NULL for the
 * destination or the source. */
void m4471ca_copy_record15(uint8_t *a, uint8_t *b, uint8_t *c, const Fl29cWorld *world, const Fl18Host *host);
void m45b4ae_copy_record_b8e(uint8_t *a, uint8_t *b, uint8_t *c, const Fl29cWorld *world, const Fl18Host *host);
void m461903_copy_record_357(uint8_t *a, uint8_t *b, uint8_t *c, const Fl29cWorld *world, const Fl18Host *host);
void m4b5c5c_copy_record_39f(uint8_t *a, uint8_t *b, uint8_t *c, const Fl29cWorld *world, const Fl18Host *host);

/* 0x45bbd8, thiscall (`self` = ecx), `ret 4`, the stack argument is the word `arg` (signed), returns ax: rec = the dword at records_5bb5e5 + (signed word [self+0x1e]) * 0x8d (an original address). count = 0;
 * for i = 0 .. 3 (a word): w2 = 0x50cd50() (cdecl, no arguments) & 0x80000001, and when that is negative ((w2 - 1) | 0xfffffffe) + 1 (the signed remainder by 2; the word is kept); a word w2 == 1: count++ (a
 * word); w4 = 0x50cd50() & 0x80000003, negative: ((w4 - 1) | 0xfffffffc) + 1 (the remainder by 4); the 16 bytes (four dwords, in order) at rec + 0x36d + w4 * 32 + w2 * 16 (signed words) are copied to
 * self + 0x36 + arg * 64 + i * 16. After the loop count == 0 gives 5. Returns count. NATIVE REJECTION: no copy when Fl18Host.resolve gives NULL for the source address. */
uint32_t m45bbd8_roll_rects(uint8_t *self, uint32_t arg, const Fl29cWorld *world, const Fl18Host *host);

/* 0x4630a3, thiscall (`self` = ecx), `ret 4`, the stack argument is the word `arg` (signed): arg == 0x277f: [0x5b44f0] = 9, [0x5b44f4] = 1, [0x5d162d] = [0x5d0377], [0x5d1631] = 0x5b160c + ([0x5b44f0] << 5) +
 * ([0x5b44f4] << 4), [0x5d1639] = 1, [0x5c39e5] = 0x277f. Otherwise: word [self+0x57] == 0: word [self+0x57] = arg; then by arg - 0x2780 (unsigned, jump table at 0x4631c1 with four dwords): 0 -> [0x5b44f0] = 0x19,
 * 1 -> 0x17, 2 -> 0x18, 3 -> 0x1a, above 3 -> [0x5b44f0] unchanged; then [0x5b44f4] = 1, [0x5d162d] = [0x5d0377], [0x5d1631] = 0x5b160c + ([0x5b44f0] << 5) + ([0x5b44f4] << 4), [0x5d1639] = 1, [0x5c39e5] = the
 * sign-extended arg. The jump table is data after the code (302 bytes span, 286 bytes of code). */
void m4630a3_select_action(uint8_t *self, uint32_t arg, Fl29cWorld *world);

/* 0x43423d, thiscall (`self` = ecx), `ret 4`, the stack argument `name` is a host pointer to a string; returns eax (0 or 1): for i = 0 while i < (signed dword [self+0x5f64]) (read again every pass): p = dword
 * [self + 0x1144 + i*4] + 4 (the length of the constant string at 0x545ef0, measured from the original); n = 0x4347b8(this self, p) (thiscall, one argument); n <= 8 (unsigned): the report 0x42639d(this 0x583979,
 * 0x545f04, 0x545ef8) (thiscall, two arguments) and 0x4c97b4(this 0x5cf659), and the function goes on. p += 4; s = 0x434814(this self, p) (thiscall, one argument; the original address of a string);
 * compare the string s with `name` byte pair by byte pair (the inlined strcmp); when equal: p += 4, dword [self+0x111c] = p, dword [self+0x1128] = n - 4, the string s with its terminator (strlen + 1 bytes: dwords
 * first, then the rest) is copied to self+0x1136, return 1. Different: next i. After the loop return 0. NATIVE REJECTION: return 0 when Fl18Host.resolve gives NULL for s. Caller-validated: the string fits the buffer. */
uint32_t m43423d_find_name_a(uint8_t *self, const uint8_t *name, const Fl18Host *host);

/* 0x4344bf, thiscall (`self` = ecx), `ret 4`, the stack argument `name` is a host pointer to a string; returns eax (0 or 1): the 1000 dwords [self + 0x4fc4 + i*4] (i = 0 .. 999) are cleared; then for i = 0 while
 * i < (signed dword [self+0x5f68]) (read again every pass): p = dword [self + 0x20e4 + i*4]; s = 0x434814(this self, p) (thiscall, one argument); when the string s equals `name` (inlined strcmp) and the dword
 * [self + 0x4fc4 + i*4] is not 1: that dword = 1; p += 4; dword [self+0x112c] = 0x4347b8(this self, p) (thiscall, one argument); p += 4; dword [self+0x1120] = p; the string s with its terminator is copied to
 * self+0x1130; return 1. Equal with the dword 1, or different: next i. After the loop return 0. The flag dwords for i >= 1000 lie behind the cleared range: i = 1000 is dword [self+0x5f64], i = 1001 is the count
 * [self+0x5f68] itself (in-bounds reads/writes of the object, reproduced as they are). NATIVE REJECTION: return 0 when Fl18Host.resolve gives NULL for s. */
uint32_t m4344bf_find_name_b(uint8_t *self, const uint8_t *name, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
