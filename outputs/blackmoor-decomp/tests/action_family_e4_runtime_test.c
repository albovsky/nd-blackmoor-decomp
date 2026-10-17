/* RT-54 unit tests of the raw 0xe4 Match Puzzle kernel (src/action_family_e4_runtime.c) and its session binding
 * (src/session_bindings_ae4.c). Prints "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure count.
 * Fixtures are synthetic bodies (no original bytes); every case cites the original function it exercises (GAME.EXE
 * SHA-256 afd337a2...5c45): handler 0x476a25, board fill 0x475a1e, cell rectangle 0x475bef, CheckForMatch 0x4763b3, pointer
 * 0x475da4/0x475fb1, click 0x47608e, render 0x4778df, invalidate 0x4758e8, cleanup 0x475885/0x4757da, scene reset 0x47591f.
 * tests/test_action_family_e4_runtime.py builds and runs this with and without ASan/UBSan and under source mutations. */
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_e4_runtime.h"
#include "scene_resource.h"
#include "session_bindings_ae4.h"

static int g_failed, g_total, g_failures;
static char g_msg[512];
#define CHECK(cond)                                                            \
    do {                                                                       \
        if (!(cond) && !g_failed) {                                            \
            g_failed = 1;                                                      \
            snprintf(g_msg, sizeof g_msg, "line %d: %.200s", __LINE__, #cond); \
        }                                                                      \
    } while (0)
#define CHECK_LOG(fx, expected)                                                                \
    do {                                                                                       \
        if (strcmp((fx)->log, (expected)) != 0 && !g_failed) {                                 \
            g_failed = 1;                                                                      \
            snprintf(g_msg, sizeof g_msg, "line %d: log \"%.150s\" != \"%.150s\"", __LINE__,   \
                     (fx)->log, (expected));                                                   \
        }                                                                                      \
    } while (0)

/* Body offsets, written down independently of the kernel (see the header comment). */
enum {
    O_NAME = 0x00, O_SCORE_NAME = 0x21, O_ROWS = 0x42, O_COLS = 0x44, O_KINDS = 0x46, O_SHUFFLE_SRC = 0x48,
    O_PIECE = 0x58, O_NAME_PANEL = 0x238, O_FONT = 0x23a, O_FONT_PARAM = 0x23c, O_TITLE = 0x23e, O_PIECE_NAME = 0x25f,
    O_SCORE_PANEL = 0x63d, O_TIME_LIMIT = 0x63e, O_TARGET = 0x640, O_PER_PIECE = 0x644, O_MATCHED_SRC = 0x646,
    O_BONUS3_TIME = 0x656, O_BONUS4_SCORE = 0x658, O_BONUS4_TIME = 0x65a, O_BONUS5_SCORE = 0x65c, O_BONUS5_TIME = 0x65e,
    O_XOFF = 0x660, O_YOFF = 0x662, O_YGAP = 0x664, O_XGAP = 0x666, O_TITLE_RECT = 0x668, O_SHUFFLE_RECT = 0x678,
    O_TARGET_RECT = 0x688, O_SCORE_RECT = 0x698, O_TIME_RECT = 0x6a8, O_NAME_RECT = 0x6b8, O_ICON_RECT = 0x6c8,
    O_HS_X0 = 0x6d8, O_HS_Y0 = 0x6dc, O_HS_X1 = 0x6e0, O_HS_Y1 = 0x6e4, O_END_DELAY = 0x6e8, O_SOUND_A = 0x6ea,
    O_CHAN_A = 0x70b, O_SOUND_B = 0x71b, O_CHAN_B = 0x73c, O_SOUND_C = 0x74c, O_CHAN_C = 0x76d, O_WIN = 0x77d,
    O_FINAL_DELAY = 0x796, O_SOUND_D = 0x798, O_CHAN_D = 0x7b9, O_EXIT = 0x7c9, O_EXIT_RECT = 0x7e2
};
#define CELL(r, c) ((size_t)E4R_O_CELLS + (size_t)(r) * 200u + (size_t)(c) * 20u)

typedef enum {
    CB_ALLOC = 1, CB_REGISTER, CB_LOAD, CB_SETSURF, CB_RELSURF, CB_RELSLOT, CB_DIRTY, CB_VIEW, CB_PREPARE, CB_STOP, CB_PLAY,
    CB_BUSY, CB_RANDOM, CB_AMBIENT, CB_FONTREL, CB_TEXTEXT, CB_TRANSITION, CB_STOREFLAG
} Callback;

typedef struct Fx {
    E4rObject o;
    E4rWorld world;
    E4rHost host;
    uint8_t body[E4R_BODY_BYTES];
    char log[32768];
    uint32_t now;
    int32_t rand_script[512];
    int rand_n, rand_i, rand_stuck;
    uint32_t lcg;
    int32_t busy_script[32];
    int busy_n, busy_i, busy_default;
    int32_t view[4], full[4];
    int fail_call, calls;
    unsigned failed_mask;
    int n_alloc, n_dirty, n_relsurf, n_relslot, n_view, n_load, n_ambient, n_fontrel, n_textext, n_evinvalid, n_tr, n_flag, n_play,
        n_stop, n_prep;
    int16_t dirty_slot, fontrel_font, evinvalid_idx;
    char registered_label[40], loaded_name[2][40];
    int prep_off[8], stop_off[8];
    int16_t played[8];
    E4rTransition tr;
    int16_t flag_idx;
    uint32_t flag_val;
    int event_invalid;
    int16_t text_height;
    E4rResult res;
    const char *failure;
    int rc;
    int16_t row;
} Fx;

static void put16(uint8_t *b, size_t off, int v) { b[off] = (uint8_t)v; b[off + 1] = (uint8_t)(v >> 8); }
static int16_t get16(const uint8_t *b, size_t off) { return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8)); }
static int32_t get32(const uint8_t *b, size_t off)
{
    return (int32_t)((uint32_t)b[off] | ((uint32_t)b[off + 1] << 8) | ((uint32_t)b[off + 2] << 16) | ((uint32_t)b[off + 3] << 24));
}
static void put32(uint8_t *b, size_t off, int32_t v)
{
    for (int i = 0; i < 4; ++i) b[off + (size_t)i] = (uint8_t)((uint32_t)v >> (8 * i));
}
static void put_rect(uint8_t *b, size_t off, int32_t l, int32_t t, int32_t r, int32_t bt)
{
    put32(b, off, l);
    put32(b, off + 4, t);
    put32(b, off + 8, r);
    put32(b, off + 12, bt);
}
static void put_text(uint8_t *b, size_t off, const char *s) { memcpy(b + off, s, strlen(s) + 1u); }

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

static const char *const effect_names[] = {"?", "start", "amb", "rand", "slot", "slotreg", "load", "slotsurf", "phase", "prep",
                                           "stop", "play", "busy", "tick", "x57b", "x599", "x595", "x39ff", "x59b", "x59f",
                                           "x5a3", "mode", "evflag", "fontrel", "complete", "relsurf", "relslot", "dirty",
                                           "textext"};
static void observe(void *c, int e, int32_t a, int32_t b) { logf_((Fx *)c, "%s:%d:%d", effect_names[e], a, b); }

static int fail_hit(Fx *f, int id)
{
    if (++f->calls == f->fail_call) {
        f->failed_mask |= 1u << id;
        return 1;
    }
    return 0;
}

static int h_alloc(void *c, int16_t *slot)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_ALLOC)) return 1;
    *slot = (int16_t)(0x18 + f->n_alloc++);
    return 0;
}
static int h_register(void *c, int16_t slot, const char *label)
{
    Fx *f = (Fx *)c;
    (void)slot;
    if (fail_hit(f, CB_REGISTER)) return 1;
    snprintf(f->registered_label, sizeof f->registered_label, "%s", label);
    return 0;
}
static int h_load(void *c, int kind, const char *name, uint32_t *surface)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_LOAD) || kind < 0 || kind > 1) return 1;
    snprintf(f->loaded_name[kind], sizeof f->loaded_name[kind], "%s", name);
    ++f->n_load;
    *surface = 100u + (uint32_t)kind;
    return 0;
}
static int h_setsurf(void *c, int16_t slot, uint32_t s)
{
    Fx *f = (Fx *)c;
    (void)slot;
    (void)s;
    return fail_hit(f, CB_SETSURF);
}
static int h_relsurf(void *c, uint32_t s)
{
    Fx *f = (Fx *)c;
    (void)s;
    if (fail_hit(f, CB_RELSURF)) return 1;
    ++f->n_relsurf;
    return 0;
}
static int h_relslot(void *c, int16_t slot)
{
    Fx *f = (Fx *)c;
    (void)slot;
    if (fail_hit(f, CB_RELSLOT)) return 1;
    ++f->n_relslot;
    return 0;
}
static int h_dirty(void *c, int16_t slot)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_DIRTY)) return 1;
    ++f->n_dirty;
    f->dirty_slot = slot;
    return 0;
}
static int h_view(void *c, int32_t view[4], int32_t full[4])
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_VIEW)) return 1;
    ++f->n_view;
    memcpy(view, f->view, sizeof f->view);
    memcpy(full, f->full, sizeof f->full);
    return 0;
}
static int h_prepare(void *c, const uint8_t *record)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_PREPARE)) return 1;
    if (f->n_prep < 8) f->prep_off[f->n_prep] = (int)(record - f->body);
    ++f->n_prep;
    return 0;
}
static int h_stop(void *c, const uint8_t *record)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_STOP)) return 1;
    if (f->n_stop < 8) f->stop_off[f->n_stop] = (int)(record - f->body);
    ++f->n_stop;
    return 0;
}
static int h_play(void *c, int16_t channel)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_PLAY)) return 1;
    if (f->n_play < 8) f->played[f->n_play] = channel;
    ++f->n_play;
    return 0;
}
static int h_busy(void *c, int16_t channel, int32_t *result)
{
    Fx *f = (Fx *)c;
    (void)channel;
    if (fail_hit(f, CB_BUSY)) return 1;
    *result = f->busy_i < f->busy_n ? f->busy_script[f->busy_i++] : f->busy_default;
    return 0;
}
static uint32_t h_tick(void *c) { return ((Fx *)c)->now; }
static int h_random(void *c, int32_t *value)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_RANDOM)) return 1;
    if (f->rand_stuck) {
        *value = 0;
        return 0;
    }
    if (f->rand_i < f->rand_n) {
        *value = f->rand_script[f->rand_i++];
    } else {
        f->lcg = f->lcg * 214013u + 2531011u;
        *value = (int32_t)((f->lcg >> 16) & 0x7fffu);
    }
    return 0;
}
static int h_ambient(void *c)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_AMBIENT)) return 1;
    ++f->n_ambient;
    return 0;
}
static int h_fontrel(void *c, int16_t font)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_FONTREL)) return 1;
    ++f->n_fontrel;
    f->fontrel_font = font;
    return 0;
}
static int h_textext(void *c, int16_t font, int16_t *height)
{
    Fx *f = (Fx *)c;
    (void)font;
    if (fail_hit(f, CB_TEXTEXT)) return 1;
    ++f->n_textext;
    *height = f->text_height;
    return 0;
}
static int h_evinvalid(void *c, int16_t index)
{
    Fx *f = (Fx *)c;
    f->evinvalid_idx = index;
    ++f->n_evinvalid;
    return f->event_invalid;
}
static int h_transition(void *c, const E4rTransition *t)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_TRANSITION)) return 1;
    f->tr = *t;
    ++f->n_tr;
    return 0;
}
static int h_storeflag(void *c, int16_t index, uint32_t value)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_STOREFLAG)) return 1;
    f->flag_idx = index;
    f->flag_val = value;
    ++f->n_flag;
    return 0;
}

static void set_block(uint8_t *b, size_t off, int scene, int w1, int w2, int w3, int32_t d1, int32_t d2, int32_t d3, int start,
                      int flag, int value)
{
    put16(b, off, scene);
    put16(b, off + 2, w1);
    put16(b, off + 4, w2);
    put16(b, off + 6, w3);
    put32(b, off + 8, d1);
    put32(b, off + 12, d2);
    put32(b, off + 16, d3);
    put16(b, off + 20, start);
    put16(b, off + 22, flag);
    b[off + 24] = (uint8_t)value;
}

/* The default body: a 3 x 4 board of 5 kinds (the fill draws kinds 0..3), cell 8 x 9, time limit 60 s, target 1000, view (10, 20). */
static void body_init(uint8_t *b)
{
    memset(b, 0, E4R_BODY_BYTES);
    put_text(b, O_NAME, "PUZ");
    put_text(b, O_SCORE_NAME, "SCORE");
    put16(b, O_ROWS, 3);
    put16(b, O_COLS, 4);
    put16(b, O_KINDS, 5);
    put_rect(b, O_SHUFFLE_SRC, 500, 10, 540, 30);
    for (int k = 0; k < E4R_MAX_KINDS; ++k) {
        char name[24];
        put_rect(b, (size_t)O_PIECE + 16u * (size_t)k, 10 * k, 50, 10 * k + 8, 59);
        snprintf(name, sizeof name, "piece%d", k);
        put_text(b, (size_t)O_PIECE_NAME + 0x21u * (size_t)k, name);
    }
    b[O_NAME_PANEL] = 1;
    put16(b, O_FONT, 3);
    put16(b, O_FONT_PARAM, 7);
    put_text(b, O_TITLE, "Title");
    b[O_SCORE_PANEL] = 1;
    put16(b, O_TIME_LIMIT, 60);
    put32(b, O_TARGET, 1000);
    put16(b, O_PER_PIECE, 10);
    put_rect(b, O_MATCHED_SRC, 300, 60, 308, 69);
    put16(b, O_BONUS3_TIME, 2);
    put16(b, O_BONUS4_SCORE, 25);
    put16(b, O_BONUS4_TIME, 4);
    put16(b, O_BONUS5_SCORE, 60);
    put16(b, O_BONUS5_TIME, 8);
    put16(b, O_XOFF, 20);
    put16(b, O_YOFF, 30);
    put16(b, O_YGAP, 2);
    put16(b, O_XGAP, 3);
    put_rect(b, O_TITLE_RECT, 10, 11, 60, 21);
    put_rect(b, O_SHUFFLE_RECT, 400, 300, 450, 330);
    put_rect(b, O_TARGET_RECT, 12, 13, 70, 23);
    put_rect(b, O_SCORE_RECT, 14, 15, 80, 25);
    put_rect(b, O_TIME_RECT, 16, 17, 90, 27);
    put_rect(b, O_NAME_RECT, 18, 19, 100, 29);
    put_rect(b, O_ICON_RECT, 20, 21, 110, 31);
    put32(b, O_HS_X0, 200);
    put32(b, O_HS_Y0, 100);
    put32(b, O_HS_X1, 300);
    put32(b, O_HS_Y1, 120);
    put16(b, O_END_DELAY, 5);
    put_text(b, O_SOUND_A, "SA");
    put16(b, O_CHAN_A, 11);
    put_text(b, O_SOUND_B, "SB");
    put16(b, O_CHAN_B, 12);
    put_text(b, O_SOUND_C, "SC");
    put16(b, O_CHAN_C, 13);
    set_block(b, O_WIN, 41, 1, 2, 3, 11, 22, 33, 1, 5, 9);
    put16(b, O_FINAL_DELAY, 3);
    put_text(b, O_SOUND_D, "SD");
    put16(b, O_CHAN_D, 14);
    set_block(b, O_EXIT, 42, 4, 5, 6, 44, 55, 66, 0, -1, 0);
    put_rect(b, O_EXIT_RECT, 600, 400, 640, 430);
}

static void fx_init(Fx *f)
{
    memset(f, 0, sizeof *f);
    e4r_object_reset(&f->o);
    body_init(f->body);
    f->now = 1000u;
    f->lcg = 12345u;
    f->busy_default = 0;
    f->row = 2;
    f->text_height = 12;
    f->view[0] = 10; f->view[1] = 20; f->view[2] = 629; f->view[3] = 384;
    f->full[0] = 5; f->full[1] = 6; f->full[2] = 7; f->full[3] = 8;
    f->host.context = f;
    f->host.alloc_slot = h_alloc;
    f->host.register_slot = h_register;
    f->host.load_surface = h_load;
    f->host.set_slot_surface = h_setsurf;
    f->host.release_surface = h_relsurf;
    f->host.release_slot = h_relslot;
    f->host.mark_dirty = h_dirty;
    f->host.view_rects = h_view;
    f->host.sound_prepare = h_prepare;
    f->host.sound_stop = h_stop;
    f->host.sound_play = h_play;
    f->host.sound_busy = h_busy;
    f->host.tick = h_tick;
    f->host.random = h_random;
    f->host.stop_ambient = h_ambient;
    f->host.font_release = h_fontrel;
    f->host.text_extent = h_textext;
    f->host.event_flag_invalid = h_evinvalid;
    f->host.transition = h_transition;
    f->host.store_event_flag = h_storeflag;
    f->host.observe = observe;
}

/* Resets the per-call observation state (not the object, body or world). */
static void fx_clear(Fx *f)
{
    f->log[0] = '\0';
    f->calls = 0;
    f->fail_call = 0;
    f->failed_mask = 0;
    f->n_alloc = f->n_dirty = f->n_relsurf = f->n_relslot = f->n_view = f->n_load = f->n_ambient = f->n_fontrel = f->n_textext = 0;
    f->n_evinvalid = f->n_tr = f->n_flag = f->n_play = f->n_stop = f->n_prep = 0;
    f->rand_n = f->rand_i = 0;
    f->busy_n = f->busy_i = 0;
}

static int step(Fx *f, uint32_t phase)
{
    f->failure = NULL;
    f->rc = e4r_step(&f->o, f->body, E4R_BODY_BYTES, f->row, phase, &f->world, &f->host, &f->res, &f->failure);
    CHECK((f->rc == E4R_OK) == (f->failure == NULL)); /* a failure text exactly when the step failed */
    return f->rc;
}
static void script(Fx *f, const int32_t *v, int n)
{
    memcpy(f->rand_script, v, (size_t)n * sizeof v[0]);
    f->rand_n = n;
    f->rand_i = 0;
}
static int32_t od32(const Fx *f, size_t off) { return get32(f->o.b, off); }
static int16_t od16(const Fx *f, size_t off) { return get16(f->o.b, off); }
static void set32(Fx *f, size_t off, int32_t v) { put32(f->o.b, off, v); }
static int kind_at(const Fx *f, int r, int c) { return get16(f->o.b, CELL(r, c) + 2u); }
static void set_kind(Fx *f, int r, int c, int k) { put16(f->o.b, CELL(r, c) + 2u, k); }
static int state_of(const Fx *f) { return od32(f, E4R_O_STATE); }
static const char *text_of(const Fx *f, size_t off) { return (const char *)f->o.b + off; }

/* The 3 x 4 board without any run (kinds 0..4). */
static const int BOARD_A[3][4] = {{0, 1, 2, 3}, {1, 2, 3, 4}, {2, 3, 4, 0}};
static void set_board_a(Fx *f)
{
    for (int r = 0; r < 3; ++r)
        for (int c = 0; c < 4; ++c) set_kind(f, r, c, BOARD_A[r][c]);
}

/* Phase 0 on the fallback rand, then the fixed board A and the given state. */
static int start(Fx *f)
{
    const int rc = step(f, 0u);
    set_board_a(f);
    fx_clear(f);
    return rc;
}

/* Phase 0 for a board of the given size, then a background without any run (kinds 1..5 of a 6-kind body), board row-major. */
static int start_sized(Fx *f, int rows, int cols)
{
    int rc;
    put16(f->body, O_ROWS, rows);
    put16(f->body, O_COLS, cols);
    put16(f->body, O_KINDS, 6);
    rc = step(f, 0u);
    for (int r = 0; r < rows; ++r)
        for (int c = 0; c < cols; ++c) set_kind(f, r, c, (r + 2 * c) % 5 + 1);
    fx_clear(f);
    return rc;
}

static int visit(Fx *f) { return step(f, 1u); }

/* ---- validation (native only: the original trusts the loader) -------------------------------------------------------------- */

static void expect_invalid(Fx *f, const char *why)
{
    const char *failure = NULL;
    CHECK(e4r_validate_body(f->body, E4R_BODY_BYTES, &failure) == E4R_ERR_BODY);
    CHECK(failure != NULL && strcmp(failure, why) == 0);
    /* The step refuses before the first effect. */
    fx_clear(f);
    e4r_object_reset(&f->o);
    CHECK(step(f, 0u) == E4R_ERR_BODY && f->failure != NULL && strcmp(f->failure, why) == 0);
    CHECK(f->log[0] == '\0' && f->calls == 0 && f->res.initialized == 0u && f->res.phase_after == 0u);
    CHECK(e4r_rd32(&f->o, E4R_O_ACTIVE) == 0);
}

