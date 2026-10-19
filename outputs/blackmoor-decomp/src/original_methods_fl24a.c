#include "original_methods_fl24a.h"

#include <string.h>

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

static uint32_t call6(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3,
                      uintptr_t a4, uintptr_t a5)
{
    uintptr_t args[6];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    args[3] = a3;
    args[4] = a4;
    args[5] = a5;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 6) : 0;
}

/* the object of an original address (an address that a record keeps), as host memory */
static const uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return host->resolve(host->context, address);
}

/* repe cmpsb with ecx = 9: 1 when the nine bytes at a and b are equal */
static int nine_bytes_equal(const uint8_t *a, const uint8_t *b)
{
    int k;
    for (k = 0; k < 9; k++)
        if (a[k] != b[k]) return 0;
    return 1;
}

/* `movsx ecx, word [self + idx]; imul ecx, ecx, 0x8d`: the byte offset of the record n in the table at 0x5bb5e5 */
static ptrdiff_t rec_offset(const uint8_t *self, ptrdiff_t idx_off)
{
    return (ptrdiff_t)(rds16(self, idx_off) * 0x8d);
}

/* `cmp dword [n * 0x8d + 0x5bb632], 1` */
static int record_state_is_1(const Fl24aWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    return rd32(world->records_5bb5e5, rec_offset(self, idx_off) + 0x4d) == 1;
}

/* `mov dword [n * 0x8d + 0x5bb632], 2` (the index word is read again, as the original does) */
static void set_record_state_2(const Fl24aWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    wr32(world->records_5bb5e5, rec_offset(self, idx_off) + 0x4d, 2);
}

/* `mov eax, [n * 0x8d + 0x5bb5e5]`: the original address of the object of record n */
static uint32_t record_object_address(const Fl24aWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    return rd32(world->records_5bb5e5, rec_offset(self, idx_off));
}

/* the signed compare of a sign-extended word with a dword of memory: lo <= v <= hi (jl / jg leave the range) */
static int in_range(int32_t v, int32_t lo, int32_t hi)
{
    return !(v < lo) && !(v > hi);
}

/* ---- 0x4d3bef ------------------------------------------------------------------------------------------------------------------ */

/* 0x4d3bef, thiscall, plain `ret`: [+0x462] = 0; then [+0x1c] = 1 when the byte at 0x61c6ae (zero-extended) is non-zero. */
void m4d3bef_reset_flags(uint8_t *self, const Fl24aWorld *world)
{
    wr32(self, 0x462, 0);
    if (world->byte_61c6ae != 0) wr32(self, 0x1c, 1);
}

/* ---- 0x44edfb ------------------------------------------------------------------------------------------------------------------ */

/* 0x44edfb: the record object address is read at entry (in [ebp-4]) before any guard. Guards: dword [+0x6b] set, dword [+0x2c] clear,
 * record state 1. Event 0x2787: [+0x67] = 1, state 2, nothing else (the announcement is skipped). Event 0x2786: by the signed word
 * [+0x30] (0: word [+0x26] -= 1 and copy the 49 bytes at record object + 0x1be to self + 0x32; 1: word [+0x26] += 1 and the same copy;
 * 2: [+0x28] = 1 and the copy from + 0x1ef; any other: nothing). Event 0x2785: word [+0x24] = word [+0x30], copy from + 0x18d. Every
 * event but 0x2787 then reaches the announcement: when the flag at 0x5bb1ca is non-zero and the nine bytes at self + 0x32 differ
 * from the constant at 0x549824, 0x4f6334 is asked about the sign-extended word [+0x53] and, when it answers zero, 0x4fb2e3 is called
 * with the word, the deadline [+0x63] = tick + 0xfa is stored and [+0x2c] = 1. */
