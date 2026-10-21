/* FL-33 (batch a) direct tests of the eight methods of GAME.EXE in src/original_methods_fl33a.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl33a_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl33a.h"

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

/* host memory: region i lives at the original address RVA(i); region 0 is `self`. The strings of the original's data (0x552494 ...) live in g_str, 0x552000 + offset. */
#define RVA(i) (0x20000000u + 0x10000u * (uint32_t)(i))
#define RSZ 0x4000
static uint8_t g_r[8][RSZ];
static uint8_t g_str[0x1000];
static uint8_t g_tbl[0x4a * 0x70];
static Fl33aWorld g_w;
static Fl18Host g_host;
#define SELF g_r[0]
#define SELFP ((uintptr_t)SELF)

static void set32(uint8_t *b, size_t off, uint32_t v) { memcpy(b + off, &v, 4); }
static void set16(uint8_t *b, size_t off, uint16_t v) { memcpy(b + off, &v, 2); }
static uint32_t get32(const uint8_t *b, size_t off) { uint32_t v; memcpy(&v, b + off, 4); return v; }
static uint16_t get16(const uint8_t *b, size_t off) { uint16_t v; memcpy(&v, b + off, 2); return v; }

#define MAXCALL 64
static int g_local_pair;                        /* 0x4daeb5 stores g_cx, g_cy through its argument and returns the low 32 bits of that pointer, as the game's callee does */
static uint32_t g_cx, g_cy;
static uint32_t g_v1, g_v2;                     /* 0x4c4067 stores them at [desc+0x10] and [desc+0x24] */
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[8];
        uint8_t sp[0x40];        /* the first 0x40 bytes of self at the call */
        uint32_t flag61e3c8;     /* world->value_61e3c8 at the call */
    } c[MAXCALL];
} L;
static struct {
    uint32_t callee, results[16];
    int n, used;
} S[8];
static int g_nscript;
static void script1(uint32_t callee, uint32_t r0)
{
    S[g_nscript].callee = callee;
    S[g_nscript].n = 1;
    S[g_nscript].used = 0;
    S[g_nscript].results[0] = r0;
    g_nscript++;
}

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int k, i = L.n;
    uint32_t result = 0;
    (void)ctx;
    if (L.n < MAXCALL) {
        L.c[i].callee = callee;
        L.c[i].this_ptr = this_ptr;
        L.c[i].nargs = nargs;
        for (k = 0; k < nargs && k < 8; k++) L.c[i].a[k] = args[k];
        memcpy(L.c[i].sp, g_r[0], sizeof L.c[i].sp);
        L.c[i].flag61e3c8 = g_w.value_61e3c8;
    }
    L.n++;
    if (callee == 0x4c4067 && nargs == 5) {
        set32((uint8_t *)args[2], 0x10, g_v1);
        set32((uint8_t *)args[2], 0x24, g_v2);
    }
    if (callee == 0x4daeb5 && g_local_pair && nargs == 1) {
        uint32_t pair[2];
        pair[0] = g_cx;
        pair[1] = g_cy;
        memcpy((void *)args[0], pair, 8);
        return (uint32_t)args[0];
    }
    for (k = 0; k < g_nscript; k++)
        if (S[k].callee == callee && S[k].n > 0) {
            result = S[k].results[S[k].used < S[k].n ? S[k].used : S[k].n - 1];
            S[k].used++;
        }
    return result;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (a >= 0x552000u && a < 0x553000u) return g_str + (a - 0x552000u);
    if (a >= RVA(0) && a < RVA(8)) {
        uint32_t i = (a - RVA(0)) >> 16, off = (a - RVA(0)) & 0xffff;
        if (off < RSZ) return g_r[i] + off;
    }
    return NULL;
}

static void setup(void)
{
    size_t b, i;
    for (i = 0; i < 8; i++)
        for (b = 0; b < RSZ; b++) g_r[i][b] = (uint8_t)(b * 7 + 3 + i);
    for (b = 0; b < sizeof g_str; b++) g_str[b] = (uint8_t)(b * 5 + 1);
    memset(g_tbl, 0, sizeof g_tbl);
    memset(&g_w, 0, sizeof g_w);
    g_w.table_5d15a5 = g_tbl + 3 * 0x4a;
    g_w.table_5d1599 = g_r[5] + 0x400;              /* index 0 in the middle: slack for negative indices */
    g_w.table_5b3790 = g_r[6];
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    L.n = 0;
    g_nscript = 0;
    g_local_pair = 0;
    g_v1 = g_v2 = 0;
}

