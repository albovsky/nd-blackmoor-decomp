/* FL-21 (batch a) direct tests of the functions of GAME.EXE in src/original_methods_fl21a.c. Prints "PASS <name>" / "FAIL <name>: <msg>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values come from the disassembly of
 * GAME.EXE, not from running the native code; tests/test_fl21a_differential.py additionally runs the original bytes on random fixtures.
 */
#include "../src/original_methods_fl21a.h"

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

/* ---- 0x4cb586 ---- */

#define A_OBJ_VA 0x00d30000u
#define A_Q_VA 0x00d31000u
#define A_P_VA 0x00d32000u

static uint8_t a_self[0x200], a_exp[0x200], a_obj[0x100], a_q[16], a_p[16], a_records[0x8d * 6], a_table[0x4a * 6], a_texp[0x4a * 6], a_str[32];

#define A_REC(w, n) ((w).records_5bb5e5 + (ptrdiff_t)(n) * 0x8d)

static void a_prepare(Fl21aWorld *w, int index, uint32_t state)
{
    reset_log();
    add_region(A_OBJ_VA, a_obj, sizeof a_obj);
    add_region(A_Q_VA, a_q, sizeof a_q);
    add_region(A_P_VA, a_p, sizeof a_p);
    memset(a_self, 0x5a, sizeof a_self);
    memset(a_table, 0x33, sizeof a_table);
    memset(a_records, 0x11, sizeof a_records);
    memset(a_obj, 0, sizeof a_obj);
    memset(w, 0, sizeof *w);
    w->records_5bb5e5 = a_records + 0x8d;
    w->table_5d1591 = a_table + 0x4a;
    w->string_558c30 = a_str;
    set32(A_REC(*w, index), 0, A_OBJ_VA);
    set32(A_REC(*w, index), 0x4d, state);
}

static void a_names(const char *q, const char *p)
{
    memset(a_q, 0x77, sizeof a_q);
    memset(a_p, 0x77, sizeof a_p);
    memcpy(a_q, q, strlen(q) + 1);
    memcpy(a_p, p, strlen(p) + 1);
}

typedef struct NameCase {
    const char *q, *p;
    int equal;
} NameCase;

static void test_m4cb586_visit(void)
{
    Fl21aWorld w;
    Fl18Host h = host();
    uint8_t *t;
    size_t k;
    static const NameCase names[] = {
        {"", "", 1},        {"a", "a", 1},      {"ab", "ab", 1},   {"abc", "abc", 1}, {"abcd", "abcd", 1}, {"a", "b", 0},   {"ab", "ac", 0},
        {"abc", "abd", 0},  {"abc", "ab", 0},   {"ab", "abc", 0},  {"", "a", 0},      {"a", "", 0},        {"b", "a", 0},   {"\xff", "\x7f", 0},
        {"\x7f", "\xff", 0}, {"abcd", "abce", 0}, {"abcde", "abcde", 1},
    };
    /* an unknown state does nothing but the copy of the record's object address */
    a_prepare(&w, 2, 7);
    memcpy(a_exp, a_self, sizeof a_exp);
    m4cb586_visit(a_self, 2, &w, &h);
    set32(a_exp, 0x16, A_OBJ_VA);
    CK(L.n == 0 && memcmp(a_self, a_exp, sizeof a_self) == 0 && get32(A_REC(w, 2), 0x4d) == 7);
    /* state 2 (record -1: a signed word): the byte +0x40 is set before 0x4caf8a is called; then 0x42ba3a with the word */
    a_prepare(&w, -1, 2);
    memcpy(a_exp, a_self, sizeof a_exp);
    L.probe_callee = 0x4caf8a;
    L.probe_ptr[0] = A_REC(w, -1) + 0x40;
    L.probe_len[0] = 1;
    L.nprobe = 1;
    m4cb586_visit(a_self, -1, &w, &h);
    set32(a_exp, 0x16, A_OBJ_VA);
    CK(L.n == 2 && is_call(0, 0x4caf8a, (uintptr_t)a_self, 0) && is_call(1, 0x42ba3a, 0, 1) && (L.c[1].a[0] & 0xffff) == 0xffff);
    CK(L.c[0].probe[0] == 1 && A_REC(w, -1)[0x40] == 1 && memcmp(a_self, a_exp, sizeof a_self) == 0 && get32(A_REC(w, -1), 0x4d) == 2);
    /* state 1: the dwords +8 and +0x12 are cleared first; 0x4c0c2c on 0x637fcf decides */
    for (k = 0; k < 8; k++) {
        static const uint32_t s_ret[8] = {0, 1, 3, 2, 2, 2, 2, 0x80000002u};
        static const uint32_t v_ret[8] = {0, 0, 0, 0xffffffffu, 9, 9, 9, 0};
        static const uint32_t b_ret[8] = {0, 0, 0, 0, 0, 0x77, 0x77, 0};
        static const uint32_t old14a[8] = {1, 1, 1, 1, 1, 9, 3, 1};
        uint32_t s = s_ret[k];
        int calls = s == 2 ? (v_ret[k] == 0xffffffffu ? 2 : 3) : 1;
        a_prepare(&w, 1, 1);
        set32(a_self, 8, 0x1111);
        set32(a_self, 0x12, 0x2222);
        set32(a_self, 0x14a, old14a[k]);
        memcpy(a_exp, a_self, sizeof a_exp);
        queue_return(0x4c0c2c, s);
        queue_return(0x4c0c54, v_ret[k]);
        queue_return(0x4cb944, b_ret[k]);
        if (s == 2 && v_ret[k] != 0xffffffffu && b_ret[k] != 0 && old14a[k] != v_ret[k]) calls++;
        L.probe_callee = 0x4cb9d1;   /* at the call: +8 is still 0 and +0x14a is the old value */
        L.probe_ptr[0] = a_self + 8;
        L.probe_len[0] = 4;
        L.probe_ptr[1] = a_self + 0x14a;
        L.probe_len[1] = 4;
        L.nprobe = 2;
        m4cb586_visit(a_self, 1, &w, &h);
        set32(a_exp, 0x16, A_OBJ_VA);
        set32(a_exp, 8, 0);
        set32(a_exp, 0x12, 0);
        CK(L.n == calls && is_call(0, 0x4c0c2c, 0x637fcf, 0));
        if (s != 2 && s != 3) CK(get32(A_REC(w, 1), 0x4d) == 2);
        else CK(get32(A_REC(w, 1), 0x4d) == 1);
        if (s == 2 && v_ret[k] != 0xffffffffu) {
            CK(is_call(1, 0x4c0c54, 0x637fcf, 0) && is_call(2, 0x4cb944, (uintptr_t)a_self, 1) && L.c[2].a[0] == v_ret[k]);
            set32(a_exp, 0x12, b_ret[k]);
            if (b_ret[k] != 0 && old14a[k] != v_ret[k]) {
                CK(is_call(3, 0x4cb9d1, (uintptr_t)a_self, 0) && get32(L.c[3].probe, 0) == 0 && get32(L.c[3].probe, 4) == old14a[k]);
                set32(a_exp, 8, 1);
                set32(a_exp, 0x14a, v_ret[k]);
            }
        }
        CK(memcmp(a_self, a_exp, sizeof a_self) == 0);
    }
    /* state 0: the names decide (this+0x1a is set); the record's object has the word +0x21 = 0; the second 0x4c0c2c (state 1) returns 0 */
    for (k = 0; k < sizeof names / sizeof names[0]; k++) {
        a_prepare(&w, 1, 0);
        a_names(names[k].q, names[k].p);
        set32(a_self, 0x1a, A_Q_VA);
        queue_return(0x4c0c2c, 2);
        queue_return(0x4c0c2c, 0);
        queue_return(0x4c0c18, A_P_VA);
        memcpy(a_exp, a_self, sizeof a_exp);
        m4cb586_visit(a_self, 1, &w, &h);
        set32(a_exp, 0x16, A_OBJ_VA);
        if (names[k].equal) {
            CK(L.n == 3 && is_call(1, 0x4c0c18, 0x637fcf, 0) && is_call(2, 0x4c0c2c, 0x637fcf, 0));
            CK(get32(A_REC(w, 1), 0x4d) == 2 && get16(a_self, 0xc) == 0xffff);
        } else {
            CK(L.n == 2 && get32(A_REC(w, 1), 0x4d) == 0 && memcmp(a_self, a_exp, sizeof a_self) == 0);
        }
    }
    /* state 0 where the first 0x4c0c2c does not return 2: one call, nothing stored */
    a_prepare(&w, 1, 0);
    set32(a_self, 0x1a, A_Q_VA);
    queue_return(0x4c0c2c, 3);
    memcpy(a_exp, a_self, sizeof a_exp);
    m4cb586_visit(a_self, 1, &w, &h);
    set32(a_exp, 0x16, A_OBJ_VA);
    CK(L.n == 1 && memcmp(a_self, a_exp, sizeof a_self) == 0 && get32(A_REC(w, 1), 0x4d) == 0);
    /* state 0 with the name pointer 0: 0x4cbba9 loads it (call-time: +0x16 is already stored), the object has the word +0x21 = 7 */
    memcpy(a_str, "xyz", 4);
    a_prepare(&w, 1, 0);
    a_names("ab", "ab");
    set32(a_self, 0x1a, 0);
    set16(a_obj, 0x21, 7);
    w.word_583a29 = 5;
    queue_return(0x4c0c2c, 2);
    queue_return(0x4c0c2c, 3);
    queue_return(0x4c0c18, A_P_VA);
    queue_return(0x4d39f9, 0xabcd0002u);
    queue_write(0x4cbba9, 0, -1, 0x1a, 4, A_Q_VA);
    memcpy(a_exp, a_self, sizeof a_exp);
    memcpy(a_texp, a_table, sizeof a_texp);
    L.probe_callee = 0x4cbba9;
    L.probe_ptr[0] = a_self + 0x16;
    L.probe_len[0] = 4;
    L.nprobe = 1;
    m4cb586_visit(a_self, 1, &w, &h);
    CK(L.n == 5 && is_call(0, 0x4cbba9, (uintptr_t)a_self, 1) && L.c[0].a[0] == A_OBJ_VA && get32(L.c[0].probe, 0) == A_OBJ_VA);
    CK(is_call(1, 0x4c0c2c, 0x637fcf, 0) && is_call(2, 0x4c0c18, 0x637fcf, 0) && is_call(3, 0x4d39f9, 0, 0) && is_call(4, 0x4c0c2c, 0x637fcf, 0));
    set32(a_exp, 0x16, A_OBJ_VA);
    set32(a_exp, 0x1a, A_Q_VA);
    set16(a_exp, 0xc, 2);
    set16(a_exp, 0x152, 5);
    set32(a_exp, 0x14a, 0xffffffffu);
    set32(a_exp, 8, 0);
    set32(a_exp, 0x12, 0);
    set32(a_exp, 0x154, 0);
    set32(a_exp, 0x14e, 0);
    set32(a_exp, 0xe, 1);
    set32(a_exp, 0x15c, 0);
    CK(memcmp(a_self, a_exp, sizeof a_self) == 0);
    t = a_texp + 0x4a + 2 * 0x4a;   /* record 2 of the table (the call returned the word 2 with a leftover upper half) */
    set32(t, 0, 0xf);
    set32(t, 4, 0x4cc79a);
    set32(t, 8, 0);
    set32(t, 0xc, 0);
    set32(t, 0x10, 0);
    set32(t, 0x14, 1);
    set32(t, 0x18, 1);
    set16(t, 0x1c, 0);
    memcpy(t + 0x22, "xyz", 4);
    CK(memcmp(a_table, a_texp, sizeof a_table) == 0 && get32(A_REC(w, 1), 0x4d) == 1);
    /* the same with the word 0x583a29 = -1 (+0x152 := 0xffff), the record number -1 (a signed word) and a 0x4d39f9 result with word 0xffff:
     * the record -1 of the table, and the call-time word +0xc = 0xffff */
    a_prepare(&w, 1, 0);
    a_names("ab", "ab");
    set32(a_self, 0x1a, A_Q_VA);
    set16(a_obj, 0x21, 0x100);
    w.word_583a29 = -1;
    queue_return(0x4c0c2c, 2);
    queue_return(0x4c0c2c, 3);
    queue_return(0x4c0c18, A_P_VA);
    queue_return(0x4d39f9, 0x1234ffffu);
    memcpy(a_texp, a_table, sizeof a_texp);
    L.probe_callee = 0x4d39f9;
    L.probe_ptr[0] = a_self + 0xc;
    L.probe_len[0] = 2;
    L.nprobe = 1;
    m4cb586_visit(a_self, 1, &w, &h);
    CK(L.n == 4 && get16(L.c[2].probe, 0) == 0xffff && get16(a_self, 0xc) == 0xffff && get16(a_self, 0x152) == 0xffff);
    t = a_texp;
    set32(t, 0, 0xf);
    set32(t, 4, 0x4cc79a);
    set32(t, 8, 0);
    set32(t, 0xc, 0);
    set32(t, 0x10, 0);
    set32(t, 0x14, 1);
    set32(t, 0x18, 1);
    set16(t, 0x1c, 0);
    memcpy(t + 0x22, "xyz", 4);
    CK(memcmp(a_table, a_texp, sizeof a_table) == 0);
}

