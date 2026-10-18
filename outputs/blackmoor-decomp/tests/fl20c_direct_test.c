/* FL-20 (batch c) direct tests of the functions of GAME.EXE in src/original_methods_fl20c.c. Prints "PASS <name>" / "FAIL <name>: <msg>";
 * the exit status is the failure count. Fixtures are synthetic (no original bytes). Expected values come from the disassembly of
 * GAME.EXE, not from running the native code; tests/test_fl20c_differential.py additionally runs the original bytes on random fixtures.
 */
#include "../src/original_methods_fl20c.h"

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
        for (k = 0; k < nargs && k < 12; k++) c->a[k] = args[k];
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

static uint32_t rect_word(const uint8_t *snap, int i) { return get32(snap, (size_t)i * 4); }

static void test_m4b9a88_draw_slots(void)
{
    static uint8_t obj[0x500], table[0x4a * 3], slots[0x37 * 1300];
    const uint32_t obj_va = 0x00d30000u;
    Fl20cWorld w;
    Fl18Host h = host();
    uint8_t before[0x37 * 5];
    memset(&w, 0, sizeof w);
    memset(obj, 0x5a, sizeof obj);
    memset(table, 0, sizeof table);
    set32(table, 0, 0xaaa00000u);
    set32(table, 0x4a, 0xaaa00001u);
    set32(table, 0x94, 0xbbb00002u);
    w.table_5d1599 = table;
    w.slots_61eeb8 = slots;
    w.word_61ee72 = 1;
    w.value_61ee82 = 1;
    w.value_61ee8e = 0;
    w.value_61ee76 = obj_va;
    w.value_5cf665 = 0xc0de0001u;
    w.value_5d0357 = 0x0d0357d0u;
    w.value_5d15e3 = 0xaaa00001u;
    w.origin_x_583186 = 7;
    w.origin_y_58318a = -9;
    /* five slots: 1, 2, 3, then 0 and 4 do nothing */
    memset(slots, 0x66, 0x37 * 5);
    set16(obj, 0x173, 5);
    set32(slots, 0 * 0x37 + 0x33, 1);
    slots[0 * 0x37 + 0x20] = 'Q';
    set16(slots, 0 * 0x37 + 0x21, 0x1234);
    set16(slots, 0 * 0x37 + 0x25, 0x5678);
    set32(slots, 1 * 0x37 + 0x33, 2);
    set32(slots, 2 * 0x37 + 0x33, 3);
    set32(slots, 2 * 0x37 + 0x10, 100);
    set32(slots, 2 * 0x37 + 0x14, 200);
    set32(slots, 2 * 0x37 + 0x18, 300);
    set32(slots, 2 * 0x37 + 0x1c, 400);
    set32(slots, 3 * 0x37 + 0x33, 0);
    set32(slots, 4 * 0x37 + 0x33, 4);
    memcpy(before, slots, sizeof before);
    reset_log();
    add_region(obj_va, obj, sizeof obj);
    m4b9a88_draw_slots(&w, &h);
    CK(L.n == 5);
    /* slot 0: 0x4c5d4b (table[1], 0x5cf665, slot, slot+0x10, 0x551e54), then 0x4d2c20 with the string "Q" and the leftover halves */
    CK(is_call(0, 0x4c5d4b, 0x5cf659, 5) && L.c[0].a[0] == 0xaaa00001u && L.c[0].a[1] == 0xc0de0001u && L.c[0].a[2] == 0x61eeb8u &&
       L.c[0].a[3] == 0x61eec8u && L.c[0].a[4] == 0x551e54);
    CK(is_call(1, 0x4d2c20, 0, 8) && L.c[1].pd[0][0] == 'Q' && L.c[1].pd[0][1] == 0 && L.c[1].a[1] == 0x5a9ba2 && L.c[1].a[2] == 0x5aed5a &&
       L.c[1].a[3] == 0x1234u && L.c[1].a[4] == 0xc0de5678u && L.c[1].a[5] == 0x0d0357d0u && L.c[1].a[6] == 0xc0de0001u && L.c[1].a[7] == 0);
    /* slot 1: 0x4c5d4b with obj + 0x163, then 0x4b8e42 on the singleton with the slot number */
    CK(is_call(2, 0x4c5d4b, 0x5cf659, 5) && L.c[2].a[0] == 0xaaa00001u && L.c[2].a[1] == 0xc0de0001u && L.c[2].a[2] == obj_va + 0x163 &&
       L.c[2].a[3] == 0x61eeb8u + 0x37 + 0x10 && L.c[2].a[4] == 0x551e6c);
    CK(is_call(3, 0x4b8e42, 0x61ee6e, 1) && (L.c[3].a[0] & 0xffff) == 1);
    /* slot 2: the rectangle moved by the origin, 0x4c5377, state cleared */
    CK(is_call(4, 0x4c5377, 0x5cf659, 5) && L.c[4].a[0] == 0xaaa00001u && L.c[4].a[1] == 0xc0de0001u && L.c[4].a[3] == 0x61eeb8u + 2 * 0x37 + 0x10 &&
       L.c[4].a[4] == 0x551e84);
    CK(rect_word(L.c[4].pd[2], 0) == 93 && rect_word(L.c[4].pd[2], 1) == 209 && rect_word(L.c[4].pd[2], 2) == 293 && rect_word(L.c[4].pd[2], 3) == 409);
    CK(get32(slots, 2 * 0x37 + 0x33) == 0);
    set32(before, 2 * 0x37 + 0x33, 0);
    CK(memcmp(slots, before, sizeof before) == 0);
    /* the upper half of the pushed word a is the upper half of k * 0x37: slot 1250 (68750 = 0x10c8e) in state 1 */
    reset_log();
    add_region(obj_va, obj, sizeof obj);
    memset(slots, 0, sizeof slots);
    set16(obj, 0x173, 1251);
    set32(slots, 1250 * 0x37 + 0x33, 1);
    slots[1250 * 0x37 + 0x20] = 'Z';
    set16(slots, 1250 * 0x37 + 0x21, 0xbeef);
    set16(slots, 1250 * 0x37 + 0x25, 0x4321);
    m4b9a88_draw_slots(&w, &h);
    CK(L.n == 2 && is_call(0, 0x4c5d4b, 0x5cf659, 5) && L.c[0].a[2] == 0x61eeb8u + 68750u && L.c[0].a[3] == 0x61eeb8u + 68750u + 0x10);
    CK(is_call(1, 0x4d2c20, 0, 8) && L.c[1].pd[0][0] == 'Z' && L.c[1].a[3] == (0x10000u | 0xbeef) && L.c[1].a[4] == 0xc0de4321u);
    /* the singleton flag is clear: nothing at all */
    reset_log();
    add_region(obj_va, obj, sizeof obj);
    w.value_61ee82 = 0;
    m4b9a88_draw_slots(&w, &h);
    CK(L.n == 0);
    w.value_61ee82 = 7;
    /* the flag at 0x61ee8e: the rectangle is centred on the middle of the screen box (w = 40, h = 61) and 0x61eea2 is cleared first */
    reset_log();
    add_region(obj_va, obj, sizeof obj);
    w.value_61ee8e = 1;
    w.value_61eea2 = 1;
    w.origin_x_583186 = 10;
    w.origin_x2_58318e = 71;
    w.origin_y_58318a = -9;
    w.origin_y2_583192 = 100;
    set32(obj, 0x41d, 100);
    set32(obj, 0x425, 140);
    set32(obj, 0x421, 50);
    set32(obj, 0x429, 111);
    m4b9a88_draw_slots(&w, &h);
    CK(L.n == 2 && w.value_61eea2 == 0);
    CK(is_call(0, 0x4c5377, 0x5cf659, 5) && L.c[0].a[0] == 0xaaa00001u && L.c[0].a[1] == 0xc0de0001u && L.c[0].a[2] == 0x583196 &&
       L.c[0].a[3] == 0x583186 && L.c[0].a[4] == 0x551ea0);
    CK(is_call(1, 0x4c5d4b, 0x5cf659, 5) && L.c[1].a[0] == 0xaaa00001u && L.c[1].a[1] == 0xc0de0001u && L.c[1].a[2] == obj_va + 0x41d &&
       L.c[1].a[4] == 0x551ec0);
    CK(rect_word(L.c[1].pd[3], 0) == 20 && rect_word(L.c[1].pd[3], 1) == 15 && rect_word(L.c[1].pd[3], 2) == 60 && rect_word(L.c[1].pd[3], 3) == 76);
    /* 0x61eea2 clear and negative odd extents round toward zero: w = -5, h = 3; x2 - x = -13 gives -6 */
    reset_log();
    add_region(obj_va, obj, sizeof obj);
    w.value_61eea2 = 0;
    w.origin_x_583186 = 10;
    w.origin_x2_58318e = -3;
    w.origin_y_58318a = 0;
    w.origin_y2_583192 = 7;
    set32(obj, 0x41d, 6);
    set32(obj, 0x425, 1);
    set32(obj, 0x421, 0);
    set32(obj, 0x429, 3);
    m4b9a88_draw_slots(&w, &h);
    CK(L.n == 1 && is_call(0, 0x4c5d4b, 0x5cf659, 5));
    CK(rect_word(L.c[0].pd[3], 0) == 6 && rect_word(L.c[0].pd[3], 1) == 2 && rect_word(L.c[0].pd[3], 2) == 1 && rect_word(L.c[0].pd[3], 3) == 5);
}

