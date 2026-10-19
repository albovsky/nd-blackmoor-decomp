/* FL-26 (batch c) direct tests of the function 0x424346 of GAME.EXE in src/original_methods_fl26c.c. Prints "PASS <name>" /
 * "FAIL <name>: <msg>"; the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values were derived by
 * hand from the disassembly of GAME.EXE (the jump table at 0x424a3c and the second table at 0x424a98 included), not from running the native
 * code; tests/test_fl26c_differential.py additionally runs the original bytes on generated fixtures. The function is checked three ways: every kind
 * of the jump table with each guard failing in turn and each arm (the result dword, the ordered host calls spelled out), the out-of-range
 * and unused kinds, and the native rejections of the unsafe cases (an unresolved address) which have no counterpart in the original. */
#include "../src/original_methods_fl26c.h"

#include <stdio.h>
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

#define ARENA_VA 0x20000000u
#define ARENA_SZ 0x1000
#define NODE_OFF 0
#define OBJ_OFF 0x100
#define RR_OFF 0x200
#define SELF_SZ 0x700
#define INIT 0x5a5a5a5au

/* the tables of the original at their original addresses (windows around the indices that the tests use) */
#define W1 0x583bb5u    /* table 0x583bd5, dword index -8 .. 8 */
#define W2 0x5857e1u    /* table 0x585801 */
#define W3 0x581a51u    /* table 0x581a71 */
#define W4 0x587b0du    /* table 0x587b2d, word index -16 .. 16 */
#define W5 0x585d65u    /* table 0x585d65, records 0 .. 3 */
#define W5M (0x585d65u - 0x106u)   /* the record -1: only its two dwords (the bytes above it hold other globals) */

/* (the arrays have 16 bytes of slack: an address is resolved by its first byte, a dword read may run a few bytes past the logical end) */
#define T1SZ 0x44
#define T4SZ 0x42
#define T5SZ (4 * 0x106 + 8)
static uint8_t arena[ARENA_SZ + 16];
static uint8_t self_buf[SELF_SZ];
static uint8_t tab5m[8 + 16];
static uint8_t tab1[T1SZ + 16], tab2[T1SZ + 16], tab3[T1SZ + 16], tab4[T4SZ + 16], tab5[T5SZ + 16];
static size_t g_node_off;         /* the node is at arena + g_node_off (0 unless a test moves it) */
static uint32_t g_hole;           /* an original address that does not resolve (0: none) */
static uint8_t low_page[0x100];   /* when g_low_ok, the addresses below 0x100 resolve to this */
static int g_low_ok;
static Fl26cWorld world;
static Fl18Host host;

static void set32(uint8_t *o, size_t off, uint32_t v) { memcpy(o + off, &v, 4); }
static void set16(uint8_t *o, size_t off, uint16_t v) { memcpy(o + off, &v, 2); }
static uint32_t get32(const uint8_t *o, size_t off)
{
    uint32_t v;
    memcpy(&v, o + off, 4);
    return v;
}

static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[4];
    } c[16];
} L;
static uint32_t g_ret_4f6334, g_ret_50cd50;

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int i;
    (void)ctx;
    if (L.n >= 16) return 0;
    L.c[L.n].callee = callee;
    L.c[L.n].this_ptr = this_ptr;
    L.c[L.n].nargs = nargs;
    for (i = 0; i < nargs && i < 4; i++) L.c[L.n].a[i] = args[i];
    L.n++;
    if (callee == 0x4f6334) return g_ret_4f6334;
    if (callee == 0x50cd50) return g_ret_50cd50;
    return 0;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (g_hole != 0 && a == g_hole) return NULL;
    if (g_low_ok && a < 0x100) return low_page + a;
    if (a >= ARENA_VA && a < ARENA_VA + ARENA_SZ) return arena + (a - ARENA_VA);
    if (a >= W1 && a < W1 + T1SZ) return tab1 + (a - W1);
    if (a >= W2 && a < W2 + T1SZ) return tab2 + (a - W2);
    if (a >= W3 && a < W3 + T1SZ) return tab3 + (a - W3);
    if (a >= W4 && a < W4 + T4SZ) return tab4 + (a - W4);
    if (a >= W5 && a < W5 + T5SZ) return tab5 + (a - W5);
    if (a >= W5M && a < W5M + 8) return tab5m + (a - W5M);
    return NULL;
}

static uint32_t host_tick(void *ctx)
{
    (void)ctx;
    return 0;
}

static void setup(void)
{
    memset(arena, 0xA5, sizeof arena);
    memset(self_buf, 0xA5, sizeof self_buf);
    memset(tab1, 0xCC, sizeof tab1);
    memset(tab2, 0xCC, sizeof tab2);
    memset(tab3, 0xCC, sizeof tab3);
    memset(tab4, 0xCC, sizeof tab4);
    memset(tab5, 0xCC, sizeof tab5);
    memset(tab5m, 0xCC, sizeof tab5m);
    memset(&world, 0, sizeof world);
    memset(&host, 0, sizeof host);
    host.call = host_call;
    host.resolve = host_resolve;
    host.tick = host_tick;
    memset(&L, 0, sizeof L);
    memset(low_page, 0, sizeof low_page);
    g_ret_4f6334 = g_ret_50cd50 = 0;
    g_node_off = 0;
    g_hole = 0;
    g_low_ok = 0;
    set32(arena, 4, INIT);
}

