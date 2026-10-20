#include "original_methods_fl29c.h"

#include <string.h>

static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    const uintptr_t a[2] = {a0, a1};
    return callv(host, callee, this_ptr, a, 2);
}

static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    const uintptr_t a[3] = {a0, a1, a2};
    return callv(host, callee, this_ptr, a, 3);
}

static uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3)
{
    const uintptr_t a[4] = {a0, a1, a2, a3};
    return callv(host, callee, this_ptr, a, 4);
}

/* the memory of an original address (an address that an object or a cell keeps), as host memory */
static uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return host->resolve != NULL ? (uint8_t *)host->resolve(host->context, address) : NULL;
}

/* ---- 0x4bf19a ------------------------------------------------------------------------------------------------------------------ */

/* 0x4bf19a, thiscall: see the header. [ebp-4] is `self`. */
uint32_t m4bf19a_bink_goto(uint8_t *self, const uint8_t *handle, uint32_t frame, const Fl18Host *host)
{
    call0(host, 0x4bf38c, (uintptr_t)self);
    if (handle == NULL) {
        wr32(self, 0x2c0, 0xfffffffdu);
        return 0;
    }
    if ((int32_t)frame < 1 || frame > rd32(handle, 8)) return 0;
    call3(host, 0x52a530, 0, (uintptr_t)handle, frame, 0);
    return 1;
}

/* ---- 0x434814 ------------------------------------------------------------------------------------------------------------------ */

/* 0x434814, thiscall: see the header. [ebp-4] is the word counter. */
uint32_t m434814_copy_name(const uint8_t *src, const Fl29cWorld *world)
{
    int16_t i;
    for (i = 0; (int32_t)i < 4; i = (int16_t)(i + 1)) {
        if ((int8_t)src[(int32_t)i] == 0) break;
        world->buf_63a590[(int32_t)i] = src[(int32_t)i];
    }
    world->buf_63a590[(int32_t)i] = 0;
    return 0x63a590;
}

/* ---- 0x4471ca ------------------------------------------------------------------------------------------------------------------ */

/* the common body of 0x4471ca, 0x45b4ae, 0x461903 and 0x4b5c5c (the same instructions with a different size, copy tail and constants): `ndwords` dwords copied forward, then a word when
 * `word`, then a byte when `byte` */
static void copy_record(uint8_t *a, uint8_t *b, uint8_t *c, const Fl29cWorld *world, const Fl18Host *host, uint32_t size, uint32_t ndwords, int word, int byte,
                        uint32_t fmt, uint32_t msg, uint32_t trace)
{
    uint32_t p, k;
    const uint8_t *src;
    uint8_t *dst;
    p = call1(host, 0x51dc43, 0, size);
    wr32(a, 0, p);
    if (p == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, fmt, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, msg, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
    }
    src = object_at(host, rd32(b, 0));
    dst = object_at(host, rd32(a, 0));
    if (src == NULL || dst == NULL) return;       /* native rejection: the original copies through the address 0 here */
    for (k = 0; k < ndwords; k++) wr32(dst, (ptrdiff_t)(4 * k), rd32(src, (ptrdiff_t)(4 * k)));
    if (word) wr16(dst, (ptrdiff_t)(4 * ndwords), rd16(src, (ptrdiff_t)(4 * ndwords)));
    if (byte) dst[4 * ndwords + (word ? 2 : 0)] = src[4 * ndwords + (word ? 2 : 0)];
    wr32(c, 0, rd32(c, 0) + size);
    wr32(b, 0, rd32(b, 0) + size);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, trace);
}

/* 0x4471ca: size 0x15 = 5 dwords + a byte. */
void m4471ca_copy_record15(uint8_t *a, uint8_t *b, uint8_t *c, const Fl29cWorld *world, const Fl18Host *host)
{
    copy_record(a, b, c, world, host, 0x15, 5, 0, 1, 0x548450, 0x54847c, 0x548498);
}

/* ---- 0x45b4ae ------------------------------------------------------------------------------------------------------------------ */

/* 0x45b4ae: size 0xb8e = 0x2e3 dwords + a word. */
void m45b4ae_copy_record_b8e(uint8_t *a, uint8_t *b, uint8_t *c, const Fl29cWorld *world, const Fl18Host *host)
{
    copy_record(a, b, c, world, host, 0xb8e, 0x2e3, 1, 0, 0x54aae4, 0x54ab10, 0x54ab2c);
}

