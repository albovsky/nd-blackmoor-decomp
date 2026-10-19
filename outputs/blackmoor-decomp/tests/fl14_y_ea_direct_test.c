/* FL-14 direct tests of the raw 0xea kernel (src/action_family_ea_runtime.c): the static rect_valid (original 0x484f0d)
 * and ea_invalidate (original 0x4840d9). Expected values from the original pseudocode:
 *   0x484f0d(rect*): p[3] == p[1] (bottom == top) or p[2] == p[0] (right == left) -> 0, else 1.
 *   0x4840d9: if dword this+0xba7 != 0 and word this+0x1c != -1: entry[slot].+0x14 := 1 (native: host mark_dirty(slot)). */
#include "../src/action_family_ea_runtime.c"

#include "fl14_y_common.h"

static void test_rect_valid_484f0d(void)
{
    static const int32_t vals[3] = {-1, 0, 5};
    uint8_t buf[64];
    const size_t off = 10; /* the rectangle does not start at the buffer start */
    memset(buf, 0xEE, sizeof buf);
    for (int l = 0; l < 3; ++l)
        for (int t = 0; t < 3; ++t)
            for (int r = 0; r < 3; ++r)
                for (int b = 0; b < 3; ++b) {
                    const int32_t v[4] = {vals[l], vals[t], vals[r], vals[b]};
                    const int expect = (v[3] == v[1] || v[2] == v[0]) ? 0 : 1; /* the original expression */
                    for (int k = 0; k < 4; ++k) wr_32(buf, off + (size_t)k * 4u, v[k]);
                    CK(rect_valid(buf, off) == expect);
                }
    {
        const int32_t good[4] = {10, 20, 30, 40}, flat_h[4] = {10, 20, 30, 20}, flat_w[4] = {10, 20, 10, 40},
                      cross[4] = {10, 30, 20, 10}, diag[4] = {10, 10, 30, 30};
        const int32_t *cases[5] = {good, flat_h, flat_w, cross, diag};
        const int expect[5] = {1, 0, 0, 1, 1};
        for (int c = 0; c < 5; ++c) {
            for (int k = 0; k < 4; ++k) wr_32(buf, off + (size_t)k * 4u, cases[c][k]);
            CK(rect_valid(buf, off) == expect[c]);
        }
    }
}

static void test_ea_invalidate_4840d9(void)
{
    for (size_t i = 0; i < N_INV_CASES; ++i) {
        EaObject o;
        EaObject before;
        EaHost host;
        Rec rec;
        memset(&o, 0, sizeof o);
        memset(&host, 0, sizeof host);
        memset(&rec, 0, sizeof rec);
        host.context = &rec;
        host.mark_dirty = rec_mark_dirty;
        wr_32(o.b, 0xba7, k_inv_cases[i].active);
        wr_16(o.b, 0x1c, k_inv_cases[i].slot);
        memcpy(&before, &o, sizeof o);
        CK(ea_invalidate(&o, &host) == EA_OK);
        CK(rec.calls == k_inv_cases[i].expect_call);
        if (k_inv_cases[i].expect_call) CK(rec.slot[0] == k_inv_cases[i].slot);
        CK(memcmp(&before, &o, sizeof o) == 0);
    }
}

int main(void)
{
    RUN_TEST(test_rect_valid_484f0d);
    RUN_TEST(test_ea_invalidate_4840d9);
    return g_fail_count;
}
