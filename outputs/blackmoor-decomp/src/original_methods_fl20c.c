#include "original_methods_fl20c.h"

#include <string.h>

/* 0x4fca60 is ported with C double arithmetic that must round like the x87 at 53 bits: no fused multiply-add. Build this file with
 * -ffp-contract=off (the tests do); clang also gets the pragma. */
#if defined(__clang__)
#pragma STDC FP_CONTRACT OFF
#endif

#if defined(__GNUC__) || defined(__clang__)
#define UNUSED_OK __attribute__((unused))
#else
#define UNUSED_OK
#endif

UNUSED_OK static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

UNUSED_OK static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

UNUSED_OK static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

UNUSED_OK static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

UNUSED_OK static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

UNUSED_OK static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, NULL, 0) : 0;
}

UNUSED_OK static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    uintptr_t args[1];
    args[0] = a0;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 1) : 0;
}

UNUSED_OK static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    uintptr_t args[2];
    args[0] = a0;
    args[1] = a1;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 2) : 0;
}

UNUSED_OK static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    uintptr_t args[3];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 3) : 0;
}

UNUSED_OK static uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2,
                      uintptr_t a3)
{
    uintptr_t args[4];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    args[3] = a3;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 4) : 0;
}

UNUSED_OK static uint32_t call5(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2,
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

/* host memory behind the dword at `off` of `base` (an original address); the dword of a record of the 0x5bb5e5 table */
UNUSED_OK static uint8_t *record_object(const Fl18Host *host, const uint8_t *records, int32_t index)
{
    return (uint8_t *)host->resolve(host->context, rd32(records, (ptrdiff_t)index * 0x8d));
}

/* the object of the owner address (an original address), as host memory */
UNUSED_OK static const uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return host->resolve(host->context, address);
}

/* the signed 32-bit quotient-by-two of the original (cdq; sub eax, edx; sar eax, 1): rounds toward zero */
UNUSED_OK static uint32_t half_toward_zero(uint32_t value)
{
    int32_t d = (int32_t)value;
    int32_t sign = d < 0 ? -1 : 0;
    return (uint32_t)((int32_t)((uint32_t)d - (uint32_t)sign) >> 1);
}

UNUSED_OK static uint32_t call8(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args8)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args8, 8) : 0;
}

/* original GAME.EXE 0x4b9a88 (FUN_004b9a88, no this, no stack argument, plain ret; the method of the singleton at 0x61ee6e, whose
 * slots of stride 0x37 start at 0x61eeb8): nothing unless the dword 0x61ee82 is non-zero. obj = the dword 0x61ee76 (an original
 * address, re-read wherever the original reads it) and table = the dword of the 0x5d1599 record at the signed word 0x61ee72
 * (stride 0x4a), also re-read for every call.
 * When the dword 0x61ee8e is 0: for k = 0, 1, ... (a signed word) while k < the signed word [obj+0x173], slot = 0x61eeb8 + k * 0x37:
 *   state = dword [slot+0x33] (0x61eeeb):
 *   1: 0x4c5d4b on 0x5cf659 with (table, dword 0x5cf665, slot, slot+0x10, 0x551e54); then the two bytes {byte [slot+0x20], 0} are a
 *      local string and 0x4d2c20 (cdecl, 8 stack arguments) is called with (&string, 0x5a9ba2, 0x5aed5a, a, b, dword 0x5d0357,
 *      dword 0x5cf665, 0): a and b are dwords pushed from 16-bit registers whose upper halves are leftovers: b = the word [slot+0x25]
 *      with the upper half of the dword 0x5cf665, a = the word [slot+0x21] with the upper half of k * 0x37;
 *   2: 0x4c5d4b on 0x5cf659 with (table, dword 0x5cf665, obj + 0x163, slot+0x10, 0x551e6c), then 0x4b8e42 on 0x61ee6e with the word k;
 *   3: the local rectangle r = { dword [slot+0x10] - 0x583186, dword [slot+0x14] - 0x58318a, dword [slot+0x18] - 0x583186,
 *      dword [slot+0x1c] - 0x58318a } (32-bit wrap), 0x4c5377 on 0x5cf659 with (dword 0x5d15e3, dword 0x5cf665, &r, slot+0x10,
 *      0x551e84); the dword [slot+0x33] := 0;
 *   any other state: nothing.
 * Otherwise (0x61ee8e non-zero): when the dword 0x61eea2 is non-zero, 0x4c5377 on 0x5cf659 with (dword 0x5d15e3, dword 0x5cf665,
 * 0x583196, 0x583186, 0x551ea0) and the dword 0x61eea2 := 0. Then the rectangle r = { x0, y0, x0 + w, y0 + h } with w = dword
 * [obj+0x425] - dword [obj+0x41d], h = dword [obj+0x429] - dword [obj+0x421], x0 = 0x583186 + (0x58318e - 0x583186) / 2 - w / 2 and
 * y0 = 0x58318a + (0x583192 - 0x58318a) / 2 - h / 2 (each division by two as signed 32-bit, rounding toward zero), and 0x4c5d4b on
 * 0x5cf659 with (table, dword 0x5cf665, obj + 0x41d, &r, 0x551ec0). */
