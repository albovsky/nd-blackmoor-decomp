/* FL-39 (batch f) direct tests of the 26 GAME.EXE functions in src/original_methods_fl39f.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl39f_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl39f.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define UNUSED_FN __attribute__((unused))

static int g_failed;
static char g_msg[256];
#define CK(cond)                                                               \
    do {                                                                       \
        if (!(cond) && !g_failed) {                                            \
            g_failed = 1;                                                      \
            snprintf(g_msg, sizeof g_msg, "line %d: %.200s", __LINE__, #cond); \
        }                                                                      \
    } while (0)

#define SELF_SIZE 0x400
static uint8_t g_self[SELF_SIZE];
#define SELF g_self
static Fl18Host g_host;
static Fl39fWorld g_w;

UNUSED_FN static void put32(uint8_t *p, size_t off, uint32_t v)
{
    p[off] = (uint8_t)v;
    p[off + 1] = (uint8_t)(v >> 8);
    p[off + 2] = (uint8_t)(v >> 16);
    p[off + 3] = (uint8_t)(v >> 24);
}

UNUSED_FN static void put16(uint8_t *p, size_t off, uint16_t v)
{
    p[off] = (uint8_t)v;
    p[off + 1] = (uint8_t)(v >> 8);
}

UNUSED_FN static uint32_t get32(const uint8_t *p, size_t off)
{
    return (uint32_t)p[off] | (uint32_t)p[off + 1] << 8 | (uint32_t)p[off + 2] << 16 | (uint32_t)p[off + 3] << 24;
}

#define MAXCALL 16
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[8];
        uint32_t first_dword;   /* the dword at [this] at the call (host pointers only) */
    } c[MAXCALL];
} L;
static uint32_t g_ret;           /* the answer of every callee without an entry in g_ans */
#define MAXANS 8
static struct {
    int n;
    uint32_t callee[MAXANS], value[MAXANS];
} g_ans;                         /* per-callee answers: the callee, and the value it returns (every call) */

/* regions of fake original memory behind addresses: {address, host pointer, length} */
static struct {
    int n;
    struct {
        uint32_t va;
        uint8_t *p;
        uint32_t len;
    } r[8];
} g_reg;

UNUSED_FN static void answer(uint32_t callee, uint32_t value)
{
    g_ans.callee[g_ans.n] = callee;
    g_ans.value[g_ans.n++] = value;
}

UNUSED_FN static void region_add(uint32_t va, uint8_t *p, uint32_t len)
{
    g_reg.r[g_reg.n].va = va;
    g_reg.r[g_reg.n].p = p;
    g_reg.r[g_reg.n++].len = len;
}

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int k, i = L.n;
    (void)ctx;
    if (L.n < MAXCALL) {
        L.c[i].callee = callee;
        L.c[i].this_ptr = this_ptr;
        L.c[i].nargs = nargs;
        for (k = 0; k < nargs && k < 8; k++) L.c[i].a[k] = args[k];
        L.c[i].first_dword = this_ptr > 0xffffffffu ? get32((const uint8_t *)this_ptr, 0) : 0;
    }
    L.n++;
    for (k = 0; k < g_ans.n; k++)
        if (g_ans.callee[k] == callee) return g_ans.value[k];
    return g_ret;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    int k;
    (void)ctx;
    for (k = 0; k < g_reg.n; k++)
        if (a >= g_reg.r[k].va && a < g_reg.r[k].va + g_reg.r[k].len) return g_reg.r[k].p + (a - g_reg.r[k].va);
    return NULL;
}

static void setup(void)
{
    size_t i;
    for (i = 0; i < SELF_SIZE; i++) g_self[i] = (uint8_t)(i * 7 + 3);
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    L.n = 0;
    g_ret = 0;
    g_ans.n = 0;
    g_reg.n = 0;
}

static const uint32_t RETS[] UNUSED_FN = {0, 0x80000000u, 0xcafef00du, 0xffffffffu};
#define NRETS (sizeof RETS / sizeof RETS[0])

typedef void (*AdvSlotFn)(uint8_t *, const Fl39fWorld *, const Fl18Host *);
static uint8_t g_ttbl[0x8d * 5];
/* thiscall: d = the descriptor whose address is the dword at table[sl * stride] (sl = signed word [self+sl_off]); m = the signed word [d+md]. The signed word cursor [self+cu] becomes (cu + 1) % m
 * (the sign of the dividend: idiv); then for i = 1 while i < m and the dword [self + cu*4 + ar] (cu sign-extended) is not zero the cursor advances the same way. m is never 0 here (the original faults). */
static void check_advslot(AdvSlotFn fn, size_t sl_off, size_t stride, size_t md, size_t cu, size_t ar)
{
    static const int16_t ms[] = {1, 2, 3, 4, 5, -3, 4, 4, 3, 5};
    static const int16_t cus[] = {0, 0, 1, 2, -1, -3, 5, -4, 3, -2};
    size_t sneed = ar + 20, i, e;
    for (i = 0; i < 10 && !g_failed; i++) {
        uint8_t *s = (uint8_t *)malloc(sneed), *want = (uint8_t *)malloc(sneed), *d = (uint8_t *)malloc(md + 2), *dd = (uint8_t *)malloc(md + 2);
        const int32_t idx = (int32_t)(i % 4) - 1, m = ms[i];
        CK(s != NULL && want != NULL && d != NULL && dd != NULL);
        if (s == NULL || want == NULL || d == NULL || dd == NULL) return;
        for (e = 0; e < 3; e++) {                                      /* the slots at [self+ar+4*j]: all non-zero / all zero / zero at j = 1 and j = -1 */
            uint8_t ttbl0[sizeof g_ttbl];
            size_t k;
            int32_t c2, step;
            int j;
            setup();
            memset(&g_w, 0, sizeof g_w);
            memset(g_ttbl, 0x55, sizeof g_ttbl);
            g_w.table_5bb5e5 = g_ttbl + 0x8d;
            for (k = 0; k < sneed; k++) s[k] = (uint8_t)(k * 5 + 1 + i);
            for (k = 0; k < md + 2; k++) d[k] = (uint8_t)(k * 3 + 9);
            put32(g_ttbl, 0x8d + (size_t)(ptrdiff_t)idx * stride, 0x20005000u);
            memcpy(ttbl0, g_ttbl, sizeof ttbl0);
            put16(d, md, (uint16_t)m);
            put16(s, sl_off, (uint16_t)idx);
            put16(s, cu, (uint16_t)cus[i]);
            for (j = -4; j <= 4; j++) put32(s, (size_t)((ptrdiff_t)ar + 4 * j), e == 1 || (e == 2 && (j == 1 || j == -1)) ? 0u : 0x80000001u + (uint32_t)(j + 4));
            region_add(0x20005000u, d, (uint32_t)(md + 2));
            memcpy(want, s, sneed);
            memcpy(dd, d, md + 2);
            c2 = ((int32_t)cus[i] + 1) % m;
            put16(want, cu, (uint16_t)c2);
            for (step = 1; step < m; step++) {
                if (get32(s, (size_t)((ptrdiff_t)ar + 4 * c2)) == 0) break;
                c2 = (c2 + 1) % m;
                put16(want, cu, (uint16_t)c2);
            }
            fn(s, &g_w, &g_host);
            CK(memcmp(s, want, sneed) == 0);
            CK(memcmp(d, dd, md + 2) == 0);
            CK(memcmp(g_ttbl, ttbl0, sizeof g_ttbl) == 0);
            CK(L.n == 0);
        }
        free(s);
        free(want);
        free(d);
        free(dd);
    }
}

