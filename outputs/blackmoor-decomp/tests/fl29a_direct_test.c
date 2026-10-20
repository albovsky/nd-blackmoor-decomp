/* FL-29 (batch a) direct tests of the ten small methods of GAME.EXE in src/original_methods_fl29a.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl29a_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl29a.h"

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
static uint8_t g_tbl[0x4a * 0x70], g_words[64], g_dwords[128];
static Fl29aWorld g_w;
static Fl18Host g_host;
#define SELF g_r[0]

static void set32(uint8_t *b, size_t off, uint32_t v) { memcpy(b + off, &v, 4); }
static void set16(uint8_t *b, size_t off, uint16_t v) { memcpy(b + off, &v, 2); }
static uint32_t get32(const uint8_t *b, size_t off) { uint32_t v; memcpy(&v, b + off, 4); return v; }
static uint16_t get16(const uint8_t *b, size_t off) { uint16_t v; memcpy(&v, b + off, 2); return v; }

#define MAXCALL 64
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[6];
        uint8_t probe[16];       /* the first 16 bytes of region 4 at the call */
    } c[MAXCALL];
} L;
static struct {
    uint32_t callee, results[8];
    int n, used;
} S[4];
static int g_nscript;
static void script(uint32_t callee, int n, uint32_t r0, uint32_t r1, uint32_t r2, uint32_t r3)
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
        for (k = 0; k < nargs && k < 6; k++) L.c[i].a[k] = args[k];
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
    memset(g_tbl, 0, sizeof g_tbl);
    memset(g_words, 0, sizeof g_words);
    memset(g_dwords, 0, sizeof g_dwords);
    memset(&g_w, 0, sizeof g_w);
    g_w.table_5d15a5 = g_tbl + 3 * 0x4a;
    g_w.words_5afbda = g_words + 16;
    g_w.dwords_5d032f = g_dwords + 32;
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

/* ---- 0x4d39f9 ------------------------------------------------------------------------------------------------------------------ */
static void ent4(int i, uint32_t v) { set32(g_w.table_5d15a5, (size_t)i * 0x4a + 4, v); }
static void test_m4d39f9_find_free_entry(void)
{
    int i;
    setup();
    for (i = 0; i < 0x41; i++) set32(g_w.table_5d15a5, (size_t)i * 0x4a, 0);       /* the dwords at +0 are not the ones looked at */
    for (i = 0; i < 0x40; i++) ent4(i, i < 0x18 ? 0 : 0x10000);                    /* 0x10000 is non-zero (full dword compare); entries below 0x18 are not looked at */
    ent4(0x40, 0);
    CK((int16_t)m4d39f9_find_free_entry(&g_w, &g_host) == -1);
    CKC(0, 0x52139c, 0, 3, 0x55a448, 0, 0);
    CKC0(1, 0x4c97b4, 0x5cf659);
    CK(L.n == 2);                                                                  /* entry 0x40 (past the loop) is free but not looked at */
    ent4(0x3f, 0);
    L.n = 0;
    CK((int16_t)m4d39f9_find_free_entry(&g_w, &g_host) == 0x3f);                  /* the last entry */
    CK(L.n == 0);
    ent4(0x20, 0);
    CK((int16_t)m4d39f9_find_free_entry(&g_w, &g_host) == 0x20);                  /* the first free one wins */
    ent4(0x18, 0);
    CK((int16_t)m4d39f9_find_free_entry(&g_w, &g_host) == 0x18);                  /* the first index of the loop */
    ent4(0x18, 0x80000000u);
    ent4(0x20, 0xff000000u);
    ent4(0x3f, 0x100);
    CK((int16_t)m4d39f9_find_free_entry(&g_w, &g_host) == -1);
    CK(L.n == 2);
}

