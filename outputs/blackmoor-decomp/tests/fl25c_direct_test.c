/* FL-25 (batch c) direct tests of the handlers of GAME.EXE in src/original_methods_fl25c.c. Prints "PASS <name>" / "FAIL <name>: <msg>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the
 * disassembly of GAME.EXE, not from running the native code; tests/test_fl25c_differential.py additionally runs the original bytes on
 * generated fixtures.
 *
 * Every function is checked three ways: (1) a guard matrix (each guard of the chain failing in turn leaves the object, the record table
 * and the call log untouched), (2) each arm with the whole object, the record table and the globals compared with a hand-edited copy and
 * the ordered host calls with arguments and the state at the call, (3) the boundaries of signed words and dwords. The whole binary is
 * also run under ASan/UBSan (gcc -fsanitize=address,undefined, -O0/-O1/-O2): every tested input stays inside the buffers. */
#include "../src/original_methods_fl25c.h"

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
    Fl25cWorld w;
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

/* ---- FL25C-TESTS-BEGIN ----------------------------------------------------------------------------------------------------------- */

/* 0x4a8818 (plain ret): record n = word [+0x1e] (state dword at n * 0x8d + 0x4d of the table), R = OBJ_VA (the counts are the words R[+0x43] and
 * R[+0x45], the nine-byte fields R[+0x375] and R[+0x3a6], the words R[+0x396] and R[+0x3c7]). Q = self + 0xa40 + word[+0xe7a] * 0x36 +
 * word[+0xe7c] * 6 = 0xab2 for the words 2 and 1 used here (the cell of i = 2, j = 1 of the loop). The buffer at 0x5a110f is `bufx`, the
 * constants 0x550bac / 0x550bb8 are consts[0] / consts[1]. */
#define Q4A 0xab2
static uint8_t bufx[0x200], xb[0x200];
static const uint8_t NINE[9] = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'};
static const uint8_t CELLQ[6] = {0x11, 0x22, 0x33, 0x44, 0x55, 0x66};
static const uint8_t CELLE[6] = {0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff};
static void setup_4a8818(uint32_t sel, int idx)
{
    size_t k;
    base(sel, idx, 0x1e);
    memset(bufx, 0x77, sizeof bufx);
    fx.w.buf_5a110f = bufx;
    fx.w.bytes_550bac = consts[0];
    fx.w.bytes_550bb8 = consts[1];
    memcpy(consts[0], NINE, 9);
    memcpy(consts[1], NINE, 9);
    for (k = 0; k < 0x1e6; k++) fx.self[0xa40 + k] = (uint8_t)(k * 5 + 3);
    set32(fx.self, 0xe72, 0x100);
    fx.self[0xe83] = 0;
    set32(fx.self, 0xe7f, 0);
    set32(fx.self, 0xe5e, 0);
    set16(fx.self, 0xe7a, 2);
    set16(fx.self, 0xe7c, 1);
    memcpy(fx.self + Q4A, CELLQ, 6);
    memcpy(fx.self + 0xe10, CELLE, 6);
    set16(fx.obj, 0x43, 0);
    set16(fx.obj, 0x45, 0);
    set16(fx.obj, 0x396, 0x8001);
    set16(fx.obj, 0x3c7, 0x8002);
    memcpy(fx.obj + 0x375, NINE, 9);
    memcpy(fx.obj + 0x3a6, NINE, 9);
    fx.w.value_5bb1ca = 0;
}
static void cell_word(int i, int j, uint16_t v) { set16(fx.self, (size_t)(0xa40 + i * 0x36 + j * 6), v); }
/* the expected buffer from the expected object: the 0x1e6-byte copy, then (the dword [+0xe5e] non-zero) every cell of the counts whose first
 * word is -10 receives the six bytes at [+0xe10] */
