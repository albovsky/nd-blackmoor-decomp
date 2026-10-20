#include "original_methods_fl33b.h"

#include <limits.h>
#include <string.h>

#if defined(__GNUC__)
#define FL33B_UNUSED __attribute__((unused))
#else
#define FL33B_UNUSED
#endif

FL33B_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL33B_UNUSED static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL33B_UNUSED static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

FL33B_UNUSED static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL33B_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* host memory behind an original address (writable: the host owns the memory; the interface only says const) */
FL33B_UNUSED static uint8_t *res(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

FL33B_UNUSED static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

FL33B_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

FL33B_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

FL33B_UNUSED static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    const uintptr_t a[2] = {a0, a1};
    return callv(host, callee, this_ptr, a, 2);
}

FL33B_UNUSED static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    const uintptr_t a[3] = {a0, a1, a2};
    return callv(host, callee, this_ptr, a, 3);
}

FL33B_UNUSED static uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3)
{
    const uintptr_t a[4] = {a0, a1, a2, a3};
    return callv(host, callee, this_ptr, a, 4);
}

FL33B_UNUSED static uint32_t call5(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3, uintptr_t a4)
{
    const uintptr_t a[5] = {a0, a1, a2, a3, a4};
    return callv(host, callee, this_ptr, a, 5);
}

/* rep movsd (n >> 2 dwords, ascending) then rep movsb (n & 3 bytes): the same width and order as the original */
static void rep_movs(uint8_t *dst, const uint8_t *src, uint32_t n)
{
    uint32_t i, d = n >> 2;
    for (i = 0; i < d; i++) {
        uint32_t v;
        memcpy(&v, src + 4 * (size_t)i, 4);
        memcpy(dst + 4 * (size_t)i, &v, 4);
    }
    for (i = 0; i < (n & 3); i++) dst[4 * (size_t)d + i] = src[4 * (size_t)d + i];
}

/* rep stosd (n >> 2 dwords of `v`) then rep stosb (n & 3 bytes of the low byte of `v`) */
static void rep_stos(uint8_t *dst, uint32_t v, uint32_t n)
{
    uint32_t i, d = n >> 2;
    for (i = 0; i < d; i++) memcpy(dst + 4 * (size_t)i, &v, 4);
    for (i = 0; i < (n & 3); i++) dst[4 * (size_t)d + i] = (uint8_t)v;
}

/* repne scasb for a NUL: the length of the string */
static uint32_t c_strlen(const uint8_t *s)
{
    uint32_t n = 0;
    while (s[n] != 0) n++;
    return n;
}

/* the text at buf + off (off a signed 16-bit offset, limit 0x3a98 bytes of buf): the offset of its NUL, or -1 when there is none or the offset is outside (helper of 0x41e3c0) */
#define F33_BUF 0x3a98
static int32_t text_end(const uint8_t *buf, int16_t off)
{
    int32_t pos = off, k;
    if (pos < 0 || pos >= F33_BUF) return -1;
    for (k = pos; k < F33_BUF; k++)
        if (buf[k] == 0) return k;
    return -1;
}

