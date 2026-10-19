/* FL-25 (batch b) direct tests of the handlers of GAME.EXE in src/original_methods_fl25b.c. Prints "PASS <name>" / "FAIL <name>: <msg>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the
 * disassembly of GAME.EXE, not from running the native code; tests/test_fl25b_differential.py additionally runs the original bytes on
 * generated fixtures.
 *
 * Every function is checked three ways: (1) a guard matrix (each guard of the chain failing in turn leaves the object, the record table
 * and the call log untouched), (2) each arm with the whole object, the record table and the globals compared with a hand-edited copy and
 * the ordered host calls with arguments and the state at the call, (3) the boundaries of signed words and dwords. The whole binary is
 * also run under ASan/UBSan (gcc -fsanitize=address,undefined, -O0/-O1/-O2): every tested input stays inside the buffers. */
#include "../src/original_methods_fl25b.h"

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
__attribute__((unused)) static uint16_t get16x(const uint8_t *o, size_t off)
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
    uint8_t obj[0x1000], decoy[0x1000], obj2[0x1000], mask[0x20100];
    Fl25bWorld w;
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
    if (a >= MASK_VA && a < MASK_VA + sizeof fx.mask) return fx.mask + (a - MASK_VA);
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

/* ---- FL25B-TESTS-BEGIN ----------------------------------------------------------------------------------------------------------- */

/* 0x455180 (ret 0xc): the object of the record is OBJ_VA + RO here (so that the entry of the word [+0x36] = -1 lies inside the buffer).
 * Point (5, 5); a rectangle is "inside" when its four compares pass (bounds inclusive) and misses by one on the side named by `miss`
 * (0 y low, 1 y high, 2 x low, 3 x high). Fixed rectangles: ro+0x25 (x low, y low +4, x high +8, y high +0xc), ro+0x35, ro+0xcf1; loop
 * entry i at E = 0x45 + 0x96 * i: x low E+0x80, y low E+0x84, x high E+0x88, y high E+0x8c, word E+0x94; selected entry at
 * Q = 0x45 + 0x96 * (word [+0x36]): x low Q+0x40, y low Q+0x44, x high Q+0x48, y high Q+0x4c, words Q+0x90 and Q+0x92. */
