#include "original_methods_fl38c.h"

#include <string.h>

static uint32_t rd32(const uint8_t *p)
{
    uint32_t v;
    memcpy(&v, p, sizeof v);
    return v;
}

static void wr32(uint8_t *p, uint32_t v)
{
    memcpy(p, &v, sizeof v);
}

static int32_t rds16(const uint8_t *p)
{
    int16_t v;
    memcpy(&v, p, sizeof v);
    return v;
}

/* host memory behind an original address (the host owns it; the interface only says const) */
static uint8_t *res(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

/* the first half shared by read_word_setting and read_time_setting: 0x51d5b2 (thiscall on self + off) reads 0x13 bytes into the local, 0x50cb1b (cdecl) converts it; returns its eax */
static uint32_t read_and_convert(uint8_t *self, const Fl18Host *host, uint32_t off)
{
    uint8_t text[0x14];            /* [ebp-0x14] of the original: 0x13 bytes are written by the first callee */
    uintptr_t two[2], one[1];
    two[0] = (uintptr_t)text;      /* pushed last, so the first argument; the count 0x13 was pushed first */
    two[1] = 0x13;
    callv(host, 0x51d5b2, (uintptr_t)(self + off), two, 2);
    one[0] = (uintptr_t)text;
    return callv(host, 0x50cb1b, 0, one, 1);
}

static uint32_t call_on_self(uint8_t *self, const Fl18Host *host, uint32_t callee)
{
    return callv(host, callee, (uintptr_t)self, NULL, 0);
}

/* read_word_setting: the low word of the conversion goes to a word global, then a method of self is called */
static uint32_t read_word_setting(uint8_t *self, const Fl18Host *host, uint32_t off, uint16_t *target, uint32_t callee)
{
    *target = (uint16_t)read_and_convert(self, host, off);
    return call_on_self(self, host, callee);
}

/* read_time_setting: the entry [0x5c3a63] of the table at 0x5e569e (stride 0x106) is addressed again for every access, as in the original (the index global is re-read each time) */
static uint8_t *entry(const Fl38cWorld *world)
{
    return world->table_5e569e + (int32_t)(world->dword_5c3a63 * 0x106u);
}

static uint32_t read_time_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host, uint32_t off, uint32_t base, uint32_t store)
{
    uint32_t hours, minutes, seconds;
    wr32(entry(world) + base + store, read_and_convert(self, host, off));
    hours = rd32(entry(world) + base + 0xc) * 0x36ee80u;
    minutes = rd32(entry(world) + base + 8) * 0xea60u;
    seconds = rd32(entry(world) + base + 4) * 0x3e8u;
    wr32(entry(world) + base, hours + minutes + seconds);
    return call_on_self(self, host, 0x4033db);
}

/* shift_rect: the four stores in the order of the original, each source field read after the earlier stores (src and dst may overlap) */
static void shift_rect(const uint8_t *src, uint8_t *dst, const Fl38cWorld *world)
{
    wr32(dst + 4, rd32(src + 4) + (uint32_t)world->dword_58318a);
    wr32(dst + 0xc, rd32(src + 0xc) + (uint32_t)world->dword_58318a);
    wr32(dst, rd32(src) + (uint32_t)world->dword_583186);
    wr32(dst + 8, rd32(src + 8) + (uint32_t)world->dword_583186);
}

/* new_zeroed: `rep stosd` (size / 4 dwords) then `rep stosb` (size & 3) of zero at *out, which is the block just stored */
static void new_zeroed(uint32_t out, uint32_t size, const Fl38cWorld *world, const Fl18Host *host, uint32_t fmt)
{
    uintptr_t two[2], one[1];
    uint32_t p;
    one[0] = size;
    p = callv(host, 0x51dc43, 0, one, 1);
    wr32(res(host, out), p);
    if (p == 0) {
        two[0] = 0x63888b;
        two[1] = fmt;
        callv(host, 0x50ca3e, 0, two, 2);
        one[0] = 0x63888b;
        callv(host, 0x4264e8, 0x583979, one, 1);
        if (world->word_63a4cd != 0) callv(host, 0x44a2b7, 0, one, 1);
        callv(host, 0x4c97b4, 0x5cf659, NULL, 0);
        return;
    }
    memset(res(host, p), 0, size);
}

