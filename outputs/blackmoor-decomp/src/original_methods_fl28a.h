#ifndef BLACKMOOR_ORIGINAL_METHODS_FL28A_H
#define BLACKMOOR_ORIGINAL_METHODS_FL28A_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-28 (batch a): small methods of the action 0xa1 / 0x3f runtimes of GAME.EXE (SHA-256 afd337a2...5c45), ported one to one in the style of
 * FL-26 / FL-27 (see original_methods_fl26a.h and original_methods_fl27c.h, whose conventions apply unchanged; Fl18Host from
 * original_methods_fl18.h is reused): each is its own symbol that cites the original address in its leading comment, `self` is the original
 * `this` object (ecx) as raw bytes at the original offsets, and the effects keep the order of the original.
 *
 * Calls into original code and the imports go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one
 * pushed, i.e. the first argument of the callee). A call through a vtable passes the address read from the vtable as the callee (the host
 * recognises the entry). An address that the function reads or writes through (a string, a record, an interface object) goes through
 * Fl18Host.resolve; `self` is a host pointer.
 *
 * Fatal paths: the original reports (0x50ca3e, 0x52139c, 0x44a2b7 when the debug word 0x63a4cd is non-zero) and then calls 0x4c97b4 with
 * ecx 0x5cf659, which ends the process (it calls the import behind [0x63a58a] and does not return). The port makes the same calls in the
 * same order and then stops: it returns (NULL / nothing) where the original would not come back. That stop is the only native addition on
 * those paths (what a host whose 0x4c97b4 returns would see differs from the original, which would run on or loop without end).
 *
 * Callees inside this batch (0x4f356e from 0x4fc808, 0x423368 from 0x423142) are host calls: the host decides whether to bind them to the
 * m<va>_* ports. A callee that changes `self` or a global the function re-reads is not exercised (stated per function).
 * Nothing here claims original source structure. */

typedef struct Fl28aWorld {
    int16_t word_63a4cd;                   /* the debug word 0x63a4cd (any non-zero value switches the traces on) */
} Fl28aWorld;

/* 0x4235fd: thiscall, plain `ret`: the count dword [self + 4] is zero: returns NULL; otherwise [self + 4] -= 1 and returns the address of the
 * entry self + 8 + 12 * [self + 4] (the new count; 32-bit wrap). Entries are 12 bytes at self + 8. */
uint8_t *m4235fd_pop(uint8_t *self);

/* 0x4fc808: thiscall, `ret 4`, argument `slot` (only its low 16 bits are used): debug word non-zero: 0x50ca3e(0x63888b, 0x56090c, slot16),
 * 0x44a2b7(0x63888b); then 0x4f356e (ecx 0x5cf1eb, slot16); then the word [self + slot16 * 0x5bb + 0x132] = 0. */
void m4fc808_clear_slot(uint8_t *self, uint32_t slot, const Fl28aWorld *world, const Fl18Host *host);

/* 0x4237f7: plain `ret`, no argument (ecx is saved and unused): p = 0x51dc43(0x4c). Zero: 0x50ca3e(0x63888b, 0x5446e0), then the fatal tail
 * (0x52139c(0x63888b, 0, 0); 0x44a2b7(0x63888b) when the debug word is non-zero; 0x4c97b4 with ecx 0x5cf659) and the port returns 0; the original
 * never comes back (0x4c97b4 ends the process; if it returned the code would loop between 0x42383f and 0x42386f without end). Otherwise the 0x4c
 * bytes at p (an original address, written through resolve) are cleared (rep stosd, 19 dwords) and p is returned. */
uint32_t m4237f7_new_block(const Fl28aWorld *world, const Fl18Host *host);

/* 0x4236d6: the same as 0x4237f7 with 0x1c bytes (7 dwords) and the message 0x5445f8. */
uint32_t m4236d6_new_block(const Fl28aWorld *world, const Fl18Host *host);

/* 0x4f80d3: thiscall, `ret 8`, arguments `obj` (the original address of an interface object) and `arg`: [self + 0x3ca] = 0; calls the vtable entry
 * [[obj] + 0x30] (stdcall: obj, 0, 0, arg) and stores its result in [self + 0x3ca]; when that is 0x88780096 calls [[obj] + 0x50] (obj) and the
 * entry 0x30 again with the same arguments, storing the new result. Returns 1 when [self + 0x3ca] is zero, else 0. The vtable and the entries are
 * read through resolve (0x34 / 0x54 bytes). */
