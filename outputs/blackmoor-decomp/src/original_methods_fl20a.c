#include "original_methods_fl20a.h"

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


/* host memory of the object of the 0x5bb5e5-based record at byte offset `slot` (index * 0x8d); the dword is re-read at every call */
UNUSED_OK static const uint8_t *record_object_at(const Fl20aWorld *world, const Fl18Host *host, ptrdiff_t slot)
{
    return host->resolve(host->context, rd32(world->records_5bb5e5, slot));
}

UNUSED_OK static uint8_t record_kind(const Fl20aWorld *world, const Fl18Host *host, ptrdiff_t slot)
{
    return record_object_at(world, host, slot)[0];
}

/* original GAME.EXE 0x4d3c88 (FUN_004d3c88), this = self (ecx; stored in the frame and not used), no stack argument, plain ret:
 * byte 0x61c6ad := 0. */
void m4d3c88_clear_flag(Fl20aWorld *world)
{
    world->byte_61c6ad = 0;
}

/* original GAME.EXE 0x4d3c5f (FUN_004d3c5f), this = self (no stack argument, plain ret): 0x4d3c31 on self; when it returns non-zero
 * 0x4d3d20 on self (the result is not used); then byte [self+0x326] := 1. */
void m4d3c5f_set_ready(uint8_t *self, const Fl18Host *host)
{
    if (call0(host, 0x4d3c31, (uintptr_t)self) != 0) call0(host, 0x4d3d20, (uintptr_t)self);
    self[0x326] = 1;
}

/* original GAME.EXE 0x41c509 (FUN_0041c509), this = ecx (stored in the frame and not used), stack argument arg (a record, ret 4):
 * word [arg+0x21] := 0xc; word [arg+0x23] := 2; word [arg+0x25] := 1; word [arg+0x27] := 1; dword [arg+0x29] := 1. */
void m41c509_init_fields(uint8_t *arg)
{
    wr16(arg, 0x21, 0xc);
    wr16(arg, 0x23, 2);
    wr16(arg, 0x25, 1);
    wr16(arg, 0x27, 1);
    wr32(arg, 0x29, 1);
}

/* original GAME.EXE 0x43ec4a (FUN_0043ec4a), this = self (ecx, kept in the frame, only passed on), stack arguments first, second and
 * third (dwords, ret 0xc; they are consecutive dwords in the frame): 0x4db000 on 0x5830a6 with (the address of first, the address of
 * second); a local triple := (second, third, first) (not read again); 0x51ab4b on self (no stack argument). The callee may change
 * the dwords through the pointers. */
void m43ec4a_forward_4db000(uintptr_t self, uint32_t first, uint32_t second, uint32_t third, const Fl18Host *host)
{
    uint32_t args[3];
    uint32_t local[3];
    args[0] = first;
    args[1] = second;
    args[2] = third;
    call2(host, 0x4db000, 0x5830a6, (uintptr_t)&args[0], (uintptr_t)&args[1]);
    local[0] = args[1];
    local[1] = args[2];
    local[2] = args[0];
    (void)local;
    call0(host, 0x51ab4b, self);
}

/* original GAME.EXE 0x43ec85 (FUN_0043ec85): the sibling of 0x43ec4a, same shape, with 0x4dafc3 in place of 0x4db000: 0x4dafc3 on
 * 0x5830a6 with (the address of first, the address of second); a local triple := (second, third, first); 0x51ab4b on self. */
void m43ec85_forward_4dafc3(uintptr_t self, uint32_t first, uint32_t second, uint32_t third, const Fl18Host *host)
{
    uint32_t args[3];
    uint32_t local[3];
    args[0] = first;
    args[1] = second;
    args[2] = third;
    call2(host, 0x4dafc3, 0x5830a6, (uintptr_t)&args[0], (uintptr_t)&args[1]);
    local[0] = args[1];
    local[1] = args[2];
    local[2] = args[0];
    (void)local;
    call0(host, 0x51ab4b, self);
}

