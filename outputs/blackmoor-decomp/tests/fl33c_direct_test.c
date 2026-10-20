/* FL-33 (batch c) direct tests of the six methods of GAME.EXE in src/original_methods_fl33c.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl33c_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl33c.h"

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

/* host memory: region i lives at the original address RVA(i); region 0 is `self`. The data of the original image that a function reads through Fl18Host.resolve (strings ...) lives in g_img,
 * 0x540000 + offset. */
#define RVA(i) (0x20000000u + 0x10000u * (uint32_t)(i))
#define RSZ 0x4000
#define IMG_BASE 0x540000u
static uint8_t g_r[8][RSZ];
static uint8_t g_img[0x30000];
static Fl33cWorld g_w;
static Fl18Host g_host;
#define SELF g_r[0]
#define SELFP ((uintptr_t)SELF)

#define UNUSED __attribute__((unused))
UNUSED static void set32(uint8_t *b, size_t off, uint32_t v) { memcpy(b + off, &v, 4); }
UNUSED static void set16(uint8_t *b, size_t off, uint16_t v) { memcpy(b + off, &v, 2); }
UNUSED static uint32_t get32(const uint8_t *b, size_t off) { uint32_t v; memcpy(&v, b + off, 4); return v; }
UNUSED static uint16_t get16(const uint8_t *b, size_t off) { uint16_t v; memcpy(&v, b + off, 2); return v; }

#define MAXCALL 96
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[16];
        uint8_t sp[0x40];        /* the first 0x40 bytes of self at the call */
        uint8_t r4[0x100];       /* the first 0x100 bytes of region 4 at the call */
    } c[MAXCALL];
} L;
#define MAXS 16
static struct {
    uint32_t callee, results[16];
    int n, used;
} S[MAXS];
static int g_nscript;
static struct {
    uint32_t callee;
    int call, arg, offset, size;
    uint32_t value;
} W[16];
static int g_nwrites;

