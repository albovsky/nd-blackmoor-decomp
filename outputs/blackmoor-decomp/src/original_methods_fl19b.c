#include "original_methods_fl19b.h"

#include <string.h>

/* 0x4fca60 is ported with C double arithmetic that must round like the x87 at 53 bits: no fused multiply-add. Build this file with
 * -ffp-contract=off (the tests do); clang also gets the pragma. */
#if defined(__clang__)
#pragma STDC FP_CONTRACT OFF
#endif

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

UNUSED_OK static uint32_t call5(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2,
                      uintptr_t a3, uintptr_t a4)
{
    uintptr_t args[5];
    args[0] = a0;
    args[1] = a1;
    args[2] = a2;
    args[3] = a3;
    args[4] = a4;
    return host->call != NULL ? host->call(host->context, callee, this_ptr, args, 5) : 0;
}

/* host memory behind the dword at `off` of `base` (an original address); the dword of a record of the 0x5bb5e5 table */
UNUSED_OK static uint8_t *record_object(const Fl18Host *host, const uint8_t *records, int32_t index)
{
    return (uint8_t *)host->resolve(host->context, rd32(records, (ptrdiff_t)index * 0x8d));
}

/* original GAME.EXE 0x44d597 (FUN_0044d597), this = self, stack argument arg (dword, ret 4): rec = the dword of the 0x5bb5e5-based
 * record at the signed word [self+0x1e] (stride 0x8d); dword 0x5b44f0 := the signed word [rec+0x263]; dword 0x5b44f4 := 1;
 * dword 0x5d162d := dword 0x5d0377; dword 0x5d1631 := 0x5b160c + (0x5b44f0 << 5) + (0x5b44f4 << 4); dword 0x5d1639 := 1;
 * dword 0x5c39e5 := 0x276e; byte [self+0x24] := 1; dword [self+0x31] := arg. */
void m44d597_press(uint8_t *self, int32_t arg, Fl19bWorld *world, const Fl18Host *host)
{
    uint8_t *rec = record_object(host, world->records_5bb5e5, rds16(self, 0x1e));
    world->value_5b44f0 = (uint32_t)rds16(rec, 0x263);
    world->value_5b44f4 = 1;
    world->value_5d162d = world->value_5d0377;
    world->value_5d1631 = 0x5b160cu + (world->value_5b44f0 << 5) + (world->value_5b44f4 << 4);
    world->value_5d1639 = 1;
    world->value_5c39e5 = 0x276e;
    self[0x24] = 1;
    wr32(self, 0x31, (uint32_t)arg);
}

/* original GAME.EXE 0x41f986 (FUN_0041f986), this = self (no stack argument): for k = 0 .. 0x1d (a signed word) with slot = self + k * 4 +
 * 0xea5: 0x51e745 on slot; buf = 0x51ea75 on slot with 0x190; the 0x190 bytes (0x64 dwords) at buf are cleared; 0x51eac4 on slot with
 * 0xffffffff. Finally 0x51e745 on self + 0xf1d. (The callees are the constructor, GetBuffer and ReleaseBuffer of a string member.) */
void m41f986_init_strings(uint8_t *self, const Fl18Host *host)
{
    int16_t k;
    for (k = 0; k < 0x1e; k++) {
        uintptr_t slot = (uintptr_t)(self + (ptrdiff_t)k * 4 + 0xea5);
        uint32_t buffer;
        call0(host, 0x51e745, slot);
        buffer = call1(host, 0x51ea75, slot, 0x190);
        memset((void *)host->resolve(host->context, buffer), 0, 0x190);
        call1(host, 0x51eac4, slot, 0xffffffffu);
    }
    call0(host, 0x51e745, (uintptr_t)(self + 0xf1d));
}

/* original GAME.EXE 0x4d00f4 (FUN_004d00f4, no this, no stack argument): the record is the dword of the 0x5bb5e5-based record at the
 * signed word 0x5b5159 (stride 0x8d), re-read in every pass. For k = 0, 1, ... (a signed word) while k < the signed word [rec+0x21]:
 * the local rectangle r = { dword [rec + k*16 + 0x123] + origin_x 0x583186, dword [rec + k*16 + 0x127] + origin_y 0x58318a,
 * dword [rec + k*16 + 0x12b] + origin_x, dword [rec + k*16 + 0x12f] + origin_y } (32-bit wrap); when the byte 0x5b5128[k] is non-zero
 * 0x4c5377 on 0x5cf659 with (dword 0x5d1a83, dword 0x5cf665, rec + k*16 + 0x23, &r, 0x559f30), otherwise 0x4c5377 on 0x5cf659 with
 * (dword 0x5d15e3, dword 0x5cf665, rec + k*16 + 0x123, &r, 0x559f4c). */
