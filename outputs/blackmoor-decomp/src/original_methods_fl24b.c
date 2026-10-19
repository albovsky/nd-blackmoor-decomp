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

/* ---- 0x4b7563 ------------------------------------------------------------------------------------------------------------------ */

/* The common step of the arms 0x27bf (counter word [+0x31], record object flag byte +0x25, count word +0x21) and 0x27c0 ([+0x33], +0x26,
 * +0x23): with the flag set the counter counts down while its sign-extended value is above 0 and otherwise takes (count - 1) truncated to
 * a word; with the flag clear it counts up while it is below count - 1 (sign-extended, no wrap) and otherwise wraps to 0. */
static void step_4b7563(uint8_t *self, const uint8_t *ro, ptrdiff_t counter, ptrdiff_t flag, ptrdiff_t count)
{
    if (ro[flag] != 0) {
        if (rds16(self, counter) > 0) wr16(self, counter, (uint16_t)(rd16(self, counter) - 1));
        else wr16(self, counter, (uint16_t)(rds16(ro, count) - 1));
    } else {
        if (rds16(self, counter) < rds16(ro, count) - 1) wr16(self, counter, (uint16_t)(rd16(self, counter) + 1));
        else wr16(self, counter, 0);
    }
}

/* 0x4b7563, thiscall, plain `ret`: guards byte [+0x35] != 0, byte [+0x3b] == 0, dword [+0x25] == 0 and the state of the record of the word
 * [+0x21] == 1; then 0x27bf and 0x27c0 step their counter, compare nine bytes of the record object (+0x2ef against 0x551c54, +0x320
 * against 0x551c60) when the flag 0x5bb1ca is set and announce the word at +0x310 / +0x341 through 0x4fb2e3 (this 0x5c3a67) when they
 * differ, and set [+0x25] = 2; 0x27c1 sets the byte [+0x36] and the record state 2. */
void m4b7563_click_27bf_27c1(uint8_t *self, Fl24bWorld *world, const Fl18Host *host)
{
    uint32_t ro_addr = record_object_address(world, self, 0x21);
    const uint8_t *ro;
    if (self[0x35] == 0) return;
    if (self[0x3b] != 0) return;
    if (rd32(self, 0x25) != 0) return;
    if (!record_state_is_1(world, self, 0x21)) return;
    if (world->value_5c39e5 == 0x27bf) {
        ro = object_at(host, ro_addr);
        step_4b7563(self, ro, 0x31, 0x25, 0x21);
        if (world->value_5bb1ca != 0 && !nine_bytes_equal(ro + 0x2ef, world->bytes_551c54))
            call1(host, 0x4fb2e3, 0x5c3a67, rd16(ro, 0x310));
        wr32(self, 0x25, 2);
    }
    if (world->value_5c39e5 == 0x27c0) {
        ro = object_at(host, ro_addr);
        step_4b7563(self, ro, 0x33, 0x26, 0x23);
        if (world->value_5bb1ca != 0 && !nine_bytes_equal(ro + 0x320, world->bytes_551c60))
            call1(host, 0x4fb2e3, 0x5c3a67, rd16(ro, 0x341));
        wr32(self, 0x25, 2);
    }
    if (world->value_5c39e5 == 0x27c1) {
        self[0x36] = 1;
        set_record_state_2(world, self, 0x21);
    }
}

/* ---- 0x459e49 ------------------------------------------------------------------------------------------------------------------ */

/* 0x459e49, thiscall, plain `ret`: guards byte [+0xd6] != 0, byte [+0xe1] == 0, dword [+0xdb] == 0, the record state of the word [+0x1c];
 * only event 0x2742. With t = the word at +0x217 of the record object: if t == 0xff or t equals the word 0x583a29 (both movsx), the byte
 * [+ p + 0x1e] is set (p = the signed word [+0xcc]), the word [+0xcc] is stored at [+ n * 2 + 0xce] while the signed word n = [+0xdf] is at
 * most 3, n is incremented (as a word) and clamped to 4 when above, and with the flag 0x5bb1ca the nine bytes at +0x1b5 of the record
 * object are compared with 0x54a7c4: when they differ and 0x4f6334 (this 0x5cf1eb, the sign-extended word +0x1d6) returns 0, the word
 * +0x1d6 is announced through 0x4fb2e3 (this 0x5c3a67). Otherwise only the flag arm runs: +0x1e6 against 0x54a7d0 and the word +0x207.
 * The indexes p and n are not bounds-checked, as in the original. The record object is re-resolved at every use. */
