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
uint8_t *m4497a0_construct(uint8_t *self, uint32_t arg8, uint32_t name, uint32_t priority, uint32_t flags, const Fl27cWorld *world, const Fl18Host *host)
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
    r = call2(host, 0x52a2ac, 0, rd32(object_at(host, obj), 0x28), priority);
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

/* ---- 0x4c2e97 ------------------------------------------------------------------------------------------------------------------ */

/* One colour mask of 0x4c2e97: `while ((mask & 1) == 0) { mask >>= 1; ++cnt; }`, then the three stores. Returns 0 for a zero mask (the original never leaves the loop). */
static int mask_fields(uint8_t *self, uint8_t *desc, ptrdiff_t desc_off, ptrdiff_t count_off, ptrdiff_t mask_off, ptrdiff_t kind_off)
{
    uint32_t mask = rd32(desc, desc_off);
    uint8_t count = 0;
    if (mask == 0) return 0;
    while ((mask & 1u) == 0) {
        mask >>= 1;
        count = (uint8_t)(count + 1);
    }
    wr32(desc, desc_off, mask);
    self[count_off] = count;
    self[mask_off] = (uint8_t)mask;
    self[kind_off] = mask == 0x1f ? 5 : 6;
    return 1;
}

/* 0x4c2e97, `ret 4`: see the header. [ebp-0x88] is `self`, [ebp-0x80] the 0x7c-byte descriptor, [ebp-4] the method's result, [ebp-0x84] the shift counter. The virtual call is
 * `mov ecx,[ebp+8]; mov edx,[ecx]; push [ebp+8]; call [edx+0x58]` with the second argument &descriptor pushed first. */
int32_t m4c2e97_read_pixel_format(uint8_t *self, uint32_t surf, Fl27cWorld *world, const Fl18Host *host)
{
    uint8_t desc[0x7c];
    uint32_t vtable, entry, hr, value;
    uintptr_t args[16];
    uint32_t flags;
    memset(desc, 0, sizeof desc);
    wr32(desc, 0, 0x7c);
    wr32(desc, 4, 0x1000);
    vtable = rd32(object_at(host, surf), 0);
    entry = rd32(object_at(host, vtable), 0x58);
    args[0] = surf;
    args[1] = (uintptr_t)desc;
    hr = callv(host, entry, surf, args, 2);
    if (hr != 0) {
        uint32_t text = call1(host, 0x4c88c7, (uintptr_t)self, hr);
        call2(host, 0x42639d, 0x583979, 0x553f14, text);
        return 0;
    }
    if (!mask_fields(self, desc, 0x58, 0x38c2, 0x38c6, 0x38ca)) return 0;
    if (!mask_fields(self, desc, 0x5c, 0x38c1, 0x38c5, 0x38c9)) return 0;
    if (!mask_fields(self, desc, 0x60, 0x38c0, 0x38c4, 0x38c8)) return 0;
    world->byte_5b0257 = (uint8_t)(world->byte_5b0257 & self[0x38c6]);
    world->byte_5b0258 = (uint8_t)(world->byte_5b0258 & self[0x38c5]);
    world->byte_5b0259 = (uint8_t)(world->byte_5b0259 & self[0x38c4]);
    if (self[0x38ca] != 5) world->byte_5b0257 = (uint8_t)(world->byte_5b0257 << 1);
    if (self[0x38c9] != 5) world->byte_5b0258 = (uint8_t)(world->byte_5b0258 << 1);
    if (self[0x38c8] != 5) world->byte_5b0259 = (uint8_t)(world->byte_5b0259 << 1);
    value = ((uint32_t)world->byte_5b0257 << self[0x38c2]) | ((uint32_t)world->byte_5b0258 << self[0x38c1]) | ((uint32_t)world->byte_5b0259 << self[0x38c0]);
    wr16(self, 0x38d0, (uint16_t)value);
    self[0x38d2] = (uint8_t)(rd16(self, 0x38d0) & 0xff);
    self[0x38d3] = (uint8_t)((rd16(self, 0x38d0) >> 8) & 0xff);
    wr32(self, 0x38a8, self[0x38ca] == 5 && self[0x38c9] == 5 && self[0x38c8] == 5 ? 0u : 1u);
    if (debug_on(world)) {
        args[0] = 0x63888b;
        args[1] = 0x553f30;
        args[2] = self[0x38c2];
        args[3] = self[0x38c6];
        args[4] = self[0x38ca];
        args[5] = self[0x38c1];
        args[6] = self[0x38c5];
        args[7] = self[0x38c9];
        args[8] = self[0x38c0];
        args[9] = self[0x38c4];
        args[10] = self[0x38c8];
        args[11] = rd32(self, 0x38a8);
        args[12] = rd16(self, 0x38d0);
        args[13] = self[0x38d3];
        args[14] = self[0x38d2];
        args[15] = rd32(desc, 0x54);
        callv(host, 0x50ca3e, 0, args, 16);
        call1(host, 0x44a2b7, 0, 0x63888b);
        flags = rd32(desc, 0x4c);
        if ((flags & 2u) != 0) call1(host, 0x44a2b7, 0, 0x55400c);
        if ((flags & 0x20u) != 0) call1(host, 0x44a2b7, 0, 0x55403c);
        if ((flags & 0x40u) != 0) call1(host, 0x44a2b7, 0, 0x554074);
        if ((flags & 0x400u) != 0) call1(host, 0x44a2b7, 0, 0x5540a0);
    }
    return 1;
}

