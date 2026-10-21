#ifndef BLACKMOOR_ORIGINAL_METHODS_FL36A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL36A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-36 (batch a): two large functions of GAME.EXE (SHA-256 afd337a2...5c45), 0x4f379c and 0x4c36b2, ported one to one in the style of FL-33c (see original_methods_fl33c.h, whose
 * conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in the comment directly above it, `self` is
 * the original object (ecx) as raw bytes at the original offsets, and the effects keep the order of the original. The names are descriptive hints, not recovered source names.
 *
 * Calls into original code, the CRT and the imports go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first argument of a C prototype). A
 * dword that holds an address of the original is a 32-bit original address and goes through Fl18Host.resolve; the address of a local that the original passes to a callee is a host pointer. Strings,
 * tables and records that live in the original's data are read through Fl18Host.resolve; no original bytes are in this file. A callee that changes `self` or a global that the function reads
 * again afterwards is only exercised where the fixtures script it (tasks/fl36a-handoff.md). Functions that can fault, run endlessly, overrun their frame or read an indeterminate stack slot in the
 * original return an int status: 0 = ran as the original, 1 = the port stops where the original would do that (documented per function; the host must not rely on anything after a 1). */

typedef struct Fl36aWorld {
    int16_t word_63a4cd, word_63aa14;                                          /* 0x4f379c (the debug word is also read by 0x4c36b2) */
    int16_t word_63988b, word_63988d, word_639895;                            /* 0x4c36b2 */
    uint8_t byte_639893;                                                       /* 0x4c36b2 */
    uint32_t value_5839a9;                                                     /* 0x4c36b2 */
    /* WORLD-END */
} Fl36aWorld;

/* 0x4f379c, thiscall, `ret 4`, one stack argument id ([ebp+8]; only the low 16 bits are read, zero extended). Returns (eax) the dword [self+0x3be] in every path.
 * local = a 0x24-byte frame area at [ebp-0x24]: the word 0x63aa14 followed by zeros (the original zero fills 30 bytes behind the word). [self+0x3be] = 1, [self+0x3c2] = 0x3e8;
 * entry = dword [self+0x3ce] + id * 0x5bb (32-bit, an original address; every field below is at an offset into entry, unaligned allowed, read through Fl18Host.resolve).
 * When dword [entry+0x162] != 0: 0x4f356e(this self, id) (thiscall, 1 argument). fp = 0x50d0a9(entry + 4, 0x55dab0) (cdecl, 2 arguments); dword [entry+0x156] = fp; fp == 0: [self+0x3c2] = 0x3ed,
 * [self+0x3be] = 0, return 0. Then 0x50cf61(entry + 0x10a, 0x1e, 1, fp) (cdecl, 4 arguments) == 0: [self+0x3c2] = 0x3ec, [self+0x3be] = 0, return 0. The header must be: the 4 bytes at entry+0x10a equal
 * the 4 bytes at 0x55dab4, signed word [entry+0x10e] == 2 and signed word [entry+0x110] == 0; otherwise 0x4f356e(this self, id), [self+0x3c2] = 0x3f9, [self+0x3be] = 0, return 0.
 * Then [entry+0x162] = 1, [entry+0x152] = 0; the range pair p = [entry+0x1aa], q = [entry+0x1ae] is replaced by the defaults [self+0x446], [self+0x44a] unless (p != 0 || q != 0) and (q - p) > 0 (32-bit
 * difference, SIGNED); the pairs ([+0x1b2], [+0x1b6]), ([+0x1ba], [+0x1be]), ([+0x1c2], [+0x1c6]) are swapped when the first is greater than the second (SIGNED); [+0x1d6] <= 1 (signed) becomes [self+0x466]
 * and [+0x1da] <= 1 (signed) becomes [self+0x46a]; [+0x287] = 0, [+0x19e] = 0, [+0x28b] = 0; size = dword [entry+0x122] is stored at [+0x15e].
 * size < 0 (signed): when the signed word 0x63a4cd != 0: 0x4f356e(this self, id), 0x50ca3e(0x63888b, 0x55dab8, entry + 4) (cdecl, THREE arguments) and 0x52139c(0x63888b, 0, 0) (stdcall); return 0 (also with the
 * debug word zero). Otherwise, when signed word [entry+0x126] == 2: the NUL-terminated string at 0x55dafc is copied with its NUL to the start of the frame area (dwords first, then bytes): the original's
 * area is 0x20 bytes plus a 4-byte temporary below it, so a string of more than 0x24 bytes with its NUL (36 characters or more) would run over the saved registers: the port returns status 1 right there (everything before has
 * happened). size > 0x56220 (signed): [+0x166] = 1; debug word != 0: 0x50ca3e(0x63888b, 0x55db08, the address of the frame area (a host
 * pointer), id, entry + 4) (cdecl, FIVE arguments) and 0x44a2b7(0x63888b) (cdecl); 0x4f438f(this self, id) (thiscall, 1 argument; the original pushes the word from cx with a stale upper half, the port
 * passes it zero extended) == 0: return 0; else return dword [self+0x3be] (read again). Otherwise (size <= 0x56220): [+0x166] = 0; debug word != 0: 0x50ca3e(0x63888b, 0x55db40, id, entry + 4) (cdecl, FOUR
 * arguments) and 0x44a2b7(0x63888b); 0x4f3c26(this self, id) (thiscall, 1 argument, word as above) == 0: return 0; else return dword [self+0x3be] (read again). The result is stored at *result.
 * Callees that change [self+0x3be] are only exercised through the fixtures' scripted stores. Status 1: see the string copy above; *result is not set then. */