/* ---- 0x4619be ---- */

typedef struct DirCase {
    int dir, row, col;
    int mr, mc, off, val;   /* one cell word set before the call (off 0x24 = T, 0x26 = U); off 0: none */
    int ok;
} DirCase;

static void test_m4619be_check_direction(void)
{
    static uint8_t obj[0x100], cells[0x4000];
    static uint8_t self[0x100];
    const uint32_t obj_va = 0x00d40000u;
    /* the object has 4 rows ([obj+0x22]) and 5 columns ([obj+0x24]); the cursor is at row 2, column 3 unless a case says otherwise */
    static const DirCase cases[] = {
        /* 0x10: left, looks at (r, c) and (r, c-1) */
        {0x10, 2, 3, 0, 0, 0, 0, 1},
        {0x10, 2, 0, 0, 0, 0, 0, 0},
        {0x10, 2, 3, 2, 3, 0x24, 0x10, 0},
        {0x10, 2, 3, 2, 2, 0x24, 0x13, 0},
        {0x10, 2, 3, 2, 2, 0x26, -1, 0},
        {0x10, 2, 3, 2, 2, 0x26, 0x100, 0},
        {0x10, 2, 3, 2, 2, 0x24, 0x14, 0},
        {0x10, 2, 3, 2, 4, 0x24, 0x10, 1},
        {0x10, 2, 3, 2, 2, 0x24, 0x10, 1},
        {0x10, 2, 3, 2, 3, 0x24, 0x13, 1},
        {0x10, 2, 3, 1, 2, 0x24, 0x13, 1},
        {0x10, 2, 3, 2, 3, 0x26, 1, 1},
        {0x10, 2, 3, 2, 2, 0x24, 0x11, 1},
        /* 0x11: up, looks at (r, c) and (r-1, c) */
        {0x11, 2, 3, 0, 0, 0, 0, 1},
        {0x11, 0, 3, 0, 0, 0, 0, 0},
        {0x11, 2, 3, 2, 3, 0x24, 0x11, 0},
        {0x11, 2, 3, 1, 3, 0x24, 0x12, 0},
        {0x11, 2, 3, 1, 3, 0x26, 7, 0},
        {0x11, 2, 3, 1, 3, 0x24, 0x14, 0},
        {0x11, 2, 3, 3, 3, 0x24, 0x11, 1},
        {0x11, 2, 3, 1, 3, 0x24, 0x11, 1},
        {0x11, 2, 3, 2, 3, 0x26, 1, 1},
        {0x11, 2, 3, 2, 2, 0x24, 0x12, 1},
        /* 0x12: down, looks at (r, c) and (r+1, c); the last row is [obj+0x22] - 1 = 3 */
        {0x12, 2, 3, 0, 0, 0, 0, 1},
        {0x12, 3, 3, 0, 0, 0, 0, 0},
        {0x12, 2, 3, 2, 3, 0x24, 0x12, 0},
        {0x12, 2, 3, 3, 3, 0x24, 0x11, 0},
        {0x12, 2, 3, 3, 3, 0x26, 2, 0},
        {0x12, 2, 3, 3, 3, 0x24, 0x14, 0},
        {0x12, 2, 3, 1, 3, 0x24, 0x11, 1},
        {0x12, 2, 3, 3, 3, 0x24, 0x12, 1},
        {0x12, 2, 3, 2, 3, 0x26, 1, 1},
        {0x12, 1, 3, 0, 0, 0, 0, 1},
        /* 0x13: right, looks at (r, c) and (r, c+1); the last column is [obj+0x24] - 1 = 4 */
        {0x13, 2, 3, 0, 0, 0, 0, 1},
        {0x13, 2, 4, 0, 0, 0, 0, 0},
        {0x13, 2, 3, 2, 3, 0x24, 0x13, 0},
        {0x13, 2, 3, 2, 4, 0x24, 0x10, 0},
        {0x13, 2, 3, 2, 4, 0x26, 0x4000, 0},
        {0x13, 2, 3, 2, 4, 0x24, 0x14, 0},
        {0x13, 2, 3, 2, 2, 0x24, 0x10, 1},
        {0x13, 2, 3, 2, 4, 0x24, 0x13, 1},
        {0x13, 2, 3, 2, 3, 0x26, 1, 1},
        {0x13, 2, 2, 0, 0, 0, 0, 1},
        /* other directions never fail (the unsigned compare of the switch), whatever the cells hold */
        {0x0f, 2, 3, 2, 3, 0x24, 0x10, 1},
        {0x14, 2, 0, 2, 3, 0x24, 0x10, 1},
        {0, 0, 0, 0, 0, 0, 0, 1},
        {-1, 3, 4, 0, 0, 0, 0, 1},
        {0x30, 3, 4, 0, 0, 0, 0, 1},
        {-32768, 3, 4, 0, 0, 0, 0, 1},
    };
    size_t i;
    Fl20cWorld w;
    Fl18Host h = host();
    memset(&w, 0, sizeof w);
    w.records_5bb5e5 = g_records;
    w.cells_594db5 = cells + 0x2000;
    for (i = 0; i < sizeof cases / sizeof cases[0]; i++) {
        const DirCase *c = &cases[i];
        int32_t ok;
        uint8_t before[sizeof self];
        reset_log();
        add_region(obj_va, obj, sizeof obj);
        memset(g_records, 0, sizeof g_records);
        set32(g_records, 2 * REC, obj_va);
        memset(obj, 0x33, sizeof obj);
        set16(obj, 0x22, 4);
        set16(obj, 0x24, 5);
        memset(cells, 0, sizeof cells);
        memset(self, 0x77, sizeof self);
        set16(self, 0x1e, 2);
        set16(self, 0x5b, (uint16_t)c->row);
        set16(self, 0x5d, (uint16_t)c->col);
        if (c->off != 0) set16(cells, 0x2000 + (size_t)((ptrdiff_t)c->mr * 0x140 + (ptrdiff_t)c->mc * 0x28 + c->off), (uint16_t)c->val);
        memcpy(before, self, sizeof self);
        ok = m4619be_check_direction(self, (int16_t)c->dir, &w, &h);
        CK(ok == c->ok);
        CK(L.n == 0);
        if (c->ok) {
            set16(before, 0x57, (uint16_t)c->dir);
        } else {
            set16(before, 0x39, 0);
            set16(before, 0x57, 0);
            set16(before, 0x59, 0);
        }
        if (memcmp(self, before, sizeof self) != 0 && !g_failed) {
            g_failed = 1;
            snprintf(g_msg, sizeof g_msg, "case %d (dir 0x%x): object differs", (int)i, c->dir);
        }
        if (g_failed && g_msg[0] == 0) snprintf(g_msg, sizeof g_msg, "case %d", (int)i);
        if (g_failed) return;
    }
}

