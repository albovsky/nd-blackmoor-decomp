/* FL-36 (batch b) direct tests of the 129 GAME.EXE functions in src/original_methods_fl36b.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl36b_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl36b.h"

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

#define SELF_SIZE 0x100
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
        uint32_t global;        /* the world dword at the call */
    } c[MAXCALL];
} L;
static uint32_t g_ret;           /* the answer of every callee */

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
    return g_ret;
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
}

typedef uint32_t (*GetFn)(uint8_t *);
static void check_get(GetFn fn, uint32_t want)
{
    uint8_t before[SELF_SIZE];
    setup();
    memcpy(before, SELF, sizeof before);
    CK(fn(SELF) == want);
    CK(memcmp(before, SELF, sizeof before) == 0);
    CK(L.n == 0);
}

typedef void (*EmptyFn)(uint8_t *);
static void check_empty(EmptyFn fn)
{
    uint8_t before[SELF_SIZE];
    setup();
    memcpy(before, SELF, sizeof before);
    fn(SELF);
    CK(memcmp(before, SELF, sizeof before) == 0);
    CK(L.n == 0);
}

static void test_m40104e_get_constant(void) { check_get(m40104e_get_constant, 0x52a550u); }
static void test_m4010b0_get_constant(void) { check_get(m4010b0_get_constant, 0x80u); }
static void test_m40148a_get_constant(void) { check_get(m40148a_get_constant, 0x52a688u); }
static void test_m40167f_get_constant(void) { check_get(m40167f_get_constant, 0x52a6a0u); }
static void test_m402952_get_constant(void) { check_get(m402952_get_constant, 0x52ac60u); }
static void test_m4030aa_get_constant(void) { check_get(m4030aa_get_constant, 0x52af90u); }
static void test_m40339b_get_constant(void) { check_get(m40339b_get_constant, 0x52afa8u); }
static void test_m4033cb_get_constant(void) { check_get(m4033cb_get_constant, 0x1u); }
static void test_m404aba_get_constant(void) { check_get(m404aba_get_constant, 0x52b358u); }
static void test_m404b39_get_constant(void) { check_get(m404b39_get_constant, 0x1u); }
static void test_m405b62_get_constant(void) { check_get(m405b62_get_constant, 0x52b370u); }
static void test_m407baa_get_constant(void) { check_get(m407baa_get_constant, 0x52bb28u); }
static void test_m407c97_get_constant(void) { check_get(m407c97_get_constant, 0x52bb40u); }
static void test_m407d90_get_constant(void) { check_get(m407d90_get_constant, 0x1u); }
static void test_m408a1a_get_constant(void) { check_get(m408a1a_get_constant, 0x52bfc8u); }
static void test_m40906b_get_constant(void) { check_get(m40906b_get_constant, 0x52bfe0u); }
static void test_m40909b_get_constant(void) { check_get(m40909b_get_constant, 0x1u); }
static void test_m414527_get_constant(void) { check_get(m414527_get_constant, 0x52c4b8u); }
static void test_m41a4be_empty_method(void) { check_empty(m41a4be_empty_method); }
static void test_m41be0a_get_constant(void) { check_get(m41be0a_get_constant, 0x52c5f0u); }
static void test_m4229fa_get_constant(void) { check_get(m4229fa_get_constant, 0x52c608u); }
static void test_m426510_get_constant(void) { check_get(m426510_get_constant, 0x52c690u); }
static void test_m43eb1a_get_constant(void) { check_get(m43eb1a_get_constant, 0x52c7c0u); }
static void test_m43eb2a_get_constant(void) { check_get(m43eb2a_get_constant, 0x52c7d8u); }
static void test_m43ef00_get_constant(void) { check_get(m43ef00_get_constant, 0x52c9f8u); }
static void test_m446f67_get_constant(void) { check_get(m446f67_get_constant, 0x52ca20u); }
static void test_m447e17_get_constant(void) { check_get(m447e17_get_constant, 0x52cad0u); }
static void test_m447e78_empty_method(void) { check_empty(m447e78_empty_method); }
static void test_m448853_empty_method(void) { check_empty(m448853_empty_method); }
static void test_m448871_empty_method(void) { check_empty(m448871_empty_method); }
static void test_m44afa7_get_constant(void) { check_get(m44afa7_get_constant, 0x52cb60u); }
static void test_m44d087_get_constant(void) { check_get(m44d087_get_constant, 0x52cc00u); }
static void test_m44e025_get_constant(void) { check_get(m44e025_get_constant, 0x52cc18u); }
static void test_m44e6e7_get_constant(void) { check_get(m44e6e7_get_constant, 0x52cc88u); }
static void test_m44e80b_empty_method(void) { check_empty(m44e80b_empty_method); }
static void test_m44f4ea_get_constant(void) { check_get(m44f4ea_get_constant, 0x52cca0u); }
static void test_m454d0a_get_constant(void) { check_get(m454d0a_get_constant, 0x52cd18u); }
static void test_m456506_get_constant(void) { check_get(m456506_get_constant, 0x52cd30u); }
static void test_m456c87_get_constant(void) { check_get(m456c87_get_constant, 0x52cda0u); }
static void test_m457bc8_get_constant(void) { check_get(m457bc8_get_constant, 0x52cdb8u); }
static void test_m457efa_get_constant(void) { check_get(m457efa_get_constant, 0x52ce28u); }
static void test_m4595e1_get_constant(void) { check_get(m4595e1_get_constant, 0x52ce40u); }
static void test_m459a6a_get_constant(void) { check_get(m459a6a_get_constant, 0x52ceb0u); }
static void test_m45ae5e_get_constant(void) { check_get(m45ae5e_get_constant, 0x52cec8u); }
static void test_m45b36a_get_constant(void) { check_get(m45b36a_get_constant, 0x52cf38u); }
static void test_m45d2b6_get_constant(void) { check_get(m45d2b6_get_constant, 0x52cf50u); }
static void test_m45dc0a_get_constant(void) { check_get(m45dc0a_get_constant, 0x52cfc0u); }
static void test_m460f16_get_constant(void) { check_get(m460f16_get_constant, 0x52cfd8u); }
static void test_m4617a7_get_constant(void) { check_get(m4617a7_get_constant, 0x52d048u); }
static void test_m463b00_get_constant(void) { check_get(m463b00_get_constant, 0x52d060u); }
static void test_m463f9a_get_constant(void) { check_get(m463f9a_get_constant, 0x52d0d0u); }
static void test_m4657d7_get_constant(void) { check_get(m4657d7_get_constant, 0x52d0e8u); }
static void test_m465a87_get_constant(void) { check_get(m465a87_get_constant, 0x52d158u); }
static void test_m465bd3_empty_method(void) { check_empty(m465bd3_empty_method); }
static void test_m466e04_get_constant(void) { check_get(m466e04_get_constant, 0x52d170u); }
static void test_m468dda_get_constant(void) { check_get(m468dda_get_constant, 0x52d1e8u); }
static void test_m46ab6f_get_constant(void) { check_get(m46ab6f_get_constant, 0x52d200u); }
static void test_m46b50a_get_constant(void) { check_get(m46b50a_get_constant, 0x52d2b0u); }
static void test_m46dea0_get_constant(void) { check_get(m46dea0_get_constant, 0x52d2c8u); }
static void test_m46e5ea_get_constant(void) { check_get(m46e5ea_get_constant, 0x52d338u); }
static void test_m470a63_get_constant(void) { check_get(m470a63_get_constant, 0x52d350u); }
static void test_m470cfa_get_constant(void) { check_get(m470cfa_get_constant, 0x52d3c0u); }
static void test_m472a4c_get_constant(void) { check_get(m472a4c_get_constant, 0x52d3d8u); }
static void test_m47575a_get_constant(void) { check_get(m47575a_get_constant, 0x52d458u); }
static void test_m4778cf_get_constant(void) { check_get(m4778cf_get_constant, 0x52d470u); }
static void test_m47817a_get_constant(void) { check_get(m47817a_get_constant, 0x52d4e0u); }
static void test_m47ac23_get_constant(void) { check_get(m47ac23_get_constant, 0x52d4f8u); }
static void test_m47d477_get_constant(void) { check_get(m47d477_get_constant, 0x52d570u); }
static void test_m47d677_empty_method(void) { check_empty(m47d677_empty_method); }
static void test_m47df47_get_constant(void) { check_get(m47df47_get_constant, 0x52d588u); }
static void test_m47e1da_get_constant(void) { check_get(m47e1da_get_constant, 0x52d5f8u); }
static void test_m481ca9_get_constant(void) { check_get(m481ca9_get_constant, 0x52d610u); }
static void test_m4820fa_get_constant(void) { check_get(m4820fa_get_constant, 0x52d680u); }
static void test_m483ac9_get_constant(void) { check_get(m483ac9_get_constant, 0x52d698u); }
static void test_m483eea_get_constant(void) { check_get(m483eea_get_constant, 0x52d708u); }
static void test_m4876dd_get_constant(void) { check_get(m4876dd_get_constant, 0x52d720u); }
static void test_m487a9a_get_constant(void) { check_get(m487a9a_get_constant, 0x52d790u); }
static void test_m487bcc_empty_method(void) { check_empty(m487bcc_empty_method); }
static void test_m4889e0_get_constant(void) { check_get(m4889e0_get_constant, 0x52d7a8u); }
static void test_m488d5a_get_constant(void) { check_get(m488d5a_get_constant, 0x52d818u); }
static void test_m48a3cb_get_constant(void) { check_get(m48a3cb_get_constant, 0x52d830u); }
static void test_m48a68a_get_constant(void) { check_get(m48a68a_get_constant, 0x52d8a0u); }
static void test_m48b720_get_constant(void) { check_get(m48b720_get_constant, 0x52d8b8u); }
static void test_m48ba97_get_constant(void) { check_get(m48ba97_get_constant, 0x52d928u); }
static void test_m48bc9b_empty_method(void) { check_empty(m48bc9b_empty_method); }
static void test_m48cc60_get_constant(void) { check_get(m48cc60_get_constant, 0x52d940u); }
static void test_m48cfe7_get_constant(void) { check_get(m48cfe7_get_constant, 0x52d9b0u); }
static void test_m48dec7_get_constant(void) { check_get(m48dec7_get_constant, 0x52d9c8u); }
static void test_m48e20a_get_constant(void) { check_get(m48e20a_get_constant, 0x52da38u); }
static void test_m49026c_get_constant(void) { check_get(m49026c_get_constant, 0x52da50u); }
static void test_m4904ea_get_constant(void) { check_get(m4904ea_get_constant, 0x52dac0u); }
static void test_m494f14_empty_method(void) { check_empty(m494f14_empty_method); }
static void test_m49c45c_get_constant(void) { check_get(m49c45c_get_constant, 0x52dad8u); }
static void test_m49c52a_get_constant(void) { check_get(m49c52a_get_constant, 0x52db90u); }
static void test_m4a1bc7_get_constant(void) { check_get(m4a1bc7_get_constant, 0x52dc20u); }
static void test_m4a35c7_get_constant(void) { check_get(m4a35c7_get_constant, 0x52dc38u); }
static void test_m4a370a_get_constant(void) { check_get(m4a370a_get_constant, 0x52dca8u); }
static void test_m4a5eda_get_constant(void) { check_get(m4a5eda_get_constant, 0x52dcc0u); }
static void test_m4a630a_get_constant(void) { check_get(m4a630a_get_constant, 0x52dd30u); }
static void test_m4a64ae_empty_method(void) { check_empty(m4a64ae_empty_method); }
static void test_m4a7a19_get_constant(void) { check_get(m4a7a19_get_constant, 0x52dd48u); }
static void test_m4a7bfa_get_constant(void) { check_get(m4a7bfa_get_constant, 0x52ddb8u); }
static void test_m4a9b1b_get_constant(void) { check_get(m4a9b1b_get_constant, 0x52ddd0u); }
static void test_m4a9ea7_get_constant(void) { check_get(m4a9ea7_get_constant, 0x52de40u); }
static void test_m4aaef5_get_constant(void) { check_get(m4aaef5_get_constant, 0x52de58u); }
static void test_m4ab327_get_constant(void) { check_get(m4ab327_get_constant, 0x52dec8u); }
static void test_m4ac488_get_constant(void) { check_get(m4ac488_get_constant, 0x52dee0u); }
static void test_m4ac85a_get_constant(void) { check_get(m4ac85a_get_constant, 0x52df50u); }
static void test_m4afa0e_get_constant(void) { check_get(m4afa0e_get_constant, 0x52df68u); }
static void test_m4afcba_get_constant(void) { check_get(m4afcba_get_constant, 0x52dfd8u); }
static void test_m4afdfe_empty_method(void) { check_empty(m4afdfe_empty_method); }
static void test_m4b371c_get_constant(void) { check_get(m4b371c_get_constant, 0x52dff0u); }
static void test_m4b3bda_get_constant(void) { check_get(m4b3bda_get_constant, 0x52e060u); }
static void test_m4b5838_get_constant(void) { check_get(m4b5838_get_constant, 0x52e078u); }
static void test_m4b5b0a_get_constant(void) { check_get(m4b5b0a_get_constant, 0x52e0e8u); }
static void test_m4b7041_get_constant(void) { check_get(m4b7041_get_constant, 0x52e100u); }
static void test_m4b7177_get_constant(void) { check_get(m4b7177_get_constant, 0x52e170u); }
static void test_m4b7ddd_get_constant(void) { check_get(m4b7ddd_get_constant, 0x52e188u); }
static void test_m4c0f60_get_constant(void) { check_get(m4c0f60_get_constant, 0x52e218u); }
static void test_m4cc917_get_constant(void) { check_get(m4cc917_get_constant, 0x52e240u); }
static void test_m4d3b0a_get_constant(void) { check_get(m4d3b0a_get_constant, 0x52e2d8u); }
static void test_m4d3b8a_empty_method(void) { check_empty(m4d3b8a_empty_method); }
static void test_m4d3d3d_empty_method(void) { check_empty(m4d3d3d_empty_method); }
static void test_m4d4192_get_constant(void) { check_get(m4d4192_get_constant, 0x52e2f0u); }
static void test_m4d51f7_get_constant(void) { check_get(m4d51f7_get_constant, 0x52e360u); }
static void test_m4d529b_empty_method(void) { check_empty(m4d529b_empty_method); }
static void test_m4dbf0a_get_constant(void) { check_get(m4dbf0a_get_constant, 0x52e460u); }
static void test_m4dd3eb_empty_method(void) { check_empty(m4dd3eb_empty_method); }
static void test_m4f003b_empty_method(void) { check_empty(m4f003b_empty_method); }