void m44edfb_click_2785_2787(uint8_t *self, const Fl24aWorld *world, const Fl18Host *host)
{
    uint32_t record = record_object_address(world, self, 0x1e);
    if (rd32(self, 0x6b) == 0) return;
    if (rd32(self, 0x2c) != 0) return;
    if (!record_state_is_1(world, self, 0x1e)) return;
    if (world->value_5c39e5 == 0x2787) {
        wr32(self, 0x67, 1);
        set_record_state_2(world, self, 0x1e);
        return;
    }
    if (world->value_5c39e5 == 0x2786) {
        int32_t w = rds16(self, 0x30);
        if (w == 0) {
            wr16(self, 0x26, (uint16_t)(rd16(self, 0x26) - 1));
            memcpy(self + 0x32, object_at(host, record) + 0x1be, 0x31);
        } else if (w == 1) {
            wr16(self, 0x26, (uint16_t)(rd16(self, 0x26) + 1));
            memcpy(self + 0x32, object_at(host, record) + 0x1be, 0x31);
        } else if (w == 2) {
            wr32(self, 0x28, 1);
            memcpy(self + 0x32, object_at(host, record) + 0x1ef, 0x31);
        }
    } else if (world->value_5c39e5 == 0x2785) {
        wr16(self, 0x24, rd16(self, 0x30));
        memcpy(self + 0x32, object_at(host, record) + 0x18d, 0x31);
    }
    if (world->value_5bb1ca == 0) return;
    if (nine_bytes_equal(self + 0x32, world->bytes_549824)) return;
    if (call1(host, 0x4f6334, 0x5cf1eb, (uintptr_t)(uint32_t)rds16(self, 0x53)) != 0) return;
    call1(host, 0x4fb2e3, 0x5c3a67, rd16(self, 0x53));
    wr32(self, 0x63, host->tick(host->context) + 0xfa);
    wr32(self, 0x2c, 1);
}

/* ---- 0x4cb3ab ------------------------------------------------------------------------------------------------------------------ */

/* The shared tail of both arms of 0x4cb3ab: q = [+0x158] points at two words (a flag index and a value). When the index word is not -1
 * the dword table at 0x585801 gets the value at that index and, when the word at 0x63a4cd is non-zero, 0x50ca3e (cdecl, six arguments)
 * formats the line into 0x63888b and 0x44a2b7 (cdecl) is called with it. */
static void store_flag_and_print(uint8_t *self, const Fl24aWorld *world, const Fl18Host *host, uint32_t format)
{
    const uint8_t *q = object_at(host, rd32(self, 0x158));
    int32_t index, value;
    if (rds16(q, 0) == -1) return;
    q = object_at(host, rd32(self, 0x158));
    value = rds16(q, 2);
    q = object_at(host, rd32(self, 0x158));
    index = rds16(q, 0);
    wr32(world->flags_585801, (ptrdiff_t)index * 4, (uint32_t)value);
    if (world->word_63a4cd == 0) return;
    {
        uint32_t line = rd32(self, 0x1a);
        int32_t first = rds16(object_at(host, rd32(self, 0x12)), 0);
        int32_t second = rds16(object_at(host, rd32(self, 0x158)), 2);
        int32_t third = rds16(object_at(host, rd32(self, 0x158)), 0);
        call6(host, 0x50ca3e, 0, 0x63888b, format, (uint32_t)third, (uint32_t)second, (uint32_t)first, line);
        call1(host, 0x44a2b7, 0, 0x63888b);
    }
}

/* 0x4cb3ab, thiscall, plain `ret`: the dwords [+0xe], [+0x12], [+0x16] and [+0x15c] must all be set. With [+0x154] set the entry is the
 * one at word [[+0x154] + 0x14] (unless -1), else with [+0x14e] set the one at word [[+0x12] + 5] (unless -1); [+0x158] = [+0x16] +
 * entry * 4 + 0x23 is stored (the formats are 0x558b50 and 0x558bbc). Only when [+0x154] is set does the second arm stay unreached. */
void m4cb3ab_store_flag(uint8_t *self, const Fl24aWorld *world, const Fl18Host *host)
{
    if (rd32(self, 0xe) == 0) return;
    if (rd32(self, 0x12) == 0) return;
    if (rd32(self, 0x16) == 0) return;
    if (rd32(self, 0x15c) == 0) return;
    if (rd32(self, 0x154) != 0) {
        int32_t entry = rds16(object_at(host, rd32(self, 0x154)), 0x14);
        if (entry == -1) return;
        wr32(self, 0x158, rd32(self, 0x16) + (uint32_t)(rds16(object_at(host, rd32(self, 0x154)), 0x14) * 4) + 0x23);
        store_flag_and_print(self, world, host, 0x558b50);
        return;
    }
    if (rd32(self, 0x14e) == 0) return;
    {
        int32_t entry = rds16(object_at(host, rd32(self, 0x12)), 5);
        if (entry == -1) return;
        wr32(self, 0x158, rd32(self, 0x16) + (uint32_t)(rds16(object_at(host, rd32(self, 0x12)), 5) * 4) + 0x23);
        store_flag_and_print(self, world, host, 0x558bbc);
    }
}