/* ---- 0x481cb9 ---- */

#define CELL_VA(m) (0x62669cu + (uint32_t)(m) * 0x25u)

static void set_cell(uint8_t *slots, int m, int16_t word, uint8_t b22, uint8_t b23, uint8_t b24)
{
    uint8_t *c = slots + (size_t)(m + 1) * 0x25;   /* the buffer holds one cell below cell 0 */
    set16(c, 0, (uint16_t)word);
    c[0x22] = b22;
    c[0x23] = b23;
    c[0x24] = b24;
}

static void test_m481cb9_draw_cells(void)
{
    static uint8_t slots[0x25 * 6], table[0x200];
    const uint32_t rec_va = 0x00e50000u;
    Fl20cWorld w;
    Fl18Host h = host();
    uint32_t q1, q2, q3;
    size_t k;
    memset(&w, 0, sizeof w);
    memset(table, 0, sizeof table);
    for (k = 0; k < sizeof table; k += 4) set32(table, k, 0x7a000000u + (uint32_t)k);
    memset(g_records, 0, sizeof g_records);
    set32(g_records, 1 * REC, rec_va);
    w.records_5bb5e5 = g_records;
    w.slots_62669c = slots + 0x25;
    w.table_625f08 = table;
    w.word_625f06 = 1;
    w.value_5cf665 = 0xc0de0001u;
    w.value_5d15e3 = 0xaaa00003u;
    w.value_62728c = 0x5a5a0001u;
    w.value_627290 = 0x5a5a0002u;
    w.value_627294 = 0x5a5a0003u;
    /* A: 3 cells drawn in the order of their words (cell 1, cell 2, cell 0); the three flags 0x627230, 0x627234 and 0x62729a */
    memset(slots, 0x66, sizeof slots);
    set_cell(slots, 0, 2, 3, 2, 0);   /* word 2: i = 2; no table entry; 0x47e99e says no */
    set_cell(slots, 1, 0, 2, 1, 1);   /* word 0: i = 0; table: idx = 1 * 0x60 + 2 * 0x18 = 0x90 */
    set_cell(slots, 2, 1, 0, 3, 0);   /* word 1: i = 1; 0x47e99e says yes */
    w.word_62728a = 3;
    w.value_627230 = 1;
    w.value_62722c = 0;
    w.value_627234 = 1;
    w.byte_62729a = 1;
    w.byte_62729b = 1;
    reset_log();
    queue_return(0x47e99e, 1);
    queue_return(0x47e99e, 0);
    queue_write(0x47e52f, 0, 1, 0, 4, 0x11111111u);
    queue_write(0x47e52f, 0, 1, 4, 4, 0x22222222u);
    queue_write(0x47e52f, 0, 1, 8, 4, 0x33333333u);
    queue_write(0x47e52f, 0, 1, 12, 4, 0x44444444u);
    queue_write(0x47e52f, 1, 1, 0, 4, 0x55555555u);
    m481cb9_draw_cells(&w, &h);
    CK(L.n == 9);
    CK(is_call(0, 0x4c5377, 0x5cf659, 5) && L.c[0].a[0] == 0xaaa00003u && L.c[0].a[1] == 0xc0de0001u && L.c[0].a[2] == 0x62723a && L.c[0].a[3] == 0x62725a &&
       L.c[0].a[4] == 0x54d6e8);
    CK(w.value_627230 == 0 && w.value_627234 == 0 && w.byte_62729b == 1);
    CK(is_call(1, 0x47e52f, 0x625ee8, 2) && L.c[1].a[0] == 0x62727a && L.c[1].a[1] > 0xffffffffu);
    CK(is_call(2, 0x4c5377, 0x5cf659, 5) && L.c[2].a[0] == 0xaaa00003u && L.c[2].a[1] == 0xc0de0001u && L.c[2].a[2] == 0x62727a && L.c[2].a[3] == L.c[1].a[1] &&
       L.c[2].a[4] == 0x54d720);
    CK(rect_word(L.c[2].pd[3], 0) == 0x11111111u && rect_word(L.c[2].pd[3], 1) == 0x22222222u && rect_word(L.c[2].pd[3], 2) == 0x33333333u &&
       rect_word(L.c[2].pd[3], 3) == 0x44444444u);
    CK(is_call(3, 0x4c5d4b, 0x5cf659, 5) && L.c[3].a[0] == get32(table, 0x90) && L.c[3].a[1] == 0xc0de0001u && L.c[3].a[2] == 0x625f0cu + 0x90 &&
       L.c[3].a[3] == CELL_VA(1) + 0x12 && L.c[3].a[4] == 0x54d750);
    q2 = rec_va + 3u * 0x53 + 0x99;
    CK(is_call(4, 0x47e99e, 0x625ee8, 1) && L.c[4].a[0] == q2);
    CK(is_call(5, 0x4c5d4b, 0x5cf659, 5) && L.c[5].a[0] == 0x5a5a0001u && L.c[5].a[1] == 0xc0de0001u && L.c[5].a[2] == q2 && L.c[5].a[3] == CELL_VA(2) + 0x12 &&
       L.c[5].a[4] == 0x54d774);
    q1 = rec_va + 2u * 0x53 + 0x99;
    CK(is_call(6, 0x47e99e, 0x625ee8, 1) && L.c[6].a[0] == q1);
    CK(is_call(7, 0x47e52f, 0x625ee8, 2) && L.c[7].a[0] == rec_va + 0x81 && L.c[7].a[1] > 0xffffffffu);
    CK(is_call(8, 0x4c5377, 0x5cf659, 5) && L.c[8].a[0] == 0x5a5a0003u && L.c[8].a[1] == 0xc0de0001u && L.c[8].a[2] == 0x62729d && L.c[8].a[3] == L.c[7].a[1] &&
       L.c[8].a[4] == 0x54d7e8);
    CK(rect_word(L.c[8].pd[3], 0) == 0x55555555u);
    /* B: flag 0x62722c: cell 1 (the selected one) is skipped, the scan ends after count - 1 = 2 draws; then the selected cell and the 0x62729b flag */
    memset(slots, 0x66, sizeof slots);
    set_cell(slots, 0, 0, 1, 1, 1);   /* i = 0: table idx = 0x60 + 0x18 = 0x78 */
    set_cell(slots, 1, 1, 2, 2, 0);   /* the selected cell: skipped by the scan, its word matches i = 1 */
    set_cell(slots, 2, 2, 0, 3, 0);   /* i = 2 */
    w.word_62728a = 3;
    w.word_627238 = 1;
    w.value_627230 = 0;
    w.value_62722c = 1;
    w.value_627234 = 0;
    w.byte_62729a = 0;
    w.byte_62729b = 1;
    w.byte_627299 = 1;
    reset_log();
    queue_return(0x47e99e, 1);
    m481cb9_draw_cells(&w, &h);
    q3 = rec_va + 3u * 0x53 + 0x99;
    CK(L.n == 7);
    CK(is_call(0, 0x4c5377, 0x5cf659, 5) && L.c[0].a[2] == 0x62723a && L.c[0].a[3] == 0x62725a && L.c[0].a[4] == 0x54d6e8);
    CK(is_call(1, 0x4c5d4b, 0x5cf659, 5) && L.c[1].a[0] == get32(table, 0x78) && L.c[1].a[2] == 0x625f0cu + 0x78 && L.c[1].a[3] == CELL_VA(0) + 0x12 &&
       L.c[1].a[4] == 0x54d750);
    CK(is_call(2, 0x47e99e, 0x625ee8, 1) && L.c[2].a[0] == q3);
    CK(is_call(3, 0x4c5d4b, 0x5cf659, 5) && L.c[3].a[0] == 0x5a5a0001u && L.c[3].a[2] == q3 && L.c[3].a[3] == CELL_VA(2) + 0x12 && L.c[3].a[4] == 0x54d774);
    /* step 4: the selected cell, byte 0x627299 set: rec + byte [cell+0x23] * 0x53 + 0xc9 */
    CK(is_call(4, 0x4c5d4b, 0x5cf659, 5) && L.c[4].a[0] == 0x5a5a0002u && L.c[4].a[1] == 0xc0de0001u && L.c[4].a[2] == rec_va + 2u * 0x53 + 0xc9 &&
       L.c[4].a[3] == CELL_VA(1) + 0x12 && L.c[4].a[4] == 0x54d798);
    CK(is_call(5, 0x47e52f, 0x625ee8, 2) && L.c[5].a[0] == rec_va + 0x81);
    CK(is_call(6, 0x4c5377, 0x5cf659, 5) && L.c[6].a[0] == 0xaaa00003u && L.c[6].a[1] == 0xc0de0001u && L.c[6].a[2] == rec_va + 0x81 && L.c[6].a[3] == L.c[5].a[1] &&
       L.c[6].a[4] == 0x54d808);
    CK(w.byte_62729b == 0 && w.value_62722c == 1);
    /* C: count 1 with flag 0x62722c: count - 1 = 0, no scan; byte 0x627299 clear: table entry of the selected cell 0 (idx = 2 * 0x60 + 1 * 0x18) */
    memset(slots, 0x66, sizeof slots);
    set_cell(slots, 0, 5, 1, 2, 1);
    w.word_62728a = 1;
    w.word_627238 = 0;
    w.byte_627299 = 0;
    w.byte_62729b = 0;
    reset_log();
    m481cb9_draw_cells(&w, &h);
    CK(L.n == 2);
    CK(is_call(1, 0x4c5d4b, 0x5cf659, 5) && L.c[1].a[0] == get32(table, 0xd8) && L.c[1].a[1] == 0xc0de0001u && L.c[1].a[2] == 0x625f0cu + 0xd8 &&
       L.c[1].a[3] == 0x62726a && L.c[1].a[4] == 0x54d7bc);
    /* D: the selected word is signed: -1 addresses the cell below cell 0 */
    set_cell(slots, -1, 9, 3, 1, 0);   /* idx = 0x60 + 3 * 0x18 = 0xa8 */
    w.word_627238 = -1;
    reset_log();
    m481cb9_draw_cells(&w, &h);
    CK(L.n == 2 && L.c[1].a[0] == get32(table, 0xa8) && L.c[1].a[2] == 0x625f0cu + 0xa8);
    /* E: nothing set: no call at all; 0x62729a wins over 0x62729b */
    w.value_62722c = 0;
    w.word_62728a = 0;
    w.byte_62729a = 0;
    w.byte_62729b = 0;
    reset_log();
    m481cb9_draw_cells(&w, &h);
    CK(L.n == 0);
    w.byte_62729a = 1;
    w.byte_62729b = 1;
    reset_log();
    m481cb9_draw_cells(&w, &h);
    CK(L.n == 2 && L.c[1].a[2] == 0x62729d && w.byte_62729b == 1);
    /* F: two cells with the same word and flag 0x62722c: count - 1 = 1, so the scan ends after the first of them (j == count); the selected cell 3 is out of the scan */
    memset(slots, 0x66, sizeof slots);
    set_cell(slots, 0, 0, 1, 1, 1);
    set_cell(slots, 1, 0, 2, 1, 1);
    set_cell(slots, 3, 7, 1, 2, 1);
    w.value_62722c = 1;
    w.word_62728a = 2;
    w.word_627238 = 3;
    w.byte_627299 = 0;
    w.byte_62729a = 0;
    w.byte_62729b = 0;
    reset_log();
    m481cb9_draw_cells(&w, &h);
    CK(L.n == 3 && is_call(1, 0x4c5d4b, 0x5cf659, 5) && L.c[1].a[3] == CELL_VA(0) + 0x12 && is_call(2, 0x4c5d4b, 0x5cf659, 5) && L.c[2].a[3] == 0x62726a);
    /* the same two cells without the flag: both are drawn in the same scan (count = 2) */
    w.value_62722c = 0;
    reset_log();
    m481cb9_draw_cells(&w, &h);
    CK(L.n == 2 && L.c[0].a[3] == CELL_VA(0) + 0x12 && L.c[1].a[3] == CELL_VA(1) + 0x12);
}
/* ---- 0x463b10 ---- */