void m4d00f4_draw_list(const Fl19bWorld *world, const Fl18Host *host)
{
    int16_t k;
    for (k = 0;; k++) {
        uint32_t rec_va = rd32(world->records_5bb5e5, (ptrdiff_t)world->word_5b5159 * 0x8d);
        const uint8_t *rec = host->resolve(host->context, rec_va);
        ptrdiff_t line = (ptrdiff_t)k * 16;
        uint32_t r[4];
        if ((int32_t)k >= rds16(rec, 0x21)) break;
        r[0] = rd32(rec, line + 0x123) + (uint32_t)world->origin_x_583186;
        r[1] = rd32(rec, line + 0x127) + (uint32_t)world->origin_y_58318a;
        r[2] = rd32(rec, line + 0x12b) + (uint32_t)world->origin_x_583186;
        r[3] = rd32(rec, line + 0x12f) + (uint32_t)world->origin_y_58318a;
        if (world->bytes_5b5128[k] != 0)
            call5(host, 0x4c5377, 0x5cf659, world->value_5d1a83, world->value_5cf665, rec_va + (uint32_t)line + 0x23u, (uintptr_t)r,
                  0x559f30);
        else
            call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, rec_va + (uint32_t)line + 0x123u, (uintptr_t)r,
                  0x559f4c);
    }
}

/* original GAME.EXE 0x447ac7 (FUN_00447ac7), this = self, stack arguments arg (passed on to the callees, ret 8) and dst (a buffer of
 * 12-byte entries): local[0x8c] is filled by 0x4c3efb on 0x5cf659 with (arg, 0x583186, &local, 0x5485b4); p = the dword local[0x24]
 * (an original address) and stride = the dword local[0x10]. For each of the signed dword [self+0x41] rows, then (cols = 0, 2, 4, ...
 * while cols < the signed dword [self+0x45], re-read) the word v at p + cols (zero-extended) gives the next entry of dst:
 * dword +0 = (v >> byte 0x5d2f1b) & byte 0x5d2f1f, dword +4 = (v >> byte 0x5d2f1a) & byte 0x5d2f1e, dword +8 =
 * (v >> byte 0x5d2f19) & byte 0x5d2f1d (shift counts as the x86 masks them, to 5 bits); after each row p += stride. Finally
 * 0x4c4202 on 0x5cf659 with (arg, 0x583186, 0x5485f4). */
void m447ac7_split_pixels(uint8_t *self, uintptr_t arg, uint8_t *dst, const Fl19bWorld *world, const Fl18Host *host)
{
    uint8_t local[0x8c];
    uint32_t p, stride, entry = 0, row, col;
    memset(local, 0, sizeof local);
    call4(host, 0x4c3efb, 0x5cf659, arg, 0x583186, (uintptr_t)local, 0x5485b4);
    p = rd32(local, 0x24);
    stride = rd32(local, 0x10);
    for (row = 0; (int32_t)row < (int32_t)rd32(self, 0x41); row++) {
        for (col = 0; (int32_t)col < (int32_t)rd32(self, 0x45); col += 2) {
            uint32_t v = rd16(host->resolve(host->context, p + col), 0);
            uint8_t *out = dst + (ptrdiff_t)(entry * 12u);
            entry++;
            wr32(out, 0, (v >> (world->shift_5d2f1b & 31)) & world->mask_5d2f1f);
            wr32(out, 4, (v >> (world->shift_5d2f1a & 31)) & world->mask_5d2f1e);
            wr32(out, 8, (v >> (world->shift_5d2f19 & 31)) & world->mask_5d2f1d);
        }
        p += stride;
    }
    call3(host, 0x4c4202, 0x5cf659, arg, 0x583186, 0x5485f4);
}

/* original GAME.EXE 0x45b872 (FUN_0045b872), this = self (no stack argument, plain ret): rec = the dword of the 0x5bb5e5-based record at
 * the signed word [self+0x1e] (stride 0x8d). Nothing unless the dword [self+0x166] is non-zero, the dwords [self+0x16a] and [self+0x24]
 * are 0 and the dword at record +0x4d is 1. Then, when the dword 0x5c39e5 is 0x27bb: when 0x45be7f on self with (rec + 0x7e9, 4, 0)
 * returns non-zero, dword [self+0x1b5] := 0xb and dword [self+0x16e] := GetTickCount + 0x320, otherwise the dword at record +0x4d := 2.
 * When it is 0x27ba: dword [self+0x28] := 1; word [self+0x2c] := word [self+0x172]; dword [self+0x2e] := GetTickCount + 0xfa; dword
 * [self+0x32] := 1; and, when the dword 0x5bb1ca is non-zero and the nine bytes at rec + s*0x31 + 0x4fe (s = the signed word
 * [self+0x172]) differ from the nine bytes at 0x54ab5c: n = the signed word at rec + s*0x31 + 0x51f; when 0x4f6334 on 0x5cf1eb with n
 * returns 0, 0x4fb2e3 on 0x5c3a67 with that word. */
