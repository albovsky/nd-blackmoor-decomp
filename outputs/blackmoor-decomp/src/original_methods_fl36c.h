#ifndef BLACKMOOR_ORIGINAL_METHODS_FL36C_H
#define BLACKMOOR_ORIGINAL_METHODS_FL36C_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-36 (batch c): 130 small functions of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-35 (see original_methods_fl35b.h, whose conventions apply
 * unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment, `self` is the original
 * object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names are descriptive hints, not recovered
 * source names.
 *
 * ctor      65 rows: constructor stubs that store a dword at [this] and call one more method (return its eax).
 * ctorret   16 rows: constructor stubs that store a dword at [this], call one more method and return this.
 * setg      49 rows: methods that store one constant in the global dword 0x569138 and call 0x401526(this).
 * The constants of every row (the returned value, the field offset, the vtable dword, the callees, the stored constants) were read from that row's own disassembly by the
 * generator, which also asserted that every row of a kind has the identical masked instruction stream. A callee that changes `self` or a global that the function reads again
 * afterwards is not exercised (the functions read nothing again). The rows with a structured-exception frame link it into fs:[0] and unlink it before returning; the frame (and the
 * handler, which runs only when a callee throws) is not modelled. */

typedef struct Fl36cWorld {
    /* the globals that the rows store into (carried so that a store of the wrong width or at the wrong place shows) */
    uint32_t dword_569138;
} Fl36cWorld;

/* 0x401032, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52a5d0u at [this], then 0x521756(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401032_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4014f5, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52ab70u at [this], then 0x5218ea(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4014f5_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x40168f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x0u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m40168f_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x4016ac, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x1u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4016ac_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x4016c9, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x2u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4016c9_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x4016e6, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x3u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4016e6_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401703, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x4u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401703_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401720, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x5u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401720_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x40173d, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x6u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m40173d_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x40175a, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x7u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m40175a_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401777, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x8u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401777_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401794, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x9u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401794_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x4017b1, thiscall, plain `ret`, returns eax of its callee: stores the dword 0xau at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4017b1_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x4017ce, thiscall, plain `ret`, returns eax of its callee: stores the dword 0xbu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4017ce_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x4017eb, thiscall, plain `ret`, returns eax of its callee: stores the dword 0xcu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4017eb_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401808, thiscall, plain `ret`, returns eax of its callee: stores the dword 0xdu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401808_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401825, thiscall, plain `ret`, returns eax of its callee: stores the dword 0xeu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401825_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401842, thiscall, plain `ret`, returns eax of its callee: stores the dword 0xfu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401842_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x40185f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x10u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m40185f_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x40187c, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x11u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m40187c_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401899, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x12u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401899_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x4018b6, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x13u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4018b6_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x4018d3, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x14u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4018d3_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x4018f0, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x15u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4018f0_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x40190d, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x16u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m40190d_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x40192a, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x17u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m40192a_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401947, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x18u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401947_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401964, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x19u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401964_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401981, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x1au at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401981_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x40199e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x1bu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m40199e_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x4019bb, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x1cu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4019bb_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x4019d8, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x1du at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4019d8_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x4019f5, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x1eu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4019f5_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401a12, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x1fu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401a12_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401a2f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x20u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401a2f_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401a4c, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x21u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401a4c_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401a69, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x22u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401a69_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401a86, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x23u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401a86_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401aa3, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x24u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401aa3_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401ac0, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x25u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401ac0_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401add, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x26u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401add_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401afa, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x27u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401afa_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401b17, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x28u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401b17_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401b34, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x29u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401b34_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401b51, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x2au at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401b51_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401b6e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x2bu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401b6e_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401b8b, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x2cu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401b8b_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401ba8, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x2du at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401ba8_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401bc5, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x2eu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401bc5_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401be2, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x2fu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401be2_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x401bff, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x30u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
uint32_t m401bff_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host);

/* 0x404af0, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52ba38u at [this], then 0x5218ea(this) (thiscall, no arguments, plain `ret`). */
uint32_t m404af0_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x41458b, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52c4f0u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m41458b_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x414ccf, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52c540u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m414ccf_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x437710, thiscall, plain `ret`, returns this: stores the dword 0x52c7bcu at [this], calls 0x437743(this) (thiscall, no arguments, plain `ret`), returns this. */
uint8_t *m437710_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host);