/* ---- 0x4c4202 ------------------------------------------------------------------------------------------------------------------ */
static void test_m4c4202_check_vtable_call(void)
{
    setup();
    set32(g_r[1], 0, RVA(2));                       /* obj: its vtable is region 2 */
    set32(g_r[2], 0x80, 0x7e000900u);               /* the entry at +0x80 */
    set32(SELF, 0xc, RVA(1));
    m4c4202_check_vtable_call(SELF, RVA(1), 77, &g_host);
    CK(L.n == 0);                                   /* obj == [self+0xc]: nothing */
    set32(SELF, 0xc, RVA(1) ^ 0x10000u);
    script(0x7e000900u, 1, 0, 0, 0, 0);
    m4c4202_check_vtable_call(SELF, RVA(1), 77, &g_host);
    CK(L.n == 1);
    CKC(0, 0x7e000900u, RVA(2), 2, RVA(1), 77);     /* ecx = the vtable, arguments (obj, arg) */
    L.n = 0;
    g_nscript = 0;
    script(0x7e000900u, 1, 0x887601c2u, 0, 0, 0);
    script(0x4c88c7, 1, 0xabcdef01u, 0, 0, 0);
    m4c4202_check_vtable_call(SELF, RVA(1), 0xfffffffeu, &g_host);
    CK(L.n == 4);
    CKC(0, 0x7e000900u, RVA(2), 2, RVA(1), 0xfffffffeu);
    CKC(1, 0x4c88c7, SELFP, 1, 0x887601c2u);
    CKC(2, 0x42639d, 0x583979, 2, 0x5543f0, 0xabcdef01u);
    CKC0(3, 0x4c97b4, SELFP);
    set32(SELF, 0xc, 0);                            /* a different stored value (0) is a different object */
    L.n = 0;
    g_nscript = 0;
    script(0x7e000900u, 1, 0x10000, 0, 0, 0);       /* non-zero with a zero low word is still non-zero */
    m4c4202_check_vtable_call(SELF, RVA(1), 5, &g_host);
    CK(L.n == 4);
}

/* ---- 0x4c948f ------------------------------------------------------------------------------------------------------------------ */
static void slot(int i, uint32_t v) { set32(SELF, 0xc72 + (size_t)i * 4, v); }
static void test_m4c948f_find_free_slot(void)
{
    int i;
    setup();
    for (i = 0; i < 0x19; i++) slot(i, i == 0x18 ? 0 : 0x10000);                 /* slot 0x18 is free but outside the loop */
    CK((int16_t)m4c948f_find_free_slot(SELF, &g_host) == -1);
    CKC(0, 0x52139c, 0, 3, 0x557ae4, 0, 0);
    CKC0(1, 0x4c97b4, SELFP);                                                   /* ecx = self here (not 0x5cf659) */
    CK(L.n == 2);
    slot(0x17, 0);
    L.n = 0;
    CK((int16_t)m4c948f_find_free_slot(SELF, &g_host) == 0x17);
    slot(5, 0);
    CK((int16_t)m4c948f_find_free_slot(SELF, &g_host) == 5);
    slot(0, 0);
    CK((int16_t)m4c948f_find_free_slot(SELF, &g_host) == 0);
    CK(L.n == 0);
}

/* ---- 0x4d3992 ------------------------------------------------------------------------------------------------------------------ */
static void fill_tbl(void) { size_t i; for (i = 0; i < sizeof g_tbl; i++) g_tbl[i] = 0xa5; }
static uint32_t tget(int idx, int off) { return get32(g_w.table_5d15a5, (size_t)((ptrdiff_t)idx * 0x4a + off)); }
static void test_m4d3992_clear_entry(void)
{
    setup();
    fill_tbl();
    m4d3992_clear_entry(0xabcd0000u | 5u, &g_w, &g_host);                         /* the upper half of the stack dword is ignored */
    CK(L.n == 0);
    CK(tget(5, 0) == 0 && tget(5, 4) == 0);
    CK(tget(4, 0) == 0xa5a5a5a5u && tget(4, 4) == 0xa5a5a5a5u && tget(6, 0) == 0xa5a5a5a5u);
    CK(get32(g_w.table_5d15a5, 5 * 0x4a + 8) == 0xa5a5a5a5u);                  /* nothing else of the record */
    m4d3992_clear_entry(0x57, &g_w, &g_host);                                     /* the last valid index */
    CK(L.n == 0 && tget(0x57, 0) == 0 && tget(0x57, 4) == 0);
    m4d3992_clear_entry(0, &g_w, &g_host);
    CK(L.n == 0 && tget(0, 0) == 0);
    m4d3992_clear_entry(0x58, &g_w, &g_host);                                     /* reported, and cleared nevertheless */
    CK(L.n == 3);
    CKC(0, 0x50ca3e, 0, 3, 0x63888b, 0x55a400, 0x58);
    CKC(1, 0x52139c, 0, 3, 0x63888b, 0, 0);
    CKC0(2, 0x4c97b4, 0x5cf659);
    CK(tget(0x58, 0) == 0 && tget(0x58, 4) == 0);
    L.n = 0;
    m4d3992_clear_entry(0xffff, &g_w, &g_host);                                   /* -1 */
    CK(L.n == 3);
    CKC(0, 0x50ca3e, 0, 3, 0x63888b, 0x55a400, 0xffffffffu);                     /* the sign-extended index */
    CK(tget(-1, 0) == 0 && tget(-1, 4) == 0);
    L.n = 0;
    m4d3992_clear_entry(0x59, &g_w, &g_host);
    CK(L.n == 3);
    CKC(0, 0x50ca3e, 0, 3, 0x63888b, 0x55a400, 0x59);
}

