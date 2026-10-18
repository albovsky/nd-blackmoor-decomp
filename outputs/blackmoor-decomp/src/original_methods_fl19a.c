#include "original_methods_fl19a.h"

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

/* The host memory behind an original address stored in memory; writable where a function writes through it. */
static uint8_t *at(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)(uintptr_t)host->resolve(host->context, address);
}

/* The unrolled string compare that the original inlines (0x423259, 0x4e444d): the first operand is compared with the second, two
 * bytes per pass, and the result is 0 for equal strings, -1 when the first differing byte of a is below that of b and 1 above. */
static int32_t inline_strcmp(const uint8_t *a, const uint8_t *b)
{
    for (;;) {
        uint8_t c = a[0];
        uint8_t d;
        if (c != b[0]) return c < b[0] ? -1 : 1;
        if (c == 0) return 0;
        d = a[1];
        if (d != b[1]) return d < b[1] ? -1 : 1;
        a += 2;
        b += 2;
        if (d == 0) return 0;
    }
}

/* The signed offsets that 0x4e89eb and 0x4ee2a9 use into the tables 0x5b30cc / 0x5b3e40 (a << 4) + b * 8 and into 0x5b3ae8 b * 4 +
 * a * 8, in 32-bit arithmetic (a = dword 0x5b44f0, b = dword 0x5b44f4). */
static ptrdiff_t dword_pair_offset(const Fl19aWorld *world)
{
    return (int32_t)((world->value_5b44f0 << 4) + world->value_5b44f4 * 8u);
}

static ptrdiff_t word_pair_offset(const Fl19aWorld *world)
{
    return (int32_t)(world->value_5b44f4 * 4u + world->value_5b44f0 * 8u);
}

/* The value that 0x4ee2a9 and 0x48bd91 store in dword 0x5d1631: 0x5b160c + (dword 0x5b44f0 << 5) + (dword 0x5b44f4 << 4). */
static uint32_t hotspot_address(const Fl19aWorld *world)
{
    return (world->value_5b44f0 << 5) + (world->value_5b44f4 << 4) + 0x5b160cu;
}

/* original GAME.EXE 0x4ceb3b (FUN_004ceb3b), this = self, stack argument index (signed word): dword [self+0x216] := 0; dword
 * 0x5d1a45 := 0; dword 0x5839a9 := dword [self+0x202]; 0x4d36ed; 0x4cd218 on self; byte [0x5bb625 + index * 0x8d] := 1. */
void m4ceb3b_reset_state(uint8_t *self, int16_t index, Fl19aWorld *world, const Fl18Host *host)
{
    wr32(self, 0x216, 0);
    wr32(world->globals_5d1a31, 0x14, 0);
    world->value_5839a9 = rd32(self, 0x202);
    call0(host, 0x4d36ed, 0);
    call0(host, 0x4cd218, (uintptr_t)self);
    world->records_5bb5e5[(ptrdiff_t)index * 0x8d + 0x40] = 1;
}

/* original GAME.EXE 0x423f57 (FUN_00423f57), this = self, stack arguments entry (a pointer to a record) and value (dword):
 * 0x4234c8 on self; dword [self+0x614] := value. When the dword [entry+4] is non-zero: 0x424201 on self with entry, dword 0x5c3a47 :=
 * (dword [entry] == 0), and the result is the dword [entry]. Otherwise dword 0x5c3a47 := (dword [entry] == 0) and the result is 1. */
uint32_t m423f57_load_entry(uint8_t *self, const uint8_t *entry, uint32_t value, Fl19aWorld *world, const Fl18Host *host)
{
    call0(host, 0x4234c8, (uintptr_t)self);
    wr32(self, 0x614, value);
    if (rd32(entry, 4) != 0) {
        call1(host, 0x424201, (uintptr_t)self, (uintptr_t)entry);
        world->value_5c3a47 = rd32(entry, 0) == 0;
        return rd32(entry, 0);
    }
    world->value_5c3a47 = rd32(entry, 0) == 0;
    return 1;
}

/* original GAME.EXE 0x4cecf7 (FUN_004cecf7), this = self: the block at 0x5d1a31 := dword 0xb, dword 0x4cf749, dword 0, dword
 * self + 0x1e2, dword self + 0x1f2 (the original addresses), dword 0, dword 1, word 0; then the zero-terminated string at 0x559b18
 * (terminator included) is copied to 0x5d1a53. */
void m4cecf7_init_descriptor(uint8_t *self, const Fl19aWorld *world)
{
    uint8_t *block = world->globals_5d1a31;
    (void)self;
    wr32(block, 0, 0xb);
    wr32(block, 4, 0x4cf749);
    wr32(block, 8, 0);
    wr32(block, 0xc, world->self_address + 0x1e2u);
    wr32(block, 0x10, world->self_address + 0x1f2u);
    wr32(block, 0x14, 0);
    wr32(block, 0x18, 1);
    wr16(block, 0x1c, 0);
    memcpy(block + 0x22, world->string_559b18, strlen((const char *)world->string_559b18) + 1);
}

