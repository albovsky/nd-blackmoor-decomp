#include "original_methods_fl36e.h"

#include <string.h>

#if defined(__GNUC__)
#define FL36_UNUSED __attribute__((unused))
#else
#define FL36_UNUSED
#endif

FL36_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL36_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL36_UNUSED static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

FL36_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

FL36_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

/* ---- 0x402945 empty_method_args ---- */
/* 0x402945, thiscall, `ret 4`: does nothing; `this` is only saved in a local and 4 bytes of stack arguments are popped (eax is not set). */
/* 0x402945 m402945_empty_method_args */
void m402945_empty_method_args(uint8_t *self)
{
    (void)self;
}

/* ---- 0x40338e empty_method_args ---- */
/* 0x40338e, thiscall, `ret 4`: does nothing; `this` is only saved in a local and 4 bytes of stack arguments are popped (eax is not set). */
/* 0x40338e m40338e_empty_method_args */
void m40338e_empty_method_args(uint8_t *self)
{
    (void)self;
}

/* ---- 0x4033ab call_two_return_const ---- */
/* 0x4033ab, thiscall, plain `ret`, returns the constant 0x1u: 0x521b22(this), then 0x4033db(this) (both thiscall, no arguments, plain `ret`). */
/* 0x4033ab m4033ab_call_two_return_const */
uint32_t m4033ab_call_two_return_const(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x521b22, (uintptr_t)self);
    (void)call0(host, 0x4033db, (uintptr_t)self);
    return 0x1u;
}

/* ---- 0x404b0c empty_method_args ---- */
/* 0x404b0c, thiscall, `ret 4`: does nothing; `this` is only saved in a local and 4 bytes of stack arguments are popped (eax is not set). */
/* 0x404b0c m404b0c_empty_method_args */
void m404b0c_empty_method_args(uint8_t *self)
{
    (void)self;
}

/* ---- 0x404b19 call_two_return_const ---- */
/* 0x404b19, thiscall, plain `ret`, returns the constant 0x1u: 0x521b22(this), then 0x404be1(this) (both thiscall, no arguments, plain `ret`). */
/* 0x404b19 m404b19_call_two_return_const */
uint32_t m404b19_call_two_return_const(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x521b22, (uintptr_t)self);
    (void)call0(host, 0x404be1, (uintptr_t)self);
    return 0x1u;
}

/* ---- 0x407c8a empty_method_args ---- */
/* 0x407c8a, thiscall, `ret 4`: does nothing; `this` is only saved in a local and 4 bytes of stack arguments are popped (eax is not set). */
/* 0x407c8a m407c8a_empty_method_args */
void m407c8a_empty_method_args(uint8_t *self)
{
    (void)self;
}

/* ---- 0x407d70 call_two_return_const ---- */
/* 0x407d70, thiscall, plain `ret`, returns the constant 0x1u: 0x521b22(this), then 0x407ca7(this) (both thiscall, no arguments, plain `ret`). */
/* 0x407d70 m407d70_call_two_return_const */
uint32_t m407d70_call_two_return_const(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x521b22, (uintptr_t)self);
    (void)call0(host, 0x407ca7, (uintptr_t)self);
    return 0x1u;
}

/* ---- 0x40905e empty_method_args ---- */
/* 0x40905e, thiscall, `ret 4`: does nothing; `this` is only saved in a local and 4 bytes of stack arguments are popped (eax is not set). */
/* 0x40905e m40905e_empty_method_args */
void m40905e_empty_method_args(uint8_t *self)
{
    (void)self;
}

/* ---- 0x40907b call_two_return_const ---- */
/* 0x40907b, thiscall, plain `ret`, returns the constant 0x1u: 0x521b22(this), then 0x4090ab(this) (both thiscall, no arguments, plain `ret`). */
/* 0x40907b m40907b_call_two_return_const */
uint32_t m40907b_call_two_return_const(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x521b22, (uintptr_t)self);
    (void)call0(host, 0x4090ab, (uintptr_t)self);
    return 0x1u;
}

