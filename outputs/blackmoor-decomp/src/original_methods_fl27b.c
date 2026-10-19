#include "original_methods_fl27b.h"

#include <string.h>

static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

static uint32_t calln(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, int n, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3, uintptr_t a4)
{
    uintptr_t args[5];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    args[3] = a3;
    args[4] = a4;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

static int32_t rds32(const uint8_t *base, ptrdiff_t off)
{
    return (int32_t)rd32(base, off);
}

static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return calln(host, callee, this_ptr, 0, 0, 0, 0, 0, 0);
}

static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    return calln(host, callee, this_ptr, 1, a0, 0, 0, 0, 0);
}

static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    return calln(host, callee, this_ptr, 2, a0, a1, 0, 0, 0);
}

static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, n) : 0;
}

/* the object of an original address (an address that an object keeps), as host memory */
static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

/* `movsx eax, word ptr [0x63a4cd]; test eax, eax`: the debug flag, read at every use */
static int debug_on(const Fl27bWorld *world)
{
    return world->word_63a4cd != 0;
}

/* ---- 0x449bff ------------------------------------------------------------------------------------------------------------------ */

/* 0x449bff, plain ret: see the header. [ebp-8] / [ebp-0xc] are the object address read from [self+0x36] (the loop reads it again on every pass), [ebp-4] the
 * result of the import (the previous suspend count of the thread: 0xffffffff is the failure value). The two compares `cmp [ebp-4], 1; jbe` are unsigned.
 * The trace calls pass the host pointers self+4 (an address of `self`) and the 32-bit values the original pushes. */
int32_t m449bff_resume_thread(uint8_t *self, const Fl27bWorld *world, const Fl18Host *host)
{
    uint32_t obj, result;
    if (rd32(self, 0x36) == 0) return 0;
    obj = rd32(self, 0x36);
    result = call1(host, 0x52a284, 0, rd32(object_at(host, obj), 0x28));
    if (debug_on(world)) {
        calln(host, 0x50ca3e, 0, 5, 0x63888b, 0x5489e4, rd32(self, 0x3a), (uintptr_t)(self + 4), result);
        call1(host, 0x44a2b7, 0, 0x63888b);
    }
    if (result == 0xffffffffu) {
        call1(host, 0x4264e8, 0x583979, 0x548a38);
        call0(host, 0x4c97b4, 0x5cf659);
        return 0;
    }
    while (result > 1u) {
        obj = rd32(self, 0x36);
        result = call1(host, 0x52a284, 0, rd32(object_at(host, obj), 0x28));
        if (debug_on(world)) {
            calln(host, 0x50ca3e, 0, 5, 0x63888b, 0x548a54, rd32(self, 0x3a), (uintptr_t)(self + 4), result);
            call1(host, 0x44a2b7, 0, 0x63888b);
        }
        /* native rejection: the original would call the import again for ever (0xffffffff is above 1) */
        if (result == 0xffffffffu) return 1;
    }
    wr32(self, 0x42, 2);
    return 0;
}

/* ---- 0x449a94 ------------------------------------------------------------------------------------------------------------------ */

/* 0x449a94, plain ret: see the header. [ebp-4] is the dword `code` that the import 0x52a280 stores through its second argument, [ebp-0x68] a 100-byte trace buffer. The
 * object address [self+0x36] is read again at the loop head, and for the stores after the loop. The virtual call: ecx = the object, the function is the dword at
 * [vtable + 0x78] with vtable = the dword at [object]. */