/* original GAME.EXE 0x4ea269 (FUN_004ea269), this = self, stack arguments piece (signed word), mode (signed word), flag (dword).
 * When the signed word 0x583f1d is not -1: 0x4e9e84 on self with (that word, 1). When it is -1 (read again): 0x4eb70f on self with 2.
 * Word 0x583f1d := piece when mode == 1, else 0xffff. 0x4ea06c on self with the word piece; when flag is non-zero 0x4fb2e3 on 0x5c3a67
 * with 0x17. Then dword 0x5bb57b := the signed word [self + piece * 0x16d + 0x780], words 0x5bb599 and 0x5bb595 := 0, word 0x5c39ff
 * := the word [self + piece * 0x16d + 0x782], dwords 0x5bb59b and 0x5bb59f := 0, 0x5bb5a3 := 1, 0x583999 := 4; 0x4e7d04 on self. */
void m4ea269_select_piece(uint8_t *self, int16_t piece, int16_t mode, uint32_t flag, Fl19aWorld *world, const Fl18Host *host)
{
    ptrdiff_t base;
    if ((int16_t)world->word_583f1d != -1) call2(host, 0x4e9e84, (uintptr_t)self, world->word_583f1d, 1);
    if ((int16_t)world->word_583f1d == -1) call1(host, 0x4eb70f, (uintptr_t)self, 2);
    if (mode == 1)
        world->word_583f1d = (uint16_t)piece;
    else
        world->word_583f1d = 0xffff;
    call1(host, 0x4ea06c, (uintptr_t)self, (uint16_t)piece);
    if (flag != 0) call1(host, 0x4fb2e3, 0x5c3a67, 0x17);
    base = (ptrdiff_t)piece * 0x16d;
    world->value_5bb57b = (uint32_t)rds16(self, base + 0x780);
    world->word_5bb599 = 0;
    world->word_5bb595 = 0;
    world->word_5c39ff = rd16(self, base + 0x782);
    world->value_5bb59b = 0;
    world->value_5bb59f = 0;
    world->value_5bb5a3 = 1;
    world->value_583999 = 4;
    call0(host, 0x4e7d04, (uintptr_t)self);
}

/* original GAME.EXE 0x4ccdab (FUN_004ccdab), this = self: the dwords [self+0x216], 0x236, 0x206, 0x20a, 0x20e, 0x212, 0x1d6, 0x222 := 0;
 * the 0x73 dwords and one word from [self+8] := 0; dword [self+0x17a] := 1, 0x17e := 0; dword 0x5d1a45 := 0; dword [self+0x1de] := 0,
 * 0x232 := -1, 0x23a := 2, 0x23e := -1, 0x242 := -1, 0x222 := 0, 0x226 := 0, 0x22a := 0, 0x246 := -1, 0x24a := -1, 0x24e := 0, 0x256 := -1. */
void m4ccdab_reset_object(uint8_t *self, Fl19aWorld *world)
{
    wr32(self, 0x216, 0);
    wr32(self, 0x236, 0);
    wr32(self, 0x206, 0);
    wr32(self, 0x20a, 0);
    wr32(self, 0x20e, 0);
    wr32(self, 0x212, 0);
    wr32(self, 0x1d6, 0);
    wr32(self, 0x222, 0);
    memset(self + 8, 0, 0x73 * 4 + 2);
    wr32(self, 0x17a, 1);
    wr32(self, 0x17e, 0);
    wr32(world->globals_5d1a31, 0x14, 0);
    wr32(self, 0x1de, 0);
    wr32(self, 0x232, 0xffffffffu);
    wr32(self, 0x23a, 2);
    wr32(self, 0x23e, 0xffffffffu);
    wr32(self, 0x242, 0xffffffffu);
    wr32(self, 0x222, 0);
    wr32(self, 0x226, 0);
    wr32(self, 0x22a, 0);
    wr32(self, 0x246, 0xffffffffu);
    wr32(self, 0x24a, 0xffffffffu);
    wr32(self, 0x24e, 0);
    wr32(self, 0x256, 0xffffffffu);
}

/* original GAME.EXE 0x47e2a5 (FUN_0047e2a5), this = self: for each of the dwords [self+0x13a4], 0x13a8, 0x13ac that is non-zero: 0x4c2dfb
 * on the surface manager 0x5cf659 with its address (self + that offset), then it := 0. Then for i = 0 .. 19 (signed word) and j = 0 .. 3:
 * the same for the dword [self + i * 0x60 + 0x20 + j * 0x18]. When the signed word [self+0x1c] is not -1: 0x4d3992 (cdecl) with that
 * word. Finally 0x47e25a on self. */