/* ---- 0x414cb0 destruct_base_set_vtable ---- */
/* 0x414cb0, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments, plain `ret`), then stores the dword 0x52c540u at [this]. */
/* 0x414cb0 m414cb0_destruct_base_set_vtable */
uint8_t *m414cb0_destruct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52c540u);
    return self;
}

/* ---- 0x423450 init_vtable_ret_self ---- */
/* 0x423450, thiscall, plain `ret`, returns this: stores the dword 0x52c688u at [this]. */
/* 0x423450 m423450_init_vtable_ret_self */
uint8_t *m423450_init_vtable_ret_self(uint8_t *self)
{
    wr32(self, 0, 0x52c688u);
    return self;
}

/* ---- 0x423467 init_vtable_ret_self ---- */
/* 0x423467, thiscall, plain `ret`, returns this: stores the dword 0x52c688u at [this]. */
/* 0x423467 m423467_init_vtable_ret_self */
uint8_t *m423467_init_vtable_ret_self(uint8_t *self)
{
    wr32(self, 0, 0x52c688u);
    return self;
}

/* ---- 0x4234b5 forward_call ---- */
/* 0x4234b5, thiscall, plain `ret`, returns eax of its callee: 0x42347b(this) (thiscall, no arguments, plain `ret`). */
/* 0x4234b5 m4234b5_forward_call */
uint32_t m4234b5_forward_call(uint8_t *self, const Fl18Host *host)
{
    return call0(host, 0x42347b, (uintptr_t)self);
}

/* ---- 0x426b5d call_global_object ---- */
/* 0x426b5d, plain `ret`, returns eax of its callee: 0x426520 with ecx = the global object 0x570388 (thiscall, no arguments); `this` is not used. */
/* 0x426b5d m426b5d_call_global_object */
uint32_t m426b5d_call_global_object(const Fl18Host *host)
{
    return call0(host, 0x426520, 0x570388);
}

/* ---- 0x426b7e call_global_object ---- */
/* 0x426b7e, plain `ret`, returns eax of its callee: 0x427420 with ecx = the global object 0x570388 (thiscall, no arguments); `this` is not used. */
/* 0x426b7e m426b7e_call_global_object */
uint32_t m426b7e_call_global_object(const Fl18Host *host)
{
    return call0(host, 0x427420, 0x570388);
}

/* ---- 0x43772f init_vtable_ret_self ---- */
/* 0x43772f, thiscall, plain `ret`, returns this: stores the dword 0x52c7bcu at [this]. */
/* 0x43772f m43772f_init_vtable_ret_self */
uint8_t *m43772f_init_vtable_ret_self(uint8_t *self)
{
    wr32(self, 0, 0x52c7bcu);
    return self;
}

/* ---- 0x43eb3a destruct_base_set_vtable ---- */
/* 0x43eb3a, thiscall, plain `ret`, returns this: 0x5227c6(this) (thiscall, no arguments, plain `ret`), then stores the dword 0x52c900u at [this]. */
/* 0x43eb3a m43eb3a_destruct_base_set_vtable */
uint8_t *m43eb3a_destruct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x5227c6, (uintptr_t)self);
    wr32(self, 0, 0x52c900u);
    return self;
}

/* ---- 0x43ef10 init_vtable_ret_self ---- */
/* 0x43ef10, thiscall, plain `ret`, returns this: stores the dword 0x52ca10u at [this]. */
/* 0x43ef10 m43ef10_init_vtable_ret_self */
uint8_t *m43ef10_init_vtable_ret_self(uint8_t *self)
{
    wr32(self, 0, 0x52ca10u);
    return self;
}

/* ---- 0x43ef27 init_vtable_ret_self ---- */
/* 0x43ef27, thiscall, plain `ret`, returns this: stores the dword 0x52ca10u at [this]. */
/* 0x43ef27 m43ef27_init_vtable_ret_self */
uint8_t *m43ef27_init_vtable_ret_self(uint8_t *self)
{
    wr32(self, 0, 0x52ca10u);
    return self;
}

