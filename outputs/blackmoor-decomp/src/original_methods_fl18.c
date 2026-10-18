#include "original_methods_fl18.h"

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

static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, NULL, 0) : 0;
}

static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    uintptr_t args[1];
    args[0] = a0;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 1) : 0;
}

static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    uintptr_t args[2];
    args[0] = a0;
    args[1] = a1;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 2) : 0;
}

static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    uintptr_t args[3];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 3) : 0;
}

static uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2,
                      uintptr_t a3)
{
    uintptr_t args[4];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    args[3] = a3;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 4) : 0;
}

static uint32_t call8(const Fl18Host *host, uint32_t callee, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3, uintptr_t a4,
                      uintptr_t a5, uintptr_t a6, uintptr_t a7)
{
    uintptr_t args[8];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    args[3] = a3;
    args[4] = a4;
    args[5] = a5;
    args[6] = a6;
    args[7] = a7;
    return host->call != NULL ? host->call(host->context, callee, 0, args, 8) : 0;
}

static uint32_t call5(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2,
                      uintptr_t a3, uintptr_t a4)
{
    uintptr_t args[5];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    args[3] = a3;
    args[4] = a4;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 5) : 0;
}

/* The value that 0x45b7a8, 0x4b6097 and 0x4b81ff store in dword 0x5d1631: 0x5b160c + (dword 0x5b44f0 << 5) + (dword 0x5b44f4 << 4)
 * (a 32-bit address). Each function stores the globals in its own order, so this only computes it. */
static uint32_t hotspot_address(const Fl18World *world)
{
    return 0x5b160cu + (world->value_5b44f0 << 5) + (world->value_5b44f4 << 4);
}

/* original GAME.EXE 0x4c924d (FUN_004c924d), stack argument index (signed word): when the signed word 0x5afbda[index] is 0 and
 * the dword 0x5d032f[index] is 0, calls 0x4c2790 on the surface manager 0x5cf659 with the four arguments 0x557adc,
 * 0x5a4c24 + index * 0x7f3, 6, 0x557acc (first to last) and stores the result in the dword 0x5d032f[index]. Always (the word is
 * read again) word 0x5afbda[index] := that word + 1. */
void m4c924d_count_up(int16_t index, const Fl18World *world, const Fl18Host *host)
{
    if ((int16_t)rd16(world->words_5afbda, (ptrdiff_t)index * 2) == 0 && rd32(world->dwords_5d032f, (ptrdiff_t)index * 4) == 0) {
        uint32_t result = call4(host, 0x4c2790, 0x5cf659, 0x557adc, 0x5a4c24u + (uint32_t)((int32_t)index * 0x7f3), 6, 0x557acc);
        wr32(world->dwords_5d032f, (ptrdiff_t)index * 4, result);
    }
    wr16(world->words_5afbda, (ptrdiff_t)index * 2, (uint16_t)(rd16(world->words_5afbda, (ptrdiff_t)index * 2) + 1));
}

/* original GAME.EXE 0x4121b8 (FUN_004121b8), this = self, stack argument index (signed word): rec = the dword of the 0x5bb5e5-based
 * record `index` (stride 0x8d). dword [self+0x102a] := 0; 0x413187 on self with (rec, rec + 0x210, 0, 0); 0x42ba3a (cdecl) with
 * the word index; 0x411b16 on self with (rec, the word index, 0). */
void m4121b8_start_piece(uint8_t *self, int16_t index, const Fl18World *world, const Fl18Host *host)
{
    uint32_t rec = rd32(world->records_5bb5e5, (ptrdiff_t)index * 0x8d);
    wr32(self, 0x102a, 0);
    call4(host, 0x413187, (uintptr_t)self, rec, rec + 0x210u, 0, 0);
    call1(host, 0x42ba3a, 0, (uint16_t)index);
    call3(host, 0x411b16, (uintptr_t)self, rec, (uint16_t)index, 0);
}

/* original GAME.EXE 0x4e7bf3 (FUN_004e7bf3), this = self: dword [self+0x822e] := 0; while the signed dword [self+0x822e] < 6
 * (re-read on every pass): when the dword [self + i * 0xf7 + 0x7012] (i = [self+0x822e]) is non-zero calls 0x4e1d34 on
 * self + i * 0x18f + 0x7654; then [self+0x822e] += 1 (read again). Finally 0x4e7ba7 on self. */
