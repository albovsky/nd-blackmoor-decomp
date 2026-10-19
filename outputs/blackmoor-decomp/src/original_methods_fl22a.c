#include "original_methods_fl22a.h"

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
