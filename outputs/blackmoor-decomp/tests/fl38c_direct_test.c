/* FL-38 (batch c) direct tests of the 24 GAME.EXE functions in src/original_methods_fl38c.c. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the failure count. Fixtures are
 * synthetic (no original bytes). Expected values were derived by hand from the disassembly of GAME.EXE (the offsets, globals, callees and strings of each row, and the arithmetic), not from
 * running the native code; tests/test_fl38c_differential.py additionally runs the original bytes on generated fixtures. */
#include "../src/original_methods_fl38c.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define UNUSED_FN __attribute__((unused))

static int g_failed;
static char g_msg[256];
#define CK(cond)                                                               \
    do {                                                                       \
        if (!(cond) && !g_failed) {                                            \
            g_failed = 1;                                                      \
            snprintf(g_msg, sizeof g_msg, "line %d: %.200s", __LINE__, #cond); \
        }                                                                      \
    } while (0)

/* the recording host: every call is logged (callee, this, arguments); 0x51d5b2 writes TEXT through its first argument, 0x50cb1b returns g_conv (and logs the string it was given),
 * 0x51dc43 returns g_new, everything else returns g_tail */
#define MAXCALL 8
static struct {
    int n;
    struct {
        uint32_t callee;
        uintptr_t this_ptr;
        int nargs;
        uintptr_t a[4];
        uint8_t seen[0x13];
        Fl38cWorld world;        /* the world at the call */
        uint8_t table[0x20];     /* the first bytes of the table pointed to by the world at the call (read_time_setting) */
    } c[MAXCALL];
} L;
static uint32_t g_conv, g_new, g_tail;
static int g_probe_at, g_probe_on;          /* where, in the table of the world, the snapshot at each call starts */
static Fl38cWorld g_world;
static const uint8_t TEXT[0x13] = {'1', '2', ':', '3', '4', ':', '5', '6', 0, 0xff, 'x', 7, 8, 9, 10, 11, 12, 13, 14};

#define CELL_VA 0x20000000u
#define BLK_VA 0x21000000u
static uint8_t *g_cells, *g_blk;
static uint32_t g_cells_len, g_blk_len;

static uint32_t host_call(void *ctx, uint32_t callee, uintptr_t this_ptr, const uintptr_t *args, int nargs)
{
    int k, i = L.n;
    (void)ctx;
    if (L.n < MAXCALL) {
        L.c[i].callee = callee;
        L.c[i].this_ptr = this_ptr;
        L.c[i].nargs = nargs;
        for (k = 0; k < nargs && k < 4; k++) L.c[i].a[k] = args[k];
        L.c[i].world = g_world;
        if (g_probe_on) memcpy(L.c[i].table, g_world.table_5e569e + g_probe_at, sizeof L.c[i].table);
    }
    L.n++;
    if (callee == 0x51d5b2 && nargs == 2) {
        memcpy((void *)args[0], TEXT, sizeof TEXT);
        return 0x77;
    }
    if (callee == 0x50cb1b && nargs == 1) {
        if (i < MAXCALL) memcpy(L.c[i].seen, (const void *)args[0], sizeof TEXT);
        return g_conv;
    }
    return callee == 0x51dc43 ? g_new : g_tail;
}

static const uint8_t *host_resolve(void *ctx, uint32_t a)
{
    (void)ctx;
    if (a >= CELL_VA && a < CELL_VA + g_cells_len) return g_cells + (a - CELL_VA);
    if (a >= BLK_VA && a < BLK_VA + g_blk_len) return g_blk + (a - BLK_VA);
    return NULL;
}

static Fl18Host g_host;

static void reset(void)
{
    memset(&g_host, 0, sizeof g_host);
    g_host.call = host_call;
    g_host.resolve = host_resolve;
    memset(&g_world, 0, sizeof g_world);
    memset(&L, 0, sizeof L);
    g_conv = g_new = g_tail = 0;
    g_probe_at = 0;
    g_probe_on = 0;
    g_cells = g_blk = NULL;
    g_cells_len = g_blk_len = 0;
}

UNUSED_FN static void put32(uint8_t *p, size_t off, uint32_t v)
{
    p[off] = (uint8_t)v;
    p[off + 1] = (uint8_t)(v >> 8);
    p[off + 2] = (uint8_t)(v >> 16);
    p[off + 3] = (uint8_t)(v >> 24);
}

UNUSED_FN static uint32_t get32(const uint8_t *p, size_t off)
{
    return (uint32_t)p[off] | (uint32_t)p[off + 1] << 8 | (uint32_t)p[off + 2] << 16 | (uint32_t)p[off + 3] << 24;
}

/* ---- read_word_setting ---- */
typedef uint32_t (*ReadFn)(uint8_t *, Fl38cWorld *, const Fl18Host *);

static void check_read_word_once(ReadFn fn, uint32_t off, size_t word_off, uint32_t callee, uint32_t conv, uint16_t want)
{
    static uint8_t self[0xa00];
    Fl38cWorld before;
    uint16_t got;
    size_t i;
    reset();
    for (i = 0; i < sizeof self; i++) self[i] = (uint8_t)(i * 3 + 1);
    memset(&g_world, 0x5a, sizeof g_world);          /* every other global keeps this value */
    before = g_world;
    g_conv = conv;
    g_tail = 0xcafe0001u;
    CK(fn(self, &g_world, &g_host) == 0xcafe0001u);
    CK(L.n == 3);
    CK(L.c[0].callee == 0x51d5b2 && L.c[0].this_ptr == (uintptr_t)(self + off) && L.c[0].nargs == 2 && L.c[0].a[1] == 0x13 && L.c[0].a[0] > 0xffffffffu);
    CK(L.c[1].callee == 0x50cb1b && L.c[1].this_ptr == 0 && L.c[1].nargs == 1 && L.c[1].a[0] == L.c[0].a[0]);
    CK(memcmp(L.c[1].seen, TEXT, sizeof TEXT) == 0);                    /* the string that 0x51d5b2 wrote is what 0x50cb1b converts */
    CK(L.c[2].callee == callee && L.c[2].this_ptr == (uintptr_t)self && L.c[2].nargs == 0);
    memcpy(&got, (const uint8_t *)&L.c[2].world + word_off, 2);
    CK(got == want);                                                    /* the word is stored before the last method runs */
    CK(L.c[0].world.dword_5c3a63 == 0x5a5a5a5au);
    memcpy(&got, (const uint8_t *)&g_world + word_off, 2);
    CK(got == want);
    memcpy((uint8_t *)&before + word_off, &want, 2);
    CK(memcmp(&before, &g_world, sizeof g_world) == 0);                 /* no other global is touched */
    for (i = 0; i < sizeof self; i++) CK(self[i] == (uint8_t)(i * 3 + 1));
}

static void check_read_word(ReadFn fn, uint32_t off, size_t word_off, uint32_t callee)
{
    check_read_word_once(fn, off, word_off, callee, 0x1234beefu, 0xbeef);       /* only the low word is stored */
    check_read_word_once(fn, off, word_off, callee, 0xffffu, 0xffff);
    check_read_word_once(fn, off, word_off, callee, 0x10000u, 0);
    check_read_word_once(fn, off, word_off, callee, 0xfffffff0u, 0xfff0);
    check_read_word_once(fn, off, word_off, callee, 0, 0);
}

/* ---- read_time_setting ---- */
#define TAB 0x1000
static void check_read_time_once(ReadFn fn, uint32_t off, uint32_t base, uint32_t store, uint32_t idx, uint32_t conv)
{
    static uint8_t self[0xa00], mem[TAB + 0x400], ref[TAB + 0x400];
    const uint32_t e = TAB / 2 + (uint32_t)(int32_t)(idx * 0x106u);        /* offset of entry idx in mem (the table starts at TAB / 2) */
    uint64_t h, m, s;
    size_t i;
    reset();
    for (i = 0; i < sizeof self; i++) self[i] = (uint8_t)(i * 5 + 2);
    for (i = 0; i < sizeof mem; i++) mem[i] = (uint8_t)(i * 7 + 3);
    put32(mem, e + base + 4, 61);
    put32(mem, e + base + 8, 0x10002);
    put32(mem, e + base + 0xc, 0xffffff00u);
    memcpy(ref, mem, sizeof mem);
    g_world.table_5e569e = mem + TAB / 2;
    g_world.dword_5c3a63 = idx;
    g_probe_at = (int)(e - TAB / 2) + (int)base;
    g_probe_on = 1;
    g_conv = conv;
    g_tail = 0xabcd0002u;
    CK(fn(self, &g_world, &g_host) == 0xabcd0002u);
    /* the model: field[store] = conv; field[0] = field[0xc] * 3600000 + field[8] * 60000 + field[4] * 1000 (mod 2^32), read after the first store */
    put32(ref, e + base + store, conv);
    h = (uint64_t)get32(ref, e + base + 0xc) * 3600000u;
    m = (uint64_t)get32(ref, e + base + 8) * 60000u;
    s = (uint64_t)get32(ref, e + base + 4) * 1000u;
    put32(ref, e + base, (uint32_t)(h + m + s));
    CK(memcmp(mem, ref, sizeof mem) == 0);
    CK(L.n == 3);
    CK(L.c[0].callee == 0x51d5b2 && L.c[0].this_ptr == (uintptr_t)(self + off) && L.c[0].nargs == 2 && L.c[0].a[1] == 0x13);
    CK(L.c[1].callee == 0x50cb1b && L.c[1].this_ptr == 0 && L.c[1].nargs == 1 && L.c[1].a[0] == L.c[0].a[0] && memcmp(L.c[1].seen, TEXT, sizeof TEXT) == 0);
    CK(L.c[2].callee == 0x4033db && L.c[2].this_ptr == (uintptr_t)self && L.c[2].nargs == 0);
    CK(memcmp(L.c[2].table, ref + TAB / 2 + g_probe_at, sizeof L.c[2].table) == 0);          /* the table is complete (the sum stored) before the last method runs */
    for (i = 0; i < sizeof self; i++) CK(self[i] == (uint8_t)(i * 5 + 2));
}

static void check_read_time(ReadFn fn, uint32_t off, uint32_t base, uint32_t store)
{
    check_read_time_once(fn, off, base, store, 0, 7);
    check_read_time_once(fn, off, base, store, 2, 0x12345678u);
    check_read_time_once(fn, off, base, store, 0xffffffffu, 0xfffffff0u);       /* entry -1 */
    check_read_time_once(fn, off, base, store, 1, 2);
    check_read_time_once(fn, off, base, store, 3, 0x80000000u);
}

/* ---- shift_rect ---- */
typedef void (*ShiftFn)(const uint8_t *, uint8_t *, const Fl38cWorld *);

static void check_shift_once(ShiftFn fn, int src_at, int dst_at, int32_t gy, int32_t gx)
{
    static uint8_t mem[0x100], ref[0x100];
    size_t i;
    reset();
    for (i = 0; i < sizeof mem; i++) mem[i] = (uint8_t)(i * 11 + 5);
    g_world.dword_58318a = gy;
    g_world.dword_583186 = gx;
    memcpy(ref, mem, sizeof mem);
    /* the model: four stores in this order, each field of the source read just before its store (so an overlapping destination changes later reads) */
    put32(ref, dst_at + 4, get32(ref, src_at + 4) + (uint32_t)gy);
    put32(ref, dst_at + 0xc, get32(ref, src_at + 0xc) + (uint32_t)gy);
    put32(ref, dst_at + 0, get32(ref, src_at + 0) + (uint32_t)gx);
    put32(ref, dst_at + 8, get32(ref, src_at + 8) + (uint32_t)gx);
    fn(mem + src_at, mem + dst_at, &g_world);
    CK(memcmp(mem, ref, sizeof mem) == 0);
    CK(L.n == 0);
}

static void check_shift_rect(ShiftFn fn)
{
    check_shift_once(fn, 0x20, 0x50, 5, 7);
    check_shift_once(fn, 0x20, 0x50, -5, -7);
    check_shift_once(fn, 0x20, 0x50, 0x7fffffff, 0x7fffffff);           /* 32-bit wrap */
    check_shift_once(fn, 0x20, 0x50, (int32_t)0x80000000u, 1);
    check_shift_once(fn, 0x20, 0x20, 100, 1000);                        /* the same rectangle */
    check_shift_once(fn, 0x20, 0x24, 3, 5);                             /* the destination overlaps the source, shifted by 4, 8, 12, 1 and backwards */
    check_shift_once(fn, 0x20, 0x28, 3, 5);
    check_shift_once(fn, 0x20, 0x2c, 3, 5);
    check_shift_once(fn, 0x20, 0x21, 3, 5);
    check_shift_once(fn, 0x24, 0x20, 3, 5);
    check_shift_once(fn, 0x28, 0x20, 3, 5);
    check_shift_once(fn, 0x2c, 0x20, 3, 5);
}

/* ---- new_zeroed ---- */
typedef void (*NewFn)(uint32_t, uint32_t, const Fl38cWorld *, const Fl18Host *);
#define BLK 0x100

static void check_new_once(NewFn fn, uint32_t fmt, uint32_t size, uint32_t p_off, int null, int16_t dbg)
{
    static uint8_t cells[0x40], blk[BLK];
    uint32_t i;
    reset();
    g_cells = cells; g_cells_len = sizeof cells; g_blk = blk; g_blk_len = sizeof blk;
    memset(cells, 0x3c, sizeof cells);
    for (i = 0; i < BLK; i++) blk[i] = 0xa5;
    g_world.word_63a4cd = dbg;
    g_new = null ? 0 : BLK_VA + p_off;
    g_tail = 0x1111;
    fn(CELL_VA + 8, size, &g_world, &g_host);
    CK(L.c[0].callee == 0x51dc43 && L.c[0].this_ptr == 0 && L.c[0].nargs == 1 && L.c[0].a[0] == size);
    CK(get32(cells, 8) == g_new);
    for (i = 0; i < sizeof cells; i++) CK(i >= 8 && i < 12 ? 1 : cells[i] == 0x3c);
    if (!null) {
        CK(L.n == 1);
        for (i = 0; i < BLK; i++) CK(blk[i] == ((i >= p_off && i < p_off + size) ? 0 : 0xa5));          /* exactly `size` bytes become zero */
    } else {
        int k = 1;
        for (i = 0; i < BLK; i++) CK(blk[i] == 0xa5);
        CK(L.n == (dbg != 0 ? 5 : 4));
        CK(L.c[k].callee == 0x50ca3e && L.c[k].this_ptr == 0 && L.c[k].nargs == 2 && L.c[k].a[0] == 0x63888b && L.c[k].a[1] == fmt);
        k++;
        CK(L.c[k].callee == 0x4264e8 && L.c[k].this_ptr == 0x583979 && L.c[k].nargs == 1 && L.c[k].a[0] == 0x63888b);
        k++;
        if (dbg != 0) {
            CK(L.c[k].callee == 0x44a2b7 && L.c[k].this_ptr == 0 && L.c[k].nargs == 1 && L.c[k].a[0] == 0x63888b);
            k++;
        }
        CK(L.c[k].callee == 0x4c97b4 && L.c[k].this_ptr == 0x5cf659 && L.c[k].nargs == 0);
    }
}

static void check_new_zeroed(NewFn fn, uint32_t fmt)
{
    static const int16_t dbgs[] = {0, 1, 0x100, -32768, -1};
    static const uint32_t sizes[] = {0, 1, 2, 3, 4, 5, 7, 8, 13, 33};
    size_t i, j;
    for (i = 0; i < sizeof sizes / sizeof sizes[0]; i++) check_new_once(fn, fmt, sizes[i], 1 + (uint32_t)i % 4, 0, 0);
    for (j = 0; j < sizeof dbgs / sizeof dbgs[0]; j++) {
        check_new_once(fn, fmt, 9, 3, 1, dbgs[j]);                      /* the failed allocation: the debug word decides the extra message; nothing is cleared */
        check_new_once(fn, fmt, 9, 3, 0, dbgs[j]);                      /* the debug word is not looked at when the allocation worked */
    }
    /* the cell lives inside the block that is zeroed: the zeroing wipes the pointer that was just stored */
    reset();
    {
        static uint8_t blk[BLK];
        memset(blk, 0xa5, sizeof blk);
        g_blk = blk; g_blk_len = sizeof blk;
        g_new = BLK_VA + 0x10;
        fn(BLK_VA + 0x14, 0x20, &g_world, &g_host);
        for (j = 0; j < BLK; j++) CK(blk[j] == ((j >= 0x10 && j < 0x30) ? 0 : 0xa5));
    }
}

/* ---- clamp_to_bounds ---- */
typedef void (*ClampFn)(uint8_t *, Fl38cWorld *);

static void ref_axis(uint8_t *mem, uint32_t lo_f, uint32_t hi_f, uint32_t w_f, int32_t lo, int32_t hi)
{
    const int16_t w = (int16_t)(mem[w_f] | mem[w_f + 1] << 8);
    if ((int32_t)get32(mem, lo_f) < lo) {
        put32(mem, lo_f, (uint32_t)lo);
        put32(mem, hi_f, (uint32_t)lo + (uint32_t)(int32_t)w);
    }
    if ((int32_t)get32(mem, hi_f) > hi) {
        put32(mem, hi_f, (uint32_t)hi);
        put32(mem, lo_f, (uint32_t)hi - (uint32_t)(int32_t)w);
    }
}

typedef struct ClampRow {
    ClampFn fn;
    uint32_t a, b, w1, c, d, w2;
} ClampRow;

static void check_clamp_once(const ClampRow *r, int32_t xlo, int32_t xhi, int32_t ylo, int32_t yhi, int32_t a0, int32_t b0, int16_t w1, int32_t c0, int32_t d0, int16_t w2, size_t size)
{
    uint8_t *mem = malloc(size), *ref = malloc(size);
    size_t i;
    CK(mem != NULL && ref != NULL);
    if (mem == NULL || ref == NULL) { free(mem); free(ref); return; }
    reset();
    for (i = 0; i < size; i++) mem[i] = (uint8_t)(i * 13 + 9);
    put32(mem, r->a, (uint32_t)a0); put32(mem, r->b, (uint32_t)b0); put32(mem, r->c, (uint32_t)c0); put32(mem, r->d, (uint32_t)d0);
    mem[r->w1] = (uint8_t)w1; mem[r->w1 + 1] = (uint8_t)((uint16_t)w1 >> 8);
    mem[r->w2] = (uint8_t)w2; mem[r->w2 + 1] = (uint8_t)((uint16_t)w2 >> 8);
    memcpy(ref, mem, size);
    g_world.dword_58319a = xlo; g_world.dword_5831a2 = xhi; g_world.dword_583196 = ylo; g_world.dword_58319e = yhi;
    ref_axis(ref, r->a, r->b, r->w1, xlo, xhi);
    ref_axis(ref, r->c, r->d, r->w2, ylo, yhi);
    r->fn(mem, &g_world);
    CK(memcmp(mem, ref, size) == 0);
    CK(L.n == 0);
    CK(g_world.dword_58319a == xlo && g_world.dword_5831a2 == xhi && g_world.dword_583196 == ylo && g_world.dword_58319e == yhi);
    free(mem);
    free(ref);
}

static void check_clamp_row(const ClampRow *r)
{
    size_t size = 0, k;
    const uint32_t fields[] = {r->a, r->b, r->c, r->d, r->w1, r->w2};
    for (k = 0; k < 6; k++)
        if (fields[k] + 4 > size) size = fields[k] + 4;
    /* x axis: inside / below / above / below and then above (a narrow range) / signed against unsigned / negative and positive extents; the y axis is checked the same way */
    check_clamp_once(r, 10, 100, 20, 200, 50, 60, 5, 50, 60, 5, size);
    check_clamp_once(r, 10, 100, 20, 200, 3, 60, 5, 50, 60, 5, size);
    check_clamp_once(r, 10, 100, 20, 200, 50, 160, 5, 50, 60, 5, size);
    check_clamp_once(r, 10, 100, 20, 200, 3, 160, 5, 50, 60, 5, size);
    check_clamp_once(r, 10, 12, 20, 200, 3, 4, 40, 50, 60, 5, size);                 /* below, then the moved maximum is above: both arms run */
    check_clamp_once(r, 10, 100, 20, 200, 50, 60, 5, 5, 60, 5, size);
    check_clamp_once(r, 10, 100, 20, 200, 50, 60, 5, 50, 260, 5, size);
    check_clamp_once(r, 10, 100, 20, 200, 50, 60, 5, 5, 260, 5, size);
    check_clamp_once(r, 10, 100, 20, 21, 50, 60, 5, 5, 6, 40, size);
    check_clamp_once(r, 10, 100, 20, 200, -10, 60, -3, 50, 60, -3, size);            /* a negative field is below 10 when signed; the extent -3 is sign-extended */
    check_clamp_once(r, -10, -5, -20, -5, -50, 60, -3, -50, 60, 0x7fff, size);
    check_clamp_once(r, -10, -5, -20, -5, 0, 0x7fffffff, (int16_t)0x8000, 0, 0x7fffffff, (int16_t)0x8000, size);
    check_clamp_once(r, (int32_t)0x80000000u, 0x7fffffff, (int32_t)0x80000000u, 0x7fffffff, 0, 0, 1, 0, 0, 1, size);
    check_clamp_once(r, 0x7ffffff0, 0x7fffffff, 0x7ffffff0, 0x7fffffff, 5, 5, 100, 5, 5, 100, size);   /* the addition wraps */
    check_clamp_once(r, 10, 10, 20, 20, 10, 10, 0, 20, 20, 0, size);                  /* the bounds themselves are inside */
    check_clamp_once(r, 10, 10, 20, 20, 9, 11, 0, 19, 21, 0, size);
    check_clamp_once(r, 10, 100, 20, 200, 10, 50, 5, 20, 90, 7, size);                /* a field equal to its minimum is not moved (the other field and the extent are not touched) */
    check_clamp_once(r, 10, 100, 20, 200, 50, 100, 5, 90, 200, 7, size);              /* a field equal to its maximum is not moved */
    check_clamp_once(r, 10, 5, 20, 3, 7, 8, 2, 4, 5, 3, size);                        /* a maximum below the minimum: the minimum clamp runs, then the maximum clamp */
    check_clamp_once(r, 10, 5, 20, 3, 6, 4, 2, 2, 1, 3, size);
}

static void check_clamp(ClampFn fn, uint32_t a, uint32_t b, uint32_t w1, uint32_t c, uint32_t d, uint32_t w2)
{
    const ClampRow r = {fn, a, b, w1, c, d, w2};
    check_clamp_row(&r);
}

static void test_m40430e_read_word_setting(void) { check_read_word(m40430e_read_word_setting, 0x18c, offsetof(Fl38cWorld, word_5e5686), 0x4033db); }
static void test_m404349_read_word_setting(void) { check_read_word(m404349_read_word_setting, 0x14c, offsetof(Fl38cWorld, word_5e5684), 0x4033db); }
static void test_m40492f_read_word_setting(void) { check_read_word(m40492f_read_word_setting, 0x38c, offsetof(Fl38cWorld, word_5ec33a), 0x4033db); }
static void test_m40496a_read_word_setting(void) { check_read_word(m40496a_read_word_setting, 0x3cc, offsetof(Fl38cWorld, word_5ec284), 0x4033db); }
static void test_m4049a5_read_word_setting(void) { check_read_word(m4049a5_read_word_setting, 0x44c, offsetof(Fl38cWorld, word_5ec288), 0x4033db); }
static void test_m4049e0_read_word_setting(void) { check_read_word(m4049e0_read_word_setting, 0x40c, offsetof(Fl38cWorld, word_5ec286), 0x4033db); }
static void test_m40893f_read_word_setting(void) { check_read_word(m40893f_read_word_setting, 0x94c, offsetof(Fl38cWorld, word_5ec2d4), 0x407ca7); }
static void test_m4043b6_read_time_setting(void) { check_read_time(m4043b6_read_time_setting, 0x24c, 0x0, 0xc); }
static void test_m40445a_read_time_setting(void) { check_read_time(m40445a_read_time_setting, 0x20c, 0x0, 0x8); }
static void test_m4044fe_read_time_setting(void) { check_read_time(m4044fe_read_time_setting, 0x28c, 0x0, 0x4); }
static void test_m4045a2_read_time_setting(void) { check_read_time(m4045a2_read_time_setting, 0x30c, 0x14, 0xc); }
static void test_m404646_read_time_setting(void) { check_read_time(m404646_read_time_setting, 0x2cc, 0x14, 0x8); }
static void test_m4046ea_read_time_setting(void) { check_read_time(m4046ea_read_time_setting, 0x34c, 0x14, 0x4); }
static void test_m454f29_shift_rect(void) { check_shift_rect(m454f29_shift_rect); }
static void test_m457071_shift_rect(void) { check_shift_rect(m457071_shift_rect); }
static void test_m458137_shift_rect(void) { check_shift_rect(m458137_shift_rect); }
static void test_m46453b_shift_rect(void) { check_shift_rect(m46453b_shift_rect); }
static void test_m466db1_shift_rect(void) { check_shift_rect(m466db1_shift_rect); }
static void test_m479d98_shift_rect(void) { check_shift_rect(m479d98_shift_rect); }
static void test_m4465fd_new_zeroed(void) { check_new_zeroed(m4465fd_new_zeroed, 0x54824c); }
static void test_m4547bc_new_zeroed(void) { check_new_zeroed(m4547bc_new_zeroed, 0x549e28); }
static void test_m454f7c_clamp_to_bounds(void) { check_clamp(m454f7c_clamp_to_bounds, 0x4e, 0x56, 0x16c, 0x4a, 0x52, 0x16a); }
static void test_m46458e_clamp_to_bounds(void) { check_clamp(m46458e_clamp_to_bounds, 0x4e, 0x56, 0xd4, 0x4a, 0x52, 0xd2); }
static void test_m46b855_clamp_to_bounds(void) { check_clamp(m46b855_clamp_to_bounds, 0x49f8, 0x4a00, 0x816c, 0x49f4, 0x49fc, 0x816a); }

/* every port on heap buffers of exactly the bytes the original touches (for the sanitiser builds) */
static const struct {
    ReadFn fn;
    uint32_t off;
    size_t word_off;
    uint32_t callee;
} G1[] = {
    {m40430e_read_word_setting, 0x18c, offsetof(Fl38cWorld, word_5e5686), 0x4033db},
    {m404349_read_word_setting, 0x14c, offsetof(Fl38cWorld, word_5e5684), 0x4033db},
    {m40492f_read_word_setting, 0x38c, offsetof(Fl38cWorld, word_5ec33a), 0x4033db},
    {m40496a_read_word_setting, 0x3cc, offsetof(Fl38cWorld, word_5ec284), 0x4033db},
    {m4049a5_read_word_setting, 0x44c, offsetof(Fl38cWorld, word_5ec288), 0x4033db},
    {m4049e0_read_word_setting, 0x40c, offsetof(Fl38cWorld, word_5ec286), 0x4033db},
    {m40893f_read_word_setting, 0x94c, offsetof(Fl38cWorld, word_5ec2d4), 0x407ca7},
};
static const struct {
    ReadFn fn;
    uint32_t off, base, store;
} G2[] = {
    {m4043b6_read_time_setting, 0x24c, 0x0, 0xc},
    {m40445a_read_time_setting, 0x20c, 0x0, 0x8},
    {m4044fe_read_time_setting, 0x28c, 0x0, 0x4},
    {m4045a2_read_time_setting, 0x30c, 0x14, 0xc},
    {m404646_read_time_setting, 0x2cc, 0x14, 0x8},
    {m4046ea_read_time_setting, 0x34c, 0x14, 0x4},
};
static ShiftFn const G3[] = {
    m454f29_shift_rect,
    m457071_shift_rect,
    m458137_shift_rect,
    m46453b_shift_rect,
    m466db1_shift_rect,
    m479d98_shift_rect,
};
static const struct {
    NewFn fn;
    uint32_t fmt;
} G4A[] = {
    {m4465fd_new_zeroed, 0x54824c},
    {m4547bc_new_zeroed, 0x549e28},
};
static const struct {
    ClampFn fn;
    uint32_t a, b, w1, c, d, w2;
} G4B[] = {
    {m454f7c_clamp_to_bounds, 0x4e, 0x56, 0x16c, 0x4a, 0x52, 0x16a},
    {m46458e_clamp_to_bounds, 0x4e, 0x56, 0xd4, 0x4a, 0x52, 0xd2},
    {m46b855_clamp_to_bounds, 0x49f8, 0x4a00, 0x816c, 0x49f4, 0x49fc, 0x816a},
};

static void test_exact_size_buffers(void)
{
    size_t r;
    uint32_t i;
    for (r = 0; r < sizeof G1 / sizeof G1[0] && !g_failed; r++) {
        uint8_t *self = malloc(G1[r].off + 1);
        CK(self != NULL);
        if (self == NULL) break;
        reset();
        g_conv = 0x1234;
        G1[r].fn(self, &g_world, &g_host);
        CK(L.n == 3);
        free(self);
    }
    for (r = 0; r < sizeof G2 / sizeof G2[0] && !g_failed; r++) {
        uint8_t *self = malloc(G2[r].off + 1), *tab = malloc(G2[r].base + 0x10);          /* index 0: the fields end at base + 0xc + 4 */
        CK(self != NULL && tab != NULL);
        if (self == NULL || tab == NULL) break;
        memset(tab, 1, G2[r].base + 0x10);
        reset();
        g_world.table_5e569e = tab;
        g_world.dword_5c3a63 = 0;
        G2[r].fn(self, &g_world, &g_host);
        CK(L.n == 3);
        free(self);
        free(tab);
    }
    for (r = 0; r < sizeof G3 / sizeof G3[0] && !g_failed; r++) {
        uint8_t *src = malloc(16), *dst = malloc(16);
        CK(src != NULL && dst != NULL);
        if (src == NULL || dst == NULL) break;
        memset(src, 3, 16);
        memset(dst, 0, 16);
        reset();
        G3[r](src, dst, &g_world);
        CK(get32(dst, 0) == 0x03030303u && get32(dst, 4) == 0x03030303u && get32(dst, 8) == 0x03030303u && get32(dst, 12) == 0x03030303u);
        free(src);
        free(dst);
    }
    for (r = 0; r < sizeof G4A / sizeof G4A[0] && !g_failed; r++) {
        uint8_t *cell = malloc(4), *blk = malloc(13);
        CK(cell != NULL && blk != NULL);
        if (cell == NULL || blk == NULL) break;
        memset(blk, 0xa5, 13);
        reset();
        g_cells = cell; g_cells_len = 4; g_blk = blk; g_blk_len = 13;
        g_new = BLK_VA;
        G4A[r].fn(CELL_VA, 13, &g_world, &g_host);
        for (i = 0; i < 13; i++) CK(blk[i] == 0);
        free(cell);
        free(blk);
    }
    for (r = 0; r < sizeof G4B / sizeof G4B[0] && !g_failed; r++) {
        const uint32_t f[] = {G4B[r].a, G4B[r].b, G4B[r].c, G4B[r].d, G4B[r].w1, G4B[r].w2};
        size_t size = 0, k;
        uint8_t *self;
        for (k = 0; k < 6; k++)
            if (f[k] + 4 > size) size = f[k] + 4;
        self = calloc(1, size);
        CK(self != NULL);
        if (self == NULL) break;
        reset();
        G4B[r].fn(self, &g_world);
        free(self);
    }
}

#define RUN(fn)                                  \
    do {                                         \
        g_failed = 0;                            \
        g_msg[0] = 0;                            \
        fn();                                    \
        if (g_failed) {                          \
            printf("FAIL %s: %s\n", #fn, g_msg); \
            failures++;                          \
        } else {                                 \
            printf("PASS %s\n", #fn);            \
        }                                        \
    } while (0)

int main(void)
{
    int failures = 0;
    RUN(test_m40430e_read_word_setting);
    RUN(test_m404349_read_word_setting);
    RUN(test_m40492f_read_word_setting);
    RUN(test_m40496a_read_word_setting);
    RUN(test_m4049a5_read_word_setting);
    RUN(test_m4049e0_read_word_setting);
    RUN(test_m40893f_read_word_setting);
    RUN(test_m4043b6_read_time_setting);
    RUN(test_m40445a_read_time_setting);
    RUN(test_m4044fe_read_time_setting);
    RUN(test_m4045a2_read_time_setting);
    RUN(test_m404646_read_time_setting);
    RUN(test_m4046ea_read_time_setting);
    RUN(test_m454f29_shift_rect);
    RUN(test_m457071_shift_rect);
    RUN(test_m458137_shift_rect);
    RUN(test_m46453b_shift_rect);
    RUN(test_m466db1_shift_rect);
    RUN(test_m479d98_shift_rect);
    RUN(test_m4465fd_new_zeroed);
    RUN(test_m4547bc_new_zeroed);
    RUN(test_m454f7c_clamp_to_bounds);
    RUN(test_m46458e_clamp_to_bounds);
    RUN(test_m46b855_clamp_to_bounds);
    RUN(test_exact_size_buffers);
    return failures;
}
