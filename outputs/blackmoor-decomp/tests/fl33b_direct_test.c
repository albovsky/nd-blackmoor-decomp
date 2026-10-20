/* FL-33 (batch b) direct tests of the methods of GAME.EXE in src/original_methods_fl33b.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the failure count.
 * Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl33b_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl33b.h"

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
#define RSZ 0x10000
static uint8_t g_r[8][RSZ];
static uint8_t g_c1[0x10], g_c2[0x9000];     /* the constants at 0x54d158 and at 0x54388c (the second is large so that a long string at 0x543890 can wrap the 16-bit offset) */
static uint8_t g_rec[0x8d * 8], g_tab[0x4a * 8];
static Fl33bWorld g_w;
static Fl18Host g_host;
#define SELF g_r[0]

static void set32(uint8_t *b, size_t off, uint32_t v) { memcpy(b + off, &v, 4); }
static void set16(uint8_t *b, size_t off, uint16_t v) { memcpy(b + off, &v, 2); }
static uint32_t get32(const uint8_t *b, size_t off) { uint32_t v; memcpy(&v, b + off, 4); return v; }
static uint16_t get16(const uint8_t *b, size_t off) { uint16_t v; memcpy(&v, b + off, 2); return v; }

#define MAXCALL 64
typedef struct {
    uint32_t callee;
    uintptr_t this_ptr;
    int nargs;
    uintptr_t a[11];
    uint8_t snap[2][128];      /* the bytes behind the pointer arguments named by sc_deref, as they are at the call */
} Call;
static Call L[MAXCALL];
static int Ln;
static struct {
    uint32_t callee, res[16];
    int n, used, darg[2], dn[2];
} S[16];
static int Sn;
static struct {
    uint32_t callee;
    int call, arg, off, n;
    uint8_t b[64];
} Wr[16];
static int Wn;

static int sidx(uint32_t callee)
{
    int i;
    for (i = 0; i < Sn; i++)
        if (S[i].callee == callee) return i;
    memset(&S[Sn], 0, sizeof S[Sn]);
    S[Sn].callee = callee;
    S[Sn].darg[0] = S[Sn].darg[1] = -1;
    return Sn++;
}
static void sc_res(uint32_t callee, int n, uint32_t r0, uint32_t r1, uint32_t r2)
{
    int i = sidx(callee);
    S[i].n = n;
    S[i].res[0] = r0;
    S[i].res[1] = r1;
    S[i].res[2] = r2;
}
static void sc_deref(uint32_t callee, int which, int arg, int nbytes)
{
    int i = sidx(callee);
    S[i].darg[which] = arg;
    S[i].dn[which] = nbytes;
}
static void sc_write(uint32_t callee, int call, int arg, int off, const void *bytes, int n)
{
    Wr[Wn].callee = callee;
    Wr[Wn].call = call;
    Wr[Wn].arg = arg;
    Wr[Wn].off = off;
    Wr[Wn].n = n;
    memcpy(Wr[Wn].b, bytes, (size_t)n);
    Wn++;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (a >= RVA(0) && a < RVA(8)) return g_r[(a - RVA(0)) >> 16] + ((a - RVA(0)) & 0xffff);
    if (a >= 0x54d158 && a < 0x54d158 + sizeof g_c1) return g_c1 + (a - 0x54d158);
    if (a >= 0x54388c && a < 0x54388c + sizeof g_c2) return g_c2 + (a - 0x54388c);
    return NULL;
}

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int k, i = Ln, si = sidx(callee);
    uint32_t result = 0;
    (void)ctx;
    if (Ln < MAXCALL) {
        memset(&L[i], 0, sizeof L[i]);
        L[i].callee = callee;
        L[i].this_ptr = this_ptr;
        L[i].nargs = nargs;
        for (k = 0; k < nargs && k < 11; k++) L[i].a[k] = args[k];
        for (k = 0; k < 2; k++)
            if (S[si].darg[k] >= 0 && args[S[si].darg[k]] > 0xffffffffu) memcpy(L[i].snap[k], (const void *)args[S[si].darg[k]], (size_t)S[si].dn[k]);
    }
    Ln++;
    for (k = 0; k < Wn; k++)
        if (Wr[k].callee == callee && Wr[k].call == S[si].used) {
            uint8_t *p = Wr[k].arg < 0 ? (uint8_t *)host_resolve(NULL, (uint32_t)Wr[k].off) : (args[Wr[k].arg] > 0xffffffffu ? (uint8_t *)args[Wr[k].arg] : (uint8_t *)host_resolve(NULL, (uint32_t)args[Wr[k].arg])) + Wr[k].off;
            memcpy(p, Wr[k].b, (size_t)Wr[k].n);
        }
    if (S[si].n > 0) result = S[si].res[S[si].used < S[si].n ? S[si].used : S[si].n - 1];
    S[si].used++;
    return result;
}

static uint32_t host_tick(void *ctx)
{
    (void)ctx;
    return 0;
}

static void setup(void)
{
    size_t b, i;
    for (i = 0; i < 8; i++)
        for (b = 0; b < RSZ; b++) g_r[i][b] = (uint8_t)(b * 7 + 3 + i);
    for (b = 0; b < sizeof g_c1; b++) g_c1[b] = (uint8_t)('a' + b);
    for (b = 0; b < sizeof g_c2; b++) g_c2[b] = (uint8_t)('A' + b);
    memset(g_rec, 0x55, sizeof g_rec);
    memset(g_tab, 0x66, sizeof g_tab);
    memset(&g_w, 0, sizeof g_w);
    g_w.records_5bb5e5 = g_rec + 3 * 0x8d;
    g_w.table_5d1599 = g_tab + 2 * 0x4a;
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    g_host.tick = host_tick;
    Ln = 0;
    Sn = 0;
    Wn = 0;
}

static void ck_call(int line, int idx, uint32_t callee, uintptr_t this_ptr, int nargs, const uintptr_t *want)
{
    int k;
    if (g_failed) return;
    if (idx >= Ln || idx >= MAXCALL || L[idx].callee != callee || L[idx].this_ptr != this_ptr || L[idx].nargs != nargs) {
        g_failed = 1;
        snprintf(g_msg, sizeof g_msg, "line %d: call %d is not %x this %lx nargs %d (log has %d)", line, idx, (unsigned)callee, (unsigned long)this_ptr, nargs, Ln);
        return;
    }
    for (k = 0; k < nargs; k++)
        if (want[k] != (uintptr_t)-1 && L[idx].a[k] != want[k]) {
            g_failed = 1;
            snprintf(g_msg, sizeof g_msg, "line %d: call %d arg %d is %lx, want %lx", line, idx, k, (unsigned long)L[idx].a[k], (unsigned long)want[k]);
            return;
        }
}
#define ANY ((uintptr_t)-1)
#define CKC(idx, callee, thisp, nargs, ...)                        \
    do {                                                           \
        const uintptr_t w_[] = {__VA_ARGS__};                      \
        ck_call(__LINE__, (idx), (callee), (thisp), (nargs), w_);  \
    } while (0)
#define CKC0(idx, callee, thisp) ck_call(__LINE__, (idx), (callee), (thisp), 0, NULL)
#define SELFP ((uintptr_t)SELF)
#define IS_HOST(v) ((v) > 0xffffffffu)

