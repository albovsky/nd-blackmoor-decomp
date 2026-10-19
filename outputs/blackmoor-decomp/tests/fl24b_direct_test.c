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
#define MASK_VA 0x20040000u       /* a byte mask (0x4acf45) */
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
    uint8_t obj[0x1000], decoy[0x1000], obj2[0x1000], mask[0x100];
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
static uint32_t g_tick, g_out_4aec35;
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
    if (callee == 0x4aec35 && nargs == 1) memcpy((void *)args[0], &g_out_4aec35, 4);
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
    if (a >= MASK_VA && a < MASK_VA + 0x100) return fx.mask + (a - MASK_VA);
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
    memset(fx.mask, 0, sizeof fx.mask);
    g_out_4aec35 = 0;
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

/* 0x46793a: [+0x1aa] := the object address of the record of the word [+8] (always, first); guards [+0x1ae] != 0, [+0xc] == 0, the record
 * state == 1, [+0x1b6] == 0, [+0x1b2] == 0; events 0x27ac and 0x27ab (the selection [+0x1ba], the stack depth [+0x240], the pairs at +0x1b8 / +0x1c0). */
static void setup_46793a(uint32_t sel, int idx)
{
    base(sel, idx, 8);
    set32(fx.self, 0x1ae, 0x01000000u);
    set32(fx.self, 0xc, 0);
    set32(fx.self, 0x1b6, 0);
    set32(fx.self, 0x1b2, 0);
    set32(fx.self, 0x248, 0);
    set32(fx.self, 0x240, 0);
    set16(fx.self, 0xa, 7);
    set32(fx.self, 0x1ba, 7);
    set16(fx.obj, 0x2bf, 0x1234);
}
#define EXPECT_STORE_1AA() X32(0x1aa, OBJ_VA)