void m47e2a5_release_surfaces(uint8_t *self, const Fl18Host *host)
{
    static const ptrdiff_t slots[3] = {0x13a4, 0x13a8, 0x13ac};
    int16_t i, j;
    int k;
    for (k = 0; k < 3; k++) {
        if (rd32(self, slots[k]) != 0) {
            call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + slots[k]));
            wr32(self, slots[k], 0);
        }
    }
    for (i = 0; i < 0x14; i = (int16_t)(i + 1)) {
        for (j = 0; j < 4; j = (int16_t)(j + 1)) {
            ptrdiff_t off = (ptrdiff_t)i * 0x60 + 0x20 + (ptrdiff_t)j * 0x18;
            if (rd32(self, off) != 0) {
                call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + off));
                wr32(self, off, 0);
            }
        }
    }
    if (rds16(self, 0x1c) != -1) call1(host, 0x4d3992, 0, rd16(self, 0x1c));
    call0(host, 0x47e25a, (uintptr_t)self);
}

/* original GAME.EXE 0x423259 (FUN_00423259), this = self, stack argument name (a zero-terminated string): index := 0x423368 on self with
 * name; node := the dword [self + index * 4]. While node is non-zero: the two locals (one 0x4c byte frame: the second at ebp-0x4c, the first at ebp-0x28 so that
 * a long copy runs on into its neighbour, as in the original) get copies of name and of the string at [node+4]; 0x50d0bc (cdecl) is called on the first and then on the second; when the locals compare equal the
 * result is the dword [node], else node := the dword [node+0x25]. The result is 0 when the chain ends. */
uint32_t m423259_find_by_name(uint8_t *self, const uint8_t *name, const Fl18Host *host)
{
    uint8_t frame[0x48];
    uint8_t *second = frame, *first = frame + 0x24;
    uint32_t index = call1(host, 0x423368, (uintptr_t)self, (uintptr_t)name);
    uint32_t node = rd32(self, (ptrdiff_t)(int32_t)index * 4);
    while (node != 0) {
        const uint8_t *entry = at(host, node);
        memcpy(first, name, strlen((const char *)name) + 1);
        memcpy(second, entry + 4, strlen((const char *)entry + 4) + 1);
        call1(host, 0x50d0bc, 0, (uintptr_t)first);
        call1(host, 0x50d0bc, 0, (uintptr_t)second);
        if (inline_strcmp(first, second) == 0) return rd32(entry, 0);
        node = rd32(entry, 0x25);
    }
    return 0;
}

/* original GAME.EXE 0x4e89eb (FUN_004e89eb), this = self: nothing unless the dword [self+0x764c] is 2 or 3. 0x4ee2a9 on self: a non-zero
 * result ends the function. With a = dword 0x5b44f0, b = dword 0x5b44f4, o = (a << 4) + b * 8 and p = b * 4 + a * 8: dword [self+0x823a]
 * := dword 0x583102 + dword[0x5b30cc + o]; [self+0x823e] := dword 0x583106 + dword[0x5b30d0 + o]; dwords 0x5c3a5b and 0x5c3a5f := those two;
 * [self+0x8242] := 0x583102 + dword[0x5b3e40 + o]; [self+0x824a] := [self+0x8242] + signed word[0x5b3ae8 + p] - 1; [self+0x8246] :=
 * 0x583106 + dword[0x5b3e44 + o]; [self+0x824e] := [self+0x8246] + signed word[0x5b3aea + p] - 1. Then [self+0x822e] counts 0 .. 5 (signed,
 * re-read): when the dword [self + i * 0xf7 + 0x7012] is non-zero 0x4e22fd on self + i * 0x18f + 0x7654 with the words ([self+0x823a],
 * [self+0x823e]); finally 0x4e8bb4 on self. */
void m4e89eb_layout_slots(uint8_t *self, Fl19aWorld *world, const Fl18Host *host)
{
    ptrdiff_t o, p;
    if (rd32(self, 0x764c) != 2 && rd32(self, 0x764c) != 3) return;
    if (call0(host, 0x4ee2a9, (uintptr_t)self) != 0) return;
    o = dword_pair_offset(world);
    p = word_pair_offset(world);
    wr32(self, 0x823a, world->value_583102 + rd32(world->table_5b30cc, o));
    wr32(self, 0x823e, world->value_583106 + rd32(world->table_5b30cc, o + 4));
    world->value_5c3a5b = rd32(self, 0x823a);
    world->value_5c3a5f = rd32(self, 0x823e);
    wr32(self, 0x8242, world->value_583102 + rd32(world->table_5b3e40, o));
    wr32(self, 0x824a, rd32(self, 0x8242) + (uint32_t)rds16(world->table_5b3ae8, p) - 1u);
    wr32(self, 0x8246, world->value_583106 + rd32(world->table_5b3e40, o + 4));
    wr32(self, 0x824e, rd32(self, 0x8246) + (uint32_t)rds16(world->table_5b3ae8, p + 2) - 1u);
    wr32(self, 0x822e, 0);
    while ((int32_t)rd32(self, 0x822e) < 6) {
        uint32_t i = rd32(self, 0x822e);
        if (rd32(self, (ptrdiff_t)(int32_t)i * 0xf7 + 0x7012) != 0)
            call2(host, 0x4e22fd, (uintptr_t)(self + (ptrdiff_t)(int32_t)rd32(self, 0x822e) * 0x18f + 0x7654), rd16(self, 0x823a),
                  rd16(self, 0x823e));
        wr32(self, 0x822e, rd32(self, 0x822e) + 1u);
    }
    call0(host, 0x4e8bb4, (uintptr_t)self);
}

