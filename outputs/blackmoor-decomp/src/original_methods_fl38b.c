#include "original_methods_fl38b.h"

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

/* host memory behind an original address (the host owns it; the interface only says const) */
static uint8_t *res(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

/* `rep movsd` (size / 4 dwords), then `movsw` when bit 1 of size is set, then `movsb` when bit 0 is set: forward, each unit read in full before it is written (so an overlapping
 * destination sees the same bytes as it does in the original) */
static void copy_forward(uint8_t *dst, const uint8_t *src, uint32_t size)
{
    uint32_t i;
    for (i = 0; i < size / 4u; i++) {
        const uint32_t v = rd32(src);
        wr32(dst, v);
        src += 4;
        dst += 4;
    }
    if ((size & 2u) != 0) {
        uint16_t v;
        memcpy(&v, src, sizeof v);
        memcpy(dst, &v, sizeof v);
        src += 2;
        dst += 2;
    }
    if ((size & 1u) != 0) *dst = *src;
}

/* the body shared by the rows: the constants of a row are its size, the format and message strings and the debug message */
static int clone_record(uint32_t out, uint32_t src, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host, uint32_t size, uint32_t fmt, uint32_t msg, uint32_t dbg_msg)
{
    uintptr_t a4[4], a2[2];
    const uint32_t p = call1(host, 0x51dc43, 0, size);
    wr32(res(host, out), p);
    if (p == 0) {
        a4[0] = 0x63888b; a4[1] = fmt; a4[2] = world->dword_5bb57b; a4[3] = (uint32_t)(int32_t)world->word_5c39e3;
        callv(host, 0x50ca3e, 0, a4, 4);
        a2[0] = msg; a2[1] = 0x63888b;
        callv(host, 0x42639d, 0x583979, a2, 2);
        call0(host, 0x4c97b4, 0x5cf659);
        return 1;                       /* 0x4c97b4 posts WM_QUIT and returns; the original then copies S bytes through *out = 0 (access violation); not modelled */
    }
    copy_forward(res(host, rd32(res(host, out))), res(host, rd32(res(host, src))), size);
    wr32(res(host, adv), rd32(res(host, adv)) + size);
    wr32(res(host, src), rd32(res(host, src)) + size);
    if (world->word_63a4cd != 0) call1(host, 0x44a2b7, 0, dbg_msg);
    return 0;
}

/* ---- 0x44d1d1 clone_record ---- */
/* 0x44d1d1, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x2fb) is stored at *out; when p is 0 the failure report (fmt 0x549538, message 0x549564) ends in 0x4c97b4 and the port returns 1; otherwise 0x2fb bytes (movsw+movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x2fb; the debug message 0x549580 is sent when [0x63a4cd] is non-zero. Returns 0. */
/* 0x44d1d1 m44d1d1_clone_record */
int m44d1d1_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host)
{
    return clone_record(out, in2, adv, world, host, 0x2fb, 0x549538, 0x549564, 0x549580);
}

/* ---- 0x456fb6 clone_record ---- */
/* 0x456fb6, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x27b) is stored at *out; when p is 0 the failure report (fmt 0x54a330, message 0x54a35c) ends in 0x4c97b4 and the port returns 1; otherwise 0x27b bytes (movsw+movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x27b; the debug message 0x54a378 is sent when [0x63a4cd] is non-zero. Returns 0. */
/* 0x456fb6 m456fb6_clone_record */
int m456fb6_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host)
{
    return clone_record(out, in2, adv, world, host, 0x27b, 0x54a330, 0x54a35c, 0x54a378);
}

/* ---- 0x45807c clone_record ---- */
/* 0x45807c, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x663) is stored at *out; when p is 0 the failure report (fmt 0x54a578, message 0x54a5a4) ends in 0x4c97b4 and the port returns 1; otherwise 0x663 bytes (movsw+movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x663; the debug message 0x54a5c0 is sent when [0x63a4cd] is non-zero. Returns 0. */
/* 0x45807c m45807c_clone_record */
int m45807c_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host)
{
    return clone_record(out, in2, adv, world, host, 0x663, 0x54a578, 0x54a5a4, 0x54a5c0);
}

/* ---- 0x464100 clone_record ---- */
/* 0x464100, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x43f) is stored at *out; when p is 0 the failure report (fmt 0x54b2c0, message 0x54b2ec) ends in 0x4c97b4 and the port returns 1; otherwise 0x43f bytes (movsw+movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x43f; the debug message 0x54b308 is sent when [0x63a4cd] is non-zero. Returns 0. */
/* 0x464100 m464100_clone_record */
int m464100_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host)
{
    return clone_record(out, in2, adv, world, host, 0x43f, 0x54b2c0, 0x54b2ec, 0x54b308);
}

