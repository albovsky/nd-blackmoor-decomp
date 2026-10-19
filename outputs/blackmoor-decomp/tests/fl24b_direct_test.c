/* FL-24 (batch b) direct tests of the handlers of GAME.EXE in src/original_methods_fl24b.c. Prints "PASS <name>" / "FAIL <name>: <msg>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the
 * disassembly of GAME.EXE, not from running the native code; tests/test_fl24b_differential.py additionally runs the original bytes on
 * generated fixtures.
 *
 * Every function is checked three ways: (1) a guard matrix (each guard of the chain failing in turn leaves the object, the record table
 * and the call log untouched), (2) each arm with the whole object, the record table and the globals compared with a hand-edited copy and
 * the ordered host calls with arguments and the state at the call, (3) the boundaries of signed words and dwords. A bounded random
 * sweep at the end only requires that nothing reads or writes outside the buffers (run it under ASan/UBSan). */
#include "../src/original_methods_fl24b.h"

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

#define REC 0x8d
#define TAB_SZ (REC * 6)          /* records -1 .. 4 */
#define OBJ_VA 0x20010000u        /* the object of the target record */
#define DECOY_VA 0x20020000u      /* the object of every other record */
#define OBJ2_VA 0x20030000u       /* a second object (an address kept in the object under test) */
#define BIG 0x1800

static void set32(uint8_t *o, size_t off, uint32_t v) { memcpy(o + off, &v, 4); }
static void set16(uint8_t *o, size_t off, uint16_t v) { memcpy(o + off, &v, 2); }
static uint16_t get16x(const uint8_t *o, size_t off)
{
    uint16_t v;
    memcpy(&v, o + off, 2);
    return v;
}
static uint32_t get32(const uint8_t *o, size_t off)
{
    uint32_t v;
    memcpy(&v, o + off, 4);
    return v;
}

static struct {
    uint8_t self[BIG];
    uint8_t tab[TAB_SZ];
    uint8_t obj[0x1000], decoy[0x1000], obj2[0x1000];
    Fl24bWorld w;
    Fl18Host host;
} fx;
static uint8_t xs[BIG], xt[TAB_SZ], xo[0x1000];     /* the expected object, record table and target object */
static uint8_t consts[8][16];                        /* nine-byte constants (the tables of the original) */

static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[4];
        uint8_t snap_self[BIG], snap_obj[0x100];
    } c[24];
} L;
static uint32_t g_tick;
static struct { uint32_t callee, value; } g_ret_by[4];

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int i, k = L.n;
    (void)ctx;
    L.c[k].callee = callee;
    L.c[k].this_ptr = this_ptr;
    L.c[k].nargs = nargs;
    for (i = 0; i < nargs && i < 4; i++) L.c[k].a[i] = args[i];
    memcpy(L.c[k].snap_self, fx.self, BIG);
    memcpy(L.c[k].snap_obj, fx.obj, 0x100);
    L.n++;
    for (i = 0; i < 4; i++)
        if (g_ret_by[i].callee == callee) return g_ret_by[i].value;
    return 0;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (a >= OBJ_VA && a < OBJ_VA + 0x1000) return fx.obj + (a - OBJ_VA);
    if (a >= DECOY_VA && a < DECOY_VA + 0x1000) return fx.decoy + (a - DECOY_VA);
    if (a >= OBJ2_VA && a < OBJ2_VA + 0x1000) return fx.obj2 + (a - OBJ2_VA);
    return NULL;
}

static uint32_t host_tick(void *ctx)
{
    (void)ctx;
    L.c[L.n].callee = 0x52a23c;
    L.n++;
    return g_tick;
}

/* the passing base: every byte of the object 0xA5, the record table with the target record idx in state 1 and the others in state 0 */
static void base(uint32_t sel, int idx, size_t idx_off)
{
    int i;
    memset(fx.self, 0xA5, sizeof fx.self);
    memset(fx.obj, 0x5c, sizeof fx.obj);
    memset(fx.decoy, 0x11, sizeof fx.decoy);
    memset(fx.obj2, 0x22, sizeof fx.obj2);
    memset(fx.tab, 0xCC, sizeof fx.tab);
    for (i = -1; i <= 4; i++) {
        set32(fx.tab, (size_t)(i + 1) * REC, i == idx ? OBJ_VA : DECOY_VA);
        set32(fx.tab, (size_t)(i + 1) * REC + 0x4d, i == idx ? 1u : 0u);
    }
    memset(&fx.w, 0, sizeof fx.w);
    fx.w.records_5bb5e5 = fx.tab + REC;
    fx.w.value_5c39e5 = sel;
    memset(&fx.host, 0, sizeof fx.host);
    fx.host.call = host_call;
    fx.host.resolve = host_resolve;
    fx.host.tick = host_tick;
    set16(fx.self, idx_off, (uint16_t)(int16_t)idx);
    memset(consts, 0, sizeof consts);
    g_tick = 1000;
    memset(g_ret_by, 0, sizeof g_ret_by);
    L.n = 0;
}

static void begin(void)
{
    memcpy(xs, fx.self, BIG);
    memcpy(xt, fx.tab, TAB_SZ);
    memcpy(xo, fx.obj, sizeof xo);
}
#define X32(o, v) set32(xs, (o), (v))
#define X16(o, v) set16(xs, (o), (v))
#define X8(o, v) (xs[(o)] = (v))
static void check_mem(void)
{
    CK(memcmp(fx.self, xs, BIG) == 0);
    CK(memcmp(fx.tab, xt, TAB_SZ) == 0);
    CK(memcmp(fx.obj, xo, sizeof xo) == 0);
}
static void check_call(int k, uint32_t callee, uintptr_t this_ptr, int nargs)
{
    CK(k < L.n);
    if (k >= L.n) return;
    CK(L.c[k].callee == callee);
    CK(L.c[k].this_ptr == this_ptr);
    CK(L.c[k].nargs == nargs);
}
static void check_arg(int k, int i, uintptr_t v, uintptr_t mask)
{
    if (k < L.n) CK((L.c[k].a[i] & mask) == (v & mask));
}

