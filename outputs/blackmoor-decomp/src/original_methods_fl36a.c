#include "original_methods_fl36a.h"

#include <string.h>

#if defined(__GNUC__)
#define FL36A_UNUSED __attribute__((unused))
#else
#define FL36A_UNUSED
#endif

FL36A_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL36A_UNUSED static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL36A_UNUSED static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

FL36A_UNUSED static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL36A_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* host memory behind an original address (writable: the host owns the memory; the interface only says const) */
FL36A_UNUSED static uint8_t *res(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

FL36A_UNUSED static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

FL36A_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

FL36A_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

FL36A_UNUSED static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    const uintptr_t a[2] = {a0, a1};
    return callv(host, callee, this_ptr, a, 2);
}

FL36A_UNUSED static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    const uintptr_t a[3] = {a0, a1, a2};
    return callv(host, callee, this_ptr, a, 3);
}

/* ---- 0x4f379c open_entry ------------------------------------------------------------------------------------------------------- */
/* the error exits: [self+0x3c2] = code, [self+0x3be] = 0, eax = [self+0x3be] */
static uint32_t fail_4f379c(uint8_t *self, uint32_t code)
{
    wr32(self, 0x3c2, code);
    wr32(self, 0x3be, 0);
    return rd32(self, 0x3be);
}

/* 0x4f379c m4f379c_open_entry */
int m4f379c_open_entry(uint8_t *self, uint32_t id, uint32_t *result, const Fl36aWorld *world, const Fl18Host *host)
{
    uint8_t local[0x24];
    uintptr_t a[5];
    uint32_t entry, fp, size, p, q, t, len;
    uint8_t *o;
    id &= 0xffffu;
    memset(local, 0, sizeof local);
    wr16(local, 0, (uint16_t)world->word_63aa14);
    wr32(self, 0x3be, 1);
    wr32(self, 0x3c2, 0x3e8);
    entry = rd32(self, 0x3ce) + id * 0x5bbu;
    o = res(host, entry);
    if (rd32(o, 0x162) != 0) call1(host, 0x4f356e, (uintptr_t)self, id);
    fp = call2(host, 0x50d0a9, 0, entry + 4u, 0x55dab0);
    wr32(o, 0x156, fp);
    if (rd32(o, 0x156) == 0) {
        *result = fail_4f379c(self, 0x3ed);
        return 0;
    }
    a[0] = entry + 0x10au; a[1] = 0x1e; a[2] = 1; a[3] = rd32(o, 0x156);
    if (callv(host, 0x50cf61, 0, a, 4) == 0) {
        *result = fail_4f379c(self, 0x3ec);
        return 0;
    }
    if (memcmp(o + 0x10a, res(host, 0x55dab4), 4) != 0 || rds16(o, 0x10e) != 2 || rds16(o, 0x110) != 0) {
        call1(host, 0x4f356e, (uintptr_t)self, id);
        *result = fail_4f379c(self, 0x3f9);
        return 0;
    }
    wr32(o, 0x162, 1);
    wr32(o, 0x152, 0);
    p = rd32(o, 0x1aa);
    q = rd32(o, 0x1ae);
    if (!((p != 0 || q != 0) && (int32_t)(q - p) > 0)) {
        wr32(o, 0x1aa, rd32(self, 0x446));
        wr32(o, 0x1ae, rd32(self, 0x44a));
    }
    if ((int32_t)rd32(o, 0x1b2) > (int32_t)rd32(o, 0x1b6)) {
        t = rd32(o, 0x1b6);
        wr32(o, 0x1b6, rd32(o, 0x1b2));
        wr32(o, 0x1b2, t);
    }
    if ((int32_t)rd32(o, 0x1ba) > (int32_t)rd32(o, 0x1be)) {
        t = rd32(o, 0x1be);
        wr32(o, 0x1be, rd32(o, 0x1ba));
        wr32(o, 0x1ba, t);
    }
    if ((int32_t)rd32(o, 0x1c2) > (int32_t)rd32(o, 0x1c6)) {
        t = rd32(o, 0x1c6);
        wr32(o, 0x1c6, rd32(o, 0x1c2));
        wr32(o, 0x1c2, t);
    }
    if ((int32_t)rd32(o, 0x1d6) <= 1) wr32(o, 0x1d6, rd32(self, 0x466));
    if ((int32_t)rd32(o, 0x1da) <= 1) wr32(o, 0x1da, rd32(self, 0x46a));
    wr32(o, 0x287, 0);
    wr32(o, 0x19e, 0);
    wr32(o, 0x28b, 0);
    wr32(o, 0x15e, rd32(o, 0x122));
    size = rd32(o, 0x15e);
    if ((int32_t)size < 0) {
        if (world->word_63a4cd != 0) {
            call1(host, 0x4f356e, (uintptr_t)self, id);
            call3(host, 0x50ca3e, 0, 0x63888b, 0x55dab8, entry + 4u);
            call3(host, 0x52139c, 0, 0x63888b, 0, 0);
        }
        *result = 0;
        return 0;
    }
    if (rds16(o, 0x126) == 2) {
        len = (uint32_t)strlen((const char *)res(host, 0x55dafc)) + 1u;
        if (len > sizeof local) return 1;                 /* the original would run over its saved registers */
        memcpy(local, res(host, 0x55dafc), len);
    }
    if ((int32_t)size > 0x56220) {
        wr32(o, 0x166, 1);
        if (world->word_63a4cd != 0) {
            a[0] = 0x63888b; a[1] = 0x55db08; a[2] = (uintptr_t)local; a[3] = id; a[4] = entry + 4u;
            callv(host, 0x50ca3e, 0, a, 5);
            call1(host, 0x44a2b7, 0, 0x63888b);
        }
        if (call1(host, 0x4f438f, (uintptr_t)self, id) == 0) {
            *result = 0;
            return 0;
        }
    } else {
        wr32(o, 0x166, 0);
        if (world->word_63a4cd != 0) {
            a[0] = 0x63888b; a[1] = 0x55db40; a[2] = id; a[3] = entry + 4u;
            callv(host, 0x50ca3e, 0, a, 4);
            call1(host, 0x44a2b7, 0, 0x63888b);
        }
        if (call1(host, 0x4f3c26, (uintptr_t)self, id) == 0) {
            *result = 0;
            return 0;
        }
    }
    *result = rd32(self, 0x3be);
    return 0;
}

