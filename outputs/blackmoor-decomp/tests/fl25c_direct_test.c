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
#define BIG 0x4b00
#define OBJ_SLACK 0x400           /* readable bytes below the object of the target record */

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
    uint8_t obj_lo[OBJ_SLACK];                       /* slack just below obj (adjacent: a negative record entry index reads here) */
    uint8_t obj[0x1000], decoy[0x1000], obj2[0x1000], mask[0x20100];
    Fl25cWorld w;
    Fl18Host host;
} fx;
static uint8_t xs[BIG], xt[TAB_SZ], xo_lo[OBJ_SLACK], xo[0x1000];     /* the expected object, record table and target object */
static uint8_t consts[8][16];                        /* nine-byte constants (the tables of the original) */

static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[4];
        uint8_t snap_self[BIG], snap_obj[0x100], snap_str[224];
    } c[24];
} L;
static uint32_t g_tick, g_out_4aec35;
static int g_snap_n;                       /* 0x448d11: how many bytes behind its second argument the host call copies */
static struct { uint32_t callee, value; } g_ret_by[4];

static const uint8_t *host_resolve(void *ctx, uint32_t a);
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
    if (callee == 0x448d11 && nargs == 4 && g_snap_n > 0) {
        const uint8_t *sp = args[1] > 0xffffffffu ? (const uint8_t *)args[1] : host_resolve(NULL, (uint32_t)args[1]);
        if (sp != NULL) memcpy(L.c[k].snap_str, sp, (size_t)g_snap_n);
    }
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
    memset(fx.obj_lo, 0x6d, sizeof fx.obj_lo);
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
    memcpy(xo_lo, fx.obj_lo, sizeof xo_lo);
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
    CK(memcmp(fx.obj_lo, xo_lo, sizeof xo_lo) == 0);
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

/* 0x4aa3d2 (plain ret): record n = word [+0x21]; R = OBJ_VA. Here k = the word [+0x23] = 2, so the entry offset is E = k * 0x15c = 0x2b8:
 * the word R[E + 0x233] (0x4eb), the nine bytes R[E + 0x119] (0x3d1), the word R[E + 0x13a] (0x3f2), the strings R[E + 0x14a] (0x402) and
 * R[E + 0x16b] (0x423). Arm 1 uses R[+0x52], R[+0x73], R[+0x83], R[+0xf7], R[+0x21], R[+0x42]. The constants 0x550e2c / 0x550e38 / 0x550e44
 * are consts[0..2], the byte array at 0x630a60 is `b630`, the string S returned by 0x423259 lives in obj2 (or in the big mask). */
#define E4B 0x2b8
static uint8_t b630[0x80], x630[0x80];
static void setup_4aa3d2(uint32_t sel, int idx)
{
    base(sel, idx, 0x21);
    memset(b630, 0x99, sizeof b630);
    fx.w.buf_630a60 = b630;
    fx.w.bytes_550e2c = consts[0];
    fx.w.bytes_550e38 = consts[1];
    fx.w.bytes_550e44 = consts[2];
    memcpy(consts[0], NINE, 9);
    memcpy(consts[1], NINE, 9);
    memcpy(consts[2], NINE, 9);
    fx.w.value_5bb202 = 0x100;
    fx.w.value_5d03b3 = 0xa1b2c3d4u;
    fx.w.value_550e50 = 0x3c653e00u;
    g_snap_n = 0;
    fx.self[0x45] = 1;
    fx.self[0x46] = 0;
    fx.self[0x47] = 0;
    set16(fx.self, 0x23, 2);
    set16(fx.self, 0x40, 0x1234);
    set16(fx.self, 0x42, 0x2222);
    set16(fx.self, 0x48, 0x0010);
    set32(fx.self, 0x25, 0x77);
    fx.self[0x2b] = 0x55;
    memset(fx.self + 0x2c, 0, 0x10);
    set16(fx.obj, E4B + 0x233, 0x1234);
    set16(fx.obj, E4B + 0x13a, 0x8123);
    set16(fx.obj, 0x73, 0x8456);
    set16(fx.obj, 0x42, 0x8789);
    set16(fx.obj, 0xf7, 0);
    fx.obj[0x83] = 0;
    memcpy(fx.obj + 0x52, NINE, 9);
    memcpy(fx.obj + 0x21, NINE, 9);
    memcpy(fx.obj + E4B + 0x119, NINE, 9);
    fx.obj[E4B + 0x14a] = 0;
    fx.obj[E4B + 0x16b] = 0;
}
static void run_4aa3d2(void)
{
    begin();
    memcpy(x630, b630, sizeof x630);
    m4aa3d2_click_276f_2771(fx.self, &fx.w, &fx.host);
}
static void finish_4aa3d2(void)
{
    check_mem();
    CK(memcmp(b630, x630, sizeof x630) == 0);
}
static void set_str(size_t off, size_t n, uint8_t first)
{
    size_t i;
    for (i = 0; i < n; i++) fx.obj[off + i] = (uint8_t)(first + i % 7);
    fx.obj[off + n] = 0;
}
/* the nine bytes of the object at `off` differ in byte m (0..8) or only in the tenth (9) */
static void nine_diff2(size_t off, int m)
{
    if (m >= 0 && m <= 8) fx.obj[off + (size_t)m] ^= 0x20;
    if (m == 9) fx.obj[off + 9] ^= 0x40;
}

/* the byte n of the object of the target record, n may be negative (the slack fx.obj_lo lies right below it) */
static uint8_t *objat(ptrdiff_t n) { return fx.obj + n; }