static int test_m46793a_click_27ab_27ac(void)
{
    static const int idxs[2] = {2, -1};
    int ii, k, v, s, c;
    g_failed = 0;
    g_msg[0] = 0;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        static const uint32_t sels[] = {0x27ab, 0x27ac, 0x2711};
        for (s = 0; s < 3; s++)
            for (k = 0; k < 5; k++)
                for (v = 0; v < 6; v++) {
                    setup_46793a(sels[s], idx);
                    set32(fx.self, 0x248, 1);
                    if (k == 0) set32(fx.self, 0x1ae, 0);
                    if (k == 1) set32(fx.self, 0xc, (uint32_t[]){1, 0x100, 0x10000, 0x01000000u, 0x80000000u, 3}[v]);
                    if (k == 2) set32(fx.self, 0x1b6, (uint32_t[]){1, 0x100, 0x10000, 0x01000000u, 0x80000000u, 3}[v]);
                    if (k == 3) set32(fx.self, 0x1b2, (uint32_t[]){1, 0x100, 0x10000, 0x01000000u, 0x80000000u, 3}[v]);
                    if (k == 4) {
                        int i;
                        for (i = -1; i <= 4; i++)
                            set32(fx.tab, (size_t)(i + 1) * REC + 0x4d, i == idx ? (uint32_t[]){0, 2, 3, 0xffffffffu, 0x101, 0x10001}[v] : 1u);
                    }
                    begin();
                    EXPECT_STORE_1AA();
                    m46793a_click_27ab_27ac(fx.self, &fx.w, &fx.host);
                    check_mem();
                    CK(L.n == 0);
                }
        /* 0x27ac */
        setup_46793a(0x27ac, idx);
        set32(fx.self, 0x248, 1);
        begin();
        EXPECT_STORE_1AA();
        X32(0x1b2, 1);
        set32(xt, (size_t)(idx + 1) * REC + 0x4d, 2);
        m46793a_click_27ab_27ac(fx.self, &fx.w, &fx.host);
        check_mem();
        CK(L.n == 0);
        /* 0x27ab, selection -1: it becomes w sign-extended; with w = -1 it stays; no announcement while [+0x248] is zero */
        for (v = 0; v < 3; v++) {
            int16_t w = (int16_t[]){-5, 0x7fff, -1}[v];
            setup_46793a(0x27ab, idx);
            set32(fx.self, 0x1ba, 0xffffffffu);
            set16(fx.self, 0xa, (uint16_t)w);
            begin();
            EXPECT_STORE_1AA();
            X32(0x1ba, (uint32_t)(int32_t)w);
            m46793a_click_27ab_27ac(fx.self, &fx.w, &fx.host);
            check_mem();
            CK(L.n == 0);
        }
        /* a different w pushes (s, w) at depth n, selects w, n + 1, then the four callees in order; [+0x1b6] is the first one's result */
        for (c = 0; c < 4; c++) {
            uint32_t n = (uint32_t[]){0, 1, 5, 0xffffffffu}[c];
            int16_t w = -2;
            setup_46793a(0x27ab, idx);
            set32(fx.self, 0x240, n);
            set16(fx.self, 0xa, (uint16_t)w);
            set32(fx.self, 0x1ba, 0xfffffffeu & ~0u ? 0x0000fffeu : 0);   /* 0xfffe: equal to w as a word but not as a dword */
            set32(fx.self, 0x248, 1);
            g_ret_by[0].callee = 0x467c0e;
            g_ret_by[0].value = 0xdead0001u;
            begin();
            EXPECT_STORE_1AA();
            set32(xs, (size_t)((int32_t)n * 8 + 0x1c0), 0x0000fffeu);
            set32(xs, (size_t)((int32_t)n * 8 + 0x1c4), 0xfffffffeu);
            if ((int32_t)n == -1) {          /* the pair at n = -1 overlaps [+0x1b8..] and [+0x1ba]: the original stores the pair first, then the selection */
                X32(0x1b8, 0x0000fffeu);
                X32(0x1bc, 0xfffffffeu);
            }
            X32(0x1ba, 0xfffffffeu);
            X32(0x240, n + 1);
            X32(0x1b6, 0xdead0001u);
            m46793a_click_27ab_27ac(fx.self, &fx.w, &fx.host);
            check_mem();
            CK(L.n == 5);
            check_call(0, 0x467c0e, (uintptr_t)fx.self, 0);
            check_call(1, 0x467d5f, (uintptr_t)fx.self, 0);
            check_call(2, 0x467e70, (uintptr_t)fx.self, 0);
            check_call(3, 0x467eb0, (uintptr_t)fx.self, 0);
            check_call(4, 0x4fb2e3, 0x5c3a67, 1);
            check_arg(4, 0, 0x1234, 0xffff);
            CK(get32(L.c[0].snap_self, 0x1b6) == ((int32_t)n == -1 ? 0xfffe0000u : 0));   /* (the pair at n = -1 reaches into the dword) */
            CK(get32(L.c[1].snap_self, 0x1b6) == 0xdead0001u);
            CK(get32(L.c[0].snap_self, 0x240) == n + 1);
        }
        /* the same w: n == 0 clears the selection */
        setup_46793a(0x27ab, idx);
        set16(fx.self, 0xa, 7);
        begin();
        EXPECT_STORE_1AA();
        X32(0x1ba, 0xffffffffu);
        m46793a_click_27ab_27ac(fx.self, &fx.w, &fx.host);
        check_mem();
        /* the same w, n = 2: the pair at +0x1c8 / +0x1cc; a match in the first dword pops to it, in the second only also pops (to the FIRST dword);
         * no match leaves everything; n = 1 pops to 0 */
        for (v = 0; v < 5; v++) {
            uint32_t n = v == 4 ? 1 : 2;
            uint32_t first = v == 0 || v == 3 || v == 4 ? 7u : 9u, second = v == 1 ? 7u : 9u;
            setup_46793a(0x27ab, idx);
            set32(fx.self, 0x240, n);
            set32(fx.self, n * 8 + 0x1b8, first);
            set32(fx.self, n * 8 + 0x1bc, second);
            if (v == 2) { set32(fx.self, n * 8 + 0x1b8, 8); set32(fx.self, n * 8 + 0x1bc, 0x100000007ull & 0xffffffffu ? 0x80000007u : 0); }
            set32(fx.self, 0x248, v == 3 ? 1 : 0);
            begin();
            EXPECT_STORE_1AA();
            if (v != 2) {
                X32(0x1ba, first);
                X32(0x240, n - 1);
            }
            m46793a_click_27ab_27ac(fx.self, &fx.w, &fx.host);
            check_mem();
            if (v == 3) { CK(L.n == 1); check_arg(0, 0, 0x1234, 0xffff); } else { CK(L.n == 0); }
        }
        /* n = -1 with a matching pair at +0x1b0: popped to -2 and clamped to 0 */
        setup_46793a(0x27ab, idx);
        set32(fx.self, 0x240, 0xffffffffu);
        set32(fx.self, 0x1b0, 7);
        set32(fx.self, 0x1b4, 0);
        set32(fx.self, 0x1b2, 0);        /* (overlaps: the gate dword [+0x1b2] is the high half of the pair) */
        begin();
        EXPECT_STORE_1AA();
        X32(0x1ba, 7);
        X32(0x240, 0);
        m46793a_click_27ab_27ac(fx.self, &fx.w, &fx.host);
        check_mem();
    }
    if (g_failed) printf("FAIL test_m46793a_click_27ab_27ac: %s\n", g_msg);
    else printf("PASS test_m46793a_click_27ab_27ac\n");
    return g_failed;
}

/* 0x4ad310: guards dword [+0xc1b] != 0, byte [+0xc24] == 0, dword [+0xc20] == 0, record state (word [+0x1e]); [+0x20] == 0 selects the events
 * 0x2775 / 0x2774, [+0x20] != 0 the event 0x2776 (entries of 0xc7 bytes at +0x6e, the list size is the word at +0x42 of the object at [+0xc17]). */
static void setup_4ad310(uint32_t sel, int idx, uint32_t d20)
{
    base(sel, idx, 0x1e);
    set32(fx.self, 0xc1b, 0x01000000u);
    fx.self[0xc24] = 0;
    set32(fx.self, 0xc20, 0);
    set32(fx.self, 0x20, d20);
    set32(fx.self, 0xc17, OBJ_VA);
    set16(fx.self, 0x24, 1);
    set16(fx.obj, 0x42, 0);
    L.n = 0;
}

