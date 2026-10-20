/* FL-30 (batch c) direct tests of the ten methods of GAME.EXE in src/original_methods_fl30c.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the failure
 * count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl30c_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl30c.h"

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

static uint32_t get32(const uint8_t *o, size_t off) { uint32_t v; memcpy(&v, o + off, 4); return v; }
__attribute__((unused)) static uint16_t get16(const uint8_t *o, size_t off) { uint16_t v; memcpy(&v, o + off, 2); return v; }
static void set32(uint8_t *o, size_t off, uint32_t v) { memcpy(o + off, &v, 4); }
static void set16(uint8_t *o, size_t off, uint16_t v) { memcpy(o + off, &v, 2); }

/* the host: a log of the calls, scripted results per callee, and the memory behind original addresses */
#define MAXCALL 4096
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[6];
    } c[MAXCALL];
} L;
static struct {
    uint32_t callee;
    uint32_t results[4096];
    int n, used;
} S[8];
static int g_nscript;
__attribute__((unused)) static void script(uint32_t callee, int n, const uint32_t *results)
{
    int i;
    S[g_nscript].callee = callee;
    S[g_nscript].n = n;
    S[g_nscript].used = 0;
    for (i = 0; i < n; i++) S[g_nscript].results[i] = results[i];
    g_nscript++;
}
static struct {
    uint32_t va;
    uint8_t *ptr;
    uint32_t len;
} R[8];
static int g_nregion;
__attribute__((unused)) static void region(uint32_t va, uint8_t *ptr, uint32_t len)
{
    R[g_nregion].va = va;
    R[g_nregion].ptr = ptr;
    R[g_nregion].len = len;
    g_nregion++;
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
        L.n++;
    }
    for (k = 0; k < g_nscript; k++)
        if (S[k].callee == callee) {
            result = S[k].results[S[k].used < S[k].n ? S[k].used : S[k].n - 1];
            S[k].used++;
        }
    return result;
}

static const uint8_t *host_resolve(void *ctx, uint32_t address)
{
    int i;
    (void)ctx;
    for (i = 0; i < g_nregion; i++)
        if (address >= R[i].va && address < R[i].va + R[i].len) return R[i].ptr + (address - R[i].va);
    return NULL;
}

static Fl18Host g_host;
static Fl30cWorld g_w;

static void reset(void)
{
    memset(&L, 0, sizeof L);
    memset(S, 0, sizeof S);
    g_nscript = 0;
    g_nregion = 0;
    memset(&g_w, 0, sizeof g_w);
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
}

static void setf(uint8_t *o, size_t off, float f) { memcpy(o + off, &f, 4); }

