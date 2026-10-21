#include "original_methods_fl36f.h"

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

/* ---- 0x401420 new_and_construct ---- */
/* 0x401420, plain `ret`, returns the new object or 0: p = 0x51dc43(0x8c) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x40149a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x526aca) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x401420 m401420_new_and_construct */
uint32_t m401420_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x8c);
    return p != 0 ? call0(host, 0x40149a, (uintptr_t)p) : 0;
}

/* ---- 0x403040 new_and_construct ---- */
/* 0x403040, plain `ret`, returns the new object or 0: p = 0x51dc43(0x4b4) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4030ba(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x526b2a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x403040 m403040_new_and_construct */
uint32_t m403040_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x4b4);
    return p != 0 ? call0(host, 0x4030ba, (uintptr_t)p) : 0;
}

/* ---- 0x404a50 new_and_construct ---- */
/* 0x404a50, plain `ret`, returns the new object or 0: p = 0x51dc43(0xde0) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x404aca(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x526d2a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x404a50 m404a50_new_and_construct */
uint32_t m404a50_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0xde0);
    return p != 0 ? call0(host, 0x404aca, (uintptr_t)p) : 0;
}

/* ---- 0x407b40 new_and_construct ---- */
/* 0x407b40, plain `ret`, returns the new object or 0: p = 0x51dc43(0x98c) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x407bba(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x526d4a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x407b40 m407b40_new_and_construct */
uint32_t m407b40_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x98c);
    return p != 0 ? call0(host, 0x407bba, (uintptr_t)p) : 0;
}

/* ---- 0x4089b0 new_and_construct ---- */
/* 0x4089b0, plain `ret`, returns the new object or 0: p = 0x51dc43(0xa8c) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x408a2a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x526d8a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4089b0 m4089b0_new_and_construct */
uint32_t m4089b0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0xa8c);
    return p != 0 ? call0(host, 0x408a2a, (uintptr_t)p) : 0;
}

/* ---- 0x4144c0 new_and_construct ---- */
/* 0x4144c0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x28) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x414537(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52728a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4144c0 m4144c0_new_and_construct */
uint32_t m4144c0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x28);
    return p != 0 ? call0(host, 0x414537, (uintptr_t)p) : 0;
}

/* ---- 0x414537 construct_base_set_vtable ---- */
/* 0x414537, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52c4f0u at [this], then 0x4145a7(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52729d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x414537 m414537_construct_base_set_vtable */
uint8_t *m414537_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52c4f0u);
    (void)call0(host, 0x4145a7, (uintptr_t)self);
    return self;
}

/* ---- 0x41bda0 new_and_construct ---- */
/* 0x41bda0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x20ef) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x41be1a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5272fa) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x41bda0 m41bda0_new_and_construct */
uint32_t m41bda0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x20ef);
    return p != 0 ? call0(host, 0x41be1a, (uintptr_t)p) : 0;
}

/* ---- 0x43eab0 new_and_construct ---- */
/* 0x43eab0, plain `ret`, returns the new object or 0: p = 0x51dc43(0xbc) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x43eb3a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x527eaa) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x43eab0 m43eab0_new_and_construct */
uint32_t m43eab0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0xbc);
    return p != 0 ? call0(host, 0x43eb3a, (uintptr_t)p) : 0;
}

/* ---- 0x446f00 new_and_construct ---- */
/* 0x446f00, plain `ret`, returns the new object or 0: p = 0x51dc43(0x5e) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x446f77(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x527eca) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x446f00 m446f00_new_and_construct */
uint32_t m446f00_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x5e);
    return p != 0 ? call0(host, 0x446f77, (uintptr_t)p) : 0;
}

/* ---- 0x447db0 new_and_construct ---- */
/* 0x447db0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x22) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x447e27(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x527efa) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x447db0 m447db0_new_and_construct */
uint32_t m447db0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x22);
    return p != 0 ? call0(host, 0x447e27, (uintptr_t)p) : 0;
}

/* ---- 0x44af40 new_and_construct ---- */
/* 0x44af40, plain `ret`, returns the new object or 0: p = 0x51dc43(0x1e) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x44afb7(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x527f7a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x44af40 m44af40_new_and_construct */
uint32_t m44af40_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x1e);
    return p != 0 ? call0(host, 0x44afb7, (uintptr_t)p) : 0;
}

