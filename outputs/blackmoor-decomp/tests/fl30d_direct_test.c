/* FL-30 (batch d) direct tests of the methods of GAME.EXE in src/original_methods_fl30d.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl30d_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl30d.h"

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
#define RSZ 0x7000
static uint8_t g_r[8][RSZ];
static uint8_t g_blk[FL30D_BLOCK_5A1E54_SIZE];
static uint8_t g_tbl[0x8d * 8];
static Fl30dWorld g_w;
static Fl18Host g_host;
#define SELF g_r[0]

static __attribute__((unused)) void set32(uint8_t *b, size_t off, uint32_t v) { memcpy(b + off, &v, 4); }
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
    memset(g_blk, 0xaa, sizeof g_blk);
    memset(&g_w, 0, sizeof g_w);
    g_w.block_5a1e54 = g_blk;
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

/* ---- 0x4e2e05 ------------------------------------------------------------------------------------------------------------------ */
#define BO(va) ((size_t)((va) - 0x5a1e54u))
static void blk_setup(int count)
{
    int i;
    setup();
    memset(SELF, 0, RSZ);
    for (i = 0; i < 0x2a * 0xec && 0x457b + i < RSZ; i++) SELF[0x457b + i] = (uint8_t)(i * 5 + 1);
    set16(SELF, 0x1471, (uint16_t)count);
    SELF[0x139d] = 'P';                 /* equal to the global byte below: no copy */
    SELF[0x13e3] = 'Q';
    g_w.byte_63a9e4 = 'P';
    g_w.byte_63a9e8 = 'Q';
}
static void test_m4e2e05_copy_state(void)
{
    int i;
    uint8_t before[FL30D_BLOCK_5A1E54_SIZE];
    blk_setup(2);
    CK(m4e2e05_copy_state(SELF, &g_w, &g_host) == 0);
    CK(L.n == 1);
    CKC0(0, 0x4e3ade, SELFP);
    CK(get32(g_blk, BO(0x5a1e54)) == 0 && get32(g_blk, BO(0x5a1e58)) == 0);
    for (i = 0; i < 2 * 0x29; i++) CK(g_blk[BO(0x5a1e62) + i] == (uint8_t)(i * 5 + 1));
    CK(g_blk[BO(0x5a1e62) + 2 * 0x29] == 0xaa);                       /* nothing past the n bytes */
    CK(get16(g_blk, BO(0x5a1e5c)) == 2);
    CK(get16(g_blk, BO(0x5a1e5e)) == 0 && get16(g_blk, BO(0x5a1e60)) == 0);   /* both first bytes equal */
    CK(g_blk[BO(0x5a2664)] == 0xaa && g_blk[BO(0x5a434c)] == 0xaa);
    /* both strings differ: z1 is "AB", z2 is "CDE", z3 is "FGHIJ" (5 chars: dword + byte copy); the words and the sign extended dword */
    blk_setup(3);
    memcpy(SELF + 0x139d, "AB\0", 4);
    memcpy(SELF + 0x13be, "CDE\0", 5);
    memcpy(SELF + 0x13e3, "FGHIJ\0", 7);
    set16(SELF, 0x13df, 0x1111); set16(SELF, 0x13e1, 0x2222);
    set16(SELF, 0x1404, 0x8000); set16(SELF, 0x1406, 0x3333); set16(SELF, 0x1408, 0x4444);
    L.n = 0;
    CK(m4e2e05_copy_state(SELF, &g_w, &g_host) == 0);
    CK(get16(g_blk, BO(0x5a1e5e)) == 1 && get16(g_blk, BO(0x5a1e60)) == 1);
    CK(memcmp(g_blk + BO(0x5a2664), "AB\0", 3) == 0 && memcmp(g_blk + BO(0x5a2685), "CDE\0", 4) == 0);
    CK(get16(g_blk, BO(0x5a26a6)) == 0x1111 && get16(g_blk, BO(0x5a26a8)) == 0x2222 && get32(g_blk, BO(0x5a26aa)) == 0);
    CK(memcmp(g_blk + BO(0x5a434c), "FGHIJ\0", 6) == 0);
    CK(get32(g_blk, BO(0x5a4371)) == 0xffff8000u && get16(g_blk, BO(0x5a436d)) == 0x3333 && get16(g_blk, BO(0x5a436f)) == 0x4444);
    /* a first string of 0x24 characters: its tail 0x21..0x24 is overwritten by the second string (copied after it) */
    blk_setup(0);
    for (i = 0; i < 0x24; i++) SELF[0x139d + i] = (uint8_t)('a' + (i % 20));
    SELF[0x139d + 0x24] = 0;
    memcpy(SELF + 0x13be, "xy\0", 3);
    SELF[0x139d] = 'a' ^ 1;
    g_w.byte_63a9e4 = 'a';
    CK(m4e2e05_copy_state(SELF, &g_w, &g_host) == 0);
    CK(g_blk[BO(0x5a2664)] == ('a' ^ 1) && g_blk[BO(0x5a2664) + 0x20] == (uint8_t)('a' + (0x20 % 20)));
    CK(g_blk[BO(0x5a2685)] == 'x' && g_blk[BO(0x5a2686)] == 'y' && g_blk[BO(0x5a2687)] == 0);     /* the second string, NUL included, over the first string's tail */
    CK(g_blk[BO(0x5a2685) + 3] == (uint8_t)('a' + ((0x21 + 3) % 20)) || g_blk[BO(0x5a2685) + 3] == 0xaa);
    /* native rejection: a negative count and a count whose bytes do not fit the mirror leave everything unchanged and call nothing */
    blk_setup(232);                      /* the largest count that fits: 232 * 0x29 = 0x2528 <= 0x2532 */
    CK(m4e2e05_copy_state(SELF, &g_w, &g_host) == 0);
    CK(g_blk[BO(0x5a1e62) + 232 * 0x29 - 1] == (uint8_t)((232 * 0x29 - 1) * 5 + 1));
    for (i = 0; i < 4; i++) {
        blk_setup(i == 0 ? -1 : i == 1 ? -0x8000 : i == 2 ? 233 : 0xec);
        memcpy(before, g_blk, sizeof before);
        L.n = 0;
        CK(m4e2e05_copy_state(SELF, &g_w, &g_host) == 1);
        CK(L.n == 0 && memcmp(before, g_blk, sizeof before) == 0);
    }
}

