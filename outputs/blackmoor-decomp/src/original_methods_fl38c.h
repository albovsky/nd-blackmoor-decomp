#ifndef BLACKMOOR_ORIGINAL_METHODS_FL38C_H
#define BLACKMOOR_ORIGINAL_METHODS_FL38C_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-38 (batch c): 24 GAME.EXE functions of five small shapes, each ported one to one in the style of FL-35/FL-36/FL-38b (the Fl18Host of original_methods_fl18.h): every row is its own
 * symbol `m<va>_<name>` that cites the original address in the comment above it; the constants of a row (the offsets, the globals, the callee, the table base, the format string) are
 * read from that row's own disassembly (the generator asserted that the whole instruction stream of every row equals its shape with exactly those constants).
 *   read_word_setting (7 rows, 59 bytes) and read_time_setting (6 rows, 164 bytes): a 0x13-byte string is read into a local by 0x51d5b2, converted by 0x50cb1b, stored, and a method of self is called.
 *   shift_rect (6 rows, 83 bytes): a rectangle copied with its x fields shifted by one global and its y fields by another.
 *   new_zeroed (2 rows, 139 bytes): allocate `size` bytes, store the block, zero it (or report the failure).
 *   clamp_to_bounds (3 rows, 207, 207 and 255 bytes): move a rectangle inside four global bounds, keeping its extents.
 * `self` is the host memory of the object (the original ecx); a pointer that the port passes to a callee is a host pointer (a local of the port, or into `self`). The cells and blocks of
 * new_zeroed are original addresses resolved with `host->resolve`. Nothing is bounds checked (the original does none). The direction flag is assumed clear. */

typedef struct Fl38cWorld {
    uint16_t word_5e5684, word_5e5686, word_5ec284, word_5ec286, word_5ec288, word_5ec2d4, word_5ec33a;           /* the word targets of read_word_setting, named by their address */
    uint32_t dword_5c3a63;                        /* read_time_setting: index of the entry of the table at 0x5e569e (stride 0x106; a signed 32-bit offset is applied to the table pointer) */
    uint8_t *table_5e569e;                        /* read_time_setting: the byte at the original address 0x5e569e */
    int32_t dword_58318a, dword_583186;           /* shift_rect: the y shift (fields +4, +0xc) and the x shift (fields +0, +8) */
    int16_t word_63a4cd;                          /* new_zeroed: the debug word, any non-zero value is on */
    int32_t dword_58319a, dword_5831a2, dword_583196, dword_58319e;   /* clamp_to_bounds: x minimum, x maximum, y minimum, y maximum (signed) */
} Fl38cWorld;


/* 0x40430e, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x18c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and its low word is stored at [0x5e5686], then 0x4033db (thiscall on self, no arguments) is called; returns its eax. */
uint32_t m40430e_read_word_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host);

/* 0x404349, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x14c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and its low word is stored at [0x5e5684], then 0x4033db (thiscall on self, no arguments) is called; returns its eax. */
uint32_t m404349_read_word_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host);

/* 0x40492f, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x38c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and its low word is stored at [0x5ec33a], then 0x4033db (thiscall on self, no arguments) is called; returns its eax. */
uint32_t m40492f_read_word_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host);

/* 0x40496a, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x3cc, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and its low word is stored at [0x5ec284], then 0x4033db (thiscall on self, no arguments) is called; returns its eax. */
uint32_t m40496a_read_word_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host);

/* 0x4049a5, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x44c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and its low word is stored at [0x5ec288], then 0x4033db (thiscall on self, no arguments) is called; returns its eax. */
uint32_t m4049a5_read_word_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host);

/* 0x4049e0, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x40c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and its low word is stored at [0x5ec286], then 0x4033db (thiscall on self, no arguments) is called; returns its eax. */
uint32_t m4049e0_read_word_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host);

/* 0x40893f, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x94c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and its low word is stored at [0x5ec2d4], then 0x407ca7 (thiscall on self, no arguments) is called; returns its eax. */
uint32_t m40893f_read_word_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host);

