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
    uint8_t probe[2048];    /* the bytes at the host addresses probe_ptr[] (concatenated), as they are at the call */
    uint8_t pd[5][16];      /* the 16 bytes behind each of args[0..4] that is a host pointer (a value above 32 bits), for every call */
    uint8_t wide[256];      /* L.wide_len bytes behind args[L.wide_arg] of a call of L.wide_callee */
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
    OutWrite w[128];
    int nw;
    int calls_of[16];       /* per callee slot: how many calls were made (for OutWrite.call) */
    uint32_t calls_callee[16];
    Region regions[8];
    int nregions;
    uint32_t tick;
    void (*hook)(uint32_t callee, int nth);   /* runs inside every host call, after the call is logged (it may change the state a callee would change) */
    uint32_t wide_callee;
    int wide_arg, wide_len;
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
        if (L.wide_len > 0 && callee == L.wide_callee && L.wide_arg < nargs) memcpy(c->wide, (const void *)args[L.wide_arg], (size_t)L.wide_len);
    }
    L.n++;
    if (L.hook != NULL) L.hook(callee, nth);
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
    (void)m42ed54_run_state; /* driven through the file's runner helper; named here so the test pointer finds it */
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

/* ---- 0x47ff0e ---------------------------------------------------------------------------------------------------------------- */

#define RECVA2 0x31000000u
#define TXTVA 0x32000000u
#define BIGVA 0x33000000u
#define IT(n, off) ((size_t)0x7b6 + (size_t)(n) * 0x25 + (size_t)(off))   /* field `off` of the item n in self (stride 0x25) */
#define KIND(n) g_self[IT(n, 0x21)]

static uint8_t g_self[0x1400], x_self[0x1400], g_rec2[0x1000], x_rec2[0x1000], g_text[0x400], g_big[0xa100], g_consts47[0x20];
static uint8_t x_records47[REC * 8];
static Fl22bWorld w47, e47;
static int32_t g_ret47;

/* the probe snapshot at every host call of 0x47ff0e: counters (+0 .. +0x1f = self+0x7a0), item 1 (+0x20, 0x25 bytes), self+0x1340 (+0x45, 0x30),
 * self+0x1390 (+0x75, 0x20), self+0x13a0 (+0x95, 0x50), the state of the record (+0xe5), item 0 (+0xe9) and item 2 (+0x10e) */
enum { PQ_CNT = 0, PQ_ITEM = 0x20, PQ_A = 0x45, PQ_B = 0x75, PQ_C = 0x95, PQ_ST = 0xe5, PQ_ITEM0 = 0xe9, PQ_ITEM2 = 0x10e };
static int pq_item(int n) { return n == 0 ? PQ_ITEM0 : n == 2 ? PQ_ITEM2 : PQ_ITEM; }   /* (items 0, 1 and 2 are probed) */

static void setup47(uint32_t sel)
{
    size_t i;
    int k;
    for (i = 0; i < sizeof g_self; i++) g_self[i] = (uint8_t)(i * 13 + 5);
    for (i = 0; i < sizeof g_rec2; i++) g_rec2[i] = (uint8_t)(i * 7 + 3);
    memset(g_text, 0, sizeof g_text);
    memset(g_big, 0, sizeof g_big);
    memset(g_consts47, 0, sizeof g_consts47);
    memcpy(g_consts47, "ABCDEFGHI", 9);
    memcpy(g_rec2 + 0x7a8, "ABCDEFGHI", 9);
    memset(g_rec2 + 0x7d9, 0, 0x60);
    g_rec2[0x5e] = 0;
    for (k = 0; k < 4; k++) g_rec2[0xe9 + k * 0x53] = 0;
    set16(g_self, 0x1e, IDX);
    set32(g_self, 0x13c5, 1);
    g_self[0x13ce] = 0;
    set32(g_self, 0x13ca, 0);
    set32(g_self, 0x1344, 0);
    set32(g_self, 0x1348, 0x1111);
    set32(g_self, 0x134c, 0x2222);
    set16(g_self, 0x1350, 1);
    g_self[0x13b0] = 0;
    g_self[0x13b1] = 0;
    g_self[0x13c9] = 0x33;
    set32(g_self, 0x13df, 0);
    set16(g_self, 0x13a2, 7);
    set32(g_self, 0x13e7, 0x4444);
    set16(g_self, 0x13e3, 0x5555);
    set16(g_self, 0x13e5, 0x6666);
    for (k = 0; k < 22; k++) g_self[0x7a0 + k] = (uint8_t)(10 + k);
    for (k = -1; k < 5; k++) {
        int d;
        for (d = 0; d < 4; d++) {
            set32(g_self, IT(k, d * 4), (uint32_t)(k + 1) * 0x100 + 0x10 + (uint32_t)d);              /* the rectangle */
            set32(g_self, IT(k, 0x10 + d * 4), (uint32_t)(k + 1) * 0x100 + 0x80 + (uint32_t)d);       /* the second rectangle */
        }
        g_self[IT(k, 0x21)] = (uint8_t)((k + 1) & 3);   /* the kind: item 0 -> 1, 1 -> 2, 2 -> 3, 3 -> 0, 4 -> 1 */
        g_self[IT(k, 0x20)] = 0x20;
        g_self[IT(k, 0x22)] = 0x22;
    }
    for (k = 0; k < 16; k++) {
        g_self[0x1352 + k] = (uint8_t)(0xa0 + k);
        g_self[0x1372 + k] = (uint8_t)(0xb0 + k);
    }
    memset(g_records, 0, sizeof g_records);
    set32(g_records, SIDX, RECVA2);
    set32(g_records, SIDX + 0x4d, 1);
    memset(&w47, 0, sizeof w47);
    w47.records_5bb5e5 = g_records;
    w47.bytes_54d5a4 = g_consts47;
    w47.value_5c39e5 = sel;
    w47.value_5bb202 = 1;
    w47.value_5d03b3 = 0xd03b3;
    w47.dword_54d5b0 = 0x00434241u;   /* "ABC" */
    w47.dword_54d5b4 = 0x00535251u;   /* "QRS" */
    reset_log();
    add_region(RECVA2, g_rec2, sizeof g_rec2);
    add_region(TXTVA, g_text, sizeof g_text);
    add_region(BIGVA, g_big, sizeof g_big);
    add_probe(g_self + 0x7a0, 0x20);
    add_probe(g_self + IT(1, 0), 0x25);
    add_probe(g_self + 0x1340, 0x30);
    add_probe(g_self + 0x1390, 0x20);
    add_probe(g_self + 0x13a0, 0x50);
    add_probe(g_records + SIDX + 0x4d, 4);
    add_probe(g_self + IT(0, 0), 0x25);
    add_probe(g_self + IT(2, 0), 0x25);
}

static void snap47(void)
{
    memcpy(x_self, g_self, sizeof g_self);
    memcpy(x_rec2, g_rec2, sizeof g_rec2);
    memcpy(x_records47, g_records, sizeof g_records);
    e47 = w47;
}

static int same47(void)
{
    const Fl22bWorld *a = &w47, *b = &e47;
    return memcmp(g_self, x_self, sizeof g_self) == 0 && memcmp(g_rec2, x_rec2, sizeof g_rec2) == 0 && memcmp(g_records, x_records47, sizeof g_records) == 0 &&
           EQF(value_5c39e5) && EQF(value_5bb202) && EQF(value_5d03b3) && EQF(dword_54d5b0) && EQF(dword_54d5b4) && EQF(bytes_54d5a4) &&
           EQF(records_5bb5e5);
}

static void run47(void)
{
    Fl18Host h = host();
    g_ret47 = m47ff0e_handle_click(g_self, &w47, &h);
}

static void hook_set_13ce(uint32_t callee, int nth)
{
    (void)nth;
    if (callee == 0x480b34) g_self[0x13ce] = 0x80;
}

static uintptr_t SELF(size_t off) { return (uintptr_t)(g_self + off); }

/* set the expected copy of 16 bytes (four dwords) */
static void exp_copy16(uint8_t *dst_base, size_t dst, const uint8_t *src) { memcpy(dst_base + dst, src, 16); }

/* the extent words of the item n as they are in x_self */
static void exp_extent(int n)
{
    set16(x_self, 0x13e3, (uint16_t)(get32(x_self, IT(n, 8)) - get32(x_self, IT(n, 0))));
    set16(x_self, 0x13e5, (uint16_t)(get32(x_self, IT(n, 0xc)) - get32(x_self, IT(n, 4))));
}

/* The tail of a click that has chosen the item n (0x4801e2 onward), called with `at` = the index of the first call it makes in the log. e9 = the
 * record byte [kind * 0x53 + 0xe9] is non-zero; r99 = the answer of 0x47e99e; cnt = the counter of the kind; the word 0x13a2 is w13a2. */
