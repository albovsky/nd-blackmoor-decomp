/* FL-36 (batch c) direct tests of the 130 GAME.EXE functions in src/original_methods_fl36c.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl36c_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl36c.h"

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
static Fl36cWorld g_w;
#define GLOBAL_VALUE (g_w.dword_569138)

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
        L.c[i].global = GLOBAL_VALUE;
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
    memset(&g_w, 0, sizeof g_w);
    g_w.dword_569138 = 0xdeadbeefu;
    L.n = 0;
    g_ret = 0;
}

static const uint32_t RETS[] = {0, 0x80000000u, 0xcafef00du, 0xffffffffu};
#define NRETS (sizeof RETS / sizeof RETS[0])

static void check_vtable_call(uint32_t got_or_zero, int returns_self, uint32_t vtbl, uint32_t callee, uint32_t want_ret, const uint8_t *before)
{
    uint8_t want[SELF_SIZE];
    memcpy(want, before, sizeof want);
    want[0] = (uint8_t)vtbl;
    want[1] = (uint8_t)(vtbl >> 8);
    want[2] = (uint8_t)(vtbl >> 16);
    want[3] = (uint8_t)(vtbl >> 24);
    if (returns_self)
        CK(got_or_zero == 0);
    else
        CK(got_or_zero == want_ret);
    CK(L.n == 1);
    CK(L.c[0].callee == callee && L.c[0].this_ptr == (uintptr_t)SELF && L.c[0].nargs == 0);
    CK(L.c[0].first_dword == vtbl);        /* the dword was stored before the call */
    CK(memcmp(SELF, want, sizeof want) == 0);
}

typedef uint32_t (*CtorFn)(uint8_t *, const Fl18Host *);
static void check_ctor(CtorFn fn, uint32_t vtbl, uint32_t callee)
{
    uint8_t before[SELF_SIZE];
    size_t k;
    for (k = 0; k < NRETS && !g_failed; k++) {
        setup();
        memcpy(before, SELF, sizeof before);
        g_ret = RETS[k];
        check_vtable_call(fn(SELF, &g_host), 0, vtbl, callee, RETS[k], before);
    }
}

typedef uint8_t *(*CtorRetFn)(uint8_t *, const Fl18Host *);
static void check_ctor_ret_self(CtorRetFn fn, uint32_t vtbl, uint32_t callee)
{
    uint8_t before[SELF_SIZE];
    size_t k;
    for (k = 0; k < NRETS && !g_failed; k++) {
        setup();
        memcpy(before, SELF, sizeof before);
        g_ret = RETS[k];
        check_vtable_call(fn(SELF, &g_host) == SELF ? 0u : 1u, 1, vtbl, callee, 0, before);
    }
}

typedef uint32_t (*SetGFn)(uint8_t *, Fl36cWorld *, const Fl18Host *);
static void check_setg(SetGFn fn, uint32_t imm, uint32_t callee)
{
    uint8_t before[SELF_SIZE];
    size_t k;
    for (k = 0; k < NRETS && !g_failed; k++) {
        setup();
        memcpy(before, SELF, sizeof before);
        g_ret = RETS[k];
        CK(fn(SELF, &g_w, &g_host) == RETS[k]);
        CK(L.n == 1);
        CK(L.c[0].callee == callee && L.c[0].this_ptr == (uintptr_t)SELF && L.c[0].nargs == 0);
        CK(L.c[0].global == imm);              /* the constant was stored before the call */
        CK(g_w.dword_569138 == imm);
        CK(memcmp(before, SELF, sizeof before) == 0);
    }
}

