/* FL-24 (batch a) direct tests of the session input handlers of GAME.EXE in src/original_methods_fl24a.c. Prints "PASS <name>" /
 * "FAIL <name>: <msg>"; the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values were derived by
 * hand from the disassembly of GAME.EXE, not from running the native code; tests/test_fl24a_differential.py additionally runs the
 * original bytes on generated fixtures.
 *
 * Every function is checked three ways: (1) the guard matrix, each guard of the chain failing in turn (several fail values each, widths
 * probed) with every selector of the function, which must leave the object, the record table and the call log untouched; (2) each arm with
 * the whole object and the record table compared with a hand-edited copy, and the ordered host calls (GetTickCount included) with their
 * arguments and the state of the object at the call; (3) the same arms with a negative record index (the index word is signed). */
#include "../src/original_methods_fl24a.h"

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
#define OBJ_VA 0x20010000u        /* the object of the target record */
#define DECOY_VA 0x20020000u      /* the object of every other record */
#define A154_VA 0x20030000u
#define A12_VA 0x20040000u
#define TBL_VA 0x20050000u
#define OBJ_SZ 0xa000
#define SNAP 0x300

static void set32(uint8_t *o, size_t off, uint32_t v) { memcpy(o + off, &v, 4); }
static void set16(uint8_t *o, size_t off, uint16_t v) { memcpy(o + off, &v, 2); }
static uint32_t get32(const uint8_t *o, size_t off)
{
    uint32_t v;
    memcpy(&v, o + off, 4);
    return v;
}

static struct {
    uint8_t self[SELF_SZ], tab[TAB_SZ], obj[OBJ_SZ], decoy[0x1000], a154[0x100], a12[0x100], tbl[0x400], flags[0x200];
    Fl24aWorld w;
    Fl18Host host;
} fx;
static uint8_t exp_self[SELF_SZ], exp_tab[TAB_SZ], exp_flags[0x200];

static const uint8_t T[2][9] = {{'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'}, {'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r'}};

static uint32_t g_tick;
static uint32_t g_ret_4f6334, g_ret_4709bb[16], g_ret_4709de[16];
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[6];
        uint8_t snap_self[SNAP], snap_tab[TAB_SZ];
    } c[32];
} L;
static int n_4709bb, n_4709de;

static void log_call(uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int i;
    L.c[L.n].callee = callee;
    L.c[L.n].this_ptr = this_ptr;
    L.c[L.n].nargs = nargs;
    for (i = 0; i < nargs && i < 6; i++) L.c[L.n].a[i] = args[i];
    memcpy(L.c[L.n].snap_self, fx.self, SNAP);
    memcpy(L.c[L.n].snap_tab, fx.tab, TAB_SZ);
    L.n++;
}

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    (void)ctx;
    log_call(callee, this_ptr, args, nargs);
    if (callee == 0x4f6334) return g_ret_4f6334;
    if (callee == 0x4709bb) return g_ret_4709bb[n_4709bb++ & 15];
    if (callee == 0x4709de) return g_ret_4709de[n_4709de++ & 15];
    return 0;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (a >= OBJ_VA && a < OBJ_VA + OBJ_SZ) return fx.obj + (a - OBJ_VA);
    if (a >= DECOY_VA && a < DECOY_VA + 0x1000) return fx.decoy + (a - DECOY_VA);
    if (a >= A154_VA && a < A154_VA + 0x100) return fx.a154 + (a - A154_VA);
    if (a >= A12_VA && a < A12_VA + 0x100) return fx.a12 + (a - A12_VA);
    if (a >= TBL_VA && a < TBL_VA + 0x400) return fx.tbl + (a - TBL_VA);
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
    memset(fx.a154, 0x33, sizeof fx.a154);
    memset(fx.a12, 0x44, sizeof fx.a12);
    memset(fx.tbl, 0x55, sizeof fx.tbl);
    memset(fx.flags, 0x66, sizeof fx.flags);
    memset(fx.tab, 0xCC, sizeof fx.tab);
    for (i = -1; i <= 4; i++) {
        set32(fx.tab, (size_t)(i + 1) * REC, i == idx ? OBJ_VA : DECOY_VA);
        set32(fx.tab, (size_t)(i + 1) * REC + 0x4d, i == idx ? 1u : 0u);
    }
    memset(&fx.w, 0, sizeof fx.w);
    fx.w.records_5bb5e5 = fx.tab + REC;
    fx.w.value_5c39e5 = sel;
    fx.w.value_5bb1ca = 0x100;
    fx.w.bytes_549824 = T[0];
    fx.w.bytes_54c140 = T[1];
    fx.w.flags_585801 = fx.flags + 0x80;
    memset(&fx.host, 0, sizeof fx.host);
    fx.host.call = host_call;
    fx.host.resolve = host_resolve;
    fx.host.tick = host_tick;
    set16(fx.self, 0x1e, (uint16_t)idx);
    g_ret_4f6334 = 0;
    g_tick = 1000;
    n_4709bb = n_4709de = 0;
    memset(g_ret_4709bb, 0, sizeof g_ret_4709bb);
    memset(g_ret_4709de, 0, sizeof g_ret_4709de);
    L.n = 0;
}

static void expect_begin(void)
{
    memcpy(exp_self, fx.self, SELF_SZ);
    memcpy(exp_tab, fx.tab, TAB_SZ);
    memcpy(exp_flags, fx.flags, sizeof fx.flags);
    L.n = 0;
}

static void expect_end(void)
{
    CK(memcmp(fx.self, exp_self, SELF_SZ) == 0);
    CK(memcmp(fx.tab, exp_tab, TAB_SZ) == 0);
    CK(memcmp(fx.flags, exp_flags, sizeof fx.flags) == 0);
}

/* call i of the log: the callee, ecx, the argument count and the arguments; bit k of wmask marks a word argument (low 16 bits only) */
static void ck_call(int i, uint32_t callee, uintptr_t this_ptr, int nargs, unsigned wmask, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3,
                    uintptr_t a4, uintptr_t a5)
{
    const uintptr_t want[6] = {a0, a1, a2, a3, a4, a5};
    int k;
    CK(i < L.n);
    if (i >= L.n) return;
    CK(L.c[i].callee == callee);
    CK(L.c[i].this_ptr == this_ptr);
    CK(L.c[i].nargs == nargs);
    for (k = 0; k < nargs; k++) {
        if (wmask & (1u << k)) CK((L.c[i].a[k] & 0xffff) == (want[k] & 0xffff));
        else CK(L.c[i].a[k] == want[k]);
    }
}

static void ck_tick(int i)
{
    CK(i < L.n);
    if (i < L.n) CK(L.c[i].callee == TICK_ID);
}

/* ---- 0x4d3bef ----------------------------------------------------------------------------------------------------------------- */