int32_t m449a94_stop_thread(uint8_t *self, const Fl27bWorld *world, const Fl18Host *host)
{
    uint32_t code = 0;
    uint8_t text[100];
    uint32_t obj, result;
    if (rd32(self, 0x36) == 0) return 0;
    if (rd32(self, 0x36) != 0 && rd32(self, 0x42) == 1) {
        call0(host, 0x449bff, (uintptr_t)self);
        call1(host, 0x52a2b0, 0, 0);
    }
    wr32(self, 0x3e, 1);
    call1(host, 0x52a2b0, 0, 0);
    while (rd32(self, 0x36) != 0) {
        result = call2(host, 0x52a280, 0, rd32(object_at(host, rd32(self, 0x36)), 0x28), (uintptr_t)&code);
        if (result != 0) {
            if (code == 0) break;
        } else if (debug_on(world)) {
            uint32_t t = call0(host, 0x426367, 0x583979);
            call1(host, 0x44a2b7, 0, t);
        }
        call1(host, 0x52a2b0, 0, 0);
    }
    obj = rd32(self, 0x36);
    /* native rejection: with [self+0x36] zero the original stores 1 at address 0x24 (an access violation); here nothing more is done */
    if (obj == 0) return 1;
    wr32(object_at(host, obj), 0x24, 1);
    obj = rd32(self, 0x36);
    {
        uint32_t vtable = rd32(object_at(host, obj), 0);
        call0(host, rd32(object_at(host, vtable), 0x78), obj);
    }
    wr32(self, 0x36, 0);
    wr32(self, 0x42, 3);
    if (debug_on(world)) {
        calln(host, 0x50ca3e, 0, 4, (uintptr_t)text, 0x5489a0, rd32(self, 0x3a), (uintptr_t)(self + 4), 0);
        call1(host, 0x44a2b7, 0, (uintptr_t)text);
    }
    return 0;
}

/* ---- 0x4bf773 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4bf773, plain ret: see the header. [ebp-0xc] is `self`, [ebp-8] / [ebp-4] the object address [self+0x1d6], and [ebp-0x10] the result of the virtual call (unused afterwards). A
 * zero object address skips the virtual call (the original stores 0 into [ebp-0x10]). The deleting-destructor call pushes the flag 1 and the callee pops it (thiscall). */
void m4bf773_release_player(uint8_t *self, const Fl27bWorld *world, const Fl18Host *host)
{
    if (rd32(self, 0x1d6) != 0) {
        uint32_t obj;
        call1(host, 0x44c479, 0, (uintptr_t)(self + 4));
        wr32(self, 4, 2);
        call0(host, 0x449a94, rd32(self, 0x1d6));
        obj = rd32(self, 0x1d6);
        if (obj != 0) {
            uint32_t vtable = rd32(object_at(host, obj), 0);
            call1(host, rd32(object_at(host, vtable), 0), obj, 1);
        }
        wr32(self, 0x1d6, 0);
        call1(host, 0x44c4ab, 0, (uintptr_t)(self + 4));
        wr32(self, 4, 0);
    }
    if (debug_on(world)) call1(host, 0x44a2b7, 0, 0x5525dc);
    call1(host, 0x415011, 0x5e2dbe, (uintptr_t)(self + 8));
    if (debug_on(world)) call1(host, 0x44a2b7, 0, 0x552620);
    if (rd32(self, 0x222) != 0) call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x222));
    if (debug_on(world)) call1(host, 0x44a2b7, 0, 0x552664);
    call1(host, 0x41632b, 0x5e2dbe, (uintptr_t)(self + 8));
    call1(host, 0x4bedfa, 0x6201f9, (uintptr_t)(self + 0x18e));
}

/* ---- 0x4161d1 ------------------------------------------------------------------------------------------------------------------ */

/* the failure path shared by the three allocation sites (the same instructions, three copies in the original): 0x50ca3e(0x63888b, format); 0x52139c(0x63888b, 0, 0); [0x63a58a] = 4; 0x4c97b4 */
static void alloc_failed(Fl27bWorld *world, const Fl18Host *host, uintptr_t format)
{
    call2(host, 0x50ca3e, 0, 0x63888b, format);
    calln(host, 0x52139c, 0, 3, 0x63888b, 0, 0, 0, 0);
    world->value_63a58a = 4;
    call0(host, 0x4c97b4, 0x5cf659);
}

/* 0x4161d1, `ret 4`: see the header. [ebp-0x14] holds the dword kind [arg+0x172] (compared with 0, then with 1); [ebp-4] / [ebp-8] / [ebp-0xc] hold the three allocation results. */
void m4161d1_alloc_buffers(uint8_t *arg, Fl27bWorld *world, const Fl18Host *host)
{
    uint32_t kind = rd32(arg, 0x172);
    uint32_t p;
    if (kind == 0) {
        p = call1(host, 0x51dc43, 0, rd32(arg, 0x1c8));
        wr32(arg, 0x17a, p);
        if (p == 0) alloc_failed(world, host, 0x541e7c);
    } else if (kind == 1) {
        p = call1(host, 0x51dc43, 0, rd32(arg, 0x1c8));
        wr32(arg, 0x17a, p);
        if (p == 0) alloc_failed(world, host, 0x541ed4);
        p = call1(host, 0x51dc43, 0, rd32(arg, 0x1c8));
        wr32(arg, 0x17e, p);
        if (p == 0) alloc_failed(world, host, 0x541f2c);
    }
    wr16(arg, 0x182, 0);
    wr16(arg, 0x184, 0);
}