/* ---- 0x44eab1 ------------------------------------------------------------------------------------------------------------------ */

/* 0x44eab1, thiscall, `ret 8`: x is the word at [esp+4], y the word at [esp+8]. Returns 0 when dword [+0x6b] is clear. Otherwise the
 * record object (read after the guard) holds `count` = signed word [+0x25] rectangles of 16 bytes from +0xed (x low, y low, x high, y
 * high at +0xed, +0xf1, +0xf5, +0xf9, signed dword compares of the sign-extended words): the first hit calls 0x44ecaf with (0x2785, the
 * index as a word) and returns 1. Then four fixed rectangles (y low/high, x low/high): +0x61/+0x69/+0x5d/+0x65 -> (0x2786, 0),
 * +0x71/+0x79/+0x6d/+0x75 -> (0x2786, 1), +0x31/+0x39/+0x2d/+0x35 -> (0x2786, 2), +0x25d/+0x265/+0x259/+0x261 -> (0x2787, 0); a hit
 * calls 0x44ecaf and returns 1; none returns 0. */
int32_t m44eab1_hit_test(uint8_t *self, int16_t x, int16_t y, const Fl24aWorld *world, const Fl18Host *host)
{
    const uint8_t *obj;
    int16_t i;
    if (rd32(self, 0x6b) == 0) return 0;
    obj = object_at(host, record_object_address(world, self, 0x1e));
    for (i = 0; (int32_t)i < rds16(obj, 0x25); i++) {
        ptrdiff_t at = (ptrdiff_t)((int32_t)i << 4);
        if (!in_range(y, rds32(obj, at + 0xf1), rds32(obj, at + 0xf9))) continue;
        if (!in_range(x, rds32(obj, at + 0xed), rds32(obj, at + 0xf5))) continue;
        call2(host, 0x44ecaf, (uintptr_t)self, 0x2785, (uint16_t)i);
        return 1;
    }
    if (in_range(y, rds32(obj, 0x61), rds32(obj, 0x69)) && in_range(x, rds32(obj, 0x5d), rds32(obj, 0x65))) {
        call2(host, 0x44ecaf, (uintptr_t)self, 0x2786, 0);
        return 1;
    }
    if (in_range(y, rds32(obj, 0x71), rds32(obj, 0x79)) && in_range(x, rds32(obj, 0x6d), rds32(obj, 0x75))) {
        call2(host, 0x44ecaf, (uintptr_t)self, 0x2786, 1);
        return 1;
    }
    if (in_range(y, rds32(obj, 0x31), rds32(obj, 0x39)) && in_range(x, rds32(obj, 0x2d), rds32(obj, 0x35))) {
        call2(host, 0x44ecaf, (uintptr_t)self, 0x2786, 2);
        return 1;
    }
    if (in_range(y, rds32(obj, 0x25d), rds32(obj, 0x265)) && in_range(x, rds32(obj, 0x259), rds32(obj, 0x261))) {
        call2(host, 0x44ecaf, (uintptr_t)self, 0x2787, 0);
        return 1;
    }
    return 0;
}

/* ---- 0x46ebff ------------------------------------------------------------------------------------------------------------------ */

/* 0x46ebff: the record object address is read at entry; base = object + 0x64d. Guards: dword [+0x46] set, [+0x5f] and [+0x28] clear,
 * record state 1. Event 0x27c2: k = byte [+0x52] if it is below 10 then 0 else byte - 9; [+0x28] = 1; word [+0x2c] = the byte;
 * [+0x2e] = tick + 0xfa; [+0x32] = 1; with the flag at 0x5bb1ca set and the nine bytes at base + k * 0x95 + 0x64 different from the
 * constant at 0x54c140, 0x4f6334 is asked about the sign-extended word at base + k * 0x95 + 0x85 and, when it answers zero, 0x4fb2e3 is
 * called with the word. Event 0x27c3: state 2; the eight bytes [+0x53..+0x5a] = 1; [+0x5f] = 1; t = tick; for j below the signed word
 * [object + 0x21]: [+0x67 + 4j] = t + 0x4709de(this = self, word [+0x36 + 2j], 0x4709bb(this = self, byte [+0x53 + j])); then 0x448d11
 * (this = 0x619a05) with ([0x5d03b3], 0x54c14c, -1, 0). */
