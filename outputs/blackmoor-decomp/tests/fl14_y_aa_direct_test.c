/* FL-14 direct test of alc_invalidate (original 0x44d19d) of the raw 0xaa Alarm clock kernel
 * (src/action_family_aa_runtime.c). Original pseudocode: if dword this+0x25 != 0 and word this+0x1c != -1:
 * entry[slot].+0x14 := 1 (native: host mark_dirty(slot)). */
#include "../src/action_family_aa_runtime.c"

#include "fl14_y_common.h"

static void test_alc_invalidate_44d19d(void)
{
    for (size_t i = 0; i < N_INV_CASES; ++i) {
        AlcObject o;
        AlcObject before;
        AlcHost host;
        Rec rec;
        memset(&o, 0, sizeof o);
        memset(&host, 0, sizeof host);
        memset(&rec, 0, sizeof rec);
        host.context = &rec;
        host.mark_dirty = rec_mark_dirty;
        o.active = k_inv_cases[i].active;
        o.slot = k_inv_cases[i].slot;
        memcpy(&before, &o, sizeof o);
        CK(alc_invalidate(&o, &host) == ALC_OK);
        CK(rec.calls == k_inv_cases[i].expect_call);
        if (k_inv_cases[i].expect_call) CK(rec.slot[0] == k_inv_cases[i].slot);
        CK(memcmp(&before, &o, sizeof o) == 0);
    }
}

int main(void)
{
    RUN_TEST(test_alc_invalidate_44d19d);
    return g_fail_count;
}
