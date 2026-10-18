/* FL-11 direct test of the static helpers of src/action_family_d3_runtime.c (raw 0xd3, the Collision Puzzle): type_is
 * (GAME.EXE 0x461d4b), grid_setup (0x462577), cell_rect (0x462b84) and solved_scan (0x4632bf). The kernel is pulled in as a
 * translation unit (shim pattern of tests/action_family_28_x87_division_fixture.c) so the test calls the static functions
 * itself. Prints "PASS <name>" / "FAIL <name>: <msg>"; the exit status is the failure count. Fixtures are synthetic bodies (no
 * original bytes); expected values are derived by hand from the Ghidra pseudocode of the four functions (x86 idiv truncates
 * toward zero), not by running the kernel. */
#include "../src/action_family_d3_runtime.c"

#include <stdio.h>

static int g_failed;
static char g_msg[256];
#define CK(cond)                                                               \
    do {                                                                       \
        if (!(cond) && !g_failed) {                                            \
            g_failed = 1;                                                      \
            snprintf(g_msg, sizeof g_msg, "line %d: %.200s", __LINE__, #cond); \
        }                                                                      \
    } while (0)

static void t_put16(uint8_t *b, size_t off, int v)
{
    b[off] = (uint8_t)v;
    b[off + 1] = (uint8_t)((unsigned)v >> 8);
}
static void t_put32(uint8_t *b, size_t off, int32_t v)
{
    for (int i = 0; i < 4; ++i) b[off + (size_t)i] = (uint8_t)((uint32_t)v >> (8 * i));
}
static void t_rect(uint8_t *b, size_t off, int32_t l, int32_t t, int32_t r, int32_t bt)
{
    t_put32(b, off, l);
    t_put32(b, off + 4, t);
    t_put32(b, off + 8, r);
    t_put32(b, off + 12, bt);
}
static int t_same4(const int32_t *got, int32_t l, int32_t t, int32_t r, int32_t b)
{
    return got[0] == l && got[1] == t && got[2] == r && got[3] == b;
}

typedef struct {
    int effect[8];
    int32_t a[8], b[8];
    int n;
} TLog;

static void t_observe(void *context, int effect, int32_t a, int32_t b)
{
    TLog *l = (TLog *)context;
    if (l->n < 8) {
        l->effect[l->n] = effect;
        l->a[l->n] = a;
        l->b[l->n] = b;
    }
    ++l->n;
}

/* 0x462b84: cell rectangle. left = gap * b + view_x + origin_x + b * cell_w, right = left + cell_w, top = gap * a + view_y +
 * origin_y + a * cell_h, bottom = top + cell_h; gap is a signed word, origin a signed dword. */
static void test_cell_rect(void)
{
    uint8_t body[CPZ_BODY_BYTES];
    CpzObject o;
    int32_t out[4];
    memset(body, 0, sizeof body);
    memset(&o, 0, sizeof o);
    o.cell_w = 20;
    o.cell_h = 10;
    t_put16(body, 0x248, 3);
    t_put32(body, 0x240, 100);
    t_put32(body, 0x244, 200);
    /* a = 2, b = 3: x = 3*3 + 7 + 100 + 3*20 = 176; y = 3*2 - 5 + 200 + 2*10 = 221 */
    cell_rect(&o, body, 7, -5, 2, 3, out);
    CK(t_same4(out, 176, 221, 196, 231));
    /* the origin cell: only the view and the origin contribute */
    cell_rect(&o, body, 7, -5, 0, 0, out);
    CK(t_same4(out, 107, 195, 127, 205));
    /* a and b are not interchangeable: a drives the vertical axis */
    cell_rect(&o, body, 0, 0, 1, 0, out);
    CK(t_same4(out, 100, 213, 120, 223));
    cell_rect(&o, body, 0, 0, 0, 1, out);
    CK(t_same4(out, 123, 200, 143, 210));
    /* a negative gap word (0xfffe) and a negative origin dword: a = 1, b = 1: x = -2 + 7 - 50 + 20 = -25; y = -2 - 5 + 200 + 10 */
    t_put16(body, 0x248, 0xfffe);
    t_put32(body, 0x240, -50);
    cell_rect(&o, body, 7, -5, 1, 1, out);
    CK(t_same4(out, -25, 203, -5, 213));
    if (!g_failed) printf("PASS test_cell_rect\n");
    else printf("FAIL test_cell_rect: %s\n", g_msg);
}

/* 0x461d4b: the cell type at (a, b) equals the piece number; the first index is the row (stride 0x140), the second the column
 * (stride 0x28). */
static void test_type_is(void)
{
    CpzWorld w;
    memset(&w, 0, sizeof w);
    w.cell[1][2].type = 5;
    w.cell[2][1].type = 6;
    w.cell[7][7].type = -1;
    CK(type_is(&w, 5, 1, 2) == 1);
    CK(type_is(&w, 5, 2, 1) == 0);
    CK(type_is(&w, 6, 2, 1) == 1);
    CK(type_is(&w, 6, 1, 2) == 0);
    CK(type_is(&w, 4, 1, 2) == 0);
    /* an empty cell (type 0) equals piece 0 only */
    CK(type_is(&w, 0, 0, 0) == 1);
    CK(type_is(&w, 1, 0, 0) == 0);
    /* a 16-bit compare on the last cell */
    CK(type_is(&w, -1, 7, 7) == 1);
    CK(type_is(&w, 0, 7, 7) == 0);
    if (!g_failed) printf("PASS test_type_is\n");
    else printf("FAIL test_type_is: %s\n", g_msg);
}

/* 0x462577: the one-time grid setup. Guarded by a flag; zeroes each 40-byte cell, copies the type word at body + 0x28 + 16a + 2b,
 * calls cell_rect for base and rect, adjusts base for the arrow types (0x10/0x13 horizontal, 0x11/0x12 vertical) with signed
 * integer divides by 2, then marks the cells of the start table (column word, row word, piece = k + 1). */
static void test_grid_setup(void)
{
    uint8_t body[CPZ_BODY_BYTES];
    CpzObject o;
    CpzWorld w;
    memset(body, 0, sizeof body);
    memset(&o, 0, sizeof o);
    o.cell_w = 16;
    o.cell_h = 12;

    /* Case 1: 2 rows x 4 columns, 3 pieces, gap 4, origin (10, 20), view (1, 2). Cell (a, b): left = 20b + 11, top = 16a + 22,
     * size 16 x 12. Horizontal arrow source 11 x 9 (gap/2 = 2, (12 - 9)/2 = 1, w/2 = 5); vertical arrow source 5 x 11
     * ((16 - 5)/2 = 5, h/2 = 5). */
    t_put16(body, 0x22, 2);
    t_put16(body, 0x24, 4);
    t_put16(body, 0x26, 3);
    t_put16(body, 0x248, 4);
    t_put32(body, 0x240, 10);
    t_put32(body, 0x244, 20);
    t_rect(body, 0x210, 5, 3, 16, 12);
    t_rect(body, 0x220, 2, 4, 7, 15);
    t_put16(body, 0x28 + 0 * 16 + 1 * 2, 3);
    t_put16(body, 0x28 + 0 * 16 + 2 * 2, 0x10);
    t_put16(body, 0x28 + 0 * 16 + 3 * 2, 0x14);
    t_put16(body, 0x28 + 1 * 16 + 0 * 2, 0x13);
    t_put16(body, 0x28 + 1 * 16 + 1 * 2, 0x11);
    t_put16(body, 0x28 + 1 * 16 + 2 * 2, 0x12);
    t_put16(body, 0x28 + 1 * 16 + 3 * 2, 5);
    /* start table: column word then row word. Piece 1 and piece 3 share (row 0, column 1): the later piece wins; piece 2 is at
     * (row 1, column 3). */
    t_put16(body, 0xa8 + 0, 1);
    t_put16(body, 0xa8 + 2, 0);
    t_put16(body, 0xa8 + 4, 3);
    t_put16(body, 0xa8 + 6, 1);
    t_put16(body, 0xa8 + 8, 1);
    t_put16(body, 0xa8 + 10, 0);
    memset(&w, 0x55, sizeof w);
    w.grid_ready = 0;
    grid_setup(&o, body, &w, 1, 2);
    CK(w.grid_ready == 1);
    /* (0,0): empty, no piece: invisible, zeroed, rect and base both the cell rectangle */
    CK(w.cell[0][0].visible == 0 && w.cell[0][0].type == 0 && w.cell[0][0].piece == 0);
    CK(t_same4(w.cell[0][0].base, 11, 22, 27, 34) && t_same4(w.cell[0][0].rect, 11, 22, 27, 34));
    /* (0,1): target type 3, piece 3 (the last start entry on this cell); base = rect */
    CK(w.cell[0][1].visible == 1 && w.cell[0][1].type == 3 && w.cell[0][1].piece == 3);
    CK(t_same4(w.cell[0][1].base, 31, 22, 47, 34) && t_same4(w.cell[0][1].rect, 31, 22, 47, 34));
    /* (0,2): left arrow 0x10: top 22 + 1, bottom 34 - 1, left 51 - 2 - 5 = 44, right 44 + 11 */
    CK(w.cell[0][2].visible == 1 && w.cell[0][2].type == 0x10 && w.cell[0][2].piece == 0);
    CK(t_same4(w.cell[0][2].base, 44, 23, 55, 33) && t_same4(w.cell[0][2].rect, 51, 22, 67, 34));
    /* (0,3): wall 0x14: visible, base untouched */
    CK(w.cell[0][3].visible == 1 && w.cell[0][3].type == 0x14 && w.cell[0][3].piece == 0);
    CK(t_same4(w.cell[0][3].base, 71, 22, 87, 34) && t_same4(w.cell[0][3].rect, 71, 22, 87, 34));
    /* (1,0): right arrow 0x13: top 38 + 1, bottom 50 - 1, left 27 + 2 - 5 = 24, right 24 + 11 */
    CK(w.cell[1][0].visible == 1 && w.cell[1][0].type == 0x13 && w.cell[1][0].piece == 0);
    CK(t_same4(w.cell[1][0].base, 24, 39, 35, 49) && t_same4(w.cell[1][0].rect, 11, 38, 27, 50));
    /* (1,1): up arrow 0x11: left 31 + 5, right 47 - 5, top 38 - 2 - 5 = 31, bottom 31 + 11 */
    CK(w.cell[1][1].visible == 1 && w.cell[1][1].type == 0x11 && w.cell[1][1].piece == 0);
    CK(t_same4(w.cell[1][1].base, 36, 31, 42, 42) && t_same4(w.cell[1][1].rect, 31, 38, 47, 50));
    /* (1,2): down arrow 0x12: left 51 + 5, right 67 - 5, top 50 + 2 - 5 = 47, bottom 47 + 11 */
    CK(w.cell[1][2].visible == 1 && w.cell[1][2].type == 0x12 && w.cell[1][2].piece == 0);
    CK(t_same4(w.cell[1][2].base, 56, 47, 62, 58) && t_same4(w.cell[1][2].rect, 51, 38, 67, 50));
    /* (1,3): target type 5 with piece 2 */
    CK(w.cell[1][3].visible == 1 && w.cell[1][3].type == 5 && w.cell[1][3].piece == 2);
    CK(t_same4(w.cell[1][3].base, 71, 38, 87, 50) && t_same4(w.cell[1][3].rect, 71, 38, 87, 50));
    /* cells outside R x C keep their previous bytes (0x55 fill) */
    CK(w.cell[2][0].visible == 0x55555555 && w.cell[0][4].type == 0x5555 && w.cell[7][7].piece == 0x5555);

    /* Case 2: the flag is already set: nothing changes */
    memset(&w, 0x55, sizeof w);
    w.grid_ready = 1;
    grid_setup(&o, body, &w, 1, 2);
    CK(w.grid_ready == 1 && w.cell[0][0].visible == 0x55555555 && w.cell[1][3].type == 0x5555);

    /* Case 3: negative gap -5, origin 0, view 0, 2 x 2, no pieces; integer divides truncate toward zero. Horizontal arrow
     * 9 x 15: (12 - 15)/2 = -1, gap/2 = -2, w/2 = 4. Vertical arrow 19 x 7: (16 - 19)/2 = -1, gap/2 = -2, h/2 = 3. Cell
     * (a, b): left = 11b, top = 7a. */
    memset(body, 0, sizeof body);
    t_put16(body, 0x22, 2);
    t_put16(body, 0x24, 2);
    t_put16(body, 0x26, 0);
    t_put16(body, 0x248, -5);
    t_rect(body, 0x210, 0, 0, 9, 15);
    t_rect(body, 0x220, 0, 0, 19, 7);
    t_put16(body, 0x28 + 0 * 16 + 0 * 2, 0x10);
    t_put16(body, 0x28 + 0 * 16 + 1 * 2, 0x13);
    t_put16(body, 0x28 + 1 * 16 + 0 * 2, 0x11);
    t_put16(body, 0x28 + 1 * 16 + 1 * 2, 0x12);
    /* a start entry beyond P = 0 is ignored (cell (0,0) stays pieceless) */
    t_put16(body, 0xa8, 0);
    t_put16(body, 0xaa, 0);
    memset(&w, 0, sizeof w);
    grid_setup(&o, body, &w, 0, 0);
    CK(t_same4(w.cell[0][0].base, -2, -1, 7, 13) && t_same4(w.cell[0][0].rect, 0, 0, 16, 12));
    CK(t_same4(w.cell[0][1].base, 21, -1, 30, 13) && t_same4(w.cell[0][1].rect, 11, 0, 27, 12));
    CK(t_same4(w.cell[1][0].base, -1, 6, 17, 13) && t_same4(w.cell[1][0].rect, 0, 7, 16, 19));
    CK(t_same4(w.cell[1][1].base, 10, 14, 28, 21) && t_same4(w.cell[1][1].rect, 11, 7, 27, 19));
    CK(w.cell[0][0].piece == 0 && w.cell[0][0].visible == 1);

    /* Case 4: zero rows: the flag is set, no cell is touched */
    t_put16(body, 0x22, 0);
    memset(&w, 0x55, sizeof w);
    w.grid_ready = 0;
    grid_setup(&o, body, &w, 0, 0);
    CK(w.grid_ready == 1 && w.cell[0][0].visible == 0x55555555);
    if (!g_failed) printf("PASS test_grid_setup\n");
    else printf("FAIL test_grid_setup: %s\n", g_msg);
}

/* 0x4632bf: scans rows x cols; returns silently at the first occupied cell whose type differs from its piece number; when no
 * such cell exists sets solved = 1 and state = 1 and reports the state store. */
static void test_solved_scan(void)
{
    uint8_t body[CPZ_BODY_BYTES];
    CpzObject o;
    CpzWorld w;
    CpzHost host;
    TLog log;
    memset(body, 0, sizeof body);
    memset(&host, 0, sizeof host);
    host.context = &log;
    host.observe = t_observe;
    t_put16(body, 0x22, 3);
    t_put16(body, 0x24, 4);

    /* an empty grid is solved */
    memset(&w, 0, sizeof w);
    memset(&o, 0, sizeof o);
    memset(&log, 0, sizeof log);
    solved_scan(&o, &w, body, &host);
    CK(o.solved == 1 && o.state == CPZ_STATE_SOLVED);
    CK(log.n == 1 && log.effect[0] == CPZ_FX_STATE && log.a[0] == 1 && log.b[0] == 0);

    /* pieces standing on their own number: solved (state was 4 before) */
    memset(&w, 0, sizeof w);
    memset(&o, 0, sizeof o);
    memset(&log, 0, sizeof log);
    o.state = CPZ_STATE_WAIT_DELAY;
    w.cell[0][0].type = 1;
    w.cell[0][0].piece = 1;
    w.cell[2][3].type = 2;
    w.cell[2][3].piece = 2;
    w.cell[1][1].type = 7; /* a target without a piece does not matter */
    solved_scan(&o, &w, body, &host);
    CK(o.solved == 1 && o.state == CPZ_STATE_SOLVED && log.n == 1 && log.effect[0] == CPZ_FX_STATE);

    /* piece 2 on a cell of type 3: not solved, nothing changes, no effect */
    memset(&w, 0, sizeof w);
    memset(&o, 0, sizeof o);
    memset(&log, 0, sizeof log);
    o.state = CPZ_STATE_WAIT_DELAY;
    w.cell[0][0].type = 1;
    w.cell[0][0].piece = 1;
    w.cell[1][2].type = 3;
    w.cell[1][2].piece = 2;
    solved_scan(&o, &w, body, &host);
    CK(o.solved == 0 && o.state == CPZ_STATE_WAIT_DELAY && log.n == 0);

    /* a piece on an empty cell (type 0) is a mismatch */
    memset(&w, 0, sizeof w);
    memset(&o, 0, sizeof o);
    memset(&log, 0, sizeof log);
    w.cell[2][0].piece = 1;
    solved_scan(&o, &w, body, &host);
    CK(o.solved == 0 && o.state == 0 && log.n == 0);

    /* a mismatch in the very last scanned cell (row R-1, column C-1) still fails */
    memset(&w, 0, sizeof w);
    memset(&o, 0, sizeof o);
    memset(&log, 0, sizeof log);
    w.cell[2][3].type = 1;
    w.cell[2][3].piece = 4;
    solved_scan(&o, &w, body, &host);
    CK(o.solved == 0 && o.state == 0 && log.n == 0);

    /* mismatching pieces outside rows x cols (row 3, column 4) are never scanned */
    memset(&w, 0, sizeof w);
    memset(&o, 0, sizeof o);
    memset(&log, 0, sizeof log);
    w.cell[3][0].piece = 1;
    w.cell[0][4].piece = 1;
    solved_scan(&o, &w, body, &host);
    CK(o.solved == 1 && o.state == CPZ_STATE_SOLVED && log.n == 1);

    /* no observer: the state is still stored */
    memset(&w, 0, sizeof w);
    memset(&o, 0, sizeof o);
    host.observe = NULL;
    solved_scan(&o, &w, body, &host);
    CK(o.solved == 1 && o.state == 1);
    if (!g_failed) printf("PASS test_solved_scan\n");
    else printf("FAIL test_solved_scan: %s\n", g_msg);
}

int main(void)
{
    int failures = 0;
    void (*const tests[])(void) = {test_cell_rect, test_type_is, test_grid_setup, test_solved_scan};
    for (size_t i = 0; i < sizeof tests / sizeof tests[0]; ++i) {
        g_failed = 0;
        tests[i]();
        failures += g_failed;
    }
    return failures;
}
