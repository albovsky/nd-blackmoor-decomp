/* FL-22 (batch a) direct tests of the functions of GAME.EXE in src/original_methods_fl22a.c. Prints "PASS <name>" / "FAIL <name>: <msg>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values come from the disassembly of
 * GAME.EXE, not from running the native code; tests/test_fl22a_differential.py additionally runs the original bytes on random fixtures.
 */
#include "../src/original_methods_fl22a.h"

#include <stdio.h>
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

#if defined(__GNUC__) || defined(__clang__)
#define UNUSED_OK __attribute__((unused))
#else
#define UNUSED_OK
#endif

#define OBJ 0x8400u
#define REC 0x8du

UNUSED_OK static void fill(uint8_t *o, size_t n, uint8_t seed)
{
    size_t i;
    for (i = 0; i < n; i++) o[i] = (uint8_t)(i * 7u + seed + (i >> 8));
}

UNUSED_OK static void set32(uint8_t *o, size_t off, uint32_t v) { memcpy(o + off, &v, 4); }
UNUSED_OK static void set16(uint8_t *o, size_t off, uint16_t v) { memcpy(o + off, &v, 2); }

UNUSED_OK static uint32_t get32(const uint8_t *o, size_t off)
{
    uint32_t v;
    memcpy(&v, o + off, 4);
    return v;
}

UNUSED_OK static uint16_t get16(const uint8_t *o, size_t off)
{
    uint16_t v;
    memcpy(&v, o + off, 2);
    return v;
}

/* ---- the call log of the host ----------------------------------------------------------------------------------------------- */

typedef struct Call {
    uint32_t callee;
    uintptr_t this_ptr;
    int n;
    uintptr_t a[12];
    uint8_t snap[32];       /* the bytes behind args[snap_arg] of the callee snap_callee, when asked for */
    uint8_t snap2[32];      /* ... and behind args[snap_arg2] (when snap_arg2 >= 0) */
    uint8_t probe[64];      /* the bytes at the host addresses probe_ptr[] (concatenated), as they are at the call (every callee, or only probe_callee) */
    uint8_t pd[5][16];      /* the 16 bytes behind each of args[0..4] that is a host pointer (a value above 32 bits), for every call */
} Call;

typedef struct Region {
    uint32_t va;
    uint8_t *ptr;
    uint32_t len;
} Region;

typedef struct OutWrite {
    uint32_t callee;
    int call, arg, off, size;
    uint32_t value;
} OutWrite;

static struct {
    int n;
    Call c[512];
    uint32_t ret_callee[8], ret_value[8][64];  /* per-callee queue of return values (index by position) */
    int ret_count[8], ret_used[8];
    uint32_t snap_callee;
    int snap_arg, snap_arg2, snap_len;
    uint32_t probe_callee;   /* 0: probe at every call */
    const uint8_t *probe_ptr[8];
    int probe_len[8], nprobe;
    OutWrite w[16];
    int nw;
    int calls_of[16];       /* per callee slot: how many calls were made (for OutWrite.call) */
    uint32_t calls_callee[16];
    Region regions[8];
    int nregions;
    uint32_t tick;
    int ticks;
    uint8_t *abs_target;     /* OutWrite.arg == -2: the write goes to this host address (+ off) */
} L;

static void reset_log(void) { memset(&L, 0, sizeof L); }

UNUSED_OK static void queue_return(uint32_t callee, uint32_t v)
{
    int i;
    for (i = 0; i < 8; i++) {
        if (L.ret_count[i] == 0 || L.ret_callee[i] == callee) {
            L.ret_callee[i] = callee;
            L.ret_value[i][L.ret_count[i]++] = v;
            return;
        }
    }
}

UNUSED_OK static void queue_write(uint32_t callee, int call, int arg, int off, int size, uint32_t value)
{
    OutWrite *w = &L.w[L.nw++];
    w->callee = callee;
    w->call = call;
    w->arg = arg;
    w->off = off;
    w->size = size;
    w->value = value;
}

static uint32_t h_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int i, k, nth = 0;
    (void)ctx;
    for (i = 0; i < 16; i++) {
        if (L.calls_of[i] == 0 || L.calls_callee[i] == callee) {
            L.calls_callee[i] = callee;
            nth = L.calls_of[i]++;
            break;
        }
    }
    if (L.n < 512) {
        Call *c = &L.c[L.n];
        c->callee = callee;
        c->this_ptr = this_ptr;
        c->n = nargs;
        for (k = 0; k < nargs && k < 12; k++) c->a[k] = args[k];
        for (k = 0; k < nargs && k < 5; k++)
            if ((uint64_t)args[k] > 0xffffffffu)
                /* (the string local of 0x4d2c20 is two bytes long) */
                memcpy(c->pd[k], (const void *)args[k], callee == 0x4d2c20 && k == 0 ? 2u : 16u);
        if (L.nprobe > 0 && (L.probe_callee == 0 || L.probe_callee == callee)) {
            int at = 0;
            for (k = 0; k < L.nprobe; k++) {
                memcpy(c->probe + at, L.probe_ptr[k], (size_t)L.probe_len[k]);
                at += L.probe_len[k];
            }
        }
        if (callee == L.snap_callee && L.snap_len > 0) {
            memcpy(c->snap, (const void *)args[L.snap_arg], (size_t)L.snap_len);
            if (L.snap_arg2 > 0) memcpy(c->snap2, (const void *)args[L.snap_arg2], (size_t)L.snap_len);
        }
    }
    L.n++;
    for (i = 0; i < L.nw; i++) {
        const OutWrite *w = &L.w[i];
        if (w->callee == callee && w->call == nth) {
            uint8_t *p = (uint8_t *)(w->arg == -2 ? (uintptr_t)L.abs_target : w->arg < 0 ? this_ptr : args[w->arg]) + w->off;
            if (w->size == 2) {
                uint16_t v = (uint16_t)w->value;
                memcpy(p, &v, 2);
            } else {
                memcpy(p, &w->value, 4);
            }
        }
    }
    for (i = 0; i < 8; i++)
        if (L.ret_count[i] != 0 && L.ret_callee[i] == callee) {
            uint32_t v = L.ret_value[i][L.ret_used[i] < L.ret_count[i] ? L.ret_used[i] : L.ret_count[i] - 1];
            L.ret_used[i]++;
            return v;
        }
    return 0;
}

static const uint8_t *h_resolve(void *ctx, uint32_t va)
{
    int i;
    (void)ctx;
    for (i = 0; i < L.nregions; i++)
        if (va >= L.regions[i].va && va < L.regions[i].va + L.regions[i].len) return L.regions[i].ptr + (va - L.regions[i].va);
    return NULL;
}

static uint32_t h_tick(void *ctx)
{
    (void)ctx;
    L.ticks++;
    return L.tick;
}

UNUSED_OK static void add_region(uint32_t va, uint8_t *ptr, uint32_t len)
{
    L.regions[L.nregions].va = va;
    L.regions[L.nregions].ptr = ptr;
    L.regions[L.nregions].len = len;
    L.nregions++;
}

static Fl18Host host(void)
{
    Fl18Host h;
    memset(&h, 0, sizeof h);
    h.call = h_call;
    h.resolve = h_resolve;
    h.tick = h_tick;
    return h;
}

UNUSED_OK static int is_call(int k, uint32_t callee, uintptr_t this_ptr, int n)
{
    return k < L.n && k < 512 && L.c[k].callee == callee && L.c[k].this_ptr == this_ptr && L.c[k].n == n;
}

