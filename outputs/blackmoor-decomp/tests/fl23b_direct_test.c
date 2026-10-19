/* FL-23 (batch b) direct tests of the click handlers of GAME.EXE in src/original_methods_fl23b.c. Prints "PASS <name>" / "FAIL <name>: <msg>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the
 * disassembly of GAME.EXE, not from running the native code; tests/test_fl23b_differential.py additionally runs the original bytes on
 * generated fixtures.
 *
 * Every function is checked three ways: (1) the guard matrix, each guard of the chain failing in turn with every selector of the function
 * and an unrelated one, which must leave the object, the record table and the call log untouched; (2) each arm with the whole object and
 * the record table compared with a hand-edited copy, and the ordered host calls (GetTickCount included) with their arguments and the
 * state of the object at the call; (3) the same arms with a negative record index (the index word is signed). */
#include "../src/original_methods_fl23b.h"

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

#define SELF_SZ 0x1600
#define REC 0x8d
#define TAB_SZ (REC * 6)          /* records -1 .. 4 */
#define TICK_ID 0x52a23cu
#define OBJ_VA 0x20010000u        /* the object of the target record */
#define DECOY_VA 0x20020000u      /* the object of every other record */
#define OBJ18_VA 0x20030000u      /* the object at [self + 0x18] (0x4ba4f2) */
#define N_FUNCS 12

static void set32(uint8_t *o, size_t off, uint32_t v) { memcpy(o + off, &v, 4); }
static void set16(uint8_t *o, size_t off, uint16_t v) { memcpy(o + off, &v, 2); }
static uint16_t get16(const uint8_t *o, size_t off)
{
    uint16_t v;
    memcpy(&v, o + off, 2);
    return v;
}

static struct {
    uint8_t self[SELF_SZ];
    uint8_t tab[TAB_SZ];
    uint8_t obj[0x1000], decoy[0x1000], obj18[0x1000];
    Fl23bWorld w;
    Fl18Host host;
} fx;

static const uint8_t T[7][9] = {{'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'}, {'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r'},
                                {'s', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A'}, {'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'},
                                {'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S'}, {'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '0', '1'},
                                {'2', '3', '4', '5', '6', '7', '8', '9', '!'}};

static uint32_t g_tick, g_ret_4e26fc, g_ret_4f6334;
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[4];
        uint8_t snap_self[SELF_SZ], snap_tab[TAB_SZ];
    } c[8];
} L;

static void log_call(uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int i;
    L.c[L.n].callee = callee;
    L.c[L.n].this_ptr = this_ptr;
    L.c[L.n].nargs = nargs;
    for (i = 0; i < nargs && i < 4; i++) L.c[L.n].a[i] = args[i];
    memcpy(L.c[L.n].snap_self, fx.self, SELF_SZ);
    memcpy(L.c[L.n].snap_tab, fx.tab, TAB_SZ);
    L.n++;
}

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    (void)ctx;
    log_call(callee, this_ptr, args, nargs);
    return callee == 0x4e26fc ? g_ret_4e26fc : callee == 0x4f6334 ? g_ret_4f6334 : 0;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (a >= OBJ_VA && a < OBJ_VA + 0x1000) return fx.obj + (a - OBJ_VA);
    if (a >= DECOY_VA && a < DECOY_VA + 0x1000) return fx.decoy + (a - DECOY_VA);
    if (a >= OBJ18_VA && a < OBJ18_VA + 0x1000) return fx.obj18 + (a - OBJ18_VA);
    return NULL;
}

static uint32_t host_tick(void *ctx)
{
    (void)ctx;
    log_call(TICK_ID, 0, NULL, 0);
    return g_tick;
}

/* ---- the table of functions ------------------------------------------------------------------------------------------------- */

enum { NZ32, Z32, NZ8, Z8, WEQ, WZ, NE32 };
typedef struct {
    int kind;
    size_t off;
    uint32_t val;
} Gate;
typedef struct {
    const char *name;
    size_t idx_off;       /* the record index word */
    int ngates;
    Gate gates[6];
    int nsels;
    uint32_t sels[3];
    int stores_76;        /* 0x473ffc stores [+0x76] before any guard */
} Spec;

