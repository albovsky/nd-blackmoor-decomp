#include "original_methods_fl22a.h"

#include <limits.h>
#include <stdint.h>
#include <string.h>

#if defined(__GNUC__) || defined(__clang__)
#define UNUSED_OK __attribute__((unused))
#else
#define UNUSED_OK
#endif

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

UNUSED_OK static int32_t rds32(const uint8_t *base, ptrdiff_t off)
{
    return (int32_t)rd32(base, off);
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

UNUSED_OK static uint32_t call5(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3, uintptr_t a4)
{
    uintptr_t args[5];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    args[3] = a3;
    args[4] = a4;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 5) : 0;
}

UNUSED_OK static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    uintptr_t args[3];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 3) : 0;
}

UNUSED_OK static uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3)
{
    uintptr_t args[4];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    args[3] = a3;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 4) : 0;
}

/* the object of the original address, as host memory */
static const uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return host->resolve(host->context, address);
}

static uint32_t tick_now(const Fl18Host *host)
{
    return host->tick != NULL ? host->tick(host->context) : 0;
}

/* a record of the table at 0x5bb5e5 (stride 0x8d) by its signed word index */
static uint8_t *record_of(uint8_t *records, int32_t index)
{
    return records + (ptrdiff_t)index * 0x8d;
}

/* the copy of a zero-terminated string with its terminator (repne scasb; rep movsd; rep movsb) */
static void copy_string(uint8_t *dst, const uint8_t *src)
{
    size_t n = strlen((const char *)src) + 1;
    memcpy(dst, src, n);
}

/* the nine-byte compare of the original (mov ecx, 9; repe cmpsb): equal when all nine bytes are equal */
static int same9(const uint8_t *a, const uint8_t *b)
{
    return memcmp(a, b, 9) == 0;
}

/* the record of table 0x5d1591 (stride 0x4a) that the signed word [self+0x1c] names; the original recomputes the address at every access */
static uint8_t *slot_of(const Fl22aWorld *world, const uint8_t *self)
{
    return world->table_5d1591 + (ptrdiff_t)rds16(self, 0x1c) * 0x4a;
}

/* the stores of 0x463392 state 2 for the group of record words at `b` (0x32e or 0x2e2): the same eleven stores in both groups */
static void apply_palette(Fl22aWorld *world, const uint8_t *rec, ptrdiff_t b)
{
    if (rds16(rec, b) != 0x270f) {
        world->value_5bb57b = (uint32_t)rds16(rec, b);
        world->word_5bb599 = rd16(rec, b + 2);
        world->word_5bb595 = rd16(rec, b + 4);
        world->word_5c39ff = rd16(rec, b + 6);
        world->value_5bb59b = rd32(rec, b + 8);
        world->value_5bb59f = rd32(rec, b + 0xc);
        world->value_5bb5a3 = rd32(rec, b + 0x10);
        if (rds16(rec, b + 0x14) == 1)
            world->value_5bb1ca = 0;
        else
            world->value_5bb1ca = 1;
        world->value_583999 = 4;
    }
    if (rds16(rec, b + 0x16) != -1) wr32(world->flags_585801, (ptrdiff_t)rds16(rec, b + 0x16) * 4, rec[b + 0x18]);
}