/* ---- 0x4fcb5c ---- */
#define CH4F(c) ((size_t)(c) * 0x5bb)
static void test_m4fcb5c_set_category_master(void)
{
    static uint8_t self[0xb900];
    const size_t vol2 = 0xb764 + 2 * 4;
    reset();
    /* a value above 1.0f (idx 2) becomes 0x3f800000; no channel matches: no call */
    setf(self, vol2, 2.0f);
    m4fcb5c_set_category_master(self, 2, &g_host);
    CK(get32(self, vol2) == 0x3f800000u && L.n == 0);
    /* below zero, minus zero stays (not less than zero), a NaN (unordered) becomes zero; the bits of a value in range are kept */
    setf(self, vol2, -0.5f);
    m4fcb5c_set_category_master(self, 2, &g_host);
    CK(get32(self, vol2) == 0);
    set32(self, vol2, 0x80000000u);
    m4fcb5c_set_category_master(self, 2, &g_host);
    CK(get32(self, vol2) == 0x80000000u);
    set32(self, vol2, 0x7f800001u);
    m4fcb5c_set_category_master(self, 2, &g_host);
    CK(get32(self, vol2) == 0);
    set32(self, vol2, 0x3f800001u);        /* just above 1.0f */
    m4fcb5c_set_category_master(self, 2, &g_host);
    CK(get32(self, vol2) == 0x3f800000u);
    set32(self, vol2, 0x3f7fffffu);        /* just below 1.0f: kept */
    m4fcb5c_set_category_master(self, 2, &g_host);
    CK(get32(self, vol2) == 0x3f7fffffu);
    set32(self, vol2, 0x7f800000u);        /* +infinity */
    m4fcb5c_set_category_master(self, 2, &g_host);
    CK(get32(self, vol2) == 0x3f800000u);
    set32(self, vol2, 0xff800000u);        /* -infinity */
    m4fcb5c_set_category_master(self, 2, &g_host);
    CK(get32(self, vol2) == 0 && L.n == 0);
    /* a matching channel 3 (category word 2, state word 1): both attenuations, then 0x4f684a(this 0x5cf1eb, 3) */
    reset();
    memset(self, 0, sizeof self);
    setf(self, vol2, 0.5f);
    set16(self, CH4F(3) + 0x10c, 2);
    set16(self, CH4F(3) + 0x132, 1);
    setf(self, CH4F(3) + 0x138, 1.0f);
    setf(self, CH4F(3) + 0x13c, 0.5f);
    m4fcb5c_set_category_master(self, 2, &g_host);
    CK(get32(self, vol2) == 0x3f000000u);
    CK(get32(self, CH4F(3) + 0x140) == 0xfffffa6cu);       /* ftol(1.0 * 0.5 * 2857.142822265625 - 2857.142857142857) = -1428 */
    CK(get32(self, CH4F(3) + 0x144) == 0xfffff7a2u);       /* ftol(0.5 * 0.5 * ... ) = -2142 */
    CK(L.n == 1 && L.c[0].callee == 0x4f684a && L.c[0].this_ptr == 0x5cf1eb && L.c[0].nargs == 1 && L.c[0].a[0] == 3);
    /* the other channels: category word differs, state word is not exactly 1 (0x101, 2, 0): untouched, no call */
    reset();
    memset(self, 0, sizeof self);
    setf(self, vol2, 0.5f);
    set16(self, CH4F(0) + 0x10c, 3);
    set16(self, CH4F(0) + 0x132, 1);
    set16(self, CH4F(1) + 0x10c, 2);
    set16(self, CH4F(1) + 0x132, 0x101);
    set16(self, CH4F(2) + 0x10c, 2);
    set16(self, CH4F(2) + 0x132, 2);
    set16(self, CH4F(0x1f) + 0x10c, 2);
    set16(self, CH4F(0x1f) + 0x132, 0);
    m4fcb5c_set_category_master(self, 2, &g_host);
    CK(L.n == 0 && get32(self, CH4F(0) + 0x140) == 0 && get32(self, CH4F(1) + 0x144) == 0);
    /* idx -1: the category word 0xffff matches the sign-extended dword; the last channel 0x1f is reached; the vol table entry is at self + 0xb760 */
    reset();
    memset(self, 0, sizeof self);
    set32(self, 0xb760, 0x3f800000u);
    set16(self, CH4F(0x1f) + 0x10c, 0xffff);
    set16(self, CH4F(0x1f) + 0x132, 1);
    setf(self, CH4F(0x1f) + 0x138, -1.0f);
    setf(self, CH4F(0x1f) + 0x13c, 3.0e9f);
    m4fcb5c_set_category_master(self, -1, &g_host);
    CK(get32(self, CH4F(0x1f) + 0x140) == 0xffffe9aeu);     /* ftol(-1.0 * 1.0 * ... - 2857.14) = -5714 */
    CK(get32(self, CH4F(0x1f) + 0x144) == 0xb0f2e543u);     /* 3e9 * 2857.14 - 2857.14 = 8571428463939 -> low dword */
    CK(L.n == 1 && L.c[0].a[0] == 0x1f);
    /* ftol out of range: 1e30 * 1.0 * 2857 is beyond the int64 range: the integer indefinite, low dword 0; a NaN too */
    reset();
    memset(self, 0, sizeof self);
    set32(self, vol2, 0x3f800000u);
    set16(self, CH4F(1) + 0x10c, 2);
    set16(self, CH4F(1) + 0x132, 1);
    set32(self, CH4F(1) + 0x138, 0x7149f2cau);
    set32(self, CH4F(1) + 0x13c, 0x7fc00000u);
    set32(self, CH4F(1) + 0x140, 0x12345678u);
    m4fcb5c_set_category_master(self, 2, &g_host);
    CK(get32(self, CH4F(1) + 0x140) == 0 && get32(self, CH4F(1) + 0x144) == 0 && L.n == 1);
}