static const Spec S[N_FUNCS] = {
    {"test_m4a1efd_click_2760", 0x1e, 3, {{NZ32, 0x60, 0}, {Z8, 0x58, 0}, {Z32, 0x4c, 0}}, 1, {0x2760}, 0},
    {"test_m4ba4f2_click_276a", 6, 1, {{NZ32, 0x34, 0}}, 1, {0x276a}, 0},
    {"test_m46957d_click_272e", 0x7e, 4, {{NZ32, 0x55c, 0}, {NZ32, 0x158, 0}, {Z32, 0x54a, 0}, {WEQ, 0x548, 0x64}}, 1, {0x272e}, 0},
    {"test_m4b45ed_click_2739", 0x728, 4, {{NZ32, 0x76e, 0}, {Z32, 0x77a, 0}, {Z32, 0x772, 0}, {WZ, 0x750, 0}}, 1, {0x2739}, 0},
    {"test_m473ffc_click_27a1", 0xc, 4, {{NZ32, 0x7a, 0}, {Z32, 0x10, 0}, {Z32, 0x82, 0}, {Z32, 0x7e, 0}}, 1, {0x27a1}, 1},
    {"test_m48e851_click_27b8_27b9", 0x1e, 3, {{NZ32, 0x462, 0}, {Z8, 0x45a, 0}, {Z32, 0x452, 0}}, 2, {0x27b9, 0x27b8}, 0},
    {"test_m45e587_click_27ec_27ef", 0x1e, 3, {{NZ8, 0x321, 0}, {Z8, 0x2aa, 0}, {NE32, 0x39e, 0xa}}, 3, {0x27ef, 0x27ec, 0x27ed}, 0},
    {"test_m48ab49_click_2756_2757", 0x1e, 3, {{NZ32, 0x1aa, 0}, {Z8, 0x1af, 0}, {Z32, 0x1b6, 0}}, 2, {0x2757, 0x2756}, 0},
    {"test_m4ab899_click_27ce_27d0", 0x1e, 3, {{NZ32, 0x54, 0}, {Z8, 0x59, 0}, {Z32, 0x5e, 0}}, 3, {0x27d0, 0x27ce, 0x27cf}, 0},
    {"test_m4574e4_click_27bc_27be", 0x1e, 2, {{NZ32, 0x3e, 0}, {Z32, 0x24, 0}}, 3, {0x27bd, 0x27be, 0x27bc}, 0},
    {"test_m47a03c_click_279c_279d", 0x1e, 4, {{NZ32, 0x157a, 0}, {Z32, 0x1576, 0}, {Z32, 0x24, 0}, {Z32, 0x1528, 0}}, 2, {0x279d, 0x279c}, 0},
    {"test_m4b2a9e_click_2792_2793", 0x1e, 3, {{NZ32, 0x1515, 0}, {Z32, 0x151d, 0}, {Z32, 0x24, 0}}, 2, {0x2793, 0x2792}, 0},
};

static void run(int f)
{
    L.n = 0;
    switch (f) {
    case 0: m4a1efd_click_2760(fx.self, &fx.w); break;
    case 1: m4ba4f2_click_276a(fx.self, &fx.w, &fx.host); break;
    case 2: m46957d_click_272e(fx.self, &fx.w); break;
    case 3: m4b45ed_click_2739(fx.self, &fx.w); break;
    case 4: m473ffc_click_27a1(fx.self, &fx.w, &fx.host); break;
    case 5: m48e851_click_27b8_27b9(fx.self, &fx.w); break;
    case 6: m45e587_click_27ec_27ef(fx.self, &fx.w, &fx.host); break;
    case 7: m48ab49_click_2756_2757(fx.self, &fx.w, &fx.host); break;
    case 8: m4ab899_click_27ce_27d0(fx.self, &fx.w, &fx.host); break;
    case 9: m4574e4_click_27bc_27be(fx.self, &fx.w, &fx.host); break;
    case 10: m47a03c_click_279c_279d(fx.self, &fx.w, &fx.host); break;
    case 11: m4b2a9e_click_2792_2793(fx.self, &fx.w, &fx.host); break;
    default: break;
    }
}

