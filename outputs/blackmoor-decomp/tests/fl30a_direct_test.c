/* FL-30 (batch a) direct tests of the methods of GAME.EXE in src/original_methods_fl30a.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl30a_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl30a.h"

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
static uint8_t g_tbl[0x8d * 0x20], g_tab[0xa0];
static Fl30aWorld g_w;
static Fl18Host g_host;
#define SELF g_r[0]

static __attribute__((unused)) void set32(uint8_t *b, size_t off, uint32_t v) { memcpy(b + off, &v, 4); }
static __attribute__((unused)) void set16(uint8_t *b, size_t off, uint16_t v) { memcpy(b + off, &v, 2); }
static uint32_t get32(const uint8_t *b, size_t off) { uint32_t v; memcpy(&v, b + off, 4); return v; }
static __attribute__((unused)) uint16_t get16(const uint8_t *b, size_t off) { uint16_t v; memcpy(&v, b + off, 2); return v; }

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
} S[8];
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
    memset(&g_w, 0, sizeof g_w);
    g_w.table_5bb5e5 = g_tbl + 4 * 0x8d;
    memset(g_tab, 0, sizeof g_tab);
    g_w.tab_58c91d = g_tab;
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

/* ---- 0x4f61e7 start_record ------------------------------------------------------------------------------------------------- */
#define VT 0x7e000900u
static void rec_setup(uint32_t index_base_add)
{
    setup();
    set32(SELF, 0x3ce, RVA(1) + index_base_add);
    set32(SELF, 0x3be, 0x77);
    set32(SELF, 0x3c2, 0x1111);
    set32(SELF, 0x3ca, 0x2222);
}
static void test_m4f61e7_start_record(void)
{
    uint8_t *rec = g_r[1] + 2 * 0x5bb;
    uint32_t rec_va = RVA(1) + 2 * 0x5bb;
    rec_setup(0);
    script(0x4f709c, 1, 0, 0, 0, 0);
    CK(m4f61e7_start_record(SELF, 2, &g_w, &g_host) == 0);                              /* the first callee fails */
    CK(get32(SELF, 0x3c2) == 0x3ea && get32(SELF, 0x3be) == 0 && get32(SELF, 0x3ca) == 0);
    CK(L.n == 1);
    CKC0(0, 0x4f709c, SELFP);
    rec_setup(0);
    script(0x4f709c, 1, 5, 0, 0, 0);
    set32(rec, 0x162, 0);
    set32(rec, 0x28f, RVA(2));
    CK(m4f61e7_start_record(SELF, 2, &g_w, &g_host) == 0);                              /* no [rec+0x162] */
    CK(get32(SELF, 0x3c2) == 0x3ef && get32(SELF, 0x3be) == 0 && get32(SELF, 0x3ca) == 0 && L.n == 1 && get32(rec, 0x287) != 1);
    rec_setup(0);
    script(0x4f709c, 1, 5, 0, 0, 0);
    set32(rec, 0x162, 0x10000);
    set32(rec, 0x28f, 0);
    CK(m4f61e7_start_record(SELF, 2, &g_w, &g_host) == 0);                              /* [rec+0x162] set, no [rec+0x28f] */
    CK(get32(SELF, 0x3c2) == 0x3ef && get32(SELF, 0x3be) == 0 && L.n == 1);
    /* success path: vtable entry result non-zero */
    rec_setup(0);
    script(0x4f709c, 1, 5, 0, 0, 0);
    script(VT, 1, 0x55, 0, 0, 0);
    set32(rec, 0x162, 0x10000);
    set32(rec, 0x28f, RVA(2));
    set32(g_r[2], 0, RVA(3));
    set32(g_r[3], 0x48, VT);
    CK(m4f61e7_start_record(SELF, 2, &g_w, &g_host) == 0);
    CK(get32(rec, 0x287) == 1 && get32(SELF, 0x3ca) == 0x55 && get32(SELF, 0x3c2) == 0x40b && get32(SELF, 0x3be) == 0);
    CK(L.n == 2);
    CKC0(0, 0x4f709c, SELFP);
    CKC(1, VT, RVA(3), 1, RVA(2));
    /* vtable entry result 0: debug off, then on (a negative word is non-zero too) */
    rec_setup(0);
    g_nscript = 0;
    script(0x4f709c, 1, 5, 0, 0, 0);
    script(VT, 1, 0, 0, 0, 0);
    set32(rec, 0x162, 1);
    set32(rec, 0x28f, RVA(2));
    set32(g_r[2], 0, RVA(3));
    set32(g_r[3], 0x48, VT);
    CK(m4f61e7_start_record(SELF, 2, &g_w, &g_host) == 1);
    CK(get32(SELF, 0x3ca) == 0 && get32(SELF, 0x3c2) == 0x3e8 && get32(SELF, 0x3be) == 0x77 && L.n == 2);
    L.n = 0;
    g_nscript = 0;
    script(0x4f709c, 1, 5, 0, 0, 0);
    script(VT, 1, 0, 0, 0, 0);
    g_w.word_63a4cd = (int16_t)0x8000;
    set32(SELF, 0x3c2, 0);
    CK(m4f61e7_start_record(SELF, 2, &g_w, &g_host) == 1);
    CK(L.n == 4);
    CKC(2, 0x50ca3e, 0, 4, 0x63888b, 0x55e7bc, 2, rec_va + 4);
    CKC(3, 0x44a2b7, 0, 1, 0x63888b);
    /* a result whose low word is 0 is still a non-zero dword */
    rec_setup(0);
    g_nscript = 0;
    script(0x4f709c, 1, 5, 0, 0, 0);
    script(VT, 1, 0x10000, 0, 0, 0);
    set32(rec, 0x162, 0x10000);
    set32(rec, 0x28f, RVA(2));
    set32(g_r[2], 0, RVA(3));
    set32(g_r[3], 0x48, VT);
    CK(m4f61e7_start_record(SELF, 2, &g_w, &g_host) == 0);
    CK(get32(SELF, 0x3ca) == 0x10000 && get32(SELF, 0x3c2) == 0x40b && L.n == 2);
    /* index 0xffffffff: rec = [self+0x3ce] - 0x5bb (32-bit wrap of the product) */
    rec_setup(0x5bb);
    g_nscript = 0;
    script(0x4f709c, 1, 5, 0, 0, 0);
    script(VT, 1, 9, 0, 0, 0);
    set32(g_r[1], 0x162, 1);
    set32(g_r[1], 0x28f, RVA(2));
    set32(g_r[2], 0, RVA(3));
    set32(g_r[3], 0x48, VT);
    CK(m4f61e7_start_record(SELF, 0xffffffffu, &g_w, &g_host) == 0);
    CK(get32(g_r[1], 0x287) == 1 && get32(SELF, 0x3ca) == 9);
}

