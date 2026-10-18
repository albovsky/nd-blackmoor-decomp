/* FL-18 direct tests of the methods of GAME.EXE in src/original_methods_fl18.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit
 * status is the failure count. Fixtures are synthetic (no original bytes). Expected values come from the disassembly of GAME.EXE, not
 * from running the native code; tests/test_fl_differential.py additionally runs the original bytes on random fixtures.
 *   0x4c924d  w = word 0x5afbda[i], d = dword 0x5d032f[i]; w == 0 and d == 0: d := 0x4c2790 on 0x5cf659 (0x557adc, 0x5a4c24 + i*0x7f3, 6, 0x557acc); w := w + 1
 *   0x4121b8  rec = dword of record i; [this+0x102a] := 0; 0x413187 (rec, rec+0x210, 0, 0); 0x42ba3a (i); 0x411b16 (rec, i, 0)
 *   0x4e7bf3  [this+0x822e] counts 0..5; 0x4e1d34 on this + k*0x18f + 0x7654 when dword [this + k*0xf7 + 0x7012]; then 0x4e7ba7 on this
 *   0x4b7051  rec = dword of record word 0x61d467; per k < word [rec+0x21]: 0x4c5377 on 0x5cf659 (dword 0x5d1599[w*0x4a], [0x5cf665], 0x61d46d+16k, 0x61d56d+16k, 0x551bb0)
 *   0x4b7f3b  the stores of the reset (see the leading comment of m4b7f3b_reset)
 *   0x4b7ff4  0x4c2dfb on 0x5cf659 (this+0xc) when [this+0xc]; 0x4d3992 (word [this+4]) when != -1, (word +0x61e), (word +0x546) when dwords != -1; 0x4c92c5 (0xa); 0x4b7f3b
 *   0x4e7253  local := 0x4e45be on this (&local, rec+2, 1, 0xb); copy 0x29 bytes of rec to 0x5a1e62 + word(local or 0x5a1e5c, then +1) * 0x29; 0x4e3ade; 0x4e0559 on 0x570508 (3, 1, 0)
 *   0x4e8dc8  nothing unless dword [this+0x764c] is 2 or 3; 0x4ee517; the 0x4e26fc loop over the six slots; 0x4e8e78
 *   0x45b7a8 / 0x4b6097 / 0x4b81ff  the hotspot globals (0x5d162d, 0x5b44f0, 0x5b44f4, 0x5d1631, 0x5d1639, 0x5c39e5)
 *   0x423b51  0x4234c8; slot := record 0x5bb5e9 + i*0x8d; 0x423876 (&slot, 0) when dword [slot+4]; clears through p and slot
 *   0x4cc79a  per entry of the list: 0x4c7623 on 0x5cf659 (dword 0x5cf665, &rect, word 0x10 + 0x400*i); dword 0x638483 := 0
 *   0x4b8d5e  GetTickCount; slots expire when (now - dword [e+0x77]) / 1000 > word [e+0x7b]; then 0x4fb2e3 and 0x4b8a27
 *   0x410f99  strcpy dst, src and the field copies / constants
 *   0x44d624 / 0x4631d1  the record-gated timers (see the leading comments)
 *   0x41632b  free dwords [arg+0x17a] and [arg+0x17e] (each only when set, then cleared); words [arg+0x182], [arg+0x184] := 0
 *   0x4c08d3  the rectangle fields of this from the object [this+0x24a], shifted by the origin 0x583186/0x58318a and back
 *   0x4c0774  open a piece: globals from the object [this+0x22a]; 0x4d36ed, 0x4bf773, 0x42ba3a
 *   0x4d07e7  0x4c5377 and one or two 0x4d2c20 text draws */
#include "../src/original_methods_fl18.h"

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

#define OBJ 0x8400u
#define REC 0x8du

static void fill(uint8_t *o, size_t n, uint8_t seed)
{
    size_t i;
    for (i = 0; i < n; i++) o[i] = (uint8_t)(i * 7u + seed + (i >> 8));
}

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

/* ---- the call log of the host ----------------------------------------------------------------------------------------------- */

typedef struct Call {
    uint32_t callee;
    uintptr_t this_ptr;
    int n;
    uintptr_t a[8];
    uint32_t snap;          /* the dword at snap_ptr when the call was made */
    uint32_t rect[4];       /* 0x4c7623: the four dwords that args[1] points at */
} Call;

typedef struct Region {
    uint32_t va;
    uint8_t *ptr;
    uint32_t len;
} Region;

static struct {
    int n;
    Call c[48];
    uint32_t ret_callee[4], ret_value[4][8];  /* per-callee queue of return values (index by position) */
    int ret_count[4], ret_used[4];
    const uint8_t *snap_ptr;
    int local_writes;       /* 0x4e45be: write this value into the word that args[0] points at */
    uint32_t local_value;
    Region regions[6];
    int nregions;
    uint32_t tick;
    int ticks;
} L;

static void reset_log(void) { memset(&L, 0, sizeof L); }

static void queue_return(uint32_t callee, uint32_t v)
{
    int i;
    for (i = 0; i < 4; i++) {
        if (L.ret_count[i] == 0 || L.ret_callee[i] == callee) {
            L.ret_callee[i] = callee;
            L.ret_value[i][L.ret_count[i]++] = v;
            return;
        }
    }
}

static uint32_t h_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int i, k;
    (void)ctx;
    if (L.n < 48) {
        Call *c = &L.c[L.n];
        c->callee = callee;
        c->this_ptr = this_ptr;
        c->n = nargs;
        for (k = 0; k < nargs && k < 8; k++) c->a[k] = args[k];
        if (L.snap_ptr != NULL) c->snap = get32(L.snap_ptr, 0);
        if (callee == 0x4c7623) memcpy(c->rect, (const void *)args[1], 16);
    }
    L.n++;
    if (callee == 0x4e45be && L.local_writes) memcpy((void *)args[0], &L.local_value, 4);
    for (i = 0; i < 4; i++)
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

static void add_region(uint32_t va, uint8_t *ptr, uint32_t len)
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

