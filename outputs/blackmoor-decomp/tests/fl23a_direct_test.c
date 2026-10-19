/* FL-23 (batch a) direct tests of the hit-test handlers of GAME.EXE in src/original_methods_fl23a.c. Prints "PASS <name>" / "FAIL <name>: <msg>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values come from the disassembly of GAME.EXE, not
 * from running the native code; tests/test_fl23a_differential.py additionally runs the original bytes on random fixtures.
 */
#include "../src/original_methods_fl23a.h"

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

#define REC 0x8du
#define OBJVA 0x30000000u
#define OBJVA2 0x31000000u

static void set32(uint8_t *o, size_t off, uint32_t v) { memcpy(o + off, &v, 4); }
static void set16(uint8_t *o, size_t off, uint16_t v) { memcpy(o + off, &v, 2); }

static uint32_t get32(const uint8_t *o, size_t off)
{
    uint32_t v;
    memcpy(&v, o + off, 4);
    return v;
}

static uint16_t get16(const uint8_t *o, size_t off)
{
    uint16_t v;
    memcpy(&v, o + off, 2);
    return v;
}

/* ---- the call log of the host ------------------------------------------------------------------------------------------------ */

typedef struct Call {
    uint32_t callee;
    uintptr_t this_ptr;
    int n;
    uintptr_t a[12];
    uint8_t probe[64];   /* the state at the call (probe_ptr / probe_len, concatenated) */
} Call;

typedef struct Region {
    uint32_t va;
    uint8_t *ptr;
    uint32_t len;
} Region;

static struct {
    int n;
    Call c[512];
    uint32_t ret_value[32];   /* the queue of return values of every callee (the last one repeats) */
    int ret_count, ret_used;
    const uint8_t *probe_ptr[8];
    int probe_len[8], nprobe;
    Region regions[4];
    int nregions;
} L;

static void queue_return(uint32_t v) { L.ret_value[L.ret_count++] = v; }

static void add_probe(const void *p, int len)
{
    L.probe_ptr[L.nprobe] = (const uint8_t *)p;
    L.probe_len[L.nprobe++] = len;
}

static uint32_t h_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int k;
    (void)ctx;
    if (L.n < 512) {
        Call *c = &L.c[L.n];
        int at = 0;
        c->callee = callee;
        c->this_ptr = this_ptr;
        c->n = nargs;
        for (k = 0; k < nargs && k < 12; k++) c->a[k] = args[k];
        for (k = 0; k < L.nprobe; k++) {
            memcpy(c->probe + at, L.probe_ptr[k], (size_t)L.probe_len[k]);
            at += L.probe_len[k];
        }
    }
    L.n++;
    if (L.ret_count == 0) return 0;
    k = L.ret_used < L.ret_count ? L.ret_used : L.ret_count - 1;
    L.ret_used++;
    return L.ret_value[k];
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
    return 0;
}

static Fl18Host H = {NULL, h_call, h_resolve, h_tick};

static void add_region(uint32_t va, uint8_t *ptr, uint32_t len)
{
    L.regions[L.nregions].va = va;
    L.regions[L.nregions].ptr = ptr;
    L.regions[L.nregions].len = len;
    L.nregions++;
}

static int is_call(int k, uint32_t callee, uintptr_t this_ptr, int n)
{
    return k < L.n && k < 512 && L.c[k].callee == callee && L.c[k].this_ptr == this_ptr && L.c[k].n == n;
}