/* original GAME.EXE 0x463392 (FUN_00463392; thiscall, one word stack argument `index`, ret 4; no result): the step of a scene player object
 * for record `index` (signed word) of the table at 0x5bb5e5; rec = the dword [record+0] (the original address of the record's object),
 * state = the dword [record+0x4d] (0x5bb632). Sibling of 0x48d914 (FL-21). data = the image bytes from 0x54b164 (Fl22aWorld.data_54b164).
 * State 0: the word [self+0x1e] := index, [self+0x3f] := 1, 0x5bb1ca := 1; when the byte [rec+0x21] is 0: 0x4618df on self; 0x4e8d96 on
 *   0x571442; [self+0x4f] := [rec+0xd8] - [rec+0xd0], [self+0x53] := [rec+0xdc] - [rec+0xd4]; 0x462577 on self; the byte [self+0x28] := 1;
 *   [self+0x1c] := (word) 0x4d39f9(); the record n of the table at 0x5d1591 (stride 0x4a, n = the signed word [self+0x1c]) gets +0 = 0xa,
 *   +4 = 0x463b10, +8 = +0xc = +0x10 = 0, +0x14 = +0x18 = 1, the word +0x1c = 0 and the string at 0x54b164 copied to +0x22; when [self+0x20]
 *   is 0: [self+0x20] := 0x4c2790 on 0x5cf659 with (0x54b19c, rec, 6, 0x54b180); the dword +8 of that record := [self+0x20]. Then, for each
 *   of (rec+0x24f vs 0x54b1a4), (rec+0x280 vs 0x54b1b0), (rec+0x2b1 vs 0x54b1bc) whose nine bytes differ: 0x4fb77a on 0x5c3a67 with the
 *   address rec + offset. Then [self+0x47] = [self+0x43] = [self+0x24] := 0, the state of the record [self+0x1e] := 1, the words [self+0x39],
 *   [self+0x57], [self+0x59] := 0, the dword [self+0x3b] := 0 and the 16 bytes at self+0x29 := 0.
 * State 1 (v = [self+0x24]; unsigned compare with 4, the original's jump table of five dwords at 0x463aec: arms 0x463690, 0x463775,
 *   0x4636bc, 0x463816, 0x4637a2): v = 0: [self+0x3b] := 0; when [self+0x47] is not 0 [self+0x24] := 1, otherwise 0x4632bf on self.
 *     v = 1: [self+0x4b] := GetTickCount + (signed word [rec+0x2fb]) * 1000; [self+0x24] := 4.
 *     v = 2: 0x461d82 on self; when that is not 0: 0x4619be on self with the word [self+0x57]; when that returns 0: 0x461d4b on self with
 *     (word [self+0x39], word [self+0x5b], word [self+0x5d]); when that is not 0: when rec+0x280 differs from 0x54b1c8: 0x4fb2e3 on 0x5c3a67
 *     with the word [rec+0x2a1]; otherwise: when rec+0x2b1 differs from 0x54b1d4: 0x4fb2e3 with the word [rec+0x2d2]; then [self+0x24] := 0.
 *     v = 3: w = the signed word [rec+0x31e]; 0x4f6334 on 0x5cf1eb with (w as a dword); when that returns 0: 0x4fba69 on 0x5c3a67 with
 *     rec+0x2fd and the state of the record [self+0x1e] := 2.
 *     v = 4: when GetTickCount >= [self+0x4b] (unsigned): when rec+0x2fd differs from 0x54b1e0: 0x4fb77a on 0x5c3a67 with rec+0x2fd,
 *     0x4fb2e3 on 0x5c3a67 with the word [rec+0x31e], [self+0x24] := 3; when equal the state of the record [self+0x1e] := 2.
 *     v > 4: nothing. (State 1 ends here without the common tail.)
 * State 2: 0x5bb1ca := 1; for each of (rec+0x24f vs 0x54b1ec), (rec+0x280 vs 0x54b1f8), (rec+0x2b1 vs 0x54b204) whose nine bytes differ: 0x4fba69
 *   on 0x5c3a67 with rec + offset. When [self+0x43] is not 0 (else, when [self+0x47] is not 0, with the record offsets 0x2e2 .. 0x2fa instead
 *   of 0x32e .. 0x346): when the signed word [rec+0x32e] is not 0x270f: 0x5bb57b := that word (sign-extended), the word 0x5bb599 :=
 *   [rec+0x330], the word 0x5bb595 := [rec+0x332], the word 0x5c39ff := [rec+0x334], the dwords 0x5bb59b := [rec+0x336], 0x5bb59f :=
 *   [rec+0x33a], 0x5bb5a3 := [rec+0x33e], 0x5bb1ca := 0 when the signed word [rec+0x342] is 1 and 1 otherwise, 0x583999 := 4; when the
 *   signed word [rec+0x344] is not -1: the dword at 0x585801 + 4 * that word := the byte [rec+0x346]. Then (for state 2 whatever the bytes
 *   are) 0x42ba3a (cdecl) with the word [self+0x1e] (the upper half of the pushed dword is a leftover of ecx that depends on the path), and
 *   0x461862 on self.
 * Any other state: nothing. Strings and bytes of the record are read through Fl18Host.resolve. */
