/* FL-38 (batch a) direct tests of the 27 GAME.EXE functions in src/original_methods_fl38a.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE (each row's offsets, callees and constants read from
 * its own instructions), not from running the native code; tests/test_fl38a_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl38a.h"

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

#define SELF_SIZE 0x5000
static uint8_t g_self[SELF_SIZE];
#define SELF g_self
#define TBL_SIZE 0x1000
#define TBL_ZERO 0x200          /* byte offset in g_tbl of the original address 0x5d15a5 (room for the negative indices) */
static uint8_t g_tbl[TBL_SIZE];
static Fl38aWorld g_world;
static Fl18Host g_host;

#define MAXCALL 8
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[2];
        uint32_t watch;         /* the dword at [self + g_watch_off] at the call (a store after a call must not show yet) */
    } c[MAXCALL];
} L;
static uint32_t g_ret[0x100];    /* the answer of the callee, by the order of the call */
static size_t g_watch_off;

static uint32_t get32(const uint8_t *p, size_t off)
{
    return (uint32_t)p[off] | (uint32_t)p[off + 1] << 8 | (uint32_t)p[off + 2] << 16 | (uint32_t)p[off + 3] << 24;
}

UNUSED_FN static void put32(uint8_t *p, size_t off, uint32_t v)
{
    p[off] = (uint8_t)v;
    p[off + 1] = (uint8_t)(v >> 8);
    p[off + 2] = (uint8_t)(v >> 16);
    p[off + 3] = (uint8_t)(v >> 24);
}

UNUSED_FN static void put16(uint8_t *p, size_t off, uint32_t v)
{
    p[off] = (uint8_t)v;
    p[off + 1] = (uint8_t)(v >> 8);
}

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int k, i = L.n;
    (void)ctx;
    if (L.n < MAXCALL) {
        L.c[i].callee = callee;
        L.c[i].this_ptr = this_ptr;
        L.c[i].nargs = nargs;
        for (k = 0; k < nargs && k < 2; k++) L.c[i].a[k] = args[k];
        L.c[i].watch = get32(g_self, g_watch_off);
    }
    L.n++;
    return g_ret[i < 0x100 ? i : 0];
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
    for (i = 0; i < TBL_SIZE; i++) g_tbl[i] = (uint8_t)(i * 11 + 5);
    memset(&g_world, 0, sizeof g_world);
    g_world.table_5d15a5 = g_tbl + TBL_ZERO;
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    L.n = 0;
    memset(g_ret, 0, sizeof g_ret);
    g_watch_off = 0;
}

static const uint32_t DWORDS[] = {0, 1, 0x100, 0x10000, 0x01000000u, 0x80000000u, 0xffffffffu};
#define NDWORDS (sizeof DWORDS / sizeof DWORDS[0])
static const uint32_t RETS[] UNUSED_FN = {0, 0x80000000u, 0xcafef00du, 0xffffffffu};

typedef uint32_t (*GetFn)(uint8_t *);
typedef uint32_t (*CallFn)(uint8_t *, const Fl18Host *);
typedef uint8_t *(*GuardFn)(uint8_t *, const Fl38aWorld *);

static void check_get(GetFn fn, uint32_t value)
{
    uint8_t want[SELF_SIZE];
    setup();
    memcpy(want, SELF, sizeof want);
    CK(fn(SELF) == value);
    CK(memcmp(SELF, want, sizeof want) == 0);
}