void m4e7bf3_close_slots(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0x822e, 0);
    while ((int32_t)rd32(self, 0x822e) < 6) {
        uint32_t i = rd32(self, 0x822e);
        if (rd32(self, (ptrdiff_t)(int32_t)i * 0xf7 + 0x7012) != 0)
            call0(host, 0x4e1d34, (uintptr_t)(self + (ptrdiff_t)(int32_t)i * 0x18f + 0x7654));
        wr32(self, 0x822e, rd32(self, 0x822e) + 1u);
    }
    call0(host, 0x4e7ba7, (uintptr_t)self);
}

/* original GAME.EXE 0x4b7051 (FUN_004b7051): rec = the dword of the 0x5bb5e5-based record at the signed word 0x61d467 (stride
 * 0x8d), read once. For i = 0 while i < the signed word [rec+0x21] (re-read on every pass): 0x4c5377 on 0x5cf659 with the five
 * arguments dword 0x5d1599[signed word 0x61d465 * 0x4a], dword 0x5cf665, 0x61d46d + i * 16, 0x61d56d + i * 16, 0x551bb0 (first to
 * last as the callee sees them). */
void m4b7051_draw_list(const Fl18World *world, const Fl18Host *host)
{
    uint32_t rec = rd32(world->records_5bb5e5, (ptrdiff_t)world->word_61d467 * 0x8d);
    int32_t i;
    for (i = 0; i < (int16_t)rd16(host->resolve(host->context, rec), 0x21); i++)
        call5(host, 0x4c5377, 0x5cf659, rd32(world->table_5d1599, (ptrdiff_t)world->word_61d465 * 0x4a), world->value_5cf665,
              0x61d46du + (uint32_t)i * 16u, 0x61d56du + (uint32_t)i * 16u, 0x551bb0);
}

/* original GAME.EXE 0x4b7f3b (FUN_004b7f3b), this = self: words [self+6], [self+4] := 0xffff; dwords [self+8], [self+0x14],
 * [self+0x18], [self+0x20], [self+0x1c], [self+0x34], [self+0xc] := 0; the four dwords from [self+0x54e] := 0; the 0x2e dwords
 * from [self+0x496] := 0 and the 0x32 dwords from [self+0x55e] := 0 (in this order, so the last two stores overwrite); dwords
 * [self+0x61e], [self+0x546] := 0xffffffff. */
void m4b7f3b_reset(uint8_t *self)
{
    wr16(self, 6, 0xffff);
    wr16(self, 4, 0xffff);
    wr32(self, 8, 0);
    wr32(self, 0x14, 0);
    wr32(self, 0x18, 0);
    wr32(self, 0x20, 0);
    wr32(self, 0x1c, 0);
    wr32(self, 0x34, 0);
    wr32(self, 0xc, 0);
    wr32(self, 0x54e, 0);
    wr32(self, 0x552, 0);
    wr32(self, 0x556, 0);
    wr32(self, 0x55a, 0);
    memset(self + 0x496, 0, 0x2e * 4);
    memset(self + 0x55e, 0, 0x32 * 4);
    wr32(self, 0x61e, 0xffffffffu);
    wr32(self, 0x546, 0xffffffffu);
}

/* original GAME.EXE 0x4b7ff4 (FUN_004b7ff4), this = self: when the dword [self+0xc] is non-zero 0x4c2dfb on the surface manager
 * 0x5cf659 with the address of [self+0xc]; 0x4d3992 (cdecl) with the word [self+4] when that signed word is not -1, with the word
 * [self+0x61e] and with the word [self+0x546] when those dwords are not -1; 0x4c92c5 on 0x5cf659 with 0xa; then 0x4b7f3b on self
 * (FL-18, direct). */
void m4b7ff4_release(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0xc) != 0) call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0xc));
    if ((int16_t)rd16(self, 4) != -1) call1(host, 0x4d3992, 0, rd16(self, 4));
    if (rd32(self, 0x61e) != 0xffffffffu) call1(host, 0x4d3992, 0, rd16(self, 0x61e));
    if (rd32(self, 0x546) != 0xffffffffu) call1(host, 0x4d3992, 0, rd16(self, 0x546));
    call1(host, 0x4c92c5, 0x5cf659, 0xa);
    m4b7f3b_reset(self);
}

/* original GAME.EXE 0x4e7253 (FUN_004e7253), this = self, stack argument index (signed word): rec = the dword of the 0x5bb5e5-based
 * record `index` (stride 0x8d). local := 0x4e45be on self with (&local, rec + 2, 1, 0xb). When it returns non-zero the 0x29 bytes at
 * rec are copied to 0x5a1e62 + (signed word local) * 0x29; otherwise to 0x5a1e62 + (signed word 0x5a1e5c) * 0x29 and the word
 * 0x5a1e5c is incremented. Then 0x4e3ade on self and 0x4e0559 on 0x570508 with (3, 1, 0). */
