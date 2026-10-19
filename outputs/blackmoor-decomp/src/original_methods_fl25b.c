#include "original_methods_fl25b.h"

#include <string.h>

#if defined(__GNUC__) || defined(__clang__)
#define FL25B_UNUSED __attribute__((unused))
#else
#define FL25B_UNUSED
#endif

FL25B_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL25B_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL25B_UNUSED static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL25B_UNUSED static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* a signed word, sign-extended (movsx) */
FL25B_UNUSED static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

FL25B_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, NULL, 0) : 0;
}

FL25B_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    uintptr_t args[1];
    args[0] = a0;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 1) : 0;
}

FL25B_UNUSED static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    uintptr_t args[2];
    args[0] = a0;
    args[1] = a1;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 2) : 0;
}

FL25B_UNUSED static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    uintptr_t args[3];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 3) : 0;
}

/* the object of an original address (an address that a record keeps), as host memory */
FL25B_UNUSED static const uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return host->resolve(host->context, address);
}

/* repe cmpsb with ecx = 9: 1 when the nine bytes at a and b are equal */
FL25B_UNUSED static int nine_bytes_equal(const uint8_t *a, const uint8_t *b)
{
    int k;
    for (k = 0; k < 9; k++)
        if (a[k] != b[k]) return 0;
    return 1;
}

/* `movsx ecx, word [self + idx]; imul ecx, ecx, 0x8d`: the byte offset of the record n in the table at 0x5bb5e5 */
FL25B_UNUSED static ptrdiff_t rec_offset(const uint8_t *self, ptrdiff_t idx_off)
{
    return (ptrdiff_t)(rds16(self, idx_off) * 0x8d);
}

/* `cmp dword [n * 0x8d + 0x5bb632], 1` */
FL25B_UNUSED static int record_state_is_1(const Fl25bWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    return rd32(world->records_5bb5e5, rec_offset(self, idx_off) + 0x4d) == 1;
}

/* `mov dword [n * 0x8d + 0x5bb632], 2` (the index word is read again, as the original does) */
FL25B_UNUSED static void set_record_state_2(const Fl25bWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    wr32(world->records_5bb5e5, rec_offset(self, idx_off) + 0x4d, 2);
}

/* `mov eax, [n * 0x8d + 0x5bb5e5]`: the original address of the object of record n */
FL25B_UNUSED static uint32_t record_object_address(const Fl25bWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    return rd32(world->records_5bb5e5, rec_offset(self, idx_off));
}

/* ---- 0x455180 ------------------------------------------------------------------------------------------------------------------ */

/* 0x455180, thiscall, `ret 0xc`: arguments x, y as words (movsx) and a pointer to four dwords; eax = 1 on a hit, else 0. `ro` is the
 * object of the record of the word [+0x1e]. Returns 0 at once when the dword [+0x150] is zero. Else [+0x26] = 1 and the block (dwords
 * 0..3) goes to [+0x15a], [+0x15e], [+0x162], [+0x166]. Rectangles are signed dwords, inclusive, in the order y low, y high, x low,
 * x high. With [+0x2a] != 0: 0x45504b runs (this = self), q = ro + 0x45 + 0x96 * the word [+0x36]; when the word ro[+0x7e0] is non-zero
 * or the word [+0x8a] equals the word q[+0x90], and the word [+0x8c] equals q[+0x92], and the point lies in q[+0x40 .. +0x4c] (x low
 * +0x40, y low +0x44, x high +0x48, y high +0x4c), 0x4554bb(0x27c8, the word [+0x36]) runs and 1 is returned. With [+0x2a] == 0 the
 * rectangles at ro+0x25 (0x27c5), ro+0x35 (0x27c6) and ro+0xcf1 (0x27c7) are tried in turn (call 0x4554bb(event, 0)). A miss falls into a
 * loop of i = 0 while i < the word ro[+0x21] (not bounded) over the entries q = ro + 0x45 + 0x96 * i with the word q[+0x94], the
 * rectangle q[+0x80 .. +0x8c]: a zero q[+0x94] and the point inside gives 0x4554bb(0x27c4, i); with [+0x2a] != 0 a non-zero q[+0x94]
 * and the point inside gives 0x4554bb(0x27c4, the word [+0x36]). The second argument of 0x4554bb is a word where the original pushes a
 * 16-bit register. A callee that changes self is not exercised. */
