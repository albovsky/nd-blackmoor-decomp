/* FL-36 (batch f) direct tests of the 95 GAME.EXE functions in src/original_methods_fl36f.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl36f_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl36f.h"

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

static void check_newctor(SCallFn fn, uint32_t size, uint32_t callee)
{
    static const uint32_t made[] = {1, 0x1000, 0x80000000u, 0xffffffffu};
    size_t k;
    setup();                                 /* the allocation fails: the result is 0 and the constructor is not called */
    g_ret = 0xcafef00du;
    g_new = 0;
    CK(fn(&g_host) == 0);
    CK(L.n == 1);
    CK(L.c[0].callee == 0x51dc43 && L.c[0].this_ptr == 0 && L.c[0].nargs == 1 && L.c[0].a[0] == size);
    for (k = 0; k < sizeof made / sizeof made[0] && !g_failed; k++) {
        setup();
        g_ret = RETS[k];
        g_new = made[k];
        CK(fn(&g_host) == RETS[k]);
        CK(L.n == 2);
        CK(L.c[0].callee == 0x51dc43 && L.c[0].nargs == 1 && L.c[0].a[0] == size);
        CK(L.c[1].callee == callee && L.c[1].this_ptr == made[k] && L.c[1].nargs == 0);
    }
}

static void check_ctoreh(DtorBaseFn fn, uint32_t callee, uint32_t vtbl, uint32_t callee2)
{
    uint8_t want[SELF_SIZE];
    uint32_t old;
    setup();
    memcpy(want, SELF, sizeof want);
    old = get32(SELF, 0);
    put32(want, 0, vtbl);
    g_ret = 0xcafef00du;
    CK(fn(SELF, &g_host) == SELF);
    CK(L.n == 2);
    CK(L.c[0].callee == callee && L.c[0].this_ptr == (uintptr_t)SELF && L.c[0].nargs == 0 && L.c[0].first_dword == old);
    CK(L.c[1].callee == callee2 && L.c[1].this_ptr == (uintptr_t)SELF && L.c[1].nargs == 0 && L.c[1].first_dword == vtbl);
    CK(memcmp(SELF, want, sizeof want) == 0);
}

