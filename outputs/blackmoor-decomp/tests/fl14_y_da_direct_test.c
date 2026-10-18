/* FL-14 direct tests of the raw 0xda Bul puzzle kernel (src/action_family_da_runtime.c): the static real_name (original
 * 0x45be3f) and bul_invalidate (original 0x45b477). Expected values are derived by hand from the original pseudocode:
 *   0x45be3f(name): compare 9 bytes with "NO SOUND\0" (repe cmpsb); equal -> 0; otherwise 1 when the string is not empty
 *                   (strlen != 0), 0 for an empty string.
 *   0x45b477: if dword this+0x166 != 0 and word this+0x1c != -1: entry[slot].+0x14 := 1 (native: host mark_dirty(slot)). */
#include "../src/action_family_da_runtime.c"

#include "fl14_y_common.h"

static void test_real_name_45be3f(void)
{
    struct {
        uint8_t name[16];
        int expect;
    } c[] = {
        {{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0, 'X', 'Y'}, 0},   /* exactly "NO SOUND": 9 bytes equal -> 0 (bytes after the NUL ignored) */
        {{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}, 0},
        {{0}, 0},                                                      /* empty -> strlen 0 -> 0 */
        {{0, 'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}, 0},           /* empty even when "NO SOUND" follows the NUL */
        {{'A', 0}, 1},
        {{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'E', 0}, 1},              /* last letter differs */
        {{'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', '!', 0}, 1},         /* 9th byte nonzero (differs from the NUL) */
        {{'N', 'O', ' ', 'S', 'O', 'U', 'N', 0}, 1},                   /* shorter prefix: mismatch at the NUL, strlen 7 */
        {{'n', 'o', ' ', 's', 'o', 'u', 'n', 'd', 0}, 1},              /* case sensitive */
        {{'X', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0}, 1},              /* first letter differs */
        {{'N', 'O', '_', 'S', 'O', 'U', 'N', 'D', 0}, 1},
        {{'1', '.', 'w', 'a', 'v', 0}, 1},
    };
    for (size_t i = 0; i < sizeof c / sizeof c[0]; ++i) CK(real_name(c[i].name) == c[i].expect);
}

static int stub_alloc_slot(void *c, int16_t *s) { (void)c; (void)s; return 0; }
static int stub_register_slot(void *c, int16_t s, int32_t t, int cb, uint32_t sf, const char *l)
{
    (void)c; (void)s; (void)t; (void)cb; (void)sf; (void)l;
    return 0;
}
static int stub_load_surface(void *c, const char *n, uint32_t *s) { (void)c; (void)n; (void)s; return 0; }
static int stub_set_slot_surface(void *c, int16_t s, uint32_t sf) { (void)c; (void)s; (void)sf; return 0; }
static int stub_release_surface(void *c, uint32_t s) { (void)c; (void)s; return 0; }
static int stub_release_slot(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int stub_view_origin(void *c, int32_t *x, int32_t *y) { (void)c; (void)x; (void)y; return 0; }
static int stub_clear_item(void *c) { (void)c; return 0; }
static int stub_sound_name(void *c, const uint8_t *n) { (void)c; (void)n; return 0; }
static int stub_sound_busy(void *c, int16_t ch) { (void)c; (void)ch; return 0; }
static int stub_sound_play(void *c, int16_t ch) { (void)c; (void)ch; return 0; }
static const char *stub_caption_text(void *c, const char *n) { (void)c; (void)n; return NULL; }
static int stub_caption_show(void *c, const char *t) { (void)c; (void)t; return 0; }
static uint32_t stub_tick(void *c) { (void)c; return 0; }
static int32_t stub_random(void *c) { (void)c; return 0; }
static int stub_flag_invalid(void *c, int16_t i) { (void)c; (void)i; return 0; }
static int stub_transition(void *c, const BulTransition *r) { (void)c; (void)r; return 0; }
static int stub_store_flag(void *c, int16_t i, uint32_t v) { (void)c; (void)i; (void)v; return 0; }
static int stub_engine_mode(void *c, int32_t m) { (void)c; (void)m; return 0; }

static void test_bul_invalidate_45b477(void)
{
    for (size_t i = 0; i < N_INV_CASES; ++i) {
        BulObject o;
        BulObject before;
        BulHost host;
        Rec rec;
        memset(&o, 0, sizeof o);
        memset(&host, 0, sizeof host);
        memset(&rec, 0, sizeof rec);
        host.context = &rec;
        host.alloc_slot = stub_alloc_slot;
        host.register_slot = stub_register_slot;
        host.load_surface = stub_load_surface;
        host.set_slot_surface = stub_set_slot_surface;
        host.release_surface = stub_release_surface;
        host.release_slot = stub_release_slot;
        host.mark_dirty = rec_mark_dirty;
        host.view_origin = stub_view_origin;
        host.clear_pending_item = stub_clear_item;
        host.sound_prepare = stub_sound_name;
        host.sound_stop = stub_sound_name;
        host.sound_busy = stub_sound_busy;
        host.sound_play = stub_sound_play;
        host.caption_text = stub_caption_text;
        host.caption_show = stub_caption_show;
        host.tick = stub_tick;
        host.random = stub_random;
        host.event_flag_invalid = stub_flag_invalid;
        host.transition = stub_transition;
        host.store_event_flag = stub_store_flag;
        host.engine_mode = stub_engine_mode;
        o.active = k_inv_cases[i].active;
        o.slot = k_inv_cases[i].slot;
        memcpy(&before, &o, sizeof o);
        CK(bul_invalidate(&o, &host) == BUL_OK);
        CK(rec.calls == k_inv_cases[i].expect_call);
        if (k_inv_cases[i].expect_call) CK(rec.slot[0] == k_inv_cases[i].slot);
        CK(memcmp(&before, &o, sizeof o) == 0); /* the original only writes the z entry */
    }
}

int main(void)
{
    RUN_TEST(test_real_name_45be3f);
    RUN_TEST(test_bul_invalidate_45b477);
    return g_fail_count;
}
