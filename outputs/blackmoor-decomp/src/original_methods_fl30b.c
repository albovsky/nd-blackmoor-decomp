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
