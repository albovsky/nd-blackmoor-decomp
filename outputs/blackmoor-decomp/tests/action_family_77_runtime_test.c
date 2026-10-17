/* RT-49 unit tests of the raw 0x77 Ordering Puzzle kernel (src/action_family_77_runtime.c). Prints
 * "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure count. Fixtures are synthetic bodies (no
 * original bytes). tests/test_action_family_77_runtime.py builds and runs this with and without ASan/UBSan and under
 * source mutations. */
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_77_runtime.h"
#include "scene_resource.h"
#include "session_bindings_a77.h"

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
    A77State st;
    A77World world;
    A77Host host;
    uint8_t body[A77_BODY_BYTES];
    char log[4096];
    int32_t rand_value;
    uint32_t ticks[8];
    int nticks, iticks;
    int32_t busy[8];
    int nbusy, ibusy;
    int fail_load, fail_release, fail_prepare, fail_stop, fail_play, fail_busy, fail_transition, fail_flag, fail_origin;
    int32_t vx, vy;
    uint32_t phase;
    int completed;
    int n_stop;
    int world_stores;
    int32_t world_value;
} Fx;

static void put16(uint8_t *b, size_t off, int v) { b[off] = (uint8_t)v; b[off + 1] = (uint8_t)(v >> 8); }
static void put32(uint8_t *b, size_t off, int32_t v)
{
    for (int i = 0; i < 4; ++i) b[off + (size_t)i] = (uint8_t)((uint32_t)v >> (8 * i));
}

static void logf_(Fx *f, const char *fmt, ...)
{
    char tmp[128];
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(tmp, sizeof tmp, fmt, ap);
    va_end(ap);
    if (f->log[0] != '\0') strncat(f->log, ",", sizeof f->log - strlen(f->log) - 1u);
    strncat(f->log, tmp, sizeof f->log - strlen(f->log) - 1u);
}

static const char *const effect_names[] = {"?", "active", "start", "rand", "relsurf", "load", "ovsurf", "ovact",
                                           "prep", "stop", "play", "busy", "tick", "step", "phase", "evflag",
                                           "x57b", "x599", "x595", "x39ff", "x59b", "x59f", "x5a3", "mode",
                                           "complete"};

static void observe(void *c, int e, int32_t a, int32_t b) { logf_((Fx *)c, "%s:%d:%d", effect_names[e], a, b); }
static int32_t h_random(void *c) { return ((Fx *)c)->rand_value; }
static int h_load(void *c, const char *name, uint32_t *surface)
{
    Fx *f = (Fx *)c;
    if (f->fail_load || strcmp(name, "ORDER") != 0) return 1;
    *surface = 77u;
    return 0;
}
static int h_release(void *c, uint32_t s) { (void)s; return ((Fx *)c)->fail_release; }
static int h_prepare(void *c, const uint8_t *r) { (void)r; return ((Fx *)c)->fail_prepare; }
static int h_stop(void *c, const uint8_t *r)
{
    (void)r;
    ++((Fx *)c)->n_stop;
    return ((Fx *)c)->fail_stop;
}
static int h_play(void *c, int16_t ch) { (void)ch; return ((Fx *)c)->fail_play; }
static int h_busy(void *c, int16_t ch, int32_t *r)
{
    Fx *f = (Fx *)c;
    (void)ch;
    if (f->fail_busy) return 1;
    *r = f->ibusy < f->nbusy ? f->busy[f->ibusy++] : 0;
    return 0;
}
static uint32_t h_tick(void *c)
{
    Fx *f = (Fx *)c;
    return f->iticks < f->nticks ? f->ticks[f->iticks++] : f->ticks[f->nticks - 1];
}
static int h_flag_invalid(void *c, int16_t i) { (void)c; return i < 0 || i >= 100; }
static int h_transition(void *c, const A77Transition *t)
{
    Fx *f = (Fx *)c;
    if (f->fail_transition) return 1;
    logf_(f, "tr:%d:%d:%d:%d:%d:%d:%d", t->scene, t->word[0], t->word[1], t->word[2], t->dword[0], t->dword[1],
          t->dword[2]);
    return 0;
}
static int h_store_flag(void *c, int16_t i, uint32_t v)
{
    Fx *f = (Fx *)c;
    if (f->fail_flag) return 1;
    logf_(f, "sf:%d:%u", i, v);
    return 0;
}
static int h_origin(void *c, int32_t *x, int32_t *y)
{
    Fx *f = (Fx *)c;
    if (f->fail_origin) return 1;
    *x = f->vx;
    *y = f->vy;
    return 0;
}

static void set_block(uint8_t *b, size_t off, int scene, int w1, int w2, int w3, int32_t d1, int32_t d2, int32_t d3,
                      int start)
{
    put16(b, off, scene);
    put16(b, off + 2, w1);
    put16(b, off + 4, w2);
    put16(b, off + 6, w3);
    put32(b, off + 8, d1);
    put32(b, off + 12, d2);
    put32(b, off + 16, d3);
    put16(b, off + 20, start);
}

static void set_rec(uint8_t *b, size_t off, const char *name)
{
    memset(b + off, 0, 9);
    memcpy(b + off, name, strlen(name));
}

/* N = 4 buttons: button i rectangle (view relative) x 20i..20i+9, y 0..9; selected source (100+10i, 200+i, 109+10i,
 * 209+i). Solution length 3: buttons 2, 0, 1. Sound A "SNDA" (channel 5 for the click), solved block scene 40, event
 * flag 7 := 3 after 2 s, sound B "SNDB" channel 9, exit block scene 50 with flag 8 := 9, exit rectangle x 100..110,
 * y 50..60. */
static void body_init(Fx *f)
{
    uint8_t *b = f->body;
    memset(b, 0, A77_BODY_BYTES);
    memcpy(b, "ORDER", 6);
    put16(b, 0x21, 4);
    for (int i = 0; i < 4; ++i) {
        put32(b, 0x23 + 16u * (unsigned)i, 100 + 10 * i);
        put32(b, 0x23 + 16u * (unsigned)i + 4, 200 + i);
        put32(b, 0x23 + 16u * (unsigned)i + 8, 109 + 10 * i);
        put32(b, 0x23 + 16u * (unsigned)i + 12, 209 + i);
        put32(b, 0x123 + 16u * (unsigned)i, 20 * i);
        put32(b, 0x123 + 16u * (unsigned)i + 4, 0);
        put32(b, 0x123 + 16u * (unsigned)i + 8, 20 * i + 9);
        put32(b, 0x123 + 16u * (unsigned)i + 12, 9);
    }
    put16(b, 0x223, 3);
    b[0x225] = 2;
    b[0x226] = 0;
    b[0x227] = 1;
    set_rec(b, 0x235, "SNDA");
    put16(b, 0x256, 5);
    set_block(b, 0x266, 40, 1, 2, 3, 11, 22, 33, 1);
    put16(b, 0x27c, 7);
    b[0x27e] = 3;
    put16(b, 0x27f, 2);
    set_rec(b, 0x281, "SNDB");
    put16(b, 0x2a2, 9);
    set_block(b, 0x2b2, 50, 4, 5, 6, 44, 55, 66, 0);
    put16(b, 0x2c8, 8);
    b[0x2ca] = 9;
    put32(b, 0x2cb, 100);
    put32(b, 0x2cf, 50);
    put32(b, 0x2d3, 110);
    put32(b, 0x2d7, 60);
}

static void fx_init(Fx *f)
{
    memset(f, 0, sizeof(*f));
    a77_state_reset(&f->st);
    f->host.context = f;
    f->host.random = h_random;
    f->host.load_surface = h_load;
    f->host.release_surface = h_release;
    f->host.sound_prepare = h_prepare;
    f->host.sound_stop = h_stop;
    f->host.sound_play = h_play;
    f->host.sound_busy = h_busy;
    f->host.tick = h_tick;
    f->host.event_flag_invalid = h_flag_invalid;
    f->host.transition = h_transition;
    f->host.store_event_flag = h_store_flag;
    f->host.view_origin = h_origin;
    f->host.observe = observe;
    f->rand_value = 7;
    f->ticks[0] = 1000u;
    f->nticks = 1;
    f->vx = 10;
    f->vy = 20;
    body_init(f);
}

static int visit_row(Fx *f, int16_t row, uint32_t phase)
{
    A77Result r;
    const char *why = NULL;
    const int rc = a77_step(&f->st, f->body, A77_BODY_BYTES, row, phase, &f->world, &f->host, &r, &why);
    f->phase = r.phase_after;
    f->completed = r.completed;
    return rc;
}
static int visit(Fx *f, uint32_t phase) { return visit_row(f, 3, phase); }

/* Phase 0 on row 3, then forget the log. */
static void start(Fx *f)
{
    CHECK(visit(f, 0) == A77_OK && f->phase == 1u);
    f->log[0] = '\0';
}

/* Phase 1 reached with the inner state `step`. */
static void at_step(Fx *f, uint32_t step)
{
    start(f);
    f->st.step = step;
}

static int pointer(Fx *f, int32_t x, int32_t y, A77PointerResult *out)
{
    return a77_pointer(&f->st, f->body, A77_BODY_BYTES, x, y, out);
}
static int click(Fx *f, int32_t candidate, int32_t start_flag, A77ClickResult *out)
{
    return a77_click(&f->st, f->body, A77_BODY_BYTES, 1u, candidate, start_flag, &f->host, out);
}
/* Hover button h then a button click. */
static int press(Fx *f, int16_t h, int32_t start_flag)
{
    A77ClickResult c;
    f->st.hover = h;
    return click(f, A77_CANDIDATE_BUTTON, start_flag, &c);
}