/* ---- 0x47d02d ------------------------------------------------------------------------------------------------------------------ */
static void put_z(uint8_t *b, size_t off, const char *s) { memcpy(b + off, s, strlen(s) + 1); }
static void fill_z(uint8_t *b, size_t off, size_t n, char c)
{
    memset(b + off, c, n);
    b[off + n] = 0;
}
static void test_m47d02d_show_names(void)
{
    uint32_t rec = RVA(1) + 0x13;
    uint8_t *r = g_r[1] + 0x13;
    char want[128];
    setup();
    put_z(r, 0x31, "AB");
    put_z(r, 0x52, "xyz");
    set16(r, 0x21, 0x4321);
    put_z(g_r[2], 3, "hello");
    set32(g_r[3], 0, 0);
    sc_res(0x516530, 1, 0, 0, 0);
    CK(m47d02d_show_names(rec, &g_w, &g_host) == 0);
    CK(Ln == 1);                                                 /* 0x516530 returned 0: nothing else; the flag 0x5bb202 is clear */
    CKC(0, 0x516530, 0, 2, rec, 0x54d14c);
    /* result non-zero: 0x4fb77a then 0x4fb2e3 with the left-over upper half of the first result */
    setup();
    put_z(r, 0x31, "AB");
    set16(r, 0x21, 0x4321);
    sc_res(0x516530, 1, 5, 0, 0);
    sc_res(0x4fb77a, 1, 0xabcd1234u, 0, 0);
    CK(m47d02d_show_names(rec, &g_w, &g_host) == 0);
    CK(Ln == 3);
    CKC(1, 0x4fb77a, 0x5c3a67, 1, rec);
    CKC(2, 0x4fb2e3, 0x5c3a67, 1, 0xabcd4321u);
    /* flag on, the first string is not empty and 0x423259 names a string: it is copied with the 7 bytes at 0x54d158 over its NUL */
    setup();
    g_w.value_5bb202 = 7;
    g_w.value_5d03b3 = 0x1234;
    put_z(r, 0x31, "AB");
    put_z(r, 0x52, "xyz");
    put_z(g_r[2], 3, "hello");
    sc_res(0x516530, 1, 0, 0, 0);
    sc_res(0x423259, 1, RVA(2) + 3, 0, 0);
    sc_deref(0x448d11, 0, 1, 12);
    CK(m47d02d_show_names(rec, &g_w, &g_host) == 0);
    CK(Ln == 3);
    CKC(1, 0x423259, 0x619a6b, 1, rec + 0x31);
    CKC(2, 0x448d11, 0x619a05, 4, 0x1234, ANY, 0xffffffffu, 0);
    CK(IS_HOST(L[2].a[1]));
    memcpy(want, "hello", 5);
    memcpy(want + 5, g_c1, 7);
    CK(memcmp(L[2].snap[0], want, 12) == 0);                     /* "hello" and the 7 bytes at 0x54d158 */
    /* 0x423259 returns 0: the string at rec + 0x52 with the 7 bytes at 0x54d160 */
    Ln = 0;
    Sn = 0;
    sc_res(0x516530, 1, 0, 0, 0);
    sc_res(0x423259, 1, 0, 0, 0);
    sc_deref(0x448d11, 0, 1, 10);
    CK(m47d02d_show_names(rec, &g_w, &g_host) == 0);
    CK(Ln == 3);
    CKC(2, 0x448d11, 0x619a05, 4, 0x1234, ANY, 0xffffffffu, 0);
    memcpy(want, "xyz", 3);
    memcpy(want + 3, g_c1 + 8, 7);
    CK(memcmp(L[2].snap[0], want, 10) == 0);
    /* the first string empty: 0x423259 is not called */
    Ln = 0;
    Sn = 0;
    r[0x31] = 0;
    sc_res(0x516530, 1, 0, 0, 0);
    sc_deref(0x448d11, 0, 1, 10);
    CK(m47d02d_show_names(rec, &g_w, &g_host) == 0);
    CK(Ln == 2);
    CKC(1, 0x448d11, 0x619a05, 4, 0x1234, ANY, 0xffffffffu, 0);
    /* both strings empty: nothing but the compare */
    Ln = 0;
    Sn = 0;
    r[0x52] = 0;
    CK(m47d02d_show_names(rec, &g_w, &g_host) == 0);
    CK(Ln == 1);
    /* the string of 0x423259 is 0x9c41 bytes long: it is dropped and the second string is used */
    setup();
    g_w.value_5bb202 = 1;
    put_z(r, 0x31, "AB");
    put_z(r, 0x52, "q");
    fill_z(g_r[2], 0, 0x9c41, 'z');
    sc_res(0x516530, 1, 0, 0, 0);
    sc_res(0x423259, 1, RVA(2), 0, 0);
    sc_deref(0x448d11, 0, 1, 8);
    CK(m47d02d_show_names(rec, &g_w, &g_host) == 0);
    CK(Ln == 3);
    CK(L[2].snap[0][0] == 'q');
    /* the largest string that fits the 0x68 byte local (97 characters + 7 bytes) is accepted, one more is rejected before the copy */
    setup();
    g_w.value_5bb202 = 1;
    put_z(r, 0x31, "AB");
    fill_z(g_r[2], 0, 97, 'y');
    sc_res(0x516530, 1, 0, 0, 0);
    sc_res(0x423259, 1, RVA(2), 0, 0);
    sc_deref(0x448d11, 0, 1, 104);
    CK(m47d02d_show_names(rec, &g_w, &g_host) == 0);
    CK(Ln == 3);
    CK(L[2].snap[0][96] == 'y' && L[2].snap[0][97] == g_c1[0]);
    Ln = 0;
    Sn = 0;
    fill_z(g_r[2], 0, 98, 'y');
    sc_res(0x423259, 1, RVA(2), 0, 0);
    CK(m47d02d_show_names(rec, &g_w, &g_host) == 1);             /* native rejection: the original overruns its frame */
    CK(Ln == 2 && L[1].callee == 0x423259);
    Ln = 0;
    Sn = 0;
    fill_z(g_r[2], 0, 0x9c40, 'y');                              /* 0x9c40 is not above the limit of the original: copied, which overruns: rejected */
    sc_res(0x423259, 1, RVA(2), 0, 0);
    CK(m47d02d_show_names(rec, &g_w, &g_host) == 1);
    /* the second string too long: rejected */
    setup();
    g_w.value_5bb202 = 1;
    r[0x31] = 0;
    fill_z(r, 0x52, 98, 'k');
    CK(m47d02d_show_names(rec, &g_w, &g_host) == 1);
    CK(Ln == 1);
}