void m4e7253_store_record(uint8_t *self, int16_t index, Fl18World *world, const Fl18Host *host)
{
    uint32_t rec = rd32(world->records_5bb5e5, (ptrdiff_t)index * 0x8d);
    uint32_t local = 0;
    if (call4(host, 0x4e45be, (uintptr_t)self, (uintptr_t)&local, rec + 2u, 1, 0xb) != 0) {
        memcpy(world->table_5a1e62 + (ptrdiff_t)(int16_t)(local & 0xffffu) * 0x29, host->resolve(host->context, rec), 0x29);
        call0(host, 0x4e3ade, (uintptr_t)self);
    } else {
        memcpy(world->table_5a1e62 + (ptrdiff_t)(int16_t)world->word_5a1e5c * 0x29, host->resolve(host->context, rec), 0x29);
        world->word_5a1e5c = (uint16_t)(world->word_5a1e5c + 1);
        call0(host, 0x4e3ade, (uintptr_t)self);
    }
    call3(host, 0x4e0559, 0x570508, 3, 1, 0);
}

/* original GAME.EXE 0x4e8dc8 (FUN_004e8dc8), this = self: nothing unless the dword [self+0x764c] is 2 or 3. Returns when 0x4ee517 on
 * self returns non-zero. Then dword [self+0x822e] := 0 and, while the signed dword [self+0x822e] < 6 (re-read), when the dword
 * [self + i * 0xf7 + 0x7012] is non-zero: returns when 0x4e26fc on self + i * 0x18f + 0x7654 returns non-zero; then
 * [self+0x822e] += 1 (read again). At the end 0x4e8e78 on self. */
void m4e8dc8_check_slots(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x764c) != 2 && rd32(self, 0x764c) != 3) return;
    if (call0(host, 0x4ee517, (uintptr_t)self) != 0) return;
    wr32(self, 0x822e, 0);
    while ((int32_t)rd32(self, 0x822e) < 6) {
        uint32_t i = rd32(self, 0x822e);
        if (rd32(self, (ptrdiff_t)(int32_t)i * 0xf7 + 0x7012) != 0) {
            if (call0(host, 0x4e26fc, (uintptr_t)(self + (ptrdiff_t)(int32_t)i * 0x18f + 0x7654)) != 0) return;
        }
        wr32(self, 0x822e, rd32(self, 0x822e) + 1u);
    }
    call0(host, 0x4e8e78, (uintptr_t)self);
}

/* original GAME.EXE 0x45b7a8 (FUN_0045b7a8), this = self, stack arguments a, b (signed words). When a is 0x27bb: dword 0x5d162d :=
 * dword 0x5d0377; 0x5b44f0 := 9; 0x5b44f4 := 1. Otherwise: 0x5b44f0 := 0x16; 0x5b44f4 := 1; 0x5d162d := dword 0x5d0377. Both then
 * 0x5d1631 := 0x5b160c + (0x5b44f0 << 5) + (0x5b44f4 << 4); 0x5d1639 := 1; 0x5c39e5 := a (sign-extended); the other branch ends with
 * word [self+0x172] := b. */
void m45b7a8_arm_hotspot(uint8_t *self, int16_t a, int16_t b, Fl18World *world)
{
    if (a == 0x27bb) {
        world->value_5d162d = world->value_5d0377;
        world->value_5b44f0 = 9;
        world->value_5b44f4 = 1;
        world->value_5d1631 = hotspot_address(world);
        world->value_5d1639 = 1;
        world->value_5c39e5 = (uint32_t)(int32_t)a;
    } else {
        world->value_5b44f0 = 0x16;
        world->value_5b44f4 = 1;
        world->value_5d162d = world->value_5d0377;
        world->value_5d1631 = hotspot_address(world);
        world->value_5d1639 = 1;
        world->value_5c39e5 = (uint32_t)(int32_t)a;
        wr16(self, 0x172, (uint16_t)b);
    }
}

