/* FL-20 (batch b) direct tests of the functions of GAME.EXE in src/original_methods_fl20b.c. Prints "PASS <name>" / "FAIL <name>: <msg>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values come from the disassembly of
 * GAME.EXE, not from running the native code; tests/test_fl20b_differential.py additionally runs the original bytes on random fixtures.
 *   0x446688  gates dwords 0x638607 / 0x63860f; strings new 0x63885f vs old 0x63887d: when they differ the old digits are drawn with 0x4c5377 (0x5d15e3, 0x5cf665, &p, &q, 0x548288); then the new digits with 0x4c5d4b (table dword, 0x5cf665, 0x6386bf + d*16, &q, 0x5482b4); strcpy(old, new)
 *   0x48d5f4  gates dword [this+0x33], dword [this+0x2b] == 1, record +0x4d == 1; 0x5c39e5 == 0x2766 -> byte [this+0x37] := 1, record +0x4d := 2; == 0x2765 -> word shifts of [this+0x3d..], strcpy rec+0x715 from rec+word[this+0x27]*0x42+0x337, 0x4f6334 / 0x4fb77a / 0x4fb2e3 / tick, then 0x423259 -> string + dword 0x54e898 -> 0x448d11
 *   0x48d5f4  gates dword [this+0x33], dword [this+0x2b] == 1, record +0x4d == 1; 0x5c39e5 == 0x2766 -> byte [this+0x37] := 1, record +0x4d := 2; == 0x2765 -> word shifts of [this+0x3d..], strcpy rec+0x715 from rec+word[this+0x27]*0x42+0x337, 0x4f6334 / 0x4fb77a / 0x4fb2e3 / tick, then 0x423259 -> string + dword 0x54e898 -> 0x448d11
 */