/* 0x43eb59, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52c900u at [this], then 0x5228a4(this) (thiscall, no arguments, plain `ret`). */
uint32_t m43eb59_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x445df0, thiscall, plain `ret`, returns this: stores the dword 0x52ca1cu at [this], calls 0x445e2b(this) (thiscall, no arguments, plain `ret`), returns this. */
uint8_t *m445df0_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host);

/* 0x445e0f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52ca1cu at [this], then 0x445f40(this) (thiscall, no arguments, plain `ret`). */
uint32_t m445e0f_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x447d10, thiscall, plain `ret`, returns this: stores the dword 0x52cac8u at [this], calls 0x447d4b(this) (thiscall, no arguments, plain `ret`), returns this. */
uint8_t *m447d10_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host);

/* 0x447d2f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cac8u at [this], then 0x447d60(this) (thiscall, no arguments, plain `ret`). */
uint32_t m447d2f_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x447e46, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cb08u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m447e46_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x448820, thiscall, plain `ret`, returns this: stores the dword 0x52cb58u at [this], calls 0x448853(this) (thiscall, no arguments, plain `ret`), returns this. */
uint8_t *m448820_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host);

/* 0x449a78, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cb5cu at [this], then 0x449a94(this) (thiscall, no arguments, plain `ret`). */
uint32_t m449a78_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x44afd6, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cb98u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m44afd6_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x44d0eb, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cc38u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m44d0eb_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x44e74b, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52ccc0u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m44e74b_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x44f650, thiscall, plain `ret`, returns this: stores the dword 0x52cd10u at [this], calls 0x44f68b(this) (thiscall, no arguments, plain `ret`), returns this. */
uint8_t *m44f650_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host);

/* 0x44f66f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cd10u at [this], then 0x44f996(this) (thiscall, no arguments, plain `ret`). */
uint32_t m44f66f_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x454d6e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cd50u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m454d6e_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x456ceb, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cdd8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m456ceb_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x457f5e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52ce60u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m457f5e_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x459ace, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cee8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m459ace_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x45b3ce, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cf70u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m45b3ce_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x45dc6e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cff8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m45dc6e_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x46180b, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d080u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m46180b_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x463ffe, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d108u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m463ffe_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x465aeb, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d190u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m465aeb_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4674e0, thiscall, plain `ret`, returns this: stores the dword 0x52d1e0u at [this], calls 0x467513(this) (thiscall, no arguments, plain `ret`), returns this. */
uint8_t *m4674e0_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host);

/* 0x468e3e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d220u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m468e3e_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x46b56e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d2e8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m46b56e_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x470d5e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d3f8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m470d5e_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4757be, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d490u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4757be_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4781de, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d518u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4781de_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x47b21f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d568u at [this], then 0x47b321(this) (thiscall, no arguments, plain `ret`). */
uint32_t m47b21f_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x47d4db, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d5a8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m47d4db_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x47e23e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d630u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m47e23e_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x48215e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d6b8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m48215e_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x483f4e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d740u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m483f4e_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x487afe, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d7c8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m487afe_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x488d89, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d850u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m488d89_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x48a6ee, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d8d8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m48a6ee_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x48bafb, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d960u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m48bafb_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x48d04b, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d9e8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m48d04b_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x48e26e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52da70u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m48e26e_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4a1c2b, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52dc58u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4a1c2b_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4a376e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52dce0u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4a376e_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4a636e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52dd68u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4a636e_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4a7c5e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52ddf0u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4a7c5e_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4a9f0b, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52de78u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4a9f0b_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4ab38b, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52df00u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4ab38b_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4ac8be, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52df88u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4ac8be_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4afd1e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e010u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4afd1e_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4b3c3e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e098u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4b3c3e_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4b5b6e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e120u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4b5b6e_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4b71db, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e1a8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4b71db_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4b7f00, thiscall, plain `ret`, returns this: stores the dword 0x52e1f8u at [this], calls 0x4b7f3b(this) (thiscall, no arguments, plain `ret`), returns this. */
uint8_t *m4b7f00_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host);

