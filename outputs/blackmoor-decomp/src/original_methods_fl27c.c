#include "original_methods_fl27c.h"

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

/* `rep movsd` of n / 4 dwords, then `rep movsb` of n % 4 bytes, forward */
static void copy_bytes(uint8_t *dst, const uint8_t *src, size_t n)
{
    size_t i;
    for (i = 0; i + 4 <= n; i += 4) wr32(dst, (ptrdiff_t)i, rd32(src, (ptrdiff_t)i));
    for (; i < n; i++) dst[i] = src[i];
}

/* `repne scasb` for the terminator: the length without it */
static size_t string_length(const uint8_t *s)
{
    size_t n = 0;
    while (s[n] != 0) n++;
    return n;
}

/* the string with its terminator */
static void copy_string(uint8_t *dst, const uint8_t *src)
{
    copy_bytes(dst, src, string_length(src) + 1);
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

/* ---- 0x414ceb ------------------------------------------------------------------------------------------------------------------ */

/* a failure report: 0x42639d(this 0x583979, message, text), [0x63a58a] = 4, 0x4c97b4(this 0x5cf659) */
static void report(const Fl18Host *host, Fl27cWorld *world, uint32_t message, uintptr_t text)
{
    call2(host, 0x42639d, 0x583979, message, text);
    world->value_63a58a = 4;
    call0(host, 0x4c97b4, 0x5cf659);
}

/* 0x414ceb, `ret 4`: see the header. [ebp-8] is `self` (ecx), [ebp-4] the allocation. The signature of 0x541978 (15 bytes with the terminator) is the file magic that the header must start with. */
int32_t m414ceb_open_map(uint8_t *self, uint8_t *arg, Fl27cWorld *world, const Fl18Host *host)
{
    static const uint8_t signature[15] = {'A', 'V', 'F', ' ', 'W', 'a', 'y', 'n', 'e', 'S', 'i', 'k', 'e', 's', 0};
    uint32_t n, a;
    const uintptr_t name = (uintptr_t)(arg + 0x4d);
    const uintptr_t path = (uintptr_t)(arg + 0x151);
    uintptr_t open_args[7], map_args[6], view_args[5];
    if (rd32(arg, 0x21) != 0) report(host, world, 0x5418d0, path);
    wr32(arg, 0x21, 0);
    wr32(arg, 0x31, 0);
    wr32(arg, 0x35, 0);
    wr32(arg, 0x39, 0);
    wr32(arg, 0x3d, 0);
    wr32(arg, 0x41, 0);
    wr32(arg, 0x25, 0);
    wr32(arg, 0x29, 0);
    wr32(arg, 0x2d, 0);
    wr32(arg, 0x49, 0);
    wr32(arg, 0x45, 0xffffffffu);
    if (string_length(arg + 0x4d) == 0) report(host, world, 0x541900, path);
    open_args[0] = name;
    open_args[1] = 0x80000000u;
    open_args[2] = 0;
    open_args[3] = 0;
    open_args[4] = 3;
    open_args[5] = 0x8000000u;
    open_args[6] = 0;
    wr32(arg, 0x25, callv(host, 0x52a2bc, 0, open_args, 7));
    if (rd32(arg, 0x25) == 0xffffffffu) {
        report(host, world, 0x541924, name);
        return 0;
    }
    map_args[0] = rd32(arg, 0x25);
    map_args[1] = 0;
    map_args[2] = 2;
    map_args[3] = 0;
    map_args[4] = 0;
    map_args[5] = 0;
    wr32(arg, 0x29, callv(host, 0x52a2c0, 0, map_args, 6));
    if (rd32(arg, 0x29) == 0) {
        report(host, world, 0x54193c, name);
        return 0;
    }
    view_args[0] = rd32(arg, 0x29);
    view_args[1] = 4;
    view_args[2] = 0;
    view_args[3] = 0;
    view_args[4] = 0;
    wr32(arg, 0x2d, callv(host, 0x52a2c4, 0, view_args, 5));
    if (rd32(arg, 0x2d) == 0) {
        report(host, world, 0x54195c, name);
        return 0;
    }
    copy_bytes(arg, object_at(host, rd32(arg, 0x2d)), 0x21);
    if (memcmp(arg, signature, sizeof signature) != 0 || rd16(arg, 0x10) != 2 || rd16(arg, 0x12) != 0) {
        call1(host, 0x415011, (uintptr_t)self, (uintptr_t)arg);
        report(host, world, 0x541988, name);
        return 0;
    }
    n = (uint32_t)rds16(arg, 0x15) * 0x13u;
    a = call1(host, 0x51dc43, 0, n);
    wr32(arg, 0x21, a);
    if (a == 0) {
        call1(host, 0x415011, (uintptr_t)self, (uintptr_t)arg);
        report(host, world, 0x5419ec, 0x5419dc);
        return 0;
    }
    /* native rejection: a negative word makes n a count of about 4 GB (the original copies it) */
    if (n > 0x7fffffffu) return 1;
    copy_bytes(object_at(host, rd32(arg, 0x21)), object_at(host, rd32(arg, 0x2d) + 0x21), n);
    wr32(arg, 0x41, (uint32_t)rds16(arg, 0x17) * (uint32_t)rds16(arg, 0x19) * (uint32_t)(arg[0x1b] >> 3));
    return 0;
}
