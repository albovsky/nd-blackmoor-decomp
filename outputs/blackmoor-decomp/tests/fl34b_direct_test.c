/* FL-34 (batch b) direct tests of the ten flag-toggle handlers of GAME.EXE in src/original_methods_fl34b.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE (flag address and word constant of each row
 * read from its own disassembly), not from running the native code; tests/test_fl34b_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl34b.h"

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
static Fl34bWorld g_w;
static Fl18Host g_host;
#define SELFP ((uintptr_t)g_self)

#define NFLAGS 10
/* the ten flags of the world, in the order of the rows: 0x5e350a, 0x5e351a, 0x5e351e, 0x5e3522, 0x5e3526, 0x5e352a, 0x5e352e, 0x5e3532, 0x5e3536, 0x5e353a */
static uint32_t *flag_ptr(Fl34bWorld *w, int which)
{
    uint32_t *p[NFLAGS];
    p[0] = &w->dword_5e350a;
    p[1] = &w->dword_5e351a;
    p[2] = &w->dword_5e351e;
    p[3] = &w->dword_5e3522;
    p[4] = &w->dword_5e3526;
    p[5] = &w->dword_5e352a;
    p[6] = &w->dword_5e352e;
    p[7] = &w->dword_5e3532;
    p[8] = &w->dword_5e3536;
    p[9] = &w->dword_5e353a;
    return p[which];
}

#define MAXCALL 16
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        Fl34bWorld w;            /* the world at the call */
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

typedef void (*FlagFn)(uint8_t *, Fl34bWorld *, const Fl18Host *);

/* `which` = the index of the row's flag in the order above, `k` = the word constant of the row (0x4067a5 is `test eax,eax`, i.e. 0) */
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
            Fl34bWorld w0;
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

/* ---- the ten rows ---------------------------------------------------------------------------------------------------------------- */
static void test_m4067a5_toggle_5e350a(void) { (void)m4067a5_toggle_5e350a; check_flag(m4067a5_toggle_5e350a, 0x0, 0); }
static void test_m4068c0_toggle_5e351a(void) { (void)m4068c0_toggle_5e351a; check_flag(m4068c0_toggle_5e351a, 0x4, 1); }
static void test_m406907_toggle_5e351e(void) { (void)m406907_toggle_5e351e; check_flag(m406907_toggle_5e351e, 0x5, 2); }
static void test_m40694e_toggle_5e3522(void) { (void)m40694e_toggle_5e3522; check_flag(m40694e_toggle_5e3522, 0x6, 3); }
static void test_m406995_toggle_5e3526(void) { (void)m406995_toggle_5e3526; check_flag(m406995_toggle_5e3526, 0x7, 4); }
static void test_m4069dc_toggle_5e352a(void) { (void)m4069dc_toggle_5e352a; check_flag(m4069dc_toggle_5e352a, 0x8, 5); }
static void test_m406a23_toggle_5e352e(void) { (void)m406a23_toggle_5e352e; check_flag(m406a23_toggle_5e352e, 0x9, 6); }
static void test_m406a6a_toggle_5e3532(void) { (void)m406a6a_toggle_5e3532; check_flag(m406a6a_toggle_5e3532, 0xa, 7); }
static void test_m406ab1_toggle_5e3536(void) { (void)m406ab1_toggle_5e3536; check_flag(m406ab1_toggle_5e3536, 0xb, 8); }
static void test_m406af8_toggle_5e353a(void) { (void)m406af8_toggle_5e353a; check_flag(m406af8_toggle_5e353a, 0xc, 9); }

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
        g_w.word_5e335e = (uint16_t)((seed >> 16) % 14);
        m4067a5_toggle_5e350a(g_self, &g_w, &g_host);
        m4068c0_toggle_5e351a(g_self, &g_w, &g_host);
        m406907_toggle_5e351e(g_self, &g_w, &g_host);
        m40694e_toggle_5e3522(g_self, &g_w, &g_host);
        m406995_toggle_5e3526(g_self, &g_w, &g_host);
        m4069dc_toggle_5e352a(g_self, &g_w, &g_host);
        m406a23_toggle_5e352e(g_self, &g_w, &g_host);
        m406a6a_toggle_5e3532(g_self, &g_w, &g_host);
        m406ab1_toggle_5e3536(g_self, &g_w, &g_host);
        m406af8_toggle_5e353a(g_self, &g_w, &g_host);
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
    RUN(test_m4067a5_toggle_5e350a);
    RUN(test_m4068c0_toggle_5e351a);
    RUN(test_m406907_toggle_5e351e);
    RUN(test_m40694e_toggle_5e3522);
    RUN(test_m406995_toggle_5e3526);
    RUN(test_m4069dc_toggle_5e352a);
    RUN(test_m406a23_toggle_5e352e);
    RUN(test_m406a6a_toggle_5e3532);
    RUN(test_m406ab1_toggle_5e3536);
    RUN(test_m406af8_toggle_5e353a);
    /* RUN-END */
    RUN(test_sweep_bounded);
    return failures;
}
