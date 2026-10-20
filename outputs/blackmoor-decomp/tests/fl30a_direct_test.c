/* FL-30 (batch a) direct tests of the methods of GAME.EXE in src/original_methods_fl30a.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl30a_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl30a.h"

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

/* host memory: region i lives at the original address RVA(i); region 0 is `self` */
#define RVA(i) (0x20000000u + 0x10000u * (uint32_t)(i))
#define RSZ 0x4000
static uint8_t g_r[8][RSZ];
static uint8_t g_tbl[0x8d * 0x20];
static Fl30aWorld g_w;
static Fl18Host g_host;
#define SELF g_r[0]

static __attribute__((unused)) void set32(uint8_t *b, size_t off, uint32_t v) { memcpy(b + off, &v, 4); }
static __attribute__((unused)) void set16(uint8_t *b, size_t off, uint16_t v) { memcpy(b + off, &v, 2); }
static uint32_t get32(const uint8_t *b, size_t off) { uint32_t v; memcpy(&v, b + off, 4); return v; }
static __attribute__((unused)) uint16_t get16(const uint8_t *b, size_t off) { uint16_t v; memcpy(&v, b + off, 2); return v; }

#define MAXCALL 64
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[6];
        uint8_t probe[16];       /* the first 16 bytes of region 4 at the call */
    } c[MAXCALL];
} L;
static struct {
    uint32_t callee, results[8];
    int n, used;
} S[8];
static int g_nscript;
static void script(uint32_t callee, int n, uint32_t r0, uint32_t r1, uint32_t r2, uint32_t r3)
{
    S[g_nscript].callee = callee;
    S[g_nscript].n = n;
    S[g_nscript].used = 0;
    S[g_nscript].results[0] = r0;
    S[g_nscript].results[1] = r1;
    S[g_nscript].results[2] = r2;
    S[g_nscript].results[3] = r3;
    g_nscript++;
}

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int k, i = L.n;
    uint32_t result = 0;
    (void)ctx;
    if (L.n < MAXCALL) {
        L.c[i].callee = callee;
        L.c[i].this_ptr = this_ptr;
        L.c[i].nargs = nargs;
        for (k = 0; k < nargs && k < 6; k++) L.c[i].a[k] = args[k];
        memcpy(L.c[i].probe, g_r[4], 16);
    }
    L.n++;
    for (k = 0; k < g_nscript; k++)
        if (S[k].callee == callee && S[k].n > 0) {
            result = S[k].results[S[k].used < S[k].n ? S[k].used : S[k].n - 1];
            S[k].used++;
        }
    return result;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (a >= RVA(0) && a < RVA(8)) {
        uint32_t i = (a - RVA(0)) >> 16, off = (a - RVA(0)) & 0xffff;
        if (off < RSZ) return g_r[i] + off;
    }
    return NULL;
}

static void setup(void)
{
    size_t b, i;
    for (i = 0; i < 8; i++)
        for (b = 0; b < RSZ; b++) g_r[i][b] = (uint8_t)(b * 7 + 3 + i);
    memset(g_tbl, 0, sizeof g_tbl);
    memset(&g_w, 0, sizeof g_w);
    g_w.table_5bb5e5 = g_tbl + 4 * 0x8d;
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    L.n = 0;
    g_nscript = 0;
}

