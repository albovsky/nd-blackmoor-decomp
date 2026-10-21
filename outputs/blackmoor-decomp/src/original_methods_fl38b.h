#ifndef BLACKMOOR_ORIGINAL_METHODS_FL38B_H
#define BLACKMOOR_ORIGINAL_METHODS_FL38B_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-38 (batch b): 18 GAME.EXE functions of one shape ("clone a record"), each ported one to one in the style of FL-35/FL-36 (see original_methods_fl36f.h and the Fl18Host of
 * original_methods_fl18.h): every row is its own symbol `m<va>_clone_record` that cites the original address in the comment above it. The size S, the two message strings and the
 * debug message are read from each row's own disassembly (the generator asserted that every row of a sub-shape has the identical masked instruction stream and that S agrees in the
 * allocation, the repeat count and tail, and the two pointer advances).
 *
 * The original is a stdcall method (`ret 0xc`, ecx = this is stored in a local and never used) with three stack arguments, each the address of a dword cell:
 *   out = [esp+4]: *out receives the new block p = 0x51dc43(S) (cdecl, one argument);
 *   in2 = [esp+8]: *in2 is the source pointer; S bytes are copied from *in2 to *out (rep movsd, then movsw and/or movsb for the S mod 4 tail), forward, dword by dword;
 *   adv = [esp+12]: *adv += S, then *in2 += S (the cells may alias; each is read again before it is stored).
 * When p is 0 the original formats a message (0x50ca3e(0x63888b, fmt, dword [0x5bb57b], (int16)[0x5c39e3])), reports it with 0x42639d (thiscall on 0x583979, two arguments:
 * the second string, then 0x63888b) and calls 0x4c97b4 on 0x5cf659, which does not return (a fatal error): the original would otherwise copy into address 0. The port stops there and
 * returns 1 (the model of a callee that ends the program); it returns 0 otherwise. At the end, when the debug word [0x63a4cd] is non-zero, 0x44a2b7(debug message) is called.
 * The three arguments are original addresses of cells (`host->resolve`); the dwords stored in the cells are original addresses too. Nothing is bounds checked. */

typedef struct Fl38bWorld {
    uint32_t dword_5bb57b;
    int16_t word_5c39e3, word_63a4cd;
} Fl38bWorld;

/* 0x44d1d1, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x2fb) is stored at *out; when p is 0 the failure report (fmt 0x549538, message 0x549564) ends in 0x4c97b4 and the port returns 1; otherwise 0x2fb bytes (movsw+movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x2fb; the debug message 0x549580 is sent when [0x63a4cd] is non-zero. Returns 0. */
int m44d1d1_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host);

/* 0x456fb6, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x27b) is stored at *out; when p is 0 the failure report (fmt 0x54a330, message 0x54a35c) ends in 0x4c97b4 and the port returns 1; otherwise 0x27b bytes (movsw+movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x27b; the debug message 0x54a378 is sent when [0x63a4cd] is non-zero. Returns 0. */
int m456fb6_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host);

/* 0x45807c, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x663) is stored at *out; when p is 0 the failure report (fmt 0x54a578, message 0x54a5a4) ends in 0x4c97b4 and the port returns 1; otherwise 0x663 bytes (movsw+movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x663; the debug message 0x54a5c0 is sent when [0x63a4cd] is non-zero. Returns 0. */
int m45807c_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host);

/* 0x464100, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x43f) is stored at *out; when p is 0 the failure report (fmt 0x54b2c0, message 0x54b2ec) ends in 0x4c97b4 and the port returns 1; otherwise 0x43f bytes (movsw+movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x43f; the debug message 0x54b308 is sent when [0x63a4cd] is non-zero. Returns 0. */
int m464100_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host);

/* 0x465bde, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x55f) is stored at *out; when p is 0 the failure report (fmt 0x54b4d0, message 0x54b4fc) ends in 0x4c97b4 and the port returns 1; otherwise 0x55f bytes (movsw+movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x55f; the debug message 0x54b518 is sent when [0x63a4cd] is non-zero. Returns 0. */
int m465bde_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host);

/* 0x46b79a, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x6e3) is stored at *out; when p is 0 the failure report (fmt 0x54bc84, message 0x54bcb0) ends in 0x4c97b4 and the port returns 1; otherwise 0x6e3 bytes (movsw+movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x6e3; the debug message 0x54bccc is sent when [0x63a4cd] is non-zero. Returns 0. */
int m46b79a_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host);