static void set_gate(const Gate *g, int pass, int variant)
{
    static const uint32_t z32_fail[] = {1, 0x100, 0x10000, 0x01000000, 0x80000000};
    static const uint32_t wz_fail[] = {1, 0x8000, 0xffff, 0x0100};
    switch (g->kind) {
    case NZ32: set32(fx.self, g->off, pass ? 0x01000000u : 0); break;
    case Z32: set32(fx.self, g->off, pass ? 0 : z32_fail[variant % 5]); break;
    case NZ8: fx.self[g->off] = pass ? 0x80 : 0; break;
    case Z8: fx.self[g->off] = pass ? 0 : (uint8_t[]){1, 0x80, 0xff}[variant % 3]; break;
    case WEQ: set16(fx.self, g->off, (uint16_t)(pass ? g->val : (uint16_t[]){(uint16_t)(g->val ^ 1), (uint16_t)(g->val + 0x100), (uint16_t)(g->val ^ 0x8000)}[variant % 3])); break;
    case WZ: set16(fx.self, g->off, pass ? 0 : (uint16_t)wz_fail[variant % 4]); break;
    case NE32: set32(fx.self, g->off, pass ? 0x10au : g->val); break;
    default: break;
    }
}

/* the passing fixture of function f for the selector sel and the record index idx (2 or -1): every guard passes, the target record is in
 * state 1 (the others in state 0), the object of the target record is filled with 0x5c, that of the others with 0x11 */
static void setup(int f, uint32_t sel, int idx)
{
    int i, k;
    memset(fx.self, 0xA5, sizeof fx.self);
    memset(fx.obj, 0x5c, sizeof fx.obj);
    memset(fx.decoy, 0x11, sizeof fx.decoy);
    memset(fx.obj18, 0x22, sizeof fx.obj18);
    memset(fx.tab, 0xCC, sizeof fx.tab);
    for (i = -1; i <= 4; i++) {
        set32(fx.tab, (size_t)(i + 1) * REC, i == idx ? OBJ_VA : DECOY_VA);
        set32(fx.tab, (size_t)(i + 1) * REC + 0x4d, i == idx ? 1u : 0u);
    }
    memset(&fx.w, 0, sizeof fx.w);
    fx.w.records_5bb5e5 = fx.tab + REC;
    fx.w.value_5c39e5 = sel;
    fx.w.value_5bb1ca = 0x100;
    fx.w.bytes_54e364 = T[0];
    fx.w.bytes_550fb8 = T[1];
    fx.w.bytes_550fc4 = T[2];
    fx.w.bytes_54a3a8 = T[3];
    fx.w.bytes_54cb8c = T[4];
    fx.w.bytes_551764 = T[5];
    fx.w.bytes_551770 = T[6];
    memset(&fx.host, 0, sizeof fx.host);
    fx.host.call = host_call;
    fx.host.resolve = host_resolve;
    fx.host.tick = host_tick;
    set16(fx.self, S[f].idx_off, (uint16_t)(int16_t)idx);
    for (k = 0; k < S[f].ngates; k++) set_gate(&S[f].gates[k], 1, 0);
    g_tick = 1000;
    g_ret_4e26fc = 0;
    g_ret_4f6334 = 0;
}

static uint8_t xs[SELF_SZ], xt[TAB_SZ];
static uint8_t mk_self[8][SELF_SZ], mk_tab[8][TAB_SZ];
static uint8_t obj_before[0x1000];

static void begin(void)
{
    memcpy(xs, fx.self, SELF_SZ);
    memcpy(xt, fx.tab, TAB_SZ);
    memcpy(obj_before, fx.obj, sizeof obj_before);
}
static void mark(int k)
{
    memcpy(mk_self[k], xs, SELF_SZ);
    memcpy(mk_tab[k], xt, TAB_SZ);
}
#define X32(o, v) set32(xs, (o), (v))
#define X16(o, v) set16(xs, (o), (v))
#define X8(o, v) (xs[(o)] = (v))
static void x_state2(int f, int idx) { (void)f; set32(xt, (size_t)(idx + 1) * REC + 0x4d, 2); }
static void check_mem(void)
{
    CK(memcmp(fx.self, xs, SELF_SZ) == 0);
    CK(memcmp(fx.tab, xt, TAB_SZ) == 0);
    CK(memcmp(fx.obj, obj_before, sizeof obj_before) == 0);
}
/* call k of the log: callee, this, argument count, and the object / record table as they were at the call (the marked copy) */
static void check_call(int k, uint32_t callee, uintptr_t this_ptr, int nargs, int snap)
{
    CK(k < L.n);
    if (k >= L.n) return;
    CK(L.c[k].callee == callee);
    CK(L.c[k].this_ptr == this_ptr);
    CK(L.c[k].nargs == nargs);
    if (snap >= 0) {
        CK(memcmp(L.c[k].snap_self, mk_self[snap], SELF_SZ) == 0);
        CK(memcmp(L.c[k].snap_tab, mk_tab[snap], TAB_SZ) == 0);
    }
}
static void check_arg(int k, int i, uintptr_t v, uintptr_t mask)
{
    if (k < L.n) CK((L.c[k].a[i] & mask) == (v & mask));
}