#define RO 0x200
static uint8_t blk[16];
static void ro32(ptrdiff_t off, uint32_t v) { set32(fx.obj, (size_t)(RO + off), v); }
static void ro16(ptrdiff_t off, uint16_t v) { set16(fx.obj, (size_t)(RO + off), v); }
static void rect4(ptrdiff_t xlo, ptrdiff_t ylo, ptrdiff_t xhi, ptrdiff_t yhi, int miss)
{
    ro32(ylo, miss == 0 ? 6u : 5u);
    ro32(yhi, miss == 1 ? 4u : 5u);
    ro32(xlo, miss == 2 ? 6u : 5u);
    ro32(xhi, miss == 3 ? 4u : 5u);
}
#define RECT1(m) rect4(0x25, 0x29, 0x2d, 0x31, m)
#define RECT2(m) rect4(0x35, 0x39, 0x3d, 0x41, m)
#define RECT3(m) rect4(0xcf1, 0xcf5, 0xcf9, 0xcfd, m)
#define LOOP_RECT(i, m) rect4(0x45 + 0x96 * (i) + 0x80, 0x45 + 0x96 * (i) + 0x84, 0x45 + 0x96 * (i) + 0x88, 0x45 + 0x96 * (i) + 0x8c, m)
#define SEL_RECT(w, m) rect4(0x45 + 0x96 * (w) + 0x40, 0x45 + 0x96 * (w) + 0x44, 0x45 + 0x96 * (w) + 0x48, 0x45 + 0x96 * (w) + 0x4c, m)
#define Q94(i) (0x45 + 0x96 * (i) + 0x94)
static void setup_455180(int idx, int use2a, int w36)
{
    int i;
    base(0x2711, idx, 0x1e);
    set32(fx.tab, (size_t)(idx + 1) * REC, OBJ_VA + RO);
    set32(fx.self, 0x150, 0x01000000u);
    set32(fx.self, 0x2a, use2a ? 0x100u : 0);
    set16(fx.self, 0x36, (uint16_t)w36);
    set16(fx.self, 0x8a, 0x1234);
    set16(fx.self, 0x8c, 0x5678);
    set16(fx.self, 0x8e, 0xdead);
    set32(blk, 0, 0x11111111u);
    set32(blk, 4, 0x22222222u);
    set32(blk, 8, 0x33333333u);
    set32(blk, 12, 0x44444444u);
    ro16(0x21, 0);
    ro16(0x7e0, 1);
    RECT1(0);
    RECT2(0);
    RECT3(0);
    for (i = 0; i < 8; i++) {
        LOOP_RECT(i, 0);
        ro16(Q94(i), 0);
        ro16(Q94(i) + 2, 0xffff);
    }
    SEL_RECT(w36, 0);
    ro16(0x45 + 0x96 * w36 + 0x90, 0x1234);
    ro16(0x45 + 0x96 * w36 + 0x92, 0x5678);
}
/* runs the function on (x, y) with the expected stores of a passed gate; returns eax */
static int32_t run_455180(int16_t x, int16_t y)
{
    begin();
    if (get32(fx.self, 0x150) != 0) {
        X32(0x26, 1);
        X32(0x15a, get32(blk, 0));
        X32(0x15e, get32(blk, 4));
        X32(0x162, get32(blk, 8));
        X32(0x166, get32(blk, 12));
    }
    return m455180_hit_test(fx.self, x, y, blk, &fx.w, &fx.host);
}
/* `pre` calls of 0x45504b (0 or 1) and then, when `event` is non-zero, one call of 0x4554bb(event, word); the stores are visible at the first call */
static void expect_calls_455180(int pre, uint32_t event, uint32_t word)
{
    CK(L.n == pre + (event != 0 ? 1 : 0));
    if (pre) {
        check_call(0, 0x45504b, (uintptr_t)fx.self, 0);
        CK(get32(L.c[0].snap_self, 0x26) == 1 && get32(L.c[0].snap_self, 0x15a) == 0x11111111u && get32(L.c[0].snap_self, 0x166) == 0x44444444u);
    }
    if (event != 0) {
        check_call(pre, 0x4554bb, (uintptr_t)fx.self, 2);
        check_arg(pre, 0, event, 0xffffffffu);
        check_arg(pre, 1, word, 0xffffu);
        CK(get32(L.c[pre].snap_self, 0x26) == 1 && get32(L.c[pre].snap_self, 0x162) == 0x33333333u);
    }
}