/* ---- 0x44d020 new_and_construct ---- */
/* 0x44d020, plain `ret`, returns the new object or 0: p = 0x51dc43(0x53) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x44d097(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x527f9a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x44d020 m44d020_new_and_construct */
uint32_t m44d020_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x53);
    return p != 0 ? call0(host, 0x44d097, (uintptr_t)p) : 0;
}

/* ---- 0x44d097 construct_base_set_vtable ---- */
/* 0x44d097, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52cc38u at [this], then 0x44d107(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x527fad) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x44d097 m44d097_construct_base_set_vtable */
uint8_t *m44d097_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52cc38u);
    (void)call0(host, 0x44d107, (uintptr_t)self);
    return self;
}

/* ---- 0x44e680 new_and_construct ---- */
/* 0x44e680, plain `ret`, returns the new object or 0: p = 0x51dc43(0x6f) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x44e6f7(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x527fca) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x44e680 m44e680_new_and_construct */
uint32_t m44e680_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x6f);
    return p != 0 ? call0(host, 0x44e6f7, (uintptr_t)p) : 0;
}

/* ---- 0x44e6f7 construct_base_set_vtable ---- */
/* 0x44e6f7, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52ccc0u at [this], then 0x44e767(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x527fdd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x44e6f7 m44e6f7_construct_base_set_vtable */
uint8_t *m44e6f7_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52ccc0u);
    (void)call0(host, 0x44e767, (uintptr_t)self);
    return self;
}

/* ---- 0x454ca0 new_and_construct ---- */
/* 0x454ca0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x174) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x454d1a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x527ffa) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x454ca0 m454ca0_new_and_construct */
uint32_t m454ca0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x174);
    return p != 0 ? call0(host, 0x454d1a, (uintptr_t)p) : 0;
}

/* ---- 0x454d1a construct_base_set_vtable ---- */
/* 0x454d1a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52cd50u at [this], then 0x454d9e(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52800d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x454d1a m454d1a_construct_base_set_vtable */
uint8_t *m454d1a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52cd50u);
    (void)call0(host, 0x454d9e, (uintptr_t)self);
    return self;
}

/* ---- 0x456c20 new_and_construct ---- */
/* 0x456c20, plain `ret`, returns the new object or 0: p = 0x51dc43(0x44) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x456c97(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52802a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x456c20 m456c20_new_and_construct */
uint32_t m456c20_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x44);
    return p != 0 ? call0(host, 0x456c97, (uintptr_t)p) : 0;
}

/* ---- 0x456c97 construct_base_set_vtable ---- */
/* 0x456c97, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52cdd8u at [this], then 0x456d07(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52803d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x456c97 m456c97_construct_base_set_vtable */
uint8_t *m456c97_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52cdd8u);
    (void)call0(host, 0x456d07, (uintptr_t)self);
    return self;
}

/* ---- 0x457e90 new_and_construct ---- */
/* 0x457e90, plain `ret`, returns the new object or 0: p = 0x51dc43(0xf3) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x457f0a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52805a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x457e90 m457e90_new_and_construct */
uint32_t m457e90_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0xf3);
    return p != 0 ? call0(host, 0x457f0a, (uintptr_t)p) : 0;
}

/* ---- 0x457f0a construct_base_set_vtable ---- */
/* 0x457f0a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52ce60u at [this], then 0x457f7a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52806d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x457f0a m457f0a_construct_base_set_vtable */
uint8_t *m457f0a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52ce60u);
    (void)call0(host, 0x457f7a, (uintptr_t)self);
    return self;
}

/* ---- 0x459a00 new_and_construct ---- */
/* 0x459a00, plain `ret`, returns the new object or 0: p = 0x51dc43(0xe2) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x459a7a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52808a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x459a00 m459a00_new_and_construct */
uint32_t m459a00_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0xe2);
    return p != 0 ? call0(host, 0x459a7a, (uintptr_t)p) : 0;
}

/* ---- 0x459a7a construct_base_set_vtable ---- */
/* 0x459a7a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52cee8u at [this], then 0x459aea(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52809d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x459a7a m459a7a_construct_base_set_vtable */
uint8_t *m459a7a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52cee8u);
    (void)call0(host, 0x459aea, (uintptr_t)self);
    return self;
}