static void ck_call(int line, int idx, uint32_t callee, uintptr_t this_ptr, int nargs, const uintptr_t *want)
{
    int k;
    if (g_failed) return;
    if (idx >= L.n || idx >= MAXCALL || L.c[idx].callee != callee || L.c[idx].this_ptr != this_ptr || L.c[idx].nargs != nargs) {
        g_failed = 1;
        snprintf(g_msg, sizeof g_msg, "line %d: call %d is not %x this %lx nargs %d (log has %d)", line, idx, (unsigned)callee, (unsigned long)this_ptr, nargs, L.n);
        return;
    }
    for (k = 0; k < nargs; k++)
        if (L.c[idx].a[k] != want[k]) {
            g_failed = 1;
            snprintf(g_msg, sizeof g_msg, "line %d: call %d arg %d is %lx, want %lx", line, idx, k, (unsigned long)L.c[idx].a[k], (unsigned long)want[k]);
            return;
        }
}
#define CKC(idx, callee, thisp, nargs, ...)                        \
    do {                                                           \
        const uintptr_t w_[] = {__VA_ARGS__};                      \
        ck_call(__LINE__, (idx), (callee), (thisp), (nargs), w_);  \
    } while (0)
#define CKC0(idx, callee, thisp) ck_call(__LINE__, (idx), (callee), (thisp), 0, NULL)

/* ---- 0x4dae88 ------------------------------------------------------------------------------------------------------------------ */
static void test_m4dae88_set_cursor(void)
{
    uint8_t before[0x40];
    setup();
    memset(SELF, 0xaa, 0x40);
    memcpy(before, SELF, sizeof before);
    script1(0x52a488, 0xcafe0001u);
    CK(m4dae88_set_cursor(SELF, 0x11223344u, 0x55667788u, &g_host) == 0xcafe0001u);       /* returns the import's eax */
    CK(L.n == 1);
    CKC(0, 0x52a488, 0, 2, 0x11223344u, 0x55667788u);                                     /* x is the last pushed = args[0] */
    CK(get32(L.c[0].sp, 0x18) == 0x11223344u && get32(L.c[0].sp, 0x1c) == 0x55667788u);   /* the stores come first */
    CK(get32(SELF, 0x18) == 0x11223344u && get32(SELF, 0x1c) == 0x55667788u);
    CK(memcmp(SELF, before, 0x18) == 0 && memcmp(SELF + 0x20, before + 0x20, 0x20) == 0);
}

/* ---- 0x473117 ------------------------------------------------------------------------------------------------------------------ */
static uint8_t g_tbl0[sizeof g_tbl];
static void tbl_fill(void)
{
    memset(g_tbl, 0x55, sizeof g_tbl);
    memcpy(g_tbl0, g_tbl, sizeof g_tbl);
}
/* the table is unchanged except the dword at record i (relative to the world's index 0) = 1 (i = 99: unchanged altogether) */
static int tbl_is(int i)
{
    uint8_t want[sizeof g_tbl];
    memcpy(want, g_tbl0, sizeof want);
    if (i != 99) set32(want, (size_t)(3 + i) * 0x4a, 1);
    return memcmp(want, g_tbl, sizeof want) == 0;
}
static void test_m473117_mark_entry(void)
{
    setup();
    tbl_fill();
    memset(SELF, 0x33, 0x100);
    set32(SELF, 0x7a, 0);
    set16(SELF, 0x14, 3);
    m473117_mark_entry(SELF, &g_w);
    CK(tbl_is(99));                                 /* the gate dword [self+0x7a] == 0: nothing */
    set32(SELF, 0x7a, 0x10000u);                    /* non-zero with a zero low word is still non-zero (dword compare) */
    set16(SELF, 0x14, 0xffff);
    m473117_mark_entry(SELF, &g_w);
    CK(tbl_is(99));                                 /* word -1: nothing */
    set16(SELF, 0x14, 3);
    m473117_mark_entry(SELF, &g_w);
    CK(tbl_is(3));
    tbl_fill();
    set16(SELF, 0x14, 0xfffe);                      /* -2 is an index (sign-extended word), not the sentinel */
    set32(SELF, 0x16, 0xffffffffu);
    m473117_mark_entry(SELF, &g_w);
    CK(tbl_is(-2));
    tbl_fill();
    set16(SELF, 0x14, 0xfffd);
    m473117_mark_entry(SELF, &g_w);
    CK(tbl_is(-3));
    tbl_fill();
    set16(SELF, 0x14, 0);
    set32(SELF, 0x7a, 0x80000000u);
    m473117_mark_entry(SELF, &g_w);
    CK(tbl_is(0));
    CK(L.n == 0);
}