/* original GAME.EXE 0x4b81ff (FUN_004b81ff), this = self, stack arguments x, y (signed words); obj = the object that the dword
 * [self+8] addresses. Returns 0 when the dword [self+0x14] is 0, or y < the signed dword [obj+0x562], y > [obj+0x56a], x <
 * [obj+0x55e] or x > [obj+0x566]. Otherwise dword 0x5d162d := dword 0x5d0377; 0x5b44f0 := the signed word [obj+0x55c]; 0x5b44f4 := 1;
 * 0x5d1631 := 0x5b160c + (0x5b44f0 << 5) + (0x5b44f4 << 4); 0x5d1639 := 1; 0x5c39e5 := 0x27eb; returns 1. */
int32_t m4b81ff_hit_test(uint8_t *self, int16_t x, int16_t y, Fl18World *world, const Fl18Host *host)
{
    const uint8_t *obj;
    if (rd32(self, 0x14) == 0) return 0;
    obj = host->resolve(host->context, rd32(self, 8));
    if ((int32_t)y < (int32_t)rd32(obj, 0x562)) return 0;
    if ((int32_t)y > (int32_t)rd32(obj, 0x56a)) return 0;
    if ((int32_t)x < (int32_t)rd32(obj, 0x55e)) return 0;
    if ((int32_t)x > (int32_t)rd32(obj, 0x566)) return 0;
    world->value_5d162d = world->value_5d0377;
    world->value_5b44f0 = (uint32_t)(int32_t)(int16_t)rd16(obj, 0x55c);
    world->value_5b44f4 = 1;
    world->value_5d1631 = hotspot_address(world);
    world->value_5d1639 = 1;
    world->value_5c39e5 = 0x27ebu;
    return 1;
}

/* original GAME.EXE 0x423b51 (FUN_00423b51), this = self, stack argument index (dword): 0x4234c8 on self. p = the address of the
 * record 0x5bb5e9 + index * 0x8d; slot := p (a local); when the dword [p+4] is non-zero calls 0x423876 on self with (&slot, 0).
 * Then the dwords [p+0x1c] .. [p+0x38] (eight, step 4) := 0 and, through the slot as it is after the call, the dwords [slot+0], [slot+4]
 * := 0, [slot+8] := 0xffffffff, [slot+0xc], [slot+0x10], [slot+0x14], [slot+0x18] := 0. */
void m423b51_reset_record(uint8_t *self, int32_t index, const Fl18World *world, const Fl18Host *host)
{
    uint8_t *p, *slot;
    int off;
    call0(host, 0x4234c8, (uintptr_t)self);
    p = world->records_5bb5e5 + 4 + (ptrdiff_t)index * 0x8d;
    slot = p;
    if (rd32(slot, 4) != 0) call2(host, 0x423876, (uintptr_t)self, (uintptr_t)&slot, 0);
    for (off = 0x1c; off <= 0x38; off += 4) wr32(p, off, 0);
    wr32(slot, 0, 0);
    wr32(slot, 4, 0);
    wr32(slot, 8, 0xffffffffu);
    wr32(slot, 0xc, 0);
    wr32(slot, 0x10, 0);
    wr32(slot, 0x14, 0);
    wr32(slot, 0x18, 0);
}

/* original GAME.EXE 0x4cc79a (FUN_004cc79a): list = the dword 0x63848d (read once; an address of the original). Nothing unless the
 * dword 0x638483 is non-zero. Then the word w := 0x10 and, for i = 0 while i < the signed word [list+2] (re-read): e = the entry
 * i * 0x18 of the array that the dword [list+9] addresses (re-read); the rectangle {x0, y0, x1, y1} (four dwords) =
 * {[e+4] + dword 0x583186, [e+8] + dword 0x58318a, [e+0xc] + dword 0x583186, [e+0x10] + dword 0x58318a}; 0x4c7623 on the surface manager
 * 0x5cf659 with (dword 0x5cf665, &rectangle, the word w); w := w + 0x400 (16 bits). At the end dword 0x638483 := 0. */
void m4cc79a_draw_rects(Fl18World *world, const Fl18Host *host)
{
    uint16_t w = 0x10;
    uint32_t list = world->value_63848d;
    int32_t i;
    if (world->value_638483 == 0) return;
    for (i = 0; i < (int16_t)rd16(host->resolve(host->context, list), 2); i++) {
        const uint8_t *entry = host->resolve(host->context, rd32(host->resolve(host->context, list), 9)) + (ptrdiff_t)i * 0x18;
        uint32_t rect[4];
        rect[0] = rd32(entry, 4) + (uint32_t)world->origin_x_583186;
        rect[2] = rd32(entry, 0xc) + (uint32_t)world->origin_x_583186;
        rect[1] = rd32(entry, 8) + (uint32_t)world->origin_y_58318a;
        rect[3] = rd32(entry, 0x10) + (uint32_t)world->origin_y_58318a;
        call3(host, 0x4c7623, 0x5cf659, world->value_5cf665, (uintptr_t)rect, w);
        w = (uint16_t)(w + 0x400);
    }
    world->value_638483 = 0;
}

