#include "original_methods_fl21b.h"

#include <string.h>

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

/* a signed word, sign-extended (movsx) */
UNUSED_OK static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

/* a dword as a signed 32-bit value */
UNUSED_OK static int32_t sdw(uint32_t v)
{
    return (int32_t)v;
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

/* the object of an original address (an address that a record or an object keeps), as host memory */
UNUSED_OK static const uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return host->resolve(host->context, address);
}

/* the 32-bit quotient-by-two of the original (cdq; sub eax, edx; sar eax, 1): rounds toward zero */
UNUSED_OK static uint32_t half_toward_zero(uint32_t value)
{
    int32_t d = (int32_t)value;
    int32_t sign = d < 0 ? -1 : 0;
    return (uint32_t)((int32_t)((uint32_t)d - (uint32_t)sign) >> 1);
}

/* the inlined strcmp(a, b) == 0 of the original: two bytes per pass, the second byte only read when the first matched and was not the
 * terminator */
UNUSED_OK static int strings_equal(const uint8_t *a, const uint8_t *b)
{
    for (;;) {
        uint8_t c = a[0];
        if (c != b[0]) return 0;
        if (c == 0) return 1;
        c = a[1];
        if (c != b[1]) return 0;
        a += 2;
        b += 2;
        if (c == 0) return 1;
    }
}

/* the inlined strlen of the original (repne scasb): the number of bytes before the first zero */
UNUSED_OK static uint32_t string_length(const uint8_t *s)
{
    uint32_t n = 0;
    while (s[n] != 0) n++;
    return n;
}

/* the inlined strcpy of the original (repne scasb, then rep movsd for the dwords and rep movsb for the rest, both ascending): strlen + 1
 * bytes; the buffers may overlap */
UNUSED_OK static void copy_string(uint8_t *dst, const uint8_t *src)
{
    uint32_t n = string_length(src) + 1u, k, whole = n >> 2;
    for (k = 0; k < whole; k++) {
        uint32_t v = rd32(src, (ptrdiff_t)k * 4);
        wr32(dst, (ptrdiff_t)k * 4, v);
    }
    for (k = 0; k < (n & 3u); k++) dst[whole * 4u + k] = src[whole * 4u + k];
}

/* repe cmpsb with ecx = 9: 1 when the nine bytes at a and b are equal */
UNUSED_OK static int nine_bytes_equal(const uint8_t *a, const uint8_t *b)
{
    int k;
    for (k = 0; k < 9; k++)
        if (a[k] != b[k]) return 0;
    return 1;
}

/* four dwords, ascending, each read and written before the next (the unrolled 16-byte copy of the original) */
UNUSED_OK static void copy16(uint8_t *dst, const uint8_t *src)
{
    wr32(dst, 0, rd32(src, 0));
    wr32(dst, 4, rd32(src, 4));
    wr32(dst, 8, rd32(src, 8));
    wr32(dst, 0xc, rd32(src, 0xc));
}

/* the original address 0x638xxx of the block at 0x638600 */
#define BLOCK(world, address) ((world)->block_638600 + ((ptrdiff_t)(address) - 0x638600))

/* ---- 0x4468fe ------------------------------------------------------------------------------------------------------------------ */

/* the rectangle p = q - (origin_x, origin_y, origin_x, origin_y) and the 0x4c5377 call of the erase steps of 0x4468fe */
static void erase_box(const Fl21bWorld *world, const Fl18Host *host, const uint32_t *q, uintptr_t konst)
{
    uint32_t p[4];
    p[0] = q[0] - (uint32_t)world->origin_x_583186;
    p[2] = q[2] - (uint32_t)world->origin_x_583186;
    p[1] = q[1] - (uint32_t)world->origin_y_58318a;
    p[3] = q[3] - (uint32_t)world->origin_y_58318a;
    call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, (uintptr_t)p, (uintptr_t)q, konst);
}

/* the dword of the 0x5d1599 record at the dword 0x638837 (imul by 0x4a, 32-bit) */
static uint32_t clock_table_dword(const Fl21bWorld *world)
{
    return rd32(world->table_5d1599, (ptrdiff_t)sdw(rd32(BLOCK(world, 0x638837), 0) * 0x4au));
}

/* original GAME.EXE 0x4468fe (FUN_004468fe, no this, no stack argument, plain ret; the sibling of 0x446688 with two strings): returns
 * at once unless the dwords 0x63860b and 0x638613 are both non-zero. x = dword 0x638827, y = dword 0x63882b. The digits are four strings
 * (a inlined strcmp each): s1 = 0x63884b, s2 = 0x638855 and their copies o1 = 0x638869, o2 = 0x638873. widths W[d] = the dword at
 * 0x638667 + d * 4, heights H[d] = the dword at 0x63868f + d * 4 (d = a character (signed byte) - 0x30; the two tables are contiguous),
 * the separator size sw = dword 0x6386b7, sh = dword 0x6386bb, the gap g = dword 0x63882f.
 * When s1 != o1 or s2 != o2: first the old digits are erased: for each character of o1 (strlen re-evaluated in every pass): the local
 * rectangle q = { x, y, x + W[d] - 1, y + H[d] - 1 } and p = q - (origin_x 0x583186, origin_y 0x58318a, origin_x, origin_y), 0x4c5377 on
 * 0x5cf659 with (dword 0x5d15e3, dword 0x5cf665, &p, &q, 0x5482c4), x += W[d] + g; then the separator: q = { x, y + (H[0] - sh) / 2, x +
 * sw - 1, that y + sh - 1 } (the division by two rounds toward zero), p likewise, 0x4c5377 with 0x5482f0, x += sw + g; then the same
 * over o2 with 0x54831c. Always afterwards x, y are reloaded and the new digits are drawn: for each character of s1: q as above and 0x4c5d4b
 * on 0x5cf659 with (the dword of the 0x5d1599 record at the dword 0x638837 * 0x4a, dword 0x5cf665, 0x638777 + d * 16, &q, 0x548348), x +=
 * W[d] + g; the separator: q as above, 0x4c5d4b with (table dword, dword 0x5cf665, 0x638817, &q, 0x548358), x += sw + g; then s2 with
 * 0x548368. Finally s1 is copied over o1 and s2 over o2 with their terminators (inlined strcpy, forward in dwords then bytes). */