#define GRID_VA(r, c) (0x594db5u + (uint32_t)(r) * 0x140u + (uint32_t)(c) * 0x28u)

static void set_grid(uint8_t *cells, int r, int c, uint32_t first, int16_t t, int16_t u)
{
    size_t base = (size_t)r * 0x140 + (size_t)c * 0x28;
    set32(cells, base, first);
    set16(cells, base + 0x24, (uint16_t)t);
    set16(cells, base + 0x26, (uint16_t)u);
}

static void test_m463b10_draw_grid(void)
{
    static uint8_t rec[0x300], cells[4 * 0x140 + 0x40], table[0x4a * 3];
    const uint32_t rec_va = 0x00f60000u;
    const uint32_t tbl = 0xaaa00001u;
    Fl20cWorld w;
    Fl18Host h = host();
    memset(&w, 0, sizeof w);
    memset(rec, 0x33, sizeof rec);
    memset(cells, 0, sizeof cells);
    memset(table, 0, sizeof table);
    set32(table, 0x4a, tbl);
    memset(g_records, 0, sizeof g_records);
    set32(g_records, 3 * REC, rec_va);
    set16(rec, 0x22, 2);   /* rows */
    set16(rec, 0x24, 3);   /* columns */
    w.records_5bb5e5 = g_records;
    w.cells_594db5 = cells;
    w.table_5d1599 = table;
    w.word_61d797 = 3;
    w.word_61d795 = 1;
    w.value_5cf665 = 0xc0de0001u;
    w.value_5d15e3 = 0xaaa00003u;
    w.origin_x_583186 = 7;
    w.origin_y_58318a = -9;
    w.value_61d7a2 = 1000;
    w.value_61d7a6 = 2000;
    w.value_61d7aa = 3000;
    w.value_61d7ae = 4000;
    /* pass 1: a skipped cell (dword 0 with a table type and a marker), the two A types, both B types, the C type and two markers */
    set_grid(cells, 0, 0, 0, 4, 1);
    set_grid(cells, 0, 1, 1, 0x10, 0);
    set_grid(cells, 0, 2, 1, 0x13, 2);
    set_grid(cells, 1, 0, 1, 0x11, 0);
    set_grid(cells, 1, 1, 1, 0x12, 3);
    set_grid(cells, 1, 2, 1, 0x14, 0);
    set32(rec, 0x230, 5);
    set32(rec, 0x238, 9);
    w.value_61d79d = 2;
    w.value_61d7b4 = 0;
    w.word_61d7b2 = 3;
    reset_log();
    add_region(rec_va, rec, sizeof rec);
    m463b10_draw_grid(&w, &h);
    CK(L.n == 8);
    CK(is_call(0, 0x4c5d4b, 0x5cf659, 5) && L.c[0].a[0] == tbl && L.c[0].a[1] == 0xc0de0001u && L.c[0].a[2] == rec_va + 0x210 && L.c[0].a[3] == GRID_VA(0, 1) + 4 &&
       L.c[0].a[4] == 0x54b210);
    CK(is_call(1, 0x4c5d4b, 0x5cf659, 5) && L.c[1].a[0] == tbl && L.c[1].a[2] == rec_va + 0x210 && L.c[1].a[3] == GRID_VA(0, 2) + 4 && L.c[1].a[4] == 0x54b210);
    CK(is_call(2, 0x4c5d4b, 0x5cf659, 5) && L.c[2].a[0] == tbl && L.c[2].a[1] == 0xc0de0001u && L.c[2].a[2] == rec_va + 0xe0 && L.c[2].a[3] == GRID_VA(0, 2) + 0x14 &&
       L.c[2].a[4] == 0x54b298);
    CK(is_call(3, 0x4c5d4b, 0x5cf659, 5) && L.c[3].a[2] == rec_va + 0x220 && L.c[3].a[3] == GRID_VA(1, 0) + 4 && L.c[3].a[4] == 0x54b22c);
    CK(is_call(4, 0x4c5d4b, 0x5cf659, 5) && L.c[4].a[2] == rec_va + 0x220 && L.c[4].a[3] == GRID_VA(1, 1) + 4 && L.c[4].a[4] == 0x54b22c);
    CK(is_call(5, 0x4c5377, 0x5cf659, 5) && L.c[5].a[0] == 0xaaa00003u && L.c[5].a[1] == 0xc0de0001u && L.c[5].a[3] == 0x61d7a2 && L.c[5].a[4] == 0x54b284);
    CK(rect_word(L.c[5].pd[2], 0) == 993 && rect_word(L.c[5].pd[2], 1) == 2009 && rect_word(L.c[5].pd[2], 2) == 2993 && rect_word(L.c[5].pd[2], 3) == 4009);
    CK(is_call(6, 0x4c5d4b, 0x5cf659, 5) && L.c[6].a[0] == tbl && L.c[6].a[2] == rec_va + 0xf0 && L.c[6].a[3] == GRID_VA(1, 1) + 0x14 && L.c[6].a[4] == 0x54b298);
    CK(is_call(7, 0x4c5d4b, 0x5cf659, 5) && L.c[7].a[2] == rec_va + 0x230 && L.c[7].a[3] == GRID_VA(1, 2) + 4 && L.c[7].a[4] == 0x54b248);
    /* pass 2: the D type (t = 4: entry 3, t = 10: entry 9), no draw for equal dwords, the types that do nothing, a negative marker with the flag 0x61d7b4 */
    set_grid(cells, 0, 0, 1, 4, 0);
    set_grid(cells, 0, 1, 1, 11, -1);
    set_grid(cells, 0, 2, 1, 0x0f, 0);
    set_grid(cells, 1, 0, 1, 1, 0);
    set_grid(cells, 1, 1, 1, 10, 0);
    set_grid(cells, 1, 2, 1, 0x15, 0);
    set32(rec, 0x170 + 3 * 16, 100);
    set32(rec, 0x178 + 3 * 16, 101);
    set32(rec, 0x170 + 0, 77);
    set32(rec, 0x178 + 0, 77);
    set32(rec, 0x170 + 9 * 16, 0xfffffff0u);
    set32(rec, 0x178 + 9 * 16, 3);
    set32(rec, 0x238, 5);   /* equal to 0x230: nothing for type 0x14 */
    w.value_61d79d = 0;
    w.value_61d7b4 = 1;
    w.word_61d7b2 = -1;
    reset_log();
    add_region(rec_va, rec, sizeof rec);
    m463b10_draw_grid(&w, &h);
    CK(L.n == 4);
    CK(is_call(0, 0x4c5d4b, 0x5cf659, 5) && L.c[0].a[0] == tbl && L.c[0].a[2] == rec_va + 0x170 + 0x30 && L.c[0].a[3] == GRID_VA(0, 0) + 4 && L.c[0].a[4] == 0x54b264);
    CK(is_call(1, 0x4c5377, 0x5cf659, 5) && L.c[1].a[3] == 0x61d7a2 && rect_word(L.c[1].pd[2], 0) == 993 && rect_word(L.c[1].pd[2], 3) == 4009);
    CK(is_call(2, 0x4c5d4b, 0x5cf659, 5) && L.c[2].a[2] == rec_va + 0xb0 && L.c[2].a[3] == GRID_VA(0, 1) + 0x14 && L.c[2].a[4] == 0x54b298);
    CK(is_call(3, 0x4c5d4b, 0x5cf659, 5) && L.c[3].a[2] == rec_va + 0x170 + 0x90 && L.c[3].a[3] == GRID_VA(1, 1) + 4 && L.c[3].a[4] == 0x54b264);
    /* pass 3: neither flag: the marker of cell (0, 1) is drawn without the rectangle; the types t = 0 and t = -1 are not in the table */
    set_grid(cells, 0, 0, 1, 0, 0);
    set_grid(cells, 1, 1, 1, -1, 0);
    w.value_61d79d = 1;
    w.value_61d7b4 = 0;
    reset_log();
    add_region(rec_va, rec, sizeof rec);
    m463b10_draw_grid(&w, &h);
    CK(L.n == 1 && is_call(0, 0x4c5d4b, 0x5cf659, 5) && L.c[0].a[2] == rec_va + 0xb0);
    /* pass 4: an empty grid (zero rows) and a grid of one column */
    set16(rec, 0x22, 0);
    reset_log();
    add_region(rec_va, rec, sizeof rec);
    m463b10_draw_grid(&w, &h);
    CK(L.n == 0);
    set16(rec, 0x22, 2);
    set16(rec, 0x24, 1);
    set_grid(cells, 0, 0, 1, 0, -1);
    reset_log();
    add_region(rec_va, rec, sizeof rec);
    m463b10_draw_grid(&w, &h);
    CK(L.n == 1 && is_call(0, 0x4c5d4b, 0x5cf659, 5) && L.c[0].a[2] == rec_va + 0xb0 && L.c[0].a[3] == GRID_VA(0, 0) + 0x14);
}
/* ---- 0x412db8 ---- */

