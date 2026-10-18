/* FL-20 (batch b) direct tests of the functions of GAME.EXE in src/original_methods_fl20b.c. Prints "PASS <name>" / "FAIL <name>: <msg>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values come from the disassembly of
 * GAME.EXE, not from running the native code; tests/test_fl20b_differential.py additionally runs the original bytes on random fixtures.
 *   0x48cc70  rec = record word 0x6246ac; byte 0x6246a3 gate; kind byte [rec+0x42] == 2 -> 0x4c5377 (0x5d15e3, 0x5cf665, rec+0x64, &b, 0x54e760) + 0x4c5d4b (table[0x6246b4], 0x5cf665, &a, &b, 0x54e778) else 0x4c5377 (table[0x6246b4], ..., &a, &b, 0x54e794); per k < 4 the rectangle at rec+k*16+0x74 (+ origin): flags 0x6246be/ba -> 0x4c5d4b (table[0x6246b6], rec+k*16+0xf4, 0x54e7b0); byte 0x6246c6 / 0x6246c2[k] / k == byte 0x6246a2 -> 0x4c5d4b (rec+k*16+0xb4, 0x54e7cc); else 0x4c5377 (0x5d15e3, rec+k*16+0x74, 0x54e7e4)
 *   0x4876ed  rec = record word 0x6252d3; dwords 0x625d43 / 0x625d3f -> 0x4c5377 (0x625d4d, 0x625d6d, 0x54dc64), 0x625d43 := 0; 0x625d47 -> 0x4841cb + 0x4c5377 (0x625d8d, &r, 0x54dc98), cleared; items (stride 0x85 at 0x6252d5, word +0 = order) drawn by 0x4c5d4b for n = word [rec+0x21] (minus the selected one when 0x625d3f), then the selected one (0x54dd0c), then 0x625e40 / 0x625e3c with 0x4841cb + 0x4c5377 (0x54dd34 / 0x54dd50)
 *   0x44d28c  gate dword [this+0x25]; region limits (x <= [rec+0x99], y <= [rec+0x8d], x >= [rec+0x51]); boxes A (dword [this+0x2d] == 0 -> 0x44d597(1)), B, C, D, E ([this+0x2d] == 1 -> 0x44d597(0, 3, 4, 6)), F (0x44d597(8)), G / H / I (byte [this+0x24] := 1), else byte [this+0x24] := 0; returns 1 after a press
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
        for (k = 0; k < nargs && k < 5; k++)
            if ((uint64_t)args[k] > 0xffffffffu) memcpy(c->pd[k], (const void *)args[k], 16);
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

static uint32_t rect_word(const uint8_t *snap, int i) { return get32(snap, (size_t)i * 4); }

static void test_m48cc70_draw_slots(void)
{
    static uint8_t rec[0x200], table[0x4a * 4];
    static const uint8_t be[4] = {1, 1, 0, 0}, ba[4] = {0, 5, 0, 0}, c2[4] = {0, 0, 1, 1};
    const uint32_t rec_va = 0x00c30000u;
    int k, round;
    Fl20bWorld w;
    Fl18Host h = host();
    memset(&w, 0, sizeof w);
    memset(g_records, 0, sizeof g_records);
    memset(rec, 0x5a, sizeof rec);
    memset(table, 0, sizeof table);
    set32(table, 0, 0xaaa00000u);
    set32(table, 0x4a, 0xaaa00001u);
    set32(table, 0x94, 0xbbb00002u);
    set32(g_records, 2 * REC, rec_va);
    rec[0x42] = 2;
    set32(rec, 0x54, 1000); set32(rec, 0x58, 2000); set32(rec, 0x5c, 3000); set32(rec, 0x60, 4000);
    set32(rec, 0x64, 100); set32(rec, 0x68, 200); set32(rec, 0x6c, 300); set32(rec, 0x70, 400);
    for (k = 0; k < 4; k++) {
        set32(rec, 0x74 + (size_t)k * 16, 5000 + 100 * (uint32_t)k + 1);
        set32(rec, 0x78 + (size_t)k * 16, 5000 + 100 * (uint32_t)k + 2);
        set32(rec, 0x7c + (size_t)k * 16, 5000 + 100 * (uint32_t)k + 3);
        set32(rec, 0x80 + (size_t)k * 16, 5000 + 100 * (uint32_t)k + 4);
    }
    add_region(rec_va, rec, sizeof rec);
    w.records_5bb5e5 = g_records;
    w.table_5d1599 = table;
    w.word_6246ac = 2;
    w.word_6246b4 = 1;
    w.word_6246b6 = 2;
    w.word_6246c7 = -3;
    w.word_6246c9 = 11;
    w.byte_6246a3 = 1;
    w.byte_6246c6 = 1;
    w.byte_6246a2 = 2;
    w.bytes_6246be = be;
    w.bytes_6246ba = ba;
    w.bytes_6246c2 = c2;
    w.origin_x_583186 = 7;
    w.origin_y_58318a = -9;
    w.value_5cf665 = 0xc0de0001u;
    w.value_5d15e3 = 0xaaa00001u;
    for (round = 0; round < 4; round++) {
        uint8_t before[sizeof rec];
        int n0 = 0;
        reset_log();
        add_region(rec_va, rec, sizeof rec);
        rec[0x42] = (round == 0) ? 2 : (round == 1) ? 1 : (round == 2) ? 0 : 2;
        memcpy(before, rec, sizeof rec);
        w.byte_6246c6 = (round == 2) ? 0 : 1;
        w.byte_6246a2 = (round == 3) ? 3 : 2;
        w.byte_6246a3 = (round == 3) ? 0 : 1;
        m48cc70_draw_slots(&w, &h);
        CK(memcmp(rec, before, sizeof rec) == 0);
        if (round == 3) {
            CK(L.n == 0);
            continue;
        }
        if (rec[0x42] == 2) {
            CK(is_call(0, 0x4c5377, 0x5cf659, 5) && L.c[0].a[0] == 0xaaa00001u && L.c[0].a[1] == 0xc0de0001u && L.c[0].a[2] == rec_va + 0x64 &&
               L.c[0].a[4] == 0x54e760);
            CK(rect_word(L.c[0].pd[3], 0) == 107 && rect_word(L.c[0].pd[3], 1) == 191 && rect_word(L.c[0].pd[3], 2) == 307 &&
               rect_word(L.c[0].pd[3], 3) == 391);
            CK(is_call(1, 0x4c5d4b, 0x5cf659, 5) && L.c[1].a[0] == 0xaaa00001u && L.c[1].a[1] == 0xc0de0001u && L.c[1].a[4] == 0x54e778);
            CK(rect_word(L.c[1].pd[2], 0) == 997 && rect_word(L.c[1].pd[2], 1) == 2011 && rect_word(L.c[1].pd[2], 2) == 2997 &&
               rect_word(L.c[1].pd[2], 3) == 4011);
            CK(rect_word(L.c[1].pd[3], 0) == 107 && rect_word(L.c[1].pd[3], 3) == 391);
            n0 = 2;
        } else {
            CK(is_call(0, 0x4c5377, 0x5cf659, 5) && L.c[0].a[0] == 0xaaa00001u && L.c[0].a[1] == 0xc0de0001u && L.c[0].a[4] == 0x54e794);
            CK(rect_word(L.c[0].pd[2], 0) == 997 && rect_word(L.c[0].pd[2], 1) == 2011 && rect_word(L.c[0].pd[2], 2) == 2997 &&
               rect_word(L.c[0].pd[2], 3) == 4011);
            CK(rect_word(L.c[0].pd[3], 0) == 107 && rect_word(L.c[0].pd[3], 1) == 191 && rect_word(L.c[0].pd[3], 2) == 307 &&
               rect_word(L.c[0].pd[3], 3) == 391);
            n0 = 1;
        }
        CK(L.n == n0 + 4);
        for (k = 0; k < 4; k++) {
            const Call *c = &L.c[n0 + k];
            uint32_t base = 5000 + 100 * (uint32_t)k;
            int which = 0;   /* 1: 0x4c5d4b with +0xf4, 2: 0x4c5d4b with +0xb4, 0: 0x4c5377 */
            if (k == 0) which = 1;
            if (k == 2 && round != 2) which = 2;
            CK(c->callee == (which ? 0x4c5d4bu : 0x4c5377u) && c->this_ptr == 0x5cf659 && c->n == 5);
            CK(c->a[0] == (which ? 0xbbb00002u : 0xaaa00001u) && c->a[1] == 0xc0de0001u);
            CK(c->a[2] == rec_va + (uint32_t)k * 16 + (which == 1 ? 0xf4u : which == 2 ? 0xb4u : 0x74u));
            CK(c->a[4] == (which == 1 ? 0x54e7b0u : which == 2 ? 0x54e7ccu : 0x54e7e4u));
            CK(rect_word(c->pd[3], 0) == base + 1 + 7 && rect_word(c->pd[3], 1) == base + 2 - 9 && rect_word(c->pd[3], 2) == base + 3 + 7 &&
               rect_word(c->pd[3], 3) == base + 4 - 9);
        }
    }
    /* the highlighted slot is 3 and the flag byte is set: the 0xb4 variant for k = 3 */
    reset_log();
    add_region(rec_va, rec, sizeof rec);
    rec[0x42] = 1;
    w.byte_6246c6 = 1;
    w.byte_6246a2 = 3;
    w.byte_6246a3 = 1;
    m48cc70_draw_slots(&w, &h);
    CK(L.n == 5 && L.c[1 + 3].callee == 0x4c5d4b && L.c[1 + 3].a[2] == rec_va + 3 * 16 + 0xb4 && L.c[1 + 3].a[4] == 0x54e7cc);
    CK(L.c[1 + 2].callee == 0x4c5377 && L.c[1 + 2].a[4] == 0x54e7e4);
}

