#include "original_methods_fl17.h"

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

/* original GAME.EXE 0x424035 (FUN_00424035), stack argument arg: when the dword [arg+0x24] is 0 returns -1, otherwise returns the
 * signed word at +0x12 of the object that dword addresses (sign-extended). */
int32_t m424035_selected_slot(const uint8_t *arg, const Fl17Host *host)
{
    uint32_t address = rd32(arg, 0x24);
    const uint8_t *object;
    if (address == 0) return -1;
    object = host->resolve(host->context, address);
    return (int16_t)rd16(object, 0x12);
}

/* original GAME.EXE 0x42405a (FUN_0042405a), stack argument arg: returns the dword [arg+0x30]. */
uint32_t m42405a_get_control(const uint8_t *arg)
{
    return rd32(arg, 0x30);
}

/* original GAME.EXE 0x42ca22 (FUN_0042ca22): nothing happens unless the dword 0x5b4ea5 (a table of 6-byte records) is non-null and
 * the signed word [[0x5b4ead] + 0x6d] is non-zero. Then for i = 0 while i < that word (re-read on every pass, signed): with
 * rec = 0x5b4ea5 table + i * 6, when the signed word [rec+2] is not -1 and the signed word [rec] equals the signed word 0x5b4e00,
 * the dword at 0x585801 + [rec+2] * 4 := the signed word [rec+4] sign-extended. */
void m42ca22_apply_event_flags(const Fl17World *world)
{
    int32_t i;
    if (world->table_5b4ea5 == NULL) return;
    if ((int16_t)rd16(world->owner_5b4ead, 0x6d) == 0) return;
    for (i = 0; i < (int16_t)rd16(world->owner_5b4ead, 0x6d); i++) {
        const uint8_t *rec = world->table_5b4ea5 + (ptrdiff_t)i * 6;
        if ((int16_t)rd16(rec, 2) == -1) continue;
        if ((int16_t)rd16(rec, 0) != world->key_5b4e00) continue;
        wr32(world->flags_585801, (ptrdiff_t)(int16_t)rd16(rec, 2) * 4, (uint32_t)(int32_t)(int16_t)rd16(rec, 4));
    }
}

/* original GAME.EXE 0x4d36ed (FUN_004d36ed): dword [0x5831c8] := 1; word [0x5831c6] := 0. */
void m4d36ed_set_flags(Fl17World *world)
{
    world->value_5831c8 = 1;
    world->value_5831c6 = 0;
}

/* original GAME.EXE 0x4cd218 (FUN_004cd218): calls 0x4ccef1, 0x4ccfbd (FL-16), 0x4ccff5 and 0x4ccdab on self, in that order. */
void m4cd218_destruct(uint8_t *self, const Fl17Host *host)
{
    if (host->call_4ccef1 != NULL) host->call_4ccef1(host->context, self);
    if (host->fl16 != NULL) m4ccfbd_release_surface(self, host->fl16);
    if (host->call_4ccff5 != NULL) host->call_4ccff5(host->context, self);
    if (host->call_4ccdab != NULL) host->call_4ccdab(host->context, self);
}

/* original GAME.EXE 0x4fba69 (FUN_004fba69), this = self, stack argument arg: calls 0x4fc808 on self with the word [arg+0x21]. */
void m4fba69_forward_word(uint8_t *self, const uint8_t *arg, const Fl17Host *host)
{
    if (host->call_4fc808 != NULL) host->call_4fc808(host->context, self, rd16(arg, 0x21));
}

/* original GAME.EXE 0x4fc05d (FUN_004fc05d), this = self: calls 0x4fc808 on self with the word at 0x5b451f. */
void m4fc05d_forward_global(uint8_t *self, const Fl17World *world, const Fl17Host *host)
{
    if (host->call_4fc808 != NULL) host->call_4fc808(host->context, self, world->value_5b451f);
}

/* original GAME.EXE 0x4e303b (FUN_004e303b), this = self: calls 0x4edb97 and 0x4e2faa on self; dword [0x583204] := 0; 0x4d36ed;
 * dword [0x5bb22a] := 0; word [self+0x6b2] := 0x270f; when the dword 0x5d039f is non-zero, releases it through 0x4c2dfb on the
 * surface manager 0x5cf659 (the dword itself is the slot argument). */
void m4e303b_close(uint8_t *self, Fl17World *world, const Fl17Host *host)
{
    if (host->call_4edb97 != NULL) host->call_4edb97(host->context, self);
    if (host->call_4e2faa != NULL) host->call_4e2faa(host->context, self);
    world->value_583204 = 0;
    m4d36ed_set_flags(world);
    world->value_5bb22a = 0;
    wr16(self, 0x6b2, 0x270f);
    if (world->slot_5d039f != 0 && host->release_surface != NULL)
        host->release_surface(host->context, (uint8_t *)&world->slot_5d039f);
}