/* original GAME.EXE 0x4b6097 (FUN_004b6097), this = self, stack arguments a, b (signed words). When a is 0x276d: 0x5b44f0 := 9;
 * 0x5b44f4 := 1; 0x5d162d := dword 0x5d0377; 0x5d1631 := 0x5b160c + (0x5b44f0 << 5) + (0x5b44f4 << 4); 0x5d1639 := 1; 0x5c39e5 := 0x276d;
 * word [self+0x252] := 0xffff. Otherwise, when a is 0x276c: the same with 0x5b44f0 := 0x12, 0x5c39e5 := 0x276c and word [self+0x252] := b. */
void m4b6097_arm_hotspot(uint8_t *self, int16_t a, int16_t b, Fl18World *world)
{
    if (a == 0x276d) {
        world->value_5b44f0 = 9;
        world->value_5b44f4 = 1;
        world->value_5d162d = world->value_5d0377;
        world->value_5d1631 = hotspot_address(world);
        world->value_5d1639 = 1;
        world->value_5c39e5 = 0x276du;
        wr16(self, 0x252, 0xffff);
    } else if (a == 0x276c) {
        world->value_5b44f0 = 0x12;
        world->value_5b44f4 = 1;
        world->value_5d162d = world->value_5d0377;
        world->value_5d1631 = hotspot_address(world);
        world->value_5d1639 = 1;
        world->value_5c39e5 = 0x276cu;
        wr16(self, 0x252, (uint16_t)b);
    }
}

/* original GAME.EXE 0x4b8d5e (FUN_004b8d5e), this = self: count := 0 (a word); now := GetTickCount. For k = 0 while the signed word k
 * < the signed word [obj+0x173] (obj = the object that the dword [self+8] addresses, re-read on every pass): e = self + k * 0x37; when
 * the dword [e+0x7d] is 1 and (now - dword [e+0x77]) / 1000 (unsigned) is above the signed word [e+0x7b] (sign-extended, compared
 * unsigned): dword [e+0x7d] := 3; word [self+0x48] -= 1; count += 1 (16 bits). Then, when the signed word count > 0, 0x4fb2e3 on
 * 0x5c3a67 with the word [obj+0x4e9] (obj read again) and 0x4b8a27 on self with 2. */
void m4b8d5e_expire_slots(uint8_t *self, const Fl18Host *host)
{
    uint16_t count = 0;
    uint32_t now = host->tick != NULL ? host->tick(host->context) : 0;
    int16_t k;
    for (k = 0; k < (int16_t)rd16(host->resolve(host->context, rd32(self, 8)), 0x173); k++) {
        uint8_t *e = self + (ptrdiff_t)k * 0x37;
        if (rd32(e, 0x7d) == 1 && (now - rd32(e, 0x77)) / 1000u > (uint32_t)(int32_t)(int16_t)rd16(e, 0x7b)) {
            wr32(e, 0x7d, 3);
            wr16(self, 0x48, (uint16_t)(rd16(self, 0x48) - 1));
            count = (uint16_t)(count + 1);
        }
    }
    if ((int16_t)count > 0) {
        call1(host, 0x4fb2e3, 0x5c3a67, rd16(host->resolve(host->context, rd32(self, 8)), 0x4e9));
        call1(host, 0x4b8a27, (uintptr_t)self, 2);
    }
}

/* original GAME.EXE 0x410f99 (FUN_00410f99), cdecl, stack arguments dst, src, a (word), b (byte): copies the string at src with its
 * terminating zero to dst, then word [dst+0x21] := word [src+0x21]; dword [dst+0x27] := dword [src+0x23]; word [dst+0x2b] := word
 * [src+0x27]; word [dst+0x2d] := word [src+0x29]; byte [dst+0x90] := byte [src+0x2b]; word [dst+0x91] := word [src+0x2c]; word
 * [dst+0xa5] := a; byte [dst+0xa7] := b; dwords [dst+0x2f] := 0x1f4, [dst+0x33] := 0x7d0, [dst+0x5b] := 0x3e8, [dst+0x5f] := 0xa; byte
 * [dst+0x87] := 1; words [dst+0x97] := 1, [dst+0xa8] := 2. */