/* 0x4043b6, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x24c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and the dword result is stored in the field at 0x5e56aa of entry [0x5c3a63] (stride 0x106, table 0x5e569e); then the field at 0x5e569e = (field at 0x5e56aa) * 3600000 + (field at 0x5e56a6) * 60000 + (field at 0x5e56a2) * 1000 (32-bit wrap, every field re-read from memory), and 0x4033db (thiscall on self) is called; returns its eax. */
uint32_t m4043b6_read_time_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host);

/* 0x40445a, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x20c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and the dword result is stored in the field at 0x5e56a6 of entry [0x5c3a63] (stride 0x106, table 0x5e569e); then the field at 0x5e569e = (field at 0x5e56aa) * 3600000 + (field at 0x5e56a6) * 60000 + (field at 0x5e56a2) * 1000 (32-bit wrap, every field re-read from memory), and 0x4033db (thiscall on self) is called; returns its eax. */
uint32_t m40445a_read_time_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host);

/* 0x4044fe, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x28c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and the dword result is stored in the field at 0x5e56a2 of entry [0x5c3a63] (stride 0x106, table 0x5e569e); then the field at 0x5e569e = (field at 0x5e56aa) * 3600000 + (field at 0x5e56a6) * 60000 + (field at 0x5e56a2) * 1000 (32-bit wrap, every field re-read from memory), and 0x4033db (thiscall on self) is called; returns its eax. */
uint32_t m4044fe_read_time_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host);

/* 0x4045a2, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x30c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and the dword result is stored in the field at 0x5e56be of entry [0x5c3a63] (stride 0x106, table 0x5e569e); then the field at 0x5e56b2 = (field at 0x5e56be) * 3600000 + (field at 0x5e56ba) * 60000 + (field at 0x5e56b6) * 1000 (32-bit wrap, every field re-read from memory), and 0x4033db (thiscall on self) is called; returns its eax. */
uint32_t m4045a2_read_time_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host);

/* 0x404646, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x2cc, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and the dword result is stored in the field at 0x5e56ba of entry [0x5c3a63] (stride 0x106, table 0x5e569e); then the field at 0x5e56b2 = (field at 0x5e56be) * 3600000 + (field at 0x5e56ba) * 60000 + (field at 0x5e56b6) * 1000 (32-bit wrap, every field re-read from memory), and 0x4033db (thiscall on self) is called; returns its eax. */
uint32_t m404646_read_time_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host);

/* 0x4046ea, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x34c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and the dword result is stored in the field at 0x5e56b6 of entry [0x5c3a63] (stride 0x106, table 0x5e569e); then the field at 0x5e56b2 = (field at 0x5e56be) * 3600000 + (field at 0x5e56ba) * 60000 + (field at 0x5e56b6) * 1000 (32-bit wrap, every field re-read from memory), and 0x4033db (thiscall on self) is called; returns its eax. */
uint32_t m4046ea_read_time_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host);

/* 0x454f29, thiscall with two stack arguments (`ret 8`; ecx is stored and unused): dst[+4] = src[+4] + [0x58318a], dst[+0xc] = src[+0xc] + [0x58318a], dst[+0] = src[+0] + [0x583186], dst[+8] = src[+8] + [0x583186], in this order, 32-bit wrap; src and dst may overlap. */
void m454f29_shift_rect(const uint8_t *src, uint8_t *dst, const Fl38cWorld *world);

/* 0x457071, thiscall with two stack arguments (`ret 8`; ecx is stored and unused): dst[+4] = src[+4] + [0x58318a], dst[+0xc] = src[+0xc] + [0x58318a], dst[+0] = src[+0] + [0x583186], dst[+8] = src[+8] + [0x583186], in this order, 32-bit wrap; src and dst may overlap. */
void m457071_shift_rect(const uint8_t *src, uint8_t *dst, const Fl38cWorld *world);

/* 0x458137, thiscall with two stack arguments (`ret 8`; ecx is stored and unused): dst[+4] = src[+4] + [0x58318a], dst[+0xc] = src[+0xc] + [0x58318a], dst[+0] = src[+0] + [0x583186], dst[+8] = src[+8] + [0x583186], in this order, 32-bit wrap; src and dst may overlap. */
void m458137_shift_rect(const uint8_t *src, uint8_t *dst, const Fl38cWorld *world);

