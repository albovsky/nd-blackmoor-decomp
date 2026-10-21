/* FL-32 (batch b) direct tests of the small functions of GAME.EXE in src/original_methods_fl32b.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl32b_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl32b.h"

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

#define SELF_SIZE 0x1800
static uint8_t g_self[SELF_SIZE];
static uint8_t g_tags[0x10];          /* the original addresses 0x53ec58 .. 0x53ec68 */
static Fl32bWorld g_w;
static Fl18Host g_host;
#define SELF g_self

static void set32(uint8_t *b, size_t off, uint32_t v) { memcpy(b + off, &v, 4); }
static void set16(uint8_t *b, size_t off, uint16_t v) { memcpy(b + off, &v, 2); }

#define MAXCALL 16
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[4];
        uint16_t words[4];       /* the world words at the call */
        uint8_t buf[0x14];       /* the 0x14 bytes behind the first argument at the call (0x50cb1b, 0x51d5b2 after it ran: only logged for 0x50cb1b) */
    } c[MAXCALL];
} L;
static uint8_t g_fill[0x14];      /* what 0x51d5b2 writes into the buffer */
static uint32_t g_atoi, g_ret;    /* the answers of 0x50cb1b and 0x4090ab */

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
    if (callee == 0x4090ab) return g_ret;
    return 0x66666666u;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (a >= 0x53ec58 && a < 0x53ec68) return g_tags + (a - 0x53ec58);
    return NULL;
}

static void setup(void)
{
    size_t i;
    for (i = 0; i < SELF_SIZE; i++) g_self[i] = (uint8_t)(i * 7 + 3);
    memset(g_tags, 0, sizeof g_tags);
    memcpy(g_tags + 4, "XYZ", 4);       /* the tag at 0x53ec5c: X Y Z NUL */
    memcpy(g_tags + 8, "PQR", 4);       /* the tag at 0x53ec60: P Q R NUL */
    g_tags[0] = g_tags[1] = g_tags[2] = g_tags[3] = 'w';
    g_tags[12] = g_tags[13] = g_tags[14] = g_tags[15] = 'v';
    memset(&g_w, 0, sizeof g_w);
    g_w.word_5ec2d6 = 0x1111;
    g_w.word_5ec2d8 = 0x2222;
    g_w.word_5ec2da = 0x3333;
    g_w.word_5ec2dc = 0x4444;
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    L.n = 0;
    g_atoi = g_ret = 0;
    memset(g_fill, 0x5a, sizeof g_fill);
}

/* ---- 0x40a613 and 0x40a665 ----------------------------------------------------------------------------------------------------- */
typedef uint32_t (*TagFn)(uint8_t *, Fl32bWorld *, const Fl18Host *);

/* `field` is 0xcc / 0x10c, `mine` / `other` the tags of the function and of its twin, `slot` the index of the word that is stored (1: 0x5ec2d8, 2: 0x5ec2da) */
static void check_tag_fn(TagFn fn, size_t field, const char *mine, const char *other, int slot)
{
    uint16_t want[4];
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
        want[0] = 0x1111;
        want[1] = 0x2222;
        want[2] = 0x3333;
        want[3] = 0x4444;
        CK(memcmp(L.c[1].words, want, sizeof want) == 0);                                      /* nothing is stored before 0x50cb1b */
        want[slot] = 0xabcd;
        CK(memcmp(L.c[2].words, want, sizeof want) == 0);                                      /* the low word is stored before the last call, nothing else */
        CK(memcmp(&g_w, want, sizeof want) == 0);
        CK(L.c[2].this_ptr == (uintptr_t)SELF);
    }
    /* the twin's tag is not this function's tag: a buffer equal to it differs here */
    setup();
    memcpy(g_fill, other, 4);
    g_atoi = 0xffff8001u;
    CK(fn(SELF, &g_w, &g_host) == 0);
    CK(L.n == 3 && L.c[1].callee == 0x50cb1b);
    CK(((uint16_t *)&g_w)[slot] == 0x8001);
}

static void test_m40a613_read_tag_word(void) { check_tag_fn(m40a613_read_tag_word, 0xcc, "XYZ", "PQR", 1); }
static void test_m40a665_read_tag_word(void) { check_tag_fn(m40a665_read_tag_word, 0x10c, "PQR", "XYZ", 2); }

/* ---- the straight-line field resets --------------------------------------------------------------------------------------------- */
typedef struct {
    unsigned off, size;
    uint32_t value;
} Store;

