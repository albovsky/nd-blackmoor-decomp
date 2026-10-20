/* FL-28 (batch c) direct tests of the action 0x2d runtime methods of GAME.EXE in src/original_methods_fl28c.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit
 * status is the failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running
 * the native code; tests/test_fl28c_differential.py additionally runs the original bytes on generated fixtures.
 *
 * Every function is checked three ways: (1) the guard matrix, each guard failing in turn, which must leave the object and the call log as the original does;
 * (2) each arm with the whole object compared with a hand-edited copy, and the ordered host calls with their arguments and the state of the object at the call;
 * (3) widths, signedness and the edges of every comparison, the native rejections, and the loops. */
#include "../src/original_methods_fl28c.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int g_failed;
static char g_msg[256];
#define CK(cond)                                                               \
    do {                                                                       \
        if (!(cond) && !g_failed) {                                            \
            g_failed = 1;                                                      \
            snprintf(g_msg, sizeof g_msg, "line %d: %.200s", __LINE__, #cond); \
        }                                                                      \
    } while (0)

#define SELF_SZ 0x300
#define HDR_SZ 0x40
#define TBL_SZ 0x400
#define HDR_VA 0x20020000u
#define TBL_VA 0x20010000u
#define HEAP_VA 0x20030000u
#define HEAP_SZ 0x400
#define OUT_VA 0x20040000u
#define SNAP 0x300

static void set32(uint8_t *o, size_t off, uint32_t v) { memcpy(o + off, &v, 4); }
static void set16(uint8_t *o, size_t off, uint16_t v) { memcpy(o + off, &v, 2); }
static uint32_t get32(const uint8_t *o, size_t off)
{
    uint32_t v;
    memcpy(&v, o + off, 4);
    return v;
}
static uint16_t get16(const uint8_t *o, size_t off)
{
    uint16_t v;
    memcpy(&v, o + off, 2);
    return v;
}

static struct {
    uint8_t self[SELF_SZ], hdr[HDR_SZ], tbl[TBL_SZ], heap[HEAP_SZ], out[8], tbl2[TBL_SZ], src[0x400], dst[0x400], cursor[16];
    Fl28cWorld w;
    Fl18Host host;
} fx;
static uint8_t exp_self[SELF_SZ], exp_hdr[HDR_SZ], exp_tbl[TBL_SZ], exp_heap[HEAP_SZ], exp_out[8];

#define MAXCALL 64
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[16];
        uint8_t snap_self[SNAP];
    } c[MAXCALL];
} L;

/* scripted behaviour: results per callee (the last one repeats) and an effect hook run after the call is logged */
static struct {
    uint32_t callee;
    uint32_t results[16];
    int nresults, used;
} S[16];
static int g_nscript;
static void (*g_effect)(int call_index, uint32_t callee, const uintptr_t *args);

static void script(uint32_t callee, int n, const uint32_t *results)
{
    int i;
    S[g_nscript].callee = callee;
    S[g_nscript].nresults = n;
    S[g_nscript].used = 0;
    for (i = 0; i < n; i++) S[g_nscript].results[i] = results[i];
    g_nscript++;
}

static void script1(uint32_t callee, uint32_t r) { script(callee, 1, &r); }

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int k, i = L.n;
    uint32_t result = 0;
    (void)ctx;
    if (L.n < MAXCALL) {
        L.c[i].callee = callee;
        L.c[i].this_ptr = this_ptr;
        L.c[i].nargs = nargs;
        for (k = 0; k < nargs && k < 16; k++) L.c[i].a[k] = args[k];
        memcpy(L.c[i].snap_self, fx.self, SNAP);
    }
    L.n++;
    for (k = 0; k < g_nscript; k++)
        if (S[k].callee == callee && S[k].nresults > 0) {
            result = S[k].results[S[k].used < S[k].nresults ? S[k].used : S[k].nresults - 1];
            S[k].used++;
        }
    if (g_effect != NULL) g_effect(i, callee, args);
    return result;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (a >= TBL_VA && a < TBL_VA + TBL_SZ) return fx.tbl + (a - TBL_VA);
    if (a >= HDR_VA && a < HDR_VA + HDR_SZ) return fx.hdr + (a - HDR_VA);
    if (a >= HEAP_VA && a < HEAP_VA + HEAP_SZ) return fx.heap + (a - HEAP_VA);
    if (a >= OUT_VA && a < OUT_VA + 8) return fx.out + (a - OUT_VA);
    if (a >= 0x20050000u && a < 0x20050000u + TBL_SZ) return fx.tbl2 + (a - 0x20050000u);
    if (a >= 0x20060000u && a < 0x20060000u + 0x400) return fx.src + (a - 0x20060000u);
    if (a >= 0x20070000u && a < 0x20070000u + 0x400) return fx.dst + (a - 0x20070000u);
    return NULL;
}

static void setup(void)
{
    size_t b;
    memset(fx.self, 0xA5, sizeof fx.self);
    for (b = 0; b < HDR_SZ; b++) fx.hdr[b] = (uint8_t)(b * 7 + 3);
    for (b = 0; b < TBL_SZ; b++) {
        fx.tbl[b] = (uint8_t)(b * 5 + 1);
        fx.tbl2[b] = (uint8_t)(b * 9 + 2);
    }
    memset(fx.heap, 0xAA, sizeof fx.heap);
    memset(fx.out, 0x5C, sizeof fx.out);
    for (b = 0; b < 0x400; b++) {
        fx.src[b] = (uint8_t)(b * 3 + 1);
        fx.dst[b] = (uint8_t)(b * 13 + 7);
    }
    memset(fx.cursor, 0, sizeof fx.cursor);
    memset(&fx.w, 0, sizeof fx.w);
    memset(&fx.host, 0, sizeof fx.host);
    fx.host.call = host_call;
    fx.host.resolve = host_resolve;
    L.n = 0;
    g_nscript = 0;
    g_effect = NULL;
}

static void expect_begin(void)
{
    memcpy(exp_self, fx.self, sizeof exp_self);
    memcpy(exp_hdr, fx.hdr, sizeof exp_hdr);
    memcpy(exp_tbl, fx.tbl, sizeof exp_tbl);
    memcpy(exp_heap, fx.heap, sizeof exp_heap);
    memcpy(exp_out, fx.out, sizeof exp_out);
}

