/* FL-37 direct tests of the 57 flag-toggle near-copies of GAME.EXE in src/original_methods_fl37.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE (flag address and word constant of each row
 * read from its own disassembly), not from running the native code; tests/test_fl37_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl37.h"

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

static uint8_t g_self[0x100];
static Fl37World g_w;
static Fl18Host g_host;
#define SELFP ((uintptr_t)g_self)

#define NFLAGS 57
/* the 57 flags of the world, in the order of the rows: 0x5e353e, 0x5e3542, ... step 4 ... 0x5e361e */
static uint32_t *flag_ptr(Fl37World *w, int which)
{
    uint32_t *p[NFLAGS];
    p[0] = &w->dword_5e353e;
    p[1] = &w->dword_5e3542;
    p[2] = &w->dword_5e3546;
    p[3] = &w->dword_5e354a;
    p[4] = &w->dword_5e354e;
    p[5] = &w->dword_5e3552;
    p[6] = &w->dword_5e3556;
    p[7] = &w->dword_5e355a;
    p[8] = &w->dword_5e355e;
    p[9] = &w->dword_5e3562;
    p[10] = &w->dword_5e3566;
    p[11] = &w->dword_5e356a;
    p[12] = &w->dword_5e356e;
    p[13] = &w->dword_5e3572;
    p[14] = &w->dword_5e3576;
    p[15] = &w->dword_5e357a;
    p[16] = &w->dword_5e357e;
    p[17] = &w->dword_5e3582;
    p[18] = &w->dword_5e3586;
    p[19] = &w->dword_5e358a;
    p[20] = &w->dword_5e358e;
    p[21] = &w->dword_5e3592;
    p[22] = &w->dword_5e3596;
    p[23] = &w->dword_5e359a;
    p[24] = &w->dword_5e359e;
    p[25] = &w->dword_5e35a2;
    p[26] = &w->dword_5e35a6;
    p[27] = &w->dword_5e35aa;
    p[28] = &w->dword_5e35ae;
    p[29] = &w->dword_5e35b2;
    p[30] = &w->dword_5e35b6;
    p[31] = &w->dword_5e35ba;
    p[32] = &w->dword_5e35be;
    p[33] = &w->dword_5e35c2;
    p[34] = &w->dword_5e35c6;
    p[35] = &w->dword_5e35ca;
    p[36] = &w->dword_5e35ce;
    p[37] = &w->dword_5e35d2;
    p[38] = &w->dword_5e35d6;
    p[39] = &w->dword_5e35da;
    p[40] = &w->dword_5e35de;
    p[41] = &w->dword_5e35e2;
    p[42] = &w->dword_5e35e6;
    p[43] = &w->dword_5e35ea;
    p[44] = &w->dword_5e35ee;
    p[45] = &w->dword_5e35f2;
    p[46] = &w->dword_5e35f6;
    p[47] = &w->dword_5e35fa;
    p[48] = &w->dword_5e35fe;
    p[49] = &w->dword_5e3602;
    p[50] = &w->dword_5e3606;
    p[51] = &w->dword_5e360a;
    p[52] = &w->dword_5e360e;
    p[53] = &w->dword_5e3612;
    p[54] = &w->dword_5e3616;
    p[55] = &w->dword_5e361a;
    p[56] = &w->dword_5e361e;
    return p[which];
}

#define MAXCALL 16
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        Fl37World w;            /* the world at the call */
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
        L.c[i].w = g_w;
    }
    L.n++;
    return 0;
}

static void setup(void)
{
    size_t i;
    int m;
    for (i = 0; i < sizeof g_self; i++) g_self[i] = (uint8_t)(i * 7 + 3);
    memset(&g_w, 0, sizeof g_w);
    g_w.word_5e335e = 0x4444;
    for (m = 0; m < NFLAGS; m++) *flag_ptr(&g_w, m) = 0xa0a0a000u + (uint32_t)m;
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.context = NULL;
    L.n = 0;
}

typedef void (*FlagFn)(uint8_t *, Fl37World *, const Fl18Host *);

