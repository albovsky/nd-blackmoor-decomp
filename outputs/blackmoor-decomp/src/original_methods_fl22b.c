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

UNUSED_OK static uint32_t rd_u8(const uint8_t *base, ptrdiff_t off)
{
    return base[off];
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

UNUSED_OK static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    uintptr_t args[2];
    args[0] = a0;
    args[1] = a1;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 2) : 0;
}

UNUSED_OK static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    uintptr_t args[3];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 3) : 0;
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

/* four dwords, ascending, each read and written before the next (the unrolled 16-byte copy of the original) */
UNUSED_OK static void copy16(uint8_t *dst, const uint8_t *src)
{
    wr32(dst, 0, rd32(src, 0));
    wr32(dst, 4, rd32(src, 4));
    wr32(dst, 8, rd32(src, 8));
    wr32(dst, 0xc, rd32(src, 0xc));
}

/* the inlined strlen of the original (repne scasb): the number of bytes before the first zero */
UNUSED_OK static uint32_t string_length(const uint8_t *s)
{
    uint32_t n = 0;
    while (s[n] != 0) n++;
    return n;
}

/* ---- 0x47ff0e ------------------------------------------------------------------------------------------------------------------ */

#define OBJ47(rec_va) object_at(host, (rec_va))                      /* the record object [ebp-4], read through again at every use */
#define ITEM_N(self) ((ptrdiff_t)rds16((self), 0x1350))              /* the selected item (a signed word) */
#define ITEM(self, off) ((ptrdiff_t)0x7b6 + ITEM_N(self) * 0x25 + (off))   /* offset of field `off` of the selected item (stride 0x25) in self */

/* the two words at +0x13e3 and +0x13e5: the extent of the selected item (right - left, bottom - top, low words) */
static void store_item_extent_47ff0e(uint8_t *self)
{
    wr16(self, 0x13e3, (uint16_t)(rd32(self, ITEM(self, 8)) - rd32(self, ITEM(self, 0))));
    wr16(self, 0x13e5, (uint16_t)(rd32(self, ITEM(self, 0xc)) - rd32(self, ITEM(self, 4))));
}

/* The inlined strcpy of `text` (length + 1 bytes, by dwords then bytes) into the frame buffer of the original followed by the strcat of the
 * dword `suffix` at the terminator, and the call of 0x448d11. The original has 0xcc bytes below its local [ebp-0xc]; a text of more than 200
 * bytes would overwrite its locals, its saved registers and the return address, so it is rejected (returns 0), not copied. */
static int show_caption_47ff0e(const Fl22bWorld *world, const Fl18Host *host, const uint8_t *text, uint32_t suffix)
{
    uint8_t frame[0xcc];
    uint32_t len = string_length(text);
    if (len > 200u) return 0;
    memcpy(frame, text, len + 1u);
    wr32(frame, (ptrdiff_t)len, suffix);   /* mov [edi-1], eax over the terminator: four bytes at frame + len */
    call4(host, 0x448d11, 0x619a05, world->value_5d03b3, (uintptr_t)frame, 0xffffffffu, 0);
    return 1;
}

/* 0x47ff0e: `self` (ecx) is the object with the record index (word +0x1e), the item table (stride 0x25 from +0x7b6) and the counters (+0x7a0);
 * the dword 0x5c39e5 is the event (0x278d .. 0x2791). A thiscall method of 0xdc bytes of frame; `ret` pops nothing. */
