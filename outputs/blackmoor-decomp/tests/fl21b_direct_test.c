/* FL-21 (batch b) direct tests of the functions of GAME.EXE in src/original_methods_fl21b.c. Prints "PASS <name>" / "FAIL <name>: <msg>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values come from the disassembly of
 * GAME.EXE, not from running the native code; tests/test_fl21b_differential.py additionally runs the original bytes on random fixtures.
 */
#include "../src/original_methods_fl21b.h"

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
    const uint8_t *probe_ptr[8];
    int probe_len[8], nprobe;
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
    if (L.n < 512) L.c[L.n].callee = TICK_ID;
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

/* ---- 0x4468fe ---------------------------------------------------------------------------------------------------------------- */

#define SLACK 0x200
#define B(a) ((size_t)(a) - 0x638600u + SLACK)    /* offset of the original address a in the block buffer */

static uint8_t g_clock[SLACK + 0x300 + 0x100];

/* widths W[d] = 10 + d (d = -1 .. 9; W[-1] is the dword at 0x638663), heights H[d] = 20 + d (d = 0 .. 9; H[-1] is the dword W[9] shares), separator
 * 7 x 9, gap 3, x = 100, y = 200; the strings are given (new s1, s2, old o1, o2) */
static void clock_setup(const char *s1, const char *s2, const char *o1, const char *o2)
{
    int d;
    memset(g_clock, 0x5a, sizeof g_clock);
    set32(g_clock, B(0x63860b), 1);
    set32(g_clock, B(0x638613), 1);
    for (d = -1; d <= 9; d++) set32(g_clock, B(0x638667) + (size_t)(d * 4), (uint32_t)(10 + d));
    for (d = 0; d <= 9; d++) set32(g_clock, B(0x63868f) + (size_t)(d * 4), (uint32_t)(20 + d));
    set32(g_clock, B(0x6386b7), 7);
    set32(g_clock, B(0x6386bb), 9);
    set32(g_clock, B(0x638827), 100);
    set32(g_clock, B(0x63882b), 200);
    set32(g_clock, B(0x63882f), 3);
    set32(g_clock, B(0x638837), 1);
    strcpy((char *)g_clock + B(0x63884b), s1);
    strcpy((char *)g_clock + B(0x638855), s2);
    strcpy((char *)g_clock + B(0x638869), o1);
    strcpy((char *)g_clock + B(0x638873), o2);
}

static uint32_t rect_word(const uint8_t *snap, int i) { return get32(snap, (size_t)i * 4); }

/* the draw call k: 0x4c5d4b with the table dword t, the record address of the digit, the rectangle {l, t, r, b} (and the constant) */
static int check_draw(int k, uint32_t table_dword, uint32_t record, uint32_t konst, uint32_t l, uint32_t t, uint32_t r, uint32_t b)
{
    return is_call(k, 0x4c5d4b, 0x5cf659, 5) && L.c[k].a[0] == table_dword && L.c[k].a[1] == 0xc0de0001u && L.c[k].a[2] == record && L.c[k].a[4] == konst &&
           rect_word(L.c[k].pd[3], 0) == l && rect_word(L.c[k].pd[3], 1) == t && rect_word(L.c[k].pd[3], 2) == r && rect_word(L.c[k].pd[3], 3) == b;
}

/* the erase call k: 0x4c5377 with the dword 0x5d15e3, the rectangle q = {l, t, r, b} and p = q - the origin (5, 7) */
static int check_erase(int k, uint32_t konst, uint32_t l, uint32_t t, uint32_t r, uint32_t b)
{
    return is_call(k, 0x4c5377, 0x5cf659, 5) && L.c[k].a[0] == 0xc0de0003u && L.c[k].a[1] == 0xc0de0001u && L.c[k].a[4] == konst &&
           rect_word(L.c[k].pd[3], 0) == l && rect_word(L.c[k].pd[3], 1) == t && rect_word(L.c[k].pd[3], 2) == r && rect_word(L.c[k].pd[3], 3) == b &&
           rect_word(L.c[k].pd[2], 0) == l - 5 && rect_word(L.c[k].pd[2], 1) == t - 7 && rect_word(L.c[k].pd[2], 2) == r - 5 &&
           rect_word(L.c[k].pd[2], 3) == b - 7;
}

static void test_m4468fe_draw_clock(void)
{
    static uint8_t table[0x4a * 4], expect[sizeof g_clock];
    Fl21bWorld w;
    Fl18Host h = host();
    int i;
    memset(&w, 0, sizeof w);
    memset(table, 0, sizeof table);
    set32(table, 0, 0xabc00000u);
    set32(table, 0x4a, 0xabc00001u);
    set32(table, 0x94, 0xabc00002u);
    w.block_638600 = g_clock + SLACK;
    w.table_5d1599 = table;
    w.origin_x_583186 = 5;
    w.origin_y_58318a = 7;
    w.value_5cf665 = 0xc0de0001u;
    w.value_5d15e3 = 0xc0de0003u;
    /* equal strings: only the new digits are drawn: "12" then the separator then "305", and the copies change nothing */
    clock_setup("12", "305", "12", "305");
    memcpy(expect, g_clock, sizeof expect);
    m4468fe_draw_clock(&w, &h);
    CK(memcmp(g_clock, expect, sizeof expect) == 0);
    CK(L.n == 6);
    CK(check_draw(0, 0xabc00001u, 0x638777u + 16, 0x548348, 100, 200, 110, 220));
    CK(check_draw(1, 0xabc00001u, 0x638777u + 32, 0x548348, 114, 200, 125, 221));
    CK(check_draw(2, 0xabc00001u, 0x638817u, 0x548358, 129, 205, 135, 213));   /* y + (H[0] - 9) / 2 = 200 + 5 */
    CK(check_draw(3, 0xabc00001u, 0x638777u + 48, 0x548368, 139, 200, 151, 222));
    CK(check_draw(4, 0xabc00001u, 0x638777u + 0, 0x548368, 155, 200, 164, 219));
    CK(check_draw(5, 0xabc00001u, 0x638777u + 80, 0x548368, 168, 200, 182, 224));
    /* the first string differs: the old digits "7" (o1), the separator and "89" (o2) are erased first, then everything is drawn; at every call the old
     * strings are still in place (the copies come last) */
    clock_setup("12", "3", "7", "89");
    memcpy(expect, g_clock, sizeof expect);
    reset_log();
    add_probe(g_clock + B(0x63884b), 0x32);
    m4468fe_draw_clock(&w, &h);
    for (i = 0; i < L.n; i++) CK(memcmp(L.c[i].probe, expect + B(0x63884b), 0x32) == 0);
    memcpy(expect + B(0x638869), "12", 3);
    memcpy(expect + B(0x638873), "3", 2);
    CK(memcmp(g_clock, expect, sizeof expect) == 0);
    CK(L.n == 4 + 4);
    CK(check_erase(0, 0x5482c4, 100, 200, 116, 226));              /* '7': W = 17, H = 27 */
    CK(check_erase(1, 0x5482f0, 120, 205, 126, 213));              /* the separator at x = 100 + 17 + 3 */
    CK(check_erase(2, 0x54831c, 130, 200, 147, 227));              /* '8': W = 18, H = 28 */
    CK(check_erase(3, 0x54831c, 151, 200, 169, 228));              /* '9': x = 130 + 18 + 3 */
    CK(check_draw(4, 0xabc00001u, 0x638777u + 16, 0x548348, 100, 200, 110, 220));
    CK(check_draw(5, 0xabc00001u, 0x638777u + 32, 0x548348, 114, 200, 125, 221));
    CK(check_draw(6, 0xabc00001u, 0x638817u, 0x548358, 129, 205, 135, 213));
    CK(check_draw(7, 0xabc00001u, 0x638777u + 48, 0x548368, 139, 200, 151, 222));
    /* only the second string differs (s1 == o1): the erase part still runs, over o1 = "12" and o2 = "4" */
    clock_setup("12", "3", "12", "4");
    reset_log();
    m4468fe_draw_clock(&w, &h);
    CK(L.n == 4 + 4);
    CK(check_erase(0, 0x5482c4, 100, 200, 110, 220));
    CK(check_erase(1, 0x5482c4, 114, 200, 125, 221));
    CK(check_erase(2, 0x5482f0, 129, 205, 135, 213));
    CK(check_erase(3, 0x54831c, 139, 200, 152, 223));              /* '4': W = 14, H = 24 */
    CK(memcmp(g_clock + B(0x638873), "3", 2) == 0);
    /* only the first string differs (s2 == o2) */
    clock_setup("5", "3", "6", "3");
    reset_log();
    m4468fe_draw_clock(&w, &h);
    CK(L.n == 3 + 3);
    CK(check_erase(0, 0x5482c4, 100, 200, 115, 225));              /* '6': W = 16, H = 26 */
    CK(check_erase(1, 0x5482f0, 119, 205, 125, 213));
    CK(check_erase(2, 0x54831c, 129, 200, 141, 222));              /* o2 = "3" is erased as well */
    CK(check_draw(3, 0xabc00001u, 0x638777u + 80, 0x548348, 100, 200, 114, 224));   /* '5': W = 15, H = 25 */
    /* the pairwise compare: "ab" vs "ab" is equal, "abc" vs "abd" differs in the second pair, "a" vs "ab" differs at the terminator */
    for (i = 0; i < 3; i++) {
        static const char *news[3] = {"12", "123", "1"};
        static const char *olds[3] = {"12", "124", "12"};
        static const int erased[3] = {0, 1, 1};
        clock_setup(news[i], "0", olds[i], "0");
        reset_log();
        m4468fe_draw_clock(&w, &h);
        CK((L.c[0].callee == 0x4c5377) == (erased[i] != 0));
    }
    /* either gate dword zero: nothing happens (the strings differ here) */
    for (i = 0; i < 2; i++) {
        clock_setup("12", "34", "56", "78");
        set32(g_clock, i == 0 ? B(0x63860b) : B(0x638613), 0);
        memcpy(expect, g_clock, sizeof expect);
        reset_log();
        m4468fe_draw_clock(&w, &h);
        CK(L.n == 0 && memcmp(g_clock, expect, sizeof expect) == 0);
    }
    /* empty strings: only the separator is drawn; the old ones are empty too */
    clock_setup("", "", "", "");
    reset_log();
    m4468fe_draw_clock(&w, &h);
    CK(L.n == 1 && check_draw(0, 0xabc00001u, 0x638817u, 0x548358, 100, 205, 106, 213));
    /* the table record comes from the dword 0x638837 (here 2), a character below '0' ('/' = -1: W[-1] = 9, H[-1] = the dword W[9] = 19), and a x
     * near 2^32 wraps */
    clock_setup("/", "", "/", "");
    set32(g_clock, B(0x638837), 2);
    set32(g_clock, B(0x638827), 0xfffffff0u);
    reset_log();
    m4468fe_draw_clock(&w, &h);
    CK(L.n == 2);
    CK(check_draw(0, 0xabc00002u, 0x638777u - 16, 0x548348, 0xfffffff0u, 200, 0xfffffff0u + 9 - 1, 200 + 19 - 1));
    CK(check_draw(1, 0xabc00002u, 0x638817u, 0x548358, 0xfffffff0u + 9 + 3, 205, 0xfffffff0u + 9 + 3 + 6, 213));
    /* characters with the high bit set are SIGNED bytes: d = (signed byte) - 0x30. New s1 = "\xe0" (d = -80), s2 = "\xe1" (-79), old o1 = "\xe2" (-78),
     * o2 = "\xe3" (-77), with the widths W[d] = 31 .. 34 and the heights H[d] = 41 .. 44 stored at their (negative) indices; the erase part walks
     * o1, the separator, o2 and the draw part s1, the separator, s2 */
    clock_setup("\xe0", "\xe1", "\xe2", "\xe3");
    for (i = 0; i < 4; i++) {
        set32(g_clock, B(0x638667) + (size_t)((-80 + i) * 4), (uint32_t)(31 + i));
        set32(g_clock, B(0x63868f) + (size_t)((-80 + i) * 4), (uint32_t)(41 + i));
    }
    reset_log();
    m4468fe_draw_clock(&w, &h);
    CK(L.n == 6);
    CK(check_erase(0, 0x5482c4, 100, 200, 132, 242));              /* '\xe2': W = 33, H = 43 */
    CK(check_erase(1, 0x5482f0, 136, 205, 142, 213));
    CK(check_erase(2, 0x54831c, 146, 200, 179, 243));              /* '\xe3': W = 34, H = 44 */
    CK(check_draw(3, 0xabc00001u, 0x638777u - 80 * 16, 0x548348, 100, 200, 130, 240));   /* '\xe0': W = 31, H = 41 */
    CK(check_draw(4, 0xabc00001u, 0x638817u, 0x548358, 134, 205, 140, 213));
    CK(check_draw(5, 0xabc00001u, 0x638777u - 79 * 16, 0x548368, 144, 200, 175, 241));   /* '\xe1': W = 32, H = 42 */
    /* a first string longer than 0x1e overlaps its copy: the copy runs forward in dwords (rep movsd) then bytes (rep movsb) */
    clock_setup("", "", "", "");
    for (i = 0; i < 34; i++) g_clock[B(0x63884b) + (size_t)i] = (uint8_t)('0' + i % 10);
    g_clock[B(0x63884b) + 34] = 0;
    /* the forward dword copy overwrites the first string's own terminator; the original then reads the second string's length through
     * whatever follows (an unterminated string), so a zero byte is planted well inside the buffer to bound that read (documented limit) */
    g_clock[B(0x6388a0)] = 0;
    memcpy(expect, g_clock, sizeof expect);
    {
        uint32_t n = 35, src = (uint32_t)B(0x63884b), dst = (uint32_t)B(0x638869), c;
        for (c = 0; c < n / 4; c++) set32(expect, dst + 4 * c, get32(expect, src + 4 * c));
        for (c = 0; c < (n & 3); c++) expect[dst + (n & ~3u) + c] = expect[src + (n & ~3u) + c];
    }
    reset_log();
    m4468fe_draw_clock(&w, &h);
    CK(memcmp(g_clock + B(0x638869), expect + B(0x638869), 10) == 0);   /* (the second copy starts at 0x638873) */
}

