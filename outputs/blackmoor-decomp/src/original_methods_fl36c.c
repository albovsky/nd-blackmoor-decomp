#include "original_methods_fl36c.h"

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

/* ---- 0x401032 init_vtable_call ---- */
/* 0x401032, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52a5d0u at [this], then 0x521756(this) (thiscall, no arguments, plain `ret`). */
/* 0x401032 m401032_init_vtable_call */
uint32_t m401032_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52a5d0u);
    return call0(host, 0x521756, (uintptr_t)self);
}

/* ---- 0x4014f5 init_vtable_call ---- */
/* 0x4014f5, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52ab70u at [this], then 0x5218ea(this) (thiscall, no arguments, plain `ret`). */
/* 0x4014f5 m4014f5_init_vtable_call */
uint32_t m4014f5_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52ab70u);
    return call0(host, 0x5218ea, (uintptr_t)self);
}

/* ---- 0x40168f set_mode_call ---- */
/* 0x40168f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x0u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x40168f m40168f_set_mode_call */
uint32_t m40168f_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x0u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x4016ac set_mode_call ---- */
/* 0x4016ac, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x1u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x4016ac m4016ac_set_mode_call */
uint32_t m4016ac_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x1u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x4016c9 set_mode_call ---- */
/* 0x4016c9, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x2u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x4016c9 m4016c9_set_mode_call */
uint32_t m4016c9_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x2u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x4016e6 set_mode_call ---- */
/* 0x4016e6, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x3u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x4016e6 m4016e6_set_mode_call */
uint32_t m4016e6_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x3u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401703 set_mode_call ---- */
/* 0x401703, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x4u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401703 m401703_set_mode_call */
uint32_t m401703_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x4u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401720 set_mode_call ---- */
/* 0x401720, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x5u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401720 m401720_set_mode_call */
uint32_t m401720_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x5u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x40173d set_mode_call ---- */
/* 0x40173d, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x6u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x40173d m40173d_set_mode_call */
uint32_t m40173d_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x6u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x40175a set_mode_call ---- */
/* 0x40175a, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x7u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x40175a m40175a_set_mode_call */
uint32_t m40175a_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x7u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401777 set_mode_call ---- */
/* 0x401777, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x8u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401777 m401777_set_mode_call */
uint32_t m401777_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x8u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401794 set_mode_call ---- */
/* 0x401794, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x9u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401794 m401794_set_mode_call */
uint32_t m401794_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x9u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x4017b1 set_mode_call ---- */
/* 0x4017b1, thiscall, plain `ret`, returns eax of its callee: stores the dword 0xau at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x4017b1 m4017b1_set_mode_call */
uint32_t m4017b1_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0xau;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x4017ce set_mode_call ---- */
/* 0x4017ce, thiscall, plain `ret`, returns eax of its callee: stores the dword 0xbu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x4017ce m4017ce_set_mode_call */
uint32_t m4017ce_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0xbu;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x4017eb set_mode_call ---- */
/* 0x4017eb, thiscall, plain `ret`, returns eax of its callee: stores the dword 0xcu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x4017eb m4017eb_set_mode_call */
uint32_t m4017eb_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0xcu;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401808 set_mode_call ---- */
/* 0x401808, thiscall, plain `ret`, returns eax of its callee: stores the dword 0xdu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401808 m401808_set_mode_call */
uint32_t m401808_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0xdu;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401825 set_mode_call ---- */
/* 0x401825, thiscall, plain `ret`, returns eax of its callee: stores the dword 0xeu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401825 m401825_set_mode_call */
uint32_t m401825_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0xeu;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401842 set_mode_call ---- */
/* 0x401842, thiscall, plain `ret`, returns eax of its callee: stores the dword 0xfu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401842 m401842_set_mode_call */
uint32_t m401842_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0xfu;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x40185f set_mode_call ---- */
/* 0x40185f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x10u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x40185f m40185f_set_mode_call */
uint32_t m40185f_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x10u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x40187c set_mode_call ---- */
/* 0x40187c, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x11u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x40187c m40187c_set_mode_call */
uint32_t m40187c_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x11u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401899 set_mode_call ---- */
/* 0x401899, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x12u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401899 m401899_set_mode_call */
uint32_t m401899_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x12u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x4018b6 set_mode_call ---- */
/* 0x4018b6, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x13u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x4018b6 m4018b6_set_mode_call */
uint32_t m4018b6_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x13u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x4018d3 set_mode_call ---- */
/* 0x4018d3, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x14u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x4018d3 m4018d3_set_mode_call */
uint32_t m4018d3_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x14u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x4018f0 set_mode_call ---- */
/* 0x4018f0, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x15u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x4018f0 m4018f0_set_mode_call */
uint32_t m4018f0_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x15u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x40190d set_mode_call ---- */
/* 0x40190d, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x16u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x40190d m40190d_set_mode_call */
uint32_t m40190d_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x16u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x40192a set_mode_call ---- */
/* 0x40192a, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x17u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x40192a m40192a_set_mode_call */
uint32_t m40192a_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x17u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401947 set_mode_call ---- */
/* 0x401947, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x18u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401947 m401947_set_mode_call */
uint32_t m401947_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x18u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401964 set_mode_call ---- */
/* 0x401964, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x19u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401964 m401964_set_mode_call */
uint32_t m401964_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x19u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401981 set_mode_call ---- */
/* 0x401981, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x1au at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401981 m401981_set_mode_call */
uint32_t m401981_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x1au;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x40199e set_mode_call ---- */
/* 0x40199e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x1bu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x40199e m40199e_set_mode_call */
uint32_t m40199e_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x1bu;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x4019bb set_mode_call ---- */
/* 0x4019bb, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x1cu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x4019bb m4019bb_set_mode_call */
uint32_t m4019bb_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x1cu;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x4019d8 set_mode_call ---- */
/* 0x4019d8, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x1du at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x4019d8 m4019d8_set_mode_call */
uint32_t m4019d8_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x1du;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x4019f5 set_mode_call ---- */
/* 0x4019f5, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x1eu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x4019f5 m4019f5_set_mode_call */
uint32_t m4019f5_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x1eu;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401a12 set_mode_call ---- */
/* 0x401a12, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x1fu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401a12 m401a12_set_mode_call */
uint32_t m401a12_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x1fu;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401a2f set_mode_call ---- */
/* 0x401a2f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x20u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401a2f m401a2f_set_mode_call */
uint32_t m401a2f_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x20u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401a4c set_mode_call ---- */
/* 0x401a4c, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x21u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401a4c m401a4c_set_mode_call */
uint32_t m401a4c_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x21u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401a69 set_mode_call ---- */
/* 0x401a69, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x22u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401a69 m401a69_set_mode_call */
uint32_t m401a69_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x22u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401a86 set_mode_call ---- */
/* 0x401a86, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x23u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401a86 m401a86_set_mode_call */
uint32_t m401a86_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x23u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401aa3 set_mode_call ---- */
/* 0x401aa3, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x24u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401aa3 m401aa3_set_mode_call */
uint32_t m401aa3_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x24u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401ac0 set_mode_call ---- */
/* 0x401ac0, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x25u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401ac0 m401ac0_set_mode_call */
uint32_t m401ac0_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x25u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401add set_mode_call ---- */
/* 0x401add, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x26u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401add m401add_set_mode_call */
uint32_t m401add_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x26u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401afa set_mode_call ---- */
/* 0x401afa, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x27u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401afa m401afa_set_mode_call */
uint32_t m401afa_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x27u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401b17 set_mode_call ---- */
/* 0x401b17, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x28u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401b17 m401b17_set_mode_call */
uint32_t m401b17_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x28u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401b34 set_mode_call ---- */
/* 0x401b34, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x29u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401b34 m401b34_set_mode_call */
uint32_t m401b34_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x29u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401b51 set_mode_call ---- */
/* 0x401b51, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x2au at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401b51 m401b51_set_mode_call */
uint32_t m401b51_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x2au;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401b6e set_mode_call ---- */
/* 0x401b6e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x2bu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401b6e m401b6e_set_mode_call */
uint32_t m401b6e_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x2bu;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401b8b set_mode_call ---- */
/* 0x401b8b, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x2cu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401b8b m401b8b_set_mode_call */
uint32_t m401b8b_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x2cu;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401ba8 set_mode_call ---- */
/* 0x401ba8, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x2du at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401ba8 m401ba8_set_mode_call */
uint32_t m401ba8_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x2du;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401bc5 set_mode_call ---- */
/* 0x401bc5, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x2eu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401bc5 m401bc5_set_mode_call */
uint32_t m401bc5_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x2eu;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401be2 set_mode_call ---- */
/* 0x401be2, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x2fu at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401be2 m401be2_set_mode_call */
uint32_t m401be2_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x2fu;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x401bff set_mode_call ---- */
/* 0x401bff, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x30u at [0x569138], then 0x401526(this) (thiscall, no arguments, plain `ret`). */
/* 0x401bff m401bff_set_mode_call */
uint32_t m401bff_set_mode_call(uint8_t *self, Fl36cWorld *world, const Fl18Host *host)
{
    world->dword_569138 = 0x30u;
    return call0(host, 0x401526, (uintptr_t)self);
}