static void expect_end_at(int line)
{
    if (!g_failed && (memcmp(exp_self, fx.self, sizeof exp_self) != 0 || memcmp(exp_hdr, fx.hdr, sizeof exp_hdr) != 0 || memcmp(exp_tbl, fx.tbl, sizeof exp_tbl) != 0 ||
                      memcmp(exp_heap, fx.heap, sizeof exp_heap) != 0 || memcmp(exp_out, fx.out, sizeof exp_out) != 0)) {
        g_failed = 1;
        snprintf(g_msg, sizeof g_msg, "line %d: an object differs from the expected copy", line);
    }
}

#define expect_end() expect_end_at(__LINE__)

static void ck_call_at(int line, int n, uint32_t callee, uintptr_t this_ptr, int nargs, const uintptr_t *want)
{
    int k;
    if (g_failed) return;
    if (n >= L.n || n >= MAXCALL) {
        g_failed = 1;
        snprintf(g_msg, sizeof g_msg, "line %d: call %d missing (log has %d)", line, n, L.n);
        return;
    }
    if (L.c[n].callee != callee || L.c[n].this_ptr != this_ptr || L.c[n].nargs != nargs) {
        g_failed = 1;
        snprintf(g_msg, sizeof g_msg, "line %d: call %d is %x this %lx nargs %d, want %x this %lx nargs %d", line, n, (unsigned)L.c[n].callee,
                 (unsigned long)L.c[n].this_ptr, L.c[n].nargs, (unsigned)callee, (unsigned long)this_ptr, nargs);
        return;
    }
    for (k = 0; k < nargs; k++)
        if (L.c[n].a[k] != want[k]) {
            g_failed = 1;
            snprintf(g_msg, sizeof g_msg, "line %d: call %d arg %d is %lx, want %lx", line, n, k, (unsigned long)L.c[n].a[k], (unsigned long)want[k]);
            return;
        }
}

/* CKC(n, callee, this, args...): the n-th logged call; CKC0 for no arguments */
#define CKC(n, callee, thisp, ...)                                                         \
    do {                                                                                   \
        const uintptr_t w_[] = {0, __VA_ARGS__};                                           \
        ck_call_at(__LINE__, (n), (callee), (uintptr_t)(thisp), (int)(sizeof w_ / sizeof w_[0]) - 1, w_ + 1); \
    } while (0)
#define CKC0(n, callee, thisp) ck_call_at(__LINE__, (n), (callee), (uintptr_t)(thisp), 0, NULL)
#define CKN(count) CK(L.n == (count))

/* ---- 0x4cf026 -------------------------------------------------------------------------------------------------------------------- */

static void find_object(uint16_t count, uint32_t table)
{
    set32(fx.self, 0x222, HDR_VA);
    set32(fx.self, 0x226, table);
    set16(fx.hdr, 0x23, count);
}

static void find_change_table(int i, uint32_t callee, const uintptr_t *args)
{
    (void)callee;
    (void)args;
    if (i == 0) set32(fx.self, 0x226, 0x20050000u);
}

static void find_change_count(int i, uint32_t callee, const uintptr_t *args)
{
    (void)callee;
    (void)args;
    if (i == 0) set16(fx.hdr, 0x23, 1);
}

static void test_m4cf026_find_record(void)
{
    uint32_t r[4];
    int32_t v;
    /* guards: either dword zero returns -1 with no call and no store */
    setup();
    find_object(3, TBL_VA);
    set32(fx.self, 0x222, 0);
    expect_begin();
    CK(m4cf026_find_record(fx.self, 0x1234, &fx.host) == -1);
    CKN(0);
    expect_end();
    setup();
    find_object(3, TBL_VA);
    set32(fx.self, 0x226, 0);
    expect_begin();
    CK(m4cf026_find_record(fx.self, 0x1234, &fx.host) == -1);
    CKN(0);
    expect_end();
    /* the signed count: 0, -1 and 0x8000 (= -0x8000) run no iteration */
    setup();
    find_object(0, TBL_VA);
    expect_begin();
    CK(m4cf026_find_record(fx.self, 7, &fx.host) == -1);
    CKN(0);
    set16(fx.hdr, 0x23, 0xffff);
    CK(m4cf026_find_record(fx.self, 7, &fx.host) == -1);
    set16(fx.hdr, 0x23, 0x8000);
    CK(m4cf026_find_record(fx.self, 7, &fx.host) == -1);
    CKN(0);
    /* a hit at index 1 of 3: the key and the original address of record i (table + i * 0x35) go to 0x516530, cdecl with no this */
    setup();
    find_object(3, TBL_VA);
    r[0] = 5;
    r[1] = 0;
    script(0x516530, 2, r);
    expect_begin();
    CK(m4cf026_find_record(fx.self, 0xcafe0001u, &fx.host) == 1);
    CKN(2);
    CKC(0, 0x516530, 0, 0xcafe0001u, TBL_VA);
    CKC(1, 0x516530, 0, 0xcafe0001u, TBL_VA + 0x35);
    expect_end();
    /* a hit at index 0 stops the loop at once; a miss walks the whole count and returns -1 */
    setup();
    find_object(2, TBL_VA);
    script1(0x516530, 0);
    CK(m4cf026_find_record(fx.self, 9, &fx.host) == 0);
    CKN(1);
    setup();
    find_object(3, TBL_VA);
    script1(0x516530, 0x80000000u);
    CK(m4cf026_find_record(fx.self, 9, &fx.host) == -1);
    CKN(3);
    CKC(2, 0x516530, 0, 9, TBL_VA + 2 * 0x35);
    /* the largest count, a hit at 0 */
    setup();
    find_object(0x7fff, TBL_VA);
    script1(0x516530, 0);
    CK(m4cf026_find_record(fx.self, 9, &fx.host) == 0);
    /* 32-bit address arithmetic: the record address wraps */
    setup();
    find_object(6, 0xffffff00u);
    script1(0x516530, 1);
    CK(m4cf026_find_record(fx.self, 9, &fx.host) == -1);
    CKN(6);
    CKC(5, 0x516530, 0, 9, (uint32_t)(0xffffff00u + 5 * 0x35));
    /* [self+0x226] and the count are read again at every step */
    setup();
    find_object(3, TBL_VA);
    script1(0x516530, 1);
    g_effect = find_change_table;
    v = m4cf026_find_record(fx.self, 9, &fx.host);
    CK(v == -1);
    CKN(3);
    CKC(0, 0x516530, 0, 9, TBL_VA);
    CKC(1, 0x516530, 0, 9, 0x20050000u + 0x35);
    CKC(2, 0x516530, 0, 9, 0x20050000u + 2 * 0x35);
    setup();
    find_object(3, TBL_VA);
    script1(0x516530, 1);
    g_effect = find_change_count;
    CK(m4cf026_find_record(fx.self, 9, &fx.host) == -1);
    CKN(1);
}