/* original GAME.EXE 0x4e444d (FUN_004e444d), stack arguments kind (signed word), out (a pointer to a word) and name (a string); `this` is
 * stored by the original and never used. For kind == 0: i = 0 while the signed i < the signed word 0x5a1e5e: when the string at
 * 0x5a2664 + i * 0x4a equals name, word [out] := i and the result is 1. For any other kind the same over 0x5a434c + i * 0x29 with the
 * count 0x5a1e60. When nothing matches word [out] := 0 and the result is 0. */
uint32_t m4e444d_find_name(int16_t kind, uint8_t *out, const uint8_t *name, const Fl19aWorld *world)
{
    uint16_t i;
    if (kind == 0) {
        for (i = 0; (int16_t)i < world->word_5a1e5e; i = (uint16_t)(i + 1)) {
            if (inline_strcmp(world->table_5a2664 + (ptrdiff_t)(int16_t)i * 0x4a, name) == 0) {
                wr16(out, 0, i);
                return 1;
            }
        }
    } else {
        for (i = 0; (int16_t)i < world->word_5a1e60; i = (uint16_t)(i + 1)) {
            if (inline_strcmp(world->table_5a434c + (ptrdiff_t)(int16_t)i * 0x29, name) == 0) {
                wr16(out, 0, i);
                return 1;
            }
        }
    }
    wr16(out, 0, 0);
    return 0;
}

/* original GAME.EXE 0x4b617a (FUN_004b617a), this = self: rec := the address in the record signed word [self+0x1e] of the table 0x5bb5e5
 * (stride 0x8d). Nothing unless dword [self+0x225] is non-zero, byte [self+0x22a] is 0, dword [self+0x274] is 0 and dword [record + 0x4d]
 * is 1. Dword 0x5c39e5 == 0x276d: byte [self+0x229] := 1 and dword [record+0x4d] := 2. Dword 0x5c39e5 == 0x276c: when 0x4f6334 on 0x5cf1eb
 * with the signed word [rec+0x2fa] returns non-zero nothing else happens; otherwise dword [self+0x274] := 2; for i < signed word [rec+0x21]
 * word [self + 0x232 + i * 2] := (i == signed word [self+0x252]); for i < 4: v := signed word [rec + sel * 8 + 0x254 + i * 2] with sel
 * the signed word [self+0x252], when v is non-zero word [self + 0x230 + v * 2] := 1; word [self+0x22c] := 1; when dword 0x5bb1ca is
 * non-zero and the nine bytes [rec+0x2d9] differ from the nine bytes at 0x551b18 calls 0x4fb2e3 on 0x5c3a67 with the word [rec+0x2fa]. */
void m4b617a_arm_piece(uint8_t *self, Fl19aWorld *world, const Fl18Host *host)
{
    ptrdiff_t recno = (ptrdiff_t)rds16(self, 0x1e) * 0x8d;
    const uint8_t *rec;
    int32_t i;
    if (rd32(self, 0x225) == 0) return;
    if (self[0x22a] != 0) return;
    if (rd32(self, 0x274) != 0) return;
    if (rd32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d + 0x4d) != 1) return;
    if (world->value_5c39e5 == 0x276d) {
        self[0x229] = 1;
        wr32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d + 0x4d, 2);
        return;
    }
    if (world->value_5c39e5 != 0x276c) return;
    rec = at(host, rd32(world->records_5bb5e5, recno));
    if (call1(host, 0x4f6334, 0x5cf1eb, (uint32_t)rds16(rec, 0x2fa)) != 0) return;
    wr32(self, 0x274, 2);
    for (i = 0; i < rds16(rec, 0x21); i++) {
        if (i == rds16(self, 0x252))
            wr16(self, (ptrdiff_t)i * 2 + 0x232, 1);
        else
            wr16(self, (ptrdiff_t)i * 2 + 0x232, 0);
    }
    for (i = 0; i < 4; i++) {
        int32_t v = rds16(rec + (ptrdiff_t)rds16(self, 0x252) * 8 + 0x254, (ptrdiff_t)i * 2);
        if (v != 0) wr16(self, (ptrdiff_t)v * 2 + 0x230, 1);
    }
    wr16(self, 0x22c, 1);
    if (world->value_5bb1ca != 0) {
        if (memcmp(rec + 0x2d9, world->bytes_551b18, 9) != 0) call1(host, 0x4fb2e3, 0x5c3a67, rd16(rec, 0x2fa));
    }
}

