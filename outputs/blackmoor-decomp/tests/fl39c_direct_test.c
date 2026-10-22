/* FL-39 (batch c) direct tests of the 33 GAME.EXE functions in src/original_methods_fl39c.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl39c_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl39c.h"

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
static Fl39cWorld g_w;

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

typedef void (*ClampFn)(uint8_t *, const Fl39cWorld *);
/* one axis: lo = [lo_off], hi = [hi_off], gl / gh = the global bounds, w = the signed word at w_off. Independent hand model of the disassembly, in 32-bit wrapping arithmetic with signed compares. */
static void clamp_axis(uint32_t *lo, uint32_t *hi, int32_t gl, int32_t gh, int32_t w)
{
    if ((int32_t)*lo < gl) {
        *lo = (uint32_t)gl;
        *hi = *lo + (uint32_t)w;
    }
    if ((int32_t)*hi > gh) {
        *hi = (uint32_t)gh;
        *lo = *hi - (uint32_t)w;
    }
}
static void check_clamp(ClampFn fn, size_t l, size_t h, size_t wy, size_t l2, size_t h2, size_t wx)
{
    static const int32_t gls[] = {-100, 0, 5, 0x7ffffff0, -0x7ffffff0, 10};
    static const int32_t deltas[] = {-5, -1, 0, 1, 5, 0x7fffffff, -0x7fffffff - 1};
    static const int16_t ws[] = {0, 1, 7, -1, -9, 0x7fff, -0x8000};
    size_t need = wy > wx ? wy : wx, k;
    uint8_t *s, *want;
    need = need + 2;
    if (h + 4 > need) need = h + 4;
    if (h2 + 4 > need) need = h2 + 4;
    if (l + 4 > need) need = l + 4;
    if (l2 + 4 > need) need = l2 + 4;
    s = (uint8_t *)malloc(need);
    want = (uint8_t *)malloc(need);
    CK(s != NULL && want != NULL);
    if (s == NULL || want == NULL) return;
    for (k = 0; k < 300 && !g_failed; k++) {
        int32_t gl = gls[k % 6], gh = (int32_t)((uint32_t)gl + (uint32_t)(k % 11) * 3u), gl2 = gls[(k / 6) % 6], gh2 = (int32_t)((uint32_t)gl2 + (uint32_t)((k / 3) % 9) * 4u);
        uint32_t lo = (uint32_t)gl + (uint32_t)deltas[k % 7], hi = (uint32_t)gh + (uint32_t)deltas[(k / 7) % 7];
        uint32_t lo2 = (uint32_t)gl2 + (uint32_t)deltas[(k / 2) % 7], hi2 = (uint32_t)gh2 + (uint32_t)deltas[(k / 5) % 7];
        int16_t wyv = ws[(k / 3) % 7], wxv = ws[(k / 11) % 7];
        uint32_t a, b, c2, d;
        setup();
        memset(&g_w, 0, sizeof g_w);
        g_w.value_58319a = gl;
        g_w.value_5831a2 = gh;
        g_w.value_583196 = gl2;
        g_w.value_58319e = gh2;
        memset(s, 0x33, need);
        put32(s, l, lo);
        put32(s, h, hi);
        put32(s, l2, lo2);
        put32(s, h2, hi2);
        put16(s, wy, (uint16_t)wyv);
        put16(s, wx, (uint16_t)wxv);
        memcpy(want, s, need);
        a = lo; b = hi; c2 = lo2; d = hi2;
        clamp_axis(&a, &b, gl, gh, wyv);
        clamp_axis(&c2, &d, gl2, gh2, wxv);
        put32(want, l, a);
        put32(want, h, b);
        put32(want, l2, c2);
        put32(want, h2, d);
        fn(s, &g_w);
        CK(memcmp(s, want, need) == 0);
        CK(L.n == 0);
        CK(g_w.value_58319a == gl && g_w.value_5831a2 == gh && g_w.value_583196 == gl2 && g_w.value_58319e == gh2);
    }
    free(s);
    free(want);
}