static void t_validate(void)
{
    Fx f;
    const char *why = NULL;
    fx_init(&f);
    CHECK(a77_validate_body(f.body, A77_BODY_BYTES, &why) == A77_OK && why == NULL);
    CHECK(a77_validate_body(f.body, A77_BODY_BYTES, NULL) == A77_OK);
    CHECK(a77_validate_body(f.body, A77_BODY_BYTES - 1u, &why) == A77_ERR_BODY && strcmp(why, "0x77-body-length") == 0);
    CHECK(a77_validate_body(f.body, A77_BODY_BYTES + 1u, &why) == A77_ERR_BODY);
    CHECK(a77_validate_body(NULL, A77_BODY_BYTES, &why) == A77_ERR_BODY);
    put16(f.body, 0x21, 17);
    CHECK(a77_validate_body(f.body, A77_BODY_BYTES, &why) == A77_ERR_BODY && strcmp(why, "0x77-button-count") == 0);
    put16(f.body, 0x21, 16);
    CHECK(a77_validate_body(f.body, A77_BODY_BYTES, &why) == A77_OK);
    put16(f.body, 0x21, 0);
    CHECK(a77_validate_body(f.body, A77_BODY_BYTES, &why) == A77_OK);
    put16(f.body, 0x21, -1);
    CHECK(a77_validate_body(f.body, A77_BODY_BYTES, &why) == A77_ERR_BODY);
    put16(f.body, 0x21, 4);
    put16(f.body, 0x223, 17);
    CHECK(a77_validate_body(f.body, A77_BODY_BYTES, &why) == A77_ERR_BODY && strcmp(why, "0x77-solution-length") == 0);
    put16(f.body, 0x223, 16);
    CHECK(a77_validate_body(f.body, A77_BODY_BYTES, &why) == A77_OK);
    put16(f.body, 0x223, -1);
    CHECK(a77_validate_body(f.body, A77_BODY_BYTES, &why) == A77_ERR_BODY);
    put16(f.body, 0x223, 3);
    memset(f.body, 'x', 0x21); /* name without its terminator */
    CHECK(a77_validate_body(f.body, A77_BODY_BYTES, &why) == A77_ERR_BODY && strcmp(why, "0x77-name-unterminated") == 0);
    body_init(&f);
    f.body[0x20] = 0; /* terminator in the very last name byte */
    memset(f.body, 'x', 0x20);
    CHECK(a77_validate_body(f.body, A77_BODY_BYTES, &why) == A77_OK);
}

static void t_reset(void)
{
    A77State s;
    memset(&s, 0xa5, sizeof s);
    a77_state_reset(&s);
    for (size_t i = 0; i < sizeof s; ++i) CHECK(((const uint8_t *)&s)[i] == 0u);
    a77_state_reset(NULL);
}

static void t_phase0(void)
{
    Fx f;
    fx_init(&f);
    f.st.surface = 0u;
    f.world.start_flag_5bb1ca = 0;
    memset(f.st.selected, 9, sizeof f.st.selected);
    f.st.solved = 1u;
    f.st.exit_requested = 1u;
    f.st.count = 9;
    f.st.step = 3u;
    CHECK(visit(&f, 0) == A77_OK);
    CHECK_LOG(&f, "active:1:0,start:1:0,rand:7:0,relsurf:0:0,load:77:0,ovsurf:77:0,ovact:1:0,prep:565:0,step:0:0,phase:1:0");
    CHECK(f.phase == 1u && f.completed == 0);
    CHECK(f.st.active == 1u && f.st.row == 3 && f.st.exit_requested == 0u && f.st.solved == 0u);
    CHECK(f.st.count == 0 && f.st.limit == 4 && f.st.step == 0u && f.st.initialized == 1u);
    CHECK(f.st.surface == 77u && f.st.overlay_surface == 77u && f.st.overlay_active == 1u);
    CHECK(f.world.start_flag_5bb1ca == 1);
    for (int i = 0; i < 16; ++i) CHECK(f.st.selected[i] == 0u && f.st.order[i] == -1);
}

static void t_phase0_limit(void)
{
    Fx f;
    /* limit = min(N, L + r) with r = rand % 5 and 0, 1 -> 2. L = 3, N = 4 gives 4 for r >= 1; use N = 8 to see the sum. */
    const struct { int32_t rnd; int n; int expect; } cases[] = {
        {0, 8, 5}, {1, 8, 5}, {2, 8, 5}, {3, 8, 6}, {4, 8, 7}, {5, 8, 5}, {6, 8, 5}, {32767, 8, 5}, {32766, 8, 5},
        {32763, 8, 6}, {-3, 8, 0}, {-1, 8, 2}, {4, 5, 5}, {3, 6, 6}, {3, 5, 5}, {4, 3, 3}, {0, 4, 4}, {3, 0, 0}};
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        fx_init(&f);
        f.rand_value = cases[i].rnd;
        put16(f.body, 0x21, cases[i].n);
        CHECK(visit(&f, 0) == A77_OK);
        if (f.st.limit != cases[i].expect && !g_failed) {
            g_failed = 1;
            snprintf(g_msg, sizeof g_msg, "rand %d N %d: limit %d != %d", cases[i].rnd, cases[i].n, f.st.limit,
                     cases[i].expect);
        }
    }
    /* the random effect carries the raw value */
    fx_init(&f);
    f.rand_value = 32765;
    CHECK(visit(&f, 0) == A77_OK && strstr(f.log, "rand:32765:0") != NULL);
}

static void t_phase0_sound_and_release(void)
{
    Fx f;
    fx_init(&f);
    set_rec(f.body, 0x235, "NO SOUND");
    CHECK(visit(&f, 0) == A77_OK && strstr(f.log, "prep") == NULL);
    /* the compare is 9 bytes: a record that differs only in the last byte is a sound */
    fx_init(&f);
    set_rec(f.body, 0x235, "NO SOUND");
    f.body[0x235 + 8] = 1;
    CHECK(visit(&f, 0) == A77_OK && strstr(f.log, "prep:565:0") != NULL);
    /* and one that differs in the first byte */
    fx_init(&f);
    set_rec(f.body, 0x235, "NO SOUND");
    f.body[0x235] = 'M';
    CHECK(visit(&f, 0) == A77_OK && strstr(f.log, "prep:565:0") != NULL);
    /* a handle held from an earlier visit is released first and reported */
    fx_init(&f);
    f.st.surface = 55u;
    CHECK(visit(&f, 0) == A77_OK && strstr(f.log, "rand:7:0,relsurf:55:0,load:77:0") != NULL);
    CHECK(f.st.surface == 77u);
}

static void t_phase0_failure(void)
{
    Fx f;
    A77Result r;
    const char *why = NULL;
    fx_init(&f);
    f.fail_load = 1;
    CHECK(visit(&f, 0) == A77_ERR_HOST && f.phase == 0u && f.st.initialized == 0u);
    fx_init(&f);
    f.fail_release = 1;
    CHECK(visit(&f, 0) == A77_ERR_HOST && f.st.initialized == 0u);
    fx_init(&f);
    f.fail_prepare = 1;
    CHECK(visit(&f, 0) == A77_ERR_HOST && f.st.initialized == 0u);
    /* argument and validation refusals come before the first effect */
    fx_init(&f);
    f.host.random = NULL;
    CHECK(a77_step(&f.st, f.body, A77_BODY_BYTES, 3, 0, &f.world, &f.host, &r, &why) == A77_ERR_ARGUMENT);
    CHECK(f.log[0] == '\0' && f.st.active == 0u);
    fx_init(&f);
    f.host.event_flag_invalid = NULL;
    CHECK(a77_step(&f.st, f.body, A77_BODY_BYTES, 3, 0, &f.world, &f.host, &r, &why) == A77_ERR_ARGUMENT);
    fx_init(&f);
    f.host.store_event_flag = NULL;
    CHECK(a77_step(&f.st, f.body, A77_BODY_BYTES, 3, 0, &f.world, &f.host, &r, &why) == A77_ERR_ARGUMENT);
    fx_init(&f);
    f.host.transition = NULL;
    CHECK(a77_step(&f.st, f.body, A77_BODY_BYTES, 3, 0, &f.world, &f.host, &r, &why) == A77_ERR_ARGUMENT);
    fx_init(&f);
    f.host.sound_busy = NULL;
    CHECK(a77_step(&f.st, f.body, A77_BODY_BYTES, 3, 0, &f.world, &f.host, &r, &why) == A77_ERR_ARGUMENT);
    fx_init(&f);
    f.host.view_origin = NULL; /* the render plan alone uses it */
    CHECK(a77_step(&f.st, f.body, A77_BODY_BYTES, 3, 0, &f.world, &f.host, &r, &why) == A77_OK);
    fx_init(&f);
    f.host.observe = NULL; /* the observer is optional */
    CHECK(a77_step(&f.st, f.body, A77_BODY_BYTES, 3, 0, &f.world, &f.host, &r, &why) == A77_OK);
    CHECK(a77_step(&f.st, f.body, A77_BODY_BYTES, 3, 0, &f.world, NULL, &r, &why) == A77_ERR_ARGUMENT);
    CHECK(a77_step(NULL, f.body, A77_BODY_BYTES, 3, 0, &f.world, &f.host, &r, &why) == A77_ERR_ARGUMENT);
    CHECK(a77_step(&f.st, NULL, A77_BODY_BYTES, 3, 0, &f.world, &f.host, &r, &why) == A77_ERR_ARGUMENT);
    CHECK(a77_step(&f.st, f.body, A77_BODY_BYTES, 3, 0, NULL, &f.host, &r, &why) == A77_ERR_ARGUMENT);
    CHECK(a77_step(&f.st, f.body, A77_BODY_BYTES, 3, 0, &f.world, &f.host, NULL, &why) == A77_ERR_ARGUMENT);
    fx_init(&f);
    CHECK(a77_step(&f.st, f.body, A77_BODY_BYTES - 1u, 3, 0, &f.world, &f.host, &r, &why) == A77_ERR_BODY);
    CHECK(strcmp(why, "0x77-body-length") == 0 && f.log[0] == '\0' && r.phase_after == 0u);
    CHECK(a77_step(&f.st, f.body, A77_BODY_BYTES, -1, 0, &f.world, &f.host, &r, &why) == A77_ERR_ARGUMENT);
    CHECK(f.log[0] == '\0');
}