void m410f99_init_entry(uint8_t *dst, const uint8_t *src, int16_t a, uint8_t b)
{
    memcpy(dst, src, strlen((const char *)src) + 1);
    wr16(dst, 0x21, rd16(src, 0x21));
    wr32(dst, 0x27, rd32(src, 0x23));
    wr16(dst, 0x2b, rd16(src, 0x27));
    wr16(dst, 0x2d, rd16(src, 0x29));
    dst[0x90] = src[0x2b];
    wr16(dst, 0x91, rd16(src, 0x2c));
    wr16(dst, 0xa5, (uint16_t)a);
    dst[0xa7] = b;
    wr32(dst, 0x2f, 0x1f4);
    wr32(dst, 0x33, 0x7d0);
    wr32(dst, 0x5b, 0x3e8);
    wr32(dst, 0x5f, 0xa);
    dst[0x87] = 1;
    wr16(dst, 0x97, 1);
    wr16(dst, 0xa8, 2);
}

/* original GAME.EXE 0x44d624 (FUN_0044d624), this = self: rec = the dword of the 0x5bb5e5-based record at the signed word [self+0x1e]
 * (stride 0x8d). Nothing unless the dword [self+0x25] is non-zero, the byte [self+0x49] is 0, the dword [self+0x29] is non-zero and the
 * dword at record +0x4d is 1. Then, when the dword 0x5bb1ca is non-zero and the nine bytes at [rec+0x265] differ from the nine bytes at
 * 0x5495b0: n = the signed word [rec+0x286]; when 0x4f6334 on 0x5cf1eb with n returns 0, 0x4fb2e3 on 0x5c3a67 with the word [rec+0x286].
 * Always (inside the first condition) dword [self+0x2d] := 2; dword [self+0x4b] := GetTickCount + the signed word [rec+0x261] * 100;
 * byte [self+0x24] := 1. */
void m44d624_arm_timer(uint8_t *self, const Fl18World *world, const Fl18Host *host)
{
    ptrdiff_t slot = (ptrdiff_t)(int16_t)rd16(self, 0x1e) * 0x8d;
    uint32_t rec = rd32(world->records_5bb5e5, slot);
    if (rd32(self, 0x25) == 0 || self[0x49] != 0 || rd32(self, 0x29) == 0 || rd32(world->records_5bb5e5, slot + 0x4d) != 1) return;
    if (world->value_5bb1ca != 0) {
        const uint8_t *r = host->resolve(host->context, rec);
        if (memcmp(r + 0x265, world->bytes_5495b0, 9) != 0) {
            int32_t n = (int16_t)rd16(r, 0x286);
            if (call1(host, 0x4f6334, 0x5cf1eb, (uintptr_t)(uint32_t)n) == 0) call1(host, 0x4fb2e3, 0x5c3a67, rd16(r, 0x286));
        }
    }
    wr32(self, 0x2d, 2);
    wr32(self, 0x4b, (host->tick != NULL ? host->tick(host->context) : 0) +
                         (uint32_t)((int32_t)(int16_t)rd16(host->resolve(host->context, rec), 0x261) * 100));
    self[0x24] = 1;
}

/* original GAME.EXE 0x4631d1 (FUN_004631d1), this = self: rec = the dword of the 0x5bb5e5-based record at the signed word [self+0x1e]
 * (stride 0x8d). Nothing unless the dword [self+0x3f] is non-zero, the dwords [self+0x47] and [self+0x24] are 0 and the dword at record
 * +0x4d is 1. Then, when the dword 0x5c39e5 is 0x277f: dword [self+0x43] := 1; dword at record +0x4d := 2. Otherwise, when the signed
 * word [self+0x57] is non-zero: dword [self+0x24] := 2 and, when that word is still non-zero, the dword 0x5bb1ca is non-zero and the
 * nine bytes at [rec+0x24f] differ from the nine bytes at 0x54b158: 0x4fb2e3 on 0x5c3a67 with the word [rec+0x270]. */
