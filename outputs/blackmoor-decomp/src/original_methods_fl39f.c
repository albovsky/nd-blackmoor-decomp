#include "original_methods_fl39f.h"

#include <limits.h>
#include <string.h>

#if defined(__GNUC__)
#define FL39_UNUSED __attribute__((unused))
#else
#define FL39_UNUSED
#endif

FL39_UNUSED static uint32_t rd32(const uint8_t *base, ptrdiff_t off)
{
    uint32_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL39_UNUSED static uint16_t rd16(const uint8_t *base, ptrdiff_t off)
{
    uint16_t v;
    memcpy(&v, base + off, sizeof v);
    return v;
}

FL39_UNUSED static int32_t rds16(const uint8_t *base, ptrdiff_t off)
{
    return (int16_t)rd16(base, off);
}

FL39_UNUSED static void wr16(uint8_t *base, ptrdiff_t off, uint16_t v)
{
    memcpy(base + off, &v, sizeof v);
}

FL39_UNUSED static void wr32(uint8_t *base, ptrdiff_t off, uint32_t v)
{
    memcpy(base + off, &v, sizeof v);
}

/* host memory behind an original address (writable: the host owns the memory; the interface only says const) */
FL39_UNUSED static uint8_t *res(const Fl18Host *host, uint32_t address)
{
    return (uint8_t *)host->resolve(host->context, address);
}

FL39_UNUSED static uint32_t callv(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int n)
{
    return host->call != NULL ? host->call(host->context, callee, this_ptr, n > 0 ? args : NULL, n) : 0;
}

FL39_UNUSED static uint32_t call0(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr)
{
    return callv(host, callee, this_ptr, NULL, 0);
}

FL39_UNUSED static uint32_t call1(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0)
{
    const uintptr_t a[1] = {a0};
    return callv(host, callee, this_ptr, a, 1);
}

FL39_UNUSED static uint32_t call2(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1)
{
    const uintptr_t a[2] = {a0, a1};
    return callv(host, callee, this_ptr, a, 2);
}

FL39_UNUSED static uint32_t call3(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2)
{
    const uintptr_t a[3] = {a0, a1, a2};
    return callv(host, callee, this_ptr, a, 3);
}

FL39_UNUSED static uint32_t call4(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3)
{
    const uintptr_t a[4] = {a0, a1, a2, a3};
    return callv(host, callee, this_ptr, a, 4);
}

FL39_UNUSED static uint32_t call5(const Fl18Host *host, uint32_t callee, uintptr_t this_ptr, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3, uintptr_t a4)
{
    const uintptr_t a[5] = {a0, a1, a2, a3, a4};
    return callv(host, callee, this_ptr, a, 5);
}

/* a forward copy in the units of the original: `dwords` dword moves (rep movsd), then a word move when tail & 2, then a byte move when tail & 1; a unit is read before it is written */
FL39_UNUSED static void copy_fwd(uint8_t *dst, const uint8_t *src, uint32_t dwords, uint32_t tail)
{
    uint32_t k;
    for (k = 0; k < dwords; k++) {
        uint32_t v;
        memcpy(&v, src, 4);
        memcpy(dst, &v, 4);
        src += 4;
        dst += 4;
    }
    if ((tail & 2u) != 0) {
        uint16_t v;
        memcpy(&v, src, 2);
        memcpy(dst, &v, 2);
        src += 2;
        dst += 2;
    }
    if ((tail & 1u) != 0) *dst = *src;
}

/* ---- 0x48ef40 advance_slot ---- */
/* 0x48ef40, thiscall, plain `ret`, no return value: d = the dword at 0x5bb5e5 + sl*0x8d (sl = the signed word [self+0x1e]) is the address of a descriptor; m = its signed word [d+0xb0]; the signed word [self+0x3fe] = (that word sign-extended + 1) % m (idiv remainder, sign of the dividend); then for i = 1 while i < m and the dword [self + word*4 + 0x46a] (word sign-extended) is non-zero: the same update. m must not be 0 (the original faults). */
void m48ef40_advance_slot(uint8_t *self, const Fl39fWorld *world, const Fl18Host *host)
{
    const uint8_t *d = res(host, rd32(world->table_5bb5e5, (ptrdiff_t)rds16(self, 0x1e) * 0x8d));
    int16_t i;
    wr16(self, 0x3fe, (uint16_t)((rds16(self, 0x3fe) + 1) % rds16(d, 0xb0)));
    for (i = 1; i < rds16(d, 0xb0); i++) {
        if (rd32(self, 0x46a + (ptrdiff_t)rds16(self, 0x3fe) * 4) == 0) break;
        wr16(self, 0x3fe, (uint16_t)((rds16(self, 0x3fe) + 1) % rds16(d, 0xb0)));
    }
}

/* ---- 0x4904fa construct_record ---- */
/* 0x4904fa, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, 0 arguments), then dword [this+0x0] = 0x52daf8, then dword [this+0x1f77] = 0x0, then dword [this+0x1f7b] = 0x1, then zero 0x1ecb bytes at [this+0x20] (rep stosd, stosw, stosb). */
uint8_t *m4904fa_construct_record(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0x0, 0x52daf8u);
    wr32(self, 0x1f77, 0x0u);
    wr32(self, 0x1f7b, 0x1u);
    memset(self + 0x20, 0, 0x1ecb);
    return self;
}