static int test_m4aa3d2_click_276f_2771(void)
{
    (void)m4aa3d2_click_276f_2771;
    static const int idxs[2] = {1, -1};
    static const uint32_t sels[4] = {0x276f, 0x2770, 0x2771, 0x2710};
    static const int lens[12] = {0, 1, 2, 3, 4, 5, 7, 8, 11, 27, 200, 28};
    int ii, s, g, m, res, k, i;
    g_failed = 0;
    g_msg[0] = 0;
    CK(fx.obj == fx.obj_lo + OBJ_SLACK);       /* the slack is adjacent: the negative entry indices below read it */
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        g_phase = ii;
        /* guards: the byte [+0x45] (the bytes after it do not count) and the record state 1; nothing stored, no call */
        for (s = 0; s < 4; s++) {
            for (g = 0; g < 5; g++) {
                setup_4aa3d2(sels[s], idx);
                if (g == 0) fx.self[0x45] = 0;
                if (g == 0) set32(fx.self, 0x46, 0xffffffffu);
                if (g == 1) set32(fx.tab, (size_t)(idx + 1) * REC + 0x4d, 0);
                if (g == 2) set32(fx.tab, (size_t)(idx + 1) * REC + 0x4d, 2);
                if (g == 3) set32(fx.tab, (size_t)(idx + 1) * REC + 0x4d, 0xffffffffu);
                if (g == 4) set32(fx.tab, (size_t)(idx + 1) * REC + 0x4d, 0x100);
                run_4aa3d2();
                finish_4aa3d2();
                CK(L.n == 0);
            }
        }
        /* [+0x45] is a byte: a non-zero byte with zero bytes after it passes (the handler acts: event 0x2771 here) */
        setup_4aa3d2(0x2771, idx);
        fx.self[0x46] = 0;
        fx.self[0x47] = 0;
        fx.self[0x48] = 0;
        run_4aa3d2();
        X8(0x46, 1);
        rec_state(idx, 2);
        finish_4aa3d2();
        CK(L.n == 0);
        /* event 0x2771: the byte [+0x46] = 1 and the state 2, whatever the byte [+0x47] is; nothing else changes */
        for (k = 0; k < 3; k++) {
            setup_4aa3d2(0x2771, idx);
            fx.self[0x47] = (uint8_t)(k == 0 ? 0 : k == 1 ? 1 : 0xff);
            run_4aa3d2();
            X8(0x46, 1);
            rec_state(idx, 2);
            finish_4aa3d2();
            CK(L.n == 0);
        }
        /* 0x276f with the byte [+0x47] non-zero acts as an unrelated event (nothing), and an unrelated event does nothing */
        for (k = 0; k < 2; k++) {
            setup_4aa3d2(k ? 0x2710 : 0x276f, idx);
            fx.self[0x47] = 1;
            run_4aa3d2();
            finish_4aa3d2();
            CK(L.n == 0);
        }
        /* arm 1a (0x276f): the word r[k * 0x15c + 0x233] equals the word [+0x40] and the byte [+0x2c + k] is zero: the word [+0x48] += 1 (wraps),
         * the byte [+0x2c + k] = 1, [+0x25] = 1 and 0x4fb2e3(word r[+0x73]) when the nine bytes r[+0x52] differ from consts[0], else [+0x25] = 0;
         * the byte [+0x2b] = 0. k = 2, then k = -1 (the flag byte is [+0x2b] itself) */
        for (k = 0; k < 2; k++) {
            for (m = -1; m <= 9; m++) {
                for (res = 0; res < 2; res++) {
                    int kk = k ? -1 : 2, differs = m >= 0 && m <= 8;
                    setup_4aa3d2(0x276f, idx);
                    set16(fx.self, 0x23, (uint16_t)(int16_t)kk);
                    if (kk == -1) fx.self[0x2b] = 0;
                    set16(fx.obj, (size_t)(kk * 0x15c + 0x233), 0x4321);
                    set16(fx.self, 0x40, 0x4321);
                    set32(fx.self, 0x40, 0xabcd4321u);           /* (the dword above the word is junk: a word compare) */
                    set16(fx.self, 0x48, res ? 0xffff : 0x0010);
                    nine_diff2(0x52, m);
                    run_4aa3d2();
                    X16(0x42, (uint16_t)(int16_t)kk);
                    X16(0x48, res ? 0 : 0x0011);
                    X8(0x2c + kk, 1);
                    X32(0x25, differs ? 1u : 0u);
                    X8(0x2b, 0);
                    finish_4aa3d2();
                    CK(L.n == (differs ? 1 : 0));
                    if (differs) {
                        check_call(0, 0x4fb2e3, 0x5c3a67u, 1);
                        check_arg(0, 0, 0x8456, 0xffffu);
                        CK(get32(L.c[0].snap_self, 0x25) == 0x77 && L.c[0].snap_self[0x2c + kk] == 1);
                    }
                }
            }
        }
        /* arm 1b: the words differ, or the flag byte is set (or both): when the byte r[+0x83] is non-zero the byte [+0x44] = 1, the word [+0x48] = 0
         * and the first (word r[+0xf7]) bytes at 0x630a60 are cleared; the nine bytes r[+0x21] against consts[1]: differ gives
         * 0x4fb2e3(word r[+0x42]) and [+0x25] = 1, else 0; [+0x2b] = 0 */
        for (k = 0; k < 4; k++) {
            for (m = -1; m <= 9; m++) {
                for (res = 0; res < 6; res++) {
                    static const int16_t cnts[6] = {0, 3, 1, -1, -0x8000, 0x40};
                    int differs = m >= 0 && m <= 8, flag = res != 0 ? 1 : 0, cnt = cnts[res];
                    setup_4aa3d2(0x276f, idx);
                    if (k == 0 || k == 2) set16(fx.self, 0x40, 0x1235);          /* the words differ by one */
                    if (k == 1 || k == 2) fx.self[0x2c + 2] = (uint8_t)(k == 1 ? 1 : 0x80);
                    if (k == 3) {
                        set16(fx.self, 0x40, 0x9234);                              /* (only the top bit differs) */
                        fx.self[0x2c + 2] = 0xff;
                    }
                    fx.obj[0x83] = (uint8_t)(flag ? (k == 0 ? 1 : 0x80) : 0);
                    fx.obj[0x84] = 0xff;
                    set16(fx.obj, 0xf7, (uint16_t)cnt);
                    nine_diff2(0x21, m);
                    run_4aa3d2();
                    X16(0x42, 2);
                    if (flag) {
                        X8(0x44, 1);
                        X16(0x48, 0);
                        for (i = 0; i < cnt && i < 0x80; i++) x630[i] = 0;
                    }
                    X32(0x25, differs ? 1u : 0u);
                    X8(0x2b, 0);
                    finish_4aa3d2();
                    CK(L.n == (differs ? 1 : 0));
                    if (differs) {
                        check_call(0, 0x4fb2e3, 0x5c3a67u, 1);
                        check_arg(0, 0, 0x8789, 0xffffu);
                    }
                }
            }
        }
        /* arm 2 (0x2770), the nine bytes at R[E + 0x119] against consts[2]: equal (also when only the tenth differs) skips every call; the
         * stores [+0x42] = [+0x23], [+0x40] = the word r[E + 0x233], [+0x2b] = 0, [+0x25] = 2 are made in all cases (also with the byte [+0x47] set) */
        for (m = -1; m <= 9; m++) {
            for (k = 0; k < 2; k++) {
                int differs = m >= 0 && m <= 8;
                setup_4aa3d2(0x2770, idx);
                fx.self[0x47] = (uint8_t)(k ? 0x80 : 0);
                set16(fx.obj, E4B + 0x233, 0xbeef);
                nine_diff2(E4B + 0x119, m);
                fx.w.value_5bb202 = 0;
                run_4aa3d2();
                X16(0x42, 2);
                X16(0x40, 0xbeef);
                X8(0x2b, 0);
                X32(0x25, 2);
                finish_4aa3d2();
                CK(L.n == (differs ? 2 : 0));
                if (differs) {
                    check_call(0, 0x4fb77a, 0x5c3a67u, 1);
                    check_arg(0, 0, OBJ_VA + E4B + 0x119, 0xffffffffu);
                    check_call(1, 0x4fb2e3, 0x5c3a67u, 1);
                    check_arg(1, 0, 0x8123, 0xffffu);
                    CK(get16x(L.c[0].snap_self, 0x40) == 0xbeef && get16x(L.c[0].snap_self, 0x42) == 2 && get32(L.c[0].snap_self, 0x25) == 0x77);
                }
            }
        }
        /* arm 2 with the flag dword 0x5bb202 non-zero (any bit): the strings. string 1 empty: only string 2 is looked at (empty: no call; else
         * 0x448d11(this 0x619a05, [0x5d03b3], its address, -1, 0)) */
        for (g = 0; g < 4; g++) {
            static const uint32_t flags[4] = {1, 0x100, 0x80000000u, 0xffffffffu};
            for (k = 0; k < 3; k++) {
                static const int l2[3] = {0, 1, 28};
                setup_4aa3d2(0x2770, idx);
                nine_diff2(E4B + 0x119, 0);
                fx.w.value_5bb202 = flags[g];
                set_str(E4B + 0x16b, (size_t)l2[k], 0x41);
                g_snap_n = l2[k] + 4;
                run_4aa3d2();
                X16(0x42, 2);
                X16(0x40, 0x1234);
                X8(0x2b, 0);
                X32(0x25, 2);
                finish_4aa3d2();
                CK(L.n == 2 + (l2[k] != 0 ? 1 : 0));
                if (l2[k] != 0) {
                    check_call(2, 0x448d11, 0x619a05u, 4);
                    check_arg(2, 0, 0xa1b2c3d4u, 0xffffffffu);
                    check_arg(2, 1, OBJ_VA + E4B + 0x16b, 0xffffffffu);
                    check_arg(2, 2, 0xffffffffu, 0xffffffffu);
                    check_arg(2, 3, 0, 0xffffffffu);
                    CK(memcmp(L.c[2].snap_str, fx.obj + E4B + 0x16b, (size_t)l2[k] + 1) == 0);
                    CK(get32(L.c[2].snap_self, 0x25) == 0x77);
                }
            }
        }
        /* arm 2 with a negative entry index: the word [+0x23] = 0xffff / 0xfffe is sign-extended (k = -1 / -2), so the entry lies BELOW the object
         * (E = k * 0x15c; the object has OBJ_SLACK readable bytes under it). v 0: flag dword zero; v 1: string 1 empty, string 2 "xyz"; v 2: string 1
         * "ab" and S = a 5-byte string from 0x423259 (copied into the local buffer). A zero extension (E = 0xffff * 0x15c) would read far away. */
        for (k = 0; k < 2; k++) {
            int v;
            for (v = 0; v < 3; v++) {
                int kk = k ? -2 : -1;
                ptrdiff_t E = (ptrdiff_t)kk * 0x15c;
                uint32_t eu = (uint32_t)(int32_t)E;
                int j;
                setup_4aa3d2(0x2770, idx);
                set16(fx.self, 0x23, (uint16_t)(int16_t)kk);
                set16(objat(E), 0x233, 0xcafe);
                set16(objat(E), 0x13a, 0x8123);
                memset(objat(E) + 0x119, 0x37, 9);
                objat(E)[0x14a] = 0;
                objat(E)[0x16b] = 0;
                fx.w.value_5bb202 = v ? 0x100u : 0;
                if (v == 1) {
                    memcpy(objat(E) + 0x16b, "xyz", 4);
                    g_snap_n = 7;
                }
                if (v == 2) {
                    memcpy(objat(E) + 0x14a, "ab", 3);
                    memcpy(objat(E) + 0x16b, "xyz", 4);
                    memset(fx.obj2, 0x44, 0x1000);
                    for (j = 0; j < 5; j++) fx.obj2[0x10 + j] = (uint8_t)('h' + j);
                    fx.obj2[0x15] = 0;
                    g_ret_by[0].callee = 0x423259;
                    g_ret_by[0].value = OBJ2_VA + 0x10;
                    g_snap_n = 9;
                }
                g_phase2 = kk;
                run_4aa3d2();
                X16(0x42, (uint16_t)(int16_t)kk);
                X16(0x40, 0xcafe);
                X8(0x2b, 0);
                X32(0x25, 2);
                finish_4aa3d2();
                CK(L.n == (v == 0 ? 2 : v == 1 ? 3 : 4));
                check_call(0, 0x4fb77a, 0x5c3a67u, 1);
                check_arg(0, 0, OBJ_VA + eu + 0x119, 0xffffffffu);
                check_call(1, 0x4fb2e3, 0x5c3a67u, 1);
                check_arg(1, 0, 0x8123, 0xffffu);
                CK(get16x(L.c[0].snap_self, 0x40) == 0xcafe && get16x(L.c[0].snap_self, 0x42) == (uint16_t)(int16_t)kk);
                if (v == 1) {
                    check_call(2, 0x448d11, 0x619a05u, 4);
                    check_arg(2, 1, OBJ_VA + eu + 0x16b, 0xffffffffu);
                    CK(memcmp(L.c[2].snap_str, "xyz", 4) == 0);
                }
                if (v == 2) {
                    static const uint8_t want[9] = {'h', 'i', 'j', 'k', 'l', 0x00, 0x3e, 0x65, 0x3c};
                    check_call(2, 0x423259, 0x619a6bu, 1);
                    check_arg(2, 0, OBJ_VA + eu + 0x14a, 0xffffffffu);
                    check_call(3, 0x448d11, 0x619a05u, 4);
                    CK(memcmp(L.c[3].snap_str, want, 9) == 0);
                }
            }
        }
        /* string 1 non-empty: 0x423259(this 0x619a6b, the address of string 1) gives S. S = 0: string 2 as above. S a string of n <= 200 bytes
         * (any alignment of its length): copied with its zero into the local buffer, the dword 0x550e50 stored at the zero, and
         * 0x448d11(this 0x619a05, [0x5d03b3], the local buffer, -1, 0) runs; string 2 is then NOT looked at. */
        for (s = 0; s < 12; s++) {
            for (k = 0; k < 2; k++) {
                int n = lens[s], j, calls;
                uint8_t want[224];
                setup_4aa3d2(0x2770, idx);
                nine_diff2(E4B + 0x119, 8);
                set_str(E4B + 0x14a, 5, 0x61);
                set_str(E4B + 0x16b, k ? 3 : 0, 0x51);
                memset(fx.obj2, 0x44, 0x1000);
                for (j = 0; j < n; j++) fx.obj2[0x10 + j] = (uint8_t)(0x21 + j % 90);
                fx.obj2[0x10 + n] = 0;
                memset(want, 0xee, sizeof want);
                memcpy(want, fx.obj2 + 0x10, (size_t)n);
                want[n] = 0x00;
                want[n + 1] = 0x3e;
                want[n + 2] = 0x65;
                want[n + 3] = 0x3c;
                g_ret_by[0].callee = 0x423259;
                g_ret_by[0].value = OBJ2_VA + 0x10;
                g_snap_n = n + 4;
                g_phase2 = n;
                run_4aa3d2();
                X16(0x42, 2);
                X16(0x40, 0x1234);
                X8(0x2b, 0);
                X32(0x25, 2);
                finish_4aa3d2();
                calls = 3 + 1;
                CK(L.n == calls);
                check_call(2, 0x423259, 0x619a6bu, 1);
                check_arg(2, 0, OBJ_VA + E4B + 0x14a, 0xffffffffu);
                check_call(3, 0x448d11, 0x619a05u, 4);
                check_arg(3, 0, 0xa1b2c3d4u, 0xffffffffu);
                check_arg(3, 2, 0xffffffffu, 0xffffffffu);
                check_arg(3, 3, 0, 0xffffffffu);
                CK(memcmp(L.c[3].snap_str, want, (size_t)n + 4) == 0);
            }
        }
        /* S = 0 with string 1 non-empty: string 2 (non-empty or empty); S longer than 0x9c40 counts as 0 as well */
        for (s = 0; s < 4; s++) {
            static const int mode[4] = {0, 1, 0, 1};
            static const int l2[4] = {3, 3, 0, 0};
            setup_4aa3d2(0x2770, idx);
            nine_diff2(E4B + 0x119, 3);
            set_str(E4B + 0x14a, 2, 0x61);
            set_str(E4B + 0x16b, (size_t)l2[s], 0x51);
            if (mode[s]) {
                memset(fx.mask, 'Z', 0x9c41);
                fx.mask[0x9c41] = 0;
                g_ret_by[0].value = MASK_VA;
            } else {
                g_ret_by[0].value = 0;
            }
            g_ret_by[0].callee = 0x423259;
            g_snap_n = l2[s] + 4;
            run_4aa3d2();
            X16(0x42, 2);
            X16(0x40, 0x1234);
            X8(0x2b, 0);
            X32(0x25, 2);
            finish_4aa3d2();
            CK(L.n == 3 + (l2[s] != 0 ? 1 : 0));
            check_call(2, 0x423259, 0x619a6bu, 1);
            if (l2[s] != 0) {
                check_call(3, 0x448d11, 0x619a05u, 4);
                check_arg(3, 1, OBJ_VA + E4B + 0x16b, 0xffffffffu);
            }
        }
        /* unsafe original behaviour, rejected by the port (no further call or store): S of 201 .. 0x9c40 bytes would overrun the 0xcc-byte
         * frame buffer; S that is not a resolvable address. The stores made before the call (the words [+0x42] and [+0x40]) remain. */
        for (s = 0; s < 4; s++) {
            static const size_t bad[4] = {201, 0x9c40, 1000, 0};
            setup_4aa3d2(0x2770, idx);
            nine_diff2(E4B + 0x119, 1);
            set_str(E4B + 0x14a, 2, 0x61);
            set_str(E4B + 0x16b, 3, 0x51);
            g_ret_by[0].callee = 0x423259;
            if (s == 3) {
                g_ret_by[0].value = 0x30000000u;
            } else {
                memset(fx.mask, 'Y', bad[s]);
                fx.mask[bad[s]] = 0;
                g_ret_by[0].value = MASK_VA;
            }
            g_snap_n = 8;
            run_4aa3d2();
            X16(0x42, 2);
            X16(0x40, 0x1234);
            finish_4aa3d2();
            CK(L.n == 3);
            CK(get32(fx.self, 0x25) == 0x77 && fx.self[0x2b] == 0x55);
        }
    }
    if (g_failed) printf("FAIL test_m4aa3d2_click_276f_2771: %s\n", g_msg);
    else printf("PASS test_m4aa3d2_click_276f_2771\n");
    return g_failed;
}

