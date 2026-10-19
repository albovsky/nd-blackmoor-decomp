/* FL-25 (batch a) direct tests of the session input handlers of GAME.EXE in src/original_methods_fl25a.c. Prints "PASS <name>" /
 * "FAIL <name>: <msg>"; the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values were derived by
 * hand from the disassembly of GAME.EXE, not from running the native code; tests/test_fl25a_differential.py additionally runs the
 * original bytes on generated fixtures.
 *
 * Every function is checked three ways: (1) the guard matrix, each guard of the chain failing in turn (several fail values each, widths
 * probed), which must leave the object and the call log untouched; (2) each arm with the whole object compared with a hand-edited copy,
 * and the ordered host calls with their arguments and the state of the object at the call; (3) the edges of every comparison, one
 * missing by one at a time. */
#include "../src/original_methods_fl25a.h"

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

static void set32(uint8_t *o, size_t off, uint32_t v) { memcpy(o + off, &v, 4); }
static void set16(uint8_t *o, size_t off, uint16_t v) { memcpy(o + off, &v, 2); }
static int32_t get32s(const uint8_t *o, size_t off)
{
    int32_t v;
    memcpy(&v, o + off, 4);
    return v;
}

static int16_t get16s(const uint8_t *o, size_t off)
{
    int16_t v;
    memcpy(&v, o + off, 2);
    return v;
}

static struct {
    uint8_t self[SELF_SZ], tab[TAB_SZ], obj[OBJ_SZ], decoy[0x1000], rect[16], t3e40[0x60], t3ae8[0x20], blk[0x90], ticks[0x10];
    Fl25aWorld w;
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

static void log_call(uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
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

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    (void)ctx;
    log_call(callee, this_ptr, args, nargs);
    if (callee == 0x45839e) return g_ret_45839e[g_n_45839e++ & 3];
    if (callee == 0x4e22fd) return g_ret_4e22fd;
    if (callee == 0x4d5316) return g_ret_4d5316[g_n_4d5316++ & 7];
    return 0;
}

static const uint8_t *host_resolve_fwd(uint32_t a)
{
    if (a >= OBJ_VA && a < OBJ_VA + OBJ_SZ) return fx.obj + (a - OBJ_VA);
    return NULL;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (a >= OBJ_VA && a < OBJ_VA + OBJ_SZ) return fx.obj + (a - OBJ_VA);
    if (a >= DECOY_VA && a < DECOY_VA + 0x1000) return fx.decoy + (a - DECOY_VA);
    if (a >= RECT_VA && a < RECT_VA + 16) return fx.rect + (a - RECT_VA);
    return NULL;
}

static uint32_t host_tick(void *ctx)
{
    (void)ctx;
    log_call(TICK_ID, 0, NULL, 0);
    return g_tick;
}

/* a pristine fixture: the object bytes 0xA5, the record object a pattern, every record in state 0 but record idx, in state 1 */
static void setup(int idx, uint32_t sel)
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
        snprintf(g_msg, sizeof g_msg, "line %d: the object, the record table or the record object differs from the expected copy", line);
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
    CK(nargs < 1 || L.c[n].a[0] == a0);
}

/* the rectangle at four dword offsets of the object holds the point exactly on its edges */
static void rect_at(size_t ylo, size_t yhi, size_t xlo, size_t xhi, int x, int y)
{
    set32(fx.obj, ylo, (uint32_t)y);
    set32(fx.obj, yhi, (uint32_t)y);
    set32(fx.obj, xlo, (uint32_t)x);
    set32(fx.obj, xhi, (uint32_t)x);
}

/* the rectangle misses the point by one at the edge e (0 y low, 1 y high, 2 x low, 3 x high) */
static void rect_miss(size_t ylo, size_t yhi, size_t xlo, size_t xhi, int x, int y, int e)
{
    rect_at(ylo, yhi, xlo, xhi, x, y);
    switch (e) {
    case 0: set32(fx.obj, ylo, (uint32_t)(y + 1)); break;
    case 1: set32(fx.obj, yhi, (uint32_t)(y - 1)); break;
    case 2: set32(fx.obj, xlo, (uint32_t)(x + 1)); break;
    default: set32(fx.obj, xhi, (uint32_t)(x - 1)); break;
    }
}

/* ======================================================================================================================== 0x45e1ca */

static void setup_45e1ca(int arm_a, int count)
{
    setup(0, 0);
    set32(fx.self, 0x31d, OBJ_VA);
    fx.self[0x321] = 1;
    set32(fx.self, 0x39e, 4);
    fx.self[0x3ae] = arm_a ? 1 : 0;
    set16(fx.obj, 0x25, (uint16_t)count);
    /* every rectangle far from every point used: all edges at 0x7000 */
    {
        size_t o;
        for (o = 0x650; o < 0xd00; o += 4) set32(fx.obj, o, 0x7000);
        for (o = 0x1330; o < 0x1348; o += 4) set32(fx.obj, o, 0x7000);
    }
}

static int run_45e1ca(int x, int y)
{
    return m45e1ca_hit_test(fx.self, (int16_t)x, (int16_t)y, &fx.host);
}

static void test_m45e1ca_hit_test(void)
{
    (void)m45e1ca_hit_test;
    static const int pts[][2] = {{5, 7}, {-1, -1}, {-32768, 32767}, {32767, -32768}, {0, 0}};
    size_t pi;
    int e, i, j, k;
    for (pi = 0; pi < 5; pi++) {
        int x = pts[pi][0], y = pts[pi][1];
        /* the gate byte: clear returns 0 even with everything holding; a byte beside it does not count */
        setup_45e1ca(1, 3);
        rect_at(0x657, 0x65f, 0x653, 0x65b, x, y);
        rect_at(0x1336 + 4, 0x1342, 0x1336, 0x133e, x, y);
        set32(fx.obj, 0x133a, (uint32_t)y);
        fx.self[0x321] = 0;
        fx.self[0x322] = 1;
        expect_begin();
        CK(run_45e1ca(x, y) == 0);
        expect_end();
        CK(L.n == 0);
        /* arm A: row k holds the point, the word [+0x214 + 2k] is 1 or 2: [+0x29a] = k and the call with 0x27ed; the first row wins */
        for (k = 0; k < 3; k++) {
            int w;
            for (w = 1; w <= 2; w++) {
                setup_45e1ca(1, 3);
                rect_at(0x657 + 16 * k, 0x65f + 16 * k, 0x653 + 16 * k, 0x65b + 16 * k, x, y);
                rect_at(0x1336 + 4, 0x1342, 0x1336, 0x133e, x, y);        /* the tail would also hold it */
                set32(fx.obj, 0x133a, (uint32_t)y);
                set16(fx.self, 0x214 + 2 * (size_t)k, (uint16_t)w);
                expect_begin();
                CK(run_45e1ca(x, y) == 1);
                set16(exp_self, 0x29a, (uint16_t)k);
                expect_end();
                CK(L.n == 1);
                ck_call(0, 0x45e4d4, (uintptr_t)fx.self, 1, 0x27ed);
                CK(L.n < 1 || get16s(L.c[0].snap_self, 0x29a) == k);        /* stored before the call */
            }
        }
        setup_45e1ca(1, 3);
        rect_at(0x657 + 16, 0x65f + 16, 0x653 + 16, 0x65b + 16, x, y);
        rect_at(0x657 + 32, 0x65f + 32, 0x653 + 32, 0x65b + 32, x, y);
        set16(fx.self, 0x214 + 2, 2);
        set16(fx.self, 0x214 + 4, 1);
        CK(run_45e1ca(x, y) == 1 && L.n == 1);
        CK(get16s(fx.self, 0x29a) == 1);
        /* a word of 0, a negative one, 3, a larger one skips the row (then the tail, which misses here) */
        {
            static const int bad[] = {0, -1, 3, 4, 0x7fff, -32768};
            for (i = 0; i < 6; i++) {
                setup_45e1ca(1, 2);
                rect_at(0x657, 0x65f, 0x653, 0x65b, x, y);
                set16(fx.self, 0x214, (uint16_t)bad[i]);
                expect_begin();
                CK(run_45e1ca(x, y) == 0);
                expect_end();
                CK(L.n == 0);
            }
        }
        /* each edge of the row missing by one; the count bound (a row at index count is not looked at; a negative or zero word count skips the loop) */
        for (e = 0; e < 4; e++) {
            setup_45e1ca(1, 3);
            rect_miss(0x657, 0x65f, 0x653, 0x65b, x, y, e);
            set16(fx.self, 0x214, 1);
            CK(run_45e1ca(x, y) == 0 && L.n == 0);
        }
        setup_45e1ca(1, 1);
        rect_at(0x657 + 16, 0x65f + 16, 0x653 + 16, 0x65b + 16, x, y);
        set16(fx.self, 0x214 + 2, 1);
        CK(run_45e1ca(x, y) == 0 && L.n == 0);
        for (i = 0; i < 3; i++) {
            static const int counts[] = {0, -1, -32768};
            setup_45e1ca(1, counts[i]);
            rect_at(0x657, 0x65f, 0x653, 0x65b, x, y);
            set16(fx.self, 0x214, 1);
            CK(run_45e1ca(x, y) == 0 && L.n == 0);
        }
        /* arm B: block j, row k: needs the dword [+0x144 + 0x34 j + 4 k] == 1 and the word [+0x214 + 2k] < 3 (negative and zero pass) */
        for (j = 0; j < 3; j++) {
            for (k = 0; k < 3; k++) {
                static const int wv[] = {-32768, -1, 0, 1, 2};
                for (i = 0; i < 5; i++) {
                    size_t b = 0x723 + 0xd0 * (size_t)j + 16 * (size_t)k;
                    setup_45e1ca(0, 3);
                    rect_at(b + 4, b + 0xc, b, b + 8, x, y);
                    set32(fx.self, 0x144 + 0x34 * (size_t)j + 4 * (size_t)k, 1);
                    set16(fx.self, 0x214 + 2 * (size_t)k, (uint16_t)wv[i]);
                    expect_begin();
                    CK(run_45e1ca(x, y) == 1);
                    set16(exp_self, 0x29a, (uint16_t)k);
                    expect_end();
                    CK(L.n == 1);
                    ck_call(0, 0x45e4d4, (uintptr_t)fx.self, 1, 0x27ec);
                }
                /* the dword is not 1, or the word is 3 or more, or an edge misses: no call */
                {
                    static const uint32_t dv[] = {0, 2, 0x10001, 0x100, 0xffffffffu};
                    size_t b = 0x723 + 0xd0 * (size_t)j + 16 * (size_t)k;
                    for (i = 0; i < 5; i++) {
                        setup_45e1ca(0, 3);
                        rect_at(b + 4, b + 0xc, b, b + 8, x, y);
                        set32(fx.self, 0x144 + 0x34 * (size_t)j + 4 * (size_t)k, dv[i]);
                        set16(fx.self, 0x214 + 2 * (size_t)k, 1);
                        CK(run_45e1ca(x, y) == 0 && L.n == 0);
                    }
                    for (i = 0; i < 3; i++) {
                        static const int bw[] = {3, 4, 0x7fff};
                        setup_45e1ca(0, 3);
                        rect_at(b + 4, b + 0xc, b, b + 8, x, y);
                        set32(fx.self, 0x144 + 0x34 * (size_t)j + 4 * (size_t)k, 1);
                        set16(fx.self, 0x214 + 2 * (size_t)k, (uint16_t)bw[i]);
                        CK(run_45e1ca(x, y) == 0 && L.n == 0);
                    }
                    for (e = 0; e < 4; e++) {
                        setup_45e1ca(0, 3);
                        rect_miss(b + 4, b + 0xc, b, b + 8, x, y, e);
                        set32(fx.self, 0x144 + 0x34 * (size_t)j + 4 * (size_t)k, 1);
                        set16(fx.self, 0x214 + 2 * (size_t)k, 1);
                        CK(run_45e1ca(x, y) == 0 && L.n == 0);
                    }
                }
            }
        }
        /* arm B with a count of 2: the block rows at index 2 are not looked at; counts of 0 and below skip every block */
        {
            size_t b = 0x723 + 16 * 2;
            setup_45e1ca(0, 2);
            rect_at(b + 4, b + 0xc, b, b + 8, x, y);
            set32(fx.self, 0x144 + 8, 1);
            set16(fx.self, 0x214 + 4, 1);
            CK(run_45e1ca(x, y) == 0 && L.n == 0);
            setup_45e1ca(0, -1);
            rect_at(0x723 + 4, 0x723 + 0xc, 0x723, 0x723 + 8, x, y);
            set32(fx.self, 0x144, 1);
            set16(fx.self, 0x214, 1);
            CK(run_45e1ca(x, y) == 0 && L.n == 0);
            /* the block j = 3 is never looked at */
            b = 0x723 + 0xd0 * 3;
            setup_45e1ca(0, 3);
            rect_at(b + 4, b + 0xc, b, b + 8, x, y);
            set32(fx.self, 0x144 + 0x34 * 3, 1);
            set16(fx.self, 0x214, 1);
            CK(run_45e1ca(x, y) == 0 && L.n == 0);
        }
        /* byte [+0x3ae] is a byte: zero with a non-zero neighbour is arm B */
        setup_45e1ca(0, 3);
        fx.self[0x3af] = 1;
        rect_at(0x723 + 4, 0x723 + 0xc, 0x723, 0x723 + 8, x, y);
        set32(fx.self, 0x144, 1);
        set16(fx.self, 0x214, 1);
        CK(run_45e1ca(x, y) == 1);
        ck_call(0, 0x45e4d4, (uintptr_t)fx.self, 1, 0x27ec);
        /* the dword [+0x39e] is compared whole: anything but 4 goes to the tail, whatever the rows hold */
        {
            static const uint32_t modes[] = {0, 3, 5, 0x10004u, 0x100u, 0xffffffffu, 0x04000000u};
            for (i = 0; i < 7; i++) {
                setup_45e1ca(1, 3);
                set32(fx.self, 0x39e, modes[i]);
                rect_at(0x657, 0x65f, 0x653, 0x65b, x, y);
                set16(fx.self, 0x214, 1);
                CK(run_45e1ca(x, y) == 0 && L.n == 0);
                rect_at(0x133a, 0x1342, 0x1336, 0x133e, x, y);
                CK(run_45e1ca(x, y) == 1 && L.n == 1);
                ck_call(0, 0x45e4d4, (uintptr_t)fx.self, 1, 0x27ef);
                CK(L.n < 1 || get16s(L.c[0].snap_self, 0x29a) == get16s(fx.self, 0x29a));
            }
        }
        /* the tail after a fall-out of the loops, each edge missing by one */
        for (e = 0; e < 4; e++) {
            setup_45e1ca(1, 0);
            rect_miss(0x133a, 0x1342, 0x1336, 0x133e, x, y, e);
            expect_begin();
            CK(run_45e1ca(x, y) == 0);
            expect_end();
            CK(L.n == 0);
            setup_45e1ca(0, 1);
            rect_miss(0x133a, 0x1342, 0x1336, 0x133e, x, y, e);
            CK(run_45e1ca(x, y) == 0 && L.n == 0);
        }
        setup_45e1ca(1, 0);
        rect_at(0x133a, 0x1342, 0x1336, 0x133e, x, y);
        expect_begin();
        CK(run_45e1ca(x, y) == 1);
        expect_end();
        CK(L.n == 1);
        ck_call(0, 0x45e4d4, (uintptr_t)fx.self, 1, 0x27ef);
    }
}