/* ---- 0x47f421 ---------------------------------------------------------------------------------------------------------------- */

#define IT(i) ((size_t)(0x7b4 + 0x25 * (i)))

static uint8_t g_self[0x1500], g_rec[0xb00], g_rect[16], g_exp[0x1500];
#define REC_VA 0x00d40000u

/* The default fixture: record index 2 (the object g_rec), three items (item 1 is the current one: box 40,50 .. 60,90, so half_w = 10 and
 * half_h = 20), the gate dword set, "drag" mode (the dword 0x1344 is set, the byte 0x13b1 is 0), the point inside the bounds of the record. */
static void hit_setup(Fl21bWorld *w)
{
    memset(g_self, 0x77, sizeof g_self);
    memset(g_rec, 0x33, sizeof g_rec);
    memset(g_records, 0, sizeof g_records);
    set32(g_records, 2 * REC, REC_VA);
    memset(w, 0, sizeof *w);
    w->records_5bb5e5 = g_records;
    set16(g_self, 0x1e, 2);
    set32(g_self, 0x13c5, 1);
    set32(g_self, 0x1344, 1);
    g_self[0x13b1] = 0;
    set16(g_self, 0x1350, 1);
    set16(g_self, 0x13a2, 3);
    set32(g_self, IT(0) + 2, 10);   /* x0, y0, x1, y1 of item 0 */
    set32(g_self, IT(0) + 6, 10);
    set32(g_self, IT(0) + 0xa, 30);
    set32(g_self, IT(0) + 0xe, 30);
    set32(g_self, IT(1) + 2, 40);
    set32(g_self, IT(1) + 6, 50);
    set32(g_self, IT(1) + 0xa, 60);
    set32(g_self, IT(1) + 0xe, 90);
    set32(g_self, IT(2) + 2, 70);
    set32(g_self, IT(2) + 6, 70);
    set32(g_self, IT(2) + 0xa, 120);
    set32(g_self, IT(2) + 0xe, 120);
    g_self[IT(0) + 0x23] = g_self[IT(1) + 0x23] = g_self[IT(2) + 0x23] = 1;
    g_self[IT(0) + 0x24] = g_self[IT(1) + 0x24] = g_self[IT(2) + 0x24] = 0;
    g_self[0x7a0] = g_self[0x7a1] = g_self[0x7a2] = 1;
    set32(g_self, 0x1352, 20);   /* the dragged rectangle: left, top, right, bottom */
    set32(g_self, 0x1356, 20);
    set32(g_self, 0x135a, 50);
    set32(g_self, 0x135e, 50);
    set32(g_rec, 0x4e, 0);
    set32(g_rec, 0x56, 200);
    set32(g_rec, 0x52, 0);
    set32(g_rec, 0x5a, 300);
    g_rec[0x5e] = 0;
    g_rec[0x5f] = 1;
    g_rec[0x48] = g_rec[0x49] = 1;
    set16(g_rec, 0x4a, 15);
    set16(g_rec, 0x4c, 15);
    memset(g_rec + 0xe9, 0, 0x53 * 4);
    set32(g_rec, 0xa14, 1000);   /* the two boxes of the tail: far away */
    set32(g_rec, 0xa18, 1000);
    set32(g_rec, 0xa1c, 1001);
    set32(g_rec, 0xa20, 1001);
    set32(g_rec, 0xa24, 1000);
    set32(g_rec, 0xa28, 1000);
    set32(g_rec, 0xa2c, 1001);
    set32(g_rec, 0xa30, 1001);
    set32(g_rect, 0, 11);
    set32(g_rect, 4, 22);
    set32(g_rect, 8, 33);
    set32(g_rect, 12, 44);
    reset_log();
    add_region(REC_VA, g_rec, sizeof g_rec);
}

/* the rectangle copied from the argument: [0x13cf] = rect[0], [0x13d3] = rect[1], [0x13d7] = rect[2], [0x13db] = rect[3] */
static void hit_expect_rect(uint8_t *e)
{
    set32(e, 0x13cf, 11);
    set32(e, 0x13d3, 22);
    set32(e, 0x13d7, 33);
    set32(e, 0x13db, 44);
}

static int32_t hit_run(Fl21bWorld *w, int16_t x, int16_t y)
{
    Fl18Host h = host();
    return m47f421_pointer_hit(g_self, x, y, g_rect, w, &h);
}