static void test_m401032_init_vtable_call(void) { check_ctor(m401032_init_vtable_call, 0x52a5d0u, 0x521756); }
static void test_m4014f5_init_vtable_call(void) { check_ctor(m4014f5_init_vtable_call, 0x52ab70u, 0x5218ea); }
static void test_m40168f_set_mode_call(void) { check_setg(m40168f_set_mode_call, 0x0u, 0x401526); }
static void test_m4016ac_set_mode_call(void) { check_setg(m4016ac_set_mode_call, 0x1u, 0x401526); }
static void test_m4016c9_set_mode_call(void) { check_setg(m4016c9_set_mode_call, 0x2u, 0x401526); }
static void test_m4016e6_set_mode_call(void) { check_setg(m4016e6_set_mode_call, 0x3u, 0x401526); }
static void test_m401703_set_mode_call(void) { check_setg(m401703_set_mode_call, 0x4u, 0x401526); }
static void test_m401720_set_mode_call(void) { check_setg(m401720_set_mode_call, 0x5u, 0x401526); }
static void test_m40173d_set_mode_call(void) { check_setg(m40173d_set_mode_call, 0x6u, 0x401526); }
static void test_m40175a_set_mode_call(void) { check_setg(m40175a_set_mode_call, 0x7u, 0x401526); }
static void test_m401777_set_mode_call(void) { check_setg(m401777_set_mode_call, 0x8u, 0x401526); }
static void test_m401794_set_mode_call(void) { check_setg(m401794_set_mode_call, 0x9u, 0x401526); }
static void test_m4017b1_set_mode_call(void) { check_setg(m4017b1_set_mode_call, 0xau, 0x401526); }
static void test_m4017ce_set_mode_call(void) { check_setg(m4017ce_set_mode_call, 0xbu, 0x401526); }
static void test_m4017eb_set_mode_call(void) { check_setg(m4017eb_set_mode_call, 0xcu, 0x401526); }
static void test_m401808_set_mode_call(void) { check_setg(m401808_set_mode_call, 0xdu, 0x401526); }
static void test_m401825_set_mode_call(void) { check_setg(m401825_set_mode_call, 0xeu, 0x401526); }
static void test_m401842_set_mode_call(void) { check_setg(m401842_set_mode_call, 0xfu, 0x401526); }
static void test_m40185f_set_mode_call(void) { check_setg(m40185f_set_mode_call, 0x10u, 0x401526); }
static void test_m40187c_set_mode_call(void) { check_setg(m40187c_set_mode_call, 0x11u, 0x401526); }
static void test_m401899_set_mode_call(void) { check_setg(m401899_set_mode_call, 0x12u, 0x401526); }
static void test_m4018b6_set_mode_call(void) { check_setg(m4018b6_set_mode_call, 0x13u, 0x401526); }
static void test_m4018d3_set_mode_call(void) { check_setg(m4018d3_set_mode_call, 0x14u, 0x401526); }
static void test_m4018f0_set_mode_call(void) { check_setg(m4018f0_set_mode_call, 0x15u, 0x401526); }
static void test_m40190d_set_mode_call(void) { check_setg(m40190d_set_mode_call, 0x16u, 0x401526); }
static void test_m40192a_set_mode_call(void) { check_setg(m40192a_set_mode_call, 0x17u, 0x401526); }
static void test_m401947_set_mode_call(void) { check_setg(m401947_set_mode_call, 0x18u, 0x401526); }
static void test_m401964_set_mode_call(void) { check_setg(m401964_set_mode_call, 0x19u, 0x401526); }
static void test_m401981_set_mode_call(void) { check_setg(m401981_set_mode_call, 0x1au, 0x401526); }
static void test_m40199e_set_mode_call(void) { check_setg(m40199e_set_mode_call, 0x1bu, 0x401526); }
static void test_m4019bb_set_mode_call(void) { check_setg(m4019bb_set_mode_call, 0x1cu, 0x401526); }
static void test_m4019d8_set_mode_call(void) { check_setg(m4019d8_set_mode_call, 0x1du, 0x401526); }
static void test_m4019f5_set_mode_call(void) { check_setg(m4019f5_set_mode_call, 0x1eu, 0x401526); }
static void test_m401a12_set_mode_call(void) { check_setg(m401a12_set_mode_call, 0x1fu, 0x401526); }
static void test_m401a2f_set_mode_call(void) { check_setg(m401a2f_set_mode_call, 0x20u, 0x401526); }
static void test_m401a4c_set_mode_call(void) { check_setg(m401a4c_set_mode_call, 0x21u, 0x401526); }
static void test_m401a69_set_mode_call(void) { check_setg(m401a69_set_mode_call, 0x22u, 0x401526); }
static void test_m401a86_set_mode_call(void) { check_setg(m401a86_set_mode_call, 0x23u, 0x401526); }
static void test_m401aa3_set_mode_call(void) { check_setg(m401aa3_set_mode_call, 0x24u, 0x401526); }
static void test_m401ac0_set_mode_call(void) { check_setg(m401ac0_set_mode_call, 0x25u, 0x401526); }
static void test_m401add_set_mode_call(void) { check_setg(m401add_set_mode_call, 0x26u, 0x401526); }
static void test_m401afa_set_mode_call(void) { check_setg(m401afa_set_mode_call, 0x27u, 0x401526); }
static void test_m401b17_set_mode_call(void) { check_setg(m401b17_set_mode_call, 0x28u, 0x401526); }
static void test_m401b34_set_mode_call(void) { check_setg(m401b34_set_mode_call, 0x29u, 0x401526); }
static void test_m401b51_set_mode_call(void) { check_setg(m401b51_set_mode_call, 0x2au, 0x401526); }
static void test_m401b6e_set_mode_call(void) { check_setg(m401b6e_set_mode_call, 0x2bu, 0x401526); }
static void test_m401b8b_set_mode_call(void) { check_setg(m401b8b_set_mode_call, 0x2cu, 0x401526); }
static void test_m401ba8_set_mode_call(void) { check_setg(m401ba8_set_mode_call, 0x2du, 0x401526); }
static void test_m401bc5_set_mode_call(void) { check_setg(m401bc5_set_mode_call, 0x2eu, 0x401526); }
static void test_m401be2_set_mode_call(void) { check_setg(m401be2_set_mode_call, 0x2fu, 0x401526); }
static void test_m401bff_set_mode_call(void) { check_setg(m401bff_set_mode_call, 0x30u, 0x401526); }
static void test_m404af0_init_vtable_call(void) { check_ctor(m404af0_init_vtable_call, 0x52ba38u, 0x5218ea); }
static void test_m41458b_init_vtable_call(void) { check_ctor(m41458b_init_vtable_call, 0x52c4f0u, 0x51d730); }
static void test_m414ccf_init_vtable_call(void) { check_ctor(m414ccf_init_vtable_call, 0x52c540u, 0x51d730); }
static void test_m437710_init_vtable_call_ret_self(void) { check_ctor_ret_self(m437710_init_vtable_call_ret_self, 0x52c7bcu, 0x437743); }
static void test_m43eb59_init_vtable_call(void) { check_ctor(m43eb59_init_vtable_call, 0x52c900u, 0x5228a4); }
static void test_m445df0_init_vtable_call_ret_self(void) { check_ctor_ret_self(m445df0_init_vtable_call_ret_self, 0x52ca1cu, 0x445e2b); }
static void test_m445e0f_init_vtable_call(void) { check_ctor(m445e0f_init_vtable_call, 0x52ca1cu, 0x445f40); }
static void test_m447d10_init_vtable_call_ret_self(void) { check_ctor_ret_self(m447d10_init_vtable_call_ret_self, 0x52cac8u, 0x447d4b); }
static void test_m447d2f_init_vtable_call(void) { check_ctor(m447d2f_init_vtable_call, 0x52cac8u, 0x447d60); }
static void test_m447e46_init_vtable_call(void) { check_ctor(m447e46_init_vtable_call, 0x52cb08u, 0x51d730); }
static void test_m448820_init_vtable_call_ret_self(void) { check_ctor_ret_self(m448820_init_vtable_call_ret_self, 0x52cb58u, 0x448853); }
static void test_m449a78_init_vtable_call(void) { check_ctor(m449a78_init_vtable_call, 0x52cb5cu, 0x449a94); }
static void test_m44afd6_init_vtable_call(void) { check_ctor(m44afd6_init_vtable_call, 0x52cb98u, 0x51d730); }
static void test_m44d0eb_init_vtable_call(void) { check_ctor(m44d0eb_init_vtable_call, 0x52cc38u, 0x51d730); }
static void test_m44e74b_init_vtable_call(void) { check_ctor(m44e74b_init_vtable_call, 0x52ccc0u, 0x51d730); }
static void test_m44f650_init_vtable_call_ret_self(void) { check_ctor_ret_self(m44f650_init_vtable_call_ret_self, 0x52cd10u, 0x44f68b); }
static void test_m44f66f_init_vtable_call(void) { check_ctor(m44f66f_init_vtable_call, 0x52cd10u, 0x44f996); }
static void test_m454d6e_init_vtable_call(void) { check_ctor(m454d6e_init_vtable_call, 0x52cd50u, 0x51d730); }
static void test_m456ceb_init_vtable_call(void) { check_ctor(m456ceb_init_vtable_call, 0x52cdd8u, 0x51d730); }
static void test_m457f5e_init_vtable_call(void) { check_ctor(m457f5e_init_vtable_call, 0x52ce60u, 0x51d730); }
static void test_m459ace_init_vtable_call(void) { check_ctor(m459ace_init_vtable_call, 0x52cee8u, 0x51d730); }
static void test_m45b3ce_init_vtable_call(void) { check_ctor(m45b3ce_init_vtable_call, 0x52cf70u, 0x51d730); }
static void test_m45dc6e_init_vtable_call(void) { check_ctor(m45dc6e_init_vtable_call, 0x52cff8u, 0x51d730); }
static void test_m46180b_init_vtable_call(void) { check_ctor(m46180b_init_vtable_call, 0x52d080u, 0x51d730); }
static void test_m463ffe_init_vtable_call(void) { check_ctor(m463ffe_init_vtable_call, 0x52d108u, 0x51d730); }
static void test_m465aeb_init_vtable_call(void) { check_ctor(m465aeb_init_vtable_call, 0x52d190u, 0x51d730); }
static void test_m4674e0_init_vtable_call_ret_self(void) { check_ctor_ret_self(m4674e0_init_vtable_call_ret_self, 0x52d1e0u, 0x467513); }
static void test_m468e3e_init_vtable_call(void) { check_ctor(m468e3e_init_vtable_call, 0x52d220u, 0x51d730); }
static void test_m46b56e_init_vtable_call(void) { check_ctor(m46b56e_init_vtable_call, 0x52d2e8u, 0x51d730); }
static void test_m470d5e_init_vtable_call(void) { check_ctor(m470d5e_init_vtable_call, 0x52d3f8u, 0x51d730); }
static void test_m4757be_init_vtable_call(void) { check_ctor(m4757be_init_vtable_call, 0x52d490u, 0x51d730); }
static void test_m4781de_init_vtable_call(void) { check_ctor(m4781de_init_vtable_call, 0x52d518u, 0x51d730); }
static void test_m47b21f_init_vtable_call(void) { check_ctor(m47b21f_init_vtable_call, 0x52d568u, 0x47b321); }
static void test_m47d4db_init_vtable_call(void) { check_ctor(m47d4db_init_vtable_call, 0x52d5a8u, 0x51d730); }
static void test_m47e23e_init_vtable_call(void) { check_ctor(m47e23e_init_vtable_call, 0x52d630u, 0x51d730); }
static void test_m48215e_init_vtable_call(void) { check_ctor(m48215e_init_vtable_call, 0x52d6b8u, 0x51d730); }
static void test_m483f4e_init_vtable_call(void) { check_ctor(m483f4e_init_vtable_call, 0x52d740u, 0x51d730); }
static void test_m487afe_init_vtable_call(void) { check_ctor(m487afe_init_vtable_call, 0x52d7c8u, 0x51d730); }
static void test_m488d89_init_vtable_call(void) { check_ctor(m488d89_init_vtable_call, 0x52d850u, 0x51d730); }
static void test_m48a6ee_init_vtable_call(void) { check_ctor(m48a6ee_init_vtable_call, 0x52d8d8u, 0x51d730); }
static void test_m48bafb_init_vtable_call(void) { check_ctor(m48bafb_init_vtable_call, 0x52d960u, 0x51d730); }
static void test_m48d04b_init_vtable_call(void) { check_ctor(m48d04b_init_vtable_call, 0x52d9e8u, 0x51d730); }
static void test_m48e26e_init_vtable_call(void) { check_ctor(m48e26e_init_vtable_call, 0x52da70u, 0x51d730); }
static void test_m4a1c2b_init_vtable_call(void) { check_ctor(m4a1c2b_init_vtable_call, 0x52dc58u, 0x51d730); }
static void test_m4a376e_init_vtable_call(void) { check_ctor(m4a376e_init_vtable_call, 0x52dce0u, 0x51d730); }
static void test_m4a636e_init_vtable_call(void) { check_ctor(m4a636e_init_vtable_call, 0x52dd68u, 0x51d730); }
static void test_m4a7c5e_init_vtable_call(void) { check_ctor(m4a7c5e_init_vtable_call, 0x52ddf0u, 0x51d730); }
static void test_m4a9f0b_init_vtable_call(void) { check_ctor(m4a9f0b_init_vtable_call, 0x52de78u, 0x51d730); }
static void test_m4ab38b_init_vtable_call(void) { check_ctor(m4ab38b_init_vtable_call, 0x52df00u, 0x51d730); }
static void test_m4ac8be_init_vtable_call(void) { check_ctor(m4ac8be_init_vtable_call, 0x52df88u, 0x51d730); }
static void test_m4afd1e_init_vtable_call(void) { check_ctor(m4afd1e_init_vtable_call, 0x52e010u, 0x51d730); }
static void test_m4b3c3e_init_vtable_call(void) { check_ctor(m4b3c3e_init_vtable_call, 0x52e098u, 0x51d730); }
static void test_m4b5b6e_init_vtable_call(void) { check_ctor(m4b5b6e_init_vtable_call, 0x52e120u, 0x51d730); }
static void test_m4b71db_init_vtable_call(void) { check_ctor(m4b71db_init_vtable_call, 0x52e1a8u, 0x51d730); }
static void test_m4b7f00_init_vtable_call_ret_self(void) { check_ctor_ret_self(m4b7f00_init_vtable_call_ret_self, 0x52e1f8u, 0x4b7f3b); }
static void test_m4b7f1f_init_vtable_call(void) { check_ctor(m4b7f1f_init_vtable_call, 0x52e1f8u, 0x4b7ff4); }
static void test_m4b9e00_init_vtable_call_ret_self(void) { check_ctor_ret_self(m4b9e00_init_vtable_call_ret_self, 0x52e200u, 0x4b9e3b); }
static void test_m4b9e1f_init_vtable_call(void) { check_ctor(m4b9e1f_init_vtable_call, 0x52e200u, 0x4ba07f); }
static void test_m4bed99_init_vtable_call(void) { check_ctor(m4bed99_init_vtable_call, 0x52e210u, 0x4bede7); }
static void test_m4bf600_init_vtable_call_ret_self(void) { check_ctor_ret_self(m4bf600_init_vtable_call_ret_self, 0x52e214u, 0x4bf63b); }
static void test_m4bf61f_init_vtable_call(void) { check_ctor(m4bf61f_init_vtable_call, 0x52e214u, 0x4bf8a7); }
static void test_m4caed0_init_vtable_call_ret_self(void) { check_ctor_ret_self(m4caed0_init_vtable_call_ret_self, 0x52e23cu, 0x4caf03); }
static void test_m4cc946_init_vtable_call(void) { check_ctor(m4cc946_init_vtable_call, 0x52e278u, 0x51d730); }
static void test_m4ccd8f_init_vtable_call(void) { check_ctor(m4ccd8f_init_vtable_call, 0x52e2d0u, 0x4cd218); }
static void test_m4d3b6e_init_vtable_call(void) { check_ctor(m4d3b6e_init_vtable_call, 0x52e310u, 0x51d730); }
static void test_m4d5260_init_vtable_call_ret_self(void) { check_ctor_ret_self(m4d5260_init_vtable_call_ret_self, 0x52e450u, 0x4d529b); }
static void test_m4d527f_init_vtable_call(void) { check_ctor(m4d527f_init_vtable_call, 0x52e450u, 0x4d52a6); }
static void test_m4d58b0_init_vtable_call_ret_self(void) { check_ctor_ret_self(m4d58b0_init_vtable_call_ret_self, 0x52e454u, 0x4d58eb); }
static void test_m4d58cf_init_vtable_call(void) { check_ctor(m4d58cf_init_vtable_call, 0x52e454u, 0x4d5b54); }
static void test_m4db260_init_vtable_call_ret_self(void) { check_ctor_ret_self(m4db260_init_vtable_call_ret_self, 0x52e458u, 0x4db29b); }
static void test_m4db27f_init_vtable_call(void) { check_ctor(m4db27f_init_vtable_call, 0x52e458u, 0x4db377); }
static void test_m4dd3b0_init_vtable_call_ret_self(void) { check_ctor_ret_self(m4dd3b0_init_vtable_call_ret_self, 0x52e4c8u, 0x4dd3eb); }
static void test_m4dd3cf_init_vtable_call(void) { check_ctor(m4dd3cf_init_vtable_call, 0x52e4c8u, 0x4dd3f6); }
static void test_m4e1c83_init_vtable_call(void) { check_ctor(m4e1c83_init_vtable_call, 0x52e4e8u, 0x4e1d34); }
static void test_m4ee980_init_vtable_call_ret_self(void) { check_ctor_ret_self(m4ee980_init_vtable_call_ret_self, 0x52e500u, 0x4ee9bb); }
static void test_m4ee99f_init_vtable_call(void) { check_ctor(m4ee99f_init_vtable_call, 0x52e500u, 0x4eead0); }
static void test_m4f0000_init_vtable_call_ret_self(void) { check_ctor_ret_self(m4f0000_init_vtable_call_ret_self, 0x52e504u, 0x4f003b); }
static void test_m4f001f_init_vtable_call(void) { check_ctor(m4f001f_init_vtable_call, 0x52e504u, 0x4f0046); }
static void test_m4fa9e7_init_vtable_call(void) { check_ctor(m4fa9e7_init_vtable_call, 0x52e518u, 0x4fad50); }