void m459e49_click_2742(uint8_t *self, Fl24bWorld *world, const Fl18Host *host)
{
    const uint8_t *ro;
    int16_t t;
    ptrdiff_t p, n;
    if (self[0xd6] == 0) return;
    if (self[0xe1] != 0) return;
    if (rd32(self, 0xdb) != 0) return;
    if (!record_state_is_1(world, self, 0x1c)) return;
    if (world->value_5c39e5 != 0x2742) return;
    ro = object_at(host, record_object_address(world, self, 0x1c));
    t = (int16_t)rd16(ro, 0x217);
    if (t == 0xff || world->value_583a29 == t) {
        p = rds16(self, 0xcc);
        self[p + 0x1e] = 1;
        n = rds16(self, 0xdf);
        if (n <= 3) wr16(self, n * 2 + 0xce, rd16(self, 0xcc));
        wr16(self, 0xdf, (uint16_t)(rd16(self, 0xdf) + 1));
        if (rds16(self, 0xdf) > 4) wr16(self, 0xdf, 4);
        if (world->value_5bb1ca != 0) {
            ro = object_at(host, record_object_address(world, self, 0x1c));
            if (!nine_bytes_equal(ro + 0x1b5, world->bytes_54a7c4)) {
                ro = object_at(host, record_object_address(world, self, 0x1c));
                if (call1(host, 0x4f6334, 0x5cf1eb, (uint32_t)rds16(ro, 0x1d6)) == 0) {
                    ro = object_at(host, record_object_address(world, self, 0x1c));
                    call1(host, 0x4fb2e3, 0x5c3a67, rd16(ro, 0x1d6));
                }
            }
        }
    } else if (world->value_5bb1ca != 0) {
        ro = object_at(host, record_object_address(world, self, 0x1c));
        if (!nine_bytes_equal(ro + 0x1e6, world->bytes_54a7d0)) {
            ro = object_at(host, record_object_address(world, self, 0x1c));
            if (call1(host, 0x4f6334, 0x5cf1eb, (uint32_t)rds16(ro, 0x207)) == 0) {
                ro = object_at(host, record_object_address(world, self, 0x1c));
                call1(host, 0x4fb2e3, 0x5c3a67, rd16(ro, 0x207));
            }
        }
    }
}

/* ---- 0x482359 ------------------------------------------------------------------------------------------------------------------ */

/* 0x482359, thiscall, `ret 8`, arguments x then y as words (movsx); eax = 1 on a hit, else 0. Returns 0 at once when the byte [+0xa8] is
 * zero. `ro` is the object of the record of the word [+0x1e]. A word counter i runs from 0 while it is below the signed word ro[+0xfc]
 * (the count is not bounded, as in the original); entry i is the 16-byte rectangle at ro + 0x23e + 16 * i (x low, y low, x high, y high,
 * signed dwords, inclusive). A hit is skipped when i == the word ro[+0x3a2] and the word [+0x92] and the byte [+0x91] are both zero, and
 * when i is the word ro[+0x39e] or ro[+0x3a0] and the word ro[+0x87c] == 1; otherwise the globals are armed (0x16, event 0x27b5), the
 * word [+0xad] = i and 1 is returned. After the loop the outer rectangle ro[+0x86c .. +0x878] arms (9, event 0x27b6). */
int32_t m482359_hit_test(uint8_t *self, int16_t x, int16_t y, Fl24bWorld *world, const Fl18Host *host)
{
    const uint8_t *ro;
    uint32_t ro_addr = record_object_address(world, self, 0x1e);
    int16_t i;
    if (self[0xa8] == 0) return 0;
    ro = object_at(host, ro_addr);
    for (i = 0; (int32_t)i < rds16(ro, 0xfc); i = (int16_t)(i + 1)) {
        ptrdiff_t e = (ptrdiff_t)((int32_t)i * 16);
        if ((int32_t)y < (int32_t)rd32(ro, e + 0x242)) continue;
        if ((int32_t)y > (int32_t)rd32(ro, e + 0x24a)) continue;
        if ((int32_t)x < (int32_t)rd32(ro, e + 0x23e)) continue;
        if ((int32_t)x > (int32_t)rd32(ro, e + 0x246)) continue;
        if ((int32_t)i == rds16(ro, 0x3a2) && rds16(self, 0x92) == 0 && self[0x91] == 0) continue;
        if ((int32_t)i == rds16(ro, 0x39e) || (int32_t)i == rds16(ro, 0x3a0)) {
            if (rds16(ro, 0x87c) == 1) continue;
        }
        arm_467740(world, 0x16, 0x27b5);
        wr16(self, 0xad, (uint16_t)i);
        return 1;
    }
    if ((int32_t)y >= (int32_t)rd32(ro, 0x870) && (int32_t)y <= (int32_t)rd32(ro, 0x878) && (int32_t)x >= (int32_t)rd32(ro, 0x86c) &&
        (int32_t)x <= (int32_t)rd32(ro, 0x874)) {
        arm_467740(world, 9, 0x27b6);
        return 1;
    }
    return 0;
}