/* ---- 0x4234dd ------------------------------------------------------------------------------------------------------------------ */
static void test_m4234dd_push_pair(void)
{
    setup();
    memset(SELF, 0x11, 0x800);
    set32(SELF, 4, 5);                                              /* n = 5 < 0x80: no calls */
    m4234dd_push_pair(SELF, 0xaaaa0001u, 0xbbbb0002u, &g_w, &g_host);
    CK(L.n == 0);
    CK(get32(SELF, 0xc + 60) == 0xaaaa0001u && get32(SELF, 0x10 + 60) == 0xbbbb0002u && get32(SELF, 4) == 6);
    setup();
    memset(SELF, 0x11, 0x800);
    set32(SELF, 4, 0x80);                                           /* n = 0x80: the error report, dbg word 0 */
    m4234dd_push_pair(SELF, 0xaaaa0003u, 0xbbbb0004u, &g_w, &g_host);
    CK(L.n == 3);
    CKC(0, 0x50ca3e, 0, 2, 0x63888b, 0x5444cc);
    CKC(1, 0x52139c, 0, 3, 0x63888b, 0, 0);
    CKC0(2, 0x4c97b4, 0x5cf659);
    CK(get32(L.c[0].sp, 4) == 0x80 && get32(L.c[2].sp, 4) == 0x80);                         /* nothing is stored before the callees */
    CK(get32(SELF, 0xc + 0x600) == 0xaaaa0003u && get32(SELF, 0x10 + 0x600) == 0xbbbb0004u && get32(SELF, 4) == 0x81);
    setup();
    memset(SELF, 0x11, 0x800);
    g_w.word_63a4cd = (int16_t)0x8000;                              /* any non-zero word (word compare) */
    set32(SELF, 4, 0x81);
    m4234dd_push_pair(SELF, 1, 2, &g_w, &g_host);
    CK(L.n == 4);
    CKC(2, 0x44a2b7, 0, 1, 0x63888b);
    CKC0(3, 0x4c97b4, 0x5cf659);
    CK(get32(SELF, 0xc + 0x60c) == 1 && get32(SELF, 0x10 + 0x60c) == 2 && get32(SELF, 4) == 0x82);
    setup();
    memset(SELF, 0x11, 0x800);
    set32(SELF, 4, 0xffffffffu);                                    /* -1 < 0x80 (signed): no calls; the second store hits [self+4] itself */
    m4234dd_push_pair(SELF, 0xaaaa0005u, 0xbbbb0006u, &g_w, &g_host);
    CK(L.n == 0);
    CK(get32(SELF, 0) == 0xaaaa0005u && get32(SELF, 4) == 0xbbbb0007u);
    setup();
    memset(SELF, 0x11, 0x800);
    set32(SELF, 4, 0x80000000u);                                    /* negative, and 0x80000000 * 12 wraps to 0 */
    m4234dd_push_pair(SELF, 7, 8, &g_w, &g_host);
    CK(L.n == 0);
    CK(get32(SELF, 0xc) == 7 && get32(SELF, 0x10) == 8 && get32(SELF, 4) == 0x80000001u);
    setup();
    memset(SELF, 0x11, 0x800);
    set32(SELF, 4, 0x15555556u);                                    /* >= 0x80 and 0x15555556 * 12 wraps to 8 */
    m4234dd_push_pair(SELF, 9, 10, &g_w, &g_host);
    CK(L.n == 3);
    CK(get32(SELF, 8 + 0xc) == 9 && get32(SELF, 8 + 0x10) == 10 && get32(SELF, 4) == 0x15555557u);
}

