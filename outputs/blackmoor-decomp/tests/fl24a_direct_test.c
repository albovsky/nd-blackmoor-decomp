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

static int16_t get16s(const uint8_t *o, size_t off)
{
    int16_t v;
    memcpy(&v, o + off, 2);
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
static uint32_t g_ret_4f6334, g_ret_4709bb[16], g_ret_4709de[16], g_ret_482595;
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
    if (callee == 0x482595) return g_ret_482595;
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

static void test_m4d3bef_reset_flags(void)
{
    (void)m4d3bef_reset_flags;
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

static void test_m44edfb_click_2785_2787(void)
{
    (void)m44edfb_click_2785_2787;
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

static void test_m4cb3ab_store_flag(void)
{
    (void)m4cb3ab_store_flag;
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

static void test_m44eab1_hit_test(void)
{
    (void)m44eab1_hit_test;
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

static void test_m46ebff_click_27c2_27c3(void)
{
    (void)m46ebff_click_27c2_27c3;
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

static void test_m4571e1_hit_test(void)
{
    (void)m4571e1_hit_test;
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

static void test_m47b4aa_hit_test(void)
{
    (void)m47b4aa_hit_test;
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

/* ---- 0x4a6574 ----------------------------------------------------------------------------------------------------------------- */

static void setup_4a6574(int idx, int w2e, int w63, int b65)
{
    setup(idx, 0);
    set32(fx.self, 0x86, 0x01000000);
    fx.self[0x29] = 0;
    set16(fx.self, 0x2e, (uint16_t)w2e);
    memset(fx.obj, 0x80, 0x400);
    set16(fx.obj, 0x63, (uint16_t)w63);
    fx.obj[0x65] = (uint8_t)b65;
    fx.w.value_61d3c2 = 0;
}

static int32_t run_4a6574(int x, int y)
{
    L.n = 0;
    return m4a6574_hit_test(fx.self, (int16_t)x, (int16_t)y, &fx.w, &fx.host);
}

static void test_m4a6574_hit_test(void)
{
    (void)m4a6574_hit_test;
    static const int idxs[] = {2, -1};
    static const int pts[][2] = {{5, 7}, {-1, -1}, {-32768, 32767}, {32767, -32768}, {0, 0}, {255, -2}};
    static const size_t R[6][4] = {{0x2b2, 0x2ba, 0x2ae, 0x2b6}, {0x2c2, 0x2ca, 0x2be, 0x2c6}, {0x1ba, 0x1c2, 0x1b6, 0x1be},
                                   {0x1da, 0x1e2, 0x1d6, 0x1de}, {0x3cb, 0x3d3, 0x3c7, 0x3cf}, {0x6a, 0x72, 0x66, 0x6e}};
    static const int ZERO[4] = {0, 0, 0, 0};
    static const uint32_t SEL[5] = {0x2772, 0x2771, 0x276f, 0x276f, 0x2770};
    static const uint32_t ARG[5] = {3, 2, 1, 4, 0};
    static const uint32_t g6_other[] = {0, 5, 7, 0x106, 0x80000006u, 0xffffffffu};
    size_t ii, pi, k;
    int r, e;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        for (pi = 0; pi < 6; pi++) {
            int x = pts[pi][0], y = pts[pi][1];
            /* [+0x86] clear (a dword; the high byte alone counts as set): the tail returns 0 and stores nothing, even with 0x61d3c2 = 6 */
            for (k = 0; k < 2; k++) {
                setup_4a6574(idx, 0, 0, 1);
                eff_rect(R[0], ZERO, x, y);
                eff_rect(R[5], ZERO, x, y);
                set32(fx.self, 0x86, 0);
                fx.w.value_61d3c2 = k ? 6u : 0u;
                expect_begin();
                CK(run_4a6574(x, y) == 0 && L.n == 0);
                expect_end();
            }
            /* the byte [+0x29] set with [+0x86] set: the original reads an uninitialised slot; rejected: 0, no call, no store */
            for (k = 0; k < 3; k++) {
                static const int b29[] = {1, 0x80, 0xff};
                setup_4a6574(idx, 0, 0, 1);
                eff_rect(R[0], ZERO, x, y);
                eff_rect(R[5], ZERO, x, y);
                fx.self[0x29] = (uint8_t)b29[k];
                fx.w.value_61d3c2 = 6;
                expect_begin();
                CK(run_4a6574(x, y) == 0 && L.n == 0);
                expect_end();
            }
            /* the five rectangles: a hit calls 0x4a67f3 (this = self, selector, argument) and returns 1; [+0x20] = 1 only for the 4th and 5th */
            for (r = 0; r < 5; r++) {
                setup_4a6574(idx, 0, 0, 1);
                eff_rect(R[r], ZERO, x, y);
                expect_begin();
                if (r >= 3) exp_self[0x20] = 1;
                CK(run_4a6574(x, y) == 1);
                expect_end();
                CK(L.n == 1);
                ck_call(0, 0x4a67f3, (uintptr_t)fx.self, 2, 0, SEL[r], ARG[r], 0, 0, 0, 0);
                CK(r < 3 || L.c[0].snap_self[0x20] == 0xA5);        /* the byte is stored after the call */
                /* each edge one outside misses: return 0, no call; with 0x61d3c2 = 6 the tail sets the byte */
                for (e = 0; e < 4; e++) {
                    setup_4a6574(idx, 0, 0, 1);
                    eff_rect(R[r], ZERO, x, y);
                    edge_out(R[r], e);
                    expect_begin();
                    CK(run_4a6574(x, y) == 0 && L.n == 0);
                    expect_end();
                    fx.w.value_61d3c2 = 6;
                    exp_self[0x20] = 1;
                    CK(run_4a6574(x, y) == 0 && L.n == 0);
                    expect_end();
                }
            }
            /* the order: rectangle 1 before 2 before 3 before 4 before 5 */
            for (r = 0; r < 4; r++) {
                int q;
                setup_4a6574(idx, 0, 0, 1);
                for (q = r; q < 5; q++) eff_rect(R[q], ZERO, x, y);
                CK(run_4a6574(x, y) == 1 && L.n == 1);
                ck_call(0, 0x4a67f3, (uintptr_t)fx.self, 2, 0, SEL[r], ARG[r], 0, 0, 0, 0);
            }
            /* the first rectangle with the byte [obj + 0x65] clear: it needs [+0x2e] < [obj + 0x63] - 1 (signed words, 32-bit subtraction) */
            {
                static const int w2e[] = {3, 4, 5, -2, -32768, -32768, 0x7fff, 0x7ffd};
                static const int w63[] = {5, 5, 5, 0, -32767, -32768, 0x7fff, 0x7fff};
                static const int pass[] = {1, 0, 0, 1, 0, 0, 0, 1};
                for (k = 0; k < 8; k++) {
                    setup_4a6574(idx, w2e[k], w63[k], 0);
                    eff_rect(R[0], ZERO, x, y);
                    CK(run_4a6574(x, y) == (pass[k] ? 1 : 0));
                    CK(L.n == (pass[k] ? 1 : 0));
                    if (pass[k]) ck_call(0, 0x4a67f3, (uintptr_t)fx.self, 2, 0, 0x2772, 3, 0, 0, 0, 0);
                }
            }
            /* a skipped first rectangle falls through to the second, which holds the point with the byte clear and [+0x2e] above 0 */
            setup_4a6574(idx, 9, 5, 0);
            eff_rect(R[0], ZERO, x, y);
            eff_rect(R[1], ZERO, x, y);
            CK(run_4a6574(x, y) == 1 && L.n == 1);
            ck_call(0, 0x4a67f3, (uintptr_t)fx.self, 2, 0, 0x2771, 2, 0, 0, 0, 0);
            /* the second rectangle with the byte clear: [+0x2e] > 0 as a signed word */
            {
                static const int w2e[] = {1, 0x7fff, 0, -1, -32768, 0x8000};
                static const int pass[] = {1, 1, 0, 0, 0, 0};
                for (k = 0; k < 6; k++) {
                    setup_4a6574(idx, w2e[k], 5, 0);
                    eff_rect(R[1], ZERO, x, y);
                    CK(run_4a6574(x, y) == (pass[k] ? 1 : 0));
                    CK(L.n == (pass[k] ? 1 : 0));
                    if (pass[k]) ck_call(0, 0x4a67f3, (uintptr_t)fx.self, 2, 0, 0x2771, 2, 0, 0, 0, 0);
                }
            }
            /* the byte [obj + 0x65] is a byte: any non-zero value passes (0x80, 0xff, 1) while its word neighbour is irrelevant */
            for (k = 0; k < 3; k++) {
                static const int b65[] = {1, 0x80, 0xff};
                setup_4a6574(idx, -5, 0, b65[k]);
                eff_rect(R[1], ZERO, x, y);
                CK(run_4a6574(x, y) == 1 && L.n == 1);
            }
            /* the tail: inside its rectangle the byte is set; outside only when 0x61d3c2 is exactly 6; always returns 0 */
            setup_4a6574(idx, 0, 0, 1);
            eff_rect(R[5], ZERO, x, y);
            expect_begin();
            exp_self[0x20] = 1;
            CK(run_4a6574(x, y) == 0 && L.n == 0);
            expect_end();
            for (e = 0; e < 4; e++) {
                for (k = 0; k < 6; k++) {
                    setup_4a6574(idx, 0, 0, 1);
                    eff_rect(R[5], ZERO, x, y);
                    edge_out(R[5], e);
                    fx.w.value_61d3c2 = g6_other[k];
                    expect_begin();
                    CK(run_4a6574(x, y) == 0 && L.n == 0);
                    expect_end();
                }
                setup_4a6574(idx, 0, 0, 1);
                eff_rect(R[5], ZERO, x, y);
                edge_out(R[5], e);
                fx.w.value_61d3c2 = 6;
                expect_begin();
                exp_self[0x20] = 1;
                CK(run_4a6574(x, y) == 0 && L.n == 0);
                expect_end();
            }
        }
    }
}

/* ---- 0x465c99 ----------------------------------------------------------------------------------------------------------------- */

static void setup_465c99(int idx, int k, int w2c)
{
    setup(idx, 0);
    set32(fx.self, 0x49, 0x01000000);
    set16(fx.self, 0x2a, (uint16_t)k);
    set16(fx.self, 0x2c, (uint16_t)w2c);
    memset(fx.obj, 0x80, 0x600);
}

static int32_t run_465c99(int x, int y)
{
    L.n = 0;
    return m465c99_hit_test(fx.self, (int16_t)x, (int16_t)y, &fx.w, &fx.host);
}

/* the row of k: lo [+0xf8], y low [+0xfc], hi [+0x100], y high [+0x104] at 16 k */
static void set_row(int k, uint32_t lo, int ylo, uint32_t hi, int yhi)
{
    size_t b = (size_t)(ptrdiff_t)(16 * k);
    set32(fx.obj, b + 0xf8, lo);
    set32(fx.obj, b + 0xfc, (uint32_t)ylo);
    set32(fx.obj, b + 0x100, hi);
    set32(fx.obj, b + 0x104, (uint32_t)yhi);
}

/* 0: no call; else the argument pair (a, b) of the call (0x27d2, a, b) that is expected */
static void ck_row(int x, int y, int k, int w2c, int d, int t, int want_a, int want_b)
{
    /* lo = x - t, hi = lo + d (32-bit) */
    setup_465c99(2, k, w2c);
    set_row(k, (uint32_t)(x - t), y, (uint32_t)(x - t) + (uint32_t)d, y);
    if (want_a == 0) {
        CK(run_465c99(x, y) == 0 && L.n == 0);
    } else {
        CK(run_465c99(x, y) == 1 && L.n == 1);
        ck_call(0, 0x465f8e, (uintptr_t)fx.self, 3, 0, 0x27d2, (uintptr_t)want_a, (uintptr_t)want_b, 0, 0, 0);
    }
}

static void test_m465c99_hit_test(void)
{
    (void)m465c99_hit_test;
    static const int idxs[] = {2, -1};
    static const int pts[][2] = {{5, 7}, {-1, -1}, {-32768, 32767}, {32767, -32768}, {0, 0}, {255, -2}};
    static const int ks[] = {-4, -1, 0, 1, 6, 7, 9};
    static const int ws[] = {0, 1, -1, 3, 0x7fff, -32768};
    static const size_t RECT[3][4] = {{0x6c, 0x74, 0x68, 0x70}, {0x5c, 0x64, 0x58, 0x60}, {0x553, 0x55b, 0x54f, 0x557}};
    static const int ZERO[4] = {0, 0, 0, 0};
    size_t ii, pi, ki, wi, k;
    int e, r;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        for (pi = 0; pi < 6; pi++) {
            int x = pts[pi][0], y = pts[pi][1];
            /* the gate: dword [+0x49] clear returns 0 even with a rectangle that holds the point */
            setup_465c99(idx, 1, 0);
            set_row(1, (uint32_t)(x - 1), y, (uint32_t)(x - 1) + 8u, y);
            set32(fx.self, 0x49, 0);
            expect_begin();
            CK(run_465c99(x, y) == 0 && L.n == 0);
            expect_end();
            /* the row: the split at (hi - lo) / 2 and the strict / non-strict edges, for every row index and [+0x2c] */
            for (ki = 0; ki < 7; ki++) {
                for (wi = 0; wi < 6; wi++) {
                    int k_ = ks[ki], w_ = ws[wi];
                    int c1 = k_ > 0 && w_ == 0, c2 = k_ < 7 && w_ == 0;
                    /* d = 8 (half 4): t = 1..4 -> the first test, 5..7 -> the second, -1, 0, 8 -> none */
                    ck_row(x, y, k_, w_, 8, -1, 0, 0);
                    ck_row(x, y, k_, w_, 8, 0, 0, 0);
                    ck_row(x, y, k_, w_, 8, 1, c1 ? 0x19 : 0, 2);
                    ck_row(x, y, k_, w_, 8, 4, c1 ? 0x19 : 0, 2);
                    ck_row(x, y, k_, w_, 8, 5, c2 ? 0x1a : 0, 3);
                    ck_row(x, y, k_, w_, 8, 7, c2 ? 0x1a : 0, 3);
                    ck_row(x, y, k_, w_, 8, 8, 0, 0);
                    /* d = 9 (half 4, not 5): t = 5 is already the second test, 8 too, 9 is out */
                    ck_row(x, y, k_, w_, 9, 4, c1 ? 0x19 : 0, 2);
                    ck_row(x, y, k_, w_, 9, 5, c2 ? 0x1a : 0, 3);
                    ck_row(x, y, k_, w_, 9, 8, c2 ? 0x1a : 0, 3);
                    ck_row(x, y, k_, w_, 9, 9, 0, 0);
                    /* d = 2 (half 1): t = 1 first test; t = 2 is not below hi; d = 1 (half 0): nothing; negative d: nothing */
                    ck_row(x, y, k_, w_, 2, 1, c1 ? 0x19 : 0, 2);
                    ck_row(x, y, k_, w_, 2, 2, 0, 0);
                    ck_row(x, y, k_, w_, 1, 1, 0, 0);
                    ck_row(x, y, k_, w_, -3, 0, 0, 0);
                    ck_row(x, y, k_, w_, -3, -1, 0, 0);
                }
            }
            /* the 32-bit subtraction wraps: lo = INT_MIN, hi = INT_MAX give d = -1, half 0: the point is above lo + 0 and below hi: second test */
            setup_465c99(idx, 1, 0);
            set_row(1, 0x80000000u, y, 0x7fffffffu, y);
            CK(run_465c99(x, y) == 1 && L.n == 1);
            ck_call(0, 0x465f8e, (uintptr_t)fx.self, 3, 0, 0x27d2, 0x1a, 3, 0, 0, 0);
            /* the y edges of the row: one outside misses */
            setup_465c99(idx, 1, 0);
            set_row(1, (uint32_t)(x - 1), y + 1, (uint32_t)(x - 1) + 8u, y);
            CK(run_465c99(x, y) == 0 && L.n == 0);
            setup_465c99(idx, 1, 0);
            set_row(1, (uint32_t)(x - 1), y, (uint32_t)(x - 1) + 8u, y - 1);
            CK(run_465c99(x, y) == 0 && L.n == 0);
            /* the rectangles: 0x16, then 0x14 / 0x15 by [+0x2c], then the last */
            for (r = 0; r < 3; r++) {
                static const int wsel[] = {0, 1, 2, -1, -32768, 3, 4, 0x7fff};
                for (k = 0; k < 8; k++) {
                    int w_ = wsel[k];
                    if (r != 1 && k > 0) break;
                    setup_465c99(idx, 5, r == 1 ? w_ : 5);
                    eff_rect(RECT[r], ZERO, x, y);
                    expect_begin();
                    if (r == 0) {
                        CK(run_465c99(x, y) == 1 && L.n == 1);
                        ck_call(0, 0x465f8e, (uintptr_t)fx.self, 3, 0, 0x27d2, 0x16, 1, 0, 0, 0);
                    } else if (r == 2) {
                        CK(run_465c99(x, y) == 1 && L.n == 1);
                        ck_call(0, 0x465f8e, (uintptr_t)fx.self, 3, 0, 0x27d3, 0, 0, 0, 0, 0);
                    } else if (w_ < 3) {
                        CK(run_465c99(x, y) == 1 && L.n == 1);
                        ck_call(0, 0x465f8e, (uintptr_t)fx.self, 3, 0, 0x27d2, 0x14, 4, 0, 0, 0);
                    } else if (w_ == 3) {
                        CK(run_465c99(x, y) == 1 && L.n == 1);
                        ck_call(0, 0x465f8e, (uintptr_t)fx.self, 3, 0, 0x27d2, 0x15, 4, 0, 0, 0);
                    } else {
                        CK(run_465c99(x, y) == 0 && L.n == 0);
                    }
                    expect_end();
                }
                for (e = 0; e < 4; e++) {
                    setup_465c99(idx, 5, 0);
                    eff_rect(RECT[r], ZERO, x, y);
                    edge_out(RECT[r], e);
                    CK(run_465c99(x, y) == 0 && L.n == 0);
                }
            }
            /* the order: the rectangle 0x16 comes before 0x14, which comes before the last */
            setup_465c99(idx, 5, 1);
            eff_rect(RECT[0], ZERO, x, y);
            eff_rect(RECT[1], ZERO, x, y);
            eff_rect(RECT[2], ZERO, x, y);
            CK(run_465c99(x, y) == 1 && L.n == 1);
            ck_call(0, 0x465f8e, (uintptr_t)fx.self, 3, 0, 0x27d2, 0x16, 1, 0, 0, 0);
            setup_465c99(idx, 5, 1);
            eff_rect(RECT[1], ZERO, x, y);
            eff_rect(RECT[2], ZERO, x, y);
            CK(run_465c99(x, y) == 1 && L.n == 1);
            ck_call(0, 0x465f8e, (uintptr_t)fx.self, 3, 0, 0x27d2, 0x14, 4, 0, 0, 0);
        }
    }
}

/* ---- 0x482724 ----------------------------------------------------------------------------------------------------------------- */

static void setup_482724(int idx, uint32_t sel, int w, int w92, int b91)
{
    setup(idx, sel);
    fx.self[0xa8] = 0x80;
    set16(fx.self, 0xa9, 0xffff);
    set32(fx.self, 0x78, 0);
    set16(fx.self, 0xad, (uint16_t)w);
    set16(fx.self, 0x92, (uint16_t)w92);
    fx.self[0x91] = (uint8_t)b91;
    memset(fx.obj, 0x5c, 0x400);
    set16(fx.obj, 0x3a2, 2);
    set16(fx.obj, 0x3a4, 3);
    set16(fx.obj, 0x39e, 4);
    set16(fx.obj, 0x3a0, 5);
    fx.obj[0xfb] = 0;
    g_ret_482595 = 0x12345680u;
}

static void run_482724(void)
{
    L.n = 0;
    m482724_click_27b5_27b6(fx.self, &fx.w, &fx.host);
}

static void test_m482724_click_27b5_27b6(void)
{
    (void)m482724_click_27b5_27b6;
    static const int idxs[] = {2, -1};
    static const uint32_t bad78[] = {2, 0x100, 0x10000, 3, 0xffffffffu, 0x80000000u};
    static const int bad_a9[] = {0, 1, 0x7fff, 0x8000, 0xfffe, 2};
    static const uint32_t other_sel[] = {0x27b4, 0x27b7, 0x26b5, 0, 0xffffffffu};
    size_t ii, k;
    int b, wi;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        size_t rec = (size_t)(idx + 1) * REC + 0x4d;
        /* the byte [+0xa8] clear (the bytes next to it set): nothing, for both events */
        for (k = 0; k < 2; k++) {
            setup_482724(idx, k ? 0x27b6u : 0x27b5u, 2, 0, 0);
            fx.self[0xa8] = 0;
            expect_begin();
            run_482724();
            expect_end();
            CK(L.n == 0);
        }
        /* event 0x27b6: [+0xab] = 1, the record goes to state 2, whatever the rest */
        setup_482724(idx, 0x27b6, 2, 0, 0);
        set32(fx.self, 0x78, 5);
        set16(fx.self, 0xa9, 3);
        expect_begin();
        exp_self[0xab] = 1;
        set32(exp_tab, rec, 2);
        run_482724();
        expect_end();
        CK(L.n == 0);
        /* [+0x78] other than 0 or 1: nothing */
        for (k = 0; k < 6; k++) {
            setup_482724(idx, 0x27b5, 2, 0, 0);
            set32(fx.self, 0x78, bad78[k]);
            expect_begin();
            run_482724();
            expect_end();
            CK(L.n == 0);
        }
        /* [+0xa9] other than -1: nothing */
        for (k = 0; k < 6; k++) {
            setup_482724(idx, 0x27b5, 2, 0, 0);
            set16(fx.self, 0xa9, (uint16_t)bad_a9[k]);
            expect_begin();
            run_482724();
            expect_end();
            CK(L.n == 0);
        }
        /* another event: nothing */
        for (k = 0; k < 5; k++) {
            setup_482724(idx, other_sel[k], 2, 0, 0);
            expect_begin();
            run_482724();
            expect_end();
            CK(L.n == 0);
        }
        /* w == word 0x3a2 (= 2): with [+0x92] > 0 or the byte [+0x91] set, [+0x78] = 2 and [+0x91] = 0 and done; the dword [+0x30] = 1 */
        for (b = 0; b < 2; b++) {
            static const int w92s[] = {0, 1, 0x7fff, -1, -32768};
            for (wi = 0; wi < 5; wi++) {
                int done = w92s[wi] > 0 || b;
                setup_482724(idx, 0x27b5, 2, w92s[wi], b ? 0x80 : 0);
                set32(fx.self, 0x78, (uint32_t)(wi & 1));
                expect_begin();
                set16(exp_self, 0xa9, 2);
                set32(exp_self, 0x30, 1);
                if (done) {
                    set32(exp_self, 0x78, 2);
                    exp_self[0x91] = 0;
                    run_482724();
                    expect_end();
                    CK(L.n == 0);
                } else {
                    /* falls through: w is not 0x3a4, 0x39e or 0x3a0, and is 0x3a2: return */
                    run_482724();
                    expect_end();
                    CK(L.n == 0);
                }
            }
        }
        /* w == word 0x3a4 (= 3): the byte [+0x91] clear: [+0x92] = 0, call 0x482595 (word 0x39e, 1), [+0x91] = the low byte of eax */
        {
            static const uint32_t rets[] = {0x12345680u, 0x1ffu, 0x100u, 0, 0xffffff7fu};
            for (k = 0; k < 5; k++) {
                setup_482724(idx, 0x27b5, 3, 0x1234, 0);
                g_ret_482595 = rets[k];
                expect_begin();
                set16(exp_self, 0xa9, 3);
                set32(exp_self, 0x34, 1);
                set16(exp_self, 0x92, 0);
                exp_self[0x91] = (uint8_t)rets[k];
                run_482724();
                expect_end();
                CK(L.n == 1);
                ck_call(0, 0x482595, (uintptr_t)fx.self, 2, 1, 4, 1, 0, 0, 0, 0);
                CK(get16s(L.c[0].snap_self, 0x92) == 0 && L.c[0].snap_self[0x91] == 0);     /* [+0x92] is cleared before the call, [+0x91] after */
            }
            /* ... with the byte set: no call for 0x3a4, nothing else */
            setup_482724(idx, 0x27b5, 3, 0x1234, 7);
            expect_begin();
            set16(exp_self, 0xa9, 3);
            set32(exp_self, 0x34, 1);
            run_482724();
            expect_end();
            CK(L.n == 0);
            /* w == word 0x39e (= 4): [+0x91] clear: call (4, 1); set: call (4, 0); the byte is stored from eax in both */
            setup_482724(idx, 0x27b5, 4, 0x1234, 0);
            expect_begin();
            set16(exp_self, 0xa9, 4);
            set32(exp_self, 0x38, 1);
            set16(exp_self, 0x92, 0);
            exp_self[0x91] = 0x80;
            run_482724();
            expect_end();
            CK(L.n == 1);
            ck_call(0, 0x482595, (uintptr_t)fx.self, 2, 1, 4, 1, 0, 0, 0, 0);
            setup_482724(idx, 0x27b5, 4, 0x1234, 0x40);
            expect_begin();
            set16(exp_self, 0xa9, 4);
            set32(exp_self, 0x38, 1);
            exp_self[0x91] = 0x80;
            run_482724();
            expect_end();
            CK(L.n == 1);
            ck_call(0, 0x482595, (uintptr_t)fx.self, 2, 1, 4, 0, 0, 0, 0, 0);
            CK(L.c[0].snap_self[0x91] == 0x40);
            /* w == word 0x3a0 (= 5): [+0x91] clear: the call still names the word 0x39e (4) and 1; set: (5, 0) */
            setup_482724(idx, 0x27b5, 5, 0x1234, 0);
            expect_begin();
            set16(exp_self, 0xa9, 5);
            set32(exp_self, 0x3c, 1);
            set16(exp_self, 0x92, 0);
            exp_self[0x91] = 0x80;
            run_482724();
            expect_end();
            CK(L.n == 1);
            ck_call(0, 0x482595, (uintptr_t)fx.self, 2, 1, 4, 1, 0, 0, 0, 0);
            setup_482724(idx, 0x27b5, 5, 0x1234, 0xff);
            g_ret_482595 = 0x33;
            expect_begin();
            set16(exp_self, 0xa9, 5);
            set32(exp_self, 0x3c, 1);
            exp_self[0x91] = 0x33;
            run_482724();
            expect_end();
            CK(L.n == 1);
            ck_call(0, 0x482595, (uintptr_t)fx.self, 2, 1, 5, 0, 0, 0, 0, 0);
            /* the words 0x39e and 0x3a2 equal (2): w = 2 with the first block failing falls into the chain, which matches 0x39e */
            setup_482724(idx, 0x27b5, 2, 0, 0);
            set16(fx.obj, 0x39e, 2);
            expect_begin();
            set16(exp_self, 0xa9, 2);
            set32(exp_self, 0x30, 1);
            exp_self[0x91] = 0x80;
            run_482724();
            expect_end();
            CK(L.n == 1);
            ck_call(0, 0x482595, (uintptr_t)fx.self, 2, 1, 2, 1, 0, 0, 0, 0);
            /* the words are compared as signed words: the word 0x3a4 = 0x8003 does not equal 3 (a high bit alone differs) */
            setup_482724(idx, 0x27b5, 3, 0, 0);
            set16(fx.obj, 0x3a4, 0x8003);
            expect_begin();
            run_482724();
            CK(L.n == 0 && fx.self[0x91] == 0 && get32(fx.self, 0xa2) == 1);   /* took the tail */
        }
        /* the tail: w = 7 matches none of the words */
        {
            static const int w92s[] = {0, 1, -1, 3, -3, 8, -2};
            static const int fbs[] = {0, 0x80, 0xff};
            for (wi = 0; wi < 7; wi++) {
                for (k = 0; k < 3; k++) {
                    int w92 = w92s[wi];
                    setup_482724(idx, 0x27b5, 7, w92, 0x55);
                    fx.obj[0xfb] = (uint8_t)fbs[k];
                    expect_begin();
                    set16(exp_self, 0xa9, 7);
                    set32(exp_self, 0x44, 1);
                    exp_self[0x91] = 0;
                    if (w92 == 0) {
                        exp_self[0x94] = 1;
                        memset(exp_self + 0x95, 0, 11);
                    }
                    exp_self[0x95 + w92] = 7;
                    if (w92 == 0) set32(exp_self, 0xa2, fbs[k] == 0 ? 1u : 0u);
                    /* the final increment reads the word again (the store above can be its own low byte: index -3) */
                    set16(exp_self, 0x92, (uint16_t)(exp_self[0x92] | (exp_self[0x93] << 8)) + 1u);
                    run_482724();
                    expect_end();
                    CK(L.n == 0);
                }
            }
            /* w = 1: [+0xa2] = 1 even with the byte [obj + 0xfb] set */
            setup_482724(idx, 0x27b5, 1, 0, 0);
            fx.obj[0xfb] = 0xff;
            run_482724();
            CK(get32(fx.self, 0xa2) == 1 && fx.self[0x95] == 1 && fx.self[0x94] == 1 && get16s(fx.self, 0x92) == 1);
            /* the store at 0x95 + [+0x92] and the test of [+0x92] == 0 for [+0xa2]: with [+0x92] = 1 the dword [+0xa2] is left alone */
            setup_482724(idx, 0x27b5, 7, 1, 0);
            run_482724();
            CK(get32(fx.self, 0xa2) == 0xA5A5A5A5u && fx.self[0x96] == 7 && fx.self[0x94] == 0xA5);
        }
    }
}

/* ---- 0x470ffe ----------------------------------------------------------------------------------------------------------------- */

static Fl24aWorld exp_world;

static void setup_470ffe(int idx, int count)
{
    setup(idx, 0x9999);
    set16(fx.self, 0xd28, (uint16_t)idx);
    fx.self[0xd3e] = 0x80;
    fx.self[0xd3b] = 0;
    memset(fx.obj, 0x80, 0x400);
    set16(fx.obj, 0x21, (uint16_t)count);
    fx.obj[0x24] = 0x01;
    fx.w.value_5b44f0 = 0x11111111u;
    fx.w.value_5b44f4 = 0x22222222u;
    fx.w.value_5d0377 = 0x1234abcdu;
    fx.w.value_5d162d = 0x33333333u;
    fx.w.value_5d1631 = 0x44444444u;
    fx.w.value_5d1639 = 0x55555555u;
}

/* the same for a rectangle of the object itself */
static void eff_rect_self(const size_t o[4], int x, int y)
{
    set32(fx.self, o[0], (uint32_t)y);
    set32(fx.self, o[1], (uint32_t)y);
    set32(fx.self, o[2], (uint32_t)x);
    set32(fx.self, o[3], (uint32_t)x);
}

static int32_t run_470ffe(int x, int y)
{
    L.n = 0;
    return m470ffe_hit_test(fx.self, (int16_t)x, (int16_t)y, &fx.w, &fx.host);
}

/* the expected world after a hit that announces (a, event) */
static void exp_announce(uint32_t a, uint32_t event)
{
    exp_world.value_5b44f0 = a;
    exp_world.value_5b44f4 = 1;
    exp_world.value_5d162d = 0x1234abcdu;
    exp_world.value_5d1631 = 0x5b160cu + a * 32 + 16;
    exp_world.value_5d1639 = 1;
    exp_world.value_5c39e5 = event;
}

static void ck_world(void)
{
    CK(memcmp(&exp_world, &fx.w, sizeof fx.w) == 0);
}

static void test_m470ffe_hit_test(void)
{
    (void)m470ffe_hit_test;
    static const int idxs[] = {2, -1};
    static const int pts[][2] = {{5, 7}, {-1, -1}, {-32768, 32767}, {32767, -32768}, {0, 0}, {255, -2}};
    static const size_t FIRST[4] = {0x100, 0x108, 0xfc, 0x104};
    static const size_t TAIL[4] = {0x39, 0x41, 0x35, 0x3d};
    static const int ZERO[4] = {0, 0, 0, 0};
    size_t ii, pi;
    int e, i, b;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        for (pi = 0; pi < 6; pi++) {
            int x = pts[pi][0], y = pts[pi][1];
            /* the first rectangle: announce (9, 0x27ad); [+0xd2a] is not stored */
            setup_470ffe(idx, 0);
            eff_rect(FIRST, ZERO, x, y);
            expect_begin();
            exp_world = fx.w;
            exp_announce(9, 0x27ad);
            CK(run_470ffe(x, y) == 1);
            expect_end();
            ck_world();
            CK(L.n == 0);
            /* the gate: the byte [+0xd3e] clear (its neighbours set) fails even with the rectangle holding the point */
            setup_470ffe(idx, 0);
            eff_rect(FIRST, ZERO, x, y);
            fx.self[0xd3e] = 0;
            expect_begin();
            exp_world = fx.w;
            set16(exp_self, 0xd2a, 0xffff);
            CK(run_470ffe(x, y) == 0);
            expect_end();
            ck_world();
            for (e = 0; e < 4; e++) {
                setup_470ffe(idx, 0);
                eff_rect(FIRST, ZERO, x, y);
                edge_out(FIRST, e);
                expect_begin();
                exp_world = fx.w;
                set16(exp_self, 0xd2a, 0xffff);
                CK(run_470ffe(x, y) == 0);
                expect_end();
                ck_world();
            }
            /* the loop: rectangle i of count 4, with the byte [+0xd3b] clear: announce (0x16, 0x27a6) and [+0xd2a] = i */
            for (i = 0; i < 4; i++) {
                size_t o[4];
                o[0] = 0x660 + 16 * (size_t)i; o[1] = 0x668 + 16 * (size_t)i; o[2] = 0x65c + 16 * (size_t)i; o[3] = 0x664 + 16 * (size_t)i;
                setup_470ffe(idx, 4);
                for (b = 0; b < 4; b++) {
                    size_t o2[4];
                    o2[0] = 0x660 + 16 * (size_t)b; o2[1] = 0x668 + 16 * (size_t)b; o2[2] = 0x65c + 16 * (size_t)b; o2[3] = 0x664 + 16 * (size_t)b;
                    if (b > i) {
                        eff_rect_self(o2, x, y);       /* later rectangles hold the point too, but the first hit wins */
                    }
                }
                eff_rect_self(o, x, y);
                expect_begin();
                exp_world = fx.w;
                exp_announce(0x16, 0x27a6);
                set16(exp_self, 0xd2a, (uint16_t)i);
                CK(run_470ffe(x, y) == 1);
                expect_end();
                ck_world();
                /* each edge one outside misses (the tail is not reachable: its byte [obj + 0x24] rectangle misses) */
                for (e = 0; e < 4; e++) {
                    setup_470ffe(idx, 4);
                    eff_rect_self(o, x, y);
                    set32(fx.self, o[e], get32(fx.self, o[e]) + (e % 2 == 0 ? 1u : (uint32_t)-1));
                    CK(run_470ffe(x, y) == 0 && get16s(fx.self, 0xd2a) == -1);
                }
                /* the byte [+0xd3b] set skips the loop (the first rectangle is not affected) */
                for (b = 0; b < 3; b++) {
                    static const int vals[] = {1, 0x80, 0xff};
                    setup_470ffe(idx, 4);
                    eff_rect_self(o, x, y);
                    fx.self[0xd3b] = (uint8_t)vals[b];
                    CK(run_470ffe(x, y) == 0 && get16s(fx.self, 0xd2a) == -1);
                }
                /* the rectangle at the index count is not looked at */
                setup_470ffe(idx, i);
                eff_rect_self(o, x, y);
                CK(run_470ffe(x, y) == 0);
            }
            /* a negative count: no loop */
            setup_470ffe(idx, -1);
            eff_rect_self((const size_t[4]){0x660, 0x668, 0x65c, 0x664}, x, y);
            CK(run_470ffe(x, y) == 0);
            /* the tail: [+0xd3b] clear and the byte [obj + 0x24] set: announce (0x16, 0x27a6), [+0xd2a] = 0x28 */
            setup_470ffe(idx, 0);
            eff_rect(TAIL, ZERO, x, y);
            expect_begin();
            exp_world = fx.w;
            exp_announce(0x16, 0x27a6);
            set16(exp_self, 0xd2a, 0x28);
            CK(run_470ffe(x, y) == 1);
            expect_end();
            ck_world();
            for (e = 0; e < 4; e++) {
                setup_470ffe(idx, 0);
                eff_rect(TAIL, ZERO, x, y);
                edge_out(TAIL, e);
                CK(run_470ffe(x, y) == 0 && get16s(fx.self, 0xd2a) == -1);
            }
            setup_470ffe(idx, 0);
            eff_rect(TAIL, ZERO, x, y);
            fx.obj[0x24] = 0;
            CK(run_470ffe(x, y) == 0 && get16s(fx.self, 0xd2a) == -1);
            setup_470ffe(idx, 0);
            eff_rect(TAIL, ZERO, x, y);
            fx.self[0xd3b] = 1;
            CK(run_470ffe(x, y) == 0 && get16s(fx.self, 0xd2a) == -1);
            /* the first rectangle wins over the loop, the loop over the tail */
            setup_470ffe(idx, 1);
            eff_rect(FIRST, ZERO, x, y);
            eff_rect_self((const size_t[4]){0x660, 0x668, 0x65c, 0x664}, x, y);
            eff_rect(TAIL, ZERO, x, y);
            CK(run_470ffe(x, y) == 1 && fx.w.value_5b44f0 == 9);
            setup_470ffe(idx, 1);
            eff_rect_self((const size_t[4]){0x660, 0x668, 0x65c, 0x664}, x, y);
            eff_rect(TAIL, ZERO, x, y);
            CK(run_470ffe(x, y) == 1 && fx.w.value_5b44f0 == 0x16 && get16s(fx.self, 0xd2a) == 0);
        }
    }
}

/* ---- 0x4a6946 ----------------------------------------------------------------------------------------------------------------- */

static const uint8_t CONST_550964[9] = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'};

static void setup_4a6946(int idx, uint32_t sel, uint32_t t25, int n)
{
    int k;
    setup(idx, sel);
    set32(fx.self, 0x86, 0x01000000);
    fx.self[0x8b] = 0;
    set32(fx.self, 0x21, 0);
    set32(fx.self, 0x25, t25);
    set16(fx.self, 0x2e, 0x1234);
    for (k = 0; k < 12; k++) set16(fx.self, 0x92 + 2 * (size_t)k, (uint16_t)(0x1000 + k));
    set32(fx.self, 0x90, 0x90909090u);
    memset(fx.obj, 0x5c, 0x400);
    set16(fx.obj, 0x298, (uint16_t)n);
    memcpy(fx.obj + 0x300, "ABCDEFGHIJKLMNO", 16);       /* with its terminator */
    memcpy(fx.obj + 0x2cf, "abcdefghijklmnop", 17);
    set16(fx.obj, 0x321, 0x8001);
    set16(fx.obj, 0x2f0, 0x7ff0);
    fx.w.bytes_550964 = CONST_550964;
    fx.w.value_5bb1ca = 0;
    g_tick = 0xfffffff0u;
}

static void run_4a6946(void)
{
    L.n = 0;
    m4a6946_click_276f_2770(fx.self, &fx.w, &fx.host);
}

static void test_m4a6946_click_276f_2770(void)
{
    (void)m4a6946_click_276f_2770;
    static const int idxs[] = {2, -1};
    static const uint32_t sels[] = {0x2770, 0x276f};
    static const int ns[] = {-2, 0, 1, 2, 3};
    size_t ii, si, k;
    int d, ni, ret;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        size_t rec = (size_t)(idx + 1) * REC + 0x4d;
        for (si = 0; si < 2; si++) {
            setup_4a6946(idx, sels[si], 1, 2);
            set32(fx.self, 0x86, 0);
            expect_begin();
            run_4a6946();
            expect_end();
            CK(L.n == 0);
            for (k = 0; k < 3; k++) {
                static const int b8b[] = {1, 0x80, 0xff};
                setup_4a6946(idx, sels[si], 1, 2);
                fx.self[0x8b] = (uint8_t)b8b[k];
                expect_begin();
                run_4a6946();
                expect_end();
                CK(L.n == 0);
            }
            for (k = 0; k < 5; k++) {
                setup_4a6946(idx, sels[si], 1, 2);
                set32(fx.self, 0x21, z32_fail[k]);
                expect_begin();
                run_4a6946();
                expect_end();
                CK(L.n == 0);
            }
            for (k = 0; k < 6; k++) {
                setup_4a6946(idx, sels[si], 1, 2);
                set32(fx.tab, rec, bad_state[k]);
                expect_begin();
                run_4a6946();
                expect_end();
                CK(L.n == 0);
            }
        }
        /* event 0x2770: byte [+0x8a] = 1, state 2; any other event: nothing */
        setup_4a6946(idx, 0x2770, 1, 2);
        expect_begin();
        exp_self[0x8a] = 1;
        set32(exp_tab, rec, 2);
        run_4a6946();
        expect_end();
        CK(L.n == 0);
        for (k = 0; k < 3; k++) {
            static const uint32_t others[] = {0x276e, 0x2771, 0};
            setup_4a6946(idx, others[k], 1, 2);
            expect_begin();
            run_4a6946();
            expect_end();
            CK(L.n == 0);
        }
        /* [+0x25] = 1 (switch 0): [+0x21] = 1, byte [+0x20] = 1, [+0x90] = tick + 0x1f4 */
        setup_4a6946(idx, 0x276f, 1, 2);
        expect_begin();
        set32(exp_self, 0x21, 1);
        exp_self[0x20] = 1;
        set32(exp_self, 0x90, 0xfffffff0u + 0x1f4);
        run_4a6946();
        expect_end();
        CK(L.n == 1 && L.c[0].callee == TICK_ID && get32(L.c[0].snap_self, 0x21) == 1 && get32(L.c[0].snap_self, 0x90) == 0x90909090u);
        /* [+0x25] = 2 and 3 (switch 1 and 2): the same arm, [+0x90] = tick + 0x12c and word [+0x80] = 1 */
        for (k = 2; k <= 3; k++) {
            setup_4a6946(idx, 0x276f, (uint32_t)k, 2);
            expect_begin();
            set32(exp_self, 0x21, (uint32_t)k);
            exp_self[0x20] = 1;
            set32(exp_self, 0x90, 0xfffffff0u + 0x12c);
            set16(exp_self, 0x80, 1);
            run_4a6946();
            expect_end();
            CK(L.n == 1);
        }
        /* [+0x25] = 4 (switch 3): the words from +0x92 shift down (word[i+1] = word[i+2] for i < n - 1), word[n] = word [+0x2e], then the tick;
         * the dword [+0x90] overlaps the word at +0x92 and is stored last */
        for (ni = 0; ni < 5; ni++) {
            int n = ns[ni], i;
            setup_4a6946(idx, 0x276f, 4, n);
            expect_begin();
            set32(exp_self, 0x21, 4);
            exp_self[0x20] = 1;
            for (i = 0; i < n - 1; i++) set16(exp_self, 0x94 + 2 * (size_t)i, (uint16_t)(0x1000 + i + 2));   /* the sources are not yet overwritten: i + 2 > i + 1 */
            set16(exp_self, (size_t)(0x92 + 2 * n), 0x1234);
            set32(exp_self, 0x90, 0xfffffff0u + 0x1f4);
            run_4a6946();
            expect_end();
            CK(L.n == 1);
        }
        /* the other values of [+0x25] (0, 5, 0x80000001, 0xffffffff, 0x100000000 is not a dword) skip the switch: no tick */
        for (k = 0; k < 4; k++) {
            static const uint32_t vals[] = {0, 5, 0x80000001u, 0xffffffffu};
            setup_4a6946(idx, 0x276f, vals[k], 2);
            expect_begin();
            set32(exp_self, 0x21, vals[k]);
            exp_self[0x20] = 1;
            run_4a6946();
            expect_end();
            CK(L.n == 0);
        }
        /* the announcement: [+0x25] = 1 and 4 keep the string at +0x300 and the word 0x8001, 2 and 3 the string at +0x2cf and 0x7ff0 */
        for (k = 1; k <= 4; k++) {
            for (d = -1; d <= 9; d++) {
                for (ret = 0; ret < 2; ret++) {
                    static uint8_t cbuf[9];
                    memcpy(cbuf, (k == 2 || k == 3) ? "abcdefghi" : "ABCDEFGHI", 9);
                    setup_4a6946(idx, 0x276f, (uint32_t)k, 2);
                    fx.w.value_5bb1ca = 0x100;
                    fx.w.bytes_550964 = cbuf;
                    if (d >= 0 && d <= 8) cbuf[d] ^= 0x20;
                    if (d == 9) { /* the tenth byte of the string differs from nothing: it is not compared */ }
                    g_ret_4f6334 = ret ? 3u : 0;
                    run_4a6946();
                    {
                        uint32_t want_word = (k == 2 || k == 3) ? 0x7ff0u : 0xffff8001u;
                        if (d == -1 || d == 9) {
                            CK(L.n == 1);
                        } else if (ret) {
                            CK(L.n == 2);
                            ck_call(1, 0x4f6334, 0x5cf1eb, 1, 0, want_word, 0, 0, 0, 0, 0);
                        } else {
                            CK(L.n == 3);
                            ck_call(1, 0x4f6334, 0x5cf1eb, 1, 0, want_word, 0, 0, 0, 0, 0);
                            ck_call(2, 0x4fb2e3, 0x5c3a67, 1, 1, want_word, 0, 0, 0, 0, 0);
                            CK(get32(L.c[1].snap_self, 0x90) == 0xfffffff0u + ((k == 2 || k == 3) ? 0x12c : 0x1f4));   /* the tick is stored first */
                        }
                    }
                }
            }
        }
        /* a string that does not fit in the 40 bytes of the original's buffer (no terminator within them) is rejected: the effects before the
         * copy stay ([+0x21], [+0x20], the shift of switch 3), but no tick, no store of [+0x90], no calls */
        setup_4a6946(idx, 0x276f, 1, 2);
        memset(fx.obj + 0x300, 'Z', 40);
        fx.obj[0x300 + 40] = 0;
        fx.w.value_5bb1ca = 0x100;
        expect_begin();
        set32(exp_self, 0x21, 1);
        exp_self[0x20] = 1;
        run_4a6946();
        expect_end();
        CK(L.n == 0);
        /* 39 characters and the terminator (40 bytes) still fit */
        setup_4a6946(idx, 0x276f, 1, 2);
        memset(fx.obj + 0x300, 'Z', 39);
        fx.obj[0x300 + 39] = 0;
        run_4a6946();
        CK(L.n == 1 && get32(fx.self, 0x90) == 0xfffffff0u + 0x1f4);
    }
}

/* ---- bounded random sweep ------------------------------------------------------------------------------------------------------- */

static uint32_t g_seed = 0x2468ace1u;

static uint32_t rnd(void)
{
    g_seed ^= g_seed << 13;
    g_seed ^= g_seed >> 17;
    g_seed ^= g_seed << 5;
    return g_seed;
}

static int rr(int lo, int hi)
{
    return lo + (int)(rnd() % (uint32_t)(hi - lo + 1));
}

static void rand_fill(uint8_t *p, size_t n)
{
    size_t i;
    for (i = 0; i < n; i++) p[i] = (uint8_t)rnd();
}

/* Random objects, record tables, selectors and flags for every port, with the indexes and counts that the originals do not bound kept inside
 * the fixture (as the callers of the originals do). It checks no value: it runs under ASan / UBSan to show that nothing reads or writes
 * outside the buffers, whatever the guards and the data are. */
static void test_sweep(void)
{
    static const uint32_t sels[] = {0x2785, 0x2786, 0x2787, 0x27c2, 0x27c3, 0x27b5, 0x27b6, 0x276f, 0x2770, 0};
    int f, iter, i;
    for (f = 0; f < 13; f++) {
        for (iter = 0; iter < 2500; iter++) {
            int idx = rr(-1, 4);
            setup(idx, sels[rnd() % 10]);
            rand_fill(fx.self, 0x1000);
            rand_fill(fx.obj, 0x1000);
            rand_fill(fx.decoy, 0x1000);
            rand_fill(fx.a154, sizeof fx.a154);
            rand_fill(fx.a12, sizeof fx.a12);
            fx.w.value_5bb1ca = rnd();
            fx.w.byte_61c6ae = (uint8_t)rnd();
            fx.w.word_63a4cd = (int16_t)rnd();
            fx.w.value_61d3c2 = rr(0, 1) ? 6u : rnd();
            g_ret_4f6334 = rnd();
            g_ret_482595 = rnd();
            g_tick = rnd();
            for (i = 0; i < 16; i++) {
                g_ret_4709bb[i] = rnd();
                g_ret_4709de[i] = rnd();
            }
            for (i = 0; i < 6; i++) {
                set32(fx.tab, (size_t)i * REC, OBJ_VA);
                set32(fx.tab, (size_t)i * REC + 0x4d, (uint32_t)rr(0, 3) == 1 ? 1u : (uint32_t)rr(0, 3));
            }
            switch (f) {
            case 0: m4d3bef_reset_flags(fx.self, &fx.w); break;
            case 1:
                set16(fx.self, 0x1e, (uint16_t)idx);
                set32(fx.self, 0x6b, rnd() & 3 ? 1u : 0u);
                set32(fx.self, 0x2c, rnd() & 3 ? 0u : rnd());
                m44edfb_click_2785_2787(fx.self, &fx.w, &fx.host);
                break;
            case 2:
                set32(fx.self, 0x12, A12_VA);
                set32(fx.self, 0x16, TBL_VA + 0x100);
                set32(fx.self, 0x154, rnd() & 1 ? A154_VA : 0);
                {
                    /* the entry of the third table is a flag index (kept inside the flag table) and a value */
                    int w = rr(-3, 40);
                    size_t q = 0x100 + 0x23 + (size_t)(ptrdiff_t)w * 4;
                    set16(fx.a154, 0x14, (uint16_t)(int16_t)w);
                    set16(fx.a12, 5, (uint16_t)(int16_t)w);
                    set16(fx.tbl, q, (uint16_t)(int16_t)rr(-20, 30));
                    set16(fx.tbl, q + 2, (uint16_t)rnd());
                }
                m4cb3ab_store_flag(fx.self, &fx.w, &fx.host);
                break;
            case 3:
            case 4:
            case 6:
            case 7:
            case 11:
            case 12: {
                /* the hit tests: small rectangles around the point, counts and indexes in range */
                int16_t x = (int16_t)rr(-40, 40), y = (int16_t)rr(-40, 40);
                size_t o;
                set16(fx.self, 0x1e, (uint16_t)idx);
                set16(fx.self, 0xd28, (uint16_t)idx);
                set32(fx.self, 0x6b, rnd() & 7 ? 1u : 0u);
                set32(fx.self, 0x3e, rnd() & 7 ? 1u : 0u);
                set32(fx.self, 0x49, rnd() & 7 ? 1u : 0u);
                set32(fx.self, 0x24, rnd() & 7 ? 1u : 0u);
                set32(fx.self, 0x86, rnd() & 7 ? 1u : 0u);
                set32(fx.self, 0x28, 0);
                set32(fx.self, 0x2c, rnd() & 3 ? 0u : rnd());
                fx.self[0xd3e] = (uint8_t)(rnd() & 7 ? 1 : 0);
                fx.self[0x29] = 0;
                fx.self[0xd3b] = (uint8_t)(rnd() & 3 ? 0 : 1);
                set16(fx.self, 0x2a, (uint16_t)(int16_t)rr(-4, 9));
                set32(fx.self, 0xc, OBJ_VA);
                set32(fx.self, 0x14, DECOY_VA);
                set32(fx.self, 0x28c, (uint32_t)rr(0, 3));
                set32(fx.self, 0x280, (uint32_t)rr(-2, 5));
                set16(fx.obj, 0x25, (uint16_t)(int16_t)rr(-3, 6));
                set16(fx.obj, 0x21, (uint16_t)(int16_t)rr(-3, 6));
                set16(fx.obj, 0x63, (uint16_t)(int16_t)rr(-3, 6));
                for (o = 0; o < 0x600; o += 4) {
                    uint32_t v = (uint32_t)(int32_t)(rr(-3, 3) + (rnd() & 1 ? x : y) + (int)(rnd() % 5) - 2);
                    if (rnd() & 1) set32(fx.obj, o, v);
                }
                if (f == 3) m44eab1_hit_test(fx.self, x, y, &fx.w, &fx.host);
                if (f == 4) m46ebff_click_27c2_27c3(fx.self, &fx.w, &fx.host);
                if (f == 6) m4571e1_hit_test(fx.self, x, y, &fx.w, &fx.host);
                if (f == 7) m47b4aa_hit_test(fx.self, x, y, &fx.w, &fx.host);
                if (f == 11) m4a6574_hit_test(fx.self, x, y, &fx.w, &fx.host);
                if (f == 12) m465c99_hit_test(fx.self, x, y, &fx.w, &fx.host);
                break;
            }
            case 5:
                /* 0x46ebff reads up to 246 rows of 0x95 bytes behind the record object */
                set16(fx.self, 0x1e, (uint16_t)idx);
                set32(fx.self, 0x46, 1);
                set32(fx.self, 0x5f, 0);
                set32(fx.self, 0x28, 0);
                set16(fx.obj, 0x21, (uint16_t)(int16_t)rr(-3, 13));
                m46ebff_click_27c2_27c3(fx.self, &fx.w, &fx.host);
                break;
            case 8:
                set16(fx.self, 0x1e, (uint16_t)idx);
                fx.self[0xa8] = 1;
                set16(fx.self, 0xa9, 0xffff);
                set32(fx.self, 0x78, (uint32_t)rr(0, 2));
                set16(fx.self, 0xad, (uint16_t)(int16_t)rr(-2, 13));
                set16(fx.self, 0x92, (uint16_t)(int16_t)rr(-3, 8));
                m482724_click_27b5_27b6(fx.self, &fx.w, &fx.host);
                break;
            case 9:
                set16(fx.self, 0x1e, (uint16_t)idx);
                set32(fx.self, 0x86, 1);
                fx.self[0x8b] = 0;
                set32(fx.self, 0x21, 0);
                set32(fx.self, 0x25, (uint32_t)rr(0, 5));
                set16(fx.obj, 0x298, (uint16_t)(int16_t)rr(-2, 8));
                fx.w.bytes_550964 = T[0];
                m4a6946_click_276f_2770(fx.self, &fx.w, &fx.host);
                break;
            default:
                set16(fx.self, 0xd28, (uint16_t)idx);
                fx.self[0xd3e] = 1;
                set16(fx.obj, 0x21, (uint16_t)(int16_t)rr(-3, 6));
                m470ffe_hit_test(fx.self, (int16_t)rr(-9, 9), (int16_t)rr(-9, 9), &fx.w, &fx.host);
                break;
            }
        }
    }
}

/* ---- the table of cases ------------------------------------------------------------------------------------------------------- */

static const struct {
    const char *name;
    void (*fn)(void);
} CASES[] = {
    {"test_m4d3bef_reset_flags", test_m4d3bef_reset_flags},
    {"test_m44edfb_click_2785_2787", test_m44edfb_click_2785_2787},
    {"test_m4cb3ab_store_flag", test_m4cb3ab_store_flag},
    {"test_m44eab1_hit_test", test_m44eab1_hit_test},
    {"test_m46ebff_click_27c2_27c3", test_m46ebff_click_27c2_27c3},
    {"test_m4571e1_hit_test", test_m4571e1_hit_test},
    {"test_m47b4aa_hit_test", test_m47b4aa_hit_test},
    {"test_m4a6574_hit_test", test_m4a6574_hit_test},
    {"test_m465c99_hit_test", test_m465c99_hit_test},
    {"test_m482724_click_27b5_27b6", test_m482724_click_27b5_27b6},
    {"test_m470ffe_hit_test", test_m470ffe_hit_test},
    {"test_m4a6946_click_276f_2770", test_m4a6946_click_276f_2770},
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
