#include "original_methods_fl38a.h"

#include <string.h>

#if defined(__GNUC__)
#define FL38_UNUSED __attribute__((unused))
#else
#define FL38_UNUSED
#endif

FL38_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL38_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL38_UNUSED static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL38_UNUSED static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

FL38_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

FL38_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

/* ---- 0x414c6d get_constant ---- */
/* 0x414c6d, thiscall, plain `ret`: returns the constant 0x52c4d0u in eax; `this` is only saved in a local and not read. */
/* 0x414c6d m414c6d_get_constant */
uint32_t m414c6d_get_constant(uint8_t *self)
{
    (void)self;
    return 0x52c4d0u;
}

/* ---- 0x447cc4 get_constant ---- */
/* 0x447cc4, thiscall, plain `ret`: returns the constant 0x52ca38u in eax; `this` is only saved in a local and not read. */
/* 0x447cc4 m447cc4_get_constant */
uint32_t m447cc4_get_constant(uint8_t *self)
{
    (void)self;
    return 0x52ca38u;
}

/* ---- 0x4487de get_constant ---- */
/* 0x4487de, thiscall, plain `ret`: returns the constant 0x52cae8u in eax; `this` is only saved in a local and not read. */
/* 0x4487de m4487de_get_constant */
uint32_t m4487de_get_constant(uint8_t *self)
{
    (void)self;
    return 0x52cae8u;
}

/* ---- 0x44be44 get_constant ---- */
/* 0x44be44, thiscall, plain `ret`: returns the constant 0x52cb78u in eax; `this` is only saved in a local and not read. */
/* 0x44be44 m44be44_get_constant */
uint32_t m44be44_get_constant(uint8_t *self)
{
    (void)self;
    return 0x52cb78u;
}

/* ---- 0x4542b5 check_no_sound_call ---- */
/* 0x4542b5, thiscall, plain `ret`, returns 0 when the 9 bytes at [self+0x550] equal the 9 bytes at 0x549de0 ("NO SOUND" and its terminating zero; `repe cmpsb`), else the eax of 0x4fb2e3 (thiscall, ecx 0x5c3a67) called with the word [self+0x571] (pushed from dx). */
/* 0x4542b5 m4542b5_check_no_sound_call */
uint32_t m4542b5_check_no_sound_call(uint8_t *self, const Fl18Host *host)
{
    static const uint8_t k[9] = {0x4e, 0x4f, 0x20, 0x53, 0x4f, 0x55, 0x4e, 0x44, 0x00}; /* the 9 bytes at 0x549de0 */
    if (memcmp(self + 0x550, k, 9) == 0) return 0;
    return call1(host, 0x4fb2e3, 0x5c3a67, rd16(self, 0x571));
}

/* ---- 0x4542f2 check_no_sound_call ---- */
/* 0x4542f2, thiscall, plain `ret`, returns 0 when the 9 bytes at [self+0x581] equal the 9 bytes at 0x549dec ("NO SOUND" and its terminating zero; `repe cmpsb`), else the eax of 0x4fb2e3 (thiscall, ecx 0x5c3a67) called with the word [self+0x5a2] (pushed from dx). */
/* 0x4542f2 m4542f2_check_no_sound_call */
uint32_t m4542f2_check_no_sound_call(uint8_t *self, const Fl18Host *host)
{
    static const uint8_t k[9] = {0x4e, 0x4f, 0x20, 0x53, 0x4f, 0x55, 0x4e, 0x44, 0x00}; /* the 9 bytes at 0x549dec */
    if (memcmp(self + 0x581, k, 9) == 0) return 0;
    return call1(host, 0x4fb2e3, 0x5c3a67, rd16(self, 0x5a2));
}

/* ---- 0x45441d check_no_sound_call ---- */
/* 0x45441d, thiscall, plain `ret`, returns 0 when the 9 bytes at [self+0x676] equal the 9 bytes at 0x549e1c ("NO SOUND" and its terminating zero; `repe cmpsb`), else the eax of 0x4fb2e3 (thiscall, ecx 0x5c3a67) called with the word [self+0x697] (pushed from dx). */
/* 0x45441d m45441d_check_no_sound_call */
uint32_t m45441d_check_no_sound_call(uint8_t *self, const Fl18Host *host)
{
    static const uint8_t k[9] = {0x4e, 0x4f, 0x20, 0x53, 0x4f, 0x55, 0x4e, 0x44, 0x00}; /* the 9 bytes at 0x549e1c */
    if (memcmp(self + 0x676, k, 9) == 0) return 0;
    return call1(host, 0x4fb2e3, 0x5c3a67, rd16(self, 0x697));
}