static void t_validate(void)
{
    Fx f;
    const char *failure = "x";
    fx_init(&f);
    CHECK(e4r_validate_body(f.body, E4R_BODY_BYTES, &failure) == E4R_OK && failure == NULL);
    CHECK(e4r_validate_body(f.body, E4R_BODY_BYTES, NULL) == E4R_OK);
    CHECK(e4r_validate_body(NULL, E4R_BODY_BYTES, &failure) == E4R_ERR_BODY && strcmp(failure, "0xe4-body-length") == 0);
    CHECK(e4r_validate_body(f.body, E4R_BODY_BYTES - 1u, &failure) == E4R_ERR_BODY && strcmp(failure, "0xe4-body-length") == 0);
    CHECK(e4r_validate_body(f.body, 0u, NULL) == E4R_ERR_BODY);
    {
        uint8_t big[E4R_BODY_BYTES + 1u];
        memset(big, 0, sizeof big);
        CHECK(e4r_validate_body(big, sizeof big, &failure) == E4R_ERR_BODY && strcmp(failure, "0xe4-body-length") == 0);
    }
    /* Accepted limits. */
    put16(f.body, O_ROWS, 10); put16(f.body, O_COLS, 10); put16(f.body, O_KINDS, 30); put16(f.body, O_FONT, 17);
    CHECK(e4r_validate_body(f.body, E4R_BODY_BYTES, NULL) == E4R_OK);
    put16(f.body, O_ROWS, 1); put16(f.body, O_COLS, 1); put16(f.body, O_KINDS, 4); put16(f.body, O_FONT, 0);
    CHECK(e4r_validate_body(f.body, E4R_BODY_BYTES, NULL) == E4R_OK);
    /* Every refusal. */
    fx_init(&f); put16(f.body, O_ROWS, 0); expect_invalid(&f, "0xe4-rows");
    fx_init(&f); put16(f.body, O_ROWS, 11); expect_invalid(&f, "0xe4-rows");
    fx_init(&f); put16(f.body, O_ROWS, -1); expect_invalid(&f, "0xe4-rows");
    fx_init(&f); put16(f.body, O_COLS, 0); expect_invalid(&f, "0xe4-columns");
    fx_init(&f); put16(f.body, O_COLS, 11); expect_invalid(&f, "0xe4-columns");
    fx_init(&f); put16(f.body, O_KINDS, 3); expect_invalid(&f, "0xe4-kinds");
    fx_init(&f); put16(f.body, O_KINDS, 31); expect_invalid(&f, "0xe4-kinds");
    fx_init(&f); put16(f.body, O_FONT, -1); expect_invalid(&f, "0xe4-font");
    fx_init(&f); put16(f.body, O_FONT, 18); expect_invalid(&f, "0xe4-font");
    fx_init(&f); memset(f.body + O_NAME, 'x', 0x21); expect_invalid(&f, "0xe4-name-unterminated");
    fx_init(&f); memset(f.body + O_SCORE_NAME, 'x', 0x21); expect_invalid(&f, "0xe4-score-name-unterminated");
    fx_init(&f); memset(f.body + O_TITLE, 'x', 0x21); expect_invalid(&f, "0xe4-title-unterminated");
    fx_init(&f); memset(f.body + O_SOUND_A, 'x', 0x21); expect_invalid(&f, "0xe4-sound-a-unterminated");
    fx_init(&f); memset(f.body + O_SOUND_B, 'x', 0x21); expect_invalid(&f, "0xe4-sound-b-unterminated");
    fx_init(&f); memset(f.body + O_SOUND_C, 'x', 0x21); expect_invalid(&f, "0xe4-sound-c-unterminated");
    fx_init(&f); memset(f.body + O_SOUND_D, 'x', 0x21); expect_invalid(&f, "0xe4-sound-d-unterminated");
    /* A name that fills 0x20 bytes plus its NUL is fine; the last used piece name is checked, the first unused one is not. */
    fx_init(&f); memset(f.body + O_NAME, 'x', 0x20); f.body[O_NAME + 0x20] = 0;
    CHECK(e4r_validate_body(f.body, E4R_BODY_BYTES, NULL) == E4R_OK);
    fx_init(&f); memset(f.body + O_PIECE_NAME + 4 * 0x21, 'x', 0x21); expect_invalid(&f, "0xe4-piece-name-unterminated");
    fx_init(&f); memset(f.body + O_PIECE_NAME + 5 * 0x21, 'x', 0x21);
    CHECK(e4r_validate_body(f.body, E4R_BODY_BYTES, NULL) == E4R_OK);
    fx_init(&f); memset(f.body + O_PIECE_NAME, 'x', 0x21); expect_invalid(&f, "0xe4-piece-name-unterminated");
}

/* 0x4757da reset values, 0x47591f scene reset. */
static void t_reset(void)
{
    E4rObject o;
    E4rWorld w;
    memset(&o, 0x55, sizeof o);
    e4r_object_reset(&o);
    CHECK(e4r_rd16(&o, E4R_O_SLOT) == -1 && e4r_rd16(&o, E4R_O_ROW) == -1);
    for (size_t i = 0; i < sizeof o.b; ++i)
        if (i != E4R_O_SLOT && i != E4R_O_SLOT + 1 && i != E4R_O_ROW && i != E4R_O_ROW + 1) CHECK(o.b[i] == 0);
    CHECK(sizeof(E4rObject) == 0x8dau);
    memset(&w, 0x7f, sizeof w);
    e4r_scene_reset(&w);
    CHECK(w.high_score_marker_5a0545 == 0);
    for (int i = 0; i < E4R_HIGH_SCORES; ++i) CHECK(w.high_score[i] == 0);
    CHECK(w.start_flag_5bb1ca == 0x7f7f7f7f); /* the start flag is not part of the table */
}

/* ---- phase 0 (0x476a25 case 0, 0x475a1e, 0x475bef) --------------------------------------------------------------------------- */

static void t_phase0(void)
{
    Fx f;
    static const int32_t rs[] = {6, 2, 7, 3, 1, 5, 4, 2, 10, 3, 0, 1, 8, 2, 0, 1, 3, 0, 0, 1, 2, 3, 1, 3, 2};
    static const int expect[3][4] = {{2, 3, 1, 0}, {3, 0, 2, 1}, {0, 1, 3, 2}};
    char want[2048] = "start:1:0,amb:0:0";
    char tmp[128];
    fx_init(&f);
    script(&f, rs, (int)(sizeof rs / sizeof rs[0]));
    CHECK(step(&f, 0u) == E4R_OK && f.failure == NULL);
    CHECK(f.res.initialized == 1u && f.res.completed == 0u && f.res.phase_after == 1u);
    CHECK(f.rand_i == (int)(sizeof rs / sizeof rs[0])); /* retries consumed exactly the scripted values */
    for (int r = 0; r < 3; ++r)
        for (int c = 0; c < 4; ++c) {
            const size_t at = CELL(r, c);
            CHECK(kind_at(&f, r, c) == expect[r][c]);
            CHECK(f.o.b[at] == 1 && f.o.b[at + 1] == 0);
            /* 0x475bef: x = c * 8 + view_x + 20 + 3 * c, y = r * 9 + view_y + 30 + 2 * r, width 8, height 9 */
            CHECK(od32(&f, at + 4) == 30 + 11 * c && od32(&f, at + 12) == 30 + 11 * c + 8);
            CHECK(od32(&f, at + 8) == 50 + 11 * r && od32(&f, at + 16) == 50 + 11 * r + 9);
        }
    /* No-equal-neighbour rule, kinds 0..kinds-2. */
    for (int r = 0; r < 3; ++r)
        for (int c = 0; c < 4; ++c) {
            CHECK(kind_at(&f, r, c) >= 0 && kind_at(&f, r, c) <= 3);
            if (r > 0) CHECK(kind_at(&f, r, c) != kind_at(&f, r - 1, c));
            if (c > 0) CHECK(kind_at(&f, r, c) != kind_at(&f, r, c - 1));
        }
    /* Cells outside the board stay empty. */
    CHECK(f.o.b[CELL(3, 0)] == 0 && f.o.b[CELL(0, 4)] == 0);
    for (size_t i = 0; i < sizeof rs / sizeof rs[0]; ++i) {
        snprintf(tmp, sizeof tmp, ",rand:%d:0", rs[i]);
        strcat(want, tmp);
    }
    snprintf(tmp, sizeof tmp, ",slot:24:0,slotreg:24:0,load:0:100,slotsurf:24:100,load:1:101,prep:%d:0", O_SOUND_A);
    strcat(want, tmp);
    snprintf(tmp, sizeof tmp, ",prep:%d:0,prep:%d:0,tick:1000:0,phase:1:0", O_SOUND_B, O_SOUND_C);
    strcat(want, tmp);
    CHECK_LOG(&f, want);
    CHECK(strcmp(f.registered_label, "MATCH PUZZLE OVERLAYS") == 0);
    CHECK(strcmp(f.loaded_name[0], "PUZ") == 0 && strcmp(f.loaded_name[1], "SCORE") == 0);
    CHECK(f.n_prep == 3 && f.prep_off[0] == O_SOUND_A && f.prep_off[1] == O_SOUND_B && f.prep_off[2] == O_SOUND_C);
    CHECK(f.world.start_flag_5bb1ca == 1 && f.n_ambient == 1 && f.n_view == 1);
    CHECK(od16(&f, E4R_O_ROW) == 2 && od16(&f, E4R_O_SLOT) == 24 && od32(&f, E4R_O_ACTIVE) == 1);
    CHECK(od32(&f, E4R_O_SURFACE) == 100 && od32(&f, E4R_O_SCORE_SURFACE) == 101);
    CHECK(od32(&f, E4R_O_NO_SELECTION) == 1 && od32(&f, E4R_O_SCORE) == 0 && od32(&f, E4R_O_STATE) == 0);
    CHECK(od32(&f, E4R_O_TIME_END) == 61000 && od32(&f, E4R_O_WON) == 0 && od32(&f, E4R_O_EXIT) == 0);
    CHECK(f.o.b[E4R_O_CHECK_FIRST] == 0 && f.o.b[E4R_O_CHECK_SECOND] == 0 && f.o.b[E4R_O_SHOW_NAME] == 0);
    CHECK(f.o.b[E4R_O_NAME_DIRTY] == 1 && f.o.b[E4R_O_SCORE_DIRTY] == 0 && f.o.b[E4R_O_ERASE_ALL] == 0);
    CHECK(f.o.b[E4R_O_MATCH_COL] == 0 && f.o.b[E4R_O_MATCH_ROW] == 0 && f.o.b[E4R_O_SHUFFLE_DOWN] == 0 &&
          f.o.b[E4R_O_SHUFFLE_DIRTY] == 0);
    CHECK(strcmp(text_of(&f, E4R_O_SCORE_TEXT), "0") == 0 && strcmp(text_of(&f, E4R_O_TIME_TEXT), "") == 0 &&
          strcmp(text_of(&f, E4R_O_NAME_TEXT), "") == 0 && strcmp(text_of(&f, E4R_O_TARGET_TEXT), "1000") == 0);
}

static void t_phase0_variants(void)
{
    Fx f;
    /* The score surface is loaded only for a non-empty name. */
    fx_init(&f);
    f.body[O_SCORE_NAME] = 0;
    CHECK(step(&f, 0u) == E4R_OK && f.n_load == 1 && od32(&f, E4R_O_SCORE_SURFACE) == 0 && strstr(f.log, "load:1") == NULL);
    /* "NO SOUND" (exactly, with its NUL) suppresses the prepare of that record only. */
    for (int which = 0; which < 3; ++which) {
        const int offs[3] = {O_SOUND_A, O_SOUND_B, O_SOUND_C};
        fx_init(&f);
        put_text(f.body, (size_t)offs[which], "NO SOUND");
        CHECK(step(&f, 0u) == E4R_OK && f.n_prep == 2);
        for (int i = 0; i < f.n_prep; ++i) CHECK(f.prep_off[i] != offs[which]);
    }
    fx_init(&f);
    put_text(f.body, O_SOUND_A, "NO SOUND2");
    put_text(f.body, O_SOUND_B, "NO SOUN");
    put_text(f.body, O_SOUND_C, "no sound");
    CHECK(step(&f, 0u) == E4R_OK && f.n_prep == 3);
    /* The sound record D is not prepared by phase 0. */
    fx_init(&f);
    put_text(f.body, O_SOUND_A, "NO SOUND");
    put_text(f.body, O_SOUND_B, "NO SOUND");
    put_text(f.body, O_SOUND_C, "NO SOUND");
    CHECK(step(&f, 0u) == E4R_OK && f.n_prep == 0);
    /* Target text is printed unsigned; time end wraps; limit 0 and negative. */
    fx_init(&f);
    put32(f.body, O_TARGET, -1);
    put16(f.body, O_TIME_LIMIT, 0);
    f.now = 77u;
    CHECK(step(&f, 0u) == E4R_OK && strcmp(text_of(&f, E4R_O_TARGET_TEXT), "4294967295") == 0 && od32(&f, E4R_O_TIME_END) == 77);
    fx_init(&f);
    put16(f.body, O_TIME_LIMIT, -1);
    f.now = 5000u;
    CHECK(step(&f, 0u) == E4R_OK && od32(&f, E4R_O_TIME_END) == 4000);
    fx_init(&f);
    f.now = 0xffffff00u;
    CHECK(step(&f, 0u) == E4R_OK && (uint32_t)od32(&f, E4R_O_TIME_END) == 0xffffff00u + 60000u);
    /* A second phase 0 on the same object loads no surface again (the handles are held) but allocates a new slot. */
    fx_init(&f);
    CHECK(step(&f, 0u) == E4R_OK && f.n_load == 2);
    fx_clear(&f);
    f.n_alloc = 1;
    CHECK(step(&f, 0u) == E4R_OK && f.n_load == 0 && strstr(f.log, "load:") == NULL && strstr(f.log, "slot:25:0") != NULL);
    CHECK(od16(&f, E4R_O_SLOT) == 25 && od32(&f, E4R_O_SURFACE) == 100);
    /* The score surface is loaded later when the first run had none. */
    fx_init(&f);
    f.body[O_SCORE_NAME] = 0;
    CHECK(step(&f, 0u) == E4R_OK && od32(&f, E4R_O_SCORE_SURFACE) == 0);
    fx_clear(&f);
    put_text(f.body, O_SCORE_NAME, "SCORE");
    CHECK(step(&f, 0u) == E4R_OK && f.n_load == 1 && strstr(f.log, "load:1:101") != NULL && strstr(f.log, "load:0") == NULL);
    /* The fill divides by kinds - 1: with 4 kinds a draw of 32767 gives kind 32767 % 3 = 1. */
    fx_init(&f);
    put16(f.body, O_KINDS, 4);
    put16(f.body, O_ROWS, 1);
    put16(f.body, O_COLS, 1);
    {
        static const int32_t one[] = {32767};
        script(&f, one, 1);
    }
    CHECK(step(&f, 0u) == E4R_OK && kind_at(&f, 0, 0) == 1);
    /* Other phases do nothing. */
    fx_clear(&f);
    CHECK(step(&f, 3u) == E4R_OK && f.log[0] == '\0' && f.res.phase_after == 3u && f.res.initialized == 0u);
}

/* Every host callback of phase 0 failing in turn stops the visit with E4R_ERR_HOST (the original has no recovery). */
static void t_phase0_host_failures(void)
{
    Fx f;
    int total;
    unsigned seen = 0u;
    fx_init(&f);
    CHECK(step(&f, 0u) == E4R_OK);
    total = f.calls;
    CHECK(total > 20);
    for (int n = 1; n <= total; ++n) {
        fx_init(&f);
        f.fail_call = n;
        CHECK(step(&f, 0u) == E4R_ERR_HOST && f.failure != NULL && strcmp(f.failure, "e4-host-failure") == 0);
        CHECK(f.res.initialized == 0u && f.res.phase_after == 0u && f.failed_mask != 0u);
        seen |= f.failed_mask;
    }
    for (int id = CB_ALLOC; id <= CB_PREPARE; ++id)
        if (id != CB_RELSURF && id != CB_RELSLOT && id != CB_DIRTY && id != CB_STOP) CHECK((seen >> id) & 1u);
    CHECK((seen >> CB_RANDOM) & 1u && (seen >> CB_AMBIENT) & 1u);
    fx_init(&f);
    f.fail_call = total + 1;
    CHECK(step(&f, 0u) == E4R_OK);
}

/* An unsatisfiable fill (the host always returns the same kind, so the second cell can never differ) is cut off with a host
 * failure instead of spinning forever (0x475a1e would loop; native-only guard). */
static void t_fill_retry_limit(void)
{
    Fx f;
    fx_init(&f);
    f.host.observe = NULL; /* a million log lines would be quadratic */
    f.rand_stuck = 1;
    put16(f.body, O_ROWS, 1);
    put16(f.body, O_COLS, 2);
    put16(f.body, O_KINDS, 4);
    CHECK(step(&f, 0u) == E4R_ERR_HOST && f.failure != NULL && strcmp(f.failure, "e4-host-failure") == 0);
    CHECK(f.calls == 1000003); /* the start flag, the ambient stop and exactly FILL_RETRY_LIMIT + 1 host random calls */
}

/* ---- argument checks and the native refusals of phases 1 and 2 -------------------------------------------------------------- */

static void t_step_args(void)
{
    Fx f;
    const char *why = NULL;
    fx_init(&f);
    CHECK(e4r_step(NULL, f.body, E4R_BODY_BYTES, 1, 0u, &f.world, &f.host, &f.res, &why) == E4R_ERR_ARGUMENT);
    CHECK(e4r_step(&f.o, NULL, E4R_BODY_BYTES, 1, 0u, &f.world, &f.host, &f.res, &why) == E4R_ERR_ARGUMENT);
    CHECK(e4r_step(&f.o, f.body, E4R_BODY_BYTES, 1, 0u, NULL, &f.host, &f.res, &why) == E4R_ERR_ARGUMENT);
    CHECK(e4r_step(&f.o, f.body, E4R_BODY_BYTES, 1, 0u, &f.world, NULL, &f.res, &why) == E4R_ERR_ARGUMENT);
    CHECK(e4r_step(&f.o, f.body, E4R_BODY_BYTES, 1, 0u, &f.world, &f.host, NULL, &why) == E4R_ERR_ARGUMENT);
    CHECK(why == NULL && f.log[0] == '\0' && e4r_rd32(&f.o, E4R_O_ACTIVE) == 0);
    CHECK(e4r_step(&f.o, f.body, E4R_BODY_BYTES, 1, 0u, &f.world, &f.host, &f.res, NULL) == E4R_OK); /* failure is optional */
    CHECK(e4r_step(&f.o, f.body, E4R_BODY_BYTES - 1u, 1, 0u, &f.world, &f.host, &f.res, &why) == E4R_ERR_BODY);
    CHECK(e4r_pointer(NULL, f.body, E4R_BODY_BYTES, 0, 0, &(E4rPointerResult){0}) == E4R_ERR_ARGUMENT);
    {
        E4rPointerResult p;
        E4rClickResult c;
        E4rRenderResult *r = (E4rRenderResult *)calloc(1u, sizeof *r);
        CHECK(e4r_pointer(&f.o, NULL, E4R_BODY_BYTES, 0, 0, &p) == E4R_ERR_ARGUMENT);
        CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 0, 0, NULL) == E4R_ERR_ARGUMENT);
        CHECK(e4r_pointer(&f.o, f.body, 10u, 0, 0, &p) == E4R_ERR_BODY);
        CHECK(e4r_click(NULL, f.body, E4R_BODY_BYTES, 1u, 0x27d5, &f.host, &c) == E4R_ERR_ARGUMENT);
        CHECK(e4r_click(&f.o, NULL, E4R_BODY_BYTES, 1u, 0x27d5, &f.host, &c) == E4R_ERR_ARGUMENT);
        CHECK(e4r_click(&f.o, f.body, E4R_BODY_BYTES, 1u, 0x27d5, NULL, &c) == E4R_ERR_ARGUMENT);
        CHECK(e4r_click(&f.o, f.body, E4R_BODY_BYTES, 1u, 0x27d5, &f.host, NULL) == E4R_ERR_ARGUMENT);
        CHECK(e4r_click(&f.o, f.body, 10u, 1u, 0x27d5, &f.host, &c) == E4R_ERR_BODY);
        CHECK(e4r_invalidate(NULL, &f.host) == E4R_ERR_ARGUMENT && e4r_invalidate(&f.o, NULL) == E4R_ERR_ARGUMENT);
        CHECK(e4r_cleanup(NULL, &f.host) == E4R_ERR_ARGUMENT && e4r_cleanup(&f.o, NULL) == E4R_ERR_ARGUMENT);
        CHECK(r != NULL);
        if (r != NULL) {
            CHECK(e4r_render(NULL, f.body, E4R_BODY_BYTES, &f.world, &f.host, r) == E4R_ERR_ARGUMENT);
            CHECK(e4r_render(&f.o, NULL, E4R_BODY_BYTES, &f.world, &f.host, r) == E4R_ERR_ARGUMENT);
            CHECK(e4r_render(&f.o, f.body, E4R_BODY_BYTES, NULL, &f.host, r) == E4R_ERR_ARGUMENT);
            CHECK(e4r_render(&f.o, f.body, E4R_BODY_BYTES, &f.world, NULL, r) == E4R_ERR_ARGUMENT);
            CHECK(e4r_render(&f.o, f.body, E4R_BODY_BYTES, &f.world, &f.host, NULL) == E4R_ERR_ARGUMENT);
            r->valid = 1;
            CHECK(e4r_render(&f.o, f.body, 10u, &f.world, &f.host, r) == E4R_ERR_BODY && r->valid == 0u && r->count == 0u);
        }
        free(r);
    }
}