/* guard: dword [self+a] and the signed word [self+b] pick the record 0x4a * index of the table at 0x5d15a5; the dword 1 is stored there, nothing else changes */
static void check_guard(GuardFn fn, uint32_t a, uint32_t b)
{
    static const int32_t idx[] = {0, 1, 5, 0x20, -2, -3, -1};
    uint8_t want_self[SELF_SIZE];
    uint8_t want_tbl[TBL_SIZE];
    size_t i, j;
    for (j = 0; j < NDWORDS && !g_failed; j++)
        for (i = 0; i < 7 && !g_failed; i++) {
            setup();
            put32(SELF, a, DWORDS[j]);
            put16(SELF, b, (uint32_t)idx[i] & 0xffff);
            memcpy(want_self, SELF, sizeof want_self);
            memcpy(want_tbl, g_tbl, sizeof want_tbl);
            if (DWORDS[j] != 0 && idx[i] != -1) put32(want_tbl, (size_t)(TBL_ZERO + idx[i] * 0x4a), 1);
            CK(fn(SELF, &g_world) == SELF);
            CK(memcmp(SELF, want_self, sizeof want_self) == 0);
            CK(memcmp(g_tbl, want_tbl, sizeof want_tbl) == 0);
            CK(L.n == 0);
        }
}

/* release / releaseclr: the calls in order, their arguments, the dword [self+a] at the first call (the clear comes after it), and the result of the last call */
static void check_release(CallFn fn, uint32_t a, uint32_t b, uint32_t tail, int clears)
{
    static const uint32_t words[] = {0xffff, 0, 1, 0x7fff, 0x8000, 0xfffe, 0x1234};
    uint8_t want[SELF_SIZE];
    size_t i, j;
    int n;
    for (j = 0; j < NDWORDS && !g_failed; j++)
        for (i = 0; i < sizeof words / sizeof words[0] && !g_failed; i++) {
            setup();
            g_watch_off = a;
            put32(SELF, a, DWORDS[j]);
            put16(SELF, b, words[i]);
            g_ret[0] = 0x11111111u;
            g_ret[1] = 0x22222222u;
            g_ret[2] = 0x33333333u;
            g_ret[(DWORDS[j] != 0) + (words[i] != 0xffff)] = RETS[(i + j) % 4];      /* the answer of the last call (the tail) */
            memcpy(want, SELF, sizeof want);
            if (clears && DWORDS[j] != 0) put32(want, a, 0);
            n = 0;
            CK(fn(SELF, &g_host) == RETS[(i + j) % 4]);
            if (DWORDS[j] != 0) {
                CK(L.c[n].callee == 0x4c2dfb && L.c[n].this_ptr == 0x5cf659 && L.c[n].nargs == 1 && L.c[n].a[0] == (uintptr_t)(SELF + a) && L.c[n].watch == DWORDS[j]);
                n++;
            }
            if (words[i] != 0xffff) {
                CK(L.c[n].callee == 0x4d3992 && L.c[n].this_ptr == 0 && L.c[n].nargs == 1 && (L.c[n].a[0] & 0xffff) == words[i] && L.c[n].watch == (clears ? 0u : DWORDS[j]));
                n++;
            }
            CK(L.c[n].callee == tail && L.c[n].this_ptr == (uintptr_t)SELF && L.c[n].nargs == 0 && L.c[n].watch == (clears ? 0u : DWORDS[j]));
            n++;
            CK(L.n == n);
            CK(memcmp(SELF, want, sizeof want) == 0);
        }
}