/* ---- 0x454de6 release_surface_clear_call_tail ---- */
/* 0x454de6, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0x20] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0x20 and then stores the dword 0 at [self+0x20] (after the call); when the signed word [self+0x1c] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x454d9e(this self) (thiscall, no arguments). */
/* 0x454de6 m454de6_release_surface_clear_call_tail */
uint32_t m454de6_release_surface_clear_call_tail(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x20) != 0) {
        (void)call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x20));
        wr32(self, 0x20, 0);
    }
    if ((int16_t)rd16(self, 0x1c) != -1) (void)call1(host, 0x4d3992, 0, rd16(self, 0x1c));
    return call0(host, 0x454d9e, (uintptr_t)self);
}

/* ---- 0x454e39 guard_set_table_flag ---- */
/* 0x454e39, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0x150] is non-zero and the signed word [self+0x1c] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x1c]); the word is read again for the store (a signed 16-bit index, no bounds check). */
/* 0x454e39 m454e39_guard_set_table_flag */
uint8_t *m454e39_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world)
{
    if (rd32(self, 0x150) != 0 && (int16_t)rd16(self, 0x1c) != -1)
        wr32(world->table_5d15a5, (ptrdiff_t)(int16_t)rd16(self, 0x1c) * 0x4a, 1);
    return self;
}

/* ---- 0x456d2e release_surface_call_tail ---- */
/* 0x456d2e, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0x20] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0x20; when the signed word [self+0x1c] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x456d07(this self) (thiscall, no arguments). */
/* 0x456d2e m456d2e_release_surface_call_tail */
uint32_t m456d2e_release_surface_call_tail(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x20) != 0) (void)call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x20));
    if ((int16_t)rd16(self, 0x1c) != -1) (void)call1(host, 0x4d3992, 0, rd16(self, 0x1c));
    return call0(host, 0x456d07, (uintptr_t)self);
}

/* ---- 0x456d77 guard_set_table_flag ---- */
/* 0x456d77, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0x3e] is non-zero and the signed word [self+0x1c] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x1c]); the word is read again for the store (a signed 16-bit index, no bounds check). */
/* 0x456d77 m456d77_guard_set_table_flag */
uint8_t *m456d77_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world)
{
    if (rd32(self, 0x3e) != 0 && (int16_t)rd16(self, 0x1c) != -1)
        wr32(world->table_5d15a5, (ptrdiff_t)(int16_t)rd16(self, 0x1c) * 0x4a, 1);
    return self;
}

/* ---- 0x457fc2 release_surface_clear_call_tail ---- */
/* 0x457fc2, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0x1c] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0x1c and then stores the dword 0 at [self+0x1c] (after the call); when the signed word [self+0x24] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x457f7a(this self) (thiscall, no arguments). */
/* 0x457fc2 m457fc2_release_surface_clear_call_tail */
uint32_t m457fc2_release_surface_clear_call_tail(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x1c) != 0) {
        (void)call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x1c));
        wr32(self, 0x1c, 0);
    }
    if ((int16_t)rd16(self, 0x24) != -1) (void)call1(host, 0x4d3992, 0, rd16(self, 0x24));
    return call0(host, 0x457f7a, (uintptr_t)self);
}

/* ---- 0x458045 guard_set_table_flag ---- */
/* 0x458045, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0x98] is non-zero and the signed word [self+0x24] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x24]); the word is read again for the store (a signed 16-bit index, no bounds check). */
/* 0x458045 m458045_guard_set_table_flag */
uint8_t *m458045_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world)
{
    if (rd32(self, 0x98) != 0 && (int16_t)rd16(self, 0x24) != -1)
        wr32(world->table_5d15a5, (ptrdiff_t)(int16_t)rd16(self, 0x24) * 0x4a, 1);
    return self;
}

