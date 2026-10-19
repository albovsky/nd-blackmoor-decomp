#include "original_methods_fl23b.h"

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

/* a signed word, sign-extended (movsx) */
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

static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    uintptr_t args[3];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 3) : 0;
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
static int record_state_is_1(const Fl23bWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    return rd32(world->records_5bb5e5, rec_offset(self, idx_off) + 0x4d) == 1;
}

/* `mov dword [n * 0x8d + 0x5bb632], 2` (the index word is read again, as the original does) */
static void set_record_state_2(const Fl23bWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    wr32(world->records_5bb5e5, rec_offset(self, idx_off) + 0x4d, 2);
}

/* `mov eax, [n * 0x8d + 0x5bb5e5]`: the original address of the object of record n */
static uint32_t record_object_address(const Fl23bWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    return rd32(world->records_5bb5e5, rec_offset(self, idx_off));
}

/* ---- 0x4a1efd ------------------------------------------------------------------------------------------------------------------ */

/* 0x4a1efd, thiscall, plain `ret`: only event 0x2760 stores, and only while [+0x60] is set and byte [+0x58] and dword [+0x4c] are clear
 * and the record of the word [+0x1e] is in state 1. */
void m4a1efd_click_2760(uint8_t *self, const Fl23bWorld *world)
{
    if (rd32(self, 0x60) == 0) return;
    if (self[0x58] != 0) return;
    if (rd32(self, 0x4c) != 0) return;
    if (!record_state_is_1(world, self, 0x1e)) return;
    if (world->value_5c39e5 != 0x2760) return;
    self[0x4b] = 1;
    wr32(self, 0x4c, 3);
}

/* ---- 0x4ba4f2 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4ba4f2: event 0x276a. The dword [+0x2d4] indexes two dwords of the object at +0x24 + 8 * n and +0x28 + 8 * n, unchecked (a signed
 * dword here; the original adds it to the object address in 32 bits). The deadline is GetTickCount plus the dword at +0x8ec of the
 * object whose address is the dword [+0x18]; the index is read again after the tick, as the original does. */
void m4ba4f2_click_276a(uint8_t *self, const Fl23bWorld *world, const Fl18Host *host)
{
    uint32_t n, t;
    if (rd32(self, 0x34) == 0) return;
    if (!record_state_is_1(world, self, 6)) return;
    if (world->value_5c39e5 != 0x276a) return;
    n = rd32(self, 0x2d4);
    wr32(self, (ptrdiff_t)(int32_t)n * 8 + 0x24, 1);
    t = host->tick(host->context);
    t += rd32(object_at(host, rd32(self, 0x18)), 0x8ec);
    n = rd32(self, 0x2d4);
    wr32(self, (ptrdiff_t)(int32_t)n * 8 + 0x28, t);
    call1(host, 0x4fb2e3, 0x5c3a67, 0x17);
}

/* ---- 0x46957d ------------------------------------------------------------------------------------------------------------------ */

/* 0x46957d: event 0x272e with the word [+0x548] equal to 0x64 (movsx word, compared with 0x64) while [+0x55c] and [+0x158] are set and
 * [+0x54a] is clear: clears [+0x158], sets [+0x54a]. */
void m46957d_click_272e(uint8_t *self, const Fl23bWorld *world)
{
    if (rd32(self, 0x55c) == 0) return;
    if (rd32(self, 0x158) == 0) return;
    if (rd32(self, 0x54a) != 0) return;
    if (!record_state_is_1(world, self, 0x7e)) return;
    if (world->value_5c39e5 != 0x272e) return;
    if (rds16(self, 0x548) != 0x64) return;
    wr32(self, 0x158, 0);
    wr32(self, 0x54a, 1);
}

/* ---- 0x4b45ed ------------------------------------------------------------------------------------------------------------------ */

/* 0x4b45ed: event 0x2739 with the word [+0x750] zero (movsx word, tested): sets [+0x77e] and moves the record of the word [+0x728] to
 * state 2. Guards: [+0x76e] set, [+0x77a] and [+0x772] clear. */