void m4468fe_draw_clock(Fl21bWorld *world, const Fl18Host *host)
{
    uint32_t q[4];
    uint32_t x, y, i, d;
    if (rd32(BLOCK(world, 0x63860b), 0) == 0) return;
    if (rd32(BLOCK(world, 0x638613), 0) == 0) return;
    x = rd32(BLOCK(world, 0x638827), 0);
    y = rd32(BLOCK(world, 0x63882b), 0);
    if (!strings_equal(BLOCK(world, 0x63884b), BLOCK(world, 0x638869)) || !strings_equal(BLOCK(world, 0x638855), BLOCK(world, 0x638873))) {
        for (i = 0; i < string_length(BLOCK(world, 0x638869)); i++) {
            d = (uint32_t)((int32_t)(int8_t)*BLOCK(world, 0x638869 + i) - 0x30);
            q[0] = x;
            q[1] = y;
            q[2] = x + rd32(BLOCK(world, 0x638667), (ptrdiff_t)sdw(d) * 4) - 1u;
            q[3] = y + rd32(BLOCK(world, 0x63868f), (ptrdiff_t)sdw(d) * 4) - 1u;
            erase_box(world, host, q, 0x5482c4);
            x = x + (rd32(BLOCK(world, 0x638667), (ptrdiff_t)sdw(d) * 4) + rd32(BLOCK(world, 0x63882f), 0));
        }
        q[0] = x;
        q[1] = y + half_toward_zero(rd32(BLOCK(world, 0x63868f), 0) - rd32(BLOCK(world, 0x6386bb), 0));
        q[2] = q[0] + rd32(BLOCK(world, 0x6386b7), 0) - 1u;
        q[3] = q[1] + rd32(BLOCK(world, 0x6386bb), 0) - 1u;
        erase_box(world, host, q, 0x5482f0);
        x = x + (rd32(BLOCK(world, 0x6386b7), 0) + rd32(BLOCK(world, 0x63882f), 0));
        for (i = 0; i < string_length(BLOCK(world, 0x638873)); i++) {
            d = (uint32_t)((int32_t)(int8_t)*BLOCK(world, 0x638873 + i) - 0x30);
            q[0] = x;
            q[1] = y;
            q[2] = x + rd32(BLOCK(world, 0x638667), (ptrdiff_t)sdw(d) * 4) - 1u;
            q[3] = y + rd32(BLOCK(world, 0x63868f), (ptrdiff_t)sdw(d) * 4) - 1u;
            erase_box(world, host, q, 0x54831c);
            x = x + (rd32(BLOCK(world, 0x638667), (ptrdiff_t)sdw(d) * 4) + rd32(BLOCK(world, 0x63882f), 0));
        }
    }
    x = rd32(BLOCK(world, 0x638827), 0);
    y = rd32(BLOCK(world, 0x63882b), 0);
    for (i = 0; i < string_length(BLOCK(world, 0x63884b)); i++) {
        d = (uint32_t)((int32_t)(int8_t)*BLOCK(world, 0x63884b + i) - 0x30);
        q[0] = x;
        q[1] = y;
        q[2] = x + rd32(BLOCK(world, 0x638667), (ptrdiff_t)sdw(d) * 4) - 1u;
        q[3] = y + rd32(BLOCK(world, 0x63868f), (ptrdiff_t)sdw(d) * 4) - 1u;
        call5(host, 0x4c5d4b, 0x5cf659, clock_table_dword(world), world->value_5cf665, 0x638777u + (d << 4), (uintptr_t)q, 0x548348);
        x = x + (rd32(BLOCK(world, 0x638667), (ptrdiff_t)sdw(d) * 4) + rd32(BLOCK(world, 0x63882f), 0));
    }
    q[0] = x;
    q[1] = y + half_toward_zero(rd32(BLOCK(world, 0x63868f), 0) - rd32(BLOCK(world, 0x6386bb), 0));
    q[2] = q[0] + rd32(BLOCK(world, 0x6386b7), 0) - 1u;
    q[3] = q[1] + rd32(BLOCK(world, 0x6386bb), 0) - 1u;
    call5(host, 0x4c5d4b, 0x5cf659, clock_table_dword(world), world->value_5cf665, 0x638817, (uintptr_t)q, 0x548358);
    x = x + (rd32(BLOCK(world, 0x6386b7), 0) + rd32(BLOCK(world, 0x63882f), 0));
    for (i = 0; i < string_length(BLOCK(world, 0x638855)); i++) {
        d = (uint32_t)((int32_t)(int8_t)*BLOCK(world, 0x638855 + i) - 0x30);
        q[0] = x;
        q[1] = y;
        q[2] = x + rd32(BLOCK(world, 0x638667), (ptrdiff_t)sdw(d) * 4) - 1u;
        q[3] = y + rd32(BLOCK(world, 0x63868f), (ptrdiff_t)sdw(d) * 4) - 1u;
        call5(host, 0x4c5d4b, 0x5cf659, clock_table_dword(world), world->value_5cf665, 0x638777u + (d << 4), (uintptr_t)q, 0x548368);
        x = x + (rd32(BLOCK(world, 0x638667), (ptrdiff_t)sdw(d) * 4) + rd32(BLOCK(world, 0x63882f), 0));
    }
    copy_string(BLOCK(world, 0x638869), BLOCK(world, 0x63884b));
    copy_string(BLOCK(world, 0x638873), BLOCK(world, 0x638855));
}

/* ---- 0x47f421 ------------------------------------------------------------------------------------------------------------------ */

