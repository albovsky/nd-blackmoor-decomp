#ifndef BLACKMOOR_ORIGINAL_METHODS_FL28B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL28B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-28 (batch b): methods of the action 0x3f / 0x3e runtimes of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-27 batch c (see
 * original_methods_fl27c.h, whose conventions apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the
 * original address in its leading comment, `self` is the original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep
 * the order of the original. The names are descriptive hints, not recovered source names.
 *
 * Calls into original code and into the imports go through Fl18Host.call (callee address, ecx value, stack arguments with args[0] the LAST one pushed = the first
 * argument of a C prototype); a host that binds them to other m<va>_* symbols says so itself. Host contract: the Fl28bWorld scalars are a snapshot; a host that backs
 * a callee with real original code must flush the world to the original's memory BEFORE each Fl18Host.call and resync it AFTER the call. A callee that changes
 * `self` or a global that the function reads again afterwards is not exercised (tasks/fl28b-handoff.md). Word arguments are taken from the low 16 bits of the
 * stack dword, as the original reads them (`movsx eax, word ptr [ebp+8]`). Nothing here claims original source structure.
 *
 * The object `self` of the slot-table methods (0x41de29, 0x41e043, 0x41e0b4, 0x41e250) holds a table of 0x4b entries of 0x16 bytes at +0x1c (word [+0] = the id or
 * 0xffff for a free slot, dword [+2] = an owned pointer, four dwords [+6 .. +0x15]), the word count [+0x68e], the word [+0x694] and the word capacity [+0x696]. */

typedef struct Fl28bWorld {
    int16_t word_5c3a05, word_5c3a07, word_5c3a09, word_5c3a0b, word_5c3a0d;   /* 0x42e493: the pending state (word_5c3a05 == 0x270f: nothing pending) */
    uint32_t value_5c3a0f, value_5c3a13, value_5c3a17;
    int16_t word_5c39ff;
    uint32_t value_5bb57b, value_5bb57f;                                       /* 0x42e493: the latched copies */
    int16_t word_5bb599, word_5bb595;
    uint32_t value_5bb59b, value_5bb59f, value_5bb5a3, value_5bb1ca, value_583999;
    int16_t word_5b3790, word_5b3792;                                          /* 0x4edfaf: the two extents that centre the rectangle */
} Fl28bWorld;

/* 0x41e043, thiscall, plain `ret`, returns ax: the index (a word) of the first free slot, or 0xffff. When the signed word count [+0x68e] is below the signed word capacity
 * [+0x696]: i = 0; while (signed i < signed capacity) { if (signed word [+0x1c + i * 0x16] == -1) return i; i++ } (i is a word); else (and at the end of the loop) returns 0xffff.
 * The upper half of eax is stale in the original and not part of the result. Caller-validated: the capacity must not exceed the table (0x4b entries): nothing is bounds checked. */
int32_t m41e043_find_free_slot(const uint8_t *self);

/* 0x42e493, cdecl without arguments, plain `ret`: takes the pending state. When the sign-extended word 0x5c3a05 is 0x270f: 0x52139c(0x5459dc, 0, 0) (stdcall, 3 arguments) and
 * 0x4c97b4(this 0x5cf659), and nothing else. Otherwise [0x5bb57b] = [0x5bb57f] = the sign-extended word 0x5c3a07, word [0x5bb599] = word 0x5c3a09, word [0x5bb595] = word 0x5c3a0b,
 * dwords [0x5bb59b] = [0x5c3a0f], [0x5bb59f] = [0x5c3a13], [0x5bb5a3] = [0x5c3a17], word [0x5c39ff] = 1, dword [0x5bb1ca] = 0 when the sign-extended word 0x5c3a0d is 1 else 1,
 * dword [0x583999] = 4 and the words 0x5c3a05 and 0x5c3a07 = 0x270f, in that order. */
void m42e493_take_pending(Fl28bWorld *world, const Fl18Host *host);

/* 0x41de29, thiscall, plain `ret`: empties the slot table. Word [+0x68e] = 0, word [+0x694] = 0xffff, then for i = 0 .. 0x4a (a word): word [+0x1c + i*0x16] = 0xffff; a non-zero
 * dword [+0x1e + i*0x16] is passed to 0x51dc6c (cdecl, one argument) and cleared; then four times j = 0 .. 3: 0x4c2e5b(this 0x5cf659, dword [+0x22 + i*0x16 + j*4]) (thiscall, one
 * argument), for every entry, free or not. */
void m41de29_clear_slots(uint8_t *self, const Fl18Host *host);

/* 0x41e250, thiscall, `ret 4`: releases the slot `slot` (the low word of the stack dword, signed). When the signed word [+0x1c + slot*0x16] is -1: nothing. Otherwise the word =
 * 0xffff; a non-zero dword [+0x1e + slot*0x16] is passed to 0x51dc6c and cleared; 0x4c2e5b(this 0x5cf659, dword [+0x22 + slot*0x16 + j*4]) for j = 0 .. 3; then the word [+0x68e]
 * is decremented as a word and set to 0 when it is then negative (signed). */
void m41e250_release_slot(uint8_t *self, uint32_t slot, const Fl18Host *host);

/* 0x4edfaf, thiscall, `ret 4`: `arg` is unused (the original copies it to a local). With kind = dword [+0x4af] != 3: dword [+0x689] = [+0x1c] + ([+0x24] - [+0x1c] + 1) / 2 - (signed
 * word 0x5b3790) / 2 and dword [+0x68d] = [+0x20] + ([+0x28] - [+0x20] + 1) / 2 - (signed word 0x5b3792) / 2; with kind == 3 the same from the dwords [+0x665], [+0x66d] (into
 * [+0x689]) and [+0x669], [+0x671] (into [+0x68d]). Every division is the `cdq; sub eax, edx; sar eax, 1` form (truncation toward zero), the sums wrap in 32 bits. Then
 * 0x4db993(this 0x5830ce, [+0x689], [+0x68d]) (thiscall, two arguments, `ret 8`). */
void m4edfaf_centre_rect(uint8_t *self, uint32_t arg, const Fl28bWorld *world, const Fl18Host *host);

/* 0x41e0b4, thiscall, `ret 8`, the stack arguments are the words `slot` and `id`: adds the entry `id` at `slot`. When the signed word count [+0x68e] >= the signed word capacity [+0x696] or
 * the signed word [+0x1c + slot*0x16] != -1: 0x52139c(0x5437fc, 0, 0) and 0x4c97b4(this 0x5cf659), and the function goes on. kind = byte [+0x75a]: 0x39, 0x3b or 0x3e: for i = 0 while
 * (signed word i < signed word [+0xf9b]): 0x417b04(this 0x5d2f31, word [+0xfb5 + i*2], dword [+0xfa1] + (signed id)*0x8c + i*0x21, dword [+0x1c + slot*0x16 + i*4 + 6]) (thiscall,
 * three arguments; the first is pushed from `ax` with the upper half of eax left over from the address arithmetic, so only its low 16 bits are defined); any other kind: 0x52139c(0x54384c,
 * 0, 0) and 0x4c97b4(this 0x5cf659). Then word [+0x1c + slot*0x16] = id and the word [+0x68e] is incremented as a word. */
void m41e0b4_add_slot(uint8_t *self, uint32_t slot, uint32_t id, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