/* ---- 0x42caa8 ---- */

static uint8_t b_ent[0x42 * 10], b_clip[16], b_rec[0x8d * 5], b_rexp[0x8d * 5];

typedef struct ClipCase {
    int32_t y0, y1, c4, c12;
    int inside;       /* 1: all in, 0: clipped, -1: nothing */
    uint32_t e2c, e34, e1c, e24;   /* the expected results of a clipped / inside run (before the final subtraction of the origin) */
} ClipCase;

static void b_run(Fl21aWorld *w, int16_t index, int32_t y0, int32_t y1, int32_t c4, int32_t c12, uint32_t ox, uint32_t oy)
{
    Fl18Host h = host();
    uint8_t *e = b_ent + 2 * 0x42 + (ptrdiff_t)index * 0x42;
    reset_log();
    memset(w, 0, sizeof *w);
    memset(b_ent, 0xcd, sizeof b_ent);
    memset(b_rec, 0x44, sizeof b_rec);
    w->entries_5b4ea9 = b_ent + 2 * 0x42;
    w->records_5bb5e5 = b_rec + 0x8d;
    w->origin_x_583186 = (int32_t)ox;
    w->origin_y_58318a = (int32_t)oy;
    set32(e, 2, 0x11);
    set32(e, 6, 0x22);
    set32(e, 0xa, 0x33);
    set32(e, 0xe, 0x44);
    set32(e, 0x12, 0x55);
    set32(e, 0x16, (uint32_t)y0);
    set32(e, 0x1a, 0x66);
    set32(e, 0x1e, (uint32_t)y1);
    set32(b_clip, 0, 0xc0de0000u);
    set32(b_clip, 4, (uint32_t)c4);
    set32(b_clip, 8, 0xc0de0008u);
    set32(b_clip, 0xc, (uint32_t)c12);
    w->value_5b4e2c = 0xa0a0a0a0u;
    w->value_5b4e34 = 0xb0b0b0b0u;
    w->value_5b4e28 = 0xc0c0c0c0u;
    w->value_5b4e30 = 0xd0d0d0d0u;
    m42caa8_clip_rect(index, b_clip, w, &h);
}