static void test_m47f421_pointer_hit(void)
{
    Fl21bWorld w;
    int32_t r;
    int k;
    /* the gate dword is zero: 0, and not even the rectangle is stored */
    hit_setup(&w);
    set32(g_self, 0x13c5, 0);
    memcpy(g_exp, g_self, sizeof g_self);
    CK(hit_run(&w, 100, 100) == 0);
    CK(L.n == 0 && memcmp(g_self, g_exp, sizeof g_self) == 0);
    /* drag mode, inside the bounds: the half sizes are w = (60-40)/2 = 10 and h = (90-50)/2 = 20; x = 100, y = 100 -> 90 > left, 110 < right, 80 >
     * top, 120 < bottom. 0x47f275 is called first (the rectangle has been stored already), then the loop, then 0x47fd65 with 0x2791 */
    hit_setup(&w);
    add_probe(g_self + 0x13cf, 0x20);
    memcpy(g_exp, g_self, sizeof g_self);
    hit_expect_rect(g_exp);
    set32(g_exp, 0x13df, 1);   /* inside; the dragged rectangle (20,20)-(50,50) meets item 0 (10,10)-(30,30) in both directions: back to 0 */
    set32(g_exp, 0x13df, 0);
    r = hit_run(&w, 100, 100);
    CK(r == 1);
    CK(L.n == 2 && is_call(0, 0x47f275, (uintptr_t)g_self, 0) && is_call(1, 0x47fd65, (uintptr_t)g_self, 1) && L.c[1].a[0] == 0x2791);
    CK(get32(L.c[0].probe, 0) == 11 && get32(L.c[0].probe, 4) == 22 && get32(L.c[0].probe, 8) == 33 && get32(L.c[0].probe, 12) == 44);
    CK(get32(L.c[1].probe, 0x10) == 0);   /* 0x13df was stored before the call */
    CK(memcmp(g_self, g_exp, sizeof g_self) == 0);
    /* each of the four bounds is strict: the point is outside when it touches (and the byte rec[0x5e] is 0: no callee) */
    {
        static const struct { size_t field; uint32_t value; int inside; } edges[] = {
            {0x52, 80, 0}, {0x52, 79, 1},        /* y - 20 > top */
            {0x5a, 120, 0}, {0x5a, 121, 1},      /* y + 20 < bottom */
            {0x4e, 90, 0}, {0x4e, 89, 1},        /* x - 10 > left */
            {0x56, 110, 0}, {0x56, 111, 1},      /* x + 10 < right */
        };
        for (k = 0; k < 8; k++) {
            hit_setup(&w);
            set32(g_self, 0x1352, 100);   /* a dragged rectangle that meets no item, so that the flag stays as the test left it */
            set32(g_self, 0x1356, 100);
            set32(g_self, 0x135a, 101);
            set32(g_self, 0x135e, 101);
            g_self[0x7a2] = 0;
            set32(g_rec, edges[k].field, edges[k].value);
            r = hit_run(&w, 100, 100);
            CK(r == 1 && get32(g_self, 0x13df) == (uint32_t)edges[k].inside);
            CK(L.n == 2);
            CK(L.c[0].callee == 0x47f275 && L.c[L.n - 1].callee == 0x47fd65 && L.c[L.n - 1].a[0] == 0x2791);
        }
    }
    /* outside and rec[0x5e] == 1: 0x47ec06 on self with the words (x, y) decides */
    for (k = 0; k < 3; k++) {
        hit_setup(&w);
        set32(g_rec, 0x52, 500);   /* outside */
        g_rec[0x5e] = k == 2 ? 2 : 1;
        queue_return(0x47ec06, k == 0 ? 0u : 0x10000u);   /* a dword test: non-zero is a yes even with a zero low word */
        r = hit_run(&w, -7, 30000);
        CK(r == 1);
        if (k == 2) {
            CK(L.n == 2 && get32(g_self, 0x13df) == 0);
        } else {
            CK(L.n == 3 && is_call(1, 0x47ec06, (uintptr_t)g_self, 2) && (L.c[1].a[0] & 0xffff) == 0xfff9 && (L.c[1].a[1] & 0xffff) == 30000);
            CK(get32(g_self, 0x13df) == (k == 0 ? 0u : 1u) || k == 1);   /* a yes with rec[0x5e] == 1 does not enter the loop (the byte is not 0) */
            CK(get32(g_self, 0x13df) == (k == 0 ? 0u : 1u));
        }
    }
    /* the loop: the dragged rectangle against the other items (item 1 is the current one and skipped, an item with a zero flag byte is skipped) */
    {
        static const struct { uint32_t l, t, r, b; int meets; } drags[] = {
            {20, 20, 50, 50, 1},           /* item 0: left >= x0 -> u = left <= x1 - 3 (20 <= 27); same vertically */
            {27, 20, 50, 50, 1},           /* left == x1 - 3: still u */
            {28, 20, 50, 50, 0},           /* left == x1 - 2: no u */
            {20, 27, 50, 50, 1},
            {20, 28, 50, 50, 0},
            {5, 5, 13, 13, 1},             /* left < x0 -> u = right >= x0 + 3 (13) */
            {5, 5, 12, 13, 0},
            {5, 5, 13, 12, 0},
            {200, 200, 300, 300, 0},       /* item 2 (70,70)-(120,120): left >= x0, u = left <= 117 */
        };
        for (k = 0; k < 9; k++) {
            hit_setup(&w);
            set32(g_self, 0x1352, drags[k].l);
            set32(g_self, 0x1356, drags[k].t);
            set32(g_self, 0x135a, drags[k].r);
            set32(g_self, 0x135e, drags[k].b);
            g_self[0x7a2] = 0;   /* item 2 is not looked at */
            r = hit_run(&w, 100, 100);
            CK(r == 1 && get32(g_self, 0x13df) == (drags[k].meets ? 0u : 1u));
        }
        hit_setup(&w);   /* the flag byte of the current item and of item 0: the dragged rectangle meets item 2 only when its flag is set */
        set32(g_self, 0x1352, 100);
        set32(g_self, 0x1356, 100);
        set32(g_self, 0x135a, 110);
        set32(g_self, 0x135e, 110);
        r = hit_run(&w, 100, 100);
        CK(get32(g_self, 0x13df) == 0);
        hit_setup(&w);
        set32(g_self, 0x1352, 100);
        set32(g_self, 0x1356, 100);
        set32(g_self, 0x135a, 110);
        set32(g_self, 0x135e, 110);
        g_self[0x7a2] = 0;
        r = hit_run(&w, 100, 100);
        CK(get32(g_self, 0x13df) == 1);
        hit_setup(&w);   /* the current item is skipped even when it meets the rectangle (item 1 is at 40,50 .. 60,90) */
        set32(g_self, 0x1352, 45);
        set32(g_self, 0x1356, 55);
        set32(g_self, 0x135a, 55);
        set32(g_self, 0x135e, 85);
        g_self[0x7a2] = 0;
        r = hit_run(&w, 100, 100);
        CK(get32(g_self, 0x13df) == 1);
    }
    /* the loop is entered only when the byte rec[0x5e] is 0 and the byte rec[0x5f] is not */
    hit_setup(&w);
    g_rec[0x5f] = 0;
    r = hit_run(&w, 100, 100);
    CK(r == 1 && get32(g_self, 0x13df) == 1 && L.n == 2);
    /* the half sizes round toward zero and are kept as words: a current item 3 wide (x) and 5 high: half_w = 1 and half_h = 2 */
    hit_setup(&w);
    set32(g_self, IT(1) + 2, 0);
    set32(g_self, IT(1) + 0xa, 3);
    set32(g_self, IT(1) + 6, 0);
    set32(g_self, IT(1) + 0xe, 5);
    set32(g_rec, 0x4e, 98);   /* x - 1 > 98 */
    set32(g_rec, 0x52, 97);   /* y - 2 > 97 -> 98 > 97 */
    set32(g_rec, 0x56, 102);
    set32(g_rec, 0x5a, 103);
    set32(g_self, 0x1352, 500);
    set32(g_self, 0x135a, 501);
    set32(g_self, 0x1356, 500);
    set32(g_self, 0x135e, 501);
    r = hit_run(&w, 100, 100);
    CK(get32(g_self, 0x13df) == 1);
    set32(g_rec, 0x5a, 102);   /* y + 2 < 102 fails */
    r = hit_run(&w, 100, 100);
    CK(get32(g_self, 0x13df) == 0);
    /* a negative extent: (0 - 5) / 2 = -2 (toward zero), (3 - 0) / 2 = 1 */
    hit_setup(&w);
    set32(g_self, IT(1) + 6, 5);
    set32(g_self, IT(1) + 0xe, 0);
    set32(g_rec, 0x52, 97);
    set32(g_rec, 0x5a, 103);   /* y -/+ (-2): 102 > 97 and 98 < 103 */
    set32(g_self, 0x1352, 500);
    set32(g_self, 0x135a, 501);
    set32(g_self, 0x1356, 500);
    set32(g_self, 0x135e, 501);
    r = hit_run(&w, 100, 100);
    CK(get32(g_self, 0x13df) == 1);
    set32(g_rec, 0x52, 101);   /* 102 > 101 still; 102 > 102 would fail */
    r = hit_run(&w, 100, 100);
    CK(get32(g_self, 0x13df) == 1);
    set32(g_rec, 0x52, 102);
    r = hit_run(&w, 100, 100);
    CK(get32(g_self, 0x13df) == 0);
    /* pick mode (the dword 0x1344 is zero): the lists. x = 100, y = 100. Item 0 (90,90)-(110,110) is in both lists when the record allows the
     * wider box; item 1 (current) (0,0)-(5,5) misses; item 2 (95,95)-(100,100) is in the first list only (rec[0x4a] = 15, rec[0x4c] = 15 make the
     * wider test (y within [y0, y0 + 15], x within [x0, x0 + 15]) hold for item 0 only: item 2 has y0 + 15 = 110 -> also; use 2 instead) */
    hit_setup(&w);
    set32(g_self, 0x1344, 0);
    set32(g_self, IT(0) + 2, 90);
    set32(g_self, IT(0) + 6, 90);
    set32(g_self, IT(0) + 0xa, 110);
    set32(g_self, IT(0) + 0xe, 110);
    set32(g_self, IT(1) + 2, 0);
    set32(g_self, IT(1) + 6, 0);
    set32(g_self, IT(1) + 0xa, 5);
    set32(g_self, IT(1) + 0xe, 5);
    set32(g_self, IT(2) + 2, 95);
    set32(g_self, IT(2) + 6, 95);
    set32(g_self, IT(2) + 0xa, 100);
    set32(g_self, IT(2) + 0xe, 100);
    set16(g_rec, 0x4a, 5);    /* item 0: y within [90, 95], x within [90, 95]: no; item 2: [95, 100]: y and x = 100 -> yes */
    set16(g_rec, 0x4c, 5);
    memcpy(g_exp, g_self, sizeof g_self);
    hit_expect_rect(g_exp);
    memset(g_exp + 0x13ef, 0, 40);
    set16(g_exp, 0x1417, 1);      /* first list: item 0 */
    set16(g_exp, 0x13ef, 0);
    set16(g_exp, 0x1441, 1);      /* second list: item 2 */
    set16(g_exp, 0x1419, 2);
    add_probe(g_self + 0x13cf, 0x75);
    r = hit_run(&w, 100, 100);
    CK(r == 1 && L.n == 1 && is_call(0, 0x47fd65, (uintptr_t)g_self, 1) && L.c[0].a[0] == 0x278e);   /* the second list wins */
    CK(memcmp(g_self, g_exp, sizeof g_self) == 0);
    CK(memcmp(L.c[0].probe + 0x20, g_exp + 0x13ef, 0x28) == 0 && get16(L.c[0].probe, 0x48) == 1);   /* the lists are complete at the call */
    /* only the first list */
    set16(g_rec, 0x4a, 0);
    g_rec[0x49] = 0;
    memset(g_self + 0x13ef, 0x55, 0x58);   /* stale entries: the first list is cleared, the second list's words stay */
    memcpy(g_exp, g_self, sizeof g_self);
    hit_expect_rect(g_exp);
    memset(g_exp + 0x13ef, 0, 40);
    set16(g_exp, 0x1417, 2);
    set16(g_exp, 0x13ef, 0);
    set16(g_exp, 0x13f1, 2);      /* (item 2 also lies in the first box (95,95)-(100,100)) */
    set16(g_exp, 0x1441, 0);
    reset_log();
    add_region(REC_VA, g_rec, sizeof g_rec);
    r = hit_run(&w, 100, 100);
    CK(r == 1 && L.n == 1 && L.c[0].a[0] == 0x278d);
    CK(memcmp(g_self, g_exp, sizeof g_self) == 0);
    /* the box edges are inclusive: y == y1 and x == x1 hit, one beyond does not (item 0 is (90,90)-(110,110)) */
    for (k = 0; k < 6; k++) {
        static const int xs[6] = {110, 111, 90, 89, 100, 100};
        static const int ys[6] = {100, 100, 100, 100, 110, 111};
        static const int hit[6] = {1, 0, 1, 0, 1, 0};
        set32(g_self, IT(2) + 2, 500);
        set32(g_self, IT(2) + 6, 500);
        set32(g_self, IT(2) + 0xa, 501);
        set32(g_self, IT(2) + 0xe, 501);
        reset_log();
        add_region(REC_VA, g_rec, sizeof g_rec);
        r = hit_run(&w, (int16_t)xs[k], (int16_t)ys[k]);
        CK(r == hit[k]);
        CK(get16(g_self, 0x1417) == (uint16_t)hit[k]);
        CK(L.n == hit[k]);
    }
    /* an item with a non-zero byte +0x24 whose class byte (+0x23) names a non-zero byte of the record at rec[class * 0x53 + 0xe9] is skipped */
    set32(g_self, IT(0) + 2, 90);
    set32(g_self, IT(0) + 6, 90);
    set32(g_self, IT(0) + 0xa, 110);
    set32(g_self, IT(0) + 0xe, 110);
    g_self[IT(0) + 0x24] = 1;
    g_self[IT(0) + 0x23] = 2;
    g_rec[0xe9 + 2 * 0x53] = 0;
    reset_log();
    add_region(REC_VA, g_rec, sizeof g_rec);
    r = hit_run(&w, 100, 100);
    CK(r == 1 && get16(g_self, 0x1417) == 1);          /* byte zero: not skipped */
    g_rec[0xe9 + 2 * 0x53] = 9;
    reset_log();
    add_region(REC_VA, g_rec, sizeof g_rec);
    r = hit_run(&w, 100, 100);
    CK(r == 0 && get16(g_self, 0x1417) == 0);          /* non-zero: skipped */
    g_self[IT(0) + 0x24] = 0;
    reset_log();
    add_region(REC_VA, g_rec, sizeof g_rec);
    r = hit_run(&w, 100, 100);
    CK(r == 1 && get16(g_self, 0x1417) == 1);          /* the +0x24 byte is zero: the table is not looked at */
    /* the locked byte 0x13b1: only the current item counts (here item 1, made to contain the point), item 0 is ignored */
    g_self[0x13b1] = 5;
    set32(g_self, IT(1) + 2, 0);
    set32(g_self, IT(1) + 6, 0);
    set32(g_self, IT(1) + 0xa, 200);
    set32(g_self, IT(1) + 0xe, 200);
    reset_log();
    add_region(REC_VA, g_rec, sizeof g_rec);
    r = hit_run(&w, 100, 100);
    CK(r == 1 && get16(g_self, 0x1417) == 1 && get16(g_self, 0x13ef) == 1);
    /* with the drag dword set but the locked byte non-zero, pick mode is used as well; and the tail: no item hits -> the two boxes of the record */
    hit_setup(&w);
    g_self[0x13b1] = 1;
    set32(g_rec, 0xa14, 90);   /* box 1: x 90..110, y 80..120 */
    set32(g_rec, 0xa18, 80);
    set32(g_rec, 0xa1c, 110);
    set32(g_rec, 0xa20, 120);
    for (k = 0; k < 5; k++) {
        static const int xs[5] = {100, 111, 89, 100, 100};
        static const int ys[5] = {100, 100, 100, 121, 79};
        static const int hit[5] = {1, 0, 0, 0, 0};
        reset_log();
        add_region(REC_VA, g_rec, sizeof g_rec);
        r = hit_run(&w, (int16_t)xs[k], (int16_t)ys[k]);
        CK(r == hit[k]);
        CK(L.n == hit[k] && (!hit[k] || L.c[0].a[0] == 0x278f));
    }
    set32(g_rec, 0xa24, 300);   /* box 2: x 300..310, y 400..410 -> 0x2790 */
    set32(g_rec, 0xa28, 400);
    set32(g_rec, 0xa2c, 310);
    set32(g_rec, 0xa30, 410);
    for (k = 0; k < 5; k++) {
        static const int xs[5] = {300, 310, 311, 299, 305};
        static const int ys[5] = {400, 410, 405, 405, 411};
        static const int hit[5] = {1, 1, 0, 0, 0};
        reset_log();
        add_region(REC_VA, g_rec, sizeof g_rec);
        r = hit_run(&w, (int16_t)xs[k], (int16_t)ys[k]);
        CK(r == hit[k]);
        CK(L.n == hit[k] && (!hit[k] || L.c[0].a[0] == 0x2790));
    }
    /* the pivots of the loop of the drag mode, at their equalities. Item 0 is (10,10)-(30,30); item 1 is the current one, the flag byte of item 2
     * is 0. On the x side: when [0x1352] < x0 (strict) u = ([0x135a] >= x0 + 3), else u = ([0x1352] <= x1 - 3); the y side likewise with [0x1356],
     * [0x135e] and y0, y1. One side is held at "yes" while the other is varied; meets = the flag [0x13df] ends 0 */
    {
        static const struct { int32_t l, t, r, b; int meets; } piv[] = {
            /* x side, v forced (top 5 < y0, bottom 50 >= y0 + 3) */
            {10, 5, 12, 50, 1},     /* [0x1352] == x0, right < x0 + 3: the else branch gives u (a `<=` would test the right edge: no) */
            {10, 5, 40, 50, 1},     {9, 5, 12, 50, 0},   /* [0x1352] < x0 and right < x0 + 3: no u */
            {5, 5, 13, 50, 1},      /* right == x0 + 3: u (a `<` for >= would lose it) */
            {5, 5, 12, 50, 0},      {27, 5, 40, 50, 1},  {28, 5, 40, 50, 0},   /* left == x1 - 3: u; one more: no */
            /* y side, u forced (left 5, right 50) */
            {5, 10, 50, 12, 1},     /* [0x1356] == y0, bottom < y0 + 3: the else branch gives v */
            {5, 10, 50, 40, 1},     {5, 9, 50, 12, 0},   {5, 5, 50, 13, 1},     {5, 5, 50, 12, 0},     {5, 27, 50, 40, 1},    {5, 28, 50, 40, 0},
        };
        for (k = 0; k < (int)(sizeof piv / sizeof piv[0]); k++) {
            hit_setup(&w);
            g_self[0x7a2] = 0;
            set32(g_self, 0x1352, (uint32_t)piv[k].l);
            set32(g_self, 0x1356, (uint32_t)piv[k].t);
            set32(g_self, 0x135a, (uint32_t)piv[k].r);
            set32(g_self, 0x135e, (uint32_t)piv[k].b);
            r = hit_run(&w, 100, 100);
            CK(r == 1 && get32(g_self, 0x13df) == (piv[k].meets ? 0u : 1u));
        }
    }
    /* the words [rec+0x4a] and [rec+0x4c] are signed: a negative extent makes the wider test of the pick mode empty (the item falls through to
     * the first list); the point (45, 60) is only in item 1 (40,50)-(60,90) */
    for (k = 0; k < 2; k++) {
        hit_setup(&w);
        set32(g_self, 0x1344, 0);
        set16(g_rec, 0x4a, (uint16_t)(k == 0 ? -3 : 15));
        set16(g_rec, 0x4c, (uint16_t)(k == 0 ? 15 : -3));
        r = hit_run(&w, 45, 60);
        CK(r == 1 && L.n == 1 && L.c[0].a[0] == 0x278d);
        CK(get16(g_self, 0x1417) == 1 && get16(g_self, 0x13ef) == 1 && get16(g_self, 0x1441) == 0);
    }
    /* the half sizes of a current item with a NEGATIVE ODD extent round toward zero: x0 = 40, x1 = 37 (width -3, half_w = -1) and y0 = 50, y1 = 47
     * (half_h = -1, a floor would give -2). The point (100, 100): y - half_h = 101 > top, y + half_h = 99 < bottom, x - half_w = 101 > left,
     * x + half_w = 99 < right; the dragged rectangle meets nothing */
    {
        static const struct { size_t field; uint32_t value; int inside; } e2[] = {
            {0x52, 101, 0}, {0x52, 100, 1}, {0x5a, 99, 0}, {0x5a, 100, 1}, {0x4e, 101, 0}, {0x4e, 100, 1}, {0x56, 99, 0}, {0x56, 100, 1},
        };
        for (k = 0; k < (int)(sizeof e2 / sizeof e2[0]); k++) {
            hit_setup(&w);
            set32(g_self, IT(1) + 2, 40);
            set32(g_self, IT(1) + 0xa, 37);
            set32(g_self, IT(1) + 6, 50);
            set32(g_self, IT(1) + 0xe, 47);
            set32(g_self, 0x1352, 100);
            set32(g_self, 0x1356, 100);
            set32(g_self, 0x135a, 101);
            set32(g_self, 0x135e, 101);
            g_self[0x7a2] = 0;
            set32(g_rec, e2[k].field, e2[k].value);
            r = hit_run(&w, 100, 100);
            CK(r == 1 && L.n == 2 && get32(g_self, 0x13df) == (uint32_t)e2[k].inside);
        }
    }
}