/* clamp_to_bounds: two (minimum then maximum) clamps per axis; each clamp re-reads the globals and the fields as the original does (a signed compare, wrap-around on the additions) */
static void clamp_axis(uint8_t *self, int32_t lo, int32_t hi, uint32_t lo_field, uint32_t hi_field, uint32_t extent)
{
    if ((int32_t)rd32(self + lo_field) < lo) {
        wr32(self + lo_field, (uint32_t)lo);
        wr32(self + hi_field, rd32(self + lo_field) + (uint32_t)rds16(self + extent));
    }
    if ((int32_t)rd32(self + hi_field) > hi) {
        wr32(self + hi_field, (uint32_t)hi);
        wr32(self + lo_field, rd32(self + hi_field) - (uint32_t)rds16(self + extent));
    }
}

static void clamp_to_bounds(uint8_t *self, const Fl38cWorld *world, uint32_t a, uint32_t b, uint32_t w1, uint32_t c, uint32_t d, uint32_t w2)
{
    clamp_axis(self, world->dword_58319a, world->dword_5831a2, a, b, w1);
    clamp_axis(self, world->dword_583196, world->dword_58319e, c, d, w2);
}

/* ---- 0x40430e read_word_setting ---- */
/* 0x40430e, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x18c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and its low word is stored at [0x5e5686], then 0x4033db (thiscall on self, no arguments) is called; returns its eax. */
/* 0x40430e m40430e_read_word_setting */
uint32_t m40430e_read_word_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host)
{
    return read_word_setting(self, host, 0x18c, &world->word_5e5686, 0x4033db);
}

/* ---- 0x404349 read_word_setting ---- */
/* 0x404349, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x14c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and its low word is stored at [0x5e5684], then 0x4033db (thiscall on self, no arguments) is called; returns its eax. */
/* 0x404349 m404349_read_word_setting */
uint32_t m404349_read_word_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host)
{
    return read_word_setting(self, host, 0x14c, &world->word_5e5684, 0x4033db);
}

/* ---- 0x40492f read_word_setting ---- */
/* 0x40492f, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x38c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and its low word is stored at [0x5ec33a], then 0x4033db (thiscall on self, no arguments) is called; returns its eax. */
/* 0x40492f m40492f_read_word_setting */
uint32_t m40492f_read_word_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host)
{
    return read_word_setting(self, host, 0x38c, &world->word_5ec33a, 0x4033db);
}

/* ---- 0x40496a read_word_setting ---- */
/* 0x40496a, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x3cc, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and its low word is stored at [0x5ec284], then 0x4033db (thiscall on self, no arguments) is called; returns its eax. */
/* 0x40496a m40496a_read_word_setting */
uint32_t m40496a_read_word_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host)
{
    return read_word_setting(self, host, 0x3cc, &world->word_5ec284, 0x4033db);
}

/* ---- 0x4049a5 read_word_setting ---- */
/* 0x4049a5, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x44c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and its low word is stored at [0x5ec288], then 0x4033db (thiscall on self, no arguments) is called; returns its eax. */
/* 0x4049a5 m4049a5_read_word_setting */
uint32_t m4049a5_read_word_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host)
{
    return read_word_setting(self, host, 0x44c, &world->word_5ec288, 0x4033db);
}

/* ---- 0x4049e0 read_word_setting ---- */
/* 0x4049e0, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x40c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and its low word is stored at [0x5ec286], then 0x4033db (thiscall on self, no arguments) is called; returns its eax. */
/* 0x4049e0 m4049e0_read_word_setting */
uint32_t m4049e0_read_word_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host)
{
    return read_word_setting(self, host, 0x40c, &world->word_5ec286, 0x4033db);
}

/* ---- 0x40893f read_word_setting ---- */
/* 0x40893f, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x94c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and its low word is stored at [0x5ec2d4], then 0x407ca7 (thiscall on self, no arguments) is called; returns its eax. */
/* 0x40893f m40893f_read_word_setting */
uint32_t m40893f_read_word_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host)
{
    return read_word_setting(self, host, 0x94c, &world->word_5ec2d4, 0x407ca7);
}