/* ---- 0x46793a ------------------------------------------------------------------------------------------------------------------ */

/* 0x46793a, thiscall, plain `ret`. Stores the address of the object of the record of the word [+8] at [+0x1aa] first. Then the guards:
 * [+0x1ae] != 0, [+0xc] == 0, the record state == 1, [+0x1b6] == 0, [+0x1b2] == 0. Event 0x27ac sets [+0x1b2] = 1 and the state 2. Event
 * 0x27ab with w = the signed word [+0xa] and the current selection s = [+0x1ba]: s == -1 selects w; otherwise a different w pushes the
 * pair (s, w) at [+ n * 8 + 0x1c0 / 0x1c4] (n = [+0x240], a signed dword, not bounds-checked), selects w, increments n and runs 0x467c0e
 * (the result goes to [+0x1b6]), 0x467d5f, 0x467e70, 0x467eb0; the same w pops: n == 0 clears the selection (-1), else when the pair at
 * [+ n * 8 + 0x1b8 / 0x1bc] holds s in either dword the selection becomes the first dword and n is decremented, clamped at 0. In every
 * 0x27ab arm that falls out, a non-zero [+0x248] announces the word at +0x2bf of the record object through 0x4fb2e3 (this 0x5c3a67). A
 * callee that changes self is not exercised. */
void m46793a_click_27ab_27ac(uint8_t *self, Fl24bWorld *world, const Fl18Host *host)
{
    int32_t w, k;
    wr32(self, 0x1aa, record_object_address(world, self, 8));
    if (rd32(self, 0x1ae) == 0) return;
    if (rd32(self, 0xc) != 0) return;
    if (!record_state_is_1(world, self, 8)) return;
    if (rd32(self, 0x1b6) != 0) return;
    if (rd32(self, 0x1b2) != 0) return;
    if (world->value_5c39e5 == 0x27ac) {
        wr32(self, 0x1b2, 1);
        set_record_state_2(world, self, 8);
        return;
    }
    if (world->value_5c39e5 != 0x27ab) return;
    if (rd32(self, 0x1ba) == 0xffffffffu) {
        wr32(self, 0x1ba, (uint32_t)rds16(self, 0xa));
    } else if ((uint32_t)rds16(self, 0xa) != rd32(self, 0x1ba)) {
        k = (int32_t)rd32(self, 0x240);
        wr32(self, (ptrdiff_t)k * 8 + 0x1c0, rd32(self, 0x1ba));
        k = (int32_t)rd32(self, 0x240);
        w = rds16(self, 0xa);
        wr32(self, (ptrdiff_t)k * 8 + 0x1c4, (uint32_t)w);
        wr32(self, 0x1ba, (uint32_t)rds16(self, 0xa));
        wr32(self, 0x240, rd32(self, 0x240) + 1);
        wr32(self, 0x1b6, call0(host, 0x467c0e, (uintptr_t)self));
        call0(host, 0x467d5f, (uintptr_t)self);
        call0(host, 0x467e70, (uintptr_t)self);
        call0(host, 0x467eb0, (uintptr_t)self);
    } else {
        if (rd32(self, 0x240) == 0) {
            wr32(self, 0x1ba, 0xffffffffu);
        } else {
            k = (int32_t)rd32(self, 0x240);
            if (rd32(self, (ptrdiff_t)k * 8 + 0x1b8) == rd32(self, 0x1ba) || (k = (int32_t)rd32(self, 0x240), rd32(self, (ptrdiff_t)k * 8 + 0x1bc) == rd32(self, 0x1ba))) {
                k = (int32_t)rd32(self, 0x240);
                wr32(self, 0x1ba, rd32(self, (ptrdiff_t)k * 8 + 0x1b8));
                wr32(self, 0x240, rd32(self, 0x240) - 1);
                if ((int32_t)rd32(self, 0x240) < 0) wr32(self, 0x240, 0);
            }
        }
    }
    if (rd32(self, 0x248) != 0) call1(host, 0x4fb2e3, 0x5c3a67, rd16(object_at(host, rd32(self, 0x1aa)), 0x2bf));
}