/* ---- 0x404af0 init_vtable_call ---- */
/* 0x404af0, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52ba38u at [this], then 0x5218ea(this) (thiscall, no arguments, plain `ret`). */
/* 0x404af0 m404af0_init_vtable_call */
uint32_t m404af0_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52ba38u);
    return call0(host, 0x5218ea, (uintptr_t)self);
}

/* ---- 0x41458b init_vtable_call ---- */
/* 0x41458b, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52c4f0u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x41458b m41458b_init_vtable_call */
uint32_t m41458b_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52c4f0u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x414ccf init_vtable_call ---- */
/* 0x414ccf, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52c540u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x414ccf m414ccf_init_vtable_call */
uint32_t m414ccf_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52c540u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x437710 init_vtable_call_ret_self ---- */
/* 0x437710, thiscall, plain `ret`, returns this: stores the dword 0x52c7bcu at [this], calls 0x437743(this) (thiscall, no arguments, plain `ret`), returns this. */
/* 0x437710 m437710_init_vtable_call_ret_self */
uint8_t *m437710_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52c7bcu);
    (void)call0(host, 0x437743, (uintptr_t)self);
    return self;
}

/* ---- 0x43eb59 init_vtable_call ---- */
/* 0x43eb59, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52c900u at [this], then 0x5228a4(this) (thiscall, no arguments, plain `ret`). */
/* 0x43eb59 m43eb59_init_vtable_call */
uint32_t m43eb59_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52c900u);
    return call0(host, 0x5228a4, (uintptr_t)self);
}

