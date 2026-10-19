/* FL-26 (batch a) direct tests of the last session input handlers of GAME.EXE in src/original_methods_fl26a.c. Prints "PASS <name>" /
 * "FAIL <name>: <msg>"; the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values were derived by
 * hand from the disassembly of GAME.EXE, not from running the native code; tests/test_fl26a_differential.py additionally runs the
 * original bytes on generated fixtures.
 *
 * Every function is checked three ways: (1) the guard matrix, each guard of the chain failing in turn (several fail values each, widths
 * probed), which must leave the object and the call log untouched; (2) each arm with the whole object compared with a hand-edited copy,
 * and the ordered host calls with their arguments and the state of the object at the call; (3) the edges of every comparison, one
 * missing by one at a time (and the 32-bit wrap of the widened edges of 0x469057). */
#include "../src/original_methods_fl26a.h"

#include <stdio.h>
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

#define SELF_SZ 0x900
#define REC 0x8d
#define TAB_SZ (REC * 6)          /* records -1 .. 4 */
#define OBJ_SZ 0xb00
#define OBJ_VA(k) (0x20010000u + 0x10000u * (uint32_t)(k))   /* the objects 0, 1, 2 (record object of the hit tests = object 0) */
#define DECOY_VA 0x20040000u
#define RECT_VA 0x20050000u
#define SNAP 0x800

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
    uint8_t self[SELF_SZ], tab[TAB_SZ], obj[3][OBJ_SZ], decoy[0x1000], rect[16];
    Fl26aWorld w;
    Fl18Host host;
} fx;
static uint8_t exp_self[SELF_SZ], exp_tab[TAB_SZ], exp_obj[3][OBJ_SZ];

static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a0;
        uint8_t snap_self[SNAP];
        uint32_t g[3];           /* 0x5a4c18, 0x5c39e5, 0x5b44f8 at the call */
    } c[32];
} L;

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    (void)ctx;
    if (L.n < 32) {
        L.c[L.n].callee = callee;
        L.c[L.n].this_ptr = this_ptr;
        L.c[L.n].nargs = nargs;
        L.c[L.n].a0 = nargs > 0 ? args[0] : 0;
        memcpy(L.c[L.n].snap_self, fx.self, SNAP);
        L.c[L.n].g[0] = fx.w.value_5a4c18;
        L.c[L.n].g[1] = fx.w.value_5c39e5;
        L.c[L.n].g[2] = fx.w.value_5b44f8;
    }
    L.n++;
    return 0;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    int k;
    (void)ctx;
    for (k = 0; k < 3; k++)
        if (a >= OBJ_VA(k) && a < OBJ_VA(k) + OBJ_SZ) return fx.obj[k] + (a - OBJ_VA(k));
    if (a >= DECOY_VA && a < DECOY_VA + 0x1000) return fx.decoy + (a - DECOY_VA);
    if (a >= RECT_VA && a < RECT_VA + 16) return fx.rect + (a - RECT_VA);
    return NULL;
}

/* a pristine fixture: the object bytes 0xA5, the objects a pattern, every record in state 0 but record idx (object 0, state 1) */
static void setup(int idx)
{
    int i, k;
    size_t b;
    memset(fx.self, 0xA5, sizeof fx.self);
    for (k = 0; k < 3; k++)
        for (b = 0; b < OBJ_SZ; b++) fx.obj[k][b] = (uint8_t)(b * 7 + 3 + k);
    memset(fx.decoy, 0x11, sizeof fx.decoy);
    set32(fx.rect, 0, 0x11111111u);
    set32(fx.rect, 4, 0x22222222u);
    set32(fx.rect, 8, 0x33333333u);
    set32(fx.rect, 12, 0x44444444u);
    memset(fx.tab, 0xCC, sizeof fx.tab);
    for (i = -1; i <= 4; i++) {
        set32(fx.tab, (size_t)(i + 1) * REC, i == idx ? OBJ_VA(0) : DECOY_VA);
        set32(fx.tab, (size_t)(i + 1) * REC + 0x4d, i == idx ? 1u : 0u);
    }
    memset(&fx.w, 0, sizeof fx.w);
    fx.w.records_5bb5e5 = fx.tab + REC;
    memset(&fx.host, 0, sizeof fx.host);
    fx.host.call = host_call;
    fx.host.resolve = host_resolve;
    L.n = 0;
}

static void expect_begin(void)
{
    memcpy(exp_self, fx.self, sizeof exp_self);
    memcpy(exp_tab, fx.tab, sizeof exp_tab);
    memcpy(exp_obj, fx.obj, sizeof exp_obj);
}

static void expect_end_at(int line)
{
    if (!g_failed && (memcmp(exp_self, fx.self, sizeof exp_self) != 0 || memcmp(exp_tab, fx.tab, sizeof exp_tab) != 0 || memcmp(exp_obj, fx.obj, sizeof exp_obj) != 0)) {
        g_failed = 1;
        snprintf(g_msg, sizeof g_msg, "line %d: the object, the record table or an object differs from the expected copy", line);
    }
}