/* original GAME.EXE 0x47f421 (FUN_0047f421), this = self, stack arguments x (word, [ebp+8]), y (word, [ebp+0xc]) and rect (a pointer to
 * four dwords, [ebp+0x10]), ret 0xc: returns 0 at once when the dword [self+0x13c5] is 0. rec = the object of the 0x5bb5e5 record at the
 * signed word [self+0x1e] (stride 0x8d), cur = self + the signed word [self+0x1350] * 0x25 + 0x7b4 (an item of 0x25 bytes, the dwords
 * at +2, +6, +0xa, +0xe are its box x0, y0, x1, y1). The dwords [self+0x13d3], [self+0x13db], [self+0x13cf], [self+0x13d7] := rect[1],
 * rect[3], rect[0], rect[2] (in this order).
 * When the dword [self+0x1344] is non-zero and the byte [self+0x13b1] is 0 ("drag"): 0x47f275 on self; half_h = (the dword at cur' +0xe -
 * the dword at cur' +6) / 2 and half_w = (the dword at cur' +0xa - the dword at cur' +2) / 2 (cur' = the item at the signed word
 * [self+0x1350] as read after that call; the division rounds toward zero, the results are kept as words); the point is inside when
 * y - half_h > the signed dword [rec+0x52], y + half_h < [rec+0x5a], x - half_w > [rec+0x4e] and x + half_w < [rec+0x56] (all four, signed). When it is not inside
 * and the byte [rec+0x5e] is 1, 0x47ec06 on self with (x, y) (words) decides: non-zero is inside. Not inside: the dword [self+0x13df]
 * := 0. Inside: [self+0x13df] := 1 and, when the byte [rec+0x5e] is 0 and the byte [rec+0x5f] is not, for i = 0, 1, ... while i < the
 * signed word [self+0x13a2]: items i other than the current one (the signed word [self+0x1350]) whose byte [self+i+0x7a0] is non-zero are
 * tested: u = 1 when the dword [self+0x1352] < the dword at item i +0x7b6 (u when [self+0x135a] >= that + 3) or else when [self+0x1352]
 * <= the dword at item +0x7be - 3; when u: v = 1 when [self+0x1356] < the dword at item +0x7ba (v when [self+0x135e] >= that + 3) or
 * else when [self+0x1356] <= the dword at item +0x7c2 - 3; when u and v: [self+0x13df] := 0 and i := the signed word [self+0x13a2]
 * (ends the loop). In every case of this branch: 0x47fd65 on self with 0x2791 and the result is 1.
 * Otherwise ("pick"): ten dwords at self+0x13ef := 0, the words [self+0x1417] and [self+0x1441] := 0 (they count the entries of two
 * word lists at self+0x13ef and self+0x1419); for i = 0, 1, ... while i < the signed word [self+0x13a2]: item = self + i*0x25 + 0x7b4;
 * skipped when the byte [self+0x13b1] is non-zero and i is not the signed word [self+0x1350]; skipped when the byte item+0x24 is non-zero
 * and the byte rec[(byte item+0x23) * 0x53 + 0xe9] is non-zero; when the bytes [rec+0x48] and [rec+0x49] are non-zero and y is within
 * [dword item+6, that + the signed word [rec+0x4a]] and x within [dword item+2, that + the signed word [rec+0x4c]]: i is appended to
 * the second list (word [self + count2*2 + 0x1419] := i, count2 := count2 + 1); otherwise when y is within [item+6, item+0xe] and x
 * within [item+2, item+0xa] (signed dword compares of the sign-extended words): i is appended to the first list. Then: second list
 * not empty: 0x47fd65 on self with 0x278e, result 1; first list not empty: 0x278d, result 1; y within [rec+0xa18, rec+0xa20] and x
 * within [rec+0xa14, rec+0xa1c]: 0x278f, result 1; y within [rec+0xa28, rec+0xa30] and x within [rec+0xa24, rec+0xa2c]: 0x2790,
 * result 1; otherwise 0. */