/* ---- 0x49192b clear_block ---- */
/* 0x49192b, thiscall, plain `ret`, no return value: when the dword [self+0x50f3] (an address of the original) is zero nothing; otherwise the n = dword [self+0x50f7] bytes behind that address are zeroed (rep stosd n/4 dwords, rep stosb n & 3 bytes) and byte [self+0x50fb] = 0. */
void m49192b_clear_block(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x50f3) == 0) return;
    memset(res(host, rd32(self, 0x50f3)), 0, rd32(self, 0x50f7));       /* rep stosd, then rep stosb: the same bytes */
    self[0x50fb] = 0;
}

/* ---- 0x495608 check_object ---- */
/* 0x495608, thiscall, plain `ret`, no return value: the dword [self+0x201f] is the address of a record. When dword [self+0x4769] is non-zero the nine bytes at [record+0x28] are compared with the nine bytes at 0x54f888, otherwise with those at 0x54f894 (repe cmpsb). When they differ: r = 0x4f6334(this 0x5cf1eb, the signed word [record+0x49] as a dword) (thiscall, one argument); gate set: 0x4fb2e3(this 0x5c3a67, the word [record+0x49]) when r == 0; gate clear: 0x4fc878(this 0x5c3a67, the word) when r != 0 (the word is pushed from ax: the upper half is left-over, the callee reads a word). */
void m495608_check_object(const uint8_t *self, const Fl39fWorld *world, const Fl18Host *host)
{
    const uint32_t gate = rd32(self, 0x4769);
    const uint8_t *k = gate != 0 ? world->bytes_54f888 : world->bytes_54f894;
    const uint8_t *p = res(host, rd32(self, 0x201f));
    int i;
    uint32_t r;
    for (i = 0; i < 9; i++)                                   /* repe cmpsb */
        if (p[0x28 + i] != k[i]) break;
    if (i == 9) return;
    r = call1(host, 0x4f6334, 0x5cf1eb, (uintptr_t)(uint32_t)rds16(p, 0x49));       /* the original loads [self+P] again before each use; the callees do not change it */
    if (gate != 0) {
        if (r == 0) (void)call1(host, 0x4fb2e3, 0x5c3a67, (uintptr_t)rd16(p, 0x49));
    } else {
        if (r != 0) (void)call1(host, 0x4fc878, 0x5c3a67, (uintptr_t)rd16(p, 0x49));
    }
}

