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
        uint32_t rect[4];        /* 0x4c5b3a: the 16 bytes behind its third argument (a local rectangle) */
        int32_t gl[4];           /* the four globals 0x63a8f0..0x63a8fc at the call */
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

static uint16_t g_idxw[8];
static int g_idxw_n, g_idxw_used;

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
        if (callee == 0x4c5b3a && nargs == 5) memcpy(L.c[i].rect, (const void *)args[2], 16);
        L.c[i].gl[0] = g_w.dword_63a8f0;
        L.c[i].gl[1] = g_w.dword_63a8f4;
        L.c[i].gl[2] = g_w.dword_63a8f8;
        L.c[i].gl[3] = g_w.dword_63a8fc;
    }
    L.n++;
    if (callee == 0x4d214b && nargs == 3 && g_idxw_used < g_idxw_n) {        /* the callee stores the glyph index through its third argument (a local word) */
        memcpy((void *)args[2], &g_idxw[g_idxw_used], 2);
        g_idxw_used++;
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
    g_idxw_n = 0;
    g_idxw_used = 0;
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

/* ---- 0x47ef0f latch_hit_counter ---------------------------------------------------------------------------------------------- */
static void hit2_good(void)
{
    setup();
    set16(SELF, 0x1e, 1);
    set32(g_w.table_5bb5e5, 1 * 0x8d, RVA(1));
    set32(g_w.table_5bb5e5, 1 * 0x8d + 0x4d, 1);
    set32(g_w.table_5bb5e5, 0, RVA(2));
    set32(g_w.table_5bb5e5, 0x4d, 1);
    memset(g_r[1] + 0x40, 0, 0x20);
    memset(g_r[2] + 0x40, 0, 0x20);
    g_r[1][0x48] = 1;
    set32(SELF, 0x13c5, 1);
    memset(SELF + 0x13ca, 0, 0x10);
    set16(SELF, 0x1417, 1);
    set32(SELF, 0x1344, 0);
    set16(SELF, 0x13e3, 0x1111);
    set16(SELF, 0x13e5, 0x2222);
}
static void test_m47ef0f_latch_hit_counter(void)
{
    int guard;
    for (guard = 0; guard < 7; guard++) {
        hit2_good();
        switch (guard) {
        case 0: set32(SELF, 0x13c5, 0); break;
        case 1: g_r[1][0x48] = 0; break;
        case 2: g_r[1][0x49] = 7; break;
        case 3: SELF[0x13ce] = 1; break;
        case 4: set32(SELF, 0x13ca, 0x10000); break;
        case 5: set32(g_w.table_5bb5e5, 1 * 0x8d + 0x4d, 0); break;
        default: set16(SELF, 0x1417, 0); break;
        }
        g_nscript = 0;
        script(0x47e9d3, 1, 2, 0, 0, 0);
        m47ef0f_latch_hit_counter(SELF, &g_w, &g_host);
        CK(L.n == 0 && get16(SELF, 0x13e3) == 0x1111 && get32(SELF, 0x1344) == 0);
    }
    hit2_good();                                         /* byte guard at 0x13ce (a set 0x13cf does not stop), word guard at 0x1417 (0x100 is non-zero) */
    SELF[0x13cf] = 1;
    set16(SELF, 0x1417, 0x100);
    script(0x47e9d3, 1, 0xffff, 0, 0, 0);
    m47ef0f_latch_hit_counter(SELF, &g_w, &g_host);
    CK(L.n == 1);
    /* first path: flag set, h = word [0x1350] = 2 */
    hit2_good();
    set32(SELF, 0x1344, 0x10000);
    set16(SELF, 0x1350, 2);
    set32(SELF, 2 * 0x25 + 0x7be, 100);
    set32(SELF, 2 * 0x25 + 0x7b6, 60);
    set32(SELF, 2 * 0x25 + 0x7c2, 5);
    set32(SELF, 2 * 0x25 + 0x7ba, 0x10008);
    SELF[2 * 0x25 + 0x7d7] = 1;                          /* the counter block belongs to the second path only */
    SELF[0x7a0 + 1] = 5;
    m47ef0f_latch_hit_counter(SELF, &g_w, &g_host);
    CK(L.n == 3);
    CKC(0, 0x47fa11, SELFP, 1, 2);
    CKC0(1, 0x480abe, SELFP);
    CKC(2, 0x47ed96, SELFP, 1, 2);
    CK(get16(SELF, 0x13e3) == 40 && get16(SELF, 0x13e5) == 0xfffd && SELF[0x7a0 + 1] == 5);
    /* second path: 0x47e9d3 returns ax = 3; counter index k = 4 with a counter of 2 and a zero record byte: decremented */
    hit2_good();
    g_nscript = 0;
    script(0x47e9d3, 1, 0xabcd0003u, 0, 0, 0);
    set32(SELF, 3 * 0x25 + 0x7be, 7);
    set32(SELF, 3 * 0x25 + 0x7b6, 9);
    set32(SELF, 3 * 0x25 + 0x7c2, 0x20000);
    set32(SELF, 3 * 0x25 + 0x7ba, 1);
    SELF[3 * 0x25 + 0x7d7] = 4;
    SELF[0x7a0 + 4] = 2;
    g_r[1][4 * 0x53 + 0xe9] = 0;
    m47ef0f_latch_hit_counter(SELF, &g_w, &g_host);
    CK(L.n == 4);
    CKC0(0, 0x47e9d3, SELFP);
    CKC(1, 0x47fa11, SELFP, 1, 3);
    CKC0(2, 0x480abe, SELFP);
    CKC(3, 0x47ed96, SELFP, 1, 3);
    CK(get32(SELF, 0x1344) == 1 && get16(SELF, 0x1350) == 3 && get16(SELF, 0x13e3) == 0xfffe && get16(SELF, 0x13e5) == 0xffff && SELF[0x7a0 + 4] == 1);
    /* counter 0: not decremented (no wrap); counter 2 with a non-zero record byte: not decremented */
    hit2_good();
    g_nscript = 0;
    script(0x47e9d3, 1, 3, 0, 0, 0);
    SELF[3 * 0x25 + 0x7d7] = 4;
    SELF[0x7a0 + 4] = 0;
    g_r[1][4 * 0x53 + 0xe9] = 0;
    m47ef0f_latch_hit_counter(SELF, &g_w, &g_host);
    CK(SELF[0x7a0 + 4] == 0);
    hit2_good();
    g_nscript = 0;
    script(0x47e9d3, 1, 3, 0, 0, 0);
    SELF[3 * 0x25 + 0x7d7] = 4;
    SELF[0x7a0 + 4] = 2;
    g_r[1][4 * 0x53 + 0xe9] = 0x80;
    m47ef0f_latch_hit_counter(SELF, &g_w, &g_host);
    CK(SELF[0x7a0 + 4] == 2);
    /* ax == -1: end after the first callee */
    hit2_good();
    g_nscript = 0;
    script(0x47e9d3, 1, 0x1ffff, 0, 0, 0);
    m47ef0f_latch_hit_counter(SELF, &g_w, &g_host);
    CK(L.n == 1 && get32(SELF, 0x1344) == 0 && get16(SELF, 0x13e3) == 0x1111);
}

/* ---- 0x4d270b draw_text ------------------------------------------------------------------------------------------------------ */
#define PIXBASE 0x100u
static void draw_setup(const char *text)
{
    uint8_t *P = g_r[2], *Q = g_r[3];
    setup();
    strcpy((char *)g_r[1], text);
    set32(P, 0xc7 + 32, 100);
    set32(P, 0xcf + 32, 110);
    set32(P, 0xc3 + 32, 10);
    set32(P, 0xcb + 32, 20);
    set32(P, 8 + 0x43, 5);
    set32(P, 8 + 0x3f, 7);
    set16(P, 0x4f, 3);
    set16(P, 0x51, 1);
    set16(P, 0x53, 2);
    set16(P, 0x55, 0);
    set16(P, 0x57, 0);
    set16(Q, 8, 6);
    set16(Q, 10, 4);
    set32(g_r[5], 0, RVA(6) + PIXBASE);
    set16(g_r[5], 0x2f, 0x10);
    memset(g_r[6], 0, RSZ);
    g_w.word_639895 = 2;
}
static uint32_t draw(uint32_t flag)
{
    return m4d270b_draw_text(RVA(1), RVA(2), RVA(3), 0x30000u | 10u, 0x40000u | 20u, 0x1111, RVA(5), 0x50001u, flag, 0x6beefu, &g_w, &g_host);
}
static void test_m4d270b_draw_text(void)
{
    int k;
    /* a glyph from 0x4d214b, index 2, no fill */
    draw_setup("!");
    script(0x4d214b, 1, 1, 0, 0, 0);
    g_idxw[0] = 2;
    g_idxw_n = 1;
    CK(draw(0) == 0x63a8f0);
    CK(L.n == 2);
    CK(L.c[0].callee == 0x4d214b && L.c[0].nargs == 3 && L.c[0].a[0] == 0x21 && L.c[0].a[1] == RVA(2));
    CKC(1, 0x4c5b3a, 0x5cf659, 5, 0x1111, RVA(5), L.c[1].a[2], 0x63a8f0, 0x55a338);
    CK(L.c[1].rect[0] == 17 && L.c[1].rect[1] == 105 && L.c[1].rect[2] == 27 && L.c[1].rect[3] == 115);
    CK(L.c[1].gl[0] == 10 && L.c[1].gl[1] == 17 && L.c[1].gl[2] == 15 && L.c[1].gl[3] == 20);
    CK(g_w.dword_63a8f0 == 17 && g_w.dword_63a8f4 == 17 && g_w.dword_63a8f8 == 22 && g_w.dword_63a8fc == 20);
    CK(get16(g_r[6], 0x254) == 0);
    /* the same with the fill: ofs = trunc(0.9 * 4) + 17 = 20, p = 0x100 + 20 * 0x10 + 10 * 2, 15 - 10 + 1 = 6 words */
    draw_setup("!");
    script(0x4d214b, 1, 1, 0, 0, 0);
    g_idxw[0] = 2;
    g_idxw_n = 1;
    CK(draw(0x100) == 0x63a8f0);
    for (k = 0; k < 6; k++) CK(get16(g_r[6], 0x254 + 2 * (size_t)k) == 0xbeef);
    CK(get16(g_r[6], 0x254 + 12) == 0 && get16(g_r[6], 0x252) == 0);
    /* two glyphs: ofs is computed once (first glyph); x1 is that of the last one: 22 - 10 + 1 = 13 words */
    draw_setup("!!");
    script(0x4d214b, 2, 1, 1, 0, 0);
    g_idxw[0] = 2;
    g_idxw[1] = 2;
    g_idxw_n = 2;
    CK(draw(1) == 0x63a8f0);
    CK(L.n == 4 && L.c[3].gl[0] == 17 && L.c[3].gl[1] == 17 && L.c[3].gl[2] == 22);
    CK(g_w.dword_63a8f0 == 24 && g_w.dword_63a8f8 == 29);
    for (k = 0; k < 13; k++) CK(get16(g_r[6], 0x254 + 2 * (size_t)k) == 0xbeef);
    CK(get16(g_r[6], 0x254 + 26) == 0);
    /* upper, lower and digit lookups (the index is 2 each time) with the sign-extended character passed to the class routines */
    draw_setup("A");
    script(0x4d214b, 1, 0, 0, 0, 0);
    script(0x50d651, 1, 1, 0, 0, 0);
    script(0x50d67f, 1, 1, 0, 0, 0);
    draw(0);
    CK(L.n == 4);
    CK(L.c[0].a[0] == 0x41 && L.c[1].callee == 0x50d651 && L.c[1].a[0] == 0x41 && L.c[2].callee == 0x50d67f && L.c[2].a[0] == 0x41 && L.c[3].callee == 0x4c5b3a);
    CK(L.c[3].rect[0] == 17 && g_w.dword_63a8f0 == 17);
    draw_setup("c");
    script(0x4d214b, 1, 0, 0, 0, 0);
    script(0x50d651, 2, 0, 1, 0, 0);
    script(0x50d6a7, 1, 1, 0, 0, 0);
    draw(0);
    CK(L.n == 5 && L.c[1].callee == 0x50d651 && L.c[2].callee == 0x50d651 && L.c[3].callee == 0x50d6a7 && L.c[4].callee == 0x4c5b3a && L.c[4].rect[0] == 17);
    draw_setup("2");
    script(0x4d214b, 1, 0, 0, 0, 0);
    script(0x50d651, 2, 0, 0, 0, 0);
    script(0x50d6cf, 1, 1, 0, 0, 0);
    draw(0);
    CK(L.n == 5 && L.c[3].callee == 0x50d6cf && L.c[3].a[0] == 0x32 && L.c[4].callee == 0x4c5b3a && L.c[4].rect[0] == 17);
    /* a byte of 0x80 or more passes none of the three class tests: the pen advances by word [layout+0x4f] = 3, nothing is drawn */
    draw_setup("\x80");
    script(0x4d214b, 1, 0, 0, 0, 0);
    script(0x50d651, 2, 1, 1, 0, 0);
    script(0x50d67f, 1, 1, 0, 0, 0);
    script(0x50d6a7, 1, 1, 0, 0, 0);
    script(0x50d6cf, 1, 1, 0, 0, 0);
    draw(0);
    CK(L.n == 6 && L.c[0].a[0] == 0x80 && L.c[1].a[0] == 0xffffff80u && L.c[2].callee == 0x50d67f && L.c[3].callee == 0x50d651 && L.c[4].callee == 0x50d6a7 && L.c[5].callee == 0x50d6cf);
    CK(g_w.dword_63a8f0 == 13 && g_w.dword_63a8f8 == 15 && g_w.dword_63a8f4 == 0);
    /* NATIVE REJECTION: flag != 0 without a drawn glyph writes nothing (the original would use stack garbage) */
    draw_setup("\x80");
    script(0x4d214b, 1, 0, 0, 0, 0);
    script(0x50d651, 2, 0, 0, 0, 0);
    script(0x50d6cf, 1, 0, 0, 0, 0);
    CK(draw(1) == 0x63a8f0);
    for (k = 0; k < 64; k++) CK(g_r[6][k * 8] == 0);
    CK(g_w.dword_63a8f0 == 13);
    /* the debug report: only when the debug word is non-zero (a negative one counts) and a destination is 0 */
    draw_setup("");
    g_w.word_63a4cd = (int16_t)0x8000;
    CK(m4d270b_draw_text(RVA(1), RVA(2), RVA(3), 10, 20, 0, RVA(5), 1, 0, 0, &g_w, &g_host) == 0x63a8f0);
    CK(L.n == 2);
    CKC(0, 0x52139c, 0, 3, 0x55a2fc, 0, 0);
    CKC0(1, 0x4c97b4, 0x5cf659);
    CK(g_w.dword_63a8f0 == 10 && g_w.dword_63a8f4 == 0 && g_w.dword_63a8f8 == 0 && g_w.dword_63a8fc == 20);
    L.n = 0;
    m4d270b_draw_text(RVA(1), RVA(2), RVA(3), 10, 20, 5, 0, 1, 0, 0, &g_w, &g_host);
    CK(L.n == 2);
    L.n = 0;
    m4d270b_draw_text(RVA(1), RVA(2), RVA(3), 10, 20, 5, RVA(5), 1, 0, 0, &g_w, &g_host);
    CK(L.n == 0);
    g_w.word_63a4cd = 0;
    m4d270b_draw_text(RVA(1), RVA(2), RVA(3), 10, 20, 0, 0, 1, 0, 0, &g_w, &g_host);
    CK(L.n == 0);
    /* an empty string with flag: x1 is not set, so nothing is drawn (native rejection as above) */
    draw_setup("");
    draw(1);
    CK(L.n == 0 && g_r[6][0x14 + PIXBASE] == 0);
}

/* CASES-END */

static void draw_setup(const char *text);
static void hit2_good(void);
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
        hit2_good();
        for (i = 0; i < 0x100; i++) g_r[0][0x7a0 + i] = (uint8_t)(seed >> (i & 7));
        set32(SELF, 0x1344, seed & 1);
        set16(SELF, 0x1350, (uint16_t)(seed % 6));
        g_nscript = 0;
        script(0x47e9d3, 1, (seed >> 4) % 6, 0, 0, 0);
        m47ef0f_latch_hit_counter(SELF, &g_w, &g_host);
        draw_setup("");
        for (i = 0; i < 0x100; i++) {
            set16(g_r[3], (size_t)i * 4, (uint16_t)(i % 7));
            set16(g_r[3], (size_t)i * 4 + 2, (uint16_t)(1 + i % 5));
        }
        for (i = 0; i < 6; i++) g_r[1][i] = (uint8_t)(0x30 + ((seed >> (3 * i)) % 0x30));
        g_nscript = 0;
        script(0x4d214b, 4, seed >> 1, seed >> 2, seed >> 3, seed >> 4);
        script(0x50d651, 4, seed >> 5, seed >> 6, seed >> 7, seed >> 8);
        script(0x50d67f, 2, seed >> 9, seed >> 10, 0, 0);
        script(0x50d6a7, 2, seed >> 11, seed >> 12, 0, 0);
        script(0x50d6cf, 2, seed >> 13, seed >> 14, 0, 0);
        g_idxw[0] = (uint16_t)(seed % 8);
        g_idxw[1] = (uint16_t)((seed >> 3) % 8);
        g_idxw_n = 2;
        m4d270b_draw_text(RVA(1), RVA(2), RVA(3), 10, 20, 0x1111, RVA(5), seed % 4, seed >> 7, seed, &g_w, &g_host);
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
    RUN(test_m47ef0f_latch_hit_counter);
    RUN(test_m4d270b_draw_text);
    /* RUNS */
    RUN(test_sweep_bounded);
    return failures;
}