void m463392_step_scene(uint8_t *self, int16_t index, Fl22aWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = rd32(record_of(world->records_5bb5e5, index), 0);
    uint32_t state = rd32(record_of(world->records_5bb5e5, index), 0x4d);
    const uint8_t *rec = object_at(host, rec_va);
    const uint8_t *data = world->data_54b164;
    if (state == 0) {
        uint8_t *t;
        wr16(self, 0x1e, (uint16_t)index);
        wr32(self, 0x3f, 1);
        world->value_5bb1ca = 1;
        if (rec[0x21] == 0) call0(host, 0x4618df, (uintptr_t)self);
        call0(host, 0x4e8d96, 0x571442);
        wr32(self, 0x4f, rd32(rec, 0xd8) - rd32(rec, 0xd0));
        wr32(self, 0x53, rd32(rec, 0xdc) - rd32(rec, 0xd4));
        call0(host, 0x462577, (uintptr_t)self);
        self[0x28] = 1;
        wr16(self, 0x1c, (uint16_t)call0(host, 0x4d39f9, 0));
        t = slot_of(world, self);
        wr32(t, 0, 0xa);
        t = slot_of(world, self);
        wr32(t, 4, 0x463b10);
        t = slot_of(world, self);
        wr32(t, 8, 0);
        t = slot_of(world, self);
        wr32(t, 0xc, 0);
        t = slot_of(world, self);
        wr32(t, 0x10, 0);
        t = slot_of(world, self);
        wr32(t, 0x14, 1);
        t = slot_of(world, self);
        wr32(t, 0x18, 1);
        t = slot_of(world, self);
        wr16(t, 0x1c, 0);
        t = slot_of(world, self);
        copy_string(t + 0x22, data);
        if (rd32(self, 0x20) == 0) wr32(self, 0x20, call4(host, 0x4c2790, 0x5cf659, 0x54b19c, rec_va, 6, 0x54b180));
        t = slot_of(world, self);
        wr32(t, 8, rd32(self, 0x20));
        if (!same9(rec + 0x24f, data + (0x54b1a4 - 0x54b164))) call1(host, 0x4fb77a, 0x5c3a67, rec_va + 0x24fu);
        if (!same9(rec + 0x280, data + (0x54b1b0 - 0x54b164))) call1(host, 0x4fb77a, 0x5c3a67, rec_va + 0x280u);
        if (!same9(rec + 0x2b1, data + (0x54b1bc - 0x54b164))) call1(host, 0x4fb77a, 0x5c3a67, rec_va + 0x2b1u);
        wr32(self, 0x47, 0);
        wr32(self, 0x43, 0);
        wr32(self, 0x24, 0);
        wr32(record_of(world->records_5bb5e5, rds16(self, 0x1e)), 0x4d, 1);
        wr16(self, 0x39, 0);
        wr16(self, 0x57, 0);
        wr16(self, 0x59, 0);
        wr32(self, 0x3b, 0);
        wr32(self, 0x29, 0);
        wr32(self, 0x2d, 0);
        wr32(self, 0x31, 0);
        wr32(self, 0x35, 0);
        return;
    }
    if (state == 1) {
        uint32_t v = rd32(self, 0x24);
        if (v == 0) {
            wr32(self, 0x3b, 0);
            if (rd32(self, 0x47) != 0)
                wr32(self, 0x24, 1);
            else
                call0(host, 0x4632bf, (uintptr_t)self);
        } else if (v == 2) {
            if (call0(host, 0x461d82, (uintptr_t)self) != 0) {
                if (call1(host, 0x4619be, (uintptr_t)self, rd16(self, 0x57)) == 0) {
                    if (call3(host, 0x461d4b, (uintptr_t)self, rd16(self, 0x39), rd16(self, 0x5b), rd16(self, 0x5d)) != 0) {
                        if (!same9(rec + 0x280, data + (0x54b1c8 - 0x54b164))) call1(host, 0x4fb2e3, 0x5c3a67, rd16(rec, 0x2a1));
                    } else {
                        if (!same9(rec + 0x2b1, data + (0x54b1d4 - 0x54b164))) call1(host, 0x4fb2e3, 0x5c3a67, rd16(rec, 0x2d2));
                    }
                    wr32(self, 0x24, 0);
                }
            }
        } else if (v == 1) {
            wr32(self, 0x4b, tick_now(host) + (uint32_t)(rds16(rec, 0x2fb) * 1000));
            wr32(self, 0x24, 4);
        } else if (v == 4) {
            if (tick_now(host) >= rd32(self, 0x4b)) {
                if (!same9(rec + 0x2fd, data + (0x54b1e0 - 0x54b164))) {
                    call1(host, 0x4fb77a, 0x5c3a67, rec_va + 0x2fdu);
                    call1(host, 0x4fb2e3, 0x5c3a67, rd16(rec, 0x31e));
                    wr32(self, 0x24, 3);
                } else {
                    wr32(record_of(world->records_5bb5e5, rds16(self, 0x1e)), 0x4d, 2);
                }
            }
        } else if (v == 3) {
            int32_t w = rds16(rec, 0x31e);
            if (call1(host, 0x4f6334, 0x5cf1eb, (uintptr_t)(uint32_t)w) == 0) {
                call1(host, 0x4fba69, 0x5c3a67, rec_va + 0x2fdu);
                wr32(record_of(world->records_5bb5e5, rds16(self, 0x1e)), 0x4d, 2);
            }
        }
        return;
    }
    if (state == 2) {
        world->value_5bb1ca = 1;
        if (!same9(rec + 0x24f, data + (0x54b1ec - 0x54b164))) call1(host, 0x4fba69, 0x5c3a67, rec_va + 0x24fu);
        if (!same9(rec + 0x280, data + (0x54b1f8 - 0x54b164))) call1(host, 0x4fba69, 0x5c3a67, rec_va + 0x280u);
        if (!same9(rec + 0x2b1, data + (0x54b204 - 0x54b164))) call1(host, 0x4fba69, 0x5c3a67, rec_va + 0x2b1u);
        if (rd32(self, 0x43) != 0)
            apply_palette(world, rec, 0x32e);
        else if (rd32(self, 0x47) != 0)
            apply_palette(world, rec, 0x2e2);
        call1(host, 0x42ba3a, 0, rd16(self, 0x1e));
        call0(host, 0x461862, (uintptr_t)self);
    }
}

