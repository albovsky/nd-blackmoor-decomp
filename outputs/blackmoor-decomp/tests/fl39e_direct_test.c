/* FL-39 (batch e) direct tests of the 35 GAME.EXE functions in src/original_methods_fl39e.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl39e_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl39e.h"

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
static Fl39eWorld g_w;

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

typedef void (*StoresFn)(uint8_t *);
typedef struct {
    size_t off;
    int width;
    uint32_t value;
} StoreSpec;
/* thiscall, plain `ret`: a list of immediate stores (word / dword / byte) at fixed offsets of self, in order; nothing else of the exactly sized object changes and nothing is called. */
static void check_stores(StoresFn fn, const StoreSpec *st, size_t n)
{
    static const uint8_t fills[] = {0x33, 0xa5};
    size_t need = 0, i, f;
    uint8_t *s, *want;
    for (i = 0; i < n; i++)
        if (st[i].off + (size_t)st[i].width > need) need = st[i].off + (size_t)st[i].width;
    s = (uint8_t *)malloc(need);
    want = (uint8_t *)malloc(need);
    CK(s != NULL && want != NULL);
    if (s == NULL || want == NULL) return;
    for (f = 0; f < 2 && !g_failed; f++) {
        setup();
        memset(s, fills[f], need);
        memcpy(want, s, need);
        for (i = 0; i < n; i++) {
            if (st[i].width == 1) want[st[i].off] = (uint8_t)st[i].value;
            else if (st[i].width == 2) put16(want, st[i].off, (uint16_t)st[i].value);
            else put32(want, st[i].off, st[i].value);
        }
        fn(s);
        CK(memcmp(s, want, need) == 0);
        CK(L.n == 0);
    }
    free(s);
    free(want);
}

typedef uint32_t (*WordGuardFn)(uint8_t *, const Fl18Host *);
/* thiscall: when the signed word [self+w] != -1, c1(word) (cdecl, one argument pushed from eax, whose upper half is left-over: the callee reads a word); then c2(this = self); the result is the
 * eax of c2. The object is an exactly sized heap block. */
static void check_wordguard(WordGuardFn fn, size_t w, uint32_t c1, uint32_t c2)
{
    static const uint16_t words[] = {0xffff, 0, 0xfffe, 0x7fff, 0x8000, 0x1234, 1};
    size_t need = w + 2, k;
    uint8_t *s = (uint8_t *)malloc(need);
    CK(s != NULL);
    if (s == NULL) return;
    for (k = 0; k < 7 * 4 && !g_failed; k++) {
        const uint16_t word = words[k % 7];
        uint32_t ret;
        setup();
        memset(s, 0x33, need);
        put16(s, w, word);
        g_ret = RETS[k & 3];
        ret = fn(s, &g_host);
        CK(ret == RETS[k & 3]);
        if (word != 0xffff) {
            CK(L.n == 2);
            CK(L.c[0].callee == c1 && L.c[0].this_ptr == 0 && L.c[0].nargs == 1 && (L.c[0].a[0] & 0xffff) == word);
            CK(L.c[1].callee == c2 && L.c[1].this_ptr == (uintptr_t)s && L.c[1].nargs == 0);
        } else {
            CK(L.n == 1);
            CK(L.c[0].callee == c2 && L.c[0].this_ptr == (uintptr_t)s && L.c[0].nargs == 0);
        }
        CK((((uint32_t)s[w] | (uint32_t)s[w + 1] << 8) == word));
    }
    free(s);
}

typedef uint32_t (*RetConstFn)(void);
/* thiscall, plain `ret`: returns the constant k (an address in the image); `this` is not used, nothing is read, written or called. */
static void check_retconst(RetConstFn fn, uint32_t k)
{
    int i;
    for (i = 0; i < 3 && !g_failed; i++) {
        setup();
        CK(fn() == k);
        CK(L.n == 0);
    }
}

typedef void (*IdxFn)(uint8_t *, uint32_t);
/* thiscall, `ret 4`, argument idx: rec = self + idx*m + o; sub = rec + (unsigned byte [rec+b])*s + r; dword [sub+d] = dword [sub+q]. Exactly sized object. */
static void check_idx(IdxFn fn, uint32_t m, uint32_t o, size_t b, uint32_t s_, uint32_t r, size_t d, size_t q)
{
    static const uint32_t idxs[] = {0, 1, 3};
    static const uint8_t bytes[] = {0, 1, 2, 7, 0x80, 0xff};
    size_t i, j, k;
    for (i = 0; i < 3 && !g_failed; i++) {
        for (j = 0; j < 6 && !g_failed; j++) {
            size_t rec = (size_t)idxs[i] * m + o, sub = rec + (size_t)bytes[j] * s_ + r;
            size_t need = sub + (d > q ? d : q) + 4;
            uint8_t *s, *want;
            if (rec + b + 1 > need) need = rec + b + 1;
            s = (uint8_t *)malloc(need);
            want = (uint8_t *)malloc(need);
            CK(s != NULL && want != NULL);
            if (s == NULL || want == NULL) return;
            setup();
            for (k = 0; k < need; k++) s[k] = (uint8_t)(k * 13 + 5);
            s[rec + b] = bytes[j];
            memcpy(want, s, need);
            put32(want, sub + d, get32(s, sub + q));
            fn(s, idxs[i]);
            CK(memcmp(s, want, need) == 0);
            CK(L.n == 0);
            free(s);
            free(want);
        }
    }
}