static void test_m4d3bef(void)
{
    static const uint8_t values[] = {0, 1, 0x80, 0xff, 0x7f};
    size_t i;
    for (i = 0; i < sizeof values; i++) {
        setup(0, 0);
        set32(fx.self, 0x462, 0xdeadbeef);
        fx.w.byte_61c6ae = values[i];
        expect_begin();
        set32(exp_self, 0x462, 0);
        if (values[i] != 0) set32(exp_self, 0x1c, 1);
        m4d3bef_reset_flags(fx.self, &fx.w);
        expect_end();
        CK(L.n == 0);
    }
    /* [+0x1c] keeps its old value when the byte is zero (whatever it was) */
    setup(0, 0);
    set32(fx.self, 0x1c, 0x12345678);
    fx.w.byte_61c6ae = 0;
    m4d3bef_reset_flags(fx.self, &fx.w);
    CK(get32(fx.self, 0x1c) == 0x12345678 && get32(fx.self, 0x462) == 0);
}

/* ---- 0x44edfb ----------------------------------------------------------------------------------------------------------------- */

static const uint32_t z32_fail[] = {1, 0x100, 0x10000, 0x01000000, 0x80000000};
static const uint32_t bad_state[] = {0, 2, 3, 0xffffffffu, 0x101, 0x10001};

/* the passing fixture of 0x44edfb: every guard passes (the dword [+0x6b] is non-zero only in its high byte) */
static void setup_44edfb(int idx, uint32_t sel, int w30)
{
    setup(idx, sel);
    set32(fx.self, 0x6b, 0x01000000);
    set32(fx.self, 0x2c, 0);
    set16(fx.self, 0x30, (uint16_t)w30);
    set16(fx.self, 0x26, 0);
}

static void run_44edfb(void)
{
    L.n = 0;
    m44edfb_click_2785_2787(fx.self, &fx.w, &fx.host);
}

static void test_m44edfb(void)
{
    static const int idxs[] = {2, -1};
    static const uint32_t sels[] = {0x2787, 0x2786, 0x2785, 0x2784};
    size_t ii, si, k;
    int d;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        /* (1) the guard matrix */
        for (si = 0; si < 4; si++) {
            setup_44edfb(idx, sels[si], 1);
            set32(fx.self, 0x6b, 0);
            expect_begin();
            run_44edfb();
            expect_end();
            CK(L.n == 0);
            for (k = 0; k < 5; k++) {
                setup_44edfb(idx, sels[si], 1);
                set32(fx.self, 0x2c, z32_fail[k]);
                expect_begin();
                run_44edfb();
                expect_end();
                CK(L.n == 0);
            }
            for (k = 0; k < 6; k++) {
                setup_44edfb(idx, sels[si], 1);
                set32(fx.tab, (size_t)(idx + 1) * REC + 0x4d, bad_state[k]);
                expect_begin();
                run_44edfb();
                expect_end();
                CK(L.n == 0);
            }
        }
        /* (2) event 0x2787: [+0x67] = 1, the record goes to state 2, nothing else even with the flag set and different bytes */
        setup_44edfb(idx, 0x2787, 1);
        expect_begin();
        set32(exp_self, 0x67, 1);
        set32(exp_tab, (size_t)(idx + 1) * REC + 0x4d, 2);
        run_44edfb();
        expect_end();
        CK(L.n == 0);
        /* event 0x2786, word [+0x30] = 0: word [+0x26] -= 1 (0 wraps to 0xffff), 49 bytes from the object + 0x1be to self + 0x32 */
        setup_44edfb(idx, 0x2786, 0);
        fx.w.value_5bb1ca = 0;
        expect_begin();
        set16(exp_self, 0x26, 0xffff);
        memcpy(exp_self + 0x32, fx.obj + 0x1be, 0x31);
        run_44edfb();
        expect_end();
        CK(L.n == 0);
        /* word = 1: += 1 (0xffff wraps to 0), same copy; the byte just after the 49 bytes is not copied */
        setup_44edfb(idx, 0x2786, 1);
        fx.w.value_5bb1ca = 0;
        set16(fx.self, 0x26, 0xffff);
        expect_begin();
        set16(exp_self, 0x26, 0);
        memcpy(exp_self + 0x32, fx.obj + 0x1be, 0x31);
        run_44edfb();
        expect_end();
        CK(fx.self[0x32 + 0x31] == 0xA5);
        /* word = 2: dword [+0x28] = 1, copy from + 0x1ef; [+0x26] untouched */
        setup_44edfb(idx, 0x2786, 2);
        fx.w.value_5bb1ca = 0;
        set16(fx.self, 0x26, 0x1234);
        expect_begin();
        set32(exp_self, 0x28, 1);
        memcpy(exp_self + 0x32, fx.obj + 0x1ef, 0x31);
        run_44edfb();
        expect_end();
        /* other values of the word do nothing: 3, 0x100 (low byte 0), -1, 0x8000 */
        {
            static const int others[] = {3, 0x100, -1, 0x8000};
            for (k = 0; k < 4; k++) {
                setup_44edfb(idx, 0x2786, others[k]);
                fx.w.value_5bb1ca = 0;
                expect_begin();
                run_44edfb();
                expect_end();
                CK(L.n == 0);
            }
        }
        /* event 0x2785: word [+0x24] = word [+0x30] (the high half is not copied), copy from + 0x18d */
        setup_44edfb(idx, 0x2785, 0x7234);
        fx.w.value_5bb1ca = 0;
        expect_begin();
        set16(exp_self, 0x24, 0x7234);
        memcpy(exp_self + 0x32, fx.obj + 0x18d, 0x31);
        run_44edfb();
        expect_end();
        CK(L.n == 0);
        /* (3) the announcement: for the event 0x2785 the nine bytes at obj + 0x18d are compared with the constant at 0x549824 */
        for (d = -1; d <= 9; d++) {
            int ret;
            for (ret = 0; ret < 2; ret++) {
                setup_44edfb(idx, 0x2785, 5);
                memcpy(fx.obj + 0x18d, T[0], 9);
                if (d >= 0) fx.obj[0x18d + d] ^= 0x40;
                fx.obj[0x18d + 0x21] = 0x34;      /* the word [+0x53] of self after the copy: 0x9234 (negative) */
                fx.obj[0x18d + 0x22] = 0x92;
                g_ret_4f6334 = ret ? 0x10000u : 0;
                g_tick = 0xffffff40u;
                expect_begin();
                set16(exp_self, 0x24, 5);
                memcpy(exp_self + 0x32, fx.obj + 0x18d, 0x31);
                run_44edfb();
                if (d == -1 || d == 9) {
                    /* equal, or different only at the tenth byte (not compared): no call */
                    expect_end();
                    CK(L.n == 0);
                } else if (ret) {
                    expect_end();
                    CK(L.n == 1);
                    ck_call(0, 0x4f6334, 0x5cf1eb, 1, 0, 0xffff9234u, 0, 0, 0, 0, 0);
                    CK(memcmp(L.c[0].snap_self, exp_self, SNAP) == 0);   /* the copy is done before the call */
                } else {
                    set32(exp_self, 0x63, 0xffffff40u + 0xfa);
                    set32(exp_self, 0x2c, 1);
                    expect_end();
                    CK(L.n == 3);
                    ck_call(0, 0x4f6334, 0x5cf1eb, 1, 0, 0xffff9234u, 0, 0, 0, 0, 0);
                    ck_call(1, 0x4fb2e3, 0x5c3a67, 1, 1, 0x9234, 0, 0, 0, 0, 0);
                    ck_tick(2);
                    CK(get32(L.c[1].snap_self, 0x63) == 0xA5A5A5A5u && get32(L.c[2].snap_self, 0x2c) == 0);   /* stores come after */
                }
            }
        }
        /* the flag zero: no announcement; the flag only its high byte: announcement */
        setup_44edfb(idx, 0x2785, 5);
        fx.w.value_5bb1ca = 0;
        set16(fx.self, 0x53, 0);
        expect_begin();
        set16(exp_self, 0x24, 5);
        memcpy(exp_self + 0x32, fx.obj + 0x18d, 0x31);
        run_44edfb();
        expect_end();
        CK(L.n == 0);
        setup_44edfb(idx, 0x2785, 5);
        fx.w.value_5bb1ca = 0x01000000;
        run_44edfb();
        CK(L.n == 3);
        /* an unrelated event (no copy): the nine bytes already at self + 0x32 are compared; all-equal: nothing */
        setup_44edfb(idx, 0x2000, 5);
        memcpy(fx.self + 0x32, T[0], 9);
        expect_begin();
        run_44edfb();
        expect_end();
        CK(L.n == 0);
        /* ... different at byte 8: the announcement with the word [+0x53] already there; 0x4f6334 non-zero ends it */
        setup_44edfb(idx, 0x2000, 5);
        memcpy(fx.self + 0x32, T[0], 9);
        fx.self[0x32 + 8] ^= 1;
        set16(fx.self, 0x53, 0x8001);
        g_ret_4f6334 = 7;
        expect_begin();
        run_44edfb();
        expect_end();
        CK(L.n == 1);
        ck_call(0, 0x4f6334, 0x5cf1eb, 1, 0, 0xffff8001u, 0, 0, 0, 0, 0);
        /* the event 0x2786 with an unmatched word also reaches the announcement */
        setup_44edfb(idx, 0x2786, 9);
        memset(fx.self + 0x32, 0x77, 9);
        run_44edfb();
        CK(L.n == 3);
    }
}