static void check_reset(uint8_t *(*fn)(uint8_t *), const Store *stores, int n)
{
    uint8_t want[SELF_SIZE];
    int i;
    setup();
    memset(SELF, 0xcc, SELF_SIZE);
    memcpy(want, SELF, sizeof want);
    for (i = 0; i < n; i++) {
        if (stores[i].size == 4) set32(want, stores[i].off, stores[i].value);
        else if (stores[i].size == 2) set16(want, stores[i].off, (uint16_t)stores[i].value);
        else want[stores[i].off] = (uint8_t)stores[i].value;
    }
    CK(fn(SELF) == SELF);                                               /* returns this */
    CK(memcmp(SELF, want, sizeof want) == 0);                           /* exactly these stores, nothing else */
    CK(L.n == 0);
    memset(SELF, 0, SELF_SIZE);
    fn(SELF);
    for (i = 0; i < n; i++)
        if (stores[i].value == 0xffffffffu || (stores[i].size == 2 && stores[i].value == 0xffffu)) {
            uint32_t v = 0;
            memcpy(&v, SELF + stores[i].off, stores[i].size);
            CK(v == (stores[i].size == 2 ? 0xffffu : 0xffffffffu));
        }
}

static void test_m4a9f27_reset_fields(void)
{
    static const Store s[] = {{0x21, 2, 0xffff}, {0x29, 2, 0xffff}, {0x1d, 4, 0}, {0x45, 1, 0}, {0x46, 1, 0}, {0x47, 1, 0}};
    check_reset(m4a9f27_reset_fields, s, 6);
}

static void test_m4b71f7_reset_fields(void)
{
    static const Store s[] = {{0x21, 2, 0xffff}, {0x2f, 2, 0xffff}, {0x35, 1, 0}, {0x36, 1, 0}, {0x3b, 1, 0}};
    check_reset(m4b71f7_reset_fields, s, 5);
}

static void test_m4781fa_reset_fields(void)
{
    static const Store s[] = {{0x1e, 2, 0xffff}, {0x1c, 2, 0xffff}, {0x157a, 4, 0}, {0x157e, 4, 0}, {0x1576, 4, 0}};
    check_reset(m4781fa_reset_fields, s, 5);
}

static void test_m4afd3a_reset_fields(void)
{
    static const Store s[] = {{0x1e, 2, 0xffff}, {0x1c, 2, 0xffff}, {0x1515, 4, 0}, {0x1519, 4, 0}, {0x151d, 4, 0}};
    check_reset(m4afd3a_reset_fields, s, 5);
}

static void test_m4e04f3_reset_fields(void)
{
    static const Store s[] = {{0xf2a, 4, 0}, {0x74f, 4, 0}, {0xf2e, 4, 0}, {0xf32, 4, 0xffffffffu}, {0xf36, 4, 0xffffffffu}};
    check_reset(m4e04f3_reset_fields, s, 5);
}

static void test_m4a638a_reset_fields(void)
{
    static const Store s[] = {{0x1e, 2, 0xffff}, {0x1c, 2, 0xffff}, {0x21, 4, 0}, {0x25, 4, 0}, {0x86, 4, 0}, {0x8a, 1, 0}, {0x8b, 1, 0}};
    check_reset(m4a638a_reset_fields, s, 7);
}

/* ---- 0x454565 ------------------------------------------------------------------------------------------------------------------ */
static int32_t cross(uint32_t ax, uint32_t ay, uint32_t bx, uint32_t by, uint32_t cx, uint32_t cy)
{
    uint8_t a[8], b[8], c[8], a0[8], b0[8], c0[8];
    int32_t r;
    set32(a, 0, ax); set32(a, 4, ay);
    set32(b, 0, bx); set32(b, 4, by);
    set32(c, 0, cx); set32(c, 4, cy);
    memcpy(a0, a, 8); memcpy(b0, b, 8); memcpy(c0, c, 8);
    r = m454565_cross_product(a, b, c);
    CK(memcmp(a, a0, 8) == 0 && memcmp(b, b0, 8) == 0 && memcmp(c, c0, 8) == 0);      /* the points are only read */
    return r;
}

static void test_m454565_cross_product(void)
{
    uint8_t p[8];
    setup();
    /* a (1,2), b (4,6), c (7,3): (4-1)*(3-2) - (7-1)*(6-2) = 3 - 24 */
    CK(cross(1, 2, 4, 6, 7, 3) == -21);
    CK(cross(1, 2, 7, 3, 4, 6) == 21);                              /* b and c swapped: the sign flips */
    CK(cross(10, 10, 5, 20, 20, 5) == -75);                         /* (-5)*(-5) - 10*10 */
    CK(cross(0, 0, 3, 0, 0, 5) == 15);                              /* the first product only: (3-0)*(5-0) - (0-0)*(0-0) */
    CK(cross(0, 0, 0, 5, 3, 0) == -15);                             /* the second product only: (0-0)*(0-0) - (3-0)*(5-0) */
    CK(cross(0, 0, 0x10000, 0, 0, 0x10000) == 0);                  /* 0x10000 * 0x10000 wraps to 0 */
    CK(cross(0, 0, 0x80000000u, 0, 0, 1) == INT32_MIN);             /* 0x80000000 * 1 */
    CK(cross(0, 0, 0x80000000u, 0, 0, 2) == 0);                     /* 0x80000000 * 2 wraps to 0 */
    CK(cross(0x7fffffffu, 0, 0x80000000u, 0, 0, 1) == 1);          /* (0x80000000 - 0x7fffffff) * 1 */
    CK(cross(5, 5, 5, 5, 9, 9) == 0);                               /* a == b */
    CK(cross(5, 5, 9, 9, 5, 5) == 0);                               /* a == c */
    CK(cross(5, 5, 9, 3, 9, 3) == 0);                               /* b == c */
    CK(cross(0xffffffffu, 0xffffffffu, 0, 0, 1, 1) == 0);           /* collinear through the wrap: (1)*(2) - (2)*(1) */
    CK(cross(2, 3, 11, 5, 4, 100) == 869);                          /* 9 * 97 - 2 * 2 */
    /* the same pointer for all three */
    set32(p, 0, 0xdeadbeefu);
    set32(p, 4, 0x12345678u);
    CK(m454565_cross_product(p, p, p) == 0);
}

