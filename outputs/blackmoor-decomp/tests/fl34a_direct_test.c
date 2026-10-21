/* FL-34 (batch a) direct tests of the 21 table-toggle handlers of GAME.EXE in src/original_methods_fl34a.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE (each row's base read from its own cmp / two stores), not from running the
 * native code; tests/test_fl34a_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl34a.h"

#include <stdio.h>
#include <stdlib.h>
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

static uint8_t g_self[0x400];
static uint8_t g_tbl[0x200];
#define TBL_ZERO 0x40          /* byte offset of the dword index 0 of the original address 0x5e60da in g_tbl (room for negative indices) */
static Fl34aWorld g_w;
static Fl18Host g_host;
#define SELFP ((uintptr_t)g_self)

static void set32(uint8_t *b, size_t off, uint32_t v) { memcpy(b + off, &v, 4); }
static uint32_t get32(const uint8_t *b, size_t off) { uint32_t v; memcpy(&v, b + off, 4); return v; }

#define MAXCALL 16
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uint8_t tbl[sizeof g_tbl];     /* the table at the call */
    } c[MAXCALL];
} L;

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int i = L.n;
    (void)ctx;
    (void)args;
    if (L.n < MAXCALL) {
        L.c[i].callee = callee;
        L.c[i].this_ptr = this_ptr;
        L.c[i].nargs = nargs;
        memcpy(L.c[i].tbl, g_tbl, sizeof g_tbl);
    }
    L.n++;
    return 0;
}

static void setup(void)
{
    size_t i;
    for (i = 0; i < sizeof g_self; i++) g_self[i] = (uint8_t)(i * 7 + 3);
    memset(g_tbl, 0x5a, sizeof g_tbl);
    memset(&g_w, 0, sizeof g_w);
    g_w.table_5e60da = g_tbl + TBL_ZERO;
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.context = NULL;
    L.n = 0;
}

/* ---- the 21 table toggles: `delta` is the row's table base minus 0x5e60da, read from the row's own disassembly --------------------------------------------- */
typedef void (*ToggleFn)(uint8_t *, Fl34aWorld *, const Fl18Host *);

