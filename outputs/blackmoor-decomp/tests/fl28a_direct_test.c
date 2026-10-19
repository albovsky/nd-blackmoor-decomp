/* FL-28 (batch a) direct tests of the methods of GAME.EXE in src/original_methods_fl28a.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit
 * status is the failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE,
 * not from running the native code; tests/test_fl28a_differential.py additionally runs the original bytes on generated fixtures.
 *
 * Every function is checked three ways: (1) the guard matrix, each guard failing in turn; (2) each arm with the whole object compared with a
 * hand-edited copy and the ordered host calls with their arguments; (3) the edges of every compare. */
#include "../src/original_methods_fl28a.h"

#include <stdio.h>
#include <stdlib.h>
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

#define SELF_OFF 0x1000u
#define SELF_SZ 0x2000
#define VA_A 0x20010000u
#define VA_B 0x20020000u
#define VA_V 0x20030000u
#define VA_C 0x20040000u
#define VA_D 0x20050000u
#define A_SZ 0x400
#define V_SZ 0x100
#define VT30 0x7e000900u
#define VT50 0x7e000a00u

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
    uint8_t self[SELF_SZ], a[A_SZ], b[A_SZ], v[V_SZ], c[A_SZ], d[A_SZ], low[0x80];
    Fl28aWorld w;
    Fl18Host host;
} fx;

static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[8];
    } c[64];
} L;

static struct {
    uint32_t callee;
    uint32_t value[4];
    int count, used;
} script[8];
static int script_count;

static void script_ret(uint32_t callee, uint32_t v0, uint32_t v1)
{
    script[script_count].callee = callee;
    script[script_count].value[0] = v0;
    script[script_count].value[1] = v1;
    script[script_count].count = 2;
    script[script_count++].used = 0;
}

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int i;
    uint32_t result = 0;
    (void)ctx;
    if (L.n < 64) {
        L.c[L.n].callee = callee;
        L.c[L.n].this_ptr = this_ptr;
        L.c[L.n].nargs = nargs;
        for (i = 0; i < nargs && i < 8; i++) L.c[L.n].a[i] = args[i];
    }
    L.n++;
    for (i = 0; i < script_count; i++)
        if (script[i].callee == callee) {
            result = script[i].value[script[i].used < script[i].count ? script[i].used : script[i].count - 1];
            script[i].used++;
        }
    return result;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (a >= 0x20 && a < sizeof fx.low) return fx.low + a;      /* address 0 itself stays unmapped */
    if (a >= VA_A && a < VA_A + A_SZ) return fx.a + (a - VA_A);
    if (a >= VA_B && a < VA_B + A_SZ) return fx.b + (a - VA_B);
    if (a >= VA_V && a < VA_V + V_SZ) return fx.v + (a - VA_V);
    if (a >= VA_C && a < VA_C + A_SZ) return fx.c + (a - VA_C);
    if (a >= VA_D && a < VA_D + A_SZ) return fx.d + (a - VA_D);
    return NULL;
}

static void reset(unsigned seed)
{
    size_t i;
    srand(seed);
    for (i = 0; i < sizeof fx.self; i++) fx.self[i] = (uint8_t)rand();
    for (i = 0; i < sizeof fx.a; i++) fx.a[i] = (uint8_t)rand();
    for (i = 0; i < sizeof fx.b; i++) fx.b[i] = (uint8_t)rand();
    for (i = 0; i < sizeof fx.v; i++) fx.v[i] = (uint8_t)rand();
    for (i = 0; i < sizeof fx.c; i++) fx.c[i] = (uint8_t)rand();
    for (i = 0; i < sizeof fx.low; i++) fx.low[i] = (uint8_t)rand();
    for (i = 0; i < sizeof fx.d; i++) fx.d[i] = (uint8_t)rand();
    memset(&fx.w, 0, sizeof fx.w);
    memset(&fx.host, 0, sizeof fx.host);
    fx.host.call = host_call;
    fx.host.resolve = host_resolve;
    memset(&L, 0, sizeof L);
    memset(script, 0, sizeof script);
    script_count = 0;
}

#define SELF (fx.self + SELF_OFF)

/* the call i of the log: callee, ecx and the arguments */
static int call_is(int i, uint32_t callee, uintptr_t this_ptr, int nargs, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3)
{
    if (i >= L.n || i >= 64) return 0;
    if (L.c[i].callee != callee || L.c[i].this_ptr != this_ptr || L.c[i].nargs != nargs) return 0;
    if (nargs > 0 && L.c[i].a[0] != a0) return 0;
    if (nargs > 1 && L.c[i].a[1] != a1) return 0;
    if (nargs > 2 && L.c[i].a[2] != a2) return 0;
    if (nargs > 3 && L.c[i].a[3] != a3) return 0;
    return 1;
}

static void test_m4235fd_pop(void)
{
    uint8_t before[SELF_SZ];
    uint8_t *r;
    reset(1);
    set32(SELF, 4, 0);
    memcpy(before, fx.self, sizeof before);
    CK(m4235fd_pop(SELF) == NULL);
    CK(memcmp(before, fx.self, sizeof before) == 0);
    set32(SELF, 4, 1);
    r = m4235fd_pop(SELF);
    CK(r == SELF + 8);
    CK(get32(SELF, 4) == 0);
    set32(SELF, 4, 3);
    r = m4235fd_pop(SELF);
    CK(r == SELF + 8 + 24);
    CK(get32(SELF, 4) == 2);
    set32(SELF, 4, 0x80);
    r = m4235fd_pop(SELF);
    CK(r == SELF + 8 + 0x7f * 12);
    CK(get32(SELF, 4) == 0x7f);
    /* the address wraps in 32 bits: count 0x80000000 -> 0x7fffffff, 0x7fffffff * 12 = 0xfffffff4 (mod 2^32), + 8 = 0xfffffffc */
    set32(SELF, 4, 0x80000000u);
    r = m4235fd_pop(SELF);
    CK((uintptr_t)r == (uintptr_t)SELF + 0xfffffffcu);
    CK(get32(SELF, 4) == 0x7fffffffu);
    /* a count of 0x100000000 / 12 + 1 style wrap: 0xffffffff -> 0xfffffffe, * 12 = 0xffffffe8 (mod 2^32), + 8 = 0xfffffff0 */
    set32(SELF, 4, 0xffffffffu);
    r = m4235fd_pop(SELF);
    CK((uintptr_t)r == (uintptr_t)SELF + 0xfffffff0u);
    CK(get32(SELF, 4) == 0xfffffffeu);
    /* the bytes around the count are untouched */
    reset(2);
    memcpy(before, fx.self, sizeof before);
    set32(SELF, 4, 2);
    memcpy(before + SELF_OFF, SELF, 8);
    set32(before + SELF_OFF, 4, 1);
    (void)m4235fd_pop(SELF);
    CK(memcmp(before, fx.self, sizeof before) == 0);
}