/* ---- 0x45b300 new_and_construct ---- */
/* 0x45b300, plain `ret`, returns the new object or 0: p = 0x51dc43(0x1b9) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x45b37a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5280ba) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x45b300 m45b300_new_and_construct */
uint32_t m45b300_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x1b9);
    return p != 0 ? call0(host, 0x45b37a, (uintptr_t)p) : 0;
}

/* ---- 0x45b37a construct_base_set_vtable ---- */
/* 0x45b37a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52cf70u at [this], then 0x45b3ea(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5280cd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x45b37a m45b37a_construct_base_set_vtable */
uint8_t *m45b37a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52cf70u);
    (void)call0(host, 0x45b3ea, (uintptr_t)self);
    return self;
}

/* ---- 0x45dba0 new_and_construct ---- */
/* 0x45dba0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x3af) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x45dc1a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5280ea) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x45dba0 m45dba0_new_and_construct */
uint32_t m45dba0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x3af);
    return p != 0 ? call0(host, 0x45dc1a, (uintptr_t)p) : 0;
}

/* ---- 0x45dc1a construct_base_set_vtable ---- */
/* 0x45dc1a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52cff8u at [this], then 0x45dc8a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5280fd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x45dc1a m45dc1a_construct_base_set_vtable */
uint8_t *m45dc1a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52cff8u);
    (void)call0(host, 0x45dc8a, (uintptr_t)self);
    return self;
}

/* ---- 0x461740 new_and_construct ---- */
/* 0x461740, plain `ret`, returns the new object or 0: p = 0x51dc43(0x5f) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4617b7(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52811a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x461740 m461740_new_and_construct */
uint32_t m461740_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x5f);
    return p != 0 ? call0(host, 0x4617b7, (uintptr_t)p) : 0;
}

/* ---- 0x4617b7 construct_base_set_vtable ---- */
/* 0x4617b7, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d080u at [this], then 0x461827(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52812d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4617b7 m4617b7_construct_base_set_vtable */
uint8_t *m4617b7_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52d080u);
    (void)call0(host, 0x461827, (uintptr_t)self);
    return self;
}

/* ---- 0x463f30 new_and_construct ---- */
/* 0x463f30, plain `ret`, returns the new object or 0: p = 0x51dc43(0xda) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x463faa(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52814a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x463f30 m463f30_new_and_construct */
uint32_t m463f30_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0xda);
    return p != 0 ? call0(host, 0x463faa, (uintptr_t)p) : 0;
}

/* ---- 0x463faa construct_base_set_vtable ---- */
/* 0x463faa, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d108u at [this], then 0x46402e(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52815d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x463faa m463faa_construct_base_set_vtable */
uint8_t *m463faa_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52d108u);
    (void)call0(host, 0x46402e, (uintptr_t)self);
    return self;
}

/* ---- 0x465a20 new_and_construct ---- */
/* 0x465a20, plain `ret`, returns the new object or 0: p = 0x51dc43(0x56) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x465a97(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52817a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x465a20 m465a20_new_and_construct */
uint32_t m465a20_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x56);
    return p != 0 ? call0(host, 0x465a97, (uintptr_t)p) : 0;
}

/* ---- 0x465a97 construct_base_set_vtable ---- */
/* 0x465a97, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d190u at [this], then 0x465b07(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52818d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x465a97 m465a97_construct_base_set_vtable */
uint8_t *m465a97_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52d190u);
    (void)call0(host, 0x465b07, (uintptr_t)self);
    return self;
}

/* ---- 0x468d70 new_and_construct ---- */
/* 0x468d70, plain `ret`, returns the new object or 0: p = 0x51dc43(0x5b4) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x468dea(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5281aa) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x468d70 m468d70_new_and_construct */
uint32_t m468d70_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x5b4);
    return p != 0 ? call0(host, 0x468dea, (uintptr_t)p) : 0;
}

/* ---- 0x468dea construct_base_set_vtable ---- */
/* 0x468dea, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d220u at [this], then 0x468e5a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5281bd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x468dea m468dea_construct_base_set_vtable */
uint8_t *m468dea_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52d220u);
    (void)call0(host, 0x468e5a, (uintptr_t)self);
    return self;
}

/* ---- 0x46b4a0 new_and_construct ---- */
/* 0x46b4a0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x8302) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x46b51a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5281da) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x46b4a0 m46b4a0_new_and_construct */
uint32_t m46b4a0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x8302);
    return p != 0 ? call0(host, 0x46b51a, (uintptr_t)p) : 0;
}