/* ---- 0x48569e ---------------------------------------------------------------------------------------------------------------- */

#define SL(k) ((size_t)(0x2a + 0x85 * (k)))   /* the slot k of the item array: 16 bytes at +0, 16 bytes at +0x10 */

/* record 1 (the word [self+0x26]) is the object g_rec, its state dword is 1, the gates are open, the slot word [self+0xa9e] is 1; self and the
 * record object are filled with a byte pattern so that every copy can be told from its source */
static void key_setup(Fl21bWorld *w, uint32_t selector)
{
    size_t i;
    for (i = 0; i < sizeof g_self; i++) g_self[i] = (uint8_t)(i * 13 + 5);
    for (i = 0; i < sizeof g_rec; i++) g_rec[i] = (uint8_t)(i * 7 + 3);
    memset(g_records, 0, sizeof g_records);
    set32(g_records, 1 * REC, REC_VA);
    set32(g_records, 1 * REC + 0x4d, 1);
    memset(w, 0, sizeof *w);
    w->records_5bb5e5 = g_records;
    w->value_5c39e5 = selector;
    set16(g_self, 0x26, 1);
    set32(g_self, 0xba7, 1);
    g_self[0xbb0] = 0;
    set32(g_self, 0xbac, 0);
    set32(g_self, 0xa92, 0);
    set32(g_self, 0xa96, 9);
    set32(g_self, 0xa9a, 8);
    set16(g_self, 0xa9e, 1);
    reset_log();
    add_region(REC_VA, g_rec, sizeof g_rec);
}

static void key_run(Fl21bWorld *w)
{
    Fl18Host h = host();
    m48569e_handle_key(g_self, w, &h);
}

