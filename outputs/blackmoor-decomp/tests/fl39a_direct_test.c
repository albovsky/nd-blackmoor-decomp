/* FL-39 (batch a) direct tests of the 28 GAME.EXE functions in src/original_methods_fl39a.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl39a_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl39a.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define UNUSED_FN __attribute__((unused))

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
static uint8_t g_self[SELF_SIZE];
#define SELF g_self
static Fl18Host g_host;
static Fl39aWorld g_w;

UNUSED_FN static void put32(uint8_t *p, size_t off, uint32_t v)
{
    p[off] = (uint8_t)v;
    p[off + 1] = (uint8_t)(v >> 8);
    p[off + 2] = (uint8_t)(v >> 16);
    p[off + 3] = (uint8_t)(v >> 24);
}

UNUSED_FN static void put16(uint8_t *p, size_t off, uint16_t v)
{
    p[off] = (uint8_t)v;
    p[off + 1] = (uint8_t)(v >> 8);
}

UNUSED_FN static uint32_t get32(const uint8_t *p, size_t off)
{
    return (uint32_t)p[off] | (uint32_t)p[off + 1] << 8 | (uint32_t)p[off + 2] << 16 | (uint32_t)p[off + 3] << 24;
}

#define MAXCALL 16
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[8];
        uint32_t first_dword;   /* the dword at [this] at the call (host pointers only) */
    } c[MAXCALL];
} L;
static uint32_t g_ret;           /* the answer of every callee without an entry in g_ans */
#define MAXANS 8
static struct {
    int n;
    uint32_t callee[MAXANS], value[MAXANS];
} g_ans;                         /* per-callee answers: the callee, and the value it returns (every call) */

/* regions of fake original memory behind addresses: {address, host pointer, length} */
static struct {
    int n;
    struct {
        uint32_t va;
        uint8_t *p;
        uint32_t len;
    } r[8];
} g_reg;

UNUSED_FN static void answer(uint32_t callee, uint32_t value)
{
    g_ans.callee[g_ans.n] = callee;
    g_ans.value[g_ans.n++] = value;
}

UNUSED_FN static void region_add(uint32_t va, uint8_t *p, uint32_t len)
{
    g_reg.r[g_reg.n].va = va;
    g_reg.r[g_reg.n].p = p;
    g_reg.r[g_reg.n++].len = len;
}

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int k, i = L.n;
    (void)ctx;
    if (L.n < MAXCALL) {
        L.c[i].callee = callee;
        L.c[i].this_ptr = this_ptr;
        L.c[i].nargs = nargs;
        for (k = 0; k < nargs && k < 8; k++) L.c[i].a[k] = args[k];
        L.c[i].first_dword = this_ptr > 0xffffffffu ? get32((const uint8_t *)this_ptr, 0) : 0;
    }
    L.n++;
    for (k = 0; k < g_ans.n; k++)
        if (g_ans.callee[k] == callee) return g_ans.value[k];
    return g_ret;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    int k;
    (void)ctx;
    for (k = 0; k < g_reg.n; k++)
        if (a >= g_reg.r[k].va && a < g_reg.r[k].va + g_reg.r[k].len) return g_reg.r[k].p + (a - g_reg.r[k].va);
    return NULL;
}

static void setup(void)
{
    size_t i;
    for (i = 0; i < SELF_SIZE; i++) g_self[i] = (uint8_t)(i * 7 + 3);
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    L.n = 0;
    g_ret = 0;
    g_ans.n = 0;
    g_reg.n = 0;
}

static const uint32_t RETS[] UNUSED_FN = {0, 0x80000000u, 0xcafef00du, 0xffffffffu};
#define NRETS (sizeof RETS / sizeof RETS[0])