static void ck_call(int line, int idx, uint32_t callee, uintptr_t this_ptr, int nargs, const uintptr_t *want)
{
    int k;
    if (g_failed) return;
    if (idx >= L.n || idx >= MAXCALL || L.c[idx].callee != callee || L.c[idx].this_ptr != this_ptr || L.c[idx].nargs != nargs) {
        g_failed = 1;
        snprintf(g_msg, sizeof g_msg, "line %d: call %d is not %x this %lx nargs %d (log has %d)", line, idx, (unsigned)callee, (unsigned long)this_ptr, nargs, L.n);
        return;
    }
    for (k = 0; k < nargs; k++)
        if (L.c[idx].a[k] != want[k]) {
            g_failed = 1;
            snprintf(g_msg, sizeof g_msg, "line %d: call %d arg %d is %lx, want %lx", line, idx, k, (unsigned long)L.c[idx].a[k], (unsigned long)want[k]);
            return;
        }
}
#define CKC(idx, callee, thisp, nargs, ...)                        \
    do {                                                           \
        const uintptr_t w_[] = {__VA_ARGS__};                      \
        ck_call(__LINE__, (idx), (callee), (thisp), (nargs), w_);  \
    } while (0)
#define CKC0(idx, callee, thisp) ck_call(__LINE__, (idx), (callee), (thisp), 0, NULL)
#define SELFP ((uintptr_t)SELF)

/* ---- 0x4f61e7 start_record ------------------------------------------------------------------------------------------------- */
#define VT 0x7e000900u
static void rec_setup(uint32_t index_base_add)
{
    setup();
    set32(SELF, 0x3ce, RVA(1) + index_base_add);
    set32(SELF, 0x3be, 0x77);
    set32(SELF, 0x3c2, 0x1111);
    set32(SELF, 0x3ca, 0x2222);
}
static void test_m4f61e7_start_record(void)
{
    uint8_t *rec = g_r[1] + 2 * 0x5bb;
    uint32_t rec_va = RVA(1) + 2 * 0x5bb;
    rec_setup(0);
    script(0x4f709c, 1, 0, 0, 0, 0);
    CK(m4f61e7_start_record(SELF, 2, &g_w, &g_host) == 0);                              /* the first callee fails */
    CK(get32(SELF, 0x3c2) == 0x3ea && get32(SELF, 0x3be) == 0 && get32(SELF, 0x3ca) == 0);
    CK(L.n == 1);
    CKC0(0, 0x4f709c, SELFP);
    rec_setup(0);
    script(0x4f709c, 1, 5, 0, 0, 0);
    set32(rec, 0x162, 0);
    set32(rec, 0x28f, RVA(2));
    CK(m4f61e7_start_record(SELF, 2, &g_w, &g_host) == 0);                              /* no [rec+0x162] */
    CK(get32(SELF, 0x3c2) == 0x3ef && get32(SELF, 0x3be) == 0 && get32(SELF, 0x3ca) == 0 && L.n == 1 && get32(rec, 0x287) != 1);
    rec_setup(0);
    script(0x4f709c, 1, 5, 0, 0, 0);
    set32(rec, 0x162, 0x10000);
    set32(rec, 0x28f, 0);
    CK(m4f61e7_start_record(SELF, 2, &g_w, &g_host) == 0);                              /* [rec+0x162] set, no [rec+0x28f] */
    CK(get32(SELF, 0x3c2) == 0x3ef && get32(SELF, 0x3be) == 0 && L.n == 1);
    /* success path: vtable entry result non-zero */
    rec_setup(0);
    script(0x4f709c, 1, 5, 0, 0, 0);
    script(VT, 1, 0x55, 0, 0, 0);
    set32(rec, 0x162, 0x10000);
    set32(rec, 0x28f, RVA(2));
    set32(g_r[2], 0, RVA(3));
    set32(g_r[3], 0x48, VT);
    CK(m4f61e7_start_record(SELF, 2, &g_w, &g_host) == 0);
    CK(get32(rec, 0x287) == 1 && get32(SELF, 0x3ca) == 0x55 && get32(SELF, 0x3c2) == 0x40b && get32(SELF, 0x3be) == 0);
    CK(L.n == 2);
    CKC0(0, 0x4f709c, SELFP);
    CKC(1, VT, RVA(3), 1, RVA(2));
    /* vtable entry result 0: debug off, then on (a negative word is non-zero too) */
    rec_setup(0);
    g_nscript = 0;
    script(0x4f709c, 1, 5, 0, 0, 0);
    script(VT, 1, 0, 0, 0, 0);
    set32(rec, 0x162, 1);
    set32(rec, 0x28f, RVA(2));
    set32(g_r[2], 0, RVA(3));
    set32(g_r[3], 0x48, VT);
    CK(m4f61e7_start_record(SELF, 2, &g_w, &g_host) == 1);
    CK(get32(SELF, 0x3ca) == 0 && get32(SELF, 0x3c2) == 0x3e8 && get32(SELF, 0x3be) == 0x77 && L.n == 2);
    L.n = 0;
    g_nscript = 0;
    script(0x4f709c, 1, 5, 0, 0, 0);
    script(VT, 1, 0, 0, 0, 0);
    g_w.word_63a4cd = (int16_t)0x8000;
    set32(SELF, 0x3c2, 0);
    CK(m4f61e7_start_record(SELF, 2, &g_w, &g_host) == 1);
    CK(L.n == 4);
    CKC(2, 0x50ca3e, 0, 4, 0x63888b, 0x55e7bc, 2, rec_va + 4);
    CKC(3, 0x44a2b7, 0, 1, 0x63888b);
    /* a result whose low word is 0 is still a non-zero dword */
    rec_setup(0);
    g_nscript = 0;
    script(0x4f709c, 1, 5, 0, 0, 0);
    script(VT, 1, 0x10000, 0, 0, 0);
    set32(rec, 0x162, 0x10000);
    set32(rec, 0x28f, RVA(2));
    set32(g_r[2], 0, RVA(3));
    set32(g_r[3], 0x48, VT);
    CK(m4f61e7_start_record(SELF, 2, &g_w, &g_host) == 0);
    CK(get32(SELF, 0x3ca) == 0x10000 && get32(SELF, 0x3c2) == 0x40b && L.n == 2);
    /* index 0xffffffff: rec = [self+0x3ce] - 0x5bb (32-bit wrap of the product) */
    rec_setup(0x5bb);
    g_nscript = 0;
    script(0x4f709c, 1, 5, 0, 0, 0);
    script(VT, 1, 9, 0, 0, 0);
    set32(g_r[1], 0x162, 1);
    set32(g_r[1], 0x28f, RVA(2));
    set32(g_r[2], 0, RVA(3));
    set32(g_r[3], 0x48, VT);
    CK(m4f61e7_start_record(SELF, 0xffffffffu, &g_w, &g_host) == 0);
    CK(get32(g_r[1], 0x287) == 1 && get32(SELF, 0x3ca) == 9);
}

