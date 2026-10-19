/* FL-25 (batch d) direct tests of the session input handlers of GAME.EXE in src/original_methods_fl25d.c. Prints "PASS <name>" /
 * "FAIL <name>: <msg>"; the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values were derived by
 * hand from the disassembly of GAME.EXE, not from running the native code; tests/test_fl25d_differential.py additionally runs the
 * original bytes on generated fixtures.
 *
 * Every function is checked three ways: (1) the guard matrix, each guard of the chain failing in turn (several fail values each, widths
 * probed), which must leave the object and the call log untouched; (2) each arm with the whole object compared with a hand-edited copy,
 * and the ordered host calls with their arguments and the state of the object at the call; (3) the edges of every comparison, one
 * missing by one at a time. */
#include "../src/original_methods_fl25d.h"

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

#define SELF_SZ 0x7000
#define REC 0x8d
#define TAB_SZ (REC * 6)          /* records -1 .. 4 */
#define TICK_ID 0x52a23cu
#define OBJ_VA 0x20010000u        /* the object of the target record / behind the pointer of the object */
#define DECOY_VA 0x20020000u      /* the object of every other record */
#define OBJ_SZ 0xa000
#define RECT_VA 0x20030000u       /* the rectangle argument of 0x464792 */
#define SNAP 0x7000

__attribute__((unused)) static void set32(uint8_t *o, size_t off, uint32_t v) { memcpy(o + off, &v, 4); }
__attribute__((unused)) static void set16(uint8_t *o, size_t off, uint16_t v) { memcpy(o + off, &v, 2); }
__attribute__((unused)) static int32_t get32s(const uint8_t *o, size_t off)
{
    int32_t v;
    memcpy(&v, o + off, 4);
    return v;
}

__attribute__((unused)) static int16_t get16s(const uint8_t *o, size_t off)
{
    int16_t v;
    memcpy(&v, o + off, 2);
    return v;
}

static struct {
    uint8_t self[SELF_SZ], tab[TAB_SZ], obj[OBJ_SZ], decoy[0x1000], rect[16], t3e40[0x60], t3ae8[0x20], blk[0x90], ticks[0x10];
    Fl25dWorld w;
    Fl18Host host;
} fx;
static uint8_t exp_self[SELF_SZ], exp_tab[TAB_SZ], exp_obj[OBJ_SZ];

static uint32_t g_tick;
static uint32_t g_ret_4afec1;
static uint32_t g_ret_45839e[4];
static uint32_t g_ret_4e22fd, g_ret_4d5316[8];
static int g_n_4d5316;
static int g_n_45839e;
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[6];
        uint8_t snap_self[SNAP];
        uint8_t deref[16];      /* 0x45839e: the 16 bytes behind its second argument at the call */
    } c[32];
} L;

static const uint8_t *host_resolve_fwd(uint32_t a);

__attribute__((unused)) static void log_call(uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int i;
    L.c[L.n].callee = callee;
    L.c[L.n].this_ptr = this_ptr;
    L.c[L.n].nargs = nargs;
    for (i = 0; i < nargs && i < 6; i++) L.c[L.n].a[i] = args[i];
    memcpy(L.c[L.n].snap_self, fx.self, SNAP);
    memset(L.c[L.n].deref, 0, 16);
    if (callee == 0x45839e && nargs >= 2) {
        const uint8_t *q = args[1] > 0xffffffffu ? (const uint8_t *)args[1] : host_resolve_fwd((uint32_t)args[1]);
        if (q != NULL) memcpy(L.c[L.n].deref, q, 16);
    }
    L.n++;
}

__attribute__((unused)) static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    (void)ctx;
    log_call(callee, this_ptr, args, nargs);
    if (callee == 0x45839e) return g_ret_45839e[g_n_45839e++ & 3];
    if (callee == 0x4e22fd) return g_ret_4e22fd;
    if (callee == 0x4afec1) return g_ret_4afec1;
    if (callee == 0x4d5316) return g_ret_4d5316[g_n_4d5316++ & 7];
    return 0;
}

__attribute__((unused)) static const uint8_t *host_resolve_fwd(uint32_t a)
{
    if (a >= OBJ_VA && a < OBJ_VA + OBJ_SZ) return fx.obj + (a - OBJ_VA);
    return NULL;
}

__attribute__((unused)) static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (a >= OBJ_VA && a < OBJ_VA + OBJ_SZ) return fx.obj + (a - OBJ_VA);
    if (a >= DECOY_VA && a < DECOY_VA + 0x1000) return fx.decoy + (a - DECOY_VA);
    if (a >= RECT_VA && a < RECT_VA + 16) return fx.rect + (a - RECT_VA);
    return NULL;
}

__attribute__((unused)) static uint32_t host_tick(void *ctx)
{
    (void)ctx;
    log_call(TICK_ID, 0, NULL, 0);
    return g_tick;
}

/* a pristine fixture: the object bytes 0xA5, the record object a pattern, every record in state 0 but record idx, in state 1 */
__attribute__((unused)) static void setup(int idx, uint32_t sel)
{
    int i;
    size_t k;
    memset(fx.self, 0xA5, sizeof fx.self);
    for (k = 0; k < sizeof fx.obj; k++) fx.obj[k] = (uint8_t)(k * 7 + 3);
    memset(fx.decoy, 0x11, sizeof fx.decoy);
    set32(fx.rect, 0, 0x11111111u);
    set32(fx.rect, 4, 0x22222222u);
    set32(fx.rect, 8, 0x33333333u);
    set32(fx.rect, 12, 0x44444444u);
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
    L.n = 0;
    g_tick = 0;
    g_ret_4afec1 = 0;
    memset(g_ret_45839e, 0, sizeof g_ret_45839e);
    g_ret_4e22fd = 0;
    memset(g_ret_4d5316, 0, sizeof g_ret_4d5316);
    g_n_4d5316 = 0;
    g_n_45839e = 0;
}

__attribute__((unused)) static void expect_begin(void)
{
    memcpy(exp_self, fx.self, sizeof exp_self);
    memcpy(exp_tab, fx.tab, sizeof exp_tab);
    memcpy(exp_obj, fx.obj, sizeof exp_obj);
}

__attribute__((unused)) static void expect_end_at(int line)
{
    if (!g_failed && (memcmp(exp_self, fx.self, sizeof exp_self) != 0 || memcmp(exp_tab, fx.tab, sizeof exp_tab) != 0 || memcmp(exp_obj, fx.obj, sizeof exp_obj) != 0)) {
        g_failed = 1;
        snprintf(g_msg, sizeof g_msg, "line %d: the object, the record table or the record object differs from the expected copy", line);
    }
}

#define expect_end() expect_end_at(__LINE__)

__attribute__((unused)) static void ck_call(int n, uint32_t callee, uintptr_t this_ptr, int nargs, uintptr_t a0)
{
    CK(L.n > n);
    if (L.n <= n) return;
    CK(L.c[n].callee == callee);
    CK(L.c[n].this_ptr == this_ptr);
    CK(L.c[n].nargs == nargs);
    CK(nargs < 1 || L.c[n].a[0] == a0);
}

/* the rectangle at four dword offsets of the object holds the point exactly on its edges */
__attribute__((unused)) static void rect_at(size_t ylo, size_t yhi, size_t xlo, size_t xhi, int x, int y)
{
    set32(fx.obj, ylo, (uint32_t)y);
    set32(fx.obj, yhi, (uint32_t)y);
    set32(fx.obj, xlo, (uint32_t)x);
    set32(fx.obj, xhi, (uint32_t)x);
}

