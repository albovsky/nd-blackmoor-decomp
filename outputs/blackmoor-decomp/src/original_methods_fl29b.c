#include "original_methods_fl29b.h"

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

/* the host memory of an original address (NULL: not resolvable, the native rejection of the functions that follow an address) */
static uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return host->resolve != NULL ? (uint8_t *)host->resolve(host->context, address) : NULL;
}

/* `rep movsd` with ecx = dwords, then `rep movsb` with ecx = tail: forward, one element at a time (a source that overlaps the destination is read as it is written) */
static void rep_movs(uint8_t *dst, const uint8_t *src, uint32_t dwords, uint32_t tail)
{
    uint32_t i;
    for (i = 0; i < dwords; i++) {
        uint32_t v;
        memcpy(&v, src + 4 * (size_t)i, 4);
        memcpy(dst + 4 * (size_t)i, &v, 4);
    }
    dst += 4 * (size_t)dwords;
    src += 4 * (size_t)dwords;
    for (i = 0; i < tail; i++) dst[i] = src[i];
}

/* ---- 0x4ee69e ------------------------------------------------------------------------------------------------------------------ */

/* 0x4ee69e, thiscall: see the header. [ebp-4] is `self`. */
uint32_t m4ee69e_forward_if_set(const uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x252) != 0) return call0(host, 0x4ef516, (uintptr_t)(self + 0x4b7));
    return 0;
}

/* ---- 0x423aae ------------------------------------------------------------------------------------------------------------------ */

/* 0x423aae, thiscall, `ret 4`: see the header. [ebp+8] is `arg`, [ebp-4] the running link q. */
uint32_t m423aae_chain_end(uint32_t arg, const Fl18Host *host)
{
    uint32_t q;
    uint8_t *o;
    long steps = 0;
    if (arg == 0) return 0;
    o = object_at(host, arg);
    if (o == NULL) return 0;
    q = rd32(o, 4);
    if (q == 0) return 0;
    for (;;) {
        uint32_t next;
        o = object_at(host, q);
        if (o == NULL || ++steps > FL29B_CHAIN_LIMIT) return 0;      /* native rejection: the original faults or loops for ever */
        next = rd32(o, 0x38);
        if (next == 0) break;
        q = next;
    }
    return q;
}

/* ---- 0x4fccf2 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4fccf2, thiscall, `ret 8`: see the header. [ebp-4] is `self`; the integer [ebp-8] is the masked word, [ebp-0xc] the float that fild/fstp make of it. */
uint32_t m4fccf2_store_percent(uint8_t *self, uint32_t a, uint32_t index, const Fl29bWorld *world, const Fl18Host *host)
{
    float f, q;
    if ((int32_t)world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x5609d4);
    f = (float)(int32_t)(a & 0xffffu);
    q = (float)((double)f / (double)100.0f);     /* fld dword; fdiv dword [0x52cbec] (= 100.0f) in the 53-bit x87 mode, fstp dword */
    memcpy(self + (ptrdiff_t)(int32_t)(index * 4u) + 0xb764, &q, sizeof q);
    return call1(host, 0x4fcb5c, (uintptr_t)self, index);
}

/* ---- 0x423a30 ------------------------------------------------------------------------------------------------------------------ */

