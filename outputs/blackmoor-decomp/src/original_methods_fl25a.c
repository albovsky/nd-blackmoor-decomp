#include "original_methods_fl25a.h"

#include <string.h>

#define UNUSED_OK __attribute__((unused))

static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static int32_t rds32(const uint8_t *base, ptrdiff_t off)
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

static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, NULL, 0) : 0;
}

static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
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
static uint32_t record_object_address(const Fl25aWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    return rd32(world->records_5bb5e5, rec_offset(self, idx_off));
}

static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
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
static int in_range(int32_t v, int32_t lo, int32_t hi)
{
    return !(v < lo) && !(v > hi);
}

/* ---- 0x45e1ca ------------------------------------------------------------------------------------------------------------------ */

/* 0x45e1ca, thiscall, `ret 8`: x is the word at [ebp+8], y the word at [ebp+0xc]. Returns 0 when the byte [+0x321] is clear. P is the
 * object behind the dword [+0x31d] (read at every use in the original; self is not changed before the call at the end, so it is
 * resolved once). When dword [+0x39e] is 4:
 *  - byte [+0x3ae] set: for i (a word counter) below the signed word P[0x25]: row i of 16 bytes holds y in [P+0x657+16i, P+0x65f+16i]
 *    and x in [P+0x653+16i, P+0x65b+16i] (signed dword compares), and the signed word [+0x214+2i] is 1 or 2 (> 0 and < 3): word [+0x29a] = i,
 *    0x45e4d4(this = self, 0x27ed), return 1;
 *  - byte [+0x3ae] clear: for j below 3, for i below P[0x25]: row i of the block at P + 0xd0 j + 0x723 holds y in [+4, +0xc] and x in
 *    [+0, +8] (+16i), the dword [+0x144 + 0x34 j + 4 i] is 1 and the signed word [+0x214+2i] is below 3 (no lower bound): word [+0x29a] = i,
 *    0x45e4d4(this = self, 0x27ec), return 1.
 * Then (every other value of [+0x39e] and every fall-out of the loops): y in [P+0x133a, P+0x1342] and x in [P+0x1336, P+0x133e]:
 * 0x45e4d4(this = self, 0x27ef), return 1; else 0. */
int32_t m45e1ca_hit_test(uint8_t *self, int16_t x, int16_t y, const Fl18Host *host)
{
    const uint8_t *p;
    int16_t i, j;
    if (self[0x321] == 0) return 0;
    p = object_at(host, rd32(self, 0x31d));
    if (rd32(self, 0x39e) == 4) {
        if (self[0x3ae] != 0) {
            for (i = 0; (int32_t)i < rds16(p, 0x25); i++) {
                ptrdiff_t e = (ptrdiff_t)((int32_t)i << 4);
                if (!in_range(y, rds32(p, e + 0x657), rds32(p, e + 0x65f))) continue;
                if (!in_range(x, rds32(p, e + 0x653), rds32(p, e + 0x65b))) continue;
                if (rds16(self, 0x214 + 2 * (ptrdiff_t)i) <= 0) continue;
                if (rds16(self, 0x214 + 2 * (ptrdiff_t)i) >= 3) continue;
                wr16(self, 0x29a, (uint16_t)i);
                call1(host, 0x45e4d4, (uintptr_t)self, 0x27ed);
                return 1;
            }
        } else {
            for (j = 0; (int32_t)j < 3; j++) {
                for (i = 0; (int32_t)i < rds16(p, 0x25); i++) {
                    ptrdiff_t b = (ptrdiff_t)((int32_t)j * 0xd0 + 0x723) + (ptrdiff_t)((int32_t)i << 4);
                    if (!in_range(y, rds32(p, b + 4), rds32(p, b + 0xc))) continue;
                    if (!in_range(x, rds32(p, b), rds32(p, b + 8))) continue;
                    if (rd32(self, (ptrdiff_t)((int32_t)j * 0x34 + 0x144) + 4 * (ptrdiff_t)i) != 1) continue;
                    if (rds16(self, 0x214 + 2 * (ptrdiff_t)i) >= 3) continue;
                    wr16(self, 0x29a, (uint16_t)i);
                    call1(host, 0x45e4d4, (uintptr_t)self, 0x27ec);
                    return 1;
                }
            }
        }
    }
    if (!in_range(y, rds32(p, 0x133a), rds32(p, 0x1342))) return 0;
    if (!in_range(x, rds32(p, 0x1336), rds32(p, 0x133e))) return 0;
    call1(host, 0x45e4d4, (uintptr_t)self, 0x27ef);
    return 1;
}