void m46ebff_click_27c2_27c3(uint8_t *self, const Fl24aWorld *world, const Fl18Host *host)
{
    uint32_t record = record_object_address(world, self, 0x1e);
    if (rd32(self, 0x46) == 0) return;
    if (rd32(self, 0x5f) != 0) return;
    if (rd32(self, 0x28) != 0) return;
    if (!record_state_is_1(world, self, 0x1e)) return;
    if (world->value_5c39e5 == 0x27c2) {
        int32_t k = self[0x52] < 10 ? 0 : (int32_t)self[0x52] - 9;
        wr32(self, 0x28, 1);
        wr16(self, 0x2c, self[0x52]);
        wr32(self, 0x2e, host->tick(host->context) + 0xfa);
        wr32(self, 0x32, 1);
        if (world->value_5bb1ca != 0) {
            const uint8_t *base = object_at(host, record + 0x64d) + (ptrdiff_t)(k * 0x95);
            if (nine_bytes_equal(base + 0x64, world->bytes_54c140)) return;
            if (call1(host, 0x4f6334, 0x5cf1eb, (uintptr_t)(uint32_t)rds16(base, 0x85)) != 0) return;
            call1(host, 0x4fb2e3, 0x5c3a67, rd16(base, 0x85));
        }
    } else if (world->value_5c39e5 == 0x27c3) {
        uint32_t t;
        int32_t j;
        set_record_state_2(world, self, 0x1e);
        for (j = 0; j < 8; j++) self[0x53 + j] = 1;
        wr32(self, 0x5f, 1);
        t = host->tick(host->context);
        for (j = 0; j < rds16(object_at(host, record), 0x21); j++) {
            uint32_t first = call1(host, 0x4709bb, (uintptr_t)self, self[0x53 + j]);
            uint32_t second = call2(host, 0x4709de, (uintptr_t)self, (uintptr_t)(uint32_t)rds16(self, 0x36 + 2 * j), first);
            wr32(self, 0x67 + 4 * j, t + second);
        }
        call4(host, 0x448d11, 0x619a05, world->value_5d03b3, 0x54c14c, 0xffffffffu, 0);
    }
}

/* ---- 0x4571e1 ------------------------------------------------------------------------------------------------------------------ */

/* the edge arithmetic of the original is 32-bit and wraps: `mov ecx, [edge]; sub ecx, 5` */
static int32_t plus(int32_t edge, int32_t amount)
{
    return (int32_t)((uint32_t)edge + (uint32_t)amount);
}

/* 0x4571e1, thiscall, `ret 8`: x is the word at [esp+4], y the word at [esp+8]. Returns 0 when dword [+0x3e] is clear or dword [+0x2c] is
 * set. The record object (read after the guards) holds, in this order (y low/high, x low/high; the added amounts wrap in 32 bits):
 * +0x3b - 5 / +0x43 + 5 / +0x37 / +0x3f -> (0x27bc, 0); +0x4b + 5 / +0x53 + 5 / +0x47 + 10 / +0x4f - 10 -> (0x27bc, 1);
 * +0x5b / +0x63 / +0x57 / +0x5f -> (0x27bc, 2); then `count` = signed word [+0x25] rectangles of 16 bytes (y +0x9b / +0xa3, x +0x97 /
 * +0x9f): the first hit calls (0x27be, index as a word) unless the index equals the signed word [+0x2a], and returns 1 either way; last
 * +0x26f / +0x277 / +0x26b / +0x273 -> (0x27bd, 0). Each hit calls 0x45741d and returns 1; no hit returns 0. */