/* original GAME.EXE 0x4e7d04 (FUN_004e7d04), this = self: calls 0x4edb97 and 0x4e7bf3 on self; dword [0x583204] := 0; 0x4d36ed. */
void m4e7d04_close(uint8_t *self, Fl17World *world, const Fl17Host *host)
{
    if (host->call_4edb97 != NULL) host->call_4edb97(host->context, self);
    if (host->call_4e7bf3 != NULL) host->call_4e7bf3(host->context, self);
    world->value_583204 = 0;
    m4d36ed_set_flags(world);
}

/* original GAME.EXE 0x4eb96e (FUN_004eb96e), this = self: calls 0x4edb97 and 0x4eba54 on self; dword [0x583204] := 0; 0x4d36ed;
 * then releases the dwords 0x5d03a3 and 0x5d03a7 (in that order, each only when non-zero) through 0x4c2dfb. */
void m4eb96e_close(uint8_t *self, Fl17World *world, const Fl17Host *host)
{
    if (host->call_4edb97 != NULL) host->call_4edb97(host->context, self);
    if (host->call_4eba54 != NULL) host->call_4eba54(host->context, self);
    world->value_583204 = 0;
    m4d36ed_set_flags(world);
    if (world->slot_5d03a3 != 0 && host->release_surface != NULL)
        host->release_surface(host->context, (uint8_t *)&world->slot_5d03a3);
    if (world->slot_5d03a7 != 0 && host->release_surface != NULL)
        host->release_surface(host->context, (uint8_t *)&world->slot_5d03a7);
}

/* original GAME.EXE 0x4caf8a (FUN_004caf8a), this = self: calls 0x4cbb00 on self; when the signed word [self+0xc] is not -1 calls
 * 0x4d3992 (cdecl) with that word; then calls 0x4caf03 on self. */
void m4caf8a_reset(uint8_t *self, const Fl17Host *host)
{
    if (host->call_4cbb00 != NULL) host->call_4cbb00(host->context, self);
    if ((int16_t)rd16(self, 0xc) != -1 && host->call_4d3992 != NULL) host->call_4d3992(host->context, rd16(self, 0xc));
    if (host->call_4caf03 != NULL) host->call_4caf03(host->context, self);
}

/* original GAME.EXE 0x4cf749 (FUN_004cf749): returns when the dword 0x638433 is 0; the four locals it then fills (addresses
 * 0x638225, 0x6383ff, 0x63840f, 0x583122) are never read. When the dword 0x638423 is non-zero it calls 0x4c5377 on the object
 * 0x5cf659 with the five arguments dword 0x5d1a39, dword 0x5cf665, dword 0x5d1a3d, dword 0x5d1a41, 0x559d94 (first to last). */
void m4cf749_notify(const Fl17World *world, const Fl17Host *host)
{
    if (world->value_638433 == 0) return;
    if (world->value_638423 == 0) return;
    if (host->call_4c5377 != NULL)
        host->call_4c5377(host->context, world->value_5d1a39, world->value_5cf665, world->value_5d1a3d, world->value_5d1a41,
                          0x559d94u);
}

/* original GAME.EXE 0x48c0ac (FUN_0048c0ac), this = self: rec = 0x5bb5e5-based record of stride 0x8d at the signed word [self+0x26],
 * obj = the dword at rec+0 (read once, first). When the dword 0x5c39e5 is 0x27a9: byte [self+0x47] := 1; dword rec+0x4d := 2.
 * Otherwise, when it is 0x27a8: word [self+0x54] := the word at obj + [self+0x28] * 0x12 + 0x160 (signed word index), then
 * dword rec+0x4d := 2 (rec taken again from [self+0x26]). Always: byte [self+0x1c] := 0xff; byte [self+0x40] := 0. */
void m48c0ac_accept_piece(uint8_t *self, const Fl17World *world, const Fl17Host *host)
{
    uint32_t object = rd32(world->records_5bb5e5, (ptrdiff_t)(int16_t)rd16(self, 0x26) * 0x8d);
    if (world->value_5c39e5 == 0x27a9u) {
        self[0x47] = 1;
        wr32(world->records_5bb5e5, (ptrdiff_t)(int16_t)rd16(self, 0x26) * 0x8d + 0x4d, 2);
    } else if (world->value_5c39e5 == 0x27a8u) {
        const uint8_t *obj = host->resolve(host->context, object);
        wr16(self, 0x54, rd16(obj, (ptrdiff_t)(int16_t)rd16(self, 0x28) * 0x12 + 0x160));
        wr32(world->records_5bb5e5, (ptrdiff_t)(int16_t)rd16(self, 0x26) * 0x8d + 0x4d, 2);
    }
    self[0x1c] = 0xff;
    self[0x40] = 0;
}

