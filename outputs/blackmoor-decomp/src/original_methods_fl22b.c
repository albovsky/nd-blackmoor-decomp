#include "original_methods_fl22b.h"

#include <string.h>

#if defined(__GNUC__) || defined(__clang__)
#define UNUSED_OK __attribute__((unused))
#else
#define UNUSED_OK
#endif

UNUSED_OK static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

UNUSED_OK static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

UNUSED_OK static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

UNUSED_OK static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* a signed word, sign-extended (movsx) */
UNUSED_OK static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

UNUSED_OK static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, NULL, 0) : 0;
}

UNUSED_OK static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    uintptr_t args[1];
    args[0] = a0;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 1) : 0;
}

UNUSED_OK static uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2,
                                uintptr_t a3)
{
    uintptr_t args[4];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    args[3] = a3;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 4) : 0;
}

/* the object of an original address (an address that a record keeps), as host memory */
UNUSED_OK static const uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return host->resolve(host->context, address);
}

/* repe cmpsb with ecx = 9: 1 when the nine bytes at a and b are equal */
UNUSED_OK static int nine_bytes_equal(const uint8_t *a, const uint8_t *b)
{
    int k;
    for (k = 0; k < 9; k++)
        if (a[k] != b[k]) return 0;
    return 1;
}

/* ---- 0x42ed54 ------------------------------------------------------------------------------------------------------------------ */

/* The record n (stride 0x8d) of 0x5bb5e5: its object address is read again at every use, as the original does after each call. */
#define REC_VA(world, rec_off) rd32((world)->records_5bb5e5, (rec_off))
#define REC_OBJ(world, host, rec_off) object_at((host), REC_VA((world), (rec_off)))

/* the two 16-entry tables at 0x5b5128 (bytes) and 0x5b5138 (words) are cleared to 0 and 0xffff (the loop of the original, int16 counter) */
static void clear_tables_42ed54(Fl22bWorld *world)
{
    int16_t i;
    for (i = 0; i < 0x10; i = (int16_t)(i + 1)) {
        world->bytes_5b5128[i] = 0;
        wr16(world->words_5b5138, (ptrdiff_t)i * 2, 0xffffu);
    }
}

/* the stores of one block of a record (selector, two words, a third word, three dwords, a flag word) to the globals 0x5bb57b.. that the
 * original does in the same order in both of its arms; `base` is the offset of the selector in the record object */
static void load_block_42ed54(Fl22bWorld *world, const uint8_t *rec, ptrdiff_t base)
{
    world->value_5bb57b = (uint32_t)rds16(rec, base);
    world->word_5bb599 = rd16(rec, base + 2);
    world->word_5bb595 = rd16(rec, base + 4);
    world->word_5c39ff = rd16(rec, base + 6);
    world->value_5bb59b = rd32(rec, base + 8);
    world->value_5bb59f = rd32(rec, base + 0xc);
    world->value_5bb5a3 = rd32(rec, base + 0x10);
    world->value_5bb1ca = rds16(rec, base + 0x14) == 1 ? 0u : 1u;
    world->value_583999 = 4;
}

/* 0x42ed54: one step of the state machine of record `index` (a word argument; the dword at +0x4d of the record is the state 0, 1 or 2; the
 * dword 0x5b5162 is the sub-step of state 1, a jump table of four arms at 0x42f500). cdecl, `ret` pops nothing. State 0 calls the CRT
 * rand() (0x50cd50, a host call: the idiv by 5 is done here), states 1 and 2 test GetTickCount. */
