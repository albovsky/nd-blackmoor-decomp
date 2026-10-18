#include "original_methods_fl20c.h"

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

static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
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

/* the object of the owner address (an original address), as host memory */
static const uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return host->resolve(host->context, address);
}

/* the signed 32-bit quotient-by-two of the original (cdq; sub eax, edx; sar eax, 1): rounds toward zero */
static uint32_t half_toward_zero(uint32_t value)
{
    int32_t d = (int32_t)value;
    int32_t sign = d < 0 ? -1 : 0;
    return (uint32_t)((int32_t)((uint32_t)d - (uint32_t)sign) >> 1);
}

static uint32_t call8(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args8)
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
static int32_t cell_word(const Fl20cWorld *world, int32_t row, int32_t col, ptrdiff_t off)
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

/* original GAME.EXE 0x481cb9 (FUN_00481cb9, no this, no stack argument, plain ret): rec = the dword of the 0x5bb5e5-based record at the
 * signed word 0x625f06 (stride 0x8d; only used as an address). The singleton at 0x625ee8 is called as the object of 0x47e52f and
 * 0x47e99e; text is a local of 0x28 bytes that 0x47e52f fills.
 * 1. When the dword 0x627230 or the dword 0x62722c is non-zero: 0x4c5377 on 0x5cf659 with (dword 0x5d15e3, dword 0x5cf665, 0x62723a,
 *    0x62725a, 0x54d6e8); the dword 0x627230 := 0.
 * 2. When the dword 0x627234 is non-zero: 0x47e52f on 0x625ee8 with (0x62727a, &text), 0x4c5377 on 0x5cf659 with (dword 0x5d15e3,
 *    dword 0x5cf665, 0x62727a, &text, 0x54d720); the dword 0x627234 := 0.
 * 3. count = the word 0x62728a, less one (16-bit) when the dword 0x62722c is non-zero. For i = 0, 1, ... (a signed word) while the
 *    word j (starting at 0) differs from count (a signed compare of the words): for m = 0, 1, ... (a signed word) while m < the signed
 *    word 0x62728a: not for m equal to the signed word 0x627238 when the dword 0x62722c is non-zero; cell = 0x62669c + m * 0x25 is
 *    handled when its signed word at +0 equals i: with idx = byte [cell+0x23] * 0x60 + byte [cell+0x22] * 0x18 (zero-extended), when
 *    the byte [cell+0x24] is non-zero 0x4c5d4b on 0x5cf659 with (dword 0x625f08 + idx, dword 0x5cf665, 0x625f0c + idx, cell + 0x12,
 *    0x54d750); otherwise q = rec + byte [cell+0x23] * 0x53 + 0x99 and, when 0x47e99e on 0x625ee8 with q returns non-zero, 0x4c5d4b on
 *    0x5cf659 with (dword 0x62728c, dword 0x5cf665, q, cell + 0x12, 0x54d774); then j := j + 1 (16-bit) and, when j equals count,
 *    the scan of this i ends (and the whole loop with it).
 * 4. When the dword 0x62722c is non-zero: cell = 0x62669c + (the signed word 0x627238) * 0x25; when the byte 0x627299 is non-zero
 *    0x4c5d4b on 0x5cf659 with (dword 0x627290, dword 0x5cf665, rec + byte [cell+0x23] * 0x53 + 0xc9, cell + 0x12, 0x54d798),
 *    otherwise (idx as above) 0x4c5d4b with (dword 0x625f08 + idx, dword 0x5cf665, 0x625f0c + idx, 0x62726a, 0x54d7bc).
 * 5. When the byte 0x62729a is non-zero: 0x47e52f on 0x625ee8 with (rec + 0x81, &text), 0x4c5377 on 0x5cf659 with (dword 0x627294,
 *    dword 0x5cf665, 0x62729d, &text, 0x54d7e8); otherwise, when the byte 0x62729b is non-zero: 0x47e52f (rec + 0x81, &text), 0x4c5377
 *    with (dword 0x5d15e3, dword 0x5cf665, rec + 0x81, &text, 0x54d808), the byte 0x62729b := 0.
 * (A scan that never finds the cells it looks for does not terminate in the original either.) */