/* ---- 0x4c7623 ------------------------------------------------------------------------------------------------------------------ */
static void test_m4c7623_draw_frame(void)
{
    uint32_t rect = RVA(1) + 0x10;
    int equal;
    for (equal = 0; equal < 2; equal++) {
        setup();
        set32(g_r[1], 0x10, 0x10);
        set32(g_r[1], 0x14, 0x20);
        set32(g_r[1], 0x18, 0x30);
        set32(g_r[1], 0x1c, 0x40);
        set32(SELF, 0xc, equal ? 0x1234u : 0x1235u);
        g_v1 = 0x111;
        g_v2 = 0x222;
        m4c7623_draw_frame(SELF, 0x1234, rect, 0xabcd1234u, &g_host);                        /* the word is the low half of the stack dword */
        CK(L.n == (equal ? 7 : 6));
        CKC(0, 0x4c4067, SELFP, 5, 0x1234, 0, L.c[0].a[2], 0x5553a8, 0x20);
        CK(L.c[0].a[2] > 0xffffffffu);                                                       /* the address of a local: a host pointer */
        CKC(1, 0x4c808f, SELFP, 7, 0x222, 0x111, 0x10, 0x20, 0x30, 0x20, 0x1234);
        CKC(2, 0x4c808f, SELFP, 7, 0x222, 0x111, 0x10, 0x40, 0x30, 0x40, 0x1234);
        CKC(3, 0x4c808f, SELFP, 7, 0x222, 0x111, 0x10, 0x20, 0x10, 0x40, 0x1234);
        CKC(4, 0x4c808f, SELFP, 7, 0x222, 0x111, 0x30, 0x20, 0x30, 0x40, 0x1234);
        CKC(5, 0x4c4202, SELFP, 3, 0x1234, rect, 0x5553d0);
        if (equal) CKC(6, 0x4c952f, SELFP, 1, rect);
    }
}

/* ---- 0x4bf3b8 ------------------------------------------------------------------------------------------------------------------ */
static void put_string(uint32_t va, const char *s)
{
    memcpy(g_str + (va - 0x552000u), s, strlen(s) + 1);
}
static void test_m4bf3b8_set_text(void)
{
    static const struct { int32_t field; uint32_t va; } copies[] = {{-4, 0x552508}, {-3, 0x5524e4}, {-2, 0x552494}, {-1, 0x5524bc}, {0, 0x552594}, {1, 0x552594}, {0x7fffffff, 0x552594},
                                                                      {-7, 0x552594}, {(int32_t)0x80000000, 0x552594}, {5, 0x552594}};
    static const char *texts[] = {"abcdefg", "abc", "a", "abcdefgh", ""};
    size_t k, t;
    for (k = 0; k < sizeof copies / sizeof copies[0]; k++)
        for (t = 0; t < sizeof texts / sizeof texts[0]; t++) {
            uint8_t before[0x400];
            size_t len = strlen(texts[t]) + 1;
            setup();
            memset(SELF, 0xee, 0x400);
            set32(SELF, 0x2c0, (uint32_t)copies[k].field);
            put_string(copies[k].va, texts[t]);
            memcpy(before, SELF, sizeof before);
            CK(m4bf3b8_set_text(SELF, 0x77, &g_host) == SELF + 0xc0);
            CK(L.n == 0);
            CK(memcmp(SELF + 0xc0, texts[t], len) == 0);                                      /* the string with its NUL */
            CK(memcmp(SELF, before, 0xc0) == 0 && memcmp(SELF + 0xc0 + len, before + 0xc0 + len, 0x400 - 0xc0 - len) == 0);
        }
    setup();
    memset(SELF, 0xee, 0x400);
    set32(SELF, 0x2c0, (uint32_t)-5);                                                         /* v = 1: sprintf(self + 0xc0, 0x552540, code) */
    CK(m4bf3b8_set_text(SELF, 0x12345678u, &g_host) == SELF + 0xc0);
    CK(L.n == 1);
    CKC(0, 0x50ca3e, 0, 3, (uintptr_t)(SELF + 0xc0), 0x552540, 0x12345678u);
    CK(SELF[0xc0] == 0xee);
    setup();
    memset(SELF, 0xee, 0x400);
    set32(SELF, 0x2c0, (uint32_t)-6);                                                         /* v = 0: _BinkGetError, then sprintf(self + 0xc0, 0x552564, error) */
    script1(0x52a514, 0xdead0001u);
    CK(m4bf3b8_set_text(SELF, 0x99, &g_host) == SELF + 0xc0);
    CK(L.n == 2);
    CKC0(0, 0x52a514, 0);
    CKC(1, 0x50ca3e, 0, 3, (uintptr_t)(SELF + 0xc0), 0x552564, 0xdead0001u);
}