/* 0x4b7f1f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e1f8u at [this], then 0x4b7ff4(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4b7f1f_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4b9e00, thiscall, plain `ret`, returns this: stores the dword 0x52e200u at [this], calls 0x4b9e3b(this) (thiscall, no arguments, plain `ret`), returns this. */
uint8_t *m4b9e00_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host);

/* 0x4b9e1f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e200u at [this], then 0x4ba07f(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4b9e1f_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4bed99, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e210u at [this], then 0x4bede7(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4bed99_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4bf600, thiscall, plain `ret`, returns this: stores the dword 0x52e214u at [this], calls 0x4bf63b(this) (thiscall, no arguments, plain `ret`), returns this. */
uint8_t *m4bf600_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host);

/* 0x4bf61f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e214u at [this], then 0x4bf8a7(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4bf61f_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4caed0, thiscall, plain `ret`, returns this: stores the dword 0x52e23cu at [this], calls 0x4caf03(this) (thiscall, no arguments, plain `ret`), returns this. */
uint8_t *m4caed0_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host);

/* 0x4cc946, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e278u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4cc946_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4ccd8f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e2d0u at [this], then 0x4cd218(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4ccd8f_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4d3b6e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e310u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4d3b6e_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4d5260, thiscall, plain `ret`, returns this: stores the dword 0x52e450u at [this], calls 0x4d529b(this) (thiscall, no arguments, plain `ret`), returns this. */
uint8_t *m4d5260_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host);

/* 0x4d527f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e450u at [this], then 0x4d52a6(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4d527f_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4d58b0, thiscall, plain `ret`, returns this: stores the dword 0x52e454u at [this], calls 0x4d58eb(this) (thiscall, no arguments, plain `ret`), returns this. */
uint8_t *m4d58b0_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host);

/* 0x4d58cf, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e454u at [this], then 0x4d5b54(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4d58cf_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4db260, thiscall, plain `ret`, returns this: stores the dword 0x52e458u at [this], calls 0x4db29b(this) (thiscall, no arguments, plain `ret`), returns this. */
uint8_t *m4db260_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host);

/* 0x4db27f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e458u at [this], then 0x4db377(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4db27f_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4dd3b0, thiscall, plain `ret`, returns this: stores the dword 0x52e4c8u at [this], calls 0x4dd3eb(this) (thiscall, no arguments, plain `ret`), returns this. */
uint8_t *m4dd3b0_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host);

/* 0x4dd3cf, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e4c8u at [this], then 0x4dd3f6(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4dd3cf_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4e1c83, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e4e8u at [this], then 0x4e1d34(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4e1c83_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4ee980, thiscall, plain `ret`, returns this: stores the dword 0x52e500u at [this], calls 0x4ee9bb(this) (thiscall, no arguments, plain `ret`), returns this. */
uint8_t *m4ee980_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host);

/* 0x4ee99f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e500u at [this], then 0x4eead0(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4ee99f_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4f0000, thiscall, plain `ret`, returns this: stores the dword 0x52e504u at [this], calls 0x4f003b(this) (thiscall, no arguments, plain `ret`), returns this. */
uint8_t *m4f0000_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host);

/* 0x4f001f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e504u at [this], then 0x4f0046(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4f001f_init_vtable_call(uint8_t *self, const Fl18Host *host);

/* 0x4fa9e7, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e518u at [this], then 0x4fad50(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4fa9e7_init_vtable_call(uint8_t *self, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