/* ---- 0x43d7f0 ---- */
static void test_m43d7f0_init_scenes(void)
{
    int i;
    reset();
    /* nothing set: [0x5d15a5] = 1, 47 thiscalls with no arguments (first 0x4d3ced on 0x61c387, then 0x468f68 on 0x616ab2, ..., last 0x489722 on 0x619935); every other global untouched */
    g_w.value_5d1a8f = 5;
    g_w.value_5b15d6 = 0x1111;
    m43d7f0_init_scenes(&g_w, &g_host);
    CK(g_w.value_5d15a5 == 1 && g_w.value_5d1a8f == 5 && g_w.value_5b15d6 == 0x1111 && g_w.value_5d1ad9 == 0 && g_w.value_5d1b6d == 0);
    CK(L.n == 47);
    CK(L.c[0].callee == 0x4d3ced && L.c[0].this_ptr == 0x61c387 && L.c[0].nargs == 0);
    CK(L.c[1].callee == 0x468f68 && L.c[1].this_ptr == 0x616ab2);
    CK(L.c[2].callee == 0x4a3910 && L.c[2].this_ptr == 0x61c8cf);
    CK(L.c[19].callee == 0x446075 && L.c[19].this_ptr == 0x638603);
    CK(L.c[46].callee == 0x489722 && L.c[46].this_ptr == 0x619935);
    for (i = 0; i < L.n; i++) CK(L.c[i].nargs == 0);
    /* [0x5bb1d2] != 0: [0x5b15d6] = [0x5bb1ce], [0x5bb1d2] = 0; [0x5bb1da] != 0: [0x5b1606] = [0x5bb1d6], [0x5bb1da] = 0 */
    reset();
    g_w.value_5bb1d2 = 0x80000000u;
    g_w.value_5bb1ce = 0xabcdef01u;
    g_w.value_5bb1da = 0x10000u;
    g_w.value_5bb1d6 = 0x22223333u;
    m43d7f0_init_scenes(&g_w, &g_host);
    CK(g_w.value_5b15d6 == 0xabcdef01u && g_w.value_5bb1d2 == 0 && g_w.value_5b1606 == 0x22223333u && g_w.value_5bb1da == 0);
    CK(g_w.value_5bb1ce == 0xabcdef01u && g_w.value_5bb1d6 == 0x22223333u);
    reset();
    g_w.value_5bb1da = 1;
    g_w.value_5bb1d6 = 9;
    m43d7f0_init_scenes(&g_w, &g_host);
    CK(g_w.value_5b1606 == 9 && g_w.value_5bb1da == 0 && g_w.value_5b15d6 == 0 && g_w.value_5bb1d2 == 0);
    /* the six bytes each set their own flag dword to 1 (a byte 0x80 or 0xff counts); the others stay */
    reset();
    g_w.byte_5b5158 = 0x80;
    g_w.byte_5b51c6 = 0xff;
    g_w.byte_5b61af = 1;
    m43d7f0_init_scenes(&g_w, &g_host);
    CK(g_w.value_5d1a8f == 1 && g_w.value_5d1ad9 == 0 && g_w.value_5d1b23 == 1 && g_w.value_5d1bb7 == 0 && g_w.value_5d1c01 == 1 && g_w.value_5d1b6d == 0);
    reset();
    g_w.byte_5b51ab = 2;
    g_w.byte_5b615e = 0x7f;
    g_w.byte_5b51f6 = 3;
    m43d7f0_init_scenes(&g_w, &g_host);
    CK(g_w.value_5d1a8f == 0 && g_w.value_5d1ad9 == 1 && g_w.value_5d1b23 == 0 && g_w.value_5d1bb7 == 1 && g_w.value_5d1c01 == 0 && g_w.value_5d1b6d == 1);
}

