#include "original_methods_fl28b.h"

#include <string.h>

static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
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

static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    const uintptr_t a[2] = {a0, a1};
    return callv(host, callee, this_ptr, a, 2);
}

static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    const uintptr_t a[3] = {a0, a1, a2};
    return callv(host, callee, this_ptr, a, 3);
}

static uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3)
{
    const uintptr_t a[4] = {a0, a1, a2, a3};
    return callv(host, callee, this_ptr, a, 4);
}

/* calls with five and six stack arguments */
static uint32_t call5(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3, uintptr_t a4)
{
    const uintptr_t a[5] = {a0, a1, a2, a3, a4};
    return callv(host, callee, this_ptr, a, 5);
}

static uint32_t call6(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3, uintptr_t a4, uintptr_t a5)
{
    const uintptr_t a[6] = {a0, a1, a2, a3, a4, a5};
    return callv(host, callee, this_ptr, a, 6);
}

/* the object of an original address (an address that an object keeps), as host memory */
static uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

/* `imul reg, slot, 0x16` on the sign-extended word, then the table base [self + 0x1c]: the offset of the entry of `slot` */
static ptrdiff_t entry_off(int32_t slot)
{
    return (ptrdiff_t)(int32_t)((uint32_t)slot * 0x16u) + 0x1c;
}

/* ---- 0x41e043 ------------------------------------------------------------------------------------------------------------------ */

/* 0x41e043, thiscall: see the header. [ebp-8] is `self`, [ebp-4] the word counter. */
int32_t m41e043_find_free_slot(const uint8_t *self)
{
    int16_t i;
    if (!(rds16(self, 0x68e) < rds16(self, 0x696))) return (int16_t)0xffff;
    for (i = 0; (int32_t)i < rds16(self, 0x696); i = (int16_t)(i + 1))
        if (rds16(self, entry_off(i)) == -1) return i;
    return (int16_t)0xffff;
}

/* ---- 0x42e493 ------------------------------------------------------------------------------------------------------------------ */

/* 0x42e493, cdecl: see the header. */
void m42e493_take_pending(Fl28bWorld *world, const Fl18Host *host)
{
    if (world->word_5c3a05 == 0x270f) {
        call3(host, 0x52139c, 0, 0x5459dc, 0, 0);
        call0(host, 0x4c97b4, 0x5cf659);
        return;
    }
    world->value_5bb57b = (uint32_t)(int32_t)world->word_5c3a07;
    world->value_5bb57f = (uint32_t)(int32_t)world->word_5c3a07;
    world->word_5bb599 = world->word_5c3a09;
    world->word_5bb595 = world->word_5c3a0b;
    world->value_5bb59b = world->value_5c3a0f;
    world->value_5bb59f = world->value_5c3a13;
    world->value_5bb5a3 = world->value_5c3a17;
    world->word_5c39ff = 1;
    world->value_5bb1ca = (int32_t)world->word_5c3a0d == 1 ? 0 : 1;
    world->value_583999 = 4;
    world->word_5c3a05 = 0x270f;
    world->word_5c3a07 = 0x270f;
}

/* ---- 0x41de29 ------------------------------------------------------------------------------------------------------------------ */

/* The part shared by 0x41de29 and 0x41e250 after the word is set to 0xffff: free the owned pointer, then the four dword calls. `at` is the offset of the entry
 * (`[ebp-8] * 0x16 + 0x1c`). */
static void free_entry(uint8_t *self, ptrdiff_t at, const Fl18Host *host)
{
    int16_t j;
    if (rd32(self, at + 2) != 0) {
        uint32_t p = rd32(self, at + 2);
        call1(host, 0x51dc6c, 0, p);
        wr32(self, at + 2, 0);
    }
    for (j = 0; j < 4; j = (int16_t)(j + 1)) call1(host, 0x4c2e5b, 0x5cf659, rd32(self, at + 6 + 4 * (ptrdiff_t)j));
}