void m45b872_click(uint8_t *self, Fl19bWorld *world, const Fl18Host *host)
{
    ptrdiff_t slot = (ptrdiff_t)rds16(self, 0x1e) * 0x8d;
    uint32_t rec_va = rd32(world->records_5bb5e5, slot);
    if (rd32(self, 0x166) == 0 || rd32(self, 0x16a) != 0 || rd32(self, 0x24) != 0 ||
        rd32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d + 0x4d) != 1)
        return;
    if (world->value_5c39e5 == 0x27bb) {
        if (call3(host, 0x45be7f, (uintptr_t)self, rec_va + 0x7e9u, 4, 0) != 0) {
            wr32(self, 0x1b5, 0xb);
            wr32(self, 0x16e, (host->tick != NULL ? host->tick(host->context) : 0) + 0x320u);
        } else {
            wr32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d + 0x4d, 2);
        }
    } else if (world->value_5c39e5 == 0x27ba) {
        wr32(self, 0x28, 1);
        wr16(self, 0x2c, rd16(self, 0x172));
        wr32(self, 0x2e, (host->tick != NULL ? host->tick(host->context) : 0) + 0xfau);
        wr32(self, 0x32, 1);
        if (world->value_5bb1ca != 0) {
            const uint8_t *rec = host->resolve(host->context, rec_va);
            ptrdiff_t entry = (ptrdiff_t)(int32_t)((uint32_t)rds16(self, 0x172) * 0x31u);
            if (memcmp(rec + entry + 0x4fe, world->bytes_54ab5c, 9) != 0) {
                int32_t n = rds16(rec, entry + 0x51f);
                if (call1(host, 0x4f6334, 0x5cf1eb, (uintptr_t)(uint32_t)n) == 0)
                    call1(host, 0x4fb2e3, 0x5c3a67, rd16(rec, entry + 0x51f));
            }
        }
    }
}

/* original GAME.EXE 0x434630 (FUN_00434630), this = self, stack argument name (a zero-terminated string, ret 4); returns 1 or 0.
 * For i = 0, 1, ... while i < the signed dword [self+0x5f68]: rec = the dword [self + i*4 + 0x20e4] (an original address); s =
 * 0x434814 on self with rec (the address of a zero-terminated string; compared with name by an inlined strcmp). When equal and the
 * dword [self + i*4 + 0x4fc4] is not 1: that dword := 1; dword [self+0x112c] := 0x4347b8 on self with rec + 4; dword [self+0x1120] :=
 * rec + 8; the string s (with its terminator, an inlined strcpy) is copied to self + 0x1130; returns 1. Returns 0 when no entry
 * qualifies. */
int32_t m434630_find_name(uint8_t *self, const uint8_t *name, const Fl18Host *host)
{
    int32_t i;
    for (i = 0; i < (int32_t)rd32(self, 0x5f68); i++) {
        uint32_t rec = rd32(self, (ptrdiff_t)i * 4 + 0x20e4);
        uint32_t text = call1(host, 0x434814, (uintptr_t)self, rec);
        const uint8_t *s = host->resolve(host->context, text);
        if (strcmp((const char *)s, (const char *)name) == 0 && rd32(self, (ptrdiff_t)i * 4 + 0x4fc4) != 1) {
            wr32(self, (ptrdiff_t)i * 4 + 0x4fc4, 1);
            rec += 4;
            wr32(self, 0x112c, call1(host, 0x4347b8, (uintptr_t)self, rec));
            rec += 4;
            wr32(self, 0x1120, rec);
            {   /* a forward byte copy like the original's rep movs, defined even when s overlaps the buffer */
                uint8_t *dst = self + 0x1130;
                const uint8_t *src = s;
                do { *dst++ = *src; } while (*src++ != 0);
            }
            return 1;
        }
    }
    return 0;
}

/* original GAME.EXE 0x4c7481 (FUN_004c7481), this = self, stack arguments buf (a buffer of 16-bit pixels) and size (in bytes, ret 8):
 * for each of the size >> 1 (unsigned) words w of buf, in place: a = (w >> byte [self+0x38c2]) & byte [self+0x38c6], b = (w >> byte
 * [self+0x38c1]) & byte [self+0x38c5], c = (w >> byte [self+0x38c0]) & byte [self+0x38c4] (16-bit shifts, count taken modulo 32, so
 * a count of 16 or more clears the value); then, when the byte [self+0x38ca] is not 5, a >>= 1, otherwise when the byte [self+0x38c9] is
 * not 5, b >>= 1, otherwise when the byte [self+0x38c8] is not 5, c >>= 1; the word is replaced by the low 16 bits of
 * (a << 10) | (b << 5) | c. (The masks and the three flag bytes are read from self on every pass.) */
