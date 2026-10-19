#include "original_methods_fl24b.h"

#include <string.h>

#if defined(__GNUC__) || defined(__clang__)
#define FL24B_UNUSED __attribute__((unused))
#else
#define FL24B_UNUSED
#endif

FL24B_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL24B_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL24B_UNUSED static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL24B_UNUSED static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* a signed word, sign-extended (movsx) */
FL24B_UNUSED static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

FL24B_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, NULL, 0) : 0;
}

FL24B_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    uintptr_t args[1];
    args[0] = a0;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 1) : 0;
}

FL24B_UNUSED static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    uintptr_t args[2];
    args[0] = a0;
    args[1] = a1;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 2) : 0;
}

FL24B_UNUSED static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    uintptr_t args[3];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 3) : 0;
}

/* the object of an original address (an address that a record keeps), as host memory */
FL24B_UNUSED static const uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return host->resolve(host->context, address);
}

/* repe cmpsb with ecx = 9: 1 when the nine bytes at a and b are equal */
FL24B_UNUSED static int nine_bytes_equal(const uint8_t *a, const uint8_t *b)
{
    int k;
    for (k = 0; k < 9; k++)
        if (a[k] != b[k]) return 0;
    return 1;
}

/* `movsx ecx, word [self + idx]; imul ecx, ecx, 0x8d`: the byte offset of the record n in the table at 0x5bb5e5 */
FL24B_UNUSED static ptrdiff_t rec_offset(const uint8_t *self, ptrdiff_t idx_off)
{
    return (ptrdiff_t)(rds16(self, idx_off) * 0x8d);
}

/* `cmp dword [n * 0x8d + 0x5bb632], 1` */
FL24B_UNUSED static int record_state_is_1(const Fl24bWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    return rd32(world->records_5bb5e5, rec_offset(self, idx_off) + 0x4d) == 1;
}

/* `mov dword [n * 0x8d + 0x5bb632], 2` (the index word is read again, as the original does) */
FL24B_UNUSED static void set_record_state_2(const Fl24bWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    wr32(world->records_5bb5e5, rec_offset(self, idx_off) + 0x4d, 2);
}

/* `mov eax, [n * 0x8d + 0x5bb5e5]`: the original address of the object of record n */
FL24B_UNUSED static uint32_t record_object_address(const Fl24bWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    return rd32(world->records_5bb5e5, rec_offset(self, idx_off));
}

/* ---- 0x4dad60 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4dad60, thiscall, plain `ret`, eax = this on return. Clears the dwords [+0xc], [+0x10], [+0], [+4], [+8] and the bytes 0x58321d and
 * 0x58321e, calls the import in slot 0x52a498 (stdcall, one argument 0x17) and stores its result at [+0x14]; a non-zero result gives
 * [+0x20] = 2, [+0x24] = 1, zero gives [+0x20] = 1, [+0x24] = 2; then clears [+0x18] and [+0x1c]. The result is re-read from the object
 * as the original does. */
void m4dad60_init_swap_buttons(uint8_t *self, Fl24bWorld *world, const Fl18Host *host)
{
    uint32_t r;
    wr32(self, 0xc, 0);
    wr32(self, 0x10, 0);
    wr32(self, 0, 0);
    wr32(self, 4, 0);
    wr32(self, 8, 0);
    world->value_58321d = 0;
    world->value_58321e = 0;
    r = call1(host, 0x52a498, 0, 0x17);
    wr32(self, 0x14, r);
    if (rd32(self, 0x14) != 0) {
        wr32(self, 0x20, 2);
        wr32(self, 0x24, 1);
    } else {
        wr32(self, 0x20, 1);
        wr32(self, 0x24, 2);
    }
    wr32(self, 0x18, 0);
    wr32(self, 0x1c, 0);
}

/* ---- 0x466073 ------------------------------------------------------------------------------------------------------------------ */

/* 0x466073, thiscall, plain `ret`: guards [+0x49] != 0, byte [+0x4e] == 0 and the state of the record of the word [+0x1e]; event 0x27d3
 * sets the byte [+0x4d] and the state 2; event 0x27d2 switches on the signed word [+0x28] - 1 (unsigned compare with 3; jump table at
 * 0x466237: word 1 -> 0x466131, 2 -> 0x4661aa, 3 -> 0x4661d9, 4 -> 0x466164), each arm copies 49 bytes of the record's object into a
 * local (rep movsd x12 + movsb) and the common tail compares the first nine bytes of the local with the constant at 0x54b54c when the
 * flag 0x5bb1ca is set, announcing the word at local+0x21 through 0x4fb2e3 (this 0x5c3a67) when they differ. The out-of-range arm leaves
 * the local uninitialised (zero here). */
