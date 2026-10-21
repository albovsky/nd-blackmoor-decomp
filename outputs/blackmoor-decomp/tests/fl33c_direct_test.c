/* FL-33 (batch c) direct tests of the four methods of GAME.EXE in src/original_methods_fl33c.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
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
        uint32_t d16[4];         /* four dwords behind a host pointer in argument 2 (the local rect of 0x4d2c20), at the call */
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
static uint32_t g_retarg_callee;      /* a callee that returns the LOW 32 BITS of its argument 0 (a host pointer), as the game's 0x4daeb5 does */

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
        memset(L.c[i].d16, 0, sizeof L.c[i].d16);
        if (callee == 0x4c5d4b && nargs > 2 && args[2] > 0xffffffffu) memcpy(L.c[i].d16, (const void *)args[2], 16);
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
    if (callee == g_retarg_callee && nargs > 0) result = (uint32_t)args[0];
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
    g_retarg_callee = 0;
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
    (void)m4c6929_copy_masked;
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
    g_w.word_63a4cd = (int16_t)0x8000;
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
    g_w.word_63a4cd = (int16_t)0xffff;
    cm_rect(CM_R2 - RVA(2), 10, 20, 12, 21);
    CK(cm_call(0, 0x4444) == 0 && L.n == 3 && L.c[0].callee == 0x50ca3e && L.c[0].a[1] == 0x5550e8 && L.c[0].a[2] == 0xd00d && L.c[0].a[10] == 21);
    cm_setup(8, 0x11);
    g_w.word_63a4cd = (int16_t)0xffff;
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
    (void)m416af3_apply_patches;
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