/* ---- 0x4c2c3a ------------------------------------------------------------------------------------------------------------------ */

static uint32_t strlen_at(const uint8_t *s)
{
    uint32_t n = 0;
    while (s[n] != 0) n++;
    return n;
}

/* 0x4c2c3a, `ret 0x14`: see the header. [ebp-0xc] / [ebp-8] hold the record address, [ebp-4] the size (the 32-bit `imul` chain a * w * b of sign-extended words), [ebp-0x10] the second allocation,
 * [ebp-0x14] the `this`. The two `repne scasb` give the string length (`not ecx; add ecx, -1`), the compare with 0x19 is unsigned (`jb`). The copy is `rep movsd` + `rep movsb` of length + 1 bytes. */
uint32_t m4c2c3a_make_record(uint8_t *self, int16_t a, int16_t b, uint32_t v10, uint32_t flags, uint32_t name, const Fl27bWorld *world, const Fl18Host *host)
{
    uint32_t p = call1(host, 0x51dc43, 0, 0x59);
    uint32_t size, len;
    uint8_t *rec, *str;
    if (p == 0) {
        call2(host, 0x42639d, 0x583979, 0x553e68, name);
        call0(host, 0x4c97b4, (uintptr_t)self);
        return 0;
    }
    rec = object_at(host, p);
    memset(rec, 0, 0x59);
    size = (uint32_t)(int32_t)a * (uint32_t)(int32_t)world->word_639895 * (uint32_t)(int32_t)b;
    if ((flags & 1u) == 0) {
        uint32_t q = call1(host, 0x51dc43, 0, size);
        wr32(rec, 0, q);
        if (q == 0) {
            call2(host, 0x42639d, 0x583979, 0x553ec0, name);
            call0(host, 0x4c97b4, (uintptr_t)self);
            return 0;
        }
    } else {
        wr32(rec, 0, 0);
    }
    str = object_at(host, name);
    len = strlen_at(str);
    if (len >= 0x19u) str[0x18] = 0;
    memcpy(rec + 8, str, strlen_at(str) + 1u);
    wr32(rec, 4, v10);
    wr16(rec, 0x21, 0x59);
    wr32(rec, 0x23, size);
    wr32(rec, 0x27, size + 0x59u);
    wr16(rec, 0x2b, (uint16_t)a);
    wr16(rec, 0x2d, (uint16_t)b);
    wr16(rec, 0x2f, (uint16_t)((uint32_t)(int32_t)a * (uint32_t)(int32_t)world->word_639895));
    wr16(rec, 0x31, (uint16_t)b);
    wr16(rec, 0x33, (uint16_t)world->word_639893);
    wr32(rec, 0x55, flags);
    wr32(rec, 0x35, 0);
    wr32(rec, 0x39, 0);
    wr32(rec, 0x3d, (uint32_t)(int32_t)a - 1u);
    wr32(rec, 0x41, (uint32_t)(int32_t)b - 1u);
    wr32(rec, 0x45, 0);
    wr32(rec, 0x49, 0);
    wr32(rec, 0x4d, 0);
    wr32(rec, 0x51, 0);
    return p;
}

/* ---- 0x4c0d3f ------------------------------------------------------------------------------------------------------------------ */

/* 0x4c0d3f, plain ret: see the header. [ebp-4] = 0x637fd7 (the player object), [ebp-8] = 0x6381ad (B, player + 0x1d6), [ebp-0x20] = 0x6381bd (C, player + 0x1e6), [ebp-0x1c] = 0x583122 (D). The
 * four locals [ebp-0x30 .. -0x24] are the intersection (x0, y0, x1, y1), the four at [ebp-0x18 .. -0xc] the translated rectangle; every compare of the rectangles is signed (`jg`, `jl`, `jge`, `jle`), the sums wrap. */