/* 0x46c6a9 (plain ret): record n = word [+0x1e]; R = OBJ_VA (the nine bytes R[+0x63d] / R[+0x60c], the words R[+0x65e] / R[+0x62d]). Cells are
 * 16 bytes at self + 0x48a0 + 16 * index; the indices are the words [+0x49e0] (k0) and [+0x49e2] (k2). The constants 0x54bd00 / 0x54bd0c are
 * consts[0] / consts[1]; the copy target 0x5a14df is `buf46`. The expected object is built store by store, in the order of the disassembly
 * (a later read sees the earlier stores: k0 == k2 and the cell words matter). */
static uint8_t buf46[0x180], xb46[0x180];
static const uint8_t NINE46[9] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'};
#define CELL(k) (0x48a0 + 16 * (k))
static void setup_46c6a9(uint32_t sel, int idx, int k0, int k2)
{
    size_t i;
    base(sel, idx, 0x1e);
    memset(buf46, 0x77, sizeof buf46);
    fx.w.buf_5a14df = buf46;
    fx.w.bytes_54bd00 = consts[0];
    fx.w.bytes_54bd0c = consts[1];
    memcpy(consts[0], NINE46, 9);
    memcpy(consts[1], NINE46, 9);
    fx.w.value_5bb1ca = 0;
    for (i = 0; i < 0x1a0; i++) fx.self[0x48a0 + i] = (uint8_t)(i * 3 + 1);
    set32(fx.self, 0x4a48, 0x100);
    fx.self[0x4a59] = 0;
    set32(fx.self, 0x4a55, 0);
    fx.self[0x4a59] = 0;
    set32(fx.self, 0x4a2c, 0);
    set16(fx.self, 0x49e0, (uint16_t)(int16_t)k0);
    set16(fx.self, 0x49e2, (uint16_t)(int16_t)k2);
    set16(fx.self, 0x4a50, 0x1111);
    set16(fx.self, 0x4a52, 0x2222);
    set32(fx.self, 0x4a24, 0x77777777u);
    set32(fx.self, 0x4a28, 0x77777777u);
    set32(fx.self, 0x4a30, 0x77777777u);
    set32(fx.self, 0x4a34, 0x77777777u);
    set32(fx.self, 0x4a4c, 0x77777777u);
    fx.self[0x4a54] = 0x66;
    set16(fx.self, 0x4a3c, 0x6666);
    set16(fx.self, 0x4a3e, 0x6666);
    memcpy(fx.obj + 0x63d, NINE46, 9);
    memcpy(fx.obj + 0x60c, NINE46, 9);
    set16(fx.obj, 0x65e, 0x8111);
    set16(fx.obj, 0x62d, 0x8222);
}
static void run_46c6a9(void)
{
    begin();
    m46c6a9_click_27e2_27ea(fx.self, &fx.w, &fx.host);
}
static void finish_46c6a9(int copied)
{
    check_mem();
    memset(xb46, 0x77, sizeof xb46);
    if (copied) memcpy(xb46, xs + 0x48a0, 0x140);
    CK(memcmp(buf46, xb46, sizeof buf46) == 0);
}
static void nine_diff3(size_t off, int m)
{
    if (m >= 0 && m <= 8) fx.obj[off + (size_t)m] ^= 0x20;
    if (m == 9) fx.obj[off + 9] ^= 0x40;
}
#define XW(off) get16x(xs, (off))