/* ---- 0x464792 ------------------------------------------------------------------------------------------------------------------ */

/* 0x464792, thiscall, `ret 0xc`: x is the word at [ebp+8], y the word at [ebp+0xc], rect the address at [ebp+0x10] of four dwords. The
 * address of the object of the record (word [+0x1e]) is read at entry. Returns 0 when dword [+0xb8] is clear. Otherwise [+0x26] = 1 and
 * the rectangle is stored: [+0xc6] = rect[1], [+0xce] = rect[3], [+0xc2] = rect[0], [+0xca] = rect[2] (in that order).
 * With dword [+0x2a] set: 0x46465d(this = self) is called, then the object's rectangle at +0x45/+0x4d (y) and +0x41/+0x49 (x) is tested
 * when (word [+0x36] == 0 and word [+0x8a] == 0) or (dword [+0x8c] == 0 and word [+0x8a] == word [+0x36] - 1, a 32-bit subtract): a hit calls
 * 0x464ab5(this = self, 0x27cd, word [+0x36]) and returns 1. With it clear: the object's rectangles +0x25/+0x2d/+0x21/+0x29 (0x27ca),
 * +0x35/+0x3d/+0x31/+0x39 (0x27cb) and +0x433/+0x43b/+0x42f/+0x437 (0x27cc), each with the word argument 0.
 * Then for k below 5 (a dword counter): the 32-byte row k of the object (y at +0x65/+0x6d + 32k, x at +0x61/+0x69 + 32k): when dword
 * [+0x94 + 4k] is clear a hit calls 0x464ab5(0x27c9, k); and, with [+0x2a] and [+0x94 + 4k] both set, a hit calls 0x464ab5(0x27c9, word
 * [+0x36]); the first call returns 1. No hit returns 0. */
int32_t m464792_hit_test(uint8_t *self, int16_t x, int16_t y, uint32_t rect, const Fl25aWorld *world, const Fl18Host *host)
{
    uint32_t record = record_object_address(world, self, 0x1e);
    const uint8_t *obj, *r;
    int32_t k;
    if (rd32(self, 0xb8) == 0) return 0;
    obj = object_at(host, record);
    r = object_at(host, rect);
    wr32(self, 0x26, 1);
    wr32(self, 0xc6, rd32(r, 4));
    wr32(self, 0xce, rd32(r, 0xc));
    wr32(self, 0xc2, rd32(r, 0));
    wr32(self, 0xca, rd32(r, 8));
    if (rd32(self, 0x2a) != 0) {
        call0(host, 0x46465d, (uintptr_t)self);
        if ((rds16(self, 0x36) == 0 && rds16(self, 0x8a) == 0) || (rd32(self, 0x8c) == 0 && rds16(self, 0x8a) == rds16(self, 0x36) - 1)) {
            if (in_range(y, rds32(obj, 0x45), rds32(obj, 0x4d)) && in_range(x, rds32(obj, 0x41), rds32(obj, 0x49))) {
                call2(host, 0x464ab5, (uintptr_t)self, 0x27cd, rd16(self, 0x36));
                return 1;
            }
        }
    } else {
        if (in_range(y, rds32(obj, 0x25), rds32(obj, 0x2d)) && in_range(x, rds32(obj, 0x21), rds32(obj, 0x29))) {
            call2(host, 0x464ab5, (uintptr_t)self, 0x27ca, 0);
            return 1;
        }
        if (in_range(y, rds32(obj, 0x35), rds32(obj, 0x3d)) && in_range(x, rds32(obj, 0x31), rds32(obj, 0x39))) {
            call2(host, 0x464ab5, (uintptr_t)self, 0x27cb, 0);
            return 1;
        }
        if (in_range(y, rds32(obj, 0x433), rds32(obj, 0x43b)) && in_range(x, rds32(obj, 0x42f), rds32(obj, 0x437))) {
            call2(host, 0x464ab5, (uintptr_t)self, 0x27cc, 0);
            return 1;
        }
    }
    for (k = 0; k < 5; k++) {
        ptrdiff_t e = (ptrdiff_t)(k << 5);
        if (rd32(self, 0x94 + 4 * (ptrdiff_t)k) == 0) {
            if (in_range(y, rds32(obj, e + 0x65), rds32(obj, e + 0x6d)) && in_range(x, rds32(obj, e + 0x61), rds32(obj, e + 0x69))) {
                call2(host, 0x464ab5, (uintptr_t)self, 0x27c9, (uint16_t)k);
                return 1;
            }
        }
        if (rd32(self, 0x2a) == 0) continue;
        if (rd32(self, 0x94 + 4 * (ptrdiff_t)k) == 0) continue;
        if (in_range(y, rds32(obj, e + 0x65), rds32(obj, e + 0x6d)) && in_range(x, rds32(obj, e + 0x61), rds32(obj, e + 0x69))) {
            call2(host, 0x464ab5, (uintptr_t)self, 0x27c9, rd16(self, 0x36));
            return 1;
        }
    }
    return 0;
}

