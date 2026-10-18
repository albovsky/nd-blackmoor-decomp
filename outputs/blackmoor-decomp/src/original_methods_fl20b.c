#include "original_methods_fl20b.h"

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

/* the strcpy (repne scasb; rep movsd; rep movsb) of the original: strlen + 1 bytes, copied forward (the buffers may overlap) */
UNUSED_OK static void copy_string(uint8_t *dst, const uint8_t *src)
{
    size_t n = strlen((const char *)src) + 1, k;
    for (k = 0; k < n; k++) dst[k] = src[k];
}

/* the original address 0x638xxx of the block at 0x638600 */
#define BLOCK(world, address) ((world)->block_638600 + ((ptrdiff_t)(address) - 0x638600))

/* original GAME.EXE 0x446688 (FUN_00446688, no this, no stack argument, plain ret): returns at once unless the dwords 0x638607 and
 * 0x63860f are both non-zero. x0 = dword 0x63875f, y0 = dword 0x638763. When the strings new (0x63885f) and old (0x63887d) differ
 * (an inlined strcmp): for i = 0, 1, ... while i < strlen(old) (unsigned, re-evaluated in every pass): d = old[i] (signed byte) - 0x30;
 * the local rectangle q = { x, y, x + dword 0x638617[d] - 1, y + dword 0x63863f[d] - 1 } and p = q - (origin_x 0x583186, origin_y
 * 0x58318a, origin_x, origin_y); 0x4c5377 on 0x5cf659 with (dword 0x5d15e3, dword 0x5cf665, &p, &q, 0x548288); x += dword
 * 0x638617[d] + dword 0x638767. Then (always) the same over new with x0, y0 again: q as above, 0x4c5d4b on 0x5cf659 with (the dword at
 * 0x5d1599 + dword 0x63876f * 0x4a, dword 0x5cf665, 0x6386bf + d * 16, &q, 0x5482b4) and the same advance. Finally new is copied
 * to old with its terminator (an inlined strcpy: strlen + 1 bytes). */
void m446688_draw_digits(Fl20bWorld *world, const Fl18Host *host)
{
    uint32_t p[4], q[4];
    uint32_t x, y, i, d;
    if (rd32(BLOCK(world, 0x638607), 0) == 0 || rd32(BLOCK(world, 0x63860f), 0) == 0) return;
    x = rd32(BLOCK(world, 0x63875f), 0);
    y = rd32(BLOCK(world, 0x638763), 0);
    if (strcmp((const char *)BLOCK(world, 0x63885f), (const char *)BLOCK(world, 0x63887d)) != 0) {
        for (i = 0; i < strlen((const char *)BLOCK(world, 0x63887d)); i++) {
            d = (uint32_t)((int32_t)(int8_t)*BLOCK(world, 0x63887d + i) - 0x30);
            q[0] = x;
            q[1] = y;
            q[2] = x + rd32(BLOCK(world, 0x638617), (ptrdiff_t)(int32_t)d * 4) - 1u;
            q[3] = y + rd32(BLOCK(world, 0x63863f), (ptrdiff_t)(int32_t)d * 4) - 1u;
            p[0] = q[0] - (uint32_t)world->origin_x_583186;
            p[2] = q[2] - (uint32_t)world->origin_x_583186;
            p[1] = q[1] - (uint32_t)world->origin_y_58318a;
            p[3] = q[3] - (uint32_t)world->origin_y_58318a;
            call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, (uintptr_t)p, (uintptr_t)q, 0x548288);
            x += rd32(BLOCK(world, 0x638617), (ptrdiff_t)(int32_t)d * 4) + rd32(BLOCK(world, 0x638767), 0);
        }
    }
    x = rd32(BLOCK(world, 0x63875f), 0);
    y = rd32(BLOCK(world, 0x638763), 0);
    for (i = 0; i < strlen((const char *)BLOCK(world, 0x63885f)); i++) {
        d = (uint32_t)((int32_t)(int8_t)*BLOCK(world, 0x63885f + i) - 0x30);
        q[0] = x;
        q[1] = y;
        q[2] = x + rd32(BLOCK(world, 0x638617), (ptrdiff_t)(int32_t)d * 4) - 1u;
        q[3] = y + rd32(BLOCK(world, 0x63863f), (ptrdiff_t)(int32_t)d * 4) - 1u;
        call5(host, 0x4c5d4b, 0x5cf659,
              rd32(world->table_5d1599, (ptrdiff_t)(int32_t)(rd32(BLOCK(world, 0x63876f), 0) * 0x4au)), world->value_5cf665,
              0x6386bfu + d * 16u, (uintptr_t)q, 0x5482b4);
        x += rd32(BLOCK(world, 0x638617), (ptrdiff_t)(int32_t)d * 4) + rd32(BLOCK(world, 0x638767), 0);
    }
    copy_string(BLOCK(world, 0x63887d), BLOCK(world, 0x63885f));
}