/* ======================================================================================================================== 0x464792 */

/* record idx; [+0xb8] set; [+0x2a] = mode; every rectangle of the object far away (edges 0x7000) */
static void setup_464792(int idx, uint32_t mode2a, int w36, int w8a, uint32_t d8c)
{
    size_t o;
    setup(idx, 0);
    set16(fx.self, 0x1e, (uint16_t)idx);
    set32(fx.self, 0xb8, 1);
    set32(fx.self, 0x2a, mode2a);
    set16(fx.self, 0x36, (uint16_t)w36);
    set16(fx.self, 0x8a, (uint16_t)w8a);
    set32(fx.self, 0x8c, d8c);
    for (o = 0; o < 5; o++) set32(fx.self, 0x94 + 4 * o, 0x100);
    for (o = 0x20; o < 0x50; o += 4) set32(fx.obj, o, 0x7000);
    for (o = 0x60; o < 0x100; o += 4) set32(fx.obj, o, 0x7000);
    for (o = 0x42c; o < 0x440; o += 4) set32(fx.obj, o, 0x7000);
}

static int run_464792(int x, int y)
{
    return m464792_hit_test(fx.self, (int16_t)x, (int16_t)y, RECT_VA, &fx.w, &fx.host);
}

/* the stores of the rectangle argument into the expected copy of the object */
static void exp_rect_stores(void)
{
    set32(exp_self, 0x26, 1);
    set32(exp_self, 0xc6, 0x22222222u);
    set32(exp_self, 0xce, 0x44444444u);
    set32(exp_self, 0xc2, 0x11111111u);
    set32(exp_self, 0xca, 0x33333333u);
}