int32_t m4571e1_hit_test(uint8_t *self, int16_t x, int16_t y, const Fl24aWorld *world, const Fl18Host *host)
{
    const uint8_t *obj;
    int16_t i;
    if (rd32(self, 0x3e) == 0) return 0;
    if (rd32(self, 0x2c) != 0) return 0;
    obj = object_at(host, record_object_address(world, self, 0x1e));
    if (in_range(y, plus(rds32(obj, 0x3b), -5), plus(rds32(obj, 0x43), 5)) && in_range(x, rds32(obj, 0x37), rds32(obj, 0x3f))) {
        call2(host, 0x45741d, (uintptr_t)self, 0x27bc, 0);
        return 1;
    }
    if (in_range(y, plus(rds32(obj, 0x4b), 5), plus(rds32(obj, 0x53), 5)) && in_range(x, plus(rds32(obj, 0x47), 10), plus(rds32(obj, 0x4f), -10))) {
        call2(host, 0x45741d, (uintptr_t)self, 0x27bc, 1);
        return 1;
    }
    if (in_range(y, rds32(obj, 0x5b), rds32(obj, 0x63)) && in_range(x, rds32(obj, 0x57), rds32(obj, 0x5f))) {
        call2(host, 0x45741d, (uintptr_t)self, 0x27bc, 2);
        return 1;
    }
    for (i = 0; (int32_t)i < rds16(obj, 0x25); i++) {
        ptrdiff_t at = (ptrdiff_t)((int32_t)i << 4);
        if (!in_range(y, rds32(obj, at + 0x9b), rds32(obj, at + 0xa3))) continue;
        if (!in_range(x, rds32(obj, at + 0x97), rds32(obj, at + 0x9f))) continue;
        if ((int32_t)i != rds16(self, 0x2a)) call2(host, 0x45741d, (uintptr_t)self, 0x27be, (uint16_t)i);
        return 1;
    }
    if (in_range(y, rds32(obj, 0x26f), rds32(obj, 0x277)) && in_range(x, rds32(obj, 0x26b), rds32(obj, 0x273))) {
        call2(host, 0x45741d, (uintptr_t)self, 0x27bd, 0);
        return 1;
    }
    return 0;
}

/* ---- 0x47b4aa ------------------------------------------------------------------------------------------------------------------ */

/* the 32-bit product of two dwords (imul), as a byte offset */
static ptrdiff_t times(uint32_t a, uint32_t b)
{
    return (ptrdiff_t)(int32_t)(a * b);
}

/* 0x47b4aa, thiscall, `ret 8`: x is the word at [esp+4], y the word at [esp+8]. Returns 0 when dword [+0x24] is clear or dword [+0x28] or
 * [+0x2c] is set. Then [+0x27c] = -1. With the signed byte [A + 0x35b] non-zero, A being the object whose address is the dword [+0xc],
 * the three rows i of 16 bytes at A + [+0x28c] * 0x30 + 0x2a1 (x low +0, y low +4, x high +8, y high +0xc) are tried: a hit stores
 * [+0x27c] = i, calls 0x47b709 with 0x2768 and returns 1. Then for i below the signed dword [+0x280]: [+0x2b4] = [+0x28c] * [+0x280] + i
 * is stored first, and a hit of the rectangle (y +0x115 + 3 .. +0x11d - 3, x +0x111 + 3 .. +0x119 - 3 of A + 16 i) whose 12-byte entry
 * [+0x2b4] of the table whose address is the dword [+0x14] has its dwords +4 and +8 both zero stores [+0x27c] = i, calls 0x47b709 with
 * 0x2769 and returns 1. No hit returns 0. */
int32_t m47b4aa_hit_test(uint8_t *self, int16_t x, int16_t y, const Fl24aWorld *world, const Fl18Host *host)
{
    int32_t i;
    (void)world;
    if (rd32(self, 0x24) == 0) return 0;
    if (rd32(self, 0x28) != 0) return 0;
    if (rd32(self, 0x2c) != 0) return 0;
    wr32(self, 0x27c, 0xffffffffu);
    if ((int8_t)object_at(host, rd32(self, 0xc))[0x35b] != 0) {
        for (i = 0; i < 3; i++) {
            const uint8_t *row = object_at(host, rd32(self, 0xc)) + times(rd32(self, 0x28c), 0x30) + 0x2a1 + ((ptrdiff_t)i << 4);
            if (y < rds32(row, 4)) continue;
            if (y > rds32(row, 0xc)) continue;
            if (x < rds32(row, 0)) continue;
            if (x > rds32(row, 8)) continue;
            wr32(self, 0x27c, (uint32_t)i);
            call1(host, 0x47b709, (uintptr_t)self, 0x2768);
            return 1;
        }
    }
    for (i = 0; i < rds32(self, 0x280); i++) {
        const uint8_t *a;
        wr32(self, 0x2b4, (uint32_t)times(rd32(self, 0x28c), rd32(self, 0x280)) + (uint32_t)i);
        a = object_at(host, rd32(self, 0xc)) + ((ptrdiff_t)i << 4);
        if (y < plus(rds32(a, 0x115), 3)) continue;
        if (y > plus(rds32(a, 0x11d), -3)) continue;
        if (x < plus(rds32(a, 0x111), 3)) continue;
        if (x > plus(rds32(a, 0x119), -3)) continue;
        if (rd32(object_at(host, rd32(self, 0x14)), times(rd32(self, 0x2b4), 12) + 4) != 0) continue;
        if (rd32(object_at(host, rd32(self, 0x14)), times(rd32(self, 0x2b4), 12) + 8) != 0) continue;
        wr32(self, 0x27c, (uint32_t)i);
        call1(host, 0x47b709, (uintptr_t)self, 0x2769);
        return 1;
    }
    return 0;
}