/* ---- 0x434025 ---- */
static void test_m434025_scan_entries(void)
{
    static uint8_t self[0x6000];
    uint32_t r1[1500], r2[2];
    int k;
    /* count 1, A[0] = 0x10000, 0x4347b8 answers 20 then 4, 0x434773 answers 0: p = 0x10000 + 4 ("DATA") -> n = 20; p = 0x1000c, q = 5; entry 0x1000c stored, p = 0x10018, q = 17 (m = 4); not above 20: entry
     * 0x10018 stored, p = 0x10024, q = 29 > 20 */
    reset();
    memset(self, 0, sizeof self);
    set32(self, 0x5f64, 1);
    set32(self, 0x1144, 0x10000);
    set32(self, 0x5f68, 77);
    r1[0] = 20; r1[1] = 4;
    r2[0] = 0;
    script(0x4347b8, 2, r1);
    script(0x434773, 1, r2);
    m434025_scan_entries(self, &g_host);
    CK(get32(self, 0x5f68) == 2 && get32(self, 0x20e4) == 0x1000c && get32(self, 0x20e8) == 0x10018);
    CK(L.n == 5);
    CK(L.c[0].callee == 0x4347b8 && L.c[0].this_ptr == (uintptr_t)self && L.c[0].nargs == 1 && L.c[0].a[0] == 0x10004);
    CK(L.c[1].callee == 0x434773 && L.c[1].a[0] == 0x1000c && L.c[2].callee == 0x4347b8 && L.c[2].a[0] == 0x10010);
    CK(L.c[3].callee == 0x434773 && L.c[3].a[0] == 0x10018 && L.c[4].callee == 0x4347b8 && L.c[4].a[0] == 0x1001c);
    /* n = 8 (not above 8): the report first; an odd m (3) is made even (4): p = 0x20018, q = 17 > 8 ends */
    reset();
    memset(self, 0, sizeof self);
    set32(self, 0x5f64, 1);
    set32(self, 0x1144, 0x20000);
    r1[0] = 8; r1[1] = 3;
    r2[0] = 0;
    script(0x4347b8, 2, r1);
    script(0x434773, 1, r2);
    m434025_scan_entries(self, &g_host);
    CK(get32(self, 0x5f68) == 1 && get32(self, 0x20e4) == 0x2000c);
    CK(L.n == 5 && L.c[1].callee == 0x42639d && L.c[1].this_ptr == 0x583979 && L.c[1].nargs == 2 && L.c[1].a[0] == 0x545e98 && L.c[1].a[1] == 0x545e84);
    CK(L.c[2].callee == 0x4c97b4 && L.c[2].this_ptr == 0x5cf659 && L.c[2].nargs == 0 && L.c[3].callee == 0x434773 && L.c[3].a[0] == 0x2000c);
    CK(L.c[4].callee == 0x4347b8 && L.c[4].a[0] == 0x20010);
    /* the scan: A[1] equals the first p of entry 0 (0x30000 + 12); 0x434773 answers 1 once; sel = 1 (j = 0 is entry 0 itself, skipped); dword [self+0x3084+4] = 0x10 is added to p and q */
    reset();
    memset(self, 0, sizeof self);
    set32(self, 0x5f64, 2);
    set32(self, 0x1144, 0x30000);
    set32(self, 0x1148, 0x3000c);
    set32(self, 0x3084 + 4, 0x10);
    r1[0] = 100; r1[1] = 2; r1[2] = 90;
    r2[0] = 1; r2[1] = 0;
    script(0x4347b8, 3, r1);
    script(0x434773, 2, r2);
    m434025_scan_entries(self, &g_host);
    /* entry 0: p = 0x3001c, q = 21 < 100: stored; p = 0x30020 -> m = 2 -> p = 0x30026, q = 31; again (answer 0): stored 0x30026, p = 0x3002a, m = 90, q = 129 > 100 ends;
     * entry 1: p = 0x3000c + 4 = 0x30010 -> n = 90, p = 0x30018, answer 0: stored 0x30018 */
    CK(get32(self, 0x5f68) == 3 && get32(self, 0x20e4) == 0x3001c && get32(self, 0x20e8) == 0x30026 && get32(self, 0x20ec) == 0x30018);
    CK(L.n == 8 && L.c[0].a[0] == 0x30004 && L.c[1].callee == 0x434773 && L.c[1].a[0] == 0x3000c && L.c[2].callee == 0x4347b8 && L.c[2].a[0] == 0x30020);
    CK(L.c[3].callee == 0x434773 && L.c[3].a[0] == 0x30026 && L.c[4].callee == 0x4347b8 && L.c[4].a[0] == 0x3002a && L.c[5].callee == 0x4347b8 && L.c[5].a[0] == 0x30010);
    CK(L.c[6].callee == 0x434773 && L.c[6].a[0] == 0x30018 && L.c[7].callee == 0x4347b8 && L.c[7].a[0] == 0x3001c);
    /* answer 1 without a match: sel stays 0 and dword [self+0x3084] = 0x7ffffff0 makes q >= n: leaves the loop without a store */
    reset();
    memset(self, 0, sizeof self);
    set32(self, 0x5f64, 1);
    set32(self, 0x1144, 0x40000);
    set32(self, 0x3084, 0x7ffffff0u);
    r1[0] = 50;
    r2[0] = 1;
    script(0x4347b8, 1, r1);
    script(0x434773, 1, r2);
    m434025_scan_entries(self, &g_host);
    CK(get32(self, 0x5f68) == 0 && get32(self, 0x20e4) == 0 && L.n == 2);
    /* a count of 0 or a negative count: nothing but [self+0x5f68] = 0 */
    reset();
    memset(self, 0, sizeof self);
    set32(self, 0x5f64, 0xffffffffu);
    set32(self, 0x5f68, 5);
    m434025_scan_entries(self, &g_host);
    CK(get32(self, 0x5f68) == 0 && L.n == 0);
    /* 500 entries, two stores each (answers 40, 0, 40 per entry): 1000 stores; the store with the count 999 (> 0x3e6) reports 0x42639d(0x583979, 0x545ed0, 0x545ebc) and 0x4c97b4 first, once */
    reset();
    memset(self, 0, sizeof self);
    set32(self, 0x5f64, 500);
    for (k = 0; k < 500; k++) set32(self, 0x1144 + 4 * k, 0x100000u + 0x100u * (uint32_t)k);
    for (k = 0; k < 1500; k += 3) { r1[k] = 40; r1[k + 1] = 0; r1[k + 2] = 40; }
    r2[0] = 0;
    script(0x4347b8, 1500, r1);
    script(0x434773, 1, r2);
    m434025_scan_entries(self, &g_host);
    CK(get32(self, 0x5f68) == 1000);
    CK(get32(self, 0x20e4) == 0x100000u + 12 && get32(self, 0x20e4 + 4 * 999) != 0);
    {
        int reports = 0, bad = 0;
        for (k = 0; k < L.n; k++) {
            if (L.c[k].callee == 0x42639d) {
                reports++;
                if (L.c[k].this_ptr != 0x583979 || L.c[k].a[0] != 0x545ed0 || L.c[k].a[1] != 0x545ebc || L.c[k + 1].callee != 0x4c97b4 || L.c[k + 1].this_ptr != 0x5cf659) bad++;
            }
        }
        CK(reports == 1 && bad == 0);
    }
}

