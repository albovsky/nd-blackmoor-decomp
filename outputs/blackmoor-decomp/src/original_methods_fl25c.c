#include "original_methods_fl25c.h"

#include <string.h>

#if defined(__GNUC__) || defined(__clang__)
#define FL25C_UNUSED __attribute__((unused))
#else
#define FL25C_UNUSED
#endif

FL25C_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL25C_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL25C_UNUSED static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL25C_UNUSED static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* a signed word, sign-extended (movsx) */
FL25C_UNUSED static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

FL25C_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, NULL, 0) : 0;
}

FL25C_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    uintptr_t args[1];
    args[0] = a0;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 1) : 0;
}

FL25C_UNUSED static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    uintptr_t args[2];
    args[0] = a0;
    args[1] = a1;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 2) : 0;
}

FL25C_UNUSED static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    uintptr_t args[3];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 3) : 0;
}

FL25C_UNUSED static uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3)
{
    uintptr_t args[4];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    args[3] = a3;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 4) : 0;
}

/* the object of an original address (an address that a record keeps), as host memory */
FL25C_UNUSED static const uint8_t *object_at(const Fl18Host *host, uint32_t address)
{
    return host->resolve(host->context, address);
}

/* repe cmpsb with ecx = 9: 1 when the nine bytes at a and b are equal */
FL25C_UNUSED static int nine_bytes_equal(const uint8_t *a, const uint8_t *b)
{
    int k;
    for (k = 0; k < 9; k++)
        if (a[k] != b[k]) return 0;
    return 1;
}

/* `movsx ecx, word [self + idx]; imul ecx, ecx, 0x8d`: the byte offset of the record n in the table at 0x5bb5e5 */
FL25C_UNUSED static ptrdiff_t rec_offset(const uint8_t *self, ptrdiff_t idx_off)
{
    return (ptrdiff_t)(rds16(self, idx_off) * 0x8d);
}

/* `cmp dword [n * 0x8d + 0x5bb632], 1` */
FL25C_UNUSED static int record_state_is_1(const Fl25cWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    return rd32(world->records_5bb5e5, rec_offset(self, idx_off) + 0x4d) == 1;
}

/* `mov dword [n * 0x8d + 0x5bb632], 2` (the index word is read again, as the original does) */
FL25C_UNUSED static void set_record_state_2(const Fl25cWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    wr32(world->records_5bb5e5, rec_offset(self, idx_off) + 0x4d, 2);
}

/* `mov eax, [n * 0x8d + 0x5bb5e5]`: the original address of the object of record n */
FL25C_UNUSED static uint32_t record_object_address(const Fl25cWorld *world, const uint8_t *self, ptrdiff_t idx_off)
{
    return rd32(world->records_5bb5e5, rec_offset(self, idx_off));
}

/* `lea eax, [self + word[+0xe7a] * 0x36 + 0xa40]; + word[+0xe7c] * 6`: the byte offset of the 6-byte cell that two words of the object name */
FL25C_UNUSED static ptrdiff_t cell_offset_e7a(const uint8_t *self)
{
    return (ptrdiff_t)(rds16(self, 0xe7a) * 0x36) + 0xa40 + (ptrdiff_t)(rds16(self, 0xe7c) * 6);
}

/* a 6-byte cell copy, as the original does it: the dword first, then the word */
FL25C_UNUSED static void copy_cell(uint8_t *dst, ptrdiff_t doff, const uint8_t *src, ptrdiff_t soff)
{
    wr32(dst, doff, rd32(src, soff));
    wr16(dst, doff + 4, rd16(src, soff + 4));
}