/* original GAME.EXE 0x4ccff5 (FUN_004ccff5), this = self: nothing when the dword [self+0x23e] is -1. When the dword [self+0x226] is
 * non-zero: for i < signed word [obj+0x23] (obj = the object at the dword [self+0x222]) the dword [arr + i * 0x35 + 0x31] (arr = the
 * array at the dword [self+0x226]) is freed through 0x51dc6c (cdecl) and cleared when non-zero; then arr itself is freed and [self+0x226]
 * := 0. The dword [self+0x22a] likewise (freed, cleared). With r = [self+0x23e] * 0x8d: the dword [0x5bb5e5 + r] is freed and cleared
 * when non-zero; dword [self+0x222] := 0; byte [0x5bb5e3 + r] := 0, byte [0x5bb625 + r] := 0, dword [0x5bb626 + r] := 0, [0x5bb632 + r]
 * := 0, word [0x5bb636 + r] := 0xffff, dword [0x5bb638 + r] := 1, [0x5bb63c + r] := 0; 0x423b51 on 0x63786d with [self+0x23e]; and
 * dword [self+0x23e] := -1. */
void m4ccff5_free_piece(uint8_t *self, Fl19aWorld *world, const Fl18Host *host)
{
    uint8_t *records = world->records_5bb5e5;
    ptrdiff_t r;
    int32_t i;
    if (rd32(self, 0x23e) == 0xffffffffu) return;
    if (rd32(self, 0x226) != 0) {
        for (i = 0; i < rds16(at(host, rd32(self, 0x222)), 0x23); i++) {
            if (rd32(at(host, rd32(self, 0x226)), (ptrdiff_t)i * 0x35 + 0x31) != 0) {
                uint32_t pointer = rd32(at(host, rd32(self, 0x226)), (ptrdiff_t)i * 0x35 + 0x31);
                call1(host, 0x51dc6c, 0, pointer);
                wr32(at(host, rd32(self, 0x226)), (ptrdiff_t)i * 0x35 + 0x31, 0);
            }
        }
        call1(host, 0x51dc6c, 0, rd32(self, 0x226));
        wr32(self, 0x226, 0);
    }
    if (rd32(self, 0x22a) != 0) {
        call1(host, 0x51dc6c, 0, rd32(self, 0x22a));
        wr32(self, 0x22a, 0);
    }
    r = (ptrdiff_t)(int32_t)(rd32(self, 0x23e) * 0x8du);
    if (rd32(records, r) != 0) {
        call1(host, 0x51dc6c, 0, rd32(records, (ptrdiff_t)(int32_t)(rd32(self, 0x23e) * 0x8du)));
        wr32(records, (ptrdiff_t)(int32_t)(rd32(self, 0x23e) * 0x8du), 0);
    }
    wr32(self, 0x222, 0);
    r = (ptrdiff_t)(int32_t)(rd32(self, 0x23e) * 0x8du);
    records[r - 2] = 0;
    r = (ptrdiff_t)(int32_t)(rd32(self, 0x23e) * 0x8du);
    records[r + 0x40] = 0;
    r = (ptrdiff_t)(int32_t)(rd32(self, 0x23e) * 0x8du);
    wr32(records, r + 0x41, 0);
    r = (ptrdiff_t)(int32_t)(rd32(self, 0x23e) * 0x8du);
    wr32(records, r + 0x4d, 0);
    r = (ptrdiff_t)(int32_t)(rd32(self, 0x23e) * 0x8du);
    wr16(records, r + 0x51, 0xffff);
    r = (ptrdiff_t)(int32_t)(rd32(self, 0x23e) * 0x8du);
    wr32(records, r + 0x53, 1);
    r = (ptrdiff_t)(int32_t)(rd32(self, 0x23e) * 0x8du);
    wr32(records, r + 0x57, 0);
    call1(host, 0x423b51, 0x63786d, rd32(self, 0x23e));
    wr32(self, 0x23e, 0xffffffffu);
}