/* the guard matrix of function f */
static void matrix(int f)
{
    int k, v, s, idx;
    static const int idxs[2] = {2, -1};
    for (idx = 0; idx < 2; idx++)
        for (k = -1; k < S[f].ngates; k++)       /* k = -1: the record state fails */
            for (v = 0; v < (k < 0 ? 6 : 5); v++)
                for (s = 0; s <= S[f].nsels; s++) {
                    uint32_t sel = s < S[f].nsels ? S[f].sels[s] : 0x2711;
                    setup(f, sel, idxs[idx]);
                    if (k < 0) {
                        int i;
                        for (i = -1; i <= 4; i++)    /* the target fails, the decoys would pass */
                            set32(fx.tab, (size_t)(i + 1) * REC + 0x4d, i == idxs[idx] ? (uint32_t[]){0, 2, 3, 0xffffffffu, 0x101, 0x10001}[v] : 1u);
                    } else {
                        set_gate(&S[f].gates[k], 0, v);
                    }
                    begin();
                    if (S[f].stores_76) X32(0x76, OBJ_VA);
                    run(f);
                    check_mem();
                    CK(L.n == 0);
                }
    /* a selector that no arm handles, every guard passing: nothing changes (0x4b2a9e stores the word copy) */
    if (f != 11) {
        setup(f, 0x2711, 2);
        begin();
        if (S[f].stores_76) X32(0x76, OBJ_VA);
        run(f);
        check_mem();
        CK(L.n == 0 || (f == 4 && L.n == 1));
    }
}

/* nine bytes at obj+off: equal to the table (variant -1), or different at byte `variant` (0..8), or different only at byte 9 */
static void set_nine(size_t off, const uint8_t *table, int variant)
{
    memcpy(fx.obj + off, table, 9);
    fx.obj[off + 9] = 0x5c;
    if (variant >= 0 && variant <= 9) fx.obj[off + (size_t)variant] ^= 0x40;
}

/* ---- the arms ---------------------------------------------------------------------------------------------------------------- */

static void arms_4a1efd(int idx)
{
    setup(0, 0x2760, idx);
    begin();
    X8(0x4b, 1);
    X32(0x4c, 3);
    run(0);
    check_mem();
    CK(L.n == 0);
}

static void arms_4ba4f2(int idx)
{
    static const int ns[] = {0, 3, -1};
    static const uint32_t ticks[] = {1000, 0xfffffff0u, 0x7fffffff};
    int i;
    for (i = 0; i < 3; i++) {
        int n = ns[i];
        setup(1, 0x276a, idx);
        set32(fx.self, 0x2d4, (uint32_t)n);
        set32(fx.self, 0x18, OBJ18_VA);
        set32(fx.obj18, 0x8ec, 0x20);
        g_tick = ticks[i];
        begin();
        X32((size_t)(0x24 + 8 * n), 1);
        mark(0);
        X32((size_t)(0x28 + 8 * n), ticks[i] + 0x20u);
        mark(1);
        run(1);
        check_mem();
        CK(L.n == 2);
        check_call(0, TICK_ID, 0, 0, 0);
        check_call(1, 0x4fb2e3, 0x5c3a67, 1, 1);
        check_arg(1, 0, 0x17, 0xffffffffu);
    }
}

static void arms_46957d(int idx)
{
    setup(2, 0x272e, idx);
    begin();
    X32(0x158, 0);
    X32(0x54a, 1);
    run(2);
    check_mem();
    CK(L.n == 0);
}