static int is_call(int k, uint32_t callee, uintptr_t this_ptr, int n)
{
    return k < L.n && k < 48 && L.c[k].callee == callee && L.c[k].this_ptr == this_ptr && L.c[k].n == n;
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

static uint8_t g_obj[OBJ], g_exp[OBJ];
static uint8_t g_records[REC * 8];

/* ---- tests ---------------------------------------------------------------------------------------------------------------- */

static void test_m4c924d_count_up(void)
{
    static uint8_t words[64], dwords[128];
    Fl18World w;
    Fl18Host h = host();
    memset(&w, 0, sizeof w);
    w.words_5afbda = words + 16;
    w.dwords_5d032f = dwords + 32;
    /* word and dword both 0: calls, stores the result, increments */
    memset(words, 0, sizeof words);
    memset(dwords, 0, sizeof dwords);
    queue_return(0x4c2790, 0xcafe0001u);
    m4c924d_count_up(2, &w, &h);
    CK(L.n == 1 && is_call(0, 0x4c2790, 0x5cf659, 4));
    CK(L.c[0].a[0] == 0x557adc && L.c[0].a[1] == 0x5a4c24u + 2u * 0x7f3u && L.c[0].a[2] == 6 && L.c[0].a[3] == 0x557acc);
    CK(get32(dwords + 32, 8) == 0xcafe0001u && get16(words + 16, 4) == 1);
    /* negative index, word non-zero: no call, only the word moves (16-bit wrap) */
    reset_log();
    set16(words + 16, (size_t)(-2 * 2) & 0xffff, 0);
    memset(words, 0, sizeof words);
    set16(words, 16 - 4, 0xffff);
    m4c924d_count_up(-2, &w, &h);
    CK(L.n == 0 && get16(words, 12) == 0);
    /* word 0 but dword non-zero: no call */
    memset(words, 0, sizeof words);
    set32(dwords, 32 + 12, 5);
    m4c924d_count_up(3, &w, &h);
    CK(L.n == 0 && get16(words, 16 + 6) == 1 && get32(dwords, 32 + 12) == 5);
}

static void test_m4121b8_start_piece(void)
{
    Fl18World w;
    Fl18Host h = host();
    memset(&w, 0, sizeof w);
    fill(g_obj, OBJ, 3);
    memcpy(g_exp, g_obj, OBJ);
    memset(g_records, 0, sizeof g_records);
    set32(g_records, 3 * REC, 0x00501000u);
    w.records_5bb5e5 = g_records;
    m4121b8_start_piece(g_obj, 3, &w, &h);
    set32(g_exp, 0x102a, 0);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    CK(L.n == 3);
    CK(is_call(0, 0x413187, (uintptr_t)g_obj, 4) && L.c[0].a[0] == 0x501000u && L.c[0].a[1] == 0x501210u && L.c[0].a[2] == 0 &&
       L.c[0].a[3] == 0);
    CK(is_call(1, 0x42ba3a, 0, 1) && (L.c[1].a[0] & 0xffff) == 3);
    CK(is_call(2, 0x411b16, (uintptr_t)g_obj, 3) && L.c[2].a[0] == 0x501000u && (L.c[2].a[1] & 0xffff) == 3 && L.c[2].a[2] == 0);
}

static void test_m4e7bf3_close_slots(void)
{
    Fl18Host h = host();
    int k;
    fill(g_obj, OBJ, 5);
    for (k = 0; k < 6; k++) set32(g_obj, 0x7012 + (size_t)k * 0xf7, 0);
    set32(g_obj, 0x7012 + 1 * 0xf7, 1);
    set32(g_obj, 0x7012 + 4 * 0xf7, 0x80000000u);
    memcpy(g_exp, g_obj, OBJ);
    m4e7bf3_close_slots(g_obj, &h);
    set32(g_exp, 0x822e, 6);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    CK(L.n == 3);
    CK(is_call(0, 0x4e1d34, (uintptr_t)(g_obj + 0x18f + 0x7654), 0));
    CK(is_call(1, 0x4e1d34, (uintptr_t)(g_obj + 4 * 0x18f + 0x7654), 0));
    CK(is_call(2, 0x4e7ba7, (uintptr_t)g_obj, 0));
}

static void test_m4b7051_draw_list(void)
{
    static uint8_t rec[0x60], tab[0x4a * 4 + 8];
    Fl18World w;
    Fl18Host h = host();
    int k;
    memset(&w, 0, sizeof w);
    memset(rec, 0, sizeof rec);
    set16(rec, 0x21, 3);
    memset(g_records, 0, sizeof g_records);
    set32(g_records, 2 * REC, 0x00600000u);
    add_region(0x00600000u, rec, sizeof rec);
    memset(tab, 0, sizeof tab);
    set32(tab, 0x4a * 2, 0x11223344u);
    w.records_5bb5e5 = g_records;
    w.word_61d467 = 2;
    w.word_61d465 = 2;
    w.table_5d1599 = tab;
    w.value_5cf665 = 0x77665544u;
    m4b7051_draw_list(&w, &h);
    CK(L.n == 3);
    for (k = 0; k < 3 && k < L.n; k++) {
        CK(is_call(k, 0x4c5377, 0x5cf659, 5));
        CK(L.c[k].a[0] == 0x11223344u && L.c[k].a[1] == 0x77665544u && L.c[k].a[2] == 0x61d46du + 16u * (uint32_t)k &&
           L.c[k].a[3] == 0x61d56du + 16u * (uint32_t)k && L.c[k].a[4] == 0x551bb0);
    }
    /* a negative count draws nothing */
    reset_log();
    add_region(0x00600000u, rec, sizeof rec);
    set16(rec, 0x21, 0xffff);
    m4b7051_draw_list(&w, &h);
    CK(L.n == 0);
}

static void test_m4b7f3b_reset(void)
{
    size_t i;
    fill(g_obj, OBJ, 9);
    memcpy(g_exp, g_obj, OBJ);
    m4b7f3b_reset(g_obj);
    set16(g_exp, 6, 0xffff);
    set16(g_exp, 4, 0xffff);
    for (i = 0; i < 7; i++) {
        static const size_t zero[7] = {8, 0x14, 0x18, 0x20, 0x1c, 0x34, 0xc};
        set32(g_exp, zero[i], 0);
    }
    for (i = 0x54e; i < 0x55e; i += 4) set32(g_exp, i, 0);
    for (i = 0x496; i < 0x496 + 0x2e * 4; i += 4) set32(g_exp, i, 0);
    for (i = 0x55e; i < 0x55e + 0x32 * 4; i += 4) set32(g_exp, i, 0);
    set32(g_exp, 0x61e, 0xffffffffu);
    set32(g_exp, 0x546, 0xffffffffu);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
}

static void test_m4b7ff4_release(void)
{
    Fl18Host h = host();
    uint8_t before[OBJ];
    /* everything set: release, three 0x4d3992 calls, 0x4c92c5, then the reset */
    fill(g_obj, OBJ, 11);
    set32(g_obj, 0xc, 0x1234);
    set16(g_obj, 4, 0x0007);
    set32(g_obj, 0x61e, 9);
    set32(g_obj, 0x546, 0x10008);
    memcpy(before, g_obj, OBJ);
    m4b7ff4_release(g_obj, &h);
    CK(L.n == 5);
    CK(is_call(0, 0x4c2dfb, 0x5cf659, 1) && L.c[0].a[0] == (uintptr_t)(g_obj + 0xc));
    CK(is_call(1, 0x4d3992, 0, 1) && (L.c[1].a[0] & 0xffff) == 7);
    CK(is_call(2, 0x4d3992, 0, 1) && (L.c[2].a[0] & 0xffff) == 9);
    CK(is_call(3, 0x4d3992, 0, 1) && (L.c[3].a[0] & 0xffff) == 8);
    CK(is_call(4, 0x4c92c5, 0x5cf659, 1) && L.c[4].a[0] == 0xa);
    CK(get16(g_obj, 4) == 0xffff && get16(g_obj, 6) == 0xffff && get32(g_obj, 0xc) == 0 && get32(g_obj, 0x61e) == 0xffffffffu &&
       get32(g_obj, 0x546) == 0xffffffffu);
    /* nothing to release: only 0x4c92c5 */
    reset_log();
    fill(g_obj, OBJ, 12);
    set32(g_obj, 0xc, 0);
    set16(g_obj, 4, 0xffff);
    set32(g_obj, 0x61e, 0xffffffffu);
    set32(g_obj, 0x546, 0xffffffffu);
    m4b7ff4_release(g_obj, &h);
    CK(L.n == 1 && is_call(0, 0x4c92c5, 0x5cf659, 1));
    /* the word is -1 but the dword at +0x61e only compares as a dword: a 16-bit -1 in a larger dword still calls */
    reset_log();
    set32(g_obj, 0x61e, 0x0001ffffu);
    set32(g_obj, 0x546, 0xffffffffu);
    m4b7ff4_release(g_obj, &h);
    CK(L.n == 2 && is_call(0, 0x4d3992, 0, 1) && (L.c[0].a[0] & 0xffff) == 0xffff);
}

static void test_m4e7253_store_record(void)
{
    static uint8_t rec[0x60], table[0x29 * 8 + 0x80];
    Fl18World w;
    Fl18Host h = host();
    uint8_t before[sizeof table];
    memset(&w, 0, sizeof w);
    fill(rec, sizeof rec, 21);
    memset(g_records, 0, sizeof g_records);
    set32(g_records, 1 * REC, 0x00700000u);
    add_region(0x00700000u, rec, sizeof rec);
    w.records_5bb5e5 = g_records;
    w.table_5a1e62 = table + 0x40;
    w.word_5a1e5c = 4;
    fill(table, sizeof table, 33);
    memcpy(before, table, sizeof table);
    fill(g_obj, OBJ, 2);
    /* 0x4e45be returns 0: append at the word 0x5a1e5c, which goes up by one */
    m4e7253_store_record(g_obj, 1, &w, &h);
    CK(L.n == 3);
    CK(is_call(0, 0x4e45be, (uintptr_t)g_obj, 4) && L.c[0].a[1] == 0x700002u && L.c[0].a[2] == 1 && L.c[0].a[3] == 0xb);
    CK(is_call(1, 0x4e3ade, (uintptr_t)g_obj, 0));
    CK(is_call(2, 0x4e0559, 0x570508, 3) && L.c[2].a[0] == 3 && L.c[2].a[1] == 1 && L.c[2].a[2] == 0);
    memcpy(before + 0x40 + 4 * 0x29, rec, 0x29);
    CK(memcmp(table, before, sizeof table) == 0 && w.word_5a1e5c == 5);
    /* 0x4e45be returns non-zero and sets the word to 2: overwrite record 2, the counter stays */
    reset_log();
    add_region(0x00700000u, rec, sizeof rec);
    queue_return(0x4e45be, 1);
    L.local_writes = 1;
    L.local_value = 0xabcd0002u;
    memcpy(before, table, sizeof table);
    m4e7253_store_record(g_obj, 1, &w, &h);
    memcpy(before + 0x40 + 2 * 0x29, rec, 0x29);
    CK(memcmp(table, before, sizeof table) == 0 && w.word_5a1e5c == 5 && L.n == 3);
    /* a negative word selects the slack below the table */
    reset_log();
    add_region(0x00700000u, rec, sizeof rec);
    queue_return(0x4e45be, 1);
    L.local_writes = 1;
    L.local_value = 0x0000ffffu;
    memcpy(before, table, sizeof table);
    m4e7253_store_record(g_obj, 1, &w, &h);
    memcpy(before + 0x40 - 0x29, rec, 0x29);
    CK(memcmp(table, before, sizeof table) == 0);
}

static void test_m4e8dc8_check_slots(void)
{
    Fl18Host h = host();
    int k;
    /* state 1: nothing at all */
    fill(g_obj, OBJ, 14);
    set32(g_obj, 0x764c, 1);
    memcpy(g_exp, g_obj, OBJ);
    m4e8dc8_check_slots(g_obj, &h);
    CK(L.n == 0 && memcmp(g_obj, g_exp, OBJ) == 0);
    /* state 2, 0x4ee517 non-zero: only that call */
    reset_log();
    set32(g_obj, 0x764c, 2);
    queue_return(0x4ee517, 7);
    memcpy(g_exp, g_obj, OBJ);
    m4e8dc8_check_slots(g_obj, &h);
    CK(L.n == 1 && is_call(0, 0x4ee517, (uintptr_t)g_obj, 0) && memcmp(g_obj, g_exp, OBJ) == 0);
    /* state 3, all slots set and quiet: six slot calls then 0x4e8e78; counter ends at 6 */
    reset_log();
    set32(g_obj, 0x764c, 3);
    for (k = 0; k < 6; k++) set32(g_obj, 0x7012 + (size_t)k * 0xf7, (uint32_t)k + 1);
    m4e8dc8_check_slots(g_obj, &h);
    CK(L.n == 8 && is_call(0, 0x4ee517, (uintptr_t)g_obj, 0));
    for (k = 0; k < 6; k++) CK(is_call(k + 1, 0x4e26fc, (uintptr_t)(g_obj + (size_t)k * 0x18f + 0x7654), 0));
    CK(is_call(7, 0x4e8e78, (uintptr_t)g_obj, 0) && get32(g_obj, 0x822e) == 6);
    /* the third slot reports non-zero: stops there with the counter at 2, no final call */
    reset_log();
    queue_return(0x4e26fc, 0);
    queue_return(0x4e26fc, 0);
    queue_return(0x4e26fc, 5);
    m4e8dc8_check_slots(g_obj, &h);
    CK(L.n == 4 && get32(g_obj, 0x822e) == 2);
}

static void test_m45b7a8_arm_hotspot(void)
{
    Fl18World w;
    memset(&w, 0, sizeof w);
    w.value_5d0377 = 0xdeadbee0u;
    fill(g_obj, OBJ, 31);
    memcpy(g_exp, g_obj, OBJ);
    m45b7a8_arm_hotspot(g_obj, 0x27bb, 0x1234, &w);
    CK(w.value_5d162d == 0xdeadbee0u && w.value_5b44f0 == 9 && w.value_5b44f4 == 1 && w.value_5d1631 == 0x5b160cu + (9u << 5) + 16u &&
       w.value_5d1639 == 1 && w.value_5c39e5 == 0x27bb && memcmp(g_obj, g_exp, OBJ) == 0);
    m45b7a8_arm_hotspot(g_obj, (int16_t)0x2000, (int16_t)0x8001, &w);
    set16(g_exp, 0x172, 0x8001);
    CK(w.value_5b44f0 == 0x16 && w.value_5b44f4 == 1 && w.value_5d1631 == 0x5b160cu + (0x16u << 5) + 16u && w.value_5c39e5 == 0x2000 &&
       memcmp(g_obj, g_exp, OBJ) == 0);
    m45b7a8_arm_hotspot(g_obj, (int16_t)-3, 0, &w);
    CK(w.value_5c39e5 == 0xfffffffdu);
}

static void test_m4b81ff_hit_test(void)
{
    static uint8_t obj[0x600];
    Fl18World w;
    Fl18Host h = host();
    memset(&w, 0, sizeof w);
    w.value_5d0377 = 0x01020304u;
    fill(obj, sizeof obj, 41);
    set32(obj, 0x55e, 10);
    set32(obj, 0x562, 20);
    set32(obj, 0x566, 30);
    set32(obj, 0x56a, 40);
    set16(obj, 0x55c, 5);
    add_region(0x00800000u, obj, sizeof obj);
    fill(g_obj, OBJ, 8);
    set32(g_obj, 8, 0x00800000u);
    set32(g_obj, 0x14, 1);
    CK(m4b81ff_hit_test(g_obj, 20, 30, &w, &h) == 1);
    CK(w.value_5d162d == 0x01020304u && w.value_5b44f0 == 5 && w.value_5b44f4 == 1 && w.value_5d1631 == 0x5b160cu + (5u << 5) + 16u &&
       w.value_5d1639 == 1 && w.value_5c39e5 == 0x27eb);
    /* each border is inclusive; just outside any of the four is a miss that leaves the globals alone */
    memset(&w, 0, sizeof w);
    CK(m4b81ff_hit_test(g_obj, 10, 20, &w, &h) == 1 && w.value_5c39e5 == 0x27eb);
    memset(&w, 0, sizeof w);
    CK(m4b81ff_hit_test(g_obj, 30, 40, &w, &h) == 1);
    memset(&w, 0, sizeof w);
    CK(m4b81ff_hit_test(g_obj, 9, 30, &w, &h) == 0 && m4b81ff_hit_test(g_obj, 31, 30, &w, &h) == 0 &&
       m4b81ff_hit_test(g_obj, 20, 19, &w, &h) == 0 && m4b81ff_hit_test(g_obj, 20, 41, &w, &h) == 0 && w.value_5c39e5 == 0);
    /* negative coordinates compare as signed */
    CK(m4b81ff_hit_test(g_obj, -1, 30, &w, &h) == 0);
    /* [this+0x14] == 0 */
    set32(g_obj, 0x14, 0);
    CK(m4b81ff_hit_test(g_obj, 20, 30, &w, &h) == 0 && w.value_5c39e5 == 0);
}

static void test_m423b51_reset_record(void)
{
    Fl18World w;
    Fl18Host h = host();
    size_t base = 4 + 2 * REC;
    int k;
    memset(&w, 0, sizeof w);
    w.records_5bb5e5 = g_records;
    fill(g_records, sizeof g_records, 51);
    memcpy(g_exp, g_records, sizeof g_records);
    set32(g_records, base + 4, 0);
    set32(g_exp, base + 4, 0);
    /* [p+4] == 0: no 0x423876; the slot is the record itself */
    m423b51_reset_record(g_obj, 2, &w, &h);
    CK(L.n == 1 && is_call(0, 0x4234c8, (uintptr_t)g_obj, 0));
    for (k = 0x1c; k <= 0x38; k += 4) set32(g_exp, base + (size_t)k, 0);
    set32(g_exp, base + 0, 0);
    set32(g_exp, base + 4, 0);
    set32(g_exp, base + 8, 0xffffffffu);
    for (k = 0xc; k <= 0x18; k += 4) set32(g_exp, base + (size_t)k, 0);
    CK(memcmp(g_records, g_exp, sizeof g_records) == 0);
    /* [p+4] != 0: 0x423876 gets (&slot, 0); it may repoint the slot, and the last stores go through the new slot */
    reset_log();
    fill(g_records, sizeof g_records, 52);
    set32(g_records, base + 4, 9);
    memcpy(g_exp, g_records, sizeof g_records);
    m423b51_reset_record(g_obj, 2, &w, &h);
    CK(L.n == 2 && is_call(1, 0x423876, (uintptr_t)g_obj, 2) && L.c[1].a[1] == 0 && L.c[1].a[0] != 0);
}

static void test_m4cc79a_draw_rects(void)
{
    static uint8_t list[16], entries[0x18 * 3];
    Fl18World w;
    Fl18Host h = host();
    int k;
    memset(&w, 0, sizeof w);
    memset(list, 0, sizeof list);
    set16(list, 2, 3);
    set32(list, 9, 0x00900000u);
    for (k = 0; k < 3; k++) {
        fill(entries + k * 0x18, 0x18, (uint8_t)(60 + k));
        set32(entries, (size_t)k * 0x18 + 4, 100u + (uint32_t)k);
        set32(entries, (size_t)k * 0x18 + 8, 200u + (uint32_t)k);
        set32(entries, (size_t)k * 0x18 + 0xc, 300u + (uint32_t)k);
        set32(entries, (size_t)k * 0x18 + 0x10, 400u + (uint32_t)k);
    }
    add_region(0x00a00000u, list, sizeof list);
    add_region(0x00900000u, entries, sizeof entries);
    w.value_63848d = 0x00a00000u;
    w.value_638483 = 1;
    w.origin_x_583186 = -7;
    w.origin_y_58318a = 11;
    w.value_5cf665 = 0xabc;
    m4cc79a_draw_rects(&w, &h);
    CK(L.n == 3 && w.value_638483 == 0);
    for (k = 0; k < 3 && k < L.n; k++) {
        CK(is_call(k, 0x4c7623, 0x5cf659, 3) && L.c[k].a[0] == 0xabc && (L.c[k].a[2] & 0xffff) == (0x10u + 0x400u * (unsigned)k));
        /* {x0, y0, x1, y1}: the x values get dword 0x583186 (-7), the y values dword 0x58318a (+11) */
        CK(L.c[k].rect[0] == 100u + (uint32_t)k - 7u && L.c[k].rect[1] == 200u + (uint32_t)k + 11u &&
           L.c[k].rect[2] == 300u + (uint32_t)k - 7u && L.c[k].rect[3] == 400u + (uint32_t)k + 11u);
    }
    /* flag clear: nothing, flag stays */
    reset_log();
    add_region(0x00a00000u, list, sizeof list);
    w.value_638483 = 0;
    m4cc79a_draw_rects(&w, &h);
    CK(L.n == 0 && w.value_638483 == 0);
}

static void test_m4b6097_arm_hotspot(void)
{
    Fl18World w;
    memset(&w, 0, sizeof w);
    w.value_5d0377 = 0x0a0b0c0du;
    fill(g_obj, OBJ, 71);
    memcpy(g_exp, g_obj, OBJ);
    m4b6097_arm_hotspot(g_obj, 0x276d, 0x4321, &w);
    set16(g_exp, 0x252, 0xffff);
    CK(w.value_5b44f0 == 9 && w.value_5b44f4 == 1 && w.value_5d162d == 0x0a0b0c0du && w.value_5d1631 == 0x5b160cu + (9u << 5) + 16u &&
       w.value_5d1639 == 1 && w.value_5c39e5 == 0x276d && memcmp(g_obj, g_exp, OBJ) == 0);
    m4b6097_arm_hotspot(g_obj, 0x276c, (int16_t)0x4321, &w);
    set16(g_exp, 0x252, 0x4321);
    CK(w.value_5b44f0 == 0x12 && w.value_5d1631 == 0x5b160cu + (0x12u << 5) + 16u && w.value_5c39e5 == 0x276c &&
       memcmp(g_obj, g_exp, OBJ) == 0);
    /* any other code leaves everything alone */
    memset(&w, 0, sizeof w);
    m4b6097_arm_hotspot(g_obj, 0x276b, 5, &w);
    CK(w.value_5b44f0 == 0 && w.value_5c39e5 == 0 && memcmp(g_obj, g_exp, OBJ) == 0);
}

static void test_m4b8d5e_expire_slots(void)
{
    static uint8_t obj[0x600];
    Fl18Host h = host();
    int k;
    memset(obj, 0, sizeof obj);
    fill(g_obj, OBJ, 5);
    set32(g_obj, 8, 0x00b00000u);
    add_region(0x00b00000u, obj, sizeof obj);
    set16(obj, 0x173, 4);
    set16(obj, 0x4e9, 0x1357);
    set16(g_obj, 0x48, 10);
    /* slot 0: expired (now - t)/1000 = 5 > 3; slot 1: 3 > 3 false; slot 2: state 2; slot 3: expired, limit negative word (0xffff) -> unsigned compare */
    for (k = 0; k < 4; k++) {
        set32(g_obj, (size_t)k * 0x37 + 0x7d, 1);
        set16(g_obj, (size_t)k * 0x37 + 0x7b, 3);
        set32(g_obj, (size_t)k * 0x37 + 0x77, 1000u);
    }
    L.tick = 6000;
    set32(g_obj, 0x37 + 0x77, 3000u);
    set32(g_obj, 2 * 0x37 + 0x7d, 2);
    set16(g_obj, 3 * 0x37 + 0x7b, 0xffff);
    memcpy(g_exp, g_obj, OBJ);
    m4b8d5e_expire_slots(g_obj, &h);
    set32(g_exp, 0x7d, 3);
    set16(g_exp, 0x48, 9);
    CK(L.ticks == 1 && memcmp(g_obj, g_exp, OBJ) == 0);
    CK(L.n == 2 && is_call(0, 0x4fb2e3, 0x5c3a67, 1) && (L.c[0].a[0] & 0xffff) == 0x1357);
    CK(is_call(1, 0x4b8a27, (uintptr_t)g_obj, 1) && L.c[1].a[0] == 2);
    /* nothing expires: no calls */
    reset_log();
    add_region(0x00b00000u, obj, sizeof obj);
    L.tick = 1500;
    set32(g_obj, 0x7d, 1);
    set32(g_obj, 0x37 + 0x7d, 0);
    m4b8d5e_expire_slots(g_obj, &h);
    CK(L.n == 0);
    /* wraparound of the tick subtraction (now below the stamp) is a large unsigned value */
    reset_log();
    add_region(0x00b00000u, obj, sizeof obj);
    L.tick = 10;
    set32(g_obj, 0x7d, 1);
    set32(g_obj, 0x77, 20);
    m4b8d5e_expire_slots(g_obj, &h);
    CK(L.n == 2 && get32(g_obj, 0x7d) == 3);
}

static void test_m410f99_init_entry(void)
{
    uint8_t dst[0xc0], src[0x80], exp[0xc0];
    size_t i;
    fill(dst, sizeof dst, 80);
    memcpy(exp, dst, sizeof dst);
    fill(src, sizeof src, 90);
    memcpy(src, "abcde", 6);
    m410f99_init_entry(dst, src, (int16_t)-2, 0x5a);
    memcpy(exp, "abcde", 6);
    memcpy(exp + 0x21, src + 0x21, 2);
    memcpy(exp + 0x27, src + 0x23, 4);
    memcpy(exp + 0x2b, src + 0x27, 2);
    memcpy(exp + 0x2d, src + 0x29, 2);
    exp[0x90] = src[0x2b];
    memcpy(exp + 0x91, src + 0x2c, 2);
    set16(exp, 0xa5, 0xfffe);
    exp[0xa7] = 0x5a;
    set32(exp, 0x2f, 0x1f4);
    set32(exp, 0x33, 0x7d0);
    set32(exp, 0x5b, 0x3e8);
    set32(exp, 0x5f, 0xa);
    exp[0x87] = 1;
    set16(exp, 0x97, 1);
    set16(exp, 0xa8, 2);
    CK(memcmp(dst, exp, sizeof dst) == 0);
    /* a string long enough to reach the field area: the field copies and constants win over the copied text */
    fill(dst, sizeof dst, 81);
    fill(src, sizeof src, 91);
    for (i = 0; i < 0x30; i++) src[i] = (uint8_t)('A' + i % 26);
    src[0x30] = 0;
    memcpy(exp, dst, sizeof dst);
    m410f99_init_entry(dst, src, 7, 1);
    memcpy(exp, src, 0x31);
    memcpy(exp + 0x21, src + 0x21, 2);
    memcpy(exp + 0x27, src + 0x23, 4);
    memcpy(exp + 0x2b, src + 0x27, 2);
    memcpy(exp + 0x2d, src + 0x29, 2);
    exp[0x90] = src[0x2b];
    memcpy(exp + 0x91, src + 0x2c, 2);
    set16(exp, 0xa5, 7);
    exp[0xa7] = 1;
    set32(exp, 0x2f, 0x1f4);
    set32(exp, 0x33, 0x7d0);
    set32(exp, 0x5b, 0x3e8);
    set32(exp, 0x5f, 0xa);
    exp[0x87] = 1;
    set16(exp, 0x97, 1);
    set16(exp, 0xa8, 2);
    /* copy of fields happens after the text, from the unchanged source */
    CK(memcmp(dst, exp, sizeof dst) == 0);
}

static const uint8_t k_pat_a[9] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
static const uint8_t k_pat_b[9] = {9, 8, 7, 6, 5, 4, 3, 2, 1};
static const uint8_t k_pat_c[9] = {1, 2, 3, 4, 5, 6, 7, 8, 0}; /* differs from k_pat_a only in the ninth byte */

static void test_m44d624_arm_timer(void)
{
    static uint8_t rec[0x300];
    Fl18World w;
    Fl18Host h = host();
    memset(&w, 0, sizeof w);
    memset(g_records, 0, sizeof g_records);
    set16(g_obj, 0, 0);
    fill(g_obj, OBJ, 17);
    set16(g_obj, 0x1e, 2);
    set32(g_obj, 0x25, 1);
    g_obj[0x49] = 0;
    set32(g_obj, 0x29, 1);
    set32(g_records, 2 * REC + 0x4d, 1);
    set32(g_records, 2 * REC, 0x00c00000u);
    fill(rec, sizeof rec, 99);
    set16(rec, 0x261, 0xfffe);
    set16(rec, 0x286, 0x0102);
    memcpy(rec + 0x265, k_pat_a, 9);
    add_region(0x00c00000u, rec, sizeof rec);
    w.records_5bb5e5 = g_records;
    w.bytes_5495b0 = k_pat_a;
    L.tick = 5000;
    /* 0x5bb1ca clear: no calls, the timer is armed */
    memcpy(g_exp, g_obj, OBJ);
    m44d624_arm_timer(g_obj, &w, &h);
    set32(g_exp, 0x2d, 2);
    set32(g_exp, 0x4b, 5000u - 200u);
    g_exp[0x24] = 1;
    CK(L.n == 0 && L.ticks == 1 && memcmp(g_obj, g_exp, OBJ) == 0);
    /* equal text: still no call */
    reset_log();
    add_region(0x00c00000u, rec, sizeof rec);
    L.tick = 5000;
    w.value_5bb1ca = 1;
    m44d624_arm_timer(g_obj, &w, &h);
    CK(L.n == 0);
    /* different text: 0x4f6334 with the signed word; its zero return triggers 0x4fb2e3 */
    reset_log();
    add_region(0x00c00000u, rec, sizeof rec);
    L.tick = 5000;
    w.bytes_5495b0 = k_pat_b;
    m44d624_arm_timer(g_obj, &w, &h);
    CK(L.n == 2 && is_call(0, 0x4f6334, 0x5cf1eb, 1) && L.c[0].a[0] == 0x102 && is_call(1, 0x4fb2e3, 0x5c3a67, 1) &&
       (L.c[1].a[0] & 0xffff) == 0x102);
    /* a difference in the ninth byte alone still counts (all nine bytes are compared) */
    reset_log();
    add_region(0x00c00000u, rec, sizeof rec);
    L.tick = 5000;
    w.bytes_5495b0 = k_pat_c;
    m44d624_arm_timer(g_obj, &w, &h);
    CK(L.n == 2 && L.c[0].callee == 0x4f6334);
    w.bytes_5495b0 = k_pat_b;
    /* a non-zero return from 0x4f6334 skips 0x4fb2e3 */
    reset_log();
    add_region(0x00c00000u, rec, sizeof rec);
    L.tick = 5000;
    queue_return(0x4f6334, 1);
    m44d624_arm_timer(g_obj, &w, &h);
    CK(L.n == 1);
    /* a gate that fails leaves everything: [this+0x25] == 0 */
    reset_log();
    set32(g_obj, 0x25, 0);
    memcpy(g_exp, g_obj, OBJ);
    m44d624_arm_timer(g_obj, &w, &h);
    CK(L.n == 0 && L.ticks == 0 && memcmp(g_obj, g_exp, OBJ) == 0);
    set32(g_obj, 0x25, 1);
    g_obj[0x49] = 1;
    memcpy(g_exp, g_obj, OBJ);
    m44d624_arm_timer(g_obj, &w, &h);
    CK(L.ticks == 0 && memcmp(g_obj, g_exp, OBJ) == 0);
    g_obj[0x49] = 0;
    set32(g_records, 2 * REC + 0x4d, 2);
    m44d624_arm_timer(g_obj, &w, &h);
    CK(L.ticks == 0);
}

static void test_m4631d1_check_piece(void)
{
    static uint8_t rec[0x300];
    Fl18World w;
    Fl18Host h = host();
    memset(&w, 0, sizeof w);
    memset(g_records, 0, sizeof g_records);
    fill(g_obj, OBJ, 18);
    set16(g_obj, 0x1e, 1);
    set32(g_obj, 0x3f, 1);
    set32(g_obj, 0x47, 0);
    set32(g_obj, 0x24, 0);
    set32(g_records, 1 * REC + 0x4d, 1);
    set32(g_records, 1 * REC, 0x00d00000u);
    fill(rec, sizeof rec, 98);
    set16(rec, 0x270, 0x0707);
    memcpy(rec + 0x24f, k_pat_a, 9);
    add_region(0x00d00000u, rec, sizeof rec);
    w.records_5bb5e5 = g_records;
    w.bytes_54b158 = k_pat_b;
    w.value_5c39e5 = 0x277f;
    /* selector 0x277f: [this+0x43] := 1, record +0x4d := 2 */
    memcpy(g_exp, g_obj, OBJ);
    m4631d1_check_piece(g_obj, &w, &h);
    set32(g_exp, 0x43, 1);
    CK(L.n == 0 && memcmp(g_obj, g_exp, OBJ) == 0 && get32(g_records, 1 * REC + 0x4d) == 2);
    /* other selector, word [this+0x57] set: [this+0x24] := 2; the text differs and 0x5bb1ca is set: 0x4fb2e3 */
    set32(g_records, 1 * REC + 0x4d, 1);
    w.value_5c39e5 = 0x1111;
    w.value_5bb1ca = 1;
    set16(g_obj, 0x57, 0xfffe);
    set32(g_obj, 0x43, 0);
    memcpy(g_exp, g_obj, OBJ);
    m4631d1_check_piece(g_obj, &w, &h);
    set32(g_exp, 0x24, 2);
    CK(L.n == 1 && is_call(0, 0x4fb2e3, 0x5c3a67, 1) && (L.c[0].a[0] & 0xffff) == 0x707 && memcmp(g_obj, g_exp, OBJ) == 0 &&
       get32(g_records, 1 * REC + 0x4d) == 1);
    /* a difference in the ninth byte alone still counts */
    reset_log();
    add_region(0x00d00000u, rec, sizeof rec);
    set32(g_obj, 0x24, 0);
    w.bytes_54b158 = k_pat_c;
    m4631d1_check_piece(g_obj, &w, &h);
    CK(L.n == 1);
    w.bytes_54b158 = k_pat_b;
    /* same text: no call; 0x5bb1ca clear: no call */
    reset_log();
    add_region(0x00d00000u, rec, sizeof rec);
    set32(g_obj, 0x24, 0);
    w.bytes_54b158 = k_pat_a;
    m4631d1_check_piece(g_obj, &w, &h);
    CK(L.n == 0 && get32(g_obj, 0x24) == 2);
    set32(g_obj, 0x24, 0);
    w.bytes_54b158 = k_pat_b;
    w.value_5bb1ca = 0;
    m4631d1_check_piece(g_obj, &w, &h);
    CK(L.n == 0 && get32(g_obj, 0x24) == 2);
    /* the word is zero: nothing changes */
    set32(g_obj, 0x24, 0);
    set16(g_obj, 0x57, 0);
    memcpy(g_exp, g_obj, OBJ);
    m4631d1_check_piece(g_obj, &w, &h);
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
    /* a gate fails: [this+0x47] != 0 */
    w.value_5c39e5 = 0x277f;
    set32(g_obj, 0x47, 1);
    memcpy(g_exp, g_obj, OBJ);
    m4631d1_check_piece(g_obj, &w, &h);
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && get32(g_records, 1 * REC + 0x4d) == 1);
}

