/* FL-28 (batch b) direct tests of the slot-table methods and the pending-state method of GAME.EXE in src/original_methods_fl28b.c. Prints "PASS <name>" / "FAIL <name>: <msg>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE, not from running
 * the native code; tests/test_fl28b_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl28b.h"

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

#define SELF_SZ 0x2200
#define SNAP 0x700
static uint8_t g_self[SELF_SZ], g_exp[SELF_SZ];
static Fl28bWorld g_w;
static Fl18Host g_host;

static void set32(size_t off, uint32_t v) { memcpy(g_self + off, &v, 4); }
static void set16(size_t off, uint16_t v) { memcpy(g_self + off, &v, 2); }
static uint32_t get32(const uint8_t *o, size_t off) { uint32_t v; memcpy(&v, o + off, 4); return v; }
static uint16_t get16(const uint8_t *o, size_t off) { uint16_t v; memcpy(&v, o + off, 2); return v; }
static void x32(size_t off, uint32_t v) { memcpy(g_exp + off, &v, 4); }
static void x16(size_t off, uint16_t v) { memcpy(g_exp + off, &v, 2); }

#define MAXCALL 512
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[6];
        uint8_t d2[16], d3[16];     /* the 16 bytes behind the arguments 2 and 3 when they are host pointers */
        uint8_t snap[SNAP];
    } c[MAXCALL];
} L;
static struct {
    uint32_t callee, results[8];
    int n, used;
} S[8];
static int g_nscript;
static void script(uint32_t callee, int n, const uint32_t *results)
{
    int i;
    S[g_nscript].callee = callee;
    S[g_nscript].n = n;
    S[g_nscript].used = 0;
    for (i = 0; i < n; i++) S[g_nscript].results[i] = results[i];
    g_nscript++;
}
#define REC_VA 0x20010000u
#define ENT_VA 0x20020000u
#define TXT_VA 0x20030000u
#define TBL_VA 0x20050000u
#define SUB_VA(j) (0x20040000u + 0x1000u * (uint32_t)(j))
static uint8_t g_t617804[4 * 0x16], g_w61879d[8], g_objs[4 * 0x84d], g_r1[0x40], g_r2[0x40], g_tbl[0x140], g_sub[4][0x80];
static uint8_t g_rec[0x900], g_ents[0x800], g_records[5 * 0x8d], g_tab[96], g_txt[0x200];

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
        memset(L.c[i].d2, 0, 16);
        memset(L.c[i].d3, 0, 16);
        if (nargs > 3 && args[2] > 0xffffffffu) memcpy(L.c[i].d2, (const void *)args[2], 16);
        if (nargs > 3 && args[3] > 0xffffffffu) memcpy(L.c[i].d3, (const void *)args[3], 16);
        memcpy(L.c[i].snap, g_self, SNAP);
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
    if (a >= REC_VA && a < REC_VA + sizeof g_rec) return g_rec + (a - REC_VA);
    if (a >= ENT_VA && a < ENT_VA + sizeof g_ents) return g_ents + (a - ENT_VA);
    if (a >= TXT_VA && a < TXT_VA + sizeof g_txt) return g_txt + (a - TXT_VA);
    if (a >= TBL_VA && a < TBL_VA + sizeof g_tbl) return g_tbl + (a - TBL_VA);
    if (a >= SUB_VA(0) && a < SUB_VA(3) + 0x80 && (a & 0xfff) < 0x80) return g_sub[(a - SUB_VA(0)) >> 12] + (a & 0xfff);
    return NULL;
}

static void setup(void)
{
    size_t b;
    for (b = 0; b < SELF_SZ; b++) g_self[b] = (uint8_t)(b * 7 + 3);
    memset(&g_w, 0, sizeof g_w);
    memset(g_rec, 0, sizeof g_rec);
    memset(g_ents, 0, sizeof g_ents);
    memset(g_records, 0, sizeof g_records);
    memset(g_tab, 0, sizeof g_tab);
    memset(g_txt, 0x77, sizeof g_txt);
    memset(g_t617804, 0, sizeof g_t617804);
    memset(g_w61879d, 0, sizeof g_w61879d);
    memset(g_objs, 0, sizeof g_objs);
    memset(g_r1, 0xe1, sizeof g_r1);
    memset(g_r2, 0xe2, sizeof g_r2);
    memset(g_tbl, 0, sizeof g_tbl);
    memset(g_sub, 0, sizeof g_sub);
    g_w.table_617804 = g_t617804 + 0x16;
    g_w.words_61879d = g_w61879d;
    g_w.objs_5d34d1 = g_objs + 0x84d;
    g_w.rects_617ec2 = g_r1;
    g_w.rects_617f02 = g_r2;
    g_w.records_5bb5e5 = g_records + 0x8d;
    g_w.dwords_585801 = g_tab + 32;
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    L.n = 0;
    g_nscript = 0;
}

static void begin(void) { memcpy(g_exp, g_self, SELF_SZ); }
#define end() do { if (!g_failed && memcmp(g_exp, g_self, SELF_SZ) != 0) { g_failed = 1; snprintf(g_msg, sizeof g_msg, "line %d: the object differs from the expected copy", __LINE__); } } while (0)

/* the idx-th logged call: callee, this, and up to four arguments */
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
#define CKC(idx, callee, thisp, nargs, ...)                              \
    do {                                                                 \
        const uintptr_t w_[] = {__VA_ARGS__};                            \
        ck_call(__LINE__, (idx), (callee), (thisp), (nargs), w_);       \
    } while (0)
#define CKC0(idx, callee, thisp) ck_call(__LINE__, (idx), (callee), (thisp), 0, NULL)

static void table_word(int i, int w) { set16(0x1c + (size_t)i * 0x16, (uint16_t)w); }
static void table_ptr(int i, uint32_t v) { set32(0x1c + (size_t)i * 0x16 + 2, v); }
static void table_dword(int i, int j, uint32_t v) { set32(0x1c + (size_t)i * 0x16 + 6 + 4 * (size_t)j, v); }
static int free_slot(void) { return (int16_t)m41e043_find_free_slot(g_self); }

/* ---- 0x41e043 ------------------------------------------------------------------------------------------------------------------ */
static void test_m41e043_find_free_slot(void)
{
    int i;
    setup();
    for (i = 0; i < 0x4b; i++) table_word(i, i == 2 ? -1 : 0x7fff);
    set16(0x68e, 2);
    set16(0x696, 3);
    CK(free_slot() == 2);                         /* the first free slot, inside the capacity */
    set16(0x696, 2);
    CK(free_slot() == -1);                        /* slot 2 is outside the capacity: the loop ends */
    set16(0x68e, 3);
    set16(0x696, 3);
    CK(free_slot() == -1);                        /* count == capacity: full, although slot 2 is free (jl not taken) */
    set16(0x68e, 4);
    CK(free_slot() == -1);                        /* count > capacity */
    set16(0x68e, 0xffff);                         /* count -1 is below capacity 3 (signed) */
    CK(free_slot() == 2);
    table_word(0, -1);
    CK(free_slot() == 0);                         /* the first free slot wins */
    table_word(0, 0x8000);                        /* 0x8000 is not -1 */
    table_word(1, 0xffff);
    CK(free_slot() == 1);
    set16(0x68e, 0xfffb);                         /* -5 < -3 (signed): the loop runs but i = 0 is not below the signed capacity -3 */
    set16(0x696, 0xfffd);
    CK(free_slot() == -1);
    set16(0x68e, 0);
    set16(0x696, 0);
    CK(free_slot() == -1);                        /* capacity 0: nothing to scan although slot 0 is free */
    set16(0x696, 0x4b);
    for (i = 0; i < 0x4b; i++) table_word(i, 5);
    table_word(0x4a, -1);
    CK(free_slot() == 0x4a);                      /* the last entry of the table */
    table_word(0x4a, 5);
    CK(free_slot() == -1);                        /* a full scan of the 0x4b entries */
    set16(0x696, 0x8000);                         /* signed -32768: no loop */
    table_word(0, -1);
    CK(free_slot() == -1);
    CK(L.n == 0);
}

