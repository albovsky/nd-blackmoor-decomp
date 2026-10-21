/* FL-34 (batch c) direct tests of the eight spill rows of FL-32 in src/original_methods_fl34c.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the failure
 * count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl34c_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl34c.h"

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

#define SELF_SIZE 0x1800
static uint8_t g_self[SELF_SIZE];
#define SELF g_self

/* the memory of the original that the ports read through Fl18Host.resolve */
static uint8_t g_globs[0x400];        /* 0x5d2800 .. 0x5d2c00 */
static uint8_t g_cf[16];              /* 0x5cf660 .. 0x5cf670 */
static uint8_t g_flag[16];            /* 0x61c6a8 .. 0x61c6b8 */
static uint8_t g_recs[0x2000];        /* 0x5bb000 .. 0x5bd000 (the record table at 0x5bb5e5) */
static uint8_t g_void[64];
static Fl34cWorld g_w;
static Fl18Host g_host;

static void set32(uint8_t *b, size_t off, uint32_t v) { memcpy(b + off, &v, 4); }
static uint32_t get32(const uint8_t *b, size_t off)
{
    uint32_t v;
    memcpy(&v, b + off, 4);
    return v;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (a >= 0x5d2800 && a < 0x5d2c00) return g_globs + (a - 0x5d2800);
    if (a >= 0x5cf660 && a < 0x5cf670) return g_cf + (a - 0x5cf660);
    if (a >= 0x61c6a8 && a < 0x61c6b8) return g_flag + (a - 0x61c6a8);
    if (a >= 0x5bb000 && a < 0x5bd000) return g_recs + (a - 0x5bb000);
    return g_void;
}

#define MAXCALL 8
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[6];
        Fl34cWorld world;        /* the world at the call */
        uint32_t d440, d462, d1c, d1576, d24;       /* dwords of self at the call */
        uint8_t rec[0x2c];       /* the 0x2c bytes behind the first argument of 0x4cc962 at the call */
    } c[MAXCALL];
} L;
static uint32_t g_ret;                /* the answer of the callee */
static uint8_t *g_hook_self;          /* what the scripted callee does to the memory (see host_call) */
static int g_hook;
enum { HOOK_NONE, HOOK_GLOBALS, HOOK_REC, HOOK_SELF_JUNK, HOOK_FLAG_ZERO, HOOK_FLAG_SET };

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int k, i = L.n;
    (void)ctx;
    if (L.n < MAXCALL) {
        L.c[i].callee = callee;
        L.c[i].this_ptr = this_ptr;
        L.c[i].nargs = nargs;
        for (k = 0; k < nargs && k < 6; k++) L.c[i].a[k] = args[k];
        L.c[i].world = g_w;
        L.c[i].d440 = get32(SELF, 0x440);
        L.c[i].d462 = get32(SELF, 0x462);
        L.c[i].d1c = get32(SELF, 0x1c);
        L.c[i].d1576 = get32(SELF, 0x1576);
        L.c[i].d24 = get32(SELF, 0x24);
        if (callee == 0x4cc962) memcpy(L.c[i].rec, (const void *)args[0], sizeof L.c[i].rec);
    }
    L.n++;
    switch (g_hook) {
    case HOOK_GLOBALS:
        memset(g_globs, 0x77, sizeof g_globs);
        memset(g_cf, 0x77, sizeof g_cf);
        break;
    case HOOK_REC:
        memset((void *)args[0], 0x99, 0x2c);
        break;
    case HOOK_SELF_JUNK:
        set32(g_hook_self, 0, 0x11223344u);
        set32(g_hook_self, 4, 1);
        set32(g_hook_self, 0x31, 0x55667788u);
        set32(g_hook_self, 0x35, 0x99aabbccu);
        set32(g_hook_self, 0x440, 0x0a0b0c0du);
        set32(g_hook_self, 0x462, 0x0e0f1011u);
        set32(g_hook_self, 0x1c, 0x12131415u);
        break;
    case HOOK_FLAG_ZERO:
        g_flag[6] = 0;
        break;
    case HOOK_FLAG_SET:
        g_flag[6] = 0x80;
        break;
    default: break;
    }
    return g_ret;
}