/* ---- 0x4cb3ab ----------------------------------------------------------------------------------------------------------------- */

#define TBL_BASE 0x100   /* [+0x16] = TBL_VA + TBL_BASE */

static void setup_4cb3ab(int arm_a, int w, int qidx, int qval, int g63)
{
    setup(0, 0);
    set32(fx.self, 0xe, 0x01000000);
    set32(fx.self, 0x12, A12_VA);
    set32(fx.self, 0x16, TBL_VA + TBL_BASE);
    set32(fx.self, 0x15c, 0x100);
    set32(fx.self, 0x154, arm_a ? A154_VA : 0);
    set32(fx.self, 0x14e, 0xffffffffu);
    set32(fx.self, 0x1a, 0x13572468);
    set16(fx.a154, 0x14, (uint16_t)w);
    set16(fx.a12, 5, (uint16_t)w);
    set16(fx.a12, 0, 0x8765);
    set16(fx.tbl, TBL_BASE + 0x23 + (size_t)w * 4, (uint16_t)qidx);
    set16(fx.tbl, TBL_BASE + 0x23 + (size_t)w * 4 + 2, (uint16_t)qval);
    fx.w.word_63a4cd = (int16_t)g63;
}

static void run_4cb3ab(void)
{
    L.n = 0;
    m4cb3ab_store_flag(fx.self, &fx.w, &fx.host);
}

static void test_m4cb3ab(void)
{
    static const size_t guards[] = {0xe, 0x12, 0x16, 0x15c};
    size_t k;
    int arm, g;
    for (k = 0; k < 4; k++) {
        for (arm = 0; arm < 2; arm++) {
            setup_4cb3ab(arm, 5, 7, -3, 1);
            set32(fx.self, guards[k], 0);
            expect_begin();
            run_4cb3ab();
            expect_end();
            CK(L.n == 0);
        }
    }
    for (arm = 1; arm >= 0; arm--) {
        static const int gs[] = {0, 1, -1, 0x100, -0x8000, 0x7fff};
        uint32_t fmt = arm ? 0x558b50u : 0x558bbcu;
        uint32_t q = TBL_VA + TBL_BASE + 0x23 + 5 * 4;
        for (g = 0; g < 6; g++) {
            setup_4cb3ab(arm, 5, 7, -3, gs[g]);
            expect_begin();
            set32(exp_self, 0x158, q);
            set32(exp_flags, 0x80 + 7 * 4, 0xfffffffdu);
            run_4cb3ab();
            expect_end();
            if (gs[g] == 0) {
                CK(L.n == 0);
            } else {
                CK(L.n == 2);
                ck_call(0, 0x50ca3e, 0, 6, 0, 0x63888b, fmt, 7, 0xfffffffdu, 0xffff8765u, 0x13572468);
                ck_call(1, 0x44a2b7, 0, 1, 0, 0x63888b, 0, 0, 0, 0, 0);
                CK(get32(L.c[0].snap_self, 0x158) == q);
                CK(memcmp(L.c[0].snap_self, fx.self, SNAP) == 0);
            }
        }
        /* a negative flag index (-2) and a negative entry (-2): q = base - 8 + 0x23 */
        setup_4cb3ab(arm, -2, -2, 0x7fff, 0);
        expect_begin();
        set32(exp_self, 0x158, TBL_VA + TBL_BASE + 0x23 - 8);
        set32(exp_flags, 0x80 - 8, 0x7fff);
        run_4cb3ab();
        expect_end();
        /* the entry word is -1: nothing is stored (not even [+0x158]) */
        setup_4cb3ab(arm, -1, 7, -3, 1);
        expect_begin();
        run_4cb3ab();
        expect_end();
        CK(L.n == 0);
        /* the flag index word is -1: only [+0x158] is stored */
        setup_4cb3ab(arm, 5, -1, 9, 1);
        expect_begin();
        set32(exp_self, 0x158, q);
        run_4cb3ab();
        expect_end();
        CK(L.n == 0);
    }
    /* [+0x154] clear and [+0x14e] clear: nothing; [+0x154] set takes the first arm whatever [+0x14e] is (checked above with 0xffffffff) */
    setup_4cb3ab(0, 5, 7, -3, 1);
    set32(fx.self, 0x14e, 0);
    expect_begin();
    run_4cb3ab();
    expect_end();
    CK(L.n == 0);
    setup_4cb3ab(0, 5, 7, -3, 1);
    set32(fx.self, 0x14e, 0x100);
    run_4cb3ab();
    CK(L.n == 2);
    setup_4cb3ab(1, 5, 7, -3, 1);
    set32(fx.self, 0x14e, 0);
    run_4cb3ab();
    CK(L.n == 2);   /* the first arm does not look at [+0x14e] */
}