/* ---- FL24B-TESTS-BEGIN ----------------------------------------------------------------------------------------------------------- */

/* 0x4dad60: five dwords and two global bytes cleared, the import 0x52a498 called with 0x17, the result stored at [+0x14] and the pair
 * at [+0x20], [+0x24] chosen by it (non-zero: 2, 1; zero: 1, 2); then [+0x18] and [+0x1c] cleared. The result is a whole dword. */
static int test_m4dad60_init_swap_buttons(void)
{
    static const uint32_t rets[] = {0, 1, 0x100, 0x10000, 0x80000000u, 0xffffffffu};
    int i;
    g_failed = 0;
    g_msg[0] = 0;
    for (i = 0; i < 6; i++) {
        base(0, 2, 0x1e);
        fx.w.value_58321d = 0x77;
        fx.w.value_58321e = 0x88;
        g_ret_by[0].callee = 0x52a498;
        g_ret_by[0].value = rets[i];
        begin();
        X32(0xc, 0);
        X32(0x10, 0);
        X32(0, 0);
        X32(4, 0);
        X32(8, 0);
        X32(0x14, rets[i]);
        X32(0x20, rets[i] != 0 ? 2 : 1);
        X32(0x24, rets[i] != 0 ? 1 : 2);
        X32(0x18, 0);
        X32(0x1c, 0);
        m4dad60_init_swap_buttons(fx.self, &fx.w, &fx.host);
        check_mem();
        CK(fx.w.value_58321d == 0 && fx.w.value_58321e == 0);
        CK(L.n == 1);
        check_call(0, 0x52a498, 0, 1);
        check_arg(0, 0, 0x17, 0xffffffffu);
        /* at the call [+0xc], [+8] are already cleared; [+0x14], [+0x20], [+0x18] are not yet stored */
        CK(get32(L.c[0].snap_self, 0xc) == 0 && get32(L.c[0].snap_self, 8) == 0 && get32(L.c[0].snap_self, 0x14) == 0xA5A5A5A5u);
        CK(get32(L.c[0].snap_self, 0x20) == 0xA5A5A5A5u && get32(L.c[0].snap_self, 0x18) == 0xA5A5A5A5u);
    }
    if (g_failed) printf("FAIL test_m4dad60_init_swap_buttons: %s\n", g_msg);
    else printf("PASS test_m4dad60_init_swap_buttons\n");
    return g_failed;
}

/* 0x466073: gates [+0x49] != 0 (dword), byte [+0x4e] == 0, the state of the record of the signed word [+0x1e] == 1, then the selector. */
static void setup_466073(uint32_t sel, int idx, int sw)
{
    base(sel, idx, 0x1e);
    set32(fx.self, 0x49, 0x01000000u);
    fx.self[0x4e] = 0;
    set16(fx.self, 0x28, (uint16_t)sw);
    fx.w.value_5bb1ca = 0;
    fx.w.bytes_54b54c = consts[0];
    memcpy(consts[0], "ABCDEFGHI", 9);
}

/* the common tail: with the flag set, a copy (49 bytes of obj at `off`) whose first nine bytes differ from the constant at byte `diff`
 * (-1: equal) announces the word at copy+0x21 */
static void tail_466073(int sw, size_t off, int idx, int flag, int diff)
{
    setup_466073(0x27d2, idx, sw);
    set16(fx.self, 0x2c, 1);
    fx.self[0x3e] = 0;
    fx.w.value_5bb1ca = flag ? 0x100u : 0;
    memcpy(fx.obj + off, "ABCDEFGHI", 9);
    if (diff >= 0) fx.obj[off + (size_t)diff] ^= 0x40;
    fx.obj[off + 0x21] = 0x34;
    fx.obj[off + 0x22] = 0x92;
    fx.obj[off + 0x23] = 0xee;
    begin();
    if (sw == 1) { X8(0x3e, 1); X8(0x42, 1); }
    if (sw == 4) { X16(0x2c, 2); }
    if (sw == 2) { X16(0x2a, (uint16_t)(get16x(fx.self, 0x2a) - 1)); X8(0x3f, 1); }
    if (sw == 3) { X16(0x2a, (uint16_t)(get16x(fx.self, 0x2a) + 1)); X8(0x40, 1); }
    m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
    check_mem();
    if (flag && diff >= 0) {
        CK(L.n == 1);
        check_call(0, 0x4fb2e3, 0x5c3a67, 1);
        check_arg(0, 0, 0x9234, 0xffff);       /* the word at copy+0x21, not the byte after it */
    } else {
        CK(L.n == 0);
    }
}

