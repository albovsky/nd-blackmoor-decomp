#include "original_methods_fl39a.h"

#include <limits.h>
#include <string.h>

#if defined(__GNUC__)
#define FL39_UNUSED __attribute__((unused))
#else
#define FL39_UNUSED
#endif

FL39_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL39_UNUSED static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL39_UNUSED static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

FL39_UNUSED static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL39_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* host memory behind an original address (writable: the host owns the memory; the interface only says const) */
FL39_UNUSED static uint8_t *res(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

FL39_UNUSED static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

FL39_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

FL39_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

FL39_UNUSED static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    const uintptr_t a[2] = {a0, a1};
    return callv(host, callee, this_ptr, a, 2);
}

FL39_UNUSED static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    const uintptr_t a[3] = {a0, a1, a2};
    return callv(host, callee, this_ptr, a, 3);
}

FL39_UNUSED static uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3)
{
    const uintptr_t a[4] = {a0, a1, a2, a3};
    return callv(host, callee, this_ptr, a, 4);
}

/* ---- 0x48220e mark_entry ---- */
/* 0x48220e, thiscall, plain `ret`: when byte [self+0xa8] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m48220e_mark_entry(const uint8_t *self, const Fl39aWorld *world)
{
    int32_t i;
    if (self[0xa8] == 0) return;
    if (rds16(self, 0x1c) == -1) return;
    i = rds16(self, 0x1c);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x487b4f release_entry ---- */
/* 0x487b4f, thiscall, plain `ret`, returns the eax of the last callee: when dword [self+0x20] != 0, 0x4c2dfb(this = 0x5cf659) with the stack argument self + 0x20 (thiscall, one argument); when the signed word [self+0x1c] != -1, 0x4d3992(word) (cdecl, one argument pushed from edx, whose upper half is left-over: the callee reads a word); then 0x487b1a(this self) (thiscall, no arguments). */
uint32_t m487b4f_release_entry(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x20) != 0) (void)call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x20));
    if (rds16(self, 0x1c) != -1) (void)call1(host, 0x4d3992, 0, (uintptr_t)rd16(self, 0x1c));
    return call0(host, 0x487b1a, (uintptr_t)self);
}

/* ---- 0x487b98 mark_entry ---- */
/* 0x487b98, thiscall, plain `ret`: when dword [self+0x71] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m487b98_mark_entry(const uint8_t *self, const Fl39aWorld *world)
{
    int32_t i;
    if (rd32(self, 0x71) == 0) return;
    if (rds16(self, 0x1c) == -1) return;
    i = rds16(self, 0x1c);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x48a7e5 release_entry ---- */
/* 0x48a7e5, thiscall, plain `ret`, returns the eax of the last callee: when dword [self+0x20] != 0, 0x4c2dfb(this = 0x5cf659) with the stack argument self + 0x20 (thiscall, one argument); when the signed word [self+0x1c] != -1, 0x4d3992(word) (cdecl, one argument pushed from edx, whose upper half is left-over: the callee reads a word); then 0x48a70a(this self) (thiscall, no arguments). */
uint32_t m48a7e5_release_entry(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x20) != 0) (void)call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x20));
    if (rds16(self, 0x1c) != -1) (void)call1(host, 0x4d3992, 0, (uintptr_t)rd16(self, 0x1c));
    return call0(host, 0x48a70a, (uintptr_t)self);
}

/* ---- 0x48a82e mark_entry ---- */
/* 0x48a82e, thiscall, plain `ret`: when dword [self+0x1aa] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m48a82e_mark_entry(const uint8_t *self, const Fl39aWorld *world)
{
    int32_t i;
    if (rd32(self, 0x1aa) == 0) return;
    if (rds16(self, 0x1c) == -1) return;
    i = rds16(self, 0x1c);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x48e393 mark_entry ---- */
/* 0x48e393, thiscall, plain `ret`: when dword [self+0x462] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m48e393_mark_entry(const uint8_t *self, const Fl39aWorld *world)
{
    int32_t i;
    if (rd32(self, 0x462) == 0) return;
    if (rds16(self, 0x1c) == -1) return;
    i = rds16(self, 0x1c);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x490547 destroy_with_frame ---- */
/* 0x490547, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52daf8u at [this], then 0x490d50(this) and 0x51d730(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52852d) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m490547_destroy_with_frame(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52daf8u);
    (void)call0(host, 0x490d50, (uintptr_t)self);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x493a10 mark_entry ---- */
/* 0x493a10, thiscall, plain `ret`: when dword [self+0x1f77] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m493a10_mark_entry(const uint8_t *self, const Fl39aWorld *world)
{
    int32_t i;
    if (rd32(self, 0x1f77) == 0) return;
    if (rds16(self, 0x1c) == -1) return;
    i = rds16(self, 0x1c);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x49c59f destroy_with_frame ---- */