int32_t m47f421_pointer_hit(uint8_t *self, int16_t x, int16_t y, const uint8_t *rect, const Fl21bWorld *world, const Fl18Host *host)
{
    uint32_t rec_va;
    const uint8_t *rec;
    int32_t i, current;
    if (rd32(self, 0x13c5) == 0) return 0;
    rec_va = rd32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d);
    rec = object_at(host, rec_va);
    wr32(self, 0x13d3, rd32(rect, 4));
    wr32(self, 0x13db, rd32(rect, 0xc));
    wr32(self, 0x13cf, rd32(rect, 0));
    wr32(self, 0x13d7, rd32(rect, 8));
    if (rd32(self, 0x1344) != 0 && self[0x13b1] == 0) {
        int inside;
        int16_t half_h, half_w;   /* half the height / width of the current item, kept as words */
        ptrdiff_t item;
        call0(host, 0x47f275, (uintptr_t)self);
        item = (ptrdiff_t)rds16(self, 0x1350) * 0x25;
        half_h = (int16_t)half_toward_zero(rd32(self, item + 0x7c2) - rd32(self, item + 0x7ba));
        half_w = (int16_t)half_toward_zero(rd32(self, item + 0x7be) - rd32(self, item + 0x7b6));
        inside = ((int32_t)y - (int32_t)half_h > sdw(rd32(rec, 0x52))) && ((int32_t)y + (int32_t)half_h < sdw(rd32(rec, 0x5a))) &&
                 ((int32_t)x - (int32_t)half_w > sdw(rd32(rec, 0x4e))) && ((int32_t)x + (int32_t)half_w < sdw(rd32(rec, 0x56)));
        if (!inside) {
            if (rec[0x5e] == 1 && call2(host, 0x47ec06, (uintptr_t)self, (uint16_t)x, (uint16_t)y) != 0) inside = 1;
        }
        if (!inside) {
            wr32(self, 0x13df, 0);
        } else {
            wr32(self, 0x13df, 1);
            if (rec[0x5e] == 0 && rec[0x5f] != 0) {
                for (i = 0; i < rds16(self, 0x13a2); i++) {
                    int u = 0, v = 0;
                    ptrdiff_t s;
                    if (i == rds16(self, 0x1350)) continue;
                    if (self[(ptrdiff_t)i + 0x7a0] == 0) continue;
                    s = (ptrdiff_t)sdw((uint32_t)i * 0x25u);
                    if (sdw(rd32(self, 0x1352)) < sdw(rd32(self, s + 0x7b6))) {
                        if (!(sdw(rd32(self, 0x135a)) < sdw(rd32(self, s + 0x7b6) + 3u))) u = 1;
                    } else {
                        if (!(sdw(rd32(self, 0x1352)) > sdw(rd32(self, s + 0x7be) - 3u))) u = 1;
                    }
                    if (u != 0) {
                        if (sdw(rd32(self, 0x1356)) < sdw(rd32(self, s + 0x7ba))) {
                            if (!(sdw(rd32(self, 0x135e)) < sdw(rd32(self, s + 0x7ba) + 3u))) v = 1;
                        } else {
                            if (!(sdw(rd32(self, 0x1356)) > sdw(rd32(self, s + 0x7c2) - 3u))) v = 1;
                        }
                    }
                    if (u != 0 && v != 0) {
                        wr32(self, 0x13df, 0);
                        i = rds16(self, 0x13a2);
                    }
                }
            }
        }
        call1(host, 0x47fd65, (uintptr_t)self, 0x2791);
        return 1;
    }
    memset(self + 0x13ef, 0, 40);
    wr16(self, 0x1417, 0);
    wr16(self, 0x1441, 0);
    for (i = 0; i < rds16(self, 0x13a2); i++) {
        uint8_t *item = self + (ptrdiff_t)sdw((uint32_t)i * 0x25u) + 0x7b4;
        current = rds16(self, 0x1350);
        if (self[0x13b1] != 0 && i != current) continue;
        if (item[0x24] != 0 && rec[(ptrdiff_t)item[0x23] * 0x53 + 0xe9] != 0) continue;
        if (rec[0x48] != 0 && rec[0x49] != 0 && (int32_t)y >= sdw(rd32(item, 6)) &&
            (int32_t)y <= sdw(rd32(item, 6) + (uint32_t)rds16(rec, 0x4a)) && (int32_t)x >= sdw(rd32(item, 2)) &&
            (int32_t)x <= sdw(rd32(item, 2) + (uint32_t)rds16(rec, 0x4c))) {
            wr16(self, 0x1419 + (ptrdiff_t)rds16(self, 0x1441) * 2, (uint16_t)i);
            wr16(self, 0x1441, (uint16_t)(rd16(self, 0x1441) + 1u));
            continue;
        }
        if ((int32_t)y >= sdw(rd32(item, 6)) && (int32_t)y <= sdw(rd32(item, 0xe)) && (int32_t)x >= sdw(rd32(item, 2)) &&
            (int32_t)x <= sdw(rd32(item, 0xa))) {
            wr16(self, 0x13ef + (ptrdiff_t)rds16(self, 0x1417) * 2, (uint16_t)i);
            wr16(self, 0x1417, (uint16_t)(rd16(self, 0x1417) + 1u));
        }
    }
    if (rds16(self, 0x1441) != 0) {
        call1(host, 0x47fd65, (uintptr_t)self, 0x278e);
        return 1;
    }
    if (rds16(self, 0x1417) != 0) {
        call1(host, 0x47fd65, (uintptr_t)self, 0x278d);
        return 1;
    }
    if ((int32_t)y >= sdw(rd32(rec, 0xa18)) && (int32_t)y <= sdw(rd32(rec, 0xa20)) && (int32_t)x >= sdw(rd32(rec, 0xa14)) &&
        (int32_t)x <= sdw(rd32(rec, 0xa1c))) {
        call1(host, 0x47fd65, (uintptr_t)self, 0x278f);
        return 1;
    }
    if ((int32_t)y >= sdw(rd32(rec, 0xa28)) && (int32_t)y <= sdw(rd32(rec, 0xa30)) && (int32_t)x >= sdw(rd32(rec, 0xa24)) &&
        (int32_t)x <= sdw(rd32(rec, 0xa2c))) {
        call1(host, 0x47fd65, (uintptr_t)self, 0x2790);
        return 1;
    }
    return 0;
}

/* ---- 0x48569e ------------------------------------------------------------------------------------------------------------------ */

/* the 0x85-byte slot k of the item array at self + 0x2a and its two 16-byte fields at +0 and +0x10 */
#define SLOT(self, k) ((self) + (ptrdiff_t)(k) * 0x85 + 0x2a)

/* 0x485bc5..0x485c97 of 0x48569e: the word [self+0xbc5] := the dword at slot +8 - the dword at slot +0, and [self+0xbc7] likewise for
 * +0xc and +4 (the slot is the signed word [self+0xa9e]; every part re-reads that word) */
static void set_slot_extent(uint8_t *self)
{
    wr16(self, 0xbc5, (uint16_t)(rd32(self, (ptrdiff_t)rds16(self, 0xa9e) * 0x85 + 0x32) - rd32(self, (ptrdiff_t)rds16(self, 0xa9e) * 0x85 + 0x2a)));
    wr16(self, 0xbc7, (uint16_t)(rd32(self, (ptrdiff_t)rds16(self, 0xa9e) * 0x85 + 0x36) - rd32(self, (ptrdiff_t)rds16(self, 0xa9e) * 0x85 + 0x2e)));
}