/* ---- 0x42e493 ------------------------------------------------------------------------------------------------------------------ */
static void test_m42e493_take_pending(void)
{
    Fl28bWorld before;
    setup();
    g_w.word_5c3a05 = 0x270f;
    g_w.word_5c3a07 = 5;
    before = g_w;
    m42e493_take_pending(&g_w, &g_host);
    CK(memcmp(&before, &g_w, sizeof g_w) == 0);   /* nothing but the two calls */
    CK(L.n == 2);
    CKC(0, 0x52139c, 0, 3, 0x5459dc, 0, 0);
    CKC0(1, 0x4c97b4, 0x5cf659);
    setup();
    g_w.word_5c3a05 = 0x270e;                     /* not the sentinel */
    g_w.word_5c3a07 = (int16_t)0x8001;
    g_w.word_5c3a09 = (int16_t)0xfffe;
    g_w.word_5c3a0b = 0x1234;
    g_w.word_5c3a0d = 1;
    g_w.value_5c3a0f = 0x11223344u;
    g_w.value_5c3a13 = 0x55667788u;
    g_w.value_5c3a17 = 0x99aabbccu;
    g_w.value_5bb1ca = 77;
    m42e493_take_pending(&g_w, &g_host);
    CK(L.n == 0);
    CK(g_w.value_5bb57b == 0xffff8001u && g_w.value_5bb57f == 0xffff8001u);     /* sign-extended */
    CK(g_w.word_5bb599 == (int16_t)0xfffe && g_w.word_5bb595 == 0x1234);
    CK(g_w.value_5bb59b == 0x11223344u && g_w.value_5bb59f == 0x55667788u && g_w.value_5bb5a3 == 0x99aabbccu);
    CK(g_w.word_5c39ff == 1 && g_w.value_5bb1ca == 0 && g_w.value_583999 == 4);
    CK(g_w.word_5c3a05 == 0x270f && g_w.word_5c3a07 == 0x270f);
    CK(g_w.word_5c3a09 == (int16_t)0xfffe && g_w.word_5c3a0b == 0x1234 && g_w.word_5c3a0d == 1);   /* the sources stay */
    g_w.word_5c3a05 = 0;
    g_w.word_5c3a0d = 2;                          /* not 1 */
    g_w.value_5bb1ca = 0;
    m42e493_take_pending(&g_w, &g_host);
    CK(g_w.value_5bb1ca == 1);
    g_w.word_5c3a05 = (int16_t)0x270f;
    g_w.word_5c3a0d = (int16_t)0xffff;
    g_w.word_5c3a05 = (int16_t)0xa70f;            /* a different word that shares the low bits */
    g_w.value_5bb1ca = 0;
    m42e493_take_pending(&g_w, &g_host);
    CK(g_w.value_5bb1ca == 1 && g_w.word_5c3a05 == 0x270f);
    CK(L.n == 0);
}

/* ---- 0x41de29 ------------------------------------------------------------------------------------------------------------------ */
static void test_m41de29_clear_slots(void)
{
    int i, j, n;
    setup();
    for (i = 0; i < 0x4b; i++) {
        table_word(i, i);
        table_ptr(i, 0);
        for (j = 0; j < 4; j++) table_dword(i, j, 0x1000u * (uint32_t)i + (uint32_t)j + 1);
    }
    table_ptr(3, 0x2000);
    table_ptr(0x4a, 0x80000000u);
    set16(0x68e, 9);
    set16(0x694, 0x1234);
    begin();
    m41de29_clear_slots(g_self, &g_host);
    x16(0x68e, 0);
    x16(0x694, 0xffff);
    for (i = 0; i < 0x4b; i++) {
        x16(0x1c + (size_t)i * 0x16, 0xffff);
        x32(0x1c + (size_t)i * 0x16 + 2, 0);
    }
    end();
    CK(L.n == 0x4b * 4 + 2);
    n = 0;
    for (i = 0; i < 0x4b; i++) {
        if (i == 3 || i == 0x4a) {
            CKC(n, 0x51dc6c, 0, 1, i == 3 ? 0x2000u : 0x80000000u);
            CK(get16(L.c[n].snap, 0x1c + (size_t)i * 0x16) == 0xffff && get32(L.c[n].snap, 0x1c + (size_t)i * 0x16 + 2) != 0);   /* word set, pointer not yet cleared */
            n++;
        }
        for (j = 0; j < 4; j++, n++) {
            CKC(n, 0x4c2e5b, 0x5cf659, 1, 0x1000u * (uint32_t)i + (uint32_t)j + 1);
            if (n < L.n) CK(get32(L.c[n].snap, 0x1c + (size_t)i * 0x16 + 2) == 0);                /* the pointer is cleared before the dword calls */
        }
    }
    CK(n == L.n);
}

/* ---- 0x41e250 ------------------------------------------------------------------------------------------------------------------ */
static void test_m41e250_release_slot(void)
{
    int j;
    setup();
    table_word(5, -1);
    set16(0x68e, 4);
    begin();
    m41e250_release_slot(g_self, 5, &g_host);      /* already free: nothing at all */
    end();
    CK(L.n == 0);
    table_word(2, 0x8000);
    table_ptr(2, 0x1000);
    for (j = 0; j < 4; j++) table_dword(2, j, 0xa0u + (uint32_t)j);
    begin();
    m41e250_release_slot(g_self, 0xabcd0002u, &g_host);   /* the upper half of the dword is ignored */
    x16(0x1c + 2 * 0x16, 0xffff);
    x32(0x1c + 2 * 0x16 + 2, 0);
    x16(0x68e, 3);
    end();
    CK(L.n == 5);
    CKC(0, 0x51dc6c, 0, 1, 0x1000);
    CK(get16(L.c[0].snap, 0x1c + 2 * 0x16) == 0xffff && get32(L.c[0].snap, 0x1c + 2 * 0x16 + 2) == 0x1000);
    for (j = 0; j < 4; j++) {
        CKC(1 + j, 0x4c2e5b, 0x5cf659, 1, 0xa0u + (uint32_t)j);
        CK(get32(L.c[1 + j].snap, 0x1c + 2 * 0x16 + 2) == 0 && get16(L.c[1 + j].snap, 0x68e) == 4);   /* the count drops after the calls */
    }
    /* no pointer: no free call; count edges */
    setup();
    table_word(0, 7);
    table_ptr(0, 0);
    set16(0x68e, 0);
    m41e250_release_slot(g_self, 0, &g_host);
    CK(L.n == 4 && get16(g_self, 0x68e) == 0 && get16(g_self, 0x1c) == 0xffff);   /* 0 - 1 = -1 < 0: reset to 0 */
    set16(0x68e, 1);
    table_word(1, 1);
    m41e250_release_slot(g_self, 1, &g_host);
    CK(get16(g_self, 0x68e) == 0);                  /* 1 - 1 = 0 stays */
    set16(0x68e, 0x8000);
    table_word(1, 1);
    m41e250_release_slot(g_self, 1, &g_host);
    CK(get16(g_self, 0x68e) == 0x7fff);             /* wraps to +0x7fff: not negative */
    set16(0x68e, 0xffff);
    table_word(1, 1);
    m41e250_release_slot(g_self, 1, &g_host);
    CK(get16(g_self, 0x68e) == 0);                  /* -2 -> 0 */
    set16(0x68e, 0x8001);
    table_word(1, 1);
    m41e250_release_slot(g_self, 1, &g_host);
    CK(get16(g_self, 0x68e) == 0);                  /* -32768 -> 0 */
    setup();
    set16(6, 0x1111);                                 /* slot -1: the entry at +0x1c - 0x16 = +6 */
    set32(8, 0);
    set16(0x68e, 5);
    m41e250_release_slot(g_self, 0xffffffffu, &g_host);
    CK(get16(g_self, 6) == 0xffff && get16(g_self, 0x68e) == 4 && L.n == 4);
}