static void test_m4fc808_clear_slot(void)
{
    uint8_t exp[SELF_SZ];
    reset(3);
    memcpy(exp, fx.self, sizeof exp);
    fx.w.word_63a4cd = 0;
    m4fc808_clear_slot(SELF, 3, &fx.w, &fx.host);
    set16(exp, SELF_OFF + 3 * 0x5bb + 0x132, 0);
    CK(memcmp(exp, fx.self, sizeof exp) == 0);
    CK(L.n == 1 && call_is(0, 0x4f356e, 0x5cf1eb, 1, 3, 0, 0, 0));
    reset(4);
    memcpy(exp, fx.self, sizeof exp);
    fx.w.word_63a4cd = (int16_t)0x8000;      /* any non-zero word */
    m4fc808_clear_slot(SELF, 0xabcd0002u, &fx.w, &fx.host);
    set16(exp, SELF_OFF + 2 * 0x5bb + 0x132, 0);
    CK(memcmp(exp, fx.self, sizeof exp) == 0);
    CK(L.n == 3);
    CK(call_is(0, 0x50ca3e, 0, 3, 0x63888b, 0x56090c, 2, 0));
    CK(call_is(1, 0x44a2b7, 0, 1, 0x63888b, 0, 0, 0));
    CK(call_is(2, 0x4f356e, 0x5cf1eb, 1, 2, 0, 0, 0));
}

static void check_block(uint32_t size, uint32_t message, int is_4237f7)
{
    uint8_t exp[A_SZ];
    uint32_t r;
    reset(5);
    memcpy(exp, fx.a, sizeof exp);
    script_ret(0x51dc43, VA_A + 4, VA_A + 4);
    r = is_4237f7 ? m4237f7_new_block(&fx.w, &fx.host) : m4236d6_new_block(&fx.w, &fx.host);
    memset(exp + 4, 0, size);
    CK(r == VA_A + 4);
    CK(memcmp(exp, fx.a, sizeof exp) == 0);
    CK(L.n == 1 && call_is(0, 0x51dc43, 0, 1, size, 0, 0, 0));
    /* allocation failed, debug word zero: report, 0x52139c, 0x4c97b4 */
    reset(6);
    memcpy(exp, fx.a, sizeof exp);
    script_ret(0x51dc43, 0, 0);
    r = is_4237f7 ? m4237f7_new_block(&fx.w, &fx.host) : m4236d6_new_block(&fx.w, &fx.host);
    CK(r == 0);
    CK(memcmp(exp, fx.a, sizeof exp) == 0);
    CK(L.n == 4);
    CK(call_is(0, 0x51dc43, 0, 1, size, 0, 0, 0));
    CK(call_is(1, 0x50ca3e, 0, 2, 0x63888b, message, 0, 0));
    CK(call_is(2, 0x52139c, 0, 3, 0x63888b, 0, 0, 0));
    CK(call_is(3, 0x4c97b4, 0x5cf659, 0, 0, 0, 0, 0));
    /* debug word non-zero: 0x44a2b7 between 0x52139c and 0x4c97b4 */
    reset(7);
    script_ret(0x51dc43, 0, 0);
    fx.w.word_63a4cd = 0x100;
    r = is_4237f7 ? m4237f7_new_block(&fx.w, &fx.host) : m4236d6_new_block(&fx.w, &fx.host);
    CK(r == 0);
    CK(L.n == 5);
    CK(call_is(2, 0x52139c, 0, 3, 0x63888b, 0, 0, 0));
    CK(call_is(3, 0x44a2b7, 0, 1, 0x63888b, 0, 0, 0));
    CK(call_is(4, 0x4c97b4, 0x5cf659, 0, 0, 0, 0, 0));
}

static void test_m4237f7_new_block(void) { check_block(0x4c, 0x5446e0, 1); }
static void test_m4236d6_new_block(void) { check_block(0x1c, 0x5445f8, 0); }

