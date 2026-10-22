#ifndef BLACKMOOR_ORIGINAL_METHODS_FL39F_H
#define BLACKMOOR_ORIGINAL_METHODS_FL39F_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-39 (batch f): 26 functions of GAME.EXE (SHA-256 afd337a2...5c45) at or above 0x480000 ported one to one, in the style of FL-36 (see original_methods_fl36f.h, whose conventions
 * apply unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment, `self` is the
 * original object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names are descriptive hints, not
 * recovered source names. The constants of every row (field offsets, callees, stored values, sizes) were read from that row's own disassembly by the generator, which also
 * asserted that every row of a kind has the identical masked instruction stream. A dword of `self` that holds an address of the original goes through Fl18Host.resolve;
 * a callee that changes `self` or a global that the function reads again afterwards is not exercised. */

typedef struct Fl39fWorld {
    uint8_t *table_5bb5e5; /* records of stride 0x8d at the original address 0x5bb5e5 (the dword at +0 is the address of a descriptor); the caller leaves slack for a negative index */
    const uint8_t *bytes_54f888; /* the nine bytes at 0x54f888 that the function compares with when its gate is set */
    const uint8_t *bytes_54f894; /* the nine bytes at 0x54f894 that the function compares with when its gate is clear */
    int16_t word_63a4cd; /* the debug word: a non-zero word turns the trace call on */
    uint8_t *table_583f1f; /* the table of 70 records of stride 0x6e at the original address 0x583f1f (its first byte is the first record's flag byte) */
    const uint8_t *bytes_56040c; /* the 21 bytes at 0x56040c that the function compares a name with */
} Fl39fWorld;

/* 0x48ef40, thiscall, plain `ret`, no return value: d = the dword at 0x5bb5e5 + sl*0x8d (sl = the signed word [self+0x1e]) is the address of a descriptor; m = its signed word [d+0xb0]; the signed word [self+0x3fe] = (that word sign-extended + 1) % m (idiv remainder, sign of the dividend); then for i = 1 while i < m and the dword [self + word*4 + 0x46a] (word sign-extended) is non-zero: the same update. m must not be 0 (the original faults). */
void m48ef40_advance_slot(uint8_t *self, const Fl39fWorld *world, const Fl18Host *host);

/* 0x4904fa, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, 0 arguments), then dword [this+0x0] = 0x52daf8, then dword [this+0x1f77] = 0x0, then dword [this+0x1f7b] = 0x1, then zero 0x1ecb bytes at [this+0x20] (rep stosd, stosw, stosb). */
uint8_t *m4904fa_construct_record(uint8_t *self, const Fl18Host *host);

/* 0x49192b, thiscall, plain `ret`, no return value: when the dword [self+0x50f3] (an address of the original) is zero nothing; otherwise the n = dword [self+0x50f7] bytes behind that address are zeroed (rep stosd n/4 dwords, rep stosb n & 3 bytes) and byte [self+0x50fb] = 0. */
void m49192b_clear_block(uint8_t *self, const Fl18Host *host);

/* 0x495608, thiscall, plain `ret`, no return value: the dword [self+0x201f] is the address of a record. When dword [self+0x4769] is non-zero the nine bytes at [record+0x28] are compared with the nine bytes at 0x54f888, otherwise with those at 0x54f894 (repe cmpsb). When they differ: r = 0x4f6334(this 0x5cf1eb, the signed word [record+0x49] as a dword) (thiscall, one argument); gate set: 0x4fb2e3(this 0x5c3a67, the word [record+0x49]) when r == 0; gate clear: 0x4fc878(this 0x5c3a67, the word) when r != 0 (the word is pushed from ax: the upper half is left-over, the callee reads a word). */
void m495608_check_object(const uint8_t *self, const Fl39fWorld *world, const Fl18Host *host);