void m481cb9_draw_cells(Fl20cWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = rd32(world->records_5bb5e5, (ptrdiff_t)world->word_625f06 * 0x8d);
    uint8_t text[0x28];
    int16_t count, i, j, m;
    memset(text, 0, sizeof text);
    if (world->value_627230 != 0 || world->value_62722c != 0) {
        call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, 0x62723a, 0x62725a, 0x54d6e8);
        world->value_627230 = 0;
    }
    if (world->value_627234 != 0) {
        call2(host, 0x47e52f, 0x625ee8, 0x62727a, (uintptr_t)text);
        call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, 0x62727a, (uintptr_t)text, 0x54d720);
        world->value_627234 = 0;
    }
    count = world->word_62728a;
    if (world->value_62722c != 0) count = (int16_t)(count - 1);
    j = 0;
    for (i = 0; (int32_t)j != (int32_t)count; i = (int16_t)(i + 1)) {
        for (m = 0; (int32_t)m < world->word_62728a; m = (int16_t)(m + 1)) {
            const uint8_t *cell;
            uint32_t cell_va, idx, q;
            if (world->value_62722c != 0 && (int32_t)world->word_627238 == (int32_t)m) continue;
            cell = world->slots_62669c + (ptrdiff_t)m * 0x25;
            cell_va = 0x62669cu + (uint32_t)((int32_t)m * 0x25);
            if (rds16(cell, 0) != (int32_t)i) continue;
            idx = (uint32_t)cell[0x23] * 0x60u + (uint32_t)cell[0x22] * 0x18u;
            if (cell[0x24] != 0) {
                call5(host, 0x4c5d4b, 0x5cf659, rd32(world->table_625f08, (ptrdiff_t)idx), world->value_5cf665, 0x625f0cu + idx, cell_va + 0x12u, 0x54d750);
            } else {
                q = rec_va + (uint32_t)cell[0x23] * 0x53u + 0x99u;
                if (call1(host, 0x47e99e, 0x625ee8, q) != 0)
                    call5(host, 0x4c5d4b, 0x5cf659, world->value_62728c, world->value_5cf665, q, cell_va + 0x12u, 0x54d774);
            }
            j = (int16_t)(j + 1);
            if ((int32_t)j == (int32_t)count) break;
        }
    }
    if (world->value_62722c != 0) {
        const uint8_t *cell = world->slots_62669c + (ptrdiff_t)world->word_627238 * 0x25;
        uint32_t cell_va = 0x62669cu + (uint32_t)((int32_t)world->word_627238 * 0x25);
        uint32_t idx = (uint32_t)cell[0x23] * 0x60u + (uint32_t)cell[0x22] * 0x18u;
        if (world->byte_627299 != 0)
            call5(host, 0x4c5d4b, 0x5cf659, world->value_627290, world->value_5cf665, rec_va + (uint32_t)cell[0x23] * 0x53u + 0xc9u, cell_va + 0x12u, 0x54d798);
        else
            call5(host, 0x4c5d4b, 0x5cf659, rd32(world->table_625f08, (ptrdiff_t)idx), world->value_5cf665, 0x625f0cu + idx, 0x62726a, 0x54d7bc);
    }
    if (world->byte_62729a != 0) {
        call2(host, 0x47e52f, 0x625ee8, rec_va + 0x81u, (uintptr_t)text);
        call5(host, 0x4c5377, 0x5cf659, world->value_627294, world->value_5cf665, 0x62729d, (uintptr_t)text, 0x54d7e8);
    } else if (world->byte_62729b != 0) {
        call2(host, 0x47e52f, 0x625ee8, rec_va + 0x81u, (uintptr_t)text);
        call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, rec_va + 0x81u, (uintptr_t)text, 0x54d808);
        world->byte_62729b = 0;
    }
}

