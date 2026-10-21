/* FL-36 (batch d) direct tests of the 97 GAME.EXE functions in src/original_methods_fl36d.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl36d_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl36d.h"

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

#define SELF_SIZE 0x200
static uint8_t g_self[SELF_SIZE];
#define SELF g_self
static Fl18Host g_host;

#define MAXCALL 8
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[2];
        uint32_t first_dword;   /* the dword at [this] at the call */
        uint32_t global;        /* the first world dword at the call */
    } c[MAXCALL];
} L;
static uint32_t g_ret;           /* the answer of every callee but the allocator */
static uint32_t g_new;           /* the answer of 0x51dc43 */

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int k, i = L.n;
    (void)ctx;
    if (L.n < MAXCALL) {
        L.c[i].callee = callee;
        L.c[i].this_ptr = this_ptr;
        L.c[i].nargs = nargs;
        for (k = 0; k < nargs && k < 2; k++) L.c[i].a[k] = args[k];
        L.c[i].first_dword = this_ptr > 0xffffffffu ? (uint32_t)(((const uint8_t *)this_ptr)[0] | ((const uint8_t *)this_ptr)[1] << 8 | ((const uint8_t *)this_ptr)[2] << 16 | (uint32_t)((const uint8_t *)this_ptr)[3] << 24) : 0;
        L.c[i].global = 0;
    }
    L.n++;
    return callee == 0x51dc43 ? g_new : g_ret;
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
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    L.n = 0;
    g_ret = 0;
    g_new = 0;
}

UNUSED_FN static void put32(uint8_t *p, size_t off, uint32_t v)
{
    p[off] = (uint8_t)v;
    p[off + 1] = (uint8_t)(v >> 8);
    p[off + 2] = (uint8_t)(v >> 16);
    p[off + 3] = (uint8_t)(v >> 24);
}

UNUSED_FN static uint32_t get32(const uint8_t *p, size_t off)
{
    return (uint32_t)p[off] | (uint32_t)p[off + 1] << 8 | (uint32_t)p[off + 2] << 16 | (uint32_t)p[off + 3] << 24;
}

static const uint32_t RETS[] UNUSED_FN = {0, 0x80000000u, 0xcafef00du, 0xffffffffu};
#define NRETS (sizeof RETS / sizeof RETS[0])

typedef uint32_t (*GetFn)(uint8_t *);
typedef void (*EmptyFn)(uint8_t *);
typedef uint32_t (*CallFn)(uint8_t *, const Fl18Host *);
typedef uint32_t (*SCallFn)(const Fl18Host *);
typedef uint8_t *(*DtorBaseFn)(uint8_t *, const Fl18Host *);

typedef uint8_t *(*DtorFn)(uint8_t *, uint32_t, const Fl18Host *);
static void check_dtor(DtorFn fn, uint32_t callee)
{
    static const uint32_t flags[] = {0, 1, 2, 3, 0x100, 0x101, 0xfffffffeu, 0xffffffffu, 0x80000000u, 0x80000001u};
    uint8_t before[SELF_SIZE];
    size_t k;
    for (k = 0; k < sizeof flags / sizeof flags[0] && !g_failed; k++) {
        setup();
        memcpy(before, SELF, sizeof before);
        g_ret = RETS[k % NRETS];
        CK(fn(SELF, flags[k], &g_host) == SELF);
        CK(L.c[0].callee == callee && L.c[0].this_ptr == (uintptr_t)SELF && L.c[0].nargs == 0);
        if ((flags[k] & 1u) != 0) {
            CK(L.n == 2);
            CK(L.c[1].callee == 0x51dc6c && L.c[1].this_ptr == 0 && L.c[1].nargs == 1 && L.c[1].a[0] == (uintptr_t)SELF);
        } else {
            CK(L.n == 1);
        }
        CK(memcmp(before, SELF, sizeof before) == 0);
    }
}

