#include "original_methods_fl25d.h"

#include <string.h>

#define UNUSED_OK __attribute__((unused))

static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

UNUSED_OK static int32_t rds32(const uint8_t *base, ptrdiff_t off)
{
    return (int32_t)rd32(base, off);
}

UNUSED_OK static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
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

/* a signed word, sign-extended (movsx) */
static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

UNUSED_OK static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, NULL, 0) : 0;
}

UNUSED_OK static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    uintptr_t args[2];
    args[0] = a0;
    args[1] = a1;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 2) : 0;
}

/* `movsx ecx, word [self + idx]; imul ecx, ecx, 0x8d`: the byte offset of the record n in the table at 0x5bb5e5 */
static ptrdiff_t rec_offset(const uint8_t *self, ptrdiff_t idx_off)
{
    return (ptrdiff_t)(rds16(self, idx_off) * 0x8d);
}

/* `mov eax, [n * 0x8d + 0x5bb5e5]`: the original address of the object of record n */
static uint32_t record_object_address(const Fl25dWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    return rd32(world->records_5bb5e5, rec_offset(self, idx_off));
}

UNUSED_OK static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    uintptr_t args[3];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 3) : 0;
}

static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    uintptr_t args[1];
    args[0] = a0;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 1) : 0;
}

/* the object of an original address (an address that a record or an object keeps), as host memory */
static const uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return host->resolve(host->context, address);
}

/* the signed compare of a sign-extended word with a dword of memory: lo <= v <= hi (jl / jg leave the range) */
UNUSED_OK static int in_range(int32_t v, int32_t lo, int32_t hi)
{
    return !(v < lo) && !(v > hi);
}

/* repe cmpsb with ecx = 9: 1 when the nine bytes at a and b are equal */
static int nine_bytes_equal(const uint8_t *a, const uint8_t *b)
{
    int k;
    for (k = 0; k < 9; k++)
        if (a[k] != b[k]) return 0;
    return 1;
}

/* ---- 0x4712bd ------------------------------------------------------------------------------------------------------------------ */

/* 0x4712bd, thiscall, plain `ret`. R (the local [ebp-4]) is the object of the record of the signed word [+0xd28], read at entry; every field of
 * `self` is read again where the original reads it (the original keeps nothing of self in a register except the pointer). Gates: byte [+0xd3e]
 * clear returns, dword [+0xd2c] != 0 returns, record state != 1 returns. s is the signed word [+0xd2a].
 * If s != 0x28 and the selector is 0x27a6 (b = byte [+0xc9c + s], c = byte [R+0x23], n = word [+0xd32], m = signed word [R+0x21]):
 *  - b and c set: b = 0; t = n - 1 (a word), 0 when negative; when the signed word [+0xd4a + 2t] equals s: n = n - 1, 0 when negative,
 *    and the word [+0xd4a + 2n] = 0xffff;
 *  - else c set: when n <= m - 1 the word [+0xd4a + 2n] = s; when b is clear: n = n + 1 and b = 1; when n > m: n = m;
 *  - else (c clear) when b is clear: n = n + 1; with d = signed word [+0xd01] > 0 and n > d: n = d; b = 1; [+0xe00] = GetTickCount + 0x12c;
 *    byte [+0xd3b] = 1; for i below d - 1 (a word): word [+0xd4a + 2i] = word [+0xd4c + 2i]; word [+0xd48 + 2d] = s.
 * Then (all three arms): when the signed word [+0xe06] > 0 and the signed word [+0xd30] <= m - 1: word [+0xdc2 + 2k] = s with k = [+0xd30],
 * and [+0xd30] += 1. Then, still under the selector test and for any s: with the flag 0x5bb1ca set and the nine bytes at R + 0x66 different
 * from the constant at 0x54c480, 0x4fb2e3(this = 0x5c3a67) is called with the word [R+0x87] (the original pushes it zero-extended). Then,
 * when byte [R+0x24] is set and s == 0x28: byte [+0xd3a] = 1, [+0xe00] = GetTickCount + 0x12c and the same announcement against 0x54c48c.
 * At last, with the selector 0x27ad: byte [+0xd3f] = 1 and the record state = 2. */