/* ---- 0x4a8818 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4a8818, thiscall, plain `ret`: the click handler of events 0x279a / 0x2798 / 0x2799. `r` is the object of the record of the word
 * [+0x1e] (the dword [n * 0x8d + 0x5bb5e5]). Guards (each failing returns at once, nothing stored): the dword [+0xe72] non-zero, the BYTE
 * [+0xe83] zero, the dword [+0xe7f] zero, the record state (dword [n * 0x8d + 0x5bb632]) equal to 1. Then, by the dword [+0xe5e] and
 * the selector [0x5c39e5]:
 *   [+0xe5e] == 0 and 0x279a: byte [+0xe7e] = 1, the record state = 2;
 *   [+0xe5e] == 0 and 0x2798: [+0xe76] = 0, [+0xe5e] = 1, [+0xe56] = 1; with c = self + 0xa40 + word[+0xe7a] * 0x36 + word[+0xe7c] * 6 the
 *     six bytes at c go to [+0xe10] (dword, word) and the word at c becomes 0xfff6; when the dword 0x5bb1ca is non-zero and the nine bytes
 *     r[+0x375] differ from the constant at 0x550bac, 0x4f6334(this 0x5cf1eb, the sign-extended word r[+0x396]) runs and, when it
 *     returns 0, 0x4fb2e3(this 0x5c3a67, the word r[+0x396]);
 *   [+0xe5e] != 0 and 0x2799: the six bytes at c are saved, the six bytes at [+0xe10] go to c, [+0xe5a] = [+0xe62] = 1, the word [+0xe66] =
 *     the word [+0xe7c], the word [+0xe68] = the word [+0xe7a]; the same 0x5bb1ca test with r[+0x3a6] / 0x550bb8 / r[+0x3c7]; then when
 *     the saved first word is -10 (compared sign-extended) [+0xe5e] = 0 and 0x4a8bf2 runs (this = self), else [+0xe56] = 1 and the saved six
 *     bytes go to [+0xe10].
 * Every pass that gets this far (also an unrelated selector) then copies the 0x1e6 bytes at self + 0xa40 to the buffer at 0x5a110f; with
 * the dword [+0xe5e] zero it returns; else for i from 0 while i < the word r[+0x43], for j from 0 while j < the word r[+0x45], a cell at
 * 0x5a110f + i * 0x36 + j * 6 whose first word is -10 gets the six bytes at [+0xe10]. The counters are words (wrap at 16 bits, as in the
 * original); nothing is bounds checked. A callee that changes self is not exercised. */
void m4a8818_click_2798_279a(uint8_t *self, Fl25cWorld *world, const Fl18Host *host)
{
    uint32_t selector;
    const uint8_t *r = NULL;
    int16_t i, j;
    if (rd32(self, 0xe72) == 0) return;
    if (self[0xe83] != 0) return;
    if (rd32(self, 0xe7f) != 0) return;
    if (!record_state_is_1(world, self, 0x1e)) return;
    selector = world->value_5c39e5;
    if (rd32(self, 0xe5e) == 0 && selector == 0x279a) {
        self[0xe7e] = 1;
        set_record_state_2(world, self, 0x1e);
    } else if (rd32(self, 0xe5e) == 0 && selector == 0x2798) {
        r = object_at(host, record_object_address(world, self, 0x1e));
        wr32(self, 0xe76, 0);
        wr32(self, 0xe5e, 1);
        wr32(self, 0xe56, 1);
        copy_cell(self, 0xe10, self, cell_offset_e7a(self));
        wr16(self, cell_offset_e7a(self), 0xfff6);
        if (world->value_5bb1ca != 0) {
            if (!nine_bytes_equal(r + 0x375, world->bytes_550bac)) {
                if (call1(host, 0x4f6334, 0x5cf1eb, (uintptr_t)(uint32_t)rds16(r, 0x396)) == 0)
                    call1(host, 0x4fb2e3, 0x5c3a67, rd16(r, 0x396));
            }
        }
    } else if (rd32(self, 0xe5e) != 0 && selector == 0x2799) {
        uint32_t saved_dword;
        uint16_t saved_word;
        r = object_at(host, record_object_address(world, self, 0x1e));
        saved_dword = rd32(self, cell_offset_e7a(self));
        saved_word = rd16(self, cell_offset_e7a(self) + 4);
        copy_cell(self, cell_offset_e7a(self), self, 0xe10);
        wr32(self, 0xe5a, 1);
        wr32(self, 0xe62, 1);
        wr16(self, 0xe66, rd16(self, 0xe7c));
        wr16(self, 0xe68, rd16(self, 0xe7a));
        if (world->value_5bb1ca != 0) {
            if (!nine_bytes_equal(r + 0x3a6, world->bytes_550bb8)) {
                if (call1(host, 0x4f6334, 0x5cf1eb, (uintptr_t)(uint32_t)rds16(r, 0x3c7)) == 0)
                    call1(host, 0x4fb2e3, 0x5c3a67, rd16(r, 0x3c7));
            }
        }
        if ((int16_t)saved_dword == -10) {
            wr32(self, 0xe5e, 0);
            call0(host, 0x4a8bf2, (uintptr_t)self);
        } else {
            wr32(self, 0xe56, 1);
            wr32(self, 0xe10, saved_dword);
            wr16(self, 0xe14, saved_word);
        }
    }
    memcpy(world->buf_5a110f, self + 0xa40, 0x1e6);
    if (rd32(self, 0xe5e) == 0) return;
    if (r == NULL) r = object_at(host, record_object_address(world, self, 0x1e));
    for (i = 0; i < rds16(r, 0x43); i = (int16_t)(i + 1)) {
        for (j = 0; j < rds16(r, 0x45); j = (int16_t)(j + 1)) {
            ptrdiff_t cell = (ptrdiff_t)i * 0x36 + (ptrdiff_t)j * 6;
            if (rds16(world->buf_5a110f, cell) == -10) copy_cell(world->buf_5a110f, cell, self, 0xe10);
        }
    }
}