/* ---- 0x4c51a5 ------------------------------------------------------------------------------------------------------------------ */
static void rect(uint8_t *b, size_t off, int x0, int y0, int x1, int y1)
{
    set32(b, off, (uint32_t)x0);
    set32(b, off + 4, (uint32_t)y0);
    set32(b, off + 8, (uint32_t)x1);
    set32(b, off + 12, (uint32_t)y1);
}
static void desc(uint8_t *b, size_t off, uint32_t base, int pitch)
{
    set32(b, off, base);
    set16(b, off + 0x2f, (uint16_t)pitch);
}
#define SRC_AT 0x1000
#define DST_AT 0x1000
static void test_m4c51a5_copy_rows(void)
{
    uint32_t a = RVA(1) + 5, b = RVA(2) + 5, fr = RVA(3) + 3, tr = RVA(4) + 3;
    uint8_t want[RSZ];
    size_t i, row;
    setup();
    memset(g_r[6], 0xee, RSZ);
    memcpy(want, g_r[6], RSZ);
    desc(g_r[1], 5, RVA(5) + SRC_AT, 0x10);
    desc(g_r[2], 5, RVA(6) + DST_AT, 0x20);
    rect(g_r[3], 3, 1, 1, 3, 2);
    rect(g_r[4], 3, 0, 0, 2, 1);
    g_w.word_639895 = 3;
    /* rows = 2, bytes = 3 * 3 = 9: p = src + 1*0x10 + 1*3, q = dst + 0 */
    for (row = 0; row < 2; row++) memcpy(want + DST_AT + row * 0x20, g_r[5] + SRC_AT + 0x10 + 3 + row * 0x10, 9);
    CK(m4c51a5_copy_rows(SELF, a, b, fr, tr, 0x77, &g_w, &g_host) == 0);
    CK(memcmp(g_r[6], want, RSZ) == 0);                          /* exactly 9 bytes of each row: a dword, a dword and one byte */
    CK(Ln == 0);
    /* the debug word set, equal sizes and both descriptors: still the copy, no calls */
    memset(g_r[6], 0xee, RSZ);
    g_w.word_63a4cd = -1;
    CK(m4c51a5_copy_rows(SELF, a, b, fr, tr, 0x77, &g_w, &g_host) == 0);
    CK(memcmp(g_r[6], want, RSZ) == 0 && Ln == 0);
    /* a different width: the report, no copy */
    memset(g_r[6], 0xee, RSZ);
    rect(g_r[4], 3, 0, 0, 3, 1);
    CK(m4c51a5_copy_rows(SELF, a, b, fr, tr, 0x77, &g_w, &g_host) == 0);
    CK(Ln == 3);
    CKC(0, 0x50ca3e, 0, 11, ANY, 0x554848, 0x77, 1, 1, 3, 2, 0, 0, 3, 1);
    CK(IS_HOST(L[0].a[0]));
    CKC(1, 0x52139c, 0, 3, L[0].a[0], 0, 0);
    CKC0(2, 0x4c97b4, SELFP);
    memset(want, 0xee, RSZ);
    CK(memcmp(g_r[6], want, RSZ) == 0);
    /* a different height, a zero source descriptor, a zero destination descriptor: the report too */
    Ln = 0;
    rect(g_r[4], 3, 0, 0, 2, 2);
    CK(m4c51a5_copy_rows(SELF, a, b, fr, tr, 1, &g_w, &g_host) == 0 && Ln == 3);
    Ln = 0;
    rect(g_r[4], 3, 0, 0, 2, 1);
    CK(m4c51a5_copy_rows(SELF, 0, b, fr, tr, 1, &g_w, &g_host) == 0 && Ln == 3);
    Ln = 0;
    CK(m4c51a5_copy_rows(SELF, a, 0, fr, tr, 1, &g_w, &g_host) == 0 && Ln == 3);
    /* the debug word clear: a zero descriptor is rejected (the original faults), nothing is called or written */
    Ln = 0;
    g_w.word_63a4cd = 0;
    CK(m4c51a5_copy_rows(SELF, 0, b, fr, tr, 1, &g_w, &g_host) == 1);
    CK(m4c51a5_copy_rows(SELF, a, 0, fr, tr, 1, &g_w, &g_host) == 1);
    CK(Ln == 0 && memcmp(g_r[6], want, RSZ) == 0);
    /* a negative pitch of the destination, one byte per pixel, widths 1 to 5 */
    for (i = 1; i <= 5; i++) {
        memset(g_r[6], 0xee, RSZ);
        memcpy(want, g_r[6], RSZ);
        g_w.word_639895 = 1;
        desc(g_r[2], 5, RVA(6) + DST_AT, -0x20);
        rect(g_r[3], 3, 2, 0, 2 + (int)i - 1, 2);
        rect(g_r[4], 3, 1, 1, 1 + (int)i - 1, 3);
        /* q = dst + ty0 * pitch + tx0 * bpp = dst - 0x20 + 1; each row steps by -0x20; p = src + 0 * 0x10 + 2 */
        for (row = 0; row < 3; row++) memcpy(want + DST_AT - row * 0x20 - 0x20 + 1, g_r[5] + SRC_AT + 2 + row * 0x10, i);
        CK(m4c51a5_copy_rows(SELF, a, b, fr, tr, 1, &g_w, &g_host) == 0);
        CK(memcmp(g_r[6], want, RSZ) == 0);
    }
    /* rows <= 0: nothing, even with a negative byte count */
    memset(g_r[6], 0xee, RSZ);
    g_w.word_639895 = -1;
    rect(g_r[3], 3, 2, 5, 4, 4);
    CK(m4c51a5_copy_rows(SELF, a, b, fr, tr, 1, &g_w, &g_host) == 0);
    rect(g_r[3], 3, 2, 5, 4, 3);
    CK(m4c51a5_copy_rows(SELF, a, b, fr, tr, 1, &g_w, &g_host) == 0);
    /* rows > 0 and a negative byte count: rejected (the original copies about 4 GB) */
    rect(g_r[3], 3, 2, 0, 4, 1);
    CK(m4c51a5_copy_rows(SELF, a, b, fr, tr, 1, &g_w, &g_host) == 1);
}

/* ---- 0x47df57 ------------------------------------------------------------------------------------------------------------------ */
static void view_world(void)
{
    g_w.word_6246f9 = 2;
    g_w.byte_6246f8 = 0x80;
    g_w.word_624731 = 0x20;
    g_w.word_6246ff = 2;
    g_w.value_624705 = 0;
    g_w.value_62470d = 0x15;
    g_w.value_624709 = 2;
    g_w.value_624711 = 0x30;
    g_w.value_624715 = 1;
    g_w.value_624719 = 2;
    g_w.value_62471d = 3;
    g_w.value_624721 = 4;
    g_w.value_624729 = 0x33;
    g_w.value_62472d = 0x44;
    g_w.value_583186 = 100;
    g_w.value_58318a = 1000;
    g_w.value_5cf665 = 0x22;
    g_w.value_5d15e3 = 0x11;
    set32(g_tab, 4 * 0x4a, 0x55);                                /* table entry 2 (the world's index 0 is entry 2 of the buffer) */
    set32(g_rec + 5 * 0x8d, 0, RVA(1) + 0x10);                   /* record 2 */
    g_r[1][0x10 + 0x22] = 0;
}
static void test_m47df57_update_view(void)
{
    uint32_t r1[4] = {101, 1002, 103, 1004}, r2[4] = {100, 1002, 121, 1048}, pt[4] = {42, 0, 63, 63};
    setup();
    view_world();
    g_w.byte_6246f8 = 0;
    m47df57_update_view(&g_w, &g_host);
    CK(Ln == 0);                                                 /* the enable byte clear: nothing */
    g_w.byte_6246f8 = 0x80;
    sc_deref(0x4c5377, 0, 3, 16);
    sc_deref(0x4c6929, 0, 4, 16);
    sc_deref(0x4c6929, 1, 5, 16);
    m47df57_update_view(&g_w, &g_host);                          /* byte [item+0x22] == 0 -> 0x4c6929 */
    CK(Ln == 2);
    CKC(0, 0x4c5377, 0x5cf659, 5, 0x11, 0x22, 0x624715, ANY, 0x54d3ec);
    CK(memcmp(L[0].snap[0], r1, 16) == 0);
    CKC(1, 0x4c6929, 0x5cf659, 7, 0x55, 0x22, 0x44, 0x624705, ANY, ANY, 0x54d434);
    CK(memcmp(L[1].snap[0], r2, 16) == 0);
    CK(memcmp(L[1].snap[1], pt, 16) == 0);                       /* width 22 < 64 and x0 == 0 -> P.x = 42; y0 == 2 -> P.y = 0 */
    /* byte [item+0x22] != 0 -> 0x4c62f0 */
    Ln = 0;
    Sn = 0;
    g_r[1][0x10 + 0x22] = 1;
    sc_deref(0x4c62f0, 0, 6, 16);
    sc_deref(0x4c62f0, 1, 7, 16);
    m47df57_update_view(&g_w, &g_host);
    CK(Ln == 2);
    CKC(1, 0x4c62f0, 0x5cf659, 9, 0x55, 0x11, 0x22, 0x33, 0x624705, 0x624705, ANY, ANY, 0x54d408);
    CK(memcmp(L[1].snap[0], r2, 16) == 0 && memcmp(L[1].snap[1], pt, 16) == 0);
    /* y0 == 0 and height < size: P.y = size - height; x0 != 0: P.x stays 0 */
    Ln = 0;
    Sn = 0;
    g_w.value_624705 = 1;
    g_w.value_62470d = 0x15;
    g_w.value_624709 = 0;
    g_w.value_624711 = 9;
    sc_deref(0x4c62f0, 0, 6, 16);
    sc_deref(0x4c62f0, 1, 7, 16);
    m47df57_update_view(&g_w, &g_host);
    pt[0] = 0;
    pt[1] = 64 - 10;
    CK(memcmp(L[1].snap[1], pt, 16) == 0);
    /* width >= size: P.x stays 0 even with x0 == 0; a negative half size makes size - 1 = -3 */
    Ln = 0;
    Sn = 0;
    g_w.value_624705 = 0;
    g_w.value_62470d = 0x3f;
    g_w.word_624731 = -1;
    sc_deref(0x4c62f0, 0, 6, 16);
    sc_deref(0x4c62f0, 1, 7, 16);
    m47df57_update_view(&g_w, &g_host);
    pt[0] = 0;
    pt[1] = 0;
    pt[2] = pt[3] = 0xfffffffdu;
    CK(memcmp(L[1].snap[1], pt, 16) == 0);
    /* the record index is a signed word: -1 reads the record before the table's index 0 */
    Ln = 0;
    g_w.word_6246f9 = -1;
    set32(g_rec + 2 * 0x8d, 0, RVA(1) + 0x10);
    g_w.word_624731 = 0x20;
    m47df57_update_view(&g_w, &g_host);
    CK(Ln == 2);
}