void m4631d1_check_piece(uint8_t *self, const Fl18World *world, const Fl18Host *host)
{
    ptrdiff_t slot = (ptrdiff_t)(int16_t)rd16(self, 0x1e) * 0x8d;
    uint32_t rec = rd32(world->records_5bb5e5, slot);
    if (rd32(self, 0x3f) == 0 || rd32(self, 0x47) != 0 || rd32(self, 0x24) != 0 ||
        rd32(world->records_5bb5e5, slot + 0x4d) != 1)
        return;
    if (world->value_5c39e5 == 0x277fu) {
        wr32(self, 0x43, 1);
        wr32(world->records_5bb5e5, slot + 0x4d, 2);
    } else if ((int16_t)rd16(self, 0x57) != 0) {
        wr32(self, 0x24, 2);
        if ((int16_t)rd16(self, 0x57) != 0 && world->value_5bb1ca != 0) {
            const uint8_t *r = host->resolve(host->context, rec);
            if (memcmp(r + 0x24f, world->bytes_54b158, 9) != 0) call1(host, 0x4fb2e3, 0x5c3a67, rd16(r, 0x270));
        }
    }
}

/* original GAME.EXE 0x41632b (FUN_0041632b), stack argument arg: when the dword [arg+0x17a] is non-zero calls 0x51dc6c (the C free,
 * cdecl) with it and clears it; the same for the dword [arg+0x17e]; words [arg+0x182], [arg+0x184] := 0. */
void m41632b_free_buffers(uint8_t *arg, const Fl18Host *host)
{
    if (rd32(arg, 0x17a) != 0) {
        call1(host, 0x51dc6c, 0, rd32(arg, 0x17a));
        wr32(arg, 0x17a, 0);
    }
    if (rd32(arg, 0x17e) != 0) {
        call1(host, 0x51dc6c, 0, rd32(arg, 0x17e));
        wr32(arg, 0x17e, 0);
    }
    wr16(arg, 0x182, 0);
    wr16(arg, 0x184, 0);
}

/* original GAME.EXE 0x4c08d3 (FUN_004c08d3), this = self: s = the object that the dword [self+0x24a] addresses. Dwords [self+0x1e2] :=
 * [s+6], [self+0x1ea] := [s+0xe], [self+0x1de] := [s+2], [self+0x1e6] := [s+0xa]; [self+0x1f2] := [s+0x16] + dword 0x58318a, [self+0x1fa]
 * := [s+0x1e] + 0x58318a, [self+0x1ee] := [s+0x12] + dword 0x583186, [self+0x1f6] := [s+0x1a] + 0x583186; then [self+0x202] :=
 * [self+0x1f2] - 0x58318a, [self+0x20a] := [self+0x1fa] - 0x58318a, [self+0x1fe] := [self+0x1ee] - 0x583186, [self+0x206] :=
 * [self+0x1f6] - 0x583186. */
void m4c08d3_shift_rects(uint8_t *self, const Fl18World *world, const Fl18Host *host)
{
    const uint8_t *s = host->resolve(host->context, rd32(self, 0x24a));
    wr32(self, 0x1e2, rd32(s, 6));
    wr32(self, 0x1ea, rd32(s, 0xe));
    wr32(self, 0x1de, rd32(s, 2));
    wr32(self, 0x1e6, rd32(s, 0xa));
    wr32(self, 0x1f2, rd32(s, 0x16) + (uint32_t)world->origin_y_58318a);
    wr32(self, 0x1fa, rd32(s, 0x1e) + (uint32_t)world->origin_y_58318a);
    wr32(self, 0x1ee, rd32(s, 0x12) + (uint32_t)world->origin_x_583186);
    wr32(self, 0x1f6, rd32(s, 0x1a) + (uint32_t)world->origin_x_583186);
    wr32(self, 0x202, rd32(self, 0x1f2) - (uint32_t)world->origin_y_58318a);
    wr32(self, 0x20a, rd32(self, 0x1fa) - (uint32_t)world->origin_y_58318a);
    wr32(self, 0x1fe, rd32(self, 0x1ee) - (uint32_t)world->origin_x_583186);
    wr32(self, 0x206, rd32(self, 0x1f6) - (uint32_t)world->origin_x_583186);
}

/* original GAME.EXE 0x4c0774 (FUN_004c0774), this = self, stack argument a (word); s = the object that the dword [self+0x22a] addresses.
 * Nothing when the signed words [s+0x21] and [self+0x1d4] are both 0. Otherwise dword [self+0x240] := 0; dword 0x5d19fb := 0; dword
 * 0x5839a9 := dword [self+0x20e]; dword 0x5c39f9 := 0; when the signed word [s+0x37] is not -1 the dword 0x585801[that word] :=
 * the signed word [s+0x39]; when the signed word [s+0x25] is 5: dword 0x5bb57b := signed word [s+0x2f], word 0x5bb599 := word
 * [s+0x31], word 0x5bb595 := word [s+0x33], word 0x5c39ff := word [s+0x35], dwords 0x5bb59b, 0x5bb59f := 0, 0x5bb5a3 := 1, 0x583999 := 4.
 * Then dword 0x5bb1ca := 0 when the signed word [s+0x23] is 1, else 1; 0x4d36ed (FL-17 has it as m4d36ed_set_flags); 0x4bf773 on self;
 * 0x42ba3a (cdecl) with the word a. */