/* ---- 0x4043b6 read_time_setting ---- */
/* 0x4043b6, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x24c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and the dword result is stored in the field at 0x5e56aa of entry [0x5c3a63] (stride 0x106, table 0x5e569e); then the field at 0x5e569e = (field at 0x5e56aa) * 3600000 + (field at 0x5e56a6) * 60000 + (field at 0x5e56a2) * 1000 (32-bit wrap, every field re-read from memory), and 0x4033db (thiscall on self) is called; returns its eax. */
/* 0x4043b6 m4043b6_read_time_setting */
uint32_t m4043b6_read_time_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host)
{
    return read_time_setting(self, world, host, 0x24c, 0x0, 0xc);
}

/* ---- 0x40445a read_time_setting ---- */
/* 0x40445a, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x20c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and the dword result is stored in the field at 0x5e56a6 of entry [0x5c3a63] (stride 0x106, table 0x5e569e); then the field at 0x5e569e = (field at 0x5e56aa) * 3600000 + (field at 0x5e56a6) * 60000 + (field at 0x5e56a2) * 1000 (32-bit wrap, every field re-read from memory), and 0x4033db (thiscall on self) is called; returns its eax. */
/* 0x40445a m40445a_read_time_setting */
uint32_t m40445a_read_time_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host)
{
    return read_time_setting(self, world, host, 0x20c, 0x0, 0x8);
}

/* ---- 0x4044fe read_time_setting ---- */
/* 0x4044fe, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x28c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and the dword result is stored in the field at 0x5e56a2 of entry [0x5c3a63] (stride 0x106, table 0x5e569e); then the field at 0x5e569e = (field at 0x5e56aa) * 3600000 + (field at 0x5e56a6) * 60000 + (field at 0x5e56a2) * 1000 (32-bit wrap, every field re-read from memory), and 0x4033db (thiscall on self) is called; returns its eax. */
/* 0x4044fe m4044fe_read_time_setting */
uint32_t m4044fe_read_time_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host)
{
    return read_time_setting(self, world, host, 0x28c, 0x0, 0x4);
}

/* ---- 0x4045a2 read_time_setting ---- */
/* 0x4045a2, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x30c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and the dword result is stored in the field at 0x5e56be of entry [0x5c3a63] (stride 0x106, table 0x5e569e); then the field at 0x5e56b2 = (field at 0x5e56be) * 3600000 + (field at 0x5e56ba) * 60000 + (field at 0x5e56b6) * 1000 (32-bit wrap, every field re-read from memory), and 0x4033db (thiscall on self) is called; returns its eax. */
/* 0x4045a2 m4045a2_read_time_setting */
uint32_t m4045a2_read_time_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host)
{
    return read_time_setting(self, world, host, 0x30c, 0x14, 0xc);
}

/* ---- 0x404646 read_time_setting ---- */
/* 0x404646, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x2cc, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and the dword result is stored in the field at 0x5e56ba of entry [0x5c3a63] (stride 0x106, table 0x5e569e); then the field at 0x5e56b2 = (field at 0x5e56be) * 3600000 + (field at 0x5e56ba) * 60000 + (field at 0x5e56b6) * 1000 (32-bit wrap, every field re-read from memory), and 0x4033db (thiscall on self) is called; returns its eax. */
/* 0x404646 m404646_read_time_setting */
uint32_t m404646_read_time_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host)
{
    return read_time_setting(self, world, host, 0x2cc, 0x14, 0x8);
}

