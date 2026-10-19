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
static int g_phase, g_phase2;
#define CK(cond)                                                               \
    do {                                                                       \
        if (!(cond) && !g_failed) {                                            \
            g_failed = 1;                                                      \
            snprintf(g_msg, sizeof g_msg, "line %d: %.200s [phase %d.%d]", __LINE__, #cond, g_phase, g_phase2); \
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
    if (memcmp(fx.self, xs, BIG) != 0 && !g_failed) {
        size_t o = 0;
        while (fx.self[o] == xs[o]) o++;
        g_failed = 1;
        snprintf(g_msg, sizeof g_msg, "self differs at +0x%zx (got %02x, want %02x) [phase %d.%d]", o, fx.self[o], xs[o], g_phase, g_phase2);
    }
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

/* 0x4cb058 (ret 8): P12 = OBJ_VA (the list object: word +2 count, byte +4, word +7 k, dword +9 the entry array = P12 + 0x100, entries of 0x18
 * bytes: x low +4, y low +8, x high +0xc, y high +0x10, word +0x16 k), P16 = OBJ2_VA (the words at 0x5f + 2k), R = DECOY_VA (x low +0x12,
 * y low +0x16, x high +0x1a, y high +0x1e). Point (5, 5); a rectangle misses by one on the side `miss` (0 y low, 1 y high, 2 x low, 3 x high). */
#define P12 OBJ_VA
#define P16 OBJ2_VA
#define PRC DECOY_VA
#define ENT 0x100
static void rectb(uint8_t *b, size_t xlo, size_t ylo, size_t xhi, size_t yhi, int miss)
{
    set32(b, ylo, miss == 0 ? 6u : 5u);
    set32(b, yhi, miss == 1 ? 4u : 5u);
    set32(b, xlo, miss == 2 ? 6u : 5u);
    set32(b, xhi, miss == 3 ? 4u : 5u);
}
#define ENTRY(i, m) rectb(fx.obj, ENT + (size_t)(i) * 0x18 + 4, ENT + (size_t)(i) * 0x18 + 8, ENT + (size_t)(i) * 0x18 + 0xc, ENT + (size_t)(i) * 0x18 + 0x10, m)
#define ENTRY_K(i, k) set16(fx.obj, ENT + (size_t)(i) * 0x18 + 0x16, (uint16_t)(k))
#define RECT_R(m) rectb(fx.decoy, 0x12, 0x16, 0x1a, 0x1e, m)
#define TBL(k, v) set16(fx.obj2, (size_t)(0x5f + 2 * (k)), (uint16_t)(v))
#define G_INIT_SEL 0x2711u
static void setup_4cb058(int count)
{
    int i;
    base(G_INIT_SEL, 0, 0x1e);
    set32(fx.self, 0xe, 0x01000000u);
    set32(fx.self, 0x12, P12);
    set32(fx.self, 0x16, P16);
    set32(fx.self, 0x15c, PRC);
    set16(fx.self, 0x152, 5);
    fx.w.value_583a29 = 5;
    set16(fx.obj, 2, (uint16_t)count);
    fx.obj[4] = 0;
    fx.obj[5] = 0xff;
    fx.obj[6] = 0xff;
    set16(fx.obj, 7, 0xffff);
    set32(fx.obj, 9, P12 + ENT);
    for (i = 0; i < 8; i++) {
        ENTRY(i, 0);
        ENTRY_K(i, 0xffff);
    }
    RECT_R(0);
    fx.w.value_5b44f0 = 0x44444444u;
    fx.w.value_5b44f4 = 0x55555555u;
    fx.w.value_5d0377 = 0xabcdef01u;
    fx.w.value_5d162d = 0x11111111u;
    fx.w.value_5d1631 = 0x22222222u;
    fx.w.value_5d1639 = 0x33333333u;
    fx.w.value_571ad3 = 0x0badcafeu;
}
static int exp_14e;
/* runs (x, y); `loop` = the final value of [+0x132] (-1: the loop is not reached), `hit` = it ended on an entry */
static int32_t run_4cb058(int16_t x, int16_t y, int loop, int hit)
{
    begin();
    X32(0x154, 0);
    X32(0x14e, (uint32_t)exp_14e);
    if (loop >= 0) {
        int examined = loop + (hit ? 1 : 0);
        X32(0x132, (uint32_t)loop);
        if (examined > 0) X32(0x126, P12 + ENT + (uint32_t)(examined - 1) * 0x18);
        if (hit) X32(0x154, P12 + ENT + (uint32_t)loop * 0x18);
    }
    exp_14e = 0;
    return m4cb058_hit_test(fx.self, x, y, &fx.w, &fx.host);
}
static void ck_untouched_4cb058(void)
{
    CK(fx.w.value_5b44f0 == 0x44444444u && fx.w.value_5b44f4 == 0x55555555u && fx.w.value_5d162d == 0x11111111u);
    CK(fx.w.value_5d1631 == 0x22222222u && fx.w.value_5d1639 == 0x33333333u && fx.w.value_5c39e5 == G_INIT_SEL);
}
static void ck_armed_4cb058(uint32_t a, uint32_t b, uint32_t c, uint32_t event)
{
    CK(fx.w.value_5b44f0 == a && fx.w.value_5b44f4 == b && fx.w.value_5d162d == c);
    CK(fx.w.value_5d1631 == (a << 5) + (b << 4) + 0x5b160c && fx.w.value_5d1639 == 1 && fx.w.value_5c39e5 == event);
}

static int test_m4cb058_hit_test(void)
{
    static const uint32_t gates[5] = {0, 0x100, 0x01000000u, 0x80000000u, 0xff};
    int i, k, v, e;
    int32_t r;
    g_failed = 0;
    g_msg[0] = 0;
    /* the gate is the whole dword [+0xe]; the pointers [+0x12], [+0x16], [+0x15c] are tested against zero before the loop */
    for (v = 0; v < 5; v++) {
        setup_4cb058(0);
        set32(fx.self, 0xe, gates[v]);
        r = run_4cb058(5, 5, v == 0 ? -1 : 0, 0);
        check_mem();
        CK(r == 0 && L.n == 0);
        ck_untouched_4cb058();
    }
    for (v = 0; v < 3; v++) {
        setup_4cb058(0);
        set32(fx.self, v == 0 ? 0x12 : v == 1 ? 0x16 : 0x15c, 0);
        if (v == 0) set32(fx.self, 0x16, P16 + 1);          /* (never reached; a dword test at +0x13 would see the nonzero low byte) */
        r = run_4cb058(5, 5, -1, 0);
        check_mem();
        CK(r == 0 && L.n == 0);
        ck_untouched_4cb058();
    }
    /* the word [+0x152] against the word 0x583a29: only a difference of the words (sign-extended) with the word P16[+0x5f] == 0xc8 and
     * [+0x152] != -1 calls 0x4ea06c(this 0x571442, the word) and stores the word */
    for (v = 0; v < 9; v++) {
        static const int16_t s152[9] = {7, 7, -1, 7, -0x8000, -1, 7, 7, 0x7fff};
        static const int16_t g583[9] = {5, 5, 5, 5, 5, -1, 7, 5, (int16_t)0x7f7f};
        static const uint16_t w5f[9] = {0xc9, 0x10c8, 0xc8, 0xc8, 0xc8, 0xc8, 0xc8, 0xffc8, 0xc8};
        int called = v == 3 || v == 4 || v == 8;
        setup_4cb058(0);
        set16(fx.self, 0x152, (uint16_t)s152[v]);
        fx.w.value_583a29 = g583[v];
        TBL(0, w5f[v]);
        r = run_4cb058(5, 5, 0, 0);
        check_mem();
        CK(r == 0);
        CK(fx.w.value_583a29 == (called ? s152[v] : g583[v]));
        CK(L.n == (called ? 1 : 0));
        if (called) {
            check_call(0, 0x4ea06c, 0x571442, 1);
            check_arg(0, 0, (uint16_t)s152[v], 0xffffu);
            CK(get32(L.c[0].snap_self, 0x154) == 0 && get32(L.c[0].snap_self, 0x14e) == 0 && get32(L.c[0].snap_self, 0x132) == 0xA5A5A5A5u);
        }
        ck_untouched_4cb058();
    }
    /* the loop: each side of entry 3 one short misses (all eight entries are examined: [+0x132] ends at 8, [+0x126] at the last entry) */
    for (k = 0; k < 4; k++) {
        setup_4cb058(8);
        ENTRY(3, k);
        r = run_4cb058(5, 5, 8, 0);
        check_mem();
        CK(r == 0 && L.n == 0);
        ck_untouched_4cb058();
    }
    /* a hit with the word -1 arms nothing: 0x5c39e5 = 0x27b0 and 1; entries 0, 3 and 7; the count limits the scan */
    for (v = 0; v < 8; v++) {
        static const int entry[8] = {0, 3, 7, 3, 3, 0, 0, 0};
        static const int counts[8] = {8, 8, 8, 3, 4, 0, -1, -32768};
        int hit = counts[v] > entry[v];
        setup_4cb058(counts[v]);
        ENTRY(entry[v], -1);
        r = run_4cb058(5, 5, hit ? entry[v] : counts[v] > 0 ? counts[v] : 0, hit);
        check_mem();
        CK(r == (hit ? 1 : 0) && L.n == 0);
        if (hit) {
            CK(fx.w.value_5c39e5 == 0x27b0);
            CK(fx.w.value_5b44f0 == 0x44444444u && fx.w.value_5d1639 == 0x33333333u);
        } else {
            ck_untouched_4cb058();
        }
    }
    /* the first matching entry wins */
    setup_4cb058(8);
    ENTRY(1, -1);
    ENTRY(2, -1);
    ENTRY_K(1, 4);
    ENTRY_K(2, 0xffff);
    TBL(4, 0xc9);
    r = run_4cb058(5, 5, 1, 1);
    check_mem();
    CK(r == 1);
    ck_armed_4cb058(0xc9, 1, 0xabcdef01u, 0x27b0);
    /* the arm of a hit with a word k != -1 and P16[+0x5f + 2k] == 0xc8 and [+0x152] != -1: 0x5b44f0 = [+0x152] + 0x25, 0x5d162d = 0x571ad3 */
    for (v = 0; v < 5; v++) {
        static const int16_t s152[5] = {7, -2, 0x7fff, -0x8000, 0};
        static const int ks[5] = {2, 1, -3, 40, 0};
        setup_4cb058(4);
        set16(fx.self, 0x152, (uint16_t)s152[v]);
        fx.w.value_583a29 = s152[v];
        for (i = -8; i < 48; i++) TBL(i, 0xc7);
        TBL(ks[v], 0xc8);
        ENTRY(2, -1);
        ENTRY_K(2, ks[v]);
        r = run_4cb058(5, 5, 2, 1);
        check_mem();
        CK(r == 1 && L.n == 0);
        ck_armed_4cb058((uint32_t)(s152[v] + 0x25), 1, 0x0badcafeu, 0x27b0);
    }
    /* ... with [+0x152] == -1 (equal to the word 0x583a29, so no call) the else arm: 0x5b44f0 = 0xc8, 0x5d162d = 0x5d0377 */
    setup_4cb058(4);
    set16(fx.self, 0x152, 0xffff);
    fx.w.value_583a29 = -1;
    TBL(2, 0xc8);
    ENTRY(2, -1);
    ENTRY_K(2, 2);
    r = run_4cb058(5, 5, 2, 1);
    check_mem();
    CK(r == 1 && L.n == 0);
    ck_armed_4cb058(0xc8, 1, 0xabcdef01u, 0x27b0);
    /* ... and a table word other than 0xc8 (sign-extended) */
    for (v = 0; v < 6; v++) {
        static const uint16_t vals[6] = {0xffc8, 0x10c8, 0xc9, 0, 0x8000, 0x80c8};
        static const int ks[6] = {1, -3, 40, 0, 2, 5};
        setup_4cb058(4);
        for (i = -8; i < 48; i++) TBL(i, 0x1111);
        TBL(ks[v], vals[v]);
        ENTRY(2, -1);
        ENTRY_K(2, ks[v]);
        r = run_4cb058(5, 5, 2, 1);
        check_mem();
        CK(r == 1 && L.n == 0);
        ck_armed_4cb058((uint32_t)(int32_t)(int16_t)vals[v], 1, 0xabcdef01u, 0x27b0);
    }
    /* after the loop (count 0): the byte P12[+4] (only that byte), then the rectangle R (each side one short), [+0x14e] = 1 */
    setup_4cb058(0);
    fx.obj[4] = 0;
    RECT_R(-1);
    r = run_4cb058(5, 5, 0, 0);
    check_mem();
    CK(r == 0);
    ck_untouched_4cb058();
    for (v = 0; v < 15; v++) {
        static const uint8_t b4[3] = {1, 0x80, 0xff};
        setup_4cb058(0);
        fx.obj[4] = b4[v / 5];
        RECT_R(v % 5 == 4 ? -1 : v % 5);
        exp_14e = v % 5 == 4;
        r = run_4cb058(5, 5, 0, 0);
        check_mem();
        CK(r == (v % 5 == 4 ? 1 : 0));
        if (v % 5 == 4) {
            CK(fx.w.value_5c39e5 == 0x27b2);
            CK(fx.w.value_5b44f0 == 0x44444444u && fx.w.value_5d1639 == 0x33333333u);
        } else {
            ck_untouched_4cb058();
        }
    }
    /* the word P12[+7] != -1 arms with the table word of that k and [+0x5b44f4] = 0 */
    for (v = 0; v < 4; v++) {
        static const int ks[4] = {2, 0, -3, 40};
        static const uint16_t vals[4] = {0x1234, 0xffc8, 0xc8, 0};
        setup_4cb058(3);
        for (i = -8; i < 48; i++) TBL(i, 0x1111);
        TBL(ks[v], vals[v]);
        fx.obj[4] = 0x80;
        set16(fx.obj, 7, (uint16_t)ks[v]);
        RECT_R(-1);
        exp_14e = 1;
        r = run_4cb058(5, 5, 3, 0);
        check_mem();
        CK(r == 1 && L.n == 0);
        ck_armed_4cb058((uint32_t)(int32_t)(int16_t)vals[v], 0, 0xabcdef01u, 0x27b2);
    }
    /* signed compares: the point (-32768, -1) inside R given as signed dwords */
    setup_4cb058(0);
    fx.obj[4] = 1;
    set32(fx.decoy, 0x12, 0xffff8000u);
    set32(fx.decoy, 0x1a, 0xffff8000u);
    set32(fx.decoy, 0x16, 0xffffffffu);
    set32(fx.decoy, 0x1e, 0xffffffffu);
    exp_14e = 1;
    r = run_4cb058((int16_t)0x8000, (int16_t)0xffff, 0, 0);
    check_mem();
    CK(r == 1 && fx.w.value_5c39e5 == 0x27b2);
    (void)e;
    if (g_failed) printf("FAIL test_m4cb058_hit_test: %s\n", g_msg);
    else printf("PASS test_m4cb058_hit_test\n");
    return g_failed;
}

/* 0x4a3f40 (ret 0xc): the object of the record is OBJ_VA. Point (5, 5). The cells live in the object under test at base + 0x60 * a + 16 * b
 * (base 0x650 when [+0x260] != 0, else 0x290 and 0x470), x low +0, y low +4, x high +8, y high +0xc; the counts are the signed bytes
 * ro[+0x22] (a) and ro[+0x21] (b); the outer rectangle ro[+0x6af] (x low), +0x6b3, +0x6b7, +0x6bb. */
#define CELL(base, a, b, m) rectb(fx.self, (base) + (size_t)(a) * 0x60 + (size_t)(b) * 16, (base) + (size_t)(a) * 0x60 + (size_t)(b) * 16 + 4, (base) + (size_t)(a) * 0x60 + (size_t)(b) * 16 + 8, (base) + (size_t)(a) * 0x60 + (size_t)(b) * 16 + 0xc, m)
#define OUTER(m) rectb(fx.obj, 0x6af, 0x6b3, 0x6b7, 0x6bb, m)
static void setup_4a3f40(int idx, int mode_a, int cnt_a, int cnt_b)
{
    int a, b;
    base(0x2711, idx, 0x1e);
    set32(fx.self, 0x26e, 0x01000000u);
    set32(fx.self, 0x260, mode_a ? 0x100u : 0);
    fx.obj[0x22] = (uint8_t)cnt_a;
    fx.obj[0x21] = (uint8_t)cnt_b;
    set16(fx.obj, 0x413, 1);
    for (a = 0; a < 4; a++)
        for (b = 0; b < 6; b++) {
            CELL(0x650, a, b, 0);
            CELL(0x290, a, b, 0);
            CELL(0x470, a, b, 0);
        }
    OUTER(0);
    set32(blk, 0, 0x11111111u);
    set32(blk, 4, 0x22222222u);
    set32(blk, 8, 0x33333333u);
    set32(blk, 12, 0x44444444u);
}
static int32_t run_4a3f40(int16_t x, int16_t y)
{
    begin();
    if (get32(fx.self, 0x26e) != 0) {
        X16(0x278, 0xffff);
        X16(0x276, 0xffff);
        X32(0x280, get32(blk, 0));
        X32(0x284, get32(blk, 4));
        X32(0x288, get32(blk, 8));
        X32(0x28c, get32(blk, 12));
    }
    return m4a3f40_hit_test(fx.self, x, y, blk, &fx.w, &fx.host);
}
/* `pre` = 1 when 0x4a3beb ran first; then, when `event` is non-zero, one call 0x4a42c0(event, b, a) */
static void expect_calls_4a3f40(int pre, uint32_t event, uint32_t b, uint32_t a)
{
    CK(L.n == pre + (event != 0 ? 1 : 0));
    if (pre) {
        check_call(0, 0x4a3beb, (uintptr_t)fx.self, 0);
        CK(get16x(L.c[0].snap_self, 0x278) == 0xffff && get32(L.c[0].snap_self, 0x280) == 0x11111111u && get32(L.c[0].snap_self, 0x28c) == 0x44444444u);
    }
    if (event != 0) {
        check_call(pre, 0x4a42c0, (uintptr_t)fx.self, 3);
        check_arg(pre, 0, event, 0xffffffffu);
        check_arg(pre, 1, b, 0xffffffffu);
        check_arg(pre, 2, a, 0xffffffffu);
        CK(get16x(L.c[pre].snap_self, 0x276) == 0xffff && get32(L.c[pre].snap_self, 0x288) == 0x33333333u);
    }
}

static int test_m4a3f40_hit_test(void)
{
    static const int idxs[2] = {2, -1};
    static const uint32_t gates[4] = {0, 0x100, 0x80000000u, 0xff};
    static const int edges[3] = {0, -1, -128};
    int ii, k, v;
    int32_t r;
    g_failed = 0;
    g_msg[0] = 0;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        /* the gate is the whole dword [+0x26e]: zero returns 0 at once (nothing stored, no call) */
        for (v = 0; v < 4; v++) {
            setup_4a3f40(idx, 1, 4, 6);
            CELL(0x650, 0, 0, -1);
            set32(fx.self, 0x26e, gates[v]);
            r = run_4a3f40(5, 5);
            check_mem();
            CK(r == (v != 0 ? 1 : 0));
            if (v == 0) CK(L.n == 0);
            else expect_calls_4a3f40(1, 0x274d, 0, 0);
        }
        /* [+0x260] != 0: the cell (a, b) of base 0x650, each side one short misses (the scan ends with 0), the others miss too */
        for (k = -1; k < 4; k++) {
            setup_4a3f40(idx, 1, 3, 4);
            CELL(0x650, 2, 3, k);
            r = run_4a3f40(5, 5);
            check_mem();
            CK(r == (k == -1 ? 1 : 0));
            expect_calls_4a3f40(1, k == -1 ? 0x274d : 0, 3, 2);
        }
        /* the dword [+0x260] is tested whole; the regions 0x290 and 0x470 are not looked at in this mode */
        setup_4a3f40(idx, 1, 4, 6);
        set32(fx.self, 0x260, 0x01000000u);
        CELL(0x290, 0, 0, -1);
        CELL(0x470, 0, 0, -1);
        OUTER(-1);
        r = run_4a3f40(5, 5);
        check_mem();
        CK(r == 0);
        expect_calls_4a3f40(1, 0, 0, 0);
        /* the counts limit the scan (a < ro[+0x22], b < ro[+0x21]); signed bytes: 0, -1, -128 scan nothing; order: a is the outer loop */
        for (v = 0; v < 4; v++) {
            static const int ca[4] = {2, 3, 4, 4}, cb[4] = {6, 6, 3, 4}, ea[4] = {2, 2, 3, 3}, eb[4] = {1, 1, 3, 3};
            int ok = v == 1 || v == 3;
            setup_4a3f40(idx, 1, ca[v], cb[v]);
            CELL(0x650, ea[v], eb[v], -1);
            r = run_4a3f40(5, 5);
            check_mem();
            CK(r == (ok ? 1 : 0));
            expect_calls_4a3f40(1, ok ? 0x274d : 0, (uint32_t)eb[v], (uint32_t)ea[v]);
        }
        for (v = 0; v < 6; v++) {
            setup_4a3f40(idx, 1, v < 3 ? edges[v] : 4, v < 3 ? 6 : edges[v - 3]);
            CELL(0x650, 0, 0, -1);
            r = run_4a3f40(5, 5);
            check_mem();
            CK(r == 0);
            expect_calls_4a3f40(1, 0, 0, 0);
        }
        /* the first cell in scan order wins: (0, 5) before (1, 0); (1, 0) before (1, 2) */
        setup_4a3f40(idx, 1, 4, 6);
        CELL(0x650, 1, 0, -1);
        CELL(0x650, 0, 5, -1);
        r = run_4a3f40(5, 5);
        check_mem();
        CK(r == 1);
        expect_calls_4a3f40(1, 0x274d, 5, 0);
        /* [+0x260] == 0: the outer rectangle after an empty scan (each side one short misses; inside gives 0x4a42c0(0x274f, 0, 0)) */
        for (k = -1; k < 4; k++) {
            setup_4a3f40(idx, 0, 4, 6);
            OUTER(k);
            r = run_4a3f40(5, 5);
            check_mem();
            CK(r == (k == -1 ? 1 : 0));
            expect_calls_4a3f40(0, k == -1 ? 0x274f : 0, 0, 0);
        }
        /* the cell of base 0x290 needs the word ro[+0x413] != 0 (also with the low byte zero), the cell of base 0x470 does not; at one (a, b) 0x290
         * comes first; an earlier (a, b) of base 0x470 beats a later 0x290; each side one short misses */
        for (v = 0; v < 4; v++) {
            static const uint16_t w413[4] = {1, 0x8000, 0x100, 0};
            setup_4a3f40(idx, 0, 4, 6);
            set16(fx.obj, 0x413, w413[v]);
            set16(fx.obj, 0x415, 0xffff);
            CELL(0x290, 1, 2, -1);
            CELL(0x470, 1, 2, -1);
            r = run_4a3f40(5, 5);
            check_mem();
            CK(r == 1);
            expect_calls_4a3f40(0, v == 3 ? 0x274c : 0x274e, 2, 1);
        }
        setup_4a3f40(idx, 0, 4, 6);
        CELL(0x470, 1, 1, -1);
        CELL(0x290, 1, 2, -1);
        r = run_4a3f40(5, 5);
        check_mem();
        CK(r == 1);
        expect_calls_4a3f40(0, 0x274c, 1, 1);
        for (k = 0; k < 8; k++) {
            setup_4a3f40(idx, 0, 4, 6);
            if (k < 4) CELL(0x290, 3, 5, k);
            else CELL(0x470, 3, 5, k - 4);
            r = run_4a3f40(5, 5);
            check_mem();
            CK(r == 0);
            expect_calls_4a3f40(0, 0, 0, 0);
        }
        for (k = 0; k < 2; k++) {              /* the last cell (3, 5) hits in either region */
            setup_4a3f40(idx, 0, 4, 6);
            CELL(k ? 0x470 : 0x290, 3, 5, -1);
            r = run_4a3f40(5, 5);
            check_mem();
            CK(r == 1);
            expect_calls_4a3f40(0, k ? 0x274c : 0x274e, 5, 3);
        }
        /* the counts also limit the 0x290/0x470 scan, and the outer rectangle is then tried: counts 0, -1, -128 */
        for (v = 0; v < 6; v++) {
            setup_4a3f40(idx, 0, v < 3 ? edges[v] : 4, v < 3 ? 6 : edges[v - 3]);
            CELL(0x290, 0, 0, -1);
            CELL(0x470, 0, 0, -1);
            OUTER(-1);
            r = run_4a3f40(5, 5);
            check_mem();
            CK(r == 1);
            expect_calls_4a3f40(0, 0x274f, 0, 0);
        }
        /* signed compares: the point (-32768, -1) in a cell given as signed dwords */
        setup_4a3f40(idx, 1, 1, 1);
        set32(fx.self, 0x650, 0xffff8000u);
        set32(fx.self, 0x650 + 4, 0xffffffffu);
        set32(fx.self, 0x650 + 8, 0xffff8000u);
        set32(fx.self, 0x650 + 12, 0xffffffffu);
        begin();
        X16(0x278, 0xffff);
        X16(0x276, 0xffff);
        X32(0x280, get32(blk, 0));
        X32(0x284, get32(blk, 4));
        X32(0x288, get32(blk, 8));
        X32(0x28c, get32(blk, 12));
        r = m4a3f40_hit_test(fx.self, (int16_t)0x8000, (int16_t)0xffff, blk, &fx.w, &fx.host);
        check_mem();
        CK(r == 1);
        expect_calls_4a3f40(1, 0x274d, 0, 0);
    }
    if (g_failed) printf("FAIL test_m4a3f40_hit_test: %s\n", g_msg);
    else printf("PASS test_m4a3f40_hit_test\n");
    return g_failed;
}

/* 0x4588ad: guards dword [+0x98] != 0, byte [+0x9d] == 0, dword [+0x20] in {0, 5}, record state (word [+0x26]) == 1; then the events 0x279f,
 * 0x27a4, 0x27a5. The object of the record is OBJ_VA; the word stack at 0x5a4bd4 is tab5a + 64 (the count 0x5a4c08 indexes it, signed). The nine-byte
 * constants are consts[0] (0x54a5f8, compared with ro+0x55b), consts[1] (0x54a604, ro+0x4f9), consts[2] (0x54a610, ro+0x4f9) and consts[3] (0x54a61c, ro+0x52a). */
static uint8_t tab5a[64 + 0x34], xtab5a[64 + 0x34];
static void setup_4588ad(uint32_t sel, int idx)
{
    int i;
    base(sel, idx, 0x26);
    set32(fx.self, 0x98, 0x01000000u);
    fx.self[0x9d] = 0;
    set32(fx.self, 0x20, 0);
    set32(fx.self, 0xb4, 0);
    set16(fx.self, 0xae, 3);
    memset(tab5a, 0x77, sizeof tab5a);
    for (i = 0; i < 26; i++) set16(tab5a, 64 + 2 * (size_t)i, (uint16_t)(0x1000 + i));
    fx.w.words_5a4bd4 = tab5a + 64;
    fx.w.value_5a4c08 = 3;
    fx.w.value_5d03b3 = 0xcafe0001u;
    memcpy(consts[0], "ABCDEFGHI", 9);
    memcpy(consts[1], "JKLMNOPQR", 9);
    memcpy(consts[2], "STUVWXYZ0", 9);
    memcpy(consts[3], "123456789", 9);
    fx.w.bytes_54a5f8 = consts[0];
    fx.w.bytes_54a604 = consts[1];
    fx.w.bytes_54a610 = consts[2];
    fx.w.bytes_54a61c = consts[3];
    memcpy(fx.obj + 0x55b, consts[0], 9);
    memcpy(fx.obj + 0x4f9, consts[1], 9);
    memcpy(fx.obj + 0x52a, consts[3], 9);
    set16(fx.obj, 0x57c, 0x4321);
    set16(fx.obj, 0x54b, 0x8765);
    set16(fx.obj, 0x21, 5);
    set32(fx.obj, 0x5d, 1000);     /* i = 3: dwords at 16 * 3 + 0x2d, 0x25, 0x31, 0x29 */
    set32(fx.obj, 0x55, 300);
    set32(fx.obj, 0x61, 5);
    set32(fx.obj, 0x59, 20);
    g_tick = 1000;
}
static void begin_4588ad(void)
{
    begin();
    memcpy(xtab5a, tab5a, sizeof tab5a);
}
static void check_4588ad(void)
{
    check_mem();
    CK(memcmp(tab5a, xtab5a, sizeof tab5a) == 0);
}
/* the two calls of the announce: 0x4fb77a(this 0x5c3a67, the address) and 0x4fb2e3(this 0x5c3a67, a word) starting at call k */
static void ck_announce_4588ad(int k, uint32_t address, uint32_t word)
{
    check_call(k, 0x4fb77a, 0x5c3a67, 1);
    check_arg(k, 0, address, 0xffffffffu);
    check_call(k + 1, 0x4fb2e3, 0x5c3a67, 1);
    check_arg(k + 1, 0, word, 0xffffu);
}
static void ck_tick_4588ad(int k) { CK(k < L.n && L.c[k].callee == 0x52a23c); }
/* the copy of 0x31 bytes ro+0x4f9 to [+0xc0] and the call 0x458c32 at call k (the snapshot at the call shows the copy) */
static void ck_copy_4588ad(int k)
{
    memcpy(xs + 0xc0, fx.obj + 0x4f9, 0x31);
    check_call(k, 0x458c32, (uintptr_t)fx.self, 0);
    CK(k < L.n && memcmp(L.c[k].snap_self + 0xc0, fx.obj + 0x4f9, 0x31) == 0);
    CK(k < L.n && get32(L.c[k].snap_self, 0x2e) == 0xA5A5A5A5u);
}

static int test_m4588ad_click_279f_27a5(void)
{
    static const int idxs[2] = {2, -1};
    static const int counts[7] = {3, 0, -1, 25, -32, 1, 7};
    int ii, k, v, c;
    g_failed = 0;
    g_msg[0] = 0;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        size_t st = (size_t)(idx + 1) * REC + 0x4d;
        g_phase = 1;
        /* the guard matrix with the event 0x27a4 and [+0x20] == 5 (which would call and store a lot) */
        for (v = 0; v < 20; v++) {
            static const uint32_t bad20[7] = {1, 2, 4, 6, 0x100, 0x10005, 0xffffffffu};
            static const uint32_t badst[6] = {0, 2, 3, 0xffffffffu, 0x101, 0x10001};
            setup_4588ad(0x27a4, idx);
            set32(fx.self, 0x20, 5);
            if (v == 0) set32(fx.self, 0x98, 0);
            else if (v < 3) fx.self[0x9d] = v == 1 ? 1 : 0x80;
            else if (v < 10) set32(fx.self, 0x20, bad20[v - 3]);
            else if (v < 16) set32(fx.tab, st, badst[v - 10]);
            else set32(fx.self, 0x20, v == 16 ? 0 : 5);          /* (v 16 and 17 pass: the matrix below is for the failing ones only) */
            if (v >= 16) continue;
            begin_4588ad();
            m4588ad_click_279f_27a5(fx.self, &fx.w, &fx.host);
            check_4588ad();
            CK(L.n == 0 && fx.w.value_5a4c08 == 3);
        }
        g_phase = 2;
        /* 0x279f: [+0x9c] = 1 and the record state 2 (with [+0x20] == 0 or 5; the neighbours of the byte [+0x9d] are non-zero) */
        for (v = 0; v < 2; v++) {
            setup_4588ad(0x279f, idx);
            set32(fx.self, 0x20, v ? 5 : 0);
            begin_4588ad();
            X8(0x9c, 1);
            set32(xt, st, 2);
            m4588ad_click_279f_27a5(fx.self, &fx.w, &fx.host);
            check_4588ad();
            CK(L.n == 0);
        }
        g_phase = 3;
        /* an unrelated event changes nothing */
        setup_4588ad(0x27a6, idx);
        begin_4588ad();
        m4588ad_click_279f_27a5(fx.self, &fx.w, &fx.host);
        check_4588ad();
        CK(L.n == 0);
        g_phase = 4;
        /* 0x27a4, [+0x20] == 5: the call 0x448d11 (this 0x619a05; the dword 0x5d03b3, 0x54a5f0, -1, 0), the stack entry at the count gets 0xffff */
        for (c = 0; c < 5; c++) {
            setup_4588ad(0x27a4, idx);
            set32(fx.self, 0x20, 5);
            fx.w.value_5a4c08 = (int16_t)counts[c];
            begin_4588ad();
            X32(0x20, 0);
            X32(0x94, 1);
            set16(xtab5a, (size_t)(64 + 2 * counts[c]), 0xffff);
            X16(0x3c, 0xffff);
            X16(0x3a, 0xffff);
            m4588ad_click_279f_27a5(fx.self, &fx.w, &fx.host);
            check_4588ad();
            CK(fx.w.value_5a4c08 == (int16_t)(counts[c] - 1));
            CK(L.n == 1);
            check_call(0, 0x448d11, 0x619a05, 4);
            check_arg(0, 0, 0xcafe0001u, 0xffffffffu);
            check_arg(0, 1, 0x54a5f0, 0xffffffffu);
            check_arg(0, 2, 0xffffffffu, 0xffffffffu);
            check_arg(0, 3, 0, 0xffffffffu);
            CK(get32(L.c[0].snap_self, 0x20) == 0 && get32(L.c[0].snap_self, 0x94) == 0xA5A5A5A5u && get16x(L.c[0].snap_self, 0x3a) == 0xA5A5u);
        }
        g_phase = 5;
        /* 0x27a4, [+0x20] == 0, [+0xb4] == 0, count > 0: the nine bytes ro+0x55b against consts[0] (every byte position, and the tenth byte not compared) */
        for (c = 5; c < 7; c++) {
            for (k = -1; k < 10; k++) {
                setup_4588ad(0x27a4, idx);
                fx.w.value_5a4c08 = (int16_t)counts[c];
                if (k >= 0) fx.obj[0x55b + k] ^= 0x40;
                begin_4588ad();
                X16(0x3a, get16x(tab5a, (size_t)(64 + 2 * counts[c])));
                X16(0x3c, (uint16_t)counts[c]);
                X32(0x20, 2);
                X32(0xbc, 1000 + 0x28);
                X32(0x2e, 0);
                m4588ad_click_279f_27a5(fx.self, &fx.w, &fx.host);
                check_4588ad();
                CK(fx.w.value_5a4c08 == counts[c] - 1);
                if (k >= 0 && k < 9) {
                    CK(L.n == 3);
                    ck_announce_4588ad(0, OBJ_VA + 0x55b, 0x4321);
                    ck_tick_4588ad(2);
                    CK(get32(L.c[0].snap_self, 0x20) == 0 && get16x(L.c[0].snap_self, 0x3a) == 0xA5A5u && get32(L.c[1].snap_self, 0xbc) == 0xA5A5A5A5u);
                } else {
                    CK(L.n == 1);
                    ck_tick_4588ad(0);
                }
            }
        }
        g_phase = 6;
        /* the tick wraps: 0xffffffff + 0x28 */
        setup_4588ad(0x27a4, idx);
        g_tick = 0xffffffffu;
        begin_4588ad();
        X16(0x3a, get16x(tab5a, 64 + 6));
        X16(0x3c, 3);
        X32(0x20, 2);
        X32(0xbc, 0x27);
        X32(0x2e, 0);
        m4588ad_click_279f_27a5(fx.self, &fx.w, &fx.host);
        check_4588ad();
        g_phase = 7;
        /* 0x27a4 else branch: [+0xb4] != 0 (any bit) or the count <= 0: the nine bytes ro+0x4f9 against consts[1]; a difference copies 0x31 bytes to [+0xc0]
         * and runs 0x458c32; [+0x2e] = 1, [+0x3a] = [+0xae], the words [+0xb0] and [+0xb2] = the low words of the differences at 16 * [+0xae] */
        for (v = 0; v < 6; v++) {
            static const uint32_t b4[6] = {0x100, 0x80000000u, 1, 0, 0, 0};
            static const int cnt[6] = {3, 1, 25, 0, -1, -32};
            static const uint16_t ae[6] = {3, 0, 7, 3, 7, 0};
            for (k = -1; k < 10; k++) {
                int i = ae[v];
                setup_4588ad(0x27a4, idx);
                fx.w.value_5a4c08 = (int16_t)cnt[v];
                set32(fx.self, 0xb4, b4[v]);
                set16(fx.self, 0xae, ae[v]);
                set32(fx.obj, (size_t)(i * 16 + 0x2d), v == 2 ? 0x10005u : 1000u);
                set32(fx.obj, (size_t)(i * 16 + 0x25), 300);
                set32(fx.obj, (size_t)(i * 16 + 0x31), 5);
                set32(fx.obj, (size_t)(i * 16 + 0x29), 20);
                if (k >= 0) fx.obj[0x4f9 + k] ^= 0x80;
                begin_4588ad();
                X32(0x2e, 1);
                X16(0x3a, ae[v]);
                X16(0xb0, (uint16_t)((v == 2 ? 0x10005u : 1000u) - 300u));
                X16(0xb2, (uint16_t)(5u - 20u));
                if (k >= 0 && k < 9) {
                    memcpy(xs + 0xc0, fx.obj + 0x4f9, 0x31);
                    X16(0xae, ae[v]);
                }
                m4588ad_click_279f_27a5(fx.self, &fx.w, &fx.host);
                memcpy(xs + 0xc0, k >= 0 && k < 9 ? fx.obj + 0x4f9 : xs + 0xc0, k >= 0 && k < 9 ? 0x31 : 0);
                check_4588ad();
                CK(fx.w.value_5a4c08 == cnt[v]);
                if (k >= 0 && k < 9) {
                    CK(L.n == 1);
                    check_call(0, 0x458c32, (uintptr_t)fx.self, 0);
                    CK(memcmp(L.c[0].snap_self + 0xc0, fx.obj + 0x4f9, 0x31) == 0 && get32(L.c[0].snap_self, 0x2e) == 0xA5A5A5A5u);
                } else {
                    CK(L.n == 0);
                }
            }
        }
        /* the word [+0xae] is signed: 0xffff and 0xfffe index the entries at 16 * -1 and 16 * -2 before ro (a zero-extending read would index 0xffff0
         * and 0xffee0 and miss the values set here). The record points at OBJ_VA + 0x40 so that the negative offsets stay inside the buffer. */
        for (v = 0; v < 3; v++) {
            static const uint16_t ae[3] = {0xffff, 0xfffe, 0xfffd};
            static const int aes[3] = {-1, -2, -3};
            const size_t R = 0x40;
            for (k = -1; k < 10; k++) {
                ptrdiff_t i = 16 * (ptrdiff_t)aes[v];
                setup_4588ad(0x27a4, idx);
                set32(fx.tab, (size_t)(idx + 1) * REC, OBJ_VA + (uint32_t)R);
                fx.w.value_5a4c08 = 0;
                set32(fx.self, 0xb4, 0);
                set16(fx.self, 0xae, ae[v]);
                memcpy(fx.obj + R + 0x4f9, consts[1], 9);
                set32(fx.obj, (size_t)((ptrdiff_t)R + i + 0x2d), 0x20000u + (uint32_t)(v * 7) + 900u);
                set32(fx.obj, (size_t)((ptrdiff_t)R + i + 0x25), 300);
                set32(fx.obj, (size_t)((ptrdiff_t)R + i + 0x31), 5);
                set32(fx.obj, (size_t)((ptrdiff_t)R + i + 0x29), 20);
                if (k >= 0) fx.obj[R + 0x4f9 + (size_t)k] ^= 0x80;
                begin_4588ad();
                X32(0x2e, 1);
                X16(0x3a, ae[v]);
                X16(0xb0, (uint16_t)((0x20000u + (uint32_t)(v * 7) + 900u) - 300u));
                X16(0xb2, (uint16_t)(5u - 20u));
                if (k >= 0 && k < 9) {
                    memcpy(xs + 0xc0, fx.obj + R + 0x4f9, 0x31);
                    X16(0xae, ae[v]);
                }
                m4588ad_click_279f_27a5(fx.self, &fx.w, &fx.host);
                memcpy(xs + 0xc0, k >= 0 && k < 9 ? fx.obj + R + 0x4f9 : xs + 0xc0, k >= 0 && k < 9 ? 0x31 : 0);
                check_4588ad();
                if (k >= 0 && k < 9) {
                    CK(L.n == 1);
                    check_call(0, 0x458c32, (uintptr_t)fx.self, 0);
                } else {
                    CK(L.n == 0);
                }
            }
        }
        g_phase = 8;
        /* 0x27a5: [+0x2e] = 0, [+0x32] = 1; [+0xb4] != 0: the copy-and-call against consts[2], then [+0x3a] = 0xffff */
        for (v = 0; v < 2; v++) {
            for (k = -1; k < 10; k++) {
                setup_4588ad(0x27a5, idx);
                set32(fx.self, 0xb4, v ? 0x01000000u : 0x100u);
                if (k >= 0) fx.obj[0x4f9 + k] ^= 0x01;
                memcpy(fx.obj + 0x4f9, k < 0 ? consts[2] : fx.obj + 0x4f9, k < 0 ? 9 : 0);
                if (k >= 0) {
                    memcpy(fx.obj + 0x4f9, consts[2], 9);
                    fx.obj[0x4f9 + k] ^= 0x01;
                }
                begin_4588ad();
                X32(0x2e, 0);
                X32(0x32, 1);
                X16(0x3a, 0xffff);
                if (k >= 0 && k < 9) memcpy(xs + 0xc0, fx.obj + 0x4f9, 0x31);
                m4588ad_click_279f_27a5(fx.self, &fx.w, &fx.host);
                check_4588ad();
                CK(L.n == (k >= 0 && k < 9 ? 1 : 0));
                if (k >= 0 && k < 9) {
                    check_call(0, 0x458c32, (uintptr_t)fx.self, 0);
                    CK(memcmp(L.c[0].snap_self + 0xc0, fx.obj + 0x4f9, 0x31) == 0 && get32(L.c[0].snap_self, 0x32) == 1 && get16x(L.c[0].snap_self, 0x3a) == 0xA5A5u);
                }
            }
        }
        g_phase = 9;
        /* 0x27a5, [+0xb4] == 0: the nine bytes ro+0x52a against consts[3]: a difference announces; [+0x3c] = ro[+0x21] - 1 (a word), [+0x20] = 1, the tick */
        for (v = 0; v < 5; v++) {
            static const int16_t w21[5] = {5, 0, -32768, 0x7fff, -1};
            for (k = -1; k < 10; k++) {
                setup_4588ad(0x27a5, idx);
                set16(fx.obj, 0x21, (uint16_t)w21[v]);
                g_phase2 = v * 20 + k + 1;
                if (k >= 0) fx.obj[0x52a + k] ^= 0x20;
                begin_4588ad();
                X32(0x2e, 0);
                X32(0x32, 1);
                X16(0x3c, (uint16_t)(w21[v] - 1));
                X32(0x20, 1);
                X32(0xbc, 1000 + 0x28);
                m4588ad_click_279f_27a5(fx.self, &fx.w, &fx.host);
                check_4588ad();
                if (k >= 0 && k < 9) {
                    CK(L.n == 3);
                    ck_announce_4588ad(0, OBJ_VA + 0x52a, 0x8765);
                    ck_tick_4588ad(2);
                    CK(get32(L.c[0].snap_self, 0x32) == 1 && get32(L.c[0].snap_self, 0x20) == 0 && get32(L.c[1].snap_self, 0xbc) == 0xA5A5A5A5u);
                } else {
                    CK(L.n == 1);
                    ck_tick_4588ad(0);
                }
            }
        }
    }
    (void)ck_copy_4588ad;
    if (g_failed) printf("FAIL test_m4588ad_click_279f_27a5: %s\n", g_msg);
    else printf("PASS test_m4588ad_click_279f_27a5\n");
    return g_failed;
}

/* FL25B-TESTS-END */

int main(void)
{
    int failures = 0;
    failures += test_m455180_hit_test();
    failures += test_m4cb058_hit_test();
    failures += test_m4a3f40_hit_test();
    failures += test_m4588ad_click_279f_27a5();
    /* FL25B-MAIN-END */
    return failures;
}