/* ---- 0x445df0 init_vtable_call_ret_self ---- */
/* 0x445df0, thiscall, plain `ret`, returns this: stores the dword 0x52ca1cu at [this], calls 0x445e2b(this) (thiscall, no arguments, plain `ret`), returns this. */
/* 0x445df0 m445df0_init_vtable_call_ret_self */
uint8_t *m445df0_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52ca1cu);
    (void)call0(host, 0x445e2b, (uintptr_t)self);
    return self;
}

/* ---- 0x445e0f init_vtable_call ---- */
/* 0x445e0f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52ca1cu at [this], then 0x445f40(this) (thiscall, no arguments, plain `ret`). */
/* 0x445e0f m445e0f_init_vtable_call */
uint32_t m445e0f_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52ca1cu);
    return call0(host, 0x445f40, (uintptr_t)self);
}

/* ---- 0x447d10 init_vtable_call_ret_self ---- */
/* 0x447d10, thiscall, plain `ret`, returns this: stores the dword 0x52cac8u at [this], calls 0x447d4b(this) (thiscall, no arguments, plain `ret`), returns this. */
/* 0x447d10 m447d10_init_vtable_call_ret_self */
uint8_t *m447d10_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52cac8u);
    (void)call0(host, 0x447d4b, (uintptr_t)self);
    return self;
}