static void t_step0_solved_detection(void)
{
    Fx f;
    fx_init(&f);
    start(&f);
    f.st.order[0] = 2;
    f.st.order[1] = 0;
    f.st.order[2] = 1;
    f.st.count = 3;
    CHECK(visit(&f, 1) == A77_OK && f.phase == 1u);
    CHECK_LOG(&f, "step:1:0");
    CHECK(f.st.solved == 1u && f.st.step == 1u);
    /* a wrong last entry is not solved */
    fx_init(&f);
    start(&f);
    f.st.order[0] = 2;
    f.st.order[1] = 0;
    f.st.order[2] = 3;
    f.st.count = 3;
    CHECK(visit(&f, 1) == A77_OK && f.st.solved == 0u && f.st.step == 0u && f.log[0] == '\0');
    /* a wrong first entry */
    f.st.order[0] = 1;
    f.st.order[2] = 1;
    CHECK(visit(&f, 1) == A77_OK && f.st.solved == 0u);
    /* entries beyond L are not compared */
    fx_init(&f);
    start(&f);
    f.st.order[0] = 2;
    f.st.order[1] = 0;
    f.st.order[2] = 1;
    f.st.order[3] = 3;
    CHECK(visit(&f, 1) == A77_OK && f.st.solved == 1u);
    /* L = 0 is solved at once */
    fx_init(&f);
    put16(f.body, 0x223, 0);
    start(&f);
    CHECK(visit(&f, 1) == A77_OK && f.st.solved == 1u && f.st.step == 1u);
    /* a solution byte above 127 is an unsigned byte against the signed word: 0xff never equals -1 */
    fx_init(&f);
    put16(f.body, 0x223, 1);
    f.body[0x225] = 0xff;
    start(&f);
    CHECK(visit(&f, 1) == A77_OK && f.st.solved == 0u);
    f.st.order[0] = 255;
    CHECK(visit(&f, 1) == A77_OK && f.st.solved == 1u);
    /* L = 16 compares all sixteen */
    fx_init(&f);
    put16(f.body, 0x223, 16);
    for (int i = 0; i < 16; ++i) f.body[0x225 + i] = (uint8_t)i;
    start(&f);
    for (int i = 0; i < 16; ++i) f.st.order[i] = (int16_t)i;
    CHECK(visit(&f, 1) == A77_OK && f.st.solved == 1u);
    f.st.step = 0u;
    f.st.order[15] = 14;
    CHECK(visit(&f, 1) == A77_OK && f.st.solved == 0u);
}

static void t_step0_unsolved_reset(void)
{
    Fx f;
    fx_init(&f);
    start(&f); /* limit 4 */
    f.st.order[0] = 1;
    f.st.order[1] = 2;
    f.st.order[2] = 3;
    f.st.selected[1] = f.st.selected[2] = f.st.selected[3] = 1;
    f.st.count = 3; /* below the limit: kept */
    CHECK(visit(&f, 1) == A77_OK && f.st.count == 3 && f.st.order[0] == 1 && f.st.selected[2] == 1u);
    f.st.count = 4; /* == limit: reset */
    CHECK(visit(&f, 1) == A77_OK && f.st.count == 0 && f.st.solved == 0u);
    for (int i = 0; i < 16; ++i) CHECK(f.st.order[i] == -1 && f.st.selected[i] == 0u);
    CHECK(f.log[0] == '\0' && f.phase == 1u && f.st.step == 0u);
    /* count above the limit also resets; the compare is signed */
    f.st.order[0] = 1;
    f.st.selected[0] = 1;
    f.st.count = 5;
    CHECK(visit(&f, 1) == A77_OK && f.st.count == 0 && f.st.order[0] == -1);
    f.st.order[0] = 1;
    f.st.count = -1;
    f.st.limit = 0;
    CHECK(visit(&f, 1) == A77_OK && f.st.count == -1 && f.st.order[0] == 1);
    f.st.count = 0;
    CHECK(visit(&f, 1) == A77_OK && f.st.count == 0 && f.st.order[0] == -1); /* 0 >= 0 */
    /* a solved check wins over the reset */
    fx_init(&f);
    start(&f);
    f.st.order[0] = 2;
    f.st.order[1] = 0;
    f.st.order[2] = 1;
    f.st.count = 4;
    CHECK(visit(&f, 1) == A77_OK && f.st.solved == 1u && f.st.order[0] == 2 && f.st.count == 4);
}

static void t_step1_flag_and_deadline(void)
{
    Fx f;
    fx_init(&f);
    at_step(&f, 1);
    f.ticks[0] = 5000u;
    CHECK(visit(&f, 1) == A77_OK && f.phase == 1u);
    CHECK_LOG(&f, "sf:7:3,evflag:7:3,tick:5000:0,step:2:0");
    CHECK(f.st.deadline == 7000u && f.st.step == 2u);
    /* no event flag: the word is -1 */
    fx_init(&f);
    put16(f.body, 0x27c, -1);
    at_step(&f, 1);
    CHECK(visit(&f, 1) == A77_OK);
    CHECK_LOG(&f, "tick:1000:0,step:2:0");
    /* flag index 0 is a flag; the signed word -1 is the only "none" */
    fx_init(&f);
    put16(f.body, 0x27c, 0);
    at_step(&f, 1);
    CHECK(visit(&f, 1) == A77_OK && strncmp(f.log, "sf:0:3,evflag:0:3", 17) == 0);
    /* byte value is unsigned */
    fx_init(&f);
    f.body[0x27e] = 0xf0;
    at_step(&f, 1);
    CHECK(visit(&f, 1) == A77_OK && strncmp(f.log, "sf:7:240,evflag:7:240", 21) == 0);
    /* delay is a signed word of seconds; the deadline wraps like the 32-bit add */
    fx_init(&f);
    put16(f.body, 0x27f, -1);
    f.ticks[0] = 5000u;
    at_step(&f, 1);
    CHECK(visit(&f, 1) == A77_OK && f.st.deadline == 4000u);
    fx_init(&f);
    put16(f.body, 0x27f, 32767);
    f.ticks[0] = 0xffffffffu - 1000u;
    at_step(&f, 1);
    CHECK(visit(&f, 1) == A77_OK && f.st.deadline == (uint32_t)(0xffffffffu - 1000u + 32767000u));
    fx_init(&f);
    put16(f.body, 0x27f, 0);
    at_step(&f, 1);
    CHECK(visit(&f, 1) == A77_OK && f.st.deadline == 1000u);
    /* an index the host cannot store is refused before any effect */
    fx_init(&f);
    put16(f.body, 0x27c, 500);
    at_step(&f, 1);
    CHECK(visit(&f, 1) == A77_ERR_BOUNDS);
    CHECK(f.log[0] == '\0' && f.st.step == 1u && f.phase == 1u);
    put16(f.body, 0x27c, -2);
    CHECK(visit(&f, 1) == A77_ERR_BOUNDS);
    /* the index check is only for a visit that stores */
    fx_init(&f);
    put16(f.body, 0x27c, 500);
    at_step(&f, 0);
    f.st.order[0] = 0;
    CHECK(visit(&f, 1) == A77_OK);
    /* the host refusing the store */
    fx_init(&f);
    at_step(&f, 1);
    f.fail_flag = 1;
    CHECK(visit(&f, 1) == A77_ERR_HOST && f.st.step == 1u && f.log[0] == '\0');
}

static void t_step2_timer_and_sound(void)
{
    Fx f;
    fx_init(&f);
    at_step(&f, 2);
    f.st.deadline = 5000u;
    f.ticks[0] = 4999u; /* below: nothing */
    CHECK(visit(&f, 1) == A77_OK && f.phase == 1u && f.st.step == 2u);
    CHECK_LOG(&f, "tick:4999:0");
    f.log[0] = '\0';
    f.ticks[0] = 5000u; /* equal fires */
    f.iticks = 0;
    CHECK(visit(&f, 1) == A77_OK && f.phase == 1u && f.st.step == 3u);
    CHECK_LOG(&f, "tick:5000:0,prep:641:0,play:9:0,step:3:0");
    /* above */
    fx_init(&f);
    at_step(&f, 2);
    f.st.deadline = 5000u;
    f.ticks[0] = 90000u;
    CHECK(visit(&f, 1) == A77_OK && f.st.step == 3u);
    /* the compare is unsigned: now = 5, deadline = 0xffffff00 is still waiting; now = 0xffffff01 fires */
    fx_init(&f);
    at_step(&f, 2);
    f.st.deadline = 0xffffff00u;
    f.ticks[0] = 5u;
    CHECK(visit(&f, 1) == A77_OK && f.st.step == 2u);
    f.iticks = 0;
    f.ticks[0] = 0xffffff01u;
    CHECK(visit(&f, 1) == A77_OK && f.st.step == 3u);
    /* no win sound: straight to phase 2 with no sound step */
    fx_init(&f);
    set_rec(f.body, 0x281, "NO SOUND");
    at_step(&f, 2);
    f.st.deadline = 0u;
    CHECK(visit(&f, 1) == A77_OK && f.phase == 2u && f.st.step == 2u);
    CHECK_LOG(&f, "tick:1000:0,phase:2:0");
    /* the record compare is 9 bytes */
    fx_init(&f);
    set_rec(f.body, 0x281, "NO SOUND");
    f.body[0x281 + 8] = 7;
    at_step(&f, 2);
    f.st.deadline = 0u;
    CHECK(visit(&f, 1) == A77_OK && f.phase == 1u && f.st.step == 3u);
    /* failures */
    fx_init(&f);
    at_step(&f, 2);
    f.st.deadline = 0u;
    f.fail_prepare = 1;
    CHECK(visit(&f, 1) == A77_ERR_HOST && f.st.step == 2u);
    fx_init(&f);
    at_step(&f, 2);
    f.st.deadline = 0u;
    f.fail_play = 1;
    CHECK(visit(&f, 1) == A77_ERR_HOST && f.st.step == 2u);
}

