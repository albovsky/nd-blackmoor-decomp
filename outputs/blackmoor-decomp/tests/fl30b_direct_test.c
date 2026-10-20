/* FL-30 (batch b) direct tests of the methods of GAME.EXE in src/original_methods_fl30b.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl30b_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl30b.h"

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

/* host memory: region i lives at the original address RVA(i); region 0 is `self` */
#define RVA(i) (0x20000000u + 0x10000u * (uint32_t)(i))
#define RSZ 0x4000
static uint8_t g_r[8][RSZ];
static uint8_t g_recs[0x8d * 8], g_tab[0xa0];
static Fl30bWorld g_w;
static Fl18Host g_host;
#define SELF g_r[0]

static void set32(uint8_t *b, size_t off, uint32_t v) { memcpy(b + off, &v, 4); }
static void set16(uint8_t *b, size_t off, uint16_t v) { memcpy(b + off, &v, 2); }
static __attribute__((unused)) uint32_t get32(const uint8_t *b, size_t off) { uint32_t v; memcpy(&v, b + off, 4); return v; }
static uint16_t get16(const uint8_t *b, size_t off) { uint16_t v; memcpy(&v, b + off, 2); return v; }

#define MAXCALL 64
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[12];
        uint8_t probe[16];       /* the first 16 bytes of region 4 at the call */
    } c[MAXCALL];
} L;
static struct {
    uint32_t callee, results[8];
    int n, used;
} S[4];
static int g_nscript;
static __attribute__((unused)) void script(uint32_t callee, int n, uint32_t r0, uint32_t r1, uint32_t r2, uint32_t r3)
{
    S[g_nscript].callee = callee;
    S[g_nscript].n = n;
    S[g_nscript].used = 0;
    S[g_nscript].results[0] = r0;
    S[g_nscript].results[1] = r1;
    S[g_nscript].results[2] = r2;
    S[g_nscript].results[3] = r3;
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
        for (k = 0; k < nargs && k < 12; k++) L.c[i].a[k] = args[k];
        memcpy(L.c[i].probe, g_r[4], 16);
    }
    L.n++;
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
    memset(g_recs, 0, sizeof g_recs);
    memset(g_tab, 0, sizeof g_tab);
    memset(&g_w, 0, sizeof g_w);
    g_w.records_5bb5e5 = g_recs + 2 * 0x8d;       /* two records of slack below for a negative index */
    g_w.words_58c959 = g_tab + 0x3c;
    g_w.floats_58c91d = g_tab;
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    L.n = 0;
    g_nscript = 0;
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
#define SELFP ((uintptr_t)SELF)

