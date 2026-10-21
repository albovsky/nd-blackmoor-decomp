/* FL-35 (batch b) direct tests of the toggle and the 35 text readers of GAME.EXE in src/original_methods_fl35b.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl35b_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl35b.h"

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

#define SELF_SIZE 0x400
#define FIRST_WORD 0x5ec28c
#define LAST_CALLEE 0x407ca7
static uint8_t g_self[SELF_SIZE];
static Fl35bWorld g_w;
static Fl18Host g_host;
#define SELF g_self
#define NW (sizeof(Fl35bWorld) / 2)
#define WORDS ((uint16_t *)&g_w)

#define MAXCALL 16
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[4];
        uint16_t words[NW];      /* the world words at the call */
        uint8_t buf[0x14];       /* the 0x14 bytes behind the first argument at the call (logged for 0x50cb1b) */
    } c[MAXCALL];
} L;
static uint8_t g_fill[0x14];      /* what 0x51d5b2 writes into the buffer */
static uint32_t g_atoi, g_ret;    /* the answers of 0x50cb1b and of the last callee */

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int k, i = L.n;
    (void)ctx;
    if (L.n < MAXCALL) {
        L.c[i].callee = callee;
        L.c[i].this_ptr = this_ptr;
        L.c[i].nargs = nargs;
        for (k = 0; k < nargs && k < 4; k++) L.c[i].a[k] = args[k];
        memcpy(L.c[i].words, &g_w, sizeof L.c[i].words);
        if (callee == 0x50cb1b) memcpy(L.c[i].buf, (const void *)args[0], 0x14);
    }
    L.n++;
    if (callee == 0x51d5b2) {
        memcpy((void *)args[0], g_fill, 0x14);
        return 0x77777777u;
    }
    if (callee == 0x50cb1b) return g_atoi;
    if (callee == LAST_CALLEE) return g_ret;
    return 0x66666666u;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    (void)a;
    return NULL;
}

static void setup(void)
{
    size_t i;
    for (i = 0; i < SELF_SIZE; i++) g_self[i] = (uint8_t)(i * 7 + 3);
    memset(&g_w, 0, sizeof g_w);
    for (i = 0; i < NW; i++) WORDS[i] = (uint16_t)(0x1000 + i * 0x111);
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    L.n = 0;
    g_atoi = g_ret = 0;
    memset(g_fill, 0x5a, sizeof g_fill);
}

typedef uint32_t (*ReadFn)(uint8_t *, Fl35bWorld *, const Fl18Host *);

/* `field` is the string field offset, `word` the original address of the word that is stored */
static void check_reader(ReadFn fn, size_t field, uint32_t word)
{
    static const uint32_t atoi_values[] = {0x1234abcdu, 0xffff8001u, 0x10000u, 0, 0x7fffu};
    uint16_t want[NW];
    size_t slot = (word - FIRST_WORD) / 2, i, k;
    uint8_t before[0x40];
    for (k = 0; k < sizeof atoi_values / sizeof atoi_values[0] && !g_failed; k++) {
        setup();
        memcpy(before, SELF, sizeof before);
        for (i = 0; i < NW; i++) want[i] = (uint16_t)(0x1000 + i * 0x111);
        for (i = 0; i < 0x14; i++) g_fill[i] = (uint8_t)(0x30 + i + k);
        g_atoi = atoi_values[k];
        g_ret = 0xcafef00du + (uint32_t)k;
        CK(fn(SELF, &g_w, &g_host) == 0xcafef00du + (uint32_t)k);
        CK(L.n == 3);
        CK(L.c[0].callee == 0x51d5b2 && L.c[0].this_ptr == (uintptr_t)(SELF + field) && L.c[0].nargs == 2 && L.c[0].a[1] == 0x13 && L.c[0].a[0] != 0);
        CK(L.c[1].callee == 0x50cb1b && L.c[1].this_ptr == 0 && L.c[1].nargs == 1 && L.c[1].a[0] == L.c[0].a[0]);        /* the same buffer */
        CK(memcmp(L.c[1].buf, g_fill, 0x14) == 0);                                                                       /* the buffer is passed unchanged */
        CK(memcmp(L.c[1].words, want, sizeof want) == 0);                                                                /* nothing is stored before 0x50cb1b */
        want[slot] = (uint16_t)atoi_values[k];
        CK(L.c[2].callee == 0x407ca7 && L.c[2].this_ptr == (uintptr_t)SELF && L.c[2].nargs == 0);
        CK(memcmp(L.c[2].words, want, sizeof want) == 0);                                                                /* the low word is stored before the last call, nothing else */
        CK(memcmp(&g_w, want, sizeof want) == 0);
        CK(memcmp(SELF, before, sizeof before) == 0 && SELF[0x300] == (uint8_t)(0x300 * 7 + 3));
    }
}