/* the node: kind, a, b words, the dwords d, e, f */
static void node(int kind, int a, int b, uint32_t d, uint32_t e, uint32_t f)
{
    set16(arena, g_node_off + 0x10, (uint16_t)kind);
    set16(arena, g_node_off + 0x12, (uint16_t)a);
    set16(arena, g_node_off + 0x14, (uint16_t)b);
    set32(arena, g_node_off + 0x20, d);
    set32(arena, g_node_off + 0x24, e);
    set32(arena, g_node_off + 0x28, f);
}

static int32_t run(void)
{
    int32_t rej = -1;
    m424346_node_condition(self_buf, ARENA_VA + (uint32_t)g_node_off, &world, &host, &rej);
    return rej;
}

static uint32_t result(void) { return get32(arena, g_node_off + 4); }

static int call_is(int i, uint32_t callee, uintptr_t this_ptr, int nargs) { return i < L.n && L.c[i].callee == callee && L.c[i].this_ptr == this_ptr && L.c[i].nargs == nargs; }

/* the diagnostic path of kinds without a case: 0x50ca3e(0x63888b, 0x544a80, kind), 0x42639d(this 0x583979; 0x544a88, 0x63888b), 0x4c97b4(this 0x5cf659) */
static int is_kind_diagnostic(uint32_t kind)
{
    return L.n == 3 && call_is(0, 0x50ca3e, 0, 3) && L.c[0].a[0] == 0x63888b && L.c[0].a[1] == 0x544a80 && L.c[0].a[2] == kind &&
           call_is(1, 0x42639d, 0x583979, 2) && L.c[1].a[0] == 0x544a88 && L.c[1].a[1] == 0x63888b && call_is(2, 0x4c97b4, 0x5cf659, 0) && result() == INIT;
}

/* the diagnostic path of kind 9 / kind 6: 0x50ca3e(0x63888b, format, [0x5bb57b]), 0x52139c(0x63888b, 0, 0), 0x4c97b4 */
static int is_format_diagnostic(uint32_t format, uint32_t value)
{
    return L.n == 3 && call_is(0, 0x50ca3e, 0, 3) && L.c[0].a[0] == 0x63888b && L.c[0].a[1] == format && L.c[0].a[2] == value &&
           call_is(1, 0x52139c, 0, 3) && L.c[1].a[0] == 0x63888b && L.c[1].a[1] == 0 && L.c[1].a[2] == 0 && call_is(2, 0x4c97b4, 0x5cf659, 0) && result() == INIT;
}

/* ---- 0x424346 ------------------------------------------------------------------------------------------------------------- */

static void test_kind_0_and_unused_and_out_of_range(void)
{
    static const int unused[] = {7, 8, 10, 18, 19};
    static const int out[] = {0x17, 0x18, 0x100, 0x7fff, -1, -2, -0x8000};
    size_t i;
    setup();
    node(0, 3, 4, 5, 6, 7);
    CK(run() == 0 && result() == 1 && L.n == 0);
    for (i = 0; i < sizeof unused / sizeof unused[0]; i++) {
        setup();
        node(unused[i], 0, 0, 0, 0, 0);
        CK(run() == 0 && is_kind_diagnostic((uint32_t)unused[i]));
    }
    for (i = 0; i < sizeof out / sizeof out[0]; i++) {
        setup();
        node(out[i], 0, 0, 0, 0, 0);
        CK(run() == 0 && is_kind_diagnostic((uint32_t)(int32_t)out[i]));
    }
}

static void test_kind_1(void)
{
    static const struct {
        int b;
        uint32_t t;
        int word_is_a;
        uint32_t exp;
    } T[] = {{1, 1, 0, 1}, {1, 1, 1, 1}, {1, 0, 1, 1}, {1, 0, 0, 0}, {1, 2, 0, 0}, {1, 0x10000, 0, 0}, {1, 0x100, 0, 0}, {0, 0, 0, 1}, {0, 0, 1, 0},
             {0, 1, 0, 0}, {0, 0x10000, 0, 0}, {0, 0x100, 0, 0}, {2, 0, 0, 0}, {2, 1, 1, 0}, {-1, 0, 0, 0}, {-1, 1, 1, 0}, {0x7fff, 0, 0, 0}};
    size_t i;
    for (i = 0; i < sizeof T / sizeof T[0]; i++) {
        int a = -3;      /* tab1 index a + 8 */
        setup();
        node(1, a, T[i].b, 0, 0, 0);
        set32(tab1, (size_t)(a + 8) * 4, T[i].t);
        world.word_583a29 = (int16_t)(T[i].word_is_a ? a : a + 1);
        CK(run() == 0 && result() == T[i].exp && L.n == 0);
    }
    /* the word 0x583a29 is compared as a signed word with a (sign extended on both sides) */
    setup();
    node(1, -1, 1, 0, 0, 0);
    set32(tab1, 7 * 4, 0);
    world.word_583a29 = (int16_t)0xffff;
    CK(run() == 0 && result() == 1);
    setup();
    node(1, 0x7fff, 1, 0, 0, 0);       /* the table index 0x7fff is out of the window: rejected before the compare */
    world.word_583a29 = 0x7fff;
    CK(run() == FL26C_REJECT_UNRESOLVED && result() == INIT);
}

