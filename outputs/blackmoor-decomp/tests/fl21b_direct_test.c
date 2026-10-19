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
}

/* TESTS-CONTINUE */

int main(void)
{
    int failures = 0;
    RUN(test_m4468fe_draw_clock);
    RUN(test_m47f421_pointer_hit);
    /* RUN-END */
    return failures;
}