#define expect_end() expect_end_at(__LINE__)

static void ck_call(int n, uint32_t callee, uintptr_t this_ptr, int nargs, uintptr_t a0)
{
    CK(L.n > n);
    if (L.n <= n) return;
    CK(L.c[n].callee == callee);
    CK(L.c[n].this_ptr == this_ptr);
    CK(L.c[n].nargs == nargs);
    CK(nargs < 1 || L.c[n].a0 == a0);
}

/* the rectangle at four dword offsets of a buffer: the stored edges ylo, yhi, xlo, xhi such that, with the code adding ay0 / ay1 / ax0 / ax1
 * before the signed compare, the effective rectangle holds the point exactly on its edges (miss: edge e is one outside) */
static void rect_adj(uint8_t *o, const size_t offs[4], const int adj[4], int x, int y, int miss_edge)
{
    int eff[4], e;
    eff[0] = y + (miss_edge == 0);
    eff[1] = y - (miss_edge == 1);
    eff[2] = x + (miss_edge == 2);
    eff[3] = x - (miss_edge == 3);
    for (e = 0; e < 4; e++) set32(o, offs[e], (uint32_t)(eff[e] - adj[e]));
}

static const int ADJ0[4] = {0, 0, 0, 0};
static const int ADJ57[4] = {-5, 5, -6, 10};     /* 0x469057: sub 5, add 5, sub 6, add 0xa */

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x4d3073 */

static const struct {
    uint32_t sel, callee, ecx;
} ARMS[] = {{2, 0x4e77b8, 0x582711}, {3, 0x4e89eb, 0x571442}, {4, 0x4ebd85, 0x57fd34}, {5, 0x4e412d, 0x57975c}};