/* ---- 0x4a835c ------------------------------------------------------------------------------------------------------------------ */

/* 0x4a835c, thiscall, `ret 0xc`: x is the word at [ebp+8], y the word at [ebp+0xc], rect the address at [ebp+0x10] of four dwords. Returns 0
 * when dword [+0xe72] is clear. Otherwise the address of the object of the record (word [+0x1e]) is read; words [+0xe7a] and [+0xe7c] = 0xffff;
 * the rectangle is stored: [+0xe88] = rect[1], [+0xe90] = rect[3], [+0xe84] = rect[0], [+0xe8c] = rect[2] (in that order). Then the blocks
 * i below the signed word obj[0x43] (a dword counter, stride 0x90 from +0xe94) of rows j below the signed word obj[0x45] (16 bytes: x low
 * +0, y low +4, x high +8, y high +0xc, signed compares of the sign-extended words): the first row that holds the point calls
 * 0x4a8697(this = self, selector, i, j) and returns 1, with the selector 0x2799 when dword [+0xe5e] is set (after 0x4a8007(this = self), which
 * runs before the loops) and 0x2798 when it is clear. With [+0xe5e] set and no hit: [0x5b44f0] = 0x24, [0x5b44f4] = 0, [0x5d162d] = [0x5d0377],
 * [0x5d1631] = ([0x5b44f0] << 5) + ([0x5b44f4] << 4) + 0x5b160c, [0x5d1639] = 1, return 1. With it clear and no hit: the rectangle of the
 * object at +0x43e/+0x446 (y) and +0x43a/+0x442 (x): a hit calls 0x4a8697(this = self, 0x279a, 0, 0) and returns 1, else 0. */
int32_t m4a835c_hit_test(uint8_t *self, int16_t x, int16_t y, uint32_t rect, Fl25aWorld *world, const Fl18Host *host)
{
    uint32_t record;
    const uint8_t *obj, *r;
    int32_t i, j;
    int announce;
    if (rd32(self, 0xe72) == 0) return 0;
    record = record_object_address(world, self, 0x1e);
    obj = object_at(host, record);
    r = object_at(host, rect);
    wr16(self, 0xe7a, 0xffff);
    wr16(self, 0xe7c, 0xffff);
    wr32(self, 0xe88, rd32(r, 4));
    wr32(self, 0xe90, rd32(r, 0xc));
    wr32(self, 0xe84, rd32(r, 0));
    wr32(self, 0xe8c, rd32(r, 8));
    announce = rd32(self, 0xe5e) != 0;
    if (announce) call0(host, 0x4a8007, (uintptr_t)self);
    for (i = 0; i < rds16(obj, 0x43); i++) {
        for (j = 0; j < rds16(obj, 0x45); j++) {
            ptrdiff_t b = (ptrdiff_t)(i * 0x90) + 0xe94 + (ptrdiff_t)(j << 4);
            if (!in_range(y, rds32(self, b + 4), rds32(self, b + 0xc))) continue;
            if (!in_range(x, rds32(self, b), rds32(self, b + 8))) continue;
            call3(host, 0x4a8697, (uintptr_t)self, announce ? 0x2799 : 0x2798, (uintptr_t)i, (uintptr_t)j);
            return 1;
        }
    }
    if (announce) {
        world->value_5b44f0 = 0x24;
        world->value_5b44f4 = 0;
        world->value_5d162d = world->value_5d0377;
        world->value_5d1631 = (world->value_5b44f0 << 5) + (world->value_5b44f4 << 4) + 0x5b160c;
        world->value_5d1639 = 1;
        return 1;
    }
    if (!in_range(y, rds32(obj, 0x43e), rds32(obj, 0x446))) return 0;
    if (!in_range(x, rds32(obj, 0x43a), rds32(obj, 0x442))) return 0;
    call3(host, 0x4a8697, (uintptr_t)self, 0x279a, 0, 0);
    return 1;
}