int32_t m47ff0e_handle_click(uint8_t *self, Fl22bWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = rd32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d);   /* [ebp-4] */
    uint32_t lc = 0;                                                                       /* [ebp-0xc] */
    uint32_t sel;
    int16_t w;
    if (rd32(self, 0x13c5) == 0) return FL22B_47FF0E_OK;
    if (self[0x13ce] != 0) return FL22B_47FF0E_OK;
    if (rd32(self, 0x13ca) != 0) return FL22B_47FF0E_OK;
    if (rd32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d + 0x4d) != 1) return FL22B_47FF0E_OK;
    sel = world->value_5c39e5;
    if (sel == 0x278f || sel == 0x2790) {
        wr32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d + 0x4d, 2);
        call0(host, 0x480b34, (uintptr_t)self);
        if (self[0x13ce] == 0) self[0x13c9] = 1;
        return FL22B_47FF0E_OK;
    }
    if (sel == 0x278e) {
        w = (int16_t)call0(host, 0x47e8fe, (uintptr_t)self);
        if (w == -1) return FL22B_47FF0E_OK;
        call1(host, 0x47fa11, (uintptr_t)self, (uint16_t)w);
        call0(host, 0x480abe, (uintptr_t)self);
        wr32(self, 0x1344, 1);
        wr16(self, 0x1350, (uint16_t)w);
        store_item_extent_47ff0e(self);
        return FL22B_47FF0E_OK;
    }
    if ((rd32(self, 0x1344) == 0 && sel == 0x278d) || (rd32(self, 0x1344) != 0 && self[0x13b1] != 0)) {
        /* 0x48013a: a click on an item */
        uint32_t kind;
        wr32(self, 0x1344, 1);
        if (self[0x13b0] != 0 && self[0x13b1] == 0) {
            w = (int16_t)call0(host, 0x47e9d3, (uintptr_t)self);
            wr16(self, 0x1350, (uint16_t)w);
            call1(host, 0x47fb76, (uintptr_t)self, (uint16_t)w);
            self[0x13b1] = 1;
            return FL22B_47FF0E_OK;
        }
        if (self[0x13b0] == 0) {
            w = (int16_t)call0(host, 0x47e9d3, (uintptr_t)self);
            wr16(self, 0x1350, (uint16_t)w);
        }
        kind = self[ITEM(self, 0x21)];
        if (rd_u8(OBJ47(rec_va), (ptrdiff_t)kind * 0x53 + 0xe9) != 0) {
            call3(host, 0x47e582, (uintptr_t)self, rd16(self, 0x13a2), self[ITEM(self, 0x21)], 1);
            call1(host, 0x47ed96, (uintptr_t)self, rd16(self, 0x13a2));
            wr16(self, 0x13a2, (uint16_t)(rd16(self, 0x13a2) + 1u));
        }
        self[0x13b1] = 0;
        wr32(self, 0x134c, 1);
        copy16(self + 0x1392, self + ITEM(self, 0));
        kind = self[ITEM(self, 0x21)];
        if (call1(host, 0x47e99e, (uintptr_t)self, rec_va + kind * 0x53u + 0xb9u) != 0) {
            kind = self[ITEM(self, 0x21)];
            copy16(self + ITEM(self, 0), OBJ47(rec_va) + (ptrdiff_t)kind * 0x53 + 0xb9);
        }
        call2(host, 0x47e52f, (uintptr_t)self, (uintptr_t)(self + ITEM(self, 0)), (uintptr_t)(self + ITEM(self, 0x10)));
        store_item_extent_47ff0e(self);
        kind = self[ITEM(self, 0x21)];
        if (self[0x7a0 + kind] > 0) {
            kind = self[ITEM(self, 0x21)];
            if (rd_u8(OBJ47(rec_va), (ptrdiff_t)kind * 0x53 + 0xe9) == 0) {
                kind = self[ITEM(self, 0x21)];
                self[0x7a0 + self[ITEM(self, 0x21)]] = (uint8_t)(self[0x7a0 + kind] - 1);
            }
        }
        call0(host, 0x4809a7, (uintptr_t)self);
        return FL22B_47FF0E_OK;
    }
    if (sel != 0x2791) return FL22B_47FF0E_OK;
    /* 0x480524: the release of the item */
    wr32(self, 0x1344, 0);
    wr32(self, 0x1348, 1);
    copy16(self + ITEM(self, 0), self + 0x1352);
    copy16(self + ITEM(self, 0x10), self + 0x1372);
    call1(host, 0x47ed96, (uintptr_t)self, rd16(self, 0x1350));
    if (rd32(self, 0x13df) != 0 && rd_u8(OBJ47(rec_va), 0x5e) != 2) {
        self[ITEM(self, 0x22)] = 1;
        self[0x7a0 + self[ITEM(self, 0x21)]] = (uint8_t)(self[0x7a0 + self[ITEM(self, 0x21)]] + 1);
        call0(host, 0x480a1d, (uintptr_t)self);
        wr16(self, 0x1350, 0xffffu);
        return FL22B_47FF0E_OK;
    }
    if (rd32(self, 0x13df) != 0 && rd_u8(OBJ47(rec_va), 0x5e) == 2) {
        self[0x7a0 + self[ITEM(self, 0x21)]] = (uint8_t)(self[0x7a0 + self[ITEM(self, 0x21)]] + 1);
        call0(host, 0x480a1d, (uintptr_t)self);
    } else if (!nine_bytes_equal(OBJ47(rec_va) + 0x7a8, world->bytes_54d5a4)) {
        uint32_t now;
        call1(host, 0x4fb2e3, 0x5c3a67, rd16(OBJ47(rec_va), 0x7c9));
        now = host->tick(host->context);
        wr32(self, 0x13e7, now + 0xc8u);
        wr32(self, 0x13ca, 1);
        if (world->value_5bb202 != 0) {
            if (string_length(OBJ47(rec_va) + 0x7d9) > 0) {
                lc = call1(host, 0x423259, 0x619a6b, rec_va + 0x7d9u);
                if (lc != 0) {
                    if (string_length(object_at(host, lc)) > 0x9c40u) {
                        lc = 0;
                    } else {
                        if (!show_caption_47ff0e(world, host, object_at(host, lc), world->dword_54d5b0)) return FL22B_47FF0E_REJECT_LONG_STRING;
                    }
                } else {
                    lc = 0;
                }
            }
            if (lc == 0 && string_length(OBJ47(rec_va) + 0x7fa) > 0) {
                if (!show_caption_47ff0e(world, host, OBJ47(rec_va) + 0x7fa, world->dword_54d5b4)) return FL22B_47FF0E_REJECT_LONG_STRING;
            }
        }
    }
    /* 0x4808af */
    self[ITEM(self, 0x22)] = 0;
    copy16(self + ITEM(self, 0), OBJ47(rec_va) + (ptrdiff_t)self[ITEM(self, 0x21)] * 0x53 + 0xa9);
    call2(host, 0x47e52f, (uintptr_t)self, (uintptr_t)(self + ITEM(self, 0)), (uintptr_t)(self + ITEM(self, 0x10)));
    self[ITEM(self, 0x20)] = 0;
    wr16(self, 0x1350, 0xffffu);
    return FL22B_47FF0E_OK;
}