/* ---- exact-size buffers (meant for the sanitiser builds: a store or a load outside the bytes the original touches is a report) ----------- */
static void test_exact_size_buffers(void)
{
    uint8_t *p;
    setup();
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401032_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4014f5_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m40168f_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4016ac_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4016c9_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4016e6_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401703_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401720_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m40173d_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m40175a_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401777_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401794_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4017b1_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4017ce_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4017eb_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401808_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401825_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401842_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m40185f_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m40187c_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401899_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4018b6_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4018d3_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4018f0_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m40190d_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m40192a_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401947_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401964_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401981_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m40199e_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4019bb_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4019d8_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4019f5_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401a12_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401a2f_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401a4c_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401a69_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401a86_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401aa3_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401ac0_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401add_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401afa_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401b17_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401b34_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401b51_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401b6e_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401b8b_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401ba8_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401bc5_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401be2_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m401bff_set_mode_call(p, &g_w, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m404af0_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m41458b_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m414ccf_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m437710_init_vtable_call_ret_self(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m43eb59_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m445df0_init_vtable_call_ret_self(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m445e0f_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m447d10_init_vtable_call_ret_self(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m447d2f_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m447e46_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m448820_init_vtable_call_ret_self(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m449a78_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44afd6_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44d0eb_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44e74b_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44f650_init_vtable_call_ret_self(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44f66f_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m454d6e_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m456ceb_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m457f5e_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m459ace_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m45b3ce_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m45dc6e_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m46180b_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m463ffe_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m465aeb_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4674e0_init_vtable_call_ret_self(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m468e3e_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m46b56e_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m470d5e_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4757be_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4781de_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m47b21f_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m47d4db_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m47e23e_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48215e_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m483f4e_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m487afe_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m488d89_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48a6ee_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48bafb_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48d04b_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m48e26e_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a1c2b_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a376e_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a636e_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a7c5e_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4a9f0b_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ab38b_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ac8be_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4afd1e_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b3c3e_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b5b6e_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b71db_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b7f00_init_vtable_call_ret_self(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b7f1f_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b9e00_init_vtable_call_ret_self(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4b9e1f_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4bed99_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4bf600_init_vtable_call_ret_self(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4bf61f_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4caed0_init_vtable_call_ret_self(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4cc946_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ccd8f_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4d3b6e_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4d5260_init_vtable_call_ret_self(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4d527f_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4d58b0_init_vtable_call_ret_self(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4d58cf_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4db260_init_vtable_call_ret_self(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4db27f_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4dd3b0_init_vtable_call_ret_self(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4dd3cf_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e1c83_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ee980_init_vtable_call_ret_self(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ee99f_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4f0000_init_vtable_call_ret_self(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4f001f_init_vtable_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4fa9e7_init_vtable_call(p, &g_host);
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
    RUN(test_m401032_init_vtable_call);
    RUN(test_m4014f5_init_vtable_call);
    RUN(test_m40168f_set_mode_call);
    RUN(test_m4016ac_set_mode_call);
    RUN(test_m4016c9_set_mode_call);
    RUN(test_m4016e6_set_mode_call);
    RUN(test_m401703_set_mode_call);
    RUN(test_m401720_set_mode_call);
    RUN(test_m40173d_set_mode_call);
    RUN(test_m40175a_set_mode_call);
    RUN(test_m401777_set_mode_call);
    RUN(test_m401794_set_mode_call);
    RUN(test_m4017b1_set_mode_call);
    RUN(test_m4017ce_set_mode_call);
    RUN(test_m4017eb_set_mode_call);
    RUN(test_m401808_set_mode_call);
    RUN(test_m401825_set_mode_call);
    RUN(test_m401842_set_mode_call);
    RUN(test_m40185f_set_mode_call);
    RUN(test_m40187c_set_mode_call);
    RUN(test_m401899_set_mode_call);
    RUN(test_m4018b6_set_mode_call);
    RUN(test_m4018d3_set_mode_call);
    RUN(test_m4018f0_set_mode_call);
    RUN(test_m40190d_set_mode_call);
    RUN(test_m40192a_set_mode_call);
    RUN(test_m401947_set_mode_call);
    RUN(test_m401964_set_mode_call);
    RUN(test_m401981_set_mode_call);
    RUN(test_m40199e_set_mode_call);
    RUN(test_m4019bb_set_mode_call);
    RUN(test_m4019d8_set_mode_call);
    RUN(test_m4019f5_set_mode_call);
    RUN(test_m401a12_set_mode_call);
    RUN(test_m401a2f_set_mode_call);
    RUN(test_m401a4c_set_mode_call);
    RUN(test_m401a69_set_mode_call);
    RUN(test_m401a86_set_mode_call);
    RUN(test_m401aa3_set_mode_call);
    RUN(test_m401ac0_set_mode_call);
    RUN(test_m401add_set_mode_call);
    RUN(test_m401afa_set_mode_call);
    RUN(test_m401b17_set_mode_call);
    RUN(test_m401b34_set_mode_call);
    RUN(test_m401b51_set_mode_call);
    RUN(test_m401b6e_set_mode_call);
    RUN(test_m401b8b_set_mode_call);
    RUN(test_m401ba8_set_mode_call);
    RUN(test_m401bc5_set_mode_call);
    RUN(test_m401be2_set_mode_call);
    RUN(test_m401bff_set_mode_call);
    RUN(test_m404af0_init_vtable_call);
    RUN(test_m41458b_init_vtable_call);
    RUN(test_m414ccf_init_vtable_call);
    RUN(test_m437710_init_vtable_call_ret_self);
    RUN(test_m43eb59_init_vtable_call);
    RUN(test_m445df0_init_vtable_call_ret_self);
    RUN(test_m445e0f_init_vtable_call);
    RUN(test_m447d10_init_vtable_call_ret_self);
    RUN(test_m447d2f_init_vtable_call);
    RUN(test_m447e46_init_vtable_call);
    RUN(test_m448820_init_vtable_call_ret_self);
    RUN(test_m449a78_init_vtable_call);
    RUN(test_m44afd6_init_vtable_call);
    RUN(test_m44d0eb_init_vtable_call);
    RUN(test_m44e74b_init_vtable_call);
    RUN(test_m44f650_init_vtable_call_ret_self);
    RUN(test_m44f66f_init_vtable_call);
    RUN(test_m454d6e_init_vtable_call);
    RUN(test_m456ceb_init_vtable_call);
    RUN(test_m457f5e_init_vtable_call);
    RUN(test_m459ace_init_vtable_call);
    RUN(test_m45b3ce_init_vtable_call);
    RUN(test_m45dc6e_init_vtable_call);
    RUN(test_m46180b_init_vtable_call);
    RUN(test_m463ffe_init_vtable_call);
    RUN(test_m465aeb_init_vtable_call);
    RUN(test_m4674e0_init_vtable_call_ret_self);
    RUN(test_m468e3e_init_vtable_call);
    RUN(test_m46b56e_init_vtable_call);
    RUN(test_m470d5e_init_vtable_call);
    RUN(test_m4757be_init_vtable_call);
    RUN(test_m4781de_init_vtable_call);
    RUN(test_m47b21f_init_vtable_call);
    RUN(test_m47d4db_init_vtable_call);
    RUN(test_m47e23e_init_vtable_call);
    RUN(test_m48215e_init_vtable_call);
    RUN(test_m483f4e_init_vtable_call);
    RUN(test_m487afe_init_vtable_call);
    RUN(test_m488d89_init_vtable_call);
    RUN(test_m48a6ee_init_vtable_call);
    RUN(test_m48bafb_init_vtable_call);
    RUN(test_m48d04b_init_vtable_call);
    RUN(test_m48e26e_init_vtable_call);
    RUN(test_m4a1c2b_init_vtable_call);
    RUN(test_m4a376e_init_vtable_call);
    RUN(test_m4a636e_init_vtable_call);
    RUN(test_m4a7c5e_init_vtable_call);
    RUN(test_m4a9f0b_init_vtable_call);
    RUN(test_m4ab38b_init_vtable_call);
    RUN(test_m4ac8be_init_vtable_call);
    RUN(test_m4afd1e_init_vtable_call);
    RUN(test_m4b3c3e_init_vtable_call);
    RUN(test_m4b5b6e_init_vtable_call);
    RUN(test_m4b71db_init_vtable_call);
    RUN(test_m4b7f00_init_vtable_call_ret_self);
    RUN(test_m4b7f1f_init_vtable_call);
    RUN(test_m4b9e00_init_vtable_call_ret_self);
    RUN(test_m4b9e1f_init_vtable_call);
    RUN(test_m4bed99_init_vtable_call);
    RUN(test_m4bf600_init_vtable_call_ret_self);
    RUN(test_m4bf61f_init_vtable_call);
    RUN(test_m4caed0_init_vtable_call_ret_self);
    RUN(test_m4cc946_init_vtable_call);
    RUN(test_m4ccd8f_init_vtable_call);
    RUN(test_m4d3b6e_init_vtable_call);
    RUN(test_m4d5260_init_vtable_call_ret_self);
    RUN(test_m4d527f_init_vtable_call);
    RUN(test_m4d58b0_init_vtable_call_ret_self);
    RUN(test_m4d58cf_init_vtable_call);
    RUN(test_m4db260_init_vtable_call_ret_self);
    RUN(test_m4db27f_init_vtable_call);
    RUN(test_m4dd3b0_init_vtable_call_ret_self);
    RUN(test_m4dd3cf_init_vtable_call);
    RUN(test_m4e1c83_init_vtable_call);
    RUN(test_m4ee980_init_vtable_call_ret_self);
    RUN(test_m4ee99f_init_vtable_call);
    RUN(test_m4f0000_init_vtable_call_ret_self);
    RUN(test_m4f001f_init_vtable_call);
    RUN(test_m4fa9e7_init_vtable_call);
    RUN(test_exact_size_buffers);
    return failures;
}
