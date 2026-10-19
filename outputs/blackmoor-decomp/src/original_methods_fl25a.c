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