/* ---- 0x4ad310 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4ad310, thiscall, plain `ret`: guards dword [+0xc1b] != 0, byte [+0xc24] == 0, dword [+0xc20] == 0, the record state (word [+0x1e]).
 * With [+0x20] == 0: event 0x2775 sets the byte [+0xc1f] and the state 2; event 0x2774 asks 0x4af96e (a word answer, -1 ends), runs
 * 0x4ada56, 0x4ae683(r), sets [+0x20] = 1 and the word [+0x24] = r, runs 0x4ae495(r). With [+0x20] != 0 and event 0x2776: p = self + word[+0x24]
 * * 0xc7 + 0x6e; 0x4ada9f, 0x4ae96c(word[+0x24]); the entries i below the signed word at +0x42 of the object whose address is the dword
 * [+0xc17], except i == word[+0x24], for which 0x4aef4a(word[+0x24], i) answers non-zero are collected in a local array of words
 * (initially 0xffff, 15 words); the word at p becomes the larger (signed) of itself and each collected entry's first word, then is
 * incremented; 0x4ae495(word[+0x24]); [+0x6a] = 1; word[+0x24] = 0xffff; [+0x20] = 0; 0x4adae8. The original computes a pointer from the byte
 * p[0x26] that it never uses (not reproduced). The local array holds 15 words; the original tolerates up to 19 matches (words 15 to 17 land
 * in padding and an unused slot, word 18 stores i over itself); entry 15 would start at the list pointer [+0xc17], so at most 14 entries
 * match and the port's `count >= 15` rejection is unreachable through the handlers. A callee that changes self is not exercised. */
void m4ad310_click_2774_2776(uint8_t *self, Fl24bWorld *world, const Fl18Host *host)
{
    uint16_t arr[15];
    int32_t r, i, count, j;
    ptrdiff_t p;
    int k;
    if (rd32(self, 0xc1b) == 0) return;
    if (self[0xc24] != 0) return;
    if (rd32(self, 0xc20) != 0) return;
    if (!record_state_is_1(world, self, 0x1e)) return;
    if (rd32(self, 0x20) == 0) {
        if (world->value_5c39e5 == 0x2775) {
            self[0xc1f] = 1;
            set_record_state_2(world, self, 0x1e);
        } else if (world->value_5c39e5 == 0x2774) {
            r = (int16_t)call0(host, 0x4af96e, (uintptr_t)self);
            if (r == -1) return;
            call0(host, 0x4ada56, (uintptr_t)self);
            call1(host, 0x4ae683, (uintptr_t)self, (uint32_t)r);
            wr32(self, 0x20, 1);
            wr16(self, 0x24, (uint16_t)r);
            call1(host, 0x4ae495, (uintptr_t)self, (uint32_t)r);
        }
        return;
    }
    if (world->value_5c39e5 != 0x2776) return;
    p = (ptrdiff_t)rds16(self, 0x24) * 0xc7 + 0x6e;
    call0(host, 0x4ada9f, (uintptr_t)self);
    call1(host, 0x4ae96c, (uintptr_t)self, (uint32_t)rds16(self, 0x24));
    for (k = 0; k < 15; k++) arr[k] = 0xffff;
    count = 0;
    for (i = 0; i < rds16(object_at(host, rd32(self, 0xc17)), 0x42); i++) {
        if (i == rds16(self, 0x24)) continue;
        if (call2(host, 0x4aef4a, (uintptr_t)self, (uint32_t)rds16(self, 0x24), (uint32_t)i) != 0) {
            if (count >= 15) return;
            arr[count] = (uint16_t)i;
            count++;
        }
    }
    for (j = 0; j < count; j++) {
        int32_t e = rds16(self, (ptrdiff_t)(int16_t)arr[j] * 0xc7 + 0x6e);
        uint16_t tmp = rds16(self, p) > e ? rd16(self, p) : (uint16_t)e;
        wr16(self, p, tmp);
    }
    wr16(self, p, (uint16_t)(rd16(self, p) + 1));
    call1(host, 0x4ae495, (uintptr_t)self, (uint32_t)rds16(self, 0x24));
    wr32(self, 0x6a, 1);
    wr16(self, 0x24, 0xffff);
    wr32(self, 0x20, 0);
    call0(host, 0x4adae8, (uintptr_t)self);
}