/* TESTS-END */

/* ---- the bounded sweep: every port on random in-bounds buffers (meant for the sanitiser builds) ---- */
static uint32_t g_rng = 0x12345678u;
static uint32_t rnd(void) { g_rng = g_rng * 1664525u + 1013904223u; return g_rng >> 8; }

static void test_sweep_bounded(void)
{
    static uint8_t sv[0xb900];
    int n, k;
    for (n = 0; n < 300; n++) {
        reset();
        g_w.word_63a4cd = (int16_t)(rnd() & 1);
        /* 0x4fcb5c */
        for (k = 0; k < (int)sizeof sv; k++) sv[k] = (uint8_t)rnd();
        for (k = 0; k < 0x20; k++) { set16(sv, (size_t)k * 0x5bb + 0x10c, (uint16_t)(rnd() % 4)); set16(sv, (size_t)k * 0x5bb + 0x132, (uint16_t)(rnd() % 3)); }
        m4fcb5c_set_category_master(sv, (int32_t)(rnd() % 6) - 2, &g_host);
        /* 0x43d7f0 */
        g_w.value_5bb1d2 = rnd() & 1;
        g_w.value_5bb1da = rnd() & 1;
        g_w.byte_5b5158 = (uint8_t)(rnd() & 1);
        g_w.byte_5b51f6 = (uint8_t)(rnd() & 1);
        m43d7f0_init_scenes(&g_w, &g_host);
        /* 0x434025 */
        {
            static uint8_t so[0x6000];
            uint32_t r1[8], r2[8];
            for (k = 0; k < 8; k++) { r1[k] = rnd() % 30; r2[k] = rnd() % 3; }
            script(0x4347b8, 8, r1);
            script(0x434773, 8, r2);
            memset(so, 0, sizeof so);
            set32(so, 0x5f64, rnd() % 5);
            for (k = 0; k < 5; k++) { set32(so, 0x1144 + 4 * k, rnd()); set32(so, 0x3084 + 4 * k, rnd() % 20); }
            m434025_scan_entries(so, &g_host);
        }
        /* SWEEP-END */
    }
}

#define RUN(fn)                \
    do {                       \
        g_failed = 0;          \
        g_msg[0] = 0;          \
        fn();                  \
        if (g_failed) {        \
            printf("FAIL %s: %s\n", #fn, g_msg); \
            failures++;        \
        } else {               \
            printf("PASS %s\n", #fn); \
        }                      \
    } while (0)

int main(void)
{
    int failures = 0;
    RUN(test_m4fcb5c_set_category_master);
    RUN(test_m43d7f0_init_scenes);
    RUN(test_m434025_scan_entries);
    /* RUN-END */
    RUN(test_sweep_bounded);
    return failures;
}