/* original GAME.EXE 0x48569e (FUN_0048569e), this = self, no stack argument, plain ret: rec = the object of the 0x5bb5e5 record at the
 * signed word [self+0x26] (stride 0x8d). Returns at once when the dword [self+0xba7] is 0, the byte [self+0xbb0] is non-zero, the
 * dword [self+0xbac] is non-zero, or the dword at record +0x4d (0x5bb632) is not 1. Then on the selector dword 0x5c39e5:
 *   0x2779: byte [self+0xbab] := 1 and the dword at record +0x4d := 2.
 *   0x277c: dword [self+0xc2b] := 1.
 *   0x2778: s = (word) 0x484622 on self; when s is -1 nothing more. Else 0x4853b0 on self with the word s, 0x485f12 on self, the dword
 *     [self+0xa92] := 1, the word [self+0xa9e] := s and set_slot_extent.
 *   when the dword [self+0xa92] is 0 and the selector is 0x2777: 0x485ca1 on self; s = (word) 0x4846c2 on self; when s is -1 nothing
 *     more. Else the word [self+0xa9e] := s, the dword [self+0xa9a] := 1, the 16 bytes of slot s (self + s*0x85 + 0x2a) are copied to
 *     self+0xae0, p = rec + s*0x42 + 0x8f (an original address), 0x484f0d on self with p: when it returns non-zero the 16 bytes at p
 *     are copied over the slot, then set_slot_extent and the dword [self+0xa92] := 1.
 *   0x277b or 0x277a (the same dword/selector conditions otherwise): 0x485d52 on self; [self+0xa92] := 0, [self+0xa96] := 1; k = the signed
 *     word [self+0xa9e]. With the selector 0x277b and either the byte [rec+0x2d] zero or the signed word at rec + 0x2e + (the signed
 *     word [self+0xc25]) * 2 equal to k + 1: the 16 bytes at rec + k*0x42 + 0x9f are copied over slot k, 0x4841cb on self with
 *     (slot, slot + 0x10), the bytes slot+0x21 (self + k*0x85 + 0x4b) and slot+0x82 (+0xac) := 1, the dword [self+0xb83] := 1 and the
 *     word [self+0xc25] += 1. Otherwise (the selector is 0x277a or the test failed) when the byte [rec+0x23] is non-zero: the 16
 *     bytes at rec + k*0x42 + 0xaf are copied over slot k, 0x4841cb on self with (slot, slot + 0x10), the byte [self+k*0x85+0x4a] :=
 *     the byte rec[k*0x42+0xbf], the byte [self+k*0x85+0xac] := 0, the dword [self+0xb83] := 0; when it is zero: the 16 bytes at
 *     self+0xaa0 are copied over slot k, those at self+0xac0 over slot k + 0x10, the byte [self+k*0x85+0xac] := 1, [self+0xb83] := 0.
 *     In every case: 0x484935 on self with the word [self+0xa9e] and the word [self+0xa9e] := 0xffff.
 * Anything else: nothing. */
void m48569e_handle_key(uint8_t *self, Fl21bWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = rd32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x26) * 0x8d);
    const uint8_t *rec;
    int16_t s;
    if (rd32(self, 0xba7) == 0) return;
    if (self[0xbb0] != 0) return;
    if (rd32(self, 0xbac) != 0) return;
    if (rd32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x26) * 0x8d + 0x4d) != 1) return;
    if (world->value_5c39e5 == 0x2779) {
        self[0xbab] = 1;
        wr32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x26) * 0x8d + 0x4d, 2);
        return;
    }
    if (world->value_5c39e5 == 0x277c) {
        wr32(self, 0xc2b, 1);
        return;
    }
    if (world->value_5c39e5 == 0x2778) {
        s = (int16_t)call0(host, 0x484622, (uintptr_t)self);
        if (s == -1) return;
        call1(host, 0x4853b0, (uintptr_t)self, (uint16_t)s);
        call0(host, 0x485f12, (uintptr_t)self);
        wr32(self, 0xa92, 1);
        wr16(self, 0xa9e, (uint16_t)s);
        set_slot_extent(self);
        return;
    }
    if (rd32(self, 0xa92) == 0 && world->value_5c39e5 == 0x2777) {
        call0(host, 0x485ca1, (uintptr_t)self);
        s = (int16_t)call0(host, 0x4846c2, (uintptr_t)self);
        if (s == -1) return;
        wr16(self, 0xa9e, (uint16_t)s);
        wr32(self, 0xa9a, 1);
        copy16(self + 0xae0, SLOT(self, rds16(self, 0xa9e)));
        if (call1(host, 0x484f0d, (uintptr_t)self, (uint32_t)(rec_va + (uint32_t)(rds16(self, 0xa9e) * 0x42) + 0x8fu)) != 0) {
            rec = object_at(host, rec_va);
            copy16(SLOT(self, rds16(self, 0xa9e)), rec + (ptrdiff_t)rds16(self, 0xa9e) * 0x42 + 0x8f);
        }
        set_slot_extent(self);
        wr32(self, 0xa92, 1);
        return;
    }
    if (world->value_5c39e5 != 0x277b && world->value_5c39e5 != 0x277a) return;
    call0(host, 0x485d52, (uintptr_t)self);
    wr32(self, 0xa92, 0);
    wr32(self, 0xa96, 1);
    rec = object_at(host, rec_va);
    if (world->value_5c39e5 == 0x277b && (rec[0x2d] == 0 || rds16(rec, 0x2e + (ptrdiff_t)rds16(self, 0xc25) * 2) == rds16(self, 0xa9e) + 1)) {
        copy16(SLOT(self, rds16(self, 0xa9e)), rec + (ptrdiff_t)rds16(self, 0xa9e) * 0x42 + 0x9f);
        call2(host, 0x4841cb, (uintptr_t)self, (uintptr_t)SLOT(self, rds16(self, 0xa9e)), (uintptr_t)(SLOT(self, rds16(self, 0xa9e)) + 0x10));
        SLOT(self, rds16(self, 0xa9e))[0x4b - 0x2a] = 1;
        SLOT(self, rds16(self, 0xa9e))[0xac - 0x2a] = 1;
        wr32(self, 0xb83, 1);
        wr16(self, 0xc25, (uint16_t)(rd16(self, 0xc25) + 1u));
    } else if (rec[0x23] != 0) {
        copy16(SLOT(self, rds16(self, 0xa9e)), rec + (ptrdiff_t)rds16(self, 0xa9e) * 0x42 + 0xaf);
        call2(host, 0x4841cb, (uintptr_t)self, (uintptr_t)SLOT(self, rds16(self, 0xa9e)), (uintptr_t)(SLOT(self, rds16(self, 0xa9e)) + 0x10));
        SLOT(self, rds16(self, 0xa9e))[0x4a - 0x2a] = rec[(ptrdiff_t)rds16(self, 0xa9e) * 0x42 + 0xbf];
        SLOT(self, rds16(self, 0xa9e))[0xac - 0x2a] = 0;
        wr32(self, 0xb83, 0);
    } else {
        copy16(SLOT(self, rds16(self, 0xa9e)), self + 0xaa0);
        copy16(SLOT(self, rds16(self, 0xa9e)) + 0x10, self + 0xac0);
        SLOT(self, rds16(self, 0xa9e))[0xac - 0x2a] = 1;
        wr32(self, 0xb83, 0);
    }
    call1(host, 0x484935, (uintptr_t)self, rd16(self, 0xa9e));
    wr16(self, 0xa9e, 0xffff);
}