/* original GAME.EXE 0x43ecc0 (FUN_0043ecc0): the sibling of 0x43ec4a, same shape, with 0x4db04f in place of 0x4db000: 0x4db04f on
 * 0x5830a6 with (the address of first, the address of second); a local triple := (second, third, first); 0x51ab4b on self. */
void m43ecc0_forward_4db04f(uintptr_t self, uint32_t first, uint32_t second, uint32_t third, const Fl18Host *host)
{
    uint32_t args[3];
    uint32_t local[3];
    args[0] = first;
    args[1] = second;
    args[2] = third;
    call2(host, 0x4db04f, 0x5830a6, (uintptr_t)&args[0], (uintptr_t)&args[1]);
    local[0] = args[1];
    local[1] = args[2];
    local[2] = args[0];
    (void)local;
    call0(host, 0x51ab4b, self);
}

/* original GAME.EXE 0x43ed71 (FUN_0043ed71): the sibling of 0x43ec4a, same shape, with 0x4daf9f in place of 0x4db000: 0x4daf9f on
 * 0x5830a6 with (the address of first, the address of second); a local triple := (second, third, first); 0x51ab4b on self. */
void m43ed71_forward_4daf9f(uintptr_t self, uint32_t first, uint32_t second, uint32_t third, const Fl18Host *host)
{
    uint32_t args[3];
    uint32_t local[3];
    args[0] = first;
    args[1] = second;
    args[2] = third;
    call2(host, 0x4daf9f, 0x5830a6, (uintptr_t)&args[0], (uintptr_t)&args[1]);
    local[0] = args[1];
    local[1] = args[2];
    local[2] = args[0];
    (void)local;
    call0(host, 0x51ab4b, self);
}

/* original GAME.EXE 0x475885 (FUN_00475885), this = self (no stack argument, plain ret): when the dword [self+0x24] is non-zero 0x4c2dfb
 * on 0x5cf659 with (the address self+0x24); likewise for the dword [self+0x28]; when the signed word [self+0x20] is not -1 0x4d3992
 * (cdecl, this 0) with that word; finally 0x4757da on self. */
void m475885_release(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x24) != 0) call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x24));
    if (rd32(self, 0x28) != 0) call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x28));
    if (rds16(self, 0x20) != -1) call1(host, 0x4d3992, 0, rd16(self, 0x20));
    call0(host, 0x4757da, (uintptr_t)self);
}

/* original GAME.EXE 0x4caf03 (FUN_004caf03), this = self (no stack argument, plain ret): dword [self+0x16] := 0; dword [self+0x1a] := 0;
 * word [self+0xc] := 0xffff; dword [self+0xe] := 0; dword [self+8] := 0; dword [self+0x14e] := 0; dword [self+0x12] := 0;
 * dword [self+0x154] := 0; dword [self+0x158] := 0; dword [self+0x14a] := 0xffffffff; dword [self+0x15c] := 0. */
void m4caf03_reset(uint8_t *self)
{
    wr32(self, 0x16, 0);
    wr32(self, 0x1a, 0);
    wr16(self, 0xc, 0xffff);
    wr32(self, 0xe, 0);
    wr32(self, 0x8, 0);
    wr32(self, 0x14e, 0);
    wr32(self, 0x12, 0);
    wr32(self, 0x154, 0);
    wr32(self, 0x158, 0);
    wr32(self, 0x14a, 0xffffffffu);
    wr32(self, 0x15c, 0);
}

/* original GAME.EXE 0x41c770 (FUN_0041c770), this = ecx (stored in the frame and not used), stack argument arg (a record, ret 4):
 * byte [arg+0x1b7] := 0; word [arg+0x1ba] := 0; word [arg+0x1bc] := 0; word [arg+0x1be] := 1; dword [arg+0x1c0] := 0;
 * dword [arg+0x1c4] := 0; dword [arg+0x1c8] := 1; word [arg+0x1cc] := 0xffff; byte [arg+0x1ce] := 1; word [arg+0x1cf] := 2. */