static int test_m4ad310_click_2774_2776(void)
{
    static const int idxs[2] = {2, -1};
    static const uint32_t sels[] = {0x2775, 0x2774, 0x2776, 0x2711};
    int ii, k, v, s, i;
    g_failed = 0;
    g_msg[0] = 0;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        for (s = 0; s < 4; s++)
            for (k = 0; k < 4; k++)
                for (v = 0; v < 6; v++) {
                    setup_4ad310(sels[s], idx, s == 2 ? 1u : 0u);
                    if (k == 0) set32(fx.self, 0xc1b, 0);
                    if (k == 1) fx.self[0xc24] = (uint8_t[]){1, 0x80, 0xff, 0x7f, 2, 0x55}[v];
                    if (k == 2) set32(fx.self, 0xc20, (uint32_t[]){1, 0x100, 0x10000, 0x01000000u, 0x80000000u, 3}[v]);
                    if (k == 3) {
                        int j;
                        for (j = -1; j <= 4; j++)
                            set32(fx.tab, (size_t)(j + 1) * REC + 0x4d, j == idx ? (uint32_t[]){0, 2, 3, 0xffffffffu, 0x101, 0x10001}[v] : 1u);
                    }
                    set16(fx.obj, 0x42, 3);
                    begin();
                    m4ad310_click_2774_2776(fx.self, &fx.w, &fx.host);
                    check_mem();
                    CK(L.n == 0);
                }
        /* [+0x20] != 0 with the events 0x2775 / 0x2774 and [+0x20] == 0 with 0x2776: nothing */
        for (s = 0; s < 3; s++) {
            setup_4ad310(sels[s], idx, s == 2 ? 0u : 0x100u);
            begin();
            m4ad310_click_2774_2776(fx.self, &fx.w, &fx.host);
            check_mem();
            CK(L.n == 0);
        }
        /* 0x2775 */
        setup_4ad310(0x2775, idx, 0);
        begin();
        X8(0xc1f, 1);
        set32(xt, (size_t)(idx + 1) * REC + 0x4d, 2);
        m4ad310_click_2774_2776(fx.self, &fx.w, &fx.host);
        check_mem();
        CK(L.n == 0);
        /* 0x2774: the answer of 0x4af96e is a word (upper half ignored): -1 ends after one call; others go on with the sign-extended value */
        for (v = 0; v < 4; v++) {
            uint32_t ans = (uint32_t[]){0xffffu, 0x1234ffffu, 0x12348000u, 3u}[v];
            int32_t r = (int16_t)(ans & 0xffff);
            setup_4ad310(0x2774, idx, 0);
            g_ret_by[0].callee = 0x4af96e;
            g_ret_by[0].value = ans;
            begin();
            if (r != -1) {
                X32(0x20, 1);
                X16(0x24, (uint16_t)r);
            }
            m4ad310_click_2774_2776(fx.self, &fx.w, &fx.host);
            check_mem();
            if (r == -1) {
                CK(L.n == 1);
            } else {
                CK(L.n == 4);
                check_call(0, 0x4af96e, (uintptr_t)fx.self, 0);
                check_call(1, 0x4ada56, (uintptr_t)fx.self, 0);
                check_call(2, 0x4ae683, (uintptr_t)fx.self, 1);
                check_arg(2, 0, (uint32_t)r, 0xffffffffu);
                check_call(3, 0x4ae495, (uintptr_t)fx.self, 1);
                check_arg(3, 0, (uint32_t)r, 0xffffffffu);
                CK(get32(L.c[2].snap_self, 0x20) == 0 && get32(L.c[3].snap_self, 0x20) == 1 && (L.c[3].snap_self[0x24] | L.c[3].snap_self[0x25] << 8) == (r & 0xffff));
            }
        }
        /* 0x2776: list of 4 entries, word [+0x24] = 1 (skipped); 0x4aef4a answers non-zero for entries 0 and 3 only (one answer per call is
         * not scriptable here: the host answers by callee, so answer non-zero for all three, then zero for all) */
        for (v = 0; v < 2; v++) {
            setup_4ad310(0x2776, idx, 1);
            set16(fx.obj, 0x42, 4);
            set16(fx.self, 0x24, 1);
            set16(fx.self, 1 * 0xc7 + 0x6e, 5);            /* p */
            set16(fx.self, 0 * 0xc7 + 0x6e, 7);
            set16(fx.self, 2 * 0xc7 + 0x6e, 0x7fff);
            set16(fx.self, 3 * 0xc7 + 0x6e, 0x8000);
            g_ret_by[0].callee = 0x4aef4a;
            g_ret_by[0].value = v ? 0 : 0x100;
            begin();
            X16(1 * 0xc7 + 0x6e, v ? 6 : 0x8000);          /* max(5, 7, 0x7fff, -32768) = 0x7fff, +1 wraps to 0x8000; no answers: 5 + 1 */
            X32(0x6a, 1);
            X16(0x24, 0xffff);
            X32(0x20, 0);
            m4ad310_click_2774_2776(fx.self, &fx.w, &fx.host);
            check_mem();
            CK(L.n == (v ? 2 + 3 + 2 : 2 + 3 + 2));
            check_call(0, 0x4ada9f, (uintptr_t)fx.self, 0);
            check_call(1, 0x4ae96c, (uintptr_t)fx.self, 1);
            check_arg(1, 0, 1, 0xffffffffu);
            check_call(2, 0x4aef4a, (uintptr_t)fx.self, 2);
            check_arg(2, 0, 1, 0xffffffffu);      /* args[0] = word [+0x24] (pushed last), args[1] = i */
            check_arg(2, 1, 0, 0xffffffffu);
            check_arg(3, 1, 2, 0xffffffffu);
            check_arg(4, 1, 3, 0xffffffffu);
            check_call(5, 0x4ae495, (uintptr_t)fx.self, 1);
            check_arg(5, 0, 1, 0xffffffffu);
            check_call(6, 0x4adae8, (uintptr_t)fx.self, 0);
            /* at 0x4ae495 the word at p is already updated, [+0x6a] not yet, [+0x24] not yet */
            CK(L.c[5].snap_self[1 * 0xc7 + 0x6e] == (v ? 6 : 0x00) && get32(L.c[5].snap_self, 0x20) == 1);
        }
        /* an empty and a negative list: no 0x4aef4a call; the word at p only incremented (0xffff + 1 wraps to 0) */
        for (v = 0; v < 2; v++) {
            setup_4ad310(0x2776, idx, 1);
            set16(fx.obj, 0x42, v ? 0xfffb : 0);
            set16(fx.self, 0x24, 2);
            set16(fx.self, 2 * 0xc7 + 0x6e, 0xffff);
            begin();
            X16(2 * 0xc7 + 0x6e, 0);
            X32(0x6a, 1);
            X16(0x24, 0xffff);
            X32(0x20, 0);
            m4ad310_click_2774_2776(fx.self, &fx.w, &fx.host);
            check_mem();
            CK(L.n == 4);
        }
        (void)i;
    }
    if (g_failed) printf("FAIL test_m4ad310_click_2774_2776: %s\n", g_msg);
    else printf("PASS test_m4ad310_click_2774_2776\n");
    return g_failed;
}