/* ---- 0x46b51a construct_base_set_vtable ---- */
/* 0x46b51a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d2e8u at [this], then 0x46b58a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5281ed) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x46b51a m46b51a_construct_base_set_vtable */
uint8_t *m46b51a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52d2e8u);
    (void)call0(host, 0x46b58a, (uintptr_t)self);
    return self;
}

/* ---- 0x46e580 new_and_construct ---- */
/* 0x46e580, plain `ret`, returns the new object or 0: p = 0x51dc43(0x95) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x46e5fa(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52820a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x46e580 m46e580_new_and_construct */
uint32_t m46e580_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x95);
    return p != 0 ? call0(host, 0x46e5fa, (uintptr_t)p) : 0;
}

/* ---- 0x470c90 new_and_construct ---- */
/* 0x470c90, plain `ret`, returns the new object or 0: p = 0x51dc43(0xe0a) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x470d0a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52827a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x470c90 m470c90_new_and_construct */
uint32_t m470c90_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0xe0a);
    return p != 0 ? call0(host, 0x470d0a, (uintptr_t)p) : 0;
}

/* ---- 0x470d0a construct_base_set_vtable ---- */
/* 0x470d0a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d3f8u at [this], then 0x470d7a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52828d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x470d0a m470d0a_construct_base_set_vtable */
uint8_t *m470d0a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52d3f8u);
    (void)call0(host, 0x470d7a, (uintptr_t)self);
    return self;
}

/* ---- 0x4756f0 new_and_construct ---- */
/* 0x4756f0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x8da) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x47576a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5282ca) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4756f0 m4756f0_new_and_construct */
uint32_t m4756f0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x8da);
    return p != 0 ? call0(host, 0x47576a, (uintptr_t)p) : 0;
}

/* ---- 0x47576a construct_base_set_vtable ---- */
/* 0x47576a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d490u at [this], then 0x4757da(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5282dd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x47576a m47576a_construct_base_set_vtable */
uint8_t *m47576a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52d490u);
    (void)call0(host, 0x4757da, (uintptr_t)self);
    return self;
}

/* ---- 0x478110 new_and_construct ---- */
/* 0x478110, plain `ret`, returns the new object or 0: p = 0x51dc43(0x15a0) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x47818a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5282fa) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x478110 m478110_new_and_construct */
uint32_t m478110_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x15a0);
    return p != 0 ? call0(host, 0x47818a, (uintptr_t)p) : 0;
}

/* ---- 0x47818a construct_base_set_vtable ---- */
/* 0x47818a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d518u at [this], then 0x4781fa(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52830d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x47818a m47818a_construct_base_set_vtable */
uint8_t *m47818a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52d518u);
    (void)call0(host, 0x4781fa, (uintptr_t)self);
    return self;
}

/* ---- 0x47d410 new_and_construct ---- */
/* 0x47d410, plain `ret`, returns the new object or 0: p = 0x51dc43(0x58) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x47d487(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52832a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x47d410 m47d410_new_and_construct */
uint32_t m47d410_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x58);
    return p != 0 ? call0(host, 0x47d487, (uintptr_t)p) : 0;
}

/* ---- 0x47d487 construct_base_set_vtable ---- */
/* 0x47d487, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d5a8u at [this], then 0x47d4f7(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52833d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x47d487 m47d487_construct_base_set_vtable */
uint8_t *m47d487_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52d5a8u);
    (void)call0(host, 0x47d4f7, (uintptr_t)self);
    return self;
}

/* ---- 0x47e170 new_and_construct ---- */
/* 0x47e170, plain `ret`, returns the new object or 0: p = 0x51dc43(0x144d) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x47e1ea(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52837a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x47e170 m47e170_new_and_construct */
uint32_t m47e170_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x144d);
    return p != 0 ? call0(host, 0x47e1ea, (uintptr_t)p) : 0;
}

/* ---- 0x47e1ea construct_base_set_vtable ---- */
/* 0x47e1ea, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d630u at [this], then 0x47e25a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52838d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x47e1ea m47e1ea_construct_base_set_vtable */
uint8_t *m47e1ea_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52d630u);
    (void)call0(host, 0x47e25a, (uintptr_t)self);
    return self;
}

/* ---- 0x482090 new_and_construct ---- */
/* 0x482090, plain `ret`, returns the new object or 0: p = 0x51dc43(0xb7) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x48210a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5283aa) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x482090 m482090_new_and_construct */
uint32_t m482090_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0xb7);
    return p != 0 ? call0(host, 0x48210a, (uintptr_t)p) : 0;
}

