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
    int16_t word_63a4cd;       /* the debug flag: a non-zero word turns on the trace output */
    uint8_t *records_5bb5e5;   /* records of stride 0x8d: the dword at +0 is the address of the object of record n (index: a signed word argument) */
    int16_t word_617e78, word_618783;   /* 0x422a0a: the selected record of table 0x617804 (signed) and the entry count */
    uint8_t byte_617f42;                /* 0x422a0a: the kind (0x39, 0x3b, 0x3e run the loops) */
    uint32_t value_618795;              /* 0x422a0a: the original address of the entry table (resolved through Fl18Host) */
    uint32_t value_58318a, value_583186, value_5cf665, value_5d15e3;   /* 0x422a0a: the offsets added to the rectangles and the two values passed to the drawing calls */
    uint32_t value_5d191d;              /* 0x422a0a: cleared at the end */
    uint8_t *table_617804, *words_61879d, *objs_5d34d1, *rects_617ec2, *rects_617f02;   /* 0x422a0a: host memory of the global tables at those addresses (stride 0x16, words, stride 0x84d, 16-byte rectangles) */
    uint8_t *dwords_585801;    /* 0x4209e8: the base of the dword table 0x585801 (indexed by a signed word, so the host memory must extend below the base too) */
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

/* 0x4205c1, thiscall, `ret 4`, the stack argument is the word `slot`: runs the entries of the record `slot`. rec = the dword at records_5bb5e5 + (signed slot) * 0x8d (an original address; Fl18Host.resolve
 * gives its memory). For i = 0 .. (signed word [rec+0x793]) - 1 (a word): e = dword [rec+0x795] + (signed i) * 0x1d1; r = 0x420737(this self, dword [e+2], word [e], self+0x78e) (thiscall, three
 * arguments; the second is pushed from `cx` with stale upper bits, so only its low word is defined); when the low word of r is zero the entry is skipped, otherwise the byte [e+0x1b7] selects
 * 0 -> 0x41fa11(this self, e), 1 -> 0x41fd08(this self, e), 2 -> 0x42028e(this self, e) (thiscall, one argument), anything else nothing. The record fields and the array address are read again
 * after the call. After the loop: b = byte [rec+0x779]; unless it is 0x14: the indirect call [self + b*4 + 0xf23] (ecx = rec, no arguments); c = byte [rec+0x77a]; unless 0x14: [self + c*4 + 0xf4b]
 * (ecx = c, no arguments). Caller-validated: the entry array must hold the count of entries; the table of the indirect calls must lie inside `self` for the bytes b and c. */
void m4205c1_run_entries(uint8_t *self, uint32_t slot, const Fl28bWorld *world, const Fl18Host *host);

/* 0x4209e8, thiscall, `ret 4`, the stack argument is the word `slot`: the second entry loop of the record. rec as in 0x4205c1; for i = 0 .. (signed word [rec+0x79f]) - 1 (a word): e = dword [rec+0x7a1] +
 * (signed i) * 10; r = 0x420737(this self, dword [e+2], word [e], self+0x7c0); the low word of r zero: next entry. Otherwise by the byte [e+6]: 1 -> with the debug word 0x50ca3e(self+0x1fd1,
 * 0x543b34, signed word [e+7], byte [e+9]) (cdecl, four arguments) and 0x44a2b7(self+0x1fd1); then the dword at dwords_585801 + (signed word [e+7]) * 4 = the byte [e+9]; 2 -> byte [e+9] == 1:
 * 0x4e9e84(this 0x571442, word [e+7], 1) (the word is pushed from `cx` with stale upper bits), otherwise 0x4ea06c(this 0x571442, word [e+7]); anything else nothing. Caller-validated: the
 * dword table must hold every index the entries name. */
void m4209e8_run_small_entries(uint8_t *self, uint32_t slot, const Fl28bWorld *world, const Fl18Host *host);