/* 0x4080fc: the signed 16-bit word 0x5ec28c becomes 0 when non-zero and 1 when zero; then 0x407ca7(this) */
static void test_m4080fc_toggle_5ec28c(void)
{
    static const uint16_t in[] = {0, 1, 0x8000, 0xffff, 0x0100, 0x00ff, 2, 0x7fff};
    uint16_t want[NW];
    size_t k, i;
    for (k = 0; k < sizeof in / sizeof in[0] && !g_failed; k++) {
        setup();
        WORDS[0] = in[k];
        for (i = 0; i < NW; i++) want[i] = WORDS[i];
        want[0] = in[k] != 0 ? 0 : 1;
        g_ret = 0xcafef00du;
        CK(m4080fc_toggle_5ec28c(SELF, &g_w, &g_host) == 0xcafef00du);
        CK(L.n == 1);
        CK(L.c[0].callee == 0x407ca7 && L.c[0].this_ptr == (uintptr_t)SELF && L.c[0].nargs == 0);
        CK(memcmp(L.c[0].words, want, sizeof want) == 0);                                  /* the toggle happens before the call, nothing else changes */
        CK(memcmp(&g_w, want, sizeof want) == 0);
        CK(SELF[0x300] == (uint8_t)(0x300 * 7 + 3));
    }
}