/* ---- 0x48210a construct_base_set_vtable ---- */
/* 0x48210a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d6b8u at [this], then 0x48217a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5283bd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x48210a m48210a_construct_base_set_vtable */
uint8_t *m48210a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52d6b8u);
    (void)call0(host, 0x48217a, (uintptr_t)self);
    return self;
}

/* ---- 0x483e80 new_and_construct ---- */
/* 0x483e80, plain `ret`, returns the new object or 0: p = 0x51dc43(0xc3b) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x483efa(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5283da) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x483e80 m483e80_new_and_construct */
uint32_t m483e80_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0xc3b);
    return p != 0 ? call0(host, 0x483efa, (uintptr_t)p) : 0;
}

/* ---- 0x483efa construct_base_set_vtable ---- */
/* 0x483efa, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d740u at [this], then 0x483f6a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5283ed) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x483efa m483efa_construct_base_set_vtable */
uint8_t *m483efa_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52d740u);
    (void)call0(host, 0x483f6a, (uintptr_t)self);
    return self;
}

/* ---- 0x487a30 new_and_construct ---- */
/* 0x487a30, plain `ret`, returns the new object or 0: p = 0x51dc43(0x9b) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x487aaa(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52840a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x487a30 m487a30_new_and_construct */
uint32_t m487a30_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x9b);
    return p != 0 ? call0(host, 0x487aaa, (uintptr_t)p) : 0;
}

/* ---- 0x487aaa construct_base_set_vtable ---- */
/* 0x487aaa, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d7c8u at [this], then 0x487b1a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52841d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x487aaa m487aaa_construct_base_set_vtable */
uint8_t *m487aaa_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52d7c8u);
    (void)call0(host, 0x487b1a, (uintptr_t)self);
    return self;
}

/* ---- 0x488cf0 new_and_construct ---- */
/* 0x488cf0, plain `ret`, returns the new object or 0: p = 0x51dc43(0xd0) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x488d6a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52843a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x488cf0 m488cf0_new_and_construct */
uint32_t m488cf0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0xd0);
    return p != 0 ? call0(host, 0x488d6a, (uintptr_t)p) : 0;
}

/* ---- 0x48a620 new_and_construct ---- */
/* 0x48a620, plain `ret`, returns the new object or 0: p = 0x51dc43(0x1ce) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x48a69a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52845a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x48a620 m48a620_new_and_construct */
uint32_t m48a620_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x1ce);
    return p != 0 ? call0(host, 0x48a69a, (uintptr_t)p) : 0;
}

/* ---- 0x48a69a construct_base_set_vtable ---- */
/* 0x48a69a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d8d8u at [this], then 0x48a70a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52846d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x48a69a m48a69a_construct_base_set_vtable */
uint8_t *m48a69a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52d8d8u);
    (void)call0(host, 0x48a70a, (uintptr_t)self);
    return self;
}

/* ---- 0x48ba30 new_and_construct ---- */
/* 0x48ba30, plain `ret`, returns the new object or 0: p = 0x51dc43(0x56) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x48baa7(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52848a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x48ba30 m48ba30_new_and_construct */
uint32_t m48ba30_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x56);
    return p != 0 ? call0(host, 0x48baa7, (uintptr_t)p) : 0;
}

/* ---- 0x48baa7 construct_base_set_vtable ---- */
/* 0x48baa7, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d960u at [this], then 0x48bb17(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52849d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x48baa7 m48baa7_construct_base_set_vtable */
uint8_t *m48baa7_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52d960u);
    (void)call0(host, 0x48bb17, (uintptr_t)self);
    return self;
}

/* ---- 0x48cf80 new_and_construct ---- */
/* 0x48cf80, plain `ret`, returns the new object or 0: p = 0x51dc43(0x5c) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x48cff7(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5284ba) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x48cf80 m48cf80_new_and_construct */
uint32_t m48cf80_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x5c);
    return p != 0 ? call0(host, 0x48cff7, (uintptr_t)p) : 0;
}

/* ---- 0x48cff7 construct_base_set_vtable ---- */
/* 0x48cff7, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52d9e8u at [this], then 0x48d067(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5284cd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x48cff7 m48cff7_construct_base_set_vtable */
uint8_t *m48cff7_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52d9e8u);
    (void)call0(host, 0x48d067, (uintptr_t)self);
    return self;
}