void m4c0d3f_present_rect(Fl27bWorld *world, const Fl18Host *host)
{
    uint8_t *player = world->player_637fd7;
    const uint8_t *bb = player + 0x1d6, *cc = player + 0x1e6, *dd = world->rect_583122;
    int32_t isect[4], out[4];
    if (rd32(player, 0x20e) != 0) {
        wr32(player, 0x20e, 0);
        calln(host, 0x4c5377, 0x5cf659, 5, world->value_5d19ef, world->value_5cf665, world->value_5d19f3, world->value_5d19f7, 0x552b7c);
        if (rd32(player, 0x216) == 0) wr16(player, 0x1cc, 0);
        return;
    }
    if (rd32(player, 0x212) == 0) return;
    if (!((rd32(player, 0x176) == 0 && rd32(player, 0x172) == 1) || rd32(player, 0x176) == 1)) return;
    if (rds32(dd, 0) > rds32(cc, 8)) return;
    if (rds32(dd, 8) < rds32(cc, 0)) return;
    if (rds32(dd, 4) > rds32(cc, 0xc)) return;
    if (rds32(dd, 0xc) < rds32(cc, 4)) return;
    isect[0] = rds32(dd, 0) < rds32(cc, 0) ? rds32(cc, 0) : rds32(dd, 0);
    isect[2] = rds32(dd, 8) > rds32(cc, 8) ? rds32(cc, 8) : rds32(dd, 8);
    isect[1] = rds32(dd, 4) < rds32(cc, 4) ? rds32(cc, 4) : rds32(dd, 4);
    isect[3] = rds32(dd, 0xc) > rds32(cc, 0xc) ? rds32(cc, 0xc) : rds32(dd, 0xc);
    out[0] = (int32_t)((uint32_t)isect[0] - rd32(cc, 0) + rd32(bb, 0));
    out[2] = (int32_t)((uint32_t)isect[2] - rd32(cc, 0) + rd32(bb, 0));
    out[1] = (int32_t)((uint32_t)isect[1] - rd32(cc, 4) + rd32(bb, 4));
    out[3] = (int32_t)((uint32_t)isect[3] - rd32(cc, 4) + rd32(bb, 4));
    calln(host, 0x4c5377, 0x5cf659, 5, world->value_5d19ef, world->value_5cf665, (uintptr_t)out, (uintptr_t)isect, 0x552b90);
}

/* ---- 0x4c5377 ------------------------------------------------------------------------------------------------------------------ */


/* `rep movsd` (count / 4 dwords) then `rep movsb` (count % 4 bytes), forward, a dword read before it is written: the same result as the original where the two blocks overlap */
static void rep_movs(uint8_t *dst, const uint8_t *src, uint32_t count)
{
    uint32_t k, dwords = count >> 2, bytes = count & 3u;
    for (k = 0; k < dwords; k++) {
        uint32_t v;
        memcpy(&v, src, 4);
        memcpy(dst, &v, 4);
        src += 4;
        dst += 4;
    }
    for (k = 0; k < bytes; k++) *dst++ = *src++;
}

/* 0x4c5377, `ret 0x14`: see the header. Locals of the original: [ebp-0x1a0] this, [ebp-0x19c] / [ebp-0x198] the r1 extents, [ebp-0x94] / [ebp-0x194] the r2 extents, [ebp-0x190] the 0x fb-byte text,
 * [ebp-0x90] the row counter i, [ebp-0x8c] h, [ebp-0x88] the descriptor desc (+0x10 = [ebp-0x78] the stride, +0x24 = [ebp-0x64] the destination), [ebp-0xc] rowbytes, [ebp-8] src, [ebp-4] dst. The
 * row loop compares `i` and `h` as signed dwords (`jge`); `shr ecx, 2` and the `and ecx, 3` make the copy counts unsigned. */