static int test_m46c6a9_click_27e2_27ea(void)
{
    (void)m46c6a9_click_27e2_27ea;
    static const int idxs[2] = {0, -1};
    static const uint32_t all[8] = {0x27ea, 0x27e6, 0x27e8, 0x27e2, 0x27e3, 0x27e4, 0x27e5, 0x2710};
    static const int ks[4][2] = {{3, 5}, {5, 5}, {-1, 2}, {18, 0}};
    int ii, s, g, p, m, res;
    g_failed = 0;
    g_msg[0] = 0;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        g_phase = ii;
        /* guards: each failing leaves everything (the copy target too) untouched, for all events and both values of [+0x4a2c] */
        for (s = 0; s < 8; s++) {
            for (g = 0; g < 6; g++) {
                setup_46c6a9(all[s], idx, 3, 5);
                set32(fx.self, 0x4a2c, (s & 1) ? 0x100u : 0);
                if (g == 0) set32(fx.self, 0x4a48, 0);
                if (g == 1) fx.self[0x4a59] = 1;
                if (g == 2) fx.self[0x4a59] = 0x80;
                if (g == 3) set32(fx.self, 0x4a55, 0x01000000u);
                if (g == 4) set32(fx.tab, (size_t)(idx + 1) * REC + 0x4d, 0);
                if (g == 5) set32(fx.tab, (size_t)(idx + 1) * REC + 0x4d, 2);
                fx.w.value_5bb1ca = 1;
                nine_diff3(0x63d, 0);
                nine_diff3(0x60c, 0);
                run_46c6a9();
                finish_46c6a9(0);
                CK(L.n == 0);
            }
        }
        /* [+0x4a59] is a byte: non-zero bytes after it do not fail the guard; 0x27ea with [+0x4a2c] == 0: the byte [+0x4a54] = 1 and the state 2 */
        setup_46c6a9(0x27ea, idx, 3, 5);
        fx.self[0x4a5a] = 0xff;
        fx.self[0x4a5b] = 0xff;
        run_46c6a9();
        X8(0x4a54, 1);
        rec_state(idx, 2);
        finish_46c6a9(1);
        CK(L.n == 0);
        /* [+0x4a2c] != 0 with 0x27ea, and an unrelated event with either value: only the copy (and no call, though 0x5bb1ca is set and the nine bytes differ) */
        for (s = 0; s < 4; s++) {
            setup_46c6a9(s < 2 ? 0x27ea : 0x2710, idx, 3, 5);
            set32(fx.self, 0x4a2c, (s & 1) ? 0x100u : 0);
            if (s == 0) set32(fx.self, 0x4a2c, 0x80000000u);
            fx.w.value_5bb1ca = 1;
            nine_diff3(0x63d, 2);
            nine_diff3(0x60c, 2);
            run_46c6a9();
            finish_46c6a9(1);
            CK(L.n == 0);
        }
        /* [+0x4a2c] == 0 with 0x27e6 / 0x27e8 */
        for (p = 0; p < 4; p++) {
            for (s = 1; s <= 2; s++) {
                int k2 = ks[p][1];
                setup_46c6a9(all[s], idx, ks[p][0], k2);
                run_46c6a9();
                X16(0x49e0, (uint16_t)(int16_t)k2);
                X32(0x4a4c, 0);
                X32(0x4a2c, 1);
                X32(0x4a24, 1);
                if (s == 1) {
                    X32(0x4a30, 1);
                    X16(0x4a3c, XW(CELL(k2) + 0xa));
                    X16(0x4a3e, XW(CELL(k2) + 0x8));
                    X32(CELL(k2), 0);
                } else {
                    X32(0x4a34, 1);
                    X16(0x4a3c, XW(CELL(k2) + 0xe));
                    X16(0x4a3e, XW(CELL(k2) + 0xc));
                    X32(CELL(k2) + 4, 0);
                }
                finish_46c6a9(1);
                CK(L.n == 0);
            }
        }
        /* [+0x4a2c] != 0 with 0x27e2 .. 0x27e5 */
        for (p = 0; p < 4; p++) {
            for (s = 3; s <= 6; s++) {
                int k0 = ks[p][0], k2 = ks[p][1];
                int off = (s <= 4) ? 0 : 4;               /* the dword at + 0x48a0 / + 0x48a4, the words at + 0x48a8 / + 0x48ac */
                setup_46c6a9(all[s], idx, k0, k2);
                set32(fx.self, 0x4a2c, 0x100);
                run_46c6a9();
                X32(CELL(k0) + off, 1);
                X16(CELL(k0) + 8 + off, 0x1111);
                X16(CELL(k0) + 10 + off, 0x2222);
                if (s == 3 || s == 5) {
                    X16(0x49e0, (uint16_t)(int16_t)k2);
                    X32(CELL(k2) + off, 0);
                    X32(0x4a4c, 0);
                    X32(0x4a2c, 1);
                } else {
                    X32(0x4a2c, 0);
                }
                X32(0x4a28, 1);
                X32(0x4a24, 1);
                X32(s <= 4 ? 0x4a30 : 0x4a34, 1);
                X16(0x4a3c, XW(CELL(k2) + 10 + off));
                X16(0x4a3e, XW(CELL(k2) + 8 + off));
                finish_46c6a9(1);
                CK(L.n == (s == 4 ? 1 : 0));
                if (s == 4) {
                    check_call(0, 0x46cc8b, (uintptr_t)fx.self, 0);
                    CK(get32(L.c[0].snap_self, 0x4a2c) == 0 && get32(L.c[0].snap_self, 0x4a28) == 0x77777777u);
                }
            }
        }
        /* the announcements: for 0x27e2 .. 0x27e5 (nine bytes R[+0x63d] against consts[0], word R[+0x65e]) and for 0x27e6 / 0x27e8 (R[+0x60c]
         * against consts[1], word R[+0x62d]) when the dword 0x5bb1ca is non-zero and they differ: 0x4f6334(sign-extended word); when it
         * returns 0, 0x4fb2e3(word). m: -1 equal, 0..8 one byte differs, 9 only the tenth. */
        for (s = 1; s < 7; s++) {
            for (g = 0; g < 2; g++) {
                for (m = -1; m <= 9; m++) {
                    for (res = 0; res < 2; res++) {
                        int six = (s == 1 || s == 2), differs = g && m >= 0 && m <= 8;
                        setup_46c6a9(all[s], idx, 3, 5);
                        set32(fx.self, 0x4a2c, six ? 0u : 0x100u);
                        fx.w.value_5bb1ca = g ? 0x40000u : 0;
                        nine_diff3(six ? 0x60c : 0x63d, m);
                        g_ret_by[0].callee = 0x4f6334;
                        g_ret_by[0].value = res ? 0x100u : 0u;
                        g_phase2 = s * 100 + m;
                        run_46c6a9();
                        {
                            int calls = (s == 4 && 1) + (differs ? (res ? 1 : 2) : 0), base_i = (s == 4) ? 1 : 0;
                            CK(L.n == calls);
                            if (differs) {
                                check_call(base_i, 0x4f6334, 0x5cf1ebu, 1);
                                check_arg(base_i, 0, six ? 0xffff8222u : 0xffff8111u, 0xffffffffu);
                                if (!res) {
                                    check_call(base_i + 1, 0x4fb2e3, 0x5c3a67u, 1);
                                    check_arg(base_i + 1, 0, six ? 0x8222 : 0x8111, 0xffffu);
                                }
                            }
                        }
                        /* (the object itself: the arms are tested above; here the copy target is the check) */
                        memset(xb46, 0x77, sizeof xb46);
                        memcpy(xb46, fx.self + 0x48a0, 0x140);
                        CK(memcmp(buf46, xb46, sizeof buf46) == 0);
                    }
                }
            }
        }
    }
    if (g_failed) printf("FAIL test_m46c6a9_click_27e2_27ea: %s\n", g_msg);
    else printf("PASS test_m46c6a9_click_27e2_27ea\n");
    return g_failed;
}