/* 0x46453b, thiscall with two stack arguments (`ret 8`; ecx is stored and unused): dst[+4] = src[+4] + [0x58318a], dst[+0xc] = src[+0xc] + [0x58318a], dst[+0] = src[+0] + [0x583186], dst[+8] = src[+8] + [0x583186], in this order, 32-bit wrap; src and dst may overlap. */
void m46453b_shift_rect(const uint8_t *src, uint8_t *dst, const Fl38cWorld *world);

/* 0x466db1, thiscall with two stack arguments (`ret 8`; ecx is stored and unused): dst[+4] = src[+4] + [0x58318a], dst[+0xc] = src[+0xc] + [0x58318a], dst[+0] = src[+0] + [0x583186], dst[+8] = src[+8] + [0x583186], in this order, 32-bit wrap; src and dst may overlap. */
void m466db1_shift_rect(const uint8_t *src, uint8_t *dst, const Fl38cWorld *world);

/* 0x479d98, thiscall with two stack arguments (`ret 8`; ecx is stored and unused): dst[+4] = src[+4] + [0x58318a], dst[+0xc] = src[+0xc] + [0x58318a], dst[+0] = src[+0] + [0x583186], dst[+8] = src[+8] + [0x583186], in this order, 32-bit wrap; src and dst may overlap. */
void m479d98_shift_rect(const uint8_t *src, uint8_t *dst, const Fl38cWorld *world);

/* 0x4465fd, two stack arguments (`ret 8`; ecx is stored and unused): p = 0x51dc43(size) is stored at *out; when p is 0 it formats 0x54824c with 0x50ca3e(0x63888b, fmt), reports with 0x4264e8 (thiscall on 0x583979, argument 0x63888b), sends 0x44a2b7(0x63888b) when the word [0x63a4cd] is non-zero and calls 0x4c97b4 (thiscall on 0x5cf659; it ends in PostQuitMessage and returns) without clearing anything; otherwise the `size` bytes at p are set to 0. */
void m4465fd_new_zeroed(uint32_t out, uint32_t size, const Fl38cWorld *world, const Fl18Host *host);

/* 0x4547bc, two stack arguments (`ret 8`; ecx is stored and unused): p = 0x51dc43(size) is stored at *out; when p is 0 it formats 0x549e28 with 0x50ca3e(0x63888b, fmt), reports with 0x4264e8 (thiscall on 0x583979, argument 0x63888b), sends 0x44a2b7(0x63888b) when the word [0x63a4cd] is non-zero and calls 0x4c97b4 (thiscall on 0x5cf659; it ends in PostQuitMessage and returns) without clearing anything; otherwise the `size` bytes at p are set to 0. */
void m4547bc_new_zeroed(uint32_t out, uint32_t size, const Fl38cWorld *world, const Fl18Host *host);

/* 0x454f7c, thiscall, plain `ret`: clamps the rectangle fields self[0x4e]/self[0x56] (x) and self[0x4a]/self[0x52] (y) into the bounds [[0x58319a], [0x5831a2]] and [[0x583196], [0x58319e]] (signed 32-bit compares), keeping the extents (int16 at +0x16c and +0x16a); no callee. */
void m454f7c_clamp_to_bounds(uint8_t *self, Fl38cWorld *world);

/* 0x46458e, thiscall, plain `ret`: clamps the rectangle fields self[0x4e]/self[0x56] (x) and self[0x4a]/self[0x52] (y) into the bounds [[0x58319a], [0x5831a2]] and [[0x583196], [0x58319e]] (signed 32-bit compares), keeping the extents (int16 at +0xd4 and +0xd2); no callee. */
void m46458e_clamp_to_bounds(uint8_t *self, Fl38cWorld *world);

/* 0x46b855, thiscall, plain `ret`: clamps the rectangle fields self[0x49f8]/self[0x4a00] (x) and self[0x49f4]/self[0x49fc] (y) into the bounds [[0x58319a], [0x5831a2]] and [[0x583196], [0x58319e]] (signed 32-bit compares), keeping the extents (int16 at +0x816c and +0x816a); no callee. */
void m46b855_clamp_to_bounds(uint8_t *self, Fl38cWorld *world);

#ifdef __cplusplus
}
#endif

#endif