/* ---- 0x4cec6c -------------------------------------------------------------------------------------------------------------------- */

static void bump_object(uint16_t counter, uint32_t index, int16_t limit)
{
    set32(fx.self, 0x222, HDR_VA);
    set32(fx.self, 0x226, TBL_VA);
    set32(fx.self, 0x246, index);
    set16(fx.self, 0x1ca, counter);
    set16(fx.tbl, 0x35 * index + 0x23, (uint16_t)limit);
}

static void test_m4cec6c_bump_counter(void)
{
    /* guards: no store */
    setup();
    bump_object(3, 1, 10);
    set32(fx.self, 0x222, 0);
    expect_begin();
    m4cec6c_bump_counter(fx.self, &fx.host);
    expect_end();
    setup();
    bump_object(3, 1, 10);
    set32(fx.self, 0x226, 0);
    expect_begin();
    m4cec6c_bump_counter(fx.self, &fx.host);
    expect_end();
    setup();
    bump_object(3, 1, 10);
    set32(fx.self, 0x246, 0xffffffffu);
    expect_begin();
    m4cec6c_bump_counter(fx.self, &fx.host);
    expect_end();
    /* below the limit: +1 */
    setup();
    bump_object(4, 2, 10);
    expect_begin();
    set16(exp_self, 0x1ca, 5);
    m4cec6c_bump_counter(fx.self, &fx.host);
    expect_end();
    /* the new value equal to the limit stays; above the limit it is replaced by the limit (the record index 2 is used, not the neighbours) */
    setup();
    bump_object(9, 2, 10);
    expect_begin();
    set16(exp_self, 0x1ca, 10);
    m4cec6c_bump_counter(fx.self, &fx.host);
    expect_end();
    setup();
    bump_object(10, 2, 10);
    set16(fx.tbl, 0x35 * 1 + 0x23, 100);
    set16(fx.tbl, 0x35 * 3 + 0x23, 100);
    expect_begin();
    set16(exp_self, 0x1ca, 10);
    m4cec6c_bump_counter(fx.self, &fx.host);
    expect_end();
    /* 16-bit wrap and signed compares: 0xffff + 1 = 0 (not above 0) */
    setup();
    bump_object(0xffff, 0, 0);
    expect_begin();
    set16(exp_self, 0x1ca, 0);
    m4cec6c_bump_counter(fx.self, &fx.host);
    expect_end();
    /* 0 is above the limit -5 (0xfffb): replaced */
    setup();
    bump_object(0xffff, 0, -5);
    expect_begin();
    set16(exp_self, 0x1ca, 0xfffb);
    m4cec6c_bump_counter(fx.self, &fx.host);
    expect_end();
    /* 0x7fff + 1 = 0x8000 = -32768: signed, not above 5 */
    setup();
    bump_object(0x7fff, 1, 5);
    expect_begin();
    set16(exp_self, 0x1ca, 0x8000);
    m4cec6c_bump_counter(fx.self, &fx.host);
    expect_end();
    /* 0xfffe + 1 = 0xffff = -1, equal to the limit -1: stays; the upper half of the dword at +0x1ca is not touched (the neighbours stay 0xa5) */
    setup();
    bump_object(0xfffe, 0, -1);
    expect_begin();
    set16(exp_self, 0x1ca, 0xffff);
    m4cec6c_bump_counter(fx.self, &fx.host);
    expect_end();
    CK(get16(fx.self, 0x1ca) == 0xffff && get16(fx.self, 0x1cc) == 0xa5a5);
}

/* ---- 0x4cf1e4 -------------------------------------------------------------------------------------------------------------------- */

static void test_m4cf1e4_alloc_clear(void)
{
    uint32_t size, k;
    int32_t v;
    uint32_t sizes[] = {0, 1, 2, 3, 4, 5, 7, 8, 9, 0x23};
    /* failure: the dword at `out` is set to 0, then the report: 0x50ca3e(0x63888b, 0x559b94), 0x4264e8(this 0x583979, 0x63888b), 0x4c97b4(this 0x5cf659); the debug word adds 0x44a2b7(0x63888b) before the last */
    setup();
    script1(0x51dc43, 0);
    expect_begin();
    set32(exp_out, 0, 0);
    v = m4cf1e4_alloc_clear(fx.out, 0x30, &fx.w, &fx.host);
    CK(v == 0);
    CKN(4);
    CKC(0, 0x51dc43, 0, 0x30);
    CKC(1, 0x50ca3e, 0, 0x63888b, 0x559b94);
    CKC(2, 0x4264e8, 0x583979, 0x63888b);
    CKC0(3, 0x4c97b4, 0x5cf659);
    expect_end();
    setup();
    script1(0x51dc43, 0);
    fx.w.word_63a4cd = (int16_t)0x8000;
    v = m4cf1e4_alloc_clear(fx.out, 0xffffffffu, &fx.w, &fx.host);
    CK(v == 0);
    CKN(5);
    CKC(0, 0x51dc43, 0, 0xffffffffu);
    CKC(3, 0x44a2b7, 0, 0x63888b);
    CKC0(4, 0x4c97b4, 0x5cf659);
    /* success: `size` bytes at p are cleared, nothing around them; the dword at out is p */
    for (k = 0; k < sizeof sizes / sizeof sizes[0]; k++) {
        size = sizes[k];
        setup();
        script1(0x51dc43, HEAP_VA + 0x10);
        expect_begin();
        set32(exp_out, 0, HEAP_VA + 0x10);
        memset(exp_heap + 0x10, 0, size);
        v = m4cf1e4_alloc_clear(fx.out, size, &fx.w, &fx.host);
        CK(v == 1);
        CKN(1);
        CKC(0, 0x51dc43, 0, size);
        expect_end();
    }
    /* size 0 with a pointer that resolves to nothing: no memory is touched */
    setup();
    script1(0x51dc43, 0x1234);
    expect_begin();
    set32(exp_out, 0, 0x1234);
    CK(m4cf1e4_alloc_clear(fx.out, 0, &fx.w, &fx.host) == 1);
    expect_end();
    /* the debug word is not consulted on success */
    setup();
    fx.w.word_63a4cd = 1;
    script1(0x51dc43, HEAP_VA);
    CK(m4cf1e4_alloc_clear(fx.out, 4, &fx.w, &fx.host) == 1);
    CKN(1);
}

/* ---- 0x4ceb8c -------------------------------------------------------------------------------------------------------------------- */