/* ---- 0x4b64a9 ------------------------------------------------------------------------------------------------------------------ */

/* The record object [ebp-0x20] (the address kept in the record table at entry), read through again at every use. */
#define REC4B(rec_va) object_at(host, (rec_va))
/* offset in the table at 0x5d1591 of field `field` of the entry (0x4a bytes) of the slot that the session holds (the signed word +0x1c), read again at every use */
#define SLOT4B(self, field) ((ptrdiff_t)rds16((self), 0x1c) * 0x4a + (field))
/* the nine bytes "NO SOUND\0" of slot k of 0x551b5c (the compared constants lie 12 bytes apart) */
#define K4B(world, k) ((world)->bytes_551b5c + 12 * (k))

/* the call of 0x4b6355 (thiscall, ret 0x10): the arguments are the item index, two words and a pointer to four dwords (the local
 * [ebp-0x1c]) that the callee fills in; args[0] is the index (the last pushed) */
static void place_item_4b64a9(uint8_t *self, const Fl18Host *host, int32_t i, uint32_t w1, uint32_t w2, uint32_t *local)
{
    call4(host, 0x4b6355, (uintptr_t)self, (uint16_t)i, (uint16_t)w1, (uint16_t)w2, (uintptr_t)local);
}

/* the four dwords of the local go into the 16-byte item entry i of the session, in this order: [-0x18] -> +0x28, [-0x10] -> +0x30,
 * [-0x1c] -> +0x24, [-0x14] -> +0x2c */
static void store_item_4b64a9(uint8_t *self, int32_t i, const uint32_t *local)
{
    wr32(self, (ptrdiff_t)i * 16 + 0x28, local[1]);
    wr32(self, (ptrdiff_t)i * 16 + 0x30, local[3]);
    wr32(self, (ptrdiff_t)i * 16 + 0x24, local[0]);
    wr32(self, (ptrdiff_t)i * 16 + 0x2c, local[2]);
}