static void test_m41632b_free_buffers(void)
{
    Fl18Host h = host();
    fill(g_obj, OBJ, 23);
    set32(g_obj, 0x17a, 0x1111);
    set32(g_obj, 0x17e, 0x2222);
    memcpy(g_exp, g_obj, OBJ);
    m41632b_free_buffers(g_obj, &h);
    set32(g_exp, 0x17a, 0);
    set32(g_exp, 0x17e, 0);
    set16(g_exp, 0x182, 0);
    set16(g_exp, 0x184, 0);
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && L.n == 2);
    CK(is_call(0, 0x51dc6c, 0, 1) && L.c[0].a[0] == 0x1111 && is_call(1, 0x51dc6c, 0, 1) && L.c[1].a[0] == 0x2222);
    /* only the second set: one call; none set: no calls but the words are cleared */
    reset_log();
    set32(g_obj, 0x17a, 0);
    set32(g_obj, 0x17e, 0x3333);
    set16(g_obj, 0x182, 9);
    m41632b_free_buffers(g_obj, &h);
    CK(L.n == 1 && L.c[0].a[0] == 0x3333 && get32(g_obj, 0x17e) == 0 && get16(g_obj, 0x182) == 0);
    reset_log();
    set16(g_obj, 0x184, 9);
    m41632b_free_buffers(g_obj, &h);
    CK(L.n == 0 && get16(g_obj, 0x184) == 0);
}