static void test_m401100_scalar_deleting_dtor(void) { check_dtor(m401100_scalar_deleting_dtor, 0x401032); }
static void test_m401190_scalar_deleting_dtor(void) { check_dtor(m401190_scalar_deleting_dtor, 0x521756); }
static void test_m401c40_scalar_deleting_dtor(void) { check_dtor(m401c40_scalar_deleting_dtor, 0x4014f5); }
static void test_m403010_scalar_deleting_dtor(void) { check_dtor(m403010_scalar_deleting_dtor, 0x401c70); }
static void test_m404a20_scalar_deleting_dtor(void) { check_dtor(m404a20_scalar_deleting_dtor, 0x403229); }
static void test_m407b10_scalar_deleting_dtor(void) { check_dtor(m407b10_scalar_deleting_dtor, 0x404af0); }
static void test_m408980_scalar_deleting_dtor(void) { check_dtor(m408980_scalar_deleting_dtor, 0x407c29); }
static void test_m40b2a0_scalar_deleting_dtor(void) { check_dtor(m40b2a0_scalar_deleting_dtor, 0x408d49); }
static void test_m414490_scalar_deleting_dtor(void) { check_dtor(m414490_scalar_deleting_dtor, 0x4110d7); }
static void test_m414c80_scalar_deleting_dtor(void) { check_dtor(m414c80_scalar_deleting_dtor, 0x41458b); }
static void test_m416e60_scalar_deleting_dtor(void) { check_dtor(m416e60_scalar_deleting_dtor, 0x414ccf); }
static void test_m41a480_scalar_deleting_dtor(void) { check_dtor(m41a480_scalar_deleting_dtor, 0x416f2d); }
static void test_m422fb0_scalar_deleting_dtor(void) { check_dtor(m422fb0_scalar_deleting_dtor, 0x41bebc); }
static void test_m425f70_scalar_deleting_dtor(void) { check_dtor(m425f70_scalar_deleting_dtor, 0x423467); }
static void test_m4273f0_scalar_deleting_dtor(void) { check_dtor(m4273f0_scalar_deleting_dtor, 0x427420); }
static void test_m434880_scalar_deleting_dtor(void) { check_dtor(m434880_scalar_deleting_dtor, 0x433e63); }
static void test_m438120_scalar_deleting_dtor(void) { check_dtor(m438120_scalar_deleting_dtor, 0x43772f); }
static void test_m43eed0_scalar_deleting_dtor(void) { check_dtor(m43eed0_scalar_deleting_dtor, 0x43eb59); }
static void test_m43f1e0_scalar_deleting_dtor(void) { check_dtor(m43f1e0_scalar_deleting_dtor, 0x43ef27); }
static void test_m446ed0_scalar_deleting_dtor(void) { check_dtor(m446ed0_scalar_deleting_dtor, 0x445e0f); }
static void test_m447ce0_scalar_deleting_dtor(void) { check_dtor(m447ce0_scalar_deleting_dtor, 0x446faa); }
static void test_m447d80_scalar_deleting_dtor(void) { check_dtor(m447d80_scalar_deleting_dtor, 0x447d2f); }
static void test_m4487f0_scalar_deleting_dtor(void) { check_dtor(m4487f0_scalar_deleting_dtor, 0x447e46); }
static void test_m449770_scalar_deleting_dtor(void) { check_dtor(m449770_scalar_deleting_dtor, 0x44883f); }
static void test_m449d60_scalar_deleting_dtor(void) { check_dtor(m449d60_scalar_deleting_dtor, 0x449a78); }
static void test_m44be60_scalar_deleting_dtor(void) { check_dtor(m44be60_scalar_deleting_dtor, 0x44afd6); }
static void test_m44c2b0_scalar_deleting_dtor(void) { check_dtor(m44c2b0_scalar_deleting_dtor, 0x44bea7); }
static void test_m44e650_scalar_deleting_dtor(void) { check_dtor(m44e650_scalar_deleting_dtor, 0x44d0eb); }
static void test_m44f620_scalar_deleting_dtor(void) { check_dtor(m44f620_scalar_deleting_dtor, 0x44e74b); }
static void test_m454c70_scalar_deleting_dtor(void) { check_dtor(m454c70_scalar_deleting_dtor, 0x44f66f); }
static void test_m456bf0_scalar_deleting_dtor(void) { check_dtor(m456bf0_scalar_deleting_dtor, 0x454d6e); }
static void test_m457e60_scalar_deleting_dtor(void) { check_dtor(m457e60_scalar_deleting_dtor, 0x456ceb); }
static void test_m4599d0_scalar_deleting_dtor(void) { check_dtor(m4599d0_scalar_deleting_dtor, 0x457f5e); }
static void test_m45b2d0_scalar_deleting_dtor(void) { check_dtor(m45b2d0_scalar_deleting_dtor, 0x459ace); }
static void test_m45db70_scalar_deleting_dtor(void) { check_dtor(m45db70_scalar_deleting_dtor, 0x45b3ce); }
static void test_m461710_scalar_deleting_dtor(void) { check_dtor(m461710_scalar_deleting_dtor, 0x45dc6e); }
static void test_m463f00_scalar_deleting_dtor(void) { check_dtor(m463f00_scalar_deleting_dtor, 0x46180b); }
static void test_m4659f0_scalar_deleting_dtor(void) { check_dtor(m4659f0_scalar_deleting_dtor, 0x463ffe); }
static void test_m4674b0_scalar_deleting_dtor(void) { check_dtor(m4674b0_scalar_deleting_dtor, 0x465aeb); }
static void test_m468d40_scalar_deleting_dtor(void) { check_dtor(m468d40_scalar_deleting_dtor, 0x4674ff); }
static void test_m46b470_scalar_deleting_dtor(void) { check_dtor(m46b470_scalar_deleting_dtor, 0x468e3e); }
static void test_m46e550_scalar_deleting_dtor(void) { check_dtor(m46e550_scalar_deleting_dtor, 0x46b56e); }
static void test_m470c60_scalar_deleting_dtor(void) { check_dtor(m470c60_scalar_deleting_dtor, 0x46e66a); }
static void test_m472ed0_scalar_deleting_dtor(void) { check_dtor(m472ed0_scalar_deleting_dtor, 0x470d5e); }
static void test_m4756c0_scalar_deleting_dtor(void) { check_dtor(m4756c0_scalar_deleting_dtor, 0x472f95); }
static void test_m4780e0_scalar_deleting_dtor(void) { check_dtor(m4780e0_scalar_deleting_dtor, 0x4757be); }
static void test_m47b1d0_scalar_deleting_dtor(void) { check_dtor(m47b1d0_scalar_deleting_dtor, 0x4781de); }
static void test_m47d3e0_scalar_deleting_dtor(void) { check_dtor(m47d3e0_scalar_deleting_dtor, 0x47b21f); }
static void test_m47e140_scalar_deleting_dtor(void) { check_dtor(m47e140_scalar_deleting_dtor, 0x47d4db); }
static void test_m482060_scalar_deleting_dtor(void) { check_dtor(m482060_scalar_deleting_dtor, 0x47e23e); }
static void test_m483e50_scalar_deleting_dtor(void) { check_dtor(m483e50_scalar_deleting_dtor, 0x48215e); }
static void test_m487a00_scalar_deleting_dtor(void) { check_dtor(m487a00_scalar_deleting_dtor, 0x483f4e); }
static void test_m488cc0_scalar_deleting_dtor(void) { check_dtor(m488cc0_scalar_deleting_dtor, 0x487afe); }
static void test_m48a5f0_scalar_deleting_dtor(void) { check_dtor(m48a5f0_scalar_deleting_dtor, 0x488d89); }
static void test_m48ba00_scalar_deleting_dtor(void) { check_dtor(m48ba00_scalar_deleting_dtor, 0x48a6ee); }
static void test_m48cf50_scalar_deleting_dtor(void) { check_dtor(m48cf50_scalar_deleting_dtor, 0x48bafb); }
static void test_m48e170_scalar_deleting_dtor(void) { check_dtor(m48e170_scalar_deleting_dtor, 0x48d04b); }
static void test_m490450_scalar_deleting_dtor(void) { check_dtor(m490450_scalar_deleting_dtor, 0x48e26e); }
static void test_m49c490_scalar_deleting_dtor(void) { check_dtor(m49c490_scalar_deleting_dtor, 0x490547); }
static void test_m4a1b30_scalar_deleting_dtor(void) { check_dtor(m4a1b30_scalar_deleting_dtor, 0x49c59f); }
static void test_m4a3670_scalar_deleting_dtor(void) { check_dtor(m4a3670_scalar_deleting_dtor, 0x4a1c2b); }
static void test_m4a6270_scalar_deleting_dtor(void) { check_dtor(m4a6270_scalar_deleting_dtor, 0x4a376e); }
static void test_m4a7b60_scalar_deleting_dtor(void) { check_dtor(m4a7b60_scalar_deleting_dtor, 0x4a636e); }
static void test_m4a9e10_scalar_deleting_dtor(void) { check_dtor(m4a9e10_scalar_deleting_dtor, 0x4a7c5e); }
static void test_m4ab290_scalar_deleting_dtor(void) { check_dtor(m4ab290_scalar_deleting_dtor, 0x4a9f0b); }
static void test_m4ac7c0_scalar_deleting_dtor(void) { check_dtor(m4ac7c0_scalar_deleting_dtor, 0x4ab38b); }
static void test_m4afc20_scalar_deleting_dtor(void) { check_dtor(m4afc20_scalar_deleting_dtor, 0x4ac8be); }
static void test_m4b3b40_scalar_deleting_dtor(void) { check_dtor(m4b3b40_scalar_deleting_dtor, 0x4afd1e); }
static void test_m4b5a70_scalar_deleting_dtor(void) { check_dtor(m4b5a70_scalar_deleting_dtor, 0x4b3c3e); }
static void test_m4b70e0_scalar_deleting_dtor(void) { check_dtor(m4b70e0_scalar_deleting_dtor, 0x4b5b6e); }
static void test_m4b7ed0_scalar_deleting_dtor(void) { check_dtor(m4b7ed0_scalar_deleting_dtor, 0x4b71db); }
static void test_m4b9dd0_scalar_deleting_dtor(void) { check_dtor(m4b9dd0_scalar_deleting_dtor, 0x4b7f1f); }
static void test_m4bed40_scalar_deleting_dtor(void) { check_dtor(m4bed40_scalar_deleting_dtor, 0x4b9e1f); }
static void test_m4bf5d0_scalar_deleting_dtor(void) { check_dtor(m4bf5d0_scalar_deleting_dtor, 0x4bed99); }
static void test_m4c0f30_scalar_deleting_dtor(void) { check_dtor(m4c0f30_scalar_deleting_dtor, 0x4bf61f); }
static void test_m4cae90_scalar_deleting_dtor(void) { check_dtor(m4cae90_scalar_deleting_dtor, 0x4c139a); }
static void test_m4cc880_scalar_deleting_dtor(void) { check_dtor(m4cc880_scalar_deleting_dtor, 0x4caeef); }
static void test_m4ccd40_scalar_deleting_dtor(void) { check_dtor(m4ccd40_scalar_deleting_dtor, 0x4cc946); }
static void test_m4cf7b0_scalar_deleting_dtor(void) { check_dtor(m4cf7b0_scalar_deleting_dtor, 0x4ccd8f); }
static void test_m4d42b0_scalar_deleting_dtor(void) { check_dtor(m4d42b0_scalar_deleting_dtor, 0x4d3b6e); }
static void test_m4d5230_scalar_deleting_dtor(void) { check_dtor(m4d5230_scalar_deleting_dtor, 0x44af20); }
static void test_m4d5880_scalar_deleting_dtor(void) { check_dtor(m4d5880_scalar_deleting_dtor, 0x4d527f); }
static void test_m4d9d40_scalar_deleting_dtor(void) { check_dtor(m4d9d40_scalar_deleting_dtor, 0x4d58cf); }
static void test_m4dbca0_scalar_deleting_dtor(void) { check_dtor(m4dbca0_scalar_deleting_dtor, 0x4db27f); }
static void test_m4dd380_scalar_deleting_dtor(void) { check_dtor(m4dd380_scalar_deleting_dtor, 0x4dbf6e); }
static void test_m4de120_scalar_deleting_dtor(void) { check_dtor(m4de120_scalar_deleting_dtor, 0x4dd3cf); }
static void test_m4de5c0_scalar_deleting_dtor(void) { check_dtor(m4de5c0_scalar_deleting_dtor, 0x4de1a4); }
static void test_m4e03e0_scalar_deleting_dtor(void) { check_dtor(m4e03e0_scalar_deleting_dtor, 0x4de66e); }
static void test_m4e1c20_scalar_deleting_dtor(void) { check_dtor(m4e1c20_scalar_deleting_dtor, 0x4e048f); }
static void test_m4e2cb0_scalar_deleting_dtor(void) { check_dtor(m4e2cb0_scalar_deleting_dtor, 0x4e1c83); }
static void test_m4e7600_scalar_deleting_dtor(void) { check_dtor(m4e7600_scalar_deleting_dtor, 0x4e2d63); }
static void test_m4e7a40_scalar_deleting_dtor(void) { check_dtor(m4e7a40_scalar_deleting_dtor, 0x4e7684); }
static void test_m4eb840_scalar_deleting_dtor(void) { check_dtor(m4eb840_scalar_deleting_dtor, 0x4e7b37); }
static void test_m4ed9e0_scalar_deleting_dtor(void) { check_dtor(m4ed9e0_scalar_deleting_dtor, 0x4eb8fe); }
static void test_m4ee950_scalar_deleting_dtor(void) { check_dtor(m4ee950_scalar_deleting_dtor, 0x4eda7c); }
static void test_m4effd0_scalar_deleting_dtor(void) { check_dtor(m4effd0_scalar_deleting_dtor, 0x4ee99f); }
static void test_m4f2610_scalar_deleting_dtor(void) { check_dtor(m4f2610_scalar_deleting_dtor, 0x4f001f); }