static void test_m464792_hit_test(void)
{
    (void)m464792_hit_test;
    static const int idxs[] = {2, -1};
    static const int pts[][2] = {{5, 7}, {-1, -1}, {-32768, 32767}, {32767, -32768}, {0, 0}};
    static const size_t fixed[3][4] = {{0x25, 0x2d, 0x21, 0x29}, {0x35, 0x3d, 0x31, 0x39}, {0x433, 0x43b, 0x42f, 0x437}};
    static const uint32_t fsel[3] = {0x27ca, 0x27cb, 0x27cc};
    size_t ii, pi;
    int e, i, k, f;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        for (pi = 0; pi < 5; pi++) {
            int x = pts[pi][0], y = pts[pi][1];
            /* the gate: dword [+0xb8] clear returns 0 and stores nothing, with every rectangle holding the point; 0x100 and 0x10000 count as set */
            setup_464792(idx, 0, 0, 0, 0);
            rect_at(0x25, 0x2d, 0x21, 0x29, x, y);
            set32(fx.self, 0xb8, 0);
            expect_begin();
            CK(run_464792(x, y) == 0);
            expect_end();
            CK(L.n == 0);
            for (i = 0; i < 2; i++) {
                setup_464792(idx, 0, 0, 0, 0);
                rect_at(0x25, 0x2d, 0x21, 0x29, x, y);
                set32(fx.self, 0xb8, i ? 0x10000u : 0x100u);
                CK(run_464792(x, y) == 1 && L.n == 1);
            }
            /* [+0x2a] clear: the three fixed rectangles in order, each calling 0x464ab5(this, selector, 0); the first holding one wins */
            for (f = 0; f < 3; f++) {
                setup_464792(idx, 0, 0, 0, 0);
                rect_at(fixed[f][0], fixed[f][1], fixed[f][2], fixed[f][3], x, y);
                if (f == 0) rect_at(fixed[1][0], fixed[1][1], fixed[1][2], fixed[1][3], x, y);
                if (f == 1) rect_at(fixed[2][0], fixed[2][1], fixed[2][2], fixed[2][3], x, y);
                rect_at(0x65, 0x6d, 0x61, 0x69, x, y);       /* (row 0 also holds the point: the fixed rectangles come first) */
                set32(fx.self, 0x94, 0);
                expect_begin();
                CK(run_464792(x, y) == 1);
                exp_rect_stores();
                expect_end();
                CK(L.n == 1);
                ck_call(0, 0x464ab5, (uintptr_t)fx.self, 2, fsel[f]);
                CK(L.n < 1 || L.c[0].a[1] == 0);
                CK(L.n < 1 || (get32s(L.c[0].snap_self, 0xc6) == 0x22222222 && get32s(L.c[0].snap_self, 0x26) == 1));      /* stored before the call */
                for (e = 0; e < 4; e++) {
                    setup_464792(idx, 0, 0, 0, 0);
                    rect_miss(fixed[f][0], fixed[f][1], fixed[f][2], fixed[f][3], x, y, e);
                    expect_begin();
                    CK(run_464792(x, y) == 0);
                    exp_rect_stores();
                    expect_end();
                    CK(L.n == 0);
                }
            }
            /* [+0x2a] set: 0x46465d(this) first, then the +0x41 rectangle under the condition; the fixed rectangles are not looked at */
            {
                static const struct { int w36, w8a; uint32_t d8c; int match; } cases[] = {
                    {0, 0, 0, 1}, {0, 0, 5, 1}, {0, 0, 0x10000u, 1},            /* both words zero: the dword does not matter */
                    {1, 0, 0, 1}, {2, 1, 0, 1}, {-1, -2, 0, 1}, {0x7fff, 0x7ffe, 0, 1}, {-2, -3, 0, 1},
                    {0, -1, 0, 1},                                                /* w36 - 1 = -1 */
                    {1, 0, 1, 0}, {1, 0, 0x100, 0}, {1, 0, 0x10000u, 0}, {1, 0, 0xffffffffu, 0},    /* the dword is non-zero */
                    {1, 1, 0, 0}, {1, 2, 0, 0}, {3, 0, 0, 0}, {-1, -1, 0, 0}, {5, 5, 0, 0},      /* the words differ by other than one */
                    {0, 1, 0, 0}, {0, -2, 0, 0}, {0, 0x7fff, 0, 0}, {0, -32768, 0, 0},
                    {-32768, 0x7fff, 0, 0},                                       /* w36 - 1 is -32769 in 32 bits: no wrap to 0x7fff */
                    {-32768, -32768, 0, 0}, {-32768, -1, 0, 0}, {0x7fff, 0x7fff, 0, 0}, {0x7fff, -32768, 0, 0},
                };
                for (i = 0; i < (int)(sizeof cases / sizeof cases[0]); i++) {
                    setup_464792(idx, 1, cases[i].w36, cases[i].w8a, cases[i].d8c);
                    rect_at(0x45, 0x4d, 0x41, 0x49, x, y);
                    rect_at(0x25, 0x2d, 0x21, 0x29, x, y);           /* (not looked at) */
                    expect_begin();
                    CK(run_464792(x, y) == cases[i].match);
                    exp_rect_stores();
                    expect_end();
                    CK(L.n == (cases[i].match ? 2 : 1));
                    CK(L.n >= 1 && L.c[0].callee == 0x46465d && L.c[0].this_ptr == (uintptr_t)fx.self && L.c[0].nargs == 0);
                    CK(L.n < 1 || (get32s(L.c[0].snap_self, 0xca) == 0x33333333 && get32s(L.c[0].snap_self, 0x26) == 1));
                    if (cases[i].match) {
                        CK(L.n < 2 || (L.c[1].callee == 0x464ab5 && L.c[1].this_ptr == (uintptr_t)fx.self && L.c[1].nargs == 2 && L.c[1].a[0] == 0x27cd &&
                                       (uint16_t)L.c[1].a[1] == (uint16_t)cases[i].w36));
                    }
                }
                for (e = 0; e < 4; e++) {
                    setup_464792(idx, 1, 0, 0, 0);
                    rect_miss(0x45, 0x4d, 0x41, 0x49, x, y, e);
                    CK(run_464792(x, y) == 0 && L.n == 1);
                }
            }
            /* the five rows: row k holds the point; [+0x94 + 4k] clear gives (0x27c9, k); with [+0x2a] set and the dword non-zero (0x27c9, w36) */
            for (k = 0; k < 5; k++) {
                size_t e32 = 32 * (size_t)k;
                for (f = 0; f < 2; f++) {
                    setup_464792(idx, (uint32_t)f, 3, 9, 9);          /* (mode 1 with these words misses the +0x41 rectangle's condition) */
                    rect_at(0x65 + e32, 0x6d + e32, 0x61 + e32, 0x69 + e32, x, y);
                    set32(fx.self, 0x94 + 4 * (size_t)k, 0);
                    expect_begin();
                    CK(run_464792(x, y) == 1);
                    exp_rect_stores();
                    expect_end();
                    CK(L.n == (f == 0 ? 1 : 2));
                    {
                        int c = f == 0 ? 0 : 1;
                        ck_call(c, 0x464ab5, (uintptr_t)fx.self, 2, 0x27c9);
                        CK(L.n <= c || (uint16_t)L.c[c].a[1] == (uint16_t)k);
                    }
                }
                /* [+0x2a] set, slot non-zero: the word [+0x36] is the argument */
                setup_464792(idx, 1, 3, 9, 9);
                rect_at(0x65 + e32, 0x6d + e32, 0x61 + e32, 0x69 + e32, x, y);
                set32(fx.self, 0x94 + 4 * (size_t)k, 0x100u);
                set16(fx.self, 0x36, 0x1234);
                CK(run_464792(x, y) == 1 && L.n == 2);
                ck_call(1, 0x464ab5, (uintptr_t)fx.self, 2, 0x27c9);
                CK(L.n < 2 || (uint16_t)L.c[1].a[1] == 0x1234);
                /* [+0x2a] clear, slot non-zero: the row is skipped */
                setup_464792(idx, 0, 0, 0, 0);
                rect_at(0x65 + e32, 0x6d + e32, 0x61 + e32, 0x69 + e32, x, y);
                set32(fx.self, 0x94 + 4 * (size_t)k, 0x100u);
                CK(run_464792(x, y) == 0 && L.n == 0);
                /* each edge of the row missing, both modes and both slot states */
                for (e = 0; e < 4; e++) {
                    for (f = 0; f < 4; f++) {
                        setup_464792(idx, (uint32_t)(f & 1), 3, 9, 9);
                        rect_miss(0x65 + e32, 0x6d + e32, 0x61 + e32, 0x69 + e32, x, y, e);
                        set32(fx.self, 0x94 + 4 * (size_t)k, (f & 2) ? 0u : 0x100u);
                        CK(run_464792(x, y) == 0 && L.n == (f & 1 ? 1 : 0));
                    }
                }
            }
            /* the first holding row wins; row 5 is not looked at */
            setup_464792(idx, 0, 0, 0, 0);
            rect_at(0x65 + 64, 0x6d + 64, 0x61 + 64, 0x69 + 64, x, y);
            rect_at(0x65 + 96, 0x6d + 96, 0x61 + 96, 0x69 + 96, x, y);
            set32(fx.self, 0x94 + 8, 0);
            set32(fx.self, 0x94 + 12, 0);
            CK(run_464792(x, y) == 1 && L.n == 1 && (uint16_t)L.c[0].a[1] == 2);
            setup_464792(idx, 0, 0, 0, 0);
            rect_at(0x65 + 160, 0x6d + 160, 0x61 + 160, 0x69 + 160, x, y);
            set32(fx.self, 0x94 + 20, 0);
            CK(run_464792(x, y) == 0 && L.n == 0);
        }
    }
}

/* ======================================================================================================================== 0x4a835c */

#define ROW(i, j) (0xe94 + 0x90 * (size_t)(i) + 16 * (size_t)(j))

/* record idx; [+0xe72] set; [+0xe5e] = mode; counts c1 (obj + 0x43) and c2 (obj + 0x45); every row and the tail rectangle far away */
static void setup_4a835c(int idx, uint32_t mode, int c1, int c2)
{
    size_t o;
    setup(idx, 0);
    set16(fx.self, 0x1e, (uint16_t)idx);
    set32(fx.self, 0xe72, 1);
    set32(fx.self, 0xe5e, mode);
    set16(fx.obj, 0x43, (uint16_t)c1);
    set16(fx.obj, 0x45, (uint16_t)c2);
    for (o = 0xe94; o < 0x1180; o += 4) set32(fx.self, o, 0x7000);
    for (o = 0x43a; o < 0x44a; o += 4) set32(fx.obj, o, 0x7000);
    fx.w.value_5b44f0 = 0x11111111u;
    fx.w.value_5b44f4 = 0x22222222u;
    fx.w.value_5d0377 = 0x33333333u;
    fx.w.value_5d162d = 0x44444444u;
    fx.w.value_5d1631 = 0x55555555u;
    fx.w.value_5d1639 = 0x66666666u;
}

static int run_4a835c(int x, int y)
{
    return m4a835c_hit_test(fx.self, (int16_t)x, (int16_t)y, RECT_VA, &fx.w, &fx.host);
}

/* the self-rectangle of row (i, j) (x low, y low, x high, y high at +0, +4, +8, +0xc) as the four offsets of rect_at / rect_miss, but in self */
static void row_at(int i, int j, int x, int y, int miss_edge)
{
    size_t b = ROW(i, j);
    set32(fx.self, b + 4, (uint32_t)y);
    set32(fx.self, b + 0xc, (uint32_t)y);
    set32(fx.self, b, (uint32_t)x);
    set32(fx.self, b + 8, (uint32_t)x);
    switch (miss_edge) {
    case 0: set32(fx.self, b + 4, (uint32_t)(y + 1)); break;
    case 1: set32(fx.self, b + 0xc, (uint32_t)(y - 1)); break;
    case 2: set32(fx.self, b, (uint32_t)(x + 1)); break;
    case 3: set32(fx.self, b + 8, (uint32_t)(x - 1)); break;
    default: break;
    }
}

/* the stores of the object that every run past the gate makes */
static void exp_stores_4a835c(void)
{
    set16(exp_self, 0xe7a, 0xffff);
    set16(exp_self, 0xe7c, 0xffff);
    set32(exp_self, 0xe88, 0x22222222u);
    set32(exp_self, 0xe90, 0x44444444u);
    set32(exp_self, 0xe84, 0x11111111u);
    set32(exp_self, 0xe8c, 0x33333333u);
}

static int world_unchanged_4a835c(void)
{
    return fx.w.value_5b44f0 == 0x11111111u && fx.w.value_5b44f4 == 0x22222222u && fx.w.value_5d0377 == 0x33333333u && fx.w.value_5d162d == 0x44444444u &&
           fx.w.value_5d1631 == 0x55555555u && fx.w.value_5d1639 == 0x66666666u;
}