UNUSED static void script(uint32_t callee, uint32_t r0)
{
    S[g_nscript].callee = callee;
    S[g_nscript].n = 1;
    S[g_nscript].used = 0;
    S[g_nscript].results[0] = r0;
    g_nscript++;
}
UNUSED static void script_more(uint32_t callee, uint32_t r)
{
    int k;
    for (k = 0; k < g_nscript; k++)
        if (S[k].callee == callee) { S[k].results[S[k].n++] = r; return; }
}
/* the call number `call` (0 based) of `callee` stores `size` bytes of `value` at args[arg] + offset (a host pointer) */
UNUSED static void script_write(uint32_t callee, int call, int arg, int offset, int size, uint32_t value)
{
    W[g_nwrites].callee = callee;
    W[g_nwrites].call = call;
    W[g_nwrites].arg = arg;
    W[g_nwrites].offset = offset;
    W[g_nwrites].size = size;
    W[g_nwrites].value = value;
    g_nwrites++;
}

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int k, i = L.n, nth = 0;
    uint32_t result = 0;
    (void)ctx;
    for (k = 0; k < i && k < MAXCALL; k++)
        if (L.c[k].callee == callee) nth++;
    if (L.n < MAXCALL) {
        L.c[i].callee = callee;
        L.c[i].this_ptr = this_ptr;
        L.c[i].nargs = nargs;
        for (k = 0; k < nargs && k < 16; k++) L.c[i].a[k] = args[k];
        memcpy(L.c[i].sp, g_r[0], sizeof L.c[i].sp);
        memcpy(L.c[i].r4, g_r[4], sizeof L.c[i].r4);
    }
    L.n++;
    for (k = 0; k < g_nwrites; k++)
        if (W[k].callee == callee && W[k].call == nth) {
            uint8_t *p = (uint8_t *)args[W[k].arg] + W[k].offset;
            if (W[k].size == 2) set16(p, 0, (uint16_t)W[k].value);
            else set32(p, 0, W[k].value);
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
    if (a >= IMG_BASE && a < IMG_BASE + sizeof g_img) return g_img + (a - IMG_BASE);
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
    for (b = 0; b < sizeof g_img; b++) g_img[b] = (uint8_t)(b * 5 + 1);
    memset(&g_w, 0, sizeof g_w);
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    L.n = 0;
    g_nscript = 0;
    g_nwrites = 0;
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
#define SELFV SELFP

/* ---- 0x4c6929 ------------------------------------------------------------------------------------------------------------------ */
/* layout: object a at RVA(1)+0x10 ([a] = pointer to the source, word hw at +0x2f); the rectangles r1 (x0 y0 x1 y1), r2, r3 at RVA(2)+3, +0x23, +0x43 (unaligned); source words at RVA(3)+0x100;
 * destination at RVA(4)+0x40 (v2); mask at RVA(5)+0x40. */
#define CM_A (RVA(1) + 0x10)
#define CM_R1 (RVA(2) + 3)
#define CM_R2 (RVA(2) + 0x23)
#define CM_R3 (RVA(2) + 0x43)
#define CM_MASK (RVA(5) + 0x40)
static void cm_rect(size_t off, int32_t x0, int32_t y0, int32_t x1, int32_t y1)
{
    set32(g_r[2], off, (uint32_t)x0);
    set32(g_r[2], off + 4, (uint32_t)y0);
    set32(g_r[2], off + 8, (uint32_t)x1);
    set32(g_r[2], off + 12, (uint32_t)y1);
}
/* r1 = (1,2,3,3): 3 columns, 2 rows; r3 = (1,1,5,9): the mask starts at c + 1 * 6 + 1 and a row is 6 bytes apart; source step hw/2 words, destination step v1/2 words */
static void cm_setup(int32_t hw, uint32_t v1)
{
    int i;
    setup();
    memset(g_r[4], 0xee, 0x300);
    memset(g_r[5], 0x55, 0x100);
    g_w.word_639895 = 2;
    set32(g_r[1], 0x10, RVA(3) + 0x100 - (uint32_t)(2 * hw + 1 * 2));          /* src = [a] + y0 * hw + x0 * 2 = RVA(3) + 0x100 */
    set16(g_r[1], 0x10 + 0x2f, (uint16_t)hw);
    cm_rect(3, 1, 2, 3, 3);
    cm_rect(0x23, 10, 20, 12, 21);
    cm_rect(0x43, 1, 1, 5, 9);
    for (i = 0; i < 16; i++) set16(g_r[3], 0x100 + 2 * (size_t)i, (uint16_t)(0x1000 + i));
    for (i = 0; i < 32; i++) set16(g_r[3], 0x100 - 64 + 2 * (size_t)i, (uint16_t)(0x1000 + i - 32));
    g_r[5][0x40] = 1; g_r[5][0x41] = 0; g_r[5][0x42] = 0x80;               /* row 0, columns 0..2 */
    g_r[5][0x46] = 0; g_r[5][0x47] = 0xff; g_r[5][0x48] = 0;               /* row 1: 6 bytes further */
    script_write(0x4c4067, 0, 2, 0x10, 4, v1);
    script_write(0x4c4067, 0, 2, 0x24, 4, RVA(4) + 0x40);
    set32(SELF, 0xc, 0x4444);
}
static int cm_call(uint32_t a, uint32_t b)
{
    return m4c6929_copy_masked(SELF, a, b, CM_MASK - 7, CM_R1, CM_R2, CM_R3, 0xd00d, &g_w, &g_host);
}
static void test_m4c6929_copy_masked(void)
{
    uint8_t want4[0x300];
    uintptr_t desc;
    cm_setup(8, 0x11);                                    /* sstep = 4 words (8 bytes), dstep = 8 words (16 bytes) */
    memcpy(want4, g_r[4], sizeof want4);
    CK(cm_call(CM_A, 0x4444) == 0);
    set16(want4, 0x40, 0x1000);                           /* row 0, column 0 */
    set16(want4, 0x44, 0x1002);                           /* row 0, column 2 */
    set16(want4, 0x40 + 16 + 2, 0x1000 + 4 + 1);          /* row 1: source 8 bytes further, column 1 */
    CK(memcmp(g_r[4], want4, sizeof want4) == 0);
    CK(L.n == 3);
    desc = L.c[0].a[2];
    CKC(0, 0x4c4067, SELFP, 5, 0x4444, CM_R2, desc, 0xd00d, 0x20);
    CKC(1, 0x4c4202, SELFP, 3, 0x4444, CM_R2, 0x555164);
    CKC(2, 0x4c952f, SELFP, 1, CM_R2);
    CK(get16(L.c[1].r4, 0x40) == 0x1000 && get16(L.c[1].r4, 0x44) == 0x1002);      /* the copy precedes the callee 0x4c4202 */
    /* b != [self+0xc]: no 0x4c952f */
    cm_setup(8, 0x11);
    CK(cm_call(CM_A, 0x4443) == 0);
    CK(L.n == 2);
    /* hw = -7 and 0x11 -> sstep = -3 words (-6 bytes), dstep = 8: row 1 reads the words 3 before */
    cm_setup(-7, 0x11);
    CK(cm_call(CM_A, 0x4444) == 0);
    CK(get16(g_r[4], 0x40) == 0x1000 && get16(g_r[4], 0x44) == 0x1002 && get16(g_r[4], 0x40 + 16 + 2) == 0x1000 - 3 + 1);
    /* v1 = -0x11 -> dstep = -8 words: row 1 is written 16 bytes before */
    cm_setup(8, (uint32_t)-0x11);
    set32(g_r[0], 0xc, 0);
    script_write(0x4c4067, 0, 2, 0x24, 4, RVA(4) + 0x80);
    CK(cm_call(CM_A, 0) == 0);                            /* b == 0 == [self+0xc] still takes the 0x4c952f call */
    CK(get16(g_r[4], 0x80) == 0x1000 && get16(g_r[4], 0x84) == 0x1002 && get16(g_r[4], 0x80 - 16 + 2) == 0x1005);
    CKC(2, 0x4c952f, SELFP, 1, CM_R2);
    /* rows and columns are SIGNED counts: rows = 0x80000000, cols = -1 .. 0 */
    cm_setup(8, 0x11);
    memcpy(want4, g_r[4], sizeof want4);
    cm_rect(3, 1, 2, 3, (int32_t)0x80000001u);                  /* rows = 0x80000000 (negative) */
    CK(cm_call(CM_A, 0x4444) == 0 && memcmp(g_r[4], want4, sizeof want4) == 0 && L.n == 3);
    cm_rect(3, 1, 2, 0, 3);                               /* cols = 0 */
    CK(cm_call(CM_A, 0x4444) == 0 && memcmp(g_r[4], want4, sizeof want4) == 0);
    cm_rect(3, 1, 2, -5, 3);                              /* cols = -5 */
    CK(cm_call(CM_A, 0x4444) == 0 && memcmp(g_r[4], want4, sizeof want4) == 0);
    cm_rect(3, 1, 2, 3, 1);                               /* rows = 0 */
    CK(cm_call(CM_A, 0x4444) == 0 && memcmp(g_r[4], want4, sizeof want4) == 0);
    /* the debug word is a WORD test: 0x100 is on, 0 is off */
    cm_setup(8, 0x11);
    g_w.word_63a4cd = 0x100;
    cm_rect(CM_R2 - RVA(2), 10, 20, 12, 21);              /* r2 is 2 x 1 wide, r1 is 2 x 1 (x1 - x0 = 2, y1 - y0 = 1): equal sizes */
    CK(cm_call(CM_A, 0x4444) == 0 && L.n == 3 && L.c[0].callee == 0x4c4067);
    /* different x size: format 0x555054 with d and the eight rectangle values, then 0x52139c and 0x4c97b4 */
    cm_setup(8, 0x11);
    g_w.word_63a4cd = 0x8000;
    cm_rect(CM_R2 - RVA(2), 10, 20, 13, 21);
    memcpy(want4, g_r[4], sizeof want4);
    CK(cm_call(CM_A, 0x4444) == 0 && L.n == 3 && memcmp(g_r[4], want4, sizeof want4) == 0);
    {
        const uintptr_t w[11] = {L.c[0].a[0], 0x555054, 0xd00d, 1, 2, 3, 3, 10, 20, 13, 21};
        ck_call(__LINE__, 0, 0x50ca3e, 0, 11, w);
    }
    CKC(1, 0x52139c, 0, 3, L.c[0].a[0], 0, 0);
    CKC0(2, 0x4c97b4, SELFP);
    /* different y size only */
    cm_setup(8, 0x11);
    g_w.word_63a4cd = 1;
    cm_rect(CM_R2 - RVA(2), 10, 20, 12, 25);
    CK(cm_call(CM_A, 0x4444) == 0 && L.n == 3 && L.c[0].a[1] == 0x555054);
    /* equal sizes, a == 0 or b == 0: format 0x5550e8 */
    cm_setup(8, 0x11);
    g_w.word_63a4cd = 0xffff;
    cm_rect(CM_R2 - RVA(2), 10, 20, 12, 21);
    CK(cm_call(0, 0x4444) == 0 && L.n == 3 && L.c[0].callee == 0x50ca3e && L.c[0].a[1] == 0x5550e8 && L.c[0].a[2] == 0xd00d && L.c[0].a[10] == 21);
    cm_setup(8, 0x11);
    g_w.word_63a4cd = 0xffff;
    cm_rect(CM_R2 - RVA(2), 10, 20, 12, 21);
    CK(cm_call(CM_A, 0) == 0 && L.n == 3 && L.c[0].a[1] == 0x5550e8);
    /* a == 0 with the debug word zero: the original faults after the first callee; the port rejects there and changes nothing */
    cm_setup(8, 0x11);
    memcpy(want4, g_r[4], sizeof want4);
    CK(cm_call(0, 0x4444) == 1 && L.n == 1 && L.c[0].callee == 0x4c4067 && memcmp(g_r[4], want4, sizeof want4) == 0);
}

/* ---- 0x416af3 ------------------------------------------------------------------------------------------------------------------ */
/* layout: header at RVA(0)+3 (count at +0xa, kind at +0xe), the stream at RVA(1)+1, the word buffer `out` at RVA(4)+0x80 (so the region snapshot at each call shows out-0x80 .. out+0x7f),
 * the full-copy source `base` at RVA(3)+0x10. */
#define PA_HDR (RVA(0) + 3)
#define PA_STREAM (RVA(1) + 1)
#define PA_OUT (RVA(4) + 0x80)
#define PA_BASE (RVA(3) + 0x10)
static size_t pa_cur;
static uint8_t *pa_s(void) { return g_r[1] + 1; }
static void pa_b(uint8_t v) { g_r[1][1 + pa_cur++] = v; }
static void pa_d(uint32_t v) { set32(g_r[1], 1 + pa_cur, v); pa_cur += 4; }
static void pa_w(uint16_t v) { set16(g_r[1], 1 + pa_cur, v); pa_cur += 2; }
static void pa_x20(int32_t off, uint32_t n, uint8_t first)    /* n * 2 data bytes first, first + 1, ... (at most 20) */
{
    uint32_t i;
    pa_b(0x20); pa_d((uint32_t)off); pa_d(n);
    for (i = 0; i < ((n * 2u) & 0xffffffffu) && i < 20; i++) pa_b((uint8_t)(first + i));
}
static void pa_x40(uint16_t word, int32_t off, uint32_t val) { pa_b(0x40); pa_w(word); pa_d((uint32_t)off); pa_d(val); }
static void pa_x80(uint8_t m, int32_t k, uint8_t first, int32_t o0, int32_t o1)
{
    uint32_t i;
    pa_b(0x80); pa_b(m); pa_d((uint32_t)k);
    for (i = 0; i < 2u * m && i < 20; i++) pa_b((uint8_t)(first + i));
    if (k >= 1) pa_d((uint32_t)o0);
    if (k >= 2) pa_d((uint32_t)o1);
}
static void pa_setup(uint8_t kind)
{
    setup();
    memset(g_r[4], 0xee, RSZ);
    set32(g_r[0], 3 + 0xa, 0);
    g_r[0][3 + 0xe] = kind;
    pa_cur = 0;
    (void)pa_s;
}
static void pa_count(uint32_t count) { set32(g_r[0], 3 + 0xa, count); }
static int pa_call(uint32_t size, uint32_t flag)
{
    return m416af3_apply_patches(PA_HDR, PA_OUT, size, PA_STREAM, PA_BASE, flag, &g_host);
}
static void test_m416af3_apply_patches(void)
{
    uint8_t want[RSZ];
    int k, i;
    for (k = 1; k <= 2; k++) {
        /* x20 (off 3, 5 words a0..a9), x40 (word 0x1234, off 5, 0xdeadbeef), x80 (m = 3 -> e0..e5, K = 2, offsets 4 and -6) */
        pa_setup((uint8_t)k);
        for (i = 0; i < 64; i++) g_r[3][0x10 + i] = (uint8_t)(0x30 + i);
        pa_x20(3, 5, 0xa0);
        pa_x40(0x1234, 5, 0xdeadbeefu);
        pa_x80(3, 2, 0xe0, 4, -6);
        pa_count((uint32_t)pa_cur);
        memcpy(want, g_r[4], RSZ);
        if (k == 2) memcpy(want + 0x80, g_r[3] + 0x10, 7);                 /* the full copy of `size` = 7 bytes (flag == 0) */
        memcpy(want + 0x80 + 6, "\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9", 10);
        memcpy(want + 0x80 + 8, "\xe0\xe1\xe2\xe3\xe4\xe5", 6);
        memcpy(want + 0x80 - 12, "\xe0\xe1\xe2\xe3\xe4\xe5", 6);
        CK(pa_call(7, 0) == 0);
        CK(memcmp(g_r[4], want, RSZ) == 0);
        if (k == 1) {
            CK(L.n == 2);
            CKC(0, 0x43ef77, 0x5d2f2d, 3, PA_OUT + 10, 0x1234, 0xdeadbeefu);
            CKC(1, 0x4c7314, 0x5cf659, 2, PA_OUT, 7);                      /* after the loop */
            CK(L.c[1].r4[0x80 + 6] == 0xa0 && L.c[1].r4[0x80 - 12] == 0xe0);
        } else {
            CK(L.n == 5);
            CKC(0, 0x4c7314, 0x5cf659, 2, PA_OUT + 6, 10);                 /* x20: after its copy */
            CK(L.c[0].r4[0x80 + 6] == 0xa0 && L.c[0].r4[0x80 + 15] == 0xa9 && L.c[0].r4[0x80 + 0] == 0x30);
            CKC(1, 0x43ef77, 0x5d2f2d, 3, PA_OUT + 10, 0x1234, 0xdeadbeefu);
            CKC(2, 0x4c7314, 0x5cf659, 2, PA_OUT + 10, 0xbd5b7ddeu);       /* 0xdeadbeef * 2 (32-bit) */
            CKC(3, 0x4c7314, 0x5cf659, 2, PA_OUT + 8, 6);
            CK(L.c[3].r4[0x80 + 8] == 0xe0 && L.c[3].r4[0x80 - 12] == 0xee);
            CKC(4, 0x4c7314, 0x5cf659, 2, PA_OUT - 12, 6);
        }
    }
    /* kind 2 with a flag whose low word is zero: non-zero, so no full copy */
    pa_setup(2);
    for (i = 0; i < 64; i++) g_r[3][0x10 + i] = (uint8_t)(0x30 + i);
    pa_x40(1, 0, 2);
    pa_count((uint32_t)pa_cur);
    memcpy(want, g_r[4], RSZ);
    CK(pa_call(7, 0x10000) == 0 && memcmp(g_r[4], want, RSZ) == 0 && L.n == 2);
    /* the count is a SIGNED compare: 0x80000000 | length runs nothing (kind 1 still makes the final call, kind 2 makes none) */
    pa_setup(1);
    pa_x20(3, 2, 0xa0);
    pa_count(0x80000000u | (uint32_t)pa_cur);
    memcpy(want, g_r[4], RSZ);
    CK(pa_call(9, 0) == 0 && memcmp(g_r[4], want, RSZ) == 0 && L.n == 1);
    CKC(0, 0x4c7314, 0x5cf659, 2, PA_OUT, 9);
    pa_count(0);
    L.n = 0;
    CK(pa_call(9, 0) == 0 && L.n == 1);
    /* n = 0x80000000: n * 2 wraps to 0 bytes copied and idx advances by 9 only, so the next op follows at once */
    pa_setup(1);
    pa_x20(3, 0x80000000u, 0xa0);
    pa_x40(7, 4, 0x11223344u);
    pa_count((uint32_t)pa_cur);
    memcpy(want, g_r[4], RSZ);
    CK(pa_call(0, 0) == 0 && memcmp(g_r[4], want, RSZ) == 0 && L.n == 2);
    CKC(0, 0x43ef77, 0x5d2f2d, 3, PA_OUT + 8, 7, 0x11223344u);
    /* K = -1 (signed): no iteration, the op after it is then read at the right place */
    pa_setup(1);
    pa_x80(3, -1, 0xe0, 0, 0);
    pa_x20(0, 1, 0x77);
    pa_count((uint32_t)pa_cur);
    CK(pa_call(0, 0) == 0 && get16(g_r[4], 0x80) == 0x7877 && L.n == 1);
    /* an unknown opcode after a valid op: the original never finishes; the port returns 1 with the first op done and no final call */
    pa_setup(1);
    pa_x20(1, 2, 0x50);
    pa_b(0x21);
    pa_count((uint32_t)pa_cur);
    memcpy(want, g_r[4], RSZ);
    memcpy(want + 0x80 + 2, "\x50\x51\x52\x53", 4);
    CK(pa_call(9, 0) == 1 && memcmp(g_r[4], want, RSZ) == 0 && L.n == 0);
    pa_setup(2);
    pa_b(0xa0);
    pa_count(1);
    CK(pa_call(9, 1) == 1 && L.n == 0);
    pa_setup(2);
    pa_b(0x00);
    pa_count(0);                                       /* the loop never starts: not an unknown opcode */
    CK(pa_call(9, 1) == 0 && L.n == 0);
    /* any other kind: nothing */
    for (k = 0; k < 4; k++) {
        if (k == 1 || k == 2) continue;
        pa_setup((uint8_t)(k == 0 ? 0 : 0x81));
        pa_x20(3, 2, 0xa0);
        pa_count((uint32_t)pa_cur);
        memcpy(want, g_r[4], RSZ);
        CK(pa_call(9, 0) == 0 && memcmp(g_r[4], want, RSZ) == 0 && L.n == 0);
    }
}

/* TESTS-END */

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
        /* 0x4c6929: a valid layout with random masks and source words */
        cm_setup((int32_t)(seed % 17) - 8, seed >> 7);
        for (i = 0; i < 0x100; i++) g_r[5][i] = (uint8_t)(seed >> (i % 7));
        g_w.word_63a4cd = (int16_t)(seed % 3);
        cm_rect(CM_R2 - RVA(2), 10, 20, 12, 21);
        script_write(0x4c4067, 0, 2, 0x24, 4, RVA(4) + 0x100);
        script_write(0x4c4067, 0, 2, 0x10, 4, (uint32_t)((int32_t)(seed % 33) - 16));
        cm_call(CM_A, seed & 1 ? 0x4444 : 0);
        L.n = 0;
        /* 0x416af3: a valid stream (x20, x40, x80), kind 1 or 2 */
        pa_setup((uint8_t)(1 + (seed & 1)));
        pa_x20((int32_t)(seed % 40) - 20, seed % 6, (uint8_t)seed);
        pa_x40((uint16_t)seed, (int32_t)(seed % 30) - 10, seed);
        pa_x80((uint8_t)(seed % 8), (int32_t)(seed % 3), (uint8_t)(seed >> 3), (int32_t)(seed % 50), -(int32_t)(seed % 50));
        pa_count((uint32_t)pa_cur);
        pa_call(seed % 40, seed >> 9 & 1);
        L.n = 0;
        /* SWEEP-END */
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
    RUN(test_m4c6929_copy_masked);
    RUN(test_m416af3_apply_patches);
    /* RUN-END */
    RUN(test_sweep_bounded);
    return failures;
}
