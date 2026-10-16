/* RT-24 unit tests of the raw 0xd9 Mouselight puzzle kernel
 * (src/action_family_d9_runtime.c). Prints "PASS <name>" / "FAIL <name>: <message>";
 * the exit status is the failure count. Fixtures are synthetic bodies (no original
 * bytes). tests/test_action_family_d9_runtime.py builds and runs this with and without
 * ASan/UBSan and under source mutations. */
#include <math.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_d9_runtime.h"

static const char *g_name;
static int g_failed, g_total;
static char g_msg[256];
#define CHECK(cond)                                                       \
    do {                                                                  \
        if (!(cond) && !g_failed) {                                       \
            g_failed = 1;                                                 \
            snprintf(g_msg, sizeof g_msg, "line %d: %s", __LINE__, #cond); \
        }                                                                 \
    } while (0)
#define CHECK_LOG(fx, expected)                                                       \
    do {                                                                              \
        if (strcmp((fx)->log, (expected)) != 0 && !g_failed) {                        \
            g_failed = 1;                                                             \
            snprintf(g_msg, sizeof g_msg, "line %d: log \"%.90s\" != \"%.90s\"", __LINE__, \
                     (fx)->log, (expected));                                          \
        }                                                                             \
    } while (0)

typedef struct Fx {
    D9Object obj;
    D9World world;
    D9Host host;
    D9View view;
    char log[1024];
    int fail_alloc_slot, fail_register, fail_load, fail_set_surface, fail_release_surface;
    int next_slot;
    uint32_t next_surface;
    uint8_t body[D9_BODY_BYTES];
} Fx;

static void logf_(Fx *f, const char *fmt, ...)
{
    char tmp[96];
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(tmp, sizeof tmp, fmt, ap);
    va_end(ap);
    if (f->log[0] != '\0') strncat(f->log, ",", sizeof f->log - strlen(f->log) - 1u);
    strncat(f->log, tmp, sizeof f->log - strlen(f->log) - 1u);
}

static void observe(void *c, int e, int32_t a, int32_t b)
{
    Fx *f = c;
    static const char *const names[] = {"?", "track", "start", "alloc", "slot", "reg", "load",
                                        "slotsurf", "phase", "relsurf", "relslot", "free"};
    logf_(f, "%s:%d:%d", names[e], a, b);
}
static int alloc_slot(void *c, int16_t *slot)
{
    Fx *f = c;
    if (f->fail_alloc_slot) return 1;
    *slot = (int16_t)f->next_slot;
    return 0;
}
static int register_slot(void *c, int16_t slot, uint32_t surface, const char *label)
{
    Fx *f = c;
    (void)slot;
    (void)surface;
    return f->fail_register || strcmp(label, "MOUSELIGHT PUZZLE BITMAP") != 0;
}
static int load_surface(void *c, const char *name, uint32_t *surface)
{
    Fx *f = c;
    if (f->fail_load || strcmp(name, "PUZZLE") != 0) return 1;
    *surface = f->next_surface;
    return 0;
}
static int set_slot_surface(void *c, int16_t slot, uint32_t surface)
{
    Fx *f = c;
    (void)slot;
    (void)surface;
    return f->fail_set_surface;
}
static int release_surface(void *c, uint32_t surface)
{
    Fx *f = c;
    (void)surface;
    return f->fail_release_surface;
}
static int release_slot(void *c, int16_t slot) { (void)c; (void)slot; return 0; }
static int mark_dirty(void *c, int16_t slot) { Fx *f = c; logf_(f, "dirty:%d", slot); return 0; }
static int view(void *c, D9View *out) { *out = ((Fx *)c)->view; return 0; }

static void fx_init(Fx *f, uint8_t radius, uint8_t mode)
{
    memset(f, 0, sizeof *f);
    d9_object_reset(&f->obj);
    f->host.context = f;
    f->host.alloc_slot = alloc_slot;
    f->host.register_slot = register_slot;
    f->host.load_surface = load_surface;
    f->host.set_slot_surface = set_slot_surface;
    f->host.release_surface = release_surface;
    f->host.release_slot = release_slot;
    f->host.mark_dirty = mark_dirty;
    f->host.view = view;
    f->host.observe = observe;
    f->view = (D9View){10, 20, 20 + 340, 600, 400};
    f->next_slot = 0x18;
    f->next_surface = 77u;
    strcpy((char *)f->body, "PUZZLE");
    f->body[0x21] = radius;
    f->body[0x22] = mode;
}

static int step(Fx *f, uint32_t phase)
{
    D9Result r;
    const char *why = NULL;
    return d9_step(&f->obj, f->body, D9_BODY_BYTES, 4, phase, &f->world, &f->host, &r, &why);
}

static void free_obj(Fx *f)
{
    free(f->obj.composite);
    free(f->obj.alpha);
    free(f->obj.mask);
    f->obj.composite = NULL;
    f->obj.alpha = NULL;
    f->obj.mask = NULL;
}

/* ---- tests ---- */
static void t_validate_body(void)
{
    uint8_t body[D9_BODY_BYTES] = {'A'};
    const char *why = NULL;
    body[0x21] = 5;
    CHECK(d9_validate_body(body, D9_BODY_BYTES, &why) == D9_OK);
    CHECK(d9_validate_body(body, D9_BODY_BYTES - 1u, &why) == D9_ERR_BODY);
    CHECK(d9_validate_body(NULL, D9_BODY_BYTES, &why) == D9_ERR_BODY);
    body[0x21] = 0;
    CHECK(d9_validate_body(body, D9_BODY_BYTES, &why) == D9_ERR_BODY);
    body[0x21] = 5;
    memset(body, 'A', D9_NAME_BYTES); /* no terminator inside the name field */
    CHECK(d9_validate_body(body, D9_BODY_BYTES, &why) == D9_ERR_BODY);
}

static void t_alpha_values(void)
{
    /* 0x47d9b5..0x47da9d: exp(-(d2^2) / (r^4 / 2)) inside the radius, 0 outside. */
    CHECK(d9_alpha_at(150, 0, 0) == 1.0f);
    CHECK(fabsf(d9_alpha_at(150, 100, 0) - (float)exp(-1e8 / 253125000.0)) < 1e-7f);
    CHECK(d9_alpha_at(150, 150, 0) == 0.0f);  /* d == r is outside (d < r only) */
    CHECK(d9_alpha_at(150, 149, 0) > 0.0f);
    CHECK(fabsf(d9_alpha_at(150, 106, 106) - (float)exp(-2.0 * pow(sqrt(22472.0) / 150.0, 4.0))) < 1e-6f); /* just inside */
}

static void t_phase0_effects_and_buffers(void)
{
    Fx f;
    fx_init(&f, 3, 1);
    CHECK(step(&f, 0) == D9_OK);
    CHECK_LOG(&f, "track:1:0,start:1:0,alloc:144:0,alloc:144:1,slot:24:0,reg:24:0,load:77:0,slotsurf:77:0,phase:1:0");
    CHECK(f.world.start_flag_5bb1ca == 1);
    CHECK(f.obj.tracking == 1 && f.obj.active == 1 && f.obj.row == 4 && f.obj.radius == 3);
    CHECK(f.obj.slot == 0x18 && f.obj.surface == 77u && f.obj.mask == NULL);
    CHECK(f.obj.composite != NULL && f.obj.alpha != NULL);
    /* 6x6 map, index (r+dy)*2r + (r+dx); centre cell (dx=dy=0) is 1.0, the far corner 0. */
    CHECK(f.obj.alpha[3 * 6 + 3] == 1.0f);
    CHECK(f.obj.alpha[0] == 0.0f);
    CHECK(f.obj.alpha[3 * 6 + 5] == d9_alpha_at(3, 0, 2));
    free_obj(&f);
}

static void t_phase0_mask(void)
{
    Fx f;
    int inside = 0;
    fx_init(&f, 4, 0);
    CHECK(step(&f, 0) == D9_OK);
    CHECK_LOG(&f, "track:1:0,start:1:0,alloc:256:0,alloc:64:2,slot:24:0,reg:24:0,load:77:0,slotsurf:77:0,phase:1:0");
    CHECK(f.obj.alpha == NULL && f.obj.mask != NULL);
    for (int y = -4; y < 4; ++y)
        for (int x = -4; x < 4; ++x) {
            const int want = (x * x + y * y) < 16 ? 1 : 0; /* sqrt(d2) < r  <=>  d2 < r^2 */
            CHECK(f.obj.mask[(4 + y) * 8 + (4 + x)] == want);
            inside += want;
        }
    CHECK(inside == 45); /* lattice points with x^2 + y^2 < 16 in -4..3 */
    free_obj(&f);
}

static void t_surface_reuse_and_host_failures(void)
{
    Fx f;
    fx_init(&f, 2, 1);
    f.obj.surface = 5u; /* already loaded: no load call, the entry gets the old handle */
    CHECK(step(&f, 0) == D9_OK);
    CHECK_LOG(&f, "track:1:0,start:1:0,alloc:64:0,alloc:64:1,slot:24:0,reg:24:5,slotsurf:5:0,phase:1:0");
    free_obj(&f);
    fx_init(&f, 2, 1);
    f.fail_alloc_slot = 1;
    CHECK(step(&f, 0) == D9_ERR_HOST);
    free_obj(&f);
    fx_init(&f, 2, 1);
    f.fail_load = 1;
    CHECK(step(&f, 0) == D9_ERR_HOST);
    CHECK(f.obj.surface == 0u);
    free_obj(&f);
    fx_init(&f, 2, 1);
    f.fail_register = 1;
    CHECK(step(&f, 0) == D9_ERR_HOST);
    free_obj(&f);
    fx_init(&f, 2, 1);
    f.fail_set_surface = 1;
    CHECK(step(&f, 0) == D9_ERR_HOST);
    free_obj(&f);
}

static void t_rejections_change_nothing(void)
{
    Fx f, ref;
    D9Result r;
    const char *why = NULL;
    fx_init(&f, 0, 1); /* zero radius */
    ref = f;
    CHECK(d9_step(&f.obj, f.body, D9_BODY_BYTES, 1, 0, &f.world, &f.host, &r, &why) == D9_ERR_BODY);
    CHECK(memcmp(&f.obj, &ref.obj, sizeof f.obj) == 0 && f.log[0] == '\0' && f.world.start_flag_5bb1ca == 0);
    fx_init(&f, 3, 1);
    CHECK(d9_step(&f.obj, f.body, D9_BODY_BYTES, 1, 2, &f.world, &f.host, &r, &why) == D9_ERR_ARGUMENT);
    f.host.view = NULL;
    CHECK(d9_step(&f.obj, f.body, D9_BODY_BYTES, 1, 1, &f.world, &f.host, &r, &why) == D9_ERR_UNSUPPORTED);
    CHECK(d9_step(&f.obj, f.body, D9_BODY_BYTES, 1, 0, NULL, &f.host, &r, &why) == D9_ERR_ARGUMENT);
}

static int run1(Fx *f, int16_t x, int16_t y)
{
    d9_pointer_move(&f->obj, x, y);
    return step(f, 1);
}

static void t_phase1_clamp(void)
{
    Fx f;
    fx_init(&f, 50, 1); /* view: origin (10,20), source right 600 bottom 400 */
    f.view.bottom = 520; /* the zeroing limit (bottom - origin_y + 5 = 505) is tested separately */
    f.obj.tracking = 1;
    f.obj.radius = 50;
    CHECK(run1(&f, 300, 200) == D9_OK);
    CHECK(f.obj.rect[0] == 250 && f.obj.rect[1] == 150 && f.obj.rect[2] == 349 && f.obj.rect[3] == 249);
    CHECK(run1(&f, 10, 30) == D9_OK); /* left/top clamp to 0 */
    CHECK(f.obj.rect[0] == 0 && f.obj.rect[1] == 0 && f.obj.rect[2] == 59 && f.obj.rect[3] == 79);
    CHECK(f.obj.prev[0] == 250 && f.obj.prev[2] == 349); /* previous window kept */
    CHECK(run1(&f, 590, 390) == D9_OK); /* right/bottom clamp to the source rectangle */
    CHECK(f.obj.rect[2] == 600 && f.obj.rect[3] == 400 && f.obj.rect[0] == 540 && f.obj.rect[1] == 340);
    CHECK(run1(&f, 551, 200) == D9_OK && f.obj.rect[2] == 600); /* x + r - 1 == max */
    CHECK(run1(&f, 552, 200) == D9_OK && f.obj.rect[2] == 600); /* one past the edge */
    CHECK(run1(&f, 1000, 300) == D9_OK);
    CHECK(f.obj.rect[0] == 950 && f.obj.rect[2] == 600); /* left is not clamped by the source edge */
    CHECK(run1(&f, -400, 100) == D9_OK); /* right end below zero floors to 0 */
    CHECK(f.obj.rect[0] == 0 && f.obj.rect[2] == 0);
    CHECK(run1(&f, 300, -300) == D9_OK);
    CHECK(f.obj.rect[1] == 0 && f.obj.rect[3] == 0);
}

static void t_phase1_below_view_zeroes_window(void)
{
    Fx f;
    fx_init(&f, 50, 1);
    f.obj.tracking = 1;
    f.obj.radius = 50;
    CHECK(run1(&f, 300, 200) == D9_OK);
    /* limit: y > bottom - origin_y + 5 = 345; 345 itself is still tracked */
    CHECK(run1(&f, 300, 345) == D9_OK);
    CHECK(f.obj.rect[1] == 295 && f.obj.rect[3] == 394);
    CHECK(run1(&f, 300, 346) == D9_OK);
    CHECK(f.obj.rect[0] == 0 && f.obj.rect[1] == 0 && f.obj.rect[2] == 0 && f.obj.rect[3] == 0);
    CHECK(f.obj.prev[1] == 295); /* previous window still recorded */
}

static void t_first_phase1_after_init(void)
{
    /* pointer starts at -500: the window collapses to the origin cell. */
    Fx f;
    fx_init(&f, 150, 1);
    CHECK(step(&f, 0) == D9_OK);
    CHECK(f.obj.pointer_x == -500 && f.obj.pointer_y == -500);
    CHECK(step(&f, 1) == D9_OK);
    CHECK(f.obj.rect[0] == 0 && f.obj.rect[1] == 0 && f.obj.rect[2] == 0 && f.obj.rect[3] == 0);
    free_obj(&f);
}

static void t_pointer_gate(void)
{
    D9Object o;
    d9_object_reset(&o);
    CHECK(d9_pointer_move(&o, 5, 6) == 0);
    CHECK(o.pointer_x == -500 && o.pointer_y == -500); /* not tracking: ignored */
    o.tracking = 1;
    CHECK(d9_pointer_move(&o, 5, -6) == 0);
    CHECK(o.pointer_x == 5 && o.pointer_y == -6);
    CHECK(d9_pointer_move(NULL, 1, 1) == 0);
}

static void t_invalidate(void)
{
    Fx f;
    fx_init(&f, 2, 1);
    CHECK(d9_invalidate(&f.obj, &f.host) == D9_OK && f.log[0] == '\0'); /* not tracking */
    f.obj.slot = 0x20; /* a slot without the tracking flag (0x47d640 tests both) */
    CHECK(d9_invalidate(&f.obj, &f.host) == D9_OK && f.log[0] == '\0');
    f.obj.slot = D9_NO_SLOT;
    CHECK(step(&f, 0) == D9_OK);
    f.log[0] = '\0';
    CHECK(d9_invalidate(&f.obj, &f.host) == D9_OK);
    CHECK_LOG(&f, "dirty:24");
    free_obj(&f);
}

static void t_cleanup_state(void)
{
    Fx f;
    fx_init(&f, 6, 0);
    CHECK(step(&f, 0) == D9_OK);
    f.log[0] = '\0';
    d9_pointer_move(&f.obj, 3, 4);
    CHECK(step(&f, 1) == D9_OK);
    CHECK(d9_cleanup(&f.obj, &f.host) == D9_OK);
    CHECK_LOG(&f, "relsurf:77:0,free:0:0,free:0:2,relslot:24:0");
    /* 0x47d4f7 resets the window, pointer, row, slot and buffers; not +0x1c, +0x1f, +0x55. */
    CHECK(f.obj.slot == -1 && f.obj.row == -1 && f.obj.tracking == 0);
    CHECK(f.obj.pointer_x == -500 && f.obj.pointer_y == -500);
    CHECK(f.obj.rect[0] == 0 && f.obj.rect[2] == 0 && f.obj.prev[0] == 0);
    CHECK(f.obj.composite == NULL && f.obj.alpha == NULL && f.obj.mask == NULL);
    CHECK(f.obj.active == 1 && f.obj.radius == 6 && f.obj.surface == 0u);
    f.log[0] = '\0';
    CHECK(d9_cleanup(&f.obj, &f.host) == D9_OK && f.log[0] == '\0'); /* idempotent */
}

static void t_reinit_after_cleanup_loads_again(void)
{
    Fx f;
    fx_init(&f, 2, 1);
    CHECK(step(&f, 0) == D9_OK);
    CHECK(d9_cleanup(&f.obj, &f.host) == D9_OK);
    f.log[0] = '\0';
    CHECK(step(&f, 0) == D9_OK);
    CHECK(strstr(f.log, "load:77:0") != NULL);
    free_obj(&f);
}

static void t_second_row_reinitializes_the_singleton(void)
{
    Fx f;
    D9Result r;
    const char *why = NULL;
    fx_init(&f, 2, 1);
    CHECK(step(&f, 0) == D9_OK);
    f.next_slot = 0x19;
    f.log[0] = '\0';
    CHECK(d9_step(&f.obj, f.body, D9_BODY_BYTES, 9, 0, &f.world, &f.host, &r, &why) == D9_OK);
    CHECK(f.obj.row == 9 && f.obj.slot == 0x19);
    CHECK(strstr(f.log, "load") == NULL); /* the surface is kept */
    free_obj(&f);
}

static void t_mode_switch_keeps_the_other_buffer(void)
{
    /* 0x47d788 stores only the chosen mode's pointer: a mask row after an alpha row leaves +0x4d. */
    Fx f;
    D9Result r;
    const char *why = NULL;
    fx_init(&f, 4, 1);
    CHECK(step(&f, 0) == D9_OK);
    CHECK(f.obj.alpha != NULL && f.obj.mask == NULL);
    f.body[0x22] = 0;
    CHECK(d9_step(&f.obj, f.body, D9_BODY_BYTES, 5, 0, &f.world, &f.host, &r, &why) == D9_OK);
    CHECK(f.obj.alpha != NULL && f.obj.mask != NULL);
    f.log[0] = '\0';
    CHECK(d9_cleanup(&f.obj, &f.host) == D9_OK);
    CHECK(strstr(f.log, "free:0:0,free:0:1,free:0:2") != NULL);
}

static void t_render_plan(void)
{
    Fx f;
    D9RenderPlan p;
    D9View v = {10, 20, 360, 600, 400};
    fx_init(&f, 50, 1);
    CHECK(d9_render_plan(&f.obj, f.body, D9_BODY_BYTES, &v, &p) == D9_OK && p.valid == 0);
    f.obj.active = 1;
    f.obj.radius = 50;
    f.obj.surface = 9;
    memcpy(f.obj.rect, (int32_t[]){250, 150, 349, 249}, sizeof f.obj.rect);
    memcpy(f.obj.prev, (int32_t[]){240, 140, 339, 239}, sizeof f.obj.prev);
    CHECK(d9_render_plan(&f.obj, f.body, D9_BODY_BYTES, &v, &p) == D9_OK && p.valid == 1);
    CHECK(p.kind == D9_BLIT_ALPHA && p.surface == 9u);
    CHECK(p.restore_src[0] == 240 && p.restore_dst[0] == 250 && p.restore_dst[1] == 160 &&
          p.restore_dst[2] == 349 && p.restore_dst[3] == 259);
    CHECK(p.src[0] == 250 && p.dst[0] == 260 && p.dst[1] == 170 && p.dst[2] == 359 && p.dst[3] == 269);
    CHECK(p.map[0] == 0 && p.map[1] == 0 && p.map[2] == 99 && p.map[3] == 99);
    /* clipped on the left and top: the map starts where the circle does */
    memcpy(f.obj.rect, (int32_t[]){0, 0, 59, 79}, sizeof f.obj.rect);
    CHECK(d9_render_plan(&f.obj, f.body, D9_BODY_BYTES, &v, &p) == D9_OK);
    CHECK(p.map[0] == 40 && p.map[1] == 20 && p.map[2] == 99 && p.map[3] == 99);
    /* clipped on the right only: no offset */
    memcpy(f.obj.rect, (int32_t[]){540, 340, 600, 400}, sizeof f.obj.rect);
    CHECK(d9_render_plan(&f.obj, f.body, D9_BODY_BYTES, &v, &p) == D9_OK);
    CHECK(p.map[0] == 0 && p.map[1] == 0);
    /* a window at the origin that is already full size has no offset */
    memcpy(f.obj.rect, (int32_t[]){0, 0, 99, 99}, sizeof f.obj.rect);
    CHECK(d9_render_plan(&f.obj, f.body, D9_BODY_BYTES, &v, &p) == D9_OK);
    CHECK(p.map[0] == 0 && p.map[1] == 0);
    f.body[0x22] = 0;
    CHECK(d9_render_plan(&f.obj, f.body, D9_BODY_BYTES, &v, &p) == D9_OK && p.kind == D9_BLIT_MASK);
    CHECK(d9_render_plan(&f.obj, f.body, 5u, &v, &p) == D9_ERR_ARGUMENT);
}

static D9Surface surf(uint8_t *px, size_t n, int pitch)
{
    D9Surface s = {px, n, pitch};
    return s;
}

static void t_blit_copy_and_bounds(void)
{
    uint8_t a[4 * 4 * 2], b[4 * 4 * 2], keep[sizeof b];
    int32_t src[4] = {1, 1, 2, 2}, dst[4] = {0, 2, 1, 3};
    int32_t bad[4] = {0, 0, 4, 1};
    D9Surface s, d;
    for (size_t i = 0; i < sizeof a; ++i) a[i] = (uint8_t)(i + 1u), b[i] = 0xee;
    s = surf(a, sizeof a, 8);
    d = surf(b, sizeof b, 8);
    memcpy(keep, b, sizeof b);
    CHECK(d9_blit_copy(&s, &d, src, dst) == D9_OK);
    CHECK(b[2 * 8 + 0] == a[1 * 8 + 2] && b[3 * 8 + 3] == a[2 * 8 + 5] && b[0] == 0xee);
    memcpy(keep, b, sizeof b);
    CHECK(d9_blit_copy(&s, &d, bad, dst) == D9_ERR_BOUNDS); /* right edge 4 is outside the 4-pixel row */
    CHECK(memcmp(keep, b, sizeof b) == 0);
}

static void t_blit_mask(void)
{
    uint8_t a[4 * 2 * 2], b[4 * 2 * 2];
    const uint8_t mask[8] = {1, 0, 1, 0, 0, 1, 0, 1};
    int32_t src[4] = {0, 0, 3, 1}, dst[4] = {0, 0, 3, 1}, map[4] = {0, 0, 3, 1};
    D9Surface s = surf(a, sizeof a, 8), d = surf(b, sizeof b, 8);
    for (size_t i = 0; i < sizeof a; ++i) a[i] = (uint8_t)(0x10 + i), b[i] = 0;
    CHECK(d9_blit_mask(&s, &d, mask, sizeof mask, src, dst, map) == D9_OK);
    for (int y = 0; y < 2; ++y)
        for (int x = 0; x < 4; ++x) {
            const int on = mask[y * 4 + x];
            CHECK(b[y * 8 + x * 2] == (on ? a[y * 8 + x * 2] : 0));
            CHECK(b[y * 8 + x * 2 + 1] == (on ? a[y * 8 + x * 2 + 1] : 0));
        }
    /* map offset (clipped window): columns 2..3 of a 4-wide map, rows 0..1 */
    int32_t src2[4] = {0, 0, 1, 1}, map2[4] = {2, 0, 3, 1};
    memset(b, 0, sizeof b);
    CHECK(d9_blit_mask(&s, &d, mask, sizeof mask, src2, src2, map2) == D9_OK);
    CHECK(b[0] == a[0] && b[2] == 0 && b[8] == 0 && b[10] == a[10]);
    int32_t big[4] = {0, 1, 3, 2};
    CHECK(d9_blit_mask(&s, &d, mask, sizeof mask, src, dst, big) == D9_ERR_BOUNDS); /* mask too short */
}

static uint16_t px555(unsigned r, unsigned g, unsigned bl) { return (uint16_t)((r << 10) | (g << 5) | bl); }

static void t_blit_alpha(void)
{
    const D9PixelFormat fmt = {{10, 5, 0}, {0x1f, 0x1f, 0x1f}};
    uint16_t p[2] = {px555(31, 0, 8), px555(0, 31, 0)}, bg[2] = {px555(0, 31, 4), px555(31, 0, 31)};
    uint16_t out[2] = {0, 0};
    float alpha[2] = {1.0f, 0.5f};
    int32_t r[4] = {0, 0, 1, 0}, map[4] = {0, 0, 1, 0};
    D9Surface sp = surf((uint8_t *)p, sizeof p, 4), sb = surf((uint8_t *)bg, sizeof bg, 4),
              so = surf((uint8_t *)out, sizeof out, 4);
    CHECK(d9_blit_alpha(&sp, &sb, &so, alpha, 2, r, r, r, map, &fmt) == D9_OK);
    CHECK(out[0] == p[0]); /* alpha 1 shows the puzzle image */
    /* alpha 0.5 truncates toward zero: bg + trunc((puzzle - bg) / 2) = red 31 + trunc(-15.5) = 16,
     * green 0 + trunc(15.5) = 15, blue 31 + trunc(-15.5) = 16 */
    CHECK(out[1] == px555(16, 15, 16));
    alpha[0] = 0.0f;
    CHECK(d9_blit_alpha(&sp, &sb, &so, alpha, 2, r, r, r, map, &fmt) == D9_OK);
    CHECK(out[0] == bg[0]); /* alpha 0 keeps the saved frame */
    CHECK(d9_blit_alpha(&sp, &sb, &so, alpha, 1, r, r, r, map, &fmt) == D9_ERR_BOUNDS); /* alpha too short */
}

static void t_blit_alpha_negative_wraps_like_the_original(void)
{
    /* puzzle channel below the saved one: trunc(-2.5) = -2, masked to 0xfffe, added to the saved
     * channel and shifted; the 16-bit store drops the carry, so the result is bg + trunc = 3. */
    const D9PixelFormat fmt = {{10, 5, 0}, {0x1f, 0x1f, 0x1f}};
    uint16_t p = px555(0, 0, 0), bg = px555(5, 0, 0), out = 0xffff;
    float alpha = 0.5f;
    int32_t r[4] = {0, 0, 0, 0};
    D9Surface sp = surf((uint8_t *)&p, 2, 2), sb = surf((uint8_t *)&bg, 2, 2), so = surf((uint8_t *)&out, 2, 2);
    CHECK(d9_blit_alpha(&sp, &sb, &so, &alpha, 1, r, r, r, r, &fmt) == D9_OK);
    /* red: 5 + (0xfffe & 0xffff) = 0x10003 << 10 -> low 16 bits 0x0c00; green, blue: 0 + 0 */
    CHECK(out == (uint16_t)(((5u + 0xfffeu) << 10) & 0xffffu));
}

int main(void)
{
    static const struct { const char *name; void (*fn)(void); } tests[] = {
        {"validate_body", t_validate_body},
        {"alpha_values", t_alpha_values},
        {"phase0_effects_and_buffers", t_phase0_effects_and_buffers},
        {"phase0_mask", t_phase0_mask},
        {"surface_reuse_and_host_failures", t_surface_reuse_and_host_failures},
        {"rejections_change_nothing", t_rejections_change_nothing},
        {"phase1_clamp", t_phase1_clamp},
        {"phase1_below_view_zeroes_window", t_phase1_below_view_zeroes_window},
        {"first_phase1_after_init", t_first_phase1_after_init},
        {"pointer_gate", t_pointer_gate},
        {"invalidate", t_invalidate},
        {"cleanup_state", t_cleanup_state},
        {"reinit_after_cleanup_loads_again", t_reinit_after_cleanup_loads_again},
        {"second_row_reinitializes_the_singleton", t_second_row_reinitializes_the_singleton},
        {"mode_switch_keeps_the_other_buffer", t_mode_switch_keeps_the_other_buffer},
        {"render_plan", t_render_plan},
        {"blit_copy_and_bounds", t_blit_copy_and_bounds},
        {"blit_mask", t_blit_mask},
        {"blit_alpha", t_blit_alpha},
        {"blit_alpha_negative_wraps_like_the_original", t_blit_alpha_negative_wraps_like_the_original},
    };
    int failures = 0;
    for (size_t i = 0; i < sizeof tests / sizeof tests[0]; ++i) {
        g_name = tests[i].name;
        g_failed = 0;
        g_msg[0] = '\0';
        tests[i].fn();
        ++g_total;
        if (g_failed) {
            printf("FAIL %s: %s\n", g_name, g_msg);
            ++failures;
        } else {
            printf("PASS %s\n", g_name);
        }
    }
    return failures;
}