/* ---- exact-size buffers (meant for the sanitiser builds: a store or a load outside the bytes the original touches is a report) ----------- */
static void test_exact_size_buffers(void)
{
    uint8_t *p;
    setup();
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m40104e_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4010b0_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m40148a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m40167f_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m402952_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4030aa_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m40339b_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4033cb_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m404aba_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m404b39_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m405b62_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m407baa_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m407c97_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m407d90_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m408a1a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m40906b_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m40909b_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m414527_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m41a4be_empty_method(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m41be0a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4229fa_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m426510_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m43eb1a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m43eb2a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m43ef00_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m446f67_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m447e17_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m447e78_empty_method(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m448853_empty_method(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m448871_empty_method(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44afa7_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44d087_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44e025_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44e6e7_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m44e80b_empty_method(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44f4ea_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m454d0a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m456506_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m456c87_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m457bc8_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m457efa_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4595e1_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m459a6a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m45ae5e_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m45b36a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m45d2b6_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m45dc0a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m460f16_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4617a7_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m463b00_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m463f9a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4657d7_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m465a87_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m465bd3_empty_method(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m466e04_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m468dda_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m46ab6f_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m46b50a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m46dea0_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m46e5ea_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m470a63_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m470cfa_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m472a4c_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m47575a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4778cf_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m47817a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m47ac23_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m47d477_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m47d677_empty_method(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m47df47_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m47e1da_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m481ca9_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4820fa_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m483ac9_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m483eea_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4876dd_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m487a9a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m487bcc_empty_method(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4889e0_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m488d5a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48a3cb_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48a68a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48b720_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48ba97_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m48bc9b_empty_method(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48cc60_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48cfe7_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48dec7_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48e20a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m49026c_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4904ea_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m494f14_empty_method(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m49c45c_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m49c52a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a1bc7_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a35c7_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a370a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a5eda_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a630a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m4a64ae_empty_method(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a7a19_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a7bfa_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a9b1b_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a9ea7_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4aaef5_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ab327_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ac488_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ac85a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4afa0e_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4afcba_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m4afdfe_empty_method(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b371c_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b3bda_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b5838_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b5b0a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b7041_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b7177_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b7ddd_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4c0f60_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4cc917_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4d3b0a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m4d3b8a_empty_method(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m4d3d3d_empty_method(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4d4192_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4d51f7_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m4d529b_empty_method(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4dbf0a_get_constant(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m4dd3eb_empty_method(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m4f003b_empty_method(p);
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
    RUN(test_m40104e_get_constant);
    RUN(test_m4010b0_get_constant);
    RUN(test_m40148a_get_constant);
    RUN(test_m40167f_get_constant);
    RUN(test_m402952_get_constant);
    RUN(test_m4030aa_get_constant);
    RUN(test_m40339b_get_constant);
    RUN(test_m4033cb_get_constant);
    RUN(test_m404aba_get_constant);
    RUN(test_m404b39_get_constant);
    RUN(test_m405b62_get_constant);
    RUN(test_m407baa_get_constant);
    RUN(test_m407c97_get_constant);
    RUN(test_m407d90_get_constant);
    RUN(test_m408a1a_get_constant);
    RUN(test_m40906b_get_constant);
    RUN(test_m40909b_get_constant);
    RUN(test_m414527_get_constant);
    RUN(test_m41a4be_empty_method);
    RUN(test_m41be0a_get_constant);
    RUN(test_m4229fa_get_constant);
    RUN(test_m426510_get_constant);
    RUN(test_m43eb1a_get_constant);
    RUN(test_m43eb2a_get_constant);
    RUN(test_m43ef00_get_constant);
    RUN(test_m446f67_get_constant);
    RUN(test_m447e17_get_constant);
    RUN(test_m447e78_empty_method);
    RUN(test_m448853_empty_method);
    RUN(test_m448871_empty_method);
    RUN(test_m44afa7_get_constant);
    RUN(test_m44d087_get_constant);
    RUN(test_m44e025_get_constant);
    RUN(test_m44e6e7_get_constant);
    RUN(test_m44e80b_empty_method);
    RUN(test_m44f4ea_get_constant);
    RUN(test_m454d0a_get_constant);
    RUN(test_m456506_get_constant);
    RUN(test_m456c87_get_constant);
    RUN(test_m457bc8_get_constant);
    RUN(test_m457efa_get_constant);
    RUN(test_m4595e1_get_constant);
    RUN(test_m459a6a_get_constant);
    RUN(test_m45ae5e_get_constant);
    RUN(test_m45b36a_get_constant);
    RUN(test_m45d2b6_get_constant);
    RUN(test_m45dc0a_get_constant);
    RUN(test_m460f16_get_constant);
    RUN(test_m4617a7_get_constant);
    RUN(test_m463b00_get_constant);
    RUN(test_m463f9a_get_constant);
    RUN(test_m4657d7_get_constant);
    RUN(test_m465a87_get_constant);
    RUN(test_m465bd3_empty_method);
    RUN(test_m466e04_get_constant);
    RUN(test_m468dda_get_constant);
    RUN(test_m46ab6f_get_constant);
    RUN(test_m46b50a_get_constant);
    RUN(test_m46dea0_get_constant);
    RUN(test_m46e5ea_get_constant);
    RUN(test_m470a63_get_constant);
    RUN(test_m470cfa_get_constant);
    RUN(test_m472a4c_get_constant);
    RUN(test_m47575a_get_constant);
    RUN(test_m4778cf_get_constant);
    RUN(test_m47817a_get_constant);
    RUN(test_m47ac23_get_constant);
    RUN(test_m47d477_get_constant);
    RUN(test_m47d677_empty_method);
    RUN(test_m47df47_get_constant);
    RUN(test_m47e1da_get_constant);
    RUN(test_m481ca9_get_constant);
    RUN(test_m4820fa_get_constant);
    RUN(test_m483ac9_get_constant);
    RUN(test_m483eea_get_constant);
    RUN(test_m4876dd_get_constant);
    RUN(test_m487a9a_get_constant);
    RUN(test_m487bcc_empty_method);
    RUN(test_m4889e0_get_constant);
    RUN(test_m488d5a_get_constant);
    RUN(test_m48a3cb_get_constant);
    RUN(test_m48a68a_get_constant);
    RUN(test_m48b720_get_constant);
    RUN(test_m48ba97_get_constant);
    RUN(test_m48bc9b_empty_method);
    RUN(test_m48cc60_get_constant);
    RUN(test_m48cfe7_get_constant);
    RUN(test_m48dec7_get_constant);
    RUN(test_m48e20a_get_constant);
    RUN(test_m49026c_get_constant);
    RUN(test_m4904ea_get_constant);
    RUN(test_m494f14_empty_method);
    RUN(test_m49c45c_get_constant);
    RUN(test_m49c52a_get_constant);
    RUN(test_m4a1bc7_get_constant);
    RUN(test_m4a35c7_get_constant);
    RUN(test_m4a370a_get_constant);
    RUN(test_m4a5eda_get_constant);
    RUN(test_m4a630a_get_constant);
    RUN(test_m4a64ae_empty_method);
    RUN(test_m4a7a19_get_constant);
    RUN(test_m4a7bfa_get_constant);
    RUN(test_m4a9b1b_get_constant);
    RUN(test_m4a9ea7_get_constant);
    RUN(test_m4aaef5_get_constant);
    RUN(test_m4ab327_get_constant);
    RUN(test_m4ac488_get_constant);
    RUN(test_m4ac85a_get_constant);
    RUN(test_m4afa0e_get_constant);
    RUN(test_m4afcba_get_constant);
    RUN(test_m4afdfe_empty_method);
    RUN(test_m4b371c_get_constant);
    RUN(test_m4b3bda_get_constant);
    RUN(test_m4b5838_get_constant);
    RUN(test_m4b5b0a_get_constant);
    RUN(test_m4b7041_get_constant);
    RUN(test_m4b7177_get_constant);
    RUN(test_m4b7ddd_get_constant);
    RUN(test_m4c0f60_get_constant);
    RUN(test_m4cc917_get_constant);
    RUN(test_m4d3b0a_get_constant);
    RUN(test_m4d3b8a_empty_method);
    RUN(test_m4d3d3d_empty_method);
    RUN(test_m4d4192_get_constant);
    RUN(test_m4d51f7_get_constant);
    RUN(test_m4d529b_empty_method);
    RUN(test_m4dbf0a_get_constant);
    RUN(test_m4dd3eb_empty_method);
    RUN(test_m4f003b_empty_method);
    RUN(test_exact_size_buffers);
    return failures;
}