/* ---- 0x484762 intersect_rects ----------------------------------------------------------------------------------------------- */
/* rectangle (x0, y0, x1, y1) stored at the dwords +2.. of record `index` (stride 0x85, base 0x28) */
static void rect_at(int index, int32_t x0, int32_t y0, int32_t x1, int32_t y1)
{
    size_t base = 0x28 + (size_t)index * 0x85 + 2;
    set32(SELF, base, (uint32_t)x0);
    set32(SELF, base + 4, (uint32_t)y0);
    set32(SELF, base + 8, (uint32_t)x1);
    set32(SELF, base + 12, (uint32_t)y1);
}
static void test_m484762_intersect_rects(void)
{
    setup();
    rect_at(0, 0, 0, 10, 10);
    rect_at(1, 5, 5, 20, 20);
    CK(m484762_intersect_rects(SELF, 0, 1) == 1);                  /* A.x0 < B.x0, A.x1 >= B.x0 */
    CK(m484762_intersect_rects(SELF, 1, 0) == 1);                  /* A.x0 >= B.x0, A.x0 <= B.x1 */
    rect_at(1, 11, 5, 20, 20);
    CK(m484762_intersect_rects(SELF, 0, 1) == 0);                  /* A.x1 < B.x0 */
    CK(m484762_intersect_rects(SELF, 1, 0) == 0);                  /* A.x0 > B.x1 */
    rect_at(1, 10, 5, 20, 20);
    CK(m484762_intersect_rects(SELF, 0, 1) == 1);                  /* A.x1 == B.x0 touches */
    CK(m484762_intersect_rects(SELF, 1, 0) == 1);                  /* A.x0 == B.x1 touches */
    rect_at(1, 5, 11, 20, 20);
    CK(m484762_intersect_rects(SELF, 0, 1) == 0);                  /* y: A.y1 < B.y0 */
    CK(m484762_intersect_rects(SELF, 1, 0) == 0);                  /* y: A.y0 > B.y1 */
    rect_at(1, 5, 10, 20, 20);
    CK(m484762_intersect_rects(SELF, 0, 1) == 1 && m484762_intersect_rects(SELF, 1, 0) == 1);
    /* the coordinate -1 is the "unset" marker: an intersection whose coordinate is -1 counts as empty */
    rect_at(0, -3, 0, 4, 4);
    rect_at(1, -1, 0, 9, 9);
    CK(m484762_intersect_rects(SELF, 0, 1) == 0);                  /* rx0 = B.x0 = -1 */
    CK(m484762_intersect_rects(SELF, 1, 0) == 0);                  /* A.x0 = -1 >= B.x0 = -3: rx0 = A.x0 = -1 */
    rect_at(0, 0, -3, 4, 4);
    rect_at(1, 0, -1, 9, 9);
    CK(m484762_intersect_rects(SELF, 0, 1) == 0 && m484762_intersect_rects(SELF, 1, 0) == 0);      /* ry0 = -1 */
    rect_at(0, 0, 0, -1, 4);
    rect_at(1, -5, 0, 9, 9);
    CK(m484762_intersect_rects(SELF, 0, 1) == 0);                  /* rx1 = A.x1 = -1 (A.x1 <= B.x1) */
    rect_at(0, 0, 0, 4, -1);
    rect_at(1, 0, -5, 9, 9);
    CK(m484762_intersect_rects(SELF, 0, 1) == 0);                  /* ry1 = A.y1 = -1 */
    rect_at(0, -9, -9, 9, 9);
    rect_at(1, -2, -2, -1, 3);
    CK(m484762_intersect_rects(SELF, 0, 1) == 0);                  /* rx1 = B.x1 = -1 (A.x1 > B.x1) */
    rect_at(1, -2, -2, 3, -1);
    CK(m484762_intersect_rects(SELF, 0, 1) == 0);                  /* ry1 = B.y1 = -1 */
    rect_at(1, -2, -2, 3, 3);
    CK(m484762_intersect_rects(SELF, 0, 1) == 1);
    /* a rectangle with the record index byte at +0x22 and the signed 32-bit comparison */
    rect_at(0, (int32_t)0x80000000, 0, 4, 4);
    rect_at(1, 0, 0, 9, 9);
    CK(m484762_intersect_rects(SELF, 0, 1) == 1);                  /* 0x80000000 is the smallest signed value: A.x0 < B.x0 */
    CK(m484762_intersect_rects(SELF, 1, 0) == 1);                  /* A.x0 = 0 >= B.x0 = INT_MIN and 0 <= B.x1 = 4: rx0 = 0, rx1 = 4 */
}