typedef void (*ClearBlockFn)(uint8_t *, const Fl18Host *);
/* thiscall: when the dword [self+p] (an address of the original) is non-zero: n = dword [self+n_off] bytes behind that address are zeroed (rep stosd n/4, rep stosb n&3) and byte [self+flag] = 0;
 * otherwise nothing. Exactly sized heap blocks: the object, and the block behind the address. */
static void check_clearblk(ClearBlockFn fn, size_t p, size_t n_off, size_t flag)
{
    static const uint32_t ns[] = {0, 1, 2, 3, 4, 5, 7, 8, 9, 0x10, 0x13, 0x41};
    size_t need = (p > n_off ? p : n_off) + 4, i, k;
    if (flag + 1 > need) need = flag + 1;
    for (i = 0; i < 2 * 12 && !g_failed; i++) {
        const uint32_t n = ns[i % 12];
        const int armed = i < 12;
        uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need), *blk = (uint8_t *)malloc(n ? n : 1), *wblk = (uint8_t *)malloc(n ? n : 1);
        CK(s != NULL && want != NULL && blk != NULL && wblk != NULL);
        if (s == NULL || want == NULL || blk == NULL || wblk == NULL) return;
        setup();
        for (k = 0; k < need; k++) s[k] = (uint8_t)(k * 5 + 1);
        for (k = 0; k < (n ? n : 1); k++) blk[k] = (uint8_t)(k * 7 + 0x11);
        put32(s, p, armed ? 0x20004000u : 0);
        put32(s, n_off, n);
        s[flag] = 0x77;
        region_add(0x20004000u, blk, n ? n : 1);
        memcpy(want, s, need);
        memcpy(wblk, blk, n ? n : 1);
        if (armed) {
            memset(wblk, 0, n);
            want[flag] = 0;
        }
        fn(s, &g_host);
        CK(memcmp(s, want, need) == 0);
        CK(memcmp(blk, wblk, n ? n : 1) == 0);
        CK(L.n == 0);
        free(s);
        free(want);
        free(blk);
        free(wblk);
    }
}

typedef void (*CheckObjFn)(const uint8_t *, const Fl39fWorld *, const Fl18Host *);
/* thiscall: the dword [self+p] is the address of a record. With dword [self+g] != 0 the nine bytes at [record+o] are compared with the world bytes k1, otherwise with k2 (repe cmpsb). When they differ:
 * r = c1(this ob1, the signed word [record+w] as a dword) (thiscall, one argument); gate set: c2(this ob2, the word [record+w]) when r == 0; gate clear: c3(this ob2, the word [record+w]) when r != 0.
 * Exactly sized heap blocks. */
static void check_checkobj(CheckObjFn fn, size_t g, size_t p, size_t o, size_t w, uint32_t c1, uint32_t c2, uint32_t c3, uint32_t ob1, uint32_t ob2)
{
    static const uint8_t K1[9] = {0x11, 0x80, 0xff, 0x01, 0x7f, 0x42, 0xa5, 0x01, 0xfe};
    static const uint8_t K2[9] = {0x21, 0x70, 0x0f, 0x02, 0x6f, 0x32, 0xb5, 0x03, 0xee};
    static const uint16_t words[] = {0, 1, 0xffff, 0x8000, 0x7fff, 0x1234};
    size_t need = g + 4 > p + 4 ? g + 4 : p + 4, rneed = (o + 9 > w + 2 ? o + 9 : w + 2), gate, m, r, wi, j;
    uint8_t *s = (uint8_t *)malloc(need), *rec = (uint8_t *)malloc(rneed), *cs = (uint8_t *)malloc(need), *cr = (uint8_t *)malloc(rneed);
    CK(s != NULL && rec != NULL && cs != NULL && cr != NULL);
    if (s == NULL || rec == NULL || cs == NULL || cr == NULL) return;
    for (gate = 0; gate < 2 && !g_failed; gate++)
        for (m = 0; m < 4 && !g_failed; m++)      /* equal, first difference at 4, 0 and 8 */
            for (r = 0; r < 2 && !g_failed; r++)
                for (wi = 0; wi < 6 && !g_failed; wi += 2) {
                    const uint8_t *k = gate ? K1 : K2;
                    size_t pos = m == 0 ? 9 : (m == 1 ? 4 : (m == 2 ? 0 : 8));
                    setup();
                    memset(&g_w, 0, sizeof g_w);
                    g_w.bytes_54f888 = K1;
                    g_w.bytes_54f894 = K2;
                    memset(s, 0x33, need);
                    memset(rec, 0x6c, rneed);
                    memcpy(rec + o, k, 9);
                    if (pos < 9) {
                        rec[o + pos] = (uint8_t)(k[pos] + 1);
                        for (j = pos + 1; j < 9; j++) rec[o + j] = (uint8_t)~k[j];
                    }
                    put16(rec, w, words[wi + (r ? 1 : 0)]);
                    put32(s, g, gate ? 0x10000u : 0);
                    put32(s, p, 0x20001000u);
                    region_add(0x20001000u, rec, (uint32_t)rneed);
                    memcpy(cs, s, need);
                    memcpy(cr, rec, rneed);
                    answer(c1, r ? 0x1234u : 0u);
                    fn(s, &g_w, &g_host);
                    if (pos == 9) {
                        CK(L.n == 0);
                    } else {
                        const uint32_t word = words[wi + (r ? 1 : 0)];
                        CK(L.c[0].callee == c1 && L.c[0].this_ptr == ob1 && L.c[0].nargs == 1 && L.c[0].a[0] == (uint32_t)(int32_t)(int16_t)word);
                        if ((gate && r == 0) || (!gate && r != 0)) {
                            CK(L.n == 2);
                            CK(L.c[1].callee == (gate ? c2 : c3) && L.c[1].this_ptr == ob2 && L.c[1].nargs == 1 && L.c[1].a[0] == word);
                        } else {
                            CK(L.n == 1);
                        }
                    }
                    CK(memcmp(s, cs, need) == 0 && memcmp(rec, cr, rneed) == 0);
                }
    free(s);
    free(rec);
    free(cs);
    free(cr);
}

typedef void (*FillCellsFn)(uint8_t *, const Fl18Host *);
/* thiscall: the table behind the address in dword [self+pt] gets 2 * dword [self+fn] bytes zeroed (rep stosd, rep stosb); then for h < (signed dword [self+ht]) and w < (signed dword [self+wd])
 * the word at table + (h*wd + w)*2 gets its low byte or-ed with 0x0f (the high byte is kept). Exactly sized heap blocks: the object, and the table (large enough for both the fill and the cells). */
