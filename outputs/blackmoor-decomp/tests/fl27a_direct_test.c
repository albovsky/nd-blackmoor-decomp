/* FL-27 (batch a) direct tests of sixteen action 0x35 (movie) runtime methods of GAME.EXE in src/original_methods_fl27a.c. Prints
 * "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values
 * were derived by hand from the disassembly of GAME.EXE, not from running the native code; tests/test_fl27a_differential.py additionally
 * runs the original bytes on generated fixtures.
 *
 * Every function is checked three ways: (1) the guard matrix, each guard of the chain failing in turn (several fail values each, widths
 * probed), which must leave the objects and the call log as the original does; (2) each arm with the whole object compared with a
 * hand-edited copy, and the ordered host calls with their arguments and the state at the call; (3) the edges of every compare. */
#include "../src/original_methods_fl27a.h"

#include <stdio.h>
#include <string.h>

#pragma GCC diagnostic ignored "-Wunused-function"

static int g_failed;
static char g_msg[256];
#define CK(cond)                                                               \
    do {                                                                       \
        if (!(cond) && !g_failed) {                                            \
            g_failed = 1;                                                      \
            snprintf(g_msg, sizeof g_msg, "line %d: %.200s", __LINE__, #cond); \
        }                                                                      \
    } while (0)

#define SELF_SZ 0xa00
#define A_SZ 0x400
#define VA_A 0x20010000u       /* the argument object (a Bink handle, a string, the object of a slot) */
#define VA_B 0x20020000u       /* a second object (the pointee of a slot) */
#define VA_C 0x20030000u       /* a slot or a flag dword */
#define VA_G 0x637fd3u         /* the state dword 0x637fd3 and the object 0x637fd7 after it */
#define G_SZ 0x200
#define SNAP 0xa00

static void set32(uint8_t *o, size_t off, uint32_t v) { memcpy(o + off, &v, 4); }
static void set16(uint8_t *o, size_t off, uint16_t v) { memcpy(o + off, &v, 2); }
static uint32_t get32(const uint8_t *o, size_t off)
{
    uint32_t v;
    memcpy(&v, o + off, 4);
    return v;
}

static uint16_t get16(const uint8_t *o, size_t off)
{
    uint16_t v;
    memcpy(&v, o + off, 2);
    return v;
}

static struct {
    uint8_t self[SELF_SZ], a[A_SZ], b[A_SZ], c[0x40], g[G_SZ];
    Fl27aWorld w;
    Fl18Host host;
} fx;
static uint8_t exp_self[SELF_SZ], exp_a[A_SZ], exp_b[A_SZ], exp_c[0x40], exp_g[G_SZ];

static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[8];
        uint8_t snap_self[SNAP], snap_a[0x100], snap_c[0x40], snap_g[G_SZ];
        uint32_t b161f, v5b15d6, v5d17f5, v63a58a;      /* the world at the call */
    } c[64];
} L;

/* the script of the host: the return value per callee (all calls) and one store at the n-th call of a callee */
static struct {
    uint32_t callee, value;
} ret_script[16];
static int ret_count;
static struct {
    uint32_t callee;
    int nth, size;
    uint8_t *ptr;
    uint32_t value;
    int seen;
} poke_script[16];
static int poke_count;

static void script_ret(uint32_t callee, uint32_t value)
{
    ret_script[ret_count].callee = callee;
    ret_script[ret_count++].value = value;
}

