#include "original_methods_fl39d.h"

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

/* string instructions of the original (direction flag clear): one unit at a time, forward, a unit is read before it is written */
FL39_UNUSED static void rep_stos(uint8_t *p, uint32_t v, uint32_t n, int unit)
{
    uint32_t k;
    for (k = 0; k < n; k++) {
        if (unit == 4) memcpy(p + 4u * k, &v, 4);
        else if (unit == 2) {
            uint16_t w = (uint16_t)v;
            memcpy(p + 2u * k, &w, 2);
        } else p[k] = (uint8_t)v;
    }
}

FL39_UNUSED static void rep_movs(uint8_t *d, const uint8_t *s, uint32_t n, int unit)
{
    uint32_t k, u;
    for (k = 0; k < n; k++)
        for (u = 0; u < (uint32_t)unit; u++) d[(size_t)k * (size_t)unit + u] = s[(size_t)k * (size_t)unit + u];
}

/* repne scasb: examines bytes from p until one equals al or `count` bytes were examined; returns how many; *last is the last byte examined */
FL39_UNUSED static uint32_t scas(const uint8_t *p, uint8_t al, uint32_t count, uint32_t *last)
{
    uint32_t i = 0;
    while (i < count) {
        uint8_t b = p[i++];
        *last = b;
        if (b == al) break;
    }
    return i;
}

/* repe cmpsb: compares bytes of s and d while they are equal, at most `count`; returns how many were compared; *a / *b are the last pair */
FL39_UNUSED static uint32_t cmps(const uint8_t *s, const uint8_t *d, uint32_t count, uint32_t *a, uint32_t *b)
{
    uint32_t i = 0;
    while (i < count) {
        *a = s[i];
        *b = d[i];
        i++;
        if (*a != *b) break;
    }
    return i;
}

/* ---- 0x48217a lifted ---- */
/* 0x48217a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x1c]/2, [self+0x1e]/2, [self+0x20]/4, [self+0xa8]/1. Returns this. */
uint8_t * m48217a_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x48217d */
    L4 = ecx;
    /* 0x48217e */
    L4 = ecx;
    /* 0x482181 */
    eax = L4;
    /* 0x482184 */
    wr16(self, 30, (uint16_t)(0xffffu));
    /* 0x48218a */
    ecx = L4;
    /* 0x48218d */
    wr16(self, 28, (uint16_t)(0xffffu));
    /* 0x482193 */
    edx = L4;
    /* 0x482196 */
    wr32(self, 32, (uint32_t)(0x0u));
    /* 0x48219d */
    eax = L4;
    /* 0x4821a0 */
    self[168] = (uint8_t)(0x0u);
    /* 0x4821a7 */
    /* 0x4821a9 */
    /* 0x4821aa */
    return (uint8_t *)eax;
}

/* ---- 0x4821ab lifted ---- */
/* 0x4821ab, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x20]/4, [self+0x24]/4, [self+0x1c]/2. Calls (in code order): 0x48217a(this, 0 args), 0x4c2dfb(this, 1 arg), 0x4d3992(1 arg). Returns eax. */
uint32_t m4821ab_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4821ae */
    L4 = ecx;
    /* 0x4821af */
    L4 = ecx;
    /* 0x4821b2 */
    eax = L4;
    /* 0x4821b5 */
    fa = rd32(self, 32);
    fb = 0x0u;
    /* 0x4821b9 */
    if (fa == fb) goto L4821cc;
    /* 0x4821bb */
    ecx = L4;
    /* 0x4821be */
    ecx = (uintptr_t)(self + (32));
    /* 0x4821c1 */
    L8 = ecx;
    /* 0x4821c2 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4821c7 */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, L8);
L4821cc:;
    /* 0x4821cc */
    edx = L4;
    /* 0x4821cf */
    fa = rd32(self, 36);
    fb = 0x0u;
    /* 0x4821d3 */
    if (fa == fb) goto L4821e6;
    /* 0x4821d5 */
    eax = L4;
    /* 0x4821d8 */
    eax = (uintptr_t)(self + (36));
    /* 0x4821db */
    L8 = eax;
    /* 0x4821dc */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4821e1 */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, L8);
L4821e6:;
    /* 0x4821e6 */
    ecx = L4;
    /* 0x4821e9 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 28)));
    /* 0x4821ed */
    fa = (uint32_t)edx;
    fb = 0xffffffffu;
    /* 0x4821f0 */
    if (fa == fb) goto L482202;
    /* 0x4821f2 */
    eax = L4;
    /* 0x4821f5 */
    ecx = (uint32_t)(((uint32_t)rd16(self, 28)) & 0xffffu);
    /* 0x4821f9 */
    L8 = (uint32_t)(uint32_t)ecx;
    /* 0x4821fa */
    eax = (uintptr_t)call1(host, 0x4d3992, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4821ff */
L482202:;
    /* 0x482202 */
    ecx = L4;
    /* 0x482205 */
    eax = (uintptr_t)call0(host, 0x48217a, ecx);
    /* 0x48220a */
    /* 0x48220c */
    /* 0x48220d */
    return (uint32_t)eax;
}

/* ---- 0x487dcf lifted ---- */
/* 0x487dcf, this = ecx (self), `ret 0x8`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword, a1 dword. Reads [self+0x65]/1. Stores to [self+0x24]/1, [self+0x66]/2. Globals: 0x5b44f0/4 (written), 0x5b44f4/4 (written), 0x5c39e5/4 (written), 0x5d0377/4, 0x5d162d/4 (written), 0x5d1631/4 (written), 0x5d1639/4 (written). eax is left-over and not meaningful. */
uint32_t m487dcf_lifted(uint8_t *self, uint32_t a0, uint32_t a1, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t A1 = (uintptr_t)a1;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)A1;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x487dd2 */
    L4 = ecx;
    /* 0x487dd3 */
    L4 = ecx;
    /* 0x487dd6 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)A0 & 0xffffu)));
    /* 0x487dda */
    fa = (uint32_t)eax;
    fb = 0x2789u;
    /* 0x487ddf */
    if (fa != fb) goto L487e48;
    /* 0x487de1 */
    world->value_5b44f0 = (uint32_t)(0x9u);
    /* 0x487deb */
    world->value_5b44f4 = (uint32_t)(0x1u);
    /* 0x487df5 */
    ecx = (uint32_t)(world->value_5d0377);
    /* 0x487dfb */
    world->value_5d162d = (uint32_t)((uint32_t)ecx);
    /* 0x487e01 */
    edx = (uint32_t)(world->value_5b44f0);
    /* 0x487e07 */
    fa = ((uint32_t)((((uint32_t)edx) << 5u) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x487e0a */
    eax = (uint32_t)(world->value_5b44f4);
    /* 0x487e0f */
    fa = ((uint32_t)((((uint32_t)eax) << 4u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x487e12 */
    ecx = (uint32_t)((uint32_t)edx + (uint32_t)eax + (uint32_t)5969420);
    /* 0x487e19 */
    world->value_5d1631 = (uint32_t)((uint32_t)ecx);
    /* 0x487e1f */
    world->value_5d1639 = (uint32_t)(0x1u);
    /* 0x487e29 */
    world->value_5c39e5 = (uint32_t)(0x2789u);
    /* 0x487e33 */
    edx = L4;
    /* 0x487e36 */
    self[36] = (uint8_t)(0x1u);
    /* 0x487e3a */
    eax = L4;
    /* 0x487e3d */
    wr16(self, 102, (uint16_t)(0xffffu));
    /* 0x487e43 */
    goto L487ecf;
L487e48:;
    /* 0x487e48 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)A0 & 0xffffu)));
    /* 0x487e4c */
    fa = (uint32_t)ecx;
    fb = 0x2788u;
    /* 0x487e52 */
    if (fa != fb) goto L487ec6;
    /* 0x487e54 */
    world->value_5b44f0 = (uint32_t)(0x16u);
    /* 0x487e5e */
    world->value_5b44f4 = (uint32_t)(0x1u);
    /* 0x487e68 */
    edx = (uint32_t)(world->value_5d0377);
    /* 0x487e6e */
    world->value_5d162d = (uint32_t)((uint32_t)edx);
    /* 0x487e74 */
    eax = (uint32_t)(world->value_5b44f0);
    /* 0x487e79 */
    fa = ((uint32_t)((((uint32_t)eax) << 5u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x487e7c */
    ecx = (uint32_t)(world->value_5b44f4);
    /* 0x487e82 */
    fa = ((uint32_t)((((uint32_t)ecx) << 4u) & 0xffffffffu)) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x487e85 */
    edx = (uint32_t)((uint32_t)eax + (uint32_t)ecx + (uint32_t)5969420);
    /* 0x487e8c */
    world->value_5d1631 = (uint32_t)((uint32_t)edx);
    /* 0x487e92 */
    world->value_5d1639 = (uint32_t)(0x1u);
    /* 0x487e9c */
    world->value_5c39e5 = (uint32_t)(0x2788u);
    /* 0x487ea6 */
    eax = L4;
    /* 0x487ea9 */
    self[36] = (uint8_t)(0x1u);
    /* 0x487ead */
    ecx = L4;
    /* 0x487eb0 */
    edx = (uint32_t)(0u);
    fa = 0u;
    /* 0x487eb2 */
    edx = (uint32_t)(((uint32_t)edx & 0xffffff00u) | ((((uint32_t)self[101]) & 0xffu) << 0));
    /* 0x487eb5 */
    fa = ((uint32_t)edx) & ((uint32_t)edx);
    /* 0x487eb7 */
    if (fa != 0) goto L487ec4;
    /* 0x487eb9 */
    eax = L4;
    /* 0x487ebc */
    ecx = (uint32_t)((((uint32_t)A1 & 0xffffu)) & 0xffffu);
    /* 0x487ec0 */
    wr16(self, 102, (uint16_t)(((uint32_t)ecx & 0xffffu)));
L487ec4:;
    /* 0x487ec4 */
    goto L487ecf;
L487ec6:;
    /* 0x487ec6 */
    edx = L4;
    /* 0x487ec9 */
    wr16(self, 102, (uint16_t)(0xffffu));
L487ecf:;
    /* 0x487ecf */
    /* 0x487ed1 */
    /* 0x487ed2 */
    return 0;
}

/* ---- 0x488e54 lifted ---- */
/* 0x488e54, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x2c]/4, [self+0xcc]/4. eax is left-over and not meaningful. */
uint32_t m488e54_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x488e57 */
    /* 0x488e5a */
    L8 = ecx;
    /* 0x488e5d */
    L4 = (uint32_t)((0x0u) & 0xffffu);
    /* 0x488e63 */
    goto L488e71;
L488e65:;
    /* 0x488e65 */
    eax = (uint32_t)((((uint32_t)L4 & 0xffffu)) & 0xffffu);
    /* 0x488e69 */
    fa = ((uint32_t)(((((uint32_t)eax & 0xffffu)) + (0x1u)) & 0xffffu)) & 0xffffu;
    eax = (uint32_t)((fa) & 0xffffu);
    /* 0x488e6d */
    L4 = (uint32_t)((((uint32_t)eax & 0xffffu)) & 0xffffu);
L488e71:;
    /* 0x488e71 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x488e75 */
    fa = (uint32_t)ecx;
    fb = 0x28u;
    /* 0x488e78 */
    if ((int32_t)fa >= (int32_t)fb) goto L488e8b;
    /* 0x488e7a */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x488e7e */
    eax = L8;
    /* 0x488e81 */
    wr32(self, 44 + (ptrdiff_t)(int32_t)((uint32_t)edx * 4u), (uint32_t)(0x0u));
    /* 0x488e89 */
    goto L488e65;
L488e8b:;
    /* 0x488e8b */
    ecx = L8;
    /* 0x488e8e */
    wr32(self, 204, (uint32_t)(0x0u));
    /* 0x488e98 */
    /* 0x488e9a */
    /* 0x488e9b */
    return 0;
}

/* ---- 0x48a70a lifted ---- */
/* 0x48a70a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x1c]/2, [self+0x1e]/2, [self+0x20]/4, [self+0x24]/1, [self+0x2e]/2, [self+0x42]/2, [self+0x44]/4, [self+0x4e]/4. ... Returns eax. */
uint32_t m48a70a_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x48a70d */
    /* 0x48a710 */
    L8 = ecx;
    /* 0x48a713 */
    eax = L8;
    /* 0x48a716 */
    wr16(self, 30, (uint16_t)(0xffffu));
    /* 0x48a71c */
    ecx = L8;
    /* 0x48a71f */
    wr16(self, 28, (uint16_t)(0xffffu));
    /* 0x48a725 */
    edx = L8;
    /* 0x48a728 */
    wr32(self, 426, (uint32_t)(0x0u));
    /* 0x48a732 */
    eax = L8;
    /* 0x48a735 */
    self[430] = (uint8_t)(0x0u);
    /* 0x48a73c */
    ecx = L8;
    /* 0x48a73f */
    self[431] = (uint8_t)(0x0u);
    /* 0x48a746 */
    edx = L8;
    /* 0x48a749 */
    wr32(self, 32, (uint32_t)(0x0u));
    /* 0x48a750 */
    eax = L8;
    /* 0x48a753 */
    wr16(self, 432, (uint16_t)(0xffffu));
    /* 0x48a75c */
    ecx = L8;
    /* 0x48a75f */
    wr16(self, 66, (uint16_t)(0x0u));
    /* 0x48a765 */
    edx = L8;
    /* 0x48a768 */
    wr32(self, 68, (uint32_t)(0x0u));
    /* 0x48a76f */
    eax = L8;
    /* 0x48a772 */
    wr32(self, 78, (uint32_t)(0x1u));
    /* 0x48a779 */
    ecx = L8;
    /* 0x48a77c */
    wr32(self, 422, (uint32_t)(0x0u));
    /* 0x48a786 */
    L4 = (uint32_t)((0x0u) & 0xffffu);
    /* 0x48a78c */
    goto L48a79a;
L48a78e:;
    /* 0x48a78e */
    edx = (uint32_t)((((uint32_t)L4 & 0xffffu)) & 0xffffu);
    /* 0x48a792 */
    fa = ((uint32_t)(((((uint32_t)edx & 0xffffu)) + (0x1u)) & 0xffffu)) & 0xffffu;
    edx = (uint32_t)((fa) & 0xffffu);
    /* 0x48a796 */
    L4 = (uint32_t)((((uint32_t)edx & 0xffffu)) & 0xffffu);
L48a79a:;
    /* 0x48a79a */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x48a79e */
    fa = (uint32_t)eax;
    fb = 0xau;
    /* 0x48a7a1 */
    if ((int32_t)fa >= (int32_t)fb) goto L48a7e1;
    /* 0x48a7a3 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x48a7a7 */
    edx = L8;
    /* 0x48a7aa */
    (self)[36 + (ptrdiff_t)(int32_t)((uint32_t)ecx)] = (uint8_t)(0x0u);
    /* 0x48a7af */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x48a7b3 */
    ecx = L8;
    /* 0x48a7b6 */
    wr16(self, 46 + (ptrdiff_t)(int32_t)((uint32_t)eax * 2u), (uint16_t)(0xffffu));
    /* 0x48a7bd */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x48a7c1 */
    eax = L8;
    /* 0x48a7c4 */
    wr16(self, 442 + (ptrdiff_t)(int32_t)((uint32_t)edx * 2u), (uint16_t)(0xffffu));
    /* 0x48a7ce */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x48a7d2 */
    edx = L8;
    /* 0x48a7d5 */
    wr16(self, 402 + (ptrdiff_t)(int32_t)((uint32_t)ecx * 2u), (uint16_t)(0xffffu));
    /* 0x48a7df */
    goto L48a78e;
L48a7e1:;
    /* 0x48a7e1 */
    /* 0x48a7e3 */
    /* 0x48a7e4 */
    return (uint32_t)eax;
}

/* ---- 0x48aa66 lifted ---- */
/* 0x48aa66, this = ecx (self), `ret 0x8`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword, a1 dword. Stores to [self+0x1b0]/2. Globals: 0x5b44f0/4 (written), 0x5b44f4/4 (written), 0x5c39e5/4 (written), 0x5d0377/4, 0x5d162d/4 (written), 0x5d1631/4 (written), 0x5d1639/4 (written). Returns eax. */
uint32_t m48aa66_lifted(uint8_t *self, uint32_t a0, uint32_t a1, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t A1 = (uintptr_t)a1;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)A1;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x48aa69 */
    L4 = ecx;
    /* 0x48aa6a */
    L4 = ecx;
    /* 0x48aa6d */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)A0 & 0xffffu)));
    /* 0x48aa71 */
    fa = (uint32_t)eax;
    fb = 0x2757u;
    /* 0x48aa76 */
    if (fa != fb) goto L48aad8;
    /* 0x48aa78 */
    world->value_5b44f0 = (uint32_t)(0x9u);
    /* 0x48aa82 */
    world->value_5b44f4 = (uint32_t)(0x1u);
    /* 0x48aa8c */
    ecx = (uint32_t)(world->value_5d0377);
    /* 0x48aa92 */
    world->value_5d162d = (uint32_t)((uint32_t)ecx);
    /* 0x48aa98 */
    edx = (uint32_t)(world->value_5b44f0);
    /* 0x48aa9e */
    fa = ((uint32_t)((((uint32_t)edx) << 5u) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x48aaa1 */
    eax = (uint32_t)(world->value_5b44f4);
    /* 0x48aaa6 */
    fa = ((uint32_t)((((uint32_t)eax) << 4u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x48aaa9 */
    ecx = (uint32_t)((uint32_t)edx + (uint32_t)eax + (uint32_t)5969420);
    /* 0x48aab0 */
    world->value_5d1631 = (uint32_t)((uint32_t)ecx);
    /* 0x48aab6 */
    world->value_5d1639 = (uint32_t)(0x1u);
    /* 0x48aac0 */
    world->value_5c39e5 = (uint32_t)(0x2757u);
    /* 0x48aaca */
    edx = L4;
    /* 0x48aacd */
    wr16(self, 432, (uint16_t)(0xffffu));
    /* 0x48aad6 */
    goto L48ab43;
L48aad8:;
    /* 0x48aad8 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)A0 & 0xffffu)));
    /* 0x48aadc */
    fa = (uint32_t)eax;
    fb = 0x2756u;
    /* 0x48aae1 */
    if (fa != fb) goto L48ab43;
    /* 0x48aae3 */
    world->value_5b44f0 = (uint32_t)(0x16u);
    /* 0x48aaed */
    world->value_5b44f4 = (uint32_t)(0x1u);
    /* 0x48aaf7 */
    ecx = (uint32_t)(world->value_5d0377);
    /* 0x48aafd */
    world->value_5d162d = (uint32_t)((uint32_t)ecx);
    /* 0x48ab03 */
    edx = (uint32_t)(world->value_5b44f0);
    /* 0x48ab09 */
    fa = ((uint32_t)((((uint32_t)edx) << 5u) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x48ab0c */
    eax = (uint32_t)(world->value_5b44f4);
    /* 0x48ab11 */
    fa = ((uint32_t)((((uint32_t)eax) << 4u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x48ab14 */
    ecx = (uint32_t)((uint32_t)edx + (uint32_t)eax + (uint32_t)5969420);
    /* 0x48ab1b */
    world->value_5d1631 = (uint32_t)((uint32_t)ecx);
    /* 0x48ab21 */
    world->value_5d1639 = (uint32_t)(0x1u);
    /* 0x48ab2b */
    world->value_5c39e5 = (uint32_t)(0x2756u);
    /* 0x48ab35 */
    edx = L4;
    /* 0x48ab38 */
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | (((((uint32_t)A1 & 0xffffu)) & 0xffffu) << 0));
    /* 0x48ab3c */
    wr16(self, 432, (uint16_t)(((uint32_t)eax & 0xffffu)));
L48ab43:;
    /* 0x48ab43 */
    /* 0x48ab45 */
    /* 0x48ab46 */
    return (uint32_t)eax;
}

/* ---- 0x48e28a lifted ---- */
/* 0x48e28a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x1c]/2, [self+0x1e]/2, [self+0x3fe]/2, [self+0x451]/1, [self+0x45a]/1, [self+0x45b]/1, [self+0x45c]/1, [self+0x45d]/4. ... Returns this. */
uint8_t * m48e28a_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x48e28d */
    L4 = ecx;
    /* 0x48e28e */
    L4 = ecx;
    /* 0x48e291 */
    eax = L4;
    /* 0x48e294 */
    wr16(self, 30, (uint16_t)(0xffffu));
    /* 0x48e29a */
    ecx = L4;
    /* 0x48e29d */
    wr16(self, 28, (uint16_t)(0xffffu));
    /* 0x48e2a3 */
    edx = L4;
    /* 0x48e2a6 */
    wr32(self, 1122, (uint32_t)(0x0u));
    /* 0x48e2b0 */
    eax = L4;
    /* 0x48e2b3 */
    self[1105] = (uint8_t)(0x0u);
    /* 0x48e2ba */
    ecx = L4;
    /* 0x48e2bd */
    self[1114] = (uint8_t)(0x0u);
    /* 0x48e2c4 */
    edx = L4;
    /* 0x48e2c7 */
    self[1115] = (uint8_t)(0x0u);
    /* 0x48e2ce */
    eax = L4;
    /* 0x48e2d1 */
    self[1116] = (uint8_t)(0x0u);
    /* 0x48e2d8 */
    ecx = L4;
    /* 0x48e2db */
    wr32(self, 1117, (uint32_t)(0x0u));
    /* 0x48e2e5 */
    edx = L4;
    /* 0x48e2e8 */
    wr16(self, 1022, (uint16_t)(0x0u));
    /* 0x48e2f1 */
    /* 0x48e2f3 */
    /* 0x48e2f4 */
    return (uint8_t *)eax;
}

/* ---- 0x4911ca lifted ---- */
/* 0x4911ca, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1f3f]/4. Stores to [self+0x1f47]/4, [self+0x1f4b]/4, [self+0x1f4f]/4, [self+0x1f53]/4, [self+0x1f57]/4, [self+0x1f5b]/4, [self+0x1f5f]/4, [self+0x1f63]/4. ... Calls (in code order): 0x4c97b4(this, 0 args), 0x51dc43(1 arg), 0x52139c(3 args). Returns eax. */
uint32_t m4911ca_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uintptr_t L24 = 0;
    uintptr_t L28 = 0;
    uintptr_t L32 = 0;
    uintptr_t L36 = 0;
    uintptr_t L40 = 0;
    uintptr_t L44 = 0;
    uintptr_t L48 = 0;
    uintptr_t L52 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L24;
    (void)L28;
    (void)L32;
    (void)L36;
    (void)L4;
    (void)L40;
    (void)L44;
    (void)L48;
    (void)L52;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4911cd */
    /* 0x4911d0 */
    L40 = ecx;
    /* 0x4911d3 */
    eax = L40;
    /* 0x4911d6 */
    ecx = (uint32_t)(rd32(self, 7999));
    /* 0x4911dc */
    fa = ((uint32_t)((((uint32_t)ecx) << 2u) & 0xffffffffu)) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4911df */
    L44 = (uint32_t)((uint32_t)ecx);
    /* 0x4911e0 */
    eax = (uintptr_t)call1(host, 0x51dc43, 0, (uintptr_t)(uint32_t)L44);
    /* 0x4911e5 */
    /* 0x4911e8 */
    L4 = (uint32_t)((uint32_t)eax);
    /* 0x4911eb */
    edx = L40;
    /* 0x4911ee */
    eax = (uint32_t)((uint32_t)L4);
    /* 0x4911f1 */
    wr32(self, 8007, (uint32_t)((uint32_t)eax));
    /* 0x4911f7 */
    fa = (uint32_t)L4;
    fb = 0x0u;
    /* 0x4911fb */
    if (fa != fb) goto L491215;
    /* 0x4911fd */
    L44 = (uint32_t)(0x0u);
    /* 0x4911ff */
    L48 = (uint32_t)(0x0u);
    /* 0x491201 */
    L52 = (uint32_t)(0x54ea90u);
    /* 0x491206 */
    eax = (uintptr_t)call3(host, 0x52139c, 0, (uintptr_t)(uint32_t)L52, (uintptr_t)(uint32_t)L48, (uintptr_t)(uint32_t)L44);
    /* 0x49120b */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x491210 */
    eax = (uintptr_t)call0(host, 0x4c97b4, (uintptr_t)(uint32_t)ecx);
L491215:;
    /* 0x491215 */
    ecx = L40;
    /* 0x491218 */
    edx = (uint32_t)(rd32(self, 7999));
    /* 0x49121e */
    fa = ((uint32_t)((((uint32_t)edx) << 1u) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x491220 */
    L44 = (uint32_t)((uint32_t)edx);
    /* 0x491221 */
    eax = (uintptr_t)call1(host, 0x51dc43, 0, (uintptr_t)(uint32_t)L44);
    /* 0x491226 */
    /* 0x491229 */
    L8 = (uint32_t)((uint32_t)eax);
    /* 0x49122c */
    eax = L40;
    /* 0x49122f */
    ecx = (uint32_t)((uint32_t)L8);
    /* 0x491232 */
    wr32(self, 8011, (uint32_t)((uint32_t)ecx));
    /* 0x491238 */
    fa = (uint32_t)L8;
    fb = 0x0u;
    /* 0x49123c */
    if (fa != fb) goto L491256;
    /* 0x49123e */
    L44 = (uint32_t)(0x0u);
    /* 0x491240 */
    L48 = (uint32_t)(0x0u);
    /* 0x491242 */
    L52 = (uint32_t)(0x54ead8u);
    /* 0x491247 */
    eax = (uintptr_t)call3(host, 0x52139c, 0, (uintptr_t)(uint32_t)L52, (uintptr_t)(uint32_t)L48, (uintptr_t)(uint32_t)L44);
    /* 0x49124c */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x491251 */
    eax = (uintptr_t)call0(host, 0x4c97b4, (uintptr_t)(uint32_t)ecx);
L491256:;
    /* 0x491256 */
    edx = L40;
    /* 0x491259 */
    eax = (uint32_t)(rd32(self, 7999));
    /* 0x49125f */
    fa = ((uint32_t)((((uint32_t)eax) << 1u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x491261 */
    L44 = (uint32_t)((uint32_t)eax);
    /* 0x491262 */
    eax = (uintptr_t)call1(host, 0x51dc43, 0, (uintptr_t)(uint32_t)L44);
    /* 0x491267 */
    /* 0x49126a */
    L12 = (uint32_t)((uint32_t)eax);
    /* 0x49126d */
    ecx = L40;
    /* 0x491270 */
    edx = (uint32_t)((uint32_t)L12);
    /* 0x491273 */
    wr32(self, 8015, (uint32_t)((uint32_t)edx));
    /* 0x491279 */
    fa = (uint32_t)L12;
    fb = 0x0u;
    /* 0x49127d */
    if (fa != fb) goto L491297;
    /* 0x49127f */
    L44 = (uint32_t)(0x0u);
    /* 0x491281 */
    L48 = (uint32_t)(0x0u);
    /* 0x491283 */
    L52 = (uint32_t)(0x54eb20u);
    /* 0x491288 */
    eax = (uintptr_t)call3(host, 0x52139c, 0, (uintptr_t)(uint32_t)L52, (uintptr_t)(uint32_t)L48, (uintptr_t)(uint32_t)L44);
    /* 0x49128d */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x491292 */
    eax = (uintptr_t)call0(host, 0x4c97b4, (uintptr_t)(uint32_t)ecx);
L491297:;
    /* 0x491297 */
    eax = L40;
    /* 0x49129a */
    ecx = (uint32_t)(rd32(self, 7999));
    /* 0x4912a0 */
    fa = ((uint32_t)((((uint32_t)ecx) << 2u) & 0xffffffffu)) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4912a3 */
    L44 = (uint32_t)((uint32_t)ecx);
    /* 0x4912a4 */
    eax = (uintptr_t)call1(host, 0x51dc43, 0, (uintptr_t)(uint32_t)L44);
    /* 0x4912a9 */
    /* 0x4912ac */
    L16 = (uint32_t)((uint32_t)eax);
    /* 0x4912af */
    edx = L40;
    /* 0x4912b2 */
    eax = (uint32_t)((uint32_t)L16);
    /* 0x4912b5 */
    wr32(self, 8019, (uint32_t)((uint32_t)eax));
    /* 0x4912bb */
    fa = (uint32_t)L16;
    fb = 0x0u;
    /* 0x4912bf */
    if (fa != fb) goto L4912d9;
    /* 0x4912c1 */
    L44 = (uint32_t)(0x0u);
    /* 0x4912c3 */
    L48 = (uint32_t)(0x0u);
    /* 0x4912c5 */
    L52 = (uint32_t)(0x54eb68u);
    /* 0x4912ca */
    eax = (uintptr_t)call3(host, 0x52139c, 0, (uintptr_t)(uint32_t)L52, (uintptr_t)(uint32_t)L48, (uintptr_t)(uint32_t)L44);
    /* 0x4912cf */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4912d4 */
    eax = (uintptr_t)call0(host, 0x4c97b4, (uintptr_t)(uint32_t)ecx);
L4912d9:;
    /* 0x4912d9 */
    ecx = L40;
    /* 0x4912dc */
    edx = (uint32_t)(rd32(self, 7999));
    /* 0x4912e2 */
    fa = ((uint32_t)((((uint32_t)edx) << 1u) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4912e4 */
    L44 = (uint32_t)((uint32_t)edx);
    /* 0x4912e5 */
    eax = (uintptr_t)call1(host, 0x51dc43, 0, (uintptr_t)(uint32_t)L44);
    /* 0x4912ea */
    /* 0x4912ed */
    L20 = (uint32_t)((uint32_t)eax);
    /* 0x4912f0 */
    eax = L40;
    /* 0x4912f3 */
    ecx = (uint32_t)((uint32_t)L20);
    /* 0x4912f6 */
    wr32(self, 8023, (uint32_t)((uint32_t)ecx));
    /* 0x4912fc */
    fa = (uint32_t)L20;
    fb = 0x0u;
    /* 0x491300 */
    if (fa != fb) goto L49131a;
    /* 0x491302 */
    L44 = (uint32_t)(0x0u);
    /* 0x491304 */
    L48 = (uint32_t)(0x0u);
    /* 0x491306 */
    L52 = (uint32_t)(0x54ebb0u);
    /* 0x49130b */
    eax = (uintptr_t)call3(host, 0x52139c, 0, (uintptr_t)(uint32_t)L52, (uintptr_t)(uint32_t)L48, (uintptr_t)(uint32_t)L44);
    /* 0x491310 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x491315 */
    eax = (uintptr_t)call0(host, 0x4c97b4, (uintptr_t)(uint32_t)ecx);
L49131a:;
    /* 0x49131a */
    edx = L40;
    /* 0x49131d */
    eax = (uint32_t)(rd32(self, 7999));
    /* 0x491323 */
    fa = ((uint32_t)((((uint32_t)eax) << 1u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x491325 */
    L44 = (uint32_t)((uint32_t)eax);
    /* 0x491326 */
    eax = (uintptr_t)call1(host, 0x51dc43, 0, (uintptr_t)(uint32_t)L44);
    /* 0x49132b */
    /* 0x49132e */
    L24 = (uint32_t)((uint32_t)eax);
    /* 0x491331 */
    ecx = L40;
    /* 0x491334 */
    edx = (uint32_t)((uint32_t)L24);
    /* 0x491337 */
    wr32(self, 8027, (uint32_t)((uint32_t)edx));
    /* 0x49133d */
    fa = (uint32_t)L24;
    fb = 0x0u;
    /* 0x491341 */
    if (fa != fb) goto L49135b;
    /* 0x491343 */
    L44 = (uint32_t)(0x0u);
    /* 0x491345 */
    L48 = (uint32_t)(0x0u);
    /* 0x491347 */
    L52 = (uint32_t)(0x54ebfcu);
    /* 0x49134c */
    eax = (uintptr_t)call3(host, 0x52139c, 0, (uintptr_t)(uint32_t)L52, (uintptr_t)(uint32_t)L48, (uintptr_t)(uint32_t)L44);
    /* 0x491351 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x491356 */
    eax = (uintptr_t)call0(host, 0x4c97b4, (uintptr_t)(uint32_t)ecx);
L49135b:;
    /* 0x49135b */
    eax = L40;
    /* 0x49135e */
    ecx = (uint32_t)(rd32(self, 7999));
    /* 0x491364 */
    fa = ((uint32_t)((((uint32_t)ecx) << 1u) & 0xffffffffu)) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x491366 */
    L44 = (uint32_t)((uint32_t)ecx);
    /* 0x491367 */
    eax = (uintptr_t)call1(host, 0x51dc43, 0, (uintptr_t)(uint32_t)L44);
    /* 0x49136c */
    /* 0x49136f */
    L28 = (uint32_t)((uint32_t)eax);
    /* 0x491372 */
    edx = L40;
    /* 0x491375 */
    eax = (uint32_t)((uint32_t)L28);
    /* 0x491378 */
    wr32(self, 8031, (uint32_t)((uint32_t)eax));
    /* 0x49137e */
    fa = (uint32_t)L28;
    fb = 0x0u;
    /* 0x491382 */
    if (fa != fb) goto L49139c;
    /* 0x491384 */
    L44 = (uint32_t)(0x0u);
    /* 0x491386 */
    L48 = (uint32_t)(0x0u);
    /* 0x491388 */
    L52 = (uint32_t)(0x54ec4cu);
    /* 0x49138d */
    eax = (uintptr_t)call3(host, 0x52139c, 0, (uintptr_t)(uint32_t)L52, (uintptr_t)(uint32_t)L48, (uintptr_t)(uint32_t)L44);
    /* 0x491392 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x491397 */
    eax = (uintptr_t)call0(host, 0x4c97b4, (uintptr_t)(uint32_t)ecx);
L49139c:;
    /* 0x49139c */
    ecx = L40;
    /* 0x49139f */
    edx = (uint32_t)(rd32(self, 7999));
    /* 0x4913a5 */
    fa = ((uint32_t)((((uint32_t)edx) << 1u) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4913a7 */
    L44 = (uint32_t)((uint32_t)edx);
    /* 0x4913a8 */
    eax = (uintptr_t)call1(host, 0x51dc43, 0, (uintptr_t)(uint32_t)L44);
    /* 0x4913ad */
    /* 0x4913b0 */
    L32 = (uint32_t)((uint32_t)eax);
    /* 0x4913b3 */
    eax = L40;
    /* 0x4913b6 */
    ecx = (uint32_t)((uint32_t)L32);
    /* 0x4913b9 */
    wr32(self, 8035, (uint32_t)((uint32_t)ecx));
    /* 0x4913bf */
    fa = (uint32_t)L32;
    fb = 0x0u;
    /* 0x4913c3 */
    if (fa != fb) goto L4913dd;
    /* 0x4913c5 */
    L44 = (uint32_t)(0x0u);
    /* 0x4913c7 */
    L48 = (uint32_t)(0x0u);
    /* 0x4913c9 */
    L52 = (uint32_t)(0x54eca0u);
    /* 0x4913ce */
    eax = (uintptr_t)call3(host, 0x52139c, 0, (uintptr_t)(uint32_t)L52, (uintptr_t)(uint32_t)L48, (uintptr_t)(uint32_t)L44);
    /* 0x4913d3 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4913d8 */
    eax = (uintptr_t)call0(host, 0x4c97b4, (uintptr_t)(uint32_t)ecx);
L4913dd:;
    /* 0x4913dd */
    edx = L40;
    /* 0x4913e0 */
    eax = (uint32_t)(rd32(self, 7999));
    /* 0x4913e6 */
    fa = ((uint32_t)((((uint32_t)eax) << 1u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4913e8 */
    L44 = (uint32_t)((uint32_t)eax);
    /* 0x4913e9 */
    eax = (uintptr_t)call1(host, 0x51dc43, 0, (uintptr_t)(uint32_t)L44);
    /* 0x4913ee */
    /* 0x4913f1 */
    L36 = (uint32_t)((uint32_t)eax);
    /* 0x4913f4 */
    ecx = L40;
    /* 0x4913f7 */
    edx = (uint32_t)((uint32_t)L36);
    /* 0x4913fa */
    wr32(self, 8039, (uint32_t)((uint32_t)edx));
    /* 0x491400 */
    fa = (uint32_t)L36;
    fb = 0x0u;
    /* 0x491404 */
    if (fa != fb) goto L49141e;
    /* 0x491406 */
    L44 = (uint32_t)(0x0u);
    /* 0x491408 */
    L48 = (uint32_t)(0x0u);
    /* 0x49140a */
    L52 = (uint32_t)(0x54ecf8u);
    /* 0x49140f */
    eax = (uintptr_t)call3(host, 0x52139c, 0, (uintptr_t)(uint32_t)L52, (uintptr_t)(uint32_t)L48, (uintptr_t)(uint32_t)L44);
    /* 0x491414 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x491419 */
    eax = (uintptr_t)call0(host, 0x4c97b4, (uintptr_t)(uint32_t)ecx);
L49141e:;
    /* 0x49141e */
    /* 0x491420 */
    /* 0x491421 */
    return (uint32_t)eax;
}

/* ---- 0x491422 lifted ---- */
/* 0x491422, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1f47]/4, [self+0x1f4b]/4, [self+0x1f4f]/4, [self+0x1f53]/4, [self+0x1f57]/4, [self+0x1f5b]/4, [self+0x1f5f]/4, [self+0x1f63]/4. ... Stores to [self+0x1f47]/4, [self+0x1f4b]/4, [self+0x1f4f]/4, [self+0x1f53]/4, [self+0x1f57]/4, [self+0x1f5b]/4, [self+0x1f5f]/4, [self+0x1f63]/4. ... Calls (in code order): 0x51dc6c(1 arg). eax is left-over and not meaningful. */
uint32_t m491422_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uintptr_t L24 = 0;
    uintptr_t L28 = 0;
    uintptr_t L32 = 0;
    uintptr_t L36 = 0;
    uintptr_t L40 = 0;
    uintptr_t L44 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L24;
    (void)L28;
    (void)L32;
    (void)L36;
    (void)L4;
    (void)L40;
    (void)L44;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x491425 */
    /* 0x491428 */
    L40 = ecx;
    /* 0x49142b */
    eax = L40;
    /* 0x49142e */
    fa = rd32(self, 8007);
    fb = 0x0u;
    /* 0x491435 */
    if (fa == fb) goto L49145c;
    /* 0x491437 */
    ecx = L40;
    /* 0x49143a */
    edx = (uint32_t)(rd32(self, 8007));
    /* 0x491440 */
    L4 = (uint32_t)((uint32_t)edx);
    /* 0x491443 */
    eax = (uint32_t)((uint32_t)L4);
    /* 0x491446 */
    L44 = (uint32_t)((uint32_t)eax);
    /* 0x491447 */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L44);
    /* 0x49144c */
    /* 0x49144f */
    ecx = L40;
    /* 0x491452 */
    wr32(self, 8007, (uint32_t)(0x0u));
L49145c:;
    /* 0x49145c */
    edx = L40;
    /* 0x49145f */
    fa = rd32(self, 8011);
    fb = 0x0u;
    /* 0x491466 */
    if (fa == fb) goto L49148d;
    /* 0x491468 */
    eax = L40;
    /* 0x49146b */
    ecx = (uint32_t)(rd32(self, 8011));
    /* 0x491471 */
    L8 = (uint32_t)((uint32_t)ecx);
    /* 0x491474 */
    edx = (uint32_t)((uint32_t)L8);
    /* 0x491477 */
    L44 = (uint32_t)((uint32_t)edx);
    /* 0x491478 */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L44);
    /* 0x49147d */
    /* 0x491480 */
    eax = L40;
    /* 0x491483 */
    wr32(self, 8011, (uint32_t)(0x0u));
L49148d:;
    /* 0x49148d */
    ecx = L40;
    /* 0x491490 */
    fa = rd32(self, 8015);
    fb = 0x0u;
    /* 0x491497 */
    if (fa == fb) goto L4914be;
    /* 0x491499 */
    edx = L40;
    /* 0x49149c */
    eax = (uint32_t)(rd32(self, 8015));
    /* 0x4914a2 */
    L12 = (uint32_t)((uint32_t)eax);
    /* 0x4914a5 */
    ecx = (uint32_t)((uint32_t)L12);
    /* 0x4914a8 */
    L44 = (uint32_t)((uint32_t)ecx);
    /* 0x4914a9 */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L44);
    /* 0x4914ae */
    /* 0x4914b1 */
    edx = L40;
    /* 0x4914b4 */
    wr32(self, 8015, (uint32_t)(0x0u));
L4914be:;
    /* 0x4914be */
    eax = L40;
    /* 0x4914c1 */
    fa = rd32(self, 8019);
    fb = 0x0u;
    /* 0x4914c8 */
    if (fa == fb) goto L4914ef;
    /* 0x4914ca */
    ecx = L40;
    /* 0x4914cd */
    edx = (uint32_t)(rd32(self, 8019));
    /* 0x4914d3 */
    L16 = (uint32_t)((uint32_t)edx);
    /* 0x4914d6 */
    eax = (uint32_t)((uint32_t)L16);
    /* 0x4914d9 */
    L44 = (uint32_t)((uint32_t)eax);
    /* 0x4914da */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L44);
    /* 0x4914df */
    /* 0x4914e2 */
    ecx = L40;
    /* 0x4914e5 */
    wr32(self, 8019, (uint32_t)(0x0u));
L4914ef:;
    /* 0x4914ef */
    edx = L40;
    /* 0x4914f2 */
    fa = rd32(self, 8023);
    fb = 0x0u;
    /* 0x4914f9 */
    if (fa == fb) goto L491520;
    /* 0x4914fb */
    eax = L40;
    /* 0x4914fe */
    ecx = (uint32_t)(rd32(self, 8023));
    /* 0x491504 */
    L20 = (uint32_t)((uint32_t)ecx);
    /* 0x491507 */
    edx = (uint32_t)((uint32_t)L20);
    /* 0x49150a */
    L44 = (uint32_t)((uint32_t)edx);
    /* 0x49150b */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L44);
    /* 0x491510 */
    /* 0x491513 */
    eax = L40;
    /* 0x491516 */
    wr32(self, 8023, (uint32_t)(0x0u));
L491520:;
    /* 0x491520 */
    ecx = L40;
    /* 0x491523 */
    fa = rd32(self, 8027);
    fb = 0x0u;
    /* 0x49152a */
    if (fa == fb) goto L491551;
    /* 0x49152c */
    edx = L40;
    /* 0x49152f */
    eax = (uint32_t)(rd32(self, 8027));
    /* 0x491535 */
    L24 = (uint32_t)((uint32_t)eax);
    /* 0x491538 */
    ecx = (uint32_t)((uint32_t)L24);
    /* 0x49153b */
    L44 = (uint32_t)((uint32_t)ecx);
    /* 0x49153c */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L44);
    /* 0x491541 */
    /* 0x491544 */
    edx = L40;
    /* 0x491547 */
    wr32(self, 8027, (uint32_t)(0x0u));
L491551:;
    /* 0x491551 */
    eax = L40;
    /* 0x491554 */
    fa = rd32(self, 8031);
    fb = 0x0u;
    /* 0x49155b */
    if (fa == fb) goto L491582;
    /* 0x49155d */
    ecx = L40;
    /* 0x491560 */
    edx = (uint32_t)(rd32(self, 8031));
    /* 0x491566 */
    L28 = (uint32_t)((uint32_t)edx);
    /* 0x491569 */
    eax = (uint32_t)((uint32_t)L28);
    /* 0x49156c */
    L44 = (uint32_t)((uint32_t)eax);
    /* 0x49156d */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L44);
    /* 0x491572 */
    /* 0x491575 */
    ecx = L40;
    /* 0x491578 */
    wr32(self, 8031, (uint32_t)(0x0u));
L491582:;
    /* 0x491582 */
    edx = L40;
    /* 0x491585 */
    fa = rd32(self, 8035);
    fb = 0x0u;
    /* 0x49158c */
    if (fa == fb) goto L4915b3;
    /* 0x49158e */
    eax = L40;
    /* 0x491591 */
    ecx = (uint32_t)(rd32(self, 8035));
    /* 0x491597 */
    L32 = (uint32_t)((uint32_t)ecx);
    /* 0x49159a */
    edx = (uint32_t)((uint32_t)L32);
    /* 0x49159d */
    L44 = (uint32_t)((uint32_t)edx);
    /* 0x49159e */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L44);
    /* 0x4915a3 */
    /* 0x4915a6 */
    eax = L40;
    /* 0x4915a9 */
    wr32(self, 8035, (uint32_t)(0x0u));
L4915b3:;
    /* 0x4915b3 */
    ecx = L40;
    /* 0x4915b6 */
    fa = rd32(self, 8039);
    fb = 0x0u;
    /* 0x4915bd */
    if (fa == fb) goto L4915e4;
    /* 0x4915bf */
    edx = L40;
    /* 0x4915c2 */
    eax = (uint32_t)(rd32(self, 8039));
    /* 0x4915c8 */
    L36 = (uint32_t)((uint32_t)eax);
    /* 0x4915cb */
    ecx = (uint32_t)((uint32_t)L36);
    /* 0x4915ce */
    L44 = (uint32_t)((uint32_t)ecx);
    /* 0x4915cf */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L44);
    /* 0x4915d4 */
    /* 0x4915d7 */
    edx = L40;
    /* 0x4915da */
    wr32(self, 8039, (uint32_t)(0x0u));
L4915e4:;
    /* 0x4915e4 */
    /* 0x4915e6 */
    /* 0x4915e7 */
    return 0;
}

/* ---- 0x491885 lifted ---- */
/* 0x491885, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x50f3]/4, [self+0x50f7]/4. Stores to [self+0x50f3]/4, [self+0x50f7]/4, [self+0x50fc]/1, [self+0x50fd]/1. Calls (in code order): 0x49192b(this, 0 args), 0x4c97b4(this, 0 args), 0x51dc43(1 arg), 0x51dc6c(1 arg), 0x52139c(3 args). Returns eax. */
uint32_t m491885_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uintptr_t L24 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L24;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x491888 */
    /* 0x49188b */
    L12 = ecx;
    /* 0x49188e */
    eax = L12;
    /* 0x491891 */
    fa = rd32(self, 20723);
    fb = 0x0u;
    /* 0x491898 */
    if (fa == fb) goto L4918bf;
    /* 0x49189a */
    ecx = L12;
    /* 0x49189d */
    edx = (uint32_t)(rd32(self, 20723));
    /* 0x4918a3 */
    L4 = (uint32_t)((uint32_t)edx);
    /* 0x4918a6 */
    eax = (uint32_t)((uint32_t)L4);
    /* 0x4918a9 */
    L16 = (uint32_t)((uint32_t)eax);
    /* 0x4918aa */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L16);
    /* 0x4918af */
    /* 0x4918b2 */
    ecx = L12;
    /* 0x4918b5 */
    wr32(self, 20723, (uint32_t)(0x0u));
L4918bf:;
    /* 0x4918bf */
    edx = L12;
    /* 0x4918c2 */
    wr32(self, 20727, (uint32_t)(0x26360u));
    /* 0x4918cc */
    eax = L12;
    /* 0x4918cf */
    self[20732] = (uint8_t)(0xfau);
    /* 0x4918d6 */
    ecx = L12;
    /* 0x4918d9 */
    self[20733] = (uint8_t)(0x2u);
    /* 0x4918e0 */
    edx = L12;
    /* 0x4918e3 */
    eax = (uint32_t)(rd32(self, 20727));
    /* 0x4918e9 */
    L16 = (uint32_t)((uint32_t)eax);
    /* 0x4918ea */
    eax = (uintptr_t)call1(host, 0x51dc43, 0, (uintptr_t)(uint32_t)L16);
    /* 0x4918ef */
    /* 0x4918f2 */
    L8 = (uint32_t)((uint32_t)eax);
    /* 0x4918f5 */
    ecx = L12;
    /* 0x4918f8 */
    edx = (uint32_t)((uint32_t)L8);
    /* 0x4918fb */
    wr32(self, 20723, (uint32_t)((uint32_t)edx));
    /* 0x491901 */
    fa = (uint32_t)L8;
    fb = 0x0u;
    /* 0x491905 */
    if (fa != fb) goto L49191f;
    /* 0x491907 */
    L16 = (uint32_t)(0x0u);
    /* 0x491909 */
    L20 = (uint32_t)(0x0u);
    /* 0x49190b */
    L24 = (uint32_t)(0x54ee6cu);
    /* 0x491910 */
    eax = (uintptr_t)call3(host, 0x52139c, 0, (uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16);
    /* 0x491915 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x49191a */
    eax = (uintptr_t)call0(host, 0x4c97b4, (uintptr_t)(uint32_t)ecx);
L49191f:;
    /* 0x49191f */
    ecx = L12;
    /* 0x491922 */
    eax = (uintptr_t)call0(host, 0x49192b, ecx);
    /* 0x491927 */
    /* 0x491929 */
    /* 0x49192a */
    return (uint32_t)eax;
}

/* ---- 0x4921a1 lifted ---- */
/* 0x4921a1, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x4791]/4, [self+0x4775]/4, [self+0x4771]/4, [self+0x477d]/4, [self+0x4779]/4, [self+0x4785]/4, [self+0x4781]/4, [self+0x4799]/4. ... Stores to [self+0x4771]/4, [self+0x4775]/4, [self+0x4779]/4, [self+0x477d]/4, [self+0x4781]/4, [self+0x4785]/4, [self+0x4789]/4, [self+0x478d]/4. ... Globals: 0x583186/4, 0x58318a/4. Returns this. */
uint8_t * m4921a1_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4921a4 */
    L4 = ecx;
    /* 0x4921a5 */
    L4 = ecx;
    /* 0x4921a8 */
    eax = L4;
    /* 0x4921ab */
    ecx = (uint32_t)(rd32(self, 18321));
    /* 0x4921b1 */
    fa = ((uint32_t)((((uint32_t)ecx) << 4u) & 0xffffffffu)) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4921b4 */
    edx = L4;
    /* 0x4921b7 */
    eax = L4;
    /* 0x4921ba */
    ecx = (uint32_t)(rd32(self, 32 + (ptrdiff_t)(int32_t)((uint32_t)ecx)));
    /* 0x4921be */
    wr32(self, 18289, (uint32_t)((uint32_t)ecx));
    /* 0x4921c4 */
    edx = L4;
    /* 0x4921c7 */
    eax = (uint32_t)(rd32(self, 18321));
    /* 0x4921cd */
    fa = ((uint32_t)((((uint32_t)eax) << 4u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4921d0 */
    ecx = L4;
    /* 0x4921d3 */
    edx = L4;
    /* 0x4921d6 */
    eax = (uint32_t)(rd32(self, 36 + (ptrdiff_t)(int32_t)((uint32_t)eax)));
    /* 0x4921da */
    wr32(self, 18297, (uint32_t)((uint32_t)eax));
    /* 0x4921e0 */
    ecx = L4;
    /* 0x4921e3 */
    edx = (uint32_t)(rd32(self, 18321));
    /* 0x4921e9 */
    fa = ((uint32_t)((((uint32_t)edx) << 4u) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4921ec */
    eax = L4;
    /* 0x4921ef */
    ecx = L4;
    /* 0x4921f2 */
    edx = (uint32_t)(rd32(self, 40 + (ptrdiff_t)(int32_t)((uint32_t)edx)));
    /* 0x4921f6 */
    wr32(self, 18293, (uint32_t)((uint32_t)edx));
    /* 0x4921fc */
    eax = L4;
    /* 0x4921ff */
    ecx = (uint32_t)(rd32(self, 18321));
    /* 0x492205 */
    fa = ((uint32_t)((((uint32_t)ecx) << 4u) & 0xffffffffu)) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x492208 */
    edx = L4;
    /* 0x49220b */
    eax = L4;
    /* 0x49220e */
    ecx = (uint32_t)(rd32(self, 44 + (ptrdiff_t)(int32_t)((uint32_t)ecx)));
    /* 0x492212 */
    wr32(self, 18301, (uint32_t)((uint32_t)ecx));
    /* 0x492218 */
    edx = L4;
    /* 0x49221b */
    eax = L4;
    /* 0x49221e */
    ecx = (uint32_t)(rd32(self, 18293));
    /* 0x492224 */
    fa = ((uint32_t)((((uint32_t)ecx) - (rd32(self, 18289))))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x49222a */
    edx = L4;
    /* 0x49222d */
    wr32(self, 18305, (uint32_t)((uint32_t)ecx));
    /* 0x492233 */
    eax = L4;
    /* 0x492236 */
    ecx = L4;
    /* 0x492239 */
    edx = (uint32_t)(rd32(self, 18301));
    /* 0x49223f */
    fa = ((uint32_t)((((uint32_t)edx) - (rd32(self, 18297))))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x492245 */
    eax = L4;
    /* 0x492248 */
    wr32(self, 18309, (uint32_t)((uint32_t)edx));
    /* 0x49224e */
    ecx = L4;
    /* 0x492251 */
    edx = (uint32_t)(rd32(self, 18309));
    /* 0x492257 */
    fa = ((uint32_t)(((uint32_t)((int32_t)((uint32_t)edx) >> 1u)) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x492259 */
    eax = L4;
    /* 0x49225c */
    ecx = (uint32_t)(rd32(self, 18297));
    /* 0x492262 */
    fa = ((uint32_t)((((uint32_t)ecx) + ((uint32_t)edx)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x492264 */
    edx = L4;
    /* 0x492267 */
    wr32(self, 18313, (uint32_t)((uint32_t)ecx));
    /* 0x49226d */
    eax = L4;
    /* 0x492270 */
    ecx = (uint32_t)(rd32(self, 18305));
    /* 0x492276 */
    fa = ((uint32_t)(((uint32_t)((int32_t)((uint32_t)ecx) >> 1u)) & 0xffffffffu)) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x492278 */
    edx = L4;
    /* 0x49227b */
    eax = (uint32_t)(rd32(self, 18289));
    /* 0x492281 */
    fa = ((uint32_t)((((uint32_t)eax) + ((uint32_t)ecx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x492283 */
    ecx = L4;
    /* 0x492286 */
    wr32(self, 18317, (uint32_t)((uint32_t)eax));
    /* 0x49228c */
    edx = L4;
    /* 0x49228f */
    eax = (uint32_t)(world->value_58318a);
    /* 0x492294 */
    fa = ((uint32_t)((((uint32_t)eax) + (rd32(self, 18297))))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x49229a */
    ecx = L4;
    /* 0x49229d */
    wr32(self, 18333, (uint32_t)((uint32_t)eax));
    /* 0x4922a3 */
    edx = L4;
    /* 0x4922a6 */
    eax = (uint32_t)(world->value_583186);
    /* 0x4922ab */
    fa = ((uint32_t)((((uint32_t)eax) + (rd32(self, 18289))))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4922b1 */
    ecx = L4;
    /* 0x4922b4 */
    wr32(self, 18329, (uint32_t)((uint32_t)eax));
    /* 0x4922ba */
    edx = L4;
    /* 0x4922bd */
    eax = (uint32_t)(rd32(self, 18329));
    /* 0x4922c3 */
    ecx = L4;
    /* 0x4922c6 */
    fa = ((uint32_t)((((uint32_t)eax) + (rd32(self, 18305))))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4922cc */
    edx = L4;
    /* 0x4922cf */
    wr32(self, 18337, (uint32_t)((uint32_t)eax));
    /* 0x4922d5 */
    eax = L4;
    /* 0x4922d8 */
    ecx = (uint32_t)(rd32(self, 18333));
    /* 0x4922de */
    edx = L4;
    /* 0x4922e1 */
    fa = ((uint32_t)((((uint32_t)ecx) + (rd32(self, 18309))))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4922e7 */
    eax = L4;
    /* 0x4922ea */
    wr32(self, 18341, (uint32_t)((uint32_t)ecx));
    /* 0x4922f0 */
    /* 0x4922f2 */
    /* 0x4922f3 */
    return (uint8_t *)eax;
}

/* ---- 0x493a54 lifted ---- */
/* 0x493a54, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1f77]/4, [self+0x479d]/4, [self+0x47a5]/4, [self+0x4799]/4, [self+0x47a1]/4. Stores to [self+0x200b]/4. Globals: 0x583102/4, 0x583106/4, 0x58310a/4, 0x58310e/4. Returns eax. */
uint32_t m493a54_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x493a57 */
    L4 = ecx;
    /* 0x493a58 */
    L4 = ecx;
    /* 0x493a5b */
    eax = L4;
    /* 0x493a5e */
    fa = rd32(self, 8055);
    fb = 0x0u;
    /* 0x493a65 */
    if (fa != fb) goto L493a6e;
    /* 0x493a67 */
    eax = (uint32_t)(0x1u);
    /* 0x493a6c */
    goto L493ad4;
L493a6e:;
    /* 0x493a6e */
    ecx = L4;
    /* 0x493a71 */
    edx = (uint32_t)(world->value_583106);
    /* 0x493a77 */
    fa = (uint32_t)edx;
    fb = rd32(self, 18333);
    /* 0x493a7d */
    if ((int32_t)fa < (int32_t)fb) goto L493ac2;
    /* 0x493a7f */
    eax = L4;
    /* 0x493a82 */
    ecx = (uint32_t)(world->value_58310e);
    /* 0x493a88 */
    fa = (uint32_t)ecx;
    fb = rd32(self, 18341);
    /* 0x493a8e */
    if ((int32_t)fa > (int32_t)fb) goto L493ac2;
    /* 0x493a90 */
    edx = L4;
    /* 0x493a93 */
    eax = (uint32_t)(world->value_583102);
    /* 0x493a98 */
    fa = (uint32_t)eax;
    fb = rd32(self, 18329);
    /* 0x493a9e */
    if ((int32_t)fa < (int32_t)fb) goto L493ac2;
    /* 0x493aa0 */
    ecx = L4;
    /* 0x493aa3 */
    edx = (uint32_t)(world->value_58310a);
    /* 0x493aa9 */
    fa = (uint32_t)edx;
    fb = rd32(self, 18337);
    /* 0x493aaf */
    if ((int32_t)fa > (int32_t)fb) goto L493ac2;
    /* 0x493ab1 */
    eax = L4;
    /* 0x493ab4 */
    wr32(self, 8203, (uint32_t)(0x1u));
    /* 0x493abe */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x493ac0 */
    goto L493ad4;
L493ac2:;
    /* 0x493ac2 */
    ecx = L4;
    /* 0x493ac5 */
    wr32(self, 8203, (uint32_t)(0x0u));
    /* 0x493acf */
    eax = (uint32_t)(0x1u);
L493ad4:;
    /* 0x493ad4 */
    /* 0x493ad6 */
    /* 0x493ad7 */
    return (uint32_t)eax;
}

/* ---- 0x493af0 lifted ---- */
/* 0x493af0, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x2003]/4, [self+0x2007]/4, [self+0x200b]/4. Calls (in code order): 0x4dae66(this, 0 args), 0x4dae77(this, 0 args). Returns eax. */
uint32_t m493af0_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x493af3 */
    L4 = ecx;
    /* 0x493af4 */
    L4 = ecx;
    /* 0x493af7 */
    eax = L4;
    /* 0x493afa */
    wr32(self, 8203, (uint32_t)(0x0u));
    /* 0x493b04 */
    ecx = (uint32_t)(0x5830a6u);
    /* 0x493b09 */
    eax = (uintptr_t)call0(host, 0x4dae66, (uintptr_t)(uint32_t)ecx);
    /* 0x493b0e */
    ecx = L4;
    /* 0x493b11 */
    wr32(self, 8195, (uint32_t)((uint32_t)eax));
    /* 0x493b17 */
    ecx = (uint32_t)(0x5830a6u);
    /* 0x493b1c */
    eax = (uintptr_t)call0(host, 0x4dae77, (uintptr_t)(uint32_t)ecx);
    /* 0x493b21 */
    edx = L4;
    /* 0x493b24 */
    wr32(self, 8199, (uint32_t)((uint32_t)eax));
    /* 0x493b2a */
    /* 0x493b2c */
    /* 0x493b2d */
    return (uint32_t)eax;
}

/* ---- 0x493b2e lifted ---- */
/* 0x493b2e, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1f77]/4. Stores to [self+0x2003]/4, [self+0x2007]/4, [self+0x200b]/4. Calls (in code order): 0x4dae66(this, 0 args), 0x4dae77(this, 0 args). eax is left-over and not meaningful. */
uint32_t m493b2e_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x493b31 */
    L4 = ecx;
    /* 0x493b32 */
    L4 = ecx;
    /* 0x493b35 */
    eax = L4;
    /* 0x493b38 */
    fa = rd32(self, 8055);
    fb = 0x0u;
    /* 0x493b3f */
    if (fa != fb) goto L493b43;
    /* 0x493b41 */
    goto L493b76;
L493b43:;
    /* 0x493b43 */
    ecx = L4;
    /* 0x493b46 */
    wr32(self, 8203, (uint32_t)(0x0u));
    /* 0x493b50 */
    ecx = (uint32_t)(0x5830a6u);
    /* 0x493b55 */
    eax = (uintptr_t)call0(host, 0x4dae66, (uintptr_t)(uint32_t)ecx);
    /* 0x493b5a */
    edx = L4;
    /* 0x493b5d */
    wr32(self, 8195, (uint32_t)((uint32_t)eax));
    /* 0x493b63 */
    ecx = (uint32_t)(0x5830a6u);
    /* 0x493b68 */
    eax = (uintptr_t)call0(host, 0x4dae77, (uintptr_t)(uint32_t)ecx);
    /* 0x493b6d */
    ecx = L4;
    /* 0x493b70 */
    wr32(self, 8199, (uint32_t)((uint32_t)eax));
L493b76:;
    /* 0x493b76 */
    /* 0x493b78 */
    /* 0x493b79 */
    return 0;
}

/* ---- 0x493c34 lifted ---- */
/* 0x493c34, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1ef7]/4, [self+0x47d1]/4, [self+0x1efb]/4. Stores to [self+0x1eff]/4, [self+0x1f03]/4, [self+0x1f07]/4, [self+0x1f0b]/4. Returns eax. */
uint32_t m493c34_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x493c37 */
    L4 = ecx;
    /* 0x493c38 */
    L4 = ecx;
    /* 0x493c3b */
    eax = L4;
    /* 0x493c3e */
    ecx = L4;
    /* 0x493c41 */
    edx = (uint32_t)(rd32(self, 7927));
    /* 0x493c47 */
    ecx = (uint32_t)(rd32(self, 18385));
    /* 0x493c4d */
    edx = (uint32_t)((uint32_t)(((uint32_t)((int32_t)((uint32_t)edx) >> (((uint32_t)ecx & 0xffu) & 31u))) & 0xffffffffu));
    /* 0x493c4f */
    eax = L4;
    /* 0x493c52 */
    wr32(self, 7935, (uint32_t)((uint32_t)edx));
    /* 0x493c58 */
    ecx = L4;
    /* 0x493c5b */
    edx = L4;
    /* 0x493c5e */
    eax = (uint32_t)(rd32(self, 7931));
    /* 0x493c64 */
    ecx = (uint32_t)(rd32(self, 18385));
    /* 0x493c6a */
    eax = (uint32_t)((uint32_t)(((uint32_t)((int32_t)((uint32_t)eax) >> (((uint32_t)ecx & 0xffu) & 31u))) & 0xffffffffu));
    /* 0x493c6c */
    ecx = L4;
    /* 0x493c6f */
    wr32(self, 7939, (uint32_t)((uint32_t)eax));
    /* 0x493c75 */
    edx = L4;
    /* 0x493c78 */
    eax = (uint32_t)(rd32(self, 7927));
    /* 0x493c7e */
    fa = ((uint32_t)((((uint32_t)eax) & (0x7fu)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x493c81 */
    ecx = L4;
    /* 0x493c84 */
    wr32(self, 7943, (uint32_t)((uint32_t)eax));
    /* 0x493c8a */
    edx = L4;
    /* 0x493c8d */
    eax = (uint32_t)(rd32(self, 7931));
    /* 0x493c93 */
    fa = ((uint32_t)((((uint32_t)eax) & (0x7fu)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x493c96 */
    ecx = L4;
    /* 0x493c99 */
    wr32(self, 7947, (uint32_t)((uint32_t)eax));
    /* 0x493c9f */
    /* 0x493ca1 */
    /* 0x493ca2 */
    return (uint32_t)eax;
}

/* ---- 0x495a5b lifted ---- */
/* 0x495a5b, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x4791]/4, [self+0x4795]/4. Stores to [self+0x4791]/4, [self+0x4795]/4. Globals: 0x58322d/1 (written). Calls (in code order): 0x49192b(this, 0 args), 0x4921a1(this, 0 args), 0x4922f4(this, 0 args), 0x4d36ed(0 args). Returns eax. */
uint32_t m495a5b_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x495a5e */
    L4 = ecx;
    /* 0x495a5f */
    L4 = ecx;
    /* 0x495a62 */
    eax = L4;
    /* 0x495a65 */
    ecx = (uint32_t)(rd32(self, 18321));
    /* 0x495a6b */
    edx = L4;
    /* 0x495a6e */
    fa = ((uint32_t)((((uint32_t)ecx) + (rd32(self, 18325))))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x495a74 */
    eax = L4;
    /* 0x495a77 */
    wr32(self, 18321, (uint32_t)((uint32_t)ecx));
    /* 0x495a7d */
    ecx = L4;
    /* 0x495a80 */
    fa = rd32(self, 18321);
    fb = 0x0u;
    /* 0x495a87 */
    if ((int32_t)fa >= (int32_t)fb) goto L495aa5;
    /* 0x495a89 */
    edx = L4;
    /* 0x495a8c */
    wr32(self, 18325, (uint32_t)(0x1u));
    /* 0x495a96 */
    eax = L4;
    /* 0x495a99 */
    wr32(self, 18321, (uint32_t)(0x1u));
    /* 0x495aa3 */
    goto L495acb;
L495aa5:;
    /* 0x495aa5 */
    ecx = L4;
    /* 0x495aa8 */
    fa = rd32(self, 18321);
    fb = 0x6u;
    /* 0x495aaf */
    if ((int32_t)fa < (int32_t)fb) goto L495acb;
    /* 0x495ab1 */
    edx = L4;
    /* 0x495ab4 */
    wr32(self, 18325, (uint32_t)(0xffffffffu));
    /* 0x495abe */
    eax = L4;
    /* 0x495ac1 */
    wr32(self, 18321, (uint32_t)(0x4u));
L495acb:;
    /* 0x495acb */
    ecx = L4;
    /* 0x495ace */
    eax = (uintptr_t)call0(host, 0x4921a1, ecx);
    /* 0x495ad3 */
    ecx = L4;
    /* 0x495ad6 */
    eax = (uintptr_t)call0(host, 0x4922f4, ecx);
    /* 0x495adb */
    ecx = L4;
    /* 0x495ade */
    eax = (uintptr_t)call0(host, 0x49192b, ecx);
    /* 0x495ae3 */
    eax = (uintptr_t)call0(host, 0x4d36ed, 0);
    /* 0x495ae8 */
    world->byte_58322d = (uint8_t)(0x0u);
    /* 0x495aef */
    /* 0x495af1 */
    /* 0x495af2 */
    return (uint32_t)eax;
}

/* ---- 0x49c46c lifted ---- */
/* 0x49c46c, ecx unused, plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x494ccc(this, 0 args), 0x4c952f(this, 1 arg). Returns eax. */
uint32_t m49c46c_lifted(const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = 0;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x49c46f */
    ecx = (uint32_t)(0x630a9au);
    /* 0x49c474 */
    eax = (uintptr_t)call0(host, 0x494ccc, (uintptr_t)(uint32_t)ecx);
    /* 0x49c479 */
    L4 = (uint32_t)(0x583186u);
    /* 0x49c47e */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x49c483 */
    eax = (uintptr_t)call1(host, 0x4c952f, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L4);
    /* 0x49c488 */
    /* 0x49c489 */
    return (uint32_t)eax;
}

/* ---- 0x49c68a lifted ---- */
/* 0x49c68a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0xde0]/4, [self+0xde4]/4, [self+0xdec]/4, [self+0xe30]/4, [self+0xe34]/4, [self+0xe38]/4, [self+0xe3c]/4, [self+0xe40]/4. ... Stores to [self+0xde0]/4, [self+0xde4]/4, [self+0xdec]/4, [self+0xe30]/4, [self+0xe34]/4, [self+0xe38]/4, [self+0xe3c]/4, [self+0xe40]/4. ... Calls (in code order): 0x49c5f0(this, 0 args), 0x51dc6c(1 arg). Returns eax. */
uint32_t m49c68a_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uintptr_t L24 = 0;
    uintptr_t L28 = 0;
    uintptr_t L32 = 0;
    uintptr_t L36 = 0;
    uintptr_t L40 = 0;
    uintptr_t L44 = 0;
    uintptr_t L48 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L24;
    (void)L28;
    (void)L32;
    (void)L36;
    (void)L4;
    (void)L40;
    (void)L44;
    (void)L48;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x49c68d */
    /* 0x49c690 */
    L44 = ecx;
    /* 0x49c693 */
    eax = L44;
    /* 0x49c696 */
    fa = rd32(self, 3552);
    fb = 0x0u;
    /* 0x49c69d */
    if (fa == fb) goto L49c6c4;
    /* 0x49c69f */
    ecx = L44;
    /* 0x49c6a2 */
    edx = (uint32_t)(rd32(self, 3552));
    /* 0x49c6a8 */
    L4 = (uint32_t)((uint32_t)edx);
    /* 0x49c6ab */
    eax = (uint32_t)((uint32_t)L4);
    /* 0x49c6ae */
    L48 = (uint32_t)((uint32_t)eax);
    /* 0x49c6af */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L48);
    /* 0x49c6b4 */
    /* 0x49c6b7 */
    ecx = L44;
    /* 0x49c6ba */
    wr32(self, 3552, (uint32_t)(0x0u));
L49c6c4:;
    /* 0x49c6c4 */
    edx = L44;
    /* 0x49c6c7 */
    fa = rd32(self, 3556);
    fb = 0x0u;
    /* 0x49c6ce */
    if (fa == fb) goto L49c6f5;
    /* 0x49c6d0 */
    eax = L44;
    /* 0x49c6d3 */
    ecx = (uint32_t)(rd32(self, 3556));
    /* 0x49c6d9 */
    L8 = (uint32_t)((uint32_t)ecx);
    /* 0x49c6dc */
    edx = (uint32_t)((uint32_t)L8);
    /* 0x49c6df */
    L48 = (uint32_t)((uint32_t)edx);
    /* 0x49c6e0 */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L48);
    /* 0x49c6e5 */
    /* 0x49c6e8 */
    eax = L44;
    /* 0x49c6eb */
    wr32(self, 3556, (uint32_t)(0x0u));
L49c6f5:;
    /* 0x49c6f5 */
    ecx = L44;
    /* 0x49c6f8 */
    fa = rd32(self, 3564);
    fb = 0x0u;
    /* 0x49c6ff */
    if (fa == fb) goto L49c726;
    /* 0x49c701 */
    edx = L44;
    /* 0x49c704 */
    eax = (uint32_t)(rd32(self, 3564));
    /* 0x49c70a */
    L12 = (uint32_t)((uint32_t)eax);
    /* 0x49c70d */
    ecx = (uint32_t)((uint32_t)L12);
    /* 0x49c710 */
    L48 = (uint32_t)((uint32_t)ecx);
    /* 0x49c711 */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L48);
    /* 0x49c716 */
    /* 0x49c719 */
    edx = L44;
    /* 0x49c71c */
    wr32(self, 3564, (uint32_t)(0x0u));
L49c726:;
    /* 0x49c726 */
    eax = L44;
    /* 0x49c729 */
    fa = rd32(self, 3632);
    fb = 0x0u;
    /* 0x49c730 */
    if (fa == fb) goto L49c757;
    /* 0x49c732 */
    ecx = L44;
    /* 0x49c735 */
    edx = (uint32_t)(rd32(self, 3632));
    /* 0x49c73b */
    L16 = (uint32_t)((uint32_t)edx);
    /* 0x49c73e */
    eax = (uint32_t)((uint32_t)L16);
    /* 0x49c741 */
    L48 = (uint32_t)((uint32_t)eax);
    /* 0x49c742 */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L48);
    /* 0x49c747 */
    /* 0x49c74a */
    ecx = L44;
    /* 0x49c74d */
    wr32(self, 3632, (uint32_t)(0x0u));
L49c757:;
    /* 0x49c757 */
    edx = L44;
    /* 0x49c75a */
    fa = rd32(self, 3636);
    fb = 0x0u;
    /* 0x49c761 */
    if (fa == fb) goto L49c788;
    /* 0x49c763 */
    eax = L44;
    /* 0x49c766 */
    ecx = (uint32_t)(rd32(self, 3636));
    /* 0x49c76c */
    L20 = (uint32_t)((uint32_t)ecx);
    /* 0x49c76f */
    edx = (uint32_t)((uint32_t)L20);
    /* 0x49c772 */
    L48 = (uint32_t)((uint32_t)edx);
    /* 0x49c773 */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L48);
    /* 0x49c778 */
    /* 0x49c77b */
    eax = L44;
    /* 0x49c77e */
    wr32(self, 3636, (uint32_t)(0x0u));
L49c788:;
    /* 0x49c788 */
    ecx = L44;
    /* 0x49c78b */
    fa = rd32(self, 3640);
    fb = 0x0u;
    /* 0x49c792 */
    if (fa == fb) goto L49c7b9;
    /* 0x49c794 */
    edx = L44;
    /* 0x49c797 */
    eax = (uint32_t)(rd32(self, 3640));
    /* 0x49c79d */
    L24 = (uint32_t)((uint32_t)eax);
    /* 0x49c7a0 */
    ecx = (uint32_t)((uint32_t)L24);
    /* 0x49c7a3 */
    L48 = (uint32_t)((uint32_t)ecx);
    /* 0x49c7a4 */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L48);
    /* 0x49c7a9 */
    /* 0x49c7ac */
    edx = L44;
    /* 0x49c7af */
    wr32(self, 3640, (uint32_t)(0x0u));
L49c7b9:;
    /* 0x49c7b9 */
    eax = L44;
    /* 0x49c7bc */
    fa = rd32(self, 3644);
    fb = 0x0u;
    /* 0x49c7c3 */
    if (fa == fb) goto L49c7ea;
    /* 0x49c7c5 */
    ecx = L44;
    /* 0x49c7c8 */
    edx = (uint32_t)(rd32(self, 3644));
    /* 0x49c7ce */
    L28 = (uint32_t)((uint32_t)edx);
    /* 0x49c7d1 */
    eax = (uint32_t)((uint32_t)L28);
    /* 0x49c7d4 */
    L48 = (uint32_t)((uint32_t)eax);
    /* 0x49c7d5 */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L48);
    /* 0x49c7da */
    /* 0x49c7dd */
    ecx = L44;
    /* 0x49c7e0 */
    wr32(self, 3644, (uint32_t)(0x0u));
L49c7ea:;
    /* 0x49c7ea */
    edx = L44;
    /* 0x49c7ed */
    fa = rd32(self, 3648);
    fb = 0x0u;
    /* 0x49c7f4 */
    if (fa == fb) goto L49c81b;
    /* 0x49c7f6 */
    eax = L44;
    /* 0x49c7f9 */
    ecx = (uint32_t)(rd32(self, 3648));
    /* 0x49c7ff */
    L32 = (uint32_t)((uint32_t)ecx);
    /* 0x49c802 */
    edx = (uint32_t)((uint32_t)L32);
    /* 0x49c805 */
    L48 = (uint32_t)((uint32_t)edx);
    /* 0x49c806 */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L48);
    /* 0x49c80b */
    /* 0x49c80e */
    eax = L44;
    /* 0x49c811 */
    wr32(self, 3648, (uint32_t)(0x0u));
L49c81b:;
    /* 0x49c81b */
    ecx = L44;
    /* 0x49c81e */
    fa = rd32(self, 3652);
    fb = 0x0u;
    /* 0x49c825 */
    if (fa == fb) goto L49c84c;
    /* 0x49c827 */
    edx = L44;
    /* 0x49c82a */
    eax = (uint32_t)(rd32(self, 3652));
    /* 0x49c830 */
    L36 = (uint32_t)((uint32_t)eax);
    /* 0x49c833 */
    ecx = (uint32_t)((uint32_t)L36);
    /* 0x49c836 */
    L48 = (uint32_t)((uint32_t)ecx);
    /* 0x49c837 */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L48);
    /* 0x49c83c */
    /* 0x49c83f */
    edx = L44;
    /* 0x49c842 */
    wr32(self, 3652, (uint32_t)(0x0u));
L49c84c:;
    /* 0x49c84c */
    eax = L44;
    /* 0x49c84f */
    fa = rd32(self, 3656);
    fb = 0x0u;
    /* 0x49c856 */
    if (fa == fb) goto L49c87d;
    /* 0x49c858 */
    ecx = L44;
    /* 0x49c85b */
    edx = (uint32_t)(rd32(self, 3656));
    /* 0x49c861 */
    L40 = (uint32_t)((uint32_t)edx);
    /* 0x49c864 */
    eax = (uint32_t)((uint32_t)L40);
    /* 0x49c867 */
    L48 = (uint32_t)((uint32_t)eax);
    /* 0x49c868 */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L48);
    /* 0x49c86d */
    /* 0x49c870 */
    ecx = L44;
    /* 0x49c873 */
    wr32(self, 3656, (uint32_t)(0x0u));
L49c87d:;
    /* 0x49c87d */
    ecx = L44;
    /* 0x49c880 */
    eax = (uintptr_t)call0(host, 0x49c5f0, ecx);
    /* 0x49c885 */
    /* 0x49c887 */
    /* 0x49c888 */
    return (uint32_t)eax;
}

/* ---- 0x4a1d14 lifted ---- */
/* 0x4a1d14, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x594d80/2 (written). Returns eax. */
uint32_t m4a1d14_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edi = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edi;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4a1d17 */
    L4 = ecx;
    /* 0x4a1d18 */
    /* 0x4a1d19 */
    L4 = ecx;
    /* 0x4a1d1c */
    world->word_594d80 = (uint16_t)(0x0u);
    /* 0x4a1d25 */
    ecx = (uint32_t)(0xbu);
    /* 0x4a1d2a */
    eax = (uint32_t)(0xffffffffu);
    fa = 0xffffffffu;
    /* 0x4a1d2d */
    edi = (uint32_t)(0x594d82u);
    /* 0x4a1d32 */
    rep_stos((world->table_594d82 + (0)), (uint32_t)eax, (uint32_t)ecx, 4);
    edi = (uint32_t)(edi + 44u);
    ecx = 0;
    /* 0x4a1d34 */
    rep_stos((world->table_594d82 + (44)), ((uint32_t)eax & 0xffu), 1u, 1);
    edi = (uint32_t)(edi + 1u);
    /* 0x4a1d35 */
    /* 0x4a1d36 */
    /* 0x4a1d38 */
    /* 0x4a1d39 */
    return (uint32_t)eax;
}

/* ---- 0x4a1e93 lifted ---- */
/* 0x4a1e93, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Globals: 0x5b44f0/4 (written), 0x5b44f4/4 (written), 0x5c39e5/4 (written), 0x5d0377/4, 0x5d162d/4 (written), 0x5d1631/4 (written), 0x5d1639/4 (written). Returns eax. */
uint32_t m4a1e93_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4a1e96 */
    L4 = ecx;
    /* 0x4a1e97 */
    L4 = ecx;
    /* 0x4a1e9a */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)A0 & 0xffffu)));
    /* 0x4a1e9e */
    fa = (uint32_t)eax;
    fb = 0x2760u;
    /* 0x4a1ea3 */
    if (fa != fb) goto L4a1ef7;
    /* 0x4a1ea5 */
    world->value_5b44f0 = (uint32_t)(0x9u);
    /* 0x4a1eaf */
    ecx = (uint32_t)(world->value_5d0377);
    /* 0x4a1eb5 */
    world->value_5d162d = (uint32_t)((uint32_t)ecx);
    /* 0x4a1ebb */
    world->value_5b44f4 = (uint32_t)(0x1u);
    /* 0x4a1ec5 */
    edx = (uint32_t)(world->value_5b44f0);
    /* 0x4a1ecb */
    fa = ((uint32_t)((((uint32_t)edx) << 5u) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a1ece */
    eax = (uint32_t)(world->value_5b44f4);
    /* 0x4a1ed3 */
    fa = ((uint32_t)((((uint32_t)eax) << 4u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a1ed6 */
    ecx = (uint32_t)((uint32_t)edx + (uint32_t)eax + (uint32_t)5969420);
    /* 0x4a1edd */
    world->value_5d1631 = (uint32_t)((uint32_t)ecx);
    /* 0x4a1ee3 */
    world->value_5d1639 = (uint32_t)(0x1u);
    /* 0x4a1eed */
    world->value_5c39e5 = (uint32_t)(0x2760u);
L4a1ef7:;
    /* 0x4a1ef7 */
    /* 0x4a1ef9 */
    /* 0x4a1efa */
    return (uint32_t)eax;
}

/* ---- 0x4a1fd1 lifted ---- */
/* 0x4a1fd1, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x20]/4, [r1+0x14f]/2, [r1+0x151]/2, [r1+0x14d]/2. Stores to [self+0x4c]/4, [self+0x58]/1. Globals: 0x58c94f/2. Returns this. */
uint8_t * m4a1fd1_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4a1fd4 */
    /* 0x4a1fd7 */
    L12 = ecx;
    /* 0x4a1fda */
    L8 = (uint32_t)(0x0u);
    /* 0x4a1fe1 */
    eax = L12;
    /* 0x4a1fe4 */
    ecx = (uint32_t)(rd32(self, 32));
    /* 0x4a1fe7 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(res(host, (uint32_t)ecx), 335)));
    /* 0x4a1fee */
    L4 = (uint32_t)((uint32_t)edx);
    /* 0x4a1ff1 */
    goto L4a1ffc;
L4a1ff3:;
    /* 0x4a1ff3 */
    eax = (uint32_t)((uint32_t)L4);
    /* 0x4a1ff6 */
    fa = ((uint32_t)((((uint32_t)eax) + (0x1u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a1ff9 */
    L4 = (uint32_t)((uint32_t)eax);
L4a1ffc:;
    /* 0x4a1ffc */
    ecx = L12;
    /* 0x4a1fff */
    edx = (uint32_t)(rd32(self, 32));
    /* 0x4a2002 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(res(host, (uint32_t)edx), 335)));
    /* 0x4a2009 */
    ecx = L12;
    /* 0x4a200c */
    edx = (uint32_t)(rd32(self, 32));
    /* 0x4a200f */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(res(host, (uint32_t)edx), 337)));
    /* 0x4a2016 */
    fa = ((uint32_t)((((uint32_t)eax) + ((uint32_t)ecx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a2018 */
    fa = (uint32_t)L4;
    fb = (uint32_t)eax;
    /* 0x4a201b */
    if ((int32_t)fa >= (int32_t)fb) goto L4a2042;
    /* 0x4a201d */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_58c94f));
    /* 0x4a2024 */
    edx = (uint32_t)((uint32_t)((uint32_t)((uint32_t)edx) * (uint32_t)(0xfu)));
    /* 0x4a2027 */
    eax = (uint32_t)((uint32_t)L4);
    /* 0x4a202a */
    ecx = (uint32_t)((uint32_t)(int32_t)(int8_t)((uint32_t)(world->table_594d82)[(ptrdiff_t)(int32_t)((uint32_t)edx + (uint32_t)eax + 0u)]));
    /* 0x4a2032 */
    fa = (uint32_t)ecx;
    fb = 0x1u;
    /* 0x4a2035 */
    if (fa != fb) goto L4a2040;
    /* 0x4a2037 */
    edx = (uint32_t)((uint32_t)L8);
    /* 0x4a203a */
    fa = ((uint32_t)((((uint32_t)edx) + (0x1u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a203d */
    L8 = (uint32_t)((uint32_t)edx);
L4a2040:;
    /* 0x4a2040 */
    goto L4a1ff3;
L4a2042:;
    /* 0x4a2042 */
    eax = L12;
    /* 0x4a2045 */
    ecx = (uint32_t)(rd32(self, 32));
    /* 0x4a2048 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(res(host, (uint32_t)ecx), 333)));
    /* 0x4a204f */
    fa = (uint32_t)L8;
    fb = (uint32_t)edx;
    /* 0x4a2052 */
    if ((int32_t)fa < (int32_t)fb) goto L4a2065;
    /* 0x4a2054 */
    eax = L12;
    /* 0x4a2057 */
    self[88] = (uint8_t)(0x1u);
    /* 0x4a205b */
    ecx = L12;
    /* 0x4a205e */
    wr32(self, 76, (uint32_t)(0x4u));
L4a2065:;
    /* 0x4a2065 */
    /* 0x4a2067 */
    /* 0x4a2068 */
    return (uint8_t *)eax;
}

/* ---- 0x4a378a lifted ---- */
/* 0x4a378a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x1c]/2, [self+0x1e]/2, [self+0x200]/4, [self+0x210]/2, [self+0x212]/2, [self+0x214]/2, [self+0x216]/2, [self+0x258]/4. ... eax is left-over and not meaningful. */
uint32_t m4a378a_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4a378d */
    /* 0x4a3790 */
    L8 = ecx;
    /* 0x4a3793 */
    eax = L8;
    /* 0x4a3796 */
    wr16(self, 30, (uint16_t)(0xffffu));
    /* 0x4a379c */
    ecx = L8;
    /* 0x4a379f */
    wr16(self, 28, (uint16_t)(0xffffu));
    /* 0x4a37a5 */
    edx = L8;
    /* 0x4a37a8 */
    wr32(self, 622, (uint32_t)(0x0u));
    /* 0x4a37b2 */
    eax = L8;
    /* 0x4a37b5 */
    wr16(self, 630, (uint16_t)(0xffffu));
    /* 0x4a37be */
    ecx = L8;
    /* 0x4a37c1 */
    wr16(self, 632, (uint16_t)(0xffffu));
    /* 0x4a37ca */
    edx = L8;
    /* 0x4a37cd */
    self[634] = (uint8_t)(0x0u);
    /* 0x4a37d4 */
    eax = L8;
    /* 0x4a37d7 */
    self[639] = (uint8_t)(0x0u);
    /* 0x4a37de */
    ecx = L8;
    /* 0x4a37e1 */
    wr32(self, 608, (uint32_t)(0x0u));
    /* 0x4a37eb */
    edx = L8;
    /* 0x4a37ee */
    wr32(self, 626, (uint32_t)(0x0u));
    /* 0x4a37f8 */
    eax = L8;
    /* 0x4a37fb */
    wr16(self, 528, (uint16_t)(0xffffu));
    /* 0x4a3804 */
    ecx = L8;
    /* 0x4a3807 */
    wr16(self, 530, (uint16_t)(0xffffu));
    /* 0x4a3810 */
    edx = L8;
    /* 0x4a3813 */
    wr16(self, 532, (uint16_t)(0xffffu));
    /* 0x4a381c */
    eax = L8;
    /* 0x4a381f */
    wr16(self, 534, (uint16_t)(0xffffu));
    /* 0x4a3828 */
    ecx = L8;
    /* 0x4a382b */
    wr32(self, 600, (uint32_t)(0x0u));
    /* 0x4a3835 */
    edx = L8;
    /* 0x4a3838 */
    wr32(self, 604, (uint32_t)(0x0u));
    /* 0x4a3842 */
    eax = L8;
    /* 0x4a3845 */
    wr32(self, 614, (uint32_t)(0x0u));
    /* 0x4a384f */
    L4 = (uint32_t)((0x0u) & 0xffffu);
    /* 0x4a3855 */
    goto L4a3863;
L4a3857:;
    /* 0x4a3857 */
    ecx = (uint32_t)((((uint32_t)L4 & 0xffffu)) & 0xffffu);
    /* 0x4a385b */
    fa = ((uint32_t)(((((uint32_t)ecx & 0xffffu)) + (0x1u)) & 0xffffu)) & 0xffffu;
    ecx = (uint32_t)((fa) & 0xffffu);
    /* 0x4a385f */
    L4 = (uint32_t)((((uint32_t)ecx & 0xffffu)) & 0xffffu);
L4a3863:;
    /* 0x4a3863 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4a3867 */
    fa = (uint32_t)edx;
    fb = 0x4u;
    /* 0x4a386a */
    if ((int32_t)fa >= (int32_t)fb) goto L4a3880;
    /* 0x4a386c */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4a3870 */
    ecx = L8;
    /* 0x4a3873 */
    wr32(self, 512 + (ptrdiff_t)(int32_t)((uint32_t)eax * 4u), (uint32_t)(0x0u));
    /* 0x4a387e */
    goto L4a3857;
L4a3880:;
    /* 0x4a3880 */
    /* 0x4a3882 */
    /* 0x4a3883 */
    return 0;
}

/* ---- 0x4a39c4 lifted ---- */
/* 0x4a39c4, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x210]/2, [self+0x212]/2, [self+0x214]/2, [self+0x216]/2, [self+0x258]/4, [self+0x25c]/4, [self+0x260]/4, [self+0x272]/4. Returns this. */
uint8_t * m4a39c4_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x4a39c7 */
    L4 = ecx;
    /* 0x4a39c8 */
    L4 = ecx;
    /* 0x4a39cb */
    eax = L4;
    /* 0x4a39ce */
    wr32(self, 604, (uint32_t)(0x0u));
    /* 0x4a39d8 */
    ecx = L4;
    /* 0x4a39db */
    wr32(self, 600, (uint32_t)(0x0u));
    /* 0x4a39e5 */
    edx = L4;
    /* 0x4a39e8 */
    wr32(self, 626, (uint32_t)(0x0u));
    /* 0x4a39f2 */
    eax = L4;
    /* 0x4a39f5 */
    wr16(self, 528, (uint16_t)(0xffffu));
    /* 0x4a39fe */
    ecx = L4;
    /* 0x4a3a01 */
    wr16(self, 530, (uint16_t)(0xffffu));
    /* 0x4a3a0a */
    edx = L4;
    /* 0x4a3a0d */
    wr16(self, 532, (uint16_t)(0xffffu));
    /* 0x4a3a16 */
    eax = L4;
    /* 0x4a3a19 */
    wr16(self, 534, (uint16_t)(0xffffu));
    /* 0x4a3a22 */
    ecx = L4;
    /* 0x4a3a25 */
    wr32(self, 608, (uint32_t)(0x0u));
    /* 0x4a3a2f */
    /* 0x4a3a31 */
    /* 0x4a3a32 */
    return (uint8_t *)eax;
}

/* ---- 0x4a3beb lifted ---- */
/* 0x4a3beb, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x288]/4, [self+0x280]/4, [self+0x28c]/4, [self+0x284]/4, [self+0x272]/4, [self+0x22c]/4, [self+0x234]/4, [self+0x228]/4. ... Stores to [self+0x218]/4, [self+0x21c]/4, [self+0x220]/4, [self+0x224]/4, [self+0x228]/4, [self+0x22c]/4, [self+0x230]/4, [self+0x234]/4. ... Globals: 0x583186/4, 0x58318a/4. Calls (in code order): 0x4a3aec(this, 0 args). Returns this. */
uint8_t * m4a3beb_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4a3bee */
    /* 0x4a3bf1 */
    L12 = ecx;
    /* 0x4a3bf4 */
    eax = L12;
    /* 0x4a3bf7 */
    ecx = L12;
    /* 0x4a3bfa */
    eax = (uint32_t)(rd32(self, 648));
    /* 0x4a3c00 */
    fa = ((uint32_t)((((uint32_t)eax) - (rd32(self, 640))))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a3c06 */
    edx = (uint32_t)((((int32_t)((uint32_t)eax) < 0) ? 0xffffffffu : 0u));
    /* 0x4a3c07 */
    fa = ((uint32_t)((((uint32_t)eax) - ((uint32_t)edx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a3c09 */
    fa = ((uint32_t)(((uint32_t)((int32_t)((uint32_t)eax) >> 1u)) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a3c0b */
    edx = L12;
    /* 0x4a3c0e */
    fa = ((uint32_t)((((uint32_t)eax) + (rd32(self, 640))))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a3c14 */
    L8 = (uint32_t)((uint32_t)eax);
    /* 0x4a3c17 */
    eax = L12;
    /* 0x4a3c1a */
    ecx = L12;
    /* 0x4a3c1d */
    eax = (uint32_t)(rd32(self, 652));
    /* 0x4a3c23 */
    fa = ((uint32_t)((((uint32_t)eax) - (rd32(self, 644))))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a3c29 */
    edx = (uint32_t)((((int32_t)((uint32_t)eax) < 0) ? 0xffffffffu : 0u));
    /* 0x4a3c2a */
    fa = ((uint32_t)((((uint32_t)eax) - ((uint32_t)edx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a3c2c */
    fa = ((uint32_t)(((uint32_t)((int32_t)((uint32_t)eax) >> 1u)) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a3c2e */
    edx = L12;
    /* 0x4a3c31 */
    fa = ((uint32_t)((((uint32_t)eax) + (rd32(self, 644))))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a3c37 */
    L4 = (uint32_t)((uint32_t)eax);
    /* 0x4a3c3a */
    eax = L12;
    /* 0x4a3c3d */
    fa = rd32(self, 626);
    fb = 0x0u;
    /* 0x4a3c44 */
    if (fa == fb) goto L4a3db3;
    /* 0x4a3c4a */
    ecx = L12;
    /* 0x4a3c4d */
    edx = L12;
    /* 0x4a3c50 */
    eax = (uint32_t)(rd32(self, 556));
    /* 0x4a3c56 */
    wr32(self, 540, (uint32_t)((uint32_t)eax));
    /* 0x4a3c5c */
    ecx = L12;
    /* 0x4a3c5f */
    edx = L12;
    /* 0x4a3c62 */
    eax = (uint32_t)(rd32(self, 564));
    /* 0x4a3c68 */
    wr32(self, 548, (uint32_t)((uint32_t)eax));
    /* 0x4a3c6e */
    ecx = L12;
    /* 0x4a3c71 */
    edx = L12;
    /* 0x4a3c74 */
    eax = (uint32_t)(rd32(self, 552));
    /* 0x4a3c7a */
    wr32(self, 536, (uint32_t)((uint32_t)eax));
    /* 0x4a3c80 */
    ecx = L12;
    /* 0x4a3c83 */
    edx = L12;
    /* 0x4a3c86 */
    eax = (uint32_t)(rd32(self, 560));
    /* 0x4a3c8c */
    wr32(self, 544, (uint32_t)((uint32_t)eax));
    /* 0x4a3c92 */
    ecx = L12;
    /* 0x4a3c95 */
    edx = L12;
    /* 0x4a3c98 */
    eax = (uint32_t)(rd32(self, 588));
    /* 0x4a3c9e */
    wr32(self, 572, (uint32_t)((uint32_t)eax));
    /* 0x4a3ca4 */
    ecx = L12;
    /* 0x4a3ca7 */
    edx = L12;
    /* 0x4a3caa */
    eax = (uint32_t)(rd32(self, 596));
    /* 0x4a3cb0 */
    wr32(self, 580, (uint32_t)((uint32_t)eax));
    /* 0x4a3cb6 */
    ecx = L12;
    /* 0x4a3cb9 */
    edx = L12;
    /* 0x4a3cbc */
    eax = (uint32_t)(rd32(self, 584));
    /* 0x4a3cc2 */
    wr32(self, 568, (uint32_t)((uint32_t)eax));
    /* 0x4a3cc8 */
    ecx = L12;
    /* 0x4a3ccb */
    edx = L12;
    /* 0x4a3cce */
    eax = (uint32_t)(rd32(self, 592));
    /* 0x4a3cd4 */
    wr32(self, 576, (uint32_t)((uint32_t)eax));
    /* 0x4a3cda */
    ecx = L12;
    /* 0x4a3cdd */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 2102)));
    /* 0x4a3ce4 */
    eax = (uint32_t)((uint32_t)L4);
    /* 0x4a3ce7 */
    fa = ((uint32_t)((((uint32_t)eax) - ((uint32_t)edx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a3ce9 */
    ecx = L12;
    /* 0x4a3cec */
    wr32(self, 556, (uint32_t)((uint32_t)eax));
    /* 0x4a3cf2 */
    edx = L12;
    /* 0x4a3cf5 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 2098)));
    /* 0x4a3cfc */
    ecx = L12;
    /* 0x4a3cff */
    edx = (uint32_t)(rd32(self, 556));
    /* 0x4a3d05 */
    fa = ((uint32_t)((((uint32_t)edx) + ((uint32_t)eax)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a3d07 */
    eax = L12;
    /* 0x4a3d0a */
    wr32(self, 564, (uint32_t)((uint32_t)edx));
    /* 0x4a3d10 */
    ecx = L12;
    /* 0x4a3d13 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 2100)));
    /* 0x4a3d1a */
    eax = (uint32_t)((uint32_t)L8);
    /* 0x4a3d1d */
    fa = ((uint32_t)((((uint32_t)eax) - ((uint32_t)edx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a3d1f */
    ecx = L12;
    /* 0x4a3d22 */
    wr32(self, 552, (uint32_t)((uint32_t)eax));
    /* 0x4a3d28 */
    edx = L12;
    /* 0x4a3d2b */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 2096)));
    /* 0x4a3d32 */
    ecx = L12;
    /* 0x4a3d35 */
    edx = (uint32_t)(rd32(self, 552));
    /* 0x4a3d3b */
    fa = ((uint32_t)((((uint32_t)edx) + ((uint32_t)eax)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a3d3d */
    eax = L12;
    /* 0x4a3d40 */
    wr32(self, 560, (uint32_t)((uint32_t)edx));
    /* 0x4a3d46 */
    ecx = L12;
    /* 0x4a3d49 */
    eax = (uintptr_t)call0(host, 0x4a3aec, ecx);
    /* 0x4a3d4e */
    ecx = L12;
    /* 0x4a3d51 */
    edx = (uint32_t)(rd32(self, 556));
    /* 0x4a3d57 */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_58318a)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a3d5d */
    eax = L12;
    /* 0x4a3d60 */
    wr32(self, 588, (uint32_t)((uint32_t)edx));
    /* 0x4a3d66 */
    ecx = L12;
    /* 0x4a3d69 */
    edx = (uint32_t)(rd32(self, 564));
    /* 0x4a3d6f */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_58318a)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a3d75 */
    eax = L12;
    /* 0x4a3d78 */
    wr32(self, 596, (uint32_t)((uint32_t)edx));
    /* 0x4a3d7e */
    ecx = L12;
    /* 0x4a3d81 */
    edx = (uint32_t)(rd32(self, 552));
    /* 0x4a3d87 */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_583186)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a3d8d */
    eax = L12;
    /* 0x4a3d90 */
    wr32(self, 584, (uint32_t)((uint32_t)edx));
    /* 0x4a3d96 */
    ecx = L12;
    /* 0x4a3d99 */
    edx = (uint32_t)(rd32(self, 560));
    /* 0x4a3d9f */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_583186)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a3da5 */
    eax = L12;
    /* 0x4a3da8 */
    wr32(self, 592, (uint32_t)((uint32_t)edx));
    /* 0x4a3dae */
    goto L4a3f3c;
L4a3db3:;
    /* 0x4a3db3 */
    ecx = L12;
    /* 0x4a3db6 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 2102)));
    /* 0x4a3dbd */
    eax = (uint32_t)((uint32_t)L4);
    /* 0x4a3dc0 */
    fa = ((uint32_t)((((uint32_t)eax) - ((uint32_t)edx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a3dc2 */
    ecx = L12;
    /* 0x4a3dc5 */
    wr32(self, 556, (uint32_t)((uint32_t)eax));
    /* 0x4a3dcb */
    edx = L12;
    /* 0x4a3dce */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 2098)));
    /* 0x4a3dd5 */
    ecx = L12;
    /* 0x4a3dd8 */
    edx = (uint32_t)(rd32(self, 556));
    /* 0x4a3dde */
    fa = ((uint32_t)((((uint32_t)edx) + ((uint32_t)eax)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a3de0 */
    eax = L12;
    /* 0x4a3de3 */
    wr32(self, 564, (uint32_t)((uint32_t)edx));
    /* 0x4a3de9 */
    ecx = L12;
    /* 0x4a3dec */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 2100)));
    /* 0x4a3df3 */
    eax = (uint32_t)((uint32_t)L8);
    /* 0x4a3df6 */
    fa = ((uint32_t)((((uint32_t)eax) - ((uint32_t)edx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a3df8 */
    ecx = L12;
    /* 0x4a3dfb */
    wr32(self, 552, (uint32_t)((uint32_t)eax));
    /* 0x4a3e01 */
    edx = L12;
    /* 0x4a3e04 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 2096)));
    /* 0x4a3e0b */
    ecx = L12;
    /* 0x4a3e0e */
    edx = (uint32_t)(rd32(self, 552));
    /* 0x4a3e14 */
    fa = ((uint32_t)((((uint32_t)edx) + ((uint32_t)eax)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a3e16 */
    eax = L12;
    /* 0x4a3e19 */
    wr32(self, 560, (uint32_t)((uint32_t)edx));
    /* 0x4a3e1f */
    ecx = L12;
    /* 0x4a3e22 */
    eax = (uintptr_t)call0(host, 0x4a3aec, ecx);
    /* 0x4a3e27 */
    ecx = L12;
    /* 0x4a3e2a */
    edx = L12;
    /* 0x4a3e2d */
    eax = (uint32_t)(rd32(self, 556));
    /* 0x4a3e33 */
    wr32(self, 540, (uint32_t)((uint32_t)eax));
    /* 0x4a3e39 */
    ecx = L12;
    /* 0x4a3e3c */
    edx = L12;
    /* 0x4a3e3f */
    eax = (uint32_t)(rd32(self, 564));
    /* 0x4a3e45 */
    wr32(self, 548, (uint32_t)((uint32_t)eax));
    /* 0x4a3e4b */
    ecx = L12;
    /* 0x4a3e4e */
    edx = L12;
    /* 0x4a3e51 */
    eax = (uint32_t)(rd32(self, 552));
    /* 0x4a3e57 */
    wr32(self, 536, (uint32_t)((uint32_t)eax));
    /* 0x4a3e5d */
    ecx = L12;
    /* 0x4a3e60 */
    edx = L12;
    /* 0x4a3e63 */
    eax = (uint32_t)(rd32(self, 560));
    /* 0x4a3e69 */
    wr32(self, 544, (uint32_t)((uint32_t)eax));
    /* 0x4a3e6f */
    ecx = L12;
    /* 0x4a3e72 */
    edx = (uint32_t)(rd32(self, 556));
    /* 0x4a3e78 */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_58318a)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a3e7e */
    eax = L12;
    /* 0x4a3e81 */
    wr32(self, 588, (uint32_t)((uint32_t)edx));
    /* 0x4a3e87 */
    ecx = L12;
    /* 0x4a3e8a */
    edx = (uint32_t)(rd32(self, 564));
    /* 0x4a3e90 */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_58318a)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a3e96 */
    eax = L12;
    /* 0x4a3e99 */
    wr32(self, 596, (uint32_t)((uint32_t)edx));
    /* 0x4a3e9f */
    ecx = L12;
    /* 0x4a3ea2 */
    edx = (uint32_t)(rd32(self, 552));
    /* 0x4a3ea8 */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_583186)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a3eae */
    eax = L12;
    /* 0x4a3eb1 */
    wr32(self, 584, (uint32_t)((uint32_t)edx));
    /* 0x4a3eb7 */
    ecx = L12;
    /* 0x4a3eba */
    edx = (uint32_t)(rd32(self, 560));
    /* 0x4a3ec0 */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_583186)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a3ec6 */
    eax = L12;
    /* 0x4a3ec9 */
    wr32(self, 592, (uint32_t)((uint32_t)edx));
    /* 0x4a3ecf */
    ecx = L12;
    /* 0x4a3ed2 */
    edx = (uint32_t)(rd32(self, 540));
    /* 0x4a3ed8 */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_58318a)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a3ede */
    eax = L12;
    /* 0x4a3ee1 */
    wr32(self, 572, (uint32_t)((uint32_t)edx));
    /* 0x4a3ee7 */
    ecx = L12;
    /* 0x4a3eea */
    edx = (uint32_t)(rd32(self, 548));
    /* 0x4a3ef0 */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_58318a)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a3ef6 */
    eax = L12;
    /* 0x4a3ef9 */
    wr32(self, 580, (uint32_t)((uint32_t)edx));
    /* 0x4a3eff */
    ecx = L12;
    /* 0x4a3f02 */
    edx = (uint32_t)(rd32(self, 536));
    /* 0x4a3f08 */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_583186)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a3f0e */
    eax = L12;
    /* 0x4a3f11 */
    wr32(self, 568, (uint32_t)((uint32_t)edx));
    /* 0x4a3f17 */
    ecx = L12;
    /* 0x4a3f1a */
    edx = (uint32_t)(rd32(self, 544));
    /* 0x4a3f20 */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_583186)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a3f26 */
    eax = L12;
    /* 0x4a3f29 */
    wr32(self, 576, (uint32_t)((uint32_t)edx));
    /* 0x4a3f2f */
    ecx = L12;
    /* 0x4a3f32 */
    wr32(self, 626, (uint32_t)(0x1u));
L4a3f3c:;
    /* 0x4a3f3c */
    /* 0x4a3f3e */
    /* 0x4a3f3f */
    return (uint8_t *)eax;
}

/* ---- 0x4a63dc lifted ---- */
/* 0x4a63dc, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x34]/4, [self+0x38]/4, [self+0x3c]/4, [self+0x1c]/2. Stores to [self+0x34]/4, [self+0x38]/4, [self+0x3c]/4. Calls (in code order): 0x4a638a(this, 0 args), 0x4c2dfb(this, 1 arg), 0x4d3992(1 arg). Returns eax. */
uint32_t m4a63dc_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4a63df */
    L4 = ecx;
    /* 0x4a63e0 */
    L4 = ecx;
    /* 0x4a63e3 */
    eax = L4;
    /* 0x4a63e6 */
    fa = rd32(self, 52);
    fb = 0x0u;
    /* 0x4a63ea */
    if (fa == fb) goto L4a63fd;
    /* 0x4a63ec */
    ecx = L4;
    /* 0x4a63ef */
    ecx = (uintptr_t)(self + (52));
    /* 0x4a63f2 */
    L8 = ecx;
    /* 0x4a63f3 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4a63f8 */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, L8);
L4a63fd:;
    /* 0x4a63fd */
    edx = L4;
    /* 0x4a6400 */
    fa = rd32(self, 56);
    fb = 0x0u;
    /* 0x4a6404 */
    if (fa == fb) goto L4a6417;
    /* 0x4a6406 */
    eax = L4;
    /* 0x4a6409 */
    eax = (uintptr_t)(self + (56));
    /* 0x4a640c */
    L8 = eax;
    /* 0x4a640d */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4a6412 */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, L8);
L4a6417:;
    /* 0x4a6417 */
    ecx = L4;
    /* 0x4a641a */
    fa = rd32(self, 60);
    fb = 0x0u;
    /* 0x4a641e */
    if (fa == fb) goto L4a6431;
    /* 0x4a6420 */
    edx = L4;
    /* 0x4a6423 */
    edx = (uintptr_t)(self + (60));
    /* 0x4a6426 */
    L8 = edx;
    /* 0x4a6427 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4a642c */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, L8);
L4a6431:;
    /* 0x4a6431 */
    eax = L4;
    /* 0x4a6434 */
    wr32(self, 52, (uint32_t)(0x0u));
    /* 0x4a643b */
    ecx = L4;
    /* 0x4a643e */
    wr32(self, 56, (uint32_t)(0x0u));
    /* 0x4a6445 */
    edx = L4;
    /* 0x4a6448 */
    wr32(self, 60, (uint32_t)(0x0u));
    /* 0x4a644f */
    eax = L4;
    /* 0x4a6452 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 28)));
    /* 0x4a6456 */
    fa = (uint32_t)ecx;
    fb = 0xffffffffu;
    /* 0x4a6459 */
    if (fa == fb) goto L4a646b;
    /* 0x4a645b */
    edx = L4;
    /* 0x4a645e */
    eax = (uint32_t)(((uint32_t)rd16(self, 28)) & 0xffffu);
    /* 0x4a6462 */
    L8 = (uint32_t)(uint32_t)eax;
    /* 0x4a6463 */
    eax = (uintptr_t)call1(host, 0x4d3992, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4a6468 */
L4a646b:;
    /* 0x4a646b */
    ecx = L4;
    /* 0x4a646e */
    eax = (uintptr_t)call0(host, 0x4a638a, ecx);
    /* 0x4a6473 */
    /* 0x4a6475 */
    /* 0x4a6476 */
    return (uint32_t)eax;
}

/* ---- 0x4a7994 lifted ---- */
/* 0x4a7994, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5cf665/4, 0x5d15e3/4, 0x61d3d1/4, 0x61d3e5/4, 0x61d3ed/4, 0x61d3bf/2. Calls (in code order): 0x4c5377(this, 5 args). Returns eax. */
uint32_t m4a7994_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uintptr_t L24 = 0;
    uintptr_t L28 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L24;
    (void)L28;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4a7997 */
    /* 0x4a799a */
    L8 = ecx;
    /* 0x4a799d */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_61d3bf));
    /* 0x4a79a4 */
    eax = (uint32_t)((uint32_t)((uint32_t)((uint32_t)eax) * (uint32_t)(0x8du)));
    /* 0x4a79aa */
    ecx = (uint32_t)(rd32(world->table_5bb5e5, (ptrdiff_t)(int32_t)((uint32_t)eax + 0u)));
    /* 0x4a79b0 */
    L4 = (uint32_t)((uint32_t)ecx);
    /* 0x4a79b3 */
    fa = world->value_61d3e5;
    fb = 0x0u;
    /* 0x4a79ba */
    if (fa != fb) goto L4a79ef;
    /* 0x4a79bc */
    fa = world->value_61d3ed;
    fb = 0x0u;
    /* 0x4a79c3 */
    if (fa != fb) goto L4a79ef;
    /* 0x4a79c5 */
    L12 = (uint32_t)(0x550a5cu);
    /* 0x4a79ca */
    L16 = (uint32_t)(0x61d3f1u);
    /* 0x4a79cf */
    edx = (uint32_t)((uint32_t)L4);
    /* 0x4a79d2 */
    fa = ((uint32_t)((((uint32_t)edx) + (0x66u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a79d5 */
    L20 = (uint32_t)((uint32_t)edx);
    /* 0x4a79d6 */
    eax = (uint32_t)(world->value_5cf665);
    /* 0x4a79db */
    L24 = (uint32_t)((uint32_t)eax);
    /* 0x4a79dc */
    ecx = (uint32_t)(world->value_5d15e3);
    /* 0x4a79e2 */
    L28 = (uint32_t)((uint32_t)ecx);
    /* 0x4a79e3 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4a79e8 */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L28, (uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12};
        eax = (uintptr_t)callv(host, 0x4c5377, (uintptr_t)(uint32_t)ecx, cargs, 5);
    }
    /* 0x4a79ed */
    goto L4a7a15;
L4a79ef:;
    /* 0x4a79ef */
    L12 = (uint32_t)(0x550a78u);
    /* 0x4a79f4 */
    L16 = (uint32_t)(0x61d3f1u);
    /* 0x4a79f9 */
    L20 = (uint32_t)(0x61d3e1u);
    /* 0x4a79fe */
    edx = (uint32_t)(world->value_5cf665);
    /* 0x4a7a04 */
    L24 = (uint32_t)((uint32_t)edx);
    /* 0x4a7a05 */
    eax = (uint32_t)(world->value_61d3d1);
    /* 0x4a7a0a */
    L28 = (uint32_t)((uint32_t)eax);
    /* 0x4a7a0b */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4a7a10 */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L28, (uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12};
        eax = (uintptr_t)callv(host, 0x4c5377, (uintptr_t)(uint32_t)ecx, cargs, 5);
    }
L4a7a15:;
    /* 0x4a7a15 */
    /* 0x4a7a17 */
    /* 0x4a7a18 */
    return (uint32_t)eax;
}

/* ---- 0x4a7c7a lifted ---- */
/* 0x4a7c7a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x1c]/2, [self+0x1e]/2, [self+0xe10]/2, [self+0xe56]/4, [self+0xe5a]/4, [self+0xe5e]/4, [self+0xe62]/4, [self+0xe72]/4. ... Returns this. */
uint8_t * m4a7c7a_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x4a7c7d */
    L4 = ecx;
    /* 0x4a7c7e */
    L4 = ecx;
    /* 0x4a7c81 */
    eax = L4;
    /* 0x4a7c84 */
    wr16(self, 30, (uint16_t)(0xffffu));
    /* 0x4a7c8a */
    ecx = L4;
    /* 0x4a7c8d */
    wr16(self, 28, (uint16_t)(0xffffu));
    /* 0x4a7c93 */
    edx = L4;
    /* 0x4a7c96 */
    wr32(self, 3698, (uint32_t)(0x0u));
    /* 0x4a7ca0 */
    eax = L4;
    /* 0x4a7ca3 */
    wr16(self, 3708, (uint16_t)(0xffffu));
    /* 0x4a7cac */
    ecx = L4;
    /* 0x4a7caf */
    wr16(self, 3706, (uint16_t)(0xffffu));
    /* 0x4a7cb8 */
    edx = L4;
    /* 0x4a7cbb */
    self[3710] = (uint8_t)(0x0u);
    /* 0x4a7cc2 */
    eax = L4;
    /* 0x4a7cc5 */
    self[3715] = (uint8_t)(0x0u);
    /* 0x4a7ccc */
    ecx = L4;
    /* 0x4a7ccf */
    wr32(self, 3678, (uint32_t)(0x0u));
    /* 0x4a7cd9 */
    edx = L4;
    /* 0x4a7cdc */
    wr32(self, 3702, (uint32_t)(0x0u));
    /* 0x4a7ce6 */
    eax = L4;
    /* 0x4a7ce9 */
    wr16(self, 3600, (uint16_t)(0xffffu));
    /* 0x4a7cf2 */
    ecx = L4;
    /* 0x4a7cf5 */
    wr32(self, 3670, (uint32_t)(0x0u));
    /* 0x4a7cff */
    edx = L4;
    /* 0x4a7d02 */
    wr32(self, 3674, (uint32_t)(0x0u));
    /* 0x4a7d0c */
    eax = L4;
    /* 0x4a7d0f */
    wr32(self, 3682, (uint32_t)(0x0u));
    /* 0x4a7d19 */
    /* 0x4a7d1b */
    /* 0x4a7d1c */
    return (uint8_t *)eax;
}

/* ---- 0x4a7d1d lifted ---- */
/* 0x4a7d1d, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0xe6a]/4, [self+0xe6e]/4, [self+0x1c]/2. Stores to [self+0xe6a]/4, [self+0xe6e]/4. Calls (in code order): 0x4a7c7a(this, 0 args), 0x4c2dfb(this, 1 arg), 0x4d3992(1 arg). Returns eax. */
uint32_t m4a7d1d_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4a7d20 */
    L4 = ecx;
    /* 0x4a7d21 */
    L4 = ecx;
    /* 0x4a7d24 */
    eax = L4;
    /* 0x4a7d27 */
    fa = rd32(self, 3690);
    fb = 0x0u;
    /* 0x4a7d2e */
    if (fa == fb) goto L4a7d44;
    /* 0x4a7d30 */
    ecx = L4;
    /* 0x4a7d33 */
    ecx = (uintptr_t)(self + (3690));
    /* 0x4a7d39 */
    L8 = ecx;
    /* 0x4a7d3a */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4a7d3f */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, L8);
L4a7d44:;
    /* 0x4a7d44 */
    edx = L4;
    /* 0x4a7d47 */
    fa = rd32(self, 3694);
    fb = 0x0u;
    /* 0x4a7d4e */
    if (fa == fb) goto L4a7d63;
    /* 0x4a7d50 */
    eax = L4;
    /* 0x4a7d53 */
    eax = (uintptr_t)(self + (3694));
    /* 0x4a7d58 */
    L8 = eax;
    /* 0x4a7d59 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4a7d5e */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, L8);
L4a7d63:;
    /* 0x4a7d63 */
    ecx = L4;
    /* 0x4a7d66 */
    wr32(self, 3690, (uint32_t)(0x0u));
    /* 0x4a7d70 */
    edx = L4;
    /* 0x4a7d73 */
    wr32(self, 3694, (uint32_t)(0x0u));
    /* 0x4a7d7d */
    eax = L4;
    /* 0x4a7d80 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 28)));
    /* 0x4a7d84 */
    fa = (uint32_t)ecx;
    fb = 0xffffffffu;
    /* 0x4a7d87 */
    if (fa == fb) goto L4a7d99;
    /* 0x4a7d89 */
    edx = L4;
    /* 0x4a7d8c */
    eax = (uint32_t)(((uint32_t)rd16(self, 28)) & 0xffffu);
    /* 0x4a7d90 */
    L8 = (uint32_t)(uint32_t)eax;
    /* 0x4a7d91 */
    eax = (uintptr_t)call1(host, 0x4d3992, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4a7d96 */
L4a7d99:;
    /* 0x4a7d99 */
    ecx = L4;
    /* 0x4a7d9c */
    eax = (uintptr_t)call0(host, 0x4a7c7a, ecx);
    /* 0x4a7da1 */
    /* 0x4a7da3 */
    /* 0x4a7da4 */
    return (uint32_t)eax;
}

/* ---- 0x4a7df9 lifted ---- */
/* 0x4a7df9, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0xe0c]/2, [self+0xe0e]/2, [self+0xe56]/4, [self+0xe5a]/4, [self+0xe5e]/4, [self+0xe76]/4. Returns this. */
uint8_t * m4a7df9_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x4a7dfc */
    L4 = ecx;
    /* 0x4a7dfd */
    L4 = ecx;
    /* 0x4a7e00 */
    eax = L4;
    /* 0x4a7e03 */
    wr32(self, 3674, (uint32_t)(0x0u));
    /* 0x4a7e0d */
    ecx = L4;
    /* 0x4a7e10 */
    wr32(self, 3670, (uint32_t)(0x0u));
    /* 0x4a7e1a */
    edx = L4;
    /* 0x4a7e1d */
    wr32(self, 3702, (uint32_t)(0x0u));
    /* 0x4a7e27 */
    eax = L4;
    /* 0x4a7e2a */
    wr16(self, 3598, (uint16_t)(0xffffu));
    /* 0x4a7e33 */
    ecx = L4;
    /* 0x4a7e36 */
    wr16(self, 3596, (uint16_t)(0xffffu));
    /* 0x4a7e3f */
    edx = L4;
    /* 0x4a7e42 */
    wr32(self, 3678, (uint32_t)(0x0u));
    /* 0x4a7e4c */
    /* 0x4a7e4e */
    /* 0x4a7e4f */
    return (uint8_t *)eax;
}

/* ---- 0x4a8007 lifted ---- */
/* 0x4a8007, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0xe8c]/4, [self+0xe84]/4, [self+0xe90]/4, [self+0xe88]/4, [self+0xe76]/4, [self+0xe2a]/4, [self+0xe32]/4, [self+0xe26]/4. ... Stores to [self+0xe16]/4, [self+0xe1a]/4, [self+0xe1e]/4, [self+0xe22]/4, [self+0xe26]/4, [self+0xe2a]/4, [self+0xe2e]/4, [self+0xe32]/4. ... Globals: 0x583186/4, 0x58318a/4. Calls (in code order): 0x4a7f08(this, 0 args). Returns this. */
uint8_t * m4a8007_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4a800a */
    /* 0x4a800d */
    L12 = ecx;
    /* 0x4a8010 */
    eax = L12;
    /* 0x4a8013 */
    ecx = L12;
    /* 0x4a8016 */
    eax = (uint32_t)(rd32(self, 3724));
    /* 0x4a801c */
    fa = ((uint32_t)((((uint32_t)eax) - (rd32(self, 3716))))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a8022 */
    edx = (uint32_t)((((int32_t)((uint32_t)eax) < 0) ? 0xffffffffu : 0u));
    /* 0x4a8023 */
    fa = ((uint32_t)((((uint32_t)eax) - ((uint32_t)edx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a8025 */
    fa = ((uint32_t)(((uint32_t)((int32_t)((uint32_t)eax) >> 1u)) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a8027 */
    edx = L12;
    /* 0x4a802a */
    fa = ((uint32_t)((((uint32_t)eax) + (rd32(self, 3716))))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a8030 */
    L8 = (uint32_t)((uint32_t)eax);
    /* 0x4a8033 */
    eax = L12;
    /* 0x4a8036 */
    ecx = L12;
    /* 0x4a8039 */
    eax = (uint32_t)(rd32(self, 3728));
    /* 0x4a803f */
    fa = ((uint32_t)((((uint32_t)eax) - (rd32(self, 3720))))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a8045 */
    edx = (uint32_t)((((int32_t)((uint32_t)eax) < 0) ? 0xffffffffu : 0u));
    /* 0x4a8046 */
    fa = ((uint32_t)((((uint32_t)eax) - ((uint32_t)edx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a8048 */
    fa = ((uint32_t)(((uint32_t)((int32_t)((uint32_t)eax) >> 1u)) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a804a */
    edx = L12;
    /* 0x4a804d */
    fa = ((uint32_t)((((uint32_t)eax) + (rd32(self, 3720))))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a8053 */
    L4 = (uint32_t)((uint32_t)eax);
    /* 0x4a8056 */
    eax = L12;
    /* 0x4a8059 */
    fa = rd32(self, 3702);
    fb = 0x0u;
    /* 0x4a8060 */
    if (fa == fb) goto L4a81cf;
    /* 0x4a8066 */
    ecx = L12;
    /* 0x4a8069 */
    edx = L12;
    /* 0x4a806c */
    eax = (uint32_t)(rd32(self, 3626));
    /* 0x4a8072 */
    wr32(self, 3610, (uint32_t)((uint32_t)eax));
    /* 0x4a8078 */
    ecx = L12;
    /* 0x4a807b */
    edx = L12;
    /* 0x4a807e */
    eax = (uint32_t)(rd32(self, 3634));
    /* 0x4a8084 */
    wr32(self, 3618, (uint32_t)((uint32_t)eax));
    /* 0x4a808a */
    ecx = L12;
    /* 0x4a808d */
    edx = L12;
    /* 0x4a8090 */
    eax = (uint32_t)(rd32(self, 3622));
    /* 0x4a8096 */
    wr32(self, 3606, (uint32_t)((uint32_t)eax));
    /* 0x4a809c */
    ecx = L12;
    /* 0x4a809f */
    edx = L12;
    /* 0x4a80a2 */
    eax = (uint32_t)(rd32(self, 3630));
    /* 0x4a80a8 */
    wr32(self, 3614, (uint32_t)((uint32_t)eax));
    /* 0x4a80ae */
    ecx = L12;
    /* 0x4a80b1 */
    edx = L12;
    /* 0x4a80b4 */
    eax = (uint32_t)(rd32(self, 3658));
    /* 0x4a80ba */
    wr32(self, 3642, (uint32_t)((uint32_t)eax));
    /* 0x4a80c0 */
    ecx = L12;
    /* 0x4a80c3 */
    edx = L12;
    /* 0x4a80c6 */
    eax = (uint32_t)(rd32(self, 3666));
    /* 0x4a80cc */
    wr32(self, 3650, (uint32_t)((uint32_t)eax));
    /* 0x4a80d2 */
    ecx = L12;
    /* 0x4a80d5 */
    edx = L12;
    /* 0x4a80d8 */
    eax = (uint32_t)(rd32(self, 3654));
    /* 0x4a80de */
    wr32(self, 3638, (uint32_t)((uint32_t)eax));
    /* 0x4a80e4 */
    ecx = L12;
    /* 0x4a80e7 */
    edx = L12;
    /* 0x4a80ea */
    eax = (uint32_t)(rd32(self, 3662));
    /* 0x4a80f0 */
    wr32(self, 3646, (uint32_t)((uint32_t)eax));
    /* 0x4a80f6 */
    ecx = L12;
    /* 0x4a80f9 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 5034)));
    /* 0x4a8100 */
    eax = (uint32_t)((uint32_t)L4);
    /* 0x4a8103 */
    fa = ((uint32_t)((((uint32_t)eax) - ((uint32_t)edx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a8105 */
    ecx = L12;
    /* 0x4a8108 */
    wr32(self, 3626, (uint32_t)((uint32_t)eax));
    /* 0x4a810e */
    edx = L12;
    /* 0x4a8111 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 5030)));
    /* 0x4a8118 */
    ecx = L12;
    /* 0x4a811b */
    edx = (uint32_t)(rd32(self, 3626));
    /* 0x4a8121 */
    fa = ((uint32_t)((((uint32_t)edx) + ((uint32_t)eax)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a8123 */
    eax = L12;
    /* 0x4a8126 */
    wr32(self, 3634, (uint32_t)((uint32_t)edx));
    /* 0x4a812c */
    ecx = L12;
    /* 0x4a812f */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 5032)));
    /* 0x4a8136 */
    eax = (uint32_t)((uint32_t)L8);
    /* 0x4a8139 */
    fa = ((uint32_t)((((uint32_t)eax) - ((uint32_t)edx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a813b */
    ecx = L12;
    /* 0x4a813e */
    wr32(self, 3622, (uint32_t)((uint32_t)eax));
    /* 0x4a8144 */
    edx = L12;
    /* 0x4a8147 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 5028)));
    /* 0x4a814e */
    ecx = L12;
    /* 0x4a8151 */
    edx = (uint32_t)(rd32(self, 3622));
    /* 0x4a8157 */
    fa = ((uint32_t)((((uint32_t)edx) + ((uint32_t)eax)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a8159 */
    eax = L12;
    /* 0x4a815c */
    wr32(self, 3630, (uint32_t)((uint32_t)edx));
    /* 0x4a8162 */
    ecx = L12;
    /* 0x4a8165 */
    eax = (uintptr_t)call0(host, 0x4a7f08, ecx);
    /* 0x4a816a */
    ecx = L12;
    /* 0x4a816d */
    edx = (uint32_t)(rd32(self, 3626));
    /* 0x4a8173 */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_58318a)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a8179 */
    eax = L12;
    /* 0x4a817c */
    wr32(self, 3658, (uint32_t)((uint32_t)edx));
    /* 0x4a8182 */
    ecx = L12;
    /* 0x4a8185 */
    edx = (uint32_t)(rd32(self, 3634));
    /* 0x4a818b */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_58318a)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a8191 */
    eax = L12;
    /* 0x4a8194 */
    wr32(self, 3666, (uint32_t)((uint32_t)edx));
    /* 0x4a819a */
    ecx = L12;
    /* 0x4a819d */
    edx = (uint32_t)(rd32(self, 3622));
    /* 0x4a81a3 */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_583186)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a81a9 */
    eax = L12;
    /* 0x4a81ac */
    wr32(self, 3654, (uint32_t)((uint32_t)edx));
    /* 0x4a81b2 */
    ecx = L12;
    /* 0x4a81b5 */
    edx = (uint32_t)(rd32(self, 3630));
    /* 0x4a81bb */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_583186)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a81c1 */
    eax = L12;
    /* 0x4a81c4 */
    wr32(self, 3662, (uint32_t)((uint32_t)edx));
    /* 0x4a81ca */
    goto L4a8358;
L4a81cf:;
    /* 0x4a81cf */
    ecx = L12;
    /* 0x4a81d2 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 5034)));
    /* 0x4a81d9 */
    eax = (uint32_t)((uint32_t)L4);
    /* 0x4a81dc */
    fa = ((uint32_t)((((uint32_t)eax) - ((uint32_t)edx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a81de */
    ecx = L12;
    /* 0x4a81e1 */
    wr32(self, 3626, (uint32_t)((uint32_t)eax));
    /* 0x4a81e7 */
    edx = L12;
    /* 0x4a81ea */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 5030)));
    /* 0x4a81f1 */
    ecx = L12;
    /* 0x4a81f4 */
    edx = (uint32_t)(rd32(self, 3626));
    /* 0x4a81fa */
    fa = ((uint32_t)((((uint32_t)edx) + ((uint32_t)eax)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a81fc */
    eax = L12;
    /* 0x4a81ff */
    wr32(self, 3634, (uint32_t)((uint32_t)edx));
    /* 0x4a8205 */
    ecx = L12;
    /* 0x4a8208 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 5032)));
    /* 0x4a820f */
    eax = (uint32_t)((uint32_t)L8);
    /* 0x4a8212 */
    fa = ((uint32_t)((((uint32_t)eax) - ((uint32_t)edx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4a8214 */
    ecx = L12;
    /* 0x4a8217 */
    wr32(self, 3622, (uint32_t)((uint32_t)eax));
    /* 0x4a821d */
    edx = L12;
    /* 0x4a8220 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 5028)));
    /* 0x4a8227 */
    ecx = L12;
    /* 0x4a822a */
    edx = (uint32_t)(rd32(self, 3622));
    /* 0x4a8230 */
    fa = ((uint32_t)((((uint32_t)edx) + ((uint32_t)eax)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a8232 */
    eax = L12;
    /* 0x4a8235 */
    wr32(self, 3630, (uint32_t)((uint32_t)edx));
    /* 0x4a823b */
    ecx = L12;
    /* 0x4a823e */
    eax = (uintptr_t)call0(host, 0x4a7f08, ecx);
    /* 0x4a8243 */
    ecx = L12;
    /* 0x4a8246 */
    edx = L12;
    /* 0x4a8249 */
    eax = (uint32_t)(rd32(self, 3626));
    /* 0x4a824f */
    wr32(self, 3610, (uint32_t)((uint32_t)eax));
    /* 0x4a8255 */
    ecx = L12;
    /* 0x4a8258 */
    edx = L12;
    /* 0x4a825b */
    eax = (uint32_t)(rd32(self, 3634));
    /* 0x4a8261 */
    wr32(self, 3618, (uint32_t)((uint32_t)eax));
    /* 0x4a8267 */
    ecx = L12;
    /* 0x4a826a */
    edx = L12;
    /* 0x4a826d */
    eax = (uint32_t)(rd32(self, 3622));
    /* 0x4a8273 */
    wr32(self, 3606, (uint32_t)((uint32_t)eax));
    /* 0x4a8279 */
    ecx = L12;
    /* 0x4a827c */
    edx = L12;
    /* 0x4a827f */
    eax = (uint32_t)(rd32(self, 3630));
    /* 0x4a8285 */
    wr32(self, 3614, (uint32_t)((uint32_t)eax));
    /* 0x4a828b */
    ecx = L12;
    /* 0x4a828e */
    edx = (uint32_t)(rd32(self, 3626));
    /* 0x4a8294 */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_58318a)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a829a */
    eax = L12;
    /* 0x4a829d */
    wr32(self, 3658, (uint32_t)((uint32_t)edx));
    /* 0x4a82a3 */
    ecx = L12;
    /* 0x4a82a6 */
    edx = (uint32_t)(rd32(self, 3634));
    /* 0x4a82ac */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_58318a)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a82b2 */
    eax = L12;
    /* 0x4a82b5 */
    wr32(self, 3666, (uint32_t)((uint32_t)edx));
    /* 0x4a82bb */
    ecx = L12;
    /* 0x4a82be */
    edx = (uint32_t)(rd32(self, 3622));
    /* 0x4a82c4 */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_583186)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a82ca */
    eax = L12;
    /* 0x4a82cd */
    wr32(self, 3654, (uint32_t)((uint32_t)edx));
    /* 0x4a82d3 */
    ecx = L12;
    /* 0x4a82d6 */
    edx = (uint32_t)(rd32(self, 3630));
    /* 0x4a82dc */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_583186)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a82e2 */
    eax = L12;
    /* 0x4a82e5 */
    wr32(self, 3662, (uint32_t)((uint32_t)edx));
    /* 0x4a82eb */
    ecx = L12;
    /* 0x4a82ee */
    edx = (uint32_t)(rd32(self, 3610));
    /* 0x4a82f4 */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_58318a)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a82fa */
    eax = L12;
    /* 0x4a82fd */
    wr32(self, 3642, (uint32_t)((uint32_t)edx));
    /* 0x4a8303 */
    ecx = L12;
    /* 0x4a8306 */
    edx = (uint32_t)(rd32(self, 3618));
    /* 0x4a830c */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_58318a)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a8312 */
    eax = L12;
    /* 0x4a8315 */
    wr32(self, 3650, (uint32_t)((uint32_t)edx));
    /* 0x4a831b */
    ecx = L12;
    /* 0x4a831e */
    edx = (uint32_t)(rd32(self, 3606));
    /* 0x4a8324 */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_583186)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a832a */
    eax = L12;
    /* 0x4a832d */
    wr32(self, 3638, (uint32_t)((uint32_t)edx));
    /* 0x4a8333 */
    ecx = L12;
    /* 0x4a8336 */
    edx = (uint32_t)(rd32(self, 3614));
    /* 0x4a833c */
    fa = ((uint32_t)((((uint32_t)edx) + (world->value_583186)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4a8342 */
    eax = L12;
    /* 0x4a8345 */
    wr32(self, 3646, (uint32_t)((uint32_t)edx));
    /* 0x4a834b */
    ecx = L12;
    /* 0x4a834e */
    wr32(self, 3702, (uint32_t)(0x1u));
L4a8358:;
    /* 0x4a8358 */
    /* 0x4a835a */
    /* 0x4a835b */
    return (uint8_t *)eax;
}

/* ---- 0x4a9f63 lifted ---- */
/* 0x4a9f63, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1d]/4, [self+0x29]/2. Calls (in code order): 0x4a9f27(this, 0 args), 0x4c2dfb(this, 1 arg), 0x4d3992(1 arg). Returns eax. */
uint32_t m4a9f63_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4a9f66 */
    /* 0x4a9f69 */
    L8 = ecx;
    /* 0x4a9f6c */
    eax = L8;
    /* 0x4a9f6f */
    fa = rd32(self, 29);
    fb = 0x0u;
    /* 0x4a9f73 */
    if (fa == fb) goto L4a9f86;
    /* 0x4a9f75 */
    ecx = L8;
    /* 0x4a9f78 */
    ecx = (uintptr_t)(self + (29));
    /* 0x4a9f7b */
    L12 = ecx;
    /* 0x4a9f7c */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4a9f81 */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, L12);
L4a9f86:;
    /* 0x4a9f86 */
    edx = L8;
    /* 0x4a9f89 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 41)));
    /* 0x4a9f8d */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4a9f8f */
    if (fa != 0) goto L4a9f98;
    /* 0x4a9f91 */
    L4 = (uint32_t)(0x1u);
L4a9f98:;
    /* 0x4a9f98 */
    ecx = L8;
    /* 0x4a9f9b */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 41)));
    /* 0x4a9f9f */
    fa = (uint32_t)edx;
    fb = 0xffffffffu;
    /* 0x4a9fa2 */
    if (fa == fb) goto L4a9fbf;
    /* 0x4a9fa4 */
    eax = L8;
    /* 0x4a9fa7 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 41)));
    /* 0x4a9fab */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4a9fad */
    if (fa == 0) goto L4a9fbf;
    /* 0x4a9faf */
    edx = L8;
    /* 0x4a9fb2 */
    eax = (uint32_t)(((uint32_t)rd16(self, 41)) & 0xffffu);
    /* 0x4a9fb6 */
    L12 = (uint32_t)(uint32_t)eax;
    /* 0x4a9fb7 */
    eax = (uintptr_t)call1(host, 0x4d3992, 0, (uintptr_t)(uint32_t)L12);
    /* 0x4a9fbc */
L4a9fbf:;
    /* 0x4a9fbf */
    ecx = L8;
    /* 0x4a9fc2 */
    eax = (uintptr_t)call0(host, 0x4a9f27, ecx);
    /* 0x4a9fc7 */
    /* 0x4a9fc9 */
    /* 0x4a9fca */
    return (uint32_t)eax;
}

/* ---- 0x4ab706 lifted ---- */
/* 0x4ab706, this = ecx (self), `ret 0x8`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword, a1 dword. Stores to [self+0x32]/2. Globals: 0x5b44f0/4 (written), 0x5b44f4/4 (written), 0x5c39e5/4 (written), 0x5d0377/4, 0x5d162d/4 (written), 0x5d1631/4 (written), 0x5d1639/4 (written). eax is left-over and not meaningful. */
uint32_t m4ab706_lifted(uint8_t *self, uint32_t a0, uint32_t a1, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t A1 = (uintptr_t)a1;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)A1;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4ab709 */
    L4 = ecx;
    /* 0x4ab70a */
    L4 = ecx;
    /* 0x4ab70d */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)A0 & 0xffffu)));
    /* 0x4ab711 */
    fa = (uint32_t)eax;
    fb = 0x27ceu;
    /* 0x4ab716 */
    if (fa != fb) goto L4ab77a;
    /* 0x4ab718 */
    world->value_5b44f0 = (uint32_t)(0x16u);
    /* 0x4ab722 */
    world->value_5b44f4 = (uint32_t)(0x1u);
    /* 0x4ab72c */
    ecx = (uint32_t)(world->value_5d0377);
    /* 0x4ab732 */
    world->value_5d162d = (uint32_t)((uint32_t)ecx);
    /* 0x4ab738 */
    edx = (uint32_t)(world->value_5b44f0);
    /* 0x4ab73e */
    fa = ((uint32_t)((((uint32_t)edx) << 5u) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4ab741 */
    eax = (uint32_t)(world->value_5b44f4);
    /* 0x4ab746 */
    fa = ((uint32_t)((((uint32_t)eax) << 4u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4ab749 */
    ecx = (uint32_t)((uint32_t)edx + (uint32_t)eax + (uint32_t)5969420);
    /* 0x4ab750 */
    world->value_5d1631 = (uint32_t)((uint32_t)ecx);
    /* 0x4ab756 */
    world->value_5d1639 = (uint32_t)(0x1u);
    /* 0x4ab760 */
    world->value_5c39e5 = (uint32_t)(0x27ceu);
    /* 0x4ab76a */
    edx = L4;
    /* 0x4ab76d */
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | (((((uint32_t)A1 & 0xffffu)) & 0xffffu) << 0));
    /* 0x4ab771 */
    wr16(self, 50, (uint16_t)(((uint32_t)eax & 0xffffu)));
    /* 0x4ab775 */
    goto L4ab84a;
L4ab77a:;
    /* 0x4ab77a */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)A0 & 0xffffu)));
    /* 0x4ab77e */
    fa = (uint32_t)ecx;
    fb = 0x27cfu;
    /* 0x4ab784 */
    if (fa != fb) goto L4ab7e5;
    /* 0x4ab786 */
    world->value_5b44f0 = (uint32_t)(0x12u);
    /* 0x4ab790 */
    world->value_5b44f4 = (uint32_t)(0x1u);
    /* 0x4ab79a */
    edx = (uint32_t)(world->value_5d0377);
    /* 0x4ab7a0 */
    world->value_5d162d = (uint32_t)((uint32_t)edx);
    /* 0x4ab7a6 */
    eax = (uint32_t)(world->value_5b44f0);
    /* 0x4ab7ab */
    fa = ((uint32_t)((((uint32_t)eax) << 5u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4ab7ae */
    ecx = (uint32_t)(world->value_5b44f4);
    /* 0x4ab7b4 */
    fa = ((uint32_t)((((uint32_t)ecx) << 4u) & 0xffffffffu)) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4ab7b7 */
    edx = (uint32_t)((uint32_t)eax + (uint32_t)ecx + (uint32_t)5969420);
    /* 0x4ab7be */
    world->value_5d1631 = (uint32_t)((uint32_t)edx);
    /* 0x4ab7c4 */
    world->value_5d1639 = (uint32_t)(0x1u);
    /* 0x4ab7ce */
    world->value_5c39e5 = (uint32_t)(0x27cfu);
    /* 0x4ab7d8 */
    eax = L4;
    /* 0x4ab7db */
    ecx = (uint32_t)(((uint32_t)ecx & 0xffff0000u) | (((((uint32_t)A1 & 0xffffu)) & 0xffffu) << 0));
    /* 0x4ab7df */
    wr16(self, 50, (uint16_t)(((uint32_t)ecx & 0xffffu)));
    /* 0x4ab7e3 */
    goto L4ab84a;
L4ab7e5:;
    /* 0x4ab7e5 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)A0 & 0xffffu)));
    /* 0x4ab7e9 */
    fa = (uint32_t)edx;
    fb = 0x27d0u;
    /* 0x4ab7ef */
    if (fa != fb) goto L4ab84a;
    /* 0x4ab7f1 */
    world->value_5b44f0 = (uint32_t)(0x9u);
    /* 0x4ab7fb */
    world->value_5b44f4 = (uint32_t)(0x1u);
    /* 0x4ab805 */
    eax = (uint32_t)(world->value_5d0377);
    /* 0x4ab80a */
    world->value_5d162d = (uint32_t)((uint32_t)eax);
    /* 0x4ab80f */
    ecx = (uint32_t)(world->value_5b44f0);
    /* 0x4ab815 */
    fa = ((uint32_t)((((uint32_t)ecx) << 5u) & 0xffffffffu)) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4ab818 */
    edx = (uint32_t)(world->value_5b44f4);
    /* 0x4ab81e */
    fa = ((uint32_t)((((uint32_t)edx) << 4u) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4ab821 */
    eax = (uint32_t)((uint32_t)ecx + (uint32_t)edx + (uint32_t)5969420);
    /* 0x4ab828 */
    world->value_5d1631 = (uint32_t)((uint32_t)eax);
    /* 0x4ab82d */
    world->value_5d1639 = (uint32_t)(0x1u);
    /* 0x4ab837 */
    world->value_5c39e5 = (uint32_t)(0x27d0u);
    /* 0x4ab841 */
    ecx = L4;
    /* 0x4ab844 */
    wr16(self, 50, (uint16_t)(0xffffu));
L4ab84a:;
    /* 0x4ab84a */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)A0 & 0xffffu)));
    /* 0x4ab84e */
    world->value_5c39e5 = (uint32_t)((uint32_t)edx);
    /* 0x4ab854 */
    /* 0x4ab856 */
    /* 0x4ab857 */
    return 0;
}

/* ---- 0x4accab lifted ---- */
/* 0x4accab, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x24]/2. Globals: 0x583196/4, 0x58319a/4, 0x58319e/4, 0x5831a2/4. eax is left-over and not meaningful. */
uint32_t m4accab_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4accae */
    /* 0x4accb1 */
    L16 = ecx;
    /* 0x4accb4 */
    eax = L16;
    /* 0x4accb7 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 36)));
    /* 0x4accbb */
    ecx = (uint32_t)((uint32_t)((uint32_t)((uint32_t)ecx) * (uint32_t)(0xc7u)));
    /* 0x4accc1 */
    edx = L16;
    /* 0x4accc4 */
    eax = (uintptr_t)((uint8_t *)edx + (ptrdiff_t)(int32_t)((uint32_t)ecx * 1u) + (ptrdiff_t)(110));
    /* 0x4accc8 */
    L12 = eax;
    /* 0x4acccb */
    ecx = L12;
    /* 0x4accce */
    ecx = (uintptr_t)((uint8_t *)ecx + (ptrdiff_t)(2));
    /* 0x4accd1 */
    L4 = ecx;
    /* 0x4accd4 */
    edx = L4;
    /* 0x4accd7 */
    eax = (uint32_t)(rd32((uint8_t *)edx, 4));
    /* 0x4accda */
    fa = (uint32_t)eax;
    fb = world->value_58319a;
    /* 0x4acce0 */
    if ((int32_t)fa >= (int32_t)fb) goto L4acd11;
    /* 0x4acce2 */
    ecx = L4;
    /* 0x4acce5 */
    edx = (uint32_t)(world->value_58319a);
    /* 0x4acceb */
    fa = ((uint32_t)((((uint32_t)edx) - (rd32((uint8_t *)ecx, 4))))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4accee */
    L8 = (uint32_t)((uint32_t)edx);
    /* 0x4accf1 */
    eax = L4;
    /* 0x4accf4 */
    ecx = (uint32_t)(rd32((uint8_t *)eax, 4));
    /* 0x4accf7 */
    fa = ((uint32_t)((((uint32_t)ecx) + ((uint32_t)L8)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4accfa */
    edx = L4;
    /* 0x4accfd */
    wr32((uint8_t *)edx, 4, (uint32_t)((uint32_t)ecx));
    /* 0x4acd00 */
    eax = L4;
    /* 0x4acd03 */
    ecx = (uint32_t)(rd32((uint8_t *)eax, 12));
    /* 0x4acd06 */
    fa = ((uint32_t)((((uint32_t)ecx) + ((uint32_t)L8)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4acd09 */
    edx = L4;
    /* 0x4acd0c */
    wr32((uint8_t *)edx, 12, (uint32_t)((uint32_t)ecx));
    /* 0x4acd0f */
    goto L4acd4c;
L4acd11:;
    /* 0x4acd11 */
    eax = L4;
    /* 0x4acd14 */
    ecx = (uint32_t)(rd32((uint8_t *)eax, 12));
    /* 0x4acd17 */
    fa = (uint32_t)ecx;
    fb = world->value_5831a2;
    /* 0x4acd1d */
    if ((int32_t)fa <= (int32_t)fb) goto L4acd4c;
    /* 0x4acd1f */
    edx = L4;
    /* 0x4acd22 */
    eax = (uint32_t)(rd32((uint8_t *)edx, 12));
    /* 0x4acd25 */
    fa = ((uint32_t)((((uint32_t)eax) - (world->value_5831a2)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4acd2b */
    L8 = (uint32_t)((uint32_t)eax);
    /* 0x4acd2e */
    ecx = L4;
    /* 0x4acd31 */
    edx = (uint32_t)(rd32((uint8_t *)ecx, 4));
    /* 0x4acd34 */
    fa = ((uint32_t)((((uint32_t)edx) - ((uint32_t)L8)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4acd37 */
    eax = L4;
    /* 0x4acd3a */
    wr32((uint8_t *)eax, 4, (uint32_t)((uint32_t)edx));
    /* 0x4acd3d */
    ecx = L4;
    /* 0x4acd40 */
    edx = (uint32_t)(rd32((uint8_t *)ecx, 12));
    /* 0x4acd43 */
    fa = ((uint32_t)((((uint32_t)edx) - ((uint32_t)L8)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4acd46 */
    eax = L4;
    /* 0x4acd49 */
    wr32((uint8_t *)eax, 12, (uint32_t)((uint32_t)edx));
L4acd4c:;
    /* 0x4acd4c */
    ecx = L4;
    /* 0x4acd4f */
    edx = (uint32_t)(rd32((uint8_t *)ecx, 0));
    /* 0x4acd51 */
    fa = (uint32_t)edx;
    fb = world->value_583196;
    /* 0x4acd57 */
    if ((int32_t)fa >= (int32_t)fb) goto L4acd85;
    /* 0x4acd59 */
    eax = L4;
    /* 0x4acd5c */
    ecx = (uint32_t)(world->value_583196);
    /* 0x4acd62 */
    fa = ((uint32_t)((((uint32_t)ecx) - (rd32((uint8_t *)eax, 0))))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4acd64 */
    L8 = (uint32_t)((uint32_t)ecx);
    /* 0x4acd67 */
    edx = L4;
    /* 0x4acd6a */
    eax = (uint32_t)(rd32((uint8_t *)edx, 0));
    /* 0x4acd6c */
    fa = ((uint32_t)((((uint32_t)eax) + ((uint32_t)L8)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4acd6f */
    ecx = L4;
    /* 0x4acd72 */
    wr32((uint8_t *)ecx, 0, (uint32_t)((uint32_t)eax));
    /* 0x4acd74 */
    edx = L4;
    /* 0x4acd77 */
    eax = (uint32_t)(rd32((uint8_t *)edx, 8));
    /* 0x4acd7a */
    fa = ((uint32_t)((((uint32_t)eax) + ((uint32_t)L8)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4acd7d */
    ecx = L4;
    /* 0x4acd80 */
    wr32((uint8_t *)ecx, 8, (uint32_t)((uint32_t)eax));
    /* 0x4acd83 */
    goto L4acdbe;
L4acd85:;
    /* 0x4acd85 */
    edx = L4;
    /* 0x4acd88 */
    eax = (uint32_t)(rd32((uint8_t *)edx, 8));
    /* 0x4acd8b */
    fa = (uint32_t)eax;
    fb = world->value_58319e;
    /* 0x4acd91 */
    if ((int32_t)fa <= (int32_t)fb) goto L4acdbe;
    /* 0x4acd93 */
    ecx = L4;
    /* 0x4acd96 */
    edx = (uint32_t)(rd32((uint8_t *)ecx, 8));
    /* 0x4acd99 */
    fa = ((uint32_t)((((uint32_t)edx) - (world->value_58319e)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4acd9f */
    L8 = (uint32_t)((uint32_t)edx);
    /* 0x4acda2 */
    eax = L4;
    /* 0x4acda5 */
    ecx = (uint32_t)(rd32((uint8_t *)eax, 0));
    /* 0x4acda7 */
    fa = ((uint32_t)((((uint32_t)ecx) - ((uint32_t)L8)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4acdaa */
    edx = L4;
    /* 0x4acdad */
    wr32((uint8_t *)edx, 0, (uint32_t)((uint32_t)ecx));
    /* 0x4acdaf */
    eax = L4;
    /* 0x4acdb2 */
    ecx = (uint32_t)(rd32((uint8_t *)eax, 8));
    /* 0x4acdb5 */
    fa = ((uint32_t)((((uint32_t)ecx) - ((uint32_t)L8)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4acdb8 */
    edx = L4;
    /* 0x4acdbb */
    wr32((uint8_t *)edx, 8, (uint32_t)((uint32_t)ecx));
L4acdbe:;
    /* 0x4acdbe */
    /* 0x4acdc0 */
    /* 0x4acdc1 */
    return 0;
}

/* ---- 0x4ad1e5 lifted ---- */
/* 0x4ad1e5, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Globals: 0x5b44f0/4 (written), 0x5b44f4/4 (written), 0x5c39e5/4 (written), 0x5d0377/4, 0x5d162d/4 (written), 0x5d1631/4 (written), 0x5d1639/4 (written). Returns eax. */
uint32_t m4ad1e5_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4ad1e8 */
    L4 = ecx;
    /* 0x4ad1e9 */
    L4 = ecx;
    /* 0x4ad1ec */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)A0 & 0xffffu)));
    /* 0x4ad1f0 */
    fa = (uint32_t)eax;
    fb = 0x2775u;
    /* 0x4ad1f5 */
    if (fa != fb) goto L4ad24e;
    /* 0x4ad1f7 */
    ecx = (uint32_t)(world->value_5d0377);
    /* 0x4ad1fd */
    world->value_5d162d = (uint32_t)((uint32_t)ecx);
    /* 0x4ad203 */
    world->value_5b44f0 = (uint32_t)(0x9u);
    /* 0x4ad20d */
    world->value_5b44f4 = (uint32_t)(0x1u);
    /* 0x4ad217 */
    edx = (uint32_t)(world->value_5b44f0);
    /* 0x4ad21d */
    fa = ((uint32_t)((((uint32_t)edx) << 5u) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4ad220 */
    eax = (uint32_t)(world->value_5b44f4);
    /* 0x4ad225 */
    fa = ((uint32_t)((((uint32_t)eax) << 4u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4ad228 */
    ecx = (uint32_t)((uint32_t)edx + (uint32_t)eax + (uint32_t)5969420);
    /* 0x4ad22f */
    world->value_5d1631 = (uint32_t)((uint32_t)ecx);
    /* 0x4ad235 */
    world->value_5d1639 = (uint32_t)(0x1u);
    /* 0x4ad23f */
    world->value_5c39e5 = (uint32_t)(0x2775u);
    /* 0x4ad249 */
    goto L4ad30a;
L4ad24e:;
    /* 0x4ad24e */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)A0 & 0xffffu)));
    /* 0x4ad252 */
    fa = (uint32_t)edx;
    fb = 0x2774u;
    /* 0x4ad258 */
    if (fa != fb) goto L4ad2ac;
    /* 0x4ad25a */
    world->value_5b44f0 = (uint32_t)(0x12u);
    /* 0x4ad264 */
    world->value_5b44f4 = (uint32_t)(0x1u);
    /* 0x4ad26e */
    eax = (uint32_t)(world->value_5d0377);
    /* 0x4ad273 */
    world->value_5d162d = (uint32_t)((uint32_t)eax);
    /* 0x4ad278 */
    ecx = (uint32_t)(world->value_5b44f0);
    /* 0x4ad27e */
    fa = ((uint32_t)((((uint32_t)ecx) << 5u) & 0xffffffffu)) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4ad281 */
    edx = (uint32_t)(world->value_5b44f4);
    /* 0x4ad287 */
    fa = ((uint32_t)((((uint32_t)edx) << 4u) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4ad28a */
    eax = (uint32_t)((uint32_t)ecx + (uint32_t)edx + (uint32_t)5969420);
    /* 0x4ad291 */
    world->value_5d1631 = (uint32_t)((uint32_t)eax);
    /* 0x4ad296 */
    world->value_5d1639 = (uint32_t)(0x1u);
    /* 0x4ad2a0 */
    world->value_5c39e5 = (uint32_t)(0x2774u);
    /* 0x4ad2aa */
    goto L4ad30a;
L4ad2ac:;
    /* 0x4ad2ac */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)A0 & 0xffffu)));
    /* 0x4ad2b0 */
    fa = (uint32_t)ecx;
    fb = 0x2776u;
    /* 0x4ad2b6 */
    if (fa != fb) goto L4ad30a;
    /* 0x4ad2b8 */
    world->value_5b44f0 = (uint32_t)(0x12u);
    /* 0x4ad2c2 */
    world->value_5b44f4 = (uint32_t)(0x0u);
    /* 0x4ad2cc */
    edx = (uint32_t)(world->value_5d0377);
    /* 0x4ad2d2 */
    world->value_5d162d = (uint32_t)((uint32_t)edx);
    /* 0x4ad2d8 */
    eax = (uint32_t)(world->value_5b44f0);
    /* 0x4ad2dd */
    fa = ((uint32_t)((((uint32_t)eax) << 5u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4ad2e0 */
    ecx = (uint32_t)(world->value_5b44f4);
    /* 0x4ad2e6 */
    fa = ((uint32_t)((((uint32_t)ecx) << 4u) & 0xffffffffu)) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4ad2e9 */
    edx = (uint32_t)((uint32_t)eax + (uint32_t)ecx + (uint32_t)5969420);
    /* 0x4ad2f0 */
    world->value_5d1631 = (uint32_t)((uint32_t)edx);
    /* 0x4ad2f6 */
    world->value_5d1639 = (uint32_t)(0x1u);
    /* 0x4ad300 */
    world->value_5c39e5 = (uint32_t)(0x2776u);
L4ad30a:;
    /* 0x4ad30a */
    /* 0x4ad30c */
    /* 0x4ad30d */
    return (uint32_t)eax;
}

/* ---- 0x4b3c5a lifted ---- */
/* 0x4b3c5a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x71c]/2, [self+0x71e]/2, [self+0x720]/2, [self+0x722]/2, [self+0x724]/2, [self+0x726]/2, [self+0x728]/2, [self+0x72a]/2. ... Returns this. */
uint8_t * m4b3c5a_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x4b3c5d */
    L4 = ecx;
    /* 0x4b3c5e */
    L4 = ecx;
    /* 0x4b3c61 */
    eax = L4;
    /* 0x4b3c64 */
    wr16(self, 1832, (uint16_t)(0xffffu));
    /* 0x4b3c6d */
    ecx = L4;
    /* 0x4b3c70 */
    wr32(self, 1876, (uint32_t)(0x0u));
    /* 0x4b3c7a */
    edx = L4;
    /* 0x4b3c7d */
    wr16(self, 1830, (uint16_t)(0xffffu));
    /* 0x4b3c86 */
    eax = L4;
    /* 0x4b3c89 */
    wr32(self, 1902, (uint32_t)(0x0u));
    /* 0x4b3c93 */
    ecx = L4;
    /* 0x4b3c96 */
    wr16(self, 1882, (uint16_t)(0xffffu));
    /* 0x4b3c9f */
    edx = L4;
    /* 0x4b3ca2 */
    wr16(self, 1884, (uint16_t)(0xffffu));
    /* 0x4b3cab */
    eax = L4;
    /* 0x4b3cae */
    wr16(self, 1880, (uint16_t)(0xffffu));
    /* 0x4b3cb7 */
    ecx = L4;
    /* 0x4b3cba */
    wr16(self, 1820, (uint16_t)(0xffffu));
    /* 0x4b3cc3 */
    edx = L4;
    /* 0x4b3cc6 */
    wr16(self, 1834, (uint16_t)(0xffffu));
    /* 0x4b3ccf */
    eax = L4;
    /* 0x4b3cd2 */
    wr16(self, 1872, (uint16_t)(0x0u));
    /* 0x4b3cdb */
    ecx = L4;
    /* 0x4b3cde */
    wr16(self, 1874, (uint16_t)(0x0u));
    /* 0x4b3ce7 */
    edx = L4;
    /* 0x4b3cea */
    wr16(self, 1868, (uint16_t)(0x0u));
    /* 0x4b3cf3 */
    eax = L4;
    /* 0x4b3cf6 */
    wr16(self, 1870, (uint16_t)(0x0u));
    /* 0x4b3cff */
    ecx = L4;
    /* 0x4b3d02 */
    wr32(self, 1914, (uint32_t)(0x0u));
    /* 0x4b3d0c */
    edx = L4;
    /* 0x4b3d0f */
    wr32(self, 1918, (uint32_t)(0x0u));
    /* 0x4b3d19 */
    eax = L4;
    /* 0x4b3d1c */
    wr16(self, 1822, (uint16_t)(0x0u));
    /* 0x4b3d25 */
    ecx = L4;
    /* 0x4b3d28 */
    wr16(self, 1824, (uint16_t)(0x0u));
    /* 0x4b3d31 */
    edx = L4;
    /* 0x4b3d34 */
    wr16(self, 1826, (uint16_t)(0x0u));
    /* 0x4b3d3d */
    eax = L4;
    /* 0x4b3d40 */
    wr16(self, 1828, (uint16_t)(0x0u));
    /* 0x4b3d49 */
    /* 0x4b3d4b */
    /* 0x4b3d4c */
    return (uint8_t *)eax;
}

/* ---- 0x4b3f98 lifted ---- */
/* 0x4b3f98, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x750]/2, [self+0x75e]/4, [self+0x762]/4, [self+0x752]/2, [self+0x6e0]/4, [self+0x6e8]/4, [self+0x6dc]/4, [self+0x6e4]/4. ... Stores to [self+0x6dc]/4, [self+0x6e0]/4, [self+0x6e4]/4, [self+0x6e8]/4, [self+0x6ec]/4, [self+0x6f0]/4, [self+0x6f4]/4, [self+0x6f8]/4. ... Globals: 0x583186/4, 0x58318a/4. Calls (in code order): 0x4b3e99(this, 0 args). eax is left-over and not meaningful. */
uint32_t m4b3f98_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4b3f9b */
    /* 0x4b3f9e */
    L12 = ecx;
    /* 0x4b3fa1 */
    eax = L12;
    /* 0x4b3fa4 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 1872)));
    /* 0x4b3fab */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4b3fad */
    if (fa != 0) goto L4b3fb4;
    /* 0x4b3faf */
    goto L4b42cf;
L4b3fb4:;
    /* 0x4b3fb4 */
    edx = L12;
    /* 0x4b3fb7 */
    eax = (uint32_t)(rd32(self, 1886));
    /* 0x4b3fbd */
    L8 = (uint32_t)((uint32_t)eax);
    /* 0x4b3fc0 */
    ecx = L12;
    /* 0x4b3fc3 */
    edx = (uint32_t)(rd32(self, 1890));
    /* 0x4b3fc9 */
    L4 = (uint32_t)((uint32_t)edx);
    /* 0x4b3fcc */
    eax = L12;
    /* 0x4b3fcf */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 1874)));
    /* 0x4b3fd6 */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4b3fd8 */
    if (fa == 0) goto L4b4147;
    /* 0x4b3fde */
    edx = L12;
    /* 0x4b3fe1 */
    eax = L12;
    /* 0x4b3fe4 */
    ecx = (uint32_t)(rd32(self, 1760));
    /* 0x4b3fea */
    wr32(self, 1776, (uint32_t)((uint32_t)ecx));
    /* 0x4b3ff0 */
    edx = L12;
    /* 0x4b3ff3 */
    eax = L12;
    /* 0x4b3ff6 */
    ecx = (uint32_t)(rd32(self, 1768));
    /* 0x4b3ffc */
    wr32(self, 1784, (uint32_t)((uint32_t)ecx));
    /* 0x4b4002 */
    edx = L12;
    /* 0x4b4005 */
    eax = L12;
    /* 0x4b4008 */
    ecx = (uint32_t)(rd32(self, 1756));
    /* 0x4b400e */
    wr32(self, 1772, (uint32_t)((uint32_t)ecx));
    /* 0x4b4014 */
    edx = L12;
    /* 0x4b4017 */
    eax = L12;
    /* 0x4b401a */
    ecx = (uint32_t)(rd32(self, 1764));
    /* 0x4b4020 */
    wr32(self, 1780, (uint32_t)((uint32_t)ecx));
    /* 0x4b4026 */
    edx = L12;
    /* 0x4b4029 */
    eax = L12;
    /* 0x4b402c */
    ecx = (uint32_t)(rd32(self, 1792));
    /* 0x4b4032 */
    wr32(self, 1808, (uint32_t)((uint32_t)ecx));
    /* 0x4b4038 */
    edx = L12;
    /* 0x4b403b */
    eax = L12;
    /* 0x4b403e */
    ecx = (uint32_t)(rd32(self, 1800));
    /* 0x4b4044 */
    wr32(self, 1816, (uint32_t)((uint32_t)ecx));
    /* 0x4b404a */
    edx = L12;
    /* 0x4b404d */
    eax = L12;
    /* 0x4b4050 */
    ecx = (uint32_t)(rd32(self, 1788));
    /* 0x4b4056 */
    wr32(self, 1804, (uint32_t)((uint32_t)ecx));
    /* 0x4b405c */
    edx = L12;
    /* 0x4b405f */
    eax = L12;
    /* 0x4b4062 */
    ecx = (uint32_t)(rd32(self, 1796));
    /* 0x4b4068 */
    wr32(self, 1812, (uint32_t)((uint32_t)ecx));
    /* 0x4b406e */
    edx = L12;
    /* 0x4b4071 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 1828)));
    /* 0x4b4078 */
    ecx = (uint32_t)((uint32_t)L4);
    /* 0x4b407b */
    fa = ((uint32_t)((((uint32_t)ecx) - ((uint32_t)eax)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4b407d */
    edx = L12;
    /* 0x4b4080 */
    wr32(self, 1760, (uint32_t)((uint32_t)ecx));
    /* 0x4b4086 */
    eax = L12;
    /* 0x4b4089 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 1826)));
    /* 0x4b4090 */
    edx = L12;
    /* 0x4b4093 */
    eax = (uint32_t)(rd32(self, 1760));
    /* 0x4b4099 */
    fa = ((uint32_t)((((uint32_t)eax) + ((uint32_t)ecx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4b409b */
    ecx = L12;
    /* 0x4b409e */
    wr32(self, 1768, (uint32_t)((uint32_t)eax));
    /* 0x4b40a4 */
    edx = L12;
    /* 0x4b40a7 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 1824)));
    /* 0x4b40ae */
    ecx = (uint32_t)((uint32_t)L8);
    /* 0x4b40b1 */
    fa = ((uint32_t)((((uint32_t)ecx) - ((uint32_t)eax)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4b40b3 */
    edx = L12;
    /* 0x4b40b6 */
    wr32(self, 1756, (uint32_t)((uint32_t)ecx));
    /* 0x4b40bc */
    eax = L12;
    /* 0x4b40bf */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 1822)));
    /* 0x4b40c6 */
    edx = L12;
    /* 0x4b40c9 */
    eax = (uint32_t)(rd32(self, 1756));
    /* 0x4b40cf */
    fa = ((uint32_t)((((uint32_t)eax) + ((uint32_t)ecx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4b40d1 */
    ecx = L12;
    /* 0x4b40d4 */
    wr32(self, 1764, (uint32_t)((uint32_t)eax));
    /* 0x4b40da */
    ecx = L12;
    /* 0x4b40dd */
    eax = (uintptr_t)call0(host, 0x4b3e99, ecx);
    /* 0x4b40e2 */
    edx = L12;
    /* 0x4b40e5 */
    eax = (uint32_t)(rd32(self, 1760));
    /* 0x4b40eb */
    fa = ((uint32_t)((((uint32_t)eax) + (world->value_58318a)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4b40f1 */
    ecx = L12;
    /* 0x4b40f4 */
    wr32(self, 1792, (uint32_t)((uint32_t)eax));
    /* 0x4b40fa */
    edx = L12;
    /* 0x4b40fd */
    eax = (uint32_t)(rd32(self, 1768));
    /* 0x4b4103 */
    fa = ((uint32_t)((((uint32_t)eax) + (world->value_58318a)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4b4109 */
    ecx = L12;
    /* 0x4b410c */
    wr32(self, 1800, (uint32_t)((uint32_t)eax));
    /* 0x4b4112 */
    edx = L12;
    /* 0x4b4115 */
    eax = (uint32_t)(rd32(self, 1756));
    /* 0x4b411b */
    fa = ((uint32_t)((((uint32_t)eax) + (world->value_583186)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4b4121 */
    ecx = L12;
    /* 0x4b4124 */
    wr32(self, 1788, (uint32_t)((uint32_t)eax));
    /* 0x4b412a */
    edx = L12;
    /* 0x4b412d */
    eax = (uint32_t)(rd32(self, 1764));
    /* 0x4b4133 */
    fa = ((uint32_t)((((uint32_t)eax) + (world->value_583186)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4b4139 */
    ecx = L12;
    /* 0x4b413c */
    wr32(self, 1796, (uint32_t)((uint32_t)eax));
    /* 0x4b4142 */
    goto L4b42cf;
L4b4147:;
    /* 0x4b4147 */
    edx = L12;
    /* 0x4b414a */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 1828)));
    /* 0x4b4151 */
    ecx = (uint32_t)((uint32_t)L4);
    /* 0x4b4154 */
    fa = ((uint32_t)((((uint32_t)ecx) - ((uint32_t)eax)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4b4156 */
    edx = L12;
    /* 0x4b4159 */
    wr32(self, 1760, (uint32_t)((uint32_t)ecx));
    /* 0x4b415f */
    eax = L12;
    /* 0x4b4162 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 1826)));
    /* 0x4b4169 */
    edx = L12;
    /* 0x4b416c */
    eax = (uint32_t)(rd32(self, 1760));
    /* 0x4b4172 */
    fa = ((uint32_t)((((uint32_t)eax) + ((uint32_t)ecx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4b4174 */
    ecx = L12;
    /* 0x4b4177 */
    wr32(self, 1768, (uint32_t)((uint32_t)eax));
    /* 0x4b417d */
    edx = L12;
    /* 0x4b4180 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 1824)));
    /* 0x4b4187 */
    ecx = (uint32_t)((uint32_t)L8);
    /* 0x4b418a */
    fa = ((uint32_t)((((uint32_t)ecx) - ((uint32_t)eax)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4b418c */
    edx = L12;
    /* 0x4b418f */
    wr32(self, 1756, (uint32_t)((uint32_t)ecx));
    /* 0x4b4195 */
    eax = L12;
    /* 0x4b4198 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 1822)));
    /* 0x4b419f */
    edx = L12;
    /* 0x4b41a2 */
    eax = (uint32_t)(rd32(self, 1756));
    /* 0x4b41a8 */
    fa = ((uint32_t)((((uint32_t)eax) + ((uint32_t)ecx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4b41aa */
    ecx = L12;
    /* 0x4b41ad */
    wr32(self, 1764, (uint32_t)((uint32_t)eax));
    /* 0x4b41b3 */
    ecx = L12;
    /* 0x4b41b6 */
    eax = (uintptr_t)call0(host, 0x4b3e99, ecx);
    /* 0x4b41bb */
    edx = L12;
    /* 0x4b41be */
    eax = L12;
    /* 0x4b41c1 */
    ecx = (uint32_t)(rd32(self, 1760));
    /* 0x4b41c7 */
    wr32(self, 1776, (uint32_t)((uint32_t)ecx));
    /* 0x4b41cd */
    edx = L12;
    /* 0x4b41d0 */
    eax = L12;
    /* 0x4b41d3 */
    ecx = (uint32_t)(rd32(self, 1768));
    /* 0x4b41d9 */
    wr32(self, 1784, (uint32_t)((uint32_t)ecx));
    /* 0x4b41df */
    edx = L12;
    /* 0x4b41e2 */
    eax = L12;
    /* 0x4b41e5 */
    ecx = (uint32_t)(rd32(self, 1756));
    /* 0x4b41eb */
    wr32(self, 1772, (uint32_t)((uint32_t)ecx));
    /* 0x4b41f1 */
    edx = L12;
    /* 0x4b41f4 */
    eax = L12;
    /* 0x4b41f7 */
    ecx = (uint32_t)(rd32(self, 1764));
    /* 0x4b41fd */
    wr32(self, 1780, (uint32_t)((uint32_t)ecx));
    /* 0x4b4203 */
    edx = L12;
    /* 0x4b4206 */
    eax = (uint32_t)(rd32(self, 1760));
    /* 0x4b420c */
    fa = ((uint32_t)((((uint32_t)eax) + (world->value_58318a)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4b4212 */
    ecx = L12;
    /* 0x4b4215 */
    wr32(self, 1792, (uint32_t)((uint32_t)eax));
    /* 0x4b421b */
    edx = L12;
    /* 0x4b421e */
    eax = (uint32_t)(rd32(self, 1768));
    /* 0x4b4224 */
    fa = ((uint32_t)((((uint32_t)eax) + (world->value_58318a)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4b422a */
    ecx = L12;
    /* 0x4b422d */
    wr32(self, 1800, (uint32_t)((uint32_t)eax));
    /* 0x4b4233 */
    edx = L12;
    /* 0x4b4236 */
    eax = (uint32_t)(rd32(self, 1756));
    /* 0x4b423c */
    fa = ((uint32_t)((((uint32_t)eax) + (world->value_583186)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4b4242 */
    ecx = L12;
    /* 0x4b4245 */
    wr32(self, 1788, (uint32_t)((uint32_t)eax));
    /* 0x4b424b */
    edx = L12;
    /* 0x4b424e */
    eax = (uint32_t)(rd32(self, 1764));
    /* 0x4b4254 */
    fa = ((uint32_t)((((uint32_t)eax) + (world->value_583186)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4b425a */
    ecx = L12;
    /* 0x4b425d */
    wr32(self, 1796, (uint32_t)((uint32_t)eax));
    /* 0x4b4263 */
    edx = L12;
    /* 0x4b4266 */
    eax = (uint32_t)(rd32(self, 1776));
    /* 0x4b426c */
    fa = ((uint32_t)((((uint32_t)eax) + (world->value_58318a)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4b4272 */
    ecx = L12;
    /* 0x4b4275 */
    wr32(self, 1808, (uint32_t)((uint32_t)eax));
    /* 0x4b427b */
    edx = L12;
    /* 0x4b427e */
    eax = (uint32_t)(rd32(self, 1784));
    /* 0x4b4284 */
    fa = ((uint32_t)((((uint32_t)eax) + (world->value_58318a)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4b428a */
    ecx = L12;
    /* 0x4b428d */
    wr32(self, 1816, (uint32_t)((uint32_t)eax));
    /* 0x4b4293 */
    edx = L12;
    /* 0x4b4296 */
    eax = (uint32_t)(rd32(self, 1772));
    /* 0x4b429c */
    fa = ((uint32_t)((((uint32_t)eax) + (world->value_583186)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4b42a2 */
    ecx = L12;
    /* 0x4b42a5 */
    wr32(self, 1804, (uint32_t)((uint32_t)eax));
    /* 0x4b42ab */
    edx = L12;
    /* 0x4b42ae */
    eax = (uint32_t)(rd32(self, 1780));
    /* 0x4b42b4 */
    fa = ((uint32_t)((((uint32_t)eax) + (world->value_583186)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4b42ba */
    ecx = L12;
    /* 0x4b42bd */
    wr32(self, 1812, (uint32_t)((uint32_t)eax));
    /* 0x4b42c3 */
    edx = L12;
    /* 0x4b42c6 */
    wr16(self, 1874, (uint16_t)(0x1u));
L4b42cf:;
    /* 0x4b42cf */
    /* 0x4b42d1 */
    /* 0x4b42d2 */
    return 0;
}

/* ---- 0x4b450f lifted ---- */
/* 0x4b450f, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Stores to [self+0x758]/2. Globals: 0x5b44f0/4 (written), 0x5b44f4/4 (written), 0x5c39e5/4 (written), 0x5d0377/4, 0x5d162d/4 (written), 0x5d1631/4 (written), 0x5d1639/4 (written). Returns this. */
uint8_t * m4b450f_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4b4512 */
    L4 = ecx;
    /* 0x4b4513 */
    L4 = ecx;
    /* 0x4b4516 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)A0 & 0xffffu)));
    /* 0x4b451a */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4b451c */
    if (((fa >> 31) & 1u) != 0) goto L4b4589;
    /* 0x4b451e */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)A0 & 0xffffu)));
    /* 0x4b4522 */
    fa = (uint32_t)ecx;
    fb = 0x3u;
    /* 0x4b4525 */
    if ((int32_t)fa >= (int32_t)fb) goto L4b4589;
    /* 0x4b4527 */
    world->value_5b44f0 = (uint32_t)(0x12u);
    /* 0x4b4531 */
    world->value_5b44f4 = (uint32_t)(0x1u);
    /* 0x4b453b */
    edx = (uint32_t)(world->value_5d0377);
    /* 0x4b4541 */
    world->value_5d162d = (uint32_t)((uint32_t)edx);
    /* 0x4b4547 */
    eax = (uint32_t)(world->value_5b44f0);
    /* 0x4b454c */
    fa = ((uint32_t)((((uint32_t)eax) << 5u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4b454f */
    ecx = (uint32_t)(world->value_5b44f4);
    /* 0x4b4555 */
    fa = ((uint32_t)((((uint32_t)ecx) << 4u) & 0xffffffffu)) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4b4558 */
    edx = (uint32_t)((uint32_t)eax + (uint32_t)ecx + (uint32_t)5969420);
    /* 0x4b455f */
    world->value_5d1631 = (uint32_t)((uint32_t)edx);
    /* 0x4b4565 */
    world->value_5d1639 = (uint32_t)(0x1u);
    /* 0x4b456f */
    world->value_5c39e5 = (uint32_t)(0x2738u);
    /* 0x4b4579 */
    eax = L4;
    /* 0x4b457c */
    ecx = (uint32_t)(((uint32_t)ecx & 0xffff0000u) | (((((uint32_t)A0 & 0xffffu)) & 0xffffu) << 0));
    /* 0x4b4580 */
    wr16(self, 1880, (uint16_t)(((uint32_t)ecx & 0xffffu)));
    /* 0x4b4587 */
    goto L4b45e7;
L4b4589:;
    /* 0x4b4589 */
    world->value_5b44f0 = (uint32_t)(0x9u);
    /* 0x4b4593 */
    world->value_5b44f4 = (uint32_t)(0x1u);
    /* 0x4b459d */
    edx = (uint32_t)(world->value_5d0377);
    /* 0x4b45a3 */
    world->value_5d162d = (uint32_t)((uint32_t)edx);
    /* 0x4b45a9 */
    eax = (uint32_t)(world->value_5b44f0);
    /* 0x4b45ae */
    fa = ((uint32_t)((((uint32_t)eax) << 5u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4b45b1 */
    ecx = (uint32_t)(world->value_5b44f4);
    /* 0x4b45b7 */
    fa = ((uint32_t)((((uint32_t)ecx) << 4u) & 0xffffffffu)) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4b45ba */
    edx = (uint32_t)((uint32_t)eax + (uint32_t)ecx + (uint32_t)5969420);
    /* 0x4b45c1 */
    world->value_5d1631 = (uint32_t)((uint32_t)edx);
    /* 0x4b45c7 */
    world->value_5d1639 = (uint32_t)(0x1u);
    /* 0x4b45d1 */
    world->value_5c39e5 = (uint32_t)(0x2739u);
    /* 0x4b45db */
    eax = L4;
    /* 0x4b45de */
    wr16(self, 1880, (uint16_t)(0xffffu));
L4b45e7:;
    /* 0x4b45e7 */
    /* 0x4b45e9 */
    /* 0x4b45ea */
    return (uint8_t *)eax;
}

/* ---- 0x4b72a9 lifted ---- */
/* 0x4b72a9, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5957c5/2 (written), 0x5957c7/2 (written), 0x5957c9/2 (written). eax is left-over and not meaningful. */
uint32_t m4b72a9_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)ecx;
    (void)world;
    /* 0x4b72ac */
    L4 = ecx;
    /* 0x4b72ad */
    L4 = ecx;
    /* 0x4b72b0 */
    world->word_5957c5 = (uint16_t)(0x0u);
    /* 0x4b72b9 */
    world->word_5957c7 = (uint16_t)(0x0u);
    /* 0x4b72c2 */
    world->word_5957c9 = (uint16_t)(0x0u);
    /* 0x4b72cb */
    /* 0x4b72cd */
    /* 0x4b72ce */
    return 0;
}

/* ---- 0x4b9e3b lifted ---- */
/* 0x4b9e3b, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x4]/2, [self+0x6]/2, [self+0x8]/4, [self+0xc]/4, [self+0x10]/4, [self+0x14]/4, [self+0x18]/4, [self+0x34]/4. ... Returns eax. */
uint32_t m4b9e3b_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edi = 0;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edi;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4b9e3e */
    L4 = ecx;
    /* 0x4b9e3f */
    /* 0x4b9e40 */
    L4 = ecx;
    /* 0x4b9e43 */
    eax = L4;
    /* 0x4b9e46 */
    wr16(self, 6, (uint16_t)(0xffffu));
    /* 0x4b9e4c */
    ecx = L4;
    /* 0x4b9e4f */
    wr16(self, 4, (uint16_t)(0xffffu));
    /* 0x4b9e55 */
    edx = L4;
    /* 0x4b9e58 */
    wr32(self, 24, (uint32_t)(0x0u));
    /* 0x4b9e5f */
    eax = L4;
    /* 0x4b9e62 */
    wr32(self, 52, (uint32_t)(0x0u));
    /* 0x4b9e69 */
    ecx = L4;
    /* 0x4b9e6c */
    wr32(self, 56, (uint32_t)(0x0u));
    /* 0x4b9e73 */
    edx = L4;
    /* 0x4b9e76 */
    wr32(self, 60, (uint32_t)(0x0u));
    /* 0x4b9e7d */
    eax = L4;
    /* 0x4b9e80 */
    wr32(self, 68, (uint32_t)(0x0u));
    /* 0x4b9e87 */
    ecx = L4;
    /* 0x4b9e8a */
    wr32(self, 64, (uint32_t)(0x0u));
    /* 0x4b9e91 */
    edx = L4;
    /* 0x4b9e94 */
    wr32(self, 72, (uint32_t)(0x0u));
    /* 0x4b9e9b */
    eax = L4;
    /* 0x4b9e9e */
    wr32(self, 388, (uint32_t)(0x0u));
    /* 0x4b9ea8 */
    ecx = L4;
    /* 0x4b9eab */
    wr32(self, 392, (uint32_t)(0x0u));
    /* 0x4b9eb5 */
    edx = L4;
    /* 0x4b9eb8 */
    wr32(self, 432, (uint32_t)(0x0u));
    /* 0x4b9ec2 */
    eax = L4;
    /* 0x4b9ec5 */
    wr32(self, 436, (uint32_t)(0x0u));
    /* 0x4b9ecf */
    ecx = L4;
    /* 0x4b9ed2 */
    wr32(self, 716, (uint32_t)(0x0u));
    /* 0x4b9edc */
    edx = L4;
    /* 0x4b9edf */
    wr32(self, 396, (uint32_t)(0x0u));
    /* 0x4b9ee9 */
    eax = L4;
    /* 0x4b9eec */
    wr32(self, 400, (uint32_t)(0x0u));
    /* 0x4b9ef6 */
    ecx = L4;
    /* 0x4b9ef9 */
    wr32(self, 404, (uint32_t)(0x0u));
    /* 0x4b9f03 */
    edx = L4;
    /* 0x4b9f06 */
    wr32(self, 732, (uint32_t)(0x0u));
    /* 0x4b9f10 */
    eax = L4;
    /* 0x4b9f13 */
    wr32(self, 736, (uint32_t)(0x0u));
    /* 0x4b9f1d */
    ecx = L4;
    /* 0x4b9f20 */
    wr32(self, 740, (uint32_t)(0x0u));
    /* 0x4b9f2a */
    edx = L4;
    /* 0x4b9f2d */
    wr32(self, 744, (uint32_t)(0x0u));
    /* 0x4b9f37 */
    eax = L4;
    /* 0x4b9f3a */
    wr32(self, 748, (uint32_t)(0x0u));
    /* 0x4b9f44 */
    ecx = L4;
    /* 0x4b9f47 */
    wr32(self, 752, (uint32_t)(0x0u));
    /* 0x4b9f51 */
    edx = L4;
    /* 0x4b9f54 */
    wr32(self, 728, (uint32_t)(0x0u));
    /* 0x4b9f5e */
    eax = L4;
    /* 0x4b9f61 */
    wr32(self, 760, (uint32_t)(0x0u));
    /* 0x4b9f6b */
    ecx = L4;
    /* 0x4b9f6e */
    wr32(self, 764, (uint32_t)(0x0u));
    /* 0x4b9f78 */
    edx = L4;
    /* 0x4b9f7b */
    wr32(self, 768, (uint32_t)(0x0u));
    /* 0x4b9f85 */
    eax = L4;
    /* 0x4b9f88 */
    wr32(self, 772, (uint32_t)(0x0u));
    /* 0x4b9f92 */
    ecx = L4;
    /* 0x4b9f95 */
    wr32(self, 776, (uint32_t)(0x0u));
    /* 0x4b9f9f */
    edx = L4;
    /* 0x4b9fa2 */
    wr32(self, 8, (uint32_t)(0x0u));
    /* 0x4b9fa9 */
    eax = L4;
    /* 0x4b9fac */
    wr32(self, 12, (uint32_t)(0x0u));
    /* 0x4b9fb3 */
    ecx = L4;
    /* 0x4b9fb6 */
    wr32(self, 16, (uint32_t)(0x0u));
    /* 0x4b9fbd */
    edx = L4;
    /* 0x4b9fc0 */
    wr32(self, 20, (uint32_t)(0x0u));
    /* 0x4b9fc7 */
    eax = L4;
    /* 0x4b9fca */
    wr32(self, 708, (uint32_t)(0x0u));
    /* 0x4b9fd4 */
    ecx = (uint32_t)(0u);
    fa = 0u;
    /* 0x4b9fd6 */
    edx = L4;
    /* 0x4b9fd9 */
    edx = (uintptr_t)(self + (444));
    /* 0x4b9fdf */
    wr32(self, 444, (uint32_t)((uint32_t)ecx));
    /* 0x4b9fe1 */
    wr32(self, 448, (uint32_t)((uint32_t)ecx));
    /* 0x4b9fe4 */
    wr32(self, 452, (uint32_t)((uint32_t)ecx));
    /* 0x4b9fe7 */
    wr32(self, 456, (uint32_t)((uint32_t)ecx));
    /* 0x4b9fea */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4b9fec */
    ecx = L4;
    /* 0x4b9fef */
    ecx = (uintptr_t)(self + (460));
    /* 0x4b9ff5 */
    wr32(self, 460, (uint32_t)((uint32_t)eax));
    /* 0x4b9ff7 */
    wr32(self, 464, (uint32_t)((uint32_t)eax));
    /* 0x4b9ffa */
    wr32(self, 468, (uint32_t)((uint32_t)eax));
    /* 0x4b9ffd */
    wr32(self, 472, (uint32_t)((uint32_t)eax));
    /* 0x4ba000 */
    edx = (uint32_t)(0u);
    fa = 0u;
    /* 0x4ba002 */
    eax = L4;
    /* 0x4ba005 */
    eax = (uintptr_t)(self + (88));
    /* 0x4ba008 */
    wr32(self, 88, (uint32_t)((uint32_t)edx));
    /* 0x4ba00a */
    wr32(self, 92, (uint32_t)((uint32_t)edx));
    /* 0x4ba00d */
    wr32(self, 96, (uint32_t)((uint32_t)edx));
    /* 0x4ba010 */
    wr32(self, 100, (uint32_t)((uint32_t)edx));
    /* 0x4ba013 */
    ecx = (uint32_t)(0u);
    fa = 0u;
    /* 0x4ba015 */
    edx = L4;
    /* 0x4ba018 */
    edx = (uintptr_t)(self + (476));
    /* 0x4ba01e */
    wr32(self, 476, (uint32_t)((uint32_t)ecx));
    /* 0x4ba020 */
    wr32(self, 480, (uint32_t)((uint32_t)ecx));
    /* 0x4ba023 */
    wr32(self, 484, (uint32_t)((uint32_t)ecx));
    /* 0x4ba026 */
    wr32(self, 488, (uint32_t)((uint32_t)ecx));
    /* 0x4ba029 */
    ecx = (uint32_t)(0xcu);
    /* 0x4ba02e */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4ba030 */
    edi = L4;
    /* 0x4ba033 */
    edi = (uintptr_t)(self + (992));
    /* 0x4ba039 */
    rep_stos((self + (992)), (uint32_t)eax, (uint32_t)ecx, 4);
    edi = (uintptr_t)(self + (1040));
    ecx = 0;
    /* 0x4ba03b */
    rep_stos((self + (1040)), ((uint32_t)eax & 0xffu), 1u, 1);
    edi = (uintptr_t)(self + (1041));
    /* 0x4ba03c */
    ecx = (uint32_t)(0x6u);
    /* 0x4ba041 */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4ba043 */
    edi = L4;
    /* 0x4ba046 */
    edi = (uintptr_t)(self + (500));
    /* 0x4ba04c */
    rep_stos((self + (500)), (uint32_t)eax, (uint32_t)ecx, 4);
    edi = (uintptr_t)(self + (524));
    ecx = 0;
    /* 0x4ba04e */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4ba050 */
    ecx = L4;
    /* 0x4ba053 */
    ecx = (uintptr_t)(self + (76));
    /* 0x4ba056 */
    wr32(self, 76, (uint32_t)((uint32_t)eax));
    /* 0x4ba058 */
    wr32(self, 80, (uint32_t)((uint32_t)eax));
    /* 0x4ba05b */
    ecx = (uint32_t)(0x2eu);
    /* 0x4ba060 */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4ba062 */
    edi = L4;
    /* 0x4ba065 */
    edi = (uintptr_t)(self + (524));
    /* 0x4ba06b */
    rep_stos((self + (524)), (uint32_t)eax, (uint32_t)ecx, 4);
    edi = (uintptr_t)(self + (708));
    ecx = 0;
    /* 0x4ba06d */
    edx = L4;
    /* 0x4ba070 */
    wr32(self, 700, (uint32_t)(0xffffffffu));
    /* 0x4ba07a */
    /* 0x4ba07b */
    /* 0x4ba07d */
    /* 0x4ba07e */
    return (uint32_t)eax;
}

/* ---- 0x4ba07f lifted ---- */
/* 0x4ba07f, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x8]/4, [self+0xc]/4, [self+0x10]/4, [self+0x14]/4, [self+0x4]/2, [self+0x2bc]/4, [self+0x2bc]/2. Calls (in code order): 0x4b9e3b(this, 0 args), 0x4be18b(this, 0 args), 0x4c2dfb(this, 1 arg), 0x4d3992(1 arg). Returns eax. */
uint32_t m4ba07f_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4ba082 */
    L4 = ecx;
    /* 0x4ba083 */
    L4 = ecx;
    /* 0x4ba086 */
    eax = L4;
    /* 0x4ba089 */
    fa = rd32(self, 8);
    fb = 0x0u;
    /* 0x4ba08d */
    if (fa == fb) goto L4ba0a0;
    /* 0x4ba08f */
    ecx = L4;
    /* 0x4ba092 */
    ecx = (uintptr_t)(self + (8));
    /* 0x4ba095 */
    L8 = ecx;
    /* 0x4ba096 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4ba09b */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, L8);
L4ba0a0:;
    /* 0x4ba0a0 */
    edx = L4;
    /* 0x4ba0a3 */
    fa = rd32(self, 12);
    fb = 0x0u;
    /* 0x4ba0a7 */
    if (fa == fb) goto L4ba0ba;
    /* 0x4ba0a9 */
    eax = L4;
    /* 0x4ba0ac */
    eax = (uintptr_t)(self + (12));
    /* 0x4ba0af */
    L8 = eax;
    /* 0x4ba0b0 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4ba0b5 */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, L8);
L4ba0ba:;
    /* 0x4ba0ba */
    ecx = L4;
    /* 0x4ba0bd */
    fa = rd32(self, 16);
    fb = 0x0u;
    /* 0x4ba0c1 */
    if (fa == fb) goto L4ba0d4;
    /* 0x4ba0c3 */
    edx = L4;
    /* 0x4ba0c6 */
    edx = (uintptr_t)(self + (16));
    /* 0x4ba0c9 */
    L8 = edx;
    /* 0x4ba0ca */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4ba0cf */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, L8);
L4ba0d4:;
    /* 0x4ba0d4 */
    eax = L4;
    /* 0x4ba0d7 */
    fa = rd32(self, 20);
    fb = 0x0u;
    /* 0x4ba0db */
    if (fa == fb) goto L4ba0ee;
    /* 0x4ba0dd */
    ecx = L4;
    /* 0x4ba0e0 */
    ecx = (uintptr_t)(self + (20));
    /* 0x4ba0e3 */
    L8 = ecx;
    /* 0x4ba0e4 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4ba0e9 */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, L8);
L4ba0ee:;
    /* 0x4ba0ee */
    ecx = L4;
    /* 0x4ba0f1 */
    eax = (uintptr_t)call0(host, 0x4be18b, ecx);
    /* 0x4ba0f6 */
    edx = L4;
    /* 0x4ba0f9 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 4)));
    /* 0x4ba0fd */
    fa = (uint32_t)eax;
    fb = 0xffffffffu;
    /* 0x4ba100 */
    if (fa == fb) goto L4ba112;
    /* 0x4ba102 */
    ecx = L4;
    /* 0x4ba105 */
    edx = (uint32_t)(((uint32_t)rd16(self, 4)) & 0xffffu);
    /* 0x4ba109 */
    L8 = (uint32_t)(uint32_t)edx;
    /* 0x4ba10a */
    eax = (uintptr_t)call1(host, 0x4d3992, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4ba10f */
L4ba112:;
    /* 0x4ba112 */
    eax = L4;
    /* 0x4ba115 */
    fa = rd32(self, 700);
    fb = 0xffffffffu;
    /* 0x4ba11c */
    if (fa == fb) goto L4ba131;
    /* 0x4ba11e */
    ecx = L4;
    /* 0x4ba121 */
    edx = (uint32_t)(((uint32_t)rd16(self, 700)) & 0xffffu);
    /* 0x4ba128 */
    L8 = (uint32_t)(uint32_t)edx;
    /* 0x4ba129 */
    eax = (uintptr_t)call1(host, 0x4d3992, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4ba12e */
L4ba131:;
    /* 0x4ba131 */
    ecx = L4;
    /* 0x4ba134 */
    eax = (uintptr_t)call0(host, 0x4b9e3b, ecx);
    /* 0x4ba139 */
    /* 0x4ba13b */
    /* 0x4ba13c */
    return (uint32_t)eax;
}

/* ---- 0x4ba262 lifted ---- */
/* 0x4ba262, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x34]/4, [self+0x5c]/4, [self+0x64]/4, [self+0x58]/4, [self+0x60]/4. Globals: 0x583102/4, 0x583106/4, 0x58310a/4, 0x58310e/4. Returns eax. */
uint32_t m4ba262_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4ba265 */
    L4 = ecx;
    /* 0x4ba266 */
    L4 = ecx;
    /* 0x4ba269 */
    eax = L4;
    /* 0x4ba26c */
    fa = rd32(self, 52);
    fb = 0x0u;
    /* 0x4ba270 */
    if (fa != fb) goto L4ba279;
    /* 0x4ba272 */
    eax = (uint32_t)(0x1u);
    /* 0x4ba277 */
    goto L4ba2b9;
L4ba279:;
    /* 0x4ba279 */
    ecx = L4;
    /* 0x4ba27c */
    edx = (uint32_t)(world->value_583106);
    /* 0x4ba282 */
    fa = (uint32_t)edx;
    fb = rd32(self, 92);
    /* 0x4ba285 */
    if ((int32_t)fa < (int32_t)fb) goto L4ba2b4;
    /* 0x4ba287 */
    eax = L4;
    /* 0x4ba28a */
    ecx = (uint32_t)(world->value_58310e);
    /* 0x4ba290 */
    fa = (uint32_t)ecx;
    fb = rd32(self, 100);
    /* 0x4ba293 */
    if ((int32_t)fa > (int32_t)fb) goto L4ba2b4;
    /* 0x4ba295 */
    edx = L4;
    /* 0x4ba298 */
    eax = (uint32_t)(world->value_583102);
    /* 0x4ba29d */
    fa = (uint32_t)eax;
    fb = rd32(self, 88);
    /* 0x4ba2a0 */
    if ((int32_t)fa < (int32_t)fb) goto L4ba2b4;
    /* 0x4ba2a2 */
    ecx = L4;
    /* 0x4ba2a5 */
    edx = (uint32_t)(world->value_58310a);
    /* 0x4ba2ab */
    fa = (uint32_t)edx;
    fb = rd32(self, 96);
    /* 0x4ba2ae */
    if ((int32_t)fa > (int32_t)fb) goto L4ba2b4;
    /* 0x4ba2b0 */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4ba2b2 */
    goto L4ba2b9;
L4ba2b4:;
    /* 0x4ba2b4 */
    eax = (uint32_t)(0x1u);
L4ba2b9:;
    /* 0x4ba2b9 */
    /* 0x4ba2bb */
    /* 0x4ba2bc */
    return (uint32_t)eax;
}

/* ---- 0x4ba486 lifted ---- */
/* 0x4ba486, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Stores to [self+0x2d4]/4. Globals: 0x5b44f0/4 (written), 0x5b44f4/4 (written), 0x5c39e5/4 (written), 0x5d0377/4, 0x5d162d/4 (written), 0x5d1631/4 (written), 0x5d1639/4 (written). Returns eax. */
uint32_t m4ba486_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4ba489 */
    L4 = ecx;
    /* 0x4ba48a */
    L4 = ecx;
    /* 0x4ba48d */
    world->value_5c39e5 = (uint32_t)(0x276au);
    /* 0x4ba497 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)A0 & 0xffffu)));
    /* 0x4ba49b */
    ecx = L4;
    /* 0x4ba49e */
    wr32(self, 724, (uint32_t)((uint32_t)eax));
    /* 0x4ba4a4 */
    world->value_5b44f0 = (uint32_t)(0x0u);
    /* 0x4ba4ae */
    world->value_5b44f4 = (uint32_t)(0x1u);
    /* 0x4ba4b8 */
    edx = (uint32_t)(world->value_5d0377);
    /* 0x4ba4be */
    world->value_5d162d = (uint32_t)((uint32_t)edx);
    /* 0x4ba4c4 */
    eax = (uint32_t)(world->value_5b44f0);
    /* 0x4ba4c9 */
    fa = ((uint32_t)((((uint32_t)eax) << 5u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4ba4cc */
    ecx = (uint32_t)(world->value_5b44f4);
    /* 0x4ba4d2 */
    fa = ((uint32_t)((((uint32_t)ecx) << 4u) & 0xffffffffu)) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4ba4d5 */
    edx = (uint32_t)((uint32_t)eax + (uint32_t)ecx + (uint32_t)5969420);
    /* 0x4ba4dc */
    world->value_5d1631 = (uint32_t)((uint32_t)edx);
    /* 0x4ba4e2 */
    world->value_5d1639 = (uint32_t)(0x1u);
    /* 0x4ba4ec */
    /* 0x4ba4ee */
    /* 0x4ba4ef */
    return (uint32_t)eax;
}

/* ---- 0x4be2c6 lifted ---- */
/* 0x4be2c6, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through). Reads [a0+0x38]/4, [self+0x1a4]/4, [self+0x1a8]/4. Stores to [self+0x1a4]/4, [self+0x1a8]/4. Calls (in code order): 0x51dc6c(1 arg). eax is left-over and not meaningful. */
uint32_t m4be2c6_lifted(uint8_t *self, uint8_t *a0, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)L12;
    (void)L16;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4be2c9 */
    /* 0x4be2cc */
    L8 = ecx;
    /* 0x4be2cf */
    fa = (uint32_t)(A0 != 0);
    fb = 0u;
    /* 0x4be2d3 */
    if (fa != fb) goto L4be2da;
    /* 0x4be2d5 */
    goto L4be361;
L4be2da:;
    /* 0x4be2da */
    eax = A0;
    /* 0x4be2dd */
    ecx = (uint32_t)(rd32(a0, 56));
    /* 0x4be2e0 */
    L12 = (uint32_t)((uint32_t)ecx);
    /* 0x4be2e3 */
    fa = (uint32_t)L12;
    fb = 0x0u;
    /* 0x4be2e7 */
    if (fa == fb) goto L4be2f1;
    /* 0x4be2e9 */
    fa = (uint32_t)L12;
    fb = 0x1u;
    /* 0x4be2ed */
    if (fa == fb) goto L4be321;
    /* 0x4be2ef */
    goto L4be34f;
L4be2f1:;
    /* 0x4be2f1 */
    edx = L8;
    /* 0x4be2f4 */
    eax = (uint32_t)(rd32(self, 420));
    /* 0x4be2fa */
    fa = ((uint32_t)((((uint32_t)eax) - (0x1u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4be2fd */
    ecx = L8;
    /* 0x4be300 */
    wr32(self, 420, (uint32_t)((uint32_t)eax));
    /* 0x4be306 */
    edx = L8;
    /* 0x4be309 */
    fa = rd32(self, 420);
    fb = 0x0u;
    /* 0x4be310 */
    if ((int32_t)fa >= (int32_t)fb) goto L4be31f;
    /* 0x4be312 */
    eax = L8;
    /* 0x4be315 */
    wr32(self, 420, (uint32_t)(0x0u));
L4be31f:;
    /* 0x4be31f */
    goto L4be34f;
L4be321:;
    /* 0x4be321 */
    ecx = L8;
    /* 0x4be324 */
    edx = (uint32_t)(rd32(self, 424));
    /* 0x4be32a */
    fa = ((uint32_t)((((uint32_t)edx) - (0x1u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4be32d */
    eax = L8;
    /* 0x4be330 */
    wr32(self, 424, (uint32_t)((uint32_t)edx));
    /* 0x4be336 */
    ecx = L8;
    /* 0x4be339 */
    fa = rd32(self, 424);
    fb = 0x0u;
    /* 0x4be340 */
    if ((int32_t)fa >= (int32_t)fb) goto L4be34f;
    /* 0x4be342 */
    edx = L8;
    /* 0x4be345 */
    wr32(self, 424, (uint32_t)(0x0u));
L4be34f:;
    /* 0x4be34f */
    eax = A0;
    /* 0x4be352 */
    L4 = eax;
    /* 0x4be355 */
    ecx = L4;
    /* 0x4be358 */
    L16 = ecx;
    /* 0x4be359 */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, L16);
    /* 0x4be35e */
L4be361:;
    /* 0x4be361 */
    /* 0x4be363 */
    /* 0x4be364 */
    return 0;
}

/* ---- 0x4bed70 lifted ---- */
/* 0x4bed70, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x0]/4, [self+0x4]/4. Calls (in code order): 0x4bedb5(this, 0 args). Returns this. */
uint8_t * m4bed70_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x4bed73 */
    L4 = ecx;
    /* 0x4bed74 */
    L4 = ecx;
    /* 0x4bed77 */
    eax = L4;
    /* 0x4bed7a */
    wr32(self, 0, (uint32_t)(0x52e210u));
    /* 0x4bed80 */
    ecx = L4;
    /* 0x4bed83 */
    wr32(self, 4, (uint32_t)(0xffffffffu));
    /* 0x4bed8a */
    ecx = L4;
    /* 0x4bed8d */
    eax = (uintptr_t)call0(host, 0x4bedb5, ecx);
    /* 0x4bed92 */
    eax = L4;
    /* 0x4bed95 */
    /* 0x4bed97 */
    /* 0x4bed98 */
    return (uint8_t *)eax;
}

/* ---- 0x4bf63b lifted ---- */
/* 0x4bf63b, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x29]/4, [self+0x2d]/4, [self+0x31]/4, [self+0x35]/4, [self+0x55]/1, [self+0x17a]/4, [self+0x17e]/4, [self+0x182]/4. ... Globals: 0x5d19fb/4 (written). Returns this. */
uint8_t * m4bf63b_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)world;
    /* 0x4bf63e */
    L4 = ecx;
    /* 0x4bf63f */
    L4 = ecx;
    /* 0x4bf642 */
    eax = L4;
    /* 0x4bf645 */
    wr32(self, 572, (uint32_t)(0x0u));
    /* 0x4bf64f */
    ecx = L4;
    /* 0x4bf652 */
    wr32(self, 582, (uint32_t)(0x0u));
    /* 0x4bf65c */
    edx = L4;
    /* 0x4bf65f */
    wr32(self, 534, (uint32_t)(0x0u));
    /* 0x4bf669 */
    eax = L4;
    /* 0x4bf66c */
    wr32(self, 538, (uint32_t)(0x0u));
    /* 0x4bf676 */
    ecx = L4;
    /* 0x4bf679 */
    wr32(self, 542, (uint32_t)(0x0u));
    /* 0x4bf683 */
    edx = L4;
    /* 0x4bf686 */
    wr32(self, 546, (uint32_t)(0x0u));
    /* 0x4bf690 */
    eax = L4;
    /* 0x4bf693 */
    wr32(self, 470, (uint32_t)(0x0u));
    /* 0x4bf69d */
    ecx = L4;
    /* 0x4bf6a0 */
    wr32(self, 550, (uint32_t)(0x0u));
    /* 0x4bf6aa */
    edx = L4;
    /* 0x4bf6ad */
    wr32(self, 554, (uint32_t)(0x0u));
    /* 0x4bf6b7 */
    eax = L4;
    /* 0x4bf6ba */
    self[85] = (uint8_t)(0x0u);
    /* 0x4bf6be */
    ecx = L4;
    /* 0x4bf6c1 */
    wr32(self, 41, (uint32_t)(0x0u));
    /* 0x4bf6c8 */
    edx = L4;
    /* 0x4bf6cb */
    wr32(self, 53, (uint32_t)(0x0u));
    /* 0x4bf6d2 */
    eax = L4;
    /* 0x4bf6d5 */
    wr32(self, 45, (uint32_t)(0x0u));
    /* 0x4bf6dc */
    ecx = L4;
    /* 0x4bf6df */
    wr32(self, 49, (uint32_t)(0x0u));
    /* 0x4bf6e6 */
    edx = L4;
    /* 0x4bf6e9 */
    wr32(self, 398, (uint32_t)(0x0u));
    /* 0x4bf6f3 */
    eax = L4;
    /* 0x4bf6f6 */
    wr32(self, 386, (uint32_t)(0x0u));
    /* 0x4bf700 */
    ecx = L4;
    /* 0x4bf703 */
    wr32(self, 390, (uint32_t)(0x0u));
    /* 0x4bf70d */
    edx = L4;
    /* 0x4bf710 */
    wr16(self, 394, (uint16_t)(0x0u));
    /* 0x4bf719 */
    eax = L4;
    /* 0x4bf71c */
    wr16(self, 396, (uint16_t)(0x0u));
    /* 0x4bf725 */
    ecx = L4;
    /* 0x4bf728 */
    wr32(self, 378, (uint32_t)(0x1u));
    /* 0x4bf732 */
    edx = L4;
    /* 0x4bf735 */
    wr32(self, 382, (uint32_t)(0x0u));
    /* 0x4bf73f */
    world->value_5d19fb = (uint32_t)(0x0u);
    /* 0x4bf749 */
    eax = L4;
    /* 0x4bf74c */
    wr32(self, 576, (uint32_t)(0x0u));
    /* 0x4bf756 */
    ecx = L4;
    /* 0x4bf759 */
    wr16(self, 580, (uint16_t)(0xffffu));
    /* 0x4bf762 */
    edx = L4;
    /* 0x4bf765 */
    wr32(self, 586, (uint32_t)(0x0u));
    /* 0x4bf76f */
    /* 0x4bf771 */
    /* 0x4bf772 */
    return (uint8_t *)eax;
}

/* ---- 0x4bf8a7 lifted ---- */
/* 0x4bf8a7, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x4bf63b(this, 0 args), 0x4bf773(this, 0 args). Returns eax. */
uint32_t m4bf8a7_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x4bf8aa */
    L4 = ecx;
    /* 0x4bf8ab */
    L4 = ecx;
    /* 0x4bf8ae */
    ecx = L4;
    /* 0x4bf8b1 */
    eax = (uintptr_t)call0(host, 0x4bf773, ecx);
    /* 0x4bf8b6 */
    ecx = L4;
    /* 0x4bf8b9 */
    eax = (uintptr_t)call0(host, 0x4bf63b, ecx);
    /* 0x4bf8be */
    /* 0x4bf8c0 */
    /* 0x4bf8c1 */
    return (uint32_t)eax;
}

/* ---- 0x4c139a lifted ---- */
/* 0x4c139a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1f24]/4, [self+0x1f28]/4. Stores to [self+0x0]/4, [self+0x1f24]/4, [self+0x1f28]/4. Calls (in code order): 0x43ef27(this, 0 args), 0x51dc6c(1 arg). Returns eax. The structured-exception frame is linked and unlinked (not modelled). */
uint32_t m4c139a_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uintptr_t L24 = 0;
    uintptr_t L28 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L24;
    (void)L28;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4c139d */
    L4 = (uint32_t)(0xffffffffu);
    /* 0x4c139f */
    L8 = (uint32_t)(0x5287eau);
    /* 0x4c13a4 */
    /* 0x4c13aa */
    /* 0x4c13ab */
    /* 0x4c13b2 */
    /* 0x4c13b5 */
    L24 = ecx;
    /* 0x4c13b8 */
    eax = L24;
    /* 0x4c13bb */
    wr32(self, 0, (uint32_t)(0x52e230u));
    /* 0x4c13c1 */
    L4 = (uint32_t)(0x1u);
    /* 0x4c13c8 */
    ecx = L24;
    /* 0x4c13cb */
    fa = rd32(self, 7972);
    fb = 0x0u;
    /* 0x4c13d2 */
    if (fa == fb) goto L4c13f9;
    /* 0x4c13d4 */
    edx = L24;
    /* 0x4c13d7 */
    eax = (uint32_t)(rd32(self, 7972));
    /* 0x4c13dd */
    L16 = (uint32_t)((uint32_t)eax);
    /* 0x4c13e0 */
    ecx = (uint32_t)((uint32_t)L16);
    /* 0x4c13e3 */
    L28 = (uint32_t)((uint32_t)ecx);
    /* 0x4c13e4 */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L28);
    /* 0x4c13e9 */
    /* 0x4c13ec */
    edx = L24;
    /* 0x4c13ef */
    wr32(self, 7972, (uint32_t)(0x0u));
L4c13f9:;
    /* 0x4c13f9 */
    eax = L24;
    /* 0x4c13fc */
    fa = rd32(self, 7976);
    fb = 0x0u;
    /* 0x4c1403 */
    if (fa == fb) goto L4c142a;
    /* 0x4c1405 */
    ecx = L24;
    /* 0x4c1408 */
    edx = (uint32_t)(rd32(self, 7976));
    /* 0x4c140e */
    L20 = (uint32_t)((uint32_t)edx);
    /* 0x4c1411 */
    eax = (uint32_t)((uint32_t)L20);
    /* 0x4c1414 */
    L28 = (uint32_t)((uint32_t)eax);
    /* 0x4c1415 */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L28);
    /* 0x4c141a */
    /* 0x4c141d */
    ecx = L24;
    /* 0x4c1420 */
    wr32(self, 7976, (uint32_t)(0x0u));
L4c142a:;
    /* 0x4c142a */
    L4 = (uint32_t)(((uint32_t)L4 & 0xffffff00u) | (((0x0u) & 0xffu) << 0));
    /* 0x4c142e */
    ecx = L24;
    /* 0x4c1431 */
    ecx = (uintptr_t)(self + (14540));
    /* 0x4c1437 */
    eax = (uintptr_t)call0(host, 0x43ef27, ecx);
    /* 0x4c143c */
    L4 = (uint32_t)(0xffffffffu);
    /* 0x4c1443 */
    /* 0x4c1446 */
    /* 0x4c144d */
    /* 0x4c144f */
    /* 0x4c1450 */
    return (uint32_t)eax;
}

/* ---- 0x4c4b12 lifted ---- */
/* 0x4c4b12, this = ecx (self), `ret 0xc`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through), a1 dword, a2 host pointer (read through). Reads [a0+0x2f]/2, [a2+0x4]/4, [a0+0x0]/4, [a2+0x0]/4, [a2+0xc]/4, [a2+0x8]/4. Globals: 0x639895/2. Calls (in code order): 0x4264e8(this, 1 arg), 0x43ef77(this, 3 args), 0x43efb6(this, 3 args), 0x4c97b4(this, 0 args). Returns eax. */
uint32_t m4c4b12_lifted(uint8_t *self, uint8_t *a0, uint32_t a1, uint8_t *a2, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t A1 = (uintptr_t)a1;
    uintptr_t A2 = (uintptr_t)a2;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uintptr_t L24 = 0;
    uintptr_t L28 = 0;
    uintptr_t L32 = 0;
    uintptr_t L36 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)A1;
    (void)A2;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L24;
    (void)L28;
    (void)L32;
    (void)L36;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4c4b15 */
    /* 0x4c4b18 */
    L24 = ecx;
    /* 0x4c4b1b */
    eax = (uint32_t)((uint32_t)A1);
    /* 0x4c4b1e */
    fa = ((uint32_t)((((uint32_t)eax) & (0xffffu)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4c4b23 */
    fa = ((uint32_t)((((uint32_t)eax) << 16u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4c4b26 */
    ecx = (uint32_t)((uint32_t)A1);
    /* 0x4c4b29 */
    fa = ((uint32_t)((((uint32_t)ecx) & (0xffffu)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4c4b2f */
    fa = ((uint32_t)((((uint32_t)eax) | ((uint32_t)ecx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4c4b31 */
    L20 = (uint32_t)((uint32_t)eax);
    /* 0x4c4b34 */
    edx = A0;
    /* 0x4c4b37 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(a0, 47)));
    /* 0x4c4b3b */
    ecx = A2;
    /* 0x4c4b3e */
    edx = (uint32_t)(rd32(a2, 4));
    /* 0x4c4b41 */
    edx = (uint32_t)((uint32_t)((uint32_t)((uint32_t)eax) * (uint32_t)((uint32_t)edx)));
    /* 0x4c4b44 */
    eax = A0;
    /* 0x4c4b47 */
    ecx = (uint32_t)(rd32(a0, 0));
    /* 0x4c4b49 */
    fa = ((uint32_t)((((uint32_t)ecx) + ((uint32_t)edx)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4c4b4b */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_639895));
    /* 0x4c4b52 */
    eax = A2;
    /* 0x4c4b55 */
    eax = (uint32_t)(rd32(a2, 0));
    /* 0x4c4b57 */
    eax = (uint32_t)((uint32_t)((uint32_t)((uint32_t)edx) * (uint32_t)((uint32_t)eax)));
    /* 0x4c4b5a */
    fa = ((uint32_t)((((uint32_t)ecx) + ((uint32_t)eax)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4c4b5c */
    L4 = (uint32_t)((uint32_t)ecx);
    /* 0x4c4b5f */
    ecx = A2;
    /* 0x4c4b62 */
    edx = A2;
    /* 0x4c4b65 */
    eax = (uint32_t)(rd32(a2, 12));
    /* 0x4c4b68 */
    fa = ((uint32_t)((((uint32_t)eax) - (rd32(a2, 4))))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4c4b6b */
    fa = ((uint32_t)((((uint32_t)eax) + (0x1u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4c4b6e */
    L12 = (uint32_t)((uint32_t)eax);
    /* 0x4c4b71 */
    ecx = A2;
    /* 0x4c4b74 */
    edx = A2;
    /* 0x4c4b77 */
    eax = (uint32_t)(rd32(a2, 8));
    /* 0x4c4b7a */
    fa = ((uint32_t)((((uint32_t)eax) - (rd32(a2, 0))))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4c4b7c */
    fa = ((uint32_t)((((uint32_t)eax) + (0x1u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4c4b7f */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_639895));
    /* 0x4c4b86 */
    eax = (uint32_t)((uint32_t)((uint32_t)((uint32_t)ecx) * (uint32_t)((uint32_t)eax)));
    /* 0x4c4b89 */
    L8 = (uint32_t)((uint32_t)eax);
    /* 0x4c4b8c */
    L16 = (uint32_t)(0x0u);
    /* 0x4c4b93 */
    goto L4c4b9e;
L4c4b95:;
    /* 0x4c4b95 */
    edx = (uint32_t)((uint32_t)L16);
    /* 0x4c4b98 */
    fa = ((uint32_t)((((uint32_t)edx) + (0x1u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4c4b9b */
    L16 = (uint32_t)((uint32_t)edx);
L4c4b9e:;
    /* 0x4c4b9e */
    eax = (uint32_t)((uint32_t)L16);
    /* 0x4c4ba1 */
    fa = (uint32_t)eax;
    fb = (uint32_t)L12;
    /* 0x4c4ba4 */
    if ((int32_t)fa >= (int32_t)fb) goto L4c4c25;
    /* 0x4c4ba6 */
    ecx = (uint32_t)((uint32_t)L8);
    /* 0x4c4ba9 */
    fa = ((uint32_t)((((uint32_t)ecx) & (0x3u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4c4bac */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4c4bae */
    if (fa != 0) goto L4c4bcf;
    /* 0x4c4bb0 */
    edx = (uint32_t)((uint32_t)L8);
    /* 0x4c4bb3 */
    fa = ((uint32_t)(((uint32_t)((int32_t)((uint32_t)edx) >> 2u)) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4c4bb6 */
    L28 = (uint32_t)((uint32_t)edx);
    /* 0x4c4bb7 */
    eax = (uint32_t)((uint32_t)L20);
    /* 0x4c4bba */
    L32 = (uint32_t)((uint32_t)eax);
    /* 0x4c4bbb */
    ecx = (uint32_t)((uint32_t)L4);
    /* 0x4c4bbe */
    L36 = (uint32_t)((uint32_t)ecx);
    /* 0x4c4bbf */
    ecx = L24;
    /* 0x4c4bc2 */
    ecx = (uintptr_t)(self + (14540));
    /* 0x4c4bc8 */
    eax = (uintptr_t)call3(host, 0x43efb6, ecx, (uintptr_t)(uint32_t)L36, (uintptr_t)(uint32_t)L32, (uintptr_t)(uint32_t)L28);
    /* 0x4c4bcd */
    goto L4c4c11;
L4c4bcf:;
    /* 0x4c4bcf */
    edx = (uint32_t)((uint32_t)L8);
    /* 0x4c4bd2 */
    fa = ((uint32_t)((((uint32_t)edx) & (0x1u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4c4bd5 */
    fa = ((uint32_t)edx) & ((uint32_t)edx);
    /* 0x4c4bd7 */
    if (fa != 0) goto L4c4bf8;
    /* 0x4c4bd9 */
    eax = (uint32_t)((uint32_t)L8);
    /* 0x4c4bdc */
    fa = ((uint32_t)(((uint32_t)((int32_t)((uint32_t)eax) >> 1u)) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4c4bde */
    L28 = (uint32_t)((uint32_t)eax);
    /* 0x4c4bdf */
    ecx = (uint32_t)(((uint32_t)ecx & 0xffff0000u) | (((((uint32_t)A1 & 0xffffu)) & 0xffffu) << 0));
    /* 0x4c4be3 */
    L32 = (uint32_t)((uint32_t)ecx);
    /* 0x4c4be4 */
    edx = (uint32_t)((uint32_t)L4);
    /* 0x4c4be7 */
    L36 = (uint32_t)((uint32_t)edx);
    /* 0x4c4be8 */
    ecx = L24;
    /* 0x4c4beb */
    ecx = (uintptr_t)(self + (14540));
    /* 0x4c4bf1 */
    eax = (uintptr_t)call3(host, 0x43ef77, ecx, (uintptr_t)(uint32_t)L36, (uintptr_t)(uint32_t)L32, (uintptr_t)(uint32_t)L28);
    /* 0x4c4bf6 */
    goto L4c4c11;
L4c4bf8:;
    /* 0x4c4bf8 */
    L28 = (uint32_t)(0x55462cu);
    /* 0x4c4bfd */
    ecx = (uint32_t)(0x583979u);
    /* 0x4c4c02 */
    eax = (uintptr_t)call1(host, 0x4264e8, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L28);
    /* 0x4c4c07 */
    ecx = L24;
    /* 0x4c4c0a */
    eax = (uintptr_t)call0(host, 0x4c97b4, ecx);
    /* 0x4c4c0f */
    goto L4c4c25;
L4c4c11:;
    /* 0x4c4c11 */
    eax = A0;
    /* 0x4c4c14 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(a0, 47)));
    /* 0x4c4c18 */
    edx = (uint32_t)((uint32_t)L4);
    /* 0x4c4c1b */
    fa = ((uint32_t)((((uint32_t)edx) + ((uint32_t)ecx)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4c4c1d */
    L4 = (uint32_t)((uint32_t)edx);
    /* 0x4c4c20 */
    goto L4c4b95;
L4c4c25:;
    /* 0x4c4c25 */
    /* 0x4c4c27 */
    /* 0x4c4c28 */
    return (uint32_t)eax;
}

/* ---- 0x4c4c2b lifted ---- */
/* 0x4c4c2b, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0xe88]/2, [self+0x8]/4, [self+0xc]/4, [self+0xe86]/2. Stores to [self+0xe86]/2. Globals: 0x63a8dc/4 (written), 0x63a8d8/2 (written). Calls (in code order): 0x4c500c(this, 6 args), 0x4c94ec(this, 0 args), 0x4c9805(this, 0 args). Returns eax. */
uint32_t m4c4c2b_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L14 = 0;
    uintptr_t L20 = 0;
    uintptr_t L24 = 0;
    uintptr_t L28 = 0;
    uintptr_t L32 = 0;
    uintptr_t L36 = 0;
    uintptr_t L40 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L14;
    (void)L20;
    (void)L24;
    (void)L28;
    (void)L32;
    (void)L36;
    (void)L4;
    (void)L40;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4c4c2e */
    /* 0x4c4c31 */
    L12 = ecx;
    /* 0x4c4c34 */
    L4 = (uint32_t)((0x0u) & 0xffffu);
    /* 0x4c4c3a */
    eax = (uint32_t)(world->value_63a8dc);
    /* 0x4c4c3f */
    fa = ((uint32_t)((((uint32_t)eax) + (0x1u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4c4c42 */
    world->value_63a8dc = (uint32_t)((uint32_t)eax);
    /* 0x4c4c47 */
    ecx = L12;
    /* 0x4c4c4a */
    eax = (uintptr_t)call0(host, 0x4c9805, ecx);
    /* 0x4c4c4f */
    L8 = (uint32_t)((0x0u) & 0xffffu);
    /* 0x4c4c55 */
    goto L4c4c63;
L4c4c57:;
    /* 0x4c4c57 */
    ecx = (uint32_t)((((uint32_t)L8 & 0xffffu)) & 0xffffu);
    /* 0x4c4c5b */
    fa = ((uint32_t)(((((uint32_t)ecx & 0xffffu)) + (0x1u)) & 0xffffu)) & 0xffffu;
    ecx = (uint32_t)((fa) & 0xffffu);
    /* 0x4c4c5f */
    L8 = (uint32_t)((((uint32_t)ecx & 0xffffu)) & 0xffffu);
L4c4c63:;
    /* 0x4c4c63 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L8 & 0xffffu)));
    /* 0x4c4c67 */
    eax = L12;
    /* 0x4c4c6a */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 3720)));
    /* 0x4c4c71 */
    fa = (uint32_t)edx;
    fb = (uint32_t)ecx;
    /* 0x4c4c73 */
    if ((int32_t)fa >= (int32_t)fb) goto L4c4cec;
    /* 0x4c4c75 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L8 & 0xffffu)));
    /* 0x4c4c79 */
    eax = L12;
    /* 0x4c4c7c */
    ecx = (uint32_t)(0u);
    fa = 0u;
    /* 0x4c4c7e */
    ecx = (uint32_t)(((uint32_t)ecx & 0xffffff00u) | ((((uint32_t)(self)[3722 + (ptrdiff_t)(int32_t)((uint32_t)edx)]) & 0xffu) << 0));
    /* 0x4c4c85 */
    fa = (uint32_t)ecx;
    fb = 0x1u;
    /* 0x4c4c88 */
    if (fa != fb) goto L4c4ce7;
    /* 0x4c4c8a */
    L20 = (uint32_t)(0x554670u);
    /* 0x4c4c8f */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L8 & 0xffffu)));
    /* 0x4c4c93 */
    fa = ((uint32_t)((((uint32_t)edx) << 4u) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4c4c96 */
    eax = L12;
    /* 0x4c4c99 */
    ecx = (uintptr_t)((uint8_t *)eax + (ptrdiff_t)(int32_t)((uint32_t)edx * 1u) + (ptrdiff_t)(3972));
    /* 0x4c4ca0 */
    L24 = ecx;
    /* 0x4c4ca1 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L8 & 0xffffu)));
    /* 0x4c4ca5 */
    fa = ((uint32_t)((((uint32_t)edx) << 4u) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4c4ca8 */
    eax = L12;
    /* 0x4c4cab */
    ecx = (uint32_t)(rd32(self, 3976 + (ptrdiff_t)(int32_t)((uint32_t)edx)));
    /* 0x4c4cb2 */
    L28 = (uint32_t)((uint32_t)ecx);
    /* 0x4c4cb3 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L8 & 0xffffu)));
    /* 0x4c4cb7 */
    fa = ((uint32_t)((((uint32_t)edx) << 4u) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4c4cba */
    eax = L12;
    /* 0x4c4cbd */
    ecx = (uint32_t)(rd32(self, 3972 + (ptrdiff_t)(int32_t)((uint32_t)edx)));
    /* 0x4c4cc4 */
    L32 = (uint32_t)((uint32_t)ecx);
    /* 0x4c4cc5 */
    edx = L12;
    /* 0x4c4cc8 */
    eax = (uint32_t)(rd32(self, 8));
    /* 0x4c4ccb */
    L36 = (uint32_t)((uint32_t)eax);
    /* 0x4c4ccc */
    ecx = L12;
    /* 0x4c4ccf */
    edx = (uint32_t)(rd32(self, 12));
    /* 0x4c4cd2 */
    L40 = (uint32_t)((uint32_t)edx);
    /* 0x4c4cd3 */
    ecx = L12;
    /* 0x4c4cd6 */
    {
        const uintptr_t cargs[6] = {(uintptr_t)(uint32_t)L40, (uintptr_t)(uint32_t)L36, (uintptr_t)(uint32_t)L32, (uintptr_t)(uint32_t)L28, L24, (uintptr_t)(uint32_t)L20};
        eax = (uintptr_t)callv(host, 0x4c500c, ecx, cargs, 6);
    }
    /* 0x4c4cdb */
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | (((((uint32_t)L4 & 0xffffu)) & 0xffffu) << 0));
    /* 0x4c4cdf */
    fa = ((uint32_t)(((((uint32_t)eax & 0xffffu)) + (0x1u)) & 0xffffu)) & 0xffffu;
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | (((fa) & 0xffffu) << 0));
    /* 0x4c4ce3 */
    L4 = (uint32_t)((((uint32_t)eax & 0xffffu)) & 0xffffu);
L4c4ce7:;
    /* 0x4c4ce7 */
    goto L4c4c57;
L4c4cec:;
    /* 0x4c4cec */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4c4cf0 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_63a8d8));
    /* 0x4c4cf7 */
    fa = (uint32_t)ecx;
    fb = (uint32_t)edx;
    /* 0x4c4cf9 */
    if (fa == fb) goto L4c4d3e;
    /* 0x4c4cfb */
    eax = L12;
    /* 0x4c4cfe */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 3718)));
    /* 0x4c4d05 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4c4d09 */
    fa = (uint32_t)ecx;
    fb = (uint32_t)edx;
    /* 0x4c4d0b */
    if ((int32_t)fa <= (int32_t)fb) goto L4c4d1d;
    /* 0x4c4d0d */
    eax = L12;
    /* 0x4c4d10 */
    ecx = (uint32_t)(((uint32_t)ecx & 0xffff0000u) | ((((uint32_t)rd16(self, 3718)) & 0xffffu) << 0));
    /* 0x4c4d17 */
    L14 = (uint32_t)((((uint32_t)ecx & 0xffffu)) & 0xffffu);
    /* 0x4c4d1b */
    goto L4c4d25;
L4c4d1d:;
    /* 0x4c4d1d */
    edx = (uint32_t)(((uint32_t)edx & 0xffff0000u) | (((((uint32_t)L4 & 0xffffu)) & 0xffffu) << 0));
    /* 0x4c4d21 */
    L14 = (uint32_t)((((uint32_t)edx & 0xffffu)) & 0xffffu);
L4c4d25:;
    /* 0x4c4d25 */
    eax = L12;
    /* 0x4c4d28 */
    ecx = (uint32_t)(((uint32_t)ecx & 0xffff0000u) | (((((uint32_t)L14 & 0xffffu)) & 0xffffu) << 0));
    /* 0x4c4d2c */
    wr16(self, 3718, (uint16_t)(((uint32_t)ecx & 0xffffu)));
    /* 0x4c4d33 */
    edx = (uint32_t)(((uint32_t)edx & 0xffff0000u) | (((((uint32_t)L4 & 0xffffu)) & 0xffffu) << 0));
    /* 0x4c4d37 */
    world->word_63a8d8 = (uint16_t)(((uint32_t)edx & 0xffffu));
L4c4d3e:;
    /* 0x4c4d3e */
    ecx = L12;
    /* 0x4c4d41 */
    eax = (uintptr_t)call0(host, 0x4c94ec, ecx);
    /* 0x4c4d46 */
    /* 0x4c4d48 */
    /* 0x4c4d49 */
    return (uint32_t)eax;
}

/* ---- 0x4c9428 lifted ---- */
/* 0x4c9428, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x4c2dfb(this, 1 arg). eax is left-over and not meaningful. */
uint32_t m4c9428_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4c942b */
    /* 0x4c942e */
    L8 = ecx;
    /* 0x4c9431 */
    L4 = (uint32_t)((0x0u) & 0xffffu);
    /* 0x4c9437 */
    goto L4c9445;
L4c9439:;
    /* 0x4c9439 */
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | (((((uint32_t)L4 & 0xffffu)) & 0xffffu) << 0));
    /* 0x4c943d */
    fa = ((uint32_t)(((((uint32_t)eax & 0xffffu)) + (0x1u)) & 0xffffu)) & 0xffffu;
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | (((fa) & 0xffffu) << 0));
    /* 0x4c9441 */
    L4 = (uint32_t)((((uint32_t)eax & 0xffffu)) & 0xffffu);
L4c9445:;
    /* 0x4c9445 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4c9449 */
    fa = (uint32_t)ecx;
    fb = 0x18u;
    /* 0x4c944c */
    if ((int32_t)fa >= (int32_t)fb) goto L4c9467;
    /* 0x4c944e */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4c9452 */
    eax = L8;
    /* 0x4c9455 */
    ecx = (uintptr_t)((uint8_t *)eax + (ptrdiff_t)(int32_t)((uint32_t)edx * 4u) + (ptrdiff_t)(3186));
    /* 0x4c945c */
    L12 = ecx;
    /* 0x4c945d */
    ecx = L8;
    /* 0x4c9460 */
    eax = (uintptr_t)call1(host, 0x4c2dfb, ecx, L12);
    /* 0x4c9465 */
    goto L4c9439;
L4c9467:;
    /* 0x4c9467 */
    /* 0x4c9469 */
    /* 0x4c946a */
    return 0;
}

/* ---- 0x4c9b66 lifted ---- */
/* 0x4c9b66, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1f28]/4. Stores to [self+0x1f34]/4. Calls (in code order): 0x50cd72(5 args), 0x50cee4(1 arg), 0x50cf61(4 args), 0x50d0a9(2 args). Returns eax. */
uint32_t m4c9b66_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uintptr_t L24 = 0;
    uintptr_t L28 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L24;
    (void)L28;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4c9b69 */
    /* 0x4c9b6c */
    L8 = ecx;
    /* 0x4c9b6f */
    eax = L8;
    /* 0x4c9b72 */
    wr32(self, 7988, (uint32_t)(0x0u));
    /* 0x4c9b7c */
    L12 = (uint32_t)(0x557c94u);
    /* 0x4c9b81 */
    L16 = (uint32_t)(0x557c9cu);
    /* 0x4c9b86 */
    L20 = (uint32_t)(0x639aa2u);
    /* 0x4c9b8b */
    L24 = (uint32_t)(0x639a9fu);
    /* 0x4c9b90 */
    L28 = (uint32_t)(0x63888bu);
    /* 0x4c9b95 */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L28, (uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12};
        eax = (uintptr_t)callv(host, 0x50cd72, 0, cargs, 5);
    }
    /* 0x4c9b9a */
    /* 0x4c9b9d */
    L12 = (uint32_t)(0x557ca4u);
    /* 0x4c9ba2 */
    L16 = (uint32_t)(0x63888bu);
    /* 0x4c9ba7 */
    eax = (uintptr_t)call2(host, 0x50d0a9, 0, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12);
    /* 0x4c9bac */
    /* 0x4c9baf */
    L4 = (uint32_t)((uint32_t)eax);
    /* 0x4c9bb2 */
    fa = (uint32_t)L4;
    fb = 0x0u;
    /* 0x4c9bb6 */
    if (fa != fb) goto L4c9bbc;
    /* 0x4c9bb8 */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4c9bba */
    goto L4c9c0c;
L4c9bbc:;
    /* 0x4c9bbc */
    ecx = (uint32_t)((uint32_t)L4);
    /* 0x4c9bbf */
    L12 = (uint32_t)((uint32_t)ecx);
    /* 0x4c9bc0 */
    L16 = (uint32_t)(0x1u);
    /* 0x4c9bc2 */
    L20 = (uint32_t)(0x1764u);
    /* 0x4c9bc7 */
    edx = L8;
    /* 0x4c9bca */
    eax = (uint32_t)(rd32(self, 7976));
    /* 0x4c9bd0 */
    L24 = (uint32_t)((uint32_t)eax);
    /* 0x4c9bd1 */
    eax = (uintptr_t)call4(host, 0x50cf61, 0, (uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12);
    /* 0x4c9bd6 */
    /* 0x4c9bd9 */
    fa = (uint32_t)eax;
    fb = 0x1u;
    /* 0x4c9bdc */
    if (fa == fb) goto L4c9bee;
    /* 0x4c9bde */
    ecx = (uint32_t)((uint32_t)L4);
    /* 0x4c9be1 */
    L12 = (uint32_t)((uint32_t)ecx);
    /* 0x4c9be2 */
    eax = (uintptr_t)call1(host, 0x50cee4, 0, (uintptr_t)(uint32_t)L12);
    /* 0x4c9be7 */
    /* 0x4c9bea */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4c9bec */
    goto L4c9c0c;
L4c9bee:;
    /* 0x4c9bee */
    edx = (uint32_t)((uint32_t)L4);
    /* 0x4c9bf1 */
    L12 = (uint32_t)((uint32_t)edx);
    /* 0x4c9bf2 */
    eax = (uintptr_t)call1(host, 0x50cee4, 0, (uintptr_t)(uint32_t)L12);
    /* 0x4c9bf7 */
    /* 0x4c9bfa */
    eax = L8;
    /* 0x4c9bfd */
    wr32(self, 7988, (uint32_t)(0x1u));
    /* 0x4c9c07 */
    eax = (uint32_t)(0x1u);
L4c9c0c:;
    /* 0x4c9c0c */
    /* 0x4c9c0e */
    /* 0x4c9c0f */
    return (uint32_t)eax;
}

/* ---- 0x4c9c10 lifted ---- */
/* 0x4c9c10, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1f24]/4. Calls (in code order): 0x50cd72(5 args), 0x50cee4(1 arg), 0x50d0a9(2 args), 0x50e493(4 args). Returns eax. */
uint32_t m4c9c10_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uintptr_t L24 = 0;
    uintptr_t L28 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L24;
    (void)L28;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4c9c13 */
    /* 0x4c9c16 */
    L8 = ecx;
    /* 0x4c9c19 */
    L12 = (uint32_t)(0x557ca8u);
    /* 0x4c9c1e */
    L16 = (uint32_t)(0x557cb0u);
    /* 0x4c9c23 */
    L20 = (uint32_t)(0x639aa2u);
    /* 0x4c9c28 */
    L24 = (uint32_t)(0x639a9fu);
    /* 0x4c9c2d */
    L28 = (uint32_t)(0x63888bu);
    /* 0x4c9c32 */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L28, (uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12};
        eax = (uintptr_t)callv(host, 0x50cd72, 0, cargs, 5);
    }
    /* 0x4c9c37 */
    /* 0x4c9c3a */
    L12 = (uint32_t)(0x557cb8u);
    /* 0x4c9c3f */
    L16 = (uint32_t)(0x63888bu);
    /* 0x4c9c44 */
    eax = (uintptr_t)call2(host, 0x50d0a9, 0, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12);
    /* 0x4c9c49 */
    /* 0x4c9c4c */
    L4 = (uint32_t)((uint32_t)eax);
    /* 0x4c9c4f */
    fa = (uint32_t)L4;
    fb = 0x0u;
    /* 0x4c9c53 */
    if (fa != fb) goto L4c9c59;
    /* 0x4c9c55 */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4c9c57 */
    goto L4c9c9c;
L4c9c59:;
    /* 0x4c9c59 */
    eax = (uint32_t)((uint32_t)L4);
    /* 0x4c9c5c */
    L12 = (uint32_t)((uint32_t)eax);
    /* 0x4c9c5d */
    L16 = (uint32_t)(0x1u);
    /* 0x4c9c5f */
    L20 = (uint32_t)(0x1764u);
    /* 0x4c9c64 */
    ecx = L8;
    /* 0x4c9c67 */
    edx = (uint32_t)(rd32(self, 7972));
    /* 0x4c9c6d */
    L24 = (uint32_t)((uint32_t)edx);
    /* 0x4c9c6e */
    eax = (uintptr_t)call4(host, 0x50e493, 0, (uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12);
    /* 0x4c9c73 */
    /* 0x4c9c76 */
    fa = (uint32_t)eax;
    fb = 0x1u;
    /* 0x4c9c79 */
    if (fa == fb) goto L4c9c8b;
    /* 0x4c9c7b */
    eax = (uint32_t)((uint32_t)L4);
    /* 0x4c9c7e */
    L12 = (uint32_t)((uint32_t)eax);
    /* 0x4c9c7f */
    eax = (uintptr_t)call1(host, 0x50cee4, 0, (uintptr_t)(uint32_t)L12);
    /* 0x4c9c84 */
    /* 0x4c9c87 */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4c9c89 */
    goto L4c9c9c;
L4c9c8b:;
    /* 0x4c9c8b */
    ecx = (uint32_t)((uint32_t)L4);
    /* 0x4c9c8e */
    L12 = (uint32_t)((uint32_t)ecx);
    /* 0x4c9c8f */
    eax = (uintptr_t)call1(host, 0x50cee4, 0, (uintptr_t)(uint32_t)L12);
    /* 0x4c9c94 */
    /* 0x4c9c97 */
    eax = (uint32_t)(0x1u);
L4c9c9c:;
    /* 0x4c9c9c */
    /* 0x4c9c9e */
    /* 0x4c9c9f */
    return (uint32_t)eax;
}

/* ---- 0x4ca92e lifted ---- */
/* 0x4ca92e, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through). Reads [a0+0x4]/4, [a0+0x8]/4, [a0+0xc]/4, [a0+0x10]/4, [a0+0x14]/4, [a0+0x16c]/4, [a0+0x3c]/4, [a0+0x40]/4. ... Calls (in code order): 0x44a2b7(1 arg), 0x50ca3e(3 args). Returns eax. */
uint32_t m4ca92e_lifted(uint8_t *self, uint8_t *a0, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)L12;
    (void)L16;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4ca931 */
    L4 = ecx;
    /* 0x4ca932 */
    L4 = ecx;
    /* 0x4ca935 */
    eax = A0;
    /* 0x4ca938 */
    ecx = (uint32_t)(rd32(a0, 4));
    /* 0x4ca93b */
    fa = ((uint32_t)((((uint32_t)ecx) & (0x1u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4ca93e */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4ca940 */
    if (fa == 0) goto L4ca94f;
    /* 0x4ca942 */
    L8 = (uint32_t)(0x5582dcu);
    /* 0x4ca947 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4ca94c */
L4ca94f:;
    /* 0x4ca94f */
    edx = A0;
    /* 0x4ca952 */
    eax = (uint32_t)(rd32(a0, 4));
    /* 0x4ca955 */
    fa = ((uint32_t)((((uint32_t)eax) & (0x2u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4ca958 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4ca95a */
    if (fa == 0) goto L4ca969;
    /* 0x4ca95c */
    L8 = (uint32_t)(0x558314u);
    /* 0x4ca961 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4ca966 */
L4ca969:;
    /* 0x4ca969 */
    ecx = A0;
    /* 0x4ca96c */
    edx = (uint32_t)(rd32(a0, 4));
    /* 0x4ca96f */
    fa = ((uint32_t)((((uint32_t)edx) & (0x4u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4ca972 */
    fa = ((uint32_t)edx) & ((uint32_t)edx);
    /* 0x4ca974 */
    if (fa == 0) goto L4ca983;
    /* 0x4ca976 */
    L8 = (uint32_t)(0x558330u);
    /* 0x4ca97b */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4ca980 */
L4ca983:;
    /* 0x4ca983 */
    eax = A0;
    /* 0x4ca986 */
    ecx = (uint32_t)(rd32(a0, 4));
    /* 0x4ca989 */
    fa = ((uint32_t)((((uint32_t)ecx) & (0x8u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4ca98c */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4ca98e */
    if (fa == 0) goto L4ca99d;
    /* 0x4ca990 */
    L8 = (uint32_t)(0x558348u);
    /* 0x4ca995 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4ca99a */
L4ca99d:;
    /* 0x4ca99d */
    edx = A0;
    /* 0x4ca9a0 */
    eax = (uint32_t)(rd32(a0, 4));
    /* 0x4ca9a3 */
    fa = ((uint32_t)((((uint32_t)eax) & (0x10u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4ca9a6 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4ca9a8 */
    if (fa == 0) goto L4ca9b7;
    /* 0x4ca9aa */
    L8 = (uint32_t)(0x558364u);
    /* 0x4ca9af */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4ca9b4 */
L4ca9b7:;
    /* 0x4ca9b7 */
    ecx = A0;
    /* 0x4ca9ba */
    edx = (uint32_t)(rd32(a0, 4));
    /* 0x4ca9bd */
    fa = ((uint32_t)((((uint32_t)edx) & (0x8000000u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4ca9c3 */
    fa = ((uint32_t)edx) & ((uint32_t)edx);
    /* 0x4ca9c5 */
    if (fa == 0) goto L4ca9d4;
    /* 0x4ca9c7 */
    L8 = (uint32_t)(0x55837cu);
    /* 0x4ca9cc */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4ca9d1 */
L4ca9d4:;
    /* 0x4ca9d4 */
    eax = A0;
    /* 0x4ca9d7 */
    ecx = (uint32_t)(rd32(a0, 4));
    /* 0x4ca9da */
    fa = ((uint32_t)((((uint32_t)ecx) & (0x40u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4ca9dd */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4ca9df */
    if (fa == 0) goto L4ca9ee;
    /* 0x4ca9e1 */
    L8 = (uint32_t)(0x558394u);
    /* 0x4ca9e6 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4ca9eb */
L4ca9ee:;
    /* 0x4ca9ee */
    edx = A0;
    /* 0x4ca9f1 */
    eax = (uint32_t)(rd32(a0, 4));
    /* 0x4ca9f4 */
    fa = ((uint32_t)((((uint32_t)eax) & (0x10000000u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4ca9f9 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4ca9fb */
    if (fa == 0) goto L4caa0a;
    /* 0x4ca9fd */
    L8 = (uint32_t)(0x5583a4u);
    /* 0x4caa02 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4caa07 */
L4caa0a:;
    /* 0x4caa0a */
    ecx = A0;
    /* 0x4caa0d */
    edx = (uint32_t)(rd32(a0, 4));
    /* 0x4caa10 */
    fa = ((uint32_t)((((uint32_t)edx) & (0x80u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4caa16 */
    fa = ((uint32_t)edx) & ((uint32_t)edx);
    /* 0x4caa18 */
    if (fa == 0) goto L4caa27;
    /* 0x4caa1a */
    L8 = (uint32_t)(0x558404u);
    /* 0x4caa1f */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4caa24 */
L4caa27:;
    /* 0x4caa27 */
    eax = A0;
    /* 0x4caa2a */
    ecx = (uint32_t)(rd32(a0, 4));
    /* 0x4caa2d */
    fa = ((uint32_t)((((uint32_t)ecx) & (0x200u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4caa33 */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4caa35 */
    if (fa == 0) goto L4caa44;
    /* 0x4caa37 */
    L8 = (uint32_t)(0x558418u);
    /* 0x4caa3c */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4caa41 */
L4caa44:;
    /* 0x4caa44 */
    edx = A0;
    /* 0x4caa47 */
    eax = (uint32_t)(rd32(a0, 4));
    /* 0x4caa4a */
    fa = ((uint32_t)((((uint32_t)eax) & (0x80000000u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4caa4f */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4caa51 */
    if (fa == 0) goto L4caa60;
    /* 0x4caa53 */
    L8 = (uint32_t)(0x55842cu);
    /* 0x4caa58 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4caa5d */
L4caa60:;
    /* 0x4caa60 */
    ecx = A0;
    /* 0x4caa63 */
    edx = (uint32_t)(rd32(a0, 4));
    /* 0x4caa66 */
    fa = ((uint32_t)((((uint32_t)edx) & (0x400u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4caa6c */
    fa = ((uint32_t)edx) & ((uint32_t)edx);
    /* 0x4caa6e */
    if (fa == 0) goto L4caa7d;
    /* 0x4caa70 */
    L8 = (uint32_t)(0x558488u);
    /* 0x4caa75 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4caa7a */
L4caa7d:;
    /* 0x4caa7d */
    eax = A0;
    /* 0x4caa80 */
    ecx = (uint32_t)(rd32(a0, 4));
    /* 0x4caa83 */
    fa = ((uint32_t)((((uint32_t)ecx) & (0x2000000u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4caa89 */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4caa8b */
    if (fa == 0) goto L4caa9a;
    /* 0x4caa8d */
    L8 = (uint32_t)(0x5584bcu);
    /* 0x4caa92 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4caa97 */
L4caa9a:;
    /* 0x4caa9a */
    edx = A0;
    /* 0x4caa9d */
    eax = (uint32_t)(rd32(a0, 4));
    /* 0x4caaa0 */
    fa = ((uint32_t)((((uint32_t)eax) & (0x800u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4caaa5 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4caaa7 */
    if (fa == 0) goto L4caab6;
    /* 0x4caaa9 */
    L8 = (uint32_t)(0x5584f0u);
    /* 0x4caaae */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4caab3 */
L4caab6:;
    /* 0x4caab6 */
    ecx = A0;
    /* 0x4caab9 */
    edx = (uint32_t)(rd32(a0, 4));
    /* 0x4caabc */
    fa = ((uint32_t)((((uint32_t)edx) & (0x8000u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4caac2 */
    fa = ((uint32_t)edx) & ((uint32_t)edx);
    /* 0x4caac4 */
    if (fa == 0) goto L4caad3;
    /* 0x4caac6 */
    L8 = (uint32_t)(0x558528u);
    /* 0x4caacb */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4caad0 */
L4caad3:;
    /* 0x4caad3 */
    eax = A0;
    /* 0x4caad6 */
    ecx = (uint32_t)(rd32(a0, 4));
    /* 0x4caad9 */
    fa = ((uint32_t)((((uint32_t)ecx) & (0x20000u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4caadf */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4caae1 */
    if (fa == 0) goto L4caaf0;
    /* 0x4caae3 */
    L8 = (uint32_t)(0x55853cu);
    /* 0x4caae8 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4caaed */
L4caaf0:;
    /* 0x4caaf0 */
    edx = A0;
    /* 0x4caaf3 */
    eax = (uint32_t)(rd32(a0, 4));
    /* 0x4caaf6 */
    fa = ((uint32_t)((((uint32_t)eax) & (0x100000u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4caafb */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4caafd */
    if (fa == 0) goto L4cab0c;
    /* 0x4caaff */
    L8 = (uint32_t)(0x558554u);
    /* 0x4cab04 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cab09 */
L4cab0c:;
    /* 0x4cab0c */
    ecx = A0;
    /* 0x4cab0f */
    edx = (uint32_t)(rd32(a0, 4));
    /* 0x4cab12 */
    fa = ((uint32_t)((((uint32_t)edx) & (0x800000u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4cab18 */
    fa = ((uint32_t)edx) & ((uint32_t)edx);
    /* 0x4cab1a */
    if (fa == 0) goto L4cab29;
    /* 0x4cab1c */
    L8 = (uint32_t)(0x558598u);
    /* 0x4cab21 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cab26 */
L4cab29:;
    /* 0x4cab29 */
    eax = A0;
    /* 0x4cab2c */
    ecx = (uint32_t)(rd32(a0, 8));
    /* 0x4cab2f */
    fa = ((uint32_t)((((uint32_t)ecx) & (0x100000u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4cab35 */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4cab37 */
    if (fa == 0) goto L4cab46;
    /* 0x4cab39 */
    L8 = (uint32_t)(0x5585dcu);
    /* 0x4cab3e */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cab43 */
L4cab46:;
    /* 0x4cab46 */
    edx = A0;
    /* 0x4cab49 */
    eax = (uint32_t)(rd32(a0, 8));
    /* 0x4cab4c */
    fa = ((uint32_t)((((uint32_t)eax) & (0x800000u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4cab51 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4cab53 */
    if (fa == 0) goto L4cab62;
    /* 0x4cab55 */
    L8 = (uint32_t)(0x5585f8u);
    /* 0x4cab5a */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cab5f */
L4cab62:;
    /* 0x4cab62 */
    ecx = A0;
    /* 0x4cab65 */
    edx = (uint32_t)(rd32(a0, 8));
    /* 0x4cab68 */
    fa = ((uint32_t)((((uint32_t)edx) & (0x80000u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4cab6e */
    fa = ((uint32_t)edx) & ((uint32_t)edx);
    /* 0x4cab70 */
    if (fa == 0) goto L4cab7f;
    /* 0x4cab72 */
    L8 = (uint32_t)(0x558614u);
    /* 0x4cab77 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cab7c */
L4cab7f:;
    /* 0x4cab7f */
    eax = A0;
    /* 0x4cab82 */
    ecx = (uint32_t)(rd32(a0, 8));
    /* 0x4cab85 */
    fa = ((uint32_t)((((uint32_t)ecx) & (0x1u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4cab88 */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4cab8a */
    if (fa == 0) goto L4cab99;
    /* 0x4cab8c */
    L8 = (uint32_t)(0x558668u);
    /* 0x4cab91 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cab96 */
L4cab99:;
    /* 0x4cab99 */
    edx = A0;
    /* 0x4cab9c */
    eax = (uint32_t)(rd32(a0, 8));
    /* 0x4cab9f */
    fa = ((uint32_t)((((uint32_t)eax) & (0x80u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4caba4 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4caba6 */
    if (fa == 0) goto L4cabb5;
    /* 0x4caba8 */
    L8 = (uint32_t)(0x55869cu);
    /* 0x4cabad */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cabb2 */
L4cabb5:;
    /* 0x4cabb5 */
    ecx = A0;
    /* 0x4cabb8 */
    edx = (uint32_t)(rd32(a0, 8));
    /* 0x4cabbb */
    fa = ((uint32_t)((((uint32_t)edx) & (0x200u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4cabc1 */
    fa = ((uint32_t)edx) & ((uint32_t)edx);
    /* 0x4cabc3 */
    if (fa == 0) goto L4cabd2;
    /* 0x4cabc5 */
    L8 = (uint32_t)(0x5586bcu);
    /* 0x4cabca */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cabcf */
L4cabd2:;
    /* 0x4cabd2 */
    eax = A0;
    /* 0x4cabd5 */
    ecx = (uint32_t)(rd32(a0, 8));
    /* 0x4cabd8 */
    fa = ((uint32_t)((((uint32_t)ecx) & (0x20000u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4cabde */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4cabe0 */
    if (fa == 0) goto L4cabef;
    /* 0x4cabe2 */
    L8 = (uint32_t)(0x5586d8u);
    /* 0x4cabe7 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cabec */
L4cabef:;
    /* 0x4cabef */
    edx = A0;
    /* 0x4cabf2 */
    eax = (uint32_t)(rd32(a0, 8));
    /* 0x4cabf5 */
    fa = ((uint32_t)((((uint32_t)eax) & (0x1000u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4cabfa */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4cabfc */
    if (fa == 0) goto L4cac0b;
    /* 0x4cabfe */
    L8 = (uint32_t)(0x5586f0u);
    /* 0x4cac03 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cac08 */
L4cac0b:;
    /* 0x4cac0b */
    ecx = A0;
    /* 0x4cac0e */
    edx = (uint32_t)(rd32(a0, 12));
    /* 0x4cac11 */
    fa = ((uint32_t)((((uint32_t)edx) & (0x1u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4cac14 */
    fa = ((uint32_t)edx) & ((uint32_t)edx);
    /* 0x4cac16 */
    if (fa == 0) goto L4cac25;
    /* 0x4cac18 */
    L8 = (uint32_t)(0x558708u);
    /* 0x4cac1d */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cac22 */
L4cac25:;
    /* 0x4cac25 */
    eax = A0;
    /* 0x4cac28 */
    ecx = (uint32_t)(rd32(a0, 12));
    /* 0x4cac2b */
    fa = ((uint32_t)((((uint32_t)ecx) & (0x200u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4cac31 */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4cac33 */
    if (fa == 0) goto L4cac42;
    /* 0x4cac35 */
    L8 = (uint32_t)(0x558720u);
    /* 0x4cac3a */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cac3f */
L4cac42:;
    /* 0x4cac42 */
    edx = A0;
    /* 0x4cac45 */
    eax = (uint32_t)(rd32(a0, 16));
    /* 0x4cac48 */
    fa = ((uint32_t)((((uint32_t)eax) & (0x1u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4cac4b */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4cac4d */
    if (fa == 0) goto L4cac5c;
    /* 0x4cac4f */
    L8 = (uint32_t)(0x558734u);
    /* 0x4cac54 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cac59 */
L4cac5c:;
    /* 0x4cac5c */
    ecx = A0;
    /* 0x4cac5f */
    edx = (uint32_t)(rd32(a0, 16));
    /* 0x4cac62 */
    fa = ((uint32_t)((((uint32_t)edx) & (0x4u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4cac65 */
    fa = ((uint32_t)edx) & ((uint32_t)edx);
    /* 0x4cac67 */
    if (fa == 0) goto L4cac76;
    /* 0x4cac69 */
    L8 = (uint32_t)(0x558774u);
    /* 0x4cac6e */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cac73 */
L4cac76:;
    /* 0x4cac76 */
    eax = A0;
    /* 0x4cac79 */
    ecx = (uint32_t)(rd32(a0, 20));
    /* 0x4cac7c */
    fa = ((uint32_t)((((uint32_t)ecx) & (0x2u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4cac7f */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4cac81 */
    if (fa == 0) goto L4cac90;
    /* 0x4cac83 */
    L8 = (uint32_t)(0x5587bcu);
    /* 0x4cac88 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cac8d */
L4cac90:;
    /* 0x4cac90 */
    edx = A0;
    /* 0x4cac93 */
    eax = (uint32_t)(rd32(a0, 20));
    /* 0x4cac96 */
    fa = ((uint32_t)((((uint32_t)eax) & (0x8u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4cac99 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4cac9b */
    if (fa == 0) goto L4cacaa;
    /* 0x4cac9d */
    L8 = (uint32_t)(0x55880cu);
    /* 0x4caca2 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4caca7 */
L4cacaa:;
    /* 0x4cacaa */
    ecx = A0;
    /* 0x4cacad */
    edx = (uint32_t)(rd32(a0, 20));
    /* 0x4cacb0 */
    fa = ((uint32_t)((((uint32_t)edx) & (0x40u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4cacb3 */
    fa = ((uint32_t)edx) & ((uint32_t)edx);
    /* 0x4cacb5 */
    if (fa == 0) goto L4cacc4;
    /* 0x4cacb7 */
    L8 = (uint32_t)(0x558850u);
    /* 0x4cacbc */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cacc1 */
L4cacc4:;
    /* 0x4cacc4 */
    eax = A0;
    /* 0x4cacc7 */
    ecx = (uint32_t)(rd32(a0, 20));
    /* 0x4cacca */
    fa = ((uint32_t)((((uint32_t)ecx) & (0x100u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4cacd0 */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4cacd2 */
    if (fa == 0) goto L4cace1;
    /* 0x4cacd4 */
    L8 = (uint32_t)(0x5588a0u);
    /* 0x4cacd9 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cacde */
L4cace1:;
    /* 0x4cace1 */
    edx = A0;
    /* 0x4cace4 */
    eax = (uint32_t)(rd32(a0, 364));
    /* 0x4cacea */
    fa = ((uint32_t)((((uint32_t)eax) & (0x2000u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4cacef */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4cacf1 */
    if (fa == 0) goto L4cad00;
    /* 0x4cacf3 */
    L8 = (uint32_t)(0x5588e4u);
    /* 0x4cacf8 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cacfd */
L4cad00:;
    /* 0x4cad00 */
    ecx = A0;
    /* 0x4cad03 */
    edx = (uint32_t)(rd32(a0, 364));
    /* 0x4cad09 */
    fa = ((uint32_t)((((uint32_t)edx) & (0x40u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4cad0c */
    fa = ((uint32_t)edx) & ((uint32_t)edx);
    /* 0x4cad0e */
    if (fa == 0) goto L4cad1d;
    /* 0x4cad10 */
    L8 = (uint32_t)(0x558924u);
    /* 0x4cad15 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cad1a */
L4cad1d:;
    /* 0x4cad1d */
    eax = A0;
    /* 0x4cad20 */
    ecx = (uint32_t)(rd32(a0, 364));
    /* 0x4cad26 */
    fa = ((uint32_t)((((uint32_t)ecx) & (0x200u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4cad2c */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4cad2e */
    if (fa == 0) goto L4cad3d;
    /* 0x4cad30 */
    L8 = (uint32_t)(0x558968u);
    /* 0x4cad35 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cad3a */
L4cad3d:;
    /* 0x4cad3d */
    edx = A0;
    /* 0x4cad40 */
    eax = (uint32_t)(rd32(a0, 364));
    /* 0x4cad46 */
    fa = ((uint32_t)((((uint32_t)eax) & (0x800u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4cad4b */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4cad4d */
    if (fa == 0) goto L4cad5c;
    /* 0x4cad4f */
    L8 = (uint32_t)(0x5589a8u);
    /* 0x4cad54 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cad59 */
L4cad5c:;
    /* 0x4cad5c */
    ecx = A0;
    /* 0x4cad5f */
    edx = (uint32_t)(rd32(a0, 364));
    /* 0x4cad65 */
    fa = ((uint32_t)((((uint32_t)edx) & (0x4000u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4cad6b */
    fa = ((uint32_t)edx) & ((uint32_t)edx);
    /* 0x4cad6d */
    if (fa == 0) goto L4cad7c;
    /* 0x4cad6f */
    L8 = (uint32_t)(0x5589f4u);
    /* 0x4cad74 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cad79 */
L4cad7c:;
    /* 0x4cad7c */
    eax = A0;
    /* 0x4cad7f */
    ecx = (uint32_t)(rd32(a0, 364));
    /* 0x4cad85 */
    fa = ((uint32_t)((((uint32_t)ecx) & (0x20000u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4cad8b */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4cad8d */
    if (fa == 0) goto L4cad9c;
    /* 0x4cad8f */
    L8 = (uint32_t)(0x558a34u);
    /* 0x4cad94 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cad99 */
L4cad9c:;
    /* 0x4cad9c */
    edx = A0;
    /* 0x4cad9f */
    eax = (uint32_t)(rd32(a0, 60));
    /* 0x4cada2 */
    L8 = (uint32_t)((uint32_t)eax);
    /* 0x4cada3 */
    L12 = (uint32_t)(0x558a68u);
    /* 0x4cada8 */
    L16 = (uint32_t)(0x63888bu);
    /* 0x4cadad */
    eax = (uintptr_t)call3(host, 0x50ca3e, 0, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4cadb2 */
    /* 0x4cadb5 */
    L8 = (uint32_t)(0x63888bu);
    /* 0x4cadba */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cadbf */
    /* 0x4cadc2 */
    ecx = A0;
    /* 0x4cadc5 */
    edx = (uint32_t)(rd32(a0, 64));
    /* 0x4cadc8 */
    L8 = (uint32_t)((uint32_t)edx);
    /* 0x4cadc9 */
    L12 = (uint32_t)(0x558a84u);
    /* 0x4cadce */
    L16 = (uint32_t)(0x63888bu);
    /* 0x4cadd3 */
    eax = (uintptr_t)call3(host, 0x50ca3e, 0, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4cadd8 */
    /* 0x4caddb */
    L8 = (uint32_t)(0x63888bu);
    /* 0x4cade0 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cade5 */
    /* 0x4cade8 */
    eax = A0;
    /* 0x4cadeb */
    ecx = (uint32_t)(rd32(a0, 80));
    /* 0x4cadee */
    L8 = (uint32_t)((uint32_t)ecx);
    /* 0x4cadef */
    L12 = (uint32_t)(0x558aa4u);
    /* 0x4cadf4 */
    L16 = (uint32_t)(0x63888bu);
    /* 0x4cadf9 */
    eax = (uintptr_t)call3(host, 0x50ca3e, 0, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4cadfe */
    /* 0x4cae01 */
    L8 = (uint32_t)(0x63888bu);
    /* 0x4cae06 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cae0b */
    /* 0x4cae0e */
    edx = A0;
    /* 0x4cae11 */
    eax = (uint32_t)(rd32(a0, 84));
    /* 0x4cae14 */
    L8 = (uint32_t)((uint32_t)eax);
    /* 0x4cae15 */
    L12 = (uint32_t)(0x558ac4u);
    /* 0x4cae1a */
    L16 = (uint32_t)(0x63888bu);
    /* 0x4cae1f */
    eax = (uintptr_t)call3(host, 0x50ca3e, 0, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4cae24 */
    /* 0x4cae27 */
    L8 = (uint32_t)(0x63888bu);
    /* 0x4cae2c */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cae31 */
    /* 0x4cae34 */
    ecx = A0;
    /* 0x4cae37 */
    edx = (uint32_t)(rd32(a0, 88));
    /* 0x4cae3a */
    L8 = (uint32_t)((uint32_t)edx);
    /* 0x4cae3b */
    L12 = (uint32_t)(0x558ae0u);
    /* 0x4cae40 */
    L16 = (uint32_t)(0x63888bu);
    /* 0x4cae45 */
    eax = (uintptr_t)call3(host, 0x50ca3e, 0, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4cae4a */
    /* 0x4cae4d */
    L8 = (uint32_t)(0x63888bu);
    /* 0x4cae52 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cae57 */
    /* 0x4cae5a */
    eax = A0;
    /* 0x4cae5d */
    ecx = (uint32_t)(rd32(a0, 92));
    /* 0x4cae60 */
    L8 = (uint32_t)((uint32_t)ecx);
    /* 0x4cae61 */
    L12 = (uint32_t)(0x558b00u);
    /* 0x4cae66 */
    L16 = (uint32_t)(0x63888bu);
    /* 0x4cae6b */
    eax = (uintptr_t)call3(host, 0x50ca3e, 0, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4cae70 */
    /* 0x4cae73 */
    L8 = (uint32_t)(0x63888bu);
    /* 0x4cae78 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cae7d */
    /* 0x4cae80 */
    /* 0x4cae82 */
    /* 0x4cae83 */
    return (uint32_t)eax;
}

/* ---- 0x4caec0 lifted ---- */
/* 0x4caec0, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. eax is left-over and not meaningful. */
uint32_t m4caec0_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)ecx;
    /* 0x4caec3 */
    L4 = ecx;
    /* 0x4caec4 */
    L4 = ecx;
    /* 0x4caec7 */
    /* 0x4caec9 */
    /* 0x4caeca */
    return 0;
}

/* ---- 0x4caff5 lifted ---- */
/* 0x4caff5, this = ecx (self), `ret 0xc`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through), a1 host pointer (read through), a2 host pointer (read through). Reads [a1+0x0]/4, [a0+0x0]/4, [a2+0x0]/4. Stores to [a1+0x0]/4, [a2+0x0]/4, [r2+0x0]/104, [r2+0x68]/1. Globals: 0x63a4cd/2. Calls (in code order): 0x44a2b7(1 arg), 0x4cc70f(this, 2 args). Returns eax. */
uint32_t m4caff5_lifted(uint8_t *self, uint8_t *a0, uint8_t *a1, uint8_t *a2, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edi = 0;
    uintptr_t edx = 0;
    uintptr_t esi = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t A1 = (uintptr_t)a1;
    uintptr_t A2 = (uintptr_t)a2;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)A1;
    (void)A2;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edi;
    (void)edx;
    (void)esi;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4caff8 */
    L4 = ecx;
    /* 0x4caff9 */
    /* 0x4caffa */
    /* 0x4caffb */
    L4 = ecx;
    /* 0x4caffe */
    L16 = (uint32_t)(0x69u);
    /* 0x4cb000 */
    eax = A0;
    /* 0x4cb003 */
    L20 = eax;
    /* 0x4cb004 */
    ecx = L4;
    /* 0x4cb007 */
    eax = (uintptr_t)call2(host, 0x4cc70f, ecx, L20, (uintptr_t)(uint32_t)L16);
    /* 0x4cb00c */
    ecx = A1;
    /* 0x4cb00f */
    esi = (uint32_t)(rd32(a1, 0));
    /* 0x4cb011 */
    edx = A0;
    /* 0x4cb014 */
    edi = (uint32_t)(rd32(a0, 0));
    /* 0x4cb016 */
    ecx = (uint32_t)(0x1au);
    /* 0x4cb01b */
    rep_movs(res(host, (uint32_t)edi), res(host, (uint32_t)esi), (uint32_t)ecx, 4);
    edi = (uint32_t)(edi + 104u);
    esi = (uint32_t)(esi + 104u);
    ecx = 0;
    /* 0x4cb01d */
    rep_movs(res(host, (uint32_t)edi), res(host, (uint32_t)esi), 1u, 1);
    edi = (uint32_t)(edi + 1u);
    esi = (uint32_t)(esi + 1u);
    /* 0x4cb01e */
    eax = A2;
    /* 0x4cb021 */
    ecx = (uint32_t)(rd32(a2, 0));
    /* 0x4cb023 */
    fa = ((uint32_t)((((uint32_t)ecx) + (0x69u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4cb026 */
    edx = A2;
    /* 0x4cb029 */
    wr32(a2, 0, (uint32_t)((uint32_t)ecx));
    /* 0x4cb02b */
    eax = A1;
    /* 0x4cb02e */
    ecx = (uint32_t)(rd32(a1, 0));
    /* 0x4cb030 */
    fa = ((uint32_t)((((uint32_t)ecx) + (0x69u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4cb033 */
    edx = A1;
    /* 0x4cb036 */
    wr32(a1, 0, (uint32_t)((uint32_t)ecx));
    /* 0x4cb038 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_63a4cd));
    /* 0x4cb03f */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4cb041 */
    if (fa == 0) goto L4cb050;
    /* 0x4cb043 */
    L16 = (uint32_t)(0x558b1cu);
    /* 0x4cb048 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L16);
    /* 0x4cb04d */
L4cb050:;
    /* 0x4cb050 */
    /* 0x4cb051 */
    /* 0x4cb052 */
    /* 0x4cb054 */
    /* 0x4cb055 */
    return (uint32_t)eax;
}

/* ---- 0x4cca0e lifted ---- */
/* 0x4cca0e, this = ecx (self), `ret 0x10`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through), a1 dword, a2 dword, a3 dword. Stores to [a0+0x30]/4, [a0+0x34]/4, [a0+0x38]/4. Calls (in code order): 0x4cc962(this, 1 arg). Returns eax. */
uint32_t m4cca0e_lifted(uint8_t *self, uint8_t *a0, uint32_t a1, uint32_t a2, uint32_t a3, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t A1 = (uintptr_t)a1;
    uintptr_t A2 = (uintptr_t)a2;
    uintptr_t A3 = (uintptr_t)a3;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    (void)host;
    (void)A0;
    (void)A1;
    (void)A2;
    (void)A3;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x4cca11 */
    L4 = ecx;
    /* 0x4cca12 */
    L4 = ecx;
    /* 0x4cca15 */
    eax = A0;
    /* 0x4cca18 */
    L8 = eax;
    /* 0x4cca19 */
    ecx = L4;
    /* 0x4cca1c */
    eax = (uintptr_t)call1(host, 0x4cc962, ecx, L8);
    /* 0x4cca21 */
    ecx = A0;
    /* 0x4cca24 */
    edx = (uint32_t)((uint32_t)A1);
    /* 0x4cca27 */
    wr32(a0, 48, (uint32_t)((uint32_t)edx));
    /* 0x4cca2a */
    eax = A0;
    /* 0x4cca2d */
    ecx = (uint32_t)((uint32_t)A2);
    /* 0x4cca30 */
    wr32(a0, 52, (uint32_t)((uint32_t)ecx));
    /* 0x4cca33 */
    edx = A0;
    /* 0x4cca36 */
    eax = (uint32_t)((uint32_t)A3);
    /* 0x4cca39 */
    wr32(a0, 56, (uint32_t)((uint32_t)eax));
    /* 0x4cca3c */
    /* 0x4cca3e */
    /* 0x4cca3f */
    return (uint32_t)eax;
}

/* ---- 0x4ccc50 lifted ---- */
/* 0x4ccc50, this = ecx (self), `ret 0xc`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword, a1 dword, a2 host pointer (read through). Reads [a2+0x8]/4, [a2+0x4]/4, [a2+0x0]/4. Calls (in code order): 0x4ccc81(this, 5 args). Returns eax. */
uint32_t m4ccc50_lifted(uint8_t *self, uint32_t a0, uint32_t a1, uint8_t *a2, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t A1 = (uintptr_t)a1;
    uintptr_t A2 = (uintptr_t)a2;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uintptr_t L24 = 0;
    (void)host;
    (void)A0;
    (void)A1;
    (void)A2;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L24;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x4ccc53 */
    L4 = ecx;
    /* 0x4ccc54 */
    L4 = ecx;
    /* 0x4ccc57 */
    eax = A2;
    /* 0x4ccc5a */
    ecx = (uint32_t)(rd32(a2, 8));
    /* 0x4ccc5d */
    L8 = (uint32_t)((uint32_t)ecx);
    /* 0x4ccc5e */
    edx = A2;
    /* 0x4ccc61 */
    eax = (uint32_t)(rd32(a2, 4));
    /* 0x4ccc64 */
    L12 = (uint32_t)((uint32_t)eax);
    /* 0x4ccc65 */
    ecx = A2;
    /* 0x4ccc68 */
    edx = (uint32_t)(rd32(a2, 0));
    /* 0x4ccc6a */
    L16 = (uint32_t)((uint32_t)edx);
    /* 0x4ccc6b */
    eax = (uint32_t)((uint32_t)A1);
    /* 0x4ccc6e */
    L20 = (uint32_t)((uint32_t)eax);
    /* 0x4ccc6f */
    ecx = (uint32_t)((uint32_t)A0);
    /* 0x4ccc72 */
    L24 = (uint32_t)((uint32_t)ecx);
    /* 0x4ccc73 */
    ecx = L4;
    /* 0x4ccc76 */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8};
        eax = (uintptr_t)callv(host, 0x4ccc81, ecx, cargs, 5);
    }
    /* 0x4ccc7b */
    /* 0x4ccc7d */
    /* 0x4ccc7e */
    return (uint32_t)eax;
}

/* ---- 0x4cd645 lifted ---- */
/* 0x4cd645, this = ecx (self), `ret 0xc`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through), a1 host pointer (read through), a2 host pointer (read through). Reads [a1+0x0]/4, [a0+0x0]/4, [r1+0x0]/4, [r1+0x4]/4, [r1+0x8]/4, [r1+0xc]/2, [r1+0xe]/1, [a2+0x0]/4. Stores to [a1+0x0]/4, [a2+0x0]/4, [r2+0x0]/4, [r2+0x4]/4, [r2+0x8]/4, [r2+0xc]/2, [r2+0xe]/1. Globals: 0x5bb57b/4, 0x5c39e3/2, 0x63a4cd/2. Calls (in code order): 0x42639d(this, 2 args), 0x44a2b7(1 arg), 0x4c97b4(this, 0 args), 0x4cf1e4(this, 2 args), 0x50ca3e(4 args). Returns eax. */
uint32_t m4cd645_lifted(uint8_t *self, uint8_t *a0, uint8_t *a1, uint8_t *a2, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t A1 = (uintptr_t)a1;
    uintptr_t A2 = (uintptr_t)a2;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)A1;
    (void)A2;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4cd648 */
    L4 = ecx;
    /* 0x4cd649 */
    L4 = ecx;
    /* 0x4cd64c */
    L8 = (uint32_t)(0xfu);
    /* 0x4cd64e */
    eax = A0;
    /* 0x4cd651 */
    L12 = eax;
    /* 0x4cd652 */
    ecx = L4;
    /* 0x4cd655 */
    eax = (uintptr_t)call2(host, 0x4cf1e4, ecx, L12, (uintptr_t)(uint32_t)L8);
    /* 0x4cd65a */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4cd65c */
    if (fa != 0) goto L4cd69f;
    /* 0x4cd65e */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_5c39e3));
    /* 0x4cd665 */
    L8 = (uint32_t)((uint32_t)ecx);
    /* 0x4cd666 */
    edx = (uint32_t)(world->value_5bb57b);
    /* 0x4cd66c */
    L12 = (uint32_t)((uint32_t)edx);
    /* 0x4cd66d */
    L16 = (uint32_t)(0x559290u);
    /* 0x4cd672 */
    L20 = (uint32_t)(0x63888bu);
    /* 0x4cd677 */
    eax = (uintptr_t)call4(host, 0x50ca3e, 0, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4cd67c */
    /* 0x4cd67f */
    L8 = (uint32_t)(0x63888bu);
    /* 0x4cd684 */
    L12 = (uint32_t)(0x5592bcu);
    /* 0x4cd689 */
    ecx = (uint32_t)(0x583979u);
    /* 0x4cd68e */
    eax = (uintptr_t)call2(host, 0x42639d, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4cd693 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4cd698 */
    eax = (uintptr_t)call0(host, 0x4c97b4, (uintptr_t)(uint32_t)ecx);
    /* 0x4cd69d */
    goto L4cd6f9;
L4cd69f:;
    /* 0x4cd69f */
    eax = A1;
    /* 0x4cd6a2 */
    ecx = (uint32_t)(rd32(a1, 0));
    /* 0x4cd6a4 */
    edx = A0;
    /* 0x4cd6a7 */
    eax = (uint32_t)(rd32(a0, 0));
    /* 0x4cd6a9 */
    edx = (uint32_t)(rd32(res(host, (uint32_t)ecx), 0));
    /* 0x4cd6ab */
    wr32(res(host, (uint32_t)eax), 0, (uint32_t)((uint32_t)edx));
    /* 0x4cd6ad */
    edx = (uint32_t)(rd32(res(host, (uint32_t)ecx), 4));
    /* 0x4cd6b0 */
    wr32(res(host, (uint32_t)eax), 4, (uint32_t)((uint32_t)edx));
    /* 0x4cd6b3 */
    edx = (uint32_t)(rd32(res(host, (uint32_t)ecx), 8));
    /* 0x4cd6b6 */
    wr32(res(host, (uint32_t)eax), 8, (uint32_t)((uint32_t)edx));
    /* 0x4cd6b9 */
    edx = (uint32_t)(((uint32_t)edx & 0xffff0000u) | ((((uint32_t)rd16(res(host, (uint32_t)ecx), 12)) & 0xffffu) << 0));
    /* 0x4cd6bd */
    wr16(res(host, (uint32_t)eax), 12, (uint16_t)(((uint32_t)edx & 0xffffu)));
    /* 0x4cd6c1 */
    ecx = (uint32_t)(((uint32_t)ecx & 0xffffff00u) | ((((uint32_t)res(host, (uint32_t)ecx)[14]) & 0xffu) << 0));
    /* 0x4cd6c4 */
    res(host, (uint32_t)eax)[14] = (uint8_t)(((uint32_t)ecx & 0xffu));
    /* 0x4cd6c7 */
    edx = A2;
    /* 0x4cd6ca */
    eax = (uint32_t)(rd32(a2, 0));
    /* 0x4cd6cc */
    fa = ((uint32_t)((((uint32_t)eax) + (0xfu)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4cd6cf */
    ecx = A2;
    /* 0x4cd6d2 */
    wr32(a2, 0, (uint32_t)((uint32_t)eax));
    /* 0x4cd6d4 */
    edx = A1;
    /* 0x4cd6d7 */
    eax = (uint32_t)(rd32(a1, 0));
    /* 0x4cd6d9 */
    fa = ((uint32_t)((((uint32_t)eax) + (0xfu)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4cd6dc */
    ecx = A1;
    /* 0x4cd6df */
    wr32(a1, 0, (uint32_t)((uint32_t)eax));
    /* 0x4cd6e1 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_63a4cd));
    /* 0x4cd6e8 */
    fa = ((uint32_t)edx) & ((uint32_t)edx);
    /* 0x4cd6ea */
    if (fa == 0) goto L4cd6f9;
    /* 0x4cd6ec */
    L8 = (uint32_t)(0x5592d8u);
    /* 0x4cd6f1 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4cd6f6 */
L4cd6f9:;
    /* 0x4cd6f9 */
    /* 0x4cd6fb */
    /* 0x4cd6fc */
    return (uint32_t)eax;
}

/* ---- 0x4d00d2 lifted ---- */
/* 0x4d00d2, ecx unused, plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5bb1c4/2 (written). Calls (in code order): 0x4e0742(this, 0 args), 0x4e119b(this, 0 args). Returns eax. */
uint32_t m4d00d2_lifted(const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = 0;
    uintptr_t edx = 0;
    (void)host;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)world;
    /* 0x4d00d5 */
    ecx = (uint32_t)(0x570508u);
    /* 0x4d00da */
    eax = (uintptr_t)call0(host, 0x4e0742, (uintptr_t)(uint32_t)ecx);
    /* 0x4d00df */
    ecx = (uint32_t)(0x570508u);
    /* 0x4d00e4 */
    eax = (uintptr_t)call0(host, 0x4e119b, (uintptr_t)(uint32_t)ecx);
    /* 0x4d00e9 */
    world->word_5bb1c4 = (uint16_t)(0x2u);
    /* 0x4d00f2 */
    /* 0x4d00f3 */
    return (uint32_t)eax;
}

/* ---- 0x4d3723 lifted ---- */
/* 0x4d3723, ecx unused, plain `ret`, lifted mechanically from the instruction stream; not original source structure. eax is left-over and not meaningful. */
uint32_t m4d3723_lifted(const Fl18Host *host)
{
    (void)host;
    /* 0x4d3726 */
    /* 0x4d3727 */
    return 0;
}

/* ---- 0x4d3b95 lifted ---- */
/* 0x4d3b95, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x1c]/4, [self+0x43e]/2, [self+0x440]/4, [self+0x444]/4, [self+0x45e]/4. Globals: 0x5d1c4b/4 (written). Calls (in code order): 0x4d3bef(this, 0 args). Returns eax. */
uint32_t m4d3b95_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)world;
    /* 0x4d3b98 */
    L4 = ecx;
    /* 0x4d3b99 */
    L4 = ecx;
    /* 0x4d3b9c */
    eax = L4;
    /* 0x4d3b9f */
    wr32(self, 1092, (uint32_t)(0x1u));
    /* 0x4d3ba9 */
    ecx = L4;
    /* 0x4d3bac */
    wr16(self, 1086, (uint16_t)(0x0u));
    /* 0x4d3bb5 */
    edx = L4;
    /* 0x4d3bb8 */
    wr32(self, 28, (uint32_t)(0x0u));
    /* 0x4d3bbf */
    eax = L4;
    /* 0x4d3bc2 */
    wr32(self, 1118, (uint32_t)(0x0u));
    /* 0x4d3bcc */
    world->value_5d1c4b = (uint32_t)(0x0u);
    /* 0x4d3bd6 */
    ecx = L4;
    /* 0x4d3bd9 */
    wr32(self, 1088, (uint32_t)(0x0u));
    /* 0x4d3be3 */
    ecx = L4;
    /* 0x4d3be6 */
    eax = (uintptr_t)call0(host, 0x4d3bef, ecx);
    /* 0x4d3beb */
    /* 0x4d3bed */
    /* 0x4d3bee */
    return (uint32_t)eax;
}

/* ---- 0x4d3c9a lifted ---- */
/* 0x4d3c9a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x61c6ae/1, 0x5d1c4b/4 (written). Returns eax. */
uint32_t m4d3c9a_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4d3c9d */
    L4 = ecx;
    /* 0x4d3c9e */
    L4 = ecx;
    /* 0x4d3ca1 */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4d3ca3 */
    eax = (uint32_t)(((uint32_t)eax & 0xffffff00u) | ((((uint32_t)world->byte_61c6ae) & 0xffu) << 0));
    /* 0x4d3ca8 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4d3caa */
    if (fa != 0) goto L4d3cb6;
    /* 0x4d3cac */
    world->value_5d1c4b = (uint32_t)(0x0u);
L4d3cb6:;
    /* 0x4d3cb6 */
    /* 0x4d3cb8 */
    /* 0x4d3cb9 */
    return (uint32_t)eax;
}

/* ---- 0x4d3cba lifted ---- */
/* 0x4d3cba, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x45e]/4. Stores to [self+0x45a]/4, [self+0x45e]/4. Globals: 0x5d1c4b/4. Returns this. */
uint8_t * m4d3cba_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4d3cbd */
    L4 = ecx;
    /* 0x4d3cbe */
    L4 = ecx;
    /* 0x4d3cc1 */
    eax = L4;
    /* 0x4d3cc4 */
    fa = rd32(self, 1118);
    fb = 0x0u;
    /* 0x4d3ccb */
    if (fa != fb) goto L4d3ce9;
    /* 0x4d3ccd */
    ecx = L4;
    /* 0x4d3cd0 */
    edx = (uint32_t)(world->value_5d1c4b);
    /* 0x4d3cd6 */
    wr32(self, 1114, (uint32_t)((uint32_t)edx));
    /* 0x4d3cdc */
    eax = L4;
    /* 0x4d3cdf */
    wr32(self, 1118, (uint32_t)(0x1u));
L4d3ce9:;
    /* 0x4d3ce9 */
    /* 0x4d3ceb */
    /* 0x4d3cec */
    return (uint8_t *)eax;
}

/* ---- 0x4d3ced lifted ---- */
/* 0x4d3ced, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x45e]/4, [self+0x45a]/4. Stores to [self+0x45e]/4. Globals: 0x5d1c4b/4 (written). Returns this. */
uint8_t * m4d3ced_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4d3cf0 */
    L4 = ecx;
    /* 0x4d3cf1 */
    L4 = ecx;
    /* 0x4d3cf4 */
    eax = L4;
    /* 0x4d3cf7 */
    fa = rd32(self, 1118);
    fb = 0x0u;
    /* 0x4d3cfe */
    if (fa == fb) goto L4d3d1c;
    /* 0x4d3d00 */
    ecx = L4;
    /* 0x4d3d03 */
    edx = (uint32_t)(rd32(self, 1114));
    /* 0x4d3d09 */
    world->value_5d1c4b = (uint32_t)((uint32_t)edx);
    /* 0x4d3d0f */
    eax = L4;
    /* 0x4d3d12 */
    wr32(self, 1118, (uint32_t)(0x0u));
L4d3d1c:;
    /* 0x4d3d1c */
    /* 0x4d3d1e */
    /* 0x4d3d1f */
    return (uint8_t *)eax;
}

/* ---- 0x4d4043 lifted ---- */
/* 0x4d4043, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5cf665/4, 0x5d0377/4. Calls (in code order): 0x4c5377(this, 5 args). Returns eax. */
uint32_t m4d4043_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uintptr_t L24 = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L24;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)world;
    /* 0x4d4046 */
    L4 = ecx;
    /* 0x4d4047 */
    L4 = ecx;
    /* 0x4d404a */
    L8 = (uint32_t)(0x55a4b4u);
    /* 0x4d404f */
    L12 = (uint32_t)(0x61c497u);
    /* 0x4d4054 */
    L16 = (uint32_t)(0x61c7b5u);
    /* 0x4d4059 */
    eax = (uint32_t)(world->value_5cf665);
    /* 0x4d405e */
    L20 = (uint32_t)((uint32_t)eax);
    /* 0x4d405f */
    ecx = (uint32_t)(world->value_5d0377);
    /* 0x4d4065 */
    L24 = (uint32_t)((uint32_t)ecx);
    /* 0x4d4066 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4d406b */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8};
        eax = (uintptr_t)callv(host, 0x4c5377, (uintptr_t)(uint32_t)ecx, cargs, 5);
    }
    /* 0x4d4070 */
    /* 0x4d4072 */
    /* 0x4d4073 */
    return (uint32_t)eax;
}

/* ---- 0x4d4645 lifted ---- */
/* 0x4d4645, ecx unused, plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x583981/4 (written), 0x583985/4 (written), 0x5839a1/4 (written). Calls (in code order): 0x43dbd5(0 args), 0x4c2dfb(this, 1 arg), 0x4dad60(this, 0 args), 0x4db870(this, 0 args). Returns eax. */
uint32_t m4d4645_lifted(const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = 0;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4d4648 */
    L4 = (uint32_t)(0x5d0387u);
    /* 0x4d464d */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4d4652 */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L4);
    /* 0x4d4657 */
    L4 = (uint32_t)(0x5d038bu);
    /* 0x4d465c */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4d4661 */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L4);
    /* 0x4d4666 */
    eax = (uintptr_t)call0(host, 0x43dbd5, 0);
    /* 0x4d466b */
    ecx = (uint32_t)(0x5830a6u);
    /* 0x4d4670 */
    eax = (uintptr_t)call0(host, 0x4dad60, (uintptr_t)(uint32_t)ecx);
    /* 0x4d4675 */
    eax = (uint32_t)(world->value_583985);
    /* 0x4d467a */
    world->value_583981 = (uint32_t)((uint32_t)eax);
    /* 0x4d467f */
    fa = world->value_583985;
    fb = 0x6u;
    /* 0x4d4686 */
    if (fa != fb) goto L4d4694;
    /* 0x4d4688 */
    world->value_5839a1 = (uint32_t)(0x0u);
    /* 0x4d4692 */
    goto L4d46a7;
L4d4694:;
    /* 0x4d4694 */
    fa = world->value_583985;
    fb = 0xeu;
    /* 0x4d469b */
    if (fa != fb) goto L4d46a7;
    /* 0x4d469d */
    ecx = (uint32_t)(0x5830ceu);
    /* 0x4d46a2 */
    eax = (uintptr_t)call0(host, 0x4db870, (uintptr_t)(uint32_t)ecx);
L4d46a7:;
    /* 0x4d46a7 */
    world->value_583985 = (uint32_t)(0x5u);
    /* 0x4d46b1 */
    /* 0x4d46b2 */
    return (uint32_t)eax;
}

/* ---- 0x4d47b0 lifted ---- */
/* 0x4d47b0, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5839a5/4 (written), 0x5b451f/2. Calls (in code order): 0x4d4803(0 args), 0x4d4c24(0 args), 0x4fb2a6(this, 2 args). Returns eax. */
uint32_t m4d47b0_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4d47b3 */
    L4 = ecx;
    /* 0x4d47b4 */
    eax = (uint32_t)(world->value_5839a5);
    /* 0x4d47b9 */
    L4 = (uint32_t)((uint32_t)eax);
    /* 0x4d47bc */
    fa = (uint32_t)L4;
    fb = 0x0u;
    /* 0x4d47c0 */
    if (fa == fb) goto L4d47d0;
    /* 0x4d47c2 */
    fa = (uint32_t)L4;
    fb = 0x1u;
    /* 0x4d47c6 */
    if (fa == fb) goto L4d47d7;
    /* 0x4d47c8 */
    fa = (uint32_t)L4;
    fb = 0x2u;
    /* 0x4d47cc */
    if (fa == fb) goto L4d47fa;
    /* 0x4d47ce */
    goto L4d47ff;
L4d47d0:;
    /* 0x4d47d0 */
    eax = (uintptr_t)call0(host, 0x4d4803, 0);
    /* 0x4d47d5 */
    goto L4d47ff;
L4d47d7:;
    /* 0x4d47d7 */
    ecx = (uint32_t)(((uint32_t)world->word_5b451f) & 0xffffu);
    /* 0x4d47de */
    L8 = (uint32_t)(uint32_t)ecx;
    /* 0x4d47df */
    L12 = (uint32_t)(0x5b452du);
    /* 0x4d47e4 */
    ecx = (uint32_t)(0x5c3a67u);
    /* 0x4d47e9 */
    eax = (uintptr_t)call2(host, 0x4fb2a6, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4d47ee */
    world->value_5839a5 = (uint32_t)(0x2u);
    /* 0x4d47f8 */
    goto L4d47ff;
L4d47fa:;
    /* 0x4d47fa */
    eax = (uintptr_t)call0(host, 0x4d4c24, 0);
L4d47ff:;
    /* 0x4d47ff */
    /* 0x4d4801 */
    /* 0x4d4802 */
    return (uint32_t)eax;
}

/* ---- 0x4d56e2 lifted ---- */
/* 0x4d56e2, this = ecx (self), `ret 0xc`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through), a1 host pointer (read through), a2 host pointer (read through). Reads [a2+0x0]/4, [a1+0x0]/4, [a2+0x8]/4, [a1+0x8]/4, [a2+0x4]/4, [a1+0x4]/4, [a2+0xc]/4, [a1+0xc]/4. ... Stores to [a0+0x0]/4, [a0+0x4]/4, [a0+0x8]/4, [a0+0xc]/4, [a1+0x0]/4, [a1+0x4]/4, [a1+0x8]/4, [a1+0xc]/4. Returns eax. */
uint32_t m4d56e2_lifted(uint8_t *self, uint8_t *a0, uint8_t *a1, uint8_t *a2, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t A1 = (uintptr_t)a1;
    uintptr_t A2 = (uintptr_t)a2;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)A1;
    (void)A2;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4d56e5 */
    /* 0x4d56e8 */
    L20 = ecx;
    /* 0x4d56eb */
    fa = (uint32_t)(A0 != 0);
    fb = 0u;
    /* 0x4d56ef */
    if (fa == fb) goto L4d56fd;
    /* 0x4d56f1 */
    fa = (uint32_t)(A1 != 0);
    fb = 0u;
    /* 0x4d56f5 */
    if (fa == fb) goto L4d56fd;
    /* 0x4d56f7 */
    fa = (uint32_t)(A2 != 0);
    fb = 0u;
    /* 0x4d56fb */
    if (fa != fb) goto L4d5704;
L4d56fd:;
    /* 0x4d56fd */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4d56ff */
    goto L4d57e2;
L4d5704:;
    /* 0x4d5704 */
    eax = A2;
    /* 0x4d5707 */
    ecx = A1;
    /* 0x4d570a */
    edx = (uint32_t)(rd32(a2, 0));
    /* 0x4d570c */
    fa = (uint32_t)edx;
    fb = rd32(a1, 0);
    /* 0x4d570e */
    if ((int32_t)fa < (int32_t)fb) goto L4d573a;
    /* 0x4d5710 */
    eax = A2;
    /* 0x4d5713 */
    ecx = A1;
    /* 0x4d5716 */
    edx = (uint32_t)(rd32(a2, 8));
    /* 0x4d5719 */
    fa = (uint32_t)edx;
    fb = rd32(a1, 8);
    /* 0x4d571c */
    if ((int32_t)fa > (int32_t)fb) goto L4d573a;
    /* 0x4d571e */
    eax = A2;
    /* 0x4d5721 */
    ecx = A1;
    /* 0x4d5724 */
    edx = (uint32_t)(rd32(a2, 4));
    /* 0x4d5727 */
    fa = (uint32_t)edx;
    fb = rd32(a1, 4);
    /* 0x4d572a */
    if ((int32_t)fa < (int32_t)fb) goto L4d573a;
    /* 0x4d572c */
    eax = A2;
    /* 0x4d572f */
    ecx = A1;
    /* 0x4d5732 */
    edx = (uint32_t)(rd32(a2, 12));
    /* 0x4d5735 */
    fa = (uint32_t)edx;
    fb = rd32(a1, 12);
    /* 0x4d5738 */
    if ((int32_t)fa <= (int32_t)fb) goto L4d5741;
L4d573a:;
    /* 0x4d573a */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4d573c */
    goto L4d57e2;
L4d5741:;
    /* 0x4d5741 */
    eax = A2;
    /* 0x4d5744 */
    ecx = A1;
    /* 0x4d5747 */
    edx = (uint32_t)(rd32(a2, 0));
    /* 0x4d5749 */
    fa = ((uint32_t)((((uint32_t)edx) - (rd32(a1, 0))))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4d574b */
    L12 = (uint32_t)((uint32_t)edx);
    /* 0x4d574e */
    eax = A2;
    /* 0x4d5751 */
    ecx = A1;
    /* 0x4d5754 */
    edx = (uint32_t)(rd32(a2, 4));
    /* 0x4d5757 */
    fa = ((uint32_t)((((uint32_t)edx) - (rd32(a1, 4))))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4d575a */
    L4 = (uint32_t)((uint32_t)edx);
    /* 0x4d575d */
    eax = A2;
    /* 0x4d5760 */
    ecx = A2;
    /* 0x4d5763 */
    edx = (uint32_t)(rd32(a2, 8));
    /* 0x4d5766 */
    fa = ((uint32_t)((((uint32_t)edx) - (rd32(a2, 0))))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4d5768 */
    fa = ((uint32_t)((((uint32_t)edx) + (0x1u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4d576b */
    L16 = (uint32_t)((uint32_t)edx);
    /* 0x4d576e */
    eax = A2;
    /* 0x4d5771 */
    ecx = A2;
    /* 0x4d5774 */
    edx = (uint32_t)(rd32(a2, 12));
    /* 0x4d5777 */
    fa = ((uint32_t)((((uint32_t)edx) - (rd32(a2, 4))))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4d577a */
    fa = ((uint32_t)((((uint32_t)edx) + (0x1u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4d577d */
    L8 = (uint32_t)((uint32_t)edx);
    /* 0x4d5780 */
    eax = A0;
    /* 0x4d5783 */
    ecx = (uint32_t)(rd32(a0, 0));
    /* 0x4d5785 */
    fa = ((uint32_t)((((uint32_t)ecx) + ((uint32_t)L12)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4d5788 */
    edx = A0;
    /* 0x4d578b */
    wr32(a0, 0, (uint32_t)((uint32_t)ecx));
    /* 0x4d578d */
    eax = A0;
    /* 0x4d5790 */
    ecx = (uint32_t)(rd32(a0, 4));
    /* 0x4d5793 */
    fa = ((uint32_t)((((uint32_t)ecx) + ((uint32_t)L4)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4d5796 */
    edx = A0;
    /* 0x4d5799 */
    wr32(a0, 4, (uint32_t)((uint32_t)ecx));
    /* 0x4d579c */
    eax = A0;
    /* 0x4d579f */
    ecx = (uint32_t)(rd32(a0, 0));
    /* 0x4d57a1 */
    edx = (uint32_t)((uint32_t)L16);
    /* 0x4d57a4 */
    eax = (uint32_t)((uint32_t)ecx + (uint32_t)edx + (uint32_t)4294967295);
    /* 0x4d57a8 */
    ecx = A0;
    /* 0x4d57ab */
    wr32(a0, 8, (uint32_t)((uint32_t)eax));
    /* 0x4d57ae */
    edx = A0;
    /* 0x4d57b1 */
    eax = (uint32_t)(rd32(a0, 4));
    /* 0x4d57b4 */
    ecx = (uint32_t)((uint32_t)L8);
    /* 0x4d57b7 */
    edx = (uint32_t)((uint32_t)eax + (uint32_t)ecx + (uint32_t)4294967295);
    /* 0x4d57bb */
    eax = A0;
    /* 0x4d57be */
    wr32(a0, 12, (uint32_t)((uint32_t)edx));
    /* 0x4d57c1 */
    ecx = A2;
    /* 0x4d57c4 */
    edx = A1;
    /* 0x4d57c7 */
    eax = (uint32_t)(rd32(a2, 0));
    /* 0x4d57c9 */
    wr32(a1, 0, (uint32_t)((uint32_t)eax));
    /* 0x4d57cb */
    eax = (uint32_t)(rd32(a2, 4));
    /* 0x4d57ce */
    wr32(a1, 4, (uint32_t)((uint32_t)eax));
    /* 0x4d57d1 */
    eax = (uint32_t)(rd32(a2, 8));
    /* 0x4d57d4 */
    wr32(a1, 8, (uint32_t)((uint32_t)eax));
    /* 0x4d57d7 */
    ecx = (uint32_t)(rd32(a2, 12));
    /* 0x4d57da */
    wr32(a1, 12, (uint32_t)((uint32_t)ecx));
    /* 0x4d57dd */
    eax = (uint32_t)(0x1u);
L4d57e2:;
    /* 0x4d57e2 */
    /* 0x4d57e4 */
    /* 0x4d57e5 */
    return (uint32_t)eax;
}

/* ---- 0x4d57e8 lifted ---- */
/* 0x4d57e8, this = ecx (self), `ret 0x8`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through), a1 host pointer (read through). Reads [a0+0x0]/4, [a1+0x0]/4, [a0+0x8]/4, [a1+0x8]/4, [a0+0x4]/4, [a1+0x4]/4, [a0+0xc]/4, [a1+0xc]/4. Returns eax. */
uint32_t m4d57e8_lifted(uint8_t *self, uint8_t *a0, uint8_t *a1, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t A1 = (uintptr_t)a1;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)A1;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4d57eb */
    L4 = ecx;
    /* 0x4d57ec */
    L4 = ecx;
    /* 0x4d57ef */
    eax = A0;
    /* 0x4d57f2 */
    ecx = A1;
    /* 0x4d57f5 */
    edx = (uint32_t)(rd32(a0, 0));
    /* 0x4d57f7 */
    fa = (uint32_t)edx;
    fb = rd32(a1, 0);
    /* 0x4d57f9 */
    if ((int32_t)fa < (int32_t)fb) goto L4d582c;
    /* 0x4d57fb */
    eax = A0;
    /* 0x4d57fe */
    ecx = A1;
    /* 0x4d5801 */
    edx = (uint32_t)(rd32(a0, 8));
    /* 0x4d5804 */
    fa = (uint32_t)edx;
    fb = rd32(a1, 8);
    /* 0x4d5807 */
    if ((int32_t)fa > (int32_t)fb) goto L4d582c;
    /* 0x4d5809 */
    eax = A0;
    /* 0x4d580c */
    ecx = A1;
    /* 0x4d580f */
    edx = (uint32_t)(rd32(a0, 4));
    /* 0x4d5812 */
    fa = (uint32_t)edx;
    fb = rd32(a1, 4);
    /* 0x4d5815 */
    if ((int32_t)fa < (int32_t)fb) goto L4d582c;
    /* 0x4d5817 */
    eax = A0;
    /* 0x4d581a */
    ecx = A1;
    /* 0x4d581d */
    edx = (uint32_t)(rd32(a0, 12));
    /* 0x4d5820 */
    fa = (uint32_t)edx;
    fb = rd32(a1, 12);
    /* 0x4d5823 */
    if ((int32_t)fa > (int32_t)fb) goto L4d582c;
    /* 0x4d5825 */
    eax = (uint32_t)(0x1u);
    /* 0x4d582a */
    goto L4d582e;
L4d582c:;
    /* 0x4d582c */
    eax = (uint32_t)(0u);
    fa = 0u;
L4d582e:;
    /* 0x4d582e */
    /* 0x4d5830 */
    /* 0x4d5831 */
    return (uint32_t)eax;
}

/* ---- 0x4d5834 lifted ---- */
/* 0x4d5834, this = ecx (self), `ret 0x8`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through), a1 host pointer (read through). Reads [a0+0x8]/4, [a1+0x0]/4, [a0+0x0]/4, [a1+0x8]/4, [a0+0xc]/4, [a1+0x4]/4, [a0+0x4]/4, [a1+0xc]/4. Returns eax. */
uint32_t m4d5834_lifted(uint8_t *self, uint8_t *a0, uint8_t *a1, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t A1 = (uintptr_t)a1;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)A1;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4d5837 */
    L4 = ecx;
    /* 0x4d5838 */
    L4 = ecx;
    /* 0x4d583b */
    eax = A0;
    /* 0x4d583e */
    ecx = A1;
    /* 0x4d5841 */
    edx = (uint32_t)(rd32(a0, 8));
    /* 0x4d5844 */
    fa = (uint32_t)edx;
    fb = rd32(a1, 0);
    /* 0x4d5846 */
    if ((int32_t)fa < (int32_t)fb) goto L4d5871;
    /* 0x4d5848 */
    eax = A0;
    /* 0x4d584b */
    ecx = A1;
    /* 0x4d584e */
    edx = (uint32_t)(rd32(a0, 0));
    /* 0x4d5850 */
    fa = (uint32_t)edx;
    fb = rd32(a1, 8);
    /* 0x4d5853 */
    if ((int32_t)fa > (int32_t)fb) goto L4d5871;
    /* 0x4d5855 */
    eax = A0;
    /* 0x4d5858 */
    ecx = A1;
    /* 0x4d585b */
    edx = (uint32_t)(rd32(a0, 12));
    /* 0x4d585e */
    fa = (uint32_t)edx;
    fb = rd32(a1, 4);
    /* 0x4d5861 */
    if ((int32_t)fa < (int32_t)fb) goto L4d5871;
    /* 0x4d5863 */
    eax = A0;
    /* 0x4d5866 */
    ecx = A1;
    /* 0x4d5869 */
    edx = (uint32_t)(rd32(a0, 4));
    /* 0x4d586c */
    fa = (uint32_t)edx;
    fb = rd32(a1, 12);
    /* 0x4d586f */
    if ((int32_t)fa <= (int32_t)fb) goto L4d5878;
L4d5871:;
    /* 0x4d5871 */
    eax = (uint32_t)(0x1u);
    /* 0x4d5876 */
    goto L4d587a;
L4d5878:;
    /* 0x4d5878 */
    eax = (uint32_t)(0u);
    fa = 0u;
L4d587a:;
    /* 0x4d587a */
    /* 0x4d587c */
    /* 0x4d587d */
    return (uint32_t)eax;
}

/* ---- 0x4d6787 lifted ---- */
/* 0x4d6787, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x2b4]/2, [self+0x2b6]/2. Stores to [self+0x4]/4, [self+0x955a]/4. Globals: 0x58320d/1 (written), 0x5d17f5/4 (written), 0x63a998/2 (written). Calls (in code order): 0x425fc0(0 args), 0x43da93(0 args), 0x4c924d(this, 1 arg), 0x4d8618(this, 0 args), 0x4d88de(this, 0 args), 0x4d8f0a(this, 0 args), 0x4dad60(this, 0 args). Returns this. */
uint8_t * m4d6787_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4d678a */
    L4 = ecx;
    /* 0x4d678b */
    L4 = ecx;
    /* 0x4d678e */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4d6790 */
    eax = (uint32_t)(((uint32_t)eax & 0xffffff00u) | ((((uint32_t)world->byte_58320d) & 0xffu) << 0));
    /* 0x4d6795 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4d6797 */
    if (fa == 0) goto L4d67a5;
    /* 0x4d6799 */
    world->byte_58320d = (uint8_t)(0x0u);
    /* 0x4d67a0 */
    eax = (uintptr_t)call0(host, 0x425fc0, 0);
L4d67a5:;
    /* 0x4d67a5 */
    eax = (uintptr_t)call0(host, 0x43da93, 0);
    /* 0x4d67aa */
    world->value_5d17f5 = (uint32_t)(0x0u);
    /* 0x4d67b4 */
    ecx = L4;
    /* 0x4d67b7 */
    edx = (uint32_t)(((uint32_t)rd16(self, 692)) & 0xffffu);
    /* 0x4d67be */
    L8 = (uint32_t)(uint32_t)edx;
    /* 0x4d67bf */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4d67c4 */
    eax = (uintptr_t)call1(host, 0x4c924d, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4d67c9 */
    eax = L4;
    /* 0x4d67cc */
    ecx = (uint32_t)(((uint32_t)rd16(self, 694)) & 0xffffu);
    /* 0x4d67d3 */
    L8 = (uint32_t)(uint32_t)ecx;
    /* 0x4d67d4 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4d67d9 */
    eax = (uintptr_t)call1(host, 0x4c924d, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4d67de */
    ecx = L4;
    /* 0x4d67e1 */
    eax = (uintptr_t)call0(host, 0x4d8f0a, ecx);
    /* 0x4d67e6 */
    ecx = L4;
    /* 0x4d67e9 */
    eax = (uintptr_t)call0(host, 0x4d88de, ecx);
    /* 0x4d67ee */
    edx = L4;
    /* 0x4d67f1 */
    wr32(self, 38234, (uint32_t)(0x0u));
    /* 0x4d67fb */
    ecx = L4;
    /* 0x4d67fe */
    eax = (uintptr_t)call0(host, 0x4d8618, ecx);
    /* 0x4d6803 */
    ecx = (uint32_t)(0x5830a6u);
    /* 0x4d6808 */
    eax = (uintptr_t)call0(host, 0x4dad60, (uintptr_t)(uint32_t)ecx);
    /* 0x4d680d */
    world->word_63a998 = (uint16_t)(0x17u);
    /* 0x4d6816 */
    eax = L4;
    /* 0x4d6819 */
    wr32(self, 4, (uint32_t)(0x1u));
    /* 0x4d6820 */
    /* 0x4d6822 */
    /* 0x4d6823 */
    return (uint8_t *)eax;
}

/* ---- 0x4d794d lifted ---- */
/* 0x4d794d, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x955e]/4. Globals: 0x583981/4 (written), 0x583985/4 (written), 0x5839a1/4 (written), 0x5bb1e2/4. Calls (in code order): 0x4d79c7(this, 0 args), 0x4db870(this, 0 args). Returns eax. */
uint32_t m4d794d_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4d7950 */
    L4 = ecx;
    /* 0x4d7951 */
    L4 = ecx;
    /* 0x4d7954 */
    ecx = L4;
    /* 0x4d7957 */
    eax = (uintptr_t)call0(host, 0x4d79c7, ecx);
    /* 0x4d795c */
    eax = (uint32_t)(world->value_583985);
    /* 0x4d7961 */
    world->value_583981 = (uint32_t)((uint32_t)eax);
    /* 0x4d7966 */
    ecx = L4;
    /* 0x4d7969 */
    fa = rd32(self, 38238);
    fb = 0x0u;
    /* 0x4d7970 */
    if (fa != fb) goto L4d7991;
    /* 0x4d7972 */
    fa = world->value_5bb1e2;
    fb = 0x0u;
    /* 0x4d7979 */
    if (fa == fb) goto L4d7991;
    /* 0x4d797b */
    world->value_583981 = (uint32_t)(0xeu);
    /* 0x4d7985 */
    ecx = (uint32_t)(0x5830ceu);
    /* 0x4d798a */
    eax = (uintptr_t)call0(host, 0x4db870, (uintptr_t)(uint32_t)ecx);
    /* 0x4d798f */
    goto L4d79b9;
L4d7991:;
    /* 0x4d7991 */
    fa = world->value_583985;
    fb = 0x6u;
    /* 0x4d7998 */
    if (fa != fb) goto L4d79a6;
    /* 0x4d799a */
    world->value_5839a1 = (uint32_t)(0x0u);
    /* 0x4d79a4 */
    goto L4d79b9;
L4d79a6:;
    /* 0x4d79a6 */
    fa = world->value_583985;
    fb = 0xeu;
    /* 0x4d79ad */
    if (fa != fb) goto L4d79b9;
    /* 0x4d79af */
    ecx = (uint32_t)(0x5830ceu);
    /* 0x4d79b4 */
    eax = (uintptr_t)call0(host, 0x4db870, (uintptr_t)(uint32_t)ecx);
L4d79b9:;
    /* 0x4d79b9 */
    world->value_583985 = (uint32_t)(0x7u);
    /* 0x4d79c3 */
    /* 0x4d79c5 */
    /* 0x4d79c6 */
    return (uint32_t)eax;
}

/* ---- 0x4d79c7 lifted ---- */
/* 0x4d79c7, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x2b4]/2, [self+0x2b6]/2. Globals: 0x5d2ecb/4 (written). Calls (in code order): 0x43dbd5(0 args), 0x4c92c5(this, 1 arg), 0x4dad60(this, 0 args). Returns eax. */
uint32_t m4d79c7_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)world;
    /* 0x4d79ca */
    L4 = ecx;
    /* 0x4d79cb */
    L4 = ecx;
    /* 0x4d79ce */
    world->value_5d2ecb = (uint32_t)(0x0u);
    /* 0x4d79d8 */
    eax = L4;
    /* 0x4d79db */
    ecx = (uint32_t)(((uint32_t)rd16(self, 692)) & 0xffffu);
    /* 0x4d79e2 */
    L8 = (uint32_t)(uint32_t)ecx;
    /* 0x4d79e3 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4d79e8 */
    eax = (uintptr_t)call1(host, 0x4c92c5, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4d79ed */
    edx = L4;
    /* 0x4d79f0 */
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | ((((uint32_t)rd16(self, 694)) & 0xffffu) << 0));
    /* 0x4d79f7 */
    L8 = (uint32_t)((uint32_t)eax);
    /* 0x4d79f8 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4d79fd */
    eax = (uintptr_t)call1(host, 0x4c92c5, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4d7a02 */
    eax = (uintptr_t)call0(host, 0x43dbd5, 0);
    /* 0x4d7a07 */
    ecx = (uint32_t)(0x5830a6u);
    /* 0x4d7a0c */
    eax = (uintptr_t)call0(host, 0x4dad60, (uintptr_t)(uint32_t)ecx);
    /* 0x4d7a11 */
    /* 0x4d7a13 */
    /* 0x4d7a14 */
    return (uint32_t)eax;
}

/* ---- 0x4d8f8d lifted ---- */
/* 0x4d8f8d, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Calls (in code order): 0x51dc6c(1 arg). eax is left-over and not meaningful. */
uint32_t m4d8f8d_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)L12;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4d8f90 */
    /* 0x4d8f93 */
    L8 = ecx;
    /* 0x4d8f96 */
    fa = (uint32_t)A0;
    fb = 0x0u;
    /* 0x4d8f9a */
    if (fa != fb) goto L4d8f9e;
    /* 0x4d8f9c */
    goto L4d8fb0;
L4d8f9e:;
    /* 0x4d8f9e */
    eax = (uint32_t)((uint32_t)A0);
    /* 0x4d8fa1 */
    L4 = (uint32_t)((uint32_t)eax);
    /* 0x4d8fa4 */
    ecx = (uint32_t)((uint32_t)L4);
    /* 0x4d8fa7 */
    L12 = (uint32_t)((uint32_t)ecx);
    /* 0x4d8fa8 */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, (uintptr_t)(uint32_t)L12);
    /* 0x4d8fad */
L4d8fb0:;
    /* 0x4d8fb0 */
    /* 0x4d8fb2 */
    /* 0x4d8fb3 */
    return 0;
}

/* ---- 0x4d912a lifted ---- */
/* 0x4d912a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x98ac]/4. Stores to [self+0x98ac]/4. Calls (in code order): 0x42639d(this, 2 args), 0x4c97b4(this, 0 args), 0x50ca3e(3 args), 0x50cd72(5 args), 0x50cee4(1 arg), 0x50cf61(4 args), 0x50d0a9(2 args). Returns eax. */
uint32_t m4d912a_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uintptr_t L24 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L24;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4d912d */
    L4 = ecx;
    /* 0x4d912e */
    L4 = ecx;
    /* 0x4d9131 */
    eax = L4;
    /* 0x4d9134 */
    eax = (uintptr_t)(self + (687));
    /* 0x4d9139 */
    L8 = eax;
    /* 0x4d913a */
    L12 = (uint32_t)(0x55a9a8u);
    /* 0x4d913f */
    ecx = L4;
    /* 0x4d9142 */
    ecx = (uintptr_t)(self + (209891));
    /* 0x4d9148 */
    L16 = ecx;
    /* 0x4d9149 */
    eax = (uintptr_t)call3(host, 0x50ca3e, 0, L16, (uintptr_t)(uint32_t)L12, L8);
    /* 0x4d914e */
    /* 0x4d9151 */
    edx = L4;
    /* 0x4d9154 */
    edx = (uintptr_t)(self + (209891));
    /* 0x4d915a */
    L8 = edx;
    /* 0x4d915b */
    eax = L4;
    /* 0x4d915e */
    eax = (uintptr_t)(self + (677));
    /* 0x4d9163 */
    L12 = eax;
    /* 0x4d9164 */
    L16 = (uint32_t)(0x63a3c9u);
    /* 0x4d9169 */
    L20 = (uint32_t)(0x63a9b8u);
    /* 0x4d916e */
    L24 = (uint32_t)(0x63888bu);
    /* 0x4d9173 */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, L12, L8};
        eax = (uintptr_t)callv(host, 0x50cd72, 0, cargs, 5);
    }
    /* 0x4d9178 */
    /* 0x4d917b */
    L8 = (uint32_t)(0x55a9acu);
    /* 0x4d9180 */
    L12 = (uint32_t)(0x63888bu);
    /* 0x4d9185 */
    eax = (uintptr_t)call2(host, 0x50d0a9, 0, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4d918a */
    /* 0x4d918d */
    ecx = L4;
    /* 0x4d9190 */
    wr32(self, 39084, (uint32_t)((uint32_t)eax));
    /* 0x4d9196 */
    edx = L4;
    /* 0x4d9199 */
    fa = rd32(self, 39084);
    fb = 0x0u;
    /* 0x4d91a0 */
    if (fa != fb) goto L4d91a7;
    /* 0x4d91a2 */
    fa = ((uint32_t)(((((uint32_t)eax & 0xffffu)) ^ (((uint32_t)eax & 0xffffu))) & 0xffffu)) & 0xffffu;
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | (((fa) & 0xffffu) << 0));
    /* 0x4d91a5 */
    goto L4d9208;
L4d91a7:;
    /* 0x4d91a7 */
    eax = L4;
    /* 0x4d91aa */
    ecx = (uint32_t)(rd32(self, 39084));
    /* 0x4d91b0 */
    L8 = (uint32_t)((uint32_t)ecx);
    /* 0x4d91b1 */
    L12 = (uint32_t)(0x1u);
    /* 0x4d91b3 */
    L16 = (uint32_t)(0x905cu);
    /* 0x4d91b8 */
    edx = L4;
    /* 0x4d91bb */
    edx = (uintptr_t)(self + (1142));
    /* 0x4d91c1 */
    L20 = edx;
    /* 0x4d91c2 */
    eax = (uintptr_t)call4(host, 0x50cf61, 0, L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4d91c7 */
    /* 0x4d91ca */
    fa = (uint32_t)eax;
    fb = 0x1u;
    /* 0x4d91cd */
    if (fa == fb) goto L4d91f2;
    /* 0x4d91cf */
    L8 = (uint32_t)(0x63888bu);
    /* 0x4d91d4 */
    L12 = (uint32_t)(0x55a9b0u);
    /* 0x4d91d9 */
    ecx = (uint32_t)(0x583979u);
    /* 0x4d91de */
    eax = (uintptr_t)call2(host, 0x42639d, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4d91e3 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4d91e8 */
    eax = (uintptr_t)call0(host, 0x4c97b4, (uintptr_t)(uint32_t)ecx);
    /* 0x4d91ed */
    fa = ((uint32_t)(((((uint32_t)eax & 0xffffu)) ^ (((uint32_t)eax & 0xffffu))) & 0xffffu)) & 0xffffu;
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | (((fa) & 0xffffu) << 0));
    /* 0x4d91f0 */
    goto L4d9208;
L4d91f2:;
    /* 0x4d91f2 */
    eax = L4;
    /* 0x4d91f5 */
    ecx = (uint32_t)(rd32(self, 39084));
    /* 0x4d91fb */
    L8 = (uint32_t)((uint32_t)ecx);
    /* 0x4d91fc */
    eax = (uintptr_t)call1(host, 0x50cee4, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4d9201 */
    /* 0x4d9204 */
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | (((0x1u) & 0xffffu) << 0));
L4d9208:;
    /* 0x4d9208 */
    /* 0x4d920a */
    /* 0x4d920b */
    return (uint32_t)eax;
}

/* ---- 0x4d920c lifted ---- */
/* 0x4d920c, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x98ac]/4. Stores to [self+0x98ac]/4. Calls (in code order): 0x42639d(this, 2 args), 0x4c97b4(this, 0 args), 0x50ca3e(3 args), 0x50cd72(5 args), 0x50cee4(1 arg), 0x50d0a9(2 args), 0x50e493(4 args). Returns eax. */
uint32_t m4d920c_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uintptr_t L24 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L24;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4d920f */
    L4 = ecx;
    /* 0x4d9210 */
    L4 = ecx;
    /* 0x4d9213 */
    eax = L4;
    /* 0x4d9216 */
    eax = (uintptr_t)(self + (687));
    /* 0x4d921b */
    L8 = eax;
    /* 0x4d921c */
    L12 = (uint32_t)(0x55a9c8u);
    /* 0x4d9221 */
    ecx = L4;
    /* 0x4d9224 */
    ecx = (uintptr_t)(self + (209891));
    /* 0x4d922a */
    L16 = ecx;
    /* 0x4d922b */
    eax = (uintptr_t)call3(host, 0x50ca3e, 0, L16, (uintptr_t)(uint32_t)L12, L8);
    /* 0x4d9230 */
    /* 0x4d9233 */
    edx = L4;
    /* 0x4d9236 */
    edx = (uintptr_t)(self + (209891));
    /* 0x4d923c */
    L8 = edx;
    /* 0x4d923d */
    eax = L4;
    /* 0x4d9240 */
    eax = (uintptr_t)(self + (677));
    /* 0x4d9245 */
    L12 = eax;
    /* 0x4d9246 */
    L16 = (uint32_t)(0x63a3c9u);
    /* 0x4d924b */
    L20 = (uint32_t)(0x63a9bcu);
    /* 0x4d9250 */
    L24 = (uint32_t)(0x63888bu);
    /* 0x4d9255 */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, L12, L8};
        eax = (uintptr_t)callv(host, 0x50cd72, 0, cargs, 5);
    }
    /* 0x4d925a */
    /* 0x4d925d */
    L8 = (uint32_t)(0x55a9ccu);
    /* 0x4d9262 */
    L12 = (uint32_t)(0x63888bu);
    /* 0x4d9267 */
    eax = (uintptr_t)call2(host, 0x50d0a9, 0, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4d926c */
    /* 0x4d926f */
    ecx = L4;
    /* 0x4d9272 */
    wr32(self, 39084, (uint32_t)((uint32_t)eax));
    /* 0x4d9278 */
    edx = L4;
    /* 0x4d927b */
    fa = rd32(self, 39084);
    fb = 0x0u;
    /* 0x4d9282 */
    if (fa != fb) goto L4d92a4;
    /* 0x4d9284 */
    L8 = (uint32_t)(0x63888bu);
    /* 0x4d9289 */
    L12 = (uint32_t)(0x55a9d0u);
    /* 0x4d928e */
    ecx = (uint32_t)(0x583979u);
    /* 0x4d9293 */
    eax = (uintptr_t)call2(host, 0x42639d, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4d9298 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4d929d */
    eax = (uintptr_t)call0(host, 0x4c97b4, (uintptr_t)(uint32_t)ecx);
    /* 0x4d92a2 */
    goto L4d92fe;
L4d92a4:;
    /* 0x4d92a4 */
    eax = L4;
    /* 0x4d92a7 */
    ecx = (uint32_t)(rd32(self, 39084));
    /* 0x4d92ad */
    L8 = (uint32_t)((uint32_t)ecx);
    /* 0x4d92ae */
    L12 = (uint32_t)(0x1u);
    /* 0x4d92b0 */
    L16 = (uint32_t)(0x905cu);
    /* 0x4d92b5 */
    edx = L4;
    /* 0x4d92b8 */
    edx = (uintptr_t)(self + (1142));
    /* 0x4d92be */
    L20 = edx;
    /* 0x4d92bf */
    eax = (uintptr_t)call4(host, 0x50e493, 0, L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4d92c4 */
    /* 0x4d92c7 */
    fa = (uint32_t)eax;
    fb = 0x1u;
    /* 0x4d92ca */
    if (fa == fb) goto L4d92ec;
    /* 0x4d92cc */
    L8 = (uint32_t)(0x63888bu);
    /* 0x4d92d1 */
    L12 = (uint32_t)(0x55aa04u);
    /* 0x4d92d6 */
    ecx = (uint32_t)(0x583979u);
    /* 0x4d92db */
    eax = (uintptr_t)call2(host, 0x42639d, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4d92e0 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4d92e5 */
    eax = (uintptr_t)call0(host, 0x4c97b4, (uintptr_t)(uint32_t)ecx);
    /* 0x4d92ea */
    goto L4d92fe;
L4d92ec:;
    /* 0x4d92ec */
    eax = L4;
    /* 0x4d92ef */
    ecx = (uint32_t)(rd32(self, 39084));
    /* 0x4d92f5 */
    L8 = (uint32_t)((uint32_t)ecx);
    /* 0x4d92f6 */
    eax = (uintptr_t)call1(host, 0x50cee4, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4d92fb */
L4d92fe:;
    /* 0x4d92fe */
    /* 0x4d9300 */
    /* 0x4d9301 */
    return (uint32_t)eax;
}

/* ---- 0x4d9d70 lifted ---- */
/* 0x4d9d70, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5839a1/4 (written), 0x5b451f/2, 0x63a4cd/2. Calls (in code order): 0x44a2b7(1 arg), 0x4d9df3(0 args), 0x4da430(0 args), 0x4fb2a6(this, 2 args). Returns eax. */
uint32_t m4d9d70_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4d9d73 */
    L4 = ecx;
    /* 0x4d9d74 */
    eax = (uint32_t)(world->value_5839a1);
    /* 0x4d9d79 */
    L4 = (uint32_t)((uint32_t)eax);
    /* 0x4d9d7c */
    fa = (uint32_t)L4;
    fb = 0x0u;
    /* 0x4d9d80 */
    if (fa == fb) goto L4d9d90;
    /* 0x4d9d82 */
    fa = (uint32_t)L4;
    fb = 0x1u;
    /* 0x4d9d86 */
    if (fa == fb) goto L4d9d97;
    /* 0x4d9d88 */
    fa = (uint32_t)L4;
    fb = 0x2u;
    /* 0x4d9d8c */
    if (fa == fb) goto L4d9dea;
    /* 0x4d9d8e */
    goto L4d9def;
L4d9d90:;
    /* 0x4d9d90 */
    eax = (uintptr_t)call0(host, 0x4d9df3, 0);
    /* 0x4d9d95 */
    goto L4d9def;
L4d9d97:;
    /* 0x4d9d97 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_63a4cd));
    /* 0x4d9d9e */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4d9da0 */
    if (fa == 0) goto L4d9daf;
    /* 0x4d9da2 */
    L8 = (uint32_t)(0x55abe0u);
    /* 0x4d9da7 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4d9dac */
L4d9daf:;
    /* 0x4d9daf */
    edx = (uint32_t)(((uint32_t)world->word_5b451f) & 0xffffu);
    /* 0x4d9db6 */
    L8 = (uint32_t)(uint32_t)edx;
    /* 0x4d9db7 */
    L12 = (uint32_t)(0x5b452du);
    /* 0x4d9dbc */
    ecx = (uint32_t)(0x5c3a67u);
    /* 0x4d9dc1 */
    eax = (uintptr_t)call2(host, 0x4fb2a6, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4d9dc6 */
    world->value_5839a1 = (uint32_t)(0x2u);
    /* 0x4d9dd0 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_63a4cd));
    /* 0x4d9dd7 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4d9dd9 */
    if (fa == 0) goto L4d9de8;
    /* 0x4d9ddb */
    L8 = (uint32_t)(0x55ac00u);
    /* 0x4d9de0 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4d9de5 */
L4d9de8:;
    /* 0x4d9de8 */
    goto L4d9def;
L4d9dea:;
    /* 0x4d9dea */
    eax = (uintptr_t)call0(host, 0x4da430, 0);
L4d9def:;
    /* 0x4d9def */
    /* 0x4d9df1 */
    /* 0x4d9df2 */
    return (uint32_t)eax;
}

/* ---- 0x4db066 lifted ---- */
/* 0x4db066, this = ecx (self), `ret 0x8`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 unused, a1 unused. Reads [self+0x10]/4. Stores to [self+0xc]/4, [self+0x10]/4. Returns this. */
uint8_t * m4db066_lifted(uint8_t *self, uint32_t a0, uint32_t a1, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)a0;
    (void)a1;
    /* 0x4db069 */
    L4 = ecx;
    /* 0x4db06a */
    L4 = ecx;
    /* 0x4db06d */
    eax = L4;
    /* 0x4db070 */
    fa = rd32(self, 16);
    fb = 0x0u;
    /* 0x4db074 */
    if (fa != fb) goto L4db080;
    /* 0x4db076 */
    ecx = L4;
    /* 0x4db079 */
    wr32(self, 16, (uint32_t)(0x1u));
L4db080:;
    /* 0x4db080 */
    edx = L4;
    /* 0x4db083 */
    wr32(self, 12, (uint32_t)(0x0u));
    /* 0x4db08a */
    /* 0x4db08c */
    /* 0x4db08d */
    return (uint8_t *)eax;
}

/* ---- 0x4db780 lifted ---- */
/* 0x4db780, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x34]/4, [self+0x3c]/4, [self+0x38]/4, [self+0x40]/4. Stores to [self+0x44]/4, [self+0x48]/4, [self+0x4c]/4, [self+0x50]/4, [self+0x54]/4, [self+0x58]/4, [self+0x5c]/4, [self+0x60]/4. Globals: 0x583186/4, 0x58318a/4, 0x5d1683/4 (written), 0x5d16cd/4 (written). Calls (in code order): 0x493a54(this, 0 args). Returns eax. */
uint32_t m4db780_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4db783 */
    L4 = ecx;
    /* 0x4db784 */
    L4 = ecx;
    /* 0x4db787 */
    eax = L4;
    /* 0x4db78a */
    ecx = (uint32_t)(rd32(self, 52));
    /* 0x4db78d */
    fa = ((uint32_t)((((uint32_t)ecx) - (world->value_583186)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4db793 */
    edx = L4;
    /* 0x4db796 */
    wr32(self, 68, (uint32_t)((uint32_t)ecx));
    /* 0x4db799 */
    eax = L4;
    /* 0x4db79c */
    ecx = (uint32_t)(rd32(self, 60));
    /* 0x4db79f */
    fa = ((uint32_t)((((uint32_t)ecx) - (world->value_583186)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4db7a5 */
    edx = L4;
    /* 0x4db7a8 */
    wr32(self, 76, (uint32_t)((uint32_t)ecx));
    /* 0x4db7ab */
    eax = L4;
    /* 0x4db7ae */
    ecx = (uint32_t)(rd32(self, 56));
    /* 0x4db7b1 */
    fa = ((uint32_t)((((uint32_t)ecx) - (world->value_58318a)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4db7b7 */
    edx = L4;
    /* 0x4db7ba */
    wr32(self, 72, (uint32_t)((uint32_t)ecx));
    /* 0x4db7bd */
    eax = L4;
    /* 0x4db7c0 */
    ecx = (uint32_t)(rd32(self, 64));
    /* 0x4db7c3 */
    fa = ((uint32_t)((((uint32_t)ecx) - (world->value_58318a)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4db7c9 */
    edx = L4;
    /* 0x4db7cc */
    wr32(self, 80, (uint32_t)((uint32_t)ecx));
    /* 0x4db7cf */
    eax = L4;
    /* 0x4db7d2 */
    eax = (uintptr_t)(self + (52));
    /* 0x4db7d5 */
    ecx = L4;
    /* 0x4db7d8 */
    ecx = (uintptr_t)(self + (84));
    /* 0x4db7db */
    edx = (uint32_t)(rd32(self, 52));
    /* 0x4db7dd */
    wr32(self, 84, (uint32_t)((uint32_t)edx));
    /* 0x4db7df */
    edx = (uint32_t)(rd32(self, 56));
    /* 0x4db7e2 */
    wr32(self, 88, (uint32_t)((uint32_t)edx));
    /* 0x4db7e5 */
    edx = (uint32_t)(rd32(self, 60));
    /* 0x4db7e8 */
    wr32(self, 92, (uint32_t)((uint32_t)edx));
    /* 0x4db7eb */
    eax = (uint32_t)(rd32(self, 64));
    /* 0x4db7ee */
    wr32(self, 96, (uint32_t)((uint32_t)eax));
    /* 0x4db7f1 */
    world->value_5d1683 = (uint32_t)(0x0u);
    /* 0x4db7fb */
    ecx = (uint32_t)(0x630a9au);
    /* 0x4db800 */
    eax = (uintptr_t)call0(host, 0x493a54, (uintptr_t)(uint32_t)ecx);
    /* 0x4db805 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4db807 */
    if (fa == 0) goto L4db813;
    /* 0x4db809 */
    world->value_5d16cd = (uint32_t)(0x1u);
L4db813:;
    /* 0x4db813 */
    /* 0x4db815 */
    /* 0x4db816 */
    return (uint32_t)eax;
}

/* ---- 0x4db817 lifted ---- */
/* 0x4db817, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x34]/4, [self+0x38]/4, [self+0x3c]/4, [self+0x40]/4. Stores to [self+0x24]/4, [self+0x28]/4, [self+0x2c]/4, [self+0x30]/4. Globals: 0x5d1683/4 (written), 0x5d16cd/4 (written). Calls (in code order): 0x493a47(this, 0 args), 0x493af0(this, 0 args). Returns eax. */
uint32_t m4db817_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4db81a */
    L4 = ecx;
    /* 0x4db81b */
    L4 = ecx;
    /* 0x4db81e */
    eax = L4;
    /* 0x4db821 */
    eax = (uintptr_t)(self + (52));
    /* 0x4db824 */
    ecx = L4;
    /* 0x4db827 */
    ecx = (uintptr_t)(self + (36));
    /* 0x4db82a */
    edx = (uint32_t)(rd32(self, 52));
    /* 0x4db82c */
    wr32(self, 36, (uint32_t)((uint32_t)edx));
    /* 0x4db82e */
    edx = (uint32_t)(rd32(self, 56));
    /* 0x4db831 */
    wr32(self, 40, (uint32_t)((uint32_t)edx));
    /* 0x4db834 */
    edx = (uint32_t)(rd32(self, 60));
    /* 0x4db837 */
    wr32(self, 44, (uint32_t)((uint32_t)edx));
    /* 0x4db83a */
    eax = (uint32_t)(rd32(self, 64));
    /* 0x4db83d */
    wr32(self, 48, (uint32_t)((uint32_t)eax));
    /* 0x4db840 */
    world->value_5d1683 = (uint32_t)(0x1u);
    /* 0x4db84a */
    world->value_5d16cd = (uint32_t)(0x0u);
    /* 0x4db854 */
    ecx = (uint32_t)(0x630a9au);
    /* 0x4db859 */
    eax = (uintptr_t)call0(host, 0x493a47, (uintptr_t)(uint32_t)ecx);
    /* 0x4db85e */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4db860 */
    if (fa == 0) goto L4db86c;
    /* 0x4db862 */
    ecx = (uint32_t)(0x630a9au);
    /* 0x4db867 */
    eax = (uintptr_t)call0(host, 0x493af0, (uintptr_t)(uint32_t)ecx);
L4db86c:;
    /* 0x4db86c */
    /* 0x4db86e */
    /* 0x4db86f */
    return (uint32_t)eax;
}

/* ---- 0x4dbc77 lifted ---- */
/* 0x4dbc77, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x1c]/4, [self+0x20]/4. Returns this. */
uint8_t * m4dbc77_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    /* 0x4dbc7a */
    L4 = ecx;
    /* 0x4dbc7b */
    L4 = ecx;
    /* 0x4dbc7e */
    eax = L4;
    /* 0x4dbc81 */
    wr32(self, 28, (uint32_t)(0x2710u));
    /* 0x4dbc88 */
    ecx = L4;
    /* 0x4dbc8b */
    wr32(self, 32, (uint32_t)(0x2710u));
    /* 0x4dbc92 */
    /* 0x4dbc94 */
    /* 0x4dbc95 */
    return (uint8_t *)eax;
}

/* ---- 0x4dbfbf lifted ---- */
/* 0x4dbfbf, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x1c]/4, [self+0x46]/4, [self+0x4a]/4, [self+0xee]/4, [self+0xf2]/4, [self+0xf6]/4, [self+0xfa]/4, [self+0xfe]/4. ... Returns this. */
uint8_t * m4dbfbf_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x4dbfc2 */
    L4 = ecx;
    /* 0x4dbfc3 */
    L4 = ecx;
    /* 0x4dbfc6 */
    eax = L4;
    /* 0x4dbfc9 */
    wr32(self, 238, (uint32_t)(0x637fd7u));
    /* 0x4dbfd3 */
    ecx = L4;
    /* 0x4dbfd6 */
    wr32(self, 28, (uint32_t)(0x0u));
    /* 0x4dbfdd */
    edx = L4;
    /* 0x4dbfe0 */
    wr32(self, 70, (uint32_t)(0x0u));
    /* 0x4dbfe7 */
    eax = L4;
    /* 0x4dbfea */
    wr32(self, 74, (uint32_t)(0x0u));
    /* 0x4dbff1 */
    ecx = L4;
    /* 0x4dbff4 */
    wr32(self, 262, (uint32_t)(0x0u));
    /* 0x4dbffe */
    edx = L4;
    /* 0x4dc001 */
    wr32(self, 242, (uint32_t)(0x1u));
    /* 0x4dc00b */
    eax = L4;
    /* 0x4dc00e */
    wr32(self, 246, (uint32_t)(0x0u));
    /* 0x4dc018 */
    ecx = L4;
    /* 0x4dc01b */
    wr32(self, 250, (uint32_t)(0x0u));
    /* 0x4dc025 */
    edx = L4;
    /* 0x4dc028 */
    wr32(self, 254, (uint32_t)(0x0u));
    /* 0x4dc032 */
    eax = L4;
    /* 0x4dc035 */
    wr32(self, 258, (uint32_t)(0x0u));
    /* 0x4dc03f */
    /* 0x4dc041 */
    /* 0x4dc042 */
    return (uint8_t *)eax;
}

/* ---- 0x4dd28d lifted ---- */
/* 0x4dd28d, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0xb7]/2, [self+0xee]/4, [r1+0x1c2]/2, [r1+0x18e]/2, [r1+0x18c]/2. Stores to [r1+0x1c2]/2. eax is left-over and not meaningful. */
uint32_t m4dd28d_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4dd290 */
    L4 = ecx;
    /* 0x4dd291 */
    L4 = ecx;
    /* 0x4dd294 */
    eax = L4;
    /* 0x4dd297 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(self, 183)));
    /* 0x4dd29e */
    fa = (uint32_t)ecx;
    fb = 0x1u;
    /* 0x4dd2a1 */
    if (fa != fb) goto L4dd30d;
    /* 0x4dd2a3 */
    edx = L4;
    /* 0x4dd2a6 */
    eax = (uint32_t)(rd32(self, 238));
    /* 0x4dd2ac */
    ecx = (uint32_t)(((uint32_t)ecx & 0xffff0000u) | ((((uint32_t)rd16(res(host, (uint32_t)eax), 450)) & 0xffffu) << 0));
    /* 0x4dd2b3 */
    fa = ((uint32_t)(((((uint32_t)ecx & 0xffffu)) + (0x1u)) & 0xffffu)) & 0xffffu;
    ecx = (uint32_t)(((uint32_t)ecx & 0xffff0000u) | (((fa) & 0xffffu) << 0));
    /* 0x4dd2b7 */
    edx = L4;
    /* 0x4dd2ba */
    eax = (uint32_t)(rd32(self, 238));
    /* 0x4dd2c0 */
    wr16(res(host, (uint32_t)eax), 450, (uint16_t)(((uint32_t)ecx & 0xffffu)));
    /* 0x4dd2c7 */
    ecx = L4;
    /* 0x4dd2ca */
    edx = (uint32_t)(rd32(self, 238));
    /* 0x4dd2d0 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(res(host, (uint32_t)edx), 450)));
    /* 0x4dd2d7 */
    ecx = L4;
    /* 0x4dd2da */
    edx = (uint32_t)(rd32(self, 238));
    /* 0x4dd2e0 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(res(host, (uint32_t)edx), 398)));
    /* 0x4dd2e7 */
    fa = (uint32_t)eax;
    fb = (uint32_t)ecx;
    /* 0x4dd2e9 */
    if ((int32_t)fa <= (int32_t)fb) goto L4dd30b;
    /* 0x4dd2eb */
    edx = L4;
    /* 0x4dd2ee */
    eax = (uint32_t)(rd32(self, 238));
    /* 0x4dd2f4 */
    ecx = L4;
    /* 0x4dd2f7 */
    edx = (uint32_t)(rd32(self, 238));
    /* 0x4dd2fd */
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | ((((uint32_t)rd16(res(host, (uint32_t)eax), 398)) & 0xffffu) << 0));
    /* 0x4dd304 */
    wr16(res(host, (uint32_t)edx), 450, (uint16_t)(((uint32_t)eax & 0xffffu)));
L4dd30b:;
    /* 0x4dd30b */
    goto L4dd375;
L4dd30d:;
    /* 0x4dd30d */
    ecx = L4;
    /* 0x4dd310 */
    edx = (uint32_t)(rd32(self, 238));
    /* 0x4dd316 */
    eax = (uint32_t)(((uint32_t)rd16(res(host, (uint32_t)edx), 450)) & 0xffffu);
    /* 0x4dd31d */
    fa = ((uint32_t)(((((uint32_t)eax & 0xffffu)) - (0x1u)) & 0xffffu)) & 0xffffu;
    eax = (uint32_t)((fa) & 0xffffu);
    /* 0x4dd321 */
    ecx = L4;
    /* 0x4dd324 */
    edx = (uint32_t)(rd32(self, 238));
    /* 0x4dd32a */
    wr16(res(host, (uint32_t)edx), 450, (uint16_t)(((uint32_t)eax & 0xffffu)));
    /* 0x4dd331 */
    eax = L4;
    /* 0x4dd334 */
    ecx = (uint32_t)(rd32(self, 238));
    /* 0x4dd33a */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(res(host, (uint32_t)ecx), 450)));
    /* 0x4dd341 */
    eax = L4;
    /* 0x4dd344 */
    ecx = (uint32_t)(rd32(self, 238));
    /* 0x4dd34a */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)rd16(res(host, (uint32_t)ecx), 396)));
    /* 0x4dd351 */
    fa = (uint32_t)edx;
    fb = (uint32_t)eax;
    /* 0x4dd353 */
    if ((int32_t)fa >= (int32_t)fb) goto L4dd375;
    /* 0x4dd355 */
    ecx = L4;
    /* 0x4dd358 */
    edx = (uint32_t)(rd32(self, 238));
    /* 0x4dd35e */
    eax = L4;
    /* 0x4dd361 */
    ecx = (uint32_t)(rd32(self, 238));
    /* 0x4dd367 */
    edx = (uint32_t)(((uint32_t)edx & 0xffff0000u) | ((((uint32_t)rd16(res(host, (uint32_t)edx), 396)) & 0xffffu) << 0));
    /* 0x4dd36e */
    wr16(res(host, (uint32_t)ecx), 450, (uint16_t)(((uint32_t)edx & 0xffffu)));
L4dd375:;
    /* 0x4dd375 */
    /* 0x4dd377 */
    /* 0x4dd378 */
    return 0;
}

/* ---- 0x4dd409 lifted ---- */
/* 0x4dd409, this = ecx (self), `ret 0x8`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword, a1 dword. Reads [self+0x4]/4. Stores to [self+0x4]/4. Globals: 0x5b451f/2. Calls (in code order): 0x4dd471(this, 1 arg), 0x4dd8f7(this, 1 arg), 0x4fb2a6(this, 2 args). eax is left-over and not meaningful. */
uint32_t m4dd409_lifted(uint8_t *self, uint32_t a0, uint32_t a1, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t A1 = (uintptr_t)a1;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)A1;
    (void)L12;
    (void)L16;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4dd40c */
    /* 0x4dd40f */
    L4 = ecx;
    /* 0x4dd412 */
    eax = L4;
    /* 0x4dd415 */
    ecx = (uint32_t)(rd32(self, 4));
    /* 0x4dd418 */
    L8 = (uint32_t)((uint32_t)ecx);
    /* 0x4dd41b */
    fa = (uint32_t)L8;
    fb = 0x0u;
    /* 0x4dd41f */
    if (fa == fb) goto L4dd42f;
    /* 0x4dd421 */
    fa = (uint32_t)L8;
    fb = 0x1u;
    /* 0x4dd425 */
    if (fa == fb) goto L4dd43d;
    /* 0x4dd427 */
    fa = (uint32_t)L8;
    fb = 0x2u;
    /* 0x4dd42b */
    if (fa == fb) goto L4dd45f;
    /* 0x4dd42d */
    goto L4dd46b;
L4dd42f:;
    /* 0x4dd42f */
    edx = (uint32_t)((uint32_t)A0);
    /* 0x4dd432 */
    L12 = (uint32_t)((uint32_t)edx);
    /* 0x4dd433 */
    ecx = L4;
    /* 0x4dd436 */
    eax = (uintptr_t)call1(host, 0x4dd471, ecx, (uintptr_t)(uint32_t)L12);
    /* 0x4dd43b */
    goto L4dd46b;
L4dd43d:;
    /* 0x4dd43d */
    eax = (uint32_t)(((uint32_t)world->word_5b451f) & 0xffffu);
    /* 0x4dd443 */
    L12 = (uint32_t)(uint32_t)eax;
    /* 0x4dd444 */
    L16 = (uint32_t)(0x5b452du);
    /* 0x4dd449 */
    ecx = (uint32_t)(0x5c3a67u);
    /* 0x4dd44e */
    eax = (uintptr_t)call2(host, 0x4fb2a6, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12);
    /* 0x4dd453 */
    ecx = L4;
    /* 0x4dd456 */
    wr32(self, 4, (uint32_t)(0x2u));
    /* 0x4dd45d */
    goto L4dd46b;
L4dd45f:;
    /* 0x4dd45f */
    edx = (uint32_t)((uint32_t)A1);
    /* 0x4dd462 */
    L12 = (uint32_t)((uint32_t)edx);
    /* 0x4dd463 */
    ecx = L4;
    /* 0x4dd466 */
    eax = (uintptr_t)call1(host, 0x4dd8f7, ecx, (uintptr_t)(uint32_t)L12);
L4dd46b:;
    /* 0x4dd46b */
    /* 0x4dd46d */
    /* 0x4dd46e */
    return 0;
}

/* ---- 0x4de009 lifted ---- */
/* 0x4de009, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5cf665/4, 0x5d2d4d/4, 0x5d2e75/4, 0x616872/2, 0x63a4cd/2. Calls (in code order): 0x44a2b7(1 arg), 0x4c5377(this, 5 args). Returns eax. */
uint32_t m4de009_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uintptr_t L24 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L24;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4de00c */
    L4 = ecx;
    /* 0x4de00d */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_63a4cd));
    /* 0x4de014 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4de016 */
    if (fa == 0) goto L4de025;
    /* 0x4de018 */
    L8 = (uint32_t)(0x55b7c0u);
    /* 0x4de01d */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4de022 */
L4de025:;
    /* 0x4de025 */
    L4 = (uint32_t)((0x0u) & 0xffffu);
    /* 0x4de02b */
    goto L4de039;
L4de02d:;
    /* 0x4de02d */
    ecx = (uint32_t)((((uint32_t)L4 & 0xffffu)) & 0xffffu);
    /* 0x4de031 */
    fa = ((uint32_t)(((((uint32_t)ecx & 0xffffu)) + (0x1u)) & 0xffffu)) & 0xffffu;
    ecx = (uint32_t)((fa) & 0xffffu);
    /* 0x4de035 */
    L4 = (uint32_t)((((uint32_t)ecx & 0xffffu)) & 0xffffu);
L4de039:;
    /* 0x4de039 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4de03d */
    fa = (uint32_t)edx;
    fb = 0x3u;
    /* 0x4de040 */
    if ((int32_t)fa >= (int32_t)fb) goto L4de0cb;
    /* 0x4de046 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4de04a */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_616872));
    /* 0x4de051 */
    fa = (uint32_t)eax;
    fb = (uint32_t)ecx;
    /* 0x4de053 */
    if (fa != fb) goto L4de08f;
    /* 0x4de055 */
    L8 = (uint32_t)(0x55b7ecu);
    /* 0x4de05a */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4de05e */
    fa = ((uint32_t)((((uint32_t)edx) << 4u) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4de061 */
    fa = ((uint32_t)((((uint32_t)edx) + (0x6167b8u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4de067 */
    L12 = (uint32_t)((uint32_t)edx);
    /* 0x4de068 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4de06c */
    fa = ((uint32_t)((((uint32_t)eax) << 4u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4de06f */
    fa = ((uint32_t)((((uint32_t)eax) + (0x6167f8u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4de074 */
    L16 = (uint32_t)((uint32_t)eax);
    /* 0x4de075 */
    ecx = (uint32_t)(world->value_5cf665);
    /* 0x4de07b */
    L20 = (uint32_t)((uint32_t)ecx);
    /* 0x4de07c */
    edx = (uint32_t)(world->value_5d2e75);
    /* 0x4de082 */
    L24 = (uint32_t)((uint32_t)edx);
    /* 0x4de083 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4de088 */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8};
        eax = (uintptr_t)callv(host, 0x4c5377, (uintptr_t)(uint32_t)ecx, cargs, 5);
    }
    /* 0x4de08d */
    goto L4de0c6;
L4de08f:;
    /* 0x4de08f */
    L8 = (uint32_t)(0x55b814u);
    /* 0x4de094 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4de098 */
    fa = ((uint32_t)((((uint32_t)eax) << 4u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4de09b */
    fa = ((uint32_t)((((uint32_t)eax) + (0x6167b8u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4de0a0 */
    L12 = (uint32_t)((uint32_t)eax);
    /* 0x4de0a1 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4de0a5 */
    fa = ((uint32_t)((((uint32_t)ecx) << 4u) & 0xffffffffu)) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4de0a8 */
    fa = ((uint32_t)((((uint32_t)ecx) + (0x6167b8u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4de0ae */
    L16 = (uint32_t)((uint32_t)ecx);
    /* 0x4de0af */
    edx = (uint32_t)(world->value_5cf665);
    /* 0x4de0b5 */
    L20 = (uint32_t)((uint32_t)edx);
    /* 0x4de0b6 */
    eax = (uint32_t)(world->value_5d2d4d);
    /* 0x4de0bb */
    L24 = (uint32_t)((uint32_t)eax);
    /* 0x4de0bc */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4de0c1 */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8};
        eax = (uintptr_t)callv(host, 0x4c5377, (uintptr_t)(uint32_t)ecx, cargs, 5);
    }
L4de0c6:;
    /* 0x4de0c6 */
    goto L4de02d;
L4de0cb:;
    /* 0x4de0cb */
    /* 0x4de0cd */
    /* 0x4de0ce */
    return (uint32_t)eax;
}

/* ---- 0x4de0cf lifted ---- */
/* 0x4de0cf, ecx unused, plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5cf665/4, 0x5d2d4d/4, 0x63a4cd/2. Calls (in code order): 0x44a2b7(1 arg), 0x4c5377(this, 5 args). Returns eax. */
uint32_t m4de0cf_lifted(const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = 0;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4de0d2 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_63a4cd));
    /* 0x4de0d9 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4de0db */
    if (fa == 0) goto L4de0ea;
    /* 0x4de0dd */
    L4 = (uint32_t)(0x55b840u);
    /* 0x4de0e2 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L4);
    /* 0x4de0e7 */
L4de0ea:;
    /* 0x4de0ea */
    L4 = (uint32_t)(0x55b864u);
    /* 0x4de0ef */
    L8 = (uint32_t)(0x6167a8u);
    /* 0x4de0f4 */
    L12 = (uint32_t)(0x6167e8u);
    /* 0x4de0f9 */
    ecx = (uint32_t)(world->value_5cf665);
    /* 0x4de0ff */
    L16 = (uint32_t)((uint32_t)ecx);
    /* 0x4de100 */
    edx = (uint32_t)(world->value_5d2d4d);
    /* 0x4de106 */
    L20 = (uint32_t)((uint32_t)edx);
    /* 0x4de107 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4de10c */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8, (uintptr_t)(uint32_t)L4};
        eax = (uintptr_t)callv(host, 0x4c5377, (uintptr_t)(uint32_t)ecx, cargs, 5);
    }
    /* 0x4de111 */
    /* 0x4de112 */
    return (uint32_t)eax;
}

/* ---- 0x4de4f9 lifted ---- */
/* 0x4de4f9, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x991]/4. Calls (in code order): 0x4de2d8(this, 0 args), 0x4de440(this, 0 args), 0x4ee6c7(this, 1 arg). eax is left-over and not meaningful. */
uint32_t m4de4f9_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4de4fc */
    /* 0x4de4ff */
    L4 = ecx;
    /* 0x4de502 */
    eax = L4;
    /* 0x4de505 */
    ecx = (uint32_t)(rd32(self, 2449));
    /* 0x4de50b */
    L8 = (uint32_t)((uint32_t)ecx);
    /* 0x4de50e */
    fa = (uint32_t)L8;
    fb = 0x2u;
    /* 0x4de512 */
    if ((int32_t)fa < (int32_t)fb) goto L4de53a;
    /* 0x4de514 */
    fa = (uint32_t)L8;
    fb = 0x3u;
    /* 0x4de518 */
    if ((int32_t)fa <= (int32_t)fb) goto L4de51c;
    /* 0x4de51a */
    goto L4de53a;
L4de51c:;
    /* 0x4de51c */
    L12 = (uint32_t)(0x0u);
    /* 0x4de51e */
    ecx = L4;
    /* 0x4de521 */
    eax = (uintptr_t)call1(host, 0x4ee6c7, ecx, (uintptr_t)(uint32_t)L12);
    /* 0x4de526 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4de528 */
    if (fa != 0) goto L4de532;
    /* 0x4de52a */
    ecx = L4;
    /* 0x4de52d */
    eax = (uintptr_t)call0(host, 0x4de2d8, ecx);
L4de532:;
    /* 0x4de532 */
    ecx = L4;
    /* 0x4de535 */
    eax = (uintptr_t)call0(host, 0x4de440, ecx);
L4de53a:;
    /* 0x4de53a */
    /* 0x4de53c */
    /* 0x4de53d */
    return 0;
}

/* ---- 0x4de6d7 lifted ---- */
/* 0x4de6d7, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x73c]/4, [self+0x740]/4. Returns this. */
uint8_t * m4de6d7_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    /* 0x4de6da */
    L4 = ecx;
    /* 0x4de6db */
    L4 = ecx;
    /* 0x4de6de */
    eax = L4;
    /* 0x4de6e1 */
    wr32(self, 1852, (uint32_t)(0x0u));
    /* 0x4de6eb */
    ecx = L4;
    /* 0x4de6ee */
    wr32(self, 1856, (uint32_t)(0x0u));
    /* 0x4de6f8 */
    /* 0x4de6fa */
    /* 0x4de6fb */
    return (uint8_t *)eax;
}

/* ---- 0x4de6fc lifted ---- */
/* 0x4de6fc, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5d03b7/4. Calls (in code order): 0x4c2dfb(this, 1 arg), 0x4de6d7(this, 0 args), 0x4e1d34(this, 0 args), 0x4eead0(this, 0 args). Returns eax. */
uint32_t m4de6fc_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4de6ff */
    L4 = ecx;
    /* 0x4de700 */
    L4 = ecx;
    /* 0x4de703 */
    ecx = L4;
    /* 0x4de706 */
    ecx = (uintptr_t)(self + (1007));
    /* 0x4de70c */
    eax = (uintptr_t)call0(host, 0x4e1d34, ecx);
    /* 0x4de711 */
    ecx = L4;
    /* 0x4de714 */
    ecx = (uintptr_t)(self + (1406));
    /* 0x4de71a */
    eax = (uintptr_t)call0(host, 0x4eead0, ecx);
    /* 0x4de71f */
    fa = world->value_5d03b7;
    fb = 0x0u;
    /* 0x4de726 */
    if (fa == fb) goto L4de737;
    /* 0x4de728 */
    L8 = (uint32_t)(0x5d03b7u);
    /* 0x4de72d */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4de732 */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L8);
L4de737:;
    /* 0x4de737 */
    ecx = L4;
    /* 0x4de73a */
    eax = (uintptr_t)call0(host, 0x4de6d7, ecx);
    /* 0x4de73f */
    /* 0x4de741 */
    /* 0x4de742 */
    return (uint32_t)eax;
}

/* ---- 0x4e01b3 lifted ---- */
/* 0x4e01b3, ecx unused, plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5cf665/4, 0x5d02ab/4, 0x5d03b7/4. Calls (in code order): 0x4c5377(this, 5 args), 0x4e2b99(this, 0 args), 0x4eff03(this, 0 args). eax is left-over and not meaningful. */
uint32_t m4e01b3_lifted(const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = 0;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4e01b6 */
    fa = world->value_5d02ab;
    fb = 0x0u;
    /* 0x4e01bd */
    if (fa == fb) goto L4e01f9;
    /* 0x4e01bf */
    L4 = (uint32_t)(0x55ba74u);
    /* 0x4e01c4 */
    L8 = (uint32_t)(0x5833fdu);
    /* 0x4e01c9 */
    L12 = (uint32_t)(0x5833edu);
    /* 0x4e01ce */
    eax = (uint32_t)(world->value_5cf665);
    /* 0x4e01d3 */
    L16 = (uint32_t)((uint32_t)eax);
    /* 0x4e01d4 */
    ecx = (uint32_t)(world->value_5d03b7);
    /* 0x4e01da */
    L20 = (uint32_t)((uint32_t)ecx);
    /* 0x4e01db */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4e01e0 */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8, (uintptr_t)(uint32_t)L4};
        eax = (uintptr_t)callv(host, 0x4c5377, (uintptr_t)(uint32_t)ecx, cargs, 5);
    }
    /* 0x4e01e5 */
    ecx = (uint32_t)(0x583624u);
    /* 0x4e01ea */
    eax = (uintptr_t)call0(host, 0x4e2b99, (uintptr_t)(uint32_t)ecx);
    /* 0x4e01ef */
    ecx = (uint32_t)(0x5837b3u);
    /* 0x4e01f4 */
    eax = (uintptr_t)call0(host, 0x4eff03, (uintptr_t)(uint32_t)ecx);
L4e01f9:;
    /* 0x4e01f9 */
    /* 0x4e01fa */
    return 0;
}

/* ---- 0x4e023b lifted ---- */
/* 0x4e023b, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5835da/4, 0x5bb202/4, 0x5bb206/4, 0x5cf665/4, 0x5d2819/4. Calls (in code order): 0x4c5377(this, 5 args), 0x4c5d4b(this, 5 args). Returns eax. */
uint32_t m4e023b_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uintptr_t L24 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L24;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4e023e */
    L4 = ecx;
    /* 0x4e023f */
    fa = world->value_5bb202;
    fb = 0x0u;
    /* 0x4e0246 */
    if (fa == fb) goto L4e0270;
    /* 0x4e0248 */
    L8 = (uint32_t)(0x55baacu);
    /* 0x4e024d */
    L12 = (uint32_t)(0x5832aeu);
    /* 0x4e0252 */
    L16 = (uint32_t)(0x5832deu);
    /* 0x4e0257 */
    eax = (uint32_t)(world->value_5cf665);
    /* 0x4e025c */
    L20 = (uint32_t)((uint32_t)eax);
    /* 0x4e025d */
    ecx = (uint32_t)(world->value_5d2819);
    /* 0x4e0263 */
    L24 = (uint32_t)((uint32_t)ecx);
    /* 0x4e0264 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4e0269 */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8};
        eax = (uintptr_t)callv(host, 0x4c5d4b, (uintptr_t)(uint32_t)ecx, cargs, 5);
    }
    /* 0x4e026e */
    goto L4e0296;
L4e0270:;
    /* 0x4e0270 */
    L8 = (uint32_t)(0x55babcu);
    /* 0x4e0275 */
    L12 = (uint32_t)(0x5832aeu);
    /* 0x4e027a */
    L16 = (uint32_t)(0x5832aeu);
    /* 0x4e027f */
    edx = (uint32_t)(world->value_5cf665);
    /* 0x4e0285 */
    L20 = (uint32_t)((uint32_t)edx);
    /* 0x4e0286 */
    eax = (uint32_t)(world->value_5d2819);
    /* 0x4e028b */
    L24 = (uint32_t)((uint32_t)eax);
    /* 0x4e028c */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4e0291 */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8};
        eax = (uintptr_t)callv(host, 0x4c5377, (uintptr_t)(uint32_t)ecx, cargs, 5);
    }
L4e0296:;
    /* 0x4e0296 */
    fa = world->value_5bb206;
    fb = 0x0u;
    /* 0x4e029d */
    if (fa == fb) goto L4e02c8;
    /* 0x4e029f */
    L8 = (uint32_t)(0x55baccu);
    /* 0x4e02a4 */
    L12 = (uint32_t)(0x5832beu);
    /* 0x4e02a9 */
    L16 = (uint32_t)(0x5832eeu);
    /* 0x4e02ae */
    ecx = (uint32_t)(world->value_5cf665);
    /* 0x4e02b4 */
    L20 = (uint32_t)((uint32_t)ecx);
    /* 0x4e02b5 */
    edx = (uint32_t)(world->value_5d2819);
    /* 0x4e02bb */
    L24 = (uint32_t)((uint32_t)edx);
    /* 0x4e02bc */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4e02c1 */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8};
        eax = (uintptr_t)callv(host, 0x4c5d4b, (uintptr_t)(uint32_t)ecx, cargs, 5);
    }
    /* 0x4e02c6 */
    goto L4e02ee;
L4e02c8:;
    /* 0x4e02c8 */
    L8 = (uint32_t)(0x55badcu);
    /* 0x4e02cd */
    L12 = (uint32_t)(0x5832beu);
    /* 0x4e02d2 */
    L16 = (uint32_t)(0x5832beu);
    /* 0x4e02d7 */
    eax = (uint32_t)(world->value_5cf665);
    /* 0x4e02dc */
    L20 = (uint32_t)((uint32_t)eax);
    /* 0x4e02dd */
    ecx = (uint32_t)(world->value_5d2819);
    /* 0x4e02e3 */
    L24 = (uint32_t)((uint32_t)ecx);
    /* 0x4e02e4 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4e02e9 */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8};
        eax = (uintptr_t)callv(host, 0x4c5377, (uintptr_t)(uint32_t)ecx, cargs, 5);
    }
L4e02ee:;
    /* 0x4e02ee */
    fa = world->value_5835da;
    fb = 0x0u;
    /* 0x4e02f5 */
    if (fa == fb) goto L4e031d;
    /* 0x4e02f7 */
    L8 = (uint32_t)(0x55baecu);
    /* 0x4e02fc */
    L12 = (uint32_t)(0x5832ceu);
    /* 0x4e0301 */
    L16 = (uint32_t)(0x5832feu);
    /* 0x4e0306 */
    edx = (uint32_t)(world->value_5cf665);
    /* 0x4e030c */
    L20 = (uint32_t)((uint32_t)edx);
    /* 0x4e030d */
    eax = (uint32_t)(world->value_5d2819);
    /* 0x4e0312 */
    L24 = (uint32_t)((uint32_t)eax);
    /* 0x4e0313 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4e0318 */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8};
        eax = (uintptr_t)callv(host, 0x4c5377, (uintptr_t)(uint32_t)ecx, cargs, 5);
    }
L4e031d:;
    /* 0x4e031d */
    L4 = (uint32_t)((0x0u) & 0xffffu);
    /* 0x4e0323 */
    goto L4e0331;
L4e0325:;
    /* 0x4e0325 */
    ecx = (uint32_t)((((uint32_t)L4 & 0xffffu)) & 0xffffu);
    /* 0x4e0329 */
    fa = ((uint32_t)(((((uint32_t)ecx & 0xffffu)) + (0x1u)) & 0xffffu)) & 0xffffu;
    ecx = (uint32_t)((fa) & 0xffffu);
    /* 0x4e032d */
    L4 = (uint32_t)((((uint32_t)ecx & 0xffffu)) & 0xffffu);
L4e0331:;
    /* 0x4e0331 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4e0335 */
    fa = (uint32_t)edx;
    fb = 0x3u;
    /* 0x4e0338 */
    if ((int32_t)fa >= (int32_t)fb) goto L4e0373;
    /* 0x4e033a */
    L8 = (uint32_t)(0x55bafcu);
    /* 0x4e033f */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4e0343 */
    fa = ((uint32_t)((((uint32_t)eax) << 4u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4e0346 */
    fa = ((uint32_t)((((uint32_t)eax) + (0x5835e4u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4e034b */
    L12 = (uint32_t)((uint32_t)eax);
    /* 0x4e034c */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4e0350 */
    fa = ((uint32_t)((((uint32_t)ecx) << 4u) & 0xffffffffu)) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4e0353 */
    fa = ((uint32_t)((((uint32_t)ecx) + (0x58331eu)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4e0359 */
    L16 = (uint32_t)((uint32_t)ecx);
    /* 0x4e035a */
    edx = (uint32_t)(world->value_5cf665);
    /* 0x4e0360 */
    L20 = (uint32_t)((uint32_t)edx);
    /* 0x4e0361 */
    eax = (uint32_t)(world->value_5d2819);
    /* 0x4e0366 */
    L24 = (uint32_t)((uint32_t)eax);
    /* 0x4e0367 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4e036c */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8};
        eax = (uintptr_t)callv(host, 0x4c5d4b, (uintptr_t)(uint32_t)ecx, cargs, 5);
    }
    /* 0x4e0371 */
    goto L4e0325;
L4e0373:;
    /* 0x4e0373 */
    /* 0x4e0375 */
    /* 0x4e0376 */
    return (uint32_t)eax;
}

/* ---- 0x4e0377 lifted ---- */
/* 0x4e0377, ecx unused, plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5cf665/4, 0x5d2819/4, 0x5d298b/4, 0x5835d8/2. Calls (in code order): 0x4c5377(this, 5 args). Returns eax. */
uint32_t m4e0377_lifted(const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = 0;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4e037a */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_5835d8));
    /* 0x4e0381 */
    fa = (uint32_t)eax;
    fb = 0x2u;
    /* 0x4e0384 */
    if (fa != fb) goto L4e03af;
    /* 0x4e0386 */
    L4 = (uint32_t)(0x55bb0cu);
    /* 0x4e038b */
    L8 = (uint32_t)(0x5832ceu);
    /* 0x4e0390 */
    L12 = (uint32_t)(0x58330eu);
    /* 0x4e0395 */
    ecx = (uint32_t)(world->value_5cf665);
    /* 0x4e039b */
    L16 = (uint32_t)((uint32_t)ecx);
    /* 0x4e039c */
    edx = (uint32_t)(world->value_5d298b);
    /* 0x4e03a2 */
    L20 = (uint32_t)((uint32_t)edx);
    /* 0x4e03a3 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4e03a8 */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8, (uintptr_t)(uint32_t)L4};
        eax = (uintptr_t)callv(host, 0x4c5377, (uintptr_t)(uint32_t)ecx, cargs, 5);
    }
    /* 0x4e03ad */
    goto L4e03d5;
L4e03af:;
    /* 0x4e03af */
    L4 = (uint32_t)(0x55bb2cu);
    /* 0x4e03b4 */
    L8 = (uint32_t)(0x5832ceu);
    /* 0x4e03b9 */
    L12 = (uint32_t)(0x5832ceu);
    /* 0x4e03be */
    eax = (uint32_t)(world->value_5cf665);
    /* 0x4e03c3 */
    L16 = (uint32_t)((uint32_t)eax);
    /* 0x4e03c4 */
    ecx = (uint32_t)(world->value_5d2819);
    /* 0x4e03ca */
    L20 = (uint32_t)((uint32_t)ecx);
    /* 0x4e03cb */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4e03d0 */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8, (uintptr_t)(uint32_t)L4};
        eax = (uintptr_t)callv(host, 0x4c5377, (uintptr_t)(uint32_t)ecx, cargs, 5);
    }
L4e03d5:;
    /* 0x4e03d5 */
    /* 0x4e03d6 */
    return (uint32_t)eax;
}

/* ---- 0x4e0619 lifted ---- */
/* 0x4e0619, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x74f]/4, [self+0x753]/4. Stores to [self+0x753]/4. Calls (in code order): 0x4c2dfb(this, 1 arg), 0x4e04f3(this, 0 args), 0x4e1d34(this, 0 args). Returns eax. */
uint32_t m4e0619_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4e061c */
    L4 = ecx;
    /* 0x4e061d */
    L4 = ecx;
    /* 0x4e0620 */
    eax = L4;
    /* 0x4e0623 */
    fa = rd32(self, 1871);
    fb = 0x0u;
    /* 0x4e062a */
    if (fa == fb) goto L4e0640;
    /* 0x4e062c */
    ecx = L4;
    /* 0x4e062f */
    ecx = (uintptr_t)(self + (1871));
    /* 0x4e0635 */
    L8 = ecx;
    /* 0x4e0636 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4e063b */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, L8);
L4e0640:;
    /* 0x4e0640 */
    edx = L4;
    /* 0x4e0643 */
    wr32(self, 1875, (uint32_t)(0x0u));
    /* 0x4e064d */
    goto L4e0664;
L4e064f:;
    /* 0x4e064f */
    eax = L4;
    /* 0x4e0652 */
    ecx = (uint32_t)(rd32(self, 1875));
    /* 0x4e0658 */
    fa = ((uint32_t)((((uint32_t)ecx) + (0x1u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4e065b */
    edx = L4;
    /* 0x4e065e */
    wr32(self, 1875, (uint32_t)((uint32_t)ecx));
L4e0664:;
    /* 0x4e0664 */
    eax = L4;
    /* 0x4e0667 */
    fa = rd32(self, 1875);
    fb = 0x5u;
    /* 0x4e066e */
    if ((int32_t)fa >= (int32_t)fb) goto L4e0690;
    /* 0x4e0670 */
    ecx = L4;
    /* 0x4e0673 */
    edx = (uint32_t)(rd32(self, 1875));
    /* 0x4e0679 */
    edx = (uint32_t)((uint32_t)((uint32_t)((uint32_t)edx) * (uint32_t)(0x18fu)));
    /* 0x4e067f */
    eax = L4;
    /* 0x4e0682 */
    ecx = (uintptr_t)((uint8_t *)eax + (ptrdiff_t)(int32_t)((uint32_t)edx * 1u) + (ptrdiff_t)(1879));
    /* 0x4e0689 */
    eax = (uintptr_t)call0(host, 0x4e1d34, ecx);
    /* 0x4e068e */
    goto L4e064f;
L4e0690:;
    /* 0x4e0690 */
    ecx = L4;
    /* 0x4e0693 */
    eax = (uintptr_t)call0(host, 0x4e04f3, ecx);
    /* 0x4e0698 */
    /* 0x4e069a */
    /* 0x4e069b */
    return (uint32_t)eax;
}

/* ---- 0x4e06c0 lifted ---- */
/* 0x4e06c0, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x753]/4. Stores to [self+0x753]/4. Calls (in code order): 0x4e04f3(this, 0 args), 0x4e1a7e(this, 0 args), 0x4e1db3(this, 1 arg). Returns eax. */
uint32_t m4e06c0_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4e06c3 */
    L4 = ecx;
    /* 0x4e06c4 */
    L4 = ecx;
    /* 0x4e06c7 */
    ecx = L4;
    /* 0x4e06ca */
    eax = (uintptr_t)call0(host, 0x4e04f3, ecx);
    /* 0x4e06cf */
    eax = L4;
    /* 0x4e06d2 */
    wr32(self, 1875, (uint32_t)(0x0u));
    /* 0x4e06dc */
    goto L4e06f3;
L4e06de:;
    /* 0x4e06de */
    ecx = L4;
    /* 0x4e06e1 */
    edx = (uint32_t)(rd32(self, 1875));
    /* 0x4e06e7 */
    fa = ((uint32_t)((((uint32_t)edx) + (0x1u)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4e06ea */
    eax = L4;
    /* 0x4e06ed */
    wr32(self, 1875, (uint32_t)((uint32_t)edx));
L4e06f3:;
    /* 0x4e06f3 */
    ecx = L4;
    /* 0x4e06f6 */
    fa = rd32(self, 1875);
    fb = 0x5u;
    /* 0x4e06fd */
    if ((int32_t)fa >= (int32_t)fb) goto L4e0736;
    /* 0x4e06ff */
    edx = L4;
    /* 0x4e0702 */
    eax = (uint32_t)(rd32(self, 1875));
    /* 0x4e0708 */
    eax = (uint32_t)((uint32_t)((uint32_t)((uint32_t)eax) * (uint32_t)(0x162u)));
    /* 0x4e070e */
    ecx = L4;
    /* 0x4e0711 */
    edx = (uintptr_t)((uint8_t *)ecx + (ptrdiff_t)(int32_t)((uint32_t)eax * 1u) + (ptrdiff_t)(101));
    /* 0x4e0715 */
    L8 = edx;
    /* 0x4e0716 */
    eax = L4;
    /* 0x4e0719 */
    ecx = (uint32_t)(rd32(self, 1875));
    /* 0x4e071f */
    ecx = (uint32_t)((uint32_t)((uint32_t)((uint32_t)ecx) * (uint32_t)(0x18fu)));
    /* 0x4e0725 */
    edx = L4;
    /* 0x4e0728 */
    ecx = (uintptr_t)((uint8_t *)edx + (ptrdiff_t)(int32_t)((uint32_t)ecx * 1u) + (ptrdiff_t)(1879));
    /* 0x4e072f */
    eax = (uintptr_t)call1(host, 0x4e1db3, ecx, L8);
    /* 0x4e0734 */
    goto L4e06de;
L4e0736:;
    /* 0x4e0736 */
    ecx = L4;
    /* 0x4e0739 */
    eax = (uintptr_t)call0(host, 0x4e1a7e, ecx);
    /* 0x4e073e */
    /* 0x4e0740 */
    /* 0x4e0741 */
    return (uint32_t)eax;
}

/* ---- 0x4e119b lifted ---- */
/* 0x4e119b, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0xf2e]/4, [self+0x74f]/4. Stores to [self+0xf2e]/4. Globals: 0x5cf665/4. Calls (in code order): 0x4c5377(this, 5 args). eax is left-over and not meaningful. */
uint32_t m4e119b_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uintptr_t L24 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L24;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4e119e */
    L4 = ecx;
    /* 0x4e119f */
    L4 = ecx;
    /* 0x4e11a2 */
    eax = L4;
    /* 0x4e11a5 */
    fa = rd32(self, 3886);
    fb = 0x0u;
    /* 0x4e11ac */
    if (fa == fb) goto L4e11e9;
    /* 0x4e11ae */
    ecx = L4;
    /* 0x4e11b1 */
    wr32(self, 3886, (uint32_t)(0x0u));
    /* 0x4e11bb */
    L8 = (uint32_t)(0x55be74u);
    /* 0x4e11c0 */
    edx = L4;
    /* 0x4e11c3 */
    edx = (uintptr_t)(self + (69));
    /* 0x4e11c6 */
    L12 = edx;
    /* 0x4e11c7 */
    eax = L4;
    /* 0x4e11ca */
    eax = (uintptr_t)(self + (69));
    /* 0x4e11cd */
    L16 = eax;
    /* 0x4e11ce */
    ecx = (uint32_t)(world->value_5cf665);
    /* 0x4e11d4 */
    L20 = (uint32_t)((uint32_t)ecx);
    /* 0x4e11d5 */
    edx = L4;
    /* 0x4e11d8 */
    eax = (uint32_t)(rd32(self, 1871));
    /* 0x4e11de */
    L24 = (uint32_t)((uint32_t)eax);
    /* 0x4e11df */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4e11e4 */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, L16, L12, (uintptr_t)(uint32_t)L8};
        eax = (uintptr_t)callv(host, 0x4c5377, (uintptr_t)(uint32_t)ecx, cargs, 5);
    }
L4e11e9:;
    /* 0x4e11e9 */
    /* 0x4e11eb */
    /* 0x4e11ec */
    return 0;
}

/* ---- 0x4e1c9f lifted ---- */
/* 0x4e1c9f, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x14]/4, [self+0x18]/4, [self+0x1c]/4, [self+0x20]/4, [self+0x24]/4, [self+0x28]/4, [self+0x177]/4, [self+0x17b]/4. ... Returns this. */
uint8_t * m4e1c9f_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x4e1ca2 */
    L4 = ecx;
    /* 0x4e1ca3 */
    L4 = ecx;
    /* 0x4e1ca6 */
    eax = L4;
    /* 0x4e1ca9 */
    wr32(self, 375, (uint32_t)(0x0u));
    /* 0x4e1cb3 */
    ecx = L4;
    /* 0x4e1cb6 */
    wr32(self, 379, (uint32_t)(0x0u));
    /* 0x4e1cc0 */
    edx = L4;
    /* 0x4e1cc3 */
    wr32(self, 36, (uint32_t)(0x0u));
    /* 0x4e1cca */
    eax = L4;
    /* 0x4e1ccd */
    wr32(self, 40, (uint32_t)(0x0u));
    /* 0x4e1cd4 */
    ecx = L4;
    /* 0x4e1cd7 */
    wr32(self, 387, (uint32_t)(0x0u));
    /* 0x4e1ce1 */
    edx = L4;
    /* 0x4e1ce4 */
    wr32(self, 383, (uint32_t)(0x0u));
    /* 0x4e1cee */
    eax = L4;
    /* 0x4e1cf1 */
    wr32(self, 391, (uint32_t)(0x0u));
    /* 0x4e1cfb */
    ecx = L4;
    /* 0x4e1cfe */
    wr32(self, 395, (uint32_t)(0x0u));
    /* 0x4e1d08 */
    edx = L4;
    /* 0x4e1d0b */
    wr32(self, 20, (uint32_t)(0x0u));
    /* 0x4e1d12 */
    eax = L4;
    /* 0x4e1d15 */
    wr32(self, 24, (uint32_t)(0x0u));
    /* 0x4e1d1c */
    ecx = L4;
    /* 0x4e1d1f */
    wr32(self, 28, (uint32_t)(0x0u));
    /* 0x4e1d26 */
    edx = L4;
    /* 0x4e1d29 */
    wr32(self, 32, (uint32_t)(0x0u));
    /* 0x4e1d30 */
    /* 0x4e1d32 */
    /* 0x4e1d33 */
    return (uint8_t *)eax;
}

/* ---- 0x4e2913 lifted ---- */
/* 0x4e2913, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x17b]/4. Stores to [self+0x17b]/4. Returns eax. */
uint32_t m4e2913_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)fa;
    (void)fb;
    /* 0x4e2916 */
    L4 = ecx;
    /* 0x4e2917 */
    L4 = ecx;
    /* 0x4e291a */
    eax = L4;
    /* 0x4e291d */
    fa = rd32(self, 379);
    fb = 0x0u;
    /* 0x4e2924 */
    if (fa == fb) goto L4e293a;
    /* 0x4e2926 */
    ecx = L4;
    /* 0x4e2929 */
    wr32(self, 379, (uint32_t)(0x0u));
    /* 0x4e2933 */
    eax = (uint32_t)(0x1u);
    /* 0x4e2938 */
    goto L4e293c;
L4e293a:;
    /* 0x4e293a */
    eax = (uint32_t)(0u);
    fa = 0u;
L4e293c:;
    /* 0x4e293c */
    /* 0x4e293e */
    /* 0x4e293f */
    return (uint32_t)eax;
}

/* ---- 0x4e29b7 lifted ---- */
/* 0x4e29b7, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Reads [self+0x1c]/4. Stores to [self+0x1c]/4, [self+0x30]/4. Returns this. */
uint8_t * m4e29b7_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4e29ba */
    L4 = ecx;
    /* 0x4e29bb */
    L4 = ecx;
    /* 0x4e29be */
    eax = L4;
    /* 0x4e29c1 */
    ecx = (uint32_t)((uint32_t)A0);
    /* 0x4e29c4 */
    wr32(self, 28, (uint32_t)((uint32_t)ecx));
    /* 0x4e29c7 */
    edx = L4;
    /* 0x4e29ca */
    fa = rd32(self, 28);
    fb = 0x0u;
    /* 0x4e29ce */
    if (fa == fb) goto L4e29dc;
    /* 0x4e29d0 */
    eax = L4;
    /* 0x4e29d3 */
    wr32(self, 48, (uint32_t)(0x0u));
    /* 0x4e29da */
    goto L4e29e6;
L4e29dc:;
    /* 0x4e29dc */
    ecx = L4;
    /* 0x4e29df */
    wr32(self, 48, (uint32_t)(0x2u));
L4e29e6:;
    /* 0x4e29e6 */
    /* 0x4e29e8 */
    /* 0x4e29e9 */
    return (uint8_t *)eax;
}

/* ---- 0x4e2dd3 lifted ---- */
/* 0x4e2dd3, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x4528]/4, [self+0x452c]/4, [self+0x4534]/4. Returns this. */
uint8_t * m4e2dd3_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x4e2dd6 */
    L4 = ecx;
    /* 0x4e2dd7 */
    L4 = ecx;
    /* 0x4e2dda */
    eax = L4;
    /* 0x4e2ddd */
    wr32(self, 17704, (uint32_t)(0x0u));
    /* 0x4e2de7 */
    ecx = L4;
    /* 0x4e2dea */
    wr32(self, 17708, (uint32_t)(0x0u));
    /* 0x4e2df4 */
    edx = L4;
    /* 0x4e2df7 */
    wr32(self, 17716, (uint32_t)(0x0u));
    /* 0x4e2e01 */
    /* 0x4e2e03 */
    /* 0x4e2e04 */
    return (uint8_t *)eax;
}

/* ---- 0x4e35e8 lifted ---- */
/* 0x4e35e8, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5a1e58/4. Calls (in code order): 0x4e2940(this, 1 arg). eax is left-over and not meaningful. */
uint32_t m4e35e8_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4e35eb */
    /* 0x4e35ee */
    L8 = ecx;
    /* 0x4e35f1 */
    fa = world->value_5a1e58;
    fb = 0x0u;
    /* 0x4e35f8 */
    if (fa == fb) goto L4e360c;
    /* 0x4e35fa */
    L12 = (uint32_t)(0x0u);
    /* 0x4e35fc */
    ecx = L8;
    /* 0x4e35ff */
    ecx = (uintptr_t)(self + (12517));
    /* 0x4e3605 */
    eax = (uintptr_t)call1(host, 0x4e2940, ecx, (uintptr_t)(uint32_t)L12);
    /* 0x4e360a */
    goto L4e3646;
L4e360c:;
    /* 0x4e360c */
    L4 = (uint32_t)((0x0u) & 0xffffu);
    /* 0x4e3612 */
    goto L4e3620;
L4e3614:;
    /* 0x4e3614 */
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | (((((uint32_t)L4 & 0xffffu)) & 0xffffu) << 0));
    /* 0x4e3618 */
    fa = ((uint32_t)(((((uint32_t)eax & 0xffffu)) + (0x1u)) & 0xffffu)) & 0xffffu;
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | (((fa) & 0xffffu) << 0));
    /* 0x4e361c */
    L4 = (uint32_t)((((uint32_t)eax & 0xffffu)) & 0xffffu);
L4e3620:;
    /* 0x4e3620 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4e3624 */
    fa = (uint32_t)ecx;
    fb = 0xfu;
    /* 0x4e3627 */
    if ((int32_t)fa > (int32_t)fb) goto L4e3646;
    /* 0x4e3629 */
    L12 = (uint32_t)(0x0u);
    /* 0x4e362b */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4e362f */
    edx = (uint32_t)((uint32_t)((uint32_t)((uint32_t)edx) * (uint32_t)(0x18fu)));
    /* 0x4e3635 */
    eax = L8;
    /* 0x4e3638 */
    ecx = (uintptr_t)((uint8_t *)eax + (ptrdiff_t)(int32_t)((uint32_t)edx * 1u) + (ptrdiff_t)(7330));
    /* 0x4e363f */
    eax = (uintptr_t)call1(host, 0x4e2940, ecx, (uintptr_t)(uint32_t)L12);
    /* 0x4e3644 */
    goto L4e3614;
L4e3646:;
    /* 0x4e3646 */
    /* 0x4e3648 */
    /* 0x4e3649 */
    return 0;
}

/* ---- 0x4e364a lifted ---- */
/* 0x4e364a, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x4e2940(this, 1 arg). eax is left-over and not meaningful. */
uint32_t m4e364a_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4e364d */
    /* 0x4e3650 */
    L8 = ecx;
    /* 0x4e3653 */
    L4 = (uint32_t)((0x10u) & 0xffffu);
    /* 0x4e3659 */
    goto L4e3667;
L4e365b:;
    /* 0x4e365b */
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | (((((uint32_t)L4 & 0xffffu)) & 0xffffu) << 0));
    /* 0x4e365f */
    fa = ((uint32_t)(((((uint32_t)eax & 0xffffu)) + (0x1u)) & 0xffffu)) & 0xffffu;
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | (((fa) & 0xffffu) << 0));
    /* 0x4e3663 */
    L4 = (uint32_t)((((uint32_t)eax & 0xffffu)) & 0xffffu);
L4e3667:;
    /* 0x4e3667 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4e366b */
    fa = (uint32_t)ecx;
    fb = 0x19u;
    /* 0x4e366e */
    if ((int32_t)fa > (int32_t)fb) goto L4e368d;
    /* 0x4e3670 */
    L12 = (uint32_t)(0x4u);
    /* 0x4e3672 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4e3676 */
    edx = (uint32_t)((uint32_t)((uint32_t)((uint32_t)edx) * (uint32_t)(0x18fu)));
    /* 0x4e367c */
    eax = L8;
    /* 0x4e367f */
    ecx = (uintptr_t)((uint8_t *)eax + (ptrdiff_t)(int32_t)((uint32_t)edx * 1u) + (ptrdiff_t)(7330));
    /* 0x4e3686 */
    eax = (uintptr_t)call1(host, 0x4e2940, ecx, (uintptr_t)(uint32_t)L12);
    /* 0x4e368b */
    goto L4e365b;
L4e368d:;
    /* 0x4e368d */
    /* 0x4e368f */
    /* 0x4e3690 */
    return 0;
}

/* ---- 0x4e3691 lifted ---- */
/* 0x4e3691, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x4e2940(this, 1 arg). Returns eax. */
uint32_t m4e3691_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x4e3694 */
    L4 = ecx;
    /* 0x4e3695 */
    L4 = ecx;
    /* 0x4e3698 */
    L8 = (uint32_t)(0x0u);
    /* 0x4e369a */
    ecx = L4;
    /* 0x4e369d */
    ecx = (uintptr_t)(self + (13714));
    /* 0x4e36a3 */
    eax = (uintptr_t)call1(host, 0x4e2940, ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4e36a8 */
    L8 = (uint32_t)(0x0u);
    /* 0x4e36aa */
    ecx = L4;
    /* 0x4e36ad */
    ecx = (uintptr_t)(self + (14113));
    /* 0x4e36b3 */
    eax = (uintptr_t)call1(host, 0x4e2940, ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4e36b8 */
    L8 = (uint32_t)(0x0u);
    /* 0x4e36ba */
    ecx = L4;
    /* 0x4e36bd */
    ecx = (uintptr_t)(self + (14512));
    /* 0x4e36c3 */
    eax = (uintptr_t)call1(host, 0x4e2940, ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4e36c8 */
    L8 = (uint32_t)(0x0u);
    /* 0x4e36ca */
    ecx = L4;
    /* 0x4e36cd */
    ecx = (uintptr_t)(self + (12118));
    /* 0x4e36d3 */
    eax = (uintptr_t)call1(host, 0x4e2940, ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4e36d8 */
    L8 = (uint32_t)(0x0u);
    /* 0x4e36da */
    ecx = L4;
    /* 0x4e36dd */
    ecx = (uintptr_t)(self + (12517));
    /* 0x4e36e3 */
    eax = (uintptr_t)call1(host, 0x4e2940, ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4e36e8 */
    L8 = (uint32_t)(0x4u);
    /* 0x4e36ea */
    ecx = L4;
    /* 0x4e36ed */
    ecx = (uintptr_t)(self + (13315));
    /* 0x4e36f3 */
    eax = (uintptr_t)call1(host, 0x4e2940, ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4e36f8 */
    /* 0x4e36fa */
    /* 0x4e36fb */
    return (uint32_t)eax;
}

/* ---- 0x4e36fc lifted ---- */
/* 0x4e36fc, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5a1e58/4. Calls (in code order): 0x4e2940(this, 1 arg). Returns eax. */
uint32_t m4e36fc_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4e36ff */
    L4 = ecx;
    /* 0x4e3700 */
    L4 = ecx;
    /* 0x4e3703 */
    fa = world->value_5a1e58;
    fb = 0x0u;
    /* 0x4e370a */
    if (fa == fb) goto L4e372e;
    /* 0x4e370c */
    L8 = (uint32_t)(0x0u);
    /* 0x4e370e */
    ecx = L4;
    /* 0x4e3711 */
    ecx = (uintptr_t)(self + (13714));
    /* 0x4e3717 */
    eax = (uintptr_t)call1(host, 0x4e2940, ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4e371c */
    L8 = (uint32_t)(0x0u);
    /* 0x4e371e */
    ecx = L4;
    /* 0x4e3721 */
    ecx = (uintptr_t)(self + (14911));
    /* 0x4e3727 */
    eax = (uintptr_t)call1(host, 0x4e2940, ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4e372c */
    goto L4e376e;
L4e372e:;
    /* 0x4e372e */
    L8 = (uint32_t)(0x0u);
    /* 0x4e3730 */
    ecx = L4;
    /* 0x4e3733 */
    ecx = (uintptr_t)(self + (13714));
    /* 0x4e3739 */
    eax = (uintptr_t)call1(host, 0x4e2940, ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4e373e */
    L8 = (uint32_t)(0x0u);
    /* 0x4e3740 */
    ecx = L4;
    /* 0x4e3743 */
    ecx = (uintptr_t)(self + (14911));
    /* 0x4e3749 */
    eax = (uintptr_t)call1(host, 0x4e2940, ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4e374e */
    L8 = (uint32_t)(0x0u);
    /* 0x4e3750 */
    ecx = L4;
    /* 0x4e3753 */
    ecx = (uintptr_t)(self + (15310));
    /* 0x4e3759 */
    eax = (uintptr_t)call1(host, 0x4e2940, ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4e375e */
    L8 = (uint32_t)(0x0u);
    /* 0x4e3760 */
    ecx = L4;
    /* 0x4e3763 */
    ecx = (uintptr_t)(self + (12916));
    /* 0x4e3769 */
    eax = (uintptr_t)call1(host, 0x4e2940, ecx, (uintptr_t)(uint32_t)L8);
L4e376e:;
    /* 0x4e376e */
    /* 0x4e3770 */
    /* 0x4e3771 */
    return (uint32_t)eax;
}

/* ---- 0x4e3772 lifted ---- */
/* 0x4e3772, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x4e2940(this, 1 arg). Returns eax. */
uint32_t m4e3772_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x4e3775 */
    L4 = ecx;
    /* 0x4e3776 */
    L4 = ecx;
    /* 0x4e3779 */
    L8 = (uint32_t)(0x0u);
    /* 0x4e377b */
    ecx = L4;
    /* 0x4e377e */
    ecx = (uintptr_t)(self + (16507));
    /* 0x4e3784 */
    eax = (uintptr_t)call1(host, 0x4e2940, ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4e3789 */
    L8 = (uint32_t)(0x0u);
    /* 0x4e378b */
    ecx = L4;
    /* 0x4e378e */
    ecx = (uintptr_t)(self + (16906));
    /* 0x4e3794 */
    eax = (uintptr_t)call1(host, 0x4e2940, ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4e3799 */
    L8 = (uint32_t)(0x0u);
    /* 0x4e379b */
    ecx = L4;
    /* 0x4e379e */
    ecx = (uintptr_t)(self + (15709));
    /* 0x4e37a4 */
    eax = (uintptr_t)call1(host, 0x4e2940, ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4e37a9 */
    L8 = (uint32_t)(0x0u);
    /* 0x4e37ab */
    ecx = L4;
    /* 0x4e37ae */
    ecx = (uintptr_t)(self + (16108));
    /* 0x4e37b4 */
    eax = (uintptr_t)call1(host, 0x4e2940, ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4e37b9 */
    /* 0x4e37bb */
    /* 0x4e37bc */
    return (uint32_t)eax;
}

/* ---- 0x4e3a64 lifted ---- */
/* 0x4e3a64, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x6b8]/2, [self+0x6ba]/2, [self+0x6bc]/2, [self+0x6be]/2, [self+0x6c2]/4, [self+0x6c6]/4. Globals: 0x5bb5a7/4, 0x5bb5ab/4, 0x5bb5af/4, 0x5bb50b/2, 0x5bb57b/2, 0x5bb57f/2, 0x5bb593/2. Returns this. */
uint8_t * m4e3a64_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)world;
    /* 0x4e3a67 */
    L4 = ecx;
    /* 0x4e3a68 */
    L4 = ecx;
    /* 0x4e3a6b */
    eax = L4;
    /* 0x4e3a6e */
    ecx = (uint32_t)(((uint32_t)world->word_5bb57b) & 0xffffu);
    /* 0x4e3a75 */
    wr16(self, 1720, (uint16_t)(((uint32_t)ecx & 0xffffu)));
    /* 0x4e3a7c */
    edx = L4;
    /* 0x4e3a7f */
    eax = (uint32_t)(((uint32_t)world->word_5bb57f) & 0xffffu);
    /* 0x4e3a85 */
    wr16(self, 1722, (uint16_t)(((uint32_t)eax & 0xffffu)));
    /* 0x4e3a8c */
    ecx = L4;
    /* 0x4e3a8f */
    edx = (uint32_t)(((uint32_t)world->word_5bb50b) & 0xffffu);
    /* 0x4e3a96 */
    wr16(self, 1724, (uint16_t)(((uint32_t)edx & 0xffffu)));
    /* 0x4e3a9d */
    eax = L4;
    /* 0x4e3aa0 */
    ecx = (uint32_t)(((uint32_t)world->word_5bb593) & 0xffffu);
    /* 0x4e3aa7 */
    wr16(self, 1726, (uint16_t)(((uint32_t)ecx & 0xffffu)));
    /* 0x4e3aae */
    edx = L4;
    /* 0x4e3ab1 */
    eax = (uint32_t)(world->value_5bb5a7);
    /* 0x4e3ab6 */
    wr32(self, 1730, (uint32_t)((uint32_t)eax));
    /* 0x4e3abc */
    ecx = L4;
    /* 0x4e3abf */
    edx = (uint32_t)(world->value_5bb5ab);
    /* 0x4e3ac5 */
    wr32(self, 1734, (uint32_t)((uint32_t)edx));
    /* 0x4e3acb */
    eax = L4;
    /* 0x4e3ace */
    ecx = (uint32_t)(world->value_5bb5af);
    /* 0x4e3ad4 */
    wr32(self, 1734, (uint32_t)((uint32_t)ecx));
    /* 0x4e3ada */
    /* 0x4e3adc */
    /* 0x4e3add */
    return (uint8_t *)eax;
}

/* ---- 0x4e40a6 lifted ---- */
/* 0x4e40a6, this = ecx (self), `ret 0x1c`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword, a1 unused, a2 dword, a3 unused, a4 dword, a5 host pointer (read through), a6 dword. Reads [a5+0x4]/4. Stores to [a5+0x4]/4, [a5+0xc]/4, [self+0x4579]/2. Returns this. */
uint8_t * m4e40a6_lifted(uint8_t *self, uint32_t a0, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint8_t *a5, uint32_t a6, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t A2 = (uintptr_t)a2;
    uintptr_t A4 = (uintptr_t)a4;
    uintptr_t A5 = (uintptr_t)a5;
    uintptr_t A6 = (uintptr_t)a6;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)A2;
    (void)A4;
    (void)A5;
    (void)A6;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)a1;
    (void)a3;
    /* 0x4e40a9 */
    /* 0x4e40ac */
    L8 = ecx;
    /* 0x4e40af */
    eax = (uint32_t)((uint32_t)A4);
    /* 0x4e40b2 */
    fa = ((uint32_t)((((uint32_t)eax) - ((uint32_t)A2)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4e40b5 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)A6 & 0xffffu)));
    /* 0x4e40b9 */
    fa = ((uint32_t)((((uint32_t)eax) + ((uint32_t)ecx)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4e40bb */
    L4 = (uint32_t)((((uint32_t)eax & 0xffffu)) & 0xffffu);
    /* 0x4e40bf */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)A0 & 0xffffu)));
    /* 0x4e40c3 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4e40c7 */
    edx = (uint32_t)((uint32_t)((uint32_t)((uint32_t)eax) * (uint32_t)((uint32_t)edx)));
    /* 0x4e40ca */
    ecx = (uint32_t)((uint32_t)A2);
    /* 0x4e40cd */
    fa = ((uint32_t)((((uint32_t)ecx) + ((uint32_t)edx)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4e40cf */
    edx = A5;
    /* 0x4e40d2 */
    wr32(a5, 4, (uint32_t)((uint32_t)ecx));
    /* 0x4e40d5 */
    eax = A5;
    /* 0x4e40d8 */
    ecx = (uint32_t)(rd32(a5, 4));
    /* 0x4e40db */
    fa = ((uint32_t)((((uint32_t)ecx) + ((uint32_t)A4)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4e40de */
    fa = ((uint32_t)((((uint32_t)ecx) - ((uint32_t)A2)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4e40e1 */
    edx = A5;
    /* 0x4e40e4 */
    wr32(a5, 12, (uint32_t)((uint32_t)ecx));
    /* 0x4e40e7 */
    eax = L8;
    /* 0x4e40ea */
    ecx = (uint32_t)(((uint32_t)ecx & 0xffff0000u) | (((((uint32_t)A0 & 0xffffu)) & 0xffffu) << 0));
    /* 0x4e40ee */
    wr16(self, 17785, (uint16_t)(((uint32_t)ecx & 0xffffu)));
    /* 0x4e40f5 */
    /* 0x4e40f7 */
    /* 0x4e40f8 */
    return (uint8_t *)eax;
}

/* ---- 0x4e49e2 lifted ---- */
/* 0x4e49e2, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x691]/4, [self+0x6a5]/2, [self+0x6a7]/4, [self+0x6ab]/4, [self+0x6af]/2, [self+0x6b1]/1, [self+0x53c1]/4. Calls (in code order): 0x4e354a(this, 0 args), 0x4e364a(this, 0 args). Returns eax. */
uint32_t m4e49e2_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4e49e5 */
    L4 = ecx;
    /* 0x4e49e6 */
    L4 = ecx;
    /* 0x4e49e9 */
    eax = L4;
    /* 0x4e49ec */
    wr16(self, 1701, (uint16_t)(0x0u));
    /* 0x4e49f5 */
    ecx = (uint32_t)(0u);
    fa = 0u;
    /* 0x4e49f7 */
    edx = L4;
    /* 0x4e49fa */
    edx = (uintptr_t)(self + (1703));
    /* 0x4e4a00 */
    wr32(self, 1703, (uint32_t)((uint32_t)ecx));
    /* 0x4e4a02 */
    wr32(self, 1707, (uint32_t)((uint32_t)ecx));
    /* 0x4e4a05 */
    wr16(self, 1711, (uint16_t)(((uint32_t)ecx & 0xffffu)));
    /* 0x4e4a09 */
    self[1713] = (uint8_t)(((uint32_t)ecx & 0xffu));
    /* 0x4e4a0c */
    eax = L4;
    /* 0x4e4a0f */
    wr32(self, 21441, (uint32_t)(0x0u));
    /* 0x4e4a19 */
    ecx = L4;
    /* 0x4e4a1c */
    wr32(self, 1681, (uint32_t)(0x1u));
    /* 0x4e4a26 */
    ecx = L4;
    /* 0x4e4a29 */
    eax = (uintptr_t)call0(host, 0x4e354a, ecx);
    /* 0x4e4a2e */
    ecx = L4;
    /* 0x4e4a31 */
    eax = (uintptr_t)call0(host, 0x4e364a, ecx);
    /* 0x4e4a36 */
    /* 0x4e4a38 */
    /* 0x4e4a39 */
    return (uint32_t)eax;
}

/* ---- 0x4e7970 lifted ---- */
/* 0x4e7970, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x991]/4. Calls (in code order): 0x4d3137(0 args), 0x4e7757(this, 0 args), 0x4ee6c7(this, 1 arg). eax is left-over and not meaningful. */
uint32_t m4e7970_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4e7973 */
    /* 0x4e7976 */
    L4 = ecx;
    /* 0x4e7979 */
    eax = L4;
    /* 0x4e797c */
    ecx = (uint32_t)(rd32(self, 2449));
    /* 0x4e7982 */
    L8 = (uint32_t)((uint32_t)ecx);
    /* 0x4e7985 */
    fa = (uint32_t)L8;
    fb = 0x2u;
    /* 0x4e7989 */
    if (fa == fb) goto L4e7993;
    /* 0x4e798b */
    fa = (uint32_t)L8;
    fb = 0x3u;
    /* 0x4e798f */
    if (fa == fb) goto L4e79b0;
    /* 0x4e7991 */
    goto L4e79c6;
L4e7993:;
    /* 0x4e7993 */
    L12 = (uint32_t)(0x1u);
    /* 0x4e7995 */
    ecx = L4;
    /* 0x4e7998 */
    eax = (uintptr_t)call1(host, 0x4ee6c7, ecx, (uintptr_t)(uint32_t)L12);
    /* 0x4e799d */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4e799f */
    if (fa != 0) goto L4e79a9;
    /* 0x4e79a1 */
    ecx = L4;
    /* 0x4e79a4 */
    eax = (uintptr_t)call0(host, 0x4e7757, ecx);
L4e79a9:;
    /* 0x4e79a9 */
    eax = (uintptr_t)call0(host, 0x4d3137, 0);
    /* 0x4e79ae */
    goto L4e79c6;
L4e79b0:;
    /* 0x4e79b0 */
    L12 = (uint32_t)(0x1u);
    /* 0x4e79b2 */
    ecx = L4;
    /* 0x4e79b5 */
    eax = (uintptr_t)call1(host, 0x4ee6c7, ecx, (uintptr_t)(uint32_t)L12);
    /* 0x4e79ba */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4e79bc */
    if (fa != 0) goto L4e79c6;
    /* 0x4e79be */
    ecx = L4;
    /* 0x4e79c1 */
    eax = (uintptr_t)call0(host, 0x4e7757, ecx);
L4e79c6:;
    /* 0x4e79c6 */
    /* 0x4e79c8 */
    /* 0x4e79c9 */
    return 0;
}

/* ---- 0x4e79ca lifted ---- */
/* 0x4e79ca, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5cf665/4. Calls (in code order): 0x4c5377(this, 5 args), 0x4ee630(this, 0 args). Returns eax. */
uint32_t m4e79ca_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uintptr_t L24 = 0;
    uintptr_t L28 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L24;
    (void)L28;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4e79cd */
    /* 0x4e79d0 */
    L8 = ecx;
    /* 0x4e79d3 */
    ecx = L8;
    /* 0x4e79d6 */
    eax = (uintptr_t)call0(host, 0x4ee630, ecx);
    /* 0x4e79db */
    L4 = (uint32_t)((uint32_t)eax);
    /* 0x4e79de */
    fa = (uint32_t)L4;
    fb = 0x0u;
    /* 0x4e79e2 */
    if (fa == fb) goto L4e7a0c;
    /* 0x4e79e4 */
    L12 = (uint32_t)(0x55c514u);
    /* 0x4e79e9 */
    L16 = (uint32_t)(0x5b0227u);
    /* 0x4e79ee */
    eax = L8;
    /* 0x4e79f1 */
    eax = (uintptr_t)(self + (2433));
    /* 0x4e79f6 */
    L20 = eax;
    /* 0x4e79f7 */
    ecx = (uint32_t)(world->value_5cf665);
    /* 0x4e79fd */
    L24 = (uint32_t)((uint32_t)ecx);
    /* 0x4e79fe */
    edx = (uint32_t)((uint32_t)L4);
    /* 0x4e7a01 */
    L28 = (uint32_t)((uint32_t)edx);
    /* 0x4e7a02 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4e7a07 */
    {
        const uintptr_t cargs[5] = {(uintptr_t)(uint32_t)L28, (uintptr_t)(uint32_t)L24, L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12};
        eax = (uintptr_t)callv(host, 0x4c5377, (uintptr_t)(uint32_t)ecx, cargs, 5);
    }
L4e7a0c:;
    /* 0x4e7a0c */
    /* 0x4e7a0e */
    /* 0x4e7a0f */
    return (uint32_t)eax;
}

/* ---- 0x4e7c72 lifted ---- */
/* 0x4e7c72, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x699]/4, [self+0x695]/4, [self+0x691]/4. Stores to [self+0x691]/4, [self+0x695]/4, [self+0x699]/4. Calls (in code order): 0x4c2dfb(this, 1 arg). eax is left-over and not meaningful. */
uint32_t m4e7c72_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4e7c75 */
    L4 = ecx;
    /* 0x4e7c76 */
    L4 = ecx;
    /* 0x4e7c79 */
    eax = L4;
    /* 0x4e7c7c */
    fa = rd32(self, 1689);
    fb = 0x0u;
    /* 0x4e7c83 */
    if (fa == fb) goto L4e7ca6;
    /* 0x4e7c85 */
    ecx = L4;
    /* 0x4e7c88 */
    ecx = (uintptr_t)(self + (1689));
    /* 0x4e7c8e */
    L8 = ecx;
    /* 0x4e7c8f */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4e7c94 */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, L8);
    /* 0x4e7c99 */
    edx = L4;
    /* 0x4e7c9c */
    wr32(self, 1689, (uint32_t)(0x0u));
L4e7ca6:;
    /* 0x4e7ca6 */
    eax = L4;
    /* 0x4e7ca9 */
    fa = rd32(self, 1685);
    fb = 0x0u;
    /* 0x4e7cb0 */
    if (fa == fb) goto L4e7cd3;
    /* 0x4e7cb2 */
    ecx = L4;
    /* 0x4e7cb5 */
    ecx = (uintptr_t)(self + (1685));
    /* 0x4e7cbb */
    L8 = ecx;
    /* 0x4e7cbc */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4e7cc1 */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, L8);
    /* 0x4e7cc6 */
    edx = L4;
    /* 0x4e7cc9 */
    wr32(self, 1685, (uint32_t)(0x0u));
L4e7cd3:;
    /* 0x4e7cd3 */
    eax = L4;
    /* 0x4e7cd6 */
    fa = rd32(self, 1681);
    fb = 0x0u;
    /* 0x4e7cdd */
    if (fa == fb) goto L4e7d00;
    /* 0x4e7cdf */
    ecx = L4;
    /* 0x4e7ce2 */
    ecx = (uintptr_t)(self + (1681));
    /* 0x4e7ce8 */
    L8 = ecx;
    /* 0x4e7ce9 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4e7cee */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, L8);
    /* 0x4e7cf3 */
    edx = L4;
    /* 0x4e7cf6 */
    wr32(self, 1681, (uint32_t)(0x0u));
L4e7d00:;
    /* 0x4e7d00 */
    /* 0x4e7d02 */
    /* 0x4e7d03 */
    return 0;
}

/* ---- 0x4e7dad lifted ---- */
/* 0x4e7dad, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through). Reads [a0+0x112c]/4, [a0+0x1120]/4. Stores to [self+0x0]/1, [self+0x69d]/1. Calls (in code order): 0x42639d(this, 2 args), 0x4343a2(this, 1 arg). Returns eax. */
uint32_t m4e7dad_lifted(uint8_t *self, uint8_t *a0, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edi = 0;
    uintptr_t edx = 0;
    uintptr_t esi = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edi;
    (void)edx;
    (void)esi;
    (void)fa;
    (void)fb;
    /* 0x4e7db0 */
    L4 = ecx;
    /* 0x4e7db1 */
    /* 0x4e7db2 */
    /* 0x4e7db3 */
    L4 = ecx;
    /* 0x4e7db6 */
    L16 = (uint32_t)(0x55c584u);
    /* 0x4e7dbb */
    ecx = A0;
    /* 0x4e7dbe */
    eax = (uintptr_t)call1(host, 0x4343a2, ecx, (uintptr_t)(uint32_t)L16);
    /* 0x4e7dc3 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4e7dc5 */
    if (fa != 0) goto L4e7ddf;
    /* 0x4e7dc7 */
    L16 = (uint32_t)(0x55c588u);
    /* 0x4e7dcc */
    L20 = (uint32_t)(0x55c58cu);
    /* 0x4e7dd1 */
    ecx = (uint32_t)(0x583979u);
    /* 0x4e7dd6 */
    eax = (uintptr_t)call2(host, 0x42639d, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16);
    /* 0x4e7ddb */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4e7ddd */
    goto L4e7e0d;
L4e7ddf:;
    /* 0x4e7ddf */
    eax = A0;
    /* 0x4e7de2 */
    ecx = (uint32_t)(rd32(a0, 4396));
    /* 0x4e7de8 */
    edx = A0;
    /* 0x4e7deb */
    esi = (uint32_t)(rd32(a0, 4384));
    /* 0x4e7df1 */
    edi = L4;
    /* 0x4e7df4 */
    edi = (uintptr_t)(self + (1693));
    /* 0x4e7dfa */
    eax = (uint32_t)((uint32_t)ecx);
    /* 0x4e7dfc */
    fa = ((uint32_t)(((uint32_t)ecx) >> 2u)) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4e7dff */
    rep_movs((self + (1693)), res(host, (uint32_t)esi), (uint32_t)ecx, 4);
    edi = (uintptr_t)((uint8_t *)edi + (ptrdiff_t)((uint32_t)ecx * 4u));
    esi = (uint32_t)(esi + ((uint32_t)ecx * 4u));
    ecx = 0;
    /* 0x4e7e01 */
    ecx = (uint32_t)((uint32_t)eax);
    /* 0x4e7e03 */
    fa = ((uint32_t)((((uint32_t)ecx) & (0x3u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4e7e06 */
    rep_movs((uint8_t *)edi, res(host, (uint32_t)esi), (uint32_t)ecx, 1);
    edi = (uintptr_t)((uint8_t *)edi + (ptrdiff_t)((uint32_t)ecx * 1u));
    esi = (uint32_t)(esi + ((uint32_t)ecx * 1u));
    ecx = 0;
    /* 0x4e7e08 */
    eax = (uint32_t)(0x1u);
L4e7e0d:;
    /* 0x4e7e0d */
    /* 0x4e7e0e */
    /* 0x4e7e0f */
    /* 0x4e7e11 */
    /* 0x4e7e12 */
    return (uint32_t)eax;
}

/* ---- 0x4e8d72 lifted ---- */
/* 0x4e8d72, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x6b1c]/4. Stores to [self+0x6b1c]/4. Returns this. */
uint8_t * m4e8d72_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)fa;
    (void)fb;
    /* 0x4e8d75 */
    L4 = ecx;
    /* 0x4e8d76 */
    L4 = ecx;
    /* 0x4e8d79 */
    eax = L4;
    /* 0x4e8d7c */
    fa = rd32(self, 27420);
    fb = 0xffffffffu;
    /* 0x4e8d83 */
    if (fa == fb) goto L4e8d92;
    /* 0x4e8d85 */
    ecx = L4;
    /* 0x4e8d88 */
    wr32(self, 27420, (uint32_t)(0xffffffffu));
L4e8d92:;
    /* 0x4e8d92 */
    /* 0x4e8d94 */
    /* 0x4e8d95 */
    return (uint8_t *)eax;
}

/* ---- 0x4e94a9 lifted ---- */
/* 0x4e94a9, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x7011]/1. Returns eax. */
uint32_t m4e94a9_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)fa;
    (void)fb;
    /* 0x4e94ac */
    L4 = ecx;
    /* 0x4e94ad */
    L4 = ecx;
    /* 0x4e94b0 */
    eax = L4;
    /* 0x4e94b3 */
    ecx = (uint32_t)(0u);
    fa = 0u;
    /* 0x4e94b5 */
    ecx = (uint32_t)(((uint32_t)ecx & 0xffffff00u) | ((((uint32_t)self[28689]) & 0xffu) << 0));
    /* 0x4e94bb */
    eax = (uint32_t)((uint32_t)ecx);
    /* 0x4e94bd */
    /* 0x4e94bf */
    /* 0x4e94c0 */
    return (uint32_t)eax;
}

/* ---- 0x4ea1cb lifted ---- */
/* 0x4ea1cb, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Reads [self+0x699]/4. Stores to [self+0x699]/4. Globals: 0x5d1717/4 (written), 0x63a4cd/2. Calls (in code order): 0x44a2b7(1 arg), 0x4c2790(this, 4 args). eax is left-over and not meaningful. */
uint32_t m4ea1cb_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4ea1ce */
    L4 = ecx;
    /* 0x4ea1cf */
    L4 = ecx;
    /* 0x4ea1d2 */
    eax = L4;
    /* 0x4ea1d5 */
    fa = rd32(self, 1689);
    fb = 0x0u;
    /* 0x4ea1dc */
    if (fa != fb) goto L4ea219;
    /* 0x4ea1de */
    L8 = (uint32_t)(0x55cab8u);
    /* 0x4ea1e3 */
    L12 = (uint32_t)(0x6u);
    /* 0x4ea1e5 */
    ecx = (uint32_t)((uint32_t)A0);
    /* 0x4ea1e8 */
    L16 = (uint32_t)((uint32_t)ecx);
    /* 0x4ea1e9 */
    L20 = (uint32_t)(0x55cad0u);
    /* 0x4ea1ee */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4ea1f3 */
    eax = (uintptr_t)call4(host, 0x4c2790, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4ea1f8 */
    edx = L4;
    /* 0x4ea1fb */
    wr32(self, 1689, (uint32_t)((uint32_t)eax));
    /* 0x4ea201 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_63a4cd));
    /* 0x4ea208 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4ea20a */
    if (fa == 0) goto L4ea219;
    /* 0x4ea20c */
    L8 = (uint32_t)(0x55cad8u);
    /* 0x4ea211 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4ea216 */
L4ea219:;
    /* 0x4ea219 */
    world->value_5d1717 = (uint32_t)(0x0u);
    /* 0x4ea223 */
    /* 0x4ea225 */
    /* 0x4ea226 */
    return 0;
}

/* ---- 0x4ea361 lifted ---- */
/* 0x4ea361, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x8256]/4, [self+0x8286]/4. Stores to [self+0x8256]/4. Globals: 0x585d37/4, 0x5b1602/4 (written). Returns this. */
uint8_t * m4ea361_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4ea364 */
    L4 = ecx;
    /* 0x4ea365 */
    L4 = ecx;
    /* 0x4ea368 */
    eax = L4;
    /* 0x4ea36b */
    fa = rd32(self, 33366);
    fb = 0x0u;
    /* 0x4ea372 */
    if (fa == fb) goto L4ea39c;
    /* 0x4ea374 */
    ecx = L4;
    /* 0x4ea377 */
    edx = (uint32_t)(rd32(self, 33414));
    /* 0x4ea37d */
    fa = (uint32_t)edx;
    fb = world->value_585d37;
    /* 0x4ea383 */
    if (fa >= fb) goto L4ea39c;
    /* 0x4ea385 */
    eax = L4;
    /* 0x4ea388 */
    wr32(self, 33366, (uint32_t)(0x0u));
    /* 0x4ea392 */
    world->value_5b1602 = (uint32_t)(0x1u);
L4ea39c:;
    /* 0x4ea39c */
    /* 0x4ea39e */
    /* 0x4ea39f */
    return (uint8_t *)eax;
}

/* ---- 0x4eb5f2 lifted ---- */
/* 0x4eb5f2, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x7011]/1. Globals: 0x583232/1 (written), 0x583999/4 (written), 0x5bb1ca/4 (written), 0x5bb57b/4 (written), 0x5bb57f/4 (written), 0x5bb59b/4 (written), 0x5bb59f/4 (written), 0x5bb5a3/4 (written). Calls (in code order): 0x4e0559(this, 3 args), 0x4e9e84(this, 2 args), 0x52139c(3 args). Returns this. */
uint8_t * m4eb5f2_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4eb5f5 */
    L4 = ecx;
    /* 0x4eb5f6 */
    L4 = ecx;
    /* 0x4eb5f9 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_5c3a1b));
    /* 0x4eb600 */
    fa = (uint32_t)eax;
    fb = 0x270fu;
    /* 0x4eb605 */
    if (fa != fb) goto L4eb629;
    /* 0x4eb607 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_63a4cd));
    /* 0x4eb60e */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4eb610 */
    if (fa == 0) goto L4eb620;
    /* 0x4eb612 */
    L8 = (uint32_t)(0x0u);
    /* 0x4eb614 */
    L12 = (uint32_t)(0x0u);
    /* 0x4eb616 */
    L16 = (uint32_t)(0x55cbc8u);
    /* 0x4eb61b */
    eax = (uintptr_t)call3(host, 0x52139c, 0, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
L4eb620:;
    /* 0x4eb620 */
    world->word_5c3a1b = (uint16_t)(0x0u);
L4eb629:;
    /* 0x4eb629 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_5c3a1d));
    /* 0x4eb630 */
    world->value_5bb57b = (uint32_t)((uint32_t)edx);
    /* 0x4eb636 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_5c3a1d));
    /* 0x4eb63d */
    world->value_5bb57f = (uint32_t)((uint32_t)eax);
    /* 0x4eb642 */
    ecx = (uint32_t)(((uint32_t)world->word_5c3a1f) & 0xffffu);
    /* 0x4eb649 */
    world->word_5bb599 = (uint16_t)(((uint32_t)ecx & 0xffffu));
    /* 0x4eb650 */
    edx = (uint32_t)(((uint32_t)edx & 0xffff0000u) | ((((uint32_t)world->word_5c3a21) & 0xffffu) << 0));
    /* 0x4eb657 */
    world->word_5bb595 = (uint16_t)(((uint32_t)edx & 0xffffu));
    /* 0x4eb65e */
    eax = (uint32_t)(world->value_5c3a25);
    /* 0x4eb663 */
    world->value_5bb59b = (uint32_t)((uint32_t)eax);
    /* 0x4eb668 */
    ecx = (uint32_t)(world->value_5c3a29);
    /* 0x4eb66e */
    world->value_5bb59f = (uint32_t)((uint32_t)ecx);
    /* 0x4eb674 */
    edx = (uint32_t)(world->value_5c3a2d);
    /* 0x4eb67a */
    world->value_5bb5a3 = (uint32_t)((uint32_t)edx);
    /* 0x4eb680 */
    world->word_5c39ff = (uint16_t)(0x1u);
    /* 0x4eb689 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_5c3a23));
    /* 0x4eb690 */
    fa = (uint32_t)eax;
    fb = 0x1u;
    /* 0x4eb693 */
    if (fa != fb) goto L4eb6a1;
    /* 0x4eb695 */
    world->value_5bb1ca = (uint32_t)(0x0u);
    /* 0x4eb69f */
    goto L4eb6ab;
L4eb6a1:;
    /* 0x4eb6a1 */
    world->value_5bb1ca = (uint32_t)(0x1u);
L4eb6ab:;
    /* 0x4eb6ab */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_583f1d));
    /* 0x4eb6b2 */
    fa = (uint32_t)ecx;
    fb = 0xffffffffu;
    /* 0x4eb6b5 */
    if (fa == fb) goto L4eb6d9;
    /* 0x4eb6b7 */
    L8 = (uint32_t)(0x0u);
    /* 0x4eb6b9 */
    edx = (uint32_t)(((uint32_t)edx & 0xffff0000u) | ((((uint32_t)world->word_583f1d) & 0xffffu) << 0));
    /* 0x4eb6c0 */
    L12 = (uint32_t)((uint32_t)edx);
    /* 0x4eb6c1 */
    ecx = L4;
    /* 0x4eb6c4 */
    eax = (uintptr_t)call2(host, 0x4e9e84, ecx, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4eb6c9 */
    L8 = (uint32_t)(0x0u);
    /* 0x4eb6cb */
    L12 = (uint32_t)(0x0u);
    /* 0x4eb6cd */
    L16 = (uint32_t)(0x1u);
    /* 0x4eb6cf */
    ecx = (uint32_t)(0x570508u);
    /* 0x4eb6d4 */
    eax = (uintptr_t)call3(host, 0x4e0559, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
L4eb6d9:;
    /* 0x4eb6d9 */
    world->value_583999 = (uint32_t)(0x4u);
    /* 0x4eb6e3 */
    world->word_5c3a1b = (uint16_t)(0x270fu);
    /* 0x4eb6ec */
    world->word_5c3a1d = (uint16_t)(0x270fu);
    /* 0x4eb6f5 */
    eax = L4;
    /* 0x4eb6f8 */
    ecx = (uint32_t)(0u);
    fa = 0u;
    /* 0x4eb6fa */
    ecx = (uint32_t)(((uint32_t)ecx & 0xffffff00u) | ((((uint32_t)self[28689]) & 0xffu) << 0));
    /* 0x4eb700 */
    fa = ((uint32_t)ecx) & ((uint32_t)ecx);
    /* 0x4eb702 */
    if (fa != 0) goto L4eb70b;
    /* 0x4eb704 */
    world->byte_583232 = (uint8_t)(0x1u);
L4eb70b:;
    /* 0x4eb70b */
    /* 0x4eb70d */
    /* 0x4eb70e */
    return (uint8_t *)eax;
}

/* ---- 0x4eb9c8 lifted ---- */
/* 0x4eb9c8, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0xca0]/4, [self+0xca4]/4, [self+0xfca]/4, [self+0xfce]/4, [self+0x28da]/2. Returns eax. */
uint32_t m4eb9c8_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4eb9cb */
    /* 0x4eb9ce */
    L8 = ecx;
    /* 0x4eb9d1 */
    eax = L8;
    /* 0x4eb9d4 */
    wr32(self, 3232, (uint32_t)(0x0u));
    /* 0x4eb9de */
    ecx = L8;
    /* 0x4eb9e1 */
    wr32(self, 3236, (uint32_t)(0x0u));
    /* 0x4eb9eb */
    edx = L8;
    /* 0x4eb9ee */
    wr32(self, 4042, (uint32_t)(0xffffffffu));
    /* 0x4eb9f8 */
    eax = L8;
    /* 0x4eb9fb */
    wr32(self, 4046, (uint32_t)(0xffffffffu));
    /* 0x4eba05 */
    ecx = L8;
    /* 0x4eba08 */
    wr16(self, 10458, (uint16_t)(0x0u));
    /* 0x4eba11 */
    L4 = (uint32_t)((0x0u) & 0xffffu);
    /* 0x4eba17 */
    goto L4eba25;
L4eba19:;
    /* 0x4eba19 */
    edx = (uint32_t)((((uint32_t)L4 & 0xffffu)) & 0xffffu);
    /* 0x4eba1d */
    fa = ((uint32_t)(((((uint32_t)edx & 0xffffu)) + (0x1u)) & 0xffffu)) & 0xffffu;
    edx = (uint32_t)((fa) & 0xffffu);
    /* 0x4eba21 */
    L4 = (uint32_t)((((uint32_t)edx & 0xffffu)) & 0xffffu);
L4eba25:;
    /* 0x4eba25 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4eba29 */
    fa = (uint32_t)eax;
    fb = 0x190u;
    /* 0x4eba2e */
    if ((int32_t)fa >= (int32_t)fb) goto L4eba50;
    /* 0x4eba30 */
    ecx = (uint32_t)(0u);
    fa = 0u;
    /* 0x4eba32 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4eba36 */
    fa = ((uint32_t)((((uint32_t)edx) << 4u) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4eba39 */
    eax = L8;
    /* 0x4eba3c */
    edx = (uintptr_t)((uint8_t *)eax + (ptrdiff_t)(int32_t)((uint32_t)edx * 1u) + (ptrdiff_t)(4058));
    /* 0x4eba43 */
    wr32((uint8_t *)edx, 0, (uint32_t)((uint32_t)ecx));
    /* 0x4eba45 */
    wr32((uint8_t *)edx, 4, (uint32_t)((uint32_t)ecx));
    /* 0x4eba48 */
    wr32((uint8_t *)edx, 8, (uint32_t)((uint32_t)ecx));
    /* 0x4eba4b */
    wr32((uint8_t *)edx, 12, (uint32_t)((uint32_t)ecx));
    /* 0x4eba4e */
    goto L4eba19;
L4eba50:;
    /* 0x4eba50 */
    /* 0x4eba52 */
    /* 0x4eba53 */
    return (uint32_t)eax;
}

/* ---- 0x4eda10 lifted ---- */
/* 0x4eda10, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x0]/4. Calls (in code order): 0x4e1c50(this, 0 args), 0x4edae5(this, 0 args), 0x4ee980(this, 0 args). Returns this. The structured-exception frame is linked and unlinked (not modelled). */
uint8_t * m4eda10_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x4eda13 */
    L4 = (uint32_t)(0xffffffffu);
    /* 0x4eda15 */
    L8 = (uint32_t)(0x528b0eu);
    /* 0x4eda1a */
    /* 0x4eda20 */
    /* 0x4eda21 */
    /* 0x4eda28 */
    L16 = ecx;
    /* 0x4eda29 */
    L16 = ecx;
    /* 0x4eda2c */
    ecx = L16;
    /* 0x4eda2f */
    ecx = (uintptr_t)(self + (796));
    /* 0x4eda35 */
    eax = (uintptr_t)call0(host, 0x4e1c50, ecx);
    /* 0x4eda3a */
    L4 = (uint32_t)(0x0u);
    /* 0x4eda41 */
    ecx = L16;
    /* 0x4eda44 */
    ecx = (uintptr_t)(self + (1207));
    /* 0x4eda4a */
    eax = (uintptr_t)call0(host, 0x4ee980, ecx);
    /* 0x4eda4f */
    L4 = (uint32_t)(((uint32_t)L4 & 0xffffff00u) | (((0x1u) & 0xffu) << 0));
    /* 0x4eda53 */
    eax = L16;
    /* 0x4eda56 */
    wr32(self, 0, (uint32_t)(0x52e4fcu));
    /* 0x4eda5c */
    ecx = L16;
    /* 0x4eda5f */
    eax = (uintptr_t)call0(host, 0x4edae5, ecx);
    /* 0x4eda64 */
    L4 = (uint32_t)(0xffffffffu);
    /* 0x4eda6b */
    eax = L16;
    /* 0x4eda6e */
    /* 0x4eda71 */
    /* 0x4eda78 */
    /* 0x4eda7a */
    /* 0x4eda7b */
    return (uint8_t *)eax;
}

/* ---- 0x4edae5 lifted ---- */
/* 0x4edae5, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x2c]/752, [self+0x4ab]/4, [self+0x4af]/4, [self+0x4b3]/4, [self+0x675]/4, [self+0x679]/4, [self+0x67d]/4, [self+0x681]/4. ... Globals: 0x55cd94/4 (written), 0x63aa10/4 (written). Returns eax. */
uint32_t m4edae5_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edi = 0;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edi;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4edae8 */
    L4 = ecx;
    /* 0x4edae9 */
    /* 0x4edaea */
    L4 = ecx;
    /* 0x4edaed */
    eax = L4;
    /* 0x4edaf0 */
    wr32(self, 1199, (uint32_t)(0x0u));
    /* 0x4edafa */
    ecx = L4;
    /* 0x4edafd */
    wr32(self, 1203, (uint32_t)(0x0u));
    /* 0x4edb07 */
    edx = L4;
    /* 0x4edb0a */
    wr32(self, 1195, (uint32_t)(0x0u));
    /* 0x4edb14 */
    eax = L4;
    /* 0x4edb17 */
    wr32(self, 1653, (uint32_t)(0x0u));
    /* 0x4edb21 */
    ecx = L4;
    /* 0x4edb24 */
    wr32(self, 1657, (uint32_t)(0x0u));
    /* 0x4edb2e */
    edx = L4;
    /* 0x4edb31 */
    wr32(self, 1661, (uint32_t)(0x0u));
    /* 0x4edb3b */
    eax = L4;
    /* 0x4edb3e */
    wr32(self, 1665, (uint32_t)(0x0u));
    /* 0x4edb48 */
    ecx = L4;
    /* 0x4edb4b */
    wr32(self, 1669, (uint32_t)(0x0u));
    /* 0x4edb55 */
    world->value_55cd94 = (uint32_t)(0x1u);
    /* 0x4edb5f */
    world->value_63aa10 = (uint32_t)(0x0u);
    /* 0x4edb69 */
    edx = L4;
    /* 0x4edb6c */
    wr32(self, 1673, (uint32_t)(0x0u));
    /* 0x4edb76 */
    eax = L4;
    /* 0x4edb79 */
    wr32(self, 1677, (uint32_t)(0x0u));
    /* 0x4edb83 */
    ecx = (uint32_t)(0xbcu);
    /* 0x4edb88 */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4edb8a */
    edi = L4;
    /* 0x4edb8d */
    edi = (uintptr_t)(self + (44));
    /* 0x4edb90 */
    rep_stos((self + (44)), (uint32_t)eax, (uint32_t)ecx, 4);
    edi = (uintptr_t)(self + (796));
    ecx = 0;
    /* 0x4edb92 */
    /* 0x4edb93 */
    /* 0x4edb95 */
    /* 0x4edb96 */
    return (uint32_t)eax;
}

/* ---- 0x4ee517 lifted ---- */
/* 0x4ee517, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x4af]/4, [self+0x15f]/4. Stores to [self+0x685]/4. Calls (in code order): 0x4e26fc(this, 0 args). Returns eax. */
uint32_t m4ee517_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4ee51a */
    L4 = ecx;
    /* 0x4ee51b */
    L4 = ecx;
    /* 0x4ee51e */
    eax = L4;
    /* 0x4ee521 */
    fa = rd32(self, 1199);
    fb = 0x2u;
    /* 0x4ee528 */
    if (fa == fb) goto L4ee53a;
    /* 0x4ee52a */
    ecx = L4;
    /* 0x4ee52d */
    fa = rd32(self, 1199);
    fb = 0x3u;
    /* 0x4ee534 */
    if (fa == fb) goto L4ee53a;
    /* 0x4ee536 */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4ee538 */
    goto L4ee56e;
L4ee53a:;
    /* 0x4ee53a */
    edx = L4;
    /* 0x4ee53d */
    fa = rd32(self, 351);
    fb = 0x0u;
    /* 0x4ee544 */
    if (fa == fb) goto L4ee56c;
    /* 0x4ee546 */
    ecx = L4;
    /* 0x4ee549 */
    ecx = (uintptr_t)(self + (796));
    /* 0x4ee54f */
    eax = (uintptr_t)call0(host, 0x4e26fc, ecx);
    /* 0x4ee554 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4ee556 */
    if (fa == 0) goto L4ee56c;
    /* 0x4ee558 */
    eax = L4;
    /* 0x4ee55b */
    wr32(self, 1669, (uint32_t)(0x1u));
    /* 0x4ee565 */
    eax = (uint32_t)(0x1u);
    /* 0x4ee56a */
    goto L4ee56e;
L4ee56c:;
    /* 0x4ee56c */
    eax = (uint32_t)(0u);
    fa = 0u;
L4ee56e:;
    /* 0x4ee56e */
    /* 0x4ee570 */
    /* 0x4ee571 */
    return (uint32_t)eax;
}

/* ---- 0x4ee572 lifted ---- */
/* 0x4ee572, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x55cd94/4, 0x63aa10/4. Returns eax. */
uint32_t m4ee572_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4ee575 */
    L4 = ecx;
    /* 0x4ee576 */
    L4 = ecx;
    /* 0x4ee579 */
    fa = world->value_55cd94;
    fb = 0x0u;
    /* 0x4ee580 */
    if (fa == fb) goto L4ee58f;
    /* 0x4ee582 */
    fa = world->value_63aa10;
    fb = 0x0u;
    /* 0x4ee589 */
    if (fa != fb) goto L4ee58f;
    /* 0x4ee58b */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4ee58d */
    goto L4ee594;
L4ee58f:;
    /* 0x4ee58f */
    eax = (uint32_t)(0x1u);
L4ee594:;
    /* 0x4ee594 */
    /* 0x4ee596 */
    /* 0x4ee597 */
    return (uint32_t)eax;
}

/* ---- 0x4ee598 lifted ---- */
/* 0x4ee598, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x4af]/4. Returns eax. */
uint32_t m4ee598_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t L4 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)fa;
    (void)fb;
    /* 0x4ee59b */
    L4 = ecx;
    /* 0x4ee59c */
    L4 = ecx;
    /* 0x4ee59f */
    eax = L4;
    /* 0x4ee5a2 */
    fa = rd32(self, 1199);
    fb = 0x1u;
    /* 0x4ee5a9 */
    if (fa == fb) goto L4ee5b2;
    /* 0x4ee5ab */
    eax = (uint32_t)(0x1u);
    /* 0x4ee5b0 */
    goto L4ee5b4;
L4ee5b2:;
    /* 0x4ee5b2 */
    eax = (uint32_t)(0u);
    fa = 0u;
L4ee5b4:;
    /* 0x4ee5b4 */
    /* 0x4ee5b6 */
    /* 0x4ee5b7 */
    return (uint32_t)eax;
}

/* ---- 0x4ee5f2 lifted ---- */
/* 0x4ee5f2, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x63aa10/4. Returns eax. */
uint32_t m4ee5f2_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t L4 = 0;
    (void)host;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)world;
    /* 0x4ee5f5 */
    L4 = ecx;
    /* 0x4ee5f6 */
    L4 = ecx;
    /* 0x4ee5f9 */
    eax = (uint32_t)(world->value_63aa10);
    /* 0x4ee5fe */
    /* 0x4ee600 */
    /* 0x4ee601 */
    return (uint32_t)eax;
}

/* ---- 0x4ee9bb lifted ---- */
/* 0x4ee9bb, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Stores to [self+0x4]/4, [self+0x8]/4, [self+0xc]/4, [self+0x18]/196, [self+0xdc]/2, [self+0x14e]/4, [self+0x152]/4, [self+0x156]/4. ... Returns eax. */
uint32_t m4ee9bb_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edi = 0;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edi;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4ee9be */
    L4 = ecx;
    /* 0x4ee9bf */
    /* 0x4ee9c0 */
    L4 = ecx;
    /* 0x4ee9c3 */
    eax = L4;
    /* 0x4ee9c6 */
    wr32(self, 366, (uint32_t)(0x0u));
    /* 0x4ee9d0 */
    ecx = L4;
    /* 0x4ee9d3 */
    wr32(self, 4, (uint32_t)(0x0u));
    /* 0x4ee9da */
    edx = L4;
    /* 0x4ee9dd */
    wr32(self, 354, (uint32_t)(0x0u));
    /* 0x4ee9e7 */
    eax = L4;
    /* 0x4ee9ea */
    wr32(self, 414, (uint32_t)(0x0u));
    /* 0x4ee9f4 */
    ecx = L4;
    /* 0x4ee9f7 */
    wr32(self, 362, (uint32_t)(0x0u));
    /* 0x4eea01 */
    edx = L4;
    /* 0x4eea04 */
    wr32(self, 358, (uint32_t)(0x0u));
    /* 0x4eea0e */
    eax = L4;
    /* 0x4eea11 */
    wr32(self, 390, (uint32_t)(0x0u));
    /* 0x4eea1b */
    ecx = L4;
    /* 0x4eea1e */
    wr32(self, 386, (uint32_t)(0x0u));
    /* 0x4eea28 */
    edx = L4;
    /* 0x4eea2b */
    wr32(self, 398, (uint32_t)(0x0u));
    /* 0x4eea35 */
    eax = L4;
    /* 0x4eea38 */
    wr32(self, 394, (uint32_t)(0x0u));
    /* 0x4eea42 */
    ecx = L4;
    /* 0x4eea45 */
    wr32(self, 406, (uint32_t)(0x0u));
    /* 0x4eea4f */
    edx = L4;
    /* 0x4eea52 */
    wr32(self, 402, (uint32_t)(0x0u));
    /* 0x4eea5c */
    eax = L4;
    /* 0x4eea5f */
    wr32(self, 410, (uint32_t)(0x0u));
    /* 0x4eea69 */
    ecx = L4;
    /* 0x4eea6c */
    wr32(self, 418, (uint32_t)(0x0u));
    /* 0x4eea76 */
    edx = L4;
    /* 0x4eea79 */
    wr32(self, 8, (uint32_t)(0x0u));
    /* 0x4eea80 */
    eax = L4;
    /* 0x4eea83 */
    wr32(self, 12, (uint32_t)(0x0u));
    /* 0x4eea8a */
    ecx = L4;
    /* 0x4eea8d */
    wr32(self, 426, (uint32_t)(0x0u));
    /* 0x4eea97 */
    edx = L4;
    /* 0x4eea9a */
    wr32(self, 422, (uint32_t)(0x0u));
    /* 0x4eeaa4 */
    ecx = (uint32_t)(0x31u);
    /* 0x4eeaa9 */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4eeaab */
    edi = L4;
    /* 0x4eeaae */
    edi = (uintptr_t)(self + (24));
    /* 0x4eeab1 */
    rep_stos((self + (24)), (uint32_t)eax, (uint32_t)ecx, 4);
    edi = (uintptr_t)(self + (220));
    ecx = 0;
    /* 0x4eeab3 */
    rep_stos((self + (220)), ((uint32_t)eax & 0xffffu), 1u, 2);
    edi = (uintptr_t)(self + (222));
    /* 0x4eeab5 */
    eax = (uint32_t)(0u);
    fa = 0u;
    /* 0x4eeab7 */
    ecx = L4;
    /* 0x4eeaba */
    ecx = (uintptr_t)(self + (334));
    /* 0x4eeac0 */
    wr32(self, 334, (uint32_t)((uint32_t)eax));
    /* 0x4eeac2 */
    wr32(self, 338, (uint32_t)((uint32_t)eax));
    /* 0x4eeac5 */
    wr32(self, 342, (uint32_t)((uint32_t)eax));
    /* 0x4eeac8 */
    wr32(self, 346, (uint32_t)((uint32_t)eax));
    /* 0x4eeacb */
    /* 0x4eeacc */
    /* 0x4eeace */
    /* 0x4eeacf */
    return (uint32_t)eax;
}

/* ---- 0x4eead0 lifted ---- */
/* 0x4eead0, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x1a2]/4, [self+0x8]/4, [self+0xc]/4. Calls (in code order): 0x4c2dfb(this, 1 arg), 0x4ee9bb(this, 0 args). Returns eax. */
uint32_t m4eead0_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4eead3 */
    L4 = ecx;
    /* 0x4eead4 */
    L4 = ecx;
    /* 0x4eead7 */
    eax = L4;
    /* 0x4eeada */
    fa = rd32(self, 418);
    fb = 0x0u;
    /* 0x4eeae1 */
    if (fa != fb) goto L4eeafd;
    /* 0x4eeae3 */
    ecx = L4;
    /* 0x4eeae6 */
    fa = rd32(self, 8);
    fb = 0x0u;
    /* 0x4eeaea */
    if (fa == fb) goto L4eeafd;
    /* 0x4eeaec */
    edx = L4;
    /* 0x4eeaef */
    edx = (uintptr_t)(self + (8));
    /* 0x4eeaf2 */
    L8 = edx;
    /* 0x4eeaf3 */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4eeaf8 */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, L8);
L4eeafd:;
    /* 0x4eeafd */
    eax = L4;
    /* 0x4eeb00 */
    fa = rd32(self, 12);
    fb = 0x0u;
    /* 0x4eeb04 */
    if (fa == fb) goto L4eeb17;
    /* 0x4eeb06 */
    ecx = L4;
    /* 0x4eeb09 */
    ecx = (uintptr_t)(self + (12));
    /* 0x4eeb0c */
    L8 = ecx;
    /* 0x4eeb0d */
    ecx = (uint32_t)(0x5cf659u);
    /* 0x4eeb12 */
    eax = (uintptr_t)call1(host, 0x4c2dfb, (uintptr_t)(uint32_t)ecx, L8);
L4eeb17:;
    /* 0x4eeb17 */
    ecx = L4;
    /* 0x4eeb1a */
    eax = (uintptr_t)call0(host, 0x4ee9bb, ecx);
    /* 0x4eeb1f */
    /* 0x4eeb21 */
    /* 0x4eeb22 */
    return (uint32_t)eax;
}

/* ---- 0x4ef3ed lifted ---- */
/* 0x4ef3ed, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Reads [self+0x10]/4, [self+0xc2]/4, [self+0xca]/4. Stores to [self+0x10]/4, [self+0x19a]/4. Globals: 0x5b44f0/4, 0x5b44f4/4 (written), 0x5c39e5/4 (written), 0x5d1631/4 (written), 0x5d1639/4 (written). Calls (in code order): 0x4d5316(this, 2 args). Returns eax. */
uint32_t m4ef3ed_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)L12;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4ef3f0 */
    L4 = ecx;
    /* 0x4ef3f1 */
    L4 = ecx;
    /* 0x4ef3f4 */
    eax = L4;
    /* 0x4ef3f7 */
    wr32(self, 410, (uint32_t)(0x0u));
    /* 0x4ef401 */
    ecx = L4;
    /* 0x4ef404 */
    fa = rd32(self, 16);
    fb = 0x0u;
    /* 0x4ef408 */
    if (fa == fb) goto L4ef420;
    /* 0x4ef40a */
    edx = L4;
    /* 0x4ef40d */
    fa = rd32(self, 16);
    fb = 0x1u;
    /* 0x4ef411 */
    if (fa == fb) goto L4ef420;
    /* 0x4ef413 */
    eax = L4;
    /* 0x4ef416 */
    fa = rd32(self, 16);
    fb = 0x2u;
    /* 0x4ef41a */
    if (fa != fb) goto L4ef4c1;
L4ef420:;
    /* 0x4ef420 */
    ecx = L4;
    /* 0x4ef423 */
    ecx = (uintptr_t)(self + (318));
    /* 0x4ef429 */
    L8 = ecx;
    /* 0x4ef42a */
    edx = (uint32_t)((uint32_t)A0);
    /* 0x4ef42d */
    L12 = (uint32_t)((uint32_t)edx);
    /* 0x4ef42e */
    ecx = (uint32_t)(0x570450u);
    /* 0x4ef433 */
    eax = (uintptr_t)call2(host, 0x4d5316, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L12, L8);
    /* 0x4ef438 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4ef43a */
    if (fa == 0) goto L4ef4b7;
    /* 0x4ef43c */
    eax = L4;
    /* 0x4ef43f */
    wr32(self, 410, (uint32_t)(0x1u));
    /* 0x4ef449 */
    ecx = L4;
    /* 0x4ef44c */
    fa = rd32(self, 16);
    fb = 0x0u;
    /* 0x4ef450 */
    if (fa != fb) goto L4ef468;
    /* 0x4ef452 */
    edx = L4;
    /* 0x4ef455 */
    fa = rd32(self, 194);
    fb = 0x0u;
    /* 0x4ef45c */
    if (fa == fb) goto L4ef468;
    /* 0x4ef45e */
    eax = L4;
    /* 0x4ef461 */
    wr32(self, 16, (uint32_t)(0x1u));
L4ef468:;
    /* 0x4ef468 */
    ecx = L4;
    /* 0x4ef46b */
    fa = rd32(self, 202);
    fb = 0x0u;
    /* 0x4ef472 */
    if (fa == fb) goto L4ef4b0;
    /* 0x4ef474 */
    world->value_5c39e5 = (uint32_t)(0x27d9u);
    /* 0x4ef47e */
    world->value_5b44f4 = (uint32_t)(0x1u);
    /* 0x4ef488 */
    edx = (uint32_t)(world->value_5b44f0);
    /* 0x4ef48e */
    fa = ((uint32_t)((((uint32_t)edx) << 5u) & 0xffffffffu)) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4ef491 */
    eax = (uint32_t)(world->value_5b44f4);
    /* 0x4ef496 */
    fa = ((uint32_t)((((uint32_t)eax) << 4u) & 0xffffffffu)) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4ef499 */
    ecx = (uint32_t)((uint32_t)edx + (uint32_t)eax + (uint32_t)5969420);
    /* 0x4ef4a0 */
    world->value_5d1631 = (uint32_t)((uint32_t)ecx);
    /* 0x4ef4a6 */
    world->value_5d1639 = (uint32_t)(0x1u);
L4ef4b0:;
    /* 0x4ef4b0 */
    eax = (uint32_t)(0x1u);
    /* 0x4ef4b5 */
    goto L4ef4c3;
L4ef4b7:;
    /* 0x4ef4b7 */
    edx = L4;
    /* 0x4ef4ba */
    wr32(self, 16, (uint32_t)(0x0u));
L4ef4c1:;
    /* 0x4ef4c1 */
    eax = (uint32_t)(0u);
    fa = 0u;
L4ef4c3:;
    /* 0x4ef4c3 */
    /* 0x4ef4c5 */
    /* 0x4ef4c6 */
    return (uint32_t)eax;
}

/* ---- 0x4ef4f0 lifted ---- */
/* 0x4ef4f0, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Stores to [self+0x162]/4, [self+0x19e]/4. Returns this. */
uint8_t * m4ef4f0_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t L4 = 0;
    (void)host;
    (void)A0;
    (void)L4;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x4ef4f3 */
    L4 = ecx;
    /* 0x4ef4f4 */
    L4 = ecx;
    /* 0x4ef4f7 */
    eax = L4;
    /* 0x4ef4fa */
    ecx = (uint32_t)((uint32_t)A0);
    /* 0x4ef4fd */
    wr32(self, 354, (uint32_t)((uint32_t)ecx));
    /* 0x4ef503 */
    edx = L4;
    /* 0x4ef506 */
    wr32(self, 414, (uint32_t)(0x1u));
    /* 0x4ef510 */
    /* 0x4ef512 */
    /* 0x4ef513 */
    return (uint8_t *)eax;
}

/* ---- 0x4f67be lifted ---- */
/* 0x4f67be, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x63a4cd/2. Calls (in code order): 0x44a2b7(1 arg), 0x4f646c(this, 2 args). Returns eax. */
uint32_t m4f67be_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4f67c1 */
    /* 0x4f67c4 */
    L8 = ecx;
    /* 0x4f67c7 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_63a4cd));
    /* 0x4f67ce */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4f67d0 */
    if (fa == 0) goto L4f67df;
    /* 0x4f67d2 */
    L12 = (uint32_t)(0x55e8ccu);
    /* 0x4f67d7 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L12);
    /* 0x4f67dc */
L4f67df:;
    /* 0x4f67df */
    L4 = (uint32_t)(0x0u);
    /* 0x4f67e6 */
    goto L4f67f1;
L4f67e8:;
    /* 0x4f67e8 */
    ecx = (uint32_t)((uint32_t)L4);
    /* 0x4f67eb */
    fa = ((uint32_t)((((uint32_t)ecx) + (0x1u)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4f67ee */
    L4 = (uint32_t)((uint32_t)ecx);
L4f67f1:;
    /* 0x4f67f1 */
    fa = (uint32_t)L4;
    fb = 0x20u;
    /* 0x4f67f5 */
    if ((int32_t)fa >= (int32_t)fb) goto L4f6807;
    /* 0x4f67f7 */
    L12 = (uint32_t)(0x1u);
    /* 0x4f67f9 */
    edx = (uint32_t)((uint32_t)L4);
    /* 0x4f67fc */
    L16 = (uint32_t)((uint32_t)edx);
    /* 0x4f67fd */
    ecx = L8;
    /* 0x4f6800 */
    eax = (uintptr_t)call2(host, 0x4f646c, ecx, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12);
    /* 0x4f6805 */
    goto L4f67e8;
L4f6807:;
    /* 0x4f6807 */
    eax = (uint32_t)(0x1u);
    /* 0x4f680c */
    /* 0x4f680e */
    /* 0x4f680f */
    return (uint32_t)eax;
}

/* ---- 0x4f6810 lifted ---- */
/* 0x4f6810, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x4f6624(this, 2 args). Returns eax. */
uint32_t m4f6810_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4f6813 */
    /* 0x4f6816 */
    L8 = ecx;
    /* 0x4f6819 */
    L4 = (uint32_t)(0x0u);
    /* 0x4f6820 */
    goto L4f682b;
L4f6822:;
    /* 0x4f6822 */
    eax = (uint32_t)((uint32_t)L4);
    /* 0x4f6825 */
    fa = ((uint32_t)((((uint32_t)eax) + (0x1u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4f6828 */
    L4 = (uint32_t)((uint32_t)eax);
L4f682b:;
    /* 0x4f682b */
    fa = (uint32_t)L4;
    fb = 0x20u;
    /* 0x4f682f */
    if ((int32_t)fa >= (int32_t)fb) goto L4f6841;
    /* 0x4f6831 */
    L12 = (uint32_t)(0x1u);
    /* 0x4f6833 */
    ecx = (uint32_t)((uint32_t)L4);
    /* 0x4f6836 */
    L16 = (uint32_t)((uint32_t)ecx);
    /* 0x4f6837 */
    ecx = L8;
    /* 0x4f683a */
    eax = (uintptr_t)call2(host, 0x4f6624, ecx, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12);
    /* 0x4f683f */
    goto L4f6822;
L4f6841:;
    /* 0x4f6841 */
    eax = (uint32_t)(0x1u);
    /* 0x4f6846 */
    /* 0x4f6848 */
    /* 0x4f6849 */
    return (uint32_t)eax;
}

/* ---- 0x4f8a17 lifted ---- */
/* 0x4f8a17, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Reads [self+0x26c]/4, [self+0x268]/4, [self+0x264]/4, [self+0x260]/4, [self+0x25c]/4, [self+0x258]/4. Calls (in code order): 0x4f88de(this, 6 args). Returns eax. */
uint32_t m4f8a17_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uintptr_t L20 = 0;
    uintptr_t L24 = 0;
    uintptr_t L28 = 0;
    (void)host;
    (void)L12;
    (void)L16;
    (void)L20;
    (void)L24;
    (void)L28;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x4f8a1a */
    L4 = ecx;
    /* 0x4f8a1b */
    L4 = ecx;
    /* 0x4f8a1e */
    eax = L4;
    /* 0x4f8a21 */
    ecx = (uint32_t)(rd32(self, 620));
    /* 0x4f8a27 */
    L8 = (uint32_t)((uint32_t)ecx);
    /* 0x4f8a28 */
    edx = L4;
    /* 0x4f8a2b */
    eax = (uint32_t)(rd32(self, 616));
    /* 0x4f8a31 */
    L12 = (uint32_t)((uint32_t)eax);
    /* 0x4f8a32 */
    ecx = L4;
    /* 0x4f8a35 */
    edx = (uint32_t)(rd32(self, 612));
    /* 0x4f8a3b */
    L16 = (uint32_t)((uint32_t)edx);
    /* 0x4f8a3c */
    eax = L4;
    /* 0x4f8a3f */
    ecx = (uint32_t)(rd32(self, 608));
    /* 0x4f8a45 */
    L20 = (uint32_t)((uint32_t)ecx);
    /* 0x4f8a46 */
    edx = L4;
    /* 0x4f8a49 */
    eax = (uint32_t)(rd32(self, 604));
    /* 0x4f8a4f */
    L24 = (uint32_t)((uint32_t)eax);
    /* 0x4f8a50 */
    ecx = L4;
    /* 0x4f8a53 */
    edx = (uint32_t)(rd32(self, 600));
    /* 0x4f8a59 */
    L28 = (uint32_t)((uint32_t)edx);
    /* 0x4f8a5a */
    ecx = L4;
    /* 0x4f8a5d */
    {
        const uintptr_t cargs[6] = {(uintptr_t)(uint32_t)L28, (uintptr_t)(uint32_t)L24, (uintptr_t)(uint32_t)L20, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8};
        eax = (uintptr_t)callv(host, 0x4f88de, ecx, cargs, 6);
    }
    /* 0x4f8a62 */
    /* 0x4f8a64 */
    /* 0x4f8a65 */
    return (uint32_t)eax;
}

/* ---- 0x4fafc7 lifted ---- */
/* 0x4fafc7, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x63a4cd/2. Calls (in code order): 0x44a2b7(1 arg), 0x4fb1c6(this, 1 arg). Returns eax. */
uint32_t m4fafc7_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4fafca */
    /* 0x4fafcd */
    L8 = ecx;
    /* 0x4fafd0 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_63a4cd));
    /* 0x4fafd7 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4fafd9 */
    if (fa == 0) goto L4fafe8;
    /* 0x4fafdb */
    L12 = (uint32_t)(0x560648u);
    /* 0x4fafe0 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L12);
    /* 0x4fafe5 */
L4fafe8:;
    /* 0x4fafe8 */
    L4 = (uint32_t)((0x0u) & 0xffffu);
    /* 0x4fafee */
    goto L4faffc;
L4faff0:;
    /* 0x4faff0 */
    ecx = (uint32_t)((((uint32_t)L4 & 0xffffu)) & 0xffffu);
    /* 0x4faff4 */
    fa = ((uint32_t)(((((uint32_t)ecx & 0xffffu)) + (0x1u)) & 0xffffu)) & 0xffffu;
    ecx = (uint32_t)((fa) & 0xffffu);
    /* 0x4faff8 */
    L4 = (uint32_t)((((uint32_t)ecx & 0xffffu)) & 0xffffu);
L4faffc:;
    /* 0x4faffc */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4fb000 */
    fa = (uint32_t)edx;
    fb = 0xeu;
    /* 0x4fb003 */
    if ((int32_t)fa >= (int32_t)fb) goto L4fb014;
    /* 0x4fb005 */
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | (((((uint32_t)L4 & 0xffffu)) & 0xffffu) << 0));
    /* 0x4fb009 */
    L12 = (uint32_t)((uint32_t)eax);
    /* 0x4fb00a */
    ecx = L8;
    /* 0x4fb00d */
    eax = (uintptr_t)call1(host, 0x4fb1c6, ecx, (uintptr_t)(uint32_t)L12);
    /* 0x4fb012 */
    goto L4faff0;
L4fb014:;
    /* 0x4fb014 */
    /* 0x4fb016 */
    /* 0x4fb017 */
    return (uint32_t)eax;
}

/* ---- 0x4fb018 lifted ---- */
/* 0x4fb018, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x63a4cd/2. Calls (in code order): 0x44a2b7(1 arg), 0x4fc05d(this, 0 args), 0x4fc808(this, 1 arg). Returns eax. */
uint32_t m4fb018_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4fb01b */
    /* 0x4fb01e */
    L8 = ecx;
    /* 0x4fb021 */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_63a4cd));
    /* 0x4fb028 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4fb02a */
    if (fa == 0) goto L4fb039;
    /* 0x4fb02c */
    L12 = (uint32_t)(0x560678u);
    /* 0x4fb031 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L12);
    /* 0x4fb036 */
L4fb039:;
    /* 0x4fb039 */
    ecx = L8;
    /* 0x4fb03c */
    eax = (uintptr_t)call0(host, 0x4fc05d, ecx);
    /* 0x4fb041 */
    L4 = (uint32_t)((0x0u) & 0xffffu);
    /* 0x4fb047 */
    goto L4fb055;
L4fb049:;
    /* 0x4fb049 */
    ecx = (uint32_t)((((uint32_t)L4 & 0xffffu)) & 0xffffu);
    /* 0x4fb04d */
    fa = ((uint32_t)(((((uint32_t)ecx & 0xffffu)) + (0x1u)) & 0xffffu)) & 0xffffu;
    ecx = (uint32_t)((fa) & 0xffffu);
    /* 0x4fb051 */
    L4 = (uint32_t)((((uint32_t)ecx & 0xffffu)) & 0xffffu);
L4fb055:;
    /* 0x4fb055 */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4fb059 */
    fa = (uint32_t)edx;
    fb = 0xeu;
    /* 0x4fb05c */
    if ((int32_t)fa >= (int32_t)fb) goto L4fb06d;
    /* 0x4fb05e */
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | (((((uint32_t)L4 & 0xffffu)) & 0xffffu) << 0));
    /* 0x4fb062 */
    L12 = (uint32_t)((uint32_t)eax);
    /* 0x4fb063 */
    ecx = L8;
    /* 0x4fb066 */
    eax = (uintptr_t)call1(host, 0x4fc808, ecx, (uintptr_t)(uint32_t)L12);
    /* 0x4fb06b */
    goto L4fb049;
L4fb06d:;
    /* 0x4fb06d */
    /* 0x4fb06f */
    /* 0x4fb070 */
    return (uint32_t)eax;
}

/* ---- 0x4fb071 lifted ---- */
/* 0x4fb071, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x4fc808(this, 1 arg). Returns eax. */
uint32_t m4fb071_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x4fb074 */
    L4 = ecx;
    /* 0x4fb075 */
    L4 = ecx;
    /* 0x4fb078 */
    L8 = (uint32_t)(0x0u);
    /* 0x4fb07a */
    ecx = L4;
    /* 0x4fb07d */
    eax = (uintptr_t)call1(host, 0x4fc808, ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4fb082 */
    /* 0x4fb084 */
    /* 0x4fb085 */
    return (uint32_t)eax;
}

/* ---- 0x4fb086 lifted ---- */
/* 0x4fb086, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x4fb0bf(this, 1 arg). eax is left-over and not meaningful. */
uint32_t m4fb086_lifted(uint8_t *self, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4fb089 */
    /* 0x4fb08c */
    L8 = ecx;
    /* 0x4fb08f */
    L4 = (uint32_t)((0x0u) & 0xffffu);
    /* 0x4fb095 */
    goto L4fb0a3;
L4fb097:;
    /* 0x4fb097 */
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | (((((uint32_t)L4 & 0xffffu)) & 0xffffu) << 0));
    /* 0x4fb09b */
    fa = ((uint32_t)(((((uint32_t)eax & 0xffffu)) + (0x1u)) & 0xffffu)) & 0xffffu;
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | (((fa) & 0xffffu) << 0));
    /* 0x4fb09f */
    L4 = (uint32_t)((((uint32_t)eax & 0xffffu)) & 0xffffu);
L4fb0a3:;
    /* 0x4fb0a3 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4fb0a7 */
    fa = (uint32_t)ecx;
    fb = 0xeu;
    /* 0x4fb0aa */
    if ((int32_t)fa >= (int32_t)fb) goto L4fb0bb;
    /* 0x4fb0ac */
    edx = (uint32_t)((((uint32_t)L4 & 0xffffu)) & 0xffffu);
    /* 0x4fb0b0 */
    L12 = (uint32_t)(uint32_t)edx;
    /* 0x4fb0b1 */
    ecx = L8;
    /* 0x4fb0b4 */
    eax = (uintptr_t)call1(host, 0x4fb0bf, ecx, (uintptr_t)(uint32_t)L12);
    /* 0x4fb0b9 */
    goto L4fb097;
L4fb0bb:;
    /* 0x4fb0bb */
    /* 0x4fb0bd */
    /* 0x4fb0be */
    return 0;
}

/* ---- 0x4fb1c6 lifted ---- */
/* 0x4fb1c6, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Stores to [self+0x12c]/4, [self+0x132]/2. Globals: 0x63a4cd/2. Calls (in code order): 0x44a2b7(1 arg), 0x4f6334(this, 1 arg), 0x4f646c(this, 2 args), 0x50ca3e(3 args). eax is left-over and not meaningful. */
uint32_t m4fb1c6_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uintptr_t L16 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)L12;
    (void)L16;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4fb1c9 */
    L4 = ecx;
    /* 0x4fb1ca */
    L4 = ecx;
    /* 0x4fb1cd */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_63a4cd));
    /* 0x4fb1d4 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4fb1d6 */
    if (fa == 0) goto L4fb201;
    /* 0x4fb1d8 */
    ecx = (uint32_t)((uint32_t)A0);
    /* 0x4fb1db */
    fa = ((uint32_t)((((uint32_t)ecx) & (0xffffu)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4fb1e1 */
    L8 = (uint32_t)((uint32_t)ecx);
    /* 0x4fb1e2 */
    L12 = (uint32_t)(0x560720u);
    /* 0x4fb1e7 */
    L16 = (uint32_t)(0x63888bu);
    /* 0x4fb1ec */
    eax = (uintptr_t)call3(host, 0x50ca3e, 0, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4fb1f1 */
    /* 0x4fb1f4 */
    L8 = (uint32_t)(0x63888bu);
    /* 0x4fb1f9 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4fb1fe */
L4fb201:;
    /* 0x4fb201 */
    edx = (uint32_t)((uint32_t)A0);
    /* 0x4fb204 */
    fa = ((uint32_t)((((uint32_t)edx) & (0xffffu)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4fb20a */
    L8 = (uint32_t)((uint32_t)edx);
    /* 0x4fb20b */
    ecx = (uint32_t)(0x5cf1ebu);
    /* 0x4fb210 */
    eax = (uintptr_t)call1(host, 0x4f6334, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4fb215 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4fb217 */
    if (fa == 0) goto L4fb2a0;
    /* 0x4fb21d */
    eax = (uint32_t)((uint32_t)(int32_t)(int16_t)((uint32_t)world->word_63a4cd));
    /* 0x4fb224 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4fb226 */
    if (fa == 0) goto L4fb251;
    /* 0x4fb228 */
    ecx = (uint32_t)((uint32_t)A0);
    /* 0x4fb22b */
    fa = ((uint32_t)((((uint32_t)ecx) & (0xffffu)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4fb231 */
    L8 = (uint32_t)((uint32_t)ecx);
    /* 0x4fb232 */
    L12 = (uint32_t)(0x56075cu);
    /* 0x4fb237 */
    L16 = (uint32_t)(0x63888bu);
    /* 0x4fb23c */
    eax = (uintptr_t)call3(host, 0x50ca3e, 0, (uintptr_t)(uint32_t)L16, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4fb241 */
    /* 0x4fb244 */
    L8 = (uint32_t)(0x63888bu);
    /* 0x4fb249 */
    eax = (uintptr_t)call1(host, 0x44a2b7, 0, (uintptr_t)(uint32_t)L8);
    /* 0x4fb24e */
L4fb251:;
    /* 0x4fb251 */
    edx = (uint32_t)((uint32_t)A0);
    /* 0x4fb254 */
    fa = ((uint32_t)((((uint32_t)edx) & (0xffffu)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4fb25a */
    edx = (uint32_t)((uint32_t)((uint32_t)((uint32_t)edx) * (uint32_t)(0x5bbu)));
    /* 0x4fb260 */
    eax = L4;
    /* 0x4fb263 */
    wr32(self, 300 + (ptrdiff_t)(int32_t)((uint32_t)edx), (uint32_t)(0x1u));
    /* 0x4fb26e */
    L8 = (uint32_t)(0x0u);
    /* 0x4fb270 */
    ecx = (uint32_t)((uint32_t)A0);
    /* 0x4fb273 */
    fa = ((uint32_t)((((uint32_t)ecx) & (0xffffu)))) & 0xffffffffu;
    ecx = (uint32_t)(fa);
    /* 0x4fb279 */
    L12 = (uint32_t)((uint32_t)ecx);
    /* 0x4fb27a */
    ecx = (uint32_t)(0x5cf1ebu);
    /* 0x4fb27f */
    eax = (uintptr_t)call2(host, 0x4f646c, (uintptr_t)(uint32_t)ecx, (uintptr_t)(uint32_t)L12, (uintptr_t)(uint32_t)L8);
    /* 0x4fb284 */
    edx = (uint32_t)((uint32_t)A0);
    /* 0x4fb287 */
    fa = ((uint32_t)((((uint32_t)edx) & (0xffffu)))) & 0xffffffffu;
    edx = (uint32_t)(fa);
    /* 0x4fb28d */
    edx = (uint32_t)((uint32_t)((uint32_t)((uint32_t)edx) * (uint32_t)(0x5bbu)));
    /* 0x4fb293 */
    eax = L4;
    /* 0x4fb296 */
    wr16(self, 306 + (ptrdiff_t)(int32_t)((uint32_t)edx), (uint16_t)(0x2u));
L4fb2a0:;
    /* 0x4fb2a0 */
    /* 0x4fb2a2 */
    /* 0x4fb2a3 */
    return 0;
}

/* ---- 0x4fb737 lifted ---- */
/* 0x4fb737, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Calls (in code order): 0x4fc808(this, 1 arg). eax is left-over and not meaningful. */
uint32_t m4fb737_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uintptr_t L12 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)L12;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    (void)world;
    /* 0x4fb73a */
    /* 0x4fb73d */
    L8 = ecx;
    /* 0x4fb740 */
    L4 = (uint32_t)((0x0u) & 0xffffu);
    /* 0x4fb746 */
    goto L4fb754;
L4fb748:;
    /* 0x4fb748 */
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | (((((uint32_t)L4 & 0xffffu)) & 0xffffu) << 0));
    /* 0x4fb74c */
    fa = ((uint32_t)(((((uint32_t)eax & 0xffffu)) + (0x1u)) & 0xffffu)) & 0xffffu;
    eax = (uint32_t)(((uint32_t)eax & 0xffff0000u) | (((fa) & 0xffffu) << 0));
    /* 0x4fb750 */
    L4 = (uint32_t)((((uint32_t)eax & 0xffffu)) & 0xffffu);
L4fb754:;
    /* 0x4fb754 */
    ecx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4fb758 */
    fa = (uint32_t)ecx;
    fb = 0x3u;
    /* 0x4fb75b */
    if ((int32_t)fa >= (int32_t)fb) goto L4fb776;
    /* 0x4fb75d */
    edx = (uint32_t)((uint32_t)(int32_t)(int16_t)(((uint32_t)L4 & 0xffffu)));
    /* 0x4fb761 */
    edx = (uint32_t)((uint32_t)((uint32_t)((uint32_t)edx) * (uint32_t)(0x2fu)));
    /* 0x4fb764 */
    eax = (uint32_t)(((uint32_t)rd16(world->table_583381, (ptrdiff_t)(int32_t)((uint32_t)edx + 0u))) & 0xffffu);
    /* 0x4fb76b */
    L12 = (uint32_t)(uint32_t)eax;
    /* 0x4fb76c */
    ecx = L8;
    /* 0x4fb76f */
    eax = (uintptr_t)call1(host, 0x4fc808, ecx, (uintptr_t)(uint32_t)L12);
    /* 0x4fb774 */
    goto L4fb748;
L4fb776:;
    /* 0x4fb776 */
    /* 0x4fb778 */
    /* 0x4fb779 */
    return 0;
}

/* ---- 0x4fba86 lifted ---- */
/* 0x4fba86, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 host pointer (read through). Reads [a0+0x21]/2. Calls (in code order): 0x4fb2e3(this, 1 arg), 0x4fb77a(this, 1 arg). Returns eax. */
uint32_t m4fba86_lifted(uint8_t *self, uint8_t *a0, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    (void)host;
    (void)A0;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    /* 0x4fba89 */
    L4 = ecx;
    /* 0x4fba8a */
    L4 = ecx;
    /* 0x4fba8d */
    eax = A0;
    /* 0x4fba90 */
    L8 = eax;
    /* 0x4fba91 */
    ecx = L4;
    /* 0x4fba94 */
    eax = (uintptr_t)call1(host, 0x4fb77a, ecx, L8);
    /* 0x4fba99 */
    ecx = A0;
    /* 0x4fba9c */
    edx = (uint32_t)(((uint32_t)rd16(a0, 33)) & 0xffffu);
    /* 0x4fbaa0 */
    L8 = (uint32_t)(uint32_t)edx;
    /* 0x4fbaa1 */
    ecx = L4;
    /* 0x4fbaa4 */
    eax = (uintptr_t)call1(host, 0x4fb2e3, ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4fbaa9 */
    /* 0x4fbaab */
    /* 0x4fbaac */
    return (uint32_t)eax;
}

/* ---- 0x4fbd7e lifted ---- */
/* 0x4fbd7e, this = ecx (self), plain `ret`, lifted mechanically from the instruction stream; not original source structure. Globals: 0x5b00d9/2. Calls (in code order): 0x4fc808(this, 1 arg). Returns eax. */
uint32_t m4fbd7e_lifted(uint8_t *self, const Fl18Host *host, Fl39dWorld *world)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    (void)host;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)world;
    /* 0x4fbd81 */
    L4 = ecx;
    /* 0x4fbd82 */
    L4 = ecx;
    /* 0x4fbd85 */
    eax = (uint32_t)(((uint32_t)world->word_5b00d9) & 0xffffu);
    /* 0x4fbd8b */
    L8 = (uint32_t)(uint32_t)eax;
    /* 0x4fbd8c */
    ecx = L4;
    /* 0x4fbd8f */
    eax = (uintptr_t)call1(host, 0x4fc808, ecx, (uintptr_t)(uint32_t)L8);
    /* 0x4fbd94 */
    /* 0x4fbd96 */
    /* 0x4fbd97 */
    return (uint32_t)eax;
}

/* ---- 0x4fce90 lifted ---- */
/* 0x4fce90, this = ecx (self), `ret 0x4`, lifted mechanically from the instruction stream; not original source structure. Stack arguments: a0 dword. Calls (in code order): 0x4fa9e7(this, 0 args), 0x51dc6c(1 arg). Returns this. */
uint8_t * m4fce90_lifted(uint8_t *self, uint32_t a0, const Fl18Host *host)
{
    uintptr_t eax = 0;
    uintptr_t ecx = (uintptr_t)self;
    uintptr_t edx = 0;
    uintptr_t A0 = (uintptr_t)a0;
    uintptr_t L4 = 0;
    uintptr_t L8 = 0;
    uint32_t fa = 0, fb = 0;
    (void)host;
    (void)A0;
    (void)L4;
    (void)L8;
    (void)eax;
    (void)ecx;
    (void)edx;
    (void)fa;
    (void)fb;
    /* 0x4fce93 */
    L4 = ecx;
    /* 0x4fce94 */
    L4 = ecx;
    /* 0x4fce97 */
    ecx = L4;
    /* 0x4fce9a */
    eax = (uintptr_t)call0(host, 0x4fa9e7, ecx);
    /* 0x4fce9f */
    eax = (uint32_t)((uint32_t)A0);
    /* 0x4fcea2 */
    fa = ((uint32_t)((((uint32_t)eax) & (0x1u)))) & 0xffffffffu;
    eax = (uint32_t)(fa);
    /* 0x4fcea5 */
    fa = ((uint32_t)eax) & ((uint32_t)eax);
    /* 0x4fcea7 */
    if (fa == 0) goto L4fceb5;
    /* 0x4fcea9 */
    ecx = L4;
    /* 0x4fceac */
    L8 = ecx;
    /* 0x4fcead */
    eax = (uintptr_t)call1(host, 0x51dc6c, 0, L8);
    /* 0x4fceb2 */
L4fceb5:;
    /* 0x4fceb5 */
    eax = L4;
    /* 0x4fceb8 */
    /* 0x4fceba */
    /* 0x4fcebb */
    return (uint8_t *)eax;
}