void m41c770_init_fields(uint8_t *arg)
{
    arg[0x1b7] = 0;
    wr16(arg, 0x1ba, 0);
    wr16(arg, 0x1bc, 0);
    wr16(arg, 0x1be, 1);
    wr32(arg, 0x1c0, 0);
    wr32(arg, 0x1c4, 0);
    wr32(arg, 0x1c8, 1);
    wr16(arg, 0x1cc, 0xffff);
    arg[0x1ce] = 1;
    wr16(arg, 0x1cf, 2);
}

/* original GAME.EXE 0x4757da (FUN_004757da), this = self (no stack argument, plain ret): word [self+0x22] := 0xffff; word [self+0x20]
 * := 0xffff; dword [self+0x89a] := 0; dword [self+0x89e] := 0; dword [self+0x1c] := 0; then for i = 0 .. 9 and j = 0 .. 9 (signed
 * words, j inner) the five dwords at self + i*0xc8 + 0x30 + j*0x14 are cleared (offsets 0, 4, 8, 0xc, 0x10). */
void m4757da_clear_grid(uint8_t *self)
{
    int16_t i, j;
    wr16(self, 0x22, 0xffff);
    wr16(self, 0x20, 0xffff);
    wr32(self, 0x89a, 0);
    wr32(self, 0x89e, 0);
    wr32(self, 0x1c, 0);
    for (i = 0; i < 10; i++) {
        for (j = 0; j < 10; j++) {
            ptrdiff_t cell = (ptrdiff_t)i * 0xc8 + 0x30 + (ptrdiff_t)j * 0x14;
            wr32(self, cell, 0);
            wr32(self, cell + 4, 0);
            wr32(self, cell + 8, 0);
            wr32(self, cell + 0xc, 0);
            wr32(self, cell + 0x10, 0);
        }
    }
}

/* original GAME.EXE 0x48bb86 (FUN_0048bb86), this = self (no stack argument, plain ret): when the dword [self+0x22] differs from the
 * dword [self+0x1e] 0x4c2dfb on 0x5cf659 with (the address self+0x22). Then, when the dword [self+0x1e] is non-zero and the byte
 * [self+0x45] is 0: 0x4c2dfb on 0x5cf659 with (the address self+0x1e); otherwise, when the dword [self+0x1e] is non-zero and the
 * byte [self+0x45] is 1: dword [self+0x1e] := 0. Then for the signed words [self+0x2e] and [self+0x30], each when it is not -1:
 * 0x4d3992 (cdecl, this 0) with that word. Finally 0x48bb17 on self. */
void m48bb86_release(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x22) != rd32(self, 0x1e)) call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x22));
    if (rd32(self, 0x1e) != 0 && self[0x45] == 0) {
        call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x1e));
    } else if (rd32(self, 0x1e) != 0 && self[0x45] == 1) {
        wr32(self, 0x1e, 0);
    }
    if (rds16(self, 0x2e) != -1) call1(host, 0x4d3992, 0, rd16(self, 0x2e));
    if (rds16(self, 0x30) != -1) call1(host, 0x4d3992, 0, rd16(self, 0x30));
    call0(host, 0x48bb17, (uintptr_t)self);
}

/* original GAME.EXE 0x483fb5 (FUN_00483fb5), this = self (no stack argument, plain ret): when the dword [self+0x1e] is non-zero
 * 0x4c2dfb on 0x5cf659 with (the address self+0x1e), then the dword := 0; likewise for the dword [self+0x22]. Then for i = 0 .. 0x13
 * and j = 0 .. 3 (signed words, j inner) with p = self + i*0x85 + 0x28 + j*0x18 + 0x24: when the dword [p] is non-zero 0x4c2dfb on
 * 0x5cf659 with (the address p), then the dword [p] := 0. Then, when the signed word [self+0x1c] is not -1, 0x4d3992 (cdecl, this 0)
 * with that word; finally 0x483f6a on self. */