static void check_fillcells(FillCellsFn fn, size_t fn_off, size_t pt, size_t wd, size_t ht)
{
    static const int32_t hs[] = {0, 1, 2, 3, -1, 2, 4, 1, 3, 0};
    static const int32_t ws[] = {0, 1, 3, 2, 3, -4, 5, 7, 3, 4};
    static const uint32_t fills[] = {0, 1, 2, 3, 6, 9, 0, 20, 7, 8};
    size_t need = (wd > ht ? wd : ht) + 4, i, k;
    if (fn_off + 4 > need) need = fn_off + 4;
    if (pt + 4 > need) need = pt + 4;
    for (i = 0; i < 10 && !g_failed; i++) {
        const int32_t h = hs[i], w = ws[i];
        const size_t cells = (h > 0 && w > 0) ? (size_t)h * (size_t)w : 0, tn = (cells * 2 > fills[i] * 2u ? cells * 2 : fills[i] * 2u), tsize = tn ? tn : 1;
        uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need), *t = (uint8_t *)malloc(tsize), *wt = (uint8_t *)malloc(tsize);
        int32_t hh, ww;
        CK(s != NULL && want != NULL && t != NULL && wt != NULL);
        if (s == NULL || want == NULL || t == NULL || wt == NULL) return;
        setup();
        for (k = 0; k < need; k++) s[k] = (uint8_t)(k * 5 + 1 + i);
        for (k = 0; k < tsize; k++) t[k] = (uint8_t)(k * 13 + 0x21 + i);
        put32(s, fn_off, fills[i]);
        put32(s, pt, 0x20004000u);
        put32(s, wd, (uint32_t)w);
        put32(s, ht, (uint32_t)h);
        region_add(0x20004000u, t, (uint32_t)tsize);
        memcpy(want, s, need);
        memcpy(wt, t, tsize);
        memset(wt, 0, fills[i] * 2u);
        for (hh = 0; hh < h; hh++)
            for (ww = 0; ww < w; ww++) wt[((size_t)hh * (size_t)w + (size_t)ww) * 2] |= 0x0f;
        fn(s, &g_host);
        CK(memcmp(s, want, need) == 0);
        CK(memcmp(t, wt, tsize) == 0);
        CK(L.n == 0);
        free(s);
        free(want);
        free(t);
        free(wt);
    }
}

typedef void (*CountNeFn)(uint8_t *);
/* thiscall: dword [self+cnt] = the number of records i < n (stride s from [self+base]) whose zero-terminated string (repne scasb) is not empty, i.e. whose first byte is not 0. Every record here is
 * terminated inside its stride. Exactly sized heap block. */
static void check_countne(CountNeFn fn, size_t cnt, size_t n, size_t stride, size_t base)
{
    size_t need = cnt + 4, masks[] = {0, 0x3ff, 0x155, 0x2aa, 1, 0x200, 0x1ff, 0x2ff}, m, i, j;
    uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need);
    CK(s != NULL && want != NULL);
    if (s == NULL || want == NULL) return;
    for (m = 0; m < sizeof masks / sizeof masks[0] && !g_failed; m++) {
        uint32_t expect = 0;
        setup();
        for (i = 0; i < need; i++) s[i] = (uint8_t)(i * 7 + 3 + m);
        for (i = 0; i < n; i++) {
            uint8_t *p = s + base + i * stride;
            if ((masks[m] >> i) & 1) {
                for (j = 0; j < 3 + i; j++) p[j] = (uint8_t)(0x41 + j);
                p[3 + i] = 0;
                expect++;
            } else {
                p[0] = 0;
                p[1] = 0x42;                                    /* what follows the empty string does not count */
            }
        }
        memcpy(want, s, need);
        put32(want, cnt, expect);
        fn(s);
        CK(memcmp(s, want, need) == 0);
        CK(L.n == 0);
    }
    free(s);
    free(want);
}

typedef uint8_t *(*ImpClearFn)(uint8_t *, uint32_t, const Fl18Host *);
/* thiscall, stack argument a0, `ret 4`: c1(this) (thiscall, no argument); then a0 == 0: n dwords at [self+o] are zeroed, dword [self+f] = v, result 0 (null);
 * a0 != 0: imp(a0, self + o, 0) (the import slot `imp`, stdcall, 3 arguments, nothing is stored), result self + o. Exactly sized heap block. */
static void check_impclear(ImpClearFn fn, uint32_t c1, size_t n, size_t o, size_t f, uint32_t v, uint32_t imp)
{
    static const uint32_t a0s[] = {0, 0, 1, 0x80000000u, 0xffffffffu, 0x12345678u};
    size_t need = o + n * 4 > f + 4 ? o + n * 4 : f + 4, i, k;
    uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need);
    CK(s != NULL && want != NULL);
    if (s == NULL || want == NULL) return;
    for (i = 0; i < 6 && !g_failed; i++) {
        uint8_t *ret;
        setup();
        for (k = 0; k < need; k++) s[k] = (uint8_t)(k * 5 + 1 + i);
        memcpy(want, s, need);
        g_ret = 0x1234;
        if (a0s[i] == 0) {
            memset(want + o, 0, n * 4);
            put32(want, f, v);
        }
        ret = fn(s, a0s[i], &g_host);
        CK(L.c[0].callee == c1 && L.c[0].this_ptr == (uintptr_t)s && L.c[0].nargs == 0);
        if (a0s[i] == 0) {
            CK(ret == NULL && L.n == 1);
        } else {
            CK(ret == s + o && L.n == 2);
            CK(L.c[1].callee == imp && L.c[1].this_ptr == 0 && L.c[1].nargs == 3 && L.c[1].a[0] == a0s[i] && L.c[1].a[1] == (uintptr_t)(s + o) && L.c[1].a[2] == 0);
        }
        CK(memcmp(s, want, need) == 0);
    }
    free(s);
    free(want);
}

typedef uint32_t (*FindZeroFn)(uint8_t *);
/* stack argument (obj; ecx is only saved), `ret 4`: 0 when obj is null (nothing else); otherwise for i = 0 .. (signed dword [obj+cnt]) - 1 the 16 bytes at [obj+base+i*stride] are compared with 16
 * zero bytes (repe cmpsb); the first record that is all zero ends the search: dword [obj+res] = i, result 1. No such record: dword [obj+res] = 0, result 1. Exactly sized heap block. */
static void check_findzero(FindZeroFn fn, size_t cnt, size_t res_off, size_t stride, size_t base)
{
    static const int32_t cnts[] = {0, -1, -5, 1, 2, 3, 3, 3};
    static const int hits[] = {-1, -1, -1, 0, 1, 2, -1, 0};
    size_t need = base + 2 * stride + 16, i, j, k;
    uint8_t *o = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need);
    CK(o != NULL && want != NULL);
    if (o == NULL || want == NULL) return;
    if (res_off + 4 > need) need = res_off + 4;
    if (cnt + 4 > need) need = cnt + 4;
    free(o);
    free(want);
    o = (uint8_t *)malloc(need);
    want = (uint8_t *)malloc(need);
    CK(o != NULL && want != NULL);
    if (o == NULL || want == NULL) return;
    setup();
    CK(fn(NULL) == 0 && L.n == 0);                              /* a null object: nothing at all */
    for (i = 0; i < 8 && !g_failed; i++) {
        uint32_t ret;
        int32_t n = cnts[i];
        setup();
        for (k = 0; k < need; k++) o[k] = (uint8_t)(k * 5 + 1 + i);
        put32(o, cnt, (uint32_t)n);
        put32(o, res_off, 0xabcdef01u);
        for (j = 0; j < 3; j++) {
            for (k = 0; k < 16; k++) o[base + j * stride + k] = (uint8_t)(0x30 + k + j);
            if ((int)j == hits[i]) {
                memset(o + base + j * stride, 0, 16 + (i % 2));        /* the 16 bytes are zero; the byte after them may be zero too and must not count */
            } else {
                const size_t p = (j * 5 + i) % 16;
                o[base + j * stride + p] = 0x80;                       /* the first difference at a varying place; bytes before it are zero */
                for (k = 0; k < p; k++) o[base + j * stride + k] = 0;
                if ((i + j) % 2 == 0) for (k = p + 1; k < 16; k++) o[base + j * stride + k] = 0;       /* what follows the first difference does not matter, even when zero */
            }
        }
        memcpy(want, o, need);
        put32(want, res_off, hits[i] >= 0 && n > hits[i] ? (uint32_t)hits[i] : 0);
        ret = fn(o);
        CK(ret == 1);
        CK(memcmp(o, want, need) == 0);
        CK(L.n == 0);
    }
    free(o);
    free(want);
}

