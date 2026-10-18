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

/* TESTS-END */

int main(void)
{
    int failures = 0;
    RUN(test_m4b9a88_draw_slots);
    RUN(test_m4619be_check_direction);
    /* RUN-END */
    return failures;
}