/* ---- 0x4db993 ------------------------------------------------------------------------------------------------------------------ */
static void mv_setup(int32_t x, int32_t y, int local)
{
    setup();
    memset(SELF, 0x22, 0x100);
    g_w.value_5b377c = 0; g_w.value_5b3784 = 100; g_w.value_5b3780 = 0; g_w.value_5b3788 = 100;
    g_w.value_5d0377 = 0xd0377; g_w.value_571ad3 = 0x571ad3; g_w.value_5b44f4 = 0xffffffffu; g_w.value_5b44f0 = 0x77;
    g_w.value_583106 = 0x1111; g_w.value_58310e = 0x2222; g_w.value_583102 = 0x3333; g_w.value_58310a = 0x4444;
    set16(g_r[6], 4 * 8, 7);  set16(g_r[6], 4 * 8 + 2, 9);              /* index 4 */
    set16(g_r[6], 0x26 * 8, 3);  set16(g_r[6], 0x26 * 8 + 2, 5);        /* index 0x26 = 1 + 0x25 */
    set16(g_r[6], 0, 11);  set16(g_r[6], 2, 13);                        /* index 0 */
    set16(g_r[6], 0x23 * 8, 0xfffeu);  set16(g_r[6], 0x23 * 8 + 2, 0xfffd);   /* index 0x23 = -2 + 0x25: negative extents */
    if (local) {
        g_local_pair = 1;
        g_cx = (uint32_t)x;
        g_cy = (uint32_t)y;
    } else {
        set32(g_r[1], 0x10, (uint32_t)x);
        set32(g_r[1], 0x14, (uint32_t)y);
        script1(0x4daeb5, RVA(1) + 0x10);
    }
}
static void test_m4db993_move_cursor(void)
{
    int local;
    for (local = 0; local < 2; local++) {
        mv_setup(50, 60, local);                                      /* in range, word -1 */
        g_w.word_583a29 = -1;
        m4db993_move_cursor(SELF, 0x1357, 0x2468, &g_w, &g_host);
        CK(L.n == 2);
        CKC(0, 0x4dae88, 0x5830a6, 2, 0x1357, 0x2468);
        CK(L.c[1].callee == 0x4daeb5 && L.c[1].this_ptr == 0x5830a6 && L.c[1].nargs == 1 && L.c[1].a[0] > 0xffffffffu);
        CK(get32(SELF, 0x14) == 50 && get32(SELF, 0x18) == 60);
        CK(g_w.value_5c3a53 == 50 && g_w.value_5c3a57 == 60);
        CK(g_w.value_5b44f0 == 0 && g_w.value_5d162d == 0xd0377 && g_w.value_5b44f4 == 0);
        CK(get32(SELF, 0x28) == 0x1111 && get32(SELF, 0x30) == 0x2222 && get32(SELF, 0x24) == 0x3333 && get32(SELF, 0x2c) == 0x4444);     /* the old values */
        CK(g_w.value_583106 == 60 && g_w.value_58310e == 60 + 13 - 1 && g_w.value_583102 == 50 && g_w.value_58310a == 50 + 11 - 1);
        mv_setup(50, 60, local);                                      /* in range, word 1: index 0x26 */
        g_w.word_583a29 = 1;
        m4db993_move_cursor(SELF, 1, 2, &g_w, &g_host);
        CK(g_w.value_5b44f0 == 0x26 && g_w.value_5d162d == 0x571ad3);
        CK(g_w.value_58310e == 60 + 5 - 1 && g_w.value_58310a == 50 + 3 - 1);
        mv_setup(50, 60, local);                                      /* in range, word -2: index 0x23, negative extents */
        g_w.word_583a29 = -2;
        m4db993_move_cursor(SELF, 1, 2, &g_w, &g_host);
        CK(g_w.value_5b44f0 == 0x23);
        CK(g_w.value_58310e == 60u + (uint32_t)-3 - 1u && g_w.value_58310a == 50u + (uint32_t)-2 - 1u);
        {
            static const int32_t out[4][2] = {{-1, 60}, {101, 60}, {50, -1}, {50, 101}};     /* each bound, one beyond (signed compares) */
            int o;
            for (o = 0; o < 4; o++) {
                mv_setup(out[o][0], out[o][1], local);
                g_w.word_583a29 = 1;
                m4db993_move_cursor(SELF, 1, 2, &g_w, &g_host);
                CK(g_w.value_5b44f0 == 4 && g_w.value_5d162d == 0xd0377);
                CK(g_w.value_58310e == (uint32_t)out[o][1] + 9u - 1u && g_w.value_58310a == (uint32_t)out[o][0] + 7u - 1u);       /* index 4 */
            }
        }
        {
            static const int32_t edge[4][2] = {{0, 60}, {100, 60}, {50, 0}, {50, 100}};      /* the bounds themselves are in range */
            int o;
            for (o = 0; o < 4; o++) {
                mv_setup(edge[o][0], edge[o][1], local);
                g_w.word_583a29 = -1;
                m4db993_move_cursor(SELF, 1, 2, &g_w, &g_host);
                CK(g_w.value_5b44f0 == 0);
            }
        }
    }
}

