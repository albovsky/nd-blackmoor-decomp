/* FL-22 (batch b) direct tests of the functions of GAME.EXE in src/original_methods_fl22b.c. Prints "PASS <name>" / "FAIL <name>: <msg>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values come from the disassembly of
 * GAME.EXE, not from running the native code; tests/test_fl22b_differential.py additionally runs the original bytes on random fixtures.
 */
#include "../src/original_methods_fl22b.h"

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

#define REC 0x8du
#define TICK_ID 0x52a23cu

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
    uint32_t callee;        /* TICK_ID for GetTickCount */
    uintptr_t this_ptr;
    int n;
    uintptr_t a[12];
    uint8_t probe[512];     /* the bytes at the host addresses probe_ptr[] (concatenated), as they are at the call */
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
    uint32_t ret_callee[8], ret_value[8][64];  /* per-callee queue of return values (the last one repeats) */
    int ret_count[8], ret_used[8];
    const uint8_t *probe_ptr[32];
    int probe_len[32], nprobe;
    OutWrite w[32];
    int nw;
    int calls_of[16];       /* per callee slot: how many calls were made (for OutWrite.call) */
    uint32_t calls_callee[16];
    Region regions[8];
    int nregions;
    uint32_t tick;
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

UNUSED_OK static void add_probe(const void *p, int len)
{
    L.probe_ptr[L.nprobe] = (const uint8_t *)p;
    L.probe_len[L.nprobe++] = len;
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
            if ((uint64_t)args[k] > 0xffffffffu) memcpy(c->pd[k], (const void *)args[k], 16u);
        if (L.nprobe > 0) {
            int at = 0;
            for (k = 0; k < L.nprobe; k++) {
                memcpy(c->probe + at, L.probe_ptr[k], (size_t)L.probe_len[k]);
                at += L.probe_len[k];
            }
        }
    }
    L.n++;
    for (i = 0; i < L.nw; i++) {
        const OutWrite *w = &L.w[i];
        if (w->callee == callee && w->call == nth) {
            uint8_t *p = (uint8_t *)args[w->arg] + w->off;
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

/* GetTickCount is an event of the ordered call log */
static uint32_t h_tick(void *ctx)
{
    (void)ctx;
    if (L.n < 512) {
        int k, at = 0;
        L.c[L.n].callee = TICK_ID;
        for (k = 0; k < L.nprobe; k++) {   /* the probes are taken at the tick too */
            memcpy(L.c[L.n].probe + at, L.probe_ptr[k], (size_t)L.probe_len[k]);
            at += L.probe_len[k];
        }
    }
    L.n++;
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

UNUSED_OK static int is_tick(int k) { return k < L.n && k < 512 && L.c[k].callee == TICK_ID; }

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

UNUSED_OK static uint8_t g_records[REC * 8];

/* TESTS-BEGIN */

/* ---- 0x42ed54 ---------------------------------------------------------------------------------------------------------------- */

#define RECVA 0x30000000u
#define IDX 2                      /* the record index used by every case */
#define SIDX ((size_t)IDX * REC)   /* its offset in g_records */

static uint8_t g_rec[0xb00], g_tab[48], g_flags[0x100], g_consts[0x40];
static uint8_t x_rec[sizeof g_rec], x_tab[sizeof g_tab], x_flags[sizeof g_flags], x_records[REC * 8];
static Fl22bWorld w42, e42;

/* the offsets of the probe snapshot taken at every host call (call-time state): the state dword, then the world scalars */
enum { PR_STATE = 0, PR_STEP = 4, PR_1CA = 8, PR_D03CF = 12, PR_D1A83 = 16, PR_D1A8F = 20, PR_B5158 = 24, PR_B516A = 25, PR_W5168 = 26, PR_W5166 = 28,
       PR_W5159 = 30, PR_B515D = 32, PR_TAB = 33, PR_57B = 81, PR_59B = 85, PR_59F = 89, PR_5A3 = 93, PR_3999 = 97, PR_W599 = 101, PR_W595 = 103,
       PR_W3FF = 105, PR_515E = 107, PR_FLAGS = 111 };
#define P8(k, o) (L.c[k].probe[o])
#define P16(k, o) get16(L.c[k].probe, o)
#define P32(k, o) get32(L.c[k].probe, o)

static void probe_all_42ed54(void)
{
    add_probe(g_records + SIDX + 0x4d, 4);
    add_probe(&w42.value_5b5162, 4);
    add_probe(&w42.value_5bb1ca, 4);
    add_probe(&w42.value_5d03cf, 4);
    add_probe(&w42.value_5d1a83, 4);
    add_probe(&w42.value_5d1a8f, 4);
    add_probe(&w42.byte_5b5158, 1);
    add_probe(&w42.byte_5b516a, 1);
    add_probe(&w42.word_5b5168, 2);
    add_probe(&w42.word_5b5166, 2);
    add_probe(&w42.word_5b5159, 2);
    add_probe(&w42.byte_5b515d, 1);
    add_probe(g_tab, 48);
    add_probe(&w42.value_5bb57b, 4);
    add_probe(&w42.value_5bb59b, 4);
    add_probe(&w42.value_5bb59f, 4);
    add_probe(&w42.value_5bb5a3, 4);
    add_probe(&w42.value_583999, 4);
    add_probe(&w42.word_5bb599, 2);
    add_probe(&w42.word_5bb595, 2);
    add_probe(&w42.word_5c39ff, 2);
    add_probe(&w42.value_5b515e, 4);
    add_probe(g_flags, 0x80);
}

/* record IDX of the table is the object g_rec in `state`; the world scalars hold recognisable values; the three nine-byte constants are
 * "ABCDEFGHI" (0x545b48), "JKLMNOPQR" (0x545b54) and "STUVWXYZ0" (0x545b60); the record fields at +0x235 and +0x281 equal the first two */
static void setup_42ed54(uint32_t state, uint32_t step)
{
    size_t i;
    for (i = 0; i < sizeof g_rec; i++) g_rec[i] = (uint8_t)(i * 7 + 3);
    for (i = 0; i < sizeof g_tab; i++) g_tab[i] = (uint8_t)(i * 3 + 1);
    for (i = 0; i < sizeof g_flags; i++) g_flags[i] = (uint8_t)(i * 5 + 2);
    memset(g_consts, 0, sizeof g_consts);
    memcpy(g_consts, "ABCDEFGHI", 9);
    memcpy(g_consts + 0x10, "JKLMNOPQR", 9);
    memcpy(g_consts + 0x20, "STUVWXYZ0", 9);
    memcpy(g_rec + 0x235, "ABCDEFGHI", 9);
    memcpy(g_rec + 0x281, "JKLMNOPQR", 9);
    memset(g_records, 0, sizeof g_records);
    set32(g_records, SIDX, RECVA);
    set32(g_records, SIDX + 0x4d, state);
    memset(&w42, 0, sizeof w42);
    w42.records_5bb5e5 = g_records;
    w42.flags_585801 = g_flags + 0x40;
    w42.bytes_5b5128 = g_tab;
    w42.words_5b5138 = g_tab + 16;
    w42.bytes_545b48 = g_consts;
    w42.bytes_545b54 = g_consts + 0x10;
    w42.bytes_545b60 = g_consts + 0x20;
    w42.byte_5b5158 = 0x5a;
    w42.byte_5b516a = 0x6b;
    w42.byte_5b515d = 0;
    w42.word_5b5159 = 0x5159;
    w42.word_5b5166 = 0x5166;
    w42.word_5b5168 = 0x5168;
    w42.value_5b515e = 0x515e0000u;
    w42.value_5b5162 = step;
    w42.value_5d03cf = 0x03cf;
    w42.value_5d1a83 = 0x1a83;
    w42.value_5d1a8f = 0x1a8f;
    w42.value_5bb1ca = 0x55;
    w42.value_5bb57b = 0x5557;
    w42.value_5bb59b = 0x559b;
    w42.value_5bb59f = 0x559f;
    w42.value_5bb5a3 = 0x55a3;
    w42.value_583999 = 0x5599;
    w42.word_5bb599 = 0x1111;
    w42.word_5bb595 = 0x2222;
    w42.word_5c39ff = 0x3333;
    reset_log();
    add_region(RECVA, g_rec, sizeof g_rec);
    probe_all_42ed54();
}

static void snap42(void)
{
    memcpy(x_rec, g_rec, sizeof g_rec);
    memcpy(x_tab, g_tab, sizeof g_tab);
    memcpy(x_flags, g_flags, sizeof g_flags);
    memcpy(x_records, g_records, sizeof g_records);
    e42 = w42;
}

#define EQF(f) (a->f == b->f)
static int world42_same(const Fl22bWorld *a, const Fl22bWorld *b)
{
    return EQF(byte_5b5158) && EQF(byte_5b516a) && EQF(byte_5b515d) && EQF(word_5b5159) && EQF(word_5b5166) && EQF(word_5b5168) && EQF(value_5b515e) &&
           EQF(value_5b5162) && EQF(value_5d03cf) && EQF(value_5d1a83) && EQF(value_5d1a8f) && EQF(value_5bb1ca) && EQF(value_5bb57b) &&
           EQF(value_5bb59b) && EQF(value_5bb59f) && EQF(value_5bb5a3) && EQF(value_583999) && EQF(word_5bb599) && EQF(word_5bb595) && EQF(word_5c39ff) &&
           EQF(records_5bb5e5) && EQF(flags_585801) && EQF(bytes_5b5128) && EQF(words_5b5138) && EQF(bytes_545b48) && EQF(bytes_545b54) &&
           EQF(bytes_545b60);
}

/* everything the function can touch is as snapshotted-and-edited: the record object is never written */
static int same42(void)
{
    return memcmp(g_rec, x_rec, sizeof g_rec) == 0 && memcmp(g_tab, x_tab, sizeof g_tab) == 0 && memcmp(g_flags, x_flags, sizeof g_flags) == 0 &&
           memcmp(g_records, x_records, sizeof g_records) == 0 && world42_same(&w42, &e42);
}

static void run42(int16_t index)
{
    Fl18Host h = host();
    m42ed54_run_state(index, &w42, &h);
}

static void clear_expected_tab(void)
{
    int i;
    for (i = 0; i < 16; i++) {
        x_tab[i] = 0;
        set16(x_tab, 16 + (size_t)i * 2, 0xffff);
    }
}

/* state 1, sub-steps 1, 2 and 3 */
static void steps_42ed54(void)
{
    int k, pos;
    /* sub-step 1: the flag-table entry (signed word index, -1 = none) gets the byte, then now + seconds * 1000 is stored */
    {
        static const struct { int16_t sel; uint8_t byte; int16_t secs; uint32_t now; } c[] = {
            {-1, 0x80, 5, 1000}, {0, 0xff, 5, 1000}, {3, 0x00, -3, 5000}, {-2, 0x7f, 0x7fff, 0xfffffff0u}, {1, 1, -32768, 0x10}, {-16, 0xaa, 0, 0},
            {15, 0x55, 1, 0x80000000u}, {47, 0x66, 2, 7}};
        for (k = 0; k < 8; k++) {
            setup_42ed54(1, 1);
            set16(g_rec, 0x27c, (uint16_t)c[k].sel);
            g_rec[0x27e] = c[k].byte;
            set16(g_rec, 0x27f, (uint16_t)c[k].secs);
            L.tick = c[k].now;
            snap42();
            if (c[k].sel != -1) set32(x_flags, 0x40 + (size_t)(c[k].sel * 4), c[k].byte);   /* a zero-extended byte */
            e42.value_5b515e = c[k].now + (uint32_t)((int32_t)c[k].secs * 1000);
            e42.value_5b5162 = 2;
            run42(IDX);
            CK(L.n == 1 && is_tick(0));
            CK(P32(0, PR_515E) == 0x515e0000u && P32(0, PR_STEP) == 1);   /* the deadline and the sub-step are stored after GetTickCount */
            if (c[k].sel >= -16 && c[k].sel <= 15) CK(memcmp(L.c[0].probe + PR_FLAGS, x_flags, 0x80) == 0);   /* the flag entry is stored before it */
            CK(same42());
        }
    }
    /* sub-step 2: GetTickCount (unsigned) against the deadline; then the nine bytes at +0x281 */
    {
        static const struct { uint32_t tick, deadline; int due; } c[] = {
            {999, 1000, 0}, {1000, 1000, 1}, {1001, 1000, 1}, {0x7fffffffu, 0x80000000u, 0}, {0x80000000u, 0x7fffffffu, 1}, {0, 0xffffffffu, 0},
            {0xffffffffu, 0, 1}, {0xffffffffu, 0xffffffffu, 1}};
        for (k = 0; k < 8; k++) {
            for (pos = -1; pos < 9; pos++) {   /* -1: the nine bytes are equal */
                setup_42ed54(1, 2);
                w42.value_5b515e = c[k].deadline;
                set16(g_rec, 0x2a2, 0xfffd);   /* the word -3 */
                if (pos >= 0) g_rec[0x281 + pos] ^= 0x04;
                L.tick = c[k].tick;
                snap42();
                if (c[k].due) {
                    if (pos >= 0)
                        e42.value_5b5162 = 3;
                    else
                        set32(x_records, SIDX + 0x4d, 2);
                }
                run42(IDX);
                CK(is_tick(0));
                if (!c[k].due) {
                    CK(L.n == 1);
                } else if (pos >= 0) {
                    CK(L.n == 3);
                    CK(is_call(1, 0x4fb77a, 0x5c3a67, 1) && L.c[1].a[0] == RECVA + 0x281);
                    CK(is_call(2, 0x4fb2e3, 0x5c3a67, 1) && (L.c[2].a[0] & 0xffff) == 0xfffd);
                    CK(P32(1, PR_STEP) == 2 && P32(2, PR_STEP) == 2 && P32(2, PR_STATE) == 1);   /* the sub-step is stored after both calls */
                } else {
                    CK(L.n == 1);
                }
                CK(same42());
            }
        }
    }
    /* sub-step 3: 0x4f6334 gets the sign-extended word; a zero result calls 0x4fba69 and ends the state */
    {
        static const int16_t words[] = {5, -3, 0x7fff, -32768, 0};
        static const uint32_t results[] = {0, 1, 0x10000, 0x80000000u, 0xffffffffu};
        for (k = 0; k < 5; k++) {
            for (pos = 0; pos < 5; pos++) {
                setup_42ed54(1, 3);
                set16(g_rec, 0x2a2, (uint16_t)words[k]);
                queue_return(0x4f6334, results[pos]);
                snap42();
                if (results[pos] == 0) set32(x_records, SIDX + 0x4d, 2);
                run42(IDX);
                CK(L.n == (results[pos] == 0 ? 2 : 1));
                CK(is_call(0, 0x4f6334, 0x5cf1eb, 1) && L.c[0].a[0] == (uintptr_t)(uint32_t)(int32_t)words[k]);
                CK(P32(0, PR_STATE) == 1 && P32(0, PR_STEP) == 3);
                if (results[pos] == 0) {
                    CK(is_call(1, 0x4fba69, 0x5c3a67, 1) && L.c[1].a[0] == RECVA + 0x281);
                    CK(P32(1, PR_STATE) == 1);   /* the state is stored after the call */
                }
                CK(same42());
            }
        }
    }
}

/* state 2: the globals at 0x5bb57b.. are loaded from one of two blocks of the record (by byte 0x5b515d), then 0x42ba3a is called */
static void state2_42ed54(void)
{
    int k, var, eq;
    for (eq = 0; eq < 2; eq++) {   /* the nine bytes at +0x235 against "STUVWXYZ0": equal, or not (0x4fba69 is called) */
        for (k = 0; k < 3; k++) {
            /* A: byte 0x5b515d non-zero (1, 0xff, 2); B: zero (k == 0 below) */
            for (var = 0; var < 6; var++) {
                int use_a = k != 0;
                int sel_none = var == 1, idx_none = var == 2, flag_one = var != 3, neg_idx = var == 4;
                int16_t sel = sel_none ? 0x270f : (int16_t)-5, idx = idx_none ? -1 : neg_idx ? -2 : 3;
                size_t base = use_a ? 0x2b2 : 0x266;
                int n;
                setup_42ed54(2, 0x77);
                w42.byte_5b515d = k == 0 ? 0 : k == 1 ? 1 : 0xff;
                if (eq) memcpy(g_rec + 0x235, "STUVWXYZ0", 9);
                set16(g_rec, base, (uint16_t)sel);
                set16(g_rec, base + 2, 0x1234);
                set16(g_rec, base + 4, 0x5678);
                set16(g_rec, base + 6, 0x9abc);
                set32(g_rec, base + 8, 0x11223344u);
                set32(g_rec, base + 0xc, 0x55667788u);
                set32(g_rec, base + 0x10, 0x99aabbccu);
                set16(g_rec, base + 0x14, flag_one ? 1 : 2);
                set16(g_rec, 0x2c8, (uint16_t)idx);
                g_rec[0x2ca] = 0xee;
                snap42();
                e42.value_5bb1ca = 1;
                e42.byte_5b5158 = 0;
                e42.value_5d1a8f = 0;
                if (sel != 0x270f) {
                    e42.value_5bb57b = 0xfffffffbu;
                    e42.word_5bb599 = 0x1234;
                    e42.word_5bb595 = 0x5678;
                    e42.word_5c39ff = 0x9abc;
                    e42.value_5bb59b = 0x11223344u;
                    e42.value_5bb59f = 0x55667788u;
                    e42.value_5bb5a3 = 0x99aabbccu;
                    e42.value_5bb1ca = flag_one ? 0u : 1u;
                    e42.value_583999 = 4;
                }
                if (use_a && idx != -1) set32(x_flags, 0x40 + (size_t)((int)idx * 4), 0xee);   /* only the first block sets a flag-table entry */
                run42(IDX);
                n = 0;
                CK(L.n == 2 + (eq ? 0 : 1));
                CK(is_call(n, 0x4c2dfb, 0x5cf659, 1) && L.c[n].a[0] == 0x5d03cf);
                CK(P32(n, PR_1CA) == 1 && P8(n, PR_B5158) == 0 && P32(n, PR_D1A8F) == 0x1a8f && P32(n, PR_57B) == 0x5557);   /* before the loads */
                n++;
                if (!eq) {
                    CK(is_call(n, 0x4fba69, 0x5c3a67, 1) && L.c[n].a[0] == RECVA + 0x235);
                    CK(P32(n, PR_D1A8F) == 0 && P32(n, PR_57B) == 0x5557);
                    n++;
                }
                CK(is_call(n, 0x42ba3a, 0, 1) && (L.c[n].a[0] & 0xffff) == IDX);
                /* at 0x42ba3a everything is loaded, the flag entry is written and the state is still 2 */
                CK(P32(n, PR_57B) == e42.value_5bb57b && P32(n, PR_1CA) == e42.value_5bb1ca && P32(n, PR_3999) == e42.value_583999 && P32(n, PR_STATE) == 2);
                CK(P32(n, PR_59B) == e42.value_5bb59b && P32(n, PR_59F) == e42.value_5bb59f && P32(n, PR_5A3) == e42.value_5bb5a3);
                CK(P16(n, PR_W599) == e42.word_5bb599 && P16(n, PR_W595) == e42.word_5bb595 && P16(n, PR_W3FF) == e42.word_5c39ff);
                CK(memcmp(L.c[n].probe + PR_FLAGS, x_flags, 0x80) == 0);
                CK(same42());
                CK(get32(g_records, SIDX + 0x4d) == 2);
            }
        }
    }
}

static void test_m42ed54_run_state(void)
{
    int k, pos, n;
    /* ---- state 0: the random number reduced mod 5 (signed idiv), 0 and 1 become 2, then the sum with the count is clamped to the limit ---- */
    {
        static const struct { uint32_t r; int16_t local; } rnd[] = {
            {0, 2}, {1, 2}, {2, 2}, {3, 3}, {4, 4}, {5, 2}, {6, 2}, {7, 2}, {12, 2}, {0x7fffffffu, 2},
            {0xffffffffu, -1}, {0xfffffffbu, 2}, {0xfffffffcu, -4}, {0xfffffffau, -1}, {0x80000000u, -3}};
        for (k = 0; k < (int)(sizeof rnd / sizeof rnd[0]); k++) {
            int differs = k & 1;
            int sum = 10 + rnd[k].local, expect_sum = sum > 12 ? 12 : sum;
            setup_42ed54(0, 0x77);
            set16(g_rec, 0x223, 10);
            set16(g_rec, 0x21, 12);
            if (differs) g_consts[8] ^= 0x20;   /* the last of the nine bytes differs */
            queue_return(0x50cd50, rnd[k].r);
            queue_return(0x4c2790, 0xdeadbeefu);
            snap42();
            clear_expected_tab();
            e42.byte_5b5158 = 1;
            e42.byte_5b516a = 0;
            e42.value_5bb1ca = 1;
            e42.word_5b5159 = (uint16_t)IDX;
            e42.byte_5b515d = 0;
            e42.word_5b5168 = (uint16_t)expect_sum;
            e42.word_5b5166 = 0;
            e42.value_5d03cf = 0xdeadbeefu;
            e42.value_5d1a83 = 0xdeadbeefu;
            e42.value_5d1a8f = 1;
            e42.value_5b5162 = 0;
            set32(x_records, SIDX + 0x4d, 1);
            run42(IDX);
            CK(L.n == 3 + differs);
            n = 0;
            CK(is_call(n, 0x50cd50, 0, 0));
            CK(P32(n, PR_STATE) == 0 && P8(n, PR_B5158) == 1 && P8(n, PR_B516A) == 0 && P32(n, PR_1CA) == 1 && P16(n, PR_W5159) == IDX && P8(n, PR_B515D) == 0);
            CK(P32(n, PR_D03CF) == 0x03cf && P16(n, PR_W5168) == 0x5168 && P16(n, PR_W5166) == 0x5166);   /* (the rest is stored after the call) */
            n++;
            CK(is_call(n, 0x4c2dfb, 0x5cf659, 1) && L.c[n].a[0] == 0x5d03cf);
            /* at this call: the clamp and both tables are done, 0x5b5166 is cleared, the state and the sub-step are as before */
            CK(P16(n, PR_W5168) == (uint16_t)expect_sum && P16(n, PR_W5166) == 0 && P32(n, PR_STATE) == 0 && P32(n, PR_STEP) == 0x77);
            CK(memcmp(L.c[n].probe + PR_TAB, x_tab, 48) == 0);
            CK(P32(n, PR_D03CF) == 0x03cf && P32(n, PR_D1A8F) == 0x1a8f);
            n++;
            CK(is_call(n, 0x4c2790, 0x5cf659, 4));
            CK(L.c[n].a[0] == 0x545b40 && L.c[n].a[1] == RECVA && L.c[n].a[2] == 6 && L.c[n].a[3] == 0x545b24);
            CK(P32(n, PR_D03CF) == 0x03cf && P32(n, PR_D1A83) == 0x1a83 && P32(n, PR_D1A8F) == 0x1a8f && P32(n, PR_STATE) == 0);
            n++;
            if (differs) {
                CK(is_call(n, 0x4fb77a, 0x5c3a67, 1) && L.c[n].a[0] == RECVA + 0x235);
                CK(P32(n, PR_D03CF) == 0xdeadbeefu && P32(n, PR_D1A83) == 0xdeadbeefu && P32(n, PR_D1A8F) == 1);
                CK(P32(n, PR_STEP) == 0x77 && P32(n, PR_STATE) == 0);   /* the sub-step and the state are written after the last call */
            }
            CK(same42());
        }
    }
    /* the sum wraps in the low word and the clamp is a signed compare of the two words */
    {
        {
            static const struct { int16_t count, limit; uint32_t r; uint16_t expect; } t[] = {
                {0x7fff, 0, 4, 0x8003},   /* local 4: 0x7fff + 4 = 0x8003 (signed -32765) is not above 0 */
                {-5, -7, 3, 0xfff9},      /* local 3: -2 is above -7: the limit, 0xfff9 */
                {-5, -1, 3, 0xfffe},      /* -2 is not above -1 */
                {6, 6, 3, 6},             /* 9 above 6: the limit */
                {2, 6, 3, 5},             /* 5 not above 6 */
                {5, 8, 3, 8},             /* 8 is not above 8: stays 8 (sum 8) */
                {6, 8, 3, 8}};            /* 9 above 8: 8 */
            for (k = 0; k < 7; k++) {
                setup_42ed54(0, 0);
                set16(g_rec, 0x223, (uint16_t)t[k].count);
                set16(g_rec, 0x21, (uint16_t)t[k].limit);
                queue_return(0x50cd50, t[k].r);
                run42(IDX);
                CK(w42.word_5b5168 == t[k].expect);
            }
        }
    }
    /* the nine-byte comparison of state 0: a difference at any position (and only then) calls 0x4fb77a */
    for (pos = 0; pos <= 9; pos++) {
        setup_42ed54(0, 0);
        queue_return(0x50cd50, 3);
        if (pos < 9) g_rec[0x235 + pos] ^= 0x10;
        run42(IDX);
        CK(L.n == (pos < 9 ? 4 : 3));
        CK(pos < 9 ? is_call(3, 0x4fb77a, 0x5c3a67, 1) && L.c[3].a[0] == RECVA + 0x235 : 1);
        CK(get32(g_records, SIDX + 0x4d) == 1);
    }
    /* ---- state 1, sub-step 0: the first `count` words of 0x5b5138 against the bytes at +0x225 of the record (movsx word vs byte) ---- */
    {
        /* all equal, count 3: sub-step 1; no table change; no call */
        for (k = 0; k < 4; k++) {
            int count = k == 0 ? 3 : k == 1 ? 0 : k == 2 ? -1 : -32768;
            setup_42ed54(1, 0);
            set16(g_rec, 0x223, (uint16_t)count);
            g_rec[0x225] = 0x10;
            g_rec[0x226] = 0xff;   /* a byte above 0x7f: the word must be 0x00ff, not 0xffff */
            g_rec[0x227] = 0x00;
            set16(g_tab, 16, 0x0010);
            set16(g_tab, 18, 0x00ff);
            set16(g_tab, 20, 0x0000);
            w42.byte_5b516a = 0;
            snap42();
            e42.byte_5b516a = 1;
            e42.value_5b5162 = 1;
            run42(IDX);
            CK(L.n == 0 && same42());
        }
        /* a mismatch at position m (0, 1, 2) of three: byte_5b516a cleared; then the signed compare of 0x5b5166 with 0x5b5168 */
        for (pos = 0; pos < 3; pos++) {
            static const struct { uint16_t cur, lim; int clear; } cmp[] = {
                {5, 5, 1}, {6, 5, 1}, {4, 5, 0}, {0xffff, 1, 0}, {0x8000, 0x7fff, 0}, {0x7fff, 0x8000, 1}, {0xffff, 0xffff, 1}, {0, 0xffff, 1}};
            for (k = 0; k < 8; k++) {
                setup_42ed54(1, 0);
                set16(g_rec, 0x223, 3);
                g_rec[0x225] = 0x10;
                g_rec[0x226] = 0xff;
                g_rec[0x227] = 0x00;
                set16(g_tab, 16, 0x0010);
                set16(g_tab, 18, 0x00ff);
                set16(g_tab, 20, 0x0000);
                set16(g_tab, 16 + (size_t)pos * 2, pos == 1 ? 0xffff : 0x0100u | g_rec[0x225 + pos]);   /* 0xffff is -1, never a byte */
                w42.word_5b5166 = cmp[k].cur;
                w42.word_5b5168 = cmp[k].lim;
                w42.byte_5b516a = 1;
                snap42();
                e42.byte_5b516a = 0;
                if (cmp[k].clear) {
                    clear_expected_tab();
                    e42.word_5b5166 = 0;
                }
                run42(IDX);
                CK(L.n == 0 && same42());
                CK(get32(g_records, SIDX + 0x4d) == 1 && w42.value_5b5162 == 0);
            }
        }
    }
    /* sub-step 4 and the huge values: the function does nothing and does not call 0x42ba3a */
    {
        static const uint32_t big[] = {4, 5, 0x80000000u, 0xffffffffu};
        for (k = 0; k < 4; k++) {
            setup_42ed54(1, big[k]);
            snap42();
            run42(IDX);
            CK(L.n == 0 && same42());
        }
        static const uint32_t other[] = {3, 0xffffffffu, 0x80000000u, 0x100u};   /* states that are none of 0, 1, 2 */
        for (k = 0; k < 4; k++) {
            setup_42ed54(other[k], 0);
            snap42();
            run42(IDX);
            CK(L.n == 0 && same42());
        }
    }
    steps_42ed54();
    state2_42ed54();
}

/* TESTS-END */

int main(void)
{
    int failures = 0;
    RUN(test_m42ed54_run_state);
    /* RUN-END */
    return failures;
}