static void test_kind_0xb(void)
{
    uint32_t va_node = ARENA_VA + NODE_OFF;
    int z, wm, arm;
    for (z = 0; z < 4; z++) {
        for (wm = 0; wm < 2; wm++) {
            for (arm = 0; arm < 3; arm++) {
                static const uint32_t zs[] = {0, 1, 0x10000, 0x100};
                uint32_t r24 = arm == 0 ? va_node : arm == 1 ? 0u : 0x1234u;
                uint32_t exp_p4, exp_rr;
                setup();
                node(0xb, 5, 0, 0, 0, 0);
                set32(arena, 0x48, ARENA_VA + OBJ_OFF);
                set32(arena, OBJ_OFF + 0x14, ARENA_VA + RR_OFF);
                set32(arena, RR_OFF + 0x24, r24);
                set32(self_buf, 0x614, zs[z]);
                world.word_583a29 = (int16_t)(wm ? 5 : 6);
                if (zs[z] != 0) {          /* the flag set: result 1, [rr + 0x24] = 0 */
                    exp_p4 = 1;
                    exp_rr = 0;
                } else if (wm) {             /* the item is a: result 1, [rr + 0x24] = the node */
                    exp_p4 = 1;
                    exp_rr = va_node;
                } else {                     /* result 0, [rr + 0x24] cleared only when it is the node */
                    exp_p4 = 0;
                    exp_rr = r24 == va_node ? 0 : r24;
                }
                CK(run() == 0 && result() == exp_p4 && get32(arena, RR_OFF + 0x24) == exp_rr && L.n == 0);
            }
        }
    }
    /* rejections: self NULL, the object unresolved, the second pointer unresolved */
    setup();
    node(0xb, 5, 0, 0, 0, 0);
    set32(arena, 0x48, ARENA_VA + OBJ_OFF);
    set32(arena, OBJ_OFF + 0x14, ARENA_VA + RR_OFF);
    {
        int32_t rej = -1;
        m424346_node_condition(NULL, va_node, &world, &host, &rej);
        CK(rej == FL26C_REJECT_UNRESOLVED && result() == INIT);
    }
    set32(arena, 0x48, 0x30000000u);
    CK(run() == FL26C_REJECT_UNRESOLVED && result() == INIT);
    set32(arena, 0x48, ARENA_VA + OBJ_OFF);
    set32(arena, OBJ_OFF + 0x14, 0);        /* [rr + 0x24] is written after the result: the result stays stored (self + 0x614 is non-zero here) */
    CK(run() == FL26C_REJECT_UNRESOLVED && result() == 1);
}

static void test_table_kinds_2_and_3(void)
{
    static const struct {
        uint32_t t;
        int b;
        uint32_t exp;
    } T[] = {{5, 5, 1}, {5, 6, 0}, {0xffffffffu, -1, 1}, {0x10000, 0, 0}, {0xffff8000u, -0x8000, 1}, {0x8000, -0x8000, 0}, {0x10001, 1, 0}, {0, 0, 1}};
    size_t i;
    for (i = 0; i < sizeof T / sizeof T[0]; i++) {
        setup();
        node(2, 2, T[i].b, 0, 0, 0);
        set32(tab2, (2 + 8) * 4, T[i].t);
        set32(tab2, (3 + 8) * 4, (uint32_t)T[i].b);      /* the neighbours do not matter */
        set32(tab2, (1 + 8) * 4, (uint32_t)T[i].b);
        CK(run() == 0 && result() == T[i].exp && L.n == 0);
        setup();
        node(3, -2, T[i].b, 0, 0, 0);
        set32(tab3, (-2 + 8) * 4, T[i].t);
        set32(tab3, (-1 + 8) * 4, (uint32_t)T[i].b);
        set32(tab3, (-3 + 8) * 4, (uint32_t)T[i].b);
        CK(run() == 0 && result() == T[i].exp && L.n == 0);
    }
    setup();
    node(2, 100, 0, 0, 0, 0);
    CK(run() == FL26C_REJECT_UNRESOLVED && result() == INIT);
    setup();
    node(3, -100, 0, 0, 0, 0);
    CK(run() == FL26C_REJECT_UNRESOLVED && result() == INIT);
}

