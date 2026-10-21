/* FL-38 (batch b) direct tests of the 18 GAME.EXE "clone a record" functions in src/original_methods_fl38b.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE (the size, the strings and the order of the effects of
 * each row), not from running the native code; tests/test_fl38b_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl38b.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define UNUSED_FN __attribute__((unused))

static int g_failed;
static char g_msg[256];
#define CK(cond)                                                               \
    do {                                                                       \
        if (!(cond) && !g_failed) {                                            \
            g_failed = 1;                                                      \
            snprintf(g_msg, sizeof g_msg, "line %d: %.200s", __LINE__, #cond); \
        }                                                                      \
    } while (0)

/* the fake original address space: three regions, a cell block, a source and a destination */
#define CELL_VA 0x20000000u
#define SRC_VA 0x21000000u
#define DST_VA 0x22000000u
#define BIG 0x2000
static uint8_t *g_cells, *g_src, *g_dst;
static uint32_t g_cells_len, g_src_len, g_dst_len;
static Fl18Host g_host;
static Fl38bWorld g_world;

#define MAXCALL 8
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[4];
    } c[MAXCALL];
} L;
static uint32_t g_new;           /* the answer of 0x51dc43 */

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int k, i = L.n;
    (void)ctx;
    if (L.n < MAXCALL) {
        L.c[i].callee = callee;
        L.c[i].this_ptr = this_ptr;
        L.c[i].nargs = nargs;
        for (k = 0; k < nargs && k < 4; k++) L.c[i].a[k] = args[k];
    }
    L.n++;
    return callee == 0x51dc43 ? g_new : 0xcafef00du;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (a >= CELL_VA && a < CELL_VA + g_cells_len) return g_cells + (a - CELL_VA);
    if (a >= SRC_VA && a < SRC_VA + g_src_len) return g_src + (a - SRC_VA);
    if (a >= DST_VA && a < DST_VA + g_dst_len) return g_dst + (a - DST_VA);
    return NULL;
}

UNUSED_FN static void put32(uint8_t *p, size_t off, uint32_t v)
{
    p[off] = (uint8_t)v;
    p[off + 1] = (uint8_t)(v >> 8);
    p[off + 2] = (uint8_t)(v >> 16);
    p[off + 3] = (uint8_t)(v >> 24);
}

UNUSED_FN static uint32_t get32(const uint8_t *p, size_t off)
{
    return (uint32_t)p[off] | (uint32_t)p[off + 1] << 8 | (uint32_t)p[off + 2] << 16 | (uint32_t)p[off + 3] << 24;
}

/* the three cells live at CELL_VA + 0, + 8 and + 16 */
#define OUT_C (CELL_VA + 0)
#define SRC_C (CELL_VA + 8)
#define ADV_C (CELL_VA + 16)

typedef int (*CloneFn)(uint32_t, uint32_t, uint32_t, const Fl38bWorld *, const Fl18Host *);

static void setup(uint8_t *cells, uint8_t *src, uint8_t *dst, uint32_t cells_len, uint32_t len)
{
    uint32_t i;
    g_cells = cells; g_src = src; g_dst = dst;
    g_cells_len = cells_len; g_src_len = len; g_dst_len = len;
    for (i = 0; i < len; i++) {
        src[i] = (uint8_t)(i * 7 + 1);
        dst[i] = 0xa5;
    }
    memset(cells, 0x3c, cells_len);
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    memset(&g_world, 0, sizeof g_world);
    L.n = 0;
    g_new = 0;
}

/* the model of the copy in the original, written independently: dword units, then a word, then a byte, each read in full before it is written */
static void model_copy(uint8_t *mem, uint32_t dst, uint32_t src, uint32_t size)
{
    uint32_t i, off = 0;
    for (i = 0; i < size / 4; i++, off += 4) {
        uint8_t t[4];
        memcpy(t, mem + src + off, 4);
        memcpy(mem + dst + off, t, 4);
    }
    if (size & 2) { uint8_t t[2]; memcpy(t, mem + src + off, 2); memcpy(mem + dst + off, t, 2); off += 2; }
    if (size & 1) mem[dst + off] = mem[src + off];
}

static void check_calls_normal(uint32_t size)
{
    CK(L.n >= 1);
    CK(L.c[0].callee == 0x51dc43 && L.c[0].this_ptr == 0 && L.c[0].nargs == 1 && L.c[0].a[0] == size);
}