/* 0x49c59f, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52dbc8u at [this], then 0x49c68a(this) and 0x51d730(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x528570) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m49c59f_destroy_with_frame(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52dbc8u);
    (void)call0(host, 0x49c68a, (uintptr_t)self);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x4a1ce0 mark_entry ---- */
/* 0x4a1ce0, thiscall, plain `ret`: when dword [self+0x60] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4a1ce0_mark_entry(const uint8_t *self, const Fl39aWorld *world)
{
    int32_t i;
    if (rd32(self, 0x60) == 0) return;
    if (rds16(self, 0x1c) == -1) return;
    i = rds16(self, 0x1c);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x4a3910 mark_entry ---- */
/* 0x4a3910, thiscall, plain `ret`: when dword [self+0x26e] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4a3910_mark_entry(const uint8_t *self, const Fl39aWorld *world)
{
    int32_t i;
    if (rd32(self, 0x26e) == 0) return;
    if (rds16(self, 0x1c) == -1) return;
    i = rds16(self, 0x1c);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x4a6477 mark_entry ---- */
/* 0x4a6477, thiscall, plain `ret`: when dword [self+0x86] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4a6477_mark_entry(const uint8_t *self, const Fl39aWorld *world)
{
    int32_t i;
    if (rd32(self, 0x86) == 0) return;
    if (rds16(self, 0x1c) == -1) return;
    i = rds16(self, 0x1c);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x4a7da5 mark_entry ---- */
/* 0x4a7da5, thiscall, plain `ret`: when dword [self+0xe72] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4a7da5_mark_entry(const uint8_t *self, const Fl39aWorld *world)
{
    int32_t i;
    if (rd32(self, 0xe72) == 0) return;
    if (rds16(self, 0x1c) == -1) return;
    i = rds16(self, 0x1c);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x4a9fcb mark_entry ---- */
/* 0x4a9fcb, thiscall, plain `ret`: when byte [self+0x45] == 0 nothing. Otherwise i = signed word [self+0x29]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4a9fcb_mark_entry(const uint8_t *self, const Fl39aWorld *world)
{
    int32_t i;
    if (self[0x45] == 0) return;
    if (rds16(self, 0x29) == -1) return;
    i = rds16(self, 0x29);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x4ab3dc release_entry ---- */
/* 0x4ab3dc, thiscall, plain `ret`, returns the eax of the last callee: when dword [self+0x20] != 0, 0x4c2dfb(this = 0x5cf659) with the stack argument self + 0x20 (thiscall, one argument); when the signed word [self+0x1c] != -1, 0x4d3992(word) (cdecl, one argument pushed from edx, whose upper half is left-over: the callee reads a word); then 0x4ab3a7(this self) (thiscall, no arguments). */
uint32_t m4ab3dc_release_entry(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x20) != 0) (void)call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x20));
    if (rds16(self, 0x1c) != -1) (void)call1(host, 0x4d3992, 0, (uintptr_t)rd16(self, 0x1c));
    return call0(host, 0x4ab3a7, (uintptr_t)self);
}

/* ---- 0x4ab425 mark_entry ---- */
/* 0x4ab425, thiscall, plain `ret`: when dword [self+0x54] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4ab425_mark_entry(const uint8_t *self, const Fl39aWorld *world)
{
    int32_t i;
    if (rd32(self, 0x54) == 0) return;
    if (rds16(self, 0x1c) == -1) return;
    i = rds16(self, 0x1c);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x4acbba mark_entry ---- */
/* 0x4acbba, thiscall, plain `ret`: when dword [self+0xc1b] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4acbba_mark_entry(const uint8_t *self, const Fl39aWorld *world)
{
    int32_t i;
    if (rd32(self, 0xc1b) == 0) return;
    if (rds16(self, 0x1c) == -1) return;
    i = rds16(self, 0x1c);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x4afd7e release_entry ---- */
/* 0x4afd7e, thiscall, plain `ret`, returns the eax of the last callee: when dword [self+0x20] != 0, 0x4c2dfb(this = 0x5cf659) with the stack argument self + 0x20 (thiscall, one argument); when the signed word [self+0x1c] != -1, 0x4d3992(word) (cdecl, one argument pushed from edx, whose upper half is left-over: the callee reads a word); then 0x4afd3a(this self) (thiscall, no arguments). */
uint32_t m4afd7e_release_entry(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x20) != 0) (void)call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x20));
    if (rds16(self, 0x1c) != -1) (void)call1(host, 0x4d3992, 0, (uintptr_t)rd16(self, 0x1c));
    return call0(host, 0x4afd3a, (uintptr_t)self);
}

/* ---- 0x4afdc7 mark_entry ---- */
/* 0x4afdc7, thiscall, plain `ret`: when dword [self+0x1515] == 0 nothing. Otherwise i = signed word [self+0x1c]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4afdc7_mark_entry(const uint8_t *self, const Fl39aWorld *world)
{
    int32_t i;
    if (rd32(self, 0x1515) == 0) return;
    if (rds16(self, 0x1c) == -1) return;
    i = rds16(self, 0x1c);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x4b3d4d release_entry ---- */