/* 0x41de29, thiscall: see the header. [ebp-0x10] is `self`, [ebp-8] the word i, [ebp-4] the word j. */
void m41de29_clear_slots(uint8_t *self, const Fl18Host *host)
{
    int16_t i;
    wr16(self, 0x68e, 0);
    wr16(self, 0x694, 0xffff);
    for (i = 0; (int32_t)i < 0x4b; i = (int16_t)(i + 1)) {
        wr16(self, entry_off(i), 0xffff);
        free_entry(self, entry_off(i), host);
    }
}

/* ---- 0x41e250 ------------------------------------------------------------------------------------------------------------------ */

/* 0x41e250, thiscall, `ret 4`: see the header. [ebp-0xc] is `self`, [ebp+8] the slot dword. */
void m41e250_release_slot(uint8_t *self, uint32_t slot, const Fl18Host *host)
{
    int16_t count;
    int32_t s = (int16_t)(slot & 0xffffu);
    if (rds16(self, entry_off(s)) == -1) return;
    wr16(self, entry_off(s), 0xffff);
    free_entry(self, entry_off(s), host);
    count = (int16_t)(rd16(self, 0x68e) - 1);
    wr16(self, 0x68e, (uint16_t)count);
    if (rds16(self, 0x68e) < 0) wr16(self, 0x68e, 0);
}

/* ---- 0x4edfaf ------------------------------------------------------------------------------------------------------------------ */

/* `mov eax, hi; sub eax, lo; add eax, 1; cdq; sub eax, edx; sar eax, 1`: (hi - lo + 1) / 2 truncated toward zero, then lo + that - half / 2 */
static uint32_t centre(uint32_t lo, uint32_t hi, int32_t extent)
{
    int32_t span = (int32_t)(hi - lo + 1u);
    return lo + (uint32_t)(span / 2) - (uint32_t)(extent / 2);
}

/* 0x4edfaf, thiscall, `ret 4`: see the header. [ebp-4] is `self`, [ebp-0xc] the kind. */
void m4edfaf_centre_rect(uint8_t *self, uint32_t arg, const Fl28bWorld *world, const Fl18Host *host)
{
    (void)arg;
    if (rd32(self, 0x4af) != 3) {
        wr32(self, 0x689, centre(rd32(self, 0x1c), rd32(self, 0x24), world->word_5b3790));
        wr32(self, 0x68d, centre(rd32(self, 0x20), rd32(self, 0x28), world->word_5b3792));
    } else {
        wr32(self, 0x689, centre(rd32(self, 0x665), rd32(self, 0x66d), world->word_5b3790));
        wr32(self, 0x68d, centre(rd32(self, 0x669), rd32(self, 0x671), world->word_5b3792));
    }
    call2(host, 0x4db993, 0x5830ce, rd32(self, 0x689), rd32(self, 0x68d));
}

/* ---- 0x41e0b4 ------------------------------------------------------------------------------------------------------------------ */

/* 0x41e0b4, thiscall, `ret 8`: see the header. [ebp-8] is `self`, [ebp-0xc] the kind byte, [ebp-4] the word i. */
void m41e0b4_add_slot(uint8_t *self, uint32_t slot, uint32_t id, const Fl18Host *host)
{
    int32_t s = (int16_t)(slot & 0xffffu);
    int32_t w = (int16_t)(id & 0xffffu);
    uint8_t kind;
    if (!(rds16(self, 0x68e) < rds16(self, 0x696)) || rds16(self, entry_off(s)) != -1) {
        call3(host, 0x52139c, 0, 0x5437fc, 0, 0);
        call0(host, 0x4c97b4, 0x5cf659);
    }
    kind = self[0x75a];
    if (kind == 0x39 || kind == 0x3b || kind == 0x3e) {
        int16_t i;
        for (i = 0; (int32_t)i < rds16(self, 0xf9b); i = (int16_t)(i + 1)) {
            uint32_t first = rd16(self, 0xfb5 + 2 * (ptrdiff_t)i);
            uint32_t ptr = rd32(self, 0xfa1) + (uint32_t)w * 0x8cu + (uint32_t)(int32_t)i * 0x21u;
            call3(host, 0x417b04, 0x5d2f31, first, ptr, rd32(self, entry_off(s) + 6 + 4 * (ptrdiff_t)i));
        }
    } else {
        call3(host, 0x52139c, 0, 0x54384c, 0, 0);
        call0(host, 0x4c97b4, 0x5cf659);
    }
    wr16(self, entry_off(s), (uint16_t)id);
    wr16(self, 0x68e, (uint16_t)(rd16(self, 0x68e) + 1u));
}