/* ---- 0x445f40 forward_call ---- */
/* 0x445f40, thiscall, plain `ret`, returns eax of its callee: 0x445e2b(this) (thiscall, no arguments, plain `ret`). */
/* 0x445f40 m445f40_forward_call */
uint32_t m445f40_forward_call(uint8_t *self, const Fl18Host *host)
{
    return call0(host, 0x445e2b, (uintptr_t)self);
}

/* ---- 0x447d4b set_field_const ---- */
/* 0x447d4b, thiscall, plain `ret`, returns this: stores the dword 0x0u at [this + 0x4]. */
/* 0x447d4b m447d4b_set_field_const */
uint8_t *m447d4b_set_field_const(uint8_t *self)
{
    wr32(self, 0x4, 0x0u);
    return self;
}

/* ---- 0x447e27 destruct_base_set_vtable ---- */
/* 0x447e27, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments, plain `ret`), then stores the dword 0x52cb08u at [this]. */
/* 0x447e27 m447e27_destruct_base_set_vtable */
uint8_t *m447e27_destruct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52cb08u);
    return self;
}

/* ---- 0x447e62 set_field_arg ---- */
/* 0x447e62, thiscall, `ret 4`, returns this: stores the stack argument (a dword) at [this + 0x1e]. */
/* 0x447e62 m447e62_set_field_arg */
uint8_t *m447e62_set_field_arg(uint8_t *self, uint32_t value)
{
    wr32(self, 0x1e, value);
    return self;
}

/* ---- 0x44883f init_vtable_ret_self ---- */
/* 0x44883f, thiscall, plain `ret`, returns this: stores the dword 0x52cb58u at [this]. */
/* 0x44883f m44883f_init_vtable_ret_self */
uint8_t *m44883f_init_vtable_ret_self(uint8_t *self)
{
    wr32(self, 0, 0x52cb58u);
    return self;
}

/* ---- 0x44885e forward_call ---- */
/* 0x44885e, thiscall, plain `ret`, returns eax of its callee: 0x448853(this) (thiscall, no arguments, plain `ret`). */
/* 0x44885e m44885e_forward_call */
uint32_t m44885e_forward_call(uint8_t *self, const Fl18Host *host)
{
    return call0(host, 0x448853, (uintptr_t)self);
}

/* ---- 0x44afb7 destruct_base_set_vtable ---- */
/* 0x44afb7, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments, plain `ret`), then stores the dword 0x52cb98u at [this]. */
/* 0x44afb7 m44afb7_destruct_base_set_vtable */
uint8_t *m44afb7_destruct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52cb98u);
    return self;
}

/* ---- 0x44be90 init_vtable_ret_self ---- */
/* 0x44be90, thiscall, plain `ret`, returns this: stores the dword 0x52cbf0u at [this]. */
/* 0x44be90 m44be90_init_vtable_ret_self */
uint8_t *m44be90_init_vtable_ret_self(uint8_t *self)
{
    wr32(self, 0, 0x52cbf0u);
    return self;
}

/* ---- 0x44bea7 init_vtable_ret_self ---- */
/* 0x44bea7, thiscall, plain `ret`, returns this: stores the dword 0x52cbf0u at [this]. */
/* 0x44bea7 m44bea7_init_vtable_ret_self */
uint8_t *m44bea7_init_vtable_ret_self(uint8_t *self)
{
    wr32(self, 0, 0x52cbf0u);
    return self;
}

/* ---- 0x454d8a set_word ---- */
/* 0x454d8a, thiscall, plain `ret`: stores the word 0x0 at [0x5a0541]; `this` is only saved in a local (eax is not set). */
/* 0x454d8a m454d8a_set_word */
void m454d8a_set_word(Fl36eWorld *world)
{
    world->word_5a0541 = 0x0;
}