/* 0x4acf45 (ret 0xc): x, y words and a block of four dwords. Entries of 0xc7 bytes at +0x6e (x low +2, y low +6, x high +0xa, y high +0xe,
 * the byte +0x26 selects q = entry + 0x27 + 0x28 * byte; the mask pointer at q+0x1c, the stride word at q+0x20). */
static uint8_t blk[16];
static void entry_4acf45(int i, int32_t xlo, int32_t ylo, int32_t xhi, int32_t yhi, int b, int stride)
{
    size_t e = (size_t)i * 0xc7 + 0x6e, q = e + 0x27 + (size_t)b * 0x28;
    set32(fx.self, e + 2, (uint32_t)xlo);
    set32(fx.self, e + 6, (uint32_t)ylo);
    set32(fx.self, e + 0xa, (uint32_t)xhi);
    set32(fx.self, e + 0xe, (uint32_t)yhi);
    fx.self[e + 0x26] = (uint8_t)b;
    set32(fx.self, q + 0x1c, MASK_VA);
    set16(fx.self, q + 0x20, (uint16_t)stride);
}
static void setup_4acf45(int count)
{
    int i;
    base(0x2711, 2, 0x1e);
    set32(fx.self, 0xc1b, 0x01000000u);
    set32(fx.self, 0xc17, OBJ_VA);
    set32(fx.self, 0x20, 0);
    set16(fx.self, 0x24, 1);
    set16(fx.obj, 0x42, (uint16_t)count);
    for (i = 0; i < 8; i++) entry_4acf45(i, 100, 100, 101, 101, 0, 1);       /* (7, 5) misses them */
    set32(fx.obj, 0x32a, 1000);
    set32(fx.obj, 0x32e, 1000);
    set32(fx.obj, 0x332, 2000);
    set32(fx.obj, 0x336, 2000);
    memcpy(blk, "\x11\x11\x11\x11\x22\x22\x22\x22\x33\x33\x33\x33\x44\x44\x44\x44", 16);
}
static void expect_block_4acf45(void)
{
    X32(0xc25, 0x11111111u);
    X32(0xc29, 0x22222222u);
    X32(0xc2d, 0x33333333u);
    X32(0xc31, 0x44444444u);
}
static int32_t run_4acf45(int16_t x, int16_t y)
{
    return m4acf45_hit_test(fx.self, x, y, blk, &fx.w, &fx.host);
}

