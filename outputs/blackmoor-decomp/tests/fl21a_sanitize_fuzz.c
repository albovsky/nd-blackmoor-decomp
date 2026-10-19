/* FL-21 (batch a) sanitizer harness: runs the five ports of src/original_methods_fl21a.c on bounded malformed inputs under ASan and UBSan
 * (tests/test_fl21a_sanitize.py builds it with -fsanitize=address,undefined). Every buffer is allocated with its exact size, so a read
 * or write past what the original may touch is reported. The inputs are malformed in content (random bytes, extreme signed values,
 * out-of-range states, mismatching strings, 0 / -1 / huge words and dwords) but bounded in the quantities that the original itself
 * does not check: record, entry, slot, row and column indices and counts stay inside the buffers. An unbounded count or index
 * overruns in the original and in the port alike (no native rejection is added; see the handoff).
 * Prints "OK <iterations>" and exits 0 when nothing was reported. */
#include "../src/original_methods_fl21a.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint64_t g_rng = 0x9e3779b97f4a7c15ull;

static uint32_t rnd(void)
{
    g_rng ^= g_rng << 13;
    g_rng ^= g_rng >> 7;
    g_rng ^= g_rng << 17;
    return (uint32_t)(g_rng >> 16);
}

static int range(int lo, int hi) { return lo + (int)(rnd() % (uint32_t)(hi - lo + 1)); }

static uint32_t pick32(void)
{
    static const uint32_t v[] = {0, 1, 2, 3, 0x7fffffffu, 0x80000000u, 0xffffffffu, 0xfffffffeu, 0x270f, 0x10000, 0x7fff, 0x8000, 0xffff};
    return rnd() % 3 == 0 ? v[rnd() % (sizeof v / sizeof v[0])] : rnd();
}

static void put32(uint8_t *b, ptrdiff_t off, uint32_t v) { memcpy(b + off, &v, 4); }
static void put16(uint8_t *b, ptrdiff_t off, uint16_t v) { memcpy(b + off, &v, 2); }

static uint8_t *alloc_random(size_t n)
{
    uint8_t *p = (uint8_t *)malloc(n);
    size_t i;
    for (i = 0; i < n; i++) p[i] = (uint8_t)rnd();
    return p;
}

/* a zero-terminated string of at most max characters in a buffer of exactly max + 1 bytes */
static uint8_t *alloc_string(size_t max, int alphabet)
{
    uint8_t *p = (uint8_t *)malloc(max + 1);
    size_t n = rnd() % (max + 1), i;
    for (i = 0; i < n; i++) p[i] = alphabet ? (uint8_t)(0x61 + rnd() % 3) : (uint8_t)(1 + rnd() % 255);
    p[n] = 0;
    for (i = n + 1; i < max + 1; i++) p[i] = (uint8_t)rnd();
    return p;
}

typedef struct Mem {
    uint32_t va;
    uint8_t *p;
    size_t n;
} Mem;

static struct {
    Mem m[8];
    int nm;
    uint8_t *self;   /* the object that a call on `this` may write (0x4cbba9 stores the name pointer) */
    uint32_t name_va;
    uint32_t ret_idx;
    uint32_t tick;
} H;

static const uint8_t *h_resolve(void *ctx, uint32_t va)
{
    int i;
    (void)ctx;
    for (i = 0; i < H.nm; i++)
        if (va >= H.m[i].va && va < H.m[i].va + H.m[i].n) return H.m[i].p + (va - H.m[i].va);
    return NULL;
}

static uint32_t h_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    (void)ctx;
    (void)args;
    (void)nargs;
    switch (callee) {
    case 0x4cbba9:
        if (this_ptr != 0 && H.self != NULL) put32((uint8_t *)this_ptr, 0x1a, H.name_va);
        return 0;
    case 0x4c0c18: return H.name_va;
    case 0x4d39f9: return H.ret_idx;
    case 0x4c0c2c: return rnd() % 5;
    default: return pick32();
    }
}

static uint32_t h_tick(void *ctx)
{
    (void)ctx;
    return H.tick;
}

static void add(uint32_t va, uint8_t *p, size_t n)
{
    H.m[H.nm].va = va;
    H.m[H.nm].p = p;
    H.m[H.nm].n = n;
    H.nm++;
}

static Fl18Host host(void)
{
    Fl18Host h;
    memset(&h, 0, sizeof h);
    h.call = h_call;
    h.resolve = h_resolve;
    h.tick = h_tick;
    return h;
}