/* ---- 0x456dab set_two_words ---- */
/* 0x456dab, thiscall, plain `ret`: stores the word 0x0 at [0x5957c1] and the word 0x0 at [0x5957c3]; `this` is only saved in a local (eax is not set). */
/* 0x456dab m456dab_set_two_words */
void m456dab_set_two_words(Fl36eWorld *world)
{
    world->word_5957c1 = 0x0;
    world->word_5957c3 = 0x0;
}

/* ---- 0x46401a set_word ---- */
/* 0x46401a, thiscall, plain `ret`: stores the word 0x0 at [0x5a0543]; `this` is only saved in a local (eax is not set). */
/* 0x46401a m46401a_set_word */
void m46401a_set_word(Fl36eWorld *world)
{
    world->word_5a0543 = 0x0;
}

/* ---- 0x4674ff init_vtable_ret_self ---- */
/* 0x4674ff, thiscall, plain `ret`, returns this: stores the dword 0x52d1e0u at [this]. */
/* 0x4674ff m4674ff_init_vtable_ret_self */
uint8_t *m4674ff_init_vtable_ret_self(uint8_t *self)
{
    wr32(self, 0, 0x52d1e0u);
    return self;
}

/* ---- 0x46b73e set_two_words ---- */
/* 0x46b73e, thiscall, plain `ret`: stores the word 0x0 at [0x5a14db] and the word 0x270f at [0x5a14dd]; `this` is only saved in a local (eax is not set). */
/* 0x46b73e m46b73e_set_two_words */
void m46b73e_set_two_words(Fl36eWorld *world)
{
    world->word_5a14db = 0x0;
    world->word_5a14dd = 0x270f;
}

/* ---- 0x470e71 set_two_words ---- */
/* 0x470e71, thiscall, plain `ret`: stores the word 0x0 at [0x5957b5] and the word 0x0 at [0x5957b7]; `this` is only saved in a local (eax is not set). */
/* 0x470e71 m470e71_set_two_words */
void m470e71_set_two_words(Fl36eWorld *world)
{
    world->word_5957b5 = 0x0;
    world->word_5957b7 = 0x0;
}

/* ---- 0x4712b0 empty_method_args ---- */
/* 0x4712b0, thiscall, `ret 8`: does nothing; `this` is only saved in a local and 8 bytes of stack arguments are popped (eax is not set). */
/* 0x4712b0 m4712b0_empty_method_args */
void m4712b0_empty_method_args(uint8_t *self)
{
    (void)self;
}

/* ---- 0x4782be set_two_words ---- */
/* 0x4782be, thiscall, plain `ret`: stores the word 0x0 at [0x5957bb] and the word 0x270f at [0x5957bd]; `this` is only saved in a local (eax is not set). */
/* 0x4782be m4782be_set_two_words */
void m4782be_set_two_words(Fl36eWorld *world)
{
    world->word_5957bb = 0x0;
    world->word_5957bd = 0x270f;
}

/* ---- 0x488d6a destruct_base_set_vtable ---- */
/* 0x488d6a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments, plain `ret`), then stores the dword 0x52d850u at [this]. */
/* 0x488d6a m488d6a_destruct_base_set_vtable */
uint8_t *m488d6a_destruct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52d850u);
    return self;
}

/* ---- 0x48d119 set_word ---- */
/* 0x48d119, thiscall, plain `ret`: stores the word 0x0 at [0x594daf]; `this` is only saved in a local (eax is not set). */
/* 0x48d119 m48d119_set_word */
void m48d119_set_word(Fl36eWorld *world)
{
    world->word_594daf = 0x0;
}

/* ---- 0x493ad8 set_field_const ---- */
/* 0x493ad8, thiscall, plain `ret`, returns this: stores the dword 0x1u at [this + 0x200b]. */
/* 0x493ad8 m493ad8_set_field_const */
uint8_t *m493ad8_set_field_const(uint8_t *self)
{
    wr32(self, 0x200b, 0x1u);
    return self;
}