/* nosound: the 9 bytes at [self+a] against "NO SOUND\0"; every byte position and a difference just outside the 9 bytes */
static void check_nosound(CallFn fn, uint32_t a, uint32_t b)
{
    static const uint8_t k[9] = {'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0};
    uint8_t want[SELF_SIZE];
    int pos;
    for (pos = -1; pos <= 9 && !g_failed; pos++) {
        setup();
        memcpy(SELF + a, k, 9);
        put16(SELF, b, 0x8123);
        if (pos >= 0 && pos < 9) SELF[a + (size_t)pos] ^= 0x20;
        if (pos == -1) SELF[a - 1] ^= 0x01;
        if (pos == 9) SELF[a + 9] ^= 0x01;
        memcpy(want, SELF, sizeof want);
        g_ret[0] = 0xcafef00du;
        if (pos >= 0 && pos < 9) {
            CK(fn(SELF, &g_host) == 0xcafef00du);
            CK(L.n == 1);
            CK(L.c[0].callee == 0x4fb2e3 && L.c[0].this_ptr == 0x5c3a67 && L.c[0].nargs == 1 && (L.c[0].a[0] & 0xffff) == 0x8123);
        } else {
            CK(fn(SELF, &g_host) == 0);
            CK(L.n == 0);
        }
        CK(memcmp(SELF, want, sizeof want) == 0);
    }
}

static void test_m414c6d_get_constant(void)
{
    (void)m414c6d_get_constant;
    check_get(m414c6d_get_constant, 0x52c4d0u);
}

static void test_m447cc4_get_constant(void)
{
    (void)m447cc4_get_constant;
    check_get(m447cc4_get_constant, 0x52ca38u);
}

static void test_m4487de_get_constant(void)
{
    (void)m4487de_get_constant;
    check_get(m4487de_get_constant, 0x52cae8u);
}

static void test_m44be44_get_constant(void)
{
    (void)m44be44_get_constant;
    check_get(m44be44_get_constant, 0x52cb78u);
}

static void test_m4542b5_check_no_sound_call(void)
{
    (void)m4542b5_check_no_sound_call;
    check_nosound(m4542b5_check_no_sound_call, 0x550, 0x571);
}

static void test_m4542f2_check_no_sound_call(void)
{
    (void)m4542f2_check_no_sound_call;
    check_nosound(m4542f2_check_no_sound_call, 0x581, 0x5a2);
}

static void test_m45441d_check_no_sound_call(void)
{
    (void)m45441d_check_no_sound_call;
    check_nosound(m45441d_check_no_sound_call, 0x676, 0x697);
}

static void test_m454de6_release_surface_clear_call_tail(void)
{
    (void)m454de6_release_surface_clear_call_tail;
    check_release(m454de6_release_surface_clear_call_tail, 0x20, 0x1c, 0x454d9e, 1);
}

static void test_m454e39_guard_set_table_flag(void)
{
    (void)m454e39_guard_set_table_flag;
    check_guard(m454e39_guard_set_table_flag, 0x150, 0x1c);
}

static void test_m456d2e_release_surface_call_tail(void)
{
    (void)m456d2e_release_surface_call_tail;
    check_release(m456d2e_release_surface_call_tail, 0x20, 0x1c, 0x456d07, 0);
}

static void test_m456d77_guard_set_table_flag(void)
{
    (void)m456d77_guard_set_table_flag;
    check_guard(m456d77_guard_set_table_flag, 0x3e, 0x1c);
}

static void test_m457fc2_release_surface_clear_call_tail(void)
{
    (void)m457fc2_release_surface_clear_call_tail;
    check_release(m457fc2_release_surface_clear_call_tail, 0x1c, 0x24, 0x457f7a, 1);
}

static void test_m458045_guard_set_table_flag(void)
{
    (void)m458045_guard_set_table_flag;
    check_guard(m458045_guard_set_table_flag, 0x98, 0x24);
}

static void test_m459b87_release_surface_call_tail(void)
{
    (void)m459b87_release_surface_call_tail;
    check_release(m459b87_release_surface_call_tail, 0xc8, 0x22, 0x459aea, 0);
}

static void test_m45dd4d_release_surface_call_tail(void)
{
    (void)m45dd4d_release_surface_call_tail;
    check_release(m45dd4d_release_surface_call_tail, 0x20, 0x1c, 0x45dc8a, 0);
}

static void test_m464076_release_surface_clear_call_tail(void)
{
    (void)m464076_release_surface_clear_call_tail;
    check_release(m464076_release_surface_clear_call_tail, 0x20, 0x1c, 0x46402e, 1);
}

static void test_m4640c9_guard_set_table_flag(void)
{
    (void)m4640c9_guard_set_table_flag;
    check_guard(m4640c9_guard_set_table_flag, 0xb8, 0x1c);
}

static void test_m465b9f_guard_set_table_flag(void)
{
    (void)m465b9f_guard_set_table_flag;
    check_guard(m465b9f_guard_set_table_flag, 0x49, 0x1c);
}

static void test_m467651_guard_set_table_flag(void)
{
    (void)m467651_guard_set_table_flag;
    check_guard(m467651_guard_set_table_flag, 0x1ae, 0x10);
}

static void test_m468f19_release_surface_call_tail(void)
{
    (void)m468f19_release_surface_call_tail;
    check_release(m468f19_release_surface_call_tail, 0x52c, 0x7c, 0x468e5a, 0);
}

static void test_m468f68_guard_set_table_flag(void)
{
    (void)m468f68_guard_set_table_flag;
    check_guard(m468f68_guard_set_table_flag, 0x55c, 0x7c);
}

static void test_m46b707_guard_set_table_flag(void)
{
    (void)m46b707_guard_set_table_flag;
    check_guard(m46b707_guard_set_table_flag, 0x4a48, 0x1c);
}

static void test_m46e7a6_release_surface_call_tail(void)
{
    (void)m46e7a6_release_surface_call_tail;
    check_release(m46e7a6_release_surface_call_tail, 0x20, 0x1c, 0x46e6c1, 0);
}

static void test_m46e7ef_guard_set_table_flag(void)
{
    (void)m46e7ef_guard_set_table_flag;
    check_guard(m46e7ef_guard_set_table_flag, 0x46, 0x1c);
}

static void test_m470ddc_release_surface_call_tail(void)
{
    (void)m470ddc_release_surface_call_tail;
    check_release(m470ddc_release_surface_call_tail, 0xd24, 0xd38, 0x470d7a, 0);
}

static void test_m47823e_release_surface_call_tail(void)
{
    (void)m47823e_release_surface_call_tail;
    check_release(m47823e_release_surface_call_tail, 0x20, 0x1c, 0x4781fa, 0);
}

static void test_m478287_guard_set_table_flag(void)
{
    (void)m478287_guard_set_table_flag;
    check_guard(m478287_guard_set_table_flag, 0x157a, 0x1c);
}

static void test_exact_size_buffers(void)
{
    uint8_t *p = NULL, *t = NULL;
    (void)p;
    (void)t;
    setup();
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    (void)m414c6d_get_constant(p);
    free(p);
    setup();
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    (void)m447cc4_get_constant(p);
    free(p);
    setup();
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    (void)m4487de_get_constant(p);
    free(p);
    setup();
    p = (uint8_t *)malloc(1);
    CK(p != NULL);
    if (p == NULL) return;
    (void)m44be44_get_constant(p);
    free(p);
    setup();
    p = (uint8_t *)malloc(1395);
    CK(p != NULL);
    if (p == NULL) return;
    memcpy(p + 0x550, "NO SOUND", 9);
    L.n = 0;
    (void)m4542b5_check_no_sound_call(p, &g_host);
    free(p);
    setup();
    p = (uint8_t *)malloc(1444);
    CK(p != NULL);
    if (p == NULL) return;
    memcpy(p + 0x581, "NO SOUND", 9);
    L.n = 0;
    (void)m4542f2_check_no_sound_call(p, &g_host);
    free(p);
    setup();
    p = (uint8_t *)malloc(1689);
    CK(p != NULL);
    if (p == NULL) return;
    memcpy(p + 0x676, "NO SOUND", 9);
    L.n = 0;
    (void)m45441d_check_no_sound_call(p, &g_host);
    free(p);
    setup();
    p = (uint8_t *)malloc(36);
    CK(p != NULL);
    if (p == NULL) return;
    memset(p, 0, 36);
    p[0x20] = 1;
    L.n = 0;
    (void)m454de6_release_surface_clear_call_tail(p, &g_host);
    free(p);
    setup();
    p = (uint8_t *)malloc(340);
    t = (uint8_t *)malloc(4);
    CK(p != NULL && t != NULL);
    if (p == NULL || t == NULL) return;
    memset(p, 0, 340);
    p[0x150] = 1;
    g_world.table_5d15a5 = t;
    (void)m454e39_guard_set_table_flag(p, &g_world);
    CK(get32(t, 0) == 1);
    free(p);
    free(t);
    setup();
    p = (uint8_t *)malloc(36);
    CK(p != NULL);
    if (p == NULL) return;
    memset(p, 0, 36);
    p[0x20] = 1;
    L.n = 0;
    (void)m456d2e_release_surface_call_tail(p, &g_host);
    free(p);
    setup();
    p = (uint8_t *)malloc(66);
    t = (uint8_t *)malloc(4);
    CK(p != NULL && t != NULL);
    if (p == NULL || t == NULL) return;
    memset(p, 0, 66);
    p[0x3e] = 1;
    g_world.table_5d15a5 = t;
    (void)m456d77_guard_set_table_flag(p, &g_world);
    CK(get32(t, 0) == 1);
    free(p);
    free(t);
    setup();
    p = (uint8_t *)malloc(38);
    CK(p != NULL);
    if (p == NULL) return;
    memset(p, 0, 38);
    p[0x1c] = 1;
    L.n = 0;
    (void)m457fc2_release_surface_clear_call_tail(p, &g_host);
    free(p);
    setup();
    p = (uint8_t *)malloc(156);
    t = (uint8_t *)malloc(4);
    CK(p != NULL && t != NULL);
    if (p == NULL || t == NULL) return;
    memset(p, 0, 156);
    p[0x98] = 1;
    g_world.table_5d15a5 = t;
    (void)m458045_guard_set_table_flag(p, &g_world);
    CK(get32(t, 0) == 1);
    free(p);
    free(t);
    setup();
    p = (uint8_t *)malloc(204);
    CK(p != NULL);
    if (p == NULL) return;
    memset(p, 0, 204);
    p[0xc8] = 1;
    L.n = 0;
    (void)m459b87_release_surface_call_tail(p, &g_host);
    free(p);
    setup();
    p = (uint8_t *)malloc(36);
    CK(p != NULL);
    if (p == NULL) return;
    memset(p, 0, 36);
    p[0x20] = 1;
    L.n = 0;
    (void)m45dd4d_release_surface_call_tail(p, &g_host);
    free(p);
    setup();
    p = (uint8_t *)malloc(36);
    CK(p != NULL);
    if (p == NULL) return;
    memset(p, 0, 36);
    p[0x20] = 1;
    L.n = 0;
    (void)m464076_release_surface_clear_call_tail(p, &g_host);
    free(p);
    setup();
    p = (uint8_t *)malloc(188);
    t = (uint8_t *)malloc(4);
    CK(p != NULL && t != NULL);
    if (p == NULL || t == NULL) return;
    memset(p, 0, 188);
    p[0xb8] = 1;
    g_world.table_5d15a5 = t;
    (void)m4640c9_guard_set_table_flag(p, &g_world);
    CK(get32(t, 0) == 1);
    free(p);
    free(t);
    setup();
    p = (uint8_t *)malloc(77);
    t = (uint8_t *)malloc(4);
    CK(p != NULL && t != NULL);
    if (p == NULL || t == NULL) return;
    memset(p, 0, 77);
    p[0x49] = 1;
    g_world.table_5d15a5 = t;
    (void)m465b9f_guard_set_table_flag(p, &g_world);
    CK(get32(t, 0) == 1);
    free(p);
    free(t);
    setup();
    p = (uint8_t *)malloc(434);
    t = (uint8_t *)malloc(4);
    CK(p != NULL && t != NULL);
    if (p == NULL || t == NULL) return;
    memset(p, 0, 434);
    p[0x1ae] = 1;
    g_world.table_5d15a5 = t;
    (void)m467651_guard_set_table_flag(p, &g_world);
    CK(get32(t, 0) == 1);
    free(p);
    free(t);
    setup();
    p = (uint8_t *)malloc(1328);
    CK(p != NULL);
    if (p == NULL) return;
    memset(p, 0, 1328);
    p[0x52c] = 1;
    L.n = 0;
    (void)m468f19_release_surface_call_tail(p, &g_host);
    free(p);
    setup();
    p = (uint8_t *)malloc(1376);
    t = (uint8_t *)malloc(4);
    CK(p != NULL && t != NULL);
    if (p == NULL || t == NULL) return;
    memset(p, 0, 1376);
    p[0x55c] = 1;
    g_world.table_5d15a5 = t;
    (void)m468f68_guard_set_table_flag(p, &g_world);
    CK(get32(t, 0) == 1);
    free(p);
    free(t);
    setup();
    p = (uint8_t *)malloc(19020);
    t = (uint8_t *)malloc(4);
    CK(p != NULL && t != NULL);
    if (p == NULL || t == NULL) return;
    memset(p, 0, 19020);
    p[0x4a48] = 1;
    g_world.table_5d15a5 = t;
    (void)m46b707_guard_set_table_flag(p, &g_world);
    CK(get32(t, 0) == 1);
    free(p);
    free(t);
    setup();
    p = (uint8_t *)malloc(36);
    CK(p != NULL);
    if (p == NULL) return;
    memset(p, 0, 36);
    p[0x20] = 1;
    L.n = 0;
    (void)m46e7a6_release_surface_call_tail(p, &g_host);
    free(p);
    setup();
    p = (uint8_t *)malloc(74);
    t = (uint8_t *)malloc(4);
    CK(p != NULL && t != NULL);
    if (p == NULL || t == NULL) return;
    memset(p, 0, 74);
    p[0x46] = 1;
    g_world.table_5d15a5 = t;
    (void)m46e7ef_guard_set_table_flag(p, &g_world);
    CK(get32(t, 0) == 1);
    free(p);
    free(t);
    setup();
    p = (uint8_t *)malloc(3386);
    CK(p != NULL);
    if (p == NULL) return;
    memset(p, 0, 3386);
    p[0xd24] = 1;
    L.n = 0;
    (void)m470ddc_release_surface_call_tail(p, &g_host);
    free(p);
    setup();
    p = (uint8_t *)malloc(36);
    CK(p != NULL);
    if (p == NULL) return;
    memset(p, 0, 36);
    p[0x20] = 1;
    L.n = 0;
    (void)m47823e_release_surface_call_tail(p, &g_host);
    free(p);
    setup();
    p = (uint8_t *)malloc(5502);
    t = (uint8_t *)malloc(4);
    CK(p != NULL && t != NULL);
    if (p == NULL || t == NULL) return;
    memset(p, 0, 5502);
    p[0x157a] = 1;
    g_world.table_5d15a5 = t;
    (void)m478287_guard_set_table_flag(p, &g_world);
    CK(get32(t, 0) == 1);
    free(p);
    free(t);
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
    RUN(test_m414c6d_get_constant);
    RUN(test_m447cc4_get_constant);
    RUN(test_m4487de_get_constant);
    RUN(test_m44be44_get_constant);
    RUN(test_m4542b5_check_no_sound_call);
    RUN(test_m4542f2_check_no_sound_call);
    RUN(test_m45441d_check_no_sound_call);
    RUN(test_m454de6_release_surface_clear_call_tail);
    RUN(test_m454e39_guard_set_table_flag);
    RUN(test_m456d2e_release_surface_call_tail);
    RUN(test_m456d77_guard_set_table_flag);
    RUN(test_m457fc2_release_surface_clear_call_tail);
    RUN(test_m458045_guard_set_table_flag);
    RUN(test_m459b87_release_surface_call_tail);
    RUN(test_m45dd4d_release_surface_call_tail);
    RUN(test_m464076_release_surface_clear_call_tail);
    RUN(test_m4640c9_guard_set_table_flag);
    RUN(test_m465b9f_guard_set_table_flag);
    RUN(test_m467651_guard_set_table_flag);
    RUN(test_m468f19_release_surface_call_tail);
    RUN(test_m468f68_guard_set_table_flag);
    RUN(test_m46b707_guard_set_table_flag);
    RUN(test_m46e7a6_release_surface_call_tail);
    RUN(test_m46e7ef_guard_set_table_flag);
    RUN(test_m470ddc_release_surface_call_tail);
    RUN(test_m47823e_release_surface_call_tail);
    RUN(test_m478287_guard_set_table_flag);
    RUN(test_exact_size_buffers);
    return failures;
}