static void test_m4a835c_hit_test(void)
{
    (void)m4a835c_hit_test;
    static const int idxs[] = {2, -1};
    static const int pts[][2] = {{5, 7}, {-1, -1}, {-32768, 32767}, {32767, -32768}, {0, 0}};
    size_t ii, pi;
    int e, i, j, mode;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        for (pi = 0; pi < 5; pi++) {
            int x = pts[pi][0], y = pts[pi][1];
            /* the gate: dword [+0xe72] clear returns 0 and stores nothing; 0x100 counts as set */
            for (mode = 0; mode < 2; mode++) {
                setup_4a835c(idx, (uint32_t)mode, 3, 4);
                row_at(0, 0, x, y, -1);
                rect_at(0x43e, 0x446, 0x43a, 0x442, x, y);
                set32(fx.self, 0xe72, 0);
                expect_begin();
                CK(run_4a835c(x, y) == 0);
                expect_end();
                CK(L.n == 0 && world_unchanged_4a835c());
                set32(fx.self, 0xe72, 0x100);
                CK(run_4a835c(x, y) == 1 && L.n >= 1);
            }
            for (mode = 0; mode < 2; mode++) {
                /* the row (i, j) holds the point (all others far): selector 0x2799 (mode set, after 0x4a8007) or 0x2798, then i and j */
                for (i = 0; i < 3; i++) {
                    for (j = 0; j < 4; j++) {
                        int c = mode;
                        setup_4a835c(idx, (uint32_t)(mode ? 0x10000u : 0u), 3, 4);
                        row_at(i, j, x, y, -1);
                        rect_at(0x43e, 0x446, 0x43a, 0x442, x, y);       /* (the tail would hold the point too) */
                        expect_begin();
                        CK(run_4a835c(x, y) == 1);
                        exp_stores_4a835c();
                        expect_end();
                        CK(L.n == 1 + mode);
                        if (mode) CK(L.n >= 1 && L.c[0].callee == 0x4a8007 && L.c[0].this_ptr == (uintptr_t)fx.self && L.c[0].nargs == 0);
                        ck_call(c, 0x4a8697, (uintptr_t)fx.self, 3, mode ? 0x2799 : 0x2798);
                        CK(L.n <= c || (L.c[c].a[1] == (uintptr_t)i && L.c[c].a[2] == (uintptr_t)j));
                        CK(L.n < 1 || (get32s(L.c[c].snap_self, 0xe88) == 0x22222222 && get32s(L.c[c].snap_self, 0xe84) == 0x11111111 &&
                                       get16s(L.c[c].snap_self, 0xe7a) == -1));
                        CK(world_unchanged_4a835c());
                        /* each edge missing by one: no hit */
                        for (e = 0; e < 4; e++) {
                            setup_4a835c(idx, (uint32_t)mode, 3, 4);
                            row_at(i, j, x, y, e);
                            expect_begin();
                            run_4a835c(x, y);
                            exp_stores_4a835c();
                            CK(L.n == mode);      /* no 0x4a8697, not even through the tail of the clear mode (far) */
                            if (mode) {
                                CK(fx.w.value_5b44f0 == 0x24 && fx.w.value_5b44f4 == 0 && fx.w.value_5d162d == 0x33333333u);
                            } else {
                                CK(world_unchanged_4a835c());
                            }
                        }
                    }
                }
                /* i is the outer loop: (0, 3) is found before (1, 0); within a block the lower j; counts bound the loops */
                setup_4a835c(idx, (uint32_t)mode, 3, 4);
                row_at(0, 3, x, y, -1);
                row_at(1, 0, x, y, -1);
                CK(run_4a835c(x, y) == 1);
                CK(L.n == 1 + mode && L.c[mode].a[1] == 0 && L.c[mode].a[2] == 3);
                setup_4a835c(idx, (uint32_t)mode, 3, 4);
                row_at(1, 1, x, y, -1);
                row_at(1, 2, x, y, -1);
                CK(run_4a835c(x, y) == 1);
                CK(L.n == 1 + mode && L.c[mode].a[1] == 1 && L.c[mode].a[2] == 1);
                setup_4a835c(idx, (uint32_t)mode, 3, 2);
                row_at(0, 2, x, y, -1);
                CK(run_4a835c(x, y) == (mode ? 1 : 0) && L.n == mode);       /* j = 2 is not looked at when c2 is 2 */
                setup_4a835c(idx, (uint32_t)mode, 1, 4);
                row_at(1, 0, x, y, -1);
                CK(run_4a835c(x, y) == (mode ? 1 : 0) && L.n == mode);       /* block 1 is not looked at when c1 is 1 */
                {
                    static const int bad[] = {0, -1, -32768};
                    int b;
                    for (b = 0; b < 3; b++) {
                        setup_4a835c(idx, (uint32_t)mode, bad[b], 4);
                        row_at(0, 0, x, y, -1);
                        CK(run_4a835c(x, y) == (mode ? 1 : 0) && L.n == mode);
                        setup_4a835c(idx, (uint32_t)mode, 3, bad[b]);
                        row_at(0, 0, x, y, -1);
                        CK(run_4a835c(x, y) == (mode ? 1 : 0) && L.n == mode);
                    }
                }
            }
            /* mode set, no hit: the announcement globals; 0x4a8007 is the only call */
            setup_4a835c(idx, 1, 2, 2);
            rect_at(0x43e, 0x446, 0x43a, 0x442, x, y);
            expect_begin();
            CK(run_4a835c(x, y) == 1);
            exp_stores_4a835c();
            expect_end();
            CK(L.n == 1 && L.c[0].callee == 0x4a8007);
            CK(fx.w.value_5b44f0 == 0x24 && fx.w.value_5b44f4 == 0 && fx.w.value_5d0377 == 0x33333333u && fx.w.value_5d162d == 0x33333333u);
            CK(fx.w.value_5d1631 == 0x24u * 32u + 0x5b160cu && fx.w.value_5d1639 == 1);
            /* mode clear: the tail rectangle at +0x43e/+0x446 (y), +0x43a/+0x442 (x), each edge missing by one */
            setup_4a835c(idx, 0, 0, 0);
            rect_at(0x43e, 0x446, 0x43a, 0x442, x, y);
            expect_begin();
            CK(run_4a835c(x, y) == 1);
            exp_stores_4a835c();
            expect_end();
            CK(L.n == 1 && world_unchanged_4a835c());
            ck_call(0, 0x4a8697, (uintptr_t)fx.self, 3, 0x279a);
            CK(L.n < 1 || (L.c[0].a[1] == 0 && L.c[0].a[2] == 0));
            for (e = 0; e < 4; e++) {
                setup_4a835c(idx, 0, 0, 0);
                rect_miss(0x43e, 0x446, 0x43a, 0x442, x, y, e);
                expect_begin();
                CK(run_4a835c(x, y) == 0);
                exp_stores_4a835c();
                expect_end();
                CK(L.n == 0 && world_unchanged_4a835c());
            }
        }
    }
}

/* ======================================================================================================================== 0x45841e */

#define ROW41E(i) (0x105 + 16 * (size_t)(i))      /* x low; y low +4, x high +8, y high +0xc */

/* record idx (word [+0x26]); [+0x98] set; [+0x20] = flag20; word [+0x3a] = w3a; obj[0x21] = c21, obj[0x23] = count; word 0x5a4c08 = w5a; the
 * rectangles of the object far away; the four dwords of row i are 100 + i, 200 + i, 300 + i, 400 + i */
static void setup_45841e(int idx, uint32_t flag20, int w3a, int c21, int count, int w5a)
{
    size_t o;
    int i;
    setup(idx, 0);
    set16(fx.self, 0x26, (uint16_t)idx);
    set32(fx.self, 0x98, 1);
    set32(fx.self, 0x20, flag20);
    set16(fx.self, 0x3a, (uint16_t)w3a);
    set16(fx.obj, 0x21, (uint16_t)c21);
    set16(fx.obj, 0x23, (uint16_t)count);
    fx.w.word_5a4c08 = (int16_t)w5a;
    for (o = 0xe0; o < 0x150; o += 4) set32(fx.obj, o, 0x7000);
    for (o = 0x650; o < 0x660; o += 4) set32(fx.obj, o, 0x7000);
    for (i = 0; i < 4; i++) {
        set32(fx.obj, ROW41E(i), (uint32_t)(100 + i));
        set32(fx.obj, ROW41E(i) + 4, (uint32_t)(200 + i));
        set32(fx.obj, ROW41E(i) + 8, (uint32_t)(300 + i));
        set32(fx.obj, ROW41E(i) + 12, (uint32_t)(400 + i));
    }
}

static int run_45841e(int x, int y)
{
    return m45841e_hit_test(fx.self, (int16_t)x, (int16_t)y, RECT_VA, &fx.w, &fx.host);
}

static void exp_stores_45841e(void)
{
    set32(exp_self, 0xa2, 0x22222222u);
    set32(exp_self, 0xaa, 0x44444444u);
    set32(exp_self, 0x9e, 0x11111111u);
    set32(exp_self, 0xa6, 0x33333333u);
}

/* a row of the object (y low +4, y high +0xc, x low +0, x high +8) holds the point, or misses at the edge e (-1: holds) */
static void row_hold_41e(int i, int x, int y, int e)
{
    if (e < 0) rect_at(ROW41E(i) + 4, ROW41E(i) + 12, ROW41E(i), ROW41E(i) + 8, x, y);
    else rect_miss(ROW41E(i) + 4, ROW41E(i) + 12, ROW41E(i), ROW41E(i) + 8, x, y, e);
}