/* ---- 0x4c92c5 ------------------------------------------------------------------------------------------------------------------ */
static void wset(int idx, uint16_t v) { set16(g_w.words_5afbda, (size_t)((ptrdiff_t)idx * 2), v); }
static int16_t wget(int idx) { return (int16_t)get16(g_w.words_5afbda, (size_t)((ptrdiff_t)idx * 2)); }
static void dset(int idx, uint32_t v) { set32(g_w.dwords_5d032f, (size_t)((ptrdiff_t)idx * 4), v); }
static void test_m4c92c5_count_down(void)
{
    setup();
    dset(2, 0x10000);                                      /* a non-zero dword with a zero low word counts */
    wset(2, 3);
    m4c92c5_count_down(0x12340002u, &g_w, &g_host);
    CK(wget(2) == 2 && L.n == 0);
    m4c92c5_count_down(2, &g_w, &g_host);
    CK(wget(2) == 1 && L.n == 0);
    m4c92c5_count_down(2, &g_w, &g_host);
    CK(wget(2) == 0 && L.n == 1);
    CKC(0, 0x4c2dfb, 0x5cf659, 1, 0x5d032fu + 8);          /* the ORIGINAL address of dword 2 */
    m4c92c5_count_down(2, &g_w, &g_host);                  /* 0 - 1 = -1: below zero, clamped to 0, no call */
    CK(wget(2) == 0 && L.n == 1);
    wset(2, 0x8000);                                       /* wraps to 0x7fff, positive */
    m4c92c5_count_down(2, &g_w, &g_host);
    CK(get16(g_w.words_5afbda, 4) == 0x7fff && L.n == 1);
    wset(2, 0xffff);                                       /* -1 -> -2 -> 0 */
    m4c92c5_count_down(2, &g_w, &g_host);
    CK(wget(2) == 0 && L.n == 1);
    dset(-3, 5);
    wset(-3, 1);
    L.n = 0;
    m4c92c5_count_down(0xfffd, &g_w, &g_host);             /* index -3 */
    CK(wget(-3) == 0 && L.n == 1);
    CKC(0, 0x4c2dfb, 0x5cf659, 1, 0x5d032fu - 12u);
    dset(1, 0);                                            /* a zero dword: the word is not decremented but a negative word is still cleared */
    wset(1, 7);
    L.n = 0;
    m4c92c5_count_down(1, &g_w, &g_host);
    CK(wget(1) == 7 && L.n == 0);
    wset(1, 0xfff0);
    m4c92c5_count_down(1, &g_w, &g_host);
    CK(wget(1) == 0 && L.n == 0);
    wset(1, 0);
    m4c92c5_count_down(1, &g_w, &g_host);
    CK(wget(1) == 0);
}