/* original GAME.EXE 0x463b10 (FUN_00463b10, no this, no stack argument, plain ret): rec = the object of the dword of the 0x5bb5e5-based
 * record at the signed word 0x61d797 (stride 0x8d); table = the dword of the 0x5d1599 record at the signed word 0x61d795 (stride 0x4a),
 * re-read for every call. For r = 0, 1, ... (a signed word) while r < the signed word [rec+0x22], then c = 0, 1, ... while c < the
 * signed word [rec+0x24]: cell = 0x594db5 + r * 0x140 + c * 0x28, handled unless its dword at +0 is 0. With t = the signed word at
 * cell+0x24 (0x594dd9 + ...), a switch on t - 1 (unsigned compare, a byte index table and five jump targets) does:
 *   t = 0x10, 0x13: 0x4c5d4b on 0x5cf659 with (table, dword 0x5cf665, rec + 0x210, cell + 4, 0x54b210);
 *   t = 0x11, 0x12: 0x4c5d4b with (table, dword 0x5cf665, rec + 0x220, cell + 4, 0x54b22c);
 *   t = 0x14: when the dword [rec+0x238] differs from the dword [rec+0x230]: 0x4c5d4b with (table, dword 0x5cf665, rec + 0x230, cell + 4,
 *             0x54b248);
 *   t = 1 .. 10: with u = (t - 1) * 16, when the dword [rec+u+0x178] differs from the dword [rec+u+0x170]: 0x4c5d4b with (table, dword
 *             0x5cf665, rec + u + 0x170, cell + 4, 0x54b264);
 *   anything else: nothing.
 * Then, with s = the signed word at cell+0x26 (0x594ddb + ...), when s is non-zero: when the dword 0x61d79d is 2 or the dword 0x61d7b4
 * is 1, and the signed word 0x61d7b2 equals s: the local rectangle { dword 0x61d7a2 - 0x583186, dword 0x61d7a6 - 0x58318a, dword
 * 0x61d7aa - 0x583186, dword 0x61d7ae - 0x58318a } (32-bit wrap) goes to 0x4c5377 on 0x5cf659 with (dword 0x5d15e3, dword 0x5cf665,
 * &rectangle, 0x61d7a2, 0x54b284); and in every case 0x4c5d4b with (table, dword 0x5cf665, rec + (s - 1) * 16 + 0xd0, cell + 0x14,
 * 0x54b298). Cell addresses handed to the callees are the original addresses (0x594db5 + ...). */
void m463b10_draw_grid(Fl20cWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = rd32(world->records_5bb5e5, (ptrdiff_t)world->word_61d797 * 0x8d);
    int16_t r, c;
    for (r = 0; (int32_t)r < rds16(object_at(host, rec_va), 0x22); r = (int16_t)(r + 1)) {
        for (c = 0; (int32_t)c < rds16(object_at(host, rec_va), 0x24); c = (int16_t)(c + 1)) {
            ptrdiff_t cell_off = (ptrdiff_t)r * 0x140 + (ptrdiff_t)c * 0x28;
            uint32_t cell_va = 0x594db5u + (uint32_t)((int32_t)r * 0x140 + (int32_t)c * 0x28);
            uint32_t e;
            int32_t s;
            if (rd32(world->cells_594db5, cell_off) == 0) continue;
            e = (uint32_t)(rds16(world->cells_594db5, cell_off + 0x24) - 1);
            if (e <= 0x13) {
                const uint8_t *rec = object_at(host, rec_va);
                if (e == 15 || e == 18) {
                    call5(host, 0x4c5d4b, 0x5cf659, rd32(world->table_5d1599, (ptrdiff_t)world->word_61d795 * 0x4a), world->value_5cf665, rec_va + 0x210u,
                          cell_va + 4u, 0x54b210);
                } else if (e == 16 || e == 17) {
                    call5(host, 0x4c5d4b, 0x5cf659, rd32(world->table_5d1599, (ptrdiff_t)world->word_61d795 * 0x4a), world->value_5cf665, rec_va + 0x220u,
                          cell_va + 4u, 0x54b22c);
                } else if (e == 19) {
                    if (rd32(rec, 0x238) - rd32(rec, 0x230) != 0)
                        call5(host, 0x4c5d4b, 0x5cf659, rd32(world->table_5d1599, (ptrdiff_t)world->word_61d795 * 0x4a), world->value_5cf665,
                              rec_va + 0x230u, cell_va + 4u, 0x54b248);
                } else if (e <= 9) {
                    uint32_t u = e << 4;
                    if (rd32(rec, (ptrdiff_t)u + 0x178) - rd32(rec, (ptrdiff_t)u + 0x170) != 0)
                        call5(host, 0x4c5d4b, 0x5cf659, rd32(world->table_5d1599, (ptrdiff_t)world->word_61d795 * 0x4a), world->value_5cf665,
                              rec_va + u + 0x170u, cell_va + 4u, 0x54b264);
                }
            }
            s = rds16(world->cells_594db5, cell_off + 0x26);
            if (s != 0) {
                if (world->value_61d79d == 2 || world->value_61d7b4 == 1) {
                    if ((int32_t)world->word_61d7b2 == s) {
                        uint32_t rect[4];
                        rect[1] = world->value_61d7a6 - (uint32_t)world->origin_y_58318a;
                        rect[3] = world->value_61d7ae - (uint32_t)world->origin_y_58318a;
                        rect[0] = world->value_61d7a2 - (uint32_t)world->origin_x_583186;
                        rect[2] = world->value_61d7aa - (uint32_t)world->origin_x_583186;
                        call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, (uintptr_t)rect, 0x61d7a2, 0x54b284);
                    }
                }
                call5(host, 0x4c5d4b, 0x5cf659, rd32(world->table_5d1599, (ptrdiff_t)world->word_61d795 * 0x4a), world->value_5cf665,
                      rec_va + ((uint32_t)(s - 1) << 4) + 0xd0u, cell_va + 0x14u, 0x54b298);
            }
        }
    }
}