/* 0x4f6ef4, thiscall, `ret 4`, the stack argument is the dword `arg` (a record number), returns eax: [self+0x3c2] = 0x3e8; rec = dword [self+0x3ce] + arg * 0x5bb (an original address); r = 0x4f709c(this self)
 * (no arguments); r == 0: [self+0x3c2] = 0x3ea, return 0xffffffff. dword [rec+0x162] == 0 or dword [rec+0x28f] == 0: [self+0x3c2] = 0x3ef, return 0xffffffff. 0x4f6334(this self, arg) == 0: return 0xffffffff
 * (no store). n = 0x4f81fa(this self, arg); n == -1: with the debug word 0x50ca3e(0x63888b, 0x55e994, arg, rec+4) (cdecl, four arguments) and 0x44a2b7(0x63888b); [self+0x3c2] = 0x410, return
 * 0xffffffff. Otherwise v = 0 when n <= 0 (signed), else v = __ftol((float)n / (float)(signed dword [rec+0x176])) in 53-bit x87 precision (the quotient of two single-precision floats; __ftol keeps the low dword
 * of the truncated 64-bit result; NaN, infinity and out-of-range values give 0); v = max(v, [rec+0x182]) then v = min(v, [rec+0x17a] - 1) (both signed); [rec+0x17e] = v, [rec+0x182] = v, and the result
 * is the dword [rec+0x17e]. Not exercised: a callee that changes the record. */
uint32_t m4f6ef4_advance_record(uint8_t *self, uint32_t arg, const Fl28bWorld *world, const Fl18Host *host);

/* 0x41c544, thiscall (`self` = ecx), `ret 8`, the stack arguments are `rec` (a host pointer to the record to initialise, at least 0x79f bytes) and `src` (a host pointer to the source record):
 * copies the 6 bytes "dummy" (the string at 0x5431b0, an embedded constant of the port) to rec+0x747, then sets word [rec+0x768] = 0xd, [+0x76a] = 2, [+0x76c] = 1, [+0x76e] = 1, dword [+0x770] = 1,
 * byte [+0x778] = 0, byte [+0x77c] = 2, word [+0x781] = 0, [+0x783] = 1, dwords [+0x785] = 0, [+0x789] = 0, [+0x78d] = 1, word [+0x791] = 2, then bytes [+0x779] [+0x77a] [+0x77b] = src [+0x21] [+0x22] [+0x23],
 * words [+0x77d] [+0x77f] = src [+0x24] [+0x26]. s = 0x423259(this self+0xfd1, src) (thiscall, one argument). s == 0: with the debug word 0x50ca3e(0x63888b, 0x5431b8, src, dword 0x5bb57b) (cdecl, four
 * arguments) and 0x52139c(0x63888b, 0, 0) (stdcall) and then the 65 bytes of the string at 0x5431fc ("<i>Missing conversation text ..." ) are copied to rec+0x16b; without it the string at 0x543240
 * (the same 65 bytes) is copied there. s != 0: the string at the original address s is copied to rec+0x16b (strlen + 1 bytes, dwords first). Finally word [rec+0x793] = src word [+0x28], word [+0x799] = 0,
 * dword [+0x79b] = 0. The two fixed strings are embedded constants. Caller-validated: the copied strings must fit in the record; Fl18Host.resolve must give the memory of s. */
void m41c544_init_record(uint8_t *self, uint8_t *rec, const uint8_t *src, const Fl28bWorld *world, const Fl18Host *host);