void m4b9a88_draw_slots(Fl20cWorld *world, const Fl18Host *host)
{
    if (world->value_61ee82 == 0) return;
    if (world->value_61ee8e == 0) {
        int16_t k;
        for (k = 0; (int32_t)k < rds16(object_at(host, world->value_61ee76), 0x173); k = (int16_t)(k + 1)) {
            uint32_t offset = (uint32_t)((int32_t)k * 0x37);
            uint8_t *slot = world->slots_61eeb8 + (ptrdiff_t)offset;
            uint32_t slot_va = 0x61eeb8u + offset;
            uint32_t state = rd32(slot, 0x33);
            if (state == 1) {
                uint8_t text[2];
                uintptr_t args[8];
                call5(host, 0x4c5d4b, 0x5cf659, rd32(world->table_5d1599, (ptrdiff_t)world->word_61ee72 * 0x4a), world->value_5cf665, slot_va, slot_va + 0x10u,
                      0x551e54);
                text[0] = slot[0x20];
                text[1] = 0;
                args[0] = (uintptr_t)text;
                args[1] = 0x5a9ba2;
                args[2] = 0x5aed5a;
                args[3] = (offset & 0xffff0000u) | rd16(slot, 0x21);
                args[4] = (world->value_5cf665 & 0xffff0000u) | rd16(slot, 0x25);
                args[5] = world->value_5d0357;
                args[6] = world->value_5cf665;
                args[7] = 0;
                call8(host, 0x4d2c20, 0, args);
            } else if (state == 2) {
                call5(host, 0x4c5d4b, 0x5cf659, rd32(world->table_5d1599, (ptrdiff_t)world->word_61ee72 * 0x4a), world->value_5cf665,
                      world->value_61ee76 + 0x163u, slot_va + 0x10u, 0x551e6c);
                call1(host, 0x4b8e42, 0x61ee6e, (uint16_t)k);
            } else if (state == 3) {
                uint32_t r[4];
                r[1] = rd32(slot, 0x14) - (uint32_t)world->origin_y_58318a;
                r[3] = rd32(slot, 0x1c) - (uint32_t)world->origin_y_58318a;
                r[0] = rd32(slot, 0x10) - (uint32_t)world->origin_x_583186;
                r[2] = rd32(slot, 0x18) - (uint32_t)world->origin_x_583186;
                call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, (uintptr_t)r, slot_va + 0x10u, 0x551e84);
                wr32(slot, 0x33, 0);
            }
        }
    } else {
        uint32_t r[4];
        const uint8_t *obj;
        uint32_t w, h;
        if (world->value_61eea2 != 0) {
            call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, 0x583196, 0x583186, 0x551ea0);
            world->value_61eea2 = 0;
        }
        obj = object_at(host, world->value_61ee76);
        w = rd32(obj, 0x425) - rd32(obj, 0x41d);
        h = rd32(obj, 0x429) - rd32(obj, 0x421);
        r[0] = (uint32_t)world->origin_x_583186 + half_toward_zero((uint32_t)world->origin_x2_58318e - (uint32_t)world->origin_x_583186) - half_toward_zero(w);
        r[1] = (uint32_t)world->origin_y_58318a + half_toward_zero((uint32_t)world->origin_y2_583192 - (uint32_t)world->origin_y_58318a) - half_toward_zero(h);
        r[2] = r[0] + w;
        r[3] = r[1] + h;
        call5(host, 0x4c5d4b, 0x5cf659, rd32(world->table_5d1599, (ptrdiff_t)world->word_61ee72 * 0x4a), world->value_5cf665, world->value_61ee76 + 0x41du, (uintptr_t)r,
              0x551ec0);
    }
}