void m483fb5_release_all(uint8_t *self, const Fl18Host *host)
{
    int16_t i, j;
    if (rd32(self, 0x1e) != 0) {
        call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x1e));
        wr32(self, 0x1e, 0);
    }
    if (rd32(self, 0x22) != 0) {
        call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + 0x22));
        wr32(self, 0x22, 0);
    }
    for (i = 0; i < 0x14; i++) {
        for (j = 0; j < 4; j++) {
            ptrdiff_t p = (ptrdiff_t)i * 0x85 + 0x28 + (ptrdiff_t)j * 0x18 + 0x24;
            if (rd32(self, p) != 0) {
                call1(host, 0x4c2dfb, 0x5cf659, (uintptr_t)(self + p));
                wr32(self, p, 0);
            }
        }
    }
    if (rds16(self, 0x1c) != -1) call1(host, 0x4d3992, 0, rd16(self, 0x1c));
    call0(host, 0x483f6a, (uintptr_t)self);
}

/* original GAME.EXE 0x4343a2 (FUN_004343a2), this = self, stack argument name (a zero-terminated string, ret 4); returns 1 or 0.
 * For i = 0, 1, ... while i < the signed dword [self+0x5f68]: rec = the dword [self + i*4 + 0x20e4] (an original address); s =
 * 0x434814 on self with rec (the address of a zero-terminated string; compared with name by an inlined strcmp). When equal (unlike
 * 0x434630 there is no flag dword to test or set): rec += 4; dword [self+0x112c] := 0x4347b8 on self with rec; rec += 4; dword
 * [self+0x1120] := rec; the string s (with its terminator, an inlined strcpy) is copied to self + 0x1130; returns 1. Returns 0 when
 * no entry matches. */