/* ---- 0x44e035 ------------------------------------------------------------------------------------------------------------------ */

/* the dword of the 0x5d1599 record at the signed word 0x624cdb (stride 0x4a) */
static uint32_t panel_table_dword(const Fl21bWorld *world)
{
    return rd32(world->table_5d1599, (ptrdiff_t)world->word_624cdb * 0x4a);
}

/* 0x44d9b5 on 0x624cbf with (rec + off, &r) and then 0x4c5377 on 0x5cf659 with (table dword, dword 0x5cf665, rec + target, &r, konst) */
static void panel_part(const Fl21bWorld *world, const Fl18Host *host, uint32_t rec_va, uint32_t r[4], uint32_t source, uint32_t target,
                       uintptr_t konst)
{
    call2(host, 0x44d9b5, 0x624cbf, rec_va + source, (uintptr_t)r);
    call5(host, 0x4c5377, 0x5cf659, panel_table_dword(world), world->value_5cf665, rec_va + target, (uintptr_t)r, konst);
}

/* original GAME.EXE 0x44e035 (FUN_0044e035, no this, no stack argument, plain ret): rec = the object address of the 0x5bb5e5 record at
 * the signed word 0x624cdd (stride 0x8d). mode = dword 0x624cec; "plain" = mode is 0 or 8, or mode is 2 and the dword 0x624cf0 is 8. When
 * plain: a = word 0x624cf4, b = word 0x624cf6, f = dword 0x624cf8; otherwise a = word 0x624cfc, b = word 0x624cfe, f = dword 0x624d00.
 * With r a local rectangle of four dwords (zero until 0x44d9b5 writes it), T = the dword of the 0x5d1599 record at the signed word
 * 0x624cdb (stride 0x4a) and P(src, dst, k) = { 0x44d9b5 on 0x624cbf with (rec + src, &r); 0x4c5377 on 0x5cf659 with (T, dword 0x5cf665,
 * rec + dst, &r, k) }: P(0x41, f ? 0x1c1 : 0x1d1, f ? 0x549614 : 0x549620); P(0xb1, plain ? 0x241 : 0x251, plain ? 0x54962c : 0x549644)
 * (the plain test is evaluated again here); P(0x31, (signed a) * 16 + 0x101, 0x549660); P(0x21, (signed b) * 16 + 0xc1, 0x54967c). Then
 * when mode is 2, on the dword 0x624cf0 (more than 8: nothing): 8: P(0x81, 0x211, 0x54969c); 1: P(0x61, 0x1f1, 0x5496b0); 0: P(0x51,
 * 0x1e1, 0x5496c8); 6: P(0x71, 0x201, 0x5496e0); 3: P(0x91, 0x221, 0x5496f8); 4: P(0xa1, 0x231, 0x549714); 2, 5, 7: nothing (the
 * switch table at 0x44e624). When mode is not 2 and the dword 0x624d04 is non-zero: for the offsets 0x81, 0x61, 0x51, 0x71, 0x91, 0xa1
 * (with the constants 0x549730, 0x54973c, 0x54974c, 0x54975c, 0x54976c, 0x549780): 0x44d9b5 on 0x624cbf with (rec + off, &r) and 0x4c5377
 * on 0x5cf659 with (dword 0x5d15e3, dword 0x5cf665, rec + off, &r, the constant), then the dword 0x624d04 := 0. Finally the byte
 * 0x624ce3 := 0. */
void m44e035_draw_panel(Fl21bWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = rd32(world->records_5bb5e5, (ptrdiff_t)world->word_624cdd * 0x8d);
    uint32_t r[4];
    uint16_t a, b;
    uint32_t flag;
    int plain;
    memset(r, 0, sizeof r);
    plain = world->value_624cec == 0 || world->value_624cec == 8 || (world->value_624cec == 2 && world->value_624cf0 == 8);
    if (plain) {
        a = world->word_624cf4;
        b = world->word_624cf6;
        flag = world->value_624cf8;
    } else {
        a = world->word_624cfc;
        b = world->word_624cfe;
        flag = world->value_624d00;
    }
    if (flag != 0)
        panel_part(world, host, rec_va, r, 0x41, 0x1c1, 0x549614);
    else
        panel_part(world, host, rec_va, r, 0x41, 0x1d1, 0x549620);
    plain = world->value_624cec == 0 || world->value_624cec == 8 || (world->value_624cec == 2 && world->value_624cf0 == 8);
    if (plain)
        panel_part(world, host, rec_va, r, 0xb1, 0x241, 0x54962c);
    else
        panel_part(world, host, rec_va, r, 0xb1, 0x251, 0x549644);
    panel_part(world, host, rec_va, r, 0x31, (uint32_t)((int32_t)(int16_t)a << 4) + 0x101u, 0x549660);
    panel_part(world, host, rec_va, r, 0x21, (uint32_t)((int32_t)(int16_t)b << 4) + 0xc1u, 0x54967c);
    if (world->value_624cec == 2) {
        switch (world->value_624cf0) {
        case 8: panel_part(world, host, rec_va, r, 0x81, 0x211, 0x54969c); break;
        case 1: panel_part(world, host, rec_va, r, 0x61, 0x1f1, 0x5496b0); break;
        case 0: panel_part(world, host, rec_va, r, 0x51, 0x1e1, 0x5496c8); break;
        case 6: panel_part(world, host, rec_va, r, 0x71, 0x201, 0x5496e0); break;
        case 3: panel_part(world, host, rec_va, r, 0x91, 0x221, 0x5496f8); break;
        case 4: panel_part(world, host, rec_va, r, 0xa1, 0x231, 0x549714); break;
        default: break;
        }
    } else if (world->value_624d04 != 0) {
        static const struct {
            uint32_t offset;
            uint32_t konst;
        } outlines[6] = {{0x81, 0x549730}, {0x61, 0x54973c}, {0x51, 0x54974c}, {0x71, 0x54975c}, {0x91, 0x54976c}, {0xa1, 0x549780}};
        int k;
        for (k = 0; k < 6; k++) {
            call2(host, 0x44d9b5, 0x624cbf, rec_va + outlines[k].offset, (uintptr_t)r);
            call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, rec_va + outlines[k].offset, (uintptr_t)r, outlines[k].konst);
        }
        world->value_624d04 = 0;
    }
    world->byte_624ce3 = 0;
}