/* ---- 0x4db38a ------------------------------------------------------------------------------------------------------------------ */
/* tables: the word pairs at 0x5b3790 in g_r[6], the dwords at 0x5b30cc in g_r[7]; indexes b44f0 = 1, b44f4 = 2 -> e = 16, f = 32 */
static void uc_setup(uint32_t px, uint32_t py)
{
    setup();
    memset(SELF, 0x11, 0x100);
    g_w.table_5b3790 = g_r[6];
    g_w.table_5b30cc = g_r[7];
    g_w.word_5d2f0d = 10;
    g_w.word_5d2f0f = 10;
    g_w.value_583204 = 2;                       /* 0..3 after the subtraction: skip the default block */
    g_w.value_5b44f0 = 1;
    g_w.value_5b44f4 = 2;
    g_w.value_583106 = 1000;
    g_w.value_583102 = 2000;
    g_w.value_5d16cd = 0x77;
    g_w.value_5d1683 = 0x78;
    set16(g_r[6], 16, 3);                      /* x extent  (0x5b3790 + e) */
    set16(g_r[6], 18, 5);                      /* y extent  (0x5b3792 + e) */
    set32(g_r[7], 32, 0x100);                  /* 0x5b30cc + f */
    set32(g_r[7], 36, 0x200);                  /* 0x5b30d0 + f */
    set32(SELF, 0x34, 100);
    set32(SELF, 0x38, 200);
    set32(SELF, 0x3c, 300);
    set32(SELF, 0x40, 400);
    g_retarg_callee = 0x4daeb5;
    script_write(0x4daeb5, 0, 0, 0, 4, px);
    script_write(0x4daeb5, 0, 0, 4, 4, py);
}
static void test_m4db38a_update_cursor(void)
{
    (void)m4db38a_update_cursor;
    uintptr_t pair;
    uc_setup(104, 195);                         /* dx = 4, dy = -5: inside the limits */
    m4db38a_update_cursor(SELF, &g_w, &g_host);
    CK(get32(SELF, 0x14) == 104 && get32(SELF, 0x18) == 195 && get32(SELF, 0x94) == 4 && get32(SELF, 0x98) == 5);
    CK(get32(SELF, 0x38) == 195 && get32(SELF, 0x40) == 195 + 5 - 1 && get32(SELF, 0x34) == 104 && get32(SELF, 0x3c) == 104 + 3 - 1);
    CK(get32(SELF, 0x1c) == 104 && get32(SELF, 0x20) == 195 && get32(SELF, 0x9c) == 1000 + 0x200 && get32(SELF, 0xa0) == 2000 + 0x100);
    CK(g_w.value_5c3a53 == 2000 + 0x100 && g_w.value_5c3a57 == 1000 + 0x200 && g_w.value_5d16cd == 0 && g_w.value_5d1683 == 0);
    CK(L.n == 5);
    pair = L.c[1].a[0];
    CKC0(0, 0x4dadff, 0x5830a6);
    CKC(1, 0x4daeb5, 0x5830a6, 1, pair);
    CKC0(2, 0x4dbb13, SELFP);
    CKC0(3, 0x4dbb13, SELFP);
    CKC(4, 0x4dae88, 0x5830a6, 2, 104, 195);
    CK(get32(L.c[2].sp, 0x14) == 104 && get32(L.c[2].sp, 0x34) == 100);        /* the first 0x4dbb13 sees the new position and the old one */
    /* clamps: dx = 30 > 10 (positive) -> x0 + 10; dy = -50 (|dy| = 50 > 10, not positive) -> y0 - 10 */
    uc_setup(130, 150);
    m4db38a_update_cursor(SELF, &g_w, &g_host);
    CK(get32(SELF, 0x14) == 110 && get32(SELF, 0x18) == 190 && get32(SELF, 0x94) == 30 && get32(SELF, 0x98) == 50);
    CKC(4, 0x4dae88, 0x5830a6, 2, 110, 190);
    CK(get32(L.c[3].sp, 0x14) == 110);                                       /* clamped before the second 0x4dbb13 */
    /* the limit itself (|dx| == 10) does not clamp; a negative limit clamps even for dx == 0 and then goes to x0 - limit */
    uc_setup(110, 190);
    m4db38a_update_cursor(SELF, &g_w, &g_host);
    CK(get32(SELF, 0x14) == 110 && get32(SELF, 0x18) == 190);
    uc_setup(100, 200);
    g_w.word_5d2f0d = -5;
    g_w.word_5d2f0f = (int16_t)0x8000;
    m4db38a_update_cursor(SELF, &g_w, &g_host);
    CK(get32(SELF, 0x14) == 105 && get32(SELF, 0x18) == 200u + 0x8000u);
    /* |0x80000000| stays negative: no clamp (the compare is signed) */
    uc_setup(100u + 0x80000000u, 200);
    m4db38a_update_cursor(SELF, &g_w, &g_host);
    CK(get32(SELF, 0x14) == 100u + 0x80000000u && get32(SELF, 0x94) == 0x80000000u);
    /* the default block (0x583204 - 2 > 3 unsigned): 0x4d57e8 != 0 -> 0x4db780 only */
    uc_setup(104, 195);
    g_w.value_583204 = 0;
    script(0x4d57e8, 1);
    m4db38a_update_cursor(SELF, &g_w, &g_host);
    CK(L.n == 7);
    CKC(4, 0x4d57e8, 0x570450, 2, (uintptr_t)(SELF + 0x34), 0x583186);
    CKC0(5, 0x4db780, SELFP);
    CKC(6, 0x4dae88, 0x5830a6, 2, 104, 195);
    /* ... 0x4d5834 != 0 -> 0x4db817 */
    uc_setup(104, 195);
    g_w.value_583204 = 6;
    script(0x4d5834, 1);
    m4db38a_update_cursor(SELF, &g_w, &g_host);
    CK(L.n == 8);
    CKC(5, 0x4d5834, 0x570450, 2, (uintptr_t)(SELF + 0x34), 0x583186);
    CKC0(6, 0x4db817, SELFP);
    /* ... both zero, 0x4d5316 = 7: the record copy, the four differences, 0x4d56e2, the flag */
    uc_setup(104, 195);
    g_w.value_583204 = 1;
    g_w.value_583186 = 50;
    g_w.value_58318a = 60;
    script(0x4d5316, 7);
    m4db38a_update_cursor(SELF, &g_w, &g_host);
    CK(g_w.value_5d16cd == 1 && g_w.value_5d1683 == 1);
    CK(get32(SELF, 0x24) == 100 && get32(SELF, 0x28) == 200 && get32(SELF, 0x2c) == 300 && get32(SELF, 0x30) == 400);
    CK(get32(SELF, 0x54) == 100 && get32(SELF, 0x58) == 200 && get32(SELF, 0x5c) == 300 && get32(SELF, 0x60) == 400);
    CK(get32(SELF, 0x44) == 100 - 50 && get32(SELF, 0x4c) == 300 - 50 && get32(SELF, 0x48) == 200 - 60 && get32(SELF, 0x50) == 400 - 60);
    CKC(7, 0x4d56e2, 0x570450, 3, (uintptr_t)(SELF + 0x44), (uintptr_t)(SELF + 0x54), 7);
    CK(L.n == 9);
    /* ... r == 0 with the debug word (a WORD test: 0x100 is on): the report and 0x44a2b7 */
    uc_setup(104, 195);
    g_w.value_583204 = 0xffffffffu;
    g_w.value_583186 = 11; g_w.value_58318a = 12; g_w.value_58318e = 13; g_w.value_583192 = 14;
    g_w.word_63a4cd = 0x100;
    m4db38a_update_cursor(SELF, &g_w, &g_host);
    CK(L.n == 10 && g_w.value_5d1683 == 1 && g_w.value_5d16cd == 0);
    CKC(7, 0x50ca3e, 0, 10, 0x63888b, 0x55af64, 100, 200, 300, 400, 11, 12, 13, 14);
    CKC(8, 0x44a2b7, 0, 1, 0x63888b);
    /* ... r == 0, debug word zero: nothing more */
    uc_setup(104, 195);
    g_w.value_583204 = 0xffffffffu;
    m4db38a_update_cursor(SELF, &g_w, &g_host);
    CK(L.n == 8 && g_w.value_5d1683 == 1);
    /* 0x4daeb5 returns an original address (not the local): the pair is read there */
    uc_setup(0, 0);
    g_retarg_callee = 0;
    set32(g_r[2], 0x11, 104);
    set32(g_r[2], 0x15, 195);
    script(0x4daeb5, RVA(2) + 0x11);
    m4db38a_update_cursor(SELF, &g_w, &g_host);
    CK(get32(SELF, 0x14) == 104 && get32(SELF, 0x18) == 195);
}