/* ---- 0x4a7ddc set_two_words ---- */
/* 0x4a7ddc, thiscall, plain `ret`: stores the word 0x0 at [0x5a110b] and the word 0x270f at [0x5a110d]; `this` is only saved in a local (eax is not set). */
/* 0x4a7ddc m4a7ddc_set_two_words */
void m4a7ddc_set_two_words(Fl36eWorld *world)
{
    world->word_5a110b = 0x0;
    world->word_5a110d = 0x270f;
}

/* ---- 0x4ab459 set_word ---- */
/* 0x4ab459, thiscall, plain `ret`: stores the word 0x0 at [0x5957b9]; `this` is only saved in a local (eax is not set). */
/* 0x4ab459 m4ab459_set_word */
void m4ab459_set_word(Fl36eWorld *world)
{
    world->word_5957b9 = 0x0;
}

/* ---- 0x4b5c48 set_word ---- */
/* 0x4b5c48, thiscall, plain `ret`: stores the word 0x0 at [0x594db1]; `this` is only saved in a local (eax is not set). */
/* 0x4b5c48 m4b5c48_set_word */
void m4b5c48_set_word(Fl36eWorld *world)
{
    world->word_594db1 = 0x0;
}

/* ---- 0x4bf3a4 get_field ---- */
/* 0x4bf3a4, thiscall, plain `ret`: returns the dword at [this + 0x2c0] in eax. */
/* 0x4bf3a4 m4bf3a4_get_field */
uint32_t m4bf3a4_get_field(uint8_t *self)
{
    return rd32(self, 0x2c0);
}

/* ---- 0x4c0c40 get_field ---- */
/* 0x4c0c40, thiscall, plain `ret`: returns the dword at [this + 0x216] in eax. */
/* 0x4c0c40 m4c0c40_get_field */
uint32_t m4c0c40_get_field(uint8_t *self)
{
    return rd32(self, 0x216);
}

/* ---- 0x4caeef init_vtable_ret_self ---- */
/* 0x4caeef, thiscall, plain `ret`, returns this: stores the dword 0x52e23cu at [this]. */
/* 0x4caeef m4caeef_init_vtable_ret_self */
uint8_t *m4caeef_init_vtable_ret_self(uint8_t *self)
{
    wr32(self, 0, 0x52e23cu);
    return self;
}

/* ---- 0x4cc927 destruct_base_set_vtable ---- */
/* 0x4cc927, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments, plain `ret`), then stores the dword 0x52e278u at [this]. */
/* 0x4cc927 m4cc927_destruct_base_set_vtable */
uint8_t *m4cc927_destruct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52e278u);
    return self;
}

/* ---- 0x4d3705 call_global_object ---- */
/* 0x4d3705, plain `ret`, returns eax of its callee: 0x4e79ca with ecx = the global object 0x582711 (thiscall, no arguments); `this` is not used. */
/* 0x4d3705 m4d3705_call_global_object */
uint32_t m4d3705_call_global_object(const Fl18Host *host)
{
    return call0(host, 0x4e79ca, 0x582711);
}

/* ---- 0x4d3714 call_global_object ---- */
/* 0x4d3714, plain `ret`, returns eax of its callee: 0x4e1157 with ecx = the global object 0x570508 (thiscall, no arguments); `this` is not used. */
/* 0x4d3714 m4d3714_call_global_object */
uint32_t m4d3714_call_global_object(const Fl18Host *host)
{
    return call0(host, 0x4e1157, 0x570508);
}

/* ---- 0x4d3c1d get_field ---- */
/* 0x4d3c1d, thiscall, plain `ret`: returns the dword at [this + 0x462] in eax. */
/* 0x4d3c1d m4d3c1d_get_field */
uint32_t m4d3c1d_get_field(uint8_t *self)
{
    return rd32(self, 0x462);
}

/* ---- 0x4d51ea empty_method_args ---- */
/* 0x4d51ea, thiscall, `ret 4`: does nothing; `this` is only saved in a local and 4 bytes of stack arguments are popped (eax is not set). */
/* 0x4d51ea m4d51ea_empty_method_args */
void m4d51ea_empty_method_args(uint8_t *self)
{
    (void)self;
}