/* ---- 0x44eab1 ----------------------------------------------------------------------------------------------------------------- */

static void setup_44eab1(int idx, int count)
{
    setup(idx, 0);
    set32(fx.self, 0x6b, 0x01000000);
    memset(fx.obj, 0x80, 0x300);          /* every edge is 0x80808080 (negative) so no rectangle holds the point unless a test sets it */
    memset(fx.obj + 0x300, 0xEE, 0x100);
    set16(fx.obj, 0x25, (uint16_t)count);
}

/* the rectangle whose edges are at offsets (ylo, yhi, xlo, xhi) holds the point exactly on its four edges */
static void rect_at(size_t ylo, size_t yhi, size_t xlo, size_t xhi, int x, int y)
{
    set32(fx.obj, ylo, (uint32_t)y);
    set32(fx.obj, yhi, (uint32_t)y);
    set32(fx.obj, xlo, (uint32_t)x);
    set32(fx.obj, xhi, (uint32_t)x);
}

static int32_t run_44eab1(int x, int y)
{
    L.n = 0;
    return m44eab1_hit_test(fx.self, (int16_t)x, (int16_t)y, &fx.w, &fx.host);
}

static void test_m44eab1(void)
{
    static const int idxs[] = {2, -1};
    static const int pts[][2] = {{5, 7}, {-1, -1}, {-32768, 32767}, {32767, -32768}, {0, 0}, {255, -2}};
    static const size_t fixed[4][4] = {{0x61, 0x69, 0x5d, 0x65}, {0x71, 0x79, 0x6d, 0x75}, {0x31, 0x39, 0x2d, 0x35}, {0x25d, 0x265, 0x259, 0x261}};
    static const uint32_t fsel[4] = {0x2786, 0x2786, 0x2786, 0x2787};
    static const uint32_t farg[4] = {0, 1, 2, 0};
    size_t ii, pi;
    int f, e, i;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        for (pi = 0; pi < 6; pi++) {
            int x = pts[pi][0], y = pts[pi][1];
            /* the gate: dword [+0x6b] clear returns 0 without a call, even with a rectangle that holds the point */
            setup_44eab1(idx, 1);
            rect_at(0xf1, 0xf9, 0xed, 0xf5, x, y);
            set32(fx.self, 0x6b, 0);
            expect_begin();
            CK(run_44eab1(x, y) == 0);
            expect_end();
            CK(L.n == 0);
            /* the loop: rectangle j of count 3 holds the point exactly on its edges; the others do not */
            for (i = 0; i < 3; i++) {
                setup_44eab1(idx, 3);
                rect_at(0xf1 + 16 * i, 0xf9 + 16 * i, 0xed + 16 * i, 0xf5 + 16 * i, x, y);
                rect_at(0x61, 0x69, 0x5d, 0x65, x, y);       /* the fixed rectangle A would also hold it, but the loop comes first */
                expect_begin();
                CK(run_44eab1(x, y) == 1);
                expect_end();
                CK(L.n == 1);
                ck_call(0, 0x44ecaf, (uintptr_t)fx.self, 2, 2, 0x2785, (uintptr_t)i, 0, 0, 0, 0);
            }
            /* the first of two holding rectangles wins */
            setup_44eab1(idx, 3);
            rect_at(0xf1 + 16, 0xf9 + 16, 0xed + 16, 0xf5 + 16, x, y);
            rect_at(0xf1 + 32, 0xf9 + 32, 0xed + 32, 0xf5 + 32, x, y);
            CK(run_44eab1(x, y) == 1 && L.n == 1);
            ck_call(0, 0x44ecaf, (uintptr_t)fx.self, 2, 2, 0x2785, 1, 0, 0, 0, 0);
            /* a rectangle at index count is not looked at (and one at count - 1 is) */
            setup_44eab1(idx, 2);
            rect_at(0xf1 + 32, 0xf9 + 32, 0xed + 32, 0xf5 + 32, x, y);
            CK(run_44eab1(x, y) == 0 && L.n == 0);
            /* a count that is negative as a word, or zero, skips the loop */
            setup_44eab1(idx, -1);
            rect_at(0xf1, 0xf9, 0xed, 0xf5, x, y);
            CK(run_44eab1(x, y) == 0 && L.n == 0);
            setup_44eab1(idx, 0);
            rect_at(0xf1, 0xf9, 0xed, 0xf5, x, y);
            CK(run_44eab1(x, y) == 0 && L.n == 0);
            setup_44eab1(idx, (int)0x8000);
            rect_at(0xf1, 0xf9, 0xed, 0xf5, x, y);
            CK(run_44eab1(x, y) == 0 && L.n == 0);
            /* each of the four edges of a loop rectangle misses the point by one (y low above it, y high below, x low above, x high below) */
            for (e = 0; e < 4; e++) {
                setup_44eab1(idx, 1);
                rect_at(0xf1, 0xf9, 0xed, 0xf5, x, y);
                switch (e) {
                case 0: set32(fx.obj, 0xf1, (uint32_t)(y + 1)); break;
                case 1: set32(fx.obj, 0xf9, (uint32_t)(y - 1)); break;
                case 2: set32(fx.obj, 0xed, (uint32_t)(x + 1)); break;
                default: set32(fx.obj, 0xf5, (uint32_t)(x - 1)); break;
                }
                CK(run_44eab1(x, y) == 0 && L.n == 0);
            }
            /* the fixed rectangles A, B, C, D */
            for (f = 0; f < 4; f++) {
                setup_44eab1(idx, 0);
                rect_at(fixed[f][0], fixed[f][1], fixed[f][2], fixed[f][3], x, y);
                expect_begin();
                CK(run_44eab1(x, y) == 1);
                expect_end();
                CK(L.n == 1);
                ck_call(0, 0x44ecaf, (uintptr_t)fx.self, 2, 2, fsel[f], farg[f], 0, 0, 0, 0);
                for (e = 0; e < 4; e++) {
                    setup_44eab1(idx, 0);
                    rect_at(fixed[f][0], fixed[f][1], fixed[f][2], fixed[f][3], x, y);
                    switch (e) {
                    case 0: set32(fx.obj, fixed[f][0], (uint32_t)(y + 1)); break;
                    case 1: set32(fx.obj, fixed[f][1], (uint32_t)(y - 1)); break;
                    case 2: set32(fx.obj, fixed[f][2], (uint32_t)(x + 1)); break;
                    default: set32(fx.obj, fixed[f][3], (uint32_t)(x - 1)); break;
                    }
                    CK(run_44eab1(x, y) == 0 && L.n == 0);
                }
            }
            /* A wins over B, B over C, C over D */
            setup_44eab1(idx, 0);
            for (f = 1; f < 4; f++) rect_at(fixed[f][0], fixed[f][1], fixed[f][2], fixed[f][3], x, y);
            CK(run_44eab1(x, y) == 1 && L.n == 1);
            ck_call(0, 0x44ecaf, (uintptr_t)fx.self, 2, 2, 0x2786, 1, 0, 0, 0, 0);
            setup_44eab1(idx, 0);
            for (f = 2; f < 4; f++) rect_at(fixed[f][0], fixed[f][1], fixed[f][2], fixed[f][3], x, y);
            CK(run_44eab1(x, y) == 1 && L.n == 1);
            ck_call(0, 0x44ecaf, (uintptr_t)fx.self, 2, 2, 0x2786, 2, 0, 0, 0, 0);
        }
        /* the edges are 32-bit signed values, the point a sign-extended word: x low 0x10000 holds x = 0? no (0x10000 > 0); x high 0x10005
         * holds x = 5; x low -0x10000 holds x = -1 */
        setup_44eab1(idx, 1);
        set32(fx.obj, 0xf1, 0); set32(fx.obj, 0xf9, 9); set32(fx.obj, 0xed, 0x10000); set32(fx.obj, 0xf5, 0x10005);
        CK(run_44eab1(0, 5) == 0 && L.n == 0);
        set32(fx.obj, 0xed, 0); set32(fx.obj, 0xf5, 0x10005);
        CK(run_44eab1(5, 5) == 1 && L.n == 1);
        set32(fx.obj, 0xed, (uint32_t)-0x10000); set32(fx.obj, 0xf5, 0);
        CK(run_44eab1(-1, 5) == 1 && L.n == 1);
        CK(run_44eab1(1, 5) == 0 && L.n == 0);
        /* the point is a sign-extended word: -1 is not 0xffff */
        set32(fx.obj, 0xed, 0); set32(fx.obj, 0xf5, 0xffff);
        CK(run_44eab1(-1, 5) == 0 && L.n == 0);
        /* the stack words carry junk in the upper halves in the original; the port takes the low 16 bits (int16_t arguments) */
    }
}