/* original GAME.EXE 0x48d5f4 (FUN_0048d5f4), this = self (no stack argument, plain ret): rec = the dword of the 0x5bb5e5-based record at
 * the signed word [self+0x1e] (stride 0x8d), read once. Nothing unless the dword [self+0x33] is non-zero, the dword [self+0x2b] is 1 and
 * the dword at record +0x4d is 1. Then, when the dword 0x5c39e5 is 0x2766: byte [self+0x37] := 1 and the dword at record +0x4d := 2. When
 * it is 0x2765: byte [self+0x26] := 1 if the dword [self+0x2f] is non-zero; word [self+0x29] := word [self+0x27]; for i = 0, 1, ... while
 * i < the signed word [rec+0x317] - 1: word [self + i*2 + 0x3d] := word [self + i*2 + 0x3f]; word [self + (the signed word [rec+0x317])*2
 * + 0x3b] := word [self+0x27]; the string at rec + (the signed word [self+0x27])*0x42 + 0x337 is copied to rec + 0x715 (strlen + 1
 * bytes). When the dword 0x5bb1ca is non-zero and the nine bytes at rec + 0x715 differ from those at 0x54e88c: n = the signed word
 * [rec+0x736]; when 0x4f6334 on 0x5cf1eb with n returns 0: 0x4fb77a on 0x5c3a67 with rec + 0x715, 0x4fb2e3 on 0x5c3a67 with the word
 * [rec+0x736], byte [self+0x24] := 1 and dword [self+0x39] := GetTickCount + 0x1f4. Finally (also when none of that happened) s = 0x423259
 * on 0x619a6b with rec + (the signed word [self+0x27])*0x42 + 0x358, which returns the address of a string (or 0): when s is not 0 and
 * strlen(s) <= 0x9c40, a local buffer receives the string and the dword 0x54e898 is stored at its terminator (an inlined strcat of 4
 * bytes), and 0x448d11 on 0x619a05 is called with (dword 0x5d03b3, buffer, 0xffffffff, 0). (The original's buffer is a 0xc0-odd-byte
 * stack local that a longer string overruns; here it is large enough for every string that passes the 0x9c40 test.) */
void m48d5f4_confirm_pick(uint8_t *self, Fl20bWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = rd32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d);
    uint8_t *rec;
    int32_t i;
    if (rd32(self, 0x33) == 0) return;
    if (rd32(self, 0x2b) != 1) return;
    if (rd32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d + 0x4d) != 1) return;
    if (world->value_5c39e5 == 0x2766) {
        self[0x37] = 1;
        wr32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d + 0x4d, 2);
        return;
    }
    if (world->value_5c39e5 != 0x2765) return;
    rec = (uint8_t *)host->resolve(host->context, rec_va);
    if (rd32(self, 0x2f) != 0) self[0x26] = 1;
    wr16(self, 0x29, rd16(self, 0x27));
    for (i = 0; i < rds16(rec, 0x317) - 1; i++) wr16(self, (ptrdiff_t)i * 2 + 0x3d, rd16(self, (ptrdiff_t)i * 2 + 0x3f));
    wr16(self, (ptrdiff_t)rds16(rec, 0x317) * 2 + 0x3b, rd16(self, 0x27));
    copy_string(rec + 0x715, rec + (ptrdiff_t)rds16(self, 0x27) * 0x42 + 0x337);
    if (world->value_5bb1ca != 0 && memcmp(rec + 0x715, world->bytes_54e88c, 9) != 0) {
        if (call1(host, 0x4f6334, 0x5cf1eb, (uintptr_t)(uint32_t)rds16(rec, 0x736)) == 0) {
            call1(host, 0x4fb77a, 0x5c3a67, rec_va + 0x715u);
            call1(host, 0x4fb2e3, 0x5c3a67, rd16(rec, 0x736));
            self[0x24] = 1;
            wr32(self, 0x39, (host->tick != NULL ? host->tick(host->context) : 0) + 0x1f4u);
        }
    }
    {
        uint32_t text_va = call1(host, 0x423259, 0x619a6b,
                                 rec_va + (uint32_t)((int32_t)rds16(self, 0x27) * 0x42) + 0x358u);
        if (text_va != 0) {
            const uint8_t *text = host->resolve(host->context, text_va);
            if (strlen((const char *)text) <= 0x9c40) {
                uint8_t buffer[0x9c50];
                copy_string(buffer, text);
                wr32(buffer, (ptrdiff_t)strlen((const char *)buffer), world->value_54e898);
                call4(host, 0x448d11, 0x619a05, world->value_5d03b3, (uintptr_t)buffer, 0xffffffffu, 0);
            }
        }
    }
}

