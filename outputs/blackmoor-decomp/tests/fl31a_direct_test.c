/* FL-31 (batch a) direct tests of the small struct methods of GAME.EXE in src/original_methods_fl31a.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl31a_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl31a.h"

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
static uint8_t g_tbl[0x4a * 0x70];
static Fl31aWorld g_w;
static Fl18Host g_host;
#define SELF g_r[0]

static void set32(uint8_t *b, size_t off, uint32_t v) { memcpy(b + off, &v, 4); }
__attribute__((unused)) static void set16(uint8_t *b, size_t off, uint16_t v) { memcpy(b + off, &v, 2); }
__attribute__((unused)) static uint32_t get32(const uint8_t *b, size_t off) { uint32_t v; memcpy(&v, b + off, 4); return v; }
__attribute__((unused)) static uint16_t get16(const uint8_t *b, size_t off) { uint16_t v; memcpy(&v, b + off, 2); return v; }

#define MAXCALL 64
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[6];
        uint8_t probe[16];       /* the first 16 bytes of region 4 at the call */
        uint8_t sp[16];          /* the first 16 bytes of self (region 0) at the call */
    } c[MAXCALL];
} L;
static struct {
    uint32_t callee, results[8];
    int n, used;
} S[4];
static int g_nscript;
__attribute__((unused)) static void script(uint32_t callee, int n, uint32_t r0, uint32_t r1, uint32_t r2, uint32_t r3)
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
        memcpy(L.c[i].sp, g_r[0], 16);
    }
    L.n++;
    for (k = 0; k < g_nscript; k++)
        if (S[k].callee == callee && S[k].n > 0) {
            result = S[k].results[S[k].used < S[k].n ? S[k].used : S[k].n - 1];
            S[k].used++;
        }
    return result;
}

__attribute__((unused)) static const uint8_t *host_resolve(void *ctx, uint32_t a)
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
    g_w.table_5d15a5 = g_tbl + 3 * 0x4a;
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    L.n = 0;
    g_nscript = 0;
}

__attribute__((unused)) static void ck_call(int line, int idx, uint32_t callee, uintptr_t this_ptr, int nargs, const uintptr_t *want)
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

/* ---- 0x47b200 ------------------------------------------------------------------------------------------------------------------ */
static void test_m47b200_construct(void)
{
    uint8_t before[0x40];
    setup();
    memset(SELF, 0xaa, 0x40);
    memcpy(before, SELF, sizeof before);
    CK(m47b200_construct(SELF, &g_host) == SELF);                                 /* returns this */
    CK(L.n == 1);
    CKC0(0, 0x47b23b, SELFP);                                                     /* thiscall, no arguments, ecx = this */
    CK(get32(L.c[0].sp, 0) == 0x52d568u);                                         /* the table pointer is stored before the call */
    CK(get32(SELF, 0) == 0x52d568u);
    CK(memcmp(SELF + 4, before + 4, sizeof before - 4) == 0);                     /* nothing else is written here (the callee is the host's) */
}

/* ---- 0x47b3bc and 0x47d640 ----------------------------------------------------------------------------------------------------- */
static uint8_t g_tbl0[sizeof g_tbl];
static void tbl_fill(void)
{
    memset(g_tbl, 0x55, sizeof g_tbl);
    memcpy(g_tbl0, g_tbl, sizeof g_tbl);
}
/* the table is unchanged except the dword at record i (relative to the world's index 0) = 1 (i = 99: unchanged altogether) */
static int tbl_is(int i)
{
    uint8_t want[sizeof g_tbl];
    memcpy(want, g_tbl0, sizeof want);
    if (i != 99) set32(want, (size_t)(3 + i) * 0x4a, 1);
    return memcmp(want, g_tbl, sizeof want) == 0;
}
static void test_m47b3bc_mark_entry(void)
{
    setup();
    tbl_fill();
    memset(SELF, 0x33, 0x100);
    set32(SELF, 0x24, 0);
    set16(SELF, 4, 3);
    m47b3bc_mark_entry(SELF, &g_w);
    CK(tbl_is(99));                                 /* the gate dword [self+0x24] == 0: nothing */
    set32(SELF, 0x24, 0x10000u);                    /* non-zero with a zero low word is still non-zero (dword compare) */
    set16(SELF, 4, 0xffff);
    m47b3bc_mark_entry(SELF, &g_w);
    CK(tbl_is(99));                                 /* word -1: nothing */
    set16(SELF, 4, 3);
    m47b3bc_mark_entry(SELF, &g_w);
    CK(tbl_is(3));
    tbl_fill();
    set16(SELF, 4, 0xfffe);                         /* -2 is an index (sign-extended word), not the sentinel */
    set32(SELF, 6, 0xffffffffu);                    /* the bytes above the word do not make a dword -1 matter */
    m47b3bc_mark_entry(SELF, &g_w);
    CK(tbl_is(-2));
    tbl_fill();
    set16(SELF, 4, 0xfffd);
    m47b3bc_mark_entry(SELF, &g_w);
    CK(tbl_is(-3));
    tbl_fill();
    set16(SELF, 4, 0);
    set32(SELF, 0x24, 0x80000000u);
    m47b3bc_mark_entry(SELF, &g_w);
    CK(tbl_is(0));
    CK(L.n == 0);
}
static void test_m47d640_mark_entry(void)
{
    setup();
    tbl_fill();
    memset(SELF, 0xff, 0x100);
    SELF[0x57] = 0;                                 /* the gate is a byte: the neighbours are non-zero */
    set16(SELF, 0x23, 3);
    m47d640_mark_entry(SELF, &g_w);
    CK(tbl_is(99));
    SELF[0x57] = 0x80;
    set16(SELF, 0x23, 0xffff);
    SELF[0x25] = 0;                                 /* the unaligned word at +0x23 is -1: nothing */
    SELF[0x26] = 0;
    m47d640_mark_entry(SELF, &g_w);
    CK(tbl_is(99));
    set16(SELF, 0x23, 7);
    m47d640_mark_entry(SELF, &g_w);
    CK(tbl_is(7));
    tbl_fill();
    SELF[0x57] = 1;
    set16(SELF, 0x23, 0xfffe);
    SELF[0x25] = 0xff;
    m47d640_mark_entry(SELF, &g_w);
    CK(tbl_is(-2));
    tbl_fill();
    set16(SELF, 0x23, 0xfffd);
    m47d640_mark_entry(SELF, &g_w);
    CK(tbl_is(-3));
    CK(L.n == 0);
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
        /* the indices are kept inside the table: the words at self+4 and self+0x23 are reduced to -3 .. 0x6b */
        set16(SELF, 4, (uint16_t)((int)(seed % 0x70) - 3));
        set16(SELF, 0x23, (uint16_t)((int)((seed >> 7) % 0x70) - 3));
        m47b3bc_mark_entry(SELF, &g_w);
        m47d640_mark_entry(SELF, &g_w);
        m47b200_construct(SELF, &g_host);
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
    RUN(test_m47b200_construct);
    RUN(test_m47b3bc_mark_entry);
    RUN(test_m47d640_mark_entry);
    /* RUN-END */
    RUN(test_sweep_bounded);
    return failures;
}