static void test_m42caa8_clip_rect(void)
{
    Fl21aWorld w;
    size_t k;
    /* origin (100, 1000); the entry is {+2 = 0x11, +6 = 0x22, +0xa = 0x33, +0xe = 0x44, x0 = 0x55, x1 = 0x66}; the clip is c4 = 10 .. c12 = 50 */
    static const ClipCase cases[] = {
        /* y0, y1, c4, c12, kind, 2c, 34, 1c, 24 */
        {20, 40, 10, 50, 1, 1010, 1030, 0x22, 0x44},      /* inside */
        {10, 50, 10, 50, 1, 1000, 1040, 0x22, 0x44},      /* exactly the clip: inside */
        {5, 40, 10, 50, 0, 1000, 1030, 0x27, 0x44},       /* above c4, y1 inside: clipped to c4 (via the c4 edge test) */
        {20, 70, 10, 50, 0, 1010, 1040, 0x22, 0x30},      /* below c12: clipped to c12 */
        {0, 100, 10, 50, 0, 1000, 1040, 0x2c, 0x12},      /* spans the whole clip */
        {50, 51, 10, 50, 0, 1040, 1040, 0x22, 0x43},      /* y0 = c12, y1 = c12 + 1 */
        {-30, -20, 10, 50, -1, 0, 0, 0, 0},               /* entirely above */
        {60, 80, 10, 50, -1, 0, 0, 0, 0},                 /* entirely below */
    };
    for (k = 0; k < sizeof cases / sizeof cases[0]; k++) {
        const ClipCase *c = &cases[k];
        b_run(&w, 3, c->y0, c->y1, c->c4, c->c12, 100, 1000);
        if (c->inside >= 0) {
            CK(w.value_5b4e18 == 0x11 && w.value_5b4e20 == 0x33 && w.value_5b4e28 == 0x55 + 100 && w.value_5b4e30 == 0x66 + 100 && w.value_5d1967 == 1);
            CK(w.value_5b4e1c == c->e1c && w.value_5b4e24 == c->e24 && w.value_5b4e2c == c->e2c && w.value_5b4e34 == c->e34);
            CK(w.value_5b4e5c == c->e2c - 1000 && w.value_5b4e64 == c->e34 - 1000 && w.value_5b4e58 == 0x55 && w.value_5b4e60 == 0x66);
        } else {
            /* nothing of the entry is stored; the final four subtractions use the old values */
            CK(w.value_5d1967 == 0 && w.value_5b4e18 == 0 && w.value_5b4e1c == 0 && w.value_5b4e2c == 0xa0a0a0a0u);
            CK(w.value_5b4e5c == 0xa0a0a0a0u - 1000 && w.value_5b4e64 == 0xb0b0b0b0u - 1000 && w.value_5b4e58 == 0xc0c0c0c0u - 100 &&
               w.value_5b4e60 == 0xd0d0d0d0u - 100);
        }
        CK(L.n == 0);
    }
    /* y0 = 10, y1 = 9 (y1 < y0): y1 <= c12 and y0 >= c4 hold, so the entry counts as inside */
    b_run(&w, 3, 10, 9, 10, 50, 100, 1000);
    CK(w.value_5b4e2c == 1000 && w.value_5b4e34 == 999 && w.value_5d1967 == 1);
    /* the edge tests with a clip c4 > c12 (inverted): y0 = 60 > c12 = 50: the second edge test (y0 > c4 = 70 is false, y1 = 80 >= 70): clipped */
    b_run(&w, 3, 60, 80, 70, 50, 100, 1000);
    CK(w.value_5d1967 == 1 && w.value_5b4e2c == 70 - 70 + 1000 + 0 && w.value_5b4e34 == 50 - 70 + 1000);
    /* inverted clip c4 = 50 > c12 = 10 with y0 = c4 = 50, y1 = 60: y0 > c12 jumps to the edge tests, y0 > c4 is false (a >= would leave the entry
     * unchanged) and y1 < c4 is false: clipped to y0 = 50 and y1 = c12 = 10 */
    b_run(&w, 3, 50, 60, 50, 10, 100, 1000);
    CK(w.value_5d1967 == 1 && w.value_5b4e2c == 1000 && w.value_5b4e34 == 960 && w.value_5b4e1c == 0x22 && w.value_5b4e24 == 0x44 - 50);
    /* the entry index is a signed word (here -2: the lowest slack entry) and the entry fields are the ones of that entry */
    b_run(&w, -2, 20, 40, 10, 50, 100, 1000);
    CK(w.value_5b4e18 == 0x11 && w.value_5b4e2c == 1010 && w.value_5b4e34 == 1030);
    /* wrap-around arithmetic: origin_y = 0x7fffffff + 1000 */
    b_run(&w, 1, 20, 40, 10, 50, 100, 0x7ffffffeu);
    CK(w.value_5b4e2c == 10u + 0x7ffffffeu && w.value_5b4e34 == 30u + 0x7ffffffeu && w.value_5b4e5c == 10u && w.value_5b4e64 == 30u);
    /* the mode word 0x5b4ea3 = 2 stores the entry into the record: +0x41 := 1 and the low words of x0, y0, x1, y1 (before the compares) */
    {
        Fl18Host h = host();
        uint8_t *e;
        b_run(&w, 3, 20, 40, 10, 50, 100, 1000);   /* (only to set up the fixture) */
        reset_log();
        e = b_ent + 2 * 0x42 + 3 * 0x42;
        set32(e, 0x12, 0x11112222u);
        set32(e, 0x16, 0x33334444u);
        set32(e, 0x1a, 0x55556666u);
        set32(e, 0x1e, 0x77778888u);
        w.word_5b4ea3 = 2;
        w.word_5b4e89 = 2;
        w.word_5b4e8b = 0;
        memcpy(b_rexp, b_rec, sizeof b_rexp);
        m42caa8_clip_rect(3, b_clip, &w, &h);
        set32(b_rexp + 0x8d + 2 * 0x8d, 0x41, 1);
        set16(b_rexp + 0x8d + 2 * 0x8d, 0x45, 0x2222);
        set16(b_rexp + 0x8d + 2 * 0x8d, 0x47, 0x4444);
        set16(b_rexp + 0x8d + 2 * 0x8d, 0x49, 0x6666);
        set16(b_rexp + 0x8d + 2 * 0x8d, 0x4b, 0x8888);
        CK(memcmp(b_rec, b_rexp, sizeof b_rec) == 0 && L.n == 0);
        /* y0 = 0x33334444 (> c12), y1 = 0x77778888 (> c12): the second edge test (y0 > c4) leaves it unchanged; the mode 3 does not store */
        w.word_5b4ea3 = 3;
        w.word_5b4e89 = 1;
        memcpy(b_rexp, b_rec, sizeof b_rexp);
        m42caa8_clip_rect(3, b_clip, &w, &h);
        CK(memcmp(b_rec, b_rexp, sizeof b_rec) == 0);
    }
    /* the mode word 0x5b4e8b = 2: 0x42cecd (cdecl) with the dword (final 0x5b4e60 & 0xffff0000 | the word index) and the clip pointer */
    {
        Fl18Host h = host();
        b_run(&w, -2, 20, 40, 10, 50, 0, 1000);
        reset_log();
        set32(b_ent + 0, 0x1a, 0xabcd1234u);   /* entry -2 is the lowest slack entry, b_ent + 0 */
        w.word_5b4e8b = 2;
        m42caa8_clip_rect(-2, b_clip, &w, &h);
        CK(w.value_5b4e30 == 0xabcd1234u && w.value_5b4e60 == 0xabcd1234u);
        CK(L.n == 1 && is_call(0, 0x42cecd, 0, 2) && L.c[0].a[0] == 0xabcdfffeu && L.c[0].a[1] == (uintptr_t)b_clip &&
           get32(L.c[0].pd[1], 4) == 10 && get32(L.c[0].pd[1], 0xc) == 50);
        w.word_5b4e8b = 3;
        reset_log();
        m42caa8_clip_rect(-2, b_clip, &w, &h);
        CK(L.n == 0);
    }
}

/* ---- 0x462c39 ---- */

#define C_REC_VA 0x00d40000u

static uint8_t c_self[0x100], c_exp[0x100], c_rec[0x400], c_cells[0x600], c_records[0x8d * 5];

static void c_cell(int r, int c, int16_t word, int32_t b, int32_t a, int32_t cc, int32_t d)
{
    uint8_t *p = c_cells + r * 0x140 + c * 0x28;
    set16(p, 0x26, (uint16_t)word);
    set32(p, 0x14, (uint32_t)b);
    set32(p, 0x18, (uint32_t)a);
    set32(p, 0x1c, (uint32_t)cc);
    set32(p, 0x20, (uint32_t)d);
}

/* a grid of rows x cols cells in the record 2 of the table; the cell rectangles are empty (zero words) until a case sets one; the
 * record's outer box (x 0 .. 100, y 0 .. 100 unless a case moves it), this+0x4f = 8 (q = 2), this+0x53 = 10 (half = 5) */
static void c_prepare(Fl21aWorld *w, int rows, int cols)
{
    reset_log();
    add_region(C_REC_VA, c_rec, sizeof c_rec);
    memset(c_self, 0x5a, sizeof c_self);
    memset(c_rec, 0, sizeof c_rec);
    memset(c_cells, 0, sizeof c_cells);
    memset(c_records, 0x11, sizeof c_records);
    memset(w, 0, sizeof *w);
    w->records_5bb5e5 = c_records + 0x8d;
    w->cells_594db5 = c_cells;
    set32(w->records_5bb5e5 + 2 * 0x8d, 0, C_REC_VA);
    set16(c_self, 0x1e, 2);
    set32(c_self, 0x3f, 1);
    set32(c_self, 0x24, 0);
    set32(c_self, 0x4f, 8);
    set32(c_self, 0x53, 10);
    set16(c_self, 0x57, 0x1234);
    set16(c_rec, 0x22, (uint16_t)rows);
    set16(c_rec, 0x24, (uint16_t)cols);
    set32(c_rec, 0x347, 0);
    set32(c_rec, 0x34b, 0);
    set32(c_rec, 0x34f, 100);
    set32(c_rec, 0x353, 100);
}

static int c_run(Fl21aWorld *w, int x, int y)
{
    Fl18Host h = host();
    return (int)m462c39_pointer_move(c_self, (int16_t)x, (int16_t)y, w, &h);
}

static void c_probe_state(void)
{
    L.probe_callee = 0x4619be;   /* at the call: the cell word, the row and the column are already stored */
    L.probe_ptr[0] = c_self + 0x39;
    L.probe_len[0] = 2;
    L.probe_ptr[1] = c_self + 0x5b;
    L.probe_len[1] = 2;
    L.probe_ptr[2] = c_self + 0x5d;
    L.probe_len[2] = 2;
    L.nprobe = 3;
}

typedef struct HitCase {
    int x, y;
    int32_t f4f, f53;
    uint32_t ret;          /* what every 0x4619be returns */
    int nd;
    uint16_t dirs[3];      /* the directions asked, in order */
    uint16_t code;         /* the 0x4630a3 code when a direction was accepted (ret 1), else 0 */
} HitCase;