/* ---- 0x4acf45 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4acf45, thiscall, `ret 0xc`: arguments x and y (words, movsx) and a pointer to a block of four dwords; eax = 1 or 0. Returns 0 at once
 * when the dword [+0xc1b] is zero. Copies block[1] to [+0xc29], block[3] to [+0xc31], block[0] to [+0xc25], block[2] to [+0xc2d]. With
 * [+0x20] != 0 (an entry is selected: word [+0x24]): 0x4acdc2, 0x4ad1e5(0x2776), 0x4aec35(&local) and then 0x4ae452(word [+0x24]) when it
 * answered non-zero and the local is non-zero, else 0x4ae495(word [+0x24]); returns 1. Otherwise clears 15 words at +0xe39 and the word
 * [+0xe57] (the counter), tests the entries i below the signed word at +0x42 of the object at the dword [+0xc17]: entry i is at
 * +0x6e + 0xc7 * i (x low +2, y low +6, x high +0xa, y high +0xe, signed dwords inclusive); a hit looks at the mask byte at
 * (dword at q+0x1c) + (y - ylow) * (word at q+0x20) + (x - xlow) where q = entry + 0x27 + 0x28 * byte [entry+0x26]; a non-zero mask byte
 * appends i to the word array (the counter indexes it unchecked, as in the original). A non-empty array runs 0x4ad1e5(0x2774) and returns
 * 1; else the outer rectangle (+0x32a x low, +0x32e y low, +0x332 x high, +0x336 y high of the list object) runs 0x4ad1e5(0x2775) and
 * returns 1, or 0. The original also computes a pointer from the byte [entry+0x26] in the [+0x20] != 0 arm that it never uses (not
 * reproduced). A callee that changes self is not exercised. */
int32_t m4acf45_hit_test(uint8_t *self, int16_t x, int16_t y, const uint8_t *block, Fl24bWorld *world, const Fl18Host *host)
{
    uint32_t local10 = 0;
    int32_t i;
    (void)world;
    if (rd32(self, 0xc1b) == 0) return 0;
    wr32(self, 0xc29, rd32(block, 4));
    wr32(self, 0xc31, rd32(block, 0xc));
    wr32(self, 0xc25, rd32(block, 0));
    wr32(self, 0xc2d, rd32(block, 8));
    if (rd32(self, 0x20) != 0) {
        call0(host, 0x4acdc2, (uintptr_t)self);
        call1(host, 0x4ad1e5, (uintptr_t)self, 0x2776);
        if (call1(host, 0x4aec35, (uintptr_t)self, (uintptr_t)&local10) != 0) {
            if (local10 != 0) call1(host, 0x4ae452, (uintptr_t)self, (uint32_t)rds16(self, 0x24));
            else call1(host, 0x4ae495, (uintptr_t)self, (uint32_t)rds16(self, 0x24));
        } else {
            call1(host, 0x4ae495, (uintptr_t)self, (uint32_t)rds16(self, 0x24));
        }
        return 1;
    }
    memset(self + 0xe39, 0, 30);
    wr16(self, 0xe57, 0);
    for (i = 0; i < rds16(object_at(host, rd32(self, 0xc17)), 0x42); i++) {
        ptrdiff_t e = (ptrdiff_t)i * 0xc7 + 0x6e;
        ptrdiff_t q;
        uint32_t dx, dy;
        if ((int32_t)y < (int32_t)rd32(self, e + 6)) continue;
        if ((int32_t)y > (int32_t)rd32(self, e + 0xe)) continue;
        if ((int32_t)x < (int32_t)rd32(self, e + 2)) continue;
        if ((int32_t)x > (int32_t)rd32(self, e + 0xa)) continue;
        q = e + (ptrdiff_t)self[e + 0x26] * 0x28 + 0x27;
        dx = (uint32_t)((int32_t)x - (int32_t)rd32(self, e + 2));
        dy = (uint32_t)((int32_t)y - (int32_t)rd32(self, e + 6));
        if (object_at(host, rd32(self, q + 0x1c) + dy * (uint32_t)rds16(self, q + 0x20) + dx)[0] == 0) continue;
        wr16(self, (ptrdiff_t)rds16(self, 0xe57) * 2 + 0xe39, (uint16_t)i);
        wr16(self, 0xe57, (uint16_t)(rd16(self, 0xe57) + 1));
    }
    if (rds16(self, 0xe57) != 0) {
        call1(host, 0x4ad1e5, (uintptr_t)self, 0x2774);
        return 1;
    }
    {
        const uint8_t *o = object_at(host, rd32(self, 0xc17));
        if ((int32_t)y >= (int32_t)rd32(o, 0x32e)) {
            o = object_at(host, rd32(self, 0xc17));
            if ((int32_t)y <= (int32_t)rd32(o, 0x336)) {
                o = object_at(host, rd32(self, 0xc17));
                if ((int32_t)x >= (int32_t)rd32(o, 0x32a)) {
                    o = object_at(host, rd32(self, 0xc17));
                    if ((int32_t)x <= (int32_t)rd32(o, 0x332)) {
                        call1(host, 0x4ad1e5, (uintptr_t)self, 0x2775);
                        return 1;
                    }
                }
            }
        }
    }
    return 0;
}