static void test_kind_0x11(void)
{
    static const struct {
        int b;
        uint32_t r;
        uint32_t exp;
    } T[] = {{1, 5, 1}, {1, 0x10000, 1}, {1, 0, 0}, {0, 0, 1}, {0, 3, 0}, {2, 0, 0}, {2, 1, 0}, {-1, 0, 0}, {-1, 1, 0}};
    size_t i;
    for (i = 0; i < sizeof T / sizeof T[0]; i++) {
        setup();
        node(0x11, -5, T[i].b, 0, 0, 0);
        g_ret_4f6334 = T[i].r;
        CK(run() == 0 && result() == T[i].exp);
        /* one host call: 0x4f6334(this = 0x5cf1eb; the signed word a as a dword) */
        CK(L.n == 1 && call_is(0, 0x4f6334, 0x5cf1eb, 1) && L.c[0].a[0] == 0xfffffffbu);
    }
}

static void test_word_kinds_0xf_0xc_0x10(void)
{
    static const struct {
        int w, b;
        uint32_t exp;
    } T[] = {{0, 0, 1}, {1, 2, 0}, {-1, -1, 1}, {-1, 1, 0}, {0x7fff, -0x8000, 0}, {-0x8000, -0x8000, 1}, {5, 5, 1}};
    static const struct {
        int b;
        uint32_t v, exp;
    } U[] = {{1, 0, 1}, {1, 1, 0}, {1, 0x10000, 0}, {2, 0, 0}, {2, 1, 1}, {2, 0x10000, 1}, {2, 0x100, 1}, {0, 0, 0}, {0, 1, 0}, {3, 0, 0}, {-1, 5, 0}};
    size_t i;
    for (i = 0; i < sizeof T / sizeof T[0]; i++) {
        setup();
        node(0xf, 9, T[i].b, 0, 0, 0);
        world.word_58c94f = (int16_t)T[i].w;
        CK(run() == 0 && result() == T[i].exp && L.n == 0);
        setup();
        node(0xc, T[i].b, 9, 0, 0, 0);
        world.word_5bb20a = (int16_t)T[i].w;
        CK(run() == 0 && result() == T[i].exp && L.n == 0);
    }
    for (i = 0; i < sizeof U / sizeof U[0]; i++) {
        setup();
        node(0x10, 0, U[i].b, 0, 0, 0);
        world.value_5bb202 = U[i].v;
        CK(run() == 0 && result() == U[i].exp && L.n == 0);
    }
}

static void test_kind_9(void)
{
    static const struct {
        int t, w;
        uint32_t lt, gt, eq;
    } T[] = {{0, 0, 0, 0, 1}, {1, 2, 1, 0, 0}, {2, 1, 0, 1, 0}, {-1, 1, 1, 0, 0}, {1, -1, 0, 1, 0}, {0x7fff, -0x8000, 0, 1, 0}, {-0x8000, 0x7fff, 1, 0, 0}, {-7, -7, 0, 0, 1}};
    static const int bad[] = {0, 4, -1, 0x100, -0x8000, 0x7fff};
    size_t i;
    int mode;
    for (i = 0; i < sizeof T / sizeof T[0]; i++) {
        for (mode = 1; mode <= 3; mode++) {
            setup();
            node(9, 0, 0, 0, 0, 0);
            set16(arena, 0x18, (uint16_t)-3);               /* q[0]: the index of the table */
            set16(arena, 0x1a, (uint16_t)T[i].w);           /* q[2] */
            set16(arena, 0x1e, (uint16_t)mode);             /* q[6]: the mode */
            set16(tab4, (size_t)(-3 + 16) * 2, (uint16_t)T[i].t);
            set16(tab4, (size_t)(-2 + 16) * 2, (uint16_t)T[i].w);      /* the neighbours */
            set16(tab4, (size_t)(-4 + 16) * 2, (uint16_t)T[i].w);
            CK(run() == 0 && result() == (mode == 1 ? T[i].lt : mode == 2 ? T[i].gt : T[i].eq) && L.n == 0);
        }
    }
    for (i = 0; i < sizeof bad / sizeof bad[0]; i++) {
        setup();
        node(9, 0, 0, 0, 0, 0);
        set16(arena, 0x1e, (uint16_t)bad[i]);
        world.value_5bb57b = 0xabcdef12u;
        CK(run() == 0 && is_format_diagnostic(0x5449a8, 0xabcdef12u));
    }
    setup();       /* the table index of the signed word [q] out of the window */
    node(9, 0, 0, 0, 0, 0);
    set16(arena, 0x18, 0x7000);
    set16(arena, 0x1e, 1);
    CK(run() == FL26C_REJECT_UNRESOLVED && result() == INIT);
}