static void arms_4b45ed(int idx)
{
    setup(3, 0x2739, idx);
    begin();
    X32(0x77e, 1);
    x_state2(3, idx);
    run(3);
    check_mem();
    CK(L.n == 0);
}

static void arms_473ffc(int idx)
{
    static const uint32_t rets[] = {0, 1, 0x100, 0x80000000u};
    int r;
    for (r = 0; r < 4; r++) {
        setup(4, 0x27a1, idx);
        g_ret_4e26fc = rets[r];
        begin();
        X32(0x76, OBJ_VA);
        mark(0);
        if (rets[r] == 0) {
            X32(0x7e, 1);
            x_state2(4, idx);
        }
        run(4);
        check_mem();
        CK(L.n == 1);
        check_call(0, 0x4e26fc, (uintptr_t)(fx.self + 0x1a6), 0, 0);
    }
    /* the call is made whatever the selector, then a non-matching selector stops: only [+0x76] changes */
    setup(4, 0x2711, idx);
    begin();
    X32(0x76, OBJ_VA);
    run(4);
    check_mem();
    CK(L.n == 1);
}

static void arms_48e851(int idx)
{
    static const int items[] = {3, -1};
    int i, kind;
    setup(5, 0x27b9, idx);
    begin();
    X8(0x451, 1);
    X32(0x452, 8);
    run(5);
    check_mem();
    CK(L.n == 0);
    for (i = 0; i < 2; i++)
        for (kind = 0; kind < 3; kind++) {   /* 0: "AB", 1: empty with a later non-zero byte, 2: "A" */
            size_t at = (size_t)(0x200 + 0x11 * items[i]);
            setup(5, 0x27b8, idx);
            set16(fx.self, 0x3fe, (uint16_t)(int16_t)items[i]);
            set16(fx.self, 0x431, 0x8001);
            fx.self[at] = kind == 1 ? 0 : 'A';
            fx.self[at + 1] = kind == 0 ? 'B' : (kind == 1 ? 'C' : 0);
            fx.self[at + 2] = 0;
            begin();
            if (kind != 1) {
                memset(xs + at, 0, 17);
            }
            X16(0x3fe, 0x8001);
            run(5);
            check_mem();
            CK(L.n == 0);
        }
}

static void arms_45e587(int idx)
{
    static const uint32_t dw[] = {0x1234ffffu, 0xfffff800u};
    static const uint32_t sum[] = {0x12350ba2u, 0x3a3u};
    int i;
    setup(6, 0x27ef, idx);
    begin();
    X8(0x39d, 1);
    x_state2(6, idx);
    run(6);
    check_mem();
    CK(L.n == 0);
    setup(6, 0x27ec, idx);
    begin();
    X32(0x39e, 5);
    run(6);
    check_mem();
    CK(L.n == 0);
    for (i = 0; i < 2; i++) {
        setup(6, 0x27ed, idx);
        set32(fx.self, 0x31d, dw[i]);
        begin();
        mark(0);
        X8(0x299, 1);
        X8(0x298, 1);
        X32(0x3a2, 5);
        run(6);
        check_mem();
        CK(L.n == 1);
        check_call(0, 0x45e6bd, (uintptr_t)fx.self, 3, 0);
        check_arg(0, 0, sum[i], 0xffffffffu);
        check_arg(0, 1, (uintptr_t)(fx.self + 0x326), ~(uintptr_t)0);
        check_arg(0, 2, 1, 0xffffu);
    }
}

/* the common tail of 0x48ab49, 0x47a03c, 0x4574e4: the nine-byte test (flag w, variant v) and the 0x4f6334 / 0x4fb2e3 calls that follow.
 * `first` is the index of the first of those calls in the log, `word` the word that is announced, `snap` the marked state at the call. */
static int announce_expected(uint32_t flag, int variant) { return flag != 0 && variant >= 0 && variant <= 8; }