static void test_m4c08d3_shift_rects(void)
{
    static uint8_t s[0x40];
    Fl18World w;
    Fl18Host h = host();
    memset(&w, 0, sizeof w);
    fill(s, sizeof s, 61);
    fill(g_obj, OBJ, 24);
    set32(g_obj, 0x24a, 0x00e00000u);
    add_region(0x00e00000u, s, sizeof s);
    w.origin_x_583186 = -300;
    w.origin_y_58318a = 70;
    memcpy(g_exp, g_obj, OBJ);
    m4c08d3_shift_rects(g_obj, &w, &h);
    set32(g_exp, 0x1e2, get32(s, 6));
    set32(g_exp, 0x1ea, get32(s, 0xe));
    set32(g_exp, 0x1de, get32(s, 2));
    set32(g_exp, 0x1e6, get32(s, 0xa));
    set32(g_exp, 0x1f2, get32(s, 0x16) + 70u);
    set32(g_exp, 0x1fa, get32(s, 0x1e) + 70u);
    set32(g_exp, 0x1ee, get32(s, 0x12) - 300u);
    set32(g_exp, 0x1f6, get32(s, 0x1a) - 300u);
    set32(g_exp, 0x202, get32(s, 0x16));
    set32(g_exp, 0x20a, get32(s, 0x1e));
    set32(g_exp, 0x1fe, get32(s, 0x12));
    set32(g_exp, 0x206, get32(s, 0x1a));
    CK(memcmp(g_obj, g_exp, OBJ) == 0);
}