void m4c7481_pack_555(const uint8_t *self, uint8_t *buf, uint32_t size)
{
    uint32_t i;
    uint8_t shift_a = self[0x38c2], shift_b = self[0x38c1], shift_c = self[0x38c0];
    uint8_t flag_a = self[0x38ca], flag_b = self[0x38c9], flag_c = self[0x38c8];
    for (i = 0; i < size >> 1; i++) {
        uint32_t w = rd16(buf, (ptrdiff_t)i * 2);
        uint32_t a = (w >> (shift_a & 31)) & self[0x38c6];
        uint32_t b = (w >> (shift_b & 31)) & self[0x38c5];
        uint32_t c = (w >> (shift_c & 31)) & self[0x38c4];
        if (flag_a != 5)
            a >>= 1;
        else if (flag_b != 5)
            b >>= 1;
        else if (flag_c != 5)
            c >>= 1;
        wr16(buf, (ptrdiff_t)i * 2, (uint16_t)((a << 10) | (b << 5) | c));
    }
}

/* original GAME.EXE 0x4d3836 (FUN_004d3836, cdecl, no this), stack arguments text (a zero-terminated string; it advances), font (an
 * object) and table (dwords of which the low word is the advance); returns the signed word width (in ax). width := 0; for each
 * character c (signed byte) of text until the terminator: r = 0x4d214b (cdecl) with (c as pushed from cl: only its low 8 bits are
 * meaningful, font, &local); when r is non-zero the glyph is the signed word local (kept from the previous pass if the callee did not
 * write it). Otherwise (each test calls the CRT predicates again, cdecl with c sign-extended): 0x50d651 and 0x50d67f both non-zero
 * and the unsigned byte < 0x80: local word := c + signed word [font+0x53] - 0x41; else 0x50d651 and 0x50d6a7 both non-zero and the
 * byte < 0x80: local word := c + signed word [font+0x55] - 0x61; else 0x50d6cf non-zero and the byte < 0x80: local word := c + signed
 * word [font+0x57] - 0x30; else no glyph: width += signed word [font+0x4f]. A glyph adds (16-bit) the signed word at table + glyph*4
 * plus the signed word [font+0x51] to width. */
int16_t m4d3836_text_width(const uint8_t *text, const uint8_t *font, const uint8_t *table, const Fl18Host *host)
{
    uint16_t width = 0;
    uint32_t local = 0;
    for (; (int8_t)*text != 0; text++) {
        int32_t c = (int8_t)*text;
        int glyph = 0;
        if (call3(host, 0x4d214b, 0, *text, (uintptr_t)font, (uintptr_t)&local) != 0) {
            glyph = 1;
        } else if (call1(host, 0x50d651, 0, (uint32_t)c) != 0 && call1(host, 0x50d67f, 0, (uint32_t)c) != 0 && *text < 0x80) {
            wr16((uint8_t *)&local, 0, (uint16_t)(c + rds16(font, 0x53) - 0x41));
            glyph = 1;
        } else if (call1(host, 0x50d651, 0, (uint32_t)c) != 0 && call1(host, 0x50d6a7, 0, (uint32_t)c) != 0 && *text < 0x80) {
            wr16((uint8_t *)&local, 0, (uint16_t)(c + rds16(font, 0x55) - 0x61));
            glyph = 1;
        } else if (call1(host, 0x50d6cf, 0, (uint32_t)c) != 0 && *text < 0x80) {
            wr16((uint8_t *)&local, 0, (uint16_t)(c + rds16(font, 0x57) - 0x30));
            glyph = 1;
        }
        if (glyph) {
            int32_t index = (int16_t)rd16((const uint8_t *)&local, 0);
            width = (uint16_t)(width + (uint16_t)(rds16(table, (ptrdiff_t)index * 4) + rds16(font, 0x51)));
        } else {
            width = (uint16_t)(width + rd16(font, 0x4f));
        }
    }
    return (int16_t)width;
}

/* the strcpy (repne scasb; rep movsd; rep movsb) of the original: strlen + 1 bytes */
UNUSED_OK static void copy_string(uint8_t *dst, const uint8_t *src)
{
    memcpy(dst, src, strlen((const char *)src) + 1);
}

/* original GAME.EXE 0x4460d6 (FUN_004460d6), this = self, stack argument src (0x2e dwords, ret 4): the 0x2e dwords at src are copied to
 * self + 0xbc (forward dword copy). For n = 0 .. 9 (the dword [self+0x284], left at 10): dword [self + n*4 + 0x14] := dword
 * [self + n*16 + 0xc4] - dword [self + n*16 + 0xbc] + 1; dword [self + n*4 + 0x3c] := dword [self + n*16 + 0xc8] - dword
 * [self + n*16 + 0xc0] + 1. Then e = the 0x5d1591-based record number [self+0x16c] (stride 0x4a, 32-bit product): dword e+0x00 := dword
 * [self+0x170]; dword e+0x04 := 0x446688; dword e+0x08 := dword [self+0x168]; dwords e+0x0c, e+0x10 := 0; dwords e+0x14, e+0x18 := 1;
 * word e+0x1c := 0; the string at 0x548218 is copied to e+0x22. Finally dword [self+0x23c] := 0; bytes [self+0x25c], [self+0x27a] :=
 * 0; dword [self+4] := 0; dword [self+0xc] := 1. */
