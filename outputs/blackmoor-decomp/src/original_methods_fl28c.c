#include "original_methods_fl28c.h"

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

__attribute__((unused)) static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    const uintptr_t a[3] = {a0, a1, a2};
    return callv(host, callee, this_ptr, a, 3);
}

__attribute__((unused)) static uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3)
{
    const uintptr_t a[4] = {a0, a1, a2, a3};
    return callv(host, callee, this_ptr, a, 4);
}

__attribute__((unused)) static uint32_t call6(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3, uintptr_t a4, uintptr_t a5)
{
    const uintptr_t a[6] = {a0, a1, a2, a3, a4, a5};
    return callv(host, callee, this_ptr, a, 6);
}

/* the object of an original address (an address that an object keeps), as host memory */
static uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

/* `movsx eax, word ptr [0x63a4cd]; test eax, eax`: the debug flag, read at every use */
static int debug_on(const Fl28cWorld *world)
{
    return world->word_63a4cd != 0;
}

/* a value pushed from a 32-bit register: only the low 32 bits go to the callee (a negative int32 must not be sign-extended to 64 bits) */
__attribute__((unused)) static uintptr_t u32(uint32_t v)
{
    return (uintptr_t)v;
}

/* ---- 0x4cf026 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4cf026, `ret 4`: see the header. [ebp-0xc] is `self`, [ebp-8] the index i, [ebp-4] the result for the failures (-1). */
int32_t m4cf026_find_record(uint8_t *self, uint32_t key, const Fl18Host *host)
{
    int32_t i;
    if (rd32(self, 0x222) == 0 || rd32(self, 0x226) == 0) return -1;
    for (i = 0; i < rds16(object_at(host, rd32(self, 0x222)), 0x23); i++) {
        uint32_t record = rd32(self, 0x226) + (uint32_t)i * 0x35u;
        if (call2(host, 0x516530, 0, key, record) == 0) return i;
    }
    return -1;
}

/* ---- 0x4cec6c ------------------------------------------------------------------------------------------------------------------ */

/* 0x4cec6c, plain `ret`: see the header. [ebp-8] is `self`, [ebp-4] the record. */
void m4cec6c_bump_counter(uint8_t *self, const Fl18Host *host)
{
    uint32_t record;
    if (rd32(self, 0x222) == 0 || rd32(self, 0x226) == 0 || rd32(self, 0x246) == 0xffffffffu) return;
    record = rd32(self, 0x226) + rd32(self, 0x246) * 0x35u;
    wr16(self, 0x1ca, (uint16_t)(rd16(self, 0x1ca) + 1u));
    if (rds16(self, 0x1ca) > rds16(object_at(host, record), 0x23)) wr16(self, 0x1ca, rd16(object_at(host, record), 0x23));
}

/* ---- 0x4cf1e4 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4cf1e4, `ret 8`: see the header. [ebp-8] is ecx (unused), [ebp-4] the allocation. */
int32_t m4cf1e4_alloc_clear(uint8_t *out, uint32_t size, const Fl28cWorld *world, const Fl18Host *host)
{
    uint32_t p = call1(host, 0x51dc43, 0, size);
    size_t i, n = size;
    uint8_t *d;
    wr32(out, 0, p);
    if (p == 0) {
        call2(host, 0x50ca3e, 0, 0x63888b, 0x559b94);
        call1(host, 0x4264e8, 0x583979, 0x63888b);
        if (debug_on(world)) call1(host, 0x44a2b7, 0, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 0;
    }
    if (n != 0) {
        d = object_at(host, rd32(out, 0));
        for (i = 0; i + 4 <= n; i += 4) wr32(d, (ptrdiff_t)i, 0);
        for (; i < n; i++) d[i] = 0;
    }
    return 1;
}

/* ---- 0x4ceb8c ------------------------------------------------------------------------------------------------------------------ */

/* 0x4ceb8c, plain `ret`: see the header. [ebp-8] is `self`, [ebp-4] the record. */
void m4ceb8c_load_rect(uint8_t *self, const Fl28cWorld *world, const Fl18Host *host)
{
    const uint8_t *rec;
    if (rd32(self, 0x222) == 0 || rd32(self, 0x22a) == 0 || rd32(self, 0x24a) == 0xffffffffu) return;
    rec = object_at(host, rd32(self, 0x22a) + rd32(self, 0x24a) * 0x22u);
    wr32(self, 0x1e6, rd32(rec, 6));
    wr32(self, 0x1ee, rd32(rec, 0xe));
    wr32(self, 0x1e2, rd32(rec, 2));
    wr32(self, 0x1ea, rd32(rec, 0xa));
    wr32(self, 0x1f6, rd32(rec, 0x16) + (uint32_t)world->origin_y_58318a);
    wr32(self, 0x1fe, rd32(rec, 0x1e) + (uint32_t)world->origin_y_58318a);
    wr32(self, 0x1f2, rd32(rec, 0x12) + (uint32_t)world->origin_x_583186);
    wr32(self, 0x1fa, rd32(rec, 0x1a) + (uint32_t)world->origin_x_583186);
}

/* ---- 0x4ccef1 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4ccef1, plain `ret`: see the header. [ebp-0xc] is `self`, [ebp-8] / [ebp-4] the player object read again, [ebp-0x10] the (unused) result of the virtual call. */
void m4ccef1_release_movie(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x1d6) != 0) {
        uint32_t obj;
        call1(host, 0x44c479, 0, (uintptr_t)(self + 4));
        wr32(self, 4, 2);
        call0(host, 0x449a94, rd32(self, 0x1d6));
        obj = rd32(self, 0x1d6);
        if (obj != 0) {
            uint32_t vtable = rd32(object_at(host, obj), 0);
            call1(host, rd32(object_at(host, vtable), 0), obj, 1);
        }
        wr32(self, 0x1d6, 0);
        call1(host, 0x44c4ab, 0, (uintptr_t)(self + 4));
        wr32(self, 4, 0);
    }
    call1(host, 0x415011, 0x5e2dbe, (uintptr_t)(self + 8));
    call1(host, 0x41632b, 0x5e2dbe, (uintptr_t)(self + 8));
    call1(host, 0x4bedfa, 0x6201f9, (uintptr_t)(self + 0x18e));
}