typedef void (*FillFn)(uint8_t *, uint32_t, uint32_t, int32_t, uint32_t, const Fl18Host *);
/* thiscall, stack arguments (pp, x, y, count, val), `ret 0x14`: p = dword [pp] (an address of the original); count times (signed compare, nothing when count <= 0): byte [p] = val's low byte, p += step;
 * then p += after; dword [pp] = p. `loop_first`: the in-loop step is the first scalar argument x (otherwise y); the other scalar is the final displacement. Exactly sized buffers. */
static void check_fill(FillFn fn, int loop_first)
{
    static const int32_t steps[] = {1, 2, -1, 3, 0, 4, -3};
    static const int32_t afters[] = {0, 7, -3, 0x100, -0x40, 1};
    static const int32_t counts[] = {0, 1, 2, 5, -1, -3, 8, (int32_t)0x80000000u, 3};
    static const uint32_t vals[] = {0x41, 0xffffff7fu, 0x12345680u, 0, 0xab};
    size_t i, k;
    for (i = 0; i < 9 * 7 && !g_failed; i++) {
        const int32_t count = counts[i % 9], step = steps[(i / 9) % 7], after = afters[i % 6];
        const uint32_t val = vals[i % 5], start = 0x20006080u;
        uint8_t *blk = (uint8_t *)malloc(0x100), *want = (uint8_t *)malloc(0x100), *slot = (uint8_t *)malloc(4), wslot[4];
        int32_t n = count > 0 ? count : 0;
        CK(blk != NULL && want != NULL && slot != NULL);
        if (blk == NULL || want == NULL || slot == NULL) return;
        setup();
        for (k = 0; k < 0x100; k++) blk[k] = (uint8_t)(k * 3 + 1);
        memcpy(want, blk, 0x100);
        put32(slot, 0, start);
        for (k = 0; k < (size_t)n; k++) want[0x80 + (int64_t)k * step] = (uint8_t)val;
        put32(wslot, 0, (uint32_t)((int64_t)start + (int64_t)n * step + after));
        region_add(0x20006000u, blk, 0x100);
        fn(slot, loop_first ? (uint32_t)step : (uint32_t)after, loop_first ? (uint32_t)after : (uint32_t)step, count, val, &g_host);
        CK(memcmp(blk, want, 0x100) == 0);
        CK(memcmp(slot, wslot, 4) == 0);
        CK(L.n == 0);
        free(blk);
        free(want);
        free(slot);
    }
}

typedef uint32_t (*Fwd3Fn)(uint8_t *, uint32_t, const uint8_t *, const Fl18Host *);
/* thiscall, stack arguments (a, rec), `ret 8`: c1(this = self, a, dword [rec], dword [rec+4], dword [rec+8]) (four arguments, the first C argument is the one pushed last); returns the eax of c1.
 * The record is an exactly sized heap block of 12 bytes. */
static void check_fwd3(Fwd3Fn fn, uint32_t c1)
{
    static const uint32_t as[] = {0, 1, 0x80000000u, 0xdeadbeefu};
    uint8_t *s = (uint8_t *)malloc(8), *rec = (uint8_t *)malloc(12), copy[8], rcopy[12];
    size_t i, j;
    CK(s != NULL && rec != NULL);
    if (s == NULL || rec == NULL) return;
    for (i = 0; i < 4 && !g_failed; i++) {
        for (j = 0; j < NRETS && !g_failed; j++) {
            setup();
            memset(s, 0x33, 8);
            memcpy(copy, s, 8);
            put32(rec, 0, 0x11111111u * (uint32_t)(i + 1));
            put32(rec, 4, 0x80000001u + (uint32_t)i);
            put32(rec, 8, i ? 0xfffffff0u + (uint32_t)i : 0);
            memcpy(rcopy, rec, 12);
            g_ret = RETS[j];
            CK(fn(s, as[i], rec, &g_host) == RETS[j]);
            CK(L.n == 1);
            CK(L.c[0].callee == c1 && L.c[0].this_ptr == (uintptr_t)s && L.c[0].nargs == 4);
            CK(L.c[0].a[0] == as[i] && L.c[0].a[1] == get32(rcopy, 0) && L.c[0].a[2] == get32(rcopy, 4) && L.c[0].a[3] == get32(rcopy, 8));
            CK(memcmp(s, copy, 8) == 0 && memcmp(rec, rcopy, 12) == 0);
        }
    }
    free(s);
    free(rec);
}