int m4f379c_open_entry(uint8_t *self, uint32_t id, uint32_t *result, const Fl36aWorld *world, const Fl18Host *host);

/* 0x4c36b2, thiscall (ecx is stored and used only as `self`), `ret 4`, one stack argument index ([ebp+8]; only the low 16 bits are read). Returns status 0 or 1 (no value). rec = 0x5bb5e5 + index * 0x8d (index
 * = the SIGNED word); obj = dword [rec] (an original address; the fields below are unaligned fields of the object it points to, read through Fl18Host.resolve) and state = dword [rec+0x4d], both read first.
 * state 0: dword 0x5839a9 = 1; 0x4d36ed(this obj) (thiscall, 0 arguments: the original has ecx = obj at that call); dword [rec+0x4d] = 2. state 3: 0x42ba3a(index & 0xffff) (cdecl, 1 argument). Any other state: nothing.
 * state 2: W, H, bpp = the signed words 0x63988b, 0x63988d, 0x639895 (sign extended); when [obj+0x2d] > H or [obj+0x29] > W (SIGNED): return 0 (nothing happens). buf1 = 0x51dc43(W * H * bpp) (cdecl, 1 argument,
 * 32-bit product); buf1 == 0: the signed word 0x63a4cd != 0: 0x44a2b7(0x554120) (cdecl, 1 argument); then the original goes on to its cleanup and tests the local [ebp-0xb8] (the second buffer) BEFORE it has
 * set it: indeterminate stack, so the port returns status 1 right after this call and changes nothing else (documented in tasks/fl36a-handoff.md).
 * Otherwise w2 = [obj+0x29] - [obj+0x21], h2 = [obj+0x2d] - [obj+0x25] (32-bit), size2 = w2 * h2 * bpp, buf2 = 0x51dc43(size2); buf2 == 0: debug word != 0: 0x44a2b7(0x55415c); go to the cleanup. Else:
 * 0x4c4067(this self, dword [self+8], 0, desc, 0x55419c, 0x10) (thiscall, 5 arguments; desc = a 0x80-byte local, a host pointer; the callee stores dword v1 at desc+0x10 and v2 at desc+0x24; zero filled here, the
 * original leaves stack garbage), 0x43f04b(this 0x5d2f2d, buf1, v2, H, W * bpp, v1) (thiscall, 5 arguments), 0x4c4202(this self, dword [self+8], 0, 0x5541d0) (thiscall, 3 arguments).
 * When NOT (w2 < W) and h2 >= H (both SIGNED): size W * H * bpp bytes are copied from buf1 to buf2 (dwords first, then bytes); otherwise for each row i = 0 while i < h2 (signed): w2 * bpp bytes from
 * src to dst (dwords first, then bytes), src += W * bpp, dst += w2 * bpp, starting at src = buf1 + bpp * (W * [obj+0x25] + [obj+0x21]) (32-bit), dst = buf2.
 * When the BYTE [obj+0x31] is 0: 0x4c334f(this self, buf2, w2, h2, obj) (thiscall, 4 arguments) == 0 and the debug word != 0: 0x44a2b7(0x554204). Otherwise a 0x12-byte header is built in a local (bytes 0, 0, 2,
 * zeros, word w2 at +0xc, word h2 at +0xe, byte 0x639893 at +0x10, 0x20 at +0x11): 0x50cd72(0x63888b, 0x639a9f, 0x639aa2, obj, 0x554238) (cdecl, 5 arguments), fp = 0x50d0a9(0x63888b, 0x554240) (cdecl, 2 arguments);
 * fp != 0: 0x50e493(the header (a host pointer), 0x12, 1, fp) (cdecl, 4 arguments), 0x4c7481(this self, buf2, size2) (thiscall, 2 arguments), 0x50e493(buf2, size2, 1, fp), 0x50cee4(fp) (cdecl, 1 argument).
 * Cleanup: buf1 != 0: 0x51dc6c(buf1) (cdecl, 1 argument); buf2 != 0: 0x51dc6c(buf2); dword 0x5839a9 = 0; dword [rec+0x4d] = 3. The original tests fp != 0 a second time before 0x50cee4 (the `je` at 0x4c3baa); that
 * test cannot fail (fp is a local nobody writes), so its taken edge is flagged in tests/fl36a_fixtures.UNTAKEN_ALLOWED; every instruction still runs.
 * The dead store [ebp-4] = bpp * [obj+0x21] is not ported. Callees that change self, obj or the globals are not exercised. */
int m4c36b2_save_region(uint8_t *self, uint32_t index, Fl36aWorld *world, const Fl18Host *host);

/* FNS-END */

#ifdef __cplusplus
}
#endif

#endif