/* ---- 0x4ce8ea ------------------------------------------------------------------------------------------------------------------ */

/* the sequence both arms of 0x4ce8ea share: 0x4befc8, 0x4bf098, [self+0x232], [self+0x206] (the arm adds its own stores after it) */
static void scan_rect(uint8_t *self, const Fl18Host *host)
{
    const uint8_t *player;
    call1(host, 0x4befc8, 0x6201f9, rd32(self, 0x18e));
    player = object_at(host, rd32(self, 0x212));
    call6(host, 0x4bf098, 0x6201f9, rd32(self, 0x18e), rd32(player, 0), u32((uint32_t)rds16(player, 0x2f)), u32((uint32_t)rds16(player, 0x2d)), 0, 0);
    wr32(self, 0x232, call1(host, 0x4bee2c, 0x6201f9, rd32(self, 0x18e)) - 1u);
    wr32(self, 0x206, 1);
}

/* 0x4ce8ea, plain `ret`: see the header. [ebp-8] is `self`, [ebp-4] the record, [ebp-0xc] the state (the switch value). */
void m4ce8ea_scan_step(uint8_t *self, const Fl28cWorld *world, const Fl18Host *host)
{
    uint32_t rec = rd32(self, 0x226) + rd32(self, 0x246) * 0x35u;
    uint32_t state = rd32(self, 0x1da);
    uint32_t r;
    if (state == 0) {
        if (call1(host, 0x4bef85, 0x6201f9, rd32(self, 0x18e)) == 0) return;
        scan_rect(self, host);
        wr32(self, 0x20a, 1);
        call0(host, 0x4ceb8c, (uintptr_t)self);
        r = call1(host, 0x4bf10f, 0x6201f9, rd32(self, 0x18e));
        if (r != 0 && rd32(self, 0x232) != (uint32_t)rds16(object_at(host, rec), 0x23)) {
            wr32(self, 0x1da, 4);
            return;
        }
        wr32(self, 0x1de, 3);
        if (debug_on(world)) call1(host, 0x44a2b7, 0, 0x559a28);
    } else if (state == 4) {
        if (call1(host, 0x4bef85, 0x6201f9, rd32(self, 0x18e)) == 0) return;
        scan_rect(self, host);
        call0(host, 0x4ceb8c, (uintptr_t)self);
        r = call1(host, 0x4bf10f, 0x6201f9, rd32(self, 0x18e));
        if (r != 0 && rd32(self, 0x232) != (uint32_t)rds16(object_at(host, rec), 0x23)) return;
        wr32(self, 0x1de, 3);
        if (debug_on(world)) call1(host, 0x44a2b7, 0, 0x559aa8);
    }
}

/* ---- 0x4cd243 ------------------------------------------------------------------------------------------------------------------ */

/* `rep movsd` of n / 4 dwords, then `rep movsb` of n % 4 bytes, forward */
static void copy_forward(uint8_t *dst, const uint8_t *src, size_t n)
{
    size_t i;
    for (i = 0; i + 4 <= n; i += 4) wr32(dst, (ptrdiff_t)i, rd32(src, (ptrdiff_t)i));
    for (; i < n; i++) dst[i] = src[i];
}

/* the failure report shared by the four allocation failures of 0x4cd243 */
static void tables_fail(const Fl28cWorld *world, const Fl18Host *host, uint32_t text, uint32_t text2)
{
    call4(host, 0x50ca3e, 0, 0x63888b, text, world->value_5bb57b, u32((uint32_t)(int32_t)world->word_5c39e3));
    call2(host, 0x42639d, 0x583979, text2, 0x63888b);
    call0(host, 0x4c97b4, 0x5cf659);
}