typedef uint32_t (*TwoCallsFn)(uint8_t *, const Fl18Host *);
/* thiscall: c1(this = self, self + off, 1) then c2(this = self, k); returns the eax of c2. The object is not written. */
static void check_twocalls(TwoCallsFn fn, size_t off, uint32_t c1, uint32_t c2, uint32_t k)
{
    size_t need = off + 1, i;
    uint8_t *s = (uint8_t *)malloc(need), *copy = (uint8_t *)malloc(need);
    CK(s != NULL && copy != NULL);
    if (s == NULL || copy == NULL) return;
    for (i = 0; i < NRETS && !g_failed; i++) {
        setup();
        memset(s, 0x33, need);
        memcpy(copy, s, need);
        g_ret = RETS[i];
        CK(fn(s, &g_host) == RETS[i]);
        CK(L.n == 2);
        CK(L.c[0].callee == c1 && L.c[0].this_ptr == (uintptr_t)s && L.c[0].nargs == 2 && L.c[0].a[0] == (uintptr_t)(s + off) && L.c[0].a[1] == 1);
        CK(L.c[1].callee == c2 && L.c[1].this_ptr == (uintptr_t)s && L.c[1].nargs == 1 && L.c[1].a[0] == k);
        CK(memcmp(s, copy, need) == 0);
    }
    free(s);
    free(copy);
}

typedef void (*Gate01Fn)(uint8_t *, const Fl18Host *);
/* thiscall, plain `ret`, no return value: c1(this = self) unless the dword [self+g] is 0 or 1. Exactly sized object, not written. */
static void check_gate01(Gate01Fn fn, size_t g, uint32_t c1)
{
    static const uint32_t gates[] = {0, 1, 2, 0x80000000u, 0xffffffffu, 0x100, 0x101, 0x10000u, 0x10001u};
    size_t need = g + 4, i;
    uint8_t *s = (uint8_t *)malloc(need), copy[0x1000];
    CK(s != NULL && need <= sizeof copy);
    if (s == NULL) return;
    for (i = 0; i < 9 && !g_failed; i++) {
        setup();
        memset(s, 0x33, need);
        put32(s, g, gates[i]);
        memcpy(copy, s, need);
        g_ret = 0x1234;
        fn(s, &g_host);
        if (gates[i] <= 1) {
            CK(L.n == 0);
        } else {
            CK(L.n == 1);
            CK(L.c[0].callee == c1 && L.c[0].this_ptr == (uintptr_t)s && L.c[0].nargs == 0);
        }
        CK(memcmp(s, copy, need) == 0);
    }
    free(s);
}

typedef uint32_t (*DtorSub2Fn)(uint8_t *, const Fl18Host *);
/* thiscall: dword [self] = vtbl; c1(this = self); c2(this = self + o2); returns the eax of c3(this = self + o3), all thiscall with no arguments. The structured-exception frame is not modelled. */
static void check_dtorsub2(DtorSub2Fn fn, uint32_t vtbl, uint32_t c1, uint32_t c2, uint32_t c3, size_t o2, size_t o3)
{
    size_t need = (o2 > o3 ? o2 : o3) + 4, k2, i;
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
        CK(L.c[1].callee == c2 && L.c[1].this_ptr == (uintptr_t)(s + o2) && L.c[1].nargs == 0);
        CK(L.c[2].callee == c3 && L.c[2].this_ptr == (uintptr_t)(s + o3) && L.c[2].nargs == 0);
        CK(memcmp(s, want, need) == 0);
    }
    free(s);
    free(want);
}

typedef void (*StoreSxFn)(uint8_t *, uint32_t);
/* thiscall, `ret 4`: dword [self+off] = the stack argument's low word sign-extended to 32 bits (the upper half of the pushed dword is garbage that must not count). */
static void check_storesx(StoreSxFn fn, size_t off)
{
    static const uint32_t args[] = {0, 1, 0x7fff, 0x8000, 0xffff, 0xfffe, 0x12345678u, 0xffff8000u, 0xabcd7fffu, 0x00018000u};
    size_t need = off + 4, i;
    uint8_t *s = (uint8_t *)malloc(need), *want = (uint8_t *)malloc(need);
    CK(s != NULL && want != NULL);
    if (s == NULL || want == NULL) return;
    for (i = 0; i < sizeof args / sizeof args[0] && !g_failed; i++) {
        setup();
        memset(s, 0x33, need);
        put32(s, off, 0x77777777u);
        memcpy(want, s, need);
        put32(want, off, (uint32_t)(int32_t)(int16_t)(uint16_t)(args[i] & 0xffff));
        fn(s, args[i]);
        CK(memcmp(s, want, need) == 0);
        CK(L.n == 0);
    }
    free(s);
    free(want);
}