static int test_m466073_click_27d2_27d3(void)
{
    static const int idxs[2] = {2, -1};
    static const int sws[] = {1, 2, 3, 4};
    static const uint32_t sels[] = {0x27d3, 0x27d2, 0x2711, 0};
    int ii, k, v, s, d, f;
    g_failed = 0;
    g_msg[0] = 0;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        /* the guard matrix: every guard failing in turn, every selector, no effect */
        for (s = 0; s < 4; s++)
            for (k = 0; k < 3; k++)
                for (v = 0; v < 6; v++) {
                    setup_466073(sels[s], idx, 1);
                    if (k == 0) set32(fx.self, 0x49, 0);
                    if (k == 1) fx.self[0x4e] = (uint8_t[]){1, 0x80, 0xff, 0x7f, 2, 0x55}[v];
                    if (k == 2) {
                        int i;
                        for (i = -1; i <= 4; i++)
                            set32(fx.tab, (size_t)(i + 1) * REC + 0x4d, i == idx ? (uint32_t[]){0, 2, 3, 0xffffffffu, 0x101, 0x10001}[v] : 1u);
                    }
                    fx.w.value_5bb1ca = 1;
                    begin();
                    m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
                    check_mem();
                    CK(L.n == 0);
                }
        /* a high-byte only [+0x49] (0x01000000) passes; an unrelated selector with every guard passing does nothing */
        setup_466073(0x2711, idx, 1);
        fx.w.value_5bb1ca = 1;
        begin();
        m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
        check_mem();
        CK(L.n == 0);
        /* 0x27d3: byte [+0x4d] = 1 and the state of the record 2 */
        setup_466073(0x27d3, idx, 1);
        fx.w.value_5bb1ca = 1;
        begin();
        X8(0x4d, 1);
        set32(xt, (size_t)(idx + 1) * REC + 0x4d, 2);
        m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
        check_mem();
        CK(L.n == 0);
        /* 0x27d2: out-of-range words fall to the tail with the local not written (nothing changes; flag clear: no call) */
        for (v = 0; v < 6; v++) {
            setup_466073(0x27d2, idx, (int[]){0, 5, -1, -32768, 0x7fff, 0x100}[v]);
            begin();
            m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
            check_mem();
            CK(L.n == 0);
        }
        /* the four arms, the flag clear and set, the nine-byte compare at every byte position and equal */
        for (s = 0; s < 4; s++) {
            size_t off = sws[s] == 1 ? 0x43e : sws[s] == 4 ? 0x46f : 0x40d;
            for (f = 0; f < 2; f++)
                for (d = -1; d < 9; d++) tail_466073(sws[s], off, idx, f, d);
        }
        /* word 1 toggles the byte [+0x3e] both ways; word 4 counts [+0x2c] up to 3 and then wraps with [+0x41] set */
        for (v = 0; v < 3; v++) {
            setup_466073(0x27d2, idx, 1);
            fx.self[0x3e] = (uint8_t[]){0, 1, 0x80}[v];
            begin();
            X8(0x3e, v == 0 ? 1 : 0);
            X8(0x42, 1);
            m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
            check_mem();
        }
        for (v = 0; v < 7; v++) {
            int16_t w2c = (int16_t[]){0, 2, 3, 4, -1, -32768, 0x7fff}[v];
            setup_466073(0x27d2, idx, 4);
            set16(fx.self, 0x2c, (uint16_t)w2c);
            begin();
            if (w2c < 3) X16(0x2c, (uint16_t)(w2c + 1));
            else { X8(0x41, 1); X16(0x2c, 0); }
            m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
            check_mem();
        }
        /* words 2 and 3 wrap [+0x2a] at the word boundaries */
        for (v = 0; v < 4; v++) {
            uint16_t w2a = (uint16_t[]){0, 0xffff, 0x8000, 0x7fff}[v];
            setup_466073(0x27d2, idx, 2);
            set16(fx.self, 0x2a, w2a);
            begin();
            X16(0x2a, (uint16_t)(w2a - 1));
            X8(0x3f, 1);
            m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
            check_mem();
            setup_466073(0x27d2, idx, 3);
            set16(fx.self, 0x2a, w2a);
            begin();
            X16(0x2a, (uint16_t)(w2a + 1));
            X8(0x40, 1);
            m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
            check_mem();
        }
    }
    /* the state of the call: at the call the object has all its stores done */
    setup_466073(0x27d2, 2, 4);
    fx.w.value_5bb1ca = 1;
    set16(fx.self, 0x2c, 9);
    memset(fx.obj + 0x46f, 'z', 9);
    m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
    CK(L.n == 1 && L.c[0].snap_self[0x41] == 1 && L.c[0].snap_self[0x2c] == 0 && L.c[0].snap_self[0x2d] == 0);
    if (g_failed) printf("FAIL test_m466073_click_27d2_27d3: %s\n", g_msg);
    else printf("PASS test_m466073_click_27d2_27d3\n");
    return g_failed;
}

/* 0x467740: (x, y) words against the outer rectangle (x lo +0x3f8, y lo +0x3fc, x hi +0x400, y hi +0x404 of the object of the record of
 * the word [+8]) and the 17 hotspots (+0x21 x lo, +0x25 y lo, +0x29 x hi, +0x2d y hi, stride 16); signed dwords, inclusive bounds. */
static void rect_outer(int32_t xlo, int32_t ylo, int32_t xhi, int32_t yhi)
{
    set32(fx.obj, 0x3f8, (uint32_t)xlo);
    set32(fx.obj, 0x3fc, (uint32_t)ylo);
    set32(fx.obj, 0x400, (uint32_t)xhi);
    set32(fx.obj, 0x404, (uint32_t)yhi);
}
static void rect_hot(int i, int32_t xlo, int32_t ylo, int32_t xhi, int32_t yhi)
{
    set32(fx.obj, (size_t)i * 16 + 0x21, (uint32_t)xlo);
    set32(fx.obj, (size_t)i * 16 + 0x25, (uint32_t)ylo);
    set32(fx.obj, (size_t)i * 16 + 0x29, (uint32_t)xhi);
    set32(fx.obj, (size_t)i * 16 + 0x2d, (uint32_t)yhi);
}
static void setup_467740(int idx)
{
    int i;
    base(0x2711, idx, 8);
    set32(fx.self, 0x1ae, 0x00010000u);
    fx.w.value_5d0377 = 0xabcdef01u;
    fx.w.value_5d162d = 0x11111111u;
    fx.w.value_5d1631 = 0x22222222u;
    fx.w.value_5d1639 = 0x33333333u;
    fx.w.value_5b44f0 = 0x44444444u;
    fx.w.value_5b44f4 = 0x55555555u;
    rect_outer(1000, 1000, 2000, 2000);
    for (i = 0; i < 0x11; i++) rect_hot(i, 1000, 1000, 1001, 1001);   /* (x, y) = (5, 5) misses all */
}
static void expect_hit_467740(int idx, uint32_t a, uint32_t event)
{
    CK(fx.w.value_5b44f0 == a && fx.w.value_5b44f4 == 1 && fx.w.value_5d162d == 0xabcdef01u && fx.w.value_5d1639 == 1);
    CK(fx.w.value_5d1631 == (a << 5) + 16 + 0x5b160c);
    CK(fx.w.value_5c39e5 == event);
    (void)idx;
}
static void expect_miss_467740(void)
{
    CK(fx.w.value_5b44f0 == 0x44444444u && fx.w.value_5b44f4 == 0x55555555u && fx.w.value_5d162d == 0x11111111u);
    CK(fx.w.value_5d1631 == 0x22222222u && fx.w.value_5d1639 == 0x33333333u && fx.w.value_5c39e5 == 0x2711);
}

