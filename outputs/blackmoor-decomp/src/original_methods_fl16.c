#include "original_methods_fl16.h"

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

/* original GAME.EXE 0x4234c8 (FUN_004234c8): [self+4] := 0 (the evaluation-stack depth of the condition evaluator). */
void m4234c8_depth_reset(uint8_t *self)
{
    wr32(self, 4, 0);
}

/* original GAME.EXE 0x423000 (FUN_00423000): [self+0] := 0; [self+0x25] := 0; returns self. */
uint8_t *m423000_init_pair(uint8_t *self)
{
    wr32(self, 0, 0);
    wr32(self, 0x25, 0);
    return self;
}

/* original GAME.EXE 0x423097 (FUN_00423097): zeroes the 0x400 dwords at self (4096 bytes); returns self. */
uint8_t *m423097_clear_table(uint8_t *self)
{
    int32_t i;
    for (i = 0; i < 0x400; i++) wr32(self, (ptrdiff_t)i * 4, 0);
    return self;
}

/* original GAME.EXE 0x47d77d (FUN_0047d77d): an empty method. */
void m47d77d_noop(void)
{
}

/* original GAME.EXE 0x4ee5cd (FUN_004ee5cd): returns the global dword at 0x55cd94. */
uint32_t m4ee5cd_get_global(const Fl16World *world)
{
    return world->value_55cd94;
}

/* original GAME.EXE 0x4f709c (FUN_004f709c): returns [self+0x1a0] (the device-ready dword). */
uint32_t m4f709c_get_ready(const uint8_t *self)
{
    return rd32(self, 0x1a0);
}

/* original GAME.EXE 0x4edf96 (FUN_004edf96): [self+0x4b3] := value. */
void m4edf96_set_value(uint8_t *self, uint32_t value)
{
    wr32(self, 0x4b3, value);
}

/* original GAME.EXE 0x493a47 (FUN_00493a47): returns 0. */
uint32_t m493a47_zero(void)
{
    return 0;
}

/* original GAME.EXE 0x434773 (FUN_00434773): 1 when the four bytes at text are 'D' 'A' 'T' 'A' (compared as signed chars), else 0. */
uint32_t m434773_is_data_tag(const uint8_t *text)
{
    return ((int8_t)text[0] == 'D' && (int8_t)text[1] == 'A' && (int8_t)text[2] == 'T' && (int8_t)text[3] == 'A') ? 1u : 0u;
}

/* original GAME.EXE 0x4347b8 (FUN_004347b8): the four bytes at bytes as a big-endian dword. */
uint32_t m4347b8_read_be32(const uint8_t *bytes)
{
    return ((uint32_t)bytes[0] << 24) | ((uint32_t)bytes[1] << 16) | ((uint32_t)bytes[2] << 8) | (uint32_t)bytes[3];
}

/* original GAME.EXE 0x43f04b (FUN_0043f04b): for each of `rows` (a signed count; none when <= 0) copies row_bytes bytes from
 * src to dst, dwords first and then the remaining row_bytes & 3 bytes (rep movsd, rep movsb: forward, in that order), then
 * advances src by src_stride and dst by row_bytes (the destination rows are packed). */
void m43f04b_copy_rows(uint8_t *dst, const uint8_t *src, int32_t rows, uint32_t row_bytes, int32_t src_stride)
{
    int32_t row;
    for (row = 0; row < rows; row++) {
        uint32_t n;
        uint8_t *d = dst;
        const uint8_t *s = src;
        for (n = row_bytes >> 2; n != 0; n--) {
            uint8_t tmp[4];
            memcpy(tmp, s, 4);
            memcpy(d, tmp, 4);
            s += 4;
            d += 4;
        }
        for (n = row_bytes & 3u; n != 0; n--) *d++ = *s++;
        src += src_stride;
        dst += row_bytes;
    }
}

static void shift_rect(const int32_t *src, int32_t *dst, const Fl16World *world)
{
    dst[1] = (int32_t)((uint32_t)src[1] + (uint32_t)world->origin_y_58318a);
    dst[3] = (int32_t)((uint32_t)src[3] + (uint32_t)world->origin_y_58318a);
    dst[0] = (int32_t)((uint32_t)src[0] + (uint32_t)world->origin_x_583186);
    dst[2] = (int32_t)((uint32_t)src[2] + (uint32_t)world->origin_x_583186);
}

/* original GAME.EXE 0x44d9b5 (FUN_0044d9b5): dst[1] := src[1] + [0x58318a]; dst[3] := src[3] + [0x58318a]; dst[0] := src[0] +
 * [0x583186]; dst[2] := src[2] + [0x583186] (dwords: a rectangle shifted by the view origin). */
void m44d9b5_shift_rect(const int32_t *src, int32_t *dst, const Fl16World *world)
{
    shift_rect(src, dst, world);
}

/* original GAME.EXE 0x45b568 (FUN_0045b568): the same rectangle shift as 0x44d9b5 (a second copy of it in the 0xda family). */
void m45b568_shift_rect(const int32_t *src, int32_t *dst, const Fl16World *world)
{
    shift_rect(src, dst, world);
}

