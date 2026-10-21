#ifndef BLACKMOOR_ORIGINAL_METHODS_FL36F_H
#define BLACKMOOR_ORIGINAL_METHODS_FL36F_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-36 (batch f): 95 small functions of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-35 (see original_methods_fl35b.h, whose conventions apply
 * unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment, `self` is the original
 * object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names are descriptive hints, not recovered
 * source names.
 *
 * newctor   54 rows: factories (allocate with 0x51dc43, construct with one method, 0 when the allocation fails) with a structured-exception frame.
 * ctoreh    41 rows: constructors (call a base constructor, store the vtable dword, call one more method) with a structured-exception frame.
 * The constants of every row (the returned value, the field offset, the vtable dword, the callees, the stored constants) were read from that row's own disassembly by the
 * generator, which also asserted that every row of a kind has the identical masked instruction stream. A callee that changes `self` or a global that the function reads again
 * afterwards is not exercised (the functions read nothing again). The rows with a structured-exception frame link it into fs:[0] and unlink it before returning; the frame (and the
 * handler, which runs only when a callee throws) is not modelled. */

/* 0x401420, plain `ret`, returns the new object or 0: p = 0x51dc43(0x8c) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x40149a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x526aca) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m401420_new_and_construct(const Fl18Host *host);

/* 0x403040, plain `ret`, returns the new object or 0: p = 0x51dc43(0x4b4) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4030ba(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x526b2a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m403040_new_and_construct(const Fl18Host *host);

/* 0x404a50, plain `ret`, returns the new object or 0: p = 0x51dc43(0xde0) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x404aca(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x526d2a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m404a50_new_and_construct(const Fl18Host *host);

/* 0x407b40, plain `ret`, returns the new object or 0: p = 0x51dc43(0x98c) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x407bba(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x526d4a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m407b40_new_and_construct(const Fl18Host *host);

/* 0x4089b0, plain `ret`, returns the new object or 0: p = 0x51dc43(0xa8c) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x408a2a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x526d8a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m4089b0_new_and_construct(const Fl18Host *host);

/* 0x4144c0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x28) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x414537(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52728a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m4144c0_new_and_construct(const Fl18Host *host);

/* 0x414537, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52c4f0u at [this], then 0x4145a7(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52729d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m414537_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x41bda0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x20ef) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x41be1a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5272fa) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m41bda0_new_and_construct(const Fl18Host *host);

/* 0x43eab0, plain `ret`, returns the new object or 0: p = 0x51dc43(0xbc) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x43eb3a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x527eaa) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m43eab0_new_and_construct(const Fl18Host *host);

/* 0x446f00, plain `ret`, returns the new object or 0: p = 0x51dc43(0x5e) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x446f77(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x527eca) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m446f00_new_and_construct(const Fl18Host *host);

/* 0x447db0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x22) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x447e27(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x527efa) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m447db0_new_and_construct(const Fl18Host *host);

/* 0x44af40, plain `ret`, returns the new object or 0: p = 0x51dc43(0x1e) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x44afb7(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x527f7a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m44af40_new_and_construct(const Fl18Host *host);

/* 0x44d020, plain `ret`, returns the new object or 0: p = 0x51dc43(0x53) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x44d097(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x527f9a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m44d020_new_and_construct(const Fl18Host *host);

/* 0x44d097, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52cc38u at [this], then 0x44d107(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x527fad) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m44d097_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x44e680, plain `ret`, returns the new object or 0: p = 0x51dc43(0x6f) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x44e6f7(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x527fca) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m44e680_new_and_construct(const Fl18Host *host);

/* 0x44e6f7, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52ccc0u at [this], then 0x44e767(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x527fdd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m44e6f7_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x454ca0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x174) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x454d1a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x527ffa) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m454ca0_new_and_construct(const Fl18Host *host);

/* 0x454d1a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52cd50u at [this], then 0x454d9e(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52800d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m454d1a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x456c20, plain `ret`, returns the new object or 0: p = 0x51dc43(0x44) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x456c97(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52802a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m456c20_new_and_construct(const Fl18Host *host);

/* 0x456c97, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52cdd8u at [this], then 0x456d07(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52803d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m456c97_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x457e90, plain `ret`, returns the new object or 0: p = 0x51dc43(0xf3) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x457f0a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52805a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m457e90_new_and_construct(const Fl18Host *host);

/* 0x457f0a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52ce60u at [this], then 0x457f7a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52806d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m457f0a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x459a00, plain `ret`, returns the new object or 0: p = 0x51dc43(0xe2) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x459a7a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52808a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m459a00_new_and_construct(const Fl18Host *host);

/* 0x459a7a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52cee8u at [this], then 0x459aea(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52809d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m459a7a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x45b300, plain `ret`, returns the new object or 0: p = 0x51dc43(0x1b9) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x45b37a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5280ba) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m45b300_new_and_construct(const Fl18Host *host);

/* 0x45b37a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52cf70u at [this], then 0x45b3ea(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5280cd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m45b37a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x45dba0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x3af) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x45dc1a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5280ea) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m45dba0_new_and_construct(const Fl18Host *host);

/* 0x45dc1a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52cff8u at [this], then 0x45dc8a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5280fd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m45dc1a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x461740, plain `ret`, returns the new object or 0: p = 0x51dc43(0x5f) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4617b7(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52811a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m461740_new_and_construct(const Fl18Host *host);

/* 0x4617b7, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d080u at [this], then 0x461827(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52812d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m4617b7_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x463f30, plain `ret`, returns the new object or 0: p = 0x51dc43(0xda) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x463faa(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52814a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m463f30_new_and_construct(const Fl18Host *host);

/* 0x463faa, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d108u at [this], then 0x46402e(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52815d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m463faa_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x465a20, plain `ret`, returns the new object or 0: p = 0x51dc43(0x56) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x465a97(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52817a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m465a20_new_and_construct(const Fl18Host *host);

/* 0x465a97, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d190u at [this], then 0x465b07(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52818d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m465a97_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x468d70, plain `ret`, returns the new object or 0: p = 0x51dc43(0x5b4) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x468dea(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5281aa) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m468d70_new_and_construct(const Fl18Host *host);

/* 0x468dea, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d220u at [this], then 0x468e5a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5281bd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m468dea_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x46b4a0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x8302) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x46b51a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5281da) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m46b4a0_new_and_construct(const Fl18Host *host);

/* 0x46b51a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d2e8u at [this], then 0x46b58a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5281ed) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m46b51a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x46e580, plain `ret`, returns the new object or 0: p = 0x51dc43(0x95) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x46e5fa(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52820a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m46e580_new_and_construct(const Fl18Host *host);

/* 0x470c90, plain `ret`, returns the new object or 0: p = 0x51dc43(0xe0a) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x470d0a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52827a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m470c90_new_and_construct(const Fl18Host *host);

/* 0x470d0a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d3f8u at [this], then 0x470d7a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52828d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m470d0a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x4756f0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x8da) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x47576a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5282ca) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m4756f0_new_and_construct(const Fl18Host *host);

/* 0x47576a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d490u at [this], then 0x4757da(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5282dd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m47576a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x478110, plain `ret`, returns the new object or 0: p = 0x51dc43(0x15a0) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x47818a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5282fa) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m478110_new_and_construct(const Fl18Host *host);

/* 0x47818a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d518u at [this], then 0x4781fa(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52830d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m47818a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x47d410, plain `ret`, returns the new object or 0: p = 0x51dc43(0x58) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x47d487(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52832a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m47d410_new_and_construct(const Fl18Host *host);

/* 0x47d487, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d5a8u at [this], then 0x47d4f7(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52833d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m47d487_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x47e170, plain `ret`, returns the new object or 0: p = 0x51dc43(0x144d) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x47e1ea(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52837a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m47e170_new_and_construct(const Fl18Host *host);

/* 0x47e1ea, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d630u at [this], then 0x47e25a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52838d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m47e1ea_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x482090, plain `ret`, returns the new object or 0: p = 0x51dc43(0xb7) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x48210a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5283aa) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m482090_new_and_construct(const Fl18Host *host);

/* 0x48210a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d6b8u at [this], then 0x48217a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5283bd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m48210a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x483e80, plain `ret`, returns the new object or 0: p = 0x51dc43(0xc3b) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x483efa(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5283da) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m483e80_new_and_construct(const Fl18Host *host);

/* 0x483efa, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d740u at [this], then 0x483f6a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5283ed) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m483efa_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x487a30, plain `ret`, returns the new object or 0: p = 0x51dc43(0x9b) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x487aaa(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52840a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m487a30_new_and_construct(const Fl18Host *host);

/* 0x487aaa, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d7c8u at [this], then 0x487b1a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52841d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m487aaa_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x488cf0, plain `ret`, returns the new object or 0: p = 0x51dc43(0xd0) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x488d6a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52843a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m488cf0_new_and_construct(const Fl18Host *host);

/* 0x48a620, plain `ret`, returns the new object or 0: p = 0x51dc43(0x1ce) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x48a69a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52845a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m48a620_new_and_construct(const Fl18Host *host);

/* 0x48a69a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d8d8u at [this], then 0x48a70a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52846d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m48a69a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x48ba30, plain `ret`, returns the new object or 0: p = 0x51dc43(0x56) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x48baa7(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52848a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m48ba30_new_and_construct(const Fl18Host *host);

/* 0x48baa7, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d960u at [this], then 0x48bb17(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52849d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m48baa7_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x48cf80, plain `ret`, returns the new object or 0: p = 0x51dc43(0x5c) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x48cff7(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5284ba) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m48cf80_new_and_construct(const Fl18Host *host);

/* 0x48cff7, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d9e8u at [this], then 0x48d067(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5284cd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m48cff7_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x48e1a0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x4e4) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x48e21a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5284ea) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m48e1a0_new_and_construct(const Fl18Host *host);

/* 0x48e21a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52da70u at [this], then 0x48e28a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5284fd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m48e21a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x490480, plain `ret`, returns the new object or 0: p = 0x51dc43(0x50fe) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4904fa(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52851a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m490480_new_and_construct(const Fl18Host *host);

/* 0x49c4c0, plain `ret`, returns the new object or 0: p = 0x51dc43(0xe4c) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x49c53a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52854a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m49c4c0_new_and_construct(const Fl18Host *host);

/* 0x4a1b60, plain `ret`, returns the new object or 0: p = 0x51dc43(0x68) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4a1bd7(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52858a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m4a1b60_new_and_construct(const Fl18Host *host);

/* 0x4a1bd7, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52dc58u at [this], then 0x4a1c47(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52859d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m4a1bd7_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x4a36a0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x840) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4a371a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5285ba) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m4a36a0_new_and_construct(const Fl18Host *host);

/* 0x4a371a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52dce0u at [this], then 0x4a378a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5285cd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m4a371a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x4a62a0, plain `ret`, returns the new object or 0: p = 0x51dc43(0xa8) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4a631a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5285ea) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m4a62a0_new_and_construct(const Fl18Host *host);

/* 0x4a631a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52dd68u at [this], then 0x4a638a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5285fd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m4a631a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x4a7b90, plain `ret`, returns the new object or 0: p = 0x51dc43(0x13fd) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4a7c0a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52861a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m4a7b90_new_and_construct(const Fl18Host *host);

/* 0x4a7c0a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52ddf0u at [this], then 0x4a7c7a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52862d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m4a7c0a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x4a9e40, plain `ret`, returns the new object or 0: p = 0x51dc43(0x4a) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4a9eb7(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52864a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m4a9e40_new_and_construct(const Fl18Host *host);

/* 0x4a9eb7, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52de78u at [this], then 0x4a9f27(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52865d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m4a9eb7_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x4ab2c0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x62) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4ab337(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52867a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m4ab2c0_new_and_construct(const Fl18Host *host);

/* 0x4ab337, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52df00u at [this], then 0x4ab3a7(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52868d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m4ab337_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x4ac7f0, plain `ret`, returns the new object or 0: p = 0x51dc43(0xe89) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4ac86a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5286aa) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m4ac7f0_new_and_construct(const Fl18Host *host);

/* 0x4ac86a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52df88u at [this], then 0x4ac8da(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5286bd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m4ac86a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x4afc50, plain `ret`, returns the new object or 0: p = 0x51dc43(0x1541) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4afcca(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5286da) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m4afc50_new_and_construct(const Fl18Host *host);

/* 0x4afcca, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52e010u at [this], then 0x4afd3a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5286ed) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m4afcca_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x4b3b70, plain `ret`, returns the new object or 0: p = 0x51dc43(0x782) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4b3bea(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52870a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m4b3b70_new_and_construct(const Fl18Host *host);

/* 0x4b3bea, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52e098u at [this], then 0x4b3c5a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52871d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m4b3bea_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x4b5aa0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x278) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4b5b1a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52873a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m4b5aa0_new_and_construct(const Fl18Host *host);

/* 0x4b5b1a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52e120u at [this], then 0x4b5b8a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52874d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m4b5b1a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x4b7110, plain `ret`, returns the new object or 0: p = 0x51dc43(0x3c) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4b7187(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52876a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m4b7110_new_and_construct(const Fl18Host *host);

/* 0x4b7187, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52e1a8u at [this], then 0x4b71f7(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52877d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m4b7187_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x4cc8b0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x1c) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4cc927(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52881a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m4cc8b0_new_and_construct(const Fl18Host *host);

/* 0x4d3aa0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x466) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4d3b1a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52885a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m4d3aa0_new_and_construct(const Fl18Host *host);

/* 0x4d3b1a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52e310u at [this], then 0x4d3b95(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52886d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m4d3b1a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x4dbea0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x10a) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4dbf1a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52888a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint32_t m4dbea0_new_and_construct(const Fl18Host *host);

/* 0x4dbf1a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52e478u at [this], then 0x4dbfbf(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52889d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m4dbf1a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x4de150, thiscall, plain `ret`, returns this: 0x4eda10(this) (thiscall, no arguments), stores the dword 0x52e4ccu at [this], then 0x4de1f5(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5288d9) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m4de150_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x4e7630, thiscall, plain `ret`, returns this: 0x4eda10(this) (thiscall, no arguments), stores the dword 0x52e4f0u at [this], then 0x4e76d5(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x528a09) into fs:[0] and unlinks it before the return; the frame is not modelled. */
uint8_t *m4e7630_construct_base_set_vtable(uint8_t *self, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