/* ---- 0x4c9340 ------------------------------------------------------------------------------------------------------------------ */
#define PIX 0x100u
static void scan_setup(int bpp, int pitch, uint32_t x0, uint32_t y0, uint32_t x1, uint32_t y1, uint16_t key)
{
    size_t i;
    setup();
    set32(g_r[1], 0, RVA(3) + PIX);
    set16(g_r[1], 0x2f, (uint16_t)pitch);
    set32(g_r[2], 0, x0);
    set32(g_r[2], 4, y0);
    set32(g_r[2], 8, x1);
    set32(g_r[2], 0xc, y1);
    set16(SELF, 0x38d0, key);
    for (i = 0; i < 0x400; i += 2) set16(g_r[3], i, key);
    g_w.word_639895 = (int16_t)bpp;
}
static int scan(void) { return (uint16_t)m4c9340_scan_surface(SELF, RVA(1), RVA(2), &g_w, &g_host); }
static void test_m4c9340_scan_surface(void)
{
    scan_setup(2, 8, 1, 1, 2, 2, 0x1234);                 /* p = base + 8 + 2, 2 rows of 4 bytes: words at 10, 12 and 18, 20 */
    CK(scan() == 0);
    set16(g_r[3], PIX + 14, 0x4321);                      /* between the rows: outside */
    set16(g_r[3], PIX + 16, 0x4321);
    set16(g_r[3], PIX + 22, 0x4321);                      /* after the last scanned word */
    set16(g_r[3], PIX + 8, 0x4321);                       /* before the first */
    CK(scan() == 0);
    set16(g_r[3], PIX + 20, 0xabcd);
    CK(scan() == 0xabcd);                                 /* second row, second word */
    set16(g_r[3], PIX + 12, 0x8001);
    CK(scan() == 0x8001);                                 /* an earlier word wins */
    set16(g_r[3], PIX + 10, 0xff34);                      /* differs in the high byte only: a full 16-bit compare */
    CK(scan() == 0xff34);
    scan_setup(2, 8, 1, 1, 2, 2, 0);
    set16(g_r[3], PIX + 10, 1);
    CK(scan() == 1);
    scan_setup(2, 8, 1, 1, 2, 1, 0x8000);                 /* rows = 1 */
    set16(g_r[3], PIX + 18, 0x0001);                      /* in the second row: not scanned */
    CK(scan() == 0);
    set16(g_r[3], PIX + 12, 0x0001);
    CK(scan() == 1);
    scan_setup(2, 8, 1, 1, 2, 0, 0x1234);                 /* rows = 0: nothing is read */
    set16(g_r[3], PIX + 10, 9);
    CK(scan() == 0);
    scan_setup(2, 8, 1, 1, 0, 2, 0x1234);                 /* width 0 bytes */
    set16(g_r[3], PIX + 10, 9);
    CK(scan() == 0);
    scan_setup(1, 8, 0, 0, 2, 0, 0x1234);                 /* 3 bytes per row (bpp 1): the words at 0 and 2; the second one ends one byte past the row */
    g_r[3][PIX + 4] = 0;                                  /* byte 4 is outside both words */
    CK(scan() == 0);
    g_r[3][PIX + 3] = 0;                                  /* byte 3 is the high byte of the word at j = 2 (0x34 | 0x00 << 8) */
    CK(scan() == 0x0034);
    scan_setup(4, -0x10, 0, 3, 1, 3, 0x2222);             /* bpp 4: 8 bytes per row, negative pitch: p = base - 0x30 */
    CK(scan() == 0);
    set16(g_r[3], PIX - 0x30 + 6, 0x2223);
    CK(scan() == 0x2223);
    scan_setup(4, -0x10, 0, 3, 1, 4, 0x2222);             /* two rows: the second one starts at base - 0x40 */
    set16(g_r[3], PIX - 0x40 + 2, 0x0222);
    CK(scan() == 0x0222);
    scan_setup(2, 0x10, 0, 0, 1, 1, 0x2222);
    set16(g_r[3], PIX + 0x10 + 2, 0x2223);
    CK(scan() == 0x2223);
    scan_setup(2, 8, 0, 0, 0, 0, 0x1111);
    CK(m4c9340_scan_surface(SELF, 0, RVA(2), &g_w, &g_host) == 0);              /* a null surface */
    CK(L.n == 0);
}

/* ---- 0x4c46d1 ------------------------------------------------------------------------------------------------------------------ */
static void fill_setup(int w, int h)
{
    setup();
    set32(g_r[1], 0, RVA(2));
    set16(g_r[1], 0x2b, (uint16_t)w);
    set16(g_r[1], 0x2d, (uint16_t)h);
    memset(g_r[2], 0xee, RSZ);
    SELF[0x38c6] = 0x1f; SELF[0x38c5] = 0x3f; SELF[0x38c4] = 0x1f;
    SELF[0x38ca] = 5; SELF[0x38c9] = 0; SELF[0x38c8] = 5;
    SELF[0x38c2] = 11; SELF[0x38c1] = 5; SELF[0x38c0] = 0;
}
static void test_m4c46d1_fill_surface(void)
{
    int i;
    fill_setup(3, 2);
    m4c46d1_fill_surface(SELF, RVA(1), 0xff, 0xffffff3fu, 0x11111105u, &g_host);       /* only the low byte of each argument */
    /* r = 0x1f (selector 5: no shift), g = 0x3f << 1 = 0x7e, b = 5 & 0x1f = 5: 0x1f << 11 | 0x7e << 5 | 5 = 0xffc5 */
    for (i = 0; i < 6; i++) CK(get16(g_r[2], (size_t)i * 2) == 0xffc5);
    CK(get16(g_r[2], 12) == 0xeeee && g_r[2][13] == 0xee);                                /* only w * h pixels */
    CK(L.n == 0);
    fill_setup(1, 1);
    SELF[0x38ca] = 0; SELF[0x38c8] = 0xff; SELF[0x38c9] = 5;
    SELF[0x38c6] = 0xff; SELF[0x38c5] = 0xff; SELF[0x38c4] = 0xff;
    m4c46d1_fill_surface(SELF, RVA(1), 0x81, 0x7f, 0x81, &g_host);
    /* r = 0x81 << 1 as a byte = 0x02; g = 0x7f (selector 5); b = 0x81 << 1 = 0x02: 2 << 11 | 0x7f << 5 | 2 = 0x1000 | 0xfe0 | 2 */
    CK(get16(g_r[2], 0) == 0x1fe2 && get16(g_r[2], 2) == 0xeeee);
    fill_setup(2, 1);
    SELF[0x38c2] = 0x25; SELF[0x38c1] = 0x10; SELF[0x38c0] = 0xff;                          /* the count is taken modulo 32: 5, 16, 31 */
    SELF[0x38c6] = 0xff; SELF[0x38c5] = 0xff; SELF[0x38c4] = 0xff;
    m4c46d1_fill_surface(SELF, RVA(1), 1, 1, 1, &g_host);
    /* r = 1 << 5 = 0x20 (selector 5: no byte shift); g = 1 << 1 = 2, 2 << 16 is above the word; b = 1 << 31 likewise: the low word is 0x20 */
    CK(get16(g_r[2], 0) == 0x20 && get16(g_r[2], 2) == 0x20 && get16(g_r[2], 4) == 0xeeee);
    fill_setup(-2, -3);                                                                     /* (-2) * (-3) = 6 pixels */
    m4c46d1_fill_surface(SELF, RVA(1), 0, 0, 0, &g_host);
    for (i = 0; i < 6; i++) CK(get16(g_r[2], (size_t)i * 2) == 0);
    CK(get16(g_r[2], 12) == 0xeeee);
    fill_setup(-1, 5);                                                                      /* -5: nothing */
    m4c46d1_fill_surface(SELF, RVA(1), 0xff, 0xff, 0xff, &g_host);
    CK(get16(g_r[2], 0) == 0xeeee);
    fill_setup(0, 5);
    m4c46d1_fill_surface(SELF, RVA(1), 0xff, 0xff, 0xff, &g_host);
    CK(get16(g_r[2], 0) == 0xeeee);
}