/* the rectangle misses the point by one at the edge e (0 y low, 1 y high, 2 x low, 3 x high) */
__attribute__((unused)) static void rect_miss(size_t ylo, size_t yhi, size_t xlo, size_t xhi, int x, int y, int e)
{
    rect_at(ylo, yhi, xlo, xhi, x, y);
    switch (e) {
    case 0: set32(fx.obj, ylo, (uint32_t)(y + 1)); break;
    case 1: set32(fx.obj, yhi, (uint32_t)(y - 1)); break;
    case 2: set32(fx.obj, xlo, (uint32_t)(x + 1)); break;
    default: set32(fx.obj, xhi, (uint32_t)(x - 1)); break;
    }
}

/* ======================================================================================================================== 0x4712bd */

static const uint8_t K480[9] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
static const uint8_t K48C[9] = {0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19};

/* a record in state 1, the gates open, slot, R[0x21] = m, R[0x23] = c, R[0x24] = 0, the nine bytes at R+0x66 equal to the first constant, flag clear,
 * the words of the lists at +0xd4a and +0xdc2 zero, tick 1000 */
static void setup_4712bd(int idx, uint32_t sel, int slot, int m, int c)
{
    setup(idx, sel);
    memset(fx.self + 0xc90, 0, 0x180);
    fx.self[0xd3e] = 1;
    set16(fx.self, 0xd28, (uint16_t)idx);
    set16(fx.self, 0xd2a, (uint16_t)slot);
    fx.self[0xc9c + slot - 1] = 0x55;        /* the neighbours of the byte [+0xc9c + slot] are non-zero: a wider read would see them */
    fx.self[0xc9c + slot + 1] = 0x55;
    set16(fx.obj, 0x21, (uint16_t)m);
    fx.obj[0x23] = (uint8_t)c;
    fx.obj[0x24] = 0;
    memcpy(fx.obj + 0x66, K480, 9);
    set16(fx.obj, 0x87, 0xbeef);
    fx.w.bytes_54c480 = K480;
    fx.w.bytes_54c48c = K48C;
    g_tick = 1000;
}

static void run_4712bd(void) { m4712bd_click_27a6_27ad(fx.self, &fx.w, &fx.host); }

static uint32_t state_of(int idx) { return (uint32_t)get32s(fx.tab, (size_t)(idx + 1) * REC + 0x4d); }