/* ---- 0x49c53a construct_record ---- */
/* 0x49c53a, thiscall, plain `ret`, returns this: 0x51d716(this) (thiscall, 0 arguments), then dword [this+0x0] = 0x52dbc8, then zero 0xdb0 bytes at [this+0x28] (rep stosd), then 0x49c5f0(this) (thiscall, 0 arguments). The function links a structured-exception frame (handler 0x52855d) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint8_t *m49c53a_construct_record(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x51d716, (uintptr_t)self);
    wr32(self, 0x0, 0x52dbc8u);
    memset(self + 0x28, 0, 0xdb0);
    (void)call0(host, 0x49c5f0, (uintptr_t)self);
    return self;
}

/* ---- 0x49cf80 fill_cells ---- */
/* 0x49cf80, thiscall, plain `ret`, no return value: 2 * dword [self+0xdf4] bytes behind the address in dword [self+0xde0] are zeroed (rep stosd, rep stosb); then for h = 0 .. (signed dword [self+0xddc]) - 1 and w = 0 .. (signed dword [self+0xdd8]) - 1 the word at that address + (h * dword [self+0xdd8] + w) * 2 gets its low byte or-ed with 0x0f (the high byte is kept). */
void m49cf80_fill_cells(uint8_t *self, const Fl18Host *host)
{
    int32_t h, w;
    memset(res(host, rd32(self, 0xde0)), 0, (size_t)(rd32(self, 0xdf4) << 1));       /* rep stosd, then rep stosb: the same bytes */
    for (h = 0; h < (int32_t)rd32(self, 0xddc); h++)
        for (w = 0; w < (int32_t)rd32(self, 0xdd8); w++) {
            const uint32_t row = (uint32_t)h * rd32(self, 0xdd8);
            uint8_t *cell = res(host, rd32(self, 0xde0) + row * 2u + (uint32_t)w * 2u);
            wr16(cell, 0, (uint16_t)(rd16(cell, 0) | 0x0fu));                     /* or al, 0xf: only the low byte changes */
        }
}

/* ---- 0x4a0c7f count_nonempty ---- */
/* 0x4a0c7f, thiscall, plain `ret`, no return value: dword [self+0xe18] = 0, then for i = 0 .. 9 the zero-terminated string at [self+0x2c+i*0x15e] is measured (repne scasb) and the dword is incremented when its length is not 0. */
void m4a0c7f_count_nonempty(uint8_t *self)
{
    int32_t i;
    wr32(self, 0xe18, 0);
    for (i = 0; i < 10; i++) {
        const uint8_t *p = self + 0x2c + (ptrdiff_t)i * 0x15e;
        uint32_t len = 0;
        while (p[len] != 0) len++;                       /* repne scasb */
        if (len > 0) wr32(self, 0xe18, rd32(self, 0xe18) + 1);
    }
}

/* ---- 0x4ac8da init_record ---- */
/* 0x4ac8da, thiscall, plain `ret`, no return value (eax is left over): word [this+0x1e] = 0xffff, then word [this+0x1c] = 0xffff, then dword [this+0xc1b] = 0x0, then dword [this+0xc17] = 0x0, then byte [this+0xc1f] = 0x0, then byte [this+0xc24] = 0x0, then dword [this+0x20] = 0x0, then word [this+0x24] = 0xffff, then dword [this+0x46] = 0x0, then dword [this+0x6a] = 0x0, then dword [this+0xc35] = 0x0, then zero 0xba9 bytes at [this+0x6e] (rep stosd, stosb), then zero 0x30 bytes at [this+0xe59] (rep stosd). */
void m4ac8da_init_record(uint8_t *self)
{
    wr16(self, 0x1e, 0xffff);
    wr16(self, 0x1c, 0xffff);
    wr32(self, 0xc1b, 0x0u);
    wr32(self, 0xc17, 0x0u);
    self[0xc1f] = 0x0;
    self[0xc24] = 0x0;
    wr32(self, 0x20, 0x0u);
    wr16(self, 0x24, 0xffff);
    wr32(self, 0x46, 0x0u);
    wr32(self, 0x6a, 0x0u);
    wr32(self, 0xc35, 0x0u);
    memset(self + 0x6e, 0, 0xba9);
    memset(self + 0xe59, 0, 0x30);
}

/* ---- 0x4beeb3 bind_buffer ---- */
/* 0x4beeb3, thiscall, stack argument a0, `ret 4`, returns an address inside the object or 0: 0x4bf38c(this) (thiscall, no argument); then a0 == 0: 0xe dwords at [this+0x84] are zeroed (rep stosd), dword [this+0x2c0] = 0xfffffffd and the result is 0; a0 != 0: the import at slot 0x52a534(a0, this + 0x84, 0) (stdcall, 3 arguments) and the result is this + 0x84 (THIS PORT RETURNS THE HOST POINTER; the differential shim maps it back to the original address). */
uint8_t *m4beeb3_bind_buffer(uint8_t *self, uint32_t a0, const Fl18Host *host)
{
    (void)call0(host, 0x4bf38c, (uintptr_t)self);
    if (a0 == 0) {
        memset(self + 0x84, 0, 0x38);
        wr32(self, 0x2c0, 0xfffffffdu);
        return NULL;
    }
    (void)call3(host, 0x52a534, 0, a0, (uintptr_t)(self + 0x84), 0);
    return self + 0x84;
}