/* ---- 0x4205c1 ------------------------------------------------------------------------------------------------------------------ */

/* the original address of record `slot` (`movsx eax, word [ebp+8]; imul eax, eax, 0x8d; mov ecx, [eax + 0x5bb5e5]`) */
static uint32_t record_address(const Fl28bWorld *world, uint32_t slot)
{
    return rd32(world->records_5bb5e5, (ptrdiff_t)(int32_t)((uint32_t)(int32_t)(int16_t)(slot & 0xffffu) * 0x8du));
}

/* 0x4205c1, thiscall, `ret 4`: see the header. [ebp-0xc] is `self`, [ebp-8] the record address, [ebp-4] the word i, [ebp-0x10] the kind byte. */
void m4205c1_run_entries(uint8_t *self, uint32_t slot, const Fl28bWorld *world, const Fl18Host *host)
{
    uint32_t rec = record_address(world, slot);
    uint32_t e;
    int16_t i;
    uint8_t b;
    for (i = 0; (int32_t)i < rds16(object_at(host, rec), 0x793); i = (int16_t)(i + 1)) {
        uint8_t *ent;
        uint32_t r;
        e = rd32(object_at(host, rec), 0x795) + (uint32_t)(int32_t)i * 0x1d1u;
        ent = object_at(host, e);
        r = call3(host, 0x420737, (uintptr_t)self, rd32(ent, 2), rd16(ent, 0), (uintptr_t)(self + 0x78e));
        if ((int16_t)r == 0) continue;
        e = rd32(object_at(host, rec), 0x795) + (uint32_t)(int32_t)i * 0x1d1u;
        b = object_at(host, e)[0x1b7];
        if (b == 0) call1(host, 0x41fa11, (uintptr_t)self, e);
        else if (b == 1) call1(host, 0x41fd08, (uintptr_t)self, e);
        else if (b == 2) call1(host, 0x42028e, (uintptr_t)self, e);
    }
    if (object_at(host, rec)[0x779] != 0x14) call0(host, rd32(self, 0xf23 + 4 * (ptrdiff_t)object_at(host, rec)[0x779]), rec);
    if (object_at(host, rec)[0x77a] != 0x14) call0(host, rd32(self, 0xf4b + 4 * (ptrdiff_t)object_at(host, rec)[0x77a]), object_at(host, rec)[0x77a]);
}