static void test_m48569e_handle_key(void)
{
    Fl21bWorld w;
    size_t k;
    static const uint32_t selectors[] = {0x2779, 0x277c, 0x2778, 0x2777, 0x277b, 0x277a, 0x2776, 0, 0x2780};
    /* each of the four gates alone stops everything: no call, nothing stored (every selector) */
    for (k = 0; k < sizeof selectors / sizeof selectors[0]; k++) {
        int gate;
        for (gate = 0; gate < 5; gate++) {
            key_setup(&w, selectors[k]);
            if (gate == 0) set32(g_self, 0xba7, 0);
            if (gate == 1) g_self[0xbb0] = 1;
            if (gate == 2) set32(g_self, 0xbac, 0x100);   /* a non-zero dword with a zero low byte and word */
            if (gate == 3) set32(g_records, REC + 0x4d, 0);
            if (gate == 4) set32(g_records, REC + 0x4d, 2);
            memcpy(g_exp, g_self, sizeof g_self);
            key_run(&w);
            CK(L.n == 0 && memcmp(g_self, g_exp, sizeof g_self) == 0);
            CK(get32(g_records, REC + 0x4d) == (gate == 3 ? 0u : gate == 4 ? 2u : 1u));
        }
    }
    /* the dword [self+0xba7] is tested as a whole: a value with a zero low byte still passes; and an unknown selector does nothing */
    key_setup(&w, 0x2779);
    set32(g_self, 0xba7, 0x01000000);
    key_run(&w);
    CK(g_self[0xbab] == 1 && get32(g_records, REC + 0x4d) == 2);
    key_setup(&w, 0x2776);
    memcpy(g_exp, g_self, sizeof g_self);
    key_run(&w);
    CK(L.n == 0 && memcmp(g_self, g_exp, sizeof g_self) == 0 && get32(g_records, REC + 0x4d) == 1);
    /* 0x2779: byte [self+0xbab] := 1 and the state := 2, no call */
    key_setup(&w, 0x2779);
    g_self[0xbab] = 0;
    memcpy(g_exp, g_self, sizeof g_self);
    g_exp[0xbab] = 1;
    key_run(&w);
    CK(L.n == 0 && memcmp(g_self, g_exp, sizeof g_self) == 0 && get32(g_records, REC + 0x4d) == 2);
    /* 0x277c: dword [self+0xc2b] := 1 (a dword store), nothing else */
    key_setup(&w, 0x277c);
    memcpy(g_exp, g_self, sizeof g_self);
    set32(g_exp, 0xc2b, 1);
    key_run(&w);
    CK(L.n == 0 && memcmp(g_self, g_exp, sizeof g_self) == 0 && get32(g_records, REC + 0x4d) == 1);
    /* 0x2778 with 0x484622 answering -1 in the low word (the high word is junk): the call only */
    key_setup(&w, 0x2778);
    queue_return(0x484622, 0x1ffff);
    memcpy(g_exp, g_self, sizeof g_self);
    key_run(&w);
    CK(L.n == 1 && is_call(0, 0x484622, (uintptr_t)g_self, 0) && memcmp(g_self, g_exp, sizeof g_self) == 0);
    /* 0x2778 with slot 2 (the high word junk): 0x484622, 0x4853b0 with the word 2, 0x485f12, then [0xa92] := 1, [0xa9e] := 2 and the extent words */
    key_setup(&w, 0x2778);
    queue_return(0x484622, 0x7777u << 16 | 2u);
    set32(g_self, SL(2) + 0, 10);
    set32(g_self, SL(2) + 4, 7);
    set32(g_self, SL(2) + 8, 50);
    set32(g_self, SL(2) + 0xc, 100);
    add_probe(g_self + 0xa90, 0x10);
    memcpy(g_exp, g_self, sizeof g_self);
    set32(g_exp, 0xa92, 1);
    set16(g_exp, 0xa9e, 2);
    set16(g_exp, 0xbc5, 40);
    set16(g_exp, 0xbc7, 93);
    key_run(&w);
    CK(L.n == 3 && is_call(0, 0x484622, (uintptr_t)g_self, 0) && is_call(1, 0x4853b0, (uintptr_t)g_self, 1) && (L.c[1].a[0] & 0xffff) == 2 &&
       is_call(2, 0x485f12, (uintptr_t)g_self, 0));
    CK(get16(L.c[2].probe, 0xe) == 1 && get32(L.c[2].probe, 2) == 0);   /* nothing is stored yet at the calls: slot still 1, [0xa92] still 0 */
    CK(memcmp(g_self, g_exp, sizeof g_self) == 0);
    /* the extent words are the low 16 bits of the dword differences */
    key_setup(&w, 0x2778);
    queue_return(0x484622, 0);
    set32(g_self, SL(0) + 0, 5);
    set32(g_self, SL(0) + 4, 0xfffffff0u);
    set32(g_self, SL(0) + 8, 0x12345u + 5u);
    set32(g_self, SL(0) + 0xc, 0x10);
    key_run(&w);
    CK(get16(g_self, 0xbc5) == 0x2345 && get16(g_self, 0xbc7) == 0x20 && get16(g_self, 0xa9e) == 0 && get32(g_self, 0xa92) == 1);
    /* 0x2777 with the dword [self+0xa92] non-zero: not this branch, and 0x2777 is none of the others: nothing */
    key_setup(&w, 0x2777);
    set32(g_self, 0xa92, 1);
    memcpy(g_exp, g_self, sizeof g_self);
    key_run(&w);
    CK(L.n == 0 && memcmp(g_self, g_exp, sizeof g_self) == 0);
    /* 0x2777 with 0x4846c2 answering -1: the two calls only */
    key_setup(&w, 0x2777);
    queue_return(0x4846c2, 0x2ffff);
    memcpy(g_exp, g_self, sizeof g_self);
    key_run(&w);
    CK(L.n == 2 && is_call(0, 0x485ca1, (uintptr_t)g_self, 0) && is_call(1, 0x4846c2, (uintptr_t)g_self, 0) && memcmp(g_self, g_exp, sizeof g_self) == 0);
    /* 0x2777 with slot 1 and 0x484f0d answering 0: the slot is copied to [0xae0] before the call, the call gets rec + 1 * 0x42 + 0x8f, the
     * slot stays, the extent words come from the slot, [0xa92] := 1 */
    {
        int result;
        for (result = 0; result < 3; result++) {
            key_setup(&w, 0x2777);
            queue_return(0x4846c2, 0x5555u << 16 | 1u);
            queue_return(0x484f0d, result == 0 ? 0u : result == 1 ? 1u : 0x10000u);   /* a dword test: 0x10000 is non-zero */
            add_probe(g_self + 0xa90, 0x10);
            add_probe(g_self + 0xae0, 0x10);
            add_probe(g_self + SL(1), 0x10);
            memcpy(g_exp, g_self, sizeof g_self);
            set16(g_exp, 0xa9e, 1);
            set32(g_exp, 0xa9a, 1);
            memcpy(g_exp + 0xae0, g_self + SL(1), 16);
            if (result != 0) memcpy(g_exp + SL(1), g_rec + 0x42 + 0x8f, 16);
            set16(g_exp, 0xbc5, (uint16_t)(get32(g_exp, SL(1) + 8) - get32(g_exp, SL(1) + 0)));
            set16(g_exp, 0xbc7, (uint16_t)(get32(g_exp, SL(1) + 0xc) - get32(g_exp, SL(1) + 4)));
            set32(g_exp, 0xa92, 1);
            key_run(&w);
            CK(L.n == 3 && is_call(0, 0x485ca1, (uintptr_t)g_self, 0) && is_call(1, 0x4846c2, (uintptr_t)g_self, 0) && is_call(2, 0x484f0d, (uintptr_t)g_self, 1));
            CK(L.c[2].a[0] == REC_VA + 0x42 + 0x8f);
            CK(get16(L.c[2].probe, 0xe) == 1 && get32(L.c[2].probe, 0xa) == 1);              /* [0xa9e], [0xa9a] are set at the call */
            CK(memcmp(L.c[2].probe + 0x10, g_self + 0, 0) == 0 && memcmp(L.c[2].probe + 0x10, L.c[2].probe + 0x20, 16) == 0);   /* [0xae0] = the slot */
            CK(memcmp(g_self, g_exp, sizeof g_self) == 0);
        }
    }
    /* 0x277b: the branch A, selector 0x277b with rec[0x2d] == 0 */
    {
        int variant;
        for (variant = 0; variant < 9; variant++) {
            /* 0: 0x277b, rec[0x2d] == 0 -> A. 1: 0x277b, rec[0x2d] != 0 and the word matches (c25 = 2, word at rec + 0x2e + 4 == 2) -> A.
             * 2: 0x277b, mismatch (word 3), rec[0x23] != 0 -> B. 3: 0x277b, mismatch, rec[0x23] == 0 -> C. 4: 0x277a, rec[0x2d] == 0,
             * rec[0x23] != 0 -> B (the selector 0x277a never takes A). 5: 0x277a, rec[0x23] == 0 -> C. 6: A with c25 = 0xffff (the word wraps to 0).
             * 7: c25 = 0xfffe = -2 is a SIGNED index: the word read is the one at rec + 0x2e - 4 = rec + 0x2a (it equals 2) -> A. 8: the same with the
             * word at rec + 0x2a not 2 -> B (an unsigned index would read 128 KB behind the record). */
            uint32_t sel = (variant == 4 || variant == 5) ? 0x277a : 0x277b;
            int a_branch = variant == 0 || variant == 1 || variant == 6 || variant == 7;
            key_setup(&w, sel);
            set32(g_self, 0xa92, 7);
            set32(g_self, 0xb83, 0x55);
            set16(g_self, 0xc25, 0);
            g_rec[0x2d] = (variant == 0 || variant == 4 || variant == 5 || variant == 6) ? 0 : 1;
            g_rec[0x23] = (variant == 3 || variant == 5) ? 0 : 1;
            if (variant == 1 || variant == 2 || variant == 3) {
                set16(g_self, 0xc25, 2);
                set16(g_rec, 0x2e + 4, variant == 1 ? 2 : 3);
            }
            if (variant == 6) set16(g_self, 0xc25, 0xffff);
            if (variant == 7 || variant == 8) {
                set16(g_self, 0xc25, 0xfffe);
                set16(g_rec, 0x2a, variant == 7 ? 2 : 3);
            }
            add_probe(g_self + 0xa90, 0x10);
            add_probe(g_self + SL(1), 0x84);
            add_probe(g_self + 0xb83, 4);
            add_probe(g_self + 0xc25, 2);
            memcpy(g_exp, g_self, sizeof g_self);
            set32(g_exp, 0xa92, 0);
            set32(g_exp, 0xa96, 1);
            if (a_branch) {
                memcpy(g_exp + SL(1), g_rec + 0x42 + 0x9f, 16);
                g_exp[SL(1) + 0x21] = 1;
                g_exp[SL(1) + 0x82] = 1;
                set32(g_exp, 0xb83, 1);
                set16(g_exp, 0xc25, (uint16_t)(get16(g_self, 0xc25) + 1u));
            } else if (g_rec[0x23] != 0) {
                memcpy(g_exp + SL(1), g_rec + 0x42 + 0xaf, 16);
                g_exp[SL(1) + 0x20] = g_rec[0x42 + 0xbf];
                g_exp[SL(1) + 0x82] = 0;
                set32(g_exp, 0xb83, 0);
            } else {
                memcpy(g_exp + SL(1), g_self + 0xaa0, 16);
                memcpy(g_exp + SL(1) + 0x10, g_self + 0xac0, 16);
                g_exp[SL(1) + 0x82] = 1;
                set32(g_exp, 0xb83, 0);
            }
            set16(g_exp, 0xa9e, 0xffff);
            key_run(&w);
            CK(L.n == (a_branch || g_rec[0x23] != 0 ? 3 : 2));
            CK(is_call(0, 0x485d52, (uintptr_t)g_self, 0));
            /* at 0x485d52 nothing has changed yet */
            CK(get32(L.c[0].probe, 2) == 7 && get32(L.c[0].probe, 6) == 9);
            if (L.n == 3) {
                CK(is_call(1, 0x4841cb, (uintptr_t)g_self, 2) && L.c[1].a[0] == (uintptr_t)(g_self + SL(1)) && L.c[1].a[1] == (uintptr_t)(g_self + SL(1) + 0x10));
                CK(is_call(2, 0x484935, (uintptr_t)g_self, 1) && (L.c[2].a[0] & 0xffff) == 1);
                /* at 0x4841cb: the flags are reset, the slot is already copied; the slot bytes +0x21/+0x20 and +0x82 and [0xb83] are still the old ones */
                CK(get32(L.c[1].probe, 2) == 0 && get32(L.c[1].probe, 6) == 1 && get16(L.c[1].probe, 0xe) == 1);
                CK(memcmp(L.c[1].probe + 0x10, g_exp + SL(1), 16) == 0);
                CK(L.c[1].probe[0x10 + 0x21] == (uint8_t)((SL(1) + 0x21) * 13 + 5) && L.c[1].probe[0x10 + 0x82] == (uint8_t)((SL(1) + 0x82) * 13 + 5));
                CK(get32(L.c[1].probe, 0x94) == 0x55);
                /* at 0x484935 everything is stored but the slot word, which is cleared afterwards */
                CK(get16(L.c[2].probe, 0xe) == 1 && memcmp(L.c[2].probe + 0x10, g_exp + SL(1), 0x84) == 0 && get32(L.c[2].probe, 0x94) == get32(g_exp, 0xb83) &&
                   get16(L.c[2].probe, 0x98) == get16(g_exp, 0xc25));
            } else {
                CK(is_call(1, 0x484935, (uintptr_t)g_self, 1) && (L.c[1].a[0] & 0xffff) == 1 && get16(L.c[1].probe, 0xe) == 1);
            }
            CK(memcmp(g_self, g_exp, sizeof g_self) == 0);
        }
    }
    /* the high bits of a9e are not part of the argument: the argument is the word, zero-extended */
    key_setup(&w, 0x277a);
    g_rec[0x23] = 0;
    set16(g_self, 0xa9e, 0);
    key_run(&w);
    CK(L.n == 2 && (L.c[1].a[0] & 0xffff0000u) == 0 && (L.c[1].a[0] & 0xffff) == 0 && get16(g_self, 0xa9e) == 0xffff);
}