/* original GAME.EXE 0x415011 (FUN_00415011), stack argument arg (this is not used): when the dword [arg+0x21] is non-zero calls
 * 0x51dc6c (cdecl) with it and clears it; byte [arg+0x4d] := 0; when the dword [arg+0x2d] is non-zero calls UnmapViewOfFile with it
 * and clears it; when [arg+0x29] is non-zero calls CloseHandle with it and clears it; same for [arg+0x25]. */
void m415011_close_handles(uint8_t *arg, const Fl17Host *host)
{
    if (rd32(arg, 0x21) != 0) {
        if (host->free_51dc6c != NULL) host->free_51dc6c(host->context, rd32(arg, 0x21));
        wr32(arg, 0x21, 0);
    }
    arg[0x4d] = 0;
    if (rd32(arg, 0x2d) != 0) {
        if (host->unmap_view != NULL) host->unmap_view(host->context, rd32(arg, 0x2d));
        wr32(arg, 0x2d, 0);
    }
    if (rd32(arg, 0x29) != 0) {
        if (host->close_handle != NULL) host->close_handle(host->context, rd32(arg, 0x29));
        wr32(arg, 0x29, 0);
    }
    if (rd32(arg, 0x25) != 0) {
        if (host->close_handle != NULL) host->close_handle(host->context, rd32(arg, 0x25));
        wr32(arg, 0x25, 0);
    }
}

/* original GAME.EXE 0x4eac4c (FUN_004eac4c), this = self, stack argument index (signed word): w = the word at the object that the
 * dword of the 0x5bb5e5-based record `index` (stride 0x8d) addresses; calls 0x4ea06c on self with w; when the signed word 0x583a29
 * equals w (signed) it is set to 0xffff; byte rec+0x40 := 1. */
void m4eac4c_use_item(uint8_t *self, int16_t index, Fl17World *world, const Fl17Host *host)
{
    uint16_t w = rd16(host->resolve(host->context, rd32(world->records_5bb5e5, (ptrdiff_t)index * 0x8d)), 0);
    if (host->call_4ea06c != NULL) host->call_4ea06c(host->context, self, w);
    if (world->value_583a29 == (int16_t)w) world->value_583a29 = -1;
    world->records_5bb5e5[(ptrdiff_t)index * 0x8d + 0x40] = 1;
}

/* original GAME.EXE 0x48d067 (FUN_0048d067): words [self+0x1e], [self+0x1c] := 0xffff; dword [self+0x33] := 0; bytes [self+0x37],
 * [self+0x38] := 0. */
void m48d067_cleanup(uint8_t *self)
{
    wr16(self, 0x1e, 0xffff);
    wr16(self, 0x1c, 0xffff);
    wr32(self, 0x33, 0);
    self[0x37] = 0;
    self[0x38] = 0;
}

/* original GAME.EXE 0x461827 (FUN_00461827): words [self+0x1e], [self+0x1c] := 0xffff; dwords [self+0x3f], [self+0x43],
 * [self+0x47] := 0. */
void m461827_cleanup(uint8_t *self)
{
    wr16(self, 0x1e, 0xffff);
    wr16(self, 0x1c, 0xffff);
    wr32(self, 0x3f, 0);
    wr32(self, 0x43, 0);
    wr32(self, 0x47, 0);
}

/* original GAME.EXE 0x4b5b8a (FUN_004b5b8a): words [self+0x1e], [self+0x1c] := 0xffff; dword [self+0x225] := 0; bytes [self+0x229],
 * [self+0x22a] := 0. */
void m4b5b8a_cleanup(uint8_t *self)
{
    wr16(self, 0x1e, 0xffff);
    wr16(self, 0x1c, 0xffff);
    wr32(self, 0x225, 0);
    self[0x229] = 0;
    self[0x22a] = 0;
}

/* original GAME.EXE 0x45b3ea (FUN_0045b3ea): words [self+0x1e], [self+0x1c] := 0xffff; dwords [self+0x166], [self+0x16a],
 * [self+0x162] := 0. */
void m45b3ea_cleanup(uint8_t *self)
{
    wr16(self, 0x1e, 0xffff);
    wr16(self, 0x1c, 0xffff);
    wr32(self, 0x166, 0);
    wr32(self, 0x16a, 0);
    wr32(self, 0x162, 0);
}

/* original GAME.EXE 0x483f6a (FUN_00483f6a): words [self+0x26], [self+0x1c] := 0xffff; dword [self+0xba7] := 0; bytes [self+0xbab],
 * [self+0xbb0] := 0; dword [self+0xa92] := 0. */
