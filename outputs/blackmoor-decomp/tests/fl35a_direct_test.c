/* FL-35 (batch a) direct tests of the 28 tag readers of GAME.EXE in src/original_methods_fl35a.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl35a_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl35a.h"

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
#define FIRST_WORD 0x5ec2d6
#define LAST_CALLEE 0x4090ab
static uint8_t g_self[SELF_SIZE];
static Fl35aWorld g_w;
static Fl18Host g_host;
#define SELF g_self
#define NW (sizeof(Fl35aWorld) / 2)
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

static uint8_t g_tags[0x78];          /* the original addresses 0x53ec58 .. 0x53ecd0 */

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (a >= 0x53ec58 && a < 0x53ec58 + sizeof g_tags) return g_tags + (a - 0x53ec58);
    return NULL;
}

static void setup(void)
{
    size_t i;
    for (i = 0; i < SELF_SIZE; i++) g_self[i] = (uint8_t)(i * 7 + 3);
    for (i = 0; i < sizeof g_tags; i++) g_tags[i] = (uint8_t)(0x41 + ((i / 4) * 5 + (i % 4) * 3) % 50);       /* every 4-byte tag differs from its neighbours */
    memset(&g_w, 0, sizeof g_w);
    for (i = 0; i < NW; i++) WORDS[i] = (uint16_t)(0x1000 + i * 0x111);
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    L.n = 0;
    g_atoi = g_ret = 0;
    memset(g_fill, 0x5a, sizeof g_fill);
}

typedef uint32_t (*TagFn)(uint8_t *, Fl35aWorld *, const Fl18Host *);

/* `field` is the string field offset, `tag` the original address of the tag, `word` the original address of the word that is stored */
static void check_tag_fn(TagFn fn, size_t field, uint32_t tag, uint32_t word)
{
    uint16_t want[NW];
    size_t slot = (word - FIRST_WORD) / 2;
    const uint8_t *mine = g_tags + (tag - 0x53ec58);
    uint8_t other[4];
    int pos;
    uint8_t before[0x40];
    setup();
    memcpy(before, SELF, sizeof before);
    memcpy(want, &g_w, sizeof want);

    /* the four bytes equal the tag: 0x51d5b2 then 0x4090ab only; the byte behind the tag is different (a fifth compared byte would mismatch) */
    memcpy(g_fill, mine, 4);
    g_fill[4] = 0x01;
    g_ret = 0xcafef00du;
    g_atoi = 0x1234abcdu;
    CK(fn(SELF, &g_w, &g_host) == 0xcafef00du);
    CK(L.n == 2);
    CK(L.c[0].callee == 0x51d5b2 && L.c[0].this_ptr == (uintptr_t)(SELF + field) && L.c[0].nargs == 2 && L.c[0].a[1] == 0x13 && L.c[0].a[0] != 0);
    CK(L.c[1].callee == 0x4090ab && L.c[1].this_ptr == (uintptr_t)SELF && L.c[1].nargs == 0);
    CK(memcmp(&g_w, want, sizeof want) == 0);
    CK(memcmp(SELF, before, sizeof before) == 0 && SELF[0x300] == (uint8_t)(0x300 * 7 + 3));

    /* a difference at each position (the others equal, or random behind it): 0x50cb1b(buf) and a word store of its low 16 bits BEFORE the last call */
    for (pos = 0; pos < 4 && !g_failed; pos++) {
        setup();
        memcpy(g_fill, mine, 4);
        g_fill[pos] ^= 0x20;
        memset(g_fill + 4, 0x31, 0x10);
        g_atoi = 0x1234abcdu;
        g_ret = 0xcafef00du;
        CK(fn(SELF, &g_w, &g_host) == 0xcafef00du);
        CK(L.n == 3);
        CK(L.c[0].callee == 0x51d5b2 && L.c[1].callee == 0x50cb1b && L.c[2].callee == 0x4090ab);
        CK(L.c[1].this_ptr == 0 && L.c[1].nargs == 1 && L.c[1].a[0] == L.c[0].a[0]);        /* the same buffer */
        CK(memcmp(L.c[1].buf, g_fill, 0x14) == 0);                                           /* the buffer is passed unchanged */
        {
            size_t i;
            for (i = 0; i < NW; i++) want[i] = (uint16_t)(0x1000 + i * 0x111);
        }
        CK(memcmp(L.c[1].words, want, sizeof want) == 0);                                      /* nothing is stored before 0x50cb1b */
        want[slot] = 0xabcd;
        CK(memcmp(L.c[2].words, want, sizeof want) == 0);                                      /* the low word is stored before the last call, nothing else */
        CK(memcmp(&g_w, want, sizeof want) == 0);
        CK(L.c[2].this_ptr == (uintptr_t)SELF);
    }
    /* the neighbouring row's tag is not this function's tag: a buffer equal to it differs here */
    setup();
    memcpy(other, tag + 4 < 0x53ecd0 ? g_tags + (tag - 0x53ec58) + 4 : g_tags + (tag - 0x53ec58) - 4, 4);
    memcpy(g_fill, other, 4);
    g_atoi = 0xffff8001u;
    CK(fn(SELF, &g_w, &g_host) == 0);
    CK(L.n == 3 && L.c[1].callee == 0x50cb1b);
    CK(WORDS[slot] == 0x8001);
}

