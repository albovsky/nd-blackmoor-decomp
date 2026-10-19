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

/* TESTS-HERE */

int main(void)
{
    int failures = 0;
    RUN(test_m463392_step_scene);
    /* RUN-END */
    return failures;
}