static void arms_48ab49(int idx)
{
    int flag, v, r;
    setup(7, 0x2757, idx);
    begin();
    X8(0x1ae, 1);
    x_state2(7, idx);
    run(7);
    check_mem();
    CK(L.n == 0);
    for (flag = 0; flag < 2; flag++)
        for (v = -1; v <= 9; v++)
            for (r = 0; r < 2; r++) {
                int ann;
                setup(7, 0x2756, idx);
                fx.w.value_5bb1ca = flag ? 0x100u : 0;
                g_tick = r ? 0x7fffffffu : 1000;
                g_ret_4f6334 = r ? 5u : 0u;
                set16(fx.obj, 0x3a6, 0xfffe);
                set16(fx.obj, 0x365, 0xfff0);
                set_nine(0x344, T[0], v);
                begin();
                X32(0x44, 1);
                X16(0x48, get16(fx.self, 0x1b0));
                mark(0);
                X32(0x4a, g_tick - 2u);
                X32(0x4e, 0);
                mark(1);
                run(7);
                check_mem();
                ann = announce_expected(flag ? 0x100u : 0, v);
                CK(L.n == 1 + (ann ? (r ? 1 : 2) : 0));
                check_call(0, TICK_ID, 0, 0, 0);
                if (ann) {
                    check_call(1, 0x4f6334, 0x5cf1eb, 1, 1);
                    check_arg(1, 0, 0xfffffff0u, 0xffffffffu);
                    if (!r) {
                        check_call(2, 0x4fb2e3, 0x5c3a67, 1, 1);
                        check_arg(2, 0, 0xfff0, 0xffffu);
                    }
                }
            }
}

static void arms_4ab899(int idx)
{
    int flag, v;
    setup(8, 0x27d0, idx);
    begin();
    X8(0x58, 1);
    x_state2(8, idx);
    run(8);
    check_mem();
    CK(L.n == 0);
    for (flag = 0; flag < 2; flag++)
        for (v = -1; v <= 9; v++) {
            int ann = announce_expected(flag ? 0x100u : 0, v);
            /* 0x27ce */
            setup(8, 0x27ce, idx);
            fx.w.value_5bb1ca = flag ? 0x100u : 0;
            g_tick = 0xffffff40u;
            set16(fx.obj, 0xad8, 0x8123);
            set_nine(0xab7, T[1], v);
            begin();
            X32(0x24, 1);
            X16(0x28, 0x27ce);
            mark(0);
            X32(0x2a, 0xffffff40u + 0xfa);
            X32(0x2e, 1);
            mark(1);
            run(8);
            check_mem();
            CK(L.n == 1 + ann);
            check_call(0, TICK_ID, 0, 0, 0);
            if (ann) {
                check_call(1, 0x4fb2e3, 0x5c3a67, 1, 1);
                check_arg(1, 0, 0x8123, 0xffffu);
            }
            /* 0x27cf */
            setup(8, 0x27cf, idx);
            fx.w.value_5bb1ca = flag ? 0x100u : 0;
            set16(fx.obj, 0xb3a, 0x7123);
            set_nine(0xb19, T[2], v);
            begin();
            mark(0);
            X32(0x5e, 2);
            X8(0x3a, 1);
            run(8);
            check_mem();
            CK(L.n == ann);
            if (ann) {
                check_call(0, 0x4fb2e3, 0x5c3a67, 1, 0);
                check_arg(0, 0, 0x7123, 0xffffu);
            }
        }
}

static void arms_4574e4(int idx)
{
    static const int items[] = {2, -1, 0};
    int i, flag, v, r;
    setup(9, 0x27bd, idx);
    begin();
    X32(0x3a, 1);
    x_state2(9, idx);
    run(9);
    check_mem();
    CK(L.n == 0);
    setup(9, 0x27be, idx);
    set16(fx.self, 0x42, 0x8765);
    begin();
    X16(0x2a, 0x8765);
    run(9);
    check_mem();
    CK(L.n == 0);
    for (i = 0; i < 3; i++)
        for (flag = 0; flag < 2; flag++)
            for (v = -1; v <= 9; v += (i == 0 ? 1 : 5))
                for (r = 0; r < 2; r++) {
                    int ann = announce_expected(flag ? 0x100u : 0, v);
                    size_t base = (size_t)(items[i] * 0x31);
                    setup(9, 0x27bc, idx);
                    fx.w.value_5bb1ca = flag ? 0x100u : 0;
                    g_tick = 0xffffff40u;
                    g_ret_4f6334 = r ? 1u : 0u;
                    set16(fx.self, 0x42, (uint16_t)(int16_t)items[i]);
                    set16(fx.obj, base + 0x1b8, 0x8abc);
                    set_nine(base + 0x197, T[3], v);
                    begin();
                    X32(0x2c, 1);
                    X16(0x30, (uint16_t)(int16_t)items[i]);
                    mark(0);
                    X32(0x32, 0xffffff40u + 0xfa);
                    X32(0x36, 1);
                    mark(1);
                    run(9);
                    check_mem();
                    CK(L.n == 1 + (ann ? (r ? 1 : 2) : 0));
                    check_call(0, TICK_ID, 0, 0, 0);
                    if (ann) {
                        check_call(1, 0x4f6334, 0x5cf1eb, 1, 1);
                        check_arg(1, 0, 0xffff8abcu, 0xffffffffu);
                        if (!r) {
                            check_call(2, 0x4fb2e3, 0x5c3a67, 1, 1);
                            check_arg(2, 0, 0x8abc, 0xffffu);
                        }
                    }
                }
}