static void test_m4f80d3_play_retry(void)
{
    uint8_t exp[SELF_SZ];
    uint32_t r;
    reset(8);
    set32(fx.a, 0, VA_V);
    set32(fx.v, 0x30, VT30);
    set32(fx.v, 0x50, VT50);
    memcpy(exp, fx.self, sizeof exp);
    script_ret(VT30, 0, 0);
    r = m4f80d3_play_retry(SELF, VA_A, 0x1234, &fx.host);
    set32(exp, SELF_OFF + 0x3ca, 0);
    CK(r == 1);
    CK(memcmp(exp, fx.self, sizeof exp) == 0);
    CK(L.n == 1 && call_is(0, VT30, 0, 4, VA_A, 0, 0, 0x1234));
    /* the device-lost answer: restore (entry 0x50) and the call again; the second answer is stored */
    reset(9);
    set32(fx.a, 0, VA_V);
    set32(fx.v, 0x30, VT30);
    set32(fx.v, 0x50, VT50);
    memcpy(exp, fx.self, sizeof exp);
    script_ret(VT30, 0x88780096u, 5);
    r = m4f80d3_play_retry(SELF, VA_A, 0xffffffffu, &fx.host);
    set32(exp, SELF_OFF + 0x3ca, 5);
    CK(r == 0);
    CK(memcmp(exp, fx.self, sizeof exp) == 0);
    CK(L.n == 3);
    CK(call_is(0, VT30, 0, 4, VA_A, 0, 0, 0xffffffffu));
    CK(call_is(1, VT50, 0, 1, VA_A, 0, 0, 0));
    CK(call_is(2, VT30, 0, 4, VA_A, 0, 0, 0xffffffffu));
    /* the lost answer twice: stored, result 0 */
    reset(10);
    set32(fx.a, 0, VA_V);
    set32(fx.v, 0x30, VT30);
    set32(fx.v, 0x50, VT50);
    script_ret(VT30, 0x88780096u, 0x88780096u);
    r = m4f80d3_play_retry(SELF, VA_A, 1, &fx.host);
    CK(r == 0 && get32(SELF, 0x3ca) == 0x88780096u && L.n == 3);
    /* near misses of the compare, and a non-zero answer: no retry */
    reset(11);
    set32(fx.a, 0, VA_V);
    set32(fx.v, 0x30, VT30);
    script_ret(VT30, 0x88780097u, 0);
    r = m4f80d3_play_retry(SELF, VA_A, 1, &fx.host);
    CK(r == 0 && get32(SELF, 0x3ca) == 0x88780097u && L.n == 1);
    reset(12);
    set32(fx.a, 0, VA_V);
    set32(fx.v, 0x30, VT30);
    script_ret(VT30, 0x88780095u, 0);
    r = m4f80d3_play_retry(SELF, VA_A, 1, &fx.host);
    CK(r == 0 && L.n == 1);
}

static void test_m42356d_push(void)
{
    uint8_t exp[SELF_SZ];
    reset(13);
    set32(SELF, 4, 2);
    memcpy(exp, fx.self, sizeof exp);
    m42356d_push(SELF, 0x11111111u, 0x22222222u, &fx.w, &fx.host);
    set32(exp, SELF_OFF + 2 * 12 + 8, 0x11111111u);
    set32(exp, SELF_OFF + 2 * 12 + 0x10, 0x22222222u);
    set32(exp, SELF_OFF + 4, 3);
    CK(memcmp(exp, fx.self, sizeof exp) == 0);
    CK(L.n == 0);
    /* the last legal count */
    reset(14);
    set32(SELF, 4, 0x7f);
    memcpy(exp, fx.self, sizeof exp);
    m42356d_push(SELF, 1, 2, &fx.w, &fx.host);
    set32(exp, SELF_OFF + 0x7f * 12 + 8, 1);
    set32(exp, SELF_OFF + 0x7f * 12 + 0x10, 2);
    set32(exp, SELF_OFF + 4, 0x80);
    CK(memcmp(exp, fx.self, sizeof exp) == 0 && L.n == 0);
    /* a negative count (the compare is signed): -2 stores at self - 16 and self - 8 */
    reset(15);
    set32(SELF, 4, 0xfffffffeu);
    memcpy(exp, fx.self, sizeof exp);
    m42356d_push(SELF, 0xaaaaaaaau, 0xbbbbbbbbu, &fx.w, &fx.host);
    set32(exp, SELF_OFF - 24 + 8, 0xaaaaaaaau);
    set32(exp, SELF_OFF - 24 + 0x10, 0xbbbbbbbbu);
    set32(exp, SELF_OFF + 4, 0xffffffffu);
    CK(memcmp(exp, fx.self, sizeof exp) == 0 && L.n == 0);
    /* count -1: the second store lands on the count itself (self - 12 + 0x10 = self + 4); the increment reads it back */
    reset(16);
    set32(SELF, 4, 0xffffffffu);
    memcpy(exp, fx.self, sizeof exp);
    m42356d_push(SELF, 0x0a0a0a0au, 0x00000041u, &fx.w, &fx.host);
    set32(exp, SELF_OFF - 4, 0x0a0a0a0au);
    set32(exp, SELF_OFF + 4, 0x42u);
    CK(memcmp(exp, fx.self, sizeof exp) == 0 && L.n == 0);
    /* a full table: the report and the fatal tail, nothing stored */
    reset(17);
    set32(SELF, 4, 0x80);
    memcpy(exp, fx.self, sizeof exp);
    m42356d_push(SELF, 1, 2, &fx.w, &fx.host);
    CK(memcmp(exp, fx.self, sizeof exp) == 0);
    CK(L.n == 3);
    CK(call_is(0, 0x50ca3e, 0, 2, 0x63888b, 0x544514, 0, 0));
    CK(call_is(1, 0x52139c, 0, 3, 0x63888b, 0, 0, 0));
    CK(call_is(2, 0x4c97b4, 0x5cf659, 0, 0, 0, 0, 0));
    reset(18);
    set32(SELF, 4, 0x7fffffffu);
    fx.w.word_63a4cd = 1;
    m42356d_push(SELF, 1, 2, &fx.w, &fx.host);
    CK(L.n == 4 && call_is(2, 0x44a2b7, 0, 1, 0x63888b, 0, 0, 0) && call_is(3, 0x4c97b4, 0x5cf659, 0, 0, 0, 0, 0));
    CK(get32(SELF, 4) == 0x7fffffffu);
}