void m42ed54_run_state(int16_t index, Fl22bWorld *world, const Fl18Host *host)
{
    ptrdiff_t rec_off = (ptrdiff_t)index * 0x8d;
    uint32_t state = rd32(world->records_5bb5e5, rec_off + 0x4d);
    const uint8_t *rec;
    if (state == 0) {
        int32_t r;
        int16_t local;
        world->byte_5b5158 = 1;
        world->byte_5b516a = 0;
        world->value_5bb1ca = 1;
        world->word_5b5159 = (uint16_t)index;
        world->byte_5b515d = 0;
        r = (int32_t)call0(host, 0x50cd50, 0);
        local = (int16_t)(r % 5);   /* cdq; idiv ecx (5); the remainder's low word */
        if (local == 0 || local == 1) local = 2;
        rec = REC_OBJ(world, host, rec_off);
        world->word_5b5168 = (uint16_t)(rds16(rec, 0x223) + local);
        rec = REC_OBJ(world, host, rec_off);
        if ((int16_t)world->word_5b5168 > (int16_t)rd16(rec, 0x21)) {
            rec = REC_OBJ(world, host, rec_off);
            world->word_5b5168 = rd16(rec, 0x21);
        }
        clear_tables_42ed54(world);
        world->word_5b5166 = 0;
        call1(host, 0x4c2dfb, 0x5cf659, 0x5d03cf);
        world->value_5d03cf = call4(host, 0x4c2790, 0x5cf659, 0x545b40, REC_VA(world, rec_off), 6, 0x545b24);
        world->value_5d1a83 = world->value_5d03cf;
        world->value_5d1a8f = 1;
        rec = REC_OBJ(world, host, rec_off);
        if (!nine_bytes_equal(rec + 0x235, world->bytes_545b48)) call1(host, 0x4fb77a, 0x5c3a67, REC_VA(world, rec_off) + 0x235u);
        world->value_5b5162 = 0;
        wr32(world->records_5bb5e5, rec_off + 0x4d, 1);
    } else if (state == 1) {
        uint32_t step = world->value_5b5162;
        if (step > 3) return;
        switch (step) {
        case 0: {
            int16_t i;
            world->byte_5b516a = 1;
            for (i = 0;; i = (int16_t)(i + 1)) {
                rec = REC_OBJ(world, host, rec_off);
                if ((int32_t)i >= rds16(rec, 0x223)) break;
                rec = REC_OBJ(world, host, rec_off);
                if (rds16(world->words_5b5138, (ptrdiff_t)i * 2) != (int32_t)rec[0x225 + i]) {
                    world->byte_5b516a = 0;
                    break;
                }
            }
            if (world->byte_5b516a != 0) {
                world->value_5b5162 = 1;
            } else if ((int16_t)world->word_5b5166 >= (int16_t)world->word_5b5168) {
                clear_tables_42ed54(world);
                world->word_5b5166 = 0;
            }
            break;
        }
        case 1:
            rec = REC_OBJ(world, host, rec_off);
            if (rds16(rec, 0x27c) != -1) {
                uint32_t flag = rec[0x27e];
                rec = REC_OBJ(world, host, rec_off);
                wr32(world->flags_585801, (ptrdiff_t)rds16(rec, 0x27c) * 4, flag);
            }
            {
                uint32_t now = host->tick(host->context);
                rec = REC_OBJ(world, host, rec_off);
                world->value_5b515e = now + (uint32_t)(rds16(rec, 0x27f) * 0x3e8);
            }
            world->value_5b5162 = 2;
            break;
        case 2:
            if (host->tick(host->context) >= world->value_5b515e) {
                rec = REC_OBJ(world, host, rec_off);
                if (!nine_bytes_equal(rec + 0x281, world->bytes_545b54)) {
                    call1(host, 0x4fb77a, 0x5c3a67, REC_VA(world, rec_off) + 0x281u);
                    rec = REC_OBJ(world, host, rec_off);
                    call1(host, 0x4fb2e3, 0x5c3a67, rd16(rec, 0x2a2));
                    world->value_5b5162 = 3;
                } else {
                    wr32(world->records_5bb5e5, rec_off + 0x4d, 2);
                }
            }
            break;
        default: /* 3 */
            rec = REC_OBJ(world, host, rec_off);
            if (call1(host, 0x4f6334, 0x5cf1eb, (uint32_t)rds16(rec, 0x2a2)) == 0) {
                call1(host, 0x4fba69, 0x5c3a67, REC_VA(world, rec_off) + 0x281u);
                wr32(world->records_5bb5e5, rec_off + 0x4d, 2);
            }
            break;
        }
    } else if (state == 2) {
        world->value_5bb1ca = 1;
        world->byte_5b5158 = 0;
        call1(host, 0x4c2dfb, 0x5cf659, 0x5d03cf);
        world->value_5d1a8f = 0;
        rec = REC_OBJ(world, host, rec_off);
        if (!nine_bytes_equal(rec + 0x235, world->bytes_545b60)) call1(host, 0x4fba69, 0x5c3a67, REC_VA(world, rec_off) + 0x235u);
        rec = REC_OBJ(world, host, rec_off);
        if (world->byte_5b515d != 0) {
            if (rds16(rec, 0x2b2) != 0x270f) load_block_42ed54(world, rec, 0x2b2);
            rec = REC_OBJ(world, host, rec_off);
            if (rds16(rec, 0x2c8) != -1) wr32(world->flags_585801, (ptrdiff_t)rds16(rec, 0x2c8) * 4, rec[0x2ca]);
        } else if (rds16(rec, 0x266) != 0x270f) {
            load_block_42ed54(world, rec, 0x266);   /* (this arm stores no flag-table entry) */
        }
        call1(host, 0x42ba3a, 0, (uint16_t)index);   /* word argument, cdecl */
    } else {
        return;
    }
}