static void test_m4712bd_click_27a6_27ad(void)
{
    (void)m4712bd_click_27a6_27ad;
    static const int idxs[] = {2, -1};
    size_t ii;
    int k, w;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        /* the gates: each fails in turn (several values), everything else open and the arms would run; the object and the call log stay untouched */
        {
            static const uint32_t d2c[] = {1, 0x100, 0x10000, 0x01000000, 0x80000000u};
            for (k = 0; k < 7; k++) {
                setup_4712bd(idx, 0x27a6, 5, 3, 1);
                fx.self[0xca1] = 1;
                fx.obj[0x24] = 1;
                fx.w.value_5bb1ca = 1;
                if (k == 0) fx.self[0xd3e] = 0;
                else if (k <= 5) set32(fx.self, 0xd2c, d2c[k - 1]);
                else set32(fx.tab, (size_t)(idx + 1) * REC + 0x4d, 2);
                if (k == 0) fx.self[0xd3f] = 0;
                expect_begin();
                run_4712bd();
                expect_end();
                CK(L.n == 0);
            }
            /* the other state values do not pass the record guard either; a state of 1 in another record does not count */
            for (k = 0; k < 4; k++) {
                static const uint32_t st[] = {0, 3, 0x101, 0xffffffffu};
                setup_4712bd(idx, 0x27ad, 5, 3, 1);
                set32(fx.tab, (size_t)(idx + 1) * REC + 0x4d, st[k]);
                set32(fx.tab, (size_t)(idx == 2 ? 4 : 1) * REC + 0x4d, 1);
                expect_begin();
                run_4712bd();
                expect_end();
                CK(L.n == 0);
            }
            /* the gate byte is a byte: a non-zero neighbour does not open it */
            setup_4712bd(idx, 0x27ad, 5, 3, 1);
            fx.self[0xd3e] = 0;
            fx.self[0xd3f] = 0;
            fx.self[0xd3d] = 1;
            fx.self[0xd3f + 1] = 1;
            expect_begin();
            run_4712bd();
            expect_end();
        }
        /* arm 1 (byte [+0xc9c + 5] and R[0x23] set): the byte is cleared; the word [+0xd4a + 2t] with t = n - 1 (0 when negative) equal to the slot
         * lowers n (0 when negative) and the word at the new n becomes 0xffff */
        {
            static const int ns[] = {3, 1, 0, -3, 2, 40};
            for (k = 0; k < 6; k++) {
                for (w = 0; w < 2; w++) {
                    int n = ns[k], t = n - 1 < 0 ? 0 : n - 1;
                    int newn = n - 1 < 0 ? 0 : n - 1;
                    setup_4712bd(idx, 0x27a6, 5, 3, 7);
                    fx.self[0xca1] = 0x80;
                    set16(fx.self, 0xd32, (uint16_t)n);
                    set16(fx.self, 0xd4a + 2 * (size_t)t, w ? 5 : 6);
                    expect_begin();
                    run_4712bd();
                    exp_self[0xca1] = 0;
                    if (w) {
                        set16(exp_self, 0xd32, (uint16_t)newn);
                        set16(exp_self, 0xd4a + 2 * (size_t)newn, 0xffff);
                    }
                    expect_end();
                    CK(L.n == 0);
                }
            }
            /* a negative slot compares as a signed word: slot -1 */
            setup_4712bd(idx, 0x27a6, -1, 3, 1);
            fx.self[0xc9b] = 3;
            set16(fx.self, 0xd32, 1);
            set16(fx.self, 0xd4a, 0xffff);
            expect_begin();
            run_4712bd();
            exp_self[0xc9b] = 0;
            set16(exp_self, 0xd32, 0);
            expect_end();
        }
        /* arm 2 (the byte clear, R[0x23] set): word [+0xd4a + 2n] = slot while n <= m - 1; n + 1 and the byte set (when it is clear); n = m when n > m */
        {
            static const int cases[][3] = {{1, 3, 0}, {2, 3, 0}, {0, 3, 0}, {3, 3, 1}, {4, 3, 1}, {5, 2, 1}, {-2, 1, 0}, {0, 0, 1}, {0, -1, 1}, {32767, 3, 1}};
            for (k = 0; k < 10; k++) {
                int n = cases[k][0], m = cases[k][1], skip_store = cases[k][2];
                int newn = (int16_t)(n + 1);
                setup_4712bd(idx, 0x27a6, 5, m, 9);
                set16(fx.self, 0xd32, (uint16_t)n);
                expect_begin();
                run_4712bd();
                if (!skip_store) set16(exp_self, (size_t)(0xd4a + 2 * n), 5);
                exp_self[0xca1] = 1;
                set16(exp_self, 0xd32, (uint16_t)(newn > m ? m : newn));
                expect_end();
                CK(L.n == 0);
            }
            /* the store goes before the increment and the clamp: after n=2, m=3 the list holds 5 at index 2 and n is 3 */
            setup_4712bd(idx, 0x27a6, 5, 3, 9);
            set16(fx.self, 0xd32, 2);
            run_4712bd();
            CK(get16s(fx.self, 0xd4a + 4) == 5 && get16s(fx.self, 0xd32) == 3 && fx.self[0xca1] == 1);
            /* the word store can clobber the byte: n = -60 stores the slot 0x36 over the byte [+0xcd2] (= [+0xc9c + 0x36]), so the byte is set already and n
             * is incremented all the same (the byte test comes after the store, and the byte is then non-zero: no increment) */
            setup_4712bd(idx, 0x27a6, 0x36, 3, 9);
            set16(fx.self, 0xd32, (uint16_t)-60);
            expect_begin();
            run_4712bd();
            set16(exp_self, 0xcd2, 0x36);
            expect_end();
            CK(get16s(fx.self, 0xd32) == -60);
        }
        /* arm 3 (R[0x23] clear): a set byte leaves the arm; otherwise n + 1 (clamped to d = word [+0xd01] when d > 0), byte, tick, [+0xd3b], the shift of the list
         * and the word [+0xd48 + 2d] = slot */
        {
            static const int cases[][2] = {{0, 1}, {3, 1}, {1, 2}, {1, 7}, {2, 2}, {6, 7}, {-1, 2}, {3, 2}, {3, -1}, {0, -1}};
            setup_4712bd(idx, 0x27a6, 5, 3, 0);
            fx.self[0xca1] = 0x40;
            set16(fx.self, 0xd32, 1);
            expect_begin();
            run_4712bd();
            expect_end();
            CK(L.n == 0);
            for (k = 0; k < 10; k++) {
                int d = cases[k][0], n = cases[k][1], j, nn = n + 1;
                setup_4712bd(idx, 0x27a6, 5, 3, 0);
                set16(fx.self, 0xd01, (uint16_t)d);
                set16(fx.self, 0xd32, (uint16_t)n);
                for (j = 0; j < 8; j++) set16(fx.self, 0xd4a + 2 * (size_t)j, (uint16_t)(0x100 + j));
                set16(fx.self, 0xd01, (uint16_t)d);
                expect_begin();
                run_4712bd();
                if (d > 0 && nn > d) nn = d;
                set16(exp_self, 0xd32, (uint16_t)nn);
                exp_self[0xca1] = 1;
                set32(exp_self, 0xe00, 1000 + 0x12c);
                exp_self[0xd3b] = 1;
                /* the shift moves each word down by one place (the source is ahead of the destination), then the slot word is stored at [+0xd48 + 2d] */
                for (j = 0; j < d - 1; j++) set16(exp_self, 0xd4a + 2 * (size_t)j, (uint16_t)(0x100 + j + 1));
                set16(exp_self, (size_t)(0xd48 + 2 * d), 5);
                expect_end();
                CK(L.n == 1 && L.c[0].callee == TICK_ID);
                /* at the tick the byte is already set and [+0xe00] and [+0xd3b] are not yet written */
                CK(L.n < 1 || (L.c[0].snap_self[0xca1] == 1 && get32s(L.c[0].snap_self, 0xe00) == 0 && L.c[0].snap_self[0xd3b] == 0));
            }
        }
        /* the list at +0xdc2: e06 > 0 (signed word) and d30 <= m - 1 (signed): the word [+0xdc2 + 2 d30] = slot, d30 + 1; checked after each arm */
        {
            static const int e06s[] = {1, 0x100, 0x7fff, 0, -1, -32768};
            static const int d30s[] = {0, 1, 2, 3, -2, 5};
            int a, e;
            for (a = 0; a < 3; a++) {
                for (e = 0; e < 6; e++) {
                    for (k = 0; k < 6; k++) {
                        int pass = e06s[e] > 0 && d30s[k] <= 2;
                        setup_4712bd(idx, 0x27a6, 5, 3, a == 2 ? 0 : 7);
                        if (a == 0) {
                            fx.self[0xca1] = 1;                 /* arm 1 with a miss: only the byte changes */
                            set16(fx.self, 0xd32, 1);
                            set16(fx.self, 0xd4a, 99);
                        } else if (a == 1) {
                            fx.self[0xca1] = 0;                 /* arm 2 */
                            set16(fx.self, 0xd32, 9);
                        } else {
                            fx.self[0xca1] = 1;                 /* arm 3 with the byte set: nothing */
                        }
                        set16(fx.self, 0xe06, (uint16_t)e06s[e]);
                        set16(fx.self, 0xd30, (uint16_t)d30s[k]);
                        expect_begin();
                        run_4712bd();
                        if (a == 0) exp_self[0xca1] = 0;
                        else if (a == 1) {
                            exp_self[0xca1] = 1;
                            set16(exp_self, 0xd32, 3);
                        }
                        if (pass) {
                            set16(exp_self, (size_t)(0xdc2 + 2 * d30s[k]), 5);
                            set16(exp_self, 0xd30, (uint16_t)(d30s[k] + 1));
                        }
                        expect_end();
                        CK(L.n == 0);
                    }
                }
            }
        }
        /* the announcement (flag set): the nine bytes at R+0x66 against the constant at 0x54c480, for every position of the first difference; the call carries
         * the zero-extended word R[0x87] and the object as it is then; byte 9 and a clear flag do not count */
        {
            for (k = -1; k <= 9; k++) {
                int f;
                for (f = 0; f < 2; f++) {
                    setup_4712bd(idx, 0x27a6, 5, 3, 7);
                    fx.self[0xca1] = 0;
                    fx.obj[0x23] = 0;
                    fx.self[0xca1] = 1;                          /* arm 3 with the byte set: no change besides the announcement */
                    fx.w.value_5bb1ca = f ? 0x100u : 0;
                    if (k >= 0) fx.obj[0x66 + k] ^= 0x40;
                    set16(fx.obj, 0x87, 0x8001);
                    expect_begin();
                    run_4712bd();
                    expect_end();
                    if (f && k >= 0 && k <= 8) {
                        ck_call(0, 0x4fb2e3, 0x5c3a67, 1, 0x8001);
                        CK(L.n == 1);
                    } else {
                        CK(L.n == 0);
                    }
                }
            }
        }
        /* slot 0x28 skips the arms (even with the selector 0x27a6); a set R[0x24] sets [+0xd3a], [+0xe00] = tick + 0x12c and announces against 0x54c48c */
        for (k = 0; k < 4; k++) {
            int r24 = k & 1, flag = k >> 1;
            setup_4712bd(idx, 0x27a6, 0x28, 3, 7);
            fx.self[0xc9c + 0x28] = 1;
            set16(fx.self, 0xd32, 3);
            fx.obj[0x24] = (uint8_t)(r24 ? 0x80 : 0);
            fx.w.value_5bb1ca = (uint32_t)flag;
            memcpy(fx.obj + 0x66, K48C, 9);
            fx.obj[0x66 + 4] ^= 1;
            set16(fx.obj, 0x87, 0x1234);
            set16(fx.self, 0xe06, 1);
            expect_begin();
            run_4712bd();
            if (r24) {
                exp_self[0xd3a] = 1;
                set32(exp_self, 0xe00, 1000 + 0x12c);
            }
            expect_end();
            if (r24 && flag) {
                CK(L.n == 2 && L.c[0].callee == TICK_ID);
                ck_call(1, 0x4fb2e3, 0x5c3a67, 1, 0x1234);
                CK(L.n < 2 || get32s(L.c[1].snap_self, 0xe00) == 1000 + 0x12c);
            } else {
                CK(L.n == (r24 ? 1 : 0));
            }
            /* the constant is the second one here: equal bytes mean no announcement; the first constant is not looked at */
            memcpy(fx.obj + 0x66, K48C, 9);
            fx.self[0xd3a] = 0;
            L.n = 0;
            run_4712bd();
            CK(L.n == (r24 ? 1 : 0));
        }
        /* the selector 0x27ad sets [+0xd3f] and the record state 2, after the other parts (a slot other than 0x28 gets no tick); the arms did not run */
        for (k = 0; k < 2; k++) {
            setup_4712bd(idx, 0x27ad, k ? 0x28 : 5, 3, 1);
            fx.self[0xc9c + (k ? 0x28 : 5)] = 1;
            fx.obj[0x24] = 1;
            set16(fx.self, 0xd32, 1);
            set16(fx.self, 0xe06, 1);
            expect_begin();
            run_4712bd();
            exp_self[0xd3f] = 1;
            if (k) {
                exp_self[0xd3a] = 1;
                set32(exp_self, 0xe00, 1000 + 0x12c);
            }
            set32(exp_tab, (size_t)(idx + 1) * REC + 0x4d, 2);
            expect_end();
            CK(state_of(idx) == 2 && L.n == (k ? 1 : 0));
        }
        /* another selector: only the slot 0x28 tail */
        setup_4712bd(idx, 0x27a7, 5, 3, 1);
        fx.obj[0x24] = 1;
        fx.self[0xca1] = 1;
        expect_begin();
        run_4712bd();
        expect_end();
        CK(L.n == 0);
    }
}