void m4712bd_click_27a6_27ad(uint8_t *self, Fl25dWorld *world, const Fl18Host *host)
{
    uint32_t record = record_object_address(world, self, 0xd28);
    const uint8_t *r;
    if (self[0xd3e] == 0) return;
    if (rd32(self, 0xd2c) != 0) return;
    if (rd32(world->records_5bb5e5, rec_offset(self, 0xd28) + 0x4d) != 1) return;
    r = object_at(host, record);
    if (rds16(self, 0xd2a) != 0x28 && world->value_5c39e5 == 0x27a6) {
        if (self[rds16(self, 0xd2a) + 0xc9c] != 0 && r[0x23] != 0) {
            int16_t t;
            self[rds16(self, 0xd2a) + 0xc9c] = 0;
            t = (int16_t)(rd16(self, 0xd32) - 1);
            if ((int32_t)t < 0) t = 0;
            if (rds16(self, 0xd4a + 2 * (ptrdiff_t)t) == rds16(self, 0xd2a)) {
                wr16(self, 0xd32, (uint16_t)(rd16(self, 0xd32) - 1));
                if (rds16(self, 0xd32) < 0) wr16(self, 0xd32, 0);
                wr16(self, 0xd4a + 2 * rds16(self, 0xd32), 0xffff);
            }
        } else if (r[0x23] != 0) {
            if (!(rds16(self, 0xd32) > rds16(r, 0x21) - 1)) wr16(self, 0xd4a + 2 * rds16(self, 0xd32), rd16(self, 0xd2a));
            if (self[rds16(self, 0xd2a) + 0xc9c] == 0) {
                wr16(self, 0xd32, (uint16_t)(rd16(self, 0xd32) + 1));
                self[rds16(self, 0xd2a) + 0xc9c] = 1;
            }
            if (rds16(self, 0xd32) > rds16(r, 0x21)) wr16(self, 0xd32, rd16(r, 0x21));
        } else if (self[rds16(self, 0xd2a) + 0xc9c] == 0) {
            int16_t i;
            wr16(self, 0xd32, (uint16_t)(rd16(self, 0xd32) + 1));
            if (rds16(self, 0xd01) > 0 && rds16(self, 0xd32) > rds16(self, 0xd01)) wr16(self, 0xd32, rd16(self, 0xd01));
            self[rds16(self, 0xd2a) + 0xc9c] = 1;
            wr32(self, 0xe00, host->tick(host->context) + 0x12c);
            self[0xd3b] = 1;
            for (i = 0; (int32_t)i < rds16(self, 0xd01) - 1; i = (int16_t)(i + 1))
                wr16(self, 0xd4a + 2 * (ptrdiff_t)i, rd16(self, 0xd4c + 2 * (ptrdiff_t)i));
            wr16(self, 0xd48 + 2 * rds16(self, 0xd01), rd16(self, 0xd2a));
        }
        if (rds16(self, 0xe06) > 0 && !(rds16(self, 0xd30) > rds16(r, 0x21) - 1)) {
            wr16(self, 0xdc2 + 2 * rds16(self, 0xd30), rd16(self, 0xd2a));
            wr16(self, 0xd30, (uint16_t)(rd16(self, 0xd30) + 1));
        }
        if (world->value_5bb1ca != 0 && !nine_bytes_equal(r + 0x66, world->bytes_54c480)) call1(host, 0x4fb2e3, 0x5c3a67, rd16(r, 0x87));
    }
    if (r[0x24] != 0 && rds16(self, 0xd2a) == 0x28) {
        self[0xd3a] = 1;
        wr32(self, 0xe00, host->tick(host->context) + 0x12c);
        if (world->value_5bb1ca != 0 && !nine_bytes_equal(r + 0x66, world->bytes_54c48c)) call1(host, 0x4fb2e3, 0x5c3a67, rd16(r, 0x87));
    }
    if (world->value_5c39e5 == 0x27ad) {
        self[0xd3f] = 1;
        wr32(world->records_5bb5e5, rec_offset(self, 0xd28) + 0x4d, 2);
    }
}

/* ---- 0x4b2250 ------------------------------------------------------------------------------------------------------------------ */