static void test_m462c39_pointer_move(void)
{
    Fl21aWorld w;
    size_t k;
    int i;
    /* the cell (1, 2) is the only one with a word: left B = 10, top A = 20, right C = 30, bottom D = 40 */
    static const HitCase cases[] = {
        {20, 22, 8, 10, 1, 1, {0x11}, 0x2781},    {29, 30, 8, 10, 1, 1, {0x13}, 0x2783},    {20, 37, 8, 10, 1, 1, {0x12}, 0x2782},
        {11, 30, 8, 10, 1, 1, {0x10}, 0x2780},    {20, 22, 8, 10, 0, 1, {0x11}, 0},         {12, 30, 8, 10, 0, 0, {0}, 0},
        {13, 22, 8, 10, 1, 1, {0x11}, 0x2781},    {28, 22, 8, 10, 0, 0, {0}, 0},            {27, 22, 8, 10, 1, 1, {0x11}, 0x2781},
        {30, 30, 8, 10, 1, 1, {0x13}, 0x2783},    {31, 30, 8, 10, 0, 0, {0}, 0},            {10, 30, 8, 10, 1, 1, {0x10}, 0x2780},
        {9, 30, 8, 10, 0, 0, {0}, 0},             {20, 19, 8, 10, 0, 0, {0}, 0},            {20, 20, 8, 10, 1, 1, {0x11}, 0x2781},
        {20, 24, 8, 10, 1, 1, {0x11}, 0x2781},    {20, 25, 8, 10, 0, 0, {0}, 0},            {20, 35, 8, 10, 1, 1, {0x12}, 0x2782},
        {20, 40, 8, 10, 1, 1, {0x12}, 0x2782},    {20, 41, 8, 10, 0, 0, {0}, 0},            {29, 37, 8, 10, 0, 1, {0x13}, 0},
        {20, 30, 8, 200, 0, 2, {0x11, 0x12}, 0},  {11, 36, 8, 10, 0, 1, {0x10}, 0},
        /* q and half round toward zero: q = -9 / 4 = -2, 3 / 4 = 0, 7 / 4 = 1; half = -5 / 2 = -2, 3 / 2 = 1 */
        {9, 22, -9, 10, 1, 1, {0x11}, 0x2781},    {31, 22, -9, 10, 1, 1, {0x11}, 0x2781},   {32, 22, -9, 10, 0, 0, {0}, 0},
        {10, 22, 3, 10, 0, 0, {0}, 0},            {11, 22, 3, 10, 1, 1, {0x11}, 0x2781},    {10, 30, 7, 10, 1, 1, {0x10}, 0x2780},
        {11, 30, 7, 10, 0, 0, {0}, 0},            {20, 20, 8, -5, 0, 0, {0}, 0},            {20, 20, 8, 3, 1, 1, {0x11}, 0x2781},
        {20, 21, 8, 3, 0, 0, {0}, 0},             {20, 20, 8, 2, 1, 1, {0x11}, 0x2781},     {20, 20, 8, 1, 0, 0, {0}, 0},
    };
    for (k = 0; k < sizeof cases / sizeof cases[0]; k++) {
        const HitCase *c = &cases[k];
        int result;
        c_prepare(&w, 2, 3);
        c_cell(1, 2, 0x1234, 10, 20, 30, 40);
        set32(c_self, 0x4f, (uint32_t)c->f4f);
        set32(c_self, 0x53, (uint32_t)c->f53);
        set32(c_rec, 0x34b, 200);   /* the outer box does not contain y: no final hit */
        set32(c_rec, 0x353, 300);
        queue_return(0x4619be, c->ret);
        c_probe_state();
        memcpy(c_exp, c_self, sizeof c_exp);
        result = c_run(&w, c->x, c->y);
        set16(c_exp, 0x39, 0x1234);
        set16(c_exp, 0x5b, 1);
        set16(c_exp, 0x5d, 2);
        if (c->code == 0) set16(c_exp, 0x57, 0);
        CK(result == (c->code != 0 ? 1 : 0));
        CK(L.n == c->nd + (c->code != 0 ? 1 : 0));
        for (i = 0; i < c->nd; i++) {
            CK(is_call(i, 0x4619be, (uintptr_t)c_self, 1) && L.c[i].a[0] == c->dirs[i]);
            CK(get16(L.c[i].probe, 0) == 0x1234 && get16(L.c[i].probe, 2) == 1 && get16(L.c[i].probe, 4) == 2);
        }
        if (c->code != 0) CK(is_call(c->nd, 0x4630a3, (uintptr_t)c_self, 1) && L.c[c->nd].a[0] == c->code);
        CK(memcmp(c_self, c_exp, sizeof c_self) == 0);
    }
    /* the origin moves the point: x = 5 + 15, y = 7 + 15 */
    c_prepare(&w, 2, 3);
    c_cell(1, 2, 7, 10, 20, 30, 40);
    w.origin_x_583186 = 15;
    w.origin_y_58318a = 15;
    queue_return(0x4619be, 1);
    CK(c_run(&w, 5, 7) == 1 && L.n == 2 && L.c[1].a[0] == 0x2781);
    /* cells are visited row by row (rows outer, columns inner); only cells with a word are asked; a cell outside rows x cols is not visited */
    c_prepare(&w, 2, 3);
    c_cell(0, 2, 5, 10, 20, 30, 40);
    c_cell(1, 0, 6, 10, 20, 30, 40);
    c_cell(0, 3, 7, 10, 20, 30, 40);
    c_cell(2, 0, 8, 10, 20, 30, 40);
    set32(c_rec, 0x34b, 200);
    c_probe_state();
    queue_return(0x4619be, 0);
    CK(c_run(&w, 20, 22) == 0 && L.n == 2);
    CK(get16(L.c[0].probe, 0) == 5 && get16(L.c[0].probe, 2) == 0 && get16(L.c[0].probe, 4) == 2);
    CK(get16(L.c[1].probe, 0) == 6 && get16(L.c[1].probe, 2) == 1 && get16(L.c[1].probe, 4) == 0);
    CK(get16(c_self, 0x39) == 6 && get16(c_self, 0x5b) == 1 && get16(c_self, 0x5d) == 0 && get16(c_self, 0x57) == 0);
    /* a dword result other than 1 (0xffffffff, 2, 0x80000001) is not an acceptance */
    for (k = 0; k < 3; k++) {
        c_prepare(&w, 2, 3);
        c_cell(1, 2, 7, 10, 20, 30, 40);
        set32(c_rec, 0x34b, 200);
        queue_return(0x4619be, k == 0 ? 0xffffffffu : k == 1 ? 2u : 0x80000001u);
        CK(c_run(&w, 20, 22) == 0 && L.n == 1);
    }
    /* the guards: [this+0x3f] = 0 and [this+0x24] = 2 return 0 with nothing stored and no call */
    c_prepare(&w, 2, 3);
    c_cell(1, 2, 7, 10, 20, 30, 40);
    set32(c_self, 0x3f, 0);
    memcpy(c_exp, c_self, sizeof c_exp);
    CK(c_run(&w, 20, 22) == 0 && L.n == 0 && memcmp(c_self, c_exp, sizeof c_self) == 0);
    set32(c_self, 0x3f, 1);
    set32(c_self, 0x24, 2);
    memcpy(c_exp, c_self, sizeof c_exp);
    CK(c_run(&w, 20, 22) == 0 && L.n == 0 && memcmp(c_self, c_exp, sizeof c_self) == 0);
    set32(c_self, 0x24, 3);
    queue_return(0x4619be, 0);
    CK(c_run(&w, 20, 22) == 1 && L.n == 2 && L.c[1].callee == 0x4630a3 && L.c[1].a[0] == 0x277f);   /* any other value runs; 0x4619be declined, the outer box hits */
    /* the outer box (x, y words against signed dwords, no origin): y 50 .. 60, x 5 .. 15, tested after the grid; no cell has a word */
    {
        static const int xs[] = {4, 5, 15, 16, -3, 0}, ys[] = {49, 50, 60, 61, 55, 55};
        static const int xhit[] = {0, 1, 1, 0, 1, 0};   /* with the box x -5 .. 15 for -3 */
        for (k = 0; k < 6; k++) {
            int yy = (k < 4) ? 55 : ys[k], xx = (k < 4) ? 10 : xs[k];
            c_prepare(&w, 2, 3);
            w.origin_x_583186 = 1000;
            w.origin_y_58318a = -1000;
            set32(c_rec, 0x34b, 50);
            set32(c_rec, 0x353, 60);
            set32(c_rec, 0x347, 5);
            set32(c_rec, 0x34f, 15);
            if (k == 4) set32(c_rec, 0x347, (uint32_t)-5);
            if (k < 4) {
                xx = k == 0 ? 4 : k == 1 ? 5 : k == 2 ? 15 : 16;
                yy = 55;
            }
            CK(c_run(&w, xx, yy) == (k < 4 ? (int)(k == 1 || k == 2) : xhit[k]));
            if (k < 4 ? (k == 1 || k == 2) : xhit[k]) CK(L.n == 1 && is_call(0, 0x4630a3, (uintptr_t)c_self, 1) && L.c[0].a[0] == 0x277f);
            else CK(L.n == 0);
            CK(get16(c_self, 0x57) == 0);
        }
        for (k = 0; k < 4; k++) {
            static const int yv[] = {49, 50, 60, 61};
            c_prepare(&w, 2, 3);
            set32(c_rec, 0x34b, 50);
            set32(c_rec, 0x353, 60);
            set32(c_rec, 0x347, 5);
            set32(c_rec, 0x34f, 15);
            CK(c_run(&w, 10, yv[k]) == (k == 1 || k == 2));
            CK(L.n == (k == 1 || k == 2 ? 1 : 0));
        }
        (void)xs;
    }
}

/* ---- 0x484f42 ---- */

#define D_REC_VA 0x00d50000u

