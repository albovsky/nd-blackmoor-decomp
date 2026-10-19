#include "original_methods_fl27c.h"

#include <string.h>

static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
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

static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    const uintptr_t a[3] = {a0, a1, a2};
    return callv(host, callee, this_ptr, a, 3);
}

static uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3)
{
    const uintptr_t a[4] = {a0, a1, a2, a3};
    return callv(host, callee, this_ptr, a, 4);
}

/* the object of an original address (an address that an object keeps), as host memory */
static uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

/* `movsx eax, word ptr [0x63a4cd]; test eax, eax`: the debug flag, read at every use */
static int debug_on(const Fl27cWorld *world)
{
    return world->word_63a4cd != 0;
}

/* `repne scasb` (length + 1 with the terminator), then `rep movsd` of n / 4 dwords and `rep movsb` of n % 4 bytes, forward */
static void copy_string(uint8_t *dst, const uint8_t *src)
{
    size_t n = 0, i;
    while (src[n] != 0) n++;
    n++;
    for (i = 0; i + 4 <= n; i += 4) wr32(dst, (ptrdiff_t)i, rd32(src, (ptrdiff_t)i));
    for (; i < n; i++) dst[i] = src[i];
}

/* ---- 0x4497a0 ------------------------------------------------------------------------------------------------------------------ */

/* The virtual call `mov ecx,[self+0x36]; mov eax,[self+0x36]; mov edx,[eax]; call [edx+0x78]`: the object address is read twice with nothing in between. */
static void virtual_78(const Fl18Host *host, uint32_t obj)
{
    uint32_t vtable = rd32(object_at(host, obj), 0);
    uint32_t entry = rd32(object_at(host, vtable), 0x78);
    call0(host, entry, obj);
}

/* 0x4497a0, `ret 0x10`: see the header. [ebp-0x8c] is `self`; [ebp-0x78] the allocation, [ebp-0x74] the object (0x524aff's result), [ebp-0x7c] and [ebp-0x84] the object
 * address re-read for the imports, [ebp-0x70] a 0x68-byte trace buffer. fs:[0] is linked in the prologue and restored before the return (not modelled). */
uint8_t *m4497a0_construct(uint8_t *self, uint32_t arg8, uint32_t name, uint32_t timeout, uint32_t flags, const Fl27cWorld *world, const Fl18Host *host)
{
    uint32_t p, obj, r;
    uint8_t text[0x68];
    wr32(self, 0, 0x52cb5c);
    wr32(self, 0x36, 0);
    wr32(self, 0x42, 3);
    wr32(self, 0x3a, 0xffffffffu);
    wr32(self, 0x3e, 0);
    copy_string(self + 4, object_at(host, name));
    p = call1(host, 0x51dc43, 0, 0x68);
    obj = p != 0 ? call2(host, 0x524aff, p, arg8, (uintptr_t)(self + 0x3e)) : 0;
    wr32(self, 0x36, obj);
    if (obj == 0) {
        call1(host, 0x4264e8, 0x583979, 0x548844);
        call0(host, 0x4c97b4, 0x5cf659);
        return self;
    }
    wr32(object_at(host, rd32(self, 0x36)), 0x24, 1);
    r = call3(host, 0x51ed8c, rd32(self, 0x36), flags | 4u, 0, 0);
    if (r == 0) {
        /* native rejection: a callee cleared [self+0x36]; the original reads the vtable at address 0 */
        if (rd32(self, 0x36) == 0) return NULL;
        virtual_78(host, rd32(self, 0x36));
        call1(host, 0x4264e8, 0x583979, 0x548894);
        call0(host, 0x4c97b4, 0x5cf659);
        return self;
    }
    obj = rd32(self, 0x36);
    if (obj == 0) return NULL;
    r = call2(host, 0x52a2ac, 0, rd32(object_at(host, obj), 0x28), timeout);
    if (r == 0) {
        if (rd32(self, 0x36) == 0) return NULL;
        virtual_78(host, rd32(self, 0x36));
        call1(host, 0x4264e8, 0x583979, 0x5488d8);
        call0(host, 0x4c97b4, 0x5cf659);
        return self;
    }
    if ((flags & 4u) == 0) {
        obj = rd32(self, 0x36);
        if (obj == 0) return NULL;
        r = call1(host, 0x52a284, 0, rd32(object_at(host, obj), 0x28));
        if (r == 0xffffffffu) {
            if (rd32(self, 0x36) == 0) return NULL;
            virtual_78(host, rd32(self, 0x36));
            call1(host, 0x4264e8, 0x583979, 0x548920);
            call0(host, 0x4c97b4, 0x5cf659);
            return self;
        }
    }
    if (rd32(self, 0x36) == 0) return NULL;
    wr32(object_at(host, rd32(self, 0x36)), 0x24, 0);
    wr32(self, 0x3a, rd32(object_at(host, rd32(self, 0x36)), 0x2c));
    wr32(self, 0x42, flags == 4u ? 1u : 2u);
    if (debug_on(world)) {
        call4(host, 0x50ca3e, 0, (uintptr_t)text, 0x548968, rd32(self, 0x3a), (uintptr_t)(self + 4));
        call1(host, 0x44a2b7, 0, (uintptr_t)text);
    }
    return self;
}