/* original GAME.EXE 0x48cc70 (FUN_0048cc70, no this, no stack argument, plain ret): rec = the dword of the 0x5bb5e5-based record at the
 * signed word 0x6246ac (stride 0x8d; an original address) and kind = the byte [rec+0x42] (both read first). Nothing more unless the
 * byte 0x6246a3 is non-zero. a = { dword [rec+0x54] + signed word 0x6246c7, dword [rec+0x58] + signed word 0x6246c9, dword [rec+0x5c] +
 * word 0x6246c7, dword [rec+0x60] + word 0x6246c9 } and b = { dword [rec+0x64] + origin_x 0x583186, dword [rec+0x68] + origin_y
 * 0x58318a, dword [rec+0x6c] + origin_x, dword [rec+0x70] + origin_y } (locals). When kind is 2: 0x4c5377 on 0x5cf659 with (dword
 * 0x5d15e3, dword 0x5cf665, rec + 0x64, &b, 0x54e760), then 0x4c5d4b on 0x5cf659 with (the dword at 0x5d1599 + signed word 0x6246b4 *
 * 0x4a, dword 0x5cf665, &a, &b, 0x54e778); otherwise 0x4c5377 with (the dword at 0x5d1599 + word 0x6246b4 * 0x4a, dword 0x5cf665, &a,
 * &b, 0x54e794). Then for k = 0 .. 3 (a signed word): b := { dword [rec + k*16 + 0x74] + origin_x, dword [rec + k*16 + 0x78] + origin_y,
 * dword [rec + k*16 + 0x7c] + origin_x, dword [rec + k*16 + 0x80] + origin_y }; when the byte 0x6246be[k] is non-zero and the byte
 * 0x6246ba[k] is 0: 0x4c5d4b with (the dword at 0x5d1599 + signed word 0x6246b6 * 0x4a, dword 0x5cf665, rec + k*16 + 0xf4, &b,
 * 0x54e7b0); otherwise, when the byte 0x6246c6 and the byte 0x6246c2[k] are non-zero and k equals the byte 0x6246a2: 0x4c5d4b with (the
 * same table dword, dword 0x5cf665, rec + k*16 + 0xb4, &b, 0x54e7cc); otherwise 0x4c5377 with (dword 0x5d15e3, dword 0x5cf665, rec +
 * k*16 + 0x74, &b, 0x54e7e4). */
void m48cc70_draw_slots(const Fl20bWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = rd32(world->records_5bb5e5, (ptrdiff_t)world->word_6246ac * 0x8d);
    const uint8_t *rec = host->resolve(host->context, rec_va);
    uint8_t kind = rec[0x42];
    uint32_t a[4], b[4];
    int16_t k;
    if (world->byte_6246a3 == 0) return;
    a[1] = rd32(rec, 0x58) + (uint32_t)(int32_t)world->word_6246c9;
    a[3] = rd32(rec, 0x60) + (uint32_t)(int32_t)world->word_6246c9;
    a[0] = rd32(rec, 0x54) + (uint32_t)(int32_t)world->word_6246c7;
    a[2] = rd32(rec, 0x5c) + (uint32_t)(int32_t)world->word_6246c7;
    b[1] = rd32(rec, 0x68) + (uint32_t)world->origin_y_58318a;
    b[3] = rd32(rec, 0x70) + (uint32_t)world->origin_y_58318a;
    b[0] = rd32(rec, 0x64) + (uint32_t)world->origin_x_583186;
    b[2] = rd32(rec, 0x6c) + (uint32_t)world->origin_x_583186;
    if (kind == 2) {
        call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, rec_va + 0x64u, (uintptr_t)b, 0x54e760);
        call5(host, 0x4c5d4b, 0x5cf659, rd32(world->table_5d1599, (ptrdiff_t)world->word_6246b4 * 0x4a), world->value_5cf665,
              (uintptr_t)a, (uintptr_t)b, 0x54e778);
    } else {
        call5(host, 0x4c5377, 0x5cf659, rd32(world->table_5d1599, (ptrdiff_t)world->word_6246b4 * 0x4a), world->value_5cf665,
              (uintptr_t)a, (uintptr_t)b, 0x54e794);
    }
    for (k = 0; k < 4; k++) {
        ptrdiff_t line = (ptrdiff_t)k * 16;
        b[1] = rd32(rec, line + 0x78) + (uint32_t)world->origin_y_58318a;
        b[3] = rd32(rec, line + 0x80) + (uint32_t)world->origin_y_58318a;
        b[0] = rd32(rec, line + 0x74) + (uint32_t)world->origin_x_583186;
        b[2] = rd32(rec, line + 0x7c) + (uint32_t)world->origin_x_583186;
        if (world->bytes_6246be[k] != 0 && world->bytes_6246ba[k] == 0) {
            call5(host, 0x4c5d4b, 0x5cf659, rd32(world->table_5d1599, (ptrdiff_t)world->word_6246b6 * 0x4a), world->value_5cf665,
                  rec_va + (uint32_t)line + 0xf4u, (uintptr_t)b, 0x54e7b0);
        } else if (world->byte_6246c6 != 0 && world->bytes_6246c2[k] != 0 && (int32_t)k == (int32_t)world->byte_6246a2) {
            call5(host, 0x4c5d4b, 0x5cf659, rd32(world->table_5d1599, (ptrdiff_t)world->word_6246b6 * 0x4a), world->value_5cf665,
                  rec_va + (uint32_t)line + 0xb4u, (uintptr_t)b, 0x54e7cc);
        } else {
            call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, rec_va + (uint32_t)line + 0x74u, (uintptr_t)b,
                  0x54e7e4);
        }
    }
}