void m466073_click_27d2_27d3(uint8_t *self, Fl24bWorld *world, const Fl18Host *host)
{
    uint8_t local[0x31];
    uint32_t rec_obj, k;
    memset(local, 0, sizeof local);
    rec_obj = record_object_address(world, self, 0x1e);
    if (rd32(self, 0x49) == 0) return;
    if (self[0x4e] != 0) return;
    if (!record_state_is_1(world, self, 0x1e)) return;
    if (world->value_5c39e5 == 0x27d3) {
        self[0x4d] = 1;
        set_record_state_2(world, self, 0x1e);
        return;
    }
    if (world->value_5c39e5 != 0x27d2) return;
    k = (uint32_t)(rds16(self, 0x28) - 1);
    switch (k) {
    case 0:   /* 0x466131 */
        self[0x3e] = (uint8_t)(self[0x3e] == 0);
        self[0x42] = 1;
        memcpy(local, object_at(host, rec_obj + 0x43e), sizeof local);
        break;
    case 3:   /* 0x466164 */
        if (rds16(self, 0x2c) < 3) {
            wr16(self, 0x2c, (uint16_t)(rd16(self, 0x2c) + 1));
        } else {
            self[0x41] = 1;
            wr16(self, 0x2c, 0);
        }
        memcpy(local, object_at(host, rec_obj + 0x46f), sizeof local);
        break;
    case 1:   /* 0x4661aa */
        wr16(self, 0x2a, (uint16_t)(rd16(self, 0x2a) - 1));
        memcpy(local, object_at(host, rec_obj + 0x40d), sizeof local);
        self[0x3f] = 1;
        break;
    case 2:   /* 0x4661d9 */
        wr16(self, 0x2a, (uint16_t)(rd16(self, 0x2a) + 1));
        memcpy(local, object_at(host, rec_obj + 0x40d), sizeof local);
        self[0x40] = 1;
        break;
    default:  /* 0x466206 with an uninitialised local */
        break;
    }
    if (world->value_5bb1ca != 0 && !nine_bytes_equal(local, world->bytes_54b54c)) call1(host, 0x4fb2e3, 0x5c3a67, rd16(local, 0x21));
}

/* ---- 0x467740 ------------------------------------------------------------------------------------------------------------------ */

/* arm the globals for the event `event` the way both hits of 0x467740 do (`mov [0x5b44f0], a; mov [0x5b44f4], 1; mov edx, [0x5d0377];
 * mov [0x5d162d], edx; eax = [0x5b44f0] << 5; ecx = [0x5b44f4] << 4; mov [0x5d1631], eax + ecx + 0x5b160c; mov [0x5d1639], 1;
 * mov [0x5c39e5], event`); the shifts read the globals back, as the original does */
static void arm_467740(Fl24bWorld *world, uint32_t a, uint32_t event)
{
    world->value_5b44f0 = a;
    world->value_5b44f4 = 1;
    world->value_5d162d = world->value_5d0377;
    world->value_5d1631 = (world->value_5b44f0 << 5) + (world->value_5b44f4 << 4) + 0x5b160c;
    world->value_5d1639 = 1;
    world->value_5c39e5 = event;
}

/* 0x467740, thiscall, `ret 8`, arguments x then y pushed as words (read by movsx); eax = 1 on a hit, else 0. It stores the address of
 * the object of the record of the word [+8] at [+0x1aa] first. The outer rectangle is at +0x3f8 (x low), +0x3fc (y low), +0x400 (x high),
 * +0x404 (y high) of that object (signed dwords, inclusive); then 17 rectangles of 16 bytes at +0x21 (x low), +0x25, +0x29, +0x2d; the
 * object is re-read through [+0x1aa] at every use. A hotspot that is hit is accepted when the host call 0x467b9e (this = self, argument
 * the index) returns 0. A callee that changes self is not exercised. */
int32_t m467740_hit_test(uint8_t *self, int16_t x, int16_t y, Fl24bWorld *world, const Fl18Host *host)
{
    const uint8_t *o;
    int32_t i;
    wr32(self, 0x1aa, record_object_address(world, self, 8));
    if (rd32(self, 0x1ae) == 0) return 0;
    o = object_at(host, rd32(self, 0x1aa));
    if ((int32_t)y >= (int32_t)rd32(o, 0x3fc) && (int32_t)y <= (int32_t)rd32(o, 0x404) && (int32_t)x >= (int32_t)rd32(o, 0x3f8) &&
        (int32_t)x <= (int32_t)rd32(o, 0x400)) {
        arm_467740(world, 9, 0x27ac);
        return 1;
    }
    for (i = 0; i < 0x11; i++) {
        o = object_at(host, rd32(self, 0x1aa));
        if ((int32_t)y < (int32_t)rd32(o, (ptrdiff_t)i * 16 + 0x25)) continue;
        o = object_at(host, rd32(self, 0x1aa));
        if ((int32_t)y > (int32_t)rd32(o, (ptrdiff_t)i * 16 + 0x2d)) continue;
        o = object_at(host, rd32(self, 0x1aa));
        if ((int32_t)x < (int32_t)rd32(o, (ptrdiff_t)i * 16 + 0x21)) continue;
        o = object_at(host, rd32(self, 0x1aa));
        if ((int32_t)x > (int32_t)rd32(o, (ptrdiff_t)i * 16 + 0x29)) continue;
        if (call1(host, 0x467b9e, (uintptr_t)self, (uintptr_t)i) != 0) continue;
        arm_467740(world, 0, 0x27ab);
        wr16(self, 0xa, (uint16_t)i);
        return 1;
    }
    return 0;
}

/* FL24B-END */