/* 0x4cd243, `ret 0xc`: see the header. [ebp-0x14] is `self`, [ebp+8] / [ebp+0xc] / [ebp+0x10] are `dst` / `src` / `tail`, [ebp-8] the index, [ebp-0xc] the running offset c,
 * [ebp-0x10] the record, [ebp-4] the stream position s of the record. */
int32_t m4cd243_read_tables(uint8_t *self, uint8_t *dst, uint8_t *src, uint8_t *tail, const Fl28cWorld *world, const Fl18Host *host)
{
    int32_t i;
    uint32_t c, n, m;
    if (rd32(self, 0x216) != 0) {
        if (debug_on(world)) {
            call3(host, 0x50ca3e, 0, 0x63888b, 0x55907c, u32((uint32_t)(int32_t)world->word_5c39e3));
            call1(host, 0x44a2b7, 0, 0x63888b);
        }
        return 0;
    }
    wr32(self, 0x23e, (uint32_t)(int32_t)world->word_5c39e3);
    if (call2(host, 0x4cf1e4, (uintptr_t)self, (uintptr_t)dst, 0x27) == 0) {
        tables_fail(world, host, 0x5590f8, 0x559124);
        return 0;
    }
    copy_forward(object_at(host, rd32(dst, 0)), object_at(host, rd32(src, 0)), 0x27);
    wr32(tail, 0, rd32(tail, 0) + 0x27u);
    wr32(src, 0, rd32(src, 0) + 0x27u);
    wr32(self, 0x222, rd32(dst, 0));
    n = (uint32_t)(rds16(object_at(host, rd32(self, 0x222)), 0x23) * 0x35);
    if (call2(host, 0x4cf1e4, (uintptr_t)self, (uintptr_t)(self + 0x226), n) == 0) {
        tables_fail(world, host, 0x559140, 0x559184);
        return 0;
    }
    c = 0;
    for (i = 0; i < rds16(object_at(host, rd32(self, 0x222)), 0x23); i++) {
        uint32_t record = rd32(self, 0x226) + (uint32_t)i * 0x35u;
        uint32_t at = rd32(src, 0) + c;
        uint8_t *r = object_at(host, record);
        const uint8_t *s = object_at(host, at);
        copy_forward(r, s, 0x21);
        c += 0x21;
        wr16(r, 0x21, rd16(s, 0x21));
        c += 2;
        wr16(r, 0x23, rd16(s, 0x23));
        c += 2;
        wr32(r, 0x25, rd32(s, 0x25));
        c += 4;
        wr32(r, 0x29, rd32(s, 0x29));
        c += 4;
        wr16(r, 0x2d, rd16(s, 0x2d));
        c += 2;
        wr16(r, 0x2f, rd16(s, 0x2f));
        c += 2;
        m = (uint32_t)(rds16(r, 0x2f) * 0x23);
        if (call2(host, 0x4cf1e4, (uintptr_t)self, (uintptr_t)(r + 0x31), m) == 0) {
            tables_fail(world, host, 0x5591a0, 0x5591e4);
            return 0;
        }
        m = (uint32_t)(rds16(r, 0x2f) * 0x23);
        if ((int32_t)m < 0) return 0;      /* native rejection: the original copies about 4 GB */
        if (m != 0) copy_forward(object_at(host, rd32(r, 0x31)), object_at(host, rd32(src, 0) + c), m);
        c += (uint32_t)(rds16(r, 0x2f) * 0x23);
    }
    wr32(tail, 0, rd32(tail, 0) + c);
    wr32(src, 0, rd32(src, 0) + c);
    n = (uint32_t)(rds16(object_at(host, rd32(self, 0x222)), 0x25) * 0x22);
    if (call2(host, 0x4cf1e4, (uintptr_t)self, (uintptr_t)(self + 0x22a), n) == 0) {
        tables_fail(world, host, 0x559200, 0x559240);
        return 0;
    }
    n = (uint32_t)(rds16(object_at(host, rd32(self, 0x222)), 0x25) * 0x22);      /* the count of the copy is computed again after the call (0x4cd5b7..0x4cd5d7) */
    if ((int32_t)n < 0) return 0;          /* native rejection: the original copies about 4 GB */
    if (n != 0) copy_forward(object_at(host, rd32(self, 0x22a)), object_at(host, rd32(src, 0)), n);
    n = (uint32_t)(rds16(object_at(host, rd32(self, 0x222)), 0x25) * 0x22);
    wr32(tail, 0, rd32(tail, 0) + n);
    wr32(src, 0, rd32(src, 0) + n);
    if (debug_on(world)) {
        call0(host, 0x4cf276, (uintptr_t)self);
        call1(host, 0x44a2b7, 0, 0x55925c);
    }
    return 1;
}

/*SOURCE-INSERT*/