/* ---- 0x4cb9d1 ------------------------------------------------------------------------------------------------------------------ */
static void reloc_setup(int count)
{
    int i;
    setup();
    set32(SELF, 0x12, RVA(1));
    set16(g_r[1], 2, (uint16_t)count);
    set32(g_r[1], 9, RVA(2));
    for (i = 0; i < 4; i++) {
        set32(g_r[2], (size_t)i * 0x18 + 4, 100 + (uint32_t)i);
        set32(g_r[2], (size_t)i * 0x18 + 8, 200 + (uint32_t)i);
        set32(g_r[2], (size_t)i * 0x18 + 0xc, 300 + (uint32_t)i);
        set32(g_r[2], (size_t)i * 0x18 + 0x10, 400 + (uint32_t)i);
        set32(g_r[2], (size_t)i * 0x18, 0x5000 + (uint32_t)i);
    }
    set32(g_r[3], 0x12, 7);
    set32(g_r[3], 0x16, 0xfffffff0u);
    script(0x4c0c69, 1, RVA(3), 0, 0, 0);
    set32(SELF, 0x132, 0x77777777u);
    set32(SELF, 0x126, 0x66666666u);
}
static void test_m4cb9d1_relocate_entries(void)
{
    int i;
    reloc_setup(3);
    m4cb9d1_relocate_entries(SELF, &g_host);
    CK(L.n == 1);
    CKC0(0, 0x4c0c69, 0x637fcf);
    CK(get32(SELF, 0x15c) == RVA(3) && get32(SELF, 0x132) == 3 && get32(SELF, 0x126) == RVA(2) + 2 * 0x18);
    for (i = 0; i < 4; i++) {
        int done = i < 3;
        CK(get32(g_r[2], (size_t)i * 0x18 + 4) == 100u + (uint32_t)i + (done ? 7u : 0u));
        CK(get32(g_r[2], (size_t)i * 0x18 + 0xc) == 300u + (uint32_t)i + (done ? 7u : 0u));
        CK(get32(g_r[2], (size_t)i * 0x18 + 8) == 200u + (uint32_t)i + (done ? 0xfffffff0u : 0u));
        CK(get32(g_r[2], (size_t)i * 0x18 + 0x10) == 400u + (uint32_t)i + (done ? 0xfffffff0u : 0u));
        CK(get32(g_r[2], (size_t)i * 0x18) == 0x5000u + (uint32_t)i);                    /* +0 untouched */
    }
    reloc_setup(0);
    m4cb9d1_relocate_entries(SELF, &g_host);
    CK(L.n == 1 && get32(SELF, 0x132) == 0 && get32(SELF, 0x126) == 0x66666666u && get32(SELF, 0x15c) == RVA(3) && get32(g_r[2], 4) == 100);
    reloc_setup(0xffff);                                                                  /* word -1: no pass */
    m4cb9d1_relocate_entries(SELF, &g_host);
    CK(get32(SELF, 0x132) == 0 && get32(g_r[2], 4) == 100);
    reloc_setup(1);
    set32(SELF, 0x12, 0);                                                                 /* no table: nothing at all */
    m4cb9d1_relocate_entries(SELF, &g_host);
    CK(L.n == 0 && get32(SELF, 0x132) == 0x77777777u && get32(SELF, 0x15c) != RVA(3));
    reloc_setup(1);
    g_nscript = 0;
    script(0x4c0c69, 1, 0, 0, 0, 0);                                                      /* no object: stored (0), then stop */
    m4cb9d1_relocate_entries(SELF, &g_host);
    CK(L.n == 1 && get32(SELF, 0x15c) == 0 && get32(SELF, 0x132) == 0x77777777u && get32(g_r[2], 4) == 100);
}