#define RUN(fn)                                  \
    do {                                         \
        g_failed = 0;                            \
        g_msg[0] = 0;                            \
        fn();                                    \
        if (g_failed) {                          \
            printf("FAIL %s: %s\n", #fn, g_msg); \
            failures++;                          \
        } else                                   \
            printf("PASS %s\n", #fn);            \
    } while (0)

/* ---- the fixture ------------------------------------------------------------------------------------------------------------- */

static uint8_t S[0x1700];       /* the self object */
static uint8_t O[0x1300];       /* the object of record idx */
static uint8_t O2[0x1300];      /* the object of every other record (all zero: a wrong record index reads this) */
static uint8_t R[6 * REC];      /* the record table */
static Fl23aWorld W;

/* a fresh fixture: record `idx` leads to O, the other records to O2 */
static void begin(int idx)
{
    int i;
    memset(S, 0, sizeof S);
    memset(O, 0, sizeof O);
    memset(O2, 0, sizeof O2);
    memset(&W, 0, sizeof W);
    memset(&L, 0, sizeof L);
    for (i = 0; i < 6; i++) set32(R, (size_t)i * REC, i == idx ? OBJVA : OBJVA2);
    W.records_5bb5e5 = R;
    add_region(OBJVA, O, sizeof O);
    add_region(OBJVA2, O2, sizeof O2);
}

static void clear_log(void)
{
    int i;
    Region keep[4];
    int n = L.nregions;
    for (i = 0; i < n; i++) keep[i] = L.regions[i];
    memset(&L, 0, sizeof L);
    for (i = 0; i < n; i++) L.regions[i] = keep[i];
    L.nregions = n;
}

/* the offsets of a rectangle: y low, y high, x low, x high */
typedef struct Offs {
    size_t ylo, yhi, xlo, xhi;
} Offs;

static void set_rect(uint8_t *o, size_t base, Offs f, int32_t ylo, int32_t yhi, int32_t xlo, int32_t xhi)
{
    set32(o, base + f.ylo, (uint32_t)ylo);
    set32(o, base + f.yhi, (uint32_t)yhi);
    set32(o, base + f.xlo, (uint32_t)xlo);
    set32(o, base + f.xhi, (uint32_t)xhi);
}

typedef int (*RunFn)(int16_t x, int16_t y);   /* 1 when the point was a hit of the rectangle under test */

/* the four edges of a rectangle (every edge hit, every neighbour outside), negative edges, the word limits, and a high edge that only a
 * sign-extended word misses; `run` must report a hit of exactly this rectangle */
static void edges(RunFn run, uint8_t *o, size_t base, Offs f)
{
    set_rect(o, base, f, -5, 7, -300, 40);
    CK(run(-300, -5) == 1);
    CK(run(40, 7) == 1);
    CK(run(-300, 7) == 1);
    CK(run(40, -5) == 1);
    CK(run(-301, 0) == 0);
    CK(run(41, 0) == 0);
    CK(run(0, -6) == 0);
    CK(run(0, 8) == 0);
    set_rect(o, base, f, -32768, 32767, -32768, 32767);
    CK(run(-32768, 32767) == 1);
    CK(run(32767, -32768) == 1);
    CK(run(-1, 1) == 1);
    /* edges above the word range: a zero-extended 0x8000 would fall inside */
    set_rect(o, base, f, 0x8000, 0x9000, 0x8000, 0x9000);
    CK(run(-32768, 0x7fff) == 0);
    CK(run(0x7fff, -32768) == 0);
    set_rect(o, base, f, -32768, -32768, -32768, -32768);
    CK(run(-32768, -32768) == 1);   /* inside only for the sign-extended words */
    CK(run(1, 1) == 0);
}

/* ---- 0x47d734 ---------------------------------------------------------------------------------------------------------------- */

static void test_m47d734_store_point(void)
{
    uint8_t before[0x80];
    int i;
    /* the byte at +0x57 off: nothing stored, 0 returned */
    begin(1);
    for (i = 0; i < 0x80; i++) S[i] = (uint8_t)(i * 3 + 1);
    S[0x57] = 0;
    memcpy(before, S, sizeof before);
    CK(m47d734_store_point(S, 5, 6) == 0);
    CK(memcmp(S, before, sizeof before) == 0);
    /* on (any non-zero byte, also 0x80): x to the word +0x25, y to the word +0x27, nothing else */
    S[0x57] = 0x80;
    memcpy(before, S, sizeof before);
    CK(m47d734_store_point(S, -2, 0x1234) == 0);
    set16(before, 0x25, 0xfffe);
    set16(before, 0x27, 0x1234);
    CK(memcmp(S, before, sizeof before) == 0);
    S[0x57] = 1;
    memcpy(before, S, sizeof before);
    CK(m47d734_store_point(S, -32768, 32767) == 0);
    set16(before, 0x25, 0x8000);
    set16(before, 0x27, 0x7fff);
    CK(memcmp(S, before, sizeof before) == 0);
    CK(L.n == 0);
}

/* ---- 0x4a1e16 ---------------------------------------------------------------------------------------------------------------- */

static const Offs R4A = {0x141, 0x149, 0x13d, 0x145};
static int run_4a1e16(int16_t x, int16_t y)
{
    int r;
    clear_log();
    r = m4a1e16_hit_test(S, x, y, &W, &H);
    CK(r == 0 || (L.n == 1 && is_call(0, 0x4a1e93, (uintptr_t)S, 1) && L.c[0].a[0] == 0x2760));
    CK(r != 0 || L.n == 0);
    return r;
}

static void test_m4a1e16_hit_test(void)
{
    uint8_t before[0x80];
    begin(0);
    set32(S, 0x60, 1);
    set32(S, 0x20, OBJVA);
    set32(S, 0x50, 2);
    set_rect(O, 0, R4A, 10, 20, 100, 200);
    memcpy(before, S, sizeof before);
    CK(run_4a1e16(100, 10) == 1);
    CK(run_4a1e16(200, 20) == 1);
    CK(run_4a1e16(99, 10) == 0);
    CK(run_4a1e16(201, 10) == 0);
    CK(run_4a1e16(100, 9) == 0);
    CK(run_4a1e16(100, 21) == 0);
    CK(memcmp(S, before, sizeof before) == 0);
    edges(run_4a1e16, O, 0, R4A);
    set_rect(O, 0, R4A, 10, 20, 100, 200);
    /* the gates: +0x60 is a dword (a set high byte counts), +0x50 must be exactly 2 */
    set32(S, 0x60, 0x01000000u);
    CK(run_4a1e16(150, 15) == 1);
    set32(S, 0x60, 0);
    CK(run_4a1e16(150, 15) == 0);
    set32(S, 0x60, 1);
    set32(S, 0x50, 1);
    CK(run_4a1e16(150, 15) == 0);
    set32(S, 0x50, 3);
    CK(run_4a1e16(150, 15) == 0);
    set32(S, 0x50, 0x100002u);
    CK(run_4a1e16(150, 15) == 0);
    set32(S, 0x50, 2);
    CK(run_4a1e16(150, 15) == 1);
}

/* ---- 0x4ba377 ---------------------------------------------------------------------------------------------------------------- */

static const Offs R4B = {0x7f0, 0x7f8, 0x7ec, 0x7f4};
static int g_slot;   /* the slot under test: 0 or 1 */
static int run_4ba377(int16_t x, int16_t y)
{
    int r;
    clear_log();
    r = m4ba377_hit_test(S, x, y, &W, &H);
    CK(r == 0 || (L.n == 1 && is_call(0, 0x4ba486, (uintptr_t)S, 1) && L.c[0].a[0] == (uintptr_t)g_slot));
    return r;
}

static void test_m4ba377_hit_test(void)
{
    begin(0);
    set32(S, 0x18, OBJVA);
    set32(S, 0x34, 1);
    set32(S, 0x2d4, 0x11111111u);
    set32(S, 0x310, 0x22222222u);
    /* the gate (a dword): off, nothing is touched */
    set32(S, 0x34, 0);
    set_rect(O, 0, R4B, 0, 10, 0, 10);
    CK(m4ba377_hit_test(S, 5, 5, &W, &H) == 0);
    CK(L.n == 0 && get32(S, 0x2d4) == 0x11111111u && get32(S, 0x310) == 0x22222222u);
    /* slot 0 hit: -1 stored to +0x2d4 and the counter 0 in +0x310 BEFORE the call, one call with the counter as a word */
    set32(S, 0x34, 0x01000000u);
    add_probe(S + 0x2d4, 4);
    add_probe(S + 0x310, 4);
    CK(m4ba377_hit_test(S, 5, 5, &W, &H) == 1);
    CK(L.n == 1 && is_call(0, 0x4ba486, (uintptr_t)S, 1) && L.c[0].a[0] == 0);
    CK(get32(L.c[0].probe, 0) == 0xffffffffu && get32(L.c[0].probe, 4) == 0);
    CK(get32(S, 0x2d4) == 0xffffffffu && get32(S, 0x310) == 0);
    /* slot 0 disabled by a dword flag (also when only its high byte is set): slot 1 */
    clear_log();
    set32(S, 0x24, 0x01000000u);
    set_rect(O, 16, R4B, 0, 10, 0, 10);
    CK(m4ba377_hit_test(S, 5, 5, &W, &H) == 1);
    CK(L.n == 1 && L.c[0].a[0] == 1 && get32(S, 0x310) == 1);
    /* both disabled: no call, counter left at 2, 0 returned */
    clear_log();
    set32(S, 0x2c, 7);
    CK(m4ba377_hit_test(S, 5, 5, &W, &H) == 0);
    CK(L.n == 0 && get32(S, 0x310) == 2 && get32(S, 0x2d4) == 0xffffffffu);
    /* slot 0 enabled and out, slot 1 enabled and in */
    set32(S, 0x24, 0);
    set_rect(O, 0, R4B, 100, 110, 100, 110);
    clear_log();
    CK(m4ba377_hit_test(S, 5, 5, &W, &H) == 0);   /* slot 1 still disabled */
    set32(S, 0x2c, 0);
    CK(m4ba377_hit_test(S, 5, 5, &W, &H) == 1);
    CK(is_call(0, 0x4ba486, (uintptr_t)S, 1) && L.c[0].a[0] == 1);
    /* both in: the first wins, one call */
    set_rect(O, 0, R4B, 0, 10, 0, 10);
    clear_log();
    CK(m4ba377_hit_test(S, 5, 5, &W, &H) == 1);
    CK(L.n == 1 && L.c[0].a[0] == 0);
    /* the edges of both slots (the other slot is disabled) */
    g_slot = 0;
    set32(S, 0x24, 0);
    set32(S, 0x2c, 1);
    edges(run_4ba377, O, 0, R4B);
    g_slot = 1;
    set32(S, 0x24, 1);
    set32(S, 0x2c, 0);
    edges(run_4ba377, O, 16, R4B);
}

/* ---- 0x459cc9 ---------------------------------------------------------------------------------------------------------------- */

static const Offs R45 = {0x65, 0x6d, 0x61, 0x69};
static int g_item;
static int run_459cc9(int16_t x, int16_t y)
{
    int r;
    clear_log();
    r = m459cc9_hit_test(S, x, y, &W, &H);
    CK(r == 0 || (L.n == 1 && is_call(0, 0x459ddc, (uintptr_t)S, 1) && L.c[0].a[0] == (uintptr_t)g_item));
    return r;
}

static void test_m459cc9_hit_test(void)
{
    int i;
    begin(2);
    set16(S, 0x1c, 2);
    set16(S, 0xcc, 0x1234);
    S[0xd6] = 0;
    set_rect(O, 32, R45, 0, 10, 0, 10);
    /* the gate byte off: 0, and the word +0xcc is not stored */
    CK(m459cc9_hit_test(S, 5, 5, &W, &H) == 0);
    CK(L.n == 0 && get16(S, 0xcc) == 0x1234);
    S[0xd7] = 1;   /* the gate is the byte +0xd6 alone */
    CK(m459cc9_hit_test(S, 5, 5, &W, &H) == 0 && L.n == 0 && get16(S, 0xcc) == 0x1234);
    S[0xd7] = 0;
    /* on (bit 7 only): the word +0xcc is set to 0xffff BEFORE the call; item 2 hit (the record is selected by the word +0x1c, stride 0x8d) */
    S[0xd6] = 0x80;
    add_probe(S + 0xcc, 2);
    CK(m459cc9_hit_test(S, 5, 5, &W, &H) == 1);
    CK(L.n == 1 && is_call(0, 0x459ddc, (uintptr_t)S, 1) && L.c[0].a[0] == 2 && get16(L.c[0].probe, 0) == 0xffff);
    CK(get16(S, 0xcc) == 0xffff);
    /* a miss still sets the word */
    set16(S, 0xcc, 0x1234);
    clear_log();
    CK(m459cc9_hit_test(S, 50, 50, &W, &H) == 0);
    CK(L.n == 0 && get16(S, 0xcc) == 0xffff);
    /* another record index reads the empty object */
    set16(S, 0x1c, 3);
    CK(m459cc9_hit_test(S, 5, 5, &W, &H) == 0);
    set16(S, 0x1c, 2);
    /* a disabled item (byte S[0x1e+i]) returns 0 at once: a later enabled item is not tried */
    set_rect(O, 0, R45, 0, 10, 0, 10);
    S[0x1e] = 0x80;
    clear_log();
    CK(m459cc9_hit_test(S, 5, 5, &W, &H) == 0 && L.n == 0);
    S[0x1e] = 0;
    CK(m459cc9_hit_test(S, 5, 5, &W, &H) == 1 && L.c[0].a[0] == 0);
    /* every item, with the others out */
    for (i = 0; i < 4; i++) {
        int j;
        for (j = 0; j < 4; j++) set_rect(O, (size_t)j * 16, R45, 100, 110, 100, 110);
        set_rect(O, (size_t)i * 16, R45, 0, 10, 0, 10);
        g_item = i;
        CK(run_459cc9(5, 5) == 1);
    }
    for (i = 0; i < 4; i++) {
        int j;
        for (j = 0; j < 4; j++) set_rect(O, (size_t)j * 16, R45, 100, 110, 100, 110);
        g_item = i;
        edges(run_459cc9, O, (size_t)i * 16, R45);
    }
    /* item 4 is not visited */
    for (i = 0; i < 4; i++) set_rect(O, (size_t)i * 16, R45, 100, 110, 100, 110);
    set_rect(O, 64, R45, 0, 10, 0, 10);
    CK(m459cc9_hit_test(S, 5, 5, &W, &H) == 0);
}

/* ---- 0x487c92 ---------------------------------------------------------------------------------------------------------------- */

static const Offs R48 = {0x329, 0x331, 0x325, 0x32d};
static const Offs R48P = {0x5a7, 0x5af, 0x5a3, 0x5ab};
static int g_expect_event, g_expect_arg;
static int run_487c92(int16_t x, int16_t y)
{
    int r;
    clear_log();
    r = m487c92_hit_test(S, x, y, &W, &H);
    CK(r == 0 || (L.n == 1 && is_call(0, 0x487dcf, (uintptr_t)S, 2) && L.c[0].a[0] == (uintptr_t)g_expect_event &&
                  (uint16_t)L.c[0].a[1] == (uint16_t)g_expect_arg));
    return r;
}

static void test_m487c92_hit_test(void)
{
    int i;
    begin(1);
    set16(S, 0x1e, 1);
    set32(S, 0x71, 1);
    S[0x65] = 0;
    S[0x24] = 0x55;
    set_rect(O, 0, R48P, 10, 20, 30, 40);
    set16(O, 0x21, 3);
    /* the gate: a dword */
    set32(S, 0x71, 0);
    CK(m487c92_hit_test(S, 35, 15, &W, &H) == 0 && L.n == 0);
    set32(S, 0x71, 0x80000000u);
    /* the pre-rectangle with the byte +0x65 clear: event 0x2789 with 0 */
    CK(m487c92_hit_test(S, 35, 15, &W, &H) == 1);
    CK(L.n == 1 && is_call(0, 0x487dcf, (uintptr_t)S, 2) && L.c[0].a[0] == 0x2789 && L.c[0].a[1] == 0 && S[0x24] == 0x55);
    /* the byte set: the pre-rectangle is skipped; item 1 in (count 3): event 0x2788 with 1, and +0x24 = 1 AFTER the call */
    S[0x65] = 0x80;
    set_rect(O, 16, R48, 10, 20, 30, 40);
    clear_log();
    add_probe(S + 0x24, 1);
    CK(m487c92_hit_test(S, 35, 15, &W, &H) == 1);
    CK(L.n == 1 && is_call(0, 0x487dcf, (uintptr_t)S, 2) && L.c[0].a[0] == 0x2788 && L.c[0].a[1] == 1);
    CK(L.c[0].probe[0] == 0x55 && S[0x24] == 1);
    /* the count is a signed word: -1 and 0 run no item; item 3 is not visited with count 3; item 2 is */
    S[0x24] = 0x55;
    set16(O, 0x21, 0xffff);
    clear_log();
    CK(m487c92_hit_test(S, 35, 15, &W, &H) == 0 && L.n == 0 && S[0x24] == 0x55);
    set16(O, 0x21, 0);
    CK(m487c92_hit_test(S, 35, 15, &W, &H) == 0 && L.n == 0);
    set16(O, 0x21, 3);
    set_rect(O, 16, R48, 100, 110, 100, 110);
    set_rect(O, 48, R48, 10, 20, 30, 40);
    CK(m487c92_hit_test(S, 35, 15, &W, &H) == 0 && L.n == 0 && S[0x24] == 0x55);
    set_rect(O, 32, R48, 10, 20, 30, 40);
    CK(m487c92_hit_test(S, 35, 15, &W, &H) == 1 && L.c[0].a[1] == 2 && S[0x24] == 1);
    /* the edges of the pre-rectangle (byte clear) and of items 0 and 3 (count 4, byte set) */
    memset(O, 0, 0x700);
    set16(O, 0x21, 4);
    S[0x65] = 0;
    g_expect_event = 0x2789;
    g_expect_arg = 0;
    edges(run_487c92, O, 0, R48P);
    memset(O, 0, 0x700);
    set16(O, 0x21, 4);
    S[0x65] = 1;
    g_expect_event = 0x2788;
    for (i = 0; i < 4; i++) {
        g_expect_arg = i;
        edges(run_487c92, O, (size_t)i * 16, R48);
        memset(O, 0, 0x700);
        set16(O, 0x21, 4);
    }
}

/* ---- 0x48a920 ---------------------------------------------------------------------------------------------------------------- */

static const Offs R48A = {0x168, 0x170, 0x164, 0x16c};
static const Offs R48AF = {0x40f, 0x417, 0x40b, 0x413};
static int run_48a920(int16_t x, int16_t y)
{
    int r;
    clear_log();
    r = m48a920_hit_test(S, x, y, &W, &H);
    CK(r == 0 || (L.n == 1 && is_call(0, 0x48aa66, (uintptr_t)S, 2) && L.c[0].a[0] == (uintptr_t)g_expect_event &&
                  (uint16_t)L.c[0].a[1] == (uint16_t)g_expect_arg));
    return r;
}

static void test_m48a920_hit_test(void)
{
    int i;
    begin(1);
    set16(S, 0x1e, 1);
    set32(S, 0x1aa, 1);
    set16(S, 0x1b0, 0x1234);
    O[0x21] = 3;
    set_rect(O, 32, R48A, 10, 20, 30, 40);
    /* the gate: off, and the word +0x1b0 is untouched */
    set32(S, 0x1aa, 0);
    CK(m48a920_hit_test(S, 35, 15, &W, &H) == 0 && L.n == 0 && get16(S, 0x1b0) == 0x1234);
    /* on (a dword with only its high byte): +0x1b0 = 0xffff BEFORE the call, item 2: event 0x2756 with 2 */
    set32(S, 0x1aa, 0x01000000u);
    add_probe(S + 0x1b0, 2);
    CK(m48a920_hit_test(S, 35, 15, &W, &H) == 1);
    CK(L.n == 1 && is_call(0, 0x48aa66, (uintptr_t)S, 2) && L.c[0].a[0] == 0x2756 && L.c[0].a[1] == 2 && get16(L.c[0].probe, 0) == 0xffff);
    /* a miss sets the word too */
    set16(S, 0x1b0, 0x1234);
    clear_log();
    CK(m48a920_hit_test(S, 1, 1, &W, &H) == 0 && L.n == 0 && get16(S, 0x1b0) == 0xffff);
    /* item 2 disabled by its byte S[0x24+2]: the final rectangle; and by the dword +0x44 */
    S[0x26] = 0x80;
    set_rect(O, 0, R48AF, 10, 20, 30, 40);
    clear_log();
    CK(m48a920_hit_test(S, 35, 15, &W, &H) == 1);
    CK(L.n == 1 && L.c[0].a[0] == 0x2757 && L.c[0].a[1] == 0);
    S[0x26] = 0;
    set32(S, 0x44, 0x00010000u);
    clear_log();
    CK(m48a920_hit_test(S, 35, 15, &W, &H) == 1 && L.c[0].a[0] == 0x2757);
    set32(S, 0x44, 0);
    /* item 0 disabled, item 1 in and enabled: event 0x2756 with 1 */
    set_rect(O, 0, R48A, 10, 20, 30, 40);
    S[0x24] = 1;
    set_rect(O, 16, R48A, 10, 20, 30, 40);
    clear_log();
    CK(m48a920_hit_test(S, 35, 15, &W, &H) == 1 && L.c[0].a[0] == 0x2756 && L.c[0].a[1] == 1);
    /* the count is an unsigned byte: 0x80 items are visited and item 0x7f hits (a signed byte would run none) */
    memset(S + 0x24, 0, 0x20);
    memset(O, 0, 0x1200);
    O[0x21] = 0x80;
    set_rect(O, 0x7f * 16, R48A, 10, 20, 30, 40);
    clear_log();
    CK(m48a920_hit_test(S, 35, 15, &W, &H) == 1 && L.c[0].a[0] == 0x2756 && L.c[0].a[1] == 0x7f);
    /* count 0: only the final rectangle */
    memset(O, 0, 0x1200);
    set_rect(O, 0, R48A, 10, 20, 30, 40);
    clear_log();
    CK(m48a920_hit_test(S, 35, 15, &W, &H) == 0 && L.n == 0);
    /* the edges of items 0 and 3 and of the final rectangle */
    O[0x21] = 4;
    g_expect_event = 0x2756;
    for (i = 0; i < 4; i++) {
        g_expect_arg = i;
        edges(run_48a920, O, (size_t)i * 16, R48A);
        memset(O, 0, 0x1200);
        O[0x21] = 4;
    }
    g_expect_event = 0x2757;
    g_expect_arg = 0;
    edges(run_48a920, O, 0, R48AF);
}

/* ---- 0x48e628 ---------------------------------------------------------------------------------------------------------------- */

static const Offs R48E = {0xb6, 0xbe, 0xb2, 0xba};
static const Offs R48EP = {0x9e, 0xa6, 0x9a, 0xa2};
static int run_48e628(int16_t x, int16_t y)
{
    int r;
    clear_log();
    r = m48e628_hit_test(S, x, y, &W, &H);
    CK(r == 0 || (L.n == 1 && is_call(0, 0x48e776, (uintptr_t)S, 2) && L.c[0].a[0] == (uintptr_t)g_expect_event &&
                  (uint16_t)L.c[0].a[1] == (uint16_t)g_expect_arg));
    return r;
}

static void test_m48e628_hit_test(void)
{
    int i;
    begin(1);
    set16(S, 0x1e, 1);
    set32(S, 0x462, 1);
    set16(S, 0x3fe, 5);
    set16(O, 0xb0, 3);
    set_rect(O, 0, R48EP, 10, 20, 30, 40);
    /* the gate (a dword) off: 0 even inside the pre-rectangle */
    set32(S, 0x462, 0);
    CK(m48e628_hit_test(S, 35, 15, &W, &H) == 0 && L.n == 0);
    set32(S, 0x462, 0x00800000u);
    /* the pre-rectangle: event 0x27b9 with 0 */
    CK(m48e628_hit_test(S, 35, 15, &W, &H) == 1);
    CK(L.n == 1 && is_call(0, 0x48e776, (uintptr_t)S, 2) && L.c[0].a[0] == 0x27b9 && L.c[0].a[1] == 0);
    /* item 2 (stride 0xd0): event 0x27b8 with 2 */
    set_rect(O, 0, R48EP, 100, 110, 100, 110);
    set_rect(O, 2 * 0xd0, R48E, 10, 20, 30, 40);
    clear_log();
    CK(m48e628_hit_test(S, 35, 15, &W, &H) == 1 && is_call(0, 0x48e776, (uintptr_t)S, 2) && L.c[0].a[0] == 0x27b8 && L.c[0].a[1] == 2);
    /* the selected item (the word +0x3fe, sign-extended, equal to the index) is skipped; 0x8002 is -32766, not 2 */
    set16(S, 0x3fe, 2);
    clear_log();
    CK(m48e628_hit_test(S, 35, 15, &W, &H) == 0 && L.n == 0);
    set16(S, 0x3fe, 0x8002);
    CK(m48e628_hit_test(S, 35, 15, &W, &H) == 1 && L.c[0].a[1] == 2);
    set16(S, 0x3fe, 0xffff);
    CK(m48e628_hit_test(S, 35, 15, &W, &H) == 1);
    /* the count is a signed word: -1 and 0 run no item; 2 does not reach item 2 */
    set16(O, 0xb0, 0xffff);
    clear_log();
    CK(m48e628_hit_test(S, 35, 15, &W, &H) == 0 && L.n == 0);
    set16(O, 0xb0, 0);
    CK(m48e628_hit_test(S, 35, 15, &W, &H) == 0 && L.n == 0);
    set16(O, 0xb0, 2);
    CK(m48e628_hit_test(S, 35, 15, &W, &H) == 0 && L.n == 0);
    /* the edges of the pre-rectangle and of items 0, 1 and 3 (the selected item is 5) */
    memset(O, 0, 0x500);
    set16(O, 0xb0, 4);
    set16(S, 0x3fe, 5);
    g_expect_event = 0x27b9;
    g_expect_arg = 0;
    edges(run_48e628, O, 0, R48EP);
    for (i = 0; i < 4; i++) {
        memset(O, 0, 0x500);
        set16(O, 0xb0, 4);
        g_expect_event = 0x27b8;
        g_expect_arg = i;
        edges(run_48e628, O, (size_t)i * 0xd0, R48E);
    }
}

/* ---- 0x479deb ---------------------------------------------------------------------------------------------------------------- */

static const Offs R479 = {0x174, 0x17c, 0x170, 0x178};
static const Offs R479F = {0x28f, 0x297, 0x28b, 0x293};

static void test_m479deb_hit_test(void)
{
    begin(1);
    set16(S, 0x1e, 1);
    set32(S, 0x157a, 1);
    set32(S, 0x24, 3);
    set32(S, 0x1528, 0);
    set16(S, 0x158e, 0x1111);
    set16(S, 0x1590, 0x2222);
    /* every item rectangle is shrunk by 10: [0,100] x [0,100] accepts 10..90 */
    set_rect(O, 16, R479, 0, 100, 0, 100);
    /* the three gates */
    set32(S, 0x157a, 0);
    CK(m479deb_hit_test(S, 50, 50, &W, &H) == 0 && L.n == 0);
    set32(S, 0x157a, 0x100);
    set32(S, 0x24, 2);
    CK(m479deb_hit_test(S, 50, 50, &W, &H) == 0 && L.n == 0);
    set32(S, 0x24, 0x80000002u);
    queue_return(1);
    CK(m479deb_hit_test(S, 50, 50, &W, &H) == 1);   /* only exactly 2 blocks */
    clear_log();
    set32(S, 0x24, 3);
    set32(S, 0x1528, 0x10000);
    CK(m479deb_hit_test(S, 50, 50, &W, &H) == 0 && L.n == 0);
    set32(S, 0x1528, 0);
    /* item 1 accepted by 0x478396 (== 1): its three arguments (index + 1, the words +0x158e and +0x1590), then 0x479f72 with 0x279c and the index + 1 */
    queue_return(1);
    CK(m479deb_hit_test(S, 50, 50, &W, &H) == 1);
    CK(L.n == 2 && is_call(0, 0x478396, (uintptr_t)S, 3) && L.c[0].a[0] == 2 && (uint16_t)L.c[0].a[1] == 0x1111 && (uint16_t)L.c[0].a[2] == 0x2222);
    CK(is_call(1, 0x479f72, (uintptr_t)S, 2) && L.c[1].a[0] == 0x279c && L.c[1].a[1] == 2);
    /* the shrunk edges: 10 and 90 hit, 9 and 91 miss (on each axis) */
    clear_log();
    queue_return(1);
    CK(m479deb_hit_test(S, 10, 10, &W, &H) == 1);
    clear_log();
    queue_return(1);
    CK(m479deb_hit_test(S, 90, 90, &W, &H) == 1);
    clear_log();
    CK(m479deb_hit_test(S, 9, 50, &W, &H) == 0 && L.n == 0);
    CK(m479deb_hit_test(S, 91, 50, &W, &H) == 0 && L.n == 0);
    CK(m479deb_hit_test(S, 50, 9, &W, &H) == 0 && L.n == 0);
    CK(m479deb_hit_test(S, 50, 91, &W, &H) == 0 && L.n == 0);
    /* the +10 and -10 wrap around in 32 bits: low edge 0x7ffffffa becomes negative, high edge 0x80000000 becomes positive */
    set_rect(O, 16, R479, 0x7ffffffa, (int32_t)0x80000000u, 0x7ffffffa, (int32_t)0x80000000u);
    clear_log();
    queue_return(1);
    CK(m479deb_hit_test(S, 0, 0, &W, &H) == 1 && L.n == 2);
    set_rect(O, 16, R479, 0, 100, 0, 100);
    /* a result other than exactly 1 goes on with the next item: item 1 returns 2, item 3 returns 0xffffffff, item 4 returns 1 */
    set_rect(O, 48, R479, 0, 100, 0, 100);
    set_rect(O, 64, R479, 0, 100, 0, 100);
    clear_log();
    queue_return(2);
    queue_return(0xffffffffu);
    queue_return(1);
    CK(m479deb_hit_test(S, 50, 50, &W, &H) == 1);
    CK(L.n == 4 && L.c[0].a[0] == 2 && L.c[1].a[0] == 4 && L.c[2].a[0] == 5 && L.c[0].callee == 0x478396 && L.c[2].callee == 0x478396);
    CK(L.c[3].callee == 0x479f72 && L.c[3].a[0] == 0x279c && L.c[3].a[1] == 5);
    /* all refused (0, 2, 0x80000001 ...) and no final rectangle: three calls, 0 */
    clear_log();
    queue_return(0);
    queue_return(0x80000001u);
    CK(m479deb_hit_test(S, 50, 50, &W, &H) == 0);
    CK(L.n == 3 && L.c[0].callee == 0x478396 && L.c[1].callee == 0x478396 && L.c[2].callee == 0x478396);
    /* the final rectangle (event 0x279d with 0), with every item rectangle away from the point */
    memset(O, 0, 0x400);
    set_rect(O, 0, R479F, 200, 300, 200, 300);
    clear_log();
    CK(m479deb_hit_test(S, 250, 250, &W, &H) == 1);
    CK(L.n == 1 && is_call(0, 0x479f72, (uintptr_t)S, 2) && L.c[0].a[0] == 0x279d && L.c[0].a[1] == 0);
    CK(m479deb_hit_test(S, 199, 250, &W, &H) == 0);
    CK(m479deb_hit_test(S, 301, 250, &W, &H) == 0);
    CK(m479deb_hit_test(S, 250, 199, &W, &H) == 0);
    CK(m479deb_hit_test(S, 250, 301, &W, &H) == 0);
    CK(m479deb_hit_test(S, 200, 300, &W, &H) == 1 && m479deb_hit_test(S, 300, 200, &W, &H) == 1);
}

/* ---- 0x46ea16 ---------------------------------------------------------------------------------------------------------------- */

static void test_m46ea16_hit_test(void)
{
    uint8_t before[0x80];
    int i;
    begin(1);
    set16(S, 0x1e, 1);
    set32(S, 0x46, 1);
    set32(S, 0x5f, 0);
    set32(S, 0x24, 0x77777777u);
    S[0x52] = 0x99;
    W.value_5c39e5 = 0x1c39e5;
    W.value_5d0377 = 0xcafe;
    W.value_5d162d = 0x162d;
    W.value_5b44f0 = 0x44f0;
    W.value_5b44f4 = 0x44f4;
    W.value_5d1631 = 0x1631;
    W.value_5d1639 = 0x1639;
    for (i = 0; i < 16; i++) O[0xf23 + i] = (uint8_t)(0x30 + i);       /* the structure at object + 0xf23 */
    for (i = 0; i < 16 * 16; i++) O[0x23c + i] = (uint8_t)(0xa0 + i);   /* the sixteen entries at object + 0x23c */
    memcpy(before, S, sizeof before);
    /* the gates: +0x46 clear, +0x5f set (a dword): nothing happens */
    set32(S, 0x46, 0);
    CK(m46ea16_hit_test(S, 1, 2, &W, &H) == 0 && L.n == 0 && W.value_5c39e5 == 0x1c39e5);
    set32(S, 0x46, 1);
    set32(S, 0x5f, 0x01000000u);
    CK(m46ea16_hit_test(S, 1, 2, &W, &H) == 0 && L.n == 0 && W.value_5d1639 == 0x1639);
    set32(S, 0x5f, 0);
    /* the first call (the structure at object + 0xf23 by value; x and y sign-extended) accepts: the globals, no write to +0x24 */
    queue_return(0x80000000u);
    add_probe(&W.value_5c39e5, 4);
    add_probe(S + 0x24, 4);
    CK(m46ea16_hit_test(S, -2, 0x7fff, &W, &H) == 1);
    CK(L.n == 1 && is_call(0, 0x46ebbd, (uintptr_t)S, 6));
    CK(L.c[0].a[0] == 0xfffffffeu && L.c[0].a[1] == 0x7fff);
    CK(L.c[0].a[2] == 0x33323130u && L.c[0].a[3] == 0x37363534u && L.c[0].a[4] == 0x3b3a3938u && L.c[0].a[5] == 0x3f3e3d3cu);
    CK(get32(L.c[0].probe, 0) == 0x1c39e5 && get32(L.c[0].probe, 4) == 0x77777777u);
    CK(W.value_5c39e5 == 0x27c3 && W.value_5b44f0 == 9 && W.value_5b44f4 == 1 && W.value_5d162d == 0xcafe && W.value_5d1639 == 1);
    CK(W.value_5d1631 == 0x5b160cu + (9u << 5) + (1u << 4));
    CK(get32(S, 0x24) == 0x77777777u && S[0x52] == 0x99);
    /* the first call refuses, entry 2 accepts: +0x24 = object address + 0x23c (stored before the entry calls), four calls with the entries of 16 bytes */
    memset(&L, 0, sizeof L);
    add_region(OBJVA, O, sizeof O);
    add_region(OBJVA2, O2, sizeof O2);
    queue_return(0);
    queue_return(0);
    queue_return(0);
    queue_return(0x100);
    add_probe(&W.value_5c39e5, 4);
    add_probe(S + 0x24, 4);
    add_probe(S + 0x52, 1);
    W.value_5c39e5 = 0x1c39e5;
    CK(m46ea16_hit_test(S, 3, 4, &W, &H) == 1);
    CK(L.n == 4 && is_call(0, 0x46ebbd, (uintptr_t)S, 6) && is_call(3, 0x46ebbd, (uintptr_t)S, 6));
    CK(L.c[1].a[2] == 0xa3a2a1a0u && L.c[2].a[2] == 0xb3b2b1b0u && L.c[3].a[2] == 0xc3c2c1c0u && L.c[3].a[5] == 0xcfcecdccu);
    CK(L.c[1].a[0] == 3 && L.c[1].a[1] == 4);
    CK(get32(L.c[1].probe, 4) == OBJVA + 0x23c && get32(L.c[1].probe, 0) == 0x1c39e5 && L.c[1].probe[8] == 0x99);
    CK(get32(S, 0x24) == OBJVA + 0x23c && S[0x52] == 2);
    CK(W.value_5b44f0 == 0x16 && W.value_5b44f4 == 1 && W.value_5d162d == 0xcafe && W.value_5d1639 == 1 && W.value_5c39e5 == 0x27c2);
    CK(W.value_5d1631 == 0x5b160cu + (0x16u << 5) + (1u << 4));
    /* the last entry (15) accepts: the byte +0x52 */
    memset(&L, 0, sizeof L);
    add_region(OBJVA, O, sizeof O);
    for (i = 0; i < 16; i++) queue_return(0);
    queue_return(5);
    CK(m46ea16_hit_test(S, 3, 4, &W, &H) == 1 && L.n == 17 && S[0x52] == 15);
    /* every call refuses: 17 calls, 0, +0x24 stored, the byte and the globals untouched */
    memset(&L, 0, sizeof L);
    add_region(OBJVA, O, sizeof O);
    S[0x52] = 0x99;
    W.value_5c39e5 = 0x1c39e5;
    CK(m46ea16_hit_test(S, 3, 4, &W, &H) == 0 && L.n == 17 && S[0x52] == 0x99 && W.value_5c39e5 == 0x1c39e5 && get32(S, 0x24) == OBJVA + 0x23c);
}

/* ---- 0x4b7389 ---------------------------------------------------------------------------------------------------------------- */

static const Offs RA = {0x3ba, 0x3c2, 0x3b6, 0x3be};
static const Offs RB = {0x2f, 0x37, 0x2b, 0x33};
static const Offs RC = {0x3f, 0x47, 0x3b, 0x43};
static uint32_t g_want;
static int run_4b7389(int16_t x, int16_t y)
{
    W.value_5c39e5 = 0;
    return m4b7389_hit_test(S, x, y, &W, &H) == 1 && W.value_5c39e5 == g_want;
}

static void test_m4b7389_hit_test(void)
{
    begin(2);
    set16(S, 0x21, 2);    /* the record index is the word at +0x21 */
    set16(S, 0x1e, 4);
    S[0x35] = 0;
    W.value_5b44f0 = 0xaaaa;
    W.value_5b44f4 = 0xbbbb;
    W.value_5d0377 = 0xcafe;
    W.value_5c39e5 = 0x39e5;
    W.value_5d162d = 0x162d;
    W.value_5d1631 = 0x1631;
    W.value_5d1639 = 0x1639;
    set_rect(O, 0, RA, 10, 20, 30, 40);
    /* the gate byte clear: 0, no store */
    CK(m4b7389_hit_test(S, 35, 15, &W, &H) == 0 && W.value_5c39e5 == 0x39e5 && W.value_5d1639 == 0x1639 && W.value_5b44f0 == 0xaaaa);
    S[0x35] = 0x80;
    /* rectangle A (all three in range, A wins and returns at once): 9 / 1, event 0x27c1 */
    set_rect(O, 0, RB, 10, 20, 30, 40);
    set_rect(O, 0, RC, 10, 20, 30, 40);
    O[0x25] = 1;
    CK(m4b7389_hit_test(S, 35, 15, &W, &H) == 1);
    CK(W.value_5b44f0 == 9 && W.value_5b44f4 == 1 && W.value_5d162d == 0xcafe && W.value_5d1639 == 1 && W.value_5c39e5 == 0x27c1);
    CK(W.value_5d1631 == 0x5b160cu + (9u << 5) + (1u << 4));
    CK(L.n == 0);
    /* B only: row 0x14 when the byte at object + 0x25 is set, 0x15 when clear; event 0x27bf; the tail uses the new row */
    set_rect(O, 0, RA, 100, 110, 100, 110);
    set_rect(O, 0, RC, 100, 110, 100, 110);
    W.value_5b44f0 = 0xaaaa;
    W.value_5b44f4 = 0xbbbb;
    CK(m4b7389_hit_test(S, 35, 15, &W, &H) == 1);
    CK(W.value_5b44f0 == 0x14 && W.value_5b44f4 == 1 && W.value_5c39e5 == 0x27bf && W.value_5d1639 == 1);
    CK(W.value_5d1631 == 0x5b160cu + (0x14u << 5) + (1u << 4));
    O[0x25] = 0;
    CK(m4b7389_hit_test(S, 35, 15, &W, &H) == 1 && W.value_5b44f0 == 0x15 && W.value_5c39e5 == 0x27bf);
    CK(W.value_5d1631 == 0x5b160cu + (0x15u << 5) + (1u << 4));
    /* C only: event 0x27c0 */
    set_rect(O, 0, RB, 100, 110, 100, 110);
    set_rect(O, 0, RC, 10, 20, 30, 40);
    O[0x25] = 0x40;
    CK(m4b7389_hit_test(S, 35, 15, &W, &H) == 1 && W.value_5b44f0 == 0x14 && W.value_5b44f4 == 1 && W.value_5c39e5 == 0x27c0);
    /* B and C: the second one's event stays */
    set_rect(O, 0, RB, 10, 20, 30, 40);
    CK(m4b7389_hit_test(S, 35, 15, &W, &H) == 1 && W.value_5c39e5 == 0x27c0);
    /* none: still 1, the tail only (0x5d162d, 0x5d1631 from the current row and column, 0x5d1639); event and row untouched */
    set_rect(O, 0, RB, 100, 110, 100, 110);
    set_rect(O, 0, RC, 100, 110, 100, 110);
    W.value_5b44f0 = 0xaaaa;
    W.value_5b44f4 = 0xbbbb;
    W.value_5c39e5 = 0x39e5;
    W.value_5d1639 = 0x1639;
    CK(m4b7389_hit_test(S, 35, 15, &W, &H) == 1);
    CK(W.value_5b44f0 == 0xaaaa && W.value_5b44f4 == 0xbbbb && W.value_5c39e5 == 0x39e5 && W.value_5d162d == 0xcafe && W.value_5d1639 == 1);
    CK(W.value_5d1631 == 0x5b160cu + (0xaaaau << 5) + (0xbbbbu << 4));
    /* the edges of the three rectangles (judged by the event they set) */
    memset(O, 0, 0x400);
    g_want = 0x27c1;
    edges(run_4b7389, O, 0, RA);
    memset(O, 0, 0x400);
    g_want = 0x27bf;
    edges(run_4b7389, O, 0, RB);
    memset(O, 0, 0x400);
    g_want = 0x27c0;
    edges(run_4b7389, O, 0, RC);
}

/* ---- 0x4ab528 ---------------------------------------------------------------------------------------------------------------- */

static const Offs R4A1 = {0xa3, 0xab, 0x9f, 0xa7};
static const Offs R4A2 = {0x1c3, 0x1cb, 0x1bf, 0x1c7};
static const Offs R4AF = {0xbb3, 0xbbb, 0xbaf, 0xbb7};
static int run_4ab528(int16_t x, int16_t y)
{
    int r;
    clear_log();
    r = m4ab528_hit_test(S, x, y, &W, &H);
    CK(r == 0 || (L.n == 1 && is_call(0, 0x4ab706, (uintptr_t)S, 2) && L.c[0].a[0] == (uintptr_t)g_expect_event &&
                  (uint16_t)L.c[0].a[1] == (uint16_t)g_expect_arg));
    return r;
}

static void test_m4ab528_hit_test(void)
{
    int i;
    begin(1);
    set16(S, 0x1e, 1);
    set32(S, 0x54, 1);
    set16(O, 0x21, 3);
    for (i = 0; i < 4; i++) set16(S, 0x3c + 2 * (size_t)i, 1);
    /* the three gates, each a dword: +0x54 must be set, +0x24 and +0x5e clear */
    set_rect(O, 32, R4A1, 10, 20, 30, 40);
    set32(S, 0x54, 0);
    CK(m4ab528_hit_test(S, 35, 15, &W, &H) == 0 && L.n == 0);
    set32(S, 0x54, 0x00000100u);
    set32(S, 0x24, 0x01000000u);
    CK(m4ab528_hit_test(S, 35, 15, &W, &H) == 0 && L.n == 0);
    set32(S, 0x24, 0);
    set32(S, 0x5e, 0x00010000u);
    CK(m4ab528_hit_test(S, 35, 15, &W, &H) == 0 && L.n == 0);
    set32(S, 0x5e, 0);
    /* loop 1, item 2: event 0x27cf with 2 */
    CK(m4ab528_hit_test(S, 35, 15, &W, &H) == 1);
    CK(L.n == 1 && is_call(0, 0x4ab706, (uintptr_t)S, 2) && L.c[0].a[0] == 0x27cf && L.c[0].a[1] == 2);
    /* the count (a signed word) bounds both loops: item 2 with count 2 is not visited */
    set16(O, 0x21, 2);
    clear_log();
    CK(m4ab528_hit_test(S, 35, 15, &W, &H) == 0 && L.n == 0);
    set16(O, 0x21, 3);
    /* loop 2 (item 1) needs the signed word S[0x3c + 2i] > 0: 1 and 0x7fff accept, 0, -1 and 0x8000 do not */
    memset(O, 0, 0x100);
    set16(O, 0x21, 3);
    set_rect(O, 16, R4A2, 10, 20, 30, 40);
    clear_log();
    CK(m4ab528_hit_test(S, 35, 15, &W, &H) == 1 && L.c[0].a[0] == 0x27ce && L.c[0].a[1] == 1);
    set16(S, 0x3e, 0x7fff);
    clear_log();
    CK(m4ab528_hit_test(S, 35, 15, &W, &H) == 1 && L.c[0].a[0] == 0x27ce);
    set16(S, 0x3e, 0);
    clear_log();
    CK(m4ab528_hit_test(S, 35, 15, &W, &H) == 0 && L.n == 0);
    set16(S, 0x3e, 0xffff);
    CK(m4ab528_hit_test(S, 35, 15, &W, &H) == 0 && L.n == 0);
    set16(S, 0x3e, 0x8000);
    CK(m4ab528_hit_test(S, 35, 15, &W, &H) == 0 && L.n == 0);
    set16(S, 0x3e, 1);
    /* loop 1 comes first when both match; the final rectangle is event 0x27d0 with 0 */
    set_rect(O, 16, R4A1, 10, 20, 30, 40);
    clear_log();
    CK(m4ab528_hit_test(S, 35, 15, &W, &H) == 1 && L.c[0].a[0] == 0x27cf && L.c[0].a[1] == 1);
    memset(O, 0, 0x100);
    set16(O, 0x21, 0xffff);
    set_rect(O, 0, R4AF, 10, 20, 30, 40);
    clear_log();
    CK(m4ab528_hit_test(S, 35, 15, &W, &H) == 1 && L.n == 1 && L.c[0].a[0] == 0x27d0 && L.c[0].a[1] == 0);
    /* the edges: loop 1 and loop 2 items 0 and 3 (count 4), then the final rectangle */
    for (i = 0; i < 4; i++) {
        memset(O, 0, 0xc00);
        set16(O, 0x21, 4);
        g_expect_event = 0x27cf;
        g_expect_arg = i;
        edges(run_4ab528, O, (size_t)i * 16, R4A1);
        memset(O, 0, 0xc00);
        set16(O, 0x21, 4);
        g_expect_event = 0x27ce;
        edges(run_4ab528, O, (size_t)i * 16, R4A2);
    }
    memset(O, 0, 0xc00);
    g_expect_event = 0x27d0;
    g_expect_arg = 0;
    edges(run_4ab528, O, 0, R4AF);
}

int main(void)
{
    int failures = 0;
    RUN(test_m47d734_store_point);
    RUN(test_m4a1e16_hit_test);
    RUN(test_m4ba377_hit_test);
    RUN(test_m459cc9_hit_test);
    RUN(test_m487c92_hit_test);
    RUN(test_m48a920_hit_test);
    RUN(test_m48e628_hit_test);
    RUN(test_m479deb_hit_test);
    RUN(test_m46ea16_hit_test);
    RUN(test_m4b7389_hit_test);
    RUN(test_m4ab528_hit_test);
    return failures;
}