static void script_poke(uint32_t callee, int nth, uint8_t *ptr, int size, uint32_t value)
{
    poke_script[poke_count].callee = callee;
    poke_script[poke_count].nth = nth;
    poke_script[poke_count].ptr = ptr;
    poke_script[poke_count].size = size;
    poke_script[poke_count].value = value;
    poke_script[poke_count++].seen = 0;
}

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int i, k;
    uint32_t result = 0;
    (void)ctx;
    if (L.n < 64) {
        k = L.n;
        L.c[k].callee = callee;
        L.c[k].this_ptr = this_ptr;
        L.c[k].nargs = nargs;
        for (i = 0; i < nargs && i < 8; i++) L.c[k].a[i] = args[i];
        memcpy(L.c[k].snap_self, fx.self, SNAP);
        memcpy(L.c[k].snap_a, fx.a, 0x100);
        memcpy(L.c[k].snap_c, fx.c, 0x40);
        memcpy(L.c[k].snap_g, fx.g, G_SZ);
        L.c[k].b161f = fx.w.byte_5a161f;
        L.c[k].v5b15d6 = fx.w.value_5b15d6;
        L.c[k].v5d17f5 = fx.w.value_5d17f5;
        L.c[k].v63a58a = fx.w.value_63a58a;
    }
    L.n++;
    for (i = 0; i < ret_count; i++)
        if (ret_script[i].callee == callee) result = ret_script[i].value;
    for (i = 0; i < poke_count; i++)
        if (poke_script[i].callee == callee) {
            if (poke_script[i].seen == poke_script[i].nth) memcpy(poke_script[i].ptr, &poke_script[i].value, (size_t)poke_script[i].size);
            poke_script[i].seen++;
        }
    return result;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (a >= VA_A && a < VA_A + A_SZ) return fx.a + (a - VA_A);
    if (a >= VA_B && a < VA_B + A_SZ) return fx.b + (a - VA_B);
    if (a >= VA_C && a < VA_C + 0x40) return fx.c + (a - VA_C);
    if (a >= VA_G && a < VA_G + G_SZ) return fx.g + (a - VA_G);
    return NULL;
}

/* a pristine fixture: every byte of the objects a pattern, the world zero, no scripted answers */
static void setup(void)
{
    size_t b;
    memset(fx.self, 0xA5, sizeof fx.self);
    for (b = 0; b < A_SZ; b++) {
        fx.a[b] = (uint8_t)(b * 7 + 3);
        fx.b[b] = (uint8_t)(b * 5 + 1);
    }
    memset(fx.c, 0x5A, sizeof fx.c);
    memset(fx.g, 0x3C, sizeof fx.g);
    memset(&fx.w, 0, sizeof fx.w);
    memset(&fx.host, 0, sizeof fx.host);
    fx.host.call = host_call;
    fx.host.resolve = host_resolve;
    memset(&L, 0, sizeof L);
    memset(ret_script, 0, sizeof ret_script);
    memset(poke_script, 0, sizeof poke_script);
    ret_count = poke_count = 0;
}

static void expect_begin(void)
{
    memcpy(exp_self, fx.self, sizeof exp_self);
    memcpy(exp_a, fx.a, sizeof exp_a);
    memcpy(exp_b, fx.b, sizeof exp_b);
    memcpy(exp_c, fx.c, sizeof exp_c);
    memcpy(exp_g, fx.g, sizeof exp_g);
}

static void expect_end_at(int line)
{
    if (!g_failed && (memcmp(exp_self, fx.self, sizeof exp_self) != 0 || memcmp(exp_a, fx.a, sizeof exp_a) != 0 || memcmp(exp_b, fx.b, sizeof exp_b) != 0 ||
                      memcmp(exp_c, fx.c, sizeof exp_c) != 0 || memcmp(exp_g, fx.g, sizeof exp_g) != 0)) {
        g_failed = 1;
        snprintf(g_msg, sizeof g_msg, "line %d: the object or an argument object differs from the expected copy", line);
    }
}

#define expect_end() expect_end_at(__LINE__)

/* call n: the callee, the value of ecx, the number of stack arguments */
static void ck_call(int n, uint32_t callee, uintptr_t this_ptr, int nargs)
{
    CK(L.n > n);
    if (L.n <= n) return;
    CK(L.c[n].callee == callee);
    CK(L.c[n].this_ptr == this_ptr);
    CK(L.c[n].nargs == nargs);
}