static void rect_object(uint32_t index)
{
    set32(fx.self, 0x222, HDR_VA);
    set32(fx.self, 0x22a, TBL_VA);
    set32(fx.self, 0x24a, index);
    fx.w.origin_x_583186 = 1000;
    fx.w.origin_y_58318a = -7;
}

static void test_m4ceb8c_load_rect(void)
{
    uint8_t *rec;
    /* guards: no store */
    setup();
    rect_object(1);
    set32(fx.self, 0x222, 0);
    expect_begin();
    m4ceb8c_load_rect(fx.self, &fx.w, &fx.host);
    expect_end();
    setup();
    rect_object(1);
    set32(fx.self, 0x22a, 0);
    expect_begin();
    m4ceb8c_load_rect(fx.self, &fx.w, &fx.host);
    expect_end();
    setup();
    rect_object(0xffffffffu);
    expect_begin();
    m4ceb8c_load_rect(fx.self, &fx.w, &fx.host);
    expect_end();
    /* record 3 (stride 0x22): the eight dwords at the original offsets; the y offset is added to +0x16 and +0x1e, the x offset to +0x12 and +0x1a */
    setup();
    rect_object(3);
    rec = fx.tbl + 3 * 0x22;
    set32(rec, 2, 0x11111111u);
    set32(rec, 6, 0x22222222u);
    set32(rec, 0xa, 0x33333333u);
    set32(rec, 0xe, 0x44444444u);
    set32(rec, 0x12, 100);
    set32(rec, 0x16, 200);
    set32(rec, 0x1a, 300);
    set32(rec, 0x1e, 400);
    expect_begin();
    set32(exp_self, 0x1e2, 0x11111111u);
    set32(exp_self, 0x1e6, 0x22222222u);
    set32(exp_self, 0x1ea, 0x33333333u);
    set32(exp_self, 0x1ee, 0x44444444u);
    set32(exp_self, 0x1f2, 1100);
    set32(exp_self, 0x1f6, 193);
    set32(exp_self, 0x1fa, 1300);
    set32(exp_self, 0x1fe, 393);
    m4ceb8c_load_rect(fx.self, &fx.w, &fx.host);
    expect_end();
    CKN(0);
    /* 32-bit wrap of the sums */
    setup();
    rect_object(0);
    set32(fx.tbl, 0x12, 0xffffffffu);
    set32(fx.tbl, 0x16, 0x7fffffffu);
    fx.w.origin_x_583186 = 2;
    fx.w.origin_y_58318a = 1;
    m4ceb8c_load_rect(fx.self, &fx.w, &fx.host);
    CK(get32(fx.self, 0x1f2) == 1 && get32(fx.self, 0x1f6) == 0x80000000u);
}

/* ---- 0x4ccef1 -------------------------------------------------------------------------------------------------------------------- */

#define PLAYER_VA 0x20060000u
#define VT2_VA 0x20070000u
#define VT_STUB 0x7e000a00u
#define SELFP ((uintptr_t)fx.self)

static void release_object(uint32_t player)
{
    set32(fx.self, 0x1d6, player);
    set32(fx.self, 4, 0x77);
    set32(fx.src, 0, VT2_VA);
    set32(fx.dst, 0, VT_STUB);
}

static void clear_player_at_449a94(int i, uint32_t callee, const uintptr_t *args)
{
    (void)i;
    (void)args;
    if (callee == 0x449a94) set32(fx.self, 0x1d6, 0);
}

static void test_m4ccef1_release_movie(void)
{
    /* no player: only the three closing calls, in order, with the pointers into the object */
    setup();
    release_object(0);
    expect_begin();
    m4ccef1_release_movie(fx.self, &fx.host);
    CKN(3);
    CKC(0, 0x415011, 0x5e2dbe, SELFP + 8);
    CKC(1, 0x41632b, 0x5e2dbe, SELFP + 8);
    CKC(2, 0x4bedfa, 0x6201f9, SELFP + 0x18e);
    expect_end();
    /* a player: 0x44c479(self+4); [self+4] = 2; 0x449a94(this = player); the virtual call [[player]+0] with this = player and 1; [self+0x1d6] = 0; 0x44c4ab(self+4); [self+4] = 0; the closing calls */
    setup();
    release_object(PLAYER_VA);
    expect_begin();
    set32(exp_self, 0x1d6, 0);
    set32(exp_self, 4, 0);
    m4ccef1_release_movie(fx.self, &fx.host);
    CKN(7);
    CKC(0, 0x44c479, 0, SELFP + 4);
    CKC0(1, 0x449a94, PLAYER_VA);
    CKC(2, VT_STUB, PLAYER_VA, 1);
    CKC(3, 0x44c4ab, 0, SELFP + 4);
    CKC(4, 0x415011, 0x5e2dbe, SELFP + 8);
    CKC(5, 0x41632b, 0x5e2dbe, SELFP + 8);
    CKC(6, 0x4bedfa, 0x6201f9, SELFP + 0x18e);
    CK(get32(L.c[0].snap_self, 4) == 0x77 && get32(L.c[0].snap_self, 0x1d6) == PLAYER_VA);        /* the state at each call */
    CK(get32(L.c[1].snap_self, 4) == 2 && get32(L.c[1].snap_self, 0x1d6) == PLAYER_VA);
    CK(get32(L.c[2].snap_self, 4) == 2 && get32(L.c[2].snap_self, 0x1d6) == PLAYER_VA);
    CK(get32(L.c[3].snap_self, 4) == 2 && get32(L.c[3].snap_self, 0x1d6) == 0);
    CK(get32(L.c[4].snap_self, 4) == 0);
    expect_end();
    /* 0x449a94 clears [self+0x1d6]: the re-read gives zero, so no virtual call */
    setup();
    release_object(PLAYER_VA);
    g_effect = clear_player_at_449a94;
    m4ccef1_release_movie(fx.self, &fx.host);
    CKN(6);
    CKC(0, 0x44c479, 0, SELFP + 4);
    CKC0(1, 0x449a94, PLAYER_VA);
    CKC(2, 0x44c4ab, 0, SELFP + 4);
    CK(get32(fx.self, 0x1d6) == 0 && get32(fx.self, 4) == 0);
}

/* ---- 0x4ce8ea -------------------------------------------------------------------------------------------------------------------- */

static void scan_object(uint32_t state, int16_t word)
{
    set32(fx.self, 0x1da, state);
    set32(fx.self, 0x226, TBL_VA);
    set32(fx.self, 0x246, 2);
    set32(fx.self, 0x212, PLAYER_VA);
    set32(fx.self, 0x18e, 0x1234);
    set16(fx.tbl, 2 * 0x35 + 0x23, (uint16_t)word);
    set32(fx.src, 0, 0xaabbccddu);
    set16(fx.src, 0x2d, 0xfffe);
    set16(fx.src, 0x2f, 5);
}