/* ---- 0x4c36b2 save_region ------------------------------------------------------------------------------------------------------ */
/* mov ecx, count; shr ecx, 2; rep movsd; mov ecx, count; and ecx, 3; rep movsb: forward, dwords first */
static void rep_movs(const Fl18Host *host, uint32_t dst, uint32_t src, uint32_t count)
{
    uint32_t n = count >> 2, i;
    uint8_t *d;
    const uint8_t *s;
    if (count == 0) return;
    d = res(host, dst);
    s = res(host, src);
    for (i = 0; i < n; i++) {
        uint8_t t[4];
        memcpy(t, s + 4u * i, 4);
        memcpy(d + 4u * i, t, 4);
    }
    for (i = 4u * n; i < count; i++) d[i] = s[i];
}

/* 0x4c36b2 m4c36b2_save_region */
int m4c36b2_save_region(uint8_t *self, uint32_t index, Fl36aWorld *world, const Fl18Host *host)
{
    uint8_t desc[0x80], hdr[0x12];
    uintptr_t a5[5];
    const int32_t idx = (int16_t)index;
    const uint32_t rec = 0x5bb5e5u + (uint32_t)idx * 0x8du;
    const uint32_t obj = rd32(res(host, rec), 0), state = rd32(res(host, rec + 0x4d), 0);
    uint32_t buf1 = 0, buf2 = 0, fp, w2, h2, size1, size2, v1, v2, W, H, bpp, src, dst, i, cnt;
    const uint8_t *o;
    if (state == 0) {
        world->value_5839a9 = 1;
        call0(host, 0x4d36ed, obj);
        wr32(res(host, rec + 0x4d), 0, 2);
        return 0;
    }
    if (state == 3) {
        call1(host, 0x42ba3a, 0, (uint16_t)index);
        return 0;
    }
    if (state != 2) return 0;
    o = res(host, obj);
    W = (uint32_t)(int32_t)(int16_t)world->word_63988b;
    H = (uint32_t)(int32_t)(int16_t)world->word_63988d;
    bpp = (uint32_t)(int32_t)(int16_t)world->word_639895;
    if ((int32_t)rd32(o, 0x2d) > (int32_t)H || (int32_t)rd32(o, 0x29) > (int32_t)W) return 0;
    size1 = W * H * bpp;
    buf1 = call1(host, 0x51dc43, 0, size1);
    if (buf1 == 0) {
        if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x554120);
        return 1;                       /* the original frees [ebp-0xb8] here, which this path has not set yet: indeterminate stack, so the port stops */
    }
    w2 = rd32(o, 0x29) - rd32(o, 0x21);
    h2 = rd32(o, 0x2d) - rd32(o, 0x25);
    size2 = w2 * h2 * bpp;
    buf2 = call1(host, 0x51dc43, 0, size2);
    if (buf2 == 0) {
        if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x55415c);
        goto cleanup;
    }
    memset(desc, 0, sizeof desc);
    a5[0] = rd32(self, 8); a5[1] = 0; a5[2] = (uintptr_t)desc; a5[3] = 0x55419c; a5[4] = 0x10;
    callv(host, 0x4c4067, (uintptr_t)self, a5, 5);
    v1 = rd32(desc, 0x10);
    v2 = rd32(desc, 0x24);
    a5[0] = buf1; a5[1] = v2; a5[2] = H; a5[3] = W * bpp; a5[4] = v1;
    callv(host, 0x43f04b, 0x5d2f2d, a5, 5);
    call3(host, 0x4c4202, (uintptr_t)self, rd32(self, 8), 0, 0x5541d0);
    if (!((int32_t)w2 < (int32_t)W) && (int32_t)h2 >= (int32_t)H) {
        rep_movs(host, buf2, buf1, W * H * bpp);
    } else {
        src = buf1 + bpp * (W * rd32(o, 0x25) + rd32(o, 0x21));
        dst = buf2;
        for (i = 0; (int32_t)i < (int32_t)h2; i++) {
            cnt = w2 * bpp;
            rep_movs(host, dst, src, cnt);
            src += W * bpp;
            dst += w2 * bpp;
        }
    }
    if (o[0x31] == 0) {
        a5[0] = buf2; a5[1] = w2; a5[2] = h2; a5[3] = obj;
        if (callv(host, 0x4c334f, (uintptr_t)self, a5, 4) == 0 && world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x554204);
    } else {
        memset(hdr, 0, sizeof hdr);
        hdr[2] = 2;
        wr16(hdr, 0xc, (uint16_t)w2);
        wr16(hdr, 0xe, (uint16_t)h2);
        hdr[0x10] = world->byte_639893;
        hdr[0x11] = 0x20;
        a5[0] = 0x63888b; a5[1] = 0x639a9f; a5[2] = 0x639aa2; a5[3] = obj; a5[4] = 0x554238;
        callv(host, 0x50cd72, 0, a5, 5);
        fp = call2(host, 0x50d0a9, 0, 0x63888b, 0x554240);
        if (fp != 0) {
            a5[0] = (uintptr_t)hdr; a5[1] = 0x12; a5[2] = 1; a5[3] = fp;
            callv(host, 0x50e493, 0, a5, 4);
            call2(host, 0x4c7481, (uintptr_t)self, buf2, size2);
            a5[0] = buf2; a5[1] = size2; a5[2] = 1; a5[3] = fp;
            callv(host, 0x50e493, 0, a5, 4);
            call1(host, 0x50cee4, 0, fp);                  /* the original tests fp != 0 again here; fp cannot be 0 on this path */
        }
    }
cleanup:
    if (buf1 != 0) {
        call1(host, 0x51dc6c, 0, buf1);
        buf1 = 0;
    }
    if (buf2 != 0) {
        call1(host, 0x51dc6c, 0, buf2);
        buf2 = 0;
    }
    world->value_5839a9 = 0;
    wr32(res(host, rec + 0x4d), 0, 3);
    return 0;
}

/* FNS-END */
