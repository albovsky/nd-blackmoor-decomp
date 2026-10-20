#include "original_methods_fl30b.h"

#include <string.h>

static __attribute__((unused)) uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static __attribute__((unused)) uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static __attribute__((unused)) int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

static __attribute__((unused)) void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

static __attribute__((unused)) void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* host memory behind an original address (writable: the host owns the memory; the interface only says const) */
static __attribute__((unused)) uint8_t *res(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

static __attribute__((unused)) uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

static __attribute__((unused)) uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

static __attribute__((unused)) uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

static __attribute__((unused)) uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    const uintptr_t a[2] = {a0, a1};
    return callv(host, callee, this_ptr, a, 2);
}

static __attribute__((unused)) uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    const uintptr_t a[3] = {a0, a1, a2};
    return callv(host, callee, this_ptr, a, 3);
}

static __attribute__((unused)) uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3)
{
    const uintptr_t a[4] = {a0, a1, a2, a3};
    return callv(host, callee, this_ptr, a, 4);
}

static __attribute__((unused)) uint32_t call5(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3, uintptr_t a4)
{
    const uintptr_t a[5] = {a0, a1, a2, a3, a4};
    return callv(host, callee, this_ptr, a, 5);
}

/* ---- 0x44b26a apply_delta -------------------------------------------------------------------------------------------------------- */
void m44b26a_apply_delta(uint32_t index, const Fl30bWorld *world, const Fl18Host *host)
{
    const uint8_t *item = res(host, rd32(world->records_5bb5e5, (ptrdiff_t)(int16_t)index * 0x8d));
    uint8_t kind = item[0];
    if (kind > 0x27) {      /* the original's `jl` after the zero-extended byte is never taken; only the compare with 0x27 decides */
        if (world->word_63a4cd != 0) {
            call3(host, 0x50ca3e, 0, 0x63888b, 0x549028, kind);
            call3(host, 0x52139c, 0, 0x63888b, 0, 0);
        }
    } else if (kind <= 0x1d) {
        uint8_t *word = world->words_58c959 + (ptrdiff_t)kind * 2;
        if (item[1] != 0 || rds16(word, 0) == 0x270f) wr16(word, 0, rd16(item, 2));
        else wr16(word, 0, (uint16_t)(rd16(word, 0) + rd16(item, 2)));
    } else {
        uint8_t *cell = world->floats_58c91d + (ptrdiff_t)kind * 4;
        float old, add, sum;
        int32_t delta = rds16(item, 2);
        memcpy(&old, cell, sizeof old);
        /* fcomp against 9999.0f: equal or unordered (C3 set) takes the plain store */
        if (item[1] == 0 && old != 9999.0f && old == old) {
            add = (float)delta;
            sum = (float)((double)add + (double)old);     /* x87 fadd at 53-bit precision, stored as a float */
            memcpy(cell, &sum, sizeof sum);
        } else {
            add = (float)delta;
            memcpy(cell, &add, sizeof add);
        }
    }
    call1(host, 0x42ba3a, 0, (uint16_t)index);
}

/* ---- 0x488e9c init_record -------------------------------------------------------------------------------------------------------- */
/* rep movsd (count / 4 dwords) then rep movsb (count % 4 bytes), forward, as the original does it */
static void rep_copy(uint8_t *dst, const uint8_t *src, uint32_t count)
{
    uint32_t i;
    for (i = 0; i < count / 4; i++) memmove(dst + 4 * i, src + 4 * i, 4);
    for (i = 4 * (count / 4); i < count; i++) dst[i] = src[i];
}