/* ---- 0x4c2a8d ------------------------------------------------------------------------------------------------------------------ */
static void test_m4c2a8d_make_record(void)
{
    uint8_t *rec = g_r[1], *name = g_r[3];
    int i;
    uint32_t r;
    setup();
    memset(rec, 0x77, 0x100);
    memset(name, 'x', 0x80);
    name[0x30] = 0;                                     /* a 0x30 character name */
    g_w.word_639895 = 3;
    g_w.word_639893 = 0xbeef;
    script(0x51dc43, 2, RVA(1), RVA(2), 0, 0);
    r = m4c2a8d_make_record(SELF, 0xabcd0005u, 0x12340004u, 0xdeadbeefu, RVA(3), &g_w, &g_host);
    CK(r == RVA(1));
    CK(L.n == 2);
    CKC(0, 0x51dc43, 0, 1, 0x59);
    CKC(1, 0x51dc43, 0, 1, 5 * 3 * 4);                  /* size = w * bpp * h from the low words */
    CK(get32(rec, 0) == RVA(2));
    CK(name[0x18] == 0 && name[0x17] == 'x');           /* a name of 0x19 or more characters is cut at 0x18 in the caller's buffer */
    for (i = 0; i < 0x18; i++) CK(rec[8 + i] == 'x');
    CK(rec[8 + 0x18] == 0);                             /* the NUL of the cut string */
    CK(get32(rec, 4) == 0xdeadbeefu && get16(rec, 0x21) == 0x59 && get32(rec, 0x23) == 60 && get32(rec, 0x27) == 60 + 0x59);
    CK(get16(rec, 0x2b) == 5 && get16(rec, 0x2d) == 4 && get16(rec, 0x2f) == 15 && get16(rec, 0x31) == 4 && get16(rec, 0x33) == 0xbeef);
    CK(get32(rec, 0x35) == 0 && get32(rec, 0x39) == 0 && get32(rec, 0x3d) == 4 && get32(rec, 0x41) == 3 && get32(rec, 0x55) == 0);
    for (i = 0; i < 16; i++) CK(rec[0x45 + i] == 0);
    CK(rec[0x59] == 0x77 && rec[0x2a] == 0 && rec[0x58] == 0);   /* the 0x59 bytes are cleared first, nothing past them is written */
    /* negative dimensions: the products are 32-bit signed; w = -2, h = -3, bpp = 2 gives size 12, the dword at +0x3d is -3 */
    setup();
    memset(rec, 0x77, 0x100);
    memcpy(name, "ab\0", 3);
    g_w.word_639895 = 2;
    script(0x51dc43, 2, RVA(1), RVA(2), 0, 0);
    r = m4c2a8d_make_record(SELF, 0xfffe, 0xfffd, 1, RVA(3), &g_w, &g_host);
    CK(r == RVA(1) && get32(rec, 0x23) == 12 && get32(rec, 0x3d) == 0xfffffffdu && get32(rec, 0x41) == 0xfffffffcu && get16(rec, 0x2f) == 0xfffc);
    CK(rec[8] == 'a' && rec[9] == 'b' && rec[10] == 0 && name[2] == 0);
    CKC(1, 0x51dc43, 0, 1, 12);
    /* a name of exactly 0x18 characters is copied as it is (no cut) */
    setup();
    memset(name, 'y', 0x30);
    name[0x18] = 0;
    memset(rec, 0x77, 0x100);
    script(0x51dc43, 2, RVA(1), RVA(2), 0, 0);
    m4c2a8d_make_record(SELF, 1, 1, 0, RVA(3), &g_w, &g_host);
    CK(rec[8 + 0x17] == 'y' && rec[8 + 0x18] == 0 && name[0x17] == 'y');
    /* first allocation fails: the report and 0 */
    setup();
    script(0x51dc43, 1, 0, 0, 0, 0);
    CK(m4c2a8d_make_record(SELF, 1, 1, 0, RVA(3), &g_w, &g_host) == 0);
    CK(L.n == 3);
    CKC(1, 0x42639d, 0x583979, 2, 0x553dbc, RVA(3));
    CKC0(2, 0x4c97b4, SELFP);
    /* second allocation fails: another report, [rec] = 0, 0 and no further effect */
    setup();
    memset(rec, 0x77, 0x100);
    script(0x51dc43, 2, RVA(1), 0, 0, 0);
    CK(m4c2a8d_make_record(SELF, 1, 1, 0, RVA(3), &g_w, &g_host) == 0);
    CK(L.n == 4);
    CKC(2, 0x42639d, 0x583979, 2, 0x553e14, RVA(3));
    CKC0(3, 0x4c97b4, SELFP);
    CK(get32(rec, 0) == 0 && rec[0x58] == 0 && get32(rec, 0x59) == 0x77777777u);
}