static uint8_t g_tbl[0x4a * 0x70];
static uint8_t g_tbl0[sizeof g_tbl];
static void tbl_fill(void)
{
    memset(g_tbl, 0x55, sizeof g_tbl);
    memcpy(g_tbl0, g_tbl, sizeof g_tbl);
    memset(&g_w, 0, sizeof g_w);
    g_w.table_5d15a5 = g_tbl + 3 * 0x4a;
}
/* the table is unchanged except the dword at record i (relative to the world's index 0) = 1 (i = 99: unchanged altogether) */
static int tbl_is(int i)
{
    uint8_t want[sizeof g_tbl];
    memcpy(want, g_tbl0, sizeof want);
    if (i != 99) put32(want, (size_t)(3 + i) * 0x4a, 1);
    return memcmp(want, g_tbl, sizeof want) == 0;
}
typedef void (*MarkFn)(const uint8_t *, const Fl39aWorld *);
/* `gate` bytes at [self+gate_off] must be non-zero and the signed word at [self+word_off] must not be -1; then dword [0x5d15a5 + word * 0x4a] = 1.
 * The object is an exactly sized heap block so that a sanitiser reports a read outside the bytes the function touches. */
static void check_mark(MarkFn fn, size_t gate_off, int gate_bytes, size_t word_off)
{
    size_t need = gate_off + (size_t)gate_bytes, i;
    uint8_t *s;
    static const uint16_t words[] = {3, 0xfffe, 0xfffd, 0, 0x2a, 0x40};
    setup();
    if (word_off + 2 > need) need = word_off + 2;
    s = (uint8_t *)malloc(need);
    CK(s != NULL);
    if (s == NULL) return;
    memset(s, 0x33, need);
    tbl_fill();
    if (gate_bytes == 4) put32(s, gate_off, 0); else s[gate_off] = 0;
    put16(s, word_off, 3);
    fn(s, &g_w);
    CK(tbl_is(99));                                 /* the gate is 0: nothing */
    if (gate_bytes == 4) put32(s, gate_off, 0x10000u); else s[gate_off] = 0x80;
    put16(s, word_off, 0xffff);
    fn(s, &g_w);
    CK(tbl_is(99));                                 /* word -1: nothing */
    for (i = 0; i < sizeof words / sizeof words[0] && !g_failed; i++) {
        tbl_fill();
        if (gate_bytes == 4) put32(s, gate_off, i % 2 ? 0x80000000u : 1u); else s[gate_off] = i % 2 ? 0xff : 1;
        put16(s, word_off, words[i]);
        fn(s, &g_w);
        CK(tbl_is((int)(int16_t)words[i]));        /* the word is sign-extended: -2 and -3 are indexes, not the sentinel */
    }
    CK(L.n == 0);
    free(s);
}

typedef uint32_t (*G73Fn)(uint8_t *, const Fl18Host *);
/* [self+g] != 0: 0x4c2dfb on the singleton 0x5cf659 with (self + g); the signed word [self+w] != -1: c2(word, pushed as a dword whose upper half is left-over);
 * then c3(self); the result is the eax of c3. The object is an exactly sized heap block. */
static void check_g73(G73Fn fn, size_t g, size_t w, uint32_t c2, uint32_t c3)
{
    size_t need = g + 4 > w + 2 ? g + 4 : w + 2, k;
    uint8_t *s;
    static const uint16_t words[] = {0xffff, 0, 0xfffe, 0x7fff, 0x8000, 0x1234};
    setup();
    s = (uint8_t *)malloc(need);
    CK(s != NULL);
    if (s == NULL) return;
    for (k = 0; k < 4 * 6 && !g_failed; k++) {
        const int gate = (k & 1) != 0, hasw = words[k >> 2] != 0xffff;
        uint32_t ret;
        setup();
        memset(s, 0x33, need);
        put32(s, g, gate ? (k & 2 ? 0x80000000u : 0x10000u) : 0);
        put16(s, w, words[k >> 2]);
        g_ret = RETS[k & 3];
        ret = fn(s, &g_host);
        CK(ret == RETS[k & 3]);
        CK(L.n == (gate ? 1 : 0) + (hasw ? 1 : 0) + 1);
        {
            int at = 0;
            if (gate) {
                CK(L.c[at].callee == 0x4c2dfb && L.c[at].this_ptr == 0x5cf659 && L.c[at].nargs == 1 && L.c[at].a[0] == (uintptr_t)(s + g));
                at++;
            }
            if (hasw) {
                CK(L.c[at].callee == c2 && L.c[at].this_ptr == 0 && L.c[at].nargs == 1 && (L.c[at].a[0] & 0xffff) == words[k >> 2]);
                at++;
            }
            CK(L.c[at].callee == c3 && L.c[at].this_ptr == (uintptr_t)s && L.c[at].nargs == 0);
        }
        CK(get32(s, g) == (gate ? (k & 2 ? 0x80000000u : 0x10000u) : 0) && get32(s, w) >> 16 != 1);
    }
    free(s);
}

