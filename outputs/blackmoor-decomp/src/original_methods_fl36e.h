#ifndef BLACKMOOR_ORIGINAL_METHODS_FL36E_H
#define BLACKMOOR_ORIGINAL_METHODS_FL36E_H

#include <stddef.h>
#include <stdint.h>

#include "original_methods_fl18.h"

#ifdef __cplusplus
extern "C" {
#endif

/* FL-36 (batch e): 80 small functions of GAME.EXE (SHA-256 afd337a2...5c45) ported one to one, in the style of FL-35 (see original_methods_fl35b.h, whose conventions apply
 * unchanged, and the Fl18Host of original_methods_fl18.h): each is its own symbol `m<va>_<name>` that cites the original address in its leading comment, `self` is the original
 * object (ecx) as raw bytes at the original offsets, nothing is bounds checked, and the effects keep the order of the original. The names are descriptive hints, not recovered
 * source names.
 *
 * getf      14 rows: getters that return one dword field of the object.
 * retn       7 rows: methods that do nothing and pop their stack arguments.
 * setvt     10 rows: methods that store one constant dword at [this] and return this.
 * tail0      7 rows: methods that call one more method on this and return its eax.
 * fwd1       7 rows: methods that pass their one stack argument to one more method on this and return its eax.
 * dtorbase   6 rows: destructor stubs: call a base method, store one constant dword at [this], return this.
 * setfa      6 rows: setters that store their stack argument in one dword field and return this.
 * setfi      5 rows: setters that store one constant in one dword field and return this.
 * setw       5 rows: methods that store one constant word in one global.
 * setw2      5 rows: methods that store one constant word in each of two globals.
 * call2      4 rows: methods that call two methods on this and return a constant.
 * scall      4 rows: functions that call one method on a global object and return its eax.
 * The constants of every row (the returned value, the field offset, the vtable dword, the callees, the stored constants) were read from that row's own disassembly by the
 * generator, which also asserted that every row of a kind has the identical masked instruction stream. A callee that changes `self` or a global that the function reads again
 * afterwards is not exercised (the functions read nothing again). The rows with a structured-exception frame link it into fs:[0] and unlink it before returning; the frame (and the
 * handler, which runs only when a callee throws) is not modelled. */

typedef struct Fl36eWorld {
    /* the globals that the rows store into (carried so that a store of the wrong width or at the wrong place shows) */
    uint16_t word_594daf;
    uint16_t word_594db1;
    uint16_t word_5957b5;
    uint16_t word_5957b7;
    uint16_t word_5957b9;
    uint16_t word_5957bb;
    uint16_t word_5957bd;
    uint16_t word_5957c1;
    uint16_t word_5957c3;
    uint16_t word_5a0541;
    uint16_t word_5a0543;
    uint16_t word_5a110b;
    uint16_t word_5a110d;
    uint16_t word_5a14db;
    uint16_t word_5a14dd;
} Fl36eWorld;

/* 0x402945, thiscall, `ret 4`: does nothing; `this` is only saved in a local and 4 bytes of stack arguments are popped (eax is not set). */
void m402945_empty_method_args(uint8_t *self);

/* 0x40338e, thiscall, `ret 4`: does nothing; `this` is only saved in a local and 4 bytes of stack arguments are popped (eax is not set). */
void m40338e_empty_method_args(uint8_t *self);

/* 0x4033ab, thiscall, plain `ret`, returns the constant 0x1u: 0x521b22(this), then 0x4033db(this) (both thiscall, no arguments, plain `ret`). */
uint32_t m4033ab_call_two_return_const(uint8_t *self, const Fl18Host *host);

/* 0x404b0c, thiscall, `ret 4`: does nothing; `this` is only saved in a local and 4 bytes of stack arguments are popped (eax is not set). */
void m404b0c_empty_method_args(uint8_t *self);

/* 0x404b19, thiscall, plain `ret`, returns the constant 0x1u: 0x521b22(this), then 0x404be1(this) (both thiscall, no arguments, plain `ret`). */
uint32_t m404b19_call_two_return_const(uint8_t *self, const Fl18Host *host);

/* 0x407c8a, thiscall, `ret 4`: does nothing; `this` is only saved in a local and 4 bytes of stack arguments are popped (eax is not set). */
void m407c8a_empty_method_args(uint8_t *self);

/* 0x407d70, thiscall, plain `ret`, returns the constant 0x1u: 0x521b22(this), then 0x407ca7(this) (both thiscall, no arguments, plain `ret`). */
uint32_t m407d70_call_two_return_const(uint8_t *self, const Fl18Host *host);

/* 0x40905e, thiscall, `ret 4`: does nothing; `this` is only saved in a local and 4 bytes of stack arguments are popped (eax is not set). */
void m40905e_empty_method_args(uint8_t *self);

/* 0x40907b, thiscall, plain `ret`, returns the constant 0x1u: 0x521b22(this), then 0x4090ab(this) (both thiscall, no arguments, plain `ret`). */
uint32_t m40907b_call_two_return_const(uint8_t *self, const Fl18Host *host);

/* 0x414cb0, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments, plain `ret`), then stores the dword 0x52c540u at [this]. */
uint8_t *m414cb0_destruct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x423450, thiscall, plain `ret`, returns this: stores the dword 0x52c688u at [this]. */
uint8_t *m423450_init_vtable_ret_self(uint8_t *self);

/* 0x423467, thiscall, plain `ret`, returns this: stores the dword 0x52c688u at [this]. */
uint8_t *m423467_init_vtable_ret_self(uint8_t *self);

/* 0x4234b5, thiscall, plain `ret`, returns eax of its callee: 0x42347b(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4234b5_forward_call(uint8_t *self, const Fl18Host *host);

/* 0x426b5d, plain `ret`, returns eax of its callee: 0x426520 with ecx = the global object 0x570388 (thiscall, no arguments); `this` is not used. */
uint32_t m426b5d_call_global_object(const Fl18Host *host);

/* 0x426b7e, plain `ret`, returns eax of its callee: 0x427420 with ecx = the global object 0x570388 (thiscall, no arguments); `this` is not used. */
uint32_t m426b7e_call_global_object(const Fl18Host *host);

/* 0x43772f, thiscall, plain `ret`, returns this: stores the dword 0x52c7bcu at [this]. */
uint8_t *m43772f_init_vtable_ret_self(uint8_t *self);

/* 0x43eb3a, thiscall, plain `ret`, returns this: 0x5227c6(this) (thiscall, no arguments, plain `ret`), then stores the dword 0x52c900u at [this]. */
uint8_t *m43eb3a_destruct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x43ef10, thiscall, plain `ret`, returns this: stores the dword 0x52ca10u at [this]. */
uint8_t *m43ef10_init_vtable_ret_self(uint8_t *self);

/* 0x43ef27, thiscall, plain `ret`, returns this: stores the dword 0x52ca10u at [this]. */
uint8_t *m43ef27_init_vtable_ret_self(uint8_t *self);

/* 0x445f40, thiscall, plain `ret`, returns eax of its callee: 0x445e2b(this) (thiscall, no arguments, plain `ret`). */
uint32_t m445f40_forward_call(uint8_t *self, const Fl18Host *host);

/* 0x447d4b, thiscall, plain `ret`, returns this: stores the dword 0x0u at [this + 0x4]. */
uint8_t *m447d4b_set_field_const(uint8_t *self);

/* 0x447e27, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments, plain `ret`), then stores the dword 0x52cb08u at [this]. */
uint8_t *m447e27_destruct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x447e62, thiscall, `ret 4`, returns this: stores the stack argument (a dword) at [this + 0x1e]. */
uint8_t *m447e62_set_field_arg(uint8_t *self, uint32_t value);

/* 0x44883f, thiscall, plain `ret`, returns this: stores the dword 0x52cb58u at [this]. */
uint8_t *m44883f_init_vtable_ret_self(uint8_t *self);

/* 0x44885e, thiscall, plain `ret`, returns eax of its callee: 0x448853(this) (thiscall, no arguments, plain `ret`). */
uint32_t m44885e_forward_call(uint8_t *self, const Fl18Host *host);

/* 0x44afb7, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments, plain `ret`), then stores the dword 0x52cb98u at [this]. */
uint8_t *m44afb7_destruct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x44be90, thiscall, plain `ret`, returns this: stores the dword 0x52cbf0u at [this]. */
uint8_t *m44be90_init_vtable_ret_self(uint8_t *self);

/* 0x44bea7, thiscall, plain `ret`, returns this: stores the dword 0x52cbf0u at [this]. */
uint8_t *m44bea7_init_vtable_ret_self(uint8_t *self);

/* 0x454d8a, thiscall, plain `ret`: stores the word 0x0 at [0x5a0541]; `this` is only saved in a local (eax is not set). */
void m454d8a_set_word(Fl36eWorld *world);

/* 0x456dab, thiscall, plain `ret`: stores the word 0x0 at [0x5957c1] and the word 0x0 at [0x5957c3]; `this` is only saved in a local (eax is not set). */
void m456dab_set_two_words(Fl36eWorld *world);

/* 0x46401a, thiscall, plain `ret`: stores the word 0x0 at [0x5a0543]; `this` is only saved in a local (eax is not set). */
void m46401a_set_word(Fl36eWorld *world);

/* 0x4674ff, thiscall, plain `ret`, returns this: stores the dword 0x52d1e0u at [this]. */
uint8_t *m4674ff_init_vtable_ret_self(uint8_t *self);

/* 0x46b73e, thiscall, plain `ret`: stores the word 0x0 at [0x5a14db] and the word 0x270f at [0x5a14dd]; `this` is only saved in a local (eax is not set). */
void m46b73e_set_two_words(Fl36eWorld *world);

/* 0x470e71, thiscall, plain `ret`: stores the word 0x0 at [0x5957b5] and the word 0x0 at [0x5957b7]; `this` is only saved in a local (eax is not set). */
void m470e71_set_two_words(Fl36eWorld *world);

/* 0x4712b0, thiscall, `ret 8`: does nothing; `this` is only saved in a local and 8 bytes of stack arguments are popped (eax is not set). */
void m4712b0_empty_method_args(uint8_t *self);

/* 0x4782be, thiscall, plain `ret`: stores the word 0x0 at [0x5957bb] and the word 0x270f at [0x5957bd]; `this` is only saved in a local (eax is not set). */
void m4782be_set_two_words(Fl36eWorld *world);

/* 0x488d6a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments, plain `ret`), then stores the dword 0x52d850u at [this]. */
uint8_t *m488d6a_destruct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x48d119, thiscall, plain `ret`: stores the word 0x0 at [0x594daf]; `this` is only saved in a local (eax is not set). */
void m48d119_set_word(Fl36eWorld *world);

/* 0x493ad8, thiscall, plain `ret`, returns this: stores the dword 0x1u at [this + 0x200b]. */
uint8_t *m493ad8_set_field_const(uint8_t *self);

/* 0x4a7ddc, thiscall, plain `ret`: stores the word 0x0 at [0x5a110b] and the word 0x270f at [0x5a110d]; `this` is only saved in a local (eax is not set). */
void m4a7ddc_set_two_words(Fl36eWorld *world);

/* 0x4ab459, thiscall, plain `ret`: stores the word 0x0 at [0x5957b9]; `this` is only saved in a local (eax is not set). */
void m4ab459_set_word(Fl36eWorld *world);

/* 0x4b5c48, thiscall, plain `ret`: stores the word 0x0 at [0x594db1]; `this` is only saved in a local (eax is not set). */
void m4b5c48_set_word(Fl36eWorld *world);

/* 0x4bf3a4, thiscall, plain `ret`: returns the dword at [this + 0x2c0] in eax. */
uint32_t m4bf3a4_get_field(uint8_t *self);

/* 0x4c0c40, thiscall, plain `ret`: returns the dword at [this + 0x216] in eax. */
uint32_t m4c0c40_get_field(uint8_t *self);

/* 0x4caeef, thiscall, plain `ret`, returns this: stores the dword 0x52e23cu at [this]. */
uint8_t *m4caeef_init_vtable_ret_self(uint8_t *self);

/* 0x4cc927, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments, plain `ret`), then stores the dword 0x52e278u at [this]. */
uint8_t *m4cc927_destruct_base_set_vtable(uint8_t *self, const Fl18Host *host);

/* 0x4d3705, plain `ret`, returns eax of its callee: 0x4e79ca with ecx = the global object 0x582711 (thiscall, no arguments); `this` is not used. */
uint32_t m4d3705_call_global_object(const Fl18Host *host);

/* 0x4d3714, plain `ret`, returns eax of its callee: 0x4e1157 with ecx = the global object 0x570508 (thiscall, no arguments); `this` is not used. */
uint32_t m4d3714_call_global_object(const Fl18Host *host);

/* 0x4d3c1d, thiscall, plain `ret`: returns the dword at [this + 0x462] in eax. */
uint32_t m4d3c1d_get_field(uint8_t *self);

/* 0x4d51ea, thiscall, `ret 4`: does nothing; `this` is only saved in a local and 4 bytes of stack arguments are popped (eax is not set). */
void m4d51ea_empty_method_args(uint8_t *self);

/* 0x4d52a6, thiscall, plain `ret`, returns eax of its callee: 0x4d529b(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4d52a6_forward_call(uint8_t *self, const Fl18Host *host);

/* 0x4dae66, thiscall, plain `ret`: returns the dword at [this + 0x18] in eax. */
uint32_t m4dae66_get_field(uint8_t *self);

/* 0x4dae77, thiscall, plain `ret`: returns the dword at [this + 0x1c] in eax. */
uint32_t m4dae77_get_field(uint8_t *self);

/* 0x4daef1, thiscall, plain `ret`: returns the dword at [this + 0xc] in eax. */
uint32_t m4daef1_get_field(uint8_t *self);

/* 0x4daf02, thiscall, `ret 4`, returns this: stores the stack argument (a dword) at [this + 0xc]. */
uint8_t *m4daf02_set_field_arg(uint8_t *self, uint32_t value);

/* 0x4daf18, thiscall, plain `ret`: returns the dword at [this + 0x10] in eax. */
uint32_t m4daf18_get_field(uint8_t *self);

/* 0x4daf29, thiscall, `ret 4`, returns this: stores the stack argument (a dword) at [this + 0x10]. */
uint8_t *m4daf29_set_field_arg(uint8_t *self, uint32_t value);

/* 0x4db377, thiscall, plain `ret`, returns eax of its callee: 0x4db29b(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4db377_forward_call(uint8_t *self, const Fl18Host *host);

/* 0x4dd3f6, thiscall, plain `ret`, returns eax of its callee: 0x4dd3eb(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4dd3f6_forward_call(uint8_t *self, const Fl18Host *host);

/* 0x4e0742, thiscall, plain `ret`, returns this: stores the dword 0x1u at [this + 0xf2e]. */
uint8_t *m4e0742_set_field_const(uint8_t *self);

/* 0x4e2940, thiscall, `ret 4`, returns this: stores the stack argument (a dword) at [this + 0x30]. */
uint8_t *m4e2940_set_field_arg(uint8_t *self, uint32_t value);

/* 0x4e2956, thiscall, plain `ret`: returns the dword at [this + 0x30] in eax. */
uint32_t m4e2956_get_field(uint8_t *self);

/* 0x4e2967, thiscall, plain `ret`: returns the dword at [this + 0x7a] in eax. */
uint32_t m4e2967_get_field(uint8_t *self);

/* 0x4e2978, thiscall, plain `ret`, returns this: stores the dword 0x1u at [this + 0x177]. */
uint8_t *m4e2978_set_field_const(uint8_t *self);

/* 0x4e2990, thiscall, `ret 4`, returns this: stores the stack argument (a dword) at [this + 0x18]. */
uint8_t *m4e2990_set_field_arg(uint8_t *self, uint32_t value);

/* 0x4e29a6, thiscall, plain `ret`: returns the dword at [this + 0x18] in eax. */
uint32_t m4e29a6_get_field(uint8_t *self);

/* 0x4e40fb, thiscall, `ret 4`, returns eax of its callee: 0x4edfaf(this, the one stack argument) (thiscall, one argument, the callee pops it). */
uint32_t m4e40fb_forward_call_arg(uint8_t *self, uint32_t arg, const Fl18Host *host);

/* 0x4e4114, thiscall, `ret 4`, returns eax of its callee: 0x4ee0d4(this, the one stack argument) (thiscall, one argument, the callee pops it). */
uint32_t m4e4114_forward_call_arg(uint8_t *self, uint32_t arg, const Fl18Host *host);

/* 0x4e779f, thiscall, `ret 4`, returns eax of its callee: 0x4ee0d4(this, the one stack argument) (thiscall, one argument, the callee pops it). */
uint32_t m4e779f_forward_call_arg(uint8_t *self, uint32_t arg, const Fl18Host *host);

/* 0x4e89b9, thiscall, `ret 4`, returns eax of its callee: 0x4edfaf(this, the one stack argument) (thiscall, one argument, the callee pops it). */
uint32_t m4e89b9_forward_call_arg(uint8_t *self, uint32_t arg, const Fl18Host *host);

/* 0x4e89d2, thiscall, `ret 4`, returns eax of its callee: 0x4ee0d4(this, the one stack argument) (thiscall, one argument, the callee pops it). */
uint32_t m4e89d2_forward_call_arg(uint8_t *self, uint32_t arg, const Fl18Host *host);

/* 0x4e9e6c, thiscall, plain `ret`, returns this: stores the dword 0x0u at [this + 0x8256]. */
uint8_t *m4e9e6c_set_field_const(uint8_t *self);

/* 0x4ebd53, thiscall, `ret 4`, returns eax of its callee: 0x4edfaf(this, the one stack argument) (thiscall, one argument, the callee pops it). */
uint32_t m4ebd53_forward_call_arg(uint8_t *self, uint32_t arg, const Fl18Host *host);

/* 0x4ebd6c, thiscall, `ret 4`, returns eax of its callee: 0x4ee0d4(this, the one stack argument) (thiscall, one argument, the callee pops it). */
uint32_t m4ebd6c_forward_call_arg(uint8_t *self, uint32_t arg, const Fl18Host *host);

/* 0x4ee602, thiscall, plain `ret`: returns the dword at [this + 0x4af] in eax. */
uint32_t m4ee602_get_field(uint8_t *self);

/* 0x4ee630, thiscall, plain `ret`: returns the dword at [this + 0x4ab] in eax. */
uint32_t m4ee630_get_field(uint8_t *self);

/* 0x4ef4c9, thiscall, `ret 4`, returns this: stores the stack argument (a dword) at [this + 0x10]. */
uint8_t *m4ef4c9_set_field_arg(uint8_t *self, uint32_t value);

/* 0x4ef4df, thiscall, plain `ret`: returns the dword at [this + 0x10] in eax. */
uint32_t m4ef4df_get_field(uint8_t *self);

/* 0x4ef516, thiscall, plain `ret`: returns the dword at [this + 0x162] in eax. */
uint32_t m4ef516_get_field(uint8_t *self);

/* 0x4f0046, thiscall, plain `ret`, returns eax of its callee: 0x4f003b(this) (thiscall, no arguments, plain `ret`). */
uint32_t m4f0046_forward_call(uint8_t *self, const Fl18Host *host);

#ifdef __cplusplus
}
#endif

#endif