void m4b45ed_click_2739(uint8_t *self, const Fl23bWorld *world)
{
    if (rd32(self, 0x76e) == 0) return;
    if (rd32(self, 0x77a) != 0) return;
    if (rd32(self, 0x772) != 0) return;
    if (!record_state_is_1(world, self, 0x728)) return;
    if (world->value_5c39e5 != 0x2739) return;
    if (rds16(self, 0x750) != 0) return;
    wr32(self, 0x77e, 1);
    set_record_state_2(world, self, 0x728);
}

/* ---- 0x473ffc ------------------------------------------------------------------------------------------------------------------ */

/* 0x473ffc: first, unconditionally, [+0x76] = the original address of the object of the record of the word [+0xc]. Then, while [+0x7a]
 * is set, [+0x10], [+0x82] and [+0x7e] are clear and the record is in state 1, it calls 0x4e26fc (this = self + 0x1a6, no argument,
 * plain `ret`) and stops when that returns non-zero; otherwise event 0x27a1 sets [+0x7e] and moves the record to state 2. */
void m473ffc_click_27a1(uint8_t *self, const Fl23bWorld *world, const Fl18Host *host)
{
    wr32(self, 0x76, record_object_address(world, self, 0xc));
    if (rd32(self, 0x7a) == 0) return;
    if (rd32(self, 0x10) != 0) return;
    if (!record_state_is_1(world, self, 0xc)) return;
    if (rd32(self, 0x82) != 0) return;
    if (rd32(self, 0x7e) != 0) return;
    if (call0(host, 0x4e26fc, (uintptr_t)(self + 0x1a6)) != 0) return;
    if (world->value_5c39e5 != 0x27a1) return;
    wr32(self, 0x7e, 1);
    set_record_state_2(world, self, 0xc);
}

/* ---- 0x48e851 ------------------------------------------------------------------------------------------------------------------ */

/* 0x48e851 (it saves edi for the string scan): guards [+0x462] set, byte [+0x45a] and dword [+0x452] clear, record of the word [+0x1e] in
 * state 1. Event 0x27b9: byte [+0x451] = 1, [+0x452] = 8. Event 0x27b8: the 17-byte string at [+0x200 + 0x11 * word [+0x3fe]] is
 * cleared (four dwords and the byte at +0x10) when it is not empty (repne scasb for the terminator, read here as its first byte), then
 * the word [+0x3fe] is replaced by the word [+0x431]. */
void m48e851_click_27b8_27b9(uint8_t *self, const Fl23bWorld *world)
{
    if (rd32(self, 0x462) == 0) return;
    if (self[0x45a] != 0) return;
    if (rd32(self, 0x452) != 0) return;
    if (!record_state_is_1(world, self, 0x1e)) return;
    if (world->value_5c39e5 == 0x27b9) {
        self[0x451] = 1;
        wr32(self, 0x452, 8);
    } else if (world->value_5c39e5 == 0x27b8) {
        ptrdiff_t at = rds16(self, 0x3fe) * 0x11 + 0x200;
        if (self[at] != 0) {
            wr32(self, at, 0);
            wr32(self, at + 4, 0);
            wr32(self, at + 8, 0);
            wr32(self, at + 0xc, 0);
            self[at + 0x10] = 0;
        }
        wr16(self, 0x3fe, rd16(self, 0x431));
    }
}

/* ---- 0x45e587 ------------------------------------------------------------------------------------------------------------------ */

/* 0x45e587: guards byte [+0x321] set, byte [+0x2aa] clear, dword [+0x39e] not 0xa, record of the word [+0x1e] in state 1. Event 0x27ef:
 * byte [+0x39d] = 1 and the record moves to state 2. Event 0x27ec: [+0x39e] = 5. Event 0x27ed: calls 0x45e6bd (thiscall, this = self,
 * `ret 0xc`: a dword, a pointer to self + 0x326, the word 1), then bytes [+0x299] and [+0x298] = 1 and [+0x3a2] = 5. */