/* ======================================================================================================================== 0x4b2250 */

#define B4 0x400   /* the object `this` sits 0x400 bytes into fx.self: the original reads below it (R.w21 = 0 reads this - 0x179) */

static size_t cell(int a, int b, int off) { return (size_t)(B4 + 0x43 + a * 0x1e4 + b * 0x2c + off); }

/* all-zero object (this = fx.self + B4), the gate open, no cell set (every w1a is 0), the record object zero with the counts w21 and w23, X = Y = 0 */
static void setup_4b2250(int idx, int w21, int w23)
{
    setup(idx, 0);
    memset(fx.self, 0, SELF_SZ);
    memset(fx.obj, 0, 0x1000);
    set32(fx.self, B4 + 0x1515, 1);
    set16(fx.self, B4 + 0x1e, (uint16_t)idx);
    set16(fx.obj, 0x21, (uint16_t)w21);
    set16(fx.obj, 0x23, (uint16_t)w23);
}

static int run_4b2250(int x, int y) { return m4b2250_hit_test(fx.self + B4, (int16_t)x, (int16_t)y, &fx.w, &fx.host); }

/* a type-5 cell (w1a = 1, w18 = 5) at (a, b) */
static void t5(int a, int b)
{
    set16(fx.self, cell(a, b, 0x1a), 1);
    set16(fx.self, cell(a, b, 0x18), 5);
}