/* ---- 0x484ac0 latch_hit ------------------------------------------------------------------------------------------------------ */
static void hit_good(void)
{
    setup();
    set16(SELF, 0x26, 1);
    set32(g_w.table_5bb5e5, 1 * 0x8d, RVA(1));
    set32(g_w.table_5bb5e5, 1 * 0x8d + 0x4d, 1);
    set32(g_w.table_5bb5e5, 0, RVA(2));                     /* the other entries point at a record that fails every guard */
    set32(g_w.table_5bb5e5, 0x4d, 1);
    memset(g_r[1] + 0x20, 0, 0x20);
    memset(g_r[2] + 0x20, 0, 0x20);
    g_r[1][0x24] = 1;
    set32(SELF, 0xba7, 1);
    memset(SELF + 0xbac, 0, 0x10);
    set16(SELF, 0xbf9, 1);
    set32(SELF, 0xa92, 0);
    set16(SELF, 0xbc5, 0x1111);
    set16(SELF, 0xbc7, 0x2222);
}
static void test_m484ac0_latch_hit(void)
{
    int guard;
    /* each guard on its own ends the function at once */
    for (guard = 0; guard < 7; guard++) {
        hit_good();
        switch (guard) {
        case 0: set32(SELF, 0xba7, 0); break;
        case 1: g_r[1][0x24] = 0; break;
        case 2: g_r[1][0x25] = 7; break;
        case 3: SELF[0xbb0] = 1; break;
        case 4: set32(SELF, 0xbac, 0x10000); break;
        case 5: set32(g_w.table_5bb5e5, 1 * 0x8d + 0x4d, 2); break;
        default: set16(SELF, 0xbf9, 0); break;
        }
        g_nscript = 0;
        script(0x4846c2, 1, 2, 0, 0, 0);
        m484ac0_latch_hit(SELF, &g_w, &g_host);
        CK(L.n == 0 && get16(SELF, 0xbc5) == 0x1111 && get32(SELF, 0xa92) == 0);
    }
    /* the guards read a byte at 0xbb0 (a set byte at 0xbb1 does not stop the function), a word at 0xbf9 (0x100 is not zero) and a dword at 0xba7 / 0xbac */
    hit_good();
    SELF[0xbb1] = 1;
    set16(SELF, 0xbf9, 0x100);
    script(0x4846c2, 1, 0xffff, 0, 0, 0);
    m484ac0_latch_hit(SELF, &g_w, &g_host);
    CK(L.n == 1);
    /* path A: a92 != 0, h = word [0xa9e] = 2 */
    hit_good();
    set32(SELF, 0xa92, 0x10000);
    set16(SELF, 0xa9e, 2);
    set32(SELF, 0x10a + 0x32, 100);
    set32(SELF, 0x10a + 0x2a, 60);
    set32(SELF, 0x10a + 0x36, 5);
    set32(SELF, 0x10a + 0x2e, 0x10008);
    m484ac0_latch_hit(SELF, &g_w, &g_host);
    CK(L.n == 3);
    CKC(0, 0x4853b0, SELFP, 1, 2);
    CKC0(1, 0x485f12, SELFP);
    CKC(2, 0x484935, SELFP, 1, 2);
    CK(get16(SELF, 0xbc5) == 40 && get16(SELF, 0xbc7) == 0xfffd && get32(SELF, 0xa92) == 0x10000 && get16(SELF, 0xa9e) == 2);
    /* path B: a92 == 0, 0x4846c2 returns ax = 3 (the upper half is garbage) */
    hit_good();
    g_nscript = 0;
    script(0x4846c2, 1, 0xabcd0003u, 0, 0, 0);
    set32(SELF, 0x18f + 0x32, 7);
    set32(SELF, 0x18f + 0x2a, 9);
    set32(SELF, 0x18f + 0x36, 0x20000);
    set32(SELF, 0x18f + 0x2e, 1);
    m484ac0_latch_hit(SELF, &g_w, &g_host);
    CK(L.n == 4);
    CKC0(0, 0x4846c2, SELFP);
    CKC(1, 0x4853b0, SELFP, 1, 3);
    CKC0(2, 0x485f12, SELFP);
    CKC(3, 0x484935, SELFP, 1, 3);
    CK(get32(SELF, 0xa92) == 1 && get16(SELF, 0xa9e) == 3 && get16(SELF, 0xbc5) == 0xfffe && get16(SELF, 0xbc7) == 0xffff);
    /* path B: ax == -1 (also with a non-zero upper half) ends the function after the first callee */
    hit_good();
    g_nscript = 0;
    script(0x4846c2, 1, 0x1ffff, 0, 0, 0);
    m484ac0_latch_hit(SELF, &g_w, &g_host);
    CK(L.n == 1 && get32(SELF, 0xa92) == 0 && get16(SELF, 0xbc5) == 0x1111);
}