static void click_tail(int at, int n, int e9, uint32_t r99, uint8_t cnt, uint16_t w13a2)
{
    int kind = x_self[IT(n, 0x21)], k = at, calls = at;
    uint8_t item_before[16];
    memcpy(item_before, x_self + IT(n, 0), 16);
    if (e9) calls += 2;
    calls += 3;          /* 0x47e99e, 0x47e52f, 0x4809a7 */
    CK(L.n == calls);
    if (e9) {
        CK(is_call(k, 0x47e582, SELF(0), 3) && (L.c[k].a[0] & 0xffff) == w13a2 && (L.c[k].a[1] & 0xffff) == (unsigned)kind && L.c[k].a[2] == 1);
        CK(get16(L.c[k].probe, PQ_C + 2) == w13a2);
        k++;
        CK(is_call(k, 0x47ed96, SELF(0), 1) && (L.c[k].a[0] & 0xffff) == w13a2 && get16(L.c[k].probe, PQ_C + 2) == w13a2);   /* the word is bumped after */
        k++;
        set16(x_self, 0x13a2, (uint16_t)(w13a2 + 1u));
    }
    x_self[0x13b1] = 0;
    set32(x_self, 0x134c, 1);
    exp_copy16(x_self, 0x1392, item_before);
    CK(is_call(k, 0x47e99e, SELF(0), 1) && L.c[k].a[0] == RECVA2 + (uint32_t)kind * 0x53u + 0xb9u);
    CK(get32(L.c[k].probe, PQ_A + 0xc) == 1 && memcmp(L.c[k].probe + PQ_B + 2, item_before, 16) == 0 && L.c[k].probe[PQ_C + 0x11] == 0);   /* 0x134c, 0x1392.., 0x13b1 */
    CK(memcmp(L.c[k].probe + pq_item(n), item_before, 16) == 0);   /* the item is not replaced yet */
    k++;
    if (r99 != 0) memcpy(x_self + IT(n, 0), x_rec2 + (size_t)kind * 0x53 + 0xb9, 16);
    CK(is_call(k, 0x47e52f, SELF(0), 2) && L.c[k].a[0] == SELF(IT(n, 0)) && L.c[k].a[1] == SELF(IT(n, 0x10)));
    CK(memcmp(L.c[k].probe + pq_item(n), x_self + IT(n, 0), 16) == 0);   /* the replacement is made before the call */
    CK(get16(L.c[k].probe, PQ_C + 0x43) == 0x5555);                      /* the extent is stored after it */
    k++;
    exp_extent(n);
    if (cnt > 0 && !e9) x_self[0x7a0 + kind] = (uint8_t)(cnt - 1);
    CK(is_call(k, 0x4809a7, SELF(0), 0));
    CK(get16(L.c[k].probe, PQ_C + 0x43) == get16(x_self, 0x13e3));
    CK(L.c[k].probe[PQ_CNT + kind] == x_self[0x7a0 + kind]);
}

/* ---- the release: the part before the strings, the strings, the part after ---- */

/* the common head of a release of the item n: the two rectangles from the blocks at +0x1352 and +0x1372, then 0x47ed96 with the old word 0x1350 */
static void release_head(int n)
{
    set32(x_self, 0x1344, 0);
    set32(x_self, 0x1348, 1);
    memcpy(x_self + IT(n, 0), g_self + 0x1352, 16);
    memcpy(x_self + IT(n, 0x10), g_self + 0x1372, 16);
}

/* 0x4808af to the end for the item n: flag +0x22 cleared, the first rectangle from the record, 0x47e52f, flag +0x20 cleared, selection -1 */
static void release_tail(int k, int n)
{
    int kind = x_self[IT(n, 0x21)];
    x_self[IT(n, 0x22)] = 0;
    memcpy(x_self + IT(n, 0), x_rec2 + (size_t)kind * 0x53 + 0xa9, 16);
    CK(is_call(k, 0x47e52f, SELF(0), 2) && L.c[k].a[0] == SELF(IT(n, 0)) && L.c[k].a[1] == SELF(IT(n, 0x10)));
    CK(memcmp(L.c[k].probe + pq_item(n), x_self + IT(n, 0), 16) == 0 && L.c[k].probe[pq_item(n) + 0x22] == 0 && L.c[k].probe[pq_item(n) + 0x20] == 0x20);
    x_self[IT(n, 0x20)] = 0;
    set16(x_self, 0x1350, 0xffff);
}


/* a release (event 0x2791, nothing held: +0x13df == 0) whose nine bytes at +0x7a8 differ: the stores, 0x4fb2e3, GetTickCount and the caption part.
 * s1 = the record string at +0x7d9, lcmode = what 0x423259 answers (0 nothing, 1 the text lctext, 2 a text of 0x9c41 characters, 3 one of 0x9c40),
 * s2 = the record string at +0x7fa, flag = the dword 0x5bb202. A caption longer than 200 bytes is a rejection. */
static void rel_strings(const char *s1, int lcmode, const char *lctext, const char *s2, uint32_t flag)
{
    const char *shown = NULL;
    uint32_t suffix = 0;
    int reject = 0, k = 3, calls;
    size_t shown_len = 0;
    uint8_t expect_frame[260];
    setup47(0x2791);
    g_rec2[0x7a8] ^= 1;
    set16(g_rec2, 0x7c9, 0xbeef);
    strcpy((char *)g_rec2 + 0x7d9, s1);
    strcpy((char *)g_rec2 + 0x7fa, s2);
    w47.value_5bb202 = flag;
    if (lcmode == 1) {
        strcpy((char *)g_text, lctext);
        queue_return(0x423259, TXTVA);
    } else if (lcmode == 2 || lcmode == 3) {
        memset(g_big, 'a', lcmode == 2 ? 0x9c41 : 0x9c40);
        queue_return(0x423259, BIGVA);
    }
    if (flag != 0) {
        if (s1[0] != 0) {
            if (lcmode == 1) {
                shown = lctext;
                suffix = w47.dword_54d5b0;
            } else if (lcmode == 3) {
                shown = (const char *)g_big;
                suffix = w47.dword_54d5b0;
            }
        }
        if (shown == NULL && s2[0] != 0) {
            shown = s2;
            suffix = w47.dword_54d5b4;
        }
    }
    if (shown != NULL) {
        shown_len = strlen(shown);
        reject = shown_len > 200;
        if (!reject) {
            memcpy(expect_frame, shown, shown_len);
            memcpy(expect_frame + shown_len, &suffix, 4);
            L.wide_callee = 0x448d11;
            L.wide_arg = 1;
            L.wide_len = (int)shown_len + 4;
        }
    }
    L.tick = 0xffffff80u;
    snap47();
    release_head(1);
    set32(x_self, 0x13ca, 1);
    set32(x_self, 0x13e7, 0x48);   /* 0xffffff80 + 0xc8 wraps */
    run47();
    CK(g_ret47 == (reject ? FL22B_47FF0E_REJECT_LONG_STRING : FL22B_47FF0E_OK));
    CK(is_call(0, 0x47ed96, SELF(0), 1) && (L.c[0].a[0] & 0xffff) == 1 && P32(0, PQ_A + 4) == 0 && get16(L.c[0].probe, PQ_A + 0x10) == 1);
    CK(is_call(1, 0x4fb2e3, 0x5c3a67, 1) && (L.c[1].a[0] & 0xffff) == 0xbeef && P32(1, PQ_C + 0x47) == 0x4444);
    CK(is_tick(2) && P32(2, PQ_C + 0x47) == 0x4444);   /* the deadline and the flag are stored after GetTickCount */
    if (flag != 0 && s1[0] != 0) {
        CK(is_call(k, 0x423259, 0x619a6b, 1) && L.c[k].a[0] == RECVA2 + 0x7d9u && P32(k, PQ_C + 0x47) == 0x48 && P32(k, PQ_C + 0x2a) == 1);
        k++;
    }
    if (shown != NULL && !reject) {
        CK(is_call(k, 0x448d11, 0x619a05, 4) && L.c[k].a[0] == 0xd03b3u && L.c[k].a[2] == 0xffffffffu && L.c[k].a[3] == 0);
        CK(memcmp(L.c[k].wide, expect_frame, shown_len + 4) == 0);
        CK(P32(k, PQ_C + 0x47) == 0x48 && get16(L.c[k].probe, PQ_A + 0x10) == 1);   /* the selection is cleared after the caption */
        k++;
    }
    if (!reject) {
        release_tail(k, 1);
        k++;
    }
    calls = k;
    CK(L.n == calls);
    CK(same47());
}