static int test_m4acf45_hit_test(void)
{
    int k, v, i;
    int32_t r;
    g_failed = 0;
    g_msg[0] = 0;
    /* the gate: nothing is stored, 0 is returned (only the low half of a dword gate set still counts) */
    for (v = 0; v < 2; v++) {
        setup_4acf45(3);
        set32(fx.self, 0xc1b, 0);
        begin();
        r = run_4acf45(7, 5);
        CK(r == 0);
        check_mem();
        CK(L.n == 0);
        setup_4acf45(3);
        set32(fx.self, 0xc1b, 0x00000100u);
        entry_4acf45(0, 0, 0, 9, 9, 0, 1);
        fx.mask[0] = 1;
        break;
    }
    /* [+0x20] != 0: 0x4acdc2, 0x4ad1e5(0x2776), 0x4aec35(&local), then 0x4ae495 or 0x4ae452 with the sign-extended word [+0x24] */
    for (v = 0; v < 4; v++) {
        uint32_t ans = v == 0 ? 0 : 0x100, out = v == 1 ? 0 : v == 0 ? 0xffffffffu : 0x01000000u;
        setup_4acf45(3);
        set32(fx.self, 0x20, v == 3 ? 0x80000000u : 1);
        set16(fx.self, 0x24, 0xfffe);
        g_ret_by[0].callee = 0x4aec35;
        g_ret_by[0].value = ans;
        g_out_4aec35 = out;
        begin();
        expect_block_4acf45();
        r = run_4acf45(7, 5);
        CK(r == 1);
        check_mem();
        CK(L.n == 4);
        check_call(0, 0x4acdc2, (uintptr_t)fx.self, 0);
        check_call(1, 0x4ad1e5, (uintptr_t)fx.self, 1);
        check_arg(1, 0, 0x2776, 0xffffffffu);
        check_call(2, 0x4aec35, (uintptr_t)fx.self, 1);
        check_call(3, ans != 0 && out != 0 ? 0x4ae452 : 0x4ae495, (uintptr_t)fx.self, 1);
        check_arg(3, 0, 0xfffffffeu, 0xffffffffu);
        CK(get32(L.c[0].snap_self, 0xc25) == 0x11111111u && get32(L.c[0].snap_self, 0xc31) == 0x44444444u);
    }
    /* the entries: a hit looks at mask[dy * stride + dx]; entry 2 (q at b = 2, stride 3, dx 2, dy 1: index 5); the array is cleared first */
    for (v = 0; v < 3; v++) {
        setup_4acf45(5);
        memset(fx.self + 0xe39, 0xee, 30 + 2);
        entry_4acf45(2, 5, 4, 8, 6, 2, 3);
        entry_4acf45(4, 7, 5, 7, 5, 0, 9);       /* dx 0, dy 0: index 0 */
        fx.mask[5] = v == 0 ? 0x80 : 0;          /* a byte test: 0x80 counts, 0 does not */
        fx.mask[4] = v == 1 ? 0 : 0;
        fx.mask[0] = v == 2 ? 1 : 0;
        begin();
        expect_block_4acf45();
        memset(xs + 0xe39, 0, 30);
        X16(0xe57, 0);
        if (v == 0) { X16(0xe39, 2); X16(0xe57, 1); }
        if (v == 2) { X16(0xe39, 4); X16(0xe57, 1); }
        r = run_4acf45(7, 5);
        check_mem();
        if (v != 1) {
            CK(r == 1);
            CK(L.n == 1);
            check_call(0, 0x4ad1e5, (uintptr_t)fx.self, 1);
            check_arg(0, 0, 0x2774, 0xffffffffu);
        } else {
            CK(r == 0);
            CK(L.n == 0);
        }
    }
    /* both entries hit: the array holds the indexes in order */
    setup_4acf45(5);
    entry_4acf45(1, 7, 5, 7, 5, 0, 1);
    entry_4acf45(3, 6, 5, 8, 5, 1, 1);
    fx.mask[0] = 1;
    fx.mask[1] = 1;
    begin();
    expect_block_4acf45();
    memset(xs + 0xe39, 0, 30);
    X16(0xe39, 1);
    X16(0xe39 + 2, 3);
    X16(0xe57, 2);
    r = run_4acf45(7, 5);
    check_mem();
    CK(r == 1 && L.n == 1);
    /* each comparison failing by one: no hit (mask all ones), then the outer rectangle */
    for (k = 0; k < 4; k++) {
        setup_4acf45(1);
        memset(fx.mask, 1, sizeof fx.mask);
        entry_4acf45(0, k == 2 ? 8 : 7, k == 0 ? 6 : 5, k == 3 ? 6 : 7, k == 1 ? 4 : 5, 0, 1);
        begin();
        expect_block_4acf45();
        memset(xs + 0xe39, 0, 30);
        X16(0xe57, 0);
        r = run_4acf45(7, 5);
        check_mem();
        CK(r == 0 && L.n == 0);
    }
    /* the outer rectangle: bounds inclusive; one short of each bound misses; a list count of 0 or negative runs no entry */
    for (v = 0; v < 6; v++) {
        int16_t cnt = (int16_t[]){0, -1, 3, 3, 3, 3}[v];
        setup_4acf45(cnt);
        memset(fx.mask, 1, sizeof fx.mask);
        entry_4acf45(0, 0, 0, 9, 9, 0, 1);
        if (cnt <= 0) entry_4acf45(0, 7, 5, 7, 5, 0, 1);
        set32(fx.obj, 0x32a, 7);
        set32(fx.obj, 0x32e, 5);
        set32(fx.obj, 0x332, 7);
        set32(fx.obj, 0x336, 5);
        if (v == 2) set32(fx.obj, 0x32a, 8);
        if (v == 3) set32(fx.obj, 0x32e, 6);
        if (v == 4) set32(fx.obj, 0x332, 6);
        if (v == 5) set32(fx.obj, 0x336, 4);
        if (v >= 2) {
            for (i = 0; i < 3; i++) entry_4acf45(i, 100, 100, 101, 101, 0, 1);
        }
        begin();
        expect_block_4acf45();
        memset(xs + 0xe39, 0, 30);
        X16(0xe57, 0);
        r = run_4acf45(7, 5);
        check_mem();
        if (v < 2) {
            CK(r == 1 && L.n == 1);
            check_arg(0, 0, 0x2775, 0xffffffffu);
        } else {
            CK(r == 0 && L.n == 0);
        }
    }
    /* signed words: x = -32768, y = -1 against signed bounds */
    setup_4acf45(0);
    set32(fx.obj, 0x32a, 0xffff8000u);
    set32(fx.obj, 0x32e, 0xffffffffu);
    set32(fx.obj, 0x332, 0xffff8000u);
    set32(fx.obj, 0x336, 0xffffffffu);
    begin();
    expect_block_4acf45();
    memset(xs + 0xe39, 0, 30);
    X16(0xe57, 0);
    r = run_4acf45((int16_t)0x8000, (int16_t)0xffff);
    check_mem();
    CK(r == 1 && L.n == 1);
    if (g_failed) printf("FAIL test_m4acf45_hit_test: %s\n", g_msg);
    else printf("PASS test_m4acf45_hit_test\n");
    return g_failed;
}