static void test_kinds_4_and_5(void)
{
    static const struct {
        int32_t v, d;
        uint32_t ge;
    } T[] = {{0, 0, 1}, {1, 2, 0}, {2, 1, 1}, {-1, 1, 0}, {1, -1, 1}, {0x7fffffff, (int32_t)0x80000000, 1}, {(int32_t)0x80000000, 0x7fffffff, 0}, {-3, -3, 1},
             {-5, -2, 0}, {-2, -5, 1}, {0x10000, 0, 1}, {0, 0x10000, 0}, {0x10001, 1, 1}};
    size_t i;
    for (i = 0; i < sizeof T / sizeof T[0]; i++) {
        setup();
        node(4, 0, 0, (uint32_t)T[i].d, 0, 0);
        world.value_585d37 = T[i].v;
        CK(run() == 0 && result() == T[i].ge && L.n == 0);
        setup();
        node(5, 0, 0, (uint32_t)T[i].d, 0, 0);
        world.value_585d41 = T[i].v;
        CK(run() == 0 && result() == T[i].ge && L.n == 0);
    }
}

static void rec5(int a, uint32_t s, uint32_t v)
{
    int j;
    for (j = 0; j < 4; j++) {
        set32(tab5, (size_t)j * 0x106, 0);              /* the other records are dead */
        set32(tab5, (size_t)j * 0x106 + 4, 0x7fffffffu);
    }
    if (a < 0) {      /* the record -1 */
        set32(tab5m, 0, s);
        set32(tab5m, 4, v);
        return;
    }
    set32(tab5, (size_t)a * 0x106, s);
    set32(tab5, (size_t)a * 0x106 + 4, v);
}

static void test_record_kinds_0xd_0xe_0x16(void)
{
    static const uint32_t live[] = {1, 5, 6};
    static const uint32_t dead[] = {0, 2, 3, 4, 7, 0x10001, 0x10005, 0x10006, 0xffffffffu, 0x100};
    static const struct {
        int32_t v, d;
        uint32_t le, gt;
    } T[] = {{0, 0, 1, 0}, {1, 2, 1, 0}, {2, 1, 0, 1}, {-1, 1, 1, 0}, {1, -1, 0, 1}, {0x7fffffff, (int32_t)0x80000000, 0, 1}, {(int32_t)0x80000000, 0x7fffffff, 1, 0},
             {-3, -3, 1, 0}, {0x10000, 0, 0, 1}, {0, 0x10000, 1, 0}};
    size_t i, k;
    int a;
    for (a = -1; a < 4; a++) {
        for (k = 0; k < 3; k++) {
            for (i = 0; i < sizeof T / sizeof T[0]; i++) {
                setup();
                rec5(a, live[k], (uint32_t)T[i].v);
                node(0xd, a, 0, (uint32_t)T[i].d, 0, 0);
                CK(run() == 0 && result() == T[i].le && L.n == 0);
                setup();
                rec5(a, live[k], (uint32_t)T[i].v);
                node(0xe, a, 0, (uint32_t)T[i].d, 0, 0);
                CK(run() == 0 && result() == T[i].gt && L.n == 0);
            }
            setup();
            rec5(a, live[k], 0);
            node(0x16, a, 0, 0, 0, 0);
            CK(run() == 0 && result() == 1 && L.n == 0);
        }
        for (k = 0; k < sizeof dead / sizeof dead[0]; k++) {
            setup();
            rec5(a, dead[k], 0);
            node(0xd, a, 0, 0x7fffffff, 0, 0);
            CK(run() == 0 && result() == 0);
            setup();
            rec5(a, dead[k], 0x7fffffffu);
            node(0xe, a, 0, 0, 0, 0);
            CK(run() == 0 && result() == 0);
            setup();
            rec5(a, dead[k], 0);
            node(0x16, a, 0, 0, 0, 0);
            CK(run() == 0 && result() == 0 && L.n == 0);
        }
    }
    /* a record index outside the windows (the record -2 and the record 100) is rejected; the record -1 is a valid record of the original */
    setup();
    node(0xd, 100, 0, 0, 0, 0);
    CK(run() == FL26C_REJECT_UNRESOLVED && result() == INIT);
    setup();
    node(0x16, -2, 0, 0, 0, 0);
    CK(run() == FL26C_REJECT_UNRESOLVED && result() == INIT);
}

static int in_range(int32_t v, int32_t e, int32_t f)
{
    /* hand-written from the disassembly: e <= f is a plain range; otherwise v is in [e, 0x59f] or in [0, f] */
    if (e <= f) return v >= e && v <= f;
    return (v >= e && v <= 0x59f) || (v >= 0 && v <= f);
}