typedef void (*GuardCall5Fn)(uint8_t *, const Fl39eWorld *, const Fl18Host *);
/* thiscall: when dword [self+g] != 0: c1(this = obj, [self+g], dword 0x5cf665, self + a2, self + a1, k) (five arguments; the one pushed last, [self+g], is the first). Exactly sized object. */
static void check_guardcall5(GuardCall5Fn fn, size_t g, size_t a1, size_t a2, uint32_t k, uint32_t obj, uint32_t c1, size_t off5)
{
    static const uint32_t gates[] = {0, 1, 0x80000000u, 0x10000u, 0xff000000u, 0};
    size_t need = g + 4, i;
    uint8_t *s, *copy;
    if (a1 + 1 > need) need = a1 + 1;
    if (a2 + 1 > need) need = a2 + 1;
    s = (uint8_t *)malloc(need);
    copy = (uint8_t *)malloc(need);
    CK(s != NULL && copy != NULL);
    if (s == NULL || copy == NULL) return;
    for (i = 0; i < 6 && !g_failed; i++) {
        setup();
        memset(&g_w, 0, sizeof g_w);
        put32((uint8_t *)&g_w, off5, 0xa1b2c3d4u + (uint32_t)i);
        memset(s, 0x33, need);
        put32(s, g, gates[i]);
        if (i == 5) put32(s, g, 0x00000100u);
        memcpy(copy, s, need);
        g_ret = 0x1234;
        fn(s, &g_w, &g_host);
        if (gates[i] == 0 && i != 5) {
            CK(L.n == 0);
        } else {
            CK(L.n == 1);
            CK(L.c[0].callee == c1 && L.c[0].this_ptr == obj && L.c[0].nargs == 5);
            CK(L.c[0].a[0] == get32(copy, g) && L.c[0].a[1] == 0xa1b2c3d4u + (uint32_t)i && L.c[0].a[2] == (uintptr_t)(s + a2) && L.c[0].a[3] == (uintptr_t)(s + a1) && L.c[0].a[4] == k);
        }
        CK(memcmp(s, copy, need) == 0);
    }
    free(s);
    free(copy);
}

typedef void (*StoreGFn)(Fl39eWorld *, uint32_t);
/* thiscall, `ret 4`, no result: the stack argument goes into the dword global at `off` of the world; nothing else of the world changes and nothing is called. */
static void check_storeg(StoreGFn fn, size_t off)
{
    static const uint32_t args[] = {0, 1, 0x80000000u, 0xffffffffu, 0xdeadbeefu, 0x10000, 0x7fffffffu, 0x100};
    uint8_t want[sizeof(Fl39eWorld)];
    size_t i;
    for (i = 0; i < sizeof args / sizeof args[0] && !g_failed; i++) {
        setup();
        memset(&g_w, 0x5a, sizeof g_w);
        memcpy(want, &g_w, sizeof want);
        put32(want, off, args[i]);
        fn(&g_w, args[i]);
        CK(memcmp(&g_w, want, sizeof want) == 0);
        CK(L.n == 0);
    }
}

typedef uint32_t (*FwdFields3Fn)(uint8_t *, const Fl18Host *);
/* thiscall: c1(this = self, [self+a1], [self+a2], [self+a3]) (the first C argument is the one pushed last: [self+a1]); returns the eax of c1. Exactly sized object, not written. */
static void check_fwdfields3(FwdFields3Fn fn, size_t a1, size_t a2, size_t a3, uint32_t c1)
{
    size_t need = a1, i, k;
    uint8_t *s, *copy;
    if (a2 > need) need = a2;
    if (a3 > need) need = a3;
    need += 4;
    s = (uint8_t *)malloc(need);
    copy = (uint8_t *)malloc(need);
    CK(s != NULL && copy != NULL);
    if (s == NULL || copy == NULL) return;
    for (i = 0; i < NRETS && !g_failed; i++) {
        setup();
        for (k = 0; k < need; k++) s[k] = (uint8_t)(k * 29 + 7 + i);
        put32(s, a1, 0x01020304u + (uint32_t)i);
        put32(s, a2, 0x80000000u + (uint32_t)i);
        put32(s, a3, i ? 0xfffffffeu : 0);
        memcpy(copy, s, need);
        g_ret = RETS[i];
        CK(fn(s, &g_host) == RETS[i]);
        CK(L.n == 1);
        CK(L.c[0].callee == c1 && L.c[0].this_ptr == (uintptr_t)s && L.c[0].nargs == 3);
        CK(L.c[0].a[0] == get32(copy, a1) && L.c[0].a[1] == get32(copy, a2) && L.c[0].a[2] == get32(copy, a3));
        CK(memcmp(s, copy, need) == 0);
    }
    free(s);
    free(copy);
}