/* original GAME.EXE 0x48d1e8 (FUN_0048d1e8), this = self, stack arguments x ([ebp+8], signed word) and y ([ebp+0xc], signed word): nothing
 * (result 0) when the dword [self+0x33] is 0. rec := the object at the address in the record signed word [self+0x1e]. When the byte
 * [self+0x26] is 0 and the dword [rec+0x7af] <= y <= [rec+0x7b7] and [rec+0x7ab] <= x <= [rec+0x7b3]: 0x48d3cb on self with (0x2766, 0)
 * and the result 1. For i < signed word [rec+0x21]: when [rec+i*16+0x207] <= y <= [..+0x20f] and [..+0x203] <= x <= [..+0x20b]: 0x48d3cb
 * on self with (0x2765, the word i) and the result 1. When the byte [self+0x26] is 0 the result is 0; otherwise for i < signed word
 * [rec+0x21]: when [rec+i*16+0x117] <= y <= [..+0x11f] and [..+0x113] <= x <= [..+0x11b] and i == signed word [self+0x27]: byte
 * [self+0x24] := 1 and the result 0. Otherwise the result is 0. */
uint32_t m48d1e8_hit_test(uint8_t *self, int16_t x, int16_t y, Fl19aWorld *world, const Fl18Host *host)
{
    const uint8_t *rec;
    int16_t i;
    if (rd32(self, 0x33) == 0) return 0;
    rec = at(host, rd32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d));
    if (self[0x26] == 0) {
        if (y >= (int32_t)rd32(rec, 0x7af) && y <= (int32_t)rd32(rec, 0x7b7) && x >= (int32_t)rd32(rec, 0x7ab) &&
            x <= (int32_t)rd32(rec, 0x7b3)) {
            call2(host, 0x48d3cb, (uintptr_t)self, 0x2766, 0);
            return 1;
        }
    }
    for (i = 0; i < rds16(rec, 0x21); i = (int16_t)(i + 1)) {
        ptrdiff_t e = (ptrdiff_t)i * 16;
        if (y >= (int32_t)rd32(rec, e + 0x207) && y <= (int32_t)rd32(rec, e + 0x20f) && x >= (int32_t)rd32(rec, e + 0x203) &&
            x <= (int32_t)rd32(rec, e + 0x20b)) {
            call2(host, 0x48d3cb, (uintptr_t)self, 0x2765, (uint16_t)i);
            return 1;
        }
    }
    if (self[0x26] == 0) return 0;
    for (i = 0; i < rds16(rec, 0x21); i = (int16_t)(i + 1)) {
        ptrdiff_t e = (ptrdiff_t)i * 16;
        if (y >= (int32_t)rd32(rec, e + 0x117) && y <= (int32_t)rd32(rec, e + 0x11f) && x >= (int32_t)rd32(rec, e + 0x113) &&
            x <= (int32_t)rd32(rec, e + 0x11b) && i == rds16(self, 0x27)) {
            self[0x24] = 1;
            return 0;
        }
    }
    return 0;
}

/* original GAME.EXE 0x475da4 (FUN_00475da4), this = self, stack arguments x ([ebp+8]) and y ([ebp+0xc]), signed words: result 0 when the
 * dword [self+0x89a] is 0 or the dword [self+0x2c] is 2. rec := the object at the address in the record signed word [self+0x22]. For
 * i < signed word [rec+0x42] and j < signed word [rec+0x44]: e := self + i * 0xc8 + 0x30 + j * 0x14; when [e+8] + 3 <= y <= [e+0x10] - 3
 * and [e+4] + 3 <= x <= [e+0xc] - 3: 0x475fb1 on self with 0x27d5, dword [self+0x8be] := i, dword [self+0x8ba] := j, result 1. Then
 * [rec+0x67c] <= y <= [rec+0x684] and [rec+0x678] <= x <= [rec+0x680]: 0x475fb1 with 0x27d7, result 1; then [rec+0x7e6] <= y <= [rec+0x7ee]
 * and [rec+0x7e2] <= x <= [rec+0x7ea]: 0x475fb1 with 0x27d6, result 1; otherwise 0. */
uint32_t m475da4_hit_test(uint8_t *self, int16_t x, int16_t y, Fl19aWorld *world, const Fl18Host *host)
{
    const uint8_t *rec;
    int16_t i, j;
    if (rd32(self, 0x89a) == 0) return 0;
    if (rd32(self, 0x2c) == 2) return 0;
    rec = at(host, rd32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x22) * 0x8d));
    for (i = 0; i < rds16(rec, 0x42); i = (int16_t)(i + 1)) {
        for (j = 0; j < rds16(rec, 0x44); j = (int16_t)(j + 1)) {
            const uint8_t *e = self + (ptrdiff_t)i * 0xc8 + 0x30 + (ptrdiff_t)j * 0x14;
            if (y >= (int32_t)(rd32(e, 8) + 3u) && y <= (int32_t)(rd32(e, 0x10) - 3u) && x >= (int32_t)(rd32(e, 4) + 3u) &&
                x <= (int32_t)(rd32(e, 0xc) - 3u)) {
                call1(host, 0x475fb1, (uintptr_t)self, 0x27d5);
                wr32(self, 0x8be, (uint32_t)(int32_t)i);
                wr32(self, 0x8ba, (uint32_t)(int32_t)j);
                return 1;
            }
        }
    }
    if (y >= (int32_t)rd32(rec, 0x67c) && y <= (int32_t)rd32(rec, 0x684) && x >= (int32_t)rd32(rec, 0x678) &&
        x <= (int32_t)rd32(rec, 0x680)) {
        call1(host, 0x475fb1, (uintptr_t)self, 0x27d7);
        return 1;
    }
    if (y >= (int32_t)rd32(rec, 0x7e6) && y <= (int32_t)rd32(rec, 0x7ee) && x >= (int32_t)rd32(rec, 0x7e2) &&
        x <= (int32_t)rd32(rec, 0x7ea)) {
        call1(host, 0x475fb1, (uintptr_t)self, 0x27d6);
        return 1;
    }
    return 0;
}