/* ---- 0x4a6574 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4a6574, thiscall, `ret 8`: x is the word at [esp+4], y the word at [esp+8]. With the dword [+0x86] clear the original reaches the
 * tail that tests the same dword again and returns 0 without a store. With the byte [+0x29] set and [+0x86] set the original jumps to
 * that tail BEFORE the record object has been stored in its local [ebp-4], so the tail reads rectangle edges through an uninitialised
 * stack slot: unsafe, rejected here (returns 0, no call, no store). Otherwise the record object holds the rectangles (y low/high, x
 * low/high): +0x2b2/+0x2ba/+0x2ae/+0x2b6 -> (0x2772, 3), only when the byte [obj + 0x65] is set or the signed word [+0x2e] is below the
 * signed word [obj + 0x63] minus 1; +0x2c2/+0x2ca/+0x2be/+0x2c6 -> (0x2771, 2), only when the byte [obj + 0x65] is set or the signed word
 * [+0x2e] is above 0; +0x1ba/+0x1c2/+0x1b6/+0x1be -> (0x276f, 1); +0x1da/+0x1e2/+0x1d6/+0x1de -> (0x276f, 4) and byte [+0x20] = 1;
 * +0x3cb/+0x3d3/+0x3c7/+0x3cf -> (0x2770, 0) and byte [+0x20] = 1. A hit calls 0x4a67f3 and returns 1. With no hit the tail sets the byte
 * [+0x20] when the point is inside the rectangle +0x6a/+0x72/+0x66/+0x6e or the dword at 0x61d3c2 is 6, and returns 0. */
int32_t m4a6574_hit_test(uint8_t *self, int16_t x, int16_t y, const Fl24aWorld *world, const Fl18Host *host)
{
    const uint8_t *obj;
    if (rd32(self, 0x86) == 0) return 0;
    if (self[0x29] != 0) return 0;
    obj = object_at(host, record_object_address(world, self, 0x1e));
    if (in_range(y, rds32(obj, 0x2b2), rds32(obj, 0x2ba)) && in_range(x, rds32(obj, 0x2ae), rds32(obj, 0x2b6))) {
        if (obj[0x65] != 0 || rds16(self, 0x2e) < rds16(obj, 0x63) - 1) {
            call2(host, 0x4a67f3, (uintptr_t)self, 0x2772, 3);
            return 1;
        }
    }
    if (in_range(y, rds32(obj, 0x2c2), rds32(obj, 0x2ca)) && in_range(x, rds32(obj, 0x2be), rds32(obj, 0x2c6))) {
        if (obj[0x65] != 0 || rds16(self, 0x2e) > 0) {
            call2(host, 0x4a67f3, (uintptr_t)self, 0x2771, 2);
            return 1;
        }
    }
    if (in_range(y, rds32(obj, 0x1ba), rds32(obj, 0x1c2)) && in_range(x, rds32(obj, 0x1b6), rds32(obj, 0x1be))) {
        call2(host, 0x4a67f3, (uintptr_t)self, 0x276f, 1);
        return 1;
    }
    if (in_range(y, rds32(obj, 0x1da), rds32(obj, 0x1e2)) && in_range(x, rds32(obj, 0x1d6), rds32(obj, 0x1de))) {
        call2(host, 0x4a67f3, (uintptr_t)self, 0x276f, 4);
        self[0x20] = 1;
        return 1;
    }
    if (in_range(y, rds32(obj, 0x3cb), rds32(obj, 0x3d3)) && in_range(x, rds32(obj, 0x3c7), rds32(obj, 0x3cf))) {
        call2(host, 0x4a67f3, (uintptr_t)self, 0x2770, 0);
        self[0x20] = 1;
        return 1;
    }
    if (in_range(y, rds32(obj, 0x6a), rds32(obj, 0x72)) && in_range(x, rds32(obj, 0x66), rds32(obj, 0x6e))) self[0x20] = 1;
    else if (world->value_61d3c2 == 6) self[0x20] = 1;
    return 0;
}