/* 0x49c53a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, 0 arguments), then dword [this+0x0] = 0x52dbc8, then zero 0xdb0 bytes at [this+0x28] (rep stosd), then 0x49c5f0(this) (thiscall, 0 arguments). The function links a structured-exception frame (handler 0x52855d) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint8_t *m49c53a_construct_record(uint8_t *self, const Fl18Host *host);

/* 0x49cf80, thiscall, plain `ret`, no return value: 2 * dword [self+0xdf4] bytes behind the address in dword [self+0xde0] are zeroed (rep stosd, rep stosb); then for h = 0 .. (signed dword [self+0xddc]) - 1 and w = 0 .. (signed dword [self+0xdd8]) - 1 the word at that address + (h * dword [self+0xdd8] + w) * 2 gets its low byte or-ed with 0x0f (the high byte is kept). */
void m49cf80_fill_cells(uint8_t *self, const Fl18Host *host);

/* 0x4a0c7f, thiscall, plain `ret`, no return value: dword [self+0xe18] = 0, then for i = 0 .. 9 the zero-terminated string at [self+0x2c+i*0x15e] is measured (repne scasb) and the dword is incremented when its length is not 0. */
void m4a0c7f_count_nonempty(uint8_t *self);

/* 0x4ac8da, thiscall, plain `ret`, no return value (eax is left over): word [this+0x1e] = 0xffff, then word [this+0x1c] = 0xffff, then dword [this+0xc1b] = 0x0, then dword [this+0xc17] = 0x0, then byte [this+0xc1f] = 0x0, then byte [this+0xc24] = 0x0, then dword [this+0x20] = 0x0, then word [this+0x24] = 0xffff, then dword [this+0x46] = 0x0, then dword [this+0x6a] = 0x0, then dword [this+0xc35] = 0x0, then zero 0xba9 bytes at [this+0x6e] (rep stosd, stosb), then zero 0x30 bytes at [this+0xe59] (rep stosd). */
void m4ac8da_init_record(uint8_t *self);

/* 0x4beeb3, thiscall, stack argument a0, `ret 4`, returns an address inside the object or 0: 0x4bf38c(this) (thiscall, no argument); then a0 == 0: 0xe dwords at [this+0x84] are zeroed (rep stosd), dword [this+0x2c0] = 0xfffffffd and the result is 0; a0 != 0: the import at slot 0x52a534(a0, this + 0x84, 0) (stdcall, 3 arguments) and the result is this + 0x84 (THIS PORT RETURNS THE HOST POINTER; the differential shim maps it back to the original address). */
uint8_t *m4beeb3_bind_buffer(uint8_t *self, uint32_t a0, const Fl18Host *host);

/* 0x4c9cdd, thiscall (ecx is only saved), stack argument obj, `ret 4`, returns 0 for a null obj and otherwise 1: for i = 0 .. (signed dword [obj+0x1758]) - 1 the 16 bytes at [obj+0x30c+i*0x3e4] are compared with 16 zero bytes of a local (repe cmpsb); the first all-zero record ends the loop with dword [obj+0x175c] = i; no such record: dword [obj+0x175c] = 0. */
uint32_t m4c9cdd_find_zero_record(uint8_t *obj);

/* 0x4d52b9, thiscall, plain `ret`, no return value (eax is left over): zero 0x80 bytes at [this+0x4] (rep stosd), then zero 0x10 bytes at [this+0x84] (rep stosd), then zero 0x10 bytes at [this+0x94] (rep stosd), then zero 0x10 bytes at [this+0xa4] (rep stosd). */
void m4d52b9_init_record(uint8_t *self);

/* 0x4d6ad1, thiscall, plain `ret`, no return value: dword [self+0x461] = 0; now = GetTickCount (import 0x52a23c); dword [self+0x465] = now + the signed word [self+0x2cc]; dword [self+0x469] = strlen of the string at [self+0x96d3] (repne scasb); byte [self+0x46d] = 0; dwords [self+0x46e] and [self+0x472] = 0. */
void m4d6ad1_start_timer(uint8_t *self, const Fl18Host *host);