static void test_m4fb2e3_start_slot(void)
{
    uint8_t exp[SELF_SZ];
    reset(19);
    memcpy(exp, fx.self, sizeof exp);
    script_ret(0x4f6059, 7, 7);
    m4fb2e3_start_slot(SELF, 1, &fx.w, &fx.host);
    set16(exp, SELF_OFF + 0x5bb + 0x132, 1);
    CK(memcmp(exp, fx.self, sizeof exp) == 0);
    CK(L.n == 1 && call_is(0, 0x4f6059, 0x5cf1eb, 1, 1, 0, 0, 0));
    /* result zero, debug word zero: no trace */
    reset(20);
    script_ret(0x4f6059, 0, 0);
    m4fb2e3_start_slot(SELF, 0xffff0003u, &fx.w, &fx.host);
    CK(get16(SELF, 3 * 0x5bb + 0x132) == 1 && L.n == 1 && call_is(0, 0x4f6059, 0x5cf1eb, 1, 3, 0, 0, 0));
    /* debug word set, result non-zero: the first trace only */
    reset(21);
    fx.w.word_63a4cd = 4;
    script_ret(0x4f6059, 1, 1);
    m4fb2e3_start_slot(SELF, 2, &fx.w, &fx.host);
    CK(L.n == 3);
    CK(call_is(0, 0x50ca3e, 0, 3, 0x63888b, 0x560794, 2, 0));
    CK(call_is(1, 0x44a2b7, 0, 1, 0x63888b, 0, 0, 0));
    CK(call_is(2, 0x4f6059, 0x5cf1eb, 1, 2, 0, 0, 0));
    /* debug word set, result zero: both traces, the second with the value of 0x4fa2a8 */
    reset(22);
    fx.w.word_63a4cd = 4;
    script_ret(0x4f6059, 0, 0);
    script_ret(0x4fa2a8, 0xdeadbeefu, 0xdeadbeefu);
    m4fb2e3_start_slot(SELF, 0, &fx.w, &fx.host);
    CK(L.n == 6);
    CK(call_is(2, 0x4f6059, 0x5cf1eb, 1, 0, 0, 0, 0));
    CK(call_is(3, 0x4fa2a8, 0x5cf1eb, 0, 0, 0, 0, 0));
    CK(call_is(4, 0x50ca3e, 0, 4, 0x63888b, 0x5607c4, 0, 0xdeadbeefu));
    CK(call_is(5, 0x44a2b7, 0, 1, 0x63888b, 0, 0, 0));
    CK(get16(SELF, 0x132) == 1);
}

static void run_hash(const char *name, uint32_t atoi1, uint32_t atoi2, uint32_t digit_at, int32_t *out)
{
    size_t n = strlen(name);
    reset(23);
    memcpy(fx.a, name, n + 1);
    script_ret(0x50cb1b, atoi1, atoi2);
    (void)digit_at;
    *out = m423368_hash_name(VA_A, &fx.host);
}

static void test_m423368_hash_name(void)
{
    int32_t r;
    /* first conversion non-zero after the remainder: returned as a signed 16-bit value, nothing else called */
    run_hash("abcdef", 5, 0, 0, &r);
    CK(r == 5 && L.n == 1 && call_is(0, 0x50cb1b, 0, 1, VA_A + 3, 0, 0, 0));
    run_hash("abcdef", 0x3ff, 0, 0, &r);
    CK(r == 0x3ff);
    run_hash("abcdef", 0x12345678u, 0, 0, &r);        /* & 0x800003ff = 0x278 */
    CK(r == 0x278);
    run_hash("abcdef", 0xffffffffu, 0, 0, &r);        /* & 0x800003ff = 0x800003ff, negative: ((v - 1) | 0xfffffc00) + 1 = 0xffffffff */
    CK(r == -1);
    run_hash("abcdef", 0x80000001u, 0, 0, &r);        /* -> 0xfffffc01, word 0xfc01 */
    CK(r == -1023);
    run_hash("abcdef", 0x80000000u, 0, 0, &r);        /* -> 0: the loop runs, no digit: the first byte */
    CK(r == 'a' && L.n > 1);
    /* zero first conversion, the digit test per character: the 3rd character answers (index 2) */
    reset(24);
    memcpy(fx.a, "ab7de", 6);
    script_ret(0x50cb1b, 0x400, 0x2c7);
    script_ret(0x50d6cf, 0, 0);
    r = m423368_hash_name(VA_A, &fx.host);
    CK(r == 'a' && L.n == 1 + 5);                   /* the digit stub answers 0 for all: after the loop the first byte */
    reset(25);
    memcpy(fx.a, "ab7de", 6);
    script_ret(0x50cb1b, 0, 0x4c7);                   /* the second conversion: 0x4c7 & 0x3ff = 0xc7 */
    script_ret(0x50d6cf, 0, 1);
    r = m423368_hash_name(VA_A, &fx.host);
    CK(r == 0xc7);
    CK(L.n == 1 + 2 + 1);
    CK(call_is(1, 0x50d6cf, 0, 1, 'a', 0, 0, 0));
    CK(call_is(2, 0x50d6cf, 0, 1, 'b', 0, 0, 0));
    CK(call_is(3, 0x50cb1b, 0, 1, VA_A + 1, 0, 0, 0));
    /* a negative first byte is passed sign-extended; an empty name returns 0 */
    reset(26);
    fx.a[0] = 0x80;
    fx.a[1] = 0;
    script_ret(0x50cb1b, 0, 0);
    script_ret(0x50d6cf, 0, 0);
    r = m423368_hash_name(VA_A, &fx.host);
    CK(r == -128 && L.n == 2 && call_is(1, 0x50d6cf, 0, 1, 0xffffff80u, 0, 0, 0));
    reset(27);
    fx.a[0] = 0;
    script_ret(0x50cb1b, 0, 0);
    r = m423368_hash_name(VA_A, &fx.host);
    CK(r == 0 && L.n == 1);
}

#define REL 0x7e000b00u

/* a record at VA_B with the nine fields of 0x4f356e set to `on` (bit i = field i of the list) and three objects in fx.a (vtable fx.v, entry +8 = REL) */
static const uint32_t F356E[9] = {0x162, 0x29b, 0x28f, 0x28b, 0x293, 0x297, 0x166, 0x2f1, 0x156};

/* layout 0: the three objects at the start of three 64 KiB regions (the low 16 bits of the addresses are zero); layout 1: at +0x41 (low byte non-zero, so that
 * a narrower read or a read at the neighbouring offset of the fields sees a difference) */