static int test_m455180_hit_test(void)
{
    static const int idxs[2] = {2, -1};
    static const int w36s[4] = {2, 0, 7, -1};
    static const uint32_t gates[4] = {0, 0x100, 0x80000000u, 0xff};
    int ii, j, k, v, w;
    int32_t r;
    g_failed = 0;
    g_msg[0] = 0;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        /* the gate is the whole dword [+0x150]: zero returns 0 at once (nothing stored, no call, though a rectangle would hit) */
        for (v = 0; v < 4; v++) {
            setup_455180(idx, 0, 2);
            RECT1(-1);
            set32(fx.self, 0x150, gates[v]);
            r = run_455180(5, 5);
            check_mem();
            CK(r == (v != 0 ? 1 : 0));
            if (v == 0) CK(L.n == 0);
            else expect_calls_455180(0, 0x27c5, 0);
        }
        /* [+0x2a] == 0: each fixed rectangle alone (the others miss); bounds inclusive, each side one short misses */
        for (j = 0; j < 3; j++) {
            for (k = -1; k < 4; k++) {
                setup_455180(idx, 0, 2);
                if (j == 0) RECT1(k);
                if (j == 1) RECT2(k);
                if (j == 2) RECT3(k);
                r = run_455180(5, 5);
                check_mem();
                CK(r == (k == -1 ? 1 : 0));
                expect_calls_455180(0, k == -1 ? 0x27c5u + (uint32_t)j : 0, 0);
            }
        }
        /* the order: all three inside -> the first; the first missing -> the second; the first two missing -> the third */
        for (j = 0; j < 3; j++) {
            setup_455180(idx, 0, 2);
            if (j < 1) RECT1(-1);
            if (j < 2) RECT2(-1);
            RECT3(-1);
            if (j == 1) RECT1(2);
            if (j == 2) {
                RECT1(3);
                RECT2(1);
            }
            r = run_455180(5, 5);
            check_mem();
            CK(r == 1);
            expect_calls_455180(0, 0x27c5u + (uint32_t)j, 0);
        }
        /* signed compares: the point (-32768, -1) in a rectangle given as signed dwords */
        setup_455180(idx, 0, 2);
        ro32(0x39, 0xffffffffu);
        ro32(0x41, 0xffffffffu);
        ro32(0x35, 0xffff8000u);
        ro32(0x3d, 0xffff8000u);
        r = run_455180((int16_t)0x8000, (int16_t)0xffff);
        check_mem();
        CK(r == 1);
        expect_calls_455180(0, 0x27c6, 0);
        /* the loop (2a == 0): entry i inside with a zero word [E+0x94] (the next word is junk) -> 0x4554bb(0x27c4, i) */
        for (k = 0; k < 3; k++) {
            static const int entries[3] = {0, 3, 7};
            int e = entries[k];
            setup_455180(idx, 0, 2);
            ro16(0x21, 8);
            LOOP_RECT(e, -1);
            r = run_455180(5, 5);
            check_mem();
            CK(r == 1);
            expect_calls_455180(0, 0x27c4, (uint32_t)e);
        }
        /* a non-zero word [E+0x94] (also 0x8000 and 0x100) skips the entry; with [+0x2a] == 0 the second test is not made */
        for (v = 0; v < 4; v++) {
            static const uint16_t nz[4] = {1, 0x8000, 0x100, 0xffff};
            setup_455180(idx, 0, 2);
            ro16(0x21, 8);
            LOOP_RECT(2, -1);
            ro16(Q94(2), nz[v]);
            r = run_455180(5, 5);
            check_mem();
            CK(r == 0);
            expect_calls_455180(0, 0, 0);
        }
        /* each side one short misses (entry 3); the count limits the scan; non-positive counts scan nothing */
        for (k = 0; k < 4; k++) {
            setup_455180(idx, 0, 2);
            ro16(0x21, 8);
            LOOP_RECT(3, k);
            r = run_455180(5, 5);
            check_mem();
            CK(r == 0);
            expect_calls_455180(0, 0, 0);
        }
        for (v = 0; v < 6; v++) {
            static const int counts[6] = {3, 4, 0, -1, -32768, 1};
            static const int entry[6] = {3, 3, 0, 0, 0, 0};
            setup_455180(idx, 0, 2);
            ro16(0x21, (uint16_t)counts[v]);
            LOOP_RECT(entry[v], -1);
            r = run_455180(5, 5);
            check_mem();
            CK(r == (v == 1 || v == 5 ? 1 : 0));
            expect_calls_455180(0, v == 1 || v == 5 ? 0x27c4 : 0, (uint32_t)entry[v]);
        }
        /* the first matching entry wins (entry 0 inside but skipped by its word) */
        setup_455180(idx, 0, 2);
        ro16(0x21, 8);
        LOOP_RECT(0, -1);
        ro16(Q94(0), 5);
        LOOP_RECT(1, -1);
        LOOP_RECT(2, -1);
        r = run_455180(5, 5);
        check_mem();
        CK(r == 1);
        expect_calls_455180(0, 0x27c4, 1);
        /* [+0x2a] != 0: 0x45504b first, then the selected entry of the word [+0x36] (2, 0, 7, -1: the call argument is that word) */
        for (w = 0; w < 4; w++) {
            int s = w36s[w];
            setup_455180(idx, 1, s);
            r = run_455180(5, 5);                                /* (a rectangle that misses: the loop has no entries) */
            check_mem();
            CK(r == 0);
            expect_calls_455180(1, 0, 0);
            for (k = -1; k < 4; k++) {
                setup_455180(idx, 1, s);
                SEL_RECT(s, k);
                r = run_455180(5, 5);
                check_mem();
                CK(r == (k == -1 ? 1 : 0));
                expect_calls_455180(1, k == -1 ? 0x27c8 : 0, (uint32_t)s & 0xffff);
            }
            /* the words: the word [+0x8c] must equal Q+0x92 (a difference in the high byte or the low byte alone fails) */
            for (v = 0; v < 3; v++) {
                setup_455180(idx, 1, s);
                SEL_RECT(s, -1);
                ro16(0x45 + 0x96 * s + 0x92, (uint16_t[]){0x5678, 0x5778, 0x5679}[v]);
                r = run_455180(5, 5);
                check_mem();
                CK(r == (v == 0 ? 1 : 0));
                expect_calls_455180(1, v == 0 ? 0x27c8 : 0, (uint32_t)s & 0xffff);
            }
            /* the first test: [ro+0x7e0] non-zero passes whatever [+0x8a] is; zero needs [+0x8a] == Q+0x90 (words, high or low byte alone fails) */
            for (v = 0; v < 8; v++) {
                static const uint16_t w7e0[8] = {0, 0, 0, 0, 1, 0x8000, 0x100, 0};
                static const uint16_t w90[8] = {0x1234, 0x1235, 0x1334, 0x9234, 0x4321, 0x0000, 0x1111, 0x1234};
                static const int pass[8] = {1, 0, 0, 0, 1, 1, 1, 1};
                setup_455180(idx, 1, s);
                SEL_RECT(s, -1);
                ro16(0x7e0, w7e0[v]);
                ro16(0x7e2, 0xabcd);
                ro16(0x45 + 0x96 * s + 0x90, w90[v]);
                r = run_455180(5, 5);
                check_mem();
                CK(r == pass[v]);
                expect_calls_455180(1, pass[v] ? 0x27c8 : 0, (uint32_t)s & 0xffff);
            }
        }
        /* the loop after a failed selected entry ([+0x2a] != 0, entry rectangle one short): a non-zero word [E+0x94] gives 0x4554bb(0x27c4, the
         * word [+0x36]), a zero word the index; entries that miss on one side do not */
        for (w = 0; w < 4; w++) {
            int s = w36s[w];
            for (v = 0; v < 3; v++) {
                setup_455180(idx, 1, s);
                SEL_RECT(s, v + 1);
                ro16(0x21, 4);
                LOOP_RECT(2, -1);
                ro16(Q94(2), v == 1 ? 0x8000 : v == 2 ? 0 : 7);
                if (v == 0) ro16(Q94(2) + 2, 0);                  /* (7: the low byte alone; the word after it is zero) */
                r = run_455180(5, 5);
                check_mem();
                CK(r == 1);
                expect_calls_455180(1, 0x27c4, v == 2 ? 2u : (uint32_t)s & 0xffff);
            }
            for (k = 0; k < 8; k++) {
                setup_455180(idx, 1, s);
                SEL_RECT(s, 0);
                ro16(0x21, 4);
                LOOP_RECT(1, k & 3);
                ro16(Q94(1), (uint16_t)(k >> 2 ? 3 : 0));
                r = run_455180(5, 5);
                check_mem();
                CK(r == 0);
                expect_calls_455180(1, 0, 0);
            }
        }
        /* use2a: the dword [+0x2a] is tested whole (only a high byte set still counts) */
        setup_455180(idx, 1, 2);
        set32(fx.self, 0x2a, 0x01000000u);
        SEL_RECT(2, -1);
        r = run_455180(5, 5);
        check_mem();
        CK(r == 1);
        expect_calls_455180(1, 0x27c8, 2);
    }
    if (g_failed) printf("FAIL test_m455180_hit_test: %s\n", g_msg);
    else printf("PASS test_m455180_hit_test\n");
    return g_failed;
}

/* FL25B-TESTS-END */

int main(void)
{
    int failures = 0;
    failures += test_m455180_hit_test();
    /* FL25B-MAIN-END */
    return failures;
}