/* ---- 0x46ebff ----------------------------------------------------------------------------------------------------------------- */

static void setup_46ebff(int idx, uint32_t sel)
{
    setup(idx, sel);
    set32(fx.self, 0x46, 0x01000000);
    set32(fx.self, 0x5f, 0);
    set32(fx.self, 0x28, 0);
    fx.w.value_5d03b3 = 0xcafe0001u;
}

static void run_46ebff(void)
{
    L.n = 0;
    m46ebff_click_27c2_27c3(fx.self, &fx.w, &fx.host);
}

static void test_m46ebff(void)
{
    static const int idxs[] = {2, -1};
    static const uint32_t sels[] = {0x27c2, 0x27c3, 0x27c4};
    static const int bytes52[] = {0, 9, 10, 11, 0xff};
    static const int ks[] = {0, 0, 1, 2, 246};
    size_t ii, si, k;
    int d, c, j;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        size_t rec = (size_t)(idx + 1) * REC + 0x4d;
        for (si = 0; si < 3; si++) {
            setup_46ebff(idx, sels[si]);
            set32(fx.self, 0x46, 0);
            expect_begin();
            run_46ebff();
            expect_end();
            CK(L.n == 0);
            for (k = 0; k < 5; k++) {
                setup_46ebff(idx, sels[si]);
                set32(fx.self, 0x5f, z32_fail[k]);
                expect_begin();
                run_46ebff();
                expect_end();
                CK(L.n == 0);
                setup_46ebff(idx, sels[si]);
                set32(fx.self, 0x28, z32_fail[k]);
                expect_begin();
                run_46ebff();
                expect_end();
                CK(L.n == 0);
            }
            for (k = 0; k < 6; k++) {
                setup_46ebff(idx, sels[si]);
                set32(fx.tab, rec, bad_state[k]);
                expect_begin();
                run_46ebff();
                expect_end();
                CK(L.n == 0);
            }
        }
        /* event 0x27c4: nothing */
        setup_46ebff(idx, 0x27c4);
        expect_begin();
        run_46ebff();
        expect_end();
        CK(L.n == 0);
        /* event 0x27c2 */
        for (k = 0; k < 5; k++) {
            for (d = -1; d <= 9; d++) {
                int ret;
                for (ret = 0; ret < 2; ret++) {
                    size_t at = 0x64d + (size_t)ks[k] * 0x95;
                    setup_46ebff(idx, 0x27c2);
                    fx.self[0x52] = (uint8_t)bytes52[k];
                    memcpy(fx.obj + at + 0x64, T[1], 9);
                    if (d >= 0) fx.obj[at + 0x64 + d] ^= 0x80;
                    fx.obj[at + 0x85] = 0x01;      /* the word at base + k * 0x95 + 0x85: 0x8001 (negative) */
                    fx.obj[at + 0x86] = 0x80;
                    g_ret_4f6334 = ret ? 5u : 0;
                    g_tick = 0xfffffff0u;
                    expect_begin();
                    set32(exp_self, 0x28, 1);
                    set16(exp_self, 0x2c, (uint16_t)bytes52[k]);
                    set32(exp_self, 0x2e, 0xfffffff0u + 0xfa);
                    set32(exp_self, 0x32, 1);
                    run_46ebff();
                    expect_end();
                    ck_tick(0);
                    CK(get32(L.c[0].snap_self, 0x28) == 1 && get32(L.c[0].snap_self, 0x2e) == 0xA5A5A5A5u);   /* [+0x28] and [+0x2c] come before the tick */
                    if (d == -1 || d == 9) {
                        CK(L.n == 1);
                    } else if (ret) {
                        CK(L.n == 2);
                        ck_call(1, 0x4f6334, 0x5cf1eb, 1, 0, 0xffff8001u, 0, 0, 0, 0, 0);
                    } else {
                        CK(L.n == 3);
                        ck_call(1, 0x4f6334, 0x5cf1eb, 1, 0, 0xffff8001u, 0, 0, 0, 0, 0);
                        ck_call(2, 0x4fb2e3, 0x5c3a67, 1, 1, 0x8001, 0, 0, 0, 0, 0);
                    }
                }
            }
            /* the flag zero: no compare */
            setup_46ebff(idx, 0x27c2);
            fx.self[0x52] = (uint8_t)bytes52[k];
            fx.w.value_5bb1ca = 0;
            run_46ebff();
            CK(L.n == 1);
        }
        /* event 0x27c3 */
        for (c = -1; c <= 13; c++) {
            setup_46ebff(idx, 0x27c3);
            set16(fx.obj, 0x21, (uint16_t)c);
            for (j = 0; j < 16; j++) {
                g_ret_4709bb[j] = 0x100u + (uint32_t)j;
                g_ret_4709de[j] = 0x1000u * (uint32_t)(j + 1);
                if (j < 13) set16(fx.self, 0x36 + 2 * (size_t)j, (uint16_t)(j ? 0x7000 + j : 0x8000));
            }
            g_tick = 0xfffffff0u;
            expect_begin();
            set32(exp_tab, rec, 2);
            memset(exp_self + 0x53, 1, 8);
            set32(exp_self, 0x5f, 1);
            for (j = 0; j < c; j++) set32(exp_self, 0x67 + 4 * (size_t)j, 0xfffffff0u + 0x1000u * (uint32_t)(j + 1));
            run_46ebff();
            expect_end();
            CK(L.n == (c > 0 ? 1 + 2 * c + 1 : 2));
            ck_tick(0);
            CK(get32(L.c[0].snap_tab, rec) == 2 && L.c[0].snap_self[0x53] == 1 && get32(L.c[0].snap_self, 0x5f) == 1);
            for (j = 0; j < c; j++) {
                /* the byte [+0x53 + j]: 1 for j < 8, the 0xA5 fill for 8..10, the low byte of [+0x5f] (1) at j = 12 */
                uintptr_t b = j < 8 ? 1 : j == 12 ? 1 : 0xA5;
                ck_call(1 + 2 * j, 0x4709bb, (uintptr_t)fx.self, 1, 0, b, 0, 0, 0, 0, 0);
                ck_call(2 + 2 * j, 0x4709de, (uintptr_t)fx.self, 2, 0, (uintptr_t)(uint32_t)(int32_t)(int16_t)(j ? 0x7000 + j : 0x8000), 0x100u + (uint32_t)j, 0, 0, 0, 0);
                /* the store of the previous iteration is visible at the next call */
                if (j > 0) CK(get32(L.c[1 + 2 * j].snap_self, 0x67 + 4 * (size_t)(j - 1)) == 0xfffffff0u + 0x1000u * (uint32_t)j);
            }
            ck_call(c > 0 ? 1 + 2 * c : 1, 0x448d11, 0x619a05, 4, 0, 0xcafe0001u, 0x54c14c, 0xffffffffu, 0, 0, 0);
        }
    }
}