/* ---- 0x461903 ------------------------------------------------------------------------------------------------------------------ */

/* 0x461903: size 0x357 = 0xd5 dwords + a word + a byte. */
void m461903_copy_record_357(uint8_t *a, uint8_t *b, uint8_t *c, const Fl29cWorld *world, const Fl18Host *host)
{
    copy_record(a, b, c, world, host, 0x357, 0xd5, 1, 1, 0x54b0dc, 0x54b108, 0x54b124);
}

/* ---- 0x4b5c5c ------------------------------------------------------------------------------------------------------------------ */

/* 0x4b5c5c: size 0x39f = 0xe7 dwords + a word + a byte. */
void m4b5c5c_copy_record_39f(uint8_t *a, uint8_t *b, uint8_t *c, const Fl29cWorld *world, const Fl18Host *host)
{
    copy_record(a, b, c, world, host, 0x39f, 0xe7, 1, 1, 0x551a9c, 0x551ac8, 0x551ae4);
}

/* ---- 0x45bbd8 ------------------------------------------------------------------------------------------------------------------ */

/* `and eax, mask` then, when the result is negative, `dec eax; or eax, low; inc eax`: the signed remainder by 2 (mask 0x80000001, low 0xfffffffe) or 4 (0x80000003, 0xfffffffc) of a
 * 32-bit value, kept as a word */
static int16_t signed_rem(uint32_t r, uint32_t mask, uint32_t low)
{
    uint32_t v = r & mask;
    if ((int32_t)v < 0) v = ((v - 1u) | low) + 1u;
    return (int16_t)v;
}

/* 0x45bbd8, thiscall: see the header. [ebp-0x18] is `self`, [ebp-0x14] the word count, [ebp-4] rec, [ebp-8] the word i, [ebp-0x10] / [ebp-0xc] the words w2 / w4. */
uint32_t m45bbd8_roll_rects(uint8_t *self, uint32_t arg, const Fl29cWorld *world, const Fl18Host *host)
{
    int16_t count = 0, i, w2, w4;
    uint32_t rec = rd32(world->records_5bb5e5, (ptrdiff_t)(int32_t)((uint32_t)rds16(self, 0x1e) * 0x8du));
    for (i = 0; (int32_t)i < 4; i = (int16_t)(i + 1)) {
        uint32_t src_va;
        const uint8_t *src;
        uint8_t *dst;
        int k;
        w2 = signed_rem(call0(host, 0x50cd50, 0), 0x80000001u, 0xfffffffeu);
        if ((int32_t)w2 == 1) count = (int16_t)(count + 1);
        w4 = signed_rem(call0(host, 0x50cd50, 0), 0x80000003u, 0xfffffffcu);
        src_va = rec + 0x36du + (uint32_t)((int32_t)w4 * 32) + (uint32_t)((int32_t)w2 * 16);
        dst = self + 0x36 + (ptrdiff_t)((int32_t)(int16_t)arg * 64) + (ptrdiff_t)((int32_t)i * 16);
        src = object_at(host, src_va);
        if (src == NULL) continue;                /* native rejection: the original reads through an unmapped address */
        for (k = 0; k < 4; k++) wr32(dst, 4 * k, rd32(src, 4 * k));
    }
    if ((int32_t)count == 0) count = 5;
    return (uint16_t)count;
}

/* ---- 0x4630a3 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4630a3, thiscall: see the header. [ebp-4] is `self`, [ebp-8] the switch index. */
void m4630a3_select_action(uint8_t *self, uint32_t arg, Fl29cWorld *world)
{
    int32_t a = (int16_t)arg;
    uint32_t index;
    if (a == 0x277f) {
        world->value_5b44f0 = 9;
        world->value_5b44f4 = 1;
        world->value_5d162d = world->value_5d0377;
        world->value_5d1631 = 0x5b160cu + (world->value_5b44f0 << 5) + (world->value_5b44f4 << 4);
        world->value_5d1639 = 1;
        world->value_5c39e5 = 0x277f;
        return;
    }
    if (rds16(self, 0x57) == 0) wr16(self, 0x57, (uint16_t)arg);
    index = (uint32_t)a - 0x2780u;
    if (index <= 3) {
        switch (index) {
        case 0: world->value_5b44f0 = 0x19; break;
        case 1: world->value_5b44f0 = 0x17; break;
        case 2: world->value_5b44f0 = 0x18; break;
        default: world->value_5b44f0 = 0x1a; break;
        }
    }
    world->value_5b44f4 = 1;
    world->value_5d162d = world->value_5d0377;
    world->value_5d1631 = 0x5b160cu + (world->value_5b44f0 << 5) + (world->value_5b44f4 << 4);
    world->value_5d1639 = 1;
    world->value_5c39e5 = (uint32_t)a;
}

