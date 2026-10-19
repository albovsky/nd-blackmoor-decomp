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