/* ---- 0x44b26a ------------------------------------------------------------------------------------------------------------------ */
static void rec44(int slot, uint32_t item_va) { set32(g_w.records_5bb5e5 + (ptrdiff_t)slot * 0x8d, 0, item_va); }
static void test_m44b26a_apply_delta(void)
{
    uint8_t *item = g_r[1];
    float f;
    setup();
    /* kind above 0x27: nothing but the final call; with the debug word the two reports first */
    rec44(2, RVA(1));
    item[0] = 0x28;
    m44b26a_apply_delta(2, &g_w, &g_host);
    CK(L.n == 1);
    CKC(0, 0x42ba3a, 0, 1, 2);
    setup();
    rec44(-1, RVA(1));
    item[0] = 0xc3;
    g_w.word_63a4cd = 0x100;
    m44b26a_apply_delta(0xfffe0000u | 0xffff, &g_w, &g_host);
    CK(L.n == 3);
    CKC(0, 0x50ca3e, 0, 3, 0x63888b, 0x549028, 0xc3);
    CKC(1, 0x52139c, 0, 3, 0x63888b, 0, 0);
    CKC(2, 0x42ba3a, 0, 1, 0xffff);
    /* kind 0x1d, flag 0: word 0x1111 + delta 0x2222 */
    setup();
    rec44(1, RVA(1));
    item[0] = 0x1d;
    item[1] = 0;
    set16(item, 2, 0x2222);
    set16(g_w.words_58c959, 0x1d * 2, 0x1111);
    m44b26a_apply_delta(1, &g_w, &g_host);
    CK(get16(g_w.words_58c959, 0x1d * 2) == 0x3333);
    CK(L.n == 1);
    /* the 16-bit wrap */
    set16(g_w.words_58c959, 0x1d * 2, 0xffff);
    set16(item, 2, 3);
    m44b26a_apply_delta(1, &g_w, &g_host);
    CK(get16(g_w.words_58c959, 0x1d * 2) == 2);
    /* the sentinel 0x270f is replaced, not added to */
    set16(g_w.words_58c959, 0x1d * 2, 0x270f);
    set16(item, 2, 0x10);
    m44b26a_apply_delta(1, &g_w, &g_host);
    CK(get16(g_w.words_58c959, 0x1d * 2) == 0x10);
    /* a non-zero flag replaces */
    item[1] = 0xff;
    set16(g_w.words_58c959, 0 * 2, 0x0101);
    item[0] = 0;
    set16(item, 2, 0x8001);
    m44b26a_apply_delta(1, &g_w, &g_host);
    CK(get16(g_w.words_58c959, 0) == 0x8001);
    /* floats: 0x1e + 0, delta -3 added to 10.0; 9999.0 is replaced; a non-zero flag replaces */
    item[0] = 0x1e;
    item[1] = 0;
    set16(item, 2, (uint16_t)-3);
    f = 10.0f;
    memcpy(g_w.floats_58c91d + 0x1e * 4, &f, 4);
    m44b26a_apply_delta(1, &g_w, &g_host);
    memcpy(&f, g_w.floats_58c91d + 0x1e * 4, 4);
    CK(f == 7.0f);
    f = 9999.0f;
    memcpy(g_w.floats_58c91d + 0x1e * 4, &f, 4);
    m44b26a_apply_delta(1, &g_w, &g_host);
    memcpy(&f, g_w.floats_58c91d + 0x1e * 4, 4);
    CK(f == -3.0f);
    item[1] = 1;
    item[0] = 0x27;
    set16(item, 2, 0x8000);
    f = 5.0f;
    memcpy(g_w.floats_58c91d + 0x27 * 4, &f, 4);
    m44b26a_apply_delta(1, &g_w, &g_host);
    memcpy(&f, g_w.floats_58c91d + 0x27 * 4, 4);
    CK(f == -32768.0f);
    /* NaN (unordered) takes the plain store as well */
    item[1] = 0;
    f = 0.0f / (volatile float)0.0f;
    memcpy(g_w.floats_58c91d + 0x27 * 4, &f, 4);
    set16(item, 2, 7);
    m44b26a_apply_delta(1, &g_w, &g_host);
    memcpy(&f, g_w.floats_58c91d + 0x27 * 4, 4);
    CK(f == 7.0f);
}

