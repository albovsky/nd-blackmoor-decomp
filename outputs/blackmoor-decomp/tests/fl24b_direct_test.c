/* FL-24 (batch b) direct tests of the handlers of GAME.EXE in src/original_methods_fl24b.c. Prints "PASS <name>" / "FAIL <name>: <msg>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the
 * disassembly of GAME.EXE, not from running the native code; tests/test_fl24b_differential.py additionally runs the original bytes on
 * generated fixtures.
 *
 * Every function is checked three ways: (1) a guard matrix (each guard of the chain failing in turn leaves the object, the record table
 * and the call log untouched), (2) each arm with the whole object, the record table and the globals compared with a hand-edited copy and
 * the ordered host calls with arguments and the state at the call, (3) the boundaries of signed words and dwords. A bounded random
 * sweep at the end only requires that nothing reads or writes outside the buffers (run it under ASan/UBSan). */
#include "../src/original_methods_fl24b.h"

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
#define BIG 0x1800

static void set32(uint8_t *o, size_t off, uint32_t v) { memcpy(o + off, &v, 4); }
static void set16(uint8_t *o, size_t off, uint16_t v) { memcpy(o + off, &v, 2); }
static uint16_t get16x(const uint8_t *o, size_t off)
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
    uint8_t obj[0x1000], decoy[0x1000], obj2[0x1000];
    Fl24bWorld w;
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
static uint32_t g_tick;
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

/* ---- FL24B-TESTS-BEGIN ----------------------------------------------------------------------------------------------------------- */

/* 0x4dad60: five dwords and two global bytes cleared, the import 0x52a498 called with 0x17, the result stored at [+0x14] and the pair
 * at [+0x20], [+0x24] chosen by it (non-zero: 2, 1; zero: 1, 2); then [+0x18] and [+0x1c] cleared. The result is a whole dword. */
static int test_m4dad60_init_swap_buttons(void)
{
    static const uint32_t rets[] = {0, 1, 0x100, 0x10000, 0x80000000u, 0xffffffffu};
    int i;
    g_failed = 0;
    g_msg[0] = 0;
    for (i = 0; i < 6; i++) {
        base(0, 2, 0x1e);
        fx.w.value_58321d = 0x77;
        fx.w.value_58321e = 0x88;
        g_ret_by[0].callee = 0x52a498;
        g_ret_by[0].value = rets[i];
        begin();
        X32(0xc, 0);
        X32(0x10, 0);
        X32(0, 0);
        X32(4, 0);
        X32(8, 0);
        X32(0x14, rets[i]);
        X32(0x20, rets[i] != 0 ? 2 : 1);
        X32(0x24, rets[i] != 0 ? 1 : 2);
        X32(0x18, 0);
        X32(0x1c, 0);
        m4dad60_init_swap_buttons(fx.self, &fx.w, &fx.host);
        check_mem();
        CK(fx.w.value_58321d == 0 && fx.w.value_58321e == 0);
        CK(L.n == 1);
        check_call(0, 0x52a498, 0, 1);
        check_arg(0, 0, 0x17, 0xffffffffu);
        /* at the call [+0xc], [+8] are already cleared; [+0x14], [+0x20], [+0x18] are not yet stored */
        CK(get32(L.c[0].snap_self, 0xc) == 0 && get32(L.c[0].snap_self, 8) == 0 && get32(L.c[0].snap_self, 0x14) == 0xA5A5A5A5u);
        CK(get32(L.c[0].snap_self, 0x20) == 0xA5A5A5A5u && get32(L.c[0].snap_self, 0x18) == 0xA5A5A5A5u);
    }
    if (g_failed) printf("FAIL test_m4dad60_init_swap_buttons: %s\n", g_msg);
    else printf("PASS test_m4dad60_init_swap_buttons\n");
    return g_failed;
}

/* 0x466073: gates [+0x49] != 0 (dword), byte [+0x4e] == 0, the state of the record of the signed word [+0x1e] == 1, then the selector. */
static void setup_466073(uint32_t sel, int idx, int sw)
{
    base(sel, idx, 0x1e);
    set32(fx.self, 0x49, 0x01000000u);
    fx.self[0x4e] = 0;
    set16(fx.self, 0x28, (uint16_t)sw);
    fx.w.value_5bb1ca = 0;
    fx.w.bytes_54b54c = consts[0];
    memcpy(consts[0], "ABCDEFGHI", 9);
}

/* the common tail: with the flag set, a copy (49 bytes of obj at `off`) whose first nine bytes differ from the constant at byte `diff`
 * (-1: equal) announces the word at copy+0x21 */
static void tail_466073(int sw, size_t off, int idx, int flag, int diff)
{
    setup_466073(0x27d2, idx, sw);
    set16(fx.self, 0x2c, 1);
    fx.self[0x3e] = 0;
    fx.w.value_5bb1ca = flag ? 0x100u : 0;
    memcpy(fx.obj + off, "ABCDEFGHI", 9);
    if (diff >= 0) fx.obj[off + (size_t)diff] ^= 0x40;
    fx.obj[off + 0x21] = 0x34;
    fx.obj[off + 0x22] = 0x92;
    fx.obj[off + 0x23] = 0xee;
    begin();
    if (sw == 1) { X8(0x3e, 1); X8(0x42, 1); }
    if (sw == 4) { X16(0x2c, 2); }
    if (sw == 2) { X16(0x2a, (uint16_t)(get16x(fx.self, 0x2a) - 1)); X8(0x3f, 1); }
    if (sw == 3) { X16(0x2a, (uint16_t)(get16x(fx.self, 0x2a) + 1)); X8(0x40, 1); }
    m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
    check_mem();
    if (flag && diff >= 0) {
        CK(L.n == 1);
        check_call(0, 0x4fb2e3, 0x5c3a67, 1);
        check_arg(0, 0, 0x9234, 0xffff);       /* the word at copy+0x21, not the byte after it */
    } else {
        CK(L.n == 0);
    }
}