/* 0x47d02d m47d02d_show_names */
int32_t m47d02d_show_names(uint32_t rec, const Fl33bWorld *world, const Fl18Host *host)
{
    uint8_t buf[0x68];
    uint32_t t = 0, r, n;
    if (call2(host, 0x516530, 0, rec, 0x54d14c) != 0) {
        r = call1(host, 0x4fb77a, 0x5c3a67, rec);
        call1(host, 0x4fb2e3, 0x5c3a67, (r & 0xffff0000u) | rd16(res(host, rec), 0x21));
    }
    if (world->value_5bb202 == 0) return 0;
    if (c_strlen(res(host, rec + 0x31)) != 0) {
        t = call1(host, 0x423259, 0x619a6b, rec + 0x31);
        if (t != 0) {
            n = c_strlen(res(host, t));
            if (n > 0x9c40) {
                t = 0;
            } else {
                if (n + 7 > sizeof buf) return 1;                  /* the original overruns its frame here */
                rep_movs(buf, res(host, t), n + 1);
                memcpy(buf + n, res(host, 0x54d158), 4);
                memcpy(buf + n + 4, res(host, 0x54d15c), 2);
                buf[n + 6] = res(host, 0x54d15e)[0];
                callv(host, 0x448d11, 0x619a05, (const uintptr_t[]){world->value_5d03b3, (uintptr_t)buf, 0xffffffffu, 0}, 4);
            }
        }
    }
    if (t == 0) {
        n = c_strlen(res(host, rec + 0x52));
        if (n != 0) {
            if (n + 7 > sizeof buf) return 1;                      /* the original overruns its frame here */
            rep_movs(buf, res(host, rec + 0x52), n + 1);
            memcpy(buf + n, res(host, 0x54d160), 4);
            memcpy(buf + n + 4, res(host, 0x54d164), 2);
            buf[n + 6] = res(host, 0x54d166)[0];
            callv(host, 0x448d11, 0x619a05, (const uintptr_t[]){world->value_5d03b3, (uintptr_t)buf, 0xffffffffu, 0}, 4);
        }
    }
    return 0;
}

/* 0x4c51a5 m4c51a5_copy_rows */
int32_t m4c51a5_copy_rows(uint8_t *self, uint32_t a, uint32_t b, uint32_t fr, uint32_t tr, uint32_t tag, const Fl33bWorld *world, const Fl18Host *host)
{
    int32_t rows, i;
    uint32_t bytes, p, q;
    if (world->word_63a4cd != 0) {
        const uint8_t *f = res(host, fr), *t = res(host, tr);
        uint32_t w1 = rd32(f, 8) - rd32(f, 0), h1 = rd32(f, 12) - rd32(f, 4);
        uint32_t w2 = rd32(t, 8) - rd32(t, 0), h2 = rd32(t, 12) - rd32(t, 4);
        if (!(w1 == w2 && h1 == h2 && a != 0 && b != 0)) {
            uint8_t text[0x100];
            const uintptr_t args[11] = {(uintptr_t)text, 0x554848, tag, rd32(f, 0), rd32(f, 4), rd32(f, 8), rd32(f, 12), rd32(t, 0), rd32(t, 4), rd32(t, 8), rd32(t, 12)};
            callv(host, 0x50ca3e, 0, args, 11);
            call3(host, 0x52139c, 0, (uintptr_t)text, 0, 0);
            call0(host, 0x4c97b4, (uintptr_t)self);
            return 0;
        }
    }
    if (a == 0 || b == 0) return 1;                               /* the original reads the descriptor at 0x2f and faults */
    {
        const uint8_t *f = res(host, fr), *t = res(host, tr);
        const uint8_t *da = res(host, a), *db = res(host, b);
        uint32_t bpp = (uint32_t)(int32_t)(int16_t)world->word_639895;
        p = rd32(da, 0) + rd32(f, 4) * (uint32_t)rds16(da, 0x2f) + rd32(f, 0) * bpp;
        q = rd32(db, 0) + rd32(t, 4) * (uint32_t)rds16(db, 0x2f) + rd32(t, 0) * bpp;
        rows = (int32_t)(rd32(f, 12) - rd32(f, 4) + 1);
        bytes = (rd32(f, 8) - rd32(f, 0) + 1) * bpp;
        if (rows > 0 && (int32_t)bytes < 0) return 1;             /* shr ecx, 2 of a negative count: about 4 GB */
        for (i = 0; i < rows; i++) {
            if (bytes != 0) rep_movs(res(host, q), res(host, p), bytes);
            p += (uint32_t)rds16(da, 0x2f);
            q += (uint32_t)rds16(db, 0x2f);
        }
    }
    return 0;
}