/* ---- 0x488e9c ------------------------------------------------------------------------------------------------------------------ */
static void init488(int mode_d2, int n, int m, int dbg)
{
    uint8_t *q = g_r[2];
    size_t i;
    setup();
    for (i = 0; i < 0x1000; i++) q[i] = (uint8_t)(i * 5 + 1);
    if (mode_d2) {
        set16(q, 0x29, 2);
        set16(q, 0x33, 3);
        set16(q, 0x35, (uint16_t)(3 + n - 1));
        set16(q, 0x2b, 0x7777);
    } else {
        set16(q, 0x29, 0x102);
        set16(q, 0x2b, (uint16_t)n);
        set16(q, 0x33, 3);
        set16(q, 0x35, 0x40);
    }
    set16(q, 0xaa, (uint16_t)m);
    set32(g_r[1], 4, RVA(2));
    set32(g_r[1], 8, 0x1000);
    set32(SELF, 0x1c, 0xaaaaaaaau);
    set32(SELF, 0x20, 0xbbbbbbbbu);
    g_w.word_63a4cd = (int16_t)dbg;
    script(0x51dc43, 1, RVA(3), 0, 0, 0);
}
static int run488(void) { return m488e9c_init_record(SELF, RVA(1), RVA(1) + 4, RVA(1) + 8, &g_w, &g_host); }
static void test_m488e9c_init_record(void)
{
    uint8_t *q = g_r[2], *buf = g_r[3];
    /* d == 2: n = 6 - 3 + 1 = 4 (64 bytes), m = 2 (76 bytes) */
    init488(1, 4, 2, 0);
    CK(run488() == 0);
    CK(get32(g_r[1], 0) == RVA(3) && get32(SELF, 0x1c) == RVA(3) && get32(SELF, 0x20) == RVA(3));
    CK(memcmp(buf, q, 0xac) == 0);
    CK(memcmp(buf + 0xac, q + 0xac, 64) == 0);
    CK(memcmp(buf + 0x6ec, q + 0xac + 64, 76) == 0);
    CK(get32(g_r[1], 4) == RVA(2) + 0xac + 64 + 76 && get32(g_r[1], 8) == 0x1000 + 0xac + 64 + 76);
    CK(L.n == 1);
    CKC(0, 0x51dc43, 0, 1, 0xaba);
    /* d != 2 (0x102 has the low byte 2 only): n = word [+0x2b] = 3; the trace call follows when the debug word is set */
    init488(0, 3, 1, 0x100);
    CK(run488() == 0);
    CK(memcmp(buf + 0xac, q + 0xac, 48) == 0);
    CK(memcmp(buf + 0x6ec, q + 0xac + 48, 38) == 0);
    CK(get32(g_r[1], 4) == RVA(2) + 0xac + 48 + 38 && get32(g_r[1], 8) == 0x1000 + 0xac + 48 + 38);
    CK(L.n == 2);
    CKC(1, 0x44a2b7, 0, 1, 0x54dfa0);
    /* the largest accepted n and m */
    init488(0, 0xa0, 25, 0);
    CK(run488() == 0);
    CK(memcmp(buf + 0xac, q + 0xac, 0x640) == 0);        /* the second copy overwrites the rest of the first one */
    CK(memcmp(buf + 0x6ec, q + 0xac + 0xa00, 25 * 38) == 0);
    /* allocation failure: the report, then the native rejection with nothing else touched */
    init488(1, 4, 2, 0x100);
    g_nscript = 0;
    script(0x51dc43, 1, 0, 0, 0, 0);
    g_w.value_5bb57b = 0x1234abcdu;
    g_w.word_5c39e3 = -1;
    CK(run488() == 1);
    CK(L.n == 4);
    CKC(0, 0x51dc43, 0, 1, 0xaba);
    CKC(1, 0x50ca3e, 0, 4, 0x63888b, 0x54df58, 0x1234abcdu, 0xffffffffu);
    CKC(2, 0x42639d, 0x583979, 2, 0x54df84, 0x63888b);
    CKC0(3, 0x4c97b4, 0x5cf659);
    CK(get32(g_r[1], 0) == 0 && get32(g_r[1], 4) == RVA(2) && get32(SELF, 0x1c) == 0xaaaaaaaau && get32(SELF, 0x20) == 0xbbbbbbbbu);
    /* native rejections: a negative count, a count that overruns the 0xaba bytes (first copy: 0xa1 * 16; second copy: 26 * 0x26) */
    init488(0, -2, 0, 0);
    memset(buf, 0x5a, 0x400);
    CK(run488() == 1);
    CK(buf[0xac] == 0x5a && get32(g_r[1], 4) == RVA(2) + 0xac && L.n == 1);
    init488(0, 0xa1, 0, 0);
    memset(buf, 0x5a, 0x400);
    CK(run488() == 1);
    CK(buf[0xac] == 0x5a && get32(g_r[1], 4) == RVA(2) + 0xac);
    init488(0, 2, -1, 0);
    memset(buf + 0x6ec, 0x5a, 0x40);
    CK(run488() == 1);
    CK(buf[0x6ec] == 0x5a && get32(g_r[1], 4) == RVA(2) + 0xac + 32);
    init488(0, 2, 26, 0);
    memset(buf + 0x6ec, 0x5a, 0x40);
    CK(run488() == 1);
    CK(buf[0x6ec] == 0x5a);
}