static void test_m4c0774_open_piece(void)
{
    static uint8_t s[0x60], flags[0x100];
    Fl18World w;
    Fl18Host h = host();
    memset(&w, 0, sizeof w);
    memset(flags, 0xee, sizeof flags);
    w.flags_585801 = flags + 0x40;
    fill(s, sizeof s, 71);
    set16(s, 0x21, 1);
    set16(s, 0x37, 3);
    set16(s, 0x39, 0xfffe);
    set16(s, 0x25, 5);
    set16(s, 0x2f, 0xfff0);
    set16(s, 0x31, 0x1111);
    set16(s, 0x33, 0x2222);
    set16(s, 0x35, 0x3333);
    set16(s, 0x23, 1);
    add_region(0x00f00000u, s, sizeof s);
    fill(g_obj, OBJ, 25);
    set32(g_obj, 0x22a, 0x00f00000u);
    set16(g_obj, 0x1d4, 0);
    set32(g_obj, 0x20e, 0xa5a5a5a5u);
    w.value_5bb1ca = 7;
    memcpy(g_exp, g_obj, OBJ);
    m4c0774_open_piece(g_obj, 0x1234, &w, &h);
    set32(g_exp, 0x240, 0);
    CK(memcmp(g_obj, g_exp, OBJ) == 0 && w.value_5d19fb == 0 && w.value_5839a9 == 0xa5a5a5a5u && w.value_5c39f9 == 0);
    CK(get32(flags, 0x40 + 12) == 0xfffffffeu && w.value_5bb57b == 0xfffffff0u && w.word_5bb599 == 0x1111 && w.word_5bb595 == 0x2222 &&
       w.word_5c39ff == 0x3333 && w.value_5bb59b == 0 && w.value_5bb59f == 0 && w.value_5bb5a3 == 1 && w.value_583999 == 4);
    CK(w.value_5bb1ca == 0);
    CK(L.n == 3 && is_call(0, 0x4d36ed, 0, 0) && is_call(1, 0x4bf773, (uintptr_t)g_obj, 0) && is_call(2, 0x42ba3a, 0, 1) &&
       (L.c[2].a[0] & 0xffff) == 0x1234);
    /* word +0x37 is -1 (no flag store), +0x25 is not 5, +0x23 is not 1; nothing at all when both +0x21 and +0x1d4 are 0 */
    reset_log();
    add_region(0x00f00000u, s, sizeof s);
    memset(flags, 0xee, sizeof flags);
    set16(s, 0x37, 0xffff);
    set16(s, 0x25, 4);
    set16(s, 0x23, 2);
    memset(&w, 0, sizeof w);
    w.flags_585801 = flags + 0x40;
    m4c0774_open_piece(g_obj, 1, &w, &h);
    CK(flags[0x40 + 12] == 0xee && w.value_5bb57b == 0 && w.value_583999 == 0 && w.value_5bb1ca == 1 && L.n == 3);
    reset_log();
    add_region(0x00f00000u, s, sizeof s);
    set16(s, 0x21, 0);
    memset(&w, 0, sizeof w);
    w.flags_585801 = flags + 0x40;
    set32(g_obj, 0x240, 77);
    set16(g_obj, 0x1d4, 0);
    m4c0774_open_piece(g_obj, 1, &w, &h);
    CK(L.n == 0 && get32(g_obj, 0x240) == 77 && w.value_5bb1ca == 0);
    /* [self+0x1d4] non-zero is enough */
    set16(g_obj, 0x1d4, 3);
    add_region(0x00f00000u, s, sizeof s);
    m4c0774_open_piece(g_obj, 1, &w, &h);
    CK(L.n == 3 && get32(g_obj, 0x240) == 0);
}