static void t_step3_sound_busy(void)
{
    Fx f;
    fx_init(&f);
    at_step(&f, 3);
    f.busy[0] = 1;
    f.busy[1] = -5;
    f.nbusy = 2;
    CHECK(visit(&f, 1) == A77_OK && f.phase == 1u);
    CHECK_LOG(&f, "busy:9:1");
    CHECK(visit(&f, 1) == A77_OK && f.phase == 1u && f.st.step == 3u); /* any nonzero result: still playing */
    f.log[0] = '\0';
    CHECK(visit(&f, 1) == A77_OK && f.phase == 2u);
    CHECK_LOG(&f, "busy:9:0,stop:641:0,phase:2:0");
    /* "NO SOUND" in record B does not stop the stop (the original tests only the busy result) */
    fx_init(&f);
    set_rec(f.body, 0x281, "NO SOUND");
    at_step(&f, 3);
    CHECK(visit(&f, 1) == A77_OK && f.phase == 2u && strstr(f.log, "stop:641:0") != NULL && f.n_stop == 1);
    fx_init(&f);
    at_step(&f, 3);
    f.fail_busy = 1;
    CHECK(visit(&f, 1) == A77_ERR_HOST);
    fx_init(&f);
    at_step(&f, 3);
    f.fail_stop = 1;
    CHECK(visit(&f, 1) == A77_ERR_HOST && f.phase == 1u);
}

static void t_step_out_of_range(void)
{
    Fx f;
    const uint32_t steps[] = {4u, 5u, 0x80000000u, 0xffffffffu};
    for (size_t i = 0; i < sizeof steps / sizeof steps[0]; ++i) {
        fx_init(&f);
        at_step(&f, steps[i]);
        f.st.order[0] = 2;
        f.st.order[1] = 0;
        f.st.order[2] = 1;
        CHECK(visit(&f, 1) == A77_OK && f.phase == 1u && f.log[0] == '\0' && f.st.step == steps[i]);
    }
}

static void t_other_phase_is_ignored(void)
{
    Fx f;
    fx_init(&f);
    start(&f);
    f.st.step = 1u; /* phase 1 would store the flag and arm the timer */
    CHECK(visit(&f, 3) == A77_OK && f.phase == 3u && f.log[0] == '\0' && f.completed == 0 && f.st.step == 1u);
    CHECK(visit(&f, 0xffffffffu) == A77_OK && f.phase == 0xffffffffu && f.log[0] == '\0');
    CHECK(f.st.active == 1u);
}

static void t_phase12_need_phase0(void)
{
    Fx f;
    fx_init(&f);
    CHECK(visit(&f, 1) == A77_ERR_UNSUPPORTED && f.log[0] == '\0' && f.phase == 1u);
    CHECK(visit(&f, 2) == A77_ERR_UNSUPPORTED && f.log[0] == '\0' && f.phase == 2u);
    start(&f);
    CHECK(visit_row(&f, 4, 1) == A77_ERR_UNSUPPORTED && f.log[0] == '\0');
    CHECK(visit_row(&f, 4, 2) == A77_ERR_UNSUPPORTED && f.log[0] == '\0');
    CHECK(visit_row(&f, 3, 1) == A77_OK);
    /* a scene clear forgets the initialisation */
    CHECK(a77_clear(&f.st, &f.host) == A77_OK);
    f.log[0] = '\0';
    CHECK(visit(&f, 1) == A77_ERR_UNSUPPORTED && f.log[0] == '\0');
    CHECK(visit(&f, 2) == A77_ERR_UNSUPPORTED);
}

static void t_phase2_solved(void)
{
    Fx f;
    fx_init(&f);
    start(&f);
    f.st.solved = 1u;
    CHECK(visit(&f, 2) == A77_OK && f.completed == 1 && f.phase == 0u);
    CHECK_LOG(&f, "start:1:0,active:0:0,relsurf:77:0,ovact:0:0,stop:565:0,tr:40:1:2:3:11:22:33,x57b:40:0,x599:1:0,"
                  "x595:2:0,x39ff:3:0,x59b:11:0,x59f:22:0,x5a3:33:0,start:0:0,mode:4:0,complete:3:0");
    CHECK(f.st.active == 0u && f.st.surface == 0u && f.st.overlay_active == 0u && f.st.overlay_surface == 77u);
    CHECK(f.world.start_flag_5bb1ca == 0);
    /* a start-flag word other than 1 stores 1 */
    fx_init(&f);
    put16(f.body, 0x27a, 2);
    start(&f);
    CHECK(visit(&f, 2) == A77_OK && f.world.start_flag_5bb1ca == 1 && strstr(f.log, "start:1:0,mode:4:0") != NULL);
    fx_init(&f);
    put16(f.body, 0x27a, 0);
    start(&f);
    CHECK(visit(&f, 2) == A77_OK && f.world.start_flag_5bb1ca == 1);
    /* a negative scene is a scene; 9999 is none */
    fx_init(&f);
    put16(f.body, 0x266, -1);
    start(&f);
    CHECK(visit(&f, 2) == A77_OK && strstr(f.log, "tr:-1:") != NULL);
    fx_init(&f);
    put16(f.body, 0x266, 9999);
    start(&f);
    f.world.start_flag_5bb1ca = 0;
    CHECK(visit(&f, 2) == A77_OK);
    CHECK_LOG(&f, "start:1:0,active:0:0,relsurf:77:0,ovact:0:0,stop:565:0,complete:3:0");
    CHECK(f.world.start_flag_5bb1ca == 1 && f.completed == 1);
    /* the solved path stores no event flag even though one is set for phase 1 and the exit */
    CHECK(strstr(f.log, "sf:") == NULL);
    /* no scene 9999 but no sound either */
    fx_init(&f);
    set_rec(f.body, 0x235, "NO SOUND");
    start(&f);
    CHECK(visit(&f, 2) == A77_OK && strstr(f.log, "stop:") == NULL);
    /* dwords keep their sign */
    fx_init(&f);
    set_block(f.body, 0x266, 40, -1, -2, -3, -4, -5, -6, 1);
    start(&f);
    CHECK(visit(&f, 2) == A77_OK && strstr(f.log, "tr:40:-1:-2:-3:-4:-5:-6") != NULL);
}

static void t_phase2_exit(void)
{
    Fx f;
    fx_init(&f);
    start(&f);
    f.st.exit_requested = 1u;
    CHECK(visit(&f, 2) == A77_OK && f.completed == 1 && f.phase == 0u);
    CHECK_LOG(&f, "start:1:0,active:0:0,relsurf:77:0,ovact:0:0,stop:565:0,tr:50:4:5:6:44:55:66,x57b:50:0,x599:4:0,"
                  "x595:5:0,x39ff:6:0,x59b:44:0,x59f:55:0,x5a3:66:0,start:1:0,mode:4:0,sf:8:9,evflag:8:9,complete:3:0");
    CHECK(f.world.start_flag_5bb1ca == 1);
    /* start-flag word 1 stores 0 on the exit block too */
    fx_init(&f);
    put16(f.body, 0x2c6, 1);
    start(&f);
    f.st.exit_requested = 1u;
    CHECK(visit(&f, 2) == A77_OK && f.world.start_flag_5bb1ca == 0);
    /* scene 9999: no change, the event flag is still stored */
    fx_init(&f);
    put16(f.body, 0x2b2, 9999);
    start(&f);
    f.st.exit_requested = 1u;
    CHECK(visit(&f, 2) == A77_OK);
    CHECK_LOG(&f, "start:1:0,active:0:0,relsurf:77:0,ovact:0:0,stop:565:0,sf:8:9,evflag:8:9,complete:3:0");
    /* flag -1: none */
    fx_init(&f);
    put16(f.body, 0x2c8, -1);
    start(&f);
    f.st.exit_requested = 1u;
    CHECK(visit(&f, 2) == A77_OK && strstr(f.log, "sf:") == NULL && strstr(f.log, "mode:4:0,complete") != NULL);
    /* exit takes the exit block even when the puzzle was solved */
    fx_init(&f);
    start(&f);
    f.st.solved = 1u;
    f.st.exit_requested = 1u;
    CHECK(visit(&f, 2) == A77_OK && strstr(f.log, "tr:50:") != NULL && strstr(f.log, "tr:40:") == NULL);
    /* an unusable index is refused before the first effect, the transition included */
    fx_init(&f);
    put16(f.body, 0x2c8, 500);
    start(&f);
    f.st.exit_requested = 1u;
    CHECK(visit(&f, 2) == A77_ERR_BOUNDS && f.log[0] == '\0' && f.st.active == 1u && f.st.surface == 77u);
    /* the solved path does not look at the exit flag */
    fx_init(&f);
    put16(f.body, 0x2c8, 500);
    start(&f);
    CHECK(visit(&f, 2) == A77_OK);
}

static void t_phase2_failures(void)
{
    Fx f;
    fx_init(&f);
    start(&f);
    f.fail_release = 1;
    CHECK(visit(&f, 2) == A77_ERR_HOST && f.completed == 0 && f.phase == 2u && f.st.surface == 77u);
    fx_init(&f);
    start(&f);
    f.fail_stop = 1;
    CHECK(visit(&f, 2) == A77_ERR_HOST && f.completed == 0 && strstr(f.log, "complete") == NULL);
    fx_init(&f);
    start(&f);
    f.fail_transition = 1;
    CHECK(visit(&f, 2) == A77_ERR_HOST && f.completed == 0 && strstr(f.log, "x57b") == NULL);
    fx_init(&f);
    start(&f);
    f.st.exit_requested = 1u;
    f.fail_flag = 1;
    CHECK(visit(&f, 2) == A77_ERR_HOST && f.completed == 0 && strstr(f.log, "mode:4:0") != NULL);
}