uint32_t m4f80d3_play_retry(uint8_t *self, uint32_t obj, uint32_t arg, const Fl18Host *host);

/* 0x42356d: thiscall, `ret 8`, arguments a, b: the count [self + 4] (signed dword) >= 0x80: the fatal report (0x50ca3e(0x63888b, 0x544514),
 * 0x52139c(0x63888b, 0, 0), 0x44a2b7 when the debug word is non-zero, 0x4c97b4 with ecx 0x5cf659) and the port stops (the original does not come
 * back); otherwise [self + 12 * count + 8] = a, [self + 12 * [self + 4] + 0x10] = b (the count is read again) and [self + 4] = [self + 4] + 1 (read
 * again). A negative count (jl) is a valid path and reaches below self (caller-validated, as in the original). */
void m42356d_push(uint8_t *self, uint32_t a, uint32_t b, const Fl28aWorld *world, const Fl18Host *host);

/* 0x4fb2e3: thiscall, `ret 4`, argument `slot` (low 16 bits): debug word non-zero: 0x50ca3e(0x63888b, 0x560794, slot16), 0x44a2b7(0x63888b); r =
 * 0x4f6059 (ecx 0x5cf1eb, slot16); r zero and the debug word (read again) non-zero: x = 0x4fa2a8 (ecx 0x5cf1eb), 0x50ca3e(0x63888b, 0x5607c4, slot16,
 * x), 0x44a2b7(0x63888b); then the word [self + slot16 * 0x5bb + 0x132] = 1. */
void m4fb2e3_start_slot(uint8_t *self, uint32_t slot, const Fl28aWorld *world, const Fl18Host *host);

/* 0x423368: thiscall, `ret 4`, argument `name` (the original address of a zero-terminated string; read through resolve), returns the signed 16-bit
 * value (`ax` sign-extended). len = strlen(name) as a 16-bit value; v = 0x50cb1b(name + 3) (cdecl); v = v & 0x800003ff made non-negative by the
 * remainder idiom (a negative value becomes ((v - 1) | 0xfffffc00) + 1); h = (int16) v; h non-zero: returned. Otherwise for i = 0, 1, ... while
 * (int16) i < (int16) len: c = (signed byte) name[i]; 0x50d6cf(c) (cdecl, c sign-extended) non-zero: h = (int16) of the same remainder of
 * 0x50cb1b(name + i) (i sign-extended), returned. After the loop h (zero there) is replaced by (int16)(signed byte) name[0] and returned. */
int32_t m423368_hash_name(uint32_t name, const Fl18Host *host);

/* 0x4f356e: thiscall, `ret 4`, argument `idx` (a dword; the record is idx * 0x5bb bytes on): [self + 0x3c2] = 0x3e8; rec = [self + 0x3ce] + idx * 0x5bb (an
 * original address, 32-bit wrap; the record is read and written through resolve, 0x2f5 bytes); 0x4f709c (this = self) zero: returns 1. Then, when the
 * dwords [rec + 0x162], [rec + 0x29b], [rec + 0x28f], [rec + 0x28b] are all non-zero and the unsigned dword [self + 0x3d6] is non-zero: [self + 0x3d6] -= 1 and
 * [rec + 0x28b] = 0. [rec + 0x28f] non-zero: 0x4f6334 (this = self, idx) non-zero: 0x4f61e7 (this = self, idx). [rec + 0x293] non-zero: its vtable entry +8 is
 * called with the object (Release) and the dword is cleared. [rec + 0x297] non-zero: 0x51dc6c (the dword; both arms of the test of [rec + 0x166] make
 * the same call) and the dword is cleared. [rec + 0x29b] and then [rec + 0x28f], re-read after the callees, non-zero: Release through the vtable and cleared.
 * [rec + 0x2f1] non-zero: 0x4fcef0 (rec + 0x2f1, an original address) and cleared. [rec + 0x156] non-zero: 0x50cee4 (the dword) and cleared. Finally
 * [rec + 0x162] = 0, [rec + 0x152] = 0; returns 1. Every field is re-read where the original reads it again (callees may change them); the record, the
 * objects and their vtables (12 bytes) are caller-validated. */
uint32_t m4f356e_unload(uint8_t *self, uint32_t idx, const Fl18Host *host);

/*DECLS*/

#ifdef __cplusplus
}
#endif

#endif