static void test_m47ff0e_handle_click(void)
{
    (void)m47ff0e_handle_click; /* driven through the file's runner helper; named here so the test pointer finds it */
    int k, n, i;
    Fl18Host h;
    (void)h;
    /* ---- the four gates: any one of them ends the call at once ---- */
    for (k = 0; k < 6; k++) {
        setup47(0x278f);
        if (k == 0) set32(g_self, 0x13c5, 0);
        if (k == 1) g_self[0x13ce] = 0xff;
        if (k == 2) set32(g_self, 0x13ca, 0x01000000);
        if (k == 3) set32(g_records, SIDX + 0x4d, 0);
        if (k == 4) set32(g_records, SIDX + 0x4d, 2);
        if (k == 5) set32(g_records, SIDX + 0x4d, 0xffffffffu);
        snap47();
        run47();
        CK(g_ret47 == FL22B_47FF0E_OK && L.n == 0 && same47());
    }
    /* ---- the events 0x278f and 0x2790: the state becomes 2 before the call of 0x480b34; the flag +0x13c9 is set unless +0x13ce became non-zero ---- */
    for (k = 0; k < 2; k++) {
        setup47(k ? 0x2790 : 0x278f);
        snap47();
        set32(x_records47, SIDX + 0x4d, 2);
        x_self[0x13c9] = 1;
        run47();
        CK(L.n == 1 && is_call(0, 0x480b34, SELF(0), 0) && P32(0, PQ_ST) == 2 && L.c[0].probe[PQ_C + 0x29] == 0x33);
        CK(g_ret47 == 0 && same47());
    }
    setup47(0x278f);
    L.hook = hook_set_13ce;
    snap47();
    set32(x_records47, SIDX + 0x4d, 2);
    x_self[0x13ce] = 0x80;   /* (the flag stays as it was) */
    run47();
    CK(L.n == 1 && g_ret47 == 0 && same47());
    /* ---- the event 0x278e: the item that 0x47e8fe names becomes the selection ---- */
    setup47(0x278e);
    queue_return(0x47e8fe, 0xabcdffffu);   /* the word -1: nothing more happens */
    snap47();
    run47();
    CK(L.n == 1 && is_call(0, 0x47e8fe, SELF(0), 0) && g_ret47 == 0 && same47());
    for (k = 0; k < 3; k++) {
        static const struct { uint32_t r; int n; uint32_t d0, d4, d8, dc; uint16_t e3, e5; } t[] = {
            {0x77770003u, 3, 5, 0x10, 0x10007, 0x20, 2, 0x10},
            {0x00000000u, 0, 100, 50, 90, 70, 0xfff6, 20},
            {0xffff0004u, 4, 0, 0, 0x10000, 0xffff0000u, 0, 0}};
        setup47(0x278e);
        n = t[k].n;
        set32(g_self, IT(n, 0), t[k].d0);
        set32(g_self, IT(n, 4), t[k].d4);
        set32(g_self, IT(n, 8), t[k].d8);
        set32(g_self, IT(n, 0xc), t[k].dc);
        queue_return(0x47e8fe, t[k].r);
        snap47();
        set32(x_self, 0x1344, 1);
        set16(x_self, 0x1350, (uint16_t)n);
        set16(x_self, 0x13e3, t[k].e3);
        set16(x_self, 0x13e5, t[k].e5);
        run47();
        CK(L.n == 3 && is_call(0, 0x47e8fe, SELF(0), 0));
        CK(is_call(1, 0x47fa11, SELF(0), 1) && (L.c[1].a[0] & 0xffff) == (unsigned)n);
        CK(is_call(2, 0x480abe, SELF(0), 0));
        CK(get32(L.c[1].probe, PQ_A + 4) == 0 && get16(L.c[1].probe, PQ_A + 0x10) == 1 && get32(L.c[2].probe, PQ_A + 4) == 0);   /* 0x1344 and 0x1350 stored after */
        CK(g_ret47 == 0 && same47());
    }
    /* ---- the click (event 0x278d with +0x1344 == 0, or any event with +0x1344 != 0 and +0x13b1 != 0) ---- */
    /* a first click with +0x13b0 set and +0x13b1 clear: 0x47e9d3 names the item, 0x47fb76 is told, +0x13b1 is set, nothing else */
    setup47(0x278d);
    g_self[0x13b0] = 0xff;
    queue_return(0x47e9d3, 0x12340002u);
    snap47();
    set32(x_self, 0x1344, 1);
    set16(x_self, 0x1350, 2);
    x_self[0x13b1] = 1;
    run47();
    CK(L.n == 2 && is_call(0, 0x47e9d3, SELF(0), 0) && is_call(1, 0x47fb76, SELF(0), 1) && (L.c[1].a[0] & 0xffff) == 2);
    CK(get32(L.c[0].probe, PQ_A + 4) == 1);                                             /* +0x1344 is stored before the first call */
    CK(get16(L.c[1].probe, PQ_A + 0x10) == 2 && L.c[1].probe[PQ_C + 0x11] == 0);        /* the selection is stored before 0x47fb76, +0x13b1 after */
    CK(g_ret47 == 0 && same47());
    /* the same with +0x13b1 already set and +0x1344 != 0: the event does not matter; no 0x47e9d3 call (+0x13b0 set): the tail for the item in +0x1350 */
    {
        static const struct { int nn, e9; uint32_t r99; uint8_t cnt; uint16_t w; } T[] = {
            {1, 0, 0, 4, 7}, {1, 1, 0, 4, 7}, {0, 0, 0x10000u, 4, 7}, {0, 1, 0x10000u, 4, 0xffff}, {1, 0, 0, 0, 7}, {0, 0, 0x10000u, 0xff, 7},
            {1, 1, 0, 0, 7}, {0, 0, 0, 1, 7}, {2, 0, 5, 3, 7}};
        for (i = 0; i < 9; i++) {
            int nn = T[i].nn;
            setup47(0x2792);
            set32(g_self, 0x1344, 5);
            g_self[0x13b1] = 1;
            g_self[0x13b0] = (uint8_t)(i & 1 ? 1 : 0xff);
            set16(g_self, 0x1350, (uint16_t)nn);
            set16(g_self, 0x13a2, T[i].w);
            g_rec2[0xe9 + KIND(nn) * 0x53] = (uint8_t)(T[i].e9 ? 0x80 : 0);
            g_self[0x7a0 + KIND(nn)] = T[i].cnt;
            queue_return(0x47e99e, T[i].r99);
            snap47();
            set32(x_self, 0x1344, 1);
            run47();
            CK(g_ret47 == 0);
            click_tail(0, nn, T[i].e9, T[i].r99, T[i].cnt, T[i].w);
            CK(same47());
        }
    }
    /* a click with +0x13b0 clear: 0x47e9d3 names the item first (the second call site), then the tail */
    setup47(0x278d);
    g_self[0x13b0] = 0;
    g_rec2[0xe9 + 3 * 0x53] = 1;
    queue_return(0x47e9d3, 0x00000002u);   /* item 2: kind 3 */
    snap47();
    set32(x_self, 0x1344, 1);
    set16(x_self, 0x1350, 2);
    run47();
    CK(is_call(0, 0x47e9d3, SELF(0), 0) && get32(L.c[0].probe, PQ_A + 4) == 1 && get16(L.c[0].probe, PQ_A + 0x10) == 1);
    n = 2;
    CK(KIND(n) == 3);
    click_tail(1, 2, 1, 0, x_self[0x7a0 + 3], 7);
    CK(same47());
    /* +0x1344 != 0, +0x13b1 set, +0x13b0 clear: a click that asks 0x47e9d3 for the item */
    setup47(0x2792);
    set32(g_self, 0x1344, 9);
    g_self[0x13b1] = 1;
    g_self[0x13b0] = 0;
    queue_return(0x47e9d3, 0x00000000u);
    snap47();
    set32(x_self, 0x1344, 1);
    set16(x_self, 0x1350, 0);
    run47();
    CK(is_call(0, 0x47e9d3, SELF(0), 0));
    click_tail(1, 0, 0, 0, x_self[0x7a0 + 1], 7);
    CK(same47());
    /* not a click: +0x1344 == 0 and the event is not 0x278d, or +0x1344 != 0 and +0x13b1 == 0, with an event that is not 0x2791 */
    for (k = 0; k < 4; k++) {
        setup47(k < 2 ? 0x2792 : 0x278c);
        if (k & 1) {
            set32(g_self, 0x1344, 1);
            g_self[0x13b1] = 0;
            g_self[0x13b0] = 0xff;   /* (+0x13b0, not +0x13b1, is set) */
        }
        snap47();
        run47();
        CK(g_ret47 == 0 && L.n == 0 && same47());
    }
    /* ---- the release (event 0x2791 with +0x1344 == 0): the rectangles come back from the blocks at +0x1352 and +0x1372 ---- */
    {
        static const uint32_t held[] = {1, 0x10000u, 0xff000000u};
        static const uint8_t r5e[] = {0, 1, 3, 0xff};
        static const uint8_t cnts[] = {12, 0xff, 0};
        /* something is held (+0x13df != 0) and the record byte +0x5e is not 2: flag +0x22 set, the counter bumped, 0x480a1d, selection cleared, end */
        for (k = 0; k < 4; k++) {
            for (i = 0; i < 3; i++) {
                setup47(0x2791);
                set32(g_self, 0x13df, held[i]);
                g_rec2[0x5e] = r5e[k];
                g_self[0x7a0 + 2] = cnts[i];
                snap47();
                release_head(1);
                x_self[IT(1, 0x22)] = 1;
                x_self[0x7a0 + 2] = (uint8_t)(cnts[i] + 1);
                set16(x_self, 0x1350, 0xffff);
                run47();
                CK(g_ret47 == 0 && L.n == 2);
                CK(is_call(0, 0x47ed96, SELF(0), 1) && (L.c[0].a[0] & 0xffff) == 1);
                CK(is_call(1, 0x480a1d, SELF(0), 0) && L.c[1].probe[PQ_ITEM + 0x22] == 1 && L.c[1].probe[PQ_CNT + 2] == (uint8_t)(cnts[i] + 1));
                CK(get16(L.c[1].probe, PQ_A + 0x10) == 1 && memcmp(L.c[1].probe + PQ_ITEM, x_self + IT(1, 0), 0x20) == 0);   /* the selection is cleared after */
                CK(same47());
            }
        }
        /* held and the byte is 2: no flag, the counter bumped, 0x480a1d, then the common end */
        for (i = 0; i < 3; i++) {
            setup47(0x2791);
            set32(g_self, 0x13df, held[i]);
            g_rec2[0x5e] = 2;
            g_self[0x7a0 + 2] = cnts[i];
            snap47();
            release_head(1);
            x_self[0x7a0 + 2] = (uint8_t)(cnts[i] + 1);
            run47();
            CK(g_ret47 == 0 && L.n == 3);
            CK(is_call(0, 0x47ed96, SELF(0), 1));
            CK(is_call(1, 0x480a1d, SELF(0), 0) && L.c[1].probe[PQ_ITEM + 0x22] == 0x22 && L.c[1].probe[PQ_CNT + 2] == (uint8_t)(cnts[i] + 1));
            release_tail(2, 1);
            CK(same47());
        }
        /* nothing held, the nine bytes equal: the common end only */
        setup47(0x2791);
        snap47();
        release_head(1);
        run47();
        CK(g_ret47 == 0 && L.n == 2 && is_call(0, 0x47ed96, SELF(0), 1));
        release_tail(1, 1);
        CK(same47());
        /* the same for the item 0 and 2 (their kinds select the record bytes) */
        for (n = 0; n <= 2; n += 2) {
            setup47(0x2791);
            set16(g_self, 0x1350, (uint16_t)n);
            snap47();
            release_head(n);
            run47();
            CK(g_ret47 == 0 && L.n == 2 && is_call(0, 0x47ed96, SELF(0), 1) && (L.c[0].a[0] & 0xffff) == (unsigned)n);
            release_tail(1, n);
            CK(same47());
        }
    }
    /* nothing held, a difference at any of the nine bytes: the captions (0x5bb202 == 0: none) */
    for (k = 0; k < 9; k++) {
        setup47(0x2791);
        g_rec2[0x7a8 + k] ^= (uint8_t)(1u << (k & 7));
        set16(g_rec2, 0x7c9, 0x1234);
        strcpy((char *)g_rec2 + 0x7d9, "pp");
        strcpy((char *)g_rec2 + 0x7fa, "qq");
        w47.value_5bb202 = 0;
        L.tick = 0x1000;
        snap47();
        release_head(1);
        set32(x_self, 0x13ca, 1);
        set32(x_self, 0x13e7, 0x10c8);
        run47();
        CK(g_ret47 == 0 && L.n == 4);
        CK(is_call(1, 0x4fb2e3, 0x5c3a67, 1) && (L.c[1].a[0] & 0xffff) == 0x1234 && is_tick(2));
        release_tail(3, 1);
        CK(same47());
    }
    rel_strings("", 0, "", "XYZ12", 2);                /* only the second string */
    rel_strings("p", 0, "", "XYZ12", 0x10000u);        /* 0x423259 answers nothing: the second string */
    rel_strings("p", 1, "hello!!", "XYZ12", 1);        /* the looked-up text wins; the first suffix */
    rel_strings("p", 1, "hello!!", "", 1);
    rel_strings("p", 2, "", "XYZ12", 1);               /* a text of 0x9c41 characters is dropped */
    rel_strings("p", 2, "", "", 1);                    /* ... and without a second string nothing is shown */
    rel_strings("", 0, "", "", 1);                     /* nothing at all */
    rel_strings("p", 0, "", "XYZ12", 0);               /* the flag 0x5bb202 is clear: no 0x423259 call, no caption */
    {
        char t200[201], t201[202];
        memset(t200, 'x', 200);
        t200[200] = 0;
        memset(t201, 'y', 201);
        t201[201] = 0;
        rel_strings("p", 1, t200, "", 1);              /* the longest caption the frame holds */
        rel_strings("", 0, "", t200, 1);
        rel_strings("p", 1, t201, "", 1);              /* rejected: the original would overrun its frame */
        rel_strings("", 0, "", t201, 1);
        rel_strings("p", 3, "", "XYZ12", 1);           /* 0x9c40 characters: allowed by the original, rejected here */
    }
    /* anything else with +0x1344 == 0 or +0x13b1 == 0 and an event that is neither a click nor a release */
}