typedef void (*TickStrFn)(uint8_t *, const Fl18Host *);
static uint32_t t_now;
static int t_calls;
static uint32_t t_tick(void *ctx)
{
    (void)ctx;
    t_calls++;
    return t_now;
}
/* thiscall: dword [self+z1] = 0; now = GetTickCount (once, the host's tick); dword [self+t] = now + the signed word [self+w]; dword [self+l] = strlen of the string at [self+s]; byte [self+z2] = 0;
 * dword [self+z3] = 0; dword [self+z4] = 0. Exactly sized heap block (the string is terminated inside it). */
static void check_tickstr(TickStrFn fn, size_t z1, size_t w, size_t t, size_t s_off, size_t l, size_t z2, size_t z3, size_t z4)
{
    static const uint32_t nows[] = {0, 1, 0xffffffffu, 0x7fffffffu, 0x80000000u, 0x12345678u};
    static const uint16_t words[] = {0, 1, 0xffff, 0x7fff, 0x8000, 0x1234};
    static const size_t lens[] = {0, 1, 2, 3, 4, 5, 0x20, 0x41};
    size_t need = s_off + 0x50, i, k;
    uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need);
    CK(s != NULL && want != NULL);
    if (s == NULL || want == NULL) return;
    for (i = 0; i < 24 && !g_failed; i++) {
        const size_t len = lens[i % 8];
        setup();
        g_host.tick = t_tick;
        t_calls = 0;
        t_now = nows[i % 6];
        for (k = 0; k < need; k++) s[k] = (uint8_t)(k * 5 + 1 + i);
        for (k = 0; k < len; k++) s[s_off + k] = (uint8_t)(0x41 + k);
        s[s_off + len] = 0;
        put16(s, w, words[(i / 2) % 6]);
        memcpy(want, s, need);
        put32(want, z1, 0);
        put32(want, t, t_now + (uint32_t)(int32_t)(int16_t)words[(i / 2) % 6]);
        put32(want, l, (uint32_t)len);
        want[z2] = 0;
        put32(want, z3, 0);
        put32(want, z4, 0);
        fn(s, &g_host);
        CK(memcmp(s, want, need) == 0);
        CK(t_calls == 1 && L.n == 0);
    }
    free(s);
    free(want);
}

typedef void (*RelListFn)(uint8_t *, const Fl18Host *);
/* thiscall: p = dword [self+hd]; while p != 0 (the list is walked only when the head is non-zero): next = dword [node(p)+nx] (read before the call), c1(this = self, p) (thiscall, one argument), p = next.
 * Then, when the dword [self+tl] is non-zero, c2([self+tl]) (cdecl, one argument). Finally n dwords from [self+hd] are zeroed. Exactly sized heap blocks for the object and the nodes. */
static void check_rellist(RelListFn fn, size_t hd, size_t nx, size_t tl, size_t n, uint32_t c1, uint32_t c2)
{
    size_t need = hd + n * 4 > tl + 4 ? hd + n * 4 : tl + 4, len, tail, k;
    for (len = 0; len < 4 && !g_failed; len++)
        for (tail = 0; tail < 2 && !g_failed; tail++) {
            uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need), *node[3];
            size_t j, calls = 0;
            CK(s != NULL && want != NULL);
            if (s == NULL || want == NULL) return;
            setup();
            for (k = 0; k < need; k++) s[k] = (uint8_t)(k * 5 + 1 + len + tail);
            for (j = 0; j < 3; j++) {
                node[j] = (uint8_t *)malloc(nx + 4);
                CK(node[j] != NULL);
                if (node[j] == NULL) return;
                for (k = 0; k < nx + 4; k++) node[j][k] = (uint8_t)(k * 3 + 7 * j);
                put32(node[j], nx, j + 1 < len ? 0x20006000u + 0x1000u * (uint32_t)(j + 1) : 0);
                region_add(0x20006000u + 0x1000u * (uint32_t)j, node[j], (uint32_t)(nx + 4));
            }
            put32(s, hd, len ? 0x20006000u : 0);
            put32(s, tl, tail ? 0xcafe0000u + (uint32_t)len : 0);
            memcpy(want, s, need);
            memset(want + hd, 0, n * 4);
            fn(s, &g_host);
            CK((size_t)L.n == len + tail);
            for (j = 0; j < len; j++) {
                CK(L.c[calls].callee == c1 && L.c[calls].this_ptr == (uintptr_t)s && L.c[calls].nargs == 1 && L.c[calls].a[0] == 0x20006000u + 0x1000u * (uint32_t)j);
                calls++;
            }
            if (tail) CK(L.c[calls].callee == c2 && L.c[calls].this_ptr == 0 && L.c[calls].nargs == 1 && L.c[calls].a[0] == 0xcafe0000u + (uint32_t)len);
            CK(memcmp(s, want, need) == 0);
            for (j = 0; j < 3; j++) free(node[j]);
            free(s);
            free(want);
        }
}

typedef void (*CopyCountedFn)(uint8_t *, const uint8_t *, uint32_t, const Fl39fWorld *, const Fl18Host *);
/* thiscall, stack arguments (src, count), `ret 8`: copies count bytes (count / 4 dwords with rep movsd, then count & 3 bytes with rep movsb) from src to [self+off]; then, when the signed debug word
 * 0x63a4cd is non-zero, c1(a) (cdecl, one argument) is called once, after the copy. Exactly sized heap blocks. */
static void check_copy_counted(CopyCountedFn fn, size_t off, uint32_t c1, uint32_t a)
{
    static const uint32_t counts[] = {0, 1, 2, 3, 4, 5, 7, 8, 9, 0x10, 0x13, 0x40};
    static const int16_t dbgs[] = {0, 1, 0x100, (int16_t)0x8000, -1};
    size_t i, j, k;
    for (i = 0; i < 12 && !g_failed; i++)
        for (j = 0; j < 5 && !g_failed; j++) {
            size_t need = off + counts[i];
            uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need), *src = (uint8_t *)malloc(counts[i] + 1);
            CK(s != NULL && want != NULL && src != NULL);
            if (s == NULL || want == NULL || src == NULL) return;
            setup();
            memset(&g_w, 0, sizeof g_w);
            g_w.word_63a4cd = dbgs[j];
            for (k = 0; k < need; k++) s[k] = (uint8_t)(k * 5 + 1 + j);
            for (k = 0; k < counts[i] + 1; k++) src[k] = (uint8_t)(k * 11 + 7 + i);
            memcpy(want, s, need);
            memcpy(want + off, src, counts[i]);
            fn(s, src, counts[i], &g_w, &g_host);
            CK(memcmp(s, want, need) == 0);
            if (dbgs[j] != 0) {
                CK(L.n == 1);
                CK(L.c[0].callee == c1 && L.c[0].this_ptr == 0 && L.c[0].nargs == 1 && L.c[0].a[0] == a);
            } else {
                CK(L.n == 0);
            }
            free(s);
            free(want);
            free(src);
        }
}