static void check_toggle(ToggleFn fn, ptrdiff_t delta)
{
    static const int32_t idx[] = {0, 3, -2, 0x20};
    static const uint32_t first[] = {1, 0, 0x100, 0x10001u, 0x01000001u, 0xffffffffu, 2};
    uint8_t want[sizeof g_tbl];
    uint8_t self_before[sizeof g_self];
    int i, j;
    for (i = 0; i < 4; i++)
        for (j = 0; j < 7; j++) {
            size_t at = (size_t)((ptrdiff_t)TBL_ZERO + (ptrdiff_t)idx[i] * 4 + delta);
            setup();
            set32(g_self, 0x5c, (uint32_t)idx[i]);
            set32(g_tbl, at, first[j]);
            memcpy(want, g_tbl, sizeof want);
            memcpy(self_before, g_self, sizeof self_before);
            set32(want, at, first[j] == 1 ? 0 : 1);        /* the dword compare: only exactly 1 becomes 0, everything else (also 0x100, 0x10001) becomes 1 */
            fn(g_self, &g_w, &g_host);
            CK(memcmp(g_tbl, want, sizeof want) == 0);      /* only that one dword changed */
            CK(L.n == 1 && L.c[0].callee == 0x40236a && L.c[0].this_ptr == SELFP && L.c[0].nargs == 0);
            CK(memcmp(L.c[0].tbl, want, sizeof want) == 0);  /* the store is done before the call */
            CK(memcmp(g_self, self_before, sizeof g_self) == 0);
            CK(g_w.table_5e60da == g_tbl + TBL_ZERO);
        }
    /* the index is a signed dword: -1 reaches the dword below index 0, not 0x3fffffffc bytes above */
    setup();
    set32(g_self, 0x5c, 0xffffffffu);
    set32(g_tbl, (size_t)((ptrdiff_t)TBL_ZERO - 4 + delta), 1);
    fn(g_self, &g_w, &g_host);
    CK(get32(g_tbl, (size_t)((ptrdiff_t)TBL_ZERO - 4 + delta)) == 0);
}
static void test_m402962_toggle_5e60d6(void) { check_toggle(m402962_toggle_5e60d6, 0x5e60d6 - 0x5e60da); }
static void test_m402a7e_toggle_5e60e6(void) { check_toggle(m402a7e_toggle_5e60e6, 0x5e60e6 - 0x5e60da); }
static void test_m402ac5_toggle_5e60ea(void) { check_toggle(m402ac5_toggle_5e60ea, 0x5e60ea - 0x5e60da); }
static void test_m402b0c_toggle_5e60ee(void) { check_toggle(m402b0c_toggle_5e60ee, 0x5e60ee - 0x5e60da); }
static void test_m402b53_toggle_5e60f2(void) { check_toggle(m402b53_toggle_5e60f2, 0x5e60f2 - 0x5e60da); }
static void test_m402b9a_toggle_5e60f6(void) { check_toggle(m402b9a_toggle_5e60f6, 0x5e60f6 - 0x5e60da); }
static void test_m402be1_toggle_5e60fa(void) { check_toggle(m402be1_toggle_5e60fa, 0x5e60fa - 0x5e60da); }
static void test_m402c28_toggle_5e60fe(void) { check_toggle(m402c28_toggle_5e60fe, 0x5e60fe - 0x5e60da); }
static void test_m402c6f_toggle_5e6102(void) { check_toggle(m402c6f_toggle_5e6102, 0x5e6102 - 0x5e60da); }
static void test_m402cb6_toggle_5e6106(void) { check_toggle(m402cb6_toggle_5e6106, 0x5e6106 - 0x5e60da); }
static void test_m402cfd_toggle_5e610a(void) { check_toggle(m402cfd_toggle_5e610a, 0x5e610a - 0x5e60da); }
static void test_m402d44_toggle_5e610e(void) { check_toggle(m402d44_toggle_5e610e, 0x5e610e - 0x5e60da); }
static void test_m402d8b_toggle_5e6112(void) { check_toggle(m402d8b_toggle_5e6112, 0x5e6112 - 0x5e60da); }
static void test_m402dd2_toggle_5e6116(void) { check_toggle(m402dd2_toggle_5e6116, 0x5e6116 - 0x5e60da); }
static void test_m402e19_toggle_5e611a(void) { check_toggle(m402e19_toggle_5e611a, 0x5e611a - 0x5e60da); }
static void test_m402e60_toggle_5e611e(void) { check_toggle(m402e60_toggle_5e611e, 0x5e611e - 0x5e60da); }
static void test_m402ea7_toggle_5e6122(void) { check_toggle(m402ea7_toggle_5e6122, 0x5e6122 - 0x5e60da); }
static void test_m402eee_toggle_5e6126(void) { check_toggle(m402eee_toggle_5e6126, 0x5e6126 - 0x5e60da); }
static void test_m402f35_toggle_5e612a(void) { check_toggle(m402f35_toggle_5e612a, 0x5e612a - 0x5e60da); }
static void test_m402f7c_toggle_5e612e(void) { check_toggle(m402f7c_toggle_5e612e, 0x5e612e - 0x5e60da); }
static void test_m402fc3_toggle_5e6132(void) { check_toggle(m402fc3_toggle_5e6132, 0x5e6132 - 0x5e60da); }

/* CASES-END */