/* original GAME.EXE 0x4876ed (FUN_004876ed, no this, no stack argument, plain ret): rec = the dword of the 0x5bb5e5-based record at the
 * signed word 0x6252d3 (stride 0x8d; an original address). When the dword 0x625d43 or the dword 0x625d3f is non-zero: 0x4c5377 on
 * 0x5cf659 with (dword 0x5d15e3, dword 0x5cf665, 0x625d4d, 0x625d6d, 0x54dc64) and dword 0x625d43 := 0. When the dword 0x625d47 is
 * non-zero: 0x4841cb on 0x6252ad with (0x625d8d, &r) (r a local rectangle that it fills), 0x4c5377 on 0x5cf659 with (dword 0x5d15e3,
 * dword 0x5cf665, 0x625d8d, &r, 0x54dc98) and dword 0x625d47 := 0. Then n = the signed word [rec+0x21] and m = n (minus 1, 16 bits,
 * when the dword 0x625d3f is non-zero); i := 0, j := 0 (signed words); while j != m: for s = 0, 1, ... while s < n: (skipping s when the
 * dword 0x625d3f is non-zero and s equals the signed word 0x625d4b) the item is at 0x6252d5 + s * 0x85 (the 0x6252d5-based table);
 * when its signed word at +0 equals i: with b = its byte +0x22, when its byte +0x84 is non-zero 0x4c5d4b on 0x5cf659 with (the dword
 * item + b*0x18 + 0x24, dword 0x5cf665, item + b*0x18 + 0x28, item + 0x12, 0x54dcc8), otherwise with (dword 0x6252cf, dword 0x5cf665,
 * rec + s*0x42 + 0x7f, item + 0x12, 0x54dce8); then j++ and, when j == m, the scan of this i stops; after each i (whole scan or
 * stopped) i++ (16-bit). Then, when the dword 0x625d3f is non-zero: the item of the signed word 0x625d4b (b as above): 0x4c5d4b with
 * (the dword item + b*0x18 + 0x24, dword 0x5cf665, item + b*0x18 + 0x28, 0x625d7d, 0x54dd0c). Finally, when the dword 0x625e40 is
 * non-zero: 0x4841cb on 0x6252ad with (rec + 0x5e8, &r) and 0x4c5377 on 0x5cf659 with (dword 0x6252cb, dword 0x5cf665, 0x625e44, &r,
 * 0x54dd34); otherwise, when the dword 0x625e3c is non-zero: 0x4841cb with (rec + 0x5e8, &r), 0x4c5377 with (dword 0x5d15e3, dword
 * 0x5cf665, rec + 0x5e8, &r, 0x54dd50) and dword 0x625e3c := 0. (The addresses 0x625d.. and the item addresses are original globals
 * that only the callees read; item addresses are 0x6252d5 + the offsets above.) */