/* ---- 0x4571e1 ----------------------------------------------------------------------------------------------------------------- */

static void setup_4571e1(int idx, int count)
{
    setup(idx, 0);
    set32(fx.self, 0x3e, 0x01000000);
    set32(fx.self, 0x2c, 0);
    set16(fx.self, 0x2a, 0x7fff);
    memset(fx.obj, 0x80, 0x300);
    set16(fx.obj, 0x25, (uint16_t)count);
}

/* the stored edges (ylo, yhi, xlo, xhi) of a rectangle whose EFFECTIVE edges (stored + adj) are exactly the point */
static void eff_rect(const size_t o[4], const int adj[4], int x, int y)
{
    set32(fx.obj, o[0], (uint32_t)(y - adj[0]));
    set32(fx.obj, o[1], (uint32_t)(y - adj[1]));
    set32(fx.obj, o[2], (uint32_t)(x - adj[2]));
    set32(fx.obj, o[3], (uint32_t)(x - adj[3]));
}

/* moves edge e (0 y low, 1 y high, 2 x low, 3 x high) of the rectangle one outside the point */
static void edge_out(const size_t o[4], int e)
{
    set32(fx.obj, o[e], get32(fx.obj, o[e]) + (e % 2 == 0 ? 1u : (uint32_t)-1));
}

static int32_t run_4571e1(int x, int y)
{
    L.n = 0;
    return m4571e1_hit_test(fx.self, (int16_t)x, (int16_t)y, &fx.w, &fx.host);
}

