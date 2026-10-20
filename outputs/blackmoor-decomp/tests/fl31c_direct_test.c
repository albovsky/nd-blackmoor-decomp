/* FL-31 (batch c) direct tests of the eight methods of GAME.EXE in src/original_methods_fl31c.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl31c_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl31c.h"

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
static Fl31cWorld g_w;
static Fl18Host g_host;
#define SELF g_r[0]
#define SELFP ((uintptr_t)SELF)

static void set32(uint8_t *b, size_t off, uint32_t v) { memcpy(b + off, &v, 4); }
static void set16(uint8_t *b, size_t off, uint16_t v) { memcpy(b + off, &v, 2); }
static uint32_t get32(const uint8_t *b, size_t off) { uint32_t v; memcpy(&v, b + off, 4); return v; }
static uint16_t get16(const uint8_t *b, size_t off) { uint16_t v; memcpy(&v, b + off, 2); return v; }

#define MAXCALL 64
static uint32_t g_fill;                         /* what the callee 0x4181c6 stores in dword [buf] */
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[6];
        uint32_t members[4];     /* dwords [self+0x675], [self+0x679], [self+0x67d], [self+0x681] at the call */
        uint8_t snap[0x60];      /* the bytes at the third argument of 0x4181c6 at the call, before the callee's store */
        uint32_t sel[3];         /* dwords [self+0x2b8], [self+0x2bc], [self+0x2c0] at the call */
        uint32_t counter;        /* dword [self+0xfc6] at the call */
    } c[MAXCALL];
} L;
static struct {
    uint32_t callee, results[16];
    int n, used;
} S[8];
static int g_nscript;
static void scriptv(uint32_t callee, int n, const uint32_t *r)
{
    int i;
    S[g_nscript].callee = callee;
    S[g_nscript].n = n;
    S[g_nscript].used = 0;
    for (i = 0; i < n && i < 16; i++) S[g_nscript].results[i] = r[i];
    g_nscript++;
}
static void script1(uint32_t callee, uint32_t r0)
{
    scriptv(callee, 1, &r0);
}