void m4876ed_redraw_items(Fl20bWorld *world, const Fl18Host *host)
{
    uint32_t rec_va = rd32(world->records_5bb5e5, (ptrdiff_t)world->word_6252d3 * 0x8d);
    const uint8_t *rec;
    uint32_t r[4];
    int16_t n, m, i, j, s;
    memset(r, 0, sizeof r);
    if (world->value_625d43 != 0 || world->value_625d3f != 0) {
        call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, 0x625d4d, 0x625d6d, 0x54dc64);
        world->value_625d43 = 0;
    }
    if (world->value_625d47 != 0) {
        call2(host, 0x4841cb, 0x6252ad, 0x625d8d, (uintptr_t)r);
        call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, 0x625d8d, (uintptr_t)r, 0x54dc98);
        world->value_625d47 = 0;
    }
    rec = host->resolve(host->context, rec_va);
    n = (int16_t)rd16(rec, 0x21);
    m = n;
    if (world->value_625d3f != 0) m = (int16_t)(m - 1);
    i = 0;
    j = 0;
    while (j != m) {
        for (s = 0; s < n; s = (int16_t)(s + 1)) {
            ptrdiff_t item;
            uint32_t item_va;
            if (world->value_625d3f != 0 && world->word_625d4b == s) continue;
            item = (ptrdiff_t)s * 0x85;
            item_va = 0x6252d5u + (uint32_t)(int32_t)((int32_t)s * 0x85);
            if ((int16_t)rd16(world->items_6252d5, item) != i) continue;
            {
                ptrdiff_t entry = (ptrdiff_t)world->items_6252d5[item + 0x22] * 0x18;
                if (world->items_6252d5[item + 0x84] != 0)
                    call5(host, 0x4c5d4b, 0x5cf659, rd32(world->items_6252d5, item + entry + 0x24), world->value_5cf665,
                          item_va + (uint32_t)entry + 0x28u, item_va + 0x12u, 0x54dcc8);
                else
                    call5(host, 0x4c5d4b, 0x5cf659, world->value_6252cf, world->value_5cf665,
                          rec_va + (uint32_t)((int32_t)s * 0x42) + 0x7fu, item_va + 0x12u, 0x54dce8);
            }
            j = (int16_t)(j + 1);
            if (j == m) break;
        }
        i = (int16_t)(i + 1);
    }
    if (world->value_625d3f != 0) {
        ptrdiff_t item = (ptrdiff_t)world->word_625d4b * 0x85;
        uint32_t item_va = 0x6252d5u + (uint32_t)((int32_t)world->word_625d4b * 0x85);
        ptrdiff_t entry = (ptrdiff_t)world->items_6252d5[item + 0x22] * 0x18;
        call5(host, 0x4c5d4b, 0x5cf659, rd32(world->items_6252d5, item + entry + 0x24), world->value_5cf665,
              item_va + (uint32_t)entry + 0x28u, 0x625d7d, 0x54dd0c);
    }
    if (world->value_625e40 != 0) {
        call2(host, 0x4841cb, 0x6252ad, rec_va + 0x5e8u, (uintptr_t)r);
        call5(host, 0x4c5377, 0x5cf659, world->value_6252cb, world->value_5cf665, 0x625e44, (uintptr_t)r, 0x54dd34);
    } else if (world->value_625e3c != 0) {
        call2(host, 0x4841cb, 0x6252ad, rec_va + 0x5e8u, (uintptr_t)r);
        call5(host, 0x4c5377, 0x5cf659, world->value_5d15e3, world->value_5cf665, rec_va + 0x5e8u, (uintptr_t)r, 0x54dd50);
        world->value_625e3c = 0;
    }
}

/* the point (x, y) lies on or inside the box of the object rec whose dword edges are at the given offsets (signed compares) */
UNUSED_OK static int in_box(const uint8_t *rec, int32_t x, int32_t y, ptrdiff_t xlo, ptrdiff_t xhi, ptrdiff_t ylo, ptrdiff_t yhi)
{
    return y >= (int32_t)rd32(rec, ylo) && y <= (int32_t)rd32(rec, yhi) && x >= (int32_t)rd32(rec, xlo) && x <= (int32_t)rd32(rec, xhi);
}

/* original GAME.EXE 0x44d28c (FUN_0044d28c), this = self, stack arguments x and y (words, sign-extended; ret 8); returns 1 or 0. When
 * the dword [self+0x25] is 0: byte [self+0x24] := 0, returns 0. Otherwise byte [self+0x24] := 1; rec = the dword of the 0x5bb5e5-based
 * record at the signed word [self+0x1e] (stride 0x8d; host memory through resolve). When x > dword [rec+0x99], or y > dword [rec+0x8d],
 * or x < dword [rec+0x51]: dword [self+0x29] := 0, returns 0. Otherwise dword [self+0x29] := 1 and the first box (signed compares,
 * edges inclusive; fields are x low, x high, y low, y high) that holds the point decides: when the dword [self+0x2d] is 0, box
 * [rec+0x61, 0x69, 0x65, 0x6d]: 0x44d597 on self with 1, returns 1; when it is 1, in this order, [0x51, 0x59, 0x55, 0x5d]: 0x44d597 with
 * 0; [0x91, 0x99, 0x95, 0x9d]: with 3; [0xa1, 0xa9, 0xa5, 0xad]: with 4; [0x71, 0x79, 0x75, 0x7d]: with 6 (each then returns 1); for any
 * value [0x81, 0x89, 0x85, 0x8d]: 0x44d597 with 8, returns 1; [0x21, 0x29, 0x25, 0x2d], [0x31, 0x39, 0x35, 0x3d] or [0xb1, 0xb9, 0xb5,
 * 0xbd]: byte [self+0x24] := 1, returns 0; none: byte [self+0x24] := 0, returns 0. (0x44d597 is also ported, as m44d597_press in FL-19;
 * here it goes through the host.) */