/* ---- 0x4c5b3a ------------------------------------------------------------------------------------------------------------------ */
/* surfaces: from = RVA(1) (pixels RVA(5) + 0x100, pitch 0x10), to = RVA(2) (pixels RVA(6) + 0x100, pitch 0x20), rectangles RVA(3), RVA(4) */
static void copy5b(int bpp, int dbg, const uint32_t fr[4], const uint32_t tr[4])
{
    int i;
    setup();
    for (i = 0; i < 0x400; i++) {
        g_r[5][i] = (uint8_t)(i * 3 + 1);
        g_r[6][i] = 0xee;
    }
    set16(SELF, 0x38d0, 0x4444);
    set32(g_r[1], 0, RVA(5) + 0x100);
    set16(g_r[1], 0x2f, 0x10);
    set32(g_r[2], 0, RVA(6) + 0x100);
    set16(g_r[2], 0x2f, 0x20);
    for (i = 0; i < 4; i++) {
        set32(g_r[3], (size_t)i * 4, fr[i]);
        set32(g_r[4], (size_t)i * 4, tr[i]);
    }
    g_w.word_639895 = (int16_t)bpp;
    g_w.word_63a4cd = (int16_t)dbg;
}
static void test_m4c5b3a_copy_keyed(void)
{
    const uint32_t fr[4] = {1, 2, 3, 3}, tr[4] = {2, 1, 4, 2};      /* 3 words wide, 2 rows */
    const uint32_t fr_bad[4] = {1, 2, 3, 3}, tr_bad[4] = {2, 1, 5, 2};
    int row, k;
    copy5b(2, 0, fr, tr);
    set16(g_r[5], 0x100 + 2 * 0x10 + 2 + 2, 0x4444);                   /* the second word of the first row carries the key: not copied */
    CK(m4c5b3a_copy_keyed(SELF, RVA(1), RVA(2), RVA(3), RVA(4), 7, &g_w, &g_host) == 0);
    CK(L.n == 0);
    for (row = 0; row < 2; row++)
        for (k = 0; k < 3; k++) {
            size_t src = 0x100 + (size_t)(2 + row) * 0x10 + (size_t)(1 + k) * 2, dst = 0x100 + (size_t)(1 + row) * 0x20 + (size_t)(2 + k) * 2;
            if (row == 0 && k == 1) CK(get16(g_r[6], dst) == 0xeeee);
            else CK(get16(g_r[6], dst) == get16(g_r[5], src));
        }
    CK(get16(g_r[6], 0x100) == 0xeeee && get16(g_r[6], 0x100 + 0x20 + 0xa) == 0xeeee && get16(g_r[6], 0x100 + 3 * 0x20) == 0xeeee);
    /* debug flag on, equal sizes, both surfaces: the copy as before and no call */
    copy5b(2, 1, fr, tr);
    CK(m4c5b3a_copy_keyed(SELF, RVA(1), RVA(2), RVA(3), RVA(4), 7, &g_w, &g_host) == 0);
    CK(L.n == 0 && get16(g_r[6], 0x124) == get16(g_r[5], 0x122));
    /* debug flag on, sizes differ: the report with the 11 arguments, then 0x52139c and 0x4c97b4, and no copy */
    copy5b(2, 0x100, fr_bad, tr_bad);
    CK(m4c5b3a_copy_keyed(SELF, RVA(1), RVA(2), RVA(3), RVA(4), 0x99, &g_w, &g_host) == 0);
    CK(L.n == 3);
    CK(L.c[0].callee == 0x50ca3e && L.c[0].nargs == 11 && L.c[0].a[1] == 0x554be8 && L.c[0].a[2] == 0x99);
    CK(L.c[0].a[3] == 1 && L.c[0].a[4] == 2 && L.c[0].a[5] == 3 && L.c[0].a[6] == 3 && L.c[0].a[7] == 2 && L.c[0].a[8] == 1 && L.c[0].a[9] == 5 && L.c[0].a[10] == 2);
    CK(L.c[1].callee == 0x52139c && L.c[1].nargs == 3 && L.c[1].a[0] == L.c[0].a[0] && L.c[1].a[1] == 0 && L.c[1].a[2] == 0);
    CKC0(2, 0x4c97b4, SELFP);
    CK(get16(g_r[6], 0x100 + 0x20 + 4) == 0xeeee);
    /* debug flag on and a null surface with equal sizes: the report, no copy (and no rejection) */
    copy5b(2, 1, fr, tr);
    CK(m4c5b3a_copy_keyed(SELF, 0, RVA(2), RVA(3), RVA(4), 1, &g_w, &g_host) == 0 && L.n == 3);
    copy5b(2, 1, fr, tr);
    CK(m4c5b3a_copy_keyed(SELF, RVA(1), 0, RVA(3), RVA(4), 1, &g_w, &g_host) == 0 && L.n == 3);
    /* debug flag off and a null surface: the native rejection with nothing done */
    copy5b(2, 0, fr, tr);
    CK(m4c5b3a_copy_keyed(SELF, 0, RVA(2), RVA(3), RVA(4), 1, &g_w, &g_host) == 1 && L.n == 0 && get16(g_r[6], 0x100 + 0x20 + 4) == 0xeeee);
    copy5b(2, 0, fr, tr);
    CK(m4c5b3a_copy_keyed(SELF, RVA(1), 0, RVA(3), RVA(4), 1, &g_w, &g_host) == 1 && L.n == 0);
    /* bpp 1, 3 words wide = 3 bytes: two word moves, the second one ends one byte behind the row; zero and negative sizes copy nothing */
    {
        const uint32_t fr1[4] = {0, 0, 2, 0}, tr1[4] = {0, 0, 2, 0}, none[4] = {2, 0, 1, 0}, neg[4] = {0, 3, 0, 1};
        copy5b(1, 0, fr1, tr1);
        CK(m4c5b3a_copy_keyed(SELF, RVA(1), RVA(2), RVA(3), RVA(4), 1, &g_w, &g_host) == 0);
        CK(get16(g_r[6], 0x100) == get16(g_r[5], 0x100) && get16(g_r[6], 0x102) == get16(g_r[5], 0x102) && get16(g_r[6], 0x104) == 0xeeee);
        copy5b(2, 0, none, tr1);
        CK(m4c5b3a_copy_keyed(SELF, RVA(1), RVA(2), RVA(3), RVA(4), 1, &g_w, &g_host) == 0 && get16(g_r[6], 0x100) == 0xeeee);
        copy5b(2, 0, neg, tr1);
        CK(m4c5b3a_copy_keyed(SELF, RVA(1), RVA(2), RVA(3), RVA(4), 1, &g_w, &g_host) == 0 && get16(g_r[6], 0x100) == 0xeeee);
    }
}

