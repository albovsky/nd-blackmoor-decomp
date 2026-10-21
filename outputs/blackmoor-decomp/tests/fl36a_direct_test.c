/* FL-36 (batch a) direct tests of the methods of GAME.EXE in src/original_methods_fl36a.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl36a_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl36a.h"

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
static Fl36aWorld g_w;
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
        uint8_t loc[0x24];       /* the 0x24 bytes behind a host pointer in argument 2 of 0x50ca3e (the frame area of 0x4f379c), at the call */
        uint32_t state3be;       /* dword [self+0x3be] at the call */
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
        memset(L.c[i].loc, 0, sizeof L.c[i].loc);
        L.c[i].state3be = get32(g_r[0], 0x3be);
        if (callee == 0x50ca3e && nargs > 2 && args[2] > 0xffffffffu) memcpy(L.c[i].loc, (const void *)args[2], sizeof L.c[i].loc);
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

/* ---- 0x4f379c ------------------------------------------------------------------------------------------------------------------ */
/* layout: self = region 0 (the dword [self+0x3ce] points at the record array: entry = [self+0x3ce] + id * 0x5bb); the entry of id 2 is at EN_VA = RVA(1) + 0x10 (unaligned fields allowed); the 4 byte magic at
 * 0x55dab4 and the string at 0x55dafc live in the image area g_img. */