/* ---- 0x4aa3d2 ------------------------------------------------------------------------------------------------------------------ */

/* 0x4aa3d2, thiscall, plain `ret`: the handler of events 0x276f / 0x2770 / 0x2771. `r` is the object of the record of the word [+0x21].
 * Returns at once when the BYTE [+0x45] is zero or the record state (dword [n * 0x8d + 0x5bb632]) is not 1. Then:
 *   byte [+0x47] == 0 and 0x276f: [+0x42] = [+0x23] (words); k = the word [+0x42]. When the word r[k * 0x15c + 0x233] equals the word [+0x40]
 *     and the byte [+0x2c + k] is zero: the word [+0x48] += 1, the byte [+0x2c + k] = 1, [+0x25] = 1 and 0x4fb2e3(this 0x5c3a67, word r[+0x73])
 *     when the nine bytes r[+0x52] differ from the constant at 0x550e2c, else [+0x25] = 0. Otherwise: when the byte r[+0x83] is non-zero the
 *     byte [+0x44] = 1, the word [+0x48] = 0 and the bytes at 0x630a60 + i are cleared for i = 0 while i < the word r[+0xf7] (a word counter);
 *     then the nine bytes r[+0x21] against 0x550e38: differ gives 0x4fb2e3(this 0x5c3a67, word r[+0x42]) and [+0x25] = 1, else [+0x25] = 0.
 *     Then the byte [+0x2b] = 0;
 *   else 0x2770 (reached with the byte [+0x47] non-zero too): [+0x42] = [+0x23], [+0x40] = the word r[k * 0x15c + 0x233] with k = the
 *     word [+0x23]; the nine bytes r[k * 0x15c + 0x119] against 0x550e44: when they differ, 0x4fb77a(this 0x5c3a67, the guest address of
 *     those bytes) and 0x4fb2e3(this 0x5c3a67, word r[k * 0x15c + 0x13a]) run, then, when the dword 0x5bb202 is non-zero and the string at
 *     r[k * 0x15c + 0x14a] is not empty, S = 0x423259(this 0x619a6b, its guest address); when S is non-zero and strlen(S) <= 0x9c40 the string
 *     is copied into a local buffer, its terminating zero is overwritten with the dword at 0x550e50 and 0x448d11(this 0x619a05, [0x5d03b3],
 *     the local buffer, -1, 0) runs; a longer S counts as zero. When S is still zero (also when the first string is empty or 0x423259
 *     returned 0) and the string at r[k * 0x15c + 0x16b] is not empty, 0x448d11(this 0x619a05, [0x5d03b3], its guest address,
 *     -1, 0) runs. Whenever the nine bytes were equal or the calls are done: the byte [+0x2b] = 0 and [+0x25] = 2;
 *   the selector 0x2771 (the check follows both of the above, which cannot match it): the byte [+0x46] = 1 and the record state = 2.
 * Unsafe original behaviour with a native rejection: the local buffer is 0xcc bytes (ebp - 0xd8 up to the local S) and the original copies
 * strlen(S) + 1 bytes and then stores a dword at its end without any bound; the port returns at once (no call, no further store) when
 * strlen(S) is in 201 .. 0x9c40 (the original overruns its frame), and when the guest address S cannot be resolved. A callee that changes
 * self is not exercised. */