static void test_m4571e1(void)
{
    static const int idxs[] = {2, -1};
    static const int pts[][2] = {{5, 7}, {-1, -1}, {-32768, 32767}, {32767, -32768}, {0, 0}, {255, -2}};
    static const size_t R[3][4] = {{0x3b, 0x43, 0x37, 0x3f}, {0x4b, 0x53, 0x47, 0x4f}, {0x5b, 0x63, 0x57, 0x5f}};
    static const int ADJ[3][4] = {{-5, 5, 0, 0}, {5, 5, 10, -10}, {0, 0, 0, 0}};
    static const int ZERO[4] = {0, 0, 0, 0};
    static const size_t LAST[4] = {0x26f, 0x277, 0x26b, 0x273};
    size_t ii, pi, k;
    int r, e, i;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        for (pi = 0; pi < 6; pi++) {
            int x = pts[pi][0], y = pts[pi][1];
            /* the gates */
            setup_4571e1(idx, 1);
            eff_rect(R[0], ADJ[0], x, y);
            set32(fx.self, 0x3e, 0);
            expect_begin();
            CK(run_4571e1(x, y) == 0 && L.n == 0);
            expect_end();
            for (k = 0; k < 5; k++) {
                setup_4571e1(idx, 1);
                eff_rect(R[0], ADJ[0], x, y);
                set32(fx.self, 0x2c, z32_fail[k]);
                expect_begin();
                CK(run_4571e1(x, y) == 0 && L.n == 0);
                expect_end();
            }
            /* the three rectangles with their margins: exact edges hit, each edge one outside misses */
            for (r = 0; r < 3; r++) {
                setup_4571e1(idx, 0);
                eff_rect(R[r], ADJ[r], x, y);
                expect_begin();
                CK(run_4571e1(x, y) == 1);
                expect_end();
                CK(L.n == 1);
                ck_call(0, 0x45741d, (uintptr_t)fx.self, 2, 2, 0x27bc, (uintptr_t)r, 0, 0, 0, 0);
                for (e = 0; e < 4; e++) {
                    setup_4571e1(idx, 0);
                    eff_rect(R[r], ADJ[r], x, y);
                    edge_out(R[r], e);
                    CK(run_4571e1(x, y) == 0 && L.n == 0);
                }
            }
            /* the order: R1 before R2 */
            setup_4571e1(idx, 1);
            eff_rect(R[1], ADJ[1], x, y);
            eff_rect(R[2], ADJ[2], x, y);
            CK(run_4571e1(x, y) == 1 && L.n == 1);
            ck_call(0, 0x45741d, (uintptr_t)fx.self, 2, 2, 0x27bc, 1, 0, 0, 0, 0);
            /* the loop (count 3): hit i calls 0x27be with i unless i is the word [+0x2a]; the call is silent then but the result is 1 */
            for (i = 0; i < 3; i++) {
                size_t o[4];
                int quiet;
                o[0] = 0x9b + 16 * (size_t)i; o[1] = 0xa3 + 16 * (size_t)i; o[2] = 0x97 + 16 * (size_t)i; o[3] = 0x9f + 16 * (size_t)i;
                for (quiet = 0; quiet < 2; quiet++) {
                    setup_4571e1(idx, 3);
                    eff_rect(o, ZERO, x, y);
                    eff_rect(LAST, ZERO, x, y);          /* the last rectangle also holds the point, but the loop comes first */
                    set16(fx.self, 0x2a, (uint16_t)(quiet ? i : i + 0x100));
                    expect_begin();
                    CK(run_4571e1(x, y) == 1);
                    expect_end();
                    if (quiet) {
                        CK(L.n == 0);
                    } else {
                        CK(L.n == 1);
                        ck_call(0, 0x45741d, (uintptr_t)fx.self, 2, 2, 0x27be, (uintptr_t)i, 0, 0, 0, 0);
                    }
                }
                for (e = 0; e < 4; e++) {
                    setup_4571e1(idx, 3);
                    eff_rect(o, ZERO, x, y);
                    edge_out(o, e);
                    CK(run_4571e1(x, y) == 0 && L.n == 0);
                }
            }
            /* the word [+0x2a] is signed: 0xffff is -1, which is no index, so the call is made */
            setup_4571e1(idx, 1);
            {
                const size_t o[4] = {0x9b, 0xa3, 0x97, 0x9f};
                eff_rect(o, ZERO, x, y);
            }
            set16(fx.self, 0x2a, 0xffff);
            CK(run_4571e1(x, y) == 1 && L.n == 1);
            /* the rectangle at the index count is not looked at; a negative or zero count skips the loop */
            setup_4571e1(idx, 2);
            {
                const size_t o[4] = {0x9b + 32, 0xa3 + 32, 0x97 + 32, 0x9f + 32};
                eff_rect(o, ZERO, x, y);
            }
            CK(run_4571e1(x, y) == 0 && L.n == 0);
            for (k = 0; k < 3; k++) {
                static const int counts[] = {0, -1, -32768};
                const size_t o[4] = {0x9b, 0xa3, 0x97, 0x9f};
                setup_4571e1(idx, counts[k]);
                eff_rect(o, ZERO, x, y);
                CK(run_4571e1(x, y) == 0 && L.n == 0);
            }
            /* the last rectangle */
            setup_4571e1(idx, 0);
            eff_rect(LAST, ZERO, x, y);
            expect_begin();
            CK(run_4571e1(x, y) == 1);
            expect_end();
            CK(L.n == 1);
            ck_call(0, 0x45741d, (uintptr_t)fx.self, 2, 2, 0x27bd, 0, 0, 0, 0, 0);
            for (e = 0; e < 4; e++) {
                setup_4571e1(idx, 0);
                eff_rect(LAST, ZERO, x, y);
                edge_out(LAST, e);
                CK(run_4571e1(x, y) == 0 && L.n == 0);
            }
        }
        /* the margins wrap in 32 bits: R0 low y 0x80000002 - 5 wraps to a large positive edge (the point is below it: a miss), R0 high y
         * 0x7ffffffe + 5 wraps to a large negative one (the point is above it: a miss); R1 low x 0x7ffffff9 + 10 wraps negative: a hit */
        setup_4571e1(idx, 0);
        eff_rect(R[0], ADJ[0], 3, 3);
        set32(fx.obj, 0x3b, 0x80000002u);
        CK(run_4571e1(3, 3) == 0 && L.n == 0);
        eff_rect(R[0], ADJ[0], 3, 3);
        set32(fx.obj, 0x43, 0x7ffffffeu);
        CK(run_4571e1(3, 3) == 0 && L.n == 0);
        eff_rect(R[1], ADJ[1], 3, 3);
        set32(fx.obj, 0x47, 0x7ffffff9u);
        CK(run_4571e1(3, 3) == 1 && L.n == 1);
        ck_call(0, 0x45741d, (uintptr_t)fx.self, 2, 2, 0x27bc, 1, 0, 0, 0, 0);
    }
}

/* ---- 0x47b4aa ----------------------------------------------------------------------------------------------------------------- */

static void setup_47b4aa(int cnt, int s28c)
{
    setup(0, 0);
    set32(fx.self, 0x24, 0x01000000);
    set32(fx.self, 0x28, 0);
    set32(fx.self, 0x2c, 0);
    set32(fx.self, 0xc, OBJ_VA);
    set32(fx.self, 0x14, DECOY_VA);
    set32(fx.self, 0x28c, (uint32_t)s28c);
    set32(fx.self, 0x280, (uint32_t)cnt);
    memset(fx.obj, 0x80, 0x600);
    fx.obj[0x35b] = 0x80;      /* a negative signed byte is non-zero */
    memset(fx.decoy, 0, 0x400);
}

static int32_t run_47b4aa(int x, int y)
{
    L.n = 0;
    return m47b4aa_hit_test(fx.self, (int16_t)x, (int16_t)y, &fx.w, &fx.host);
}

/* row i of the first table: x low, y low, x high, y high at +0, +4, +8, +0xc */
static size_t row1_base(int s28c, int i)
{
    return 0x2a1 + (size_t)(ptrdiff_t)s28c * 0x30 + 16 * (size_t)i;
}

static void row1(int s28c, int i, int x, int y)
{
    size_t b = row1_base(s28c, i);
    set32(fx.obj, b, (uint32_t)x);
    set32(fx.obj, b + 4, (uint32_t)y);
    set32(fx.obj, b + 8, (uint32_t)x);
    set32(fx.obj, b + 0xc, (uint32_t)y);
}

/* row i of the second table (the code narrows it by 3 on every side) */
static void row2(int i, int x, int y)
{
    size_t b = 16 * (size_t)i;
    set32(fx.obj, b + 0x111, (uint32_t)(x - 3));
    set32(fx.obj, b + 0x115, (uint32_t)(y - 3));
    set32(fx.obj, b + 0x119, (uint32_t)(x + 3));
    set32(fx.obj, b + 0x11d, (uint32_t)(y + 3));
}

