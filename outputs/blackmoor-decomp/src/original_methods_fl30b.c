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

/* ---- 0x42e844 step_record -------------------------------------------------------------------------------------------------------- */
void m42e844_step_record(uint32_t index, Fl30bWorld *world, const Fl18Host *host)
{
    uint8_t *r = world->records_5bb5e5 + (ptrdiff_t)(int16_t)index * 0x8d;
    uint32_t state = rd32(r, 0x4d);
    if (state == 0 || state == 1) {
        uint16_t i;
        if (state == 0) {
            world->value_5bb1ca = 1;
            wr32(r, 0x4d, 1);
        }
        wr32(r, 0x41, 0);
        for (i = 0; (int16_t)i < (int16_t)rd16(res(host, rd32(r, 0)), 0x28); i++) {
            const uint8_t *e = res(host, rd32(r, 0)) + (ptrdiff_t)(int16_t)i * 0x12;
            if (rds16(e, 0x2a) != (int32_t)world->word_5bb50b) continue;
            wr32(r, 0x41, 1);
            wr16(r, 0x45, rd16(e, 0x2c));
            wr16(r, 0x47, rd16(e, 0x30));
            wr16(r, 0x49, rd16(e, 0x34));
            wr16(r, 0x4b, rd16(e, 0x38));
            return;
        }
        return;
    }
    if (state == 2) {
        int k;
        r[0x40] = 1;
        wr32(r, 0x41, 0);
        for (k = 0; k < 10; k++) {
            const uint8_t *p = res(host, rd32(r, 0));
            int32_t a = rds16(p, k * 4);
            if (a != -1) wr32(world->dwords_585801, (ptrdiff_t)a * 4, (uint32_t)rds16(res(host, rd32(r, 0)), k * 4 + 2));
        }
        call1(host, 0x42ba3a, 0, (uint16_t)index);
    }
}

/* ---- 0x411f24 replace_record ----------------------------------------------------------------------------------------------------- */
static size_t c_strlen(const uint8_t *s)
{
    size_t n = 0;
    while (s[n] != 0) n++;
    return n;
}

int32_t m411f24_replace_record(uint8_t *self, uint32_t index, const Fl30bWorld *world, const Fl18Host *host)
{
    uint8_t *rec = world->records_5bb5e5 + (ptrdiff_t)(int16_t)index * 0x8d;
    uint32_t p = rd32(rec, 0), q = p + 0xe7, buf, buf2, value;
    uint8_t num[8];
    uint8_t *b;
    size_t n, at;
    call4(host, 0x413187, (uintptr_t)self, p, p + 0x12d, 0, 0);
    call1(host, 0x42ba3a, 0, (uint16_t)index);
    buf = call1(host, 0x51dc43, 0, 0xaba);
    if (buf == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x541564, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x5415ac, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;          /* the original goes on and stores through the null pointer */
    }
    b = res(host, buf);
    memset(b, 0, 0xaba);
    call2(host, 0x48945b, 0x619935, buf, q + 2);
    n = c_strlen(res(host, 0x5415c8)) + 1;
    rep_copy(b, res(host, 0x5415c8), (uint32_t)n);
    value = (uint32_t)(rds16(res(host, p), 2) + 1);
    memset(num, 0, sizeof num);
    call3(host, 0x5193ca, 0, value, (uintptr_t)num, 10);
    if (memchr(num, 0, sizeof num) == NULL) return 1;      /* native rejection: the original overwrites the local behind num */
    at = c_strlen(b);
    rep_copy(b + at, num, (uint32_t)c_strlen(num) + 1);
    wr16(b, 0x23, rd16(res(host, p), 0));
    wr16(b, 0x27, rd16(res(host, q), 0));
    memcpy(b + 0xac, res(host, q + 0x12), 16);
    call1(host, 0x51dc6c, 0, rd32(rec, 0));
    wr32(rec, 0, 0);
    buf2 = call1(host, 0x51dc43, 0, 0xaba);
    wr32(rec, 0, buf2);
    if (buf2 == 0) {
        call4(host, 0x50ca3e, 0, 0x63888b, 0x5415d8, world->value_5bb57b, (uint32_t)(int32_t)world->word_5c39e3);
        call2(host, 0x42639d, 0x583979, 0x54161c, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;          /* the original goes on and stores through the null pointer */
    }
    memcpy(res(host, rd32(rec, 0)), b, 0xaba);
    rec[0x40] = 0;
    rec[-2] = 0x36;
    rec[-1] = 1;
    wr32(rec, 0x4d, 0);
    call1(host, 0x51dc6c, 0, buf);
    return 0;
}

/* ---- 0x4cbba9 load_file ---------------------------------------------------------------------------------------------------------- */
static int read4cbba9(const Fl18Host *host, uint32_t dst, uint32_t size, uint32_t file)
{
    return call4(host, 0x50cf61, 0, dst, size, 1, file) == 1;
}

void m4cbba9_load_file(uint8_t *self, uint32_t path, const Fl30bWorld *world, const Fl18Host *host)
{
    if (rd32(self, 0x1a) != 0) call0(host, 0x4cbb00, (uintptr_t)self);
    if (c_strlen(res(host, path)) == 0) {
        call3(host, 0x50ca3e, 0, 0x63888b, 0x558c48, path);
        goto failure;
    }
    if (world->value_5bb1fa != 0) call5(host, 0x50cd72, 0, (uintptr_t)(self + 0x1e), 0x639da2, 0x639db1, path, 0x558c98);
    else call5(host, 0x50cd72, 0, (uintptr_t)(self + 0x1e), 0x639dae, 0x639db1, path, 0x558c9c);
    wr32(self, 0x12a, 0);
    wr32(self, 0x12a, call2(host, 0x50d0a9, 0, (uintptr_t)(self + 0x1e), 0x558ca0));
    if (rd32(self, 0x12a) == 0) {
        call3(host, 0x50ca3e, 0, 0x63888b, 0x558ca4, (uintptr_t)(self + 0x1e));
        goto failure;
    }
    call2(host, 0x4cc70f, (uintptr_t)self, (uintptr_t)(self + 0x1a), 0x29);
    if (!read4cbba9(host, rd32(self, 0x1a), 0x21, rd32(self, 0x12a)) || !read4cbba9(host, rd32(self, 0x1a) + 0x21, 4, rd32(self, 0x12a))) {
        call3(host, 0x50ca3e, 0, 0x63888b, 0x558cf4, (uintptr_t)(self + 0x1e));
        goto failure;
    }
    call2(host, 0x4cc70f, (uintptr_t)self, rd32(self, 0x1a) + 0x25, rd32(res(host, rd32(self, 0x1a)), 0x21) * 0xdu);
    wr32(self, 0x12e, 0);
    for (;; wr32(self, 0x12e, rd32(self, 0x12e) + 1)) {
        uint32_t e;
        int32_t m;
        if ((int32_t)rd32(self, 0x12e) >= (int32_t)rd32(res(host, rd32(self, 0x1a)), 0x21)) break;
        e = rd32(res(host, rd32(self, 0x1a)), 0x25) + rd32(self, 0x12e) * 0xdu;
        wr32(self, 0x122, e);
        if (!(read4cbba9(host, rd32(self, 0x122), 2, rd32(self, 0x12a)) && read4cbba9(host, rd32(self, 0x122) + 2, 2, rd32(self, 0x12a)) &&
              read4cbba9(host, rd32(self, 0x122) + 4, 1, rd32(self, 0x12a)) && read4cbba9(host, rd32(self, 0x122) + 5, 2, rd32(self, 0x12a)) &&
              read4cbba9(host, rd32(self, 0x122) + 7, 2, rd32(self, 0x12a)))) {
            call4(host, 0x50ca3e, 0, 0x63888b, 0x558d64, rd32(self, 0x12e), (uintptr_t)(self + 0x1e));
            goto failure;
        }
        m = rds16(res(host, rd32(self, 0x122)), 2);
        call2(host, 0x4cc70f, (uintptr_t)self, rd32(self, 0x122) + 9, (uint32_t)m * 0x18u);
        if (!read4cbba9(host, rd32(res(host, rd32(self, 0x122)), 9), (uint32_t)rds16(res(host, rd32(self, 0x122)), 2) * 0x18u, rd32(self, 0x12a))) {
            call4(host, 0x50ca3e, 0, 0x63888b, 0x558dc8, rd32(self, 0x12e), (uintptr_t)(self + 0x1e));
            goto failure;
        }
    }
    call1(host, 0x50cee4, 0, rd32(self, 0x12a));
    return;
failure:
    call1(host, 0x4264e8, 0x583979, 0x63888b);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x63888b);
    if (rd32(self, 0x12a) != 0) call1(host, 0x50cee4, 0, rd32(self, 0x12a));
    call0(host, 0x4c97b4, 0x5cf659);
}