/* ---- 0x4895cc ------------------------------------------------------------------------------------------------------------------ */
static void init_setup(const char *text, uint32_t buf)
{
    size_t i;
    setup();
    memset(g_r[4], 0x77, RSZ);                    /* the buffer (the first 0x1000 bytes of region 4 are inside the host memory) */
    memset(g_r[2], 0x33, RSZ);
    strcpy((char *)g_r[2], text);
    for (i = 0; i < 0x70; i++) g_r[2][0x30 + i] = (uint8_t)(0x90 + i);
    set32(g_r[1], 0, 0x11111111u);                /* p0 */
    set32(g_r[1], 4, RVA(2));                     /* p1 */
    set32(g_r[1], 8, 0x10);                       /* p2 */
    script(0x51dc43, 1, buf, 0, 0, 0);
    g_w.value_5bb57b = 0xcafe0001u;
    g_w.word_5c39e3 = -2;
}
static void test_m4895cc_init_buffer(void)
{
    int i;
    init_setup("AB", RVA(4));
    set16(g_r[2], 0x21, 0x5566);
    set16(g_r[2], 0x23, 0x7788);
    CK(m4895cc_init_buffer(SELF, RVA(1), RVA(1) + 4, RVA(1) + 8, &g_w, &g_host) == 0);
    CK(L.n == 2);
    CKC(0, 0x51dc43, 0, 1, 0xaba);
    CKC(1, 0x48945b, SELFP, 2, RVA(4), RVA(2) + 0x25);
    CK(L.c[1].probe[0] == 0 && L.c[1].probe[15] == 0);                                    /* the buffer is cleared before the callee runs */
    CK(get32(g_r[1], 0) == RVA(4) && get32(SELF, 0x1c) == RVA(4) && get32(SELF, 0x20) == RVA(4));
    CK(g_r[4][0] == 'A' && g_r[4][1] == 'B' && g_r[4][2] == 0 && g_r[4][3] == 0);       /* the string with its NUL, over the cleared buffer */
    CK(get16(g_r[4], 0x23) == 0x5566 && get16(g_r[4], 0x27) == 0x7788);
    CK(g_r[4][0x25] == 0 && g_r[4][0xaba - 1] == 0 && g_r[4][0xaba] == 0x77);           /* exactly 0xaba bytes cleared */
    for (i = 0; i < 16; i++) CK(g_r[4][0xac + i] == g_r[2][0x35 + i]);
    CK(get32(g_r[1], 4) == RVA(2) + 0x45 && get32(g_r[1], 8) == 0x55);
    init_setup("0123456789abcdef0123456789abcdef01234567", RVA(4));                        /* 40 characters: the two words overwrite the copy */
    g_w.word_63a4cd = 0x100;                                                              /* non-zero word: the trace call */
    CK(m4895cc_init_buffer(SELF, RVA(1), RVA(1) + 4, RVA(1) + 8, &g_w, &g_host) == 0);
    /* word q+0x21 = '1' '2' goes to 0x23, word q+0x23 = '3' '4' to 0x27 (read from the source, stored after the copy): 0x28 held the NUL */
    CK(g_r[4][0x22] == '2' && g_r[4][0x23] == '1' && g_r[4][0x24] == '2' && g_r[4][0x25] == '5' && g_r[4][0x26] == '6' && g_r[4][0x27] == '3' && g_r[4][0x28] == '4' && g_r[4][0x29] == 0);
    CK(L.n == 3);
    CKC(2, 0x44a2b7, 0, 1, 0x54e0ac);
    init_setup("", RVA(4));
    m4895cc_init_buffer(SELF, RVA(1), RVA(1) + 4, RVA(1) + 8, &g_w, &g_host);
    CK(g_r[4][0] == 0 && L.n == 2);
    init_setup("X", 0);                                                                  /* the allocation fails: reports, then (native) rejection */
    CK(m4895cc_init_buffer(SELF, RVA(1), RVA(1) + 4, RVA(1) + 8, &g_w, &g_host) == 1);
    CK(L.n == 4);
    CKC(0, 0x51dc43, 0, 1, 0xaba);
    CKC(1, 0x50ca3e, 0, 4, 0x63888b, 0x54e064, 0xcafe0001u, 0xfffffffeu);
    CKC(2, 0x42639d, 0x583979, 2, 0x54e090, 0x63888b);
    CKC0(3, 0x4c97b4, 0x5cf659);
    CK(get32(g_r[1], 0) == 0 && get32(g_r[1], 8) == 0x10 && get32(SELF, 0x1c) != 0);      /* [p0] = 0; nothing else touched */
}