static void t_pointer(void)
{
    Fx f;
    A77PointerResult p;
    fx_init(&f);
    /* inactive: nothing is claimed */
    CHECK(pointer(&f, 5, 5, &p) == A77_OK && p.hit == 0u && p.candidate == -1 && p.hover == -1 && p.cursor_kind == 0u &&
          p.cursor_sub == 0u);
    start(&f);
    f.st.hover = 3;
    CHECK(pointer(&f, 5, 5, &p) == A77_OK);
    CHECK(p.hit == 1u && p.candidate == 0x2719 && p.hover == 0 && p.cursor_sub == 1u && p.cursor_kind == 0u);
    CHECK(f.st.hover == 0);
    CHECK(pointer(&f, 25, 9, &p) == A77_OK && p.hit == 1u && p.hover == 1 && f.st.hover == 1);
    CHECK(pointer(&f, 65, 0, &p) == A77_OK && p.hit == 1u && p.hover == 3 && f.st.hover == 3);
    /* inclusive edges of button 1 (x 20..29, y 0..9) */
    CHECK(pointer(&f, 20, 0, &p) == A77_OK && p.hit == 1u && p.hover == 1);
    CHECK(pointer(&f, 29, 0, &p) == A77_OK && p.hit == 1u && p.hover == 1);
    CHECK(pointer(&f, 20, 9, &p) == A77_OK && p.hit == 1u && p.hover == 1);
    CHECK(pointer(&f, 29, 9, &p) == A77_OK && p.hit == 1u && p.hover == 1);
    f.st.hover = 3;
    CHECK(pointer(&f, 19, 5, &p) == A77_OK && p.hit == 0u && p.candidate == -1 && p.hover == -1 && f.st.hover == 3);
    CHECK(pointer(&f, 30, 5, &p) == A77_OK && p.hit == 0u);
    CHECK(pointer(&f, 25, -1, &p) == A77_OK && p.hit == 0u);
    CHECK(pointer(&f, 25, 10, &p) == A77_OK && p.hit == 0u);
    /* buttons >= N are not tested: button 4 would be x 80..89 */
    CHECK(pointer(&f, 85, 5, &p) == A77_OK && p.hit == 0u);
    /* exit rectangle, inclusive, writes the cursor kind and the exit candidate and leaves the hover alone */
    CHECK(pointer(&f, 100, 50, &p) == A77_OK && p.hit == 1u && p.candidate == 0x271a && p.cursor_kind == 9u);
    CHECK(p.hover == -1 && p.cursor_sub == 0u && f.st.hover == 3);
    CHECK(pointer(&f, 110, 60, &p) == A77_OK && p.hit == 1u && p.candidate == 0x271a);
    CHECK(pointer(&f, 99, 55, &p) == A77_OK && p.hit == 0u);
    CHECK(pointer(&f, 111, 55, &p) == A77_OK && p.hit == 0u);
    CHECK(pointer(&f, 105, 49, &p) == A77_OK && p.hit == 0u);
    CHECK(pointer(&f, 105, 61, &p) == A77_OK && p.hit == 0u);
    CHECK(pointer(&f, 105, 55, &p) == A77_OK && p.hit == 1u);
    /* buttons come first: an overlapping exit rectangle loses; the first overlapping button wins */
    put32(f.body, 0x2cb, 0);
    put32(f.body, 0x2cf, 0);
    put32(f.body, 0x2d3, 200);
    put32(f.body, 0x2d7, 200);
    CHECK(pointer(&f, 5, 5, &p) == A77_OK && p.candidate == 0x2719 && p.hover == 0);
    CHECK(pointer(&f, 85, 5, &p) == A77_OK && p.candidate == 0x271a);
    put32(f.body, 0x123 + 16, 0); /* button 1 now covers x 0..29 too */
    CHECK(pointer(&f, 5, 5, &p) == A77_OK && p.hover == 0);
    /* negative coordinates and a negative-left rectangle use signed compares */
    put32(f.body, 0x123, -10);
    put32(f.body, 0x127, -10);
    CHECK(pointer(&f, -10, -10, &p) == A77_OK && p.hover == 0);
    CHECK(pointer(&f, -11, -10, &p) == A77_OK && p.hit == 0u);
    CHECK(pointer(&f, -10, -11, &p) == A77_OK && p.hit == 0u);
    /* N = 0: only the exit rectangle */
    fx_init(&f);
    put16(f.body, 0x21, 0);
    start(&f);
    CHECK(pointer(&f, 5, 5, &p) == A77_OK && p.hit == 0u);
    CHECK(pointer(&f, 105, 55, &p) == A77_OK && p.hit == 1u);
    /* bad arguments */
    CHECK(a77_pointer(NULL, f.body, A77_BODY_BYTES, 0, 0, &p) == A77_ERR_ARGUMENT);
    CHECK(a77_pointer(&f.st, NULL, A77_BODY_BYTES, 0, 0, &p) == A77_ERR_ARGUMENT);
    CHECK(a77_pointer(&f.st, f.body, A77_BODY_BYTES, 0, 0, NULL) == A77_ERR_ARGUMENT);
    CHECK(a77_pointer(&f.st, f.body, 10u, 0, 0, &p) == A77_ERR_ARGUMENT);
}

static void t_click_toggle(void)
{
    Fx f;
    A77ClickResult c;
    fx_init(&f);
    start(&f);
    f.world.start_flag_5bb1ca = 1;
    /* on */
    f.st.hover = 2;
    CHECK(click(&f, 0x2719, 1, &c) == A77_OK);
    CHECK(c.toggled == 1u && c.click_sound == 1u && c.exit_asked == 0u && c.new_phase == 1u);
    CHECK_LOG(&f, "play:5:0");
    CHECK(f.st.selected[2] == 1u && f.st.count == 1 && f.st.order[0] == 2 && f.st.order[1] == -1);
    CHECK(press(&f, 0, 0) == A77_OK && f.st.count == 2 && f.st.order[1] == 0 && f.st.selected[0] == 1u);
    CHECK(press(&f, 1, 0) == A77_OK && f.st.count == 3 && f.st.order[2] == 1);
    /* off: the last entry leaves the list */
    CHECK(press(&f, 1, 0) == A77_OK && f.st.count == 2 && f.st.order[2] == -1 && f.st.selected[1] == 0u);
    /* off: an entry that is not the last one stays in the list (the original only looks at the top) */
    CHECK(press(&f, 2, 0) == A77_OK && f.st.selected[2] == 0u && f.st.count == 2 && f.st.order[0] == 2 &&
          f.st.order[1] == 0);
    /* the top one goes on removing */
    CHECK(press(&f, 0, 0) == A77_OK && f.st.count == 1 && f.st.order[1] == -1 && f.st.order[0] == 2);
    /* count 0: t clamps to 0 and order[0] == h pops below zero, clamped */
    fx_init(&f);
    start(&f);
    f.st.selected[3] = 1u;
    f.st.order[0] = 3;
    f.st.count = 0;
    CHECK(press(&f, 3, 0) == A77_OK && f.st.count == 0 && f.st.order[0] == -1 && f.st.selected[3] == 0u);
    fx_init(&f);
    start(&f);
    f.st.selected[3] = 1u;
    f.st.order[0] = 2;
    f.st.count = 0;
    CHECK(press(&f, 3, 0) == A77_OK && f.st.count == 0 && f.st.order[0] == 2);
    /* overflow: with count == N the entry is not stored and the count clamps back to N */
    fx_init(&f);
    start(&f);
    for (int i = 0; i < 4; ++i) CHECK(press(&f, (int16_t)i, 0) == A77_OK);
    CHECK(f.st.count == 4 && f.st.order[3] == 3);
    f.st.selected[3] = 0u;
    f.st.order[3] = 9; /* a stale cell: must not be written by the next press */
    CHECK(press(&f, 3, 0) == A77_OK && f.st.count == 4 && f.st.order[3] == 9 && f.st.selected[3] == 1u);
    CHECK(f.st.order[4] == -1); /* nothing is written one past the last button */
    /* count at N - 1 stores, count above N - 1 does not */
    fx_init(&f);
    start(&f);
    f.st.count = 3;
    CHECK(press(&f, 1, 0) == A77_OK && f.st.order[3] == 1 && f.st.count == 4);
    fx_init(&f);
    start(&f);
    f.st.count = 5; /* beyond N: the store is skipped, the increment clamps */
    f.st.order[5] = 77;
    CHECK(press(&f, 1, 0) == A77_OK && f.st.order[5] == 77 && f.st.count == 4);
    /* N = 1 */
    fx_init(&f);
    put16(f.body, 0x21, 1);
    start(&f);
    CHECK(press(&f, 0, 0) == A77_OK && f.st.count == 1 && f.st.order[0] == 0);
    CHECK(press(&f, 0, 0) == A77_OK && f.st.count == 0 && f.st.order[0] == -1);
}