typedef void (*CmpFn)(const uint8_t *, const Fl39cWorld *, const Fl18Host *);
/* The nine bytes at [base+off] are compared with the nine bytes behind the world pointer *slot (repe cmpsb); when they differ (first difference at any of the nine places) the word at
 * [base+woff] goes to c1 (this = obj) (zero-extended when `zext`), otherwise nothing. `base` is self, or (via_ptr) the object whose original address the dword self[pofs] holds.
 * Every buffer is exactly sized so that a sanitiser reports a read outside the bytes the function touches. */
static void check_cmp(CmpFn fn, const uint8_t **slot, size_t off, size_t woff, int via_ptr, size_t pofs, uint32_t c1, uint32_t obj, int zext)
{
    static const uint16_t words[] = {0, 0xffff, 0x1234, 0x8000};
    static const uint8_t K[9] = {0x11, 0x80, 0xff, 0x00, 0x7f, 0x42, 0xa5, 0x01, 0xfe};
    size_t dneed = off + 9 > woff + 2 ? off + 9 : woff + 2, sneed = via_ptr ? pofs + 4 : dneed, m, wi, j;
    uint8_t *s = (uint8_t *)malloc(sneed), *d = via_ptr ? (uint8_t *)malloc(dneed) : s, *k = (uint8_t *)malloc(9), *cs = (uint8_t *)malloc(sneed), *cd = (uint8_t *)malloc(dneed);
    CK(s != NULL && d != NULL && k != NULL && cs != NULL && cd != NULL);
    if (s == NULL || d == NULL || k == NULL || cs == NULL || cd == NULL) return;
    memcpy(k, K, 9);
    for (m = 0; m <= 9 && !g_failed; m++) {
        for (wi = 0; wi < 4 && !g_failed; wi++) {
            setup();
            memset(&g_w, 0, sizeof g_w);
            *slot = k;
            memset(s, 0x33, sneed);
            memset(d, 0x6c, dneed);
            memcpy(d + off, K, 9);
            if (m < 9) {
                d[off + m] = (uint8_t)(K[m] + 1);
                for (j = m + 1; j < 9; j++) if (wi % 2) d[off + j] = (uint8_t)~K[j];       /* what follows the first difference does not matter */
            }
            put16(d, woff, words[wi]);
            if (via_ptr) {
                put32(s, pofs, 0x20001000u);
                region_add(0x20001000u, d, (uint32_t)dneed);
            }
            memcpy(cs, s, sneed);
            memcpy(cd, d, dneed);
            g_ret = 0x1234;
            fn(s, &g_w, &g_host);
            if (m == 9) {
                CK(L.n == 0);
            } else {
                CK(L.n == 1);
                CK(L.c[0].callee == c1 && L.c[0].this_ptr == obj && L.c[0].nargs == 1);
                CK(zext ? L.c[0].a[0] == words[wi] : (L.c[0].a[0] & 0xffff) == words[wi]);
            }
            CK(memcmp(s, cs, sneed) == 0 && memcmp(d, cd, dneed) == 0);
        }
    }
    free(s);
    if (via_ptr) free(d);
    free(k);
    free(cs);
    free(cd);
}

typedef uint32_t (*AllocZeroFn)(uint8_t *, uint32_t, const Fl39cWorld *, const Fl18Host *);
/* cdecl, `ret 8`, args (out, size): p = alloc(size) (0x51dc43, cdecl); dword [out] = p; when p == 0: s1/s2 text trace p0(s2, s1), q(this m, s2), r(s2) only when the debug word is non-zero,
 * then y(this x) whose eax is returned; otherwise `size` bytes at p are zeroed (the host memory behind the original address) and 0 is returned. */