static const uint8_t *host_resolve(void *ctx, uint32_t a);

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int k, i = L.n;
    uint32_t result = 0;
    (void)ctx;
    if (L.n < MAXCALL) {
        L.c[i].callee = callee;
        L.c[i].this_ptr = this_ptr;
        L.c[i].nargs = nargs;
        for (k = 0; k < nargs && k < 6; k++) L.c[i].a[k] = args[k];
        for (k = 0; k < 4; k++) L.c[i].members[k] = get32(SELF, 0x675 + 4 * (size_t)k);
        for (k = 0; k < 3; k++) L.c[i].sel[k] = get32(SELF, 0x2b8 + 4 * (size_t)k);
        L.c[i].counter = get32(SELF, 0xfc6);
        if (callee == 0x4181c6 && nargs == 3) memcpy(L.c[i].snap, host_resolve(NULL, (uint32_t)args[2]), sizeof L.c[i].snap);
    }
    L.n++;
    if (callee == 0x4181c6 && nargs == 3) {      /* the callee fills dword [buf] */
        uint32_t v = g_fill;
        memcpy((void *)host_resolve(NULL, (uint32_t)args[2]), &v, 4);
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
    memset(&g_w, 0, sizeof g_w);
    g_w.words_59f27b = g_r[4];
    g_w.table_5b3790 = g_r[5] + 0x800;              /* index 0 in the middle: slack for negative indices */
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    L.n = 0;
    g_nscript = 0;
    g_fill = 0;
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

/* ---- 0x4e2faa ------------------------------------------------------------------------------------------------------------------ */
static void release_case(uint32_t d6ce, uint16_t w1, uint16_t w2)
{
    int i;
    setup();
    set32(SELF, 0x6ce, d6ce);
    set16(SELF, 0x140a, w1);
    set16(SELF, 0x140c, w2);
    m4e2faa_release_cells(SELF, &g_host);
    CK(L.n == (d6ce != 0 ? 30 : 29));
    for (i = 0; i < 26; i++) CKC0(i, 0x4e1d34, SELFP + 0x1ca2u + (uintptr_t)i * 0x18f);       /* 26 sub-objects, the stride 0x18f */
    CKC0(26, 0x4e2dd3, SELFP);
    CKC(27, 0x4c92c5, 0x5cf659, 1, w1);                                                       /* a word each, in this order */
    CKC(28, 0x4c92c5, 0x5cf659, 1, w2);
    if (d6ce != 0) CKC(29, 0x4c2dfb, 0x5cf659, 1, SELFP + 0x6ce);                             /* the address of the dword inside self */
}
static void test_m4e2faa_release_cells(void)
{
    release_case(0, 0xfffe, 0x8001);
    release_case(1, 0x0000, 0x7fff);
    release_case(0x10000, 0xffff, 0x0000);                                                    /* non-zero with a zero low word */
    release_case(0x80000000u, 0x1234, 0xabcd);
    release_case(0xff000000u, 0x0001, 0x0002);
    setup();
    set32(SELF, 0x6ca, 0xffffffffu);                                                          /* the neighbours do not count */
    set32(SELF, 0x6ce, 0);
    set32(SELF, 0x6d2, 0xffffffffu);
    m4e2faa_release_cells(SELF, &g_host);
    CK(L.n == 29);
}

/* ---- 0x4c2790 ------------------------------------------------------------------------------------------------------------------ */
static void new_record_case(uint32_t len, uint32_t soff, uint32_t boff, uint32_t fill, uint16_t pixel)
{
    uint32_t ret, i, copied;
    uint8_t *str = g_r[3] + soff, *buf = g_r[2] + boff;
    uint8_t before[0x40];
    setup();
    memset(g_r[2], 0x5a, 0x100);
    memset(g_r[3], 0x7e, 0x100);
    for (i = 0; i < len; i++) str[i] = (uint8_t)('A' + i % 26);
    str[len] = 0;
    memcpy(before, str, sizeof before);
    g_w.word_639893 = pixel;
    script1(0x51dc43, RVA(2) + boff);
    g_fill = fill;
    ret = m4c2790_new_record(SELF, 0x11111111u, 0x22222222u, 0x33333333u, RVA(3) + soff, &g_w, &g_host);
    copied = (len >= 0x19 ? 0x18u : len) + 1;                                                  /* the string with its NUL, cut at 0x18 characters */
    CKC(0, 0x51dc43, 0, 1, 0x59);
    CKC(1, 0x4181c6, 0x5d2f31, 3, 0x11111111u, 0x22222222u, RVA(2) + boff);
    for (i = 0; i < 0x60 && !g_failed; i++) {                                                  /* the record as the callee sees it: initialised, [buf] not yet filled */
        uint8_t want = 0;
        if (i >= 4 && i < 8) want = (uint8_t)(0x33333333u >> (8 * (i - 4)));
        else if (i >= 8 && i < 8 + copied) want = i - 8 < copied - 1 ? (uint8_t)('A' + (i - 8) % 26) : 0;
        else if (i == 0x21) want = 0x59;
        else if (i == 0x33) want = (uint8_t)pixel;
        else if (i == 0x34) want = (uint8_t)(pixel >> 8);
        else if (i >= 0x59) want = 0x5a;
        CK(L.c[1].snap[i] == want);
    }
    CK(get32(buf, 0) == fill);
    for (i = 0; i < 0x100 && !g_failed; i++) if (i < boff || i >= boff + 0x59) CK(g_r[2][i] == 0x5a);       /* nothing outside the 0x59 bytes */
    CK(get32(buf, 0x55) == 0 && get16(buf, 0x21) == 0x59);
    for (i = 0; i < 0x40 && !g_failed; i++) {                                                  /* the source is changed only by the cut */
        uint8_t want = before[i];
        if (len >= 0x19 && i == 0x18) want = 0;
        CK(str[i] == want);
    }
    if (fill != 0) {
        CK(ret == RVA(2) + boff);
        CK(L.n == 2);
    } else {
        CK(ret == 0);
        CKC(2, 0x42639d, 0x583979, 2, 0x553c40, 0x22222222u);
        CKC0(3, 0x4c97b4, SELFP);
        CK(L.n == 4);
    }
}
static void test_m4c2790_new_record(void)
{
    uint32_t ret;
    new_record_case(0, 0, 0, 0xdeadbeefu, 0x1234);
    new_record_case(1, 1, 3, 0x80000000u, 0xffff);
    new_record_case(3, 0, 0, 1, 0);
    new_record_case(4, 2, 1, 0x10000, 0x8000);
    new_record_case(5, 3, 0x20, 0xffffffffu, 0x0102);
    new_record_case(0x17, 0, 0, 0x100, 0x7fff);
    new_record_case(0x18, 1, 0, 0xff, 0x1111);
    new_record_case(0x19, 0, 1, 0x1234, 0x2222);          /* cut: the character at 0x18 becomes the NUL */
    new_record_case(0x1b, 3, 3, 5, 0x3333);
    new_record_case(0x30, 0, 0, 7, 0x4444);
    new_record_case(0x30, 2, 0x20, 0, 0x5555);            /* the callee leaves [buf] zero: the error report */
    new_record_case(0x19, 1, 0, 0, 0x6666);
    new_record_case(0, 0, 0, 0, 0x7777);
    /* the allocation fails: nothing is touched, only the two reports */
    setup();
    memset(g_r[2], 0x5a, 0x100);
    script1(0x51dc43, 0);
    ret = m4c2790_new_record(SELF, 1, 0xcafe0001u, 3, RVA(3), &g_w, &g_host);
    CK(ret == 0 && L.n == 3);
    CKC(0, 0x51dc43, 0, 1, 0x59);
    CKC(1, 0x42639d, 0x583979, 2, 0x553be8, 0xcafe0001u);
    CKC0(2, 0x4c97b4, SELFP);
    CK(g_r[2][0] == 0x5a && g_r[2][0x58] == 0x5a);
}

/* ---- 0x4eba54 ------------------------------------------------------------------------------------------------------------------ */
static void retarget_case(uint32_t f0, uint32_t f1, uint16_t count, const uint16_t *words, int nwords, uint16_t repl)
{
    int i, calls = 0, signed_count = (int16_t)count;
    uint8_t before[64];
    setup();
    set32(SELF, 0x985, f0);
    set32(SELF, 0x985 + 0xf7, f1);
    set32(SELF, 0x985 + 2 * 0xf7, 0xffffffffu);                                               /* a third record is never looked at */
    set16(SELF, 0x28da, count);
    set16(SELF, 0xb85, repl);
    set32(SELF, 0xfc6, 0x7777);
    for (i = 0; i < 32; i++) set16(g_r[4], 2 * (size_t)i, i < nwords ? words[i] : 8);       /* beyond the list: 8 (must stay) */
    memcpy(before, g_r[4], sizeof before);
    m4eba54_retarget_words(SELF, &g_w, &g_host);
    if (f0 != 0) {
        CKC0(calls, 0x4e1d34, SELFP + 0xca8);
        CK(L.c[calls].counter == 0);                                                          /* the counter is stored in self at each step */
        calls++;
    }
    if (f1 != 0) {
        CKC0(calls, 0x4e1d34, SELFP + 0xca8 + 0x18f);
        CK(L.c[calls].counter == 1);
        calls++;
    }
    CKC0(calls, 0x4eb9c8, SELFP);
    CK(L.c[calls].counter == (uint32_t)(signed_count > 0 ? signed_count : 0));
    CK(L.n == calls + 1);
    for (i = 0; i < 32 && !g_failed; i++) {
        uint16_t was = get16(before, 2 * (size_t)i), want = was;
        if (i < signed_count && was == 8) want = repl;
        CK(get16(g_r[4], 2 * (size_t)i) == want);
    }
    CK(get32(SELF, 0xfc6) == (uint32_t)(signed_count > 0 ? signed_count : 0));
}
static void test_m4eba54_retarget_words(void)
{
    static const uint16_t mixed[6] = {8, 7, 8, 0x8008, 8, 0xfff8};
    static const uint16_t none[4] = {0, 9, 0x0800, 0x8000};
    retarget_case(0, 0, 0, mixed, 6, 0x1111);
    retarget_case(1, 0, 0, mixed, 6, 0x1111);
    retarget_case(0, 0x10000, 0, mixed, 6, 0x1111);
    retarget_case(0x80000000u, 0xffffffffu, 0, mixed, 6, 0x1111);
    retarget_case(0, 0, 1, mixed, 6, 0x2222);
    retarget_case(0, 0, 4, mixed, 6, 0x3333);
    retarget_case(0xff, 0x100, 6, mixed, 6, 0x4444);
    retarget_case(0, 0, 6, none, 4, 0x5555);
    retarget_case(1, 1, 3, mixed, 6, 8);                                                       /* the replacement equals 8 */
    retarget_case(0, 0, 0xffff, mixed, 6, 0x6666);                                             /* -1: the loop does not run */
    retarget_case(0, 0, 0x8000, mixed, 6, 0x6666);                                             /* -32768 */
    retarget_case(0, 0, 0x8001, mixed, 6, 0x6666);
    retarget_case(0, 0, 2, mixed, 6, 0xffff);
}

/* ---- 0x4edb97 ------------------------------------------------------------------------------------------------------------------ */
static const uint32_t FLAGS[7] = {0x15f, 0x252, 0x4ab, 0x675, 0x679, 0x67d, 0x681};
static void members_case(unsigned mask)
{
    static const uint32_t nz[4] = {1, 0x10000, 0x80000000u, 0xdeadbeefu};
    static const uint32_t arg[4] = {0x9b, 0xcc, 0xfd, 0x12e};
    int k, idx = 0;
    setup();
    for (k = 0; k < 7; k++) set32(SELF, FLAGS[k], ((mask >> k) & 1) ? nz[k % 4] : 0);
    m4edb97_release_members(SELF, &g_host);
    if (mask & 1) CKC0(idx++, 0x4e1d34, SELFP + 0x31c);
    if (mask & 2) CKC0(idx++, 0x4eead0, SELFP + 0x4b7);
    if (mask & 4) CKC(idx++, 0x4c2dfb, 0x5cf659, 1, SELFP + 0x4ab);
    for (k = 0; k < 4; k++) {
        if ((mask >> (3 + k)) & 1) {
            uint32_t flags[4];
            int j;
            CKC(idx, 0x4fba69, 0x5c3a67, 1, SELFP + arg[k]);
            for (j = 0; j < 4; j++) flags[j] = (((mask >> (3 + j)) & 1) && j >= k) ? nz[(3 + j) % 4] : 0;       /* the dword is cleared AFTER the call */
            for (j = 0; j < 4; j++) CK(L.c[idx].members[j] == flags[j]);
            idx++;
        }
    }
    CKC0(idx, 0x4edae5, SELFP);
    CK(L.n == idx + 1);
    for (k = 3; k < 7; k++) CK(get32(SELF, FLAGS[k]) == 0);
    for (k = 0; k < 3; k++) CK(get32(SELF, FLAGS[k]) == (((mask >> k) & 1) ? nz[k % 4] : 0));       /* the first three are left as they are */
}
static void test_m4edb97_release_members(void)
{
    unsigned mask;
    for (mask = 0; mask < 128 && !g_failed; mask++) members_case(mask);
}

/* ---- 0x4db870 ------------------------------------------------------------------------------------------------------------------ */
static void cursor_case(uint16_t word, uint32_t pair_at, uint32_t x, uint32_t y, uint16_t t0, uint16_t t1)
{
    int32_t sel = word == 0xffff ? 0 : (int16_t)word + 0x25;
    ptrdiff_t e = sel * 8;
    uint32_t px = x, py = y;
    uint8_t before[0x40];
    setup();
    g_w.word_583a29 = (int16_t)word;
    g_w.dword_5d0377 = 0x0d0377u;
    g_w.dword_571ad3 = 0x071ad3u;
    g_w.dword_5b44f0 = 0x55555555u;
    g_w.dword_5b44f4 = 0x66666666u;
    set16(g_r[5] + 0x800, (size_t)e, t0);
    set16(g_r[5] + 0x800, (size_t)e + 2, t1);
    if (pair_at >= RVA(1)) {
        set32(g_r[1], pair_at - RVA(1), x);
        set32(g_r[1], pair_at - RVA(1) + 4, y);
    } else {                                           /* the pair lies inside self: the dwords there are x and y (both read before any store) */
        set32(SELF, pair_at - RVA(0), x);
        set32(SELF, pair_at - RVA(0) + 4, y);
    }
    memcpy(before, SELF, sizeof before);
    script1(0x4daeb5, pair_at);
    m4db870_load_cursor(SELF, &g_w, &g_host);
    CK(L.n == 2);
    CKC(0, 0x4dae88, 0x5830a6, 2, 0, 0);
    CK(L.c[1].callee == 0x4daeb5 && L.c[1].this_ptr == 0x5830a6 && L.c[1].nargs == 1 && L.c[1].a[0] > 0xffffffffu);
    CK(g_w.dword_5b44f0 == (uint32_t)sel && g_w.dword_5b44f4 == 0);
    CK(g_w.dword_5d162d == (word == 0xffff ? 0x0d0377u : 0x071ad3u));
    CK(get32(SELF, 0x14) == px && get32(SELF, 0x18) == py && get32(SELF, 0x1c) == px && get32(SELF, 0x20) == py);
    CK(g_w.dword_583106 == py && get32(SELF, 0x28) == py);
    CK(g_w.dword_58310e == py + (uint32_t)(int32_t)(int16_t)t1 - 1u && get32(SELF, 0x30) == g_w.dword_58310e);
    CK(g_w.dword_583102 == px && get32(SELF, 0x24) == px);
    CK(g_w.dword_58310a == px + (uint32_t)(int32_t)(int16_t)t0 - 1u && get32(SELF, 0x2c) == g_w.dword_58310a);
    CK(memcmp(before + 0x34, SELF + 0x34, sizeof before - 0x34) == 0 && memcmp(before, SELF, 0x14) == 0);       /* only +0x14 .. +0x33 is written */
}
static void test_m4db870_load_cursor(void)
{
    cursor_case(0xffff, RVA(1) + 8, 0x11111111u, 0x22222222u, 0x8000, 0xfffb);         /* -1: first arm, entry 0; words -32768 and -5 are sign-extended */
    cursor_case(5, RVA(1) + 8, 0x00000001u, 0x80000000u, 0x0001, 0x7fff);              /* sel = 0x2a */
    cursor_case(0xffd8, RVA(1) + 0x10, 0xfffffff0u, 0x00000010u, 0xfff0, 0x0100);       /* -0x28: sel = -3 */
    cursor_case(0, RVA(1) + 8, 0, 0, 0x0000, 0x0000);
    cursor_case(0xff, RVA(1) + 8, 0x12345678u, 0x9abcdef0u, 0x1234, 0x8001);           /* 0xff is not -1 */
    cursor_case(0xffdb, RVA(1) + 8, 5, 6, 7, 8);                                       /* -0x25: sel = 0 on the second arm */
    cursor_case(0xfffe, RVA(1) + 8, 0xffffffffu, 0xffffffffu, 0xffff, 0xffff);
    cursor_case(1, RVA(0) + 0x10, 0xaaaa0001u, 0xbbbb0002u, 3, 4);                     /* the pair at +0x10: x = [self+0x10], y = [self+0x14] */
    cursor_case(0xffff, RVA(0) + 0x14, 0x01010101u, 0x02020202u, 5, 6);
    cursor_case(0xffff, RVA(0) + 0x18, 0x0badf00du, 0xdeadbeefu, 7, 8);
    cursor_case(2, RVA(0) + 0x1c, 0x13572468u, 0x24681357u, 9, 10);
}

/* ---- 0x47cd90, 0x47ce6f, 0x47cf4e ---------------------------------------------------------------------------------------------- */
typedef void (*pick_fn)(uint8_t *, const Fl18Host *);
static void pick_case(pick_fn fn, uint32_t sel, uint32_t base, int count, uint32_t s1, uint32_t s2, int k, const uint32_t *rands, int nr, uint32_t second_nz, uint32_t record_base)
{
    uint32_t others[3];
    int i, idx = 0, r;
    uint32_t cur = 0;
    setup();
    set32(SELF, 0xc, record_base);
    set32(SELF, sel, 0x12345678u);
    for (i = 0; i < 3; i++) others[i] = get32(SELF, 0x2b8 + 4 * (size_t)i);
    {   /* the compares: k zeros, one non-zero, then (nr - 1) zeros and the second non-zero */
        uint32_t seq[16];
        int n = 0;
        for (i = 0; i < k; i++) seq[n++] = 0;
        if (k < count) {
            seq[n++] = 0x10000;
            for (i = 0; i < nr - 1; i++) seq[n++] = 0;
            seq[n++] = second_nz;
        }
        scriptv(0x516530, n ? n : 1, seq);
    }
    if (nr > 0) scriptv(0x50cd50, nr, rands);
    fn(SELF, &g_host);
    for (i = 0; i < (k < count ? k + 1 : count); i++, idx++) {
        CKC(idx, 0x516530, 0, 2, record_base + (uint32_t)i * 0xb6u + base, s1);
        CK(L.c[idx].sel[(sel - 0x2b8) / 4] == 0xffffffffu);                               /* the selector is set to -1 before the first compare */
    }
    if (k < count) {
        for (r = 0; r < nr; r++) {
            int32_t rem = (int32_t)rands[r] % count;
            cur = (uint32_t)rem;
            CKC0(idx, 0x50cd50, 0);
            idx++;
            CKC(idx, 0x516530, 0, 2, record_base + cur * 0xb6u + base, s2);
            CK(L.c[idx].sel[(sel - 0x2b8) / 4] == cur);                                   /* stored before the compare */
            idx++;
        }
        CKC(idx, 0x47d02d, SELFP, 1, record_base + cur * 0xb6u + base);
        idx++;
        CK(get32(SELF, sel) == cur);
    } else {
        CK(get32(SELF, sel) == 0xffffffffu);
    }
    CK(L.n == idx);
    for (i = 0; i < 3; i++) if (0x2b8 + 4 * (uint32_t)i != sel) CK(get32(SELF, 0x2b8 + 4 * (size_t)i) == others[i]);        /* the other two selectors are not touched */
}
static void test_pick_one(pick_fn fn, uint32_t sel, uint32_t base, int count, uint32_t s1, uint32_t s2)
{
    static const uint32_t r1[1] = {7};
    static const uint32_t r2[2] = {0xfffffffdu, 12};              /* -3 % N, then 12 % N */
    static const uint32_t r3[3] = {0x80000000u, 0x7fffffffu, 4};
    static const uint32_t r4[1] = {0xfffffffbu};                  /* -5: remainder 0 */
    int k;
    for (k = 0; k <= count; k++) {
        pick_case(fn, sel, base, count, s1, s2, k, r1, 1, 1, RVA(1) + 0x100);
        pick_case(fn, sel, base, count, s1, s2, k, r2, 2, 0x100, 0xfffffe00u);
        pick_case(fn, sel, base, count, s1, s2, k, r3, 3, 0x80000000u, 0x10000);
        pick_case(fn, sel, base, count, s1, s2, k, r4, 1, 5, 0x80000000u);
    }
}
static void test_m47cd90_pick_variant_a(void) { test_pick_one(m47cd90_pick_variant_a, 0x2b8, 0x4c8, 5, 0x54d104, 0x54d110); }
static void test_m47ce6f_pick_variant_b(void) { test_pick_one(m47ce6f_pick_variant_b, 0x2bc, 0x856, 10, 0x54d11c, 0x54d128); }
static void test_m47cf4e_pick_variant_c(void) { test_pick_one(m47cf4e_pick_variant_c, 0x2c0, 0xf72, 10, 0x54d134, 0x54d140); }

/* ---- bounded sweep ------------------------------------------------------------------------------------------------------------- */
static void test_sweep_bounded(void)
{
    unsigned seed = 4242;
    int n, i;
    for (n = 0; n < 300 && !g_failed; n++) {
        uint32_t seq[8];
        setup();
        for (i = 0; i < RSZ; i++) {
            seed = seed * 1103515245u + 12345u;
            g_r[0][i] = (uint8_t)(seed >> 16);
        }
        m4e2faa_release_cells(SELF, &g_host);
        L.n = 0;
        memset(g_r[3], 'x', 0x100);                                  /* a string of up to 0x7f characters in region 3 */
        seed = seed * 1103515245u + 12345u;
        g_r[3][seed % 0x80] = 0;
        script1(0x51dc43, (seed & 8) ? 0 : RVA(2) + (seed >> 8) % 0x40);
        g_fill = seed >> 3;
        m4c2790_new_record(SELF, seed, seed >> 5, seed >> 9, RVA(3) + (seed >> 12) % 4, &g_w, &g_host);
        L.n = 0;
        g_nscript = 0;
        set16(SELF, 0x28da, (uint16_t)((seed >> 4) % 20) - 4);       /* -4 .. 15 words: inside the region */
        for (i = 0; i < 32; i++) set16(g_r[4], 2 * (size_t)i, (uint16_t)(seed >> (i & 7)) & 0xf);
        m4eba54_retarget_words(SELF, &g_w, &g_host);
        L.n = 0;
        m4edb97_release_members(SELF, &g_host);
        L.n = 0;
        g_w.word_583a29 = (int16_t)((seed >> 6) % 0x40) - 0x30;
        script1(0x4daeb5, RVA(1) + (seed >> 5) % 0x100);
        m4db870_load_cursor(SELF, &g_w, &g_host);
        L.n = 0;
        g_nscript = 0;
        for (i = 0; i < 8; i++) seq[i] = (i == 3 || i == 7) ? seed | 1u : 0u;
        scriptv(0x516530, 8, seq);
        seq[0] = seed >> 7;
        scriptv(0x50cd50, 1, seq);
        m47cd90_pick_variant_a(SELF, &g_host);
        L.n = 0;
        g_nscript = 0;
        for (i = 0; i < 8; i++) seq[i] = (i == 3 || i == 7) ? seed | 1u : 0u;
        scriptv(0x516530, 8, seq);
        scriptv(0x50cd50, 1, seq);
        m47ce6f_pick_variant_b(SELF, &g_host);
        L.n = 0;
        g_nscript = 0;
        scriptv(0x516530, 8, seq);
        m47cf4e_pick_variant_c(SELF, &g_host);
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
    RUN(test_m4e2faa_release_cells);
    RUN(test_m4c2790_new_record);
    RUN(test_m4eba54_retarget_words);
    RUN(test_m4edb97_release_members);
    RUN(test_m4db870_load_cursor);
    RUN(test_m47cd90_pick_variant_a);
    RUN(test_m47ce6f_pick_variant_b);
    RUN(test_m47cf4e_pick_variant_c);
    RUN(test_sweep_bounded);
    return failures;
}