void m45e587_click_27ec_27ef(uint8_t *self, const Fl23bWorld *world, const Fl18Host *host)
{
    if (self[0x321] == 0) return;
    if (self[0x2aa] != 0) return;
    if (rd32(self, 0x39e) == 0xa) return;
    if (!record_state_is_1(world, self, 0x1e)) return;
    if (world->value_5c39e5 == 0x27ef) {
        self[0x39d] = 1;
        set_record_state_2(world, self, 0x1e);
    } else if (world->value_5c39e5 == 0x27ec) {
        wr32(self, 0x39e, 5);
    } else if (world->value_5c39e5 == 0x27ed) {
        call3(host, 0x45e6bd, (uintptr_t)self, (uint32_t)(rd32(self, 0x31d) + 0xba3u), (uintptr_t)(self + 0x326), 1);
        self[0x299] = 1;
        self[0x298] = 1;
        wr32(self, 0x3a2, 5);
    }
}

/* ---- 0x48ab49 ------------------------------------------------------------------------------------------------------------------ */

/* 0x48ab49 (locals: the record's object address, read at entry; esi and edi saved for the nine-byte compare): guards [+0x1aa] set, byte
 * [+0x1af] and dword [+0x1b6] clear, record of the word [+0x1e] in state 1. Event 0x2757: byte [+0x1ae] = 1, record to state 2. Event
 * 0x2756: [+0x44] = 1, word [+0x48] = word [+0x1b0], [+0x4a] = tick + word [object + 0x3a6] (sign-extended), [+0x4e] = 0; when 0x5bb1ca
 * is set and the nine bytes at object + 0x344 differ from those at 0x54e364, 0x4f6334 (this 0x5cf1eb, the sign-extended word at
 * object + 0x365) is asked and, when it answers 0, 0x4fb2e3 (this 0x5c3a67, that word) is called. */
void m48ab49_click_2756_2757(uint8_t *self, const Fl23bWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = record_object_address(world, self, 0x1e);
    if (rd32(self, 0x1aa) == 0) return;
    if (self[0x1af] != 0) return;
    if (rd32(self, 0x1b6) != 0) return;
    if (!record_state_is_1(world, self, 0x1e)) return;
    if (world->value_5c39e5 == 0x2757) {
        self[0x1ae] = 1;
        set_record_state_2(world, self, 0x1e);
    } else if (world->value_5c39e5 == 0x2756) {
        uint32_t t;
        wr32(self, 0x44, 1);
        wr16(self, 0x48, rd16(self, 0x1b0));
        t = host->tick(host->context);
        t += (uint32_t)rds16(object_at(host, rec_va), 0x3a6);
        wr32(self, 0x4a, t);
        wr32(self, 0x4e, 0);
        if (world->value_5bb1ca != 0 && !nine_bytes_equal(object_at(host, rec_va) + 0x344, world->bytes_54e364)) {
            uint32_t v = (uint32_t)rds16(object_at(host, rec_va), 0x365);
            if (call1(host, 0x4f6334, 0x5cf1eb, v) == 0) call1(host, 0x4fb2e3, 0x5c3a67, rd16(object_at(host, rec_va), 0x365));
        }
    }
}

/* ---- 0x4ab899 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4ab899: guards [+0x54] set, byte [+0x59] and dword [+0x5e] clear, record of the word [+0x1e] in state 1. Event 0x27d0: byte [+0x58]
 * = 1, record to state 2. Event 0x27ce: [+0x24] = 1, word [+0x28] = 0x27ce, [+0x2a] = tick + 0xfa, [+0x2e] = 1; with 0x5bb1ca set and the
 * nine bytes at object + 0xab7 different from those at 0x550fb8: 0x4fb2e3 with the word at object + 0xad8. Event 0x27cf: with 0x5bb1ca
 * set and the nine bytes at object + 0xb19 different from those at 0x550fc4: 0x4fb2e3 with the word at object + 0xb3a; then [+0x5e] = 2
 * and byte [+0x3a] = 1 (whether or not it was announced). */