/* ---- 0x45841e ------------------------------------------------------------------------------------------------------------------ */

/* 0x45841e, thiscall, `ret 0xc`: x is the word at [ebp+8], y the word at [ebp+0xc], rect the address at [ebp+0x10] of four dwords. The address
 * of the object of the record (word [+0x26]) is read at entry. Returns 0 when dword [+0x98] is clear. Otherwise the rectangle is stored:
 * [+0xa2] = rect[1], [+0xaa] = rect[3], [+0x9e] = rect[0], [+0xa6] = rect[2] (in that order). Then, with dword [+0x20] != 5:
 *  - word [+0x3a] != -1: 0x458262(this = self); 0x45839e(this = self, self + 0x3e, obj + 0xe5): non-zero: 0x45879e(this = self, 0x27a5),
 *    [+0xb4] = 0, return 1. Else for i below the signed word obj[0x23] (a dword counter, rows of 16 from obj + 0x105): the local rectangle
 *    {row+0x105 + 10, row+0x109 + 10, row+0x10d - 10, row+0x111 - 10} (32-bit) is built, and when word [+0x3a] == i,
 *    0x45839e(this = self, self + 0x3e, &local) non-zero: 0x45879e(0x27a5), [+0xb4] = 1, return 1.
 *  - word [+0x3a] == -1: when the signed word at 0x5a4c08 is below the signed word obj[0x21]: the first row i below obj[0x23] that holds the point
 *    (y in [row+0x109, row+0x111], x in [row+0x105, row+0x10d]) gives 0x45879e(0x27a4), [+0xb4] = 1, word [+0xae] = i, return 1; and, when the
 *    word at 0x5a4c08 is above 0, the rectangle obj +0xe9/+0xf1 (y), +0xe5/+0xed (x): 0x45879e(0x27a4), [+0xb4] = 0, return 1.
 * With dword [+0x20] == 5 (compared a second time, as the original does): the rectangle obj +0xf9/+0x101 (y), +0xf5/+0xfd (x): 0x45879e(0x27a4),
 * return 1. Everything else ends at the rectangle obj +0x657/+0x65f (y), +0x653/+0x65b (x): 0x45879e(0x279f), return 1, else 0. */