/* ---- 0x4b64a9 ---------------------------------------------------------------------------------------------------------------- */

#define RECVA4 0x31000000u
#define IDX4 2                       /* the record index used by every case */
#define SIDX4 ((size_t)IDX4 * REC)
#define TSLACK4 3                    /* entries of 0x4a bytes below the table at 0x5d1591 */
#define ENT4(idx) ((size_t)((idx) + TSLACK4) * 0x4a)
#define SLOT4 7                      /* the slot word (+0x1c) that states 1 and 2 find in the session */

static uint8_t g4_self[0x300], x4_self[0x300], o4_self[0x300];
static uint8_t g_rec4[0x400], x_rec4[0x400];
static uint8_t g_tab4[(TSLACK4 + 0x44) * 0x4a], x_tab4[sizeof g_tab4];
static uint8_t g_consts4[84], g_str4[40];
static Fl22bWorld w4, e4;
static int32_t g_ret4;
static int g_probe_slot = SLOT4;

/* the offsets of the probe snapshot taken at every host call and at GetTickCount */
enum { Q_SELF = 0, Q_1CA = 0x300, Q_STATE = 0x304, Q_ENT = 0x308, Q_G = 0x352, Q_FLAGS = 0x36c };

static void probe_all_4b64a9(void)
{
    add_probe(g4_self, 0x300);
    add_probe(&w4.value_5bb1ca, 4);
    add_probe(g_records + SIDX4 + 0x4d, 4);
    add_probe(g_tab4 + ENT4(g_probe_slot), 0x4a);
    add_probe(&w4.value_5bb57b, 4);
    add_probe(&w4.value_5bb59b, 4);
    add_probe(&w4.value_5bb59f, 4);
    add_probe(&w4.value_5bb5a3, 4);
    add_probe(&w4.value_583999, 4);
    add_probe(&w4.word_5bb599, 2);
    add_probe(&w4.word_5bb595, 2);
    add_probe(&w4.word_5c39ff, 2);
    add_probe(g_flags, 0x100);
}

/* the nine bytes of slot k of the constants: "SLOT<k>-ABC"; record fields set equal to them (eq9) or one byte off (ne9) */
static void eq9(size_t off, int k) { memcpy(g_rec4 + off, g_consts4 + 12 * k, 9); }
static void ne9(size_t off, int k, int pos)
{
    eq9(off, k);
    g_rec4[off + (size_t)pos] ^= (uint8_t)(0x01u << (pos & 7));
}

/* a fixed fixture: record IDX4 in `state`, the session with the step `step`; the record has 3 items, the divisor 4 (+0x25), the last
 * position 4 (+0x23 == 5), +0x2d4 == 3, +0x2d7 == 2, the words +0x2fa == -3 and +0x366 == 0x1234, the byte +0x2d6 == 1 and the names
 * (+0x2d9, +0x345) equal to slots 0 and 1 */