static void test_m40812e_read_text_word(void) { check_reader(m40812e_read_text_word, 0x8c, 0x5ec28e); }
static void test_m408169_read_text_word(void) { check_reader(m408169_read_text_word, 0xcc, 0x5ec290); }
static void test_m4081a4_read_text_word(void) { check_reader(m4081a4_read_text_word, 0x10c, 0x5ec292); }
static void test_m4081df_read_text_word(void) { check_reader(m4081df_read_text_word, 0x14c, 0x5ec294); }
static void test_m40821a_read_text_word(void) { check_reader(m40821a_read_text_word, 0x18c, 0x5ec296); }
static void test_m408255_read_text_word(void) { check_reader(m408255_read_text_word, 0x1cc, 0x5ec298); }
static void test_m408290_read_text_word(void) { check_reader(m408290_read_text_word, 0x20c, 0x5ec29a); }
static void test_m4082cb_read_text_word(void) { check_reader(m4082cb_read_text_word, 0x24c, 0x5ec29c); }
static void test_m408306_read_text_word(void) { check_reader(m408306_read_text_word, 0x28c, 0x5ec29e); }
static void test_m408341_read_text_word(void) { check_reader(m408341_read_text_word, 0x2cc, 0x5ec2a0); }
static void test_m40837c_read_text_word(void) { check_reader(m40837c_read_text_word, 0x30c, 0x5ec2a2); }
static void test_m4083b7_read_text_word(void) { check_reader(m4083b7_read_text_word, 0x34c, 0x5ec2a4); }
static void test_m4083f2_read_text_word(void) { check_reader(m4083f2_read_text_word, 0x38c, 0x5ec2a6); }
static void test_m40842d_read_text_word(void) { check_reader(m40842d_read_text_word, 0x3cc, 0x5ec2a8); }
static void test_m408468_read_text_word(void) { check_reader(m408468_read_text_word, 0x40c, 0x5ec2aa); }
static void test_m4084a3_read_text_word(void) { check_reader(m4084a3_read_text_word, 0x44c, 0x5ec2ac); }
static void test_m4084de_read_text_word(void) { check_reader(m4084de_read_text_word, 0x48c, 0x5ec2ae); }
static void test_m408519_read_text_word(void) { check_reader(m408519_read_text_word, 0x4cc, 0x5ec2b0); }
static void test_m408554_read_text_word(void) { check_reader(m408554_read_text_word, 0x50c, 0x5ec2b2); }
static void test_m40858f_read_text_word(void) { check_reader(m40858f_read_text_word, 0x54c, 0x5ec2b4); }
static void test_m4085ca_read_text_word(void) { check_reader(m4085ca_read_text_word, 0x58c, 0x5ec2b6); }
static void test_m408605_read_text_word(void) { check_reader(m408605_read_text_word, 0x5cc, 0x5ec2b8); }
static void test_m408640_read_text_word(void) { check_reader(m408640_read_text_word, 0x60c, 0x5ec2ba); }
static void test_m40867b_read_text_word(void) { check_reader(m40867b_read_text_word, 0x64c, 0x5ec2bc); }
static void test_m4086b6_read_text_word(void) { check_reader(m4086b6_read_text_word, 0x68c, 0x5ec2be); }
static void test_m4086f1_read_text_word(void) { check_reader(m4086f1_read_text_word, 0x6cc, 0x5ec2c0); }
static void test_m40872c_read_text_word(void) { check_reader(m40872c_read_text_word, 0x70c, 0x5ec2c2); }
static void test_m408767_read_text_word(void) { check_reader(m408767_read_text_word, 0x74c, 0x5ec2c4); }
static void test_m4087a2_read_text_word(void) { check_reader(m4087a2_read_text_word, 0x78c, 0x5ec2c6); }
static void test_m4087dd_read_text_word(void) { check_reader(m4087dd_read_text_word, 0x7cc, 0x5ec2c8); }
static void test_m408818_read_text_word(void) { check_reader(m408818_read_text_word, 0x80c, 0x5ec2ca); }
static void test_m408853_read_text_word(void) { check_reader(m408853_read_text_word, 0x84c, 0x5ec2cc); }
static void test_m40888e_read_text_word(void) { check_reader(m40888e_read_text_word, 0x88c, 0x5ec2ce); }
static void test_m4088c9_read_text_word(void) { check_reader(m4088c9_read_text_word, 0x8cc, 0x5ec2d0); }
static void test_m408904_read_text_word(void) { check_reader(m408904_read_text_word, 0x90c, 0x5ec2d2); }

/* ---- exact-size buffers (meant for the sanitiser builds: a store or a load outside the bytes the original touches is a report) ----------- */
static void test_exact_size_buffers(void)
{
    static const ReadFn fns[] = {m4080fc_toggle_5ec28c, m40812e_read_text_word, m408169_read_text_word, m4081a4_read_text_word, m4081df_read_text_word, m40821a_read_text_word, m408255_read_text_word, m408290_read_text_word, m4082cb_read_text_word, m408306_read_text_word, m408341_read_text_word, m40837c_read_text_word, m4083b7_read_text_word, m4083f2_read_text_word, m40842d_read_text_word, m408468_read_text_word, m4084a3_read_text_word, m4084de_read_text_word, m408519_read_text_word, m408554_read_text_word, m40858f_read_text_word, m4085ca_read_text_word, m408605_read_text_word, m408640_read_text_word, m40867b_read_text_word, m4086b6_read_text_word, m4086f1_read_text_word, m40872c_read_text_word, m408767_read_text_word, m4087a2_read_text_word, m4087dd_read_text_word, m408818_read_text_word, m408853_read_text_word, m40888e_read_text_word, m4088c9_read_text_word, m408904_read_text_word};
    size_t i;
    uint8_t *p;
    setup();
    /* none of the functions touches a byte of the object itself (the field address goes to the callee as a pointer) */
    for (i = 0; i < sizeof fns / sizeof fns[0]; i++) {
        p = (uint8_t *)malloc(1);
        CK(p != NULL);
        if (p == NULL) return;
        (void)fns[i](p, &g_w, &g_host);
        free(p);
    }
}