static void test_m45841e_hit_test(void)
{
    (void)m45841e_hit_test;
    static const int idxs[] = {2, -1};
    static const int pts[][2] = {{5, 7}, {-1, -1}, {-32768, 32767}, {32767, -32768}, {0, 0}};
    static const uint32_t a_flags[] = {0, 4, 6, 0x105, 0x10000005u, 0x80000005u, 0xffffffffu};
    size_t ii, pi;
    int e, i, k;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        for (pi = 0; pi < 5; pi++) {
            int x = pts[pi][0], y = pts[pi][1];
            /* the gate: dword [+0x98] clear returns 0, nothing stored, whatever else holds; 0x100 is set */
            setup_45841e(idx, 0, -1, 3, 3, 0);
            row_hold_41e(0, x, y, -1);
            rect_at(0x657, 0x65f, 0x653, 0x65b, x, y);
            set32(fx.self, 0x98, 0);
            expect_begin();
            CK(run_45841e(x, y) == 0);
            expect_end();
            CK(L.n == 0);
            set32(fx.self, 0x98, 0x100);
            CK(run_45841e(x, y) == 1);
            /* path A (word [+0x3a] != -1, dword [+0x20] != 5): 0x458262, then 0x45839e(this, self + 0x3e, obj + 0xe5) */
            for (k = 0; k < 7; k++) {
                setup_45841e(idx, a_flags[k], 2, 3, 4, 0);
                g_ret_45839e[0] = 0x100;
                expect_begin();
                CK(run_45841e(x, y) == 1);
                exp_stores_45841e();
                set32(exp_self, 0xb4, 0);
                expect_end();
                CK(L.n == 3);
                CK(L.n >= 3 && L.c[0].callee == 0x458262 && L.c[0].nargs == 0 && L.c[0].this_ptr == (uintptr_t)fx.self);
                ck_call(1, 0x45839e, (uintptr_t)fx.self, 2, (uintptr_t)(fx.self + 0x3e));
                CK(L.n < 2 || L.c[1].a[1] == OBJ_VA + 0xe5);
                CK(L.n < 2 || (get32s(L.c[1].snap_self, 0xa2) == 0x22222222 && get32s(L.c[1].snap_self, 0x9e) == 0x11111111));
                ck_call(2, 0x45879e, (uintptr_t)fx.self, 1, 0x27a5);
            }
            /* ... zero: the rows i below the count are built, and the call is made for i == word [+0x3a] only, with the local rectangle */
            for (i = 0; i < 4; i++) {
                int r;
                for (r = 0; r < 2; r++) {
                    setup_45841e(idx, 0, i, 3, 4, 0);
                    g_ret_45839e[1] = r ? 0xffffffffu : 0;
                    expect_begin();
                    CK(run_45841e(x, y) == r);
                    exp_stores_45841e();
                    if (r) set32(exp_self, 0xb4, 1);
                    expect_end();
                    CK(L.n == (r ? 4 : 3));
                    ck_call(2, 0x45839e, (uintptr_t)fx.self, 2, (uintptr_t)(fx.self + 0x3e));
                    if (L.n > 2) {
                        uint32_t want[4] = {(uint32_t)(100 + i + 10), (uint32_t)(200 + i + 10), (uint32_t)(300 + i - 10), (uint32_t)(400 + i - 10)};
                        CK(L.c[2].a[1] > 0xffffffffu);
                        CK(memcmp(L.c[2].deref, want, 16) == 0);
                    }
                    if (r) ck_call(3, 0x45879e, (uintptr_t)fx.self, 1, 0x27a5);
                    CK(!r || get32s(L.c[3].snap_self, 0xb4) == (int32_t)0xA5A5A5A5);       /* [+0xb4] is set after the call */
                }
            }
            /* a word [+0x3a] at or above the count, or negative but not -1, makes no second call; the tail answers */
            {
                static const int w[] = {4, 5, -2, -32768, 0x7fff};
                for (k = 0; k < 5; k++) {
                    setup_45841e(idx, 0, w[k], 3, 4, 0);
                    CK(run_45841e(x, y) == 0 && L.n == 2);
                    rect_at(0x657, 0x65f, 0x653, 0x65b, x, y);
                    L.n = 0;
                    CK(run_45841e(x, y) == 1 && L.n == 3);
                    ck_call(2, 0x45879e, (uintptr_t)fx.self, 1, 0x279f);
                }
                for (k = 0; k < 3; k++) {
                    static const int cnt[] = {0, -1, -32768};
                    setup_45841e(idx, 0, 0, 3, cnt[k], 0);
                    CK(run_45841e(x, y) == 0 && L.n == 2);
                }
            }
            /* path B (word [+0x3a] == -1, even with garbage above bit 15 of the dword it sits in): rows while word 0x5a4c08 < obj[0x21] */
            for (i = 0; i < 4; i++) {
                setup_45841e(idx, 0, -1, 3, 4, 0);
                row_hold_41e(i, x, y, -1);
                row_hold_41e(i == 3 ? 2 : 3, x, y, -1);
                if (i == 3) row_hold_41e(2, x, y, 0);
                rect_at(0xe9, 0xf1, 0xe5, 0xed, x, y);
                expect_begin();
                CK(run_45841e(x, y) == 1);
                exp_stores_45841e();
                set32(exp_self, 0xb4, 1);
                set16(exp_self, 0xae, (uint16_t)i);
                expect_end();
                CK(L.n == 1);
                ck_call(0, 0x45879e, (uintptr_t)fx.self, 1, 0x27a4);
                CK(L.n < 1 || get32s(L.c[0].snap_self, 0xb4) == (int32_t)0xA5A5A5A5);
                for (e = 0; e < 4; e++) {
                    setup_45841e(idx, 0, -1, 3, 4, 0);
                    row_hold_41e(i, x, y, e);
                    expect_begin();
                    CK(run_45841e(x, y) == 0 && L.n == 0);
                    exp_stores_45841e();
                    expect_end();
                }
            }
            /* ... the rows are not looked at when word 0x5a4c08 >= obj[0x21] (signed words) and when the count is not positive */
            {
                static const int wc[][2] = {{3, 3}, {4, 3}, {0, 0}, {32767, -32768}, {-1, -1}, {1, 1}};
                for (k = 0; k < 6; k++) {
                    setup_45841e(idx, 0, -1, wc[k][1], 4, wc[k][0]);
                    row_hold_41e(0, x, y, -1);
                    rect_at(0xe9, 0xf1, 0xe5, 0xed, x, y);
                    CK(run_45841e(x, y) == 0 && L.n == 0);
                }
                setup_45841e(idx, 0, -1, 32767, 4, -32768);
                row_hold_41e(1, x, y, -1);
                CK(run_45841e(x, y) == 1 && L.n == 1 && get16s(fx.self, 0xae) == 1);
                for (k = 0; k < 3; k++) {
                    static const int cnt[] = {0, -1, -32768};
                    setup_45841e(idx, 0, -1, 3, cnt[k], 0);
                    row_hold_41e(0, x, y, -1);
                    CK(run_45841e(x, y) == 0 && L.n == 0);
                }
            }
            /* the post rectangle +0xe9/+0xf1 (y), +0xe5/+0xed (x) counts only when word 0x5a4c08 > 0: 0x27a4, [+0xb4] = 0, [+0xae] kept */
            {
                static const int wp[] = {1, 7, 32766, 0, -1, -32768};
                for (k = 0; k < 6; k++) {
                    int w = wp[k];
                    setup_45841e(idx, 0, -1, w + 1, 0, w);
                    rect_at(0xe9, 0xf1, 0xe5, 0xed, x, y);
                    expect_begin();
                    CK(run_45841e(x, y) == (w > 0 ? 1 : 0));
                    exp_stores_45841e();
                    if (w > 0) set32(exp_self, 0xb4, 0);
                    expect_end();
                    CK(L.n == (w > 0 ? 1 : 0));
                    if (w > 0) ck_call(0, 0x45879e, (uintptr_t)fx.self, 1, 0x27a4);
                }
                for (e = 0; e < 4; e++) {
                    setup_45841e(idx, 0, -1, 2, 0, 1);
                    rect_miss(0xe9, 0xf1, 0xe5, 0xed, x, y, e);
                    CK(run_45841e(x, y) == 0 && L.n == 0);
                }
            }
            /* path C (dword [+0x20] == 5): the rectangle +0xf9/+0x101 (y), +0xf5/+0xfd (x): 0x27a4, [+0xb4] untouched; no 0x458262 whatever word [+0x3a] is */
            for (k = 0; k < 2; k++) {
                setup_45841e(idx, 5, k ? 2 : -1, 3, 4, 0);
                rect_at(0xf9, 0x101, 0xf5, 0xfd, x, y);
                row_hold_41e(0, x, y, -1);
                rect_at(0xe9, 0xf1, 0xe5, 0xed, x, y);
                expect_begin();
                CK(run_45841e(x, y) == 1);
                exp_stores_45841e();
                expect_end();
                CK(L.n == 1);
                ck_call(0, 0x45879e, (uintptr_t)fx.self, 1, 0x27a4);
                for (e = 0; e < 4; e++) {
                    setup_45841e(idx, 5, k ? 2 : -1, 3, 4, 0);
                    rect_miss(0xf9, 0x101, 0xf5, 0xfd, x, y, e);
                    CK(run_45841e(x, y) == 0 && L.n == 0);
                }
            }
            /* the tail rectangle +0x657/+0x65f (y), +0x653/+0x65b (x): 0x279f, nothing else changes; each edge missing by one */
            for (k = 0; k < 3; k++) {
                setup_45841e(idx, k == 2 ? 5u : 0u, -1, 0, 0, 5);
                rect_at(0x657, 0x65f, 0x653, 0x65b, x, y);
                expect_begin();
                CK(run_45841e(x, y) == 1);
                exp_stores_45841e();
                expect_end();
                CK(L.n == 1);
                ck_call(0, 0x45879e, (uintptr_t)fx.self, 1, 0x279f);
                for (e = 0; e < 4; e++) {
                    setup_45841e(idx, k == 2 ? 5u : 0u, -1, 0, 0, 5);
                    rect_miss(0x657, 0x65f, 0x653, 0x65b, x, y, e);
                    CK(run_45841e(x, y) == 0 && L.n == 0);
                }
            }
        }
    }
}

/* ======================================================================================================================== 0x45565f */

#define B5 0x800      /* the record object sits 0x800 bytes into fx.obj: the loop of 0x27c8 may read below it */

static void setup_45565f(int idx, uint32_t sel)
{
    setup(idx, sel);
    set32(fx.tab, (size_t)(idx + 1) * REC, OBJ_VA + B5);
    set16(fx.self, 0x1e, (uint16_t)idx);
    set32(fx.self, 0x150, 1);
    set32(fx.self, 0x155, 0);
}

static void run_45565f(void)
{
    m45565f_click_27c4_27c8(fx.self, &fx.w, &fx.host);
}

/* the state dword of the record idx in the expected copy of the table */
static void exp_state(int idx, uint32_t v)
{
    set32(exp_tab, (size_t)(idx + 1) * REC + 0x4d, v);
}

static void ck_plain(int n, uint32_t callee)
{
    CK(L.n > n);
    if (L.n <= n) return;
    CK(L.c[n].callee == callee && L.c[n].this_ptr == (uintptr_t)fx.self && L.c[n].nargs == 0);
}