/* ---- 0x4d52a6 forward_call ---- */
/* 0x4d52a6, thiscall, plain `ret`, returns eax of its callee: 0x4d529b(this) (thiscall, no arguments, plain `ret`). */
/* 0x4d52a6 m4d52a6_forward_call */
uint32_t m4d52a6_forward_call(uint8_t *self, const Fl18Host *host)
{
    return call0(host, 0x4d529b, (uintptr_t)self);
}

/* ---- 0x4dae66 get_field ---- */
/* 0x4dae66, thiscall, plain `ret`: returns the dword at [this + 0x18] in eax. */
/* 0x4dae66 m4dae66_get_field */
uint32_t m4dae66_get_field(uint8_t *self)
{
    return rd32(self, 0x18);
}

/* ---- 0x4dae77 get_field ---- */
/* 0x4dae77, thiscall, plain `ret`: returns the dword at [this + 0x1c] in eax. */
/* 0x4dae77 m4dae77_get_field */
uint32_t m4dae77_get_field(uint8_t *self)
{
    return rd32(self, 0x1c);
}

/* ---- 0x4daef1 get_field ---- */
/* 0x4daef1, thiscall, plain `ret`: returns the dword at [this + 0xc] in eax. */
/* 0x4daef1 m4daef1_get_field */
uint32_t m4daef1_get_field(uint8_t *self)
{
    return rd32(self, 0xc);
}

/* ---- 0x4daf02 set_field_arg ---- */
/* 0x4daf02, thiscall, `ret 4`, returns this: stores the stack argument (a dword) at [this + 0xc]. */
/* 0x4daf02 m4daf02_set_field_arg */
uint8_t *m4daf02_set_field_arg(uint8_t *self, uint32_t value)
{
    wr32(self, 0xc, value);
    return self;
}

/* ---- 0x4daf18 get_field ---- */
/* 0x4daf18, thiscall, plain `ret`: returns the dword at [this + 0x10] in eax. */
/* 0x4daf18 m4daf18_get_field */
uint32_t m4daf18_get_field(uint8_t *self)
{
    return rd32(self, 0x10);
}

/* ---- 0x4daf29 set_field_arg ---- */
/* 0x4daf29, thiscall, `ret 4`, returns this: stores the stack argument (a dword) at [this + 0x10]. */
/* 0x4daf29 m4daf29_set_field_arg */
uint8_t *m4daf29_set_field_arg(uint8_t *self, uint32_t value)
{
    wr32(self, 0x10, value);
    return self;
}

/* ---- 0x4db377 forward_call ---- */
/* 0x4db377, thiscall, plain `ret`, returns eax of its callee: 0x4db29b(this) (thiscall, no arguments, plain `ret`). */
/* 0x4db377 m4db377_forward_call */
uint32_t m4db377_forward_call(uint8_t *self, const Fl18Host *host)
{
    return call0(host, 0x4db29b, (uintptr_t)self);
}

/* ---- 0x4dd3f6 forward_call ---- */
/* 0x4dd3f6, thiscall, plain `ret`, returns eax of its callee: 0x4dd3eb(this) (thiscall, no arguments, plain `ret`). */
/* 0x4dd3f6 m4dd3f6_forward_call */
uint32_t m4dd3f6_forward_call(uint8_t *self, const Fl18Host *host)
{
    return call0(host, 0x4dd3eb, (uintptr_t)self);
}

/* ---- 0x4e0742 set_field_const ---- */
/* 0x4e0742, thiscall, plain `ret`, returns this: stores the dword 0x1u at [this + 0xf2e]. */
/* 0x4e0742 m4e0742_set_field_const */
uint8_t *m4e0742_set_field_const(uint8_t *self)
{
    wr32(self, 0xf2e, 0x1u);
    return self;
}

/* ---- 0x4e2940 set_field_arg ---- */
/* 0x4e2940, thiscall, `ret 4`, returns this: stores the stack argument (a dword) at [this + 0x30]. */
/* 0x4e2940 m4e2940_set_field_arg */
uint8_t *m4e2940_set_field_arg(uint8_t *self, uint32_t value)
{
    wr32(self, 0x30, value);
    return self;
}

