/* RT-34 unit tests of the 0xd8 peephole view kernel (src/action_family_d8_runtime.c) and the 0x411b16 record builder
 * (src/action_family_44_runtime.c). Prints "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure count.
 * Fixtures are synthetic (no original bytes). tests/test_action_family_44_runtime.py builds and runs this plainly, under
 * ASan/UBSan and under source mutations. */
#include <stdio.h>
#include <string.h>

#include "action_family_44_runtime.h"
#include "action_family_d8_runtime.h"

static int g_failed;
static char g_msg[320];
#define CHECK(cond)                                                       \
    do {                                                                  \
        if (!(cond) && !g_failed) {                                       \
            g_failed = 1;                                                 \
            snprintf(g_msg, sizeof g_msg, "line %d: %s", __LINE__, #cond); \
        }                                                                 \
    } while (0)

typedef struct {
    int effects[96];
    int32_t a[96];
    int32_t b[96];
    unsigned n;
    int next_slot;
    uint32_t next_surface;
    uint32_t text_surface[6];
    int32_t text_height[6];
    uint32_t now;
    int start_flag;
    D8SceneChange change;
    unsigned changes;
    int32_t flags[8];
    unsigned releases;
    int fail_load;
} Rig;

static void observe(void *c, int effect, int32_t a, int32_t b)
{
    Rig *r = (Rig *)c;
    if (r->n < 96u) {
        r->effects[r->n] = effect;
        r->a[r->n] = a;
        r->b[r->n] = b;
        ++r->n;
    }
}
static int alloc_slot(void *c, int16_t *s) { Rig *r = (Rig *)c; *s = (int16_t)r->next_slot++; return 0; }
static int register_slot(void *c, int16_t s, uint32_t surf, const char *label) { (void)c; (void)s; (void)surf; (void)label; return 0; }
static int load_surface(void *c, const char *name, const char *label, uint32_t *surface)
{
    Rig *r = (Rig *)c;
    (void)name; (void)label;
    if (r->fail_load) return 1;
    *surface = r->next_surface++;
    return 0;
}
static int set_slot_surface(void *c, int16_t s, uint32_t surf) { (void)c; (void)s; (void)surf; return 0; }
static int release_surface(void *c, uint32_t surf) { Rig *r = (Rig *)c; (void)surf; ++r->releases; return 0; }
static int release_slot(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int mark_dirty(void *c, int16_t s) { Rig *r = (Rig *)c; observe(c, 99, s, 0); (void)r; return 0; }
static int text_surface(void *c, int index, uint32_t *surf, int32_t *height)
{
    Rig *r = (Rig *)c;
    *surf = r->text_surface[index];
    *height = r->text_height[index];
    return 0;
}
static uint32_t tick(void *c) { return ((Rig *)c)->now; }
static int set_start_flag(void *c, int32_t v) { ((Rig *)c)->start_flag = v; return 0; }
static int scene_change(void *c, const D8SceneChange *ch) { Rig *r = (Rig *)c; r->change = *ch; ++r->changes; return 0; }
static int set_event_flag(void *c, int16_t i, int32_t v) { ((Rig *)c)->flags[i] = v; return 0; }

static D8Host host_for(Rig *r)
{
    D8Host h;
    memset(&h, 0, sizeof h);
    h.context = r;
    h.alloc_slot = alloc_slot;
    h.register_slot = register_slot;
    h.load_surface = load_surface;
    h.set_slot_surface = set_slot_surface;
    h.release_surface = release_surface;
    h.release_slot = release_slot;
    h.mark_dirty = mark_dirty;
    h.text_surface = text_surface;
    h.tick = tick;
    h.set_start_flag = set_start_flag;
    h.scene_change = scene_change;
    h.set_event_flag = set_event_flag;
    h.observe = observe;
    return h;
}

static void rig_init(Rig *r)
{
    memset(r, 0, sizeof *r);
    r->next_slot = 0x18;
    r->next_surface = 100u;
    for (unsigned i = 0u; i < 6u; ++i) {
        r->text_surface[i] = 500u + i;
        r->text_height[i] = 1000 + 100 * (int32_t)i;
    }
}

static void p16(uint8_t *p, unsigned o, int v) { p[o] = (uint8_t)v; p[o + 1] = (uint8_t)(v >> 8); }
static void p32(uint8_t *p, unsigned o, int32_t v)
{
    p16(p, o, v & 0xffff);
    p16(p, o + 2u, (v >> 16) & 0xffff);
}
static void rect(uint8_t *p, unsigned o, int l, int t, int rr, int b)
{
    p32(p, o, l);
    p32(p, o + 4u, t);
    p32(p, o + 8u, rr);
    p32(p, o + 12u, b);
}

/* A built record with `links` entries. View window source (10,20)-(110,220), limits: x 0..50, y 0..500. */
static size_t make_record(uint8_t *rec, const char *name, const char *name2, int links)
{
    const size_t len = d8_record_bytes(links);
    memset(rec, 0, D8_RECORD_MAX_BYTES);
    strcpy((char *)rec, name);
    strcpy((char *)rec + 0x21, name2);
    p32(rec, 0x44, 0);
    p32(rec, 0x48, 0);
    p32(rec, 0x4c, 160);   /* x max source: 160 - 110 = 50 */
    p32(rec, 0x50, 720);   /* y max: 720 - 220 = 500 */
    rect(rec, 0x54, 10, 20, 110, 220);
    rect(rec, 0x64, 5, 6, 105, 206);
    for (int i = 0; i < 4; ++i) {
        rect(rec, 0x74u + 16u * (unsigned)i, 200 + 10 * i, 10, 205 + 10 * i, 20);
        rect(rec, 0xb4u + 16u * (unsigned)i, 1, 1, 2, 2);
        rect(rec, 0xf4u + 16u * (unsigned)i, 3, 3, 4, 4);
    }
    rec[0x134] = 20; /* 50 ms period */
    rect(rec, 0x14e, 300, 300, 310, 310);
    p16(rec, 0x15e, links);
    for (int i = 0; i < links; ++i) {
        p16(rec, 0x160u + 0x12u * (unsigned)i, 70 + i);
        rect(rec, 0x162u + 0x12u * (unsigned)i, 20 * i, 30, 20 * i + 10, 40);
    }
    return len;
}

static int count(const Rig *r, int effect)
{
    int n = 0;
    for (unsigned i = 0; i < r->n; ++i) n += r->effects[i] == effect;
    return n;
}

static void test_record_sizes(void)
{
    CHECK(d8_record_bytes(0) == 0x160u);
    CHECK(d8_record_bytes(100) == 0x868u);
    CHECK(d8_record_bytes(3) == 0x160u + 3u * 0x12u);
    CHECK(d8_record_bytes(-1) == 0u && d8_record_bytes(101) == 0u);
}

static void test_validate(void)
{
    uint8_t rec[D8_RECORD_MAX_BYTES];
    const char *why;
    size_t len = make_record(rec, "A", "", 2);
    CHECK(d8_validate_record(rec, len, &why) == D8_OK);
    CHECK(d8_validate_record(rec, len - 1u, &why) == D8_ERR_BODY);
    CHECK(d8_validate_record(rec, len + 1u, &why) == D8_ERR_BODY);
    CHECK(d8_validate_record(NULL, len, &why) == D8_ERR_BODY);
    p16(rec, 0x15e, 101);
    CHECK(d8_validate_record(rec, D8_RECORD_MAX_BYTES, &why) == D8_ERR_BODY);
    p16(rec, 0x15e, -1);
    CHECK(d8_validate_record(rec, 0x160u, &why) == D8_ERR_BODY);
    p16(rec, 0x15e, 2);
    memset(rec, 'x', 0x21);
    CHECK(d8_validate_record(rec, len, &why) == D8_ERR_BODY); /* name not terminated */
}

static void test_phase0_file_surfaces(void)
{
    Rig r;
    D8Host h;
    D8Object o;
    D8Result res;
    uint8_t rec[D8_RECORD_MAX_BYTES];
    const char *why;
    const size_t len = make_record(rec, "FIRST", "SECOND", 0);
    rig_init(&r);
    h = host_for(&r);
    d8_object_reset(&o);
    CHECK(d8_step(&o, rec, len, 7, 0, 8, &h, &res, &why) == D8_OK);
    CHECK(res.phase_after == 1u && res.initialized == 1u);
    CHECK(o.active == 1u && o.visible == 1u && o.row == 7 && o.target_scene == 9999 && o.exit_clicked == 0u);
    CHECK(r.start_flag == 1 && o.slot_a == 0x18 && o.slot_b == 0x19);
    CHECK(o.surface1 == 100u && o.surface2 == 101u && o.borrowed == 0u);
    /* limits: y max 720-220, y min 0-20, x max 160-110, x min 0-10 */
    CHECK(o.limit_4c == 500 && o.limit_4e == -20 && o.limit_48 == 50 && o.limit_4a == -10);
    /* the start position 0,0 is inside every limit except the lower ones (-20, -10), which clamp upwards? no: 0 > -20 */
    CHECK(o.pos_41 == 0 && o.pos_43 == 0);
    for (int i = 0; i < 4; ++i) CHECK(o.can_move[i] == 1u && o.inactive_rect[i] == 1u && o.down_rect[i] == 1u);
    /* a rectangle with right == left or bottom == top is empty (IsRectEmpty) */
    rig_init(&r);
    h = host_for(&r);
    d8_object_reset(&o);
    make_record(rec, "FIRST", "SECOND", 0);
    rect(rec, 0xb4, 5, 5, 5, 9);
    rect(rec, 0xf4 + 16, 5, 5, 9, 5);
    CHECK(d8_step(&o, rec, len, 7, 0, 8, &h, &res, &why) == D8_OK);
    CHECK(o.down_rect[0] == 0u && o.down_rect[1] == 1u && o.inactive_rect[1] == 0u && o.inactive_rect[0] == 1u);
    CHECK(count(&r, D8_FX_SLOT) == 2 && count(&r, D8_FX_SURFACE_LOAD) == 2);
    /* the same names ignoring case share the first surface */
    rig_init(&r);
    h = host_for(&r);
    d8_object_reset(&o);
    make_record(rec, "Same", "sAME", 0);
    CHECK(d8_step(&o, rec, len, 0, 0, 8, &h, &res, &why) == D8_OK);
    CHECK(o.surface1 == o.surface2 && count(&r, D8_FX_SURFACE_LOAD) == 1);
    /* an empty second name shares it too */
    rig_init(&r);
    h = host_for(&r);
    d8_object_reset(&o);
    make_record(rec, "Only", "", 0);
    CHECK(d8_step(&o, rec, len, 0, 0, 8, &h, &res, &why) == D8_OK);
    CHECK(o.surface1 == o.surface2 && count(&r, D8_FX_SURFACE_LOAD) == 1);
}

static void test_phase0_text_pages(void)
{
    Rig r;
    D8Host h;
    D8Object o;
    D8Result res;
    uint8_t rec[D8_RECORD_MAX_BYTES];
    const char *why;
    const size_t len = d8_record_bytes(0);
    rig_init(&r);
    h = host_for(&r);
    d8_object_reset(&o);
    make_record(rec, "USE_AUTOTEXT2", "", 0);
    CHECK(d8_step(&o, rec, len, 1, 0, 8, &h, &res, &why) == D8_OK);
    CHECK(o.surface1 == 501u && o.borrowed == 1u && o.limit_4c == 1100 - 220);
    CHECK(count(&r, D8_FX_SURFACE_LOAD) == 0);
    /* USE_LISTPAGE<n> is writer table entry 2 + n */
    rig_init(&r);
    h = host_for(&r);
    d8_object_reset(&o);
    make_record(rec, "USE_LISTPAGE3", "", 0);
    CHECK(d8_step(&o, rec, len, 1, 0, 8, &h, &res, &why) == D8_OK);
    CHECK(o.surface1 == 505u && o.limit_4c == 1500 - 220);
    /* a page outside the six writer surfaces is refused before any effect */
    rig_init(&r);
    h = host_for(&r);
    d8_object_reset(&o);
    make_record(rec, "USE_LISTPAGE4", "", 0);
    CHECK(d8_step(&o, rec, len, 1, 0, 8, &h, &res, &why) == D8_ERR_BODY);
    CHECK(r.n == 0u && o.active == 0u && r.start_flag == 0);
    /* near misses are file names, not text pages */
    rig_init(&r);
    h = host_for(&r);
    d8_object_reset(&o);
    make_record(rec, "USE_AUTOTEXT4", "", 0);
    CHECK(d8_step(&o, rec, len, 1, 0, 8, &h, &res, &why) == D8_OK && count(&r, D8_FX_SURFACE_LOAD) == 1);
}

static void test_scroll(void)
{
    Rig r;
    D8Host h;
    D8Object o;
    D8Result res;
    uint8_t rec[D8_RECORD_MAX_BYTES];
    const char *why;
    const size_t len = make_record(rec, "A", "", 0);
    rig_init(&r);
    h = host_for(&r);
    d8_object_reset(&o);
    CHECK(d8_step(&o, rec, len, 0, 0, 8, &h, &res, &why) == D8_OK);
    r.now = 1000u;
    CHECK(d8_hit_test(&o, rec, len, 201, 15, &(D8HitInput){-1, 0, 0, 0, 0}, &(D8HitOutput){0}) == D8_OK);
    CHECK(o.hot == 0);
    CHECK(d8_press(&o, 1u, D8_CAND_BUTTON, &h) == D8_OK && o.dir == 0u && o.pressed == 1u && o.tick == 1000u);
    /* 40 ms is below the 50 ms period: nothing moves */
    r.now = 1040u;
    CHECK(d8_step(&o, rec, len, 0, 1, 8, &h, &res, &why) == D8_OK && o.pos_43 == 0 && o.tick == 1000u);
    /* 130 ms is two periods up (button 0 scrolls toward the lower limit -20) */
    r.now = 1130u;
    CHECK(d8_step(&o, rec, len, 0, 1, 8, &h, &res, &why) == D8_OK && o.pos_43 == -2 && o.tick == 1130u && o.can_move[1] == 1u);
    /* a long hold reaches the limit: clamp, direction cleared, side flag cleared */
    r.now = 1130u + 50u * 100u;
    CHECK(d8_step(&o, rec, len, 0, 1, 8, &h, &res, &why) == D8_OK);
    CHECK(o.pos_43 == -20 && o.dir == 0xffu && o.can_move[0] == 0u);
    /* phase 1 with a zero frame rate is a native safety rejection and changes nothing */
    rec[0x134] = 0;
    r.now += 100u;
    CHECK(d8_step(&o, rec, len, 0, 1, 8, &h, &res, &why) == D8_ERR_BODY && o.tick == 1130u + 5000u);
    /* an idle direction only advances the tick */
    rec[0x134] = 20;
    o.dir = 0xffu;
    r.now += 500u;
    CHECK(d8_step(&o, rec, len, 0, 1, 8, &h, &res, &why) == D8_OK && o.tick == r.now && o.pos_43 == -20);
}

static void test_finish(void)
{
    Rig r;
    D8Host h;
    D8Object o;
    D8Result res;
    uint8_t rec[D8_RECORD_MAX_BYTES];
    const char *why;
    const size_t len = make_record(rec, "A", "B", 2);
    rig_init(&r);
    h = host_for(&r);
    d8_object_reset(&o);
    CHECK(d8_step(&o, rec, len, 3, 0, 8, &h, &res, &why) == D8_OK);
    /* a link click: scene = the entry word, cells 0,0,1 / 0,0,1, row phase 2 */
    {
        D8HitOutput out;
        D8ClickOutput click;
        D8HitInput in = {-1, 0, 0, 0, 0};
        /* link rectangles are relative to the destination window origin (5,6): this point is inside the raw rect only */
        CHECK(d8_hit_test(&o, rec, len, 30, 33, &in, &out) == D8_OK && out.hit == 0u && o.hot == -1);
        CHECK(d8_hit_test(&o, rec, len, 17, 41, &in, &out) == D8_OK && out.hit == 0u);
        CHECK(d8_hit_test(&o, rec, len, 30, 41, &in, &out) == D8_OK && out.hit == 1u && out.candidate_5c39e5 == D8_CAND_LINK && o.hot == 1);
        CHECK(out.table_5d1631 == 0x5b160cu + 0x10u && out.cursor_5b44f0 == 0);
        CHECK(d8_click(&o, rec, len, D8_CAND_LINK, &click) == D8_OK && click.phase_written == 1u && click.phase == 2u);
        CHECK(o.target_scene == 71 && o.dir == 0xffu && o.pressed == 0u);
    }
    r.n = 0u;
    CHECK(d8_step(&o, rec, len, 3, 2, 8, &h, &res, &why) == D8_OK);
    CHECK(res.finished == 1u && res.phase_after == 0u && r.changes == 1u);
    CHECK(r.change.scene == 71 && r.change.word[0] == 0 && r.change.word[1] == 0 && r.change.word[2] == 1 &&
          r.change.dword[0] == 0 && r.change.dword[1] == 0 && r.change.dword[2] == 1);
    CHECK(o.active == 0u && o.row == -1 && o.surface1 == 0u && o.surface2 == 0u && o.slot_a == -1);
    CHECK(count(&r, D8_FX_COMPLETE) == 1 && count(&r, D8_FX_RELEASE_SLOT) == 2 && r.releases == 2u);
    CHECK(count(&r, D8_FX_ENGINE_MODE) == 1);
    /* the exit rect: event flag, scene words from the record, start flag from word +0x149 */
    rig_init(&r);
    h = host_for(&r);
    d8_object_reset(&o);
    p16(rec, 0x135, 12);
    p16(rec, 0x137, 1);
    p16(rec, 0x139, 2);
    p16(rec, 0x13b, 3);
    p32(rec, 0x13d, 4);
    p32(rec, 0x141, 5);
    p32(rec, 0x145, 6);
    p16(rec, 0x149, 1);
    p16(rec, 0x14b, 5);
    rec[0x14d] = 200;
    CHECK(d8_step(&o, rec, len, 0, 0, 8, &h, &res, &why) == D8_OK);
    {
        D8HitOutput out;
        D8ClickOutput click;
        D8HitInput in = {-1, 0, 7, 0, 0};
        CHECK(d8_hit_test(&o, rec, len, 305, 305, &in, &out) == D8_OK && out.candidate_5c39e5 == D8_CAND_EXIT);
        CHECK(out.cursor_5b44f0 == 9 && out.value_5d162d == 7 && out.table_5d1631 == 0x5b160cu + 9u * 0x20u + 0x10u);
        CHECK(d8_click(&o, rec, len, D8_CAND_EXIT, &click) == D8_OK && o.exit_clicked == 1u);
    }
    CHECK(d8_step(&o, rec, len, 0, 2, 8, &h, &res, &why) == D8_OK);
    CHECK(r.change.scene == 12 && r.change.word[2] == 3 && r.change.dword[1] == 5 && r.flags[5] == 200 && r.start_flag == 0);
    /* an exit event flag index outside the table is refused before any effect */
    rig_init(&r);
    h = host_for(&r);
    d8_object_reset(&o);
    CHECK(d8_step(&o, rec, len, 0, 0, 8, &h, &res, &why) == D8_OK);
    o.exit_clicked = 1u;
    r.n = 0u;
    CHECK(d8_step(&o, rec, len, 0, 2, 4, &h, &res, &why) == D8_ERR_BODY && r.n == 0u && o.active == 1u);
}

static void test_cleanup_rules(void)
{
    Rig r;
    D8Host h;
    D8Object o;
    D8Result res;
    uint8_t rec[D8_RECORD_MAX_BYTES];
    const char *why;
    const size_t len = make_record(rec, "USE_AUTOTEXT1", "", 0);
    rig_init(&r);
    h = host_for(&r);
    d8_object_reset(&o);
    CHECK(d8_step(&o, rec, len, 0, 0, 8, &h, &res, &why) == D8_OK && o.borrowed == 1u);
    /* the borrowed text surface is never released and the equal second surface is skipped */
    CHECK(d8_cleanup(&o, &h) == D8_OK);
    CHECK(r.releases == 0u && o.surface1 == 0u && o.surface2 == 0u && o.slot_a == -1 && o.slot_b == -1 && o.dir == 0xffu);
    /* a second phase-0 visit with a surface already set keeps it and the clamps still run */
    make_record(rec, "A", "B", 0);
    rig_init(&r);
    h = host_for(&r);
    d8_object_reset(&o);
    CHECK(d8_step(&o, rec, len, 0, 0, 8, &h, &res, &why) == D8_OK);
    r.n = 0u;
    CHECK(d8_step(&o, rec, len, 1, 0, 8, &h, &res, &why) == D8_OK);
    CHECK(count(&r, D8_FX_SURFACE_LOAD) == 0 && o.row == 1);
    /* cleanup releases the second surface (differs) and the first (owned) */
    r.releases = 0u;
    CHECK(d8_cleanup(&o, &h) == D8_OK && r.releases == 2u);
}

static void test_hit_cursor(void)
{
    Rig r;
    D8Host h;
    D8Object o;
    D8Result res;
    D8HitOutput out;
    uint8_t rec[D8_RECORD_MAX_BYTES];
    const char *why;
    const size_t len = make_record(rec, "A", "", 0);
    rig_init(&r);
    h = host_for(&r);
    d8_object_reset(&o);
    /* an inactive object never hits */
    CHECK(d8_hit_test(&o, NULL, 0u, 1, 1, &(D8HitInput){0}, &out) == D8_OK && out.hit == 0u);
    CHECK(d8_step(&o, rec, len, 0, 0, 8, &h, &res, &why) == D8_OK);
    /* button 2 with a selected item: cursor = item + 0x25, 0x5d162d from 0x571ad3 */
    CHECK(d8_hit_test(&o, rec, len, 222, 12, &(D8HitInput){3, 0, 9, 77, 5}, &out) == D8_OK);
    CHECK(out.hit == 1u && o.hot == 2 && out.cursor_5b44f0 == 0x28 && out.value_5d162d == 77 && out.candidate_5c39e5 == D8_CAND_BUTTON);
    CHECK(out.table_5d1631 == 0x5b160cu + 0x28u * 0x20u + 0x10u);
    /* no item and no flag: cursor 0; flag set: the cursor is left alone and the table uses its current value */
    CHECK(d8_hit_test(&o, rec, len, 222, 12, &(D8HitInput){-1, 0, 9, 77, 5}, &out) == D8_OK && out.cursor_written == 1u && out.cursor_5b44f0 == 0);
    CHECK(d8_hit_test(&o, rec, len, 222, 12, &(D8HitInput){3, 1, 9, 77, 5}, &out) == D8_OK && out.cursor_written == 0u &&
          out.table_5d1631 == 0x5b160cu + 5u * 0x20u + 0x10u);
    /* a miss leaves hot at -1 */
    CHECK(d8_hit_test(&o, rec, len, 0, 0, &(D8HitInput){-1, 0, 9, 77, 5}, &out) == D8_OK && out.hit == 0u && o.hot == -1);
    /* press needs the button flag, phase 1 and the button candidate */
    o.hot = 1;
    o.can_move[1] = 0u;
    CHECK(d8_press(&o, 1u, D8_CAND_BUTTON, &h) == D8_OK && o.pressed == 0u);
    o.can_move[1] = 1u;
    CHECK(d8_press(&o, 0u, D8_CAND_BUTTON, &h) == D8_OK && o.pressed == 0u);
    CHECK(d8_press(&o, 1u, D8_CAND_LINK, &h) == D8_OK && o.pressed == 0u);
    CHECK(d8_press(&o, 1u, D8_CAND_BUTTON, &h) == D8_OK && o.pressed == 1u && o.dir == 1u);
}

static void test_render(void)
{
    Rig r;
    D8Host h;
    D8Object o;
    D8Result res;
    D8RenderPlan plan;
    D8View view = {50, 60};
    uint8_t rec[D8_RECORD_MAX_BYTES];
    const char *why;
    const size_t len = make_record(rec, "A", "", 0);
    rig_init(&r);
    h = host_for(&r);
    d8_object_reset(&o);
    CHECK(d8_render_plan(&o, NULL, 0u, &view, &plan) == D8_OK && plan.valid == 0u);
    CHECK(d8_step(&o, rec, len, 0, 0, 8, &h, &res, &why) == D8_OK);
    o.pos_41 = 3;
    o.pos_43 = 7;
    CHECK(d8_render_plan(&o, rec, len, &view, &plan) == D8_OK && plan.valid == 1u && plan.count == 5u);
    CHECK(plan.blit[0].kind == D8_BLIT_COPY && plan.blit[0].source == D8_SRC_SLOT_A);
    CHECK(plan.blit[0].src[0] == 13 && plan.blit[0].src[1] == 27 && plan.blit[0].src[2] == 113 && plan.blit[0].src[3] == 227);
    CHECK(plan.blit[0].dst[0] == 55 && plan.blit[0].dst[1] == 66 && plan.blit[0].dst[2] == 155 && plan.blit[0].dst[3] == 266);
    /* all four buttons movable and idle: refresh copies from the saved frame */
    for (unsigned i = 1u; i < 5u; ++i) CHECK(plan.blit[i].kind == D8_BLIT_COPY && plan.blit[i].source == D8_SRC_SAVED_FRAME);
    /* mode 2 adds the restore copy first; an unmovable button draws its inactive image; the held one its down image */
    rec[0x42] = 2;
    o.can_move[1] = 0u;
    o.pressed = 1u;
    o.dir = 2u;
    CHECK(d8_render_plan(&o, rec, len, &view, &plan) == D8_OK && plan.count == 6u);
    CHECK(plan.blit[0].source == D8_SRC_SAVED_FRAME && plan.blit[1].kind == D8_BLIT_TRANS && plan.blit[1].source == D8_SRC_SLOT_A);
    CHECK(plan.blit[3].kind == D8_BLIT_TRANS && plan.blit[3].source == D8_SRC_SLOT_B && plan.blit[3].src[0] == 3);
    CHECK(plan.blit[4].kind == D8_BLIT_TRANS && plan.blit[4].src[0] == 1);
    CHECK(plan.blit[2].kind == D8_BLIT_COPY);
}

static void test_dirty_and_host_failure(void)
{
    Rig r;
    D8Host h;
    D8Object o;
    D8Result res;
    uint8_t rec[D8_RECORD_MAX_BYTES];
    const char *why;
    const size_t len = make_record(rec, "A", "", 0);
    rig_init(&r);
    h = host_for(&r);
    d8_object_reset(&o);
    CHECK(d8_mark_dirty(&o, &h) == D8_OK && r.n == 0u);
    CHECK(d8_step(&o, rec, len, 0, 0, 8, &h, &res, &why) == D8_OK);
    r.n = 0u;
    CHECK(d8_mark_dirty(&o, &h) == D8_OK && count(&r, 99) == 2);
    /* a failed surface load stops the visit with a host error */
    rig_init(&r);
    h = host_for(&r);
    d8_object_reset(&o);
    r.fail_load = 1;
    CHECK(d8_step(&o, rec, len, 0, 0, 8, &h, &res, &why) == D8_ERR_HOST);
    /* missing callbacks are refused before any effect */
    rig_init(&r);
    h = host_for(&r);
    h.alloc_slot = NULL;
    d8_object_reset(&o);
    CHECK(d8_step(&o, rec, len, 0, 0, 8, &h, &res, &why) == D8_ERR_UNSUPPORTED && r.n == 0u && o.active == 0u);
}

/* ---- the 0x411b16 record builder ---- */

static void make_object(uint8_t *obj, size_t *len)
{
    memset(obj, 0, 0x240);
    p16(obj, 0, 0x0102);
    p16(obj, 2, 7); /* name page = 7 - 2 */
    p16(obj, 0xc, -3);
    p16(obj, 0xe, 300);
    strcpy((char *)obj + 0xea, "OVERLAY");
    for (unsigned i = 0u; i < 16u; ++i) obj[0x10bu + i] = (uint8_t)(0x10 + i);
    for (unsigned i = 0u; i < 16u; ++i) obj[0x11bu + i] = (uint8_t)(0x30 + i);
    for (unsigned i = 0u; i < 64u; ++i) {
        obj[0x12bu + i] = (uint8_t)i;
        obj[0x16bu + i] = (uint8_t)(0x40 + i);
        obj[0x1abu + i] = (uint8_t)(0x80 + i);
    }
    obj[0x1eb] = 24;
    strcpy((char *)obj + 0x210, "text");
    *len = 0x210u + 5u;
}

static void test_builder(void)
{
    uint8_t obj[0x240];
    uint8_t rec[D8_RECORD_MAX_BYTES];
    A44TextResult text;
    size_t olen, rlen = 0u;
    make_object(obj, &olen);
    memset(&text, 0, sizeof text);
    CHECK(a44_build_record(obj, olen, &text, rec, sizeof rec, &rlen) == A44_OK && rlen == 0x160u);
    CHECK(memcmp(rec, "USE_LISTPAGE5", 14) == 0 && strcmp((char *)rec + 0x21, "OVERLAY") == 0);
    CHECK(rec[0x42] == 0x02 && rec[0x43] == 0x01);
    CHECK(rec[0x4c] == 0xfd && rec[0x4d] == 0xff && rec[0x4e] == 0xff && rec[0x4f] == 0xff); /* sign-extended -3 */
    CHECK(rec[0x50] == 0x2c && rec[0x51] == 0x01 && rec[0x52] == 0 && rec[0x53] == 0);
    CHECK(rec[0x54] == 0x10 && rec[0x63] == 0x1f && rec[0x64] == 0x30 && rec[0x73] == 0x3f);
    CHECK(rec[0x74] == 0 && rec[0xb3] == 63 && rec[0xb4] == 0x40 && rec[0xf3] == 0x40 + 63 && rec[0xf4] == 0x80 && rec[0x133] == 0x80 + 63);
    CHECK(rec[0x134] == 24 && rec[0x15e] == 0 && rec[0x15f] == 0);
    /* link entries: values 0x270f are skipped, the rest keep order */
    text.has_links = 1u;
    text.link_count = 4;
    text.link_value[0] = 11;
    text.link_value[1] = 9999;
    text.link_value[2] = 33;
    text.link_value[3] = -4;
    for (unsigned i = 0u; i < 4u; ++i) memset(text.link_rect[i], (int)(0xa0 + i), 16u);
    CHECK(a44_build_record(obj, olen, &text, rec, sizeof rec, &rlen) == A44_OK && rlen == 0x160u + 3u * 0x12u);
    CHECK(rec[0x15e] == 3 && rec[0x160] == 11 && rec[0x162] == 0xa0 && rec[0x160 + 0x12] == 33 && rec[0x162 + 0x12] == 0xa2);
    CHECK(rec[0x160 + 0x24] == 0xfc && rec[0x161 + 0x24] == 0xff && rec[0x162 + 0x24] == 0xa3);
    /* flag clear: the table is ignored */
    text.has_links = 0u;
    CHECK(a44_build_record(obj, olen, &text, rec, sizeof rec, &rlen) == A44_OK && rlen == 0x160u);
    /* a negative count adds no entry */
    text.has_links = 1u;
    text.link_count = -5;
    CHECK(a44_build_record(obj, olen, &text, rec, sizeof rec, &rlen) == A44_OK && rlen == 0x160u);
    /* more than 100 accepted entries is refused (the original overflows its buffer) and writes nothing */
    text.link_count = 101;
    for (unsigned i = 0u; i < 101u; ++i) text.link_value[i] = (int16_t)i;
    memset(rec, 0x5a, sizeof rec);
    CHECK(a44_build_record(obj, olen, &text, rec, sizeof rec, &rlen) == A44_ERR_BOUNDS && rec[0] == 0x5a);
    text.link_count = 401;
    CHECK(a44_build_record(obj, olen, &text, rec, sizeof rec, &rlen) == A44_ERR_BOUNDS);
    text.link_count = 0;
    /* short object and unterminated second name */
    CHECK(a44_build_record(obj, 0x210u, &text, rec, sizeof rec, &rlen) == A44_ERR_BODY);
    memset(obj + 0xea, 'x', 0x21);
    CHECK(a44_build_record(obj, olen, &text, rec, sizeof rec, &rlen) == A44_ERR_BODY);
    CHECK(a44_record_length(obj, olen, &text) == 0u);
    /* negative page word: itoa of a negative number */
    make_object(obj, &olen);
    p16(obj, 2, 0);
    CHECK(a44_build_record(obj, olen, &text, rec, sizeof rec, &rlen) == A44_OK && strcmp((char *)rec, "USE_LISTPAGE-2") == 0);
}

typedef void (*Test)(void);
static void run(const char *name, Test test)
{
    g_failed = 0;
    g_msg[0] = '\0';
    test();
    if (g_failed) printf("FAIL %s: %s\n", name, g_msg);
    else printf("PASS %s\n", name);
}

int main(void)
{
    static const struct { const char *name; Test fn; } tests[] = {
        {"record_sizes", test_record_sizes},
        {"validate", test_validate},
        {"phase0_file_surfaces", test_phase0_file_surfaces},
        {"phase0_text_pages", test_phase0_text_pages},
        {"scroll", test_scroll},
        {"finish", test_finish},
        {"cleanup_rules", test_cleanup_rules},
        {"hit_cursor", test_hit_cursor},
        {"render", test_render},
        {"dirty_and_host_failure", test_dirty_and_host_failure},
        {"builder", test_builder},
    };
    int failures = 0;
    for (size_t i = 0; i < sizeof tests / sizeof tests[0]; ++i) {
        g_failed = 0;
        run(tests[i].name, tests[i].fn);
        failures += g_failed;
    }
    return failures;
}