/* ---- 0x4209e8 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4209e8, thiscall, `ret 4`: see the header. */
void m4209e8_run_small_entries(uint8_t *self, uint32_t slot, const Fl28bWorld *world, const Fl18Host *host)
{
    uint32_t rec = record_address(world, slot);
    uint32_t e;
    int16_t i;
    for (i = 0; (int32_t)i < rds16(object_at(host, rec), 0x79f); i = (int16_t)(i + 1)) {
        uint8_t *ent;
        uint32_t r;
        uint8_t kind;
        e = rd32(object_at(host, rec), 0x7a1) + (uint32_t)(int32_t)i * 10u;
        ent = object_at(host, e);
        r = call3(host, 0x420737, (uintptr_t)self, rd32(ent, 2), rd16(ent, 0), (uintptr_t)(self + 0x7c0));
        if ((int16_t)r == 0) continue;
        e = rd32(object_at(host, rec), 0x7a1) + (uint32_t)(int32_t)i * 10u;
        ent = object_at(host, e);
        kind = ent[6];
        if (kind == 1) {
            if (world->word_63a4cd != 0) {
                call4(host, 0x50ca3e, 0, (uintptr_t)(self + 0x1fd1), 0x543b34, (uint32_t)rds16(ent, 7), ent[9]);
                call1(host, 0x44a2b7, 0, (uintptr_t)(self + 0x1fd1));
            }
            ent = object_at(host, e);
            wr32(world->dwords_585801, 4 * (ptrdiff_t)rds16(ent, 7), ent[9]);
        } else if (kind == 2) {
            if (ent[9] == 1) call2(host, 0x4e9e84, 0x571442, rd16(ent, 7), 1);
            else call1(host, 0x4ea06c, 0x571442, rd16(ent, 7));
        }
    }
}

/* ---- 0x4f6ef4 ------------------------------------------------------------------------------------------------------------------ */

/* The library routine __ftol at 0x50ce04 (called with the value on the x87 stack): fnstcw / fldcw with the rounding control forced to truncation, `fistp qword`, and eax = the low dword of the 64-bit result.
 * A NaN, an infinity or a value outside the 64-bit range gives the integer indefinite 0x8000000000000000, whose low dword is 0. */
static uint32_t ftol_low_dword(double value)
{
    if (value != value) return 0;
    if (value >= 9223372036854775808.0 || value < -9223372036854775808.0) return 0;
    return (uint32_t)(int64_t)value;
}

/* 0x4f6ef4, thiscall, `ret 4`: see the header. [ebp-0x10] is `self`, [ebp-0xc] the record address, [ebp-8] the value v, [ebp-4] n. */
uint32_t m4f6ef4_advance_record(uint8_t *self, uint32_t arg, const Fl28bWorld *world, const Fl18Host *host)
{
    uint32_t rec, n, v;
    int32_t low, high;
    wr32(self, 0x3c2, 0x3e8);
    rec = rd32(self, 0x3ce) + arg * 0x5bbu;
    v = 0;
    if (call0(host, 0x4f709c, (uintptr_t)self) == 0) {
        wr32(self, 0x3c2, 0x3ea);
        return 0xffffffffu;
    }
    if (rd32(object_at(host, rec), 0x162) == 0 || rd32(object_at(host, rec), 0x28f) == 0) {
        wr32(self, 0x3c2, 0x3ef);
        return 0xffffffffu;
    }
    if (call1(host, 0x4f6334, (uintptr_t)self, arg) == 0) return 0xffffffffu;
    n = call1(host, 0x4f81fa, (uintptr_t)self, arg);
    if (n == 0xffffffffu) {
        if (world->word_63a4cd != 0) {
            call4(host, 0x50ca3e, 0, 0x63888b, 0x55e994, arg, rec + 4);
            call1(host, 0x44a2b7, 0, 0x63888b);
        }
        wr32(self, 0x3c2, 0x410);
        return 0xffffffffu;
    }
    if ((int32_t)n > 0) {
        /* fild dword, fstp dword (a single-precision float each), fld, fdiv in 53-bit precision (control word 0x27f), __ftol */
        float count = (float)(int32_t)n;
        float divisor = (float)(int32_t)rd32(object_at(host, rec), 0x176);
        v = ftol_low_dword((double)count / (double)divisor);
    } else {
        v = 0;
    }
    low = (int32_t)rd32(object_at(host, rec), 0x182);
    if ((int32_t)v <= low) v = (uint32_t)low;
    high = (int32_t)(rd32(object_at(host, rec), 0x17a) - 1u);
    if (high < (int32_t)v) v = (uint32_t)high;
    wr32(object_at(host, rec), 0x17e, v);
    wr32(object_at(host, rec), 0x182, v);
    return rd32(object_at(host, rec), 0x17e);
}