/* ---- 0x465c99 ------------------------------------------------------------------------------------------------------------------ */

static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    uintptr_t args[3];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 3) : 0;
}

/* 0x465c99, thiscall, `ret 8`: x is the word at [esp+4], y the word at [esp+8]. Returns 0 when dword [+0x49] is clear. The record object
 * (read after the guard) holds, at the row k = signed word [+0x2a] (16 bytes per row), lo = [row + 0xf8], hi = [row + 0x100], y low
 * [row + 0xfc], y high [row + 0x104]; half = (hi - lo) / 2 (32-bit subtraction, cdq/sub/sar = division by 2 truncating toward zero).
 * Four tests in this order, each calling 0x465f8e with this = self and (0x27d2, a, b) and returning 1:
 *   y in [ylo, yhi], lo < x <= lo + half, signed word [+0x2c] == 0 and k > 0 -> (0x27d2, 0x19, 2);
 *   y in [ylo, yhi], lo + half < x < hi, [+0x2c] == 0 and k < 7 -> (0x27d2, 0x1a, 3);
 *   the rectangle +0x6c/+0x74 (y), +0x68/+0x70 (x) -> (0x27d2, 0x16, 1);
 *   the rectangle +0x5c/+0x64 (y), +0x58/+0x60 (x) with [+0x2c] < 3 -> (0x27d2, 0x14, 4), with [+0x2c] == 3 -> (0x27d2, 0x15, 4);
 *   the rectangle +0x553/+0x55b (y), +0x54f/+0x557 (x) -> (0x27d3, 0, 0).
 * No hit returns 0. */
int32_t m465c99_hit_test(uint8_t *self, int16_t x, int16_t y, const Fl24aWorld *world, const Fl18Host *host)
{
    const uint8_t *obj;
    ptrdiff_t row;
    int32_t half, lo, hi;
    if (rd32(self, 0x49) == 0) return 0;
    obj = object_at(host, record_object_address(world, self, 0x1e));
    row = (ptrdiff_t)(rds16(self, 0x2a) * 16);
    half = (int32_t)(rd32(obj, row + 0x100) - rd32(obj, row + 0xf8)) / 2;
    if (in_range(y, rds32(obj, row + 0xfc), rds32(obj, row + 0x104)) && x > rds32(obj, row + 0xf8) &&
        !(x > plus(rds32(obj, row + 0xf8), half)) && rds16(self, 0x2c) == 0 && rds16(self, 0x2a) > 0) {
        call3(host, 0x465f8e, (uintptr_t)self, 0x27d2, 0x19, 2);
        return 1;
    }
    lo = rds32(obj, row + 0xf8);
    hi = rds32(obj, row + 0x100);
    if (in_range(y, rds32(obj, row + 0xfc), rds32(obj, row + 0x104)) && x < hi && x > plus(lo, half) && rds16(self, 0x2c) == 0 &&
        rds16(self, 0x2a) < 7) {
        call3(host, 0x465f8e, (uintptr_t)self, 0x27d2, 0x1a, 3);
        return 1;
    }
    if (in_range(y, rds32(obj, 0x6c), rds32(obj, 0x74)) && in_range(x, rds32(obj, 0x68), rds32(obj, 0x70))) {
        call3(host, 0x465f8e, (uintptr_t)self, 0x27d2, 0x16, 1);
        return 1;
    }
    if (in_range(y, rds32(obj, 0x5c), rds32(obj, 0x64)) && in_range(x, rds32(obj, 0x58), rds32(obj, 0x60)) && rds16(self, 0x2c) < 3) {
        call3(host, 0x465f8e, (uintptr_t)self, 0x27d2, 0x14, 4);
        return 1;
    }
    if (in_range(y, rds32(obj, 0x5c), rds32(obj, 0x64)) && in_range(x, rds32(obj, 0x58), rds32(obj, 0x60)) && rds16(self, 0x2c) == 3) {
        call3(host, 0x465f8e, (uintptr_t)self, 0x27d2, 0x15, 4);
        return 1;
    }
    if (in_range(y, rds32(obj, 0x553), rds32(obj, 0x55b)) && in_range(x, rds32(obj, 0x54f), rds32(obj, 0x557))) {
        call3(host, 0x465f8e, (uintptr_t)self, 0x27d3, 0, 0);
        return 1;
    }
    return 0;
}