static void scan_scripts(uint32_t r85, uint32_t rbee, uint32_t r10f)
{
    script1(0x4bef85, r85);
    script1(0x4bee2c, rbee);
    script1(0x4bf10f, r10f);
}

static int16_t g_store232;
static void store_232_at_4ceb8c(int i, uint32_t callee, const uintptr_t *args)
{
    (void)i;
    (void)args;
    if (callee == 0x4ceb8c) set32(fx.self, 0x232, (uint32_t)(int32_t)g_store232);
}

/* the calls of both arms up to and including 0x4bf10f, checked from the call after 0x4bef85 */
static void ck_scan_calls(void)
{
    CKC(0, 0x4bef85, 0x6201f9, 0x1234);
    CKC(1, 0x4befc8, 0x6201f9, 0x1234);
    CKC(2, 0x4bf098, 0x6201f9, 0x1234, 0xaabbccddu, 5, 0xfffffffeu, 0, 0);
    CKC(3, 0x4bee2c, 0x6201f9, 0x1234);
}

static void test_m4ce8ea_scan_step(void)
{
    uint32_t other[] = {1, 2, 3, 0x10000, 0x10004, 0xffffffffu, 0x80000000u, 0x100};
    size_t k;
    /* every other state value returns at once */
    for (k = 0; k < sizeof other / sizeof other[0]; k++) {
        setup();
        scan_object(other[k], 7);
        expect_begin();
        m4ce8ea_scan_step(fx.self, &fx.w, &fx.host);
        CKN(0);
        expect_end();
    }
    /* arm 0, 0x4bef85 answers 0: nothing else happens */
    setup();
    scan_object(0, 7);
    scan_scripts(0, 8, 1);
    expect_begin();
    m4ce8ea_scan_step(fx.self, &fx.w, &fx.host);
    CKN(1);
    CKC(0, 0x4bef85, 0x6201f9, 0x1234);
    expect_end();
    /* arm 0, [self+0x232] = 8 - 1 = 7 equals the word 7: [+0x206] = [+0x20a] = 1, [+0x1de] = 3, state kept, the debug text */
    setup();
    scan_object(0, 7);
    scan_scripts(1, 8, 1);
    fx.w.word_63a4cd = 1;
    expect_begin();
    set32(exp_self, 0x232, 7);
    set32(exp_self, 0x206, 1);
    set32(exp_self, 0x20a, 1);
    set32(exp_self, 0x1de, 3);
    m4ce8ea_scan_step(fx.self, &fx.w, &fx.host);
    CKN(7);
    ck_scan_calls();
    CKC0(4, 0x4ceb8c, SELFP);
    CKC(5, 0x4bf10f, 0x6201f9, 0x1234);
    CKC(6, 0x44a2b7, 0, 0x559a28);
    CK(get32(L.c[4].snap_self, 0x232) == 7 && get32(L.c[4].snap_self, 0x206) == 1 && get32(L.c[4].snap_self, 0x20a) == 1 && get32(L.c[4].snap_self, 0x1de) == 0xa5a5a5a5u);
    expect_end();
    /* without the debug word: no 0x44a2b7 */
    setup();
    scan_object(0, 7);
    scan_scripts(1, 8, 1);
    m4ce8ea_scan_step(fx.self, &fx.w, &fx.host);
    CKN(6);
    CK(get32(fx.self, 0x1de) == 3);
    /* arm 0, a different value and 0x4bf10f non-zero: [+0x1da] = 4, no [+0x1de], no debug text */
    setup();
    scan_object(0, 7);
    scan_scripts(1, 20, 5);
    fx.w.word_63a4cd = 1;
    expect_begin();
    set32(exp_self, 0x232, 19);
    set32(exp_self, 0x206, 1);
    set32(exp_self, 0x20a, 1);
    set32(exp_self, 0x1da, 4);
    m4ce8ea_scan_step(fx.self, &fx.w, &fx.host);
    CKN(6);
    expect_end();
    /* arm 0, a different value but 0x4bf10f answers 0: [+0x1de] = 3 and the state is kept */
    setup();
    scan_object(0, 7);
    scan_scripts(1, 20, 0);
    expect_begin();
    set32(exp_self, 0x232, 19);
    set32(exp_self, 0x206, 1);
    set32(exp_self, 0x20a, 1);
    set32(exp_self, 0x1de, 3);
    m4ce8ea_scan_step(fx.self, &fx.w, &fx.host);
    CKN(6);
    expect_end();
    /* the word is signed: -3 equals 0xfffffffd ([+0x232] = 0xfffffffe - 1), 0xfffd does not (state 4) */
    setup();
    scan_object(0, -3);
    scan_scripts(1, 0xfffffffeu, 1);
    m4ce8ea_scan_step(fx.self, &fx.w, &fx.host);
    CK(get32(fx.self, 0x1de) == 3 && get32(fx.self, 0x1da) == 0);
    setup();
    scan_object(0, -3);
    scan_scripts(1, 0xfffeu, 1);
    m4ce8ea_scan_step(fx.self, &fx.w, &fx.host);
    CK(get32(fx.self, 0x1da) == 4 && get32(fx.self, 0x232) == 0xfffdu);
    /* [self+0x232] is read again after 0x4ceb8c: a callee that stores the equal value turns a difference into a match */
    setup();
    scan_object(0, 7);
    scan_scripts(1, 20, 1);
    g_store232 = 7;
    g_effect = store_232_at_4ceb8c;
    m4ce8ea_scan_step(fx.self, &fx.w, &fx.host);
    CK(get32(fx.self, 0x1de) == 3 && get32(fx.self, 0x1da) == 0 && get32(fx.self, 0x232) == 7);
    /* arm 4: the same sequence without [+0x20a] and without the [+0x1da] store; the debug text is 0x559aa8 */
    setup();
    scan_object(4, 7);
    scan_scripts(0, 8, 1);
    expect_begin();
    m4ce8ea_scan_step(fx.self, &fx.w, &fx.host);
    CKN(1);
    expect_end();
    setup();
    scan_object(4, 7);
    scan_scripts(1, 8, 1);
    fx.w.word_63a4cd = (int16_t)0x8000;
    expect_begin();
    set32(exp_self, 0x232, 7);
    set32(exp_self, 0x206, 1);
    set32(exp_self, 0x1de, 3);
    m4ce8ea_scan_step(fx.self, &fx.w, &fx.host);
    CKN(7);
    ck_scan_calls();
    CKC0(4, 0x4ceb8c, SELFP);
    CKC(5, 0x4bf10f, 0x6201f9, 0x1234);
    CKC(6, 0x44a2b7, 0, 0x559aa8);
    expect_end();
    setup();
    scan_object(4, 7);
    scan_scripts(1, 20, 5);
    fx.w.word_63a4cd = 1;
    expect_begin();
    set32(exp_self, 0x232, 19);
    set32(exp_self, 0x206, 1);
    m4ce8ea_scan_step(fx.self, &fx.w, &fx.host);
    CKN(6);
    expect_end();
    setup();
    scan_object(4, 7);
    scan_scripts(1, 20, 0);
    expect_begin();
    set32(exp_self, 0x232, 19);
    set32(exp_self, 0x206, 1);
    set32(exp_self, 0x1de, 3);
    m4ce8ea_scan_step(fx.self, &fx.w, &fx.host);
    CKN(6);
    expect_end();
}

