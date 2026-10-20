/* FL-30 (batch b) direct tests of the methods of GAME.EXE in src/original_methods_fl30b.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl30b_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl30b.h"

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
static uint8_t g_recs[0x8d * 8], g_tab[0xa0];
static Fl30bWorld g_w;
static Fl18Host g_host;
#define SELF g_r[0]

static void set32(uint8_t *b, size_t off, uint32_t v) { memcpy(b + off, &v, 4); }
static void set16(uint8_t *b, size_t off, uint16_t v) { memcpy(b + off, &v, 2); }
static __attribute__((unused)) uint32_t get32(const uint8_t *b, size_t off) { uint32_t v; memcpy(&v, b + off, 4); return v; }
static uint16_t get16(const uint8_t *b, size_t off) { uint16_t v; memcpy(&v, b + off, 2); return v; }

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
} S[4];
static int g_nscript;
static __attribute__((unused)) void script(uint32_t callee, int n, uint32_t r0, uint32_t r1, uint32_t r2, uint32_t r3)
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
    memset(g_recs, 0, sizeof g_recs);
    memset(g_tab, 0, sizeof g_tab);
    memset(&g_w, 0, sizeof g_w);
    g_w.records_5bb5e5 = g_recs + 2 * 0x8d;       /* two records of slack below for a negative index */
    g_w.words_58c959 = g_tab + 0x3c;
    g_w.floats_58c91d = g_tab;
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

/* ---- 0x44b26a ------------------------------------------------------------------------------------------------------------------ */
static void rec44(int slot, uint32_t item_va) { set32(g_w.records_5bb5e5 + (ptrdiff_t)slot * 0x8d, 0, item_va); }
static void test_m44b26a_apply_delta(void)
{
    uint8_t *item = g_r[1];
    float f;
    setup();
    /* kind above 0x27: nothing but the final call; with the debug word the two reports first */
    rec44(2, RVA(1));
    item[0] = 0x28;
    m44b26a_apply_delta(2, &g_w, &g_host);
    CK(L.n == 1);
    CKC(0, 0x42ba3a, 0, 1, 2);
    setup();
    rec44(-1, RVA(1));
    item[0] = 0xc3;
    g_w.word_63a4cd = 0x100;
    m44b26a_apply_delta(0xfffe0000u | 0xffff, &g_w, &g_host);
    CK(L.n == 3);
    CKC(0, 0x50ca3e, 0, 3, 0x63888b, 0x549028, 0xc3);
    CKC(1, 0x52139c, 0, 3, 0x63888b, 0, 0);
    CKC(2, 0x42ba3a, 0, 1, 0xffff);
    /* kind 0x1d, flag 0: word 0x1111 + delta 0x2222 */
    setup();
    rec44(1, RVA(1));
    item[0] = 0x1d;
    item[1] = 0;
    set16(item, 2, 0x2222);
    set16(g_w.words_58c959, 0x1d * 2, 0x1111);
    m44b26a_apply_delta(1, &g_w, &g_host);
    CK(get16(g_w.words_58c959, 0x1d * 2) == 0x3333);
    CK(L.n == 1);
    /* the 16-bit wrap */
    set16(g_w.words_58c959, 0x1d * 2, 0xffff);
    set16(item, 2, 3);
    m44b26a_apply_delta(1, &g_w, &g_host);
    CK(get16(g_w.words_58c959, 0x1d * 2) == 2);
    /* the sentinel 0x270f is replaced, not added to */
    set16(g_w.words_58c959, 0x1d * 2, 0x270f);
    set16(item, 2, 0x10);
    m44b26a_apply_delta(1, &g_w, &g_host);
    CK(get16(g_w.words_58c959, 0x1d * 2) == 0x10);
    /* a non-zero flag replaces */
    item[1] = 0xff;
    set16(g_w.words_58c959, 0 * 2, 0x0101);
    item[0] = 0;
    set16(item, 2, 0x8001);
    m44b26a_apply_delta(1, &g_w, &g_host);
    CK(get16(g_w.words_58c959, 0) == 0x8001);
    /* floats: 0x1e + 0, delta -3 added to 10.0; 9999.0 is replaced; a non-zero flag replaces */
    item[0] = 0x1e;
    item[1] = 0;
    set16(item, 2, (uint16_t)-3);
    f = 10.0f;
    memcpy(g_w.floats_58c91d + 0x1e * 4, &f, 4);
    m44b26a_apply_delta(1, &g_w, &g_host);
    memcpy(&f, g_w.floats_58c91d + 0x1e * 4, 4);
    CK(f == 7.0f);
    f = 9999.0f;
    memcpy(g_w.floats_58c91d + 0x1e * 4, &f, 4);
    m44b26a_apply_delta(1, &g_w, &g_host);
    memcpy(&f, g_w.floats_58c91d + 0x1e * 4, 4);
    CK(f == -3.0f);
    item[1] = 1;
    item[0] = 0x27;
    set16(item, 2, 0x8000);
    f = 5.0f;
    memcpy(g_w.floats_58c91d + 0x27 * 4, &f, 4);
    m44b26a_apply_delta(1, &g_w, &g_host);
    memcpy(&f, g_w.floats_58c91d + 0x27 * 4, 4);
    CK(f == -32768.0f);
    /* NaN (unordered) takes the plain store as well */
    item[1] = 0;
    f = 0.0f / (volatile float)0.0f;
    memcpy(g_w.floats_58c91d + 0x27 * 4, &f, 4);
    set16(item, 2, 7);
    m44b26a_apply_delta(1, &g_w, &g_host);
    memcpy(&f, g_w.floats_58c91d + 0x27 * 4, 4);
    CK(f == 7.0f);
}

/* CASES-NEXT */

/* ---- bounded sweep ------------------------------------------------------------------------------------------------------------- */
static void test_sweep_bounded(void)
{
    unsigned seed = 4242;
    int n, i, slot;
    for (n = 0; n < 300 && !g_failed; n++) {
        setup();
        for (i = 0; i < RSZ; i++) {
            seed = seed * 1103515245u + 12345u;
            g_r[0][i] = (uint8_t)(seed >> 16);
        }
        seed = seed * 1103515245u + 12345u;
        for (i = 0; i < (int)sizeof g_tab; i++) g_tab[i] = (uint8_t)(seed >> (i & 15));
        for (i = 0; i < (int)sizeof g_recs; i++) g_recs[i] = (uint8_t)(seed >> (i & 7));
        slot = (int)((seed >> 3) % 3) - 1;
        rec44(slot, RVA(1));
        g_r[1][0] = (uint8_t)(seed >> 5);
        g_r[1][1] = (uint8_t)(seed >> 9);
        g_w.word_63a4cd = (int16_t)(seed >> 7);
        m44b26a_apply_delta((uint32_t)slot, &g_w, &g_host);
        /*SWEEP*/
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
    RUN(test_m44b26a_apply_delta);
    /*RUNS*/
    RUN(test_sweep_bounded);
    return failures;
}