/* ---- 0x4edfaf ------------------------------------------------------------------------------------------------------------------ */
static void test_m4edfaf_centre_rect(void)
{
    setup();
    set32(0x4af, 0);
    set32(0x1c, 10);
    set32(0x24, 29);
    set32(0x20, 5);
    set32(0x28, 10);
    set32(0x665, 100);
    set32(0x66d, 199);
    set32(0x669, 50);
    set32(0x671, 59);
    g_w.word_5b3790 = 8;
    g_w.word_5b3792 = 5;
    begin();
    m4edfaf_centre_rect(g_self, 0xdeadbeef, &g_w, &g_host);
    x32(0x689, 10 + 10 - 4);                      /* span 20 -> 10, extent 8 -> 4 */
    x32(0x68d, 5 + 3 - 2);                        /* span 6 -> 3, extent 5 -> 2 */
    end();
    CK(L.n == 1);
    CKC(0, 0x4db993, 0x5830ce, 2, 16, 6);
    setup();
    set32(0x4af, 3);
    set32(0x1c, 10);
    set32(0x24, 29);
    set32(0x665, 100);
    set32(0x66d, 199);
    set32(0x669, 50);
    set32(0x671, 59);
    g_w.word_5b3790 = (int16_t)0xfff9;            /* -7 / 2 = -3 */
    g_w.word_5b3792 = 1;                          /* 1 / 2 = 0 */
    begin();
    m4edfaf_centre_rect(g_self, 0, &g_w, &g_host);
    x32(0x689, 100 + 50 + 3);                     /* span 100 -> 50 */
    x32(0x68d, 50 + 5 - 0);                       /* span 10 -> 5 */
    end();
    CKC(0, 0x4db993, 0x5830ce, 2, 153, 55);
    setup();
    set32(0x4af, 0x103);                           /* the whole dword is compared with 3 */
    set32(0x1c, 0);
    set32(0x24, 0xfffffffcu);                      /* hi - lo + 1 = -3 -> truncates toward zero: -1 */
    set32(0x20, 0x80000000u);
    set32(0x28, 0x7fffffffu);                      /* hi - lo + 1 wraps to 0 */
    g_w.word_5b3790 = (int16_t)0xfffd;             /* -3 -> -1 */
    g_w.word_5b3792 = (int16_t)0x8000;             /* -32768 -> -16384 */
    begin();
    m4edfaf_centre_rect(g_self, 0, &g_w, &g_host);
    x32(0x689, 0u + (uint32_t)-1 - (uint32_t)-1);
    x32(0x68d, 0x80000000u + 16384u);
    end();
    CKC(0, 0x4db993, 0x5830ce, 2, 0, 0x80004000u);
}

/* ---- 0x41e0b4 ------------------------------------------------------------------------------------------------------------------ */
static void prep_add(uint8_t kind, int count)
{
    int j;
    setup();
    for (j = 0; j < 0x4b; j++) table_word(j, -1);
    set16(0x68e, 1);
    set16(0x696, 4);
    g_self[0x75a] = kind;
    set16(0xf9b, (uint16_t)count);
    set32(0xfa1, 0x20000000u);
    for (j = 0; j < 4; j++) {
        set16(0xfb5 + 2 * (size_t)j, (uint16_t)(0x100 + j));
        table_dword(3, j, 0xb0u + (uint32_t)j);
    }
}

static void test_m41e0b4_add_slot(void)
{
    int j;
    prep_add(0x39, 3);
    begin();
    m41e0b4_add_slot(g_self, 0x77770003u, 0x5555fffeu, &g_host);     /* slot 3, id -2; upper halves ignored */
    x16(0x1c + 3 * 0x16, 0xfffe);
    x16(0x68e, 2);
    end();
    CK(L.n == 3);
    for (j = 0; j < 3; j++) CKC(j, 0x417b04, 0x5d2f31, 3, 0x100u + (uint32_t)j, 0x20000000u - 2u * 0x8cu + 0x21u * (uint32_t)j, 0xb0u + (uint32_t)j);
    CK(get16(L.c[0].snap, 0x68e) == 1);             /* the count rises after the calls */
    /* the other two accepted kinds, and no loop for count 0 / negative */
    prep_add(0x3b, 1);
    m41e0b4_add_slot(g_self, 3, 0, &g_host);
    CK(L.n == 1 && get16(g_self, 0x1c + 3 * 0x16) == 0 && get16(g_self, 0x68e) == 2);
    prep_add(0x3e, 0);
    m41e0b4_add_slot(g_self, 3, 0x7fff, &g_host);
    CK(L.n == 0 && get16(g_self, 0x1c + 3 * 0x16) == 0x7fff);
    prep_add(0x3e, -1);
    m41e0b4_add_slot(g_self, 3, 1, &g_host);
    CK(L.n == 0);
    /* a different kind: the second report, then the store */
    prep_add(0x3a, 2);
    begin();
    m41e0b4_add_slot(g_self, 3, 9, &g_host);
    x16(0x1c + 3 * 0x16, 9);
    x16(0x68e, 2);
    end();
    CK(L.n == 2);
    CKC(0, 0x52139c, 0, 3, 0x54384c, 0, 0);
    CKC0(1, 0x4c97b4, 0x5cf659);
    /* the guard: full (count >= capacity, signed), reported, and the function goes on */
    prep_add(0x39, 0);
    set16(0x68e, 4);
    m41e0b4_add_slot(g_self, 3, 9, &g_host);
    CK(L.n == 2 && L.c[0].callee == 0x52139c && L.c[0].a[0] == 0x5437fc && L.c[1].callee == 0x4c97b4 && get16(g_self, 0x68e) == 5 && get16(g_self, 0x1c + 3 * 0x16) == 9);
    prep_add(0x39, 0);
    set16(0x68e, 0xffff);                             /* -1 < 4: not full */
    m41e0b4_add_slot(g_self, 3, 9, &g_host);
    CK(L.n == 0 && get16(g_self, 0x68e) == 0);
    prep_add(0x39, 0);
    table_word(3, 0x8000);                            /* an occupied slot is reported too */
    m41e0b4_add_slot(g_self, 3, 9, &g_host);
    CK(L.n == 2 && L.c[0].a[0] == 0x5437fc);
    prep_add(0x38, 0);
    set16(0x68e, 5);
    m41e0b4_add_slot(g_self, 3, 9, &g_host);          /* both reports, in order */
    CK(L.n == 4 && L.c[0].a[0] == 0x5437fc && L.c[2].a[0] == 0x54384c);
    prep_add(0x39, 0);
    m41e0b4_add_slot(g_self, 0xffff, 4, &g_host);     /* slot -1: the entry at +6 */
    CK(get16(g_self, 6) == 4);
}