/* ---- 0x48e1a0 new_and_construct ---- */
/* 0x48e1a0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x4e4) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x48e21a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5284ea) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x48e1a0 m48e1a0_new_and_construct */
uint32_t m48e1a0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x4e4);
    return p != 0 ? call0(host, 0x48e21a, (uintptr_t)p) : 0;
}

/* ---- 0x48e21a construct_base_set_vtable ---- */
/* 0x48e21a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52da70u at [this], then 0x48e28a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5284fd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x48e21a m48e21a_construct_base_set_vtable */
uint8_t *m48e21a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52da70u);
    (void)call0(host, 0x48e28a, (uintptr_t)self);
    return self;
}

/* ---- 0x490480 new_and_construct ---- */
/* 0x490480, plain `ret`, returns the new object or 0: p = 0x51dc43(0x50fe) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4904fa(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52851a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x490480 m490480_new_and_construct */
uint32_t m490480_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x50fe);
    return p != 0 ? call0(host, 0x4904fa, (uintptr_t)p) : 0;
}

/* ---- 0x49c4c0 new_and_construct ---- */
/* 0x49c4c0, plain `ret`, returns the new object or 0: p = 0x51dc43(0xe4c) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x49c53a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52854a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x49c4c0 m49c4c0_new_and_construct */
uint32_t m49c4c0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0xe4c);
    return p != 0 ? call0(host, 0x49c53a, (uintptr_t)p) : 0;
}

/* ---- 0x4a1b60 new_and_construct ---- */
/* 0x4a1b60, plain `ret`, returns the new object or 0: p = 0x51dc43(0x68) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4a1bd7(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52858a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4a1b60 m4a1b60_new_and_construct */
uint32_t m4a1b60_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x68);
    return p != 0 ? call0(host, 0x4a1bd7, (uintptr_t)p) : 0;
}

/* ---- 0x4a1bd7 construct_base_set_vtable ---- */
/* 0x4a1bd7, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52dc58u at [this], then 0x4a1c47(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52859d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4a1bd7 m4a1bd7_construct_base_set_vtable */
uint8_t *m4a1bd7_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52dc58u);
    (void)call0(host, 0x4a1c47, (uintptr_t)self);
    return self;
}

/* ---- 0x4a36a0 new_and_construct ---- */
/* 0x4a36a0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x840) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4a371a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5285ba) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4a36a0 m4a36a0_new_and_construct */
uint32_t m4a36a0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x840);
    return p != 0 ? call0(host, 0x4a371a, (uintptr_t)p) : 0;
}

/* ---- 0x4a371a construct_base_set_vtable ---- */
/* 0x4a371a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52dce0u at [this], then 0x4a378a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5285cd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4a371a m4a371a_construct_base_set_vtable */
uint8_t *m4a371a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52dce0u);
    (void)call0(host, 0x4a378a, (uintptr_t)self);
    return self;
}

/* ---- 0x4a62a0 new_and_construct ---- */
/* 0x4a62a0, plain `ret`, returns the new object or 0: p = 0x51dc43(0xa8) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4a631a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5285ea) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4a62a0 m4a62a0_new_and_construct */
uint32_t m4a62a0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0xa8);
    return p != 0 ? call0(host, 0x4a631a, (uintptr_t)p) : 0;
}

/* ---- 0x4a631a construct_base_set_vtable ---- */
/* 0x4a631a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52dd68u at [this], then 0x4a638a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5285fd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4a631a m4a631a_construct_base_set_vtable */
uint8_t *m4a631a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52dd68u);
    (void)call0(host, 0x4a638a, (uintptr_t)self);
    return self;
}

/* ---- 0x4a7b90 new_and_construct ---- */
/* 0x4a7b90, plain `ret`, returns the new object or 0: p = 0x51dc43(0x13fd) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4a7c0a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52861a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4a7b90 m4a7b90_new_and_construct */
uint32_t m4a7b90_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x13fd);
    return p != 0 ? call0(host, 0x4a7c0a, (uintptr_t)p) : 0;
}

/* ---- 0x4a7c0a construct_base_set_vtable ---- */
/* 0x4a7c0a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52ddf0u at [this], then 0x4a7c7a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52862d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4a7c0a m4a7c0a_construct_base_set_vtable */
uint8_t *m4a7c0a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52ddf0u);
    (void)call0(host, 0x4a7c7a, (uintptr_t)self);
    return self;
}