/* the cell of table 0x594db5 that the signed words [self+0x5b] (row) and [self+0x5d] (column) name; the original recomputes the address at every access */
static uint8_t *cell_of(const Fl22aWorld *world, const uint8_t *self)
{
    return world->cells_594db5 + (ptrdiff_t)rds16(self, 0x5b) * 0x140 + (ptrdiff_t)rds16(self, 0x5d) * 0x28;
}

/* the original address of cell + 0x14 (the pointer 0x461d82 hands to 0x462b84: lea [row * 0x140 + column * 0x28 + 0x594dc9]) */
static uint32_t cell_va_plus_14(const uint8_t *self)
{
    return (uint32_t)(rds16(self, 0x5b) * 0x140) + (uint32_t)(rds16(self, 0x5d) * 0x28) + 0x594dc9u;
}

/* One arm of the switch of 0x461d82; the four arms (0x461e0b, 0x461fe1, 0x4621b7, 0x46238d) are the same sequence of stores on different
 * fields: q = the signed dword [self+src] / the signed word [rec+0x24a] (idiv); cell+field_a := cell+field_a -/+ q; cell+field_b :=
 * cell+field_a + [self+src]; the word [self+0x59] += 1 and, when it equals the signed word [rec+0x24a]: the word cell+0x26 := 0, the dword
 * cell+0 := 0 when the word cell+0x24 is 0, 0x462b84 on self with (word row, word column, 0, original address of cell+0x14), the word
 * [self+axis] += delta, the word cell+0x26 := [self+0x39] (of the cell that the changed row / column names), the dword cell+0 := 1,
 * [self+0x59] := 0, the result := 1, [self+0x3b] := 1. Returns 0 with nothing more done when the division would fault. */
