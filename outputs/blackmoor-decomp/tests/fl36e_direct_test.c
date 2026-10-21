/* FL-36 (batch e) direct tests of the 80 GAME.EXE functions in src/original_methods_fl36e.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl36e_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl36e.h"

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

#define SELF_SIZE 0x8300
static uint8_t g_self[SELF_SIZE];
#define SELF g_self
static Fl18Host g_host;
static Fl36eWorld g_w;

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
        L.c[i].global = g_w.word_594daf;
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

UNUSED_FN static void world_init(Fl36eWorld *w)
{
    memset(w, 0, sizeof *w);
    w->word_594daf = (uint16_t)0xa5a0;
    w->word_594db1 = (uint16_t)0xa5a1;
    w->word_5957b5 = (uint16_t)0xa5a2;
    w->word_5957b7 = (uint16_t)0xa5a3;
    w->word_5957b9 = (uint16_t)0xa5a4;
    w->word_5957bb = (uint16_t)0xa5a5;
    w->word_5957bd = (uint16_t)0xa5a6;
    w->word_5957c1 = (uint16_t)0xa5a7;
    w->word_5957c3 = (uint16_t)0xa5a8;
    w->word_5a0541 = (uint16_t)0xa5a9;
    w->word_5a0543 = (uint16_t)0xa5aa;
    w->word_5a110b = (uint16_t)0xa5ab;
    w->word_5a110d = (uint16_t)0xa5ac;
    w->word_5a14db = (uint16_t)0xa5ad;
    w->word_5a14dd = (uint16_t)0xa5ae;
}

UNUSED_FN static int world_eq(const Fl36eWorld *a, const Fl36eWorld *b)
{
    return a->word_594daf == b->word_594daf && a->word_594db1 == b->word_594db1 && a->word_5957b5 == b->word_5957b5 && a->word_5957b7 == b->word_5957b7 && a->word_5957b9 == b->word_5957b9 && a->word_5957bb == b->word_5957bb && a->word_5957bd == b->word_5957bd && a->word_5957c1 == b->word_5957c1 && a->word_5957c3 == b->word_5957c3 && a->word_5a0541 == b->word_5a0541 && a->word_5a0543 == b->word_5a0543 && a->word_5a110b == b->word_5a110b && a->word_5a110d == b->word_5a110d && a->word_5a14db == b->word_5a14db && a->word_5a14dd == b->word_5a14dd;
}

static void setup(void)
{
    size_t i;
    for (i = 0; i < SELF_SIZE; i++) g_self[i] = (uint8_t)(i * 7 + 3);
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    world_init(&g_w);
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

static void check_getf(GetFn fn, size_t off)
{
    static const uint32_t vals[] = {0, 1, 0x80000000u, 0xdeadbeefu};
    uint8_t before[SELF_SIZE];
    size_t k;
    for (k = 0; k < sizeof vals / sizeof vals[0] && !g_failed; k++) {
        setup();
        put32(SELF, off, vals[k]);
        memcpy(before, SELF, sizeof before);
        CK(fn(SELF) == vals[k]);
        CK(memcmp(before, SELF, sizeof before) == 0);
        CK(L.n == 0);
    }
}

static void check_empty(EmptyFn fn)
{
    uint8_t before[SELF_SIZE];
    setup();
    memcpy(before, SELF, sizeof before);
    fn(SELF);
    CK(memcmp(before, SELF, sizeof before) == 0);
    CK(L.n == 0);
}

typedef uint8_t *(*RetSelfFn)(uint8_t *);
static void check_setvt(RetSelfFn fn, size_t off, uint32_t imm)
{
    uint8_t want[SELF_SIZE];
    setup();
    memcpy(want, SELF, sizeof want);
    put32(want, off, imm);
    CK(fn(SELF) == SELF);
    CK(memcmp(SELF, want, sizeof want) == 0);
    CK(L.n == 0);
}

static void check_tail0(CallFn fn, uint32_t callee)
{
    uint8_t before[SELF_SIZE];
    size_t k;
    for (k = 0; k < NRETS && !g_failed; k++) {
        setup();
        memcpy(before, SELF, sizeof before);
        g_ret = RETS[k];
        CK(fn(SELF, &g_host) == RETS[k]);
        CK(L.n == 1);
        CK(L.c[0].callee == callee && L.c[0].this_ptr == (uintptr_t)SELF && L.c[0].nargs == 0);
        CK(memcmp(before, SELF, sizeof before) == 0);
    }
}

typedef uint32_t (*Fwd1Fn)(uint8_t *, uint32_t, const Fl18Host *);
static void check_fwd1(Fwd1Fn fn, uint32_t callee)
{
    static const uint32_t args[] = {0, 1, 0xffffffffu, 0x12345678u};
    uint8_t before[SELF_SIZE];
    size_t k;
    for (k = 0; k < NRETS && !g_failed; k++) {
        setup();
        memcpy(before, SELF, sizeof before);
        g_ret = RETS[k];
        CK(fn(SELF, args[k], &g_host) == RETS[k]);
        CK(L.n == 1);
        CK(L.c[0].callee == callee && L.c[0].this_ptr == (uintptr_t)SELF && L.c[0].nargs == 1 && L.c[0].a[0] == args[k]);
        CK(memcmp(before, SELF, sizeof before) == 0);
    }
}

static void check_dtorbase(DtorBaseFn fn, uint32_t callee, uint32_t imm)
{
    uint8_t want[SELF_SIZE];
    uint32_t old;
    setup();
    memcpy(want, SELF, sizeof want);
    old = get32(SELF, 0);
    put32(want, 0, imm);
    g_ret = 0xcafef00du;
    CK(fn(SELF, &g_host) == SELF);
    CK(L.n == 1);
    CK(L.c[0].callee == callee && L.c[0].this_ptr == (uintptr_t)SELF && L.c[0].nargs == 0);
    CK(L.c[0].first_dword == old);         /* the dword is stored after the call */
    CK(memcmp(SELF, want, sizeof want) == 0);
}