typedef uint32_t (*DtorEhFn)(uint8_t *, const Fl18Host *);
static void check_dtoreh(DtorEhFn fn, uint32_t vtbl, uint32_t c1, uint32_t c2)
{
    uint8_t want[SELF_SIZE];
    uint32_t old;
    size_t k;
    for (k = 0; k < NRETS && !g_failed; k++) {
        setup();
        memcpy(want, SELF, sizeof want);
        old = get32(SELF, 0);
        put32(want, 0, vtbl);
        g_ret = RETS[k];
        CK(fn(SELF, &g_host) == RETS[k]);
        CK(L.n == 2);
        CK(L.c[0].callee == c1 && L.c[0].this_ptr == (uintptr_t)SELF && L.c[0].nargs == 0 && L.c[0].first_dword == vtbl && old != vtbl);
        CK(L.c[1].callee == c2 && L.c[1].this_ptr == (uintptr_t)SELF && L.c[1].nargs == 0 && L.c[1].first_dword == vtbl);
        CK(memcmp(SELF, want, sizeof want) == 0);
    }
}

static void test_m48220e_mark_entry(void)
{
    check_mark(m48220e_mark_entry, 0xa8, 1, 0x1c);
}

static void test_m487b4f_release_entry(void)
{
    check_g73(m487b4f_release_entry, 0x20, 0x1c, 0x4d3992, 0x487b1a);
}

static void test_m487b98_mark_entry(void)
{
    check_mark(m487b98_mark_entry, 0x71, 4, 0x1c);
}

static void test_m48a7e5_release_entry(void)
{
    check_g73(m48a7e5_release_entry, 0x20, 0x1c, 0x4d3992, 0x48a70a);
}

static void test_m48a82e_mark_entry(void)
{
    check_mark(m48a82e_mark_entry, 0x1aa, 4, 0x1c);
}

static void test_m48e393_mark_entry(void)
{
    check_mark(m48e393_mark_entry, 0x462, 4, 0x1c);
}

static void test_m490547_destroy_with_frame(void)
{
    check_dtoreh(m490547_destroy_with_frame, 0x52daf8u, 0x490d50, 0x51d730);
}

static void test_m493a10_mark_entry(void)
{
    check_mark(m493a10_mark_entry, 0x1f77, 4, 0x1c);
}

static void test_m49c59f_destroy_with_frame(void)
{
    check_dtoreh(m49c59f_destroy_with_frame, 0x52dbc8u, 0x49c68a, 0x51d730);
}

static void test_m4a1ce0_mark_entry(void)
{
    check_mark(m4a1ce0_mark_entry, 0x60, 4, 0x1c);
}

static void test_m4a3910_mark_entry(void)
{
    check_mark(m4a3910_mark_entry, 0x26e, 4, 0x1c);
}

static void test_m4a6477_mark_entry(void)
{
    check_mark(m4a6477_mark_entry, 0x86, 4, 0x1c);
}

static void test_m4a7da5_mark_entry(void)
{
    check_mark(m4a7da5_mark_entry, 0xe72, 4, 0x1c);
}

static void test_m4a9fcb_mark_entry(void)
{
    check_mark(m4a9fcb_mark_entry, 0x45, 1, 0x29);
}

static void test_m4ab3dc_release_entry(void)
{
    check_g73(m4ab3dc_release_entry, 0x20, 0x1c, 0x4d3992, 0x4ab3a7);
}