/* ---- 0x47d24e ------------------------------------------------------------------------------------------------------------------ */
static void rep_setup(uint32_t gate, uint32_t flag, int bytev, int32_t count, uint32_t page, int16_t word)
{
    setup();
    g_w.value_61e3a4 = RVA(1);
    g_w.value_61e3ac = RVA(2) + 0x20;
    g_w.value_61e3bc = gate;
    g_w.value_61e3c8 = flag;
    g_w.value_61e618 = (uint32_t)count;
    g_w.value_61e624 = page;
    g_w.value_5cf665 = 0x5cf665u ^ 0x1111;
    g_w.value_5d15e3 = 0x5d15e3u ^ 0x2222;
    g_w.word_61e39c = word;
    memset(g_r[1], 0, 0x600);
    g_r[1][0x35b] = (uint8_t)bytev;
    set32(g_r[5] + 0x400 + (ptrdiff_t)word * 0x4a, 0, 0x7ab1e000u + (uint32_t)(int)word);
}
static void test_m47d24e_report_fields(void)
{
    uint32_t p = RVA(1), t = 0x7ab1e000u + 2;
    rep_setup(0, 1, 1, 2, 1, 2);                                    /* the gate dword is zero: nothing at all */
    m47d24e_report_fields(&g_w, &g_host);
    CK(L.n == 0 && g_w.value_61e3c8 == 1);
    rep_setup(0x10000, 1, 0x80, 2, 1, 2);                           /* everything: the flag, the byte (negative), two entries */
    set32(g_r[2], 0x20 + 2 * 12, 3);
    set32(g_r[2], 0x20 + 2 * 12 + 4, 1);                            /* entry 2 (base 1 * 2 + 0): flag == 1 */
    set32(g_r[2], 0x20 + 3 * 12, 4);
    set32(g_r[2], 0x20 + 3 * 12 + 4, 0x10001);                      /* entry 3: not 1 (dword compare) */
    m47d24e_report_fields(&g_w, &g_host);
    CK(L.n == 4);
    CKC(0, 0x4c5377, 0x5cf659, 5, 0x5d15e3u ^ 0x2222, 0x5cf665u ^ 0x1111, 0x583196, 0x61e5f4, 0x54d1a0);
    CK(L.c[0].flag61e3c8 == 1 && g_w.value_61e3c8 == 0);            /* cleared after the call */
    CKC(1, 0x4c5377, 0x5cf659, 5, t, 0x5cf665u ^ 0x1111, p + (1u << 4) + 0xe1, 0x61e554, 0x54d1c8);
    CKC(2, 0x4c5377, 0x5cf659, 5, t, 0x5cf665u ^ 0x1111, p + (3u << 4) + 0x21, 0x61e3d4, 0x54d1e4);
    CKC(3, 0x4c5377, 0x5cf659, 5, 0x5d15e3u ^ 0x2222, 0x5cf665u ^ 0x1111, p + (1u << 4) + 0x111, 0x61e3d4 + 16, 0x54d20c);
    rep_setup(1, 0, 0, 0, 0, 0);                                    /* nothing to report */
    m47d24e_report_fields(&g_w, &g_host);
    CK(L.n == 0);
    rep_setup(1, 0, 0, -1, 0, 0);                                   /* a negative count (signed compare) */
    m47d24e_report_fields(&g_w, &g_host);
    CK(L.n == 0);
    rep_setup(1, 0, 1, 1, 0xffffffffu, -1);                         /* page -1: base = -1, the entry before the first; table index -1 */
    set32(g_r[2], 0x20 - 12 + 4, 1);
    set32(g_r[2], 0x20 - 12, 5);
    m47d24e_report_fields(&g_w, &g_host);
    CK(L.n == 2);
    CKC(0, 0x4c5377, 0x5cf659, 5, 0x7ab1e000u + 0xffffffffu, 0x5cf665u ^ 0x1111, p + (0xffffffffu << 4) + 0xe1, 0x61e554, 0x54d1c8);
    CKC(1, 0x4c5377, 0x5cf659, 5, 0x7ab1e000u + 0xffffffffu, 0x5cf665u ^ 0x1111, p + (5u << 4) + 0x21, 0x61e3d4, 0x54d1e4);
}