/* original GAME.EXE 0x412db8 (FUN_00412db8), this = self, ten stack arguments (ret 0x28), in the order of the stack: text (a buffer,
 * [ebp+8]), font (word, [ebp+0xc]), flag (pointer to a dword, [ebp+0x10]), x (pointer to a word, [ebp+0x14]), limit_e (word,
 * [ebp+0x18]), limit_f (word, [ebp+0x1c]), y (pointer to a word, [ebp+0x20]), arg8 ([ebp+0x24], dword, only ever incremented: never
 * seen by anything), arg9 (word, [ebp+0x28]), arg10 (dword, [ebp+0x2c]). The prologue calls the CRT stack probe 0x50c920 for the
 * 0x1398-byte frame (no effect on anything the port can see). buf is a local of 5000 bytes, zeroed; src and dst are signed words (0);
 * wrapped = 0. rec = the font record 0x5adb3a + font * 0x1d0 and w = the signed word at rec+2.
 * Repeat:
 *  1. When the dword *flag is non-zero: *x := *x + w (16-bit) when the dword [self+0x293e] is non-zero; otherwise, when the dword
 *     [self+0x2942] is non-zero, *x := *x + (w + w / 9) / 2 (16-bit; both divisions signed, the second rounds toward zero) and the
 *     dword [self+0x2942] := 0; otherwise *x := *x + w + w / 9 (16-bit). Then, when *x (signed) >= limit_e: when the signed word
 *     0x63a4cd is non-zero, 0x50ca3e (cdecl) with (0x63888b, 0x54167c) and 0x4264e8 on 0x583979 with (0x63888b); the function then
 *     goes to the end. Otherwise *flag := 0.
 *  2. A text that is empty (strlen == 0) goes to the end.
 *  3. Copy: while *y + (signed word result of 0x4d3836 (cdecl) with (buf, 0x5a4c24 + font * 0x7f3, rec)) < limit_f (signed) and the
 *     byte text[src] (signed) is non-zero: buf[dst] := text[src]; dst++; src++ (16-bit counters).
 *  4. When text[src] is still non-zero (the line is full): dst--, src--, buf[dst] := 0, and while dst >= 0 and buf[dst] != 0x20: dst--,
 *     src-- (dst reaches -1 when the line has no space; the original then reads and writes the byte below buf, the top byte of its
 *     saved this pointer, which is 0 for every this below 0x1000000, so nothing is done here); then dst++, src++, buf[dst] := 0 and
 *     wrapped := 1.
 *  5. When strlen(buf) != 0: 0x4d270b (cdecl, 10 stack arguments: args[0] .. args[9]) with (buf, 0x5a4c24 + font * 0x7f3, rec,
 *     y_arg, x_arg, dword 0x5d032f[font], arg10, arg9, dword [self+0x2938], word [self+0x293c]) where x_arg and y_arg are *x and *y
 *     pushed from 16-bit registers: x_arg keeps the upper half of the sign extension of font, y_arg the upper half of the POINTER x
 *     (the port cannot reproduce that: only its low 16 bits are meaningful); arg9 and the last argument are zero-extended. Then
 *     *y := *y + (the word result of 0x4d3836 with (buf, 0x5a4c24 + font * 0x7f3, rec)).
 *  6. When wrapped: wrapped := 0, *y := the word [self+0x292e], *flag := 1, arg8 += 2 (not observable).
 *  7. buf is cleared again, dst := 0; when text[src] (signed byte) is zero the function goes to the end, otherwise repeat.
 * End: the 0x2710 dwords (40000 bytes) at text are cleared. */