static uint8_t wr_self[0x3000], wr_text[40100], wr_args[0x20], wr_fonts[0x1d0 * 5], wr_dwords[32];

/* one call of the port; text is copied to a zeroed 40100-byte buffer (the last 100 bytes are 0xee and must survive the clearing of 40000) */
static void wrap_run(Fl20cWorld *w, const char *text, int16_t font, uint32_t flag, int16_t x, int16_t limit_e, int16_t limit_f, int16_t y, int16_t arg9,
                     uint32_t arg10)
{
    Fl18Host h = host();
    memset(wr_text, 0, 40000);
    memset(wr_text + 40000, 0xee, 100);
    strcpy((char *)wr_text, text);
    set32(wr_args, 0, flag);
    set16(wr_args, 8, (uint16_t)x);
    set16(wr_args, 0x10, (uint16_t)y);
    m412db8_wrap_text(wr_self, wr_text, font, wr_args, wr_args + 8, limit_e, limit_f, wr_args + 0x10, 0x1234, arg9, arg10, w, &h);
}

static int text_cleared(void)
{
    size_t i;
    for (i = 0; i < 40000; i++)
        if (wr_text[i] != 0) return 0;
    for (i = 40000; i < 40100; i++)
        if (wr_text[i] != 0xee) return 0;
    return 1;
}