static void test_m4d3073_session_tick(void)
{
    static const uint32_t DEFAULT_SELS[] = {0, 1, 6, 7, 0x80000002u, 0x7fffffffu, 0xffffffffu, 0x80000005u};
    size_t a, f;
    int flag;
    for (a = 0; a < 4; a++) {
        setup(0);
        fx.w.value_5a4c18 = 0x1234;
        fx.w.value_5c39e5 = 0x77;
        fx.w.value_5b44f8 = 0xabcdef;
        fx.w.value_583204 = ARMS[a].sel;
        fx.w.byte_5a161f = 0xff;             /* does not matter in an arm of the switch */
        m4d3073_session_tick(&fx.w, &fx.host);
        CK(L.n == 3);
        ck_call(0, 0x4db38a, 0x5830ce, 0, 0);
        ck_call(1, 0x4e8d72, 0x571442, 0, 0);
        ck_call(2, ARMS[a].callee, ARMS[a].ecx, 0, 0);
        /* the call-time state: before the first call nothing is reset, before the second only the first two are, before the arm all three */
        CK(L.c[0].g[0] == 0x1234 && L.c[0].g[1] == 0x77 && L.c[0].g[2] == 0xabcdefu);
        CK(L.c[1].g[0] == 0 && L.c[1].g[1] == 0xffffffffu && L.c[1].g[2] == 0xabcdefu);
        CK(L.c[2].g[0] == 0 && L.c[2].g[1] == 0xffffffffu && L.c[2].g[2] == 0);
        CK(fx.w.value_5a4c18 == 0 && fx.w.value_5c39e5 == 0xffffffffu && fx.w.value_5b44f8 == 0 && fx.w.value_583204 == ARMS[a].sel);
    }
    for (f = 0; f < sizeof DEFAULT_SELS / sizeof DEFAULT_SELS[0]; f++) {
        for (flag = 0; flag < 4; flag++) {
            static const uint8_t FLAGS[4] = {0, 1, 0x80, 0xff};
            setup(0);
            fx.w.value_5a4c18 = 9;
            fx.w.value_5c39e5 = 8;
            fx.w.value_5b44f8 = 7;
            fx.w.value_583204 = DEFAULT_SELS[f];
            fx.w.byte_5a161f = FLAGS[flag];
            m4d3073_session_tick(&fx.w, &fx.host);
            CK(L.n == (FLAGS[flag] != 0 ? 5 : 4));
            ck_call(0, 0x4db38a, 0x5830ce, 0, 0);
            ck_call(1, 0x4e8d72, 0x571442, 0, 0);
            ck_call(2, 0x4f0059, 0x583182, 0, 0);
            ck_call(3, 0x4e075a, 0x570508, 0, 0);
            if (FLAGS[flag] != 0) ck_call(4, 0x4de322, 0x61f864, 0, 0);
            CK(L.c[2].g[0] == 0 && L.c[2].g[1] == 0xffffffffu && L.c[2].g[2] == 0);
            CK(fx.w.value_5a4c18 == 0 && fx.w.value_5c39e5 == 0xffffffffu && fx.w.value_5b44f8 == 0);
        }
    }
    /* a NULL call hook: the step still resets the globals and does not crash */
    setup(0);
    fx.host.call = NULL;
    fx.w.value_583204 = 9;
    fx.w.byte_5a161f = 1;
    m4d3073_session_tick(&fx.w, &fx.host);
    CK(fx.w.value_5c39e5 == 0xffffffffu && L.n == 0);
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x469057 */

static const size_t ROW57[6][4] = {{0x20, 0x28, 0x1c, 0x24}, {0x30, 0x38, 0x2c, 0x34}, {0x40, 0x48, 0x3c, 0x44},
                                   {0x50, 0x58, 0x4c, 0x54}, {0x60, 0x68, 0x5c, 0x64}, {0x70, 0x78, 0x6c, 0x74}};
static const size_t TAIL57[4] = {0x35, 0x3d, 0x31, 0x39};

/* every row of the object and the record object miss the point by a wide margin; the gate is set */
static void setup_469057(int idx, int x, int y)
{
    int k;
    setup(idx);
    set32(fx.self, 0x55c, 1);
    set16(fx.self, 0x7e, (uint16_t)idx);
    for (k = 0; k < 6; k++) rect_adj(fx.self, ROW57[k], ADJ57, x + 100, y + 100, 0);
    rect_adj(fx.obj[0], TAIL57, ADJ57, x + 100, y + 100, 0);
}

static int run_469057(int x, int y)
{
    return m469057_hit_test(fx.self, (int16_t)x, (int16_t)y, &fx.w, &fx.host);
}

static void exp_stores_469057(int hit, int x, int y)
{
    set16(exp_self, 0x548, 0xffff);
    set16(exp_self, 0x552, hit ? (uint16_t)x : 0xffff);
    set16(exp_self, 0x554, hit ? (uint16_t)y : 0xffff);
}

static void test_m469057_hit_test(void)
{
    static const int PTS[][2] = {{10, 20}, {0, 0}, {-1, -1}, {-32768, 32767}, {32767, -32768}, {255, 1}};
    size_t p;
    int k, e, idx, v, ret;
    for (p = 0; p < sizeof PTS / sizeof PTS[0]; p++) {
        int x = PTS[p][0], y = PTS[p][1];
        /* the gate dword: zero, and non-zero in the high word only, which counts as set */
        setup_469057(1, x, y);
        set32(fx.self, 0x55c, 0);
        for (k = 0; k < 6; k++) rect_adj(fx.self, ROW57[k], ADJ57, x, y, -1);
        rect_adj(fx.obj[0], TAIL57, ADJ57, x, y, -1);
        expect_begin();
        CK(run_469057(x, y) == 0);
        CK(L.n == 0);
        expect_end();
        setup_469057(1, x, y);
        set32(fx.self, 0x55c, 0x10000);
        expect_begin();
        CK(run_469057(x, y) == 0);
        exp_stores_469057(0, x, y);
        expect_end();
        /* no row, tail misses at each edge by one: 0, and the words 0xffff are stored */
        for (e = 0; e < 4; e++) {
            setup_469057(2, x, y);
            rect_adj(fx.obj[0], TAIL57, ADJ57, x, y, e);
            expect_begin();
            CK(run_469057(x, y) == 0);
            CK(L.n == 0);
            exp_stores_469057(0, x, y);
            expect_end();
        }
        /* the tail holds the point exactly on its edges (any record index -1 .. 4): call 0x4691ee with 0x64, the words stay 0xffff */
        for (idx = -1; idx <= 4; idx++) {
            setup_469057(idx, x, y);
            rect_adj(fx.obj[0], TAIL57, ADJ57, x, y, -1);
            expect_begin();
            ret = run_469057(x, y);
            CK(ret == 1);
            CK(L.n == 1);
            ck_call(0, 0x4691ee, (uintptr_t)fx.self, 1, 0x64);
            exp_stores_469057(0, x, y);
            expect_end();
        }
        /* each row alone holds the point exactly (all four edges) or misses at each edge by one */
        for (k = 0; k < 6; k++) {
            setup_469057(3, x, y);
            rect_adj(fx.self, ROW57[k], ADJ57, x, y, -1);
            rect_adj(fx.obj[0], TAIL57, ADJ57, x, y, -1);     /* the tail would hit too: the row comes first */
            expect_begin();
            CK(run_469057(x, y) == 1);
            CK(L.n == 1);
            ck_call(0, 0x4691ee, (uintptr_t)fx.self, 1, (uintptr_t)k);
            exp_stores_469057(1, x, y);
            expect_end();
            CK(get16(L.c[0].snap_self, 0x552) == (uint16_t)x && get16(L.c[0].snap_self, 0x554) == (uint16_t)y);   /* stored before the call */
            for (e = 0; e < 4; e++) {
                setup_469057(3, x, y);
                rect_adj(fx.self, ROW57[k], ADJ57, x, y, e);
                expect_begin();
                CK(run_469057(x, y) == 0);
                CK(L.n == 0);
                exp_stores_469057(0, x, y);
                expect_end();
            }
        }
    }
    /* the first row that holds the point wins, whatever the later rows say */
    setup_469057(0, 5, 6);
    rect_adj(fx.self, ROW57[2], ADJ57, 5, 6, -1);
    rect_adj(fx.self, ROW57[4], ADJ57, 5, 6, -1);
    CK(run_469057(5, 6) == 1 && L.n == 1);
    ck_call(0, 0x4691ee, (uintptr_t)fx.self, 1, 2);
    /* the widening wraps in 32 bits: ylo 0x80000000 - 5 -> 0x7ffffffb (the point is below it), yhi 0x7fffffff + 5 -> negative, xlo 0x80000000 - 6, xhi 0x7ffffffa + 10 */
    for (e = 0; e < 4; e++) {
        for (v = 0; v < 2; v++) {                          /* a row, then the tail */
            setup_469057(0, 0, 0);
            rect_adj(v ? fx.obj[0] : fx.self, v ? TAIL57 : ROW57[0], ADJ57, 0, 0, -1);
            set32(v ? fx.obj[0] : fx.self, (v ? TAIL57 : ROW57[0])[e], e == 0 ? 0x80000000u : e == 1 ? 0x7fffffffu : e == 2 ? 0x80000000u : 0x7ffffffau);
            CK(run_469057(0, 0) == 0 && L.n == 0);
            /* ... and one step inside the wrap still holds the point where the 64-bit sum would not */
            set32(v ? fx.obj[0] : fx.self, (v ? TAIL57 : ROW57[0])[e], e == 0 ? 5u : e == 1 ? 0xfffffffbu : e == 2 ? 6u : 0xfffffff6u);
            CK(run_469057(0, 0) == 1 && L.n == 1);
        }
    }
    /* the point words are signed: x = -1 is below xlo = 0 widened (stored 6 -> effective 0) */
    setup_469057(0, 0, 0);
    rect_adj(fx.self, ROW57[0], ADJ57, 0, 0, -1);
    CK(run_469057(-1, 0) == 0);
    CK(run_469057(0, -1) == 0);
    CK(run_469057(0, 0) == 1);
    /* a NULL call hook: the hit still returns 1 */
    setup_469057(0, 0, 0);
    rect_adj(fx.self, ROW57[0], ADJ57, 0, 0, -1);
    fx.host.call = NULL;
    CK(run_469057(0, 0) == 1);
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x4b42d3 */

static const size_t ROW42[3][4] = {{0xed, 0xf5, 0xe9, 0xf1}, {0xfd, 0x105, 0xf9, 0x101}, {0x10d, 0x115, 0x109, 0x111}};
static const size_t TAIL42[4] = {0x8a2, 0x8aa, 0x89e, 0x8a6};

static void setup_4b42d3(int idx, int x, int y)
{
    int k;
    setup(idx);
    set32(fx.self, 0x76e, 1);
    set16(fx.self, 0x728, (uint16_t)idx);
    set32(fx.self, 0x750, 0);
    for (k = 0; k < 3; k++) rect_adj(fx.obj[0], ROW42[k], ADJ0, x + 100, y + 100, 0);
    rect_adj(fx.obj[0], TAIL42, ADJ0, x + 100, y + 100, 0);
}

static int run_4b42d3(int x, int y)
{
    return m4b42d3_hit_test(fx.self, (int16_t)x, (int16_t)y, RECT_VA, &fx.w, &fx.host);
}

/* the stores of every pass beyond the gate: the three words 0xffff, then the rectangle (rect[1], rect[3], rect[0], rect[2]); on a hit the point words */
static void exp_stores_4b42d3(int hit, int x, int y)
{
    set16(exp_self, 0x758, 0xffff);
    set16(exp_self, 0x75a, hit ? (uint16_t)x : 0xffff);
    set16(exp_self, 0x75c, hit ? (uint16_t)y : 0xffff);
    set32(exp_self, 0x762, 0x22222222u);
    set32(exp_self, 0x76a, 0x44444444u);
    set32(exp_self, 0x75e, 0x11111111u);
    set32(exp_self, 0x766, 0x33333333u);
}

static void test_m4b42d3_hit_test(void)
{
    static const int PTS[][2] = {{10, 20}, {0, 0}, {-1, -1}, {-32768, 32767}, {32767, -32768}};
    static const uint32_t W750_NONZERO[] = {1, 0xffff, 0x8000, 0x7fff, 0x80000001u, 0x10001u};
    static const uint32_t W750_ZERO[] = {0, 0x10000, 0xabcd0000u, 0xffff0000u};
    size_t p, q;
    int k, e, idx;
    for (p = 0; p < sizeof PTS / sizeof PTS[0]; p++) {
        int x = PTS[p][0], y = PTS[p][1];
        /* the gate dword: zero (everything else holds the point), non-zero in the high word only counts as set */
        setup_4b42d3(1, x, y);
        set32(fx.self, 0x76e, 0);
        for (k = 0; k < 3; k++) rect_adj(fx.obj[0], ROW42[k], ADJ0, x, y, -1);
        rect_adj(fx.obj[0], TAIL42, ADJ0, x, y, -1);
        expect_begin();
        CK(run_4b42d3(x, y) == 0);
        CK(L.n == 0);
        expect_end();
        setup_4b42d3(1, x, y);
        set32(fx.self, 0x76e, 0x01000000);
        expect_begin();
        CK(run_4b42d3(x, y) == 0);
        exp_stores_4b42d3(0, x, y);
        expect_end();
        CK(L.n == 1);
        ck_call(0, 0x4b3f98, (uintptr_t)fx.self, 0, 0);
        CK(get16(L.c[0].snap_self, 0x75a) == 0xffff && get32(L.c[0].snap_self, 0x762) == 0x22222222u && get32(L.c[0].snap_self, 0x75e) == 0x11111111u);   /* stored before the call */
        /* the point words are stored after the call: at the call they are still 0xffff */
        for (k = 0; k < 3; k++) {
            setup_4b42d3(2, x, y);
            rect_adj(fx.obj[0], ROW42[k], ADJ0, x, y, -1);
            rect_adj(fx.obj[0], TAIL42, ADJ0, x, y, -1);
            expect_begin();
            CK(run_4b42d3(x, y) == 1);
            exp_stores_4b42d3(1, x, y);
            expect_end();
            CK(L.n == 2);
            ck_call(0, 0x4b3f98, (uintptr_t)fx.self, 0, 0);
            ck_call(1, 0x4b450f, (uintptr_t)fx.self, 1, (uintptr_t)k);
            CK(get16(L.c[0].snap_self, 0x75a) == 0xffff && get16(L.c[1].snap_self, 0x75a) == (uint16_t)x && get16(L.c[1].snap_self, 0x75c) == (uint16_t)y);
            for (e = 0; e < 4; e++) {
                setup_4b42d3(2, x, y);
                rect_adj(fx.obj[0], ROW42[k], ADJ0, x, y, e);
                expect_begin();
                CK(run_4b42d3(x, y) == 0);
                CK(L.n == 1);
                exp_stores_4b42d3(0, x, y);
                expect_end();
            }
        }
        /* the tail: only with the word [+0x750] zero (its low word: movsx word) */
        for (idx = -1; idx <= 4; idx++) {
            setup_4b42d3(idx, x, y);
            rect_adj(fx.obj[0], TAIL42, ADJ0, x, y, -1);
            expect_begin();
            CK(run_4b42d3(x, y) == 1);
            exp_stores_4b42d3(0, x, y);
            expect_end();
            CK(L.n == 2);
            ck_call(1, 0x4b450f, (uintptr_t)fx.self, 1, 0x64);
        }
        for (e = 0; e < 4; e++) {
            setup_4b42d3(0, x, y);
            rect_adj(fx.obj[0], TAIL42, ADJ0, x, y, e);
            expect_begin();
            CK(run_4b42d3(x, y) == 0);
            CK(L.n == 1);
            exp_stores_4b42d3(0, x, y);
            expect_end();
        }
        for (q = 0; q < sizeof W750_NONZERO / sizeof W750_NONZERO[0]; q++) {
            setup_4b42d3(0, x, y);
            rect_adj(fx.obj[0], TAIL42, ADJ0, x, y, -1);
            set32(fx.self, 0x750, W750_NONZERO[q]);
            expect_begin();
            CK(run_4b42d3(x, y) == 0);
            CK(L.n == 1);
            exp_stores_4b42d3(0, x, y);
            expect_end();
        }
        for (q = 0; q < sizeof W750_ZERO / sizeof W750_ZERO[0]; q++) {
            setup_4b42d3(0, x, y);
            rect_adj(fx.obj[0], TAIL42, ADJ0, x, y, -1);
            set32(fx.self, 0x750, W750_ZERO[q]);
            CK(run_4b42d3(x, y) == 1 && L.n == 2);
        }
    }
    /* the first row that holds the point wins */
    setup_4b42d3(0, 5, 6);
    rect_adj(fx.obj[0], ROW42[1], ADJ0, 5, 6, -1);
    rect_adj(fx.obj[0], ROW42[2], ADJ0, 5, 6, -1);
    CK(run_4b42d3(5, 6) == 1 && L.n == 2);
    ck_call(1, 0x4b450f, (uintptr_t)fx.self, 1, 1);
    /* a NULL call hook */
    setup_4b42d3(0, 5, 6);
    rect_adj(fx.obj[0], TAIL42, ADJ0, 5, 6, -1);
    fx.host.call = NULL;
    CK(run_4b42d3(5, 6) == 1);
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x4897cd */

#define ROWB(r) (0x6ec + 0x26 * (size_t)(r))
static size_t row_off(int r, int field)       /* field 0 ylo, 1 yhi, 2 xlo, 3 xhi */
{
    static const size_t F[4] = {0x1a, 0x22, 0x16, 0x1e};
    return ROWB(r) + F[field];
}

static void row_rect(int k, int r, int x, int y, int miss_edge)
{
    size_t offs[4];
    int e;
    for (e = 0; e < 4; e++) offs[e] = row_off(r, e);
    rect_adj(fx.obj[k], offs, ADJ0, x, y, miss_edge);
}

/* object k: record index rec (state 1), flag non-zero, `rows` rows; row r holds the word w5bb50b and the word 1; every rectangle misses */
static void obj_setup(int k, int rec, int rows, int w5bb50b, int x, int y)
{
    int r;
    set32(fx.self, 0x2c + 4 * (size_t)k, OBJ_VA(k));
    set16(fx.obj[k], 0xab0, (uint16_t)rec);
    set32(fx.obj[k], 0xab2, 1);
    set16(fx.obj[k], 0xaa, (uint16_t)rows);
    set32(fx.tab, (size_t)(rec + 1) * REC + 0x4d, 1);
    for (r = 0; r < 4; r++) {
        set16(fx.obj[k], ROWB(r), (uint16_t)w5bb50b);
        set16(fx.obj[k], ROWB(r) + 4, 1);
        row_rect(k, r, x + 100, y + 100, 0);
    }
}

static void setup_4897cd(int count, int w5bb50b, int x, int y)
{
    setup(0);
    set32(fx.self, 0xcc, (uint32_t)count);
    fx.w.word_5bb50b = (int16_t)w5bb50b;
    fx.w.word_583a29 = -1;
    fx.w.value_5b44f0 = 0x11111111u;
    fx.w.value_5b44f4 = 0x22222222u;
    fx.w.value_5d0377 = 0x33333333u;
    fx.w.value_5d162d = 0x44444444u;
    fx.w.value_5d1631 = 0x55555555u;
    fx.w.value_5d1639 = 0x66666666u;
    fx.w.value_571ad3 = 0x77777777u;
    fx.w.value_5c39e5 = 0x88888888u;
    fx.w.value_5b44f8 = 0;
    obj_setup(0, 2, 3, w5bb50b, x, y);
    obj_setup(1, -1, 4, w5bb50b, x, y);
    obj_setup(2, 4, 2, w5bb50b, x, y);
}

static int run_4897cd(int x, int y)
{
    return m4897cd_hit_test(fx.self, (int16_t)x, (int16_t)y, &fx.w, &fx.host);
}

static int world_untouched(void)
{
    return fx.w.value_5b44f0 == 0x11111111u && fx.w.value_5b44f4 == 0x22222222u && fx.w.value_5d0377 == 0x33333333u && fx.w.value_5d162d == 0x44444444u &&
           fx.w.value_5d1631 == 0x55555555u && fx.w.value_5d1639 == 0x66666666u && fx.w.value_571ad3 == 0x77777777u && fx.w.value_5c39e5 == 0x88888888u;
}

/* the stores into the object on a pass that reached object k and row j (the object list address into [+0x1c] and [+0x20], the row address into [+0x24]) */
static void exp_self_stores(int k, int j)
{
    set32(exp_self, 0x1c, OBJ_VA(k));
    set32(exp_self, 0x20, OBJ_VA(k));
    if (j >= 0) set32(exp_self, 0x24, OBJ_VA(k) + (uint32_t)ROWB(j));
}

static void test_m4897cd_hit_test(void)
{
    static const int PTS[][2] = {{10, 20}, {0, 0}, {-1, -1}, {-32768, 32767}, {32767, -32768}};
    static const uint32_t BAD_STATES[] = {0, 2, 3, 0x101, 0x10001u, 0xffffffffu, 0x80000001u};
    static const int NOROWS[] = {0, -1, -32768};
    static const struct {
        int sel;
        uint32_t b44f0, d1631;
    } ANN[] = {{-1, 0, 0x5b161c}, {5, 0x2a, 0x5b1b5c}, {-2, 0x23, 0x5b1a7c}, {0x7fff, 0x8024, 0x6b1a9c}, {-32768, 0xffff8025u, 0x4b1abc}, {0, 0x25, 0x5b1abc}};
    static const int LAST_ROW[3] = {2, 3, 1};
    size_t p, q;
    int k, r, e, w, ret;
    for (p = 0; p < sizeof PTS / sizeof PTS[0]; p++) {
        int x = PTS[p][0], y = PTS[p][1];
        const int w5 = (int)p % 2 ? -32768 : 0x7fff;
        /* the gate: the count is zero; a count that is not positive (signed) never enters the loop even though every row would hit */
        setup_4897cd(0, w5, x, y);
        for (k = 0; k < 3; k++)
            for (r = 0; r < 4; r++) row_rect(k, r, x, y, -1);
        expect_begin();
        CK(run_4897cd(x, y) == 0);
        expect_end();
        CK(world_untouched());
        for (q = 0; q < 3; q++) {
            static const uint32_t NEG[3] = {0xffffffffu, 0x80000000u, 0xfffffffeu};
            setup_4897cd(0, w5, x, y);
            set32(fx.self, 0xcc, NEG[q]);
            for (k = 0; k < 3; k++)
                for (r = 0; r < 4; r++) row_rect(k, r, x, y, -1);
            expect_begin();
            CK(run_4897cd(x, y) == 0);
            expect_end();
            CK(world_untouched());
        }
        /* nothing holds the point: the stores of each visited object, return 0 */
        for (k = 1; k <= 3; k++) {
            setup_4897cd(k, w5, x, y);
            expect_begin();
            CK(run_4897cd(x, y) == 0);
            exp_self_stores(k - 1, LAST_ROW[k - 1]);       /* the row address of the last row visited (the objects have 3, 4 and 2 rows) */
            expect_end();
            CK(world_untouched());
        }
        /* the hit at (object k, row r), and its faults */
        for (k = 0; k < 3; k++) {
            static const int ROWS[3] = {3, 4, 2};
            static const int RECIDX[3] = {2, -1, 4};
            for (r = 0; r < ROWS[k]; r++) {
                setup_4897cd(3, w5, x, y);
                row_rect(k, r, x, y, -1);
                expect_begin();
                ret = run_4897cd(x, y);
                CK(ret == 1);
                exp_self_stores(k, r);
                expect_end();
                CK(fx.w.value_5b44f0 == 0 && fx.w.value_5b44f4 == 1 && fx.w.value_5d162d == 0x33333333u && fx.w.value_5d1631 == 0x5b161c && fx.w.value_5d1639 == 1);
                CK(fx.w.value_5c39e5 == (uint32_t)(int32_t)RECIDX[k] && fx.w.value_571ad3 == 0x77777777u);
                for (e = 0; e < 4; e++) {                       /* the row misses at one edge by one: no hit anywhere */
                    setup_4897cd(3, w5, x, y);
                    row_rect(k, r, x, y, e);
                    CK(run_4897cd(x, y) == 0);
                    CK(world_untouched());
                }
                setup_4897cd(3, w5, x, y);                      /* the word of the row differs from [0x5bb50b] */
                row_rect(k, r, x, y, -1);
                set16(fx.obj[k], ROWB(r), (uint16_t)(w5 + 1));
                CK(run_4897cd(x, y) == 0 && world_untouched());
                setup_4897cd(3, w5, x, y);                      /* the word at +4 is not 1 (the high word of the dword is junk and ignored when it is 1) */
                row_rect(k, r, x, y, -1);
                set16(fx.obj[k], ROWB(r) + 4, 0);
                CK(run_4897cd(x, y) == 0 && world_untouched());
                set16(fx.obj[k], ROWB(r) + 4, 2);
                CK(run_4897cd(x, y) == 0);
                set16(fx.obj[k], ROWB(r) + 4, 1);
                set16(fx.obj[k], ROWB(r) + 6, 0xffff);
                set16(fx.obj[k], ROWB(r) + 2, 0xffff);
                CK(run_4897cd(x, y) == 1);
                setup_4897cd(3, w5, x, y);                      /* the flag dword of the object is clear */
                row_rect(k, r, x, y, -1);
                set32(fx.obj[k], 0xab2, 0);
                CK(run_4897cd(x, y) == 0 && world_untouched());
                set32(fx.obj[k], 0xab2, 0x10000);               /* ... a flag in the high word only counts as set */
                CK(run_4897cd(x, y) == 1);
                for (w = 0; w < (int)(sizeof BAD_STATES / sizeof BAD_STATES[0]); w++) {   /* the record state is not 1 */
                    setup_4897cd(3, w5, x, y);
                    row_rect(k, r, x, y, -1);
                    set32(fx.tab, (size_t)(RECIDX[k] + 1) * REC + 0x4d, BAD_STATES[w]);
                    CK(run_4897cd(x, y) == 0 && world_untouched());
                }
                for (w = 0; w < 3; w++) {                       /* the row count word is not positive: the hit row is never visited */
                    setup_4897cd(3, w5, x, y);
                    row_rect(k, r, x, y, -1);
                    set16(fx.obj[k], 0xaa, (uint16_t)NOROWS[w]);
                    CK(run_4897cd(x, y) == 0 && world_untouched());
                }
                setup_4897cd(3, w5, x, y);                      /* the count word is r (the hit row is the first one not visited), then r + 1 */
                row_rect(k, r, x, y, -1);
                set16(fx.obj[k], 0xaa, (uint16_t)r);
                CK(run_4897cd(x, y) == 0);
                set16(fx.obj[k], 0xaa, (uint16_t)(r + 1));
                CK(run_4897cd(x, y) == 1);
            }
        }
    }
    /* the first hit wins: object 0 row 1 and object 1 row 0 both hold the point */
    setup_4897cd(3, 7, 5, 6);
    row_rect(0, 1, 5, 6, -1);
    row_rect(1, 0, 5, 6, -1);
    CK(run_4897cd(5, 6) == 1 && get32(fx.self, 0x1c) == OBJ_VA(0) && get32(fx.self, 0x24) == OBJ_VA(0) + (uint32_t)ROWB(1));
    /* an object before the hit that is skipped leaves its own address in [+0x1c] / [+0x20] only until the next object is taken */
    setup_4897cd(3, 7, 5, 6);
    set32(fx.obj[0], 0xab2, 0);
    row_rect(2, 1, 5, 6, -1);
    CK(run_4897cd(5, 6) == 1 && get32(fx.self, 0x1c) == OBJ_VA(2) && get32(fx.self, 0x20) == OBJ_VA(2));
    /* the announcement: the word [0x583a29] and the dword [0x5b44f8] (non-zero in the high word only is non-zero) */
    for (q = 0; q < sizeof ANN / sizeof ANN[0]; q++) {
        static const uint32_t F8[] = {0, 1, 0x10000, 0x80000000u};
        for (w = 0; w < 4; w++) {
            setup_4897cd(3, 7, 5, 6);
            row_rect(1, 0, 5, 6, -1);
            fx.w.word_583a29 = (int16_t)ANN[q].sel;
            fx.w.value_5b44f8 = F8[w];
            CK(run_4897cd(5, 6) == 1);
            if (F8[w] == 0) {
                CK(fx.w.value_5b44f0 == ANN[q].b44f0);
                CK(fx.w.value_5d162d == (ANN[q].sel == -1 ? 0x33333333u : 0x77777777u));
                CK(fx.w.value_5d1631 == ANN[q].d1631);
            } else {                                   /* [0x5b44f0] and [0x5d162d] stay; [0x5d1631] is computed from the unchanged [0x5b44f0] */
                CK(fx.w.value_5b44f0 == 0x11111111u && fx.w.value_5d162d == 0x44444444u);
                CK(fx.w.value_5d1631 == 0x227d383cu);
            }
            CK(fx.w.value_5b44f4 == 1 && fx.w.value_5d1639 == 1 && fx.w.value_5b44f8 == F8[w]);
            CK(fx.w.value_5c39e5 == 0xffffffffu);      /* the record index of object 1 is -1 */
            CK(fx.w.value_5d0377 == 0x33333333u && fx.w.value_571ad3 == 0x77777777u && fx.w.word_583a29 == (int16_t)ANN[q].sel);
        }
    }
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* a bounded random sweep over every port (for the sanitiser builds): arbitrary bytes in the objects, the table in range, host calls recorded */

static uint32_t g_seed = 0x2545f491u;
static uint32_t rnd(void)
{
    g_seed ^= g_seed << 13;
    g_seed ^= g_seed >> 17;
    g_seed ^= g_seed << 5;
    return g_seed;
}

static void test_sweep(void)
{
    int iter, k;
    for (iter = 0; iter < 400; iter++) {
        int idx = (int)(rnd() % 6) - 1;
        int x = (int)(rnd() % 400) - 200, y = (int)(rnd() % 400) - 200;
        size_t b;
        setup(idx);
        for (b = 0; b < sizeof fx.self; b++) fx.self[b] = (uint8_t)(rnd() >> 7);
        for (k = 0; k < 3; k++)
            for (b = 0; b < OBJ_SZ; b++) fx.obj[k][b] = (uint8_t)(rnd() % 5 == 0 ? rnd() >> 9 : 0);
        for (b = 0; b < sizeof fx.decoy; b++) fx.decoy[b] = (uint8_t)(rnd() >> 11);
        fx.w.value_583204 = rnd() % 9;
        fx.w.byte_5a161f = (uint8_t)(rnd() % 3);
        fx.w.word_5bb50b = (int16_t)(rnd() % 3);
        fx.w.word_583a29 = (int16_t)((int)(rnd() % 4) - 1);
        set16(fx.self, 0x7e, (uint16_t)idx);
        set16(fx.self, 0x728, (uint16_t)idx);
        set32(fx.self, 0xcc, rnd() % 4);
        for (k = 0; k < 3; k++) {
            set32(fx.self, 0x2c + 4 * (size_t)k, OBJ_VA(k));
            set16(fx.obj[k], 0xab0, (uint16_t)((int)(rnd() % 6) - 1));
            set16(fx.obj[k], 0xaa, (uint16_t)(rnd() % 5));
        }
        for (b = 0; b < 6; b++) set32(fx.tab, b * REC, rnd() % 2 ? OBJ_VA(0) : DECOY_VA);
        L.n = 0;
        m4d3073_session_tick(&fx.w, &fx.host);
        (void)m469057_hit_test(fx.self, (int16_t)x, (int16_t)y, &fx.w, &fx.host);
        (void)m4b42d3_hit_test(fx.self, (int16_t)x, (int16_t)y, RECT_VA, &fx.w, &fx.host);
        (void)m4897cd_hit_test(fx.self, (int16_t)x, (int16_t)y, &fx.w, &fx.host);
    }
    CK(1);
}

static const struct {
    const char *name;
    void (*fn)(void);
} CASES[] = {
    {"test_m4d3073_session_tick", test_m4d3073_session_tick},
    {"test_m469057_hit_test", test_m469057_hit_test},
    {"test_m4b42d3_hit_test", test_m4b42d3_hit_test},
    {"test_m4897cd_hit_test", test_m4897cd_hit_test},
    {"test_sweep_bounded", test_sweep},
};

int main(void)
{
    size_t i;
    int failures = 0;
    for (i = 0; i < sizeof CASES / sizeof CASES[0]; i++) {
        g_failed = 0;
        g_msg[0] = 0;
        CASES[i].fn();
        if (g_failed) {
            printf("FAIL %s: %s\n", CASES[i].name, g_msg);
            failures++;
        } else {
            printf("PASS %s\n", CASES[i].name);
        }
    }
    return failures;
}