/* ---- 0x4cd243 -------------------------------------------------------------------------------------------------------------------- */

#define SRC_VA 0x20060000u
#define TBL2_VA 0x20050000u
#define CELL_A (fx.cursor)
#define CELL_B (fx.cursor + 4)
#define CELL_C (fx.cursor + 8)

/* the stream: the header words (record counts) and the word [+0x2f] of each record, whose sub table follows the 0x31 bytes of the record */
static size_t tables_stream(uint16_t count, uint16_t count2, const int16_t *w)
{
    size_t at = 0x27;
    int i;
    set16(fx.src, 0x23, count);
    set16(fx.src, 0x25, count2);
    for (i = 0; i < (int16_t)count && i < 4; i++) {
        set16(fx.src, at + 0x2f, (uint16_t)w[i]);
        at += 0x31 + (w[i] > 0 ? (size_t)w[i] * 0x23 : 0);
    }
    return at;
}

/* the allocation stub: call k stores values[k] (0 for the call that fails) at its first argument, which is a field of the caller (a host pointer) or an original address */
static uint32_t g_values[8];
static int g_fail_at, g_alloc_calls;
static int16_t g_new_count;
static int g_rw_word, g_rw_count2;     /* the sub-table allocation of record 0 changes the word [rec+0x2f]; the last allocation changes the word [hdr+0x25] (-1: no) */
static void store_ptr(uintptr_t where, uint32_t v)
{
    uint8_t *p = where <= 0xffffffffu ? (uint8_t *)host_resolve(NULL, (uint32_t)where) : NULL;
    memcpy(p != NULL ? p : (uint8_t *)where, &v, 4);
}

static void alloc_effect(int i, uint32_t callee, const uintptr_t *args)
{
    (void)i;
    if (callee != 0x4cf1e4) return;
    store_ptr(args[0], g_alloc_calls == g_fail_at ? 0 : g_values[g_alloc_calls]);
    if (g_alloc_calls == 2 && g_rw_word >= 0) set16(fx.tbl, 0x2f, (uint16_t)g_rw_word);
    if (g_alloc_calls == 3 && g_rw_count2 >= 0) set16(fx.hdr, 0x25, (uint16_t)g_rw_count2);
    if (g_alloc_calls == 2 && g_new_count >= 0) set16(fx.hdr, 0x23, (uint16_t)g_new_count);     /* a header word that changes after the first record's allocation */
    g_alloc_calls++;
}

static void tables_setup(int fail_at, uint16_t count, uint16_t count2, const int16_t *w)
{
    size_t k;
    setup();
    set32(fx.self, 0x216, 0);
    tables_stream(count, count2, w);
    set32(fx.cursor, 0, 0xdeadbeefu);
    set32(fx.cursor, 4, SRC_VA);
    set32(fx.cursor, 8, 0x1000);
    g_values[0] = HDR_VA;
    g_values[1] = TBL_VA;
    g_values[2] = HEAP_VA;
    g_values[3] = HEAP_VA + 0x100;
    g_values[4] = TBL2_VA;
    for (k = 5; k < 8; k++) g_values[k] = TBL2_VA;
    g_values[(int16_t)count > 0 ? 2 + (int16_t)count : 2] = TBL2_VA;       /* the call after the records stores the second table (count <= 2 here) */
    g_fail_at = fail_at;
    g_alloc_calls = 0;
    g_new_count = -1;
    g_rw_word = g_rw_count2 = -1;
    g_effect = alloc_effect;
    fx.w.word_5c39e3 = -2;
    fx.w.value_5bb57b = 0x12345678u;
    {
        uint32_t res[8];
        for (k = 0; k < 8; k++) res[k] = (int)k == fail_at ? 0 : (k & 1) ? 0x10000u : 0x80000000u;      /* successes whose low 16 bits are zero */
        script(0x4cf1e4, 8, res);
    }
}

static void ck_tables_fail(int first, uint32_t text, uint32_t text2)
{
    CKC(first, 0x50ca3e, 0, 0x63888b, text, 0x12345678u, 0xfffffffeu);
    CKC(first + 1, 0x42639d, 0x583979, text2, 0x63888b);
    CKC0(first + 2, 0x4c97b4, 0x5cf659);
}