/* ---- 0x42e844 ------------------------------------------------------------------------------------------------------------------ */
static uint8_t g_dt[80];
static void step42(int slot, uint32_t state)
{
    size_t i;
    setup();
    for (i = 0; i < sizeof g_dt; i++) g_dt[i] = (uint8_t)(i + 1);
    g_w.dwords_585801 = g_dt + 32;
    rec44(slot, RVA(1));
    set32(g_w.records_5bb5e5 + (ptrdiff_t)slot * 0x8d, 0x4d, state);
    memset(g_r[1], 0, 0x100);
}
static void test_m42e844_step_record(void)
{
    uint8_t *r, *p = g_r[1];
    int i;
    /* state 0: the global is set, the state becomes 1, the second entry matches the key 0x1234 */
    step42(2, 0);
    g_w.word_5bb50b = 0x1234;
    set16(p, 0x28, 3);
    set16(p, 0x2a, 0x1233);
    set16(p, 0x12 + 0x2a, 0x1234);
    set16(p, 0x12 + 0x2c, 0x1111);
    set16(p, 0x12 + 0x30, 0x2222);
    set16(p, 0x12 + 0x34, 0x3333);
    set16(p, 0x12 + 0x38, 0x4444);
    set16(p, 0x24 + 0x2a, 0x1234);
    r = g_w.records_5bb5e5 + 2 * 0x8d;
    set32(r, 0x41, 0x77777777u);
    m42e844_step_record(2, &g_w, &g_host);
    CK(g_w.value_5bb1ca == 1 && get32(r, 0x4d) == 1 && get32(r, 0x41) == 1);
    CK(get16(r, 0x45) == 0x1111 && get16(r, 0x47) == 0x2222 && get16(r, 0x49) == 0x3333 && get16(r, 0x4b) == 0x4444);
    CK(L.n == 0);
    /* state 1, no match: found flag 0 and the words untouched; a count of 0 or a negative count does not loop */
    step42(-1, 1);
    g_w.word_5bb50b = 7;
    set16(p, 0x28, 2);
    r = g_w.records_5bb5e5 - 0x8d;
    set32(r, 0x41, 0x77777777u);
    set16(r, 0x45, 0x5555);
    m42e844_step_record(0xffffu, &g_w, &g_host);
    CK(g_w.value_5bb1ca == 0 && get32(r, 0x41) == 0 && get16(r, 0x45) == 0x5555 && get32(r, 0x4d) == 1);
    set16(p, 0x28, 0xffff);
    set16(p, 0x2a, 7);
    set32(r, 0x41, 9);
    m42e844_step_record(0xffffu, &g_w, &g_host);
    CK(get32(r, 0x41) == 0 && get16(r, 0x45) == 0x5555);
    /* state 2: byte flag, dword 0, the pairs (a, v) with a != -1 go to the dword table, the sign extended; then the final call */
    step42(1, 2);
    r = g_w.records_5bb5e5 + 0x8d;
    set32(r, 0x41, 5);
    for (i = 0; i < 10; i++) {
        set16(p, (size_t)i * 4, (uint16_t)(i == 3 ? -1 : i % 4 - 2));
        set16(p, (size_t)i * 4 + 2, (uint16_t)(0x8000 + i));
    }
    m42e844_step_record(0x10001u, &g_w, &g_host);
    CK(r[0x40] == 1 && get32(r, 0x41) == 0);
    /* a = -2, -1 (skipped), 0, -1, -2, -1, 0, 1, -2, -1 for k = 0 .. 9: the last store to each index wins */
    CK(get32(g_dt, 24) == 0xffff8008u && get32(g_dt, 32) == 0xffff8006u && get32(g_dt, 36) == 0xffff8007u && get32(g_dt, 28) == 0x201f1e1du);
    CK(L.n == 1);
    CKC(0, 0x42ba3a, 0, 1, 1);
    /* any other state: nothing */
    step42(0, 3);
    m42e844_step_record(0, &g_w, &g_host);
    CK(g_w.value_5bb1ca == 0 && get32(g_w.records_5bb5e5, 0x4d) == 3 && L.n == 0);
}