/* ---- 0x447d2f init_vtable_call ---- */
/* 0x447d2f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cac8u at [this], then 0x447d60(this) (thiscall, no arguments, plain `ret`). */
/* 0x447d2f m447d2f_init_vtable_call */
uint32_t m447d2f_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52cac8u);
    return call0(host, 0x447d60, (uintptr_t)self);
}

/* ---- 0x447e46 init_vtable_call ---- */
/* 0x447e46, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cb08u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x447e46 m447e46_init_vtable_call */
uint32_t m447e46_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52cb08u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x448820 init_vtable_call_ret_self ---- */
/* 0x448820, thiscall, plain `ret`, returns this: stores the dword 0x52cb58u at [this], calls 0x448853(this) (thiscall, no arguments, plain `ret`), returns this. */
/* 0x448820 m448820_init_vtable_call_ret_self */
uint8_t *m448820_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52cb58u);
    (void)call0(host, 0x448853, (uintptr_t)self);
    return self;
}

/* ---- 0x449a78 init_vtable_call ---- */
/* 0x449a78, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cb5cu at [this], then 0x449a94(this) (thiscall, no arguments, plain `ret`). */
/* 0x449a78 m449a78_init_vtable_call */
uint32_t m449a78_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52cb5cu);
    return call0(host, 0x449a94, (uintptr_t)self);
}

/* ---- 0x44afd6 init_vtable_call ---- */
/* 0x44afd6, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cb98u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x44afd6 m44afd6_init_vtable_call */
uint32_t m44afd6_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52cb98u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x44d0eb init_vtable_call ---- */
/* 0x44d0eb, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cc38u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x44d0eb m44d0eb_init_vtable_call */
uint32_t m44d0eb_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52cc38u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x44e74b init_vtable_call ---- */
/* 0x44e74b, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52ccc0u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x44e74b m44e74b_init_vtable_call */
uint32_t m44e74b_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52ccc0u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x44f650 init_vtable_call_ret_self ---- */
/* 0x44f650, thiscall, plain `ret`, returns this: stores the dword 0x52cd10u at [this], calls 0x44f68b(this) (thiscall, no arguments, plain `ret`), returns this. */
/* 0x44f650 m44f650_init_vtable_call_ret_self */
uint8_t *m44f650_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52cd10u);
    (void)call0(host, 0x44f68b, (uintptr_t)self);
    return self;
}

/* ---- 0x44f66f init_vtable_call ---- */
/* 0x44f66f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cd10u at [this], then 0x44f996(this) (thiscall, no arguments, plain `ret`). */
/* 0x44f66f m44f66f_init_vtable_call */
uint32_t m44f66f_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52cd10u);
    return call0(host, 0x44f996, (uintptr_t)self);
}

/* ---- 0x454d6e init_vtable_call ---- */
/* 0x454d6e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cd50u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x454d6e m454d6e_init_vtable_call */
uint32_t m454d6e_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52cd50u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x456ceb init_vtable_call ---- */
/* 0x456ceb, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cdd8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x456ceb m456ceb_init_vtable_call */
uint32_t m456ceb_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52cdd8u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x457f5e init_vtable_call ---- */
/* 0x457f5e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52ce60u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x457f5e m457f5e_init_vtable_call */
uint32_t m457f5e_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52ce60u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x459ace init_vtable_call ---- */
/* 0x459ace, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cee8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x459ace m459ace_init_vtable_call */
uint32_t m459ace_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52cee8u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x45b3ce init_vtable_call ---- */
/* 0x45b3ce, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cf70u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x45b3ce m45b3ce_init_vtable_call */
uint32_t m45b3ce_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52cf70u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x45dc6e init_vtable_call ---- */
/* 0x45dc6e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52cff8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x45dc6e m45dc6e_init_vtable_call */
uint32_t m45dc6e_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52cff8u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x46180b init_vtable_call ---- */
/* 0x46180b, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d080u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x46180b m46180b_init_vtable_call */
uint32_t m46180b_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d080u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x463ffe init_vtable_call ---- */
/* 0x463ffe, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d108u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x463ffe m463ffe_init_vtable_call */
uint32_t m463ffe_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d108u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x465aeb init_vtable_call ---- */
/* 0x465aeb, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d190u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x465aeb m465aeb_init_vtable_call */
uint32_t m465aeb_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d190u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x4674e0 init_vtable_call_ret_self ---- */
/* 0x4674e0, thiscall, plain `ret`, returns this: stores the dword 0x52d1e0u at [this], calls 0x467513(this) (thiscall, no arguments, plain `ret`), returns this. */
/* 0x4674e0 m4674e0_init_vtable_call_ret_self */
uint8_t *m4674e0_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d1e0u);
    (void)call0(host, 0x467513, (uintptr_t)self);
    return self;
}