/* ---- bounded sweep ------------------------------------------------------------------------------------------------------------- */
static void test_sweep_bounded(void)
{
    static const ReadFn fns[] = {m4080fc_toggle_5ec28c, m40812e_read_text_word, m408169_read_text_word, m4081a4_read_text_word, m4081df_read_text_word, m40821a_read_text_word, m408255_read_text_word, m408290_read_text_word, m4082cb_read_text_word, m408306_read_text_word, m408341_read_text_word, m40837c_read_text_word, m4083b7_read_text_word, m4083f2_read_text_word, m40842d_read_text_word, m408468_read_text_word, m4084a3_read_text_word, m4084de_read_text_word, m408519_read_text_word, m408554_read_text_word, m40858f_read_text_word, m4085ca_read_text_word, m408605_read_text_word, m408640_read_text_word, m40867b_read_text_word, m4086b6_read_text_word, m4086f1_read_text_word, m40872c_read_text_word, m408767_read_text_word, m4087a2_read_text_word, m4087dd_read_text_word, m408818_read_text_word, m408853_read_text_word, m40888e_read_text_word, m4088c9_read_text_word, m408904_read_text_word};
    unsigned seed = 4242;
    int n, i;
    size_t f;
    for (n = 0; n < 300 && !g_failed; n++) {
        setup();
        for (i = 0; i < SELF_SIZE; i++) {
            seed = seed * 1103515245u + 12345u;
            g_self[i] = (uint8_t)(seed >> 16);
        }
        for (i = 0; i < 16; i++) {
            seed = seed * 1103515245u + 12345u;
            g_fill[i % 0x14] = (uint8_t)(seed >> 16);
        }
        g_atoi = seed;
        g_ret = seed >> 3;
        for (f = 0; f < sizeof fns / sizeof fns[0]; f++) {
            L.n = 0;
            fns[f](SELF, &g_w, &g_host);
        }
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
    RUN(test_m4080fc_toggle_5ec28c);
    RUN(test_m40812e_read_text_word);
    RUN(test_m408169_read_text_word);
    RUN(test_m4081a4_read_text_word);
    RUN(test_m4081df_read_text_word);
    RUN(test_m40821a_read_text_word);
    RUN(test_m408255_read_text_word);
    RUN(test_m408290_read_text_word);
    RUN(test_m4082cb_read_text_word);
    RUN(test_m408306_read_text_word);
    RUN(test_m408341_read_text_word);
    RUN(test_m40837c_read_text_word);
    RUN(test_m4083b7_read_text_word);
    RUN(test_m4083f2_read_text_word);
    RUN(test_m40842d_read_text_word);
    RUN(test_m408468_read_text_word);
    RUN(test_m4084a3_read_text_word);
    RUN(test_m4084de_read_text_word);
    RUN(test_m408519_read_text_word);
    RUN(test_m408554_read_text_word);
    RUN(test_m40858f_read_text_word);
    RUN(test_m4085ca_read_text_word);
    RUN(test_m408605_read_text_word);
    RUN(test_m408640_read_text_word);
    RUN(test_m40867b_read_text_word);
    RUN(test_m4086b6_read_text_word);
    RUN(test_m4086f1_read_text_word);
    RUN(test_m40872c_read_text_word);
    RUN(test_m408767_read_text_word);
    RUN(test_m4087a2_read_text_word);
    RUN(test_m4087dd_read_text_word);
    RUN(test_m408818_read_text_word);
    RUN(test_m408853_read_text_word);
    RUN(test_m40888e_read_text_word);
    RUN(test_m4088c9_read_text_word);
    RUN(test_m408904_read_text_word);
    RUN(test_exact_size_buffers);
    RUN(test_sweep_bounded);
    return failures;
}