/* ---- 0x41c544 ------------------------------------------------------------------------------------------------------------------ */

/* the string with its terminator, `repne scasb` for the length, then `rep movsd` / `rep movsb` forward */
static void copy_string(uint8_t *dst, const uint8_t *src)
{
    size_t n = 0, i;
    while (src[n] != 0) n++;
    n++;
    for (i = 0; i + 4 <= n; i += 4) wr32(dst, (ptrdiff_t)i, rd32(src, (ptrdiff_t)i));
    for (; i < n; i++) dst[i] = src[i];
}

/* 0x41c544, thiscall, `ret 8`: see the header. [ebp-8] is `self`, [ebp+8] `rec`, [ebp+0xc] `src`, [ebp-4] the result of 0x423259. The constants are the strings of the original at 0x5431b0 / 0x5431fc / 0x543240. */
void m41c544_init_record(uint8_t *self, uint8_t *rec, const uint8_t *src, const Fl28bWorld *world, const Fl18Host *host)
{
    static const char dummy[] = "dummy";
    static const char missing[] = "<i>Missing conversation text (please contact Tech Support)<n><o>";
    uint32_t s;
    copy_string(rec + 0x747, (const uint8_t *)dummy);
    wr16(rec, 0x768, 0xd);
    wr16(rec, 0x76a, 2);
    wr16(rec, 0x76c, 1);
    wr16(rec, 0x76e, 1);
    wr32(rec, 0x770, 1);
    rec[0x778] = 0;
    rec[0x77c] = 2;
    wr16(rec, 0x781, 0);
    wr16(rec, 0x783, 1);
    wr32(rec, 0x785, 0);
    wr32(rec, 0x789, 0);
    wr32(rec, 0x78d, 1);
    wr16(rec, 0x791, 2);
    rec[0x779] = src[0x21];
    rec[0x77a] = src[0x22];
    rec[0x77b] = src[0x23];
    wr16(rec, 0x77d, rd16(src, 0x24));
    wr16(rec, 0x77f, rd16(src, 0x26));
    s = call1(host, 0x423259, (uintptr_t)(self + 0xfd1), (uintptr_t)src);
    if (s == 0) {
        if (world->word_63a4cd != 0) {
            call4(host, 0x50ca3e, 0, 0x63888b, 0x5431b8, (uintptr_t)src, world->value_5bb57b);
            call3(host, 0x52139c, 0, 0x63888b, 0, 0);
            copy_string(rec + 0x16b, (const uint8_t *)missing);
        } else {
            copy_string(rec + 0x16b, (const uint8_t *)missing);
        }
    } else {
        copy_string(rec + 0x16b, object_at(host, s));
    }
    wr16(rec, 0x793, rd16(src, 0x28));
    wr16(rec, 0x799, 0);
    wr32(rec, 0x79b, 0);
}

/* ---- 0x41fa11 ------------------------------------------------------------------------------------------------------------------ */