typedef void (*TraceFn)(const Fl39eWorld *, const Fl18Host *);
/* plain `ret`: when the debug word 0x63a4cd is non-zero p1(s1) (cdecl); r = c1(this = obj) (thiscall); when r == 0 and the debug word is non-zero: t = c2(this = obj); p2(b, s2, t) (cdecl, three
 * arguments, the one pushed last first); p3(b, 0, 0) (callee pops its arguments); p1(b) (cdecl). */
static void check_trace(TraceFn fn, uint32_t obj, uint32_t c1, uint32_t c2, uint32_t p1, uint32_t s1, uint32_t p2, uint32_t s2, uint32_t b, uint32_t p3)
{
    static const int16_t dbgs[] = {0, 1, 0x100, (int16_t)0x8000, -1};
    static const uint32_t r1s[] = {0, 5, 0x80000000u};
    size_t i, j;
    for (i = 0; i < 5 && !g_failed; i++) {
        for (j = 0; j < 3 && !g_failed; j++) {
            const int dbg = dbgs[i] != 0, full = r1s[j] == 0 && dbg;
            int at = 0;
            setup();
            memset(&g_w, 0, sizeof g_w);
            g_w.word_63a4cd = dbgs[i];
            answer(c1, r1s[j]);
            answer(c2, 0xcafef00du);
            fn(&g_w, &g_host);
            if (dbg) {
                CK(L.c[at].callee == p1 && L.c[at].this_ptr == 0 && L.c[at].nargs == 1 && L.c[at].a[0] == s1);
                at++;
            }
            CK(L.c[at].callee == c1 && L.c[at].this_ptr == obj && L.c[at].nargs == 0);
            at++;
            if (full) {
                CK(L.c[at].callee == c2 && L.c[at].this_ptr == obj && L.c[at].nargs == 0);
                at++;
                CK(L.c[at].callee == p2 && L.c[at].this_ptr == 0 && L.c[at].nargs == 3 && L.c[at].a[0] == b && L.c[at].a[1] == s2 && L.c[at].a[2] == 0xcafef00du);
                at++;
                CK(L.c[at].callee == p3 && L.c[at].this_ptr == 0 && L.c[at].nargs == 3 && L.c[at].a[0] == b && L.c[at].a[1] == 0 && L.c[at].a[2] == 0);
                at++;
                CK(L.c[at].callee == p1 && L.c[at].this_ptr == 0 && L.c[at].nargs == 1 && L.c[at].a[0] == b);
                at++;
            }
            CK(L.n == at);
            CK(g_w.word_63a4cd == dbgs[i]);
        }
    }
}

static void test_m487b1a_init_fields5(void)
{
    {
        static const StoreSpec st[] = {{0x1e, 2, 0xffff}, {0x1c, 2, 0xffff}, {0x71, 4, 0x0}, {0x75, 1, 0x0}, {0x70, 1, 0x0}};
        check_stores(m487b1a_init_fields5, st, sizeof st / sizeof st[0]);
    }
}

static void test_m48e2f5_release_word(void)
{
    check_wordguard(m48e2f5_release_word, 0x1c, 0x4d3992, 0x48e28a);
}

static void test_m49c5f0_zero_fields11(void)
{
    {
        static const StoreSpec st[] = {{0xde0, 4, 0x0}, {0xdec, 4, 0x0}, {0xde4, 4, 0x0}, {0xe30, 4, 0x0}, {0xe34, 4, 0x0}, {0xe38, 4, 0x0}, {0xe3c, 4, 0x0}, {0xe40, 4, 0x0}, {0xe44, 4, 0x0}, {0xe48, 4, 0x0}, {0xe18, 4, 0x0}};
        check_stores(m49c5f0_zero_fields11, st, sizeof st / sizeof st[0]);
    }
}

static void test_m4a1b12_get_constant(void)
{
    check_retconst(m4a1b12_get_constant, 0x52dba8u);
}

static void test_m4a1c47_init_fields11(void)
{
    {
        static const StoreSpec st[] = {{0x1e, 2, 0xffff}, {0x1c, 2, 0xffff}, {0x60, 4, 0x0}, {0x4b, 1, 0x0}, {0x58, 1, 0x0}, {0x59, 1, 0x0}, {0x5a, 1, 0x0}, {0x20, 4, 0x0}, {0x24, 4, 0x0}, {0x5b, 4, 0x0}, {0x49, 2, 0xffff}};
        check_stores(m4a1c47_init_fields11, st, sizeof st / sizeof st[0]);
    }
}