/* record index i of a table of 5 records with one slack record below it: n in -1 .. 3 */
static uint8_t *make_records(int record, uint32_t obj_va, uint32_t state)
{
    uint8_t *r = alloc_random(5 * 0x8d);
    put32(r + 0x8d, (ptrdiff_t)record * 0x8d, obj_va);
    put32(r + 0x8d, (ptrdiff_t)record * 0x8d + 0x4d, state);
    return r;
}

static uint32_t pick_state(void)
{
    static const uint32_t s[] = {0, 1, 2, 3, 7, 0xffffffffu, 0x80000000u};
    return rnd() % 4 != 0 ? rnd() % 3 : s[rnd() % (sizeof s / sizeof s[0])];
}

static void fuzz_4cb586(void)
{
    Fl21aWorld w;
    Fl18Host h = host();
    int record = range(-1, 3);
    uint8_t *records = make_records(record, 0x30000000u, pick_state());
    uint8_t *self = alloc_random(0x160), *obj = alloc_random(0x30), *q = alloc_string(5, 1), *p = alloc_string(5, 1);
    uint8_t *table = alloc_random(6 * 0x4a), *str = alloc_string(0x20, 0);
    memset(&w, 0, sizeof w);
    w.records_5bb5e5 = records + 0x8d;
    w.table_5d1591 = table + 0x4a;
    w.string_558c30 = str;
    w.word_583a29 = (int16_t)(rnd() % 3 == 0 ? 0xffffffffu : rnd());
    H.nm = 0;
    add(0x30000000u, obj, 0x30);
    add(0x31000000u, q, 6);
    add(0x32000000u, p, 6);
    H.self = self;
    H.name_va = rnd() % 2 ? 0x31000000u : 0x32000000u;   /* (q or p: the strings may agree) */
    put32(self, 0x1a, rnd() % 2 ? 0x31000000u : 0);
    if (H.name_va == 0x32000000u && rnd() % 2) memcpy(p, q, 6);
    H.ret_idx = (uint32_t)(range(-1, 4)) | (rnd() << 16);
    put32(self, 0x14a, pick32());
    m4cb586_visit(self, (int16_t)record, &w, &h);
    free(records); free(self); free(obj); free(q); free(p); free(table); free(str);
}

static void fuzz_42caa8(void)
{
    Fl21aWorld w;
    Fl18Host h = host();
    int index = range(-2, 7);
    uint8_t *entries = alloc_random(10 * 0x42), *clip = alloc_random(16);
    uint8_t *records = alloc_random(5 * 0x8d);
    int k;
    memset(&w, 0, sizeof w);
    w.entries_5b4ea9 = entries + 2 * 0x42;
    w.records_5bb5e5 = records + 0x8d;
    w.origin_x_583186 = (int32_t)pick32();
    w.origin_y_58318a = (int32_t)pick32();
    w.word_5b4ea3 = (int16_t)(rnd() % 2 ? 2 : (int16_t)rnd());
    w.word_5b4e89 = (int16_t)range(-1, 3);
    w.word_5b4e8b = (int16_t)(rnd() % 2 ? 2 : (int16_t)rnd());
    for (k = 0; k < 10; k++) {
        put32(entries, (size_t)k * 0x42 + 0x16, pick32());
        put32(entries, (size_t)k * 0x42 + 0x1e, pick32());
    }
    put32(clip, 4, pick32());
    put32(clip, 0xc, pick32());
    H.nm = 0;
    m42caa8_clip_rect((int16_t)index, clip, &w, &h);
    free(entries); free(clip); free(records);
}

static void fuzz_462c39(void)
{
    Fl21aWorld w;
    Fl18Host h = host();
    int record = range(-1, 3), r, c;
    uint8_t *records = make_records(record, 0x30000000u, 0);
    uint8_t *self = alloc_random(0x5f), *rec = alloc_random(0x357), *cells = alloc_random(3 * 0x140 + 4 * 0x28 + 0x28);
    memset(&w, 0, sizeof w);
    w.records_5bb5e5 = records + 0x8d;
    w.cells_594db5 = cells;
    w.origin_x_583186 = (int32_t)pick32();
    w.origin_y_58318a = (int32_t)pick32();
    put16(self, 0x1e, (uint16_t)record);
    put32(self, 0x3f, rnd() % 6 == 0 ? 0 : pick32());
    put32(self, 0x24, rnd() % 6 == 0 ? 2 : pick32());
    put32(self, 0x4f, pick32());
    put32(self, 0x53, pick32());
    put16(rec, 0x22, (uint16_t)range(-2, 4));
    put16(rec, 0x24, (uint16_t)range(-2, 5));
    for (r = 0; r < 4; r++)
        for (c = 0; c < 5; c++) {
            size_t b = (size_t)r * 0x140 + (size_t)c * 0x28;
            if (b + 0x28 <= 3 * 0x140 + 4 * 0x28 + 0x28 && rnd() % 3 != 0) {
                put32(cells, b + 0x14, pick32());
                put32(cells, b + 0x18, pick32());
                put32(cells, b + 0x1c, pick32());
                put32(cells, b + 0x20, pick32());
            }
        }
    H.nm = 0;
    add(0x30000000u, rec, 0x357);
    m462c39_pointer_move(self, (int16_t)rnd(), (int16_t)rnd(), &w, &h);
    free(records); free(self); free(rec); free(cells);
}