/* 0x47314b, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x4ff) is stored at *out; when p is 0 the failure report (fmt 0x54c5a0, message 0x54c5cc) ends in 0x4c97b4 and the port returns 1; otherwise 0x4ff bytes (movsw+movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x4ff; the debug message 0x54c5e8 is sent when [0x63a4cd] is non-zero. Returns 0. */
int m47314b_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host);

/* 0x4782db, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x29b) is stored at *out; when p is 0 the failure report (fmt 0x54cb10, message 0x54cb3c) ends in 0x4c97b4 and the port returns 1; otherwise 0x29b bytes (movsw+movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x29b; the debug message 0x54cb58 is sent when [0x63a4cd] is non-zero. Returns 0. */
int m4782db_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host);

/* 0x475964, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x7f2) is stored at *out; when p is 0 the failure report (fmt 0x54c7cc, message 0x54c7f8) ends in 0x4c97b4 and the port returns 1; otherwise 0x7f2 bytes (movsw) are copied from *in2 to *out and *adv, then *in2, advance by 0x7f2; the debug message 0x54c814 is sent when [0x63a4cd] is non-zero. Returns 0. */
int m475964_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host);

/* 0x44fbe3, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x4e8) is stored at *out; when p is 0 the failure report (fmt 0x54991c, message 0x549948) ends in 0x4c97b4 and the port returns 1; otherwise 0x4e8 bytes (none) are copied from *in2 to *out and *adv, then *in2, advance by 0x4e8; the debug message 0x549964 is sent when [0x63a4cd] is non-zero. Returns 0. */
int m44fbe3_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host);

/* 0x467688, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x408) is stored at *out; when p is 0 the failure report (fmt 0x54b7d8, message 0x54b804) ends in 0x4c97b4 and the port returns 1; otherwise 0x408 bytes (none) are copied from *in2 to *out and *adv, then *in2, advance by 0x408; the debug message 0x54b820 is sent when [0x63a4cd] is non-zero. Returns 0. */
int m467688_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host);

/* 0x468f9f, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x5d8) is stored at *out; when p is 0 the failure report (fmt 0x54b974, message 0x54b9a0) ends in 0x4c97b4 and the port returns 1; otherwise 0x5d8 bytes (none) are copied from *in2 to *out and *adv, then *in2, advance by 0x5d8; the debug message 0x54b9bc is sent when [0x63a4cd] is non-zero. Returns 0. */
int m468f9f_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host);

/* 0x47e477, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0xa34) is stored at *out; when p is 0 the failure report (fmt 0x54d474, message 0x54d4a0) ends in 0x4c97b4 and the port returns 1; otherwise 0xa34 bytes (none) are copied from *in2 to *out and *adv, then *in2, advance by 0xa34; the debug message 0x54d4bc is sent when [0x63a4cd] is non-zero. Returns 0. */
int m47e477_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host);

/* 0x44e8a2, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x269) is stored at *out; when p is 0 the failure report (fmt 0x5497a8, message 0x5497d4) ends in 0x4c97b4 and the port returns 1; otherwise 0x269 bytes (movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x269; the debug message 0x5497f0 is sent when [0x63a4cd] is non-zero. Returns 0. */
int m44e8a2_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host);

/* 0x454e70, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0xd01) is stored at *out; when p is 0 the failure report (fmt 0x549fbc, message 0x549fe8) ends in 0x4c97b4 and the port returns 1; otherwise 0xd01 bytes (movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0xd01; the debug message 0x54a004 is sent when [0x63a4cd] is non-zero. Returns 0. */
int m454e70_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host);

/* 0x459c10, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x2b1) is stored at *out; when p is 0 the failure report (fmt 0x54a74c, message 0x54a778) ends in 0x4c97b4 and the port returns 1; otherwise 0x2b1 bytes (movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x2b1; the debug message 0x54a794 is sent when [0x63a4cd] is non-zero. Returns 0. */
int m459c10_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host);

/* 0x45ddd0, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x1346) is stored at *out; when p is 0 the failure report (fmt 0x54aeb8, message 0x54aee4) ends in 0x4c97b4 and the port returns 1; otherwise 0x1346 bytes (movsw) are copied from *in2 to *out and *adv, then *in2, advance by 0x1346; the debug message 0x54af00 is sent when [0x63a4cd] is non-zero. Returns 0. */
int m45ddd0_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host);

/* 0x47b3f0, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x16c2) is stored at *out; when p is 0 the failure report (fmt 0x54cdd4, message 0x54ce00) ends in 0x4c97b4 and the port returns 1; otherwise 0x16c2 bytes (movsw) are copied from *in2 to *out and *adv, then *in2, advance by 0x16c2; the debug message 0x54ce1c is sent when [0x63a4cd] is non-zero. Returns 0. */
int m47b3f0_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