/* `which` = the index of the row's flag in the order above, `k` = the word constant of the row (0xd to 0x45 in this batch) */
static void check_flag(FlagFn fn, uint32_t k, int which)
{
    static const uint32_t flags[] = {1, 0, 2, 0x100, 0x10001u, 0xffffffffu, 0x80000001u};
    static const uint16_t extra[] = {0, 1, 2, 3, 0xffff, 0x8000, 0x8001, 0x100, 0x101, 0x8000, 0xfffe, 0x4, 0x5, 0xc, 0xd};
    int i, j, n = (int)(sizeof extra / sizeof extra[0]);
    for (i = 0; i < 7; i++)
        for (j = 0; j < n + 5; j++) {
            /* the word values: k itself, k - 1, k + 1, k | 0x100, k | 0x8000, and the fixed list */
            uint16_t word_now = j == 0 ? (uint16_t)k : j == 1 ? (uint16_t)(k - 1) : j == 2 ? (uint16_t)(k + 1) : j == 3 ? (uint16_t)(k | 0x100) : j == 4 ? (uint16_t)(k | 0x8000) : extra[j - 5];
            uint16_t word_want;
            uint32_t flag_now;
            Fl37World w0;
            int m;
            setup();
            *flag_ptr(&g_w, which) = flags[i];
            g_w.word_5e335e = word_now;
            w0 = g_w;
            fn(g_self, &g_w, &g_host);
            flag_now = flags[i] == 1 ? 0 : 1;
            word_want = flags[i] == 1 ? word_now : (word_now == (uint16_t)k ? 0xffff : word_now);
            CK(*flag_ptr(&g_w, which) == flag_now);
            CK(g_w.word_5e335e == word_want);
            for (m = 0; m < NFLAGS; m++)
                if (m != which) CK(*flag_ptr(&g_w, m) == *flag_ptr(&w0, m));
            CK(L.n == 1 && L.c[0].callee == 0x404be1 && L.c[0].this_ptr == SELFP && L.c[0].nargs == 0);
            CK(L.c[0].w.word_5e335e == word_want);        /* both stores are done before the call */
            CK(*flag_ptr(&L.c[0].w, which) == flag_now);
        }
}