static void check_allocz(AllocZeroFn fn, uint32_t a, uint32_t s1, uint32_t s2, uint32_t p0, uint32_t m, uint32_t q, uint32_t dbg, uint32_t rr, uint32_t x, uint32_t y)
{
    static const uint32_t sizes[] = {1, 3, 4, 5, 7, 8, 0x11, 0x40};
    static const int16_t dbgs[] = {0, 1, 0x100, (int16_t)0x8000};
    size_t i, k;
    (void)dbg;
    for (i = 0; i < 4 + sizeof sizes / sizeof sizes[0] && !g_failed; i++) {
        uint32_t size = i < 4 ? 0x30 + (uint32_t)i : sizes[i - 4];
        int fail = i < 4;
        uint8_t slot[4], *blk = (uint8_t *)malloc(size), *want = (uint8_t *)malloc(size);
        uint32_t ret;
        CK(blk != NULL && want != NULL);
        if (blk == NULL || want == NULL) return;
        setup();
        memset(&g_w, 0, sizeof g_w);
        g_w.word_63a4cd = fail ? dbgs[i] : 0x55;
        memset(blk, 0x6d, size);
        memcpy(want, blk, size);
        memset(slot, 0x99, 4);
        answer(a, fail ? 0 : 0x20004000u);
        answer(y, 0xcafef00du);
        region_add(0x20004000u, blk, size);
        ret = fn(slot, size, &g_w, &g_host);
        CK(L.c[0].callee == a && L.c[0].this_ptr == 0 && L.c[0].nargs == 1 && L.c[0].a[0] == size);
        CK(get32(slot, 0) == (fail ? 0u : 0x20004000u));
        if (fail) {
            int at = 1;
            CK(ret == 0xcafef00du);
            CK(L.c[at].callee == p0 && L.c[at].this_ptr == 0 && L.c[at].nargs == 2 && L.c[at].a[0] == s2 && L.c[at].a[1] == s1);
            at++;
            CK(L.c[at].callee == q && L.c[at].this_ptr == m && L.c[at].nargs == 1 && L.c[at].a[0] == s2);
            at++;
            if (g_w.word_63a4cd != 0) {
                CK(L.c[at].callee == rr && L.c[at].this_ptr == 0 && L.c[at].nargs == 1 && L.c[at].a[0] == s2);
                at++;
            }
            CK(L.c[at].callee == y && L.c[at].this_ptr == x && L.c[at].nargs == 0);
            CK(L.n == at + 1);
        } else {
            CK(ret == 0);
            CK(L.n == 1);
            for (k = 0; k < size; k++) want[k] = 0;
        }
        CK(memcmp(blk, want, size) == 0);
        free(blk);
        free(want);
    }
}

typedef uint32_t (*OutGetFn)(uint8_t *, const Fl18Host *);
static uint32_t g_out_val, g_out_seen;
static int g_out_hits;
/* the callee stores through its first argument: remembers what was there, then writes the scripted value */
static uint32_t out_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    uint32_t r = host_call(ctx, callee, this_ptr, args, nargs);
    if (nargs >= 1 && args[0] != 0) {
        uint8_t *p = (uint8_t *)args[0];
        g_out_seen = get32(p, 0);
        put32(p, 0, g_out_val);
        g_out_hits++;
    }
    return r;
}
/* thiscall: a local dword is cleared, c1(this = self, &local, k) stores a value through the pointer, the function returns the local. */
static void check_outget(OutGetFn fn, uint32_t c1, uint32_t k)
{
    static const uint32_t vals[] = {0, 1, 0x80000000u, 0xdeadbeefu, 0xffffffffu, 0x100};
    uint8_t *s = (uint8_t *)malloc(8), copy[8];
    size_t i;
    CK(s != NULL);
    if (s == NULL) return;
    for (i = 0; i < sizeof vals / sizeof vals[0] && !g_failed; i++) {
        setup();
        g_host.call = out_call;
        g_out_hits = 0;
        g_out_seen = 0xa5a5a5a5u;
        g_out_val = vals[i];
        g_ret = 0xcafef00du;                         /* the callee's own result is not the function's result */
        memset(s, 0x33, 8);
        memcpy(copy, s, 8);
        CK(fn(s, &g_host) == vals[i]);
        CK(L.n == 1 && g_out_hits == 1);
        CK(L.c[0].callee == c1 && L.c[0].this_ptr == (uintptr_t)s && L.c[0].nargs == 2 && L.c[0].a[0] != 0 && L.c[0].a[1] == k);
        CK(g_out_seen == 0);                         /* the local is cleared before the call */
        CK(memcmp(s, copy, 8) == 0);
    }
    free(s);
}

