/* FL-32 (batch c) direct tests of the small game rows of GAME.EXE in src/original_methods_fl32c.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the failure
 * count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl32c_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl32c.h"

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

#define RSZ 0x4000
static uint8_t g_r[8][RSZ];
static uint8_t g_tbl[0x4a * 0x70];
static Fl32cWorld g_w;
static Fl18Host g_host;
#define SELF g_r[0]

static void set32(uint8_t *b, size_t off, uint32_t v) { memcpy(b + off, &v, 4); }
static void set16(uint8_t *b, size_t off, uint16_t v) { memcpy(b + off, &v, 2); }
static uint32_t get32(const uint8_t *b, size_t off) { uint32_t v; memcpy(&v, b + off, 4); return v; }

#define MAXCALL 64
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[6];
        uint8_t sp[0x30];        /* the first 0x30 bytes of self (region 0) at the call */
        uint32_t slots[3];       /* the three dwords behind the first argument of 0x437774 at the call */
        uint32_t g5d1717;        /* the world's value_5d1717 at the call */
    } c[MAXCALL];
} L;
static struct {
    uint32_t callee, results[8];
    int n, used;
} S[4];
static int g_nscript;
static void script(uint32_t callee, int n, uint32_t r0, uint32_t r1)
{
    S[g_nscript].callee = callee;
    S[g_nscript].n = n;
    S[g_nscript].used = 0;
    S[g_nscript].results[0] = r0;
    S[g_nscript].results[1] = r1;
    g_nscript++;
}
static int g_rewrite;                  /* the callee 0x437774 writes 11, 22, 33 through its three pointers */
static void (*g_on_call)(uint32_t callee);

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
        memcpy(L.c[i].sp, g_r[0], sizeof L.c[i].sp);
        L.c[i].g5d1717 = g_w.value_5d1717;
        if (callee == 0x437774 && nargs == 3) memcpy(L.c[i].slots, (const void *)args[0], 12);
    }
    L.n++;
    if (callee == 0x437774 && nargs == 3 && g_rewrite) {
        uint32_t v;
        v = 11; memcpy((void *)args[0], &v, 4);
        v = 22; memcpy((void *)args[1], &v, 4);
        v = 33; memcpy((void *)args[2], &v, 4);
    }
    if (g_on_call != NULL) g_on_call(callee);
    for (k = 0; k < g_nscript; k++)
        if (S[k].callee == callee && S[k].n > 0) {
            result = S[k].results[S[k].used < S[k].n ? S[k].used : S[k].n - 1];
            S[k].used++;
        }
    return result;
}

