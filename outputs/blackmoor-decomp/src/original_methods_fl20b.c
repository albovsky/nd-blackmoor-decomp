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