typedef void (*CopyChkFn)(uint8_t *, const uint8_t *, int32_t, const Fl18Host *);
/* thiscall, stack args (src, limit), `ret 8`: copies b bytes from src to [self+off]; when b > limit (signed): p(s2, s1, b, limit) (cdecl), q(this m, s2), y(this x). Exactly sized buffers. */
static void check_copy(CopyChkFn fn, size_t off, size_t b, uint32_t s1, uint32_t s2, uint32_t p0, uint32_t m, uint32_t q, uint32_t x, uint32_t y)
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

typedef uint32_t (*DtorVecFn)(uint8_t *, const Fl18Host *);
/* thiscall: dword [self] = vtbl; c1(this = self); v(self + off, 0x18f, k, cb) (cdecl, four arguments); returns the eax of c2(this = self). The structured-exception frame is not modelled. */
static void check_dtorvec(DtorVecFn fn, uint32_t vtbl, uint32_t c1, uint32_t c2, uint32_t v, uint32_t k, size_t off, uint32_t cb)
{
    size_t need = off + 1, k2, i;
    uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need);
    CK(s != NULL && want != NULL);
    if (s == NULL || want == NULL) return;
    for (k2 = 0; k2 < NRETS && !g_failed; k2++) {
        uint32_t old;
        setup();
        for (i = 0; i < need; i++) s[i] = (uint8_t)(i * 7 + 3);
        old = get32(s, 0);
        memcpy(want, s, need);
        put32(want, 0, vtbl);
        g_ret = RETS[k2];
        CK(fn(s, &g_host) == RETS[k2]);
        CK(L.n == 3 && old != vtbl);
        CK(L.c[0].callee == c1 && L.c[0].this_ptr == (uintptr_t)s && L.c[0].nargs == 0 && L.c[0].first_dword == vtbl);
        CK(L.c[1].callee == v && L.c[1].this_ptr == 0 && L.c[1].nargs == 4 && L.c[1].a[0] == (uintptr_t)(s + off) && L.c[1].a[1] == 0x18f && L.c[1].a[2] == k && L.c[1].a[3] == cb);
        CK(L.c[2].callee == c2 && L.c[2].this_ptr == (uintptr_t)s && L.c[2].nargs == 0 && L.c[2].first_dword == vtbl);
        CK(memcmp(s, want, need) == 0);
    }
    free(s);
    free(want);
}

typedef uint32_t (*StoreFwdFn)(uint8_t *, uint32_t, const Fl18Host *);
/* thiscall, `ret 4`: dword [self+off] = arg, then c1(this = self, arg); returns the eax of c1. Only that dword of the (exactly sized) object changes. */
static void check_storefwd(StoreFwdFn fn, size_t off, uint32_t c1)
{
    static const uint32_t args[] = {0, 1, 0x80000000u, 0xffffffffu, 0xdeadbeefu, 0x10000};
    size_t need = off + 4, i, j;
    uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need);
    CK(s != NULL && want != NULL);
    if (s == NULL || want == NULL) return;
    for (i = 0; i < sizeof args / sizeof args[0] && !g_failed; i++) {
        for (j = 0; j < 2 && !g_failed; j++) {
            setup();
            memset(s, 0x33, need);
            put32(s, off, 0x77777777u);
            memcpy(want, s, need);
            put32(want, off, args[i]);
            g_ret = RETS[i % NRETS];
            CK(fn(s, args[i], &g_host) == RETS[i % NRETS]);
            CK(L.n == 1 && L.c[0].callee == c1 && L.c[0].this_ptr == (uintptr_t)s && L.c[0].nargs == 1 && L.c[0].a[0] == args[i]);
            CK(memcmp(s, want, need) == 0);
        }
    }
    free(s);
    free(want);
}