void m4aa3d2_click_276f_2771(uint8_t *self, Fl25cWorld *world, const Fl18Host *host)
{
    uint32_t r_addr = record_object_address(world, self, 0x21);
    const uint8_t *r;
    uint32_t selector;
    if (self[0x45] == 0) return;
    if (!record_state_is_1(world, self, 0x21)) return;
    selector = world->value_5c39e5;
    r = object_at(host, r_addr);
    if (self[0x47] == 0 && selector == 0x276f) {
        ptrdiff_t k;
        wr16(self, 0x42, rd16(self, 0x23));
        k = rds16(self, 0x42);
        if (rds16(r, k * 0x15c + 0x233) == rds16(self, 0x40) && self[k + 0x2c] == 0) {
            wr16(self, 0x48, (uint16_t)(rd16(self, 0x48) + 1));
            self[rds16(self, 0x42) + 0x2c] = 1;
            if (!nine_bytes_equal(r + 0x52, world->bytes_550e2c)) {
                call1(host, 0x4fb2e3, 0x5c3a67, rd16(r, 0x73));
                wr32(self, 0x25, 1);
            } else {
                wr32(self, 0x25, 0);
            }
        } else {
            if (r[0x83] != 0) {
                int16_t i;
                self[0x44] = 1;
                wr16(self, 0x48, 0);
                for (i = 0; i < rds16(r, 0xf7); i = (int16_t)(i + 1)) world->buf_630a60[i] = 0;
            }
            if (!nine_bytes_equal(r + 0x21, world->bytes_550e38)) {
                call1(host, 0x4fb2e3, 0x5c3a67, rd16(r, 0x42));
                wr32(self, 0x25, 1);
            } else {
                wr32(self, 0x25, 0);
            }
        }
        self[0x2b] = 0;
    } else if (selector == 0x2770) {
        ptrdiff_t e;
        wr16(self, 0x42, rd16(self, 0x23));
        e = (ptrdiff_t)(rds16(self, 0x23) * 0x15c);
        wr16(self, 0x40, rd16(r, e + 0x233));
        if (!nine_bytes_equal(r + e + 0x119, world->bytes_550e44)) {
            call1(host, 0x4fb77a, 0x5c3a67, r_addr + (uint32_t)e + 0x119);
            call1(host, 0x4fb2e3, 0x5c3a67, rd16(r, e + 0x13a));
            if (world->value_5bb202 != 0) {
                uint32_t s = 0;
                if (strlen((const char *)(r + e + 0x14a)) != 0) {
                    s = call1(host, 0x423259, 0x619a6b, r_addr + (uint32_t)e + 0x14a);
                    if (s != 0) {
                        const uint8_t *sp = object_at(host, s);
                        size_t len;
                        uint8_t local[0xcc];
                        if (sp == NULL) return;
                        len = strlen((const char *)sp);
                        if (len > 0x9c40) {
                            s = 0;
                        } else {
                            if (len > 200) return;      /* the original overruns its 0xcc-byte buffer */
                            memcpy(local, sp, len + 1);
                            wr32(local, (ptrdiff_t)len, world->value_550e50);
                            call4(host, 0x448d11, 0x619a05, world->value_5d03b3, (uintptr_t)local, 0xffffffffu, 0);
                        }
                    }
                }
                if (s == 0 && strlen((const char *)(r + e + 0x16b)) != 0) {
                    call4(host, 0x448d11, 0x619a05, world->value_5d03b3, r_addr + (uint32_t)e + 0x16b, 0xffffffffu, 0);
                }
            }
        }
        self[0x2b] = 0;
        wr32(self, 0x25, 2);
    }
    if (selector == 0x2771) {
        self[0x46] = 1;
        set_record_state_2(world, self, 0x21);
    }
}

/* ---- 0x46c6a9 ------------------------------------------------------------------------------------------------------------------ */

/* `movsx ecx, word [self + idx]; shl ecx, 4`: the byte offset of cell n of the table of 16-byte cells at [+0x48a0] */
FL25C_UNUSED static ptrdiff_t cell16(const uint8_t *self, ptrdiff_t idx_off)
{
    return (ptrdiff_t)(rds16(self, idx_off) * 16);
}