/* ---- 0x44da08 ------------------------------------------------------------------------------------------------------------------ */

/* the entry of the 0x5d1599 table at the signed word [self+0x1c] (stride 0x4a), as the original re-reads it in every statement */
#define ENTRY(world, self) ((world)->table_5d1599 + (ptrdiff_t)rds16((self), 0x1c) * 0x4a)

/* original GAME.EXE 0x44da08 (FUN_0044da08), this = self, stack argument index (word, ret 4): rec = the object address of the 0x5bb5e5
 * record at the signed word index (stride 0x8d); state = the dword at that record +0x4d (0x5bb632).
 * state 0: word [self+0x1e] := index, dword [self+0x25] := 1, 0x44d711 on self, byte [self+0x24] := 1, dword 0x5bb1ca := 1, dwords
 *   [self+0x45], [self+0x2d], [self+0x29] := 0; n = (word) 0x4d39f9 (no this, no argument) stored to the word [self+0x1c]; the 0x4a-byte
 *   entry E of the table at 0x5d1599 at the signed word [self+0x1c] gets (re-reading [self+0x1c] for every store) E-8 := 0xa, E-4 :=
 *   0x44e035, E+0 := 0, E+4 := 0, E+8 := 0, E+0xc := 1, E+0x10 := 1, the word E+0x14 := 0 and the string at 0x5495bc is copied to E+0x1a
 *   (strlen + 1 bytes). When the dword [self+0x20] is 0: [self+0x20] := 0x4c2790 on 0x5cf659 with (0x5495e8, rec, 6, 0x5495d4). E+0 :=
 *   [self+0x20]. When the nine bytes at rec+0x265 differ from those at 0x5495f0: 0x4fb77a on 0x5c3a67 with rec+0x265. Then the bytes
 *   [self+0x4a], [self+0x49] := 0 and the dword at the record of the signed word [self+0x1e] +0x4d := 1.
 * state 1: on the dword [self+0x2d] (more than 8: nothing):
 *   0, 1: byte [self+0x24] := 1.
 *   2: when GetTickCount >= the dword [self+0x4b]: [self+0x2d] := [self+0x31] and [self+0x45] := 1.
 *   3, 4: 0x44d8ad on self with 1 (3) or 0 (4), byte [self+0x24] := 1, [self+0x2d] := 1.
 *   5: when GetTickCount >= the dword [self+0x4f]: when the nine bytes at rec+0x2b1 equal those at 0x5495fc, the dword at the record +0x4d :=
 *      2 (record of [self+0x1e]); otherwise 0x4fb77a on 0x5c3a67 with rec+0x2b1, 0x4fb2e3 on 0x5c3a67 with the word [rec+0x2d2] and
 *      [self+0x2d] := 7.
 *   6: [self+0x4f] := GetTickCount + (signed word [rec+0x2af]) * 1000, byte [self+0x4a] := 1, [self+0x2d] := 5.
 *   7: r = 0x4f6334 on 0x5cf1eb with the sign-extended word [rec+0x2d2]; when r is 0: 0x4fba69 on 0x5c3a67 with rec+0x2b1 and the
 *      record state := 2.
 *   8: byte [self+0x49] := 1, record state := 2.
 * state 2: dword 0x5bb1ca := 1; when the nine bytes at rec+0x265 differ from those at 0x549608: 0x4fba69 on 0x5c3a67 with rec+0x265. When
 *   the byte [self+0x49] is non-zero: unless the signed word [rec+0x2e2] is 0x270f: the dword 0x5bb57b := that word (sign-extended), the words
 *   0x5bb599, 0x5bb595, 0x5c39ff := the words [rec+0x2e4], [rec+0x2e6], [rec+0x2e8], the dwords 0x5bb59b, 0x5bb59f, 0x5bb5a3 := the dwords
 *   [rec+0x2ea], [rec+0x2ee], [rec+0x2f2], the dword 0x5bb1ca := 0 when the signed word [rec+0x2f6] is 1 and 1 otherwise, the dword
 *   0x583999 := 4; then unless the signed word [rec+0x2f8] is -1: the dword at 0x585801 + that word * 4 := the byte [rec+0x2fa].
 *   Otherwise when the byte [self+0x4a] is non-zero: 0x44d946 on self, then the same with the fields +0x296, +0x298, +0x29a, +0x29c,
 *   +0x29e, +0x2a2, +0x2a6, +0x2aa (flag) and +0x2ac, +0x2ae. In both cases (also when neither byte is set): 0x42ba3a (cdecl) with the word
 *   [self+0x1e], then 0x44d154 on self.
 * Any other state: nothing. */
