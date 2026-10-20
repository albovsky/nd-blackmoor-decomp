/* FL-30 (batch d) direct tests of the methods of GAME.EXE in src/original_methods_fl30d.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl30d_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl30d.h"

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
#define RSZ 0x7000
static uint8_t g_r[8][RSZ];
static uint8_t g_blk[FL30D_BLOCK_5A1E54_SIZE];
static Fl30dWorld g_w;
static Fl18Host g_host;
#define SELF g_r[0]

static __attribute__((unused)) void set32(uint8_t *b, size_t off, uint32_t v) { memcpy(b + off, &v, 4); }
static void set16(uint8_t *b, size_t off, uint16_t v) { memcpy(b + off, &v, 2); }
static uint32_t get32(const uint8_t *b, size_t off) { uint32_t v; memcpy(&v, b + off, 4); return v; }
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
    memset(g_blk, 0xaa, sizeof g_blk);
    memset(&g_w, 0, sizeof g_w);
    g_w.block_5a1e54 = g_blk;
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

/* ---- 0x4e2e05 ------------------------------------------------------------------------------------------------------------------ */
#define BO(va) ((size_t)((va) - 0x5a1e54u))
static void blk_setup(int count)
{
    int i;
    setup();
    memset(SELF, 0, RSZ);
    for (i = 0; i < 0x2a * 0xec && 0x457b + i < RSZ; i++) SELF[0x457b + i] = (uint8_t)(i * 5 + 1);
    set16(SELF, 0x1471, (uint16_t)count);
    SELF[0x139d] = 'P';                 /* equal to the global byte below: no copy */
    SELF[0x13e3] = 'Q';
    g_w.byte_63a9e4 = 'P';
    g_w.byte_63a9e8 = 'Q';
}
static void test_m4e2e05_copy_state(void)
{
    int i;
    uint8_t before[FL30D_BLOCK_5A1E54_SIZE];
    blk_setup(2);
    CK(m4e2e05_copy_state(SELF, &g_w, &g_host) == 0);
    CK(L.n == 1);
    CKC0(0, 0x4e3ade, SELFP);
    CK(get32(g_blk, BO(0x5a1e54)) == 0 && get32(g_blk, BO(0x5a1e58)) == 0);
    for (i = 0; i < 2 * 0x29; i++) CK(g_blk[BO(0x5a1e62) + i] == (uint8_t)(i * 5 + 1));
    CK(g_blk[BO(0x5a1e62) + 2 * 0x29] == 0xaa);                       /* nothing past the n bytes */
    CK(get16(g_blk, BO(0x5a1e5c)) == 2);
    CK(get16(g_blk, BO(0x5a1e5e)) == 0 && get16(g_blk, BO(0x5a1e60)) == 0);   /* both first bytes equal */
    CK(g_blk[BO(0x5a2664)] == 0xaa && g_blk[BO(0x5a434c)] == 0xaa);
    /* both strings differ: z1 is "AB", z2 is "CDE", z3 is "FGHIJ" (5 chars: dword + byte copy); the words and the sign extended dword */
    blk_setup(3);
    memcpy(SELF + 0x139d, "AB\0", 4);
    memcpy(SELF + 0x13be, "CDE\0", 5);
    memcpy(SELF + 0x13e3, "FGHIJ\0", 7);
    set16(SELF, 0x13df, 0x1111); set16(SELF, 0x13e1, 0x2222);
    set16(SELF, 0x1404, 0x8000); set16(SELF, 0x1406, 0x3333); set16(SELF, 0x1408, 0x4444);
    L.n = 0;
    CK(m4e2e05_copy_state(SELF, &g_w, &g_host) == 0);
    CK(get16(g_blk, BO(0x5a1e5e)) == 1 && get16(g_blk, BO(0x5a1e60)) == 1);
    CK(memcmp(g_blk + BO(0x5a2664), "AB\0", 3) == 0 && memcmp(g_blk + BO(0x5a2685), "CDE\0", 4) == 0);
    CK(get16(g_blk, BO(0x5a26a6)) == 0x1111 && get16(g_blk, BO(0x5a26a8)) == 0x2222 && get32(g_blk, BO(0x5a26aa)) == 0);
    CK(memcmp(g_blk + BO(0x5a434c), "FGHIJ\0", 6) == 0);
    CK(get32(g_blk, BO(0x5a4371)) == 0xffff8000u && get16(g_blk, BO(0x5a436d)) == 0x3333 && get16(g_blk, BO(0x5a436f)) == 0x4444);
    /* a first string of 0x24 characters: its tail 0x21..0x24 is overwritten by the second string (copied after it) */
    blk_setup(0);
    for (i = 0; i < 0x24; i++) SELF[0x139d + i] = (uint8_t)('a' + (i % 20));
    SELF[0x139d + 0x24] = 0;
    memcpy(SELF + 0x13be, "xy\0", 3);
    SELF[0x139d] = 'a' ^ 1;
    g_w.byte_63a9e4 = 'a';
    CK(m4e2e05_copy_state(SELF, &g_w, &g_host) == 0);
    CK(g_blk[BO(0x5a2664)] == ('a' ^ 1) && g_blk[BO(0x5a2664) + 0x20] == (uint8_t)('a' + (0x20 % 20)));
    CK(g_blk[BO(0x5a2685)] == 'x' && g_blk[BO(0x5a2686)] == 'y' && g_blk[BO(0x5a2687)] == 0);     /* the second string, NUL included, over the first string's tail */
    CK(g_blk[BO(0x5a2685) + 3] == (uint8_t)('a' + ((0x21 + 3) % 20)) || g_blk[BO(0x5a2685) + 3] == 0xaa);
    /* native rejection: a negative count and a count whose bytes do not fit the mirror leave everything unchanged and call nothing */
    blk_setup(232);                      /* the largest count that fits: 232 * 0x29 = 0x2528 <= 0x2532 */
    CK(m4e2e05_copy_state(SELF, &g_w, &g_host) == 0);
    CK(g_blk[BO(0x5a1e62) + 232 * 0x29 - 1] == (uint8_t)((232 * 0x29 - 1) * 5 + 1));
    for (i = 0; i < 4; i++) {
        blk_setup(i == 0 ? -1 : i == 1 ? -0x8000 : i == 2 ? 233 : 0xec);
        memcpy(before, g_blk, sizeof before);
        L.n = 0;
        CK(m4e2e05_copy_state(SELF, &g_w, &g_host) == 1);
        CK(L.n == 0 && memcmp(before, g_blk, sizeof before) == 0);
    }
}

/*TESTS*/

/* ---- bounded sweep ------------------------------------------------------------------------------------------------------------- */
static void test_sweep_bounded(void)
{
    unsigned seed = 4242;
    int n, i;
    for (n = 0; n < 300 && !g_failed; n++) {
        setup();
        for (i = 0; i < RSZ; i++) {
            seed = seed * 1103515245u + 12345u;
            SELF[i] = (uint8_t)(seed >> 16);
        }
        set16(SELF, 0x1471, (uint16_t)((seed >> 3) % 0x40));       /* inside the mirror: a bounded sweep */
        SELF[0x139d + 0x20] = 0;                                   /* the strings end inside their fields */
        SELF[0x13be + 0x20] = 0;
        SELF[0x13e3 + 0x20] = 0;
        g_w.byte_63a9e4 = (uint8_t)seed;
        g_w.byte_63a9e8 = (uint8_t)(seed >> 8);
        m4e2e05_copy_state(SELF, &g_w, &g_host);
        L.n = 0;
        /*SWEEPBODY*/
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
    RUN(test_m4e2e05_copy_state);
    /*RUNS*/
    RUN(test_sweep_bounded);
    return failures;
}