typedef void (*CopyInFn)(uint8_t *, const uint8_t *);
/* thiscall, stack arguments (src, unused), `ret 8`, no return value: copies dwords*4 + tail bytes (rep movsd, then movsw / movsb) from src to [self+off]; nothing else changes and nothing is called.
 * The object and the source are exactly sized heap blocks, so that a sanitiser reports a read or a write outside the bytes the function touches. */
static void check_copy_in(CopyInFn fn, size_t off, size_t dwords, size_t tail)
{
    size_t total = dwords * 4 + tail, need = off + total, i, k;
    uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need), *src = (uint8_t *)malloc(total);
    CK(s != NULL && want != NULL && src != NULL);
    if (s == NULL || want == NULL || src == NULL) return;
    for (i = 0; i < 3 && !g_failed; i++) {
        setup();
        for (k = 0; k < need; k++) s[k] = (uint8_t)(k * 5 + 1 + i);
        for (k = 0; k < total; k++) src[k] = (uint8_t)(k * 11 + 7 + 3 * i);
        memcpy(want, s, need);
        memcpy(want + off, src, total);
        fn(s, src);
        CK(memcmp(s, want, need) == 0);
        CK(L.n == 0);
    }
    free(s);
    free(want);
    free(src);
}

typedef void (*SetNameFn)(uint8_t *, const uint8_t *);
/* thiscall, stack argument (name), `ret 4`: the n = dwords*4 + 1 bytes at [self+src_off] are copied to [self+dst_off] (rep movsd, movsb); then the zero-terminated string at `name` is copied there too,
 * strlen(name) + 1 bytes (repne scasb finds the length including the terminator; rep movsd for len/4 dwords, rep movsb for len & 3 bytes). The original does not bound the length by the field:
 * the lengths tested keep the copy inside the n bytes of the field. Exactly sized heap blocks. */
static void check_setname(SetNameFn fn, size_t src_off, size_t dst_off, size_t dwords)
{
    size_t first = dwords * 4 + 1, need = (src_off > dst_off ? src_off : dst_off) + first, len, k;
    for (len = 0; len < first && !g_failed; len += (len < 6 ? 1 : 7)) {
        uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need), *name = (uint8_t *)malloc(len + 1);
        CK(s != NULL && want != NULL && name != NULL);
        if (s == NULL || want == NULL || name == NULL) return;
        setup();
        for (k = 0; k < need; k++) s[k] = (uint8_t)(k * 5 + 1 + len);
        for (k = 0; k < len; k++) name[k] = (uint8_t)(0x41 + (k * 3 + len) % 50);
        name[len] = 0;
        memcpy(want, s, need);
        memcpy(want + dst_off, want + src_off, first);
        memcpy(want + dst_off, name, len + 1);
        fn(s, name);
        CK(memcmp(s, want, need) == 0);
        CK(L.n == 0);
        free(s);
        free(want);
        free(name);
    }
}

typedef void (*FillTableFn)(uint8_t *, const Fl39fWorld *);
/* thiscall: the loop counter dword [self+ct] runs 0 .. n-1; for each i the record at table + i*stride gets: byte 0 = 0; at +t1 the zero-terminated string at [self+src] (strlen + 1 bytes: repne scasb,
 * rep movsd, rep movsb); at +t2 the `dwords` * 4 + 1 bytes at [self+src2] (rep movsd, movsb). The original does not bound the string by the field (the 0x3c bytes up to t2): the strings here are at
 * most 0x3b bytes long. Exactly sized heap blocks. */
static void check_filltable(FillTableFn fn, size_t ct, size_t n, size_t stride, size_t t1, size_t t2, size_t src, size_t src2, size_t dwords)
{
    static const size_t lens[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 30, 0x3b};
    size_t need = ct + 4, tsize = n * stride, li, i, k;
    if (src + 0x40 > need) need = src + 0x40;
    for (li = 0; li < 12 && !g_failed; li++) {
        uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need), *t = (uint8_t *)malloc(tsize), *wt = (uint8_t *)malloc(tsize);
        CK(s != NULL && want != NULL && t != NULL && wt != NULL);
        if (s == NULL || want == NULL || t == NULL || wt == NULL) return;
        setup();
        memset(&g_w, 0, sizeof g_w);
        g_w.table_583f1f = t;
        for (k = 0; k < need; k++) s[k] = (uint8_t)(k * 5 + 1 + li);
        for (k = 0; k < lens[li]; k++) s[src + k] = (uint8_t)(0x41 + (k + li) % 40);
        s[src + lens[li]] = 0;
        for (k = 0; k < tsize; k++) t[k] = (uint8_t)(k * 13 + 0x21 + li);
        memcpy(want, s, need);
        memcpy(wt, t, tsize);
        put32(want, ct, (uint32_t)n);
        for (i = 0; i < n; i++) {
            wt[i * stride] = 0;
            memcpy(wt + i * stride + t1, s + src, lens[li] + 1);
            memcpy(wt + i * stride + t2, s + src2, dwords * 4 + 1);
        }
        fn(s, &g_w);
        CK(memcmp(s, want, need) == 0);
        CK(memcmp(t, wt, tsize) == 0);
        CK(L.n == 0);
        free(s);
        free(want);
        free(t);
        free(wt);
    }
}

typedef void (*CopyLimitFn)(uint8_t *, const uint8_t *, int32_t, const Fl18Host *);
/* thiscall, stack args (src, limit), `ret 8`: copies b bytes (dwords of rep movsd, a movsw, a movsb) from src to [self+off]; when b > limit (signed): p(s2, s1, b, limit) (cdecl, 4 arguments),
 * q(this m, s2) (thiscall), y(this x) (thiscall, no argument). Exactly sized heap blocks. */