static int test_m467740_hit_test(void)
{
    static const int idxs[2] = {2, -1};
    int ii, k, i;
    int32_t r;
    g_failed = 0;
    g_msg[0] = 0;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        /* [+0x1aa] is stored before the zero test of [+0x1ae]; zero -> 0, nothing else */
        setup_467740(idx);
        set32(fx.self, 0x1ae, 0);
        rect_outer(0, 0, 100, 100);
        begin();
        X32(0x1aa, OBJ_VA);
        r = m467740_hit_test(fx.self, 5, 5, &fx.w, &fx.host);
        CK(r == 0);
        check_mem();
        expect_miss_467740();
        CK(L.n == 0);
        /* the outer hit: all four edges inclusive, with the arguments as words (upper halves would be junk in the original's stack) */
        for (k = 0; k < 6; k++) {
            int16_t x = (int16_t[]){5, 5, 5, 5, -5, -32768}[k], y = (int16_t[]){5, 5, 5, 5, -5, 32767}[k];
            int32_t xlo = (int32_t[]){5, 0, 5, 0, -10, -32768}[k], xhi = (int32_t[]){5, 5, 9, 5, -5, -32768}[k];
            int32_t ylo = (int32_t[]){5, 5, 0, 5, -10, 32767}[k], yhi = (int32_t[]){5, 9, 5, 5, -5, 0x7fffffff}[k];
            setup_467740(idx);
            rect_outer(xlo, ylo, xhi, yhi);
            begin();
            X32(0x1aa, OBJ_VA);
            r = m467740_hit_test(fx.self, x, y, &fx.w, &fx.host);
            CK(r == 1);
            check_mem();
            expect_hit_467740(idx, 9, 0x27ac);
            CK(L.n == 0);
        }
        /* the outer rectangle fails at each of its four comparisons (one short of each bound) */
        for (k = 0; k < 4; k++) {
            setup_467740(idx);
            rect_outer(k == 2 ? 6 : 5, k == 0 ? 6 : 5, 5, k == 1 ? 4 : 5);   /* x lo, y lo, x hi, y hi */
            if (k == 3) rect_outer(5, 5, 4, 5);
            if (k == 2) rect_outer(6, 5, 5, 5);
            if (k == 0) rect_outer(5, 6, 5, 5);
            if (k == 1) rect_outer(5, 5, 5, 4);
            begin();
            X32(0x1aa, OBJ_VA);
            r = m467740_hit_test(fx.self, 5, 5, &fx.w, &fx.host);
            CK(r == 0);
            check_mem();
            expect_miss_467740();
            CK(L.n == 0);
        }
        /* hotspots: one that fails each of its four comparisons by one, then a hit at index 16 whose callee answers 0 */
        for (k = 0; k < 4; k++) {
            setup_467740(idx);
            rect_outer(1000, 1000, 2000, 2000);
            for (i = 0; i < 0x11; i++) rect_hot(i, 5, 5, 5, 5);
            if (k == 0) rect_hot(0, 5, 6, 5, 5);      /* y low */
            if (k == 1) rect_hot(0, 5, 5, 5, 4);      /* y high */
            if (k == 2) rect_hot(0, 6, 5, 5, 5);      /* x low */
            if (k == 3) rect_hot(0, 5, 5, 4, 5);      /* x high */
            for (i = 1; i < 0x11; i++) rect_hot(i, 6, 6, 6, 6);
            rect_hot(16, -0x80000000, -0x80000000, 0x7fffffff, 0x7fffffff);
            begin();
            X32(0x1aa, OBJ_VA);
            X16(0xa, 16);
            r = m467740_hit_test(fx.self, 5, 5, &fx.w, &fx.host);
            CK(r == 1);
            check_mem();
            expect_hit_467740(idx, 0, 0x27ab);
            CK(L.n == 1);
            check_call(0, 0x467b9e, (uintptr_t)fx.self, 1);
            check_arg(0, 0, 16, 0xffffffffu);
            CK(L.c[0].snap_self[0x1aa] == (OBJ_VA & 0xff) && get32(L.c[0].snap_self, 0xa) == 0xA5A5A5A5u);   /* word [+0xa] not yet stored */
        }
        /* two hits: index 3 answers non-zero (skipped), index 5 answers 0 (accepted); index 7 would hit but is not reached */
        setup_467740(idx);
        rect_hot(3, 0, 0, 9, 9);
        rect_hot(5, 5, 5, 5, 5);
        rect_hot(7, 0, 0, 9, 9);
        g_ret_by[0].callee = 0x467b9e;
        g_ret_by[0].value = 0;
        {
            /* the host answers per callee, not per call: use two runs. First run answers non-zero for everything: all hits are tried */
            g_ret_by[0].value = 0x100;
            begin();
            X32(0x1aa, OBJ_VA);
            r = m467740_hit_test(fx.self, 5, 5, &fx.w, &fx.host);
            CK(r == 0);
            check_mem();
            expect_miss_467740();
            CK(L.n == 3);
            check_call(0, 0x467b9e, (uintptr_t)fx.self, 1);
            check_arg(0, 0, 3, 0xffffffffu);
            check_arg(1, 0, 5, 0xffffffffu);
            check_arg(2, 0, 7, 0xffffffffu);
        }
        /* signed words: x = -1 and y = 0x8000 (-32768) against signed bounds */
        setup_467740(idx);
        rect_outer(-2, -32768, -1, -32768);
        begin();
        X32(0x1aa, OBJ_VA);
        r = m467740_hit_test(fx.self, (int16_t)0xffff, (int16_t)0x8000, &fx.w, &fx.host);
        CK(r == 1);
        check_mem();
        expect_hit_467740(idx, 9, 0x27ac);
    }
    if (g_failed) printf("FAIL test_m467740_hit_test: %s\n", g_msg);
    else printf("PASS test_m467740_hit_test\n");
    return g_failed;
}

