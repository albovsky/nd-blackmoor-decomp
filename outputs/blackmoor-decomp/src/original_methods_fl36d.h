#ifndef BLACKMOOR_ORIGINAL_METHODS_FL36D_H
#define BLACKMOOR_ORIGINAL_METHODS_FL36D_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-36 (batch d): 97 small functions of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-35 (see original_methods_fl35b.h, whose conventions apply
 * unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment, `self` is the original
 * object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names are descriptive hints, not recovered
 * source names.
 *
 * dtor      97 rows: scalar-deleting destructors (call a destructor, delete this when bit 0 of the argument is set, return this).
 * The constants of every row (the returned value, the field offset, the vtable dword, the callees, the stored constants) were read from that row's own disassembly by the
 * generator, which also asserted that every row of a kind has the identical masked instruction stream. A callee that changes `self` or a global that the function reads again
 * afterwards is not exercised (the functions read nothing again). The rows with a structured-exception frame link it into fs:[0] and unlink it before returning; the frame (and the
 * handler, which runs only when a callee throws) is not modelled. */

/* 0x401100, thiscall, `ret 4`, returns this: 0x401032(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m401100_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x401190, thiscall, `ret 4`, returns this: 0x521756(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m401190_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x401c40, thiscall, `ret 4`, returns this: 0x4014f5(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m401c40_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x403010, thiscall, `ret 4`, returns this: 0x401c70(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m403010_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x404a20, thiscall, `ret 4`, returns this: 0x403229(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m404a20_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x407b10, thiscall, `ret 4`, returns this: 0x404af0(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m407b10_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x408980, thiscall, `ret 4`, returns this: 0x407c29(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m408980_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x40b2a0, thiscall, `ret 4`, returns this: 0x408d49(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m40b2a0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x414490, thiscall, `ret 4`, returns this: 0x4110d7(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m414490_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x414c80, thiscall, `ret 4`, returns this: 0x41458b(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m414c80_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x416e60, thiscall, `ret 4`, returns this: 0x414ccf(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m416e60_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x41a480, thiscall, `ret 4`, returns this: 0x416f2d(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m41a480_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x422fb0, thiscall, `ret 4`, returns this: 0x41bebc(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m422fb0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x425f70, thiscall, `ret 4`, returns this: 0x423467(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m425f70_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4273f0, thiscall, `ret 4`, returns this: 0x427420(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4273f0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x434880, thiscall, `ret 4`, returns this: 0x433e63(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m434880_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x438120, thiscall, `ret 4`, returns this: 0x43772f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m438120_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x43eed0, thiscall, `ret 4`, returns this: 0x43eb59(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m43eed0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x43f1e0, thiscall, `ret 4`, returns this: 0x43ef27(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m43f1e0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x446ed0, thiscall, `ret 4`, returns this: 0x445e0f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m446ed0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x447ce0, thiscall, `ret 4`, returns this: 0x446faa(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m447ce0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x447d80, thiscall, `ret 4`, returns this: 0x447d2f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m447d80_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4487f0, thiscall, `ret 4`, returns this: 0x447e46(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4487f0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x449770, thiscall, `ret 4`, returns this: 0x44883f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m449770_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x449d60, thiscall, `ret 4`, returns this: 0x449a78(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m449d60_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x44be60, thiscall, `ret 4`, returns this: 0x44afd6(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m44be60_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x44c2b0, thiscall, `ret 4`, returns this: 0x44bea7(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m44c2b0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x44e650, thiscall, `ret 4`, returns this: 0x44d0eb(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m44e650_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x44f620, thiscall, `ret 4`, returns this: 0x44e74b(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m44f620_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x454c70, thiscall, `ret 4`, returns this: 0x44f66f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m454c70_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x456bf0, thiscall, `ret 4`, returns this: 0x454d6e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m456bf0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x457e60, thiscall, `ret 4`, returns this: 0x456ceb(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m457e60_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4599d0, thiscall, `ret 4`, returns this: 0x457f5e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4599d0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x45b2d0, thiscall, `ret 4`, returns this: 0x459ace(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m45b2d0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x45db70, thiscall, `ret 4`, returns this: 0x45b3ce(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m45db70_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x461710, thiscall, `ret 4`, returns this: 0x45dc6e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m461710_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x463f00, thiscall, `ret 4`, returns this: 0x46180b(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m463f00_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4659f0, thiscall, `ret 4`, returns this: 0x463ffe(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4659f0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4674b0, thiscall, `ret 4`, returns this: 0x465aeb(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4674b0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x468d40, thiscall, `ret 4`, returns this: 0x4674ff(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m468d40_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x46b470, thiscall, `ret 4`, returns this: 0x468e3e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m46b470_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x46e550, thiscall, `ret 4`, returns this: 0x46b56e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m46e550_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x470c60, thiscall, `ret 4`, returns this: 0x46e66a(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m470c60_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x472ed0, thiscall, `ret 4`, returns this: 0x470d5e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m472ed0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4756c0, thiscall, `ret 4`, returns this: 0x472f95(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4756c0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4780e0, thiscall, `ret 4`, returns this: 0x4757be(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4780e0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x47b1d0, thiscall, `ret 4`, returns this: 0x4781de(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m47b1d0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x47d3e0, thiscall, `ret 4`, returns this: 0x47b21f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m47d3e0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x47e140, thiscall, `ret 4`, returns this: 0x47d4db(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m47e140_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x482060, thiscall, `ret 4`, returns this: 0x47e23e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m482060_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x483e50, thiscall, `ret 4`, returns this: 0x48215e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m483e50_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x487a00, thiscall, `ret 4`, returns this: 0x483f4e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m487a00_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x488cc0, thiscall, `ret 4`, returns this: 0x487afe(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m488cc0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x48a5f0, thiscall, `ret 4`, returns this: 0x488d89(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m48a5f0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x48ba00, thiscall, `ret 4`, returns this: 0x48a6ee(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m48ba00_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x48cf50, thiscall, `ret 4`, returns this: 0x48bafb(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m48cf50_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x48e170, thiscall, `ret 4`, returns this: 0x48d04b(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m48e170_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x490450, thiscall, `ret 4`, returns this: 0x48e26e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m490450_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x49c490, thiscall, `ret 4`, returns this: 0x490547(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m49c490_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4a1b30, thiscall, `ret 4`, returns this: 0x49c59f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4a1b30_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4a3670, thiscall, `ret 4`, returns this: 0x4a1c2b(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4a3670_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4a6270, thiscall, `ret 4`, returns this: 0x4a376e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4a6270_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4a7b60, thiscall, `ret 4`, returns this: 0x4a636e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4a7b60_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4a9e10, thiscall, `ret 4`, returns this: 0x4a7c5e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4a9e10_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4ab290, thiscall, `ret 4`, returns this: 0x4a9f0b(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4ab290_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4ac7c0, thiscall, `ret 4`, returns this: 0x4ab38b(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4ac7c0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4afc20, thiscall, `ret 4`, returns this: 0x4ac8be(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4afc20_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4b3b40, thiscall, `ret 4`, returns this: 0x4afd1e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4b3b40_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4b5a70, thiscall, `ret 4`, returns this: 0x4b3c3e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4b5a70_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4b70e0, thiscall, `ret 4`, returns this: 0x4b5b6e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4b70e0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4b7ed0, thiscall, `ret 4`, returns this: 0x4b71db(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4b7ed0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4b9dd0, thiscall, `ret 4`, returns this: 0x4b7f1f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4b9dd0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4bed40, thiscall, `ret 4`, returns this: 0x4b9e1f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4bed40_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4bf5d0, thiscall, `ret 4`, returns this: 0x4bed99(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4bf5d0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4c0f30, thiscall, `ret 4`, returns this: 0x4bf61f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4c0f30_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4cae90, thiscall, `ret 4`, returns this: 0x4c139a(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4cae90_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4cc880, thiscall, `ret 4`, returns this: 0x4caeef(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4cc880_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4ccd40, thiscall, `ret 4`, returns this: 0x4cc946(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4ccd40_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4cf7b0, thiscall, `ret 4`, returns this: 0x4ccd8f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4cf7b0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4d42b0, thiscall, `ret 4`, returns this: 0x4d3b6e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4d42b0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4d5230, thiscall, `ret 4`, returns this: 0x44af20(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4d5230_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4d5880, thiscall, `ret 4`, returns this: 0x4d527f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4d5880_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4d9d40, thiscall, `ret 4`, returns this: 0x4d58cf(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4d9d40_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4dbca0, thiscall, `ret 4`, returns this: 0x4db27f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4dbca0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4dd380, thiscall, `ret 4`, returns this: 0x4dbf6e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4dd380_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4de120, thiscall, `ret 4`, returns this: 0x4dd3cf(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4de120_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4de5c0, thiscall, `ret 4`, returns this: 0x4de1a4(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4de5c0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4e03e0, thiscall, `ret 4`, returns this: 0x4de66e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4e03e0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4e1c20, thiscall, `ret 4`, returns this: 0x4e048f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4e1c20_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4e2cb0, thiscall, `ret 4`, returns this: 0x4e1c83(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4e2cb0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4e7600, thiscall, `ret 4`, returns this: 0x4e2d63(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4e7600_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4e7a40, thiscall, `ret 4`, returns this: 0x4e7684(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4e7a40_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4eb840, thiscall, `ret 4`, returns this: 0x4e7b37(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4eb840_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4ed9e0, thiscall, `ret 4`, returns this: 0x4eb8fe(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4ed9e0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4ee950, thiscall, `ret 4`, returns this: 0x4eda7c(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4ee950_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4effd0, thiscall, `ret 4`, returns this: 0x4ee99f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4effd0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

/* 0x4f2610, thiscall, `ret 4`, returns this: 0x4f001f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
uint8_t *m4f2610_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