typedef uint32_t (*Three0Fn)(uint8_t *, const Fl18Host *);
static uint32_t g_seq[3];
static uint32_t seq_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    (void)host_call(ctx, callee, this_ptr, args, nargs);
    return g_seq[L.n - 1 < 3 ? L.n - 1 : 2];
}
/* thiscall: c1(this = self + o1, 0), c1(self + o2, 0), c1(self + o3, 0) in that order; returns the eax of the last. The object is not written. */
static void check_three0(Three0Fn fn, uint32_t c1, size_t o1, size_t o2, size_t o3)
{
    size_t need = o1 > o2 ? o1 : o2, i;
    uint8_t *s, *copy;
    need = (need > o3 ? need : o3) + 4;       /* the test host reads the dword at every `this` that is a host pointer */
    s = (uint8_t *)malloc(need);
    copy = (uint8_t *)malloc(need);
    CK(s != NULL && copy != NULL);
    if (s == NULL || copy == NULL) return;
    for (i = 0; i < 3 && !g_failed; i++) {
        setup();
        g_host.call = seq_call;
        g_seq[0] = 0x11111111u + (uint32_t)i;
        g_seq[1] = 0x80000000u + (uint32_t)i;
        g_seq[2] = i == 0 ? 0 : i == 1 ? 0xffffffffu : 0xcafef00du;
        memset(s, 0x33, need);
        memcpy(copy, s, need);
        CK(fn(s, &g_host) == g_seq[2]);
        CK(L.n == 3);
        CK(L.c[0].callee == c1 && L.c[0].this_ptr == (uintptr_t)(s + o1) && L.c[0].nargs == 1 && L.c[0].a[0] == 0);
        CK(L.c[1].callee == c1 && L.c[1].this_ptr == (uintptr_t)(s + o2) && L.c[1].nargs == 1 && L.c[1].a[0] == 0);
        CK(L.c[2].callee == c1 && L.c[2].this_ptr == (uintptr_t)(s + o3) && L.c[2].nargs == 1 && L.c[2].a[0] == 0);
        CK(memcmp(s, copy, need) == 0);
    }
    free(s);
    free(copy);
}

typedef uint32_t (*FwdWordFn)(uint8_t *, uint16_t, const Fl18Host *);
/* thiscall, `ret 4`: c1(this = self, word pushed from ax with a left-over upper half, k); returns the eax of c1. */
static void check_fwdword(FwdWordFn fn, uint32_t c1, uint32_t k)
{
    static const uint16_t words[] = {0, 1, 0x7fff, 0x8000, 0xffff, 0x1234};
    uint8_t *s = (uint8_t *)malloc(8), copy[8];
    size_t i, j;
    CK(s != NULL);
    if (s == NULL) return;
    for (i = 0; i < sizeof words / sizeof words[0] && !g_failed; i++) {
        for (j = 0; j < NRETS && !g_failed; j++) {
            setup();
            memset(s, 0x33, 8);
            memcpy(copy, s, 8);
            g_ret = RETS[j];
            CK(fn(s, words[i], &g_host) == RETS[j]);
            CK(L.n == 1);
            CK(L.c[0].callee == c1 && L.c[0].this_ptr == (uintptr_t)s && L.c[0].nargs == 2);
            CK((L.c[0].a[0] & 0xffff) == words[i] && L.c[0].a[1] == k);
            CK(memcmp(s, copy, 8) == 0);
        }
    }
    free(s);
}

static void test_m4a3aec_clamp_rect(void)
{
    check_clamp(m4a3aec_clamp_rect, 0x22c, 0x234, 0x832, 0x228, 0x230, 0x830);
}

static void test_m4a7f08_clamp_rect(void)
{
    check_clamp(m4a7f08_clamp_rect, 0xe2a, 0xe32, 0x13a6, 0xe26, 0xe2e, 0x13a4);
}

static void test_m4ada0d_check_bytes(void)
{
    check_cmp(m4ada0d_check_bytes, &g_w.bytes_5511d4, 0x296, 0x2b7, 1, 0xc17, 0x4fb2e3, 0x5c3a67, 1);
}

static void test_m4ada56_check_bytes(void)
{
    check_cmp(m4ada56_check_bytes, &g_w.bytes_5511e0, 0x234, 0x255, 1, 0xc17, 0x4fb2e3, 0x5c3a67, 1);
}