/* ---- 0x4c3efb ------------------------------------------------------------------------------------------------------------------ */
static void lock_setup(void)
{
    int i;
    setup();
    set32(SELF, 0xc, RVA(1));
    set32(SELF, 0x14, 0x1000);
    set16(SELF, 0x18, 0x8000);
    set16(SELF, 0x1a, 0xfffe);
    set32(SELF, 0x1c, 0x40);
    set16(SELF, 0x20, 4);
    for (i = 0; i < 8; i++) set32(SELF, 0x22 + (size_t)i * 4, 0x01010101u * (uint32_t)(i + 1));
    set32(SELF, 0x42, 0x99);
    set32(g_r[2], 0x64, 0x7e000900u);
    set32(g_r[1], 0, RVA(2));
    memset(g_r[4], 0xcc, RSZ);
    for (i = 0; i < 4; i++) set32(g_r[3], (size_t)i * 4, 0);
}
static void test_m4c3efb_lock_surface(void)
{
    int i;
    lock_setup();
    m4c3efb_lock_surface(SELF, RVA(1), 0, RVA(4), 0x1111, &g_host);
    CK(L.n == 0);
    CK(get32(g_r[4], 0x24) == 0x1000 && get32(g_r[4], 8) == 0xfffffffeu && get32(g_r[4], 0xc) == 0xffff8000u);       /* [0x1a] -> +8, [0x18] -> +0xc */
    CK(get32(g_r[4], 0) == 0x6c && get32(g_r[4], 4) == 0x99 && get32(g_r[4], 0x10) == 0x40);
    for (i = 0; i < 8; i++) CK(get32(g_r[4], 0x48 + (size_t)i * 4) == 0x01010101u * (uint32_t)(i + 1));
    CK(get32(g_r[4], 0x68) == 0xcccccccc && get32(g_r[4], 0x44) == 0xcccccccc && get32(g_r[4], 0x14) == 0xcccccccc && get32(g_r[4], 0x28) == 0xcccccccc);
    lock_setup();
    set32(g_r[3], 0, 2); set32(g_r[3], 4, 3); set32(g_r[3], 8, 5); set32(g_r[3], 0xc, 7);       /* x0 = 2, y0 = 3, x1 = 5, y1 = 7 */
    m4c3efb_lock_surface(SELF, RVA(1), RVA(3), RVA(4), 0, &g_host);
    CK(get32(g_r[4], 0x24) == 0x1000 + 3 * 0x40 + 2 * 4 && get32(g_r[4], 8) == 5 && get32(g_r[4], 0xc) == 4 && get32(g_r[4], 0) == 0x6c);
    CK(L.n == 0);
    lock_setup();
    set16(SELF, 0x20, 0xffff);                                                            /* -1 */
    set32(g_r[3], 0, 2); set32(g_r[3], 4, 3); set32(g_r[3], 8, 1); set32(g_r[3], 0xc, 2);
    m4c3efb_lock_surface(SELF, RVA(1), RVA(3), RVA(4), 0, &g_host);
    CK(get32(g_r[4], 0x24) == 0x1000 + 3 * 0x40 - 2);                                      /* x0 * (signed word -1) */
    CK(get32(g_r[4], 8) == 0 && get32(g_r[4], 0xc) == 0);                                  /* y1 - y0 + 1 = 0, x1 - x0 + 1 = 0 */
    /* the lock path */
    lock_setup();
    set32(SELF, 0xc, RVA(1) ^ 1u);
    script(0x7e000900u, 4, 0x887601c2u, 0x8876021cu, 0x80004005u, 0);
    script(0x4c88c7, 1, 0x5551, 0, 0, 0);
    m4c3efb_lock_surface(SELF, RVA(1), RVA(3), RVA(4), 0x1234, &g_host);
    CK(L.n == 8);
    CKC(0, 0x7e000900u, 0, 5, RVA(1), RVA(3), RVA(4), 0x800, 0);
    CK(L.c[0].probe[0] == 0x6c);                                                          /* desc[0] is set before the first call */
    CKC0(1, 0x4c4dc3, SELFP);                                                             /* 0x887601c2: restore, then again */
    CKC(2, 0x7e000900u, 0, 5, RVA(1), RVA(3), RVA(4), 0x800, 0);
    CKC(3, 0x7e000900u, 0, 5, RVA(1), RVA(3), RVA(4), 0x800, 0);                          /* 0x8876021c: again, nothing else */
    CKC(4, 0x4c88c7, SELFP, 1, 0x80004005u);
    CKC(5, 0x50ca3e, 0, 4, 0x63888b, 0x554368, 0x1234, 0x5551);
    CKC(6, 0x4264e8, 0x583979, 1, 0x63888b);
    CKC(7, 0x7e000900u, 0, 5, RVA(1), RVA(3), RVA(4), 0x800, 0);
    CK(get32(g_r[4], 0) == 0x6c && get32(g_r[4], 0x24) == 0xcccccccc && get32(g_r[4], 0x48) == 0xcccccccc);       /* the lock path leaves the rest to the callee */
    lock_setup();
    set32(SELF, 0xc, 0);
    script(0x7e000900u, 1, 0, 0, 0, 0);
    m4c3efb_lock_surface(SELF, RVA(1), 0, RVA(4), 9, &g_host);
    CK(L.n == 1);
    CKC(0, 0x7e000900u, 0, 5, RVA(1), 0, RVA(4), 0x800, 0);
    lock_setup();
    set32(SELF, 0xc, RVA(1) + 0x10000u);
    g_nscript = 0;
    script(0x7e000900u, 3, 0x887601c3u, 0x8876021du, 0, 0);                              /* neighbours of the two special codes are reported as errors */
    m4c3efb_lock_surface(SELF, RVA(1), 0, RVA(4), 9, &g_host);
    CK(L.n == 9);
    CKC(1, 0x4c88c7, SELFP, 1, 0x887601c3u);
    CKC(2, 0x50ca3e, 0, 4, 0x63888b, 0x554368, 9, 0);
    CKC(3, 0x4264e8, 0x583979, 1, 0x63888b);
    CKC(5, 0x4c88c7, SELFP, 1, 0x8876021du);
    CKC(8, 0x7e000900u, 0, 5, RVA(1), 0, RVA(4), 0x800, 0);
}

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
        for (i = 0; i < (int)sizeof g_tbl; i++) g_tbl[i] = (uint8_t)(seed >> (i & 15));
        for (i = 0; i < 64; i++) g_words[i] = (uint8_t)(seed >> (i & 7));
        m4d39f9_find_free_entry(&g_w, &g_host);
        m4d3992_clear_entry((seed >> 3) % 0x58, &g_w, &g_host);
        m4c92c5_count_down(((seed >> 5) % 8) - 4, &g_w, &g_host);
        m4c948f_find_free_slot(SELF, &g_host);
        L.n = 0;
        /* the surface scan and fill with sizes inside the buffers */
        set32(g_r[1], 0, RVA(3) + PIX);
        set16(g_r[1], 0x2f, (uint16_t)(seed % 0x40));
        set16(g_r[1], 0x2b, (uint16_t)(seed % 9));
        set16(g_r[1], 0x2d, (uint16_t)((seed >> 4) % 9));
        for (i = 0; i < 4; i++) set32(g_r[2], (size_t)i * 4, (seed >> (4 * i)) % 4);
        g_w.word_639895 = (int16_t)(1 + seed % 3);
        m4c9340_scan_surface(SELF, RVA(1), RVA(2), &g_w, &g_host);
        set32(g_r[1], 0, RVA(5));
        m4c46d1_fill_surface(SELF, RVA(1), seed, seed >> 3, seed >> 6, &g_host);
        L.n = 0;
        g_nscript = 0;
        script(0x7e000900u, 2, 0x887601c2u, 0, 0, 0);
        set32(g_r[1], 0, RVA(2));
        set32(g_r[2], 0x64, 0x7e000900u);
        set32(g_r[2], 0x80, 0x7e000900u);
        m4c4202_check_vtable_call(SELF, RVA(1), seed, &g_host);
        m4c3efb_lock_surface(SELF, RVA(1), RVA(3), RVA(4), seed, &g_host);
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
    RUN(test_m4d39f9_find_free_entry);
    RUN(test_m4c4202_check_vtable_call);
    RUN(test_m4c948f_find_free_slot);
    RUN(test_m4d3992_clear_entry);
    RUN(test_m4c92c5_count_down);
    RUN(test_m4c9340_scan_surface);
    RUN(test_m4c46d1_fill_surface);
    RUN(test_m4cb9d1_relocate_entries);
    RUN(test_m4895cc_init_buffer);
    RUN(test_m4c3efb_lock_surface);
    RUN(test_sweep_bounded);
    return failures;
}