static void t_phase12_gating(void)
{
    Fx f;
    /* Phase 1 and 2 need a phase 0 of the same row (native refusal, before any effect). */
    fx_init(&f);
    for (uint32_t ph = 1u; ph <= 2u; ++ph) {
        fx_clear(&f);
        CHECK(step(&f, ph) == E4R_ERR_UNSUPPORTED && strcmp(f.failure, "e4-phase-without-init") == 0 && f.log[0] == '\0');
        CHECK(f.res.phase_after == ph && f.res.completed == 0u);
    }
    CHECK(start(&f) == E4R_OK);
    f.row = 3;
    CHECK(visit(&f) == E4R_ERR_UNSUPPORTED && strcmp(f.failure, "e4-phase-without-init") == 0);
    CHECK(step(&f, 2u) == E4R_ERR_UNSUPPORTED && f.log[0] == '\0' && f.n_stop == 0);
    f.row = 2;
    CHECK(visit(&f) == E4R_OK);
    /* An inactive object (after the cleanup) refuses as well. */
    CHECK(e4r_cleanup(&f.o, &f.host) == E4R_OK);
    CHECK(visit(&f) == E4R_ERR_UNSUPPORTED);
    f.row = -1;
    CHECK(visit(&f) == E4R_ERR_UNSUPPORTED); /* row -1 equals the reset row, but the object is inactive */
    /* A piece kind outside the body in any cell of the board refuses phase 1 (not phase 2). */
    for (int bad = 0; bad < 2; ++bad) {
        fx_init(&f);
        CHECK(start(&f) == E4R_OK);
        set_kind(&f, 2, 3, bad ? -1 : 5);
        CHECK(visit(&f) == E4R_ERR_UNSUPPORTED && strcmp(f.failure, "e4-piece-kind-outside-body") == 0 && f.log[0] == '\0');
        set_kind(&f, 2, 3, 4);
        CHECK(visit(&f) == E4R_OK);
        set_kind(&f, 2, 3, bad ? -1 : 5);
        CHECK(step(&f, 2u) == E4R_OK); /* phase 2 reads no cell */
    }
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    set_kind(&f, 3, 0, 9); /* outside the 3 x 4 board: not examined */
    set_kind(&f, 0, 4, 9);
    CHECK(visit(&f) == E4R_OK);
    /* A pending check whose cell lies outside the board refuses (state 0 only). */
    {
        const size_t sel_row = E4R_O_SEL_ROW, sel_col = E4R_O_SEL_COL, swap_row = E4R_O_SWAP_ROW, swap_col = E4R_O_SWAP_COL;
        struct { uint8_t first, second; size_t off; int32_t v; int refused; } cases[] = {
            {1, 0, sel_row, 3, 1}, {1, 0, sel_row, -1, 1}, {1, 0, sel_col, 4, 1}, {1, 0, sel_col, -1, 1},
            {1, 0, sel_row, 2, 0}, {1, 0, sel_col, 3, 0},
            {0, 1, swap_row, 3, 1}, {0, 1, swap_row, -1, 1}, {0, 1, swap_col, 4, 1}, {0, 1, swap_col, -1, 1},
            {0, 1, swap_row, 2, 0}, {0, 1, swap_col, 3, 0},
            {1, 1, swap_row, 9, 0}, /* the first check wins; the swapped cell is not looked at */
            {0, 1, sel_row, 9, 0}, {1, 0, swap_row, 9, 0}, {0, 0, sel_row, 9, 0}};
        for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
            fx_init(&f);
            CHECK(start(&f) == E4R_OK);
            f.o.b[E4R_O_CHECK_FIRST] = cases[i].first;
            f.o.b[E4R_O_CHECK_SECOND] = cases[i].second;
            set32(&f, cases[i].off, cases[i].v);
            CHECK(visit(&f) == (cases[i].refused ? E4R_ERR_UNSUPPORTED : E4R_OK));
            if (cases[i].refused) {
                CHECK(strcmp(f.failure, "e4-selection-outside-board") == 0 && f.log[0] == '\0');
                CHECK(f.o.b[E4R_O_CHECK_FIRST] == cases[i].first && f.o.b[E4R_O_CHECK_SECOND] == cases[i].second);
            }
        }
        fx_init(&f);
        CHECK(start(&f) == E4R_OK);
        f.o.b[E4R_O_CHECK_FIRST] = 1;
        set32(&f, E4R_O_SEL_ROW, 7);
        set32(&f, E4R_O_STATE, E4R_STATE_SHUFFLE);
        set32(&f, E4R_O_SHUFFLE_END, 99999);
        CHECK(visit(&f) == E4R_OK); /* only state 0 reads the selection */
    }
    /* Phase 2: an event flag index outside the host window refuses before any effect, for the block that would be applied. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    set32(&f, E4R_O_WON, 1);
    f.event_invalid = 1;
    CHECK(step(&f, 2u) == E4R_ERR_BOUNDS && strcmp(f.failure, "e4-event-flag-outside-window") == 0 && f.log[0] == '\0');
    CHECK(f.evinvalid_idx == 5); /* the win block's flag */
    CHECK(f.n_evinvalid == 1 && od32(&f, E4R_O_ACTIVE) == 1 && f.world.start_flag_5bb1ca == 1 && f.n_stop == 0);
    set32(&f, E4R_O_EXIT, 1); /* exit block: flag -1, nothing to query */
    fx_clear(&f);
    CHECK(step(&f, 2u) == E4R_OK && f.n_evinvalid == 0);
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    f.event_invalid = 1; /* neither exit nor won: no block, no query */
    CHECK(step(&f, 2u) == E4R_OK && f.n_evinvalid == 0 && f.res.completed == 1u);
}

/* ---- the state machine (0x476a25 case 1, jump table 0x4778b3) ----------------------------------------------------------------- */

static void play_state(Fx *f, int32_t state) { set32(f, E4R_O_STATE, state); }

/* State 0 with no check pending: the time text, the time-out and the win test (unsigned countdown). */
static void t_state_idle(void)
{
    Fx f;
    struct { uint32_t now; const char *text; } texts[] = {
        {1000u, " 1m  0s"},          /* 61000 - 1000 = 60000 */
        {61000u - 3599999u, "59m 59s"}, {61000u - 3600000u, " 0m  0s"}, {61000u - 125000u, " 2m  5s"},
        {61000u - 500u, " 0m  0s"},   /* left == 500: not over yet */
        {61000u + 1000u, " 2m 46s"}}; /* left wraps to 4294966296: the text uses the unsigned value and the countdown goes on */
    for (size_t i = 0; i < sizeof texts / sizeof texts[0]; ++i) {
        fx_init(&f);
        CHECK(start(&f) == E4R_OK);
        f.now = texts[i].now;
        CHECK(visit(&f) == E4R_OK);
        CHECK(strcmp(text_of(&f, E4R_O_TIME_TEXT), texts[i].text) == 0);
        CHECK(state_of(&f) == 0 && od32(&f, E4R_O_WON) == 0);
        {
            char want[32];
            snprintf(want, sizeof want, "tick:%d:0", (int32_t)texts[i].now);
            CHECK_LOG(&f, want);
        }
        CHECK(f.res.phase_after == 1u);
    }
    /* Time over: left < 500 (including 0 and the wrap just below). */
    for (int i = 0; i < 3; ++i) {
        fx_init(&f);
        CHECK(start(&f) == E4R_OK);
        f.now = 61000u - (i == 0 ? 499u : (i == 1 ? 1u : 0u));
        CHECK(visit(&f) == E4R_OK);
        CHECK(state_of(&f) == E4R_STATE_END && strcmp(text_of(&f, E4R_O_TIME_TEXT), "TIME!") == 0 && od32(&f, E4R_O_WON) == 0);
    }
    /* Limit 0: no time text, no time-out; negative limit: text, no time-out. */
    fx_init(&f);
    put16(f.body, O_TIME_LIMIT, 0);
    CHECK(start(&f) == E4R_OK);
    f.now = 9999999u;
    CHECK(visit(&f) == E4R_OK && state_of(&f) == 0 && text_of(&f, E4R_O_TIME_TEXT)[0] == '\0');
    fx_init(&f);
    put16(f.body, O_TIME_LIMIT, -1);
    CHECK(start(&f) == E4R_OK);
    f.now = 9999999u;
    CHECK(visit(&f) == E4R_OK && state_of(&f) == 0 && text_of(&f, E4R_O_TIME_TEXT)[0] != '\0');
    /* The win test: signed score >= signed target; the win text and flag; the win beats a simultaneous time-out. */
    struct { int32_t score, target; int win; } wins[] = {{1000, 1000, 1}, {999, 1000, 0}, {1001, 1000, 1}, {0, -5, 1}, {-6, -5, 0},
                                                         {-5, -5, 1}, {0, 0, 1}, {0x7fffffff, 1000, 1}, {-1, 0, 0}};
    for (size_t i = 0; i < sizeof wins / sizeof wins[0]; ++i) {
        fx_init(&f);
        put32(f.body, O_TARGET, wins[i].target);
        CHECK(start(&f) == E4R_OK);
        set32(&f, E4R_O_SCORE, wins[i].score);
        CHECK(visit(&f) == E4R_OK);
        CHECK(state_of(&f) == (wins[i].win ? E4R_STATE_END : 0));
        CHECK(od32(&f, E4R_O_WON) == wins[i].win);
        CHECK(!wins[i].win || strcmp(text_of(&f, E4R_O_TIME_TEXT), "WIN!!!") == 0);
        CHECK(wins[i].win || strcmp(text_of(&f, E4R_O_TIME_TEXT), " 1m  0s") == 0);
    }
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    set32(&f, E4R_O_SCORE, 5000);
    f.now = 61000u;
    CHECK(visit(&f) == E4R_OK && strcmp(text_of(&f, E4R_O_TIME_TEXT), "WIN!!!") == 0 && od32(&f, E4R_O_WON) == 1);
    /* A state above 6 (unsigned) does nothing, not even a tick. */
    for (uint32_t st = 7u; st <= 8u; ++st) {
        fx_init(&f);
        CHECK(start(&f) == E4R_OK);
        play_state(&f, (int32_t)st);
        CHECK(visit(&f) == E4R_OK && f.log[0] == '\0' && state_of(&f) == (int32_t)st);
    }
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    play_state(&f, -1);
    CHECK(visit(&f) == E4R_OK && f.log[0] == '\0' && state_of(&f) == -1);
}