/* ---- 0x44e035 ---------------------------------------------------------------------------------------------------------------- */

typedef struct Pair {
    uint32_t src, dst, konst;
    uint32_t t;              /* the first argument of 0x4c5377 when it is not the table dword (the outline loop) */
} Pair;

static uint8_t g_table[0x4a * 4 + 0x20];

#define TDW 0xaaaa0002u    /* the dword of the table record 2 */
#define V665 0xc0de0665u
#define V5E3 0xc0de15e3u

static void panel_setup(Fl21bWorld *w, uint32_t mode, uint32_t sub)
{
    int i;
    memset(w, 0, sizeof *w);
    memset(g_records, 0, sizeof g_records);
    memset(g_table, 0x11, sizeof g_table);
    set32(g_records, 2 * REC, REC_VA);
    set32(g_table, 0x4a * 1, 0xaaaa0001u);
    set32(g_table, 0x4a * 2, TDW);
    w->records_5bb5e5 = g_records;
    w->table_5d1599 = g_table;
    w->word_624cdd = 2;
    w->word_624cdb = 2;
    w->value_5cf665 = V665;
    w->value_5d15e3 = V5E3;
    w->value_624cec = mode;
    w->value_624cf0 = sub;
    w->word_624cf4 = 3;
    w->word_624cf6 = 2;
    w->value_624cf8 = 1;
    w->word_624cfc = 5;
    w->word_624cfe = 4;
    w->value_624d00 = 0;
    w->value_624d04 = 0;
    w->byte_624ce3 = 0x77;
    reset_log();
    /* 0x44d9b5 writes the first and the fourth dword of the rectangle through its second argument, a different value in every call */
    for (i = 0; i < 10; i++) {
        queue_write(0x44d9b5, i, 1, 0, 4, 0x1000u + (uint32_t)i);
        queue_write(0x44d9b5, i, 1, 12, 4, 0x2000u + (uint32_t)i);
    }
}

/* the calls 2k (0x44d9b5) and 2k + 1 (0x4c5377) of every pair, in order */
static int check_pairs(const Pair *p, int n)
{
    int k;
    uintptr_t rp = 0;
    if (L.n != 2 * n) return 0;
    for (k = 0; k < n; k++) {
        const Call *a = &L.c[2 * k], *b = &L.c[2 * k + 1];
        uint32_t prev0 = k == 0 ? 0u : 0x1000u + (uint32_t)(k - 1), prev3 = k == 0 ? 0u : 0x2000u + (uint32_t)(k - 1);
        if (!is_call(2 * k, 0x44d9b5, 0x624cbf, 2) || !is_call(2 * k + 1, 0x4c5377, 0x5cf659, 5)) return 0;
        if (a->a[0] != (uintptr_t)(REC_VA + p[k].src)) return 0;
        if (rp == 0) rp = a->a[1];
        if (a->a[1] != rp || b->a[3] != rp || rp < 0x100000000ull) return 0;
        /* the rectangle as the first callee receives it (the previous pair's) and as the second callee sees it */
        if (get32(a->pd[1], 0) != prev0 || get32(a->pd[1], 4) != 0 || get32(a->pd[1], 8) != 0 || get32(a->pd[1], 12) != prev3) return 0;
        if (get32(b->pd[3], 0) != 0x1000u + (uint32_t)k || get32(b->pd[3], 4) != 0 || get32(b->pd[3], 8) != 0 || get32(b->pd[3], 12) != 0x2000u + (uint32_t)k) return 0;
        if (b->a[0] != (p[k].t != 0 ? p[k].t : TDW) || b->a[1] != V665 || b->a[2] != (uintptr_t)(REC_VA + p[k].dst) || b->a[4] != p[k].konst) return 0;
    }
    return 1;
}

static void panel_run(Fl21bWorld *w)
{
    Fl18Host h = host();
    m44e035_draw_panel(w, &h);
}

static void test_m44e035_draw_panel(void)
{
    Fl21bWorld w;
    int k;
    /* plain (mode 0), flag set: the four standard parts; a = 3, b = 2 -> 0x131 and 0xe1 */
    panel_setup(&w, 0, 0);
    {
        static const Pair p[] = {{0x41, 0x1c1, 0x549614, 0}, {0xb1, 0x241, 0x54962c, 0}, {0x31, 0x131, 0x549660, 0}, {0x21, 0xe1, 0x54967c, 0}};
        add_probe(&w.value_624d04, 4);
        add_probe(&w.byte_624ce3, 1);
        panel_run(&w);
        CK(check_pairs(p, 4));
        CK(w.byte_624ce3 == 0 && w.value_624d04 == 0);
        CK(L.c[0].probe[4] == 0x77 && L.c[7].probe[4] == 0x77);   /* the byte is cleared last */
    }
    /* plain, flag clear: the other pair of the first part */
    panel_setup(&w, 0, 0);
    w.value_624cf8 = 0;
    {
        static const Pair p[] = {{0x41, 0x1d1, 0x549620, 0}, {0xb1, 0x241, 0x54962c, 0}, {0x31, 0x131, 0x549660, 0}, {0x21, 0xe1, 0x54967c, 0}};
        panel_run(&w);
        CK(check_pairs(p, 4) && w.byte_624ce3 == 0);
    }
    /* mode 8 is plain as well; the flag is a dword: a value with a zero low word still counts */
    panel_setup(&w, 8, 0);
    w.value_624cf8 = 0x10000;
    {
        static const Pair p[] = {{0x41, 0x1c1, 0x549614, 0}, {0xb1, 0x241, 0x54962c, 0}, {0x31, 0x131, 0x549660, 0}, {0x21, 0xe1, 0x54967c, 0}};
        panel_run(&w);
        CK(check_pairs(p, 4));
    }
    /* mode 1, 3, 7, 9 and 0x80000000 are not plain: the second selector pair (cfc, cfe) and flag (d00), and the other part-2 record */
    {
        static const uint32_t modes[] = {1, 3, 7, 9, 0x80000000u, 0x100};
        for (k = 0; k < 6; k++) {
            int flag;
            for (flag = 0; flag < 2; flag++) {
                panel_setup(&w, modes[k], 8);   /* (the sub-mode only matters for mode 2) */
                w.value_624d00 = flag ? 0x20000u : 0;
                w.value_624cf8 = flag ? 0 : 1;
                {
                    Pair p[4];
                    p[0].src = 0x41; p[0].dst = flag ? 0x1c1 : 0x1d1; p[0].konst = flag ? 0x549614 : 0x549620; p[0].t = 0;
                    p[1].src = 0xb1; p[1].dst = 0x251; p[1].konst = 0x549644; p[1].t = 0;
                    p[2].src = 0x31; p[2].dst = 0x151; p[2].konst = 0x549660; p[2].t = 0;    /* 5 * 16 + 0x101 */
                    p[3].src = 0x21; p[3].dst = 0x101; p[3].konst = 0x54967c; p[3].t = 0;    /* 4 * 16 + 0xc1 */
                    panel_run(&w);
                    CK(check_pairs(p, 4) && w.byte_624ce3 == 0);
                }
            }
        }
    }
    /* mode 2: plain only when the sub-mode is 8 (then the extra pair 0x81 / 0x211 follows); otherwise the switch on the sub-mode */
    {
        static const uint32_t subs[] = {8, 1, 0, 6, 3, 4, 2, 5, 7, 9, 0x100, 0x80000008u, 0xffffffffu};
        for (k = 0; k < 13; k++) {
            Pair p[5];
            int n = 4;
            int plain = subs[k] == 8;
            panel_setup(&w, 2, subs[k]);
            w.value_624d04 = 5;   /* never touched in mode 2 */
            p[0].src = 0x41; p[0].dst = 0x1c1; p[0].konst = 0x549614; p[0].t = 0;
            p[1].src = 0xb1; p[1].dst = plain ? 0x241 : 0x251; p[1].konst = plain ? 0x54962c : 0x549644; p[1].t = 0;
            p[2].src = 0x31; p[2].dst = plain ? 0x131 : 0x151; p[2].konst = 0x549660; p[2].t = 0;
            p[3].src = 0x21; p[3].dst = plain ? 0xe1 : 0x101; p[3].konst = 0x54967c; p[3].t = 0;
            if (!plain) {
                w.value_624d00 = 0;    /* flag from d00: clear -> 0x1d1 */
                p[0].dst = 0x1d1;
                p[0].konst = 0x549620;
            }
            switch (subs[k]) {
            case 8: p[4].src = 0x81; p[4].dst = 0x211; p[4].konst = 0x54969c; n = 5; break;
            case 1: p[4].src = 0x61; p[4].dst = 0x1f1; p[4].konst = 0x5496b0; n = 5; break;
            case 0: p[4].src = 0x51; p[4].dst = 0x1e1; p[4].konst = 0x5496c8; n = 5; break;
            case 6: p[4].src = 0x71; p[4].dst = 0x201; p[4].konst = 0x5496e0; n = 5; break;
            case 3: p[4].src = 0x91; p[4].dst = 0x221; p[4].konst = 0x5496f8; n = 5; break;
            case 4: p[4].src = 0xa1; p[4].dst = 0x231; p[4].konst = 0x549714; n = 5; break;
            default: break;
            }
            p[4].t = 0;
            panel_run(&w);
            CK(check_pairs(p, n));
            CK(w.value_624d04 == 5 && w.byte_624ce3 == 0);
        }
    }
    /* mode not 2 and the redraw flag set: the six outline pairs with the dword 0x5d15e3, then the flag is cleared (it is still set at every call) */
    {
        static const uint32_t modes[] = {0, 1, 8, 4};
        for (k = 0; k < 4; k++) {
            Pair p[10];
            static const uint32_t offs[6] = {0x81, 0x61, 0x51, 0x71, 0x91, 0xa1};
            static const uint32_t konsts[6] = {0x549730, 0x54973c, 0x54974c, 0x54975c, 0x54976c, 0x549780};
            int plain = modes[k] == 0 || modes[k] == 8, j;
            panel_setup(&w, modes[k], 0);
            w.value_624d04 = 0x30000;
            add_probe(&w.value_624d04, 4);
            w.value_624d00 = 1;
            p[0].src = 0x41; p[0].dst = plain ? 0x1c1 : 0x1c1; p[0].konst = 0x549614; p[0].t = 0;
            p[1].src = 0xb1; p[1].dst = plain ? 0x241 : 0x251; p[1].konst = plain ? 0x54962c : 0x549644; p[1].t = 0;
            p[2].src = 0x31; p[2].dst = plain ? 0x131 : 0x151; p[2].konst = 0x549660; p[2].t = 0;
            p[3].src = 0x21; p[3].dst = plain ? 0xe1 : 0x101; p[3].konst = 0x54967c; p[3].t = 0;
            for (j = 0; j < 6; j++) {
                p[4 + j].src = offs[j];
                p[4 + j].dst = offs[j];
                p[4 + j].konst = konsts[j];
                p[4 + j].t = V5E3;
            }
            panel_run(&w);
            CK(check_pairs(p, 10));
            CK(w.value_624d04 == 0 && w.byte_624ce3 == 0);
            for (j = 0; j < L.n; j++) CK(get32(L.c[j].probe, 0) == 0x30000u);
        }
    }
    /* the selectors are signed words: a = 0xfffe is -2, b = 0x8000 is -32768 (the shift and the add wrap in 32 bits) */
    panel_setup(&w, 0, 0);
    w.word_624cf4 = 0xfffe;
    w.word_624cf6 = 0x8000;
    {
        Pair p[4];
        p[0].src = 0x41; p[0].dst = 0x1c1; p[0].konst = 0x549614; p[0].t = 0;
        p[1].src = 0xb1; p[1].dst = 0x241; p[1].konst = 0x54962c; p[1].t = 0;
        p[2].src = 0x31; p[2].dst = 0xe1; p[2].konst = 0x549660; p[2].t = 0;
        p[3].src = 0x21; p[3].dst = 0xfff800c1u; p[3].konst = 0x54967c; p[3].t = 0;
        panel_run(&w);
        CK(check_pairs(p, 4));
    }
    /* other record and table indices: record 1's address and table record 1 */
    panel_setup(&w, 0, 0);
    set32(g_records, 1 * REC, 0x00ee0000u);
    w.word_624cdd = 1;
    w.word_624cdb = 1;
    panel_run(&w);
    CK(L.n == 8 && L.c[0].a[0] == 0x00ee0000u + 0x41 && L.c[1].a[0] == 0xaaaa0001u && L.c[1].a[2] == 0x00ee0000u + 0x1c1);
}