static void test_m401420_new_and_construct(void) { check_newctor(m401420_new_and_construct, 0x8c, 0x40149a); }
static void test_m403040_new_and_construct(void) { check_newctor(m403040_new_and_construct, 0x4b4, 0x4030ba); }
static void test_m404a50_new_and_construct(void) { check_newctor(m404a50_new_and_construct, 0xde0, 0x404aca); }
static void test_m407b40_new_and_construct(void) { check_newctor(m407b40_new_and_construct, 0x98c, 0x407bba); }
static void test_m4089b0_new_and_construct(void) { check_newctor(m4089b0_new_and_construct, 0xa8c, 0x408a2a); }
static void test_m4144c0_new_and_construct(void) { check_newctor(m4144c0_new_and_construct, 0x28, 0x414537); }
static void test_m414537_construct_base_set_vtable(void) { check_ctoreh(m414537_construct_base_set_vtable, 0x51d716, 0x52c4f0u, 0x4145a7); }
static void test_m41bda0_new_and_construct(void) { check_newctor(m41bda0_new_and_construct, 0x20ef, 0x41be1a); }
static void test_m43eab0_new_and_construct(void) { check_newctor(m43eab0_new_and_construct, 0xbc, 0x43eb3a); }
static void test_m446f00_new_and_construct(void) { check_newctor(m446f00_new_and_construct, 0x5e, 0x446f77); }
static void test_m447db0_new_and_construct(void) { check_newctor(m447db0_new_and_construct, 0x22, 0x447e27); }
static void test_m44af40_new_and_construct(void) { check_newctor(m44af40_new_and_construct, 0x1e, 0x44afb7); }
static void test_m44d020_new_and_construct(void) { check_newctor(m44d020_new_and_construct, 0x53, 0x44d097); }
static void test_m44d097_construct_base_set_vtable(void) { check_ctoreh(m44d097_construct_base_set_vtable, 0x51d716, 0x52cc38u, 0x44d107); }
static void test_m44e680_new_and_construct(void) { check_newctor(m44e680_new_and_construct, 0x6f, 0x44e6f7); }
static void test_m44e6f7_construct_base_set_vtable(void) { check_ctoreh(m44e6f7_construct_base_set_vtable, 0x51d716, 0x52ccc0u, 0x44e767); }
static void test_m454ca0_new_and_construct(void) { check_newctor(m454ca0_new_and_construct, 0x174, 0x454d1a); }
static void test_m454d1a_construct_base_set_vtable(void) { check_ctoreh(m454d1a_construct_base_set_vtable, 0x51d716, 0x52cd50u, 0x454d9e); }
static void test_m456c20_new_and_construct(void) { check_newctor(m456c20_new_and_construct, 0x44, 0x456c97); }
static void test_m456c97_construct_base_set_vtable(void) { check_ctoreh(m456c97_construct_base_set_vtable, 0x51d716, 0x52cdd8u, 0x456d07); }
static void test_m457e90_new_and_construct(void) { check_newctor(m457e90_new_and_construct, 0xf3, 0x457f0a); }
static void test_m457f0a_construct_base_set_vtable(void) { check_ctoreh(m457f0a_construct_base_set_vtable, 0x51d716, 0x52ce60u, 0x457f7a); }
static void test_m459a00_new_and_construct(void) { check_newctor(m459a00_new_and_construct, 0xe2, 0x459a7a); }
static void test_m459a7a_construct_base_set_vtable(void) { check_ctoreh(m459a7a_construct_base_set_vtable, 0x51d716, 0x52cee8u, 0x459aea); }
static void test_m45b300_new_and_construct(void) { check_newctor(m45b300_new_and_construct, 0x1b9, 0x45b37a); }
static void test_m45b37a_construct_base_set_vtable(void) { check_ctoreh(m45b37a_construct_base_set_vtable, 0x51d716, 0x52cf70u, 0x45b3ea); }
static void test_m45dba0_new_and_construct(void) { check_newctor(m45dba0_new_and_construct, 0x3af, 0x45dc1a); }
static void test_m45dc1a_construct_base_set_vtable(void) { check_ctoreh(m45dc1a_construct_base_set_vtable, 0x51d716, 0x52cff8u, 0x45dc8a); }
static void test_m461740_new_and_construct(void) { check_newctor(m461740_new_and_construct, 0x5f, 0x4617b7); }
static void test_m4617b7_construct_base_set_vtable(void) { check_ctoreh(m4617b7_construct_base_set_vtable, 0x51d716, 0x52d080u, 0x461827); }
static void test_m463f30_new_and_construct(void) { check_newctor(m463f30_new_and_construct, 0xda, 0x463faa); }
static void test_m463faa_construct_base_set_vtable(void) { check_ctoreh(m463faa_construct_base_set_vtable, 0x51d716, 0x52d108u, 0x46402e); }
static void test_m465a20_new_and_construct(void) { check_newctor(m465a20_new_and_construct, 0x56, 0x465a97); }
static void test_m465a97_construct_base_set_vtable(void) { check_ctoreh(m465a97_construct_base_set_vtable, 0x51d716, 0x52d190u, 0x465b07); }
static void test_m468d70_new_and_construct(void) { check_newctor(m468d70_new_and_construct, 0x5b4, 0x468dea); }
static void test_m468dea_construct_base_set_vtable(void) { check_ctoreh(m468dea_construct_base_set_vtable, 0x51d716, 0x52d220u, 0x468e5a); }
static void test_m46b4a0_new_and_construct(void) { check_newctor(m46b4a0_new_and_construct, 0x8302, 0x46b51a); }
static void test_m46b51a_construct_base_set_vtable(void) { check_ctoreh(m46b51a_construct_base_set_vtable, 0x51d716, 0x52d2e8u, 0x46b58a); }
static void test_m46e580_new_and_construct(void) { check_newctor(m46e580_new_and_construct, 0x95, 0x46e5fa); }
static void test_m470c90_new_and_construct(void) { check_newctor(m470c90_new_and_construct, 0xe0a, 0x470d0a); }
static void test_m470d0a_construct_base_set_vtable(void) { check_ctoreh(m470d0a_construct_base_set_vtable, 0x51d716, 0x52d3f8u, 0x470d7a); }
static void test_m4756f0_new_and_construct(void) { check_newctor(m4756f0_new_and_construct, 0x8da, 0x47576a); }
static void test_m47576a_construct_base_set_vtable(void) { check_ctoreh(m47576a_construct_base_set_vtable, 0x51d716, 0x52d490u, 0x4757da); }
static void test_m478110_new_and_construct(void) { check_newctor(m478110_new_and_construct, 0x15a0, 0x47818a); }
static void test_m47818a_construct_base_set_vtable(void) { check_ctoreh(m47818a_construct_base_set_vtable, 0x51d716, 0x52d518u, 0x4781fa); }
static void test_m47d410_new_and_construct(void) { check_newctor(m47d410_new_and_construct, 0x58, 0x47d487); }
static void test_m47d487_construct_base_set_vtable(void) { check_ctoreh(m47d487_construct_base_set_vtable, 0x51d716, 0x52d5a8u, 0x47d4f7); }
static void test_m47e170_new_and_construct(void) { check_newctor(m47e170_new_and_construct, 0x144d, 0x47e1ea); }
static void test_m47e1ea_construct_base_set_vtable(void) { check_ctoreh(m47e1ea_construct_base_set_vtable, 0x51d716, 0x52d630u, 0x47e25a); }
static void test_m482090_new_and_construct(void) { check_newctor(m482090_new_and_construct, 0xb7, 0x48210a); }
static void test_m48210a_construct_base_set_vtable(void) { check_ctoreh(m48210a_construct_base_set_vtable, 0x51d716, 0x52d6b8u, 0x48217a); }
static void test_m483e80_new_and_construct(void) { check_newctor(m483e80_new_and_construct, 0xc3b, 0x483efa); }
static void test_m483efa_construct_base_set_vtable(void) { check_ctoreh(m483efa_construct_base_set_vtable, 0x51d716, 0x52d740u, 0x483f6a); }
static void test_m487a30_new_and_construct(void) { check_newctor(m487a30_new_and_construct, 0x9b, 0x487aaa); }
static void test_m487aaa_construct_base_set_vtable(void) { check_ctoreh(m487aaa_construct_base_set_vtable, 0x51d716, 0x52d7c8u, 0x487b1a); }
static void test_m488cf0_new_and_construct(void) { check_newctor(m488cf0_new_and_construct, 0xd0, 0x488d6a); }
static void test_m48a620_new_and_construct(void) { check_newctor(m48a620_new_and_construct, 0x1ce, 0x48a69a); }
static void test_m48a69a_construct_base_set_vtable(void) { check_ctoreh(m48a69a_construct_base_set_vtable, 0x51d716, 0x52d8d8u, 0x48a70a); }
static void test_m48ba30_new_and_construct(void) { check_newctor(m48ba30_new_and_construct, 0x56, 0x48baa7); }
static void test_m48baa7_construct_base_set_vtable(void) { check_ctoreh(m48baa7_construct_base_set_vtable, 0x51d716, 0x52d960u, 0x48bb17); }
static void test_m48cf80_new_and_construct(void) { check_newctor(m48cf80_new_and_construct, 0x5c, 0x48cff7); }
static void test_m48cff7_construct_base_set_vtable(void) { check_ctoreh(m48cff7_construct_base_set_vtable, 0x51d716, 0x52d9e8u, 0x48d067); }
static void test_m48e1a0_new_and_construct(void) { check_newctor(m48e1a0_new_and_construct, 0x4e4, 0x48e21a); }
static void test_m48e21a_construct_base_set_vtable(void) { check_ctoreh(m48e21a_construct_base_set_vtable, 0x51d716, 0x52da70u, 0x48e28a); }
static void test_m490480_new_and_construct(void) { check_newctor(m490480_new_and_construct, 0x50fe, 0x4904fa); }
static void test_m49c4c0_new_and_construct(void) { check_newctor(m49c4c0_new_and_construct, 0xe4c, 0x49c53a); }
static void test_m4a1b60_new_and_construct(void) { check_newctor(m4a1b60_new_and_construct, 0x68, 0x4a1bd7); }
static void test_m4a1bd7_construct_base_set_vtable(void) { check_ctoreh(m4a1bd7_construct_base_set_vtable, 0x51d716, 0x52dc58u, 0x4a1c47); }
static void test_m4a36a0_new_and_construct(void) { check_newctor(m4a36a0_new_and_construct, 0x840, 0x4a371a); }
static void test_m4a371a_construct_base_set_vtable(void) { check_ctoreh(m4a371a_construct_base_set_vtable, 0x51d716, 0x52dce0u, 0x4a378a); }
static void test_m4a62a0_new_and_construct(void) { check_newctor(m4a62a0_new_and_construct, 0xa8, 0x4a631a); }
static void test_m4a631a_construct_base_set_vtable(void) { check_ctoreh(m4a631a_construct_base_set_vtable, 0x51d716, 0x52dd68u, 0x4a638a); }
static void test_m4a7b90_new_and_construct(void) { check_newctor(m4a7b90_new_and_construct, 0x13fd, 0x4a7c0a); }
static void test_m4a7c0a_construct_base_set_vtable(void) { check_ctoreh(m4a7c0a_construct_base_set_vtable, 0x51d716, 0x52ddf0u, 0x4a7c7a); }
static void test_m4a9e40_new_and_construct(void) { check_newctor(m4a9e40_new_and_construct, 0x4a, 0x4a9eb7); }
static void test_m4a9eb7_construct_base_set_vtable(void) { check_ctoreh(m4a9eb7_construct_base_set_vtable, 0x51d716, 0x52de78u, 0x4a9f27); }
static void test_m4ab2c0_new_and_construct(void) { check_newctor(m4ab2c0_new_and_construct, 0x62, 0x4ab337); }
static void test_m4ab337_construct_base_set_vtable(void) { check_ctoreh(m4ab337_construct_base_set_vtable, 0x51d716, 0x52df00u, 0x4ab3a7); }
static void test_m4ac7f0_new_and_construct(void) { check_newctor(m4ac7f0_new_and_construct, 0xe89, 0x4ac86a); }
static void test_m4ac86a_construct_base_set_vtable(void) { check_ctoreh(m4ac86a_construct_base_set_vtable, 0x51d716, 0x52df88u, 0x4ac8da); }
static void test_m4afc50_new_and_construct(void) { check_newctor(m4afc50_new_and_construct, 0x1541, 0x4afcca); }
static void test_m4afcca_construct_base_set_vtable(void) { check_ctoreh(m4afcca_construct_base_set_vtable, 0x51d716, 0x52e010u, 0x4afd3a); }
static void test_m4b3b70_new_and_construct(void) { check_newctor(m4b3b70_new_and_construct, 0x782, 0x4b3bea); }
static void test_m4b3bea_construct_base_set_vtable(void) { check_ctoreh(m4b3bea_construct_base_set_vtable, 0x51d716, 0x52e098u, 0x4b3c5a); }
static void test_m4b5aa0_new_and_construct(void) { check_newctor(m4b5aa0_new_and_construct, 0x278, 0x4b5b1a); }
static void test_m4b5b1a_construct_base_set_vtable(void) { check_ctoreh(m4b5b1a_construct_base_set_vtable, 0x51d716, 0x52e120u, 0x4b5b8a); }
static void test_m4b7110_new_and_construct(void) { check_newctor(m4b7110_new_and_construct, 0x3c, 0x4b7187); }
static void test_m4b7187_construct_base_set_vtable(void) { check_ctoreh(m4b7187_construct_base_set_vtable, 0x51d716, 0x52e1a8u, 0x4b71f7); }
static void test_m4cc8b0_new_and_construct(void) { check_newctor(m4cc8b0_new_and_construct, 0x1c, 0x4cc927); }
static void test_m4d3aa0_new_and_construct(void) { check_newctor(m4d3aa0_new_and_construct, 0x466, 0x4d3b1a); }
static void test_m4d3b1a_construct_base_set_vtable(void) { check_ctoreh(m4d3b1a_construct_base_set_vtable, 0x51d716, 0x52e310u, 0x4d3b95); }
static void test_m4dbea0_new_and_construct(void) { check_newctor(m4dbea0_new_and_construct, 0x10a, 0x4dbf1a); }
static void test_m4dbf1a_construct_base_set_vtable(void) { check_ctoreh(m4dbf1a_construct_base_set_vtable, 0x51d716, 0x52e478u, 0x4dbfbf); }
static void test_m4de150_construct_base_set_vtable(void) { check_ctoreh(m4de150_construct_base_set_vtable, 0x4eda10, 0x52e4ccu, 0x4de1f5); }
static void test_m4e7630_construct_base_set_vtable(void) { check_ctoreh(m4e7630_construct_base_set_vtable, 0x4eda10, 0x52e4f0u, 0x4e76d5); }