static void check_clone_on(CloneFn fn, uint32_t size, uint32_t fmt, uint32_t msg, uint32_t dbg, uint8_t *cells, uint8_t *src, uint8_t *dst, uint32_t len)
{
    static const int16_t dbgs[] = {0, 1, 0x100, -32768, -1};
    uint32_t i, j;
    uint8_t ref[BIG];
    /* normal path, debug word 0: p = DST_VA + 5, source pointer SRC_VA + 3, advance counter 0xfffffff0 (wraps) */
    setup(cells, src, dst, 32, len);
    put32(g_cells, 8, SRC_VA + 3);
    put32(g_cells, 16, 0xfffffff0u);
    g_new = DST_VA + 5;
    CK(fn(OUT_C, SRC_C, ADV_C, &g_world, &g_host) == 0);
    CK(L.n == 1);
    check_calls_normal(size);
    CK(get32(g_cells, 0) == DST_VA + 5);
    CK(get32(g_cells, 8) == SRC_VA + 3 + size);
    CK(get32(g_cells, 16) == 0xfffffff0u + size);
    for (i = 0; i < len; i++) {
        const uint8_t want = (i >= 5 && i < 5 + size) ? (uint8_t)((i - 5 + 3) * 7 + 1) : 0xa5;     /* exactly `size` bytes are copied */
        CK(g_dst[i] == want);
        CK(g_src[i] == (uint8_t)(i * 7 + 1));
    }
    /* the debug word: every non-zero value (also with the low byte 0) sends the message; zero does not */
    for (j = 0; j < sizeof dbgs / sizeof dbgs[0] && !g_failed; j++) {
        setup(cells, src, dst, 32, len);
        put32(g_cells, 8, SRC_VA);
        g_world.word_63a4cd = dbgs[j];
        g_new = DST_VA;
        CK(fn(OUT_C, SRC_C, ADV_C, &g_world, &g_host) == 0);
        if (dbgs[j] == 0) {
            CK(L.n == 1);
        } else {
            CK(L.n == 2);
            CK(L.c[1].callee == 0x44a2b7 && L.c[1].this_ptr == 0 && L.c[1].nargs == 1 && L.c[1].a[0] == dbg);
        }
    }
    /* the cells alias: adv == in2 advances the source cell twice; out == in2 copies the block onto itself; out == adv */
    setup(cells, src, dst, 32, len);
    put32(g_cells, 8, SRC_VA + 1);
    g_new = DST_VA + 2;
    CK(fn(OUT_C, SRC_C, SRC_C, &g_world, &g_host) == 0);
    CK(get32(g_cells, 8) == SRC_VA + 1 + 2 * size);
    CK(get32(g_cells, 0) == DST_VA + 2);
    setup(cells, src, dst, 32, len);
    g_new = DST_VA + 4;
    CK(fn(SRC_C, SRC_C, ADV_C, &g_world, &g_host) == 0);
    CK(get32(g_cells, 8) == DST_VA + 4 + size);
    for (i = 0; i < len; i++) CK(g_dst[i] == 0xa5);                    /* the block is copied onto itself */
    setup(cells, src, dst, 32, len);
    put32(g_cells, 8, SRC_VA);
    g_new = DST_VA + 1;
    CK(fn(ADV_C, SRC_C, ADV_C, &g_world, &g_host) == 0);
    CK(get32(g_cells, 16) == DST_VA + 1 + size);
    CK(get32(g_cells, 8) == SRC_VA + size);
    /* the destination overlaps the source (all in the source array): the unit order of the original decides the result */
    for (j = 1; j <= 3; j++) {
        setup(cells, src, dst, 32, len);
        put32(g_cells, 8, SRC_VA + 4);
        g_new = SRC_VA + 4 + j;
        memcpy(ref, g_src, len);
        model_copy(ref, 4 + j, 4, size);
        CK(fn(OUT_C, SRC_C, ADV_C, &g_world, &g_host) == 0);
        CK(memcmp(g_src, ref, len) == 0);
    }
    /* the failed allocation: the report (sprintf-style, then 0x42639d, then 0x4c97b4), *out = 0, no copy, no advance, status 1, and the debug message is not sent */
    setup(cells, src, dst, 32, len);
    put32(g_cells, 8, SRC_VA + 3);
    put32(g_cells, 16, 0x1234);
    g_world.dword_5bb57b = 0x12345678u;
    g_world.word_5c39e3 = -5;
    g_world.word_63a4cd = 1;
    g_new = 0;
    CK(fn(OUT_C, SRC_C, ADV_C, &g_world, &g_host) == 1);
    CK(L.n == 4);
    check_calls_normal(size);
    CK(L.c[1].callee == 0x50ca3e && L.c[1].this_ptr == 0 && L.c[1].nargs == 4 && L.c[1].a[0] == 0x63888b && L.c[1].a[1] == fmt && L.c[1].a[2] == 0x12345678u && L.c[1].a[3] == 0xfffffffbu);
    CK(L.c[2].callee == 0x42639d && L.c[2].this_ptr == 0x583979 && L.c[2].nargs == 2 && L.c[2].a[0] == msg && L.c[2].a[1] == 0x63888b);
    CK(L.c[3].callee == 0x4c97b4 && L.c[3].this_ptr == 0x5cf659 && L.c[3].nargs == 0);
    CK(get32(g_cells, 0) == 0);
    CK(get32(g_cells, 8) == SRC_VA + 3 && get32(g_cells, 16) == 0x1234);
    for (i = 0; i < len; i++) CK(g_dst[i] == 0xa5 && g_src[i] == (uint8_t)(i * 7 + 1));
    /* the positive half of the word and a large dword go through unchanged */
    setup(cells, src, dst, 32, len);
    g_world.dword_5bb57b = 0xfedcba98u;
    g_world.word_5c39e3 = 0x7fff;
    g_new = 0;
    CK(fn(OUT_C, SRC_C, ADV_C, &g_world, &g_host) == 1);
    CK(L.n == 4 && L.c[1].a[2] == 0xfedcba98u && L.c[1].a[3] == 0x7fffu);
}