/* ---- 0x44b3c8 sum_kinds ------------------------------------------------------------------------------------------------------ */
static float getf(const uint8_t *b, size_t off) { float v; memcpy(&v, b + off, 4); return v; }
static void setf(uint8_t *b, size_t off, float v) { memcpy(b + off, &v, 4); }
static void trip(int i, uint8_t e, int16_t value)
{
    g_r[1][1 + 3 * i] = e;
    set16(g_r[1], 2 + 3 * i, (uint16_t)value);
}
static void kinds_setup(uint8_t kind)
{
    int i;
    setup();
    set32(g_w.table_5bb5e5, 1 * 0x8d, RVA(1));
    g_r[1][0] = kind;
    for (i = 0; i < 10; i++) trip(i, 0x63, 0x1234);
}
static void test_m44b3c8_sum_kinds(void)
{
    kinds_setup(0x1e);
    setf(g_tab, 4 * 0x1e, 55.0f);
    set16(g_tab, 0x3c + 2 * 5, 0x270f);
    set16(g_tab, 0x3c + 2 * 7, 40);
    setf(g_tab, 4 * 0x1f, 9999.0f);
    setf(g_tab, 4 * 0x20, 2.5f);
    trip(1, 5, 250);          /* word table entry 0x270f: nothing */
    trip(2, 7, 300);          /* 300 / 100 * 40 = 120 */
    trip(3, 0x1f, 1000);      /* float cell equal to 9999.0: nothing */
    trip(4, 0x20, 50);        /* 50 / 100 * 2.5 = 1.25 */
    trip(5, 0x64, -7);        /* plain value */
    trip(6, 0x28, 5);         /* report */
    m44b3c8_sum_kinds(0x12340001u, &g_w, &g_host);       /* the upper half of the stack dword is garbage */
    CK(getf(g_tab, 4 * 0x1e) == 114.25f);
    CK(L.n == 3);
    CKC(0, 0x50ca3e, 0, 3, 0x63888b, 0x549088, 0x28);
    CKC(1, 0x52139c, 0, 3, 0x63888b, 0, 0);
    CKC(2, 0x42ba3a, 0, 1, 1);
    /* the kind cell is cleared first; a float cell holding NaN counts as 9999.0 (unordered), and the rounding is single precision of a double quotient and product */
    kinds_setup(0x22);
    setf(g_tab, 4 * 0x22, 77.0f);
    set32(g_tab, 4 * 0x23, 0x7fc00000u);
    trip(0, 0x23, 1000);
    trip(1, 3, 1);
    set16(g_tab, 0x3c + 2 * 3, 3);                       /* 1 / 100 * 3 = 0.03 as a float */
    m44b3c8_sum_kinds(1, &g_w, &g_host);
    CK(get32(g_tab, 4 * 0x22) == 0x3cf5c28fu);
    CK(L.n == 1);
    /* the word table is signed, a value of -32768 and the negative table word -1 */
    kinds_setup(0x27);
    set16(g_tab, 0x3c + 2 * 0x1d, 0xffff);
    trip(9, 0x1d, -32768);                               /* -32768 / 100 * -1 = 327.68 */
    m44b3c8_sum_kinds(1, &g_w, &g_host);
    CK(get32(g_tab, 4 * 0x27) == 0x43a3d70au);
    /* kinds outside 0x1e..0x27: only the debug report (any non-zero word, also a negative one) and the final call; no cell is changed */
    kinds_setup(0x1d);
    setf(g_tab, 4 * 0x1d, 5.0f);
    m44b3c8_sum_kinds(1, &g_w, &g_host);
    CK(L.n == 1 && getf(g_tab, 4 * 0x1d) == 5.0f);
    kinds_setup(0x28);
    g_w.word_63a4cd = (int16_t)0x8000;
    m44b3c8_sum_kinds(1, &g_w, &g_host);
    CK(L.n == 3);
    CKC(0, 0x50ca3e, 0, 3, 0x63888b, 0x549054, 0x28);
    CKC(1, 0x52139c, 0, 3, 0x63888b, 0, 0);
    CKC(2, 0x42ba3a, 0, 1, 1);
    /* 0x28 + kind 0x1e: a report for every pass that has such a byte; e = 0x63 passes are skipped without a call */
    kinds_setup(0x1e);
    trip(0, 0xff, 1);
    trip(9, 0x65, 1);
    m44b3c8_sum_kinds(1, &g_w, &g_host);
    CK(L.n == 5);
    CKC(0, 0x50ca3e, 0, 3, 0x63888b, 0x549088, 0xff);
    CKC(2, 0x50ca3e, 0, 3, 0x63888b, 0x549088, 0x65);
}

