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

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x44c479: while *state == 1: Sleep(1); then 2 -> return 2, else *state = 1, return 1 (a dword at an odd address) */

#define STATE_VA (VA_C + 1u)

static void test_m44c479_wait_state(void)
{
    static const uint32_t OTHERS[] = {0, 3, 4, 0x100, 0x10000, 0x01000000u, 0x80000000u, 0xffffffffu, 0x201};
    size_t i;
    int32_t r;
    int k;
    for (i = 0; i < sizeof OTHERS / sizeof OTHERS[0]; i++) {            /* not 1 and not 2: no wait, stored 1 */
        setup();
        set32(fx.c, 1, OTHERS[i]);
        expect_begin();
        r = m44c479_wait_state(STATE_VA, &fx.w, &fx.host);
        CK(r == 1 && L.n == 0);
        set32(exp_c, 1, 1);                                              /* the dword only, at an odd offset: its neighbours stay */
        expect_end();
    }
    setup();                                                            /* 2: returned as it is, nothing stored */
    set32(fx.c, 1, 2);
    expect_begin();
    r = m44c479_wait_state(STATE_VA, &fx.w, &fx.host);
    CK(r == 2 && L.n == 0);
    expect_end();
    for (k = 0; k < 4; k++) {                                            /* 1: Sleep(1) per read, until the other thread sets the value */
        static const uint32_t ENDS[] = {2, 0, 7, 0x101};
        size_t e;
        for (e = 0; e < 4; e++) {
            int j;
            setup();
            set32(fx.c, 1, 1);
            script_poke(0x52a2b0, k, fx.c + 1, 4, ENDS[e]);
            expect_begin();
            r = m44c479_wait_state(STATE_VA, &fx.w, &fx.host);
            CK(r == (ENDS[e] == 2 ? 2 : 1));
            CK(L.n == k + 1);
            for (j = 0; j < L.n && j < 64; j++) {
                ck_call(j, 0x52a2b0, 0, 1);
                ck_arg(j, 0, 1);
                CK(get32(L.c[j].snap_c, 1) == 1);                        /* the dword is still 1 at every Sleep (before the store of the other thread) */
            }
            set32(exp_c, 1, ENDS[e] == 2 ? 2 : 1);
            expect_end();
        }
    }
    /* native rejection: the dword never leaves 1 */
    setup();
    set32(fx.c, 1, 1);
    fx.w.native_spin_limit = 5;
    r = m44c479_wait_state(STATE_VA, &fx.w, &fx.host);
    CK(r == FL27A_REJECTED && L.n == 5 && get32(fx.c, 1) == 1);
    setup();
    set32(fx.c, 1, 1);
    r = m44c479_wait_state(STATE_VA, &fx.w, &fx.host);                   /* the default bound */
    CK(r == FL27A_REJECTED && L.n == (int)FL27A_SPIN_LIMIT);
    setup();                                                            /* a limit of 1 stops at the first Sleep, but a wait that ends first is not rejected */
    set32(fx.c, 1, 1);
    fx.w.native_spin_limit = 2;
    script_poke(0x52a2b0, 0, fx.c + 1, 4, 2);
    CK(m44c479_wait_state(STATE_VA, &fx.w, &fx.host) == 2 && L.n == 1);
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x4bee2c: 0x4bf38c(self) first; handle 0 -> [self+0x2c0] = -3, return -1; else return [handle+0xc] */

static void test_m4bee2c_get_field(void)
{
    static const uint32_t FIELDS[] = {0, 1, 0x100, 0x10000, 0x01000000u, 0x80000000u, 0xffffffffu, 0x12345678u};
    size_t i;
    int32_t r;
    setup();
    expect_begin();
    r = m4bee2c_get_field(fx.self, 0, &fx.host);
    CK(r == -1);
    CK(L.n == 1);
    ck_call(0, 0x4bf38c, (uintptr_t)fx.self, 0);
    CK(get32(L.c[0].snap_self, 0x2c0) == 0xa5a5a5a5u);                  /* the call comes first */
    set32(exp_self, 0x2c0, 0xfffffffdu);
    expect_end();
    for (i = 0; i < sizeof FIELDS / sizeof FIELDS[0]; i++) {
        setup();
        set32(fx.a, 0x1c, FIELDS[i]);                                    /* handle = VA_A + 0x10 */
        expect_begin();
        r = m4bee2c_get_field(fx.self, VA_A + 0x10, &fx.host);
        CK((uint32_t)r == FIELDS[i]);
        CK(L.n == 1);
        ck_call(0, 0x4bf38c, (uintptr_t)fx.self, 0);
        expect_end();                                                    /* nothing is written when the handle is not null */
    }
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x4bef85: 0x4bf38c(self); handle 0 -> [self+0x2c0] = -3, return 0; else _BinkWait(handle): non-zero -> 0, zero -> 1 */

static void test_m4bef85_bink_wait(void)
{
    static const uint32_t WAITS[] = {1, 2, 0x100, 0x10000, 0x01000000u, 0x80000000u, 0xffffffffu};
    size_t i;
    setup();
    script_ret(0x52a52c, 7);                                             /* never called */
    expect_begin();
    CK(m4bef85_bink_wait(fx.self, 0, &fx.host) == 0);
    CK(L.n == 1);
    ck_call(0, 0x4bf38c, (uintptr_t)fx.self, 0);
    set32(exp_self, 0x2c0, 0xfffffffdu);
    expect_end();
    setup();
    expect_begin();
    CK(m4bef85_bink_wait(fx.self, VA_A + 0x40, &fx.host) == 1);          /* the import answers 0 */
    CK(L.n == 2);
    ck_call(0, 0x4bf38c, (uintptr_t)fx.self, 0);
    ck_call(1, 0x52a52c, 0, 1);
    ck_arg(1, 0, VA_A + 0x40);
    expect_end();
    for (i = 0; i < sizeof WAITS / sizeof WAITS[0]; i++) {
        setup();
        script_ret(0x52a52c, WAITS[i]);
        expect_begin();
        CK(m4bef85_bink_wait(fx.self, 0x1234, &fx.host) == 0);
        CK(L.n == 2);
        ck_call(1, 0x52a52c, 0, 1);
        ck_arg(1, 0, 0x1234);
        expect_end();
    }
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x4bee5f: 0x4bf38c(self); handle 0 -> 124 bytes at self+8 cleared, [self+0x2c0] = -3, return 0; else _BinkGetSummary(handle, self+8), return self+8 */

static void test_m4bee5f_bink_summary(void)
{
    uint8_t *r;
    size_t b;
    setup();
    expect_begin();
    r = m4bee5f_bink_summary(fx.self, 0, &fx.host);
    CK(r == NULL);
    CK(L.n == 1);
    ck_call(0, 0x4bf38c, (uintptr_t)fx.self, 0);
    for (b = 8; b < 8 + 0x1f * 4; b++) exp_self[b] = 0;                  /* exactly 0x1f dwords: the bytes 7 and 0x84 stay */
    set32(exp_self, 0x2c0, 0xfffffffdu);
    expect_end();
    CK(fx.self[7] == 0xA5 && fx.self[0x84] == 0xA5 && fx.self[8] == 0 && fx.self[0x83] == 0);
    CK(L.c[0].snap_self[8] == 0xA5);                                     /* cleared after the first call */
    setup();
    script_ret(0x52a508, 0x55);
    expect_begin();
    r = m4bee5f_bink_summary(fx.self, VA_A + 0x20, &fx.host);
    CK(r == fx.self + 8);
    CK(L.n == 2);
    ck_call(0, 0x4bf38c, (uintptr_t)fx.self, 0);
    ck_call(1, 0x52a508, 0, 2);
    ck_arg(1, 0, VA_A + 0x20);                                           /* the handle is the last pushed = the first argument */
    ck_arg(1, 1, (uintptr_t)(fx.self + 8));
    expect_end();                                                        /* the object is not written when the handle is not null */
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x4befc8: 0x4bf38c(self); [self+0xbc] = 0; handle 0 -> [self+0x2c0] = -3, return [self+0xbc]; else [self+0xbc] = _BinkDoFrame(handle), return it */

static void test_m4befc8_bink_do_frame(void)
{
    static const uint32_t FRAMES[] = {0, 1, 2, 0x100, 0x10000, 0x01000000u, 0x80000000u, 0xffffffffu};
    size_t i;
    setup();
    script_ret(0x52a528, 9);                                             /* never called */
    expect_begin();
    CK(m4befc8_bink_do_frame(fx.self, 0, &fx.host) == 0);
    CK(L.n == 1);
    ck_call(0, 0x4bf38c, (uintptr_t)fx.self, 0);
    CK(get32(L.c[0].snap_self, 0xbc) == 0xa5a5a5a5u);                    /* cleared after the first call */
    set32(exp_self, 0xbc, 0);
    set32(exp_self, 0x2c0, 0xfffffffdu);
    expect_end();
    for (i = 0; i < sizeof FRAMES / sizeof FRAMES[0]; i++) {
        setup();
        script_ret(0x52a528, FRAMES[i]);
        expect_begin();
        CK((uint32_t)m4befc8_bink_do_frame(fx.self, VA_A + 0x18, &fx.host) == FRAMES[i]);
        CK(L.n == 2);
        ck_call(0, 0x4bf38c, (uintptr_t)fx.self, 0);
        ck_call(1, 0x52a528, 0, 1);
        ck_arg(1, 0, VA_A + 0x18);
        CK(get32(L.c[1].snap_self, 0xbc) == 0);                          /* the import sees the cleared field */
        set32(exp_self, 0xbc, FRAMES[i]);
        expect_end();
    }
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x4bef11: 0x4bf38c(self); handle 0 -> [self+0x2c0] = -3, return -3; else [self+0x2c4] = mode, _BinkGoto(handle, mode == 1 ? [handle+8] : 1, 0), return 0 */

static void test_m4bef11_bink_goto(void)
{
    static const uint32_t OTHER_MODES[] = {0, 2, 3, 0x100, 0x101, 0x10000, 0x01000000u, 0x80000000u, 0xffffffffu};
    size_t i;
    setup();
    expect_begin();
    CK(m4bef11_bink_goto(fx.self, 0, 1, &fx.host) == -3);               /* the mode is not stored */
    CK(L.n == 1);
    ck_call(0, 0x4bf38c, (uintptr_t)fx.self, 0);
    set32(exp_self, 0x2c0, 0xfffffffdu);
    expect_end();
    setup();                                                            /* mode 1: the frame count of the handle */
    set32(fx.a, 0x18, 0x00000abcu);                                      /* handle = VA_A + 0x10: [handle + 8] */
    set32(fx.a, 0x14, 0xdeadbeefu);
    expect_begin();
    CK(m4bef11_bink_goto(fx.self, VA_A + 0x10, 1, &fx.host) == 0);
    CK(L.n == 2);
    ck_call(0, 0x4bf38c, (uintptr_t)fx.self, 0);
    ck_call(1, 0x52a530, 0, 3);
    ck_arg(1, 0, VA_A + 0x10);
    ck_arg(1, 1, 0xabc);
    ck_arg(1, 2, 0);
    CK(get32(L.c[1].snap_self, 0x2c4) == 1);                             /* stored before the import */
    set32(exp_self, 0x2c4, 1);
    expect_end();
    for (i = 0; i < sizeof OTHER_MODES / sizeof OTHER_MODES[0]; i++) {
        setup();
        expect_begin();
        CK(m4bef11_bink_goto(fx.self, VA_A + 0x10, OTHER_MODES[i], &fx.host) == 0);
        CK(L.n == 2);
        ck_call(1, 0x52a530, 0, 3);
        ck_arg(1, 0, VA_A + 0x10);
        ck_arg(1, 1, 1);
        ck_arg(1, 2, 0);
        set32(exp_self, 0x2c4, OTHER_MODES[i]);
        expect_end();
    }
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x4bf098: 0x4bf38c(self); [self+0xbc] = 0; handle 0 -> [self+0x2c0] = -3, return [self+0xbc]; else [self+0xbc] = _BinkCopyToBuffer(handle, 5 args, [self+4]) */

static void test_m4bf098_bink_copy_to_buffer(void)
{
    static const uint32_t RESULTS[] = {0, 1, 2, 0x100, 0x10000, 0x01000000u, 0x80000000u, 0xffffffffu};
    size_t i;
    setup();
    set32(fx.self, 4, 0x7777u);
    script_ret(0x52a524, 9);                                             /* never called */
    expect_begin();
    CK(m4bf098_bink_copy_to_buffer(fx.self, 0, 0x22, 0x33, 0x44, 0x55, 0x66, &fx.host) == 0);
    CK(L.n == 1);
    ck_call(0, 0x4bf38c, (uintptr_t)fx.self, 0);
    CK(get32(L.c[0].snap_self, 0xbc) == 0xa5a5a5a5u);                    /* cleared after the first call */
    set32(exp_self, 0xbc, 0);
    set32(exp_self, 0x2c0, 0xfffffffdu);
    expect_end();
    for (i = 0; i < sizeof RESULTS / sizeof RESULTS[0]; i++) {
        setup();
        set32(fx.self, 4, 0x7777u);
        script_ret(0x52a524, RESULTS[i]);
        expect_begin();
        CK((uint32_t)m4bf098_bink_copy_to_buffer(fx.self, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, &fx.host) == RESULTS[i]);
        CK(L.n == 2);
        ck_call(0, 0x4bf38c, (uintptr_t)fx.self, 0);
        ck_call(1, 0x52a524, 0, 7);
        ck_arg(1, 0, 0x11);                                              /* the first argument is the handle ([ebp+8], pushed last) */
        ck_arg(1, 1, 0x22);
        ck_arg(1, 2, 0x33);
        ck_arg(1, 3, 0x44);
        ck_arg(1, 4, 0x55);
        ck_arg(1, 5, 0x66);
        ck_arg(1, 6, 0x7777);                                            /* [self + 4] is the last argument (pushed first) */
        CK(get32(L.c[1].snap_self, 0xbc) == 0);                          /* the import sees the cleared field */
        set32(exp_self, 0xbc, RESULTS[i]);
        expect_end();
    }
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x4bf10f: 0x4bf38c(self); handle 0 -> [self+0x2c0] = -3, return 0; mode != 1: cur == total -> 0 else NextFrame, 1; mode == 1: cur == 1 -> 0 else Goto(cur - 1), 1 */

static void set_handle(uint32_t total, uint32_t cur)                      /* the handle is VA_A + 0x10 */
{
    set32(fx.a, 0x18, total);
    set32(fx.a, 0x1c, cur);
}

static void test_m4bf10f_bink_next(void)
{
    static const uint32_t MODES[] = {0, 2, 0x100, 0x101, 0x10000, 0x01000000u, 0x80000000u, 0xffffffffu};
    static const uint32_t CURS[] = {0, 2, 0x100, 0x101, 0x10001, 0x10000, 0x80000000u, 0xffffffffu, 5};
    size_t i;
    setup();
    set32(fx.self, 0x2c4, 1);
    expect_begin();
    CK(m4bf10f_bink_next(fx.self, 0, &fx.host) == 0);
    CK(L.n == 1);
    ck_call(0, 0x4bf38c, (uintptr_t)fx.self, 0);
    set32(exp_self, 0x2c0, 0xfffffffdu);
    expect_end();
    for (i = 0; i < sizeof MODES / sizeof MODES[0]; i++) {               /* mode not 1 (compared as a dword) */
        static const uint32_t TOTALS[] = {7, 0x100, 0x10001, 0xffffffffu};
        size_t t, d;
        for (t = 0; t < 4; t++) {
            setup();
            set32(fx.self, 0x2c4, MODES[i]);
            set_handle(TOTALS[t], TOTALS[t]);                            /* current == total: nothing */
            expect_begin();
            CK(m4bf10f_bink_next(fx.self, VA_A + 0x10, &fx.host) == 0);
            CK(L.n == 1);
            expect_end();
            for (d = 0; d < 4; d++) {                                    /* current differs in one byte only */
                setup();
                set32(fx.self, 0x2c4, MODES[i]);
                set_handle(TOTALS[t], TOTALS[t] ^ (1u << (8 * d)));
                expect_begin();
                CK(m4bf10f_bink_next(fx.self, VA_A + 0x10, &fx.host) == 1);
                CK(L.n == 2);
                ck_call(1, 0x52a520, 0, 1);
                ck_arg(1, 0, VA_A + 0x10);
                expect_end();
            }
        }
    }
    for (i = 0; i < sizeof CURS / sizeof CURS[0]; i++) {                 /* mode 1 */
        setup();
        set32(fx.self, 0x2c4, 1);
        set_handle(CURS[i], CURS[i]);                                    /* the total is not looked at */
        expect_begin();
        if (CURS[i] == 1) {
            CK(m4bf10f_bink_next(fx.self, VA_A + 0x10, &fx.host) == 0 && L.n == 1);
        } else {
            CK(m4bf10f_bink_next(fx.self, VA_A + 0x10, &fx.host) == 1);
            CK(L.n == 2);
            ck_call(1, 0x52a530, 0, 3);
            ck_arg(1, 0, VA_A + 0x10);
            ck_arg(1, 1, CURS[i] - 1u);
            ck_arg(1, 2, 0);
        }
        expect_end();
    }
    setup();                                                            /* mode 1, current exactly 1, different from the total: nothing */
    set32(fx.self, 0x2c4, 1);
    set_handle(9, 1);
    CK(m4bf10f_bink_next(fx.self, VA_A + 0x10, &fx.host) == 0 && L.n == 1);
    setup();                                                            /* 0x101 and 0x10001 are not 1 */
    set32(fx.self, 0x2c4, 1);
    set_handle(9, 0x101);
    CK(m4bf10f_bink_next(fx.self, VA_A + 0x10, &fx.host) == 1 && L.n == 2);
    CK(L.c[1].a[1] == 0x100);
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x4bf315: 0x4bf38c(self), 0x4bede7(self); empty name -> [self+0x2c0] = -5, return 0; else _BinkOpen(name, flags): 0 -> [self+0x2c0] = -6, return 0; else the handle */

static void test_m4bf315_bink_open(void)
{
    static const uint32_t HANDLES[] = {1, 2, 0x100, 0x10000, 0x01000000u, 0x80000000u, 0xffffffffu};
    static const uint8_t FIRST[] = {1, 0x41, 0x80, 0xff};
    size_t i;
    setup();
    fx.a[0x10] = 0;                                                     /* the name is VA_A + 0x10: empty, junk behind the terminator */
    fx.a[0x11] = 'x';
    script_ret(0x52a518, 5);                                            /* never called */
    expect_begin();
    CK(m4bf315_bink_open(fx.self, VA_A + 0x10, 0x99, &fx.host) == 0);
    CK(L.n == 2);
    ck_call(0, 0x4bf38c, (uintptr_t)fx.self, 0);
    ck_call(1, 0x4bede7, (uintptr_t)fx.self, 0);
    CK(get32(L.c[1].snap_self, 0x2c0) == 0xa5a5a5a5u);
    set32(exp_self, 0x2c0, 0xfffffffbu);
    expect_end();
    for (i = 0; i < sizeof FIRST; i++) {                                /* the first byte alone decides; the open fails (zero) */
        setup();
        fx.a[0x10] = FIRST[i];
        fx.a[0x11] = 0;
        expect_begin();
        CK(m4bf315_bink_open(fx.self, VA_A + 0x10, 0x4242, &fx.host) == 0);
        CK(L.n == 3);
        ck_call(2, 0x52a518, 0, 2);
        ck_arg(2, 0, VA_A + 0x10);                                      /* the name is the last pushed = the first argument */
        ck_arg(2, 1, 0x4242);
        set32(exp_self, 0x2c0, 0xfffffffau);
        expect_end();
    }
    for (i = 0; i < sizeof HANDLES / sizeof HANDLES[0]; i++) {
        setup();
        fx.a[0x10] = 'a';
        fx.a[0x11] = 'b';
        fx.a[0x12] = 0;
        script_ret(0x52a518, HANDLES[i]);
        expect_begin();
        CK(m4bf315_bink_open(fx.self, VA_A + 0x10, 0xabcd0123u, &fx.host) == HANDLES[i]);
        CK(L.n == 3);
        ck_call(0, 0x4bf38c, (uintptr_t)fx.self, 0);
        ck_call(1, 0x4bede7, (uintptr_t)fx.self, 0);
        ck_call(2, 0x52a518, 0, 2);
        ck_arg(2, 0, VA_A + 0x10);
        ck_arg(2, 1, 0xabcd0123u);
        expect_end();                                                   /* no error code on success */
    }
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x4c2dfb: slot -> p; p == 0 -> nothing; bit0 of [p+0x55] clear -> 0x4c2e5b(self, p), set -> [p] = 0; then free(*slot) (re-read) and *slot = 0 */

static void test_m4c2dfb_free_pair(void)
{
    static const uint32_t SET[] = {1, 3, 0xffffffffu, 0x80000001u, 0x01010101u, 0x100001u};
    static const uint32_t CLEAR[] = {0, 2, 0x100, 0xfffffffeu, 0x80000000u, 0x01010100u, 0x10000};
    size_t i;
    setup();                                                            /* the slot (VA_C + 4) is null */
    set32(fx.c, 4, 0);
    expect_begin();
    m4c2dfb_free_pair(fx.self, VA_C + 4, &fx.host);
    CK(L.n == 0);
    expect_end();
    for (i = 0; i < sizeof SET / sizeof SET[0]; i++) {                  /* bit 0 set: [p] = 0, no callee */
        setup();
        set32(fx.c, 4, VA_B + 0x10);
        set32(fx.b, 0x10 + 0x55, SET[i]);
        set32(fx.b, 0x10, 0xcafef00du);
        expect_begin();
        m4c2dfb_free_pair(fx.self, VA_C + 4, &fx.host);
        CK(L.n == 1);
        ck_call(0, 0x51dc6c, 0, 1);
        ck_arg(0, 0, VA_B + 0x10);
        CK(get32(L.c[0].snap_c, 4) == VA_B + 0x10);                      /* the slot is cleared only after the free */
        set32(exp_b, 0x10, 0);                                           /* one dword */
        set32(exp_c, 4, 0);
        expect_end();
    }
    for (i = 0; i < sizeof CLEAR / sizeof CLEAR[0]; i++) {              /* bit 0 clear: the callee gets (self, p); [p] stays */
        setup();
        set32(fx.c, 4, VA_B + 0x10);
        set32(fx.b, 0x10 + 0x55, CLEAR[i]);
        expect_begin();
        m4c2dfb_free_pair(fx.self, VA_C + 4, &fx.host);
        CK(L.n == 2);
        ck_call(0, 0x4c2e5b, (uintptr_t)fx.self, 1);
        ck_arg(0, 0, VA_B + 0x10);
        ck_call(1, 0x51dc6c, 0, 1);
        ck_arg(1, 0, VA_B + 0x10);
        set32(exp_c, 4, 0);
        expect_end();
    }
    setup();                                                            /* the callee replaces the slot: the NEW value is freed, the slot is cleared */
    set32(fx.c, 4, VA_B + 0x10);
    set32(fx.b, 0x10 + 0x55, 0);
    script_poke(0x4c2e5b, 0, fx.c + 4, 4, 0x20061234u);
    expect_begin();
    m4c2dfb_free_pair(fx.self, VA_C + 4, &fx.host);
    CK(L.n == 2);
    ck_arg(1, 0, 0x20061234u);
    set32(exp_c, 4, 0);
    expect_end();
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x4159db: byte [a+0x20] == 2 -> 0x415db9(self; a, word); else 0x415011, 0x50ca3e (byte re-read, a+0x151), 0x52139c, [0x63a58a] = 4, 0x4c97b4 */

static void test_m4159db_dispatch_piece(void)
{
    static const uint8_t OTHER[] = {0, 1, 3, 0x82, 0xff, 0x20, 0x12};
    static const uint16_t WORDS[] = {0, 1, 0xffff, 0x8000, 0x1234};
    size_t i;
    for (i = 0; i < sizeof WORDS / sizeof WORDS[0]; i++) {
        setup();
        fx.a[0x30 + 0x20] = 2;                                           /* a = VA_A + 0x30; the neighbours are non-zero: a byte compare */
        fx.a[0x30 + 0x21] = 0x7f;
        fx.a[0x30 + 0x1f] = 0x7e;
        fx.w.value_63a58a = 0x77;
        expect_begin();
        m4159db_dispatch_piece(fx.self, VA_A + 0x30, WORDS[i], &fx.w, &fx.host);
        CK(L.n == 1);
        ck_call(0, 0x415db9, (uintptr_t)fx.self, 2);
        ck_arg(0, 0, VA_A + 0x30);                                       /* the object is the last pushed = the first argument */
        ck_arg(0, 1, WORDS[i]);
        CK(fx.w.value_63a58a == 0x77);
        expect_end();
    }
    for (i = 0; i < sizeof OTHER; i++) {
        setup();
        fx.a[0x30 + 0x20] = OTHER[i];
        fx.a[0x30 + 0x21] = 0;
        fx.w.value_63a58a = 0x77;
        expect_begin();
        m4159db_dispatch_piece(fx.self, VA_A + 0x30, 0x55, &fx.w, &fx.host);
        CK(L.n == 4);
        ck_call(0, 0x415011, (uintptr_t)fx.self, 1);
        ck_arg(0, 0, VA_A + 0x30);
        ck_call(1, 0x50ca3e, 0, 4);
        ck_arg(1, 0, 0x63888b);
        ck_arg(1, 1, 0x541dd8);
        ck_arg(1, 2, OTHER[i]);                                          /* zero-extended byte */
        ck_arg(1, 3, VA_A + 0x30 + 0x151);
        ck_call(2, 0x52139c, 0, 3);
        ck_arg(2, 0, 0x63888b);
        ck_arg(2, 1, 0);
        ck_arg(2, 2, 0);
        ck_call(3, 0x4c97b4, 0x5cf659, 0);
        CK(L.c[0].v63a58a == 0x77 && L.c[1].v63a58a == 0x77 && L.c[2].v63a58a == 0x77);   /* 4 is stored after 0x52139c, before 0x4c97b4 */
        CK(L.c[3].v63a58a == 4);
        CK(fx.w.value_63a58a == 4);
        expect_end();
    }
    setup();                                                            /* 0x415011 changes the byte: the formatted byte is the NEW one */
    fx.a[0x30 + 0x20] = 4;
    script_poke(0x415011, 0, fx.a + 0x30 + 0x20, 1, 0xaa);
    m4159db_dispatch_piece(fx.self, VA_A + 0x30, 0, &fx.w, &fx.host);
    CK(L.n == 4);
    ck_arg(1, 2, 0xaa);
}

/* --------------------------------------------------------------------------------------------------------------------------------- */
/* 0x4c0c7d: stop flag -> 0x51ec84(0, 1); else word [obj+0x1cc] == 0 -> 0x44c479 (ax != 2 -> switch [obj+0x172]: 0x41546f / 0x4156ea / none; 0x44c4ab; word = 1); Sleep(1) */

#define OBJ_VA (VA_G + 4u)
#define W1CC 0x1d0         /* the word [obj + 0x1cc] in fx.g */
#define SEL172 0x176       /* the dword [obj + 0x172] in fx.g */

static void setup_thread(uint32_t flag, uint16_t w1cc, uint32_t state, uint32_t sel)
{
    setup();
    set32(fx.c, 8, flag);                                               /* param = VA_C + 8 */
    set32(fx.g, 0, state);
    set16(fx.g, W1CC, w1cc);
    set16(fx.g, W1CC + 2, 0xffff);
    set32(fx.g, SEL172, sel);
}

static void test_m4c0c7d_movie_thread(void)
{
    static const uint32_t FLAGS[] = {1, 0x100, 0x10000, 0x01000000u, 0x80000000u, 0xffffffffu};
    size_t i;
    int32_t r;
    for (i = 0; i < sizeof FLAGS / sizeof FLAGS[0]; i++) {              /* the stop flag: at once */
        setup_thread(FLAGS[i], 0, 0, 0);
        expect_begin();
        r = m4c0c7d_movie_thread(VA_C + 8, &fx.w, &fx.host);
        CK(r == 0 && L.n == 1);
        ck_call(0, 0x51ec84, 0, 2);
        ck_arg(0, 0, 0);                                                 /* AfxEndThread(0, 1): nExitCode is the last pushed */
        ck_arg(0, 1, 1);
        expect_end();
    }
    /* one pass, then the stop (the stop is set by the Sleep): word 0, state 0 -> 0x44c479 stores 1, returns 1; selector 0 / 1 / other */
    {
        static const struct {
            uint32_t sel, callee;
            int calls;
        } SELS[] = {{0, 0x41546f, 1}, {1, 0x4156ea, 1}, {2, 0, 0}, {0x100, 0, 0}, {0x10000, 0, 0}, {0xffffffffu, 0, 0}};
        for (i = 0; i < sizeof SELS / sizeof SELS[0]; i++) {
            int c = 0;
            setup_thread(0, 0, 0, SELS[i].sel);
            script_poke(0x52a2b0, 0, fx.c + 8, 4, 1);
            expect_begin();
            r = m4c0c7d_movie_thread(VA_C + 8, &fx.w, &fx.host);
            CK(r == 0);
            CK(L.n == 3 + SELS[i].calls);
            if (SELS[i].calls) {
                ck_call(c, SELS[i].callee, 0x5e2dbe, 1);
                ck_arg(c, 0, OBJ_VA);
                c++;
            }
            ck_call(c, 0x44c4ab, 0, 1);
            ck_arg(c, 0, VA_G);
            CK(get32(L.c[c].snap_g, 0) == 1 && get16(L.c[c].snap_g, W1CC) == 0);     /* 0x44c479 stored the state 1; the word is set after */
            c++;
            ck_call(c, 0x52a2b0, 0, 1);
            ck_arg(c, 0, 1);
            c++;
            ck_call(c, 0x51ec84, 0, 2);
            set32(exp_g, 0, 1);
            set16(exp_g, W1CC, 1);
            set32(exp_c, 8, 1);
            expect_end();
        }
    }
    /* state 2: 0x44c479 returns 2 -> no switch, no 0x44c4ab, the word stays 0; only the Sleep */
    setup_thread(0, 0, 2, 0);
    script_poke(0x52a2b0, 0, fx.c + 8, 4, 1);
    expect_begin();
    CK(m4c0c7d_movie_thread(VA_C + 8, &fx.w, &fx.host) == 0);
    CK(L.n == 2);
    ck_call(0, 0x52a2b0, 0, 1);
    ck_call(1, 0x51ec84, 0, 2);
    set32(exp_c, 8, 1);
    expect_end();
    /* a non-zero word (movsx; the upper half is junk): no wait call at all */
    {
        static const uint16_t WORDS[] = {1, 0xffff, 0x8000, 0x0100, 0x00ff};
        for (i = 0; i < sizeof WORDS / sizeof WORDS[0]; i++) {
            setup_thread(0, WORDS[i], 1, 0);                             /* (state 1 would spin if 0x44c479 were called) */
            script_poke(0x52a2b0, 0, fx.c + 8, 4, 1);
            expect_begin();
            CK(m4c0c7d_movie_thread(VA_C + 8, &fx.w, &fx.host) == 0);
            CK(L.n == 2);
            ck_call(0, 0x52a2b0, 0, 1);
            set32(exp_c, 8, 1);
            expect_end();
        }
    }
    /* a word whose low half is zero and whose upper half is not: still zero */
    setup_thread(0, 0, 0, 5);
    set16(fx.g, W1CC + 2, 0x1234);
    script_poke(0x52a2b0, 0, fx.c + 8, 4, 1);
    CK(m4c0c7d_movie_thread(VA_C + 8, &fx.w, &fx.host) == 0);
    CK(L.n == 3 && get16(fx.g, W1CC) == 1 && get16(fx.g, W1CC + 2) == 0x1234);
    /* three passes: the second finds the word set (Sleep only), the third the stop; the state is waited on in the first (state 1 -> ended by the 1st Sleep) */
    setup_thread(0, 0, 1, 0);
    script_poke(0x52a2b0, 0, fx.g, 4, 3);                               /* inside 0x44c479: the state leaves 1 */
    script_poke(0x52a2b0, 2, fx.c + 8, 4, 1);
    r = m4c0c7d_movie_thread(VA_C + 8, &fx.w, &fx.host);
    CK(r == 0);
    CK(L.n == 6);                                                       /* Sleep (wait), 0x41546f, 0x44c4ab, Sleep, Sleep, AfxEndThread */
    ck_call(0, 0x52a2b0, 0, 1);
    ck_call(1, 0x41546f, 0x5e2dbe, 1);
    ck_call(2, 0x44c4ab, 0, 1);
    ck_call(3, 0x52a2b0, 0, 1);
    ck_call(4, 0x52a2b0, 0, 1);
    ck_call(5, 0x51ec84, 0, 2);
    /* native rejection: the flag never comes */
    setup_thread(0, 1, 0, 0);
    fx.w.native_spin_limit = 7;
    CK(m4c0c7d_movie_thread(VA_C + 8, &fx.w, &fx.host) == FL27A_REJECTED);
    CK(L.n == 7);
    setup_thread(0, 0, 1, 0);                                           /* the wait of 0x44c479 never ends */
    fx.w.native_spin_limit = 4;
    CK(m4c0c7d_movie_thread(VA_C + 8, &fx.w, &fx.host) == FL27A_REJECTED);
    CK(L.n == 4);
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
        fx.w.native_spin_limit = 3;
        set32(fx.c, 1, rnd() % 4);
        (void)m44c479_wait_state(STATE_VA, &fx.w, &fx.host);
        (void)m4bee2c_get_field(fx.self, rnd() % 2 ? VA_A + (rnd() % 64) : 0, &fx.host);
        (void)m4bef85_bink_wait(fx.self, rnd() % 2 ? VA_A : 0, &fx.host);
        (void)m4bee5f_bink_summary(fx.self, rnd() % 2 ? VA_A : 0, &fx.host);
        (void)m4befc8_bink_do_frame(fx.self, rnd() % 2 ? VA_A : 0, &fx.host);
        (void)m4bef11_bink_goto(fx.self, rnd() % 2 ? VA_A : 0, rnd() % 3, &fx.host);
        (void)m4bf098_bink_copy_to_buffer(fx.self, rnd() % 2 ? VA_A : 0, rnd(), rnd(), rnd(), rnd(), rnd(), &fx.host);
        (void)m4bf10f_bink_next(fx.self, rnd() % 2 ? VA_A : 0, &fx.host);
        (void)m4bf315_bink_open(fx.self, VA_A + (rnd() % 64), rnd(), &fx.host);
        set32(fx.c, 4, rnd() % 2 ? VA_B + (rnd() % 16) : 0);
        m4c2dfb_free_pair(fx.self, VA_C + 4, &fx.host);
        m4159db_dispatch_piece(fx.self, VA_A + (rnd() % 0x80), (uint16_t)rnd(), &fx.w, &fx.host);
        set32(fx.c, 8, 0);
        set16(fx.g, W1CC, (uint16_t)(rnd() % 3));
        set32(fx.g, 0, rnd() % 4);
        set32(fx.g, SEL172, rnd() % 3);
        script_poke(0x52a2b0, (int)(rnd() % 3), fx.c + 8, 4, 1);
        script_poke(0x52a2b0, 0, fx.g, 4, rnd() % 4);
        fx.w.native_spin_limit = 50;
        (void)m4c0c7d_movie_thread(VA_C + 8, &fx.w, &fx.host);
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
    {"test_m44c479_wait_state", test_m44c479_wait_state},
    {"test_m4bee2c_get_field", test_m4bee2c_get_field},
    {"test_m4bef85_bink_wait", test_m4bef85_bink_wait},
    {"test_m4bee5f_bink_summary", test_m4bee5f_bink_summary},
    {"test_m4befc8_bink_do_frame", test_m4befc8_bink_do_frame},
    {"test_m4bef11_bink_goto", test_m4bef11_bink_goto},
    {"test_m4bf098_bink_copy_to_buffer", test_m4bf098_bink_copy_to_buffer},
    {"test_m4bf10f_bink_next", test_m4bf10f_bink_next},
    {"test_m4bf315_bink_open", test_m4bf315_bink_open},
    {"test_m4c2dfb_free_pair", test_m4c2dfb_free_pair},
    {"test_m4159db_dispatch_piece", test_m4159db_dispatch_piece},
    {"test_m4c0c7d_movie_thread", test_m4c0c7d_movie_thread},
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