/* ---- 0x48d3cb ------------------------------------------------------------------------------------------------------------------ */
static void ent_setup(int index)
{
    int i;
    setup();
    memset(g_r[1], 0, RSZ);
    memset(SELF, 0, 0x100);
    g_tbl[0] = 0;                                        /* g_tbl: records of stride 0x8d, record 0 at g_tbl + 3 * 0x8d */
    for (i = 0; i < 8; i++) set32(g_tbl, (size_t)i * 0x8d, 0);
    set32(g_tbl, (size_t)(3 + index) * 0x8d, RVA(1));
    g_w.table_5bb5e5 = g_tbl + 3 * 0x8d;
    set16(SELF, 0x1e, (uint16_t)index);
    g_w.dword_5d0377 = 0x11223344u;
    g_w.dword_5b44f0 = 0x77;
    g_w.dword_5b44f4 = 0x78;
}
static void box(uint8_t *p, int k, int a, int b, int c, int d, int bounds_at, int ba, int bb, int bc, int bd)
{
    set32(p, (size_t)(0x207 + 16 * k), (uint32_t)a);       /* e(0x207), e(0x20f), e(0x203), e(0x20b) */
    set32(p, (size_t)(0x20f + 16 * k), (uint32_t)b);
    set32(p, (size_t)(0x203 + 16 * k), (uint32_t)c);
    set32(p, (size_t)(0x20b + 16 * k), (uint32_t)d);
    set32(p, (size_t)bounds_at, (uint32_t)ba);               /* >= , <= , >= , <= bounds at +0, +8, -4, +4 relative to bounds_at */
    set32(p, (size_t)bounds_at + 8, (uint32_t)bb);
    set32(p, (size_t)bounds_at - 4, (uint32_t)bc);
    set32(p, (size_t)bounds_at + 4, (uint32_t)bd);
}
static void test_m48d3cb_select_entry(void)
{
    uint8_t *p = g_r[1];
    ent_setup(2);
    m48d3cb_select_entry(SELF, 0x2766, 5, &g_w, &g_host);               /* the fixed selection */
    CK(g_w.dword_5b44f0 == 9 && g_w.dword_5b44f4 == 1 && g_w.dword_5d162d == 0x11223344u);
    CK(g_w.dword_5d1631 == 0x5b160cu + 9 * 32 + 16 && g_w.dword_5d1639 == 1 && g_w.dword_5c39e5 == 0x2766);
    CK(SELF[0x24] == 1 && get16(SELF, 0x27) == 0xffff);
    ent_setup(0);
    m48d3cb_select_entry(SELF, 0x2764, 5, &g_w, &g_host);               /* any other selection */
    CK(get16(SELF, 0x27) == 0xffff && SELF[0x24] == 0 && g_w.dword_5b44f0 == 0x77 && g_w.dword_5d1639 == 0);
    ent_setup(0);
    m48d3cb_select_entry(SELF, 0xd89a, 5, &g_w, &g_host);               /* -0x2766 is not 0x2766 */
    CK(get16(SELF, 0x27) == 0xffff && g_w.dword_5d1639 == 0);
    /* sel 0x2765, k = 2: box 1 passes (equal bounds: >= and <= are inclusive, signed values) */
    ent_setup(1);
    set16(p, 0x2f3, 0x8001);
    set16(p, 0x305, 0x1234);
    box(p, 2, -5, -3, -9, -4, 0x2f9, -5, -3, -9, -4);                   /* e(0x207) >= [0x2f9], e(0x20f) <= [0x301], e(0x203) >= [0x2f5], e(0x20b) <= [0x2fd] */
    set32(p, 0x2fd, (uint32_t)-4);
    m48d3cb_select_entry(SELF, 0x12765, 0xabcd0002u, &g_w, &g_host);
    CK(g_w.dword_5b44f0 == 0xffff8001u);                                /* the signed word [p+0x2f3] */
    CK(g_w.dword_5b44f4 == 1 && g_w.dword_5d162d == 0x11223344u);
    CK(g_w.dword_5d1631 == 0x5b160cu + (0xffff8001u << 5) + 16 && g_w.dword_5d1639 == 1 && g_w.dword_5c39e5 == 0x2765);
    CK(SELF[0x24] == 1 && get16(SELF, 0x27) == 2);                      /* byte [self+0x26] is 0: word [self+0x27] = k */
    /* each test of box 1 failing in turn falls to box 2, which passes: [p+0x305]; byte [self+0x26] non-zero leaves word [self+0x27] */
    {
        int fail;
        for (fail = 0; fail < 4; fail++) {
            int e[4] = {-5, -3, -9, -4};
            ent_setup(1);
            SELF[0x26] = 7;
            set16(SELF, 0x27, 0x4321);
            set16(p, 0x2f3, 1);
            set16(p, 0x305, 0x8002);
            box(p, 1, e[0], e[1], e[2], e[3], 0x2f9, -5, -3, -9, -4);
            if (fail == 0) set32(p, 0x2f9, (uint32_t)-4);              /* e(0x207) = -5 < -4 */
            if (fail == 1) set32(p, 0x301, (uint32_t)-4);              /* e(0x20f) = -3 > -4 */
            if (fail == 2) set32(p, 0x2f5, (uint32_t)-8);              /* e(0x203) = -9 < -8 */
            if (fail == 3) set32(p, 0x2fd, (uint32_t)-5);              /* e(0x20b) = -4 > -5 */
            box(p, 1, e[0], e[1], e[2], e[3], 0x30b, -5, -3, -9, -4);
            m48d3cb_select_entry(SELF, 0x2765, 1, &g_w, &g_host);
            CK(g_w.dword_5b44f0 == 0xffff8002u);
            CK(SELF[0x24] == 1 && get16(SELF, 0x27) == 0x4321);
        }
        for (fail = 0; fail < 4; fail++) {                              /* box 2 failing in turn: [0x5b44f0] = 0 */
            int e[4] = {-5, -3, -9, -4};
            ent_setup(1);
            set16(p, 0x2f3, 1);
            set16(p, 0x305, 0x8002);
            box(p, -1, e[0], e[1], e[2], e[3], 0x2f9, 100, 100, 100, 100);       /* box 1 fails at its first test */
            box(p, -1, e[0], e[1], e[2], e[3], 0x30b, -5, -3, -9, -4);
            if (fail == 0) set32(p, 0x30b, (uint32_t)-4);
            if (fail == 1) set32(p, 0x313, (uint32_t)-4);
            if (fail == 2) set32(p, 0x307, (uint32_t)-8);
            if (fail == 3) set32(p, 0x30f, (uint32_t)-5);
            set32(p, 0x2f9, (uint32_t)0x7fffffff);
            m48d3cb_select_entry(SELF, 0x2765, 0xffff, &g_w, &g_host);       /* k = -1 */
            CK(g_w.dword_5b44f0 == 0);
            CK(g_w.dword_5d1631 == 0x5b160cu + 16 && get16(SELF, 0x27) == 0xffff);
        }
    }
}