/* original GAME.EXE 0x47e25a (FUN_0047e25a): word [self+0x1e] := 0xffff; word [self+0x1c] := 0xffff; dword [self+0x13c5] := 0;
 * byte [self+0x13c9] := 0; byte [self+0x13ce] := 0; dword [self+0x1344] := 0. */
void m47e25a_reset_fields(uint8_t *self)
{
    wr16(self, 0x1e, 0xffff);
    wr16(self, 0x1c, 0xffff);
    wr32(self, 0x13c5, 0);
    self[0x13c9] = 0;
    self[0x13ce] = 0;
    wr32(self, 0x1344, 0);
}

/* original GAME.EXE 0x4bedb5 (FUN_004bedb5): dwords [self+0xbc], [self+0x2c0] and [self+0x2c4] := 0. */
void m4bedb5_clear_state(uint8_t *self)
{
    wr32(self, 0xbc, 0);
    wr32(self, 0x2c0, 0);
    wr32(self, 0x2c4, 0);
}

/* original GAME.EXE 0x4bede7 (FUN_004bede7): calls 0x4bedb5 on self. */
void m4bede7_clear_state(uint8_t *self)
{
    m4bedb5_clear_state(self);
}

/* original GAME.EXE 0x4bedfa (FUN_004bedfa): when *handle != 0 calls BinkClose(*handle) and sets *handle := 0; then calls
 * 0x4bedb5 on self. */
void m4bedfa_close_and_clear(uint8_t *self, uint32_t *handle, const Fl16Host *host)
{
    if (*handle != 0) {
        if (host->bink_close != NULL) host->bink_close(host->context, *handle);
        *handle = 0;
    }
    m4bedb5_clear_state(self);
}

/* original GAME.EXE 0x4bf38c (FUN_004bf38c): dword [self+0x2c0] := 0. */
void m4bf38c_clear_2c0(uint8_t *self)
{
    wr32(self, 0x2c0, 0);
}

/* original GAME.EXE 0x4c0c18 (FUN_004c0c18): returns dword [self+0x22a]. */
uint32_t m4c0c18_get_22a(const uint8_t *self)
{
    return rd32(self, 0x22a);
}

/* original GAME.EXE 0x4c0c2c (FUN_004c0c2c): returns dword [self+0x240]. */
uint32_t m4c0c2c_get_240(const uint8_t *self)
{
    return rd32(self, 0x240);
}

/* original GAME.EXE 0x4c0c54 (FUN_004c0c54): returns the signed word [self+0x244] sign-extended to 32 bits. */
int32_t m4c0c54_get_244(const uint8_t *self)
{
    return (int32_t)(int16_t)rd16(self, 0x244);
}

/* original GAME.EXE 0x4c0c69 (FUN_004c0c69): returns dword [self+0x24a]. */
uint32_t m4c0c69_get_24a(const uint8_t *self)
{
    return rd32(self, 0x24a);
}

/* original GAME.EXE 0x4d3c31 (FUN_004d3c31): returns dword [self+0x1c]. */
uint32_t m4d3c31_get_1c(const uint8_t *self)
{
    return rd32(self, 0x1c);
}

/* original GAME.EXE 0x4e76d5 (FUN_004e76d5): dword [self+0x991] := 0. */
void m4e76d5_clear_991(uint8_t *self)
{
    wr32(self, 0x991, 0);
}

/* original GAME.EXE 0x4e76ed (FUN_004e76ed): calls 0x4e76d5 on self. */
void m4e76ed_clear_991(uint8_t *self)
{
    m4e76d5_clear_991(self);
}

/* original GAME.EXE 0x4e7ba7 (FUN_004e7ba7): dwords [self+0x764c] := 0, [self+0x7650] := 0, [self+0x8232] := 0xffffffff,
 * [self+0x8236] := 0xffffffff, [self+0x8252] := 0 (the inventory view reset). */
void m4e7ba7_view_reset(uint8_t *self)
{
    wr32(self, 0x764c, 0);
    wr32(self, 0x7650, 0);
    wr32(self, 0x8232, 0xffffffffu);
    wr32(self, 0x8236, 0xffffffffu);
    wr32(self, 0x8252, 0);
}

/* original GAME.EXE 0x42e560 (FUN_0042e560): copies the scene-restore globals into the block at 0x5c3a05: word 0x5c3a05 :=
 * word [0x5bb57b]; word 0x5c3a07 := word [0x5bb57f]; word 0x5c3a09 := word [0x5bb50b]; word 0x5c3a0b := word [0x5bb593];
 * word 0x5c3a0d := value; dword 0x5c3a0f := dword [0x5bb5a7]; dword 0x5c3a13 := dword [0x5bb5ab] and then, the same address
 * again, := dword [0x5bb5af] (the second store wins). */