/* 0x46c6a9, thiscall, plain `ret`: the handler of events 0x27e2 .. 0x27e6, 0x27e8 and 0x27ea. `r` is the object of the record of the word
 * [+0x1e]. Returns at once (nothing stored) when the dword [+0x4a48] is zero, the BYTE [+0x4a59] is non-zero, the dword [+0x4a55] is
 * non-zero or the record state (dword [n * 0x8d + 0x5bb632]) is not 1. Cells are 16 bytes at self + 0x48a0 + 16 * index (the indices are the
 * words [+0x49e0] and [+0x49e2], sign-extended; 20 cells fill the table up to [+0x49e0]). Then, by the dword [+0x4a2c] and the event:
 *   [+0x4a2c] == 0 and 0x27ea: the byte [+0x4a54] = 1 and the record state 2;
 *   [+0x4a2c] == 0 and 0x27e6 / 0x27e8: the word [+0x49e0] = [+0x49e2], [+0x4a4c] = 0, [+0x4a2c] = 1, [+0x4a24] = 1; 0x27e6: [+0x4a30] = 1, the
 *     words [+0x4a3c] / [+0x4a3e] = the words at cell(49e2) + 0x48aa / + 0x48a8, the dword cell(49e0) + 0x48a0 = 0; 0x27e8: [+0x4a34] = 1, the
 *     same words from + 0x48ae / + 0x48ac and the dword cell(49e2) + 0x48a4 = 0;
 *   [+0x4a2c] != 0 and 0x27e2 / 0x27e3: the dword cell(49e0) + 0x48a0 = 1, the words + 0x48a8 / + 0x48aa = the words [+0x4a50] / [+0x4a52]; 0x27e2:
 *     [+0x49e0] = [+0x49e2], the dword cell(49e0) + 0x48a0 = 0, [+0x4a4c] = 0, [+0x4a2c] = 1; 0x27e3: [+0x4a2c] = 0 and 0x46cc8b(this = self); then
 *     [+0x4a28] = [+0x4a24] = [+0x4a30] = 1 and the words [+0x4a3c] / [+0x4a3e] = the words at cell(49e2) + 0x48aa / + 0x48a8;
 *   [+0x4a2c] != 0 and 0x27e4 / 0x27e5: the same with the dword + 0x48a4, the words + 0x48ac / + 0x48ae, 0x27e4 resetting the dword + 0x48a4 and 0x27e5
 *     only clearing [+0x4a2c] (no call); [+0x4a34] = 1 instead of [+0x4a30]; the words [+0x4a3c] / [+0x4a3e] come from + 0x48ae / + 0x48ac.
 * Every passing call then: for 0x27e2 .. 0x27e5 with the dword 0x5bb1ca non-zero and the nine bytes r[+0x63d] different from the constant at
 * 0x54bd00: 0x4f6334(this 0x5cf1eb, the sign-extended word r[+0x65e]) and, when it returns 0, 0x4fb2e3(this 0x5c3a67, the word r[+0x65e]); for
 * 0x27e6 / 0x27e8 the same with r[+0x60c], 0x54bd0c and the word r[+0x62d]; finally the 0x140 bytes at self + 0x48a0 are copied to 0x5a14df.
 * A callee that changes self is not exercised. */