/* ---- the record-driven methods ---------------------------------------------------------------------------------------------------- */
static uint32_t rd32_(const uint8_t *o, size_t off) { uint32_t v; memcpy(&v, o + off, 4); return v; }
static void rec_set32(size_t off, uint32_t v) { memcpy(g_rec + off, &v, 4); }
static void rec_set16(size_t off, uint16_t v) { memcpy(g_rec + off, &v, 2); }
static void ent_set32(size_t off, uint32_t v) { memcpy(g_ents + off, &v, 4); }
static void ent_set16(size_t off, uint16_t v) { memcpy(g_ents + off, &v, 2); }
static void set_record(int slot) { memcpy(g_records + 0x8d + (ptrdiff_t)slot * 0x8d, &(uint32_t){REC_VA}, 4); }

static void test_m4205c1_run_entries(void)
{
    const uint32_t res[3] = {0x12340001u, 0x10000u, 0x8000u};
    setup();
    set_record(1);
    rec_set16(0x793, 3);
    rec_set32(0x795, ENT_VA);
    g_rec[0x779] = 5;
    g_rec[0x77a] = 0x14;
    ent_set16(0, 0xaaa1); ent_set32(2, 0x11111111u); g_ents[0x1b7] = 0;
    ent_set16(0x1d1, 0xaaa2); ent_set32(0x1d1 + 2, 0x22222222u); g_ents[0x1d1 + 0x1b7] = 1;
    ent_set16(2 * 0x1d1, 0xaaa3); ent_set32(2 * 0x1d1 + 2, 0x33333333u); g_ents[2 * 0x1d1 + 0x1b7] = 2;
    set32(0xf23 + 4 * 5, 0x7e000a00u);
    script(0x420737, 3, res);
    begin();
    m4205c1_run_entries(g_self, 0x99990001u, &g_w, &g_host);     /* slot 1 (the upper half is ignored) */
    end();
    CK(L.n == 6);
    CKC0(5, 0x7e000a00u, REC_VA);                                /* the tail: byte 0x779 = 5 */
    CKC(0, 0x420737, (uintptr_t)g_self, 3, 0x11111111u, 0xaaa1, (uintptr_t)(g_self + 0x78e));
    CKC(1, 0x41fa11, (uintptr_t)g_self, 1, ENT_VA);
    CKC(2, 0x420737, (uintptr_t)g_self, 3, 0x22222222u, 0xaaa2, (uintptr_t)(g_self + 0x78e));    /* result 0x10000: its low word is zero, the entry is skipped */
    CKC(3, 0x420737, (uintptr_t)g_self, 3, 0x33333333u, 0xaaa3, (uintptr_t)(g_self + 0x78e));
    CKC(4, 0x42028e, (uintptr_t)g_self, 1, ENT_VA + 2 * 0x1d1);
    /* the tail: byte 0x779 = 5 calls [self + 0xf23 + 20] with ecx = the record; byte 0x77a = 0x14 is skipped */
    setup();
    set_record(0);
    rec_set16(0x793, 0);
    g_rec[0x779] = 5;
    g_rec[0x77a] = 0xff;
    set32(0xf23 + 4 * 5, 0x7e000a00u);
    set32(0xf4b + 4 * 0xff, 0x7e000b00u);
    m4205c1_run_entries(g_self, 0, &g_w, &g_host);
    CK(L.n == 2);
    CKC0(0, 0x7e000a00u, REC_VA);
    CKC0(1, 0x7e000b00u, 0xff);                                  /* ecx = the byte */
    /* kind 1 -> 0x41fd08, kind 3 -> nothing, count -1 -> no loop */
    setup();
    set_record(2);
    rec_set16(0x793, 2);
    rec_set32(0x795, ENT_VA);
    g_rec[0x779] = 0x14;
    g_rec[0x77a] = 0x14;
    g_ents[0x1b7] = 1;
    g_ents[0x1d1 + 0x1b7] = 3;
    script(0x420737, 1, (const uint32_t[]){0xffffffffu});
    m4205c1_run_entries(g_self, 2, &g_w, &g_host);
    CK(L.n == 3);
    CKC(1, 0x41fd08, (uintptr_t)g_self, 1, ENT_VA);
    rec_set16(0x793, 0xffff);
    L.n = 0;
    m4205c1_run_entries(g_self, 2, &g_w, &g_host);
    CK(L.n == 0);
    set_record(-1);                                             /* slot -1 is the record before the table base */
    rec_set16(0x793, 1);
    L.n = 0;
    m4205c1_run_entries(g_self, 0xffff, &g_w, &g_host);
    CK(L.n == 2 && L.c[0].callee == 0x420737);
}

static void test_m4209e8_run_small_entries(void)
{
    const uint32_t res[3] = {1, 0, 0x8000};
    uint32_t v;
    setup();
    set_record(1);
    rec_set16(0x79f, 4);
    rec_set32(0x7a1, ENT_VA);
    ent_set16(0, 0x0a01); ent_set32(2, 0xc0de0001u); g_ents[6] = 1; ent_set16(7, 0xfffe); g_ents[9] = 0xab;      /* store 0xab into table[-2] */
    ent_set16(10, 0x0a02); ent_set32(12, 0xc0de0002u); g_ents[16] = 2; ent_set16(17, 0x105); g_ents[19] = 1;       /* result 0: skipped */
    ent_set16(20, 0x0a03); ent_set32(22, 0xc0de0003u); g_ents[26] = 2; ent_set16(27, 0x106); g_ents[29] = 0xff;   /* 0x4ea06c */
    ent_set16(30, 0x0a04); ent_set32(32, 0xc0de0004u); g_ents[36] = 3; ent_set16(37, 3); g_ents[39] = 1;          /* nothing */
    g_w.word_63a4cd = 0;
    script(0x420737, 3, res);
    memset(g_tab, 0x5a, sizeof g_tab);
    m4209e8_run_small_entries(g_self, 1, &g_w, &g_host);
    memcpy(&v, g_tab + 32 - 8, 4);
    CK(v == 0xab);
    CK(g_tab[32 - 8 + 4] == 0x5a && g_tab[32 - 9] == 0x5a);       /* only the one dword is written */
    CK(L.n == 5);
    CKC(0, 0x420737, (uintptr_t)g_self, 3, 0xc0de0001u, 0x0a01, (uintptr_t)(g_self + 0x7c0));
    CKC(1, 0x420737, (uintptr_t)g_self, 3, 0xc0de0002u, 0x0a02, (uintptr_t)(g_self + 0x7c0));
    CKC(2, 0x420737, (uintptr_t)g_self, 3, 0xc0de0003u, 0x0a03, (uintptr_t)(g_self + 0x7c0));
    CKC(3, 0x4ea06c, 0x571442, 1, 0x106);
    CKC(4, 0x420737, (uintptr_t)g_self, 3, 0xc0de0004u, 0x0a04, (uintptr_t)(g_self + 0x7c0));   /* kind 3: nothing after it */
    /* with the debug word: kind 1 reports first; byte 1 in kind 2 -> 0x4e9e84(word, 1) */
    setup();
    set_record(0);
    rec_set16(0x79f, 2);
    rec_set32(0x7a1, ENT_VA);
    ent_set32(2, 1); g_ents[6] = 1; ent_set16(7, 0xfffd); g_ents[9] = 0x80;
    ent_set32(12, 2); g_ents[16] = 2; ent_set16(17, 0x107); g_ents[19] = 1;
    g_w.word_63a4cd = (int16_t)0x8000;
    script(0x420737, 1, (const uint32_t[]){5});
    m4209e8_run_small_entries(g_self, 0, &g_w, &g_host);
    CK(L.n == 5);
    CKC(1, 0x50ca3e, 0, 4, (uintptr_t)(g_self + 0x1fd1), 0x543b34, 0xfffffffdu, 0x80);
    CKC(2, 0x44a2b7, 0, 1, (uintptr_t)(g_self + 0x1fd1));
    CKC(4, 0x4e9e84, 0x571442, 2, 0x107, 1);
    memcpy(&v, g_tab + 32 - 12, 4);
    CK(v == 0x80);
    setup();                                                    /* a negative count: no entry */
    set_record(0);
    rec_set16(0x79f, 0x8000);
    m4209e8_run_small_entries(g_self, 0, &g_w, &g_host);
    CK(L.n == 0);
}