/* ---- 0x44da08 ---------------------------------------------------------------------------------------------------------------- */

static uint8_t g_tab[0x20 + 0x4a * 4 + 0x80], g_exptab[sizeof g_tab], g_flags[0x100], g_expfl[0x100], g_consts[0x60];
#define TAB(n) ((size_t)0x20 + (size_t)(n) * 0x4a)   /* offset of the entry n in g_tab (0x20 bytes of slack below) */

/* record `index` is the object g_rec in the given state; self, the record object, the table and the flag table are filled with byte patterns so
 * that every copy can be told from its source; the world globals hold recognisable values. The nine-byte constants are "ABCDEFGHI" (0x5495f0),
 * "JKLMNOPQR" (0x5495fc) and "STUVWXYZ0" (0x549608); the string at 0x5495bc is "hello". */
static void run_setup(Fl21bWorld *w, int16_t index, uint32_t state)
{
    size_t i;
    for (i = 0; i < sizeof g_self; i++) g_self[i] = (uint8_t)(i * 13 + 5);
    for (i = 0; i < sizeof g_rec; i++) g_rec[i] = (uint8_t)(i * 7 + 3);
    for (i = 0; i < sizeof g_tab; i++) g_tab[i] = (uint8_t)(i * 3 + 1);
    for (i = 0; i < sizeof g_flags; i++) g_flags[i] = (uint8_t)(i * 5 + 2);
    memset(g_consts, 0, sizeof g_consts);
    strcpy((char *)g_consts, "hello");
    memcpy(g_consts + 0x34, "ABCDEFGHI", 9);
    memcpy(g_consts + 0x40, "JKLMNOPQR", 9);
    memcpy(g_consts + 0x4c, "STUVWXYZ0", 9);
    memset(g_records, 0, sizeof g_records);
    set32(g_records, (size_t)index * REC, REC_VA);
    set32(g_records, (size_t)index * REC + 0x4d, state);
    memset(w, 0, sizeof *w);
    w->records_5bb5e5 = g_records;
    w->table_5d1599 = g_tab + 0x20;
    w->flags_585801 = g_flags + 0x40;
    w->bytes_5495bc = g_consts;
    w->bytes_5495f0 = g_consts + 0x34;
    w->bytes_5495fc = g_consts + 0x40;
    w->bytes_549608 = g_consts + 0x4c;
    w->value_5bb1ca = 0x55;
    w->value_5bb57b = 0x5557;
    w->value_5bb59b = 0x559b;
    w->value_5bb59f = 0x559f;
    w->value_5bb5a3 = 0x55a3;
    w->value_583999 = 0x5599;
    w->word_5bb599 = 0x1111;
    w->word_5bb595 = 0x2222;
    w->word_5c39ff = 0x3333;
    set16(g_self, 0x1e, index);
    reset_log();
    add_region(REC_VA, g_rec, sizeof g_rec);
}

static void snap(void)
{
    memcpy(g_exp, g_self, sizeof g_self);
    memcpy(g_exptab, g_tab, sizeof g_tab);
    memcpy(g_expfl, g_flags, sizeof g_flags);
}

static int same(void)
{
    return memcmp(g_self, g_exp, sizeof g_self) == 0 && memcmp(g_tab, g_exptab, sizeof g_tab) == 0 && memcmp(g_flags, g_expfl, sizeof g_flags) == 0;
}

static void state_run(Fl21bWorld *w, int16_t index)
{
    Fl18Host h = host();
    m44da08_run_state(g_self, index, w, &h);
}