/* CASES-END */

/* ---- bounded sweep ------------------------------------------------------------------------------------------------------------- */
static void test_sweep_bounded(void)
{
    unsigned seed = 4242;
    int n, i;
    for (n = 0; n < 300 && !g_failed; n++) {
        setup();
        for (i = 0; i < RSZ; i++) {
            seed = seed * 1103515245u + 12345u;
            g_r[0][i] = (uint8_t)(seed >> 16);
        }
        seed = seed * 1103515245u + 12345u;
        for (i = 0; i < (int)sizeof g_tbl; i++) g_tbl[i] = (uint8_t)(seed >> (i & 15));
        /* SWEEP */
        set32(SELF, 0x3ce, RVA(1));
        set32(g_r[1], 0x162, seed | 1);
        set32(g_r[1], 0x28f, RVA(2));
        set32(g_r[2], 0, RVA(3));
        set32(g_r[3], 0x48, VT);
        g_nscript = 0;
        script(0x4f709c, 1, seed >> 5, 0, 0, 0);
        script(VT, 1, seed >> 7, 0, 0, 0);
        m4f61e7_start_record(SELF, 0, &g_w, &g_host);
        L.n = 0;
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
    RUN(test_m4f61e7_start_record);
    /* RUNS */
    RUN(test_sweep_bounded);
    return failures;
}