void m4460d6_load_layout(uint8_t *self, const uint8_t *src, Fl19bWorld *world)
{
    uint8_t *e;
    uint32_t k;
    for (k = 0; k < 0x2e; k++) wr32(self, 0xbc + (ptrdiff_t)k * 4, rd32(src, (ptrdiff_t)k * 4));
    for (wr32(self, 0x284, 0); (int32_t)rd32(self, 0x284) < 10; wr32(self, 0x284, rd32(self, 0x284) + 1u)) {
        uint32_t n = rd32(self, 0x284);
        wr32(self, (ptrdiff_t)n * 4 + 0x14, rd32(self, (ptrdiff_t)n * 16 + 0xc4) - rd32(self, (ptrdiff_t)n * 16 + 0xbc) + 1u);
        wr32(self, (ptrdiff_t)n * 4 + 0x3c, rd32(self, (ptrdiff_t)n * 16 + 0xc8) - rd32(self, (ptrdiff_t)n * 16 + 0xc0) + 1u);
    }
    e = world->table_5d1591 + (ptrdiff_t)(int32_t)(rd32(self, 0x16c) * 0x4au);
    wr32(e, 0x00, rd32(self, 0x170));
    wr32(e, 0x04, 0x446688);
    wr32(e, 0x08, rd32(self, 0x168));
    wr32(e, 0x0c, 0);
    wr32(e, 0x10, 0);
    wr32(e, 0x14, 1);
    wr32(e, 0x18, 1);
    wr16(e, 0x1c, 0);
    copy_string(e + 0x22, world->string_548218);
    wr32(self, 0x23c, 0);
    self[0x25c] = 0;
    self[0x27a] = 0;
    wr32(self, 4, 0);
    wr32(self, 0xc, 1);
}

/* original GAME.EXE 0x48ded7 (FUN_0048ded7, no this, no stack argument, plain ret): the record is the dword of the 0x5bb5e5-based record at
 * the signed word 0x61d363 (stride 0x8d). Nothing at all unless the byte 0x61d369 and the dword 0x61d374 are non-zero. Then, with
 * k = the signed word 0x61d36c: when the byte 0x61d36b is non-zero and k is not -1: the local rectangle r = { dword [rec + k*16 + 0x113] +
 * origin_x 0x583186, dword [rec + k*16 + 0x117] + origin_y 0x58318a, dword [rec + k*16 + 0x11b] + origin_x, dword [rec + k*16 + 0x11f] +
 * origin_y }, 0x4c5377 on 0x5cf659 with (the dword at 0x5d1599 + word 0x61d361 * 0x4a, dword 0x5cf665, rec + k*16 + 0x23, &r, 0x54e8e0)
 * and dword 0x61d370 := 0; otherwise, when the byte 0x61d36a is non-zero and j = the signed word 0x61d36e is not -1: r as above with
 * j, 0x4c5377 on 0x5cf659 with (dword 0x5d15e3, dword 0x5cf665, rec + j*16 + 0x113, &r, 0x54e8fc), byte 0x61d36a := 0 and 0x48d89e on
 * 0x61d345. Finally byte 0x61d369 := 0. */
void m48ded7_draw_hover(Fl19bWorld *world, const Fl18Host *host)
{
    int32_t k = world->word_61d36c, j = world->word_61d36e;
    uint32_t rec_va, r[4];
    const uint8_t *rec;
    if (world->byte_61d369 == 0 || world->value_61d374 == 0) return;
    if (world->byte_61d36b != 0 && k != -1) {
        rec_va = rd32(world->records_5bb5e5, (ptrdiff_t)world->word_61d363 * 0x8d);
        rec = host->resolve(host->context, rec_va);
        r[0] = rd32(rec, (ptrdiff_t)k * 16 + 0x113) + (uint32_t)world->origin_x_583186;
        r[1] = rd32(rec, (ptrdiff_t)k * 16 + 0x117) + (uint32_t)world->origin_y_58318a;
        r[2] = rd32(rec, (ptrdiff_t)k * 16 + 0x11b) + (uint32_t)world->origin_x_583186;
        r[3] = rd32(rec, (ptrdiff_t)k * 16 + 0x11f) + (uint32_t)world->origin_y_58318a;
        call5(host, 0x4c5377, 0x5cf659, rd32(world->table_5d1591, (ptrdiff_t)(int32_t)((uint32_t)world->word_61d361 * 0x4au) + 8),
              world->value_5cf665, rec_va + (uint32_t)(k * 16) + 0x23u, (uintptr_t)r, 0x54e8e0);
        world->value_61d370 = 0;
    } else if (world->byte_61d36a != 0 && j != -1) {
        rec_va = rd32(world->records_5bb5e5, (ptrdiff_t)world->word_61d363 * 0x8d);
        rec = host->resolve(host->context, rec_va);
        r[0] = rd32(rec, (ptrdiff_t)j * 16 + 0x113) + (uint32_t)world->origin_x_583186;
        r[1] = rd32(rec, (ptrdiff_t)j * 16 + 0x117) + (uint32_t)world->origin_y_58318a;
        r[2] = rd32(rec, (ptrdiff_t)j * 16 + 0x11b) + (uint32_t)world->origin_x_583186;
        r[3] = rd32(rec, (ptrdiff_t)j * 16 + 0x11f) + (uint32_t)world->origin_y_58318a;
        call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, rec_va + (uint32_t)(j * 16) + 0x113u, (uintptr_t)r,
              0x54e8fc);
        world->byte_61d36a = 0;
        call0(host, 0x48d89e, 0x61d345);
    }
    world->byte_61d369 = 0;
}