/* 0x4b3d4d, thiscall, plain `ret`, returns the eax of the last callee: when dword [self+0x754] != 0, 0x4c2dfb(this = 0x5cf659) with the stack argument self + 0x754 (thiscall, one argument); when the signed word [self+0x726] != -1, 0x4d3992(word) (cdecl, one argument pushed from edx, whose upper half is left-over: the callee reads a word); then 0x4b3c5a(this self) (thiscall, no arguments). */
uint32_t m4b3d4d_release_entry(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x754) != 0) (void)call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x754));
    if (rds16(self, 0x726) != -1) (void)call1(host, 0x4d3992, 0, (uintptr_t)rd16(self, 0x726));
    return call0(host, 0x4b3c5a, (uintptr_t)self);
}

/* ---- 0x4b3da2 mark_entry ---- */
/* 0x4b3da2, thiscall, plain `ret`: when dword [self+0x76e] == 0 nothing. Otherwise i = signed word [self+0x726]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4b3da2_mark_entry(const uint8_t *self, const Fl39aWorld *world)
{
    int32_t i;
    if (rd32(self, 0x76e) == 0) return;
    if (rds16(self, 0x726) == -1) return;
    i = rds16(self, 0x726);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x4b7229 release_entry ---- */
/* 0x4b7229, thiscall, plain `ret`, returns the eax of the last callee: when dword [self+0x1d] != 0, 0x4c2dfb(this = 0x5cf659) with the stack argument self + 0x1d (thiscall, one argument); when the signed word [self+0x2f] != -1, 0x4d3992(word) (cdecl, one argument pushed from edx, whose upper half is left-over: the callee reads a word); then 0x4b71f7(this self) (thiscall, no arguments). */
uint32_t m4b7229_release_entry(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x1d) != 0) (void)call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x1d));
    if (rds16(self, 0x2f) != -1) (void)call1(host, 0x4d3992, 0, (uintptr_t)rd16(self, 0x2f));
    return call0(host, 0x4b71f7, (uintptr_t)self);
}

/* ---- 0x4b7272 mark_entry ---- */
/* 0x4b7272, thiscall, plain `ret`: when byte [self+0x35] == 0 nothing. Otherwise i = signed word [self+0x2f]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4b7272_mark_entry(const uint8_t *self, const Fl39aWorld *world)
{
    int32_t i;
    if (self[0x35] == 0) return;
    if (rds16(self, 0x2f) == -1) return;
    i = rds16(self, 0x2f);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x4ba22e mark_entry ---- */
/* 0x4ba22e, thiscall, plain `ret`: when dword [self+0x34] == 0 nothing. Otherwise i = signed word [self+0x4]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4ba22e_mark_entry(const uint8_t *self, const Fl39aWorld *world)
{
    int32_t i;
    if (rd32(self, 0x34) == 0) return;
    if (rds16(self, 0x4) == -1) return;
    i = rds16(self, 0x4);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x4cafc1 mark_entry ---- */
/* 0x4cafc1, thiscall, plain `ret`: when dword [self+0xe] == 0 nothing. Otherwise i = signed word [self+0xc]; when i == -1 nothing, else dword [0x5d15a5 + i*0x4a] = 1. */
void m4cafc1_mark_entry(const uint8_t *self, const Fl39aWorld *world)
{
    int32_t i;
    if (rd32(self, 0xe) == 0) return;
    if (rds16(self, 0xc) == -1) return;
    i = rds16(self, 0xc);
    wr32(world->table_5d15a5, (ptrdiff_t)i * 0x4a, 1);
}

/* ---- 0x4dbf6e destroy_with_frame ---- */
/* 0x4dbf6e, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52e478u at [this], then 0x4dc043(this) and 0x51d730(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5288b0) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m4dbf6e_destroy_with_frame(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e478u);
    (void)call0(host, 0x4dc043, (uintptr_t)self);
    return call0(host, 0x51d730, (uintptr_t)self);
}

/* ---- 0x4de1a4 destroy_with_frame ---- */
/* 0x4de1a4, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52e4ccu at [this], then 0x4de214(this) and 0x4eda7c(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5288ec) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m4de1a4_destroy_with_frame(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e4ccu);
    (void)call0(host, 0x4de214, (uintptr_t)self);
    return call0(host, 0x4eda7c, (uintptr_t)self);
}

/* ---- 0x4e7684 destroy_with_frame ---- */
/* 0x4e7684, thiscall, plain `ret`, returns the eax of the last callee: stores the dword 0x52e4f0u at [this], then 0x4e76ed(this) and 0x4eda7c(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x528a1c) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint32_t m4e7684_destroy_with_frame(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0, 0x52e4f0u);
    (void)call0(host, 0x4e76ed, (uintptr_t)self);
    return call0(host, 0x4eda7c, (uintptr_t)self);
}
