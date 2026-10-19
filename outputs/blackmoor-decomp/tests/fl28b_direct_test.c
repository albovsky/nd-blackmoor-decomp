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

#define SELF_SZ 0x1000
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
        uintptr_t a[4];
        uint8_t snap[SNAP];
    } c[MAXCALL];
} L;
static struct {
    uint32_t callee, result;
} S[4];
static int g_nscript;

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int k, i = L.n;
    uint32_t result = 0;
    (void)ctx;
    if (L.n < MAXCALL) {
        L.c[i].callee = callee;
        L.c[i].this_ptr = this_ptr;
        L.c[i].nargs = nargs;
        for (k = 0; k < nargs && k < 4; k++) L.c[i].a[k] = args[k];
        memcpy(L.c[i].snap, g_self, SNAP);
    }
    L.n++;
    for (k = 0; k < g_nscript; k++)
        if (S[k].callee == callee) result = S[k].result;
    return result;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    (void)a;
    return NULL;
}

static void setup(void)
{
    size_t b;
    for (b = 0; b < SELF_SZ; b++) g_self[b] = (uint8_t)(b * 7 + 3);
    memset(&g_w, 0, sizeof g_w);
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
    RUN(test_sweep_bounded);
    return failures;
}