static uint8_t d_self[0xd00], d_exp[0xd00], d_rec[0x1000], d_rexp[0x1000], d_rect[16], d_records[0x8d * 5];

/* the record 3 holds the object d_rec; self+0xba7 != 0; rect = {11, 22, 33, 44}; every other byte is 0 */
static void d_prepare(Fl21aWorld *w, uint32_t a92)
{
    reset_log();
    add_region(D_REC_VA, d_rec, sizeof d_rec);
    memset(d_self, 0, sizeof d_self);
    memset(d_rec, 0, sizeof d_rec);
    memset(d_records, 0x11, sizeof d_records);
    memset(w, 0, sizeof *w);
    w->records_5bb5e5 = d_records + 0x8d;
    set32(w->records_5bb5e5 + 3 * 0x8d, 0, D_REC_VA);
    set16(d_self, 0x26, 3);
    set32(d_self, 0xba7, 1);
    set32(d_self, 0xa92, a92);
    set32(d_rect, 0, 11);
    set32(d_rect, 4, 22);
    set32(d_rect, 8, 33);
    set32(d_rect, 0xc, 44);
}

static int d_run(Fl21aWorld *w, int x, int y)
{
    Fl18Host h = host();
    return (int)m484f42_pointer_move(d_self, (int16_t)x, (int16_t)y, d_rect, w, &h);
}

static void d_probe_state(uint32_t callee)
{
    L.probe_callee = callee;   /* at the call: the two counters, the rectangle copies and the record's word +0x2b */
    L.probe_ptr[0] = d_self + 0xbf9;
    L.probe_len[0] = 2;
    L.probe_ptr[1] = d_self + 0xc23;
    L.probe_len[1] = 2;
    L.probe_ptr[2] = d_self + 0xbb1;
    L.probe_len[2] = 16;
    L.probe_ptr[3] = d_rec + 0x2b;
    L.probe_len[3] = 2;
    L.nprobe = 4;
}

static void d_rect_copies(uint8_t *self)
{
    set32(self, 0xbb1, 11);
    set32(self, 0xbb5, 22);
    set32(self, 0xbb9, 33);
    set32(self, 0xbbd, 44);
}

static void d_slot(int i, int32_t left, int32_t top, int32_t right, int32_t bottom, uint8_t flag23, uint8_t flag22)
{
    uint8_t *s = d_self + 0x28 + i * 0x85;
    set32(s, 2, (uint32_t)left);
    set32(s, 6, (uint32_t)top);
    set32(s, 0xa, (uint32_t)right);
    set32(s, 0xe, (uint32_t)bottom);
    s[0x23] = flag23;
    s[0x22] = flag22;
}