/* ---- the 57 rows ---------------------------------------------------------------------------------------------------------------- */
static void test_m406b3f_toggle_5e353e(void) { (void)m406b3f_toggle_5e353e; check_flag(m406b3f_toggle_5e353e, 0xd, 0); }
static void test_m406b86_toggle_5e3542(void) { (void)m406b86_toggle_5e3542; check_flag(m406b86_toggle_5e3542, 0xe, 1); }
static void test_m406bcd_toggle_5e3546(void) { (void)m406bcd_toggle_5e3546; check_flag(m406bcd_toggle_5e3546, 0xf, 2); }
static void test_m406c14_toggle_5e354a(void) { (void)m406c14_toggle_5e354a; check_flag(m406c14_toggle_5e354a, 0x10, 3); }
static void test_m406c5b_toggle_5e354e(void) { (void)m406c5b_toggle_5e354e; check_flag(m406c5b_toggle_5e354e, 0x11, 4); }
static void test_m406ca2_toggle_5e3552(void) { (void)m406ca2_toggle_5e3552; check_flag(m406ca2_toggle_5e3552, 0x12, 5); }
static void test_m406ce9_toggle_5e3556(void) { (void)m406ce9_toggle_5e3556; check_flag(m406ce9_toggle_5e3556, 0x13, 6); }
static void test_m406d30_toggle_5e355a(void) { (void)m406d30_toggle_5e355a; check_flag(m406d30_toggle_5e355a, 0x14, 7); }
static void test_m406d77_toggle_5e355e(void) { (void)m406d77_toggle_5e355e; check_flag(m406d77_toggle_5e355e, 0x15, 8); }
static void test_m406dbe_toggle_5e3562(void) { (void)m406dbe_toggle_5e3562; check_flag(m406dbe_toggle_5e3562, 0x16, 9); }
static void test_m406e05_toggle_5e3566(void) { (void)m406e05_toggle_5e3566; check_flag(m406e05_toggle_5e3566, 0x17, 10); }
static void test_m406e4c_toggle_5e356a(void) { (void)m406e4c_toggle_5e356a; check_flag(m406e4c_toggle_5e356a, 0x18, 11); }
static void test_m406e93_toggle_5e356e(void) { (void)m406e93_toggle_5e356e; check_flag(m406e93_toggle_5e356e, 0x19, 12); }
static void test_m406eda_toggle_5e3572(void) { (void)m406eda_toggle_5e3572; check_flag(m406eda_toggle_5e3572, 0x1a, 13); }
static void test_m406f21_toggle_5e3576(void) { (void)m406f21_toggle_5e3576; check_flag(m406f21_toggle_5e3576, 0x1b, 14); }
static void test_m406f68_toggle_5e357a(void) { (void)m406f68_toggle_5e357a; check_flag(m406f68_toggle_5e357a, 0x1c, 15); }
static void test_m406faf_toggle_5e357e(void) { (void)m406faf_toggle_5e357e; check_flag(m406faf_toggle_5e357e, 0x1d, 16); }
static void test_m406ff6_toggle_5e3582(void) { (void)m406ff6_toggle_5e3582; check_flag(m406ff6_toggle_5e3582, 0x1e, 17); }
static void test_m40703d_toggle_5e3586(void) { (void)m40703d_toggle_5e3586; check_flag(m40703d_toggle_5e3586, 0x1f, 18); }
static void test_m407084_toggle_5e358a(void) { (void)m407084_toggle_5e358a; check_flag(m407084_toggle_5e358a, 0x20, 19); }
static void test_m4070cb_toggle_5e358e(void) { (void)m4070cb_toggle_5e358e; check_flag(m4070cb_toggle_5e358e, 0x21, 20); }
static void test_m407112_toggle_5e3592(void) { (void)m407112_toggle_5e3592; check_flag(m407112_toggle_5e3592, 0x22, 21); }
static void test_m407159_toggle_5e3596(void) { (void)m407159_toggle_5e3596; check_flag(m407159_toggle_5e3596, 0x23, 22); }
static void test_m4071a0_toggle_5e359a(void) { (void)m4071a0_toggle_5e359a; check_flag(m4071a0_toggle_5e359a, 0x24, 23); }
static void test_m4071e7_toggle_5e359e(void) { (void)m4071e7_toggle_5e359e; check_flag(m4071e7_toggle_5e359e, 0x25, 24); }
static void test_m40722e_toggle_5e35a2(void) { (void)m40722e_toggle_5e35a2; check_flag(m40722e_toggle_5e35a2, 0x26, 25); }
static void test_m407275_toggle_5e35a6(void) { (void)m407275_toggle_5e35a6; check_flag(m407275_toggle_5e35a6, 0x27, 26); }
static void test_m4072bc_toggle_5e35aa(void) { (void)m4072bc_toggle_5e35aa; check_flag(m4072bc_toggle_5e35aa, 0x28, 27); }
static void test_m407303_toggle_5e35ae(void) { (void)m407303_toggle_5e35ae; check_flag(m407303_toggle_5e35ae, 0x29, 28); }
static void test_m40734a_toggle_5e35b2(void) { (void)m40734a_toggle_5e35b2; check_flag(m40734a_toggle_5e35b2, 0x2a, 29); }
static void test_m407391_toggle_5e35b6(void) { (void)m407391_toggle_5e35b6; check_flag(m407391_toggle_5e35b6, 0x2b, 30); }
static void test_m4073d8_toggle_5e35ba(void) { (void)m4073d8_toggle_5e35ba; check_flag(m4073d8_toggle_5e35ba, 0x2c, 31); }
static void test_m40741f_toggle_5e35be(void) { (void)m40741f_toggle_5e35be; check_flag(m40741f_toggle_5e35be, 0x2d, 32); }
static void test_m407466_toggle_5e35c2(void) { (void)m407466_toggle_5e35c2; check_flag(m407466_toggle_5e35c2, 0x2e, 33); }
static void test_m4074ad_toggle_5e35c6(void) { (void)m4074ad_toggle_5e35c6; check_flag(m4074ad_toggle_5e35c6, 0x2f, 34); }
static void test_m4074f4_toggle_5e35ca(void) { (void)m4074f4_toggle_5e35ca; check_flag(m4074f4_toggle_5e35ca, 0x30, 35); }
static void test_m40753b_toggle_5e35ce(void) { (void)m40753b_toggle_5e35ce; check_flag(m40753b_toggle_5e35ce, 0x31, 36); }
static void test_m407582_toggle_5e35d2(void) { (void)m407582_toggle_5e35d2; check_flag(m407582_toggle_5e35d2, 0x32, 37); }
static void test_m4075c9_toggle_5e35d6(void) { (void)m4075c9_toggle_5e35d6; check_flag(m4075c9_toggle_5e35d6, 0x33, 38); }
static void test_m407610_toggle_5e35da(void) { (void)m407610_toggle_5e35da; check_flag(m407610_toggle_5e35da, 0x34, 39); }
static void test_m407657_toggle_5e35de(void) { (void)m407657_toggle_5e35de; check_flag(m407657_toggle_5e35de, 0x35, 40); }
static void test_m40769e_toggle_5e35e2(void) { (void)m40769e_toggle_5e35e2; check_flag(m40769e_toggle_5e35e2, 0x36, 41); }
static void test_m4076e5_toggle_5e35e6(void) { (void)m4076e5_toggle_5e35e6; check_flag(m4076e5_toggle_5e35e6, 0x37, 42); }
static void test_m40772c_toggle_5e35ea(void) { (void)m40772c_toggle_5e35ea; check_flag(m40772c_toggle_5e35ea, 0x38, 43); }
static void test_m407773_toggle_5e35ee(void) { (void)m407773_toggle_5e35ee; check_flag(m407773_toggle_5e35ee, 0x39, 44); }
static void test_m4077ba_toggle_5e35f2(void) { (void)m4077ba_toggle_5e35f2; check_flag(m4077ba_toggle_5e35f2, 0x3a, 45); }
static void test_m407801_toggle_5e35f6(void) { (void)m407801_toggle_5e35f6; check_flag(m407801_toggle_5e35f6, 0x3b, 46); }
static void test_m407848_toggle_5e35fa(void) { (void)m407848_toggle_5e35fa; check_flag(m407848_toggle_5e35fa, 0x3c, 47); }
static void test_m40788f_toggle_5e35fe(void) { (void)m40788f_toggle_5e35fe; check_flag(m40788f_toggle_5e35fe, 0x3d, 48); }
static void test_m4078d6_toggle_5e3602(void) { (void)m4078d6_toggle_5e3602; check_flag(m4078d6_toggle_5e3602, 0x3e, 49); }
static void test_m40791d_toggle_5e3606(void) { (void)m40791d_toggle_5e3606; check_flag(m40791d_toggle_5e3606, 0x3f, 50); }
static void test_m407964_toggle_5e360a(void) { (void)m407964_toggle_5e360a; check_flag(m407964_toggle_5e360a, 0x40, 51); }
static void test_m4079ab_toggle_5e360e(void) { (void)m4079ab_toggle_5e360e; check_flag(m4079ab_toggle_5e360e, 0x41, 52); }
static void test_m4079f2_toggle_5e3612(void) { (void)m4079f2_toggle_5e3612; check_flag(m4079f2_toggle_5e3612, 0x42, 53); }
static void test_m407a39_toggle_5e3616(void) { (void)m407a39_toggle_5e3616; check_flag(m407a39_toggle_5e3616, 0x43, 54); }
static void test_m407a80_toggle_5e361a(void) { (void)m407a80_toggle_5e361a; check_flag(m407a80_toggle_5e361a, 0x44, 55); }
static void test_m407ac7_toggle_5e361e(void) { (void)m407ac7_toggle_5e361e; check_flag(m407ac7_toggle_5e361e, 0x45, 56); }