/* 0x47df57 m47df57_update_view */
void m47df57_update_view(const Fl33bWorld *world, const Fl18Host *host)
{
    uint32_t item = rd32(world->records_5bb5e5, (ptrdiff_t)world->word_6246f9 * 0x8d);
    uint32_t r1[4], r2[4], pt[4], tval;
    int32_t size, width, height;
    if (world->byte_6246f8 == 0) return;
    size = (int32_t)world->word_624731 * 2;
    width = (int32_t)(world->value_62470d - world->value_624705 + 1);
    height = (int32_t)(world->value_624711 - world->value_624709 + 1);
    r1[0] = world->value_624715 + world->value_583186;
    r1[1] = world->value_624719 + world->value_58318a;
    r1[2] = world->value_62471d + world->value_583186;
    r1[3] = world->value_624721 + world->value_58318a;
    callv(host, 0x4c5377, 0x5cf659, (const uintptr_t[]){world->value_5d15e3, world->value_5cf665, 0x624715, (uintptr_t)r1, 0x54d3ec}, 5);
    r2[0] = world->value_624705 + world->value_583186;
    r2[1] = world->value_624709 + world->value_58318a;
    r2[2] = world->value_62470d + world->value_583186;
    r2[3] = world->value_624711 + world->value_58318a;
    pt[0] = 0;
    pt[1] = 0;
    pt[2] = (uint32_t)size - 1;
    pt[3] = (uint32_t)size - 1;
    if (width < size && world->value_624705 == 0) pt[0] = (uint32_t)size - (uint32_t)width;
    if (height < size && world->value_624709 == 0) pt[1] = (uint32_t)size - (uint32_t)height;
    tval = rd32(world->table_5d1599, (ptrdiff_t)world->word_6246ff * 0x4a);
    if (res(host, item)[0x22] != 0) {
        callv(host, 0x4c62f0, 0x5cf659, (const uintptr_t[]){tval, world->value_5d15e3, world->value_5cf665, world->value_624729, 0x624705, 0x624705, (uintptr_t)r2, (uintptr_t)pt, 0x54d408}, 9);
    } else {
        callv(host, 0x4c6929, 0x5cf659, (const uintptr_t[]){tval, world->value_5cf665, world->value_62472d, 0x624705, (uintptr_t)r2, (uintptr_t)pt, 0x54d434}, 7);
    }
}