static void test_m47b4aa(void)
{
    static const int pts[][2] = {{5, 7}, {-1, -1}, {-32768, 32767}, {32767, -32768}, {0, 0}, {255, -2}};
    static const int ss[] = {2, 0, -1};
    static const int bytes[] = {1, 0x80, 0xff};
    static const uint32_t nz[] = {0x01000000u, 1, 0x80000000u, 0xffffffffu};
    size_t pi, k, si;
    int i, e, b, which;
    for (pi = 0; pi < 6; pi++) {
        int x = pts[pi][0], y = pts[pi][1];
        /* the gates: no store, no call */
        setup_47b4aa(0, 1);
        set32(fx.self, 0x24, 0);
        expect_begin();
        CK(run_47b4aa(x, y) == 0 && L.n == 0);
        expect_end();
        for (k = 0; k < 5; k++) {
            setup_47b4aa(0, 1);
            set32(fx.self, 0x28, z32_fail[k]);
            expect_begin();
            CK(run_47b4aa(x, y) == 0 && L.n == 0);
            expect_end();
            setup_47b4aa(0, 1);
            set32(fx.self, 0x2c, z32_fail[k]);
            expect_begin();
            CK(run_47b4aa(x, y) == 0 && L.n == 0);
            expect_end();
        }
        /* no hit: [+0x27c] = -1 and nothing else (count 0) */
        setup_47b4aa(0, 1);
        expect_begin();
        set32(exp_self, 0x27c, 0xffffffffu);
        CK(run_47b4aa(x, y) == 0 && L.n == 0);
        expect_end();
        for (si = 0; si < 3; si++) {
            int s = ss[si];
            /* the first table: row i holds the point exactly on its edges -> [+0x27c] = i, call 0x2768 */
            for (i = 0; i < 3; i++) {
                for (b = 0; b < 3; b++) {
                    setup_47b4aa(0, s);
                    fx.obj[0x35b] = (uint8_t)bytes[b];
                    row1(s, i, x, y);
                    expect_begin();
                    set32(exp_self, 0x27c, (uint32_t)i);
                    CK(run_47b4aa(x, y) == 1);
                    expect_end();
                    CK(L.n == 1);
                    ck_call(0, 0x47b709, (uintptr_t)fx.self, 1, 0, 0x2768, 0, 0, 0, 0, 0);
                    CK(get32(L.c[0].snap_self, 0x27c) == (uint32_t)i);   /* stored before the call */
                }
                /* each edge one outside misses */
                for (e = 0; e < 4; e++) {
                    size_t at = row1_base(s, i) + (size_t)(e == 0 ? 4 : e == 1 ? 0xc : e == 2 ? 0 : 8);
                    setup_47b4aa(0, s);
                    row1(s, i, x, y);
                    set32(fx.obj, at, get32(fx.obj, at) + (e % 2 == 0 ? 1u : (uint32_t)-1));
                    CK(run_47b4aa(x, y) == 0 && L.n == 0 && get32(fx.self, 0x27c) == 0xffffffffu);
                }
                /* the byte [object + 0x35b] zero skips the first table */
                setup_47b4aa(0, s);
                fx.obj[0x35b] = 0;
                row1(s, i, x, y);
                CK(run_47b4aa(x, y) == 0 && L.n == 0);
            }
        }
        /* the second table: s = 2, count 3, row i holds the point with the narrowed edges; the entry 6 + i of the third table is zero */
        for (i = 0; i < 3; i++) {
            setup_47b4aa(3, 2);
            row2(i, x, y);
            expect_begin();
            set32(exp_self, 0x27c, (uint32_t)i);
            set32(exp_self, 0x2b4, (uint32_t)(6 + i));
            CK(run_47b4aa(x, y) == 1);
            expect_end();
            CK(L.n == 1);
            ck_call(0, 0x47b709, (uintptr_t)fx.self, 1, 0, 0x2769, 0, 0, 0, 0, 0);
            CK(get32(L.c[0].snap_self, 0x2b4) == (uint32_t)(6 + i) && get32(L.c[0].snap_self, 0x27c) == (uint32_t)i);
            /* a non-zero dword +4 or +8 (only a high byte, or all ones) of the entry rejects the row; the index 2b4 stays at the last tried */
            for (k = 0; k < 4; k++) {
                for (which = 0; which < 2; which++) {
                    setup_47b4aa(3, 2);
                    row2(i, x, y);
                    set32(fx.decoy, (size_t)(6 + i) * 12 + (which ? 8 : 4), nz[k]);
                    expect_begin();
                    set32(exp_self, 0x27c, 0xffffffffu);
                    set32(exp_self, 0x2b4, 8);
                    CK(run_47b4aa(x, y) == 0 && L.n == 0);
                    expect_end();
                }
            }
            /* ... and the next row takes over when it holds the point and its entry is zero */
            if (i < 2) {
                setup_47b4aa(3, 2);
                row2(i, x, y);
                row2(i + 1, x, y);
                set32(fx.decoy, (size_t)(6 + i) * 12 + 4, 7);
                CK(run_47b4aa(x, y) == 1 && L.n == 1);
                CK(get32(fx.self, 0x27c) == (uint32_t)(i + 1) && get32(fx.self, 0x2b4) == (uint32_t)(6 + i + 1));
            }
            for (e = 0; e < 4; e++) {
                size_t at = 16 * (size_t)i + (size_t)(e == 0 ? 0x115 : e == 1 ? 0x11d : e == 2 ? 0x111 : 0x119);
                setup_47b4aa(3, 2);
                row2(i, x, y);
                set32(fx.obj, at, get32(fx.obj, at) + (e % 2 == 0 ? 1u : (uint32_t)-1));
                CK(run_47b4aa(x, y) == 0 && L.n == 0);
            }
        }
        /* counts: the row at the count is not looked at; a negative count (also 0x80000000) runs nothing; [+0x2b4] = s * count + i */
        setup_47b4aa(2, 2);
        row2(2, x, y);
        CK(run_47b4aa(x, y) == 0 && L.n == 0 && get32(fx.self, 0x2b4) == 5);
        setup_47b4aa(-1, 2);
        row2(0, x, y);
        CK(run_47b4aa(x, y) == 0 && L.n == 0 && get32(fx.self, 0x2b4) == 0xA5A5A5A5u);
        setup_47b4aa((int)0x80000000u, 2);
        row2(0, x, y);
        CK(run_47b4aa(x, y) == 0 && L.n == 0);
        /* the first table wins over the second */
        setup_47b4aa(3, 0);
        row1(0, 2, x, y);
        row2(0, x, y);
        CK(run_47b4aa(x, y) == 1 && L.n == 1 && get32(fx.self, 0x27c) == 2);
        ck_call(0, 0x47b709, (uintptr_t)fx.self, 1, 0, 0x2768, 0, 0, 0, 0, 0);
    }
    /* the second table's margins wrap: x low 0x7ffffffe + 3 wraps negative, so the point holds; x high 0x80000002 - 3 wraps positive */
    setup_47b4aa(1, 0);
    row2(0, 4, 4);
    set32(fx.obj, 0x111, 0x7ffffffeu);
    CK(run_47b4aa(4, 4) == 1 && L.n == 1);
    setup_47b4aa(1, 0);
    row2(0, 4, 4);
    set32(fx.obj, 0x119, 0x80000002u);
    CK(run_47b4aa(4, 4) == 1 && L.n == 1);
}

/* ---- the table of cases ------------------------------------------------------------------------------------------------------- */

static const struct {
    const char *name;
    void (*fn)(void);
} CASES[] = {
    {"test_m4d3bef_reset_flags", test_m4d3bef},
    {"test_m44edfb_click_2785_2787", test_m44edfb},
    {"test_m4cb3ab_store_flag", test_m4cb3ab},
    {"test_m44eab1_hit_test", test_m44eab1},
    {"test_m46ebff_click_27c2_27c3", test_m46ebff},
    {"test_m4571e1_hit_test", test_m4571e1},
    {"test_m47b4aa_hit_test", test_m47b4aa},
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
