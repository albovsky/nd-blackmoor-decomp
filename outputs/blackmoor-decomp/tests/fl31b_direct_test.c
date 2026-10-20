/* FL-31 (batch b) direct tests of the nine small methods of GAME.EXE in src/original_methods_fl31b.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the
 * failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running the native code;
 * tests/test_fl31b_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl31b.h"

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
static uint8_t g_dwords[128];
static Fl31bWorld g_w;
static Fl18Host g_host;
#define SELF g_r[0]

static void set32(uint8_t *b, size_t off, uint32_t v) { memcpy(b + off, &v, 4); }
static void set16(uint8_t *b, size_t off, uint16_t v) { memcpy(b + off, &v, 2); }
static uint32_t get32(const uint8_t *b, size_t off) { uint32_t v; memcpy(&v, b + off, 4); return v; }
static uint16_t get16(const uint8_t *b, size_t off) { uint16_t v; memcpy(&v, b + off, 2); return v; }

#define MAXCALL 64
static const uint8_t *g_watch;                  /* two bytes that every logged call keeps a copy of (the state at the call) */
static uint32_t g_cursor_x, g_cursor_y;         /* what the import in slot 0x52a484 stores through its pointer argument */
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[6];
        uint8_t watch[2];
        uint8_t flags[2];        /* byte_58321d, byte_58321e at the call */
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
        if (g_watch != NULL) memcpy(L.c[i].watch, g_watch, 2);
        L.c[i].flags[0] = g_w.byte_58321d;
        L.c[i].flags[1] = g_w.byte_58321e;
    }
    L.n++;
    if (callee == 0x52a484 && nargs == 1) {      /* GetCursorPos: stores the pair through the pointer (a local of the function) */
        uint32_t pair[2];
        pair[0] = g_cursor_x;
        pair[1] = g_cursor_y;
        memcpy((void *)args[0], pair, 8);
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
    memset(g_dwords, 0, sizeof g_dwords);
    memset(&g_w, 0, sizeof g_w);
    g_w.table_5d02cb = g_dwords + 64;               /* index 0 in the middle: slack for negative indices */
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    L.n = 0;
    g_nscript = 0;
    g_watch = NULL;
    g_cursor_x = g_cursor_y = 0;
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

/* ---- 0x4c946b ------------------------------------------------------------------------------------------------------------------ */
static void test_m4c946b_call_slot(void)
{
    setup();
    m4c946b_call_slot(SELF, 0, &g_host);
    CK(L.n == 1);
    CKC(0, 0x4c2dfb, SELFP, 1, SELFP + 0xc72);                                   /* ecx = self, the argument is the slot address self + 0xc72 + 4 * index */
    L.n = 0;
    m4c946b_call_slot(SELF, 0xabcd0005u, &g_host);                               /* the upper half of the stack dword is garbage */
    CKC(0, 0x4c2dfb, SELFP, 1, SELFP + 0xc72 + 20);
    L.n = 0;
    m4c946b_call_slot(SELF, 0x1234fffdu, &g_host);                               /* word -3 */
    CKC(0, 0x4c2dfb, SELFP, 1, SELFP + 0xc72 - 12);
    L.n = 0;
    m4c946b_call_slot(SELF, 0xffffu, &g_host);                                   /* -1, not 0xffff */
    CKC(0, 0x4c2dfb, SELFP, 1, SELFP + 0xc72 - 4);
    L.n = 0;
    m4c946b_call_slot(SELF, 0x8000u, &g_host);                                   /* -0x8000 (address arithmetic only: nothing is read) */
    CKC(0, 0x4c2dfb, SELFP, 1, SELFP + 0xc72 - 0x20000u);
    CK(L.n == 1);
}

/* ---- 0x4ee673 ------------------------------------------------------------------------------------------------------------------ */
static void test_m4ee673_forward_if_set(void)
{
    setup();
    set32(SELF, 0x24e, 0xffffffffu);
    set32(SELF, 0x252, 0);
    set32(SELF, 0x256, 0xffffffffu);
    m4ee673_forward_if_set(SELF, 0x1234, &g_host);
    CK(L.n == 0);                                                                /* only the dword at +0x252 counts */
    set32(SELF, 0x252, 1);
    m4ee673_forward_if_set(SELF, 0xfedcba98u, &g_host);
    CK(L.n == 1);
    CKC(0, 0x4ef4f0, SELFP + 0x4b7, 1, 0xfedcba98u);
    L.n = 0;
    set32(SELF, 0x252, 0x10000);                                                 /* non-zero with a zero low word */
    m4ee673_forward_if_set(SELF, 7, &g_host);
    CK(L.n == 1);
    L.n = 0;
    set32(SELF, 0x252, 0x80000000u);
    m4ee673_forward_if_set(SELF, 7, &g_host);
    CK(L.n == 1);
    L.n = 0;
    set32(SELF, 0x252, 0x00010000u);
    set16(SELF, 0x252, 0);
    m4ee673_forward_if_set(SELF, 7, &g_host);
    CK(L.n == 1);                                                                /* the high word alone */
}

/* ---- 0x4daeb5 ------------------------------------------------------------------------------------------------------------------ */
static void test_m4daeb5_read_cursor(void)
{
    uint32_t r;
    setup();
    g_cursor_x = 0x11223344u;
    g_cursor_y = 0x80000001u;
    r = m4daeb5_read_cursor(SELF, RVA(1) + 8, &g_host);
    CK(r == RVA(1) + 8);                                                         /* returns the pointer argument */
    CK(L.n == 1 && L.c[0].callee == 0x52a484 && L.c[0].nargs == 1 && L.c[0].this_ptr == 0 && L.c[0].a[0] > 0xffffffffu);      /* a host pointer to the local pair */
    CK(get32(SELF, 0x18) == 0x11223344u && get32(SELF, 0x1c) == 0x80000001u);
    CK(get32(g_r[1], 8) == 0x11223344u && get32(g_r[1], 12) == 0x80000001u);
    CK(g_r[1][7] == (uint8_t)(7 * 7 + 3 + 1) && g_r[1][16] == (uint8_t)(16 * 7 + 3 + 1));      /* nothing around the pair */
    CK(SELF[0x17] == (uint8_t)(0x17 * 7 + 3) && SELF[0x20] == (uint8_t)(0x20 * 7 + 3));
    /* the pair lands inside self: the stores into self come first, the pair over them (x at +0x1a, y at +0x1e) */
    setup();
    g_cursor_x = 0xaabbccddu;
    g_cursor_y = 0x01020304u;
    r = m4daeb5_read_cursor(SELF, RVA(0) + 0x1a, &g_host);
    CK(r == RVA(0) + 0x1a);
    CK(get16(SELF, 0x18) == 0xccddu && get32(SELF, 0x1a) == 0xaabbccddu && get32(SELF, 0x1e) == 0x01020304u);
    CK(SELF[0x22] == (uint8_t)(0x22 * 7 + 3));
    setup();            /* the pair lands at +0x14: x over +0x14..+0x17, y over +0x18..+0x1b, then no later store into self */
    g_cursor_x = 0x0badf00du;
    g_cursor_y = 0xdeadbeefu;
    m4daeb5_read_cursor(SELF, RVA(0) + 0x14, &g_host);
    CK(get32(SELF, 0x14) == 0x0badf00du && get32(SELF, 0x18) == 0xdeadbeefu && get32(SELF, 0x1c) == 0xdeadbeefu);
}

/* ---- 0x4dadff ------------------------------------------------------------------------------------------------------------------ */
static void keys(uint32_t r1, uint32_t r2, int want1, int want2)
{
    setup();
    set32(SELF, 0x20, 0x11111111u);
    set32(SELF, 0x24, 0x22222222u);
    g_w.byte_58321d = 0x55;
    g_w.byte_58321e = 0xaa;
    script(0x52a4b4, 2, r1, r2, 0, 0);
    m4dadff_poll_keys(SELF, &g_w, &g_host);
    CK(L.n == 2);
    CKC(0, 0x52a4b4, 0, 1, 0x11111111u);
    CKC(1, 0x52a4b4, 0, 1, 0x22222222u);
    CK(L.c[0].flags[0] == 0x55 && L.c[0].flags[1] == 0xaa);                       /* nothing is stored before the first call */
    CK(L.c[1].flags[0] == want1 && L.c[1].flags[1] == 0xaa);                      /* the first store is done before the second call */
    CK(g_w.byte_58321d == want1 && g_w.byte_58321e == want2);
}
static void test_m4dadff_poll_keys(void)
{
    keys(0x8000, 0, 1, 0);
    keys(0, 0x8000, 0, 1);
    keys(0x7fff, 0xffff, 0, 1);
    keys(0x18000, 0x10000, 1, 0);                  /* only bit 15 of ax counts: the upper half of eax is ignored */
    keys(0xffff8000u, 0x8001, 1, 1);
    keys(0x00018001u, 0x4000, 1, 0);
    keys(0, 0, 0, 0);
    keys(0xffffffffu, 0xffffffffu, 1, 1);
}

/* ---- 0x420b9e ------------------------------------------------------------------------------------------------------------------ */
static void test_m420b9e_report_name(void)
{
    setup();
    set32(g_dwords, 64 - 8, 0x11000001u);                                           /* table[-2] */
    set32(g_dwords, 64 - 4, 0x22000002u);                                           /* table[-1] */
    set32(g_dwords, 64 + 12, 0x33000003u);                                          /* table[3] */
    set32(g_dwords, 64 + 16, 0x44000004u);                                          /* table[4] */
    set16(SELF, 0xf73, 0xfffe);                                                    /* -2 */
    set16(SELF, 0xf75, 3);
    g_w.dword_5d03af = 0xcafe0001u;
    g_w.dword_5b15da = 0x10000;                                                    /* non-zero: the word at +0xf75 and the string 0x543b60 */
    m420b9e_report_name(SELF, &g_w, &g_host);
    CK(L.n == 1);
    CKC(0, 0x4c51a5, 0x5cf659, 5, 0x33000003u, 0xcafe0001u, 0x5b15de, 0x5b15de, 0x543b60);
    L.n = 0;
    g_w.dword_5b15da = 0;                                                          /* zero: the word at +0xf73 (sign-extended) and the string 0x543b88 */
    m420b9e_report_name(SELF, &g_w, &g_host);
    CKC(0, 0x4c51a5, 0x5cf659, 5, 0x11000001u, 0xcafe0001u, 0x5b15de, 0x5b15de, 0x543b88);
    L.n = 0;
    set16(SELF, 0xf73, 0xffff);
    g_w.dword_5b15da = 0;
    m420b9e_report_name(SELF, &g_w, &g_host);
    CKC(0, 0x4c51a5, 0x5cf659, 5, 0x22000002u, 0xcafe0001u, 0x5b15de, 0x5b15de, 0x543b88);        /* -1, not 0xffff */
    L.n = 0;
    set16(SELF, 0xf75, 4);
    g_w.dword_5b15da = 0x80000000u;
    m420b9e_report_name(SELF, &g_w, &g_host);
    CKC(0, 0x4c51a5, 0x5cf659, 5, 0x44000004u, 0xcafe0001u, 0x5b15de, 0x5b15de, 0x543b60);
    CK(L.n == 1);
}

/* ---- 0x47d1c3 ------------------------------------------------------------------------------------------------------------------ */
static void alloc_case(uint32_t size, uint32_t off)
{
    size_t i;
    setup();
    memset(g_r[2], 0x5a, 0x100);
    set32(g_r[1], 8, 0x77777777u);
    script(0x51dc43, 1, RVA(2) + off, 0, 0, 0);
    m47d1c3_alloc_zeroed(RVA(1) + 8, size, &g_w, &g_host);
    CK(L.n == 1);
    CKC(0, 0x51dc43, 0, 1, size);
    CK(get32(g_r[1], 8) == RVA(2) + off);                                           /* the result is stored first */
    for (i = 0; i < 0x100 && !g_failed; i++) CK(g_r[2][i] == ((i >= off && i < off + size) ? 0 : 0x5a));      /* exactly `size` bytes: dwords, then the tail bytes */
}
static void null_case(int dbg)
{
    setup();
    g_w.word_63a4cd = (int16_t)dbg;
    set32(g_r[1], 8, 0x77777777u);
    memset(g_r[2], 0x5a, 0x100);
    script(0x51dc43, 1, 0, 0, 0, 0);
    m47d1c3_alloc_zeroed(RVA(1) + 8, 0x20, &g_w, &g_host);
    CK(get32(g_r[1], 8) == 0);
    CKC(0, 0x51dc43, 0, 1, 0x20);
    CKC(1, 0x50ca3e, 0, 2, 0x63888b, 0x54d168);
    CKC(2, 0x4264e8, 0x583979, 1, 0x63888b);
    if (dbg != 0) {
        CKC(3, 0x44a2b7, 0, 1, 0x63888b);
        CKC0(4, 0x4c97b4, 0x5cf659);
        CK(L.n == 5);
    } else {
        CKC0(3, 0x4c97b4, 0x5cf659);
        CK(L.n == 4);
    }
    CK(g_r[2][0] == 0x5a && g_r[2][0x1f] == 0x5a);                                  /* nothing is cleared */
}
static void test_m47d1c3_alloc_zeroed(void)
{
    alloc_case(0, 0);
    alloc_case(1, 0);
    alloc_case(3, 1);
    alloc_case(4, 3);
    alloc_case(5, 0);
    alloc_case(7, 1);
    alloc_case(8, 0x20);
    alloc_case(0x41, 1);
    null_case(0);
    null_case(1);
    null_case(0x8000);
    null_case(0xffff);
}

/* ---- 0x4fc878 ------------------------------------------------------------------------------------------------------------------ */
static void rec_case(uint32_t arg, uint32_t word_dword, int dbg, int hit)
{
    uint32_t i = arg & 0xffff;
    size_t off = (size_t)i * 0x5bb + 0x132;
    int k;
    setup();
    for (k = 0; k < 8; k++) set16(SELF, (size_t)k * 0x5bb + 0x132, 1);             /* every other record is in state 1 as well */
    set32(SELF, off, word_dword);
    g_w.word_63a4cd = (int16_t)dbg;
    g_watch = SELF + off;
    m4fc878_activate_record(SELF, arg, &g_w, &g_host);
    k = 0;
    if (dbg) {
        CKC(k, 0x50ca3e, 0, 3, 0x63888b, 0x560940, i);
        CKC(k + 1, 0x44a2b7, 0, 1, 0x63888b);
        k += 2;
    }
    if (hit) {
        CKC(k, 0x4f61e7, 0x5cf1eb, 1, i);
        CK(L.c[k].watch[0] == 1 && L.c[k].watch[1] == 0);                           /* the state word is still 1 at the call */
        k++;
        CK(get16(SELF, off) == 2 && get16(SELF, off + 2) == (uint16_t)(word_dword >> 16));
    } else {
        CK(get32(SELF, off) == word_dword);
    }
    CK(L.n == k);
    for (k = 0; k < 8; k++)
        if ((uint32_t)k != i) CK(get16(SELF, (size_t)k * 0x5bb + 0x132) == 1);
}
static void test_m4fc878_near_records(void)
{
    rec_case(0, 1, 0, 1);
    rec_case(2, 1, 0, 1);
    rec_case(0xabcd0003u, 1, 0, 1);                                                  /* upper half of the stack dword ignored */
    rec_case(6, 0x00050001u, 1, 1);                                                  /* the next word is not part of the compare */
    rec_case(1, 0, 0, 0);
    rec_case(1, 2, 1, 0);
    rec_case(3, 0xffff, 0, 0);
    rec_case(3, 0x8001, 0, 0);
    rec_case(0, 0x10000, 1, 0);                                                      /* word 0 with a non-zero high word is not 1 */
    rec_case(4, 0x00010000u | 3, 1, 0);
}

/* record indices with bit 15 set: the index is the unsigned low word, so the object is 48 to 96 MB (a lazily committed zeroed allocation). With the debug word on,
 * the third argument of 0x50ca3e separates 0x8000 from 0xffff8000 (a sign-extended index); the record that a 15-bit mask or a sign extension would address is set to 1. */
static void far_case(uint32_t idx, uint32_t garbage, int dbg, uint32_t word_dword, int hit)
{
    const size_t stride = 0x5bb;
    uint8_t *obj = (uint8_t *)calloc(stride * 0x10000u + 0x200, 1);
    size_t off = (size_t)idx * stride + 0x132;
    int k = 0;
    if (obj == NULL) {
        CK(obj != NULL);
        return;
    }
    setup();
    g_w.word_63a4cd = (int16_t)dbg;
    set16(obj, (size_t)(idx & 0x7fffu) * stride + 0x132, 1);                         /* the alias of a 15-bit mask */
    set32(obj, off, word_dword);
    g_watch = obj + off;
    m4fc878_activate_record(obj, garbage | idx, &g_w, &g_host);
    if (dbg) {
        CKC(k, 0x50ca3e, 0, 3, 0x63888b, 0x560940, idx);
        CKC(k + 1, 0x44a2b7, 0, 1, 0x63888b);
        k += 2;
    }
    if (hit) {
        CKC(k, 0x4f61e7, 0x5cf1eb, 1, idx);
        CK(L.c[k].watch[0] == 1 && L.c[k].watch[1] == 0);
        k++;
        CK(get16(obj, off) == 2 && get16(obj, off + 2) == (uint16_t)(word_dword >> 16));
    } else {
        CK(get32(obj, off) == word_dword);
    }
    CK(L.n == k);
    CK(get16(obj, (size_t)(idx & 0x7fffu) * stride + 0x132) == 1);                   /* the alias is untouched */
    g_watch = NULL;
    free(obj);
}
static void test_m4fc878_far_records(void)
{
    static const uint32_t idxs[3] = {0x8000, 0x8001, 0xffff};
    int i;
    for (i = 0; i < 3 && !g_failed; i++) {
        far_case(idxs[i], 0, 1, 1, 1);
        far_case(idxs[i], 0xabcd0000u, 1, 0x00070001u, 1);
        far_case(idxs[i], 0x12340000u, 0, 1, 1);
        far_case(idxs[i], 0, 1, 0, 0);
        far_case(idxs[i], 0xffff0000u, 0, 2, 0);
    }
}
static void test_m4fc878_activate_record(void)
{
    test_m4fc878_near_records();
    if (!g_failed) test_m4fc878_far_records();
}

/* ---- 0x47d4f7 ------------------------------------------------------------------------------------------------------------------ */
static void test_m47d4f7_reset_fields(void)
{
    size_t i;
    setup();
    memset(SELF, 0xcc, 0x100);
    m47d4f7_reset_fields(SELF);
    for (i = 0; i < 0x100 && !g_failed; i++) {
        uint8_t want = 0xcc;
        if (i == 0x1d || i == 0x1e || i == 0x23 || i == 0x24) want = 0xff;
        if (i == 0x25 || i == 0x27) want = 0x0c;
        if (i == 0x26 || i == 0x28) want = 0xfe;
        if (i >= 0x29 && i < 0x55) want = 0;
        if (i == 0x57) want = 0;
        CK(SELF[i] == want);
    }
    CK(L.n == 0);
    memset(SELF, 0x00, 0x100);
    m47d4f7_reset_fields(SELF);
    CK(get16(SELF, 0x1d) == 0xffff && get16(SELF, 0x23) == 0xffff && get16(SELF, 0x27) == 0xfe0c && get16(SELF, 0x25) == 0xfe0c && SELF[0x1f] == 0 && SELF[0x56] == 0);
}

/* ---- 0x47d59b ------------------------------------------------------------------------------------------------------------------ */
static void rel_case(int mask, uint16_t word)
{
    int k = 0, bit;
    static const size_t offs[4] = {0x1f, 0x49, 0x4d, 0x51};
    setup();
    memset(SELF, 0, 0x100);
    for (bit = 0; bit < 4; bit++)
        if ((mask >> bit) & 1) set32(SELF, offs[bit], bit == 0 ? 0x1000u : (0x10000u << bit));      /* non-zero dwords, two with a zero low word */
    set16(SELF, 0x23, word);
    m47d59b_release_fields(SELF, &g_host);
    if (mask & 1) CKC(k++, 0x4c2dfb, 0x5cf659, 1, SELFP + 0x1f);
    for (bit = 1; bit < 4; bit++)
        if ((mask >> bit) & 1) CKC(k++, 0x51dc6c, 0, 1, 0x10000u << bit);
    if (word != 0xffff) CKC(k++, 0x4d3992, 0, 1, word);
    CKC0(k++, 0x47d4f7, SELFP);
    CK(L.n == k);
}
static void test_m47d59b_release_fields(void)
{
    int m;
    for (m = 0; m < 16 && !g_failed; m++) {
        rel_case(m, 0xffff);
        rel_case(m, 0x7fff);
    }
    rel_case(0, 0);              /* 0 is not -1: 0x4d3992(0) is called */
    rel_case(15, 0x8000);
    rel_case(15, 0xfffe);
    rel_case(5, 0x00ff);
    setup();
    memset(SELF, 0, 0x100);
    set16(SELF, 0x23, 0xffff);
    set32(SELF, 0x21, 0xffff0000u);      /* neighbours of the word do not change the test */
    m47d59b_release_fields(SELF, &g_host);
    CK(L.n == 1 && get16(SELF, 0x23) == 0xffff);
}

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
        for (i = 0; i < 128; i++) g_dwords[i] = (uint8_t)(seed >> (i & 15));
        m4c946b_call_slot(SELF, seed, &g_host);
        m4ee673_forward_if_set(SELF, seed, &g_host);
        g_cursor_x = seed;
        g_cursor_y = seed >> 3;
        m4daeb5_read_cursor(SELF, RVA(1) + (seed % 0x100), &g_host);
        script(0x52a4b4, 2, seed, seed >> 5, 0, 0);
        m4dadff_poll_keys(SELF, &g_w, &g_host);
        set16(SELF, 0xf73, (uint16_t)((seed >> 2) % 8) - 4);
        set16(SELF, 0xf75, (uint16_t)((seed >> 6) % 8) - 4);
        g_w.dword_5b15da = seed & 1;
        m420b9e_report_name(SELF, &g_w, &g_host);
        g_w.word_63a4cd = (int16_t)(seed >> 7);
        script(0x51dc43, 1, (seed & 8) ? 0 : RVA(2) + (seed % 0x20), 0, 0, 0);
        m47d1c3_alloc_zeroed(RVA(1) + 0x20, (seed >> 9) % 0x80, &g_w, &g_host);
        m4fc878_activate_record(SELF, seed % 7, &g_w, &g_host);
        m47d59b_release_fields(SELF, &g_host);
        m47d4f7_reset_fields(SELF);
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
    RUN(test_m4c946b_call_slot);
    RUN(test_m4ee673_forward_if_set);
    RUN(test_m4daeb5_read_cursor);
    RUN(test_m4dadff_poll_keys);
    RUN(test_m420b9e_report_name);
    RUN(test_m47d1c3_alloc_zeroed);
    RUN(test_m4fc878_activate_record);
    RUN(test_m47d4f7_reset_fields);
    RUN(test_m47d59b_release_fields);
    RUN(test_sweep_bounded);
    return failures;
}