static void check_copy_limit(CopyLimitFn fn, size_t off, size_t b, uint32_t s1, uint32_t s2, uint32_t p0, uint32_t m, uint32_t q, uint32_t x, uint32_t y)
{
    int32_t limits[8];
    size_t need = off + b, i, k;
    uint8_t *s = (uint8_t *)malloc(need), *src = (uint8_t *)malloc(b), *want = (uint8_t *)malloc(need);
    CK(s != NULL && src != NULL && want != NULL);
    if (s == NULL || src == NULL || want == NULL) return;
    limits[0] = (int32_t)b - 1; limits[1] = (int32_t)b; limits[2] = (int32_t)b + 1; limits[3] = 0; limits[4] = -1; limits[5] = 0x7fffffff; limits[6] = (int32_t)0x80000000u; limits[7] = (int32_t)b - 4;
    for (i = 0; i < 8 && !g_failed; i++) {
        setup();
        for (k = 0; k < need; k++) s[k] = (uint8_t)(k * 5 + 1);
        for (k = 0; k < b; k++) src[k] = (uint8_t)(k * 11 + 7);
        memcpy(want, s, need);
        memcpy(want + off, src, b);
        g_ret = 0x1234;
        fn(s, src, limits[i], &g_host);
        CK(memcmp(s, want, need) == 0);
        if ((int32_t)b > limits[i]) {
            CK(L.n == 3);
            CK(L.c[0].callee == p0 && L.c[0].this_ptr == 0 && L.c[0].nargs == 4 && L.c[0].a[0] == s2 && L.c[0].a[1] == s1 && L.c[0].a[2] == b && (uint32_t)L.c[0].a[3] == (uint32_t)limits[i]);
            CK(L.c[1].callee == q && L.c[1].this_ptr == m && L.c[1].nargs == 1 && L.c[1].a[0] == s2);
            CK(L.c[2].callee == y && L.c[2].this_ptr == x && L.c[2].nargs == 0);
        } else {
            CK(L.n == 0);
        }
    }
    free(s);
    free(src);
    free(want);
}

typedef uint32_t (*CheckNameFn)(uint32_t, const uint8_t *, uint32_t, uint8_t *, const Fl39fWorld *, const Fl18Host *);
/* stack arguments (a0, name, a2, cell), `ret 0x10`, returns 1 or 0.
 *  a0 == 0: when the first n bytes at `name` equal the n bytes at the world pointer (repe cmpsb): the debug word non-zero -> p(s2, s1, name) (cdecl, 3 arguments) and q(s2) (cdecl); result 1.
 *           Not equal: result 1 (the shared a0 == 0 exit).
 *  a0 != 0: dword [cell] = a0; the debug word non-zero -> p(s2, s3, name, a2) (cdecl, 4 arguments) and q(s2); result 0.
 * Exactly sized heap blocks for the name and the cell. */
static void check_checkname(CheckNameFn fn, uint32_t n, uint32_t p0, uint32_t q, uint32_t s1, uint32_t s2, uint32_t s3)
{
    static const int16_t dbgs[] = {0, 1, 0x100, (int16_t)0x8000};
    uint8_t K[64];
    size_t i, k;
    for (k = 0; k < n; k++) K[k] = (uint8_t)(0x20 + k * 3);
    for (i = 0; i < 4 * 6 && !g_failed; i++) {
        const int16_t dbg = dbgs[i % 4];
        const int a0nz = (i / 4) % 3 == 2, equal = (i / 4) % 3 == 0;     /* a0 == 0 and equal; a0 == 0 and different; a0 != 0 */
        const uint32_t a0 = a0nz ? 0x1234abcdu : 0, a2 = 0xfeed0000u + (uint32_t)i;
        uint8_t *name = (uint8_t *)malloc(n), *cell = (uint8_t *)malloc(4);
        uint32_t ret;
        size_t at = 0;
        CK(name != NULL && cell != NULL);
        if (name == NULL || cell == NULL) return;
        setup();
        memset(&g_w, 0, sizeof g_w);
        g_w.word_63a4cd = dbg;
        g_w.bytes_56040c = K;
        memcpy(name, K, n);
        if (!equal && !a0nz) name[(i * 7) % n] ^= 0x10;
        put32(cell, 0, 0x55667788u);
        ret = fn(a0, name, a2, cell, &g_w, &g_host);
        if (!a0nz && equal) {
            CK(ret == 1 && get32(cell, 0) == 0x55667788u);
            if (dbg != 0) {
                CK(L.n == 2);
                CK(L.c[0].callee == p0 && L.c[0].this_ptr == 0 && L.c[0].nargs == 3 && L.c[0].a[0] == s2 && L.c[0].a[1] == s1 && L.c[0].a[2] == (uintptr_t)name);
                CK(L.c[1].callee == q && L.c[1].this_ptr == 0 && L.c[1].nargs == 1 && L.c[1].a[0] == s2);
            } else {
                CK(L.n == 0);
            }
        } else if (!a0nz) {
            CK(ret == 1 && get32(cell, 0) == 0x55667788u && L.n == 0);
        } else {
            CK(ret == 0 && get32(cell, 0) == a0);
            if (dbg != 0) {
                CK(L.n == 2);
                CK(L.c[at].callee == p0 && L.c[at].this_ptr == 0 && L.c[at].nargs == 4 && L.c[at].a[0] == s2 && L.c[at].a[1] == s3 && L.c[at].a[2] == (uintptr_t)name && L.c[at].a[3] == a2);
                CK(L.c[at + 1].callee == q && L.c[at + 1].this_ptr == 0 && L.c[at + 1].nargs == 1 && L.c[at + 1].a[0] == s2);
            } else {
                CK(L.n == 0);
            }
        }
        free(name);
        free(cell);
    }
}

static void test_m48ef40_advance_slot(void)
{
    check_advslot(m48ef40_advance_slot, 0x1e, 0x8d, 0xb0, 0x3fe, 0x46a);
}

static void test_m4904fa_construct_record(void)
{
    const size_t need = 0x1f7f;
    uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need);
    size_t i, k;
    CK(s != NULL && want != NULL);
    if (s == NULL || want == NULL) return;
    for (k = 0; k < NRETS && !g_failed; k++) {
        setup();
        for (i = 0; i < need; i++) s[i] = (uint8_t)(i * 5 + 1);
        memcpy(want, s, need);
        put32(want, 0x0, 0x52daf8u);
        put32(want, 0x1f77, 0x0u);
        put32(want, 0x1f7b, 0x1u);
        memset(want + 0x20, 0, 0x1ecb);
        g_ret = RETS[k];
        CK(m4904fa_construct_record(s, &g_host) == s);
        CK(L.n == 1);
        CK(L.c[0].callee == 0x51d716 && L.c[0].this_ptr == (uintptr_t)s && L.c[0].nargs == 0 && L.c[0].first_dword == 0x100b0601u);
        CK(memcmp(s, want, need) == 0);
    }
    free(s);
    free(want);
}

static void test_m49192b_clear_block(void)
{
    check_clearblk(m49192b_clear_block, 0x50f3, 0x50f7, 0x50fb);
}

static void test_m495608_check_object(void)
{
    check_checkobj(m495608_check_object, 0x4769, 0x201f, 0x28, 0x49, 0x4f6334, 0x4fb2e3, 0x4fc878, 0x5cf1eb, 0x5c3a67);
}

static void test_m49c53a_construct_record(void)
{
    const size_t need = 0xdd8;
    uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need);
    size_t i, k;
    CK(s != NULL && want != NULL);
    if (s == NULL || want == NULL) return;
    for (k = 0; k < NRETS && !g_failed; k++) {
        setup();
        for (i = 0; i < need; i++) s[i] = (uint8_t)(i * 5 + 1);
        memcpy(want, s, need);
        put32(want, 0x0, 0x52dbc8u);
        memset(want + 0x28, 0, 0xdb0);
        g_ret = RETS[k];
        CK(m49c53a_construct_record(s, &g_host) == s);
        CK(L.n == 2);
        CK(L.c[0].callee == 0x51d716 && L.c[0].this_ptr == (uintptr_t)s && L.c[0].nargs == 0 && L.c[0].first_dword == 0x100b0601u);
        CK(L.c[1].callee == 0x49c5f0 && L.c[1].this_ptr == (uintptr_t)s && L.c[1].nargs == 0 && L.c[1].first_dword == 0x52dbc8u);
        CK(memcmp(s, want, need) == 0);
    }
    free(s);
    free(want);
}