/* original GAME.EXE 0x45b5bb (FUN_0045b5bb), this = self, stack arguments x and y (words, sign-extended; ret 8); returns 1 when the point
 * lands in one of the hot boxes of the record, else 0. rec = the dword of the 0x5bb5e5-based record at the signed word [self+0x1e]
 * (stride 0x8d). Returns 0 unless the dword [self+0x166] is non-zero and the dword [self+0x28] is 0, and returns 0 when the byte [rec+0x27]
 * is 0 and the signed word 0x6247ee is >= 2. Then (all comparisons signed, with the dword fields of the record): box A, when
 * [rec+0x321] - 5 <= y <= [rec+0x329] + 5 and [rec+0x31d] <= x <= [rec+0x325]: 0x45b7a8 on self with (0x27ba, 0); box B, only when
 * the signed word [self+0xba] is 1 or 3, when [rec+0x331] + 5 <= y <= [rec+0x339] + 5 and [rec+0x32d] + 10 <= x <= [rec+0x335] - 10:
 * 0x45b7a8 with (0x27ba, 1); box C, when [rec+0x341] <= y <= [rec+0x349] and [rec+0x33d] <= x <= [rec+0x345]: 0x45b7a8 with
 * (0x27ba, 2); box D, when [rec+0xb82] <= y <= [rec+0xb8a] and [rec+0xb7e] <= x <= [rec+0xb86]: 0x45b7a8 with (0x27bb, 0). The first
 * box that holds the point calls and returns 1. (0x45b7a8 is also ported, as m45b7a8_arm_hotspot, in FL-18; here it goes through the
 * host.) */
int32_t m45b5bb_pointer_move(uint8_t *self, int16_t x, int16_t y, const Fl19bWorld *world, const Fl18Host *host)
{
    const uint8_t *rec;
    int32_t px = x, py = y;
    if (rd32(self, 0x166) == 0 || rd32(self, 0x28) != 0) return 0;
    rec = record_object(host, world->records_5bb5e5, rds16(self, 0x1e));
    if (rec[0x27] == 0 && world->word_6247ee >= 2) return 0;
    if (py >= (int32_t)(rd32(rec, 0x321) - 5u) && py <= (int32_t)(rd32(rec, 0x329) + 5u) && px >= (int32_t)rd32(rec, 0x31d) &&
        px <= (int32_t)rd32(rec, 0x325)) {
        call2(host, 0x45b7a8, (uintptr_t)self, 0x27ba, 0);
        return 1;
    }
    if ((rds16(self, 0xba) == 1 || rds16(self, 0xba) == 3) && py >= (int32_t)(rd32(rec, 0x331) + 5u) &&
        py <= (int32_t)(rd32(rec, 0x339) + 5u) && px >= (int32_t)(rd32(rec, 0x32d) + 10u) && px <= (int32_t)(rd32(rec, 0x335) - 10u)) {
        call2(host, 0x45b7a8, (uintptr_t)self, 0x27ba, 1);
        return 1;
    }
    if (py >= (int32_t)rd32(rec, 0x341) && py <= (int32_t)rd32(rec, 0x349) && px >= (int32_t)rd32(rec, 0x33d) &&
        px <= (int32_t)rd32(rec, 0x345)) {
        call2(host, 0x45b7a8, (uintptr_t)self, 0x27ba, 2);
        return 1;
    }
    if (py >= (int32_t)rd32(rec, 0xb82) && py <= (int32_t)rd32(rec, 0xb8a) && px >= (int32_t)rd32(rec, 0xb7e) &&
        px <= (int32_t)rd32(rec, 0xb86)) {
        call2(host, 0x45b7a8, (uintptr_t)self, 0x27bb, 0);
        return 1;
    }
    return 0;
}