void m412db8_wrap_text(uint8_t *self, uint8_t *text, int16_t font, uint8_t *flag, uint8_t *x, int16_t limit_e, int16_t limit_f, uint8_t *y,
                       uint32_t arg8, int16_t arg9, uint32_t arg10, const Fl20cWorld *world, const Fl18Host *host)
{
    uint8_t buf[5000];
    int16_t src = 0, dst = 0;
    uint32_t wrapped = 0;
    uint32_t font_va = 0x5adb3au + (uint32_t)((int32_t)font * 0x1d0);
    uint32_t table_va = 0x5a4c24u + (uint32_t)((int32_t)font * 0x7f3);
    int32_t w = rds16(world->records_5adb3a, (ptrdiff_t)font * 0x1d0 + 2);
    memset(buf, 0, sizeof buf);
    for (;;) {
        if (rd32(flag, 0) != 0) {
            if (rd32(self, 0x293e) != 0) {
                wr16(x, 0, (uint16_t)(rd16(x, 0) + (uint16_t)w));
            } else if (rd32(self, 0x2942) != 0) {
                int32_t sum = w / 9 + w;
                uint32_t half = half_toward_zero((uint32_t)sum);
                wr16(x, 0, (uint16_t)(rd16(x, 0) + (uint16_t)half));
                wr32(self, 0x2942, 0);
            } else {
                wr16(x, 0, (uint16_t)(rd16(x, 0) + (uint16_t)(w + w / 9)));
            }
            if (rds16(x, 0) >= (int32_t)limit_e) {
                if (world->word_63a4cd != 0) {
                    call2(host, 0x50ca3e, 0, 0x63888b, 0x54167c);
                    call1(host, 0x4264e8, 0x583979, 0x63888b);
                }
                break;
            }
            wr32(flag, 0, 0);
        }
        if (strlen((const char *)text) == 0) break;
        for (;;) {
            int32_t y_now = rds16(y, 0);   /* (read before the call, as the original loads it into esi first) */
            int32_t sum = y_now + (int16_t)call3(host, 0x4d3836, 0, (uintptr_t)buf, table_va, font_va);
            if (sum >= (int32_t)limit_f) break;
            if ((int8_t)text[(int32_t)src] == 0) break;
            buf[(int32_t)dst] = text[(int32_t)src];
            dst = (int16_t)(dst + 1);
            src = (int16_t)(src + 1);
        }
        if ((int8_t)text[(int32_t)src] != 0) {
            dst = (int16_t)(dst - 1);
            src = (int16_t)(src - 1);
            if (dst >= 0) buf[(int32_t)dst] = 0;
            while ((int32_t)dst >= 0 && buf[(int32_t)dst] != 0x20) {
                dst = (int16_t)(dst - 1);
                src = (int16_t)(src - 1);
            }
            dst = (int16_t)(dst + 1);
            src = (int16_t)(src + 1);
            buf[(int32_t)dst] = 0;
            wrapped = 1;
        }
        if (strlen((const char *)buf) != 0) {
            uintptr_t args[10];
            args[0] = (uintptr_t)buf;
            args[1] = table_va;
            args[2] = font_va;
            args[3] = rd16(y, 0);
            args[4] = (font < 0 ? 0xffff0000u : 0u) | rd16(x, 0);
            args[5] = rd32(world->dwords_5d032f, (ptrdiff_t)font * 4);
            args[6] = arg10;
            args[7] = (uint16_t)arg9;
            args[8] = rd32(self, 0x2938);
            args[9] = rd16(self, 0x293c);
            host->call(host->context, 0x4d270b, 0, args, 10);
            uint16_t y_before = rd16(y, 0);
            wr16(y, 0, (uint16_t)(y_before + (uint16_t)call3(host, 0x4d3836, 0, (uintptr_t)buf, table_va, font_va)));
        }
        if (wrapped != 0) {
            wrapped = 0;
            wr16(y, 0, rd16(self, 0x292e));
            wr32(flag, 0, 1);
            arg8 += 2;
        }
        memset(buf, 0, sizeof buf);
        dst = 0;
        if ((int8_t)text[(int32_t)src] == 0) break;
    }
    (void)arg8;
    memset(text, 0, 40000);
}