/* ---- 0x4aa0f0 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4aa0f0, thiscall, `ret 8`, arguments x then y as words (movsx); eax = 1 on a hit, else 0. Returns 0 at once when the byte [+0x45] is
 * zero. `ro` is the object of the record of the word [+0x21]. The outer rectangle (y low +0xeb, y high +0xf3, x low +0xe7, x high +0xef;
 * signed dwords, inclusive) arms (9, event 0x2771). Then a word counter i runs below the signed word ro[+0xf7] (not bounded, as in the
 * original); entry i is at ro + 0x15c * i: while the byte [+0x2b] is set and the byte 0x630a60[i] is zero its first rectangle (y low +0x10d,
 * y high +0x115, x low +0x109, x high +0x111) arms (0x16, event 0x276f); then, unless the dword [+0x25] == 2, its second rectangle (+0x249,
 * +0x251, +0x245, +0x24d) arms (0x16, event 0x2770); both store the word [+0x23] = i and return 1. */
int32_t m4aa0f0_hit_test(uint8_t *self, int16_t x, int16_t y, Fl24bWorld *world, const Fl18Host *host)
{
    const uint8_t *ro;
    uint32_t ro_addr = record_object_address(world, self, 0x21);
    int16_t i;
    if (self[0x45] == 0) return 0;
    ro = object_at(host, ro_addr);
    if ((int32_t)y >= (int32_t)rd32(ro, 0xeb) && (int32_t)y <= (int32_t)rd32(ro, 0xf3) && (int32_t)x >= (int32_t)rd32(ro, 0xe7) &&
        (int32_t)x <= (int32_t)rd32(ro, 0xef)) {
        arm_467740(world, 9, 0x2771);
        return 1;
    }
    for (i = 0; (int32_t)i < rds16(ro, 0xf7); i = (int16_t)(i + 1)) {
        ptrdiff_t e = (ptrdiff_t)((int32_t)i * 0x15c);
        if (self[0x2b] != 0 && world->bytes_630a60[(int32_t)i] == 0 && (int32_t)y >= (int32_t)rd32(ro, e + 0x10d) &&
            (int32_t)y <= (int32_t)rd32(ro, e + 0x115) && (int32_t)x >= (int32_t)rd32(ro, e + 0x109) && (int32_t)x <= (int32_t)rd32(ro, e + 0x111)) {
            arm_467740(world, 0x16, 0x276f);
            wr16(self, 0x23, (uint16_t)i);
            return 1;
        }
        if (rd32(self, 0x25) != 2 && (int32_t)y >= (int32_t)rd32(ro, e + 0x249) && (int32_t)y <= (int32_t)rd32(ro, e + 0x251) &&
            (int32_t)x >= (int32_t)rd32(ro, e + 0x245) && (int32_t)x <= (int32_t)rd32(ro, e + 0x24d)) {
            arm_467740(world, 0x16, 0x2770);
            wr16(self, 0x23, (uint16_t)i);
            return 1;
        }
    }
    return 0;
}

/* ---- 0x487ed5 ------------------------------------------------------------------------------------------------------------------ */

/* 0x487ed5, thiscall, plain `ret`: guards dword [+0x71] != 0, dword [+0x6c] == 1 and the record state of the word [+0x1e]. Event 0x2789 sets
 * the byte [+0x75] and the record state 2 and ends. Event 0x2788 steps the slot dword s at [+ k * 4 + 0x25] (k = the signed word [+0x66],
 * not bounds-checked) by the byte ro[+0x23] of the record object and the equality m of the signed word 0x583a29 with the signed word
 * ro[+0x447]: ro[+0x23] == 0: s == 0 -> byte [+0x65] = 1, word [+0x6a] += 1, s = 1; ro[+0x23] != 0: s == 0 and m -> s = 2 and `matched`;
 * s == 0 -> byte [+0x65] = 1, word [+0x6a] += 1, s = 1; s == 2 -> the same with s = 3; s == 1 and m -> s = 3 and `matched`. Then, when the
 * byte [+0x65] is non-zero (set here or before): word [+0x68] = word [+0x66], the queue words [+0x7a + 2j] = [+0x7c + 2j] for
 * j < ro[+0x425] - 1, word [+0x78 + 2 * ro[+0x425]] = k + 1, and with the flag 0x5bb1ca the nine bytes at ro+0x4ab against 0x54de04
 * announce the word ro[+0x4cc] through 0x4fb2e3 (this 0x5c3a67) when they differ; else when `matched`, the same with ro+0x4dc, 0x54de10 and
 * the word ro[+0x4fd]. Finally [+0x76] = GetTickCount + 0x1f4 and [+0x6c] = 0. */