static void expect_buf(void)
{
    int i, j, c1 = (int16_t)get16x(fx.obj, 0x43), c2 = (int16_t)get16x(fx.obj, 0x45);
    memset(xb, 0x77, sizeof xb);
    memcpy(xb, xs + 0xa40, 0x1e6);
    if (get32(xs, 0xe5e) == 0) return;
    for (i = 0; i < c1; i++)
        for (j = 0; j < c2; j++)
            if ((int16_t)get16x(xb, (size_t)(i * 0x36 + j * 6)) == -10) memcpy(xb + i * 0x36 + j * 6, xs + 0xe10, 6);
}
static void run_4a8818(void)
{
    begin();
    m4a8818_click_2798_279a(fx.self, &fx.w, &fx.host);
}
static void finish_4a8818(void)
{
    expect_buf();
    check_mem();
    CK(memcmp(bufx, xb, sizeof bufx) == 0);
}
static void rec_state(int idx, uint32_t v) { set32(xt, (size_t)(idx + 1) * REC + 0x4d, v); }
/* the nine-byte field `off` of the object differs in byte m (0..8), only in the tenth byte (9), or not at all (-1) */
static void nine_diff(size_t off, int m)
{
    if (m >= 0 && m <= 8) fx.obj[off + (size_t)m] ^= 0x20;
    if (m == 9) fx.obj[off + 9] ^= 0x40;
}
/* the call of 0x4f6334 (this 0x5cf1eb, the sign-extended word) at index `first` and, when it returned 0, the call of 0x4fb2e3 (this 0x5c3a67, the word) */
static void expect_pair(int first, int made, uint32_t sext, uint16_t word, int second)
{
    if (!made) return;
    check_call(first, 0x4f6334, 0x5cf1ebu, 1);
    check_arg(first, 0, sext, 0xffffffffu);
    if (second) {
        check_call(first + 1, 0x4fb2e3, 0x5c3a67u, 1);
        check_arg(first + 1, 0, word, 0xffffu);
    }
}