static void ck_arg(int n, int i, uintptr_t v)
{
    if (L.n > n && i < 8) CK(L.c[n].a[i] == v);
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x4de1f5 */

static void test_m4de1f5_clear_flags(void)
{
    int round;
    for (round = 0; round < 4; round++) {
        static const uint8_t FLAGS[4] = {0xff, 1, 0x80, 0};
        setup();
        set32(fx.self, 0x991, round == 3 ? 0u : 0xffffffffu);
        fx.w.byte_5a161f = FLAGS[round];
        fx.w.value_5b15d6 = 7;
        fx.w.value_5d17f5 = 8;
        fx.w.value_63a58a = 9;
        expect_begin();
        m4de1f5_clear_flags(fx.self, &fx.w);
        set32(exp_self, 0x991, 0);                       /* the dword, not the neighbours 0x990 and 0x995 */
        expect_end();
        CK(fx.w.byte_5a161f == 0);
        CK(fx.w.value_5b15d6 == 7 && fx.w.value_5d17f5 == 8 && fx.w.value_63a58a == 9 && fx.w.native_spin_limit == 0);
        CK(L.n == 0);
    }
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x4de214: calls 0x4de1f5 (natively), so its two effects are the whole observable behaviour; no host call */

static void test_m4de214_clear_flags_thunk(void)
{
    int round;
    for (round = 0; round < 4; round++) {
        static const uint8_t FLAGS[4] = {0xff, 1, 0x80, 0};
        setup();
        set32(fx.self, 0x991, round == 3 ? 0u : 0xffffffffu);
        fx.w.byte_5a161f = FLAGS[round];
        fx.w.value_5b15d6 = 7;
        expect_begin();
        m4de214_clear_flags_thunk(fx.self, &fx.w);
        set32(exp_self, 0x991, 0);
        expect_end();
        CK(fx.w.byte_5a161f == 0 && fx.w.value_5b15d6 == 7);
        CK(L.n == 0);
    }
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x4de2d8: [self+0x991] = 1; 0x4e053f(1) and 0x4e1113 with the singleton ecx; the two dwords cleared AFTER the calls; 0x4de214 last */

static void test_m4de2d8_reset_caption(void)
{
    int round;
    for (round = 0; round < 4; round++) {
        static const uint8_t FLAGS[4] = {0xff, 1, 0x80, 0};
        setup();
        set32(fx.self, 0x991, round == 3 ? 0u : 0xdeadbeefu);
        fx.w.byte_5a161f = FLAGS[round];
        fx.w.value_5b15d6 = 0x11111111u + (uint32_t)round;
        fx.w.value_5d17f5 = 0x22222222u + (uint32_t)round;
        fx.w.value_63a58a = 9;
        script_ret(0x4e053f, 0x77);
        expect_begin();
        m4de2d8_reset_caption(fx.self, &fx.w, &fx.host);
        set32(exp_self, 0x991, 0);                       /* set to 1 first, cleared by 0x4de214 at the end */
        expect_end();
        CK(L.n == 2);
        ck_call(0, 0x4e053f, 0x570508, 1);
        ck_arg(0, 0, 1);
        ck_call(1, 0x4e1113, 0x570508, 0);
        /* at both calls: [self+0x991] is 1 (its neighbours untouched), the flags and the two dwords are still the old values */
        CK(get32(L.c[0].snap_self, 0x991) == 1 && get32(L.c[1].snap_self, 0x991) == 1);
        CK(L.c[0].snap_self[0x990] == 0xA5 && L.c[0].snap_self[0x995] == 0xA5);
        CK(L.c[0].b161f == FLAGS[round] && L.c[1].b161f == FLAGS[round]);
        CK(L.c[0].v5b15d6 == 0x11111111u + (uint32_t)round && L.c[1].v5b15d6 == 0x11111111u + (uint32_t)round);
        CK(L.c[0].v5d17f5 == 0x22222222u + (uint32_t)round && L.c[1].v5d17f5 == 0x22222222u + (uint32_t)round);
        CK(fx.w.byte_5a161f == 0 && fx.w.value_5b15d6 == 0 && fx.w.value_5d17f5 == 0 && fx.w.value_63a58a == 9);
    }
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x449d90: file = 0x50d0a9(path, 0x548aac); 0 -> return 0 with no further call; else 0x50cee4(file), return 1 */

static void test_m449d90_file_exists(void)
{
    static const uint32_t FILES[] = {1, 2, 0x100, 0x10000, 0x01000000u, 0x80000000u, 0xffffffffu};
    size_t i;
    int32_t r;
    setup();
    script_ret(0x50d0a9, 0);
    expect_begin();
    r = m449d90_file_exists(VA_A + 5, &fx.host);
    CK(r == 0);
    CK(L.n == 1);
    ck_call(0, 0x50d0a9, 0, 2);
    ck_arg(0, 0, VA_A + 5);                    /* the path is the last pushed: the first argument */
    ck_arg(0, 1, 0x548aac);
    expect_end();
    for (i = 0; i < sizeof FILES / sizeof FILES[0]; i++) {
        setup();
        script_ret(0x50d0a9, FILES[i]);
        script_ret(0x50cee4, 0xdead);              /* the answer of the close is ignored */
        r = m449d90_file_exists(0x12345678u, &fx.host);
        CK(r == 1);
        CK(L.n == 2);
        ck_call(0, 0x50d0a9, 0, 2);
        ck_arg(0, 0, 0x12345678u);
        ck_arg(0, 1, 0x548aac);
        ck_call(1, 0x50cee4, 0, 1);
        ck_arg(1, 0, FILES[i]);
    }
}

/*TESTS*/

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* a bounded random sweep over every port (for the sanitiser builds): arbitrary bytes in the objects, host calls recorded */

static uint32_t g_seed = 0x2545f491u;
static uint32_t rnd(void)
{
    g_seed ^= g_seed << 13;
    g_seed ^= g_seed >> 17;
    g_seed ^= g_seed << 5;
    return g_seed;
}

static void test_sweep(void)
{
    int iter;
    for (iter = 0; iter < 400; iter++) {
        size_t b;
        setup();
        for (b = 0; b < sizeof fx.self; b++) fx.self[b] = (uint8_t)(rnd() >> 7);
        for (b = 0; b < A_SZ; b++) fx.a[b] = (uint8_t)(rnd() % 5 == 0 ? rnd() >> 9 : 0);
        for (b = 0; b < A_SZ; b++) fx.b[b] = (uint8_t)(rnd() % 5 == 0 ? rnd() >> 9 : 0);
        fx.w.byte_5a161f = (uint8_t)(rnd() % 3);
        L.n = 0;
        m4de1f5_clear_flags(fx.self, &fx.w);
        m4de214_clear_flags_thunk(fx.self, &fx.w);
        m4de2d8_reset_caption(fx.self, &fx.w, &fx.host);
        (void)m449d90_file_exists(VA_A + (rnd() % 64), &fx.host);
        /*SWEEP*/
    }
    CK(1);
}

static const struct {
    const char *name;
    void (*fn)(void);
} CASES[] = {
    {"test_m4de1f5_clear_flags", test_m4de1f5_clear_flags},
    {"test_m4de214_clear_flags_thunk", test_m4de214_clear_flags_thunk},
    {"test_m4de2d8_reset_caption", test_m4de2d8_reset_caption},
    {"test_m449d90_file_exists", test_m449d90_file_exists},
    /*CASELIST*/
    {"test_sweep_bounded", test_sweep},
};

int main(void)
{
    size_t i;
    int failures = 0;
    for (i = 0; i < sizeof CASES / sizeof CASES[0]; i++) {
        g_failed = 0;
        g_msg[0] = 0;
        CASES[i].fn();
        if (g_failed) {
            printf("FAIL %s: %s\n", CASES[i].name, g_msg);
            failures++;
        } else {
            printf("PASS %s\n", CASES[i].name);
        }
    }
    return failures;
}