/* ---- 0x4a9e40 new_and_construct ---- */
/* 0x4a9e40, plain `ret`, returns the new object or 0: p = 0x51dc43(0x4a) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4a9eb7(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52864a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4a9e40 m4a9e40_new_and_construct */
uint32_t m4a9e40_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x4a);
    return p != 0 ? call0(host, 0x4a9eb7, (uintptr_t)p) : 0;
}

/* ---- 0x4a9eb7 construct_base_set_vtable ---- */
/* 0x4a9eb7, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52de78u at [this], then 0x4a9f27(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52865d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4a9eb7 m4a9eb7_construct_base_set_vtable */
uint8_t *m4a9eb7_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52de78u);
    (void)call0(host, 0x4a9f27, (uintptr_t)self);
    return self;
}

/* ---- 0x4ab2c0 new_and_construct ---- */
/* 0x4ab2c0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x62) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4ab337(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52867a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4ab2c0 m4ab2c0_new_and_construct */
uint32_t m4ab2c0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x62);
    return p != 0 ? call0(host, 0x4ab337, (uintptr_t)p) : 0;
}

/* ---- 0x4ab337 construct_base_set_vtable ---- */
/* 0x4ab337, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52df00u at [this], then 0x4ab3a7(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52868d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4ab337 m4ab337_construct_base_set_vtable */
uint8_t *m4ab337_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52df00u);
    (void)call0(host, 0x4ab3a7, (uintptr_t)self);
    return self;
}

/* ---- 0x4ac7f0 new_and_construct ---- */
/* 0x4ac7f0, plain `ret`, returns the new object or 0: p = 0x51dc43(0xe89) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4ac86a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5286aa) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4ac7f0 m4ac7f0_new_and_construct */
uint32_t m4ac7f0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0xe89);
    return p != 0 ? call0(host, 0x4ac86a, (uintptr_t)p) : 0;
}

/* ---- 0x4ac86a construct_base_set_vtable ---- */
/* 0x4ac86a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52df88u at [this], then 0x4ac8da(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5286bd) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4ac86a m4ac86a_construct_base_set_vtable */
uint8_t *m4ac86a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52df88u);
    (void)call0(host, 0x4ac8da, (uintptr_t)self);
    return self;
}

/* ---- 0x4afc50 new_and_construct ---- */
/* 0x4afc50, plain `ret`, returns the new object or 0: p = 0x51dc43(0x1541) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4afcca(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x5286da) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4afc50 m4afc50_new_and_construct */
uint32_t m4afc50_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x1541);
    return p != 0 ? call0(host, 0x4afcca, (uintptr_t)p) : 0;
}

/* ---- 0x4afcca construct_base_set_vtable ---- */
/* 0x4afcca, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52e010u at [this], then 0x4afd3a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5286ed) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4afcca m4afcca_construct_base_set_vtable */
uint8_t *m4afcca_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52e010u);
    (void)call0(host, 0x4afd3a, (uintptr_t)self);
    return self;
}

/* ---- 0x4b3b70 new_and_construct ---- */
/* 0x4b3b70, plain `ret`, returns the new object or 0: p = 0x51dc43(0x782) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4b3bea(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52870a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4b3b70 m4b3b70_new_and_construct */
uint32_t m4b3b70_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x782);
    return p != 0 ? call0(host, 0x4b3bea, (uintptr_t)p) : 0;
}

/* ---- 0x4b3bea construct_base_set_vtable ---- */
/* 0x4b3bea, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52e098u at [this], then 0x4b3c5a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52871d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4b3bea m4b3bea_construct_base_set_vtable */
uint8_t *m4b3bea_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52e098u);
    (void)call0(host, 0x4b3c5a, (uintptr_t)self);
    return self;
}

/* ---- 0x4b5aa0 new_and_construct ---- */
/* 0x4b5aa0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x278) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4b5b1a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52873a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4b5aa0 m4b5aa0_new_and_construct */
uint32_t m4b5aa0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x278);
    return p != 0 ? call0(host, 0x4b5b1a, (uintptr_t)p) : 0;
}

