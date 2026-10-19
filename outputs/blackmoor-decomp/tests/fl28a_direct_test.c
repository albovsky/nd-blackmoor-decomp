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
    uint8_t self[SELF_SZ], a[A_SZ], b[A_SZ], v[V_SZ];
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
    if (a >= VA_A && a < VA_A + A_SZ) return fx.a + (a - VA_A);
    if (a >= VA_B && a < VA_B + A_SZ) return fx.b + (a - VA_B);
    if (a >= VA_V && a < VA_V + V_SZ) return fx.v + (a - VA_V);
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
    /*RUNS*/
    RUN(test_sweep_bounded);
    return failures;
}