static void test_kind_6(void)
{
    static const struct {
        int32_t v, d;
        uint32_t ge, le, eq;
    } T[] = {{0, 0, 1, 1, 1}, {1, 2, 0, 1, 0}, {2, 1, 1, 0, 0}, {-1, 1, 0, 1, 0}, {1, -1, 1, 0, 0}, {0x7fffffff, (int32_t)0x80000000, 1, 0, 0},
             {(int32_t)0x80000000, 0x7fffffff, 0, 1, 0}, {-3, -3, 1, 1, 1}, {0x10000, 0, 1, 0, 0}, {0, 0x10000, 0, 1, 0}};
    static const int32_t triples[][3] = {{10, 20, 9}, {10, 20, 10}, {10, 20, 20}, {10, 20, 21}, {-5, -1, -6}, {-5, -1, -1}, {-5, -1, 0}, {7, 7, 7}, {7, 7, 8},
                                         {100, 5, 3}, {100, 5, 5}, {100, 5, 6}, {100, 5, 99}, {100, 5, 100}, {100, 5, 0x59f}, {100, 5, 0x5a0}, {100, 5, -1},
                                         {0x5a0, -1, 0x5a0}, {0x5a0, -1, 0}, {-5, -10, -5}, {-5, -10, -6}, {-5, -10, 0}, {100, 50, 30}, {100, 50, 60},
                                         {100, 50, 51}, {0x900, 0x7ff, 0x7ff}, {0x900, 0x7ff, 0x800}, {0x900, 0x7ff, 0x600}, {0x59f, 5, 0x59f}, {0x59f, 5, 0x5a0}};
    static const int bad[] = {4, 5, -1, 0x100, 0x7fff, -0x8000};
    size_t i;
    for (i = 0; i < sizeof T / sizeof T[0]; i++) {
        setup();
        node(6, 0, 0, (uint32_t)T[i].d, 0, 0);
        world.value_585d4b = T[i].v;
        CK(run() == 0 && result() == T[i].ge && L.n == 0);
        setup();
        node(6, 0, 1, (uint32_t)T[i].d, 0, 0);
        world.value_585d4b = T[i].v;
        CK(run() == 0 && result() == T[i].le && L.n == 0);
        setup();
        node(6, 0, 2, (uint32_t)T[i].d, 0, 0);
        world.value_585d4b = T[i].v;
        CK(run() == 0 && result() == T[i].eq && L.n == 0);
    }
    for (i = 0; i < sizeof triples / sizeof triples[0]; i++) {
        setup();
        node(6, 0, 3, 0x12345678u, (uint32_t)triples[i][0], (uint32_t)triples[i][1]);
        world.value_585d4b = triples[i][2];
        CK(run() == 0 && result() == (uint32_t)in_range(triples[i][2], triples[i][0], triples[i][1]) && L.n == 0);
    }
    /* spot values of the wrapped range spelled out */
    setup();
    node(6, 0, 3, 0, 100, 5);
    world.value_585d4b = 0x59f;
    CK(run() == 0 && result() == 1);
    setup();
    node(6, 0, 3, 0, 100, 5);
    world.value_585d4b = 0x5a0;
    CK(run() == 0 && result() == 0);
    setup();
    node(6, 0, 3, 0, 100, 5);
    world.value_585d4b = 3;
    CK(run() == 0 && result() == 1);
    setup();
    node(6, 0, 3, 0, 100, 5);
    world.value_585d4b = 6;
    CK(run() == 0 && result() == 0);
    for (i = 0; i < sizeof bad / sizeof bad[0]; i++) {
        setup();
        node(6, 0, bad[i], 0, 0, 0);
        world.value_5bb57b = 0x0badf00du;
        CK(run() == 0 && is_format_diagnostic(0x5449e8, 0x0badf00du));
    }
}

static void test_kind_0x14(void)
{
    static const struct {
        int32_t r;
        int32_t rem;
    } R[] = {{0, 0}, {5, 5}, {99, 99}, {100, 0}, {101, 1}, {-1, -1}, {-99, -99}, {-100, 0}, {0x7fffffff, 47}, {(int32_t)0x80000000, -48}, {1234567, 67}};
    static const int bs[] = {-0x8000, -1, 0, 1, 50, 100, 101, 0x7fff};
    static const int wv[] = {0, 1, 0x100, -0x8000};
    size_t i, j, k;
    /* the flag [node + 0x2c] non-zero (any bit): nothing happens at all */
    {
        static const uint32_t zs[] = {1, 0x100, 0x10000, 0xffffffffu};
        for (i = 0; i < 4; i++) {
            setup();
            node(0x14, 0, 50, 0, 0, 0);
            set32(arena, 0x2c, zs[i]);
            set32(arena, 0x30, 0x77u);
            world.word_63a4cd = 1;
            CK(run() == 0 && result() == INIT && L.n == 0 && get32(arena, 0x2c) == zs[i] && get32(arena, 0x30) == 0x77u);
        }
    }
    for (k = 0; k < sizeof wv / sizeof wv[0]; k++) {
        for (j = 0; j < sizeof bs / sizeof bs[0]; j++) {
            for (i = 0; i < sizeof R / sizeof R[0]; i++) {
                int range_bad = bs[j] < 1 || bs[j] > 100;
                int n_calls = wv[k] != 0 && range_bad ? 5 : 1;
                setup();
                node(0x14, 0, bs[j], 0, 0, 0);
                set32(arena, 0x2c, 0);
                set32(arena, 0x30, 0x99999999u);
                world.word_63a4cd = (int16_t)wv[k];
                world.value_5bb57b = 0x11223344u;
                g_ret_50cd50 = (uint32_t)R[i].r;
                CK(run() == 0 && L.n == n_calls && call_is(0, 0x50cd50, 0, 0));
                CK(get32(arena, 0x30) == (uint32_t)R[i].rem && get32(arena, 0x2c) == 1);
                CK(result() == (uint32_t)(R[i].rem < bs[j] ? 1 : 0));
                if (n_calls == 5) {
                    CK(call_is(1, 0x50ca3e, 0, 4) && L.c[1].a[0] == 0x63888b && L.c[1].a[1] == 0x544a34 && L.c[1].a[2] == 0x11223344u && L.c[1].a[3] == (uintptr_t)(uint32_t)bs[j]);
                    CK(call_is(2, 0x52139c, 0, 3) && L.c[2].a[0] == 0x63888b && L.c[2].a[1] == 0 && L.c[2].a[2] == 0);
                    CK(call_is(3, 0x44a2b7, 0, 1) && L.c[3].a[0] == 0x63888b);
                    CK(call_is(4, 0x4c97b4, 0x5cf659, 0));
                }
            }
        }
    }
    /* unresolved node */
    {
        int32_t rej = -1;
        setup();
        m424346_node_condition(self_buf, 0x1000, &world, &host, &rej);
        CK(rej == FL26C_REJECT_UNRESOLVED && L.n == 0);
    }
}

