#include "original_methods_fl31b.h"

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

/* host memory behind an original address (writable: the host owns the memory; the interface only says const) */
static uint8_t *res(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
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

static uint32_t call5(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3, uintptr_t a4)
{
    const uintptr_t a[5] = {a0, a1, a2, a3, a4};
    return callv(host, callee, this_ptr, a, 5);
}

/* ---- 0x4c946b call_slot ---------------------------------------------------------------------------------------------------------- */
void m4c946b_call_slot(const uint8_t *self, uint32_t index, const Fl18Host *host)
{
    int32_t i = (int16_t)index;
    call1(host, 0x4c2dfb, (uintptr_t)self, (uintptr_t)self + (uintptr_t)(ptrdiff_t)(0xc72 + (ptrdiff_t)i * 4));
}

/* ---- 0x4ee673 forward_if_set ----------------------------------------------------------------------------------------------------- */
void m4ee673_forward_if_set(const uint8_t *self, uint32_t arg, const Fl18Host *host)
{
    if (rd32(self, 0x252) != 0) call1(host, 0x4ef4f0, (uintptr_t)self + 0x4b7, arg);
}

/* ---- 0x4daeb5 read_cursor -------------------------------------------------------------------------------------------------------- */
uint32_t m4daeb5_read_cursor(uint8_t *self, uint32_t out, const Fl18Host *host)
{
    uint32_t pt[2] = {0, 0};
    uint8_t *dst;
    call1(host, 0x52a484, 0, (uintptr_t)pt);
    wr32(self, 0x18, pt[0]);
    wr32(self, 0x1c, pt[1]);
    dst = res(host, out);
    wr32(dst, 0, pt[0]);
    wr32(dst, 4, pt[1]);
    return out;
}

/* ---- 0x4dadff poll_keys ---------------------------------------------------------------------------------------------------------- */
void m4dadff_poll_keys(const uint8_t *self, Fl31bWorld *world, const Fl18Host *host)
{
    uint32_t r = call1(host, 0x52a4b4, 0, rd32(self, 0x20));
    world->byte_58321d = ((uint32_t)(int32_t)(int16_t)r & 0x8000u) == 0x8000u ? 1 : 0;
    r = call1(host, 0x52a4b4, 0, rd32(self, 0x24));
    world->byte_58321e = ((uint32_t)(int32_t)(int16_t)r & 0x8000u) == 0x8000u ? 1 : 0;
}

/* ---- 0x420b9e report_name -------------------------------------------------------------------------------------------------------- */
void m420b9e_report_name(const uint8_t *self, const Fl31bWorld *world, const Fl18Host *host)
{
    int32_t m;
    uint32_t s;
    if (world->dword_5b15da != 0) {
        m = (int16_t)rd16(self, 0xf75);
        s = 0x543b60;
    } else {
        m = (int16_t)rd16(self, 0xf73);
        s = 0x543b88;
    }
    call5(host, 0x4c51a5, 0x5cf659, rd32(world->table_5d02cb, (ptrdiff_t)m * 4), world->dword_5d03af, 0x5b15de, 0x5b15de, s);
}

/* ---- 0x47d1c3 alloc_zeroed ------------------------------------------------------------------------------------------------------- */
void m47d1c3_alloc_zeroed(uint32_t out, uint32_t size, const Fl31bWorld *world, const Fl18Host *host)
{
    uint32_t buf = call1(host, 0x51dc43, 0, size);
    wr32(res(host, out), 0, buf);
    if (buf == 0) {
        call2(host, 0x50ca3e, 0, 0x63888b, 0x54d168);
        call1(host, 0x4264e8, 0x583979, 0x63888b);
        if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, 0x63888b);
        call0(host, 0x4c97b4, 0x5cf659);
    } else {
        if (size != 0) memset(res(host, rd32(res(host, out), 0)), 0, size);
    }
}

/* ---- 0x4fc878 activate_record ---------------------------------------------------------------------------------------------------- */
void m4fc878_activate_record(uint8_t *self, uint32_t index, const Fl31bWorld *world, const Fl18Host *host)
{
    uint32_t i = index & 0xffffu;
    if (world->word_63a4cd != 0) {
        call3(host, 0x50ca3e, 0, 0x63888b, 0x560940, i);
        call1(host, 0x44a2b7, 0, 0x63888b);
    }
    if (rd16(self, (ptrdiff_t)(i * 0x5bbu) + 0x132) == 1) {
        call1(host, 0x4f61e7, 0x5cf1eb, i);
        wr16(self, (ptrdiff_t)(i * 0x5bbu) + 0x132, 2);
    }
}

/* ---- 0x47d4f7 reset_fields ------------------------------------------------------------------------------------------------------- */
void m47d4f7_reset_fields(uint8_t *self)
{
    wr16(self, 0x1d, 0xffff);
    wr16(self, 0x23, 0xffff);
    wr16(self, 0x27, 0xfe0c);
    wr16(self, 0x25, 0xfe0c);
    self[0x57] = 0;
    wr32(self, 0x29, 0);
    wr32(self, 0x41, 0);
    wr32(self, 0x31, 0);
    wr32(self, 0x39, 0);
    wr32(self, 0x2d, 0);
    wr32(self, 0x45, 0);
    wr32(self, 0x35, 0);
    wr32(self, 0x3d, 0);
    wr32(self, 0x49, 0);
    wr32(self, 0x4d, 0);
    wr32(self, 0x51, 0);
}

/* ---- 0x47d59b release_fields ----------------------------------------------------------------------------------------------------- */
void m47d59b_release_fields(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x1f) != 0) call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)self + 0x1f);
    if (rd32(self, 0x49) != 0) call1(host, 0x51dc6c, 0, rd32(self, 0x49));
    if (rd32(self, 0x4d) != 0) call1(host, 0x51dc6c, 0, rd32(self, 0x4d));
    if (rd32(self, 0x51) != 0) call1(host, 0x51dc6c, 0, rd32(self, 0x51));
    if (rds16(self, 0x23) != -1) call1(host, 0x4d3992, 0, rd16(self, 0x23));
    call0(host, 0x47d4f7, (uintptr_t)self);
}