static void rec_prep(uint32_t arg, uint32_t n_result, uint32_t divisor, uint32_t lo, uint32_t hi)
{
    setup();
    set32(0x3ce, REC_VA - arg * 0x5bbu);
    rec_set32(0x162, 1);
    rec_set32(0x28f, 1);
    rec_set32(0x176, divisor);
    rec_set32(0x17a, hi);
    rec_set32(0x182, lo);
    script(0x4f709c, 1, (const uint32_t[]){1});
    script(0x4f6334, 1, (const uint32_t[]){1});
    script(0x4f81fa, 1, &n_result);
}

static uint32_t rec_get(size_t off)
{
    return get32(g_rec, off);
}

static void test_m4f6ef4_advance_record(void)
{
    uint32_t r;
    rec_prep(2, 0xffffffffu, 1, 0, 1);
    script(0x4f709c, 1, (const uint32_t[]){0});
    r = m4f6ef4_advance_record(g_self, 2, &g_w, &g_host);
    CK(r == 0xffffffffu && get32(g_self, 0x3c2) == 0x3ea && L.n == 1);
    CKC0(0, 0x4f709c, (uintptr_t)g_self);
    rec_prep(2, 1, 1, 0, 1);
    rec_set32(0x162, 0);
    r = m4f6ef4_advance_record(g_self, 2, &g_w, &g_host);
    CK(r == 0xffffffffu && get32(g_self, 0x3c2) == 0x3ef && L.n == 1);
    rec_prep(2, 1, 1, 0, 1);
    rec_set32(0x28f, 0);
    r = m4f6ef4_advance_record(g_self, 2, &g_w, &g_host);
    CK(r == 0xffffffffu && get32(g_self, 0x3c2) == 0x3ef && L.n == 1);
    rec_prep(2, 1, 1, 0, 1);
    S[1].results[0] = 0;
    r = m4f6ef4_advance_record(g_self, 2, &g_w, &g_host);
    CK(r == 0xffffffffu && get32(g_self, 0x3c2) == 0x3e8 && L.n == 2);
    CKC(1, 0x4f6334, (uintptr_t)g_self, 1, 2);
    rec_prep(0xffffffffu, 0xffffffffu, 1, 0, 1);               /* arg -1: rec = base - 0x5bb */
    r = m4f6ef4_advance_record(g_self, 0xffffffffu, &g_w, &g_host);
    CK(r == 0xffffffffu && get32(g_self, 0x3c2) == 0x410 && L.n == 3);
    CKC(2, 0x4f81fa, (uintptr_t)g_self, 1, 0xffffffffu);
    rec_prep(2, 0xffffffffu, 1, 0, 1);
    g_w.word_63a4cd = 1;
    r = m4f6ef4_advance_record(g_self, 2, &g_w, &g_host);
    CK(L.n == 5);
    CKC(3, 0x50ca3e, 0, 4, 0x63888b, 0x55e994, 2, REC_VA + 4);
    CKC(4, 0x44a2b7, 0, 1, 0x63888b);
    /* the quotient and the clamps: (n, divisor, low, high) -> value */
    rec_prep(0, 7, 2, 0, 10);
    r = m4f6ef4_advance_record(g_self, 0, &g_w, &g_host);
    CK(r == 3 && rec_get(0x17e) == 3 && rec_get(0x182) == 3 && L.n == 3 && get32(g_self, 0x3c2) == 0x3e8);     /* 3.5 truncates to 3 */
    rec_prep(0, 100, 3, 5, 10);
    CK(m4f6ef4_advance_record(g_self, 0, &g_w, &g_host) == 9);   /* 33 -> min(33, 10 - 1) */
    rec_prep(0, 1, 100, 4, 100);
    CK(m4f6ef4_advance_record(g_self, 0, &g_w, &g_host) == 4);   /* 0 -> max(0, 4) */
    rec_prep(0, 0, 5, 0xfffffffdu, 100);
    CK(m4f6ef4_advance_record(g_self, 0, &g_w, &g_host) == 0);   /* n == 0: v = 0; signed low -3 */
    rec_prep(0, 0xfffffffbu, 5, 2, 100);
    CK(m4f6ef4_advance_record(g_self, 0, &g_w, &g_host) == 2);   /* n = -5: v = 0 -> max(0, 2) */
    rec_prep(0, 5, 0, 2, 100);
    CK(m4f6ef4_advance_record(g_self, 0, &g_w, &g_host) == 2);   /* 5 / 0 = infinity -> the indefinite integer, low dword 0 -> max(0, 2) */
    rec_prep(0, 0x7fffffffu, 1, 0x80000000u, 0);
    CK(m4f6ef4_advance_record(g_self, 0, &g_w, &g_host) == 0x80000000u);   /* float(2147483647) = 2^31: low dword 0x80000000, signed lowest, high -1 does not clamp */
    rec_prep(0, 6, 0xfffffffdu, 0xfffffffbu, 100);
    CK(m4f6ef4_advance_record(g_self, 0, &g_w, &g_host) == 0xfffffffeu);   /* 6 / -3 = -2 */
    rec_prep(0, 16777217u, 1, 0, 0x7fffffffu);
    CK(m4f6ef4_advance_record(g_self, 0, &g_w, &g_host) == 0x1000000u);    /* 2^24 + 1 is rounded to 2^24 by the single-precision store */
    rec_prep(0, 3, 1, 0, 0);
    CK(m4f6ef4_advance_record(g_self, 0, &g_w, &g_host) == 0xffffffffu);   /* high = 0 - 1 = -1 < 3 */
    rec_prep(0, 9, 1, 9, 10);
    CK(m4f6ef4_advance_record(g_self, 0, &g_w, &g_host) == 9);             /* v == low: the same */
}

static const char MISSING[] = "<i>Missing conversation text (please contact Tech Support)<n><o>";

static void init_prep(void)
{
    setup();
    memset(g_rec, 0xcc, sizeof g_rec);
    memset(g_ents, 0x11, sizeof g_ents);
    g_ents[0x21] = 0x31; g_ents[0x22] = 0x32; g_ents[0x23] = 0x33;
    ent_set16(0x24, 0x4444); ent_set16(0x26, 0x5555); ent_set16(0x28, 0x6666);
}