int32_t m45841e_hit_test(uint8_t *self, int16_t x, int16_t y, uint32_t rect, const Fl25aWorld *world, const Fl18Host *host)
{
    uint32_t record = record_object_address(world, self, 0x26);
    const uint8_t *obj, *r;
    int32_t i;
    if (rd32(self, 0x98) == 0) return 0;
    obj = object_at(host, record);
    r = object_at(host, rect);
    wr32(self, 0xa2, rd32(r, 4));
    wr32(self, 0xaa, rd32(r, 0xc));
    wr32(self, 0x9e, rd32(r, 0));
    wr32(self, 0xa6, rd32(r, 8));
    if (rd32(self, 0x20) != 5) {
        if (rds16(self, 0x3a) != -1) {
            call0(host, 0x458262, (uintptr_t)self);
            if (call2(host, 0x45839e, (uintptr_t)self, (uintptr_t)(self + 0x3e), (uintptr_t)(record + 0xe5)) != 0) {
                call1(host, 0x45879e, (uintptr_t)self, 0x27a5);
                wr32(self, 0xb4, 0);
                return 1;
            }
            for (i = 0; i < rds16(obj, 0x23); i++) {
                ptrdiff_t e = (ptrdiff_t)(i << 4);
                uint32_t local[4];
                local[1] = rd32(obj, e + 0x109) + 10;
                local[3] = rd32(obj, e + 0x111) - 10;
                local[0] = rd32(obj, e + 0x105) + 10;
                local[2] = rd32(obj, e + 0x10d) - 10;
                if (rds16(self, 0x3a) == i) {
                    if (call2(host, 0x45839e, (uintptr_t)self, (uintptr_t)(self + 0x3e), (uintptr_t)local) != 0) {
                        call1(host, 0x45879e, (uintptr_t)self, 0x27a5);
                        wr32(self, 0xb4, 1);
                        return 1;
                    }
                }
            }
        } else if (world->word_5a4c08 < rds16(obj, 0x21)) {
            for (i = 0; i < rds16(obj, 0x23); i++) {
                ptrdiff_t e = (ptrdiff_t)(i << 4);
                if (!in_range(y, rds32(obj, e + 0x109), rds32(obj, e + 0x111))) continue;
                if (!in_range(x, rds32(obj, e + 0x105), rds32(obj, e + 0x10d))) continue;
                call1(host, 0x45879e, (uintptr_t)self, 0x27a4);
                wr32(self, 0xb4, 1);
                wr16(self, 0xae, (uint16_t)i);
                return 1;
            }
            if (world->word_5a4c08 > 0 && in_range(y, rds32(obj, 0xe9), rds32(obj, 0xf1)) && in_range(x, rds32(obj, 0xe5), rds32(obj, 0xed))) {
                call1(host, 0x45879e, (uintptr_t)self, 0x27a4);
                wr32(self, 0xb4, 0);
                return 1;
            }
        }
    } else if (rd32(self, 0x20) == 5) {
        if (in_range(y, rds32(obj, 0xf9), rds32(obj, 0x101)) && in_range(x, rds32(obj, 0xf5), rds32(obj, 0xfd))) {
            call1(host, 0x45879e, (uintptr_t)self, 0x27a4);
            return 1;
        }
    }
    if (!in_range(y, rds32(obj, 0x657), rds32(obj, 0x65f))) return 0;
    if (!in_range(x, rds32(obj, 0x653), rds32(obj, 0x65b))) return 0;
    call1(host, 0x45879e, (uintptr_t)self, 0x279f);
    return 1;
}

/* ---- 0x45565f ------------------------------------------------------------------------------------------------------------------ */

/* 0x45565f, thiscall, plain `ret`: the record object address (word [+0x1e]) is read at entry. Guards: dword [+0x150] set, dword [+0x155]
 * clear, record state 1. Then by the selector [0x5c39e5]:
 *  0x27c7: byte [+0x154] = 1, record state = 2.
 *  0x27c6: word [+0x8e] = word [+0x8a]; word [+0x8a] = signed [+0x8a] < 3 ? [+0x8a] + 1 : 0; 0x455ab8(this = self).
 *  0x27c5: word [+0x8e] = word [+0x8a]; word [+0x8a] = signed [+0x8a] > 0 ? [+0x8a] - 1 : 3; 0x455ab8(this = self).
 *  0x27c4: with dword [+0x2a] set: 0x455a63(this = self), dword [+0x2e] = 1. With [+0x2a] set (read again) and signed words [+0x36] == [+0x38]:
 *    [+0x2a] = 0, word [+0x36] = 0xffff, done. Else word [+0x36] = word [+0x38]; m = signed [+0x36] * 0x96; word [+0x16a] = low 16 bits of
 *    obj[m+0xcd] - obj[m+0xc5], word [+0x16c] = low 16 bits of obj[m+0xd1] - obj[m+0xc9]; 0x455a0e(this = self); [+0x2a] = 1, [+0x32] = 1;
 *    the 16 bytes at obj + m + 0xc5 are copied to self + 0x7a as four dwords.
 *  0x27c8: when the signed word obj[0x7e0] is set and the signed word [+0x8a] differs from the signed word obj[m+0xd5] (m as above, from
 *    [+0x36]): 0x455b2e(this = self). Else 0x455a63(this = self); word obj[m+0xd9] = 1; when signed [+0x8c] < signed obj[0x23]: flag = 1;
 *    for j from 4 * [+0x8c] - 4 while j < 4 * [+0x8c] and flag == 1: flag = 0 unless signed word obj[j * 0x96 + 0xd9] == 1 (j is a signed
 *    dword and may be negative: the original then reads below the object, as this port does); when flag is set word [+0x8c] += 1. Then
 *    always: [+0x2a] = 0, [+0x2e] = 1, word [+0x36] = 0xffff, 0x455c4f(this = self).
 * Any other selector: nothing. The record object is written (word obj[m+0xd9]); the host's resolve returns mutable memory. */