/* ---- exact-size buffers (meant for the sanitiser builds: a store or a load outside the bytes the original touches is a report) ----------- */
static void test_exact_size_buffers(void)
{
    uint8_t *p;
    setup();
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401420_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m403040_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m404a50_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m407b40_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4089b0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4144c0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m414537_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m41bda0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m43eab0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m446f00_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m447db0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44af40_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44d020_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44d097_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44e680_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44e6f7_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m454ca0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m454d1a_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m456c20_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m456c97_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m457e90_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m457f0a_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m459a00_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m459a7a_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m45b300_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m45b37a_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m45dba0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m45dc1a_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m461740_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4617b7_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m463f30_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m463faa_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m465a20_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m465a97_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m468d70_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m468dea_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m46b4a0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m46b51a_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m46e580_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m470c90_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m470d0a_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4756f0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m47576a_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m478110_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m47818a_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m47d410_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m47d487_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m47e170_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m47e1ea_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m482090_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48210a_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m483e80_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m483efa_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m487a30_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m487aaa_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m488cf0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48a620_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48a69a_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48ba30_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48baa7_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48cf80_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48cff7_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48e1a0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48e21a_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m490480_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m49c4c0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a1b60_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a1bd7_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a36a0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a371a_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a62a0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a631a_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a7b90_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a7c0a_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a9e40_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a9eb7_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ab2c0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ab337_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ac7f0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ac86a_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4afc50_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4afcca_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b3b70_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b3bea_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b5aa0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b5b1a_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b7110_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b7187_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4cc8b0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4d3aa0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4d3b1a_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4dbea0_new_and_construct(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4dbf1a_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4de150_construct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e7630_construct_base_set_vtable(p, &g_host);
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
    RUN(test_m401420_new_and_construct);
    RUN(test_m403040_new_and_construct);
    RUN(test_m404a50_new_and_construct);
    RUN(test_m407b40_new_and_construct);
    RUN(test_m4089b0_new_and_construct);
    RUN(test_m4144c0_new_and_construct);
    RUN(test_m414537_construct_base_set_vtable);
    RUN(test_m41bda0_new_and_construct);
    RUN(test_m43eab0_new_and_construct);
    RUN(test_m446f00_new_and_construct);
    RUN(test_m447db0_new_and_construct);
    RUN(test_m44af40_new_and_construct);
    RUN(test_m44d020_new_and_construct);
    RUN(test_m44d097_construct_base_set_vtable);
    RUN(test_m44e680_new_and_construct);
    RUN(test_m44e6f7_construct_base_set_vtable);
    RUN(test_m454ca0_new_and_construct);
    RUN(test_m454d1a_construct_base_set_vtable);
    RUN(test_m456c20_new_and_construct);
    RUN(test_m456c97_construct_base_set_vtable);
    RUN(test_m457e90_new_and_construct);
    RUN(test_m457f0a_construct_base_set_vtable);
    RUN(test_m459a00_new_and_construct);
    RUN(test_m459a7a_construct_base_set_vtable);
    RUN(test_m45b300_new_and_construct);
    RUN(test_m45b37a_construct_base_set_vtable);
    RUN(test_m45dba0_new_and_construct);
    RUN(test_m45dc1a_construct_base_set_vtable);
    RUN(test_m461740_new_and_construct);
    RUN(test_m4617b7_construct_base_set_vtable);
    RUN(test_m463f30_new_and_construct);
    RUN(test_m463faa_construct_base_set_vtable);
    RUN(test_m465a20_new_and_construct);
    RUN(test_m465a97_construct_base_set_vtable);
    RUN(test_m468d70_new_and_construct);
    RUN(test_m468dea_construct_base_set_vtable);
    RUN(test_m46b4a0_new_and_construct);
    RUN(test_m46b51a_construct_base_set_vtable);
    RUN(test_m46e580_new_and_construct);
    RUN(test_m470c90_new_and_construct);
    RUN(test_m470d0a_construct_base_set_vtable);
    RUN(test_m4756f0_new_and_construct);
    RUN(test_m47576a_construct_base_set_vtable);
    RUN(test_m478110_new_and_construct);
    RUN(test_m47818a_construct_base_set_vtable);
    RUN(test_m47d410_new_and_construct);
    RUN(test_m47d487_construct_base_set_vtable);
    RUN(test_m47e170_new_and_construct);
    RUN(test_m47e1ea_construct_base_set_vtable);
    RUN(test_m482090_new_and_construct);
    RUN(test_m48210a_construct_base_set_vtable);
    RUN(test_m483e80_new_and_construct);
    RUN(test_m483efa_construct_base_set_vtable);
    RUN(test_m487a30_new_and_construct);
    RUN(test_m487aaa_construct_base_set_vtable);
    RUN(test_m488cf0_new_and_construct);
    RUN(test_m48a620_new_and_construct);
    RUN(test_m48a69a_construct_base_set_vtable);
    RUN(test_m48ba30_new_and_construct);
    RUN(test_m48baa7_construct_base_set_vtable);
    RUN(test_m48cf80_new_and_construct);
    RUN(test_m48cff7_construct_base_set_vtable);
    RUN(test_m48e1a0_new_and_construct);
    RUN(test_m48e21a_construct_base_set_vtable);
    RUN(test_m490480_new_and_construct);
    RUN(test_m49c4c0_new_and_construct);
    RUN(test_m4a1b60_new_and_construct);
    RUN(test_m4a1bd7_construct_base_set_vtable);
    RUN(test_m4a36a0_new_and_construct);
    RUN(test_m4a371a_construct_base_set_vtable);
    RUN(test_m4a62a0_new_and_construct);
    RUN(test_m4a631a_construct_base_set_vtable);
    RUN(test_m4a7b90_new_and_construct);
    RUN(test_m4a7c0a_construct_base_set_vtable);
    RUN(test_m4a9e40_new_and_construct);
    RUN(test_m4a9eb7_construct_base_set_vtable);
    RUN(test_m4ab2c0_new_and_construct);
    RUN(test_m4ab337_construct_base_set_vtable);
    RUN(test_m4ac7f0_new_and_construct);
    RUN(test_m4ac86a_construct_base_set_vtable);
    RUN(test_m4afc50_new_and_construct);
    RUN(test_m4afcca_construct_base_set_vtable);
    RUN(test_m4b3b70_new_and_construct);
    RUN(test_m4b3bea_construct_base_set_vtable);
    RUN(test_m4b5aa0_new_and_construct);
    RUN(test_m4b5b1a_construct_base_set_vtable);
    RUN(test_m4b7110_new_and_construct);
    RUN(test_m4b7187_construct_base_set_vtable);
    RUN(test_m4cc8b0_new_and_construct);
    RUN(test_m4d3aa0_new_and_construct);
    RUN(test_m4d3b1a_construct_base_set_vtable);
    RUN(test_m4dbea0_new_and_construct);
    RUN(test_m4dbf1a_construct_base_set_vtable);
    RUN(test_m4de150_construct_base_set_vtable);
    RUN(test_m4e7630_construct_base_set_vtable);
    RUN(test_exact_size_buffers);
    return failures;
}