/* ---- 0x4b5b1a construct_base_set_vtable ---- */
/* 0x4b5b1a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52e120u at [this], then 0x4b5b8a(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52874d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4b5b1a m4b5b1a_construct_base_set_vtable */
uint8_t *m4b5b1a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52e120u);
    (void)call0(host, 0x4b5b8a, (uintptr_t)self);
    return self;
}

/* ---- 0x4b7110 new_and_construct ---- */
/* 0x4b7110, plain `ret`, returns the new object or 0: p = 0x51dc43(0x3c) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4b7187(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52876a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4b7110 m4b7110_new_and_construct */
uint32_t m4b7110_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x3c);
    return p != 0 ? call0(host, 0x4b7187, (uintptr_t)p) : 0;
}

/* ---- 0x4b7187 construct_base_set_vtable ---- */
/* 0x4b7187, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52e1a8u at [this], then 0x4b71f7(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52877d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4b7187 m4b7187_construct_base_set_vtable */
uint8_t *m4b7187_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52e1a8u);
    (void)call0(host, 0x4b71f7, (uintptr_t)self);
    return self;
}

/* ---- 0x4cc8b0 new_and_construct ---- */
/* 0x4cc8b0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x1c) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4cc927(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52881a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4cc8b0 m4cc8b0_new_and_construct */
uint32_t m4cc8b0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x1c);
    return p != 0 ? call0(host, 0x4cc927, (uintptr_t)p) : 0;
}

/* ---- 0x4d3aa0 new_and_construct ---- */
/* 0x4d3aa0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x466) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4d3b1a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52885a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4d3aa0 m4d3aa0_new_and_construct */
uint32_t m4d3aa0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x466);
    return p != 0 ? call0(host, 0x4d3b1a, (uintptr_t)p) : 0;
}

/* ---- 0x4d3b1a construct_base_set_vtable ---- */
/* 0x4d3b1a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52e310u at [this], then 0x4d3b95(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52886d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4d3b1a m4d3b1a_construct_base_set_vtable */
uint8_t *m4d3b1a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52e310u);
    (void)call0(host, 0x4d3b95, (uintptr_t)self);
    return self;
}

/* ---- 0x4dbea0 new_and_construct ---- */
/* 0x4dbea0, plain `ret`, returns the new object or 0: p = 0x51dc43(0x10a) (cdecl, one argument, the caller pops it); when p is non-zero the result is 0x4dbf1a(p) (thiscall, no arguments), else 0. The function links a structured-exception frame (handler 0x52888a) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4dbea0 m4dbea0_new_and_construct */
uint32_t m4dbea0_new_and_construct(const Fl18Host *host)
{
    const uint32_t p = call1(host, 0x51dc43, 0, 0x10a);
    return p != 0 ? call0(host, 0x4dbf1a, (uintptr_t)p) : 0;
}

/* ---- 0x4dbf1a construct_base_set_vtable ---- */
/* 0x4dbf1a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, no arguments), stores the dword 0x52e478u at [this], then 0x4dbfbf(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x52889d) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4dbf1a m4dbf1a_construct_base_set_vtable */
uint8_t *m4dbf1a_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0, 0x52e478u);
    (void)call0(host, 0x4dbfbf, (uintptr_t)self);
    return self;
}

/* ---- 0x4de150 construct_base_set_vtable ---- */
/* 0x4de150, thiscall, plain `ret`, returns this: 0x4eda10(this) (thiscall, no arguments), stores the dword 0x52e4ccu at [this], then 0x4de1f5(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x5288d9) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4de150 m4de150_construct_base_set_vtable */
uint8_t *m4de150_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x4eda10, (uintptr_t)self);
    wr32(self, 0, 0x52e4ccu);
    (void)call0(host, 0x4de1f5, (uintptr_t)self);
    return self;
}

/* ---- 0x4e7630 construct_base_set_vtable ---- */
/* 0x4e7630, thiscall, plain `ret`, returns this: 0x4eda10(this) (thiscall, no arguments), stores the dword 0x52e4f0u at [this], then 0x4e76d5(this) (thiscall, no arguments). The function links a structured-exception frame (handler 0x528a09) into fs:[0] and unlinks it before the return; the frame is not modelled. */
/* 0x4e7630 m4e7630_construct_base_set_vtable */
uint8_t *m4e7630_construct_base_set_vtable(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x4eda10, (uintptr_t)self);
    wr32(self, 0, 0x52e4f0u);
    (void)call0(host, 0x4e76d5, (uintptr_t)self);
    return self;
}