void m487ed5_click_2788_2789(uint8_t *self, Fl24bWorld *world, const Fl18Host *host)
{
    uint32_t matched = 0;
    int32_t j;
    const uint8_t *ro;
    uint32_t ro_addr = record_object_address(world, self, 0x1e);
    if (rd32(self, 0x71) == 0) return;
    if (rd32(self, 0x6c) != 1) return;
    if (!record_state_is_1(world, self, 0x1e)) return;
    if (world->value_5c39e5 == 0x2789) {
        self[0x75] = 1;
        set_record_state_2(world, self, 0x1e);
        return;
    }
    if (world->value_5c39e5 != 0x2788) return;
    ro = object_at(host, ro_addr);
    if (ro[0x23] == 0) {
        if (rd32(self, rds16(self, 0x66) * 4 + 0x25) == 0) {
            self[0x65] = 1;
            wr16(self, 0x6a, (uint16_t)(rd16(self, 0x6a) + 1));
            wr32(self, rds16(self, 0x66) * 4 + 0x25, 1);
        }
    } else if (rd32(self, rds16(self, 0x66) * 4 + 0x25) == 0 && (int32_t)(int16_t)world->value_583a29 == rds16(ro, 0x447)) {
        matched = 1;
        wr32(self, rds16(self, 0x66) * 4 + 0x25, 2);
    } else if (rd32(self, rds16(self, 0x66) * 4 + 0x25) == 0) {
        self[0x65] = 1;
        wr16(self, 0x6a, (uint16_t)(rd16(self, 0x6a) + 1));
        wr32(self, rds16(self, 0x66) * 4 + 0x25, 1);
    } else if (rd32(self, rds16(self, 0x66) * 4 + 0x25) == 2) {
        self[0x65] = 1;
        wr16(self, 0x6a, (uint16_t)(rd16(self, 0x6a) + 1));
        wr32(self, rds16(self, 0x66) * 4 + 0x25, 3);
    } else if (rd32(self, rds16(self, 0x66) * 4 + 0x25) == 1 && (int32_t)(int16_t)world->value_583a29 == rds16(ro, 0x447)) {
        wr32(self, rds16(self, 0x66) * 4 + 0x25, 3);
        matched = 1;
    }
    if (self[0x65] != 0) {
        wr16(self, 0x68, rd16(self, 0x66));
        for (j = 0; j < rds16(ro, 0x425) - 1; j++) wr16(self, (ptrdiff_t)j * 2 + 0x7a, rd16(self, (ptrdiff_t)j * 2 + 0x7c));
        wr16(self, (ptrdiff_t)rds16(ro, 0x425) * 2 + 0x78, (uint16_t)(rds16(self, 0x66) + 1));
        if (world->value_5bb1ca != 0 && !nine_bytes_equal(ro + 0x4ab, world->bytes_54de04)) call1(host, 0x4fb2e3, 0x5c3a67, rd16(ro, 0x4cc));
    } else if (matched != 0) {
        if (world->value_5bb1ca != 0 && !nine_bytes_equal(ro + 0x4dc, world->bytes_54de10)) call1(host, 0x4fb2e3, 0x5c3a67, rd16(ro, 0x4fd));
    }
    wr32(self, 0x76, host->tick(host->context) + 0x1f4);
    wr32(self, 0x6c, 0);
}

/* ---- 0x464c59 ------------------------------------------------------------------------------------------------------------------ */