void m483f6a_cleanup(uint8_t *self)
{
    wr16(self, 0x26, 0xffff);
    wr16(self, 0x1c, 0xffff);
    wr32(self, 0xba7, 0);
    self[0xbab] = 0;
    self[0xbb0] = 0;
    wr32(self, 0xa92, 0);
}

/* original GAME.EXE 0x44d107 (FUN_0044d107): words [self+0x1e], [self+0x1c] := 0xffff; dword [self+0x25] := 0; bytes [self+0x49],
 * [self+0x4a] := 0; then, when 0x4d3c31 on the object 0x61c387 (FL-16) returns non-zero, 0x4d3d20 (FL-16) on it. */
void m44d107_cleanup(uint8_t *self, const Fl17World *world, const Fl17Host *host)
{
    wr16(self, 0x1e, 0xffff);
    wr16(self, 0x1c, 0xffff);
    wr32(self, 0x25, 0);
    self[0x49] = 0;
    self[0x4a] = 0;
    if (m4d3c31_get_1c(world->object_61c387) != 0) m4d3d20_stamp_tick(world->object_61c387, host->fl16);
}

/* original GAME.EXE 0x44d154 (FUN_0044d154), this = self: when the dword [self+0x20] is non-zero releases the slot self+0x20
 * through 0x4c2dfb on the surface manager 0x5cf659; when the signed word [self+0x1c] is not -1 calls 0x4d3992 (cdecl) with it;
 * then calls 0x44d107 on self. */
void m44d154_begin_scene(uint8_t *self, const Fl17World *world, const Fl17Host *host)
{
    if (rd32(self, 0x20) != 0 && host->release_surface != NULL) host->release_surface(host->context, self + 0x20);
    if ((int16_t)rd16(self, 0x1c) != -1 && host->call_4d3992 != NULL) host->call_4d3992(host->context, rd16(self, 0x1c));
    m44d107_cleanup(self, world, host);
}

/* original GAME.EXE 0x45b42e (FUN_0045b42e), this = self: same shape as 0x44d154: release the slot self+0x20 when [self+0x20] is
 * non-zero; 0x4d3992 with the word [self+0x1c] when it is not -1; then 0x45b3ea on self. */
void m45b42e_begin_scene(uint8_t *self, const Fl17Host *host)
{
    if (rd32(self, 0x20) != 0 && host->release_surface != NULL) host->release_surface(host->context, self + 0x20);
    if ((int16_t)rd16(self, 0x1c) != -1 && host->call_4d3992 != NULL) host->call_4d3992(host->context, rd16(self, 0x1c));
    m45b3ea_cleanup(self);
}

/* original GAME.EXE 0x461862 (FUN_00461862), this = self: same shape as 0x44d154, ending in 0x461827 on self. */
void m461862_begin_scene(uint8_t *self, const Fl17Host *host)
{
    if (rd32(self, 0x20) != 0 && host->release_surface != NULL) host->release_surface(host->context, self + 0x20);
    if ((int16_t)rd16(self, 0x1c) != -1 && host->call_4d3992 != NULL) host->call_4d3992(host->context, rd16(self, 0x1c));
    m461827_cleanup(self);
}

/* original GAME.EXE 0x48d09c (FUN_0048d09c), this = self: same shape as 0x44d154, ending in 0x48d067 on self. */
void m48d09c_begin_scene(uint8_t *self, const Fl17Host *host)
{
    if (rd32(self, 0x20) != 0 && host->release_surface != NULL) host->release_surface(host->context, self + 0x20);
    if ((int16_t)rd16(self, 0x1c) != -1 && host->call_4d3992 != NULL) host->call_4d3992(host->context, rd16(self, 0x1c));
    m48d067_cleanup(self);
}

/* original GAME.EXE 0x4b5bc8 (FUN_004b5bc8), this = self: same shape as 0x44d154, ending in 0x4b5b8a on self. */
void m4b5bc8_begin_scene(uint8_t *self, const Fl17Host *host)
{
    if (rd32(self, 0x20) != 0 && host->release_surface != NULL) host->release_surface(host->context, self + 0x20);
    if ((int16_t)rd16(self, 0x1c) != -1 && host->call_4d3992 != NULL) host->call_4d3992(host->context, rd16(self, 0x1c));
    m4b5b8a_cleanup(self);
}

/* original GAME.EXE 0x47591f (FUN_0047591f): dword [0x5a0545] := 0; then for the signed word i = 0..4 the dword [0x5a0549 + i * 4]
 * := 0. */
void m47591f_clear_block(Fl17World *world)
{
    int16_t i;
    wr32(world->block_5a0545, 0, 0);
    for (i = 0; i < 5; i++) wr32(world->block_5a0545, 4 + (ptrdiff_t)i * 4, 0);
}