int32_t m44d28c_click(uint8_t *self, int16_t x, int16_t y, const Fl20bWorld *world, const Fl18Host *host)
{
    const uint8_t *rec;
    int32_t px = x, py = y;
    if (rd32(self, 0x25) == 0) {
        self[0x24] = 0;
        return 0;
    }
    self[0x24] = 1;
    rec = host->resolve(host->context, rd32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d));
    if (px > (int32_t)rd32(rec, 0x99) || py > (int32_t)rd32(rec, 0x8d) || px < (int32_t)rd32(rec, 0x51)) {
        wr32(self, 0x29, 0);
        return 0;
    }
    wr32(self, 0x29, 1);
    if (rd32(self, 0x2d) == 0 && in_box(rec, px, py, 0x61, 0x69, 0x65, 0x6d)) {
        call1(host, 0x44d597, (uintptr_t)self, 1);
        return 1;
    }
    if (rd32(self, 0x2d) == 1) {
        if (in_box(rec, px, py, 0x51, 0x59, 0x55, 0x5d)) {
            call1(host, 0x44d597, (uintptr_t)self, 0);
            return 1;
        }
        if (in_box(rec, px, py, 0x91, 0x99, 0x95, 0x9d)) {
            call1(host, 0x44d597, (uintptr_t)self, 3);
            return 1;
        }
        if (in_box(rec, px, py, 0xa1, 0xa9, 0xa5, 0xad)) {
            call1(host, 0x44d597, (uintptr_t)self, 4);
            return 1;
        }
        if (in_box(rec, px, py, 0x71, 0x79, 0x75, 0x7d)) {
            call1(host, 0x44d597, (uintptr_t)self, 6);
            return 1;
        }
    }
    if (in_box(rec, px, py, 0x81, 0x89, 0x85, 0x8d)) {
        call1(host, 0x44d597, (uintptr_t)self, 8);
        return 1;
    }
    if (in_box(rec, px, py, 0x21, 0x29, 0x25, 0x2d) || in_box(rec, px, py, 0x31, 0x39, 0x35, 0x3d)) {
        self[0x24] = 1;
        return 0;
    }
    if (in_box(rec, px, py, 0xb1, 0xb9, 0xb5, 0xbd)) {
        self[0x24] = 1;
        return 0;
    }
    self[0x24] = 0;
    return 0;
}

/* the byte of the cell (a, b) of the 0x30-based table of the object self: self + a * 0xc8 + 0x30 + b * 0x14 + 2 (32-bit products) */
UNUSED_OK static uint8_t *swap_cell(uint8_t *self, uint32_t a, uint32_t b)
{
    return self + (ptrdiff_t)(int32_t)(a * 0xc8u) + 0x30 + (ptrdiff_t)(int32_t)(b * 0x14u) + 2;
}

/* original GAME.EXE 0x47608e (FUN_0047608e), this = self (no stack argument, plain ret): rec = the dword of the 0x5bb5e5-based record at
 * the signed word [self+0x22] (stride 0x8d; an original address). Nothing unless the dword [self+0x89a] is non-zero, the dwords
 * [self+0x1c] and [self+0x2c] are 0, the bytes [self+0x8d8] and [self+0x8d9] are 0 and the dword at record +0x4d is 1. Then by the
 * dword 0x5c39e5: 0x27d6: dword [self+0x89e] := 1 and the dword at record +0x4d := 2. 0x27d5: when the dword [self+0x8b6] is non-zero:
 * (when the nine bytes at rec + 0x74c differ from those at 0x54c844 and 0x4f6334 on 0x5cf1eb with the signed word [rec+0x76d]
 * returns 0: 0x4fb2e3 on 0x5c3a67 with that word,) then dword [self+0x8aa] := dword [self+0x8be], dword [self+0x8a6] := dword
 * [self+0x8ba], dword [self+0x8b6] := 0; otherwise dword [self+0x8b6] := 1, the same compare / calls against the nine bytes at
 * 0x54c850, then the words at self + dword[0x8aa] * 0xc8 + 0x30 + dword[0x8a6] * 0x14 + 2 and at self + dword[0x8be] * 0xc8 + 0x30 +
 * dword[0x8ba] * 0x14 + 2 are exchanged, dword [self+0x8b2] := dword [self+0x8be], dword [self+0x8ae] := dword [self+0x8ba], bytes
 * [self+0x8d8] and [self+0x8d9] := 1. 0x27d7: the compare of the nine bytes at rec + 0x71b with those at 0x54c85c and (when different) the
 * same 0x4f6334 / 0x4fb2e3 calls with the signed word [rec+0x73c]; dword [self+0x8ca] := GetTickCount + 0xfa; byte [self+0x898] := 1;
 * dword [self+0x2c] := 3. */