/* the fixed stores of 0x41c544 applied to the expected record `x` */
static void init_expect(uint8_t *x)
{
    memcpy(x + 0x747, "dummy", 6);
    x[0x768] = 0xd; x[0x769] = 0;
    x[0x76a] = 2; x[0x76b] = 0;
    x[0x76c] = 1; x[0x76d] = 0;
    x[0x76e] = 1; x[0x76f] = 0;
    memcpy(x + 0x770, (const uint32_t[]){1}, 4);
    x[0x778] = 0; x[0x77c] = 2;
    x[0x781] = 0; x[0x782] = 0; x[0x783] = 1; x[0x784] = 0;
    memset(x + 0x785, 0, 8);
    memcpy(x + 0x78d, (const uint32_t[]){1}, 4);
    x[0x791] = 2; x[0x792] = 0;
    x[0x779] = 0x31; x[0x77a] = 0x32; x[0x77b] = 0x33;
    x[0x77d] = 0x44; x[0x77e] = 0x44; x[0x77f] = 0x55; x[0x780] = 0x55;
    x[0x793] = 0x66; x[0x794] = 0x66;
    memset(x + 0x799, 0, 6);
}

static void test_m41c544_init_record(void)
{
    uint8_t x[0x900];
    size_t i;
    init_prep();
    m41c544_init_record(g_self, g_rec, g_ents, &g_w, &g_host);        /* no text, no debug */
    memset(x, 0xcc, sizeof x);
    init_expect(x);
    memcpy(x + 0x16b, MISSING, sizeof MISSING);
    CK(memcmp(x, g_rec, sizeof x) == 0);
    CK(L.n == 1);
    CKC(0, 0x423259, (uintptr_t)(g_self + 0xfd1), 1, (uintptr_t)g_ents);
    init_prep();                                                       /* no text, debug: report first */
    g_w.word_63a4cd = (int16_t)0x8000;
    g_w.value_5bb57b = 0x1234;
    m41c544_init_record(g_self, g_rec, g_ents, &g_w, &g_host);
    CK(memcmp(x, g_rec, sizeof x) == 0 && L.n == 3);
    CKC(1, 0x50ca3e, 0, 4, 0x63888b, 0x5431b8, (uintptr_t)g_ents, 0x1234);
    CKC(2, 0x52139c, 0, 3, 0x63888b, 0, 0);
    CK(memcmp(L.c[1].snap, g_self, SNAP) == 0);
    {
        static const char *texts[] = {"", "A", "AB", "ABC", "ABCD", "ABCDE", "0123456789abcdefghij"};
        for (i = 0; i < sizeof texts / sizeof texts[0]; i++) {
            init_prep();
            strcpy((char *)g_txt, texts[i]);
            script(0x423259, 1, (const uint32_t[]){TXT_VA});
            g_w.word_63a4cd = 1;                                       /* the debug word does not matter when the text exists */
            m41c544_init_record(g_self, g_rec, g_ents, &g_w, &g_host);
            memset(x, 0xcc, sizeof x);
            init_expect(x);
            memcpy(x + 0x16b, texts[i], strlen(texts[i]) + 1);
            CK(memcmp(x, g_rec, sizeof x) == 0 && L.n == 1);
        }
    }
}

static void add_prep(int count, const char *text)
{
    const uint32_t results[2] = {5, 7};
    setup();
    memset(g_ents, 0x11, sizeof g_ents);
    set16(0xf21, (uint16_t)count);
    strcpy((char *)g_ents + 0x196, text);
    ent_set16(0x1be, 0x1111); ent_set16(0x1bc, 0x2222); ent_set16(0x1b8, 0x3333); ent_set16(0x1ba, 0x4444);
    ent_set32(0x1c0, 0xa0a0a0a0u); ent_set32(0x1c4, 0xb1b1b1b1u); ent_set32(0x1c8, 0xc2c2c2c2u);
    ent_set16(0x1cc, 0x5555); g_ents[0x1ce] = 0x66; ent_set16(0x1cf, 0x7777);
    script(0x51ea75, 1, (const uint32_t[]){TXT_VA});
    script(0x50d550, 2, results);
}

static void add_expect(int count, const char *text)
{
    size_t b = (size_t)(ptrdiff_t)(count * 0x3a);
    x16(0x800 + b, 0x1111); x16(0x7fe + b, 0x2222); x16(0x7fa + b, 0x3333); x16(0x7fc + b, 0x4444);
    x32(0x802 + b, 0xa0a0a0a0u); x32(0x806 + b, 0xb1b1b1b1u); x32(0x80a + b, 0xc2c2c2c2u);
    memcpy(g_exp + 0x7d9 + b, text, strlen(text) + 1);
    x16(0x80e + b, 0x5555); g_exp[0x810 + b] = 0x66; x16(0x811 + b, 0x7777);
    x16(0xf21, (uint16_t)(count + 1));
}

static void test_m41fa11_add_entry(void)
{
    int j;
    add_prep(2, "hello");
    begin();
    m41fa11_add_entry(g_self, g_ents, &g_w, &g_host);
    add_expect(2, "hello");
    end();
    CK(L.n == 8);
    for (j = 0; j < 2; j++) {
        CKC(3 * j, 0x51ea75, (uintptr_t)(g_self + 0xea5 + 4 * j), 1, 0x190);
        CKC(3 * j + 1, 0x50d550, 0, 3, TXT_VA, (uintptr_t)(g_ents + 6), 0x190);
        CKC(3 * j + 2, 0x51eac4, (uintptr_t)(g_self + 0xea5 + 4 * j), 1, 0xffffffffu);
    }
    CKC(6, 0x51ea75, (uintptr_t)(g_self + 0xea5 + 8), 1, 0x190);
    CKC(7, 0x51eac4, (uintptr_t)(g_self + 0xea5 + 8), 1, 0xffffffffu);
    CK(memcmp(g_txt, g_ents + 6, 0x190) == 0 && g_txt[0x190] == 0x77);        /* 0x190 bytes copied, no more */
    /* a block that is equal to a stored one: released, then nothing else */
    add_prep(2, "hello");
    script(0x50d550, 2, (const uint32_t[]){5, 0});
    begin();
    m41fa11_add_entry(g_self, g_ents, &g_w, &g_host);
    end();
    CK(L.n == 6 && g_txt[0] == 0x77);
    CKC(5, 0x51eac4, (uintptr_t)(g_self + 0xea5 + 4), 1, 0xffffffffu);
    /* the table limit: 0x1d -> 0x1e entries is allowed, 0x1e is refused (silently, or traced) */
    add_prep(0x1d, "x");
    begin();
    m41fa11_add_entry(g_self, g_ents, &g_w, &g_host);
    add_expect(0x1d, "x");
    end();
    CK(L.n == 29 * 3 + 2);
    add_prep(0x1e, "x");
    begin();
    m41fa11_add_entry(g_self, g_ents, &g_w, &g_host);
    end();
    CK(L.n == 0);
    add_prep(0x1e, "x");
    g_w.word_63a4cd = 1;
    begin();
    m41fa11_add_entry(g_self, g_ents, &g_w, &g_host);
    end();
    CK(L.n == 2);
    CKC(0, 0x50ca3e, 0, 3, 0x63888b, 0x543a58, 0x1f);
    CKC(1, 0x4264e8, 0x583979, 1, 0x63888b);
    add_prep(0x7fff, "x");
    g_w.word_63a4cd = 1;
    m41fa11_add_entry(g_self, g_ents, &g_w, &g_host);
    CK(L.n == 2 && L.c[0].a[2] == 0x8000);
    add_prep(0x1d, "x");                                                      /* the debug word alone does not trace below the limit */
    g_w.word_63a4cd = 1;
    m41fa11_add_entry(g_self, g_ents, &g_w, &g_host);
    CK(L.c[0].callee == 0x51ea75);
    /* count -1 (a word): the entry is built at index -1 and the count becomes 0 */
    add_prep(-1, "neg");
    begin();
    m41fa11_add_entry(g_self, g_ents, &g_w, &g_host);
    add_expect(-1, "neg");
    end();
    CK(L.n == 2 && get16(g_self, 0xf21) == 0);
    /* a 0x22-character string clobbers the first byte of the word at +0x7fa that was stored before it (the NUL lands in the next byte) */
    {
        char text[0x23];
        memset(text, 'x', 0x22);
        text[0x22] = 0;
        add_prep(0, text);
        g_ents[0x1b8] = 0;                                                    /* field low byte = the string's terminator position */
        ent_set16(0x1b8, 0x3300);
        begin();
        m41fa11_add_entry(g_self, g_ents, &g_w, &g_host);
        add_expect(0, text);
        x16(0x7fa, 0x0078);                                                   /* 'x' then the terminator replaced the stored 0x3300 */
        end();
    }
}