static int32_t step_arm(uint8_t *self, Fl22aWorld *world, const uint8_t *rec, const Fl18Host *host, ptrdiff_t field_a, ptrdiff_t src, int plus,
                        ptrdiff_t field_b, ptrdiff_t axis, int delta)
{
    int32_t divisor = rds16(rec, 0x24a);
    int32_t dividend = rds32(self, src);
    int32_t quotient;
    uint8_t *cell;
    if (divisor == 0 || (dividend == INT32_MIN && divisor == -1)) return 0;   /* the original's divide fault */
    quotient = dividend / divisor;
    cell = cell_of(world, self);
    wr32(cell, field_a, plus ? rd32(cell, field_a) + (uint32_t)quotient : rd32(cell, field_a) - (uint32_t)quotient);
    cell = cell_of(world, self);
    wr32(cell, field_b, rd32(cell, field_a) + rd32(self, src));
    wr16(self, 0x59, (uint16_t)(rd16(self, 0x59) + 1u));
    if (rds16(self, 0x59) == rds16(rec, 0x24a)) {
        cell = cell_of(world, self);
        wr16(cell, 0x26, 0);
        cell = cell_of(world, self);
        if (rds16(cell, 0x24) == 0) {
            cell = cell_of(world, self);
            wr32(cell, 0, 0);
        }
        call4(host, 0x462b84, (uintptr_t)self, rd16(self, 0x5b), rd16(self, 0x5d), 0, cell_va_plus_14(self));
        wr16(self, axis, (uint16_t)(rd16(self, axis) + (uint16_t)delta));
        cell = cell_of(world, self);
        wr16(cell, 0x26, rd16(self, 0x39));
        cell = cell_of(world, self);
        wr32(cell, 0, 1);
        wr16(self, 0x59, 0);
        wr32(self, 0x3b, 1);
        return 1;
    }
    return 0;
}

/* original GAME.EXE 0x461d82 (FUN_00461d82; thiscall, no stack argument, plain ret; result eax = 0 or 1): the step of a cell mover.
 * rec = the dword [record+0] of the record that the signed word [self+0x1e] names in the table at 0x5bb5e5 (the original address of the
 * record's object; read through Fl18Host.resolve); the cell is cell(row = signed word [self+0x5b], column = signed word [self+0x5d]) of the
 * table at 0x594db5 (Fl22aWorld.cells_594db5). First the 16 bytes (four dwords) at cell+0x14 are copied to self+0x29. Then the signed word
 * [self+0x57] - 0x10 selects the arm (unsigned compare with 3, the original's jump table of four dwords at 0x462567; any other value: the
 * result is 0 and nothing else happens): 0x10: step_arm(+0x14, [self+0x4f], minus, +0x1c, column - 1); 0x11: step_arm(+0x18, [self+0x53],
 * minus, +0x20, row - 1); 0x12: step_arm(+0x18, [self+0x53], plus, +0x20, row + 1); 0x13: step_arm(+0x14, [self+0x4f], plus, +0x1c,
 * column + 1). The words handed to 0x462b84 are only meaningful in their low 16 bits (the upper half is a leftover of edx = the address of
 * self and of the product column * 0x28). */
int32_t m461d82_move_step(uint8_t *self, Fl22aWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = rd32(record_of(world->records_5bb5e5, rds16(self, 0x1e)), 0);
    const uint8_t *rec = object_at(host, rec_va);
    const uint8_t *cell = cell_of(world, self);
    uint32_t arm;
    wr32(self, 0x29, rd32(cell, 0x14));
    wr32(self, 0x2d, rd32(cell, 0x18));
    wr32(self, 0x31, rd32(cell, 0x1c));
    wr32(self, 0x35, rd32(cell, 0x20));
    arm = (uint32_t)(rds16(self, 0x57) - 0x10);
    if (arm > 3) return 0;
    if (arm == 0) return step_arm(self, world, rec, host, 0x14, 0x4f, 0, 0x1c, 0x5d, -1);
    if (arm == 1) return step_arm(self, world, rec, host, 0x18, 0x53, 0, 0x20, 0x5b, -1);
    if (arm == 2) return step_arm(self, world, rec, host, 0x18, 0x53, 1, 0x20, 0x5b, 1);
    return step_arm(self, world, rec, host, 0x14, 0x4f, 1, 0x1c, 0x5d, 1);
}