/* ---- 0x4f684a ------------------------------------------------------------------------------------------------------------------ */
#define VTE 0x7e000900u
static void pe_setup(uint32_t a0_scale_base)
{
    setup();
    memset(g_r[1], 0, RSZ);
    memset(g_r[2], 0, 0x40);
    memset(g_r[3], 0, 0x100);
    memset(SELF, 0x55, 0x400);
    set32(SELF, 0x3ce, RVA(1) + a0_scale_base);
    set32(g_r[1], a0_scale_base + 0x28f, RVA(2));        /* q = region 1 + a0_scale_base: the object */
    set32(g_r[2], 0, RVA(3));                            /* its vtable */
    set32(g_r[3], 0x3c, VTE);                            /* entry +0x3c */
    script(0x4f709c, 1, 1, 0, 0, 0);
    script(VTE, 1, 0, 0, 0, 0);
}
static void test_m4f684a_prepare_entry(void)
{
    uint8_t *q = g_r[1];
    uint32_t r;
    /* a0 = 2: q = [self+0x3ce] + 2 * 0x5bb; the clamp: positive -> 0, -1 -> -1, -2857 -> -2857, -2858 -> -2857, very negative -> -2857 */
    pe_setup(0);
    set32(SELF, 0x3ce, RVA(1));
    set32(q, 2 * 0x5bb + 0x28f, RVA(2));
    set32(q, 2 * 0x5bb + 0x13c, 0x7fffffff);
    set32(q, 2 * 0x5bb + 0x140, (uint32_t)-2858);
    r = m4f684a_prepare_entry(SELF, 2, &g_w, &g_host);
    CK(r == 1);
    CK(get32(q, 2 * 0x5bb + 0x13c) == 0 && get32(q, 2 * 0x5bb + 0x140) == (uint32_t)-2857);
    CK(get32(SELF, 0x3c2) == 0x3e8 && get32(SELF, 0x3ca) == 0 && get32(SELF, 0x3be) == 0x55555555u);   /* success touches only these */
    CK(L.n == 2);
    CKC0(0, 0x4f709c, SELFP);
    CKC(1, VTE, RVA(2), 2, RVA(2), (uint32_t)0);                            /* ecx = obj, args (obj, [q+0x13c]) */
    pe_setup(0);
    set32(SELF, 0x3ce, RVA(1));
    set32(q, 2 * 0x5bb + 0x28f, RVA(2));
    set32(q, 2 * 0x5bb + 0x13c, (uint32_t)-2857);
    set32(q, 2 * 0x5bb + 0x140, 0x80000000u);
    L.n = 0;
    CK(m4f684a_prepare_entry(SELF, 2, &g_w, &g_host) == 1);
    CK(get32(q, 2 * 0x5bb + 0x13c) == (uint32_t)-2857 && get32(q, 2 * 0x5bb + 0x140) == (uint32_t)-2857);   /* -2857 is above the constant: kept; INT_MIN: the constant */
    CKC(1, VTE, RVA(2), 2, RVA(2), (uint32_t)-2857);
    pe_setup(0);
    set32(SELF, 0x3ce, RVA(1));
    set32(q, 2 * 0x5bb + 0x28f, RVA(2));
    set32(q, 2 * 0x5bb + 0x13c, (uint32_t)-1);
    set32(q, 2 * 0x5bb + 0x140, (uint32_t)-3000);
    L.n = 0;
    CK(m4f684a_prepare_entry(SELF, 2, &g_w, &g_host) == 1);
    CK(get32(q, 2 * 0x5bb + 0x13c) == (uint32_t)-1 && get32(q, 2 * 0x5bb + 0x140) == (uint32_t)-2857);
    /* the debug flag: a non-zero signed word traces after a successful call */
    pe_setup(0);
    set32(SELF, 0x3ce, RVA(1) - 0x5bb);
    set32(q, 0x28f, RVA(2));
    g_w.word_63a4cd = (int16_t)0x8000;
    L.n = 0;
    CK(m4f684a_prepare_entry(SELF, 1, &g_w, &g_host) == 1);                 /* q = [self+0x3ce] + 0x5bb = region 1 */
    CK(L.n == 4);
    CKC(2, 0x50ca3e, 0, 5, 0x63888b, 0x55e8fc, 0, 1, RVA(1) + 4);
    CKC(3, 0x44a2b7, 0, 1, 0x63888b);
    /* the callee reports a failure: hr is kept at [self+0x3ca], 0x408 and 0 are stored and the result is 0 (no trace) */
    pe_setup(0);
    set32(SELF, 0x3ce, RVA(1));
    g_nscript = 0;
    script(0x4f709c, 1, 5, 0, 0, 0);
    script(VTE, 1, 0x10000, 0, 0, 0);
    g_w.word_63a4cd = 1;
    L.n = 0;
    CK(m4f684a_prepare_entry(SELF, 0, &g_w, &g_host) == 0);
    CK(get32(SELF, 0x3ca) == 0x10000 && get32(SELF, 0x3c2) == 0x408 && get32(SELF, 0x3be) == 0 && L.n == 2);
    /* 0x4f709c returns 0: 0x3ea, and no vtable call */
    pe_setup(0);
    g_nscript = 0;
    script(0x4f709c, 1, 0, 0, 0, 0);
    L.n = 0;
    CK(m4f684a_prepare_entry(SELF, 0, &g_w, &g_host) == 0);
    CK(get32(SELF, 0x3c2) == 0x3ea && get32(SELF, 0x3be) == 0 && get32(SELF, 0x3ca) == 0 && L.n == 1);
    /* no object at [q+0x28f]: 0x3ef */
    pe_setup(0);
    set32(SELF, 0x3ce, RVA(1));
    set32(q, 0x28f, 0);
    set32(q, 0x13c, 5);
    L.n = 0;
    CK(m4f684a_prepare_entry(SELF, 0, &g_w, &g_host) == 0);
    CK(get32(SELF, 0x3c2) == 0x3ef && get32(SELF, 0x3be) == 0 && L.n == 1 && get32(q, 0x13c) == 5);
}