/* 0x4aa0f0 (ret 8): byte [+0x45] gate; the outer rectangle y low +0xeb, y high +0xf3, x low +0xe7, x high +0xef of the object of the record of
 * the word [+0x21]; entries of 0x15c bytes below the signed word +0xf7: rectangle A (y low +0x10d, y high +0x115, x low +0x109, x high +0x111)
 * while the byte [+0x2b] is set and the byte 0x630a60[i] is zero, rectangle B (+0x249, +0x251, +0x245, +0x24d) unless the dword [+0x25] == 2. */
static uint8_t tab630[16];
static void rect_4aa0f0(int i, int second, int32_t xlo, int32_t ylo, int32_t xhi, int32_t yhi)
{
    size_t o = (size_t)i * 0x15c + (second ? 0x245 : 0x109);
    set32(fx.obj, o, (uint32_t)xlo);
    set32(fx.obj, o + 4, (uint32_t)ylo);
    set32(fx.obj, o + 8, (uint32_t)xhi);
    set32(fx.obj, o + 12, (uint32_t)yhi);
}
static void setup_4aa0f0(int idx, int count)
{
    int i;
    base(0x2711, idx, 0x21);
    fx.self[0x45] = 0x80;
    fx.self[0x2b] = 1;
    set32(fx.self, 0x25, 0);
    set16(fx.obj, 0xf7, (uint16_t)count);
    for (i = 0; i < 9; i++) {
        rect_4aa0f0(i, 0, 100, 100, 101, 101);
        rect_4aa0f0(i, 1, 100, 100, 101, 101);
    }
    memset(tab630, 0, sizeof tab630);
    fx.w.bytes_630a60 = tab630;
    set32(fx.obj, 0xe7, 1000);
    set32(fx.obj, 0xeb, 1000);
    set32(fx.obj, 0xef, 2000);
    set32(fx.obj, 0xf3, 2000);
    fx.w.value_5d0377 = 0xabcdef01u;
    fx.w.value_5d162d = 0x11111111u;
    fx.w.value_5d1631 = 0x22222222u;
    fx.w.value_5d1639 = 0x33333333u;
    fx.w.value_5b44f0 = 0x44444444u;
    fx.w.value_5b44f4 = 0x55555555u;
}
/* runs (5, 5); `a`/`event` the expected arming, `word` the expected [+0x23] (-1: not stored) */
static void run_4aa0f0(int hit, uint32_t a, uint32_t event, int word)
{
    int32_t r;
    begin();
    if (word >= 0) X16(0x23, (uint16_t)word);
    r = m4aa0f0_hit_test(fx.self, 5, 5, &fx.w, &fx.host);
    check_mem();
    CK(L.n == 0);
    if (hit) {
        CK(r == 1);
        CK(fx.w.value_5b44f0 == a && fx.w.value_5b44f4 == 1 && fx.w.value_5d162d == 0xabcdef01u && fx.w.value_5d1639 == 1);
        CK(fx.w.value_5d1631 == (a << 5) + 16 + 0x5b160c && fx.w.value_5c39e5 == event);
    } else {
        CK(r == 0);
        CK(fx.w.value_5b44f0 == 0x44444444u && fx.w.value_5c39e5 == 0x2711 && fx.w.value_5d1639 == 0x33333333u);
    }
}