/* ---- 0x4c7070 ------------------------------------------------------------------------------------------------------------------ */
static void rot_setup(int32_t w1, int32_t w2, int32_t w3, int16_t bpp, uint32_t size)
{
    uint8_t *d;
    setup();
    d = g_r[1] + 0x11;
    memset(g_r[1], 0, 0x100);
    set32(d, 0, RVA(2) + 0x21);
    set32(d, 0x23, size);
    set16(d, 0x2b, (uint16_t)w1);
    set16(d, 0x2d, (uint16_t)w2);
    set16(d, 0x2f, (uint16_t)w3);
    set16(d, 0x31, 0x7777);
    g_w.word_639895 = bpp;
    script1(0x51dc43, RVA(3) + 0x200);
}
static void test_m4c7070_rotate_image(void)
{
    uint8_t *img = g_r[2] + 0x21, *buf;
    uint8_t *d = g_r[1] + 0x11;
    int j, i;
    uint16_t want[6];
    uint8_t tail[6];
    rot_setup(2, 3, 6, 2, 18);                                      /* 2 columns, 3 rows of words, row stride 6 bytes, 2 bytes per column */
    buf = g_r[3] + 0x200;
    memset(buf, 0x5a, 0x40);
    for (j = 0; j < 3; j++)
        for (i = 0; i < 2; i++) set16(img, (size_t)(j * 6 + i * 2), (uint16_t)(0x1000 * (j + 1) + 0x10 * i + 1));
    memcpy(tail, img + 12, sizeof tail);
    m4c7070_rotate_image(SELF, RVA(1) + 0x11, 0xfeed, &g_w, &g_host);
    want[0] = 0x3001; want[1] = 0x2001; want[2] = 0x1001; want[3] = 0x3011; want[4] = 0x2011; want[5] = 0x1011;       /* column by column, last row first */
    CK(memcmp(img, want, 12) == 0);
    CK(memcmp(img + 12, tail, sizeof tail) == 0);                                          /* nothing beyond the rotated words changes */
    CK(get16(d, 0x2b) == 3 && get16(d, 0x2d) == 2 && get16(d, 0x2f) == 6 && get16(d, 0x31) == 2);
    CK(memcmp(buf + 18, "\x5a\x5a\x5a\x5a", 4) == 0);                 /* the copy is exactly `size` bytes */
    CK(get16(buf, 0) == 0x1001 && get16(buf, 14) == 0x3011);
    CK(L.n == 2);
    CKC(0, 0x51dc43, 0, 1, 18);
    CKC(1, 0x51dc6c, 0, 1, RVA(3) + 0x200);
    rot_setup(1, 1, 2, 2, 3);                                        /* a size below four bytes: bytes only */
    buf = g_r[3] + 0x200;
    memset(buf, 0x5a, 0x10);
    memset(img, 0x61, 8);
    m4c7070_rotate_image(SELF, RVA(1) + 0x11, 0, &g_w, &g_host);
    CK(buf[0] == 0x61 && buf[2] == 0x61 && buf[3] == 0x5a);
    rot_setup(-1, 2, 4, 2, 4);                                       /* w1 negative: no pass; w2 is still stored, and the product too */
    memset(img, 0x61, 8);
    m4c7070_rotate_image(SELF, RVA(1) + 0x11, 0, &g_w, &g_host);
    CK(img[0] == 0x61 && get16(d, 0x2b) == 2 && get16(d, 0x2d) == 0xffff && get16(d, 0x2f) == 4 && get16(d, 0x31) == 0xffff);
    rot_setup(2, 2, 4, -2, 8);                                       /* negative column step: the product is -4 as a word */
    m4c7070_rotate_image(SELF, RVA(1) + 0x11, 0, &g_w, &g_host);
    CK(get16(d, 0x2f) == 0xfffc);
    rot_setup(2, 3, 6, 2, 0x13);                                     /* the allocator fails: the report and 0x4c97b4(this), nothing else */
    g_nscript = 0;
    script1(0x51dc43, 0);
    memset(img, 0x61, 0x20);
    memcpy(g_r[4], d, 0x40);
    m4c7070_rotate_image(SELF, RVA(1) + 0x11, 0xfeedbeefu, &g_w, &g_host);
    CK(L.n == 3);
    CKC(0, 0x51dc43, 0, 1, 0x13);
    CKC(1, 0x42639d, 0x583979, 2, 0x5552e8, 0xfeedbeefu);
    CKC0(2, 0x4c97b4, SELFP);
    CK(memcmp(g_r[4], d, 0x40) == 0 && img[0] == 0x61);
}