typedef uint8_t *(*SetFaFn)(uint8_t *, uint32_t);
static void check_setfa(SetFaFn fn, size_t off)
{
    static const uint32_t vals[] = {0, 1, 0xffffffffu, 0x12345678u};
    uint8_t want[SELF_SIZE];
    size_t k;
    for (k = 0; k < sizeof vals / sizeof vals[0] && !g_failed; k++) {
        setup();
        memcpy(want, SELF, sizeof want);
        put32(want, off, vals[k]);
        CK(fn(SELF, vals[k]) == SELF);
        CK(memcmp(SELF, want, sizeof want) == 0);
        CK(L.n == 0);
    }
}

static void check_call2(CallFn fn, uint32_t callee, uint32_t callee2, uint32_t imm)
{
    uint8_t before[SELF_SIZE];
    setup();
    memcpy(before, SELF, sizeof before);
    g_ret = 0xcafef00du;
    CK(fn(SELF, &g_host) == imm);
    CK(L.n == 2);
    CK(L.c[0].callee == callee && L.c[0].this_ptr == (uintptr_t)SELF && L.c[0].nargs == 0);
    CK(L.c[1].callee == callee2 && L.c[1].this_ptr == (uintptr_t)SELF && L.c[1].nargs == 0);
    CK(memcmp(before, SELF, sizeof before) == 0);
}

static void check_scall(SCallFn fn, uint32_t obj, uint32_t callee)
{
    size_t k;
    for (k = 0; k < NRETS && !g_failed; k++) {
        setup();
        g_ret = RETS[k];
        CK(fn(&g_host) == RETS[k]);
        CK(L.n == 1);
        CK(L.c[0].callee == callee && L.c[0].this_ptr == obj && L.c[0].nargs == 0);
    }
}