static void setup_4f356e(uint32_t on, uint32_t idx, uint32_t unload_count, uint32_t layout)
{
    int i;
    reset(30 + on);
    set32(SELF, 0x3ce, VA_B + 0x100 - idx * 0x5bbu);
    set32(SELF, 0x3d6, unload_count);
    set32(fx.a, layout ? 0x41 : 0, VA_V);
    set32(fx.c, layout ? 0x41 : 0, VA_V);
    set32(fx.low, 0x24, VA_V);
    set32(fx.d, layout ? 0x41 : 0, VA_V);
    set32(fx.v, 8, REL);
    for (i = 0; i < 9; i++) {
        uint32_t f = F356E[i], v = (on >> i & 1) ? 0x77000000u + f : 0;
        if (on >> i & 1) {
            if (f == 0x293) v = VA_A + (layout ? 0x41u : 0u);
            if (f == 0x29b) v = VA_D + (layout ? 0x41u : 0u);
            if (f == 0x28f) v = layout == 2 ? 0x24u : VA_C + (layout ? 0x41u : 0u);
        }
        set32(fx.b, 0x100 + f, v);
    }
    script_ret(0x4f709c, 1, 1);
    script_ret(0x4f6334, 1, 1);
}

static void test_m4f356e_unload(void)
{
    uint8_t exp[SELF_SZ], expb[A_SZ];
    uint32_t r;
    /* everything set: the counter drops, the callees run in the order of the original, the fields are cleared */
    setup_4f356e(0x1ff, 1, 5, 0);
    memcpy(exp, fx.self, sizeof exp);
    memcpy(expb, fx.b, sizeof expb);
    r = m4f356e_unload(SELF, 1, &fx.host);
    CK(r == 1);
    set32(exp, SELF_OFF + 0x3c2, 0x3e8);
    set32(exp, SELF_OFF + 0x3d6, 4);
    CK(memcmp(exp, fx.self, sizeof exp) == 0);
    /* the record after: [0x28b], [0x293], [0x297], [0x29b], [0x28f], [0x2f1], [0x156], [0x162] and [0x152] cleared */
    {
        static const uint32_t cleared[] = {0x28b, 0x293, 0x297, 0x29b, 0x28f, 0x2f1, 0x156, 0x162, 0x152};
        unsigned k;
        for (k = 0; k < sizeof cleared / sizeof cleared[0]; k++) set32(expb, 0x100 + cleared[k], 0);
        CK(memcmp(expb, fx.b, sizeof expb) == 0);
    }
    CK(L.n == 9);
    CK(call_is(0, 0x4f709c, (uintptr_t)SELF, 0, 0, 0, 0, 0));
    CK(call_is(1, 0x4f6334, (uintptr_t)SELF, 1, 1, 0, 0, 0));
    CK(call_is(2, 0x4f61e7, (uintptr_t)SELF, 1, 1, 0, 0, 0));
    CK(call_is(3, REL, 0, 1, VA_A, 0, 0, 0));
    CK(call_is(4, 0x51dc6c, 0, 1, 0x77000297u, 0, 0, 0));
    CK(call_is(5, REL, 0, 1, VA_D, 0, 0, 0));
    CK(call_is(6, REL, 0, 1, VA_C, 0, 0, 0));
    CK(call_is(7, 0x4fcef0, 0, 1, VA_B + 0x100 + 0x2f1, 0, 0, 0));
    CK(call_is(8, 0x50cee4, 0, 1, 0x77000156u, 0, 0, 0));
    /* the other layout: the objects at +0x41, the same calls with those addresses, the same clears */
    setup_4f356e(0x1ff, 1, 5, 1);
    (void)m4f356e_unload(SELF, 1, &fx.host);
    CK(L.n == 9 && call_is(3, REL, 0, 1, VA_A + 0x41, 0, 0, 0) && call_is(5, REL, 0, 1, VA_D + 0x41, 0, 0, 0) && call_is(6, REL, 0, 1, VA_C + 0x41, 0, 0, 0));
    CK(get32(fx.b, 0x100 + 0x293) == 0 && get32(fx.b, 0x100 + 0x29b) == 0 && get32(fx.b, 0x100 + 0x28f) == 0);
    /* layout 2: the [rec + 0x28f] object at the address 0x24 (a dword read at the neighbouring offset 0x290 would see zero) */
    setup_4f356e(0x1ff, 0, 5, 2);
    (void)m4f356e_unload(SELF, 0, &fx.host);
    CK(L.n == 9 && call_is(6, REL, 0, 1, 0x24, 0, 0, 0) && get32(fx.b, 0x100 + 0x28f) == 0);
    /* 0x4f709c answers zero: only the stamp [self + 0x3c2] is stored */
    setup_4f356e(0x1ff, 0, 5, 0);
    script_ret(0x4f709c, 0, 0);
    memcpy(exp, fx.self, sizeof exp);
    memcpy(expb, fx.b, sizeof expb);
    r = m4f356e_unload(SELF, 0, &fx.host);
    set32(exp, SELF_OFF + 0x3c2, 0x3e8);
    CK(r == 1 && memcmp(exp, fx.self, sizeof exp) == 0 && memcmp(expb, fx.b, sizeof expb) == 0 && L.n == 1);
    /* the counter is unsigned: 0 leaves it and [0x28b] alone; 0x80000000 counts down */
    setup_4f356e(0x1ff, 0, 0, 0);
    (void)m4f356e_unload(SELF, 0, &fx.host);
    CK(get32(SELF, 0x3d6) == 0);
    setup_4f356e(0x1ff, 0, 0x80000000u, 0);
    (void)m4f356e_unload(SELF, 0, &fx.host);
    CK(get32(SELF, 0x3d6) == 0x7fffffffu);
    /* each of the four guards of the counter in turn: nothing counted down, the record fields still cleared by the later steps */
    {
        static const unsigned off_bits[4] = {0, 1, 2, 3};
        unsigned k, layout;
        for (layout = 0; layout < 2; layout++)
            for (k = 0; k < 4; k++) {
                setup_4f356e(0x1ff & ~(1u << off_bits[k]), 0, 5, layout);
                (void)m4f356e_unload(SELF, 0, &fx.host);
                CK(get32(SELF, 0x3d6) == 5);
            }
    }
    /* 0x4f6334 answers zero: 0x4f61e7 is not called */
    setup_4f356e(0x1ff, 0, 5, 0);
    script_ret(0x4f6334, 0, 0);
    (void)m4f356e_unload(SELF, 0, &fx.host);
    CK(L.n == 8 && L.c[2].callee == REL);
    /* [0x28f] zero: no 0x4f6334, no last Release; the neighbouring flag [0x28b] has a high bit only (a dword test) */
    setup_4f356e(0x1ff & ~(1u << 2), 0, 5, 0);
    (void)m4f356e_unload(SELF, 0, &fx.host);
    CK(L.n == 6 && L.c[1].callee == REL);
    setup_4f356e(0x1ff, 0, 5, 0);
    set32(fx.b, 0x100 + 0x28b, 0x80000000u);
    (void)m4f356e_unload(SELF, 0, &fx.host);
    CK(get32(SELF, 0x3d6) == 4 && get32(fx.b, 0x100 + 0x28b) == 0);
    /* nothing set: no call besides 0x4f709c; [0x152] is cleared (the other nine fields are already zero) */
    setup_4f356e(0, 2, 5, 0);
    memcpy(expb, fx.b, sizeof expb);
    (void)m4f356e_unload(SELF, 2, &fx.host);
    set32(expb, 0x100 + 0x152, 0);
    CK(L.n == 1 && memcmp(expb, fx.b, sizeof expb) == 0);
}