static void test_kind_0x15_and_calls(void)
{
    static const uint32_t vs[] = {0, 1, 0x100, 0x10000, 0xffffffffu};
    size_t i;
    for (i = 0; i < 5; i++) {
        setup();
        node(0x15, 0, 0, 0, 0, 0);
        world.value_5c3a47 = vs[i];
        CK(run() == 0 && result() == (vs[i] != 0) && L.n == 0);
    }
    /* kind 0x10 is not 0x11 and the unused words are ignored: the word [+0x16] and the bytes after the node's fields change nothing */
    setup();
    node(0, 0, 0, 0, 0, 0);
    set16(arena, 0x16, 0x1234);
    CK(run() == 0 && result() == 1 && get32(arena, 0x20) == 0);
}

/* a read that fails in the middle of the node (the object is contiguous in the original, but a host may map it in pieces): the call stops at once,
 * with no host call and no store, wherever the zero that a failed read returns could start one */
static void test_partial_reads_reject(void)
{
    static const int kinds[] = {7, 0x11, 0x14, 0, 2, 4};
    size_t i;
    /* the dword f at +0x28 does not resolve: nothing runs, whatever the kind */
    for (i = 0; i < sizeof kinds / sizeof kinds[0]; i++) {
        setup();
        g_node_off = 0x80;
        node(kinds[i], 0, 1, 0, 0, 0);
        set32(arena, g_node_off + 4, INIT);
        g_hole = ARENA_VA + (uint32_t)g_node_off + 0x28;
        CK(run() == FL26C_REJECT_UNRESOLVED && L.n == 0 && result() == INIT);
    }
    /* the mode word [q + 6] of kind 9 does not resolve: no diagnostic call */
    setup();
    g_node_off = 0x80;
    set32(arena, g_node_off + 4, INIT);
    node(9, 0, 0, 0, 0, 0);
    set16(arena, g_node_off + 0x1e, 5);
    g_hole = ARENA_VA + (uint32_t)g_node_off + 0x1e;
    CK(run() == FL26C_REJECT_UNRESOLVED && L.n == 0 && result() == INIT);
    /* the object pointer [node + 0x48] of kind 0xb does not resolve; the addresses below 0x100 do, so a zero read as the object would be followed */
    setup();
    g_node_off = 0x80;
    set32(arena, g_node_off + 4, INIT);
    node(0xb, 0, 0, 0, 0, 0);
    set32(arena, g_node_off + 0x48, ARENA_VA + OBJ_OFF);
    g_hole = ARENA_VA + (uint32_t)g_node_off + 0x48;
    g_low_ok = 1;
    set32(low_page, 0x14, ARENA_VA + RR_OFF);
    set32(self_buf, 0x614, 1);
    CK(run() == FL26C_REJECT_UNRESOLVED && result() == INIT && get32(arena, RR_OFF + 0x24) == 0xA5A5A5A5u);
}

/* kind 0x14: a failed read of the flag [node + 0x2c], or a store target that does not resolve ([node + 4], [node + 0x30], [node + 0x2c]), is rejected
 * before the random draw and before any diagnostic call; nothing is stored */
static void test_kind_0x14_holes(void)
{
    static const uint32_t holes[] = {0x2c, 0x30, 4};
    static const int bs[] = {50, 0};       /* in range, and out of range (with word 0x63a4cd non-zero: the diagnostic path) */
    size_t i, j;
    for (i = 0; i < sizeof holes / sizeof holes[0]; i++) {
        for (j = 0; j < 2; j++) {
            setup();
            g_node_off = 0x80;
            node(0x14, 0, bs[j], 0, 0, 0);
            set32(arena, g_node_off + 4, INIT);
            set32(arena, g_node_off + 0x2c, 0);
            set32(arena, g_node_off + 0x30, 0x99999999u);
            world.word_63a4cd = 1;
            g_ret_50cd50 = 250;
            g_hole = ARENA_VA + (uint32_t)g_node_off + holes[i];
            CK(run() == FL26C_REJECT_UNRESOLVED && L.n == 0 && result() == INIT && get32(arena, g_node_off + 0x2c) == 0 &&
               get32(arena, g_node_off + 0x30) == 0x99999999u);
        }
    }
}