/* ---- 0x4c9cdd find_zero_record ---- */
/* 0x4c9cdd, thiscall (ecx is only saved), stack argument obj, `ret 4`, returns 0 for a null obj and otherwise 1: for i = 0 .. (signed dword [obj+0x1758]) - 1 the 16 bytes at [obj+0x30c+i*0x3e4] are compared with 16 zero bytes of a local (repe cmpsb); the first all-zero record ends the loop with dword [obj+0x175c] = i; no such record: dword [obj+0x175c] = 0. */
uint32_t m4c9cdd_find_zero_record(uint8_t *obj)
{
    int32_t i;
    if (obj == NULL) return 0;
    for (i = 0; i < (int32_t)rd32(obj, 0x1758); i++) {
        const uint8_t *rec = obj + 0x30c + (size_t)((uint32_t)i * 0x3e4u);
        int j = 0;
        while (j < 16 && rec[j] == 0) j++;                    /* repe cmpsb against 16 zero bytes: stops at the first non-zero byte */
        if (j == 16) {
            wr32(obj, 0x175c, (uint32_t)i);
            return 1;
        }
    }
    wr32(obj, 0x175c, 0);
    return 1;
}

/* ---- 0x4d52b9 init_record ---- */
/* 0x4d52b9, thiscall, plain `ret`, no return value (eax is left over): zero 0x80 bytes at [this+0x4] (rep stosd), then zero 0x10 bytes at [this+0x84] (rep stosd), then zero 0x10 bytes at [this+0x94] (rep stosd), then zero 0x10 bytes at [this+0xa4] (rep stosd). */
void m4d52b9_init_record(uint8_t *self)
{
    memset(self + 0x4, 0, 0x80);
    memset(self + 0x84, 0, 0x10);
    memset(self + 0x94, 0, 0x10);
    memset(self + 0xa4, 0, 0x10);
}

/* ---- 0x4d6ad1 start_timer ---- */
/* 0x4d6ad1, thiscall, plain `ret`, no return value: dword [self+0x461] = 0; now = GetTickCount (import 0x52a23c); dword [self+0x465] = now + the signed word [self+0x2cc]; dword [self+0x469] = strlen of the string at [self+0x96d3] (repne scasb); byte [self+0x46d] = 0; dwords [self+0x46e] and [self+0x472] = 0. */
void m4d6ad1_start_timer(uint8_t *self, const Fl18Host *host)
{
    uint32_t len = 0;
    wr32(self, 0x461, 0);
    wr32(self, 0x465, host->tick(host->context) + (uint32_t)rds16(self, 0x2cc));
    while (self[0x96d3 + len] != 0) len++;       /* repne scasb */
    wr32(self, 0x469, len);
    self[0x46d] = 0;
    wr32(self, 0x46e, 0);
    wr32(self, 0x472, 0);
}

/* ---- 0x4d8f0a release_list ---- */
/* 0x4d8f0a, thiscall, plain `ret`, no return value: when the dword [self+0x9804] (the head of a linked list of original addresses) is non-zero, for each node p (next = dword [p+0x108], read before the call) 0x4d8f8d(this, p) (thiscall, one argument); then, when the dword [self+0x980c] is non-zero, 0x51dc6c(that dword) (cdecl, one argument); finally 0x29 dwords from [self+0x9804] are zeroed (rep stosd). */
void m4d8f0a_release_list(uint8_t *self, const Fl18Host *host)
{
    if (rd32(self, 0x9804) != 0) {
        uint32_t p = rd32(self, 0x9804);
        while (p != 0) {
            const uint32_t next = rd32(res(host, p), 0x108);
            (void)call1(host, 0x4d8f8d, (uintptr_t)self, p);
            p = next;
        }
    }
    if (rd32(self, 0x980c) != 0) (void)call1(host, 0x51dc6c, 0, rd32(self, 0x980c));
    memset(self + 0x9804, 0, 0xa4);                               /* rep stosd */
}