static void test_m484f42_pointer_move(void)
{
    Fl21aWorld w;
    size_t k;
    int result;
    static const int bx[] = {10, 30, 9, 31, 20, 20, 20, 20, 10, 30};
    static const int by[] = {20, 40, 30, 30, 19, 41, 20, 40, 41, 19};
    static const int bok[] = {1, 1, 0, 0, 0, 0, 1, 1, 0, 0};
    /* [self+0xba7] = 0: nothing at all */
    d_prepare(&w, 1);
    set32(d_self, 0xba7, 0);
    memcpy(d_exp, d_self, sizeof d_exp);
    CK(d_run(&w, 1, 2) == 0 && L.n == 0 && memcmp(d_self, d_exp, sizeof d_self) == 0);
    /* mode [self+0xa92] != 0: the rectangle copies are stored in the order +0xbb5, +0xbbd, +0xbb1, +0xbb9 (all before 0x484d87, whose call
     * state shows them), then the point is tested against the box [rec+0x5b7] .. [rec+0x5bf] x [rec+0x5bb] .. [rec+0x5c3] */
    for (k = 0; k < 10; k++) {
        d_prepare(&w, 0x100);
        set32(d_rec, 0x5b7, 10);
        set32(d_rec, 0x5bb, 20);
        set32(d_rec, 0x5bf, 30);
        set32(d_rec, 0x5c3, 40);
        d_rec[0x2a] = 1;
        set16(d_rec, 0x2b, 0x7777);
        set32(d_rec, 0xa3, 0);
        d_probe_state(0x484d87);
        memcpy(d_exp, d_self, sizeof d_exp);
        result = d_run(&w, bx[k], by[k]);
        CK(L.n >= 1 && is_call(0, 0x484d87, (uintptr_t)d_self, 0) && get32(L.c[0].probe, 4) == 11 && get32(L.c[0].probe, 8) == 22 &&
           get32(L.c[0].probe, 12) == 33 && get32(L.c[0].probe, 16) == 44);
        d_rect_copies(d_exp);
        if (!bok[k]) CK(result == 0 && L.n == 1 && memcmp(d_self, d_exp, sizeof d_self) == 0);
        else CK(result == 1 && L.n == 2 && is_call(1, 0x4854fb, (uintptr_t)d_self, 1));
    }
    /* an empty box ([rec+0x5bf] == [rec+0x5b7]) accepts every point; [rec+0x2a] = 0 zeroes the word [rec+0x2b] first (call-time: still 0 at
     * 0x484d87, already 0 at 0x4854fb) */
    d_prepare(&w, 1);
    set32(d_rec, 0x5b7, 77);
    set32(d_rec, 0x5bf, 77);
    set16(d_rec, 0x2b, 0x7777);
    d_self[0x22 + 0x28] = 1;   /* slot byte +0x22 != 0 */
    d_probe_state(0x4854fb);
    memcpy(d_rexp, d_rec, sizeof d_rexp);
    result = d_run(&w, -5, 1000);
    set16(d_rexp, 0x2b, 0);
    CK(result == 1 && L.n == 2 && is_call(1, 0x4854fb, (uintptr_t)d_self, 1) && L.c[1].a[0] == 0x277a && get16(L.c[1].probe, 20) == 0);
    CK(memcmp(d_rec, d_rexp, sizeof d_rec) == 0);
    /* the four compares against the entry of the slot index 1 (e = 0x42): [rec+e+0xa3] = 100, +0xab = 200, +0x9f = 50, +0xa7 = 80, t = the signed
     * word [rec+0x2b] (the byte [rec+0x2a] != 0): [self+0xaa4] >= 100 - t, [self+0xaac] <= 200 + t, [self+0xaa0] >= 50 - t, [self+0xaa8] <= 80 + t
     * and the byte [slot+0x22] == 0 give 0x277b; any one of them one step the wrong way gives 0x277a */
    {
        static const int32_t tvals[3] = {2, -3, 0};
        int variant, t;
        for (t = 0; t < 3; t++) {
            for (variant = 0; variant < 6; variant++) {
                int32_t v[4];
                d_prepare(&w, 1);
                set32(d_rec, 0x5b7, 10);
                set32(d_rec, 0x5bf, 10);   /* an empty box: accepts */
                d_rec[0x2a] = 1;
                set16(d_rec, 0x2b, (uint16_t)tvals[t]);
                set16(d_self, 0xa9e, 1);
                set32(d_rec, 0x42 + 0xa3, 100);
                set32(d_rec, 0x42 + 0xab, 200);
                set32(d_rec, 0x42 + 0x9f, 50);
                set32(d_rec, 0x42 + 0xa7, 80);
                v[0] = 100 - tvals[t];
                v[1] = 200 + tvals[t];
                v[2] = 50 - tvals[t];
                v[3] = 80 + tvals[t];
                if (variant >= 1 && variant <= 4) v[variant - 1] += (variant == 1 || variant == 3) ? -1 : 1;
                if (variant == 5) d_self[0x28 + 0x85 + 0x22] = 1;
                set32(d_self, 0xaa4, (uint32_t)v[0]);
                set32(d_self, 0xaac, (uint32_t)v[1]);
                set32(d_self, 0xaa0, (uint32_t)v[2]);
                set32(d_self, 0xaa8, (uint32_t)v[3]);
                CK(d_run(&w, 3, 4) == 1 && L.n == 2 && is_call(1, 0x4854fb, (uintptr_t)d_self, 1));
                CK(L.c[1].a[0] == (variant == 0 ? 0x277bu : 0x277au));
            }
        }
    }
    /* mode [self+0xa92] == 0: the list of slots; rec +0x21 = 3 slots, rect heights h = [rec+0x26] = 5 and w = [rec+0x28] = 6, bytes +0x24 and +0x25
     * set; slot 0 = (10, 20) .. (50, 60), slot 1 = (100, 100) .. (120, 120), slot 2 = (12, 22) .. (16, 26). The first test of a slot is
     * y in [top, top + h] and x in [left, left + w]; the second (only when the first fails and the slot byte +0x23 is 0) is y in [top, bottom], x in
     * [left, right]. variant: 1 = slot 2 bottom 60 with its byte +0x23 = 1, 2 = slot 2 bottom 60, 3 = [rec+0x24] = 0, 4 = [rec+0x25] = 0 */
    {
        static const struct {
            int x, y, variant;
            int n1, l1[3];        /* the slots of the first test, in order (words at +0xbfb, count at +0xc23) */
            int n2, l2[3];        /* the slots of the second test (words at +0xbd1, count at +0xbf9) */
            uint16_t code;
        } cases[] = {
            {12, 22, 0, 2, {0, 2, 0}, 0, {0, 0, 0}, 0x2778},   {40, 50, 0, 0, {0, 0, 0}, 1, {0, 0, 0}, 0x2777},   {16, 25, 0, 2, {0, 2, 0}, 0, {0, 0, 0}, 0x2778},
            {17, 25, 0, 1, {2, 0, 0}, 1, {0, 0, 0}, 0x2778},   {75, 75, 0, 0, {0, 0, 0}, 0, {0, 0, 0}, 0},        {50, 60, 0, 0, {0, 0, 0}, 1, {0, 0, 0}, 0x2777},
            {51, 60, 0, 0, {0, 0, 0}, 0, {0, 0, 0}, 0},        {50, 61, 0, 0, {0, 0, 0}, 0, {0, 0, 0}, 0},        {9, 40, 0, 0, {0, 0, 0}, 0, {0, 0, 0}, 0},
            {10, 19, 0, 0, {0, 0, 0}, 0, {0, 0, 0}, 0},        {14, 40, 1, 0, {0, 0, 0}, 1, {0, 0, 0}, 0x2777},   {14, 40, 2, 0, {0, 0, 0}, 2, {0, 2, 0}, 0x2777},
            {12, 22, 3, 0, {0, 0, 0}, 2, {0, 2, 0}, 0x2777},   {12, 22, 4, 0, {0, 0, 0}, 2, {0, 2, 0}, 0x2777},   {110, 110, 0, 0, {0, 0, 0}, 1, {1, 0, 0}, 0x2777},
            {106, 100, 0, 1, {1, 0, 0}, 0, {0, 0, 0}, 0x2778}, {107, 100, 0, 0, {0, 0, 0}, 1, {1, 0, 0}, 0x2777},
        };
        size_t n;
        int j;
        for (n = 0; n < sizeof cases / sizeof cases[0]; n++) {
            d_prepare(&w, 0);
            set16(d_rec, 0x21, 3);
            d_rec[0x24] = cases[n].variant == 3 ? 0 : 1;
            d_rec[0x25] = cases[n].variant == 4 ? 0 : 1;
            set16(d_rec, 0x26, 5);
            set16(d_rec, 0x28, 6);
            d_slot(0, 10, 20, 50, 60, 0, 0);
            d_slot(1, 100, 100, 120, 120, 0, 0);
            if (cases[n].variant == 1) d_slot(2, 12, 22, 16, 60, 1, 0);
            else if (cases[n].variant == 2) d_slot(2, 12, 22, 16, 60, 0, 0);
            else d_slot(2, 12, 22, 16, 26, 0, 0);
            memset(d_self + 0xbd1, 0xee, 0x28);
            set16(d_self, 0xbf9, 0x5555);
            set16(d_self, 0xc23, 0x5555);
            d_probe_state(0x4854fb);
            memcpy(d_exp, d_self, sizeof d_exp);
            result = d_run(&w, cases[n].x, cases[n].y);
            d_rect_copies(d_exp);
            memset(d_exp + 0xbd1, 0, 0x28);
            set16(d_exp, 0xbf9, (uint16_t)cases[n].n2);
            set16(d_exp, 0xc23, (uint16_t)cases[n].n1);
            for (j = 0; j < cases[n].n1; j++) set16(d_exp, 0xbfb + 2 * j, (uint16_t)cases[n].l1[j]);
            for (j = 0; j < cases[n].n2; j++) set16(d_exp, 0xbd1 + 2 * j, (uint16_t)cases[n].l2[j]);
            CK(memcmp(d_self, d_exp, sizeof d_self) == 0);
            if (cases[n].code != 0) {
                CK(result == 1 && L.n == 1 && is_call(0, 0x4854fb, (uintptr_t)d_self, 1) && L.c[0].a[0] == cases[n].code);
                /* at the call the counters and the lists are final */
                CK(get16(L.c[0].probe, 0) == (uint16_t)cases[n].n2 && get16(L.c[0].probe, 2) == (uint16_t)cases[n].n1);
            } else {
                CK(result == 0 && L.n == 0);
            }
        }
    }
    /* after the lists: the box 2 (needs [self+0xc27] != 0): x in [rec+0x5f8, rec+0x600), y in [rec+0x5fc, rec+0x604]; then the box 3: x in
     * [rec+0xef7, rec+0xeff], y in [rec+0xefb, rec+0xf03] */
    {
        static const struct {
            int x, y;
            uint32_t flag;
            uint16_t code;
        } cases[] = {
            {70, 70, 1, 0x277c},  {89, 90, 1, 0x277c},  {90, 70, 1, 0},       {70, 91, 1, 0},       {69, 70, 1, 0},       {70, 69, 1, 0},
            {75, 75, 0, 0},       {200, 200, 0, 0x2779}, {210, 210, 0, 0x2779}, {211, 210, 0, 0},     {200, 211, 0, 0},     {199, 200, 0, 0},
            {200, 199, 0, 0},     {205, 205, 1, 0x2779}, {-5, -7, 0, 0},
        };
        size_t n;
        for (n = 0; n < sizeof cases / sizeof cases[0]; n++) {
            d_prepare(&w, 0);
            set16(d_rec, 0x21, 3);
            d_rec[0x24] = 1;
            d_rec[0x25] = 1;
            set16(d_rec, 0x26, 5);
            set16(d_rec, 0x28, 6);
            d_slot(0, 10, 20, 50, 60, 0, 0);
            d_slot(1, 100, 100, 120, 120, 0, 0);
            d_slot(2, 12, 22, 16, 26, 0, 0);
            set32(d_self, 0xc27, cases[n].flag);
            set32(d_rec, 0x5f8, 70);
            set32(d_rec, 0x600, 90);
            set32(d_rec, 0x5fc, 70);
            set32(d_rec, 0x604, 90);
            set32(d_rec, 0xef7, 200);
            set32(d_rec, 0xeff, 210);
            set32(d_rec, 0xefb, 200);
            set32(d_rec, 0xf03, 210);
            result = d_run(&w, cases[n].x, cases[n].y);
            if (cases[n].code != 0) CK(result == 1 && L.n == 1 && is_call(0, 0x4854fb, (uintptr_t)d_self, 1) && L.c[0].a[0] == cases[n].code);
            else CK(result == 0 && L.n == 0);
        }
    }
    /* the box 3 in signed compares: x = -5, y = -7 against the box -10 .. -1 */
    d_prepare(&w, 0);
    set32(d_rec, 0xef7, (uint32_t)-10);
    set32(d_rec, 0xeff, (uint32_t)-1);
    set32(d_rec, 0xefb, (uint32_t)-10);
    set32(d_rec, 0xf03, (uint32_t)-1);
    CK(d_run(&w, -5, -7) == 1 && L.n == 1 && L.c[0].a[0] == 0x2779);
    CK(d_run(&w, -11, -7) == 0 && L.n == 1);
}

/* ---- 0x48d914 ---- */

#define E_REC_VA 0x00d60000u

static uint8_t e_self[0x100], e_exp[0x100], e_rec[0x800], e_records[0x8d * 6], e_table[0x4a * 7], e_texp[0x4a * 7], e_flags[0x80], e_fexp[0x80];
static const uint8_t e_bytes9[9] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'};
static const uint8_t e_name[8] = {'s', 'c', 'e', 'n', 'e', '0', '1', 0};

#define E_FLAG(w, n) ((w).flags_585801 + (ptrdiff_t)(n) * 4)

/* the record 2 holds the object e_rec in the given state; byte 0x63a8ac = 'Z'; the dword table at 0x585801 has 0x20 dwords, the base at
 * dword 16 (indices -16 .. 15); nothing else is set */
static void e_prepare(Fl21aWorld *w, uint32_t state)
{
    reset_log();
    add_region(E_REC_VA, e_rec, sizeof e_rec);
    memset(e_self, 0x5a, sizeof e_self);
    memset(e_rec, 0, sizeof e_rec);
    memset(e_records, 0x11, sizeof e_records);
    memset(e_table, 0x33, sizeof e_table);
    memset(e_flags, 0x44, sizeof e_flags);
    memset(w, 0, sizeof *w);
    w->records_5bb5e5 = e_records + 0x8d;
    w->table_5d1591 = e_table + 0x4a;
    w->string_54e89c = e_name;
    w->bytes_54e8d4 = e_bytes9;
    w->flags_585801 = e_flags + 64;
    w->byte_63a8ac = 'Z';
    set32(w->records_5bb5e5 + 2 * 0x8d, 0, E_REC_VA);
    set32(w->records_5bb5e5 + 2 * 0x8d, 0x4d, state);
    memcpy(e_rec + 0x761, e_bytes9, 9);
    set16(e_self, 0x1e, 2);
}

static void e_run(Fl21aWorld *w, int index)
{
    Fl18Host h = host();
    m48d914_step_scene(e_self, (int16_t)index, w, &h);
}

static void e_record_state(Fl21aWorld *w, uint32_t expect, int *ok)
{
    *ok = get32(w->records_5bb5e5 + 2 * 0x8d, 0x4d) == expect;
}