static void test_m4a1cb1_release_word(void)
{
    check_wordguard(m4a1cb1_release_word, 0x1c, 0x4d3992, 0x4a1c47);
}

static void test_m4ab3a7_init_fields5(void)
{
    {
        static const StoreSpec st[] = {{0x1e, 2, 0xffff}, {0x1c, 2, 0xffff}, {0x54, 4, 0x0}, {0x58, 1, 0x0}, {0x59, 1, 0x0}};
        check_stores(m4ab3a7_init_fields5, st, sizeof st / sizeof st[0]);
    }
}

static void test_m4ae452_copy_sub_dword(void)
{
    check_idx(m4ae452_copy_sub_dword, 0xc7, 0x6e, 0x26, 0x28, 0x27, 0x8, 0x4);
}

static void test_m4ae495_copy_sub_dword(void)
{
    check_idx(m4ae495_copy_sub_dword, 0xc7, 0x6e, 0x26, 0x28, 0x27, 0x8, 0x0);
}

static void test_m4c87ba_fill_stride(void)
{
    check_fill(m4c87ba_fill_stride, 0);
}

static void test_m4c8872_fill_stride(void)
{
    check_fill(m4c8872_fill_stride, 1);
}

static void test_m4cca42_forward_struct(void)
{
    check_fwd3(m4cca42_forward_struct, 0x4cca0e);
}

static void test_m4cca6f_forward_struct(void)
{
    check_fwd3(m4cca6f_forward_struct, 0x4cca9c);
}

static void test_m4ccd25_get_constant(void)
{
    check_retconst(m4ccd25_get_constant, 0x52e258u);
}

static void test_m4d0b68_log_loop(void)
{
    {
        static const int16_t curs[] = {0, 1, 2, 5, 8, 9, -1, 0x7fff, (int16_t)0x8000};
        size_t ci;
        for (ci = 0; ci < 9 && !g_failed; ci++) {
            int32_t i;
            setup();
            memset(&g_w, 0, sizeof g_w);
            g_w.value_5d2b47 = 0x11111111u;
            g_w.value_5d2a1f = 0x22222222u;
            g_w.value_5cf665 = 0x55555555u;
            g_w.word_5aff57 = curs[ci];
            m4d0b68_log_loop(&g_w, &g_host);
            CK(L.n == 0x9);
            for (i = 0; i < 0x9 && i < MAXCALL && !g_failed; i++) {
                CK(L.c[i].callee == 0x4c5377 && L.c[i].this_ptr == 0x5cf659 && L.c[i].nargs == 5);
                CK(L.c[i].a[1] == 0x55555555u);
                if (i == curs[ci]) {
                    CK(L.c[i].a[0] == 0x11111111u && L.c[i].a[2] == (uint32_t)(i * 16) + 0x5afeb5 && L.c[i].a[3] == (uint32_t)(i * 16) + 0x5afd05 && L.c[i].a[4] == 0x55a098);
                } else {
                    CK(L.c[i].a[0] == 0x22222222u && L.c[i].a[2] == (uint32_t)(i * 16) + 0x5afd05 && L.c[i].a[3] == (uint32_t)(i * 16) + 0x5afd05 && L.c[i].a[4] == 0x55a0bc);
                }
            }
        }
    }
}

static void test_m4d0c57_log_loop(void)
{
    {
        static const int16_t curs[] = {0, 1, 2, 5, 8, 9, -1, 0x7fff, (int16_t)0x8000};
        size_t ci;
        for (ci = 0; ci < 9 && !g_failed; ci++) {
            int32_t i;
            setup();
            memset(&g_w, 0, sizeof g_w);
            g_w.value_5d2d03 = 0x11111111u;
            g_w.value_5d2bdb = 0x22222222u;
            g_w.value_5cf665 = 0x55555555u;
            g_w.word_5b0010 = curs[ci];
            m4d0c57_log_loop(&g_w, &g_host);
            CK(L.n == 0x1);
            for (i = 0; i < 0x1 && i < MAXCALL && !g_failed; i++) {
                CK(L.c[i].callee == 0x4c5377 && L.c[i].this_ptr == 0x5cf659 && L.c[i].nargs == 5);
                CK(L.c[i].a[1] == 0x55555555u);
                if (i == curs[ci]) {
                    CK(L.c[i].a[0] == 0x11111111u && L.c[i].a[2] == (uint32_t)(i * 16) + 0x5afff2 && L.c[i].a[3] == (uint32_t)(i * 16) + 0x5affd2 && L.c[i].a[4] == 0x55a0f8);
                } else {
                    CK(L.c[i].a[0] == 0x22222222u && L.c[i].a[2] == (uint32_t)(i * 16) + 0x5affd2 && L.c[i].a[3] == (uint32_t)(i * 16) + 0x5affd2 && L.c[i].a[4] == 0x55a118);
                }
            }
        }
    }
}