/* `for (i = 0; i < count; i++) word[self + 0x232 + 2*i] = value`: the count word of the record is read again at every test */
static void fill_flags_4b64a9(uint8_t *self, const Fl18Host *host, uint32_t rec_va, uint16_t value)
{
    int32_t i;
    for (i = 0; i < rds16(REC4B(rec_va), 0x21); i++) wr16(self, (ptrdiff_t)i * 2 + 0x232, value);
}

/* 0x4b6bfc / 0x4b6d16: the record goes to state 2 when its byte +0x2d6 is clear (the byte is read again) */
static void finish_step_4b64a9(uint8_t *self, Fl22bWorld *world, const Fl18Host *host, uint32_t rec_va)
{
    if (rd_u8(REC4B(rec_va), 0x2d6) == 0) wr32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d + 0x4d, 2);
}

/* 0x4b64a9: one step of the session object `self` (ecx) for the record `index` (a word). Record state (dword +0x4d) 0 sets the session up
 * (calls 0x4e8d96, 0x4b6355 for every item, 0x4d39f9, 0x4c2790, 0x4fb77a), 1 runs the step in self+0x274 (jump table of six arms at
 * 0x4b7029), 2 loads the globals 0x5bb57b.. from one of two blocks of the record and calls 0x42ba3a and 0x4b5bc8. The block load of
 * state 2 stores the same globals in the same order as in 0x42ed54 (load_block_42ed54). */