/* ---- 0x4e2956 get_field ---- */
/* 0x4e2956, thiscall, plain `ret`: returns the dword at [this + 0x30] in eax. */
/* 0x4e2956 m4e2956_get_field */
uint32_t m4e2956_get_field(uint8_t *self)
{
    return rd32(self, 0x30);
}

/* ---- 0x4e2967 get_field ---- */
/* 0x4e2967, thiscall, plain `ret`: returns the dword at [this + 0x7a] in eax. */
/* 0x4e2967 m4e2967_get_field */
uint32_t m4e2967_get_field(uint8_t *self)
{
    return rd32(self, 0x7a);
}

/* ---- 0x4e2978 set_field_const ---- */
/* 0x4e2978, thiscall, plain `ret`, returns this: stores the dword 0x1u at [this + 0x177]. */
/* 0x4e2978 m4e2978_set_field_const */
uint8_t *m4e2978_set_field_const(uint8_t *self)
{
    wr32(self, 0x177, 0x1u);
    return self;
}

/* ---- 0x4e2990 set_field_arg ---- */
/* 0x4e2990, thiscall, `ret 4`, returns this: stores the stack argument (a dword) at [this + 0x18]. */
/* 0x4e2990 m4e2990_set_field_arg */
uint8_t *m4e2990_set_field_arg(uint8_t *self, uint32_t value)
{
    wr32(self, 0x18, value);
    return self;
}

/* ---- 0x4e29a6 get_field ---- */
/* 0x4e29a6, thiscall, plain `ret`: returns the dword at [this + 0x18] in eax. */
/* 0x4e29a6 m4e29a6_get_field */
uint32_t m4e29a6_get_field(uint8_t *self)
{
    return rd32(self, 0x18);
}

/* ---- 0x4e40fb forward_call_arg ---- */
/* 0x4e40fb, thiscall, `ret 4`, returns eax of its callee: 0x4edfaf(this, the one stack argument) (thiscall, one argument, the callee pops it). */
/* 0x4e40fb m4e40fb_forward_call_arg */
uint32_t m4e40fb_forward_call_arg(uint8_t *self, uint32_t arg, const Fl18Host *host)
{
    return call1(host, 0x4edfaf, (uintptr_t)self, arg);
}

/* ---- 0x4e4114 forward_call_arg ---- */
/* 0x4e4114, thiscall, `ret 4`, returns eax of its callee: 0x4ee0d4(this, the one stack argument) (thiscall, one argument, the callee pops it). */
/* 0x4e4114 m4e4114_forward_call_arg */
uint32_t m4e4114_forward_call_arg(uint8_t *self, uint32_t arg, const Fl18Host *host)
{
    return call1(host, 0x4ee0d4, (uintptr_t)self, arg);
}

/* ---- 0x4e779f forward_call_arg ---- */
/* 0x4e779f, thiscall, `ret 4`, returns eax of its callee: 0x4ee0d4(this, the one stack argument) (thiscall, one argument, the callee pops it). */
/* 0x4e779f m4e779f_forward_call_arg */
uint32_t m4e779f_forward_call_arg(uint8_t *self, uint32_t arg, const Fl18Host *host)
{
    return call1(host, 0x4ee0d4, (uintptr_t)self, arg);
}

/* ---- 0x4e89b9 forward_call_arg ---- */
/* 0x4e89b9, thiscall, `ret 4`, returns eax of its callee: 0x4edfaf(this, the one stack argument) (thiscall, one argument, the callee pops it). */
/* 0x4e89b9 m4e89b9_forward_call_arg */
uint32_t m4e89b9_forward_call_arg(uint8_t *self, uint32_t arg, const Fl18Host *host)
{
    return call1(host, 0x4edfaf, (uintptr_t)self, arg);
}