static void fuzz_484f42(void)
{
    Fl21aWorld w;
    Fl18Host h = host();
    int record = range(-1, 3), i;
    uint8_t *records = make_records(record, 0x30000000u, 0);
    uint8_t *self = alloc_random(0xc2b), *rec = alloc_random(0xf07), *rect = alloc_random(16);
    memset(&w, 0, sizeof w);
    w.records_5bb5e5 = records + 0x8d;
    put16(self, 0x26, (uint16_t)record);
    put32(self, 0xba7, rnd() % 6 == 0 ? 0 : pick32());
    put32(self, 0xa92, rnd() % 2 ? 0 : pick32());
    put16(self, 0xa9e, (uint16_t)range(0, 3));
    for (i = 0; i < 4; i++) put32(self, 0x2a + (size_t)i * 0x85, pick32());
    for (i = 0; i < 4; i++) put32(self, 0x2e + (size_t)i * 0x85, pick32());
    put16(rec, 0x21, (uint16_t)range(-2, 4));
    for (i = 0; i < 12; i++) put32(rec, (size_t[]){0x5b7, 0x5bb, 0x5bf, 0x5c3, 0x5f8, 0x5fc, 0x600, 0x604, 0xef7, 0xefb, 0xeff, 0xf03}[i], pick32());
    put16(rec, 0x2b, (uint16_t)pick32());
    H.nm = 0;
    add(0x30000000u, rec, 0xf07);
    m484f42_pointer_move(self, (int16_t)rnd(), (int16_t)rnd(), rect, &w, &h);
    free(records); free(self); free(rec); free(rect);
}

static void fuzz_48d914(void)
{
    Fl21aWorld w;
    Fl18Host h = host();
    int record = range(-1, 3);
    uint8_t *records = make_records(record, 0x30000000u, pick_state());
    uint8_t *self = alloc_random(0x4c), *rec = alloc_random(0x7ab), *table = alloc_random(7 * 0x4a), *flags = alloc_random(16 * 4);
    uint8_t *str = alloc_string(0x20, 0), *bytes9 = alloc_random(9);
    memset(&w, 0, sizeof w);
    w.records_5bb5e5 = records + 0x8d;
    w.table_5d1591 = table + 0x4a;
    w.flags_585801 = flags + 4 * 4;
    w.string_54e89c = str;
    w.bytes_54e8d4 = bytes9;
    w.byte_63a8ac = (uint8_t)rnd();
    put16(self, 0x1e, (uint16_t)range(-1, 3));
    put32(self, 0x2b, rnd() % 4 == 0 ? pick32() : rnd() % 6);
    put32(self, 0x37, pick32());
    put32(self, 0x20, rnd() % 2 ? 0 : pick32());
    if (rnd() % 2) rec[0] = w.byte_63a8ac;
    if (rnd() % 2) memcpy(rec + 0x761, bytes9, 9);
    put16(rec, 0x792, (uint16_t)(rnd() % 3 == 0 ? 0x270f : rnd()));
    put16(rec, 0x746, (uint16_t)(rnd() % 3 == 0 ? 0x270f : rnd()));
    put16(rec, 0x7a8, (uint16_t)(rnd() % 3 == 0 ? 0xffff : (uint16_t)range(-4, 11)));
    put16(rec, 0x75c, (uint16_t)(rnd() % 3 == 0 ? 0xffff : (uint16_t)range(-4, 11)));
    H.nm = 0;
    add(0x30000000u, rec, 0x7ab);
    H.ret_idx = (uint32_t)(range(-1, 5)) | (rnd() << 16);
    H.tick = pick32();
    put32(self, 0x39, pick32());
    m48d914_step_scene(self, (int16_t)record, &w, &h);
    free(records); free(self); free(rec); free(table); free(flags); free(str); free(bytes9);
}

int main(void)
{
    int i, n = 3000;
    H.self = NULL;
    for (i = 0; i < n; i++) {
        fuzz_4cb586();
        fuzz_42caa8();
        fuzz_462c39();
        fuzz_484f42();
        fuzz_48d914();
    }
    printf("OK %d\n", n);
    return 0;
}