static void test_m45565f_click_27c4_27c8(void)
{
    (void)m45565f_click_27c4_27c8;
    static const int idxs[] = {2, -1};
    static const uint32_t sels[] = {0x27c4, 0x27c5, 0x27c6, 0x27c7, 0x27c8};
    size_t ii;
    int i, k, g;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        /* the guards: [+0x150] clear; [+0x155] set (any bit of the dword); the record state not 1 */
        for (k = 0; k < 5; k++) {
            static const uint32_t bad_state[] = {0, 2, 3, 0xffffffffu, 0x101, 0x10001};
            for (g = 0; g < 2; g++) {
                setup_45565f(idx, sels[k]);
                if (g == 0) set32(fx.self, 0x150, 0);
                else set32(fx.self, 0x155, 0x01000000);
                expect_begin();
                run_45565f();
                expect_end();
                CK(L.n == 0);
            }
            for (i = 0; i < 6; i++) {
                setup_45565f(idx, sels[k]);
                set32(fx.tab, (size_t)(idx + 1) * REC + 0x4d, bad_state[i]);
                expect_begin();
                run_45565f();
                expect_end();
                CK(L.n == 0);
            }
            setup_45565f(idx, sels[k]);
            set32(fx.self, 0x150, 0x100);                /* any non-zero dword counts */
            set16(fx.self, 0x36, 0);
            set16(fx.self, 0x38, 0);
            set16(fx.self, 0x8c, 0);
            set16(fx.obj, B5 + 0x23, 0);
            run_45565f();
            CK(k == 3 ? L.n == 0 : L.n >= 1);
        }
        /* an unknown selector changes nothing */
        {
            static const uint32_t other[] = {0, 0x27c3, 0x27c9, 0xffffffffu, 0x127c8, 0x127c4};
            for (i = 0; i < 6; i++) {
                setup_45565f(idx, other[i]);
                set32(fx.self, 0x2a, 1);
                expect_begin();
                run_45565f();
                expect_end();
                CK(L.n == 0);
            }
        }
        /* 0x27c7 */
        setup_45565f(idx, 0x27c7);
        expect_begin();
        run_45565f();
        exp_self[0x154] = 1;
        exp_state(idx, 2);
        expect_end();
        CK(L.n == 0);
        /* 0x27c6: [+0x8e] = [+0x8a]; [+0x8a] + 1 below 3 (signed), else 0 */
        {
            static const int w[] = {0, 1, 2, 3, -1, 5, 0x7fff, -32768, 4};
            for (i = 0; i < 9; i++) {
                setup_45565f(idx, 0x27c6);
                set16(fx.self, 0x8a, (uint16_t)w[i]);
                expect_begin();
                run_45565f();
                set16(exp_self, 0x8e, (uint16_t)w[i]);
                set16(exp_self, 0x8a, (uint16_t)(w[i] < 3 ? w[i] + 1 : 0));
                expect_end();
                CK(L.n == 1);
                ck_plain(0, 0x455ab8);
                CK(L.n < 1 || (get16s(L.c[0].snap_self, 0x8e) == (int16_t)w[i] && get16s(L.c[0].snap_self, 0x8a) == (int16_t)(w[i] < 3 ? w[i] + 1 : 0)));
            }
        }
        /* 0x27c5: [+0x8e] = [+0x8a]; [+0x8a] - 1 above 0 (signed), else 3 */
        {
            static const int w[] = {0, 1, 2, 3, -1, -32768, 0x7fff, 5};
            for (i = 0; i < 8; i++) {
                setup_45565f(idx, 0x27c5);
                set16(fx.self, 0x8a, (uint16_t)w[i]);
                expect_begin();
                run_45565f();
                set16(exp_self, 0x8e, (uint16_t)w[i]);
                set16(exp_self, 0x8a, (uint16_t)(w[i] > 0 ? w[i] - 1 : 3));
                expect_end();
                CK(L.n == 1);
                ck_plain(0, 0x455ab8);
                CK(L.n < 1 || get16s(L.c[0].snap_self, 0x8a) == (int16_t)(w[i] > 0 ? w[i] - 1 : 3));
            }
        }
        /* 0x27c4 */
        {
            static const int w38s[] = {0, 1, -3, 6, -1};
            static const uint32_t nz[] = {1, 0x100, 0x10000, 0x80000000u};
            for (i = 0; i < 5; i++) {
                int w38 = w38s[i];
                size_t m = (size_t)((long)w38 * 0x96 + B5);
                for (k = 0; k < 4 + 1; k++) {
                    int mode2a = k;          /* 0: [+0x2a] clear; 1..4: set */
                    int eq;
                    for (eq = 0; eq < 2; eq++) {
                        setup_45565f(idx, 0x27c4);
                        set32(fx.self, 0x2a, mode2a ? nz[mode2a - 1] : 0);
                        set16(fx.self, 0x38, (uint16_t)w38);
                        set16(fx.self, 0x36, (uint16_t)(eq ? w38 : w38 + 2));
                        set32(fx.obj, m + 0xc5, 0x00010005u);
                        set32(fx.obj, m + 0xc9, 0x0002fff0u);
                        set32(fx.obj, m + 0xcd, 0x00030000u);
                        set32(fx.obj, m + 0xd1, 0x00040010u);
                        expect_begin();
                        run_45565f();
                        if (mode2a && eq) {
                            /* [+0x2a] set and the words equal: [+0x2a] cleared, [+0x36] = 0xffff, after 0x455a63 and [+0x2e] = 1 */
                            set32(exp_self, 0x2e, 1);
                            set32(exp_self, 0x2a, 0);
                            set16(exp_self, 0x36, 0xffff);
                            expect_end();
                            CK(L.n == 1);
                            ck_plain(0, 0x455a63);
                            CK(L.n < 1 || (get32s(L.c[0].snap_self, 0x2e) == (int32_t)0xA5A5A5A5 && get32s(L.c[0].snap_self, 0x2a) != 0));
                        } else {
                            if (mode2a) set32(exp_self, 0x2e, 1);
                            set16(exp_self, 0x36, (uint16_t)w38);
                            set16(exp_self, 0x16a, 0xfffb);       /* 0x30000 - 0x10005 = 0x1fffb: low 16 bits */
                            set16(exp_self, 0x16c, 0x0020);       /* 0x40010 - 0x2fff0 = 0x10020 */
                            set32(exp_self, 0x2a, 1);
                            set32(exp_self, 0x32, 1);
                            set32(exp_self, 0x7a, 0x00010005u);
                            set32(exp_self, 0x7e, 0x0002fff0u);
                            set32(exp_self, 0x82, 0x00030000u);
                            set32(exp_self, 0x86, 0x00040010u);
                            expect_end();
                            CK(L.n == (mode2a ? 2 : 1));
                            if (mode2a) ck_plain(0, 0x455a63);
                            ck_plain(mode2a ? 1 : 0, 0x455a0e);
                            {
                                int c = mode2a ? 1 : 0;
                                CK(L.n <= c || (get16s(L.c[c].snap_self, 0x36) == (int16_t)w38 && get16s(L.c[c].snap_self, 0x16a) == (int16_t)0xfffb &&
                                                get16s(L.c[c].snap_self, 0x16c) == 0x20 && get32s(L.c[c].snap_self, 0x32) == (int32_t)0xA5A5A5A5));
                            }
                        }
                    }
                }
            }
            /* equal as words: 0xffff and -1 */
            setup_45565f(idx, 0x27c4);
            set32(fx.self, 0x2a, 1);
            set16(fx.self, 0x36, 0xffff);
            set16(fx.self, 0x38, 0xffff);
            run_45565f();
            CK(L.n == 1 && get32s(fx.self, 0x2a) == 0 && get16s(fx.self, 0x36) == -1);
        }
        /* 0x27c8 */
        {
            static const int w36s[] = {0, 1, -1, 3};
            for (i = 0; i < 4; i++) {
                int w36 = w36s[i];
                size_t m = (size_t)((long)w36 * 0x96 + B5);
                int has7e0, equal;
                for (has7e0 = 0; has7e0 < 2; has7e0++) {
                    for (equal = 0; equal < 2; equal++) {
                        int differ = has7e0 && !equal;
                        setup_45565f(idx, 0x27c8);
                        set16(fx.self, 0x36, (uint16_t)w36);
                        set16(fx.self, 0x8a, 7);
                        set16(fx.self, 0x8c, 0);
                        set16(fx.obj, B5 + 0x23, 0);            /* [+0x8c] (0) is not below it: the loop is skipped */
                        set16(fx.obj, B5 + 0x7e0, (uint16_t)(has7e0 ? 0x100 : 0));
                        set16(fx.obj, m + 0xd5, (uint16_t)(equal ? 7 : 8));
                        set16(fx.self, 0x8a, 7);
                        expect_begin();
                        run_45565f();
                        set32(exp_self, 0x2a, 0);
                        set32(exp_self, 0x2e, 1);
                        set16(exp_self, 0x36, 0xffff);
                        if (!differ) set16(exp_obj, m + 0xd9, 1);
                        expect_end();
                        CK(L.n == 2);
                        ck_plain(0, differ ? 0x455b2e : 0x455a63);
                        ck_plain(1, 0x455c4f);
                        CK(L.n < 2 || (get32s(L.c[1].snap_self, 0x2a) == 0 && get32s(L.c[1].snap_self, 0x2e) == 1 && get16s(L.c[1].snap_self, 0x36) == -1));
                        CK(L.n < 1 || differ || get16s(L.c[0].snap_self, 0x36) == (int16_t)w36);
                    }
                }
            }
            /* the loop: rows j = 4w - 4 .. 4w - 1 of the record object (word at j * 0x96 + 0xd9) must all be 1 for [+0x8c] to advance */
            {
                static const int w8cs[] = {-2, -1, 0, 1, 2, 3};
                for (i = 0; i < 6; i++) {
                    int w8c = w8cs[i];
                    int bad;
                    for (bad = -1; bad < 4; bad++) {
                        int cnt;
                        for (cnt = 0; cnt < 3; cnt++) {
                            /* count: above w8c (loop runs), equal, below (loop skipped) */
                            int count = cnt == 0 ? w8c + 1 : cnt == 1 ? w8c : w8c - 1;
                            int j, advance;
                            setup_45565f(idx, 0x27c8);
                            set16(fx.self, 0x36, 2);
                            set16(fx.self, 0x8c, (uint16_t)w8c);
                            set16(fx.obj, B5 + 0x23, (uint16_t)count);
                            set16(fx.obj, B5 + 0x7e0, 0);
                            for (j = 4 * w8c - 4; j < 4 * w8c; j++) set16(fx.obj, (size_t)((long)j * 0x96 + B5 + 0xd9), 1);
                            if (bad >= 0) set16(fx.obj, (size_t)((long)(4 * w8c - 4 + bad) * 0x96 + B5 + 0xd9), (uint16_t)(bad == 2 ? 0x101 : bad == 3 ? 0xffff : 0));
                            expect_begin();
                            run_45565f();
                            /* the store of 1 to row [+0x36] = 2 comes before the loop: it may be one of the rows read, and it is what the loop then sees */
                            set16(exp_obj, (size_t)(2 * 0x96 + B5 + 0xd9), 1);
                            advance = (w8c < count) && bad < 0;
                            if (w8c < count && bad >= 0 && 4 * w8c - 4 + bad == 2) advance = 1;          /* (the row 2 holds 1 after the store) */
                            if (w8c < count) {
                                int jj, ok = 1;
                                for (jj = 4 * w8c - 4; jj < 4 * w8c; jj++) {
                                    int16_t v = get16s(exp_obj, (size_t)((long)jj * 0x96 + B5 + 0xd9));
                                    if (jj == 2) v = 1;
                                    if (v != 1) { ok = 0; break; }
                                }
                                advance = ok;
                            }
                            set16(exp_self, 0x8c, (uint16_t)(advance ? w8c + 1 : w8c));
                            set32(exp_self, 0x2a, 0);
                            set32(exp_self, 0x2e, 1);
                            set16(exp_self, 0x36, 0xffff);
                            expect_end();
                            CK(L.n == 2);
                            ck_plain(0, 0x455a63);
                            ck_plain(1, 0x455c4f);
                        }
                    }
                }
            }
        }
    }
}

/* ======================================================================================================================== 0x473206 */

/* A = 1, B = 1; origin (100, 50); table entries (20, 8) and words (11, 6): left 120, right 130, top 58, bottom 63, centre (125, 60) */
static void setup_473206(int idx)
{
    setup(idx, 0x1234);
    set16(fx.self, 0xc, (uint16_t)idx);
    set32(fx.self, 0x7a, 1);
    memset(fx.t3e40, 0x77, sizeof fx.t3e40);
    memset(fx.t3ae8, 0x66, sizeof fx.t3ae8);
    memset(fx.blk, 0, sizeof fx.blk);
    memset(fx.ticks, 0x5a, sizeof fx.ticks);
    set32(fx.t3e40, 16 + 8, 20);
    set32(fx.t3e40, 16 + 8 + 4, 8);
    set16(fx.t3ae8, 8 + 4, 11);
    set16(fx.t3ae8, 8 + 4 + 2, 6);
    fx.w.value_5b44f0 = 1;
    fx.w.value_5b44f4 = 1;
    fx.w.value_583102 = 100;
    fx.w.value_583106 = 50;
    fx.w.word_583a29 = 5;
    fx.w.value_5d0377 = 0x3333;
    fx.w.table_5b3e40 = fx.t3e40;
    fx.w.table_5b3ae8 = fx.t3ae8;
    fx.w.block_5a4b4e = fx.blk;
    fx.w.ticks_63a864 = fx.ticks;
    set32(fx.blk, 0x80, 0xffffffffu);
    fx.obj[0x106] = 1;
    set16(fx.obj, 0x104, 5);
    /* the rectangle of the record object far from the point (x, y) of the callers */
    set32(fx.obj, 0x4f3, 0x7000);
    set32(fx.obj, 0x4fb, 0x7000);
    set32(fx.obj, 0x4ef, 0x7000);
    set32(fx.obj, 0x4f7, 0x7000);
    g_tick = 0x777;
}