static void test_m49cf80_fill_cells(void)
{
    check_fillcells(m49cf80_fill_cells, 0xdf4, 0xde0, 0xdd8, 0xddc);
}

static void test_m4a0c7f_count_nonempty(void)
{
    check_countne(m4a0c7f_count_nonempty, 0xe18, 10, 0x15e, 0x2c);
}

static void test_m4ac8da_init_record(void)
{
    const size_t need = 0xe89;
    uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need);
    size_t i, k;
    CK(s != NULL && want != NULL);
    if (s == NULL || want == NULL) return;
    for (k = 0; k < NRETS && !g_failed; k++) {
        setup();
        for (i = 0; i < need; i++) s[i] = (uint8_t)(i * 5 + 1);
        memcpy(want, s, need);
        put16(want, 0x1e, 0xffff);
        put16(want, 0x1c, 0xffff);
        put32(want, 0xc1b, 0x0u);
        put32(want, 0xc17, 0x0u);
        want[0xc1f] = 0x0;
        want[0xc24] = 0x0;
        put32(want, 0x20, 0x0u);
        put16(want, 0x24, 0xffff);
        put32(want, 0x46, 0x0u);
        put32(want, 0x6a, 0x0u);
        put32(want, 0xc35, 0x0u);
        memset(want + 0x6e, 0, 0xba9);
        memset(want + 0xe59, 0, 0x30);
        g_ret = RETS[k];
        m4ac8da_init_record(s);
        CK(L.n == 0);
        
        CK(memcmp(s, want, need) == 0);
    }
    free(s);
    free(want);
}

static void test_m4beeb3_bind_buffer(void)
{
    check_impclear(m4beeb3_bind_buffer, 0x4bf38c, 0xe, 0x84, 0x2c0, 0xfffffffdu, 0x52a534);
}

static void test_m4c9cdd_find_zero_record(void)
{
    check_findzero(m4c9cdd_find_zero_record, 0x1758, 0x175c, 0x3e4, 0x30c);
}

static void test_m4d52b9_init_record(void)
{
    const size_t need = 0xb4;
    uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need);
    size_t i, k;
    CK(s != NULL && want != NULL);
    if (s == NULL || want == NULL) return;
    for (k = 0; k < NRETS && !g_failed; k++) {
        setup();
        for (i = 0; i < need; i++) s[i] = (uint8_t)(i * 5 + 1);
        memcpy(want, s, need);
        memset(want + 0x4, 0, 0x80);
        memset(want + 0x84, 0, 0x10);
        memset(want + 0x94, 0, 0x10);
        memset(want + 0xa4, 0, 0x10);
        g_ret = RETS[k];
        m4d52b9_init_record(s);
        CK(L.n == 0);
        
        CK(memcmp(s, want, need) == 0);
    }
    free(s);
    free(want);
}

static void test_m4d6ad1_start_timer(void)
{
    check_tickstr(m4d6ad1_start_timer, 0x461, 0x2cc, 0x465, 0x96d3, 0x469, 0x46d, 0x46e, 0x472);
}

static void test_m4d8f0a_release_list(void)
{
    check_rellist(m4d8f0a_release_list, 0x9804, 0x108, 0x980c, 0x29, 0x4d8f8d, 0x51dc6c);
}

static void test_m4dc13f_copy_counted(void)
{
    check_copy_counted(m4dc13f_copy_counted, 0x4e, 0x44a2b7, 0x55b058);
}

static void test_m4de5f0_construct_record(void)
{
    const size_t need = 0x582;
    uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need);
    size_t i, k;
    CK(s != NULL && want != NULL);
    if (s == NULL || want == NULL) return;
    for (k = 0; k < NRETS && !g_failed; k++) {
        setup();
        for (i = 0; i < need; i++) s[i] = (uint8_t)(i * 5 + 1);
        memcpy(want, s, need);
        put32(want, 0x0, 0x52e4d0u);
        memset(want + 0x4, 0, 0x389);
        g_ret = RETS[k];
        CK(m4de5f0_construct_record(s, &g_host) == s);
        CK(L.n == 3);
        CK(L.c[0].callee == 0x4e1c50 && L.c[0].this_ptr == (uintptr_t)(s + 0x3ef) && L.c[0].nargs == 0 && L.c[0].first_dword == 0xbbb6b1acu);
        CK(L.c[1].callee == 0x4ee980 && L.c[1].this_ptr == (uintptr_t)(s + 0x57e) && L.c[1].nargs == 0 && L.c[1].first_dword == 0x86817c77u);
        CK(L.c[2].callee == 0x4de6d7 && L.c[2].this_ptr == (uintptr_t)s && L.c[2].nargs == 0 && L.c[2].first_dword == 0x52e4d0u);
        CK(memcmp(s, want, need) == 0);
    }
    free(s);
    free(want);
}

static void test_m4e0410_construct_record(void)
{
    const size_t need = 0x758;
    uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need);
    size_t i, k;
    CK(s != NULL && want != NULL);
    if (s == NULL || want == NULL) return;
    for (k = 0; k < NRETS && !g_failed; k++) {
        setup();
        for (i = 0; i < need; i++) s[i] = (uint8_t)(i * 5 + 1);
        memcpy(want, s, need);
        put32(want, 0x0, 0x52e4e4u);
        memset(want + 0x4, 0, 0x74b);
        g_ret = RETS[k];
        CK(m4e0410_construct_record(s, &g_host) == s);
        CK(L.n == 2);
        CK(L.c[0].callee == 0x50cb26 && L.c[0].this_ptr == 0 && L.c[0].nargs == 5 && L.c[0].a[0] == (uintptr_t)(s + 0x757) && L.c[0].a[1] == 0x18f && L.c[0].a[2] == 0x5 && L.c[0].a[3] == 0x4e1c50 && L.c[0].a[4] == 0x4e1c83);
        CK(L.c[1].callee == 0x4e04f3 && L.c[1].this_ptr == (uintptr_t)s && L.c[1].nargs == 0 && L.c[1].first_dword == 0x52e4e4u);
        CK(memcmp(s, want, need) == 0);
    }
    free(s);
    free(want);
}

static void test_m4e069c_copy_in(void)
{
    check_copy_in(m4e069c_copy_in, 0x4, 0x1d2, 3);
}

static void test_m4e1c50_construct_record(void)
{
    const size_t need = 0x127;
    uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need);
    size_t i, k;
    CK(s != NULL && want != NULL);
    if (s == NULL || want == NULL) return;
    for (k = 0; k < NRETS && !g_failed; k++) {
        setup();
        for (i = 0; i < need; i++) s[i] = (uint8_t)(i * 5 + 1);
        memcpy(want, s, need);
        put32(want, 0x0, 0x52e4e8u);
        memset(want + 0x38, 0, 0xef);
        g_ret = RETS[k];
        CK(m4e1c50_construct_record(s, &g_host) == s);
        CK(L.n == 1);
        CK(L.c[0].callee == 0x4e1c9f && L.c[0].this_ptr == (uintptr_t)s && L.c[0].nargs == 0 && L.c[0].first_dword == 0x52e4e8u);
        CK(memcmp(s, want, need) == 0);
    }
    free(s);
    free(want);
}