/* ---- 0x465bde clone_record ---- */
/* 0x465bde, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x55f) is stored at *out; when p is 0 the failure report (fmt 0x54b4d0, message 0x54b4fc) ends in 0x4c97b4 and the port returns 1; otherwise 0x55f bytes (movsw+movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x55f; the debug message 0x54b518 is sent when [0x63a4cd] is non-zero. Returns 0. */
/* 0x465bde m465bde_clone_record */
int m465bde_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host)
{
    return clone_record(out, in2, adv, world, host, 0x55f, 0x54b4d0, 0x54b4fc, 0x54b518);
}

/* ---- 0x46b79a clone_record ---- */
/* 0x46b79a, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x6e3) is stored at *out; when p is 0 the failure report (fmt 0x54bc84, message 0x54bcb0) ends in 0x4c97b4 and the port returns 1; otherwise 0x6e3 bytes (movsw+movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x6e3; the debug message 0x54bccc is sent when [0x63a4cd] is non-zero. Returns 0. */
/* 0x46b79a m46b79a_clone_record */
int m46b79a_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host)
{
    return clone_record(out, in2, adv, world, host, 0x6e3, 0x54bc84, 0x54bcb0, 0x54bccc);
}

/* ---- 0x47314b clone_record ---- */
/* 0x47314b, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x4ff) is stored at *out; when p is 0 the failure report (fmt 0x54c5a0, message 0x54c5cc) ends in 0x4c97b4 and the port returns 1; otherwise 0x4ff bytes (movsw+movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x4ff; the debug message 0x54c5e8 is sent when [0x63a4cd] is non-zero. Returns 0. */
/* 0x47314b m47314b_clone_record */
int m47314b_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host)
{
    return clone_record(out, in2, adv, world, host, 0x4ff, 0x54c5a0, 0x54c5cc, 0x54c5e8);
}

/* ---- 0x4782db clone_record ---- */
/* 0x4782db, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x29b) is stored at *out; when p is 0 the failure report (fmt 0x54cb10, message 0x54cb3c) ends in 0x4c97b4 and the port returns 1; otherwise 0x29b bytes (movsw+movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x29b; the debug message 0x54cb58 is sent when [0x63a4cd] is non-zero. Returns 0. */
/* 0x4782db m4782db_clone_record */
int m4782db_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host)
{
    return clone_record(out, in2, adv, world, host, 0x29b, 0x54cb10, 0x54cb3c, 0x54cb58);
}

/* ---- 0x475964 clone_record ---- */
/* 0x475964, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x7f2) is stored at *out; when p is 0 the failure report (fmt 0x54c7cc, message 0x54c7f8) ends in 0x4c97b4 and the port returns 1; otherwise 0x7f2 bytes (movsw) are copied from *in2 to *out and *adv, then *in2, advance by 0x7f2; the debug message 0x54c814 is sent when [0x63a4cd] is non-zero. Returns 0. */
/* 0x475964 m475964_clone_record */
int m475964_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host)
{
    return clone_record(out, in2, adv, world, host, 0x7f2, 0x54c7cc, 0x54c7f8, 0x54c814);
}

/* ---- 0x44fbe3 clone_record ---- */
/* 0x44fbe3, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x4e8) is stored at *out; when p is 0 the failure report (fmt 0x54991c, message 0x549948) ends in 0x4c97b4 and the port returns 1; otherwise 0x4e8 bytes (none) are copied from *in2 to *out and *adv, then *in2, advance by 0x4e8; the debug message 0x549964 is sent when [0x63a4cd] is non-zero. Returns 0. */
/* 0x44fbe3 m44fbe3_clone_record */
int m44fbe3_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host)
{
    return clone_record(out, in2, adv, world, host, 0x4e8, 0x54991c, 0x549948, 0x549964);
}

/* ---- 0x467688 clone_record ---- */
/* 0x467688, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x408) is stored at *out; when p is 0 the failure report (fmt 0x54b7d8, message 0x54b804) ends in 0x4c97b4 and the port returns 1; otherwise 0x408 bytes (none) are copied from *in2 to *out and *adv, then *in2, advance by 0x408; the debug message 0x54b820 is sent when [0x63a4cd] is non-zero. Returns 0. */
/* 0x467688 m467688_clone_record */
int m467688_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host)
{
    return clone_record(out, in2, adv, world, host, 0x408, 0x54b7d8, 0x54b804, 0x54b820);
}