#define RUN(fn)                                  \
    do {                                         \
        g_failed = 0;                            \
        g_msg[0] = 0;                            \
        reset_log();                             \
        fn();                                    \
        if (g_failed) {                          \
            printf("FAIL %s: %s\n", #fn, g_msg); \
            failures++;                          \
        } else                                   \
            printf("PASS %s\n", #fn);            \
    } while (0)

UNUSED_OK static uint8_t g_obj[OBJ], g_exp[OBJ];
UNUSED_OK static uint8_t g_records[REC * 8];

/* ---- tests ---- */

/* ---- 0x463392 ---- */

#define P_VA 0x00d30000u
#define P_TICK_NOW 0x40000000u

static uint8_t p_self[0x100], p_exp[0x100], p_rec[0x400], p_records[0x8d * 6], p_table[0x4a * 7], p_texp[0x4a * 7], p_flags[0x80], p_fexp[0x80], p_data[0xac];

#define P_REC(w, n) ((w).records_5bb5e5 + (ptrdiff_t)(n) * 0x8d)
#define P_SLOT(n) (p_table + 0x4a + (ptrdiff_t)(n) * 0x4a)
#define P_FLAG(w, i) ((w).flags_585801 + (ptrdiff_t)(i) * 4)

/* the nine-byte patterns of the image (offset in the data block from 0x54b164) and the offset of the record bytes each is compared with */
static const uint16_t p_pat_off[9] = {0x40, 0x4c, 0x58, 0x64, 0x70, 0x7c, 0x88, 0x94, 0xa0};
static const uint16_t p_pat_rec[9] = {0x24f, 0x280, 0x2b1, 0x280, 0x2b1, 0x2fd, 0x24f, 0x280, 0x2b1};
/* indices into the two arrays above */
enum { PAT_S0_24F, PAT_S0_280, PAT_S0_2B1, PAT_S1_280, PAT_S1_2B1, PAT_S1_2FD, PAT_S2_24F, PAT_S2_280, PAT_S2_2B1 };

static void p_prepare(Fl22aWorld *w, int index, uint32_t state)
{
    int k, j;
    reset_log();
    add_region(P_VA, p_rec, sizeof p_rec);
    memset(p_self, 0x5a, sizeof p_self);
    memset(p_table, 0x33, sizeof p_table);
    memset(p_records, 0x11, sizeof p_records);
    memset(p_flags, 0x44, sizeof p_flags);
    memset(p_data, 0x66, sizeof p_data);
    fill(p_rec, sizeof p_rec, 0x21);
    memset(w, 0, sizeof *w);
    w->records_5bb5e5 = p_records + 0x8d;
    w->table_5d1591 = p_table + 0x4a;
    w->data_54b164 = p_data;
    w->flags_585801 = p_flags + 0x40;
    set32(P_REC(*w, index), 0, P_VA);
    set32(P_REC(*w, index), 0x4d, state);
    memcpy(p_data, "hello", 6);
    /* every pattern equals the record bytes it is compared with */
    for (k = 0; k < 9; k++)
        for (j = 0; j < 9; j++) p_data[p_pat_off[k] + j] = p_rec[p_pat_rec[k] + j];
    L.tick = P_TICK_NOW;
}

/* a difference at byte `pos` of the pattern k */
static void p_break(int k, int pos) { p_data[p_pat_off[k] + pos] ^= 0x40; }

static void p_run(Fl22aWorld *w, int index)
{
    Fl18Host h = host();
    m463392_step_scene(p_self, (int16_t)index, w, &h);
}

/* the address of the record bytes that pattern k is compared with, as the original passes it */
static uintptr_t p_addr(int k) { return (uintptr_t)(P_VA + p_pat_rec[k]); }

static void test_m463392_step_scene(void)
{
    (void)m463392_step_scene; /* driven through the file's runner helper; named here so the test pointer finds it */
    Fl22aWorld w;
    size_t n;
    int mask, variant, r21, s20, k;
    /* any other state: nothing (not even the tick), the record is not touched */
    {
        static const uint32_t states[] = {3, 0xffffffffu, 0x100, 0x80000000u, 4};
        for (n = 0; n < sizeof states / sizeof states[0]; n++) {
            p_prepare(&w, 2, states[n]);
            memcpy(p_exp, p_self, sizeof p_exp);
            p_run(&w, 2);
            CK(L.n == 0 && L.ticks == 0 && memcmp(p_self, p_exp, sizeof p_self) == 0 && get32(P_REC(w, 2), 0x4d) == states[n] && w.value_5bb1ca == 0);
        }
    }
    /* ---- state 0 ---- */
    for (variant = 0; variant < 2; variant++)
        for (r21 = 0; r21 < 2; r21++)
            for (s20 = 0; s20 < 2; s20++)
                for (mask = 0; mask < 8; mask++) {
                    /* the pattern differences sit at the first / fifth / ninth byte (variant 0) or reversed (variant 1) */
                    static const int posa[2][3] = {{0, 4, 8}, {8, 4, 0}};
                    uint32_t self20 = s20 ? 0x777u : 0;
                    uint32_t ret4c = 0x9999u;
                    int slot = variant ? -1 : 1;
                    int idx_slot = variant ? 2 : 3;    /* the record index of the call */
                    int expect_calls;
                    int c;
                    uint8_t *t;
                    p_prepare(&w, idx_slot, 0);
                    p_rec[0x21] = r21 ? 9 : 0;
                    set32(p_rec, 0xd8, 1000);
                    set32(p_rec, 0xd0, 300);
                    set32(p_rec, 0xdc, 50);
                    set32(p_rec, 0xd4, 80);   /* 50 - 80 wraps */
                    set32(p_self, 0x20, self20);
                    set16(p_self, 0x1e, 0x1234);   /* overwritten with the index */
                    queue_return(0x4d39f9, variant ? 0xabcdffffu : 0xabcd0001u);   /* only the low 16 bits are the slot */
                    queue_return(0x4c2790, ret4c);
                    for (k = 0; k < 3; k++)
                        if (mask & (1 << k)) {
                            p_break(k, posa[variant][k]);
                            /* an embedded zero before the difference: a string compare would stop there */
                            if (posa[variant][k] == 8) { p_data[p_pat_off[k] + 1] = 0; p_rec[p_pat_rec[k] + 1] = 0; }
                        }
                    L.probe_ptr[0] = p_self + 0x1c;
                    L.probe_len[0] = 8;
                    L.probe_ptr[1] = p_self + 0x4f;
                    L.probe_len[1] = 8;
                    L.probe_ptr[2] = p_self + 0x28;
                    L.probe_len[2] = 1;
                    L.probe_ptr[3] = P_SLOT(slot);
                    L.probe_len[3] = 0x1e;
                    L.probe_ptr[4] = P_REC(w, idx_slot) + 0x4d;
                    L.probe_len[4] = 4;
                    L.probe_ptr[5] = (const uint8_t *)&w.value_5bb1ca;
                    L.probe_len[5] = 4;
                    L.nprobe = 6;
                    memcpy(p_exp, p_self, sizeof p_exp);
                    memcpy(p_texp, p_table, sizeof p_texp);
                    p_run(&w, idx_slot);
                    /* the expected object */
                    set16(p_exp, 0x1e, (uint16_t)idx_slot);
                    set32(p_exp, 0x3f, 1);
                    set32(p_exp, 0x4f, 1000u - 300u);
                    set32(p_exp, 0x53, 50u - 80u);
                    p_exp[0x28] = 1;
                    set16(p_exp, 0x1c, (uint16_t)slot);
                    set32(p_exp, 0x20, s20 ? self20 : ret4c);
                    set32(p_exp, 0x47, 0);
                    set32(p_exp, 0x43, 0);
                    set32(p_exp, 0x24, 0);
                    set16(p_exp, 0x39, 0);
                    set16(p_exp, 0x57, 0);
                    set16(p_exp, 0x59, 0);
                    set32(p_exp, 0x3b, 0);
                    memset(p_exp + 0x29, 0, 16);
                    CK(memcmp(p_self, p_exp, sizeof p_self) == 0);
                    t = p_texp + 0x4a + slot * 0x4a;
                    set32(t, 0, 0xa);
                    set32(t, 4, 0x463b10);
                    set32(t, 8, s20 ? self20 : ret4c);
                    set32(t, 0xc, 0);
                    set32(t, 0x10, 0);
                    set32(t, 0x14, 1);
                    set32(t, 0x18, 1);
                    set16(t, 0x1c, 0);
                    memcpy(t + 0x22, "hello", 6);
                    CK(memcmp(p_table, p_texp, sizeof p_table) == 0);
                    CK(get32(P_REC(w, idx_slot), 0x4d) == 1 && w.value_5bb1ca == 1);
                    /* the calls in order */
                    c = 0;
                    if (!r21) { CK(is_call(c, 0x4618df, (uintptr_t)p_self, 0)); c++; }
                    CK(is_call(c, 0x4e8d96, 0x571442, 0)); c++;
                    CK(is_call(c, 0x462577, (uintptr_t)p_self, 0)); c++;
                    CK(is_call(c, 0x4d39f9, 0, 0)); c++;
                    if (!s20) { CK(is_call(c, 0x4c2790, 0x5cf659, 4) && L.c[c].a[0] == 0x54b19c && L.c[c].a[1] == P_VA && L.c[c].a[2] == 6 && L.c[c].a[3] == 0x54b180); c++; }
                    for (k = 0; k < 3; k++)
                        if (mask & (1 << k)) { CK(is_call(c, 0x4fb77a, 0x5c3a67, 1) && L.c[c].a[0] == p_addr(k)); c++; }
                    expect_calls = c;
                    CK(L.n == expect_calls && L.ticks == 0);
                    /* call-time state: the first calls see the early stores only */
                    c = 0;
                    if (!r21) {   /* 0x4618df: [self+0x1e] = index, [self+0x3f] = 1, 0x5bb1ca = 1 are stored; nothing else */
                        CK(get16(L.c[0].probe, 2) == (uint16_t)idx_slot && get32(L.c[0].probe, 4) == self20);   /* self+0x1e (offset 2 of the probe) and +0x20 (offset 4) */
                        CK(get32(L.c[0].probe, 51) == 1 && L.c[0].probe[16] == 0x5a && get32(L.c[0].probe, 8) == 0x5a5a5a5au);
                        CK(get32(L.c[0].probe, 47) == 0);   /* the state of the record is not yet 1 */
                        c = 1;
                    }
                    CK(get32(L.c[c].probe, 8) == 0x5a5a5a5au && L.c[c].probe[17] == 0x33 && get32(L.c[c].probe, 51) == 1);   /* 0x4e8d96: [self+0x4f] not yet stored, slot untouched */
                    c++;
                    CK(get32(L.c[c].probe, 8) == 1000u - 300u && get32(L.c[c].probe, 12) == 50u - 80u && L.c[c].probe[16] == 0x5a && L.c[c].probe[17] == 0x33);
                    c++;
                    CK(L.c[c].probe[16] == 1 && L.c[c].probe[17] == 0x33);   /* 0x4d39f9: [self+0x28] = 1 is stored, the slot is untouched */
                    c++;
                    if (!s20) {   /* 0x4c2790: the slot is complete up to +0x1c, the object field +0x20 is still the old 0 */
                        const uint8_t *pr = L.c[c].probe;
                        CK(get16(pr, 0) == (uint16_t)slot && get32(pr, 4) == 0 && get32(pr, 17 + 0) == 0xa && get32(pr, 17 + 4) == 0x463b10 && get32(pr, 17 + 8) == 0 &&
                           get32(pr, 17 + 0x14) == 1 && get32(pr, 17 + 0x18) == 1);
                        c++;
                    }
                    if (mask != 0) {   /* the first 0x4fb77a: the slot's +8 is the final value of [self+0x20], the record state is not yet 1 */
                        const uint8_t *pr = L.c[c].probe;
                        CK(get32(pr, 17 + 8) == (s20 ? self20 : ret4c) && get32(pr, 47) == 0 && get32(pr, 4) == (s20 ? self20 : ret4c));
                    }
                }
    /* ---- state 1, v = [self+0x24]; [self+0x1e] names another record (3), whose state is the one that is stored ---- */
    /* v = 0 */
    {
        static const uint32_t f47[] = {0, 1, 0x100, 0x1000000u, 0xffffffffu};
        for (n = 0; n < sizeof f47 / sizeof f47[0]; n++) {
            p_prepare(&w, 2, 1);
            set16(p_self, 0x1e, 3);
            set32(P_REC(w, 3), 0x4d, 1);
            set32(p_self, 0x24, 0);
            set32(p_self, 0x3b, 0x1234);
            set32(p_self, 0x47, f47[n]);
            L.probe_ptr[0] = p_self + 0x3b;
            L.probe_len[0] = 4;
            L.probe_ptr[1] = p_self + 0x24;
            L.probe_len[1] = 4;
            L.nprobe = 2;
            memcpy(p_exp, p_self, sizeof p_exp);
            p_run(&w, 2);
            set32(p_exp, 0x3b, 0);
            if (f47[n] != 0) {
                set32(p_exp, 0x24, 1);
                CK(L.n == 0);
            } else {
                CK(L.n == 1 && is_call(0, 0x4632bf, (uintptr_t)p_self, 0) && get32(L.c[0].probe, 0) == 0 && get32(L.c[0].probe, 4) == 0);
            }
            CK(memcmp(p_self, p_exp, sizeof p_self) == 0 && get32(P_REC(w, 3), 0x4d) == 1 && L.ticks == 0);
        }
    }
    /* v = 1: the deadline [self+0x4b] := tick + (signed word [rec+0x2fb]) * 1000, [self+0x24] := 4 */
    {
        static const int16_t words[] = {0, 1, -1, 5, -32768, 4000, 32767};
        static const uint32_t ticks[] = {0, 0xfffffc00u, 12345u};
        size_t m;
        for (n = 0; n < sizeof words / sizeof words[0]; n++)
            for (m = 0; m < sizeof ticks / sizeof ticks[0]; m++) {
                p_prepare(&w, 2, 1);
                set16(p_self, 0x1e, 3);
                set32(p_self, 0x24, 1);
                set32(p_self, 0x4b, 0x7777);
                set16(p_rec, 0x2fb, (uint16_t)words[n]);
                L.tick = ticks[m];
                memcpy(p_exp, p_self, sizeof p_exp);
                p_run(&w, 2);
                set32(p_exp, 0x4b, ticks[m] + (uint32_t)((int32_t)words[n] * 1000));
                set32(p_exp, 0x24, 4);
                CK(L.n == 0 && L.ticks == 1 && memcmp(p_self, p_exp, sizeof p_self) == 0);
            }
    }
    /* v = 2: 0x461d82, 0x4619be (word [self+0x57]), 0x461d4b (words +0x39, +0x5b, +0x5d), then a nine-byte compare and a word of the record */
    for (variant = 0; variant < 2; variant++)
        for (mask = 0; mask < 64; mask++) {
            uint32_t r82 = (mask & 1) ? 0x100u : 0, r9e = (mask & 2) ? 0x100u : 0, r4b = (mask & 4) ? 0xffffffffu : 0;
            int dmis = (mask & 8) != 0, emis = (mask & 16) != 0;
            int c = 0;
            /* variant 1: the callees store the words that are read afterwards (the port must read them after the call) */
            p_prepare(&w, 2, 1);
            set16(p_self, 0x1e, 3);
            set32(p_self, 0x24, 2);
            set16(p_self, 0x57, 0x1111);
            set16(p_self, 0x39, 0x2222);
            set16(p_self, 0x5b, 0x3333);
            set16(p_self, 0x5d, 0x4444);
            set16(p_rec, 0x2a1, 0x5555);
            set16(p_rec, 0x2d2, 0x6666);
            queue_return(0x461d82, r82);
            queue_return(0x4619be, r9e);
            queue_return(0x461d4b, r4b);
            if (variant) {
                queue_write(0x461d82, 0, -1, 0x57, 2, 0x7777);
                queue_write(0x4619be, 0, -1, 0x39, 2, 0x8888);
                queue_write(0x4619be, 0, -1, 0x5b, 2, 0x9999);
                queue_write(0x4619be, 0, -1, 0x5d, 2, 0xaaaa);
            }
            if (dmis) p_break(PAT_S1_280, (mask >> 5) & 1 ? 8 : 0);
            if (emis) p_break(PAT_S1_2B1, (mask >> 5) & 1 ? 8 : 0);
            L.probe_ptr[0] = p_self + 0x24;
            L.probe_len[0] = 4;
            L.nprobe = 1;
            memcpy(p_exp, p_self, sizeof p_exp);
            p_run(&w, 2);
            CK(is_call(c, 0x461d82, (uintptr_t)p_self, 0));
            c++;
            if (r82 != 0) {
                CK(is_call(c, 0x4619be, (uintptr_t)p_self, 1) && (L.c[c].a[0] & 0xffff) == (variant ? 0x7777u : 0x1111u));
                c++;
                if (r9e == 0) {
                    CK(is_call(c, 0x461d4b, (uintptr_t)p_self, 3) && (L.c[c].a[0] & 0xffff) == (variant ? 0x8888u : 0x2222u) &&
                       (L.c[c].a[1] & 0xffff) == (variant ? 0x9999u : 0x3333u) && (L.c[c].a[2] & 0xffff) == (variant ? 0xaaaau : 0x4444u));
                    c++;
                    if (r4b != 0) {
                        if (dmis) { CK(is_call(c, 0x4fb2e3, 0x5c3a67, 1) && (L.c[c].a[0] & 0xffff) == 0x5555 && get32(L.c[c].probe, 0) == 2); c++; }
                    } else {
                        if (emis) { CK(is_call(c, 0x4fb2e3, 0x5c3a67, 1) && (L.c[c].a[0] & 0xffff) == 0x6666 && get32(L.c[c].probe, 0) == 2); c++; }
                    }
                    set32(p_exp, 0x24, 0);
                }
            }
            if (variant) {   /* 0x461d82 stores [self+0x57] in its (always made) call; 0x4619be stores the three words when it is called */
                set16(p_exp, 0x57, 0x7777);
                if (r82 != 0) { set16(p_exp, 0x39, 0x8888); set16(p_exp, 0x5b, 0x9999); set16(p_exp, 0x5d, 0xaaaa); }
            }
            CK(L.n == c && L.ticks == 0 && memcmp(p_self, p_exp, sizeof p_self) == 0 && get32(P_REC(w, 3), 0x4d) == 0x11111111u);
        }
    /* v = 3: 0x4f6334 on 0x5cf1eb with the sign-extended word [rec+0x31e]; when it returns 0: 0x4fba69 with rec+0x2fd and the record state := 2 */
    {
        static const int16_t words[] = {-5, 0x7fff, 5, 0, -32768};
        static const uint32_t rets[] = {0, 1, 0x100, 0xffffffffu};
        size_t m;
        for (n = 0; n < sizeof words / sizeof words[0]; n++)
            for (m = 0; m < sizeof rets / sizeof rets[0]; m++) {
                p_prepare(&w, 2, 1);
                set16(p_self, 0x1e, 3);
                set32(P_REC(w, 3), 0x4d, 1);
                set32(p_self, 0x24, 3);
                set16(p_rec, 0x31e, (uint16_t)words[n]);
                queue_return(0x4f6334, rets[m]);
                L.probe_ptr[0] = P_REC(w, 3) + 0x4d;
                L.probe_len[0] = 4;
                L.nprobe = 1;
                memcpy(p_exp, p_self, sizeof p_exp);
                p_run(&w, 2);
                CK(is_call(0, 0x4f6334, 0x5cf1eb, 1) && L.c[0].a[0] == (uintptr_t)(uint32_t)(int32_t)words[n]);
                if (rets[m] == 0) {
                    CK(L.n == 2 && is_call(1, 0x4fba69, 0x5c3a67, 1) && L.c[1].a[0] == p_addr(PAT_S1_2FD) && get32(L.c[1].probe, 0) == 1);   /* (the state is stored after the call) */
                    CK(get32(P_REC(w, 3), 0x4d) == 2);
                } else {
                    CK(L.n == 1 && get32(P_REC(w, 3), 0x4d) == 1);
                }
                CK(memcmp(p_self, p_exp, sizeof p_self) == 0 && get32(P_REC(w, 2), 0x4d) == 1);
            }
    }
    /* v = 4: the deadline [self+0x4b] against the tick (unsigned >=); then the compare of rec+0x2fd with 0x54b1e0 */
    {
        static const struct { uint32_t deadline, now; int due; } cases[] = {
            {100, 99, 0}, {100, 100, 1}, {100, 101, 1}, {0x80000000u, 0x7fffffffu, 0}, {0x7fffffffu, 0x80000000u, 1}, {0, 0xffffffffu, 1},
            {0xffffffffu, 0, 0}, {0x80000000u, 0x80000000u, 1},
        };
        for (n = 0; n < sizeof cases / sizeof cases[0]; n++)
            for (k = 0; k < 4; k++) {   /* 0: equal; 1..3: a difference at the first / fifth / ninth byte */
                p_prepare(&w, 2, 1);
                set16(p_self, 0x1e, 3);
                set32(P_REC(w, 3), 0x4d, 1);
                set32(p_self, 0x24, 4);
                set32(p_self, 0x4b, cases[n].deadline);
                set16(p_rec, 0x31e, 0x0abc);
                L.tick = cases[n].now;
                if (k > 0) p_break(PAT_S1_2FD, k == 1 ? 0 : k == 2 ? 4 : 8);
                L.probe_ptr[0] = p_self + 0x24;
                L.probe_len[0] = 4;
                L.probe_ptr[1] = P_REC(w, 3) + 0x4d;
                L.probe_len[1] = 4;
                L.nprobe = 2;
                memcpy(p_exp, p_self, sizeof p_exp);
                p_run(&w, 2);
                CK(L.ticks == 1);
                if (!cases[n].due) {
                    CK(L.n == 0 && memcmp(p_self, p_exp, sizeof p_self) == 0 && get32(P_REC(w, 3), 0x4d) == 1);
                } else if (k > 0) {
                    set32(p_exp, 0x24, 3);   /* (stored after the two calls) */
                    CK(L.n == 2 && is_call(0, 0x4fb77a, 0x5c3a67, 1) && L.c[0].a[0] == p_addr(PAT_S1_2FD) && get32(L.c[0].probe, 0) == 4 && get32(L.c[0].probe, 4) == 1);
                    CK(is_call(1, 0x4fb2e3, 0x5c3a67, 1) && (L.c[1].a[0] & 0xffff) == 0x0abc && get32(L.c[1].probe, 0) == 4);
                    CK(memcmp(p_self, p_exp, sizeof p_self) == 0 && get32(P_REC(w, 3), 0x4d) == 1);
                } else {
                    CK(L.n == 0 && memcmp(p_self, p_exp, sizeof p_self) == 0 && get32(P_REC(w, 3), 0x4d) == 2);
                }
            }
    }
    /* v > 4: nothing, not even the tick */
    {
        static const uint32_t vs[] = {5, 6, 0x100, 0x80000000u, 0xffffffffu};
        for (n = 0; n < sizeof vs / sizeof vs[0]; n++) {
            p_prepare(&w, 2, 1);
            set32(p_self, 0x24, vs[n]);
            memcpy(p_exp, p_self, sizeof p_exp);
            p_run(&w, 2);
            CK(L.n == 0 && L.ticks == 0 && memcmp(p_self, p_exp, sizeof p_self) == 0 && get32(P_REC(w, 2), 0x4d) == 1 && w.value_5bb1ca == 0);
        }
    }
    /* ---- state 2 ---- */
    {
        static const struct {
            int base;     /* 1: [self+0x43] (group 0x32e), 2: [self+0x47] only (group 0x2e2), 3: both (the first group is used), 0: neither */
            int first;    /* the signed word at the group's first offset */
            int flag;     /* the signed word at +0x14 */
            int index;    /* the signed word at +0x16 (-1: none) */
        } cases[] = {
            {1, 0x270f, 1, 3}, {1, 0x270e, 1, 3}, {1, 0x2710, 1, 9}, {1, 0, 0, -1}, {1, -1, 2, 9}, {1, 5, 0x101, -3}, {1, 5, -1, 9}, {1, 0x270f, 0, -1},
            {2, 0x270f, 1, 3}, {2, 0x270e, 1, 3}, {2, 0x2710, 1, 9}, {2, 0, 0, -1}, {2, -1, 2, 9}, {2, 5, 0x101, -3}, {2, 5, -1, 9}, {2, 0x270f, 0, -1},
            {3, 0x270e, 1, 3}, {3, 7, 0, 9}, {0, 7, 1, 9},
        };
        for (n = 0; n < sizeof cases / sizeof cases[0]; n++)
            for (mask = 0; mask < 8; mask++) {
                int b = cases[n].base;
                ptrdiff_t g = (b == 1 || b == 3) ? 0x32e : 0x2e2, og = (b == 1 || b == 3) ? 0x2e2 : 0x32e;
                uint32_t expect_57b = 0x66, expect_999 = 0x77, expect_1ca = 1;
                uint32_t v43 = (b == 1 || b == 3) ? 0x100u : 0, v47 = (b == 2 || b == 3) ? 0x1000000u : 0;
                int c = 0;
                p_prepare(&w, 2, 2);
                set16(p_self, 0x1e, 3);
                set32(p_self, 0x43, v43);
                set32(p_self, 0x47, v47);
                set16(p_rec, g, (uint16_t)cases[n].first);
                set16(p_rec, g + 2, 0x1111);
                set16(p_rec, g + 4, 0x2222);
                set16(p_rec, g + 6, 0x3333);
                set32(p_rec, g + 8, 0x44444444u);
                set32(p_rec, g + 0xc, 0x55555555u);
                set32(p_rec, g + 0x10, 0x66666666u);
                set16(p_rec, g + 0x14, (uint16_t)cases[n].flag);
                set16(p_rec, g + 0x16, (uint16_t)cases[n].index);
                p_rec[g + 0x18] = 0xc3;
                /* the other group holds words that must not be used */
                set16(p_rec, og, 0x0101);
                set16(p_rec, og + 0x14, 1);
                set16(p_rec, og + 0x16, 0x0001);
                p_rec[og + 0x18] = 0xd4;
                if (mask & 1) p_break(PAT_S2_24F, 0);
                if (mask & 2) p_break(PAT_S2_280, 4);
                if (mask & 4) p_break(PAT_S2_2B1, 8);
                w.value_5bb1ca = 0x55;
                w.value_5bb57b = 0x66;
                w.value_583999 = 0x77;
                memcpy(p_fexp, p_flags, sizeof p_fexp);
                /* every call sees 0x5bb1ca = 1 already; 0x42ba3a and 0x461862 see the final globals and flags */
                L.probe_ptr[0] = (const uint8_t *)&w.value_5bb1ca;
                L.probe_len[0] = 4;
                L.probe_ptr[1] = (const uint8_t *)&w.value_583999;
                L.probe_len[1] = 4;
                L.probe_ptr[2] = P_FLAG(w, 9);
                L.probe_len[2] = 4;
                L.nprobe = 3;
                memcpy(p_exp, p_self, sizeof p_exp);
                p_run(&w, 2);
                for (k = 0; k < 3; k++) {
                    static const int pats[3] = {PAT_S2_24F, PAT_S2_280, PAT_S2_2B1};
                    if (mask & (1 << k)) {
                        CK(is_call(c, 0x4fba69, 0x5c3a67, 1) && L.c[c].a[0] == p_addr(pats[k]) && get32(L.c[c].probe, 0) == 1 && get32(L.c[c].probe, 4) == 0x77);
                        c++;
                    }
                }
                CK(is_call(c, 0x42ba3a, 0, 1) && (L.c[c].a[0] & 0xffff) == 3 && is_call(c + 1, 0x461862, (uintptr_t)p_self, 0) && L.n == c + 2);
                CK(memcmp(p_self, p_exp, sizeof p_self) == 0);
                if (b != 0) {
                    if (cases[n].first != 0x270f) {
                        CK(w.word_5bb599 == 0x1111 && w.word_5bb595 == 0x2222 && w.word_5c39ff == 0x3333 && w.value_5bb59b == 0x44444444u &&
                           w.value_5bb59f == 0x55555555u && w.value_5bb5a3 == 0x66666666u);
                        expect_57b = (uint32_t)(int32_t)cases[n].first;
                        expect_999 = 4;
                        expect_1ca = cases[n].flag == 1 ? 0 : 1;
                    } else {
                        CK(w.word_5bb599 == 0 && w.word_5bb595 == 0 && w.word_5c39ff == 0 && w.value_5bb59b == 0 && w.value_5bb59f == 0 && w.value_5bb5a3 == 0);
                    }
                    if (cases[n].index != -1) set32(p_fexp + 0x40, cases[n].index * 4, 0xc3);
                } else {
                    CK(w.word_5bb599 == 0 && w.value_5bb59b == 0);
                }
                CK(w.value_5bb57b == expect_57b && w.value_583999 == expect_999 && w.value_5bb1ca == expect_1ca);
                CK(memcmp(p_flags, p_fexp, sizeof p_flags) == 0);
                /* call-time: 0x5bb1ca, 0x583999 and the flag dword 9 are final before 0x42ba3a */
                CK(get32(L.c[c].probe, 0) == expect_1ca && get32(L.c[c].probe, 4) == expect_999);
                CK(get32(L.c[c].probe, 8) == (b != 0 && cases[n].index == 9 ? 0xc3u : 0x44444444u));
                CK(get32(P_REC(w, 2), 0x4d) == 2);
            }
    }
}

/* ---- 0x461d82 ---- */

#define Q_VA 0x00d40000u

static uint8_t q_self[0x100], q_exp[0x100], q_rec[0x300], q_records[0x8d * 6], q_cells[0x780], q_cexp[0x780];

#define Q_CELL(r, c) (q_cells + 0x2d0 + (ptrdiff_t)(r)*0x140 + (ptrdiff_t)(c)*0x28)
#define QE_CELL(r, c) (q_cexp + 0x2d0 + (ptrdiff_t)(r)*0x140 + (ptrdiff_t)(c)*0x28)

static void q_prepare(Fl22aWorld *w, int rec_index, int row, int col, int16_t word57, int16_t divisor, int32_t d4f, int32_t d53, int16_t counter)
{
    reset_log();
    add_region(Q_VA, q_rec, sizeof q_rec);
    memset(q_self, 0x5a, sizeof q_self);
    memset(q_records, 0x11, sizeof q_records);
    fill(q_rec, sizeof q_rec, 0x31);
    fill(q_cells, sizeof q_cells, 0x77);
    memset(w, 0, sizeof *w);
    w->records_5bb5e5 = q_records + 0x8d;
    w->cells_594db5 = q_cells + 0x2d0;
    set32(q_records + 0x8d + (ptrdiff_t)rec_index * 0x8d, 0, Q_VA);
    set16(q_self, 0x1e, (uint16_t)rec_index);
    set16(q_rec, 0x24a, (uint16_t)divisor);
    set16(q_self, 0x5b, (uint16_t)row);
    set16(q_self, 0x5d, (uint16_t)col);
    set16(q_self, 0x57, (uint16_t)word57);
    set32(q_self, 0x4f, (uint32_t)d4f);
    set32(q_self, 0x53, (uint32_t)d53);
    set16(q_self, 0x59, (uint16_t)counter);
    set16(q_self, 0x39, 0x4321);
    set32(q_self, 0x3b, 0x12345678u);
}

static int32_t q_run(Fl22aWorld *w)
{
    Fl18Host h = host();
    return m461d82_move_step(q_self, w, &h);
}

/* the expectations come from the four arms of the disassembly: word57, [self+src], the cell field to adjust, its sign, the cell field to derive,
 * the axis (0 = column word +0x5d, 1 = row word +0x5b) and its step */
static const struct {
    int16_t w57;
    int src, plus, field_a, field_b, row_axis, delta;
} q_arms[4] = {
    {0x10, 0x4f, 0, 0x14, 0x1c, 0, -1}, {0x11, 0x53, 0, 0x18, 0x20, 1, -1}, {0x12, 0x53, 1, 0x18, 0x20, 1, 1}, {0x13, 0x4f, 1, 0x14, 0x1c, 0, 1},
};

static void test_m461d82_move_step(void)
{
    (void)m461d82_move_step; /* driven through the file's runner helper; named here so the test pointer finds it */
    Fl22aWorld w;
    size_t n;
    int arm;
    static const struct {
        int row, col;
        int16_t divisor;
        int32_t d4f, d53;
        int complete;     /* the counter reaches the divisor */
        int f24zero;      /* the word cell+0x24 is 0 */
    } cases[] = {
        {1, 1, 4, 100, 200, 0, 0},       {1, 1, 4, 100, 200, 1, 0},       {1, 1, 4, 100, 200, 1, 1},       {0, 0, 2, 7, 7, 1, 1},
        {-1, 2, 2, -7, -7, 1, 0},        {2, -1, -2, 7, -7, 1, 1},        {1, 2, -2, -7, 7, 0, 1},         {0, 1, 3, 0, 0, 1, 0},
        {1, 0, 1, 12345, -12345, 1, 1},  {2, 2, -3, 0x7fffffff, -0x7fffffff, 1, 0}, {0, 2, 0x7fff, 0x7fffffff, 5, 1, 1}, {1, 1, -32768, 100, 100, 1, 1},
        {-1, -1, 5, 3, 4, 1, 0},         {2, 1, 7, -(1 << 30), 1 << 30, 0, 0},
    };
    for (arm = 0; arm < 4; arm++)
        for (n = 0; n < sizeof cases / sizeof cases[0]; n++) {
            const int r = cases[n].row, c = cases[n].col;
            const int32_t dividend = q_arms[arm].src == 0x4f ? cases[n].d4f : cases[n].d53;
            const int32_t divisor = cases[n].divisor;
            const int16_t counter = cases[n].complete ? (int16_t)(divisor - 1) : (int16_t)(divisor + 5);
            const int rr = q_arms[arm].row_axis ? r + q_arms[arm].delta : r, cc = q_arms[arm].row_axis ? c : c + q_arms[arm].delta;
            uint8_t *e;
            const uint8_t *cell0;
            int32_t q = dividend / divisor, result;
            uint32_t na, nb;
            q_prepare(&w, 2, r, c, q_arms[arm].w57, (int16_t)divisor, cases[n].d4f, cases[n].d53, counter);
            if (cases[n].f24zero) set16(Q_CELL(r, c), 0x24, 0);
            else set16(Q_CELL(r, c), 0x24, 0x0100);
            memcpy(q_cexp, q_cells, sizeof q_cexp);
            memcpy(q_exp, q_self, sizeof q_exp);
            cell0 = QE_CELL(r, c);
            L.probe_ptr[0] = Q_CELL(r, c);
            L.probe_len[0] = 0x28;
            L.probe_ptr[1] = q_self + 0x59;
            L.probe_len[1] = 2;
            L.probe_ptr[2] = q_self + 0x3b;
            L.probe_len[2] = 4;
            L.nprobe = 3;
            result = q_run(&w);
            /* the expected self: the copy of the four dwords of the cell, the counter, and on completion the axis, the counter, +0x3b */
            memcpy(q_exp + 0x29, cell0 + 0x14, 16);
            e = QE_CELL(r, c);
            na = q_arms[arm].plus ? get32(e, q_arms[arm].field_a) + (uint32_t)q : get32(e, q_arms[arm].field_a) - (uint32_t)q;
            nb = na + (uint32_t)dividend;
            set32(e, q_arms[arm].field_a, na);
            set32(e, q_arms[arm].field_b, nb);
            set16(q_exp, 0x59, (uint16_t)(counter + 1));
            if (cases[n].complete) {
                CK(L.n == 1 && is_call(0, 0x462b84, (uintptr_t)q_self, 4));
                CK((L.c[0].a[0] & 0xffff) == (uint16_t)r && (L.c[0].a[1] & 0xffff) == (uint16_t)c && L.c[0].a[2] == 0 &&
                   L.c[0].a[3] == 0x594db5u + (uint32_t)(r * 0x140 + c * 0x28) + 0x14u);
                set16(e, 0x26, 0);
                if (cases[n].f24zero) set32(e, 0, 0);
                /* at the call: the cell holds the new fields, +0x26 is 0, +0 is 0 when +0x24 is 0; the counter is already advanced, +0x3b not yet */
                CK(memcmp(L.c[0].probe, e, 0x28) == 0 && get16(L.c[0].probe, 0x28) == (uint16_t)(counter + 1) && get32(L.c[0].probe, 0x2a) == 0x12345678u);
                e = QE_CELL(rr, cc);
                set16(e, 0x26, 0x4321);
                set32(e, 0, 1);
                set16(q_exp, 0x59, 0);
                set32(q_exp, 0x3b, 1);
                if (q_arms[arm].row_axis) set16(q_exp, 0x5b, (uint16_t)rr);
                else set16(q_exp, 0x5d, (uint16_t)cc);
                CK(result == 1);
            } else {
                CK(L.n == 0 && result == 0);
            }
            CK(memcmp(q_self, q_exp, sizeof q_self) == 0);
            CK(memcmp(q_cells, q_cexp, sizeof q_cells) == 0);
        }
    /* the callee's stores are read where the original reads them: it moves the column / row and the word [self+0x39] */
    for (arm = 0; arm < 4; arm++) {
        const int r = 1, c = 1;
        int rr, cc;
        q_prepare(&w, 1, r, c, q_arms[arm].w57, 3, 30, 60, 2);
        set16(Q_CELL(r, c), 0x24, 5);
        memcpy(q_cexp, q_cells, sizeof q_cexp);
        queue_write(0x462b84, 0, -1, 0x5b, 2, (uint32_t)(uint16_t)-1);   /* row := -1 */
        queue_write(0x462b84, 0, -1, 0x5d, 2, 2);                       /* column := 2 */
        queue_write(0x462b84, 0, -1, 0x39, 2, 0xbeef);
        CK(q_run(&w) == 1 && L.n == 1);
        /* the axis step is applied to the stored value; the +0x26 word and +0 go to the cell of the new row / column */
        rr = q_arms[arm].row_axis ? -1 + q_arms[arm].delta : -1;
        cc = q_arms[arm].row_axis ? 2 : 2 + q_arms[arm].delta;
        CK((int16_t)get16(q_self, 0x5b) == rr && (int16_t)get16(q_self, 0x5d) == cc);
        CK(get16(Q_CELL(rr, cc), 0x26) == 0xbeef && get32(Q_CELL(rr, cc), 0) == 1);
        CK(get16(Q_CELL(1, 1), 0x26) == 0 && get32(Q_CELL(1, 1), 0) == get32(q_cexp + 0x2d0 + 0x140 + 0x28, 0));   /* (+0x24 is 5: the old cell keeps its dword +0) */
    }
    /* any other selector: only the copy of the four dwords, result 0, no tick and no call */
    {
        static const int16_t sel[] = {0x0f, 0x14, 0, -1, 0x7fff, -32768, 0x110, 0x1f};
        for (n = 0; n < sizeof sel / sizeof sel[0]; n++) {
            q_prepare(&w, 0, 1, 1, sel[n], 4, 100, 200, 3);
            memcpy(q_cexp, q_cells, sizeof q_cexp);
            memcpy(q_exp, q_self, sizeof q_exp);
            memcpy(q_exp + 0x29, Q_CELL(1, 1) + 0x14, 16);
            CK(q_run(&w) == 0 && L.n == 0 && L.ticks == 0 && memcmp(q_self, q_exp, sizeof q_self) == 0 && memcmp(q_cells, q_cexp, sizeof q_cells) == 0);
        }
    }
    /* the rejected divisions (the original faults): divisor 0 and INT32_MIN / -1; the copy of the four dwords was made before, nothing after */
    for (arm = 0; arm < 4; arm++)
        for (n = 0; n < 2; n++) {
            q_prepare(&w, 0, 1, 1, q_arms[arm].w57, n ? -1 : 0, (int32_t)0x80000000u, (int32_t)0x80000000u, -1);
            memcpy(q_cexp, q_cells, sizeof q_cexp);
            memcpy(q_exp, q_self, sizeof q_exp);
            memcpy(q_exp + 0x29, Q_CELL(1, 1) + 0x14, 16);
            CK(q_run(&w) == 0 && L.n == 0 && memcmp(q_self, q_exp, sizeof q_self) == 0 && memcmp(q_cells, q_cexp, sizeof q_cells) == 0);
        }
    /* a plain INT32_MIN / 1 and INT32_MIN / 2 are not faults */
    q_prepare(&w, 0, 1, 1, 0x10, 2, (int32_t)0x80000000u, 0, 5);
    memcpy(q_cexp, q_cells, sizeof q_cexp);
    CK(q_run(&w) == 0 && get32(Q_CELL(1, 1), 0x14) == get32(q_cexp + 0x2d0 + 0x140 + 0x28, 0x14) + 0x40000000u && get16(q_self, 0x59) == 6);
}

/* ---- 0x4778df ---- */

#define R_VA 0x00d50000u
#define R_5D15E3 0x0a5d15e3u
#define R_5CF665 0x0b5cf665u
#define R_622FCA 0x0c622fcau
#define R_DWORD 0x0d5d1599u   /* the dword at 0x5d1599 + 4 * 0x4a (word 0x622fc2 = 1) */
#define R_OX 100
#define R_OY (-7)
#define HOSTPTR ((uintptr_t)-1)

static uint8_t r_rec[0x700], r_records[0x8d * 6], r_tbl[0x300], r_t5d[0x4a * 5], r_d5a[20];

typedef struct Exp {
    uint32_t callee;
    uintptr_t this_ptr;
    int n;
    uintptr_t a[5];
    int rect_arg;       /* the argument that points to the 16-byte rectangle local (-1: none) */
    uint32_t rect[4];
    int buf_arg;        /* the argument that points to the text buffer (-1: none) */
    uint32_t buf0;
} Exp;

static Exp r_x[80];
static int r_nx;

static void xcall(uint32_t callee, uintptr_t this_ptr, int n, uintptr_t a0, uintptr_t a1, uintptr_t a2, uintptr_t a3, uintptr_t a4)
{
    Exp *e = &r_x[r_nx++];
    memset(e, 0, sizeof *e);
    e->callee = callee;
    e->this_ptr = this_ptr;
    e->n = n;
    e->a[0] = a0;
    e->a[1] = a1;
    e->a[2] = a2;
    e->a[3] = a3;
    e->a[4] = a4;
    e->rect_arg = -1;
    e->buf_arg = -1;
}

static void xrect(int arg, uint32_t l, uint32_t t, uint32_t r, uint32_t b)
{
    Exp *e = &r_x[r_nx - 1];
    e->rect_arg = arg;
    e->rect[0] = l;
    e->rect[1] = t;
    e->rect[2] = r;
    e->rect[3] = b;
    e->a[arg] = HOSTPTR;
}

static void xbuf(uint32_t first_dword)
{
    Exp *e = &r_x[r_nx - 1];
    e->buf_arg = 0;
    e->buf0 = first_dword;
    e->a[0] = HOSTPTR;
}

static int r_match(void)
{
    int i, k;
    if (L.n != r_nx) return 0;
    for (i = 0; i < r_nx; i++) {
        const Exp *e = &r_x[i];
        if (!is_call(i, e->callee, e->this_ptr, e->n)) return 0;
        for (k = 0; k < e->n; k++) {
            if (e->a[k] == HOSTPTR) {
                if (!((uint64_t)L.c[i].a[k] > 0xffffffffu)) return 0;
            } else if (L.c[i].a[k] != e->a[k]) {
                return 0;
            }
        }
        if (e->rect_arg >= 0 && memcmp(L.c[i].pd[e->rect_arg], e->rect, 16) != 0) return 0;
        if (e->buf_arg >= 0) {
            uint8_t want[16];
            memset(want, 0, sizeof want);
            memcpy(want, &e->buf0, 4);
            if (memcmp(L.c[i].pd[e->buf_arg], want, 16) != 0) return 0;
        }
    }
    return 1;
}

#define RR(off) (0x01000000u + (uint32_t)(off)*16u)   /* the dword of the record at `off` */

static void r_prepare(Fl22aWorld *w, int index)
{
    int off;
    reset_log();
    add_region(R_VA, r_rec, sizeof r_rec);
    r_nx = 0;
    memset(r_rec, 0x5c, sizeof r_rec);
    memset(r_records, 0x11, sizeof r_records);
    memset(r_tbl, 0, sizeof r_tbl);
    memset(r_t5d, 0x22, sizeof r_t5d);
    memset(r_d5a, 0, sizeof r_d5a);
    memset(w, 0, sizeof *w);
    w->records_5bb5e5 = r_records + 0x8d;
    w->table_622fd2 = r_tbl;
    w->table_5d1599 = r_t5d + 0x4a;
    w->dwords_5a0549 = r_d5a;
    set32(r_records + 0x8d + (ptrdiff_t)index * 0x8d, 0, R_VA);
    w->word_622fc4 = (int16_t)index;
    w->word_622fc2 = 1;
    set32(r_t5d + 0x4a + 0x4a, 0, R_DWORD);
    w->value_5d15e3 = R_5D15E3;
    w->value_5cf665 = R_5CF665;
    w->value_622fca = R_622FCA;
    w->origin_x_583186 = R_OX;
    w->origin_y_58318a = R_OY;
    for (off = 0x678; off <= 0x6ec; off += 4) set32(r_rec, (size_t)off, RR(off));
    set16(r_rec, 0x42, 0);
    set16(r_rec, 0x44, 0);
    set16(r_rec, 0x63e, 0);
    r_rec[0x238] = 0;
    r_rec[0x63d] = 0;
    r_rec[0x23e] = 0;
}

static void r_run(Fl22aWorld *w)
{
    Fl18Host h = host();
    m4778df_render(w, &h);
}

/* the rectangle that the original builds from the four dwords at base .. base + 0xc */
static void x_rect_args(int arg, uint32_t base)
{
    xrect(arg, RR(base) + (uint32_t)R_OX, RR(base + 4) + (uint32_t)R_OY, RR(base + 8) + (uint32_t)R_OX, RR(base + 0xc) + (uint32_t)R_OY);
}

static void test_m4778df_render(void)
{
    (void)m4778df_render; /* driven through the file's runner helper; named here so the test pointer finds it */
    Fl22aWorld w;
    int mask, i, j;
    /* ---- step 1 and the empty scene: the byte 0x6237a4 selects the first call and is cleared after it; value 6 selects the other branch ---- */
    for (mask = 0; mask < 6; mask++) {
        static const uint32_t modes[6] = {0, 5, 7, 0xffffffffu, 0x100, 6};
        for (i = 0; i < 3; i++) {   /* the byte: 0, 1, 0xff */
            static const uint8_t bytes[3] = {0, 1, 0xff};
            r_prepare(&w, 2);
            w.byte_6237a4 = bytes[i];
            w.value_622fce = modes[mask];
            L.probe_ptr[0] = &w.byte_6237a4;
            L.probe_len[0] = 1;
            L.nprobe = 1;
            r_run(&w);
            if (bytes[i] != 0) {
                xcall(0x4c5377, 0x5cf659, 5, R_5D15E3, R_5CF665, 0x583196, 0x583186, 0x54c9b0);
                CK(L.c[0].probe[0] == bytes[i]);   /* (the byte is cleared after the call) */
            }
            CK(r_match() && w.byte_6237a4 == 0 && L.ticks == 0);
        }
    }
    /* ---- the grid: i < signed word [rec+0x42], j < signed word [rec+0x44]; entry e = 0x622fd2 + i * 0xc8 + j * 0x14 ---- */
    {
        static const struct { int16_t ni, nj; } limits[] = {{2, 3}, {1, 1}, {0, 3}, {3, 0}, {-1, 2}, {2, -1}, {-32768, 5}, {1, 2}, {3, 4}};
        size_t n;
        for (n = 0; n < sizeof limits / sizeof limits[0]; n++)
            for (mask = 0; mask < 3; mask++) {
                static const int16_t words[3] = {5, -3, 0x1234};
                r_prepare(&w, 2);
                w.value_622fce = 0;
                set16(r_rec, 0x42, (uint16_t)limits[n].ni);
                set16(r_rec, 0x44, (uint16_t)limits[n].nj);
                for (i = 0; i < 4; i++)
                    for (j = 0; j < 5; j++) {
                        uint8_t *e = r_tbl + i * 0xc8 + j * 0x14;
                        e[0] = (uint8_t)(((i + j) & 1) ? 0 : 0x80 + j);       /* checkerboard: some entries are skipped */
                        e[1] = (uint8_t)((i * 5 + j) % 3 == 0 ? 0 : 0xff);    /* the second byte selects the call */
                        set16(e, 2, (uint16_t)words[(i + j + mask) % 3]);
                    }
                r_run(&w);
                for (i = 0; i < limits[n].ni; i++)
                    for (j = 0; j < limits[n].nj; j++) {
                        const uint8_t *e = r_tbl + i * 0xc8 + j * 0x14;
                        const uint32_t e_va = 0x622fd2u + (uint32_t)(i * 0xc8 + j * 0x14);
                        if (e[0] == 0) continue;
                        if (e[1] == 0)
                            xcall(0x4c5377, 0x5cf659, 5, R_DWORD, R_5CF665, R_VA + (uint32_t)((int)(int16_t)get16(e, 2) * 16) + 0x58u, e_va + 4u, 0x54c9d8);
                        else
                            xcall(0x4c5377, 0x5cf659, 5, R_DWORD, R_5CF665, R_VA + 0x646u, e_va + 4u, 0x54c9f0);
                    }
                CK(r_match());
            }
    }
    /* the dword of the grid call is read at 0x5d1599 + n * 0x4a for the signed word n = 0x622fc2 */
    {
        static const int16_t ns[] = {-1, 0, 2, 3};
        size_t n;
        for (n = 0; n < sizeof ns / sizeof ns[0]; n++) {
            r_prepare(&w, 2);
            w.value_622fce = 0;
            w.word_622fc2 = ns[n];
            set16(r_rec, 0x42, 1);
            set16(r_rec, 0x44, 1);
            r_tbl[0] = 1;
            r_tbl[1] = 0;
            set32(r_t5d + 0x4a + ns[n] * 0x4a, 0, 0xfeed0000u + (uint32_t)(ns[n] & 0xff));
            r_run(&w);
            xcall(0x4c5377, 0x5cf659, 5, 0xfeed0000u + (uint32_t)(ns[n] & 0xff), R_5CF665, R_VA + 0x58u + 0u + (uint32_t)((int)(int16_t)get16(r_tbl, 2) * 16), 0x622fd6, 0x54c9d8);
            CK(r_match());
        }
    }
    /* ---- every group after the grid (value != 6): all combinations of the eleven conditions, the grid empty ---- */
    for (mask = 0; mask < 2048; mask++) {
        const int a4 = mask & 1, g238 = (mask >> 1) & 1, a2 = (mask >> 2) & 1, a5 = (mask >> 3) & 1, g63d = (mask >> 4) & 1, a3 = (mask >> 5) & 1,
                  diff6a8 = (mask >> 6) & 1, f3a = (mask >> 7) & 1, f3b = (mask >> 8) & 1, diff23e = (mask >> 9) & 1, diff819 = (mask >> 10) & 1;
        r_prepare(&w, 3);
        w.value_622fce = 0x22;
        w.byte_6237a4 = (uint8_t)(a4 ? 0x80 : 0);
        r_rec[0x238] = (uint8_t)(g238 ? 0xff : 0);
        w.byte_6237a2 = (uint8_t)(a2 ? 3 : 0);
        w.byte_6237a5 = (uint8_t)(a5 ? 2 : 0);
        r_rec[0x63d] = (uint8_t)(g63d ? 0x40 : 0);
        w.byte_6237a3 = (uint8_t)(a3 ? 9 : 0);
        w.byte_6237f8 = 0x31;
        w.byte_63a88c = (uint8_t)(diff6a8 ? 0x32 : 0x31);
        w.byte_62383a = (uint8_t)(f3a ? 4 : 0);
        w.byte_62383b = (uint8_t)(f3b ? 6 : 0);
        r_rec[0x23e] = 0x41;
        w.byte_63a890 = (uint8_t)(diff23e ? 0x40 : 0x41);
        w.byte_623819 = 0x51;
        w.byte_63a894 = (uint8_t)(diff819 ? 0x50 : 0x51);
        L.probe_ptr[0] = &w.byte_6237a4;
        L.probe_len[0] = 1;
        L.probe_ptr[1] = &w.byte_6237a5;
        L.probe_len[1] = 1;
        L.probe_ptr[2] = &w.byte_6237a3;
        L.probe_len[2] = 1;
        L.probe_ptr[3] = &w.byte_62383b;
        L.probe_len[3] = 1;
        L.nprobe = 4;
        r_run(&w);
        if (a4) xcall(0x4c5377, 0x5cf659, 5, R_5D15E3, R_5CF665, 0x583196, 0x583186, 0x54c9b0);
        if (g238) {
            if (a2) {
                xcall(0x475cc4, 0x622fa2, 2, 0x6237a6, R_VA + 0x6b8u, 0, 0, 0);
                xcall(0x4c5377, 0x5cf659, 5, R_DWORD, R_5CF665, 0x6237c7, 0, 0x54ca08);
                x_rect_args(3, 0x6c8);
            } else if (a5) {
                xcall(0x4c5377, 0x5cf659, 5, R_5D15E3, R_5CF665, R_VA + 0x6b8u, 0, 0x54ca18);
                x_rect_args(3, 0x6b8);
                xcall(0x4c5377, 0x5cf659, 5, R_5D15E3, R_5CF665, R_VA + 0x6c8u, 0, 0x54ca3c);
                x_rect_args(3, 0x6c8);
            }
        }
        if (g63d) {
            if (a3) {
                xcall(0x4c5377, 0x5cf659, 5, R_5D15E3, R_5CF665, R_VA + 0x698u, 0, 0x54ca4c);
                x_rect_args(3, 0x698);
            }
            xcall(0x475cc4, 0x622fa2, 2, 0x6237d7, R_VA + 0x698u, 0, 0, 0);
        }
        if (diff6a8) {
            xcall(0x4c5377, 0x5cf659, 5, R_5D15E3, R_5CF665, R_VA + 0x6a8u, 0, 0x54ca70);
            x_rect_args(3, 0x6a8);
            xcall(0x475cc4, 0x622fa2, 2, 0x6237f8, R_VA + 0x6a8u, 0, 0, 0);
        }
        if (f3a) {
            xcall(0x4c5377, 0x5cf659, 5, R_DWORD, R_5CF665, R_VA + 0x48u, 0, 0x54ca88);
            x_rect_args(3, 0x678);
        } else if (f3b) {
            xcall(0x4c5377, 0x5cf659, 5, R_5D15E3, R_5CF665, R_VA + 0x678u, 0, 0x54caa8);
            x_rect_args(3, 0x678);
        }
        if (diff23e) xcall(0x475cc4, 0x622fa2, 2, R_VA + 0x23eu, R_VA + 0x668u, 0, 0, 0);
        if (diff819) xcall(0x475cc4, 0x622fa2, 2, 0x623819, R_VA + 0x688u, 0, 0, 0);
        CK(r_match());
        /* the flags 0x6237a4 / 0x6237a5 / 0x6237a3 / 0x62383b are cleared exactly when their group ran; the call-time probes see them set */
        CK(w.byte_6237a4 == 0);
        CK(w.byte_6237a5 == (uint8_t)((g238 && !a2 && a5) ? 0 : (a5 ? 2 : 0)));
        CK(w.byte_6237a3 == (uint8_t)((g63d && a3) ? 0 : (a3 ? 9 : 0)));
        CK(w.byte_62383b == (uint8_t)((!f3a && f3b) ? 0 : (f3b ? 6 : 0)));
        CK(w.byte_6237a2 == (uint8_t)(a2 ? 3 : 0) && w.byte_62383a == (uint8_t)(f3a ? 4 : 0));
        {
            int c;
            for (c = 0; c < r_nx; c++) {   /* each draw call (0x4c5377) sees the flags that are not yet cleared by its own group */
                if (r_x[c].callee != 0x4c5377) continue;
                if (r_x[c].a[4] == 0x54c9b0) CK(L.c[c].probe[0] != 0);
                if (r_x[c].a[4] == 0x54ca18 || r_x[c].a[4] == 0x54ca3c) CK(L.c[c].probe[1] == 2);
                if (r_x[c].a[4] == 0x54ca4c) CK(L.c[c].probe[2] == 9);
                if (r_x[c].a[4] == 0x54caa8) CK(L.c[c].probe[3] == 6);
            }
        }
    }
    /* the rectangle arithmetic wraps like the original's 32-bit adds */
    r_prepare(&w, 1);
    w.value_622fce = 0;
    w.origin_x_583186 = (int32_t)0x80000000u;
    w.origin_y_58318a = 0x7fffffff;
    w.byte_62383a = 1;
    r_rec[0x238] = 0;
    set32(r_rec, 0x678, 0x80000000u);
    set32(r_rec, 0x67c, 2);
    set32(r_rec, 0x680, 0xffffffffu);
    set32(r_rec, 0x684, 0x7fffffffu);
    r_run(&w);
    xcall(0x4c5377, 0x5cf659, 5, R_DWORD, R_5CF665, R_VA + 0x48u, 0, 0x54ca88);
    xrect(3, 0, 0x80000001u, 0x7fffffffu, 0xfffffffeu);
    CK(r_match());
    /* ---- value 6: the caption rows ---- */
    {
        static const struct { uint32_t ret; int16_t k; int16_t count; } cases[] = {
            {0, 0, 1}, {5, 1, 5}, {0xfff5, 3, 0x7fff}, {0x7ff3, -1, 2}, {0xffff, 0x7f, 1}, {0xffff0005u, 2, 3},
            {0x8000, 1, 1}, {2, 5, 0}, {2, 5, -1}, {2, 5, -32768},
        };
        size_t n;
        for (n = 0; n < sizeof cases / sizeof cases[0]; n++) {
            r_prepare(&w, 2);
            w.value_622fce = 6;
            w.byte_6237a4 = 0;
            set16(r_rec, 0x42, 2);   /* (the grid is skipped for value 6) */
            set16(r_rec, 0x44, 2);
            r_tbl[0] = 1;
            set16(r_rec, 0x63e, (uint16_t)cases[n].count);
            set16(r_rec, 0x23a, (uint16_t)cases[n].k);
            set32(r_d5a, 0, 0xa0a0a0a0u);
            set32(r_d5a, 4, 0xa1a1a1a1u);
            set32(r_d5a, 8, 0xa2a2a2a2u);
            set32(r_d5a, 12, 0xa3a3a3a3u);
            set32(r_d5a, 16, 0xa4a4a4a4u);
            queue_return(0x4d3836, cases[n].ret);
            queue_write(0x50ca3e, 0, 0, 0, 4, 0x11111111u);
            queue_write(0x50ca3e, 1, 0, 0, 4, 0x22222222u);
            queue_write(0x50ca3e, 2, 0, 0, 4, 0x33333333u);
            queue_write(0x50ca3e, 3, 0, 0, 4, 0x44444444u);
            queue_write(0x50ca3e, 4, 0, 0, 4, 0x55555555u);
            queue_write(0x50ca3e, 5, 0, 0, 4, 0x66666666u);
            r_run(&w);
            if (cases[n].count > 0) {
                const int16_t height = (int16_t)(uint16_t)(cases[n].ret + 0xdu);
                const uint32_t h32 = (uint32_t)(int32_t)height;
                uint32_t top, bottom, left;
                int m;
                xcall(0x4c5377, 0x5cf659, 5, R_622FCA, R_5CF665, 0x583196, 0x583186, 0x54cac8);
                xcall(0x4d3836, 0, 3, 0x54caf0, (uint32_t)(cases[n].k * 0x7f3) + 0x5a4c24u, (uint32_t)(cases[n].k * 0x1d0) + 0x5adb3au, 0, 0);
                top = RR(0x6dc) + (uint32_t)R_OY - 6u;
                bottom = top + h32;
                left = RR(0x6d8) + (uint32_t)R_OX;
                xcall(0x50ca3e, 0, 3, HOSTPTR, 0x54caf4, 0x6237d7, 0, 0);
                xcall(0x475cc4, 0x622fa2, 2, HOSTPTR, HOSTPTR, 0, 0, 0);
                xbuf(0x11111111u);
                {
                    Exp *e = &r_x[r_nx - 1];
                    e->rect_arg = 1;
                    e->rect[0] = left;
                    e->rect[1] = top;
                    e->rect[2] = left + 0x64u;
                    e->rect[3] = bottom;
                }
                top = RR(0x6e4) + (uint32_t)R_OY - 0x10u;
                bottom = top + h32;
                left = RR(0x6e0) + (uint32_t)R_OX;
                for (m = 0; m < 5; m++) {
                    Exp *e;
                    top = bottom;
                    bottom = top + h32;
                    xcall(0x50ca3e, 0, 3, HOSTPTR, 0x54caf8, 0xa0a0a0a0u + (uint32_t)m * 0x01010101u, 0, 0);
                    xcall(0x475cc4, 0x622fa2, 2, HOSTPTR, HOSTPTR, 0, 0, 0);
                    xbuf(0x22222222u + (uint32_t)m * 0x11111111u);
                    e = &r_x[r_nx - 1];
                    e->rect_arg = 1;
                    e->rect[0] = left;
                    e->rect[1] = top;
                    e->rect[2] = left + 0x50u;
                    e->rect[3] = bottom;
                }
            }
            CK(r_match() && L.ticks == 0);
        }
    }
}

/* ---- 0x45d2c6 (shares the expectation helpers of the 0x4778df test above) ---- */

#define S_F R_5CF665
#define S_G R_5D15E3

static void s_prepare(Fl22aWorld *w, int index)
{
    int k;
    reset_log();
    add_region(R_VA, r_rec, sizeof r_rec);
    r_nx = 0;
    memset(r_rec, 0, sizeof r_rec);
    memset(r_records, 0x11, sizeof r_records);
    memset(r_t5d, 0, sizeof r_t5d);
    memset(w, 0, sizeof *w);
    w->records_5bb5e5 = r_records + 0x8d;
    w->table_5d1599 = r_t5d + 0x4a;
    set32(r_records + 0x8d + (ptrdiff_t)index * 0x8d, 0, R_VA);
    w->word_624752 = (int16_t)index;
    for (k = -1; k <= 3; k++) set32(r_t5d + 0x4a + k * 0x4a, 0, 0xf0000000u + (uint32_t)(k + 1));
    w->word_624750 = 2;
    w->value_5cf665 = S_F;
    w->value_5d15e3 = S_G;
    w->value_624758 = 5;   /* neither 6 nor 9 */
}

static void s_run(Fl22aWorld *w)
{
    Fl18Host h = host();
    m45d2c6_render(w, &h);
}

#define S_T(n) (0xf0000000u + (uint32_t)((n) + 1))

static void xb(uint32_t src)
{
    xcall(0x45b568, 0x624734, 2, src, HOSTPTR, 0, 0, 0);
    r_x[r_nx - 1].a[1] = HOSTPTR;
}

static void xc(uint32_t a0, uint32_t a2, uint32_t fmt)
{
    xcall(0x4c5377, 0x5cf659, 5, a0, S_F, a2, HOSTPTR, fmt);
}

static void s_probe(const Fl22aWorld *w)
{
    L.probe_ptr[0] = (const uint8_t *)&w->value_624848;
    L.probe_len[0] = 4;
    L.probe_ptr[1] = (const uint8_t *)&w->value_62475c;
    L.probe_len[1] = 4;
    L.probe_ptr[2] = (const uint8_t *)&w->value_624818;
    L.probe_len[2] = 4;
    L.probe_ptr[3] = (const uint8_t *)&w->value_624840;
    L.probe_len[3] = 4;
    L.probe_ptr[4] = (const uint8_t *)&w->value_624810;
    L.probe_len[4] = 4;
    L.nprobe = 5;
}

/* the calls of the disassembly for the parameters (rec23, 0x6247ec, 0x6247ea; the sixteen calls of the two fixed loops are included) */
static void s_expect_loops(int n, int rec23, int w6ec, int w6ea)
{
    const uint32_t T = S_T(n);
    int i;
    for (i = 0; i < 4; i++) { xb(R_VA + (uint32_t)(i * 16) + 0x2d); xc(T, 0x62476au + (uint32_t)(i * 16), 0x54ac14); }
    for (i = 0; i < 4; i++) { xb(R_VA + (uint32_t)(i * 16) + 0x6d); xc(T, 0x6247aau + (uint32_t)(i * 16), 0x54ac28); }
    for (i = 0; i < rec23 - w6ec - 1; i++) { xb(R_VA + (uint32_t)(i * 16) + 0x19d); xc(T, R_VA + 0x42d, 0x54ac3c); }
    for (i = 0; i < w6ea; i++) { xb(R_VA + (uint32_t)(i * 16) + 0x1fd); xc(T, R_VA + 0x45d, 0x54ac54); }
    for (i = 0; i < rec23 - w6ea - 1; i++) { xb(R_VA + (uint32_t)(i * 16) + 0x25d); xc(T, R_VA + 0x43d, 0x54ac68); }
    for (i = 0; i < w6ec; i++) { xb(R_VA + (uint32_t)(i * 16) + 0x2bd); xc(T, R_VA + 0x44d, 0x54ac80); }
    for (i = 0; i < w6ea; i++) { xb(R_VA + (uint32_t)(i * 16) + 0x1fd); xc(T, R_VA + 0x45d, 0x54ac98); }
}

static void test_m45d2c6_render(void)
{
    (void)m45d2c6_render; /* driven through the file's runner helper; named here so the test pointer finds it */
    Fl22aWorld w;
    int mask, i;
    size_t n;
    /* ---- the loop limits: i < 4 twice, i < rec23 - 0x6247ec - 1, i < 0x6247ea, i < rec23 - 0x6247ea - 1, i < 0x6247ec, i < 0x6247ea ---- */
    {
        static const struct { int16_t rec23, w6ec, w6ea; } lim[] = {
            {0, 0, 0}, {5, 1, 2}, {6, 0, 0}, {3, 3, 0}, {2, 0, 3}, {1, 4, 4}, {-1, 0, 0}, {2, 1, 0}, {3, 1, 1}, {4, 2, 1}, {1, 0, 0}, {2, 0, 0}, {-32768, 5, 5}, {5, -3, -2},
        };
        for (n = 0; n < sizeof lim / sizeof lim[0]; n++) {
            s_prepare(&w, 1);
            set16(r_rec, 0x23, (uint16_t)lim[n].rec23);
            w.word_6247ec = lim[n].w6ec;
            w.word_6247ea = lim[n].w6ea;
            w.word_6247ee = 0;   /* (the blocks after the loops are tested below; here the standard w = 0 calls follow) */
            s_run(&w);
            s_expect_loops(2, lim[n].rec23, lim[n].w6ec, lim[n].w6ea);
            xb(R_VA + 0x34d); xc(S_T(2), R_VA + 0x49d, 0x54accc);
            xb(R_VA + 0x35d); xcall(0x4c5377, 0x5cf659, 5, S_G, S_F, R_VA + 0x35d, HOSTPTR, 0x54ace0);
            xb(R_VA + 0x32d); xc(S_T(2), R_VA + 0x4bd, 0x54ad2c);
            xb(0x6247f0); xc(S_T(2), 0x624820, 0x54adac);
            xb(0x624800); xc(S_T(2), 0x624830, 0x54adc8);
            CK(r_match() && L.ticks == 0);
        }
    }
    /* ---- the table dword is read at 0x5d1599 + n * 0x4a for the signed word n = 0x624750 ---- */
    {
        static const int16_t ns[] = {-1, 0, 1, 2, 3};
        for (n = 0; n < sizeof ns / sizeof ns[0]; n++) {
            s_prepare(&w, 3);
            w.word_624750 = ns[n];
            w.word_6247ee = 2;
            s_run(&w);
            s_expect_loops(ns[n], 0, 0, 0);
            xb(R_VA + 0x32d); xc(S_T(ns[n]), R_VA + 0x4bd, 0x54ad2c);
            xb(0x6247f0); xc(S_T(ns[n]), 0x624820, 0x54adac);
            xb(0x624800); xc(S_T(ns[n]), 0x624830, 0x54adc8);
            CK(r_match());
        }
    }
    /* ---- the rectangle that B fills is the one that C gets: B stores four dwords per call (the first four calls are scripted) ---- */
    s_prepare(&w, 2);
    for (i = 0; i < 4; i++) {
        queue_write(0x45b568, i, 1, 0, 4, 0x100u * (uint32_t)(i + 1) + 1);
        queue_write(0x45b568, i, 1, 4, 4, 0x100u * (uint32_t)(i + 1) + 2);
        queue_write(0x45b568, i, 1, 8, 4, 0x100u * (uint32_t)(i + 1) + 3);
        queue_write(0x45b568, i, 1, 12, 4, 0x100u * (uint32_t)(i + 1) + 4);
    }
    s_run(&w);
    s_expect_loops(2, 0, 0, 0);
    for (i = 0; i < 4; i++) {
        /* the first 4 draw calls, in the order B0 C0 B1 C1 ...: the rectangle of draw call k holds the four dwords of B call k */
        const int c = 2 * i + 1;
        uint32_t want[4];
        want[0] = 0x100u * (uint32_t)(i + 1) + 1;
        want[1] = 0x100u * (uint32_t)(i + 1) + 2;
        want[2] = 0x100u * (uint32_t)(i + 1) + 3;
        want[3] = 0x100u * (uint32_t)(i + 1) + 4;
        CK(L.c[c].callee == 0x4c5377 && memcmp(L.c[c].pd[3], want, 16) == 0);
    }
    /* ---- every conditional block: the combinations of the selectors ---- */
    for (mask = 0; mask < 2304; mask++) {
        static const uint32_t q_values[3] = {6, 9, 5};
        const int w6ee = mask & 3, d892 = (mask >> 2) & 1, d5c = (mask >> 3) & 1, d766 = (mask >> 4) & 1, d896 = (mask >> 5) & 1, qi = (mask >> 6) % 3, w890i = (mask / 192) % 3,
                  d818 = (mask / 576) & 1, d848 = (mask / 1152) & 1;
        const uint32_t q = q_values[qi];
        const int16_t w890 = (int16_t)w890i;
        const uint32_t T = S_T(2), R = R_VA;
        int s_index;
        s_prepare(&w, 1);
        w.word_6247ee = (int16_t)w6ee;
        w.value_624892 = d892 ? 0x10000u : 0;
        w.value_62475c = d5c ? 0x100u : 0;
        w.value_624766 = d766 ? 0x1000000u : 0;
        w.value_624896 = d896 ? 0x100u : 0;
        w.value_624758 = q;
        w.word_624890 = w890;
        w.value_624818 = d818 ? 0x10000u : 0;
        w.value_624848 = d848 ? 0x100u : 0;
        w.word_624760 = (int16_t)(mask % 5 - 2);   /* -2 .. 2 */
        s_index = w.word_624760;
        w.value_624810 = 0x11;
        w.value_624814 = 0x22;
        w.value_62481c = 0x33;
        w.value_624840 = 0x44;
        w.value_624844 = 0x55;
        w.value_62484c = 0x66;
        s_probe(&w);
        s_run(&w);
        s_expect_loops(2, 0, 0, 0);
        if (d848) { xb(0x624840); xcall(0x4c5377, 0x5cf659, 5, S_G, S_F, 0x624840, HOSTPTR, 0x54acac); }
        if (w6ee == 0 || (w6ee == 1 && d892)) {
            xb(R + 0x34d); xc(T, R + 0x49d, 0x54accc);
            xb(R + 0x35d); xcall(0x4c5377, 0x5cf659, 5, S_G, S_F, R + 0x35d, HOSTPTR, 0x54ace0);
        } else if (d892) {
            xb(R + 0x35d); xc(T, R + 0x4ad, 0x54acfc);
            xb(R + 0x34d); xcall(0x4c5377, 0x5cf659, 5, S_G, S_F, R + 0x34d, HOSTPTR, 0x54ad10);
        }
        if (w6ee == 0 || w6ee == 2) {
            xb(R + 0x32d); xc(T, R + 0x4bd, 0x54ad2c);
        } else {
            xb(R + 0x32d); xcall(0x4c5377, 0x5cf659, 5, S_G, S_F, R + 0x32d, HOSTPTR, 0x54ad48);
        }
        if (d5c) {
            xb(R + (uint32_t)(s_index * 16) + 0x31d);
            if (d766) {
                xcall(0x4c5d4b, 0x5cf659, 5, T, S_F, R + (uint32_t)(s_index * 16) + 0x46d, HOSTPTR, 0x54ad5c);
            } else {
                xcall(0x4c5377, 0x5cf659, 5, S_G, S_F, R + (uint32_t)(s_index * 16) + 0x31d, HOSTPTR, 0x54ad88);
            }
        }
        if (!d896) {
            if (q != 6 || w890 == 0) { xb(0x6247f0); xc(T, 0x624820, 0x54adac); }
            if (q != 6 || w890 == 1) { xb(0x624800); xc(T, 0x624830, 0x54adc8); }
        }
        if (d818) { xb(0x624810); xcall(0x4c5377, 0x5cf659, 5, S_G, S_F, 0x624810, HOSTPTR, 0x54ade8); }
        if (q == 9) {
            xb(0x624850); xcall(0x4c5377, 0x5cf659, 5, S_G, S_F, 0x624850, HOSTPTR, 0x54ae08);
            xb(0x624860); xcall(0x4c5377, 0x5cf659, 5, S_G, S_F, 0x624860, HOSTPTR, 0x54ae34);
            xb(0x624870); xcall(0x4c5377, 0x5cf659, 5, S_G, S_F, 0x624870, HOSTPTR, 0x54ae64);
            xb(0x624880); xcall(0x4c5377, 0x5cf659, 5, S_G, S_F, 0x624880, HOSTPTR, 0x54ae88);
        }
        CK(r_match());
        /* the dwords that the function clears are cleared after the call that uses them (the call-time probes see the old values) */
        CK(w.value_624840 == (d848 ? 0u : 0x44u) && w.value_624844 == (d848 ? 0u : 0x55u) && w.value_62484c == (d848 ? 0u : 0x66u) && w.value_624848 == 0);
        CK(w.value_624818 == 0 && w.value_624810 == (d818 ? 0u : 0x11u) && w.value_624814 == (d818 ? 0u : 0x22u) && w.value_62481c == (d818 ? 0u : 0x33u));
        CK(w.value_62475c == (uint32_t)((d5c && !d766) ? 0 : (d5c ? 0x100 : 0)));
        for (i = 0; i < r_nx; i++) {
            if (r_x[i].callee != 0x4c5377 && r_x[i].callee != 0x4c5d4b) continue;
            if (r_x[i].a[4] == 0x54acac) CK(get32(L.c[i].probe, 0) == 0x100 && get32(L.c[i].probe, 12) == 0x44);
            if (r_x[i].a[4] == 0x54ad88) CK(get32(L.c[i].probe, 4) == 0x100);
            if (r_x[i].a[4] == 0x54ade8) CK(get32(L.c[i].probe, 8) == 0x10000 && get32(L.c[i].probe, 16) == 0x11);
        }
    }
}

/* TESTS-HERE */

int main(void)
{
    int failures = 0;
    RUN(test_m463392_step_scene);
    RUN(test_m461d82_move_step);
    RUN(test_m4778df_render);
    RUN(test_m45d2c6_render);
    /* RUN-END */
    return failures;
}