/* ---- 0x468e3e init_vtable_call ---- */
/* 0x468e3e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d220u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x468e3e m468e3e_init_vtable_call */
uint32_t m468e3e_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d220u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x46b56e init_vtable_call ---- */
/* 0x46b56e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d2e8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x46b56e m46b56e_init_vtable_call */
uint32_t m46b56e_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d2e8u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x470d5e init_vtable_call ---- */
/* 0x470d5e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d3f8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x470d5e m470d5e_init_vtable_call */
uint32_t m470d5e_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d3f8u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x4757be init_vtable_call ---- */
/* 0x4757be, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d490u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x4757be m4757be_init_vtable_call */
uint32_t m4757be_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d490u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x4781de init_vtable_call ---- */
/* 0x4781de, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d518u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x4781de m4781de_init_vtable_call */
uint32_t m4781de_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d518u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x47b21f init_vtable_call ---- */
/* 0x47b21f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d568u at [this], then 0x47b321(this) (thiscall, no arguments, plain `ret`). */
/* 0x47b21f m47b21f_init_vtable_call */
uint32_t m47b21f_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d568u);
    return call0(host, 0x47b321, (uintptr_t)self);
}

/* ---- 0x47d4db init_vtable_call ---- */
/* 0x47d4db, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d5a8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x47d4db m47d4db_init_vtable_call */
uint32_t m47d4db_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d5a8u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x47e23e init_vtable_call ---- */
/* 0x47e23e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d630u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x47e23e m47e23e_init_vtable_call */
uint32_t m47e23e_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d630u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x48215e init_vtable_call ---- */
/* 0x48215e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d6b8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x48215e m48215e_init_vtable_call */
uint32_t m48215e_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d6b8u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x483f4e init_vtable_call ---- */
/* 0x483f4e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d740u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x483f4e m483f4e_init_vtable_call */
uint32_t m483f4e_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d740u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x487afe init_vtable_call ---- */
/* 0x487afe, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d7c8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x487afe m487afe_init_vtable_call */
uint32_t m487afe_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d7c8u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x488d89 init_vtable_call ---- */
/* 0x488d89, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d850u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x488d89 m488d89_init_vtable_call */
uint32_t m488d89_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d850u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x48a6ee init_vtable_call ---- */
/* 0x48a6ee, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d8d8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x48a6ee m48a6ee_init_vtable_call */
uint32_t m48a6ee_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d8d8u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x48bafb init_vtable_call ---- */
/* 0x48bafb, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d960u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x48bafb m48bafb_init_vtable_call */
uint32_t m48bafb_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d960u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x48d04b init_vtable_call ---- */
/* 0x48d04b, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52d9e8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x48d04b m48d04b_init_vtable_call */
uint32_t m48d04b_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52d9e8u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x48e26e init_vtable_call ---- */
/* 0x48e26e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52da70u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x48e26e m48e26e_init_vtable_call */
uint32_t m48e26e_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52da70u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x4a1c2b init_vtable_call ---- */
/* 0x4a1c2b, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52dc58u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x4a1c2b m4a1c2b_init_vtable_call */
uint32_t m4a1c2b_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52dc58u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x4a376e init_vtable_call ---- */
/* 0x4a376e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52dce0u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x4a376e m4a376e_init_vtable_call */
uint32_t m4a376e_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52dce0u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x4a636e init_vtable_call ---- */
/* 0x4a636e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52dd68u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x4a636e m4a636e_init_vtable_call */
uint32_t m4a636e_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52dd68u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x4a7c5e init_vtable_call ---- */
/* 0x4a7c5e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52ddf0u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x4a7c5e m4a7c5e_init_vtable_call */
uint32_t m4a7c5e_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52ddf0u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x4a9f0b init_vtable_call ---- */
/* 0x4a9f0b, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52de78u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x4a9f0b m4a9f0b_init_vtable_call */
uint32_t m4a9f0b_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52de78u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x4ab38b init_vtable_call ---- */
/* 0x4ab38b, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52df00u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x4ab38b m4ab38b_init_vtable_call */
uint32_t m4ab38b_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52df00u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x4ac8be init_vtable_call ---- */
/* 0x4ac8be, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52df88u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x4ac8be m4ac8be_init_vtable_call */
uint32_t m4ac8be_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52df88u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x4afd1e init_vtable_call ---- */
/* 0x4afd1e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e010u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x4afd1e m4afd1e_init_vtable_call */
uint32_t m4afd1e_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e010u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x4b3c3e init_vtable_call ---- */
/* 0x4b3c3e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e098u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x4b3c3e m4b3c3e_init_vtable_call */
uint32_t m4b3c3e_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e098u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x4b5b6e init_vtable_call ---- */
/* 0x4b5b6e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e120u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x4b5b6e m4b5b6e_init_vtable_call */
uint32_t m4b5b6e_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e120u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x4b71db init_vtable_call ---- */
/* 0x4b71db, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e1a8u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x4b71db m4b71db_init_vtable_call */
uint32_t m4b71db_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e1a8u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x4b7f00 init_vtable_call_ret_self ---- */
/* 0x4b7f00, thiscall, plain `ret`, returns this: stores the dword 0x52e1f8u at [this], calls 0x4b7f3b(this) (thiscall, no arguments, plain `ret`), returns this. */
/* 0x4b7f00 m4b7f00_init_vtable_call_ret_self */
uint8_t *m4b7f00_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e1f8u);
    (void)call0(host, 0x4b7f3b, (uintptr_t)self);
    return self;
}