/* 0x464c59, thiscall, plain `ret`: guards dword [+0xb8] != 0, byte [+0xc1] == 0, dword [+0xbd] == 0, the record state of the word [+0x1e].
 * 0x27cc: byte [+0xbc] = 1 and the state 2. 0x27cb / 0x27ca: the signed word [+0x8a] counts up to 3 and wraps to 0 / counts down and wraps to
 * 3, then 0x464fff and 0x4641bb. 0x27c9: with [+0x2a] set 0x464faa and [+0x2e] = 1; with [+0x2a] still set and the signed words [+0x36] ==
 * [+0x38] the selection ends ([+0x2a] = 0, [+0x36] = 0xffff); otherwise [+0x36] = [+0x38], the words [+0xd2] / [+0xd4] get the differences of
 * dwords of the record object entry [+0x36] * 32 ((+0x69) - (+0x61), (+0x6d) - (+0x65)), 0x464f55, [+0x2a] = 1, [+0x32] = 1 and the 16 bytes
 * of the entry at +0x61 are copied to [+0x7a]. 0x27cd: 0x464faa, [+0x8c] != 0 moves to [+0x90] = 1 / [+0x8c] = 0, else a set [+0x90] is
 * cleared, the dword [+ k * 4 + 0x94] = 1 (k the signed word [+0x36], unchecked), [+0x2a] = 0, 0x4641bb, [+0x2e] = 1, [+0x36] = 0xffff,
 * 0x465075. A callee that changes self is not exercised. */
void m464c59_click_27c9_27cd(uint8_t *self, Fl24bWorld *world, const Fl18Host *host)
{
    const uint8_t *ro;
    ptrdiff_t t;
    uint32_t ro_addr = record_object_address(world, self, 0x1e);
    if (rd32(self, 0xb8) == 0) return;
    if (self[0xc1] != 0) return;
    if (rd32(self, 0xbd) != 0) return;
    if (!record_state_is_1(world, self, 0x1e)) return;
    if (world->value_5c39e5 == 0x27cc) {
        self[0xbc] = 1;
        set_record_state_2(world, self, 0x1e);
        return;
    }
    if (world->value_5c39e5 == 0x27cb) {
        if (rds16(self, 0x8a) < 3) wr16(self, 0x8a, (uint16_t)(rd16(self, 0x8a) + 1));
        else wr16(self, 0x8a, 0);
        call0(host, 0x464fff, (uintptr_t)self);
        call0(host, 0x4641bb, (uintptr_t)self);
        return;
    }
    if (world->value_5c39e5 == 0x27ca) {
        if (rds16(self, 0x8a) > 0) wr16(self, 0x8a, (uint16_t)(rd16(self, 0x8a) - 1));
        else wr16(self, 0x8a, 3);
        call0(host, 0x464fff, (uintptr_t)self);
        call0(host, 0x4641bb, (uintptr_t)self);
        return;
    }
    if (world->value_5c39e5 == 0x27c9) {
        if (rd32(self, 0x2a) != 0) {
            call0(host, 0x464faa, (uintptr_t)self);
            wr32(self, 0x2e, 1);
        }
        if (rd32(self, 0x2a) != 0 && rds16(self, 0x36) == rds16(self, 0x38)) {
            wr32(self, 0x2a, 0);
            wr16(self, 0x36, 0xffff);
            return;
        }
        wr16(self, 0x36, rd16(self, 0x38));
        ro = object_at(host, ro_addr);
        t = (ptrdiff_t)(rds16(self, 0x36) * 32);
        wr16(self, 0xd2, (uint16_t)(rd32(ro, t + 0x69) - rd32(ro, t + 0x61)));
        t = (ptrdiff_t)(rds16(self, 0x36) * 32);
        wr16(self, 0xd4, (uint16_t)(rd32(ro, t + 0x6d) - rd32(ro, t + 0x65)));
        call0(host, 0x464f55, (uintptr_t)self);
        wr32(self, 0x2a, 1);
        wr32(self, 0x32, 1);
        t = (ptrdiff_t)(rds16(self, 0x36) * 32);
        wr32(self, 0x7a, rd32(ro, t + 0x61));
        wr32(self, 0x7e, rd32(ro, t + 0x65));
        wr32(self, 0x82, rd32(ro, t + 0x69));
        wr32(self, 0x86, rd32(ro, t + 0x6d));
        return;
    }
    if (world->value_5c39e5 != 0x27cd) return;
    call0(host, 0x464faa, (uintptr_t)self);
    if (rd32(self, 0x8c) != 0) {
        wr32(self, 0x90, 1);
        wr32(self, 0x8c, 0);
    } else if (rd32(self, 0x90) != 0) {
        wr32(self, 0x90, 0);
    }
    wr32(self, (ptrdiff_t)rds16(self, 0x36) * 4 + 0x94, 1);
    wr32(self, 0x2a, 0);
    call0(host, 0x4641bb, (uintptr_t)self);
    wr32(self, 0x2e, 1);
    wr16(self, 0x36, 0xffff);
    call0(host, 0x465075, (uintptr_t)self);
}

/* FL24B-END */