/* the signed word at +off of cell (row, col) of the table at 0x594db5 (cell + 0x24 is the word at 0x594dd9, cell + 0x26 the word at 0x594ddb) */
UNUSED_OK static int32_t cell_word(const Fl20cWorld *world, int32_t row, int32_t col, ptrdiff_t off)
{
    return rds16(world->cells_594db5, (ptrdiff_t)row * 0x140 + (ptrdiff_t)col * 0x28 + off);
}

/* original GAME.EXE 0x4619be (FUN_004619be), this = self, stack argument direction (word, ret 4): rec = the dword of the 0x5bb5e5-based
 * record at the signed word [self+0x1e] (stride 0x8d, read first); ok = 1; the word [self+0x57] := direction. With row = the signed word
 * [self+0x5b], col = the signed word [self+0x5d], T(r, c) = the signed word at 0x594dd9 + r * 0x140 + c * 0x28 and U(r, c) = the signed
 * word at 0x594ddb + r * 0x140 + c * 0x28, a switch on the signed word [self+0x57] - 0x10 (an unsigned compare, so anything outside
 * 0x10 .. 0x13 keeps ok = 1) sets ok := 0 when
 *   0x10: col == 0, or T(row, col) == 0x10, or T(row, col-1) == 0x13, or U(row, col-1) != 0, or T(row, col-1) == 0x14;
 *   0x11: row == 0, or T(row, col) == 0x11, or T(row-1, col) == 0x12, or U(row-1, col) != 0, or T(row-1, col) == 0x14;
 *   0x12: row == the signed word [obj+0x22] - 1 (obj = the object of rec), or T(row, col) == 0x12, or T(row+1, col) == 0x11, or
 *         U(row+1, col) != 0, or T(row+1, col) == 0x14;
 *   0x13: col == the signed word [obj+0x24] - 1, or T(row, col) == 0x13, or T(row, col+1) == 0x10, or U(row, col+1) != 0, or
 *         T(row, col+1) == 0x14.
 * When ok is 0 the words [self+0x39], [self+0x57] and [self+0x59] are cleared. Returns ok. */
int32_t m4619be_check_direction(uint8_t *self, int16_t direction, const Fl20cWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = rd32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d);
    int32_t ok = 1;
    int32_t row, col;
    wr16(self, 0x57, (uint16_t)direction);
    switch ((uint32_t)(rds16(self, 0x57) - 0x10)) {
    case 0:
        col = rds16(self, 0x5d);
        row = rds16(self, 0x5b);
        if (col == 0) {
            ok = 0;
        } else if (cell_word(world, row, col, 0x24) == 0x10 || cell_word(world, row, col - 1, 0x24) == 0x13 ||
                   cell_word(world, row, col - 1, 0x26) != 0 || cell_word(world, row, col - 1, 0x24) == 0x14) {
            ok = 0;
        }
        break;
    case 1:
        row = rds16(self, 0x5b);
        col = rds16(self, 0x5d);
        if (row == 0) {
            ok = 0;
        } else if (cell_word(world, row, col, 0x24) == 0x11 || cell_word(world, row - 1, col, 0x24) == 0x12 ||
                   cell_word(world, row - 1, col, 0x26) != 0 || cell_word(world, row - 1, col, 0x24) == 0x14) {
            ok = 0;
        }
        break;
    case 2:
        row = rds16(self, 0x5b);
        col = rds16(self, 0x5d);
        if (row == rds16(object_at(host, rec_va), 0x22) - 1) {
            ok = 0;
        } else if (cell_word(world, row, col, 0x24) == 0x12 || cell_word(world, row + 1, col, 0x24) == 0x11 ||
                   cell_word(world, row + 1, col, 0x26) != 0 || cell_word(world, row + 1, col, 0x24) == 0x14) {
            ok = 0;
        }
        break;
    case 3:
        row = rds16(self, 0x5b);
        col = rds16(self, 0x5d);
        if (col == rds16(object_at(host, rec_va), 0x24) - 1) {
            ok = 0;
        } else if (cell_word(world, row, col, 0x24) == 0x13 || cell_word(world, row, col + 1, 0x24) == 0x10 ||
                   cell_word(world, row, col + 1, 0x26) != 0 || cell_word(world, row, col + 1, 0x24) == 0x14) {
            ok = 0;
        }
        break;
    default:
        break;
    }
    if (ok == 0) {
        wr16(self, 0x39, 0);
        wr16(self, 0x57, 0);
        wr16(self, 0x59, 0);
    }
    return ok;
}