static void arms_47a03c(int idx)
{
    int flag, v, r;
    setup(10, 0x279d, idx);
    begin();
    X32(0x157e, 1);
    x_state2(10, idx);
    run(10);
    check_mem();
    CK(L.n == 0);
    setup(10, 0x279c, idx);   /* the word [+0x159a] is zero: nothing at all */
    set16(fx.self, 0x159a, 0);
    begin();
    run(10);
    check_mem();
    CK(L.n == 0);
    for (flag = 0; flag < 2; flag++)
        for (v = -1; v <= 9; v++)
            for (r = 0; r < 2; r++) {
                int ann = announce_expected(flag ? 0x100u : 0, v);
                setup(10, 0x279c, idx);
                fx.w.value_5bb1ca = flag ? 0x100u : 0;
                g_tick = 5000;
                g_ret_4f6334 = r ? 0x10000u : 0u;
                set16(fx.self, 0x159a, 0x8000);
                set16(fx.obj, 0x216, 0x7ffe);
                set_nine(0x1f5, T[4], v);
                begin();
                X32(0x1528, 1);
                X16(0x152c, 0x8000);
                mark(0);
                X32(0x152e, 5000 + 0xfa);
                X32(0x1532, 1);
                mark(1);
                run(10);
                check_mem();
                CK(L.n == 1 + (ann ? (r ? 1 : 2) : 0));
                check_call(0, TICK_ID, 0, 0, 0);
                if (ann) {
                    check_call(1, 0x4f6334, 0x5cf1eb, 1, 1);
                    check_arg(1, 0, 0x7ffe, 0xffffffffu);
                    if (!r) {
                        check_call(2, 0x4fb2e3, 0x5c3a67, 1, 1);
                        check_arg(2, 0, 0x7ffe, 0xffffu);
                    }
                }
            }
}

static void arms_4b2a9e(int idx)
{
    int flag, v, w;
    static const uint16_t w1531[] = {0, 1, 0x8000, 0x0100};
    for (w = 0; w < 4; w++) {
        setup(11, 0x2793, idx);
        set16(fx.self, 0x1531, w1531[w]);
        begin();
        X32(0x1519, 1);
        x_state2(11, idx);
        X16(0x1535, w1531[w]);
        run(11);
        check_mem();
        CK(L.n == 0);
    }
    for (flag = 0; flag < 2; flag++)
        for (v = -1; v <= 9; v++)
            for (w = 0; w < 4; w++) {
                int ann = announce_expected(flag ? 0x100u : 0, v);
                /* 0x2792 */
                setup(11, 0x2792, idx);
                fx.w.value_5bb1ca = flag ? 0x100u : 0;
                g_tick = 0xfffffe00u;
                set16(fx.self, 0x1531, w1531[w]);
                set16(fx.obj, 0x2f7, 0x6543);
                set_nine(0x2d6, T[5], v);
                begin();
                mark(0);
                mark(1);
                X32(0x1537, 0xfffffe00u + 0x1f4);
                X8(0x1510, 1);
                X32(0x24, 3);
                X16(0x1535, w1531[w]);
                run(11);
                check_mem();
                CK(L.n == 1 + 2 * ann);
                if (ann) {
                    check_call(0, 0x4fb77a, 0x5c3a67, 1, 0);
                    check_arg(0, 0, OBJ_VA + 0x2d6u, 0xffffffffu);
                    check_call(1, 0x4fb2e3, 0x5c3a67, 1, 1);
                    check_arg(1, 0, 0x6543, 0xffffu);
                }
                check_call(2 * ann, TICK_ID, 0, 0, 0);
                /* any other event: the word [+0x1531] non-zero sets [+0x24] = 2 and may announce [rec + 0x295] */
                setup(11, 0x2711, idx);
                fx.w.value_5bb1ca = flag ? 0x100u : 0;
                set16(fx.self, 0x1531, w1531[w]);
                set16(fx.obj, 0x295, 0x6123);
                set_nine(0x274, T[6], v);
                begin();
                if (w1531[w] != 0) X32(0x24, 2);
                mark(0);
                X16(0x1535, w1531[w]);
                run(11);
                check_mem();
                CK(L.n == (w1531[w] != 0 ? ann : 0));
                if (w1531[w] != 0 && ann) {
                    check_call(0, 0x4fb2e3, 0x5c3a67, 1, 0);
                    check_arg(0, 0, 0x6123, 0xffffu);
                }
            }
}