static void test_m44da08_run_state(void)
{
    Fl21bWorld w;
    int k, pos;
    /* ---- state 0 (the entry table[2] is the one that 0x4d39f9 names) ---- */
    for (k = 0; k < 2; k++) {
        for (pos = 0; pos <= 9; pos++) {
            int differs = pos < 9;
            size_t e = TAB(2);
            int calls = 2 + (k == 0 ? 1 : 0) + (differs ? 1 : 0), n = 0;
            uint32_t slot20 = k == 0 ? 0u : 0x13572468u, result20 = k == 0 ? 0xdeadbeefu : 0x13572468u;
            run_setup(&w, 1, 0);
            set16(g_self, 0x1e, 0x7f7f);
            set32(g_self, 0x20, slot20);
            memcpy(g_consts + 0x34, g_rec + 0x265, 9);
            if (differs) g_consts[0x34 + pos] ^= 0x40;
            queue_return(0x4d39f9, 0x31230002u);   /* the word 2 with a junk high word */
            queue_return(0x4c2790, 0xdeadbeefu);
            add_probe(g_self + 0x1c, 0x34);            /* +0x1c .. +0x4f */
            add_probe(&w.value_5bb1ca, 4);             /* at 0x34 */
            add_probe(g_tab + e - 8, 0x30);            /* at 0x38; the entry starts at 0x40 */
            add_probe(g_records + REC + 0x4d, 4);      /* at 0x68 */
            snap();
            set16(g_exp, 0x1e, 1);
            set32(g_exp, 0x25, 1);
            g_exp[0x24] = 1;
            set32(g_exp, 0x45, 0);
            set32(g_exp, 0x2d, 0);
            set32(g_exp, 0x29, 0);
            set16(g_exp, 0x1c, 2);
            set32(g_exp, 0x20, result20);
            g_exp[0x4a] = 0;
            g_exp[0x49] = 0;
            set32(g_exptab, e - 8, 0xa);
            set32(g_exptab, e - 4, 0x44e035);
            set32(g_exptab, e + 0, result20);
            set32(g_exptab, e + 4, 0);
            set32(g_exptab, e + 8, 0);
            set32(g_exptab, e + 0xc, 1);
            set32(g_exptab, e + 0x10, 1);
            set16(g_exptab, e + 0x14, 0);
            memcpy(g_exptab + e + 0x1a, "hello", 6);
            state_run(&w, 1);
            CK(L.n == calls);
            CK(is_call(n, 0x44d711, (uintptr_t)g_self, 0));
            /* at 0x44d711: the index, [0x25] set, the rest still as it was */
            CK(get16(L.c[n].probe, 2) == 1 && get32(L.c[n].probe, 9) == 1 && L.c[n].probe[8] == (uint8_t)(0x24 * 13 + 5) && get32(L.c[n].probe, 0x34) == 0x55);
            n++;
            CK(is_call(n, 0x4d39f9, 0, 0));
            CK(L.c[n].probe[8] == 1 && get32(L.c[n].probe, 0x34) == 1 && get32(L.c[n].probe, 0x11) == 0 && get32(L.c[n].probe, 0x29) == 0 && get32(L.c[n].probe, 0xd) == 0);
            CK(L.c[n].probe[0] == (uint8_t)(0x1c * 13 + 5) && L.c[n].probe[1] == (uint8_t)(0x1d * 13 + 5));   /* the table word is not stored yet */
            n++;
            if (k == 0) {
                CK(is_call(n, 0x4c2790, 0x5cf659, 4));
                CK(L.c[n].a[0] == 0x5495e8 && L.c[n].a[1] == REC_VA && L.c[n].a[2] == 6 && L.c[n].a[3] == 0x5495d4);
                CK(get16(L.c[n].probe, 0) == 2 && get32(L.c[n].probe, 4) == 0);   /* [0x1c] stored, [0x20] still 0 */
                CK(memcmp(L.c[n].probe + 0x38, g_exptab + e - 8, 8) == 0 && get32(L.c[n].probe, 0x40) == 0);   /* the entry is set up, E+0 is 0 */
                CK(memcmp(L.c[n].probe + 0x38 + 8 + 0x1a, "hello", 6) == 0 && get32(L.c[n].probe, 0x38 + 8 + 0xc) == 1);
                n++;
            }
            if (differs) {
                CK(is_call(n, 0x4fb77a, 0x5c3a67, 1) && L.c[n].a[0] == REC_VA + 0x265);
                CK(get32(L.c[n].probe, 0x40) == result20 && get32(L.c[n].probe, 4) == result20);   /* E+0 and [0x20] are stored */
                CK(get32(L.c[n].probe, 0x68) == 0 && L.c[n].probe[0x2d] == (uint8_t)(0x49 * 13 + 5));   /* the state and [0x49] are written after */
            }
            CK(same());
            CK(get32(g_records, REC + 0x4d) == 1);
            CK(w.value_5bb1ca == 1);
        }
    }
    /* state 0 for the record 0 (another record), index 0: the same stores through the word index */
    run_setup(&w, 0, 0);
    set32(g_self, 0x20, 5);
    memcpy(g_consts + 0x34, g_rec + 0x265, 9);
    queue_return(0x4d39f9, 0);
    state_run(&w, 0);
    CK(L.n == 2 && get16(g_self, 0x1e) == 0 && get32(g_records, 0x4d) == 1 && get32(g_tab, TAB(0) + 0) == 5 && get32(g_tab, TAB(0) - 8) == 0xa);
    /* ---- state 1, the dword [self+0x2d] ---- */
    for (k = 0; k < 2; k++) {   /* 0 and 1 */
        run_setup(&w, 1, 1);
        set32(g_self, 0x2d, (uint32_t)k);
        g_self[0x24] = 0;
        snap();
        g_exp[0x24] = 1;
        state_run(&w, 1);
        CK(L.n == 0 && same() && get32(g_records, REC + 0x4d) == 1);
    }
    {   /* 2: tick >= [0x4b] (unsigned) */
        static const uint32_t tv[][3] = {{1000, 1000, 1}, {999, 1000, 0}, {1001, 1000, 1}, {0x80000000u, 0x7fffffffu, 1}, {1, 0xffffffffu, 0}, {0, 0, 1}, {0xffffffffu, 0x80000000u, 1}};
        for (k = 0; k < 7; k++) {
            run_setup(&w, 1, 1);
            set32(g_self, 0x2d, 2);
            set32(g_self, 0x4b, tv[k][1]);
            set32(g_self, 0x31, 0x9abcdef0u);
            L.tick = tv[k][0];
            snap();
            if (tv[k][2]) {
                set32(g_exp, 0x2d, 0x9abcdef0u);
                set32(g_exp, 0x45, 1);
            }
            state_run(&w, 1);
            CK(L.n == 1 && is_tick(0) && same() && get32(g_records, REC + 0x4d) == 1);
        }
    }
    for (k = 3; k <= 4; k++) {   /* 3 and 4: 0x44d8ad on self with 1 / 0, then [0x24] := 1, [0x2d] := 1 */
        run_setup(&w, 1, 1);
        set32(g_self, 0x2d, (uint32_t)k);
        g_self[0x24] = 0;
        add_probe(g_self + 0x24, 1);
        add_probe(g_self + 0x2d, 4);
        snap();
        g_exp[0x24] = 1;
        set32(g_exp, 0x2d, 1);
        state_run(&w, 1);
        CK(L.n == 1 && is_call(0, 0x44d8ad, (uintptr_t)g_self, 1) && L.c[0].a[0] == (k == 3 ? 1u : 0u));
        CK(L.c[0].probe[0] == 0 && get32(L.c[0].probe, 1) == (uint32_t)k && same());
    }
    {   /* 5: tick >= [0x4f]; the nine bytes at rec+0x2b1 against "JKLMNOPQR" */
        static const uint32_t tv[][3] = {{50, 50, 1}, {49, 50, 0}, {0x80000000u, 0x7fffffffu, 1}, {2, 0xfffffff0u, 0}};
        int diff;
        for (k = 0; k < 4; k++) {
            for (diff = 0; diff <= 9; diff++) {
                run_setup(&w, 1, 1);
                set32(g_self, 0x2d, 5);
                set32(g_self, 0x4f, tv[k][1]);
                L.tick = tv[k][0];
                memcpy(g_consts + 0x40, g_rec + 0x2b1, 9);
                if (diff < 9) g_consts[0x40 + diff] ^= 1;
                set16(g_rec, 0x2d2, 0xfff9);
                add_probe(g_self + 0x2d, 4);
                snap();
                if (tv[k][2]) {
                    if (diff < 9) set32(g_exp, 0x2d, 7);
                }
                state_run(&w, 1);
                if (!tv[k][2]) {
                    CK(L.n == 1 && is_tick(0) && same() && get32(g_records, REC + 0x4d) == 1);
                } else if (diff < 9) {
                    CK(L.n == 3 && is_tick(0) && is_call(1, 0x4fb77a, 0x5c3a67, 1) && L.c[1].a[0] == REC_VA + 0x2b1);
                    CK(is_call(2, 0x4fb2e3, 0x5c3a67, 1) && (L.c[2].a[0] & 0xffff) == 0xfff9 && get32(L.c[1].probe, 0) == 5);
                    CK(same() && get32(g_records, REC + 0x4d) == 1);
                } else {
                    CK(L.n == 1 && is_tick(0) && same() && get32(g_records, REC + 0x4d) == 2);
                }
            }
        }
    }
    {   /* 6: [0x4f] := tick + (signed word [rec+0x2af]) * 1000, [0x4a] := 1, [0x2d] := 5 */
        static const uint16_t words[] = {5, 0xfffd, 0x7fff, 0x8000, 0};
        for (k = 0; k < 5; k++) {
            run_setup(&w, 1, 1);
            set32(g_self, 0x2d, 6);
            g_self[0x4a] = 0;
            L.tick = 0xfffffc00u;
            set16(g_rec, 0x2af, words[k]);
            snap();
            set32(g_exp, 0x4f, 0xfffffc00u + (uint32_t)((int32_t)(int16_t)words[k] * 1000));
            g_exp[0x4a] = 1;
            set32(g_exp, 0x2d, 5);
            state_run(&w, 1);
            CK(L.n == 1 && is_tick(0) && same() && get32(g_records, REC + 0x4d) == 1);
        }
    }
    {   /* 7: 0x4f6334 on 0x5cf1eb with the sign-extended word [rec+0x2d2]; a zero result: 0x4fba69, state := 2 */
        static const uint32_t results[] = {0, 1, 0x10000, 0x80000000u};
        static const uint16_t words[] = {0xfffd, 7, 0x8000};
        int j;
        for (k = 0; k < 4; k++) {
            for (j = 0; j < 3; j++) {
                run_setup(&w, 1, 1);
                set32(g_self, 0x2d, 7);
                set16(g_rec, 0x2d2, words[j]);
                queue_return(0x4f6334, results[k]);
                snap();
                state_run(&w, 1);
                if (results[k] == 0) {
                    CK(L.n == 2 && is_call(1, 0x4fba69, 0x5c3a67, 1) && L.c[1].a[0] == REC_VA + 0x2b1 && get32(g_records, REC + 0x4d) == 2);
                } else {
                    CK(L.n == 1 && get32(g_records, REC + 0x4d) == 1);
                }
                CK(is_call(0, 0x4f6334, 0x5cf1eb, 1) && L.c[0].a[0] == (uint32_t)(int32_t)(int16_t)words[j] && same());
            }
        }
    }
    run_setup(&w, 1, 1);   /* 8: [0x49] := 1, state := 2 */
    set32(g_self, 0x2d, 8);
    g_self[0x49] = 0;
    snap();
    g_exp[0x49] = 1;
    state_run(&w, 1);
    CK(L.n == 0 && same() && get32(g_records, REC + 0x4d) == 2);
    {   /* anything above 8 does nothing */
        static const uint32_t others[] = {9, 0x10, 0x100, 0xffffffffu, 0x80000000u, 0x12};
        for (k = 0; k < 6; k++) {
            run_setup(&w, 1, 1);
            set32(g_self, 0x2d, others[k]);
            snap();
            state_run(&w, 1);
            CK(L.n == 0 && same() && get32(g_records, REC + 0x4d) == 1 && w.value_5bb1ca == 0x55);
        }
    }
    /* any other state does nothing: 3, 4, 0xffffffff, 0x80000000, 0x100 */
    {
        static const uint32_t states[] = {3, 4, 0xffffffffu, 0x80000000u, 0x100};
        for (k = 0; k < 5; k++) {
            run_setup(&w, 1, states[k]);
            set32(g_self, 0x2d, 2);
            snap();
            state_run(&w, 1);
            CK(L.n == 0 && same() && get32(g_records, REC + 0x4d) == states[k] && w.value_5bb1ca == 0x55);
        }
    }
    /* ---- state 2 ---- */
    {
        int v49, v4a, equal, selv, flagw, idxv;
        static const int16_t sels[] = {0x270f, -5};
        static const int16_t flagws[] = {1, 0};
        static const int16_t idxs[] = {-1, 3, -3};
        for (v49 = 0; v49 < 2; v49++)
            for (v4a = 0; v4a < 2; v4a++)
                for (equal = 0; equal < 2; equal++)
                    for (selv = 0; selv < 2; selv++)
                        for (flagw = 0; flagw < 2; flagw++)
                            for (idxv = 0; idxv < 3; idxv++) {
                                size_t base = v49 ? 0x2e2 : 0x296;
                                int assigned = (v49 || v4a) && sels[selv] != 0x270f;
                                int n = 0;
                                Fl21bWorld w0;
                                run_setup(&w, 1, 2);
                                g_self[0x49] = (uint8_t)v49;
                                g_self[0x4a] = (uint8_t)v4a;
                                if (equal) memcpy(g_consts + 0x4c, g_rec + 0x265, 9);
                                set16(g_rec, 0x2e2, (uint16_t)sels[selv]);
                                set16(g_rec, 0x296, (uint16_t)sels[selv]);
                                set16(g_rec, 0x2f6, (uint16_t)flagws[flagw]);
                                set16(g_rec, 0x2aa, (uint16_t)flagws[flagw]);
                                set16(g_rec, 0x2f8, (uint16_t)idxs[idxv]);
                                set16(g_rec, 0x2ac, (uint16_t)idxs[idxv]);
                                add_probe(&w.value_5bb1ca, 4);
                                add_probe(&w.value_583999, 4);
                                w0 = w;
                                snap();
                                if ((v49 || v4a) && idxs[idxv] != -1) set32(g_expfl, 0x40 + (size_t)(idxs[idxv] * 4), g_rec[base + 0x18]);
                                state_run(&w, 1);
                                if (!equal) {
                                    CK(is_call(n, 0x4fba69, 0x5c3a67, 1) && L.c[n].a[0] == REC_VA + 0x265 && get32(L.c[n].probe, 0) == 1 && get32(L.c[n].probe, 4) == 0x5599);
                                    n++;
                                }
                                if (!v49 && v4a) {
                                    CK(is_call(n, 0x44d946, (uintptr_t)g_self, 0) && get32(L.c[n].probe, 0) == 1 && get32(L.c[n].probe, 4) == 0x5599);
                                    n++;
                                }
                                CK(is_call(n, 0x42ba3a, 0, 1) && (L.c[n].a[0] & 0xffff) == 1);
                                CK(get32(L.c[n].probe, 0) == (assigned ? (get16(g_rec, base + 0x14) == 1 ? 0u : 1u) : 1u) && get32(L.c[n].probe, 4) == (assigned ? 4u : 0x5599u));
                                n++;
                                CK(is_call(n, 0x44d154, (uintptr_t)g_self, 0));
                                n++;
                                CK(L.n == n);
                                CK(same());
                                CK(w.value_5bb1ca == (assigned ? (get16(g_rec, base + 0x14) == 1 ? 0u : 1u) : 1u));
                                CK(w.value_583999 == (assigned ? 4u : 0x5599u));
                                CK(w.value_5bb57b == (assigned ? (uint32_t)(int32_t)(int16_t)get16(g_rec, base) : w0.value_5bb57b));
                                CK(w.word_5bb599 == (assigned ? get16(g_rec, base + 2) : w0.word_5bb599));
                                CK(w.word_5bb595 == (assigned ? get16(g_rec, base + 4) : w0.word_5bb595));
                                CK(w.word_5c39ff == (assigned ? get16(g_rec, base + 6) : w0.word_5c39ff));
                                CK(w.value_5bb59b == (assigned ? get32(g_rec, base + 8) : w0.value_5bb59b));
                                CK(w.value_5bb59f == (assigned ? get32(g_rec, base + 0xc) : w0.value_5bb59f));
                                CK(w.value_5bb5a3 == (assigned ? get32(g_rec, base + 0x10) : w0.value_5bb5a3));
                                CK(get32(g_records, REC + 0x4d) == 2);
                            }
    }
    /* the word argument of 0x42ba3a is the word [self+0x1e], a different value from the argument index: the stores use the word, the call too */
    run_setup(&w, 1, 2);
    set16(g_self, 0x1e, 0xfffe);
    set16(g_rec, 0x2f8, 0xffff);   /* no flag-table store (the patterned index would address far outside the table) */
    memcpy(g_consts + 0x4c, g_rec + 0x265, 9);
    state_run(&w, 1);
    CK(L.n == 2 && (L.c[0].a[0] & 0xffff) == 0xfffe);
}

/* TESTS-CONTINUE */

int main(void)
{
    int failures = 0;
    RUN(test_m4468fe_draw_clock);
    RUN(test_m47f421_pointer_hit);
    RUN(test_m48569e_handle_key);
    RUN(test_m44e035_draw_panel);
    RUN(test_m44da08_run_state);
    /* RUN-END */
    return failures;
}