static void setup(void)
{
    size_t i;
    for (i = 0; i < SELF_SIZE; i++) g_self[i] = (uint8_t)(i * 7 + 3);
    for (i = 0; i < sizeof g_globs; i++) g_globs[i] = (uint8_t)(i * 13 + 5);
    for (i = 0; i < sizeof g_cf; i++) g_cf[i] = (uint8_t)(i * 29 + 1);
    for (i = 0; i < sizeof g_recs; i++) g_recs[i] = (uint8_t)(i * 31 + 9);
    memset(g_flag, 0xff, sizeof g_flag);
    memset(g_void, 0x5c, sizeof g_void);
    for (i = 0; i < sizeof g_w / 2; i++) ((uint16_t *)&g_w)[i] = (uint16_t)(0x1100 + i * 0x111);
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    memset(&L, 0, sizeof L);
    g_ret = 0;
    g_hook = HOOK_NONE;
    g_hook_self = SELF;
}

/* ---- 0x4d0abc, 0x4d0c17, 0x4e01fb ----------------------------------------------------------------------------------------------- */
typedef uint32_t (*PostFn)(Fl34cWorld *, const Fl18Host *);

/* g1 is the first global of the row (three dwords g1, g1 + 4, g1 + 8), `text` the constant pushed first, `word` the world word that is cleared */
static void check_post(PostFn fn, uint32_t g1, uint32_t text, uint16_t *word, int hook)
{
    Fl34cWorld before;
    uint16_t *w16 = (uint16_t *)&g_w;
    size_t i;
    setup();
    set32(g_globs, g1 - 0x5d2800, 0x01020304u);
    set32(g_globs, g1 - 0x5d2800 + 4, 0x05060708u);
    set32(g_globs, g1 - 0x5d2800 + 8, 0x090a0b0cu);
    set32(g_cf, 5, 0x0d0e0f10u);
    g_ret = 0xcafef00du;
    g_hook = hook;                           /* the callee overwrites every global afterwards: they were read before the call */
    *word = 0x7777;
    before = g_w;
    CK(fn(&g_w, &g_host) == 0xcafef00du);
    CK(L.n == 1 && L.c[0].callee == 0x4c5377 && L.c[0].this_ptr == 0x5cf659 && L.c[0].nargs == 5);
    CK(L.c[0].a[0] == 0x01020304u && L.c[0].a[1] == 0x0d0e0f10u && L.c[0].a[2] == 0x05060708u && L.c[0].a[3] == 0x090a0b0cu && L.c[0].a[4] == text);
    CK(memcmp(&L.c[0].world, &before, sizeof before) == 0);          /* nothing is stored before the call */
    CK(g_w.word_5bb1c4 == 2 && *word == 0);
    for (i = 0; i < sizeof g_w / 2; i++) {
        if (&w16[i] == &g_w.word_5bb1c4 || &w16[i] == word) continue;
        CK(w16[i] == ((uint16_t *)&before)[i]);                      /* no other word changes */
    }
}

static void test_m4d0abc_post_message(void)
{
    check_post(m4d0abc_post_message, 0x5d2a1f, 0x55a05c, &g_w.word_63a97c, HOOK_NONE);
    check_post(m4d0abc_post_message, 0x5d2a1f, 0x55a05c, &g_w.word_63a97c, HOOK_GLOBALS);
}

static void test_m4d0c17_post_message(void)
{
    check_post(m4d0c17_post_message, 0x5d2bdb, 0x55a0e8, &g_w.word_63a97e, HOOK_NONE);
    check_post(m4d0c17_post_message, 0x5d2bdb, 0x55a0e8, &g_w.word_63a97e, HOOK_GLOBALS);
}

static void test_m4e01fb_post_message(void)
{
    check_post(m4e01fb_post_message, 0x5d2819, 0x55ba9c, &g_w.word_63a9d0, HOOK_NONE);
    check_post(m4e01fb_post_message, 0x5d2819, 0x55ba9c, &g_w.word_63a9d0, HOOK_GLOBALS);
}