/* ---- 0x4b7f1f init_vtable_call ---- */
/* 0x4b7f1f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e1f8u at [this], then 0x4b7ff4(this) (thiscall, no arguments, plain `ret`). */
/* 0x4b7f1f m4b7f1f_init_vtable_call */
uint32_t m4b7f1f_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e1f8u);
    return call0(host, 0x4b7ff4, (uintptr_t)self);
}

/* ---- 0x4b9e00 init_vtable_call_ret_self ---- */
/* 0x4b9e00, thiscall, plain `ret`, returns this: stores the dword 0x52e200u at [this], calls 0x4b9e3b(this) (thiscall, no arguments, plain `ret`), returns this. */
/* 0x4b9e00 m4b9e00_init_vtable_call_ret_self */
uint8_t *m4b9e00_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e200u);
    (void)call0(host, 0x4b9e3b, (uintptr_t)self);
    return self;
}

/* ---- 0x4b9e1f init_vtable_call ---- */
/* 0x4b9e1f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e200u at [this], then 0x4ba07f(this) (thiscall, no arguments, plain `ret`). */
/* 0x4b9e1f m4b9e1f_init_vtable_call */
uint32_t m4b9e1f_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e200u);
    return call0(host, 0x4ba07f, (uintptr_t)self);
}

/* ---- 0x4bed99 init_vtable_call ---- */
/* 0x4bed99, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e210u at [this], then 0x4bede7(this) (thiscall, no arguments, plain `ret`). */
/* 0x4bed99 m4bed99_init_vtable_call */
uint32_t m4bed99_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e210u);
    return call0(host, 0x4bede7, (uintptr_t)self);
}