/* a host without `call` or `resolve` is rejected at once */
static void test_null_host_rejects(void)
{
    int32_t rej = -1;
    Fl18Host no_call;
    setup();
    node(0, 0, 0, 0, 0, 0);
    no_call = host;
    no_call.call = NULL;
    m424346_node_condition(self_buf, ARENA_VA, &world, &no_call, &rej);
    CK(rej == FL26C_REJECT_UNRESOLVED && result() == INIT);
    rej = -1;
    no_call = host;
    no_call.resolve = NULL;
    m424346_node_condition(self_buf, ARENA_VA, &world, &no_call, &rej);
    CK(rej == FL26C_REJECT_UNRESOLVED && result() == INIT);
    rej = -1;
    m424346_node_condition(self_buf, ARENA_VA, &world, NULL, &rej);
    CK(rej == FL26C_REJECT_UNRESOLVED && result() == INIT);
}

static unsigned rnd(void)
{
    static unsigned s = 0x12345678u;
    s = s * 1664525u + 1013904223u;
    return s >> 8;
}

/* a bounded random sweep over every kind with random memory, including nodes and tables that cannot be resolved (meant for the sanitiser builds) */
static void test_sweep(void)
{
    int round;
    for (round = 0; round < 6000; round++) {
        int32_t rej = 0;
        size_t q;
        uint32_t nodeva = ARENA_VA + NODE_OFF;
        setup();
        for (q = 0; q < ARENA_SZ; q++) arena[q] = (uint8_t)rnd();
        for (q = 0; q < sizeof tab1; q++) tab1[q] = tab2[q] = tab3[q] = (uint8_t)(rnd() % 3 ? rnd() : 1);
        for (q = 0; q < sizeof tab4; q++) tab4[q] = (uint8_t)rnd();
        for (q = 0; q < sizeof tab5; q++) tab5[q] = (uint8_t)(rnd() % 3 ? rnd() % 7 : rnd());
        for (q = 0; q < 0x700; q++) self_buf[q] = (uint8_t)(rnd() % 4 ? 0 : rnd());
        set16(arena, 0x10, (uint16_t)(rnd() % 30 - 3));
        if (rnd() % 3 == 0) set16(arena, 0x12, (uint16_t)(rnd() % 9 - 4));
        if (rnd() % 3 == 0) set16(arena, 0x14, (uint16_t)(rnd() % 6 - 1));
        if (rnd() % 2) {
            set32(arena, 0x48, ARENA_VA + OBJ_OFF);
            set32(arena, OBJ_OFF + 0x14, rnd() % 4 ? ARENA_VA + RR_OFF : rnd());
        }
        if (rnd() % 2) set32(arena, 0x2c, 0);
        world.word_583a29 = (int16_t)(rnd() % 9 - 4);
        world.word_63a4cd = (int16_t)(rnd() % 2);
        world.value_5bb202 = rnd() % 2;
        world.value_585d4b = (int32_t)(rnd() % 2000) - 100;
        g_ret_50cd50 = rnd();
        g_ret_4f6334 = rnd() % 2;
        if (rnd() % 16 == 0) nodeva = rnd() % 2 ? 0x4000u : ARENA_VA + ARENA_SZ - 0x10 + (rnd() % 0x20);
        m424346_node_condition(rnd() % 40 ? self_buf : NULL, nodeva, &world, &host, &rej);
        if (rej != 0 && rej != FL26C_REJECT_UNRESOLVED) {
            g_failed = 1;
            snprintf(g_msg, sizeof g_msg, "round %d: reject code %d", round, (int)rej);
        }
    }
}

static const struct {
    const char *name;
    void (*fn)(void);
} CASES[] = {
    {"test_kind_0_unused_and_out_of_range", test_kind_0_and_unused_and_out_of_range},
    {"test_kind_1", test_kind_1},
    {"test_kind_0xb", test_kind_0xb},
    {"test_table_kinds_2_and_3", test_table_kinds_2_and_3},
    {"test_kind_0x11", test_kind_0x11},
    {"test_word_kinds_0xf_0xc_0x10", test_word_kinds_0xf_0xc_0x10},
    {"test_kind_9", test_kind_9},
    {"test_kinds_4_and_5", test_kinds_4_and_5},
    {"test_record_kinds_0xd_0xe_0x16", test_record_kinds_0xd_0xe_0x16},
    {"test_kind_6", test_kind_6},
    {"test_kind_0x14", test_kind_0x14},
    {"test_kind_0x15", test_kind_0x15_and_calls},
    {"test_partial_reads_reject", test_partial_reads_reject},
    {"test_kind_0x14_holes", test_kind_0x14_holes},
    {"test_null_host_rejects", test_null_host_rejects},
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