static void test_m4b2250_hit_test(void)
{
    (void)m4b2250_hit_test;
    static const int idxs[] = {2, -1};
    size_t ii;
    int e, k;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        /* the gates: dword [+0x1515] clear returns 0 (a set byte beside it does not count), [+0x24] 2 or 1 returns 0; any other value passes (the words are cleared:
         * Y = 0 > the dword at [(w21 - 1) * 0x1e4 + 0x6b] = -1) */
        for (k = 0; k < 7; k++) {
            static const uint32_t g24[] = {0, 3, 0x100, 0xffffffffu, 2, 1};
            setup_4b2250(idx, 1, 1);
            set16(fx.self, B4 + 0x1531, 0xaaaa);
            set16(fx.self, B4 + 0x1533, 0xbbbb);
            set32(fx.self, cell(0, 0, 0x28), 0xffffffffu);
            if (k == 6) {
                set32(fx.self, B4 + 0x1515, 0);
                fx.self[B4 + 0x1514] = 1;
                fx.self[B4 + 0x1519] = 1;
            } else {
                set32(fx.self, B4 + 0x24, g24[k]);
            }
            expect_begin();
            CK(run_4b2250(1, 1) == 0);
            if (k < 4) {
                set16(exp_self, B4 + 0x1531, 0);
                set16(exp_self, B4 + 0x1533, 0);
            }
            expect_end();
            CK(L.n == 0);
        }
        /* the clearing tests, each alone (each boundary): Y <= [(w21 - 1) * 0x1e4 + 0x6b], X <= [(w23 - 1) * 0x2c + 0x67], X >= [0x5f]; the first failing one clears */
        for (k = 0; k < 7; k++) {
            /* k 0: none; 1: Y one above its limit; 2: X one above; 3: X one below; 4 to 6: the three limits sit on the point (no clearing) */
            int x = 5, y = 9;
            setup_4b2250(idx, 3, 2);
            set16(fx.self, B4 + 0x1531, 0xaaaa);
            set16(fx.self, B4 + 0x1533, 0xbbbb);
            set32(fx.self, B4 + 0x6b + 2 * 0x1e4, (uint32_t)(k == 1 ? y - 1 : k == 4 ? y : y + 1000));
            set32(fx.self, B4 + 0x67 + 1 * 0x2c, (uint32_t)(k == 2 ? x - 1 : k == 5 ? x : x + 1000));
            set32(fx.self, 0x5f + B4, (uint32_t)(k == 3 ? x + 1 : k == 6 ? x : x - 1000));
            expect_begin();
            CK(run_4b2250(x, y) == 0);
            if (k >= 1 && k <= 3) {
                set16(exp_self, B4 + 0x1531, 0);
                set16(exp_self, B4 + 0x1533, 0);
            }
            expect_end();
            CK(L.n == 0);
        }
        /* a cell that is not type 5 (word [+0x18] != 5) with a code: the box test, each edge, at the cell (1, 2): [+0x3f] = 1, [+0x41] = 2, 0x4afec1(this, code);
         * 1 from it calls 0x4b2917(this, code) and returns 1, any other answer returns 0 */
        for (e = -1; e < 4; e++) {
            static const uint32_t ans[] = {1, 0, 2, 0x100, 0xffffffffu};
            int a;
            for (a = 0; a < 5; a++) {
                int x = 10, y = 20;
                setup_4b2250(idx, 2, 3);
                set16(fx.self, cell(1, 2, 0x1a), (uint16_t)(a == 4 ? 0x8000 : 0x1234));
                set16(fx.self, cell(1, 2, 0x18), (uint16_t)(a == 2 ? 0x7fff : 4));
                set32(fx.self, cell(1, 2, 0x20), 15);
                set32(fx.self, cell(1, 2, 0x28), 25);
                set32(fx.self, cell(1, 2, 0x1c), 5);
                set32(fx.self, cell(1, 2, 0x24), 15);
                if (e == 0) set32(fx.self, cell(1, 2, 0x20), (uint32_t)(y + 1));
                if (e == 1) set32(fx.self, cell(1, 2, 0x28), (uint32_t)(y - 1));
                if (e == 2) set32(fx.self, cell(1, 2, 0x1c), (uint32_t)(x + 1));
                if (e == 3) set32(fx.self, cell(1, 2, 0x24), (uint32_t)(x - 1));
                if (e < 0 && a == 0) {          /* the edges themselves hold */
                    set32(fx.self, cell(1, 2, 0x20), (uint32_t)y);
                    set32(fx.self, cell(1, 2, 0x28), (uint32_t)y);
                    set32(fx.self, cell(1, 2, 0x1c), (uint32_t)x);
                    set32(fx.self, cell(1, 2, 0x24), (uint32_t)x);
                }
                g_ret_4afec1 = ans[a];
                expect_begin();
                {
                    int r = run_4b2250(x, y);
                    if (e < 0) {
                        uint16_t code = (uint16_t)(a == 4 ? 0x8000 : 0x1234);
                        CK(r == (ans[a] == 1 ? 1 : 0));
                        set16(exp_self, B4 + 0x3f, 1);
                        set16(exp_self, B4 + 0x41, 2);
                        if (a == 2) {
                            /* word [+0x18] = 0x7fff is not 5: still the box path */
                        }
                        CK(L.n == (ans[a] == 1 ? 2 : 1));
                        ck_call(0, 0x4afec1, (uintptr_t)(fx.self + B4), 1, code);
                        if (ans[a] == 1) ck_call(1, 0x4b2917, (uintptr_t)(fx.self + B4), 1, code);
                        CK(L.n < 1 || (get16s(L.c[0].snap_self, B4 + 0x3f) == 1 && get16s(L.c[0].snap_self, B4 + 0x41) == 2));
                    } else {
                        /* a missed edge: no code, the loops run out; the record object has no rectangle (all zero, point (10, 20) is outside [0, 0]) */
                        CK(r == 0 && L.n == 0);
                    }
                }
                expect_end();
            }
        }
        /* w1a == 0 never gives a code, w18 == 5 or not (the point (1, 1) is inside the all-zero box? no: it is outside, but the fields are zero and the point is inside
         * the box [0, 1]) */
        for (k = 0; k < 2; k++) {
            setup_4b2250(idx, 1, 1);
            set16(fx.self, cell(0, 0, 0x18), (uint16_t)(k ? 5 : 4));
            set32(fx.self, cell(0, 0, 0x28), 1);
            set32(fx.self, cell(0, 0, 0x24), 1);
            expect_begin();
            CK(run_4b2250(1, 1) == 0);
            expect_end();
            CK(L.n == 0);
        }
        /* type 5, all fields zero, X = Y = 0, q1 = q2 = 0: the four blocks hold in turn; B = 1, A = 1, code 0x2794, then block 4: code 0x2797, A = 2, B = 2 */
        setup_4b2250(idx, 1, 1);
        t5(0, 0);
        g_ret_4afec1 = 1;
        expect_begin();
        CK(run_4b2250(0, 0) == 1);
        set16(exp_self, B4 + 0x3f, 2);
        set16(exp_self, B4 + 0x41, 2);
        expect_end();
        CK(L.n == 2);
        ck_call(0, 0x4afec1, (uintptr_t)(fx.self + B4), 1, 0x2797);
        ck_call(1, 0x4b2917, (uintptr_t)(fx.self + B4), 1, 0x2797);
        /* the point is x + dword 0x583186 and y + dword 0x58318a, 32-bit, from the sign-extended words */
        setup_4b2250(idx, 1, 1);
        t5(0, 0);
        fx.w.value_583186 = 32768;
        fx.w.value_58318a = 0xfffffff9u;
        g_ret_4afec1 = 0;
        CK(run_4b2250(-32768, 7) == 0 && L.n == 1);
        ck_call(0, 0x4afec1, (uintptr_t)(fx.self + B4), 1, 0x2797);
        /* block 1 fails at its first test (c.20 = 1 > Y): block 2 on the row below holds (A = 1, 0x2796), block 3 at (1, 0) holds, block 4 at (1, 0) holds
         * and moves B to 1 and A to 2: code 0x2797, [+0x3f] = 2, [+0x41] = 1 */
        setup_4b2250(idx, 1, 1);
        t5(0, 0);
        set32(fx.self, cell(0, 0, 0x20), 1);
        g_ret_4afec1 = 0;
        expect_begin();
        CK(run_4b2250(0, 0) == 0);
        set16(exp_self, B4 + 0x3f, 2);
        set16(exp_self, B4 + 0x41, 1);
        expect_end();
        ck_call(0, 0x4afec1, (uintptr_t)(fx.self + B4), 1, 0x2797);
        /* all four hold up to block 4, whose X >= (1, 2).24 - q2 fails (the dword is 1): code 0x2794 from block 3 at (1, 1), A = 1, B = 1 */
        setup_4b2250(idx, 1, 1);
        t5(0, 0);
        set32(fx.self, cell(1, 2, 0x24), 1);
        g_ret_4afec1 = 0;
        expect_begin();
        CK(run_4b2250(0, 0) == 0);
        set16(exp_self, B4 + 0x3f, 1);
        set16(exp_self, B4 + 0x41, 1);
        expect_end();
        ck_call(0, 0x4afec1, (uintptr_t)(fx.self + B4), 1, 0x2794);
        /* and block 3 fails as well (X >= (1, 1).1c: the dword is 1): the code stays 0x2796 from block 2 */
        setup_4b2250(idx, 1, 1);
        t5(0, 0);
        set32(fx.self, cell(1, 2, 0x24), 1);
        set32(fx.self, cell(1, 1, 0x1c), 1);
        g_ret_4afec1 = 0;
        CK(run_4b2250(0, 0) == 0);
        ck_call(0, 0x4afec1, (uintptr_t)(fx.self + B4), 1, 0x2796);
        CK(get16s(fx.self, B4 + 0x3f) == 1 && get16s(fx.self, B4 + 0x41) == 1);
        /* block 2 fails on Y >= (1, 1).28 - q1 (the dword is 1) and block 4 on X >= (0, 2).24 - q2: block 3 at (0, 1) holds, A = 0, B = 1, code 0x2794 */
        setup_4b2250(idx, 1, 1);
        t5(0, 0);
        set32(fx.self, cell(1, 1, 0x28), 1);
        set32(fx.self, cell(0, 2, 0x24), 1);
        g_ret_4afec1 = 0;
        CK(run_4b2250(0, 0) == 0);
        ck_call(0, 0x4afec1, (uintptr_t)(fx.self + B4), 1, 0x2794);
        CK(get16s(fx.self, B4 + 0x3f) == 0 && get16s(fx.self, B4 + 0x41) == 1);
        /* and block 3 fails on X >= (0, 1).1c (the dword is 1): only block 1 is left, code 0x2795, A = 0, B = 1 */
        setup_4b2250(idx, 1, 1);
        t5(0, 0);
        set32(fx.self, cell(1, 1, 0x28), 1);
        set32(fx.self, cell(0, 2, 0x24), 1);
        set32(fx.self, cell(0, 1, 0x1c), 1);
        g_ret_4afec1 = 0;
        CK(run_4b2250(0, 0) == 0);
        ck_call(0, 0x4afec1, (uintptr_t)(fx.self + B4), 1, 0x2795);
        CK(get16s(fx.self, B4 + 0x3f) == 0 && get16s(fx.self, B4 + 0x41) == 1);
        /* the quotients: q1 = dword [+0x152d] / 4 and q2 = dword [+0x1529] / 4, toward zero: -3 gives 0 (an arithmetic shift alone would give -1: the
         * blocks would then end with A = B = 1), 4 gives 1, -5 gives -1; each case derived by hand from the four blocks at X = Y = 0 and an all-zero grid */
        {
            static const struct { size_t off; int32_t raw; int code, a, b; } qs[] = {
                {0x152d, -3, 0x2797, 2, 2}, {0x152d, 3, 0x2797, 2, 2}, {0x152d, 4, 0x2796, 1, 1}, {0x152d, -5, 0x2797, 1, 1},
                {0x1529, -3, 0x2797, 2, 2}, {0x1529, 3, 0x2797, 2, 2}, {0x1529, 4, 0x2797, 1, 1}, {0x1529, -5, 0x2796, 1, 1}};
            for (k = 0; k < 8; k++) {
                setup_4b2250(idx, 1, 1);
                t5(0, 0);
                set32(fx.self, B4 + qs[k].off, (uint32_t)qs[k].raw);
                g_ret_4afec1 = 0;
                CK(run_4b2250(0, 0) == 0);
                ck_call(0, 0x4afec1, (uintptr_t)(fx.self + B4), 1, (uintptr_t)qs[k].code);
                CK(get16s(fx.self, B4 + 0x3f) == qs[k].a && get16s(fx.self, B4 + 0x41) == qs[k].b);
            }
        }
        /* the rectangles of the record object, no code: byte [R+0x17d] clear: y in [R.370, R.378], x in [R.36c, R.374] (the point itself, not X and Y) calls
         * 0x4b2917(0x2793) and returns 1; set (any non-zero byte, its neighbours are non-zero): y in [R.192, R.19a], x in [R.18e, R.196], 0x4b2917(0x2792) */
        for (k = 0; k < 2; k++) {
            for (e = -1; e < 4; e++) {
                int x = -7, y = 11, base = k ? 0x192 : 0x370;
                setup_4b2250(idx, 0, 0);
                fx.w.value_583186 = 1000;
                fx.w.value_58318a = 2000;
                fx.obj[0x17d] = (uint8_t)(k ? 0x80 : 0);
                fx.obj[0x17c] = 0x55;
                fx.obj[0x17e] = 0x55;
                set32(fx.obj, (size_t)base, (uint32_t)y);              /* y low, y high at +8, x low at -4 (0x36c / 0x18e), x high at +4 */
                set32(fx.obj, (size_t)base + 8, (uint32_t)y);
                set32(fx.obj, (size_t)base - 4, (uint32_t)x);
                set32(fx.obj, (size_t)base + 4, (uint32_t)x);
                if (e == 0) set32(fx.obj, (size_t)base, (uint32_t)(y + 1));
                if (e == 1) set32(fx.obj, (size_t)base + 8, (uint32_t)(y - 1));
                if (e == 2) set32(fx.obj, (size_t)base - 4, (uint32_t)(x + 1));
                if (e == 3) set32(fx.obj, (size_t)base + 4, (uint32_t)(x - 1));
                expect_begin();
                CK(run_4b2250(x, y) == (e < 0 ? 1 : 0));
                expect_end();
                if (e < 0) {
                    CK(L.n == 1);
                    ck_call(0, 0x4b2917, (uintptr_t)(fx.self + B4), 1, k ? 0x2792 : 0x2793);
                } else {
                    CK(L.n == 0);
                }
            }
        }
        /* the other byte's rectangle is not looked at: byte clear with only the second rectangle holding, byte set with only the first */
        for (k = 0; k < 2; k++) {
            setup_4b2250(idx, 0, 0);
            fx.obj[0x17d] = (uint8_t)(k ? 0 : 0x80);
            set32(fx.obj, k ? 0x192 : 0x370, 3);
            set32(fx.obj, k ? 0x19a : 0x378, 3);
            set32(fx.obj, k ? 0x18e : 0x36c, 3);
            set32(fx.obj, k ? 0x196 : 0x374, 3);
            CK(run_4b2250(3, 3) == 0 && L.n == 0);
        }
    }
}