static int test_m466073_click_27d2_27d3(void)
{
    static const int idxs[2] = {2, -1};
    static const int sws[] = {1, 2, 3, 4};
    static const uint32_t sels[] = {0x27d3, 0x27d2, 0x2711, 0};
    int ii, k, v, s, d, f;
    g_failed = 0;
    g_msg[0] = 0;
    for (ii = 0; ii < 2; ii++) {
        int idx = idxs[ii];
        /* the guard matrix: every guard failing in turn, every selector, no effect */
        for (s = 0; s < 4; s++)
            for (k = 0; k < 3; k++)
                for (v = 0; v < 6; v++) {
                    setup_466073(sels[s], idx, 1);
                    if (k == 0) set32(fx.self, 0x49, 0);
                    if (k == 1) fx.self[0x4e] = (uint8_t[]){1, 0x80, 0xff, 0x7f, 2, 0x55}[v];
                    if (k == 2) {
                        int i;
                        for (i = -1; i <= 4; i++)
                            set32(fx.tab, (size_t)(i + 1) * REC + 0x4d, i == idx ? (uint32_t[]){0, 2, 3, 0xffffffffu, 0x101, 0x10001}[v] : 1u);
                    }
                    fx.w.value_5bb1ca = 1;
                    begin();
                    m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
                    check_mem();
                    CK(L.n == 0);
                }
        /* a high-byte only [+0x49] (0x01000000) passes; an unrelated selector with every guard passing does nothing */
        setup_466073(0x2711, idx, 1);
        fx.w.value_5bb1ca = 1;
        begin();
        m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
        check_mem();
        CK(L.n == 0);
        /* 0x27d3: byte [+0x4d] = 1 and the state of the record 2 */
        setup_466073(0x27d3, idx, 1);
        fx.w.value_5bb1ca = 1;
        begin();
        X8(0x4d, 1);
        set32(xt, (size_t)(idx + 1) * REC + 0x4d, 2);
        m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
        check_mem();
        CK(L.n == 0);
        /* 0x27d2: out-of-range words fall to the tail with the local not written (nothing changes; flag clear: no call) */
        for (v = 0; v < 6; v++) {
            setup_466073(0x27d2, idx, (int[]){0, 5, -1, -32768, 0x7fff, 0x100}[v]);
            begin();
            m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
            check_mem();
            CK(L.n == 0);
        }
        /* the four arms, the flag clear and set, the nine-byte compare at every byte position and equal */
        for (s = 0; s < 4; s++) {
            size_t off = sws[s] == 1 ? 0x43e : sws[s] == 4 ? 0x46f : 0x40d;
            for (f = 0; f < 2; f++)
                for (d = -1; d < 9; d++) tail_466073(sws[s], off, idx, f, d);
        }
        /* word 1 toggles the byte [+0x3e] both ways; word 4 counts [+0x2c] up to 3 and then wraps with [+0x41] set */
        for (v = 0; v < 3; v++) {
            setup_466073(0x27d2, idx, 1);
            fx.self[0x3e] = (uint8_t[]){0, 1, 0x80}[v];
            begin();
            X8(0x3e, v == 0 ? 1 : 0);
            X8(0x42, 1);
            m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
            check_mem();
        }
        for (v = 0; v < 7; v++) {
            int16_t w2c = (int16_t[]){0, 2, 3, 4, -1, -32768, 0x7fff}[v];
            setup_466073(0x27d2, idx, 4);
            set16(fx.self, 0x2c, (uint16_t)w2c);
            begin();
            if (w2c < 3) X16(0x2c, (uint16_t)(w2c + 1));
            else { X8(0x41, 1); X16(0x2c, 0); }
            m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
            check_mem();
        }
        /* words 2 and 3 wrap [+0x2a] at the word boundaries */
        for (v = 0; v < 4; v++) {
            uint16_t w2a = (uint16_t[]){0, 0xffff, 0x8000, 0x7fff}[v];
            setup_466073(0x27d2, idx, 2);
            set16(fx.self, 0x2a, w2a);
            begin();
            X16(0x2a, (uint16_t)(w2a - 1));
            X8(0x3f, 1);
            m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
            check_mem();
            setup_466073(0x27d2, idx, 3);
            set16(fx.self, 0x2a, w2a);
            begin();
            X16(0x2a, (uint16_t)(w2a + 1));
            X8(0x40, 1);
            m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
            check_mem();
        }
    }
    /* the state of the call: at the call the object has all its stores done */
    setup_466073(0x27d2, 2, 4);
    fx.w.value_5bb1ca = 1;
    set16(fx.self, 0x2c, 9);
    memset(fx.obj + 0x46f, 'z', 9);
    m466073_click_27d2_27d3(fx.self, &fx.w, &fx.host);
    CK(L.n == 1 && L.c[0].snap_self[0x41] == 1 && L.c[0].snap_self[0x2c] == 0 && L.c[0].snap_self[0x2d] == 0);
    if (g_failed) printf("FAIL test_m466073_click_27d2_27d3: %s\n", g_msg);
    else printf("PASS test_m466073_click_27d2_27d3\n");
    return g_failed;
}

/* FL24B-TESTS-END */

int main(void)
{
    int failures = 0;
    failures += test_m4dad60_init_swap_buttons();
    failures += test_m466073_click_27d2_27d3();
    /* FL24B-MAIN-END */
    return failures;
}