/* `mov eax, v; cdq; and edx, 3; add eax, edx; sar eax, 2`: v / 4 rounded toward zero */
static int32_t div4(int32_t v)
{
    uint32_t t = (uint32_t)v + (v < 0 ? 3u : 0u);
    return (int32_t)t >> 2;
}

/* 32-bit wrapping add / sub (add, sub on registers) */
static int32_t add32(int32_t a, int32_t b) { return (int32_t)((uint32_t)a + (uint32_t)b); }
static int32_t sub32(int32_t a, int32_t b) { return (int32_t)((uint32_t)a - (uint32_t)b); }

/* the byte offset of the cell (a + da, b + db) in self: `0x43 + a * 0x1e4 + b * 0x2c` (a and b signed words, sign-extended) */
static ptrdiff_t cell_at(int16_t a, int16_t b, int da, int db)
{
    return (ptrdiff_t)(0x43 + ((int32_t)a + da) * 0x1e4 + ((int32_t)b + db) * 0x2c);
}

/* 0x4b2250, thiscall, `ret 8`: x is the word at [ebp+8], y the word at [ebp+0xc]. X = x + dword 0x583186 and Y = y + dword 0x58318a (32-bit sums, signed
 * compares). R is the object of the record of the word [+0x1e], read at entry. Returns 0 when dword [+0x1515] is clear or dword [+0x24] is 1 or 2.
 * The words [+0x1531] and [+0x1533] are cleared when Y > the dword at [(R.w21 - 1) * 0x1e4 + 0x6b] or X > the dword at [(R.w23 - 1) * 0x2c + 0x67] or
 * X < the dword [+0x5f] (those are fields of cells (R.w21 - 1, 0) and (0, R.w23 - 1)). Then, for A below the signed word R[0x21] and B below the signed
 * word R[0x23] (two word counters that the body also advances), with the cell c = A * 0x1e4 + B * 0x2c + 0x43 (words +0x18, +0x1a, dwords +0x1c,
 * +0x20, +0x24, +0x28), q1 = dword [+0x152d] / 4 and q2 = dword [+0x1529] / 4 (toward zero):
 *  - word c[0x1a] set and word c[0x18] == 5: four tests in turn, each overwriting the code: block 1 (code 0x2795, B += 1), block 2 on the row below (0x2796,
 *    A += 1), block 3 (0x2794), block 4 (0x2797, B += 1 and A += 1); each block is a chain of four signed compares of Y or X with a cell field +- q1 / q2
 *    that must all hold (see the comments below), and later blocks read the cells at the A and B that earlier blocks advanced;
 *  - else, when c[0x1a] is set: Y in [c.20, c.28] and X in [c.1c, c.24] give the code c[0x1a];
 * a non-zero code stores A to [+0x3f] and B to [+0x41], calls 0x4afec1(this = self, code) and returns 0, or, when that returns exactly 1, calls
 * 0x4b2917(this = self, code) and returns 1. Without a code after both loops: byte R[0x17d] clear: the point (x, y) inside the rectangle
 * y in [R.370, R.378], x in [R.36c, R.374] calls 0x4b2917(0x2793) and returns 1; byte set: y in [R.192, R.19a], x in [R.18e, R.196] calls 0x4b2917(0x2792)
 * and returns 1; otherwise 0. */