/* ---- 0x422a0a ------------------------------------------------------------------------------------------------------------------ */
static void sub32(int j, size_t off, uint32_t v) { memcpy(g_sub[j] + off, &v, 4); }
static void sub_pattern(int j, uint8_t base)
{
    size_t b;
    for (b = 0x35; b < 0x55; b++) g_sub[j][b] = (uint8_t)(base + b);
}
static void tbl32(size_t off, uint32_t v) { memcpy(g_tbl + off, &v, 4); }
static void obj_set(int w, uint8_t sel, uint8_t sel2) { g_objs[(size_t)(w + 1) * 0x84d + 0x1e] = sel; g_objs[(size_t)(w + 1) * 0x84d + 0x1f] = sel2; }
static void world_422a0a(int16_t idx, int16_t count, uint8_t kind)
{
    int j;
    g_w.word_617e78 = idx;
    g_w.word_618783 = count;
    g_w.byte_617f42 = kind;
    g_w.value_618795 = TBL_VA;
    g_w.value_58318a = 5;
    g_w.value_583186 = 7;
    g_w.value_5cf665 = 0x5cf665aa;
    g_w.value_5d15e3 = 0x5d15e3bb;
    g_w.value_5d191d = 99;
    for (j = 0; j < 4; j++) memcpy(g_t617804 + (size_t)(idx + 1) * 0x16 + 6 + 4 * (size_t)j, &(uint32_t){SUB_VA(j)}, 4);
    for (j = 0; j < 4; j++) sub_pattern(j, (uint8_t)(0x10 * j));
}
static int d_eq32(const uint8_t *d, uint32_t a, uint32_t b, uint32_t c, uint32_t e)
{
    uint32_t v[4] = {a, b, c, e};
    return memcmp(d, v, 16) == 0;
}

static void test_m422a0a_draw_marked(void)
{
    int k;
    /* first arms: j = 0 from the table (byte 0xb6 == 2, selector 0, second selector 1), then j = 1 from the sub-object (selector 3, second selector 2) */
    setup();
    world_422a0a(1, 2, 0x3b);
    g_tbl[0xb2] = 0; g_tbl[0xb3] = 1; g_tbl[0xb6] = 2; g_tbl[0xb7] = 0;
    memcpy(g_w61879d, (const uint16_t[]){0, 1, 0, 0}, 8);
    obj_set(0, 0, 1);
    obj_set(1, 3, 2);
    for (k = 0; k < 4; k++) { tbl32(0xba + 4 * (size_t)k, 1 + (uint32_t)k); tbl32(0xfa + 4 * (size_t)k, 0x100u * (1 + (uint32_t)k)); }
    sub32(0, 0, 0xabc0); g_sub[0][0x2f] = 0xf0; g_sub[0][0x30] = 0xff;
    sub32(1, 0, 0xabc1); g_sub[1][0x2f] = 0x34; g_sub[1][0x30] = 0x12;
    sub32(1, 0x45, 0x10); sub32(1, 0x49, 0x20); sub32(1, 0x4d, 0x30); sub32(1, 0x51, 0x40);
    m422a0a_draw_marked(&g_w, &g_host);
    CK(L.n == 3 && g_w.value_5d191d == 0);
    CKC(0, 0x4c5377, 0x5cf659, 5, 0x5d15e3bb, 0x5cf665aa, L.c[0].a[2], L.c[0].a[3], 0x544330);
    CK(d_eq32(L.c[0].d2, 0x100, 0x200, 0x300, 0x400) && d_eq32(L.c[0].d3, 0x107, 0x205, 0x307, 0x405));      /* l34 = the table words, l44 = the table words plus the offsets */
    CKC(1, 0x4c609b, 0x5cf659, 6, 0xabc0, 0x5cf665aa, L.c[1].a[2], L.c[1].a[3], 0xfffffff0u, 0x54434c);
    CK(d_eq32(L.c[1].d2, 1, 2, 3, 4) && d_eq32(L.c[1].d3, 0x107, 0x205, 0x307, 0x405) && L.c[1].a[3] == L.c[0].a[3]);
    CKC(2, 0x4c5770, 0x5cf659, 6, 0xabc1, 0x5cf665aa, L.c[2].a[2], L.c[2].a[3], 0x1234, 0x544368);
    CK(memcmp(L.c[2].d2, g_sub[1] + 0x35, 16) == 0);                                                          /* l1c = sub+0x35 */
    CK(d_eq32(L.c[2].d3, 0x10 + 7, 0x20 + 5, 0x30 + 7, 0x40 + 5));                                            /* l44 = sub fields plus the offsets */
    {
        uint8_t e[0x40];
        memset(e, 0xe1, sizeof e);
        CK(memcmp(g_r1, e, sizeof e) == 0);                                                                   /* the first arm writes no rectangle */
    }
    /* the second arm (selector 2) at j = 1 and j = 0 (i = 0 finds j = 1, i = 1 finds j = 0), second selector 1; a second selector of 0 calls once */
    setup();
    world_422a0a(0, 2, 0x39);
    g_tbl[0xb2] = 1; g_tbl[0xb3] = 0;
    memcpy(g_w61879d, (const uint16_t[]){0xffff, 0xffff, 0, 0}, 8);                                            /* word -1: object 0 of the area */
    obj_set(-1, 2, 1);
    m422a0a_draw_marked(&g_w, &g_host);
    CK(L.n == 4);
    CKC(0, 0x4c5377, 0x5cf659, 5, 0x5d15e3bb, 0x5cf665aa, 0x617ec2 + 16, 0x617f02 + 16, 0x544388);           /* j = 1 first */
    CKC(1, 0x4c609b, 0x5cf659, 6, L.c[1].a[0], 0x5cf665aa, SUB_VA(1) + 0x35, L.c[1].a[3], 0, 0x5443a4);
    CKC(2, 0x4c5377, 0x5cf659, 5, 0x5d15e3bb, 0x5cf665aa, 0x617ec2, 0x617f02, 0x544388);                     /* then j = 0 */
    CK(L.c[1].a[0] == rd32_(g_sub[1], 0) && L.c[1].a[4] == (uint32_t)(int32_t)(int16_t)get16(g_sub[1], 0x2f));
    CK(memcmp(g_r1 + 16, g_sub[1] + 0x45, 16) == 0 && memcmp(g_r1, g_sub[0] + 0x45, 16) == 0);
    CK(d_eq32(g_r2 + 16, get32(g_sub[1], 0x45) + 7, get32(g_sub[1], 0x49) + 5, get32(g_sub[1], 0x4d) + 7, get32(g_sub[1], 0x51) + 5));
    CK(d_eq32(g_r2, get32(g_sub[0], 0x45) + 7, get32(g_sub[0], 0x49) + 5, get32(g_sub[0], 0x4d) + 7, get32(g_sub[0], 0x51) + 5));
    /* second arm, second selector 2 -> 0x4c5770; a selector above 3 ends the inner loop without anything; kinds that do not match do nothing but the clear */
    setup();
    world_422a0a(0, 1, 0x3e);
    g_tbl[0xb2] = 0;
    memcpy(g_w61879d, (const uint16_t[]){0xffff, 0, 0, 0}, 8);
    obj_set(-1, 2, 2);
    m422a0a_draw_marked(&g_w, &g_host);
    CK(L.n == 2 && L.c[1].callee == 0x4c5770 && L.c[1].a[5] == 0x5443c0 && L.c[1].a[2] == SUB_VA(0) + 0x35);
    setup();
    world_422a0a(0, 2, 0x39);
    g_tbl[0xb2] = 0; g_tbl[0xb3] = 0;
    obj_set(0, 4, 1);                                           /* sel > 3: ends the j loop, j = 1 is never looked at (both bytes match i = 0) */
    m422a0a_draw_marked(&g_w, &g_host);
    CK(L.n == 0 && g_w.value_5d191d == 0);
    setup();
    world_422a0a(0, 2, 0x39);
    g_tbl[0xb2] = 0; g_tbl[0xb3] = 0;
    obj_set(0, 1, 0);                                           /* selector 1 with a second selector of 0: nothing is called, i = 1 matches nothing */
    m422a0a_draw_marked(&g_w, &g_host);
    CK(L.n == 0);
    for (k = 0; k < 5; k++) {
        static const uint8_t kinds[5] = {0x38, 0x3a, 0x3c, 0, 0xff};
        setup();
        world_422a0a(0, 2, kinds[k]);
        g_tbl[0xb2] = 0;
        obj_set(0, 2, 1);
        m422a0a_draw_marked(&g_w, &g_host);
        CK(L.n == 0 && g_w.value_5d191d == 0 && g_r1[0] == 0xe1);
    }
    setup();
    world_422a0a(0, -1, 0x39);                                  /* a negative count: no loop */
    m422a0a_draw_marked(&g_w, &g_host);
    CK(L.n == 0 && g_w.value_5d191d == 0);
}