void m42e560_save_block(Fl16World *world, uint16_t value)
{
    uint8_t *block = world->block_5c3a05;
    wr16(block, 0, (uint16_t)world->src_5bb57b);
    wr16(block, 2, (uint16_t)world->src_5bb57f);
    wr16(block, 4, (uint16_t)world->src_5bb50b);
    wr16(block, 6, (uint16_t)world->src_5bb593);
    wr16(block, 8, value);
    wr32(block, 0xa, world->src_5bb5a7);
    wr32(block, 0xe, world->src_5bb5ab);
    wr32(block, 0xe, world->src_5bb5af);
}

/* original GAME.EXE 0x4d3d20 (FUN_004d3d20): dword [self+0x456] := GetTickCount() - 5 (32-bit wrap). */
void m4d3d20_stamp_tick(uint8_t *self, const Fl16Host *host)
{
    uint32_t now = host->tick != NULL ? host->tick(host->context) : 0;
    wr32(self, 0x456, now - 5u);
}

/* original GAME.EXE 0x4b8e42 (FUN_004b8e42): with slot a signed word, when GetTickCount() >= the dword at 0x61eee1 + slot * 0x37
 * (unsigned compare): dword [self + slot * 0x37 + 0x7d] := 3, word [self+0x48] -= 1, then calls 0x4b8a27 on self with 2. */
void m4b8e42_expire_slot(uint8_t *self, int16_t slot, const Fl16World *world, const Fl16Host *host)
{
    uint32_t now = host->tick != NULL ? host->tick(host->context) : 0;
    ptrdiff_t stride = (ptrdiff_t)slot * 0x37;
    if (now < rd32(world->deadlines_61eee1, stride)) return;
    wr32(self, stride + 0x7d, 3);
    wr16(self, 0x48, (uint16_t)(rd16(self, 0x48) - 1u));
    if (host->call_4b8a27 != NULL) host->call_4b8a27(host->context, self, 2);
}

/* original GAME.EXE 0x4d3c42 (FUN_004d3c42): dword [self+0x1c] := 1, then calls 0x4d3bef on self. */
void m4d3c42_set_flag(uint8_t *self, const Fl16Host *host)
{
    wr32(self, 0x1c, 1);
    if (host->call_4d3bef != NULL) host->call_4d3bef(host->context, self);
}

/* original GAME.EXE 0x4e7786 (FUN_004e7786): calls 0x4edfaf on self with arg (a forwarding method). */
void m4e7786_forward(uint8_t *self, uint32_t arg, const Fl16Host *host)
{
    if (host->call_4edfaf != NULL) host->call_4edfaf(host->context, self, arg);
}

/* original GAME.EXE 0x4faf98 (FUN_004faf98): calls 0x4fadc4 on self with arg1 and the word arg2; when it returns non-zero calls
 * 0x4fb2e3 on self with the word arg2. */
void m4faf98_visit(uint8_t *self, uintptr_t arg1, uint16_t arg2, const Fl16Host *host)
{
    int32_t found = host->call_4fadc4 != NULL ? host->call_4fadc4(host->context, self, arg1, arg2) : 0;
    if (found != 0 && host->call_4fb2e3 != NULL) host->call_4fb2e3(host->context, self, arg2);
}

/* original GAME.EXE 0x4ccfbd (FUN_004ccfbd): when dword [self+0x212] != 0 releases it through 0x4c2dfb on the surface manager
 * (0x5cf659) with the address self+0x212, then sets dword [self+0x212] := 0. */
void m4ccfbd_release_surface(uint8_t *self, const Fl16Host *host)
{
    if (rd32(self, 0x212) != 0) {
        if (host->release_surface != NULL) host->release_surface(host->context, self + 0x212);
        wr32(self, 0x212, 0);
    }
}

/* original GAME.EXE 0x4ccd70 (FUN_004ccd70): dword [self+0] := 0x52e2d0 (the vtable pointer), calls 0x4ccdab on self, returns
 * self. */
uint8_t *m4ccd70_construct(uint8_t *self, const Fl16Host *host)
{
    wr32(self, 0, FL16_VTABLE_52E2D0);
    if (host->call_4ccdab != NULL) host->call_4ccdab(host->context, self);
    return self;
}

/* original GAME.EXE 0x4e7728 (FUN_004e7728): calls 0x43dbd5 and 0x4d36ed, stores dword [self+0x991] := value, then calls
 * 0x4edf96 on self with value. */
void m4e7728_open(uint8_t *self, uint32_t value, const Fl16Host *host)
{
    if (host->call_43dbd5 != NULL) host->call_43dbd5(host->context);
    if (host->call_4d36ed != NULL) host->call_4d36ed(host->context);
    wr32(self, 0x991, value);
    m4edf96_set_value(self, value);
}

/* original GAME.EXE 0x4e7757 (FUN_004e7757): dword [self+0x991] := 1, calls 0x4e76ed on self (which clears it again), calls
 * 0x4d36ed, then dword [0x583204] := 0. */
void m4e7757_close(uint8_t *self, const Fl16Host *host, Fl16World *world)
{
    wr32(self, 0x991, 1);
    m4e76ed_clear_991(self);
    if (host->call_4d36ed != NULL) host->call_4d36ed(host->context);
    world->value_583204 = 0;
}