/* 0x4b7563: gates byte [+0x35] != 0, byte [+0x3b] == 0, dword [+0x25] == 0, record state (word [+0x21]); the arms 0x27bf / 0x27c0 step the
 * counter word ([+0x31] / [+0x33]) by the flag byte (+0x25 / +0x26) of the record object and its count word (+0x21 / +0x23). */
static void setup_4b7563(uint32_t sel, int idx)
{
    base(sel, idx, 0x21);
    fx.self[0x35] = 0x80;
    fx.self[0x3b] = 0;
    set32(fx.self, 0x25, 0);
    fx.w.value_5bb1ca = 0;
    fx.w.bytes_551c54 = consts[0];
    fx.w.bytes_551c60 = consts[1];
    memcpy(consts[0], "ABCDEFGHI", 9);
    memcpy(consts[1], "JKLMNOPQR", 9);
}

static int test_m4b7563_click_27bf_27c1(void)
{
    static const int idxs[2] = {2, -1};
    static const uint32_t sels[] = {0x27bf, 0x27c0, 0x27c1, 0x2711};
    static const struct { uint32_t sel; size_t counter, flag, count, nine, arg; const char *k; } A[2] = {
        {0x27bf, 0x31, 0x25, 0x21, 0x2ef, 0x310, "ABCDEFGHI"}, {0x27c0, 0x33, 0x26, 0x23, 0x320, 0x341, "JKLMNOPQR"}};
    static const int16_t counters[] = {0, 1, 2, 3, 4, -1, -32768, 32767};
    static const int16_t counts[] = {0, 1, 2, 3, 4, 5, -1, -32768, 32767};
    int ii, k, v, s, a, c, n, flag, d;
    g_failed = 0;
    g_msg[0] = 0;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        for (s = 0; s < 4; s++)
            for (k = 0; k < 4; k++)
                for (v = 0; v < 6; v++) {
                    setup_4b7563(sels[s], idx);
                    if (k == 0) fx.self[0x35] = 0;
                    if (k == 1) fx.self[0x3b] = (uint8_t[]){1, 0x80, 0xff, 0x7f, 2, 0x55}[v];
                    if (k == 2) set32(fx.self, 0x25, (uint32_t[]){1, 0x100, 0x10000, 0x01000000u, 0x80000000u, 3}[v]);
                    if (k == 3) {
                        int i;
                        for (i = -1; i <= 4; i++)
                            set32(fx.tab, (size_t)(i + 1) * REC + 0x4d, i == idx ? (uint32_t[]){0, 2, 3, 0xffffffffu, 0x101, 0x10001}[v] : 1u);
                    }
                    fx.w.value_5bb1ca = 1;
                    begin();
                    m4b7563_click_27bf_27c1(fx.self, &fx.w, &fx.host);
                    check_mem();
                    CK(L.n == 0);
                }
        /* neighbours of the byte gates: bytes next to [+0x35] and [+0x3b] do not matter */
        setup_4b7563(0x2711, idx);
        fx.self[0x36] = 0;
        fx.self[0x3c] = 0xff;
        begin();
        m4b7563_click_27bf_27c1(fx.self, &fx.w, &fx.host);
        check_mem();
        /* 0x27c1 and an unrelated selector */
        setup_4b7563(0x27c1, idx);
        begin();
        X8(0x36, 1);
        set32(xt, (size_t)(idx + 1) * REC + 0x4d, 2);
        m4b7563_click_27bf_27c1(fx.self, &fx.w, &fx.host);
        check_mem();
        CK(L.n == 0);
        /* the two counter arms */
        for (a = 0; a < 2; a++)
            for (flag = 0; flag < 3; flag++)         /* 0: record flag byte 0, 1: 1, 2: 0x80 */
                for (c = 0; c < 8; c++)
                    for (n = 0; n < 9; n++) {
                        int32_t cnt = counts[n], cur = counters[c], expected;
                        setup_4b7563(A[a].sel, idx);
                        fx.obj[A[a].flag] = (uint8_t[]){0, 1, 0x80}[flag];
                        set16(fx.obj, A[a].count, (uint16_t)cnt);
                        set16(fx.self, A[a].counter, (uint16_t)cur);
                        begin();
                        if (flag != 0) expected = cur > 0 ? cur - 1 : cnt - 1;
                        else expected = cur < cnt - 1 ? cur + 1 : 0;
                        X16(A[a].counter, (uint16_t)expected);
                        X32(0x25, 2);
                        m4b7563_click_27bf_27c1(fx.self, &fx.w, &fx.host);
                        check_mem();
                        CK(L.n == 0);
                    }
        /* spot values: 0 > count - 1 = -32769 stays 0 with the flag clear; with the flag set and the counter 0, count -32768 wraps to 0x7fff */
        setup_4b7563(0x27bf, idx);
        fx.obj[0x25] = 0;
        set16(fx.obj, 0x21, 0x8000);
        set16(fx.self, 0x31, 0xffff);
        begin();
        X16(0x31, 0);
        X32(0x25, 2);
        m4b7563_click_27bf_27c1(fx.self, &fx.w, &fx.host);
        check_mem();
        setup_4b7563(0x27bf, idx);
        fx.obj[0x25] = 1;
        set16(fx.obj, 0x21, 0x8000);
        set16(fx.self, 0x31, 0);
        begin();
        X16(0x31, 0x7fff);
        X32(0x25, 2);
        m4b7563_click_27bf_27c1(fx.self, &fx.w, &fx.host);
        check_mem();
        /* the announcement: flag set, the nine bytes differing at each position or equal; the word of the record object is the argument,
         * announced after the counter and before [+0x25] is set */
        for (a = 0; a < 2; a++)
            for (d = -1; d < 10; d++) {
                setup_4b7563(A[a].sel, idx);
                fx.w.value_5bb1ca = 0x100;
                fx.obj[A[a].flag] = 1;
                set16(fx.obj, A[a].count, 5);
                set16(fx.self, A[a].counter, 3);
                memcpy(fx.obj + A[a].nine, A[a].k, 9);
                fx.obj[A[a].nine + 9] = 0x5c;
                if (d >= 0) fx.obj[A[a].nine + (size_t)d] ^= 0x40;
                fx.obj[A[a].arg] = 0x21;
                fx.obj[A[a].arg + 1] = 0x43;
                fx.obj[A[a].arg + 2] = 0x65;
                begin();
                X16(A[a].counter, 2);
                X32(0x25, 2);
                m4b7563_click_27bf_27c1(fx.self, &fx.w, &fx.host);
                check_mem();
                if (d >= 0 && d < 9) {
                    CK(L.n == 1);
                    check_call(0, 0x4fb2e3, 0x5c3a67, 1);
                    check_arg(0, 0, 0x4321, 0xffff);
                    CK(get32(L.c[0].snap_self, 0x25) == 0 && L.c[0].snap_self[A[a].counter] == 2);
                } else {
                    CK(L.n == 0);
                }
                /* the flag clear: no compare at all */
                fx.w.value_5bb1ca = 0;
                L.n = 0;
                fx.w.bytes_551c54 = consts[2];
                fx.w.bytes_551c60 = consts[2];
                set16(fx.self, A[a].counter, 3);
                set32(fx.self, 0x25, 0);
                m4b7563_click_27bf_27c1(fx.self, &fx.w, &fx.host);
                CK(L.n == 0);
            }
    }
    if (g_failed) printf("FAIL test_m4b7563_click_27bf_27c1: %s\n", g_msg);
    else printf("PASS test_m4b7563_click_27bf_27c1\n");
    return g_failed;
}