#define EN_ID 2u
#define EN_VA (RVA(1) + 0x10)
#define EN (g_r[1] + 0x10)
#define FP 0x1234abcdu
static void en_setup(void)
{
    setup();
    set32(SELF, 0x3ce, EN_VA - EN_ID * 0x5bb);
    set32(SELF, 0x446, 0x1111);
    set32(SELF, 0x44a, 0x2222);
    set32(SELF, 0x466, 0x3333);
    set32(SELF, 0x46a, 0x4444);
    memcpy(g_img + (0x55dab4 - IMG_BASE), "HIS\0", 4);
    memcpy(g_img + (0x55dafc - IMG_BASE), " compressed", 12);
    memset(EN, 0xcd, 0x5bb);
    memcpy(EN + 0x10a, "HIS\0", 4);
    set16(EN, 0x10e, 2);
    set16(EN, 0x110, 0);
    set32(EN, 0x162, 0);
    set32(EN, 0x166, 0x77);
    set32(EN, 0x122, 0x1000);
    set16(EN, 0x126, 3);
    set32(EN, 0x1aa, 0); set32(EN, 0x1ae, 0);
    set32(EN, 0x1b2, 9); set32(EN, 0x1b6, 3);
    set32(EN, 0x1ba, 1); set32(EN, 0x1be, 2);
    set32(EN, 0x1c2, 0xffffffffu); set32(EN, 0x1c6, 5);
    set32(EN, 0x1d6, 1); set32(EN, 0x1da, 2);
    g_w.word_63aa14 = 0x5a5a;
    g_w.word_63a4cd = 0;
    script(0x50d0a9, FP);
    script(0x50cf61, 1);
    script(0x4f3c26, 1);
    script(0x4f438f, 1);
}
static int en_call(uint32_t id, uint32_t *result)
{
    return m4f379c_open_entry(SELF, id, result, &g_w, &g_host);
}
static void test_m4f379c_open_entry(void)
{
    uint32_t r = 0xdeadu;
    int k;
    /* the plain path: header ok, size <= 0x56220, debug off */
    en_setup();
    CK(en_call(0x10000u | EN_ID, &r) == 0 && r == 1);               /* only the low 16 bits of the id count */
    CK(L.n == 3);
    CKC(0, 0x50d0a9, 0, 2, EN_VA + 4, 0x55dab0);
    CKC(1, 0x50cf61, 0, 4, EN_VA + 0x10a, 0x1e, 1, FP);
    CKC(2, 0x4f3c26, SELFV, 1, EN_ID);
    CK(get32(SELF, 0x3be) == 1 && get32(SELF, 0x3c2) == 0x3e8);
    CK(get32(EN, 0x162) == 1 && get32(EN, 0x152) == 0 && get32(EN, 0x156) == FP && get32(EN, 0x166) == 0 && get32(EN, 0x15e) == 0x1000);
    CK(get32(EN, 0x1aa) == 0x1111 && get32(EN, 0x1ae) == 0x2222);
    CK(get32(EN, 0x1b2) == 3 && get32(EN, 0x1b6) == 9 && get32(EN, 0x1ba) == 1 && get32(EN, 0x1be) == 2);
    CK(get32(EN, 0x1c2) == 0xffffffffu && get32(EN, 0x1c6) == 5);       /* -1 < 5: no swap (a compare of unsigned values would swap) */
    CK(get32(EN, 0x1d6) == 0x3333 && get32(EN, 0x1da) == 2);
    CK(get32(EN, 0x287) == 0 && get32(EN, 0x19e) == 0 && get32(EN, 0x28b) == 0);
    /* [entry+0x162] != 0: 0x4f356e first */
    en_setup(); set32(EN, 0x162, 0x100);
    CK(en_call(EN_ID, &r) == 0 && r == 1 && L.n == 4);
    CKC(0, 0x4f356e, SELFV, 1, EN_ID);
    CKC(1, 0x50d0a9, 0, 2, EN_VA + 4, 0x55dab0);
    /* open fails */
    en_setup(); S[0].results[0] = 0;
    CK(en_call(EN_ID, &r) == 0 && r == 0 && L.n == 1 && get32(SELF, 0x3c2) == 0x3ed && get32(SELF, 0x3be) == 0 && get32(EN, 0x156) == 0 && get32(EN, 0x162) == 0);
    /* read fails */
    en_setup(); S[1].results[0] = 0;
    CK(en_call(EN_ID, &r) == 0 && r == 0 && L.n == 2 && get32(SELF, 0x3c2) == 0x3ec && get32(SELF, 0x3be) == 0 && get32(EN, 0x162) == 0);
    /* header: each of the four checks */
    for (k = 0; k < 4; k++) {
        en_setup();
        if (k < 2) EN[0x10a + (k ? 3 : 0)] ^= 1;
        else if (k == 2) set16(EN, 0x10e, 3);
        else set16(EN, 0x110, 0x100);
        CK(en_call(EN_ID, &r) == 0 && r == 0 && L.n == 3 && get32(SELF, 0x3c2) == 0x3f9 && get32(SELF, 0x3be) == 0 && get32(EN, 0x162) == 0);
        CKC(2, 0x4f356e, SELFV, 1, EN_ID);
    }
    en_setup(); set16(EN, 0x10e, 0xfffe);         /* signed word -2 != 2 */
    CK(en_call(EN_ID, &r) == 0 && r == 0 && get32(SELF, 0x3c2) == 0x3f9);
    /* the range pair: kept only when (p != 0 || q != 0) and q - p > 0 (signed, 32-bit) */
    {
        static const uint32_t pq[][3] = {{0, 0, 0}, {0, 5, 1}, {0, 0xfffffffbu, 0}, {3, 10, 1}, {10, 3, 0}, {5, 0, 0}, {7, 7, 0}, {0x7fffffffu, 0x80000000u, 1}, {0x80000000u, 1, 0}, {1, 1, 0}};
        for (k = 0; k < 10 && !g_failed; k++) {
            en_setup(); set32(EN, 0x1aa, pq[k][0]); set32(EN, 0x1ae, pq[k][1]);
            CK(en_call(EN_ID, &r) == 0);
            if (pq[k][2]) CK(get32(EN, 0x1aa) == pq[k][0] && get32(EN, 0x1ae) == pq[k][1]);
            else CK(get32(EN, 0x1aa) == 0x1111 && get32(EN, 0x1ae) == 0x2222);
        }
    }
    /* the three swaps and the two small words (signed compares) */
    en_setup(); set32(EN, 0x1ba, 0x80000000u); set32(EN, 0x1be, 0x7fffffffu); set32(EN, 0x1c2, 5); set32(EN, 0x1c6, 5); set32(EN, 0x1d6, 2); set32(EN, 0x1da, 0xffffffffu);
    CK(en_call(EN_ID, &r) == 0);
    CK(get32(EN, 0x1ba) == 0x80000000u && get32(EN, 0x1be) == 0x7fffffffu);   /* INT_MIN < INT_MAX: no swap */
    CK(get32(EN, 0x1c2) == 5 && get32(EN, 0x1c6) == 5);
    CK(get32(EN, 0x1d6) == 2 && get32(EN, 0x1da) == 0x4444);              /* -1 <= 1: replaced */
    en_setup(); set32(EN, 0x1ba, 7); set32(EN, 0x1be, 0xffffffffu); set32(EN, 0x1c2, 0x7fffffffu); set32(EN, 0x1c6, 0x80000000u);
    CK(en_call(EN_ID, &r) == 0);
    CK(get32(EN, 0x1ba) == 0xffffffffu && get32(EN, 0x1be) == 7);          /* 7 > -1: swapped */
    CK(get32(EN, 0x1c2) == 0x80000000u && get32(EN, 0x1c6) == 0x7fffffffu);
    /* size < 0: with the debug word on the three calls, then 0; off: nothing; [entry+0x166] is not touched, no 0x4f3c26 / 0x4f438f */
    en_setup(); set32(EN, 0x122, 0x80000000u); g_w.word_63a4cd = 0x100;
    CK(en_call(EN_ID, &r) == 0 && r == 0 && L.n == 5);
    CKC(2, 0x4f356e, SELFV, 1, EN_ID);
    CKC(3, 0x50ca3e, 0, 3, 0x63888b, 0x55dab8, EN_VA + 4);
    CKC(4, 0x52139c, 0, 3, 0x63888b, 0, 0);
    CK(get32(EN, 0x166) == 0x77 && get32(EN, 0x15e) == 0x80000000u && get32(SELF, 0x3be) == 1);
    en_setup(); set32(EN, 0x122, 0xffffffffu);
    CK(en_call(EN_ID, &r) == 0 && r == 0 && L.n == 2);
    /* size > 0x56220: [+0x166] = 1, the five-argument report with the frame area (word 0x63aa14 + zeros, or the string 0x55dafc), then 0x4f438f */
    en_setup(); set32(EN, 0x122, 0x56221); g_w.word_63a4cd = 1;
    CK(en_call(EN_ID, &r) == 0 && r == 1 && L.n == 5 && get32(EN, 0x166) == 1);
    CKC(2, 0x50ca3e, 0, 5, 0x63888b, 0x55db08, L.c[2].a[2], EN_ID, EN_VA + 4);
    CK(L.c[2].a[2] > 0xffffffffu);
    CK(get16(L.c[2].loc, 0) == 0x5a5a);
    for (k = 2; k < 0x24; k++) CK(L.c[2].loc[k] == 0);
    CKC(3, 0x44a2b7, 0, 1, 0x63888b);
    CKC(4, 0x4f438f, SELFV, 1, EN_ID);
    en_setup(); set32(EN, 0x122, 0x56221); set16(EN, 0x126, 2); g_w.word_63a4cd = 1;
    CK(en_call(EN_ID, &r) == 0 && r == 1 && L.n == 5);
    CK(memcmp(L.c[2].loc, " compressed\0", 12) == 0);
    for (k = 12; k < 0x24; k++) CK(L.c[2].loc[k] == 0);
    en_setup(); set32(EN, 0x122, 0x56221); S[3].results[0] = 0;          /* 0x4f438f returns 0: result 0 although [self+0x3be] is 1 */
    CK(en_call(EN_ID, &r) == 0 && r == 0 && get32(SELF, 0x3be) == 1);
    /* size == 0x56220 and below: [+0x166] = 0, the four-argument report, then 0x4f3c26; its failure returns 0 */
    en_setup(); set32(EN, 0x122, 0x56220); g_w.word_63a4cd = (int16_t)0x8000;
    CK(en_call(EN_ID, &r) == 0 && r == 1 && L.n == 5 && get32(EN, 0x166) == 0);
    CKC(2, 0x50ca3e, 0, 4, 0x63888b, 0x55db40, EN_ID, EN_VA + 4);
    CKC(3, 0x44a2b7, 0, 1, 0x63888b);
    CKC(4, 0x4f3c26, SELFV, 1, EN_ID);
    en_setup(); S[2].results[0] = 0;
    CK(en_call(EN_ID, &r) == 0 && r == 0);
    /* a string of 0x24 bytes with its NUL fits the frame (the original overwrites its temporary), 0x25 does not: status 1 right after the effects before the copy */
    en_setup(); set32(EN, 0x122, 0x56221); set16(EN, 0x126, 2); g_w.word_63a4cd = 1;
    memset(g_img + (0x55dafc - IMG_BASE), 'x', 35); g_img[0x55dafc - IMG_BASE + 35] = 0;
    CK(en_call(EN_ID, &r) == 0 && L.n == 5 && memcmp(L.c[2].loc, g_img + (0x55dafc - IMG_BASE), 36) == 0);
    en_setup(); set32(EN, 0x122, 0x56221); set16(EN, 0x126, 2); g_w.word_63a4cd = 1;
    memset(g_img + (0x55dafc - IMG_BASE), 'x', 36); g_img[0x55dafc - IMG_BASE + 36] = 0;
    r = 0xdeadu;
    CK(en_call(EN_ID, &r) == 1 && r == 0xdeadu && L.n == 2 && get32(EN, 0x166) == 0x77 && get32(EN, 0x162) == 1);
}