/* ---- bounded sweep ------------------------------------------------------------------------------------------------------------- */
static void test_sweep_bounded(void)
{
    unsigned seed = 4242;
    int n, i;
    for (n = 0; n < 300 && !g_failed; n++) {
        setup();
        for (i = 0; i < (int)sizeof g_self; i++) {
            seed = seed * 1103515245u + 12345u;
            g_self[i] = (uint8_t)(seed >> 16);
        }
        seed = seed * 1103515245u + 12345u;
        for (i = 0; i < (int)sizeof g_tbl; i++) g_tbl[i] = (uint8_t)(seed >> (i & 15));
        /* the table index is kept inside g_tbl: -12 .. 19 dwords (the largest row offset, 88 bytes, and the dword itself stay inside as well) */
        set32(g_self, 0x5c, (uint32_t)((int)(seed % 0x20) - 12));
        m402962_toggle_5e60d6(g_self, &g_w, &g_host);
        m402a7e_toggle_5e60e6(g_self, &g_w, &g_host);
        m402ac5_toggle_5e60ea(g_self, &g_w, &g_host);
        m402b0c_toggle_5e60ee(g_self, &g_w, &g_host);
        m402b53_toggle_5e60f2(g_self, &g_w, &g_host);
        m402b9a_toggle_5e60f6(g_self, &g_w, &g_host);
        m402be1_toggle_5e60fa(g_self, &g_w, &g_host);
        m402c28_toggle_5e60fe(g_self, &g_w, &g_host);
        m402c6f_toggle_5e6102(g_self, &g_w, &g_host);
        m402cb6_toggle_5e6106(g_self, &g_w, &g_host);
        m402cfd_toggle_5e610a(g_self, &g_w, &g_host);
        m402d44_toggle_5e610e(g_self, &g_w, &g_host);
        m402d8b_toggle_5e6112(g_self, &g_w, &g_host);
        m402dd2_toggle_5e6116(g_self, &g_w, &g_host);
        m402e19_toggle_5e611a(g_self, &g_w, &g_host);
        m402e60_toggle_5e611e(g_self, &g_w, &g_host);
        m402ea7_toggle_5e6122(g_self, &g_w, &g_host);
        m402eee_toggle_5e6126(g_self, &g_w, &g_host);
        m402f35_toggle_5e612a(g_self, &g_w, &g_host);
        m402f7c_toggle_5e612e(g_self, &g_w, &g_host);
        m402fc3_toggle_5e6132(g_self, &g_w, &g_host);
        L.n = 0;
        /* SWEEP-END */
    }
}

#define RUN(fn)                                       \
    do {                                              \
        g_failed = 0;                                 \
        g_msg[0] = 0;                                 \
        fn();                                         \
        if (g_failed) {                               \
            printf("FAIL %s: %s\n", #fn, g_msg);      \
            failures++;                               \
        } else {                                      \
            printf("PASS %s\n", #fn);                 \
        }                                             \
    } while (0)

int main(void)
{
    int failures = 0;
    RUN(test_m402962_toggle_5e60d6);
    RUN(test_m402a7e_toggle_5e60e6);
    RUN(test_m402ac5_toggle_5e60ea);
    RUN(test_m402b0c_toggle_5e60ee);
    RUN(test_m402b53_toggle_5e60f2);
    RUN(test_m402b9a_toggle_5e60f6);
    RUN(test_m402be1_toggle_5e60fa);
    RUN(test_m402c28_toggle_5e60fe);
    RUN(test_m402c6f_toggle_5e6102);
    RUN(test_m402cb6_toggle_5e6106);
    RUN(test_m402cfd_toggle_5e610a);
    RUN(test_m402d44_toggle_5e610e);
    RUN(test_m402d8b_toggle_5e6112);
    RUN(test_m402dd2_toggle_5e6116);
    RUN(test_m402e19_toggle_5e611a);
    RUN(test_m402e60_toggle_5e611e);
    RUN(test_m402ea7_toggle_5e6122);
    RUN(test_m402eee_toggle_5e6126);
    RUN(test_m402f35_toggle_5e612a);
    RUN(test_m402f7c_toggle_5e612e);
    RUN(test_m402fc3_toggle_5e6132);
    /* RUN-END */
    RUN(test_sweep_bounded);
    return failures;
}