/* ---- 0x4c2898 ------------------------------------------------------------------------------------------------------------------ */
static void test_m4c2898_alloc_surface(void)
{
    uint32_t pp = RVA(1) + 3, p = RVA(2) + 5, name = RVA(3) + 1;
    uint8_t *pr = g_r[2] + 5, want[0x60];
    size_t i;
    setup();
    set32(g_r[1], 3, 0x1234);
    put_z(g_r[3], 1, "Surface");
    m4c2898_alloc_surface(SELF, pp, 0x10, 5, 0xabc, name, &g_w, &g_host);       /* the cell is non-zero: the report */
    CK(Ln == 2);
    CKC(0, 0x42639d, 0x583979, 2, 0x553c94, name);
    CKC0(1, 0x4c97b4, SELFP);
    CK(get32(g_r[1], 3) == 0x1234);
    /* the first allocation fails */
    setup();
    set32(g_r[1], 3, 0);
    sc_res(0x51dc43, 1, 0, 0, 0);
    m4c2898_alloc_surface(SELF, pp, 0x10, 5, 0xabc, name, &g_w, &g_host);
    CK(Ln == 3);
    CKC(0, 0x51dc43, 0, 1, 0x59);
    CKC(1, 0x42639d, 0x583979, 2, 0x553d10, name);
    CKC0(2, 0x4c97b4, SELFP);
    CK(get32(g_r[1], 3) == 0);
    /* the second allocation fails: the record is cleared and the pixel pointer is 0 */
    setup();
    set32(g_r[1], 3, 0);
    g_w.word_639895 = 2;
    memset(pr, 0xcc, 0x70);
    put_z(g_r[3], 1, "Surface");
    sc_res(0x51dc43, 2, p, 0, 0);
    m4c2898_alloc_surface(SELF, pp, 0x10, 5, 0xabc, name, &g_w, &g_host);
    CK(Ln == 4);
    CKC(1, 0x51dc43, 0, 1, 0xa0);
    CKC(2, 0x42639d, 0x583979, 2, 0x553d68, name);
    CK(get32(g_r[1], 3) == p);
    for (i = 0; i < 0x59; i++) CK(pr[i] == 0);
    CK(pr[0x59] == 0xcc);
    /* success: w = 0x10 (garbage in the upper half), h = 5, bpp = 2 */
    setup();
    set32(g_r[1], 3, 0);
    g_w.word_639895 = 2;
    g_w.word_639893 = 0x1234;
    memset(pr, 0xcc, 0x70);
    put_z(g_r[3], 1, "Surface");
    sc_res(0x51dc43, 2, p, 0x30001234u, 0);
    m4c2898_alloc_surface(SELF, pp, 0xbeef0010u, 0x12340005u, 0xabc, name, &g_w, &g_host);
    CK(Ln == 2);
    CKC(0, 0x51dc43, 0, 1, 0x59);
    CKC(1, 0x51dc43, 0, 1, 0xa0);
    memset(want, 0, sizeof want);
    set32(want, 0, 0x30001234u);
    set32(want, 4, 0xabc);
    memcpy(want + 8, "Surface", 8);
    set16(want, 0x21, 0x59);
    set32(want, 0x23, 0xa0);
    set32(want, 0x27, 0xf9);
    set16(want, 0x2b, 0x10);
    set16(want, 0x2d, 5);
    set16(want, 0x2f, 0x20);
    set16(want, 0x31, 5);
    set16(want, 0x33, 0x1234);
    set32(want, 0x3d, 0xf);
    set32(want, 0x41, 4);
    CK(memcmp(pr, want, 0x59) == 0);
    CK(pr[0x59] == 0xcc && pr[0x6f] == 0xcc);
    /* a name of 0x30 characters is cut at 0x18 characters (in the caller's string too) */
    setup();
    set32(g_r[1], 3, 0);
    memset(pr, 0xcc, 0x70);
    fill_z(g_r[3], 1, 0x30, 'n');
    sc_res(0x51dc43, 2, p, 0x30001234u, 0);
    m4c2898_alloc_surface(SELF, pp, 3, 3, 0, name, &g_w, &g_host);
    CK(g_r[3][1 + 0x18] == 0 && g_r[3][1 + 0x17] == 'n' && g_r[3][1 + 0x19] == 'n');
    CK(pr[8 + 0x17] == 'n' && pr[8 + 0x18] == 0);
    /* 0x18 characters are kept; w = -1: size = -1 * bpp * h, [p+0x3d] = -2 */
    setup();
    set32(g_r[1], 3, 0);
    memset(pr, 0xcc, 0x70);
    fill_z(g_r[3], 1, 0x18, 'm');
    g_w.word_639895 = 2;
    sc_res(0x51dc43, 2, p, 0x30001234u, 0);
    m4c2898_alloc_surface(SELF, pp, 0xffff, 5, 0, name, &g_w, &g_host);
    CK(pr[8 + 0x17] == 'm' && pr[8 + 0x18] == 0);
    CKC(1, 0x51dc43, 0, 1, 0xfffffff6u);
    CK(get32(pr, 0x23) == 0xfffffff6u && get32(pr, 0x27) == 0xfffffff6u + 0x59);
    CK(get16(pr, 0x2f) == 0xfffe && get32(pr, 0x3d) == 0xfffffffeu && get32(pr, 0x41) == 4);
}