void m45565f_click_27c4_27c8(uint8_t *self, const Fl25aWorld *world, const Fl18Host *host)
{
    uint32_t record = record_object_address(world, self, 0x1e);
    uint8_t *obj;
    uint32_t sel;
    ptrdiff_t m;
    if (rd32(self, 0x150) == 0) return;
    if (rd32(self, 0x155) != 0) return;
    if (rd32(world->records_5bb5e5, rec_offset(self, 0x1e) + 0x4d) != 1) return;
    sel = world->value_5c39e5;
    if (sel == 0x27c7) {
        self[0x154] = 1;
        wr32(world->records_5bb5e5, rec_offset(self, 0x1e) + 0x4d, 2);
        return;
    }
    if (sel == 0x27c6) {
        wr16(self, 0x8e, rd16(self, 0x8a));
        if (rds16(self, 0x8a) < 3) wr16(self, 0x8a, (uint16_t)(rd16(self, 0x8a) + 1));
        else wr16(self, 0x8a, 0);
        call0(host, 0x455ab8, (uintptr_t)self);
        return;
    }
    if (sel == 0x27c5) {
        wr16(self, 0x8e, rd16(self, 0x8a));
        if (rds16(self, 0x8a) > 0) wr16(self, 0x8a, (uint16_t)(rd16(self, 0x8a) - 1));
        else wr16(self, 0x8a, 3);
        call0(host, 0x455ab8, (uintptr_t)self);
        return;
    }
    if (sel == 0x27c4) {
        obj = (uint8_t *)object_at(host, record);
        if (rd32(self, 0x2a) != 0) {
            call0(host, 0x455a63, (uintptr_t)self);
            wr32(self, 0x2e, 1);
        }
        if (rd32(self, 0x2a) != 0 && rds16(self, 0x36) == rds16(self, 0x38)) {
            wr32(self, 0x2a, 0);
            wr16(self, 0x36, 0xffff);
            return;
        }
        wr16(self, 0x36, rd16(self, 0x38));
        m = (ptrdiff_t)(rds16(self, 0x36) * 0x96);
        wr16(self, 0x16a, (uint16_t)(rd32(obj, m + 0xcd) - rd32(obj, m + 0xc5)));
        wr16(self, 0x16c, (uint16_t)(rd32(obj, m + 0xd1) - rd32(obj, m + 0xc9)));
        call0(host, 0x455a0e, (uintptr_t)self);
        wr32(self, 0x2a, 1);
        wr32(self, 0x32, 1);
        m = (ptrdiff_t)(rds16(self, 0x36) * 0x96);
        wr32(self, 0x7a, rd32(obj, m + 0xc5));
        wr32(self, 0x7e, rd32(obj, m + 0xc9));
        wr32(self, 0x82, rd32(obj, m + 0xcd));
        wr32(self, 0x86, rd32(obj, m + 0xd1));
        return;
    }
    if (sel == 0x27c8) {
        int32_t j;
        int flag;
        obj = (uint8_t *)object_at(host, record);
        if (rds16(obj, 0x7e0) != 0 && rds16(self, 0x8a) != rds16(obj, (ptrdiff_t)(rds16(self, 0x36) * 0x96) + 0xd5)) {
            call0(host, 0x455b2e, (uintptr_t)self);
        } else {
            call0(host, 0x455a63, (uintptr_t)self);
            wr16(obj, (ptrdiff_t)(rds16(self, 0x36) * 0x96) + 0xd9, 1);
            if (rds16(self, 0x8c) < rds16(obj, 0x23)) {
                flag = 1;
                for (j = rds16(self, 0x8c) * 4 - 4; j < rds16(self, 0x8c) * 4 && flag == 1; j++) {
                    if (rds16(obj, (ptrdiff_t)(j * 0x96) + 0xd9) != 1) flag = 0;
                }
                if (flag != 0) wr16(self, 0x8c, (uint16_t)(rd16(self, 0x8c) + 1));
            }
        }
        wr32(self, 0x2a, 0);
        wr32(self, 0x2e, 1);
        wr16(self, 0x36, 0xffff);
        call0(host, 0x455c4f, (uintptr_t)self);
    }
}