static void setup4(uint32_t state, uint32_t step)
{
    size_t i;
    int k;
    for (i = 0; i < sizeof g4_self; i++) g4_self[i] = (uint8_t)(i * 5 + 1);
    for (i = 0; i < sizeof g_rec4; i++) g_rec4[i] = (uint8_t)(i * 7 + 3);
    for (i = 0; i < sizeof g_tab4; i++) g_tab4[i] = (uint8_t)(i * 3 + 2);
    for (i = 0; i < sizeof g_flags; i++) g_flags[i] = (uint8_t)(i * 5 + 2);
    for (k = 0; k < 7; k++) {
        memcpy(g_consts4 + 12 * k, "SLOT0-ABC", 9);
        g_consts4[12 * k + 4] = (uint8_t)('0' + k);
        memset(g_consts4 + 12 * k + 9, 0xee, 3);
    }
    memset(g_str4, 0x77, sizeof g_str4);
    memcpy(g_str4, "OVERLAYS", 9);
    set16(g_rec4, 0x21, 3);
    set16(g_rec4, 0x25, 4);
    set16(g_rec4, 0x23, 5);
    set16(g_rec4, 0x2d4, 3);
    set16(g_rec4, 0x2d7, 2);
    set16(g_rec4, 0x2fa, 0xfffd);
    set16(g_rec4, 0x366, 0x1234);
    g_rec4[0x2d6] = 1;
    eq9(0x2d9, 0);
    eq9(0x345, 1);
    set16(g4_self, 0x1e, IDX4);
    set16(g4_self, 0x1c, SLOT4);
    set32(g4_self, 0x274, step);
    memset(g_records, 0, sizeof g_records);
    set32(g_records, SIDX4, RECVA4);
    set32(g_records, SIDX4 + 0x4d, state);
    set32(g_records, 4 * REC + 0x4d, 0x44);
    set32(g_records, 3 * REC, 0x32000000u);
    memset(&w4, 0, sizeof w4);
    w4.records_5bb5e5 = g_records;
    w4.flags_585801 = g_flags + 0x40;
    w4.table_5d1591 = g_tab4 + TSLACK4 * 0x4a;
    w4.string_551b24 = g_str4;
    w4.bytes_551b5c = g_consts4;
    w4.value_58318a = 0x100;
    w4.value_583186 = 0x10000;
    w4.value_5bb1ca = 0x55;
    w4.value_5bb57b = 0x5557;
    w4.value_5bb59b = 0x559b;
    w4.value_5bb59f = 0x559f;
    w4.value_5bb5a3 = 0x55a3;
    w4.value_583999 = 0x5599;
    w4.word_5bb599 = 0x1111;
    w4.word_5bb595 = 0x2222;
    w4.word_5c39ff = 0x3333;
    reset_log();
    add_region(RECVA4, g_rec4, sizeof g_rec4);
    for (i = 0; i < 20; i++) {   /* the call n of 0x4b6355 fills its four dwords with A, B, C, D of n */
        queue_write(0x4b6355, (int)i, 3, 0, 4, 0xa0000000u + (uint32_t)i);
        queue_write(0x4b6355, (int)i, 3, 4, 4, 0xb0000000u + (uint32_t)i);
        queue_write(0x4b6355, (int)i, 3, 8, 4, 0xc0000000u + (uint32_t)i);
        queue_write(0x4b6355, (int)i, 3, 12, 4, 0xd0000000u + (uint32_t)i);
    }
    probe_all_4b64a9();
}

static void snap4(void)
{
    memcpy(x4_self, g4_self, sizeof g4_self);
    memcpy(o4_self, g4_self, sizeof g4_self);
    memcpy(x_rec4, g_rec4, sizeof g_rec4);
    memcpy(x_tab4, g_tab4, sizeof g_tab4);
    memcpy(x_flags, g_flags, sizeof g_flags);
    memcpy(x_records, g_records, sizeof g_records);
    e4 = w4;
}

/* everything the function can touch is as snapshotted-and-edited (the record object is never written) */
static int same4(void)
{
    return memcmp(g4_self, x4_self, sizeof g4_self) == 0 && memcmp(g_rec4, x_rec4, sizeof g_rec4) == 0 && memcmp(g_tab4, x_tab4, sizeof g_tab4) == 0 &&
           memcmp(g_flags, x_flags, sizeof g_flags) == 0 && memcmp(g_records, x_records, sizeof g_records) == 0 && memcmp(&w4, &e4, sizeof w4) == 0;
}

static void run4(int16_t index)
{
    Fl18Host h = host();
    g_ret4 = m4b64a9_run_scene(g4_self, index, &w4, &h);
}

#define XS32(off, v) set32(x4_self, (off), (v))
#define XS16(off, v) set16(x4_self, (off), (v))

/* the stores that follow the n-th call of 0x4b6355 for item i: +0x24 A, +0x28 B, +0x2c C, +0x30 D (the dwords of the local) */
static void expect_item(int i, int n)
{
    XS32(0x24 + (size_t)i * 16, 0xa0000000u + (uint32_t)n);
    XS32(0x28 + (size_t)i * 16, 0xb0000000u + (uint32_t)n);
    XS32(0x2c + (size_t)i * 16, 0xc0000000u + (uint32_t)n);
    XS32(0x30 + (size_t)i * 16, 0xd0000000u + (uint32_t)n);
}

/* a call of 0x4b6355 with the index, the two words and a host pointer */
static int is_place(int k, int index, uint16_t w1, uint16_t w2)
{
    return is_call(k, 0x4b6355, (uintptr_t)g4_self, 4) && (L.c[k].a[0] & 0xffff) == (uint16_t)index && (L.c[k].a[1] & 0xffff) == w1 &&
           (L.c[k].a[2] & 0xffff) == w2 && (uint64_t)L.c[k].a[3] > 0xffffffffu;
}

/* ---- state 0 ---- */
static void state0_4b64a9(void)
{
    static const int counts[] = {0, 1, 3, 16};
    static const struct { int16_t idx; size_t len; } slots[] = {{0x18, 0}, {0x3f, 3}, {-2, 22}, {0x41, 23}, {0, 31}, {-3, 1}};
    int c, s, a, b, i, nlog;
    for (c = 0; c < 4; c++) {
        for (s = 0; s < 6; s++) {
            for (a = -1; a < 2; a++) {            /* the first name: equal (-1) / differs at byte 0 / byte 8 */
                for (b = -1; b < 2; b++) {        /* the second name */
                    int n = counts[c], f20 = (s & 1) == 0;   /* +0x20 zero: 0x4c2790 is called */
                    int16_t idx = slots[s].idx;
                    size_t len = slots[s].len, e = ENT4(idx);
                    g_probe_slot = idx;
                    setup4(0, 0);
                    set16(g_rec4, 0x21, (uint16_t)n);
                    for (i = 0; i < n; i++) {
                        set32(g_rec4, 0x47 + (size_t)i * 16, 0x1000u + (uint32_t)i);   /* x */
                        set32(g_rec4, 0x4b + (size_t)i * 16, 0x2000u + (uint32_t)i);   /* x2 */
                        set32(g_rec4, 0x4f + (size_t)i * 16, 0x3000u + (uint32_t)i);   /* y */
                        set32(g_rec4, 0x53 + (size_t)i * 16, 0x4000u + (uint32_t)i);   /* y2 */
                        set16(g_rec4, 0x27 + (size_t)i * 2, (uint16_t)(0x500 + i));
                    }
                    if (a >= 0) ne9(0x2d9, 0, a * 8);
                    if (b >= 0) ne9(0x345, 1, b * 8);
                    memset(g_str4, 0x77, sizeof g_str4);
                    memset(g_str4, 'x', len);
                    g_str4[len] = 0;
                    set32(g4_self, 0x20, f20 ? 0 : 0x77777777u);
                    w4.value_583186 = 0xfffffff0u;   /* (a wrap) */
                    queue_return(0x4d39f9, 0xabcd0000u | (uint16_t)idx);
                    queue_return(0x4c2790, 0xcafe0001u);
                    snap4();
                    /* expected result */
                    XS16(0x1e, IDX4);
                    XS32(0x225, 1);
                    XS32(0x254, 0);
                    XS32(0x258, 0);
                    XS32(0x25c, 0);
                    XS32(0x260, 0);
                    for (i = 0; i < n; i++) {
                        XS32(0x128 + (size_t)i * 16, 0x2000u + (uint32_t)i + 0x100u);
                        XS32(0x130 + (size_t)i * 16, 0x4000u + (uint32_t)i + 0x100u);
                        XS32(0x124 + (size_t)i * 16, 0x1000u + (uint32_t)i + 0xfffffff0u);
                        XS32(0x12c + (size_t)i * 16, 0x3000u + (uint32_t)i + 0xfffffff0u);
                        XS16(0x254 + (size_t)i * 2, (uint16_t)(0x500 + i));
                        expect_item(i, i);
                    }
                    x4_self[0x224] = 1;
                    XS16(0x1c, (uint16_t)idx);
                    if (f20) XS32(0x20, 0xcafe0001u);
                    x4_self[0x229] = 0;
                    x4_self[0x22a] = 0;
                    XS16(0x22c, 1);
                    XS32(0x274, 0);
                    set32(x_tab4, e + 0, 0xa);
                    set32(x_tab4, e + 4, 0x4b7051);
                    set32(x_tab4, e + 8, f20 ? 0xcafe0001u : 0x77777777u);
                    set32(x_tab4, e + 0xc, 0);
                    set32(x_tab4, e + 0x10, 0);
                    set32(x_tab4, e + 0x14, 1);
                    set32(x_tab4, e + 0x18, 1);
                    set16(x_tab4, e + 0x1c, 0);
                    memset(x_tab4 + e + 0x22, 'x', len);
                    x_tab4[e + 0x22 + len] = 0;   /* the string with its terminator; the bytes after it are not touched */
                    e4.value_5bb1ca = 1;
                    set32(x_records, SIDX4 + 0x4d, 1);
                    run4(IDX4);
                    CK(g_ret4 == FL22B_4B64A9_OK);
                    nlog = 0;
                    CK(is_call(nlog, 0x4e8d96, 0x571442, 0));
                    CK(P32(nlog, Q_1CA) == 1 && P16(nlog, Q_SELF + 0x1e) == IDX4);   /* 0x5bb1ca and the index are stored before the first call */
                    CK(P32(nlog, Q_STATE) == 0 && P32(nlog, Q_SELF + 0x225) == 1);
                    nlog++;
                    for (i = 0; i < n; i++, nlog++) {
                        CK(is_place(nlog, i, (uint16_t)(0x500 + i), 0));
                        CK(P32(nlog, Q_SELF + 0x128 + (size_t)i * 16) == 0x2100u + (uint32_t)i);   /* the coordinates are stored before the call */
                        CK(P16(nlog, Q_SELF + 0x254 + (size_t)i * 2) == 0x500 + i);
                        CK(P32(nlog, Q_SELF + 0x24 + (size_t)i * 16) == get32(o4_self, 0x24 + (size_t)i * 16));   /* this item is stored after the call */
                        if (i > 0) CK(P32(nlog, Q_SELF + 0x24 + (size_t)(i - 1) * 16) == 0xa0000000u + (uint32_t)(i - 1));   /* the previous item is stored */
                    }
                    CK(is_call(nlog, 0x4d39f9, 0, 0));
                    CK(P8(nlog, Q_SELF + 0x224) == 1);
                    nlog++;
                    if (f20) {
                        CK(is_call(nlog, 0x4c2790, 0x5cf659, 4));
                        CK(L.c[nlog].a[0] == 0x551b54 && L.c[nlog].a[1] == RECVA4 && L.c[nlog].a[2] == 6 && L.c[nlog].a[3] == 0x551b3c);
                        CK(get32(L.c[nlog].probe, Q_ENT) == 0xa && get32(L.c[nlog].probe, Q_ENT + 4) == 0x4b7051);   /* the entry is filled in first */
                        CK(get32(L.c[nlog].probe, Q_ENT + 8) == 0 && P32(nlog, Q_SELF + 0x20) == 0);
                        CK(memcmp(L.c[nlog].probe + Q_ENT + 0x22, x_tab4 + e + 0x22, len + 1) == 0);
                        nlog++;
                    }
                    if (a >= 0) {
                        CK(is_call(nlog, 0x4fb77a, 0x5c3a67, 1) && L.c[nlog].a[0] == RECVA4 + 0x2d9);
                        CK(get32(L.c[nlog].probe, Q_ENT + 8) == (f20 ? 0xcafe0001u : 0x77777777u));   /* the session's +0x20 is stored into the entry before */
                        CK(P8(nlog, Q_SELF + 0x22a) == o4_self[0x22a]);                                 /* the flag bytes are cleared after */
                        nlog++;
                    }
                    if (b >= 0) {
                        CK(is_call(nlog, 0x4fb77a, 0x5c3a67, 1) && L.c[nlog].a[0] == RECVA4 + 0x345);
                        nlog++;
                    }
                    CK(L.n == nlog);
                    CK(same4());
                }
            }
        }
    }
}