void m47608e_step_swap(uint8_t *self, Fl20bWorld *world, const Fl18Host *host)
{
    ptrdiff_t slot = (ptrdiff_t)rds16(self, 0x22) * 0x8d;
    uint8_t *rec;
    if (rd32(self, 0x89a) == 0) return;
    if (rd32(self, 0x1c) != 0) return;
    if (rd32(self, 0x2c) != 0) return;
    if (self[0x8d8] != 0) return;
    if (self[0x8d9] != 0) return;
    if (rd32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x22) * 0x8d + 0x4d) != 1) return;
    if (world->value_5c39e5 == 0x27d6) {
        wr32(self, 0x89e, 1);
        wr32(world->records_5bb5e5, (ptrdiff_t)rds16(self, 0x22) * 0x8d + 0x4d, 2);
        return;
    }
    if (world->value_5c39e5 == 0x27d5) {
        rec = (uint8_t *)host->resolve(host->context, rd32(world->records_5bb5e5, slot));
        if (rd32(self, 0x8b6) != 0) {
            if (memcmp(rec + 0x74c, world->bytes_54c844, 9) != 0) {
                if (call1(host, 0x4f6334, 0x5cf1eb, (uintptr_t)(uint32_t)rds16(rec, 0x76d)) == 0)
                    call1(host, 0x4fb2e3, 0x5c3a67, rd16(rec, 0x76d));
            }
            wr32(self, 0x8aa, rd32(self, 0x8be));
            wr32(self, 0x8a6, rd32(self, 0x8ba));
            wr32(self, 0x8b6, 0);
        } else {
            uint16_t keep, moved;
            wr32(self, 0x8b6, 1);
            if (memcmp(rec + 0x74c, world->bytes_54c850, 9) != 0) {
                if (call1(host, 0x4f6334, 0x5cf1eb, (uintptr_t)(uint32_t)rds16(rec, 0x76d)) == 0)
                    call1(host, 0x4fb2e3, 0x5c3a67, rd16(rec, 0x76d));
            }
            keep = rd16(swap_cell(self, rd32(self, 0x8aa), rd32(self, 0x8a6)), 0);
            moved = rd16(swap_cell(self, rd32(self, 0x8be), rd32(self, 0x8ba)), 0);
            wr16(swap_cell(self, rd32(self, 0x8aa), rd32(self, 0x8a6)), 0, moved);
            wr16(swap_cell(self, rd32(self, 0x8be), rd32(self, 0x8ba)), 0, keep);
            wr32(self, 0x8b2, rd32(self, 0x8be));
            wr32(self, 0x8ae, rd32(self, 0x8ba));
            self[0x8d8] = 1;
            self[0x8d9] = 1;
        }
    } else if (world->value_5c39e5 == 0x27d7) {
        rec = (uint8_t *)host->resolve(host->context, rd32(world->records_5bb5e5, slot));
        if (memcmp(rec + 0x71b, world->bytes_54c85c, 9) != 0) {
            if (call1(host, 0x4f6334, 0x5cf1eb, (uintptr_t)(uint32_t)rds16(rec, 0x73c)) == 0)
                call1(host, 0x4fb2e3, 0x5c3a67, rd16(rec, 0x73c));
        }
        wr32(self, 0x8ca, (host->tick != NULL ? host->tick(host->context) : 0) + 0xfau);
        self[0x898] = 1;
        wr32(self, 0x2c, 3);
    }
}

/* the object of the dword [self+8] (an original address), as host memory */
UNUSED_OK static uint8_t *owner_object(const uint8_t *self, const Fl18Host *host)
{
    return (uint8_t *)host->resolve(host->context, rd32(self, 8));
}

/* the signed 32-bit quotient-by-two of the original (cdq; sub eax, edx; sar eax, 1): rounds toward zero */
UNUSED_OK static uint32_t half_toward_zero(uint32_t value)
{
    int32_t d = (int32_t)value;
    int32_t sign = d < 0 ? -1 : 0;
    return (uint32_t)((int32_t)((uint32_t)d - (uint32_t)sign) >> 1);
}

/* original GAME.EXE 0x4b8a27 (FUN_004b8a27), this = self, stack argument n (word, sign-extended; ret 4). rand is 0x50cd50 (cdecl, no
 * argument, result in eax) and every division is the signed 32-bit idiv of the original (a zero divisor would fault there: the callers
 * never produce one, and nothing here guards it). obj = the dword [self+8] (an original address, re-read at each use). When the signed
 * word [self+0x48] + n < the signed word [obj+0x456]: word [self+0x48] := word [obj+0x456] (the local r that the loop below tests is
 * then uninitialised in the original; here it is 0, and the tests only run this path with no slots). Otherwise r = the low word of
 * rand() % (n + 1), drawn again until the signed word [self+0x48] + r lies within the signed words [obj+0x456] .. [obj+0x458], and the
 * word [self+0x48] := its low 16 bits + r. Then for s = 0, 1, ... (a signed word) while s < the signed word [obj+0x173] and r > 0, with
 * slot = self + s * 0x37: skipped when the dword [slot+0x7d] is non-zero; otherwise obj0 = the dword [self+8] (taken before the call),
 * k = the signed word returned by 0x4b866e on self, the four dwords at obj0 + k * 16 + 0x175 are copied to slot + 0x5a; dword [slot+0x5e]
 * and [slot+0x66] += origin_y 0x58318a, [slot+0x5a] and [slot+0x62] += origin_x 0x583186; dword [slot+0x6f] := [slot+0x66] - h + 6 with
 * h = ([slot+0x66] - [slot+0x5e]) / 2 rounded toward zero, dword [slot+0x6b] := [slot+0x62] - w - 8 with w = ([slot+0x62] - [slot+0x5a])
 * / 2 rounded toward zero; j = the low word of rand() % (the signed word [obj+0x21]) and the four dwords at obj + j * 16 + 0x23 are
 * copied to slot + 0x4a; dword [slot+0x7d] := 1; byte [slot+0x6a] := the low byte returned by 0x4b85f6 on self; dword [slot+0x77] :=
 * GetTickCount; word [slot+0x7b] := the low word of rand() % ([obj+0x454] + 1 - [obj+0x452]) + [obj+0x452] (signed words); r := r - 1. */