/* 0x459e49: gates byte [+0xd6] != 0, byte [+0xe1] == 0, dword [+0xdb] == 0, record state of the word [+0x1c]; event 0x2742. */
static void setup_459e49(int idx, int arm_a)
{
    base(0x2742, idx, 0x1c);
    fx.self[0xd6] = 0x80;
    fx.self[0xe1] = 0;
    set32(fx.self, 0xdb, 0);
    set16(fx.self, 0xcc, 0x40);
    set16(fx.self, 0xdf, 1);
    fx.w.value_5bb1ca = 0;
    fx.w.value_583a29 = 0x1234;
    set16(fx.obj, 0x217, arm_a ? 0x00ff : 0x4321);
    fx.w.bytes_54a7c4 = consts[0];
    fx.w.bytes_54a7d0 = consts[1];
    memcpy(consts[0], "ABCDEFGHI", 9);
    memcpy(consts[1], "JKLMNOPQR", 9);
}

static int test_m459e49_click_2742(void)
{
    static const int idxs[2] = {2, -1};
    static const int16_t cnts[] = {-3, 0, 1, 2, 3, 4, 5, 0x7fff, -1};
    int ii, k, v, s, c, d, r, a;
    g_failed = 0;
    g_msg[0] = 0;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        for (s = 0; s < 2; s++)
            for (k = 0; k < 4; k++)
                for (v = 0; v < 6; v++) {
                    setup_459e49(idx, 1);
                    if (s) fx.w.value_5c39e5 = 0x2741;
                    if (k == 0) fx.self[0xd6] = 0;
                    if (k == 1) fx.self[0xe1] = (uint8_t[]){1, 0x80, 0xff, 0x7f, 2, 0x55}[v];
                    if (k == 2) set32(fx.self, 0xdb, (uint32_t[]){1, 0x100, 0x10000, 0x01000000u, 0x80000000u, 3}[v]);
                    if (k == 3) {
                        int i;
                        for (i = -1; i <= 4; i++)
                            set32(fx.tab, (size_t)(i + 1) * REC + 0x4d, i == idx ? (uint32_t[]){0, 2, 3, 0xffffffffu, 0x101, 0x10001}[v] : 1u);
                    }
                    fx.w.value_5bb1ca = 1;
                    begin();
                    m459e49_click_2742(fx.self, &fx.w, &fx.host);
                    check_mem();
                    CK(L.n == 0);
                }
        /* the first arm: t == 0xff (any global), or t == the global (word compare, so 0x1234 vs 0x11234 is not equal) */
        for (a = 0; a < 3; a++)
            for (c = 0; c < 9; c++) {
                int16_t cnt = cnts[c];
                int32_t after;
                setup_459e49(idx, a == 0);
                if (a == 1) set16(fx.obj, 0x217, 0x1234);
                if (a == 2) set16(fx.obj, 0x217, 0x8000), fx.w.value_583a29 = (int16_t)0x8000;
                set16(fx.self, 0xdf, (uint16_t)cnt);
                set16(fx.self, 0xcc, 0x30 + (uint16_t)c);
                begin();
                X8(0x30 + c + 0x1e, 1);
                if (cnt <= 3) X16((size_t)(cnt * 2 + 0xce), (uint16_t)(0x30 + c));
                after = (int16_t)(uint16_t)(cnt + 1);
                if (after > 4) after = 4;
                X16(0xdf, (uint16_t)after);
                m459e49_click_2742(fx.self, &fx.w, &fx.host);
                check_mem();
                CK(L.n == 0);
            }
        /* t = 0x01ff and a global that differs in the upper byte only: second arm; nothing without the flag */
        setup_459e49(idx, 0);
        set16(fx.obj, 0x217, 0x01ff);
        begin();
        m459e49_click_2742(fx.self, &fx.w, &fx.host);
        check_mem();
        CK(L.n == 0);
        /* p hits the word [+0xcc] itself: the byte store comes first, the word copy re-reads it */
        setup_459e49(idx, 1);
        set16(fx.self, 0xcc, 0xae);
        set16(fx.self, 0xdf, 0);
        begin();
        X8(0xcc, 1);
        X16(0xce, 0x0001);
        X16(0xdf, 1);
        m459e49_click_2742(fx.self, &fx.w, &fx.host);
        check_mem();
        /* the announcements of both arms: nine bytes differing at every position or equal, 0x4f6334 answering 0 or non-zero */
        for (a = 0; a < 2; a++)
            for (d = -1; d < 10; d++)
                for (r = 0; r < 2; r++) {
                    size_t nine = a == 0 ? 0x1b5 : 0x1e6, arg = a == 0 ? 0x1d6 : 0x207;
                    setup_459e49(idx, a == 0);
                    fx.w.value_5bb1ca = 0x100;
                    memcpy(fx.obj + nine, a == 0 ? "ABCDEFGHI" : "JKLMNOPQR", 9);
                    fx.obj[nine + 9] = 0x5c;
                    if (d >= 0) fx.obj[nine + (size_t)d] ^= 0x40;
                    set16(fx.obj, arg, 0x8001);          /* negative as a word: the first callee gets 0xffff8001 */
                    g_ret_by[0].callee = 0x4f6334;
                    g_ret_by[0].value = r ? 0x100u : 0;
                    set16(fx.self, 0xdf, 7);
                    begin();
                    if (a == 0) {
                        X8(0x40 + 0x1e, 1);
                        X16(0xdf, 4);
                    }
                    m459e49_click_2742(fx.self, &fx.w, &fx.host);
                    check_mem();
                    if (d >= 0 && d < 9) {
                        CK(L.n == (r ? 1 : 2));
                        check_call(0, 0x4f6334, 0x5cf1eb, 1);
                        check_arg(0, 0, 0xffff8001u, 0xffffffffu);
                        if (!r) {
                            check_call(1, 0x4fb2e3, 0x5c3a67, 1);
                            check_arg(1, 0, 0x8001, 0xffff);
                        }
                    } else {
                        CK(L.n == 0);
                    }
                }
        /* the first arm: the counter and the slot are stored before the callees run */
        setup_459e49(idx, 1);
        fx.w.value_5bb1ca = 1;
        set16(fx.self, 0xdf, 2);
        memset(fx.obj + 0x1b5, 'x', 9);
        m459e49_click_2742(fx.self, &fx.w, &fx.host);
        CK(L.n == 2 && L.c[0].snap_self[0x40 + 0x1e] == 1 && L.c[0].snap_self[0xdf] == 3 && L.c[0].snap_self[2 * 2 + 0xce] == 0x40);
    }
    if (g_failed) printf("FAIL test_m459e49_click_2742: %s\n", g_msg);
    else printf("PASS test_m459e49_click_2742\n");
    return g_failed;
}

