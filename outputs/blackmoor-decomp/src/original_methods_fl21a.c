#include "original_methods_fl21a.h"

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

static int32_t rds32(const uint8_t *base, ptrdiff_t off)
{
    return (int32_t)rd32(base, off);
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

static uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3)
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

/* the signed 32-bit quotient-by-two of the original (cdq; sub eax, edx; sar eax, 1): rounds toward zero */
static int32_t half_toward_zero(uint32_t value)
{
    int32_t d = (int32_t)value;
    int32_t sign = d < 0 ? -1 : 0;
    return (int32_t)((uint32_t)d - (uint32_t)sign) >> 1;
}

/* the signed 32-bit quotient-by-four of the original (cdq; and edx, 3; add eax, edx; sar eax, 2): rounds toward zero */
static int32_t quarter_toward_zero(uint32_t value)
{
    int32_t d = (int32_t)value;
    uint32_t bias = d < 0 ? 3u : 0u;
    return (int32_t)((uint32_t)d + bias) >> 2;
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

/* original GAME.EXE 0x4cb586 (FUN_004cb586; thiscall, one word stack argument `index`, ret 4; the method of a player-state object whose
 * dword at +0x16 holds the object of record `index` and whose dword at +0x1a the address of a name). record = the table at 0x5bb5e5
 * (stride 0x8d) at the signed word `index`, the state is the dword [record+0x4d] (0x5bb632). [self+0x16] := the dword [record+0].
 * State 0: when [self+0x1a] is 0, 0x4cbba9 on self with ([self+0x16]); 0x4c0c2c on 0x637fcf: not 2 -> done; the name p = 0x4c0c18 on
 *   0x637fcf is compared with the name q = [self+0x1a] byte by byte in pairs (the inlined strcmp), a difference -> done. Otherwise
 *   [self+0xc] := 0xffff and, when the word [obj+0x21] of the record's object is not 0: [self+0xc] := (word) 0x4d39f9(); the record n of
 *   the table at 0x5d1591 (stride 0x4a, n = the signed word [self+0xc]) gets +0 = 0xf, +4 = 0x4cc79a, +8 = +0xc = +0x10 = 0, +0x14 =
 *   +0x18 = 1, the word +0x1c = 0 and the string at 0x558c30 copied to +0x22. Then [self+0x152] := the word 0x583a29 (0xffff when that
 *   is -1), [self+0x14a] := -1, [self+8] = [self+0x12] = [self+0x154] = [self+0x14e] = [self+0x15c] := 0, [self+0xe] := 1, the state
 *   := 1, and the original falls through into state 1.
 * State 1: [self+8] = [self+0x12] := 0; s = 0x4c0c2c on 0x637fcf: when s is neither 2 nor 3 the state := 2 and done; when s is 3 done;
 *   when s is 2: v = 0x4c0c54 on 0x637fcf; unless v is -1: [self+0x12] := 0x4cb944 on self with (v); when that is not 0 and v differs
 *   from [self+0x14a]: 0x4cb9d1 on self, [self+8] := 1, [self+0x14a] := v.
 * State 2: the byte [record+0x40] (0x5bb625) := 1; 0x4caf8a on self; 0x42ba3a (cdecl) with the word `index` (the upper half of the pushed
 *   dword is the ecx that 0x4caf8a left: a callee-dependent leftover, only the low 16 bits are meaningful).
 * Any other state: nothing. The strings are compared as unsigned bytes up to and including the first zero pair (unterminated strings
 * run on, as in the original). */
void m4cb586_visit(uint8_t *self, int16_t index, Fl21aWorld *world, const Fl18Host *host)
{
    int32_t n = (int32_t)index;
    uint32_t state;
    uint32_t s;
    wr32(self, 0x16, rd32(record_of(world->records_5bb5e5, n), 0));
    state = rd32(record_of(world->records_5bb5e5, n), 0x4d);
    if (state == 0) {
        const uint8_t *q;
        const uint8_t *p;
        uint8_t c19, c1a;
        int equal = 1;
        if (rd32(self, 0x1a) == 0) call1(host, 0x4cbba9, (uintptr_t)self, rd32(self, 0x16));
        s = call0(host, 0x4c0c2c, 0x637fcf);
        if (s != 2) return;
        p = object_at(host, call0(host, 0x4c0c18, 0x637fcf));
        q = object_at(host, rd32(self, 0x1a));
        for (;;) {
            c19 = q[0];
            if (c19 != p[0]) {
                equal = 0;
                break;
            }
            if (c19 == 0) break;
            c1a = q[1];
            if (c1a != p[1]) {
                equal = 0;
                break;
            }
            q += 2;
            p += 2;
            if (c1a == 0) break;
        }
        if (!equal) return;
        wr16(self, 0xc, 0xffff);
        if (rds16(object_at(host, rd32(self, 0x16)), 0x21) != 0) {
            uint8_t *t;
            wr16(self, 0xc, (uint16_t)call0(host, 0x4d39f9, 0));
            t = world->table_5d1591 + (ptrdiff_t)rds16(self, 0xc) * 0x4a;
            wr32(t, 0, 0xf);
            t = world->table_5d1591 + (ptrdiff_t)rds16(self, 0xc) * 0x4a;
            wr32(t, 4, 0x4cc79a);
            t = world->table_5d1591 + (ptrdiff_t)rds16(self, 0xc) * 0x4a;
            wr32(t, 8, 0);
            t = world->table_5d1591 + (ptrdiff_t)rds16(self, 0xc) * 0x4a;
            wr32(t, 0xc, 0);
            t = world->table_5d1591 + (ptrdiff_t)rds16(self, 0xc) * 0x4a;
            wr32(t, 0x10, 0);
            t = world->table_5d1591 + (ptrdiff_t)rds16(self, 0xc) * 0x4a;
            wr32(t, 0x14, 1);
            t = world->table_5d1591 + (ptrdiff_t)rds16(self, 0xc) * 0x4a;
            wr32(t, 0x18, 1);
            t = world->table_5d1591 + (ptrdiff_t)rds16(self, 0xc) * 0x4a;
            wr16(t, 0x1c, 0);
            t = world->table_5d1591 + (ptrdiff_t)rds16(self, 0xc) * 0x4a;
            copy_string(t + 0x22, world->string_558c30);
        }
        if (world->word_583a29 != -1)
            wr16(self, 0x152, (uint16_t)world->word_583a29);
        else
            wr16(self, 0x152, 0xffff);
        wr32(self, 0x14a, 0xffffffffu);
        wr32(self, 8, 0);
        wr32(self, 0x12, 0);
        wr32(self, 0x154, 0);
        wr32(self, 0x14e, 0);
        wr32(self, 0xe, 1);
        wr32(self, 0x15c, 0);
        wr32(record_of(world->records_5bb5e5, n), 0x4d, 1);
        state = 1;
    }
    if (state == 1) {
        wr32(self, 8, 0);
        wr32(self, 0x12, 0);
        s = call0(host, 0x4c0c2c, 0x637fcf);
        if (s != 2 && s != 3) {
            wr32(record_of(world->records_5bb5e5, n), 0x4d, 2);
            return;
        }
        if (s == 2) {
            uint32_t v = call0(host, 0x4c0c54, 0x637fcf);
            if ((int32_t)v != -1) {
                wr32(self, 0x12, call1(host, 0x4cb944, (uintptr_t)self, v));
                if (rd32(self, 0x12) != 0 && v != rd32(self, 0x14a)) {
                    call0(host, 0x4cb9d1, (uintptr_t)self);
                    wr32(self, 8, 1);
                    wr32(self, 0x14a, v);
                }
            }
        }
        return;
    }
    if (state == 2) {
        record_of(world->records_5bb5e5, n)[0x40] = 1;
        call0(host, 0x4caf8a, (uintptr_t)self);
        call1(host, 0x42ba3a, 0, (uint16_t)index);
    }
}

/* original GAME.EXE 0x42caa8 (FUN_0042caa8; cdecl, a word `index` and a pointer `clip` to four signed dwords, plain ret; entries of
 * stride 0x42 at the memory that the dword 0x5b4ea9 points to; `ent` = entry `index` (a signed word)):
 * When the signed word 0x5b4ea3 is 2: with r = the signed word 0x5b4e89, the record r of the table at 0x5bb5e5 (stride 0x8d) gets the dword
 *   +0x41 (0x5bb626) := 1 and the words +0x45, +0x47, +0x49, +0x4b (0x5bb62a, 2c, 2e, 30) := the low words of the dwords ent+0x12, +0x16,
 *   +0x1a, +0x1e.
 * y0 = the signed dword ent+0x16, y1 = ent+0x1e, c4 = clip[1] (clip+4), c12 = clip[3] (clip+0xc), ox = 0x583186, oy = 0x58318a:
 *   y1 <= c12 and y0 >= c4: 0x5b4e1c := ent+6, 0x5b4e24 := ent+0xe, 0x5b4e18 := ent+2, 0x5b4e20 := ent+0xa, 0x5b4e2c := y0 - c4 + oy,
 *     0x5b4e34 := y1 - c4 + oy, 0x5b4e28 := ent+0x12 + ox, 0x5b4e30 := ent+0x1a + ox, 0x5d1967 := 1.
 *   otherwise, when the entry reaches an edge of the clip (y0 <= c12 and y1 >= c12, or y0 <= c4 and y1 >= c4): 0x5b4e2c := max(y0, c4)
 *     (c4 when y0 < c4), 0x5b4e34 := min(y1, c12) (c12 when y1 > c12), then 0x5b4e1c := ent+6 + (0x5b4e2c - y0), 0x5b4e24 := ent+0xe -
 *     (y1 - 0x5b4e34), 0x5b4e18 := ent+2, 0x5b4e20 := ent+0xa, 0x5b4e2c := 0x5b4e2c - c4 + oy, 0x5b4e34 := 0x5b4e34 - c4 + oy, 0x5b4e28 :=
 *     ent+0x12 + ox, 0x5b4e30 := ent+0x1a + ox, 0x5d1967 := 1.
 *   otherwise nothing of that.
 * Then 0x5b4e5c := 0x5b4e2c - oy, 0x5b4e64 := 0x5b4e34 - oy, 0x5b4e58 := 0x5b4e28 - ox, 0x5b4e60 := 0x5b4e30 - ox and, when the signed
 * word 0x5b4e8b is 2, 0x42cecd (cdecl, two stack arguments) with (the dword that the original pushes from cx: the upper half is the
 * final value of 0x5b4e60 (ecx at the store), the low half the word `index`; then `clip`). All compares and sums are signed 32-bit. */
void m42caa8_clip_rect(int16_t index, const uint8_t *clip, Fl21aWorld *world, const Fl18Host *host)
{
    const uint8_t *ent;
    int32_t y0, y1, c4, c12;
    uint32_t ox, oy;
    if (world->word_5b4ea3 == 2) {
        uint8_t *rec = record_of(world->records_5bb5e5, world->word_5b4e89);
        wr32(rec, 0x41, 1);
        ent = world->entries_5b4ea9 + (ptrdiff_t)((int32_t)index * 0x42);
        wr16(rec, 0x45, rd16(ent, 0x12));
        ent = world->entries_5b4ea9 + (ptrdiff_t)((int32_t)index * 0x42);
        wr16(rec, 0x47, rd16(ent, 0x16));
        wr16(rec, 0x49, rd16(ent, 0x1a));
        wr16(rec, 0x4b, rd16(ent, 0x1e));
    }
    ent = world->entries_5b4ea9 + (ptrdiff_t)((int32_t)index * 0x42);
    ox = (uint32_t)world->origin_x_583186;
    oy = (uint32_t)world->origin_y_58318a;
    y0 = rds32(ent, 0x16);
    y1 = rds32(ent, 0x1e);
    c4 = rds32(clip, 4);
    c12 = rds32(clip, 0xc);
    if (y1 > c12) goto above;
    if (y0 < c4) goto above;
    world->value_5b4e1c = rd32(ent, 6);
    world->value_5b4e24 = rd32(ent, 0xe);
    world->value_5b4e18 = rd32(ent, 2);
    world->value_5b4e20 = rd32(ent, 0xa);
    world->value_5b4e2c = (uint32_t)y0 - (uint32_t)c4 + oy;
    world->value_5b4e34 = (uint32_t)y1 - (uint32_t)c4 + oy;
    world->value_5b4e28 = rd32(ent, 0x12) + ox;
    world->value_5b4e30 = rd32(ent, 0x1a) + ox;
    world->value_5d1967 = 1;
    goto done;
above:
    if (y0 > c12) goto edge_low;
    if (y1 >= c12) goto clipped;
edge_low:
    if (y0 > c4) goto done;
    if (y1 < c4) goto done;
clipped:
    if (y0 < c4)
        world->value_5b4e2c = (uint32_t)c4;
    else
        world->value_5b4e2c = (uint32_t)y0;
    if (y1 > c12)
        world->value_5b4e34 = (uint32_t)c12;
    else
        world->value_5b4e34 = (uint32_t)y1;
    world->value_5b4e1c = rd32(ent, 6) + (world->value_5b4e2c - (uint32_t)y0);
    world->value_5b4e24 = rd32(ent, 0xe) - ((uint32_t)y1 - world->value_5b4e34);
    world->value_5b4e18 = rd32(ent, 2);
    world->value_5b4e20 = rd32(ent, 0xa);
    world->value_5b4e2c = world->value_5b4e2c - (uint32_t)c4 + oy;
    world->value_5b4e34 = world->value_5b4e34 - (uint32_t)c4 + oy;
    world->value_5b4e28 = rd32(ent, 0x12) + ox;
    world->value_5b4e30 = rd32(ent, 0x1a) + ox;
    world->value_5d1967 = 1;
done:
    world->value_5b4e5c = world->value_5b4e2c - oy;
    world->value_5b4e64 = world->value_5b4e34 - oy;
    world->value_5b4e58 = world->value_5b4e28 - ox;
    world->value_5b4e60 = world->value_5b4e30 - ox;
    if (world->word_5b4e8b == 2)
        call2(host, 0x42cecd, 0, (world->value_5b4e60 & 0xffff0000u) | (uint16_t)index, (uintptr_t)clip);
}

/* original GAME.EXE 0x462c39 (FUN_00462c39; thiscall, two word stack arguments x and y, ret 8; returns eax = 0 or 1): pointer-move
 * hit test of a grid object. Nothing (0) when the dword [self+0x3f] is 0 or the dword [self+0x24] is 2. px = x + 0x583186 and
 * py = y + 0x58318a (x, y signed words); rec = the object of record [self+0x1e] (signed word) of the table at 0x5bb5e5; half =
 * [self+0x53] / 2 and q = [self+0x4f] / 4 (both toward zero, read where the original reads them). For row r = 0 .. (signed word)
 * [rec+0x22] - 1 and column c = 0 .. (signed word) [rec+0x24] - 1 (both signed words) of the cells at 0x594db5 (stride 0x28, rows of
 * 0x140): a cell whose word +0x26 is 0 is skipped; otherwise [self+0x39] := that word, [self+0x5b] := r, [self+0x5d] := c, and with
 * A = the dword cell+0x18, B = cell+0x14, C = cell+0x1c, D = cell+0x20 (signed) four tests are made in this order, each of which, when
 * it holds, asks 0x4619be on self with (direction): when that returns 1, 0x4630a3 on self with (code) and the function returns 1:
 *   0x11 / 0x2781: A <= py < A + half and B + q < px < C - q;
 *   0x13 / 0x2783: A <= py <= D and C - q < px <= C;
 *   0x12 / 0x2782: D - half <= py <= D and B + q < px < C - q;
 *   0x10 / 0x2780: A <= py <= D and B <= px < B + q.
 * After the loops: the word [self+0x57] := 0; then, when [rec+0x34b] <= y <= [rec+0x353] and [rec+0x347] <= x <= [rec+0x34f] (signed
 * dwords against the signed words), 0x4630a3 on self with (0x277f) and the result 1; otherwise 0. */
int32_t m462c39_pointer_move(uint8_t *self, int16_t x, int16_t y, const Fl21aWorld *world, const Fl18Host *host)
{
    uint32_t px, py;
    const uint8_t *rec;
    int16_t r, c;
    if (rd32(self, 0x3f) == 0) return 0;
    if (rd32(self, 0x24) == 2) return 0;
    px = (uint32_t)(int32_t)x + (uint32_t)world->origin_x_583186;
    py = (uint32_t)(int32_t)y + (uint32_t)world->origin_y_58318a;
    rec = object_at(host, rd32(record_of(world->records_5bb5e5, rds16(self, 0x1e)), 0));
    for (r = 0; (int32_t)r < rds16(rec, 0x22); r = (int16_t)(r + 1)) {
        for (c = 0; (int32_t)c < rds16(rec, 0x24); c = (int16_t)(c + 1)) {
            const uint8_t *cell = world->cells_594db5 + (ptrdiff_t)((int32_t)r * 0x140 + (int32_t)c * 0x28);
            if (rds16(cell, 0x26) == 0) continue;
            wr16(self, 0x39, rd16(cell, 0x26));
            wr16(self, 0x5b, (uint16_t)r);
            wr16(self, 0x5d, (uint16_t)c);
            /* direction 0x11 (up): A <= py < A + half, B + q < px < C - q */
            if (!((int32_t)py < rds32(cell, 0x18)) && (int32_t)py < (int32_t)(rd32(cell, 0x18) + (uint32_t)half_toward_zero(rd32(self, 0x53))) &&
                (int32_t)px > (int32_t)(rd32(cell, 0x14) + (uint32_t)quarter_toward_zero(rd32(self, 0x4f))) &&
                (int32_t)px < (int32_t)(rd32(cell, 0x1c) - (uint32_t)quarter_toward_zero(rd32(self, 0x4f)))) {
                if (call1(host, 0x4619be, (uintptr_t)self, 0x11) == 1) {
                    call1(host, 0x4630a3, (uintptr_t)self, 0x2781);
                    return 1;
                }
            }
            /* direction 0x13 (right): A <= py <= D, C - q < px <= C */
            if (!((int32_t)py < rds32(cell, 0x18)) && !((int32_t)py > rds32(cell, 0x20)) &&
                (int32_t)px > (int32_t)(rd32(cell, 0x1c) - (uint32_t)quarter_toward_zero(rd32(self, 0x4f))) && !((int32_t)px > rds32(cell, 0x1c))) {
                if (call1(host, 0x4619be, (uintptr_t)self, 0x13) == 1) {
                    call1(host, 0x4630a3, (uintptr_t)self, 0x2783);
                    return 1;
                }
            }
            /* direction 0x12 (down): D - half <= py <= D, B + q < px < C - q */
            if (!((int32_t)py < (int32_t)(rd32(cell, 0x20) - (uint32_t)half_toward_zero(rd32(self, 0x53)))) && !((int32_t)py > rds32(cell, 0x20)) &&
                (int32_t)px > (int32_t)(rd32(cell, 0x14) + (uint32_t)quarter_toward_zero(rd32(self, 0x4f))) &&
                (int32_t)px < (int32_t)(rd32(cell, 0x1c) - (uint32_t)quarter_toward_zero(rd32(self, 0x4f)))) {
                if (call1(host, 0x4619be, (uintptr_t)self, 0x12) == 1) {
                    call1(host, 0x4630a3, (uintptr_t)self, 0x2782);
                    return 1;
                }
            }
            /* direction 0x10 (left): A <= py <= D, B <= px < B + q */
            if (!((int32_t)py < rds32(cell, 0x18)) && !((int32_t)py > rds32(cell, 0x20)) && !((int32_t)px < rds32(cell, 0x14)) &&
                (int32_t)px < (int32_t)(rd32(cell, 0x14) + (uint32_t)quarter_toward_zero(rd32(self, 0x4f)))) {
                if (call1(host, 0x4619be, (uintptr_t)self, 0x10) == 1) {
                    call1(host, 0x4630a3, (uintptr_t)self, 0x2780);
                    return 1;
                }
            }
        }
    }
    wr16(self, 0x57, 0);
    if ((int32_t)y < rds32(rec, 0x34b)) return 0;
    if ((int32_t)y > rds32(rec, 0x353)) return 0;
    if ((int32_t)x < rds32(rec, 0x347)) return 0;
    if ((int32_t)x > rds32(rec, 0x34f)) return 0;
    call1(host, 0x4630a3, (uintptr_t)self, 0x277f);
    return 1;
}

/* original GAME.EXE 0x484f42 (FUN_00484f42; thiscall, two word stack arguments x and y and a pointer `rect` to four dwords, ret 0xc;
 * returns eax = 0 or 1): pointer-move hit test of a list object. rec = the object of record [self+0x26] (signed word) of the table at
 * 0x5bb5e5. Nothing (0) when the dword [self+0xba7] is 0. Otherwise slot0 = self + (signed word [self+0xa9e]) * 0x85 + 0x28 and
 * [self+0xbb5] := rect[1], [self+0xbbd] := rect[3], [self+0xbb1] := rect[0], [self+0xbb9] := rect[2] (in that order).
 * When the dword [self+0xa92] is not 0: 0x484d87 on self; ok = 1, and when [rec+0x5bf] - [rec+0x5b7] is not 0 ok := 0 unless
 *   [rec+0x5bb] <= y <= [rec+0x5c3] and [rec+0x5b7] <= x <= [rec+0x5bf]; ok 0 -> return 0. The word [rec+0x2b] := 0 when the byte [rec+0x2a]
 *   is 0. Then, with t = the signed word [rec+0x2b] and e = (signed word [self+0xa9e]) * 0x42: when the byte [slot0+0x22] is 0 and
 *   [self+0xaa4] >= [rec+e+0xa3] - t, [self+0xaac] <= [rec+e+0xab] + t, [self+0xaa0] >= [rec+e+0x9f] - t and [self+0xaa8] <=
 *   [rec+e+0xa7] + t (signed): 0x4854fb on self with (0x277b), otherwise with (0x277a); return 1.
 * When it is 0: the 40 bytes at self+0xbd1 := 0, the words [self+0xbf9] and [self+0xc23] := 0; for i = 0 ... (signed word [rec+0x21]) - 1
 *   (a dword counter), slot = self + i * 0x85 + 0x28: when the bytes [rec+0x24] and [rec+0x25] are not 0 and [slot+6] <= y <= [slot+6] +
 *   (word [rec+0x26]) and [slot+2] <= x <= [slot+2] + (word [rec+0x28]): the word [self+0xbfb + 2 * (word [self+0xc23])] := i and the word
 *   [self+0xc23] += 1; otherwise, when the byte [slot+0x23] is 0 and [slot+6] <= y <= [slot+0xe] and [slot+2] <= x <= [slot+0xa]: the word
 *   [self+0xbd1 + 2 * (word [self+0xbf9])] := i and [self+0xbf9] += 1. After the loop: the word [self+0xc23] not 0: 0x4854fb with (0x2778),
 *   return 1; the word [self+0xbf9] not 0: (0x2777), return 1; the dword [self+0xc27] not 0 and [rec+0x5fc] <= y <= [rec+0x604] and
 *   [rec+0x5f8] <= x < [rec+0x600]: (0x277c), return 1; [rec+0xefb] <= y <= [rec+0xf03] and [rec+0xef7] <= x <= [rec+0xeff]: (0x2779),
 *   return 1; otherwise 0. All compares are signed; x and y are the sign-extended words. */
int32_t m484f42_pointer_move(uint8_t *self, int16_t x, int16_t y, const uint8_t *rect, const Fl21aWorld *world, const Fl18Host *host)
{
    int32_t ok = 1;
    int32_t sx = (int32_t)x, sy = (int32_t)y;
    const uint8_t *rec = object_at(host, rd32(record_of(world->records_5bb5e5, rds16(self, 0x26)), 0));
    uint8_t *slot;
    if (rd32(self, 0xba7) == 0) return 0;
    slot = self + (ptrdiff_t)(rds16(self, 0xa9e) * 0x85) + 0x28;
    wr32(self, 0xbb5, rd32(rect, 4));
    wr32(self, 0xbbd, rd32(rect, 0xc));
    wr32(self, 0xbb1, rd32(rect, 0));
    wr32(self, 0xbb9, rd32(rect, 8));
    if (rd32(self, 0xa92) != 0) {
        call0(host, 0x484d87, (uintptr_t)self);
        if (rd32(rec, 0x5bf) - rd32(rec, 0x5b7) != 0) {
            if (sy < rds32(rec, 0x5bb) || sy > rds32(rec, 0x5c3) || sx < rds32(rec, 0x5b7) || sx > rds32(rec, 0x5bf)) ok = 0;
        }
        if (ok == 0) return 0;
        if (rec[0x2a] == 0) wr16((uint8_t *)rec, 0x2b, 0);
        if (slot[0x22] == 0) {
            ptrdiff_t e = (ptrdiff_t)(rds16(self, 0xa9e) * 0x42);
            if (!(rds32(self, 0xaa4) < (int32_t)(rd32(rec, e + 0xa3) - (uint32_t)rds16(rec, 0x2b)))) {
                e = (ptrdiff_t)(rds16(self, 0xa9e) * 0x42);
                if (!(rds32(self, 0xaac) > (int32_t)(rd32(rec, e + 0xab) + (uint32_t)rds16(rec, 0x2b)))) {
                    e = (ptrdiff_t)(rds16(self, 0xa9e) * 0x42);
                    if (!(rds32(self, 0xaa0) < (int32_t)(rd32(rec, e + 0x9f) - (uint32_t)rds16(rec, 0x2b)))) {
                        e = (ptrdiff_t)(rds16(self, 0xa9e) * 0x42);
                        if (!(rds32(self, 0xaa8) > (int32_t)(rd32(rec, e + 0xa7) + (uint32_t)rds16(rec, 0x2b)))) {
                            call1(host, 0x4854fb, (uintptr_t)self, 0x277b);
                            return 1;
                        }
                    }
                }
            }
        }
        call1(host, 0x4854fb, (uintptr_t)self, 0x277a);
        return 1;
    }
    memset(self + 0xbd1, 0, 40);
    wr16(self, 0xbf9, 0);
    wr16(self, 0xc23, 0);
    {
        int32_t i;
        for (i = 0; i < rds16(rec, 0x21); i++) {
            slot = self + (ptrdiff_t)(i * 0x85) + 0x28;
            if (rec[0x24] != 0 && rec[0x25] != 0 && !(sy < rds32(slot, 6)) &&
                !(sy > (int32_t)(rd32(slot, 6) + (uint32_t)rds16(rec, 0x26))) && !(sx < rds32(slot, 2)) &&
                !(sx > (int32_t)(rd32(slot, 2) + (uint32_t)rds16(rec, 0x28)))) {
                wr16(self, 0xbfb + (ptrdiff_t)rds16(self, 0xc23) * 2, (uint16_t)i);
                wr16(self, 0xc23, (uint16_t)(rd16(self, 0xc23) + 1));
                continue;
            }
            if (slot[0x23] == 0 && !(sy < rds32(slot, 6)) && !(sy > rds32(slot, 0xe)) && !(sx < rds32(slot, 2)) && !(sx > rds32(slot, 0xa))) {
                wr16(self, 0xbd1 + (ptrdiff_t)rds16(self, 0xbf9) * 2, (uint16_t)i);
                wr16(self, 0xbf9, (uint16_t)(rd16(self, 0xbf9) + 1));
            }
        }
    }
    if (rds16(self, 0xc23) != 0) {
        call1(host, 0x4854fb, (uintptr_t)self, 0x2778);
        return 1;
    }
    if (rds16(self, 0xbf9) != 0) {
        call1(host, 0x4854fb, (uintptr_t)self, 0x2777);
        return 1;
    }
    if (rd32(self, 0xc27) != 0 && !(sy < rds32(rec, 0x5fc)) && !(sy > rds32(rec, 0x604)) && !(sx < rds32(rec, 0x5f8)) && sx < rds32(rec, 0x600)) {
        call1(host, 0x4854fb, (uintptr_t)self, 0x277c);
        return 1;
    }
    if (!(sy < rds32(rec, 0xefb)) && !(sy > rds32(rec, 0xf03)) && !(sx < rds32(rec, 0xef7)) && !(sx > rds32(rec, 0xeff))) {
        call1(host, 0x4854fb, (uintptr_t)self, 0x2779);
        return 1;
    }
    return 0;
}

/* original GAME.EXE 0x48d914 (FUN_0048d914; thiscall, one word stack argument `index`, ret 4; no result): the step of a scene player
 * object for record `index` (signed word) of the table at 0x5bb5e5; rec = the dword [record+0] (the original address of the record's
 * object), state = the dword [record+0x4d] (0x5bb632).
 * State 0: the word [self+0x1e] := index, [self+0x33] := 1, the bytes [self+0x26], [self+0x25], [self+0x24] := 0, [self+0x20] := 0,
 *   0x5bb1ca := 1, 0x4e8d96 on 0x571442, the 15 bytes at self+0x3d (dword, dword, dword, word, byte) := 0, the bytes [self+0x38] and
 *   [self+0x37] := 0. When the first byte of the record's string [rec+0] equals the byte at 0x63a8ac: [self+0x2f] := 0. Otherwise
 *   [self+0x2f] := 1, [self+0x1c] := (word) 0x4d39f9(), the record n of the table at 0x5d1591 (stride 0x4a, n = the signed word
 *   [self+0x1c]) gets +0 = 0xa, +4 = 0x48ded7, +8 = +0xc = +0x10 = 0, +0x14 = +0x18 = 1, the word +0x1c = 0 and the string at 0x54e89c
 *   copied to +0x22; when [self+0x20] is 0: [self+0x20] := 0x4c2790 on 0x5cf659 with (0x54e8cc, rec, 6, 0x54e8b4); the dword +8 of that
 *   record (0x5d1599 + n * 0x4a) := [self+0x20]. Then [self+0x2b] := 1 and the state of the record [self+0x1e] := 1.
 * State 1 (v = [self+0x2b]; unsigned compare with 4, the original's jump table): v = 0: GetTickCount; when it is >= [self+0x39] (unsigned):
 *     0x4fba69 on 0x5c3a67 with (rec + 0x715), [self+0x2b] := 1, the bytes [self+0x24] and [self+0x25] := 1, [self+0x26] := 0.
 *   v = 1: 0x48d89e on self when [self+0x2f] is 0.
 *   v = 2: [self+0x39] := GetTickCount + (signed word [rec+0x75f]) * 1000, [self+0x2b] := 3.
 *   v = 3: GetTickCount; when it is >= [self+0x39]: when the nine bytes at rec+0x761 differ from those at 0x54e8d4: 0x4fb77a on 0x5c3a67 with
 *     (rec + 0x761), 0x4fb2e3 on 0x5c3a67 with the word [rec+0x782] (the upper half is a leftover of edx, callee dependent: only the low 16
 *     bits are meaningful), [self+0x2b] := 4; when they are equal the state of the record [self+0x1e] := 2.
 *   v = 4: w = the signed word [rec+0x782]; 0x4f6334 on 0x5cf1eb with (w as a dword); when that returns 0: 0x4fba69 on 0x5c3a67 with
 *     (rec + 0x761) and the state of the record [self+0x1e] := 2.
 *   v > 4: nothing. (State 1 ends here without the common tail.)
 * State 2: 0x5bb1ca := 1. When the byte [self+0x37] is not 0, or else when the byte [self+0x38] is not 0 (then with the record offsets 0x746
 *   .. 0x75e instead of 0x792 .. 0x7aa): when the signed word [rec+0x792] is not 0x270f: 0x5bb57b := that word (sign-extended), the word
 *   0x5bb599 := [rec+0x794], the word 0x5bb595 := [rec+0x796], the word 0x5c39ff := [rec+0x798], the dwords 0x5bb59b := [rec+0x79a],
 *   0x5bb59f := [rec+0x79e], 0x5bb5a3 := [rec+0x7a2], 0x5bb1ca := 0 when the signed word [rec+0x7a6] is 1 and 1 otherwise, 0x583999 := 4;
 *   when the signed word [rec+0x7a8] is not -1: the dword at 0x585801 + 4 * that word := the byte [rec+0x7aa]. Then (for state 2
 *   whatever the bytes are) 0x42ba3a (cdecl) with the word [self+0x1e] (the upper half is a leftover of edx that depends on the path:
 *   only the low 16 bits are meaningful), and 0x48d09c on self.
 * Any other state: nothing. Strings and bytes of the record are read through Fl18Host.resolve. */
void m48d914_step_scene(uint8_t *self, int16_t index, Fl21aWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = rd32(record_of(world->records_5bb5e5, index), 0);
    uint32_t state = rd32(record_of(world->records_5bb5e5, index), 0x4d);
    const uint8_t *rec = object_at(host, rec_va);
    if (state == 0) {
        uint8_t *t;
        wr16(self, 0x1e, (uint16_t)index);
        wr32(self, 0x33, 1);
        self[0x26] = 0;
        self[0x25] = 0;
        self[0x24] = 0;
        wr32(self, 0x20, 0);
        world->value_5bb1ca = 1;
        call0(host, 0x4e8d96, 0x571442);
        wr32(self, 0x3d, 0);
        wr32(self, 0x41, 0);
        wr32(self, 0x45, 0);
        wr16(self, 0x49, 0);
        self[0x4b] = 0;
        self[0x38] = 0;
        self[0x37] = 0;
        if (rec[0] == world->byte_63a8ac) {
            wr32(self, 0x2f, 0);
        } else {
            wr32(self, 0x2f, 1);
            wr16(self, 0x1c, (uint16_t)call0(host, 0x4d39f9, 0));
            t = world->table_5d1591 + (ptrdiff_t)rds16(self, 0x1c) * 0x4a;
            wr32(t, 0, 0xa);
            t = world->table_5d1591 + (ptrdiff_t)rds16(self, 0x1c) * 0x4a;
            wr32(t, 4, 0x48ded7);
            t = world->table_5d1591 + (ptrdiff_t)rds16(self, 0x1c) * 0x4a;
            wr32(t, 8, 0);
            t = world->table_5d1591 + (ptrdiff_t)rds16(self, 0x1c) * 0x4a;
            wr32(t, 0xc, 0);
            t = world->table_5d1591 + (ptrdiff_t)rds16(self, 0x1c) * 0x4a;
            wr32(t, 0x10, 0);
            t = world->table_5d1591 + (ptrdiff_t)rds16(self, 0x1c) * 0x4a;
            wr32(t, 0x14, 1);
            t = world->table_5d1591 + (ptrdiff_t)rds16(self, 0x1c) * 0x4a;
            wr32(t, 0x18, 1);
            t = world->table_5d1591 + (ptrdiff_t)rds16(self, 0x1c) * 0x4a;
            wr16(t, 0x1c, 0);
            t = world->table_5d1591 + (ptrdiff_t)rds16(self, 0x1c) * 0x4a;
            copy_string(t + 0x22, world->string_54e89c);
            if (rd32(self, 0x20) == 0) wr32(self, 0x20, call4(host, 0x4c2790, 0x5cf659, 0x54e8cc, rec_va, 6, 0x54e8b4));
            t = world->table_5d1591 + (ptrdiff_t)rds16(self, 0x1c) * 0x4a;
            wr32(t, 8, rd32(self, 0x20));
        }
        wr32(self, 0x2b, 1);
        wr32(record_of(world->records_5bb5e5, rds16(self, 0x1e)), 0x4d, 1);
        return;
    }
    if (state == 1) {
        uint32_t v = rd32(self, 0x2b);
        if (v == 0) {
            if (tick_now(host) >= rd32(self, 0x39)) {
                call1(host, 0x4fba69, 0x5c3a67, rec_va + 0x715u);
                wr32(self, 0x2b, 1);
                self[0x24] = 1;
                self[0x25] = 1;
                self[0x26] = 0;
            }
        } else if (v == 1) {
            if (rd32(self, 0x2f) == 0) call0(host, 0x48d89e, (uintptr_t)self);
        } else if (v == 2) {
            wr32(self, 0x39, tick_now(host) + (uint32_t)(rds16(rec, 0x75f) * 1000));
            wr32(self, 0x2b, 3);
        } else if (v == 3) {
            if (tick_now(host) >= rd32(self, 0x39)) {
                if (memcmp(rec + 0x761, world->bytes_54e8d4, 9) != 0) {
                    call1(host, 0x4fb77a, 0x5c3a67, rec_va + 0x761u);
                    call1(host, 0x4fb2e3, 0x5c3a67, rd16(rec, 0x782));
                    wr32(self, 0x2b, 4);
                } else {
                    wr32(record_of(world->records_5bb5e5, rds16(self, 0x1e)), 0x4d, 2);
                }
            }
        } else if (v == 4) {
            int32_t w = rds16(rec, 0x782);
            if (call1(host, 0x4f6334, 0x5cf1eb, (uintptr_t)(uint32_t)w) == 0) {
                call1(host, 0x4fba69, 0x5c3a67, rec_va + 0x761u);
                wr32(record_of(world->records_5bb5e5, rds16(self, 0x1e)), 0x4d, 2);
            }
        }
        return;
    }
    if (state == 2) {
        world->value_5bb1ca = 1;
        if (self[0x37] != 0) {
            if (rds16(rec, 0x792) != 0x270f) {
                world->value_5bb57b = (uint32_t)rds16(rec, 0x792);
                world->word_5bb599 = rd16(rec, 0x794);
                world->word_5bb595 = rd16(rec, 0x796);
                world->word_5c39ff = rd16(rec, 0x798);
                world->value_5bb59b = rd32(rec, 0x79a);
                world->value_5bb59f = rd32(rec, 0x79e);
                world->value_5bb5a3 = rd32(rec, 0x7a2);
                if (rds16(rec, 0x7a6) == 1)
                    world->value_5bb1ca = 0;
                else
                    world->value_5bb1ca = 1;
                world->value_583999 = 4;
            }
            if (rds16(rec, 0x7a8) != -1) wr32(world->flags_585801, (ptrdiff_t)rds16(rec, 0x7a8) * 4, rec[0x7aa]);
        } else if (self[0x38] != 0) {
            if (rds16(rec, 0x746) != 0x270f) {
                world->value_5bb57b = (uint32_t)rds16(rec, 0x746);
                world->word_5bb599 = rd16(rec, 0x748);
                world->word_5bb595 = rd16(rec, 0x74a);
                world->word_5c39ff = rd16(rec, 0x74c);
                world->value_5bb59b = rd32(rec, 0x74e);
                world->value_5bb59f = rd32(rec, 0x752);
                world->value_5bb5a3 = rd32(rec, 0x756);
                if (rds16(rec, 0x75a) == 1)
                    world->value_5bb1ca = 0;
                else
                    world->value_5bb1ca = 1;
                world->value_583999 = 4;
            }
            if (rds16(rec, 0x75c) != -1) wr32(world->flags_585801, (ptrdiff_t)rds16(rec, 0x75c) * 4, rec[0x75e]);
        }
        call1(host, 0x42ba3a, 0, rd16(self, 0x1e));
        call0(host, 0x48d09c, (uintptr_t)self);
    }
}
