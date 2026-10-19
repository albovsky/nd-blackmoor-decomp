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

#define SELF_SZ 0x1000
#define REC 0x8d
#define TAB_SZ (REC * 6)          /* records -1 .. 4 */
#define TICK_ID 0x52a23cu
#define OBJ_VA 0x20010000u        /* the object of the target record / behind the pointer of the object */
#define DECOY_VA 0x20020000u      /* the object of every other record */
#define OBJ_SZ 0xa000
#define RECT_VA 0x20030000u       /* the rectangle argument of 0x464792 */
#define SNAP 0x400

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
    uint8_t self[SELF_SZ], tab[TAB_SZ], obj[OBJ_SZ], decoy[0x1000], rect[16];
    Fl25aWorld w;
    Fl18Host host;
} fx;
static uint8_t exp_self[SELF_SZ], exp_tab[TAB_SZ];

static uint32_t g_tick;
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[6];
        uint8_t snap_self[SNAP];
    } c[32];
} L;

static void log_call(uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int i;
    L.c[L.n].callee = callee;
    L.c[L.n].this_ptr = this_ptr;
    L.c[L.n].nargs = nargs;
    for (i = 0; i < nargs && i < 6; i++) L.c[L.n].a[i] = args[i];
    memcpy(L.c[L.n].snap_self, fx.self, SNAP);
    L.n++;
}

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    (void)ctx;
    log_call(callee, this_ptr, args, nargs);
    return 0;
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
}

static void expect_begin(void)
{
    memcpy(exp_self, fx.self, sizeof exp_self);
    memcpy(exp_tab, fx.tab, sizeof exp_tab);
}

static void expect_end(void)
{
    CK(memcmp(exp_self, fx.self, sizeof exp_self) == 0);
    CK(memcmp(exp_tab, fx.tab, sizeof exp_tab) == 0);
}

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
    for (f = 0; f < 2; f++) {
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