static void test_m402945_empty_method_args(void) { check_empty(m402945_empty_method_args); }
static void test_m40338e_empty_method_args(void) { check_empty(m40338e_empty_method_args); }
static void test_m4033ab_call_two_return_const(void) { check_call2(m4033ab_call_two_return_const, 0x521b22, 0x4033db, 0x1u); }
static void test_m404b0c_empty_method_args(void) { check_empty(m404b0c_empty_method_args); }
static void test_m404b19_call_two_return_const(void) { check_call2(m404b19_call_two_return_const, 0x521b22, 0x404be1, 0x1u); }
static void test_m407c8a_empty_method_args(void) { check_empty(m407c8a_empty_method_args); }
static void test_m407d70_call_two_return_const(void) { check_call2(m407d70_call_two_return_const, 0x521b22, 0x407ca7, 0x1u); }
static void test_m40905e_empty_method_args(void) { check_empty(m40905e_empty_method_args); }
static void test_m40907b_call_two_return_const(void) { check_call2(m40907b_call_two_return_const, 0x521b22, 0x4090ab, 0x1u); }
static void test_m414cb0_destruct_base_set_vtable(void) { check_dtorbase(m414cb0_destruct_base_set_vtable, 0x51d716, 0x52c540u); }
static void test_m423450_init_vtable_ret_self(void) { check_setvt(m423450_init_vtable_ret_self, 0, 0x52c688u); }
static void test_m423467_init_vtable_ret_self(void) { check_setvt(m423467_init_vtable_ret_self, 0, 0x52c688u); }
static void test_m4234b5_forward_call(void) { check_tail0(m4234b5_forward_call, 0x42347b); }
static void test_m426b5d_call_global_object(void) { check_scall(m426b5d_call_global_object, 0x570388, 0x426520); }
static void test_m426b7e_call_global_object(void) { check_scall(m426b7e_call_global_object, 0x570388, 0x427420); }
static void test_m43772f_init_vtable_ret_self(void) { check_setvt(m43772f_init_vtable_ret_self, 0, 0x52c7bcu); }
static void test_m43eb3a_destruct_base_set_vtable(void) { check_dtorbase(m43eb3a_destruct_base_set_vtable, 0x5227c6, 0x52c900u); }
static void test_m43ef10_init_vtable_ret_self(void) { check_setvt(m43ef10_init_vtable_ret_self, 0, 0x52ca10u); }
static void test_m43ef27_init_vtable_ret_self(void) { check_setvt(m43ef27_init_vtable_ret_self, 0, 0x52ca10u); }
static void test_m445f40_forward_call(void) { check_tail0(m445f40_forward_call, 0x445e2b); }
static void test_m447d4b_set_field_const(void) { check_setvt(m447d4b_set_field_const, 0x4, 0x0u); }
static void test_m447e27_destruct_base_set_vtable(void) { check_dtorbase(m447e27_destruct_base_set_vtable, 0x51d716, 0x52cb08u); }
static void test_m447e62_set_field_arg(void) { check_setfa(m447e62_set_field_arg, 0x1e); }
static void test_m44883f_init_vtable_ret_self(void) { check_setvt(m44883f_init_vtable_ret_self, 0, 0x52cb58u); }
static void test_m44885e_forward_call(void) { check_tail0(m44885e_forward_call, 0x448853); }
static void test_m44afb7_destruct_base_set_vtable(void) { check_dtorbase(m44afb7_destruct_base_set_vtable, 0x51d716, 0x52cb98u); }
static void test_m44be90_init_vtable_ret_self(void) { check_setvt(m44be90_init_vtable_ret_self, 0, 0x52cbf0u); }
static void test_m44bea7_init_vtable_ret_self(void) { check_setvt(m44bea7_init_vtable_ret_self, 0, 0x52cbf0u); }
static void test_m454d8a_set_word(void) { { Fl36eWorld want; setup(); want = g_w; want.word_5a0541 = 0x0; m454d8a_set_word(&g_w); CK(world_eq(&g_w, &want)); CK(L.n == 0); } }
static void test_m456dab_set_two_words(void) { { Fl36eWorld want; setup(); want = g_w; want.word_5957c1 = 0x0; want.word_5957c3 = 0x0; m456dab_set_two_words(&g_w); CK(world_eq(&g_w, &want)); CK(L.n == 0); } }
static void test_m46401a_set_word(void) { { Fl36eWorld want; setup(); want = g_w; want.word_5a0543 = 0x0; m46401a_set_word(&g_w); CK(world_eq(&g_w, &want)); CK(L.n == 0); } }
static void test_m4674ff_init_vtable_ret_self(void) { check_setvt(m4674ff_init_vtable_ret_self, 0, 0x52d1e0u); }
static void test_m46b73e_set_two_words(void) { { Fl36eWorld want; setup(); want = g_w; want.word_5a14db = 0x0; want.word_5a14dd = 0x270f; m46b73e_set_two_words(&g_w); CK(world_eq(&g_w, &want)); CK(L.n == 0); } }
static void test_m470e71_set_two_words(void) { { Fl36eWorld want; setup(); want = g_w; want.word_5957b5 = 0x0; want.word_5957b7 = 0x0; m470e71_set_two_words(&g_w); CK(world_eq(&g_w, &want)); CK(L.n == 0); } }
static void test_m4712b0_empty_method_args(void) { check_empty(m4712b0_empty_method_args); }
static void test_m4782be_set_two_words(void) { { Fl36eWorld want; setup(); want = g_w; want.word_5957bb = 0x0; want.word_5957bd = 0x270f; m4782be_set_two_words(&g_w); CK(world_eq(&g_w, &want)); CK(L.n == 0); } }
static void test_m488d6a_destruct_base_set_vtable(void) { check_dtorbase(m488d6a_destruct_base_set_vtable, 0x51d716, 0x52d850u); }
static void test_m48d119_set_word(void) { { Fl36eWorld want; setup(); want = g_w; want.word_594daf = 0x0; m48d119_set_word(&g_w); CK(world_eq(&g_w, &want)); CK(L.n == 0); } }
static void test_m493ad8_set_field_const(void) { check_setvt(m493ad8_set_field_const, 0x200b, 0x1u); }
static void test_m4a7ddc_set_two_words(void) { { Fl36eWorld want; setup(); want = g_w; want.word_5a110b = 0x0; want.word_5a110d = 0x270f; m4a7ddc_set_two_words(&g_w); CK(world_eq(&g_w, &want)); CK(L.n == 0); } }
static void test_m4ab459_set_word(void) { { Fl36eWorld want; setup(); want = g_w; want.word_5957b9 = 0x0; m4ab459_set_word(&g_w); CK(world_eq(&g_w, &want)); CK(L.n == 0); } }
static void test_m4b5c48_set_word(void) { { Fl36eWorld want; setup(); want = g_w; want.word_594db1 = 0x0; m4b5c48_set_word(&g_w); CK(world_eq(&g_w, &want)); CK(L.n == 0); } }
static void test_m4bf3a4_get_field(void) { check_getf(m4bf3a4_get_field, 0x2c0); }
static void test_m4c0c40_get_field(void) { check_getf(m4c0c40_get_field, 0x216); }
static void test_m4caeef_init_vtable_ret_self(void) { check_setvt(m4caeef_init_vtable_ret_self, 0, 0x52e23cu); }
static void test_m4cc927_destruct_base_set_vtable(void) { check_dtorbase(m4cc927_destruct_base_set_vtable, 0x51d716, 0x52e278u); }
static void test_m4d3705_call_global_object(void) { check_scall(m4d3705_call_global_object, 0x582711, 0x4e79ca); }
static void test_m4d3714_call_global_object(void) { check_scall(m4d3714_call_global_object, 0x570508, 0x4e1157); }
static void test_m4d3c1d_get_field(void) { check_getf(m4d3c1d_get_field, 0x462); }
static void test_m4d51ea_empty_method_args(void) { check_empty(m4d51ea_empty_method_args); }
static void test_m4d52a6_forward_call(void) { check_tail0(m4d52a6_forward_call, 0x4d529b); }
static void test_m4dae66_get_field(void) { check_getf(m4dae66_get_field, 0x18); }
static void test_m4dae77_get_field(void) { check_getf(m4dae77_get_field, 0x1c); }
static void test_m4daef1_get_field(void) { check_getf(m4daef1_get_field, 0xc); }
static void test_m4daf02_set_field_arg(void) { check_setfa(m4daf02_set_field_arg, 0xc); }
static void test_m4daf18_get_field(void) { check_getf(m4daf18_get_field, 0x10); }
static void test_m4daf29_set_field_arg(void) { check_setfa(m4daf29_set_field_arg, 0x10); }
static void test_m4db377_forward_call(void) { check_tail0(m4db377_forward_call, 0x4db29b); }
static void test_m4dd3f6_forward_call(void) { check_tail0(m4dd3f6_forward_call, 0x4dd3eb); }
static void test_m4e0742_set_field_const(void) { check_setvt(m4e0742_set_field_const, 0xf2e, 0x1u); }
static void test_m4e2940_set_field_arg(void) { check_setfa(m4e2940_set_field_arg, 0x30); }
static void test_m4e2956_get_field(void) { check_getf(m4e2956_get_field, 0x30); }
static void test_m4e2967_get_field(void) { check_getf(m4e2967_get_field, 0x7a); }
static void test_m4e2978_set_field_const(void) { check_setvt(m4e2978_set_field_const, 0x177, 0x1u); }
static void test_m4e2990_set_field_arg(void) { check_setfa(m4e2990_set_field_arg, 0x18); }
static void test_m4e29a6_get_field(void) { check_getf(m4e29a6_get_field, 0x18); }
static void test_m4e40fb_forward_call_arg(void) { check_fwd1(m4e40fb_forward_call_arg, 0x4edfaf); }
static void test_m4e4114_forward_call_arg(void) { check_fwd1(m4e4114_forward_call_arg, 0x4ee0d4); }
static void test_m4e779f_forward_call_arg(void) { check_fwd1(m4e779f_forward_call_arg, 0x4ee0d4); }
static void test_m4e89b9_forward_call_arg(void) { check_fwd1(m4e89b9_forward_call_arg, 0x4edfaf); }
static void test_m4e89d2_forward_call_arg(void) { check_fwd1(m4e89d2_forward_call_arg, 0x4ee0d4); }
static void test_m4e9e6c_set_field_const(void) { check_setvt(m4e9e6c_set_field_const, 0x8256, 0x0u); }
static void test_m4ebd53_forward_call_arg(void) { check_fwd1(m4ebd53_forward_call_arg, 0x4edfaf); }
static void test_m4ebd6c_forward_call_arg(void) { check_fwd1(m4ebd6c_forward_call_arg, 0x4ee0d4); }
static void test_m4ee602_get_field(void) { check_getf(m4ee602_get_field, 0x4af); }
static void test_m4ee630_get_field(void) { check_getf(m4ee630_get_field, 0x4ab); }
static void test_m4ef4c9_set_field_arg(void) { check_setfa(m4ef4c9_set_field_arg, 0x10); }
static void test_m4ef4df_get_field(void) { check_getf(m4ef4df_get_field, 0x10); }
static void test_m4ef516_get_field(void) { check_getf(m4ef516_get_field, 0x162); }
static void test_m4f0046_forward_call(void) { check_tail0(m4f0046_forward_call, 0x4f003b); }