/* ---- state 1 ---- */
static void step03_4b64a9(void)
{
    static const struct { uint32_t tick, deadline; int due; } c[] = {{999, 1000, 0}, {1000, 1000, 1}, {1001, 1000, 1}, {0x7fffffffu, 0x80000000u, 0},
                                                                    {0x80000000u, 0x7fffffffu, 1}, {0, 0xffffffffu, 0}, {0xffffffffu, 0, 1}};
    int k, pos, f;
    /* step 0: the byte +0x22a decides between the step 4 and a call of 0x4b642d */
    for (f = 0; f < 3; f++) {
        setup4(1, 0);
        g4_self[0x22a] = (uint8_t)(f == 0 ? 0 : f == 1 ? 1 : 0xff);
        snap4();
        if (f != 0) XS32(0x274, 4);
        run4(IDX4);
        CK(g_ret4 == 0);
        if (f == 0) {
            CK(L.n == 1 && is_call(0, 0x4b642d, (uintptr_t)g4_self, 0) && P32(0, Q_SELF + 0x274) == 0);
        } else {
            CK(L.n == 0);
        }
        CK(same4());
    }
    /* step 3: GetTickCount (unsigned) against +0x22e; then 274 := 2, and with +0x22a set the name against slot 2 */
    for (k = 0; k < 7; k++) {
        for (f = 0; f < 2; f++) {
            for (pos = -1; pos < 9; pos++) {
                setup4(1, 3);
                set32(g4_self, 0x22e, c[k].deadline);
                g4_self[0x22a] = (uint8_t)(f ? 0x80 : 0);
                if (pos >= 0) ne9(0x2d9, 2, pos); else eq9(0x2d9, 2);
                L.tick = c[k].tick;
                snap4();
                if (c[k].due) XS32(0x274, 2);
                run4(IDX4);
                CK(is_tick(0));
                if (!c[k].due || !f || pos < 0) {
                    CK(L.n == 1);
                } else {
                    CK(L.n == 2 && is_call(1, 0x4fb2e3, 0x5c3a67, 1) && (L.c[1].a[0] & 0xffff) == 0xfffd && P32(1, Q_SELF + 0x274) == 2);
                }
                CK(same4());
            }
        }
    }
    /* steps above 5 and states above 2 do nothing */
    {
        static const uint32_t steps[] = {6, 7, 0x80000000u, 0xffffffffu};
        static const uint32_t states[] = {3, 4, 0x80000000u, 0xffffffffu};
        for (k = 0; k < 4; k++) {
            setup4(1, steps[k]);
            snap4();
            run4(IDX4);
            CK(g_ret4 == 0 && L.n == 0 && same4());
            setup4(states[k], 0);
            snap4();
            run4(IDX4);
            CK(g_ret4 == 0 && L.n == 0 && same4());
        }
    }
}

/* step 2: the items that move */
static void step2_4b64a9(void)
{
    /* the expected division results: (+0x2d4 * 1000) / +0x25 with idiv (truncation toward zero), added to GetTickCount */
    static const struct { int16_t w2d4, w25; uint32_t tick, deadline; } dv[] = {
        {3, 4, 1000, 1750}, {-7, 3, 1000, 1000u - 2333u}, {0x7fff, 1, 0xffffff00u, 0xffffff00u + 32767000u}, {-32768, -3, 5, 5u + 10922666u},
        {0, 7, 77, 77}, {1, -2, 100, 100u - 500u}};
    int d, mv, moved, a22, mode, i, nlog, n, calls, lasti;
    for (d = 0; d < 6; d++) {
        for (mv = 0; mv < 2; mv++) {        /* +0x22c equal to +0x25: the items advance */
            for (a22 = 0; a22 < 2; a22++) {
                for (mode = 0; mode < 6; mode++) {
                    /* the flag words F[0..2], the positions P[0..2] */
                    static const int16_t F[6][3] = {{1, 1, 1}, {1, 0, 1}, {0, 0, 0}, {0x100, 5, 0x7fff}, {0, 1, 0}, {1, 1, 1}};
                    static const int16_t Pp[6][3] = {{4, 4, 4}, {3, 4, 0}, {4, 4, 4}, {4, 3, -32768}, {4, 2, 4}, {-1, 5, 3}};
                    int16_t w25 = dv[d].w25, s22c = (int16_t)(mv ? w25 : (int16_t)(w25 + 1));
                    n = 3;
                    setup4(1, 2);
                    set16(g_rec4, 0x25, (uint16_t)w25);
                    set16(g_rec4, 0x2d4, (uint16_t)dv[d].w2d4);
                    set16(g_rec4, 0x23, 5);   /* the last position is 4 */
                    set16(g4_self, 0x22c, (uint16_t)s22c);
                    g4_self[0x22a] = (uint8_t)(a22 ? 1 : 0);
                    for (i = 0; i < n; i++) {
                        set16(g4_self, 0x232 + (size_t)i * 2, (uint16_t)F[mode][i]);
                        set16(g4_self, 0x254 + (size_t)i * 2, (uint16_t)Pp[mode][i]);
                    }
                    L.tick = dv[d].tick;
                    snap4();
                    x4_self[0x224] = 1;
                    /* an item only counts as moved when it has its flag word set: with none the step schedules the next one */
                    moved = mv && (F[mode][0] != 0 || F[mode][1] != 0 || F[mode][2] != 0);
                    calls = 0;
                    for (i = 0; i < n; i++) {
                        if (F[mode][i] == 0) continue;
                        if (mv && Pp[mode][i] == 4) XS16(0x254 + (size_t)i * 2, 0);
                        else if (mv) XS16(0x254 + (size_t)i * 2, (uint16_t)(Pp[mode][i] + 1));
                        expect_item(i, calls++);
                    }
                    if (moved) {
                        XS32(0x274, 0);
                        XS16(0x22c, 1);
                        if (!a22) for (i = 0; i < n; i++) XS16(0x232 + (size_t)i * 2, 0);
                    } else {
                        XS32(0x22e, dv[d].deadline);
                        XS32(0x274, 3);
                        XS16(0x22c, (uint16_t)(s22c + 1));
                    }
                    run4(IDX4);
                    CK(g_ret4 == 0);
                    nlog = 0;
                    calls = 0;
                    lasti = 0;
                    for (i = 0; i < n; i++) {
                        if (F[mode][i] == 0) continue;
                        if (mv && Pp[mode][i] == 4) CK(is_place(nlog, i, 0, 0));
                        else CK(is_place(nlog, i, (uint16_t)Pp[mode][i], (uint16_t)s22c));
                        CK(P8(nlog, Q_SELF + 0x224) == 1);
                        CK(P16(nlog, Q_SELF + 0x254 + (size_t)i * 2) == (uint16_t)Pp[mode][i]);   /* the position is stored after the call */
                        if (calls > 0) CK(P32(nlog, Q_SELF + 0x24 + 16u * (uint32_t)lasti) == 0xa0000000u + (uint32_t)(calls - 1));   /* the previous item is stored */
                        lasti = i;
                        nlog++;
                        calls++;
                    }
                    if (!moved) {
                        CK(is_tick(nlog));
                        CK(P32(nlog, Q_SELF + 0x274) == 2 && P16(nlog, Q_SELF + 0x22c) == (uint16_t)s22c);   /* nothing is stored before the tick */
                        nlog++;
                    }
                    CK(L.n == nlog);
                    CK(same4());
                }
            }
        }
    }
}