static void test_m40a5c1_read_tag_word(void) { check_tag_fn(m40a5c1_read_tag_word, 0x8c, 0x53ec58, 0x5ec2d6); }
static void test_m40a6b7_read_tag_word(void) { check_tag_fn(m40a6b7_read_tag_word, 0x14c, 0x53ec64, 0x5ec2dc); }
static void test_m40a709_read_tag_word(void) { check_tag_fn(m40a709_read_tag_word, 0x18c, 0x53ec68, 0x5ec2de); }
static void test_m40a75b_read_tag_word(void) { check_tag_fn(m40a75b_read_tag_word, 0x1cc, 0x53ec6c, 0x5ec2e0); }
static void test_m40a7ad_read_tag_word(void) { check_tag_fn(m40a7ad_read_tag_word, 0x20c, 0x53ec70, 0x5ec2e2); }
static void test_m40a7ff_read_tag_word(void) { check_tag_fn(m40a7ff_read_tag_word, 0x24c, 0x53ec74, 0x5ec2e4); }
static void test_m40a851_read_tag_word(void) { check_tag_fn(m40a851_read_tag_word, 0x28c, 0x53ec78, 0x5ec2e6); }
static void test_m40a8a3_read_tag_word(void) { check_tag_fn(m40a8a3_read_tag_word, 0x2cc, 0x53ec7c, 0x5ec2e8); }
static void test_m40a8f5_read_tag_word(void) { check_tag_fn(m40a8f5_read_tag_word, 0x30c, 0x53ec80, 0x5ec2ea); }
static void test_m40a947_read_tag_word(void) { check_tag_fn(m40a947_read_tag_word, 0x34c, 0x53ec84, 0x5ec2ec); }
static void test_m40a999_read_tag_word(void) { check_tag_fn(m40a999_read_tag_word, 0x38c, 0x53ec88, 0x5ec2ee); }
static void test_m40a9eb_read_tag_word(void) { check_tag_fn(m40a9eb_read_tag_word, 0x3cc, 0x53ec8c, 0x5ec2f0); }
static void test_m40aa3d_read_tag_word(void) { check_tag_fn(m40aa3d_read_tag_word, 0x40c, 0x53ec90, 0x5ec2f2); }
static void test_m40aa8f_read_tag_word(void) { check_tag_fn(m40aa8f_read_tag_word, 0x44c, 0x53ec94, 0x5ec2f4); }
static void test_m40aae1_read_tag_word(void) { check_tag_fn(m40aae1_read_tag_word, 0x48c, 0x53ec98, 0x5ec2f6); }
static void test_m40ab33_read_tag_word(void) { check_tag_fn(m40ab33_read_tag_word, 0x4cc, 0x53ec9c, 0x5ec2f8); }
static void test_m40ab85_read_tag_word(void) { check_tag_fn(m40ab85_read_tag_word, 0x50c, 0x53eca0, 0x5ec2fa); }
static void test_m40abd7_read_tag_word(void) { check_tag_fn(m40abd7_read_tag_word, 0x54c, 0x53eca4, 0x5ec2fc); }
static void test_m40ac29_read_tag_word(void) { check_tag_fn(m40ac29_read_tag_word, 0x58c, 0x53eca8, 0x5ec2fe); }
static void test_m40ac7b_read_tag_word(void) { check_tag_fn(m40ac7b_read_tag_word, 0x5cc, 0x53ecac, 0x5ec300); }
static void test_m40accd_read_tag_word(void) { check_tag_fn(m40accd_read_tag_word, 0x60c, 0x53ecb0, 0x5ec302); }
static void test_m40ad1f_read_tag_word(void) { check_tag_fn(m40ad1f_read_tag_word, 0x64c, 0x53ecb4, 0x5ec304); }
static void test_m40ad71_read_tag_word(void) { check_tag_fn(m40ad71_read_tag_word, 0x68c, 0x53ecb8, 0x5ec306); }
static void test_m40adc3_read_tag_word(void) { check_tag_fn(m40adc3_read_tag_word, 0x6cc, 0x53ecbc, 0x5ec308); }
static void test_m40ae15_read_tag_word(void) { check_tag_fn(m40ae15_read_tag_word, 0x70c, 0x53ecc0, 0x5ec30a); }
static void test_m40ae67_read_tag_word(void) { check_tag_fn(m40ae67_read_tag_word, 0x74c, 0x53ecc4, 0x5ec30c); }
static void test_m40aeb9_read_tag_word(void) { check_tag_fn(m40aeb9_read_tag_word, 0x78c, 0x53ecc8, 0x5ec30e); }
static void test_m40af0b_read_tag_word(void) { check_tag_fn(m40af0b_read_tag_word, 0x7cc, 0x53eccc, 0x5ec310); }