/* ---- 0x4f594d ------------------------------------------------------------------------------------------------------------------ */
#define REC_AT 0x700
static uint8_t *rec_ptr(int idx) { return g_r[1] + REC_AT + (size_t)(idx * 0x5bb); }
static void read_setup(int idx, uint32_t len, uint32_t rec15e)
{
    setup();
    set32(SELF, 0x3ce, RVA(1) + REC_AT);
    set32(SELF, 0x3c2, 0x1111);
    set32(rec_ptr(idx), 0x15e, rec15e);
    set32(rec_ptr(idx), 0x28f, 0x5a5a);
    set32(rec_ptr(idx), 0x130, 0);
    (void)len;
}
static void s_fill(uint32_t s2, uint32_t s3, uint32_t s4)
{
    uint32_t v[3] = {s2, s3, s4};
    sc_write(0x4f5e95, 0, 1, 8, v, 12);
    sc_deref(0x4f5e95, 0, 1, 28);
    sc_deref(0x4f5e35, 0, 1, 28);
}
static void test_m4f594d_read_checked(void)
{
    uint32_t S[7];
    uint32_t data = RVA(2) + 3, rec;
    int idx = 1;
    read_setup(idx, 8, 8);
    rec = RVA(1) + REC_AT + (uint32_t)idx * 0x5bb;
    s_fill(data, 8, 0);
    sc_res(0x4f5e95, 1, 0, 0, 0);
    CK(m4f594d_read_checked(SELF, (uint32_t)idx, 0, 8, &g_w, &g_host) == 0);
    CK(Ln == 1 && get32(SELF, 0x3c2) == 0x405);
    CKC(0, 0x4f5e95, SELFP, 2, 0x5a5a, ANY);
    memset(S, 0, sizeof S);
    S[1] = 8;
    S[6] = 2;                                                    /* len == [rec+0x15e] and buf == 0 */
    CK(memcmp(L[0].snap[0], S, 28) == 0);
    read_setup(idx, 8, 8);
    s_fill(data, 8, 0);
    sc_res(0x4f5e95, 1, 1, 0, 0);
    sc_res(0x4f5b50, 1, 8, 0, 0);
    sc_res(0x4f5e35, 1, 1, 0, 0);
    CK(m4f594d_read_checked(SELF, (uint32_t)idx, 0x30000000u, 8, &g_w, &g_host) == 1);
    S[0] = 0x30000000u;
    S[2] = data;
    S[3] = 8;
    S[6] = 0;                                                    /* buf != 0 */
    CK(Ln == 3);
    CKC(1, 0x4f5b50, SELFP, 3, (uintptr_t)idx, data, 8);
    CKC(2, 0x4f5e35, SELFP, 2, 0x5a5a, ANY);
    CK(memcmp(L[2].snap[0], S, 28) == 0);
    CK(get32(SELF, 0x3c2) == 0x1111);
    /* the final call fails */
    read_setup(idx, 8, 9);
    s_fill(data, 8, 0);
    sc_res(0x4f5e95, 1, 1, 0, 0);
    sc_res(0x4f5b50, 1, 8, 0, 0);
    sc_res(0x4f5e35, 1, 0, 0, 0);
    CK(m4f594d_read_checked(SELF, (uint32_t)idx, 0, 8, &g_w, &g_host) == 0);
    CK(get32(SELF, 0x3c2) == 0x407);
    CK(L[0].snap[0][24] == 0);                                   /* len != [rec+0x15e]: local 0 */
    /* S[3] != len, S[4] != 0 */
    read_setup(idx, 8, 8);
    s_fill(data, 9, 0);
    sc_res(0x4f5e95, 1, 1, 0, 0);
    CK(m4f594d_read_checked(SELF, (uint32_t)idx, 0, 8, &g_w, &g_host) == 0);
    CK(Ln == 2 && get32(SELF, 0x3c2) == 0x406);
    CKC(1, 0x4f5e35, SELFP, 2, 0x5a5a, ANY);
    read_setup(idx, 8, 8);
    s_fill(data, 8, 0x10000);
    sc_res(0x4f5e95, 1, 1, 0, 0);
    CK(m4f594d_read_checked(SELF, (uint32_t)idx, 0, 8, &g_w, &g_host) == 0);
    CK(Ln == 2 && get32(SELF, 0x3c2) == 0x406);
    /* n < 0 */
    read_setup(idx, 8, 8);
    s_fill(data, 8, 0);
    sc_res(0x4f5e95, 1, 1, 0, 0);
    sc_res(0x4f5b50, 1, 0xffffffffu, 0, 0);
    sc_res(0x4f5e35, 1, 1, 0, 0);
    CK(m4f594d_read_checked(SELF, (uint32_t)idx, 0, 8, &g_w, &g_host) == 0);
    CK(Ln == 3 && get32(SELF, 0x3c2) == 0x1111);
    /* n >= len (signed): n = len + 3 -> ok */
    read_setup(idx, 8, 8);
    s_fill(data, 8, 0);
    sc_res(0x4f5e95, 1, 1, 0, 0);
    sc_res(0x4f5b50, 1, 11, 0, 0);
    sc_res(0x4f5e35, 1, 1, 0, 0);
    CK(m4f594d_read_checked(SELF, (uint32_t)idx, 0, 8, &g_w, &g_host) == 1 && Ln == 3);
    /* n < len, [rec+0x130] == 0: the rest is read again at S[2] + n with len - n */
    read_setup(idx, 8, 8);
    s_fill(data, 8, 0);
    sc_res(0x4f5e95, 1, 1, 0, 0);
    sc_res(0x4f5b50, 2, 3, 5, 0);
    sc_res(0x4f5e35, 1, 1, 0, 0);
    CK(m4f594d_read_checked(SELF, (uint32_t)idx, 0, 8, &g_w, &g_host) == 1);
    CK(Ln == 4);
    CKC(2, 0x4f5b50, SELFP, 3, (uintptr_t)idx, data + 3, 5);
    read_setup(idx, 8, 8);                                       /* second read short: status 0x3ec */
    s_fill(data, 8, 0);
    sc_res(0x4f5e95, 1, 1, 0, 0);
    sc_res(0x4f5b50, 2, 3, 4, 0);
    sc_res(0x4f5e35, 1, 1, 0, 0);
    CK(m4f594d_read_checked(SELF, (uint32_t)idx, 0, 8, &g_w, &g_host) == 0 && get32(SELF, 0x3c2) == 0x3ec);
    read_setup(idx, 8, 8);                                       /* second read negative: ok = 0, no status */
    s_fill(data, 8, 0);
    sc_res(0x4f5e95, 1, 1, 0, 0);
    sc_res(0x4f5b50, 2, 3, 0xfffffffeu, 0);
    sc_res(0x4f5e35, 1, 1, 0, 0);
    CK(m4f594d_read_checked(SELF, (uint32_t)idx, 0, 8, &g_w, &g_host) == 0 && get32(SELF, 0x3c2) == 0x1111);
    /* n < len, [rec+0x130] != 0: the rest of the buffer is filled and the item flag set unless [item+0x10] == -1 */
    for (idx = -1; idx <= 1; idx++) {
        int k;
        for (k = 0; k < 3; k++) {
            uint8_t *rp;
            uint32_t item_flag_before;
            read_setup(idx, 8, 8);
            rp = rec_ptr(idx);
            rec = RVA(1) + REC_AT + (uint32_t)(idx * 0x5bb);
            (void)rec;
            set32(rp, 0x130, 5);
            set32(rp, 0x18a + 0x10, k == 2 ? 0xffffffffu : 7);
            set32(rp, 0x18a + 0xc, 0x99);
            set16(rp, 0x2ed, k == 0 ? 8 : 0x108);
            memset(g_r[2], 0x55, 0x40);
            s_fill(data, 8, 0);
            sc_res(0x4f5e95, 1, 1, 0, 0);
            sc_res(0x4f5b50, 1, 3, 0, 0);
            sc_res(0x4f5e35, 1, 1, 0, 0);
            item_flag_before = get32(rp, 0x18a + 0xc);
            CK(m4f594d_read_checked(SELF, (uint32_t)idx, 0, 8, &g_w, &g_host) == 1);
            CK(Ln == 3);
            if (k == 2) {
                CK(g_r[2][3 + 3] == 0x55 && get32(rp, 0x18a + 0xc) == item_flag_before);
            } else {
                int j;
                for (j = 0; j < 5; j++) CK(g_r[2][3 + 3 + j] == (k == 0 ? 0x80 : 0));
                CK(g_r[2][3 + 2] == 0x55 && g_r[2][3 + 8] == 0x55);
                CK(get32(rp, 0x18a + 0xc) == 1);
            }
        }
    }
}