/* 0x4c2898 m4c2898_alloc_surface */
void m4c2898_alloc_surface(uint8_t *self, uint32_t pp, uint32_t w, uint32_t h, uint32_t extra, uint32_t name, const Fl33bWorld *world, const Fl18Host *host)
{
    uint32_t p, q, size, n;
    uint8_t *rec;
    int32_t ws = (int16_t)w, hs = (int16_t)h, bpp = world->word_639895;
    if (rd32(res(host, pp), 0) != 0) {
        call2(host, 0x42639d, 0x583979, 0x553c94, name);
        call0(host, 0x4c97b4, (uintptr_t)self);
        return;
    }
    p = call1(host, 0x51dc43, 0, 0x59);
    wr32(res(host, pp), 0, p);
    if (p == 0) {
        call2(host, 0x42639d, 0x583979, 0x553d10, name);
        call0(host, 0x4c97b4, (uintptr_t)self);
        return;
    }
    rep_stos(res(host, rd32(res(host, pp), 0)), 0, 0x59);
    size = (uint32_t)(ws * bpp) * (uint32_t)hs;
    q = call1(host, 0x51dc43, 0, size);
    wr32(res(host, rd32(res(host, pp), 0)), 0, q);
    if (q == 0) {
        call2(host, 0x42639d, 0x583979, 0x553d68, name);
        call0(host, 0x4c97b4, (uintptr_t)self);
        return;
    }
    if (c_strlen(res(host, name)) >= 0x19) res(host, name)[0x18] = 0;
    n = c_strlen(res(host, name)) + 1;
    rec = res(host, rd32(res(host, pp), 0));
    rep_movs(rec + 8, res(host, name), n);
    rec = res(host, rd32(res(host, pp), 0));
    wr32(rec, 4, extra);
    rec = res(host, rd32(res(host, pp), 0));
    wr16(rec, 0x21, 0x59);
    rec = res(host, rd32(res(host, pp), 0));
    wr32(rec, 0x23, size);
    rec = res(host, rd32(res(host, pp), 0));
    wr32(rec, 0x27, size + 0x59);
    rec = res(host, rd32(res(host, pp), 0));
    wr16(rec, 0x2b, (uint16_t)w);
    rec = res(host, rd32(res(host, pp), 0));
    wr16(rec, 0x2d, (uint16_t)h);
    rec = res(host, rd32(res(host, pp), 0));
    wr16(rec, 0x2f, (uint16_t)(ws * bpp));
    rec = res(host, rd32(res(host, pp), 0));
    wr16(rec, 0x31, (uint16_t)h);
    rec = res(host, rd32(res(host, pp), 0));
    wr16(rec, 0x33, (uint16_t)world->word_639893);
    rec = res(host, rd32(res(host, pp), 0));
    wr32(rec, 0x55, 0);
    rec = res(host, rd32(res(host, pp), 0));
    wr32(rec, 0x35, 0);
    rec = res(host, rd32(res(host, pp), 0));
    wr32(rec, 0x39, 0);
    rec = res(host, rd32(res(host, pp), 0));
    wr32(rec, 0x3d, (uint32_t)(ws - 1));
    rec = res(host, rd32(res(host, pp), 0));
    wr32(rec, 0x41, (uint32_t)(hs - 1));
    rec = res(host, rd32(res(host, pp), 0));
    wr32(rec, 0x45, 0);
    wr32(rec, 0x49, 0);
    wr32(rec, 0x4d, 0);
    wr32(rec, 0x51, 0);
}

/* 0x4f594d m4f594d_read_checked */
int32_t m4f594d_read_checked(uint8_t *self, uint32_t idx, uint32_t buf, uint32_t len, const Fl33bWorld *world, const Fl18Host *host)
{
    uint32_t rec, item, S[7];
    int32_t ok = 1, n;
    (void)world;
    rec = rd32(self, 0x3ce) + idx * 0x5bb;
    item = rec + 0x18a;
    memset(S, 0, sizeof S);
    S[0] = buf;
    S[1] = len;
    S[6] = (len == rd32(res(host, rec), 0x15e) && buf == 0) ? 2 : 0;
    if (call2(host, 0x4f5e95, (uintptr_t)self, rd32(res(host, rec), 0x28f), (uintptr_t)S) == 0) {
        wr32(self, 0x3c2, 0x405);
        return 0;
    }
    if (S[3] != len || S[4] != 0) {
        call2(host, 0x4f5e35, (uintptr_t)self, rd32(res(host, rec), 0x28f), (uintptr_t)S);
        wr32(self, 0x3c2, 0x406);
        return 0;
    }
    n = (int32_t)call3(host, 0x4f5b50, (uintptr_t)self, idx, S[2], len);
    if (n < 0) {
        ok = 0;
    } else if (n < (int32_t)len) {
        if (rd32(res(host, rec), 0x130) == 0) {
            len = len - (uint32_t)n;
            n = (int32_t)call3(host, 0x4f5b50, (uintptr_t)self, idx, S[2] + (uint32_t)n, len);
            if (n < 0) {
                ok = 0;
            } else if (n < (int32_t)len) {
                wr32(self, 0x3c2, 0x3ec);
                ok = 0;
            }
        } else if (rd32(res(host, item), 0x10) != 0xffffffffu) {
            uint32_t fill = rd16(res(host, rec), 0x2ed) == 8 ? 0x80808080u : 0;
            rep_stos(res(host, S[2] + (uint32_t)n), fill, len - (uint32_t)n);
            wr32(res(host, item), 0xc, 1);
        }
    }
    if (call2(host, 0x4f5e35, (uintptr_t)self, rd32(res(host, rec), 0x28f), (uintptr_t)S) == 0) {
        wr32(self, 0x3c2, 0x407);
        ok = 0;
    }
    return ok;
}