static void test_m4d07e7_draw_texts(void)
{
    static uint8_t obj[0x20], dwords[0x80];
    static const uint8_t text_a[4] = {'a', 'b', 0, 0}, text_b[4] = {0, 'x', 0, 0};
    Fl18World w;
    Fl18Host h = host();
    memset(&w, 0, sizeof w);
    memset(g_records, 0, sizeof g_records);
    set32(g_records, 2 * REC, 0x00a10000u);
    memset(obj, 0, sizeof obj);
    set16(obj, 0, (uint16_t)-2);
    add_region(0x00a10000u, obj, sizeof obj);
    memset(dwords, 0, sizeof dwords);
    set32(dwords, 0x40 - 8, 0x99887766u);
    w.records_5bb5e5 = g_records;
    w.word_5b61b0 = 2;
    w.dwords_5d032f = dwords + 0x40;
    w.value_5d15e3 = 0x1357;
    w.value_5cf665 = 0x2468;
    w.word_5b61dd = 0xaaaa;
    w.word_5b61d1 = 0xbbbb;
    w.word_5b61e1 = 0xcccc;
    w.word_5b61ed = 0xdddd;
    w.string_5b618e = text_a;
    m4d07e7_draw_texts(&w, &h);
    CK(L.n == 3 && is_call(0, 0x4c5377, 0x5cf659, 5));
    CK(L.c[0].a[0] == 0x1357 && L.c[0].a[1] == 0x2468 && L.c[0].a[2] == 0x00a10024u && L.c[0].a[3] == 0x5b61c1 && L.c[0].a[4] == 0x55a004);
    CK(is_call(1, 0x4d2c20, 0, 8) && L.c[1].a[0] == 0x5b616d && L.c[1].a[1] == 0x5a4c24u - 2u * 0x7f3u &&
       L.c[1].a[2] == 0x5adb3au - 2u * 0x1d0u && (L.c[1].a[3] & 0xffff) == 0xbbbb && (L.c[1].a[4] & 0xffff) == 0xaaaa &&
       L.c[1].a[5] == 0x99887766u && L.c[1].a[6] == 0x2468 && L.c[1].a[7] == 0);
    CK(is_call(2, 0x4d2c20, 0, 8) && L.c[2].a[0] == 0x5b618e && L.c[2].a[1] == L.c[1].a[1] && L.c[2].a[2] == L.c[1].a[2] &&
       (L.c[2].a[3] & 0xffff) == 0xcccc && (L.c[2].a[4] & 0xffff) == 0xdddd && L.c[2].a[5] == 0x99887766u && L.c[2].a[6] == 0x2468 &&
       L.c[2].a[7] == 0);
    /* an empty string: only the first text call */
    reset_log();
    add_region(0x00a10000u, obj, sizeof obj);
    w.string_5b618e = text_b;
    m4d07e7_draw_texts(&w, &h);
    CK(L.n == 2);
}

int main(void)
{
    int failures = 0;
    RUN(test_m4c924d_count_up);
    RUN(test_m4121b8_start_piece);
    RUN(test_m4e7bf3_close_slots);
    RUN(test_m4b7051_draw_list);
    RUN(test_m4b7f3b_reset);
    RUN(test_m4b7ff4_release);
    RUN(test_m4e7253_store_record);
    RUN(test_m4e8dc8_check_slots);
    RUN(test_m45b7a8_arm_hotspot);
    RUN(test_m4b81ff_hit_test);
    RUN(test_m423b51_reset_record);
    RUN(test_m4cc79a_draw_rects);
    RUN(test_m4b6097_arm_hotspot);
    RUN(test_m4b8d5e_expire_slots);
    RUN(test_m410f99_init_entry);
    RUN(test_m44d624_arm_timer);
    RUN(test_m4631d1_check_piece);
    RUN(test_m41632b_free_buffers);
    RUN(test_m4c08d3_shift_rects);
    RUN(test_m4c0774_open_piece);
    RUN(test_m4d07e7_draw_texts);
    return failures;
}