static void test_m4876ed_redraw_items(void)
{
    static uint8_t rec[0x100], items[0x85 * 4 + 0x100];
    const uint32_t rec_va = 0x00c50000u;
    const uint32_t item_va = 0x6252d5u;
    int k;
    Fl20bWorld w;
    Fl18Host h = host();
    memset(&w, 0, sizeof w);
    memset(g_records, 0, sizeof g_records);
    memset(rec, 0x33, sizeof rec);
    memset(items, 0, sizeof items);
    set32(g_records, 1 * REC, rec_va);
    set16(rec, 0x21, 3);
    /* item s: word +0 = the order i it is drawn at, byte +0x22 = b, byte +0x84 = flag, dword at +b*0x18+0x24 */
    set16(items, 0 * 0x85, 0); items[0 * 0x85 + 0x22] = 1; items[0 * 0x85 + 0x84] = 1; set32(items, 0 * 0x85 + 0x18 + 0x24, 0x1110);
    set16(items, 1 * 0x85, 1); items[1 * 0x85 + 0x22] = 0; items[1 * 0x85 + 0x84] = 7; set32(items, 1 * 0x85 + 0x24, 0x2220);
    set16(items, 2 * 0x85, 0); items[2 * 0x85 + 0x22] = 2; items[2 * 0x85 + 0x84] = 0; set32(items, 2 * 0x85 + 0x30 + 0x24, 0x3330);
    set16(items, 3 * 0x85, 0); items[3 * 0x85 + 0x22] = 0; items[3 * 0x85 + 0x84] = 0;
    add_region(rec_va, rec, sizeof rec);
    w.records_5bb5e5 = g_records;
    w.items_6252d5 = items;
    w.word_6252d3 = 1;
    w.value_5cf665 = 0xc0de0001u;
    w.value_5d15e3 = 0xc0de0003u;
    w.value_6252cf = 0xc0de0004u;
    w.value_6252cb = 0xc0de0005u;
    w.word_625d4b = 1;
    /* A, C and E set: three draws of the items in order (i = 0: items 0 and 2, i = 1: item 1), the m = n = 3 items done */
    w.value_625d43 = 1;
    w.value_625d47 = 1;
    w.value_625e3c = 1;
    queue_write(0x4841cb, 0, 1, 0, 4, 11);
    queue_write(0x4841cb, 0, 1, 4, 4, 12);
    queue_write(0x4841cb, 0, 1, 8, 4, 13);
    queue_write(0x4841cb, 0, 1, 12, 4, 14);
    queue_write(0x4841cb, 1, 1, 0, 4, 21);
    queue_write(0x4841cb, 1, 1, 4, 4, 22);
    queue_write(0x4841cb, 1, 1, 8, 4, 23);
    queue_write(0x4841cb, 1, 1, 12, 4, 24);
    m4876ed_redraw_items(&w, &h);
    CK(w.value_625d43 == 0 && w.value_625d47 == 0 && w.value_625e3c == 0 && w.value_625d3f == 0 && w.value_625e40 == 0);
    CK(L.n == 8);
    CK(is_call(0, 0x4c5377, 0x5cf659, 5) && L.c[0].a[0] == 0xc0de0003u && L.c[0].a[1] == 0xc0de0001u && L.c[0].a[2] == 0x625d4d &&
       L.c[0].a[3] == 0x625d6d && L.c[0].a[4] == 0x54dc64);
    CK(is_call(1, 0x4841cb, 0x6252ad, 2) && L.c[1].a[0] == 0x625d8d);
    CK(is_call(2, 0x4c5377, 0x5cf659, 5) && L.c[2].a[0] == 0xc0de0003u && L.c[2].a[1] == 0xc0de0001u && L.c[2].a[2] == 0x625d8d &&
       L.c[2].a[4] == 0x54dc98);
    CK(get32(L.c[2].pd[3], 0) == 11 && get32(L.c[2].pd[3], 4) == 12 && get32(L.c[2].pd[3], 8) == 13 && get32(L.c[2].pd[3], 12) == 14);
    CK(is_call(3, 0x4c5d4b, 0x5cf659, 5) && L.c[3].a[0] == 0x1110 && L.c[3].a[1] == 0xc0de0001u && L.c[3].a[2] == item_va + 0x18 + 0x28 &&
       L.c[3].a[3] == item_va + 0x12 && L.c[3].a[4] == 0x54dcc8);
    CK(is_call(4, 0x4c5d4b, 0x5cf659, 5) && L.c[4].a[0] == 0xc0de0004u && L.c[4].a[1] == 0xc0de0001u && L.c[4].a[2] == rec_va + 2 * 0x42 + 0x7f &&
       L.c[4].a[3] == item_va + 2 * 0x85 + 0x12 && L.c[4].a[4] == 0x54dce8);
    CK(is_call(5, 0x4c5d4b, 0x5cf659, 5) && L.c[5].a[0] == 0x2220 && L.c[5].a[2] == item_va + 0x85 + 0x28 && L.c[5].a[3] == item_va + 0x85 + 0x12 &&
       L.c[5].a[4] == 0x54dcc8);
    CK(is_call(6, 0x4841cb, 0x6252ad, 2) && L.c[6].a[0] == rec_va + 0x5e8);
    CK(is_call(7, 0x4c5377, 0x5cf659, 5) && L.c[7].a[0] == 0xc0de0003u && L.c[7].a[2] == rec_va + 0x5e8 && L.c[7].a[4] == 0x54dd50);
    CK(get32(L.c[7].pd[3], 0) == 21 && get32(L.c[7].pd[3], 12) == 24);
    /* B set (A clear), the selected item 1 skipped so m = 2: items 0 and 2 drawn, then the selected item, then D (E stays set) */
    reset_log();
    add_region(rec_va, rec, sizeof rec);
    w.value_625d43 = 0;
    w.value_625d47 = 0;
    w.value_625d3f = 5;
    w.value_625e40 = 9;
    w.value_625e3c = 1;
    queue_write(0x4841cb, 0, 1, 0, 4, 31);
    queue_write(0x4841cb, 0, 1, 12, 4, 34);
    m4876ed_redraw_items(&w, &h);
    CK(w.value_625e3c == 1 && w.value_625d3f == 5 && w.value_625e40 == 9 && L.n == 1 + 2 + 1 + 2);
    CK(is_call(0, 0x4c5377, 0x5cf659, 5) && L.c[0].a[2] == 0x625d4d && L.c[0].a[3] == 0x625d6d && L.c[0].a[4] == 0x54dc64);
    CK(is_call(1, 0x4c5d4b, 0x5cf659, 5) && L.c[1].a[0] == 0x1110 && L.c[1].a[4] == 0x54dcc8);
    CK(is_call(2, 0x4c5d4b, 0x5cf659, 5) && L.c[2].a[0] == 0xc0de0004u && L.c[2].a[2] == rec_va + 2 * 0x42 + 0x7f && L.c[2].a[4] == 0x54dce8);
    CK(is_call(3, 0x4c5d4b, 0x5cf659, 5) && L.c[3].a[0] == 0x2220 && L.c[3].a[1] == 0xc0de0001u && L.c[3].a[2] == item_va + 0x85 + 0x28 &&
       L.c[3].a[3] == 0x625d7d && L.c[3].a[4] == 0x54dd0c);
    CK(is_call(4, 0x4841cb, 0x6252ad, 2) && L.c[4].a[0] == rec_va + 0x5e8);
    CK(is_call(5, 0x4c5377, 0x5cf659, 5) && L.c[5].a[0] == 0xc0de0005u && L.c[5].a[1] == 0xc0de0001u && L.c[5].a[2] == 0x625e44 &&
       L.c[5].a[4] == 0x54dd34);
    CK(get32(L.c[5].pd[3], 0) == 31 && get32(L.c[5].pd[3], 12) == 34);
    /* nothing to draw in the loop (n = 0) and no flags: no calls at all; items whose order comes later are found by later passes */
    reset_log();
    add_region(rec_va, rec, sizeof rec);
    w.value_625d3f = 0;
    w.value_625e40 = 0;
    w.value_625e3c = 0;
    set16(rec, 0x21, 0);
    m4876ed_redraw_items(&w, &h);
    CK(L.n == 0);
    set16(rec, 0x21, 2);
    set16(items, 0, 2);
    set16(items, 0x85, 2);
    m4876ed_redraw_items(&w, &h);
    CK(L.n == 2 && L.c[0].a[3] == item_va + 0x12 && L.c[1].a[3] == item_va + 0x85 + 0x12);
    for (k = 0; k < 2; k++) CK(L.c[k].callee == 0x4c5d4b);
}

