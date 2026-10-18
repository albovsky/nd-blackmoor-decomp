#include "original_methods_fl20b.h"

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