/* 0x41fa11, thiscall (`self` = ecx), `ret 4`, the stack argument `arg` is a host pointer to a 0x1d0-byte record: adds the record to the table of at most 0x1e entries unless an equal block exists. count = the
 * signed word [self+0xf21]. With the debug word and count + 1 > 0x1e: 0x50ca3e(0x63888b, 0x543a58, count + 1) (cdecl, three arguments) and 0x4264e8(this 0x583979, 0x63888b). count + 1 > 0x1e: return. For
 * j = 0 .. count - 1 (a word): p = 0x51ea75(this self+0xea5+j*4, 0x190) (thiscall, one argument); 0x50d550(p, arg+6, 0x190) (cdecl, three arguments); then 0x51eac4(this self+0xea5+j*4, 0xffffffff) in both
 * cases; a zero result of 0x50d550 (an equal block) returns at once. No equal block: p = 0x51ea75(this self+0xea5+count*4, 0x190); 0x190 bytes from arg+6 are copied to the original address p (dwords);
 * 0x51eac4(this ..., 0xffffffff); then for b = self + count*0x3a (signed count, 32-bit): word [b+0x800] = arg word [+0x1be], [b+0x7fe] = [+0x1bc], [b+0x7fa] = [+0x1b8], [b+0x7fc] = [+0x1ba], dwords [b+0x802] =
 * [+0x1c0], [b+0x806] = [+0x1c4], [b+0x80a] = [+0x1c8], the string at arg+0x196 (strlen + 1 bytes, dwords first) to b+0x7d9 (a string of 0x21 or more characters clobbers the words stored before it), word [b+0x80e] =
 * arg word [+0x1cc], byte [b+0x810] = arg byte [+0x1ce], word [b+0x811] = arg word [+0x1cf], and the word count is incremented. Caller-validated: the table index must lie inside `self`. */
void m41fa11_add_entry(uint8_t *self, const uint8_t *arg, const Fl28bWorld *world, const Fl18Host *host);

/* 0x422a0a, cdecl, no arguments, plain `ret`: draws the marked entries. rec = table_617804 + (signed word_617e78) * 0x16 (its dwords at +6 + 4*j are the original addresses of the sub-objects). When the byte
 * 0x617f42 is 0x39, 0x3b or 0x3e: for i = 0 .. (signed word_618783) - 1 (a word), for j = 0 .. (signed word_618783) - 1 (a word): with tbl = value_618795 (an original address): the byte [tbl + j + 0xb2] must
 * equal i (the byte is compared against the sign-extended word), else the next j; the first j that matches ends the inner loop after its arm (and so does sel > 3 without any arm): i goes on. obj = objs_5d34d1 + (signed word [words_61879d + 2*j]) * 0x84d; sub = dword [rec + 6 + 4*j]; sel = byte [obj + 0x1e], unsigned > 3: the inner loop ends;
 * the jump table makes 2 the second arm and 0, 1, 3 the first. First arm: when byte [tbl + j + 0xb6] == 2 (rectangles from the table at tbl + j*16: l1c = the 16 bytes at +0xba, l44 = {[+0xfa] + value_583186,
 * [+0xfe] + value_58318a, [+0x102] + value_583186, [+0x106] + value_58318a}, l34 = the 16 bytes at +0xfa), otherwise from sub (l1c = the 16 bytes at sub+0x35, l44 = {[sub+0x45] + value_583186, [sub+0x49] +
 * value_58318a, [sub+0x4d] + value_583186, [sub+0x51] + value_58318a}, l34 = the 16 bytes at sub+0x45). Then by the byte [obj + 0x1f]: 1 -> 0x4c5377(this 0x5cf659, value_5d15e3, value_5cf665, &l34, &l44, 0x544330)
 * (thiscall, five arguments) and 0x4c609b(this 0x5cf659, dword [sub], value_5cf665, &l1c, &l44, signed word [sub+0x2f], 0x54434c) (six arguments); 2 -> 0x4c5770(this 0x5cf659, dword [sub], value_5cf665, &l1c,
 * &l44, signed word [sub+0x2f], 0x544368); anything else nothing. Second arm: l44 from sub as above, 0x4c5377(this 0x5cf659, value_5d15e3, value_5cf665, 0x617ec2 + j*16, 0x617f02 + j*16, 0x544388); then by
 * the byte [obj + 0x1f] (read again): 1 -> 0x4c609b(dword [sub], value_5cf665, sub+0x35, &l44, signed word [sub+0x2f], 0x5443a4), 2 -> 0x4c5770(.., 0x5443c0); then the 16 bytes at sub+0x45 are copied to
 * rects_617ec2 + j*16 and l44 to rects_617f02 + j*16. At the end (also when the kind does not match) value_5d191d = 0. The pointers &l.. are host pointers to locals; Caller-validated: j < 4, the tables
 * must hold every index the words and counts name. Not exercised: a callee that changes the tables. */
void m422a0a_draw_marked(Fl28bWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