static void check_clone(CloneFn fn, uint32_t size, uint32_t fmt, uint32_t msg, uint32_t dbg)
{
    static uint8_t cells[32], src[BIG], dst[BIG];
    check_clone_on(fn, size, fmt, msg, dbg, cells, src, dst, BIG);
}

static void test_m44d1d1_clone_record(void) { check_clone(m44d1d1_clone_record, 0x2fb, 0x549538, 0x549564, 0x549580); }
static void test_m456fb6_clone_record(void) { check_clone(m456fb6_clone_record, 0x27b, 0x54a330, 0x54a35c, 0x54a378); }
static void test_m45807c_clone_record(void) { check_clone(m45807c_clone_record, 0x663, 0x54a578, 0x54a5a4, 0x54a5c0); }
static void test_m464100_clone_record(void) { check_clone(m464100_clone_record, 0x43f, 0x54b2c0, 0x54b2ec, 0x54b308); }
static void test_m465bde_clone_record(void) { check_clone(m465bde_clone_record, 0x55f, 0x54b4d0, 0x54b4fc, 0x54b518); }
static void test_m46b79a_clone_record(void) { check_clone(m46b79a_clone_record, 0x6e3, 0x54bc84, 0x54bcb0, 0x54bccc); }
static void test_m47314b_clone_record(void) { check_clone(m47314b_clone_record, 0x4ff, 0x54c5a0, 0x54c5cc, 0x54c5e8); }
static void test_m4782db_clone_record(void) { check_clone(m4782db_clone_record, 0x29b, 0x54cb10, 0x54cb3c, 0x54cb58); }
static void test_m475964_clone_record(void) { check_clone(m475964_clone_record, 0x7f2, 0x54c7cc, 0x54c7f8, 0x54c814); }
static void test_m44fbe3_clone_record(void) { check_clone(m44fbe3_clone_record, 0x4e8, 0x54991c, 0x549948, 0x549964); }
static void test_m467688_clone_record(void) { check_clone(m467688_clone_record, 0x408, 0x54b7d8, 0x54b804, 0x54b820); }
static void test_m468f9f_clone_record(void) { check_clone(m468f9f_clone_record, 0x5d8, 0x54b974, 0x54b9a0, 0x54b9bc); }
static void test_m47e477_clone_record(void) { check_clone(m47e477_clone_record, 0xa34, 0x54d474, 0x54d4a0, 0x54d4bc); }
static void test_m44e8a2_clone_record(void) { check_clone(m44e8a2_clone_record, 0x269, 0x5497a8, 0x5497d4, 0x5497f0); }
static void test_m454e70_clone_record(void) { check_clone(m454e70_clone_record, 0xd01, 0x549fbc, 0x549fe8, 0x54a004); }
static void test_m459c10_clone_record(void) { check_clone(m459c10_clone_record, 0x2b1, 0x54a74c, 0x54a778, 0x54a794); }
static void test_m45ddd0_clone_record(void) { check_clone(m45ddd0_clone_record, 0x1346, 0x54aeb8, 0x54aee4, 0x54af00); }
static void test_m47b3f0_clone_record(void) { check_clone(m47b3f0_clone_record, 0x16c2, 0x54cdd4, 0x54ce00, 0x54ce1c); }

