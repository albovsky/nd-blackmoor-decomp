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