/* 0x41e3c0 m41e3c0_build_text */
int32_t m41e3c0_build_text(uint8_t *self, uint32_t idx, const Fl33bWorld *world, const Fl18Host *host)
{
    uint8_t *buf, text[0x34];
    uint8_t *item;
    uint32_t bufaddr, n, a;
    int16_t off = 0, i;
    int32_t e;
    uintptr_t obj = (uintptr_t)(self + 0xf1d);
    call0(host, 0x51e745, obj);
    bufaddr = call1(host, 0x51ea75, obj, 0x3a98);
    if (bufaddr == 0) return 1;                                  /* the original's rep stosd faults at address 0 */
    buf = res(host, bufaddr);
    rep_stos(buf, 0, 0xea6 * 4);
    item = res(host, rd32(world->records_5bb5e5, (ptrdiff_t)(int16_t)idx * 0x8d));
    n = c_strlen(item + 0x16b);
    if (n > F33_BUF) return 1;
    rep_movs(buf, item + 0x16b, n);
    off = (int16_t)(off + (int16_t)n);
    if (world->value_5bb202 != 0) {
        e = text_end(buf, off);
        if (e < 0 || e + 4 > F33_BUF) return 1;
        memcpy(buf + e, res(host, 0x54388c), 4);
        off = (int16_t)(off + (int16_t)c_strlen(res(host, 0x543890)));
    }
    for (i = 0; i < rds16(self, 0xf21); i = (int16_t)(i + 1)) {
        if (i != 0) {
            e = text_end(buf, off);
            if (e < 0 || e + 4 > F33_BUF) return 1;
            memcpy(buf + e, res(host, 0x543894), 4);
            off = (int16_t)(off + (int16_t)c_strlen(res(host, 0x543898)));
        }
        call5(host, 0x50ca3e, 0, (uintptr_t)text, 0x54389c, (uint32_t)(int32_t)i, (uint32_t)(int32_t)i, (uintptr_t)(self + (int32_t)i * 0x3a + 0x7d9));
        for (n = 0; n < sizeof text && text[n] != 0; n++) {}
        if (n == sizeof text) return 1;                          /* the callee text overruns the 0x34 byte local */
        e = text_end(buf, off);
        if (e < 0 || e + (int32_t)n + 1 > F33_BUF) return 1;
        rep_movs(buf + e, text, n + 1);
        off = (int16_t)(off + (int16_t)n);
        a = rd32(self, (ptrdiff_t)i * 4 + 0xea5);
        n = c_strlen(res(host, a));
        if (off < 0 || (uint32_t)off + n > F33_BUF) return 1;
        rep_movs(buf + off, res(host, a), n);
        a = rd32(self, (ptrdiff_t)i * 4 + 0xea5);
        off = (int16_t)(off + (int16_t)c_strlen(res(host, a)));
    }
    e = text_end(buf, off);
    if (e < 0 || e + 4 > F33_BUF) return 1;
    memcpy(buf + e, res(host, 0x5438b0), 4);
    call1(host, 0x51eac4, obj, 0xffffffffu);
    return 0;
}

