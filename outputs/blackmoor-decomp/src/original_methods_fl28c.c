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

/*SOURCE-INSERT*/