/* ---- 0x473206 ------------------------------------------------------------------------------------------------------------------ */

/* the signed division by two of `cdq; sub eax, edx; sar eax, 1` (rounds toward zero for a negative value: d + 1 first), in 32-bit arithmetic */
static int32_t half_toward_zero(int32_t d)
{
    uint32_t t = (uint32_t)d - (uint32_t)(d >> 31);
    return (int32_t)t >> 1;
}

/* 0x473206, thiscall, `ret 8`: x is the word at [ebp+8], y the word at [ebp+0xc]. [+0x76] = the address of the object of the record (word [+0xc]);
 * word [+0xe] = 0xffff. Returns 0 when dword [+0x7a] is clear. Otherwise, with A = [0x5b44f0] and B = [0x5b44f4]:
 *   [+0x335] = [0x583102] + dword[0x5b3e40 + 16A + 8B];  [+0x33d] = [+0x335] + signed word[0x5b3ae8 + 8A + 4B] - 1;
 *   [+0x339] = [0x583106] + dword[0x5b3e44 + 16A + 8B];  [+0x341] = [+0x339] + signed word[0x5b3aea + 8A + 4B] - 1;
 *   word [+0x345] = [+0x335] + ([+0x33d] - [+0x335]) / 2;  word [+0x347] = [+0x339] + ([+0x341] - [+0x339]) / 2   (halves round toward zero).
 * 0x4e22fd(this = self + 0x1a6, word [+0x345], word [+0x347]) non-zero: [0x5c39e5] = 0x27a3, return 1. Else the rectangle of the record object
 * (y in [+0x4f3, +0x4fb], x in [+0x4ef, +0x4f7], signed): [0x5b44f0] = 9, [0x5b44f4] = 1, [0x5d162d] = [0x5d0377], [0x5d1631] = (9 << 5) +
 * (1 << 4) + 0x5b160c, [0x5d1639] = 1, [0x5c39e5] = 0x27a1, return 1. Else 0x473651(this = self); for k below 4 whose dword [0x5a4b4e + 4k] is
 * clear: with the signed byte obj[0x106] set, the centre (words [+0x345], [+0x347]) inside the rectangle 0x5a4b5e + 16k (x low +0, y low +4, x high
 * +8, y high +0xc) sets word [+0xe] = k and ends the loop; with it clear 0x4d5316(this = 0x570450, 0x5a4b5e + 16k, self + 0x335) non-zero does.
 * word [+0xe] == -1: 0x473f7d(this = self), return 0. Then, when the signed word 0x583a29 differs from the signed word obj[0x104] and that is not
 * -1: dword [+0x375 + 4 [+0xe]] clear: 0x4eb184(this = 0x571442, the sign-extended word obj[0x104]) and the dword = 1; return 0. Else
 * 0x47409e(this = self); with dword 0x5a4bce == -1: w = word [+0xe]: dword[0x5a4b9e + 8w] = [0x583102] - rect.xlow, dword[0x5a4ba2 + 8w] =
 * [0x583106] - rect.ylow, [0x5a4bce] = w, dword[0x5a4bbe + 4w] = 1, dword[0x63a864 + 4k] = GetTickCount(), and with dword [+0x371] set: it is
 * cleared and 0x47512a(this = self) is called. Return 1. */
