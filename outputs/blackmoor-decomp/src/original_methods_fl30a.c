#include "original_methods_fl30a.h"

#include <string.h>

static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
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

static __attribute__((unused)) uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
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

/* ---- 0x4f61e7 start_record ------------------------------------------------------------------------------------------------------ */
uint32_t m4f61e7_start_record(uint8_t *self, uint32_t index, const Fl30aWorld *world, const Fl18Host *host)
{
    uint32_t rec, obj, vtable, entry, hr;
    wr32(self, 0x3c2, 0x3e8);
    wr32(self, 0x3ca, 0);
    rec = rd32(self, 0x3ce) + index * 0x5bbu;
    if (call0(host, 0x4f709c, (uintptr_t)self) == 0) {
        wr32(self, 0x3c2, 0x3ea);
        wr32(self, 0x3be, 0);
        return rd32(self, 0x3be);
    }
    if (rd32(res(host, rec), 0x162) == 0 || rd32(res(host, rec), 0x28f) == 0) {
        wr32(self, 0x3c2, 0x3ef);
        wr32(self, 0x3be, 0);
        return rd32(self, 0x3be);
    }
    wr32(res(host, rec), 0x287, 1);
    obj = rd32(res(host, rec), 0x28f);
    vtable = rd32(res(host, obj), 0);
    entry = rd32(res(host, vtable + 0x48), 0);
    hr = call1(host, entry, vtable, obj);
    wr32(self, 0x3ca, hr);
    if (rd32(self, 0x3ca) == 0) {
        if (world->word_63a4cd != 0) {
            call4(host, 0x50ca3e, 0, 0x63888b, 0x55e7bc, index, rec + 4);
            call1(host, 0x44a2b7, 0, 0x63888b);
        }
        return 1;
    }
    wr32(self, 0x3c2, 0x40b);
    wr32(self, 0x3be, 0);
    return rd32(self, 0x3be);
}