static void test_m4d3728_log_three(void)
{
    {
        static const int16_t words[] = {0, 1, 0x100, (int16_t)0x8000, -1};
        size_t wi;
        for (wi = 0; wi < 5 && !g_failed; wi++) {
            setup();
            memset(&g_w, 0, sizeof g_w);
            g_w.value_5d1963 = 0x11111111u;
            g_w.value_5d03bb = 0x22222222u;
            g_w.value_5d195f = 0x33333333u;
            g_w.value_5d195b = 0x44444444u;
            g_w.value_5d03c7 = 0x66666666u;
            g_w.value_5cf665 = 0x55555555u;
            g_w.word_5b4e8d = words[wi];
            m4d3728_log_three(&g_w, &g_host);
            CK(L.n == (words[wi] != 0 ? 3 : 2));
            CK(L.c[0].callee == 0x4c5377 && L.c[0].this_ptr == 0x5cf659 && L.c[0].nargs == 5);
            CK(L.c[0].a[0] == 0x22222222u && L.c[0].a[1] == 0x55555555u && L.c[0].a[2] == 0x5b4e58 && L.c[0].a[3] == 0x11111111u && L.c[0].a[4] == 0x55a388);
            CK(L.c[1].callee == 0x4c5d4b && L.c[1].this_ptr == 0x5cf659 && L.c[1].nargs == 5);
            CK(L.c[1].a[0] == 0x44444444u && L.c[1].a[1] == 0x55555555u && L.c[1].a[2] == 0x33333333u && L.c[1].a[3] == 0x11111111u && L.c[1].a[4] == 0x55a398);
            if (words[wi] != 0) {
                CK(L.c[2].callee == 0x4c5d4b && L.c[2].this_ptr == 0x5cf659 && L.c[2].nargs == 5);
                CK(L.c[2].a[0] == 0x66666666u && L.c[2].a[1] == 0x55555555u && L.c[2].a[2] == 0x5b4e38 && L.c[2].a[3] == 0x5b4e48 && L.c[2].a[4] == 0x55a3a8);
            }
        }
    }
}

static void test_m4d37af_log_three(void)
{
    {
        static const int16_t words[] = {0, 1, 0x100, (int16_t)0x8000, -1};
        size_t wi;
        for (wi = 0; wi < 5 && !g_failed; wi++) {
            setup();
            memset(&g_w, 0, sizeof g_w);
            g_w.value_5d19ad = 0x11111111u;
            g_w.value_5d03bb = 0x22222222u;
            g_w.value_5d19a9 = 0x33333333u;
            g_w.value_5d19a5 = 0x44444444u;
            g_w.value_5d03cb = 0x66666666u;
            g_w.value_5cf665 = 0x55555555u;
            g_w.word_5b5104 = words[wi];
            m4d37af_log_three(&g_w, &g_host);
            CK(L.n == (words[wi] != 0 ? 3 : 2));
            CK(L.c[0].callee == 0x4c5377 && L.c[0].this_ptr == 0x5cf659 && L.c[0].nargs == 5);
            CK(L.c[0].a[0] == 0x22222222u && L.c[0].a[1] == 0x55555555u && L.c[0].a[2] == 0x5b50cf && L.c[0].a[3] == 0x11111111u && L.c[0].a[4] == 0x55a3c4);
            CK(L.c[1].callee == 0x4c5d4b && L.c[1].this_ptr == 0x5cf659 && L.c[1].nargs == 5);
            CK(L.c[1].a[0] == 0x44444444u && L.c[1].a[1] == 0x55555555u && L.c[1].a[2] == 0x33333333u && L.c[1].a[3] == 0x11111111u && L.c[1].a[4] == 0x55a3d4);
            if (words[wi] != 0) {
                CK(L.c[2].callee == 0x4c5d4b && L.c[2].this_ptr == 0x5cf659 && L.c[2].nargs == 5);
                CK(L.c[2].a[0] == 0x66666666u && L.c[2].a[1] == 0x55555555u && L.c[2].a[2] == 0x5b50af && L.c[2].a[3] == 0x5b50bf && L.c[2].a[4] == 0x55a3e4);
            }
        }
    }
}

static void test_m4de227_call_pair(void)
{
    check_twocalls(m4de227_call_pair, 0x691, 0x4edcb1, 0x4ee6c7, 0);
}

static void test_m4de413_call_unless_01(void)
{
    check_gate01(m4de413_call_unless_01, 0x991, 0x4ee517);
}

static void test_m4de584_call_unless_01(void)
{
    check_gate01(m4de584_call_unless_01, 0x991, 0x4ee86f);
}