/* original GAME.EXE 0x4462d3 (FUN_004462d3), this = self, stack argument src (0x32 dwords, ret 4): the 0x32 dwords at src are copied to
 * self + 0x174 (forward dword copy). For n = 0 .. 9 (the dword [self+0x284], left at 10): dword [self + n*4 + 0x64] := dword
 * [self + n*16 + 0x17c] - dword [self + n*16 + 0x174] + 1; dword [self + n*4 + 0x8c] := dword [self + n*16 + 0x180] - dword
 * [self + n*16 + 0x178] + 1. Then dword [self+0xb4] := dword [self+0x21c] - dword [self+0x214] + 1; dword [self+0xb8] := dword [self+0x220]
 * - dword [self+0x218] + 1. e = the 0x5d1591-based record number [self+0x234] (stride 0x4a, 32-bit product): dword e+0x00 := dword
 * [self+0x238]; dword e+0x04 := 0x4468fe; dword e+0x08 := dword [self+0x230]; dwords e+0x0c, e+0x10 := 0; dwords e+0x14, e+0x18 := 1;
 * word e+0x1c := 0; the string at 0x548228 is copied to e+0x22. Finally dwords [self+0x240], [self+0x244] := 0; bytes [self+0x248],
 * [self+0x252], [self+0x266], [self+0x270] := 0; dword [self+8] := 0; dword [self+0x10] := 1. */
void m4462d3_load_layout(uint8_t *self, const uint8_t *src, Fl19bWorld *world)
{
    uint8_t *e;
    uint32_t k;
    for (k = 0; k < 0x32; k++) wr32(self, 0x174 + (ptrdiff_t)k * 4, rd32(src, (ptrdiff_t)k * 4));
    for (wr32(self, 0x284, 0); (int32_t)rd32(self, 0x284) < 10; wr32(self, 0x284, rd32(self, 0x284) + 1u)) {
        uint32_t n = rd32(self, 0x284);
        wr32(self, (ptrdiff_t)n * 4 + 0x64, rd32(self, (ptrdiff_t)n * 16 + 0x17c) - rd32(self, (ptrdiff_t)n * 16 + 0x174) + 1u);
        wr32(self, (ptrdiff_t)n * 4 + 0x8c, rd32(self, (ptrdiff_t)n * 16 + 0x180) - rd32(self, (ptrdiff_t)n * 16 + 0x178) + 1u);
    }
    wr32(self, 0xb4, rd32(self, 0x21c) - rd32(self, 0x214) + 1u);
    wr32(self, 0xb8, rd32(self, 0x220) - rd32(self, 0x218) + 1u);
    e = world->table_5d1591 + (ptrdiff_t)(int32_t)(rd32(self, 0x234) * 0x4au);
    wr32(e, 0x00, rd32(self, 0x238));
    wr32(e, 0x04, 0x4468fe);
    wr32(e, 0x08, rd32(self, 0x230));
    wr32(e, 0x0c, 0);
    wr32(e, 0x10, 0);
    wr32(e, 0x14, 1);
    wr32(e, 0x18, 1);
    wr16(e, 0x1c, 0);
    copy_string(e + 0x22, world->string_548228);
    wr32(self, 0x240, 0);
    wr32(self, 0x244, 0);
    self[0x248] = 0;
    self[0x252] = 0;
    self[0x266] = 0;
    self[0x270] = 0;
    wr32(self, 8, 0);
    wr32(self, 0x10, 1);
}

/* original GAME.EXE 0x412787 (FUN_00412787), stack argument index (a word, ret 4; ecx is not used): rec = the dword of the 0x5bb5e5-based
 * record `index` (stride 0x8d; an original address); g = the signed word [rec] - 3 (16 bits); the string of the entry is rec + 2. For
 * k = 0, 1, ... (a signed word) while k < the signed word 0x59fbdb[g]: the table string at 0x5957cb + g*0x3390 + k*0x21 is compared with
 * the entry string; when they are equal, or when 0x423259 on 0x619a6b with (rec + 2) returns 0, the function calls 0x42ba3a (cdecl)
 * with the word index and returns. When every entry differs: n = the signed word 0x59fbdb[g]; when n is 0x190 only 0x52139c (stdcall)
 * is called with (0x54164c, 0, 0); otherwise the entry string is copied to 0x5957cb + g*0x3390 + n*0x21, the word 0x59f27b[g*0x320 + n*2]
 * := the word [rec+0x23] and the word 0x59fbe1[g*0x320 + n*2] := the word [rec+0x25] when the signed word [rec+0x23] is >= 10 or 7,
 * otherwise 0x270f. Then (also after the 0x190 call) the word 0x59fbdb[g] += 1 (16 bits); when the signed word [rec] is 4, 0x4e0559 on
 * 0x570508 with (2, 1, 0), when it is 3, with (2, 1, 1); and finally 0x42ba3a with the word index. */