/* CASES-END */

/* ---- bounded sweep ------------------------------------------------------------------------------------------------------------- */
static void test_sweep_bounded(void)
{
    unsigned seed = 4242;
    int n, m;
    for (n = 0; n < 300 && !g_failed; n++) {
        setup();
        for (m = 0; m < NFLAGS; m++) {
            seed = seed * 1103515245u + 12345u;
            *flag_ptr(&g_w, m) = (seed >> 16) & 3;
        }
        seed = seed * 1103515245u + 12345u;
        g_w.word_5e335e = (uint16_t)((seed >> 16) % 0x46);
        m406b3f_toggle_5e353e(g_self, &g_w, &g_host);
        m406b86_toggle_5e3542(g_self, &g_w, &g_host);
        m406bcd_toggle_5e3546(g_self, &g_w, &g_host);
        m406c14_toggle_5e354a(g_self, &g_w, &g_host);
        m406c5b_toggle_5e354e(g_self, &g_w, &g_host);
        m406ca2_toggle_5e3552(g_self, &g_w, &g_host);
        m406ce9_toggle_5e3556(g_self, &g_w, &g_host);
        m406d30_toggle_5e355a(g_self, &g_w, &g_host);
        m406d77_toggle_5e355e(g_self, &g_w, &g_host);
        m406dbe_toggle_5e3562(g_self, &g_w, &g_host);
        m406e05_toggle_5e3566(g_self, &g_w, &g_host);
        m406e4c_toggle_5e356a(g_self, &g_w, &g_host);
        m406e93_toggle_5e356e(g_self, &g_w, &g_host);
        m406eda_toggle_5e3572(g_self, &g_w, &g_host);
        m406f21_toggle_5e3576(g_self, &g_w, &g_host);
        m406f68_toggle_5e357a(g_self, &g_w, &g_host);
        m406faf_toggle_5e357e(g_self, &g_w, &g_host);
        m406ff6_toggle_5e3582(g_self, &g_w, &g_host);
        m40703d_toggle_5e3586(g_self, &g_w, &g_host);
        m407084_toggle_5e358a(g_self, &g_w, &g_host);
        m4070cb_toggle_5e358e(g_self, &g_w, &g_host);
        m407112_toggle_5e3592(g_self, &g_w, &g_host);
        m407159_toggle_5e3596(g_self, &g_w, &g_host);
        m4071a0_toggle_5e359a(g_self, &g_w, &g_host);
        m4071e7_toggle_5e359e(g_self, &g_w, &g_host);
        m40722e_toggle_5e35a2(g_self, &g_w, &g_host);
        m407275_toggle_5e35a6(g_self, &g_w, &g_host);
        m4072bc_toggle_5e35aa(g_self, &g_w, &g_host);
        m407303_toggle_5e35ae(g_self, &g_w, &g_host);
        m40734a_toggle_5e35b2(g_self, &g_w, &g_host);
        m407391_toggle_5e35b6(g_self, &g_w, &g_host);
        m4073d8_toggle_5e35ba(g_self, &g_w, &g_host);
        m40741f_toggle_5e35be(g_self, &g_w, &g_host);
        m407466_toggle_5e35c2(g_self, &g_w, &g_host);
        m4074ad_toggle_5e35c6(g_self, &g_w, &g_host);
        m4074f4_toggle_5e35ca(g_self, &g_w, &g_host);
        m40753b_toggle_5e35ce(g_self, &g_w, &g_host);
        m407582_toggle_5e35d2(g_self, &g_w, &g_host);
        m4075c9_toggle_5e35d6(g_self, &g_w, &g_host);
        m407610_toggle_5e35da(g_self, &g_w, &g_host);
        m407657_toggle_5e35de(g_self, &g_w, &g_host);
        m40769e_toggle_5e35e2(g_self, &g_w, &g_host);
        m4076e5_toggle_5e35e6(g_self, &g_w, &g_host);
        m40772c_toggle_5e35ea(g_self, &g_w, &g_host);
        m407773_toggle_5e35ee(g_self, &g_w, &g_host);
        m4077ba_toggle_5e35f2(g_self, &g_w, &g_host);
        m407801_toggle_5e35f6(g_self, &g_w, &g_host);
        m407848_toggle_5e35fa(g_self, &g_w, &g_host);
        m40788f_toggle_5e35fe(g_self, &g_w, &g_host);
        m4078d6_toggle_5e3602(g_self, &g_w, &g_host);
        m40791d_toggle_5e3606(g_self, &g_w, &g_host);
        m407964_toggle_5e360a(g_self, &g_w, &g_host);
        m4079ab_toggle_5e360e(g_self, &g_w, &g_host);
        m4079f2_toggle_5e3612(g_self, &g_w, &g_host);
        m407a39_toggle_5e3616(g_self, &g_w, &g_host);
        m407a80_toggle_5e361a(g_self, &g_w, &g_host);
        m407ac7_toggle_5e361e(g_self, &g_w, &g_host);
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
    RUN(test_m406b3f_toggle_5e353e);
    RUN(test_m406b86_toggle_5e3542);
    RUN(test_m406bcd_toggle_5e3546);
    RUN(test_m406c14_toggle_5e354a);
    RUN(test_m406c5b_toggle_5e354e);
    RUN(test_m406ca2_toggle_5e3552);
    RUN(test_m406ce9_toggle_5e3556);
    RUN(test_m406d30_toggle_5e355a);
    RUN(test_m406d77_toggle_5e355e);
    RUN(test_m406dbe_toggle_5e3562);
    RUN(test_m406e05_toggle_5e3566);
    RUN(test_m406e4c_toggle_5e356a);
    RUN(test_m406e93_toggle_5e356e);
    RUN(test_m406eda_toggle_5e3572);
    RUN(test_m406f21_toggle_5e3576);
    RUN(test_m406f68_toggle_5e357a);
    RUN(test_m406faf_toggle_5e357e);
    RUN(test_m406ff6_toggle_5e3582);
    RUN(test_m40703d_toggle_5e3586);
    RUN(test_m407084_toggle_5e358a);
    RUN(test_m4070cb_toggle_5e358e);
    RUN(test_m407112_toggle_5e3592);
    RUN(test_m407159_toggle_5e3596);
    RUN(test_m4071a0_toggle_5e359a);
    RUN(test_m4071e7_toggle_5e359e);
    RUN(test_m40722e_toggle_5e35a2);
    RUN(test_m407275_toggle_5e35a6);
    RUN(test_m4072bc_toggle_5e35aa);
    RUN(test_m407303_toggle_5e35ae);
    RUN(test_m40734a_toggle_5e35b2);
    RUN(test_m407391_toggle_5e35b6);
    RUN(test_m4073d8_toggle_5e35ba);
    RUN(test_m40741f_toggle_5e35be);
    RUN(test_m407466_toggle_5e35c2);
    RUN(test_m4074ad_toggle_5e35c6);
    RUN(test_m4074f4_toggle_5e35ca);
    RUN(test_m40753b_toggle_5e35ce);
    RUN(test_m407582_toggle_5e35d2);
    RUN(test_m4075c9_toggle_5e35d6);
    RUN(test_m407610_toggle_5e35da);
    RUN(test_m407657_toggle_5e35de);
    RUN(test_m40769e_toggle_5e35e2);
    RUN(test_m4076e5_toggle_5e35e6);
    RUN(test_m40772c_toggle_5e35ea);
    RUN(test_m407773_toggle_5e35ee);
    RUN(test_m4077ba_toggle_5e35f2);
    RUN(test_m407801_toggle_5e35f6);
    RUN(test_m407848_toggle_5e35fa);
    RUN(test_m40788f_toggle_5e35fe);
    RUN(test_m4078d6_toggle_5e3602);
    RUN(test_m40791d_toggle_5e3606);
    RUN(test_m407964_toggle_5e360a);
    RUN(test_m4079ab_toggle_5e360e);
    RUN(test_m4079f2_toggle_5e3612);
    RUN(test_m407a39_toggle_5e3616);
    RUN(test_m407a80_toggle_5e361a);
    RUN(test_m407ac7_toggle_5e361e);
    /* RUN-END */
    RUN(test_sweep_bounded);
    return failures;
}
