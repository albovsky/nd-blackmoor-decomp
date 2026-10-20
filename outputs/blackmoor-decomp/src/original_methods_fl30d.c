#include "original_methods_fl30d.h"

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

/* ---- 0x4e2e05 copy_state --------------------------------------------------------------------------------------------------------- */
#define B(va) ((va) - 0x5a1e54u)

/* copies the NUL-terminated string at src (NUL included) to dst; the original copies dwords and then bytes forward (src and dst never overlap) */
static void copy_z(uint8_t *dst, const uint8_t *src)
{
    size_t len = strlen((const char *)src) + 1;
    memcpy(dst, src, len);
}

int32_t m4e2e05_copy_state(uint8_t *self, const Fl30dWorld *world, const Fl18Host *host)
{
    uint8_t *b = world->block_5a1e54;
    int32_t count = rds16(self, 0x1471);
    int32_t n = count * 0x29;
    if (count < 0 || (uint32_t)n > FL30D_BLOCK_5A1E54_SIZE - B(0x5a1e62)) return 1;     /* native rejection */
    wr32(b, B(0x5a1e54), 0);
    wr32(b, B(0x5a1e58), 0);
    memcpy(b + B(0x5a1e62), self + 0x457b, (size_t)n);
    wr16(b, B(0x5a1e5c), rd16(self, 0x1471));
    call0(host, 0x4e3ade, (uintptr_t)self);
    if (self[0x139d] != world->byte_63a9e4) {
        wr16(b, B(0x5a1e5e), 1);
        copy_z(b + B(0x5a2664), self + 0x139d);
        copy_z(b + B(0x5a2685), self + 0x13be);
        wr16(b, B(0x5a26a6), rd16(self, 0x13df));
        wr16(b, B(0x5a26a8), rd16(self, 0x13e1));
        wr32(b, B(0x5a26aa), 0);
    } else {
        wr16(b, B(0x5a1e5e), 0);
    }
    if (self[0x13e3] != world->byte_63a9e8) {
        wr16(b, B(0x5a1e60), 1);
        copy_z(b + B(0x5a434c), self + 0x13e3);
        wr32(b, B(0x5a4371), (uint32_t)rds16(self, 0x1404));
        wr16(b, B(0x5a436d), rd16(self, 0x1406));
        wr16(b, B(0x5a436f), rd16(self, 0x1408));
    } else {
        wr16(b, B(0x5a1e60), 0);
    }
    (void)host;
    return 0;
}

/* ---- 0x4c2a8d make_record -------------------------------------------------------------------------------------------------------- */
uint32_t m4c2a8d_make_record(uint8_t *self, uint32_t w, uint32_t h, uint32_t tag, uint32_t name, const Fl30dWorld *world, const Fl18Host *host)
{
    int32_t sw = (int16_t)w, sh = (int16_t)h, size;
    uint32_t rec_va, pix_va;
    uint8_t *rec, *str;
    size_t len;
    rec_va = call1(host, 0x51dc43, 0, 0x59);
    if (rec_va == 0) {
        call2(host, 0x42639d, 0x583979, 0x553dbc, name);
        call0(host, 0x4c97b4, (uintptr_t)self);
        return 0;
    }
    rec = res(host, rec_va);
    memset(rec, 0, 0x59);
    size = (int32_t)((uint32_t)sw * (uint32_t)(int32_t)world->word_639895 * (uint32_t)sh);
    pix_va = call1(host, 0x51dc43, 0, (uint32_t)size);
    wr32(rec, 0, pix_va);
    if (pix_va == 0) {
        call2(host, 0x42639d, 0x583979, 0x553e14, name);
        call0(host, 0x4c97b4, (uintptr_t)self);
        return 0;
    }
    str = res(host, name);
    len = strlen((const char *)str);
    if (len >= 0x19) str[0x18] = 0;
    memcpy(rec + 8, str, strlen((const char *)str) + 1);
    wr32(rec, 4, tag);
    wr16(rec, 0x21, 0x59);
    wr32(rec, 0x23, (uint32_t)size);
    wr32(rec, 0x27, (uint32_t)size + 0x59);
    wr16(rec, 0x2b, (uint16_t)w);
    wr16(rec, 0x2d, (uint16_t)h);
    wr16(rec, 0x2f, (uint16_t)((uint32_t)sw * (uint32_t)(int32_t)world->word_639895));
    wr16(rec, 0x31, (uint16_t)h);
    wr16(rec, 0x33, world->word_639893);
    wr32(rec, 0x55, 0);
    wr32(rec, 0x35, 0);
    wr32(rec, 0x39, 0);
    wr32(rec, 0x3d, (uint32_t)(sw - 1));
    wr32(rec, 0x41, (uint32_t)(sh - 1));
    memset(rec + 0x45, 0, 16);
    return rec_va;
}