void m4c0774_open_piece(uint8_t *self, int16_t a, Fl18World *world, const Fl18Host *host)
{
    const uint8_t *s = host->resolve(host->context, rd32(self, 0x22a));
    if ((int16_t)rd16(s, 0x21) == 0 && (int16_t)rd16(self, 0x1d4) == 0) return;
    wr32(self, 0x240, 0);
    world->value_5d19fb = 0;
    world->value_5839a9 = rd32(self, 0x20e);
    world->value_5c39f9 = 0;
    if ((int16_t)rd16(s, 0x37) != -1)
        wr32(world->flags_585801, (ptrdiff_t)(int16_t)rd16(s, 0x37) * 4, (uint32_t)(int32_t)(int16_t)rd16(s, 0x39));
    if ((int16_t)rd16(s, 0x25) == 5) {
        world->value_5bb57b = (uint32_t)(int32_t)(int16_t)rd16(s, 0x2f);
        world->word_5bb599 = rd16(s, 0x31);
        world->word_5bb595 = rd16(s, 0x33);
        world->word_5c39ff = rd16(s, 0x35);
        world->value_5bb59b = 0;
        world->value_5bb59f = 0;
        world->value_5bb5a3 = 1;
        world->value_583999 = 4;
    }
    world->value_5bb1ca = (int16_t)rd16(s, 0x23) == 1 ? 0 : 1;
    call0(host, 0x4d36ed, 0);
    call0(host, 0x4bf773, (uintptr_t)self);
    call1(host, 0x42ba3a, 0, (uint16_t)a);
}

/* The signed word at the object that the dword of the record at the signed word 0x5b61b0 addresses (read afresh by every use in 0x4d07e7). */
static int16_t piece_5b61b0(const Fl18World *world, const Fl18Host *host)
{
    uint32_t rec = rd32(world->records_5bb5e5, (ptrdiff_t)world->word_5b61b0 * 0x8d);
    return (int16_t)rd16(host->resolve(host->context, rec), 0);
}

/* original GAME.EXE 0x4d07e7 (FUN_004d07e7), no arguments: rec = the dword of the 0x5bb5e5-based record at the signed word 0x5b61b0
 * (stride 0x8d); 0x4c5377 on 0x5cf659 with the five arguments dword 0x5d15e3, dword 0x5cf665, rec + 0x24, 0x5b61c1, 0x55a004 (first to
 * last as the callee sees them); then, with i = the signed word at the object that rec addresses (read afresh), 0x4d2c20 (cdecl, eight
 * arguments) with 0x5b616d, 0x5a4c24 + i * 0x7f3, 0x5adb3a + i * 0x1d0, word 0x5b61d1, word 0x5b61dd, dword 0x5d032f[i], dword
 * 0x5cf665, 0; and when the string at 0x5b618e is not empty the same call with 0x5b618e, the two addresses, word 0x5b61e1, word
 * 0x5b61ed, dword 0x5d032f[i], dword 0x5cf665, 0. */
void m4d07e7_draw_texts(const Fl18World *world, const Fl18Host *host)
{
    uint32_t rec = rd32(world->records_5bb5e5, (ptrdiff_t)world->word_5b61b0 * 0x8d);
    int32_t i;
    call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, rec + 0x24u, 0x5b61c1, 0x55a004);
    i = piece_5b61b0(world, host);
    call8(host, 0x4d2c20, 0x5b616d, 0x5a4c24u + (uint32_t)(i * 0x7f3), 0x5adb3au + (uint32_t)(i * 0x1d0), world->word_5b61d1,
          world->word_5b61dd, rd32(world->dwords_5d032f, (ptrdiff_t)i * 4), world->value_5cf665, 0);
    if (world->string_5b618e[0] != 0) {
        i = piece_5b61b0(world, host);
        call8(host, 0x4d2c20, 0x5b618e, 0x5a4c24u + (uint32_t)(i * 0x7f3), 0x5adb3au + (uint32_t)(i * 0x1d0), world->word_5b61e1,
              world->word_5b61ed, rd32(world->dwords_5d032f, (ptrdiff_t)i * 4), world->value_5cf665, 0);
    }
}