/* ---- 0x4dc13f copy_counted ---- */
/* 0x4dc13f, thiscall, stack arguments (src, count), `ret 8`, no return value: copies count bytes (count / 4 dwords with rep movsd, then count & 3 bytes with rep movsb; the count is unsigned and not checked) from src to [self+0x4e]; then, when the signed word 0x63a4cd is non-zero, 0x44a2b7(0x55b058) (cdecl, one argument). */
void m4dc13f_copy_counted(uint8_t *self, const uint8_t *src, uint32_t count, const Fl39fWorld *world, const Fl18Host *host)
{
    uint32_t k;
    copy_fwd(self + 0x4e, src, count >> 2, 0);
    for (k = count & ~3u; k < count; k++) self[0x4e + k] = src[k];       /* rep movsb of count & 3 bytes */
    if (world->word_63a4cd != 0) (void)call1(host, 0x44a2b7, 0, 0x55b058);
}

/* ---- 0x4de5f0 construct_record ---- */
/* 0x4de5f0, thiscall, plain `ret`, returns this: 0x4e1c50(this + 0x3ef) (thiscall, 0 arguments), then 0x4ee980(this + 0x57e) (thiscall, 0 arguments), then dword [this+0x0] = 0x52e4d0, then zero 0x389 bytes at [this+0x4] (rep stosd, stosb), then 0x4de6d7(this) (thiscall, 0 arguments). The function links a structured-exception frame (handler 0x52891e) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint8_t *m4de5f0_construct_record(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x4e1c50, (uintptr_t)(self + 0x3ef));
    (void)call0(host, 0x4ee980, (uintptr_t)(self + 0x57e));
    wr32(self, 0x0, 0x52e4d0u);
    memset(self + 0x4, 0, 0x389);
    (void)call0(host, 0x4de6d7, (uintptr_t)self);
    return self;
}

/* ---- 0x4e0410 construct_record ---- */
/* 0x4e0410, thiscall, plain `ret`, returns this: 0x50cb26(this + 0x757, 0x18f, 0x5, 0x4e1c50, 0x4e1c83) (stdcall: the callee pops them, 5 arguments), then dword [this+0x0] = 0x52e4e4, then zero 0x74b bytes at [this+0x4] (rep stosd, stosw, stosb), then 0x4e04f3(this) (thiscall, 0 arguments). The function links a structured-exception frame (handler 0x52896b) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint8_t *m4e0410_construct_record(uint8_t *self, const Fl18Host *host)
{
    (void)call5(host, 0x50cb26, 0, (uintptr_t)(self + 0x757), 0x18f, 0x5, 0x4e1c50, 0x4e1c83);
    wr32(self, 0x0, 0x52e4e4u);
    memset(self + 0x4, 0, 0x74b);
    (void)call0(host, 0x4e04f3, (uintptr_t)self);
    return self;
}

/* ---- 0x4e069c copy_in ---- */
/* 0x4e069c, thiscall, stack arguments (src, unused), `ret 8`, no return value: copies 0x74b bytes (466 dwords with rep movsd, then movsw and movsb) from src to [self+0x4]. The second stack argument is not read; `self` (ecx) is saved in a local. */
void m4e069c_copy_in(uint8_t *self, const uint8_t *src)
{
    copy_fwd(self + 0x4, src, 0x1d2, 3);
}

/* ---- 0x4e1c50 construct_record ---- */
/* 0x4e1c50, thiscall, plain `ret`, returns this: dword [this+0x0] = 0x52e4e8, then zero 0xef bytes at [this+0x38] (rep stosd, stosw, stosb), then 0x4e1c9f(this) (thiscall, 0 arguments). */
uint8_t *m4e1c50_construct_record(uint8_t *self, const Fl18Host *host)
{
    wr32(self, 0x0, 0x52e4e8u);
    memset(self + 0x38, 0, 0xef);
    (void)call0(host, 0x4e1c9f, (uintptr_t)self);
    return self;
}

/* ---- 0x4e4428 copy_in ---- */
/* 0x4e4428, thiscall, stack arguments (src, unused), `ret 8`, no return value: copies 0x10ed bytes (1083 dwords with rep movsd, then movsb) from src to [self+0x54df]. The second stack argument is not read; `self` (ecx) is saved in a local. */
void m4e4428_copy_in(uint8_t *self, const uint8_t *src)
{
    copy_fwd(self + 0x54df, src, 0x43b, 1);
}