int32_t m4b64a9_run_scene(uint8_t *self, int16_t index, Fl22bWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = rd32(world->records_5bb5e5, (ptrdiff_t)index * 0x8d);       /* [ebp-0x20] */
    uint32_t state = rd32(world->records_5bb5e5, (ptrdiff_t)index * 0x8d + 0x4d); /* [ebp-0x34] */
    uint32_t local[4] = {0, 0, 0, 0};                                              /* [ebp-0x1c .. -0x10], filled in by 0x4b6355 */
    int32_t i;
    if (state == 0) {
        wr16(self, 0x1e, (uint16_t)index);
        wr32(self, 0x225, 1);   /* (the bytes +0x229 and +0x22a are overwritten below) */
        world->value_5bb1ca = 1;
        call0(host, 0x4e8d96, 0x571442);
        wr32(self, 0x254, 0);
        wr32(self, 0x258, 0);
        wr32(self, 0x25c, 0);
        wr32(self, 0x260, 0);
        for (i = 0; i < rds16(REC4B(rec_va), 0x21); i++) {
            ptrdiff_t o = (ptrdiff_t)i * 16;
            uint16_t w;
            wr32(self, o + 0x128, rd32(REC4B(rec_va), o + 0x4b) + world->value_58318a);
            wr32(self, o + 0x130, rd32(REC4B(rec_va), o + 0x53) + world->value_58318a);
            wr32(self, o + 0x124, rd32(REC4B(rec_va), o + 0x47) + world->value_583186);
            wr32(self, o + 0x12c, rd32(REC4B(rec_va), o + 0x4f) + world->value_583186);
            w = rd16(REC4B(rec_va), (ptrdiff_t)i * 2 + 0x27);   /* [ebp-8] */
            wr16(self, (ptrdiff_t)i * 2 + 0x254, rd16(REC4B(rec_va), (ptrdiff_t)i * 2 + 0x27));
            place_item_4b64a9(self, host, i, w, 0, local);
            store_item_4b64a9(self, i, local);
        }
        self[0x224] = 1;
        wr16(self, 0x1c, (uint16_t)call0(host, 0x4d39f9, 0));
        wr32(world->table_5d1591, SLOT4B(self, 0), 0xa);
        wr32(world->table_5d1591, SLOT4B(self, 4), 0x4b7051);
        wr32(world->table_5d1591, SLOT4B(self, 8), 0);
        wr32(world->table_5d1591, SLOT4B(self, 0xc), 0);
        wr32(world->table_5d1591, SLOT4B(self, 0x10), 0);
        wr32(world->table_5d1591, SLOT4B(self, 0x14), 1);
        wr32(world->table_5d1591, SLOT4B(self, 0x18), 1);
        wr16(world->table_5d1591, SLOT4B(self, 0x1c), 0);
        {   /* the inlined strcpy: length + 1 bytes of 0x551b24 into the entry at +0x22 */
            uint32_t len = string_length(world->string_551b24) + 1u;
            memcpy(world->table_5d1591 + SLOT4B(self, 0x22), world->string_551b24, len);
        }
        if (rd32(self, 0x20) == 0) wr32(self, 0x20, call4(host, 0x4c2790, 0x5cf659, 0x551b54, rec_va, 6, 0x551b3c));
        wr32(world->table_5d1591, SLOT4B(self, 8), rd32(self, 0x20));
        if (!nine_bytes_equal(REC4B(rec_va) + 0x2d9, K4B(world, 0))) call1(host, 0x4fb77a, 0x5c3a67, rec_va + 0x2d9u);
        if (!nine_bytes_equal(REC4B(rec_va) + 0x345, K4B(world, 1))) call1(host, 0x4fb77a, 0x5c3a67, rec_va + 0x345u);
        self[0x22a] = 0;
        self[0x229] = 0;
        wr16(self, 0x22c, 1);
        wr32(self, 0x274, 0);
        wr32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d + 0x4d, 1);
        return FL22B_4B64A9_OK;
    }
    if (state == 1) {
        uint32_t step = rd32(self, 0x274);
        if (step > 5) return FL22B_4B64A9_OK;
        switch (step) {
        case 0:   /* 0x4b6858 */
            if (self[0x22a] != 0)
                wr32(self, 0x274, 4);
            else
                call0(host, 0x4b642d, (uintptr_t)self);
            break;
        case 3:   /* 0x4b6883 */
            if (host->tick(host->context) < rd32(self, 0x22e)) break;
            wr32(self, 0x274, 2);
            if (self[0x22a] != 0 && !nine_bytes_equal(REC4B(rec_va) + 0x2d9, K4B(world, 2)))
                call1(host, 0x4fb2e3, 0x5c3a67, rd16(REC4B(rec_va), 0x2fa));
            break;
        case 2: { /* 0x4b68e3 */
            int32_t moved = 0;   /* [ebp-4] */
            self[0x224] = 1;
            for (i = 0; i < rds16(REC4B(rec_va), 0x21); i++) {
                ptrdiff_t at = (ptrdiff_t)i * 2;
                if (rds16(self, at + 0x232) == 0) continue;
                if (rds16(self, 0x22c) == rds16(REC4B(rec_va), 0x25)) {
                    moved = 1;
                    if (rds16(self, at + 0x254) == rds16(REC4B(rec_va), 0x23) - 1) {
                        place_item_4b64a9(self, host, i, 0, 0, local);
                        wr16(self, at + 0x254, 0);
                    } else {
                        place_item_4b64a9(self, host, i, rd16(self, at + 0x254), rd16(self, 0x22c), local);
                        wr16(self, at + 0x254, (uint16_t)(rd16(self, at + 0x254) + 1u));
                    }
                } else {
                    place_item_4b64a9(self, host, i, rd16(self, at + 0x254), rd16(self, 0x22c), local);
                }
                store_item_4b64a9(self, i, local);
            }
            if (moved != 0) {
                wr32(self, 0x274, 0);
                wr16(self, 0x22c, 1);
                if (self[0x22a] == 0) {
                    for (i = 0; i < rds16(REC4B(rec_va), 0x21); i++) wr16(self, (ptrdiff_t)i * 2 + 0x232, 0);
                }
            } else {
                uint32_t now = host->tick(host->context);
                int32_t numerator = rds16(REC4B(rec_va), 0x2d4) * 0x3e8;
                int32_t divisor = rds16(REC4B(rec_va), 0x25);
                if (divisor == 0) return FL22B_4B64A9_REJECT_DIVIDE_BY_ZERO;
                wr32(self, 0x22e, now + (uint32_t)(numerator / divisor));
                wr32(self, 0x274, 3);
                wr16(self, 0x22c, (uint16_t)(rd16(self, 0x22c) + 1u));
            }
            break;
        }
        case 1:   /* 0x4b6b03 */
            if (!nine_bytes_equal(REC4B(rec_va) + 0x345, K4B(world, 3))) {
                call1(host, 0x4fb2e3, 0x5c3a67, rd16(REC4B(rec_va), 0x366));
                wr32(self, 0x274, 5);
            } else if (rd_u8(REC4B(rec_va), 0x2d6) != 0 &&
                       call1(host, 0x4f6334, 0x5cf1eb, (uint32_t)rds16(REC4B(rec_va), 0x2fa)) == 0) {
                fill_flags_4b64a9(self, host, rec_va, 1);
                wr32(self, 0x274, 2);
                wr16(self, 0x22c, 1);
                self[0x22b] = 0;
                if (!nine_bytes_equal(REC4B(rec_va) + 0x2d9, K4B(world, 4))) call1(host, 0x4fb2e3, 0x5c3a67, rd16(REC4B(rec_va), 0x2fa));
            } else {
                finish_step_4b64a9(self, world, host, rec_va);
            }
            break;
        case 5:   /* 0x4b6c27 */
            if (call1(host, 0x4f6334, 0x5cf1eb, (uint32_t)rds16(REC4B(rec_va), 0x366)) != 0) break;
            call1(host, 0x4fba69, 0x5c3a67, rec_va + 0x345u);
            if (rd_u8(REC4B(rec_va), 0x2d6) != 0 &&
                call1(host, 0x4f6334, 0x5cf1eb, (uint32_t)rds16(REC4B(rec_va), 0x2fa)) == 0) {
                fill_flags_4b64a9(self, host, rec_va, 1);
                wr32(self, 0x274, 2);
                wr16(self, 0x22c, 1);
                self[0x22b] = 0;
                if (!nine_bytes_equal(REC4B(rec_va) + 0x2d9, K4B(world, 5))) call1(host, 0x4fb2e3, 0x5c3a67, rd16(REC4B(rec_va), 0x2fa));
            } else {
                finish_step_4b64a9(self, world, host, rec_va);
            }
            break;
        default: { /* 4: 0x4b6d41 */
            if (!(rds16(self, 0x254) < rds16(REC4B(rec_va), 0x23) - 1)) {
                int32_t limit = rds16(REC4B(rec_va), 0x2d7) * (rds16(REC4B(rec_va), 0x23) - 1) - 1;
                if ((int32_t)self[0x22b] >= limit) {
                    wr32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d + 0x4d, 2);
                    break;
                }
            }
            {   /* 0x4b6d82 */
                uint32_t now = host->tick(host->context);
                int32_t numerator = rds16(REC4B(rec_va), 0x2d4) * 0x1f40;
                int32_t divisor = rds16(REC4B(rec_va), 0x25);
                if (divisor == 0) return FL22B_4B64A9_REJECT_DIVIDE_BY_ZERO;
                wr32(self, 0x22e, now + (uint32_t)(numerator / divisor));
                wr32(self, 0x274, 3);
                self[0x22b] = (uint8_t)(self[0x22b] + 1u);
            }
            break;
        }
        }
        return FL22B_4B64A9_OK;
    }
    if (state == 2) {   /* 0x4b6dee */
        world->value_5bb1ca = 1;
        if (!nine_bytes_equal(REC4B(rec_va) + 0x2d9, K4B(world, 6))) call1(host, 0x4fba69, 0x5c3a67, rec_va + 0x2d9u);
        if (self[0x229] != 0) {
            if (rds16(REC4B(rec_va), 0x376) != 0x270f) load_block_42ed54(world, REC4B(rec_va), 0x376);
            if (rds16(REC4B(rec_va), 0x38c) != -1)
                wr32(world->flags_585801, (ptrdiff_t)rds16(REC4B(rec_va), 0x38c) * 4, rd_u8(REC4B(rec_va), 0x38e));
        } else if (self[0x22a] != 0) {
            if (rds16(REC4B(rec_va), 0x32a) != 0x270f) load_block_42ed54(world, REC4B(rec_va), 0x32a);
            if (rds16(REC4B(rec_va), 0x340) != -1)
                wr32(world->flags_585801, (ptrdiff_t)rds16(REC4B(rec_va), 0x340) * 4, rd_u8(REC4B(rec_va), 0x342));
        }
        call1(host, 0x42ba3a, 0, rd16(self, 0x1e));   /* word argument, cdecl */
        call0(host, 0x4b5bc8, (uintptr_t)self);
    }
    return FL22B_4B64A9_OK;
}