static uint8_t big[0xb800];

static void setf(uint8_t *o, size_t off, float f)
{
    memcpy(o + off, &f, 4);
}

static void setup_4fadc4(uint32_t dbg)
{
    size_t i;
    reset(40 + dbg);
    for (i = 0; i < sizeof big; i++) big[i] = (uint8_t)rand();
    for (i = 0; i < 4; i++) set16(big, i * 0x5bb + 0x10c, (uint16_t)(rand() % 8));      /* the table index: caller-validated, small here */
    fx.w.word_63a4cd = (int16_t)dbg;
    memcpy(fx.a, "hi\0", 3);
    script_ret(0x4f379c, 1, 1);
}

static void test_m4fadc4_set_name(void)
{
    uint32_t r;
    size_t rec = 0x5bb;
    uint8_t exp[sizeof big];
    /* slot 1, record fields 2.0 and 0.0, table entry [index 2] = 2.0: 4 * 2857.142822265625 - 2857.142857142857 = 8571.43 -> 8571; 0 - 2857.14 -> -2857 */
    setup_4fadc4(0);
    set16(big, rec + 0x10c, 2);
    setf(big, rec + 0x138, 2.0f);
    setf(big, rec + 0x13c, 0.0f);
    setf(big, 0xb764 + 8, 2.0f);
    memcpy(exp, big, sizeof exp);
    r = m4fadc4_set_name(big, VA_A, 0xabcd0001u, &fx.w, &fx.host);
    memcpy(exp + rec + 8, "hi", 3);
    set32(exp, rec + 0x140, 8571);
    set32(exp, rec + 0x144, 0xfffff4d7u);
    set16(exp, rec + 0x132, 1);
    CK(r == 1);
    CK(memcmp(exp, big, sizeof exp) == 0);
    CK(L.n == 1 && call_is(0, 0x4f379c, 0x5cf1eb, 1, 0xffff0001u, 0, 0, 0));
    /* the table index is a signed word: 0xfffe = -2 reads 0xb764 - 8 */
    setup_4fadc4(0);
    set16(big, rec + 0x10c, 0xfffe);
    setf(big, rec + 0x138, 2.0f);
    setf(big, rec + 0x13c, 2.0f);
    setf(big, 0xb764 - 8, 2.0f);
    r = m4fadc4_set_name(big, VA_A, 1, &fx.w, &fx.host);
    CK(r == 1 && get32(big, rec + 0x140) == 8571 && get32(big, rec + 0x144) == 8571);
    CK(L.n == 1 && call_is(0, 0x4f379c, 0x5cf1eb, 1, 1, 0, 0, 0));
    /* NaN gives the integer indefinite, whose low dword is 0; a huge value as well */
    setup_4fadc4(0);
    set16(big, rec + 0x10c, 0);
    big[rec + 0x138] = 0; big[rec + 0x139] = 0; big[rec + 0x13a] = 0xc0; big[rec + 0x13b] = 0x7f;      /* a NaN */
    setf(big, rec + 0x13c, 3.4e38f);
    setf(big, 0xb764, 3.4e38f);
    (void)m4fadc4_set_name(big, VA_A, 1, &fx.w, &fx.host);
    CK(get32(big, rec + 0x140) == 0);
    CK(get32(big, rec + 0x144) == 0);
    /* the pair is not converted: r zero (no debug word): 0x4f379c, 0x4fa2a8, the report with five arguments, 0x52139c; the word [rec + 0x132] is not stored */
    setup_4fadc4(0);
    script_ret(0x4f379c, 0, 0);
    script_ret(0x4fa2a8, 0xcafef00du, 0);
    memcpy(exp, big, sizeof exp);
    r = m4fadc4_set_name(big, VA_A, 2, &fx.w, &fx.host);
    CK(r == 0);
    CK(memcmp(exp + 2 * rec + 0x132, big + 2 * rec + 0x132, 2) == 0);
    CK(L.n == 4);
    CK(call_is(1, 0x4fa2a8, 0x5cf1eb, 0, 0, 0, 0, 0));
    CK(L.c[2].callee == 0x50ca3e && L.c[2].nargs == 5 && L.c[2].a[0] == 0x63888b && L.c[2].a[1] == 0x560610 && L.c[2].a[2] == 2 && L.c[2].a[3] == VA_A && L.c[2].a[4] == 0xcafef00du);
    CK(call_is(3, 0x52139c, 0, 3, 0x63888b, 0, 0, 0));
    /* with the debug word: the first trace, and 0x44a2b7 at the end */
    setup_4fadc4(0x100);
    script_ret(0x4f379c, 0, 0);
    r = m4fadc4_set_name(big, VA_A, 3, &fx.w, &fx.host);
    CK(r == 0 && L.n == 7);
    CK(call_is(0, 0x50ca3e, 0, 4, 0x63888b, 0x5605e0, 3, VA_A));
    CK(call_is(1, 0x44a2b7, 0, 1, 0x63888b, 0, 0, 0));
    CK(L.c[2].callee == 0x4f379c && L.c[3].callee == 0x4fa2a8 && L.c[4].callee == 0x50ca3e && L.c[5].callee == 0x52139c);
    CK(call_is(6, 0x44a2b7, 0, 1, 0x63888b, 0, 0, 0));
    /* the debug word with the success path: only the first trace */
    setup_4fadc4(1);
    r = m4fadc4_set_name(big, VA_A, 0, &fx.w, &fx.host);
    CK(r == 1 && L.n == 3 && call_is(2, 0x4f379c, 0x5cf1eb, 1, (get32(big, 0x144) & 0xffff0000u), 0, 0, 0));
}