/* ---- 0x459b87 release_surface_call_tail ---- */
/* 0x459b87, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0xc8] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0xc8; when the signed word [self+0x22] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x459aea(this self) (thiscall, no arguments). */
/* 0x459b87 m459b87_release_surface_call_tail */
uint32_t m459b87_release_surface_call_tail(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0xc8) != 0) (void)call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0xc8));
    if ((int16_t)rd16(self, 0x22) != -1) (void)call1(host, 0x4d3992, 0, rd16(self, 0x22));
    return call0(host, 0x459aea, (uintptr_t)self);
}

/* ---- 0x45dd4d release_surface_call_tail ---- */
/* 0x45dd4d, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0x20] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0x20; when the signed word [self+0x1c] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x45dc8a(this self) (thiscall, no arguments). */
/* 0x45dd4d m45dd4d_release_surface_call_tail */
uint32_t m45dd4d_release_surface_call_tail(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x20) != 0) (void)call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x20));
    if ((int16_t)rd16(self, 0x1c) != -1) (void)call1(host, 0x4d3992, 0, rd16(self, 0x1c));
    return call0(host, 0x45dc8a, (uintptr_t)self);
}

/* ---- 0x464076 release_surface_clear_call_tail ---- */
/* 0x464076, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0x20] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0x20 and then stores the dword 0 at [self+0x20] (after the call); when the signed word [self+0x1c] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x46402e(this self) (thiscall, no arguments). */
/* 0x464076 m464076_release_surface_clear_call_tail */
uint32_t m464076_release_surface_clear_call_tail(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x20) != 0) {
        (void)call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x20));
        wr32(self, 0x20, 0);
    }
    if ((int16_t)rd16(self, 0x1c) != -1) (void)call1(host, 0x4d3992, 0, rd16(self, 0x1c));
    return call0(host, 0x46402e, (uintptr_t)self);
}

/* ---- 0x4640c9 guard_set_table_flag ---- */
/* 0x4640c9, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0xb8] is non-zero and the signed word [self+0x1c] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x1c]); the word is read again for the store (a signed 16-bit index, no bounds check). */
/* 0x4640c9 m4640c9_guard_set_table_flag */
uint8_t *m4640c9_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world)
{
    if (rd32(self, 0xb8) != 0 && (int16_t)rd16(self, 0x1c) != -1)
        wr32(world->table_5d15a5, (ptrdiff_t)(int16_t)rd16(self, 0x1c) * 0x4a, 1);
    return self;
}

/* ---- 0x465b9f guard_set_table_flag ---- */
/* 0x465b9f, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0x49] is non-zero and the signed word [self+0x1c] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x1c]); the word is read again for the store (a signed 16-bit index, no bounds check). */
/* 0x465b9f m465b9f_guard_set_table_flag */
uint8_t *m465b9f_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world)
{
    if (rd32(self, 0x49) != 0 && (int16_t)rd16(self, 0x1c) != -1)
        wr32(world->table_5d15a5, (ptrdiff_t)(int16_t)rd16(self, 0x1c) * 0x4a, 1);
    return self;
}

/* ---- 0x467651 guard_set_table_flag ---- */
/* 0x467651, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0x1ae] is non-zero and the signed word [self+0x10] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x10]); the word is read again for the store (a signed 16-bit index, no bounds check). */
/* 0x467651 m467651_guard_set_table_flag */
uint8_t *m467651_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world)
{
    if (rd32(self, 0x1ae) != 0 && (int16_t)rd16(self, 0x10) != -1)
        wr32(world->table_5d15a5, (ptrdiff_t)(int16_t)rd16(self, 0x10) * 0x4a, 1);
    return self;
}

/* ---- 0x468f19 release_surface_call_tail ---- */
/* 0x468f19, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0x52c] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0x52c; when the signed word [self+0x7c] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x468e5a(this self) (thiscall, no arguments). */
/* 0x468f19 m468f19_release_surface_call_tail */
uint32_t m468f19_release_surface_call_tail(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x52c) != 0) (void)call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x52c));
    if ((int16_t)rd16(self, 0x7c) != -1) (void)call1(host, 0x4d3992, 0, rd16(self, 0x7c));
    return call0(host, 0x468e5a, (uintptr_t)self);
}

/* ---- 0x468f68 guard_set_table_flag ---- */
/* 0x468f68, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0x55c] is non-zero and the signed word [self+0x7c] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x7c]); the word is read again for the store (a signed 16-bit index, no bounds check). */
/* 0x468f68 m468f68_guard_set_table_flag */
uint8_t *m468f68_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world)
{
    if (rd32(self, 0x55c) != 0 && (int16_t)rd16(self, 0x7c) != -1)
        wr32(world->table_5d15a5, (ptrdiff_t)(int16_t)rd16(self, 0x7c) * 0x4a, 1);
    return self;
}