static void test_m4ada9f_check_bytes(void)
{
    check_cmp(m4ada9f_check_bytes, &g_w.bytes_5511ec, 0x265, 0x286, 1, 0xc17, 0x4fb2e3, 0x5c3a67, 1);
}

static void test_m4b3e99_clamp_rect(void)
{
    check_clamp(m4b3e99_clamp_rect, 0x6e0, 0x6e8, 0x722, 0x6dc, 0x6e4, 0x71e);
}

static void test_m4be3d3_check_bytes(void)
{
    check_cmp(m4be3d3_check_bytes, &g_w.bytes_55214c, 0x31c, 0x33d, 0, 0x0, 0x4fb2e3, 0x5c3a67, 0);
}

static void test_m4be410_check_bytes(void)
{
    check_cmp(m4be410_check_bytes, &g_w.bytes_552158, 0x34d, 0x36e, 0, 0x0, 0x4fb2e3, 0x5c3a67, 0);
}

static void test_m4be44d_check_bytes(void)
{
    check_cmp(m4be44d_check_bytes, &g_w.bytes_552164, 0x37e, 0x39f, 0, 0x0, 0x4fb2e3, 0x5c3a67, 0);
}

static void test_m4be48a_check_bytes(void)
{
    check_cmp(m4be48a_check_bytes, &g_w.bytes_552170, 0x3af, 0x3d0, 0, 0x0, 0x4fb2e3, 0x5c3a67, 0);
}

static void test_m4be4c7_check_bytes(void)
{
    check_cmp(m4be4c7_check_bytes, &g_w.bytes_55217c, 0x411, 0x432, 0, 0x0, 0x4fb2e3, 0x5c3a67, 0);
}

static void test_m4be619_alloc_zero(void)
{
    check_allocz(m4be619_alloc_zero, 0x51dc43, 0x552190, 0x63888b, 0x50ca3e, 0x583979, 0x4264e8, 0x63a4cd, 0x44a2b7, 0x5cf659, 0x4c97b4);
}

static void test_m4bf542_alloc_zero(void)
{
    check_allocz(m4bf542_alloc_zero, 0x51dc43, 0x5525ac, 0x63888b, 0x50ca3e, 0x583979, 0x4264e8, 0x63a4cd, 0x44a2b7, 0x5cf659, 0x4c97b4);
}

static void test_m4cb8d5_get_via_out(void)
{
    check_outget(m4cb8d5_get_via_out, 0x4cc70f, 0x18);
}

static void test_m4cb8fa_get_via_out(void)
{
    check_outget(m4cb8fa_get_via_out, 0x4cc70f, 0xd);
}

static void test_m4cb91f_get_via_out(void)
{
    check_outget(m4cb91f_get_via_out, 0x4cc70f, 0x29);
}

static void test_m4cc70f_alloc_zero(void)
{
    check_allocz(m4cc70f_alloc_zero, 0x51dc43, 0x559038, 0x63888b, 0x50ca3e, 0x583979, 0x4264e8, 0x63a4cd, 0x44a2b7, 0x5cf659, 0x4c97b4);
}

static void test_m4d9910_alloc_zero(void)
{
    check_allocz(m4d9910_alloc_zero, 0x51dc43, 0x55aa34, 0x63888b, 0x50ca3e, 0x583979, 0x4264e8, 0x63a4cd, 0x44a2b7, 0x5cf659, 0x4c97b4);
}

static void test_m4de394_copy_block(void)
{
    check_copy(m4de394_copy_block, 0x691, 0x300, 0x55b87c, 0x63888b, 0x50ca3e, 0x583979, 0x4264e8, 0x5cf659, 0x4c97b4);
}

static void test_m4e2d63_destroy_vector(void)
{
    check_dtorvec(m4e2d63_destroy_vector, 0x52e4ecu, 0x4e2faa, 0x4eda7c, 0x50cba8, 26, 0x1ca2, 0x4e1c83);
}

static void test_m4e3525_set_field_forward(void)
{
    check_storefwd(m4e3525_set_field_forward, 0x452c, 0x4edf96);
}