static void test_m4cd243_read_tables(void)
{
    int16_t w2[2] = {1, 0}, wneg[2] = {-1, 0}, w0[1] = {0};
    int k;
    int32_t v;
    /* [self+0x216] non-zero: nothing happens, with the debug word the two trace calls, never the stores */
    setup();
    set32(fx.self, 0x216, 1);
    fx.w.word_5c39e3 = -2;
    expect_begin();
    CK(m4cd243_read_tables(fx.self, CELL_A, CELL_B, CELL_C, &fx.w, &fx.host) == 0);
    CKN(0);
    expect_end();
    fx.w.word_63a4cd = 1;
    CK(m4cd243_read_tables(fx.self, CELL_A, CELL_B, CELL_C, &fx.w, &fx.host) == 0);
    CKN(2);
    CKC(0, 0x50ca3e, 0, 0x63888b, 0x55907c, 0xfffffffeu);
    CKC(1, 0x44a2b7, 0, 0x63888b);
    expect_end();
    /* two records, word2f = 1 and 0, three records in the second table: every copy, the cursors and the calls */
    tables_setup(-1, 2, 3, w2);
    expect_begin();
    set32(exp_self, 0x23e, 0xfffffffeu);
    set32(exp_self, 0x222, HDR_VA);
    set32(exp_self, 0x226, TBL_VA);
    set32(exp_self, 0x22a, TBL2_VA);
    memcpy(exp_hdr, fx.src, 0x27);
    memcpy(exp_tbl, fx.src + 0x27, 0x31);
    set32(exp_tbl, 0x31, HEAP_VA);
    memcpy(exp_tbl + 0x35, fx.src + 0x7b, 0x31);
    set32(exp_tbl, 0x35 + 0x31, HEAP_VA + 0x100);
    memcpy(exp_heap, fx.src + 0x58, 0x23);
    CK(m4cd243_read_tables(fx.self, CELL_A, CELL_B, CELL_C, &fx.w, &fx.host) == 1);
    CKN(5);
    CKC(0, 0x4cf1e4, SELFP, (uintptr_t)CELL_A, 0x27);
    CKC(1, 0x4cf1e4, SELFP, SELFP + 0x226, 0x6a);
    CKC(2, 0x4cf1e4, SELFP, (uintptr_t)(fx.tbl + 0x31), 0x23);
    CKC(3, 0x4cf1e4, SELFP, (uintptr_t)(fx.tbl + 0x35 + 0x31), 0);
    CKC(4, 0x4cf1e4, SELFP, SELFP + 0x22a, 0x66);
    CK(get32(L.c[0].snap_self, 0x23e) == 0xfffffffeu && get32(L.c[1].snap_self, 0x222) == HDR_VA);
    CK(get32(fx.cursor, 0) == HDR_VA && get32(fx.cursor, 4) == SRC_VA + 0x112 && get32(fx.cursor, 8) == 0x1000 + 0x112);
    CK(memcmp(fx.tbl2, fx.src + 0xac, 0x66) == 0);
    {
        /* the second table is compared separately (it is not in the expected copies) */
        uint8_t keep[0x66];
        memcpy(keep, fx.tbl2, sizeof keep);
        CK(memcmp(keep, fx.src + 0xac, sizeof keep) == 0 && fx.tbl2[0x66] == (uint8_t)(0x66 * 9 + 2));
    }
    expect_end();
    /* with the debug word: 0x4cf276(this self) and 0x44a2b7(0x55925c) after the copies */
    tables_setup(-1, 2, 3, w2);
    fx.w.word_63a4cd = (int16_t)0x8000;
    CK(m4cd243_read_tables(fx.self, CELL_A, CELL_B, CELL_C, &fx.w, &fx.host) == 1);
    CKN(7);
    CKC0(5, 0x4cf276, SELFP);
    CKC(6, 0x44a2b7, 0, 0x55925c);
    /* each allocation failing in turn: its cell is stored as 0 by the callee, then the report (text pair of that allocation) and return 0, no later call */
    for (k = 0; k < 5; k++) {
        tables_setup(k, 2, 3, w2);
        v = m4cd243_read_tables(fx.self, CELL_A, CELL_B, CELL_C, &fx.w, &fx.host);
        CK(v == 0);
        CKN(k + 1 + 3);
        if (k == 0) ck_tables_fail(1, 0x5590f8, 0x559124);
        if (k == 1) ck_tables_fail(2, 0x559140, 0x559184);
        if (k == 2 || k == 3) ck_tables_fail(k + 1, 0x5591a0, 0x5591e4);
        if (k == 4) ck_tables_fail(5, 0x559200, 0x559240);
    }
    /* the cursors at the failures: untouched at the first, +0x27 at the second and third, +0x27 + c at the fourth (the second table) */
    tables_setup(0, 2, 3, w2);
    (void)m4cd243_read_tables(fx.self, CELL_A, CELL_B, CELL_C, &fx.w, &fx.host);
    CK(get32(fx.cursor, 4) == SRC_VA && get32(fx.cursor, 8) == 0x1000 && get32(fx.self, 0x222) == 0xa5a5a5a5u && get32(fx.cursor, 0) == 0);
    tables_setup(2, 2, 3, w2);
    (void)m4cd243_read_tables(fx.self, CELL_A, CELL_B, CELL_C, &fx.w, &fx.host);
    CK(get32(fx.cursor, 4) == SRC_VA + 0x27 && get32(fx.cursor, 8) == 0x1000 + 0x27 && get32(fx.self, 0x222) == HDR_VA);
    CK(memcmp(fx.tbl, fx.src + 0x27, 0x31) == 0 && get32(fx.tbl, 0x31) == 0);
    tables_setup(4, 2, 3, w2);
    (void)m4cd243_read_tables(fx.self, CELL_A, CELL_B, CELL_C, &fx.w, &fx.host);
    CK(get32(fx.cursor, 4) == SRC_VA + 0x27 + 0x85 && get32(fx.cursor, 8) == 0x1000 + 0x27 + 0x85 && get32(fx.self, 0x22a) == 0);
    /* signed counts: word 0x8000 is -32768 (no record, the allocation size is -32768 * 0x35 as a dword); a negative sub-table size is passed on as a dword */
    tables_setup(-1, 0x8000, 0, w0);
    CK(m4cd243_read_tables(fx.self, CELL_A, CELL_B, CELL_C, &fx.w, &fx.host) == 1);
    CKN(3);
    CKC(1, 0x4cf1e4, SELFP, SELFP + 0x226, (uint32_t)(-32768 * 0x35));
    CK(get32(fx.cursor, 4) == SRC_VA + 0x27);
    tables_setup(2, 1, 0, wneg);
    CK(m4cd243_read_tables(fx.self, CELL_A, CELL_B, CELL_C, &fx.w, &fx.host) == 0);
    CKC(2, 0x4cf1e4, SELFP, (uintptr_t)(fx.tbl + 0x31), (uint32_t)(-1 * 0x23));
    /* native rejections: a negative size after a successful allocation returns 0 before the copy (the first record's, the second table's) */
    tables_setup(-1, 1, 0, wneg);
    expect_begin();
    CK(m4cd243_read_tables(fx.self, CELL_A, CELL_B, CELL_C, &fx.w, &fx.host) == 0);
    CKN(3);
    CK(get32(fx.cursor, 4) == SRC_VA + 0x27);
    CK(memcmp(fx.heap, exp_heap, HEAP_SZ) == 0);
    tables_setup(-1, 0, 0xffff, w0);
    expect_begin();
    CK(m4cd243_read_tables(fx.self, CELL_A, CELL_B, CELL_C, &fx.w, &fx.host) == 0);
    CKN(3);
    CK(fx.tbl2[0] == 2 && get32(fx.cursor, 4) == SRC_VA + 0x27);
    /* the sub-table allocation changes the word [rec+0x2f] from 1 to 3: the copy and c use the new size (0x69), the allocation was asked for the old one (0x23) */
    tables_setup(-1, 1, 0, w2);
    g_rw_word = 3;
    CK(m4cd243_read_tables(fx.self, CELL_A, CELL_B, CELL_C, &fx.w, &fx.host) == 1);
    CKC(2, 0x4cf1e4, SELFP, (uintptr_t)(fx.tbl + 0x31), 0x23);
    CK(memcmp(fx.heap, fx.src + 0x58, 0x69) == 0 && fx.heap[0x69] == 0xAA);
    CK(get32(fx.cursor, 4) == SRC_VA + 0x27 + 0x31 + 0x69 && get32(fx.cursor, 8) == 0x1000 + 0x27 + 0x31 + 0x69);
    /* the last allocation changes the word [hdr+0x25] from 2 to 3: the copy and the cursors use 3 * 0x22, the allocation was asked for 2 * 0x22 */
    tables_setup(-1, 1, 2, w2);
    g_rw_count2 = 3;
    CK(m4cd243_read_tables(fx.self, CELL_A, CELL_B, CELL_C, &fx.w, &fx.host) == 1);
    CKC(3, 0x4cf1e4, SELFP, SELFP + 0x22a, 0x44);
    CK(memcmp(fx.tbl2, fx.src + 0x27 + 0x31 + 0x23, 0x66) == 0 && fx.tbl2[0x66] == (uint8_t)(0x66 * 9 + 2));
    CK(get32(fx.cursor, 4) == SRC_VA + 0x27 + 0x31 + 0x23 + 0x66);
    /* the header word is read again for the loop: a callee that lowers it to 1 after the first record's allocation ends the loop there */
    tables_setup(-1, 2, 3, w2);
    g_new_count = 1;
    CK(m4cd243_read_tables(fx.self, CELL_A, CELL_B, CELL_C, &fx.w, &fx.host) == 1);
    CKN(4);
    CKC(3, 0x4cf1e4, SELFP, SELFP + 0x22a, 0x66);
    CK(fx.tbl[0x35] == (uint8_t)(0x35 * 5 + 1) && fx.tbl[0x35 + 0x31] == (uint8_t)((0x35 + 0x31) * 5 + 1));     /* the second record was never read */
    CK(get32(fx.cursor, 4) == SRC_VA + 0x27 + 0x31 + 0x23 + 0x66);
}