/* original GAME.EXE 0x4ee2a9 (FUN_004ee2a9), this = self: dwords 0x5b44f0 / 0x5b44f4 / 0x5d162d := 4 / 0 / dword 0x5d0377 when the dword
 * 0x5c39e9 is non-zero or the signed word 0x583a29 is -1; else 9 / 0 / 0x5d0377 when the dword 0x5b44f8 is non-zero; else (0x583a29 +
 * 0x25) / 0 / dword 0x571ad3. Then dword 0x5d1631 := 0x5b160c + (0x5b44f0 << 5) + (0x5b44f4 << 4), dword 0x5d1639 := 1. With o and p as
 * in m4e89eb_layout_slots: dword [self+4] := 0x583102 + dword[0x5b30cc + o]; [self+8] := 0x583106 + dword[0x5b30d0 + o]; dwords 0x5c3a5b
 * and 0x5c3a5f := those; [self+0xc] := 0x583102 + dword[0x5b3e40 + o]; [self+0x14] := [self+0xc] + signed word[0x5b3ae8 + p] - 1;
 * [self+0x10] := 0x583106 + dword[0x5b3e44 + o]; [self+0x18] := [self+0x10] + signed word[0x5b3aea + p] - 1. Result 0 unless the dword
 * [self+0x4af] is 2 or 3. When the dword [self+0x15f] is non-zero: 0x4e22fd on self + 0x31c with the words ([self+4], [self+8]), a non-zero
 * result is the result 1. When the dword [self+0x252] is non-zero: 0x4ef2d1 on self + 0x4b7 with the same words, a non-zero result is the
 * result 1. Otherwise 0. */
uint32_t m4ee2a9_hit_slots(uint8_t *self, Fl19aWorld *world, const Fl18Host *host)
{
    ptrdiff_t o, p;
    if (world->value_5c39e9 != 0) {
        world->value_5b44f0 = 4;
        world->value_5b44f4 = 0;
        world->value_5d162d = world->value_5d0377;
    } else if (world->word_583a29 == -1) {
        world->value_5b44f0 = 4;
        world->value_5b44f4 = 0;
        world->value_5d162d = world->value_5d0377;
    } else if (world->word_583a29 != -1 && world->value_5b44f8 != 0) {
        world->value_5b44f0 = 9;
        world->value_5b44f4 = 0;
        world->value_5d162d = world->value_5d0377;
    } else if (world->word_583a29 != -1 && world->value_5b44f8 == 0) {
        world->value_5b44f0 = (uint32_t)((int32_t)world->word_583a29 + 0x25);
        world->value_5b44f4 = 0;
        world->value_5d162d = world->value_571ad3;
    }
    world->value_5d1631 = hotspot_address(world);
    world->value_5d1639 = 1;
    o = dword_pair_offset(world);
    p = word_pair_offset(world);
    wr32(self, 4, world->value_583102 + rd32(world->table_5b30cc, o));
    wr32(self, 8, world->value_583106 + rd32(world->table_5b30cc, o + 4));
    world->value_5c3a5b = rd32(self, 4);
    world->value_5c3a5f = rd32(self, 8);
    wr32(self, 0xc, world->value_583102 + rd32(world->table_5b3e40, o));
    wr32(self, 0x14, rd32(self, 0xc) + (uint32_t)rds16(world->table_5b3ae8, p) - 1u);
    wr32(self, 0x10, world->value_583106 + rd32(world->table_5b3e40, o + 4));
    wr32(self, 0x18, rd32(self, 0x10) + (uint32_t)rds16(world->table_5b3ae8, p + 2) - 1u);
    if (rd32(self, 0x4af) != 2 && rd32(self, 0x4af) != 3) return 0;
    if (rd32(self, 0x15f) != 0) {
        if (call2(host, 0x4e22fd, (uintptr_t)(self + 0x31c), rd16(self, 4), rd16(self, 8)) != 0) return 1;
    }
    if (rd32(self, 0x252) != 0) {
        if (call2(host, 0x4ef2d1, (uintptr_t)(self + 0x4b7), rd16(self, 4), rd16(self, 8)) != 0) return 1;
    }
    return 0;
}

