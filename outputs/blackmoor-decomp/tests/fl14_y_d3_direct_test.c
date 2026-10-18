/* FL-14 direct tests of the raw 0xd3 Collision puzzle kernel (src/action_family_d3_runtime.c): cpz_grid_reset (original
 * 0x4618df) and cpz_invalidate (original 0x4618ab). Expected values from the original pseudocode:
 *   0x4618df: byte 0x594db3 := 0, then 0x280 dwords from 0x594db5 := 0 (64 cells of 40 bytes); nothing else is written.
 *   0x4618ab: if dword this+0x3f != 0 and word this+0x1c != -1: entry[slot].+0x14 := 1 (native: host mark_dirty(slot)). */
#include "../src/action_family_d3_runtime.c"

#include "fl14_y_common.h"

static void test_cpz_grid_reset_4618df(void)
{
    static CpzWorld w;
    uint8_t *cells = (uint8_t *)w.cell;
    CK(sizeof w.cell == 0x280u * 4u); /* the 0x280 dwords of the original */
    memset(&w, 0xA5, sizeof w);
    w.start_flag_5bb1ca = 77;
    w.grid_ready = 1;
    cpz_grid_reset(&w);
    CK(w.grid_ready == 0);
    {
        size_t nonzero = 0;
        for (size_t i = 0; i < sizeof w.cell; ++i) nonzero += cells[i] != 0;
        CK(nonzero == 0);
    }
    CK(w.start_flag_5bb1ca == 77); /* the start flag 0x5bb1ca is not touched */
    /* already clear stays clear; a nonzero last dword (index 0x27f) is cleared as well */
    w.grid_ready = 1;
    w.cell[CPZ_GRID_MAX - 1][CPZ_GRID_MAX - 1].piece = 9;
    w.cell[0][0].visible = 1;
    cpz_grid_reset(&w);
    CK(w.grid_ready == 0 && w.cell[CPZ_GRID_MAX - 1][CPZ_GRID_MAX - 1].piece == 0 && w.cell[0][0].visible == 0);
}

static void test_cpz_invalidate_4618ab(void)
{
    for (size_t i = 0; i < N_INV_CASES; ++i) {
        CpzObject o;
        CpzObject before;
        CpzHost host;
        Rec rec;
        memset(&o, 0, sizeof o);
        memset(&host, 0, sizeof host);
        memset(&rec, 0, sizeof rec);
        host.context = &rec;
        host.mark_dirty = rec_mark_dirty;
        o.active = k_inv_cases[i].active;
        o.slot = k_inv_cases[i].slot;
        memcpy(&before, &o, sizeof o);
        CK(cpz_invalidate(&o, &host) == CPZ_OK);
        CK(rec.calls == k_inv_cases[i].expect_call);
        if (k_inv_cases[i].expect_call) CK(rec.slot[0] == k_inv_cases[i].slot);
        CK(memcmp(&before, &o, sizeof o) == 0);
    }
}

int main(void)
{
    RUN_TEST(test_cpz_grid_reset_4618df);
    RUN_TEST(test_cpz_invalidate_4618ab);
    return g_fail_count;
}
