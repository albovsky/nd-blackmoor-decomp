/* FL-14 direct tests of the raw 0xeb Multibuild puzzle kernel (src/action_family_eb_runtime.c): the static rect_valid
 * (original 0x47e99e), the static near_unplaced (original 0x47ec06) and eb_invalidate (original 0x47e440). Expected values
 * are derived by hand from the original pseudocode; every offset is the original's displacement:
 *   0x47e99e(rect*): p[3] == p[1] (bottom == top) or p[2] == p[0] (right == left) -> 0, else 1.
 *   0x47ec06(x, y): hand = word this+0x1350; half_w = (right - left) / 2 and half_h = (bottom - top) / 2 of piece[hand]
 *     (pieces at this+0x7b6 + i * 0x25: left, top, right, bottom dwords; type byte at this+0x7d7 + i * 0x25), both truncated to
 *     a short; for j in 0 .. word this+0x13a2 - 1: home = *(0x5bb5e5 + row * 0x8d) + 0xa9 + type * 0x53 (4 dwords); when the
 *     piece rectangle differs from home and top_j - 4 < y + half_h and y < top_j and left_j - 0x14 < x - half_w and
 *     x + half_w < right_j + 0x14 return 1; after the last piece return 0.
 *   0x47e440: if dword this+0x13c5 != 0 and word this+0x1c != -1: entry[slot].+0x14 := 1 (native: host mark_dirty(slot)). */
#include "../src/action_family_eb_runtime.c"

#include "fl14_y_common.h"

static void test_rect_valid_47e99e(void)
{
    static const int32_t vals[3] = {-1, 0, 5};
    uint8_t buf[64];
    const size_t off = 6; /* the rectangle does not start at the buffer start */
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
    /* explicit cases: left, top, right, bottom */
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

enum { NU_PIECE0 = 0x7b4, NU_TYPE0 = 0x99 };

static void nu_piece(uint8_t *obj, int i, int type, const int32_t r[4])
{
    const size_t p = (size_t)NU_PIECE0 + (size_t)i * 0x25u;
    obj[p + 0x23] = (uint8_t)type;
    for (int k = 0; k < 4; ++k) wr_32(obj, p + 2 + (size_t)k * 4u, r[k]);
}
static void nu_home(uint8_t *body, int type, const int32_t r[4])
{
    for (int k = 0; k < 4; ++k) wr_32(body, (size_t)NU_TYPE0 + (size_t)type * 0x53u + 0x10u + (size_t)k * 4u, r[k]);
}

static void test_near_unplaced_47ec06(void)
{
    static EbObject o;
    static uint8_t body[EB_BODY_BYTES];
    const int32_t wide[4] = {0, 0, 1000, 1000};
    const int32_t hand[4] = {100, 200, 141, 261}; /* width 41 -> 20, height 61 -> 30 (truncated) */
    const int32_t cand[4] = {90, 300, 150, 340};  /* top 300, left 90, right 150 */
    const int32_t other[4] = {1, 2, 3, 4};
    memset(&o, 0, sizeof o);
    memset(body, 0, sizeof body);
    wr_16(o.b, O_HAND, 1);
    wr_16(o.b, O_COUNT, 3);
    nu_piece(o.b, 0, 0, wide);
    nu_piece(o.b, 1, 1, hand);
    nu_piece(o.b, 2, 2, cand);
    nu_home(body, 0, wide);  /* piece 0 and the hand piece are at home */
    nu_home(body, 1, hand);
    nu_home(body, 2, other); /* piece 2 is away from home */
    /* the baseline hits; y: 266 < y < 300 (296 < y + 30 and y < 300); x: 90 < x < 150 (70 < x - 20 and x + 20 < 170) */
    CK(near_unplaced(o.b, body, 120, 290) == 1);
    CK(near_unplaced(o.b, body, 120, 266) == 0);
    CK(near_unplaced(o.b, body, 120, 267) == 1);
    CK(near_unplaced(o.b, body, 120, 299) == 1);
    CK(near_unplaced(o.b, body, 120, 300) == 0);
    CK(near_unplaced(o.b, body, 90, 290) == 0);
    CK(near_unplaced(o.b, body, 91, 290) == 1);
    CK(near_unplaced(o.b, body, 149, 290) == 1);
    CK(near_unplaced(o.b, body, 150, 290) == 0);
    CK(near_unplaced(o.b, body, -300, -300) == 0);
    /* count limits the scan: only pieces 0 and 1 (both at home) */
    wr_16(o.b, O_COUNT, 2);
    CK(near_unplaced(o.b, body, 120, 290) == 0);
    wr_16(o.b, O_COUNT, 0);
    CK(near_unplaced(o.b, body, 120, 290) == 0);
    wr_16(o.b, O_COUNT, 3);
    /* at home in all four dwords -> 0; away in any single dword -> 1 */
    nu_home(body, 2, cand);
    CK(near_unplaced(o.b, body, 120, 290) == 0);
    for (int k = 0; k < 4; ++k) {
        int32_t h[4] = {cand[0], cand[1], cand[2], cand[3]};
        h[k] += 1;
        nu_home(body, 2, h);
        CK(near_unplaced(o.b, body, 120, 290) == 1);
    }
    /* the home comes from the piece's type byte: retype piece 2 to type 3 whose home equals the piece */
    nu_home(body, 2, other);
    nu_home(body, 3, cand);
    nu_piece(o.b, 2, 3, cand);
    CK(near_unplaced(o.b, body, 120, 290) == 0);
    nu_piece(o.b, 2, 2, cand);
    CK(near_unplaced(o.b, body, 120, 290) == 1);
    /* the geometry comes from the hand piece: hand 0 is the wide piece (half 500 x 500), which cannot be "under" */
    wr_16(o.b, O_HAND, 0);
    CK(near_unplaced(o.b, body, 120, 290) == 0);
    wr_16(o.b, O_HAND, 1);
    /* a later piece matches after earlier ones fail: move the candidate to index 2 of 4 and add a failing piece 3 */
    wr_16(o.b, O_COUNT, 4);
    nu_piece(o.b, 3, 2, other);
    CK(near_unplaced(o.b, body, 120, 290) == 1);
}

static void test_eb_invalidate_47e440(void)
{
    for (size_t i = 0; i < N_INV_CASES; ++i) {
        EbObject o;
        EbObject before;
        EbHost host;
        Rec rec;
        memset(&o, 0, sizeof o);
        memset(&host, 0, sizeof host);
        memset(&rec, 0, sizeof rec);
        host.context = &rec;
        host.mark_dirty = rec_mark_dirty;
        wr_32(o.b, 0x13c5, k_inv_cases[i].active);
        wr_16(o.b, 0x1c, k_inv_cases[i].slot);
        memcpy(&before, &o, sizeof o);
        CK(eb_invalidate(&o, &host) == EB_OK);
        CK(rec.calls == k_inv_cases[i].expect_call);
        if (k_inv_cases[i].expect_call) CK(rec.slot[0] == k_inv_cases[i].slot);
        CK(memcmp(&before, &o, sizeof o) == 0);
    }
}

int main(void)
{
    RUN_TEST(test_rect_valid_47e99e);
    RUN_TEST(test_near_unplaced_47ec06);
    RUN_TEST(test_eb_invalidate_47e440);
    return g_fail_count;
}
