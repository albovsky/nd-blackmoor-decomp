#ifndef BLACKMOOR_ORIGINAL_METHODS_FL29B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL29B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-29 (batch b): ten small methods of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-28 batch b (see original_methods_fl28b.h, whose conventions
 * apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment, `self` is
 * the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked unless a function says so, and the effects keep the order of the original.
 * The names are descriptive hints, not recovered source names.
 *
 * Calls into original code go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first argument of a C prototype).
 * A dword inside an object that holds an address of the original is turned into host memory with Fl18Host.resolve. A stack argument that the original treats as a pointer
 * is a host pointer here (a pointer to a dword cell holds an original 32-bit address). Host contract: the Fl29bWorld scalars are a snapshot; a host that backs a callee with
 * real original code must flush the world to the original's memory BEFORE each Fl18Host.call and resync it AFTER the call. A callee that changes `self` or a global that the
 * function reads again afterwards is not exercised, except where a function below says so (tasks/fl29b-handoff.md).
 *
 * Native rejections (documented separately from the valid-input behaviour; the original has no such path): an address that Fl18Host.resolve cannot turn into host memory
 * ends the function at that point (the original would fault); 0x423aae stops after FL29B_CHAIN_LIMIT links (the original would loop for ever on a cyclic chain); 0x4e4337
 * does not run the third block copy when its size word is negative (the original would run a rep movsd of about 2^30 dwords). */

typedef struct Fl29bWorld {
    int16_t word_63a4cd;                  /* the debug flag: a non-zero word turns on the trace output (0x4fccf2, 0x42e72c, 0x4e9c2f, 0x411a22) */
    uint32_t value_5d03bf;                /* 0x42e72c: the address (of the original) of the dword that receives the chosen value; 0 = none */
    int16_t word_5b4dc8, word_5b4e04;     /* 0x42e72c: the toggled index and the mode */
    uint32_t value_5b4db8, value_5b4dbc;  /* 0x42e72c: the two-entry table of dwords at 0x5b4db8 */
    uint32_t value_5bb57b;                /* 0x4e9c2f, 0x411a22: logged by the allocation failure report */
    int16_t word_5c39e3;                  /* 0x4e9c2f, 0x411a22: the record index (signed word) */
    int16_t word_5a1e5c;                  /* 0x4e45be: the number of rows */
    uint8_t *table_5a1e64;                /* 0x4e45be: host memory at the global address 0x5a1e64 (rows of 0x29 bytes) */
    uint8_t *records_5bb5e5;              /* 0x411a22: host memory at the global address 0x5bb5e5 (records of 0x8d bytes, indexed by a signed word, so the memory extends below the base) */
    uint32_t value_5e32c9, value_5e32de;  /* 0x437dcd: the enable dword and the latched flag */
    uint8_t byte_5e32dd;                  /* 0x437dcd: the latched character */
    uint8_t byte_5b61af, byte_5b616b, byte_5b616c;   /* 0x437dcd: the second enable byte, its latched flag and character */
} Fl29bWorld;

#define FL29B_CHAIN_LIMIT 0x100000

/* 0x4ee69e, thiscall, plain `ret`, returns eax: when the dword [self + 0x252] is non-zero, returns the result of 0x4ef516 (thiscall, no arguments, this = self + 0x4b7);
 * otherwise 0. */
uint32_t m4ee69e_forward_if_set(const uint8_t *self, const Fl18Host *host);

/* 0x423aae, thiscall (ecx unused), `ret 4`, returns eax: `arg` is an address of the original. 0 when arg is 0; q = dword [arg + 4]; 0 when q is 0; then while the dword
 * [q + 0x38] is non-zero q = that dword; returns q (an address of the original). Native rejection: an unresolvable link or more than FL29B_CHAIN_LIMIT links returns 0. */
uint32_t m423aae_chain_end(uint32_t arg, const Fl18Host *host);