static void test_m48d914_step_scene(void)
{
    Fl21aWorld w;
    size_t k;
    int ok;
    uint8_t *t;
    /* state 0, the first byte of the record's string equals the byte at 0x63a8ac: [self+0x2f] = 0, no table record, one call 0x4e8d96 on
     * 0x571442; call-time: the stores before it are visible (+0x1e, +0x33, +0x20, 0x5bb1ca = 1), the zeroing of +0x3d ... after it is not */
    e_prepare(&w, 0);
    e_rec[0] = 'Z';
    w.value_5bb1ca = 0x77;
    memcpy(e_texp, e_table, sizeof e_texp);
    memcpy(e_exp, e_self, sizeof e_exp);
    L.probe_callee = 0x4e8d96;
    L.probe_ptr[0] = e_self + 0x1e;
    L.probe_len[0] = 2;
    L.probe_ptr[1] = e_self + 0x33;
    L.probe_len[1] = 4;
    L.probe_ptr[2] = e_self + 0x20;
    L.probe_len[2] = 4;
    L.probe_ptr[3] = (const uint8_t *)&w.value_5bb1ca;
    L.probe_len[3] = 4;
    L.probe_ptr[4] = e_self + 0x3d;
    L.probe_len[4] = 4;
    L.probe_ptr[5] = e_self + 0x37;
    L.probe_len[5] = 2;
    L.nprobe = 6;
    e_run(&w, 2);
    CK(L.n == 1 && is_call(0, 0x4e8d96, 0x571442, 0));
    CK(get16(L.c[0].probe, 0) == 2 && get32(L.c[0].probe, 2) == 1 && get32(L.c[0].probe, 6) == 0 && get32(L.c[0].probe, 10) == 1 &&
       get32(L.c[0].probe, 14) == 0x5a5a5a5au && get16(L.c[0].probe, 18) == 0x5a5a);
    set16(e_exp, 0x1e, 2);
    set32(e_exp, 0x33, 1);
    e_exp[0x26] = e_exp[0x25] = e_exp[0x24] = 0;
    set32(e_exp, 0x20, 0);
    set32(e_exp, 0x3d, 0);
    set32(e_exp, 0x41, 0);
    set32(e_exp, 0x45, 0);
    set16(e_exp, 0x49, 0);
    e_exp[0x4b] = 0;
    e_exp[0x38] = e_exp[0x37] = 0;
    set32(e_exp, 0x2f, 0);
    set32(e_exp, 0x2b, 1);
    CK(memcmp(e_self, e_exp, sizeof e_self) == 0 && memcmp(e_table, e_texp, sizeof e_table) == 0 && w.value_5bb1ca == 1);
    e_record_state(&w, 1, &ok);
    CK(ok);
    /* state 0, another first byte: [self+0x2f] = 1, 0x4d39f9 returns the word 3 (upper half a leftover), the record 3 of the table at 0x5d1591 gets
     * its fields and the string "scene01", 0x4c2790 on 0x5cf659 (0x54e8cc, the object address, 6, 0x54e8b4) returns the value stored at +8 and
     * [self+0x20] */
    e_prepare(&w, 0);
    e_rec[0] = 'Y';
    queue_return(0x4d39f9, 0xabcd0003u);
    queue_return(0x4c2790, 0x1234abcdu);
    memcpy(e_texp, e_table, sizeof e_texp);
    memcpy(e_exp, e_self, sizeof e_exp);
    L.probe_callee = 0x4c2790;   /* at the call: +0x1c = 3, +0x20 = 0, and the +8 dword of the record is still 0 */
    L.probe_ptr[0] = e_self + 0x1c;
    L.probe_len[0] = 2;
    L.probe_ptr[1] = e_self + 0x20;
    L.probe_len[1] = 4;
    L.probe_ptr[2] = e_table + 0x4a + 3 * 0x4a + 8;
    L.probe_len[2] = 4;
    L.probe_ptr[3] = e_table + 0x4a + 3 * 0x4a + 0x22;
    L.probe_len[3] = 8;
    L.nprobe = 4;
    e_run(&w, 2);
    CK(L.n == 3 && is_call(0, 0x4e8d96, 0x571442, 0) && is_call(1, 0x4d39f9, 0, 0) && is_call(2, 0x4c2790, 0x5cf659, 4));
    CK(L.c[2].a[0] == 0x54e8cc && L.c[2].a[1] == E_REC_VA && L.c[2].a[2] == 6 && L.c[2].a[3] == 0x54e8b4);
    CK(get16(L.c[2].probe, 0) == 3 && get32(L.c[2].probe, 2) == 0 && get32(L.c[2].probe, 6) == 0 && memcmp(L.c[2].probe + 10, e_name, 8) == 0);
    set16(e_exp, 0x1e, 2);
    set32(e_exp, 0x33, 1);
    e_exp[0x26] = e_exp[0x25] = e_exp[0x24] = 0;
    set32(e_exp, 0x3d, 0);
    set32(e_exp, 0x41, 0);
    set32(e_exp, 0x45, 0);
    set16(e_exp, 0x49, 0);
    e_exp[0x4b] = 0;
    e_exp[0x38] = e_exp[0x37] = 0;
    set32(e_exp, 0x2f, 1);
    set16(e_exp, 0x1c, 3);
    set32(e_exp, 0x20, 0x1234abcdu);
    set32(e_exp, 0x2b, 1);
    CK(memcmp(e_self, e_exp, sizeof e_self) == 0);
    t = e_texp + 0x4a + 3 * 0x4a;
    set32(t, 0, 0xa);
    set32(t, 4, 0x48ded7);
    set32(t, 8, 0x1234abcdu);
    set32(t, 0xc, 0);
    set32(t, 0x10, 0);
    set32(t, 0x14, 1);
    set32(t, 0x18, 1);
    set16(t, 0x1c, 0);
    memcpy(t + 0x22, e_name, 8);
    CK(memcmp(e_table, e_texp, sizeof e_table) == 0);
    /* the skip of 0x4c2790 when 0x4d39f9 left [self+0x20] != 0 (a callee side effect that no valid call has): +8 := that value */
    e_prepare(&w, 0);
    e_rec[0] = 'Y';
    queue_return(0x4d39f9, 0xffffffffu);   /* the word -1: the record -1 of the table */
    L.abs_target = e_self;
    queue_write(0x4d39f9, 0, -2, 0x20, 4, 0x9999);
    e_run(&w, 2);
    CK(L.n == 2 && get32(e_self, 0x20) == 0x9999 && get16(e_self, 0x1c) == 0xffff && get32(e_table, 8) == 0x9999);
    /* state 1, v = 0: GetTickCount (unsigned) >= [self+0x39] -> 0x4fba69 on 0x5c3a67 with the object address + 0x715, [self+0x2b] := 1, bytes 0x24 = 0x25 = 1, 0x26 = 0 */
    {
        static const uint32_t ticks[6] = {1000, 1000, 0, 0xffffffffu, 5, 0x80000000u};
        static const uint32_t limits[6] = {1000, 1001, 0xffffffffu, 0, 0x80000000u, 0x7fffffffu};
        static const int hits[6] = {1, 0, 0, 1, 0, 1};
        for (k = 0; k < 6; k++) {
            e_prepare(&w, 1);
            set32(e_self, 0x2b, 0);
            set32(e_self, 0x39, limits[k]);
            L.tick = ticks[k];
            memcpy(e_exp, e_self, sizeof e_exp);
            e_run(&w, 2);
            CK(L.ticks == 1);
            if (hits[k]) {
                CK(L.n == 1 && is_call(0, 0x4fba69, 0x5c3a67, 1) && L.c[0].a[0] == E_REC_VA + 0x715);
                set32(e_exp, 0x2b, 1);
                e_exp[0x24] = 1;
                e_exp[0x25] = 1;
                e_exp[0x26] = 0;
            } else {
                CK(L.n == 0);
            }
            CK(memcmp(e_self, e_exp, sizeof e_self) == 0);
            e_record_state(&w, 1, &ok);
            CK(ok);
        }
    }
    /* v = 1: 0x48d89e on self only when [self+0x2f] == 0 */
    for (k = 0; k < 2; k++) {
        e_prepare(&w, 1);
        set32(e_self, 0x2b, 1);
        set32(e_self, 0x2f, k == 0 ? 0 : 0x100);
        memcpy(e_exp, e_self, sizeof e_exp);
        e_run(&w, 2);
        CK(L.ticks == 0 && memcmp(e_self, e_exp, sizeof e_self) == 0);
        CK(k == 0 ? (L.n == 1 && is_call(0, 0x48d89e, (uintptr_t)e_self, 0)) : L.n == 0);
    }
    /* v = 2: [self+0x39] := GetTickCount + (signed word [rec+0x75f]) * 1000, [self+0x2b] := 3 */
    {
        static const int16_t words[4] = {5, -3, 0, -32768};
        for (k = 0; k < 4; k++) {
            e_prepare(&w, 1);
            set32(e_self, 0x2b, 2);
            set16(e_rec, 0x75f, (uint16_t)words[k]);
            L.tick = 1234;
            memcpy(e_exp, e_self, sizeof e_exp);
            e_run(&w, 2);
            set32(e_exp, 0x39, 1234u + (uint32_t)((int32_t)words[k] * 1000));
            set32(e_exp, 0x2b, 3);
            CK(L.ticks == 1 && L.n == 0 && memcmp(e_self, e_exp, sizeof e_self) == 0);
        }
    }
    /* v = 3: tick >= [self+0x39]: the nine bytes at rec+0x761 against those at 0x54e8d4; a difference (any position) -> 0x4fb77a (object + 0x761),
     * 0x4fb2e3 (the word [rec+0x782]), [self+0x2b] := 4; equal -> the record [self+0x1e] := state 2; tick < [self+0x39]: nothing */
    for (k = 0; k < 12; k++) {
        e_prepare(&w, 1);
        set32(e_self, 0x2b, 3);
        set32(e_self, 0x39, k == 10 ? 2000 : 1000);
        set16(e_rec, 0x782, 0xbeef);
        L.tick = k == 11 ? 1000 : k == 10 ? 1999 : 1000;
        if (k < 9) e_rec[0x761 + k] ^= 0x01;   /* the position k differs */
        memcpy(e_exp, e_self, sizeof e_exp);
        e_run(&w, 2);
        CK(L.ticks == 1);
        if (k == 10) {   /* tick 1999 < 2000 */
            CK(L.n == 0 && memcmp(e_self, e_exp, sizeof e_self) == 0);
            e_record_state(&w, 1, &ok);
            CK(ok);
        } else if (k < 9) {
            CK(L.n == 2 && is_call(0, 0x4fb77a, 0x5c3a67, 1) && L.c[0].a[0] == E_REC_VA + 0x761 && is_call(1, 0x4fb2e3, 0x5c3a67, 1) &&
               (L.c[1].a[0] & 0xffff) == 0xbeef);
            set32(e_exp, 0x2b, 4);
            CK(memcmp(e_self, e_exp, sizeof e_self) == 0);
            e_record_state(&w, 1, &ok);
            CK(ok);
        } else {   /* 9: all equal at tick == limit; 11: all equal, the state of the record of [self+0x1e] becomes 2 */
            CK(L.n == 0 && memcmp(e_self, e_exp, sizeof e_self) == 0);
            e_record_state(&w, 2, &ok);
            CK(ok);
        }
    }
    /* v = 4: 0x4f6334 on 0x5cf1eb with the sign-extended word [rec+0x782]; 0 -> 0x4fba69 (object + 0x761) and the record := 2 */
    for (k = 0; k < 4; k++) {
        static const uint16_t words[4] = {0xfffe, 5, 0x8000, 0};
        static const uint32_t rets[4] = {0, 0, 1, 0xffffffffu};
        e_prepare(&w, 1);
        set32(e_self, 0x2b, 4);
        set16(e_rec, 0x782, words[k]);
        queue_return(0x4f6334, rets[k]);
        memcpy(e_exp, e_self, sizeof e_exp);
        e_run(&w, 2);
        CK(L.ticks == 0 && memcmp(e_self, e_exp, sizeof e_self) == 0);
        CK(is_call(0, 0x4f6334, 0x5cf1eb, 1) && L.c[0].a[0] == (uint32_t)(int32_t)(int16_t)words[k]);
        if (rets[k] == 0) {
            CK(L.n == 2 && is_call(1, 0x4fba69, 0x5c3a67, 1) && L.c[1].a[0] == E_REC_VA + 0x761);
            e_record_state(&w, 2, &ok);
        } else {
            CK(L.n == 1);
            e_record_state(&w, 1, &ok);
        }
        CK(ok);
    }
    /* v = 5, 0xffffffff (unsigned > 4): nothing; an unknown record state (3): nothing */
    for (k = 0; k < 3; k++) {
        e_prepare(&w, k == 2 ? 3 : 1);
        set32(e_self, 0x2b, k == 0 ? 5 : k == 1 ? 0xffffffffu : 0);
        memcpy(e_exp, e_self, sizeof e_exp);
        e_run(&w, 2);
        CK(L.n == 0 && L.ticks == 0 && memcmp(e_self, e_exp, sizeof e_self) == 0);
    }
    /* state 2: 0x5bb1ca := 1 first. [self+0x37] != 0 uses the record words at 0x792 ..., else [self+0x38] != 0 those at 0x746 ...; neither: only the
     * common tail 0x42ba3a (word [self+0x1e]) and 0x48d09c on self */
    {
        static const struct {
            uint8_t b37, b38;
            int base;          /* the group of record words that is used (0: none) */
            int16_t first, flag, index;
        } cases[] = {
            {0xff, 0, 0x792, 5, 1, -1},  {1, 0, 0x792, 0x270f, 1, 9}, {0, 1, 0x746, -5, 2, -3}, {0, 1, 0x746, 0x270f, 1, 15},
            {1, 1, 0x792, 7, 1, 0},      {0, 0, 0, 0, 0, 0},          {0, 0xff, 0x746, 8, 1, -16}, {1, 0, 0x792, -32768, 3, -1},
        };
        for (k = 0; k < sizeof cases / sizeof cases[0]; k++) {
            const int b = cases[k].base != 0 ? cases[k].base : 0x792;
            const int ob = b == 0x792 ? 0x746 : 0x792;
            uint32_t expect_1ca = 1, expect_999 = 0x77, expect_57b = 0x66;
            e_prepare(&w, 2);
            e_self[0x37] = cases[k].b37;
            e_self[0x38] = cases[k].b38;
            set16(e_rec, b, (uint16_t)cases[k].first);
            set16(e_rec, b + 2, 0x1111);
            set16(e_rec, b + 4, 0x2222);
            set16(e_rec, b + 6, 0x3333);
            set32(e_rec, b + 8, 0x44444444u);
            set32(e_rec, b + 0xc, 0x55555555u);
            set32(e_rec, b + 0x10, 0x66666666u);
            set16(e_rec, b + 0x14, (uint16_t)cases[k].flag);
            set16(e_rec, b + 0x16, (uint16_t)cases[k].index);
            e_rec[b + 0x18] = 0xc3;
            /* the other group holds words that must not be used */
            set16(e_rec, ob, 0x0101);
            set16(e_rec, ob + 0x14, 1);
            set16(e_rec, ob + 0x16, 0x0001);
            e_rec[ob + 0x18] = 0xd4;
            w.value_5bb1ca = 0x55;
            w.value_5bb57b = 0x66;
            w.value_583999 = 0x77;
            memcpy(e_fexp, e_flags, sizeof e_fexp);
            L.probe_callee = 0x42ba3a;
            L.probe_ptr[0] = (const uint8_t *)&w.value_5bb1ca;
            L.probe_len[0] = 4;
            L.probe_ptr[1] = (const uint8_t *)&w.value_583999;
            L.probe_len[1] = 4;
            L.probe_ptr[2] = E_FLAG(w, 9);
            L.probe_len[2] = 4;
            L.nprobe = 3;
            memcpy(e_exp, e_self, sizeof e_exp);
            e_run(&w, 2);
            CK(L.n == 2 && is_call(0, 0x42ba3a, 0, 1) && (L.c[0].a[0] & 0xffff) == 2 && is_call(1, 0x48d09c, (uintptr_t)e_self, 0));
            CK(memcmp(e_self, e_exp, sizeof e_self) == 0);
            if (cases[k].base != 0) {
                if (cases[k].first != 0x270f) {
                    CK(w.word_5bb599 == 0x1111 && w.word_5bb595 == 0x2222 && w.word_5c39ff == 0x3333 && w.value_5bb59b == 0x44444444u &&
                       w.value_5bb59f == 0x55555555u && w.value_5bb5a3 == 0x66666666u);
                    expect_57b = (uint32_t)(int32_t)cases[k].first;
                    expect_999 = 4;
                    expect_1ca = cases[k].flag == 1 ? 0 : 1;
                } else {
                    CK(w.word_5bb599 == 0 && w.word_5bb595 == 0 && w.value_5bb59b == 0);
                }
                if (cases[k].index != -1) set32(e_fexp, 64 + cases[k].index * 4, 0xc3);
            } else {
                CK(w.word_5bb599 == 0 && w.value_5bb59b == 0);
            }
            CK(w.value_5bb57b == expect_57b && w.value_583999 == expect_999 && w.value_5bb1ca == expect_1ca);
            CK(memcmp(e_flags, e_fexp, sizeof e_flags) == 0);
            /* call-time: 0x5bb1ca and 0x583999 (and the flag dword 9) are final before 0x42ba3a */
            CK(get32(L.c[0].probe, 0) == expect_1ca && get32(L.c[0].probe, 4) == expect_999);
            CK(get32(L.c[0].probe, 8) == (cases[k].base != 0 && cases[k].index == 9 ? 0xc3u : 0x44444444u));
        }
    }
}

/* TESTS-HERE */

int main(void)
{
    int failures = 0;
    RUN(test_m4cb586_visit);
    RUN(test_m42caa8_clip_rect);
    RUN(test_m462c39_pointer_move);
    RUN(test_m484f42_pointer_move);
    RUN(test_m48d914_step_scene);
    /* RUN-END */
    return failures;
}