/* The pending checks of state 0 (the second piece is only looked at on a later visit and only if the first did not refill). */
static void t_state_check_order(void)
{
    Fx f;
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    f.o.b[E4R_O_CHECK_FIRST] = 1;
    f.o.b[E4R_O_CHECK_SECOND] = 1;
    set32(&f, E4R_O_SEL_ROW, 0); set32(&f, E4R_O_SEL_COL, 0);
    set32(&f, E4R_O_SWAP_ROW, 1); set32(&f, E4R_O_SWAP_COL, 1);
    CHECK(visit(&f) == E4R_OK && f.o.b[E4R_O_CHECK_FIRST] == 0 && f.o.b[E4R_O_CHECK_SECOND] == 1 && f.log[0] == '\0');
    CHECK(visit(&f) == E4R_OK && f.o.b[E4R_O_CHECK_SECOND] == 0 && f.log[0] == '\0' && state_of(&f) == 0);
    CHECK(visit(&f) == E4R_OK && strstr(f.log, "tick:") != NULL); /* the idle path only now */
    /* A first check that scores starts the refill; the second check waits until the state is PLAY again. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    set_kind(&f, 0, 0, 4); set_kind(&f, 1, 0, 4); set_kind(&f, 2, 0, 4);
    f.o.b[E4R_O_CHECK_FIRST] = 1;
    f.o.b[E4R_O_CHECK_SECOND] = 1;
    set32(&f, E4R_O_SEL_ROW, 1); set32(&f, E4R_O_SEL_COL, 0);
    set32(&f, E4R_O_SWAP_ROW, 0); set32(&f, E4R_O_SWAP_COL, 3);
    CHECK(visit(&f) == E4R_OK && state_of(&f) == E4R_STATE_REFILL && f.o.b[E4R_O_CHECK_FIRST] == 0 && f.o.b[E4R_O_CHECK_SECOND] == 1);
    CHECK(visit(&f) == E4R_OK && f.o.b[E4R_O_CHECK_SECOND] == 1); /* REFILL visits leave the pending check alone */
    /* The second check starts a refill when it scores. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    set_kind(&f, 0, 3, 4); set_kind(&f, 1, 3, 4); set_kind(&f, 2, 3, 4);
    f.o.b[E4R_O_CHECK_SECOND] = 1;
    set32(&f, E4R_O_SWAP_ROW, 2); set32(&f, E4R_O_SWAP_COL, 3);
    CHECK(visit(&f) == E4R_OK && state_of(&f) == E4R_STATE_REFILL && f.o.b[E4R_O_CHECK_SECOND] == 0);
    CHECK(strcmp(text_of(&f, E4R_O_NAME_TEXT), "piece4") == 0);
}

/* State 1: the end sound starts (0x476a25 jump table entry 1). */
static void t_state_end(void)
{
    Fx f;
    char want[128];
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    play_state(&f, E4R_STATE_END);
    CHECK(visit(&f) == E4R_OK && state_of(&f) == E4R_STATE_END_WAIT && (uint32_t)od32(&f, E4R_O_DEADLINE) == 1000u + 3000u);
    snprintf(want, sizeof want, "prep:%d:0,play:14:0,tick:1000:0", O_SOUND_D);
    CHECK_LOG(&f, want);
    CHECK(f.n_prep == 1 && f.prep_off[0] == O_SOUND_D && f.n_play == 1 && f.played[0] == 14);
    fx_init(&f);
    put_text(f.body, O_SOUND_D, "NO SOUND");
    CHECK(start(&f) == E4R_OK);
    play_state(&f, E4R_STATE_END);
    CHECK(visit(&f) == E4R_OK && state_of(&f) == E4R_STATE_END_WAIT);
    CHECK_LOG(&f, "tick:1000:0");
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    play_state(&f, E4R_STATE_END);
    f.now = 0xffffff00u;
    CHECK(visit(&f) == E4R_OK && (uint32_t)od32(&f, E4R_O_DEADLINE) == (uint32_t)(0xffffff00u + 3000u));
    fx_init(&f);
    put16(f.body, O_FINAL_DELAY, 0);
    CHECK(start(&f) == E4R_OK);
    play_state(&f, E4R_STATE_END);
    CHECK(visit(&f) == E4R_OK && (uint32_t)od32(&f, E4R_O_DEADLINE) == 1000u);
}

/* State 2: matched pieces shown until the deadline and the match sound has finished, then refilled. */
static void t_state_refill(void)
{
    Fx f;
    char want[256];
    for (int scenario = 0; scenario < 7; ++scenario) {
        fx_init(&f);
        CHECK(start(&f) == E4R_OK);
        play_state(&f, E4R_STATE_REFILL);
        set32(&f, E4R_O_DEADLINE, 2000);
        f.now = scenario < 3 ? 1999u : 2000u; /* before the deadline, then at it */
        switch (scenario) {
        case 0: f.busy_default = 0; break;                                       /* b2 = 0, b3 = 0: the match sound starts */
        case 1: f.busy_script[0] = 1; f.busy_n = 1; break;                       /* b2 = 1: nothing more */
        case 2: f.busy_script[0] = 0; f.busy_script[1] = 1; f.busy_n = 2; break; /* b3 = 1: no sound */
        case 3: f.busy_script[0] = 1; f.busy_n = 1; f.busy_default = 1; break;   /* at the deadline, b1 = 1: wait; b2 = 1 */
        case 4: f.busy_script[0] = 1; f.busy_script[1] = 0; f.busy_script[2] = 0; f.busy_n = 3; break; /* b1 = 1, b2 = 0, b3 = 0 */
        case 5: f.busy_script[0] = 1; f.busy_script[1] = 0; f.busy_script[2] = 1; f.busy_n = 3; break;
        default: break; /* case 6: b1 = 0 at the deadline: the refill itself */
        }
        if (scenario == 6) set32(&f, E4R_O_DEADLINE, 1000);
        f.o.b[CELL(0, 1) + 1] = 1;
        f.o.b[CELL(2, 3) + 1] = 1;
        f.o.b[CELL(1, 1) + 1] = 2; /* only the value 1 means matched */
        if (scenario == 6) {
            static const int32_t rs[] = {0, 5, 4};
            script(&f, rs, 3);
            f.o.b[E4R_O_SHOW_NAME] = 1;
            f.o.b[E4R_O_NAME_DIRTY] = 0;
            put_text(f.o.b, E4R_O_NAME_TEXT, "left over");
        }
        CHECK(visit(&f) == E4R_OK);
        switch (scenario) {
        case 0:
            snprintf(want, sizeof want, "tick:1999:0,busy:11:0,busy:11:0,play:11:0");
            CHECK_LOG(&f, want);
            CHECK(f.n_play == 1 && f.played[0] == 11);
            break;
        case 1: CHECK_LOG(&f, "tick:1999:0,busy:11:1"); break;
        case 2: CHECK_LOG(&f, "tick:1999:0,busy:11:0,busy:11:1"); break;
        case 3: CHECK_LOG(&f, "tick:2000:0,busy:11:1,busy:11:1"); break;
        case 4: CHECK_LOG(&f, "tick:2000:0,busy:11:1,busy:11:0,busy:11:0,play:11:0"); break;
        case 5: CHECK_LOG(&f, "tick:2000:0,busy:11:1,busy:11:0,busy:11:1"); break;
        default:
            CHECK_LOG(&f, "tick:2000:0,busy:11:0,rand:0:0,rand:5:0,rand:4:0");
            break;
        }
        if (scenario < 6) {
            CHECK(state_of(&f) == E4R_STATE_REFILL && f.o.b[CELL(0, 1) + 1] == 1 && f.o.b[CELL(2, 3) + 1] == 1);
        } else {
            /* (0,1): 0 equals its left neighbour 0 (retry), 5 -> kind 1; (2,3): 4 -> kind 0 (up is 4, left is 4). */
            CHECK(state_of(&f) == 0 && kind_at(&f, 0, 1) == 1 && kind_at(&f, 2, 3) == 0);
            CHECK(f.o.b[CELL(0, 1) + 1] == 0 && f.o.b[CELL(2, 3) + 1] == 0 && f.o.b[CELL(1, 1) + 1] == 2);
            CHECK(f.o.b[CELL(0, 1)] == 1 && text_of(&f, E4R_O_NAME_TEXT)[0] == '\0' && f.o.b[E4R_O_SHOW_NAME] == 0 &&
                  f.o.b[E4R_O_NAME_DIRTY] == 1);
            CHECK(kind_at(&f, 1, 1) == 2); /* the cell marked 2 stays as it was */
        }
    }
    /* NO SOUND for the match sound: the busy queries run, no play. */
    fx_init(&f);
    put_text(f.body, O_SOUND_A, "NO SOUND");
    CHECK(start(&f) == E4R_OK);
    play_state(&f, E4R_STATE_REFILL);
    set32(&f, E4R_O_DEADLINE, 2000);
    CHECK(visit(&f) == E4R_OK && f.n_play == 0 && strstr(f.log, "busy:11:0,busy:11:0") != NULL);
    /* The deadline comparison is unsigned. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    play_state(&f, E4R_STATE_REFILL);
    set32(&f, E4R_O_DEADLINE, (int32_t)0xfffffff0u);
    CHECK(visit(&f) == E4R_OK && state_of(&f) == E4R_STATE_REFILL);
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    play_state(&f, E4R_STATE_REFILL);
    set32(&f, E4R_O_DEADLINE, 1000);
    f.now = 0xfffffff0u;
    CHECK(visit(&f) == E4R_OK && state_of(&f) == 0);
}

/* State 3: the shuffle button is shown pressed until the deadline, then the whole board is refilled. */
static void t_state_shuffle(void)
{
    Fx f;
    for (int before = 0; before < 4; ++before) {
        fx_init(&f);
        CHECK(start(&f) == E4R_OK);
        play_state(&f, E4R_STATE_SHUFFLE);
        f.o.b[E4R_O_SHUFFLE_DOWN] = 1;
        set32(&f, E4R_O_SHUFFLE_END, before == 0 ? 1001 : (before == 1 ? 1000 : (before == 2 ? 999 : (int32_t)0xfffffff0u)));
        CHECK(visit(&f) == E4R_OK);
        if (before == 0 || before == 3) {
            CHECK(state_of(&f) == E4R_STATE_SHUFFLE && f.o.b[E4R_O_SHUFFLE_DOWN] == 1 && f.o.b[E4R_O_SHUFFLE_DIRTY] == 0);
            CHECK_LOG(&f, "tick:1000:0");
        } else {
            CHECK(state_of(&f) == 0 && f.o.b[E4R_O_SHUFFLE_DOWN] == 0 && f.o.b[E4R_O_SHUFFLE_DIRTY] == 1);
            for (int r = 0; r < 3; ++r)
                for (int c = 0; c < 4; ++c) {
                    CHECK(f.o.b[CELL(r, c)] == 1 && f.o.b[CELL(r, c) + 1] == 0 && kind_at(&f, r, c) <= 3 && kind_at(&f, r, c) >= 0);
                    if (r > 0) CHECK(kind_at(&f, r, c) != kind_at(&f, r - 1, c));
                    if (c > 0) CHECK(kind_at(&f, r, c) != kind_at(&f, r, c - 1));
                }
            CHECK(strncmp(f.log, "tick:1000:0,rand:", 17) == 0);
        }
    }
}

/* States 4 and 5: the end sound wait and the delay before it is checked. */
static void t_state_end_wait(void)
{
    Fx f;
    char want[128];
    for (int busy = 0; busy < 2; ++busy) {
        fx_init(&f);
        CHECK(start(&f) == E4R_OK);
        play_state(&f, E4R_STATE_END_SOUND);
        f.busy_script[0] = busy;
        f.busy_n = 1;
        CHECK(visit(&f) == E4R_OK && state_of(&f) == E4R_STATE_SCORES && (uint32_t)od32(&f, E4R_O_DEADLINE) == 1000u + 5000u);
        CHECK(f.o.b[E4R_O_ERASE_ALL] == 1);
        snprintf(want, sizeof want, busy ? "busy:14:1,tick:1000:0" : "busy:14:0,stop:%d:0,tick:1000:0", O_SOUND_D);
        CHECK_LOG(&f, want);
        CHECK(f.n_stop == (busy ? 0 : 1));
    }
    fx_init(&f);
    put_text(f.body, O_SOUND_D, "NO SOUND"); /* the stop is not suppressed by the sound name (0x476a25 tests only the busy result) */
    CHECK(start(&f) == E4R_OK);
    play_state(&f, E4R_STATE_END_SOUND);
    CHECK(visit(&f) == E4R_OK && f.n_stop == 1);
    for (int i = 0; i < 4; ++i) {
        fx_init(&f);
        CHECK(start(&f) == E4R_OK);
        play_state(&f, E4R_STATE_END_WAIT);
        set32(&f, E4R_O_DEADLINE, i == 0 ? 1001 : (i == 1 ? 1000 : (i == 2 ? 5 : (int32_t)0xfffffff0u)));
        CHECK(visit(&f) == E4R_OK);
        CHECK(state_of(&f) == (i == 1 || i == 2 ? E4R_STATE_END_SOUND : E4R_STATE_END_WAIT));
        CHECK_LOG(&f, "tick:1000:0");
    }
}

/* State 6: the high score screen (insertion at every rank, then restart or finish). */
static void t_state_scores(void)
{
    Fx f;
    struct { int32_t score; int32_t want[5]; int inserted; } cases[] = {
        {60, {60, 50, 40, 30, 20}, 1}, {50, {50, 50, 40, 30, 20}, 1}, {45, {50, 45, 40, 30, 20}, 1}, {41, {50, 41, 40, 30, 20}, 1},
        {40, {50, 40, 40, 30, 20}, 1}, {35, {50, 40, 35, 30, 20}, 1}, {25, {50, 40, 30, 25, 20}, 1}, {15, {50, 40, 30, 20, 15}, 1},
        {11, {50, 40, 30, 20, 11}, 1}, {10, {50, 40, 30, 20, 10}, 0}, {5, {50, 40, 30, 20, 10}, 0}, {-3, {50, 40, 30, 20, 10}, 0}};
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        fx_init(&f);
        CHECK(start(&f) == E4R_OK);
        play_state(&f, E4R_STATE_SCORES);
        set32(&f, E4R_O_DEADLINE, 1000);
        set32(&f, E4R_O_SCORE, cases[i].score);
        set32(&f, E4R_O_WON, 1); /* the won path leaves the screen state alone */
        f.world.high_score_marker_5a0545 = 77;
        for (int k = 0; k < 5; ++k) f.world.high_score[k] = 50 - 10 * k;
        CHECK(visit(&f) == E4R_OK);
        for (int k = 0; k < 5; ++k) CHECK(f.world.high_score[k] == cases[i].want[k]);
        CHECK(f.o.b[E4R_O_ERASE_ALL] == (uint8_t)cases[i].inserted);
        CHECK(f.world.high_score_marker_5a0545 == 77 && f.world.start_flag_5bb1ca == 1); /* nothing past the table is written */
        CHECK(f.res.phase_after == 2u && strstr(f.log, "phase:2:0") != NULL && state_of(&f) == E4R_STATE_SCORES);
    }
    /* An empty table takes any score above 0 at the top; the best-first order holds. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    play_state(&f, E4R_STATE_SCORES);
    set32(&f, E4R_O_DEADLINE, 1000);
    set32(&f, E4R_O_SCORE, 7);
    CHECK(visit(&f) == E4R_OK);
    CHECK(f.world.high_score[0] == 7 && f.world.high_score[1] == 0 && f.world.high_score[4] == 0);
    /* The table is exactly five entries: a world allocated to its size (ASan fences it) is never read or written past them. */
    {
        E4rWorld *hw = (E4rWorld *)malloc(sizeof *hw);
        CHECK(hw != NULL);
        if (hw != NULL) {
            fx_init(&f);
            CHECK(start(&f) == E4R_OK);
            play_state(&f, E4R_STATE_SCORES);
            set32(&f, E4R_O_DEADLINE, 1000);
            set32(&f, E4R_O_SCORE, 45);
            *hw = f.world;
            for (int k = 0; k < 5; ++k) hw->high_score[k] = 50 - 10 * k;
            CHECK(e4r_step(&f.o, f.body, E4R_BODY_BYTES, f.row, 1u, hw, &f.host, &f.res, &f.failure) == E4R_OK);
            CHECK(hw->high_score[1] == 45 && hw->high_score[4] == 20 && hw->start_flag_5bb1ca == 1);
            free(hw);
        }
    }
    /* Not won: the game restarts in state PLAY with the score and time reset. */
    CHECK(state_of(&f) == 0 && od32(&f, E4R_O_SCORE) == 0 && od32(&f, E4R_O_TIME_END) == 61000 && f.o.b[E4R_O_ERASE_ALL] == 1);
    CHECK(strcmp(text_of(&f, E4R_O_SCORE_TEXT), "0") == 0 && text_of(&f, E4R_O_TIME_TEXT)[0] == '\0' && f.res.phase_after == 1u);
    CHECK_LOG(&f, "tick:1000:0,tick:1000:0");
    /* Before the deadline: nothing, unless won with no time limit. */
    for (int variant = 0; variant < 4; ++variant) {
        fx_init(&f);
        if (variant >= 2) put16(f.body, O_TIME_LIMIT, 0);
        CHECK(start(&f) == E4R_OK);
        play_state(&f, E4R_STATE_SCORES);
        set32(&f, E4R_O_DEADLINE, 1001);
        set32(&f, E4R_O_WON, variant & 1);
        set32(&f, E4R_O_SCORE, 99);
        CHECK(visit(&f) == E4R_OK);
        CHECK(f.res.phase_after == (variant == 3 ? 2u : 1u));
        CHECK((strstr(f.log, "phase:2:0") != NULL) == (variant == 3)); /* the finish is logged */
        CHECK(f.world.high_score[0] == 0 && f.o.b[E4R_O_ERASE_ALL] == 0 && state_of(&f) == E4R_STATE_SCORES);
    }
    /* Won, no time limit, deadline reached: finishes (the table is still updated). */
    fx_init(&f);
    put16(f.body, O_TIME_LIMIT, 0);
    CHECK(start(&f) == E4R_OK);
    play_state(&f, E4R_STATE_SCORES);
    set32(&f, E4R_O_DEADLINE, 1000);
    set32(&f, E4R_O_WON, 1);
    set32(&f, E4R_O_SCORE, 99);
    CHECK(visit(&f) == E4R_OK && f.res.phase_after == 2u && f.world.high_score[0] == 99);
    /* The deadline comparison is unsigned. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    play_state(&f, E4R_STATE_SCORES);
    set32(&f, E4R_O_DEADLINE, (int32_t)0xfffffff0u);
    set32(&f, E4R_O_SCORE, 9);
    CHECK(visit(&f) == E4R_OK && f.world.high_score[0] == 0 && state_of(&f) == E4R_STATE_SCORES);
    /* Restart after a score screen with a time limit of 0 and a wrapped clock. */
    fx_init(&f);
    put16(f.body, O_TIME_LIMIT, 0);
    CHECK(start(&f) == E4R_OK);
    play_state(&f, E4R_STATE_SCORES);
    set32(&f, E4R_O_DEADLINE, 1000);
    f.now = 4242u;
    set32(&f, E4R_O_DEADLINE, 100);
    CHECK(visit(&f) == E4R_OK && od32(&f, E4R_O_TIME_END) == 4242);
}

/* ---- phase 2: the finish (0x476a25 case 2, 0x42ba3a, 0x475885) ------------------------------------------------------------ */

static void t_phase2_exit_and_win(void)
{
    Fx f;
    char want[512];
    /* Exit block: scene 42, start-flag word 0 stores 1, no event flag. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    set32(&f, E4R_O_EXIT, 1);
    CHECK(step(&f, 2u) == E4R_OK && f.res.completed == 1u && f.res.initialized == 0u);
    snprintf(want, sizeof want,
             "start:1:0,stop:%d:0,stop:%d:0,stop:%d:0,x57b:42:0,x599:4:0,x595:5:0,x39ff:6:0,x59b:44:0,x59f:55:0,x5a3:66:0,"
             "start:1:0,mode:4:0,fontrel:3:0,complete:2:0,relsurf:100:0,relsurf:101:1,relslot:24:0", O_SOUND_A, O_SOUND_B, O_SOUND_C);
    CHECK_LOG(&f, want);
    CHECK(f.n_tr == 1 && f.tr.scene == 42 && f.tr.word[0] == 4 && f.tr.word[1] == 5 && f.tr.word[2] == 6 && f.tr.dword[0] == 44 &&
          f.tr.dword[1] == 55 && f.tr.dword[2] == 66 && f.n_flag == 0 && f.world.start_flag_5bb1ca == 1);
    CHECK(f.n_fontrel == 1 && f.fontrel_font == 3 && f.n_stop == 3 && f.stop_off[0] == O_SOUND_A && f.stop_off[2] == O_SOUND_C);
    CHECK(f.res.phase_after == 2u);
    CHECK(od16(&f, E4R_O_ROW) == -1 && od16(&f, E4R_O_SLOT) == -1 && od32(&f, E4R_O_ACTIVE) == 0 && od32(&f, E4R_O_EXIT) == 0 &&
          od32(&f, E4R_O_WON) == 0 && od32(&f, E4R_O_SURFACE) == 0 && od32(&f, E4R_O_SCORE_SURFACE) == 0);
    /* Win block: scene 41, start-flag word 1 stores 0, event flag 5 := 9. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    set32(&f, E4R_O_WON, 1);
    CHECK(step(&f, 2u) == E4R_OK && f.res.completed == 1u);
    CHECK(f.n_tr == 1 && f.tr.scene == 41 && f.tr.word[0] == 1 && f.tr.dword[2] == 33 && f.n_flag == 1 && f.flag_idx == 5 &&
          f.flag_val == 9u && f.world.start_flag_5bb1ca == 0);
    snprintf(want, sizeof want,
             "start:1:0,stop:%d:0,stop:%d:0,stop:%d:0,x57b:41:0,x599:1:0,x595:2:0,x39ff:3:0,x59b:11:0,x59f:22:0,x5a3:33:0,"
             "start:0:0,mode:4:0,evflag:5:9,fontrel:3:0,complete:2:0,relsurf:100:0,relsurf:101:1,relslot:24:0", O_SOUND_A, O_SOUND_B, O_SOUND_C);
    CHECK_LOG(&f, want);
    /* The exit block wins over the win flag. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    set32(&f, E4R_O_WON, 1);
    set32(&f, E4R_O_EXIT, 1);
    CHECK(step(&f, 2u) == E4R_OK && f.tr.scene == 42 && f.n_flag == 0);
    /* Neither flag: no block at all, the rest of the finish still runs. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    CHECK(step(&f, 2u) == E4R_OK && f.n_tr == 0 && f.n_flag == 0 && f.res.completed == 1u);
    CHECK(strstr(f.log, "x57b") == NULL && strstr(f.log, "evflag") == NULL && strstr(f.log, "mode") == NULL && f.world.start_flag_5bb1ca == 1);
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    CHECK(step(&f, 2u) == E4R_OK && strstr(f.log, "complete:2:0") != NULL && strstr(f.log, "x57b") == NULL);
}

static void t_phase2_variants(void)
{
    Fx f;
    /* Scene word 9999: no scene change, the event flag is still stored; flag -1: no store; the start-flag word != 1 stores 1. */
    fx_init(&f);
    set_block(f.body, O_WIN, 9999, 1, 2, 3, 4, 5, 6, 1, 7, 200);
    CHECK(start(&f) == E4R_OK);
    f.world.start_flag_5bb1ca = 5;
    set32(&f, E4R_O_WON, 1);
    CHECK(step(&f, 2u) == E4R_OK && f.n_tr == 0 && f.n_flag == 1 && f.flag_idx == 7 && f.flag_val == 200u);
    CHECK(strstr(f.log, "x57b") == NULL && f.world.start_flag_5bb1ca == 1); /* the phase's own start stores 1 first */
    for (int w = -1; w <= 2; ++w) {
        fx_init(&f);
        set_block(f.body, O_EXIT, 50, 0, 0, 0, 0, 0, 0, w, -1, 0);
        CHECK(start(&f) == E4R_OK);
        set32(&f, E4R_O_EXIT, 1);
        CHECK(step(&f, 2u) == E4R_OK && f.world.start_flag_5bb1ca == (w == 1 ? 0 : 1) && f.n_flag == 0);
    }
    /* Negative scene words/dwords pass through sign-extended. */
    fx_init(&f);
    set_block(f.body, O_EXIT, -2, -3, -4, -5, -6, -7, -8, 0, 0, 255);
    CHECK(start(&f) == E4R_OK);
    set32(&f, E4R_O_EXIT, 1);
    CHECK(step(&f, 2u) == E4R_OK && f.tr.scene == -2 && f.tr.word[0] == -3 && f.tr.word[2] == -5 && f.tr.dword[1] == -7 &&
          f.flag_idx == 0 && f.flag_val == 255u);
    CHECK(strstr(f.log, "x57b:-2:0") != NULL && strstr(f.log, "evflag:0:255") != NULL);
    /* Sound stops skip "NO SOUND" records; the font is released only with the name panel. */
    for (int which = 0; which < 3; ++which) {
        const int offs[3] = {O_SOUND_A, O_SOUND_B, O_SOUND_C};
        fx_init(&f);
        put_text(f.body, (size_t)offs[which], "NO SOUND");
        CHECK(start(&f) == E4R_OK);
        CHECK(step(&f, 2u) == E4R_OK && f.n_stop == 2);
        for (int i = 0; i < f.n_stop; ++i) CHECK(f.stop_off[i] != offs[which]);
    }
    fx_init(&f);
    f.body[O_NAME_PANEL] = 0;
    CHECK(start(&f) == E4R_OK);
    CHECK(step(&f, 2u) == E4R_OK && f.n_fontrel == 0 && strstr(f.log, "fontrel") == NULL && f.res.completed == 1u);
    /* The sound record D is not stopped by the finish. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    CHECK(step(&f, 2u) == E4R_OK);
    for (int i = 0; i < f.n_stop; ++i) CHECK(f.stop_off[i] != O_SOUND_D);
    /* Every host callback failing in turn ends the finish with E4R_ERR_HOST, on the win path and on the exit path. */
    for (int exit_path = 0; exit_path < 2; ++exit_path) {
        int total;
        fx_init(&f);
        put16(f.body, O_EXIT + 22, 7); /* a flag to store, so the exit block makes a host call too */
        CHECK(start(&f) == E4R_OK);
        set32(&f, exit_path ? E4R_O_EXIT : E4R_O_WON, 1);
        CHECK(step(&f, 2u) == E4R_OK);
        total = f.calls;
        CHECK(total >= 8);
        for (int n = 1; n <= total; ++n) {
            fx_init(&f);
            put16(f.body, O_EXIT + 22, 7);
            CHECK(start(&f) == E4R_OK);
            set32(&f, exit_path ? E4R_O_EXIT : E4R_O_WON, 1);
            f.fail_call = n;
            CHECK(step(&f, 2u) == E4R_ERR_HOST && strcmp(f.failure, "e4-host-failure") == 0);
        }
    }
}

/* ---- pointer (0x475da4, 0x475fb1) ------------------------------------------------------------------------------------------ */

static void t_pointer(void)
{
    Fx f;
    E4rPointerResult p;
    fx_init(&f);
    /* Inactive: nothing, the result is cleared. */
    memset(&p, 0x55, sizeof p);
    CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 34, 54, &p) == E4R_OK && p.hit == 0u && p.candidate == -1 &&
          p.cursor_written == 0u && p.cursor_kind == 0 && p.cursor_sub == 0);
    CHECK(start(&f) == E4R_OK);
    /* Cell (0,0) is (30,50)-(38,59): pieces hit with a 3 pixel inset, inclusive. */
    struct { int x, y, hit; } pts[] = {{33, 53, 1}, {35, 56, 1}, {34, 54, 1}, {32, 54, 0}, {36, 54, 0}, {34, 52, 0}, {34, 57, 0},
                                       {33, 56, 1}, {35, 53, 1}, {33, 57, 0}, {32, 53, 0}, {36, 56, 0}, {35, 52, 0}};
    for (size_t i = 0; i < sizeof pts / sizeof pts[0]; ++i) {
        set32(&f, E4R_O_HOVER_ROW, 7);
        set32(&f, E4R_O_HOVER_COL, 7);
        CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, pts[i].x, pts[i].y, &p) == E4R_OK && p.hit == (uint8_t)pts[i].hit);
        if (pts[i].hit) {
            CHECK(p.candidate == E4R_CANDIDATE_PIECE && p.cursor_written == 1u && p.cursor_kind == 0x16 && p.cursor_sub == 1);
            CHECK(od32(&f, E4R_O_HOVER_ROW) == 0 && od32(&f, E4R_O_HOVER_COL) == 0);
        } else {
            CHECK(p.candidate == -1 && p.cursor_written == 0u && od32(&f, E4R_O_HOVER_ROW) == 7 && od32(&f, E4R_O_HOVER_COL) == 7);
        }
    }
    /* Row and column of the hit: cell (2,3) is (63,72)-(71,81). */
    CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 67, 76, &p) == E4R_OK && p.hit == 1u && od32(&f, E4R_O_HOVER_ROW) == 2 &&
          od32(&f, E4R_O_HOVER_COL) == 3);
    CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 45, 65, &p) == E4R_OK && p.hit == 1u && od32(&f, E4R_O_HOVER_ROW) == 1 &&
          od32(&f, E4R_O_HOVER_COL) == 1); /* cell (1,1): (41,61)-(49,70) */
    /* The coordinates are signed 16-bit words: the upper halves are garbage. */
    CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 34 + 0x70000, 54 + 0x30000, &p) == E4R_OK && p.hit == 1u);
    CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 34 - 0x10000, 54, &p) == E4R_OK && p.hit == 1u);
    CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 34 + 0x8000, 54, &p) == E4R_OK && p.hit == 0u); /* word 0x8022 is negative */
    /* The shuffle button (400,300)-(450,330) and the exit button (600,400)-(640,430): inclusive, no inset. */
    struct { int x, y; int32_t cand; int kind; } btn[] = {{400, 300, E4R_CANDIDATE_SHUFFLE, 0x16}, {450, 330, E4R_CANDIDATE_SHUFFLE, 0x16},
                                                          {425, 315, E4R_CANDIDATE_SHUFFLE, 0x16}, {600, 400, E4R_CANDIDATE_EXIT, 9},
                                                          {640, 430, E4R_CANDIDATE_EXIT, 9}, {620, 415, E4R_CANDIDATE_EXIT, 9}};
    for (size_t i = 0; i < sizeof btn / sizeof btn[0]; ++i) {
        set32(&f, E4R_O_HOVER_ROW, 1);
        CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, btn[i].x, btn[i].y, &p) == E4R_OK && p.hit == 1u && p.candidate == btn[i].cand);
        CHECK(p.cursor_written == 1u && p.cursor_kind == btn[i].kind && p.cursor_sub == 1 && od32(&f, E4R_O_HOVER_ROW) == 1);
    }
    struct { int x, y; } misses[] = {{399, 300}, {400, 299}, {451, 330}, {450, 331}, {599, 400}, {600, 399}, {641, 430}, {640, 431}, {0, 0}};
    for (size_t i = 0; i < sizeof misses / sizeof misses[0]; ++i)
        CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, misses[i].x, misses[i].y, &p) == E4R_OK && p.hit == 0u && p.candidate == -1);
    /* Order: a piece wins over the shuffle button, the shuffle button over the exit button. */
    put_rect(f.body, O_SHUFFLE_RECT, 30, 50, 100, 100);
    CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 34, 54, &p) == E4R_OK && p.candidate == E4R_CANDIDATE_PIECE);
    CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 39, 54, &p) == E4R_OK && p.candidate == E4R_CANDIDATE_SHUFFLE); /* in the gap */
    put_rect(f.body, O_EXIT_RECT, 30, 50, 100, 100);
    CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 39, 54, &p) == E4R_OK && p.candidate == E4R_CANDIDATE_SHUFFLE);
    put_rect(f.body, O_SHUFFLE_RECT, 400, 300, 450, 330);
    CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 39, 54, &p) == E4R_OK && p.candidate == E4R_CANDIDATE_EXIT);
    put_rect(f.body, O_EXIT_RECT, 600, 400, 640, 430);
    /* Cells outside the board are not hit even when present. */
    f.o.b[CELL(3, 0)] = 1;
    put_rect(f.o.b, CELL(3, 0) + 4, 0, 0, 100, 100);
    CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 50, 50, &p) == E4R_OK && p.hit == 0u);
    /* State REFILL ignores the pointer; state SCORES hides the exit button (the hit stops the cascade, no candidate). */
    set32(&f, E4R_O_HOVER_ROW, 1);
    play_state(&f, E4R_STATE_REFILL);
    CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 34, 54, &p) == E4R_OK && p.hit == 0u && p.candidate == -1 &&
          od32(&f, E4R_O_HOVER_ROW) == 1);
    CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 425, 315, &p) == E4R_OK && p.hit == 0u);
    play_state(&f, E4R_STATE_SCORES);
    CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 620, 415, &p) == E4R_OK && p.hit == 1u && p.candidate == -1 && p.cursor_written == 0u);
    CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 425, 315, &p) == E4R_OK && p.hit == 1u && p.candidate == E4R_CANDIDATE_SHUFFLE);
    for (int st = 0; st <= 6; ++st) {
        if (st == E4R_STATE_REFILL) continue;
        play_state(&f, st);
        CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 34, 54, &p) == E4R_OK && p.hit == 1u);
    }
    /* A zero-sized or inverted cell rectangle is never hit. */
    put_rect(f.o.b, CELL(0, 0) + 4, 33, 53, 35, 56);
    CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 34, 54, &p) == E4R_OK && p.hit == 0u);
}