/* the nine boxes of the record of 0x44d28c: byte offsets of x low, x high, y low, y high */
typedef struct BoxOff { uint32_t xlo, xhi, ylo, yhi; } BoxOff;
enum { BA, BB, BC, BD, BE, BF, BG, BH, BI, NBOX };
static const BoxOff k_boxes[NBOX] = {{0x61, 0x69, 0x65, 0x6d}, {0x51, 0x59, 0x55, 0x5d}, {0x91, 0x99, 0x95, 0x9d},
                                     {0xa1, 0xa9, 0xa5, 0xad}, {0x71, 0x79, 0x75, 0x7d}, {0x81, 0x89, 0x85, 0x8d},
                                     {0x21, 0x29, 0x25, 0x2d}, {0x31, 0x39, 0x35, 0x3d}, {0xb1, 0xb9, 0xb5, 0xbd}};
static const int k_press[NBOX] = {1, 0, 3, 4, 6, 8, -1, -1, -1};  /* the argument of 0x44d597, or none */

static void box_set(uint8_t *rec, int b, int32_t xlo, int32_t xhi, int32_t ylo, int32_t yhi)
{
    set32(rec, k_boxes[b].xlo, (uint32_t)xlo);
    set32(rec, k_boxes[b].xhi, (uint32_t)xhi);
    set32(rec, k_boxes[b].ylo, (uint32_t)ylo);
    set32(rec, k_boxes[b].yhi, (uint32_t)yhi);
}