void m4ab899_click_27ce_27d0(uint8_t *self, const Fl23bWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = record_object_address(world, self, 0x1e);
    if (rd32(self, 0x54) == 0) return;
    if (self[0x59] != 0) return;
    if (rd32(self, 0x5e) != 0) return;
    if (!record_state_is_1(world, self, 0x1e)) return;
    if (world->value_5c39e5 == 0x27d0) {
        self[0x58] = 1;
        set_record_state_2(world, self, 0x1e);
    } else if (world->value_5c39e5 == 0x27ce) {
        wr32(self, 0x24, 1);
        wr16(self, 0x28, 0x27ce);
        wr32(self, 0x2a, host->tick(host->context) + 0xfa);
        wr32(self, 0x2e, 1);
        if (world->value_5bb1ca != 0 && !nine_bytes_equal(object_at(host, rec_va) + 0xab7, world->bytes_550fb8))
            call1(host, 0x4fb2e3, 0x5c3a67, rd16(object_at(host, rec_va), 0xad8));
    } else if (world->value_5c39e5 == 0x27cf) {
        if (world->value_5bb1ca != 0 && !nine_bytes_equal(object_at(host, rec_va) + 0xb19, world->bytes_550fc4))
            call1(host, 0x4fb2e3, 0x5c3a67, rd16(object_at(host, rec_va), 0xb3a));
        wr32(self, 0x5e, 2);
        self[0x3a] = 1;
    }
}

/* ---- 0x4574e4 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4574e4: guards [+0x3e] set, [+0x24] clear, record of the word [+0x1e] in state 1. Event 0x27bd: [+0x3a] = 1, record to state 2.
 * Event 0x27be: word [+0x2a] = word [+0x42]. Event 0x27bc: [+0x2c] = 1, word [+0x30] = word [+0x42], [+0x32] = tick + 0xfa, [+0x36] = 1;
 * with 0x5bb1ca set and the nine bytes at object + 0x31 * word [+0x42] + 0x197 different from those at 0x54a3a8: 0x4f6334 (this
 * 0x5cf1eb, the sign-extended word at object + 0x31 * word [+0x42] + 0x1b8) and, when it answers 0, 0x4fb2e3 (that word). The word
 * [+0x42] is read again at each use, as in the original. */
void m4574e4_click_27bc_27be(uint8_t *self, const Fl23bWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = record_object_address(world, self, 0x1e);
    if (rd32(self, 0x3e) == 0) return;
    if (rd32(self, 0x24) != 0) return;
    if (!record_state_is_1(world, self, 0x1e)) return;
    if (world->value_5c39e5 == 0x27bd) {
        wr32(self, 0x3a, 1);
        set_record_state_2(world, self, 0x1e);
    } else if (world->value_5c39e5 == 0x27be) {
        wr16(self, 0x2a, rd16(self, 0x42));
    } else if (world->value_5c39e5 == 0x27bc) {
        wr32(self, 0x2c, 1);
        wr16(self, 0x30, rd16(self, 0x42));
        wr32(self, 0x32, host->tick(host->context) + 0xfa);
        wr32(self, 0x36, 1);
        if (world->value_5bb1ca != 0 &&
            !nine_bytes_equal(object_at(host, rec_va) + rds16(self, 0x42) * 0x31 + 0x197, world->bytes_54a3a8)) {
            uint32_t v = (uint32_t)rds16(object_at(host, rec_va), rds16(self, 0x42) * 0x31 + 0x1b8);
            if (call1(host, 0x4f6334, 0x5cf1eb, v) == 0)
                call1(host, 0x4fb2e3, 0x5c3a67, rd16(object_at(host, rec_va), rds16(self, 0x42) * 0x31 + 0x1b8));
        }
    }
}

/* ---- 0x47a03c ------------------------------------------------------------------------------------------------------------------ */

/* 0x47a03c: guards [+0x157a] set, [+0x1576], [+0x24] and [+0x1528] clear, record of the word [+0x1e] in state 1. Event 0x279d: [+0x157e]
 * = 1, record to state 2. Event 0x279c with the word [+0x159a] non-zero: [+0x1528] = 1, word [+0x152c] = word [+0x159a], [+0x152e] =
 * tick + 0xfa, [+0x1532] = 1; with 0x5bb1ca set and the nine bytes at object + 0x1f5 different from those at 0x54cb8c: 0x4f6334 (this
 * 0x5cf1eb, the sign-extended word at object + 0x216) and, when it answers 0, 0x4fb2e3 (that word). */