int32_t m4343a2_find_name(uint8_t *self, const uint8_t *name, const Fl18Host *host)
{
    int32_t i;
    for (i = 0; i < (int32_t)rd32(self, 0x5f68); i++) {
        uint32_t rec = rd32(self, (ptrdiff_t)i * 4 + 0x20e4);
        uint32_t text = call1(host, 0x434814, (uintptr_t)self, rec);
        const uint8_t *s = host->resolve(host->context, text);
        if (strcmp((const char *)s, (const char *)name) == 0) {
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

/* original GAME.EXE 0x44727a (FUN_0044727a), this = self, stack argument index (a signed word, ret 4): the record is the dword of the
 * 0x5bb5e5-based record at index (stride 0x8d), its state the dword at record +0x4d (0x5bb632 + index * 0x8d). State 0: nothing when
 * the byte [self+0x1c] is non-zero; otherwise byte [self+0x1c] := 1; the 0x15 bytes at the object of the record are copied to self
 * + 0x49 (five dwords, then one byte); when the dword [self+0x5a] - [self+0x52] is 0, or else [self+0x56] - [self+0x4e] is 0,
 * the four dwords at self + 0x1d are the dwords 0x583186, 0x58318a, 0x58318e, 0x583192 (offsets 0, 4, 8, 0xc); otherwise dword
 * [self+0x21] += [self+0x52]; dword [self+0x29] := [self+0x5a] + dword 0x58318a; dword [self+0x1d] += [self+0x4e]; dword [self+0x25]
 * := [self+0x56] + dword 0x583186. Then 0x4473a9 on self and the state := 2. State 2: 0x42ba3a (cdecl, this 0) with the word index.
 * Any other state: nothing. */
void m44727a_start_record(uint8_t *self, int16_t index, const Fl20aWorld *world, const Fl18Host *host)
{
    ptrdiff_t slot = (ptrdiff_t)index * 0x8d;
    uint32_t state = rd32(world->records_5bb5e5, slot + 0x4d);
    if (state == 0) {
        const uint8_t *src;
        uint8_t *dst;
        int n;
        if (self[0x1c] != 0) return;
        self[0x1c] = 1;
        src = host->resolve(host->context, rd32(world->records_5bb5e5, slot));
        dst = self + 0x49;
        for (n = 0; n < 5; n++) {   /* rep movsd, forward */
            wr32(dst, n * 4, rd32(src, n * 4));
        }
        dst[0x14] = src[0x14];      /* movsb */
        if (rd32(self, 0x5a) - rd32(self, 0x52) == 0 || rd32(self, 0x56) - rd32(self, 0x4e) == 0) {
            wr32(self, 0x1d, (uint32_t)world->origin_x_583186);
            wr32(self, 0x21, (uint32_t)world->origin_y_58318a);
            wr32(self, 0x25, (uint32_t)world->corner_x_58318e);
            wr32(self, 0x29, (uint32_t)world->corner_y_583192);
        } else {
            wr32(self, 0x21, rd32(self, 0x21) + rd32(self, 0x52));
            wr32(self, 0x29, rd32(self, 0x5a) + (uint32_t)world->origin_y_58318a);
            wr32(self, 0x1d, rd32(self, 0x1d) + rd32(self, 0x4e));
            wr32(self, 0x25, rd32(self, 0x56) + (uint32_t)world->origin_x_583186);
        }
        call0(host, 0x4473a9, (uintptr_t)self);
        wr32(world->records_5bb5e5, slot + 0x4d, 2);
    } else if (state == 2) {
        call1(host, 0x42ba3a, 0, (uint16_t)index);
    }
}

/* original GAME.EXE 0x42b87a (FUN_0042b87a), no this, stack argument index (a signed word, ret 0 from a cdecl caller: plain ret): the
 * record object is re-read from the 0x5bb5e5-based record at index (stride 0x8d) at every use; its byte [obj] minus 1, as an unsigned
 * value above 5, does nothing here. Case 0 (byte 1): word 0x585d51 := word [obj+1]; word 0x585d4f := word [obj+3]. Case 1 (2): word
 * 0x585d51 += word [obj+1]; word 0x585d4f += word [obj+3] (16-bit wrap). Case 2 (3): 0x4d3c5f on 0x61c387. Case 3 (4): 0x4d3c88 on
 * 0x61c387. Case 4 (5): 0x4d3c88 on 0x61c387, then as case 0. Case 5 (6): 0x4d3c88 on 0x61c387, then as case 1. Then, in every case:
 * dword 0x585d4b := signed word 0x585d51 * 0x3c + signed word 0x585d4f; dword 0x585d55 := GetTickCount + signed word 0x5b0280;
 * 0x42ba3a (cdecl, this 0) with the word index. (The switch is the jump table at 0x42ba22.) */
void m42b87a_apply_record(int16_t index, Fl20aWorld *world, const Fl18Host *host)
{
    ptrdiff_t slot = (ptrdiff_t)index * 0x8d;
    uint32_t kind = (uint32_t)record_kind(world, host, slot) - 1u;
    if (kind <= 5) {
        switch (kind) {
        case 4:
            call0(host, 0x4d3c88, 0x61c387);
            /* fall through */
        case 0:
            world->word_585d51 = (int16_t)rd16(record_object_at(world, host, slot), 1);
            world->word_585d4f = (int16_t)rd16(record_object_at(world, host, slot), 3);
            break;
        case 5:
            call0(host, 0x4d3c88, 0x61c387);
            /* fall through */
        case 1:
            world->word_585d51 = (int16_t)(world->word_585d51 + (int16_t)rd16(record_object_at(world, host, slot), 1));
            world->word_585d4f = (int16_t)(world->word_585d4f + (int16_t)rd16(record_object_at(world, host, slot), 3));
            break;
        case 2:
            call0(host, 0x4d3c5f, 0x61c387);
            break;
        case 3:
            call0(host, 0x4d3c88, 0x61c387);
            break;
        default:
            break;
        }
    }
    world->value_585d4b = (uint32_t)((int32_t)world->word_585d51 * 0x3c + (int32_t)world->word_585d4f);
    world->value_585d55 = host->tick(host->context) + (uint32_t)(int32_t)world->word_5b0280;
    call1(host, 0x42ba3a, 0, (uint16_t)index);
}