static void setup(void)
{
    size_t b, i;
    for (i = 0; i < 8; i++)
        for (b = 0; b < RSZ; b++) g_r[i][b] = (uint8_t)(b * 7 + 3 + i);
    memset(g_tbl, 0, sizeof g_tbl);
    memset(&g_w, 0, sizeof g_w);
    g_w.table_5d15a5 = g_tbl + 3 * 0x4a;
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    L.n = 0;
    g_nscript = 0;
    g_rewrite = 0;
    g_on_call = NULL;
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

/* ---- 0x44e78e ------------------------------------------------------------------------------------------------------------------ */
static void change_word(uint32_t callee)
{
    if (callee == 0x4c2dfb) set16(SELF, 0x1c, 0xffff);
}
static void test_m44e78e_release_entry(void)
{
    setup();
    memset(SELF, 0x33, 0x100);
    set32(SELF, 0x20, 0);
    set16(SELF, 0x1c, 0xffff);
    m44e78e_release_entry(SELF, &g_host);
    CK(L.n == 1);                                                          /* no field, word -1: only the reset */
    CKC0(0, 0x44e767, SELFP);
    setup();
    memset(SELF, 0x33, 0x100);
    set32(SELF, 0x20, 0x10000u);                                           /* non-zero with a zero low word is still non-zero (dword compare) */
    set16(SELF, 0x1c, 0x8000);                                             /* the word is passed as it is, not sign-extended */
    set16(SELF, 0x1e, 0xffff);
    m44e78e_release_entry(SELF, &g_host);
    CK(L.n == 3);
    CKC(0, 0x4c2dfb, 0x5cf659, 1, SELFP + 0x20);                           /* the address of the field */
    CKC(1, 0x4d3992, 0, 1, 0x8000);
    CKC0(2, 0x44e767, SELFP);
    setup();
    memset(SELF, 0x33, 0x100);
    set32(SELF, 0x20, 0);
    set16(SELF, 0x1c, 0x7fff);
    set16(SELF, 0x1e, 0);
    m44e78e_release_entry(SELF, &g_host);
    CK(L.n == 2);
    CKC(0, 0x4d3992, 0, 1, 0x7fff);
    CKC0(1, 0x44e767, SELFP);
    setup();
    set32(SELF, 0x20, 0);
    set16(SELF, 0x1c, 0xfffe);                                             /* -2 is a value, not the sentinel */
    m44e78e_release_entry(SELF, &g_host);
    CKC(0, 0x4d3992, 0, 1, 0xfffe);
    setup();
    set32(SELF, 0x20, 5);
    set16(SELF, 0x1c, 0);                                                  /* 0 is a value too */
    g_on_call = change_word;                                               /* the first callee makes the word -1: it is read again afterwards */
    m44e78e_release_entry(SELF, &g_host);
    CK(L.n == 2);
    CKC(0, 0x4c2dfb, 0x5cf659, 1, SELFP + 0x20);
    CKC0(1, 0x44e767, SELFP);
}

/* ---- 0x44e7d7 ------------------------------------------------------------------------------------------------------------------ */
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
static void test_m44e7d7_mark_entry(void)
{
    setup();
    tbl_fill();
    memset(SELF, 0x33, 0x100);
    set32(SELF, 0x6b, 0);
    set16(SELF, 0x1c, 3);
    SELF[0x6a] = 0xff;                              /* the bytes around the zero gate do not matter */
    SELF[0x6f] = 0xff;
    m44e7d7_mark_entry(SELF, &g_w);
    CK(tbl_is(99));                                 /* the gate dword [self+0x6b] == 0: nothing */
    set32(SELF, 0x6b, 0x10000u);                    /* non-zero with a zero low word is still non-zero (dword compare) */
    set16(SELF, 0x1c, 0xffff);
    m44e7d7_mark_entry(SELF, &g_w);
    CK(tbl_is(99));                                 /* word -1: nothing */
    set16(SELF, 0x1c, 3);
    m44e7d7_mark_entry(SELF, &g_w);
    CK(tbl_is(3));
    tbl_fill();
    set32(SELF, 0x6b, 0xff000000u);
    set16(SELF, 0x1c, 0xfffe);                      /* -2 is an index (sign-extended word), not the sentinel */
    set16(SELF, 0x1e, 0xffff);
    m44e7d7_mark_entry(SELF, &g_w);
    CK(tbl_is(-2));
    tbl_fill();
    set16(SELF, 0x1c, 0xfffd);
    m44e7d7_mark_entry(SELF, &g_w);
    CK(tbl_is(-3));
    tbl_fill();
    set16(SELF, 0x1c, 0);
    m44e7d7_mark_entry(SELF, &g_w);
    CK(tbl_is(0));
    tbl_fill();
    set16(SELF, 0x1c, 0x2a);
    m44e7d7_mark_entry(SELF, &g_w);
    CK(tbl_is(0x2a));
    CK(L.n == 0);
}

/* ---- 0x44e95b ------------------------------------------------------------------------------------------------------------------ */
static void test_m44e95b_offset_rect(void)
{
    uint8_t *m = g_r[1];
    setup();
    g_w.value_583186 = 1000;                        /* x */
    g_w.value_58318a = 5;                           /* y */
    memset(m, 0xaa, 0x80);
    set32(m, 0, 10);
    set32(m, 4, 20);
    set32(m, 8, 30);
    set32(m, 0xc, 40);
    m44e95b_offset_rect(m, m + 0x20, &g_w);        /* distinct rectangles: x is added to the dwords at 0 and 8, y to those at 4 and 0xc */
    CK(get32(m, 0x20) == 1010 && get32(m, 0x24) == 25 && get32(m, 0x28) == 1030 && get32(m, 0x2c) == 45);
    CK(get32(m, 0) == 10 && get32(m, 4) == 20 && get32(m, 8) == 30 && get32(m, 0xc) == 40);
    CK(get32(m, 0x30) == 0xaaaaaaaau && get32(m, 0x1c) == 0xaaaaaaaau);       /* nothing else is written */
    m44e95b_offset_rect(m, m, &g_w);                 /* in place */
    CK(get32(m, 0) == 1010 && get32(m, 4) == 25 && get32(m, 8) == 1030 && get32(m, 0xc) == 45);
    set32(m, 0, 10);
    set32(m, 4, 20);
    set32(m, 8, 30);
    set32(m, 0xc, 40);
    set32(m, 0x10, 0xaaaaaaaau);
    m44e95b_offset_rect(m, m + 4, &g_w);             /* overlapping: dst+4 = src+8 gets src[4]+y first; dst+8 = src+0xc then reads src[8] which that store has changed */
    CK(get32(m, 0) == 10 && get32(m, 4) == 1010 && get32(m, 8) == 25 && get32(m, 0xc) == 1025 && get32(m, 0x10) == 45);
    set32(m, 4, 20);
    set32(m, 8, 30);
    set32(m, 0xc, 40);
    set32(m, 4, 20);
    set32(m, 8, 30);
    set32(m, 0xc, 40);
    m44e95b_offset_rect(m + 4, m, &g_w);             /* dst below src (src = {20,30,40,45}): dst+4 = src+0 gets src[4]+y = 35, dst+0xc = src+8 gets src[0xc]+y = 50, then dst+0 gets
                                                        src[0]+x (src[0] is now 35) = 1035 and dst+8 = src+0xc gets src[8] (now 50) + x = 1050 */
    CK(get32(m, 0) == 1035 && get32(m, 4) == 35 && get32(m, 8) == 1050 && get32(m, 0xc) == 50 && get32(m, 0x10) == 45);
    set32(m, 0, 10);
    set32(m, 4, 20);
    set32(m, 8, 30);
    set32(m, 0xc, 40);
    set32(m, 0x10, 0xaaaaaaaau);
    set32(m, 0x14, 0xaaaaaaaau);
    m44e95b_offset_rect(m, m + 8, &g_w);             /* dst = src + 8: dst+4 = src+0xc gets 25, dst+0xc = src+0x14 gets src[0xc] (now 25) + y = 30, dst+0 = src+8 gets 1010, and dst+8 = src+0x10 gets
                                                        src[8] (now 1010) + x = 2010 */
    CK(get32(m, 0) == 10 && get32(m, 4) == 20 && get32(m, 8) == 1010 && get32(m, 0xc) == 25 && get32(m, 0x10) == 2010 && get32(m, 0x14) == 30);
    g_w.value_583186 = 0xffffffffu;                 /* wrapping adds */
    g_w.value_58318a = 0x80000000u;
    set32(m, 0x40, 1);
    set32(m, 0x44, 0x80000000u);
    set32(m, 0x48, 2);
    set32(m, 0x4c, 0xffffffffu);
    m44e95b_offset_rect(m + 0x40, m + 0x60, &g_w);
    CK(get32(m, 0x60) == 0 && get32(m, 0x64) == 0 && get32(m, 0x68) == 1 && get32(m, 0x6c) == 0x7fffffffu);
    CK(L.n == 0);
}

/* ---- 0x43edac ------------------------------------------------------------------------------------------------------------------ */
static void test_m43edac_default_after_query(void)
{
    uint32_t r;
    setup();
    script(0x51ab4b, 1, 0x12345678u, 0);
    r = m43edac_default_after_query(SELF, 1, 2, 3, &g_host);
    CK(r == 0x12345678u);                                                   /* eax of the final call */
    CK(L.n == 2);
    CK(L.c[0].callee == 0x437774 && L.c[0].this_ptr == 0x583208 && L.c[0].nargs == 3);
    CK(L.c[0].a[1] == L.c[0].a[0] + 4 && L.c[0].a[2] == L.c[0].a[0] + 8);   /* pointers to the argument slots a8, ac, a10 in this order */
    CK(L.c[0].slots[0] == 1 && L.c[0].slots[1] == 2 && L.c[0].slots[2] == 3);
    CKC0(1, 0x51ab4b, SELFP);
    setup();
    g_rewrite = 1;
    script(0x51ab4b, 1, 0xffffffffu, 0);
    r = m43edac_default_after_query(SELF, 0xdeadbeefu, 0, 0x80000000u, &g_host);
    CK(r == 0xffffffffu);
    CK(L.n == 2 && L.c[0].slots[0] == 0xdeadbeefu && L.c[0].slots[1] == 0 && L.c[0].slots[2] == 0x80000000u);       /* the values the callee sees are the arguments */
    CKC0(1, 0x51ab4b, SELFP);
    setup();
    r = m43edac_default_after_query(SELF, 0, 0, 0, &g_host);
    CK(r == 0 && L.n == 2);
}

/* ---- 0x43ee69 ------------------------------------------------------------------------------------------------------------------ */
static void filt(uint32_t msg, uint32_t w, uint32_t l, int calls, uint32_t want)
{
    uint32_t r;
    setup();
    script(0x51b461, 1, 0xc0ffee00u, 0);
    r = m43ee69_filter_message(SELF, msg, w, l, &g_host);
    CK(r == want);
    CK(L.n == calls);
    if (calls) CKC(0, 0x51b461, SELFP, 3, msg, w, l);                       /* args[0] = msg (pushed last), then wparam, lparam */
}
static void test_m43ee69_filter_message(void)
{
    (void)m43ee69_filter_message;                   /* the evidence scan reads the symbol from the test body */
    filt(0x14, 0xf140, 5, 0, 1);                    /* WM_ERASEBKGND -> 1, before any look at wparam */
    filt(0x112, 0xf140, 5, 0, 0);
    filt(0x112, 0xf170, 5, 0, 0);
    filt(0x112, 0xf14f, 5, 0, 0);                   /* the low nibble is masked */
    filt(0x112, 0x1f170, 5, 0, 0);                  /* so are the bits above 16 */
    filt(0x112, 0xf150, 5, 1, 0xc0ffee00u);
    filt(0x112, 0xf160, 6, 1, 0xc0ffee00u);
    filt(0x112, 0xf130, 7, 1, 0xc0ffee00u);
    filt(0x112, 0x0140, 8, 1, 0xc0ffee00u);
    filt(0x112, 0, 0, 1, 0xc0ffee00u);
    filt(0x113, 0xf140, 9, 1, 0xc0ffee00u);         /* another message: the command is not looked at */
    filt(0x10014, 0xf140, 9, 1, 0xc0ffee00u);       /* the compares are dword compares */
    filt(0x10112, 0xf140, 9, 1, 0xc0ffee00u);
    filt(0x80000014u, 0, 0xffffffffu, 1, 0xc0ffee00u);
    filt(0xffffffffu, 0xffffffffu, 0xffffffffu, 1, 0xc0ffee00u);
    filt(0x15, 0, 0, 1, 0xc0ffee00u);
    filt(0x13, 0, 0, 1, 0xc0ffee00u);
}

/* ---- 0x4db090 ------------------------------------------------------------------------------------------------------------------ */
static void state(uint32_t g, uint32_t f4, uint32_t f10, uint32_t want4, uint32_t want10)
{
    setup();
    memset(SELF, 0x66, 0x40);
    g_w.value_5c39e5 = g;
    set32(SELF, 4, f4);
    set32(SELF, 0x10, f10);
    set32(SELF, 0xc, 0x77777777u);
    m4db090_normalize_state(SELF, &g_w);
    CK(get32(SELF, 4) == want4);
    CK(get32(SELF, 0x10) == want10);
    CK(get32(SELF, 0xc) == 0);
    CK(get32(SELF, 0) == 0x66666666u && get32(SELF, 8) == 0x66666666u && get32(SELF, 0x14) == 0x66666666u);
    CK(L.n == 0);
}
static void test_m4db090_normalize_state(void)
{
    (void)m4db090_normalize_state;  /* the evidence scan reads the symbol from the test body */
    state(0xffffffffu, 0, 1, 0, 2);                 /* the selector is -1: [self+4] stays 0 */
    state(0, 0, 1, 1, 2);
    state(5, 0, 0, 1, 0);
    state(0xffff, 0, 2, 1, 2);                      /* a dword compare: 0xffff is not -1 */
    state(0x10000, 1, 0x101, 1, 0x101);             /* [self+4] != 0 stays; [self+0x10] must be exactly 1 */
    state(0xfffffffeu, 0x100, 0x10001, 0x100, 0x10001);
    state(7, 0x10000, 1, 0x10000, 2);
    state(0xffffffffu, 0x100, 1, 0x100, 2);
}

/* ---- 0x4de53e ------------------------------------------------------------------------------------------------------------------ */
static void change_global(uint32_t callee)
{
    if (callee == 0x4ee630) g_w.value_5cf665 = 0xabcdef01u;
}
static void test_m4de53e_report(void)
{
    setup();
    script(0x4ee630, 1, 0, 0);
    g_w.value_5cf665 = 0x1234;
    m4de53e_report(SELF, &g_w, &g_host);
    CK(L.n == 1);                                   /* p == 0: nothing else */
    CKC0(0, 0x4ee630, SELFP);
    setup();
    script(0x4ee630, 1, 0x10000u, 0);
    g_w.value_5cf665 = 0x1234;
    m4de53e_report(SELF, &g_w, &g_host);
    CK(L.n == 2);
    CKC0(0, 0x4ee630, SELFP);
    CKC(1, 0x4c5377, 0x5cf659, 5, 0x10000u, 0x1234, SELFP + 0x981, 0x5b0227, 0x55b8d0);       /* args[0] = p (pushed last) ... the string addresses (pushed first) */
    setup();
    script(0x4ee630, 1, 0xffffffffu, 0);
    g_w.value_5cf665 = 0x1;
    g_on_call = change_global;                      /* the global is read after the first call */
    m4de53e_report(SELF, &g_w, &g_host);
    CKC(1, 0x4c5377, 0x5cf659, 5, 0xffffffffu, 0xabcdef01u, SELFP + 0x981, 0x5b0227, 0x55b8d0);
}

/* ---- 0x4ea229 ------------------------------------------------------------------------------------------------------------------ */
static void test_m4ea229_clear_pending(void)
{
    setup();
    g_w.value_5d1717 = 0x80000000u;
    g_w.word_63a4cd = 0;
    m4ea229_clear_pending(SELF, &g_w, &g_host);
    CK(L.n == 1);
    CKC(0, 0x4c2dfb, 0x5cf659, 1, SELFP + 0x699);
    CK(L.c[0].g5d1717 == 0x80000000u);              /* the store comes after the first call */
    CK(g_w.value_5d1717 == 0);
    setup();
    g_w.value_5d1717 = 0x10000u;
    g_w.word_63a4cd = (int16_t)0x8000;              /* any non-zero word */
    m4ea229_clear_pending(SELF, &g_w, &g_host);
    CK(L.n == 2);
    CKC(1, 0x44a2b7, 0, 1, 0x55cb10);
    CK(L.c[1].g5d1717 == 0);                        /* and before the second */
    CK(g_w.value_5d1717 == 0);
    setup();
    g_w.word_63a4cd = 0x100;
    m4ea229_clear_pending(SELF, &g_w, &g_host);
    CK(L.n == 2);
    setup();
    g_w.word_63a4cd = -1;
    m4ea229_clear_pending(SELF, &g_w, &g_host);
    CK(L.n == 2);
}

/* ---- 0x4fb2a6 ------------------------------------------------------------------------------------------------------------------ */
static uint8_t g_big[0x10400];
static void slot(uint32_t a, uint32_t b, uint16_t word_at_slot, int calls, uint32_t want_e)
{
    uint32_t idx = (b & 0xffff) * 0x5bb;
    setup();
    memset(g_big, 0xff, sizeof g_big);                 /* the bytes around the word are non-zero */
    set16(g_big, idx + 0x132, word_at_slot);
    m4fb2a6_check_slot(g_big, a, b, &g_host);
    CK(L.n == calls);
    if (calls) CKC(0, 0x4faf98, (uintptr_t)g_big, 2, a, want_e);
}
static void test_m4fb2a6_check_slot(void)
{
    (void)m4fb2a6_check_slot;  /* the evidence scan reads the symbol from the test body */
    slot(0x1111, 0, 1, 0, 0);
    slot(0x1111, 0, 0, 1, 0);                          /* slot 0: the word at +0x132 */
    slot(0x2222, 1, 0, 1, 1);                          /* slot 1: +0x6ed; the pushed eax is the index with its low word replaced by the word of b (the upper half of 0x5bb is 0) */
    slot(0x2222, 2, 0, 1, 2);
    slot(0x3333, 3, 0x8000, 0, 0);
    slot(0x3333, 3, 0xff, 0, 0);
    slot(0x3333, 3, 0x100, 0, 0);
    slot(0x4444, 3, 0, 1, 3);
    slot(0xdeadbeefu, 0xffff0003u, 0, 1, 3);           /* the high half of b is masked away */
    slot(0x5555, 0x2c, 0, 1, 0x2c);                    /* 0x2c * 0x5bb = 0xfc24: upper half 0 */
    slot(0x6666, 0x2d, 0, 1, 0x1002d);                 /* 0x2d * 0x5bb = 0x101df: the upper half (1) stays in the pushed eax: 0x0001002d */
    slot(0x6666, 0x2d, 0x4000, 0, 0);
    slot(0x7777, 0x0001002d, 0, 1, 0x1002d);           /* and b's own high half is masked before the multiply */
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
        for (i = 0; i < (int)sizeof g_tbl; i++) g_tbl[i] = (uint8_t)(seed >> (i & 15));
        /* the indices are kept inside the table: the word at self+0x1c is reduced to -3 .. 0x6b */
        set16(SELF, 0x1c, (uint16_t)((int)(seed % 0x70) - 3));
        set32(SELF, 0x20, seed);
        set32(SELF, 0x6b, seed >> 1);
        script(0x4ee630, 1, seed >> 2, 0);
        m44e78e_release_entry(SELF, &g_host);
        m44e7d7_mark_entry(SELF, &g_w);
        g_w.value_583186 = seed;
        g_w.value_58318a = seed >> 3;
        m44e95b_offset_rect(g_r[1], g_r[1] + (seed & 0x3c), &g_w);
        m43edac_default_after_query(SELF, seed, seed >> 1, seed >> 2, &g_host);
        m43ee69_filter_message(SELF, (seed & 1) ? 0x112 : seed >> 4, 0xf000u + (seed >> 5), seed, &g_host);
        g_w.value_5c39e5 = (seed & 2) ? 0xffffffffu : seed;
        m4db090_normalize_state(SELF, &g_w);
        g_w.value_5cf665 = seed >> 6;
        m4de53e_report(SELF, &g_w, &g_host);
        g_w.word_63a4cd = (int16_t)(seed >> 7);
        m4ea229_clear_pending(SELF, &g_w, &g_host);
        m4fb2a6_check_slot(SELF, seed, seed % 3, &g_host);        /* b is kept below 3: idx + 0x132 stays inside the region */
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
    RUN(test_m44e78e_release_entry);
    RUN(test_m44e7d7_mark_entry);
    RUN(test_m44e95b_offset_rect);
    RUN(test_m43edac_default_after_query);
    RUN(test_m43ee69_filter_message);
    RUN(test_m4db090_normalize_state);
    RUN(test_m4de53e_report);
    RUN(test_m4ea229_clear_pending);
    RUN(test_m4fb2a6_check_slot);
    /* RUN-END */
    RUN(test_sweep_bounded);
    return failures;
}