int32_t m488e9c_init_record(uint8_t *self, uint32_t p0, uint32_t p1, uint32_t p2, const Fl30bWorld *world, const Fl18Host *host)
{
    uint32_t buf;
    uint8_t *b;
    int16_t n, m;
    uint32_t bytes;
    buf = call1(host, 0x51dc43, 0, 0xaba);
    wr32(res(host, p0), 0, buf);
    if (buf == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x54df58, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x54df84, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;          /* the original goes on and stores through the null pointer */
    }
    wr32(self, 0x1c, rd32(res(host, p0), 0));
    wr32(self, 0x20, rd32(self, 0x1c));
    b = res(host, rd32(self, 0x20));
    rep_copy(b, res(host, rd32(res(host, p1), 0)), 0xac);
    wr32(res(host, p1), 0, rd32(res(host, p1), 0) + 0xac);
    wr32(res(host, p2), 0, rd32(res(host, p2), 0) + 0xac);
    if (rds16(b, 0x29) == 2) n = (int16_t)(rds16(b, 0x35) - rds16(b, 0x33) + 1);
    else n = (int16_t)rd16(b, 0x2b);
    if (n < 0 || 0xacu + (uint32_t)n * 16u > 0xaba) return 1;      /* native rejection: the original copies 4 GB / overruns the buffer */
    bytes = (uint32_t)n * 16u;
    rep_copy(res(host, rd32(self, 0x1c)) + 0xac, res(host, rd32(res(host, p1), 0)), bytes);
    wr32(res(host, p1), 0, rd32(res(host, p1), 0) + (uint32_t)n * 16u);
    wr32(res(host, p2), 0, rd32(res(host, p2), 0) + (uint32_t)n * 16u);
    m = (int16_t)rd16(res(host, rd32(self, 0x20)), 0xaa);
    if (m < 0 || 0x6ecu + (uint32_t)m * 0x26u > 0xaba) return 1;   /* native rejection, as above */
    bytes = (uint32_t)m * 0x26u;
    rep_copy(res(host, rd32(self, 0x1c)) + 0x6ec, res(host, rd32(res(host, p1), 0)), bytes);
    wr32(res(host, p1), 0, rd32(res(host, p1), 0) + bytes);
    wr32(res(host, p2), 0, rd32(res(host, p2), 0) + bytes);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x54dfa0);
    return 0;
}

/* ---- 0x4c5b3a copy_keyed --------------------------------------------------------------------------------------------------------- */
int32_t m4c5b3a_copy_keyed(const uint8_t *self, uint32_t from, uint32_t to, uint32_t fr, uint32_t tr, uint32_t tag, const Fl30bWorld *world, const Fl18Host *host)
{
    const uint8_t *r1 = NULL, *r2 = NULL;
    uint32_t pitch_from, pitch_to, bpp, p, q;
    int32_t rows, bytes, i, j;
    if (world->word_63a4cd != 0) {
        uint32_t w1, h1, w2, h2;
        r1 = res(host, fr);
        r2 = res(host, tr);
        w1 = rd32(r1, 8) - rd32(r1, 0);
        h1 = rd32(r1, 0xc) - rd32(r1, 4);
        w2 = rd32(r2, 8) - rd32(r2, 0);
        h2 = rd32(r2, 0xc) - rd32(r2, 4);
        if (!(w1 == w2 && h1 == h2 && from != 0 && to != 0)) {
            uint8_t text[0x124];
            const uintptr_t a[11] = {(uintptr_t)text, 0x554be8, tag, rd32(r1, 0), rd32(r1, 4), rd32(r1, 8), rd32(r1, 0xc), rd32(r2, 0), rd32(r2, 4), rd32(r2, 8), rd32(r2, 0xc)};
            memset(text, 0, sizeof text);
            callv(host, 0x50ca3e, 0, a, 11);
            call3(host, 0x52139c, 0, (uintptr_t)text, 0, 0);
            call0(host, 0x4c97b4, (uintptr_t)self);
            return 0;
        }
    }
    if (from == 0 || to == 0) return 1;      /* native rejection: the original reads the descriptor at 0x2f */
    r1 = res(host, fr);
    r2 = res(host, tr);
    pitch_from = (uint32_t)rds16(res(host, from), 0x2f);
    pitch_to = (uint32_t)rds16(res(host, to), 0x2f);
    bpp = (uint32_t)(int32_t)world->word_639895;
    p = rd32(res(host, from), 0) + rd32(r1, 4) * pitch_from + rd32(r1, 0) * bpp;
    q = rd32(res(host, to), 0) + rd32(r2, 4) * pitch_to + rd32(r2, 0) * bpp;
    rows = (int32_t)(rd32(r1, 0xc) - rd32(r1, 4) + 1);
    bytes = (int32_t)((rd32(r1, 8) - rd32(r1, 0) + 1) * bpp);
    for (i = 0; i < rows; i++) {
        for (j = 0; j < bytes; j = (int32_t)((uint32_t)j + 2)) {
            uint16_t v = rd16(res(host, p + (uint32_t)j), 0);
            if (v != rd16(self, 0x38d0)) wr16(res(host, q + (uint32_t)j), 0, v);
        }
        p += pitch_from;
        q += pitch_to;
    }
    return 0;
}