/* 0x4d8f0a, thiscall, plain `ret`, no return value: when the dword [self+0x9804] (the head of a linked list of original addresses) is non-zero, for each node p (next = dword [p+0x108], read before the call) 0x4d8f8d(this, p) (thiscall, one argument); then, when the dword [self+0x980c] is non-zero, 0x51dc6c(that dword) (cdecl, one argument); finally 0x29 dwords from [self+0x9804] are zeroed (rep stosd). */
void m4d8f0a_release_list(uint8_t *self, const Fl18Host *host);

/* 0x4dc13f, thiscall, stack arguments (src, count), `ret 8`, no return value: copies count bytes (count / 4 dwords with rep movsd, then count & 3 bytes with rep movsb; the count is unsigned and not checked) from src to [self+0x4e]; then, when the signed word 0x63a4cd is non-zero, 0x44a2b7(0x55b058) (cdecl, one argument). */
void m4dc13f_copy_counted(uint8_t *self, const uint8_t *src, uint32_t count, const Fl39fWorld *world, const Fl18Host *host);

/* 0x4de5f0, thiscall, plain `ret`, returns this: 0x4e1c50(this + 0x3ef) (thiscall, 0 arguments), then 0x4ee980(this + 0x57e) (thiscall, 0 arguments), then dword [this+0x0] = 0x52e4d0, then zero 0x389 bytes at [this+0x4] (rep stosd, stosb), then 0x4de6d7(this) (thiscall, 0 arguments). The function links a structured-exception frame (handler 0x52891e) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint8_t *m4de5f0_construct_record(uint8_t *self, const Fl18Host *host);

/* 0x4e0410, thiscall, plain `ret`, returns this: 0x50cb26(this + 0x757, 0x18f, 0x5, 0x4e1c50, 0x4e1c83) (stdcall: the callee pops them, 5 arguments), then dword [this+0x0] = 0x52e4e4, then zero 0x74b bytes at [this+0x4] (rep stosd, stosw, stosb), then 0x4e04f3(this) (thiscall, 0 arguments). The function links a structured-exception frame (handler 0x52896b) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint8_t *m4e0410_construct_record(uint8_t *self, const Fl18Host *host);

/* 0x4e069c, thiscall, stack arguments (src, unused), `ret 8`, no return value: copies 0x74b bytes (466 dwords with rep movsd, then movsw and movsb) from src to [self+0x4]. The second stack argument is not read; `self` (ecx) is saved in a local. */
void m4e069c_copy_in(uint8_t *self, const uint8_t *src);

/* 0x4e1c50, thiscall, plain `ret`, returns this: dword [this+0x0] = 0x52e4e8, then zero 0xef bytes at [this+0x38] (rep stosd, stosw, stosb), then 0x4e1c9f(this) (thiscall, 0 arguments). */
uint8_t *m4e1c50_construct_record(uint8_t *self, const Fl18Host *host);

/* 0x4e4428, thiscall, stack arguments (src, unused), `ret 8`, no return value: copies 0x10ed bytes (1083 dwords with rep movsd, then movsb) from src to [self+0x54df]. The second stack argument is not read; `self` (ecx) is saved in a local. */
void m4e4428_copy_in(uint8_t *self, const uint8_t *src);

/* 0x4e498d, thiscall, stack argument (name), `ret 4`, no return value: copies the 0x31 bytes at [self+0xa80] to [self+0x453c] (rep movsd, movsb); then copies strlen(name) + 1 bytes of the zero-terminated string `name` to [self+0x453c] (repne scasb for the length, rep movsd for len/4 dwords, rep movsb for len & 3). The length is not bounded by the field (0x31 bytes). */
void m4e498d_set_name(uint8_t *self, const uint8_t *name);