/* ---- exact-size buffers (meant for the sanitiser builds: a store or a load outside the bytes the original touches is a report) ----------- */
static void test_exact_size_buffers(void)
{
    static const TagFn fns[] = {m40a5c1_read_tag_word, m40a6b7_read_tag_word, m40a709_read_tag_word, m40a75b_read_tag_word, m40a7ad_read_tag_word, m40a7ff_read_tag_word, m40a851_read_tag_word, m40a8a3_read_tag_word, m40a8f5_read_tag_word, m40a947_read_tag_word, m40a999_read_tag_word, m40a9eb_read_tag_word, m40aa3d_read_tag_word, m40aa8f_read_tag_word, m40aae1_read_tag_word, m40ab33_read_tag_word, m40ab85_read_tag_word, m40abd7_read_tag_word, m40ac29_read_tag_word, m40ac7b_read_tag_word, m40accd_read_tag_word, m40ad1f_read_tag_word, m40ad71_read_tag_word, m40adc3_read_tag_word, m40ae15_read_tag_word, m40ae67_read_tag_word, m40aeb9_read_tag_word, m40af0b_read_tag_word};
    size_t i;
    uint8_t *p;
    setup();
    /* the rows touch no byte of the object themselves (the field address goes to the callee as a pointer) and only four bytes of each tag */
    for (i = 0; i < sizeof fns / sizeof fns[0]; i++) {
        p = (uint8_t *)malloc(1);
        CK(p != NULL);
        if (p == NULL) return;
        g_fill[0] = (uint8_t)i;
        (void)fns[i](p, &g_w, &g_host);
        free(p);
    }
}

/* ---- bounded sweep ------------------------------------------------------------------------------------------------------------- */
static void test_sweep_bounded(void)
{
    static const TagFn fns[] = {m40a5c1_read_tag_word, m40a6b7_read_tag_word, m40a709_read_tag_word, m40a75b_read_tag_word, m40a7ad_read_tag_word, m40a7ff_read_tag_word, m40a851_read_tag_word, m40a8a3_read_tag_word, m40a8f5_read_tag_word, m40a947_read_tag_word, m40a999_read_tag_word, m40a9eb_read_tag_word, m40aa3d_read_tag_word, m40aa8f_read_tag_word, m40aae1_read_tag_word, m40ab33_read_tag_word, m40ab85_read_tag_word, m40abd7_read_tag_word, m40ac29_read_tag_word, m40ac7b_read_tag_word, m40accd_read_tag_word, m40ad1f_read_tag_word, m40ad71_read_tag_word, m40adc3_read_tag_word, m40ae15_read_tag_word, m40ae67_read_tag_word, m40aeb9_read_tag_word, m40af0b_read_tag_word};
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
            if (i < 4 && (seed & 1)) g_fill[i] = g_tags[(seed >> 8) % 0x78];
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
    RUN(test_m40a5c1_read_tag_word);
    RUN(test_m40a6b7_read_tag_word);
    RUN(test_m40a709_read_tag_word);
    RUN(test_m40a75b_read_tag_word);
    RUN(test_m40a7ad_read_tag_word);
    RUN(test_m40a7ff_read_tag_word);
    RUN(test_m40a851_read_tag_word);
    RUN(test_m40a8a3_read_tag_word);
    RUN(test_m40a8f5_read_tag_word);
    RUN(test_m40a947_read_tag_word);
    RUN(test_m40a999_read_tag_word);
    RUN(test_m40a9eb_read_tag_word);
    RUN(test_m40aa3d_read_tag_word);
    RUN(test_m40aa8f_read_tag_word);
    RUN(test_m40aae1_read_tag_word);
    RUN(test_m40ab33_read_tag_word);
    RUN(test_m40ab85_read_tag_word);
    RUN(test_m40abd7_read_tag_word);
    RUN(test_m40ac29_read_tag_word);
    RUN(test_m40ac7b_read_tag_word);
    RUN(test_m40accd_read_tag_word);
    RUN(test_m40ad1f_read_tag_word);
    RUN(test_m40ad71_read_tag_word);
    RUN(test_m40adc3_read_tag_word);
    RUN(test_m40ae15_read_tag_word);
    RUN(test_m40ae67_read_tag_word);
    RUN(test_m40aeb9_read_tag_word);
    RUN(test_m40af0b_read_tag_word);
    RUN(test_exact_size_buffers);
    RUN(test_sweep_bounded);
    return failures;
}