void m47a03c_click_279c_279d(uint8_t *self, const Fl23bWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = record_object_address(world, self, 0x1e);
    if (rd32(self, 0x157a) == 0) return;
    if (rd32(self, 0x1576) != 0) return;
    if (rd32(self, 0x24) != 0) return;
    if (rd32(self, 0x1528) != 0) return;
    if (!record_state_is_1(world, self, 0x1e)) return;
    if (world->value_5c39e5 == 0x279d) {
        wr32(self, 0x157e, 1);
        set_record_state_2(world, self, 0x1e);
    } else if (world->value_5c39e5 == 0x279c) {
        if (rds16(self, 0x159a) == 0) return;
        wr32(self, 0x1528, 1);
        wr16(self, 0x152c, rd16(self, 0x159a));
        wr32(self, 0x152e, host->tick(host->context) + 0xfa);
        wr32(self, 0x1532, 1);
        if (world->value_5bb1ca != 0 && !nine_bytes_equal(object_at(host, rec_va) + 0x1f5, world->bytes_54cb8c)) {
            uint32_t v = (uint32_t)rds16(object_at(host, rec_va), 0x216);
            if (call1(host, 0x4f6334, 0x5cf1eb, v) == 0) call1(host, 0x4fb2e3, 0x5c3a67, rd16(object_at(host, rec_va), 0x216));
        }
    }
}

/* ---- 0x4b2a9e ------------------------------------------------------------------------------------------------------------------ */

/* 0x4b2a9e: guards [+0x1515] set, [+0x151d] and [+0x24] clear, record of the word [+0x1e] in state 1. Event 0x2793: [+0x1519] = 1,
 * record to state 2. Event 0x2792: with 0x5bb1ca set and the nine bytes at object + 0x2d6 different from those at 0x551764: 0x4fb77a
 * (this 0x5c3a67, the original address object + 0x2d6) then 0x4fb2e3 (the word at object + 0x2f7); then [+0x1537] = tick + 0x1f4,
 * byte [+0x1510] = 1, [+0x24] = 3. Any other event: when the word [+0x1531] is non-zero, [+0x24] = 2 and, with 0x5bb1ca set and the
 * nine bytes at object + 0x274 different from those at 0x551770, 0x4fb2e3 (the word at object + 0x295). All three arms then end with
 * word [+0x1535] = word [+0x1531]. (The original tests the word [+0x1531] a second time at 0x4b2bd6 with nothing between that could
 * change it; that test cannot fail after the first passed, and is kept as in the original.) */
void m4b2a9e_click_2792_2793(uint8_t *self, const Fl23bWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = record_object_address(world, self, 0x1e);
    if (rd32(self, 0x1515) == 0) return;
    if (rd32(self, 0x151d) != 0) return;
    if (rd32(self, 0x24) != 0) return;
    if (!record_state_is_1(world, self, 0x1e)) return;
    if (world->value_5c39e5 == 0x2793) {
        wr32(self, 0x1519, 1);
        set_record_state_2(world, self, 0x1e);
    } else if (world->value_5c39e5 == 0x2792) {
        if (world->value_5bb1ca != 0 && !nine_bytes_equal(object_at(host, rec_va) + 0x2d6, world->bytes_551764)) {
            call1(host, 0x4fb77a, 0x5c3a67, (uint32_t)(rec_va + 0x2d6u));
            call1(host, 0x4fb2e3, 0x5c3a67, rd16(object_at(host, rec_va), 0x2f7));
        }
        wr32(self, 0x1537, host->tick(host->context) + 0x1f4);
        self[0x1510] = 1;
        wr32(self, 0x24, 3);
    } else if (rds16(self, 0x1531) != 0) {
        wr32(self, 0x24, 2);
        if (rds16(self, 0x1531) != 0 && world->value_5bb1ca != 0 &&
            !nine_bytes_equal(object_at(host, rec_va) + 0x274, world->bytes_551770))
            call1(host, 0x4fb2e3, 0x5c3a67, rd16(object_at(host, rec_va), 0x295));
    }
    wr16(self, 0x1535, rd16(self, 0x1531));
}