/* 0x4a44c0 (plain ret): record n = word [+0x1e]; R = OBJ_VA (the byte R[+0x21], the word R[+0x413], the nine bytes and words of the three
 * announcements). The index words are [+0x264] = 1 (row, 0x7c bytes), [+0x278] = 2 (sub-row, 0xc), [+0x276] = 3 (word), so P = 0x7c + 0x18 + 6 =
 * 0x9a; B is the word at 0x591a28 + P (buf47 + P) and A the word at 0x591a64 + P (buf47 + 0x3c + P). Constants 0x550570 / 0x55057c / 0x550588 are
 * consts[0..2]. The expected object is built store by store from the disassembly. */
#define P47 0x9a
#define M47 0x200            /* the matrices start M47 bytes into buf47s: a negative index word reads (and the original would write) below them */
static uint8_t buf47s[M47 + 0x200], xb47s[M47 + 0x200];
#define buf47 (buf47s + M47)
#define xb47 (xb47s + M47)
static const uint8_t NINE47[9] = {'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's'};
static void setup_4a44c0(uint32_t sel, int idx)
{
    base(sel, idx, 0x1e);
    memset(buf47s, 0x5a, sizeof buf47s);
    fx.w.buf_591a28 = buf47;
    fx.w.bytes_550570 = consts[0];
    fx.w.bytes_55057c = consts[1];
    fx.w.bytes_550588 = consts[2];
    memcpy(consts[0], NINE47, 9);
    memcpy(consts[1], NINE47, 9);
    memcpy(consts[2], NINE47, 9);
    fx.w.value_5bb1ca = 0;
    set32(fx.self, 0x26e, 0x100);
    fx.self[0x27f] = 0;
    set32(fx.self, 0x27b, 0);
    set32(fx.self, 0x260, 0);
    set16(fx.self, 0x264, 1);
    set16(fx.self, 0x278, 2);
    set16(fx.self, 0x276, 3);
    set16(fx.self, 0x214, 0x1234);
    set16(fx.self, 0x216, 0x5678);
    set32(fx.self, 0x258, 0x77777777u);
    set32(fx.self, 0x25c, 0x77777777u);
    set32(fx.self, 0x266, 0x77777777u);
    set32(fx.self, 0x272, 0x77777777u);
    fx.self[0x27a] = 0x66;
    set16(fx.self, 0x210, 0x7777);
    set16(fx.self, 0x212, 0x7777);
    fx.obj[0x21] = 3;
    set16(fx.obj, 0x413, 1);
    memcpy(fx.obj + 0x61b, NINE47, 9);
    memcpy(fx.obj + 0x5b9, NINE47, 9);
    memcpy(fx.obj + 0x5ea, NINE47, 9);
    set16(fx.obj, 0x63c, 0x8301);
    set16(fx.obj, 0x5da, 0x8302);
    set16(fx.obj, 0x60b, 0x8303);
}
static void set_b(int16_t v) { set16(buf47, P47, (uint16_t)v); }
static void set_a(int16_t v) { set16(buf47, 0x3c + P47, (uint16_t)v); }
static void run_4a44c0(void)
{
    begin();
    memcpy(xb47s, buf47s, sizeof xb47s);
    m4a44c0_click_274c_274f(fx.self, &fx.w, &fx.host);
}
static void finish_4a44c0(void)
{
    check_mem();
    CK(memcmp(buf47s, xb47s, sizeof buf47s) == 0);
}
static void xA47(int16_t v) { set16(xb47, 0x3c + P47, (uint16_t)v); }
static void xB47(int16_t v) { set16(xb47, P47, (uint16_t)v); }
static void nine_diff4(size_t off, int m)
{
    if (m >= 0 && m <= 8) fx.obj[off + (size_t)m] ^= 0x20;
    if (m == 9) fx.obj[off + 9] ^= 0x40;
}
/* the split of the expected word [+0x214] by the signed byte d: zero gives two zero words; else the quotient (truncated to a word) and
 * n - quotient * d (words) */
static void expect_split(int16_t n, int8_t d)
{
    int16_t q;
    if (n == 0) {
        X16(0x210, 0);
        X16(0x212, 0);
        return;
    }
    q = (int16_t)((int32_t)n / (int32_t)d);
    X16(0x212, (uint16_t)q);
    X16(0x210, (uint16_t)(n - q * d));
}
/* the announcement: calls 0x4f6334(this 0x5cf1eb, sign-extended `word`) and, when it returned 0, 0x4fb2e3(this 0x5c3a67, word) from index `first` */
static void expect_announce(int first, int made, uint16_t word, int second)
{
    if (!made) return;
    check_call(first, 0x4f6334, 0x5cf1ebu, 1);
    check_arg(first, 0, (uint32_t)(int32_t)(int16_t)word, 0xffffffffu);
    if (second) {
        check_call(first + 1, 0x4fb2e3, 0x5c3a67u, 1);
        check_arg(first + 1, 0, word, 0xffffu);
    }
}

static int test_m4a44c0_click_274c_274f(void)
{
    (void)m4a44c0_click_274c_274f;
    static const int idxs[2] = {3, -1};
    static const uint32_t sels[5] = {0x274f, 0x274e, 0x274c, 0x274d, 0x2710};
    static const int16_t avs[8] = {0, 1, 2, 3, 4, -1, 0x7fff, -0x8000};
    static const uint16_t w413[4] = {1, 0, 2, 0x8001};
    static const int8_t ds[9] = {1, 2, 3, 5, 7, -1, -3, 127, -128};
    static const int16_t ns[8] = {1, -1, 100, -32768, 32767, 12345, -7, 4};
    int ii, s, g, m, res, a, w, d, n;
    g_failed = 0;
    g_msg[0] = 0;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        g_phase = ii;
        /* guards: each failing leaves everything (the matrices too) untouched, for every event and both values of [+0x260] */
        for (s = 0; s < 5; s++) {
            for (g = 0; g < 6; g++) {
                setup_4a44c0(sels[s], idx);
                set32(fx.self, 0x260, (s & 1) ? 0x100u : 0);
                if (g == 0) set32(fx.self, 0x26e, 0);
                if (g == 1) fx.self[0x27f] = 1;
                if (g == 2) fx.self[0x27f] = 0x80;
                if (g == 3) set32(fx.self, 0x27b, 0x01000000u);
                if (g == 4) set32(fx.tab, (size_t)(idx + 1) * REC + 0x4d, 0);
                if (g == 5) set32(fx.tab, (size_t)(idx + 1) * REC + 0x4d, 2);
                fx.w.value_5bb1ca = 1;
                nine_diff4(0x61b, 0);
                run_4a44c0();
                finish_4a44c0();
                CK(L.n == 0);
            }
        }
        /* [+0x27f] is a byte: non-zero bytes after it do not fail the guard; 0x274f with [+0x260] == 0: [+0x27a] = 1 and the state 2 */
        setup_4a44c0(0x274f, idx);
        fx.self[0x280] = 0xff;
        fx.self[0x281] = 0xff;
        run_4a44c0();
        X8(0x27a, 1);
        rec_state(idx, 2);
        finish_4a44c0();
        CK(L.n == 0);
        /* [+0x260] != 0 with 0x274f / 0x274e / 0x274c: nothing; [+0x260] == 0 with 0x274d and an unrelated event: nothing */
        for (s = 0; s < 5; s++) {
            static const int sl[5] = {0, 1, 2, 3, 4};
            setup_4a44c0(sels[sl[s]], idx);
            set32(fx.self, 0x260, s == 3 || s == 4 ? 0u : 0x80000000u);
            fx.w.value_5bb1ca = 1;
            nine_diff4(0x61b, 1);
            nine_diff4(0x5b9, 1);
            nine_diff4(0x5ea, 1);
            run_4a44c0();
            finish_4a44c0();
            CK(L.n == 0);
        }
        /* 0x274e, [+0x260] == 0: the switch on the word A (unsigned: 0 .. 3 through the table, else nothing) */
        for (a = 0; a < 8; a++) {
            for (w = 0; w < 4; w++) {
                int16_t av = avs[a], want = av;
                int one = (w413[w] == 1);
                setup_4a44c0(0x274e, idx);
                set_a(av);
                set_b(-10);
                set16(fx.obj, 0x413, w413[w]);
                run_4a44c0();
                if (av == 0) want = one ? 1 : 2;
                if (av == 1) want = 2;
                if (av == 2) want = one ? 3 : 0;
                if (av == 3) want = one ? 0 : 3;
                xA47(want);
                X32(0x266, 1);
                X16(0x26a, 3);
                X16(0x26c, 2);
                finish_4a44c0();
                CK(L.n == 1);
                check_call(0, 0x4a4d55, (uintptr_t)fx.self, 0);
                CK(get32(L.c[0].snap_self, 0x266) == 1 && get16x(L.c[0].snap_self, 0x26a) == 3 && get16x(L.c[0].snap_self, 0x26c) == 2);
            }
        }
        /* 0x274e: the announcement (r[+0x61b] against consts[0], word r[+0x63c]) before the stores and the call of 0x4a4d55 */
        for (m = -2; m <= 9; m++) {
            for (res = 0; res < 2; res++) {
                int differs = m >= 0 && m <= 8;
                setup_4a44c0(0x274e, idx);
                set_a(1);
                fx.w.value_5bb1ca = m == -2 ? 0u : 0x2000u;
                nine_diff4(0x61b, m);
                g_ret_by[0].callee = 0x4f6334;
                g_ret_by[0].value = res ? 0x100u : 0u;
                g_phase2 = m;
                run_4a44c0();
                xA47(2);
                X32(0x266, 1);
                X16(0x26a, 3);
                X16(0x26c, 2);
                finish_4a44c0();
                CK(L.n == (differs ? (res ? 1 : 2) : 0) + 1);
                expect_announce(0, differs, 0x8301, !res);
                if (differs) CK(get32(L.c[0].snap_self, 0x266) == 0x77777777u);
                check_call(L.n - 1, 0x4a4d55, (uintptr_t)fx.self, 0);
            }
        }
        /* 0x274c, [+0x260] == 0: [+0x272] = 0, [+0x260] = 1, [+0x258] = 1, [+0x214] = B, the split by the byte r[+0x21], [+0x216] = A, B = A = -10 */
        for (d = 0; d < 9; d++) {
            for (n = 0; n < 8; n++) {
                setup_4a44c0(0x274c, idx);
                fx.obj[0x21] = (uint8_t)ds[d];
                set_b(ns[n]);
                set_a(0x1357);
                run_4a44c0();
                X32(0x272, 0);
                X32(0x260, 1);
                X32(0x258, 1);
                X16(0x214, (uint16_t)ns[n]);
                expect_split(ns[n], ds[d]);
                X16(0x216, 0x1357);
                xB47(-10);
                xA47(-10);
                finish_4a44c0();
                CK(L.n == 0);
            }
        }
        /* a zero word B: [+0x210] = [+0x212] = 0 (the byte r[+0x21] may be anything, also zero: no division) */
        for (d = 0; d < 2; d++) {
            setup_4a44c0(0x274c, idx);
            fx.obj[0x21] = (uint8_t)(d ? 0 : 0x80);
            set_b(0);
            set_a(0x1357);
            run_4a44c0();
            X32(0x272, 0);
            X32(0x260, 1);
            X32(0x258, 1);
            X16(0x214, 0);
            X16(0x210, 0);
            X16(0x212, 0);
            X16(0x216, 0x1357);
            xB47(-10);
            xA47(-10);
            finish_4a44c0();
        }
        /* negative index words (0xffff, 0xfffe, ...): each of the row [+0x264], sub-row [+0x278] and word [+0x276] index words in turn is negative,
         * the other two stay 1, 2, 3; the sign-extended cell lies BELOW the matrices (M47 readable bytes under them). A zero extension of the row
         * (0xffff * 0x7c), the sub-row (0xffff * 0xc) or the word index would pick a cell far away and so a wrong value. */
        for (a = 0; a < 3; a++) {
            for (w = 0; w < 2; w++) {
                static const int16_t neg[3][2] = {{-1, -2}, {-1, -2}, {-1, -3}};
                int16_t iw[3] = {1, 2, 3};
                int ev;
                ptrdiff_t P;
                iw[a] = neg[a][w];
                P = (ptrdiff_t)iw[0] * 0x7c + (ptrdiff_t)iw[1] * 0xc + (ptrdiff_t)iw[2] * 2;
                for (ev = 0; ev < 3; ev++) {
                    static const uint32_t evs[3] = {0x274c, 0x274d, 0x274e};
                    setup_4a44c0(evs[ev], idx);
                    set16(fx.self, 0x264, (uint16_t)iw[0]);
                    set16(fx.self, 0x278, (uint16_t)iw[1]);
                    set16(fx.self, 0x276, (uint16_t)iw[2]);
                    set32(fx.self, 0x260, ev == 1 ? 0x100u : 0u);
                    set16(buf47 + P, 0, 77);
                    set16(buf47 + P + 0x3c, 0, ev == 0 ? 0x1357 : ev == 1 ? 0x2468 : 0);
                    g_phase2 = a * 100 + w * 10 + ev;
                    run_4a44c0();
                    if (ev == 0) {
                        X32(0x272, 0);
                        X32(0x260, 1);
                        X32(0x258, 1);
                        X16(0x214, 77);
                        expect_split(77, 3);
                        X16(0x216, 0x1357);
                        set16(xb47 + P, 0, 0xfff6);
                        set16(xb47 + P + 0x3c, 0, 0xfff6);
                    } else if (ev == 1) {
                        set16(xb47 + P, 0, 0x1234);
                        set16(xb47 + P + 0x3c, 0, 0x5678);
                        X32(0x25c, 1);
                        X32(0x266, 1);
                        X16(0x26a, (uint16_t)iw[2]);
                        X16(0x26c, (uint16_t)iw[1]);
                        X32(0x258, 1);
                        X16(0x214, 77);
                        expect_split(77, 3);
                        X16(0x216, 0x2468);
                    } else {
                        set16(xb47 + P + 0x3c, 0, 1);           /* A = 0 and the word r[+0x413] is 1: A = 1 */
                        X32(0x266, 1);
                        X16(0x26a, (uint16_t)iw[2]);
                        X16(0x26c, (uint16_t)iw[1]);
                    }
                    finish_4a44c0();
                    CK(L.n == (ev == 2 ? 1 : 0));
                    if (ev == 2) check_call(0, 0x4a4d55, (uintptr_t)fx.self, 0);
                }
            }
        }
        /* the divide error of the original (non-zero B, byte 0): rejected after [+0x272], [+0x260], [+0x258] and [+0x214]; nothing else */
        setup_4a44c0(0x274c, idx);
        fx.obj[0x21] = 0;
        set_b(77);
        set_a(0x1357);
        fx.w.value_5bb1ca = 1;
        nine_diff4(0x5b9, 0);
        run_4a44c0();
        X32(0x272, 0);
        X32(0x260, 1);
        X32(0x258, 1);
        X16(0x214, 77);
        finish_4a44c0();
        CK(L.n == 0);
        /* 0x274c: the announcement (r[+0x5b9] against consts[1], word r[+0x5da]) after the matrix stores */
        for (m = -2; m <= 9; m++) {
            for (res = 0; res < 2; res++) {
                int differs = m >= 0 && m <= 8;
                setup_4a44c0(0x274c, idx);
                set_b(5);
                set_a(9);
                fx.w.value_5bb1ca = m == -2 ? 0u : 0x2000u;
                nine_diff4(0x5b9, m);
                g_ret_by[0].callee = 0x4f6334;
                g_ret_by[0].value = res ? 0x100u : 0u;
                run_4a44c0();
                X32(0x272, 0);
                X32(0x260, 1);
                X32(0x258, 1);
                X16(0x214, 5);
                expect_split(5, 3);
                X16(0x216, 9);
                xB47(-10);
                xA47(-10);
                finish_4a44c0();
                CK(L.n == (differs ? (res ? 1 : 2) : 0));
                expect_announce(0, differs, 0x8302, !res);
                if (differs) {
                    CK(get16x(L.c[0].snap_self, 0x216) == 9 && get32(L.c[0].snap_self, 0x258) == 1);
                    CK(get16x(buf47, P47) == 0xfff6 && get16x(buf47, 0x3c + P47) == 0xfff6);
                }
            }
        }
        /* 0x274d, [+0x260] != 0: B and A are saved and replaced by [+0x214] and [+0x216]; saved B == -10 (only its low word counts): [+0x260] = 0 and
         * 0x4a4d55; else [+0x258] = 1, [+0x214] = the saved B, the split, [+0x216] = the saved A */
        for (a = 0; a < 6; a++) {
            for (d = 0; d < 9; d += 2) {
                static const int16_t sb[6] = {-10, 7, -1, 0, -0x8000, 0x00f6};
                setup_4a44c0(0x274d, idx);
                set32(fx.self, 0x260, 0x100);
                set_b(sb[a]);
                set_a(0x2468);
                fx.obj[0x21] = (uint8_t)ds[d];
                run_4a44c0();
                xB47(0x1234);
                xA47(0x5678);
                X32(0x25c, 1);
                X32(0x266, 1);
                X16(0x26a, 3);
                X16(0x26c, 2);
                if (sb[a] == -10) {
                    X32(0x260, 0);
                } else {
                    X32(0x258, 1);
                    X16(0x214, (uint16_t)sb[a]);
                    expect_split(sb[a], ds[d]);
                    X16(0x216, 0x2468);
                }
                finish_4a44c0();
                CK(L.n == (sb[a] == -10 ? 1 : 0));
                if (sb[a] == -10) {
                    check_call(0, 0x4a4d55, (uintptr_t)fx.self, 0);
                    CK(get32(L.c[0].snap_self, 0x260) == 0);
                }
            }
        }
        /* 0x274d: the divide error (saved B non-zero and not -10, byte 0): rejected after [+0x258] and [+0x214] */
        setup_4a44c0(0x274d, idx);
        set32(fx.self, 0x260, 0x100);
        set_b(9);
        set_a(0x2468);
        fx.obj[0x21] = 0;
        run_4a44c0();
        xB47(0x1234);
        xA47(0x5678);
        X32(0x25c, 1);
        X32(0x266, 1);
        X16(0x26a, 3);
        X16(0x26c, 2);
        X32(0x258, 1);
        X16(0x214, 9);
        finish_4a44c0();
        CK(L.n == 0);
        /* 0x274d: the announcement (r[+0x5ea] against consts[2], word r[+0x60b]) after the stores and before the -10 test */
        for (m = -2; m <= 9; m++) {
            for (res = 0; res < 2; res++) {
                for (a = 0; a < 2; a++) {
                    int differs = m >= 0 && m <= 8, ten = a == 0;
                    setup_4a44c0(0x274d, idx);
                    set32(fx.self, 0x260, 0x100);
                    set_b(ten ? -10 : 6);
                    set_a(0x2468);
                    fx.w.value_5bb1ca = m == -2 ? 0u : 0x2000u;
                    nine_diff4(0x5ea, m);
                    g_ret_by[0].callee = 0x4f6334;
                    g_ret_by[0].value = res ? 0x100u : 0u;
                    run_4a44c0();
                    xB47(0x1234);
                    xA47(0x5678);
                    X32(0x25c, 1);
                    X32(0x266, 1);
                    X16(0x26a, 3);
                    X16(0x26c, 2);
                    if (ten) {
                        X32(0x260, 0);
                    } else {
                        X32(0x258, 1);
                        X16(0x214, 6);
                        expect_split(6, 3);
                        X16(0x216, 0x2468);
                    }
                    finish_4a44c0();
                    CK(L.n == (differs ? (res ? 1 : 2) : 0) + (ten ? 1 : 0));
                    expect_announce(0, differs, 0x8303, !res);
                    if (differs) CK(get32(L.c[0].snap_self, 0x25c) == 1 && get32(L.c[0].snap_self, 0x260) == 0x100);
                    if (ten) check_call(L.n - 1, 0x4a4d55, (uintptr_t)fx.self, 0);
                }
            }
        }
    }
    if (g_failed) printf("FAIL test_m4a44c0_click_274c_274f: %s\n", g_msg);
    else printf("PASS test_m4a44c0_click_274c_274f\n");
    return g_failed;
}

/* FL25C-TESTS-END */

int main(void)
{
    int failures = 0;
    failures += test_m4a8818_click_2798_279a();
    failures += test_m4aa3d2_click_276f_2771();
    failures += test_m46c6a9_click_27e2_27ea();
    failures += test_m4a44c0_click_274c_274f();
    /* FL25C-MAIN-END */
    return failures;
}
