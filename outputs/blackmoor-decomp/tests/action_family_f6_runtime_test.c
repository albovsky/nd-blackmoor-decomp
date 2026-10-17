/* RT-47 unit tests of the raw 0xf6 card puzzle kernel (src/action_family_f6_runtime.c). Prints
 * "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure count. Fixtures are synthetic bodies (no
 * original bytes). tests/test_action_family_f6_runtime.py builds and runs this with and without ASan/UBSan and under
 * source mutations. */
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_f6_runtime.h"

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

typedef struct Fx {
    F6Object obj;
    F6World world;
    F6Host host;
    uint8_t body[F6_BODY_BYTES];
    char log[4096];
    int fail_alloc, fail_sound, fail_flag, fail_transition;
    uint32_t seed;
    uint32_t clock;
    uint32_t step;
    int busy_answer;
    const char *text; /* autotext answer, NULL = key absent */
    char last_caption[64];
    int event_flags[8];
    int scene_changes;
    int16_t last_scene;
    uint32_t phase;
    int completed;
    int32_t script[32]; /* scripted _rand answers, then the LCG */
    int script_n, script_i;
} Fx;

static void put16(uint8_t *b, size_t off, int v) { b[off] = (uint8_t)v; b[off + 1] = (uint8_t)(v >> 8); }
static void put32(uint8_t *b, size_t off, int32_t v)
{
    for (int i = 0; i < 4; ++i) b[off + (size_t)i] = (uint8_t)((uint32_t)v >> (8 * i));
}
static void set_name(uint8_t *b, size_t off, const char *s)
{
    memset(b + off, 0, F6_NAME_BYTES);
    strncpy((char *)b + off, s, F6_NAME_BYTES - 1u);
}
static void put_rect(uint8_t *b, size_t off, int l, int t, int r, int bt)
{
    put32(b, off, l);
    put32(b, off + 4, t);
    put32(b, off + 8, r);
    put32(b, off + 12, bt);
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

static const char *const effect_names[] = {"?", "start", "clritem", "slot", "reg", "load", "slotsurf", "prep",
                                           "busy", "play", "tick", "rand", "autotext", "caption", "phase", "x57b",
                                           "x599", "x595", "x39ff", "x59b", "x59f", "x5a3", "mode", "evflag",
                                           "complete", "relsurf", "relslot", "dirty"};

static void observe(void *c, int e, int32_t a, int32_t b)
{
    Fx *f = (Fx *)c;
    /* rand and tick are bulk noise in the flow tests: only logged when the test looks for them */
    logf_(f, "%s:%d:%d", effect_names[e], a, b);
}
static int alloc_slot(void *c, int16_t *slot)
{
    if (((Fx *)c)->fail_alloc) return 1;
    *slot = 0x18;
    return 0;
}
static int register_slot(void *c, int16_t slot, const char *label)
{
    (void)c;
    (void)slot;
    return strcmp(label, "MATCH PUZZLE OVERLAYS") != 0;
}
static int load_surface(void *c, const char *name, uint32_t *surface)
{
    (void)c;
    if (strcmp(name, "SHEET") != 0) return 1;
    *surface = 77u;
    return 0;
}
static int set_slot_surface(void *c, int16_t slot, uint32_t surface) { (void)c; (void)slot; (void)surface; return 0; }
static int release_surface(void *c, uint32_t s) { (void)c; (void)s; return 0; }
static int release_slot(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int mark_dirty(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int view_origin(void *c, int32_t *x, int32_t *y) { (void)c; *x = 10; *y = 20; return 0; }
static int clear_item(void *c) { (void)c; return 0; }
static int sound_prepare(void *c, const uint8_t *r) { (void)c; (void)r; return 0; }
static int sound_play(void *c, int16_t ch) { (void)ch; return ((Fx *)c)->fail_sound; }
static int sound_busy(void *c, int16_t ch, int32_t *r) { (void)ch; *r = ((Fx *)c)->busy_answer; return 0; }
static uint32_t tick(void *c)
{
    Fx *f = (Fx *)c;
    f->clock += f->step;
    return f->clock;
}
static int32_t rnd(void *c)
{
    Fx *f = (Fx *)c;
    if (f->script_i < f->script_n) return f->script[f->script_i++];
    f->seed = f->seed * 214013u + 2531011u;
    return (int32_t)((f->seed >> 16) & 0x7fffu);
}
static int autotext(void *c, const char *key, const char **text)
{
    Fx *f = (Fx *)c;
    (void)key;
    *text = f->text;
    return 0;
}
static int caption(void *c, const char *text, size_t length)
{
    Fx *f = (Fx *)c;
    snprintf(f->last_caption, sizeof f->last_caption, "%.*s", (int)(length < 60u ? length : 60u), text);
    return 0;
}
static int flag_invalid(void *c, int16_t i) { (void)c; return i < 0 || i >= 8; }
static int transition(void *c, const F6Transition *t)
{
    Fx *f = (Fx *)c;
    if (f->fail_transition) return 1;
    f->scene_changes++;
    f->last_scene = t->scene;
    return 0;
}
static int store_flag(void *c, int16_t i, uint32_t v)
{
    Fx *f = (Fx *)c;
    if (f->fail_flag) return 1;
    f->event_flags[i] = (int)v;
    return 0;
}

#define COLS 3
#define ROWS 2

static void make_body(uint8_t *b)
{
    memset(b, 0, F6_BODY_BYTES);
    set_name(b, 0, "SHEET");
    b[0x21] = 1;
    b[0x22] = 0;
    b[0x23] = 0; /* the computer starts */
    b[0x24] = 0;
    put16(b, 0x25, COLS);
    put16(b, 0x27, ROWS);
    put16(b, 0x29, 1);
    put_rect(b, 0x2b, 1, 1, 2, 2);
    put_rect(b, 0x3b, 3, 3, 4, 4);
    put_rect(b, 0x4b, 5, 5, 6, 8); /* turn marker 0 destination: top != bottom => has_turn */
    put_rect(b, 0x5b, 7, 7, 8, 10);
    put_rect(b, 0x47b, 0, 100, 10, 110);
    put16(b, 0x62b, 3);
    put16(b, 0x62d, 5);
    put32(b, 0x62f, 10);
    for (int i = 0; i < 2; ++i) put_rect(b, 0x633 + (size_t)i * 16u, 100 + i * 50, 300, 130 + i * 50, 340);
    for (int k = 0; k < COLS; ++k) put_rect(b, 0x653 + (size_t)k * 16u, 20 + k * 40, 400, 50 + k * 40, 420);
    for (int r = 0; r < ROWS; ++r)
        for (int k = 0; k < COLS; ++k) {
            put_rect(b, 0x723 + (size_t)r * 0xd0u + (size_t)k * 16u, 10 + k * 40, 20 + r * 50, 40 + k * 40, 60 + r * 50);
            put_rect(b, 0x6b + (size_t)r * 0xd0u + (size_t)k * 16u, 500 + k * 40, 20 + r * 50, 530 + k * 40, 60 + r * 50);
        }
    set_name(b, 0xba3, "PICK");
    set_name(b, 0xbc4, "NO SOUND");
    set_name(b, 0xbe5, "NO SOUND");
    set_name(b, 0xc06, "NO SOUND");
    for (int k = 0; k < 13; ++k) {
        set_name(b, 0xc2b + (size_t)k * 0x21u, "");
        set_name(b, 0xf68 + (size_t)k * 0x21u, "");
    }
    for (int p = 0; p < 2; ++p) {
        const size_t base = 0xdd8u + (size_t)p * 0x33du;
        for (int k = 0; k < 5; ++k) set_name(b, base + (size_t)k * 0x21u, "SND");
        for (int k = 0; k < 3; ++k) set_name(b, base + 0xa5u + (size_t)k * 0x21u, "SND");
        for (int k = 0; k < 2; ++k) {
            set_name(b, base + 0x108u + (size_t)k * 0x21u, "SND");
            set_name(b, base + 0x14au + (size_t)k * 0x21u, "SND");
        }
    }
    for (int k = 0; k < 3; ++k) set_name(b, 0x12a1 + (size_t)k * 0x21u, "SND");
    put16(b, 0xf64, 85);
    put16(b, 0xf66, 85);
    put16(b, 0x1304, 2000);
    put16(b, 0x1306, 2001);
    put16(b, 0x1308, 1);
    put16(b, 0x130a, 2);
    put16(b, 0x130c, 3);
    put32(b, 0x130e, 11);
    put32(b, 0x1312, 12);
    put32(b, 0x1316, 13);
    put16(b, 0x131a, 0);
    put16(b, 0x131c, 3);
    put16(b, 0x131e, 4);
    put16(b, 0x1320, 3000);
    put16(b, 0x1322, 7);
    put16(b, 0x1334, 1);
    put_rect(b, 0x1336, 600, 0, 640, 40);
}

static void fx_init(Fx *f)
{
    memset(f, 0, sizeof *f);
    f6_object_reset(&f->obj);
    make_body(f->body);
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
    f->host.sound_play = sound_play;
    f->host.sound_busy = sound_busy;
    f->host.tick = tick;
    f->host.random = rnd;
    f->host.autotext = autotext;
    f->host.caption = caption;
    f->host.transition = transition;
    f->host.store_event_flag = store_flag;
    f->host.event_flag_invalid = flag_invalid;
    f->host.observe = observe;
    f->seed = 12345u;
    f->clock = 1000u;
    f->step = 7u;
}

static int run(Fx *f, uint32_t phase, int16_t row)
{
    F6Result r;
    const char *why = NULL;
    const int rc = f6_step(&f->obj, f->body, F6_BODY_BYTES, row, phase, &f->world, &f->host, &r, &why);
    if (rc == F6_OK) {
        f->phase = r.phase_after;
        f->completed = r.completed;
    }
    return rc;
}

static int count_log(const Fx *f, const char *needle)
{
    int n = 0;
    for (const char *p = f->log; (p = strstr(p, needle)) != NULL; p += strlen(needle)) ++n;
    return n;
}

static int deck_total(const F6Object *o)
{
    int n = 0;
    for (int r = 0; r < F6_CARD_ROWS; ++r)
        for (int k = 0; k < F6_MAX_COLUMNS; ++k) n += o->deck[r][k];
    return n;
}

static int held_total(const F6Object *o, int p)
{
    int n = 0;
    for (int k = 0; k < F6_MAX_COLUMNS; ++k) n += o->count[p][k];
    return n;
}

static void t_validate(void)
{
    uint8_t b[F6_BODY_BYTES];
    const char *why = NULL;
    make_body(b);
    CHECK(f6_validate_body(b, F6_BODY_BYTES, &why) == F6_OK);
    CHECK(f6_validate_body(b, F6_BODY_BYTES - 1u, &why) == F6_ERR_BODY);
    put16(b, 0x25, 0);
    CHECK(f6_validate_body(b, F6_BODY_BYTES, &why) == F6_ERR_BODY);
    put16(b, 0x25, 14);
    CHECK(f6_validate_body(b, F6_BODY_BYTES, &why) == F6_ERR_BODY);
    put16(b, 0x25, COLS);
    put16(b, 0x27, 4);
    CHECK(f6_validate_body(b, F6_BODY_BYTES, &why) == F6_ERR_BODY);
    put16(b, 0x27, ROWS);
    put16(b, 0x29, -1);
    CHECK(f6_validate_body(b, F6_BODY_BYTES, &why) == F6_ERR_BODY);
    put16(b, 0x29, 1);
    memset(b + 0xba3, 'x', F6_NAME_BYTES);
    CHECK(f6_validate_body(b, F6_BODY_BYTES, &why) == F6_ERR_BODY);
}

static void t_phase0(Fx *f)
{
    fx_init(f);
    CHECK(run(f, 0, 3) == F6_OK);
    CHECK(f->phase == 1u);
    CHECK(f->obj.active == 1 && f->obj.row == 3 && f->obj.slot == 0x18 && f->obj.surface == 77u);
    CHECK(f->obj.state == 4 && f->obj.channel == 8);
    CHECK(f->world.start_flag_5bb1ca == 1);
    /* one card each was dealt out of ROWS * COLS */
    CHECK(f->obj.deck_left == ROWS * COLS - 2);
    CHECK(held_total(&f->obj, 0) == 1 && held_total(&f->obj, 1) == 1 && deck_total(&f->obj) == ROWS * COLS - 2);
    CHECK(f->obj.has_turn == 1 && f->obj.has_scores == 1 && f->obj.has_display == 1 && f->obj.has_exit == 1);
    CHECK(f->obj.has_delivery == 0 && f->obj.has_no_card == 0 && f->obj.has_sound_a == 0);
    CHECK(f->obj.order_count == -1 && f->obj.order[0] == -1);
    CHECK(f->obj.player == 0);
    CHECK(strncmp(f->log, "start:1:0,clritem:0:0,rand:", 27) == 0);
    CHECK(count_log(f, "rand:") == 4);
    CHECK(strstr(f->log, "slot:24:0,reg:24:0,load:77:0,slotsurf:24:77,phase:1:0") != NULL);
    /* the image is loaded only once per object */
    {
        const uint32_t surface = f->obj.surface;
        f->log[0] = '\0';
        f->obj.slot = -1;
        CHECK(run(f, 0, 3) == F6_OK);
        CHECK(f->obj.surface == surface && count_log(f, "load:") == 0);
    }
}

static void t_host_failure(Fx *f)
{
    fx_init(f);
    f->fail_alloc = 1;
    CHECK(run(f, 0, 0) == F6_ERR_HOST);
    fx_init(f);
    CHECK(run(f, 1, 0) == F6_ERR_UNSUPPORTED); /* no init */
    CHECK(run(f, 2, 0) == F6_ERR_UNSUPPORTED);
    CHECK(run(f, 7, 0) == F6_OK && f->phase == 7u);
}

/* The human clicks the first card of the first hand column found; returns 1 when a click was made. */
static int human_click(Fx *f)
{
    F6PointerResult pr;
    for (int k = 0; k < COLS; ++k)
        for (int r = 0; r < ROWS; ++r) {
            if (f->obj.card[1][r][k] == 1 && f->obj.count[1][k] < 3) {
                /* the button mode is on (has_exit): aim at the column button */
                CHECK(f6_pointer_move(&f->obj, f->body, F6_BODY_BYTES, (int16_t)(30 + k * 40), 410, &pr) == F6_OK);
                if (pr.hit == 0u) continue;
                CHECK(pr.candidate == F6_CANDIDATE_BUTTON && pr.cursor == F6_CURSOR_PICK && f->obj.selected == k);
                {
                    uint32_t np = 1u;
                    CHECK(f6_click(&f->obj, f->body, F6_BODY_BYTES, 1u, pr.candidate, &f->host, &np) == F6_OK);
                    CHECK(np == 1u);
                }
                return 1;
            }
        }
    return 0;
}

/* Plays a whole game: the human clicks a column whenever it waits (state 4, player 1). */
static int play_game(Fx *f, int *steps)
{
    int guard;
    CHECK(run(f, 0, 0) == F6_OK);
    for (guard = 0; guard < 20000; ++guard) {
        int rc;
        if (f->obj.state == 4 && f->obj.player == 1 && f->phase == 1u) {
            if (human_click(f) == 0) break;
        }
        rc = run(f, f->phase, 0);
        if (rc != F6_OK) {
            *steps = guard;
            return rc;
        }
        if (f->phase == 2u) break;
        f->log[0] = '\0';
    }
    *steps = guard;
    return F6_OK;
}

static void t_full_game(Fx *f)
{
    int steps = 0;
    fx_init(f);
    f->text = "hello";
    CHECK(play_game(f, &steps) == F6_OK);
    CHECK(steps < 20000);
    CHECK(f->phase == 2u);
    CHECK(f->obj.finished == 1);
    f->log[0] = '\0';
    CHECK(run(f, 2, 0) == F6_OK);
    CHECK(f->completed == 1 && f->phase == 0u && f->obj.active == 0 && f->obj.slot == -1 && f->obj.surface == 0u);
    CHECK(f->scene_changes == 1 && (f->last_scene == 2000 || f->last_scene == 2001));
    CHECK(strstr(f->log, "mode:4:0") != NULL && strstr(f->log, "complete:0:0") != NULL);
    CHECK(strstr(f->log, "relsurf:77:0,relslot:24:0") != NULL);
    CHECK(f->world.start_flag_5bb1ca == 1);
    CHECK(f->obj.score[0] + f->obj.score[1] >= 0);
}

static void t_pointer(Fx *f)
{
    F6PointerResult pr;
    fx_init(f);
    CHECK(f6_pointer_move(&f->obj, f->body, F6_BODY_BYTES, 30, 410, &pr) == F6_OK && pr.hit == 0u && pr.candidate == -1);
    CHECK(run(f, 0, 0) == F6_OK);
    /* not in state 4: the exit rectangle still answers */
    f->obj.state = 5;
    CHECK(f6_pointer_move(&f->obj, f->body, F6_BODY_BYTES, 30, 410, &pr) == F6_OK && pr.hit == 0u);
    CHECK(f6_pointer_move(&f->obj, f->body, F6_BODY_BYTES, 620, 20, &pr) == F6_OK && pr.hit == 1u);
    CHECK(pr.candidate == F6_CANDIDATE_EXIT && pr.cursor == F6_CURSOR_EXIT && pr.sprite == 1u);
    /* edges are inclusive */
    CHECK(f6_pointer_move(&f->obj, f->body, F6_BODY_BYTES, 600, 0, &pr) == F6_OK && pr.hit == 1u);
    CHECK(f6_pointer_move(&f->obj, f->body, F6_BODY_BYTES, 640, 40, &pr) == F6_OK && pr.hit == 1u);
    CHECK(f6_pointer_move(&f->obj, f->body, F6_BODY_BYTES, 641, 40, &pr) == F6_OK && pr.hit == 0u);
    CHECK(f6_pointer_move(&f->obj, f->body, F6_BODY_BYTES, 640, 41, &pr) == F6_OK && pr.hit == 0u);
    /* state 4 with the buttons: a column the human holds (1..2 cards) is a button hit */
    f->obj.state = 4;
    f->obj.count[1][1] = 1;
    CHECK(f6_pointer_move(&f->obj, f->body, F6_BODY_BYTES, 70, 400, &pr) == F6_OK && pr.hit == 1u);
    CHECK(pr.candidate == F6_CANDIDATE_BUTTON && pr.sprite == 2u && f->obj.selected == 1);
    f->obj.count[1][1] = 0;
    CHECK(f6_pointer_move(&f->obj, f->body, F6_BODY_BYTES, 70, 400, &pr) == F6_OK && pr.hit == 0u);
    f->obj.count[1][1] = 3;
    CHECK(f6_pointer_move(&f->obj, f->body, F6_BODY_BYTES, 70, 400, &pr) == F6_OK && pr.hit == 0u);
    /* card mode (no buttons): a held card with fewer than three in its column */
    f->obj.has_exit = 0;
    f->obj.count[1][1] = 1;
    f->obj.card[1][1][1] = 1;
    CHECK(f6_pointer_move(&f->obj, f->body, F6_BODY_BYTES, 50, 80, &pr) == F6_OK && pr.hit == 1u);
    CHECK(pr.candidate == F6_CANDIDATE_CARD && f->obj.selected == 1);
    f->obj.card[1][1][1] = 0;
    CHECK(f6_pointer_move(&f->obj, f->body, F6_BODY_BYTES, 50, 80, &pr) == F6_OK && pr.hit == 0u);
}

static void t_click(Fx *f)
{
    uint32_t np = 0;
    fx_init(f);
    CHECK(run(f, 0, 0) == F6_OK);
    f->obj.state = 4;
    CHECK(f6_click(&f->obj, f->body, F6_BODY_BYTES, 1u, F6_CANDIDATE_CARD, &f->host, &np) == F6_OK && np == 1u);
    CHECK(f->obj.state == 5);
    f->obj.state = 4;
    CHECK(f6_click(&f->obj, f->body, F6_BODY_BYTES, 0u, F6_CANDIDATE_CARD, &f->host, &np) == F6_OK);
    CHECK(f->obj.state == 4); /* the row phase must be 1 */
    f->obj.state = 10;
    CHECK(f6_click(&f->obj, f->body, F6_BODY_BYTES, 1u, F6_CANDIDATE_CARD, &f->host, &np) == F6_OK && f->obj.state == 10);
    f->obj.state = 4;
    f->obj.finished = 1;
    CHECK(f6_click(&f->obj, f->body, F6_BODY_BYTES, 1u, F6_CANDIDATE_EXIT, &f->host, &np) == F6_OK);
    CHECK(np == 1u && f->obj.exit_taken == 0);
    f->obj.finished = 0;
    /* a button click plays its line (here "PICK" is real) and asks for the column choice after it */
    f->text = "x";
    f->log[0] = '\0';
    CHECK(f6_click(&f->obj, f->body, F6_BODY_BYTES, 1u, F6_CANDIDATE_BUTTON, &f->host, &np) == F6_OK);
    CHECK(f->obj.button_down == 1 && f->obj.redraw_298 == 1 && f->obj.next_state == 5 && f->obj.state == 10);
    CHECK(strstr(f->log, "prep:0:0,play:8:0,autotext:1:0,caption:1:0") != NULL);
    CHECK(strcmp(f->last_caption, "x<e>") == 0 && f->obj.caption_shown == 1 && f->obj.channel == 8);
    /* the exit asks for phase 2 and finishes through the exit block */
    f->obj.state = 4;
    CHECK(f6_click(&f->obj, f->body, F6_BODY_BYTES, 1u, F6_CANDIDATE_EXIT, &f->host, &np) == F6_OK);
    CHECK(np == 2u && f->obj.exit_taken == 1);
    f->log[0] = '\0';
    CHECK(run(f, 2, 0) == F6_OK);
    CHECK(f->completed == 1 && f->scene_changes == 1 && f->last_scene == 3000);
    CHECK(f->world.start_flag_5bb1ca == 0); /* exit block start word 1 */
}

static void t_finish_blocks(Fx *f)
{
    fx_init(f);
    CHECK(run(f, 0, 0) == F6_OK);
    /* finished by a win of the human: scene 2000, event flag 3 */
    f->obj.finished = 1;
    f->obj.outcome_2a8 = 1;
    f->obj.outcome_2a9 = 0;
    CHECK(run(f, 2, 0) == F6_OK);
    CHECK(f->last_scene == 2000 && f->event_flags[3] == 1 && f->event_flags[4] == 0);
    /* +0x2a9 selects the second scene block, the flag index follows +0x2a8 (the dead compare at 0x45df30 is the only
     * writer of +0x2a9 besides init, so the game never reaches this path; the oracle drives it directly) */
    fx_init(f);
    CHECK(run(f, 0, 0) == F6_OK);
    f->obj.finished = 1;
    f->obj.outcome_2a8 = 1;
    f->obj.outcome_2a9 = 1;
    CHECK(run(f, 2, 0) == F6_OK);
    CHECK(f->last_scene == 2001 && f->event_flags[4] == 0 && f->event_flags[3] == 1);
    /* flag -1 stores nothing */
    fx_init(f);
    put16(f->body, 0x131c, -1);
    CHECK(run(f, 0, 0) == F6_OK);
    f->obj.finished = 1;
    f->obj.outcome_2a8 = 1;
    f->obj.outcome_2a9 = 0;
    CHECK(run(f, 2, 0) == F6_OK && f->event_flags[3] == 0);
    /* scene 9999 changes nothing but the flag is still stored */
    fx_init(f);
    put16(f->body, 0x1304, 9999);
    CHECK(run(f, 0, 0) == F6_OK);
    f->obj.finished = 1;
    f->obj.outcome_2a8 = 1;
    CHECK(run(f, 2, 0) == F6_OK && f->scene_changes == 0 && f->event_flags[3] == 1);
    /* an invalid flag is refused before any effect */
    fx_init(f);
    put16(f->body, 0x131c, 77);
    CHECK(run(f, 0, 0) == F6_OK);
    f->obj.finished = 1;
    f->obj.outcome_2a8 = 1;
    f->log[0] = '\0';
    CHECK(run(f, 2, 0) == F6_ERR_BOUNDS && f->log[0] == '\0' && f->obj.active == 1);
    /* not finished: the finish stores nothing and still completes */
    fx_init(f);
    CHECK(run(f, 0, 0) == F6_OK);
    CHECK(run(f, 2, 0) == F6_OK && f->scene_changes == 0 && f->completed == 1);
    /* a host failure keeps the object */
    fx_init(f);
    CHECK(run(f, 0, 0) == F6_OK);
    f->obj.exit_taken = 1;
    f->fail_transition = 1;
    CHECK(run(f, 2, 0) == F6_ERR_HOST && f->obj.active == 1);
}

static void t_cleanup_and_invalidate(Fx *f)
{
    fx_init(f);
    CHECK(f6_invalidate(&f->obj, &f->host) == F6_OK && f->log[0] == '\0');
    CHECK(f6_cleanup(&f->obj, &f->host) == F6_OK && f->log[0] == '\0');
    CHECK(run(f, 0, 2) == F6_OK);
    f->log[0] = '\0';
    CHECK(f6_invalidate(&f->obj, &f->host) == F6_OK && strcmp(f->log, "dirty:24:0") == 0);
    f->log[0] = '\0';
    CHECK(f6_cleanup(&f->obj, &f->host) == F6_OK);
    CHECK(strcmp(f->log, "relsurf:77:0,relslot:24:0") == 0);
    CHECK(f->obj.slot == -1 && f->obj.row == -1 && f->obj.active == 0 && f->obj.anim_frame == -1 &&
          f->obj.slide_step == -1 && f->obj.delivery_step == -1);
    f->log[0] = '\0';
    CHECK(f6_cleanup(&f->obj, &f->host) == F6_OK && f->log[0] == '\0');
}

static void script(Fx *f, int n, const int32_t *v)
{
    memcpy(f->script, v, (size_t)n * sizeof v[0]);
    f->script_n = n;
    f->script_i = 0;
}

static void t_pick_line(Fx *f)
{
    /* the pick list of the "found" kind has three real names and the scripted rand chooses */
    fx_init(f);
    CHECK(run(f, 0, 0) == F6_OK);
    for (int k = 0; k < 3; ++k) set_name(f->body, 0xe7d + 0x33d + (size_t)k * 0x21u, k == 1 ? "REAL" : "NO SOUND");
    f->text = "y";
    f->obj.player = 0; /* the list of (player == 0) * 0x33d => the second list is asked when player is 0 */
    f->obj.state = 6;
    f->obj.selected = 0;
    f->obj.card[1][0][0] = 1;
    f->obj.count[1][0] = 1;
    f->log[0] = '\0';
    {
        static const int32_t v[] = {4}; /* 4 % 3 = 1: the real name */
        script(f, 1, v);
    }
    CHECK(run(f, 1, 0) == F6_OK);
    CHECK(f->script_i == 1 && strcmp((const char *)f->obj.record, "REAL") == 0);
    CHECK(strstr(f->log, "rand:4:0,prep:0:0") != NULL);
    CHECK(strstr(f->log, "prep:0:0") != NULL);
    CHECK(f->obj.state == 10 && f->obj.next_state != 0);
    CHECK(f->obj.card[1][0][0] == 0 && f->obj.card[0][0][0] >= 0);
}

static void t_deal_stuck(Fx *f)
{
    fx_init(f);
    CHECK(run(f, 0, 0) == F6_OK);
    memset(f->obj.deck, 0, sizeof f->obj.deck);
    f->obj.deck_left = 3;
    f->obj.state = 9;
    f->obj.warned_3ab = 0;
    CHECK(run(f, 1, 0) == F6_ERR_STUCK);
}

static void t_render(Fx *f)
{
    static F6RenderPlan plan;
    fx_init(f);
    CHECK(f6_render_plan(&f->obj, f->body, F6_BODY_BYTES, &f->host, &plan) == F6_OK && plan.valid == 0u);
    CHECK(run(f, 0, 0) == F6_OK);
    CHECK(f6_render_plan(&f->obj, f->body, F6_BODY_BYTES, &f->host, &plan) == F6_OK);
    CHECK(plan.valid == 1u && plan.surface == 77u);
    {
        int restore = 0, keyed = 0, opaque = 0;
        for (int i = 0; i < plan.count; ++i) {
            restore += plan.blit[i].kind == F6_BLIT_RESTORE;
            keyed += plan.blit[i].kind == F6_BLIT_SHEET_KEYED;
            opaque += plan.blit[i].kind == F6_BLIT_SHEET_OPAQUE;
        }
        /* 6 card slots (5 empty restores, 1 keyed card) + the turn marker pair */
        CHECK(keyed == 1 && restore == 5 + 1 && opaque == 1);
        CHECK(plan.blit[0].kind == F6_BLIT_RESTORE);
        CHECK(plan.blit[0].src[0] == 10 && plan.blit[0].dst[0] == 20 && plan.blit[0].dst[1] == 40 &&
              plan.blit[0].dst[2] == 50 && plan.blit[0].dst[3] == 80); /* view origin (10, 20) applied to dst only */
    }
    /* the button redraw is consumed by the render callback */
    f->obj.redraw_298 = 1;
    f->obj.clear_29e = 1;
    f->obj.flip_2ac = 1;
    f->obj.selected = 1;
    CHECK(f6_render_plan(&f->obj, f->body, F6_BODY_BYTES, &f->host, &plan) == F6_OK);
    CHECK(f->obj.redraw_298 == 0 && f->obj.clear_29e == 0 && f->obj.flip_2ac == 0);
    f->obj.button_down = 1;
    {
        const int before = plan.count;
        CHECK(f6_render_plan(&f->obj, f->body, F6_BODY_BYTES, &f->host, &plan) == F6_OK);
        CHECK(plan.count != 0 && before != 0);
        CHECK(f->obj.redraw_298 == 0);
    }
}

static void t_pack(Fx *f)
{
    uint8_t image[F6_IMAGE_BYTES], mask[F6_IMAGE_BYTES];
    fx_init(f);
    CHECK(run(f, 0, 5) == F6_OK);
    f6_object_pack(&f->obj, image, mask);
    CHECK(mask[0x1c] == 1 && mask[0x321] == 1 && mask[0x3ae] == 1 && mask[0x31d] == 0);
    CHECK(image[0x1e] == 5 && image[0x321] == 1 && image[0x39e] == 4);
    CHECK(image[0x2a6] == (uint8_t)(ROWS * COLS - 2));
}


static void t_deal_scripted(Fx *f)
{
    /* player 0: row 3 % 2 = 1, column 2 % 3 = 2; player 1 first draws the taken card again, then row 0 / column 1 */
    static const int32_t v[] = {3, 2, 3, 2, 0, 1};
    fx_init(f);
    script(f, 6, v);
    CHECK(run(f, 0, 0) == F6_OK);
    CHECK(f->script_i == 6);
    CHECK(f->obj.card[0][1][2] == 1 && f->obj.count[0][2] == 1 && f->obj.deck[1][2] == 0);
    CHECK(f->obj.card[1][0][1] == 1 && f->obj.count[1][1] == 1 && f->obj.deck[0][1] == 0);
    CHECK(f->obj.deck_left == ROWS * COLS - 2);
}

static void t_deal_column_limit(Fx *f)
{
    /* with more cards left than columns a player is dealt a card only into a column that holds fewer than two */
    static const int32_t v[] = {0, 1, 1, 1, 0, 0};
    fx_init(f);
    CHECK(run(f, 0, 0) == F6_OK);
    memset(f->obj.count, 0, sizeof f->obj.count);
    memset(f->obj.card, 0, sizeof f->obj.card);
    memset(f->obj.deck, 1, sizeof f->obj.deck);
    f->obj.deck_left = ROWS * COLS;
    f->obj.count[0][1] = 2;
    f->obj.state = 9; /* draw */
    f->obj.player = 0;
    f->obj.warned_3ab = 0;
    script(f, 6, v);
    CHECK(run(f, 1, 0) == F6_OK);
    CHECK(f->script_i == 6 && f->obj.card[0][0][0] == 1 && f->obj.count[0][0] == 1 && f->obj.count[0][1] == 2);
}

static void t_deal_last_cards_free(Fx *f)
{
    static const int32_t v[] = {0, 1};
    fx_init(f);
    CHECK(run(f, 0, 0) == F6_OK);
    memset(f->obj.deck, 0, sizeof f->obj.deck);
    f->obj.deck[0][1] = 1;
    f->obj.deck_left = COLS; /* as many cards as columns: free pick */
    f->obj.count[0][1] = 2;
    f->obj.state = 9;
    f->obj.player = 0;
    f->obj.warned_3ab = 0;
    script(f, 2, v);
    CHECK(run(f, 1, 0) == F6_OK);
    CHECK(f->script_i == 2 && f->obj.count[0][1] == 3 && f->obj.deck_left == COLS - 1);
}

static void t_refill_after_choose(Fx *f)
{
    static const int32_t v[] = {0, 0};
    fx_init(f);
    CHECK(run(f, 0, 0) == F6_OK);
    memset(f->obj.count, 0, sizeof f->obj.count);
    memset(f->obj.deck, 1, sizeof f->obj.deck);
    f->obj.deck_left = ROWS * COLS;
    f->obj.score[1] = 1;
    f->obj.count[1][0] = 3; /* the human holds exactly the scored sets: one card is dealt */
    f->obj.player = 1;
    f->obj.selected = 0;
    f->obj.state = 5;
    script(f, 2, v);
    CHECK(run(f, 1, 0) == F6_OK);
    CHECK(f->script_i == 2 && f->obj.deck_left == ROWS * COLS - 1 && f->obj.order_count == 0 && f->obj.order[0] == 0);
    CHECK(f->obj.state == 6);
}

static void t_computer_pick(Fx *f)
{
    /* empty column 0 and full column 2 are skipped; column 1 holds a card */
    static const int32_t v[] = {0, 2, 1};
    fx_init(f);
    CHECK(run(f, 0, 0) == F6_OK);
    memset(f->obj.count, 0, sizeof f->obj.count);
    f->obj.count[0][1] = 1;
    f->obj.count[0][2] = 3;
    f->obj.score[0] = 1;
    f->obj.player = 0;
    f->obj.state = 5;
    f->obj.order_count = -1;
    script(f, 3, v);
    CHECK(run(f, 1, 0) == F6_OK);
    CHECK(f->script_i == 3 && f->obj.selected == 1 && f->obj.order_count == 0 && f->obj.order[0] == 1);
    CHECK(f->obj.state == 7);
    /* a column that was already asked for is skipped when the computer holds several sets */
    fx_init(f);
    CHECK(run(f, 0, 0) == F6_OK);
    {
        static const int32_t w[] = {0, 1};
        memset(f->obj.count, 0, sizeof f->obj.count);
        f->obj.count[0][0] = 1;
        f->obj.count[0][1] = 2;
        f->obj.score[0] = 0;
        f->obj.player = 0;
        f->obj.state = 5;
        f->obj.order_count = 0;
        f->obj.order[0] = 0;
        script(f, 2, w);
        CHECK(run(f, 1, 0) == F6_OK);
        CHECK(f->script_i == 2 && f->obj.selected == 1 && f->obj.order_count == 1 && f->obj.order[1] == 1);
    }
}

static void t_ask_computer_takes_from_any_row(Fx *f)
{
    fx_init(f);
    CHECK(run(f, 0, 0) == F6_OK);
    memset(f->obj.card, 0, sizeof f->obj.card);
    memset(f->obj.count, 0, sizeof f->obj.count);
    f->obj.card[1][1][1] = 1; /* only the second suit row holds the column's card */
    f->obj.count[1][1] = 1;
    f->obj.player = 0;
    f->obj.selected = 1;
    f->obj.deliver_29c = 1;
    f->obj.state = 7;
    f->obj.display_count = 0;
    f->obj.flip_2ab = 0;
    CHECK(run(f, 1, 0) == F6_OK);
    CHECK(f->obj.card[1][1][1] == 0 && f->obj.card[0][1][1] == 1 && f->obj.state == 3);
}

static void t_game_end_outcome(Fx *f)
{
    struct { int16_t s0, s1; uint8_t mode; int16_t player; int expect; } c[] = {
        {2, 1, 0, 0, 0}, {1, 2, 0, 0, 1}, {1, 1, 2, 1, 1}, {1, 1, 2, 0, 0}, {1, 1, 0, 1, 0}, {1, 1, 255, 0, 1}};
    for (size_t i = 0; i < sizeof c / sizeof c[0]; ++i) {
        fx_init(f);
        f->text = "t";
        put16(f->body, 0, 0);
        set_name(f->body, 0, "SHEET");
        f->body[0x24] = c[i].mode;
        CHECK(run(f, 0, 0) == F6_OK);
        f->obj.deck_left = 0;
        f->obj.score[0] = c[i].s0;
        f->obj.score[1] = c[i].s1;
        f->obj.player = c[i].player;
        f->obj.state = 9;
        f->obj.warned_3ab = 0;
        CHECK(run(f, 1, 0) == F6_OK);
        CHECK(f->obj.outcome_2a8 == c[i].expect && f->obj.next_state == 12 && f->obj.state == 10);
    }
}

static void t_forward_slide_and_refill(Fx *f)
{
    fx_init(f);
    CHECK(run(f, 0, 0) == F6_OK);
    memset(f->obj.card, 0, sizeof f->obj.card);
    memset(f->obj.count, 0, sizeof f->obj.count);
    f->obj.card[0][0][1] = 1;
    f->obj.count[0][1] = 1;
    f->obj.player = 1;
    f->obj.selected = 1;
    f->obj.card_row = 0;
    f->obj.slide_2d4 = 1;
    f->obj.state = 6;
    CHECK(run(f, 1, 0) == F6_OK);
    /* the card slides in from the sheet position moved back by (steps - 1) * step = 10 */
    CHECK(f->obj.state == 3 && f->obj.flip_2ac == 1 && f->obj.slide_2d4 == 0);
    CHECK(f->obj.slide_forward == 1 && f->obj.slide_step == 0);
    CHECK(f->obj.slide_sheet[0][0] == 540 - 10 && f->obj.slide_sheet[0][2] == 570 - 10);
    CHECK(f->obj.deadline_anim == 1007u + 10u);
    CHECK(f->obj.card[1][0][1] == 1 && f->obj.card[0][0][1] == 0);
}

static void t_refill_of_empty_hand(Fx *f)
{
    static const int32_t v[] = {0, 0, 0};
    fx_init(f);
    CHECK(run(f, 0, 0) == F6_OK);
    memset(f->obj.card, 0, sizeof f->obj.card);
    memset(f->obj.count, 0, sizeof f->obj.count);
    memset(f->obj.deck, 1, sizeof f->obj.deck);
    f->obj.deck_left = ROWS * COLS;
    f->obj.card[0][0][1] = 1; /* the computer's only card is asked for */
    f->obj.count[0][1] = 1;
    f->obj.score[0] = 1;
    f->obj.player = 1;
    f->obj.selected = 1;
    f->obj.slide_2d4 = 0;
    f->obj.state = 6;
    script(f, 3, v);
    CHECK(run(f, 1, 0) == F6_OK);
    CHECK(f->obj.card[1][0][1] == 1 && f->obj.state == 10);
    CHECK(f->obj.deck_left == ROWS * COLS - 1 && f->obj.count[0][0] == 1);
}

typedef void (*TestFn)(Fx *);
static void run_test(const char *name, TestFn fn)
{
    static Fx fx;
    g_name = name;
    g_failed = 0;
    ++g_total;
    memset(&fx, 0, sizeof fx);
    fx_init(&fx);
    fn(&fx);
    if (g_failed) {
        ++g_failures;
        printf("FAIL %s: %s\n  log: %s\n", name, g_msg, fx.log);
    } else {
        printf("PASS %s\n", name);
    }
}

static void t_validate_wrap(Fx *f) { (void)f; t_validate(); }

int main(void)
{
    run_test("validate_body", t_validate_wrap);
    run_test("phase0", t_phase0);
    run_test("host_failure_and_phase_guard", t_host_failure);
    run_test("pointer", t_pointer);
    run_test("click", t_click);
    run_test("finish_blocks", t_finish_blocks);
    run_test("cleanup_and_invalidate", t_cleanup_and_invalidate);
    run_test("pick_line", t_pick_line);
    run_test("deal_stuck_guard", t_deal_stuck);
    run_test("render_plan", t_render);
    run_test("pack_image", t_pack);
    run_test("deal_scripted", t_deal_scripted);
    run_test("deal_column_limit", t_deal_column_limit);
    run_test("deal_last_cards_free", t_deal_last_cards_free);
    run_test("refill_after_choose", t_refill_after_choose);
    run_test("computer_pick", t_computer_pick);
    run_test("ask_computer_any_row", t_ask_computer_takes_from_any_row);
    run_test("game_end_outcome", t_game_end_outcome);
    run_test("forward_slide", t_forward_slide_and_refill);
    run_test("refill_empty_hand", t_refill_of_empty_hand);
    run_test("full_game", t_full_game);
    printf("TOTAL %d FAILED %d\n", g_total, g_failures);
    return g_failures;
}