void m412787_register_name(int16_t index, const Fl19bWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = rd32(world->records_5bb5e5, (ptrdiff_t)index * 0x8d);
    uint8_t *rec = (uint8_t *)host->resolve(host->context, rec_va);
    int32_t g = (int16_t)(uint16_t)(rd16(rec, 0) - 3u);
    int16_t k;
    int32_t n;
    for (k = 0; (int32_t)k < rds16(world->words_59fbdb, (ptrdiff_t)g * 2); k++) {
        const uint8_t *entry = world->strings_5957cb + (ptrdiff_t)g * 0x3390 + (ptrdiff_t)k * 0x21;
        if (strcmp((const char *)entry, (const char *)(rec + 2)) == 0 || call1(host, 0x423259, 0x619a6b, rec_va + 2u) == 0) {
            call1(host, 0x42ba3a, 0, (uint16_t)index);
            return;
        }
    }
    n = rds16(world->words_59fbdb, (ptrdiff_t)g * 2);
    if (n == 0x190) {
        call3(host, 0x52139c, 0, 0x54164c, 0, 0);
    } else {
        copy_string(world->strings_5957cb + (ptrdiff_t)g * 0x3390 + (ptrdiff_t)n * 0x21, rec + 2);
        wr16(world->words_59f27b, (ptrdiff_t)g * 0x320 + (ptrdiff_t)n * 2, rd16(rec, 0x23));
        if (rds16(rec, 0x23) >= 10 || rds16(rec, 0x23) == 7)
            wr16(world->words_59fbe1, (ptrdiff_t)g * 0x320 + (ptrdiff_t)n * 2, rd16(rec, 0x25));
        else
            wr16(world->words_59fbe1, (ptrdiff_t)g * 0x320 + (ptrdiff_t)n * 2, 0x270f);
    }
    wr16(world->words_59fbdb, (ptrdiff_t)g * 2, (uint16_t)(rd16(world->words_59fbdb, (ptrdiff_t)g * 2) + 1u));
    if (rds16(rec, 0) == 4)
        call3(host, 0x4e0559, 0x570508, 2, 1, 0);
    else if (rds16(rec, 0) == 3)
        call3(host, 0x4e0559, 0x570508, 2, 1, 1);
    call1(host, 0x42ba3a, 0, (uint16_t)index);
}

typedef char fl19b_uintptr_holds_a_double[sizeof(uintptr_t) >= sizeof(double) ? 1 : -1];

/* the host call of 0x50ce04 (the float-to-int truncation; the original passes the value in st0): args[0] = the bits of the double */
static uint32_t call_ftol(const Fl18Host *host, double value)
{
    uint64_t bits;
    memcpy(&bits, &value, sizeof bits);
    return call1(host, 0x50ce04, 0, (uintptr_t)bits);
}

/* original GAME.EXE 0x4fca60 (FUN_004fca60), this = self, stack arguments channel (a word, sign-extended), first and second (dwords,
 * floats; ret 0xc): e = self + channel * 0x5bb. dword [e+0x138] := first; dword [e+0x13c] := second; with t = the float at self + 4 *
 * (the signed word [e+0x10c]) + 0xb764: dword [e+0x140] := 0x50ce04 of ((double)(float [e+0x138]) * t * float 0x52e4e0 + double
 * 0x52e4d8); dword [e+0x144] := 0x50ce04 of the same with the float [e+0x13c]; finally 0x4f684a on 0x5cf1eb with the sign-extended
 * channel. (Unlike the original it does not run the x87 unit; see the header comment.) */
void m4fca60_set_channel_scalars(uint8_t *self, int16_t channel, uint32_t first, uint32_t second, const Fl19bWorld *world,
                                 const Fl18Host *host)
{
    uint8_t *e = self + (ptrdiff_t)((int32_t)channel * 0x5bb);
    float f, t;
    double v;
    wr32(e, 0x138, first);
    wr32(e, 0x13c, second);
    memcpy(&f, e + 0x138, sizeof f);
    memcpy(&t, self + (ptrdiff_t)rds16(e, 0x10c) * 4 + 0xb764, sizeof t);
    v = (double)f * (double)t;
    v = v * (double)world->scale_52e4e0;
    v = v + world->bias_52e4d8;
    wr32(e, 0x140, call_ftol(host, v));
    memcpy(&f, e + 0x13c, sizeof f);
    memcpy(&t, self + (ptrdiff_t)rds16(e, 0x10c) * 4 + 0xb764, sizeof t);
    v = (double)f * (double)t;
    v = v * (double)world->scale_52e4e0;
    v = v + world->bias_52e4d8;
    wr32(e, 0x144, call_ftol(host, v));
    call1(host, 0x4f684a, 0x5cf1eb, (uint32_t)(int32_t)channel);
}