/* 0x482359: byte [+0xa8] gate; up to the signed word ro[+0xfc] entries (+0x23e x lo, +0x242 y lo, +0x246 x hi, +0x24a y hi, stride 16) of the
 * object of the record of the word [+0x1e]; skips by ro[+0x3a2] with [+0x92] / [+0x91], by ro[+0x39e], ro[+0x3a0] with ro[+0x87c] == 1; the outer
 * rectangle +0x86c x lo, +0x870 y lo, +0x874 x hi, +0x878 y hi. */
static void ent_482359(int i, int32_t xlo, int32_t ylo, int32_t xhi, int32_t yhi)
{
    set32(fx.obj, (size_t)i * 16 + 0x23e, (uint32_t)xlo);
    set32(fx.obj, (size_t)i * 16 + 0x242, (uint32_t)ylo);
    set32(fx.obj, (size_t)i * 16 + 0x246, (uint32_t)xhi);
    set32(fx.obj, (size_t)i * 16 + 0x24a, (uint32_t)yhi);
}
static void setup_482359(int idx, int count)
{
    int i;
    base(0x2711, idx, 0x1e);
    fx.self[0xa8] = 0x80;
    set16(fx.self, 0x92, 0);
    fx.self[0x91] = 0;
    set16(fx.obj, 0xfc, (uint16_t)count);
    set16(fx.obj, 0x3a2, 0xffff);
    set16(fx.obj, 0x39e, 0xffff);
    set16(fx.obj, 0x3a0, 0xffff);
    set16(fx.obj, 0x87c, 0);
    for (i = 0; i < 12; i++) ent_482359(i, 6, 6, 6, 6);               /* (5, 5) misses them */
    set32(fx.obj, 0x86c, 1000);
    set32(fx.obj, 0x870, 1000);
    set32(fx.obj, 0x874, 2000);
    set32(fx.obj, 0x878, 2000);
    fx.w.value_5d0377 = 0xabcdef01u;
    fx.w.value_5d162d = 0x11111111u;
    fx.w.value_5d1631 = 0x22222222u;
    fx.w.value_5d1639 = 0x33333333u;
    fx.w.value_5b44f0 = 0x44444444u;
    fx.w.value_5b44f4 = 0x55555555u;
}
static void expect_arm_482359(uint32_t a, uint32_t event)
{
    CK(fx.w.value_5b44f0 == a && fx.w.value_5b44f4 == 1 && fx.w.value_5d162d == 0xabcdef01u && fx.w.value_5d1639 == 1);
    CK(fx.w.value_5d1631 == (a << 5) + 16 + 0x5b160c && fx.w.value_5c39e5 == event);
}
/* runs (5, 5) and checks a hit at entry `hit` (-1: miss, nothing armed) */
static void run_482359(int idx, int hit, int arg_x, int arg_y)
{
    int32_t r;
    begin();
    if (hit >= 0) {
        X16(0xad, (uint16_t)hit);
    }
    r = m482359_hit_test(fx.self, (int16_t)arg_x, (int16_t)arg_y, &fx.w, &fx.host);
    check_mem();
    (void)idx;
    if (hit >= 0) {
        CK(r == 1);
        expect_arm_482359(0x16, 0x27b5);
    } else {
        CK(r == 0);
        CK(fx.w.value_5b44f0 == 0x44444444u && fx.w.value_5c39e5 == 0x2711 && fx.w.value_5d1639 == 0x33333333u);
    }
}