/* ---- exact-size buffers (meant for the sanitiser builds: a store or a load outside the bytes the original touches is a report) ----------- */
static void test_exact_size_buffers(void)
{
    static const struct {
        uint8_t *(*fn)(uint8_t *);
        size_t size;      /* the highest offset + width that the original stores */
    } cases[] = {{m4a9f27_reset_fields, 0x48}, {m4b71f7_reset_fields, 0x3c}, {m4781fa_reset_fields, 0x1582}, {m4afd3a_reset_fields, 0x1521},
                 {m4e04f3_reset_fields, 0xf3a}, {m4a638a_reset_fields, 0x8c}};
    size_t i;
    uint8_t *p;
    setup();
    for (i = 0; i < sizeof cases / sizeof cases[0]; i++) {
        p = (uint8_t *)malloc(cases[i].size);
        CK(p != NULL);
        if (p == NULL) return;
        memset(p, 0x99, cases[i].size);
        CK(cases[i].fn(p) == p);
        free(p);
    }
    /* the points of 0x454565 are exactly eight bytes each */
    {
        uint8_t *a = (uint8_t *)malloc(8), *b = (uint8_t *)malloc(8), *c = (uint8_t *)malloc(8);
        CK(a != NULL && b != NULL && c != NULL);
        if (a != NULL && b != NULL && c != NULL) {
            memset(a, 1, 8);
            memset(b, 2, 8);
            memset(c, 3, 8);
            (void)m454565_cross_product(a, b, c);
        }
        free(a);
        free(b);
        free(c);
    }
    /* 0x40a613 / 0x40a665 touch no byte of the object themselves (the field address goes to the callee as a pointer) and only four bytes of each tag */
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p != NULL) {
        g_fill[0] = 1;
        (void)m40a613_read_tag_word(p, &g_w, &g_host);
        (void)m40a665_read_tag_word(p, &g_w, &g_host);
        free(p);
    }
}

/* CASES-END */

/* ---- bounded sweep ------------------------------------------------------------------------------------------------------------- */
static void test_sweep_bounded(void)
{
    unsigned seed = 4242;
    int n, i;
    for (n = 0; n < 300 && !g_failed; n++) {
        uint8_t pa[8], pb[8], pc[8];
        setup();
        for (i = 0; i < SELF_SIZE; i++) {
            seed = seed * 1103515245u + 12345u;
            g_self[i] = (uint8_t)(seed >> 16);
        }
        for (i = 0; i < 16; i++) {
            seed = seed * 1103515245u + 12345u;
            g_fill[i % 0x14] = (uint8_t)(seed >> 16);
            if (i < 4 && (seed & 1)) g_fill[i] = g_tags[4 + i];
        }
        g_atoi = seed;
        g_ret = seed >> 3;
        m40a613_read_tag_word(SELF, &g_w, &g_host);
        m40a665_read_tag_word(SELF, &g_w, &g_host);
        L.n = 0;
        m4a9f27_reset_fields(SELF);
        m4b71f7_reset_fields(SELF);
        m4781fa_reset_fields(SELF);
        m4afd3a_reset_fields(SELF);
        m4e04f3_reset_fields(SELF);
        m4a638a_reset_fields(SELF);
        memcpy(pa, g_self, 8);
        memcpy(pb, g_self + 8, 8);
        memcpy(pc, g_self + 16, 8);
        m454565_cross_product(pa, pb, pc);
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
    RUN(test_m40a613_read_tag_word);
    RUN(test_m40a665_read_tag_word);
    RUN(test_m4a9f27_reset_fields);
    RUN(test_m4b71f7_reset_fields);
    RUN(test_m4781fa_reset_fields);
    RUN(test_m4afd3a_reset_fields);
    RUN(test_m4e04f3_reset_fields);
    RUN(test_m454565_cross_product);
    RUN(test_m4a638a_reset_fields);
    /* RUN-END */
    RUN(test_exact_size_buffers);
    RUN(test_sweep_bounded);
    return failures;
}