/*TESTS*/

/* ---- bounded sweep ------------------------------------------------------------------------------------------------------------- */
static void test_sweep_bounded(void)
{
    unsigned seed = 4242;
    int n, i;
    for (n = 0; n < 300 && !g_failed; n++) {
        setup();
        for (i = 0; i < RSZ; i++) {
            seed = seed * 1103515245u + 12345u;
            SELF[i] = (uint8_t)(seed >> 16);
        }
        set16(SELF, 0x1471, (uint16_t)((seed >> 3) % 0x40));       /* inside the mirror: a bounded sweep */
        SELF[0x139d + 0x20] = 0;                                   /* the strings end inside their fields */
        SELF[0x13be + 0x20] = 0;
        SELF[0x13e3 + 0x20] = 0;
        g_w.byte_63a9e4 = (uint8_t)seed;
        g_w.byte_63a9e8 = (uint8_t)(seed >> 8);
        m4e2e05_copy_state(SELF, &g_w, &g_host);
        L.n = 0;
        g_nscript = 0;
        script(0x51dc43, 2, RVA(1), RVA(2), 0, 0);
        g_w.word_639895 = (int16_t)(1 + seed % 3);
        m4c2a8d_make_record(SELF, (seed >> 2) % 9, (seed >> 6) % 9, seed, RVA(3), &g_w, &g_host);
        L.n = 0;
        memset(g_tbl, 0, sizeof g_tbl);
        set32(g_tbl, 3 * 0x8d, RVA(1));
        g_w.table_5bb5e5 = g_tbl + 3 * 0x8d;
        set16(SELF, 0x1e, 0);
        set32(g_r[1], 0x2f9, seed);
        m48d3cb_select_entry(SELF, 0x2765 + (seed & 1), (seed >> 4) % 8, &g_w, &g_host);
        L.n = 0;
        pe_setup(0);
        set32(SELF, 0x3ce, RVA(1));
        set32(g_r[1], 0x28f, RVA(2));
        set32(g_r[1], 0x13c, seed);
        set32(g_r[1], 0x140, seed >> 3);
        g_w.word_63a4cd = (int16_t)(seed >> 5);
        m4f684a_prepare_entry(SELF, 0, &g_w, &g_host);
        L.n = 0;
        g_nscript = 0;
        /*SWEEPBODY*/
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
    RUN(test_m4e2e05_copy_state);
    RUN(test_m48d3cb_select_entry);
    RUN(test_m4f684a_prepare_entry);
    RUN(test_m4c2a8d_make_record);
    /*RUNS*/
    RUN(test_sweep_bounded);
    return failures;
}