/* ---- 0x41e3c0 ------------------------------------------------------------------------------------------------------------------ */
static void build_setup(int count, uint32_t flag)
{
    setup();
    memset(g_r[3], 0x5a, 0x3b00);
    g_w.value_5bb202 = flag;
    set16(SELF, 0xf21, (uint16_t)count);
    set32(SELF, 0xea5, RVA(2) + 0x10);
    set32(SELF, 0xea5 + 4, RVA(2) + 0x41);
    put_z(g_r[2], 0x10, "Q");
    put_z(g_r[2], 0x41, "WXYZ");
    set32(SELF, 0xea5 + 8, RVA(2) + 0x72);
    set32(SELF, 0xea5 + 12, RVA(2) + 0x93);
    put_z(g_r[2], 0x72, "ee");
    put_z(g_r[2], 0x93, "");
    put_z(g_r[1], 3 + 0x16b, "AB");
    set32(g_rec + 4 * 0x8d, 0, RVA(1) + 3);
    memcpy(g_c2, "1234", 4);
    put_z(g_c2, 4, "ab");
    memcpy(g_c2 + 8, "5678", 4);
    put_z(g_c2, 0xc, "xyz");
    memcpy(g_c2 + 0x24, "9ABC", 4);
    sc_res(0x51ea75, 1, RVA(3), 0, 0);
}
static void test_m41e3c0_build_text(void)
{
    uintptr_t obj;
    build_setup(2, 3);
    obj = (uintptr_t)(SELF + 0xf1d);
    sc_write(0x50ca3e, 0, 0, 0, "T0", 3);
    sc_write(0x50ca3e, 1, 0, 0, "R1", 3);
    CK(m41e3c0_build_text(SELF, 1, &g_w, &g_host) == 0);          /* the record index is the word 1: g_rec + 4 * 0x8d = the world's index 1 */
    CK(memcmp(g_r[3], "AB1234Q05678WXYZ9ABC", 21) == 0);
    CK(g_r[3][21] == 0 && g_r[3][0x3a97] == 0 && g_r[3][0x3a98] == 0x5a);       /* the 0x3a98 bytes are cleared, the rest is not touched */
    CK(Ln == 5);
    CKC0(0, 0x51e745, obj);
    CKC(1, 0x51ea75, obj, 1, 0x3a98);
    CKC(2, 0x50ca3e, 0, 5, ANY, 0x54389c, 0, 0, (uintptr_t)(SELF + 0x7d9));
    CKC(3, 0x50ca3e, 0, 5, ANY, 0x54389c, 1, 1, (uintptr_t)(SELF + 0x3a + 0x7d9));
    CKC(4, 0x51eac4, obj, 1, 0xffffffffu);
    CK(IS_HOST(L[2].a[0]));
    /* flag clear, count 0: the text "AB" and the last dword */
    build_setup(0, 0);
    CK(m41e3c0_build_text(SELF, 1, &g_w, &g_host) == 0);
    CK(memcmp(g_r[3], "AB9ABC", 7) == 0 && Ln == 3);
    /* the count is a signed word: 0xffff and 0x8000 run no iteration */
    build_setup(0xffff, 1);
    CK(m41e3c0_build_text(SELF, 1, &g_w, &g_host) == 0 && Ln == 3);
    CK(memcmp(g_r[3], "AB12349ABC", 11) == 0);
    build_setup(0x8000, 0);
    CK(m41e3c0_build_text(SELF, 1, &g_w, &g_host) == 0 && Ln == 3);
    /* the allocation fails: rejected after the two calls (the original faults in rep stosd) */
    build_setup(2, 1);
    sc_res(0x51ea75, 1, 0, 0, 0);
    CK(m41e3c0_build_text(SELF, 1, &g_w, &g_host) == 1);
    CK(Ln == 2 && g_r[3][0] == 0x5a);
    /* a callee text of 51 characters is accepted, 52 without a NUL is rejected */
    build_setup(1, 0);
    {
        uint8_t t[0x34];
        memset(t, 'x', sizeof t);
        t[51] = 0;
        sc_write(0x50ca3e, 0, 0, 0, t, 52);
        CK(m41e3c0_build_text(SELF, 1, &g_w, &g_host) == 0);
        CK(g_r[3][2] == 'x' && g_r[3][52] == 'x' && g_r[3][53] == 'Q');
        build_setup(1, 0);
        memset(t, 'x', sizeof t);
        sc_write(0x50ca3e, 0, 0, 0, t, 52);
        CK(m41e3c0_build_text(SELF, 1, &g_w, &g_host) == 1);
    }
    /* the closing dword store must end inside the 0x3a98 bytes: a text of 0x3a94 characters is accepted, 0x3a96 is rejected before the store */
    build_setup(0, 0);
    fill_z(g_r[1], 3 + 0x16b, 0x3a94, 'i');
    CK(m41e3c0_build_text(SELF, 1, &g_w, &g_host) == 0);
    CK(g_r[3][0x3a93] == 'i' && memcmp(g_r[3] + 0x3a94, "9ABC", 4) == 0 && g_r[3][0x3a98] == 0x5a);
    build_setup(0, 0);
    fill_z(g_r[1], 3 + 0x16b, 0x3a96, 'i');
    CK(m41e3c0_build_text(SELF, 1, &g_w, &g_host) == 1);
    CK(Ln == 2 && g_r[3][0x3a95] == 'i' && g_r[3][0x3a96] == 0);
    /* a string of 0x8000 characters at 0x543890 wraps the 16-bit offset negative: the next text lookup is rejected (the original would write in front of the buffer) */
    build_setup(0, 1);
    fill_z(g_c2, 4, 0x8000, 'x');
    CK(m41e3c0_build_text(SELF, 1, &g_w, &g_host) == 1);
    CK(Ln == 2 && memcmp(g_r[3], "AB1234", 6) == 0);
}