/* ---- 0x4e498d set_name ---- */
/* 0x4e498d, thiscall, stack argument (name), `ret 4`, no return value: copies the 0x31 bytes at [self+0xa80] to [self+0x453c] (rep movsd, movsb); then copies strlen(name) + 1 bytes of the zero-terminated string `name` to [self+0x453c] (repne scasb for the length, rep movsd for len/4 dwords, rep movsb for len & 3). The length is not bounded by the field (0x31 bytes). */
void m4e498d_set_name(uint8_t *self, const uint8_t *name)
{
    uint32_t n = 0, k;
    copy_fwd(self + 0x453c, self + 0xa80, 0xc, 1);
    while (name[n] != 0) n++;
    n++;                                         /* repne scasb: the length with the terminator */
    copy_fwd(self + 0x453c, name, n >> 2, 0);
    for (k = n & ~3u; k < n; k++) self[0x453c + k] = name[k];       /* rep movsb of n & 3 bytes */
}

/* ---- 0x4e7a70 construct_record ---- */
/* 0x4e7a70, thiscall, plain `ret`, returns this: 0x4eda10(this) (thiscall, 0 arguments), then 0x50cb26(this + 0x7654, 0x18f, 0x6, 0x4e1c50, 0x4e1c83) (stdcall: the callee pops them, 5 arguments), then dword [this+0x0] = 0x52e4f4, then dword [this+0x699] = 0x0, then dword [this+0x695] = 0x0, then dword [this+0x691] = 0x0, then zero 0xb2c bytes at [this+0x6b20] (rep stosd), then zero 0x647f bytes at [this+0x69d] (rep stosd, stosw, stosb), then 0x4e7ba7(this) (thiscall, 0 arguments). The function links a structured-exception frame (handler 0x528a54) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint8_t *m4e7a70_construct_record(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x4eda10, (uintptr_t)self);
    (void)call5(host, 0x50cb26, 0, (uintptr_t)(self + 0x7654), 0x18f, 0x6, 0x4e1c50, 0x4e1c83);
    wr32(self, 0x0, 0x52e4f4u);
    wr32(self, 0x699, 0x0u);
    wr32(self, 0x695, 0x0u);
    wr32(self, 0x691, 0x0u);
    memset(self + 0x6b20, 0, 0xb2c);
    memset(self + 0x69d, 0, 0x647f);
    (void)call0(host, 0x4e7ba7, (uintptr_t)self);
    return self;
}

/* ---- 0x4eb77d fill_name_table ---- */
/* 0x4eb77d, thiscall, plain `ret`, no return value: the dword counter [self+0x822e] runs from 0 while it is < 70 (signed compare); for each value i: byte [0x583f1f + i*0x6e] = 0; strlen + 1 bytes of the zero-terminated string at [self+0x712] (repne scasb, rep movsd for len/4 dwords, rep movsb for len & 3) are copied to 0x583f20 + i*0x6e; 0x31 bytes (12 dwords with rep movsd, then movsb) at [self+0x6e1] are copied to 0x583f5c + i*0x6e. The string is not bounded by its 0x3c-byte field. */
void m4eb77d_fill_name_table(uint8_t *self, const Fl39fWorld *world)
{
    uint8_t *t = world->table_583f1f;
    for (wr32(self, 0x822e, 0); (int32_t)rd32(self, 0x822e) < 70; wr32(self, 0x822e, rd32(self, 0x822e) + 1)) {
        const uint32_t i = rd32(self, 0x822e);
        uint32_t n = 0, k;
        t[i * 0x6eu] = 0;
        while (self[0x712 + n] != 0) n++;
        n++;                                     /* repne scasb: the length with the terminator */
        copy_fwd(t + i * 0x6eu + 0x1, self + 0x712, n >> 2, 0);
        for (k = n & ~3u; k < n; k++) t[i * 0x6eu + 0x1 + k] = self[0x712 + k];     /* rep movsb of n & 3 bytes */
        copy_fwd(t + i * 0x6eu + 0x3d, self + 0x6e1, 0xc, 1);
    }
}

/* ---- 0x4eb870 construct_record ---- */
/* 0x4eb870, thiscall, plain `ret`, returns this: 0x4eda10(this) (thiscall, 0 arguments), then 0x50cb26(this + 0xca8, 0x18f, 0x2, 0x4e1c50, 0x4e1c83) (stdcall: the callee pops them, 5 arguments), then dword [this+0x0] = 0x52e4f8, then zero 0x60b bytes at [this+0x695] (rep stosd, stosw, stosb), then 0x4eb9c8(this) (thiscall, 0 arguments). The function links a structured-exception frame (handler 0x528ab4) into fs:[0] and unlinks it before the return; the frame (and the handler, which runs only when a callee throws) is not modelled. */
uint8_t *m4eb870_construct_record(uint8_t *self, const Fl18Host *host)
{
    (void)call0(host, 0x4eda10, (uintptr_t)self);
    (void)call5(host, 0x50cb26, 0, (uintptr_t)(self + 0xca8), 0x18f, 0x2, 0x4e1c50, 0x4e1c83);
    wr32(self, 0x0, 0x52e4f8u);
    memset(self + 0x695, 0, 0x60b);
    (void)call0(host, 0x4eb9c8, (uintptr_t)self);
    return self;
}