/* ---- 0x4046ea read_time_setting ---- */
/* 0x4046ea, thiscall, plain `ret`: a 0x13-byte string is read into a local with 0x51d5b2 (thiscall on self + 0x34c, arguments: the local, 0x13), 0x50cb1b (cdecl, the local) converts it and the dword result is stored in the field at 0x5e56b6 of entry [0x5c3a63] (stride 0x106, table 0x5e569e); then the field at 0x5e56b2 = (field at 0x5e56be) * 3600000 + (field at 0x5e56ba) * 60000 + (field at 0x5e56b6) * 1000 (32-bit wrap, every field re-read from memory), and 0x4033db (thiscall on self) is called; returns its eax. */
/* 0x4046ea m4046ea_read_time_setting */
uint32_t m4046ea_read_time_setting(uint8_t *self, Fl38cWorld *world, const Fl18Host *host)
{
    return read_time_setting(self, world, host, 0x34c, 0x14, 0x4);
}

/* ---- 0x454f29 shift_rect ---- */
/* 0x454f29, thiscall with two stack arguments (`ret 8`; ecx is stored and unused): dst[+4] = src[+4] + [0x58318a], dst[+0xc] = src[+0xc] + [0x58318a], dst[+0] = src[+0] + [0x583186], dst[+8] = src[+8] + [0x583186], in this order, 32-bit wrap; src and dst may overlap. */
/* 0x454f29 m454f29_shift_rect */
void m454f29_shift_rect(const uint8_t *src, uint8_t *dst, const Fl38cWorld *world)
{
    shift_rect(src, dst, world);
}

/* ---- 0x457071 shift_rect ---- */
/* 0x457071, thiscall with two stack arguments (`ret 8`; ecx is stored and unused): dst[+4] = src[+4] + [0x58318a], dst[+0xc] = src[+0xc] + [0x58318a], dst[+0] = src[+0] + [0x583186], dst[+8] = src[+8] + [0x583186], in this order, 32-bit wrap; src and dst may overlap. */
/* 0x457071 m457071_shift_rect */
void m457071_shift_rect(const uint8_t *src, uint8_t *dst, const Fl38cWorld *world)
{
    shift_rect(src, dst, world);
}

/* ---- 0x458137 shift_rect ---- */
/* 0x458137, thiscall with two stack arguments (`ret 8`; ecx is stored and unused): dst[+4] = src[+4] + [0x58318a], dst[+0xc] = src[+0xc] + [0x58318a], dst[+0] = src[+0] + [0x583186], dst[+8] = src[+8] + [0x583186], in this order, 32-bit wrap; src and dst may overlap. */
/* 0x458137 m458137_shift_rect */
void m458137_shift_rect(const uint8_t *src, uint8_t *dst, const Fl38cWorld *world)
{
    shift_rect(src, dst, world);
}

/* ---- 0x46453b shift_rect ---- */
/* 0x46453b, thiscall with two stack arguments (`ret 8`; ecx is stored and unused): dst[+4] = src[+4] + [0x58318a], dst[+0xc] = src[+0xc] + [0x58318a], dst[+0] = src[+0] + [0x583186], dst[+8] = src[+8] + [0x583186], in this order, 32-bit wrap; src and dst may overlap. */
/* 0x46453b m46453b_shift_rect */
void m46453b_shift_rect(const uint8_t *src, uint8_t *dst, const Fl38cWorld *world)
{
    shift_rect(src, dst, world);
}

/* ---- 0x466db1 shift_rect ---- */
/* 0x466db1, thiscall with two stack arguments (`ret 8`; ecx is stored and unused): dst[+4] = src[+4] + [0x58318a], dst[+0xc] = src[+0xc] + [0x58318a], dst[+0] = src[+0] + [0x583186], dst[+8] = src[+8] + [0x583186], in this order, 32-bit wrap; src and dst may overlap. */
/* 0x466db1 m466db1_shift_rect */
void m466db1_shift_rect(const uint8_t *src, uint8_t *dst, const Fl38cWorld *world)
{
    shift_rect(src, dst, world);
}

/* ---- 0x479d98 shift_rect ---- */
/* 0x479d98, thiscall with two stack arguments (`ret 8`; ecx is stored and unused): dst[+4] = src[+4] + [0x58318a], dst[+0xc] = src[+0xc] + [0x58318a], dst[+0] = src[+0] + [0x583186], dst[+8] = src[+8] + [0x583186], in this order, 32-bit wrap; src and dst may overlap. */
/* 0x479d98 m479d98_shift_rect */
void m479d98_shift_rect(const uint8_t *src, uint8_t *dst, const Fl38cWorld *world)
{
    shift_rect(src, dst, world);
}