/* ---- 0x4f5b50 ------------------------------------------------------------------------------------------------------------------ */
static void rb_setup(int idx, int mode)
{
    setup();
    set32(SELF, 0x3ce, RVA(1) + REC_AT);
    set32(SELF, 0x3c2, 0x1111);
    set16(rec_ptr(idx), 0x126, (uint16_t)mode);
    set16(rec_ptr(idx), 0x2ed, 0);
    set32(rec_ptr(idx), 0x156, RVA(2) + 0x10);
    set32(g_r[2], 0x10 + 0xc, 0);
}
static void test_m4f5b50_read_block(void)
{
    uint32_t rec = RVA(1) + REC_AT + 0x5bb, s = RVA(1) + REC_AT + 0x5bb + 0x2f1, buf = 0x30000100;
    uint32_t one = 1;
    int idx = 1;
    /* mode 2: two reads (3 then the rest), a != 8: (a, b) = (2, 1) */
    rb_setup(idx, 2);
    sc_res(0x4fe2d0, 2, 3, 5, 0);
    sc_write(0x4fe2d0, 0, 6, 0, &(uint32_t){0}, 4);
    CK(m4f5b50_read_block(SELF, (uint32_t)idx, buf, 8, &g_w, &g_host) == 8);
    CK(get32(SELF, 0x3c2) == 0x3e8 && Ln == 2);
    CKC(0, 0x4fe2d0, 0, 7, s, buf, 8, 0, 2, 1, ANY);
    CK(IS_HOST(L[0].a[6]));
    CKC(1, 0x4fe2d0, 0, 7, s, buf + 3, 5, 0, 2, 1, ANY);
    /* the word [rec+0x2ed] == 8: (a, b) = (1, 0); debug word 2: the traces */
    rb_setup(idx, 2);
    set16(rec_ptr(idx), 0x2ed, 8);
    g_w.word_63a4cd = 2;
    sc_res(0x4fe2d0, 1, 8, 0, 0);
    CK(m4f5b50_read_block(SELF, (uint32_t)idx, buf, 8, &g_w, &g_host) == 8);
    CK(Ln == 5);
    CKC(0, 0x50ca3e, 0, 3, 0x63888b, 0x55e63c, 1);
    CKC(1, 0x44a2b7, 0, 1, 0x63888b);
    CKC(2, 0x4fe2d0, 0, 7, s, buf, 8, 0, 1, 0, ANY);
    CKC(3, 0x50ca3e, 0, 4, 0x63888b, 0x55e6c8, 1, 8);
    CKC(4, 0x44a2b7, 0, 1, 0x63888b);
    /* debug word 1 (not 2): no traces in the success case */
    rb_setup(idx, 2);
    g_w.word_63a4cd = 1;
    sc_res(0x4fe2d0, 1, 8, 0, 0);
    CK(m4f5b50_read_block(SELF, (uint32_t)idx, buf, 8, &g_w, &g_host) == 8 && Ln == 1);
    /* a read of 0 bytes calls 0x4fdc70 and ends the loop */
    rb_setup(idx, 2);
    sc_res(0x4fe2d0, 2, 2, 0, 0);
    CK(m4f5b50_read_block(SELF, (uint32_t)idx, buf, 8, &g_w, &g_host) == 2);
    CK(Ln == 3);
    CKC(2, 0x4fdc70, 0, 3, s, 0, 0);
    /* negative result / the out flag set: the error (with the trace when the debug word is non-zero) */
    rb_setup(idx, 2);
    g_w.word_63a4cd = 0x100;
    sc_res(0x4fe2d0, 1, 0xfffffffeu, 0, 0);
    CK(m4f5b50_read_block(SELF, (uint32_t)idx, buf, 8, &g_w, &g_host) == -1);
    CK(get32(SELF, 0x3c2) == 0x3ec && Ln == 3);
    CKC(1, 0x50ca3e, 0, 4, 0x63888b, 0x55e680, rec + 4, 0xfffffffeu);
    rb_setup(idx, 2);
    sc_res(0x4fe2d0, 1, 4, 0, 0);
    sc_write(0x4fe2d0, 0, 6, 0, &one, 4);
    CK(m4f5b50_read_block(SELF, (uint32_t)idx, buf, 8, &g_w, &g_host) == -1);
    CK(get32(SELF, 0x3c2) == 0x3ec && Ln == 1);
    /* len <= 0 (signed): no read */
    rb_setup(idx, 2);
    CK(m4f5b50_read_block(SELF, (uint32_t)idx, buf, 0xfffffffcu, &g_w, &g_host) == 0 && Ln == 0);
    /* mode 1 */
    rb_setup(idx, 1);
    sc_res(0x50cf61, 1, 8, 0, 0);
    CK(m4f5b50_read_block(SELF, (uint32_t)idx, buf, 8, &g_w, &g_host) == 8 && Ln == 1);
    CKC(0, 0x50cf61, 0, 4, buf, 1, 8, RVA(2) + 0x10);
    rb_setup(idx, 1);                                            /* short read, bit 0x10 only: the seek, n returned */
    set32(g_r[2], 0x10 + 0xc, 0x10);
    sc_res(0x50cf61, 1, 5, 0, 0);
    CK(m4f5b50_read_block(SELF, (uint32_t)idx, buf, 8, &g_w, &g_host) == 5 && Ln == 2);
    CKC(1, 0x50ce2b, 0, 3, RVA(2) + 0x10, 0x1e, 0);
    CK(get32(SELF, 0x3c2) == 0x3e8);
    rb_setup(idx, 1);                                            /* bit 0x20 (even with 0x10): the error */
    g_w.word_63a4cd = 3;
    set32(g_r[2], 0x10 + 0xc, 0x30);
    sc_res(0x50cf61, 1, 5, 0, 0);
    CK(m4f5b50_read_block(SELF, (uint32_t)idx, buf, 8, &g_w, &g_host) == -1);
    CK(Ln == 3 && get32(SELF, 0x3c2) == 0x3ec);
    CKC(1, 0x50ca3e, 0, 3, 0x63888b, 0x55e718, rec + 4);
    rb_setup(idx, 1);                                            /* neither bit: the error without the trace */
    sc_res(0x50cf61, 1, 5, 0, 0);
    CK(m4f5b50_read_block(SELF, (uint32_t)idx, buf, 8, &g_w, &g_host) == -1 && Ln == 1);
    /* other modes */
    rb_setup(idx, 3);
    g_w.word_63a4cd = 1;
    CK(m4f5b50_read_block(SELF, (uint32_t)idx, buf, 8, &g_w, &g_host) == -1);
    CK(Ln == 1 && get32(SELF, 0x3c2) == 0x3f9);
    CKC(0, 0x52139c, 0, 3, 0x55e754, 0, 0);
    rb_setup(idx, 0);
    CK(m4f5b50_read_block(SELF, (uint32_t)idx, buf, 8, &g_w, &g_host) == -1 && Ln == 0 && get32(SELF, 0x3c2) == 0x3f9);
}

/* ---- 0x41db40 ------------------------------------------------------------------------------------------------------------------ */
static void test_m41db40_free_record(void)
{
    uint32_t item = RVA(1) + 9, a = RVA(2) + 1, b = RVA(3) + 1, c = RVA(4) + 1;
    uint8_t *ip = g_r[1] + 9;
    int j;
    setup();
    set32(g_rec + 5 * 0x8d, 0, 0);                                /* index 2, item 0 */
    g_w.word_63a4cd = 1;
    m41db40_free_record(2, &g_w, &g_host);
    CK(Ln == 1);
    CKC(0, 0x44a2b7, 0, 1, 0x5437a8);                             /* the closing trace is skipped for an empty record */
    setup();
    set32(g_rec + 5 * 0x8d, 0, item);
    memset(ip + 0x793, 0, 0x20);
    set16(ip, 0x793, 3);
    set32(ip, 0x795, a);
    set16(ip, 0x799, 2);
    set32(ip, 0x79b, b);
    set16(ip, 0x79f, 3);
    set32(ip, 0x7a1, c);
    for (j = 0; j < 3; j++) {
        set16(g_r[2] + 1, (size_t)j * 0x1d1, 1);
        set32(g_r[2] + 1, (size_t)j * 0x1d1 + 2, 0x1000 + (uint32_t)j);
        set16(g_r[4] + 1, (size_t)j * 0xa, 1);
        set32(g_r[4] + 1, (size_t)j * 0xa + 2, 0x3000 + (uint32_t)j);
    }
    set16(g_r[2] + 1, 0x1d1, 0);                                  /* entry 1 of A: word 0 (not freed) */
    set16(g_r[4] + 1, 2 * 0xa, 0x8000);                           /* entry 2 of C: negative word (not freed) */
    set16(g_r[3] + 1, 0, 5);
    set32(g_r[3] + 1, 2, 0);                                      /* entry 0 of B: pointer 0 (not freed) */
    set16(g_r[3] + 1, 0x1c, 7);
    set32(g_r[3] + 1, 0x1c + 2, 0x2001);
    g_w.word_63a4cd = 0;
    m41db40_free_record(2, &g_w, &g_host);
    /* frees: A0, A2, A (the table), B1, B (the table), C0, C1, C (the table), the item */
    CK(Ln == 9);
    CKC(0, 0x51dc6c, 0, 1, 0x1000);
    CKC(1, 0x51dc6c, 0, 1, 0x1002);
    CKC(2, 0x51dc6c, 0, 1, a);
    CKC(3, 0x51dc6c, 0, 1, 0x2001);
    CKC(4, 0x51dc6c, 0, 1, b);
    CKC(5, 0x51dc6c, 0, 1, 0x3000);
    CKC(6, 0x51dc6c, 0, 1, 0x3001);
    CKC(7, 0x51dc6c, 0, 1, c);
    CKC(8, 0x51dc6c, 0, 1, item);
    CK(get32(ip, 0x795) == 0 && get32(ip, 0x79b) == 0 && get32(ip, 0x7a1) == 0);
    CK(get32(g_rec + 5 * 0x8d, 0) == 0);
    CK(get16(ip, 0x793) == 3 && get16(ip, 0x799) == 2);          /* the counts stay */
    /* count 0 / negative / pointer 0: the table is skipped altogether (and not freed) */
    setup();
    set32(g_rec + 5 * 0x8d, 0, item);
    memset(ip + 0x793, 0, 0x20);
    set16(ip, 0x793, 0x8000);
    set32(ip, 0x795, a);
    set16(ip, 0x799, 0);
    set32(ip, 0x79b, b);
    set16(ip, 0x79f, 2);
    set32(ip, 0x7a1, 0);
    g_w.word_63a4cd = 5;
    m41db40_free_record(2, &g_w, &g_host);
    CK(Ln == 3);
    CKC(0, 0x44a2b7, 0, 1, 0x5437a8);
    CKC(1, 0x51dc6c, 0, 1, item);
    CKC(2, 0x44a2b7, 0, 1, 0x5437d4);
    CK(get32(ip, 0x795) == a && get32(ip, 0x79b) == b);
}