static void test_m4de66e_destroy_subobjects(void)
{
    check_dtorsub2(m4de66e_destroy_subobjects, 0x52e4d0u, 0x4de6fc, 0x4ee99f, 0x4e1c83, 0x57e, 0x3ef);
}

static void test_m4e053f_set_field_sx(void)
{
    check_storesx(m4e053f_set_field_sx, 0xf2a);
}

static void test_m4e1113_log_guarded(void)
{
    check_guardcall5(m4e1113_log_guarded, 0x74f, 0x35, 0x25, 0x55be0c, 0x5cf659, 0x4c5377, offsetof(Fl39eWorld, value_5cf665));
}

static void test_m4e1157_log_guarded(void)
{
    check_guardcall5(m4e1157_log_guarded, 0x74f, 0x55, 0x55, 0x55be54, 0x5cf659, 0x4c5377, offsetof(Fl39eWorld, value_5cf665));
}

static void test_m4e7700_call_pair(void)
{
    check_twocalls(m4e7700_call_pair, 0x691, 0x4edcb1, 0x4ee6c7, 1);
}

static void test_m4e7a10_call_unless_01(void)
{
    check_gate01(m4e7a10_call_unless_01, 0x991, 0x4ee86f);
}

static void test_m4eda7c_destroy_subobjects(void)
{
    check_dtorsub2(m4eda7c_destroy_subobjects, 0x52e4fcu, 0x4edb97, 0x4ee99f, 0x4e1c83, 0x4b7, 0x31c);
}

static void test_m4ee5b8_store_global(void)
{
    check_storeg(m4ee5b8_store_global, offsetof(Fl39eWorld, value_55cd94));
}

static void test_m4ee5dd_store_global(void)
{
    check_storeg(m4ee5dd_store_global, offsetof(Fl39eWorld, value_63aa10));
}

static void test_m4ee616_set_field_sx(void)
{
    check_storesx(m4ee616_set_field_sx, 0x4af);
}

static void test_m4f872e_forward_fields(void)
{
    check_fwdfields3(m4f872e_forward_fields, 0x240, 0x244, 0x248, 0x4f861c);
}

static void test_m4f88ad_forward_fields(void)
{
    check_fwdfields3(m4f88ad_forward_fields, 0x24c, 0x250, 0x254, 0x4f875f);
}

static void test_m4fc909_check_trace(void)
{
    check_trace(m4fc909_check_trace, 0x5cf1eb, 0x4f67be, 0x4fa2a8, 0x44a2b7, 0x56095c, 0x50ca3e, 0x560974, 0x63888b, 0x52139c);
}

static void test_m4fc97d_check_trace(void)
{
    check_trace(m4fc97d_check_trace, 0x5cf1eb, 0x4f6810, 0x4fa2a8, 0x44a2b7, 0x560994, 0x50ca3e, 0x5609b0, 0x63888b, 0x52139c);
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
    RUN(test_m487b1a_init_fields5);
    RUN(test_m48e2f5_release_word);
    RUN(test_m49c5f0_zero_fields11);
    RUN(test_m4a1b12_get_constant);
    RUN(test_m4a1c47_init_fields11);
    RUN(test_m4a1cb1_release_word);
    RUN(test_m4ab3a7_init_fields5);
    RUN(test_m4ae452_copy_sub_dword);
    RUN(test_m4ae495_copy_sub_dword);
    RUN(test_m4c87ba_fill_stride);
    RUN(test_m4c8872_fill_stride);
    RUN(test_m4cca42_forward_struct);
    RUN(test_m4cca6f_forward_struct);
    RUN(test_m4ccd25_get_constant);
    RUN(test_m4d0b68_log_loop);
    RUN(test_m4d0c57_log_loop);
    RUN(test_m4d3728_log_three);
    RUN(test_m4d37af_log_three);
    RUN(test_m4de227_call_pair);
    RUN(test_m4de413_call_unless_01);
    RUN(test_m4de584_call_unless_01);
    RUN(test_m4de66e_destroy_subobjects);
    RUN(test_m4e053f_set_field_sx);
    RUN(test_m4e1113_log_guarded);
    RUN(test_m4e1157_log_guarded);
    RUN(test_m4e7700_call_pair);
    RUN(test_m4e7a10_call_unless_01);
    RUN(test_m4eda7c_destroy_subobjects);
    RUN(test_m4ee5b8_store_global);
    RUN(test_m4ee5dd_store_global);
    RUN(test_m4ee616_set_field_sx);
    RUN(test_m4f872e_forward_fields);
    RUN(test_m4f88ad_forward_fields);
    RUN(test_m4fc909_check_trace);
    RUN(test_m4fc97d_check_trace);
    return failures;
}