int32_t m4c5377_blit_rows(uint8_t *self, uint32_t surf, uint32_t idx, uint32_t r1, uint32_t r2, uint32_t arg, const Fl27bWorld *world, const Fl18Host *host)
{
    uint8_t text[0xfb];
    uint8_t desc[0x7c];
    const uint8_t *a = object_at(host, r1), *b = object_at(host, r2);
    uint8_t *sm;
    int32_t h, i;
    uint32_t rowbytes, src, dst, bpp;
    if (debug_on(world)) {
        uint32_t d1x = rd32(a, 8) - rd32(a, 0), d1y = rd32(a, 0xc) - rd32(a, 4), d2x = rd32(b, 8) - rd32(b, 0), d2y = rd32(b, 0xc) - rd32(b, 4);
        if (!(d1x == d2x && d1y == d2y && surf != 0 && idx != 0)) {
            uintptr_t args[11];
            memset(text, 0, sizeof text);
            args[0] = (uintptr_t)text;
            args[1] = 0x5548ec;
            args[2] = arg;
            args[3] = rd32(a, 0);
            args[4] = rd32(a, 4);
            args[5] = rd32(a, 8);
            args[6] = rd32(a, 0xc);
            args[7] = rd32(b, 0);
            args[8] = rd32(b, 4);
            args[9] = rd32(b, 8);
            args[10] = rd32(b, 0xc);
            callv(host, 0x50ca3e, 0, args, 11);
            calln(host, 0x52139c, 0, 3, (uintptr_t)text, 0, 0, 0, 0);
            call0(host, 0x4c97b4, (uintptr_t)self);
            return 0;
        }
    }
    if (surf == 0) return 1;      /* native rejection: the original reads the word at address 0x2f */
    sm = object_at(host, surf);
    bpp = (uint32_t)(int32_t)world->word_639895;
    src = rd32(sm, 0) + rd32(a, 4) * (uint32_t)(int32_t)(int16_t)rd16(sm, 0x2f) + rd32(a, 0) * bpp;
    memset(desc, 0, sizeof desc);
    {
        uintptr_t args[5];
        args[0] = idx;
        args[1] = r2;
        args[2] = (uintptr_t)desc;
        args[3] = arg;
        args[4] = 0x20;
        callv(host, 0x4c4067, (uintptr_t)self, args, 5);
    }
    h = (int32_t)(rd32(a, 0xc) - rd32(a, 4) + 1u);
    rowbytes = (rd32(a, 8) - rd32(a, 0) + 1u) * bpp;
    dst = rd32(desc, 0x24);
    if (h > 0 && rowbytes > 0x7fffffffu) return 1;      /* native rejection: the original copies ~4 GB */
    for (i = 0; i < h; i++) {
        rep_movs(rowbytes != 0 ? object_at(host, dst) : NULL, rowbytes != 0 ? object_at(host, src) : NULL, rowbytes);
        src += (uint32_t)(int32_t)(int16_t)rd16(sm, 0x2f);
        dst += rd32(desc, 0x10);
    }
    calln(host, 0x4c4202, (uintptr_t)self, 3, idx, r2, 0x554990, 0, 0);
    if (idx == rd32(self, 0xc)) call1(host, 0x4c952f, (uintptr_t)self, r2);
    return 0;
}

/* ---- 0x4c04e3 ------------------------------------------------------------------------------------------------------------------ */

/* the sequence that states 0 and 4 share (0x4befc8 .. 0x4c08d3), with the stores in the original order; `first` selects the state-0 store [self+0x21a] = 1 */
static void start_sequence(uint8_t *self, const Fl18Host *host, int first)
{
    uint32_t r;
    call1(host, 0x4befc8, 0x6201f9, rd32(self, 0x18e));
    {
        uintptr_t args[6];
        args[0] = rd32(self, 0x18e);
        args[1] = rd32(object_at(host, rd32(self, 0x222)), 0);
        args[2] = (uint32_t)(int32_t)(int16_t)rd16(object_at(host, rd32(self, 0x222)), 0x2f);
        args[3] = (uint32_t)(int32_t)(int16_t)rd16(object_at(host, rd32(self, 0x222)), 0x2d);
        args[4] = 0;
        args[5] = 0;
        callv(host, 0x4bf098, 0x6201f9, args, 6);
    }
    r = call1(host, 0x4bee2c, 0x6201f9, rd32(self, 0x18e));
    wr16(self, 0x244, (uint16_t)(r - 1u));
    call0(host, 0x4c0ab1, (uintptr_t)self);
    wr32(self, 0x216, 1);
    wr32(self, 0x240, 2);
    if (first) wr32(self, 0x21a, 1);
    call0(host, 0x4c08d3, (uintptr_t)self);
}