/* ---- 0x4d214b lookup_word -------------------------------------------------------------------------------------------------------- */
int32_t m4d214b_lookup_word(uint32_t ch, uint32_t obj, uint32_t out, const Fl18Host *host)
{
    int32_t off;
    switch ((int8_t)(ch & 0xff)) {
    case -128: off = 0xc1; break;
    case -95: off = 0x9b; break;
    case -65: off = 0x9d; break;
    case -64: off = 0x87; break;
    case -60: off = 0x8f; break;
    case -59: off = 0xb1; break;
    case -55: off = 0xa3; break;
    case -47: off = 0x9f; break;
    case -42: off = 0x93; break;
    case -36: off = 0x97; break;
    case -33: off = 0xad; break;
    case -32: off = 0x79; break;
    case -31: off = 0xa5; break;
    case -30: off = 0x89; break;
    case -28: off = 0x91; break;
    case -27: off = 0xb3; break;
    case -25: off = 0x7b; break;
    case -24: off = 0x7d; break;
    case -23: off = 0x7f; break;
    case -22: off = 0x81; break;
    case -21: off = 0x83; break;
    case -19: off = 0xa7; break;
    case -18: off = 0x8b; break;
    case -15: off = 0xa1; break;
    case -13: off = 0xa9; break;
    case -12: off = 0x85; break;
    case -10: off = 0x95; break;
    case -7: off = 0x8d; break;
    case -6: off = 0xab; break;
    case -4: off = 0x99; break;
    case 33: off = 0x65; break;
    case 35: off = 0xb5; break;
    case 36: off = 0xb7; break;
    case 37: off = 0x67; break;
    case 38: off = 0x69; break;
    case 39: off = 0x73; break;
    case 40: off = 0x6d; break;
    case 41: off = 0x6f; break;
    case 42: off = 0x6b; break;
    case 43: off = 0x71; break;
    case 44: off = 0x5b; break;
    case 45: off = 0x61; break;
    case 46: off = 0x59; break;
    case 47: off = 0x77; break;
    case 58: off = 0x5f; break;
    case 59: off = 0x75; break;
    case 60: off = 0xb9; break;
    case 61: off = 0x5d; break;
    case 62: off = 0xbb; break;
    case 63: off = 0x63; break;
    case 95: off = 0xaf; break;
    case 123: off = 0xbd; break;
    case 125: off = 0xbf; break;
    default: return 0;
    }
    wr16(res(host, out), 0, rd16(res(host, obj), off));
    return 1;
}