/* 0x4e7a70, thiscall, plain `ret`, returns this: 0x4eda10(this) (thiscall, 0 arguments), then 0x50cb26(this + 0x7654, 0x18f, 0x6, 0x4e1c50, 0x4e1c83) (stdcall: the callee pops them, 5 arguments), then dword [this+0x0] = 0x52e4f4, then dword [this+0x699] = 0x0, then dword [this+0x695] = 0x0, then dword [this+0x691] = 0x0, then zero 0xb2c bytes at [this+0x6b20] (rep stosd), then zero 0x647f bytes at [this+0x69d] (rep stosd, stosw, stosb), then 0x4e7ba7(this) (thiscall, 0 arguments). The function links a structured-exception frame (handler 0x528a54) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint8_t *m4e7a70_construct_record(uint8_t *self, const Fl18Host *host);

/* 0x4eb77d, thiscall, plain `ret`, no return value: the dword counter [self+0x822e] runs from 0 while it is < 70 (signed compare); for each value i: byte [0x583f1f + i*0x6e] = 0; strlen + 1 bytes of the zero-terminated string at [self+0x712] (repne scasb, rep movsd for len/4 dwords, rep movsb for len & 3) are copied to 0x583f20 + i*0x6e; 0x31 bytes (12 dwords with rep movsd, then movsb) at [self+0x6e1] are copied to 0x583f5c + i*0x6e. The string is not bounded by its 0x3c-byte field. */
void m4eb77d_fill_name_table(uint8_t *self, const Fl39fWorld *world);

/* 0x4eb870, thiscall, plain `ret`, returns this: 0x4eda10(this) (thiscall, 0 arguments), then 0x50cb26(this + 0xca8, 0x18f, 0x2, 0x4e1c50, 0x4e1c83) (stdcall: the callee pops them, 5 arguments), then dword [this+0x0] = 0x52e4f8, then zero 0x60b bytes at [this+0x695] (rep stosd, stosw, stosb), then 0x4eb9c8(this) (thiscall, 0 arguments). The function links a structured-exception frame (handler 0x528ab4) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint8_t *m4eb870_construct_record(uint8_t *self, const Fl18Host *host);

/* 0x4ec005, thiscall, stack arguments (src, limit), `ret 8`, no return value: copies 0x60b bytes (386 dwords with rep movsd, then movsw and movsb) from src to [self+0x695]; when 0x60b > limit (signed): 0x50ca3e(0x63888b, 0x55cc48, 0x60b, limit) (cdecl, four arguments), 0x4264e8(0x63888b) on 0x583979 (thiscall), 0x4c97b4 on 0x5cf659 (thiscall, no argument). */
void m4ec005_copy_checked(uint8_t *self, const uint8_t *src, int32_t limit, const Fl18Host *host);

/* 0x4fa8d2, cdecl-style stack arguments (a0, name, a2, cell), `ret 0x10`, returns 1 or 0 (ecx is not used): when a0 == 0 and the 21 bytes at `name` equal those at 0x56040c (repe cmpsb) and the signed word 0x63a4cd is non-zero: 0x50ca3e(0x63888b, 0x560424, name) (cdecl, 3 arguments) and 0x44a2b7(0x63888b) (cdecl), result 1; when a0 == 0 otherwise result 1; when a0 != 0: dword [cell] = a0, then with the debug word non-zero 0x50ca3e(0x63888b, 0x560478, name, a2) (cdecl, 4 arguments) and 0x44a2b7(0x63888b), result 0. */
uint32_t m4fa8d2_check_name(uint32_t a0, const uint8_t *name, uint32_t a2, uint8_t *cell, const Fl39fWorld *world, const Fl18Host *host);

/* 0x4fa980, thiscall, plain `ret`, returns this: dword [this+0x0] = 0x52e518, then word [this+0xb774] = 0x0, then dword [this+0xb776] = 0x0, then dword [this+0xb77a] = 0x0, then dword [this+0xb77e] = 0x0, then word [this+0xb782] = 0x0, then zero 0xb760 bytes at [this+0x4] (rep stosd). */
uint8_t *m4fa980_construct_record(uint8_t *self);

#ifdef __cplusplus
}
#endif

#endif