void m44da08_run_state(uint8_t *self, int16_t index, Fl21bWorld *world, const Fl18Host *host)
{
    ptrdiff_t rec_off = (ptrdiff_t)index * 0x8d;
    uint32_t rec_va = rd32(world->records_5bb5e5, rec_off);
    uint32_t state = rd32(world->records_5bb5e5, rec_off + 0x4d);
    const uint8_t *rec;
    if (state == 0) {
        wr16(self, 0x1e, (uint16_t)index);
        wr32(self, 0x25, 1);
        call0(host, 0x44d711, (uintptr_t)self);
        self[0x24] = 1;
        world->value_5bb1ca = 1;
        wr32(self, 0x45, 0);
        wr32(self, 0x2d, 0);
        wr32(self, 0x29, 0);
        wr16(self, 0x1c, (uint16_t)call0(host, 0x4d39f9, 0));
        wr32(ENTRY(world, self), -8, 0xa);
        wr32(ENTRY(world, self), -4, 0x44e035);
        wr32(ENTRY(world, self), 0, 0);
        wr32(ENTRY(world, self), 4, 0);
        wr32(ENTRY(world, self), 8, 0);
        wr32(ENTRY(world, self), 0xc, 1);
        wr32(ENTRY(world, self), 0x10, 1);
        wr16(ENTRY(world, self), 0x14, 0);
        copy_string(ENTRY(world, self) + 0x1a, world->bytes_5495bc);
        if (rd32(self, 0x20) == 0) wr32(self, 0x20, call4(host, 0x4c2790, 0x5cf659, 0x5495e8, rec_va, 6, 0x5495d4));
        wr32(ENTRY(world, self), 0, rd32(self, 0x20));
        rec = object_at(host, rec_va);
        if (!nine_bytes_equal(rec + 0x265, world->bytes_5495f0)) call1(host, 0x4fb77a, 0x5c3a67, rec_va + 0x265u);
        self[0x4a] = 0;
        self[0x49] = 0;
        wr32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d + 0x4d, 1);
    } else if (state == 1) {
        switch (rd32(self, 0x2d)) {
        case 0:
        case 1:
            self[0x24] = 1;
            break;
        case 2:
            if (host->tick(host->context) >= rd32(self, 0x4b)) {
                wr32(self, 0x2d, rd32(self, 0x31));
                wr32(self, 0x45, 1);
            }
            break;
        case 3:
            call1(host, 0x44d8ad, (uintptr_t)self, 1);
            self[0x24] = 1;
            wr32(self, 0x2d, 1);
            break;
        case 4:
            call1(host, 0x44d8ad, (uintptr_t)self, 0);
            self[0x24] = 1;
            wr32(self, 0x2d, 1);
            break;
        case 5:
            if (host->tick(host->context) >= rd32(self, 0x4f)) {
                rec = object_at(host, rec_va);
                if (!nine_bytes_equal(rec + 0x2b1, world->bytes_5495fc)) {
                    call1(host, 0x4fb77a, 0x5c3a67, rec_va + 0x2b1u);
                    call1(host, 0x4fb2e3, 0x5c3a67, rd16(rec, 0x2d2));
                    wr32(self, 0x2d, 7);
                } else {
                    wr32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d + 0x4d, 2);
                }
            }
            break;
        case 6:
            rec = object_at(host, rec_va);
            wr32(self, 0x4f, host->tick(host->context) + (uint32_t)(rds16(rec, 0x2af) * 0x3e8));
            self[0x4a] = 1;
            wr32(self, 0x2d, 5);
            break;
        case 7:
            rec = object_at(host, rec_va);
            if (call1(host, 0x4f6334, 0x5cf1eb, (uint32_t)rds16(rec, 0x2d2)) == 0) {
                call1(host, 0x4fba69, 0x5c3a67, rec_va + 0x2b1u);
                wr32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d + 0x4d, 2);
            }
            break;
        case 8:
            self[0x49] = 1;
            wr32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d + 0x4d, 2);
            break;
        default: break;
        }
    } else if (state == 2) {
        world->value_5bb1ca = 1;
        rec = object_at(host, rec_va);
        if (!nine_bytes_equal(rec + 0x265, world->bytes_549608)) call1(host, 0x4fba69, 0x5c3a67, rec_va + 0x265u);
        if (self[0x49] != 0) {
            if (rds16(rec, 0x2e2) != 0x270f) {
                world->value_5bb57b = (uint32_t)rds16(rec, 0x2e2);
                world->word_5bb599 = rd16(rec, 0x2e4);
                world->word_5bb595 = rd16(rec, 0x2e6);
                world->word_5c39ff = rd16(rec, 0x2e8);
                world->value_5bb59b = rd32(rec, 0x2ea);
                world->value_5bb59f = rd32(rec, 0x2ee);
                world->value_5bb5a3 = rd32(rec, 0x2f2);
                world->value_5bb1ca = rds16(rec, 0x2f6) == 1 ? 0u : 1u;
                world->value_583999 = 4;
            }
            if (rds16(rec, 0x2f8) != -1) wr32(world->flags_585801, (ptrdiff_t)rds16(rec, 0x2f8) * 4, rec[0x2fa]);
        } else if (self[0x4a] != 0) {
            call0(host, 0x44d946, (uintptr_t)self);
            if (rds16(rec, 0x296) != 0x270f) {
                world->value_5bb57b = (uint32_t)rds16(rec, 0x296);
                world->word_5bb599 = rd16(rec, 0x298);
                world->word_5bb595 = rd16(rec, 0x29a);
                world->word_5c39ff = rd16(rec, 0x29c);
                world->value_5bb59b = rd32(rec, 0x29e);
                world->value_5bb59f = rd32(rec, 0x2a2);
                world->value_5bb5a3 = rd32(rec, 0x2a6);
                world->value_5bb1ca = rds16(rec, 0x2aa) == 1 ? 0u : 1u;
                world->value_583999 = 4;
            }
            if (rds16(rec, 0x2ac) != -1) wr32(world->flags_585801, (ptrdiff_t)rds16(rec, 0x2ac) * 4, rec[0x2ae]);
        }
        call1(host, 0x42ba3a, 0, rd16(self, 0x1e));
        call0(host, 0x44d154, (uintptr_t)self);
    }
}