/* ======================================================================================================================== 0x46bca9 */

/* the cell (i, j) of the scan s (1: +0x4a6a, 2: +0x636a): y in [ylo, yhi], x in [xlo, xhi] */
static void set_cell(int s, int i, int j, int ylo, int yhi, int xlo, int xhi)
{
    size_t c = (size_t)((s == 1 ? 0x4a6a : 0x636a) + i * 0x140 + j * 16);
    set32(fx.self, c + 4, (uint32_t)ylo);
    set32(fx.self, c + 0xc, (uint32_t)yhi);
    set32(fx.self, c, (uint32_t)xlo);
    set32(fx.self, c + 8, (uint32_t)xhi);
}

/* the entry k of the scan s: dword flag, words i and j */
static void set_entry(int s, int k, uint32_t flag, int i, int j)
{
    size_t e = (size_t)((s == 1 ? 0x48a0 : 0x48a4) + 16 * k);
    set32(fx.self, e, flag);
    set16(fx.self, e + 8, (uint16_t)i);
    set16(fx.self, e + 0xa, (uint16_t)j);
}

/* the gate open, mode A or B, every cell far from the point (-7, 11), the record object counts, the rectangle argument four distinct dwords */
static void setup_46bca9(int idx, int mode_a, int w43, int w45, int w47, int w49, int w4f)
{
    int s, i, j, k;
    setup(idx, 0);
    memset(fx.self, 0, SELF_SZ);
    memset(fx.obj, 0, 0x1000);
    set32(fx.self, 0x4a48, 1);
    set32(fx.self, 0x4a2c, mode_a ? 0x100u : 0u);
    set16(fx.self, 0x1e, (uint16_t)idx);
    set16(fx.obj, 0x43, (uint16_t)w43);
    set16(fx.obj, 0x45, (uint16_t)w45);
    set16(fx.obj, 0x47, (uint16_t)w47);
    set16(fx.obj, 0x49, (uint16_t)w49);
    set16(fx.obj, 0x4f, (uint16_t)w4f);
    for (s = 1; s <= 2; s++) {
        for (i = 0; i < 4; i++)
            for (j = 0; j < 4; j++) set_cell(s, i, j, 1000, 2000, 1000, 2000);
        for (k = 0; k < 4; k++) set_entry(s, k, 0, 0, 0);
    }
    /* the rectangle of the tail is far away as well */
    set32(fx.obj, 0x6d5, 1000);
    set32(fx.obj, 0x6dd, 2000);
    set32(fx.obj, 0x6d1, 1000);
    set32(fx.obj, 0x6d9, 2000);
}

static int run_46bca9(int x, int y) { return m46bca9_hit_test(fx.self, (int16_t)x, (int16_t)y, RECT_VA, &fx.w, &fx.host); }

/* the writes that every run makes after the gate */
static void expect_prologue_46bca9(void)
{
    set16(exp_self, 0x4a50, 0xffff);
    set16(exp_self, 0x4a52, 0xffff);
    set32(exp_self, 0x4a5e, 0x22222222u);
    set32(exp_self, 0x4a66, 0x44444444u);
    set32(exp_self, 0x4a5a, 0x11111111u);
    set32(exp_self, 0x4a62, 0x33333333u);
}

static void ck_call4(int n, uint32_t msg, int i, int j, int k)
{
    CK(L.n > n);
    if (L.n <= n) return;
    CK(L.c[n].callee == 0x46c41e && L.c[n].this_ptr == (uintptr_t)fx.self && L.c[n].nargs == 4);
    CK(L.c[n].a[0] == msg && (uint32_t)L.c[n].a[1] == (uint32_t)i && (uint32_t)L.c[n].a[2] == (uint32_t)j && (uint32_t)L.c[n].a[3] == (uint32_t)k);
}