void m4b8a27_spawn_slots(uint8_t *self, int16_t n, const Fl20bWorld *world, const Fl18Host *host)
{
    int16_t r = 0;   /* uninitialised in the original on the first path */
    int16_t s;
    if ((int32_t)rds16(self, 0x48) + (int32_t)n < rds16(owner_object(self, host), 0x456)) {
        wr16(self, 0x48, rd16(owner_object(self, host), 0x456));
    } else {
        r = (int16_t)((int32_t)call0(host, 0x50cd50, 0) % ((int32_t)n + 1));
        for (;;) {
            int32_t sum = rds16(self, 0x48) + (int32_t)r;
            if (!(sum < rds16(owner_object(self, host), 0x456))) {
                if (!(rds16(self, 0x48) + (int32_t)r > rds16(owner_object(self, host), 0x458))) break;
            }
            r = (int16_t)((int32_t)call0(host, 0x50cd50, 0) % ((int32_t)n + 1));
        }
        wr16(self, 0x48, (uint16_t)(rd16(self, 0x48) + (uint16_t)r));
    }
    for (s = 0; (int32_t)s < rds16(owner_object(self, host), 0x173) && r > 0; s = (int16_t)(s + 1)) {
        ptrdiff_t slot = (ptrdiff_t)s * 0x37;
        const uint8_t *obj0;
        const uint8_t *src;
        int16_t k, j;
        int32_t draw;
        uint32_t half;
        if (rd32(self, slot + 0x7d) != 0) continue;
        obj0 = owner_object(self, host);
        k = (int16_t)call0(host, 0x4b866e, (uintptr_t)self);
        src = obj0 + (ptrdiff_t)k * 16 + 0x175;
        wr32(self, slot + 0x5a, rd32(src, 0));
        wr32(self, slot + 0x5e, rd32(src, 4));
        wr32(self, slot + 0x62, rd32(src, 8));
        wr32(self, slot + 0x66, rd32(src, 12));
        wr32(self, slot + 0x5e, rd32(self, slot + 0x5e) + (uint32_t)world->origin_y_58318a);
        wr32(self, slot + 0x66, rd32(self, slot + 0x66) + (uint32_t)world->origin_y_58318a);
        wr32(self, slot + 0x5a, rd32(self, slot + 0x5a) + (uint32_t)world->origin_x_583186);
        wr32(self, slot + 0x62, rd32(self, slot + 0x62) + (uint32_t)world->origin_x_583186);
        half = half_toward_zero(rd32(self, slot + 0x66) - rd32(self, slot + 0x5e));
        wr32(self, slot + 0x6f, rd32(self, slot + 0x66) - half + 6u);
        half = half_toward_zero(rd32(self, slot + 0x62) - rd32(self, slot + 0x5a));
        wr32(self, slot + 0x6b, rd32(self, slot + 0x62) - half - 8u);
        draw = (int32_t)call0(host, 0x50cd50, 0);
        j = (int16_t)(draw % rds16(owner_object(self, host), 0x21));
        src = owner_object(self, host) + (ptrdiff_t)j * 16 + 0x23;
        wr32(self, slot + 0x4a, rd32(src, 0));
        wr32(self, slot + 0x4e, rd32(src, 4));
        wr32(self, slot + 0x52, rd32(src, 8));
        wr32(self, slot + 0x56, rd32(src, 12));
        wr32(self, slot + 0x7d, 1);
        self[slot + 0x6a] = (uint8_t)call0(host, 0x4b85f6, (uintptr_t)self);
        wr32(self, slot + 0x77, host->tick != NULL ? host->tick(host->context) : 0);
        draw = (int32_t)call0(host, 0x50cd50, 0);   /* the draw first, then the two bounds are read (the original order) */
        {
            const uint8_t *o = owner_object(self, host);
            int32_t span = rds16(o, 0x454) + 1 - rds16(o, 0x452);
            wr16(self, slot + 0x7b, (uint16_t)(draw % span + rds16(o, 0x452)));
        }
        r = (int16_t)(r - 1);
    }
}