/* CASES-END */

/* ---- bounded sweep ------------------------------------------------------------------------------------------------------------- */
static void test_sweep_bounded(void)
{
    unsigned seed = 4242;
    int n, i;
    for (n = 0; n < 300 && !g_failed; n++) {
        setup();
        for (i = 0; i < RSZ; i++) {
            seed = seed * 1103515245u + 12345u;
            g_r[0][i] = (uint8_t)(seed >> 16);
        }
        seed = seed * 1103515245u + 12345u;
        /* 0x4dae88, 0x473117 (the index is kept inside the table: -3 .. 0x6b) */
        m4dae88_set_cursor(SELF, seed, seed >> 3, &g_host);
        set16(SELF, 0x14, (uint16_t)((int)(seed % 0x70) - 3));
        m473117_mark_entry(SELF, &g_w);
        /* 0x4234dd: n kept in -1 .. 0x90 (the object is 0x4000 bytes) */
        set32(SELF, 4, (uint32_t)((int)(seed % 0x92) - 1));
        m4234dd_push_pair(SELF, seed, seed >> 1, &g_w, &g_host);
        /* 0x4bf3b8 */
        set32(SELF, 0x2c0, (uint32_t)((int)(seed % 12) - 8));
        for (i = 0; i < 4; i++) g_str[(i + 1) * 0x40 + 3 + (seed % 7)] = 0;
        m4bf3b8_set_text(SELF, seed, &g_host);
        /* 0x4c7623 */
        set32(g_r[1], 0, seed);
        set32(g_r[1], 4, seed >> 1);
        set32(g_r[1], 8, seed >> 2);
        set32(g_r[1], 12, seed >> 3);
        m4c7623_draw_frame(SELF, seed, RVA(1), seed >> 4, &g_host);
        /* 0x4db993: the table has 8 bytes per index; keep the index inside g_r[6] */
        g_local_pair = 1;
        g_cx = seed;
        g_cy = seed >> 5;
        g_w.value_5b377c = seed >> 9;
        g_w.value_5b3784 = seed >> 3;
        g_w.word_583a29 = (int16_t)(seed % 9) - 4;
        m4db993_move_cursor(SELF, seed, seed, &g_w, &g_host);
        g_local_pair = 0;
        /* 0x47d24e */
        g_w.value_61e3a4 = RVA(1);
        g_w.value_61e3ac = RVA(2) + 0x400;
        g_w.value_61e3bc = seed | 1;
        g_w.value_61e3c8 = seed & 1;
        g_w.value_61e618 = seed % 5;
        g_w.value_61e624 = seed % 3;
        g_w.word_61e39c = (int16_t)(seed % 7);
        g_w.table_5d1599 = g_r[5] + 0x100;
        m47d24e_report_fields(&g_w, &g_host);
        /* 0x4c7070: a 4x3 image of words inside region 2 */
        g_w.word_639895 = 2;
        set32(g_r[1], 0x10, RVA(2) + 0x40);
        set32(g_r[1], 0x10 + 0x23, 24);
        set16(g_r[1], 0x10 + 0x2b, (uint16_t)(seed % 4));
        set16(g_r[1], 0x10 + 0x2d, (uint16_t)(seed % 3 + 1));
        set16(g_r[1], 0x10 + 0x2f, 8);
        g_nscript = 0;
        script1(0x51dc43, RVA(3) + 0x40);
        m4c7070_rotate_image(SELF, RVA(1) + 0x10, seed, &g_w, &g_host);
        L.n = 0;
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
    RUN(test_m4dae88_set_cursor);
    RUN(test_m473117_mark_entry);
    RUN(test_m4234dd_push_pair);
    RUN(test_m4c7623_draw_frame);
    RUN(test_m4bf3b8_set_text);
    RUN(test_m4db993_move_cursor);
    RUN(test_m47d24e_report_fields);
    RUN(test_m4c7070_rotate_image);
    /* RUN-END */
    RUN(test_sweep_bounded);
    return failures;
}