/* 0x4fccf2, thiscall, `ret 8`, returns the eax of 0x4fcb5c: when the sign-extended word 0x63a4cd is non-zero 0x44a2b7(0x5609d4) (cdecl, one argument); then the float
 * (float)(unsigned)(a & 0xffff) divided by the float constant 100.0 at 0x52cbec (x87 control word 0x27f: the quotient is a double, stored as a float) is stored as the dword
 * [self + index * 4 + 0xb764] (32-bit wrap of the address), and 0x4fcb5c(this = self, index) (thiscall, one argument) is called and its result returned. */
uint32_t m4fccf2_store_percent(uint8_t *self, uint32_t a, uint32_t index, const Fl29bWorld *world, const Fl18Host *host);

/* 0x423a30, thiscall (ecx unused), `ret 4`: `cell` points to a dword (host pointer). When the dword is 0: 0x50ca3e(0x63888b, 0x544820) (cdecl, two arguments), then the report
 * 0x52139c(0x63888b, 0, 0) (stdcall, three), then when the sign-extended word 0x63a4cd is non-zero 0x44a2b7(0x63888b) (cdecl, one) and 0x4c97b4(this 0x5cf659). Otherwise
 * 0x51dc6c(the dword) (cdecl, one argument) and the dword is cleared. */
void m423a30_free_cell(uint8_t *cell, const Fl29bWorld *world, const Fl18Host *host);

/* 0x42e72c, cdecl without arguments, plain `ret`: when the dword [0x5d03bf] is 0 only the trace call 0x44a2b7(0x545aac) (when the debug word is non-zero). Otherwise
 * 0x44c479(0x5b4c3a) (cdecl, one); the word [0x5b4dc8] is toggled (0 -> 1, non-zero -> 0); when the sign-extended word [0x5b4e04] is 2 the dword whose address is
 * [0x5d03bf] (re-read at this point) receives the dword [0x5b4db8 + 4 * word [0x5b4dc8]]; then 0x44c4ab(0x5b4c3a) (cdecl, one). */
void m42e72c_toggle_state(Fl29bWorld *world, const Fl18Host *host);

/* 0x4e9c2f, thiscall (ecx unused), `ret 0xc`: `out`, `src` and `adv` point to dword cells (host pointers; a cell holds an address of the original). p = 0x51dc43(6) (cdecl, one
 * argument); the cell `out` = p. When p is 0: 0x50ca3e(0x63888b, 0x55c934, [0x5bb57b], sign-extended word [0x5c39e3]) (cdecl, four), 0x42639d(this 0x583979, 0x55c960, 0x63888b)
 * (thiscall, two) and 0x4c97b4(this 0x5cf659); the function then continues (the report returns). Then: s = *src; d = *out (re-read); the dword at s is stored at d and the word at
 * s + 4 (read after that store) at d + 4; *adv += 6; *src += 6; and the trace call 0x44a2b7(0x55c97c) when the debug word is non-zero. Native rejection: s or d not
 * resolvable (the original writes to or reads from the address it holds, for example 0 after a failed allocation) returns after the cell updates that precede the copy. */
void m4e9c2f_copy_six(uint8_t *out, uint8_t *src, uint8_t *adv, const Fl29bWorld *world, const Fl18Host *host);

/* 0x4e45be, thiscall (ecx unused), `ret 0x10`, returns eax: `out` points to a word, `bytes` to a byte string, the third stack argument is not used, `len` is a word. When the
 * signed word len is 0: returns 0 (nothing stored). Otherwise word [out] = 0 and for i = 0 while the signed word i is below the signed word [0x5a1e5c], i++: j = 0 while the
 * signed word j is below len: compares the byte [0x5a1e64 + i * 0x29 + j] with bytes[j] and, on the first difference, leaves the inner loop with the row marked as different; a row
 * without difference stores word [out] = i and ends the search. Returns 1 when the last row examined had no difference, else 0. When the row count is not positive the original
 * returns `sete` of an uninitialised local: the port returns 0 there (rejection; the fixtures keep the count positive). That result is unspecified in the original and the case is REACHABLE: the caller 0x4e7253 (phone insert) calls this with the count 0x5a1e5c = 0 on an empty table, so 0x4e45be is NOT credited as a port acceptance (tasks/fl29b-handoff.md). */