/* 0x4c04e3, `ret 4`: see the header. [ebp-4] is `self`, [ebp-8] the state dword (compared with 0, then with 4). The object [self+0x222] and the handle [self+0x18e] are read again at every use. */
void m4c04e3_start_movie(uint8_t *self, int16_t rec, const Fl27bWorld *world, const Fl18Host *host)
{
    uint32_t state = rd32(self, 0x1da);
    if (state == 0) {
        if (debug_on(world)) {
            call2(host, 0x50ca3e, 0, 0x63888b, 0x5529e0);
            call1(host, 0x44a2b7, 0, 0x63888b);
        }
        if (call1(host, 0x4bef85, 0x6201f9, rd32(self, 0x18e)) == 0) return;
        start_sequence(self, host, 1);
        if (call1(host, 0x4bf10f, 0x6201f9, rd32(self, 0x18e)) != 0) {
            wr32(self, 0x1da, 4);
            if (debug_on(world)) call1(host, 0x44a2b7, 0, 0x552a14);
        } else {
            wr32(world->records_5bb5e5, (ptrdiff_t)((int32_t)rec * 0x8d + 0x4d), 2);
            if (debug_on(world)) call1(host, 0x44a2b7, 0, 0x552a58);
        }
    } else if (state == 4) {
        if (call1(host, 0x4bef85, 0x6201f9, rd32(self, 0x18e)) == 0) return;
        start_sequence(self, host, 0);
        if (call1(host, 0x4bf10f, 0x6201f9, rd32(self, 0x18e)) == 0) {
            wr32(world->records_5bb5e5, (ptrdiff_t)((int32_t)rec * 0x8d + 0x4d), 2);
            if (debug_on(world)) call1(host, 0x44a2b7, 0, 0x552ac4);
        }
    }
}

/* ---- 0x415db9 ------------------------------------------------------------------------------------------------------------------ */

/* 0x415db9, `ret 8`: see the header. Locals of the original: [ebp-0x1c] the input pointer, [ebp-0x1050] the length, [ebp-0x1054] the output pointer, [ebp-0x14] the ring (0x1000 bytes), [ebp-0x10] the byte
 * counter, [ebp-0x18] the output index, [ebp-0x24] the input index (starts at 0xffffffff), [ebp-4] the flags, [ebp-8] the ring write position, [ebp-0x28] the byte just read. The frame also holds the stack
 * probe `call 0x50c920` (`_chkstk` for 0x1058 bytes), which has no effect on the data. */
int32_t m415db9_unpack(uint8_t *arg, int16_t index, const Fl18Host *host)
{
    uint8_t ring[0x1000];
    const uint8_t *in, *table;
    uint8_t *out;
    uint32_t length, flags = 0, idx = 0xffffffffu, w, k, out_i = 0, position, count;
    uint8_t counter = 0, c, c2;
    length = rd32(arg, 0x39);
    if (length > 0x7fffffffu) return 1;      /* native rejection */
    table = object_at(host, rd32(arg, 0x21));
    in = object_at(host, rd32(arg, 0x2d) + rd32(table, (ptrdiff_t)((int32_t)index * 0x13 + 2)));
    out = object_at(host, rd32(arg, 0x35));
    memset(ring, 0, sizeof ring);
    memset(ring, 0x20, 0x1000 - 0x12);
    w = 0x1000 - 0x12;
    for (;;) {
        flags >>= 1;
        if ((flags & 0x100u) == 0) {
            idx++;
            if (idx == length) return 0;
            c = (uint8_t)(in[idx] - counter);
            counter++;
            flags = (uint32_t)c | 0xff00u;
        }
        if ((flags & 1u) != 0) {
            idx++;
            if (idx == length) return 0;
            c = (uint8_t)(in[idx] - counter);
            counter++;
            out[out_i++] = c;
            ring[w] = c;
            w = (w + 1u) & 0xfffu;
        } else {
            idx++;
            if (idx == length) return 0;
            c = (uint8_t)(in[idx] - counter);
            counter++;
            position = c;
            idx++;
            if (idx == length) return 0;
            c2 = (uint8_t)(in[idx] - counter);
            counter++;
            position |= ((uint32_t)c2 & 0xf0u) << 4;
            count = ((uint32_t)c2 & 0xfu) + 2u;
            for (k = 0; k <= count; k++) {
                c = ring[(position + k) & 0xfffu];
                out[out_i++] = c;
                ring[w] = c;
                w = (w + 1u) & 0xfffu;
            }
        }
    }
}