/* every port on heap buffers of exactly the bytes the original touches (for the sanitiser builds): three 4-byte cells are not exact here (they share one 24-byte block, the cells being
 * 8 bytes apart), the source holds up to 3 + size bytes and the destination 5 + size */
static const struct {
    CloneFn fn;
    uint32_t size;
} ROWS[] = {
    {m44d1d1_clone_record, 0x2fb},
    {m456fb6_clone_record, 0x27b},
    {m45807c_clone_record, 0x663},
    {m464100_clone_record, 0x43f},
    {m465bde_clone_record, 0x55f},
    {m46b79a_clone_record, 0x6e3},
    {m47314b_clone_record, 0x4ff},
    {m4782db_clone_record, 0x29b},
    {m475964_clone_record, 0x7f2},
    {m44fbe3_clone_record, 0x4e8},
    {m467688_clone_record, 0x408},
    {m468f9f_clone_record, 0x5d8},
    {m47e477_clone_record, 0xa34},
    {m44e8a2_clone_record, 0x269},
    {m454e70_clone_record, 0xd01},
    {m459c10_clone_record, 0x2b1},
    {m45ddd0_clone_record, 0x1346},
    {m47b3f0_clone_record, 0x16c2},
};

static void test_exact_size_buffers(void)
{
    size_t r;
    for (r = 0; r < sizeof ROWS / sizeof ROWS[0] && !g_failed; r++) {
        const uint32_t size = ROWS[r].size;
        uint8_t *cells = malloc(20), *src = malloc(size + 3), *dst = malloc(size + 5);
        uint32_t i;
        CK(cells != NULL && src != NULL && dst != NULL);
        if (cells == NULL || src == NULL || dst == NULL) break;
        for (i = 0; i < size + 3; i++) src[i] = (uint8_t)(i * 5 + 2);
        memset(dst, 0xa5, size + 5);
        memset(cells, 0, 20);
        g_cells = cells; g_src = src; g_dst = dst;
        g_cells_len = 20; g_src_len = size + 3; g_dst_len = size + 5;
        memset(&g_host, 0, sizeof g_host);
        g_host.call = host_call;
        g_host.resolve = host_resolve;
        memset(&g_world, 0, sizeof g_world);
        L.n = 0;
        put32(cells, 8, SRC_VA + 3);
        put32(cells, 16, 7);
        g_new = DST_VA + 5;
        CK(ROWS[r].fn(OUT_C, SRC_C, ADV_C, &g_world, &g_host) == 0);
        CK(get32(cells, 0) == DST_VA + 5 && get32(cells, 16) == 7 + size);
        free(cells);
        free(src);
        free(dst);
    }
}

#define RUN(fn)                                  \
    do {                                         \
        g_failed = 0;                            \
        g_msg[0] = 0;                            \
        fn();                                    \
        if (g_failed) {                          \
            printf("FAIL %s: %s\n", #fn, g_msg); \
            failures++;                          \
        } else {                                 \
            printf("PASS %s\n", #fn);            \
        }                                        \
    } while (0)

int main(void)
{
    int failures = 0;
    RUN(test_m44d1d1_clone_record);
    RUN(test_m456fb6_clone_record);
    RUN(test_m45807c_clone_record);
    RUN(test_m464100_clone_record);
    RUN(test_m465bde_clone_record);
    RUN(test_m46b79a_clone_record);
    RUN(test_m47314b_clone_record);
    RUN(test_m4782db_clone_record);
    RUN(test_m475964_clone_record);
    RUN(test_m44fbe3_clone_record);
    RUN(test_m467688_clone_record);
    RUN(test_m468f9f_clone_record);
    RUN(test_m47e477_clone_record);
    RUN(test_m44e8a2_clone_record);
    RUN(test_m454e70_clone_record);
    RUN(test_m459c10_clone_record);
    RUN(test_m45ddd0_clone_record);
    RUN(test_m47b3f0_clone_record);
    RUN(test_exact_size_buffers);
    return failures;
}