/*TESTS*/

static uint32_t rng_state = 12345;
static uint32_t rnd(void)
{
    rng_state = rng_state * 1664525u + 1013904223u;
    return rng_state >> 8;
}

static void test_sweep_bounded(void)
{
    int i;
    for (i = 0; i < 300; i++) {
        uint32_t r[8];
        size_t b;
        int k;
        setup();
        for (b = 0; b < SELF_SZ; b++) fx.self[b] = (uint8_t)rnd();
        for (b = 0; b < TBL_SZ; b++) fx.tbl[b] = (uint8_t)rnd();
        find_object((uint16_t)(rnd() % 8), rnd() % 4 == 0 ? 0 : TBL_VA);
        if (rnd() % 5 == 0) set32(fx.self, 0x222, 0);
        for (k = 0; k < 8; k++) r[k] = rnd() % 3 == 0 ? 0 : rnd() | 1;
        script(0x516530, 8, r);
        (void)m4cf026_find_record(fx.self, rnd(), &fx.host);
        set32(fx.self, 0x246, rnd() % 4 == 0 ? 0xffffffffu : rnd() % 6);
        set32(fx.self, 0x222, rnd() % 5 == 0 ? 0 : HDR_VA);
        set32(fx.self, 0x226, rnd() % 5 == 0 ? 0 : TBL_VA);
        m4cec6c_bump_counter(fx.self, &fx.host);
        set32(fx.self, 0x222, rnd() % 5 == 0 ? 0 : HDR_VA);
        set32(fx.self, 0x22a, rnd() % 5 == 0 ? 0 : TBL_VA);
        set32(fx.self, 0x24a, rnd() % 4 == 0 ? 0xffffffffu : rnd() % 6);
        fx.w.origin_x_583186 = (int32_t)rnd();
        fx.w.origin_y_58318a = (int32_t)rnd();
        m4ceb8c_load_rect(fx.self, &fx.w, &fx.host);
        r[0] = rnd() % 3 == 0 ? 0 : HEAP_VA + rnd() % 0x20;
        script(0x51dc43, 1, r);
        fx.w.word_63a4cd = (int16_t)(rnd() % 3);
        (void)m4cf1e4_alloc_clear(fx.out, rnd() % 0x40, &fx.w, &fx.host);
    }
    for (i = 0; i < 300; i++) {
        uint32_t r[1];
        setup();
        release_object(rnd() % 3 == 0 ? 0 : PLAYER_VA);
        if (rnd() % 3 == 0) g_effect = clear_player_at_449a94;
        m4ccef1_release_movie(fx.self, &fx.host);
        scan_object(rnd() % 3 == 0 ? rnd() % 6 : (rnd() % 2) * 4, (int16_t)(rnd() % 4 == 0 ? 7 : rnd()));
        script1(0x4bef85, rnd() % 4 != 0);
        r[0] = rnd() % 2 ? 8 : rnd();
        script(0x4bee2c, 1, r);
        script1(0x4bf10f, rnd() % 3 != 0);
        fx.w.word_63a4cd = (int16_t)(rnd() % 3);
        m4ce8ea_scan_step(fx.self, &fx.w, &fx.host);
    }
    for (i = 0; i < 300; i++) {
        int16_t w[2];
        uint16_t count = (uint16_t)(rnd() % 3);
        w[0] = (int16_t)(rnd() % 4);
        w[1] = (int16_t)(rnd() % 4);
        tables_setup(rnd() % 3 == 0 ? (int)(rnd() % 5) : -1, count, (uint16_t)(rnd() % 6), w);
        set32(fx.self, 0x216, rnd() % 8 == 0 ? 1 : 0);
        fx.w.word_63a4cd = (int16_t)(rnd() % 3);
        (void)m4cd243_read_tables(fx.self, CELL_A, CELL_B, CELL_C, &fx.w, &fx.host);
    }
    /*SWEEPS*/
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
    RUN(test_m4cf026_find_record);
    RUN(test_m4cec6c_bump_counter);
    RUN(test_m4cf1e4_alloc_clear);
    RUN(test_m4ceb8c_load_rect);
    RUN(test_m4ccef1_release_movie);
    RUN(test_m4ce8ea_scan_step);
    RUN(test_m4cd243_read_tables);
    /*RUNS*/
    RUN(test_sweep_bounded);
    return failures;
}
