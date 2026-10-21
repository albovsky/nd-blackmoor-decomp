#include "original_methods_fl36d.h"

#include <string.h>

#if defined(__GNUC__)
#define FL36_UNUSED __attribute__((unused))
#else
#define FL36_UNUSED
#endif

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

/* ---- 0x401100 scalar_deleting_dtor ---- */
/* 0x401100, thiscall, `ret 4`, returns this: 0x401032(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x401100 m401100_scalar_deleting_dtor */
uint8_t *m401100_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x401032, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x401190 scalar_deleting_dtor ---- */
/* 0x401190, thiscall, `ret 4`, returns this: 0x521756(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x401190 m401190_scalar_deleting_dtor */
uint8_t *m401190_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x521756, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x401c40 scalar_deleting_dtor ---- */
/* 0x401c40, thiscall, `ret 4`, returns this: 0x4014f5(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x401c40 m401c40_scalar_deleting_dtor */
uint8_t *m401c40_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4014f5, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x403010 scalar_deleting_dtor ---- */
/* 0x403010, thiscall, `ret 4`, returns this: 0x401c70(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x403010 m403010_scalar_deleting_dtor */
uint8_t *m403010_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x401c70, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x404a20 scalar_deleting_dtor ---- */
/* 0x404a20, thiscall, `ret 4`, returns this: 0x403229(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x404a20 m404a20_scalar_deleting_dtor */
uint8_t *m404a20_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x403229, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x407b10 scalar_deleting_dtor ---- */
/* 0x407b10, thiscall, `ret 4`, returns this: 0x404af0(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x407b10 m407b10_scalar_deleting_dtor */
uint8_t *m407b10_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x404af0, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x408980 scalar_deleting_dtor ---- */
/* 0x408980, thiscall, `ret 4`, returns this: 0x407c29(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x408980 m408980_scalar_deleting_dtor */
uint8_t *m408980_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x407c29, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x40b2a0 scalar_deleting_dtor ---- */
/* 0x40b2a0, thiscall, `ret 4`, returns this: 0x408d49(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x40b2a0 m40b2a0_scalar_deleting_dtor */
uint8_t *m40b2a0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x408d49, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x414490 scalar_deleting_dtor ---- */
/* 0x414490, thiscall, `ret 4`, returns this: 0x4110d7(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x414490 m414490_scalar_deleting_dtor */
uint8_t *m414490_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4110d7, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x414c80 scalar_deleting_dtor ---- */
/* 0x414c80, thiscall, `ret 4`, returns this: 0x41458b(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x414c80 m414c80_scalar_deleting_dtor */
uint8_t *m414c80_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x41458b, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x416e60 scalar_deleting_dtor ---- */
/* 0x416e60, thiscall, `ret 4`, returns this: 0x414ccf(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x416e60 m416e60_scalar_deleting_dtor */
uint8_t *m416e60_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x414ccf, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x41a480 scalar_deleting_dtor ---- */
/* 0x41a480, thiscall, `ret 4`, returns this: 0x416f2d(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x41a480 m41a480_scalar_deleting_dtor */
uint8_t *m41a480_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x416f2d, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x422fb0 scalar_deleting_dtor ---- */
/* 0x422fb0, thiscall, `ret 4`, returns this: 0x41bebc(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x422fb0 m422fb0_scalar_deleting_dtor */
uint8_t *m422fb0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x41bebc, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x425f70 scalar_deleting_dtor ---- */
/* 0x425f70, thiscall, `ret 4`, returns this: 0x423467(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x425f70 m425f70_scalar_deleting_dtor */
uint8_t *m425f70_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x423467, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4273f0 scalar_deleting_dtor ---- */
/* 0x4273f0, thiscall, `ret 4`, returns this: 0x427420(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4273f0 m4273f0_scalar_deleting_dtor */
uint8_t *m4273f0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x427420, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x434880 scalar_deleting_dtor ---- */
/* 0x434880, thiscall, `ret 4`, returns this: 0x433e63(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x434880 m434880_scalar_deleting_dtor */
uint8_t *m434880_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x433e63, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x438120 scalar_deleting_dtor ---- */
/* 0x438120, thiscall, `ret 4`, returns this: 0x43772f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x438120 m438120_scalar_deleting_dtor */
uint8_t *m438120_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x43772f, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x43eed0 scalar_deleting_dtor ---- */
/* 0x43eed0, thiscall, `ret 4`, returns this: 0x43eb59(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x43eed0 m43eed0_scalar_deleting_dtor */
uint8_t *m43eed0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x43eb59, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x43f1e0 scalar_deleting_dtor ---- */
/* 0x43f1e0, thiscall, `ret 4`, returns this: 0x43ef27(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x43f1e0 m43f1e0_scalar_deleting_dtor */
uint8_t *m43f1e0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x43ef27, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x446ed0 scalar_deleting_dtor ---- */
/* 0x446ed0, thiscall, `ret 4`, returns this: 0x445e0f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x446ed0 m446ed0_scalar_deleting_dtor */
uint8_t *m446ed0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x445e0f, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x447ce0 scalar_deleting_dtor ---- */
/* 0x447ce0, thiscall, `ret 4`, returns this: 0x446faa(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x447ce0 m447ce0_scalar_deleting_dtor */
uint8_t *m447ce0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x446faa, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x447d80 scalar_deleting_dtor ---- */
/* 0x447d80, thiscall, `ret 4`, returns this: 0x447d2f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x447d80 m447d80_scalar_deleting_dtor */
uint8_t *m447d80_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x447d2f, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4487f0 scalar_deleting_dtor ---- */
/* 0x4487f0, thiscall, `ret 4`, returns this: 0x447e46(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4487f0 m4487f0_scalar_deleting_dtor */
uint8_t *m4487f0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x447e46, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x449770 scalar_deleting_dtor ---- */
/* 0x449770, thiscall, `ret 4`, returns this: 0x44883f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x449770 m449770_scalar_deleting_dtor */
uint8_t *m449770_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x44883f, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x449d60 scalar_deleting_dtor ---- */
/* 0x449d60, thiscall, `ret 4`, returns this: 0x449a78(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x449d60 m449d60_scalar_deleting_dtor */
uint8_t *m449d60_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x449a78, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x44be60 scalar_deleting_dtor ---- */
/* 0x44be60, thiscall, `ret 4`, returns this: 0x44afd6(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x44be60 m44be60_scalar_deleting_dtor */
uint8_t *m44be60_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x44afd6, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x44c2b0 scalar_deleting_dtor ---- */
/* 0x44c2b0, thiscall, `ret 4`, returns this: 0x44bea7(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x44c2b0 m44c2b0_scalar_deleting_dtor */
uint8_t *m44c2b0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x44bea7, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x44e650 scalar_deleting_dtor ---- */
/* 0x44e650, thiscall, `ret 4`, returns this: 0x44d0eb(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x44e650 m44e650_scalar_deleting_dtor */
uint8_t *m44e650_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x44d0eb, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x44f620 scalar_deleting_dtor ---- */
/* 0x44f620, thiscall, `ret 4`, returns this: 0x44e74b(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x44f620 m44f620_scalar_deleting_dtor */
uint8_t *m44f620_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x44e74b, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x454c70 scalar_deleting_dtor ---- */
/* 0x454c70, thiscall, `ret 4`, returns this: 0x44f66f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x454c70 m454c70_scalar_deleting_dtor */
uint8_t *m454c70_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x44f66f, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x456bf0 scalar_deleting_dtor ---- */
/* 0x456bf0, thiscall, `ret 4`, returns this: 0x454d6e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x456bf0 m456bf0_scalar_deleting_dtor */
uint8_t *m456bf0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x454d6e, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x457e60 scalar_deleting_dtor ---- */
/* 0x457e60, thiscall, `ret 4`, returns this: 0x456ceb(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x457e60 m457e60_scalar_deleting_dtor */
uint8_t *m457e60_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x456ceb, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4599d0 scalar_deleting_dtor ---- */
/* 0x4599d0, thiscall, `ret 4`, returns this: 0x457f5e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4599d0 m4599d0_scalar_deleting_dtor */
uint8_t *m4599d0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x457f5e, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x45b2d0 scalar_deleting_dtor ---- */
/* 0x45b2d0, thiscall, `ret 4`, returns this: 0x459ace(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x45b2d0 m45b2d0_scalar_deleting_dtor */
uint8_t *m45b2d0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x459ace, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x45db70 scalar_deleting_dtor ---- */
/* 0x45db70, thiscall, `ret 4`, returns this: 0x45b3ce(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x45db70 m45db70_scalar_deleting_dtor */
uint8_t *m45db70_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x45b3ce, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x461710 scalar_deleting_dtor ---- */
/* 0x461710, thiscall, `ret 4`, returns this: 0x45dc6e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x461710 m461710_scalar_deleting_dtor */
uint8_t *m461710_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x45dc6e, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x463f00 scalar_deleting_dtor ---- */
/* 0x463f00, thiscall, `ret 4`, returns this: 0x46180b(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x463f00 m463f00_scalar_deleting_dtor */
uint8_t *m463f00_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x46180b, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4659f0 scalar_deleting_dtor ---- */
/* 0x4659f0, thiscall, `ret 4`, returns this: 0x463ffe(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4659f0 m4659f0_scalar_deleting_dtor */
uint8_t *m4659f0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x463ffe, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4674b0 scalar_deleting_dtor ---- */
/* 0x4674b0, thiscall, `ret 4`, returns this: 0x465aeb(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4674b0 m4674b0_scalar_deleting_dtor */
uint8_t *m4674b0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x465aeb, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x468d40 scalar_deleting_dtor ---- */
/* 0x468d40, thiscall, `ret 4`, returns this: 0x4674ff(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x468d40 m468d40_scalar_deleting_dtor */
uint8_t *m468d40_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4674ff, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x46b470 scalar_deleting_dtor ---- */
/* 0x46b470, thiscall, `ret 4`, returns this: 0x468e3e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x46b470 m46b470_scalar_deleting_dtor */
uint8_t *m46b470_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x468e3e, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x46e550 scalar_deleting_dtor ---- */
/* 0x46e550, thiscall, `ret 4`, returns this: 0x46b56e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x46e550 m46e550_scalar_deleting_dtor */
uint8_t *m46e550_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x46b56e, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x470c60 scalar_deleting_dtor ---- */
/* 0x470c60, thiscall, `ret 4`, returns this: 0x46e66a(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x470c60 m470c60_scalar_deleting_dtor */
uint8_t *m470c60_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x46e66a, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x472ed0 scalar_deleting_dtor ---- */
/* 0x472ed0, thiscall, `ret 4`, returns this: 0x470d5e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x472ed0 m472ed0_scalar_deleting_dtor */
uint8_t *m472ed0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x470d5e, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4756c0 scalar_deleting_dtor ---- */
/* 0x4756c0, thiscall, `ret 4`, returns this: 0x472f95(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4756c0 m4756c0_scalar_deleting_dtor */
uint8_t *m4756c0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x472f95, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4780e0 scalar_deleting_dtor ---- */
/* 0x4780e0, thiscall, `ret 4`, returns this: 0x4757be(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4780e0 m4780e0_scalar_deleting_dtor */
uint8_t *m4780e0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4757be, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x47b1d0 scalar_deleting_dtor ---- */
/* 0x47b1d0, thiscall, `ret 4`, returns this: 0x4781de(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x47b1d0 m47b1d0_scalar_deleting_dtor */
uint8_t *m47b1d0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4781de, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x47d3e0 scalar_deleting_dtor ---- */
/* 0x47d3e0, thiscall, `ret 4`, returns this: 0x47b21f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x47d3e0 m47d3e0_scalar_deleting_dtor */
uint8_t *m47d3e0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x47b21f, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x47e140 scalar_deleting_dtor ---- */
/* 0x47e140, thiscall, `ret 4`, returns this: 0x47d4db(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x47e140 m47e140_scalar_deleting_dtor */
uint8_t *m47e140_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x47d4db, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x482060 scalar_deleting_dtor ---- */
/* 0x482060, thiscall, `ret 4`, returns this: 0x47e23e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x482060 m482060_scalar_deleting_dtor */
uint8_t *m482060_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x47e23e, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x483e50 scalar_deleting_dtor ---- */
/* 0x483e50, thiscall, `ret 4`, returns this: 0x48215e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x483e50 m483e50_scalar_deleting_dtor */
uint8_t *m483e50_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x48215e, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x487a00 scalar_deleting_dtor ---- */
/* 0x487a00, thiscall, `ret 4`, returns this: 0x483f4e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x487a00 m487a00_scalar_deleting_dtor */
uint8_t *m487a00_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x483f4e, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x488cc0 scalar_deleting_dtor ---- */
/* 0x488cc0, thiscall, `ret 4`, returns this: 0x487afe(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x488cc0 m488cc0_scalar_deleting_dtor */
uint8_t *m488cc0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x487afe, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x48a5f0 scalar_deleting_dtor ---- */
/* 0x48a5f0, thiscall, `ret 4`, returns this: 0x488d89(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x48a5f0 m48a5f0_scalar_deleting_dtor */
uint8_t *m48a5f0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x488d89, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x48ba00 scalar_deleting_dtor ---- */
/* 0x48ba00, thiscall, `ret 4`, returns this: 0x48a6ee(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x48ba00 m48ba00_scalar_deleting_dtor */
uint8_t *m48ba00_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x48a6ee, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x48cf50 scalar_deleting_dtor ---- */
/* 0x48cf50, thiscall, `ret 4`, returns this: 0x48bafb(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x48cf50 m48cf50_scalar_deleting_dtor */
uint8_t *m48cf50_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x48bafb, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x48e170 scalar_deleting_dtor ---- */
/* 0x48e170, thiscall, `ret 4`, returns this: 0x48d04b(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x48e170 m48e170_scalar_deleting_dtor */
uint8_t *m48e170_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x48d04b, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x490450 scalar_deleting_dtor ---- */
/* 0x490450, thiscall, `ret 4`, returns this: 0x48e26e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x490450 m490450_scalar_deleting_dtor */
uint8_t *m490450_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x48e26e, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x49c490 scalar_deleting_dtor ---- */
/* 0x49c490, thiscall, `ret 4`, returns this: 0x490547(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x49c490 m49c490_scalar_deleting_dtor */
uint8_t *m49c490_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x490547, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4a1b30 scalar_deleting_dtor ---- */
/* 0x4a1b30, thiscall, `ret 4`, returns this: 0x49c59f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4a1b30 m4a1b30_scalar_deleting_dtor */
uint8_t *m4a1b30_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x49c59f, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4a3670 scalar_deleting_dtor ---- */
/* 0x4a3670, thiscall, `ret 4`, returns this: 0x4a1c2b(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4a3670 m4a3670_scalar_deleting_dtor */
uint8_t *m4a3670_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4a1c2b, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4a6270 scalar_deleting_dtor ---- */
/* 0x4a6270, thiscall, `ret 4`, returns this: 0x4a376e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4a6270 m4a6270_scalar_deleting_dtor */
uint8_t *m4a6270_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4a376e, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4a7b60 scalar_deleting_dtor ---- */
/* 0x4a7b60, thiscall, `ret 4`, returns this: 0x4a636e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4a7b60 m4a7b60_scalar_deleting_dtor */
uint8_t *m4a7b60_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4a636e, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4a9e10 scalar_deleting_dtor ---- */
/* 0x4a9e10, thiscall, `ret 4`, returns this: 0x4a7c5e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4a9e10 m4a9e10_scalar_deleting_dtor */
uint8_t *m4a9e10_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4a7c5e, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4ab290 scalar_deleting_dtor ---- */
/* 0x4ab290, thiscall, `ret 4`, returns this: 0x4a9f0b(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4ab290 m4ab290_scalar_deleting_dtor */
uint8_t *m4ab290_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4a9f0b, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4ac7c0 scalar_deleting_dtor ---- */
/* 0x4ac7c0, thiscall, `ret 4`, returns this: 0x4ab38b(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4ac7c0 m4ac7c0_scalar_deleting_dtor */
uint8_t *m4ac7c0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4ab38b, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4afc20 scalar_deleting_dtor ---- */
/* 0x4afc20, thiscall, `ret 4`, returns this: 0x4ac8be(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4afc20 m4afc20_scalar_deleting_dtor */
uint8_t *m4afc20_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4ac8be, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4b3b40 scalar_deleting_dtor ---- */
/* 0x4b3b40, thiscall, `ret 4`, returns this: 0x4afd1e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4b3b40 m4b3b40_scalar_deleting_dtor */
uint8_t *m4b3b40_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4afd1e, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4b5a70 scalar_deleting_dtor ---- */
/* 0x4b5a70, thiscall, `ret 4`, returns this: 0x4b3c3e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4b5a70 m4b5a70_scalar_deleting_dtor */
uint8_t *m4b5a70_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4b3c3e, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4b70e0 scalar_deleting_dtor ---- */
/* 0x4b70e0, thiscall, `ret 4`, returns this: 0x4b5b6e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4b70e0 m4b70e0_scalar_deleting_dtor */
uint8_t *m4b70e0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4b5b6e, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4b7ed0 scalar_deleting_dtor ---- */
/* 0x4b7ed0, thiscall, `ret 4`, returns this: 0x4b71db(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4b7ed0 m4b7ed0_scalar_deleting_dtor */
uint8_t *m4b7ed0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4b71db, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4b9dd0 scalar_deleting_dtor ---- */
/* 0x4b9dd0, thiscall, `ret 4`, returns this: 0x4b7f1f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4b9dd0 m4b9dd0_scalar_deleting_dtor */
uint8_t *m4b9dd0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4b7f1f, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4bed40 scalar_deleting_dtor ---- */
/* 0x4bed40, thiscall, `ret 4`, returns this: 0x4b9e1f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4bed40 m4bed40_scalar_deleting_dtor */
uint8_t *m4bed40_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4b9e1f, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4bf5d0 scalar_deleting_dtor ---- */
/* 0x4bf5d0, thiscall, `ret 4`, returns this: 0x4bed99(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4bf5d0 m4bf5d0_scalar_deleting_dtor */
uint8_t *m4bf5d0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4bed99, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4c0f30 scalar_deleting_dtor ---- */
/* 0x4c0f30, thiscall, `ret 4`, returns this: 0x4bf61f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4c0f30 m4c0f30_scalar_deleting_dtor */
uint8_t *m4c0f30_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4bf61f, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4cae90 scalar_deleting_dtor ---- */
/* 0x4cae90, thiscall, `ret 4`, returns this: 0x4c139a(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4cae90 m4cae90_scalar_deleting_dtor */
uint8_t *m4cae90_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4c139a, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4cc880 scalar_deleting_dtor ---- */
/* 0x4cc880, thiscall, `ret 4`, returns this: 0x4caeef(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4cc880 m4cc880_scalar_deleting_dtor */
uint8_t *m4cc880_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4caeef, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4ccd40 scalar_deleting_dtor ---- */
/* 0x4ccd40, thiscall, `ret 4`, returns this: 0x4cc946(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4ccd40 m4ccd40_scalar_deleting_dtor */
uint8_t *m4ccd40_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4cc946, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4cf7b0 scalar_deleting_dtor ---- */
/* 0x4cf7b0, thiscall, `ret 4`, returns this: 0x4ccd8f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4cf7b0 m4cf7b0_scalar_deleting_dtor */
uint8_t *m4cf7b0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4ccd8f, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4d42b0 scalar_deleting_dtor ---- */
/* 0x4d42b0, thiscall, `ret 4`, returns this: 0x4d3b6e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4d42b0 m4d42b0_scalar_deleting_dtor */
uint8_t *m4d42b0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4d3b6e, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4d5230 scalar_deleting_dtor ---- */
/* 0x4d5230, thiscall, `ret 4`, returns this: 0x44af20(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4d5230 m4d5230_scalar_deleting_dtor */
uint8_t *m4d5230_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x44af20, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4d5880 scalar_deleting_dtor ---- */
/* 0x4d5880, thiscall, `ret 4`, returns this: 0x4d527f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4d5880 m4d5880_scalar_deleting_dtor */
uint8_t *m4d5880_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4d527f, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4d9d40 scalar_deleting_dtor ---- */
/* 0x4d9d40, thiscall, `ret 4`, returns this: 0x4d58cf(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4d9d40 m4d9d40_scalar_deleting_dtor */
uint8_t *m4d9d40_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4d58cf, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4dbca0 scalar_deleting_dtor ---- */
/* 0x4dbca0, thiscall, `ret 4`, returns this: 0x4db27f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4dbca0 m4dbca0_scalar_deleting_dtor */
uint8_t *m4dbca0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4db27f, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4dd380 scalar_deleting_dtor ---- */
/* 0x4dd380, thiscall, `ret 4`, returns this: 0x4dbf6e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4dd380 m4dd380_scalar_deleting_dtor */
uint8_t *m4dd380_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4dbf6e, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4de120 scalar_deleting_dtor ---- */
/* 0x4de120, thiscall, `ret 4`, returns this: 0x4dd3cf(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4de120 m4de120_scalar_deleting_dtor */
uint8_t *m4de120_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4dd3cf, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4de5c0 scalar_deleting_dtor ---- */
/* 0x4de5c0, thiscall, `ret 4`, returns this: 0x4de1a4(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4de5c0 m4de5c0_scalar_deleting_dtor */
uint8_t *m4de5c0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4de1a4, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4e03e0 scalar_deleting_dtor ---- */
/* 0x4e03e0, thiscall, `ret 4`, returns this: 0x4de66e(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4e03e0 m4e03e0_scalar_deleting_dtor */
uint8_t *m4e03e0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4de66e, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4e1c20 scalar_deleting_dtor ---- */
/* 0x4e1c20, thiscall, `ret 4`, returns this: 0x4e048f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4e1c20 m4e1c20_scalar_deleting_dtor */
uint8_t *m4e1c20_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4e048f, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4e2cb0 scalar_deleting_dtor ---- */
/* 0x4e2cb0, thiscall, `ret 4`, returns this: 0x4e1c83(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4e2cb0 m4e2cb0_scalar_deleting_dtor */
uint8_t *m4e2cb0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4e1c83, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4e7600 scalar_deleting_dtor ---- */
/* 0x4e7600, thiscall, `ret 4`, returns this: 0x4e2d63(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4e7600 m4e7600_scalar_deleting_dtor */
uint8_t *m4e7600_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4e2d63, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4e7a40 scalar_deleting_dtor ---- */
/* 0x4e7a40, thiscall, `ret 4`, returns this: 0x4e7684(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4e7a40 m4e7a40_scalar_deleting_dtor */
uint8_t *m4e7a40_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4e7684, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4eb840 scalar_deleting_dtor ---- */
/* 0x4eb840, thiscall, `ret 4`, returns this: 0x4e7b37(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4eb840 m4eb840_scalar_deleting_dtor */
uint8_t *m4eb840_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4e7b37, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4ed9e0 scalar_deleting_dtor ---- */
/* 0x4ed9e0, thiscall, `ret 4`, returns this: 0x4eb8fe(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4ed9e0 m4ed9e0_scalar_deleting_dtor */
uint8_t *m4ed9e0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4eb8fe, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4ee950 scalar_deleting_dtor ---- */
/* 0x4ee950, thiscall, `ret 4`, returns this: 0x4eda7c(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4ee950 m4ee950_scalar_deleting_dtor */
uint8_t *m4ee950_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4eda7c, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4effd0 scalar_deleting_dtor ---- */
/* 0x4effd0, thiscall, `ret 4`, returns this: 0x4ee99f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4effd0 m4effd0_scalar_deleting_dtor */
uint8_t *m4effd0_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4ee99f, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

/* ---- 0x4f2610 scalar_deleting_dtor ---- */
/* 0x4f2610, thiscall, `ret 4`, returns this: 0x4f001f(this) (thiscall, no arguments), then, only when bit 0 of the stack argument is set, 0x51dc6c(this) (cdecl, one argument, caller pops). */
/* 0x4f2610 m4f2610_scalar_deleting_dtor */
uint8_t *m4f2610_scalar_deleting_dtor(uint8_t *self, uint32_t flags, const Fl18Host *host)
{
    (void)call0(host, 0x4f001f, (uintptr_t)self);
    if ((flags & 1u) != 0) (void)call1(host, 0x51dc6c, 0, (uintptr_t)self);
    return self;
}