static void t_click_gating_and_sound(void)
{
    Fx f;
    A77ClickResult c;
    fx_init(&f);
    f.st.hover = 1;
    /* inactive: nothing happens */
    CHECK(click(&f, 0x2719, 1, &c) == A77_OK && c.toggled == 0u && c.new_phase == 1u && f.st.selected[1] == 0u);
    CHECK(click(&f, 0x271a, 1, &c) == A77_OK && c.exit_asked == 0u && f.st.exit_requested == 0u);
    start(&f);
    f.st.solved = 1u;
    f.st.hover = 1;
    CHECK(click(&f, 0x2719, 1, &c) == A77_OK && c.toggled == 0u && f.st.selected[1] == 0u && f.log[0] == '\0');
    CHECK(click(&f, 0x271a, 1, &c) == A77_OK && c.exit_asked == 0u && f.st.exit_requested == 0u && c.new_phase == 1u);
    f.st.solved = 0u;
    /* other candidates do nothing */
    CHECK(click(&f, 0x2718, 1, &c) == A77_OK && c.toggled == 0u && c.exit_asked == 0u && f.st.selected[1] == 0u);
    CHECK(click(&f, 0x271b, 1, &c) == A77_OK && c.toggled == 0u && c.exit_asked == 0u);
    CHECK(click(&f, -1, 1, &c) == A77_OK && c.toggled == 0u);
    /* sound: only with the start flag set and a sound record */
    CHECK(click(&f, 0x2719, 0, &c) == A77_OK && c.toggled == 1u && c.click_sound == 0u && f.log[0] == '\0');
    CHECK(click(&f, 0x2719, 2, &c) == A77_OK && c.click_sound == 1u && strcmp(f.log, "play:5:0") == 0);
    CHECK(click(&f, 0x2719, -1, &c) == A77_OK && c.click_sound == 1u);
    f.log[0] = '\0';
    set_rec(f.body, 0x235, "NO SOUND");
    CHECK(click(&f, 0x2719, 1, &c) == A77_OK && c.toggled == 1u && c.click_sound == 0u && f.log[0] == '\0');
    f.body[0x235 + 8] = 1;
    CHECK(click(&f, 0x2719, 1, &c) == A77_OK && c.click_sound == 1u);
    /* channel is a signed word */
    put16(f.body, 0x256, -3);
    f.log[0] = '\0';
    CHECK(click(&f, 0x2719, 1, &c) == A77_OK && strcmp(f.log, "play:-3:0") == 0);
    /* host failure after the toggle */
    f.fail_play = 1;
    CHECK(click(&f, 0x2719, 1, &c) == A77_ERR_HOST);
    f.host.sound_play = NULL;
    CHECK(click(&f, 0x2719, 1, &c) == A77_ERR_ARGUMENT);
    CHECK(click(&f, 0x2719, 0, &c) == A77_OK); /* no sound wanted: the callback is not needed */
    /* the exit */
    fx_init(&f);
    start(&f);
    CHECK(click(&f, 0x271a, 1, &c) == A77_OK && c.exit_asked == 1u && c.toggled == 0u && c.new_phase == 2u);
    CHECK(f.st.exit_requested == 1u && c.click_sound == 0u);
    CHECK_LOG(&f, "phase:2:0");
    /* the phase is reported relative to the row phase given */
    CHECK(a77_click(&f.st, f.body, A77_BODY_BYTES, 1u, 0x2719, 0, &f.host, &c) == A77_OK && c.new_phase == 1u);
    /* argument refusals */
    CHECK(a77_click(NULL, f.body, A77_BODY_BYTES, 1u, 0x271a, 0, &f.host, &c) == A77_ERR_ARGUMENT);
    CHECK(a77_click(&f.st, NULL, A77_BODY_BYTES, 1u, 0x271a, 0, &f.host, &c) == A77_ERR_ARGUMENT);
    CHECK(a77_click(&f.st, f.body, A77_BODY_BYTES, 1u, 0x271a, 0, NULL, &c) == A77_ERR_ARGUMENT);
    CHECK(a77_click(&f.st, f.body, A77_BODY_BYTES, 1u, 0x271a, 0, &f.host, NULL) == A77_ERR_ARGUMENT);
    CHECK(a77_click(&f.st, f.body, 9u, 1u, 0x271a, 0, &f.host, &c) == A77_ERR_ARGUMENT);
}

static void t_click_bounds(void)
{
    Fx f;
    A77ClickResult c;
    fx_init(&f);
    start(&f);
    f.st.hover = -1;
    CHECK(click(&f, 0x2719, 1, &c) == A77_ERR_BOUNDS && f.log[0] == '\0' && f.st.count == 0);
    f.st.hover = 4; /* == N */
    CHECK(click(&f, 0x2719, 1, &c) == A77_ERR_BOUNDS && f.st.selected[4] == 0u);
    f.st.hover = 3;
    f.st.count = 17;
    CHECK(click(&f, 0x2719, 1, &c) == A77_ERR_BOUNDS && f.st.selected[3] == 0u);
    f.st.count = -1;
    CHECK(click(&f, 0x2719, 1, &c) == A77_ERR_BOUNDS);
    f.st.count = 16;
    CHECK(click(&f, 0x2719, 0, &c) == A77_OK);
    f.st.count = 0;
    f.st.hover = 3;
    f.st.selected[3] = 0u;
    CHECK(click(&f, 0x2719, 0, &c) == A77_OK && f.st.selected[3] == 1u);
    /* hover is not consulted for the exit */
    f.st.hover = 99;
    CHECK(click(&f, 0x271a, 0, &c) == A77_OK && c.exit_asked == 1u);
}

static void t_render_plan(void)
{
    Fx f;
    A77RenderPlan p;
    fx_init(&f);
    /* the entry is not drawn while the overlay flag is 0 */
    memset(&p, 0x55, sizeof p);
    CHECK(a77_render_plan(&f.st, f.body, A77_BODY_BYTES, &f.host, &p) == A77_OK && p.valid == 0u && p.count == 0 &&
          p.surface == 0u);
    start(&f);
    CHECK(a77_render_plan(&f.st, f.body, A77_BODY_BYTES, &f.host, &p) == A77_OK);
    CHECK(p.valid == 1u && p.surface == 77u && p.count == 4);
    for (int i = 0; i < 4; ++i) {
        CHECK(p.blit[i].selected == 0u);
        CHECK(p.blit[i].dst[0] == 20 * i + 10 && p.blit[i].dst[1] == 0 + 20 && p.blit[i].dst[2] == 20 * i + 9 + 10 &&
              p.blit[i].dst[3] == 9 + 20);
        /* unselected: the source is the button rectangle itself (view relative, no origin added) */
        CHECK(p.blit[i].src[0] == 20 * i && p.blit[i].src[1] == 0 && p.blit[i].src[2] == 20 * i + 9 &&
              p.blit[i].src[3] == 9);
    }
    f.st.selected[1] = 1u;
    f.st.selected[3] = 7u;
    CHECK(a77_render_plan(&f.st, f.body, A77_BODY_BYTES, &f.host, &p) == A77_OK);
    CHECK(p.blit[0].selected == 0u && p.blit[1].selected == 1u && p.blit[2].selected == 0u && p.blit[3].selected == 1u);
    CHECK(p.blit[1].src[0] == 110 && p.blit[1].src[1] == 201 && p.blit[1].src[2] == 119 && p.blit[1].src[3] == 210);
    CHECK(p.blit[1].dst[0] == 30 && p.blit[1].dst[1] == 20 && p.blit[1].dst[2] == 39 && p.blit[1].dst[3] == 29);
    CHECK(p.blit[3].src[0] == 130 && p.blit[3].src[3] == 212);
    /* the origin is signed and added to x with left/right and to y with top/bottom */
    f.vx = -100;
    f.vy = 5;
    CHECK(a77_render_plan(&f.st, f.body, A77_BODY_BYTES, &f.host, &p) == A77_OK);
    CHECK(p.blit[2].dst[0] == -60 && p.blit[2].dst[1] == 5 && p.blit[2].dst[2] == -51 && p.blit[2].dst[3] == 14);
    /* the render callback does not test `active`: only the overlay flag */
    f.st.active = 0u;
    CHECK(a77_render_plan(&f.st, f.body, A77_BODY_BYTES, &f.host, &p) == A77_OK && p.valid == 1u);
    f.st.overlay_active = 0u;
    CHECK(a77_render_plan(&f.st, f.body, A77_BODY_BYTES, &f.host, &p) == A77_OK && p.valid == 0u);
    f.st.overlay_active = 1u;
    /* a stale surface handle survives the finish */
    fx_init(&f);
    start(&f);
    CHECK(visit(&f, 2) == A77_OK && f.st.overlay_surface == 77u);
    CHECK(a77_render_plan(&f.st, f.body, A77_BODY_BYTES, &f.host, &p) == A77_OK && p.valid == 0u);
    f.st.overlay_active = 1u;
    CHECK(a77_render_plan(&f.st, f.body, A77_BODY_BYTES, &f.host, &p) == A77_OK && p.valid == 1u && p.surface == 77u);
    /* N = 0 and N = 16 */
    fx_init(&f);
    put16(f.body, 0x21, 0);
    start(&f);
    CHECK(a77_render_plan(&f.st, f.body, A77_BODY_BYTES, &f.host, &p) == A77_OK && p.valid == 1u && p.count == 0);
    fx_init(&f);
    put16(f.body, 0x21, 16);
    put32(f.body, 0x123 + 16u * 15u, 777);
    start(&f);
    CHECK(a77_render_plan(&f.st, f.body, A77_BODY_BYTES, &f.host, &p) == A77_OK && p.count == 16 &&
          p.blit[15].dst[0] == 787);
    /* failures */
    f.fail_origin = 1;
    CHECK(a77_render_plan(&f.st, f.body, A77_BODY_BYTES, &f.host, &p) == A77_ERR_HOST);
    f.host.view_origin = NULL;
    CHECK(a77_render_plan(&f.st, f.body, A77_BODY_BYTES, &f.host, &p) == A77_ERR_ARGUMENT);
    CHECK(a77_render_plan(NULL, f.body, A77_BODY_BYTES, &f.host, &p) == A77_ERR_ARGUMENT);
    CHECK(a77_render_plan(&f.st, f.body, 5u, &f.host, &p) == A77_ERR_ARGUMENT);
}

static void t_clear(void)
{
    Fx f;
    fx_init(&f);
    start(&f);
    CHECK(a77_clear(&f.st, &f.host) == A77_OK);
    CHECK_LOG(&f, "active:0:0,ovact:0:0,relsurf:77:0");
    CHECK(f.st.active == 0u && f.st.overlay_active == 0u && f.st.surface == 0u && f.st.overlay_surface == 77u);
    /* with no handle held nothing is released */
    f.log[0] = '\0';
    CHECK(a77_clear(&f.st, &f.host) == A77_OK);
    CHECK_LOG(&f, "active:0:0,ovact:0:0");
    /* the selection state is left alone by the clear */
    fx_init(&f);
    start(&f);
    f.st.selected[2] = 1u;
    f.st.count = 2;
    CHECK(a77_clear(&f.st, &f.host) == A77_OK && f.st.selected[2] == 1u && f.st.count == 2);
    fx_init(&f);
    start(&f);
    f.fail_release = 1;
    CHECK(a77_clear(&f.st, &f.host) == A77_ERR_HOST && f.st.surface == 77u && f.st.active == 0u);
    f.host.release_surface = NULL;
    CHECK(a77_clear(&f.st, &f.host) == A77_ERR_ARGUMENT);
    f.st.surface = 0u;
    CHECK(a77_clear(&f.st, &f.host) == A77_OK);
    CHECK(a77_clear(NULL, &f.host) == A77_ERR_ARGUMENT);
    CHECK(a77_clear(&f.st, NULL) == A77_ERR_ARGUMENT);
}