/* ---- click (0x47608e) ---------------------------------------------------------------------------------------------------------- */

static void hover(Fx *f, int r, int c)
{
    E4rPointerResult p;
    const int x = 30 + 11 * c + 4, y = 50 + 11 * r + 4;
    CHECK(e4r_pointer(&f->o, f->body, E4R_BODY_BYTES, x, y, &p) == E4R_OK && p.candidate == E4R_CANDIDATE_PIECE);
}

static int click(Fx *f, uint32_t row_phase, int32_t candidate, E4rClickResult *out)
{
    return f->rc = e4r_click(&f->o, f->body, E4R_BODY_BYTES, row_phase, candidate, &f->host, out);
}

static void t_click_guards(void)
{
    Fx f;
    E4rClickResult c;
    E4rObject before;
    for (int guard = 0; guard < 8; ++guard) {
        fx_init(&f);
        CHECK(start(&f) == E4R_OK);
        hover(&f, 0, 0);
        switch (guard) {
        case 0: set32(&f, E4R_O_ACTIVE, 0); break;
        case 1: set32(&f, E4R_O_WON, 1); break;
        case 2: play_state(&f, E4R_STATE_END); break;
        case 3: play_state(&f, E4R_STATE_REFILL); break;
        case 4: f.o.b[E4R_O_CHECK_FIRST] = 1; break;
        case 5: f.o.b[E4R_O_CHECK_SECOND] = 1; break;
        case 6: break; /* row phase 0 */
        default: break; /* row phase 2 */
        }
        before = f.o;
        for (int cand = 0; cand < 3; ++cand) {
            const int32_t cands[3] = {E4R_CANDIDATE_PIECE, E4R_CANDIDATE_EXIT, E4R_CANDIDATE_SHUFFLE};
            memset(&c, 0x55, sizeof c);
            CHECK(click(&f, guard == 6 ? 0u : (guard == 7 ? 2u : 1u), cands[cand], &c) == E4R_OK && c.fired == 0u &&
                  c.sound_played == 0u && c.phase_changed == 0u && c.phase == 0u);
            CHECK(memcmp(&before, &f.o, sizeof before) == 0 && f.log[0] == '\0');
        }
    }
    /* Other candidates: the guard holds but nothing is done. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    hover(&f, 0, 0);
    before = f.o;
    {
        const int32_t others[] = {-1, 0, 0x27d4, 0x27d8, 0x27d5 + 0x10000};
        for (size_t i = 0; i < sizeof others / sizeof others[0]; ++i)
            CHECK(click(&f, 1u, others[i], &c) == E4R_OK && c.fired == 0u && memcmp(&before, &f.o, sizeof before) == 0 && f.log[0] == '\0');
    }
}

static void t_click_select_and_swap(void)
{
    Fx f;
    E4rClickResult c;
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    /* First click: the piece under the pointer is selected; the piece-click sound plays when its channel is idle. */
    hover(&f, 1, 2);
    CHECK(click(&f, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_OK && c.fired == 1u && c.sound_played == 1u && c.phase_changed == 0u);
    CHECK_LOG(&f, "busy:13:0,play:13:0");
    CHECK(f.n_play == 1 && f.played[0] == 13);
    CHECK(od32(&f, E4R_O_SEL_ROW) == 1 && od32(&f, E4R_O_SEL_COL) == 2 && od32(&f, E4R_O_NO_SELECTION) == 0);
    CHECK(f.o.b[E4R_O_CHECK_FIRST] == 0 && f.o.b[E4R_O_CHECK_SECOND] == 0 && kind_at(&f, 1, 2) == 3);
    /* Second click: the two pieces swap (no adjacency needed) and both are to be checked. */
    fx_clear(&f);
    hover(&f, 2, 0);
    CHECK(click(&f, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_OK && c.fired == 1u && c.sound_played == 1u);
    CHECK_LOG(&f, "busy:13:0,play:13:0");
    CHECK(kind_at(&f, 1, 2) == 2 && kind_at(&f, 2, 0) == 3); /* board A: (1,2) = 3 and (2,0) = 2 */
    CHECK(od32(&f, E4R_O_NO_SELECTION) == 1 && od32(&f, E4R_O_SWAP_ROW) == 2 && od32(&f, E4R_O_SWAP_COL) == 0);
    CHECK(od32(&f, E4R_O_SEL_ROW) == 1 && od32(&f, E4R_O_SEL_COL) == 2);
    CHECK(f.o.b[E4R_O_CHECK_FIRST] == 1 && f.o.b[E4R_O_CHECK_SECOND] == 1);
    /* While a check is pending the click does nothing. */
    {
        E4rObject snap = f.o;
        CHECK(click(&f, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_OK && c.fired == 0u && memcmp(&snap, &f.o, sizeof snap) == 0);
    }
    /* Selecting the same piece twice swaps it with itself. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    hover(&f, 0, 1);
    CHECK(click(&f, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_OK);
    CHECK(click(&f, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_OK && c.fired == 1u && kind_at(&f, 0, 1) == 1);
    CHECK(f.o.b[E4R_O_CHECK_FIRST] == 1 && od32(&f, E4R_O_SWAP_ROW) == 0 && od32(&f, E4R_O_SWAP_COL) == 1);
    /* A busy channel: no play; NO SOUND: no query at all. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    hover(&f, 0, 0);
    f.busy_script[0] = 1;
    f.busy_n = 1;
    CHECK(click(&f, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_OK && c.fired == 1u && c.sound_played == 0u && f.n_play == 0);
    CHECK_LOG(&f, "busy:13:1");
    fx_init(&f);
    put_text(f.body, O_SOUND_C, "NO SOUND");
    CHECK(start(&f) == E4R_OK);
    hover(&f, 0, 0);
    CHECK(click(&f, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_OK && c.fired == 1u && c.sound_played == 0u && f.log[0] == '\0');
    CHECK(od32(&f, E4R_O_NO_SELECTION) == 0);
    /* The selection and hover must lie on the board (a corrupt object is refused, nothing changes). */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    set32(&f, E4R_O_HOVER_ROW, 3);
    set32(&f, E4R_O_HOVER_COL, 0);
    CHECK(click(&f, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_ERR_UNSUPPORTED && c.fired == 0u && od32(&f, E4R_O_NO_SELECTION) == 1);
    set32(&f, E4R_O_HOVER_ROW, 0);
    set32(&f, E4R_O_HOVER_COL, -1);
    CHECK(click(&f, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_ERR_UNSUPPORTED);
    set32(&f, E4R_O_HOVER_COL, 4);
    CHECK(click(&f, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_ERR_UNSUPPORTED);
    set32(&f, E4R_O_HOVER_ROW, -1);
    set32(&f, E4R_O_HOVER_COL, 0);
    CHECK(click(&f, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_ERR_UNSUPPORTED);
    hover(&f, 1, 1);
    CHECK(click(&f, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_OK); /* selected */
    for (int bad = 0; bad < 4; ++bad) {
        E4rObject snap = f.o;
        set32(&f, bad < 2 ? E4R_O_SEL_ROW : E4R_O_SEL_COL, bad == 0 ? 3 : (bad == 1 ? -1 : (bad == 2 ? 4 : -1)));
        CHECK(click(&f, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_ERR_UNSUPPORTED && c.fired == 0u && f.o.b[E4R_O_CHECK_FIRST] == 0);
        f.o = snap;
    }
    set32(&f, E4R_O_SEL_ROW, 2);
    set32(&f, E4R_O_SEL_COL, 3);
    CHECK(click(&f, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_OK && c.fired == 1u && kind_at(&f, 2, 3) == 2 && kind_at(&f, 1, 1) == 0);
}

static void t_click_shuffle_and_exit(void)
{
    Fx f;
    E4rClickResult c;
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    CHECK(click(&f, 1u, E4R_CANDIDATE_SHUFFLE, &c) == E4R_OK && c.fired == 1u && c.sound_played == 1u && c.phase_changed == 0u);
    CHECK_LOG(&f, "busy:12:0,play:12:0,tick:1000:0");
    CHECK(f.played[0] == 12 && (uint32_t)od32(&f, E4R_O_SHUFFLE_END) == 1000u + 0xfau && f.o.b[E4R_O_SHUFFLE_DOWN] == 1 &&
          state_of(&f) == E4R_STATE_SHUFFLE);
    CHECK(od32(&f, E4R_O_NO_SELECTION) == 1); /* a pending selection is not cleared by the shuffle button */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    f.now = 0xffffff80u;
    f.busy_script[0] = 1;
    f.busy_n = 1;
    CHECK(click(&f, 1u, E4R_CANDIDATE_SHUFFLE, &c) == E4R_OK && c.sound_played == 0u && (uint32_t)od32(&f, E4R_O_SHUFFLE_END) == (uint32_t)(0xffffff80u + 0xfau));
    fx_init(&f);
    put_text(f.body, O_SOUND_B, "NO SOUND");
    CHECK(start(&f) == E4R_OK);
    CHECK(click(&f, 1u, E4R_CANDIDATE_SHUFFLE, &c) == E4R_OK && c.fired == 1u && c.sound_played == 0u);
    CHECK_LOG(&f, "tick:1000:0");
    /* Selected piece stays selected across the shuffle button. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    hover(&f, 1, 1);
    CHECK(click(&f, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_OK);
    CHECK(click(&f, 1u, E4R_CANDIDATE_SHUFFLE, &c) == E4R_OK && od32(&f, E4R_O_NO_SELECTION) == 0);
    /* Exit button: the exit flag is set and the row phase becomes 2; no sound. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    CHECK(click(&f, 1u, E4R_CANDIDATE_EXIT, &c) == E4R_OK && c.fired == 1u && c.phase_changed == 1u && c.phase == 2u &&
          c.sound_played == 0u);
    CHECK_LOG(&f, "phase:2:0");
    CHECK(od32(&f, E4R_O_EXIT) == 1 && state_of(&f) == 0);
    /* Sound failures surface as host errors. */
    {
        int total;
        fx_init(&f);
        CHECK(start(&f) == E4R_OK);
        CHECK(click(&f, 1u, E4R_CANDIDATE_SHUFFLE, &c) == E4R_OK);
        total = f.calls;
        CHECK(total == 2);
        for (int n = 1; n <= total; ++n) {
            fx_init(&f);
            CHECK(start(&f) == E4R_OK);
            f.fail_call = n;
            CHECK(click(&f, 1u, E4R_CANDIDATE_SHUFFLE, &c) == E4R_ERR_HOST);
        }
        fx_init(&f);
        CHECK(start(&f) == E4R_OK);
        hover(&f, 0, 0);
        f.fail_call = 2; /* the play */
        CHECK(click(&f, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_ERR_HOST);
        fx_init(&f);
        CHECK(start(&f) == E4R_OK);
        hover(&f, 0, 0);
        CHECK(click(&f, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_OK);
        hover(&f, 1, 0);
        f.calls = 0;
        f.fail_call = 1; /* the busy query of the swap click */
        CHECK(click(&f, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_ERR_HOST);
        f.fail_call = 2;
        f.calls = 0;
        CHECK(click(&f, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_ERR_HOST);
    }
}

/* ---- CheckForMatch (0x4763b3) through the first check of state 0 ------------------------------------------------------------- */

typedef struct Cell2 { int r, c; } Cell2;
static void put_kind0(Fx *f, const Cell2 *cells, int n)
{
    for (int i = 0; i < n; ++i) set_kind(f, cells[i].r, cells[i].c, 0);
}
static int check_at(Fx *f, int r, int c)
{
    f->o.b[E4R_O_CHECK_FIRST] = 1;
    set32(f, E4R_O_SEL_ROW, r);
    set32(f, E4R_O_SEL_COL, c);
    return visit(f);
}
static int matched_count(const Fx *f, int rows, int cols)
{
    int n = 0;
    for (int r = 0; r < rows; ++r)
        for (int c = 0; c < cols; ++c) n += f->o.b[CELL(r, c) + 1] == 1;
    return n;
}

typedef struct MatchCase {
    const char *name;
    int rows, cols;
    Cell2 cells[16];
    int n;
    int at_r, at_c;
    int32_t score, time_delta_s; /* expected score, expected change of the countdown end in seconds */
    int matched;
    int vertical, horizontal;
} MatchCase;

static void t_check_for_match(void)
{
    /* Defaults: 10 per piece; three-run time bonus 2 s; four-run +25 score and 4 s; five-run +60 score and 8 s. */
    static const MatchCase cases[] = {
        {"vertical 3: no bonus (the 3-run time test reads the horizontal run)", 5, 7, {{1, 2}, {2, 2}, {3, 2}}, 3, 2, 2, 30, 0, 3, 1, 0},
        {"vertical 3 checked at its end", 5, 7, {{1, 2}, {2, 2}, {3, 2}}, 3, 1, 2, 30, 0, 3, 1, 0},
        {"vertical 3 at the top edge", 5, 7, {{0, 6}, {1, 6}, {2, 6}}, 3, 0, 6, 30, 0, 3, 1, 0},
        {"vertical 3 at the bottom edge", 5, 7, {{2, 0}, {3, 0}, {4, 0}}, 3, 4, 0, 30, 0, 3, 1, 0},
        {"horizontal 3: time bonus", 5, 7, {{2, 1}, {2, 2}, {2, 3}}, 3, 2, 2, 30, 2, 3, 0, 1},
        {"horizontal 3 at the left edge", 5, 7, {{4, 0}, {4, 1}, {4, 2}}, 3, 4, 0, 30, 2, 3, 0, 1},
        {"horizontal 3 at the right edge", 5, 7, {{0, 4}, {0, 5}, {0, 6}}, 3, 0, 6, 30, 2, 3, 0, 1},
        {"vertical 4: score and time bonus", 5, 7, {{0, 3}, {1, 3}, {2, 3}, {3, 3}}, 4, 3, 3, 65, 4, 4, 1, 0},
        {"horizontal 4: score and time bonus", 5, 7, {{3, 2}, {3, 3}, {3, 4}, {3, 5}}, 4, 3, 4, 65, 4, 4, 0, 1},
        {"vertical 5 over the full height", 5, 7, {{0, 1}, {1, 1}, {2, 1}, {3, 1}, {4, 1}}, 5, 2, 1, 110, 8, 5, 1, 0},
        {"horizontal 5", 5, 7, {{1, 0}, {1, 1}, {1, 2}, {1, 3}, {1, 4}}, 5, 1, 4, 110, 8, 5, 0, 1},
        {"vertical 4 away from the top", 8, 7, {{2, 3}, {3, 3}, {4, 3}, {5, 3}}, 4, 3, 3, 65, 4, 4, 1, 0},
        {"vertical 5 away from the top", 8, 7, {{1, 1}, {2, 1}, {3, 1}, {4, 1}, {5, 1}}, 5, 3, 1, 110, 8, 5, 1, 0},
        {"horizontal 5 away from the left", 5, 7, {{1, 1}, {1, 2}, {1, 3}, {1, 4}, {1, 5}}, 5, 1, 4, 110, 8, 5, 0, 1},
        {"vertical 6: per-piece score only", 8, 7, {{1, 4}, {2, 4}, {3, 4}, {4, 4}, {5, 4}, {6, 4}}, 6, 3, 4, 60, 0, 6, 1, 0},
        {"horizontal 6: per-piece score only", 8, 7, {{5, 0}, {5, 1}, {5, 2}, {5, 3}, {5, 4}, {5, 5}}, 6, 5, 0, 60, 0, 6, 0, 1},
        {"horizontal 7: the whole row", 8, 7, {{2, 0}, {2, 1}, {2, 2}, {2, 3}, {2, 4}, {2, 5}, {2, 6}}, 7, 2, 3, 70, 0, 7, 0, 1},
        {"cross of two 3-runs: the vertical run takes the 3-run time bonus too", 5, 7, {{1, 3}, {2, 3}, {3, 3}, {2, 2}, {2, 4}}, 5, 2, 3, 60, 4, 5, 1, 1},
        {"vertical 4 crossed by a horizontal 3: only the 3-run bonus", 5, 7, {{0, 3}, {1, 3}, {2, 3}, {3, 3}, {1, 2}, {1, 4}}, 6, 1, 3, 70, 4, 6, 1, 1},
        {"horizontal 4 crossed by a vertical 3: the column gets no bonus, the row its 4-run bonus", 5, 7, {{2, 0}, {2, 1}, {2, 2}, {2, 3}, {1, 1}, {3, 1}}, 6, 2, 1, 95, 4, 6, 1, 1},
        {"no match: a pair", 5, 7, {{2, 1}, {2, 2}}, 2, 2, 1, 0, 0, 0, 0, 0},
        {"no match: a vertical pair", 5, 7, {{2, 1}, {3, 1}}, 2, 3, 1, 0, 0, 0, 0, 0},
        {"no match: a run broken by another kind", 5, 7, {{2, 0}, {2, 1}, {2, 3}, {2, 4}}, 4, 2, 0, 0, 0, 0, 0, 0},
        {"no match: a single piece", 5, 7, {{2, 2}}, 1, 2, 2, 0, 0, 0, 0, 0},
    };
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        const MatchCase *m = &cases[i];
        Fx f;
        fx_init(&f);
        CHECK(start_sized(&f, m->rows, m->cols) == E4R_OK);
        put_kind0(&f, m->cells, m->n);
        CHECK(check_at(&f, m->at_r, m->at_c) == E4R_OK);
        CHECK(od32(&f, E4R_O_SCORE) == m->score);
        CHECK(od32(&f, E4R_O_TIME_END) == 61000 + 1000 * m->time_delta_s);
        CHECK(matched_count(&f, m->rows, m->cols) == m->matched);
        CHECK(f.o.b[E4R_O_MATCH_COL] == (uint8_t)m->vertical && f.o.b[E4R_O_MATCH_ROW] == (uint8_t)m->horizontal);
        CHECK(f.o.b[E4R_O_CHECK_FIRST] == 0);
        if (m->matched != 0) {
            char want[16];
            snprintf(want, sizeof want, "%u", (unsigned)m->score);
            CHECK(strcmp(text_of(&f, E4R_O_SCORE_TEXT), want) == 0 && f.o.b[E4R_O_SCORE_DIRTY] == 1);
            /* The refill starts: state, deadline now + 800, the piece name and icon of the checked piece. */
            CHECK(state_of(&f) == E4R_STATE_REFILL && (uint32_t)od32(&f, E4R_O_DEADLINE) == 1800u);
            CHECK(strcmp(text_of(&f, E4R_O_NAME_TEXT), "piece0") == 0 && f.o.b[E4R_O_SHOW_NAME] == 1);
            CHECK(memcmp(f.o.b + E4R_O_ICON_RECT, f.body + O_PIECE, 16) == 0);
            CHECK_LOG(&f, "tick:1000:0");
        } else {
            CHECK(state_of(&f) == 0 && f.log[0] == '\0' && strcmp(text_of(&f, E4R_O_SCORE_TEXT), "0") == 0 &&
                  f.o.b[E4R_O_SCORE_DIRTY] == 0 && f.o.b[E4R_O_SHOW_NAME] == 0);
        }
        if (g_failed) {
            snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " [case: %.60s]", m->name);
            return;
        }
    }
}

/* The run bounds the check stores (obj+0x8ce..0x8d4), a different kind next to the run, and the kind named by the checked piece. */
static void t_check_run_bounds(void)
{
    Fx f;
    fx_init(&f);
    CHECK(start_sized(&f, 5, 7) == E4R_OK);
    {
        const Cell2 cells[] = {{1, 2}, {2, 2}, {3, 2}, {2, 3}, {2, 4}, {2, 5}};
        put_kind0(&f, cells, 6);
    }
    CHECK(check_at(&f, 2, 2) == E4R_OK);
    CHECK(od16(&f, E4R_O_RUN_ROW_MIN) == 1 && od16(&f, E4R_O_RUN_ROW_MAX) == 3 && od16(&f, E4R_O_RUN_COL_MIN) == 2 &&
          od16(&f, E4R_O_RUN_COL_MAX) == 5);
    CHECK(matched_count(&f, 5, 7) == 6);
    /* Each cell of the cross is marked once; the score counts the shared piece in both runs (3 + 4 pieces + the 4-run bonus). */
    CHECK(od32(&f, E4R_O_SCORE) == 10 * 3 + 10 * 4 + 25);
    /* A piece of another kind equal elsewhere is not marked: kind 4 elsewhere in the same row/column stays unmatched. */
    fx_init(&f);
    CHECK(start_sized(&f, 5, 7) == E4R_OK);
    {
        const Cell2 cells[] = {{2, 1}, {2, 2}, {2, 3}, {2, 5}, {0, 2}, {4, 2}};
        put_kind0(&f, cells, 6);
    }
    CHECK(check_at(&f, 2, 2) == E4R_OK && matched_count(&f, 5, 7) == 3 && f.o.b[CELL(2, 5) + 1] == 0 && f.o.b[CELL(0, 2) + 1] == 0 &&
          f.o.b[CELL(4, 2) + 1] == 0);
    /* The checked piece's kind decides the name: kind 4 gives "piece4". */
    fx_init(&f);
    CHECK(start_sized(&f, 5, 7) == E4R_OK);
    for (int c = 0; c < 3; ++c) set_kind(&f, 1, c, 4);
    CHECK(check_at(&f, 1, 1) == E4R_OK && strcmp(text_of(&f, E4R_O_NAME_TEXT), "piece4") == 0 &&
          memcmp(f.o.b + E4R_O_ICON_RECT, f.body + O_PIECE + 64, 16) == 0);
    /* The second check names its own piece. */
    fx_init(&f);
    CHECK(start_sized(&f, 5, 7) == E4R_OK);
    for (int c = 0; c < 3; ++c) set_kind(&f, 3, c, 5);
    set_kind(&f, 3, 3, 0);
    f.o.b[E4R_O_CHECK_SECOND] = 1;
    set32(&f, E4R_O_SWAP_ROW, 3);
    set32(&f, E4R_O_SWAP_COL, 2);
    CHECK(visit(&f) == E4R_OK && state_of(&f) == E4R_STATE_REFILL && strcmp(text_of(&f, E4R_O_NAME_TEXT), "piece5") == 0 &&
          od32(&f, E4R_O_SCORE) == 30 + 0 && f.o.b[E4R_O_CHECK_SECOND] == 0);
    /* Score arithmetic: a negative per-piece word wraps and the text is the unsigned value. */
    fx_init(&f);
    put16(f.body, O_PER_PIECE, -5);
    CHECK(start_sized(&f, 5, 7) == E4R_OK);
    for (int c = 0; c < 3; ++c) set_kind(&f, 0, c, 0);
    CHECK(check_at(&f, 0, 0) == E4R_OK && od32(&f, E4R_O_SCORE) == -15 && strcmp(text_of(&f, E4R_O_SCORE_TEXT), "4294967281") == 0);
    /* The time bonus words are signed seconds times 1000. */
    fx_init(&f);
    put16(f.body, O_BONUS3_TIME, -3);
    CHECK(start_sized(&f, 5, 7) == E4R_OK);
    for (int c = 0; c < 3; ++c) set_kind(&f, 0, c, 0);
    CHECK(check_at(&f, 0, 0) == E4R_OK && od32(&f, E4R_O_TIME_END) == 61000 - 3000);
    /* A full 10 x 10 board checks without leaving it. */
    fx_init(&f);
    CHECK(start_sized(&f, 10, 10) == E4R_OK);
    for (int r = 7; r < 10; ++r) set_kind(&f, r, 9, 0);
    CHECK(check_at(&f, 9, 9) == E4R_OK && matched_count(&f, 10, 10) == 3 && od16(&f, E4R_O_RUN_ROW_MAX) == 9);
}

/* Every host call of the phase 1 states that make host calls can fail, and each failure ends the visit with a host error. */
static void host_variant(Fx *f, int v)
{
    static const int32_t rs[] = {7, 6, 5, 4, 3, 2, 1, 0, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 9, 8};
    fx_init(f);
    CHECK(start(f) == E4R_OK);
    switch (v) {
    case 0: play_state(f, E4R_STATE_REFILL); set32(f, E4R_O_DEADLINE, 2000); f->now = 1999u; break;
    case 1: play_state(f, E4R_STATE_REFILL); set32(f, E4R_O_DEADLINE, 1000); f->o.b[CELL(0, 1) + 1] = 1; f->o.b[CELL(2, 3) + 1] = 1;
            script(f, rs, 20); break;
    case 2: play_state(f, E4R_STATE_SHUFFLE); f->o.b[E4R_O_SHUFFLE_DOWN] = 1; set32(f, E4R_O_SHUFFLE_END, 999); script(f, rs, 20); break;
    case 3: play_state(f, E4R_STATE_END); break;
    case 4: play_state(f, E4R_STATE_END_SOUND); f->busy_script[0] = 0; f->busy_n = 1; break;
    default: break;
    }
}

static void t_visit_host_failures(void)
{
    Fx f;
    for (int v = 0; v < 5; ++v) {
        int total;
        host_variant(&f, v);
        if (v == 0) f.now = 1999u;
        CHECK(visit(&f) == E4R_OK);
        total = f.calls;
        CHECK(total >= 2);
        for (int n = 1; n <= total; ++n) {
            host_variant(&f, v);
            if (v == 0) f.now = 1999u;
            f.calls = 0;
            f.fail_call = n;
            f.res.phase_after = 77u;
            CHECK(visit(&f) == E4R_ERR_HOST && f.failure != NULL && strcmp(f.failure, "e4-host-failure") == 0);
            CHECK(f.res.phase_after == 1u && f.res.initialized == 0u && f.res.completed == 0u);
        }
    }
    /* A failure with no text pointer is still reported (and a refusal too). */
    host_variant(&f, 3);
    f.calls = 0;
    f.fail_call = 1;
    CHECK(e4r_step(&f.o, f.body, E4R_BODY_BYTES, f.row, 1u, &f.world, &f.host, &f.res, NULL) == E4R_ERR_HOST);
    fx_init(&f);
    CHECK(e4r_step(&f.o, f.body, E4R_BODY_BYTES, f.row, 1u, &f.world, &f.host, &f.res, NULL) == E4R_ERR_UNSUPPORTED); /* no init */
    CHECK(e4r_step(&f.o, f.body, E4R_BODY_BYTES, f.row, 0u, &f.world, &f.host, &f.res, NULL) == E4R_OK);
    {
        const char *why = "left over";
        CHECK(e4r_step(&f.o, f.body, E4R_BODY_BYTES, f.row, 1u, &f.world, &f.host, &f.res, &why) == E4R_OK && why == NULL);
    }
}

/* ---- invalidate (0x4758e8) and cleanup (0x475885 / 0x4757da) ------------------------------------------------------------------ */

static void t_invalidate(void)
{
    Fx f;
    fx_init(&f);
    CHECK(e4r_invalidate(&f.o, &f.host) == E4R_OK && f.n_dirty == 0); /* inactive */
    CHECK(start(&f) == E4R_OK);
    CHECK(e4r_invalidate(&f.o, &f.host) == E4R_OK && f.n_dirty == 1 && f.dirty_slot == 24);
    CHECK_LOG(&f, "dirty:24:0");
    set32(&f, E4R_O_ACTIVE, 0);
    fx_clear(&f);
    CHECK(e4r_invalidate(&f.o, &f.host) == E4R_OK && f.n_dirty == 0);
    set32(&f, E4R_O_ACTIVE, 1);
    put16(f.o.b, E4R_O_SLOT, -1);
    CHECK(e4r_invalidate(&f.o, &f.host) == E4R_OK && f.n_dirty == 0);
    put16(f.o.b, E4R_O_SLOT, 30);
    f.fail_call = 1;
    CHECK(e4r_invalidate(&f.o, &f.host) == E4R_ERR_HOST);
}

static void t_cleanup(void)
{
    Fx f;
    fx_init(&f);
    CHECK(e4r_cleanup(&f.o, &f.host) == E4R_OK && f.log[0] == '\0' && f.calls == 0); /* a power-on object: nothing to release */
    CHECK(start(&f) == E4R_OK);
    set32(&f, E4R_O_SCORE, 321);
    set32(&f, E4R_O_STATE, 5);
    set32(&f, E4R_O_EXIT, 1);
    set32(&f, E4R_O_WON, 1);
    CHECK(e4r_cleanup(&f.o, &f.host) == E4R_OK);
    CHECK_LOG(&f, "relsurf:100:0,relsurf:101:1,relslot:24:0");
    CHECK(od16(&f, E4R_O_ROW) == -1 && od16(&f, E4R_O_SLOT) == -1 && od32(&f, E4R_O_ACTIVE) == 0 && od32(&f, E4R_O_EXIT) == 0 &&
          od32(&f, E4R_O_WON) == 0 && od32(&f, E4R_O_SURFACE) == 0 && od32(&f, E4R_O_SCORE_SURFACE) == 0);
    for (size_t i = 0; i < 2000u; ++i) CHECK(f.o.b[E4R_O_CELLS + i] == 0); /* the ten rows of cells are cleared */
    CHECK(od32(&f, E4R_O_SCORE) == 321 && od32(&f, E4R_O_STATE) == 5); /* 0x4757da leaves the rest alone */
    fx_clear(&f);
    CHECK(e4r_cleanup(&f.o, &f.host) == E4R_OK && f.log[0] == '\0'); /* idempotent */
    /* No score surface: one release. */
    fx_init(&f);
    f.body[O_SCORE_NAME] = 0;
    CHECK(start(&f) == E4R_OK);
    CHECK(e4r_cleanup(&f.o, &f.host) == E4R_OK);
    CHECK_LOG(&f, "relsurf:100:0,relslot:24:0");
    /* A failing release leaves the rest of the object as it was. */
    for (int n = 1; n <= 3; ++n) {
        fx_init(&f);
        CHECK(start(&f) == E4R_OK);
        f.fail_call = n;
        CHECK(e4r_cleanup(&f.o, &f.host) == E4R_ERR_HOST);
        CHECK(od32(&f, E4R_O_ACTIVE) == 1 && od16(&f, E4R_O_ROW) == 2);
        CHECK((n == 1) == (od32(&f, E4R_O_SURFACE) == 100));
        CHECK((n <= 2) == (od32(&f, E4R_O_SCORE_SURFACE) == 101));
        CHECK(od16(&f, E4R_O_SLOT) == 24);
    }
}

/* ---- render (0x4778df, text helper 0x475cc4) ---------------------------------------------------------------------------------- */

static int render(Fx *f, E4rRenderResult *r)
{
    return f->rc = e4r_render(&f->o, f->body, E4R_BODY_BYTES, &f->world, &f->host, r);
}

static int is_blit(const E4rOp *op, int label, int role, int32_t s0, int32_t s1, int32_t s2, int32_t s3, int32_t d0, int32_t d1,
                   int32_t d2, int32_t d3)
{
    /* The text fields of a blit are clear (a reused result must not keep an earlier text op's bytes). */
    for (size_t i = 0; i < sizeof op->text; ++i)
        if (op->text[i] != 0) return 0;
    return op->kind == E4R_OP_BLIT && op->label == label && op->surface_role == role && op->src[0] == s0 && op->src[1] == s1 &&
           op->src[2] == s2 && op->src[3] == s3 && op->dst[0] == d0 && op->dst[1] == d1 && op->dst[2] == d2 && op->dst[3] == d3 &&
           op->font == 0 && op->param == 0 && op->x == 0 && op->y == 0;
}
static int is_text(const E4rOp *op, const char *text, int x, int y)
{
    /* Everything after the text's terminator is clear, and the blit fields of a text op are clear. */
    for (size_t i = strlen(text) + 1u; i < sizeof op->text; ++i)
        if (op->text[i] != 0) return 0;
    return op->kind == E4R_OP_TEXT && strcmp(op->text, text) == 0 && op->x == x && op->y == y && op->font == 3 && op->param == 7 &&
           op->label == 0 && op->surface_role == 0 && op->src[0] == 0 && op->src[3] == 0 && op->dst[0] == 0 && op->dst[3] == 0;
}
/* Board blits of the fixed board A: the piece rectangle of the kind, the cell rectangle. */
static int is_piece(const E4rOp *op, int r, int c, int kind)
{
    return is_blit(op, E4R_LABEL_PIECE, E4R_SURFACE_PUZZLE, 10 * kind, 50, 10 * kind + 8, 59, 30 + 11 * c, 50 + 11 * r,
                   38 + 11 * c, 59 + 11 * r);
}

/* ---- gaps found by the source-mutation sweep ---------------------------------------------------------------------------------- */

/* Phase 0 sets every field itself: run it over an object full of leftovers, with values that need all four bytes. */
static void t_phase0_over_leftovers(void)
{
    Fx f;
    fx_init(&f);
    memset(f.o.b, 0xa5, sizeof f.o.b);
    set32(&f, E4R_O_ACTIVE, 0);
    set32(&f, E4R_O_SURFACE, 0);
    set32(&f, E4R_O_SCORE_SURFACE, 0);
    f.row = 0x0180;                 /* bit 7 differs from bit 8: both bytes of the word are needed */
    f.now = 0x01800000u - 60000u;   /* the countdown end is 0x01800000: bit 23 differs from bit 24 */
    put32(f.body, O_TARGET, 0x12345678);
    CHECK(step(&f, 0u) == E4R_OK);
    CHECK(od16(&f, E4R_O_ROW) == 0x0180 && od32(&f, E4R_O_TIME_END) == 0x01800000);
    CHECK(strcmp(text_of(&f, E4R_O_TARGET_TEXT), "305419896") == 0);
    CHECK(f.o.b[E4R_O_CHECK_FIRST] == 0 && f.o.b[E4R_O_CHECK_SECOND] == 0 && f.o.b[E4R_O_SHOW_NAME] == 0);
    CHECK(f.o.b[E4R_O_NAME_DIRTY] == 1 && f.o.b[E4R_O_SCORE_DIRTY] == 0 && f.o.b[E4R_O_ERASE_ALL] == 0);
    CHECK(f.o.b[E4R_O_MATCH_COL] == 0 && f.o.b[E4R_O_MATCH_ROW] == 0 && f.o.b[E4R_O_SHUFFLE_DOWN] == 0 &&
          f.o.b[E4R_O_SHUFFLE_DIRTY] == 0);
    CHECK(od32(&f, E4R_O_SCORE) == 0 && od32(&f, E4R_O_STATE) == 0 && od32(&f, E4R_O_WON) == 0 && od32(&f, E4R_O_EXIT) == 0);
    CHECK(strcmp(text_of(&f, E4R_O_SCORE_TEXT), "0") == 0 && text_of(&f, E4R_O_TIME_TEXT)[0] == '\0' &&
          text_of(&f, E4R_O_NAME_TEXT)[0] == '\0');
    /* A leftover longer text is replaced up to its terminator (the old bytes after it do not matter, but the text is exact). */
    CHECK(text_of(&f, E4R_O_SCORE_TEXT)[1] == '\0');
}

/* A piece kind outside the body is refused wherever it sits: the first cell is checked like every other. */
static void t_kind_outside_first_cell(void)
{
    Fx f;
    E4rRenderResult *r = (E4rRenderResult *)calloc(1u, sizeof *r);
    CHECK(r != NULL);
    if (r == NULL) return;
    for (int cell = 0; cell < 2; ++cell) {
        const int rr = cell == 0 ? 0 : 2, cc = cell == 0 ? 0 : 3;
        fx_init(&f);
        CHECK(start(&f) == E4R_OK);
        set_kind(&f, rr, cc, 9);
        CHECK(visit(&f) == E4R_ERR_UNSUPPORTED && strcmp(f.failure, "e4-piece-kind-outside-body") == 0);
        CHECK(render(&f, r) == E4R_ERR_BOUNDS && r->valid == 0u && r->count == 0u);
        set_kind(&f, rr, cc, -1);
        CHECK(visit(&f) == E4R_ERR_UNSUPPORTED);
        CHECK(render(&f, r) == E4R_ERR_BOUNDS);
    }
    free(r);
}

/* A board of ten columns: the pointer finds the first cell of the second row, not a phantom eleventh cell of the first. */
static void t_full_width_board(void)
{
    Fx f;
    E4rPointerResult p;
    fx_init(&f);
    CHECK(start_sized(&f, 10, 10) == E4R_OK);
    CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 30 + 4, 50 + 11 + 4, &p) == E4R_OK && p.hit == 1u);
    CHECK(od32(&f, E4R_O_HOVER_ROW) == 1 && od32(&f, E4R_O_HOVER_COL) == 0);
    CHECK(e4r_pointer(&f.o, f.body, E4R_BODY_BYTES, 30 + 11 * 9 + 4, 50 + 4, &p) == E4R_OK && p.hit == 1u);
    CHECK(od32(&f, E4R_O_HOVER_ROW) == 0 && od32(&f, E4R_O_HOVER_COL) == 9);
}

/* The refill finds a matched piece in the first row and the first column. */
static void t_refill_first_cell(void)
{
    static const int32_t rs[] = {7, 6};
    Fx f;
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    play_state(&f, E4R_STATE_REFILL);
    set32(&f, E4R_O_DEADLINE, 1000);
    f.o.b[CELL(0, 0) + 1] = 1;
    f.o.b[CELL(1, 0) + 1] = 1;
    script(&f, rs, 2);
    CHECK(visit(&f) == E4R_OK && state_of(&f) == 0);
    CHECK(f.o.b[CELL(0, 0) + 1] == 0 && f.o.b[CELL(1, 0) + 1] == 0 && f.rand_i == 2);
    CHECK(kind_at(&f, 0, 0) == 7 % 4);       /* kinds - 1 = 4 */
    CHECK(kind_at(&f, 1, 0) == 6 % 4 && kind_at(&f, 1, 0) != kind_at(&f, 0, 0));
}

/* More gaps found by the sweep: values that differ only in a corner the other cases never reach. */
static void t_more_gaps(void)
{
    Fx f;
    E4rRenderResult *r = (E4rRenderResult *)calloc(1u, sizeof *r);
    CHECK(r != NULL);
    if (r == NULL) return;
    /* The piece width and height come from piece 0's rectangle (right - left, bottom - top), whatever its origin. */
    fx_init(&f);
    put_rect(f.body, O_PIECE, 3, 55, 11, 64);
    CHECK(start(&f) == E4R_OK);
    CHECK(od32(&f, CELL(0, 0) + 4) == 30 && od32(&f, CELL(0, 0) + 12) == 38 && od32(&f, CELL(0, 3) + 4) == 63 &&
          od32(&f, CELL(2, 0) + 8) == 72 && od32(&f, CELL(2, 0) + 16) == 81);
    /* The countdown: a limit of one second, and a limit of zero never times out. */
    fx_init(&f);
    put16(f.body, O_TIME_LIMIT, 1);
    CHECK(start(&f) == E4R_OK);
    f.now = 1000u + 1000u - 400u;
    CHECK(visit(&f) == E4R_OK && state_of(&f) == E4R_STATE_END);
    fx_init(&f);
    put16(f.body, O_TIME_LIMIT, 0);
    CHECK(start(&f) == E4R_OK);
    f.now = 1000u; /* left == 0 */
    CHECK(visit(&f) == E4R_OK && state_of(&f) == 0);
    /* The score screen restart with a score that does not enter the table: the screen is erased, the texts are reset. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    play_state(&f, E4R_STATE_SCORES);
    set32(&f, E4R_O_DEADLINE, 1000);
    set32(&f, E4R_O_SCORE, 0);
    put_text(f.o.b, E4R_O_SCORE_TEXT, "123");
    put_text(f.o.b, E4R_O_TIME_TEXT, "TIME!");
    CHECK(visit(&f) == E4R_OK && state_of(&f) == 0 && f.o.b[E4R_O_ERASE_ALL] == 1);
    CHECK(strcmp(text_of(&f, E4R_O_SCORE_TEXT), "0") == 0 && text_of(&f, E4R_O_TIME_TEXT)[0] == '\0');
    /* The match flags are cleared by every check, matched or not; the name text is replaced, not overlaid. */
    fx_init(&f);
    CHECK(start_sized(&f, 5, 7) == E4R_OK);
    f.o.b[E4R_O_MATCH_COL] = 1;
    f.o.b[E4R_O_MATCH_ROW] = 1;
    CHECK(check_at(&f, 2, 2) == E4R_OK && f.o.b[E4R_O_MATCH_COL] == 0 && f.o.b[E4R_O_MATCH_ROW] == 0);
    fx_init(&f);
    CHECK(start_sized(&f, 5, 7) == E4R_OK);
    for (int c = 0; c < 3; ++c) set_kind(&f, 0, c, 0);
    put_text(f.o.b, E4R_O_NAME_TEXT, "left over name");
    CHECK(check_at(&f, 0, 0) == E4R_OK && strcmp(text_of(&f, E4R_O_NAME_TEXT), "piece0") == 0);
    /* The icon rectangle is all sixteen bytes of the piece's rectangle. */
    fx_init(&f);
    put_rect(f.body, O_PIECE, 0, 50, 8, 59);
    put32(f.body, O_PIECE + 12, 0x05000009);
    CHECK(start_sized(&f, 5, 7) == E4R_OK);
    for (int c = 0; c < 3; ++c) set_kind(&f, 0, c, 0);
    CHECK(check_at(&f, 0, 0) == E4R_OK && memcmp(f.o.b + E4R_O_ICON_RECT, f.body + O_PIECE, 16) == 0);
    /* The event flag window is queried only when the block is applied (phase 2), for the exit or the win block. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    set32(&f, E4R_O_WON, 1);
    f.event_invalid = 1;
    CHECK(visit(&f) == E4R_OK && f.n_evinvalid == 0);
    fx_init(&f);
    put16(f.body, O_EXIT + 22, 7); /* the exit block names flag 7 */
    CHECK(start(&f) == E4R_OK);
    set32(&f, E4R_O_EXIT, 1);
    f.event_invalid = 1;
    CHECK(step(&f, 2u) == E4R_ERR_BOUNDS && f.n_evinvalid == 1 && f.evinvalid_idx == 7 && strcmp(f.failure, "e4-event-flag-outside-window") == 0);
    fx_clear(&f);
    f.event_invalid = 0;
    CHECK(step(&f, 2u) == E4R_OK && f.n_evinvalid == 1 && f.flag_idx == 7);
    /* The win block applies when the exit was not pressed. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    set32(&f, E4R_O_WON, 1);
    CHECK(step(&f, 2u) == E4R_OK && f.n_evinvalid == 1 && f.flag_idx == 5 && f.tr.scene == 41);
    /* The score screen draws for a limit of one second and not for no limit. */
    fx_init(&f);
    put16(f.body, O_TIME_LIMIT, 1);
    CHECK(start(&f) == E4R_OK);
    play_state(&f, E4R_STATE_SCORES);
    CHECK(render(&f, r) == E4R_OK && r->count == 7u && r->op[0].label == E4R_LABEL_SCORES_BACKDROP);
    free(r);
}

static void t_render_fresh(void)
{
    Fx f;
    E4rRenderResult *r = (E4rRenderResult *)calloc(1u, sizeof *r);
    CHECK(r != NULL);
    if (r == NULL) return;
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    CHECK(render(&f, r) == E4R_OK && r->valid == 1u && r->count == 17u && f.n_view == 1);
    for (int i = 0; i < 12; ++i) CHECK(is_piece(&r->op[i], i / 4, i % 4, BOARD_A[i / 4][i % 4]));
    CHECK(is_blit(&r->op[12], E4R_LABEL_NAME_ERASE, E4R_SURFACE_BACKGROUND, 18, 19, 100, 29, 28, 39, 110, 49));
    CHECK(is_blit(&r->op[13], E4R_LABEL_ICON_ERASE, E4R_SURFACE_BACKGROUND, 20, 21, 110, 31, 30, 41, 120, 51));
    CHECK(is_text(&r->op[14], "0", 24, 45));
    CHECK(is_text(&r->op[15], "Title", 20, 41));
    CHECK(is_text(&r->op[16], "1000", 22, 43));
    CHECK(f.o.b[E4R_O_NAME_DIRTY] == 0);
    CHECK(render(&f, r) == E4R_OK && r->valid == 1u && r->count == 15u); /* the erases are one-shot */
    CHECK(is_text(&r->op[12], "0", 24, 45) && is_text(&r->op[14], "1000", 22, 43));
    /* Matched pieces use the matched source rectangle. */
    f.o.b[CELL(1, 1) + 1] = 1;
    CHECK(render(&f, r) == E4R_OK && r->count == 15u);
    CHECK(is_blit(&r->op[5], E4R_LABEL_MATCHED, E4R_SURFACE_PUZZLE, 300, 60, 308, 69, 41, 61, 49, 70));
    CHECK(is_piece(&r->op[4], 1, 0, 1) && is_piece(&r->op[6], 1, 2, 3));
    /* Absent cells are skipped; the order stays row-major. */
    f.o.b[CELL(0, 2)] = 0;
    CHECK(render(&f, r) == E4R_OK && r->count == 14u && is_piece(&r->op[2], 0, 3, 3));
    f.o.b[CELL(0, 2)] = 1;
    /* The view rectangles are read on every call. */
    f.view[0] = 100; f.view[1] = 200;
    CHECK(render(&f, r) == E4R_OK && f.n_view == 5);
    CHECK(is_text(&r->op[r->count - 3], "0", 114, 225));
    free(r);
}

static void t_render_panels(void)
{
    Fx f;
    E4rRenderResult *r = (E4rRenderResult *)calloc(1u, sizeof *r);
    CHECK(r != NULL);
    if (r == NULL) return;
    /* The erase of the whole view comes first, once. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    f.o.b[E4R_O_ERASE_ALL] = 1;
    CHECK(render(&f, r) == E4R_OK && r->count == 18u);
    CHECK(is_blit(&r->op[0], E4R_LABEL_ERASE_ALL, E4R_SURFACE_BACKGROUND, 5, 6, 7, 8, 10, 20, 629, 384) && is_piece(&r->op[1], 0, 0, 0));
    CHECK(f.o.b[E4R_O_ERASE_ALL] == 0);
    CHECK(render(&f, r) == E4R_OK && r->count == 15u);
    /* Piece name panel: shown name and icon. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    f.o.b[E4R_O_SHOW_NAME] = 1;
    put_text(f.o.b, E4R_O_NAME_TEXT, "Glyph");
    put_rect(f.o.b, E4R_O_ICON_RECT, 70, 71, 79, 80);
    CHECK(render(&f, r) == E4R_OK && r->count == 17u);
    CHECK(is_text(&r->op[12], "Glyph", 28, 49));
    CHECK(is_blit(&r->op[13], E4R_LABEL_NAME_ICON, E4R_SURFACE_PUZZLE, 70, 71, 79, 80, 30, 41, 120, 51));
    CHECK(f.o.b[E4R_O_NAME_DIRTY] == 1); /* untouched while the name is shown */
    f.o.b[E4R_O_NAME_TEXT] = 0;
    CHECK(render(&f, r) == E4R_OK && r->count == 16u && r->op[12].kind == E4R_OP_BLIT && r->op[12].label == E4R_LABEL_NAME_ICON);
    /* Panel disabled: no name ops and no dirty handling. */
    fx_init(&f);
    f.body[O_NAME_PANEL] = 0;
    CHECK(start(&f) == E4R_OK);
    CHECK(render(&f, r) == E4R_OK && r->count == 15u && f.o.b[E4R_O_NAME_DIRTY] == 1);
    f.o.b[E4R_O_SHOW_NAME] = 1;
    put_text(f.o.b, E4R_O_NAME_TEXT, "Glyph");
    CHECK(render(&f, r) == E4R_OK && r->count == 15u);
    /* Score panel: dirty erase then the text; panel disabled: nothing. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    CHECK(render(&f, r) == E4R_OK);
    f.o.b[E4R_O_SCORE_DIRTY] = 1;
    put_text(f.o.b, E4R_O_SCORE_TEXT, "250");
    CHECK(render(&f, r) == E4R_OK && r->count == 16u);
    CHECK(is_blit(&r->op[12], E4R_LABEL_SCORE_ERASE, E4R_SURFACE_BACKGROUND, 14, 15, 80, 25, 24, 35, 90, 45));
    CHECK(is_text(&r->op[13], "250", 24, 45) && f.o.b[E4R_O_SCORE_DIRTY] == 0);
    f.o.b[E4R_O_SCORE_TEXT] = 0;
    CHECK(render(&f, r) == E4R_OK && r->count == 14u);
    fx_init(&f);
    f.body[O_SCORE_PANEL] = 0;
    CHECK(start(&f) == E4R_OK);
    f.o.b[E4R_O_SCORE_DIRTY] = 1;
    CHECK(render(&f, r) == E4R_OK && r->count == 16u && f.o.b[E4R_O_SCORE_DIRTY] == 1);
    /* Time text: erase then text. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    CHECK(render(&f, r) == E4R_OK);
    put_text(f.o.b, E4R_O_TIME_TEXT, " 1m  0s");
    CHECK(render(&f, r) == E4R_OK && r->count == 17u);
    CHECK(is_blit(&r->op[13], E4R_LABEL_TIME_ERASE, E4R_SURFACE_BACKGROUND, 16, 17, 90, 27, 26, 37, 100, 47));
    CHECK(is_text(&r->op[14], " 1m  0s", 26, 47));
    /* The shuffle button: pressed graphic, then the one-shot restore. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    CHECK(render(&f, r) == E4R_OK);
    f.o.b[E4R_O_SHUFFLE_DOWN] = 1;
    f.o.b[E4R_O_SHUFFLE_DIRTY] = 1;
    CHECK(render(&f, r) == E4R_OK && r->count == 16u);
    CHECK(is_blit(&r->op[13], E4R_LABEL_SHUFFLE_DOWN, E4R_SURFACE_PUZZLE, 500, 10, 540, 30, 410, 320, 460, 350));
    CHECK(f.o.b[E4R_O_SHUFFLE_DIRTY] == 1);
    f.o.b[E4R_O_SHUFFLE_DOWN] = 0;
    CHECK(render(&f, r) == E4R_OK && r->count == 16u);
    CHECK(is_blit(&r->op[13], E4R_LABEL_SHUFFLE_ERASE, E4R_SURFACE_BACKGROUND, 400, 300, 450, 330, 410, 320, 460, 350));
    CHECK(f.o.b[E4R_O_SHUFFLE_DIRTY] == 0);
    CHECK(render(&f, r) == E4R_OK && r->count == 15u);
    /* Title and target text are optional. */
    fx_init(&f);
    f.body[O_TITLE] = 0;
    CHECK(start(&f) == E4R_OK);
    CHECK(render(&f, r) == E4R_OK && r->count == 16u && is_text(&r->op[15], "1000", 22, 43));
    f.o.b[E4R_O_TARGET_TEXT] = 0;
    CHECK(render(&f, r) == E4R_OK && r->count == 13u);
    /* Text positions are the rectangle corner plus the view origin, truncated to words. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    f.view[0] = 70000;
    f.view[1] = -70000;
    CHECK(render(&f, r) == E4R_OK);
    CHECK(r->op[r->count - 1].kind == E4R_OP_TEXT && r->op[r->count - 1].x == (int16_t)(12 + 70000) &&
          r->op[r->count - 1].y == (int16_t)(23 - 70000));
    /* A full 10 x 10 board with every optional part stays inside the op table. */
    fx_init(&f);
    put16(f.body, O_ROWS, 10);
    put16(f.body, O_COLS, 10);
    CHECK(step(&f, 0u) == E4R_OK);
    f.o.b[E4R_O_ERASE_ALL] = 1;
    f.o.b[E4R_O_SCORE_DIRTY] = 1;
    f.o.b[E4R_O_SHUFFLE_DIRTY] = 1;
    put_text(f.o.b, E4R_O_TIME_TEXT, "TIME!");
    CHECK(render(&f, r) == E4R_OK && r->count == 100u + 1u + 2u + 2u + 2u + 1u + 1u + 1u && r->count <= E4R_MAX_OPS);
    free(r);
}

static void t_render_scores(void)
{
    Fx f;
    E4rRenderResult *r = (E4rRenderResult *)calloc(1u, sizeof *r);
    CHECK(r != NULL);
    if (r == NULL) return;
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    play_state(&f, E4R_STATE_SCORES);
    for (int i = 0; i < 5; ++i) f.world.high_score[i] = 900 - 100 * i;
    put_text(f.o.b, E4R_O_SCORE_TEXT, "345");
    f.o.b[E4R_O_ERASE_ALL] = 1;
    CHECK(render(&f, r) == E4R_OK && r->valid == 1u && r->count == 8u);
    CHECK(is_blit(&r->op[0], E4R_LABEL_ERASE_ALL, E4R_SURFACE_BACKGROUND, 5, 6, 7, 8, 10, 20, 629, 384));
    CHECK(is_blit(&r->op[1], E4R_LABEL_SCORES_BACKDROP, E4R_SURFACE_SCORE, 5, 6, 7, 8, 10, 20, 629, 384));
    CHECK(f.n_textext == 1 && strstr(f.log, "textext:3:12") != NULL);
    /* step = height 12 + 13 = 25. The score text: bottom = Y0 - 6 + view_y + step = 139, then the view origin is added again. */
    CHECK(is_text(&r->op[2], "345", 220, 159));
    /* The high scores: bottom of the first = Y1 - 16 + view_y + step + step = 174, spacing 25, left X1 + view_x. */
    CHECK(is_text(&r->op[3], "900", 320, 194) && is_text(&r->op[4], "800", 320, 219) && is_text(&r->op[5], "700", 320, 244));
    CHECK(is_text(&r->op[6], "600", 320, 269) && is_text(&r->op[7], "500", 320, 294));
    CHECK(f.o.b[E4R_O_ERASE_ALL] == 0);
    /* Zeros are drawn (a non-empty "0"); an empty score text is not drawn. */
    memset(&f.world, 0, sizeof f.world);
    f.o.b[E4R_O_SCORE_TEXT] = 0;
    CHECK(render(&f, r) == E4R_OK && r->count == 6u && is_text(&r->op[1], "0", 320, 194));
    /* A different text height moves the lines. */
    f.text_height = 20;
    CHECK(render(&f, r) == E4R_OK && r->count == 6u && is_text(&r->op[1], "0", 320, 210) && is_text(&r->op[2], "0", 320, 243));
    /* Time limit 0: no score screen, only the erase. */
    fx_init(&f);
    put16(f.body, O_TIME_LIMIT, 0);
    CHECK(start(&f) == E4R_OK);
    play_state(&f, E4R_STATE_SCORES);
    f.o.b[E4R_O_ERASE_ALL] = 1;
    CHECK(render(&f, r) == E4R_OK && r->valid == 1u && r->count == 1u && r->op[0].label == E4R_LABEL_ERASE_ALL && f.n_textext == 0);
    CHECK(render(&f, r) == E4R_OK && r->valid == 1u && r->count == 0u);
    /* Negative limit: the screen is not shown either (the test is limit > 0). */
    put16(f.body, O_TIME_LIMIT, -3);
    CHECK(render(&f, r) == E4R_OK && r->count == 0u);
    /* Piece kinds are not examined on the score screen; the board is not drawn. */
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    play_state(&f, E4R_STATE_SCORES);
    set_kind(&f, 0, 0, 77);
    CHECK(render(&f, r) == E4R_OK && r->count == 7u);
    /* Failing text measure or view. */
    f.calls = 0;
    f.fail_call = 1;
    CHECK(render(&f, r) == E4R_ERR_HOST); /* the view */
    f.calls = 0;
    f.fail_call = 2;
    CHECK(render(&f, r) == E4R_ERR_HOST); /* the text measure */
    free(r);
}

static void t_render_refusals(void)
{
    Fx f;
    E4rRenderResult *r = (E4rRenderResult *)calloc(1u, sizeof *r);
    CHECK(r != NULL);
    if (r == NULL) return;
    /* No row or no render entry: the callback does nothing. */
    fx_init(&f);
    r->valid = 1;
    r->count = 9;
    CHECK(render(&f, r) == E4R_OK && r->valid == 0u && r->count == 0u && f.n_view == 0);
    CHECK(start(&f) == E4R_OK);
    put16(f.o.b, E4R_O_SLOT, -1);
    CHECK(render(&f, r) == E4R_OK && r->valid == 0u && f.n_view == 0);
    put16(f.o.b, E4R_O_SLOT, 24);
    put16(f.o.b, E4R_O_ROW, -1);
    CHECK(render(&f, r) == E4R_OK && r->valid == 0u);
    put16(f.o.b, E4R_O_ROW, 0);
    CHECK(render(&f, r) == E4R_OK && r->valid == 1u); /* row 0 is a row */
    /* A present, unmatched piece with a kind outside the body is refused before any change. */
    for (int bad = 0; bad < 3; ++bad) {
        fx_init(&f);
        CHECK(start(&f) == E4R_OK);
        set_kind(&f, 1, 2, bad == 0 ? 5 : (bad == 1 ? -1 : 30000));
        r->valid = 1;
        CHECK(render(&f, r) == E4R_ERR_BOUNDS && r->valid == 0u && r->count == 0u);
        CHECK(f.o.b[E4R_O_NAME_DIRTY] == 1 && f.n_view == 0);
        f.o.b[CELL(1, 2) + 1] = 1; /* matched pieces are drawn from the matched source and need no valid kind */
        CHECK(render(&f, r) == E4R_OK);
        f.o.b[CELL(1, 2) + 1] = 0;
        f.o.b[CELL(1, 2)] = 0; /* an absent cell is skipped */
        CHECK(render(&f, r) == E4R_OK);
    }
    fx_init(&f);
    CHECK(start(&f) == E4R_OK);
    set_kind(&f, 0, 0, 4);
    CHECK(render(&f, r) == E4R_OK); /* kinds - 1 is a valid index */
    f.calls = 0;
    f.fail_call = 1;
    CHECK(render(&f, r) == E4R_ERR_HOST && r->valid == 0u);
    free(r);
}

/* ---- the session binding (src/session_bindings_ae4.c) over a synthetic scene ------------------------------------------------- */

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
    uint8_t tsum[126], act[48 + 2 + E4R_BODY_BYTES];
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

static int g_stores, g_store_start, g_hook_bad;
static void h_store_world(void *c, const E4rWorld *w)
{
    if (c == NULL) ++g_hook_bad;
    ++g_stores;
    g_store_start = w->start_flag_5bb1ca;
}

typedef struct Bind {
    Fx f;
    SessionAe4Host host;
    SessionAe4Binding *b;
    SceneResource *scene;
    uint8_t bytes[16384];
    uint8_t bytes_before[16384];
    size_t bytes_len;
    uint8_t body_a[E4R_BODY_BYTES], body_b[E4R_BODY_BYTES];
} Bind;

static int bind_open(Bind *x, int hooks)
{
    const int types[3] = {0x70, 0xe4, 0xe4};
    const uint8_t one = 0;
    const uint8_t *bodies[3];
    size_t lengths[3] = {1, E4R_BODY_BYTES, E4R_BODY_BYTES};
    char err[128] = {0};
    fx_init(&x->f);
    g_stores = g_hook_bad = 0;
    g_store_start = -1;
    memcpy(x->body_a, x->f.body, E4R_BODY_BYTES);
    memcpy(x->body_b, x->f.body, E4R_BODY_BYTES);
    put_rect(x->body_b, O_EXIT_RECT, 500, 410, 540, 440); /* row 2: the exit button elsewhere */
    set_block(x->body_b, O_EXIT, 77, 1, 2, 3, 4, 5, 6, 0, 3, 8);
    bodies[0] = &one;
    bodies[1] = x->body_a;
    bodies[2] = x->body_b;
    x->bytes_len = build_scene(x->bytes, 3, types, bodies, lengths);
    memcpy(x->bytes_before, x->bytes, x->bytes_len);
    x->scene = scene_resource_open_memory(x->bytes, x->bytes_len, err, sizeof err);
    if (x->scene == NULL) return 0;
    memset(&x->host, 0, sizeof x->host);
    x->host.kernel = x->f.host;
    x->host.kernel.context = &x->f;
    if (hooks) x->host.store_world = h_store_world;
    x->b = session_ae4_create(&x->host);
    return x->b != NULL;
}

static void bind_close(Bind *x)
{
    session_ae4_destroy(x->b);
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
        const int rc = session_ae4_handler(x->b, row, &info, &st, &out);
        if (rc == SCENE_ACTION_HANDLER_OK) {
            *phase_after = out.phase;
            *completed = out.disposition == SCENE_ACTION_HANDLER_COMPLETED;
            if (out.disposition != SCENE_ACTION_HANDLER_COMPLETED && out.disposition != SCENE_ACTION_HANDLER_PENDING) return -2;
        }
        return rc;
    }
}

static void t_binding_flow(void)
{
    Bind x;
    uint32_t ph = 99u;
    int done = -1;
    E4rPointerResult p;
    E4rClickResult c;
    E4rRenderResult *r = (E4rRenderResult *)calloc(1u, sizeof *r);
    SceneActionInfo info, other;
    SceneActionRuntimeState st;
    SceneActionHandlerResult out;
    CHECK(r != NULL);
    if (r == NULL) return;
    if (!bind_open(&x, 1)) {
        CHECK(0 && "scene opens");
        free(r);
        return;
    }
    CHECK(strcmp(session_ae4_failure(x.b), "none") == 0); /* fresh */
    CHECK(session_ae4_begin_scene(x.b, x.scene) == E4R_OK && strcmp(session_ae4_failure(x.b), "none") == 0);
    CHECK(session_ae4_registered(x.b) == 0u && e4r_rd32(session_ae4_state(x.b), E4R_O_ACTIVE) == 0 &&
          e4r_rd16(session_ae4_state(x.b), E4R_O_ROW) == -1);
    for (int i = 0; i < 5; ++i) CHECK(session_ae4_world(x.b)->high_score[i] == 0);
    /* Nothing is registered: pointer, click, render and invalidate do nothing. */
    memset(&p, 0x55, sizeof p);
    CHECK(session_ae4_pointer_move(x.b, 34, 54, &p) == E4R_OK && p.hit == 0u && p.candidate == -1 && p.cursor_written == 0u);
    memset(&c, 0x55, sizeof c);
    CHECK(session_ae4_click(x.b, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_OK && c.fired == 0u && c.phase_changed == 0u && c.phase == 0u);
    r->valid = 1;
    r->count = 5;
    CHECK(session_ae4_render(x.b, r) == E4R_OK && r->valid == 0u && r->count == 0u);
    CHECK(session_ae4_invalidate(x.b) == E4R_OK && x.f.n_dirty == 0);
    /* Row ownership. */
    memset(&st, 0, sizeof st);
    CHECK(scene_resource_action_at(x.scene, 0, &info) == SCENE_RESOURCE_OK);
    CHECK(session_ae4_handler(x.b, 0, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(strcmp(session_ae4_failure(x.b), "0xe4-row-not-owned") == 0);
    CHECK(scene_resource_action_at(x.scene, 1, &info) == SCENE_RESOURCE_OK);
    CHECK(session_ae4_handler(x.b, 7, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_ae4_handler(x.b, 3, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR); /* one past the last row */
    CHECK(scene_resource_action_at(x.scene, 0, &other) == SCENE_RESOURCE_OK);
    CHECK(session_ae4_handler(x.b, 1, &other, &st, &out) == SCENE_ACTION_HANDLER_ERROR); /* foreign type at our index */
    CHECK(session_ae4_handler(x.b, 0, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);  /* our type at a foreign index */
    CHECK(strcmp(session_ae4_failure(x.b), "0xe4-row-not-owned") == 0);
    CHECK(session_ae4_handler(x.b, 1, NULL, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_ae4_handler(x.b, 1, &info, NULL, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_ae4_handler(x.b, 1, &info, &st, NULL) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_ae4_handler(NULL, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
    /* Phase 1 before phase 0 is refused as unsupported. */
    st.phase = 1u;
    CHECK(session_ae4_handler(x.b, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CHECK(strcmp(session_ae4_failure(x.b), "e4-phase-without-init") == 0);
    /* Phase 0: pending in phase 1, the start flag published. */
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u && done == 0 && strcmp(session_ae4_failure(x.b), "none") == 0);
    CHECK(g_stores == 1 && g_store_start == 1 && g_hook_bad == 0);
    CHECK(session_ae4_registered(x.b) == 1u && e4r_rd32(session_ae4_state(x.b), E4R_O_ACTIVE) == 1 && e4r_rd16(session_ae4_state(x.b), E4R_O_ROW) == 1);
    CHECK(session_ae4_render(x.b, r) == E4R_OK && r->valid == 1u && r->count > 12u);
    CHECK(session_ae4_invalidate(x.b) == E4R_OK && x.f.n_dirty == 1 && x.f.dirty_slot == 24);
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u && done == 0 && g_stores == 1);
    /* Pointer and clicks through the binding: select and swap two pieces. */
    CHECK(session_ae4_pointer_move(x.b, 34, 54, &p) == E4R_OK && p.hit == 1u && p.candidate == E4R_CANDIDATE_PIECE);
    CHECK(session_ae4_click(x.b, 2u, E4R_CANDIDATE_PIECE, &c) == E4R_OK && c.fired == 0u); /* row phase 2: guard */
    CHECK(session_ae4_click(x.b, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_OK && c.fired == 1u);
    CHECK(session_ae4_pointer_move(x.b, 45, 65, &p) == E4R_OK && p.hit == 1u);
    CHECK(session_ae4_click(x.b, 1u, E4R_CANDIDATE_PIECE, &c) == E4R_OK && c.fired == 1u && c.phase_changed == 0u);
    CHECK(session_ae4_state(x.b)->b[E4R_O_CHECK_FIRST] == 1);
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK && session_ae4_state(x.b)->b[E4R_O_CHECK_FIRST] == 0);
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK && session_ae4_state(x.b)->b[E4R_O_CHECK_SECOND] == 0);
    /* The exit button: the click reports the phase change and the next visit finishes. */
    CHECK(session_ae4_pointer_move(x.b, 620, 415, &p) == E4R_OK && p.hit == 1u && p.candidate == E4R_CANDIDATE_EXIT);
    CHECK(session_ae4_click(x.b, 1u, E4R_CANDIDATE_EXIT, &c) == E4R_OK && c.fired == 1u && c.phase_changed == 1u && c.phase == 2u);
    CHECK(session_ae4_click(x.b, 1u, E4R_CANDIDATE_EXIT, NULL) == E4R_ERR_ARGUMENT);
    CHECK(b_visit(&x, 1, 2u, &ph, &done) == SCENE_ACTION_HANDLER_OK && done == 1 && ph == 2u && g_stores == 2 && g_store_start == 0 + 1);
    CHECK(x.f.n_tr == 1 && x.f.tr.scene == 42 && session_ae4_registered(x.b) == 0u && e4r_rd32(session_ae4_state(x.b), E4R_O_ACTIVE) == 0);
    CHECK(x.f.n_relslot == 1 && x.f.n_relsurf == 2);
    CHECK(memcmp(x.bytes, x.bytes_before, x.bytes_len) == 0); /* the scene bytes are never written */
    /* Failures: a host error is a handler error with its text; the click and pointer text names the call. */
    CHECK(session_ae4_begin_scene(x.b, x.scene) == E4R_OK);
    x.f.calls = 0;
    x.f.fail_call = 1; /* the ambient stop */
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_ERROR && strcmp(session_ae4_failure(x.b), "e4-host-failure") == 0);
    x.f.fail_call = 0;
    CHECK(session_ae4_begin_scene(x.b, x.scene) == E4R_OK);
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    CHECK(session_ae4_pointer_move(x.b, 425, 315, &p) == E4R_OK && p.candidate == E4R_CANDIDATE_SHUFFLE);
    x.f.calls = 0;
    x.f.fail_call = 1; /* the sound busy query */
    CHECK(session_ae4_click(x.b, 1u, E4R_CANDIDATE_SHUFFLE, &c) == E4R_ERR_HOST && strcmp(session_ae4_failure(x.b), "0xe4-click") == 0);
    x.f.fail_call = 0;
    CHECK(session_ae4_click(x.b, 1u, E4R_CANDIDATE_SHUFFLE, &c) == E4R_OK && strcmp(session_ae4_failure(x.b), "none") == 0);
    x.f.calls = 0;
    x.f.fail_call = 1;
    CHECK(session_ae4_render(x.b, r) == E4R_ERR_HOST && strcmp(session_ae4_failure(x.b), "0xe4-render") == 0);
    x.f.fail_call = 0;
    CHECK(session_ae4_pointer_move(x.b, 425, 315, &p) == E4R_OK && strcmp(session_ae4_failure(x.b), "none") == 0); /* clears the text */
    /* NULL arguments and the unbound text. */
    CHECK(session_ae4_pointer_move(NULL, 1, 1, &p) == E4R_ERR_ARGUMENT && session_ae4_pointer_move(x.b, 1, 1, NULL) == E4R_ERR_ARGUMENT);
    CHECK(session_ae4_click(NULL, 1u, 0, &c) == E4R_ERR_ARGUMENT);
    CHECK(session_ae4_render(NULL, r) == E4R_ERR_ARGUMENT && session_ae4_render(x.b, NULL) == E4R_ERR_ARGUMENT);
    CHECK(session_ae4_invalidate(NULL) == E4R_ERR_ARGUMENT);
    CHECK(session_ae4_registered(NULL) == 0u && session_ae4_state(NULL) == NULL && session_ae4_world(NULL) == NULL);
    CHECK(strcmp(session_ae4_failure(NULL), "0xe4-binding-unbound") == 0);
    CHECK(session_ae4_begin_scene(NULL, x.scene) == E4R_ERR_ARGUMENT && session_ae4_begin_scene(x.b, NULL) == E4R_ERR_ARGUMENT);
    CHECK(session_ae4_create(NULL) == NULL);
    session_ae4_destroy(NULL);
    bind_close(&x);
    free(r);
}

static void t_binding_second_row_and_scene_change(void)
{
    Bind x;
    uint32_t ph = 99u;
    int done = -1;
    E4rPointerResult p;
    if (!bind_open(&x, 0)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_ae4_begin_scene(x.b, x.scene) == E4R_OK);
    /* Row 2 runs its own body: the exit button lies elsewhere and the finish block names scene 77. */
    CHECK(b_visit(&x, 2, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && e4r_rd16(session_ae4_state(x.b), E4R_O_ROW) == 2);
    CHECK(session_ae4_pointer_move(x.b, 620, 415, &p) == E4R_OK && p.hit == 0u);
    CHECK(session_ae4_pointer_move(x.b, 520, 425, &p) == E4R_OK && p.hit == 1u && p.candidate == E4R_CANDIDATE_EXIT);
    {
        E4rObject *o = (E4rObject *)session_ae4_state(x.b);
        E4rClickResult c;
        CHECK(session_ae4_click(x.b, 1u, E4R_CANDIDATE_EXIT, &c) == E4R_OK && c.phase_changed == 1u);
        CHECK(e4r_rd32(o, E4R_O_EXIT) == 1);
    }
    CHECK(b_visit(&x, 2, 2u, &ph, &done) == SCENE_ACTION_HANDLER_OK && done == 1 && x.f.tr.scene == 77 && x.f.flag_idx == 3 && x.f.flag_val == 8u);
    /* Scene change while a puzzle runs: the previous object is cleaned up (surfaces and slot released) and the table is reset. */
    CHECK(session_ae4_begin_scene(x.b, x.scene) == E4R_OK);
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    {
        E4rObject *o = (E4rObject *)session_ae4_state(x.b);
        E4rWorld *w = (E4rWorld *)session_ae4_world(x.b);
        w->high_score[0] = 500;
        w->high_score[4] = 3;
        w->high_score_marker_5a0545 = 9;
        (void)o;
    }
    x.f.n_relsurf = x.f.n_relslot = 0;
    CHECK(session_ae4_begin_scene(x.b, x.scene) == E4R_OK);
    CHECK(x.f.n_relsurf == 2 && x.f.n_relslot == 1 && session_ae4_registered(x.b) == 0u);
    CHECK(session_ae4_world(x.b)->high_score[0] == 0 && session_ae4_world(x.b)->high_score[4] == 0 &&
          session_ae4_world(x.b)->high_score_marker_5a0545 == 0);
    /* A failing clear stops the scene change and keeps the earlier rows. */
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    x.f.calls = 0;
    x.f.fail_call = 1;
    CHECK(session_ae4_begin_scene(x.b, x.scene) == E4R_ERR_HOST && strcmp(session_ae4_failure(x.b), "0xe4-scene-clear") == 0);
    x.f.fail_call = 0;
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    /* destroy cleans up. */
    x.f.n_relsurf = x.f.n_relslot = 0;
    session_ae4_destroy(x.b);
    CHECK(x.f.n_relsurf >= 1 && x.f.n_relslot == 1);
    scene_resource_close(x.scene);
}

static void t_binding_refuses_bad_body(void)
{
    Bind x;
    uint32_t ph = 99u;
    int done = -1;
    if (!bind_open(&x, 1)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_ae4_begin_scene(x.b, x.scene) == E4R_OK);
    scene_resource_close(x.scene);
    {
        /* A second scene with a bad body: the failure names the check and the first scene's rows stay in use. */
        const int types[2] = {0xe4, 0xe4};
        const uint8_t *bodies[2];
        const size_t lengths[2] = {E4R_BODY_BYTES, E4R_BODY_BYTES};
        uint8_t bad[E4R_BODY_BYTES];
        char err[128] = {0};
        memcpy(bad, x.body_a, sizeof bad);
        put16(bad, O_ROWS, 11);
        bodies[0] = x.body_a;
        bodies[1] = bad;
        x.bytes_len = build_scene(x.bytes, 2, types, bodies, lengths);
        x.scene = scene_resource_open_memory(x.bytes, x.bytes_len, err, sizeof err);
        CHECK(x.scene != NULL);
        if (x.scene != NULL) {
            CHECK(session_ae4_begin_scene(x.b, x.scene) == E4R_ERR_BODY && strcmp(session_ae4_failure(x.b), "0xe4-rows") == 0);
            /* The earlier scene (rows 1 and 2) is still bound: row 1 still runs from the copy of the first scene's body. */
            CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u);
            CHECK(session_ae4_begin_scene(x.b, x.scene) == E4R_ERR_BODY && strcmp(session_ae4_failure(x.b), "0xe4-rows") == 0);
            scene_resource_close(x.scene);
            x.scene = NULL;
        }
        /* A good scene afterwards clears the failure text. */
        x.bytes_len = build_scene(x.bytes, 1, types, bodies, lengths);
        x.scene = scene_resource_open_memory(x.bytes, x.bytes_len, err, sizeof err);
        CHECK(x.scene != NULL);
        if (x.scene != NULL) {
            CHECK(session_ae4_begin_scene(x.b, x.scene) == E4R_OK && strcmp(session_ae4_failure(x.b), "none") == 0);
            /* The e4 row is the scene's first row: it runs. */
            CHECK(b_visit(&x, 0, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u);
            scene_resource_close(x.scene);
            x.scene = NULL;
        }
        /* A scene without any row binds (nothing to copy) and leaves nothing to run. */
        x.bytes_len = build_scene(x.bytes, 0, types, bodies, lengths);
        x.scene = scene_resource_open_memory(x.bytes, x.bytes_len, err, sizeof err);
        CHECK(x.scene != NULL);
        if (x.scene != NULL) {
            CHECK(session_ae4_begin_scene(x.b, x.scene) == E4R_OK && strcmp(session_ae4_failure(x.b), "none") == 0);
            CHECK(b_visit(&x, 0, 0u, &ph, &done) == -1);
        }
    }
    bind_close(&x);
}

static void t_binding_without_hook_and_short_body(void)
{
    Bind x;
    uint32_t ph = 99u;
    int done = -1;
    if (!bind_open(&x, 0)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_ae4_begin_scene(x.b, x.scene) == E4R_OK);
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u); /* no store_world hook: still works */
    CHECK(g_stores == 0);
    scene_resource_close(x.scene);
    {
        /* A raw 0xe4 row of the wrong length cannot be a typed row: the parser leaves it opaque or refuses the scene, and the binding
         * never accepts it. */
        const int types[1] = {0xe4};
        const uint8_t *bodies[1];
        const size_t lengths[1] = {100};
        char err[128] = {0};
        bodies[0] = x.body_a;
        x.bytes_len = build_scene(x.bytes, 1, types, bodies, lengths);
        x.scene = scene_resource_open_memory(x.bytes, x.bytes_len, err, sizeof err);
        if (x.scene != NULL) {
            CHECK(session_ae4_begin_scene(x.b, x.scene) == E4R_ERR_BODY || session_ae4_begin_scene(x.b, x.scene) == E4R_OK);
        }
    }
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
    run("object_and_scene_reset", t_reset);
    run("phase0", t_phase0);
    run("phase0_variants", t_phase0_variants);
    run("phase0_host_failures", t_phase0_host_failures);
    run("fill_retry_limit", t_fill_retry_limit);
    run("step_args", t_step_args);
    run("phase12_gating", t_phase12_gating);
    run("state_idle", t_state_idle);
    run("state_check_order", t_state_check_order);
    run("state_end", t_state_end);
    run("state_refill", t_state_refill);
    run("state_shuffle", t_state_shuffle);
    run("state_end_wait", t_state_end_wait);
    run("state_scores", t_state_scores);
    run("phase2_exit_and_win", t_phase2_exit_and_win);
    run("phase2_variants", t_phase2_variants);
    run("pointer", t_pointer);
    run("click_guards", t_click_guards);
    run("click_select_and_swap", t_click_select_and_swap);
    run("click_shuffle_and_exit", t_click_shuffle_and_exit);
    run("check_for_match", t_check_for_match);
    run("check_run_bounds", t_check_run_bounds);
    run("phase0_over_leftovers", t_phase0_over_leftovers);
    run("kind_outside_first_cell", t_kind_outside_first_cell);
    run("full_width_board", t_full_width_board);
    run("refill_first_cell", t_refill_first_cell);
    run("visit_host_failures", t_visit_host_failures);
    run("more_gaps", t_more_gaps);
    run("invalidate", t_invalidate);
    run("cleanup", t_cleanup);
    run("render_fresh", t_render_fresh);
    run("render_panels", t_render_panels);
    run("render_scores", t_render_scores);
    run("render_refusals", t_render_refusals);
    run("binding_flow", t_binding_flow);
    run("binding_second_row_and_scene_change", t_binding_second_row_and_scene_change);
    run("binding_refuses_bad_body", t_binding_refuses_bad_body);
    run("binding_without_hook_and_short_body", t_binding_without_hook_and_short_body);
    printf("TOTAL %d FAILED %d\n", g_total, g_failures);
    return g_failures;
}