/* ---- 0x4cca9c ------------------------------------------------------------------------------------------------------------------ */
static void test_m4cca9c_fill_record(void)
{
    static const size_t offs[] = {0x40, 0x100, 0, 0x13, 0x14};
    size_t k;
    for (k = 0; k < sizeof offs / sizeof offs[0] && !g_failed; k++) {
        uint8_t want[SELF_SIZE];
        uint8_t *rec;
        int hook;
        for (hook = 0; hook < 2 && !g_failed; hook++) {
            setup();
            memset(SELF, 0xcc, SELF_SIZE);
            rec = SELF + offs[k];
            g_hook = hook ? HOOK_REC : HOOK_NONE;                       /* the callee clobbers the 0x2c bytes at rec: the stores come after it */
            g_ret = 0x13572468u;
            memcpy(want, SELF, sizeof want);
            if (!hook) {
                set32(want, offs[k], 0x11111111u);
                set32(want, offs[k] + 0x14, 0x22222222u);
                set32(want, offs[k] + 0x28, 0x33333333u);
            } else {
                memset(want + offs[k], 0x99, 0x2c);
                set32(want, offs[k], 0x11111111u);
                set32(want, offs[k] + 0x14, 0x22222222u);
                set32(want, offs[k] + 0x28, 0x33333333u);
            }
            CK(m4cca9c_fill_record(SELF, rec, 0x11111111u, 0x22222222u, 0x33333333u, &g_host) == 0x33333333u);      /* eax at the ret = the last argument */
            CK(L.n == 1 && L.c[0].callee == 0x4cc962 && L.c[0].this_ptr == (uintptr_t)SELF && L.c[0].nargs == 1 && L.c[0].a[0] == (uintptr_t)rec);
            CK(memcmp(SELF, want, sizeof want) == 0);                   /* exactly these stores, nothing else */
            if (!hook && offs[k] != 0 && offs[k] != 0x13 && offs[k] != 0x14) {
                size_t i;
                for (i = 0; i < 0x2c; i++) CK(L.c[0].rec[i] == 0xcc);   /* nothing is stored before the call */
            }
        }
    }
}

/* ---- 0x446f77 ------------------------------------------------------------------------------------------------------------------ */
static void test_m446f77_construct(void)
{
    uint8_t want[SELF_SIZE];
    int hook;
    for (hook = 0; hook < 2 && !g_failed; hook++) {
        setup();
        memset(SELF, 0xcc, SELF_SIZE);
        g_hook = hook ? HOOK_SELF_JUNK : HOOK_NONE;
        g_ret = 0xdeadbeefu;
        memcpy(want, SELF, sizeof want);
        if (hook) {                                                     /* what the scripted callee left behind outside the stored fields */
            set32(want, 4, 1);
            set32(want, 0x440, 0x0a0b0c0du);
            set32(want, 0x462, 0x0e0f1011u);
            set32(want, 0x1c, 0x12131415u);
        }
        set32(want, 0, 0x52ca58u);
        set32(want, 0x31, 0);
        set32(want, 0x35, 0);
        CK(m446f77_construct(SELF, &g_host) == SELF);                   /* returns this, not the callee's eax */
        CK(L.n == 1 && L.c[0].callee == 0x51d716 && L.c[0].this_ptr == (uintptr_t)SELF && L.c[0].nargs == 0);
        CK(memcmp(SELF, want, sizeof want) == 0);
        CK(SELF[0] == 0x58 && SELF[1] == 0xca && SELF[2] == 0x52 && SELF[3] == 0);       /* the vtable pointer 0x52ca58, little endian */
    }
}

/* ---- 0x4fce5e ------------------------------------------------------------------------------------------------------------------ */
static void test_m4fce5e_call_with_record_dword(void)
{
    static const int16_t idx[] = {0, 1, 2, -1, -2, 7, 20, -3};
    size_t k;
    for (k = 0; k < sizeof idx / sizeof idx[0] && !g_failed; k++) {
        setup();
        set32(g_recs, (size_t)(0x5e5 + (int32_t)idx[k] * 0x8d), 0xa0b0c0d0u + (uint32_t)k);        /* 0x5bb5e5 - 0x5bb000 = 0x5e5 */
        g_ret = 0x1234567u + (uint32_t)k;
        CK(m4fce5e_call_with_record_dword(idx[k], &g_host) == 0x1234567u + (uint32_t)k);
        CK(L.n == 1 && L.c[0].callee == 0x4f7e93 && L.c[0].this_ptr == 0x5cf1eb && L.c[0].nargs == 1);
        CK(L.c[0].a[0] == 0xa0b0c0d0u + (uint32_t)k);                  /* the dword at 0x5bb5e5 + index * 0x8d, unaligned */
    }
    /* the sign extension: index -1 reads 0x8d bytes BELOW the table base, not 0xffff * 0x8d above it */
    setup();
    set32(g_recs, 0x5e5 - 0x8d, 0x600dc0deu);
    (void)m4fce5e_call_with_record_dword(-1, &g_host);
    CK(L.c[0].a[0] == 0x600dc0deu);
    /* the stride is 0x8d: a read at stride 0x8c or 0x8e would give another dword */
    setup();
    set32(g_recs, 0x5e5 + 3 * 0x8d, 0x0badf00du);
    (void)m4fce5e_call_with_record_dword(3, &g_host);
    CK(L.c[0].a[0] == 0x0badf00du);
}