/* the rectangle of 0x4778df in its frame (left, top, right, bottom = [ebp-0x40], [ebp-0x3c], [ebp-0x38], [ebp-0x34]) loaded from the four dwords of the
 * record at base (left), base + 4 (top), base + 8 (right), base + 0xc (bottom) plus the origin (x for left / right, y for top / bottom) */
static void load_rect(uint32_t *rect, const uint8_t *rec, ptrdiff_t base, const Fl22aWorld *world)
{
    rect[1] = rd32(rec, base + 4) + (uint32_t)world->origin_y_58318a;
    rect[3] = rd32(rec, base + 0xc) + (uint32_t)world->origin_y_58318a;
    rect[0] = rd32(rec, base) + (uint32_t)world->origin_x_583186;
    rect[2] = rd32(rec, base + 8) + (uint32_t)world->origin_x_583186;
}

/* the dword at 0x5d1599 + n * 0x4a, n = the signed word 0x622fc2 (re-read at every use, as the original does) */
static uint32_t dword_5d1599(const Fl22aWorld *world)
{
    return rd32(world->table_5d1599, (ptrdiff_t)world->word_622fc2 * 0x4a);
}

/* original GAME.EXE 0x4778df (FUN_004778df; cdecl, no stack argument, plain ret, no result): draws the scene of the record that the signed word 0x622fc4 names
 * (rec = the dword [record+0], the original address of the record's object, read through Fl18Host.resolve). Everything is a host call: C = 0x4c5377
 * (thiscall on 0x5cf659, five arguments), T = 0x475cc4 (thiscall on 0x622fa2, two arguments), W = 0x4d3836 and S = 0x50ca3e (cdecl, three arguments).
 * 1. When the byte 0x6237a4 is not 0: C(args [0x5d15e3], [0x5cf665], 0x583196, 0x583186, 0x54c9b0), then the byte := 0.
 * 2. When the dword 0x622fce is not 6: for i = 0 .. (signed word [rec+0x42]) - 1 (a word counter), for j = 0 .. (signed word [rec+0x44]) - 1 (a word counter):
 *    e = 0x622fd2 + i * 0xc8 + j * 0x14; when the byte [e] is not 0: when the byte [e+1] is 0: C([dword at 0x5d1599 + n * 0x4a], [0x5cf665], rec + (signed word
 *    [e+2] << 4) + 0x58, e + 4, 0x54c9d8), otherwise C([dword at 0x5d1599 + n * 0x4a], [0x5cf665], rec + 0x646, e + 4, 0x54c9f0) (n = the signed word 0x622fc2).
 *    Then, when the byte [rec+0x238] is not 0: when the byte 0x6237a2 is not 0: rect(0x6b8) (left = [rec+0x6b8] + x, top = [rec+0x6bc] + y, right = [rec+0x6c0] + x, bottom =
 *    [rec+0x6c4] + y; x = the dword 0x583186, y = the dword 0x58318a), T(0x6237a6, rec + 0x6b8), rect(0x6c8), C([5d1599 dword], [0x5cf665], 0x6237c7, &rect, 0x54ca08);
 *    otherwise, when the byte 0x6237a5 is not 0: rect(0x6b8), C([0x5d15e3], [0x5cf665], rec + 0x6b8, &rect, 0x54ca18), rect(0x6c8), C([0x5d15e3], [0x5cf665], rec + 0x6c8,
 *    &rect, 0x54ca3c), the byte 0x6237a5 := 0. Then, when the byte [rec+0x63d] is not 0: when the byte 0x6237a3 is not 0: rect(0x698), C([0x5d15e3], [0x5cf665],
 *    rec + 0x698, &rect, 0x54ca4c), the byte 0x6237a3 := 0; then T(0x6237d7, rec + 0x698). Then, when the byte 0x6237f8 differs from the byte 0x63a88c: rect(0x6a8),
 *    C([0x5d15e3], [0x5cf665], rec + 0x6a8, &rect, 0x54ca70), T(0x6237f8, rec + 0x6a8). Then, when the byte 0x62383a is not 0: rect(0x678), C([5d1599 dword],
 *    [0x5cf665], rec + 0x48, &rect, 0x54ca88); otherwise, when the byte 0x62383b is not 0: rect(0x678), C([0x5d15e3], [0x5cf665], rec + 0x678, &rect, 0x54caa8), the
 *    byte 0x62383b := 0. Then, when the byte [rec+0x23e] differs from the byte 0x63a890: T(rec + 0x23e, rec + 0x668); when the byte 0x623819 differs from the byte
 *    0x63a894: T(0x623819, rec + 0x688).
 * 3. When the dword 0x622fce is 6 and the signed word [rec+0x63e] is greater than 0: C([0x622fca], [0x5cf665], 0x583196, 0x583186, 0x54cac8); k = the signed word
 *    [rec+0x23a]; h = (word) (W(0x54caf0, k * 0x7f3 + 0x5a4c24, k * 0x1d0 + 0x5adb3a) as a signed word + 0xd); rect = (left [rec+0x6d8] + x, top [rec+0x6dc] + y - 6,
 *    right left + 0x64, bottom top + h); S(&buffer, 0x54caf4, 0x6237d7); T(&buffer, &rect); rect = (left [rec+0x6e0] + x, top [rec+0x6e4] + y - 0x10, right left +
 *    0x50, bottom top + h); then for m = 0 .. 4 (a word counter): top := bottom, bottom := top + h, S(&buffer, 0x54caf8, the dword at 0x5a0549 + m * 4), T(&buffer, &rect).
 * Divergence: the local buffer (0x24 bytes) is zeroed at entry; the original's is uninitialised stack. */