/* ---- 0x46b707 guard_set_table_flag ---- */
/* 0x46b707, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0x4a48] is non-zero and the signed word [self+0x1c] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x1c]); the word is read again for the store (a signed 16-bit index, no bounds check). */
/* 0x46b707 m46b707_guard_set_table_flag */
uint8_t *m46b707_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world)
{
    if (rd32(self, 0x4a48) != 0 && (int16_t)rd16(self, 0x1c) != -1)
        wr32(world->table_5d15a5, (ptrdiff_t)(int16_t)rd16(self, 0x1c) * 0x4a, 1);
    return self;
}

/* ---- 0x46e7a6 release_surface_call_tail ---- */
/* 0x46e7a6, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0x20] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0x20; when the signed word [self+0x1c] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x46e6c1(this self) (thiscall, no arguments). */
/* 0x46e7a6 m46e7a6_release_surface_call_tail */
uint32_t m46e7a6_release_surface_call_tail(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x20) != 0) (void)call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x20));
    if ((int16_t)rd16(self, 0x1c) != -1) (void)call1(host, 0x4d3992, 0, rd16(self, 0x1c));
    return call0(host, 0x46e6c1, (uintptr_t)self);
}

/* ---- 0x46e7ef guard_set_table_flag ---- */
/* 0x46e7ef, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0x46] is non-zero and the signed word [self+0x1c] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x1c]); the word is read again for the store (a signed 16-bit index, no bounds check). */
/* 0x46e7ef m46e7ef_guard_set_table_flag */
uint8_t *m46e7ef_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world)
{
    if (rd32(self, 0x46) != 0 && (int16_t)rd16(self, 0x1c) != -1)
        wr32(world->table_5d15a5, (ptrdiff_t)(int16_t)rd16(self, 0x1c) * 0x4a, 1);
    return self;
}

/* ---- 0x470ddc release_surface_call_tail ---- */
/* 0x470ddc, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0xd24] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0xd24; when the signed word [self+0xd38] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x470d7a(this self) (thiscall, no arguments). */
/* 0x470ddc m470ddc_release_surface_call_tail */
uint32_t m470ddc_release_surface_call_tail(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0xd24) != 0) (void)call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0xd24));
    if ((int16_t)rd16(self, 0xd38) != -1) (void)call1(host, 0x4d3992, 0, rd16(self, 0xd38));
    return call0(host, 0x470d7a, (uintptr_t)self);
}

/* ---- 0x47823e release_surface_call_tail ---- */
/* 0x47823e, thiscall, plain `ret`, returns the eax of the last call: when the dword [self+0x20] is non-zero calls 0x4c2dfb (thiscall, ecx 0x5cf659, the callee pops its one argument) with the address self+0x20; when the signed word [self+0x1c] is not -1 calls 0x4d3992 (cdecl, the caller pops) with that word; then 0x4781fa(this self) (thiscall, no arguments). */
/* 0x47823e m47823e_release_surface_call_tail */
uint32_t m47823e_release_surface_call_tail(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x20) != 0) (void)call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x20));
    if ((int16_t)rd16(self, 0x1c) != -1) (void)call1(host, 0x4d3992, 0, rd16(self, 0x1c));
    return call0(host, 0x4781fa, (uintptr_t)self);
}

/* ---- 0x478287 guard_set_table_flag ---- */
/* 0x478287, thiscall, plain `ret`, returns this (eax is this on every path): when the dword [self+0x157a] is non-zero and the signed word [self+0x1c] is not -1, stores the dword 1 at 0x5d15a5 + 0x4a * (signed word [self+0x1c]); the word is read again for the store (a signed 16-bit index, no bounds check). */
/* 0x478287 m478287_guard_set_table_flag */
uint8_t *m478287_guard_set_table_flag(uint8_t *self, const Fl38aWorld *world)
{
    if (rd32(self, 0x157a) != 0 && (int16_t)rd16(self, 0x1c) != -1)
        wr32(world->table_5d15a5, (ptrdiff_t)(int16_t)rd16(self, 0x1c) * 0x4a, 1);
    return self;
}