/* 0x423a30, thiscall, `ret 4`: see the header. [ebp+8] is `cell`, [ebp-4] the dword read from it. */
void m423a30_free_cell(uint8_t *cell, const Fl29bWorld *world, const Fl18Host *host)
{
    if (rd32(cell, 0) == 0) {
        call2(host, 0x50ca3e, 0, 0x63888b, 0x544820);
        call3(host, 0x52139c, 0, 0x63888b, 0, 0);
        if ((int32_t)world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return;
    }
    {
        uint32_t p = rd32(cell, 0);
        call1(host, 0x51dc6c, 0, p);
        wr32(cell, 0, 0);
    }
}

/* ---- 0x42e72c ------------------------------------------------------------------------------------------------------------------ */

/* 0x42e72c, cdecl: see the header. [ebp-4] is the mode (the sign-extended word 0x5b4e04). */
void m42e72c_toggle_state(Fl29bWorld *world, const Fl18Host *host)
{
    if (world->value_5d03bf == 0) {
        if ((int32_t)world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x545aac);
        return;
    }
    call1(host, 0x44c479, 0, 0x5b4c3a);
    if ((int32_t)world->word_5b4dc8 != 0) world->word_5b4dc8 = 0;
    else world->word_5b4dc8 = 1;
    if ((int32_t)world->word_5b4e04 == 2) {
        uint32_t v = (int32_t)world->word_5b4dc8 == 0 ? world->value_5b4db8 : world->value_5b4dbc;     /* [eax*4 + 0x5b4db8], eax = sign-extended 0/1 */
        uint8_t *dest = object_at(host, world->value_5d03bf);
        if (dest != NULL) wr32(dest, 0, v);          /* native rejection: an unresolvable destination is not written */
    }
    call1(host, 0x44c4ab, 0, 0x5b4c3a);
}

/* ---- 0x4e9c2f ------------------------------------------------------------------------------------------------------------------ */

/* 0x4e9c2f, thiscall, `ret 0xc`: see the header. [ebp+8] = out, [ebp+0xc] = src, [ebp+0x10] = adv; [ebp-4] the allocation. */
void m4e9c2f_copy_six(uint8_t *out, uint8_t *src, uint8_t *adv, const Fl29bWorld *world, const Fl18Host *host)
{
    uint32_t p = call1(host, 0x51dc43, 0, 6);
    uint8_t *s, *d;
    uint32_t lo;
    uint16_t hi;
    wr32(out, 0, p);
    if (p == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x55c934, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x55c960, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
    }
    s = object_at(host, rd32(src, 0));
    d = object_at(host, rd32(out, 0));            /* re-read: the report may have changed the cell */
    if (s == NULL || d == NULL) return;           /* native rejection */
    lo = rd32(s, 0);
    wr32(d, 0, lo);
    hi = rd16(s, 4);                              /* read after the dword store, as in the original */
    wr16(d, 4, hi);
    wr32(adv, 0, rd32(adv, 0) + 6);
    wr32(src, 0, rd32(src, 0) + 6);
    if ((int32_t)world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x55c97c);
}

/* ---- 0x4e45be ------------------------------------------------------------------------------------------------------------------ */

/* 0x4e45be, thiscall, `ret 0x10`: see the header. [ebp+0x14] = len (a word), [ebp-8] the row i, [ebp-4] the column j, [ebp-0xc] the "different" flag. */
uint32_t m4e45be_find_row(uint8_t *out, const uint8_t *bytes, uint32_t len, const Fl29bWorld *world)
{
    int16_t i, j;
    int different = 0;
    if ((int16_t)(len & 0xffffu) == 0) return 0;
    wr16(out, 0, 0);
    for (i = 0; (int32_t)i < (int32_t)world->word_5a1e5c; i = (int16_t)(i + 1)) {
        different = 0;
        for (j = 0; (int32_t)j < (int32_t)(int16_t)(len & 0xffffu); j = (int16_t)(j + 1)) {
            uint8_t a = world->table_5a1e64[(ptrdiff_t)(int32_t)((uint32_t)(int32_t)i * 0x29u) + (int32_t)j];
            uint8_t b = bytes[(int32_t)j];
            if (a != b) {
                different = 1;
                break;
            }
        }
        if (different == 0) {
            wr16(out, 0, (uint16_t)i);
            break;
        }
    }
    if ((int32_t)world->word_5a1e5c <= 0) return 0;      /* native rejection: the original returns sete of an uninitialised local */
    return different == 0 ? 1u : 0u;
}

/* ---- 0x437dcd ------------------------------------------------------------------------------------------------------------------ */

/* 0x437dcd, thiscall, `ret 0xc`: see the header. [ebp+8] is `p`, [ebp-4] `self`. */
void m437dcd_note_key(const uint8_t *self, const uint8_t *p, Fl29bWorld *world, const Fl18Host *host)
{
    if (world->value_5e32c9 != 0 && world->value_5e32de == 0) {
        if (call1(host, 0x437ea1, (uintptr_t)self, p[0]) != 0 && (int8_t)p[0] != 0x2f && (int8_t)p[0] != 0x3f && (int8_t)p[0] != 0x3a) {
            world->byte_5e32dd = p[0];
            world->value_5e32de = 1;
        }
    }
    if (world->byte_5b61af != 0 && world->byte_5b616b == 0) {
        if (call1(host, 0x437ea1, (uintptr_t)self, p[0]) != 0) {
            world->byte_5b616c = p[0];
            world->byte_5b616b = 1;
        }
    }
    call1(host, 0x4a1f59, 0x61d2dd, (uint32_t)(int32_t)(int8_t)p[0]);
    call1(host, 0x48e93e, 0x624dc9, (uint32_t)(int32_t)(int8_t)p[0]);
    call1(host, 0x4b8193, 0x61ee6e, (uint32_t)(int32_t)(int8_t)p[0]);
}

/* ---- 0x4e4337 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4e4337, thiscall, `ret 8`: see the header. [ebp-0xc] is `self`, [ebp+8] the advancing source, [ebp-8] the running total, [ebp-4] the word n. */
void m4e4337_load_blocks(uint8_t *self, const uint8_t *src, uint32_t limit, const Fl18Host *host)
{
    int32_t total = 0;
    int32_t n;
    rep_movs(self + 0x6d2, src, 0xbc, 0);
    src += 0x2f0;
    total += 0x2f0;
    rep_movs(self + 0x9c2, src, 0x2ac, 1);
    src += 0xab1;
    total += 0xab1;
    n = (int16_t)(uint16_t)((uint32_t)rds16(self, 0x1471) * 0x29u);      /* imul edx, edx, 0x29; mov [ebp-4], dx; movsx ecx, word [ebp-4] */
    if (n < 0) return;                                                   /* native rejection */
    rep_movs(self + 0x457b, src, (uint32_t)n >> 2, (uint32_t)n & 3u);
    total += n;
    if (total > (int32_t)limit) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x55c0c0, (uint32_t)total, limit);
        call1(host, 0x4264e8, 0x583979, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
    }
}