/* CASES-END */

static void kinds_setup(uint8_t kind);
static void trip(int i, uint8_t e, int16_t value);
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
        /* SWEEP */
        rect_at(0, (int32_t)(seed % 7) - 3, (int32_t)(seed % 5) - 2, (int32_t)((seed >> 3) % 7) - 3, (int32_t)((seed >> 6) % 5) - 2);
        rect_at(1, (int32_t)((seed >> 9) % 7) - 3, (int32_t)((seed >> 12) % 5) - 2, (int32_t)((seed >> 15) % 7) - 3, (int32_t)((seed >> 18) % 5) - 2);
        g_r[0][0x28 + 0x22] = (uint8_t)seed;
        g_r[0][0x28 + 0x85 + 0x22] = (uint8_t)(seed >> 4);
        m484762_intersect_rects(SELF, 0, 1);
        hit_good();
        for (i = 0; i < 0x100; i++) g_r[0][0x100 + i] = (uint8_t)(seed >> (i & 7));
        set32(SELF, 0xa92, seed & 1);
        set16(SELF, 0xa9e, (uint16_t)(seed % 6));
        g_nscript = 0;
        script(0x4846c2, 1, (seed >> 4) % 6, 0, 0, 0);
        m484ac0_latch_hit(SELF, &g_w, &g_host);
        kinds_setup((uint8_t)(0x1c + seed % 14));
        for (i = 0; i < 10; i++) trip(i, (uint8_t)(seed >> (i + 3)), (int16_t)(seed >> i));
        for (i = 0; i < (int)sizeof g_tab; i++) g_tab[i] = (uint8_t)(seed >> (i & 7));
        m44b3c8_sum_kinds(1, &g_w, &g_host);
        set32(SELF, 0x3ce, RVA(1));
        set32(g_r[1], 0x162, seed | 1);
        set32(g_r[1], 0x28f, RVA(2));
        set32(g_r[2], 0, RVA(3));
        set32(g_r[3], 0x48, VT);
        g_nscript = 0;
        script(0x4f709c, 1, seed >> 5, 0, 0, 0);
        script(VT, 1, seed >> 7, 0, 0, 0);
        m4f61e7_start_record(SELF, 0, &g_w, &g_host);
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
    RUN(test_m4f61e7_start_record);
    RUN(test_m484762_intersect_rects);
    RUN(test_m484ac0_latch_hit);
    RUN(test_m44b3c8_sum_kinds);
    /* RUNS */
    RUN(test_sweep_bounded);
    return failures;
}