static void test_m4e4428_copy_in(void)
{
    check_copy_in(m4e4428_copy_in, 0x54df, 0x43b, 1);
}

static void test_m4e498d_set_name(void)
{
    check_setname(m4e498d_set_name, 0xa80, 0x453c, 0xc);
}

static void test_m4e7a70_construct_record(void)
{
    const size_t need = 0x7655;
    uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need);
    size_t i, k;
    CK(s != NULL && want != NULL);
    if (s == NULL || want == NULL) return;
    for (k = 0; k < NRETS && !g_failed; k++) {
        setup();
        for (i = 0; i < need; i++) s[i] = (uint8_t)(i * 5 + 1);
        memcpy(want, s, need);
        put32(want, 0x0, 0x52e4f4u);
        put32(want, 0x699, 0x0u);
        put32(want, 0x695, 0x0u);
        put32(want, 0x691, 0x0u);
        memset(want + 0x6b20, 0, 0xb2c);
        memset(want + 0x69d, 0, 0x647f);
        g_ret = RETS[k];
        CK(m4e7a70_construct_record(s, &g_host) == s);
        CK(L.n == 3);
        CK(L.c[0].callee == 0x4eda10 && L.c[0].this_ptr == (uintptr_t)s && L.c[0].nargs == 0 && L.c[0].first_dword == 0x100b0601u);
        CK(L.c[1].callee == 0x50cb26 && L.c[1].this_ptr == 0 && L.c[1].nargs == 5 && L.c[1].a[0] == (uintptr_t)(s + 0x7654) && L.c[1].a[1] == 0x18f && L.c[1].a[2] == 0x6 && L.c[1].a[3] == 0x4e1c50 && L.c[1].a[4] == 0x4e1c83);
        CK(L.c[2].callee == 0x4e7ba7 && L.c[2].this_ptr == (uintptr_t)s && L.c[2].nargs == 0 && L.c[2].first_dword == 0x52e4f4u);
        CK(memcmp(s, want, need) == 0);
    }
    free(s);
    free(want);
}

static void test_m4eb77d_fill_name_table(void)
{
    check_filltable(m4eb77d_fill_name_table, 0x822e, 70, 0x6e, 0x1, 0x3d, 0x712, 0x6e1, 0xc);
}

static void test_m4eb870_construct_record(void)
{
    const size_t need = 0xca9;
    uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need);
    size_t i, k;
    CK(s != NULL && want != NULL);
    if (s == NULL || want == NULL) return;
    for (k = 0; k < NRETS && !g_failed; k++) {
        setup();
        for (i = 0; i < need; i++) s[i] = (uint8_t)(i * 5 + 1);
        memcpy(want, s, need);
        put32(want, 0x0, 0x52e4f8u);
        memset(want + 0x695, 0, 0x60b);
        g_ret = RETS[k];
        CK(m4eb870_construct_record(s, &g_host) == s);
        CK(L.n == 3);
        CK(L.c[0].callee == 0x4eda10 && L.c[0].this_ptr == (uintptr_t)s && L.c[0].nargs == 0 && L.c[0].first_dword == 0x100b0601u);
        CK(L.c[1].callee == 0x50cb26 && L.c[1].this_ptr == 0 && L.c[1].nargs == 5 && L.c[1].a[0] == (uintptr_t)(s + 0xca8) && L.c[1].a[1] == 0x18f && L.c[1].a[2] == 0x2 && L.c[1].a[3] == 0x4e1c50 && L.c[1].a[4] == 0x4e1c83);
        CK(L.c[2].callee == 0x4eb9c8 && L.c[2].this_ptr == (uintptr_t)s && L.c[2].nargs == 0 && L.c[2].first_dword == 0x52e4f8u);
        CK(memcmp(s, want, need) == 0);
    }
    free(s);
    free(want);
}

static void test_m4ec005_copy_checked(void)
{
    check_copy_limit(m4ec005_copy_checked, 0x695, 0x60b, 0x55cc48, 0x63888b, 0x50ca3e, 0x583979, 0x4264e8, 0x5cf659, 0x4c97b4);
}

static void test_m4fa8d2_check_name(void)
{
    check_checkname(m4fa8d2_check_name, 21, 0x50ca3e, 0x44a2b7, 0x560424, 0x63888b, 0x560478);
}

static void test_m4fa980_construct_record(void)
{
    const size_t need = 0xb784;
    uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need);
    size_t i, k;
    CK(s != NULL && want != NULL);
    if (s == NULL || want == NULL) return;
    for (k = 0; k < NRETS && !g_failed; k++) {
        setup();
        for (i = 0; i < need; i++) s[i] = (uint8_t)(i * 5 + 1);
        memcpy(want, s, need);
        put32(want, 0x0, 0x52e518u);
        put16(want, 0xb774, 0x0);
        put32(want, 0xb776, 0x0u);
        put32(want, 0xb77a, 0x0u);
        put32(want, 0xb77e, 0x0u);
        put16(want, 0xb782, 0x0);
        memset(want + 0x4, 0, 0xb760);
        g_ret = RETS[k];
        CK(m4fa980_construct_record(s) == s);
        CK(L.n == 0);
        
        CK(memcmp(s, want, need) == 0);
    }
    free(s);
    free(want);
}

#define RUN(fn)                                                                \
    do {                                                                       \
        g_failed = 0;                                                          \
        g_msg[0] = 0;                                                          \
        fn();                                                                  \
        if (g_failed) {                                                        \
            printf("FAIL %s: %s\n", #fn, g_msg);                               \
            failures++;                                                        \
        } else {                                                               \
            printf("PASS %s\n", #fn);                                           \
        }                                                                      \
    } while (0)

int main(void)
{
    int failures = 0;
    RUN(test_m48ef40_advance_slot);
    RUN(test_m4904fa_construct_record);
    RUN(test_m49192b_clear_block);
    RUN(test_m495608_check_object);
    RUN(test_m49c53a_construct_record);
    RUN(test_m49cf80_fill_cells);
    RUN(test_m4a0c7f_count_nonempty);
    RUN(test_m4ac8da_init_record);
    RUN(test_m4beeb3_bind_buffer);
    RUN(test_m4c9cdd_find_zero_record);
    RUN(test_m4d52b9_init_record);
    RUN(test_m4d6ad1_start_timer);
    RUN(test_m4d8f0a_release_list);
    RUN(test_m4dc13f_copy_counted);
    RUN(test_m4de5f0_construct_record);
    RUN(test_m4e0410_construct_record);
    RUN(test_m4e069c_copy_in);
    RUN(test_m4e1c50_construct_record);
    RUN(test_m4e4428_copy_in);
    RUN(test_m4e498d_set_name);
    RUN(test_m4e7a70_construct_record);
    RUN(test_m4eb77d_fill_name_table);
    RUN(test_m4eb870_construct_record);
    RUN(test_m4ec005_copy_checked);
    RUN(test_m4fa8d2_check_name);
    RUN(test_m4fa980_construct_record);
    return failures;
}