/* ---- exact-size buffers (meant for the sanitiser builds: a store or a load outside the bytes the original touches is a report) ----------- */
static void test_exact_size_buffers(void)
{
    uint8_t *p;
    setup();
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401100_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401190_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401c40_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m403010_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m404a20_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m407b10_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m408980_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m40b2a0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m414490_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m414c80_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m416e60_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m41a480_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m422fb0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m425f70_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4273f0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m434880_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m438120_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m43eed0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m43f1e0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m446ed0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m447ce0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m447d80_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4487f0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m449770_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m449d60_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44be60_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44c2b0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44e650_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44f620_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m454c70_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m456bf0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m457e60_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4599d0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m45b2d0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m45db70_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m461710_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m463f00_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4659f0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4674b0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m468d40_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m46b470_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m46e550_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m470c60_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m472ed0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4756c0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4780e0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m47b1d0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m47d3e0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m47e140_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m482060_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m483e50_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m487a00_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m488cc0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48a5f0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48ba00_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48cf50_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48e170_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m490450_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m49c490_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a1b30_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a3670_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a6270_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a7b60_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a9e10_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ab290_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ac7c0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4afc20_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b3b40_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b5a70_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b70e0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b7ed0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b9dd0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4bed40_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4bf5d0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4c0f30_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4cae90_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4cc880_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ccd40_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4cf7b0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4d42b0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4d5230_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4d5880_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4d9d40_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4dbca0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4dd380_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4de120_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4de5c0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e03e0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e1c20_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e2cb0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e7600_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e7a40_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4eb840_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ed9e0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ee950_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4effd0_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4f2610_scalar_deleting_dtor(p, 3, &g_host);
    free(p);
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
    RUN(test_m401100_scalar_deleting_dtor);
    RUN(test_m401190_scalar_deleting_dtor);
    RUN(test_m401c40_scalar_deleting_dtor);
    RUN(test_m403010_scalar_deleting_dtor);
    RUN(test_m404a20_scalar_deleting_dtor);
    RUN(test_m407b10_scalar_deleting_dtor);
    RUN(test_m408980_scalar_deleting_dtor);
    RUN(test_m40b2a0_scalar_deleting_dtor);
    RUN(test_m414490_scalar_deleting_dtor);
    RUN(test_m414c80_scalar_deleting_dtor);
    RUN(test_m416e60_scalar_deleting_dtor);
    RUN(test_m41a480_scalar_deleting_dtor);
    RUN(test_m422fb0_scalar_deleting_dtor);
    RUN(test_m425f70_scalar_deleting_dtor);
    RUN(test_m4273f0_scalar_deleting_dtor);
    RUN(test_m434880_scalar_deleting_dtor);
    RUN(test_m438120_scalar_deleting_dtor);
    RUN(test_m43eed0_scalar_deleting_dtor);
    RUN(test_m43f1e0_scalar_deleting_dtor);
    RUN(test_m446ed0_scalar_deleting_dtor);
    RUN(test_m447ce0_scalar_deleting_dtor);
    RUN(test_m447d80_scalar_deleting_dtor);
    RUN(test_m4487f0_scalar_deleting_dtor);
    RUN(test_m449770_scalar_deleting_dtor);
    RUN(test_m449d60_scalar_deleting_dtor);
    RUN(test_m44be60_scalar_deleting_dtor);
    RUN(test_m44c2b0_scalar_deleting_dtor);
    RUN(test_m44e650_scalar_deleting_dtor);
    RUN(test_m44f620_scalar_deleting_dtor);
    RUN(test_m454c70_scalar_deleting_dtor);
    RUN(test_m456bf0_scalar_deleting_dtor);
    RUN(test_m457e60_scalar_deleting_dtor);
    RUN(test_m4599d0_scalar_deleting_dtor);
    RUN(test_m45b2d0_scalar_deleting_dtor);
    RUN(test_m45db70_scalar_deleting_dtor);
    RUN(test_m461710_scalar_deleting_dtor);
    RUN(test_m463f00_scalar_deleting_dtor);
    RUN(test_m4659f0_scalar_deleting_dtor);
    RUN(test_m4674b0_scalar_deleting_dtor);
    RUN(test_m468d40_scalar_deleting_dtor);
    RUN(test_m46b470_scalar_deleting_dtor);
    RUN(test_m46e550_scalar_deleting_dtor);
    RUN(test_m470c60_scalar_deleting_dtor);
    RUN(test_m472ed0_scalar_deleting_dtor);
    RUN(test_m4756c0_scalar_deleting_dtor);
    RUN(test_m4780e0_scalar_deleting_dtor);
    RUN(test_m47b1d0_scalar_deleting_dtor);
    RUN(test_m47d3e0_scalar_deleting_dtor);
    RUN(test_m47e140_scalar_deleting_dtor);
    RUN(test_m482060_scalar_deleting_dtor);
    RUN(test_m483e50_scalar_deleting_dtor);
    RUN(test_m487a00_scalar_deleting_dtor);
    RUN(test_m488cc0_scalar_deleting_dtor);
    RUN(test_m48a5f0_scalar_deleting_dtor);
    RUN(test_m48ba00_scalar_deleting_dtor);
    RUN(test_m48cf50_scalar_deleting_dtor);
    RUN(test_m48e170_scalar_deleting_dtor);
    RUN(test_m490450_scalar_deleting_dtor);
    RUN(test_m49c490_scalar_deleting_dtor);
    RUN(test_m4a1b30_scalar_deleting_dtor);
    RUN(test_m4a3670_scalar_deleting_dtor);
    RUN(test_m4a6270_scalar_deleting_dtor);
    RUN(test_m4a7b60_scalar_deleting_dtor);
    RUN(test_m4a9e10_scalar_deleting_dtor);
    RUN(test_m4ab290_scalar_deleting_dtor);
    RUN(test_m4ac7c0_scalar_deleting_dtor);
    RUN(test_m4afc20_scalar_deleting_dtor);
    RUN(test_m4b3b40_scalar_deleting_dtor);
    RUN(test_m4b5a70_scalar_deleting_dtor);
    RUN(test_m4b70e0_scalar_deleting_dtor);
    RUN(test_m4b7ed0_scalar_deleting_dtor);
    RUN(test_m4b9dd0_scalar_deleting_dtor);
    RUN(test_m4bed40_scalar_deleting_dtor);
    RUN(test_m4bf5d0_scalar_deleting_dtor);
    RUN(test_m4c0f30_scalar_deleting_dtor);
    RUN(test_m4cae90_scalar_deleting_dtor);
    RUN(test_m4cc880_scalar_deleting_dtor);
    RUN(test_m4ccd40_scalar_deleting_dtor);
    RUN(test_m4cf7b0_scalar_deleting_dtor);
    RUN(test_m4d42b0_scalar_deleting_dtor);
    RUN(test_m4d5230_scalar_deleting_dtor);
    RUN(test_m4d5880_scalar_deleting_dtor);
    RUN(test_m4d9d40_scalar_deleting_dtor);
    RUN(test_m4dbca0_scalar_deleting_dtor);
    RUN(test_m4dd380_scalar_deleting_dtor);
    RUN(test_m4de120_scalar_deleting_dtor);
    RUN(test_m4de5c0_scalar_deleting_dtor);
    RUN(test_m4e03e0_scalar_deleting_dtor);
    RUN(test_m4e1c20_scalar_deleting_dtor);
    RUN(test_m4e2cb0_scalar_deleting_dtor);
    RUN(test_m4e7600_scalar_deleting_dtor);
    RUN(test_m4e7a40_scalar_deleting_dtor);
    RUN(test_m4eb840_scalar_deleting_dtor);
    RUN(test_m4ed9e0_scalar_deleting_dtor);
    RUN(test_m4ee950_scalar_deleting_dtor);
    RUN(test_m4effd0_scalar_deleting_dtor);
    RUN(test_m4f2610_scalar_deleting_dtor);
    RUN(test_exact_size_buffers);
    return failures;
}