static void test_m46bca9_hit_test(void)
{
    (void)m46bca9_hit_test;
    static const int idxs[] = {2, -1};
    size_t ii;
    int k, e, s, mode;
    const int px = -7, py = 11;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        /* the gate: dword [+0x4a48] clear returns 0 and writes nothing (a set neighbour byte does not count); any non-zero value opens it */
        setup_46bca9(idx, 1, 2, 2, 2, 2, 2);
        set32(fx.self, 0x4a48, 0);
        fx.self[0x4a47] = 1;
        fx.self[0x4a4c] = 1;
        expect_begin();
        CK(run_46bca9(px, py) == 0);
        expect_end();
        CK(L.n == 0);
        setup_46bca9(idx, 1, 2, 2, 2, 2, 2);
        set32(fx.self, 0x4a48, 0x01000000u);
        CK(run_46bca9(px, py) == 1);
        CK(L.n == 1 && L.c[0].callee == 0x46b954);
        /* mode A (dword [+0x4a2c] != 0), nothing found: the announcement globals (the quotient 0x24 * 32 + 0 * 16 + 0x5b160c) and return 1 */
        setup_46bca9(idx, 1, 2, 2, 2, 2, 2);
        fx.w.value_5d0377 = 0xabcdef01u;
        expect_begin();
        CK(run_46bca9(px, py) == 1);
        expect_prologue_46bca9();
        expect_end();
        CK(L.n == 1 && L.c[0].callee == 0x46b954 && L.c[0].this_ptr == (uintptr_t)fx.self && L.c[0].nargs == 0);
        CK(get16s(L.c[0].snap_self, 0x4a50) == -1 && get32s(L.c[0].snap_self, 0x4a62) == 0x33333333);
        CK(fx.w.value_5b44f0 == 0x24 && fx.w.value_5b44f4 == 0 && fx.w.value_5d162d == 0xabcdef01u && fx.w.value_5d1631 == 0x5b1a8cu && fx.w.value_5d1639 == 1);
        /* the stage 1 cell (1, 2) holds the point (every edge exactly on it): the entries 0 to 1 fail one condition each (flag, i, j), entry 2 matches:
         * 0x46c41e(self, 0x27e2, i = 1, j = 2, k = 2); a cell before it in the order (0, 0) would win, a cell after it (1, 3) does not */
        for (mode = 0; mode < 2; mode++) {
            for (s = 1; s <= 2; s++) {
                for (k = -1; k < 3; k++) {
                    /* k -1: no entry matches (the count is 3 and every entry fails); 0 to 2: the entry k matches, the ones before it fail by flag, i, j in turn */
                    int ok = k >= 0, f;
                    setup_46bca9(idx, !mode, 3, 4, 3, 4, 3);
                    set_cell(s, 1, 2, py, py, px, px);
                    set_cell(s, 1, 3, py - 5, py + 5, px - 5, px + 5);
                    for (f = 0; f < 3; f++) {
                        uint32_t flag = f == 0 ? 2u : 1u;
                        int ei = f == 1 ? 0 : 1, ej = f == 2 ? 1 : 2;
                        if (ok && f >= k) break;
                        set_entry(s, f, flag, ei, ej);
                    }
                    if (ok) set_entry(s, k, 1, 1, 2);
                    expect_begin();
                    CK(run_46bca9(px, py) == 1);
                    expect_prologue_46bca9();
                    expect_end();
                    if (!mode) {
                        CK(L.n == 2 && L.c[0].callee == 0x46b954);
                        ck_call4(1, (uint32_t)(s == 1 ? (ok ? 0x27e2 : 0x27e3) : (ok ? 0x27e4 : 0x27e5)), 1, 2, ok ? k : -1);
                    } else {
                        CK(L.n == 1);
                        ck_call4(0, (uint32_t)(s == 1 ? (ok ? 0x27e6 : 0x27e7) : (ok ? 0x27e8 : 0x27e9)), 1, 2, ok ? k : -1);
                    }
                    CK(fx.w.value_5b44f0 == 0);
                }
            }
        }
        /* the entry count R[0x4f] bounds the search (a signed word): a matching entry at index 1 is not found when the count is 1, and a count of -1 finds none
         * (the cell holds the point: 0x46c41e(self, 0x27e3, 1, 2, -1)) */
        for (k = 0; k < 2; k++) {
            setup_46bca9(idx, 1, 3, 4, 3, 4, k ? -1 : 1);
            set_cell(1, 1, 2, py, py, px, px);
            set_entry(1, 1, 1, 1, 2);
            if (k) set_entry(1, 0, 1, 1, 2);
            CK(run_46bca9(px, py) == 1 && L.n == 2);
            ck_call4(1, 0x27e3, 1, 2, -1);
        }
        /* the order: row-major, the first holding cell wins: (0, 1) before (1, 0) */
        setup_46bca9(idx, 1, 2, 2, 2, 2, 1);
        set_cell(1, 1, 0, py, py, px, px);
        set_cell(1, 0, 1, py, py, px, px);
        set_entry(1, 0, 1, 0, 1);
        CK(run_46bca9(px, py) == 1 && L.n == 2);
        ck_call4(1, 0x27e2, 0, 1, 0);
        /* the bounds: the cell (1, 2) is not scanned when R[0x43] = 1 or R[0x45] = 2; stage 2 of mode A uses R[0x43] x R[0x45] (not 0x47 / 0x49), stage 2 of
         * mode B uses R[0x47] x R[0x49] (not 0x43 / 0x45) */
        setup_46bca9(idx, 1, 1, 3, 3, 3, 1);
        set_cell(1, 1, 2, py, py, px, px);
        set_cell(2, 1, 2, py, py, px, px);
        CK(run_46bca9(px, py) == 1 && L.n == 1 && fx.w.value_5b44f0 == 0x24);
        setup_46bca9(idx, 1, 2, 2, 3, 3, 1);
        set_cell(2, 1, 1, py, py, px, px);
        set_entry(2, 0, 1, 1, 1);
        CK(run_46bca9(px, py) == 1 && L.n == 2);
        ck_call4(1, 0x27e4, 1, 1, 0);
        setup_46bca9(idx, 1, 3, 3, 1, 1, 1);        /* the bounds 0x47 / 0x49 do not matter for mode A */
        set_cell(2, 1, 1, py, py, px, px);
        set_entry(2, 0, 1, 1, 1);
        CK(run_46bca9(px, py) == 1 && L.n == 2);
        ck_call4(1, 0x27e4, 1, 1, 0);
        setup_46bca9(idx, 0, 1, 1, 2, 2, 1);        /* mode B, stage 2 with 0x47 / 0x49 = 2 x 2 reaches (1, 1), 0x43 / 0x45 = 1 x 1 would not */
        set_cell(2, 1, 1, py, py, px, px);
        set_entry(2, 0, 1, 1, 1);
        CK(run_46bca9(px, py) == 1 && L.n == 1);
        ck_call4(0, 0x27e8, 1, 1, 0);
        setup_46bca9(idx, 0, 2, 2, 1, 1, 1);        /* and 0x43 / 0x45 = 2 x 2 do not matter for stage 2 of mode B */
        set_cell(2, 1, 1, py, py, px, px);
        CK(run_46bca9(px, py) == 0 && L.n == 0);
        /* each edge of the target cell missing by one lets the scans continue (mode A: the globals and 1; mode B: the rectangle, here absent: 0) */
        for (mode = 0; mode < 2; mode++) {
            for (s = 1; s <= 2; s++) {
                for (e = 0; e < 4; e++) {
                    setup_46bca9(idx, !mode, 2, 2, 2, 2, 1);
                    set_cell(s, 1, 1, py, py, px, px);
                    if (e == 0) set_cell(s, 1, 1, py + 1, py, px, px);
                    if (e == 1) set_cell(s, 1, 1, py, py - 1, px, px);
                    if (e == 2) set_cell(s, 1, 1, py, py, px + 1, px);
                    if (e == 3) set_cell(s, 1, 1, py, py, px, px - 1);
                    set_entry(s, 0, 1, 1, 1);
                    CK(run_46bca9(px, py) == (mode ? 0 : 1));
                    CK(L.n == (mode ? 0 : 1));
                }
            }
        }
        /* the rectangle of mode B: y in [R.6d5, R.6dd], x in [R.6d1, R.6d9]; a hit calls 0x46c41e(self, 0x27ea, 0, 0, -1) and returns 1; the point itself is used */
        for (e = -1; e < 4; e++) {
            setup_46bca9(idx, 0, 1, 1, 1, 1, 0);
            set32(fx.obj, 0x6d5, (uint32_t)(e == 0 ? py + 1 : py));
            set32(fx.obj, 0x6dd, (uint32_t)(e == 1 ? py - 1 : py));
            set32(fx.obj, 0x6d1, (uint32_t)(e == 2 ? px + 1 : px));
            set32(fx.obj, 0x6d9, (uint32_t)(e == 3 ? px - 1 : px));
            expect_begin();
            CK(run_46bca9(px, py) == (e < 0 ? 1 : 0));
            expect_prologue_46bca9();
            expect_end();
            if (e < 0) {
                CK(L.n == 1);
                ck_call4(0, 0x27ea, 0, 0, -1);
            } else {
                CK(L.n == 0);
            }
        }
        /* mode A never looks at the rectangle: it returns 1 with the globals instead */
        setup_46bca9(idx, 1, 1, 1, 1, 1, 0);
        set32(fx.obj, 0x6d5, (uint32_t)py);
        set32(fx.obj, 0x6dd, (uint32_t)py);
        set32(fx.obj, 0x6d1, (uint32_t)px);
        set32(fx.obj, 0x6d9, (uint32_t)px);
        CK(run_46bca9(px, py) == 1 && L.n == 1 && L.c[0].callee == 0x46b954);
    }
}