static int test_m4a8818_click_2798_279a(void)
{
    static const int idxs[2] = {2, -1};
    static const uint32_t sels[4] = {0x279a, 0x2798, 0x2799, 0x2710};
    static const uint16_t lows[4] = {0xfff6, 0x2211, 0x00f6, 0x80f6};
    int ii, g, m, s, mode, lo, res;
    g_failed = 0;
    g_msg[0] = 0;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        g_phase = ii;
        /* each guard failing leaves everything untouched (the buffer too), for every selector and both values of [+0xe5e] */
        for (s = 0; s < 4; s++) {
            for (g = 0; g < 7; g++) {
                setup_4a8818(sels[s], idx);
                set32(fx.self, 0xe5e, (s & 1) ? 0 : 1);
                if (g == 0) set32(fx.self, 0xe72, 0);
                if (g == 1) fx.self[0xe83] = 1;
                if (g == 2) fx.self[0xe83] = 0x80;
                if (g == 3) set32(fx.self, 0xe7f, 0x01000000u);
                if (g == 4) set32(fx.tab, (size_t)(idx + 1) * REC + 0x4d, 0);
                if (g == 5) set32(fx.tab, (size_t)(idx + 1) * REC + 0x4d, 2);
                if (g == 6) set32(fx.tab, (size_t)(idx + 1) * REC + 0x4d, 0xffffffffu);
                begin();
                memcpy(xb, bufx, sizeof xb);
                m4a8818_click_2798_279a(fx.self, &fx.w, &fx.host);
                check_mem();
                CK(L.n == 0);
                CK(memcmp(bufx, xb, sizeof xb) == 0);
            }
        }
        /* [+0xe83] is a byte: non-zero bytes after it do not fail the guard; arm 0x279a: the byte [+0xe7e] = 1 and the record state 2,
         * the buffer is the copy and there is no loop ([+0xe5e] is still 0 even though a count and a -10 cell are there) */
        setup_4a8818(0x279a, idx);
        fx.self[0xe84] = 0xff;
        fx.self[0xe85] = 0xff;
        cell_word(0, 0, 0xfff6);
        set16(fx.obj, 0x43, 2);
        set16(fx.obj, 0x45, 2);
        run_4a8818();
        X8(0xe7e, 1);
        rec_state(idx, 2);
        finish_4a8818();
        CK(L.n == 0);
        /* [+0xe5e] != 0 with 0x279a / 0x2798 / unrelated selectors: only the copy and the loop; 0x2799 with [+0xe5e] == 0: the copy only */
        for (s = 0; s < 5; s++) {
            static const uint32_t ss[5] = {0x279a, 0x2798, 0x2710, 0x2799, 0x2797};
            setup_4a8818(ss[s], idx);
            set32(fx.self, 0xe5e, s == 3 ? 0u : 0x01000000u);
            set16(fx.obj, 0x43, 3);
            set16(fx.obj, 0x45, 4);
            cell_word(0, 0, 0xfff6);
            cell_word(1, 2, 0xfff6);
            cell_word(2, 3, 0xfff6);
            cell_word(0, 1, 0x00f6);
            cell_word(2, 0, 0xfff7);
            cell_word(0, 4, 0xfff6);      /* j == the count: not visited */
            cell_word(3, 0, 0xfff6);      /* i == the count: not visited */
            run_4a8818();
            finish_4a8818();
            CK(L.n == 0);
            CK(get32(fx.self, 0xe5e) == (s == 3 ? 0u : 0x01000000u));
        }
        /* the loop counts are signed words: negative and zero visit nothing; junk above a word is ignored */
        for (s = 0; s < 6; s++) {
            static const int16_t c1[6] = {-1, 0, 2, 2, 1, 2}, c2[6] = {3, 3, -1, 0, 5, 2};
            setup_4a8818(0x2710, idx);
            set32(fx.self, 0xe5e, 1);
            set16(fx.obj, 0x43, (uint16_t)c1[s]);
            set16(fx.obj, 0x45, (uint16_t)c2[s]);
            set16(fx.obj, 0x47, 0x7fff);
            fx.obj[0x41] = 0x55;
            cell_word(0, 0, 0xfff6);
            cell_word(1, 1, 0xfff6);
            cell_word(0, 4, 0xfff6);
            run_4a8818();
            finish_4a8818();
            CK(L.n == 0);
        }
        /* arm 0x2798 ([+0xe5e] == 0): [+0xe76] = 0, [+0xe5e] = 1, [+0xe56] = 1, the cell Q goes to [+0xe10], its first word becomes 0xfff6.
         * m: -2 the flag 0x5bb1ca is zero, -1 equal, 0..8 byte m differs, 9 only the unchecked tenth byte differs; res: 0x4f6334 returns 0 or not */
        for (m = -2; m <= 9; m++) {
            for (res = 0; res < 2; res++) {
                int differs = m >= 0 && m <= 8;
                setup_4a8818(0x2798, idx);
                set32(fx.self, 0xe76, 0xdeadbeefu);
                set32(fx.self, 0xe56, 0);
                cell_word(0, 0, 0xfff6);
                set16(fx.obj, 0x43, 3);
                set16(fx.obj, 0x45, 2);
                fx.w.value_5bb1ca = m == -2 ? 0u : 0x10000u;
                nine_diff(0x375, m);
                g_ret_by[0].callee = 0x4f6334;
                g_ret_by[0].value = res ? 0x100u : 0u;
                g_phase2 = m;
                run_4a8818();
                X32(0xe76, 0);
                X32(0xe5e, 1);
                X32(0xe56, 1);
                memcpy(xs + 0xe10, CELLQ, 6);
                X16(Q4A, 0xfff6);
                finish_4a8818();
                CK(L.n == (differs ? (res ? 1 : 2) : 0));
                expect_pair(0, differs, 0xffff8001u, 0x8001, !res);
                if (differs) {
                    CK(get32(L.c[0].snap_self, 0xe5e) == 1 && get32(L.c[0].snap_self, 0xe56) == 1 && get32(L.c[0].snap_self, 0xe76) == 0);
                    CK(memcmp(L.c[0].snap_self + 0xe10, CELLQ, 6) == 0 && get16x(L.c[0].snap_self, Q4A) == 0xfff6);
                }
                /* the loop (e5e is 1 now): the cells (0, 0) and (2, 1) = Q (its word was set to -10 by the handler) receive [+0xe10] */
                CK(memcmp(bufx, CELLQ, 6) == 0);
                CK(memcmp(bufx + 2 * 0x36 + 6, CELLQ, 6) == 0);
            }
        }
        /* arm 0x2799 ([+0xe5e] != 0): the cell Q is saved, [+0xe10] goes to Q, [+0xe5a] = [+0xe62] = 1, words [+0xe66] = 1, [+0xe68] = 2;
         * the saved first word -10 (sign-extended compare): [+0xe5e] = 0 and 0x4a8bf2(self); else [+0xe56] = 1 and the saved cell goes to [+0xe10] */
        for (lo = 0; lo < 4; lo++) {
            for (mode = -2; mode < 3; mode++) {
                for (res = 0; res < 2; res++) {
                    int differs = mode == 0 || mode == 1;
                    uint8_t saved[6];
                    int hit = lows[lo] == 0xfff6;
                    int ncalls;
                    setup_4a8818(0x2799, idx);
                    set32(fx.self, 0xe5e, 0x100);
                    set32(fx.self, 0xe56, 0);
                    set32(fx.self, 0xe5a, 0);
                    set32(fx.self, 0xe62, 0);
                    set16(fx.self, Q4A, lows[lo]);
                    cell_word(0, 0, 0xfff6);
                    set16(fx.obj, 0x43, 3);
                    set16(fx.obj, 0x45, 2);
                    fx.w.value_5bb1ca = mode == -2 ? 0u : 0x10000u;
                    nine_diff(0x3a6, mode == 2 ? 9 : mode == 1 ? 8 : mode == 0 ? 0 : -1);
                    g_ret_by[0].callee = 0x4f6334;
                    g_ret_by[0].value = res ? 0x100u : 0u;
                    memcpy(saved, fx.self + Q4A, 6);
                    g_phase2 = lo * 10 + mode;
                    run_4a8818();
                    memcpy(xs + Q4A, CELLE, 6);
                    X32(0xe5a, 1);
                    X32(0xe62, 1);
                    X16(0xe66, 1);
                    X16(0xe68, 2);
                    if (hit) {
                        X32(0xe5e, 0);
                    } else {
                        X32(0xe56, 1);
                        memcpy(xs + 0xe10, saved, 6);
                    }
                    finish_4a8818();
                    ncalls = (differs ? (res ? 1 : 2) : 0) + (hit ? 1 : 0);
                    CK(L.n == ncalls);
                    expect_pair(0, differs, 0xffff8002u, 0x8002, !res);
                    if (differs) {
                        CK(get32(L.c[0].snap_self, 0xe5a) == 1 && get32(L.c[0].snap_self, 0xe62) == 1 && get32(L.c[0].snap_self, 0xe5e) == 0x100);
                        CK(memcmp(L.c[0].snap_self + Q4A, CELLE, 6) == 0 && get16x(L.c[0].snap_self, 0xe66) == 1 && get16x(L.c[0].snap_self, 0xe68) == 2);
                        CK(get32(L.c[0].snap_self, 0xe56) == 0);
                    }
                    if (hit) {
                        check_call(ncalls - 1, 0x4a8bf2, (uintptr_t)fx.self, 0);
                        CK(get32(L.c[ncalls - 1].snap_self, 0xe5e) == 0);
                    }
                }
            }
        }
    }
    if (g_failed) printf("FAIL test_m4a8818_click_2798_279a: %s\n", g_msg);
    else printf("PASS test_m4a8818_click_2798_279a\n");
    return g_failed;
}

/* FL25C-TESTS-END */

int main(void)
{
    int failures = 0;
    failures += test_m4a8818_click_2798_279a();
    /* FL25C-MAIN-END */
    return failures;
}