/* ---- 0x4bf600 init_vtable_call_ret_self ---- */
/* 0x4bf600, thiscall, plain `ret`, returns this: stores the dword 0x52e214u at [this], calls 0x4bf63b(this) (thiscall, no arguments, plain `ret`), returns this. */
/* 0x4bf600 m4bf600_init_vtable_call_ret_self */
uint8_t *m4bf600_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e214u);
    (void)call0(host, 0x4bf63b, (uintptr_t)self);
    return self;
}

/* ---- 0x4bf61f init_vtable_call ---- */
/* 0x4bf61f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e214u at [this], then 0x4bf8a7(this) (thiscall, no arguments, plain `ret`). */
/* 0x4bf61f m4bf61f_init_vtable_call */
uint32_t m4bf61f_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e214u);
    return call0(host, 0x4bf8a7, (uintptr_t)self);
}

/* ---- 0x4caed0 init_vtable_call_ret_self ---- */
/* 0x4caed0, thiscall, plain `ret`, returns this: stores the dword 0x52e23cu at [this], calls 0x4caf03(this) (thiscall, no arguments, plain `ret`), returns this. */
/* 0x4caed0 m4caed0_init_vtable_call_ret_self */
uint8_t *m4caed0_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e23cu);
    (void)call0(host, 0x4caf03, (uintptr_t)self);
    return self;
}

/* ---- 0x4cc946 init_vtable_call ---- */
/* 0x4cc946, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e278u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x4cc946 m4cc946_init_vtable_call */
uint32_t m4cc946_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e278u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x4ccd8f init_vtable_call ---- */
/* 0x4ccd8f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e2d0u at [this], then 0x4cd218(this) (thiscall, no arguments, plain `ret`). */
/* 0x4ccd8f m4ccd8f_init_vtable_call */
uint32_t m4ccd8f_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e2d0u);
    return call0(host, 0x4cd218, (uintptr_t)self);
}

/* ---- 0x4d3b6e init_vtable_call ---- */
/* 0x4d3b6e, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e310u at [this], then 0x51d730(this) (thiscall, no arguments, plain `ret`). */
/* 0x4d3b6e m4d3b6e_init_vtable_call */
uint32_t m4d3b6e_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e310u);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x4d5260 init_vtable_call_ret_self ---- */
/* 0x4d5260, thiscall, plain `ret`, returns this: stores the dword 0x52e450u at [this], calls 0x4d529b(this) (thiscall, no arguments, plain `ret`), returns this. */
/* 0x4d5260 m4d5260_init_vtable_call_ret_self */
uint8_t *m4d5260_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e450u);
    (void)call0(host, 0x4d529b, (uintptr_t)self);
    return self;
}

/* ---- 0x4d527f init_vtable_call ---- */
/* 0x4d527f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e450u at [this], then 0x4d52a6(this) (thiscall, no arguments, plain `ret`). */
/* 0x4d527f m4d527f_init_vtable_call */
uint32_t m4d527f_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e450u);
    return call0(host, 0x4d52a6, (uintptr_t)self);
}

/* ---- 0x4d58b0 init_vtable_call_ret_self ---- */
/* 0x4d58b0, thiscall, plain `ret`, returns this: stores the dword 0x52e454u at [this], calls 0x4d58eb(this) (thiscall, no arguments, plain `ret`), returns this. */
/* 0x4d58b0 m4d58b0_init_vtable_call_ret_self */
uint8_t *m4d58b0_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e454u);
    (void)call0(host, 0x4d58eb, (uintptr_t)self);
    return self;
}

/* ---- 0x4d58cf init_vtable_call ---- */
/* 0x4d58cf, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e454u at [this], then 0x4d5b54(this) (thiscall, no arguments, plain `ret`). */
/* 0x4d58cf m4d58cf_init_vtable_call */
uint32_t m4d58cf_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e454u);
    return call0(host, 0x4d5b54, (uintptr_t)self);
}

/* ---- 0x4db260 init_vtable_call_ret_self ---- */
/* 0x4db260, thiscall, plain `ret`, returns this: stores the dword 0x52e458u at [this], calls 0x4db29b(this) (thiscall, no arguments, plain `ret`), returns this. */
/* 0x4db260 m4db260_init_vtable_call_ret_self */
uint8_t *m4db260_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e458u);
    (void)call0(host, 0x4db29b, (uintptr_t)self);
    return self;
}