/* CASES-NEXT */

/* ---- bounded sweep ------------------------------------------------------------------------------------------------------------- */
static void test_sweep_bounded(void)
{
    unsigned seed = 4242;
    int n, i, slot;
    for (n = 0; n < 300 && !g_failed; n++) {
        setup();
        for (i = 0; i < RSZ; i++) {
            seed = seed * 1103515245u + 12345u;
            g_r[0][i] = (uint8_t)(seed >> 16);
        }
        seed = seed * 1103515245u + 12345u;
        for (i = 0; i < (int)sizeof g_tab; i++) g_tab[i] = (uint8_t)(seed >> (i & 15));
        for (i = 0; i < (int)sizeof g_recs; i++) g_recs[i] = (uint8_t)(seed >> (i & 7));
        slot = (int)((seed >> 3) % 3) - 1;
        rec44(slot, RVA(1));
        g_r[1][0] = (uint8_t)(seed >> 5);
        g_r[1][1] = (uint8_t)(seed >> 9);
        g_w.word_63a4cd = (int16_t)(seed >> 7);
        m44b26a_apply_delta((uint32_t)slot, &g_w, &g_host);
        init488(seed & 1, (int)((seed >> 4) % 8), (int)((seed >> 8) % 8), (int)(seed >> 12));
        run488();
        {
            const uint32_t sf[4] = {seed % 3, (seed >> 2) % 3, 3 + (seed >> 4) % 3, 3 + (seed >> 6) % 3}, st[4] = {(seed >> 8) % 3, (seed >> 10) % 3, 6, 6};
            copy5b(1 + (int)(seed % 3), (int)((seed >> 3) & 1), sf, st);
            m4c5b3a_copy_keyed(SELF, RVA(1), RVA(2), RVA(3), RVA(4), seed, &g_w, &g_host);
        }
        step42(((int)(seed >> 3) % 3) - 1, (uint32_t)(seed >> 9) % 4);
        for (i = 0; i < 0x40; i++) g_r[1][i] = (uint8_t)(seed >> (i & 15));
        set16(g_r[1], 0x28, (uint16_t)(seed % 4));
        for (i = 0; i < 10; i++) set16(g_r[1], (size_t)i * 4, (uint16_t)((seed >> i) % 11 - 6));
        g_w.word_5bb50b = (int16_t)(seed >> 5);
        m42e844_step_record((uint32_t)(((int)(seed >> 3) % 3) - 1), &g_w, &g_host);
        /*SWEEP*/
        L.n = 0;
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
    RUN(test_m44b26a_apply_delta);
    RUN(test_m488e9c_init_record);
    RUN(test_m4c5b3a_copy_keyed);
    RUN(test_m42e844_step_record);
    /*RUNS*/
    RUN(test_sweep_bounded);
    return failures;
}