/* ---- 0x4d2c20 ------------------------------------------------------------------------------------------------------------------ */
/* layout: the string at RVA(1)+1, the font at RVA(2)+0x700, the metrics at RVA(3)+0x200. Font words: +0x4f advance 7, +0x51 gap 2, +0x53 5, +0x55 2, +0x57 1; glyph i: dwords at font + i*16 + 0xc3 / 0xc7 / 0xcb / 0xcf
 * = 0x1000 / 0x2000 / 0x3000 / 0x4000 + i; selector 1: dwords at font + 8 + 0x3f = 0x10, + 8 + 0x43 = 0x20 (selector -2: 0x50 and 0x60); metrics: word [M + i*4] = 9 + i, word [M + i*4 + 2] = 11 + i. */
#define LT_TEXT (RVA(1) + 1)
#define LT_FONT (RVA(2) + 0x700)
#define LT_M (RVA(3) + 0x200)
static void lt_setup(const char *text)
{
    int i;
    setup();
    memset(g_r[1], 0, 0x100);
    memcpy(g_r[1] + 1, text, strlen(text) + 1);
    for (i = -100; i < 100; i++) {
        set32(g_r[2], (size_t)(0x700 + i * 16 + 0xc3), 0x1000u + (uint32_t)i);
        set32(g_r[2], (size_t)(0x700 + i * 16 + 0xc7), 0x2000u + (uint32_t)i);
        set32(g_r[2], (size_t)(0x700 + i * 16 + 0xcb), 0x3000u + (uint32_t)i);
        set32(g_r[2], (size_t)(0x700 + i * 16 + 0xcf), 0x4000u + (uint32_t)i);
        set16(g_r[3], (size_t)(0x200 + i * 4), (uint16_t)(9 + i));
        set16(g_r[3], (size_t)(0x200 + i * 4 + 2), (uint16_t)(11 + i));
    }
    set32(g_r[2], 0x700 + 8 + 0x3f, 0x10);
    set32(g_r[2], 0x700 + 8 + 0x43, 0x20);
    set32(g_r[2], 0x700 - 16 + 0x3f, 0x50);
    set32(g_r[2], 0x700 - 16 + 0x43, 0x60);
    /* the header words last: the glyph table with negative indexes overlaps them */
    set16(g_r[2], 0x700 + 0x4f, 7);
    set16(g_r[2], 0x700 + 0x51, 2);
    set16(g_r[2], 0x700 + 0x53, 5);
    set16(g_r[2], 0x700 + 0x55, 2);
    set16(g_r[2], 0x700 + 0x57, 1);
    g_w.value_63a8e0 = g_w.value_63a8e4 = g_w.value_63a8e8 = g_w.value_63a8ec = 0x55555555u;
}
static uint32_t lt_call(uint32_t x, uint32_t y, uint32_t a, uint32_t b, uint32_t sel)
{
    return m4d2c20_layout_text(LT_TEXT, LT_FONT, LT_M, x, y, a, b, sel, &g_w, &g_host);
}
static void test_m4d2c20_layout_text(void)
{
    (void)m4d2c20_layout_text;
    /* "A" (upper): glyph 5, selector 1; x = 100, y = 300 with garbage in the upper halves of the word arguments */
    lt_setup("A");
    script(0x50d651, 1);
    script(0x50d67f, 1);
    CK(lt_call(0xabcd0064u, 0x1234012cu, 0x1111, 0x2222, 0xfff70001u) == 0x63a8e0);
    CK(L.n == 4);
    CKC(0, 0x4d214b, 0, 3, 0x41, LT_FONT, L.c[0].a[2]);
    CKC(1, 0x50d651, 0, 1, 0x41);
    CKC(2, 0x50d67f, 0, 1, 0x41);
    CKC(3, 0x4c5d4b, 0x5cf659, 5, 0x1111, 0x2222, L.c[3].a[2], 0x63a8e0, 0x55a37c);
    CK(L.c[3].d16[0] == 0x1005 + 0x10 && L.c[3].d16[1] == 0x2005 + 0x20 && L.c[3].d16[2] == 0x3005 + 0x10 && L.c[3].d16[3] == 0x4005 + 0x20);
    CK(g_w.value_63a8ec == 300 && g_w.value_63a8e4 == 300 - 16 + 1 && g_w.value_63a8e0 == 2 + 100 + 14 && g_w.value_63a8e8 == 116 + 14 - 1);
    /* "a" (lower): 651 -> 1, 67f -> 0, 651 -> 1, 6a7 -> 1: glyph 'a' + 2 - 'a' = 2 */
    lt_setup("a");
    script(0x50d651, 1);
    script(0x50d67f, 0);
    script(0x50d6a7, 1);
    CK(lt_call(100, 300, 1, 1, 1) == 0x63a8e0 && L.n == 6);
    CKC(3, 0x50d651, 0, 1, 0x61);
    CKC(4, 0x50d6a7, 0, 1, 0x61);
    CK(L.c[5].callee == 0x4c5d4b && L.c[5].d16[0] == 0x1002 + 0x10 && g_w.value_63a8e4 == 300 - 13 + 1 && g_w.value_63a8e0 == 2 + 100 + 11);
    /* "7" (digit): 651 -> 0 twice, then 6cf -> 1: glyph '7' + 1 - '0' = 8 */
    lt_setup("7");
    script(0x50d6cf, 1);
    CK(lt_call(100, 300, 1, 1, 1) == 0x63a8e0 && L.n == 5);
    CKC(1, 0x50d651, 0, 1, 0x37);
    CKC(2, 0x50d651, 0, 1, 0x37);
    CKC(3, 0x50d6cf, 0, 1, 0x37);
    CK(L.c[4].d16[1] == 0x2008 + 0x20 && g_w.value_63a8e0 == 2 + 100 + 17);
    /* characters nothing matches advance: x += 7 each, 0x63a8e8 = x + 7 - 1 */
    lt_setup("  ");
    CK(lt_call(100, 300, 1, 1, 1) == 0x63a8e0 && L.n == 8);
    CK(g_w.value_63a8e0 == 114 && g_w.value_63a8e8 == 114 + 7 - 1 && g_w.value_63a8e4 == 0);
    /* the glyph comes from 0x4d214b (non-zero): the local word (-3, a sign-extended word), no predicate calls */
    lt_setup("Q");
    script(0x4d214b, 1);
    script_write(0x4d214b, 0, 2, 0, 2, 0xfffd);
    CK(lt_call(100, 300, 1, 1, 0xffff0001u) == 0x63a8e0 && L.n == 2);
    CKC(1, 0x4c5d4b, 0x5cf659, 5, 1, 1, L.c[1].a[2], 0x63a8e0, 0x55a37c);
    CK(L.c[1].d16[0] == 0x1000 - 3 + 0x10 && L.c[1].d16[3] == 0x4000 - 3 + 0x20 && g_w.value_63a8e4 == 300 - 8 + 1 && g_w.value_63a8e0 == 2 + 100 + 6);
    /* a negative selector word (0xfffe = -2): the dwords at font - 16 + 0x3f / 0x43 */
    lt_setup("A");
    script(0x50d651, 1);
    script(0x50d67f, 1);
    CK(lt_call(100, 300, 1, 1, 0xabcdfffeu) == 0x63a8e0 && L.n == 4);
    CK(L.c[3].d16[0] == 0x1005 + 0x50 && L.c[3].d16[1] == 0x2005 + 0x60);
    /* a char with the high bit: the predicates get the SIGN-EXTENDED byte, every zero-extended >= 0x80 test fails: advance */
    lt_setup("\xe9");
    script(0x50d651, 1);
    script(0x50d67f, 1);
    script(0x50d6a7, 1);
    script(0x50d6cf, 1);
    CK(lt_call(100, 300, 1, 1, 1) == 0x63a8e0 && L.n == 6 && g_w.value_63a8e0 == 107);
    CKC(0, 0x4d214b, 0, 3, 0xe9, LT_FONT, L.c[0].a[2]);
    CKC(1, 0x50d651, 0, 1, 0xffffffe9u);
    CKC(2, 0x50d67f, 0, 1, 0xffffffe9u);
    CKC(3, 0x50d651, 0, 1, 0xffffffe9u);
    CKC(4, 0x50d6a7, 0, 1, 0xffffffe9u);
    CKC(5, 0x50d6cf, 0, 1, 0xffffffe9u);
    /* the empty string: only the stores (words sign-extended); the debug word is a WORD test (0x100 is on) */
    lt_setup("");
    CK(lt_call(0x1234ffffu, 0x1234bcd8u, 0, 0, 0) == 0x63a8e0 && L.n == 0);
    CK(g_w.value_63a8e0 == 0xffffffffu && g_w.value_63a8ec == 0xffffbcd8u && g_w.value_63a8e4 == 0 && g_w.value_63a8e8 == 0);
    lt_setup("");
    g_w.word_63a4cd = 0x100;
    CK(lt_call(1, 2, 0, 5, 0) == 0x63a8e0 && L.n == 2);
    CKC(0, 0x52139c, 0, 3, 0x55a344, 0, 0);
    CKC0(1, 0x4c97b4, 0x5cf659);
    lt_setup("");
    g_w.word_63a4cd = 0x100;
    CK(lt_call(1, 2, 5, 0, 0) == 0x63a8e0 && L.n == 2);
    lt_setup("");
    g_w.word_63a4cd = 0x100;
    CK(lt_call(1, 2, 5, 5, 0) == 0x63a8e0 && L.n == 0);
    lt_setup("");
    CK(lt_call(1, 2, 0, 0, 0) == 0x63a8e0 && L.n == 0);
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
        /* 0x4db38a: tables inside g_r[6] / g_r[7], random positions */
        uc_setup(seed >> 3, seed >> 11);
        g_w.value_583204 = seed % 7;
        g_w.value_5b44f0 = seed % 5;
        g_w.value_5b44f4 = seed % 4;
        g_w.word_63a4cd = (int16_t)(seed & 3);
        g_w.word_5d2f0d = (int16_t)(seed >> 5);
        script(0x4d57e8, seed & 1);
        script(0x4d5834, seed >> 1 & 1);
        script(0x4d5316, seed >> 2 & 1);
        m4db38a_update_cursor(SELF, &g_w, &g_host);
        L.n = 0;
        /* 0x4d2c20: a short string with random scripted answers */
        lt_setup("Aa7 \xe9Q");
        script(0x4d214b, seed >> 4 & 1);
        script(0x50d651, seed >> 5 & 1);
        script(0x50d67f, seed >> 6 & 1);
        script(0x50d6a7, seed >> 7 & 1);
        script(0x50d6cf, seed >> 8 & 1);
        script_write(0x4d214b, 0, 2, 0, 2, seed % 20);
        g_w.word_63a4cd = (int16_t)(seed & 1);
        lt_call(seed, seed >> 3, seed >> 9 & 1, 1, seed >> 11 & 3);
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
    RUN(test_m4db38a_update_cursor);
    RUN(test_m4d2c20_layout_text);
    /* RUN-END */
    RUN(test_sweep_bounded);
    return failures;
}