int32_t m455180_hit_test(uint8_t *self, int16_t x, int16_t y, const uint8_t *block, const Fl25bWorld *world, const Fl18Host *host)
{
    uint32_t ro_addr = record_object_address(world, self, 0x1e);
    const uint8_t *ro;
    int32_t i;
    if (rd32(self, 0x150) == 0) return 0;
    ro = object_at(host, ro_addr);
    wr32(self, 0x26, 1);
    wr32(self, 0x15e, rd32(block, 4));
    wr32(self, 0x166, rd32(block, 0xc));
    wr32(self, 0x15a, rd32(block, 0));
    wr32(self, 0x162, rd32(block, 8));
    if (rd32(self, 0x2a) != 0) {
        ptrdiff_t q = (ptrdiff_t)(rds16(self, 0x36) * 0x96) + 0x45;
        call0(host, 0x45504b, (uintptr_t)self);
        if (rds16(ro, 0x7e0) != 0 || rds16(self, 0x8a) == rds16(ro, q + 0x90)) {
            if (rds16(self, 0x8c) == rds16(ro, q + 0x92) && (int32_t)y >= (int32_t)rd32(ro, q + 0x44) &&
                (int32_t)y <= (int32_t)rd32(ro, q + 0x4c) && (int32_t)x >= (int32_t)rd32(ro, q + 0x40) &&
                (int32_t)x <= (int32_t)rd32(ro, q + 0x48)) {
                call2(host, 0x4554bb, (uintptr_t)self, 0x27c8, rd16(self, 0x36));
                return 1;
            }
        }
    } else {
        if ((int32_t)y >= (int32_t)rd32(ro, 0x29) && (int32_t)y <= (int32_t)rd32(ro, 0x31) && (int32_t)x >= (int32_t)rd32(ro, 0x25) &&
            (int32_t)x <= (int32_t)rd32(ro, 0x2d)) {
            call2(host, 0x4554bb, (uintptr_t)self, 0x27c5, 0);
            return 1;
        }
        if ((int32_t)y >= (int32_t)rd32(ro, 0x39) && (int32_t)y <= (int32_t)rd32(ro, 0x41) && (int32_t)x >= (int32_t)rd32(ro, 0x35) &&
            (int32_t)x <= (int32_t)rd32(ro, 0x3d)) {
            call2(host, 0x4554bb, (uintptr_t)self, 0x27c6, 0);
            return 1;
        }
        if ((int32_t)y >= (int32_t)rd32(ro, 0xcf5) && (int32_t)y <= (int32_t)rd32(ro, 0xcfd) && (int32_t)x >= (int32_t)rd32(ro, 0xcf1) &&
            (int32_t)x <= (int32_t)rd32(ro, 0xcf9)) {
            call2(host, 0x4554bb, (uintptr_t)self, 0x27c7, 0);
            return 1;
        }
    }
    for (i = 0; i < rds16(ro, 0x21); i++) {
        ptrdiff_t q = (ptrdiff_t)(i * 0x96) + 0x45;
        int inside = (int32_t)y >= (int32_t)rd32(ro, q + 0x84) && (int32_t)y <= (int32_t)rd32(ro, q + 0x8c) &&
                     (int32_t)x >= (int32_t)rd32(ro, q + 0x80) && (int32_t)x <= (int32_t)rd32(ro, q + 0x88);
        if (rds16(ro, q + 0x94) == 0 && inside) {
            call2(host, 0x4554bb, (uintptr_t)self, 0x27c4, (uint16_t)i);
            return 1;
        }
        if (rd32(self, 0x2a) != 0 && rds16(ro, q + 0x94) != 0 && inside) {
            call2(host, 0x4554bb, (uintptr_t)self, 0x27c4, rd16(self, 0x36));
            return 1;
        }
    }
    return 0;
}