static int test_m482359_hit_test(void)
{
    static const int idxs[2] = {2, -1};
    int ii, k, i, v;
    int32_t r;
    g_failed = 0;
    g_msg[0] = 0;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        /* the byte gate (only the low byte is tested: the neighbour is non-zero) */
        setup_482359(idx, 3);
        fx.self[0xa8] = 0;
        fx.self[0xa9] = 0xff;
        ent_482359(0, 0, 0, 9, 9);
        run_482359(idx, -1, 5, 5);
        /* the outer rectangle (count 0 and a negative count run no entry): hit on the bounds, miss one short of each */
        for (v = 0; v < 2; v++)
            for (k = 0; k < 5; k++) {
                setup_482359(idx, v ? -1 : 0);
                ent_482359(0, 0, 0, 9, 9);
                set32(fx.obj, 0x86c, k == 2 ? 6 : 5);
                set32(fx.obj, 0x870, k == 1 ? 6 : 5);
                set32(fx.obj, 0x874, k == 4 ? 4 : 5);
                set32(fx.obj, 0x878, k == 3 ? 4 : 5);
                if (k == 0) { set32(fx.obj, 0x86c, 5); }
                begin();
                r = m482359_hit_test(fx.self, 5, 5, &fx.w, &fx.host);
                check_mem();
                if (k == 0) { CK(r == 1); expect_arm_482359(9, 0x27b6); }
                else { CK(r == 0); CK(fx.w.value_5c39e5 == 0x2711); }
            }
        /* entries: the first that fails each of its four comparisons by one, then a hit at index 4; the later hit at 6 is not reached */
        for (k = 0; k < 4; k++) {
            setup_482359(idx, 8);
            ent_482359(0, k == 2 ? 6 : 5, k == 0 ? 6 : 5, k == 3 ? 4 : 5, k == 1 ? 4 : 5);
            ent_482359(4, -0x80000000, -0x80000000, 0x7fffffff, 0x7fffffff);
            ent_482359(6, 0, 0, 9, 9);
            run_482359(idx, 4, 5, 5);
        }
        /* a hit past the count is not seen; a hit at entry count-1 is */
        setup_482359(idx, 3);
        ent_482359(3, 0, 0, 9, 9);
        run_482359(idx, -1, 5, 5);
        setup_482359(idx, 4);
        ent_482359(3, 0, 0, 9, 9);
        run_482359(idx, 3, 5, 5);
        /* the skips: entry 2 is hit; ro[+0x3a2] == 2 with [+0x92] == 0 and [+0x91] == 0 skips it (the hit then is entry 5),
         * a non-zero word [+0x92] (0x100: its low byte is zero) or byte [+0x91] does not */
        for (v = 0; v < 4; v++) {
            setup_482359(idx, 8);
            ent_482359(2, 0, 0, 9, 9);
            ent_482359(5, 0, 0, 9, 9);
            set16(fx.obj, 0x3a2, 2);
            if (v == 1) set16(fx.self, 0x92, 0x100);
            if (v == 2) fx.self[0x91] = 0x80;
            if (v == 3) set16(fx.obj, 0x3a2, 3);
            run_482359(idx, v == 0 ? 5 : 2, 5, 5);
        }
        /* ro[+0x39e] and ro[+0x3a0]: with ro[+0x87c] == 1 the entry is skipped, with 0, 2, 0x101, -1 it is not */
        for (k = 0; k < 2; k++)
            for (v = 0; v < 5; v++) {
                int16_t w87c = (int16_t[]){1, 0, 2, 0x101, -1}[v];
                setup_482359(idx, 8);
                ent_482359(1, 0, 0, 9, 9);
                ent_482359(7, 0, 0, 9, 9);
                set16(fx.obj, k ? 0x3a0 : 0x39e, 1);
                set16(fx.obj, 0x87c, (uint16_t)w87c);
                run_482359(idx, w87c == 1 ? 7 : 1, 5, 5);
            }
        /* word arguments: -1 and -32768 against signed bounds; an entry hit at entry 0 with x = -32768 */
        setup_482359(idx, 1);
        ent_482359(0, -32768, -1, -32768, -1);
        begin();
        X16(0xad, 0);
        r = m482359_hit_test(fx.self, (int16_t)0x8000, (int16_t)0xffff, &fx.w, &fx.host);
        CK(r == 1);
        check_mem();
        expect_arm_482359(0x16, 0x27b5);
        (void)i;
    }
    if (g_failed) printf("FAIL test_m482359_hit_test: %s\n", g_msg);
    else printf("PASS test_m482359_hit_test\n");
    return g_failed;
}

/* FL24B-TESTS-END */

int main(void)
{
    int failures = 0;
    failures += test_m4dad60_init_swap_buttons();
    failures += test_m466073_click_27d2_27d3();
    failures += test_m467740_hit_test();
    failures += test_m4b7563_click_27bf_27c1();
    failures += test_m459e49_click_2742();
    failures += test_m482359_hit_test();
    /* FL24B-MAIN-END */
    return failures;
}