static int test_m4aa0f0_hit_test(void)
{
    static const int idxs[2] = {2, -1};
    int ii, k, v;
    int32_t r;
    g_failed = 0;
    g_msg[0] = 0;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        /* the byte gate: only the low byte */
        setup_4aa0f0(idx, 3);
        fx.self[0x45] = 0;
        fx.self[0x46] = 0xff;
        rect_4aa0f0(0, 0, 0, 0, 9, 9);
        set32(fx.obj, 0xe7, 0);
        set32(fx.obj, 0xeb, 0);
        set32(fx.obj, 0xef, 9);
        set32(fx.obj, 0xf3, 9);
        run_4aa0f0(0, 0, 0, -1);
        /* the outer rectangle: bounds inclusive, one short of each misses (count 0: no entries) */
        for (k = 0; k < 5; k++) {
            setup_4aa0f0(idx, 0);
            set32(fx.obj, 0xe7, k == 3 ? 6 : 5);
            set32(fx.obj, 0xeb, k == 1 ? 6 : 5);
            set32(fx.obj, 0xef, k == 4 ? 4 : 5);
            set32(fx.obj, 0xf3, k == 2 ? 4 : 5);
            run_4aa0f0(k == 0, 9, 0x2771, -1);
        }
        /* rectangle A of entry 2: needs [+0x2b] != 0 and the table byte zero; each comparison one short misses (B is then tried and misses too) */
        for (k = 0; k < 4; k++) {
            setup_4aa0f0(idx, 5);
            rect_4aa0f0(2, 0, k == 2 ? 6 : 5, k == 0 ? 6 : 5, k == 3 ? 4 : 5, k == 1 ? 4 : 5);
            run_4aa0f0(0, 0, 0, -1);
        }
        for (v = 0; v < 4; v++) {                   /* the gates of A: [+0x2b] == 0 or table[2] != 0 skip it */
            setup_4aa0f0(idx, 5);
            rect_4aa0f0(2, 0, 0, 0, 9, 9);
            if (v == 1) fx.self[0x2b] = 0;
            if (v == 2) tab630[2] = 0x80;
            if (v == 3) fx.self[0x2b] = 0x80;
            run_4aa0f0(v == 0 || v == 3, 0x16, 0x276f, v == 0 || v == 3 ? 2 : -1);
        }
        /* rectangle B of entry 3 (A of entry 3 would miss): [+0x25] == 2 skips it, any other value (also 0x100, 0x80000002) does not */
        for (v = 0; v < 4; v++) {
            setup_4aa0f0(idx, 5);
            rect_4aa0f0(3, 1, 0, 0, 9, 9);
            set32(fx.self, 0x25, (uint32_t[]){0, 2, 0x100, 0x80000002u}[v]);
            run_4aa0f0(v != 1, 0x16, 0x2770, v != 1 ? 3 : -1);
        }
        /* each comparison of B one short */
        for (k = 0; k < 4; k++) {
            setup_4aa0f0(idx, 5);
            rect_4aa0f0(1, 1, k == 2 ? 6 : 5, k == 0 ? 6 : 5, k == 3 ? 4 : 5, k == 1 ? 4 : 5);
            run_4aa0f0(0, 0, 0, -1);
        }
        /* the order: entry 1's B is hit before entry 2's A; the count limits the scan (entry 4 is out of a count of 4) */
        setup_4aa0f0(idx, 4);
        rect_4aa0f0(1, 1, 0, 0, 9, 9);
        rect_4aa0f0(2, 0, 0, 0, 9, 9);
        run_4aa0f0(1, 0x16, 0x2770, 1);
        setup_4aa0f0(idx, 4);
        rect_4aa0f0(4, 0, 0, 0, 9, 9);
        run_4aa0f0(0, 0, 0, -1);
        setup_4aa0f0(idx, 5);
        rect_4aa0f0(4, 0, 0, 0, 9, 9);
        run_4aa0f0(1, 0x16, 0x276f, 4);
        /* a negative count scans nothing; signed words */
        setup_4aa0f0(idx, -1);
        rect_4aa0f0(0, 0, 0, 0, 9, 9);
        run_4aa0f0(0, 0, 0, -1);
        setup_4aa0f0(idx, 0);
        set32(fx.obj, 0xe7, 0xffff8000u);
        set32(fx.obj, 0xeb, 0xffffffffu);
        set32(fx.obj, 0xef, 0xffff8000u);
        set32(fx.obj, 0xf3, 0xffffffffu);
        begin();
        r = m4aa0f0_hit_test(fx.self, (int16_t)0x8000, (int16_t)0xffff, &fx.w, &fx.host);
        CK(r == 1);
        check_mem();
    }
    if (g_failed) printf("FAIL test_m4aa0f0_hit_test: %s\n", g_msg);
    else printf("PASS test_m4aa0f0_hit_test\n");
    return g_failed;
}

/* 0x487ed5: guards dword [+0x71] != 0, dword [+0x6c] == 1 (exactly), record state (word [+0x1e]); events 0x2789 / 0x2788; the slot of the word
 * [+0x66] = 3 is the dword at [+0x31]; the queue words at [+0x7a ...]; the tick is read last. */
static void setup_487ed5(uint32_t sel, int idx)
{
    base(sel, idx, 0x1e);
    set32(fx.self, 0x71, 0x01000000u);
    set32(fx.self, 0x6c, 1);
    set16(fx.self, 0x66, 3);
    fx.self[0x65] = 0;
    set16(fx.self, 0x6a, 0xffff);
    set16(fx.self, 0x7a, 0x1111);
    set16(fx.self, 0x7c, 0x2222);
    set16(fx.self, 0x7e, 0x3333);
    set16(fx.self, 0x80, 0x4444);
    fx.w.value_5bb1ca = 0;
    fx.w.value_583a29 = 0x1234;
    fx.w.bytes_54de04 = consts[0];
    fx.w.bytes_54de10 = consts[1];
    memcpy(consts[0], "ABCDEFGHI", 9);
    memcpy(consts[1], "JKLMNOPQR", 9);
    memcpy(fx.obj + 0x4ab, "ABCDEFGHI", 9);
    memcpy(fx.obj + 0x4dc, "JKLMNOPQR", 9);
    set16(fx.obj, 0x4cc, 0x1234);
    set16(fx.obj, 0x4fd, 0x5678);
    set16(fx.obj, 0x425, 3);
    set16(fx.obj, 0x447, 0x1234);
    fx.obj[0x23] = 0;
    g_tick = 0xfffffe10u;
}

