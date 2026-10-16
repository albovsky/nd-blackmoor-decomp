/* RT-35 unit tests of the raw 0xd1 Turning Puzzle kernel (src/action_family_d1_runtime.c). Prints
 * "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure count. Fixtures are synthetic bodies (no
 * original bytes). tests/test_action_family_d1_runtime.py builds and runs this with and without ASan/UBSan and under
 * source mutations. */
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_d1_runtime.h"

static const char *g_name;
static int g_failed, g_total, g_failures;
static char g_msg[256];
#define CHECK(cond)                                                        \
    do {                                                                   \
        if (!(cond) && !g_failed) {                                        \
            g_failed = 1;                                                  \
            snprintf(g_msg, sizeof g_msg, "line %d: %s", __LINE__, #cond); \
        }                                                                  \
    } while (0)
#define CHECK_LOG(fx, expected)                                                              \
    do {                                                                                     \
        if (strcmp((fx)->log, (expected)) != 0 && !g_failed) {                               \
            g_failed = 1;                                                                    \
            snprintf(g_msg, sizeof g_msg, "line %d: log \"%.100s\" != \"%.100s\"", __LINE__, \
                     (fx)->log, (expected));                                                 \
        }                                                                                    \
    } while (0)

typedef struct Fx {
    D1Object obj;
    D1World world;
    D1Host host;
    uint8_t body[D1_BODY_BYTES];
    char log[2048];
    int fail_alloc, fail_load, fail_sound_play, fail_flag, fail_release_slot;
    int32_t busy[8];
    int nbusy, ibusy;
    uint32_t ticks[8];
    int nticks, iticks;
    uint32_t phase;
    int completed;
} Fx;

static void put16(uint8_t *b, size_t off, int v) { b[off] = (uint8_t)v; b[off + 1] = (uint8_t)(v >> 8); }
static void put32(uint8_t *b, size_t off, int32_t v)
{
    for (int i = 0; i < 4; ++i) b[off + (size_t)i] = (uint8_t)((uint32_t)v >> (8 * i));
}

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

static const char *const effect_names[] = {"?", "active", "start", "clritem", "slot", "reg", "load", "slotsurf",
                                           "prep", "phase", "busy", "play", "stop", "tick", "state", "x57b",
                                           "x599", "x595", "x39ff", "x59b", "x59f", "x5a3", "mode", "evflag",
                                           "complete", "relsurf", "relslot"};

static void observe(void *c, int e, int32_t a, int32_t b)
{
    Fx *f = (Fx *)c;
    logf_(f, "%s:%d:%d", effect_names[e], a, b);
}
static int alloc_slot(void *c, int16_t *slot)
{
    Fx *f = (Fx *)c;
    if (f->fail_alloc) return 1;
    *slot = 0x18;
    return 0;
}
static int register_slot(void *c, int16_t slot, const char *label)
{
    (void)c;
    (void)slot;
    return strcmp(label, "TURNING PUZZLE OVERLAYS") != 0;
}
static int load_surface(void *c, const char *name, uint32_t *surface)
{
    Fx *f = (Fx *)c;
    if (f->fail_load || strcmp(name, "WHEELS") != 0) return 1;
    *surface = 77u;
    return 0;
}
static int set_slot_surface(void *c, int16_t slot, uint32_t surface) { (void)c; (void)slot; (void)surface; return 0; }
static int release_surface(void *c, uint32_t s) { (void)c; (void)s; return 0; }
static int release_slot(void *c, int16_t s) { (void)s; return ((Fx *)c)->fail_release_slot; }
static int mark_dirty(void *c, int16_t s) { logf_((Fx *)c, "dirty:%d", s); return 0; }
static int view_origin(void *c, int32_t *x, int32_t *y) { (void)c; *x = 10; *y = 20; return 0; }
static int clear_item(void *c) { (void)c; return 0; }
static int sound_prepare(void *c, int r, const uint8_t *b) { (void)c; (void)r; (void)b; return 0; }
static int sound_stop(void *c, int r, const uint8_t *b) { (void)c; (void)r; (void)b; return 0; }
static int sound_play(void *c, int16_t ch) { (void)ch; return ((Fx *)c)->fail_sound_play; }
static int sound_busy(void *c, int16_t ch, int32_t *r)
{
    Fx *f = (Fx *)c;
    (void)ch;
    *r = f->ibusy < f->nbusy ? f->busy[f->ibusy++] : 0;
    return 0;
}
static uint32_t tick(void *c)
{
    Fx *f = (Fx *)c;
    return f->iticks < f->nticks ? f->ticks[f->iticks++] : f->ticks[f->nticks - 1];
}
static int flag_invalid(void *c, int16_t i) { (void)c; return i < 0 || i >= 100; }
static int transition(void *c, const D1Transition *t) { logf_((Fx *)c, "scene:%d:%d", t->scene, t->word[0]); return 0; }
static int store_flag(void *c, int16_t i, uint32_t v) { (void)i; (void)v; return ((Fx *)c)->fail_flag; }

static void set_name(uint8_t *b, size_t off, const char *s)
{
    memset(b + off, 0, D1_NAME_BYTES);
    memcpy(b + off, s, strlen(s));
}

/* Two wheels, 3 frames, 1 sub-step. Tile 0 hits x 0..9, tile 1 x 10..19, y 0..9; exit rect x 100..110, y 50..60. */
static void body_init(Fx *f, int n)
{
    uint8_t *b = f->body;
    memset(b, 0, D1_BODY_BYTES);
    memcpy(b, "WHEELS", 7);
    put16(b, 0x21, n);
    put16(b, 0x23, 3);
    put16(b, 0x25, 1);
    for (int i = 0; i < n; ++i) {
        put16(b, 0x27 + 2u * (unsigned)i, i);
        put32(b, 0x47 + 16u * (unsigned)i, 5 + 20 * i);
        put32(b, 0x47 + 16u * (unsigned)i + 4, 6);
        put32(b, 0x47 + 16u * (unsigned)i + 8, 24 + 20 * i);
        put32(b, 0x47 + 16u * (unsigned)i + 12, 35);
        put32(b, 0x147 + 16u * (unsigned)i, 10 * i);
        put32(b, 0x147 + 16u * (unsigned)i + 4, 0);
        put32(b, 0x147 + 16u * (unsigned)i + 8, 10 * i + 9);
        put32(b, 0x147 + 16u * (unsigned)i + 12, 9);
        put16(b, 0x30a + 2u * (unsigned)i, 2); /* every tile must show frame 2 */
    }
    b[0x247] = 1;
    put32(b, 0x248, 1);
    put32(b, 0x24c, 1);
    put16(b, 0x250, 20);
    put16(b, 0x252, 30);
    put16(b, 0x2d4, 2);
    b[0x2d6] = 0;
    put16(b, 0x2d7, 1);
    set_name(b, 0x2d9, "CLICK");
    put16(b, 0x2fa, 8);
    set_name(b, 0x345, "NO SOUND");
    put16(b, 0x366, 9);
    put16(b, 0x32a, 4377); put16(b, 0x32c, 11); put16(b, 0x32e, 12); put16(b, 0x330, 13);
    put32(b, 0x332, 1); put32(b, 0x336, 2); put32(b, 0x33a, 3);
    put16(b, 0x33e, 2); put16(b, 0x340, 5); b[0x342] = 1;
    put16(b, 0x376, 4366); put16(b, 0x378, 21); put16(b, 0x38a, 1); put16(b, 0x38c, -1);
    put32(b, 0x38f, 100); put32(b, 0x393, 50); put32(b, 0x397, 110); put32(b, 0x39b, 60);
}

static void fx_init(Fx *f, int n)
{
    memset(f, 0, sizeof *f);
    d1_object_reset(&f->obj);
    body_init(f, n);
    f->host.context = f;
    f->host.alloc_slot = alloc_slot;
    f->host.register_slot = register_slot;
    f->host.load_surface = load_surface;
    f->host.set_slot_surface = set_slot_surface;
    f->host.release_surface = release_surface;
    f->host.release_slot = release_slot;
    f->host.mark_dirty = mark_dirty;
    f->host.view_origin = view_origin;
    f->host.clear_pending_item = clear_item;
    f->host.sound_prepare = sound_prepare;
    f->host.sound_stop = sound_stop;
    f->host.sound_play = sound_play;
    f->host.sound_busy = sound_busy;
    f->host.tick = tick;
    f->host.event_flag_invalid = flag_invalid;
    f->host.transition = transition;
    f->host.store_event_flag = store_flag;
    f->host.observe = observe;
    f->ticks[0] = 1000u;
    f->nticks = 1;
}

static int visit(Fx *f, int16_t row)
{
    D1Result r;
    const char *why = NULL;
    int rc = d1_step(&f->obj, f->body, D1_BODY_BYTES, row, f->phase, &f->world, &f->host, &r, &why);
    if (rc == D1_OK) {
        f->phase = r.phase_after;
        f->completed = r.completed;
    }
    return rc;
}

static void start(Fx *f)
{
    CHECK(visit(f, 3) == D1_OK);
    f->log[0] = '\0';
}

static void click_tile(Fx *f, int16_t x, int16_t y)
{
    D1PointerResult pr;
    uint32_t np;
    CHECK(d1_pointer_move(&f->obj, f->body, D1_BODY_BYTES, x, y, &pr) == D1_OK);
    CHECK(pr.candidate == D1_CANDIDATE_TILE);
    CHECK(d1_click(&f->obj, f->body, D1_BODY_BYTES, f->phase, pr.candidate, f->world.start_flag_5bb1ca, &f->host, &np) ==
          D1_OK);
    f->phase = np;
}

static void t_validate(void)
{
    Fx f;
    const char *why = NULL;
    fx_init(&f, 2);
    CHECK(d1_validate_body(f.body, D1_BODY_BYTES, &why) == D1_OK);
    CHECK(d1_validate_body(f.body, D1_BODY_BYTES - 1u, &why) != D1_OK);
    put16(f.body, 0x21, 17);
    CHECK(d1_validate_body(f.body, D1_BODY_BYTES, &why) != D1_OK);
    put16(f.body, 0x21, -1);
    CHECK(d1_validate_body(f.body, D1_BODY_BYTES, &why) != D1_OK);
    put16(f.body, 0x21, 2);
    put16(f.body, 0x25, 0);
    CHECK(d1_validate_body(f.body, D1_BODY_BYTES, &why) != D1_OK);
    put16(f.body, 0x25, 1);
    put16(f.body, 0x254, 17);
    CHECK(d1_validate_body(f.body, D1_BODY_BYTES, &why) != D1_OK);
    put16(f.body, 0x254, 0);
    memset(f.body, 'A', D1_NAME_BYTES);
    CHECK(d1_validate_body(f.body, D1_BODY_BYTES, &why) != D1_OK);
}

static void t_geometry(void)
{
    Fx f;
    int32_t r[4];
    fx_init(&f, 2);
    /* x = 1 + frame * 20 * 1 + step * 20; y = 1 + tile * 30 with the row flag. */
    d1_geometry(f.body, 1, 2, 1, r);
    CHECK(r[0] == 1 + 40 + 20 && r[2] == r[0] - 2 + 20 && r[1] == 1 + 30 && r[3] == r[1] - 2 + 30);
    f.body[0x247] = 0;
    d1_geometry(f.body, 1, 0, 0, r);
    CHECK(r[1] == 1 && r[0] == 1);
    put16(f.body, 0x25, 3);
    d1_geometry(f.body, 0, 2, 0, r);
    CHECK(r[0] == 1 + 2 * 20 * 3);
}

static void t_phase0(void)
{
    Fx f;
    fx_init(&f, 2);
    CHECK(visit(&f, 3) == D1_OK);
    CHECK_LOG(&f, "active:1:0,start:1:0,clritem:0:0,slot:24:0,reg:24:0,load:77:0,slotsurf:24:77,prep:0:0,phase:1:0");
    CHECK(f.phase == 1u && f.completed == 0);
    CHECK(f.obj.row == 3 && f.obj.active == 1 && f.obj.slot == 0x18 && f.obj.surface == 77u);
    CHECK(f.obj.dst[1][0] == 25 + 10 && f.obj.dst[1][1] == 6 + 20 && f.obj.dst[1][2] == 44 + 10 && f.obj.dst[1][3] == 35 + 20);
    CHECK(f.obj.frame[1] == 1 && f.obj.src[1][0] == 1 + 20 && f.obj.src[1][1] == 1 + 30);
    CHECK(f.obj.state == D1_STATE_IDLE && f.obj.step == 1 && f.world.start_flag_5bb1ca == 1);
    /* A second init keeps the already loaded image. */
    f.phase = 0;
    f.log[0] = '\0';
    CHECK(visit(&f, 3) == D1_OK);
    CHECK(strstr(f.log, "load:") == NULL);
}

static void t_phase0_failure(void)
{
    Fx f;
    fx_init(&f, 2);
    f.fail_alloc = 1;
    CHECK(visit(&f, 3) == D1_ERR_HOST);
    fx_init(&f, 2);
    f.fail_load = 1;
    CHECK(visit(&f, 3) == D1_ERR_HOST);
    fx_init(&f, 2);
    f.phase = 1u; /* phase 1 without init */
    CHECK(visit(&f, 3) == D1_ERR_UNSUPPORTED);
    CHECK(f.log[0] == '\0');
}

static void t_solved_finishes(void)
{
    Fx f;
    fx_init(&f, 2);
    put16(f.body, 0x27, 2);
    put16(f.body, 0x29, 2); /* initial frames equal the targets */
    start(&f);
    CHECK(visit(&f, 3) == D1_OK); /* idle: solved check */
    CHECK(f.obj.solved == 1 && f.obj.state == D1_STATE_START_SOLVED && f.phase == 1u);
    CHECK(visit(&f, 3) == D1_OK); /* record 1 is "NO SOUND", the sound flag byte is 0: finish */
    CHECK(f.phase == 2u);
    f.log[0] = '\0';
    CHECK(visit(&f, 3) == D1_OK);
    CHECK_LOG(&f, "start:1:0,stop:0:0,scene:4377:11,x57b:4377:0,x599:11:0,x595:12:0,x39ff:13:0,x59b:1:0,x59f:2:0,x5a3:3:0,"
                  "start:1:0,mode:4:0,evflag:5:1,complete:3:0,relsurf:77:0,relslot:24:0");
    CHECK(f.completed == 1 && f.phase == 0u && f.obj.active == 0 && f.obj.slot == D1_NO_SLOT && f.obj.row == -1);
    CHECK(f.obj.surface == 0u && f.world.start_flag_5bb1ca == 1);
}

static void t_click_turns_tile(void)
{
    Fx f;
    fx_init(&f, 2);
    start(&f);
    f.nbusy = 1;
    f.busy[0] = 0;
    click_tile(&f, 3, 3);
    CHECK_LOG(&f, "busy:8:0,state:2:0,play:8:0");
    CHECK(f.obj.state == D1_STATE_ANIMATE && f.obj.moving[0] == 1 && f.obj.moving[1] == 0 && f.obj.step == 1);
    {
        D1PointerResult pr;
        /* A pointer event while a tile turns shows the sub-step before the current one (0x4b5d17). */
        CHECK(d1_pointer_move(&f.obj, f.body, D1_BODY_BYTES, 3, 3, &pr) == D1_OK);
        CHECK(f.obj.src[0][0] == 1 && f.obj.src[1][0] == 1 + 20);
    }
    f.log[0] = '\0';
    CHECK(visit(&f, 3) == D1_OK); /* animate: step == S, frame 0 -> 1 */
    CHECK(f.obj.frame[0] == 1 && f.obj.frame[1] == 1 && f.obj.state == D1_STATE_IDLE && f.obj.step == 1);
    CHECK(f.obj.moving[0] == 0); /* cleared again, not solved */
    CHECK(f.obj.src[0][0] == 1 + 0 * 20 + 20); /* geometry at frame 0, step 1 */
}

static void t_busy_sound_blocks_click(void)
{
    Fx f;
    fx_init(&f, 2);
    start(&f);
    f.nbusy = 1;
    f.busy[0] = 1;
    click_tile(&f, 3, 3);
    CHECK(f.obj.state == D1_STATE_IDLE && f.obj.moving[0] == 0);
    CHECK_LOG(&f, "busy:8:1");
}

static void t_links_turn_together(void)
{
    Fx f;
    fx_init(&f, 3);
    put16(f.body, 0x254, 3); /* tile 0 also turns tile 2 (1-based 3) */
    start(&f);
    click_tile(&f, 3, 3);
    CHECK(f.obj.moving[0] == 1 && f.obj.moving[1] == 0 && f.obj.moving[2] == 1);
}

static void t_frame_wraps_and_deadline(void)
{
    Fx f;
    fx_init(&f, 2);
    put16(f.body, 0x25, 2); /* two sub-steps */
    start(&f);
    click_tile(&f, 3, 3);
    f.ticks[0] = 5000u;
    CHECK(visit(&f, 3) == D1_OK); /* step 1 != S 2: nothing moves on, wait */
    CHECK(f.obj.state == D1_STATE_WAIT && f.obj.step == 2 && f.obj.deadline == 5000u + 2u * 1000u / 2u);
    CHECK(visit(&f, 3) == D1_OK); /* deadline not reached (tick == 5000) */
    CHECK(f.obj.state == D1_STATE_WAIT);
    f.ticks[0] = 6000u;
    CHECK(visit(&f, 3) == D1_OK);
    CHECK(f.obj.state == D1_STATE_ANIMATE);
    CHECK(visit(&f, 3) == D1_OK); /* step == S: tile 0 advances 0 -> 1 */
    CHECK(f.obj.frame[0] == 1 && f.obj.state == D1_STATE_IDLE);
    /* From the last frame (F - 1 = 2) the tile wraps to 0. */
    f.obj.frame[0] = 2;
    f.obj.state = D1_STATE_ANIMATE;
    f.obj.moving[0] = 1;
    f.obj.step = 2;
    CHECK(visit(&f, 3) == D1_OK);
    CHECK(f.obj.frame[0] == 0);
}

static void t_exit_click(void)
{
    Fx f;
    D1PointerResult pr;
    uint32_t np;
    fx_init(&f, 2);
    start(&f);
    CHECK(d1_pointer_move(&f.obj, f.body, D1_BODY_BYTES, 105, 55, &pr) == D1_OK);
    CHECK(pr.hit == 1 && pr.candidate == D1_CANDIDATE_EXIT && pr.cursor == D1_CURSOR_EXIT && f.obj.last_tile == -1);
    CHECK(d1_click(&f.obj, f.body, D1_BODY_BYTES, 1u, pr.candidate, 1, &f.host, &np) == D1_OK);
    CHECK(np == 2u && f.obj.exit_taken == 1);
    f.phase = np;
    f.log[0] = '\0';
    CHECK(visit(&f, 3) == D1_OK); /* the exit block, not solved: scene 4366, flag index -1 */
    CHECK_LOG(&f, "start:1:0,stop:0:0,scene:4366:21,x57b:4366:0,x599:21:0,x595:0:0,x39ff:0:0,x59b:0:0,x59f:0:0,x5a3:0:0,start:0:0,"
                  "mode:4:0,complete:3:0,relsurf:77:0,relslot:24:0");
    CHECK(f.completed == 1 && f.world.start_flag_5bb1ca == 0);
}

static void t_pointer(void)
{
    Fx f;
    D1PointerResult pr;
    fx_init(&f, 2);
    CHECK(d1_pointer_move(&f.obj, f.body, D1_BODY_BYTES, 3, 3, &pr) == D1_OK && pr.hit == 0 && pr.candidate == -1);
    start(&f);
    CHECK(d1_pointer_move(&f.obj, f.body, D1_BODY_BYTES, 12, 9, &pr) == D1_OK);
    CHECK(pr.hit == 1 && pr.candidate == D1_CANDIDATE_TILE && pr.cursor == D1_CURSOR_TILE && f.obj.last_tile == 1);
    CHECK(d1_pointer_move(&f.obj, f.body, D1_BODY_BYTES, 12, 10, &pr) == D1_OK); /* y2 edge is inclusive, 10 is out */
    CHECK(pr.hit == 0 && pr.candidate == -1 && f.obj.last_tile == -1);
    CHECK(d1_pointer_move(&f.obj, f.body, D1_BODY_BYTES, 110, 60, &pr) == D1_OK && pr.candidate == D1_CANDIDATE_EXIT);
    CHECK(d1_pointer_move(&f.obj, f.body, D1_BODY_BYTES, 0, 0, &pr) == D1_OK && pr.candidate == D1_CANDIDATE_TILE &&
          f.obj.last_tile == 0); /* the top-left corner is inside (inclusive bounds) */
}

static void t_exit_without_scene(void)
{
    Fx f;
    uint32_t np;
    fx_init(&f, 2);
    put16(f.body, 0x376, D1_NO_SCENE);
    start(&f);
    f.world.start_flag_5bb1ca = 0;
    CHECK(d1_click(&f.obj, f.body, D1_BODY_BYTES, 1u, D1_CANDIDATE_EXIT, 1, &f.host, &np) == D1_OK && np == 2u);
    f.phase = np;
    f.log[0] = '\0';
    CHECK(visit(&f, 3) == D1_OK);
    /* No scene change: only the unconditional start flag store, no cells, no engine mode. */
    CHECK_LOG(&f, "start:1:0,stop:0:0,complete:3:0,relsurf:77:0,relslot:24:0");
    CHECK(f.world.start_flag_5bb1ca == 1);
}

static void t_click_without_tile_is_refused(void)
{
    Fx f;
    uint32_t np;
    fx_init(&f, 2);
    start(&f);
    f.obj.last_tile = -1;
    CHECK(d1_click(&f.obj, f.body, D1_BODY_BYTES, 1u, D1_CANDIDATE_TILE, 1, &f.host, &np) == D1_ERR_BOUNDS);
    CHECK(f.log[0] == '\0' && f.obj.state == D1_STATE_IDLE);
    /* Not idle: nothing happens, whatever the candidate. */
    f.obj.state = D1_STATE_WAIT;
    CHECK(d1_click(&f.obj, f.body, D1_BODY_BYTES, 1u, D1_CANDIDATE_EXIT, 1, &f.host, &np) == D1_OK && np == 1u);
}

static void t_auto_turn_when_solved_and_sound_flag(void)
{
    Fx f;
    fx_init(&f, 1);
    put16(f.body, 0x27, 2);
    put16(f.body, 0x30a, 2);
    f.body[0x2d6] = 1; /* sound flag set: the solved puzzle plays the turn animation once more */
    start(&f);
    CHECK(visit(&f, 3) == D1_OK); /* idle -> start solved */
    f.nbusy = 1;
    f.busy[0] = 0;
    f.log[0] = '\0';
    CHECK(visit(&f, 3) == D1_OK); /* record 1 NO SOUND, flag set, not busy: all tiles turn */
    CHECK_LOG(&f, "busy:8:0,state:2:0,play:8:0");
    CHECK(f.obj.state == D1_STATE_ANIMATE && f.obj.moving[0] == 1 && f.obj.counter == 0);
    CHECK(visit(&f, 3) == D1_OK); /* frame 2 == F - 1 wraps to 0; solved keeps moving[] */
    CHECK(f.obj.frame[0] == 0 && f.obj.state == D1_STATE_IDLE && f.obj.moving[0] == 1);
    CHECK(visit(&f, 3) == D1_OK); /* solved: auto state */
    CHECK(f.obj.state == D1_STATE_AUTO);
    f.ticks[0] = 100u;
    CHECK(visit(&f, 3) == D1_OK); /* frame 0 < F - 1: deadline T * 8000 / S, counter 1 */
    CHECK(f.obj.state == D1_STATE_WAIT && f.obj.deadline == 100u + 16000u && f.obj.counter == 1);
}

static void t_win_sound_branch(void)
{
    Fx f;
    fx_init(&f, 1);
    put16(f.body, 0x27, 2);
    put16(f.body, 0x30a, 2);
    set_name(f.body, 0x345, "WIN");
    start(&f);
    CHECK(visit(&f, 3) == D1_OK);
    CHECK(visit(&f, 3) == D1_OK); /* record 1 is a sound: play channel 9, state 5 */
    CHECK(f.obj.state == D1_STATE_WIN_SOUND && strstr(f.log, "play:9:0") != NULL);
    f.nbusy = 2;
    f.busy[0] = 1;
    f.busy[1] = 0;
    CHECK(visit(&f, 3) == D1_OK); /* busy: wait */
    CHECK(f.obj.state == D1_STATE_WIN_SOUND && f.phase == 1u);
    CHECK(visit(&f, 3) == D1_OK); /* not busy: stop record 1; the sound flag byte is 0 -> finish */
    CHECK(f.phase == 2u && strstr(f.log, "stop:1:0") != NULL);
}

static void t_render_plan_and_cleanup(void)
{
    Fx f;
    D1RenderPlan plan;
    fx_init(&f, 2);
    CHECK(d1_render_plan(&f.obj, f.body, D1_BODY_BYTES, &plan) == D1_OK && plan.valid == 0);
    start(&f);
    CHECK(d1_render_plan(&f.obj, f.body, D1_BODY_BYTES, &plan) == D1_OK);
    CHECK(plan.valid == 1 && plan.count == 2 && plan.surface == 77u && plan.dst[0][0] == 15 && plan.src[1][0] == 21);
    CHECK(d1_invalidate(&f.obj, &f.host) == D1_OK);
    CHECK_LOG(&f, "dirty:24");
    f.log[0] = '\0';
    CHECK(d1_cleanup(&f.obj, &f.host) == D1_OK);
    CHECK_LOG(&f, "relsurf:77:0,relslot:24:0");
    CHECK(d1_render_plan(&f.obj, f.body, D1_BODY_BYTES, &plan) == D1_OK && plan.valid == 0);
    f.log[0] = '\0';
    CHECK(d1_invalidate(&f.obj, &f.host) == D1_OK && f.log[0] == '\0'); /* inactive */
    CHECK(d1_cleanup(&f.obj, &f.host) == D1_OK && f.log[0] == '\0');    /* idempotent */
}

static void t_phase2_flag_refused_before_effects(void)
{
    Fx f;
    fx_init(&f, 1);
    put16(f.body, 0x27, 2);
    put16(f.body, 0x30a, 2);
    put16(f.body, 0x340, 500); /* beyond the host's flag table */
    start(&f);
    CHECK(visit(&f, 3) == D1_OK && visit(&f, 3) == D1_OK && f.phase == 2u);
    f.log[0] = '\0';
    CHECK(visit(&f, 3) == D1_ERR_BOUNDS);
    CHECK(f.log[0] == '\0' && f.obj.active == 1);
    f.body[0x340] = 5;
    f.body[0x341] = 0;
    f.fail_flag = 1; /* the host refuses after the transition went out */
    CHECK(visit(&f, 3) == D1_ERR_HOST);
}

static void t_other_phase_is_ignored(void)
{
    Fx f;
    fx_init(&f, 2);
    start(&f);
    f.phase = 7u;
    CHECK(visit(&f, 3) == D1_OK && f.phase == 7u && f.log[0] == '\0');
}

typedef void (*TestFn)(void);
static void run(const char *name, TestFn fn)
{
    g_name = name;
    g_failed = 0;
    g_msg[0] = '\0';
    fn();
    ++g_total;
    if (g_failed) {
        ++g_failures;
        printf("FAIL %s: %s\n", name, g_msg);
    } else {
        printf("PASS %s\n", name);
    }
}

int main(void)
{
    run("validate_body", t_validate);
    run("geometry", t_geometry);
    run("phase0", t_phase0);
    run("phase0_failure", t_phase0_failure);
    run("solved_finishes", t_solved_finishes);
    run("click_turns_tile", t_click_turns_tile);
    run("busy_sound_blocks_click", t_busy_sound_blocks_click);
    run("links_turn_together", t_links_turn_together);
    run("frame_wraps_and_deadline", t_frame_wraps_and_deadline);
    run("exit_click", t_exit_click);
    run("pointer", t_pointer);
    run("exit_without_scene", t_exit_without_scene);
    run("click_without_tile_is_refused", t_click_without_tile_is_refused);
    run("auto_turn", t_auto_turn_when_solved_and_sound_flag);
    run("win_sound_branch", t_win_sound_branch);
    run("render_plan_and_cleanup", t_render_plan_and_cleanup);
    run("phase2_flag_refused_before_effects", t_phase2_flag_refused_before_effects);
    run("other_phase_is_ignored", t_other_phase_is_ignored);
    printf("TOTAL %d FAILED %d\n", g_total, g_failures);
    return g_failures;
}