/* ---- 0x4465fd new_zeroed ---- */
/* 0x4465fd, two stack arguments (`ret 8`; ecx is stored and unused): p = 0x51dc43(size) is stored at *out; when p is 0 it formats 0x54824c with 0x50ca3e(0x63888b, fmt), reports with 0x4264e8 (thiscall on 0x583979, argument 0x63888b), sends 0x44a2b7(0x63888b) when the word [0x63a4cd] is non-zero and calls 0x4c97b4 (thiscall on 0x5cf659; it ends in PostQuitMessage and returns) without clearing anything; otherwise the `size` bytes at p are set to 0. */
/* 0x4465fd m4465fd_new_zeroed */
void m4465fd_new_zeroed(uint32_t out, uint32_t size, const Fl38cWorld *world, const Fl18Host *host)
{
    new_zeroed(out, size, world, host, 0x54824c);
}

/* ---- 0x4547bc new_zeroed ---- */
/* 0x4547bc, two stack arguments (`ret 8`; ecx is stored and unused): p = 0x51dc43(size) is stored at *out; when p is 0 it formats 0x549e28 with 0x50ca3e(0x63888b, fmt), reports with 0x4264e8 (thiscall on 0x583979, argument 0x63888b), sends 0x44a2b7(0x63888b) when the word [0x63a4cd] is non-zero and calls 0x4c97b4 (thiscall on 0x5cf659; it ends in PostQuitMessage and returns) without clearing anything; otherwise the `size` bytes at p are set to 0. */
/* 0x4547bc m4547bc_new_zeroed */
void m4547bc_new_zeroed(uint32_t out, uint32_t size, const Fl38cWorld *world, const Fl18Host *host)
{
    new_zeroed(out, size, world, host, 0x549e28);
}

/* ---- 0x454f7c clamp_to_bounds ---- */
/* 0x454f7c, thiscall, plain `ret`: clamps the rectangle fields self[0x4e]/self[0x56] (x) and self[0x4a]/self[0x52] (y) into the bounds [[0x58319a], [0x5831a2]] and [[0x583196], [0x58319e]] (signed 32-bit compares), keeping the extents (int16 at +0x16c and +0x16a); no callee. */
/* 0x454f7c m454f7c_clamp_to_bounds */
void m454f7c_clamp_to_bounds(uint8_t *self, Fl38cWorld *world)
{
    clamp_to_bounds(self, world, 0x4e, 0x56, 0x16c, 0x4a, 0x52, 0x16a);
}

/* ---- 0x46458e clamp_to_bounds ---- */
/* 0x46458e, thiscall, plain `ret`: clamps the rectangle fields self[0x4e]/self[0x56] (x) and self[0x4a]/self[0x52] (y) into the bounds [[0x58319a], [0x5831a2]] and [[0x583196], [0x58319e]] (signed 32-bit compares), keeping the extents (int16 at +0xd4 and +0xd2); no callee. */
/* 0x46458e m46458e_clamp_to_bounds */
void m46458e_clamp_to_bounds(uint8_t *self, Fl38cWorld *world)
{
    clamp_to_bounds(self, world, 0x4e, 0x56, 0xd4, 0x4a, 0x52, 0xd2);
}

/* ---- 0x46b855 clamp_to_bounds ---- */
/* 0x46b855, thiscall, plain `ret`: clamps the rectangle fields self[0x49f8]/self[0x4a00] (x) and self[0x49f4]/self[0x49fc] (y) into the bounds [[0x58319a], [0x5831a2]] and [[0x583196], [0x58319e]] (signed 32-bit compares), keeping the extents (int16 at +0x816c and +0x816a); no callee. */
/* 0x46b855 m46b855_clamp_to_bounds */
void m46b855_clamp_to_bounds(uint8_t *self, Fl38cWorld *world)
{
    clamp_to_bounds(self, world, 0x49f8, 0x4a00, 0x816c, 0x49f4, 0x49fc, 0x816a);
}