#define NEWNODE (VA_B + 0x100u)
#define NEWBUF (VA_B + 0x200u)

/* name "ab" at VA_V, value "value" at VA_V + 0x40; the hash answers `idx`; allocation answers: node, buffer; the constructor answers `ctor` */
static void setup_423142(uint32_t idx, uint32_t node, uint32_t ctor, const char *name, const char *value)
{
    reset(50 + idx);
    memcpy(fx.v, name, strlen(name) + 1);
    memcpy(fx.v + 0x40, value, strlen(value) + 1);
    script_ret(0x423368, idx, idx);
    script_ret(0x51dc43, node, NEWBUF);
    script_ret(0x423000, ctor, ctor);
    fx.w.word_63a4cd = 0;
}

static void test_m423142_insert(void)
{
    uint32_t r;
    uint8_t expb[A_SZ], expa[A_SZ];
    /* an empty chain: the cell at self + 4 * idx receives the node */
    setup_423142(2, NEWNODE, NEWNODE, "ab", "value");
    set32(SELF, 8, 0);
    memcpy(expb, fx.b, sizeof expb);
    r = m423142_insert(SELF, VA_V, VA_V + 0x40, &fx.host);
    CK(r == 6);
    CK(get32(SELF, 8) == NEWNODE);
    set32(expb, 0x100, NEWBUF);
    memcpy(expb + 0x104, "ab", 3);
    memcpy(expb + 0x200, "value", 6);
    CK(memcmp(expb, fx.b, sizeof expb) == 0);
    CK(L.n == 4);
    CK(call_is(0, 0x423368, (uintptr_t)SELF, 1, VA_V, 0, 0, 0));
    CK(call_is(1, 0x51dc43, 0, 1, 0x29, 0, 0, 0));
    CK(call_is(2, 0x423000, NEWNODE, 0, 0, 0, 0, 0));
    CK(call_is(3, 0x51dc43, 0, 1, 7, 0, 0, 0));       /* strlen("value") + 2 */
    /* a chain of two nodes (A at VA_A, B at VA_A + 0x60): the new node goes into the cell at B + 0x25 */
    setup_423142(0xffffffffu, NEWNODE, NEWNODE, "x", "");
    set32(SELF, (size_t)-4, VA_A);
    set32(fx.a, 0x25, VA_A + 0x60);
    set32(fx.a, 0x60 + 0x25, 0);
    memcpy(expa, fx.a, sizeof expa);
    r = m423142_insert(SELF, VA_V, VA_V + 0x40, &fx.host);
    CK(r == 1 && get32(SELF, (size_t)-4) == VA_A);
    set32(expa, 0x60 + 0x25, NEWNODE);
    CK(memcmp(expa, fx.a, sizeof expa) == 0);
    CK(L.n == 4 && call_is(3, 0x51dc43, 0, 1, 2, 0, 0, 0) && fx.b[0x200] == 0 && get32(fx.b, 0x100) == NEWBUF && fx.b[0x104] == 'x' && fx.b[0x105] == 0);
    /* the constructor answers another address than the node: that address is stored and used */
    setup_423142(1, NEWNODE, NEWNODE + 0x40, "ab", "v");
    set32(SELF, 4, 0);
    r = m423142_insert(SELF, VA_V, VA_V + 0x40, &fx.host);
    CK(r == 2 && get32(SELF, 4) == NEWNODE + 0x40 && get32(fx.b, 0x140) == NEWBUF && fx.b[0x144] == 'a');
    /* the node allocation failed: the constructor is not called, the cell is zero, address 0 (unmapped here) is the original's fault: rejection after the store */
    setup_423142(1, 0, 0, "ab", "v");
    set32(SELF, 4, 0);
    set32(SELF, 4, 0);
    r = m423142_insert(SELF, VA_V, VA_V + 0x40, &fx.host);
    CK(r == 0 && get32(SELF, 4) == 0 && L.n == 3 && L.c[2].callee == 0x51dc43);
    /* the name fits 0x25 bytes with its terminator (0x24 characters) and not more (0x25 characters: rejection, the node and the buffer pointer are stored) */
    {
        char name[0x30];
        memset(name, 'n', sizeof name);
        name[0x24] = 0;
        setup_423142(1, NEWNODE, NEWNODE, name, "v");
        set32(SELF, 4, 0);
        r = m423142_insert(SELF, VA_V, VA_V + 0x40, &fx.host);
        CK(r == 2 && memcmp(fx.b + 0x104, name, 0x25) == 0);
        name[0x24] = 'n';
        name[0x25] = 0;
        setup_423142(1, NEWNODE, NEWNODE, name, "v");
        set32(SELF, 4, 0);
        memset(fx.b + 0x100, 0x5a, 0x40);
        r = m423142_insert(SELF, VA_V, VA_V + 0x40, &fx.host);
        CK(r == 0 && get32(fx.b, 0x100) == NEWBUF && fx.b[0x104] == 0x5a && fx.b[0x128] == 0x5a);
    }
    /* a cycle in the chain: bounded, nothing allocated */
    setup_423142(0, NEWNODE, NEWNODE, "ab", "v");
    set32(SELF, 0, VA_A);
    set32(fx.a, 0x25, VA_A);
    r = m423142_insert(SELF, VA_V, VA_V + 0x40, &fx.host);
    CK(r == 0 && L.n == 1);
    /* an unresolvable value string (before the buffer allocation), name string (after the buffer pointer was stored), buffer address (after the name copy) */
    setup_423142(0, NEWNODE, NEWNODE, "ab", "v");
    set32(SELF, 0, 0);
    r = m423142_insert(SELF, VA_V, 0x11110000u, &fx.host);
    CK(r == 0 && L.n == 3 && get32(SELF, 0) == NEWNODE);
    setup_423142(0, NEWNODE, NEWNODE, "ab", "v");
    set32(SELF, 0, 0);
    r = m423142_insert(SELF, 0x11110000u, VA_V + 0x40, &fx.host);
    CK(r == 0 && L.n == 4 && get32(fx.b, 0x100) == NEWBUF);
    setup_423142(0, NEWNODE, NEWNODE, "ab", "v");
    script_ret(0x51dc43, NEWNODE, 0x22220000u);
    set32(SELF, 0, 0);
    r = m423142_insert(SELF, VA_V, VA_V + 0x40, &fx.host);
    CK(r == 0 && L.n == 4 && get32(fx.b, 0x100) == 0x22220000u && fx.b[0x104] == 'a' && fx.b[0x105] == 'b' && fx.b[0x106] == 0);
    /* an unresolvable chain address */
    setup_423142(0, NEWNODE, NEWNODE, "ab", "v");
    set32(SELF, 0, 0x11110000u);
    r = m423142_insert(SELF, VA_V, VA_V + 0x40, &fx.host);
    CK(r == 0 && L.n == 1);
}