int32_t m473206_click(uint8_t *self, int16_t x, int16_t y, Fl25aWorld *world, const Fl18Host *host)
{
    const uint8_t *rec2;
    uint8_t *blk;
    int32_t k, a, b, d;
    int16_t w;
    wr32(self, 0x76, record_object_address(world, self, 0xc));
    wr16(self, 0xe, 0xffff);
    if (rd32(self, 0x7a) == 0) return 0;
    a = (int32_t)world->value_5b44f0;
    b = (int32_t)world->value_5b44f4;
    wr32(self, 0x335, world->value_583102 + rd32(world->table_5b3e40, (ptrdiff_t)(int32_t)((uint32_t)a * 16u + (uint32_t)b * 8u)));
    wr32(self, 0x33d, rd32(self, 0x335) + (uint32_t)rds16(world->table_5b3ae8, (ptrdiff_t)(int32_t)((uint32_t)b * 4u + (uint32_t)a * 8u)) - 1u);
    wr32(self, 0x339, world->value_583106 + rd32(world->table_5b3e40, (ptrdiff_t)(int32_t)((uint32_t)a * 16u + (uint32_t)b * 8u) + 4));
    wr32(self, 0x341, rd32(self, 0x339) + (uint32_t)rds16(world->table_5b3ae8, (ptrdiff_t)(int32_t)((uint32_t)b * 4u + (uint32_t)a * 8u) + 2) - 1u);
    d = half_toward_zero((int32_t)(rd32(self, 0x33d) - rd32(self, 0x335)));
    wr16(self, 0x345, (uint16_t)(rd32(self, 0x335) + (uint32_t)d));
    d = half_toward_zero((int32_t)(rd32(self, 0x341) - rd32(self, 0x339)));
    wr16(self, 0x347, (uint16_t)(rd32(self, 0x339) + (uint32_t)d));
    if (call2(host, 0x4e22fd, (uintptr_t)(self + 0x1a6), rd16(self, 0x345), rd16(self, 0x347)) != 0) {
        world->value_5c39e5 = 0x27a3;
        return 1;
    }
    rec2 = object_at(host, rd32(self, 0x76));
    if (in_range(y, rds32(rec2, 0x4f3), rds32(rec2, 0x4fb)) && in_range(x, rds32(rec2, 0x4ef), rds32(rec2, 0x4f7))) {
        world->value_5b44f0 = 9;
        world->value_5b44f4 = 1;
        world->value_5d162d = world->value_5d0377;
        world->value_5d1631 = (world->value_5b44f0 << 5) + (world->value_5b44f4 << 4) + 0x5b160c;
        world->value_5d1639 = 1;
        world->value_5c39e5 = 0x27a1;
        return 1;
    }
    call0(host, 0x473651, (uintptr_t)self);
    blk = world->block_5a4b4e;
    for (k = 0; k < 4; k++) {
        ptrdiff_t r = 0x10 + 16 * (ptrdiff_t)k;
        if (rd32(blk, 4 * (ptrdiff_t)k) != 0) continue;
        if ((int8_t)rec2[0x106] != 0) {
            if (!in_range(rds16(self, 0x347), rds32(blk, r + 4), rds32(blk, r + 0xc))) continue;
            if (!in_range(rds16(self, 0x345), rds32(blk, r), rds32(blk, r + 8))) continue;
            wr16(self, 0xe, (uint16_t)k);
            break;
        }
        if (call2(host, 0x4d5316, 0x570450, (uintptr_t)(0x5a4b5eu + 16u * (uint32_t)k), (uintptr_t)(self + 0x335)) != 0) {
            wr16(self, 0xe, (uint16_t)k);
            break;
        }
    }
    if (rds16(self, 0xe) == -1) {
        call0(host, 0x473f7d, (uintptr_t)self);
        return 0;
    }
    if ((int32_t)world->word_583a29 != rds16(rec2, 0x104) && rds16(rec2, 0x104) != -1) {
        ptrdiff_t at = 0x375 + 4 * (ptrdiff_t)rds16(self, 0xe);
        if (rd32(self, at) == 0) {
            call1(host, 0x4eb184, 0x571442, (uintptr_t)(uint32_t)rds16(rec2, 0x104));
            wr32(self, at, 1);
        }
        return 0;
    }
    call0(host, 0x47409e, (uintptr_t)self);
    if (rd32(blk, 0x80) == 0xffffffffu) {
        w = (int16_t)rds16(self, 0xe);
        wr32(blk, 0x50 + 8 * (ptrdiff_t)w, world->value_583102 - rd32(blk, 0x10 + 16 * (ptrdiff_t)w));
        wr32(blk, 0x54 + 8 * (ptrdiff_t)w, world->value_583106 - rd32(blk, 0x14 + 16 * (ptrdiff_t)w));
        wr32(blk, 0x80, (uint32_t)(int32_t)w);
        wr32(blk, 0x70 + 4 * (ptrdiff_t)w, 1);
        wr32(world->ticks_63a864, 4 * (ptrdiff_t)k, host->tick(host->context));
        if (rd32(self, 0x371) != 0) {
            wr32(self, 0x371, 0);
            call0(host, 0x47512a, (uintptr_t)self);
        }
    }
    return 1;
}