/* ---- 0x411a22 ------------------------------------------------------------------------------------------------------------------ */

/* 0x411a22, thiscall, `ret 0xc`: see the header. [ebp-4] is the length (0x27 on both arms of the compare), [ebp-0xc] the allocation. */
void m411a22_alloc_copy(uint8_t *dst, uint8_t *src, uint8_t *adv, const Fl29bWorld *world, const Fl18Host *host)
{
    uint8_t *so, *s, *d;
    uint32_t p;
    int32_t len;
    so = object_at(host, rd32(src, 0));
    if (so == NULL) return;                       /* native rejection: the original reads the word at [*src + 0x23] */
    if (rds16(so, 0x23) >= 0xa) len = 0x27;
    else len = 0x27;
    p = call1(host, 0x51dc43, 0, (uint32_t)len);
    wr32(world->records_5bb5e5, (ptrdiff_t)(int32_t)((uint32_t)(int32_t)world->word_5c39e3 * 0x8du), p);
    if (p == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x541404, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x541430, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
    }
    s = object_at(host, rd32(src, 0));
    d = object_at(host, rd32(dst, 0));
    if (s == NULL || d == NULL) return;           /* native rejection */
    rep_movs(d, s, (uint32_t)len >> 2, (uint32_t)len & 3u);
    wr32(adv, 0, rd32(adv, 0) + (uint32_t)len);
    wr32(src, 0, rd32(src, 0) + (uint32_t)len);
    if ((int32_t)world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x54144c);
}