/* ---- 0x4db27f init_vtable_call ---- */
/* 0x4db27f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e458u at [this], then 0x4db377(this) (thiscall, no arguments, plain `ret`). */
/* 0x4db27f m4db27f_init_vtable_call */
uint32_t m4db27f_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e458u);
    return call0(host, 0x4db377, (uintptr_t)self);
}

/* ---- 0x4dd3b0 init_vtable_call_ret_self ---- */
/* 0x4dd3b0, thiscall, plain `ret`, returns this: stores the dword 0x52e4c8u at [this], calls 0x4dd3eb(this) (thiscall, no arguments, plain `ret`), returns this. */
/* 0x4dd3b0 m4dd3b0_init_vtable_call_ret_self */
uint8_t *m4dd3b0_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e4c8u);
    (void)call0(host, 0x4dd3eb, (uintptr_t)self);
    return self;
}

/* ---- 0x4dd3cf init_vtable_call ---- */
/* 0x4dd3cf, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e4c8u at [this], then 0x4dd3f6(this) (thiscall, no arguments, plain `ret`). */
/* 0x4dd3cf m4dd3cf_init_vtable_call */
uint32_t m4dd3cf_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e4c8u);
    return call0(host, 0x4dd3f6, (uintptr_t)self);
}

/* ---- 0x4e1c83 init_vtable_call ---- */
/* 0x4e1c83, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e4e8u at [this], then 0x4e1d34(this) (thiscall, no arguments, plain `ret`). */
/* 0x4e1c83 m4e1c83_init_vtable_call */
uint32_t m4e1c83_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e4e8u);
    return call0(host, 0x4e1d34, (uintptr_t)self);
}

/* ---- 0x4ee980 init_vtable_call_ret_self ---- */
/* 0x4ee980, thiscall, plain `ret`, returns this: stores the dword 0x52e500u at [this], calls 0x4ee9bb(this) (thiscall, no arguments, plain `ret`), returns this. */
/* 0x4ee980 m4ee980_init_vtable_call_ret_self */
uint8_t *m4ee980_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e500u);
    (void)call0(host, 0x4ee9bb, (uintptr_t)self);
    return self;
}

/* ---- 0x4ee99f init_vtable_call ---- */
/* 0x4ee99f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e500u at [this], then 0x4eead0(this) (thiscall, no arguments, plain `ret`). */
/* 0x4ee99f m4ee99f_init_vtable_call */
uint32_t m4ee99f_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e500u);
    return call0(host, 0x4eead0, (uintptr_t)self);
}

/* ---- 0x4f0000 init_vtable_call_ret_self ---- */
/* 0x4f0000, thiscall, plain `ret`, returns this: stores the dword 0x52e504u at [this], calls 0x4f003b(this) (thiscall, no arguments, plain `ret`), returns this. */
/* 0x4f0000 m4f0000_init_vtable_call_ret_self */
uint8_t *m4f0000_init_vtable_call_ret_self(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e504u);
    (void)call0(host, 0x4f003b, (uintptr_t)self);
    return self;
}

/* ---- 0x4f001f init_vtable_call ---- */
/* 0x4f001f, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e504u at [this], then 0x4f0046(this) (thiscall, no arguments, plain `ret`). */
/* 0x4f001f m4f001f_init_vtable_call */
uint32_t m4f001f_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e504u);
    return call0(host, 0x4f0046, (uintptr_t)self);
}

/* ---- 0x4fa9e7 init_vtable_call ---- */
/* 0x4fa9e7, thiscall, plain `ret`, returns eax of its callee: stores the dword 0x52e518u at [this], then 0x4fad50(this) (thiscall, no arguments, plain `ret`). */
/* 0x4fa9e7 m4fa9e7_init_vtable_call */
uint32_t m4fa9e7_init_vtable_call(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e518u);
    return call0(host, 0x4fad50, (uintptr_t)self);
}