void m4778df_render(Fl22aWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = rd32(record_of(world->records_5bb5e5, world->word_622fc4), 0);
    const uint8_t *rec = object_at(host, rec_va);
    uint32_t rect[4];
    uint8_t buffer[0x24];
    memset(rect, 0, sizeof rect);
    memset(buffer, 0, sizeof buffer);
    if (world->byte_6237a4 != 0) {
        call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, 0x583196, 0x583186, 0x54c9b0);
        world->byte_6237a4 = 0;
    }
    if (world->value_622fce != 6) {
        int16_t i, j;
        for (i = 0; i < rds16(rec, 0x42); i = (int16_t)(i + 1)) {
            for (j = 0; j < rds16(rec, 0x44); j = (int16_t)(j + 1)) {
                ptrdiff_t e = (ptrdiff_t)i * 0xc8 + (ptrdiff_t)j * 0x14;
                uint32_t e_va = 0x622fd2u + (uint32_t)((int32_t)i * 0xc8) + (uint32_t)((int32_t)j * 0x14);
                if (world->table_622fd2[e] == 0) continue;
                if (world->table_622fd2[e + 1] == 0)
                    call5(host, 0x4c5377, 0x5cf659, dword_5d1599(world), world->value_5cf665,
                          rec_va + (uint32_t)(rds16(world->table_622fd2, e + 2) * 16) + 0x58u, e_va + 4u, 0x54c9d8);
                else
                    call5(host, 0x4c5377, 0x5cf659, dword_5d1599(world), world->value_5cf665, rec_va + 0x646u, e_va + 4u, 0x54c9f0);
            }
        }
        if (rec[0x238] != 0) {
            if (world->byte_6237a2 != 0) {
                load_rect(rect, rec, 0x6b8, world);
                call2(host, 0x475cc4, 0x622fa2, 0x6237a6, rec_va + 0x6b8u);
                load_rect(rect, rec, 0x6c8, world);
                call5(host, 0x4c5377, 0x5cf659, dword_5d1599(world), world->value_5cf665, 0x6237c7, (uintptr_t)rect, 0x54ca08);
            } else if (world->byte_6237a5 != 0) {
                load_rect(rect, rec, 0x6b8, world);
                call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, rec_va + 0x6b8u, (uintptr_t)rect, 0x54ca18);
                load_rect(rect, rec, 0x6c8, world);
                call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, rec_va + 0x6c8u, (uintptr_t)rect, 0x54ca3c);
                world->byte_6237a5 = 0;
            }
        }
        if (rec[0x63d] != 0) {
            if (world->byte_6237a3 != 0) {
                load_rect(rect, rec, 0x698, world);
                call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, rec_va + 0x698u, (uintptr_t)rect, 0x54ca4c);
                world->byte_6237a3 = 0;
            }
            call2(host, 0x475cc4, 0x622fa2, 0x6237d7, rec_va + 0x698u);
        }
        if (world->byte_6237f8 != world->byte_63a88c) {
            load_rect(rect, rec, 0x6a8, world);
            call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, rec_va + 0x6a8u, (uintptr_t)rect, 0x54ca70);
            call2(host, 0x475cc4, 0x622fa2, 0x6237f8, rec_va + 0x6a8u);
        }
        if (world->byte_62383a != 0) {
            load_rect(rect, rec, 0x678, world);
            call5(host, 0x4c5377, 0x5cf659, dword_5d1599(world), world->value_5cf665, rec_va + 0x48u, (uintptr_t)rect, 0x54ca88);
        } else if (world->byte_62383b != 0) {
            load_rect(rect, rec, 0x678, world);
            call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, rec_va + 0x678u, (uintptr_t)rect, 0x54caa8);
            world->byte_62383b = 0;
        }
        if (rec[0x23e] != world->byte_63a890) call2(host, 0x475cc4, 0x622fa2, rec_va + 0x23eu, rec_va + 0x668u);
        if (world->byte_623819 != world->byte_63a894) call2(host, 0x475cc4, 0x622fa2, 0x623819, rec_va + 0x688u);
        return;
    }
    if (rds16(rec, 0x63e) > 0) {
        int32_t k = rds16(rec, 0x23a);
        int16_t height;
        int16_t m;
        call5(host, 0x4c5377, 0x5cf659, world->value_622fca, world->value_5cf665, 0x583196, 0x583186, 0x54cac8);
        height = (int16_t)(uint16_t)(uint32_t)((int32_t)(int16_t)call3(host, 0x4d3836, 0, 0x54caf0, (uint32_t)(k * 0x7f3) + 0x5a4c24u, (uint32_t)(k * 0x1d0) + 0x5adb3au) + 0xd);
        rect[1] = rd32(rec, 0x6dc) + (uint32_t)world->origin_y_58318a - 6u;
        rect[3] = rect[1] + (uint32_t)(int32_t)height;
        rect[0] = rd32(rec, 0x6d8) + (uint32_t)world->origin_x_583186;
        rect[2] = rect[0] + 0x64u;
        call3(host, 0x50ca3e, 0, (uintptr_t)buffer, 0x54caf4, 0x6237d7);
        call2(host, 0x475cc4, 0x622fa2, (uintptr_t)buffer, (uintptr_t)rect);
        rect[1] = rd32(rec, 0x6e4) + (uint32_t)world->origin_y_58318a - 0x10u;
        rect[3] = rect[1] + (uint32_t)(int32_t)height;
        rect[0] = rd32(rec, 0x6e0) + (uint32_t)world->origin_x_583186;
        rect[2] = rect[0] + 0x50u;
        for (m = 0; m < 5; m = (int16_t)(m + 1)) {
            rect[1] = rect[3];
            rect[3] = rect[1] + (uint32_t)(int32_t)height;
            call3(host, 0x50ca3e, 0, (uintptr_t)buffer, 0x54caf8, rd32(world->dwords_5a0549, (ptrdiff_t)m * 4));
            call2(host, 0x475cc4, 0x622fa2, (uintptr_t)buffer, (uintptr_t)rect);
        }
    }
}