/* TESTS-END */

/* ---- bounded sweep ------------------------------------------------------------------------------------------------------------- */
static void test_sweep_bounded(void)
{
    unsigned seed = 4242;
    int n, i;
    for (n = 0; n < 300 && !g_failed; n++) {
        uint32_t r = 0;
        setup();
        seed = seed * 1103515245u + 12345u;
        /* 0x4f379c: random entry bytes with a valid magic / string and a pointer from the record table */
        en_setup();
        for (i = 0; i < 0x5bb; i++) {
            seed = seed * 1103515245u + 12345u;
            if ((seed >> 20) & 1) EN[i] = (uint8_t)(seed >> 16);
        }
        memcpy(EN + 0x10a, "HIS\0", 4);
        set16(EN, 0x10e, seed & 7 ? 2 : (uint16_t)(seed >> 8));
        set16(EN, 0x110, seed & 15 ? 0 : (uint16_t)(seed >> 9));
        set32(EN, 0x122, seed);
        set16(EN, 0x126, (uint16_t)(2 + (seed >> 5 & 1)));
        set32(EN, 0x162, seed >> 3 & 1);
        g_w.word_63a4cd = (int16_t)(seed >> 6 & 1);
        S[0].results[0] = seed >> 7 & 3 ? FP : 0;
        S[1].results[0] = seed >> 9 & 3 ? 1 : 0;
        S[2].results[0] = seed >> 11 & 1;
        S[3].results[0] = seed >> 12 & 1;
        set32(SELF, 0x3ce, EN_VA - (uint32_t)(seed & 0xffffu) * 0x5bbu);
        en_call((uint32_t)seed, &r);
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
    RUN(test_m4f379c_open_entry);
    /* RUN-END */
    RUN(test_sweep_bounded);
    return failures;
}