/* ---- a bounded random sweep (meant for the sanitiser builds) ----------------------------------------------------------------- */

static uint32_t g_seed = 0x2545f491u;
static uint32_t rnd(void)
{
    g_seed ^= g_seed << 13;
    g_seed ^= g_seed >> 17;
    g_seed ^= g_seed << 5;
    return g_seed;
}

static int rr(int lo, int hi) { return lo + (int)(rnd() % (uint32_t)(hi - lo + 1)); }

static void test_sweep(void)
{
    int it, f;
    for (f = 0; f < 3; f++) {
        for (it = 0; it < 2500; it++) {
            int idx = rr(-1, 4);
            setup(idx, 0);
            switch (f) {
            case 0:
            {
                int slot = rr(-3, 0x2a), idx2 = idx;
                size_t q;
                setup_4712bd(idx2, (uint32_t)(rnd() & 3 ? 0x27a6 : (rnd() & 1 ? 0x27ad : 0)), slot, rr(-1, 5), rnd() & 1 ? 1 : 0);
                for (q = 0xc9c; q < 0xcdc; q++) fx.self[q] = (uint8_t)(rnd() & 1);
                fx.self[0xd3e] = rnd() & 7 ? 1 : 0;
                set32(fx.self, 0xd2c, rnd() & 7 ? 0u : 1u);
                set16(fx.self, 0xd2a, (uint16_t)(rnd() & 7 ? slot : 0x28));
                set16(fx.self, 0xd32, (uint16_t)(int16_t)rr(-4, 6));
                set16(fx.self, 0xd30, (uint16_t)(int16_t)rr(-3, 6));
                set16(fx.self, 0xe06, (uint16_t)(int16_t)rr(-1, 2));
                set16(fx.self, 0xd01, (uint16_t)(int16_t)rr(-1, 5));
                for (q = 0; q < 12; q++) set16(fx.self, 0xd42 + 2 * q, (uint16_t)(rnd() & 3 ? (rnd() & 7) : 0xffff));
                fx.obj[0x24] = (uint8_t)(rnd() & 1);
                fx.w.value_5bb1ca = rnd() & 1;
                if (rnd() & 1) fx.obj[0x66 + rnd() % 10] ^= 1;
                g_tick = rnd();
                m4712bd_click_27a6_27ad(fx.self, &fx.w, &fx.host);
                break;
            }
            case 1:
            {
                int w21 = rr(-1, 3), w23 = rr(-1, 3), a, b;
                int16_t x = (int16_t)rr(-3, 3), y = (int16_t)rr(-3, 3);
                setup_4b2250(idx, w21, w23);
                set32(fx.self, B4 + 0x1515, rnd() & 7 ? 1u : 0u);
                set32(fx.self, B4 + 0x24, rnd() & 3 ? 0u : 1u + (rnd() & 1));
                set32(fx.self, B4 + 0x152d, (uint32_t)rr(-9, 9));
                set32(fx.self, B4 + 0x1529, (uint32_t)rr(-9, 9));
                set16(fx.self, B4 + 0x1531, 0xaaaa);
                fx.w.value_583186 = (uint32_t)rr(-2, 2);
                fx.w.value_58318a = (uint32_t)rr(-2, 2);
                for (a = 0; a < 5; a++) {
                    for (b = 0; b < 5; b++) {
                        set16(fx.self, cell(a, b, 0x1a), (uint16_t)(rnd() & 3 ? rr(-1, 2) : 0));
                        set16(fx.self, cell(a, b, 0x18), (uint16_t)(rnd() & 1 ? 5 : rr(0, 6)));
                        set32(fx.self, cell(a, b, 0x1c), (uint32_t)rr(-2, 2));
                        set32(fx.self, cell(a, b, 0x20), (uint32_t)rr(-2, 2));
                        set32(fx.self, cell(a, b, 0x24), (uint32_t)rr(-2, 2));
                        set32(fx.self, cell(a, b, 0x28), (uint32_t)rr(-2, 2));
                    }
                }
                fx.obj[0x17d] = (uint8_t)(rnd() & 1);
                for (a = 0x36c; a < 0x37c; a += 4) set32(fx.obj, (size_t)a, (uint32_t)rr(-3, 3));
                for (a = 0x18e; a < 0x19e; a += 4) set32(fx.obj, (size_t)a, (uint32_t)rr(-3, 3));
                g_ret_4afec1 = (uint32_t)(rnd() & 1);
                m4b2250_hit_test(fx.self + B4, x, y, &fx.w, &fx.host);
                break;
            }
            case 2:
            {
                int16_t x = (int16_t)rr(-3, 3), y = (int16_t)rr(-3, 3);
                int s, i, j, k;
                setup_46bca9(idx, rnd() & 1, rr(-1, 3), rr(-1, 3), rr(-1, 3), rr(-1, 3), rr(-1, 3));
                set32(fx.self, 0x4a48, rnd() & 7 ? 1u : 0u);
                for (s = 1; s <= 2; s++) {
                    for (i = 0; i < 4; i++)
                        for (j = 0; j < 4; j++) set_cell(s, i, j, rr(-3, 3), rr(-3, 3), rr(-3, 3), rr(-3, 3));
                    for (k = 0; k < 4; k++) set_entry(s, k, (uint32_t)(rnd() & 1), rr(-1, 3), rr(-1, 3));
                }
                set32(fx.obj, 0x6d5, (uint32_t)rr(-3, 3));
                set32(fx.obj, 0x6dd, (uint32_t)rr(-3, 3));
                set32(fx.obj, 0x6d1, (uint32_t)rr(-3, 3));
                set32(fx.obj, 0x6d9, (uint32_t)rr(-3, 3));
                m46bca9_hit_test(fx.self, x, y, RECT_VA, &fx.w, &fx.host);
                break;
            }
            default: break;
            }
        }
    }
}

/* ---- the table of cases ------------------------------------------------------------------------------------------------------- */

static const struct {
    const char *name;
    void (*fn)(void);
} CASES[] = {
    {"test_m4712bd_click_27a6_27ad", test_m4712bd_click_27a6_27ad},
    {"test_m4b2250_hit_test", test_m4b2250_hit_test},
    {"test_m46bca9_hit_test", test_m46bca9_hit_test},
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