/* ---- bounded sweep ------------------------------------------------------------------------------------------------------------- */
static void test_sweep_bounded(void)
{
    unsigned seed = 12345;
    int n, i;
    for (n = 0; n < 300 && !g_failed; n++) {
        setup();
        for (i = 0; i < SELF_SZ; i++) {
            seed = seed * 1103515245u + 12345u;
            g_self[i] = (uint8_t)(seed >> 16);
        }
        seed = seed * 1103515245u + 12345u;
        set16(0x696, (uint16_t)((seed >> 16) % 0x4c));          /* capacity within the table */
        set16(0xf9b, (uint16_t)((seed >> 8) % 0x20));
        set32(0xfa1, seed);
        g_w.word_5b3790 = (int16_t)seed;
        g_w.word_5b3792 = (int16_t)(seed >> 7);
        g_w.word_5c3a05 = (n & 1) ? 0x270f : (int16_t)seed;
        g_self[0x75a] = (uint8_t)(n % 3 == 0 ? 0x39 + (n % 5 == 0 ? 2 : 0) : seed >> 24);
        m41e043_find_free_slot(g_self);
        m42e493_take_pending(&g_w, &g_host);
        m4edfaf_centre_rect(g_self, seed, &g_w, &g_host);
        m41e0b4_add_slot(g_self, seed % 0x4c - 1, seed >> 5, &g_host);
        m41e250_release_slot(g_self, (seed >> 3) % 0x4c - 1, &g_host);
        m41de29_clear_slots(g_self, &g_host);
        L.n = 0;
    }
    for (n = 0; n < 300 && !g_failed; n++) {       /* the record-driven methods: random records, counts up to four, indices inside the dword table */
        uint32_t results[2];
        setup();
        for (i = 0; i < (int)sizeof g_rec; i++) { seed = seed * 1103515245u + 12345u; g_rec[i] = (uint8_t)(seed >> 16); }
        for (i = 0; i < (int)sizeof g_ents; i++) { seed = seed * 1103515245u + 12345u; g_ents[i] = (uint8_t)(seed >> 16); }
        for (i = 0; i < SELF_SZ; i++) { seed = seed * 1103515245u + 12345u; g_self[i] = (uint8_t)(seed >> 16); }
        seed = seed * 1103515245u + 12345u;
        set_record((int)(seed >> 20) % 3);
        rec_set16(0x793, (uint16_t)((seed >> 8) % 5));
        rec_set16(0x79f, (uint16_t)((seed >> 11) % 5));
        rec_set32(0x795, ENT_VA);
        rec_set32(0x7a1, ENT_VA);
        g_rec[0x779] = (uint8_t)((seed & 1) ? 0x14 : 5);
        g_rec[0x77a] = (uint8_t)((seed & 2) ? 0x14 : 0xff);
        set32(0xf23 + 4 * 5, 0x7e000a00u);
        set32(0xf4b + 4 * 0xff, 0x7e000b00u);
        for (i = 0; i < 5; i++) ent_set16(10 * (size_t)i + 7, (uint16_t)((seed >> i) % 16 - 8));
        results[0] = seed;
        results[1] = seed >> 3;
        script(0x420737, 2, results);
        g_w.word_63a4cd = (int16_t)(seed >> 9);
        m4205c1_run_entries(g_self, (uint32_t)((int)(seed >> 20) % 3), &g_w, &g_host);
        m4209e8_run_small_entries(g_self, (uint32_t)((int)(seed >> 20) % 3), &g_w, &g_host);
        L.n = 0;
        set32(0x3ce, REC_VA - 1u * 0x5bbu);
        rec_set32(0x162, 1);
        rec_set32(0x28f, 1);
        script(0x4f709c, 1, (const uint32_t[]){1});
        script(0x4f6334, 1, (const uint32_t[]){1});
        script(0x4f81fa, 1, &results[0]);
        m4f6ef4_advance_record(g_self, 1, &g_w, &g_host);
    }
    CK(1);
}

#define RUN(fn)                                                  \
    do {                                                         \
        g_failed = 0;                                            \
        g_msg[0] = 0;                                            \
        fn();                                                    \
        if (g_failed) { failures++; printf("FAIL %s: %s\n", #fn, g_msg); } \
        else printf("PASS %s\n", #fn);                           \
    } while (0)

int main(void)
{
    int failures = 0;
    RUN(test_m41e043_find_free_slot);
    RUN(test_m42e493_take_pending);
    RUN(test_m41de29_clear_slots);
    RUN(test_m41e250_release_slot);
    RUN(test_m4edfaf_centre_rect);
    RUN(test_m41e0b4_add_slot);
    RUN(test_m4205c1_run_entries);
    RUN(test_m4209e8_run_small_entries);
    RUN(test_m4f6ef4_advance_record);
    RUN(test_m41c544_init_record);
    RUN(test_m41fa11_add_entry);
    RUN(test_m422a0a_draw_marked);
    RUN(test_sweep_bounded);
    return failures;
}