int32_t m4b2250_hit_test(uint8_t *self, int16_t x, int16_t y, const Fl25dWorld *world, const Fl18Host *host)
{
    int32_t X, Y;
    int16_t A, B, code = 0;
    const uint8_t *R;
#define Q1 div4(rds32(self, 0x152d))
#define Q2 div4(rds32(self, 0x1529))
#define CELL(da, db, off) rds32(self, cell_at(A, B, (da), (db)) + (off))
    if (rd32(self, 0x1515) == 0) return 0;
    if (rd32(self, 0x24) == 2) return 0;
    if (rd32(self, 0x24) == 1) return 0;
    X = add32((int32_t)x, (int32_t)world->value_583186);
    Y = add32((int32_t)y, (int32_t)world->value_58318a);
    R = object_at(host, record_object_address(world, self, 0x1e));
    if (Y > rds32(self, (ptrdiff_t)((rds16(R, 0x21) - 1) * 0x1e4) + 0x6b) || X > rds32(self, (ptrdiff_t)((rds16(R, 0x23) - 1) * 0x2c) + 0x67) ||
        X < rds32(self, 0x5f)) {
        wr16(self, 0x1531, 0);
        wr16(self, 0x1533, 0);
    }
    for (A = 0; (int32_t)A < rds16(R, 0x21); A = (int16_t)(A + 1)) {
        for (B = 0; (int32_t)B < rds16(R, 0x23); B = (int16_t)(B + 1)) {
            if (rds16(self, cell_at(A, B, 0, 0) + 0x1a) != 0 && rds16(self, cell_at(A, B, 0, 0) + 0x18) == 5) {
                /* block 1: Y >= c.20, Y <= c.20 + q1, X >= c.1c + q2, X <= (B + 1).24 - q2 */
                if (!(Y < CELL(0, 0, 0x20)) && !(Y > add32(CELL(0, 0, 0x20), Q1)) && !(X < add32(CELL(0, 0, 0x1c), Q2)) && !(X > sub32(CELL(0, 1, 0x24), Q2))) {
                    code = 0x2795;
                    B = (int16_t)(B + 1);
                }
                /* block 2: Y >= (A + 1).28 - q1, Y <= (A + 1).28, X >= c.1c + q2, X <= (B + 1).24 - q2 */
                if (!(Y < sub32(CELL(1, 0, 0x28), Q1)) && !(Y > CELL(1, 0, 0x28)) && !(X < add32(CELL(0, 0, 0x1c), Q2)) && !(X > sub32(CELL(0, 1, 0x24), Q2))) {
                    code = 0x2796;
                    A = (int16_t)(A + 1);
                }
                /* block 3: Y >= c.20 + q1, Y <= (A + 1).28 - q1, X >= c.1c, X <= c.1c + q2 */
                if (!(Y < add32(CELL(0, 0, 0x20), Q1)) && !(Y > sub32(CELL(1, 0, 0x28), Q1)) && !(X < CELL(0, 0, 0x1c)) && !(X > add32(CELL(0, 0, 0x1c), Q2)))
                    code = 0x2794;
                /* block 4: Y >= c.20 + q1, Y <= (A + 1).28 - q1, X >= (B + 1).24 - q2, X <= (B + 1).24 */
                if (!(Y < add32(CELL(0, 0, 0x20), Q1)) && !(Y > sub32(CELL(1, 0, 0x28), Q1)) && !(X < sub32(CELL(0, 1, 0x24), Q2)) && !(X > CELL(0, 1, 0x24))) {
                    code = 0x2797;
                    B = (int16_t)(B + 1);
                    A = (int16_t)(A + 1);
                }
            } else if (rds16(self, cell_at(A, B, 0, 0) + 0x1a) != 0) {
                if (!(Y < CELL(0, 0, 0x20)) && !(Y > CELL(0, 0, 0x28)) && !(X < CELL(0, 0, 0x1c)) && !(X > CELL(0, 0, 0x24))) code = (int16_t)rd16(self, cell_at(A, B, 0, 0) + 0x1a);
            }
            if (code != 0) {
                wr16(self, 0x3f, (uint16_t)A);
                wr16(self, 0x41, (uint16_t)B);
                if (call1(host, 0x4afec1, (uintptr_t)self, (uint16_t)code) != 1) return 0;
                call1(host, 0x4b2917, (uintptr_t)self, (uint16_t)code);
                return 1;
            }
        }
    }
    if (R[0x17d] == 0 && !((int32_t)y < rds32(R, 0x370)) && !((int32_t)y > rds32(R, 0x378)) && !((int32_t)x < rds32(R, 0x36c)) && !((int32_t)x > rds32(R, 0x374))) {
        call1(host, 0x4b2917, (uintptr_t)self, 0x2793);
        return 1;
    }
    if (R[0x17d] != 0 && !((int32_t)y < rds32(R, 0x192)) && !((int32_t)y > rds32(R, 0x19a)) && !((int32_t)x < rds32(R, 0x18e)) && !((int32_t)x > rds32(R, 0x196))) {
        call1(host, 0x4b2917, (uintptr_t)self, 0x2792);
        return 1;
    }
#undef CELL
#undef Q2
#undef Q1
    return 0;
}