/* a bounded random sweep for the sanitisers: every function on 3000 random objects, record tables and selectors, with the guards passing or
 * failing at random and the index words that the original does not bound (the record index, [+0x2d4] of 0x4ba4f2, the item words of 0x48e851 and
 * 0x4574e4) kept inside the fixture. It checks no value, only that nothing reads or writes outside the buffers or has undefined behaviour. */
static uint32_t g_rng = 0x1234567u;
static uint32_t rnd(void)
{
    g_rng ^= g_rng << 13;
    g_rng ^= g_rng >> 17;
    g_rng ^= g_rng << 5;
    return g_rng;
}

static void sweep(int f)
{
    int it, k, i;
    for (it = 0; it < 3000; it++) {
        int idx = (int)(rnd() % 6) - 1;
        uint32_t sel = rnd() % 3 == 0 ? rnd() : (S[f].nsels > 0 ? S[f].sels[rnd() % (uint32_t)S[f].nsels] : 0);
        setup(f, sel, idx);
        for (i = 0; i < 40; i++) fx.self[rnd() % SELF_SZ] = (uint8_t)rnd();
        for (i = 0; i < 20; i++) fx.obj[rnd() % sizeof fx.obj] = (uint8_t)rnd();
        for (k = 0; k < S[f].ngates; k++) set_gate(&S[f].gates[k], (int)(rnd() % 4 != 0), (int)(rnd() % 5));
        set16(fx.self, S[f].idx_off, (uint16_t)(int16_t)idx);
        if (rnd() % 8 == 0) set32(fx.tab, (size_t)(idx + 1) * REC + 0x4d, rnd());
        fx.w.value_5bb1ca = rnd() % 2 ? 0 : rnd();
        g_ret_4e26fc = rnd() % 3 ? 0 : rnd();
        g_ret_4f6334 = rnd() % 3 ? 0 : rnd();
        g_tick = rnd();
        if (f == 1) {
            set32(fx.self, 0x2d4, (uint32_t)((int)(rnd() % 43) - 2));
            set32(fx.self, 0x18, OBJ18_VA);
        }
        if (f == 5) set16(fx.self, 0x3fe, (uint16_t)(int16_t)((int)(rnd() % 24) - 3));
        if (f == 9) set16(fx.self, 0x42, (uint16_t)(int16_t)((int)(rnd() % 24) - 3));
        run(f);
    }
}

typedef void (*Arms)(int);
static const Arms ARMS[N_FUNCS] = {arms_4a1efd, arms_4ba4f2, arms_46957d, arms_4b45ed, arms_473ffc, arms_48e851,
                                   arms_45e587, arms_48ab49, arms_4ab899, arms_4574e4, arms_47a03c, arms_4b2a9e};

int main(void)
{
    int f, failures = 0;
    for (f = 0; f < N_FUNCS; f++) {
        g_failed = 0;
        g_msg[0] = 0;
        matrix(f);
        ARMS[f](2);
        ARMS[f](-1);
        sweep(f);
        if (g_failed) {
            printf("FAIL %s: %s\n", S[f].name, g_msg);
            failures++;
        } else {
            printf("PASS %s\n", S[f].name);
        }
    }
    return failures;
}