/* ---- 0x43423d ------------------------------------------------------------------------------------------------------------------ */

/* the inlined strcmp of 0x43423d / 0x4344bf, byte pair by byte pair as the original reads them: 0 when the strings are equal, 1 (the sign is not used) otherwise */
static int pair_strcmp(const uint8_t *s, const uint8_t *name)
{
    for (;;) {
        uint8_t c0 = s[0], c1;
        if (c0 != name[0]) return 1;
        if (c0 == 0) return 0;
        c1 = s[1];
        if (c1 != name[1]) return 1;
        s += 2;
        name += 2;
        if (c1 == 0) return 0;
    }
}

/* `repne scasb` + `rep movsd` + `rep movsb`: the string with its terminator copied forward, the dwords first */
static void copy_string(uint8_t *dst, const uint8_t *s)
{
    uint32_t n = (uint32_t)strlen((const char *)s) + 1u, k;
    for (k = 0; k < (n >> 2); k++) wr32(dst, (ptrdiff_t)(4 * k), rd32(s, (ptrdiff_t)(4 * k)));
    for (k = 0; k < (n & 3u); k++) dst[4 * (n >> 2) + k] = s[4 * (n >> 2) + k];
}

/* 0x43423d, thiscall: see the header. [ebp-0x14] is `self`, [ebp-8] i, [ebp-0xc] p, [ebp-4] n, [ebp-0x10] s. */
uint32_t m43423d_find_name_a(uint8_t *self, const uint8_t *name, const Fl18Host *host)
{
    int32_t i;
    for (i = 0; i < (int32_t)rd32(self, 0x5f64); i++) {
        uint32_t p = rd32(self, 0x1144 + (ptrdiff_t)i * 4) + 4u;
        uint32_t n = call1(host, 0x4347b8, (uintptr_t)self, p);
        const uint8_t *s;
        if (n <= 8) {
            call2(host, 0x42639d, 0x583979, 0x545f04, 0x545ef8);
            call0(host, 0x4c97b4, 0x5cf659);
        }
        p += 4;
        s = object_at(host, call1(host, 0x434814, (uintptr_t)self, p));
        if (s == NULL) return 0;                  /* native rejection */
        if (pair_strcmp(s, name) == 0) {
            p += 4;
            wr32(self, 0x111c, p);
            wr32(self, 0x1128, n - 4u);
            copy_string(self + 0x1136, s);
            return 1;
        }
    }
    return 0;
}

/* ---- 0x4344bf ------------------------------------------------------------------------------------------------------------------ */

/* 0x4344bf, thiscall: see the header. [ebp-0x10] is `self`, [ebp-8] i, [ebp-4] p, [ebp-0xc] s. */
uint32_t m4344bf_find_name_b(uint8_t *self, const uint8_t *name, const Fl18Host *host)
{
    int32_t i;
    for (i = 0; i < 0x3e8; i++) wr32(self, 0x4fc4 + (ptrdiff_t)i * 4, 0);
    for (i = 0; i < (int32_t)rd32(self, 0x5f68); i++) {
        uint32_t p = rd32(self, 0x20e4 + (ptrdiff_t)i * 4);
        const uint8_t *s = object_at(host, call1(host, 0x434814, (uintptr_t)self, p));
        if (s == NULL) return 0;                  /* native rejection */
        if (pair_strcmp(s, name) == 0 && rd32(self, 0x4fc4 + (ptrdiff_t)i * 4) != 1) {
            wr32(self, 0x4fc4 + (ptrdiff_t)i * 4, 1);
            p += 4;
            wr32(self, 0x112c, call1(host, 0x4347b8, (uintptr_t)self, p));
            p += 4;
            wr32(self, 0x1120, p);
            copy_string(self + 0x1130, s);
            return 1;
        }
    }
    return 0;
}