/* ---- exact-size buffers (meant for the sanitiser builds: a store or a load outside the bytes the original touches is a report) ----------- */
static void test_exact_size_buffers(void)
{
    uint8_t *p;
    setup();
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m402945_empty_method_args(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m40338e_empty_method_args(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4033ab_call_two_return_const(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m404b0c_empty_method_args(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m404b19_call_two_return_const(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m407c8a_empty_method_args(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m407d70_call_two_return_const(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m40905e_empty_method_args(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m40907b_call_two_return_const(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m414cb0_destruct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m423450_init_vtable_ret_self(p);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m423467_init_vtable_ret_self(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4234b5_forward_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m426b5d_call_global_object(&g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m426b7e_call_global_object(&g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m43772f_init_vtable_ret_self(p);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m43eb3a_destruct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m43ef10_init_vtable_ret_self(p);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m43ef27_init_vtable_ret_self(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m445f40_forward_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(0x8);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m447d4b_set_field_const(p);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m447e27_destruct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(0x22);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m447e62_set_field_arg(p, 5);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44883f_init_vtable_ret_self(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44885e_forward_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44afb7_destruct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44be90_init_vtable_ret_self(p);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m44bea7_init_vtable_ret_self(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m454d8a_set_word(&g_w);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m456dab_set_two_words(&g_w);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m46401a_set_word(&g_w);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4674ff_init_vtable_ret_self(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m46b73e_set_two_words(&g_w);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m470e71_set_two_words(&g_w);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m4712b0_empty_method_args(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m4782be_set_two_words(&g_w);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m488d6a_destruct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m48d119_set_word(&g_w);
    free(p);
    p = (uint8_t *)malloc(0x200f);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m493ad8_set_field_const(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m4a7ddc_set_two_words(&g_w);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m4ab459_set_word(&g_w);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m4b5c48_set_word(&g_w);
    free(p);
    p = (uint8_t *)malloc(0x2c4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4bf3a4_get_field(p);
    free(p);
    p = (uint8_t *)malloc(0x21a);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4c0c40_get_field(p);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4caeef_init_vtable_ret_self(p);
    free(p);
    p = (uint8_t *)malloc(4);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4cc927_destruct_base_set_vtable(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4d3705_call_global_object(&g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4d3714_call_global_object(&g_host);
    free(p);
    p = (uint8_t *)malloc(0x466);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4d3c1d_get_field(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    m4d51ea_empty_method_args(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4d52a6_forward_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(0x1c);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4dae66_get_field(p);
    free(p);
    p = (uint8_t *)malloc(0x20);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4dae77_get_field(p);
    free(p);
    p = (uint8_t *)malloc(0x10);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4daef1_get_field(p);
    free(p);
    p = (uint8_t *)malloc(0x10);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4daf02_set_field_arg(p, 5);
    free(p);
    p = (uint8_t *)malloc(0x14);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4daf18_get_field(p);
    free(p);
    p = (uint8_t *)malloc(0x14);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4daf29_set_field_arg(p, 5);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4db377_forward_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4dd3f6_forward_call(p, &g_host);
    free(p);
    p = (uint8_t *)malloc(0xf32);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e0742_set_field_const(p);
    free(p);
    p = (uint8_t *)malloc(0x34);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e2940_set_field_arg(p, 5);
    free(p);
    p = (uint8_t *)malloc(0x34);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e2956_get_field(p);
    free(p);
    p = (uint8_t *)malloc(0x7e);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e2967_get_field(p);
    free(p);
    p = (uint8_t *)malloc(0x17b);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e2978_set_field_const(p);
    free(p);
    p = (uint8_t *)malloc(0x1c);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e2990_set_field_arg(p, 5);
    free(p);
    p = (uint8_t *)malloc(0x1c);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e29a6_get_field(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e40fb_forward_call_arg(p, 5, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e4114_forward_call_arg(p, 5, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e779f_forward_call_arg(p, 5, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e89b9_forward_call_arg(p, 5, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e89d2_forward_call_arg(p, 5, &g_host);
    free(p);
    p = (uint8_t *)malloc(0x825a);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4e9e6c_set_field_const(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ebd53_forward_call_arg(p, 5, &g_host);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ebd6c_forward_call_arg(p, 5, &g_host);
    free(p);
    p = (uint8_t *)malloc(0x4b3);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ee602_get_field(p);
    free(p);
    p = (uint8_t *)malloc(0x4af);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ee630_get_field(p);
    free(p);
    p = (uint8_t *)malloc(0x14);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ef4c9_set_field_arg(p, 5);
    free(p);
    p = (uint8_t *)malloc(0x14);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ef4df_get_field(p);
    free(p);
    p = (uint8_t *)malloc(0x166);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4ef516_get_field(p);
    free(p);
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    L.n = 0;
    (void)m4f0046_forward_call(p, &g_host);
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
    RUN(test_m402945_empty_method_args);
    RUN(test_m40338e_empty_method_args);
    RUN(test_m4033ab_call_two_return_const);
    RUN(test_m404b0c_empty_method_args);
    RUN(test_m404b19_call_two_return_const);
    RUN(test_m407c8a_empty_method_args);
    RUN(test_m407d70_call_two_return_const);
    RUN(test_m40905e_empty_method_args);
    RUN(test_m40907b_call_two_return_const);
    RUN(test_m414cb0_destruct_base_set_vtable);
    RUN(test_m423450_init_vtable_ret_self);
    RUN(test_m423467_init_vtable_ret_self);
    RUN(test_m4234b5_forward_call);
    RUN(test_m426b5d_call_global_object);
    RUN(test_m426b7e_call_global_object);
    RUN(test_m43772f_init_vtable_ret_self);
    RUN(test_m43eb3a_destruct_base_set_vtable);
    RUN(test_m43ef10_init_vtable_ret_self);
    RUN(test_m43ef27_init_vtable_ret_self);
    RUN(test_m445f40_forward_call);
    RUN(test_m447d4b_set_field_const);
    RUN(test_m447e27_destruct_base_set_vtable);
    RUN(test_m447e62_set_field_arg);
    RUN(test_m44883f_init_vtable_ret_self);
    RUN(test_m44885e_forward_call);
    RUN(test_m44afb7_destruct_base_set_vtable);
    RUN(test_m44be90_init_vtable_ret_self);
    RUN(test_m44bea7_init_vtable_ret_self);
    RUN(test_m454d8a_set_word);
    RUN(test_m456dab_set_two_words);
    RUN(test_m46401a_set_word);
    RUN(test_m4674ff_init_vtable_ret_self);
    RUN(test_m46b73e_set_two_words);
    RUN(test_m470e71_set_two_words);
    RUN(test_m4712b0_empty_method_args);
    RUN(test_m4782be_set_two_words);
    RUN(test_m488d6a_destruct_base_set_vtable);
    RUN(test_m48d119_set_word);
    RUN(test_m493ad8_set_field_const);
    RUN(test_m4a7ddc_set_two_words);
    RUN(test_m4ab459_set_word);
    RUN(test_m4b5c48_set_word);
    RUN(test_m4bf3a4_get_field);
    RUN(test_m4c0c40_get_field);
    RUN(test_m4caeef_init_vtable_ret_self);
    RUN(test_m4cc927_destruct_base_set_vtable);
    RUN(test_m4d3705_call_global_object);
    RUN(test_m4d3714_call_global_object);
    RUN(test_m4d3c1d_get_field);
    RUN(test_m4d51ea_empty_method_args);
    RUN(test_m4d52a6_forward_call);
    RUN(test_m4dae66_get_field);
    RUN(test_m4dae77_get_field);
    RUN(test_m4daef1_get_field);
    RUN(test_m4daf02_set_field_arg);
    RUN(test_m4daf18_get_field);
    RUN(test_m4daf29_set_field_arg);
    RUN(test_m4db377_forward_call);
    RUN(test_m4dd3f6_forward_call);
    RUN(test_m4e0742_set_field_const);
    RUN(test_m4e2940_set_field_arg);
    RUN(test_m4e2956_get_field);
    RUN(test_m4e2967_get_field);
    RUN(test_m4e2978_set_field_const);
    RUN(test_m4e2990_set_field_arg);
    RUN(test_m4e29a6_get_field);
    RUN(test_m4e40fb_forward_call_arg);
    RUN(test_m4e4114_forward_call_arg);
    RUN(test_m4e779f_forward_call_arg);
    RUN(test_m4e89b9_forward_call_arg);
    RUN(test_m4e89d2_forward_call_arg);
    RUN(test_m4e9e6c_set_field_const);
    RUN(test_m4ebd53_forward_call_arg);
    RUN(test_m4ebd6c_forward_call_arg);
    RUN(test_m4ee602_get_field);
    RUN(test_m4ee630_get_field);
    RUN(test_m4ef4c9_set_field_arg);
    RUN(test_m4ef4df_get_field);
    RUN(test_m4ef516_get_field);
    RUN(test_m4f0046_forward_call);
    RUN(test_exact_size_buffers);
    return failures;
}