uint32_t m4e45be_find_row(uint8_t *out, const uint8_t *bytes, uint32_t len, const Fl29bWorld *world);

/* 0x437dcd, thiscall, `ret 0xc` (only the first of the three stack arguments is read): `p` points to a character (host pointer). With c = *p: when the dword [0x5e32c9] is non-zero and
 * the dword [0x5e32de] is 0: 0x437ea1(this = self, c) (thiscall, one argument; the original pushes ecx = (self & 0xffffff00) | c, the callee reads only the low byte); when it returns
 * non-zero and the sign-extended *p (re-read each time) is none of 0x2f, 0x3f, 0x3a: byte [0x5e32dd] = *p, dword [0x5e32de] = 1. Then when the byte [0x5b61af] is non-zero and the byte
 * [0x5b616b] is 0: 0x437ea1(self, c) (the pushed dword is exactly c here); when non-zero: byte [0x5b616c] = *p, byte [0x5b616b] = 1. Then the sign-extended *p is passed to
 * 0x4a1f59 (this 0x61d2dd), 0x48e93e (this 0x624dc9), 0x4b8193 (this 0x61ee6e) (thiscall, one argument each), in that order. */
void m437dcd_note_key(const uint8_t *self, const uint8_t *p, Fl29bWorld *world, const Fl18Host *host);

/* 0x4e4337, thiscall (ecx unused except as `self`), `ret 8`: `self` is the object (host pointer), `src` the source buffer (host pointer), `limit` a signed dword. Copies 0xbc dwords from
 * src to self + 0x6d2; then 0x2ac dwords and one byte from src + 0x2f0 to self + 0x9c2; then n = the signed word [self + 0x1471] (read after the second copy) times 0x29, truncated to a
 * word and sign-extended, bytes from src + 0xda1 to self + 0x457b (rep movsd n >> 2 then rep movsb n & 3, forward). total = 0xda1 + n; when total > limit (signed): 0x50ca3e(0x63888b,
 * 0x55c0c0, total, limit) (cdecl, four), 0x4264e8(this 0x583979, 0x63888b) (thiscall, one), 0x4c97b4(this 0x5cf659). Native rejection: n < 0 (the original would copy about 2^30 dwords)
 * returns after the second copy. */
void m4e4337_load_blocks(uint8_t *self, const uint8_t *src, uint32_t limit, const Fl18Host *host);

/* 0x411a22, thiscall (ecx unused), `ret 0xc`: `dst`, `src` and `adv` point to dword cells (host pointers). p = 0x51dc43(0x27) (cdecl, one argument) (the word [*src + 0x23] is read and
 * compared with 10 first; both arms store the length 0x27); the dword at 0x5bb5e5 + 0x8d * (signed word [0x5c39e3]) = p (also when p is 0). When p is 0: 0x50ca3e(0x63888b, 0x541404,
 * [0x5bb57b], sign-extended word [0x5c39e3]) (cdecl, four), 0x42639d(this 0x583979, 0x541430, 0x63888b) (thiscall, two) and 0x4c97b4(this 0x5cf659); the function continues. Then
 * 0x27 bytes are copied forward (rep movsd 9 dwords, rep movsb 3 bytes) from the address in *src to the address in *dst; *adv += 0x27; *src += 0x27; and the trace call
 * 0x44a2b7(0x54144c) when the debug word is non-zero. Native rejection: an address that cannot be resolved ends the function before the copy. */
void m411a22_alloc_copy(uint8_t *dst, uint8_t *src, uint8_t *adv, const Fl29bWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