#include "../src/original_methods_fl20b.h"

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
    uintptr_t a[8];
    uint8_t snap[32];       /* the bytes behind args[snap_arg] of the callee snap_callee, when asked for */
    uint8_t snap2[32];      /* ... and behind args[snap_arg2] (when snap_arg2 >= 0) */
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
    OutWrite w[16];
    int nw;
    int calls_of[16];       /* per callee slot: how many calls were made (for OutWrite.call) */
    uint32_t calls_callee[16];
    Region regions[8];
    int nregions;
    uint32_t tick;
    int ticks;
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
        for (k = 0; k < nargs && k < 8; k++) c->a[k] = args[k];
        if (callee == L.snap_callee && L.snap_len > 0) {
            memcpy(c->snap, (const void *)args[L.snap_arg], (size_t)L.snap_len);
            if (L.snap_arg2 > 0) memcpy(c->snap2, (const void *)args[L.snap_arg2], (size_t)L.snap_len);
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

#define B(a) ((a)-0x638600u)

static void blk_setup(uint8_t *blk, const char *old_text, const char *new_text)
{
    int d;
    memset(blk, 0, 0x400);
    set32(blk, B(0x638607), 1);
    set32(blk, B(0x63860f), 1);
    for (d = 0; d < 10; d++) {
        set32(blk, B(0x638617) + (size_t)d * 4, 20 + 3 * (uint32_t)d);  /* widths */
        set32(blk, B(0x63863f) + (size_t)d * 4, 30 + (uint32_t)d);      /* heights */
    }
    set32(blk, B(0x638613), 7);   /* the width of the digit -1 ('/') */
    set32(blk, B(0x63875f), 100);
    set32(blk, B(0x638763), 200);
    set32(blk, B(0x638767), 4);
    set32(blk, B(0x63876f), 1);
    strcpy((char *)blk + B(0x63887d), old_text);
    strcpy((char *)blk + B(0x63885f), new_text);
}

static void test_m446688_draw_digits(void)
{
    static uint8_t blk[0x400], expect[0x400], table[0x4a * 3];
    Fl20bWorld w;
    Fl18Host h = host();
    uint32_t qx, i;
    memset(&w, 0, sizeof w);
    memset(table, 0, sizeof table);
    set32(table, 0, 0xabc00000u);
    set32(table, 0x4a, 0xabc00001u);
    w.block_638600 = blk;
    w.table_5d1599 = table;
    w.origin_x_583186 = 5;
    w.origin_y_58318a = 7;
    w.value_5cf665 = 0xc0de0001u;
    w.value_5d15e3 = 0xc0de0003u;
    L.snap_callee = 0x4c5377;
    L.snap_arg = 2;
    L.snap_arg2 = 3;
    L.snap_len = 16;
    /* the strings differ: the old digits "37" are drawn, then the new ones "9/", then the new string is copied over the old one */
    blk_setup(blk, "37", "9/");
    memcpy(expect, blk, sizeof expect);
    blk[B(0x63887d) + 3] = 0x5a;
    expect[B(0x63887d) + 3] = 0x5a;
    m446688_draw_digits(&w, &h);
    expect[B(0x63887d)] = '9';
    expect[B(0x63887d) + 1] = '/';
    expect[B(0x63887d) + 2] = 0;
    CK(memcmp(blk, expect, sizeof blk) == 0);
    CK(L.n == 4);
    CK(is_call(0, 0x4c5377, 0x5cf659, 5) && L.c[0].a[0] == 0xc0de0003u && L.c[0].a[1] == 0xc0de0001u && L.c[0].a[4] == 0x548288);
    CK(get32(L.c[0].snap2, 0) == 100 && get32(L.c[0].snap2, 4) == 200 && get32(L.c[0].snap2, 8) == 128 && get32(L.c[0].snap2, 12) == 232);
    CK(get32(L.c[0].snap, 0) == 95 && get32(L.c[0].snap, 4) == 193 && get32(L.c[0].snap, 8) == 123 && get32(L.c[0].snap, 12) == 225);
    qx = 100 + 29 + 4;  /* the advance: the width of the digit 3 plus the gap */
    CK(is_call(1, 0x4c5377, 0x5cf659, 5) && L.c[1].a[4] == 0x548288);
    CK(get32(L.c[1].snap2, 0) == qx && get32(L.c[1].snap2, 4) == 200 && get32(L.c[1].snap2, 8) == qx + 41 - 1 && get32(L.c[1].snap2, 12) == 200 + 37 - 1);
    CK(get32(L.c[1].snap, 0) == qx - 5 && get32(L.c[1].snap, 4) == 193 && get32(L.c[1].snap, 8) == qx + 40 - 5 && get32(L.c[1].snap, 12) == 200 + 36 - 7);
    CK(is_call(2, 0x4c5d4b, 0x5cf659, 5) && L.c[2].a[0] == 0xabc00001u && L.c[2].a[1] == 0xc0de0001u && L.c[2].a[2] == 0x6386bfu + 9 * 16 &&
       L.c[2].a[4] == 0x5482b4);
    CK(is_call(3, 0x4c5d4b, 0x5cf659, 5) && L.c[3].a[0] == 0xabc00001u && L.c[3].a[2] == 0x6386bfu - 16 && L.c[3].a[4] == 0x5482b4);
    /* the rectangles of the new digits (the second callee: look at them in a second run that skips the old digits) */
    blk_setup(blk, "9/", "9/");
    reset_log();
    L.snap_callee = 0x4c5d4b;
    L.snap_arg = 3;
    L.snap_arg2 = 0;
    L.snap_len = 16;
    memcpy(expect, blk, sizeof expect);
    m446688_draw_digits(&w, &h);
    CK(memcmp(blk, expect, sizeof blk) == 0);  /* equal strings: no old digits, the copy changes nothing */
    CK(L.n == 2 && is_call(0, 0x4c5d4b, 0x5cf659, 5) && is_call(1, 0x4c5d4b, 0x5cf659, 5));
    CK(get32(L.c[0].snap, 0) == 100 && get32(L.c[0].snap, 4) == 200 && get32(L.c[0].snap, 8) == 100 + 47 - 1 && get32(L.c[0].snap, 12) == 200 + 39 - 1);
    qx = 100 + 47 + 4;
    CK(get32(L.c[1].snap, 0) == qx && get32(L.c[1].snap, 4) == 200 && get32(L.c[1].snap, 8) == qx + 7 - 1 && get32(L.c[1].snap, 12) == 200 + 47 - 1);
    /* either gate dword zero: nothing happens (the strings differ here) */
    for (i = 0; i < 2; i++) {
        blk_setup(blk, "12", "34");
        set32(blk, i == 0 ? B(0x638607) : B(0x63860f), 0);
        memcpy(expect, blk, sizeof expect);
        reset_log();
        m446688_draw_digits(&w, &h);
        CK(L.n == 0 && memcmp(blk, expect, sizeof blk) == 0);
    }
    /* an empty new string: the old digit is drawn, nothing new, and the terminator alone is copied */
    blk_setup(blk, "4", "");
    memcpy(expect, blk, sizeof expect);
    expect[B(0x63887d)] = 0;
    reset_log();
    L.snap_callee = 0x4c5377;
    m446688_draw_digits(&w, &h);
    CK(L.n == 1 && is_call(0, 0x4c5377, 0x5cf659, 5) && memcmp(blk, expect, sizeof blk) == 0);
    /* a new string longer than 0x1e overlaps the old one: the copy runs forward in dwords (rep movsd) then bytes (rep movsb) */
    blk_setup(blk, "", "");
    for (i = 0; i < 34; i++) blk[B(0x63885f) + i] = (uint8_t)('0' + i % 10);
    blk[B(0x63885f) + 34] = 0;
    memcpy(expect, blk, sizeof expect);
    {
        uint32_t n = 35, src = B(0x63885f), dst = B(0x63887d), c;
        for (c = 0; c < n / 4; c++) {
            uint32_t v = get32(expect, src + 4 * c);
            set32(expect, dst + 4 * c, v);
        }
        for (c = 0; c < (n & 3); c++) expect[dst + (n & ~3u) + c] = expect[src + (n & ~3u) + c];
    }
    reset_log();
    m446688_draw_digits(&w, &h);
    CK(memcmp(blk, expect, sizeof blk) == 0);
    CK(L.n == 34 + 4);  /* the old string (4 characters, as seen through the overlap) and the 34 new ones */
}

static void test_m48d5f4_confirm_pick(void)
{
    static uint8_t region[0xe00], region_exp[0xe00], text[0x9d00], old[OBJ];
    static const uint8_t pattern[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0};
    const uint32_t rec_va = 0x00c20100u, text_va = 0x00c40000u;
    uint8_t *rec = region + 0x100;
    uint8_t *rec_exp = region_exp + 0x100;
    Fl20bWorld w;
    Fl18Host h = host();
    int i;
    memset(&w, 0, sizeof w);
    memset(g_records, 0, sizeof g_records);
    fill(g_obj, OBJ, 21);
    fill(region, sizeof region, 99);
    strcpy((char *)rec + 0x337 + 2 * 0x42, "pick two");
    strcpy((char *)rec + 0x337 - 0x42, "pick minus");
    strcpy((char *)text, "Hi");
    set16(g_obj, 0x1e, 3);
    set32(g_records, 3 * REC, rec_va);
    set32(g_records, 3 * REC + 0x4d, 1);
    set32(g_obj, 0x33, 7);
    set32(g_obj, 0x2b, 1);
    set32(g_obj, 0x2f, 0);
    set16(g_obj, 0x27, 2);
    set16(rec, 0x317, 4);
    set16(rec, 0x736, 0xfff0);
    add_region(rec_va, rec, 0xd00);
    add_region(text_va, text, sizeof text);
    w.records_5bb5e5 = g_records;
    w.bytes_54e88c = pattern;
    w.value_5bb1ca = 1;
    w.value_54e898 = 0x00212121u;
    w.value_5d03b3 = 0x600d0001u;
    w.value_5c39e5 = 0x2765;
    L.tick = 5000;
    L.snap_callee = 0x448d11;
    L.snap_arg = 1;
    L.snap_arg2 = 0;
    L.snap_len = 16;
    /* gates: each failing alone changes nothing and calls nothing */
    for (i = 0; i < 3; i++) {
        uint8_t saved_obj[OBJ], saved_records[sizeof g_records];
        memcpy(saved_obj, g_obj, OBJ);
        memcpy(saved_records, g_records, sizeof g_records);
        if (i == 0) set32(g_obj, 0x33, 0);
        if (i == 1) set32(g_obj, 0x2b, 2);
        if (i == 2) set32(g_records, 3 * REC + 0x4d, 2);
        memcpy(old, g_obj, OBJ);
        memcpy(region_exp, region, sizeof region);
        memcpy(g_exp, g_records, sizeof g_records);
        m48d5f4_confirm_pick(g_obj, &w, &h);
        CK(memcmp(g_obj, old, OBJ) == 0 && memcmp(g_records, g_exp, sizeof g_records) == 0);
        CK(memcmp(region, region_exp, sizeof region) == 0 && L.n == 0 && L.ticks == 0);
        memcpy(g_obj, saved_obj, OBJ);
        memcpy(g_records, saved_records, sizeof g_records);
    }
    /* selector 0x2766: only the flag byte and the record dword; any other selector: nothing */
    w.value_5c39e5 = 0x2766;
    memcpy(g_exp, g_obj, OBJ);
    memcpy(region_exp, region, sizeof region);
    m48d5f4_confirm_pick(g_obj, &w, &h);
    g_exp[0x37] = 1;
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && memcmp(region, region_exp, sizeof region) == 0 && L.n == 0 && L.ticks == 0);
    CK(get32(g_records, 3 * REC + 0x4d) == 2);
    set32(g_records, 3 * REC + 0x4d, 1);
    w.value_5c39e5 = 0x2767;
    m48d5f4_confirm_pick(g_obj, &w, &h);
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && get32(g_records, 3 * REC + 0x4d) == 1 && L.n == 0);
    /* selector 0x2765, the whole path: 3 words shifted (the record's count 4 gives i = 0..2), the pick appended at word index 4, the
     * string copied, 0x4f6334 returns 0 so the message calls and the timer are made, then the text is fetched and shown */
    w.value_5c39e5 = 0x2765;
    set32(g_obj, 0x2f, 9);
    memcpy(old, g_obj, OBJ);
    memcpy(g_exp, g_obj, OBJ);
    memcpy(region_exp, region, sizeof region);
    queue_return(0x423259, text_va);
    m48d5f4_confirm_pick(g_obj, &w, &h);
    g_exp[0x26] = 1;
    set16(g_exp, 0x29, 2);
    for (i = 0; i < 3; i++) set16(g_exp, 0x3d + 2 * i, get16(old, 0x3f + 2 * i));
    set16(g_exp, 0x3b + 4 * 2, 2);
    g_exp[0x24] = 1;
    set32(g_exp, 0x39, 5000 + 0x1f4);
    strcpy((char *)rec_exp + 0x715, "pick two");
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    CK(memcmp(region, region_exp, sizeof region) == 0);
    CK(L.ticks == 1 && L.n == 5);
    CK(is_call(0, 0x4f6334, 0x5cf1eb, 1) && L.c[0].a[0] == 0xfffffff0u);
    CK(is_call(1, 0x4fb77a, 0x5c3a67, 1) && L.c[1].a[0] == rec_va + 0x715);
    CK(is_call(2, 0x4fb2e3, 0x5c3a67, 1) && (L.c[2].a[0] & 0xffff) == 0xfff0);
    CK(is_call(3, 0x423259, 0x619a6b, 1) && L.c[3].a[0] == rec_va + 2 * 0x42 + 0x358);
    CK(is_call(4, 0x448d11, 0x619a05, 4) && L.c[4].a[0] == 0x600d0001u && L.c[4].a[2] == 0xffffffffu && L.c[4].a[3] == 0);
    CK(memcmp(L.c[4].snap, "Hi!!!", 6) == 0);  /* "Hi" with the dword 0x00212121 stored at its terminator */
    /* the same with a negative pick index (the string 0x42 below the table), a record count of 0 (no shifting, the pick goes to
     * word index 0), 0x4f6334 returning non-zero (no message, no timer) and a text of exactly 0x9c40 characters (still shown) */
    reset_log();
    L.tick = 77;
    set16(g_obj, 0x27, 0xffff);
    set16(rec, 0x317, 0);
    set32(g_obj, 0x2f, 0);
    set32(g_obj, 0x39, 0x11111111u);
    g_obj[0x24] = 0;
    memset(text, 'x', 0x9c40);
    text[0x9c40] = 0;
    queue_return(0x4f6334, 1);
    queue_return(0x423259, text_va);
    add_region(rec_va, rec, 0xd00);
    add_region(text_va, text, sizeof text);
    L.snap_callee = 0x448d11;
    L.snap_arg = 1;
    L.snap_arg2 = 0;
    L.snap_len = 16;
    memcpy(old, g_obj, OBJ);
    memcpy(g_exp, g_obj, OBJ);
    memcpy(region_exp, region, sizeof region);
    m48d5f4_confirm_pick(g_obj, &w, &h);
    set16(g_exp, 0x29, 0xffff);
    set16(g_exp, 0x3b, 0xffff);
    strcpy((char *)rec_exp + 0x715, "pick minus");
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && memcmp(region, region_exp, sizeof region) == 0);
    CK(L.ticks == 0 && L.n == 3 && is_call(0, 0x4f6334, 0x5cf1eb, 1) && is_call(1, 0x423259, 0x619a6b, 1) &&
       L.c[1].a[0] == rec_va - 0x42 + 0x358);
    CK(is_call(2, 0x448d11, 0x619a05, 4) && memcmp(L.c[2].snap, "xxxxxxxxxxxxxxxx", 16) == 0);
    /* the other outcomes (flag 0x5bb1ca, the nine bytes, the result of 0x4f6334, the length of the text); the pick is still index -1 */
    for (i = 0; i < 4; i++) {
        reset_log();
        add_region(rec_va, rec, 0xd00);
        add_region(text_va, text, sizeof text);
        L.tick = 77;
        text[0x9c40] = 'x';  /* 0x9c41 characters */
        text[0x9c41] = 0;
        w.value_5bb1ca = (i == 2) ? 0 : 1;
        if (i == 3) memcpy(rec + 0x337 - 0x42, pattern, 10);  /* the copy is {1..9} (+ terminator): equal to the nine bytes */
        if (i == 0) queue_return(0x423259, text_va);  /* too long: not shown */
        m48d5f4_confirm_pick(g_obj, &w, &h);
        if (i == 0) CK(L.n == 4 && L.ticks == 1 && is_call(0, 0x4f6334, 0x5cf1eb, 1) && is_call(1, 0x4fb77a, 0x5c3a67, 1) &&
                       is_call(2, 0x4fb2e3, 0x5c3a67, 1) && is_call(3, 0x423259, 0x619a6b, 1));
        if (i == 1) CK(L.n == 4 && L.ticks == 1 && is_call(3, 0x423259, 0x619a6b, 1));  /* the null result: not shown */
        if (i >= 2) CK(L.n == 1 && L.ticks == 0 && is_call(0, 0x423259, 0x619a6b, 1));
        if (i < 2) CK(get32(g_obj, 0x39) == 77u + 0x1f4u);
    }
    w.value_5bb1ca = 1;
}

/* TESTS-END */

int main(void)
{
    int failures = 0;
    RUN(test_m446688_draw_digits);
    RUN(test_m48d5f4_confirm_pick);
    /* RUN-END */
    return failures;
}