/* ---- 0x4e89d2 forward_call_arg ---- */
/* 0x4e89d2, thiscall, `ret 4`, returns eax of its callee: 0x4ee0d4(this, the one stack argument) (thiscall, one argument, the callee pops it). */
/* 0x4e89d2 m4e89d2_forward_call_arg */
uint32_t m4e89d2_forward_call_arg(uint8_t *self, uint32_t arg, const Fl18Host *host)
{
    return call1(host, 0x4ee0d4, (uintptr_t)self, arg);
}

/* ---- 0x4e9e6c set_field_const ---- */
/* 0x4e9e6c, thiscall, plain `ret`, returns this: stores the dword 0x0u at [this + 0x8256]. */
/* 0x4e9e6c m4e9e6c_set_field_const */
uint8_t *m4e9e6c_set_field_const(uint8_t *self)
{
    wr32(self, 0x8256, 0x0u);
    return self;
}

/* ---- 0x4ebd53 forward_call_arg ---- */
/* 0x4ebd53, thiscall, `ret 4`, returns eax of its callee: 0x4edfaf(this, the one stack argument) (thiscall, one argument, the callee pops it). */
/* 0x4ebd53 m4ebd53_forward_call_arg */
uint32_t m4ebd53_forward_call_arg(uint8_t *self, uint32_t arg, const Fl18Host *host)
{
    return call1(host, 0x4edfaf, (uintptr_t)self, arg);
}

/* ---- 0x4ebd6c forward_call_arg ---- */
/* 0x4ebd6c, thiscall, `ret 4`, returns eax of its callee: 0x4ee0d4(this, the one stack argument) (thiscall, one argument, the callee pops it). */
/* 0x4ebd6c m4ebd6c_forward_call_arg */
uint32_t m4ebd6c_forward_call_arg(uint8_t *self, uint32_t arg, const Fl18Host *host)
{
    return call1(host, 0x4ee0d4, (uintptr_t)self, arg);
}

/* ---- 0x4ee602 get_field ---- */
/* 0x4ee602, thiscall, plain `ret`: returns the dword at [this + 0x4af] in eax. */
/* 0x4ee602 m4ee602_get_field */
uint32_t m4ee602_get_field(uint8_t *self)
{
    return rd32(self, 0x4af);
}

/* ---- 0x4ee630 get_field ---- */
/* 0x4ee630, thiscall, plain `ret`: returns the dword at [this + 0x4ab] in eax. */
/* 0x4ee630 m4ee630_get_field */
uint32_t m4ee630_get_field(uint8_t *self)
{
    return rd32(self, 0x4ab);
}

/* ---- 0x4ef4c9 set_field_arg ---- */
/* 0x4ef4c9, thiscall, `ret 4`, returns this: stores the stack argument (a dword) at [this + 0x10]. */
/* 0x4ef4c9 m4ef4c9_set_field_arg */
uint8_t *m4ef4c9_set_field_arg(uint8_t *self, uint32_t value)
{
    wr32(self, 0x10, value);
    return self;
}

/* ---- 0x4ef4df get_field ---- */
/* 0x4ef4df, thiscall, plain `ret`: returns the dword at [this + 0x10] in eax. */
/* 0x4ef4df m4ef4df_get_field */
uint32_t m4ef4df_get_field(uint8_t *self)
{
    return rd32(self, 0x10);
}

/* ---- 0x4ef516 get_field ---- */
/* 0x4ef516, thiscall, plain `ret`: returns the dword at [this + 0x162] in eax. */
/* 0x4ef516 m4ef516_get_field */
uint32_t m4ef516_get_field(uint8_t *self)
{
    return rd32(self, 0x162);
}

/* ---- 0x4f0046 forward_call ---- */
/* 0x4f0046, thiscall, plain `ret`, returns eax of its callee: 0x4f003b(this) (thiscall, no arguments, plain `ret`). */
/* 0x4f0046 m4f0046_forward_call */
uint32_t m4f0046_forward_call(uint8_t *self, const Fl18Host *host)
{
    return call0(host, 0x4f003b, (uintptr_t)self);
}