/* row k of the block holds the centre (125, 60), or misses it at the edge e (0..3: y low, y high, x low, x high) */
static void blk_row(int k, int e)
{
    size_t r = 0x10 + 16 * (size_t)k;
    set32(fx.blk, r, 120);          /* x low */
    set32(fx.blk, r + 4, 55);       /* y low */
    set32(fx.blk, r + 8, 130);      /* x high */
    set32(fx.blk, r + 12, 65);      /* y high */
    if (e == 0) set32(fx.blk, r + 4, 61);
    if (e == 1) set32(fx.blk, r + 12, 59);
    if (e == 2) set32(fx.blk, r, 126);
    if (e == 3) set32(fx.blk, r + 8, 124);
}

static int run_473206(int x, int y)
{
    return m473206_click(fx.self, (int16_t)x, (int16_t)y, &fx.w, &fx.host);
}

static void test_m473206_click(void)
{
    (void)m473206_click;
    static const int idxs[] = {2, -1};
    size_t ii;
    int i, k, e;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        /* the gate: [+0x76] and [+0xe] are written first; dword [+0x7a] clear returns 0 */
        setup_473206(idx);
        set32(fx.self, 0x7a, 0);
        expect_begin();
        CK(run_473206(5, 7) == 0);
        set32(exp_self, 0x76, OBJ_VA);
        set16(exp_self, 0xe, 0xffff);
        expect_end();
        CK(L.n == 0);
        /* the computed fields and the call 0x4e22fd(this = self + 0x1a6, 125, 60); a non-zero answer sets the selector and returns 1 */
        setup_473206(idx);
        g_ret_4e22fd = 0x100;
        expect_begin();
        CK(run_473206(5, 7) == 1);
        set32(exp_self, 0x76, OBJ_VA);
        set16(exp_self, 0xe, 0xffff);
        set32(exp_self, 0x335, 120);
        set32(exp_self, 0x33d, 130);
        set32(exp_self, 0x339, 58);
        set32(exp_self, 0x341, 63);
        set16(exp_self, 0x345, 125);
        set16(exp_self, 0x347, 60);
        expect_end();
        CK(L.n == 1 && fx.w.value_5c39e5 == 0x27a3);
        ck_call(0, 0x4e22fd, (uintptr_t)(fx.self + 0x1a6), 2, 125);
        CK(L.n < 1 || ((uint16_t)L.c[0].a[1] == 60 && get32s(L.c[0].snap_self, 0x335) == 120));
        /* negative half-widths round toward zero: width -3 gives right = left - 4, half -2; height 4 gives bottom = top + 3, half 1 */
        setup_473206(idx);
        set16(fx.t3ae8, 8 + 4, (uint16_t)-3);
        set16(fx.t3ae8, 8 + 4 + 2, 4);
        g_ret_4e22fd = 1;
        CK(run_473206(5, 7) == 1);
        CK(get16s(fx.self, 0x345) == 118 && get16s(fx.self, 0x347) == 59 && get32s(fx.self, 0x33d) == 116);
        setup_473206(idx);
        set16(fx.t3ae8, 8 + 4, (uint16_t)-2);          /* right = left - 3, d = -3: half -1 */
        g_ret_4e22fd = 1;
        CK(run_473206(5, 7) == 1 && get16s(fx.self, 0x345) == 119);
        /* the rectangle of the record object: the announcement */
        setup_473206(idx);
        rect_at(0x4f3, 0x4fb, 0x4ef, 0x4f7, -3, 9);
        expect_begin();
        CK(run_473206(-3, 9) == 1);
        set32(exp_self, 0x76, OBJ_VA);
        set16(exp_self, 0xe, 0xffff);
        set32(exp_self, 0x335, 120);
        set32(exp_self, 0x33d, 130);
        set32(exp_self, 0x339, 58);
        set32(exp_self, 0x341, 63);
        set16(exp_self, 0x345, 125);
        set16(exp_self, 0x347, 60);
        expect_end();
        CK(fx.w.value_5b44f0 == 9 && fx.w.value_5b44f4 == 1 && fx.w.value_5d162d == 0x3333 && fx.w.value_5d1631 == 9u * 32u + 16u + 0x5b160cu);
        CK(fx.w.value_5d1639 == 1 && fx.w.value_5c39e5 == 0x27a1 && L.n == 1);
        for (e = 0; e < 4; e++) {
            setup_473206(idx);
            rect_miss(0x4f3, 0x4fb, 0x4ef, 0x4f7, -3, 9, e);
            fx.obj[0x106] = 0;
            CK(run_473206(-3, 9) == 0);
            CK(L.n == 7 && L.c[1].callee == 0x473651 && L.c[2].callee == 0x4d5316 && L.c[6].callee == 0x473f7d && fx.w.value_5c39e5 == 0x1234);
        }
        /* the loop, byte set: the rows with their skip dword clear; the first that holds the centre wins, and then the final stage runs */
        for (k = 0; k < 4; k++) {
            for (e = -1; e < 4; e++) {
                int j;
                setup_473206(idx);
                for (j = 0; j < 4; j++) blk_row(j, 0);
                blk_row(k, e);
                set32(fx.blk, 0x80, 0xffffffffu);
                set32(fx.self, 0x371, 1);
                expect_begin();
                if (e < 0) {
                    CK(run_473206(5, 7) == 1);
                    CK(get16s(fx.self, 0xe) == k);
                    CK(L.n == 5 && L.c[1].callee == 0x473651 && L.c[2].callee == 0x47409e && L.c[3].callee == TICK_ID && L.c[4].callee == 0x47512a);
                    CK(L.n < 5 || get32s(L.c[4].snap_self, 0x371) == 0);
                    CK(get32s(fx.blk, 0x50 + 8 * (size_t)k) == 100 - 120 && get32s(fx.blk, 0x54 + 8 * (size_t)k) == 50 - 55);
                    CK(get32s(fx.blk, 0x80) == k && get32s(fx.blk, 0x70 + 4 * (size_t)k) == 1 && get32s(fx.ticks, 4 * (size_t)k) == 0x777);
                } else {
                    CK(run_473206(5, 7) == 0);          /* no row holds it: word [+0xe] stays -1 */
                    CK(get16s(fx.self, 0xe) == -1);
                    CK(L.n == 3 && L.c[2].callee == 0x473f7d);
                    CK(get32s(fx.blk, 0x80) == -1);
                }
                (void)exp_self;
            }
            /* a row whose skip dword is non-zero is not looked at (any bit of the dword) */
            setup_473206(idx);
            for (i = 0; i < 4; i++) blk_row(i, -1);
            set32(fx.blk, 4 * (size_t)k, 0x10000);
            CK(run_473206(5, 7) == 1);
            CK(get16s(fx.self, 0xe) == (k == 0 ? 1 : 0));
        }
        /* the loop, byte clear: 0x4d5316(this = 0x570450, 0x5a4b5e + 16k, self + 0x335) answers per row */
        for (k = 0; k < 4; k++) {
            setup_473206(idx);
            fx.obj[0x106] = 0;
            for (i = 0; i < k; i++) g_ret_4d5316[i] = 0;
            g_ret_4d5316[k] = 0x80000000u;
            CK(run_473206(5, 7) == 1);
            CK(get16s(fx.self, 0xe) == k);
            CK(L.n == 2 + (k + 1) + 3 && L.c[L.n - 3].callee == 0x47409e);
            ck_call(2, 0x4d5316, 0x570450, 2, 0x5a4b5eu);
            CK(L.n < 3 || (L.c[2].a[1] == (uintptr_t)(fx.self + 0x335)));
            CK(L.n < 3 + k || L.c[2 + k].a[0] == 0x5a4b5eu + 16u * (uint32_t)k);
        }
        setup_473206(idx);
        fx.obj[0x106] = 0;
        CK(run_473206(5, 7) == 0 && L.n == 2 + 4 + 1 && L.c[6].callee == 0x473f7d);
        /* a byte of 0x80 or 0xff counts as set (sign-extended, non-zero) */
        setup_473206(idx);
        fx.obj[0x106] = 0x80;
        fx.obj[0x107] = 0;
        blk_row(1, -1);
        CK(run_473206(5, 7) == 1 && get16s(fx.self, 0xe) == 1);
        /* the final stage: the signed words 0x583a29 and obj[0x104] */
        for (i = 0; i < 6; i++) {
            static const int r104[] = {5, -1, 77, 77, 77, 77};
            static const int w29[] = {5, 9, 5, 5, 5, 5};
            /* the skip dword at [+0x375 + 8]: a value in the high word only (0x10000, 0x01000000) is non-zero too */
            static const uint32_t d375[] = {0, 0, 0, 0x100u, 0x10000u, 0x01000000u};
            setup_473206(idx);
            blk_row(2, -1);
            set16(fx.obj, 0x104, (uint16_t)r104[i]);
            fx.w.word_583a29 = (int16_t)w29[i];
            set32(fx.self, 0x375 + 8, d375[i]);
            set32(fx.self, 0x371, 0);
            set32(fx.blk, 0x80, 0xffffffffu);
            if (i < 2) {
                CK(run_473206(5, 7) == 1);
                CK(L.c[L.n - 1].callee == TICK_ID && get32s(fx.blk, 0x80) == 2);
            } else {
                int r = run_473206(5, 7);
                CK(r == 0 && get32s(fx.blk, 0x80) == -1);
                if (i == 2) {
                    CK(L.n == 3 && L.c[2].callee == 0x4eb184 && L.c[2].this_ptr == 0x571442 && L.c[2].a[0] == 77 && get32s(fx.self, 0x375 + 8) == 1);
                } else {
                    CK(L.n == 2 && (uint32_t)get32s(fx.self, 0x375 + 8) == d375[i]);
                }
            }
        }
        setup_473206(idx);
        blk_row(0, -1);
        set16(fx.obj, 0x104, 0x8000);              /* -32768: sign-extended in the push */
        set32(fx.self, 0x375, 0);
        fx.w.word_583a29 = 1;
        CK(run_473206(5, 7) == 0 && L.c[2].callee == 0x4eb184 && L.c[2].a[0] == 0xffff8000u);
        /* dword 0x5a4bce must be -1 exactly */
        setup_473206(idx);
        blk_row(0, -1);
        set32(fx.blk, 0x80, 0xfffffffeu);
        set32(fx.self, 0x371, 1);
        CK(run_473206(5, 7) == 1 && L.n == 3 && get32s(fx.self, 0x371) == 1);
        /* [+0x371] set only in its high word (0x10000, 0x01000000): still non-zero, so it is cleared and 0x47512a runs */
        for (i = 0; i < 2; i++) {
            setup_473206(idx);
            blk_row(3, -1);
            set32(fx.self, 0x371, i ? 0x01000000u : 0x10000u);
            CK(run_473206(5, 7) == 1 && L.n == 5 && L.c[4].callee == 0x47512a && get32s(L.c[4].snap_self, 0x371) == 0 && get32s(fx.self, 0x371) == 0);
        }
        /* [+0x371] clear: no 0x47512a */
        setup_473206(idx);
        blk_row(3, -1);
        set32(fx.self, 0x371, 0);
        CK(run_473206(5, 7) == 1 && L.n == 4 && L.c[3].callee == TICK_ID && get32s(fx.ticks, 12) == 0x777);
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
    for (f = 0; f < 6; f++) {
        for (it = 0; it < 2500; it++) {
            size_t o;
            int idx = rr(-1, 4);
            setup(idx, 0);
            for (o = 0; o < 0x400; o++) fx.self[o] = (uint8_t)rnd();
            switch (f) {
            case 1: {
                int16_t x = (int16_t)rr(-40, 40), y = (int16_t)rr(-40, 40);
                set16(fx.self, 0x1e, (uint16_t)idx);
                set32(fx.self, 0xb8, rnd() & 7 ? 1u : 0u);
                set32(fx.self, 0x2a, (uint32_t)(rnd() & 1));
                set16(fx.self, 0x36, (uint16_t)(int16_t)rr(-2, 3));
                set16(fx.self, 0x8a, (uint16_t)(int16_t)rr(-3, 3));
                set32(fx.self, 0x8c, (uint32_t)(rnd() & 3 ? 0 : 1));
                for (o = 0; o < 5; o++) set32(fx.self, 0x94 + 4 * o, (uint32_t)(rnd() & 1));
                for (o = 0x20; o < 0x440; o += 4) {
                    uint32_t v = (uint32_t)(int32_t)(rr(-3, 3) + (rnd() & 1 ? x : y) + (int)(rnd() % 5) - 2);
                    if (rnd() & 1) set32(fx.obj, o, v);
                }
                m464792_hit_test(fx.self, x, y, RECT_VA, &fx.w, &fx.host);
                break;
            }
            case 2: {
                int16_t x = (int16_t)rr(-40, 40), y = (int16_t)rr(-40, 40);
                set16(fx.self, 0x1e, (uint16_t)idx);
                set32(fx.self, 0xe72, rnd() & 7 ? 1u : 0u);
                set32(fx.self, 0xe5e, (uint32_t)(rnd() & 1));
                set16(fx.obj, 0x43, (uint16_t)(int16_t)rr(-2, 4));
                set16(fx.obj, 0x45, (uint16_t)(int16_t)rr(-2, 5));
                for (o = 0xe94; o < 0x1180; o += 4) {
                    uint32_t v = (uint32_t)(int32_t)(rr(-3, 3) + (rnd() & 1 ? x : y) + (int)(rnd() % 5) - 2);
                    if (rnd() & 1) set32(fx.self, o, v);
                }
                for (o = 0x43a; o < 0x44a; o += 4) set32(fx.obj, o, (uint32_t)(int32_t)(rr(-3, 3) + (rnd() & 1 ? x : y)));
                m4a835c_hit_test(fx.self, x, y, RECT_VA, &fx.w, &fx.host);
                break;
            }
            case 3: {
                int16_t x = (int16_t)rr(-40, 40), y = (int16_t)rr(-40, 40);
                set16(fx.self, 0x26, (uint16_t)idx);
                set32(fx.self, 0x98, rnd() & 7 ? 1u : 0u);
                set32(fx.self, 0x20, rnd() & 3 ? (uint32_t)(rnd() & 1) : 5u);
                set16(fx.self, 0x3a, (uint16_t)(int16_t)rr(-2, 4));
                set16(fx.obj, 0x21, (uint16_t)(int16_t)rr(-2, 4));
                set16(fx.obj, 0x23, (uint16_t)(int16_t)rr(-2, 5));
                fx.w.word_5a4c08 = (int16_t)rr(-2, 4);
                g_ret_45839e[0] = rnd() & 3 ? 0u : 1u;
                g_ret_45839e[1] = rnd() & 3 ? 0u : 1u;
                for (o = 0xe0; o < 0x150; o += 4) {
                    uint32_t v = (uint32_t)(int32_t)(rr(-3, 3) + (rnd() & 1 ? x : y) + (int)(rnd() % 5) - 2);
                    if (rnd() & 1) set32(fx.obj, o, v);
                }
                for (o = 0x650; o < 0x660; o += 4) set32(fx.obj, o, (uint32_t)(int32_t)(rr(-3, 3) + (rnd() & 1 ? x : y)));
                m45841e_hit_test(fx.self, x, y, RECT_VA, &fx.w, &fx.host);
                break;
            }
            case 4: {
                static const uint32_t sels5[] = {0x27c4, 0x27c5, 0x27c6, 0x27c7, 0x27c8};
                fx.w.value_5c39e5 = sels5[rnd() % 5];
                set32(fx.tab, (size_t)(idx + 1) * REC, OBJ_VA + B5);
                set16(fx.self, 0x1e, (uint16_t)idx);
                set32(fx.self, 0x150, rnd() & 7 ? 1u : 0u);
                set32(fx.self, 0x155, rnd() & 7 ? 0u : 1u);
                set32(fx.self, 0x2a, (uint32_t)(rnd() & 1));
                set16(fx.self, 0x36, (uint16_t)(int16_t)rr(-3, 6));
                set16(fx.self, 0x38, (uint16_t)(int16_t)rr(-3, 6));
                set16(fx.self, 0x8a, (uint16_t)(int16_t)rr(-2, 5));
                set16(fx.self, 0x8c, (uint16_t)(int16_t)rr(-2, 4));
                set16(fx.obj, B5 + 0x23, (uint16_t)(int16_t)rr(-3, 6));
                set16(fx.obj, B5 + 0x7e0, (uint16_t)(rnd() & 1));
                for (o = B5 + 0x100; o < B5 + 0x400; o += 2) set16(fx.obj, o, (uint16_t)(rnd() & 3));
                m45565f_click_27c4_27c8(fx.self, &fx.w, &fx.host);
                break;
            }
            case 5: {
                int16_t x = (int16_t)rr(-40, 40), y = (int16_t)rr(-40, 40);
                size_t q;
                set16(fx.self, 0xc, (uint16_t)idx);
                set32(fx.self, 0x7a, rnd() & 7 ? 1u : 0u);
                set32(fx.self, 0x371, (uint32_t)(rnd() & 1));
                for (q = 0; q < 4; q++) set32(fx.self, 0x375 + 4 * q, (uint32_t)(rnd() & 1));
                memset(fx.t3e40, 0, sizeof fx.t3e40);
                memset(fx.t3ae8, 0, sizeof fx.t3ae8);
                for (q = 0; q < sizeof fx.t3e40; q += 4) set32(fx.t3e40, q, (uint32_t)rr(-30, 30));
                for (q = 0; q < sizeof fx.t3ae8; q += 2) set16(fx.t3ae8, q, (uint16_t)(int16_t)rr(-30, 30));
                for (q = 0; q < sizeof fx.blk; q += 4) set32(fx.blk, q, (uint32_t)rr(-3, 130));
                set32(fx.blk, 0x80, rnd() & 1 ? 0xffffffffu : 3u);
                fx.w.value_5b44f0 = (uint32_t)rr(0, 3);
                fx.w.value_5b44f4 = (uint32_t)rr(0, 1);
                fx.w.value_583102 = (uint32_t)rr(-50, 50);
                fx.w.value_583106 = (uint32_t)rr(-50, 50);
                fx.w.word_583a29 = (int16_t)rr(-1, 2);
                fx.w.table_5b3e40 = fx.t3e40;
                fx.w.table_5b3ae8 = fx.t3ae8;
                fx.w.block_5a4b4e = fx.blk;
                fx.w.ticks_63a864 = fx.ticks;
                fx.obj[0x106] = (uint8_t)(rnd() & 1);
                set16(fx.obj, 0x104, (uint16_t)(int16_t)rr(-1, 2));
                g_ret_4e22fd = rnd() & 7 ? 0u : 1u;
                for (q = 0; q < 8; q++) g_ret_4d5316[q] = rnd() & 1 ? 1u : 0u;
                for (q = 0x4ef; q < 0x4ff; q += 4) set32(fx.obj, q, (uint32_t)(int32_t)(rr(-3, 3) + (rnd() & 1 ? x : y)));
                m473206_click(fx.self, x, y, &fx.w, &fx.host);
                break;
            }
            default: {
                int16_t x = (int16_t)rr(-40, 40), y = (int16_t)rr(-40, 40);
                set32(fx.self, 0x31d, OBJ_VA);
                fx.self[0x321] = (uint8_t)(rnd() & 7 ? 1 : 0);
                set32(fx.self, 0x39e, rnd() & 7 ? 4u : rnd());
                fx.self[0x3ae] = (uint8_t)(rnd() & 1);
                set16(fx.obj, 0x25, (uint16_t)(int16_t)rr(-3, 6));
                for (o = 0x640; o < 0x1360; o += 4) {
                    uint32_t v = (uint32_t)(int32_t)(rr(-3, 3) + (rnd() & 1 ? x : y) + (int)(rnd() % 5) - 2);
                    if (rnd() & 1) set32(fx.obj, o, v);
                }
                m45e1ca_hit_test(fx.self, x, y, &fx.host);
                break;
            }
            }
        }
    }
}

/* ---- the table of cases ------------------------------------------------------------------------------------------------------- */

static const struct {
    const char *name;
    void (*fn)(void);
} CASES[] = {
    {"test_m45e1ca_hit_test", test_m45e1ca_hit_test},
    {"test_m464792_hit_test", test_m464792_hit_test},
    {"test_m4a835c_hit_test", test_m4a835c_hit_test},
    {"test_m45841e_hit_test", test_m45841e_hit_test},
    {"test_m45565f_click_27c4_27c8", test_m45565f_click_27c4_27c8},
    {"test_m473206_click", test_m473206_click},
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