/* ---- 0x4ec005 copy_checked ---- */
/* 0x4ec005, thiscall, stack arguments (src, limit), `ret 8`, no return value: copies 0x60b bytes (386 dwords with rep movsd, then movsw and movsb) from src to [self+0x695]; when 0x60b > limit (signed): 0x50ca3e(0x63888b, 0x55cc48, 0x60b, limit) (cdecl, four arguments), 0x4264e8(0x63888b) on 0x583979 (thiscall), 0x4c97b4 on 0x5cf659 (thiscall, no argument). */
void m4ec005_copy_checked(uint8_t *self, const uint8_t *src, int32_t limit, const Fl18Host *host)
{
    copy_fwd(self + 0x695, src, 0x182, 3);
    if ((int32_t)0x60b > limit) {
        (void)call4(host, 0x50ca3e, 0, 0x63888b, 0x55cc48, 0x60b, (uintptr_t)(uint32_t)limit);
        (void)call1(host, 0x4264e8, 0x583979, 0x63888b);
        (void)call0(host, 0x4c97b4, 0x5cf659);
    }
}

/* ---- 0x4fa8d2 check_name ---- */
/* 0x4fa8d2, cdecl-style stack arguments (a0, name, a2, cell), `ret 0x10`, returns 1 or 0 (ecx is not used): when a0 == 0 and the 21 bytes at `name` equal those at 0x56040c (repe cmpsb) and the signed word 0x63a4cd is non-zero: 0x50ca3e(0x63888b, 0x560424, name) (cdecl, 3 arguments) and 0x44a2b7(0x63888b) (cdecl), result 1; when a0 == 0 otherwise result 1; when a0 != 0: dword [cell] = a0, then with the debug word non-zero 0x50ca3e(0x63888b, 0x560478, name, a2) (cdecl, 4 arguments) and 0x44a2b7(0x63888b), result 0. */
uint32_t m4fa8d2_check_name(uint32_t a0, const uint8_t *name, uint32_t a2, uint8_t *cell, const Fl39fWorld *world, const Fl18Host *host)
{
    if (a0 == 0) {
        const uint8_t *k = world->bytes_56040c;
        int i;
        for (i = 0; i < 21; i++)                           /* repe cmpsb */
            if (name[i] != k[i]) break;
        if (i == 21) {
            if (world->word_63a4cd != 0) {
                (void)call3(host, 0x50ca3e, 0, 0x63888b, 0x560424, (uintptr_t)name);
                (void)call1(host, 0x44a2b7, 0, 0x63888b);
            }
            return 1;
        }
    }
    if (a0 == 0) return 1;
    wr32(cell, 0, a0);
    if (world->word_63a4cd != 0) {
        (void)call4(host, 0x50ca3e, 0, 0x63888b, 0x560478, (uintptr_t)name, a2);
        (void)call1(host, 0x44a2b7, 0, 0x63888b);
    }
    return 0;
}

/* ---- 0x4fa980 construct_record ---- */
/* 0x4fa980, thiscall, plain `ret`, returns this: dword [this+0x0] = 0x52e518, then word [this+0xb774] = 0x0, then dword [this+0xb776] = 0x0, then dword [this+0xb77a] = 0x0, then dword [this+0xb77e] = 0x0, then word [this+0xb782] = 0x0, then zero 0xb760 bytes at [this+0x4] (rep stosd). */
uint8_t *m4fa980_construct_record(uint8_t *self)
{
    wr32(self, 0x0, 0x52e518u);
    wr16(self, 0xb774, 0x0);
    wr32(self, 0xb776, 0x0u);
    wr32(self, 0xb77a, 0x0u);
    wr32(self, 0xb77e, 0x0u);
    wr16(self, 0xb782, 0x0);
    memset(self + 0x4, 0, 0xb760);
    return self;
}
