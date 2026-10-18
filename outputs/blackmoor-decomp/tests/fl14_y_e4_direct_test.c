/* FL-14 direct test of e4r_invalidate (original 0x4758e8) of the raw 0xe4 Match puzzle kernel
 * (src/action_family_e4_runtime.c). Original pseudocode: if dword this+0x89a != 0 and word this+0x20 != -1:
 * entry[slot].+0x14 := 1 (native: host mark_dirty(slot)). */
#include "../src/action_family_e4_runtime.c"

#include "fl14_y_common.h"

static void test_e4r_invalidate_4758e8(void)
{
    for (size_t i = 0; i < N_INV_CASES; ++i) {
        E4rObject o;
        E4rObject before;
        E4rHost host;
        Rec rec;
        const int32_t active = k_inv_cases[i].active;
        const int16_t slot = k_inv_cases[i].slot;
        memset(&o, 0, sizeof o);
        memset(&host, 0, sizeof host);
        memset(&rec, 0, sizeof rec);
        host.context = &rec;
        host.mark_dirty = rec_mark_dirty;
        for (int k = 0; k < 4; ++k) o.b[0x89a + k] = (uint8_t)((uint32_t)active >> (8 * k)); /* dword +0x89a */
        o.b[0x20] = (uint8_t)(uint16_t)slot;                                                  /* word +0x20 */
        o.b[0x21] = (uint8_t)((uint16_t)slot >> 8);
        memcpy(&before, &o, sizeof o);
        CK(e4r_invalidate(&o, &host) == E4R_OK);
        CK(rec.calls == k_inv_cases[i].expect_call);
        if (k_inv_cases[i].expect_call) CK(rec.slot[0] == slot);
        CK(memcmp(&before, &o, sizeof o) == 0);
    }
}

int main(void)
{
    RUN_TEST(test_e4r_invalidate_4758e8);
    return g_fail_count;
}