/* ---- 0x44c4c1 ------------------------------------------------------------------------------------------------------------------ */

/* The library routine __ftol at 0x50ce04 (called with the value on the x87 stack): fnstcw / fldcw with the rounding control forced to truncation, `fistp qword`, and eax = the low dword of the 64-bit result.
 * A NaN or a value outside the 64-bit range gives the integer indefinite 0x8000000000000000, whose low dword is 0. */
static uint32_t ftol_low_dword(double value)
{
    if (value != value) return 0;
    if (value >= 9223372036854775808.0 || value < -9223372036854775808.0) return 0;
    return (uint32_t)(int64_t)value;
}

/* The common tail of 0x44c4c1 (at 0x44c98d): four dwords copied inside the record. */
static void copy_rectangle(uint8_t *arg)
{
    wr32(arg, 0x1ae, rd32(arg, 0x19e));
    wr32(arg, 0x1b6, rd32(arg, 0x1a6));
    wr32(arg, 0x1aa, rd32(arg, 0x19a));
    wr32(arg, 0x1b2, rd32(arg, 0x1a2));
}

/* 0x44c4c1, plain `ret` (cdecl, one stack argument): see the header. [ebp+8] is `arg`; [ebp-0x308] a local text, [ebp-0x204] the extension text, [ebp-0x104] a second local text, [ebp-0x30c] the info object. */
void m44c4c1_open_video(uint8_t *arg, Fl27cWorld *world, const Fl18Host *host)
{
    uint8_t text1[0x100], text2[0x100], ext[0x100];
    uint32_t handle, info_address;
    const uint8_t *info;
    memset(text1, 0, sizeof text1);
    memset(text2, 0, sizeof text2);
    memset(ext, 0, sizeof ext);
    copy_string(ext, (const uint8_t *)(rd32(arg, 0x176) != 1 ? ".AVF" : ".BIK"));
    wr16(arg, 0x1c4, 1);
    {
        const uintptr_t a[5] = {(uintptr_t)text1, 0x639dae, 0x639eb5, (uintptr_t)(arg + 0x151), (uintptr_t)ext};
        callv(host, 0x50cd72, 0, a, 5);
    }
    if (call1(host, 0x449d90, 0, (uintptr_t)text1) == 0) {
        const uintptr_t a[5] = {(uintptr_t)text2, 0x639dab, 0x639fb9, (uintptr_t)(arg + 0x151), (uintptr_t)ext};
        callv(host, 0x50cd72, 0, a, 5);
        copy_string(arg + 0x4d, text2);
    } else {
        copy_string(arg + 0x4d, text1);
    }
    if (rd32(arg, 0x176) != 1) {
        call1(host, 0x414ceb, 0x5e2dbe, (uintptr_t)arg);
        wr16(arg, 0x18c, 0);
        wr32(arg, 0x190, (uint32_t)rds16(arg, 0x15));
        wr16(arg, 0x18e, (uint16_t)((uint32_t)rds16(arg, 0x18c) + rd32(arg, 0x190) - 1u));
        wr32(arg, 0x19e, 0);
        wr32(arg, 0x19a, 0);
        wr32(arg, 0x1a6, rd32(arg, 0x19e) + (uint32_t)rds16(arg, 0x19) - 1u);
        wr32(arg, 0x1a2, rd32(arg, 0x19a) + (uint32_t)rds16(arg, 0x17) - 1u);
        wr16(arg, 0x194, rd16(arg, 0x17));
        wr16(arg, 0x198, rd16(arg, 0x19));
        wr16(arg, 0x196, (uint16_t)((uint32_t)rds16(arg, 0x194) * (uint32_t)(arg[0x1b] >> 3)));
        wr32(arg, 0x1ba, rd32(arg, 0x1c));
        wr32(arg, 0x1c8, (uint32_t)rds16(arg, 0x196) * (uint32_t)rds16(arg, 0x198));
        copy_rectangle(arg);
        return;
    }
    handle = call2(host, 0x4bf315, 0x6201f9, (uintptr_t)(arg + 0x4d), 0);
    wr32(arg, 0x186, handle);
    if (rd32(arg, 0x186) == 0) {
        if (debug_on(world)) call1(host, 0x44a2b7, 0, call1(host, 0x4bf3b8, 0x6201f9, (uintptr_t)(arg + 0x4d)));
        call1(host, 0x4264e8, 0x583979, call1(host, 0x4bf3b8, 0x6201f9, (uintptr_t)(arg + 0x4d)));
        world->value_5bb20c = 1;
        call0(host, 0x4c97b4, 0x5cf659);
        return;
    }
    info_address = call1(host, 0x4bee5f, 0x6201f9, rd32(arg, 0x186));
    if (rd32(arg, 0x186) == 0 || info_address == 0) {
        call3(host, 0x50ca3e, 0, 0x63888b, 0x54939c, (uintptr_t)(arg + 0x4d));
        if (debug_on(world)) call1(host, 0x44a2b7, 0, 0x63888b);
        call1(host, 0x4264e8, 0x583979, 0x63888b);
        world->value_5bb20c = 1;
        call0(host, 0x4c97b4, 0x5cf659);
        return;
    }
    info = object_at(host, info_address);
    wr16(arg, 0x18c, 0);
    wr32(arg, 0x190, rd32(info, 0x20));
    wr16(arg, 0x18e, (uint16_t)(rd32(arg, 0x190) - 1u));
    wr32(arg, 0x19e, 0);
    wr32(arg, 0x19a, 0);
    wr32(arg, 0x1a6, rd32(info, 4) - 1u);
    wr32(arg, 0x1a2, rd32(info, 0) - 1u);
    wr16(arg, 0x194, rd16(info, 0));
    wr16(arg, 0x198, rd16(info, 4));
    wr16(arg, 0x196, (uint16_t)(rd32(info, 0) * (uint32_t)(int32_t)world->word_639895));
    {
        /* fild qword (the dword with a zero upper half), fstp dword: each count becomes a single-precision float; fld, fdiv, fdivr qword [0x52c598] (1.0), fmul qword [0x52c590] (1000.0) in
         * 53-bit precision (the process default control word 0x27f), then __ftol (0x50ce04) */
        float frames = (float)rd32(info, 0xc);
        float period = (float)rd32(info, 0x10);
        double quotient = (double)frames / (double)period;
        double rate = 1.0 / quotient;
        double scaled = rate * 1000.0;
        wr32(arg, 0x1ba, ftol_low_dword(scaled));
    }
    wr32(arg, 0x1c8, (uint32_t)rds16(arg, 0x196) * (uint32_t)rds16(arg, 0x198));
    copy_rectangle(arg);
}
