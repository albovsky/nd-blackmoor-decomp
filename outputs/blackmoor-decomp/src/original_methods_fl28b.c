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