static void test_m4ab425_mark_entry(void)
{
    check_mark(m4ab425_mark_entry, 0x54, 4, 0x1c);
}

static void test_m4acbba_mark_entry(void)
{
    check_mark(m4acbba_mark_entry, 0xc1b, 4, 0x1c);
}

static void test_m4afd7e_release_entry(void)
{
    check_g73(m4afd7e_release_entry, 0x20, 0x1c, 0x4d3992, 0x4afd3a);
}

static void test_m4afdc7_mark_entry(void)
{
    check_mark(m4afdc7_mark_entry, 0x1515, 4, 0x1c);
}

static void test_m4b3d4d_release_entry(void)
{
    check_g73(m4b3d4d_release_entry, 0x754, 0x726, 0x4d3992, 0x4b3c5a);
}

static void test_m4b3da2_mark_entry(void)
{
    check_mark(m4b3da2_mark_entry, 0x76e, 4, 0x726);
}

static void test_m4b7229_release_entry(void)
{
    check_g73(m4b7229_release_entry, 0x1d, 0x2f, 0x4d3992, 0x4b71f7);
}

static void test_m4b7272_mark_entry(void)
{
    check_mark(m4b7272_mark_entry, 0x35, 1, 0x2f);
}

static void test_m4ba22e_mark_entry(void)
{
    check_mark(m4ba22e_mark_entry, 0x34, 4, 0x4);
}

static void test_m4cafc1_mark_entry(void)
{
    check_mark(m4cafc1_mark_entry, 0xe, 4, 0xc);
}

static void test_m4dbf6e_destroy_with_frame(void)
{
    check_dtoreh(m4dbf6e_destroy_with_frame, 0x52e478u, 0x4dc043, 0x51d730);
}

static void test_m4de1a4_destroy_with_frame(void)
{
    check_dtoreh(m4de1a4_destroy_with_frame, 0x52e4ccu, 0x4de214, 0x4eda7c);
}

static void test_m4e7684_destroy_with_frame(void)
{
    check_dtoreh(m4e7684_destroy_with_frame, 0x52e4f0u, 0x4e76ed, 0x4eda7c);
}

#define RUN(fn)                                                                \
    do {                                                                       \
        g_failed = 0;                                                          \
        g_msg[0] = 0;                                                          \
        fn();                                                                  \
        if (g_failed) {                                                        \
            printf("FAIL %s: %s\n", #fn, g_msg);                               \
            failures++;                                                        \
        } else {                                                               \
            printf("PASS %s\n", #fn);                                           \
        }                                                                      \
    } while (0)

int main(void)
{
    int failures = 0;
    RUN(test_m48220e_mark_entry);
    RUN(test_m487b4f_release_entry);
    RUN(test_m487b98_mark_entry);
    RUN(test_m48a7e5_release_entry);
    RUN(test_m48a82e_mark_entry);
    RUN(test_m48e393_mark_entry);
    RUN(test_m490547_destroy_with_frame);
    RUN(test_m493a10_mark_entry);
    RUN(test_m49c59f_destroy_with_frame);
    RUN(test_m4a1ce0_mark_entry);
    RUN(test_m4a3910_mark_entry);
    RUN(test_m4a6477_mark_entry);
    RUN(test_m4a7da5_mark_entry);
    RUN(test_m4a9fcb_mark_entry);
    RUN(test_m4ab3dc_release_entry);
    RUN(test_m4ab425_mark_entry);
    RUN(test_m4acbba_mark_entry);
    RUN(test_m4afd7e_release_entry);
    RUN(test_m4afdc7_mark_entry);
    RUN(test_m4b3d4d_release_entry);
    RUN(test_m4b3da2_mark_entry);
    RUN(test_m4b7229_release_entry);
    RUN(test_m4b7272_mark_entry);
    RUN(test_m4ba22e_mark_entry);
    RUN(test_m4cafc1_mark_entry);
    RUN(test_m4dbf6e_destroy_with_frame);
    RUN(test_m4de1a4_destroy_with_frame);
    RUN(test_m4e7684_destroy_with_frame);
    return failures;
}