/* ---- 0x468f9f clone_record ---- */
/* 0x468f9f, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x5d8) is stored at *out; when p is 0 the failure report (fmt 0x54b974, message 0x54b9a0) ends in 0x4c97b4 and the port returns 1; otherwise 0x5d8 bytes (none) are copied from *in2 to *out and *adv, then *in2, advance by 0x5d8; the debug message 0x54b9bc is sent when [0x63a4cd] is non-zero. Returns 0. */
/* 0x468f9f m468f9f_clone_record */
int m468f9f_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host)
{
    return clone_record(out, in2, adv, world, host, 0x5d8, 0x54b974, 0x54b9a0, 0x54b9bc);
}

/* ---- 0x47e477 clone_record ---- */
/* 0x47e477, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0xa34) is stored at *out; when p is 0 the failure report (fmt 0x54d474, message 0x54d4a0) ends in 0x4c97b4 and the port returns 1; otherwise 0xa34 bytes (none) are copied from *in2 to *out and *adv, then *in2, advance by 0xa34; the debug message 0x54d4bc is sent when [0x63a4cd] is non-zero. Returns 0. */
/* 0x47e477 m47e477_clone_record */
int m47e477_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host)
{
    return clone_record(out, in2, adv, world, host, 0xa34, 0x54d474, 0x54d4a0, 0x54d4bc);
}

/* ---- 0x44e8a2 clone_record ---- */
/* 0x44e8a2, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x269) is stored at *out; when p is 0 the failure report (fmt 0x5497a8, message 0x5497d4) ends in 0x4c97b4 and the port returns 1; otherwise 0x269 bytes (movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x269; the debug message 0x5497f0 is sent when [0x63a4cd] is non-zero. Returns 0. */
/* 0x44e8a2 m44e8a2_clone_record */
int m44e8a2_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host)
{
    return clone_record(out, in2, adv, world, host, 0x269, 0x5497a8, 0x5497d4, 0x5497f0);
}

/* ---- 0x454e70 clone_record ---- */
/* 0x454e70, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0xd01) is stored at *out; when p is 0 the failure report (fmt 0x549fbc, message 0x549fe8) ends in 0x4c97b4 and the port returns 1; otherwise 0xd01 bytes (movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0xd01; the debug message 0x54a004 is sent when [0x63a4cd] is non-zero. Returns 0. */
/* 0x454e70 m454e70_clone_record */
int m454e70_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host)
{
    return clone_record(out, in2, adv, world, host, 0xd01, 0x549fbc, 0x549fe8, 0x54a004);
}

/* ---- 0x459c10 clone_record ---- */
/* 0x459c10, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x2b1) is stored at *out; when p is 0 the failure report (fmt 0x54a74c, message 0x54a778) ends in 0x4c97b4 and the port returns 1; otherwise 0x2b1 bytes (movsb) are copied from *in2 to *out and *adv, then *in2, advance by 0x2b1; the debug message 0x54a794 is sent when [0x63a4cd] is non-zero. Returns 0. */
/* 0x459c10 m459c10_clone_record */
int m459c10_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host)
{
    return clone_record(out, in2, adv, world, host, 0x2b1, 0x54a74c, 0x54a778, 0x54a794);
}

/* ---- 0x45ddd0 clone_record ---- */
/* 0x45ddd0, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x1346) is stored at *out; when p is 0 the failure report (fmt 0x54aeb8, message 0x54aee4) ends in 0x4c97b4 and the port returns 1; otherwise 0x1346 bytes (movsw) are copied from *in2 to *out and *adv, then *in2, advance by 0x1346; the debug message 0x54af00 is sent when [0x63a4cd] is non-zero. Returns 0. */
/* 0x45ddd0 m45ddd0_clone_record */
int m45ddd0_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host)
{
    return clone_record(out, in2, adv, world, host, 0x1346, 0x54aeb8, 0x54aee4, 0x54af00);
}

/* ---- 0x47b3f0 clone_record ---- */
/* 0x47b3f0, stdcall (`ret 0xc`) with three cells: p = 0x51dc43(0x16c2) is stored at *out; when p is 0 the failure report (fmt 0x54cdd4, message 0x54ce00) ends in 0x4c97b4 and the port returns 1; otherwise 0x16c2 bytes (movsw) are copied from *in2 to *out and *adv, then *in2, advance by 0x16c2; the debug message 0x54ce1c is sent when [0x63a4cd] is non-zero. Returns 0. */
/* 0x47b3f0 m47b3f0_clone_record */
int m47b3f0_clone_record(uint32_t out, uint32_t in2, uint32_t adv, const Fl38bWorld *world, const Fl18Host *host)
{
    return clone_record(out, in2, adv, world, host, 0x16c2, 0x54cdd4, 0x54ce00, 0x54ce1c);
}