static void test_m4e37bd_call_three_zero(void)
{
    check_three0(m4e37bd_call_three_zero, 0x4e2940, 0x3d5d, 0x3eec, 0x4399);
}

static void test_m4e37f8_call_three_zero(void)
{
    check_three0(m4e37f8_call_three_zero, 0x4e2940, 0x3d5d, 0x3eec, 0x4399);
}

static void test_m4e3833_call_three_zero(void)
{
    check_three0(m4e3833_call_three_zero, 0x4e2940, 0x3d5d, 0x3eec, 0x407b);
}

static void test_m4e7843_copy_block(void)
{
    check_copy(m4e7843_copy_block, 0x691, 0x300, 0x55c4c4, 0x63888b, 0x50ca3e, 0x583979, 0x4264e8, 0x5cf659, 0x4c97b4);
}

static void test_m4e7b37_destroy_vector(void)
{
    check_dtorvec(m4e7b37_destroy_vector, 0x52e4f4u, 0x4e7bf3, 0x4eda7c, 0x50cba8, 6, 0x7654, 0x4e1c83);
}

static void test_m4e7d2e_copy_block(void)
{
    check_copy(m4e7d2e_copy_block, 0x6b20, 0xb2c, 0x55c530, 0x63888b, 0x50ca3e, 0x583979, 0x4264e8, 0x5cf659, 0x4c97b4);
}

static void test_m4e8994_set_field_forward(void)
{
    check_storefwd(m4e8994_set_field_forward, 0x7650, 0x4edf96);
}

static void test_m4eb8fe_destroy_vector(void)
{
    check_dtorvec(m4eb8fe_destroy_vector, 0x52e4f8u, 0x4eba54, 0x4eda7c, 0x50cba8, 2, 0xca8, 0x4e1c83);
}

static void test_m4ebd2e_set_field_forward(void)
{
    check_storefwd(m4ebd2e_set_field_forward, 0xca4, 0x4edf96);
}

static void test_m4fcd4d_forward_word(void)
{
    check_fwdword(m4fcd4d_forward_word, 0x4fccf2, 0);
}

static void test_m4fcd69_forward_word(void)
{
    check_fwdword(m4fcd69_forward_word, 0x4fccf2, 1);
}

static void test_m4fcd85_forward_word(void)
{
    check_fwdword(m4fcd85_forward_word, 0x4fccf2, 2);
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
    RUN(test_m4a3aec_clamp_rect);
    RUN(test_m4a7f08_clamp_rect);
    RUN(test_m4ada0d_check_bytes);
    RUN(test_m4ada56_check_bytes);
    RUN(test_m4ada9f_check_bytes);
    RUN(test_m4b3e99_clamp_rect);
    RUN(test_m4be3d3_check_bytes);
    RUN(test_m4be410_check_bytes);
    RUN(test_m4be44d_check_bytes);
    RUN(test_m4be48a_check_bytes);
    RUN(test_m4be4c7_check_bytes);
    RUN(test_m4be619_alloc_zero);
    RUN(test_m4bf542_alloc_zero);
    RUN(test_m4cb8d5_get_via_out);
    RUN(test_m4cb8fa_get_via_out);
    RUN(test_m4cb91f_get_via_out);
    RUN(test_m4cc70f_alloc_zero);
    RUN(test_m4d9910_alloc_zero);
    RUN(test_m4de394_copy_block);
    RUN(test_m4e2d63_destroy_vector);
    RUN(test_m4e3525_set_field_forward);
    RUN(test_m4e37bd_call_three_zero);
    RUN(test_m4e37f8_call_three_zero);
    RUN(test_m4e3833_call_three_zero);
    RUN(test_m4e7843_copy_block);
    RUN(test_m4e7b37_destroy_vector);
    RUN(test_m4e7d2e_copy_block);
    RUN(test_m4e8994_set_field_forward);
    RUN(test_m4eb8fe_destroy_vector);
    RUN(test_m4ebd2e_set_field_forward);
    RUN(test_m4fcd4d_forward_word);
    RUN(test_m4fcd69_forward_word);
    RUN(test_m4fcd85_forward_word);
    return failures;
}