static void test_m44d28c_click(void)
{
    static uint8_t rec[0x100];
    const uint32_t rec_va = 0x00c60000u;
    Fl20bWorld w;
    Fl18Host h = host();
    int b, v, c, k;
    memset(&w, 0, sizeof w);
    memset(g_records, 0, sizeof g_records);
    set32(g_records, 1 * REC, rec_va);
    w.records_5bb5e5 = g_records;
    fill(g_obj, OBJ, 3);
    set16(g_obj, 0x1e, 1);
    /* the dword [this+0x25] is zero: byte [this+0x24] := 0 and nothing else */
    set32(g_obj, 0x25, 0);
    g_obj[0x24] = 7;
    memcpy(g_exp, g_obj, OBJ);
    add_region(rec_va, rec, sizeof rec);
    CK(m44d28c_click(g_obj, 40, 50, &w, &h) == 0);
    g_exp[0x24] = 0;
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && L.n == 0);
    set32(g_obj, 0x25, 5);
    /* each box alone around the point (40, 50): interior, each edge exactly on the point, and each edge one unit short; the other boxes
     * are far away; the region limits x >= [rec+0x51], x <= [rec+0x99], y <= [rec+0x8d] belong to boxes B, C, F */
    for (b = 0; b < NBOX; b++) {
        for (c = 0; c < 3; c++) {          /* [this+0x2d] */
            for (v = 0; v < 9; v++) {      /* 0 interior, 1..4 the low x, high x, low y, high y edge on the point, 5..8 one unit short */
                int32_t lo_x = 30, hi_x = 50, lo_y = 20, hi_y = 80;
                int active = (b == BA) ? (c == 0) : (b >= BB && b <= BE) ? (c == 1) : 1;
                int outer = 0, hit;
                int32_t r;
                if (v == 1) lo_x = 40;
                if (v == 2) hi_x = 40;
                if (v == 3) lo_y = 50;
                if (v == 4) hi_y = 50;
                if (v == 5) lo_x = 41;
                if (v == 6) hi_x = 39;
                if (v == 7) lo_y = 51;
                if (v == 8) hi_y = 49;
                memset(rec, 0, sizeof rec);
                for (k = 0; k < NBOX; k++) box_set(rec, k, 1000, 1010, 1000, 1010);
                box_set(rec, BB, 0, 1010, 1000, 1010);  /* x >= 0 */
                box_set(rec, BC, 1000, 2000, 1000, 1010);
                box_set(rec, BF, 1000, 1010, 1000, 2000);
                box_set(rec, b, lo_x, hi_x, lo_y, hi_y);
                if (b == BB && v == 5) outer = 1;   /* x < [rec+0x51] */
                if (b == BC && v == 6) outer = 1;   /* x > [rec+0x99] */
                if (b == BF && v == 8) outer = 1;   /* y > [rec+0x8d] */
                hit = !outer && v <= 4 && active;
                reset_log();
                add_region(rec_va, rec, sizeof rec);
                g_obj[0x24] = 0;
                set32(g_obj, 0x29, 0xdead);
                set32(g_obj, 0x2d, (uint32_t)c);
                memcpy(g_exp, g_obj, OBJ);
                r = m44d28c_click(g_obj, 40, 50, &w, &h);
                if (outer) {
                    g_exp[0x24] = 1;
                    set32(g_exp, 0x29, 0);
                    CK(r == 0 && L.n == 0);
                } else if (hit && k_press[b] >= 0) {
                    g_exp[0x24] = 1;
                    set32(g_exp, 0x29, 1);
                    CK(r == 1 && L.n == 1 && is_call(0, 0x44d597, (uintptr_t)g_obj, 1) && L.c[0].a[0] == (uint32_t)k_press[b]);
                } else if (hit) {   /* boxes G, H, I */
                    g_exp[0x24] = 1;
                    set32(g_exp, 0x29, 1);
                    CK(r == 0 && L.n == 0);
                } else {            /* inside the region but no box holds the point */
                    g_exp[0x24] = 0;
                    set32(g_exp, 0x29, 1);
                    CK(r == 0 && L.n == 0);
                }
                CK(memcmp(g_obj, g_exp, OBJ) == 0);
            }
        }
    }
    /* the order of the boxes when all of them hold the point: A (only for 0), then B, C, D, E (only for 1), F, and G / H / I last */
    for (c = 0; c < 2; c++) {
        static const int order1[] = {BB, BC, BD, BE, BF};
        int n;
        memset(rec, 0, sizeof rec);
        for (k = 0; k < NBOX; k++) box_set(rec, k, 30, 50, 20, 80);
        set32(g_obj, 0x2d, (uint32_t)c);
        if (c == 0) {
            reset_log();
            add_region(rec_va, rec, sizeof rec);
            CK(m44d28c_click(g_obj, 40, 50, &w, &h) == 1 && L.n == 1 && L.c[0].a[0] == 1);
            box_set(rec, BA, 1000, 1010, 1000, 1010);
            reset_log();
            add_region(rec_va, rec, sizeof rec);
            CK(m44d28c_click(g_obj, 40, 50, &w, &h) == 1 && L.n == 1 && L.c[0].a[0] == 8);  /* A gone: F (B..E need 1) */
        } else {
            for (n = 0; n < 5; n++) {
                reset_log();
                add_region(rec_va, rec, sizeof rec);
                CK(m44d28c_click(g_obj, 40, 50, &w, &h) == 1 && L.n == 1 && L.c[0].a[0] == (uint32_t)k_press[order1[n]]);
                if (order1[n] == BB) box_set(rec, BB, 0, 1010, 1000, 1010);  /* (B holds the region limit: keep x >= [rec+0x51]) */
                else if (order1[n] == BC) box_set(rec, BC, 1000, 2000, 1000, 1010);
                else if (order1[n] == BF) box_set(rec, BF, 1000, 1010, 1000, 2000);
                else box_set(rec, order1[n], 1000, 1010, 1000, 1010);
            }
        }
    }
    /* the point's coordinates are signed words: -1 (0xffff) is below every box that starts at 0, and sign-extends for the limits */
    memset(rec, 0, sizeof rec);
    for (k = 0; k < NBOX; k++) box_set(rec, k, -100, -50, -20, -10);
    box_set(rec, BB, -200, -50, -20, -10);
    set32(g_obj, 0x2d, 1);
    reset_log();
    add_region(rec_va, rec, sizeof rec);
    CK(m44d28c_click(g_obj, (int16_t)-60, (int16_t)-15, &w, &h) == 1 && L.n == 1 && L.c[0].a[0] == 0);
    reset_log();
    add_region(rec_va, rec, sizeof rec);
    CK(m44d28c_click(g_obj, (int16_t)0xffff, (int16_t)-15, &w, &h) == 0 && get32(g_obj, 0x29) == 0 && L.n == 0);  /* x = -1 > [rec+0x99] = -50 */
}

/* TESTS-END */

int main(void)
{
    int failures = 0;
    RUN(test_m446688_draw_digits);
    RUN(test_m48d5f4_confirm_pick);
    RUN(test_m48cc70_draw_slots);
    RUN(test_m4876ed_redraw_items);
    RUN(test_m44d28c_click);
    /* RUN-END */
    return failures;
}