/* the same words in 0x4b6355 calls with no moving item at all (mode 2) do not touch the call log: only the tick */
static void step14_4b64a9(void)
{
    int pos, r, z, k;
    /* step 1 */
    for (pos = -1; pos < 9; pos++) {
        for (z = 0; z < 2; z++) {
            for (r = 0; r < 3; r++) {
                static const uint32_t res[] = {0, 1, 0x80000000u};
                for (k = -1; k < 9; k += 3) {
                    int eqname = pos < 0, cnt = 3;
                    setup4(1, 1);
                    if (pos >= 0) ne9(0x345, 3, pos); else eq9(0x345, 3);
                    g_rec4[0x2d6] = (uint8_t)(z ? 0 : 0x40);
                    if (k >= 0) ne9(0x2d9, 4, k); else eq9(0x2d9, 4);
                    set16(g4_self, 0x1e, (uint16_t)(pos & 1 ? 4 : IDX4));   /* the record that is moved on is the one of the session */
                    queue_return(0x4f6334, res[r]);
                    snap4();
                    run4(IDX4);
                    CK(g_ret4 == 0);
                    if (!eqname) {
                        CK(L.n == 1 && is_call(0, 0x4fb2e3, 0x5c3a67, 1) && (L.c[0].a[0] & 0xffff) == 0x1234 && P32(0, Q_SELF + 0x274) == 1);
                        XS32(0x274, 5);
                    } else if (!z && res[r] == 0) {
                        int i;
                        CK(is_call(0, 0x4f6334, 0x5cf1eb, 1) && L.c[0].a[0] == (uintptr_t)(uint32_t)(int32_t)(int16_t)0xfffd);
                        for (i = 0; i < cnt; i++) XS16(0x232 + (size_t)i * 2, 1);
                        XS32(0x274, 2);
                        XS16(0x22c, 1);
                        x4_self[0x22b] = 0;
                        if (k >= 0) {
                            CK(L.n == 2 && is_call(1, 0x4fb2e3, 0x5c3a67, 1) && (L.c[1].a[0] & 0xffff) == 0xfffd);
                            CK(P32(1, Q_SELF + 0x274) == 2 && P16(1, Q_SELF + 0x22c) == 1 && P8(1, Q_SELF + 0x22b) == 0);   /* the stores come first */
                        } else {
                            CK(L.n == 1);
                        }
                    } else if (!z) {
                        CK(L.n == 1 && is_call(0, 0x4f6334, 0x5cf1eb, 1));   /* the call is non-zero: nothing happens */
                    } else {
                        CK(L.n == 0);
                        set32(x_records, (size_t)(pos & 1 ? 4 : IDX4) * REC + 0x4d, 2);
                    }
                    CK(same4());
                }
            }
        }
    }
    /* step 5 */
    for (pos = 0; pos < 2; pos++) {
        for (z = 0; z < 2; z++) {
            for (r = 0; r < 3; r++) {
                static const uint32_t res[] = {0, 1, 0x80000000u};
                for (k = -1; k < 9; k += 3) {
                    int second, i;
                    setup4(1, 5);
                    g_rec4[0x2d6] = (uint8_t)(z ? 0 : 0x40);
                    if (k >= 0) ne9(0x2d9, 5, k); else eq9(0x2d9, 5);
                    set16(g4_self, 0x1e, (uint16_t)(pos ? 4 : IDX4));
                    queue_return(0x4f6334, res[pos ? 1 : 0]);   /* the first answer */
                    queue_return(0x4f6334, res[r]);             /* the second */
                    snap4();
                    run4(IDX4);
                    CK(g_ret4 == 0);
                    if (pos) {   /* the first call answers non-zero: nothing else */
                        CK(L.n == 1 && is_call(0, 0x4f6334, 0x5cf1eb, 1) && L.c[0].a[0] == 0x1234);
                    } else {
                        CK(is_call(0, 0x4f6334, 0x5cf1eb, 1) && L.c[0].a[0] == 0x1234);
                        CK(is_call(1, 0x4fba69, 0x5c3a67, 1) && L.c[1].a[0] == RECVA4 + 0x345);
                        second = !z && res[r] == 0;
                        if (second) {
                            CK(is_call(2, 0x4f6334, 0x5cf1eb, 1) && L.c[2].a[0] == (uintptr_t)(uint32_t)(int32_t)(int16_t)0xfffd);
                            for (i = 0; i < 3; i++) XS16(0x232 + (size_t)i * 2, 1);
                            XS32(0x274, 2);
                            XS16(0x22c, 1);
                            x4_self[0x22b] = 0;
                            if (k >= 0) {
                                CK(L.n == 4 && is_call(3, 0x4fb2e3, 0x5c3a67, 1) && (L.c[3].a[0] & 0xffff) == 0xfffd);
                                CK(P32(3, Q_SELF + 0x274) == 2);
                            } else {
                                CK(L.n == 3);
                            }
                        } else if (!z) {
                            CK(L.n == 3);
                        } else {
                            CK(L.n == 2);
                            set32(x_records, (size_t)IDX4 * REC + 0x4d, 2);
                        }
                    }
                    CK(same4());
                }
            }
        }
    }
}

/* step 4 */
static void step4_4b64a9(void)
{
    static const struct { int16_t w2d4, w25; uint32_t tick, deadline; } dv[] = {
        {3, 4, 1000, 1000u + 6000u}, {-7, 3, 1000, 1000u - 18666u}, {0x7fff, 1, 0xffffff00u, 0xffffff00u + 262136000u}, {-32768, -3, 5, 5u + 87381333u},
        {0, 7, 77, 77}, {1, -2, 100, 100u - 4000u}};
    /* again == (p0 < w23 - 1) || !(b22b >= w2d7 * (w23 - 1) - 1), worked out by hand for each row */
    static const struct { int16_t p0, w23, w2d7; uint8_t b22b; int again; } c[] = {
        {3, 5, 2, 0, 1},         /* 3 < 4: again */
        {4, 5, 2, 0, 1},         /* 4 < 4 no; 0 >= 2 * 4 - 1 = 7 no: again */
        {4, 5, 2, 7, 0},         /* 7 >= 7: done */
        {4, 5, 2, 6, 1},         /* 6 >= 7 no: again */
        {5, 5, 2, 200, 0},       /* 200 >= 7: done */
        {-32768, 1, 1, 0, 1},    /* -32768 < 0: again */
        {0, 1, 1, 0, 0},         /* 0 < 0 no; 0 >= 1 * 0 - 1 = -1: done */
        {4, 5, 2, 0xff, 0},      /* the byte is zero-extended: 255 >= 7: done */
        {4, 5, -1, 0, 0},        /* 0 >= -1 * 4 - 1 = -5: done */
        {4, 5, 0x7fff, 0xff, 1}, /* 255 >= 0x7fff * 4 - 1 = 131067 no: again */
        {3, 5, 2, 0xff, 1},      /* again, the byte wraps to 0 */
    };
    int k, d;
    for (k = 0; k < 11; k++) {
        int again = c[k].again, a;
        for (d = 0; d < 6; d++) {
            for (a = 0; a < 2; a++) {
                setup4(1, 4);
                set16(g_rec4, 0x23, (uint16_t)c[k].w23);
                set16(g_rec4, 0x2d7, (uint16_t)c[k].w2d7);
                set16(g_rec4, 0x25, (uint16_t)dv[d].w25);
                set16(g_rec4, 0x2d4, (uint16_t)dv[d].w2d4);
                set16(g4_self, 0x254, (uint16_t)c[k].p0);
                g4_self[0x22b] = c[k].b22b;
                g4_self[0x22a] = (uint8_t)a;
                set16(g4_self, 0x1e, (uint16_t)(a ? 4 : IDX4));
                L.tick = dv[d].tick;
                snap4();
                if (again) {
                    XS32(0x22e, dv[d].deadline);
                    XS32(0x274, 3);
                    x4_self[0x22b] = (uint8_t)(c[k].b22b + 1);
                } else {
                    set32(x_records, (size_t)(a ? 4 : IDX4) * REC + 0x4d, 2);
                }
                run4(IDX4);
                CK(g_ret4 == 0);
                if (again) {
                    CK(L.n == 1 && is_tick(0) && P32(0, Q_SELF + 0x274) == 4 && P8(0, Q_SELF + 0x22b) == c[k].b22b);
                } else {
                    CK(L.n == 0);
                }
                CK(same4());
            }
        }
    }
}