/* CASES-END */

/* ---- bounded sweep ------------------------------------------------------------------------------------------------------------- */
static void test_sweep_bounded(void)
{
    unsigned seed = 4242;
    int n, i;
    for (n = 0; n < 300 && !g_failed; n++) {
        uint32_t rec = RVA(1) + 0x13;
        uint8_t *r = g_r[1] + 0x13;
        seed = seed * 1103515245u + 12345u;
        setup();
        /* 0x47d02d: strings of 0 to 120 characters (the long ones are rejected) */
        g_w.value_5bb202 = seed & 1;
        fill_z(r, 0x31, (seed >> 3) % 5, 'a');
        fill_z(r, 0x52, (seed >> 6) % 120, 'b');
        fill_z(g_r[2], 0, (seed >> 9) % 120, 'c');
        sc_res(0x516530, 1, seed >> 12 & 1, 0, 0);
        sc_res(0x423259, 1, (seed >> 13 & 1) ? RVA(2) : 0, 0, 0);
        m47d02d_show_names(rec, &g_w, &g_host);
        /* 0x4c51a5: small rectangles, pitches of both signs */
        Ln = 0;
        Sn = 0;
        desc(g_r[1], 5, RVA(5) + SRC_AT, (int)(seed >> 4 & 0x3f) - 0x20);
        desc(g_r[2], 5, RVA(6) + DST_AT, (int)(seed >> 8 & 0x3f) - 0x20);
        rect(g_r[3], 3, (int)(seed & 3), (int)(seed >> 2 & 3), (int)(seed >> 4 & 7), (int)(seed >> 5 & 7));
        rect(g_r[4], 3, (int)(seed >> 7 & 3), (int)(seed >> 9 & 3), (int)(seed >> 10 & 7), (int)(seed >> 12 & 7));
        g_w.word_639895 = (int16_t)(1 + (seed >> 14 & 3));
        g_w.word_63a4cd = (int16_t)(seed >> 16 & 1);
        m4c51a5_copy_rows(SELF, (seed >> 20 & 7) ? RVA(1) + 5 : 0, RVA(2) + 5, RVA(3) + 3, RVA(4) + 3, seed, &g_w, &g_host);
        /* 0x47df57: every global random */
        Ln = 0;
        view_world();
        g_w.value_624705 = seed & 3;
        g_w.value_62470d = seed >> 3;
        g_w.value_624709 = seed >> 5 & 3;
        g_w.word_624731 = (int16_t)(seed >> 7);
        g_w.value_583186 = seed * 3;
        g_r[1][0x10 + 0x22] = (uint8_t)(seed >> 9);
        m47df57_update_view(&g_w, &g_host);
        /* 0x4c2898 */
        Ln = 0;
        Sn = 0;
        set32(g_r[1], 3, 0);
        fill_z(g_r[3], 1, (seed >> 5) % 60, 'n');
        g_w.word_639895 = (int16_t)(seed >> 11);
        sc_res(0x51dc43, 2, (seed >> 3 & 7) ? RVA(2) + 5 : 0, (seed >> 6 & 7) ? 0x30001234u : 0, 0);
        m4c2898_alloc_surface(SELF, RVA(1) + 3, seed >> 2, seed >> 9, seed, RVA(3) + 1, &g_w, &g_host);
        /* 0x4f594d and 0x4f5b50 */
        Ln = 0;
        Sn = 0;
        read_setup(1, 8, seed & 1 ? 8 : 9);
        s_fill(RVA(2) + 3, (seed >> 1 & 3) ? 8 : 7, seed >> 3 & 1);
        set32(rec_ptr(1), 0x130, seed >> 4 & 1);
        set32(rec_ptr(1), 0x18a + 0x10, seed >> 5 & 1 ? 0xffffffffu : 3);
        sc_res(0x4f5e95, 1, seed >> 6 & 3, 0, 0);
        sc_res(0x4f5b50, 2, seed >> 7 & 15, (seed >> 11 & 15), 0);
        m4f594d_read_checked(SELF, 1, seed >> 15 & 1 ? 0 : 0x30000000u, 8, &g_w, &g_host);
        Ln = 0;
        Sn = 0;
        rb_setup(1, (int)(seed >> 3 & 3));
        set16(rec_ptr(1), 0x126, (uint16_t)(seed >> 3 & 3));
        sc_res(0x4fe2d0, 2, seed >> 5 & 7, seed >> 9 & 7, 0);
        set32(g_r[2], 0x10 + 0xc, (seed >> 12 & 1) ? 0x10 : 0x20);
        sc_res(0x50cf61, 1, seed >> 13 & 15, 0, 0);
        g_w.word_63a4cd = (int16_t)(seed >> 17 & 3);
        m4f5b50_read_block(SELF, 1, 0x30000000u, 8, &g_w, &g_host);
        /* 0x41e3c0 */
        Ln = 0;
        Sn = 0;
        build_setup((int)(seed >> 8 & 3), seed & 1);
        for (i = 0; i < 2; i++) {
            uint8_t t[0x34];
            unsigned z = (seed >> (3 + i)) % 0x36;       /* 0x34 and 0x35: no NUL in the 0x34 bytes of the local (rejected) */
            memset(t, 'x', sizeof t);
            if (z < sizeof t) t[z] = 0;
            sc_write(0x50ca3e, i, 0, 0, t, 0x34);
        }
        m41e3c0_build_text(SELF, 1, &g_w, &g_host);
        /* 0x41db40 */
        Ln = 0;
        Sn = 0;
        setup();
        set32(g_rec + 5 * 0x8d, 0, RVA(1) + 9);
        for (i = 0; i < 0x20; i++) g_r[1][9 + 0x793 + i] = 0;
        set16(g_r[1] + 9, 0x793, (uint16_t)(seed & 3));
        set32(g_r[1] + 9, 0x795, (seed >> 2 & 1) ? RVA(2) + 1 : 0);
        set16(g_r[1] + 9, 0x799, (uint16_t)(seed >> 3 & 3));
        set32(g_r[1] + 9, 0x79b, (seed >> 5 & 1) ? RVA(3) + 1 : 0);
        set16(g_r[1] + 9, 0x79f, (uint16_t)(seed >> 6 & 3));
        set32(g_r[1] + 9, 0x7a1, (seed >> 8 & 1) ? RVA(4) + 1 : 0);
        g_w.word_63a4cd = (int16_t)(seed >> 9 & 1);
        m41db40_free_record(2, &g_w, &g_host);
        Ln = 0;
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
    RUN(test_m47d02d_show_names);
    RUN(test_m4c51a5_copy_rows);
    RUN(test_m47df57_update_view);
    RUN(test_m4c2898_alloc_surface);
    RUN(test_m4f594d_read_checked);
    RUN(test_m41e3c0_build_text);
    RUN(test_m4f5b50_read_block);
    RUN(test_m41db40_free_record);
    /* RUN-END */
    RUN(test_sweep_bounded);
    return failures;
}