static void test_m412db8_wrap_text(void)
{
    Fl20cWorld w;
    int i, k;
    memset(&w, 0, sizeof w);
    memset(wr_fonts, 0, sizeof wr_fonts);
    memset(wr_dwords, 0, sizeof wr_dwords);
    memset(wr_self, 0x55, sizeof wr_self);
    w.records_5adb3a = wr_fonts + 0x1d0;     /* one record of slack below font 0 */
    w.dwords_5d032f = wr_dwords + 8;
    w.word_63a4cd = 0;
    set16(wr_fonts, 0x1d0 + 1 * 0x1d0 + 2, 10);      /* font 1: w = 10 */
    set16(wr_fonts, 0x1d0 + 2, 33);                  /* font 0 */
    set16(wr_fonts, 0 * 0x1d0 + 2, 0x4321);          /* font -1 */
    set32(wr_dwords, 8 + 4, 0xd0d0d001u);            /* [1] */
    set32(wr_dwords, 8 - 4, 0xd0d0ffffu);            /* [-1] */
    set16(wr_self, 0x292e, 0);
    set32(wr_self, 0x2938, 0xabcd1234u);
    set16(wr_self, 0x293c, 0x3456);
    set32(wr_self, 0x293e, 0);
    set32(wr_self, 0x2942, 0);
    /* 1. one line, flag set: x += w + w / 9 = 11; buf = "ab cd" is drawn with the arguments in the order of the stack; y += the width after the draw */
    reset_log();
    for (k = 0; k < 6; k++) queue_return(0x4d3836, (uint32_t)k);
    queue_return(0x4d3836, 7);
    wrap_run(&w, "ab cd", 1, 1, 100, 1000, 100, 5, -2, 0x77665544u);
    CK(L.n == 8);
    for (k = 0; k < 6; k++) CK(is_call(k, 0x4d3836, 0, 3) && L.c[k].a[1] == 0x5a4c24u + 0x7f3 && L.c[k].a[2] == 0x5adb3au + 0x1d0);
    CK(L.c[0].pd[0][0] == 0 && L.c[1].pd[0][0] == 'a' && L.c[1].pd[0][1] == 0 && memcmp(L.c[5].pd[0], "ab cd", 6) == 0);
    CK(is_call(6, 0x4d270b, 0, 10) && memcmp(L.c[6].pd[0], "ab cd", 6) == 0 && L.c[6].a[1] == 0x5a4c24u + 0x7f3 && L.c[6].a[2] == 0x5adb3au + 0x1d0 &&
       (L.c[6].a[3] & 0xffff) == 5 && L.c[6].a[4] == 111 && L.c[6].a[5] == 0xd0d0d001u && L.c[6].a[6] == 0x77665544u && L.c[6].a[7] == 0xfffe &&
       L.c[6].a[8] == 0xabcd1234u && L.c[6].a[9] == 0x3456);
    CK(is_call(7, 0x4d3836, 0, 3) && memcmp(L.c[7].pd[0], "ab cd", 6) == 0);
    CK(get32(wr_args, 0) == 0);
    CK((int16_t)get16(wr_args, 8) == 111);
    CK((int16_t)get16(wr_args, 0x10) == 12);
    CK(text_cleared());
    /* 2. a line break at a space: the first line "aaa bbb " (limit_f 10), y := [self+0x292e] and flag := 1, then x += 11 and "ccc" */
    set16(wr_self, 0x292e, 0);
    reset_log();
    for (k = 0; k <= 10; k++) queue_return(0x4d3836, (uint32_t)k);
    queue_return(0x4d3836, 77);
    for (k = 0; k < 4; k++) queue_return(0x4d3836, (uint32_t)k);
    queue_return(0x4d3836, 5);
    wrap_run(&w, "aaa bbb ccc", 1, 0, 20, 1000, 10, 0, 1, 2);
    CK(L.n == 19);
    CK(is_call(11, 0x4d270b, 0, 10) && memcmp(L.c[11].pd[0], "aaa bbb ", 9) == 0 && (L.c[11].a[3] & 0xffff) == 0 && L.c[11].a[4] == 20);
    CK(is_call(12, 0x4d3836, 0, 3) && memcmp(L.c[12].pd[0], "aaa bbb ", 9) == 0);
    CK(is_call(17, 0x4d270b, 0, 10) && memcmp(L.c[17].pd[0], "ccc", 4) == 0 && (L.c[17].a[3] & 0xffff) == 0 && L.c[17].a[4] == 31);
    CK(get32(wr_args, 0) == 0 && (int16_t)get16(wr_args, 8) == 31 && (int16_t)get16(wr_args, 0x10) == 5 && text_cleared());
    /* 3. a word without a space is not broken: the line is empty, nothing is drawn, y := 100 and flag := 1 every time, x grows by 11 until it reaches limit_e
     * (33 >= 30): then (word 0x63a4cd non-zero) 0x50ca3e and 0x4264e8 are called and the flag stays set */
    set16(wr_self, 0x292e, 100);
    w.word_63a4cd = 1;
    reset_log();
    for (k = 0; k < 6; k++) queue_return(0x4d3836, (uint32_t)k);
    queue_return(0x4d3836, 9);
    queue_return(0x4d3836, 9);
    wrap_run(&w, "abcdefghijkl", 1, 0, 0, 30, 5, 0, 0, 0);
    CK(L.n == 10);
    for (k = 0; k < 8; k++) CK(is_call(k, 0x4d3836, 0, 3) && L.c[k].a[1] == 0x5a4c24u + 0x7f3 && L.c[k].a[2] == 0x5adb3au + 0x1d0);
    CK(is_call(8, 0x50ca3e, 0, 2) && L.c[8].a[0] == 0x63888b && L.c[8].a[1] == 0x54167c);
    CK(is_call(9, 0x4264e8, 0x583979, 1) && L.c[9].a[0] == 0x63888b);
    CK(get32(wr_args, 0) == 1 && (int16_t)get16(wr_args, 8) == 33 && (int16_t)get16(wr_args, 0x10) == 100 && text_cleared());
    /* the same with the word 0x63a4cd clear: the calls are not made */
    w.word_63a4cd = 0;
    reset_log();
    for (k = 0; k < 6; k++) queue_return(0x4d3836, (uint32_t)k);
    queue_return(0x4d3836, 9);
    queue_return(0x4d3836, 9);
    wrap_run(&w, "abcdefghijkl", 1, 0, 0, 30, 5, 0, 0, 0);
    CK(L.n == 8 && get32(wr_args, 0) == 1);
    /* 4. the three updates of x (text empty: nothing but the block at the top): [self+0x293e] adds w; [self+0x2942] adds (w + w / 9) / 2 rounded toward zero and
     * is cleared; otherwise w + w / 9. limit_e is compared as signed words, x + delta == limit_e leaves (the flag stays), one below does not */
    {
        static const struct {
            int16_t w;
            uint32_t f293e, f2942;
            int16_t x, limit, expect;
            int exits;
        } t[] = {
            {10, 1, 0, 100, 1000, 110, 0},     {10, 0, 0, 100, 1000, 111, 0},   {10, 0, 3, 100, 1000, 105, 0},     {-5, 0, 3, 100, 1000, 98, 0},
            {-5, 0, 0, 100, 1000, 95, 0},      {-20, 0, 0, 100, 1000, 78, 0},   {-5, 1, 0, 100, 1000, 95, 0},      {-19, 0, 5, 100, 1000, 90, 0},
            {18, 0, 7, 100, 1000, 110, 0},     {7, 0, 0, 100, 107, 107, 1},     {7, 0, 0, 100, 108, 107, 0},       {7, 0, 0, 100, 106, 107, 1},
            {7, 0, 0, -50, -43, -43, 1},       {7, 0, 0, -50, -42, -43, 0},     {7, 0, 0, 32765, -32768, (int16_t)(32765 + 7), 1},
        };
        for (i = 0; i < (int)(sizeof t / sizeof t[0]); i++) {
            set16(wr_fonts, 0x1d0 + 1 * 0x1d0 + 2, (uint16_t)t[i].w);
            set32(wr_self, 0x293e, t[i].f293e);
            set32(wr_self, 0x2942, t[i].f2942);
            reset_log();
            wrap_run(&w, "", 1, 1, t[i].x, t[i].limit, 50, 0, 0, 0);
            CK(L.n == 0);
            CK((int16_t)get16(wr_args, 8) == t[i].expect);
            CK(get32(wr_args, 0) == (t[i].exits ? 1u : 0u));
            CK(get32(wr_self, 0x2942) == (t[i].f293e ? t[i].f2942 : 0));
            CK(text_cleared());
            if (g_failed) {
                char old[256];
                memcpy(old, g_msg, sizeof old);
                snprintf(g_msg, sizeof g_msg, "x-update row %d: %.200s", i, old);
                return;
            }
        }
        /* a clear flag does nothing at all (x unchanged, [self+0x2942] kept) */
        set32(wr_self, 0x293e, 0);
        set32(wr_self, 0x2942, 9);
        reset_log();
        wrap_run(&w, "", 1, 0, 100, 0, 50, 0, 0, 0);
        CK(L.n == 0 && (int16_t)get16(wr_args, 8) == 100 && get32(wr_self, 0x2942) == 9 && text_cleared());
    }
    /* 5. a negative font: the sign extension of the word shows in the upper half of x_arg; records / tables are addressed below font 0 */
    set32(wr_self, 0x2942, 0);
    set16(wr_self, 0x292e, 0);
    reset_log();
    queue_return(0x4d3836, 0);
    queue_return(0x4d3836, 0);
    queue_return(0x4d3836, 0x10004);
    wrap_run(&w, "a", -1, 0, 7, 0, 50, 3, 5, 6);
    CK(L.n == 4 && is_call(2, 0x4d270b, 0, 10) && L.c[2].a[1] == 0x5a4c24u - 0x7f3 && L.c[2].a[2] == 0x5adb3au - 0x1d0 && (L.c[2].a[3] & 0xffff) == 3 &&
       L.c[2].a[4] == 0xffff0007u && L.c[2].a[5] == 0xd0d0ffffu && L.c[2].a[6] == 6 && L.c[2].a[7] == 5);
    CK((int16_t)get16(wr_args, 0x10) == 7 && text_cleared());   /* y += (signed word) 4 of the result 0x10004 */
    /* the break is the last space: "ab cd" with limit_f 4 and widths 0, 1, 2, 3, 4 copies "ab c" (the 5th call: 4 >= 4), falls back to "ab " and draws it;
     * y := [self+0x292e] = 0 and the flag is set; the next turn adds w + w / 9 = 36 (font 0: 33) to x, which reaches limit_e = 10: the end */
    reset_log();
    for (k = 0; k < 6; k++) queue_return(0x4d3836, (uint32_t)k);
    queue_return(0x4d3836, 1);
    queue_return(0x4d3836, 1);
    queue_return(0x4d3836, 1);
    queue_return(0x4d3836, 1);
    wrap_run(&w, "ab cd", 0, 0, 0, 10, 4, 0, 0, 0);
    CK(is_call(5, 0x4d270b, 0, 10) && memcmp(L.c[5].pd[0], "ab ", 4) == 0);
    CK(L.n == 7 && get32(wr_args, 0) == 1 && (int16_t)get16(wr_args, 8) == 36 && (int16_t)get16(wr_args, 0x10) == 0 && text_cleared());
}

/* TESTS-END */

int main(void)
{
    int failures = 0;
    RUN(test_m4b9a88_draw_slots);
    RUN(test_m4619be_check_direction);
    RUN(test_m481cb9_draw_cells);
    RUN(test_m463b10_draw_grid);
    RUN(test_m412db8_wrap_text);
    /* RUN-END */
    return failures;
}