/* ---- 0x4d3ffe ------------------------------------------------------------------------------------------------------------------ */
static void test_m4d3ffe_start_flag(void)
{
    static const struct {
        uint8_t flag;
        int hook;
    } cases[] = {{0, HOOK_NONE}, {1, HOOK_NONE}, {0x80, HOOK_NONE}, {0xff, HOOK_NONE}, {5, HOOK_FLAG_ZERO}, {0, HOOK_FLAG_SET}, {0, HOOK_SELF_JUNK}, {7, HOOK_SELF_JUNK}};
    size_t k;
    for (k = 0; k < sizeof cases / sizeof cases[0] && !g_failed; k++) {
        uint8_t want[SELF_SIZE];
        uintptr_t r;
        int flag_after;
        setup();
        memset(SELF, 0xcc, SELF_SIZE);
        memset(g_flag, 0xff, sizeof g_flag);                           /* the bytes next to the flag are non-zero: only the byte counts */
        g_flag[6] = cases[k].flag;                                      /* 0x61c6ae - 0x61c6a8 = 6 */
        g_hook = cases[k].hook;
        g_ret = 0x2468ace0u;
        memcpy(want, SELF, sizeof want);
        flag_after = cases[k].hook == HOOK_FLAG_ZERO ? 0 : cases[k].hook == HOOK_FLAG_SET ? 0x80 : cases[k].flag;
        if (cases[k].hook == HOOK_SELF_JUNK) {
            set32(want, 0, 0x11223344u);
            set32(want, 4, 1);
            set32(want, 0x31, 0x55667788u);
            set32(want, 0x35, 0x99aabbccu);
        }
        set32(want, 0x440, 1);
        set32(want, 0x462, 0);
        if (flag_after == 0) set32(want, 0x1c, 0);
        else if (cases[k].hook == HOOK_SELF_JUNK) set32(want, 0x1c, 0x12131415u);
        if (cases[k].hook == HOOK_SELF_JUNK) set32(want, 0x440, 0x0a0b0c0du);     /* the callee overwrote the 1; the function does not store it again */
        r = m4d3ffe_start_flag(SELF, &g_host);
        CK(L.n == 1 && L.c[0].callee == 0x4dad60 && L.c[0].this_ptr == 0x5830a6 && L.c[0].nargs == 0);
        CK(L.c[0].d440 == 1);                                           /* the 1 is stored before the call */
        CK(memcmp(SELF, want, sizeof want) == 0);
        if (flag_after == 0) CK(r == (uintptr_t)SELF);                  /* eax is this on the zero path */
        else CK(r == 0x2468ace0u);                                      /* and the callee's eax when the flag is set */
    }
}

/* ---- 0x47a3d9 ------------------------------------------------------------------------------------------------------------------ */
static void test_m47a3d9_set_flags(void)
{
    static const uint32_t answers[] = {0, 1, 0x10000, 0x80000000u, 0xffffffffu, 0x100, 0xffff};
    size_t k;
    for (k = 0; k < sizeof answers / sizeof answers[0] && !g_failed; k++) {
        uint8_t want[SELF_SIZE];
        uintptr_t r;
        setup();
        memset(SELF, 0xcc, SELF_SIZE);
        g_ret = answers[k];
        memcpy(want, SELF, sizeof want);
        if (answers[k] != 0) {
            set32(want, 0x1576, 1);
            set32(want, 0x24, 1);
        } else {
            set32(want, 0x1576, 0);
        }
        r = m47a3d9_set_flags(SELF, &g_host);
        CK(L.n == 1 && L.c[0].callee == 0x4789d6 && L.c[0].this_ptr == (uintptr_t)SELF && L.c[0].nargs == 0);
        CK(memcmp(SELF, want, sizeof want) == 0);                       /* the zero path leaves 0x24 alone */
        CK(r == (answers[k] != 0 ? (uintptr_t)SELF : 0));
    }
}