/* 0x4f5b50 m4f5b50_read_block */
int32_t m4f5b50_read_block(uint8_t *self, uint32_t idx, uint32_t buf, uint32_t len, const Fl33bWorld *world, const Fl18Host *host)
{
    uint32_t rec, s, flag = 0, file;
    int32_t mode, pos = 0, go = 1, v18 = 1, v20 = 2, n;
    wr32(self, 0x3c2, 0x3e8);
    rec = rd32(self, 0x3ce) + idx * 0x5bb;
    mode = rds16(res(host, rec), 0x126);
    if (mode == 2) {
        s = rec + 0x2f1;
        if (rd16(res(host, rec), 0x2ed) == 8) {
            v18 = 0;
            v20 = 1;
        }
        if (world->word_63a4cd == 2) {
            call3(host, 0x50ca3e, 0, 0x63888b, 0x55e63c, idx);
            call1(host, 0x44a2b7, 0, 0x63888b);
        }
        while (pos < (int32_t)len && go != 0) {
            go = (int32_t)callv(host, 0x4fe2d0, 0, (const uintptr_t[]){s, buf + (uint32_t)pos, len - (uint32_t)pos, 0, (uint32_t)v20, (uint32_t)v18, (uintptr_t)&flag}, 7);
            if (go < 0 || flag != 0) {
                if (world->word_63a4cd != 0) {
                    call4(host, 0x50ca3e, 0, 0x63888b, 0x55e680, rec + 4, (uint32_t)go);
                    call1(host, 0x44a2b7, 0, 0x63888b);
                }
                wr32(self, 0x3c2, 0x3ec);
                return -1;
            }
            if (go == 0) call3(host, 0x4fdc70, 0, s, 0, 0);
            pos += go;
        }
        if (world->word_63a4cd == 2) {
            call4(host, 0x50ca3e, 0, 0x63888b, 0x55e6c8, idx, (uint32_t)pos);
            call1(host, 0x44a2b7, 0, 0x63888b);
        }
        return pos;
    }
    if (mode == 1) {
        file = rd32(res(host, rec), 0x156);
        n = (int32_t)call4(host, 0x50cf61, 0, buf, 1, len, file);
        if (n != (int32_t)len) {
            uint32_t fl = rd32(res(host, file), 0xc);
            if ((fl & 0x20) != 0 || (fl & 0x10) == 0) {
                if (world->word_63a4cd != 0) {
                    call3(host, 0x50ca3e, 0, 0x63888b, 0x55e718, rec + 4);
                    call1(host, 0x44a2b7, 0, 0x63888b);
                }
                wr32(self, 0x3c2, 0x3ec);
                return -1;
            }
            call3(host, 0x50ce2b, 0, file, 0x1e, 0);
        }
        return n;
    }
    if (world->word_63a4cd != 0) call3(host, 0x52139c, 0, 0x55e754, 0, 0);
    wr32(self, 0x3c2, 0x3f9);
    return -1;
}

/* 0x41db40 m41db40_free_record */
void m41db40_free_record(uint32_t idx, const Fl33bWorld *world, const Fl18Host *host)
{
    static const struct { uint32_t cnt, ptr, stride; } T[3] = {{0x793, 0x795, 0x1d1}, {0x799, 0x79b, 0x1c}, {0x79f, 0x7a1, 0xa}};
    uint32_t p, q;
    uint8_t *pr;
    int16_t i;
    int k;
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x5437a8);
    p = rd32(world->records_5bb5e5, (ptrdiff_t)(int16_t)idx * 0x8d);
    if (p == 0) return;
    pr = res(host, p);
    for (k = 0; k < 3; k++) {
        if (rds16(pr, T[k].cnt) > 0 && rd32(pr, T[k].ptr) != 0) {
            for (i = 0; i < rds16(pr, T[k].cnt); i = (int16_t)(i + 1)) {
                const uint8_t *e = res(host, rd32(pr, T[k].ptr) + (uint32_t)((int32_t)i * (int32_t)T[k].stride));
                if (rds16(e, 0) > 0 && rd32(e, 2) != 0) {
                    q = rd32(e, 2);
                    call1(host, 0x51dc6c, 0, q);
                }
            }
            q = rd32(pr, T[k].ptr);
            call1(host, 0x51dc6c, 0, q);
            wr32(pr, T[k].ptr, 0);
        }
    }
    q = rd32(world->records_5bb5e5, (ptrdiff_t)(int16_t)idx * 0x8d);
    call1(host, 0x51dc6c, 0, q);
    wr32(world->records_5bb5e5, (ptrdiff_t)(int16_t)idx * 0x8d, 0);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x5437d4);
}

/* FNS-END */