static void test_sweep_bounded(void)
{
    unsigned s;
    for (s = 0; s < 300; s++) {
        uint32_t k = (uint32_t)rand();
        reset(1000 + s);
        fx.w.word_63a4cd = (int16_t)(s % 3 == 0 ? 0 : rand());
        set32(SELF, 4, s % 7 == 0 ? 0u : (uint32_t)(s % 0x90) - 8u);
        (void)m4235fd_pop(SELF);
        m4fc808_clear_slot(SELF, (uint32_t)(s % 4), &fx.w, &fx.host);
        script_ret(0x51dc43, s % 5 == 0 ? 0 : VA_A + (s % 8), 0);
        (void)m4237f7_new_block(&fx.w, &fx.host);
        (void)m4236d6_new_block(&fx.w, &fx.host);
        set32(fx.a, 0, VA_V);
        set32(fx.v, 0x30, VT30);
        set32(fx.v, 0x50, VT50);
        script_ret(VT30, s % 2 ? 0x88780096u : 0, 0);
        (void)m4f80d3_play_retry(SELF, VA_A, k, &fx.host);
        set32(SELF, 4, (uint32_t)((int32_t)(s % 0xc0) - 0x40));
        m42356d_push(SELF, k, k + 1, &fx.w, &fx.host);
        m4fb2e3_start_slot(SELF, s % 4, &fx.w, &fx.host);
        script_ret(0x50cb1b, k, k);
        fx.a[A_SZ - 1] = 0;
        (void)m423368_hash_name(VA_A + (s % 8), &fx.host);
        setup_4f356e(s % 512, s % 3 == 0 ? 0 : 1, s % 4, 0);
        (void)m4f356e_unload(SELF, s % 3 == 0 ? 0 : 1, &fx.host);
        setup_4fadc4(s % 3 ? 0 : 1);
        script_ret(0x4f379c, s % 2, 0);
        (void)m4fadc4_set_name(big, VA_A, s % 4, &fx.w, &fx.host);
        setup_423142(s % 8, s % 5 ? NEWNODE : 0, s % 7 ? NEWNODE : 0, s % 3 ? "ab" : "", s % 4 ? "value" : "");
        set32(SELF, 4 * (s % 8), s % 6 == 0 ? VA_A : 0);
        set32(fx.a, 0x25, s % 9 == 0 ? VA_A : 0);
        (void)m423142_insert(SELF, VA_V, VA_V + 0x40, &fx.host);
    }
}

#define RUN(fn)                                  \
    do {                                         \
        g_failed = 0;                            \
        g_msg[0] = 0;                            \
        fn();                                    \
        if (g_failed) {                          \
            printf("FAIL %s: %s\n", #fn, g_msg); \
            failures++;                          \
        } else {                                 \
            printf("PASS %s\n", #fn);            \
        }                                        \
    } while (0)

int main(void)
{
    int failures = 0;
    RUN(test_m4235fd_pop);
    RUN(test_m4fc808_clear_slot);
    RUN(test_m4237f7_new_block);
    RUN(test_m4236d6_new_block);
    RUN(test_m4f80d3_play_retry);
    RUN(test_m42356d_push);
    RUN(test_m4fb2e3_start_slot);
    RUN(test_m423368_hash_name);
    RUN(test_m4f356e_unload);
    RUN(test_m4fadc4_set_name);
    RUN(test_m423142_insert);
    /*RUNS*/
    RUN(test_sweep_bounded);
    return failures;
}