/* 0x41fa11, thiscall, `ret 4`: see the header. [ebp-0xc] is `self`, [ebp+8] `arg`, [ebp-8] the block pointer p, [ebp-4] the word j. */
void m41fa11_add_entry(uint8_t *self, const uint8_t *arg, const Fl28bWorld *world, const Fl18Host *host)
{
    int16_t j;
    uint32_t p;
    ptrdiff_t b;
    size_t k;
    if (world->word_63a4cd != 0 && rds16(self, 0xf21) + 1 > 0x1e) {
        call3(host, 0x50ca3e, 0, 0x63888b, 0x543a58, (uint32_t)(rds16(self, 0xf21) + 1));
        call1(host, 0x4264e8, 0x583979, 0x63888b);
    }
    if (rds16(self, 0xf21) + 1 > 0x1e) return;
    for (j = 0; (int32_t)j < rds16(self, 0xf21); j = (int16_t)(j + 1)) {
        uintptr_t slot = (uintptr_t)(self + 0xea5 + 4 * (ptrdiff_t)j);
        p = call1(host, 0x51ea75, slot, 0x190);
        if (call3(host, 0x50d550, 0, p, (uintptr_t)(arg + 6), 0x190) == 0) {
            call1(host, 0x51eac4, slot, 0xffffffffu);
            return;
        }
        call1(host, 0x51eac4, slot, 0xffffffffu);
    }
    {
        uintptr_t slot = (uintptr_t)(self + 0xea5 + 4 * (ptrdiff_t)rds16(self, 0xf21));
        uint8_t *dst;
        p = call1(host, 0x51ea75, slot, 0x190);
        dst = object_at(host, p);
        for (k = 0; k < 0x64; k++) wr32(dst, (ptrdiff_t)(4 * k), rd32(arg, 6 + (ptrdiff_t)(4 * k)));
        call1(host, 0x51eac4, (uintptr_t)(self + 0xea5 + 4 * (ptrdiff_t)rds16(self, 0xf21)), 0xffffffffu);
    }
    b = (ptrdiff_t)(int32_t)((uint32_t)(int32_t)rds16(self, 0xf21) * 0x3au);
    wr16(self, b + 0x800, rd16(arg, 0x1be));
    b = (ptrdiff_t)(int32_t)((uint32_t)(int32_t)rds16(self, 0xf21) * 0x3au);
    wr16(self, b + 0x7fe, rd16(arg, 0x1bc));
    b = (ptrdiff_t)(int32_t)((uint32_t)(int32_t)rds16(self, 0xf21) * 0x3au);
    wr16(self, b + 0x7fa, rd16(arg, 0x1b8));
    wr16(self, b + 0x7fc, rd16(arg, 0x1ba));
    wr32(self, b + 0x802, rd32(arg, 0x1c0));
    wr32(self, b + 0x806, rd32(arg, 0x1c4));
    wr32(self, b + 0x80a, rd32(arg, 0x1c8));
    copy_string(self + b + 0x7d9, arg + 0x196);
    wr16(self, b + 0x80e, rd16(arg, 0x1cc));
    self[b + 0x810] = arg[0x1ce];
    wr16(self, b + 0x811, rd16(arg, 0x1cf));
    wr16(self, 0xf21, (uint16_t)(rd16(self, 0xf21) + 1u));
}

/* ---- 0x422a0a ------------------------------------------------------------------------------------------------------------------ */

static void copy16(uint32_t *dst, const uint8_t *src)
{
    int k;
    for (k = 0; k < 4; k++) dst[k] = rd32(src, 4 * k);
}