static void t_full_playthrough(void)
{
    Fx f;
    A77PointerResult p;
    A77ClickResult c;
    fx_init(&f);
    f.ticks[0] = 100u;
    CHECK(visit(&f, 0) == A77_OK && f.phase == 1u);
    CHECK(visit(&f, 1) == A77_OK && f.st.step == 0u); /* nothing chosen: no reset yet */
    const int16_t order[3] = {2, 0, 1};
    for (int k = 0; k < 3; ++k) {
        CHECK(pointer(&f, 20 * order[k] + 3, 4, &p) == A77_OK && p.candidate == 0x2719);
        CHECK(click(&f, p.candidate, f.world.start_flag_5bb1ca, &c) == A77_OK && c.toggled == 1u);
    }
    CHECK(f.st.count == 3);
    CHECK(visit(&f, 1) == A77_OK && f.st.solved == 1u && f.st.step == 1u);
    /* solved: clicks are inert */
    CHECK(pointer(&f, 3, 3, &p) == A77_OK && p.hit == 1u);
    f.log[0] = '\0';
    CHECK(click(&f, 0x2719, 1, &c) == A77_OK && c.toggled == 0u && f.log[0] == '\0');
    CHECK(visit(&f, 1) == A77_OK && f.st.step == 2u && f.st.deadline == 2100u);
    f.ticks[0] = 2099u;
    f.iticks = 0;
    CHECK(visit(&f, 1) == A77_OK && f.st.step == 2u);
    f.ticks[0] = 2100u;
    f.iticks = 0;
    CHECK(visit(&f, 1) == A77_OK && f.st.step == 3u);
    f.busy[0] = 1;
    f.nbusy = 1;
    CHECK(visit(&f, 1) == A77_OK && f.phase == 1u);
    CHECK(visit(&f, 1) == A77_OK && f.phase == 2u);
    CHECK(visit(&f, 2) == A77_OK && f.completed == 1 && strstr(f.log, "tr:40:") != NULL);
    CHECK(f.st.active == 0u && f.st.overlay_active == 0u);
    /* after the finish the pointer claims nothing */
    CHECK(pointer(&f, 3, 3, &p) == A77_OK && p.hit == 0u);
}

static void t_unsolved_cycle(void)
{
    /* wrong entries until the count reaches the limit: the list is cleared and the player starts over */
    Fx f;
    fx_init(&f);
    start(&f); /* limit 4 */
    for (int i = 0; i < 4; ++i) CHECK(press(&f, (int16_t)(3 - i), 0) == A77_OK);
    CHECK(f.st.count == 4);
    CHECK(visit(&f, 1) == A77_OK && f.st.solved == 0u && f.st.count == 0 && f.st.order[0] == -1);
    for (int i = 0; i < 4; ++i) CHECK(f.st.selected[i] == 0u);
}


/* ---- the session binding (src/session_bindings_a77.c) over a synthetic scene ------------------------------------------ */

static void put_be32(uint8_t *b, size_t off, size_t v)
{
    for (int i = 0; i < 4; ++i) b[off + (size_t)i] = (uint8_t)(v >> (24 - 8 * i));
}

/* The 4-byte id includes the NUL of "ACT". */
static size_t put_chunk(uint8_t *out, size_t pos, const char *id, const uint8_t *payload, size_t n)
{
    memcpy(out + pos, id, 4);
    put_be32(out, pos + 4, n);
    memcpy(out + pos + 8, payload, n);
    pos += 8 + n;
    if (n & 1u) out[pos++] = 0;
    return pos;
}

/* A scene of actions {type, body}: the 48 byte description, type, subtype 1, body (no dependency records). */
static size_t build_scene(uint8_t *out, size_t rows, const int *types, const uint8_t *const *bodies, const size_t *lengths)
{
    uint8_t tsum[126], act[48 + 2 + A77_BODY_BYTES];
    size_t pos = 12;
    memset(tsum, 0, sizeof tsum);
    memcpy(tsum, "Executor", 9);
    memcpy(tsum + 50, "background", 11);
    memcpy(tsum + 83, "sound", 6);
    memcpy(out + 8, "SCEN", 4);
    pos = put_chunk(out, pos, "TSUM", tsum, sizeof tsum);
    for (size_t i = 0; i < rows; ++i) {
        memset(act, 0, sizeof act);
        memcpy(act, "test", 4);
        act[48] = (uint8_t)types[i];
        act[49] = 1;
        memcpy(act + 50, bodies[i], lengths[i]);
        pos = put_chunk(out, pos, "ACT", act, 50 + lengths[i]);
    }
    memcpy(out, "DATA", 4);
    put_be32(out, 4, pos - 8);
    return pos;
}

static void h_store_world(void *c, const A77World *w)
{
    Fx *f = (Fx *)c;
    ++f->world_stores;
    f->world_value = w->start_flag_5bb1ca;
}

typedef struct Bind {
    Fx f;
    SessionA77Host host;
    SessionA77Binding *b;
    SceneResource *scene;
    uint8_t bytes[4096];
    uint8_t body_a[A77_BODY_BYTES], body_b[A77_BODY_BYTES];
} Bind;

static int bind_open(Bind *x, int types_ok)
{
    const int types[3] = {0x70, 0x77, 0x77};
    const uint8_t one = 0;
    const uint8_t *bodies[3];
    size_t lengths[3] = {1, A77_BODY_BYTES, A77_BODY_BYTES};
    size_t n;
    char err[128] = {0};
    fx_init(&x->f);
    memcpy(x->body_a, x->f.body, A77_BODY_BYTES);
    memcpy(x->body_b, x->f.body, A77_BODY_BYTES);
    put32(x->body_b, 0x123, 300);
    put32(x->body_b, 0x123 + 8, 309);
    put16(x->body_b, 0x2c8, 11);
    bodies[0] = &one;
    bodies[1] = x->body_a;
    bodies[2] = x->body_b;
    (void)types_ok;
    n = build_scene(x->bytes, 3, types, bodies, lengths);
    x->scene = scene_resource_open_memory(x->bytes, n, err, sizeof err);
    if (x->scene == NULL) return 0;
    memset(&x->host, 0, sizeof x->host);
    x->host.kernel = x->f.host;
    x->host.store_world = h_store_world;
    x->b = session_a77_create(&x->host);
    return x->b != NULL;
}

static void bind_close(Bind *x)
{
    session_a77_destroy(x->b);
    scene_resource_close(x->scene);
}

static int b_visit(Bind *x, size_t row, uint32_t phase, uint32_t *phase_after, int *completed)
{
    SceneActionInfo info;
    SceneActionRuntimeState st;
    SceneActionHandlerResult out;
    memset(&st, 0, sizeof st);
    memset(&out, 0, sizeof out);
    st.phase = phase;
    if (scene_resource_action_at(x->scene, row, &info) != SCENE_RESOURCE_OK) return -1;
    {
        const int rc = session_a77_handler(x->b, row, &info, &st, &out);
        if (rc == SCENE_ACTION_HANDLER_OK) {
            *phase_after = out.phase;
            *completed = out.disposition == SCENE_ACTION_HANDLER_COMPLETED;
            if (out.disposition != SCENE_ACTION_HANDLER_COMPLETED && out.disposition != SCENE_ACTION_HANDLER_PENDING)
                return -2;
        }
        return rc;
    }
}

