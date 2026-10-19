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

/* FL25C-FUNCS-END */
