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

#define SELF_SZ 0x1200
#define REC 0x8d
#define TAB_SZ (REC * 6)          /* records -1 .. 4 */
#define TICK_ID 0x52a23cu
#define OBJ_VA 0x20010000u        /* the object of the target record / behind the pointer of the object */
#define DECOY_VA 0x20020000u      /* the object of every other record */
#define OBJ_SZ 0xa000
#define RECT_VA 0x20030000u       /* the rectangle argument of 0x464792 */
#define SNAP 0x1200

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
    for (f = 0; f < 1; f++) {
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