static void t_binding_flow(void)
{
    Bind x;
    uint32_t ph = 99u, np = 0u;
    int done = -1;
    A77PointerResult p;
    A77RenderPlan plan;
    if (!bind_open(&x, 1)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_a77_begin_scene(x.b, x.scene) == A77_OK && strcmp(session_a77_failure(x.b), "none") == 0);
    CHECK(session_a77_registered(x.b) == 0u && session_a77_state(x.b)->active == 0u);
    /* a row of another type and an unknown index are not ours */
    {
        SceneActionInfo info, other;
        SceneActionRuntimeState st;
        SceneActionHandlerResult out;
        memset(&st, 0, sizeof st);
        CHECK(scene_resource_action_at(x.scene, 0, &info) == SCENE_RESOURCE_OK);
        CHECK(session_a77_handler(x.b, 0, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(strcmp(session_a77_failure(x.b), "0x77-row-not-owned") == 0);
        CHECK(scene_resource_action_at(x.scene, 1, &info) == SCENE_RESOURCE_OK);
        CHECK(session_a77_handler(x.b, 7, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        /* a row of ours addressed with another type's action, and a row that is not ours addressed with ours */
        x.f.log[0] = '\0';
        CHECK(scene_resource_action_at(x.scene, 0, &other) == SCENE_RESOURCE_OK);
        CHECK(session_a77_handler(x.b, 1, &other, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_a77_handler(x.b, 0, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(x.f.log[0] == '\0');
        CHECK(session_a77_handler(x.b, 1, NULL, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_a77_handler(x.b, 1, &info, NULL, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_a77_handler(x.b, 1, &info, &st, NULL) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_a77_handler(NULL, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
    }
    /* phase 1 before phase 0 is unsupported; the failure text says why */
    {
        SceneActionInfo info;
        SceneActionRuntimeState st;
        SceneActionHandlerResult out;
        memset(&st, 0, sizeof st);
        st.phase = 1u;
        CHECK(scene_resource_action_at(x.scene, 1, &info) == SCENE_RESOURCE_OK);
        CHECK(session_a77_handler(x.b, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
        CHECK(strcmp(session_a77_failure(x.b), "0x77-phase-1-without-init") == 0);
    }
    /* pointer, click and plan before the puzzle starts */
    CHECK(session_a77_pointer_move(x.b, 5, 5, &p) == A77_OK && p.hit == 0u && p.candidate == -1 && p.hover == -1);
    CHECK(session_a77_click(x.b, 1u, 0x2719, 1, &np) == A77_OK && np == 1u);
    CHECK(session_a77_click(x.b, 1u, 0x271a, 1, &np) == A77_OK && np == 1u && session_a77_state(x.b)->exit_requested == 0u);
    CHECK(session_a77_render_plan(x.b, &plan) == A77_OK && plan.valid == 0u);
    /* phase 0 */
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u && done == 0);
    CHECK(x.f.world_stores == 1 && x.f.world_value == 1);
    CHECK(session_a77_registered(x.b) == 1u && session_a77_state(x.b)->active == 1u && session_a77_state(x.b)->row == 1);
    CHECK(session_a77_render_plan(x.b, &plan) == A77_OK && plan.valid == 1u && plan.surface == 77u && plan.count == 4);
    /* the pointer uses the body of the active row (row 1: button 0 at x 0..9) */
    CHECK(session_a77_pointer_move(x.b, 5, 5, &p) == A77_OK && p.hit == 1u && p.hover == 0 && p.candidate == 0x2719);
    CHECK(session_a77_pointer_move(x.b, 305, 5, &p) == A77_OK && p.hit == 0u);
    CHECK(session_a77_click(x.b, 1u, 0x2719, 0, &np) == A77_OK && np == 1u && session_a77_state(x.b)->count == 1);
    CHECK(session_a77_click(x.b, 7u, 0x2719, 0, &np) == A77_OK && np == 7u); /* the row phase passes through */
    /* phase 1 visits write no world */
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u && done == 0 && x.f.world_stores == 1);
    /* exit: new_phase 2, then the finish completes with phase 0 and stores the world */
    CHECK(session_a77_click(x.b, 1u, 0x271a, 1, &np) == A77_OK && np == 2u);
    CHECK(b_visit(&x, 1, 2u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 0u && done == 1);
    CHECK(x.f.world_stores == 2 && x.f.world_value == 1);
    CHECK(session_a77_state(x.b)->active == 0u && session_a77_registered(x.b) == 0u);
    CHECK(strstr(x.f.log, "tr:50:") != NULL && strstr(x.f.log, "sf:8:9") != NULL);
    /* second row: its own body, even while the first one's copy is kept */
    x.f.log[0] = '\0';
    CHECK(b_visit(&x, 2, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u);
    CHECK(session_a77_pointer_move(x.b, 305, 5, &p) == A77_OK && p.hit == 1u && p.hover == 0);
    CHECK(session_a77_pointer_move(x.b, 5, 5, &p) == A77_OK && p.hit == 0u);
    CHECK(session_a77_click(x.b, 1u, 0x271a, 1, &np) == A77_OK && np == 2u);
    CHECK(b_visit(&x, 2, 2u, &ph, &done) == SCENE_ACTION_HANDLER_OK && done == 1 && strstr(x.f.log, "sf:11:9") != NULL);
    /* a phase beyond 2 is pending and untouched */
    CHECK(b_visit(&x, 1, 5u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 5u && done == 0);
    /* argument checks */
    CHECK(session_a77_pointer_move(NULL, 0, 0, &p) == A77_ERR_ARGUMENT);
    CHECK(session_a77_pointer_move(x.b, 0, 0, NULL) == A77_ERR_ARGUMENT);
    CHECK(session_a77_click(NULL, 1u, 1, 1, &np) == A77_ERR_ARGUMENT);
    CHECK(session_a77_click(x.b, 1u, 1, 1, NULL) == A77_ERR_ARGUMENT);
    CHECK(session_a77_render_plan(NULL, &plan) == A77_ERR_ARGUMENT);
    CHECK(session_a77_render_plan(x.b, NULL) == A77_ERR_ARGUMENT);
    CHECK(session_a77_begin_scene(NULL, x.scene) == A77_ERR_ARGUMENT);
    CHECK(session_a77_begin_scene(x.b, NULL) == A77_ERR_ARGUMENT);
    CHECK(session_a77_registered(NULL) == 0u && session_a77_state(NULL) == NULL);
    CHECK(strcmp(session_a77_failure(NULL), "0x77-binding-unbound") == 0);
    CHECK(session_a77_create(NULL) == NULL);
    session_a77_destroy(NULL);
    bind_close(&x);
}

static void t_binding_scene_change_clears(void)
{
    Bind x;
    uint32_t ph = 0u;
    int done = 0;
    A77PointerResult p;
    uint32_t np = 0u;
    if (!bind_open(&x, 1)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_a77_begin_scene(x.b, x.scene) == A77_OK);
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    x.f.log[0] = '\0';
    /* the next scene's clear runs the release and drops the active flag */
    CHECK(session_a77_begin_scene(x.b, x.scene) == A77_OK);
    CHECK_LOG(&x.f, "active:0:0,ovact:0:0,relsurf:77:0");
    CHECK(session_a77_state(x.b)->active == 0u && session_a77_registered(x.b) == 0u);
    CHECK(session_a77_pointer_move(x.b, 5, 5, &p) == A77_OK && p.hit == 0u);
    CHECK(session_a77_click(x.b, 1u, 0x271a, 1, &np) == A77_OK && np == 1u);
    /* the new scene's rows need their own phase 0 */
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    /* destroy clears too */
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    x.f.log[0] = '\0';
    bind_close(&x);
    CHECK_LOG(&x.f, "active:0:0,ovact:0:0,relsurf:77:0");
}

static void t_binding_refuses_bad_body(void)
{
    Bind x;
    uint8_t bad[A77_BODY_BYTES];
    const int types[2] = {0x77, 0x77};
    const uint8_t *bodies[2];
    size_t lengths[2] = {A77_BODY_BYTES, A77_BODY_BYTES};
    size_t n;
    char err[128] = {0};
    uint32_t ph = 0u;
    int done = 0;
    SceneResource *bad_scene;
    if (!bind_open(&x, 1)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_a77_begin_scene(x.b, x.scene) == A77_OK);
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    memcpy(bad, x.body_a, sizeof bad);
    put16(bad, 0x223, 17);
    bodies[0] = x.body_a;
    bodies[1] = bad;
    n = build_scene(x.bytes, 2, types, bodies, lengths);
    bad_scene = scene_resource_open_memory(x.bytes, n, err, sizeof err);
    CHECK(bad_scene != NULL);
    if (bad_scene != NULL) {
        CHECK(session_a77_begin_scene(x.b, bad_scene) == A77_ERR_BODY);
        CHECK(strcmp(session_a77_failure(x.b), "0x77-solution-length") == 0);
        /* the refusal comes before the clear: the running puzzle is untouched */
        CHECK(session_a77_state(x.b)->active == 1u);
        scene_resource_close(bad_scene);
    }
    /* a failing release during the next scene's clear is a host error and keeps the old rows */
    x.f.fail_release = 1;
    CHECK(session_a77_begin_scene(x.b, x.scene) == A77_ERR_HOST && strcmp(session_a77_failure(x.b), "0x77-scene-clear") == 0);
    CHECK(session_a77_state(x.b)->active == 0u && session_a77_state(x.b)->surface == 77u);
    x.host.kernel = x.f.host;
    session_a77_destroy(x.b);
    x.b = session_a77_create(&x.host);
    CHECK(x.b != NULL && session_a77_begin_scene(x.b, x.scene) == A77_OK);
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_ERROR); /* phase 0 releases first */
    scene_resource_close(x.scene);
    session_a77_destroy(x.b);
}

static void t_binding_host_error_maps_to_error(void)
{
    Bind x;
    uint32_t ph = 0u;
    int done = 0;
    uint32_t np = 0u;
    if (!bind_open(&x, 1)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_a77_begin_scene(x.b, x.scene) == A77_OK);
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    x.f.fail_play = 1;
    {
        A77PointerResult p;
        CHECK(session_a77_pointer_move(x.b, 5, 5, &p) == A77_OK && p.hit == 1u);
        CHECK(session_a77_click(x.b, 1u, 0x2719, 1, &np) == A77_ERR_HOST);
        CHECK(strcmp(session_a77_failure(x.b), "0x77-click") == 0);
    }
    CHECK(session_a77_state(x.b)->count >= 1);
    bind_close(&x);
}

typedef void (*TestFn)(void);
static void run(const char *name, TestFn fn)
{
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
    run("state_reset", t_reset);
    run("phase0", t_phase0);
    run("phase0_limit", t_phase0_limit);
    run("phase0_sound_and_release", t_phase0_sound_and_release);
    run("phase0_failure", t_phase0_failure);
    run("step0_solved_detection", t_step0_solved_detection);
    run("step0_unsolved_reset", t_step0_unsolved_reset);
    run("step1_flag_and_deadline", t_step1_flag_and_deadline);
    run("step2_timer_and_sound", t_step2_timer_and_sound);
    run("step3_sound_busy", t_step3_sound_busy);
    run("step_out_of_range", t_step_out_of_range);
    run("other_phase_is_ignored", t_other_phase_is_ignored);
    run("phase12_need_phase0", t_phase12_need_phase0);
    run("phase2_solved", t_phase2_solved);
    run("phase2_exit", t_phase2_exit);
    run("phase2_failures", t_phase2_failures);
    run("pointer", t_pointer);
    run("click_toggle", t_click_toggle);
    run("click_gating_and_sound", t_click_gating_and_sound);
    run("click_bounds", t_click_bounds);
    run("render_plan", t_render_plan);
    run("clear", t_clear);
    run("full_playthrough", t_full_playthrough);
    run("unsolved_cycle", t_unsolved_cycle);
    run("binding_flow", t_binding_flow);
    run("binding_scene_change_clears", t_binding_scene_change_clears);
    run("binding_refuses_bad_body", t_binding_refuses_bad_body);
    run("binding_host_error", t_binding_host_error_maps_to_error);
    printf("TOTAL %d FAILED %d\n", g_total, g_failures);
    return g_failures;
}