/* ---- exact-size buffers (meant for the sanitiser builds: a store or a load outside the bytes the original touches is a report) ----------- */
static void test_exact_size_buffers(void)
{
    uint8_t *p, *q;
    setup();
    p = (uint8_t *)malloc(0x39);               /* 0x446f77: the highest store is the dword at +0x35 */
    CK(p != NULL);
    if (p != NULL) {
        memset(p, 0x99, 0x39);
        CK(m446f77_construct(p, &g_host) == p);
        free(p);
    }
    p = (uint8_t *)malloc(0x2c);               /* 0x4cca9c: self is not touched; rec is exactly 0x2c bytes */
    q = (uint8_t *)malloc(1);
    CK(p != NULL && q != NULL);
    if (p != NULL && q != NULL) {
        memset(p, 0x99, 0x2c);
        (void)m4cca9c_fill_record(q, p, 1, 2, 3, &g_host);
    }
    free(p);
    free(q);
    p = (uint8_t *)malloc(0x466);              /* 0x4d3ffe: the highest store is the dword at +0x462 */
    CK(p != NULL);
    if (p != NULL) {
        memset(p, 0x99, 0x466);
        g_flag[6] = 0;
        (void)m4d3ffe_start_flag(p, &g_host);
        g_flag[6] = 1;
        (void)m4d3ffe_start_flag(p, &g_host);
        free(p);
    }
    p = (uint8_t *)malloc(0x157a);             /* 0x47a3d9: the highest store is the dword at +0x1576 */
    CK(p != NULL);
    if (p != NULL) {
        memset(p, 0x99, 0x157a);
        g_ret = 1;
        (void)m47a3d9_set_flags(p, &g_host);
        g_ret = 0;
        (void)m47a3d9_set_flags(p, &g_host);
        free(p);
    }
    /* the three post_message rows touch no object; 0x4fce5e only reads through the host */
    (void)m4d0abc_post_message(&g_w, &g_host);
    (void)m4d0c17_post_message(&g_w, &g_host);
    (void)m4e01fb_post_message(&g_w, &g_host);
    (void)m4fce5e_call_with_record_dword(5, &g_host);
}

/* CASES-END */

/* ---- bounded sweep ------------------------------------------------------------------------------------------------------------- */
static void test_sweep_bounded(void)
{
    unsigned seed = 4242;
    int n;
    size_t i;
    for (n = 0; n < 300 && !g_failed; n++) {
        setup();
        for (i = 0; i < SELF_SIZE; i++) {
            seed = seed * 1103515245u + 12345u;
            g_self[i] = (uint8_t)(seed >> 16);
        }
        for (i = 0; i < sizeof g_globs; i++) {
            seed = seed * 1103515245u + 12345u;
            g_globs[i] = (uint8_t)(seed >> 16);
        }
        for (i = 0; i < sizeof g_flag; i++) {
            seed = seed * 1103515245u + 12345u;
            g_flag[i] = (n % 3 == 0) ? 0 : (uint8_t)(seed >> 16);
        }
        seed = seed * 1103515245u + 12345u;
        g_ret = seed;
        m4d0abc_post_message(&g_w, &g_host);
        m4d0c17_post_message(&g_w, &g_host);
        m4e01fb_post_message(&g_w, &g_host);
        L.n = 0;
        m4cca9c_fill_record(g_self, g_self + (seed % (SELF_SIZE - 0x2c)), seed, seed >> 3, seed >> 5, &g_host);
        L.n = 0;
        m446f77_construct(g_self + (seed >> 8) % 0x100, &g_host);
        L.n = 0;
        m4fce5e_call_with_record_dword((int16_t)(seed % 40) - 10, &g_host);
        L.n = 0;
        m4d3ffe_start_flag(g_self, &g_host);
        L.n = 0;
        m47a3d9_set_flags(g_self, &g_host);
        /* SWEEP-END */
    }
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
    RUN(test_m4d0abc_post_message);
    RUN(test_m4d0c17_post_message);
    RUN(test_m4e01fb_post_message);
    RUN(test_m4cca9c_fill_record);
    RUN(test_m446f77_construct);
    RUN(test_m4fce5e_call_with_record_dword);
    RUN(test_m4d3ffe_start_flag);
    RUN(test_m47a3d9_set_flags);
    /* RUN-END */
    RUN(test_exact_size_buffers);
    RUN(test_sweep_bounded);
    return failures;
}