/* 0x422a0a, cdecl: see the header. [ebp-0x24] is rec, [ebp-4] the word i, [ebp-8] the word j, [ebp-0x20] obj, [ebp-0xc] sub; l1c at [ebp-0x1c], l44 at [ebp-0x44], l34 at [ebp-0x34]. */
void m422a0a_draw_marked(Fl28bWorld *world, const Fl18Host *host)
{
    uint8_t *rec = world->table_617804 + (ptrdiff_t)(int32_t)((uint32_t)(int32_t)world->word_617e78 * 0x16u);
    uint8_t kind = world->byte_617f42;
    int16_t i, j;
    if (kind == 0x39 || kind == 0x3b || kind == 0x3e) {
        for (i = 0; (int32_t)i < world->word_618783; i = (int16_t)(i + 1)) {
            for (j = 0; (int32_t)j < world->word_618783; j = (int16_t)(j + 1)) {
                uint32_t l1c[4], l34[4], l44[4];
                const uint8_t *obj;
                uint8_t *tbl, *sub;
                uint32_t sub_addr;
                ptrdiff_t entry = 16 * (ptrdiff_t)j;
                tbl = object_at(host, world->value_618795);
                if ((int32_t)tbl[j + 0xb2] != (int32_t)i) continue;
                obj = world->objs_5d34d1 + (ptrdiff_t)(int32_t)((uint32_t)(int32_t)(int16_t)rd16(world->words_61879d, 2 * (ptrdiff_t)j) * 0x84du);
                sub_addr = rd32(rec, 6 + 4 * (ptrdiff_t)j);
                if (obj[0x1e] > 3) break;
                sub = object_at(host, sub_addr);    /* the original never dereferences the sub-object on the sel > 3 path */
                memset(l1c, 0, sizeof l1c);
                memset(l34, 0, sizeof l34);
                memset(l44, 0, sizeof l44);
                if (obj[0x1e] != 2) {
                    tbl = object_at(host, world->value_618795);
                    if (tbl[j + 0xb6] == 2) {
                        copy16(l1c, tbl + entry + 0xba);
                        l44[1] = rd32(tbl, entry + 0xfe) + world->value_58318a;
                        l44[3] = rd32(tbl, entry + 0x106) + world->value_58318a;
                        l44[0] = rd32(tbl, entry + 0xfa) + world->value_583186;
                        l44[2] = rd32(tbl, entry + 0x102) + world->value_583186;
                        copy16(l34, tbl + entry + 0xfa);
                    } else {
                        copy16(l1c, sub + 0x35);
                        l44[1] = rd32(sub, 0x49) + world->value_58318a;
                        l44[3] = rd32(sub, 0x51) + world->value_58318a;
                        l44[0] = rd32(sub, 0x45) + world->value_583186;
                        l44[2] = rd32(sub, 0x4d) + world->value_583186;
                        copy16(l34, sub + 0x45);
                    }
                    if (obj[0x1f] == 1) {
                        call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, (uintptr_t)l34, (uintptr_t)l44, 0x544330);
                        call6(host, 0x4c609b, 0x5cf659, rd32(sub, 0), world->value_5cf665, (uintptr_t)l1c, (uintptr_t)l44, (uint32_t)rds16(sub, 0x2f), 0x54434c);
                    } else if (obj[0x1f] == 2) {
                        call6(host, 0x4c5770, 0x5cf659, rd32(sub, 0), world->value_5cf665, (uintptr_t)l1c, (uintptr_t)l44, (uint32_t)rds16(sub, 0x2f), 0x544368);
                    }
                } else {
                    l44[1] = rd32(sub, 0x49) + world->value_58318a;
                    l44[3] = rd32(sub, 0x51) + world->value_58318a;
                    l44[0] = rd32(sub, 0x45) + world->value_583186;
                    l44[2] = rd32(sub, 0x4d) + world->value_583186;
                    call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, 0x617ec2u + (uint32_t)entry, 0x617f02u + (uint32_t)entry, 0x544388);
                    if (obj[0x1f] == 1) {
                        call6(host, 0x4c609b, 0x5cf659, rd32(sub, 0), world->value_5cf665, sub_addr + 0x35, (uintptr_t)l44, (uint32_t)rds16(sub, 0x2f), 0x5443a4);
                    } else if (obj[0x1f] == 2) {
                        call6(host, 0x4c5770, 0x5cf659, rd32(sub, 0), world->value_5cf665, sub_addr + 0x35, (uintptr_t)l44, (uint32_t)rds16(sub, 0x2f), 0x5443c0);
                    }
                    {
                        int k;
                        for (k = 0; k < 4; k++) wr32(world->rects_617ec2, entry + 4 * k, rd32(sub, 0x45 + 4 * k));
                        for (k = 0; k < 4; k++) wr32(world->rects_617f02, entry + 4 * k, l44[k]);
                    }
                }
                break;      /* 0x422e20 -> 0x422e27 -> 0x422a4a: the first matching j ends the inner loop, i goes on */
            }
        }
    }
    world->value_5d191d = 0;
}