void m46c6a9_click_27e2_27ea(uint8_t *self, Fl25cWorld *world, const Fl18Host *host)
{
    uint32_t selector;
    const uint8_t *r;
    if (rd32(self, 0x4a48) == 0) return;
    if (self[0x4a59] != 0) return;
    if (rd32(self, 0x4a55) != 0) return;
    if (!record_state_is_1(world, self, 0x1e)) return;
    selector = world->value_5c39e5;
    if (rd32(self, 0x4a2c) == 0 && selector == 0x27ea) {
        self[0x4a54] = 1;
        set_record_state_2(world, self, 0x1e);
    } else if (rd32(self, 0x4a2c) == 0 && (selector == 0x27e6 || selector == 0x27e8)) {
        wr16(self, 0x49e0, rd16(self, 0x49e2));
        wr32(self, 0x4a4c, 0);
        wr32(self, 0x4a2c, 1);
        wr32(self, 0x4a24, 1);
        if (selector == 0x27e6) {
            wr32(self, 0x4a30, 1);
            wr16(self, 0x4a3c, rd16(self, cell16(self, 0x49e2) + 0x48aa));
            wr16(self, 0x4a3e, rd16(self, cell16(self, 0x49e2) + 0x48a8));
            wr32(self, cell16(self, 0x49e0) + 0x48a0, 0);
        } else {
            wr32(self, 0x4a34, 1);
            wr16(self, 0x4a3c, rd16(self, cell16(self, 0x49e2) + 0x48ae));
            wr16(self, 0x4a3e, rd16(self, cell16(self, 0x49e2) + 0x48ac));
            wr32(self, cell16(self, 0x49e2) + 0x48a4, 0);
        }
    } else if (rd32(self, 0x4a2c) != 0 && (selector == 0x27e2 || selector == 0x27e3)) {
        wr32(self, cell16(self, 0x49e0) + 0x48a0, 1);
        wr16(self, cell16(self, 0x49e0) + 0x48a8, rd16(self, 0x4a50));
        wr16(self, cell16(self, 0x49e0) + 0x48aa, rd16(self, 0x4a52));
        if (selector == 0x27e2) {
            wr16(self, 0x49e0, rd16(self, 0x49e2));
            wr32(self, cell16(self, 0x49e0) + 0x48a0, 0);
            wr32(self, 0x4a4c, 0);
            wr32(self, 0x4a2c, 1);
        } else {
            wr32(self, 0x4a2c, 0);
            call0(host, 0x46cc8b, (uintptr_t)self);
        }
        wr32(self, 0x4a28, 1);
        wr32(self, 0x4a24, 1);
        wr32(self, 0x4a30, 1);
        wr16(self, 0x4a3c, rd16(self, cell16(self, 0x49e2) + 0x48aa));
        wr16(self, 0x4a3e, rd16(self, cell16(self, 0x49e2) + 0x48a8));
    } else if (rd32(self, 0x4a2c) != 0 && (selector == 0x27e4 || selector == 0x27e5)) {
        wr32(self, cell16(self, 0x49e0) + 0x48a4, 1);
        wr16(self, cell16(self, 0x49e0) + 0x48ac, rd16(self, 0x4a50));
        wr16(self, cell16(self, 0x49e0) + 0x48ae, rd16(self, 0x4a52));
        if (selector == 0x27e4) {
            wr16(self, 0x49e0, rd16(self, 0x49e2));
            wr32(self, cell16(self, 0x49e0) + 0x48a4, 0);
            wr32(self, 0x4a4c, 0);
            wr32(self, 0x4a2c, 1);
        } else {
            wr32(self, 0x4a2c, 0);
        }
        wr32(self, 0x4a28, 1);
        wr32(self, 0x4a24, 1);
        wr32(self, 0x4a34, 1);
        wr16(self, 0x4a3c, rd16(self, cell16(self, 0x49e2) + 0x48ae));
        wr16(self, 0x4a3e, rd16(self, cell16(self, 0x49e2) + 0x48ac));
    }
    r = object_at(host, record_object_address(world, self, 0x1e));
    if ((selector == 0x27e2 || selector == 0x27e3 || selector == 0x27e4 || selector == 0x27e5) && world->value_5bb1ca != 0) {
        if (!nine_bytes_equal(r + 0x63d, world->bytes_54bd00)) {
            if (call1(host, 0x4f6334, 0x5cf1eb, (uintptr_t)(uint32_t)rds16(r, 0x65e)) == 0)
                call1(host, 0x4fb2e3, 0x5c3a67, rd16(r, 0x65e));
        }
    }
    if ((selector == 0x27e6 || selector == 0x27e8) && world->value_5bb1ca != 0) {
        if (!nine_bytes_equal(r + 0x60c, world->bytes_54bd0c)) {
            if (call1(host, 0x4f6334, 0x5cf1eb, (uintptr_t)(uint32_t)rds16(r, 0x62d)) == 0)
                call1(host, 0x4fb2e3, 0x5c3a67, rd16(r, 0x62d));
        }
    }
    memcpy(world->buf_5a14df, self + 0x48a0, 0x140);
}

/* FL25C-FUNCS-END */