/* original GAME.EXE 0x48bd91 (FUN_0048bd91), this = self, stack arguments x ([ebp+8]) and y ([ebp+0xc]), signed words: rec := the object at
 * the address in the record signed word [self+0x26]. Result 0 when the byte [self+0x46] is 0. When [rec+0x152] <= y <= [rec+0x15a] and
 * [rec+0x14e] <= x <= [rec+0x156]: dwords 0x5b44f0 / 0x5b44f4 := 9 / 1, 0x5d162d := dword 0x5d0377, 0x5d1631 := the hotspot address,
 * 0x5d1639 := 1, 0x5c39e5 := 0x27a9, result 1. For i < 4 (signed word): word [self+0x28] := 0xffff, and when [rec+i*16+0x78] <= y <= [..+0x80]
 * and [..+0x74] <= x <= [..+0x7c]: signed word 0x583a29 != -1 and dword 0x5b44f8 == 0: 0x5b44f0 := 0x583a29 + 0x25 and 0x5d162d := dword
 * 0x571ad3; or 0x583a29 == -1 and 0x5b44f8 == 0: 0x5b44f0 := 0; then 0x5b44f4 := 1, 0x5d1631 := the hotspot address, 0x5d1639 := 1,
 * 0x5c39e5 := 0x27a7, word [self+0x28] := i, result 1. For i < signed word [rec+0x15e]: word [self+0x28] := 0xffff and when
 * [rec+i*0x12+0x166] + [rec+0x68] <= y <= [..+0x16e] + [rec+0x68] and [..+0x162] + [rec+0x64] <= x <= [..+0x16a] + [rec+0x64]: 0x5b44f0 /
 * 0x5b44f4 := 0 / 1, 0x5d1631, 0x5d1639 := 1, 0x5c39e5 := 0x27a8, word [self+0x28] := i, result 1. Otherwise 0. */
uint32_t m48bd91_hit_test(uint8_t *self, int16_t x, int16_t y, Fl19aWorld *world, const Fl18Host *host)
{
    const uint8_t *rec;
    int16_t i;
    if (self[0x46] == 0) return 0;
    rec = at(host, rd32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x26) * 0x8d));
    if (y >= (int32_t)rd32(rec, 0x152) && y <= (int32_t)rd32(rec, 0x15a) && x >= (int32_t)rd32(rec, 0x14e) &&
        x <= (int32_t)rd32(rec, 0x156)) {
        world->value_5b44f0 = 9;
        world->value_5b44f4 = 1;
        world->value_5d162d = world->value_5d0377;
        world->value_5d1631 = hotspot_address(world);
        world->value_5d1639 = 1;
        world->value_5c39e5 = 0x27a9;
        return 1;
    }
    for (i = 0; i < 4; i = (int16_t)(i + 1)) {
        ptrdiff_t e = (ptrdiff_t)i * 16;
        wr16(self, 0x28, 0xffff);
        if (y >= (int32_t)rd32(rec, e + 0x78) && y <= (int32_t)rd32(rec, e + 0x80) && x >= (int32_t)rd32(rec, e + 0x74) &&
            x <= (int32_t)rd32(rec, e + 0x7c)) {
            if (world->word_583a29 != -1 && world->value_5b44f8 == 0) {
                world->value_5b44f0 = (uint32_t)((int32_t)world->word_583a29 + 0x25);
                world->value_5d162d = world->value_571ad3;
            } else if (world->word_583a29 == -1 && world->value_5b44f8 == 0) {
                world->value_5b44f0 = 0;
            }
            world->value_5b44f4 = 1;
            world->value_5d1631 = hotspot_address(world);
            world->value_5d1639 = 1;
            world->value_5c39e5 = 0x27a7;
            wr16(self, 0x28, (uint16_t)i);
            return 1;
        }
    }
    for (i = 0; i < rds16(rec, 0x15e); i = (int16_t)(i + 1)) {
        ptrdiff_t e = (ptrdiff_t)i * 0x12;
        wr16(self, 0x28, 0xffff);
        if (y >= (int32_t)(rd32(rec, e + 0x166) + rd32(rec, 0x68)) && y <= (int32_t)(rd32(rec, e + 0x16e) + rd32(rec, 0x68)) &&
            x >= (int32_t)(rd32(rec, e + 0x162) + rd32(rec, 0x64)) && x <= (int32_t)(rd32(rec, e + 0x16a) + rd32(rec, 0x64))) {
            world->value_5b44f0 = 0;
            world->value_5b44f4 = 1;
            world->value_5d1631 = hotspot_address(world);
            world->value_5d1639 = 1;
            world->value_5c39e5 = 0x27a8;
            wr16(self, 0x28, (uint16_t)i);
            return 1;
        }
    }
    return 0;
}