/* a zero divisor (+0x25 == 0) in steps 2 (nothing moves) and 4: the original divides by zero after the GetTickCount call */
static void divide_4b64a9(void)
{
    setup4(1, 4);
    set16(g_rec4, 0x25, 0);
    set16(g4_self, 0x254, 0);
    L.tick = 0x1234;
    snap4();
    run4(IDX4);
    CK(g_ret4 == FL22B_4B64A9_REJECT_DIVIDE_BY_ZERO && L.n == 1 && is_tick(0) && same4());
    setup4(1, 2);
    set16(g_rec4, 0x25, 0);
    set16(g4_self, 0x22c, 1);   /* different from the divisor: no item moves */
    set16(g4_self, 0x232, 0);
    set16(g4_self, 0x234, 0);
    set16(g4_self, 0x236, 0);
    L.tick = 0x1234;
    snap4();
    x4_self[0x224] = 1;
    run4(IDX4);
    CK(g_ret4 == FL22B_4B64A9_REJECT_DIVIDE_BY_ZERO && L.n == 1 && is_tick(0) && same4());
    setup4(1, 2);
    set16(g_rec4, 0x25, 0);
    set16(g4_self, 0x22c, 0);   /* equal to the divisor: the items advance and no division happens */
    set16(g4_self, 0x232, 1);
    set16(g4_self, 0x234, 0);
    set16(g4_self, 0x236, 0);
    set16(g4_self, 0x254, 4);
    g4_self[0x22a] = 0;
    snap4();
    x4_self[0x224] = 1;
    XS16(0x254, 0);
    expect_item(0, 0);
    XS32(0x274, 0);
    XS16(0x22c, 1);
    XS16(0x232, 0);
    XS16(0x234, 0);
    XS16(0x236, 0);
    run4(IDX4);
    CK(g_ret4 == 0 && L.n == 1 && is_place(0, 0, 0, 0) && same4());
}

/* ---- state 2 ---- */
static void state2_4b64a9(void)
{
    int pos, f9, fa, sel, fidx, sub, base, nlog;
    for (pos = -1; pos < 9; pos += 3) {
        for (f9 = 0; f9 < 2; f9++) {
            for (fa = 0; fa < 2; fa++) {
                for (sel = 0; sel < 3; sel++) {          /* the selector word of the block: 0x270f (nothing loaded), or 5 / -7 */
                    for (fidx = 0; fidx < 3; fidx++) {   /* the flag index word: -1 (none), 3, -2 */
                        for (sub = 0; sub < 3; sub++) {  /* the word at block + 0x14: 1 (clears 0x5bb1ca), 2, -1 */
                            int16_t selw = (int16_t)(sel == 0 ? 0x270f : sel == 1 ? 5 : -7);
                            int16_t flw = (int16_t)(fidx == 0 ? -1 : fidx == 1 ? 3 : -2);
                            int16_t subw = (int16_t)(sub == 0 ? 1 : sub == 1 ? 2 : -1);
                            int blocks = f9 ? 1 : fa ? 2 : 0;   /* 1: the block at 0x376, 2: the block at 0x32a */
                            size_t o = blocks == 1 ? 0x376 : 0x32a;
                            setup4(2, 0);
                            if (pos >= 0) ne9(0x2d9, 6, pos); else eq9(0x2d9, 6);
                            g4_self[0x229] = (uint8_t)(f9 ? 0x80 : 0);
                            g4_self[0x22a] = (uint8_t)(fa ? 1 : 0);
                            set16(g4_self, 0x1e, (uint16_t)(f9 ? 4 : IDX4));
                            /* (with neither flag set both blocks are armed: nothing may be loaded from either) */
                            set16(g_rec4, 0x376, (uint16_t)(blocks != 2 ? selw : 0x270f));
                            set16(g_rec4, 0x32a, (uint16_t)(blocks != 1 ? selw : 0x270f));
                            set16(g_rec4, 0x376 + 0x14, (uint16_t)subw);
                            set16(g_rec4, 0x32a + 0x14, (uint16_t)subw);
                            for (base = 0; base < 2; base++) {   /* both blocks hold recognisable values */
                                size_t b = base ? 0x32a : 0x376;
                                set16(g_rec4, b + 2, (uint16_t)(0x1100 + base));
                                set16(g_rec4, b + 4, (uint16_t)(0x2200 + base));
                                set16(g_rec4, b + 6, (uint16_t)(0x3300 + base));
                                set32(g_rec4, b + 8, 0x44000000u + (uint32_t)base);
                                set32(g_rec4, b + 0xc, 0x55000000u + (uint32_t)base);
                                set32(g_rec4, b + 0x10, 0x66000000u + (uint32_t)base);
                            }
                            set16(g_rec4, 0x38c, (uint16_t)(blocks != 2 ? flw : -1));
                            set16(g_rec4, 0x340, (uint16_t)(blocks != 1 ? flw : -1));
                            g_rec4[0x38e] = 0xa5;
                            g_rec4[0x342] = 0x5a;
                            snap4();
                            e4.value_5bb1ca = 1;
                            if (blocks != 0) {
                                if (selw != 0x270f) {
                                    e4.value_5bb57b = (uint32_t)(int32_t)selw;
                                    e4.word_5bb599 = get16(g_rec4, o + 2);
                                    e4.word_5bb595 = get16(g_rec4, o + 4);
                                    e4.word_5c39ff = get16(g_rec4, o + 6);
                                    e4.value_5bb59b = get32(g_rec4, o + 8);
                                    e4.value_5bb59f = get32(g_rec4, o + 0xc);
                                    e4.value_5bb5a3 = get32(g_rec4, o + 0x10);
                                    e4.value_5bb1ca = subw == 1 ? 0u : 1u;
                                    e4.value_583999 = 4;
                                }
                                if (flw != -1) set32(x_flags, 0x40 + (size_t)(flw * 4), blocks == 1 ? 0xa5u : 0x5au);
                            }
                            run4(IDX4);
                            CK(g_ret4 == 0);
                            nlog = 0;
                            if (pos >= 0) {
                                CK(is_call(nlog, 0x4fba69, 0x5c3a67, 1) && L.c[nlog].a[0] == RECVA4 + 0x2d9);
                                CK(P32(nlog, Q_1CA) == 1 && P32(nlog, Q_G) == 0x5557 && P32(nlog, Q_G + 16) == 0x5599);   /* 0x5bb1ca first; nothing loaded yet */
                                nlog++;
                            }
                            CK(is_call(nlog, 0x42ba3a, 0, 1) && (L.c[nlog].a[0] & 0xffff) == (f9 ? 4 : IDX4));
                            CK(P32(nlog, Q_1CA) == e4.value_5bb1ca && P32(nlog, Q_G) == e4.value_5bb57b && P32(nlog, Q_G + 16) == e4.value_583999);
                            CK(P16(nlog, Q_G + 20) == e4.word_5bb599 && P16(nlog, Q_G + 24) == e4.word_5c39ff);
                            CK(memcmp(L.c[nlog].probe + Q_FLAGS, x_flags, 0x100) == 0);   /* the flag entry is stored before the call */
                            nlog++;
                            CK(is_call(nlog, 0x4b5bc8, (uintptr_t)g4_self, 0));
                            nlog++;
                            CK(L.n == nlog);
                            CK(same4());
                        }
                    }
                }
            }
        }
    }
}

static void test_m4b64a9_run_scene(void)
{
    (void)m4b64a9_run_scene; /* driven through the file's runner helper; named here so the test pointer finds it */
    state0_4b64a9();
    step03_4b64a9();
    step2_4b64a9();
    step14_4b64a9();
    step4_4b64a9();
    divide_4b64a9();
    state2_4b64a9();
}

/* TESTS-END */

int main(void)
{
    int failures = 0;
    RUN(test_m42ed54_run_state);
    RUN(test_m47ff0e_handle_click);
    RUN(test_m4b64a9_run_scene);
    /* RUN-END */
    return failures;
}