static int test_m487ed5_click_2788_2789(void)
{
    static const int idxs[2] = {2, -1};
    static const uint32_t sels[] = {0x2788, 0x2789, 0x2711};
    int ii, k, v, s, arm, b65, flag, d, eq;
    g_failed = 0;
    g_msg[0] = 0;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        for (s = 0; s < 3; s++)
            for (k = 0; k < 4; k++)
                for (v = 0; v < 6; v++) {
                    setup_487ed5(sels[s], idx);
                    if (k == 0) set32(fx.self, 0x71, 0);
                    if (k == 1) set32(fx.self, 0x6c, (uint32_t[]){0, 2, 0x100, 0x10001, 0xffffffffu, 0x80000001u}[v]);
                    if (k == 3) {
                        int i;
                        for (i = -1; i <= 4; i++)
                            set32(fx.tab, (size_t)(i + 1) * REC + 0x4d, i == idx ? (uint32_t[]){0, 2, 3, 0xffffffffu, 0x101, 0x10001}[v] : 1u);
                    }
                    if (k == 2) {
                        set32(fx.self, 0x71, 0x00000100u);      /* the dword is tested, not its low byte: this passes */
                        set32(fx.self, 0x6c, 1);
                        fx.self[0x65] = 1;
                    }
                    fx.w.value_5bb1ca = 1;
                    begin();
                    if (k == 2 && s == 0) {
                        /* all guards pass: handled below */
                        continue;
                    }
                    if (k == 2 && s == 1) {
                        X8(0x75, 1);
                        set32(xt, (size_t)(idx + 1) * REC + 0x4d, 2);
                    }
                    m487ed5_click_2788_2789(fx.self, &fx.w, &fx.host);
                    check_mem();
                    CK(L.n == 0);
                }
        /* the arms of 0x2788 */
        for (arm = 0; arm < 8; arm++)
            for (b65 = 0; b65 < 2; b65++)
                for (flag = 0; flag < 2; flag++)
                    for (d = -1; d < 3; d++) {
                        static const uint32_t slots[8] = {0, 2, 0, 0, 2, 1, 1, 3};
                        int ro23 = !(arm == 0 || arm == 1);
                        uint32_t slot = slots[arm], nslot = slot;
                        int set65 = 0, matched = 0;
                        size_t dpos = d < 0 ? 0 : d == 0 ? 0 : d == 1 ? 4 : 8;
                        eq = arm == 2 || arm == 5;
                        setup_487ed5(0x2788, idx);
                        fx.obj[0x23] = ro23 ? 0x80 : 0;
                        fx.w.value_583a29 = eq ? 0x1234 : (int16_t)0x9234;
                        set32(fx.self, 0x31, slot);
                        fx.self[0x65] = (uint8_t)b65;
                        fx.w.value_5bb1ca = flag ? 0x100u : 0;
                        if (d >= 0) {
                            fx.obj[0x4ab + dpos] ^= 0x40;
                            fx.obj[0x4dc + dpos] ^= 0x40;
                        }
                        if (arm == 0 || arm == 3) { nslot = 1; set65 = 1; }
                        if (arm == 2) { nslot = 2; matched = 1; }
                        if (arm == 4) { nslot = 3; set65 = 1; }
                        if (arm == 5) { nslot = 3; matched = 1; }
                        if (arm == 1) { fx.self[0x31] = 0x02; }
                        begin();
                        X32(0x31, nslot);
                        if (set65) { X8(0x65, 1); X16(0x6a, 0); }
                        if (set65 || b65) {
                            X16(0x68, 3);
                            X16(0x7a, 0x2222);
                            X16(0x7c, 0x3333);
                            X16(0x7e, 4);
                        }
                        X32(0x76, 4);
                        X32(0x6c, 0);
                        m487ed5_click_2788_2789(fx.self, &fx.w, &fx.host);
                        check_mem();
                        {
                            int announce = flag && d >= 0 && (set65 || b65 || matched);
                            CK(L.n == (announce ? 2 : 1));
                            if (announce) {
                                check_call(0, 0x4fb2e3, 0x5c3a67, 1);
                                check_arg(0, 0, (set65 || b65) ? 0x1234 : 0x5678, 0xffff);
                                CK(L.c[1].callee == 0x52a23c);
                            } else {
                                CK(L.c[0].callee == 0x52a23c);
                            }
                        }
                    }
        /* the queue with the count word 0, 1 (no copy), -3 (the store lands at +0x72) and 40; the store precedes the tick store */
        for (v = 0; v < 4; v++) {
            int16_t n = (int16_t[]){0, 1, -3, 40}[v];
            int j;
            setup_487ed5(0x2788, idx);
            fx.self[0x65] = 1;
            set16(fx.obj, 0x425, (uint16_t)n);
            begin();
            X16(0x68, 3);
            for (j = 0; j < n - 1; j++) memcpy(xs + 0x7a + 2 * j, fx.self + 0x7c + 2 * j, 2);
            set16(xs, (size_t)(0x78 + 2 * n), 4);
            X32(0x76, 4);
            X32(0x6c, 0);
            if (n == 40) {
                /* the copy of 39 words moves the whole run down by one word: words 0x7c.. of the original */
                for (j = 0; j < 39; j++) set16(xs, (size_t)(0x7a + 2 * j), (uint16_t)((fx.self[0x7c + 2 * j]) | (fx.self[0x7d + 2 * j] << 8)));
                set16(xs, (size_t)(0x78 + 80), 4);
            }
            m487ed5_click_2788_2789(fx.self, &fx.w, &fx.host);
            check_mem();
            CK(L.n == 1);
        }
    }
    (void)eq;
    if (g_failed) printf("FAIL test_m487ed5_click_2788_2789: %s\n", g_msg);
    else printf("PASS test_m487ed5_click_2788_2789\n");
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
    failures += test_m46793a_click_27ab_27ac();
    failures += test_m4ad310_click_2774_2776();
    failures += test_m4acf45_hit_test();
    failures += test_m4aa0f0_hit_test();
    failures += test_m487ed5_click_2788_2789();
    /* FL24B-MAIN-END */
    return failures;
}
