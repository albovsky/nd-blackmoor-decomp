/* RT-51 unit tests of the raw 0xd6 / 0xe0 keypad puzzle kernel (src/action_family_e0_runtime.c) and its session binding
 * (src/session_bindings_ae0.c). Prints "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure count.
 * Fixtures are synthetic bodies (no original bytes) for both flag 0 (raw 0xd6, 1,733 bytes) and flag 1 (raw 0xe0, 294 bytes
 * zero padded to E0_BODY_CAPACITY). tests/test_action_family_e0_runtime.py builds and runs this with and without ASan/UBSan
 * and under source mutations. */
#include <stdarg.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_e0_runtime.h"
#include "scene_resource.h"
#include "session_bindings_ae0.h"

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

static void fail_now(const char *what)
{
    if (!g_failed) {
        g_failed = 1;
        snprintf(g_msg, sizeof g_msg, "%s", what);
    }
}

#define CAP E0_BODY_CAPACITY

typedef struct Fx {
    E0Object obj;
    E0World world;
    E0Host host;
    uint8_t body[E0_BODY_CAPACITY];
    size_t body_len;
    int flag;
    char log[8192];
    uint32_t ticks[16];
    int nticks, iticks;
    int32_t busy[8];
    int nbusy, ibusy;
    int fail_alloc, fail_register, fail_load, fail_setsurf, fail_relsurf, fail_relslot, fail_dirty, fail_origin,
        fail_prepare, fail_stop, fail_play, fail_busy, fail_transition, fail_flag;
    int16_t next_slot;
    uint32_t new_surface;
    int32_t vx, vy;
    uint32_t phase;
    int completed, initialized;
    const char *why;
    /* values the host just answered or received; observe() checks the kernel's effect arguments against them */
    int16_t pend_slot, pend_ss_slot, pend_rel_slot, pend_dirty, pend_play, pend_busy_ch, pend_flag_idx;
    uint32_t pend_load, pend_reg_surface, pend_ss_surface, pend_rel_surface, pend_tick;
    int32_t pend_busy_val;
    uint32_t pend_flag_val;
    char pend_tag;
    int n_stop, n_prepare, n_play;
} Fx;

static void put16(uint8_t *b, size_t off, int v)
{
    b[off] = (uint8_t)v;
    b[off + 1] = (uint8_t)(v >> 8);
}
static void put32(uint8_t *b, size_t off, int32_t v)
{
    for (int i = 0; i < 4; ++i) b[off + (size_t)i] = (uint8_t)((uint32_t)v >> (8 * i));
}
static int get16(const uint8_t *b, size_t off) { return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8)); }
static void put_rect(uint8_t *b, size_t off, int32_t l, int32_t t, int32_t r, int32_t bt)
{
    put32(b, off, l);
    put32(b, off + 4, t);
    put32(b, off + 8, r);
    put32(b, off + 12, bt);
}
static void set_block(uint8_t *b, size_t off, int scene, int w1, int w2, int w3, int32_t d1, int32_t d2, int32_t d3,
                      int start, int flag, int value)
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
static void set_rec(uint8_t *b, size_t off, const char *name)
{
    memset(b + off, 0, 9);
    memcpy(b + off, name, strlen(name));
}
static void set_code(uint8_t *b, size_t off, int k, int ordered, const uint8_t *code, size_t n)
{
    memset(b + off, 0, E0_ROUND_BYTES);
    put16(b, off, k);
    b[off + 2] = (uint8_t)ordered;
    memcpy(b + off + 3, code, n);
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

static const char *const effect_names[] = {"?",       "start",  "slot",   "reg",   "load",   "slotsurf", "prep",
                                           "stop",    "play",   "busy",   "tick",  "phase",  "?",        "evflag",
                                           "x57b",    "x599",   "x595",   "x39ff", "x59b",   "x59f",     "x5a3",
                                           "mode",    "e17",    "complete", "relsurf", "relslot", "dirty"};

static void observe(void *c, int e, int32_t a, int32_t b)
{
    Fx *f = (Fx *)c;
    switch (e) {
    case E0_FX_SLOT:
        if (a != f->pend_slot) fail_now("slot effect differs from the host answer");
        break;
    case E0_FX_SLOT_REGISTER:
        if (a != f->pend_slot || b != (int32_t)f->pend_reg_surface) fail_now("register effect differs from the host call");
        break;
    case E0_FX_SURFACE_LOAD:
        if ((uint32_t)a != f->pend_load) fail_now("surface load effect differs from the host answer");
        break;
    case E0_FX_SLOT_SURFACE:
        if (a != f->pend_ss_slot || (uint32_t)b != f->pend_ss_surface) fail_now("slot surface effect differs from the host call");
        break;
    case E0_FX_SOUND_PREPARE:
    case E0_FX_SOUND_STOP:
        if (f->pend_tag != 0 && f->pend_tag != (a == 0x66 ? 'A' : a == 0xb2 ? 'B' : '?')) fail_now("sound record offset differs from the host record");
        break;
    case E0_FX_SOUND_PLAY:
        if (a != f->pend_play) fail_now("sound channel differs from the host call");
        break;
    case E0_FX_SOUND_BUSY:
        if (a != f->pend_busy_ch || b != f->pend_busy_val) fail_now("busy effect differs from the host call");
        break;
    case E0_FX_TICK:
        if (a != (int32_t)f->pend_tick) fail_now("tick effect differs from the host answer");
        break;
    case E0_FX_EVENT_FLAG:
        if (a != f->pend_flag_idx || (uint32_t)b != f->pend_flag_val) fail_now("event flag effect differs from the host call");
        break;
    case E0_FX_RELEASE_SURFACE:
        if ((uint32_t)a != f->pend_rel_surface) fail_now("release surface effect differs from the host call");
        break;
    case E0_FX_RELEASE_SLOT:
        if (a != f->pend_rel_slot) fail_now("release slot effect differs from the host call");
        break;
    case E0_FX_MARK_DIRTY:
        if (a != f->pend_dirty) fail_now("dirty effect differs from the host call");
        break;
    default:
        break;
    }
    logf_(f, "%s:%d:%d", effect_names[e], a, b);
}

static int h_alloc(void *c, int16_t *slot)
{
    Fx *f = (Fx *)c;
    if (f->fail_alloc) return 1;
    *slot = f->next_slot;
    f->pend_slot = *slot;
    return 0;
}
static int h_register(void *c, int16_t slot, const char *label, uint32_t surface)
{
    Fx *f = (Fx *)c;
    if (f->fail_register || slot != f->pend_slot || strcmp(label, "KEYPAD PUZZLE OVERLAYS") != 0) return 1;
    f->pend_reg_surface = surface;
    return 0;
}
static int h_load(void *c, const char *name, uint32_t *surface)
{
    Fx *f = (Fx *)c;
    if (f->fail_load || strcmp(name, "KEYS") != 0) return 1;
    *surface = f->new_surface;
    f->pend_load = *surface;
    return 0;
}
static int h_setsurf(void *c, int16_t slot, uint32_t surface)
{
    Fx *f = (Fx *)c;
    if (f->fail_setsurf) return 1;
    f->pend_ss_slot = slot;
    f->pend_ss_surface = surface;
    return 0;
}
static int h_relsurf(void *c, uint32_t surface)
{
    Fx *f = (Fx *)c;
    if (f->fail_relsurf) return 1;
    f->pend_rel_surface = surface;
    return 0;
}
static int h_relslot(void *c, int16_t slot)
{
    Fx *f = (Fx *)c;
    if (f->fail_relslot) return 1;
    f->pend_rel_slot = slot;
    return 0;
}
static int h_dirty(void *c, int16_t slot)
{
    Fx *f = (Fx *)c;
    if (f->fail_dirty) return 1;
    f->pend_dirty = slot;
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
static int h_prepare(void *c, const uint8_t *r)
{
    Fx *f = (Fx *)c;
    if (f->fail_prepare) return 1;
    f->pend_tag = memcmp(r, "SND", 3) == 0 ? (char)r[3] : 0;
    ++f->n_prepare;
    return 0;
}
static int h_stop(void *c, const uint8_t *r)
{
    Fx *f = (Fx *)c;
    if (f->fail_stop) return 1;
    f->pend_tag = memcmp(r, "SND", 3) == 0 ? (char)r[3] : 0;
    ++f->n_stop;
    return 0;
}
static int h_play(void *c, int16_t ch)
{
    Fx *f = (Fx *)c;
    if (f->fail_play) return 1;
    f->pend_play = ch;
    ++f->n_play;
    return 0;
}
static int h_busy(void *c, int16_t ch, int32_t *r)
{
    Fx *f = (Fx *)c;
    if (f->fail_busy) return 1;
    *r = f->ibusy < f->nbusy ? f->busy[f->ibusy++] : 0;
    f->pend_busy_ch = ch;
    f->pend_busy_val = *r;
    return 0;
}
static uint32_t h_tick(void *c)
{
    Fx *f = (Fx *)c;
    f->pend_tick = f->iticks < f->nticks ? f->ticks[f->iticks++] : f->ticks[f->nticks - 1];
    return f->pend_tick;
}
static int h_transition(void *c, const E0Transition *t)
{
    Fx *f = (Fx *)c;
    if (f->fail_transition) return 1;
    logf_(f, "tr:%d:%d:%d:%d:%d:%d:%d", t->scene, t->word[0], t->word[1], t->word[2], t->dword[0], t->dword[1], t->dword[2]);
    return 0;
}
static int h_store_flag(void *c, int16_t i, uint32_t v)
{
    Fx *f = (Fx *)c;
    if (f->fail_flag) return 1;
    f->pend_flag_idx = i;
    f->pend_flag_val = v;
    return 0;
}
static int h_flag_invalid(void *c, int16_t i)
{
    (void)c;
    return i < 0 || i >= 100;
}

static void set_ticks(Fx *f, const uint32_t *v, size_t n)
{
    for (size_t i = 0; i < n && i < 16u; ++i) f->ticks[i] = v[i];
    f->nticks = (int)n;
    f->iticks = 0;
}
#define T(f, ...)                                              \
    do {                                                       \
        const uint32_t v_[] = {__VA_ARGS__};                   \
        set_ticks((f), v_, sizeof v_ / sizeof v_[0]);          \
    } while (0)
static void set_busy(Fx *f, const int32_t *v, size_t n)
{
    for (size_t i = 0; i < n && i < 8u; ++i) f->busy[i] = v[i];
    f->nbusy = (int)n;
    f->ibusy = 0;
}
#define BUSY(f, ...)                                           \
    do {                                                       \
        const int32_t v_[] = {__VA_ARGS__};                    \
        set_busy((f), v_, sizeof v_ / sizeof v_[0]);           \
    } while (0)
static void set_i16(int16_t *dst, const int16_t *v, size_t n)
{
    for (int i = 0; i < E0_MAX_CODE; ++i) dst[i] = -1;
    for (size_t i = 0; i < n && i < (size_t)E0_MAX_CODE; ++i) dst[i] = v[i];
}
#define PLAYER(o, ...)                                         \
    do {                                                       \
        const int16_t v_[] = {__VA_ARGS__};                    \
        set_i16((o)->player, v_, sizeof v_ / sizeof v_[0]);    \
    } while (0)
#define RECORD(o, ...)                                         \
    do {                                                       \
        const int16_t v_[] = {__VA_ARGS__};                    \
        set_i16((o)->record, v_, sizeof v_ / sizeof v_[0]);    \
    } while (0)

/* The base body. Flag 0 (1,733 bytes): N = 4 keys, key i source rect (100+10i, 200+i, 109+10i, 209+i), hit rect
 * (20i, 0, 20i+9, 9); exit button present (hit rect 200,100..219,109; pressed source 500,0..509,9); round 0 code {1,2}
 * unordered; sound A "SNDA" (click channel 5); failed block scene 60 (words 1 2 3, dwords 11 22 33, start word 1, event flag
 * 7 := 3); delay 2 s; sound B "SNDB" (channel 9); exit block scene 50 (4 5 6, 44 55 66, start 0, flag 8 := 9); exit rectangle
 * 300,200..319,209; R = 3 rounds; round lights; blink byte 1; round records 1..4 K = 3 code {10+j, 11+j, 12+j}; no code sets;
 * all-sets block scene 70 (7 8 9, 77 88 99, start 1, flag 12 := 4).
 * Flag 1 (294 bytes): the same up to +0x10c (the scene word is 5), then a 2 x 2 key grid of 10 x 8 keys (x0 5 y0 6, gaps 3
 * and 4; destination x0' 100 y0' 50, gaps 6 and 2). Everything after +0x126 is zero. */
static void body_init(Fx *f, int flag)
{
    uint8_t *b = f->body;
    static const uint8_t code0[2] = {1, 2};
    memset(b, 0, CAP);
    memcpy(b, "KEYS", 5);
    put16(b, 0x21, 4);
    b[0x23] = 0;
    b[0x24] = 1;
    put_rect(b, 0x25, 500, 0, 509, 9);
    put_rect(b, 0x35, 200, 100, 219, 109);
    set_code(b, 0x45, 2, 0, code0, sizeof code0);
    set_rec(b, 0x66, "SNDA");
    put16(b, 0x87, 5);
    set_block(b, 0x97, 60, 1, 2, 3, 11, 22, 33, 1, 7, 3);
    put16(b, 0xb0, 2);
    set_rec(b, 0xb2, "SNDB");
    put16(b, 0xd3, 9);
    set_block(b, 0xe3, 50, 4, 5, 6, 44, 55, 66, 0, 8, 9);
    put_rect(b, 0xfc, 300, 200, 319, 209);
    if (flag == 1) {
        put16(b, 0x10c, 5);
        put16(b, 0x10e, 2);
        put16(b, 0x110, 2);
        put16(b, 0x112, 10);
        put16(b, 0x114, 8);
        put16(b, 0x116, 5);
        put16(b, 0x118, 6);
        put16(b, 0x11a, 3);
        put16(b, 0x11c, 4);
        put16(b, 0x11e, 100);
        put16(b, 0x120, 50);
        put16(b, 0x122, 6);
        put16(b, 0x124, 2);
        f->body_len = E0_BODY_BYTES_E0;
    } else {
        put16(b, 0x10c, 3);
        for (int i = 0; i < 5; ++i) {
            put_rect(b, 0x10e + 16u * (unsigned)i, 300 + 10 * i, 400, 309 + 10 * i, 409);
            put_rect(b, 0x15e + 16u * (unsigned)i, 10 + 20 * i, 300, 19 + 20 * i, 309);
            put_rect(b, 0x1ae + 16u * (unsigned)i, 500 + 10 * i, 500, 509 + 10 * i, 509);
            put_rect(b, 0x1fe + 16u * (unsigned)i, 50 + 20 * i, 350, 59 + 20 * i, 359);
        }
        b[0x24e] = 1;
        for (int j = 0; j < 4; ++j) {
            const uint8_t code[3] = {(uint8_t)(10 + j), (uint8_t)(11 + j), (uint8_t)(12 + j)};
            set_code(b, 0x24f + E0_ROUND_BYTES * (unsigned)j, 3, 0, code, sizeof code);
        }
        set_block(b, 0x2ec, 70, 7, 8, 9, 77, 88, 99, 1, 12, 4);
        for (int i = 0; i < 30; ++i) {
            put_rect(b, 0x305 + 16u * (unsigned)i, 100 + 10 * i, 200 + i, 109 + 10 * i, 209 + i);
            put_rect(b, 0x4e5 + 16u * (unsigned)i, 20 * i, 0, 20 * i + 9, 9);
        }
        f->body_len = E0_BODY_BYTES_D6;
    }
    f->flag = flag;
}

static void fx_init(Fx *f, int flag)
{
    memset(f, 0, sizeof(*f));
    e0_object_reset(&f->obj);
    f->world.scene_cell_5bb57b = E0_NO_SCENE;
    f->host.context = f;
    f->host.alloc_slot = h_alloc;
    f->host.register_slot = h_register;
    f->host.load_surface = h_load;
    f->host.set_slot_surface = h_setsurf;
    f->host.release_surface = h_relsurf;
    f->host.release_slot = h_relslot;
    f->host.mark_dirty = h_dirty;
    f->host.view_origin = h_origin;
    f->host.sound_prepare = h_prepare;
    f->host.sound_stop = h_stop;
    f->host.sound_play = h_play;
    f->host.sound_busy = h_busy;
    f->host.tick = h_tick;
    f->host.transition = h_transition;
    f->host.store_event_flag = h_store_flag;
    f->host.event_flag_invalid = h_flag_invalid;
    f->host.observe = observe;
    f->next_slot = 24;
    f->new_surface = 0x1234u;
    f->vx = 10;
    f->vy = 20;
    f->ticks[0] = 1000u;
    f->nticks = 1;
    body_init(f, flag);
}

static int visit_row(Fx *f, int16_t row, uint32_t phase)
{
    E0Result r;
    const char *why = NULL;
    const int rc = e0_step(&f->obj, f->body, f->body_len, f->flag, row, phase, &f->world, &f->host, &r, &why);
    f->phase = r.phase_after;
    f->completed = r.completed;
    f->initialized = r.initialized;
    f->why = why;
    return rc;
}
static int visit(Fx *f, uint32_t phase) { return visit_row(f, 3, phase); }

/* Phase 0 on row 3, then forget the log and reset the scripted ticks. */
static void start(Fx *f)
{
    CHECK(visit(f, 0) == E0_OK && f->phase == 1u);
    f->log[0] = '\0';
    T(f, 1000u);
}

static int pointer(Fx *f, int32_t x, int32_t y, E0PointerResult *out)
{
    return e0_pointer_move(&f->obj, f->body, f->body_len, x, y, out);
}
static int click(Fx *f, uint32_t row_phase, int32_t candidate, int32_t start_flag, uint32_t *np)
{
    return e0_click(&f->obj, f->body, f->body_len, row_phase, candidate, start_flag, &f->host, np);
}
/* A key click in state 0 with the hover set. */
static int press(Fx *f, int16_t hover, int32_t start_flag)
{
    uint32_t np = 0u;
    f->obj.hover = hover;
    return click(f, 1u, E0_CANDIDATE_KEY, start_flag, &np);
}

static void snapshot(const Fx *f, uint8_t img[E0_IMAGE_BYTES])
{
    uint8_t mask[E0_IMAGE_BYTES];
    e0_object_pack(&f->obj, img, mask);
}

/* ---- validation and the object --------------------------------------------------------------------------------------- */

static void expect_reject(Fx *f, const char *reason)
{
    const char *why = NULL;
    const int rc = e0_validate_body(f->flag, f->body, f->body_len, &why);
    if (rc != E0_ERR_BODY || why == NULL || strcmp(why, reason) != 0) {
        char m[160];
        snprintf(m, sizeof m, "expected rejection %s, got rc %d why %s", reason, rc, why == NULL ? "(null)" : why);
        fail_now(m);
    }
}
static void expect_accept(Fx *f)
{
    const char *why = (const char *)1;
    const int rc = e0_validate_body(f->flag, f->body, f->body_len, &why);
    if (rc != E0_OK || why != NULL) {
        char m[160];
        snprintf(m, sizeof m, "expected acceptance, got rc %d why %s", rc, why == NULL ? "(null)" : why);
        fail_now(m);
    }
}

static void t_validate_common(void)
{
    Fx f;
    const char *why = NULL;
    for (int flag = 0; flag < 2; ++flag) {
        fx_init(&f, flag);
        expect_accept(&f);
        CHECK(e0_validate_body(flag, f.body, f.body_len, NULL) == E0_OK);
        /* arguments */
        CHECK(e0_validate_body(flag, NULL, f.body_len, &why) == E0_ERR_BODY && strcmp(why, "keypad-argument") == 0);
        CHECK(e0_validate_body(2, f.body, f.body_len, &why) == E0_ERR_BODY && strcmp(why, "keypad-argument") == 0);
        CHECK(e0_validate_body(-1, f.body, f.body_len, &why) == E0_ERR_BODY && strcmp(why, "keypad-argument") == 0);
        /* length: only the exact loader length of the flag */
        f.body_len = flag == 0 ? E0_BODY_BYTES_E0 : E0_BODY_BYTES_D6;
        expect_reject(&f, "keypad-body-length");
        f.body_len = flag == 0 ? E0_BODY_BYTES_D6 - 1u : E0_BODY_BYTES_E0 - 1u;
        expect_reject(&f, "keypad-body-length");
        f.body_len = flag == 0 ? E0_BODY_BYTES_D6 + 1u : E0_BODY_BYTES_E0 + 1u;
        expect_reject(&f, "keypad-body-length");
        f.body_len = 0u;
        expect_reject(&f, "keypad-body-length");
        body_init(&f, flag);
        /* the name must end within 0x21 bytes */
        memset(f.body, 'A', 0x21);
        expect_reject(&f, "keypad-name-unterminated");
        f.body[0x20] = 0;
        expect_accept(&f);
        f.body[0x20] = 'A';
        f.body[0x1f] = 0;
        expect_accept(&f);
        /* the search covers exactly 0x21 bytes: a zero in the next byte does not terminate the name */
        memset(f.body, 'A', 0x21);
        f.body[0x21] = 0;
        f.body[0x22] = 0;
        expect_reject(&f, "keypad-name-unterminated");
        body_init(&f, flag);
        /* the length precedes every other reason */
        memset(f.body, 'A', 0x21);
        f.body_len = 10u;
        expect_reject(&f, "keypad-body-length");
        body_init(&f, flag);
        /* the name is checked before the counts */
        memset(f.body, 'A', 0x21);
        put16(f.body, 0x21, 500);
        expect_reject(&f, "keypad-name-unterminated");
        body_init(&f, flag);
    }
    /* the padding after the loaded 294 bytes must be zero (flag 1 only: flag 0 has no padding) */
    fx_init(&f, 1);
    f.body[294] = 1;
    expect_reject(&f, "keypad-padding-not-zero");
    f.body[294] = 0;
    f.body[E0_BODY_CAPACITY - 1u] = 1;
    expect_reject(&f, "keypad-padding-not-zero");
    f.body[E0_BODY_CAPACITY - 1u] = 0;
    f.body[0x24e] = 1;
    expect_reject(&f, "keypad-padding-not-zero");
    f.body[0x24e] = 0;
    f.body[293] = 1;
    expect_accept(&f);
}

static void t_validate_counts(void)
{
    Fx f;
    static const int ok_n[] = {0, 1, 29, 30, 99, 100};
    static const int bad_n[] = {101, 255, 32767, -1, -100, -32768};
    /* flag 0: N is the word at +0x21 */
    fx_init(&f, 0);
    for (size_t i = 0; i < sizeof ok_n / sizeof ok_n[0]; ++i) {
        put16(f.body, 0x21, ok_n[i]);
        expect_accept(&f);
    }
    for (size_t i = 0; i < sizeof bad_n / sizeof bad_n[0]; ++i) {
        put16(f.body, 0x21, bad_n[i]);
        expect_reject(&f, "keypad-key-count");
    }
    /* flag 1: N is the 16-bit product cols * rows (the stored +0x21 word is ignored) */
    {
        static const int cr[][2] = {{10, 10}, {4, 25}, {1, 100}, {100, 1}, {0, 5}, {5, 0}, {0, 0}, {256, 256}, {-10, -10}, {16384, 4}, {-1, -1}};
        static const int bad[][2] = {{11, 10}, {101, 1}, {300, 300}, {200, 200}, {-1, 5}, {-2, 50}, {7, 15}};
        fx_init(&f, 1);
        for (size_t i = 0; i < sizeof cr / sizeof cr[0]; ++i) {
            put16(f.body, 0x10e, cr[i][0]);
            put16(f.body, 0x110, cr[i][1]);
            expect_accept(&f);
        }
        for (size_t i = 0; i < sizeof bad / sizeof bad[0]; ++i) {
            put16(f.body, 0x10e, bad[i][0]);
            put16(f.body, 0x110, bad[i][1]);
            expect_reject(&f, "keypad-key-count");
        }
        fx_init(&f, 1);
        put16(f.body, 0x21, 5000);
        expect_accept(&f); /* the stored count word is not read */
    }
    /* ordered mode: the typed order must fit the 30 entry arrays */
    fx_init(&f, 0);
    f.body[0x23] = 1;
    put16(f.body, 0x21, 30);
    expect_accept(&f);
    put16(f.body, 0x21, 31);
    expect_reject(&f, "keypad-ordered-key-count");
    f.body[0x23] = 2;
    expect_reject(&f, "keypad-ordered-key-count");
    f.body[0x23] = 0;
    expect_accept(&f);
    fx_init(&f, 1);
    f.body[0x23] = 1;
    put16(f.body, 0x10e, 8);
    put16(f.body, 0x110, 4);
    expect_reject(&f, "keypad-ordered-key-count");
    put16(f.body, 0x110, 3);
    expect_accept(&f);
}

static void t_validate_records_and_sets(void)
{
    Fx f;
    static const int bad_k[] = {31, 32, 255, 32767, -1, -32768};
    /* round record 0 */
    fx_init(&f, 0);
    put16(f.body, 0x45, 30);
    expect_accept(&f);
    put16(f.body, 0x45, 0);
    expect_accept(&f);
    for (size_t i = 0; i < sizeof bad_k / sizeof bad_k[0]; ++i) {
        put16(f.body, 0x45, bad_k[i]);
        expect_reject(&f, "keypad-code-length");
    }
    fx_init(&f, 1);
    put16(f.body, 0x45, 31);
    expect_reject(&f, "keypad-code-length");
    put16(f.body, 0x45, -1);
    expect_reject(&f, "keypad-code-length");
    /* the four later records (flag 0 only) */
    for (unsigned j = 0; j < 4u; ++j) {
        const size_t off = 0x24f + E0_ROUND_BYTES * j;
        fx_init(&f, 0);
        put16(f.body, off, 30);
        expect_accept(&f);
        for (size_t i = 0; i < sizeof bad_k / sizeof bad_k[0]; ++i) {
            put16(f.body, off, bad_k[i]);
            expect_reject(&f, "keypad-code-length");
        }
    }
    /* code sets: a prefix of nonzero first bytes, with N <= 29 */
    fx_init(&f, 0);
    f.body[0x2d3] = 1;
    f.body[0x2d3 + 5] = 2;
    f.body[0x2d3 + 10] = 3;
    f.body[0x2d3 + 15] = 4;
    f.body[0x2d3 + 20] = 5;
    expect_accept(&f); /* all five */
    f.body[0x2d3 + 20] = 0;
    expect_accept(&f); /* four */
    f.body[0x2d3 + 10] = 0;
    expect_reject(&f, "keypad-code-sets-not-prefix"); /* a hole */
    f.body[0x2d3 + 15] = 0;
    expect_accept(&f); /* two */
    f.body[0x2d3] = 0;
    expect_reject(&f, "keypad-code-sets-not-prefix"); /* the first one empty, the second not */
    f.body[0x2d3 + 5] = 0;
    expect_accept(&f); /* none */
    f.body[0x2d3 + 20] = 7;
    expect_reject(&f, "keypad-code-sets-not-prefix"); /* only the last */
    /* the first byte alone decides whether a set exists */
    fx_init(&f, 0);
    f.body[0x2d3 + 1] = 9;
    f.body[0x2d3 + 4] = 9;
    expect_accept(&f);
    /* with sets, N must be at most 29; without, 30 is fine */
    fx_init(&f, 0);
    put16(f.body, 0x21, 30);
    expect_accept(&f);
    f.body[0x2d3] = 1;
    expect_reject(&f, "keypad-code-sets-key-count");
    put16(f.body, 0x21, 29);
    expect_accept(&f);
    put16(f.body, 0x21, 100);
    expect_reject(&f, "keypad-code-sets-key-count");
    /* flag 1 does not read the set area (it lies beyond the loaded 294 bytes, so it cannot be nonzero) */
    fx_init(&f, 1);
    put16(f.body, 0x21, 30);
    expect_accept(&f);
}

static void t_object_reset(void)
{
    E0Object o;
    E0Object zero;
    memset(&o, 0x5a, sizeof o);
    e0_object_reset(&o);
    CHECK(o.row == -1 && o.slot == E0_NO_SLOT);
    memset(&zero, 0, sizeof zero);
    zero.row = -1;
    zero.slot = -1;
    CHECK(memcmp(&o, &zero, sizeof o) == 0);
    e0_object_reset(NULL);
    e0_scene_reset(NULL);
    o.round = 5;
    o.word_5957b5 = 7;
    o.typed = 3;
    e0_scene_reset(&o);
    CHECK(o.round == 0 && o.word_5957b5 == 0 && o.typed == 3);
}

static uint64_t rd_le(const uint8_t *img, size_t off, size_t size)
{
    uint64_t v = 0;
    for (size_t i = 0; i < size; ++i) v |= (uint64_t)img[off + i] << (8u * i);
    return v;
}

static void t_object_pack(void)
{
    E0Object o;
    uint8_t img[E0_IMAGE_BYTES], mask[E0_IMAGE_BYTES];
    size_t modelled = 0;
    memset(&o, 0, sizeof o);
    for (int i = 0; i < E0_MAX_KEYS; ++i) {
        for (int k = 0; k < 4; ++k) {
            o.rect_a[i][k] = 0x01000000 + i * 16 + k;
            o.rect_b[i][k] = -(0x02000000 + i * 16 + k);
        }
        o.lit[i] = (uint8_t)(i + 1);
    }
    o.tiles_visible = 0x11;
    o.code_len = 0x1234;
    o.code_ordered = 0x22;
    for (int i = 0; i < E0_MAX_CODE; ++i) {
        o.code[i] = (uint8_t)(0x30 + i);
        o.player[i] = (int16_t)(0x100 + i);
        o.scratch[i] = (int16_t)(0x200 + i);
        o.record[i] = (int16_t)(0x300 + i);
    }
    o.rounds = 0x2345;
    o.surface = 0x89abcdefu;
    o.row = -2;
    o.hover = -3;
    o.state = 0x01020304;
    o.recorded = 0x3456;
    o.typed = 0x4567;
    o.slot = 0x5678;
    o.exit_pending = 0x41;
    o.waiting = 0x42;
    o.blink = 0x43;
    o.flag = 0x44;
    o.active = 0x45;
    o.exit_asked = 0x46;
    o.blink_deadline = 0xa1b2c3d4u;
    o.show_deadline = 0xe1f20304u;
    o.pad_d48 = 0x6789;
    o.solved = 0x47;
    o.solved_sets = 0x48;
    o.wait_deadline = 0x0badf00du;
    o.set_count = 0x789a;
    o.scene = 0x7bcd;
    e0_object_pack(&o, img, mask);
    for (size_t i = 0; i < E0_IMAGE_BYTES; ++i) modelled += mask[i];
    CHECK(modelled == 3560u);
    /* unmodelled holes stay zero and unmarked */
    for (size_t i = 0; i < 0x1c; ++i) CHECK(mask[i] == 0u && img[i] == 0u);
    for (size_t i = 0xd34; i < 0xd38; ++i) CHECK(mask[i] == 0u && img[i] == 0u);
    for (size_t i = 0xd02; i < 0xd03; ++i) CHECK(mask[i] == 1u); /* the high byte of the code length word */
    for (int i = 0; i < E0_MAX_KEYS; i += 33) {
        for (int k = 0; k < 4; ++k) {
            CHECK(rd_le(img, 0x1cu + (size_t)i * 16u + (size_t)k * 4u, 4) == (uint32_t)o.rect_a[i][k]);
            CHECK(rd_le(img, 0x65cu + (size_t)i * 16u + (size_t)k * 4u, 4) == (uint32_t)o.rect_b[i][k]);
        }
    }
    for (int k = 0; k < 4; ++k) {
        CHECK(rd_le(img, 0x1cu + 99u * 16u + (size_t)k * 4u, 4) == (uint32_t)o.rect_a[99][k]);
        CHECK(rd_le(img, 0x65cu + 99u * 16u + (size_t)k * 4u, 4) == (uint32_t)o.rect_b[99][k]);
    }
    for (int i = 0; i < E0_MAX_KEYS; ++i) CHECK(img[0xc9c + i] == (uint8_t)(i + 1));
    CHECK(img[0xd00] == 0x11);
    CHECK(rd_le(img, 0xd01, 2) == 0x1234u);
    CHECK(img[0xd03] == 0x22);
    for (int i = 0; i < E0_MAX_CODE; ++i) {
        CHECK(img[0xd04 + i] == (uint8_t)(0x30 + i));
        CHECK(rd_le(img, 0xd4au + (size_t)i * 2u, 2) == (uint16_t)(0x100 + i));
        CHECK(rd_le(img, 0xd86u + (size_t)i * 2u, 2) == (uint16_t)(0x200 + i));
        CHECK(rd_le(img, 0xdc2u + (size_t)i * 2u, 2) == (uint16_t)(0x300 + i));
    }
    CHECK(rd_le(img, 0xd22, 2) == 0x2345u);
    CHECK(rd_le(img, 0xd24, 4) == 0x89abcdefu);
    CHECK(rd_le(img, 0xd28, 2) == 0xfffeu);
    CHECK(rd_le(img, 0xd2a, 2) == 0xfffdu);
    CHECK(rd_le(img, 0xd2c, 4) == 0x01020304u);
    CHECK(rd_le(img, 0xd30, 2) == 0x3456u);
    CHECK(rd_le(img, 0xd32, 2) == 0x4567u);
    CHECK(rd_le(img, 0xd38, 2) == 0x5678u);
    CHECK(img[0xd3a] == 0x41 && img[0xd3b] == 0x42 && img[0xd3c] == 0x43 && img[0xd3d] == 0x44 && img[0xd3e] == 0x45 &&
          img[0xd3f] == 0x46);
    CHECK(rd_le(img, 0xd40, 4) == 0xa1b2c3d4u);
    CHECK(rd_le(img, 0xd44, 4) == 0xe1f20304u);
    CHECK(rd_le(img, 0xd48, 2) == 0x6789u);
    CHECK(img[0xdfe] == 0x47 && img[0xdff] == 0x48);
    CHECK(rd_le(img, 0xe00, 4) == 0x0badf00du);
    CHECK(rd_le(img, 0xe06, 2) == 0x789au);
    CHECK(rd_le(img, 0xe08, 2) == 0x7bcdu);
    CHECK(mask[0xe09] == 1u);
}

/* ---- phase 0 --------------------------------------------------------------------------------------------------------- */

static void t_phase0_d6(void)
{
    Fx f;
    fx_init(&f, 0);
    memset(f.obj.rect_a, 0x55, sizeof f.obj.rect_a);
    memset(f.obj.rect_b, 0x55, sizeof f.obj.rect_b);
    memset(f.obj.lit, 1, sizeof f.obj.lit);
    f.obj.solved = 1;
    f.obj.waiting = 1;
    f.obj.exit_asked = 1;
    f.obj.exit_pending = 1;
    f.obj.state = 3;
    f.obj.typed = 7;
    f.obj.recorded = 3;
    f.obj.hover = 9;
    f.obj.round = 0;
    f.obj.player[0] = 5;
    f.obj.record[0] = 5;
    CHECK(visit(&f, 0) == E0_OK && f.phase == 1u && f.initialized == 1 && f.completed == 0);
    CHECK_LOG(&f, "start:1:0,slot:24:0,reg:24:0,load:4660:0,slotsurf:24:4660,prep:102:0,phase:1:0");
    CHECK(f.world.start_flag_5bb1ca == 1);
    CHECK(f.obj.active == 1u && f.obj.flag == 0u && f.obj.solved == 0u && f.obj.waiting == 0u && f.obj.row == 3 &&
          f.obj.exit_asked == 0u);
    CHECK(f.obj.rounds == 3 && f.obj.round == 1 && f.obj.set_count == 0 && f.obj.scene == E0_NO_SCENE);
    for (int i = 0; i < 100; ++i) {
        for (int k = 0; k < 4; ++k) {
            const int32_t ea[4] = {100 + 10 * i, 200 + i, 109 + 10 * i, 209 + i};
            const int32_t eb[4] = {20 * i, 0, 20 * i + 9, 9};
            if (i < 30) {
                CHECK(f.obj.rect_a[i][k] == ea[k]);
                CHECK(f.obj.rect_b[i][k] == eb[k]);
            } else {
                CHECK(f.obj.rect_a[i][k] == 0 && f.obj.rect_b[i][k] == 0);
            }
        }
    }
    CHECK(f.obj.code_len == 2 && f.obj.code_ordered == 0u && f.obj.code[0] == 1 && f.obj.code[1] == 2 && f.obj.code[2] == 0);
    for (int i = 0; i < 4; ++i) CHECK(f.obj.lit[i] == 0u);
    CHECK(f.obj.lit[4] == 1u); /* only N entries are cleared */
    for (int i = 0; i < E0_MAX_CODE; ++i) CHECK(f.obj.player[i] == -1 && f.obj.record[i] == -1);
    CHECK(f.obj.typed == 0 && f.obj.recorded == 0 && f.obj.tiles_visible == 1u && f.obj.exit_pending == 0u);
    CHECK(f.obj.slot == 24 && f.obj.surface == 0x1234u && f.obj.state == 0 && f.obj.initialized == 1u);
    CHECK(f.obj.hover == 9); /* untouched */
}

static void t_phase0_rounds(void)
{
    static const struct {
        int rounds_word, round_before, round_after, k, first;
    } c[] = {
        {3, 0, 1, 2, 1},   /* a first visit: round 1, record 0 */
        {3, 1, 1, 2, 1},   /* round 1 stays */
        {3, 2, 2, 3, 10},  /* record 1 (the first later record) */
        {3, 3, 3, 3, 11},  /* record 2 */
        {3, 5, 5, 3, 13},  /* record 4 */
        {0, 0, 0, 2, 1},   /* no rounds: round stays 0, record 0 */
        {-1, 0, 0, 2, 1},  /* a negative round count is not positive */
        {0, 4, 4, 3, 12},  /* round kept, record 3 */
        {1, 0, 1, 2, 1},
    };
    for (size_t i = 0; i < sizeof c / sizeof c[0]; ++i) {
        Fx f;
        fx_init(&f, 0);
        put16(f.body, 0x10c, c[i].rounds_word);
        f.obj.round = (int16_t)c[i].round_before;
        CHECK(visit(&f, 0) == E0_OK);
        CHECK(f.obj.rounds == c[i].rounds_word);
        CHECK(f.obj.round == c[i].round_after);
        CHECK(f.obj.code_len == c[i].k && f.obj.code[0] == c[i].first);
    }
    /* set_count counts the code sets, scene stays 9999 */
    {
        Fx f;
        fx_init(&f, 0);
        f.body[0x2d3] = 1;
        f.body[0x2d3 + 5] = 3;
        f.body[0x2d3 + 10] = 4;
        f.obj.set_count = 9;
        CHECK(visit(&f, 0) == E0_OK && f.obj.set_count == 3 && f.obj.scene == E0_NO_SCENE);
        fx_init(&f, 0);
        for (unsigned s = 0; s < 5u; ++s) f.body[0x2d3 + 5u * s] = (uint8_t)(s + 1u);
        CHECK(visit(&f, 0) == E0_OK && f.obj.set_count == 5);
        fx_init(&f, 0);
        f.obj.set_count = 4;
        CHECK(visit(&f, 0) == E0_OK && f.obj.set_count == 0);
    }
    /* the code record of the first round is copied whole: length, ordered byte, 30 code bytes */
    {
        Fx f;
        uint8_t code[E0_MAX_CODE];
        fx_init(&f, 0);
        for (int i = 0; i < E0_MAX_CODE; ++i) code[i] = (uint8_t)(0xe0 + i);
        set_code(f.body, 0x45, 30, 1, code, sizeof code);
        CHECK(visit(&f, 0) == E0_OK && f.obj.code_len == 30 && f.obj.code_ordered == 1u);
        for (int i = 0; i < E0_MAX_CODE; ++i) CHECK(f.obj.code[i] == (uint8_t)(0xe0 + i));
    }
}

static void t_phase0_surface_and_sound(void)
{
    Fx f;
    /* a surface already held is reused */
    fx_init(&f, 0);
    f.obj.surface = 0x777u;
    CHECK(visit(&f, 0) == E0_OK && f.obj.surface == 0x777u);
    CHECK_LOG(&f, "start:1:0,slot:24:0,reg:24:1911,slotsurf:24:1911,prep:102:0,phase:1:0");
    /* sound A "NO SOUND" is not prepared */
    fx_init(&f, 0);
    set_rec(f.body, 0x66, "NO SOUND");
    CHECK(visit(&f, 0) == E0_OK);
    CHECK_LOG(&f, "start:1:0,slot:24:0,reg:24:0,load:4660:0,slotsurf:24:4660,phase:1:0");
    CHECK(f.n_prepare == 0);
    /* the compare covers nine bytes: "NO SOUND" followed by a non-NUL byte is a sound; so is a one byte difference */
    fx_init(&f, 0);
    memcpy(f.body + 0x66, "NO SOUND", 8);
    f.body[0x66 + 8] = 'X';
    CHECK(visit(&f, 0) == E0_OK && f.n_prepare == 1);
    fx_init(&f, 0);
    memcpy(f.body + 0x66, "NO SOUNX", 8);
    f.body[0x66 + 8] = 0;
    CHECK(visit(&f, 0) == E0_OK && f.n_prepare == 1);
    fx_init(&f, 0);
    memcpy(f.body + 0x66, "no sound", 8);
    CHECK(visit(&f, 0) == E0_OK && f.n_prepare == 1);
    /* a different slot from the host */
    fx_init(&f, 0);
    f.next_slot = 0x3f;
    CHECK(visit(&f, 0) == E0_OK && f.obj.slot == 0x3f);
    CHECK(strstr(f.log, "slot:63:0,reg:63:0") != NULL);
    /* the visit without observer works */
    fx_init(&f, 0);
    f.host.observe = NULL;
    CHECK(visit(&f, 0) == E0_OK && f.log[0] == '\0' && f.obj.initialized == 1u && f.phase == 1u);
}

static void expect_layout(const Fx *f, int cols, int rows, int w, int h, int x0, int y0, int xg, int yg, int x0b, int y0b,
                          int xgb, int ygb)
{
    const int n = cols * rows;
    for (int i = 0; i < n; ++i) {
        const int c = i % cols, r = i / cols;
        const int32_t la = x0 + c * (w + xg), ta = y0 + r * (h + yg);
        const int32_t lb = x0b + c * (w + xgb), tb = y0b + r * (h + ygb);
        CHECK(f->obj.rect_a[i][0] == la && f->obj.rect_a[i][1] == ta && f->obj.rect_a[i][2] == la + w &&
              f->obj.rect_a[i][3] == ta + h);
        CHECK(f->obj.rect_b[i][0] == lb && f->obj.rect_b[i][1] == tb && f->obj.rect_b[i][2] == lb + w &&
              f->obj.rect_b[i][3] == tb + h);
    }
    for (int k = 0; k < 4 && n < E0_MAX_KEYS; ++k) {
        CHECK(f->obj.rect_a[n][k] == 0 && f->obj.rect_b[n][k] == 0);
        CHECK(f->obj.rect_a[99][k] == 0 && f->obj.rect_b[99][k] == 0);
    }
}

static void layout_case(int cols, int rows, int w, int h, int x0, int y0, int xg, int yg, int x0b, int y0b, int xgb, int ygb)
{
    Fx f;
    fx_init(&f, 1);
    put16(f.body, 0x10e, cols);
    put16(f.body, 0x110, rows);
    put16(f.body, 0x112, w);
    put16(f.body, 0x114, h);
    put16(f.body, 0x116, x0);
    put16(f.body, 0x118, y0);
    put16(f.body, 0x11a, xg);
    put16(f.body, 0x11c, yg);
    put16(f.body, 0x11e, x0b);
    put16(f.body, 0x120, y0b);
    put16(f.body, 0x122, xgb);
    put16(f.body, 0x124, ygb);
    memset(f.obj.rect_a, 0x66, sizeof f.obj.rect_a);
    memset(f.obj.rect_b, 0x66, sizeof f.obj.rect_b);
    CHECK(visit(&f, 0) == E0_OK && f.phase == 1u);
    CHECK(get16(f.body, 0x21) == (int16_t)(cols * rows)); /* phase 0 stores N into the body */
    expect_layout(&f, cols, rows, w, h, x0, y0, xg, yg, x0b, y0b, xgb, ygb);
}

static void t_phase0_e0_layout(void)
{
    Fx f;
    layout_case(2, 2, 10, 8, 5, 6, 3, 4, 100, 50, 6, 2);
    layout_case(3, 4, 10, 8, 5, 6, 3, 4, 100, 50, 6, 2);   /* 3 columns x 4 rows */
    layout_case(4, 3, 10, 8, 5, 6, 3, 4, 100, 50, 6, 2);   /* 4 columns x 3 rows: a different split */
    layout_case(5, 1, 10, 8, 5, 6, 3, 4, 100, 50, 6, 2);
    layout_case(1, 7, 10, 8, 5, 6, 3, 4, 100, 50, 6, 2);
    layout_case(3, 3, 10, 8, -3, -7, -4, -2, 200, 30, -3, -1);  /* negative start and gaps */
    layout_case(4, 2, 12, 9, 0, 0, -12, -9, 0, 0, -12, -9);    /* gaps cancelling the sizes: overlapping keys */
    layout_case(3, 3, -5, -6, 20, 30, 1, 2, 40, 50, 3, 4);     /* negative sizes */
    layout_case(3, 2, 10, 8, 5, 6, 3, 4, -100, -50, -6, -2);  /* negative destination origin and gaps */
    layout_case(10, 10, 300, 200, 30000, 29000, 500, 400, 32000, 31000, 100, 50); /* products beyond 16 bits */
    layout_case(100, 1, 7, 7, 1, 1, 0, 0, 2, 2, 0, 0);
    layout_case(1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    /* the columns drive the split, not the rows: 6 keys as 2 x 3 and 3 x 2 differ in key 2 */
    fx_init(&f, 1);
    put16(f.body, 0x10e, 2);
    put16(f.body, 0x110, 3);
    CHECK(visit(&f, 0) == E0_OK && f.obj.rect_a[2][0] == 5 && f.obj.rect_a[2][1] == 6 + 12);
    fx_init(&f, 1);
    put16(f.body, 0x10e, 3);
    put16(f.body, 0x110, 2);
    CHECK(visit(&f, 0) == E0_OK && f.obj.rect_a[2][0] == 5 + 2 * 13 && f.obj.rect_a[2][1] == 6);
    /* N = 0 by 16-bit overflow and by a zero dimension: no keys, no division */
    fx_init(&f, 1);
    put16(f.body, 0x10e, 256);
    put16(f.body, 0x110, 256);
    put16(f.body, 0x21, 77);
    CHECK(visit(&f, 0) == E0_OK && get16(f.body, 0x21) == 0 && f.obj.rect_a[0][2] == 0 && f.obj.rect_b[0][2] == 0);
    fx_init(&f, 1);
    put16(f.body, 0x10e, 0);
    put16(f.body, 0x110, 9);
    CHECK(visit(&f, 0) == E0_OK && get16(f.body, 0x21) == 0 && f.obj.rect_b[0][2] == 0);
    /* the other e0 fields */
    fx_init(&f, 1);
    f.obj.round = 4;
    f.obj.rounds = 9;
    f.obj.set_count = 6;
    f.obj.scene = 77;
    f.obj.flag = 0;
    CHECK(visit(&f, 0) == E0_OK);
    CHECK(f.obj.flag == 1u && f.obj.rounds == 1 && f.obj.round == 0 && f.obj.set_count == 0 && f.obj.scene == 5);
    CHECK(f.obj.code_len == 2 && f.obj.code[0] == 1 && f.obj.code[1] == 2);
    put16(f.body, 0x10c, E0_NO_SCENE);
    CHECK(visit(&f, 0) == E0_OK && f.obj.scene == E0_NO_SCENE);
    put16(f.body, 0x10c, 0);
    CHECK(visit(&f, 0) == E0_OK && f.obj.scene == 0);
    put16(f.body, 0x10c, -1);
    CHECK(visit(&f, 0) == E0_OK && f.obj.scene == -1);
    /* raw 0xe0 ignores the rounds of 0xd6 and takes record 0 even when a round was left behind in the process word */
    fx_init(&f, 1);
    f.obj.round = 3;
    CHECK(visit(&f, 0) == E0_OK && f.obj.round == 0 && f.obj.code_len == 2);
}

static void t_phase0_failures(void)
{
    Fx f;
    E0Result r;
    const char *why = NULL;
    /* each host failure after its predecessors' effects */
    fx_init(&f, 0);
    f.fail_alloc = 1;
    CHECK(visit(&f, 0) == E0_ERR_HOST);
    CHECK_LOG(&f, "start:1:0");
    fx_init(&f, 0);
    f.fail_register = 1;
    CHECK(visit(&f, 0) == E0_ERR_HOST);
    CHECK_LOG(&f, "start:1:0,slot:24:0");
    fx_init(&f, 0);
    f.fail_load = 1;
    CHECK(visit(&f, 0) == E0_ERR_HOST);
    CHECK_LOG(&f, "start:1:0,slot:24:0,reg:24:0");
    CHECK(f.obj.surface == 0u && f.obj.initialized == 0u);
    fx_init(&f, 0);
    f.fail_setsurf = 1;
    CHECK(visit(&f, 0) == E0_ERR_HOST);
    CHECK_LOG(&f, "start:1:0,slot:24:0,reg:24:0,load:4660:0");
    fx_init(&f, 0);
    f.fail_prepare = 1;
    CHECK(visit(&f, 0) == E0_ERR_HOST);
    CHECK_LOG(&f, "start:1:0,slot:24:0,reg:24:0,load:4660:0,slotsurf:24:4660");
    CHECK(f.obj.initialized == 0u && f.phase == 0u && f.initialized == 0);
    /* a refused body: no effect at all, the reason is reported */
    fx_init(&f, 0);
    put16(f.body, 0x21, 101);
    CHECK(visit(&f, 0) == E0_ERR_BODY && f.log[0] == '\0' && f.why != NULL && strcmp(f.why, "keypad-key-count") == 0);
    CHECK(f.obj.active == 0u && f.world.start_flag_5bb1ca == 0 && f.phase == 0u);
    fx_init(&f, 1);
    f.body_len = 200;
    CHECK(visit(&f, 0) == E0_ERR_BODY && f.log[0] == '\0' && strcmp(f.why, "keypad-body-length") == 0);
    /* phase 0 loads the record of the round left behind by the previous scene: a record outside the body or with a code length
     * above 30 is refused after the start flag effect */
    fx_init(&f, 0);
    f.obj.round = 50;
    CHECK(visit(&f, 0) == E0_ERR_BOUNDS && f.obj.initialized == 0u && f.initialized == 0);
    CHECK_LOG(&f, "start:1:0");
    fx_init(&f, 0);
    f.obj.round = 6; /* record 4 lies on the code sets */
    f.body[0x2d3] = 40;
    CHECK(visit(&f, 0) == E0_ERR_BOUNDS);
    CHECK_LOG(&f, "start:1:0");
    /* phases above 2 do nothing and do not even look at the body */
    fx_init(&f, 0);
    put16(f.body, 0x21, 101);
    for (uint32_t p = 3u; p < 8u; ++p) CHECK(visit(&f, p) == E0_OK && f.phase == p && f.log[0] == '\0' && f.initialized == 0);
    CHECK(visit(&f, 0xffffffffu) == E0_OK && f.phase == 0xffffffffu && f.log[0] == '\0');
    /* phases 1 and 2 need this visit's phase 0 on the same row */
    fx_init(&f, 0);
    CHECK(visit(&f, 1) == E0_ERR_UNSUPPORTED && f.why != NULL && strcmp(f.why, "keypad-phase-without-init") == 0 && f.log[0] == '\0');
    CHECK(visit(&f, 2) == E0_ERR_UNSUPPORTED && f.log[0] == '\0' && f.phase == 2u);
    CHECK(visit(&f, 0) == E0_OK);
    f.log[0] = '\0';
    CHECK(visit_row(&f, 4, 1) == E0_ERR_UNSUPPORTED && f.log[0] == '\0');
    CHECK(visit_row(&f, 4, 2) == E0_ERR_UNSUPPORTED && f.log[0] == '\0');
    CHECK(visit_row(&f, 3, 1) == E0_OK);
    f.obj.initialized = 0u;
    CHECK(visit(&f, 1) == E0_ERR_UNSUPPORTED);
    /* arguments */
    fx_init(&f, 0);
    CHECK(e0_step(NULL, f.body, f.body_len, 0, 3, 0, &f.world, &f.host, &r, &why) == E0_ERR_ARGUMENT);
    CHECK(e0_step(&f.obj, NULL, f.body_len, 0, 3, 0, &f.world, &f.host, &r, &why) == E0_ERR_ARGUMENT);
    CHECK(e0_step(&f.obj, f.body, f.body_len, 0, 3, 0, NULL, &f.host, &r, &why) == E0_ERR_ARGUMENT);
    CHECK(e0_step(&f.obj, f.body, f.body_len, 0, 3, 0, &f.world, NULL, &r, &why) == E0_ERR_ARGUMENT);
    CHECK(e0_step(&f.obj, f.body, f.body_len, 0, 3, 0, &f.world, &f.host, NULL, &why) == E0_ERR_ARGUMENT);
    CHECK(e0_step(&f.obj, f.body, f.body_len, 0, 3, 0, &f.world, &f.host, &r, NULL) == E0_OK);
    CHECK(e0_step(&f.obj, f.body, f.body_len, 2, 3, 0, &f.world, &f.host, &r, &why) == E0_ERR_BODY);
    CHECK(f.log[0] != '\0'); /* the NULL failure pointer visit ran phase 0 */
}

#define HOST_FIELDS(X)                                                                                              \
    X(alloc_slot) X(register_slot) X(load_surface) X(set_slot_surface) X(release_surface) X(release_slot)          \
    X(mark_dirty) X(view_origin) X(sound_prepare) X(sound_stop) X(sound_play) X(sound_busy) X(tick) X(transition) \
    X(store_event_flag) X(event_flag_invalid)

static void t_incomplete_host(void)
{
    static const size_t offs[] = {
#define X(name) offsetof(E0Host, name),
        HOST_FIELDS(X)
#undef X
    };
    for (size_t i = 0; i < sizeof offs / sizeof offs[0]; ++i) {
        Fx f;
        E0Result r;
        E0RenderPlan plan;
        uint32_t np = 0;
        const char *why = NULL;
        E0Host broken;
        fx_init(&f, 0);
        broken = f.host;
        memset((char *)&broken + offs[i], 0, sizeof(broken.alloc_slot));
        CHECK(e0_step(&f.obj, f.body, f.body_len, 0, 3, 0, &f.world, &broken, &r, &why) == E0_ERR_ARGUMENT);
        CHECK(f.log[0] == '\0' && f.obj.active == 0u);
        CHECK(e0_click(&f.obj, f.body, f.body_len, 1u, E0_CANDIDATE_KEY, 1, &broken, &np) == E0_ERR_ARGUMENT);
        CHECK(e0_invalidate(&f.obj, &broken) == E0_ERR_ARGUMENT);
        CHECK(e0_cleanup(&f.obj, &broken) == E0_ERR_ARGUMENT);
        CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &broken, &plan) == E0_ERR_ARGUMENT);
    }
    {
        Fx f;
        E0Result r;
        E0RenderPlan plan;
        uint32_t np;
        const char *why;
        fx_init(&f, 0);
        CHECK(e0_click(&f.obj, f.body, f.body_len, 1u, 0, 1, NULL, &np) == E0_ERR_ARGUMENT);
        CHECK(e0_click(NULL, f.body, f.body_len, 1u, 0, 1, &f.host, &np) == E0_ERR_ARGUMENT);
        CHECK(e0_click(&f.obj, NULL, f.body_len, 1u, 0, 1, &f.host, &np) == E0_ERR_ARGUMENT);
        CHECK(e0_click(&f.obj, f.body, f.body_len, 1u, 0, 1, &f.host, NULL) == E0_ERR_ARGUMENT);
        CHECK(e0_invalidate(NULL, &f.host) == E0_ERR_ARGUMENT);
        CHECK(e0_invalidate(&f.obj, NULL) == E0_ERR_ARGUMENT);
        CHECK(e0_cleanup(NULL, &f.host) == E0_ERR_ARGUMENT);
        CHECK(e0_cleanup(&f.obj, NULL) == E0_ERR_ARGUMENT);
        CHECK(e0_render_plan(NULL, f.body, f.body_len, &f.host, &plan) == E0_ERR_ARGUMENT);
        CHECK(e0_render_plan(&f.obj, NULL, f.body_len, &f.host, &plan) == E0_ERR_ARGUMENT);
        CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, NULL) == E0_ERR_ARGUMENT);
        CHECK(e0_render_plan(&f.obj, f.body, f.body_len, NULL, &plan) == E0_ERR_ARGUMENT);
        (void)r;
        (void)why;
    }
}

/* ---- phase 1: state 0 ------------------------------------------------------------------------------------------------ */

static void t_state0_solved_advance(void)
{
    Fx f;
    static const struct {
        int round, rounds_word, keep_solved;
    } c[] = {
        {1, 3, 0}, {2, 3, 0}, {3, 3, 1}, {4, 3, 1}, {0, 3, 1}, {1, 1, 1}, {1, 2, 0}, {-1, 3, 1}, {1, 0, 1},
    };
    for (size_t i = 0; i < sizeof c / sizeof c[0]; ++i) {
        fx_init(&f, 0);
        f.body[0x24] = 0; /* no exit button */
        put16(f.body, 0x10c, c[i].rounds_word);
        start(&f);
        f.obj.solved = 1;
        f.obj.typed = 2;
        PLAYER(&f.obj, 1, 2);
        f.obj.round = (int16_t)c[i].round;
        CHECK(visit(&f, 1) == E0_OK && f.phase == 1u);
        CHECK(f.obj.state == 1 && f.log[0] == '\0');
        if (c[i].keep_solved) {
            CHECK(f.obj.solved == 1u && f.obj.typed == 2 && f.obj.player[0] == 1 && f.obj.player[1] == 2);
        } else {
            CHECK(f.obj.solved == 0u && f.obj.typed == 0);
            for (int k = 0; k < E0_MAX_CODE; ++k) CHECK(f.obj.player[k] == -1);
        }
    }
    /* raw 0xe0: the rounds compared are the body word at +0x10c (the scene word), not the object's own count */
    for (int round = 0; round < 7; ++round) {
        fx_init(&f, 1);
        f.body[0x24] = 0;
        start(&f);
        f.obj.solved = 1;
        f.obj.typed = 2;
        f.obj.round = (int16_t)round;
        CHECK(visit(&f, 1) == E0_OK && f.obj.state == 1);
        CHECK(f.obj.solved == (uint8_t)((round > 0 && round < 5) ? 0 : 1));
    }
    /* the exit button present: solved alone does not advance */
    fx_init(&f, 0);
    start(&f);
    f.obj.solved = 1;
    CHECK(visit(&f, 1) == E0_OK && f.obj.state == 0);
    /* waiting: solved does not advance (the waiting block runs instead) */
    fx_init(&f, 0);
    f.body[0x24] = 0;
    start(&f);
    f.obj.solved = 1;
    f.obj.waiting = 1;
    f.obj.wait_deadline = 5000u;
    CHECK(visit(&f, 1) == E0_OK && f.obj.state == 0 && f.obj.waiting == 1u);
    CHECK_LOG(&f, "tick:1000:0");
    /* solved, no exit button, round advance leaves the flag for the exit-less final round */
    fx_init(&f, 1);
    f.body[0x24] = 0;
    start(&f);
    f.obj.solved = 1;
    f.obj.round = 0;
    CHECK(visit(&f, 1) == E0_OK && f.obj.state == 1 && f.obj.solved == 1u);
}

static void check_typed(int ordered_record, int k, const uint8_t *code, const int16_t *player, int typed, int expect_solved,
                        int preset_solved)
{
    Fx f;
    fx_init(&f, 0);
    start(&f);
    f.obj.code_len = (int16_t)k;
    f.obj.code_ordered = (uint8_t)ordered_record;
    memset(f.obj.code, 0, sizeof f.obj.code);
    memcpy(f.obj.code, code, (size_t)k);
    memcpy(f.obj.player, player, sizeof f.obj.player);
    f.obj.typed = (int16_t)typed;
    f.obj.solved = (uint8_t)preset_solved;
    CHECK(visit(&f, 1) == E0_OK);
    CHECK(f.obj.solved == (uint8_t)expect_solved);
    CHECK(f.log[0] == '\0' && f.obj.state == 0);
}

static void t_state0_typed_code(void)
{
    Fx f;
    int16_t p[E0_MAX_CODE];
    uint8_t code[E0_MAX_CODE];
    /* unordered record */
    memset(code, 0, sizeof code);
    code[0] = 1;
    code[1] = 2;
    for (int i = 0; i < E0_MAX_CODE; ++i) p[i] = -1;
    p[0] = 1;
    p[1] = 2;
    check_typed(0, 2, code, p, 2, 1, 0);
    p[0] = 2;
    p[1] = 1;
    check_typed(0, 2, code, p, 2, 1, 0); /* any order */
    p[0] = 1;
    p[1] = 3;
    check_typed(0, 2, code, p, 2, 0, 1); /* wrong key */
    p[0] = 3;
    p[1] = 2;
    check_typed(0, 2, code, p, 2, 0, 1);
    p[0] = 1;
    p[1] = 1;
    check_typed(0, 2, code, p, 2, 0, 1); /* the same key twice does not count twice */
    /* typed != length: the flag is not touched */
    p[0] = 1;
    p[1] = 2;
    check_typed(0, 2, code, p, 1, 1, 1);
    check_typed(0, 2, code, p, 1, 0, 0);
    check_typed(0, 2, code, p, 3, 1, 1);
    check_typed(0, 2, code, p, 0, 0, 0);
    p[1] = 3; /* a wrong code is not examined unless the count equals the length */
    check_typed(0, 2, code, p, 3, 1, 1);
    check_typed(0, 2, code, p, 1, 1, 1);
    check_typed(1, 2, code, p, 3, 1, 1);
    check_typed(1, 2, code, p, 1, 1, 1);
    p[1] = 2;
    /* length 0 never checks */
    check_typed(0, 0, code, p, 0, 1, 1);
    check_typed(0, 0, code, p, 0, 0, 0);
    /* the original quirk: a match writes -1 at index K, not at the matched index, so a repeated code byte matches again */
    code[0] = 2;
    code[1] = 2;
    p[0] = 2;
    p[1] = 3;
    check_typed(0, 2, code, p, 2, 1, 0);
    code[0] = 1;
    code[1] = 2;
    /* the code byte is unsigned: 255 is not the empty entry -1 */
    code[0] = 255;
    for (int i = 0; i < E0_MAX_CODE; ++i) p[i] = -1;
    check_typed(0, 1, code, p, 1, 0, 1);
    check_typed(1, 1, code, p, 1, 0, 1);
    p[0] = 255;
    check_typed(0, 1, code, p, 1, 1, 0);
    check_typed(1, 1, code, p, 1, 1, 0);
    /* ordered record: position by position */
    code[0] = 1;
    code[1] = 2;
    for (int i = 0; i < E0_MAX_CODE; ++i) p[i] = -1;
    p[0] = 1;
    p[1] = 2;
    check_typed(1, 2, code, p, 2, 1, 0);
    p[0] = 2;
    p[1] = 1;
    check_typed(1, 2, code, p, 2, 0, 1);
    p[0] = 1;
    p[1] = 3;
    check_typed(1, 2, code, p, 2, 0, 1);
    p[0] = 3;
    p[1] = 2;
    check_typed(1, 2, code, p, 2, 0, 1);
    /* a flag byte other than 1 is ordered */
    check_typed(7, 2, code, p, 2, 0, 1);
    /* the scratch copy and the index K write */
    fx_init(&f, 0);
    start(&f);
    f.obj.code_len = 2;
    f.obj.code_ordered = 0;
    memset(f.obj.code, 0, sizeof f.obj.code);
    f.obj.code[0] = 1;
    f.obj.code[1] = 2;
    PLAYER(&f.obj, 1, 2);
    f.obj.typed = 2;
    memset(f.obj.scratch, 0x33, sizeof f.obj.scratch);
    CHECK(visit(&f, 1) == E0_OK && f.obj.solved == 1u);
    CHECK(f.obj.scratch[0] == 1 && f.obj.scratch[1] == 2 && f.obj.scratch[2] == -1); /* matched indices untouched */
    /* the compare stops at the first missing code byte: scratch is the copy taken for that byte */
    PLAYER(&f.obj, 5, 2, 9);
    CHECK(visit(&f, 1) == E0_OK && f.obj.solved == 0u && f.obj.scratch[2] == 9);
    /* the unordered compare of a failing key leaves scratch as a copy */
    PLAYER(&f.obj, 1, 5);
    CHECK(visit(&f, 1) == E0_OK && f.obj.solved == 0u && f.obj.scratch[1] == 5);
    /* length 30: the write at index K lands on record[0] */
    fx_init(&f, 0);
    start(&f);
    f.obj.code_len = 30;
    f.obj.code_ordered = 0;
    for (int i = 0; i < E0_MAX_CODE; ++i) {
        f.obj.code[i] = (uint8_t)(i + 1);
        f.obj.player[i] = (int16_t)(i + 1);
    }
    f.obj.typed = 30;
    f.obj.record[0] = 7;
    f.obj.record[1] = 8;
    CHECK(visit(&f, 1) == E0_OK && f.obj.solved == 1u && f.obj.record[0] == -1 && f.obj.record[1] == 8);
    /* ordered length 30 */
    f.obj.code_ordered = 1;
    f.obj.record[0] = 7;
    CHECK(visit(&f, 1) == E0_OK && f.obj.solved == 1u && f.obj.record[0] == 7);
    f.obj.player[29] = 5;
    CHECK(visit(&f, 1) == E0_OK && f.obj.solved == 0u);
    /* length 29: the index K write lands on scratch[29], not on record[0] */
    fx_init(&f, 0);
    start(&f);
    f.obj.code_len = 29;
    f.obj.code_ordered = 0;
    for (int i = 0; i < E0_MAX_CODE; ++i) {
        f.obj.code[i] = (uint8_t)(i + 1);
        f.obj.player[i] = (int16_t)(i + 1);
    }
    f.obj.typed = 29;
    f.obj.record[0] = 7;
    CHECK(visit(&f, 1) == E0_OK && f.obj.solved == 1u && f.obj.record[0] == 7 && f.obj.scratch[29] == -1);
    /* only the first K scratch entries are searched: the entry at index K is not a candidate */
    fx_init(&f, 0);
    start(&f);
    f.obj.code_len = 2;
    f.obj.code_ordered = 0;
    memset(f.obj.code, 0, sizeof f.obj.code);
    f.obj.code[0] = 1;
    f.obj.code[1] = 2;
    PLAYER(&f.obj, 2, 5, 1);
    f.obj.typed = 2;
    CHECK(visit(&f, 1) == E0_OK && f.obj.solved == 0u);
    /* waiting suppresses the compare */
    fx_init(&f, 0);
    start(&f);
    PLAYER(&f.obj, 1, 2);
    f.obj.typed = 2;
    f.obj.waiting = 1;
    f.obj.wait_deadline = 99999u;
    CHECK(visit(&f, 1) == E0_OK && f.obj.solved == 0u);
    /* no exit button and nothing solved: the state stays 0 and nothing happens */
    fx_init(&f, 0);
    f.body[0x24] = 0;
    start(&f);
    CHECK(visit(&f, 1) == E0_OK && f.obj.state == 0 && f.log[0] == '\0');
}

static void t_state0_ordered_wrap(void)
{
    Fx f;
    /* body ordered: typed >= N clears the keys, the typed keys and the count (N = 4) */
    static const struct {
        int ordered, typed, cleared;
    } c[] = {{1, 4, 1}, {1, 5, 1}, {1, 3, 0}, {1, 0, 0}, {0, 4, 0}, {0, 9, 0}, {2, 4, 1}};
    for (size_t i = 0; i < sizeof c / sizeof c[0]; ++i) {
        fx_init(&f, 0);
        start(&f);
        f.body[0x23] = (uint8_t)c[i].ordered;
        f.obj.typed = (int16_t)c[i].typed;
        memset(f.obj.lit, 1, sizeof f.obj.lit);
        PLAYER(&f.obj, 3, 1, 0, 2);
        f.obj.code_len = 0;
        CHECK(visit(&f, 1) == E0_OK && f.log[0] == '\0');
        if (c[i].cleared) {
            for (int k = 0; k < E0_MAX_KEYS; ++k) CHECK(f.obj.lit[k] == 0u);
            for (int k = 0; k < E0_MAX_CODE; ++k) CHECK(f.obj.player[k] == -1);
            CHECK(f.obj.typed == 0);
        } else {
            for (int k = 0; k < E0_MAX_KEYS; ++k) CHECK(f.obj.lit[k] == 1u);
            CHECK(f.obj.typed == c[i].typed && f.obj.player[0] == 3);
        }
    }
    /* the compare happens first: a solved ordered code stays solved after the wrap clears the typed keys */
    fx_init(&f, 0);
    start(&f);
    f.body[0x23] = 1;
    f.obj.code_len = 4;
    f.obj.code_ordered = 1;
    f.obj.code[0] = 0;
    f.obj.code[1] = 1;
    f.obj.code[2] = 2;
    f.obj.code[3] = 3;
    PLAYER(&f.obj, 0, 1, 2, 3);
    f.obj.typed = 4;
    CHECK(visit(&f, 1) == E0_OK && f.obj.solved == 1u && f.obj.typed == 0 && f.obj.player[0] == -1);
}

static void t_state0_waiting(void)
{
    Fx f;
    /* now <= deadline keeps waiting (jbe) */
    fx_init(&f, 0);
    start(&f);
    f.obj.waiting = 1;
    f.obj.wait_deadline = 1000u;
    memset(f.obj.lit, 1, sizeof f.obj.lit);
    f.obj.hover = 2;
    CHECK(visit(&f, 1) == E0_OK);
    CHECK_LOG(&f, "tick:1000:0");
    CHECK(f.obj.waiting == 1u && f.obj.lit[0] == 1u && f.obj.state == 0);
    T(&f, 999u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.waiting == 1u);
    /* now > deadline: the first N keys are released unless the hover is the exit button */
    f.log[0] = '\0';
    T(&f, 1001u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.waiting == 0u);
    CHECK_LOG(&f, "tick:1001:0");
    for (int i = 0; i < 4; ++i) CHECK(f.obj.lit[i] == 0u);
    for (int i = 4; i < E0_MAX_KEYS; ++i) CHECK(f.obj.lit[i] == 1u);
    /* hover 0x28 keeps the keys */
    fx_init(&f, 0);
    start(&f);
    f.obj.waiting = 1;
    f.obj.wait_deadline = 5u;
    memset(f.obj.lit, 1, sizeof f.obj.lit);
    f.obj.hover = E0_EXIT_KEY;
    CHECK(visit(&f, 1) == E0_OK && f.obj.waiting == 0u && f.obj.lit[0] == 1u && f.obj.lit[3] == 1u);
    f.obj.waiting = 1;
    f.obj.hover = -1;
    CHECK(visit(&f, 1) == E0_OK && f.obj.waiting == 0u && f.obj.lit[0] == 0u);
    f.obj.waiting = 1;
    f.obj.hover = 0x27; /* not the exit key */
    f.obj.lit[2] = 1;
    CHECK(visit(&f, 1) == E0_OK && f.obj.lit[2] == 0u);
    /* the tick compare is unsigned: a deadline that wrapped keeps waiting until the clock wraps too */
    fx_init(&f, 0);
    start(&f);
    f.obj.waiting = 1;
    f.obj.wait_deadline = 0xffffff00u;
    memset(f.obj.lit, 1, sizeof f.obj.lit);
    T(&f, 0x10u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.waiting == 1u && f.obj.lit[0] == 1u);
    T(&f, 0xffffff00u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.waiting == 1u);
    T(&f, 0xffffff01u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.waiting == 0u && f.obj.lit[0] == 0u);
    /* the typed-code check runs after the waiting block in the same visit */
    fx_init(&f, 0);
    start(&f);
    f.obj.waiting = 1;
    f.obj.wait_deadline = 5u;
    PLAYER(&f.obj, 1, 2);
    f.obj.typed = 2;
    f.obj.hover = 1;
    T(&f, 10u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.waiting == 0u && f.obj.solved == 1u);
    /* ... and a still waiting visit stops before it */
    fx_init(&f, 0);
    start(&f);
    f.obj.waiting = 1;
    f.obj.wait_deadline = 50u;
    PLAYER(&f.obj, 1, 2);
    f.obj.typed = 2;
    T(&f, 10u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.solved == 0u);
    /* the ordered-mode wrap also runs after a waiting release */
    fx_init(&f, 0);
    start(&f);
    f.body[0x23] = 1;
    f.obj.waiting = 1;
    f.obj.wait_deadline = 5u;
    f.obj.typed = 4;
    memset(f.obj.lit, 1, sizeof f.obj.lit);
    T(&f, 10u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.typed == 0 && f.obj.lit[50] == 0u);
}

static void t_state0_exit_pending(void)
{
    Fx f;
    /* solved: the visit ends in state 1 with the typed keys cleared and the record count zeroed */
    {
        static const struct {
            int round, keep;
        } c[] = {{1, 0}, {2, 0}, {3, 1}, {0, 1}, {4, 1}};
        for (size_t i = 0; i < sizeof c / sizeof c[0]; ++i) {
            fx_init(&f, 0);
            start(&f);
            f.obj.waiting = 1;
            f.obj.exit_pending = 1;
            f.obj.wait_deadline = 0u;
            f.obj.solved = 1;
            f.obj.typed = 2;
            f.obj.recorded = 3;
            f.obj.round = (int16_t)c[i].round;
            PLAYER(&f.obj, 5, 6);
            T(&f, 1u);
            CHECK(visit(&f, 1) == E0_OK && f.phase == 1u);
            CHECK_LOG(&f, "tick:1:0");
            CHECK(f.obj.waiting == 0u && f.obj.exit_pending == 0u && f.obj.recorded == 0 && f.obj.state == 1);
            CHECK(f.obj.typed == 0 && f.obj.player[0] == -1 && f.obj.player[1] == -1);
            CHECK(f.obj.solved == (uint8_t)c[i].keep);
        }
    }
    for (int round = 0; round < 7; ++round) { /* raw 0xe0: the body word 5 bounds the rounds */
        fx_init(&f, 1);
        start(&f);
        f.obj.waiting = 1;
        f.obj.exit_pending = 1;
        f.obj.wait_deadline = 0u;
        f.obj.solved = 1;
        f.obj.round = (int16_t)round;
        T(&f, 1u);
        CHECK(visit(&f, 1) == E0_OK && f.obj.state == 1);
        CHECK(f.obj.solved == (uint8_t)((round > 0 && round < 5) ? 0 : 1));
    }
    /* unsolved without code sets, scene 9999 (raw 0xd6): the keys are cleared and the state stays */
    fx_init(&f, 0);
    start(&f);
    f.obj.waiting = 1;
    f.obj.exit_pending = 1;
    f.obj.wait_deadline = 0u;
    f.obj.typed = 2;
    f.obj.recorded = 3;
    memset(f.obj.lit, 1, sizeof f.obj.lit);
    PLAYER(&f.obj, 5, 6);
    T(&f, 1u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.state == 0 && f.obj.recorded == 0 && f.obj.typed == 0 && f.obj.player[0] == -1);
    for (int i = 0; i < E0_MAX_KEYS; ++i) CHECK(f.obj.lit[i] == 0u);
    /* raw 0xe0: a scene word other than 9999 moves on to state 1 when the order does not matter */
    {
        static const struct {
            int scene, ordered, typed, expect_state, lit_cleared;
        } c[] = {
            {5, 0, 2, 1, 0}, {5, 0, 0, 1, 0}, {5, 1, 0, 1, 0}, {5, 1, 2, 0, 1},
            {E0_NO_SCENE, 0, 0, 0, 1}, {E0_NO_SCENE, 1, 0, 0, 1}, {0, 0, 1, 1, 0}, {-1, 1, 0, 1, 0},
        };
        for (size_t i = 0; i < sizeof c / sizeof c[0]; ++i) {
            fx_init(&f, 1);
            put16(f.body, 0x10c, c[i].scene);
            f.body[0x23] = (uint8_t)c[i].ordered;
            start(&f);
            f.obj.waiting = 1;
            f.obj.exit_pending = 1;
            f.obj.wait_deadline = 0u;
            f.obj.typed = (int16_t)c[i].typed;
            memset(f.obj.lit, 1, sizeof f.obj.lit);
            T(&f, 1u);
            CHECK(visit(&f, 1) == E0_OK && f.obj.state == c[i].expect_state);
            CHECK(f.obj.lit[0] == (c[i].lit_cleared ? 0u : 1u) && f.obj.lit[99] == (c[i].lit_cleared ? 0u : 1u));
            CHECK(f.obj.typed == 0);
        }
    }
}

static void sets_fixture(Fx *f, int n)
{
    fx_init(f, 0);
    put16(f->body, 0x21, n);
    /* set 0 {1,2}, set 1 {3}, set 2 {1,2,3,4}, set 3 {1,1}, set 4 {2,2} */
    f->body[0x2d3 + 0] = 1;
    f->body[0x2d3 + 1] = 2;
    f->body[0x2d3 + 5] = 3;
    f->body[0x2d3 + 10] = 1;
    f->body[0x2d3 + 11] = 2;
    f->body[0x2d3 + 12] = 3;
    f->body[0x2d3 + 13] = 4;
    f->body[0x2d3 + 15] = 1;
    f->body[0x2d3 + 16] = 1;
    f->body[0x2d3 + 20] = 2;
    f->body[0x2d3 + 21] = 2;
    start(f);
    f->obj.waiting = 1;
    f->obj.exit_pending = 1;
    f->obj.wait_deadline = 0u;
    f->obj.typed = 1;
    T(f, 1u);
}

static void t_state0_code_sets(void)
{
    Fx f;
    /* only set 0 and 1 are live (set_count 2): record {0,1} completes set 0 */
    sets_fixture(&f, 4);
    f.obj.set_count = 2;
    RECORD(&f.obj, 0, 1);
    f.obj.recorded = 2;
    CHECK(visit(&f, 1) == E0_OK);
    CHECK_LOG(&f, "tick:1:0,phase:2:0");
    CHECK(f.phase == 2u && f.obj.solved_sets == 1u && f.obj.state == 0 && f.completed == 0);
    for (int i = 0; i < E0_MAX_CODE; ++i) CHECK(f.obj.record[i] == -1);
    CHECK(f.obj.recorded == 0 && f.obj.exit_pending == 0u && f.obj.waiting == 0u && f.obj.typed == 0);
    /* a partial record completes nothing */
    sets_fixture(&f, 4);
    f.obj.set_count = 2;
    RECORD(&f.obj, 1);
    f.obj.record[29] = 7;
    CHECK(visit(&f, 1) == E0_OK && f.phase == 1u && f.obj.solved_sets == 0u && f.obj.record[0] == -1 && f.obj.recorded == 0);
    for (int i = 0; i < E0_MAX_CODE; ++i) CHECK(f.obj.record[i] == -1);
    CHECK_LOG(&f, "tick:1:0");
    /* set 1 alone */
    sets_fixture(&f, 4);
    f.obj.set_count = 2;
    RECORD(&f.obj, 2);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 2u && f.obj.solved_sets == 1u);
    /* two sets complete: the phase request is made once per set */
    sets_fixture(&f, 4);
    f.obj.set_count = 2;
    RECORD(&f.obj, 0, 1, 2);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 2u);
    CHECK_LOG(&f, "tick:1:0,phase:2:0,phase:2:0");
    /* set_count bounds the sets examined */
    sets_fixture(&f, 4);
    f.obj.set_count = 1;
    RECORD(&f.obj, 2);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 1u && f.obj.solved_sets == 0u);
    sets_fixture(&f, 4);
    f.obj.set_count = 5;
    RECORD(&f.obj, 0, 0, 0);
    f.obj.recorded = 3;
    CHECK(visit(&f, 1) == E0_OK && f.phase == 2u); /* sets 3 {1,1}: key 0 matched twice because the record keeps its entries */
    /* a matched entry is not consumed: {1,1} matches a record holding key 0 once */
    sets_fixture(&f, 4);
    f.obj.set_count = 4;
    RECORD(&f.obj, 0, 3);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 2u && f.obj.solved_sets == 1u);
    CHECK_LOG(&f, "tick:1:0,phase:2:0"); /* set 3 only: set 0 needs key 1, set 2 needs keys 1..3 */
    /* a four code set */
    sets_fixture(&f, 4);
    f.obj.set_count = 3;
    RECORD(&f.obj, 3, 2, 1, 0);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 2u);
    CHECK_LOG(&f, "tick:1:0,phase:2:0,phase:2:0,phase:2:0"); /* sets 0, 1 and 2 */
    sets_fixture(&f, 4);
    f.obj.set_count = 3;
    RECORD(&f.obj, 3, 0);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 1u); /* keys 1 and 2 missing */
    sets_fixture(&f, 4);
    f.obj.set_count = 3;
    RECORD(&f.obj, 3, 2, 0);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 2u); /* only set 1 {3} is complete */
    CHECK_LOG(&f, "tick:1:0,phase:2:0");
    /* only the first N record entries are searched (N = 4) */
    sets_fixture(&f, 4);
    f.obj.set_count = 2;
    f.obj.record[4] = 2;
    CHECK(visit(&f, 1) == E0_OK && f.phase == 1u);
    /* a five code set needs N >= 5 */
    sets_fixture(&f, 6);
    f.body[0x2d3 + 5] = 1;
    f.body[0x2d3 + 6] = 2;
    f.body[0x2d3 + 7] = 3;
    f.body[0x2d3 + 8] = 4;
    f.body[0x2d3 + 9] = 5;
    f.obj.set_count = 2;
    RECORD(&f.obj, 4, 3, 2, 1, 0);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 2u);
    CHECK_LOG(&f, "tick:1:0,phase:2:0,phase:2:0");
    sets_fixture(&f, 6);
    f.body[0x2d3 + 5] = 1;
    f.body[0x2d3 + 6] = 2;
    f.body[0x2d3 + 7] = 3;
    f.body[0x2d3 + 8] = 4;
    f.body[0x2d3 + 9] = 5;
    f.obj.set_count = 2;
    RECORD(&f.obj, 4, 3, 2, 1);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 1u);
    /* the fifth code is looked at: keys 0..3 complete set 0 only */
    sets_fixture(&f, 6);
    f.body[0x2d3 + 5] = 1;
    f.body[0x2d3 + 6] = 2;
    f.body[0x2d3 + 7] = 3;
    f.body[0x2d3 + 8] = 4;
    f.body[0x2d3 + 9] = 5;
    f.obj.set_count = 2;
    RECORD(&f.obj, 0, 1, 2, 3);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 2u);
    CHECK_LOG(&f, "tick:1:0,phase:2:0");
    /* a full record (no empty entry among the first N) still completes a short set: the zero byte ends the set */
    sets_fixture(&f, 2);
    f.obj.set_count = 1;
    RECORD(&f.obj, 0, 1);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 2u);
    /* N = 29: the index N write stays inside the 30 entry record */
    sets_fixture(&f, 29);
    f.obj.set_count = 2;
    RECORD(&f.obj, 0, 1);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 2u);
    for (int i = 0; i < E0_MAX_CODE; ++i) CHECK(f.obj.record[i] == -1);
    /* solved wins over the sets */
    sets_fixture(&f, 4);
    f.obj.set_count = 2;
    f.obj.solved = 1;
    f.obj.round = 3;
    RECORD(&f.obj, 0, 1);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 1u && f.obj.state == 1 && f.obj.solved_sets == 0u && f.obj.record[0] == 0);
    /* a code byte 0 ends the set: the code sets are separate from the unordered code */
    sets_fixture(&f, 4);
    f.body[0x2d3 + 1] = 0;
    f.obj.set_count = 1;
    RECORD(&f.obj, 0);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 2u);
}

/* ---- phase 1: states 1, 3, 4 ----------------------------------------------------------------------------------------- */

static void t_state1(void)
{
    Fx f;
    fx_init(&f, 0);
    start(&f);
    f.obj.state = 1;
    T(&f, 1000u, 1005u);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 1u);
    CHECK_LOG(&f, "tick:1000:0,tick:1005:0");
    CHECK(f.obj.state == 3 && f.obj.show_deadline == 3400u && f.obj.blink_deadline == 1105u);
    /* the delay is a signed word in seconds */
    {
        static const int delays[] = {0, 1, 5, 32767, -1, -32768, 30, 3600};
        for (size_t i = 0; i < sizeof delays / sizeof delays[0]; ++i) {
            const uint32_t first = 0x10000u + (uint32_t)i, second = 0x20000u + (uint32_t)i;
            fx_init(&f, 0);
            put16(f.body, 0xb0, delays[i]);
            start(&f);
            f.obj.state = 1;
            T(&f, first, second);
            CHECK(visit(&f, 1) == E0_OK && f.obj.state == 3);
            CHECK(f.obj.show_deadline == first + (uint32_t)(delays[i] * 1000 + 0x190));
            CHECK(f.obj.blink_deadline == second + 0x64u);
        }
    }
    /* wrapping ticks */
    fx_init(&f, 0);
    start(&f);
    f.obj.state = 1;
    T(&f, 0xffffff00u, 0xffffffc0u);
    CHECK(visit(&f, 1) == E0_OK);
    CHECK(f.obj.show_deadline == (uint32_t)(0xffffff00u + 2400u) && f.obj.blink_deadline == (uint32_t)(0xffffffc0u + 0x64u));
    /* the same on raw 0xe0 */
    fx_init(&f, 1);
    start(&f);
    f.obj.state = 1;
    T(&f, 7u, 9u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.show_deadline == 7u + 2400u && f.obj.blink_deadline == 9u + 0x64u);
}

static void t_state3_timer_and_blink(void)
{
    Fx f;
    /* before the deadline, no blink byte: only the one tick */
    fx_init(&f, 0);
    start(&f);
    f.body[0x24e] = 0;
    f.obj.state = 3;
    f.obj.show_deadline = 1000u;
    f.obj.blink_deadline = 1u;
    T(&f, 999u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.state == 3 && f.obj.blink == 0u);
    CHECK_LOG(&f, "tick:999:0");
    /* ... with the blink byte: a second tick, no toggle before the blink deadline */
    f.body[0x24e] = 1;
    f.log[0] = '\0';
    f.obj.blink_deadline = 2000u;
    T(&f, 999u, 1999u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.blink == 0u && f.obj.blink_deadline == 2000u);
    CHECK_LOG(&f, "tick:999:0,tick:1999:0");
    /* at the blink deadline it toggles and re-arms from a third tick */
    f.log[0] = '\0';
    T(&f, 999u, 2000u, 5000u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.blink == 1u && f.obj.blink_deadline == 5100u);
    CHECK_LOG(&f, "tick:999:0,tick:2000:0,tick:5000:0");
    f.log[0] = '\0';
    T(&f, 999u, 5100u, 7000u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.blink == 0u && f.obj.blink_deadline == 7100u);
    f.log[0] = '\0';
    T(&f, 999u, 7100u, 0xffffffffu);
    CHECK(visit(&f, 1) == E0_OK && f.obj.blink == 1u && f.obj.blink_deadline == 0x63u); /* wraps */
    /* the blink compare is unsigned */
    f.obj.blink = 0u;
    f.obj.blink_deadline = 0xffffff00u;
    T(&f, 999u, 5u, 6u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.blink == 0u && f.obj.blink_deadline == 0xffffff00u);
    f.obj.blink_deadline = 5u;
    T(&f, 999u, 0xfffffff0u, 6u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.blink == 1u && f.obj.blink_deadline == 0x6au);
    /* the show deadline compare: now == deadline proceeds, unsigned */
    fx_init(&f, 0);
    start(&f);
    f.obj.state = 3;
    f.obj.show_deadline = 1000u;
    set_rec(f.body, 0xb2, "NO SOUND");
    f.obj.solved = 1;
    T(&f, 1000u);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 2u);
    fx_init(&f, 0);
    start(&f);
    f.obj.state = 3;
    f.obj.show_deadline = 0xffffff00u;
    f.body[0x24e] = 0;
    f.obj.solved = 1;
    set_rec(f.body, 0xb2, "NO SOUND");
    T(&f, 0x100u);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 1u && f.obj.state == 3);
    T(&f, 0xffffff00u);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 2u);
}

static void t_state3_finish(void)
{
    Fx f;
    /* raw 0xe0 scene: a scene word other than 9999 and 0, nothing typed, goes straight to phase 2 */
    {
        static const struct {
            int scene, typed, phase2;
        } c[] = {{5, 0, 1}, {5, 1, 0}, {0, 0, 0}, {E0_NO_SCENE, 0, 0}, {-1, 0, 1}, {1, 0, 1}, {9998, 0, 1}, {1, -1, 0}};
        for (size_t i = 0; i < sizeof c / sizeof c[0]; ++i) {
            fx_init(&f, 1);
            put16(f.body, 0x10c, c[i].scene);
            start(&f);
            f.obj.state = 3;
            f.obj.show_deadline = 500u;
            f.obj.typed = (int16_t)c[i].typed;
            T(&f, 600u);
            CHECK(visit(&f, 1) == E0_OK);
            if (c[i].phase2) {
                CHECK(f.phase == 2u);
                CHECK_LOG(&f, "tick:600:0,phase:2:0");
                CHECK(f.obj.state == 3);
            } else {
                CHECK(f.phase == 1u && f.obj.state == 4);
                CHECK_LOG(&f, "tick:600:0,prep:178:0,play:9:0");
            }
        }
    }
    /* the next round's record is bounds checked, including offsets just below the body (a negative offset must not wrap): the
     * body sits inside a larger buffer whose bytes before it hold a plausible code length */
    {
        static const int rounds[] = {-17, -18, -1, 45, 50, 1000};
        for (size_t i = 0; i < sizeof rounds / sizeof rounds[0]; ++i) {
            uint8_t big[E0_BODY_CAPACITY + 64];
            E0Result r;
            const char *why = NULL;
            fx_init(&f, 0);
            set_rec(f.body, 0xb2, "NO SOUND");
            start(&f);
            memset(big, 0, sizeof big);
            for (size_t k = 0; k < 32u; ++k) big[k] = (uint8_t)((k & 1u) != 0u ? 5u : 0u); /* words before the body at odd offsets: 5 */
            memcpy(big + 32, f.body, E0_BODY_CAPACITY);
            f.obj.state = 3;
            f.obj.show_deadline = 500u;
            f.obj.solved = 0;
            f.obj.round = (int16_t)rounds[i];
            T(&f, 600u);
            CHECK(e0_step(&f.obj, big + 32, f.body_len, 0, 3, 1u, &f.world, &f.host, &r, &why) == E0_ERR_BOUNDS);
            CHECK(f.obj.round == (int16_t)rounds[i] && f.obj.state == 3);
        }
    }
    /* sound B: prepare and play on the win channel, then state 4, whatever the solved flag says */
    for (int solved = 0; solved < 2; ++solved) {
        fx_init(&f, 0);
        start(&f);
        f.obj.state = 3;
        f.obj.show_deadline = 500u;
        f.obj.solved = (uint8_t)solved;
        T(&f, 600u);
        CHECK(visit(&f, 1) == E0_OK && f.phase == 1u && f.obj.state == 4);
        CHECK_LOG(&f, "tick:600:0,prep:178:0,play:9:0");
    }
    fx_init(&f, 0);
    put16(f.body, 0xd3, 0x1f2);
    start(&f);
    f.obj.state = 3;
    f.obj.show_deadline = 500u;
    T(&f, 600u);
    CHECK(visit(&f, 1) == E0_OK);
    CHECK_LOG(&f, "tick:600:0,prep:178:0,play:498:0");
    /* no sound B: solved finishes, unsolved loads the next round record */
    fx_init(&f, 0);
    set_rec(f.body, 0xb2, "NO SOUND");
    start(&f);
    f.obj.state = 3;
    f.obj.show_deadline = 500u;
    f.obj.solved = 1;
    T(&f, 600u);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 2u && f.obj.state == 3);
    CHECK_LOG(&f, "tick:600:0,phase:2:0");
    {
        static const struct {
            int round, k, first;
        } c[] = {{1, 3, 10}, {2, 3, 11}, {3, 3, 12}, {4, 3, 13}};
        for (size_t i = 0; i < sizeof c / sizeof c[0]; ++i) {
            fx_init(&f, 0);
            set_rec(f.body, 0xb2, "NO SOUND");
            start(&f);
            f.obj.state = 3;
            f.obj.show_deadline = 500u;
            f.obj.round = (int16_t)c[i].round;
            f.obj.blink = 1u;
            f.obj.code_len = 0;
            T(&f, 600u);
            CHECK(visit(&f, 1) == E0_OK && f.phase == 1u);
            CHECK_LOG(&f, "tick:600:0");
            CHECK(f.obj.round == c[i].round + 1 && f.obj.state == 0 && f.obj.blink == 0u);
            CHECK(f.obj.code_len == c[i].k && f.obj.code[0] == c[i].first && f.obj.code[1] == c[i].first + 1 &&
                  f.obj.code_ordered == 0u);
        }
    }
    /* raw 0xe0 (no round records in its body): the zero padding gives an empty code */
    fx_init(&f, 1);
    set_rec(f.body, 0xb2, "NO SOUND");
    put16(f.body, 0x10c, E0_NO_SCENE);
    start(&f);
    f.obj.state = 3;
    f.obj.show_deadline = 500u;
    f.obj.round = 1;
    T(&f, 600u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.round == 2 && f.obj.code_len == 0 && f.obj.state == 0);
    /* a record index outside the body is refused natively, with no change */
    fx_init(&f, 0);
    set_rec(f.body, 0xb2, "NO SOUND");
    start(&f);
    f.obj.state = 3;
    f.obj.show_deadline = 500u;
    f.obj.round = 1000;
    T(&f, 600u);
    CHECK(visit(&f, 1) == E0_ERR_BOUNDS && f.obj.round == 1000 && f.obj.state == 3);
    f.obj.round = -1000;
    CHECK(visit(&f, 1) == E0_ERR_BOUNDS && f.obj.round == -1000);
    f.obj.round = 0; /* the record before the later ones holds a light rectangle: its length word is not a valid code length */
    CHECK(visit(&f, 1) == E0_ERR_BOUNDS);
    {
        static const struct {
            int k, ok;
        } c[] = {{-1, 0}, {-32768, 0}, {0, 1}, {4, 1}, {29, 1}, {30, 1}, {31, 0}, {255, 0}, {110, 0}};
        for (size_t i = 0; i < sizeof c / sizeof c[0]; ++i) {
            f.obj.round = 0;
            f.obj.state = 3;
            put16(f.body, 0x22e, c[i].k);
            if (c[i].ok) {
                CHECK(visit(&f, 1) == E0_OK && f.obj.round == 1 && f.obj.code_len == c[i].k);
            } else {
                CHECK(visit(&f, 1) == E0_ERR_BOUNDS && f.obj.round == 0 && f.obj.state == 3);
            }
        }
    }
    /* host failures */
    fx_init(&f, 0);
    start(&f);
    f.obj.state = 3;
    f.obj.show_deadline = 500u;
    T(&f, 600u);
    f.fail_prepare = 1;
    CHECK(visit(&f, 1) == E0_ERR_HOST && f.obj.state == 3);
    f.fail_prepare = 0;
    f.fail_play = 1;
    CHECK(visit(&f, 1) == E0_ERR_HOST && f.obj.state == 3);
}

static void t_state4(void)
{
    Fx f;
    /* busy: nothing but the query (no blink byte) */
    fx_init(&f, 0);
    start(&f);
    f.body[0x24e] = 0;
    f.obj.state = 4;
    BUSY(&f, 1);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 1u && f.obj.state == 4);
    CHECK_LOG(&f, "busy:9:1");
    for (int v = 0; v < 4; ++v) {
        static const int32_t vals[4] = {2, -1, 0x10000, 255};
        f.log[0] = '\0';
        BUSY(&f, vals[v]);
        CHECK(visit(&f, 1) == E0_OK && f.obj.state == 4 && strstr(f.log, "stop") == NULL);
    }
    /* busy with the blink byte: the blink tick pair */
    fx_init(&f, 0);
    start(&f);
    f.obj.state = 4;
    f.obj.blink_deadline = 100u;
    BUSY(&f, 1);
    T(&f, 100u, 4000u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.blink == 1u && f.obj.blink_deadline == 4100u && f.obj.state == 4);
    CHECK_LOG(&f, "busy:9:1,tick:100:0,tick:4000:0");
    /* idle: stop sound B, then finish when solved */
    fx_init(&f, 0);
    start(&f);
    f.obj.state = 4;
    f.obj.solved = 1;
    BUSY(&f, 0);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 2u);
    CHECK_LOG(&f, "busy:9:0,stop:178:0,phase:2:0");
    /* ... or load the next round when unsolved */
    fx_init(&f, 0);
    start(&f);
    f.obj.state = 4;
    f.obj.solved = 0;
    f.obj.round = 2;
    f.obj.blink = 1u;
    BUSY(&f, 0);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 1u && f.obj.round == 3 && f.obj.state == 0 && f.obj.blink == 0u);
    CHECK_LOG(&f, "busy:9:0,stop:178:0");
    CHECK(f.obj.code_len == 3 && f.obj.code[0] == 11);
    /* the stop is unconditional in this state (even for a "NO SOUND" record) */
    fx_init(&f, 0);
    set_rec(f.body, 0xb2, "NO SOUND");
    start(&f);
    f.obj.state = 4;
    f.obj.solved = 1;
    BUSY(&f, 0);
    CHECK(visit(&f, 1) == E0_OK && f.n_stop == 1);
    /* host failures keep the state */
    fx_init(&f, 0);
    start(&f);
    f.obj.state = 4;
    f.fail_busy = 1;
    CHECK(visit(&f, 1) == E0_ERR_HOST && f.obj.state == 4);
    f.fail_busy = 0;
    f.fail_stop = 1;
    BUSY(&f, 0);
    f.obj.solved = 1;
    CHECK(visit(&f, 1) == E0_ERR_HOST && f.phase == 1u);
    /* record bounds */
    fx_init(&f, 0);
    start(&f);
    f.obj.state = 4;
    f.obj.round = 900;
    BUSY(&f, 0);
    CHECK(visit(&f, 1) == E0_ERR_BOUNDS && f.obj.round == 900 && f.obj.state == 4);
}

static void t_inert_states(void)
{
    Fx f;
    uint8_t before[E0_IMAGE_BYTES], after[E0_IMAGE_BYTES];
    static const int32_t states[] = {2, 5, 6, 100, -1, 0x7fffffff, (int32_t)0x80000000u};
    for (size_t i = 0; i < sizeof states / sizeof states[0]; ++i) {
        fx_init(&f, 0);
        start(&f);
        f.obj.state = states[i];
        f.obj.waiting = 1;
        f.obj.wait_deadline = 0u;
        snapshot(&f, before);
        CHECK(visit(&f, 1) == E0_OK && f.phase == 1u && f.log[0] == '\0');
        snapshot(&f, after);
        CHECK(memcmp(before, after, sizeof before) == 0);
    }
    /* phase 1 with a held button state never touches the world */
    CHECK(f.world.start_flag_5bb1ca == 1 && f.world.entry17_active_5d1a8f == 0);
}

/* ---- phase 2 --------------------------------------------------------------------------------------------------------- */

#define TAIL_CLEANUP ",relsurf:4660:0,relslot:24:0"

static void ready_for_phase2(Fx *f, int flag)
{
    fx_init(f, flag);
    start(f);
    f->obj.blink = 1u;
    f->world.entry17_active_5d1a8f = 5;
    f->world.start_flag_5bb1ca = 0;
}

static void t_phase2_exit_branch(void)
{
    Fx f;
    ready_for_phase2(&f, 0);
    f.obj.exit_asked = 1;
    CHECK(visit(&f, 2) == E0_OK && f.phase == 2u && f.completed == 1);
    CHECK_LOG(&f,
              "start:1:0,e17:0:0,stop:102:0,tr:50:4:5:6:44:55:66,x57b:50:0,x599:4:0,x595:5:0,x39ff:6:0,x59b:44:0,x59f:55:0,"
              "x5a3:66:0,start:1:0,mode:4:0,evflag:8:9,complete:3:0" TAIL_CLEANUP);
    CHECK(f.world.start_flag_5bb1ca == 1 && f.world.scene_cell_5bb57b == 50 && f.world.entry17_active_5d1a8f == 0);
    CHECK(f.obj.blink == 0u && f.obj.active == 0u && f.obj.row == -1 && f.obj.slot == -1 && f.obj.surface == 0u &&
          f.obj.exit_asked == 0u && f.obj.solved == 0u && f.obj.initialized == 0u);
    /* the exit start-flag word: 1 clears the flag, anything else sets it */
    {
        static const struct {
            int start, flag;
        } c[] = {{1, 0}, {0, 1}, {2, 1}, {-1, 1}, {0x100, 1}};
        for (size_t i = 0; i < sizeof c / sizeof c[0]; ++i) {
            char want[64];
            ready_for_phase2(&f, 0);
            f.obj.exit_asked = 1;
            put16(f.body, 0xf7, c[i].start);
            CHECK(visit(&f, 2) == E0_OK && f.world.start_flag_5bb1ca == c[i].flag);
            snprintf(want, sizeof want, "x5a3:66:0,start:%d:0,mode:4:0", c[i].flag);
            CHECK(strstr(f.log, want) != NULL);
        }
    }
    /* no exit scene: no block, the flag and the completion still follow */
    ready_for_phase2(&f, 0);
    f.obj.exit_asked = 1;
    put16(f.body, 0xe3, E0_NO_SCENE);
    CHECK(visit(&f, 2) == E0_OK);
    CHECK_LOG(&f, "start:1:0,e17:0:0,stop:102:0,evflag:8:9,complete:3:0" TAIL_CLEANUP);
    CHECK(f.world.scene_cell_5bb57b == E0_NO_SCENE);
    /* scene 0 and negative scenes are blocks like any other */
    ready_for_phase2(&f, 0);
    f.obj.exit_asked = 1;
    put16(f.body, 0xe3, -5);
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "tr:-5:4:5:6:44:55:66,x57b:-5:0") != NULL && f.world.scene_cell_5bb57b == -5);
    ready_for_phase2(&f, 0);
    f.obj.exit_asked = 1;
    put16(f.body, 0xe3, 0);
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "tr:0:4:5:6") != NULL);
    /* words and dwords are signed */
    ready_for_phase2(&f, 0);
    f.obj.exit_asked = 1;
    set_block(f.body, 0xe3, 50, -4, -5, -6, -44, -55, -66, 0, 8, 9);
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "tr:50:-4:-5:-6:-44:-55:-66,x57b:50:0,x599:-4:0,x595:-5:0,x39ff:-6:0,x59b:-44:0") != NULL);
    /* event flag: -1 stores nothing, the value is an unsigned byte */
    ready_for_phase2(&f, 0);
    f.obj.exit_asked = 1;
    put16(f.body, 0xf9, -1);
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "evflag") == NULL && f.completed == 1);
    ready_for_phase2(&f, 0);
    f.obj.exit_asked = 1;
    put16(f.body, 0xf9, 99);
    f.body[0xfb] = 255;
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "evflag:99:255,complete:3:0") != NULL);
    ready_for_phase2(&f, 0);
    f.obj.exit_asked = 1;
    put16(f.body, 0xf9, 0);
    f.body[0xfb] = 0;
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "evflag:0:0,complete") != NULL);
    /* sound A "NO SOUND": no stop */
    ready_for_phase2(&f, 0);
    f.obj.exit_asked = 1;
    set_rec(f.body, 0x66, "NO SOUND");
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "stop") == NULL && f.n_stop == 0);
    /* the exit branch wins over solved sets */
    ready_for_phase2(&f, 0);
    f.obj.exit_asked = 1;
    f.obj.solved_sets = 1;
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "tr:50:") != NULL && strstr(f.log, "tr:70:") == NULL);
    /* raw 0xe0 takes the same branch */
    ready_for_phase2(&f, 1);
    f.obj.exit_asked = 1;
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "tr:50:4:5:6:44:55:66") != NULL && f.completed == 1);
}

static void t_phase2_sets_branch(void)
{
    Fx f;
    ready_for_phase2(&f, 0);
    f.obj.solved_sets = 1;
    CHECK(visit(&f, 2) == E0_OK && f.phase == 2u && f.completed == 1);
    CHECK_LOG(&f,
              "start:1:0,e17:0:0,stop:102:0,tr:70:7:8:9:77:88:99,x57b:70:0,x599:7:0,x595:8:0,x39ff:9:0,x59b:77:0,x59f:88:0,"
              "x5a3:99:0,start:0:0,mode:4:0,evflag:12:4,complete:3:0" TAIL_CLEANUP);
    CHECK(f.world.start_flag_5bb1ca == 0 && f.world.scene_cell_5bb57b == 70);
    /* start flag word, flag and value come from the all-sets block */
    ready_for_phase2(&f, 0);
    f.obj.solved_sets = 1;
    put16(f.body, 0x300, 0);
    put16(f.body, 0x302, 33);
    f.body[0x304] = 77;
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "x5a3:99:0,start:1:0,mode:4:0,evflag:33:77,complete") != NULL);
    /* no scene: no block */
    ready_for_phase2(&f, 0);
    f.obj.solved_sets = 1;
    put16(f.body, 0x2ec, E0_NO_SCENE);
    CHECK(visit(&f, 2) == E0_OK);
    CHECK_LOG(&f, "start:1:0,e17:0:0,stop:102:0,evflag:12:4,complete:3:0" TAIL_CLEANUP);
    /* no event flag */
    ready_for_phase2(&f, 0);
    f.obj.solved_sets = 1;
    put16(f.body, 0x302, -1);
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "evflag") == NULL);
    /* the other blocks' flags are not looked at: invalid exit and failed flags do not refuse the sets branch */
    ready_for_phase2(&f, 0);
    f.obj.solved_sets = 1;
    put16(f.body, 0xf9, 500);
    put16(f.body, 0xad, 500);
    CHECK(visit(&f, 2) == E0_OK && f.completed == 1);
}

static void t_phase2_failed_branch(void)
{
    Fx f;
    /* raw 0xd6: the failed block, scene 60 */
    ready_for_phase2(&f, 0);
    CHECK(visit(&f, 2) == E0_OK && f.phase == 2u && f.completed == 1);
    CHECK_LOG(&f,
              "start:1:0,e17:0:0,stop:102:0,x57b:60:0,tr:60:1:2:3:11:22:33,x599:1:0,x595:2:0,x39ff:3:0,x59b:11:0,x59f:22:0,"
              "x5a3:33:0,start:0:0,mode:4:0,evflag:7:3,complete:3:0" TAIL_CLEANUP);
    CHECK(f.world.scene_cell_5bb57b == 60 && f.world.start_flag_5bb1ca == 0);
    /* start-flag word of the failed block */
    ready_for_phase2(&f, 0);
    put16(f.body, 0xab, 0);
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "x5a3:33:0,start:1:0,mode:4:0") != NULL && f.world.start_flag_5bb1ca == 1);
    ready_for_phase2(&f, 0);
    put16(f.body, 0xab, 2);
    CHECK(visit(&f, 2) == E0_OK && f.world.start_flag_5bb1ca == 1);
    /* no failed scene and the stale cell untouched: no transition at all */
    ready_for_phase2(&f, 0);
    put16(f.body, 0x97, E0_NO_SCENE);
    CHECK(visit(&f, 2) == E0_OK);
    CHECK_LOG(&f, "start:1:0,e17:0:0,stop:102:0,evflag:7:3,complete:3:0" TAIL_CLEANUP);
    CHECK(f.world.scene_cell_5bb57b == E0_NO_SCENE && f.world.start_flag_5bb1ca == 1);
    /* the stale cell: the original tests the dword 0x5bb57b even when this visit did not assign it */
    ready_for_phase2(&f, 0);
    put16(f.body, 0x97, E0_NO_SCENE);
    f.world.scene_cell_5bb57b = 77;
    CHECK(visit(&f, 2) == E0_OK);
    CHECK_LOG(&f,
              "start:1:0,e17:0:0,stop:102:0,tr:77:1:2:3:11:22:33,x599:1:0,x595:2:0,x39ff:3:0,x59b:11:0,x59f:22:0,x5a3:33:0,"
              "start:0:0,mode:4:0,evflag:7:3,complete:3:0" TAIL_CLEANUP);
    CHECK(f.world.scene_cell_5bb57b == 77);
    ready_for_phase2(&f, 0);
    put16(f.body, 0x97, E0_NO_SCENE);
    f.world.scene_cell_5bb57b = 0;
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "tr:0:1:2:3") != NULL);
    ready_for_phase2(&f, 0);
    put16(f.body, 0x97, E0_NO_SCENE);
    f.world.scene_cell_5bb57b = -1;
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "tr:-1:1:2:3") != NULL);
    /* a stale value that happens to be 9999 in the high word only is still not 9999 (a dword compare) */
    ready_for_phase2(&f, 0);
    put16(f.body, 0x97, E0_NO_SCENE);
    f.world.scene_cell_5bb57b = 0x10000 + E0_NO_SCENE;
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "tr:") != NULL);
    /* a failed block scene overrides the stale cell */
    ready_for_phase2(&f, 0);
    f.world.scene_cell_5bb57b = 77;
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "x57b:60:0,tr:60:") != NULL && f.world.scene_cell_5bb57b == 60);
    /* negative failed scene */
    ready_for_phase2(&f, 0);
    put16(f.body, 0x97, -9);
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "x57b:-9:0,tr:-9:1:2:3") != NULL);
    /* the failed event flag */
    ready_for_phase2(&f, 0);
    put16(f.body, 0xad, -1);
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "evflag") == NULL);
    ready_for_phase2(&f, 0);
    put16(f.body, 0xad, 99);
    f.body[0xaf] = 200;
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "evflag:99:200") != NULL);
    /* raw 0xe0: a scene word other than 9999 and 0, unsolved, nothing typed: that scene is assigned */
    {
        static const struct {
            int scene, solved, typed, assigned;
        } c[] = {
            {5, 0, 0, 1}, {5, 1, 0, 0}, {5, 0, 2, 0}, {0, 0, 0, 0}, {E0_NO_SCENE, 0, 0, 0}, {-3, 0, 0, 1}, {1, 0, 0, 1},
        };
        for (size_t i = 0; i < sizeof c / sizeof c[0]; ++i) {
            char want[64];
            ready_for_phase2(&f, 1);
            put16(f.body, 0x10c, c[i].scene);
            f.obj.scene = (int16_t)c[i].scene;
            f.obj.solved = (uint8_t)c[i].solved;
            f.obj.typed = (int16_t)c[i].typed;
            CHECK(visit(&f, 2) == E0_OK);
            if (c[i].assigned) {
                snprintf(want, sizeof want, "x57b:%d:0,tr:%d:1:2:3:11:22:33", c[i].scene, c[i].scene);
                CHECK(strstr(f.log, want) != NULL && f.world.scene_cell_5bb57b == c[i].scene);
            } else {
                CHECK(strstr(f.log, "x57b:5:0") == NULL && strstr(f.log, "x57b:-3:0") == NULL);
                CHECK(strstr(f.log, "x57b:60:0,tr:60:") != NULL);
            }
        }
        /* raw 0xe0 whose scene is assigned also reports the failed block's words */
        ready_for_phase2(&f, 1);
        f.obj.scene = 5;
        put16(f.body, 0x97, E0_NO_SCENE);
        CHECK(visit(&f, 2) == E0_OK);
        CHECK(strstr(f.log, "x57b:5:0,tr:5:1:2:3:11:22:33,x599:1:0") != NULL);
        /* raw 0xe0 with neither: the stale cell */
        ready_for_phase2(&f, 1);
        f.obj.scene = E0_NO_SCENE;
        put16(f.body, 0x97, E0_NO_SCENE);
        f.world.scene_cell_5bb57b = 31;
        CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "x57b") == NULL && strstr(f.log, "tr:31:1:2:3") != NULL);
    }
}

static void t_phase2_refusals_and_failures(void)
{
    Fx f;
    /* an invalid event flag of the chosen branch is refused before any effect */
    {
        static const int bad[] = {100, 500, -2, -100, 32767, -32768};
        for (size_t i = 0; i < sizeof bad / sizeof bad[0]; ++i) {
            ready_for_phase2(&f, 0);
            f.obj.exit_asked = 1;
            put16(f.body, 0xf9, bad[i]);
            CHECK(visit(&f, 2) == E0_ERR_BOUNDS && f.log[0] == '\0' && f.completed == 0);
            CHECK(f.obj.active == 1u && f.obj.slot == 24 && f.obj.surface == 0x1234u && f.obj.blink == 1u);
            CHECK(f.world.start_flag_5bb1ca == 0 && f.world.entry17_active_5d1a8f == 5);
            ready_for_phase2(&f, 0);
            f.obj.solved_sets = 1;
            put16(f.body, 0x302, bad[i]);
            CHECK(visit(&f, 2) == E0_ERR_BOUNDS && f.log[0] == '\0');
            ready_for_phase2(&f, 0);
            put16(f.body, 0xad, bad[i]);
            CHECK(visit(&f, 2) == E0_ERR_BOUNDS && f.log[0] == '\0');
        }
        ready_for_phase2(&f, 0);
        f.obj.exit_asked = 1;
        put16(f.body, 0xf9, 99);
        CHECK(visit(&f, 2) == E0_OK);
        ready_for_phase2(&f, 0);
        f.obj.exit_asked = 1;
        put16(f.body, 0xf9, 0);
        CHECK(visit(&f, 2) == E0_OK);
    }
    /* host failures */
    ready_for_phase2(&f, 0);
    f.obj.exit_asked = 1;
    f.fail_stop = 1;
    CHECK(visit(&f, 2) == E0_ERR_HOST);
    CHECK_LOG(&f, "start:1:0,e17:0:0");
    ready_for_phase2(&f, 0);
    f.obj.exit_asked = 1;
    f.fail_transition = 1;
    CHECK(visit(&f, 2) == E0_ERR_HOST);
    CHECK_LOG(&f, "start:1:0,e17:0:0,stop:102:0");
    ready_for_phase2(&f, 0);
    f.fail_transition = 1;
    CHECK(visit(&f, 2) == E0_ERR_HOST);
    CHECK_LOG(&f, "start:1:0,e17:0:0,stop:102:0,x57b:60:0");
    ready_for_phase2(&f, 0);
    f.obj.solved_sets = 1;
    f.fail_transition = 1;
    CHECK(visit(&f, 2) == E0_ERR_HOST && f.completed == 0);
    CHECK_LOG(&f, "start:1:0,e17:0:0,stop:102:0");
    ready_for_phase2(&f, 0);
    f.obj.exit_asked = 1;
    f.fail_flag = 1;
    CHECK(visit(&f, 2) == E0_ERR_HOST);
    ready_for_phase2(&f, 0);
    f.obj.exit_asked = 1;
    f.fail_relsurf = 1;
    CHECK(visit(&f, 2) == E0_ERR_HOST && f.completed == 0 && f.obj.active == 0u && f.obj.blink == 0u);
    ready_for_phase2(&f, 0);
    f.obj.exit_asked = 1;
    f.fail_relslot = 1;
    CHECK(visit(&f, 2) == E0_ERR_HOST && f.completed == 0 && f.obj.surface == 0u);
    /* a second phase 2 visit after the finish needs a new phase 0 */
    ready_for_phase2(&f, 0);
    f.obj.exit_asked = 1;
    CHECK(visit(&f, 2) == E0_OK);
    CHECK(visit(&f, 2) == E0_ERR_UNSUPPORTED);
    CHECK(visit(&f, 1) == E0_ERR_UNSUPPORTED);
    CHECK(visit(&f, 0) == E0_OK && f.obj.initialized == 1u);
}

/* ---- pointer --------------------------------------------------------------------------------------------------------- */

static void expect_pointer(Fx *f, int32_t x, int32_t y, int hit, int32_t candidate, int cursor, int hover)
{
    E0PointerResult p;
    memset(&p, 0x77, sizeof p);
    if (pointer(f, x, y, &p) != E0_OK || p.hit != (uint8_t)hit || p.candidate != candidate || p.cursor != (uint8_t)cursor ||
        f->obj.hover != hover) {
        char m[200];
        snprintf(m, sizeof m, "pointer (%d,%d): hit %d cand %d cursor %d hover %d, wanted %d %d %d %d", (int)x, (int)y, p.hit,
                 (int)p.candidate, p.cursor, f->obj.hover, hit, (int)candidate, cursor, hover);
        fail_now(m);
    }
}

static void t_pointer_keys(void)
{
    Fx f;
    fx_init(&f, 0);
    start(&f);
    f.obj.hover = 3;
    /* keys 0..3 at x 20i..20i+9, y 0..9, inclusive on every side */
    expect_pointer(&f, 5, 5, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 0);
    expect_pointer(&f, 0, 0, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 0);
    expect_pointer(&f, 9, 9, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 0);
    expect_pointer(&f, 9, 0, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 0);
    expect_pointer(&f, 0, 9, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 0);
    expect_pointer(&f, 10, 5, 0, -1, 0, -1);
    expect_pointer(&f, 5, 10, 0, -1, 0, -1);
    expect_pointer(&f, -1, 5, 0, -1, 0, -1);
    expect_pointer(&f, 5, -1, 0, -1, 0, -1);
    expect_pointer(&f, 20, 0, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 1);
    expect_pointer(&f, 29, 9, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 1);
    expect_pointer(&f, 30, 9, 0, -1, 0, -1);
    expect_pointer(&f, 60, 5, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 3);
    expect_pointer(&f, 69, 5, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 3);
    expect_pointer(&f, 70, 5, 0, -1, 0, -1);
    expect_pointer(&f, 85, 5, 0, -1, 0, -1); /* key 4 is beyond N */
    /* only the low 16 bits of x and y count, sign extended */
    expect_pointer(&f, 5 + 0x10000, 5, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 0);
    expect_pointer(&f, 5, 5 + 0x20000, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 0);
    expect_pointer(&f, 5 + 0x7fff0000, 5 - 0x10000, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 0);
    expect_pointer(&f, 40005, 5, 0, -1, 0, -1); /* 40005 is -25531 */
    f.obj.rect_b[0][0] = -5;
    f.obj.rect_b[0][1] = -5;
    f.obj.rect_b[0][2] = -1;
    f.obj.rect_b[0][3] = -1;
    expect_pointer(&f, 0xffff, 0xffff, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 0);
    expect_pointer(&f, 0xfffb, 0xfffb, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 0);
    expect_pointer(&f, 0xfffa, 0xfffb, 0, -1, 0, -1);
    expect_pointer(&f, 0, 0, 0, -1, 0, -1);
    /* an earlier key wins when rectangles overlap */
    f.obj.rect_b[0][0] = 0;
    f.obj.rect_b[0][1] = 0;
    f.obj.rect_b[0][2] = 9;
    f.obj.rect_b[0][3] = 9;
    memcpy(f.obj.rect_b[2], f.obj.rect_b[1], sizeof f.obj.rect_b[1]);
    expect_pointer(&f, 25, 5, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 1);
    f.obj.rect_b[0][0] = 20;
    f.obj.rect_b[0][2] = 29;
    expect_pointer(&f, 25, 5, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 0);
    /* the key array stops at 100 whatever N says (the 101st rectangle is not part of the array) */
    {
        Fx g;
        fx_init(&g, 0);
        start(&g);
        put16(g.body, 0x21, 5000);
        memset(g.obj.lit, 0, sizeof g.obj.lit);
        g.obj.tiles_visible = 0;
        expect_pointer(&g, 5, 5, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 0);
        for (int i = 0; i < E0_MAX_KEYS; ++i) {
            g.obj.rect_b[i][0] = 1000;
            g.obj.rect_b[i][1] = 1000;
            g.obj.rect_b[i][2] = 1001;
            g.obj.rect_b[i][3] = 1001;
        }
        g.body[0x24] = 0;
        g.obj.waiting = 0;
        /* the bytes after rect_b[99] must not be read as a rectangle: make them look like one that contains (5, 5) */
        memset(g.obj.lit, 0, sizeof g.obj.lit);
        g.obj.lit[8] = 0xff;
        g.obj.lit[12] = 0xff;
        expect_pointer(&g, 5, 5, 0, -1, 0, -1);
    }
}

static void t_pointer_exit(void)
{
    Fx f;
    fx_init(&f, 0);
    start(&f);
    f.obj.hover = 2;
    /* the exit rectangle (300,200..319,209): candidate 0x27ad, cursor 9, the hover is left alone */
    expect_pointer(&f, 305, 205, 1, E0_CANDIDATE_EXIT, E0_CURSOR_EXIT, 2);
    expect_pointer(&f, 300, 200, 1, E0_CANDIDATE_EXIT, E0_CURSOR_EXIT, 2);
    expect_pointer(&f, 319, 209, 1, E0_CANDIDATE_EXIT, E0_CURSOR_EXIT, 2);
    expect_pointer(&f, 299, 205, 0, -1, 0, -1);
    expect_pointer(&f, 320, 205, 0, -1, 0, -1);
    expect_pointer(&f, 305, 199, 0, -1, 0, -1);
    expect_pointer(&f, 305, 210, 0, -1, 0, -1);
    /* the exit button (200,100..219,109): a hit with hover 0x28, candidate 0x27a6 */
    expect_pointer(&f, 210, 105, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, E0_EXIT_KEY);
    expect_pointer(&f, 200, 100, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, E0_EXIT_KEY);
    expect_pointer(&f, 219, 109, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, E0_EXIT_KEY);
    expect_pointer(&f, 199, 105, 0, -1, 0, -1);
    expect_pointer(&f, 220, 105, 0, -1, 0, -1);
    expect_pointer(&f, 210, 99, 0, -1, 0, -1);
    expect_pointer(&f, 210, 110, 0, -1, 0, -1);
    /* without an exit button the rectangle is just space */
    f.body[0x24] = 0;
    expect_pointer(&f, 210, 105, 0, -1, 0, -1);
    expect_pointer(&f, 305, 205, 1, E0_CANDIDATE_EXIT, E0_CURSOR_EXIT, -1); /* hover was -1 from the miss */
    f.body[0x24] = 1;
    /* waiting suppresses the keys and the exit button but not the exit rectangle */
    f.obj.waiting = 1;
    f.obj.hover = 2;
    expect_pointer(&f, 5, 5, 0, -1, 0, -1);
    f.obj.hover = 2;
    expect_pointer(&f, 210, 105, 0, -1, 0, -1);
    f.obj.hover = 2;
    expect_pointer(&f, 305, 205, 1, E0_CANDIDATE_EXIT, E0_CURSOR_EXIT, 2);
    f.obj.waiting = 0;
    /* the exit rectangle is tried first, then the keys, then the exit button */
    put_rect(f.body, 0xfc, 0, 0, 100, 100);
    f.obj.hover = 1;
    expect_pointer(&f, 5, 5, 1, E0_CANDIDATE_EXIT, E0_CURSOR_EXIT, 1);
    put_rect(f.body, 0xfc, 300, 200, 319, 209);
    put_rect(f.body, 0x35, 0, 0, 9, 9);
    expect_pointer(&f, 5, 5, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 0);
    expect_pointer(&f, 5, 8, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 0);
    put_rect(f.body, 0x35, 10, 0, 19, 9);
    expect_pointer(&f, 15, 5, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, E0_EXIT_KEY);
    /* inactive: nothing is claimed, the hover is still cleared */
    f.obj.active = 0;
    f.obj.hover = 3;
    expect_pointer(&f, 5, 5, 0, -1, 0, -1);
    f.obj.hover = 3;
    expect_pointer(&f, 305, 205, 0, -1, 0, -1);
    /* the pointer needs arguments */
    {
        E0PointerResult p;
        CHECK(e0_pointer_move(NULL, f.body, f.body_len, 1, 1, &p) == E0_ERR_ARGUMENT);
        CHECK(e0_pointer_move(&f.obj, NULL, f.body_len, 1, 1, &p) == E0_ERR_ARGUMENT);
        CHECK(e0_pointer_move(&f.obj, f.body, f.body_len, 1, 1, NULL) == E0_ERR_ARGUMENT);
    }
}

static void t_pointer_e0(void)
{
    Fx f;
    fx_init(&f, 1);
    start(&f);
    /* the destination rectangles come from the grid: key 0 (100,50)-(110,58), key 1 (116,50), key 2 (100,60), key 3 (116,60) */
    expect_pointer(&f, 105, 55, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 0);
    expect_pointer(&f, 110, 58, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 0);
    expect_pointer(&f, 111, 55, 0, -1, 0, -1);
    expect_pointer(&f, 116, 50, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 1);
    expect_pointer(&f, 100, 60, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 2);
    expect_pointer(&f, 126, 68, 1, E0_CANDIDATE_KEY, E0_CURSOR_PICK, 3);
    expect_pointer(&f, 127, 68, 0, -1, 0, -1);
    expect_pointer(&f, 5, 6, 0, -1, 0, -1); /* the source rectangles are not hit targets */
    expect_pointer(&f, 305, 205, 1, E0_CANDIDATE_EXIT, E0_CURSOR_EXIT, -1);
}

/* ---- click ----------------------------------------------------------------------------------------------------------- */

static void t_click_gating(void)
{
    Fx f;
    uint32_t np;
    fx_init(&f, 0);
    start(&f);
    f.obj.hover = 1;
    /* active, state 0, row phase 1: everything below runs */
    np = 99;
    CHECK(click(&f, 1u, E0_CANDIDATE_KEY, 1, &np) == E0_OK && np == 1u && f.obj.lit[1] == 1u);
    /* inactive */
    fx_init(&f, 0);
    start(&f);
    f.obj.hover = 1;
    f.obj.active = 0;
    np = 0;
    CHECK(click(&f, 1u, E0_CANDIDATE_KEY, 1, &np) == E0_OK && np == 1u && f.obj.lit[1] == 0u && f.log[0] == '\0');
    np = 0;
    CHECK(click(&f, 1u, E0_CANDIDATE_EXIT, 1, &np) == E0_OK && np == 1u && f.obj.exit_asked == 0u);
    /* not state 0 */
    for (int s = 1; s < 6; ++s) {
        fx_init(&f, 0);
        start(&f);
        f.obj.hover = 1;
        f.obj.state = s;
        np = 0;
        CHECK(click(&f, 1u, E0_CANDIDATE_KEY, 1, &np) == E0_OK && np == 1u && f.obj.lit[1] == 0u && f.log[0] == '\0');
        CHECK(click(&f, 1u, E0_CANDIDATE_EXIT, 1, &np) == E0_OK && np == 1u && f.obj.exit_asked == 0u);
    }
    f.obj.state = -1;
    CHECK(click(&f, 1u, E0_CANDIDATE_EXIT, 1, &np) == E0_OK && np == 1u && f.obj.exit_asked == 0u);
    /* row phase other than 1 passes through untouched */
    fx_init(&f, 0);
    start(&f);
    f.obj.hover = 1;
    for (uint32_t p = 0u; p < 6u; ++p) {
        if (p == 1u) continue;
        np = 0;
        CHECK(click(&f, p, E0_CANDIDATE_KEY, 1, &np) == E0_OK && np == p && f.obj.lit[1] == 0u);
        CHECK(click(&f, p, E0_CANDIDATE_EXIT, 1, &np) == E0_OK && np == p && f.obj.exit_asked == 0u && f.log[0] == '\0');
    }
    /* other candidates do nothing */
    for (int32_t cand = -1; cand < 0x27b0; cand += 0x27b1 / 3) {
        if (cand == E0_CANDIDATE_KEY || cand == E0_CANDIDATE_EXIT) continue;
        np = 0;
        CHECK(click(&f, 1u, cand, 1, &np) == E0_OK && np == 1u && f.obj.lit[1] == 0u && f.obj.exit_asked == 0u);
    }
    /* the hover outside the key array is an error before any effect */
    {
        static const int hovers[] = {-1, -2, 100, 101, 32767, -32768};
        for (size_t i = 0; i < sizeof hovers / sizeof hovers[0]; ++i) {
            fx_init(&f, 0);
            start(&f);
            f.obj.hover = (int16_t)hovers[i];
            np = 0;
            CHECK(click(&f, 1u, E0_CANDIDATE_KEY, 1, &np) == E0_ERR_BOUNDS && np == 1u && f.log[0] == '\0');
            CHECK(f.obj.typed == 0 && f.obj.waiting == 0u);
            /* not an error for the exit rectangle or another candidate */
            CHECK(click(&f, 1u, 0, 1, &np) == E0_OK);
        }
        fx_init(&f, 0);
        start(&f);
        f.obj.hover = 99;
        CHECK(click(&f, 1u, E0_CANDIDATE_KEY, 0, &np) == E0_OK && f.obj.lit[99] == 1u);
        f.obj.hover = 0;
        CHECK(click(&f, 1u, E0_CANDIDATE_KEY, 0, &np) == E0_OK && f.obj.lit[0] == 1u);
        f.obj.hover = -1;
        CHECK(click(&f, 1u, E0_CANDIDATE_EXIT, 0, &np) == E0_OK && np == 2u);
    }
}

static void t_click_ordered(void)
{
    Fx f;
    uint32_t np;
    fx_init(&f, 0);
    start(&f);
    f.body[0x23] = 1;
    /* append: three keys in order, no wait, no tick */
    CHECK(press(&f, 2, 0) == E0_OK);
    CHECK(f.obj.typed == 1 && f.obj.player[0] == 2 && f.obj.lit[2] == 1u && f.obj.waiting == 0u && f.log[0] == '\0');
    CHECK(press(&f, 0, 0) == E0_OK && f.obj.typed == 2 && f.obj.player[1] == 0 && f.obj.lit[0] == 1u);
    CHECK(press(&f, 3, 0) == E0_OK && f.obj.typed == 3 && f.obj.player[2] == 3);
    /* clicking the last typed key pops it */
    CHECK(press(&f, 3, 0) == E0_OK && f.obj.typed == 2 && f.obj.lit[3] == 0u && f.obj.player[2] == -1 && f.obj.player[1] == 0);
    /* clicking a lit key that is not the last un-lights it but keeps the order */
    CHECK(press(&f, 2, 0) == E0_OK && f.obj.lit[2] == 0u && f.obj.typed == 2 && f.obj.player[0] == 2 && f.obj.player[1] == 0);
    /* typing it again appends */
    CHECK(press(&f, 2, 0) == E0_OK && f.obj.typed == 3 && f.obj.player[2] == 2 && f.obj.lit[2] == 1u);
    /* typed == N: no store, the count clamps at N */
    CHECK(press(&f, 1, 0) == E0_OK && f.obj.typed == 4 && f.obj.player[3] == 1);
    f.obj.hover = 7;
    f.obj.lit[7] = 0;
    CHECK(click(&f, 1u, E0_CANDIDATE_KEY, 0, &np) == E0_OK && f.obj.typed == 4 && f.obj.lit[7] == 1u && f.obj.player[4] == -1);
    /* typed above N clamps down on a lit pop? no: the pop path is untouched */
    f.obj.typed = 6;
    f.obj.hover = 5;
    f.obj.lit[5] = 0;
    CHECK(click(&f, 1u, E0_CANDIDATE_KEY, 0, &np) == E0_OK && f.obj.typed == 4); /* 7 clamped to N */
    /* popping from an empty list */
    fx_init(&f, 0);
    start(&f);
    f.body[0x23] = 1;
    f.obj.lit[2] = 1;
    CHECK(press(&f, 2, 0) == E0_OK && f.obj.lit[2] == 0u && f.obj.typed == 0 && f.obj.player[0] == -1);
    /* a pop whose list is empty but whose first entry matches */
    f.obj.lit[2] = 1;
    f.obj.player[0] = 2;
    f.obj.typed = 0;
    CHECK(press(&f, 2, 0) == E0_OK && f.obj.typed == 0 && f.obj.player[0] == -1);
    /* a pop with a stale negative count never indexes below 0 */
    f.obj.lit[2] = 1;
    f.obj.typed = -5;
    f.obj.player[0] = 2;
    CHECK(press(&f, 2, 0) == E0_OK && f.obj.typed == 0 && f.obj.player[0] == -1);
    /* the keypad of raw 0xe0 behaves the same way (N from the grid) */
    fx_init(&f, 1);
    start(&f);
    f.body[0x23] = 1;
    CHECK(press(&f, 3, 0) == E0_OK && f.obj.typed == 1 && f.obj.player[0] == 3);
    CHECK(press(&f, 3, 0) == E0_OK && f.obj.typed == 0 && f.obj.player[0] == -1 && f.obj.lit[3] == 0u);
}

static void t_click_unordered(void)
{
    Fx f;
    fx_init(&f, 0);
    start(&f);
    T(&f, 1000u);
    /* code length 2: the typed window slides, the click arms the wait */
    CHECK(press(&f, 1, 0) == E0_OK);
    CHECK_LOG(&f, "tick:1000:0");
    CHECK(f.obj.typed == 1 && f.obj.lit[1] == 1u && f.obj.waiting == 1u && f.obj.wait_deadline == 1300u);
    CHECK(f.obj.player[0] == -1 && f.obj.player[1] == 1);
    T(&f, 2000u);
    CHECK(press(&f, 2, 0) == E0_OK && f.obj.typed == 2 && f.obj.wait_deadline == 2300u && f.obj.player[0] == 1 && f.obj.player[1] == 2);
    T(&f, 4000u);
    CHECK(press(&f, 3, 0) == E0_OK && f.obj.typed == 2 && f.obj.player[0] == 2 && f.obj.player[1] == 3); /* clamped, window shifted */
    /* a lit key does nothing in unordered mode (no tick, no shift) */
    f.log[0] = '\0';
    f.obj.wait_deadline = 7u;
    CHECK(press(&f, 3, 0) == E0_OK && f.log[0] == '\0' && f.obj.wait_deadline == 7u && f.obj.typed == 2 && f.obj.player[1] == 3);
    /* the deadline wraps */
    fx_init(&f, 0);
    start(&f);
    T(&f, 0xfffffff0u);
    CHECK(press(&f, 0, 0) == E0_OK && f.obj.wait_deadline == (uint32_t)(0xfffffff0u + 0x12cu));
    /* length 3: window of three */
    fx_init(&f, 0);
    start(&f);
    f.obj.code_len = 3;
    PLAYER(&f.obj, 1, 2, 3);
    f.obj.typed = 3;
    CHECK(press(&f, 5, 0) == E0_OK && f.obj.player[0] == 2 && f.obj.player[1] == 3 && f.obj.player[2] == 5 && f.obj.player[3] == -1);
    CHECK(f.obj.typed == 3);
    /* length 1: no shift, the single entry is replaced */
    fx_init(&f, 0);
    start(&f);
    f.obj.code_len = 1;
    PLAYER(&f.obj, 4);
    f.obj.typed = 1;
    CHECK(press(&f, 6, 0) == E0_OK && f.obj.player[0] == 6 && f.obj.player[1] == -1 && f.obj.typed == 1);
    /* length 30: the shift covers 29 entries */
    fx_init(&f, 0);
    start(&f);
    f.obj.code_len = 30;
    for (int i = 0; i < E0_MAX_CODE; ++i) f.obj.player[i] = (int16_t)i;
    f.obj.typed = 30;
    CHECK(press(&f, 50, 0) == E0_OK);
    for (int i = 0; i < 29; ++i) CHECK(f.obj.player[i] == i + 1);
    CHECK(f.obj.player[29] == 50 && f.obj.typed == 30);
    /* length 0: the count is not clamped and the hover lands on the pad word */
    fx_init(&f, 0);
    start(&f);
    f.obj.code_len = 0;
    PLAYER(&f.obj, 7, 8);
    CHECK(press(&f, 9, 0) == E0_OK && f.obj.typed == 1 && f.obj.pad_d48 == 9 && f.obj.player[0] == 7 && f.obj.player[1] == 8);
    CHECK(press(&f, 10, 0) == E0_OK && f.obj.typed == 2 && f.obj.pad_d48 == 10);
    /* a negative stale count is not clamped either */
    fx_init(&f, 0);
    start(&f);
    f.obj.code_len = 2;
    f.obj.typed = 5;
    CHECK(press(&f, 0, 0) == E0_OK && f.obj.typed == 2);
    /* raw 0xe0 behaves the same */
    fx_init(&f, 1);
    start(&f);
    T(&f, 50u);
    CHECK(press(&f, 2, 0) == E0_OK && f.obj.player[1] == 2 && f.obj.wait_deadline == 350u && f.obj.waiting == 1u);
}

static void t_click_record_and_sound(void)
{
    Fx f;
    uint32_t np;
    /* the record collects hovered keys while code sets exist */
    fx_init(&f, 0);
    start(&f);
    f.obj.set_count = 1;
    CHECK(press(&f, 2, 0) == E0_OK && f.obj.recorded == 1 && f.obj.record[0] == 2);
    CHECK(press(&f, 2, 0) == E0_OK && f.obj.recorded == 2 && f.obj.record[1] == 2); /* even a lit key is recorded */
    CHECK(press(&f, 3, 0) == E0_OK && f.obj.recorded == 3 && f.obj.record[2] == 3);
    CHECK(press(&f, 0, 0) == E0_OK && f.obj.recorded == 4 && f.obj.record[3] == 0);
    CHECK(press(&f, 1, 0) == E0_OK && f.obj.recorded == 4 && f.obj.record[4] == -1); /* N = 4 entries at most */
    fx_init(&f, 0);
    start(&f);
    f.obj.set_count = 0;
    CHECK(press(&f, 2, 0) == E0_OK && f.obj.recorded == 0 && f.obj.record[0] == -1);
    fx_init(&f, 0);
    start(&f);
    f.obj.set_count = -1;
    CHECK(press(&f, 2, 0) == E0_OK && f.obj.recorded == 0);
    /* the record is also kept by ordered pops */
    fx_init(&f, 0);
    start(&f);
    f.body[0x23] = 1;
    f.obj.set_count = 2;
    CHECK(press(&f, 2, 0) == E0_OK && press(&f, 2, 0) == E0_OK && f.obj.recorded == 2 && f.obj.record[1] == 2);
    /* the click sound: start flag nonzero and sound A not "NO SOUND" */
    fx_init(&f, 0);
    start(&f);
    T(&f, 1000u);
    CHECK(press(&f, 1, 1) == E0_OK);
    CHECK_LOG(&f, "tick:1000:0,play:5:0");
    f.log[0] = '\0';
    f.obj.lit[1] = 0;
    CHECK(press(&f, 1, 7) == E0_OK && strstr(f.log, "play:5:0") != NULL);
    f.log[0] = '\0';
    f.obj.lit[1] = 0;
    CHECK(press(&f, 1, -1) == E0_OK && strstr(f.log, "play:5:0") != NULL);
    f.log[0] = '\0';
    f.obj.lit[1] = 0;
    CHECK(press(&f, 1, 0) == E0_OK && strstr(f.log, "play") == NULL);
    put16(f.body, 0x87, 0x1ff);
    f.obj.lit[1] = 0;
    CHECK(press(&f, 1, 1) == E0_OK && strstr(f.log, "play:511:0") != NULL);
    put16(f.body, 0x87, -2);
    CHECK(press(&f, 1, 1) == E0_OK && strstr(f.log, "play:-2:0") != NULL); /* a lit key still plays the click sound */
    set_rec(f.body, 0x66, "NO SOUND");
    f.log[0] = '\0';
    CHECK(press(&f, 1, 1) == E0_OK && strstr(f.log, "play") == NULL);
    /* the sound fails after the state change */
    fx_init(&f, 0);
    start(&f);
    f.fail_play = 1;
    CHECK(press(&f, 1, 1) == E0_ERR_HOST && f.obj.lit[1] == 1u && f.obj.typed == 1);
    (void)np;
}

static void t_click_exit_button(void)
{
    Fx f;
    uint32_t np;
    fx_init(&f, 0);
    start(&f);
    T(&f, 5000u);
    f.obj.hover = E0_EXIT_KEY;
    np = 0;
    CHECK(click(&f, 1u, E0_CANDIDATE_KEY, 1, &np) == E0_OK && np == 1u);
    CHECK_LOG(&f, "tick:5000:0,play:5:0");
    CHECK(f.obj.exit_pending == 1u && f.obj.wait_deadline == 5300u && f.obj.waiting == 0u && f.obj.typed == 0);
    for (int i = 0; i < E0_MAX_KEYS; ++i) CHECK(f.obj.lit[i] == 0u);
    CHECK(f.obj.exit_asked == 0u);
    /* the start flag and the sound record gate the sound, not the pending flag */
    fx_init(&f, 0);
    start(&f);
    f.obj.hover = E0_EXIT_KEY;
    CHECK(click(&f, 1u, E0_CANDIDATE_KEY, 0, &np) == E0_OK && f.obj.exit_pending == 1u && strstr(f.log, "play") == NULL);
    fx_init(&f, 0);
    start(&f);
    set_rec(f.body, 0x66, "NO SOUND");
    f.obj.hover = E0_EXIT_KEY;
    CHECK(click(&f, 1u, E0_CANDIDATE_KEY, 1, &np) == E0_OK && f.obj.exit_pending == 1u && strstr(f.log, "play") == NULL);
    /* the candidate does not matter for the exit button branch */
    fx_init(&f, 0);
    start(&f);
    f.obj.hover = E0_EXIT_KEY;
    CHECK(click(&f, 1u, 0, 1, &np) == E0_OK && f.obj.exit_pending == 1u && strstr(f.log, "play:5:0") != NULL);
    /* without the exit button nothing happens */
    fx_init(&f, 0);
    start(&f);
    f.body[0x24] = 0;
    f.obj.hover = E0_EXIT_KEY;
    CHECK(click(&f, 1u, E0_CANDIDATE_KEY, 1, &np) == E0_OK && f.obj.exit_pending == 0u && f.log[0] == '\0' && f.obj.lit[0x28] == 0u);
    /* the wait deadline wraps */
    fx_init(&f, 0);
    start(&f);
    T(&f, 0xffffff00u);
    f.obj.hover = E0_EXIT_KEY;
    CHECK(click(&f, 1u, E0_CANDIDATE_KEY, 0, &np) == E0_OK && f.obj.wait_deadline == (uint32_t)(0xffffff00u + 0x12cu));
    /* other hover values are keys, not the exit button */
    fx_init(&f, 0);
    start(&f);
    f.obj.hover = 0x27;
    CHECK(click(&f, 1u, E0_CANDIDATE_KEY, 0, &np) == E0_OK && f.obj.exit_pending == 0u && f.obj.lit[0x27] == 1u);
    f.obj.hover = 0x29;
    CHECK(click(&f, 1u, E0_CANDIDATE_KEY, 0, &np) == E0_OK && f.obj.exit_pending == 0u && f.obj.lit[0x29] == 1u);
    /* host failure of the sound */
    fx_init(&f, 0);
    start(&f);
    f.obj.hover = E0_EXIT_KEY;
    f.fail_play = 1;
    CHECK(click(&f, 1u, E0_CANDIDATE_KEY, 1, &np) == E0_ERR_HOST && f.obj.exit_pending == 1u);
    /* raw 0xe0 */
    fx_init(&f, 1);
    start(&f);
    f.obj.hover = E0_EXIT_KEY;
    CHECK(click(&f, 1u, E0_CANDIDATE_KEY, 1, &np) == E0_OK && f.obj.exit_pending == 1u);
}

static void t_click_exit_rectangle(void)
{
    Fx f;
    uint32_t np = 0;
    fx_init(&f, 0);
    start(&f);
    f.obj.hover = 2;
    CHECK(click(&f, 1u, E0_CANDIDATE_EXIT, 1, &np) == E0_OK && np == 2u);
    CHECK_LOG(&f, "phase:2:0");
    CHECK(f.obj.exit_asked == 1u && f.obj.lit[2] == 0u && f.obj.typed == 0 && f.obj.hover == 2);
    /* the exit rectangle candidate together with the exit button hover does both */
    fx_init(&f, 0);
    start(&f);
    f.obj.hover = E0_EXIT_KEY;
    CHECK(click(&f, 1u, E0_CANDIDATE_EXIT, 1, &np) == E0_OK && np == 2u && f.obj.exit_pending == 1u && f.obj.exit_asked == 1u);
    CHECK_LOG(&f, "tick:1000:0,play:5:0,phase:2:0");
    /* raw 0xe0 */
    fx_init(&f, 1);
    start(&f);
    f.obj.hover = -1;
    CHECK(click(&f, 1u, E0_CANDIDATE_EXIT, 0, &np) == E0_OK && np == 2u && f.obj.exit_asked == 1u);
    /* the new phase is observed by the step: phase 2 now takes the exit branch */
    CHECK(visit(&f, 2) == E0_OK && f.completed == 1 && strstr(f.log, "tr:50:") != NULL);
}

/* ---- render plan ----------------------------------------------------------------------------------------------------- */

static void expect_blit(const E0RenderPlan *p, int i, int kind, int role, const int32_t src[4], const int32_t dst[4])
{
    if (i >= p->count || i < 0) {
        fail_now("blit index beyond the plan");
        return;
    }
    if (p->blit[i].kind != (uint8_t)kind || p->blit[i].role != (uint8_t)role || memcmp(p->blit[i].src, src, 16) != 0 ||
        memcmp(p->blit[i].dst, dst, 16) != 0) {
        char m[200];
        snprintf(m, sizeof m, "blit %d: kind %d role %d src %d,%d,%d,%d dst %d,%d,%d,%d", i, p->blit[i].kind, p->blit[i].role,
                 (int)p->blit[i].src[0], (int)p->blit[i].src[1], (int)p->blit[i].src[2], (int)p->blit[i].src[3],
                 (int)p->blit[i].dst[0], (int)p->blit[i].dst[1], (int)p->blit[i].dst[2], (int)p->blit[i].dst[3]);
        fail_now(m);
    }
}

static void t_render_plan_d6(void)
{
    Fx f;
    E0RenderPlan plan;
    fx_init(&f, 0);
    start(&f);
    f.obj.lit[2] = 1;
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_OK);
    CHECK(plan.valid == 1u && plan.surface == 0x1234u && plan.count == 7);
    {
        const int32_t up0[4] = {0, 0, 9, 9}, up0d[4] = {10, 20, 19, 29};
        const int32_t up1[4] = {20, 0, 29, 9}, up1d[4] = {30, 20, 39, 29};
        const int32_t dn2s[4] = {120, 202, 129, 211}, dn2d[4] = {50, 20, 59, 29};
        const int32_t up3[4] = {60, 0, 69, 9}, up3d[4] = {70, 20, 79, 29};
        const int32_t ls[4] = {300, 400, 309, 409}, ld[4] = {20, 320, 29, 329};
        const int32_t as[4] = {500, 500, 509, 509}, ad[4] = {60, 370, 69, 379};
        const int32_t ex[4] = {200, 100, 219, 109}, exd[4] = {210, 120, 229, 129};
        expect_blit(&plan, 0, E0_BLIT_BG_OPAQUE, E0_ROLE_KEY_UP, up0, up0d);
        expect_blit(&plan, 1, E0_BLIT_BG_OPAQUE, E0_ROLE_KEY_UP, up1, up1d);
        expect_blit(&plan, 2, E0_BLIT_SHEET_KEYED, E0_ROLE_KEY_DOWN, dn2s, dn2d);
        expect_blit(&plan, 3, E0_BLIT_BG_OPAQUE, E0_ROLE_KEY_UP, up3, up3d);
        expect_blit(&plan, 4, E0_BLIT_SHEET_KEYED, E0_ROLE_ROUND_LIGHT, ls, ld);
        expect_blit(&plan, 5, E0_BLIT_SHEET_KEYED, E0_ROLE_ACTIVE_LIGHT, as, ad);
        expect_blit(&plan, 6, E0_BLIT_BG_KEYED, E0_ROLE_EXIT_UP, ex, exd);
    }
    CHECK(f.obj.waiting == 0u);
    /* blink phase on: the current light is erased from the background */
    f.obj.blink = 1;
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_OK && plan.count == 7);
    {
        const int32_t ad[4] = {50, 350, 59, 359}, add[4] = {60, 370, 69, 379};
        expect_blit(&plan, 5, E0_BLIT_BG_KEYED, E0_ROLE_ACTIVE_ERASE, ad, add);
    }
    /* round 3: three lights, the active light is the third */
    f.obj.blink = 0;
    f.obj.round = 3;
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_OK && plan.count == 4 + 3 + 1 + 1);
    {
        const int32_t l0s[4] = {300, 400, 309, 409}, l0d[4] = {20, 320, 29, 329};
        const int32_t l1s[4] = {310, 400, 319, 409}, l1d[4] = {40, 320, 49, 329};
        const int32_t l2s[4] = {320, 400, 329, 409}, l2d[4] = {60, 320, 69, 329};
        const int32_t as[4] = {520, 500, 529, 509}, ad[4] = {100, 370, 109, 379};
        expect_blit(&plan, 4, E0_BLIT_SHEET_KEYED, E0_ROLE_ROUND_LIGHT, l0s, l0d);
        expect_blit(&plan, 5, E0_BLIT_SHEET_KEYED, E0_ROLE_ROUND_LIGHT, l1s, l1d);
        expect_blit(&plan, 6, E0_BLIT_SHEET_KEYED, E0_ROLE_ROUND_LIGHT, l2s, l2d);
        expect_blit(&plan, 7, E0_BLIT_SHEET_KEYED, E0_ROLE_ACTIVE_LIGHT, as, ad);
    }
    /* round 0: no lights, no active light */
    f.obj.round = 0;
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_OK && plan.count == 5);
    /* a light whose destination has zero height is skipped (equality, not sign) */
    f.obj.round = 2;
    put_rect(f.body, 0x15e, 10, 300, 19, 300);
    put_rect(f.body, 0x1fe + 16, 70, 350, 79, 350);
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_OK && plan.count == 4 + 1 + 0 + 1);
    put_rect(f.body, 0x15e, 10, 309, 19, 300); /* negative height still draws */
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_OK && plan.count == 4 + 2 + 0 + 1);
    {
        const int32_t ls[4] = {300, 400, 309, 409}, ld[4] = {20, 329, 29, 320};
        expect_blit(&plan, 4, E0_BLIT_SHEET_KEYED, E0_ROLE_ROUND_LIGHT, ls, ld);
    }
    /* the exit button pressed: the pressed source is blitted and the callback sets waiting */
    fx_init(&f, 0);
    start(&f);
    f.obj.exit_pending = 1;
    CHECK(f.obj.waiting == 0u);
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_OK && plan.count == 7);
    {
        const int32_t src[4] = {500, 0, 509, 9}, dst[4] = {210, 120, 229, 129};
        expect_blit(&plan, 6, E0_BLIT_SHEET_KEYED, E0_ROLE_EXIT_DOWN, src, dst);
    }
    CHECK(f.obj.waiting == 1u);
    /* the exit rectangle is drawn even when the exit button flag is 0 */
    f.body[0x24] = 0;
    f.obj.exit_pending = 0;
    f.obj.waiting = 1;
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_OK && plan.count == 7 && f.obj.waiting == 1u);
    {
        const int32_t src[4] = {200, 100, 219, 109}, dst[4] = {210, 120, 229, 129};
        expect_blit(&plan, 6, E0_BLIT_BG_KEYED, E0_ROLE_EXIT_UP, src, dst);
    }
    /* view origin applied to every destination */
    f.vx = -100;
    f.vy = 1000;
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_OK);
    {
        const int32_t up0[4] = {0, 0, 9, 9}, up0d[4] = {-100, 1000, -91, 1009};
        expect_blit(&plan, 0, E0_BLIT_BG_OPAQUE, E0_ROLE_KEY_UP, up0, up0d);
    }
}

static void t_render_plan_limits(void)
{
    Fx f;
    E0RenderPlan plan;
    /* tiles hidden: nothing drawn, the host origin is not even asked */
    fx_init(&f, 0);
    start(&f);
    f.obj.tiles_visible = 0;
    f.fail_origin = 1;
    memset(&plan, 0x55, sizeof plan);
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_OK && plan.valid == 0u && plan.count == 0);
    f.obj.tiles_visible = 1;
    memset(&plan, 0x55, sizeof plan);
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_ERR_HOST);
    f.fail_origin = 0;
    /* raw 0xe0 draws keys and the exit rectangle only, whatever the round is */
    fx_init(&f, 1);
    start(&f);
    f.obj.round = 3;
    f.obj.lit[1] = 1;
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_OK && plan.valid == 1u && plan.count == 5);
    {
        const int32_t s1[4] = {18, 6, 28, 14}, d1[4] = {126, 70, 136, 78};
        const int32_t k0[4] = {100, 50, 110, 58}, k0d[4] = {110, 70, 120, 78};
        expect_blit(&plan, 0, E0_BLIT_BG_OPAQUE, E0_ROLE_KEY_UP, k0, k0d);
        (void)s1;
        (void)d1;
        CHECK(plan.blit[1].kind == E0_BLIT_SHEET_KEYED && plan.blit[1].role == E0_ROLE_KEY_DOWN);
        CHECK(plan.blit[1].src[0] == 18 && plan.blit[1].src[1] == 6 && plan.blit[1].src[2] == 28 && plan.blit[1].src[3] == 14);
        CHECK(plan.blit[1].dst[0] == 126 && plan.blit[1].dst[1] == 70 && plan.blit[1].dst[2] == 136 && plan.blit[1].dst[3] == 78);
        CHECK(plan.blit[4].role == E0_ROLE_EXIT_UP);
    }
    /* flag byte decides: an object flag of 1 never draws lights even for a d6 sized body */
    fx_init(&f, 0);
    start(&f);
    f.obj.flag = 1;
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_OK && plan.count == 5);
    /* the body count: more than 100 keys is a bounds error */
    fx_init(&f, 0);
    start(&f);
    put16(f.body, 0x21, 101);
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_ERR_BOUNDS);
    put16(f.body, 0x21, 100);
    f.obj.round = 5;
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_OK && plan.count == 100 + 5 + 1 + 1);
    /* the blit array limit: 100 keys + 10 lights + the active light + the exit blit = 112 */
    f.obj.round = 10;
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_OK && plan.count == E0_MAX_BLITS);
    f.obj.round = 12;
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_ERR_BOUNDS);
    /* exactly one blit too many: round 11 with a light and an active light of nonzero height needs 113 */
    put_rect(f.body, 0x1fe, 0, 0, 9, 9);
    put_rect(f.body, 0x29e, 0, 0, 9, 9);
    f.obj.round = 11;
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_ERR_BOUNDS);
    f.obj.round = 30;
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_ERR_BOUNDS);
    put16(f.body, 0x21, 106);
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_ERR_BOUNDS);
    /* a round outside the body */
    fx_init(&f, 0);
    start(&f);
    f.obj.round = 200;
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_ERR_BOUNDS);
    f.obj.round = 100;
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_ERR_BOUNDS);
    /* no keys: the last round whose light and active rectangles lie in the body */
    put16(f.body, 0x21, 0);
    f.obj.round = 76;
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_OK && plan.valid == 1u && plan.count <= 78);
    f.obj.round = 77;
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_ERR_BOUNDS);
    f.obj.round = 87;
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_ERR_BOUNDS);
    put16(f.body, 0x21, 4);
    f.obj.round = 6;
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_OK && plan.count == 4 + 6 + 1 + 1);
}

/* ---- invalidate, cleanup, scene reset -------------------------------------------------------------------------------- */

static void t_invalidate(void)
{
    Fx f;
    fx_init(&f, 0);
    start(&f);
    CHECK(e0_invalidate(&f.obj, &f.host) == E0_OK);
    CHECK_LOG(&f, "dirty:24:0");
    f.log[0] = '\0';
    f.obj.slot = 0x3a;
    CHECK(e0_invalidate(&f.obj, &f.host) == E0_OK);
    CHECK_LOG(&f, "dirty:58:0");
    f.log[0] = '\0';
    f.obj.slot = E0_NO_SLOT;
    CHECK(e0_invalidate(&f.obj, &f.host) == E0_OK && f.log[0] == '\0');
    f.obj.slot = 24;
    f.obj.active = 0;
    CHECK(e0_invalidate(&f.obj, &f.host) == E0_OK && f.log[0] == '\0');
    f.obj.active = 1;
    f.fail_dirty = 1;
    CHECK(e0_invalidate(&f.obj, &f.host) == E0_ERR_HOST);
    /* an object that never started */
    fx_init(&f, 0);
    CHECK(e0_invalidate(&f.obj, &f.host) == E0_OK && f.log[0] == '\0');
}

static void t_cleanup(void)
{
    Fx f;
    fx_init(&f, 0);
    start(&f);
    f.obj.solved = 1;
    f.obj.solved_sets = 1;
    f.obj.exit_asked = 1;
    f.obj.blink = 1;
    f.obj.typed = 3;
    f.obj.state = 3;
    f.obj.round = 2;
    f.obj.waiting = 1;
    f.obj.hover = 4;
    CHECK(e0_cleanup(&f.obj, &f.host) == E0_OK);
    CHECK_LOG(&f, "relsurf:4660:0,relslot:24:0");
    CHECK(f.obj.row == -1 && f.obj.slot == -1 && f.obj.surface == 0u && f.obj.active == 0u && f.obj.exit_asked == 0u &&
          f.obj.solved == 0u && f.obj.solved_sets == 0u && f.obj.blink == 0u && f.obj.initialized == 0u);
    /* fields the reset does not touch */
    CHECK(f.obj.typed == 3 && f.obj.state == 3 && f.obj.round == 2 && f.obj.waiting == 1u && f.obj.hover == 4 &&
          f.obj.tiles_visible == 1u && f.obj.rounds == 3 && f.obj.code_len == 2);
    /* idempotent, with no effects the second time */
    f.log[0] = '\0';
    CHECK(e0_cleanup(&f.obj, &f.host) == E0_OK && f.log[0] == '\0');
    /* a held surface but no slot, and a slot but no surface */
    fx_init(&f, 0);
    f.obj.surface = 0x42u;
    CHECK(e0_cleanup(&f.obj, &f.host) == E0_OK);
    CHECK_LOG(&f, "relsurf:66:0");
    fx_init(&f, 0);
    f.obj.slot = 30;
    CHECK(e0_cleanup(&f.obj, &f.host) == E0_OK);
    CHECK_LOG(&f, "relslot:30:0");
    fx_init(&f, 0);
    f.obj.slot = 0;
    CHECK(e0_cleanup(&f.obj, &f.host) == E0_OK);
    CHECK_LOG(&f, "relslot:0:0");
    /* failures keep what was not released */
    fx_init(&f, 0);
    start(&f);
    f.fail_relsurf = 1;
    CHECK(e0_cleanup(&f.obj, &f.host) == E0_ERR_HOST && f.obj.surface == 0x1234u && f.obj.slot == 24 && f.obj.active == 1u);
    f.fail_relsurf = 0;
    f.fail_relslot = 1;
    CHECK(e0_cleanup(&f.obj, &f.host) == E0_ERR_HOST && f.obj.surface == 0u && f.obj.slot == 24 && f.obj.active == 1u);
}

/* ---- a few whole runs ------------------------------------------------------------------------------------------------ */

static void t_run_unordered_d6(void)
{
    Fx f;
    E0PointerResult p;
    uint32_t np = 0;
    /* no exit button, unordered code {1,2}, round 1 of 3 with sound B: type 1 then 2, wait, solve, show, win sound, next round */
    fx_init(&f, 0);
    f.body[0x24] = 0;
    CHECK(visit(&f, 0) == E0_OK);
    f.log[0] = '\0';
    T(&f, 1000u);
    CHECK(pointer(&f, 25, 5, &p) == E0_OK && p.hit == 1u);
    CHECK(click(&f, 1u, p.candidate, 1, &np) == E0_OK && f.obj.waiting == 1u && f.obj.wait_deadline == 1300u);
    T(&f, 1100u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.waiting == 1u && f.obj.state == 0); /* still waiting */
    T(&f, 1400u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.waiting == 0u && f.obj.lit[1] == 0u && f.obj.typed == 1 && f.obj.solved == 0u);
    T(&f, 1500u);
    CHECK(pointer(&f, 45, 5, &p) == E0_OK && p.hit == 1u);
    CHECK(click(&f, 1u, p.candidate, 1, &np) == E0_OK && f.obj.typed == 2);
    CHECK(f.obj.player[0] == 1 && f.obj.player[1] == 2);
    T(&f, 2000u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.waiting == 0u && f.obj.solved == 1u && f.obj.state == 0);
    CHECK(visit(&f, 1) == E0_OK && f.obj.state == 1 && f.obj.solved == 0u && f.obj.typed == 0); /* round 1 < 3 */
    T(&f, 3000u, 3010u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.state == 3 && f.obj.show_deadline == 3000u + 2400u);
    T(&f, 4000u, 4000u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.state == 3);
    T(&f, 6000u);
    f.log[0] = '\0';
    CHECK(visit(&f, 1) == E0_OK && f.obj.state == 4);
    CHECK_LOG(&f, "tick:6000:0,prep:178:0,play:9:0");
    f.log[0] = '\0';
    BUSY(&f, 1, 1, 0);
    T(&f, 6100u, 6100u, 6100u, 6100u, 6100u, 6100u, 6100u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.state == 4);
    CHECK(visit(&f, 1) == E0_OK && f.obj.state == 4);
    CHECK(visit(&f, 1) == E0_OK && f.obj.state == 0 && f.obj.round == 2 && f.obj.code[0] == 10);
    CHECK(strstr(f.log, "stop:178:0") != NULL);
    CHECK(f.phase == 1u);
}

static void t_run_exit_d6(void)
{
    Fx f;
    E0PointerResult p;
    uint32_t np = 0;
    E0RenderPlan plan;
    fx_init(&f, 0);
    CHECK(visit(&f, 0) == E0_OK);
    f.log[0] = '\0';
    T(&f, 100u);
    /* pointer over the exit button, click, render (pressed -> waiting), wait, then state 1 (round count reached) */
    CHECK(pointer(&f, 210, 105, &p) == E0_OK && p.hit == 1u && f.obj.hover == E0_EXIT_KEY);
    CHECK(click(&f, 1u, p.candidate, 1, &np) == E0_OK && f.obj.exit_pending == 1u && f.obj.wait_deadline == 400u);
    CHECK(e0_render_plan(&f.obj, f.body, f.body_len, &f.host, &plan) == E0_OK && f.obj.waiting == 1u);
    T(&f, 400u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.waiting == 1u);
    T(&f, 401u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.waiting == 0u && f.obj.exit_pending == 0u && f.obj.solved == 0u && f.obj.state == 0);
    /* now the exit rectangle ends the puzzle */
    CHECK(pointer(&f, 305, 205, &p) == E0_OK && p.candidate == E0_CANDIDATE_EXIT);
    CHECK(click(&f, 1u, p.candidate, 1, &np) == E0_OK && np == 2u);
    f.log[0] = '\0';
    CHECK(visit(&f, 2) == E0_OK && f.phase == 2u && f.completed == 1);
    CHECK(strstr(f.log, "tr:50:4:5:6:44:55:66") != NULL && strstr(f.log, "complete:3:0,relsurf:4660:0,relslot:24:0") != NULL);
    CHECK(f.obj.active == 0u && f.obj.slot == -1);
    /* after cleanup the pointer claims nothing */
    CHECK(pointer(&f, 305, 205, &p) == E0_OK && p.hit == 0u && f.obj.hover == -1);
    /* and a new visit starts fresh, keeping the round the process word holds */
    CHECK(visit(&f, 0) == E0_OK && f.obj.round == 1 && f.obj.surface == 0x1234u);
}

static void t_run_e0_scene(void)
{
    Fx f;
    uint32_t np = 0;
    E0PointerResult p;
    /* raw 0xe0: scene word 5, unordered code {1,2}, no sound B and no exit button flag */
    fx_init(&f, 1);
    f.body[0x24] = 0;
    set_rec(f.body, 0xb2, "NO SOUND");
    CHECK(visit(&f, 0) == E0_OK);
    f.log[0] = '\0';
    T(&f, 10u);
    CHECK(pointer(&f, 117, 51, &p) == E0_OK && f.obj.hover == 1);
    CHECK(click(&f, 1u, p.candidate, 0, &np) == E0_OK && f.obj.waiting == 1u && f.obj.wait_deadline == 310u);
    CHECK(pointer(&f, 101, 61, &p) == E0_OK && p.hit == 0u && f.obj.hover == -1); /* keys are suppressed while waiting */
    T(&f, 400u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.waiting == 0u && f.obj.lit[1] == 0u && f.obj.typed == 1 && f.obj.solved == 0u);
    CHECK(pointer(&f, 101, 61, &p) == E0_OK && p.hit == 1u && f.obj.hover == 2);
    T(&f, 500u);
    CHECK(click(&f, 1u, p.candidate, 0, &np) == E0_OK && f.obj.typed == 2 && f.obj.player[0] == 1 && f.obj.player[1] == 2);
    T(&f, 900u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.waiting == 0u && f.obj.solved == 1u && f.obj.state == 0);
    CHECK(visit(&f, 1) == E0_OK && f.obj.state == 1 && f.obj.solved == 1u); /* round 0: the flag stays */
    T(&f, 1000u, 1000u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.state == 3 && f.obj.show_deadline == 3400u);
    T(&f, 2000u);
    CHECK(visit(&f, 1) == E0_OK && f.obj.state == 3 && f.phase == 1u);
    T(&f, 3400u);
    CHECK(visit(&f, 1) == E0_OK && f.phase == 2u); /* typed is 2, so the scene shortcut is not taken; solved finishes */
    f.log[0] = '\0';
    CHECK(visit(&f, 2) == E0_OK && f.completed == 1 && strstr(f.log, "x57b:60:0,tr:60:1:2:3") != NULL);
    /* with nothing typed the scene word itself is the next scene */
    fx_init(&f, 1);
    CHECK(visit(&f, 0) == E0_OK);
    f.obj.state = 3;
    f.obj.show_deadline = 0u;
    f.log[0] = '\0';
    CHECK(visit(&f, 1) == E0_OK && f.phase == 2u);
    f.log[0] = '\0';
    CHECK(visit(&f, 2) == E0_OK && strstr(f.log, "x57b:5:0,tr:5:1:2:3:11:22:33") != NULL);
}

/* ---- the session binding --------------------------------------------------------------------------------------------- */

static void put_be32(uint8_t *b, size_t off, size_t v)
{
    for (int i = 0; i < 4; ++i) b[off + (size_t)i] = (uint8_t)(v >> (24 - 8 * i));
}

static size_t put_chunk(uint8_t *out, size_t pos, const char *id, const uint8_t *payload, size_t n)
{
    memcpy(out + pos, id, 4);
    put_be32(out, pos + 4, n);
    memcpy(out + pos + 8, payload, n);
    pos += 8 + n;
    if (n & 1u) out[pos++] = 0;
    return pos;
}

static size_t build_scene(uint8_t *out, size_t rows, const int *types, const uint8_t *const *bodies, const size_t *lengths)
{
    uint8_t tsum[126], act[48 + 2 + E0_BODY_CAPACITY];
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

typedef struct Bind {
    Fx f;            /* the host record and the d6 / e0 bodies */
    SessionAe0Host host;
    SessionAe0Binding *b;
    SceneResource *scene;
    uint8_t bytes[8192];
    uint8_t body_d6[E0_BODY_BYTES_D6], body_e0[E0_BODY_BYTES_E0];
    int world_stores;
    E0World world_seen;
    int32_t cell;
    int use_cell;
} Bind;

static void h_store_world(void *c, const E0World *w)
{
    Bind *x = (Bind *)((char *)c - offsetof(Bind, f));
    ++x->world_stores;
    x->world_seen = *w;
}

static int32_t h_scene_cell(void *c)
{
    Bind *x = (Bind *)((char *)c - offsetof(Bind, f));
    return x->cell;
}

static int bind_open(Bind *x, int with_cell)
{
    const int types[4] = {0x70, 0xd6, 0xe0, 0xd6};
    const uint8_t one = 0;
    const uint8_t *bodies[4];
    size_t lengths[4] = {1, E0_BODY_BYTES_D6, E0_BODY_BYTES_E0, E0_BODY_BYTES_D6};
    size_t n;
    char err[128] = {0};
    memset(x, 0, sizeof *x);
    fx_init(&x->f, 0);
    memcpy(x->body_d6, x->f.body, E0_BODY_BYTES_D6);
    fx_init(&x->f, 1);
    memcpy(x->body_e0, x->f.body, E0_BODY_BYTES_E0);
    /* the e0 row's keys sit elsewhere: grid origin 300, so the two rows can be told apart by the pointer */
    put16(x->body_e0, 0x11e, 300);
    bodies[0] = &one;
    bodies[1] = x->body_d6;
    bodies[2] = x->body_e0;
    bodies[3] = x->body_d6;
    n = build_scene(x->bytes, 4, types, bodies, lengths);
    x->scene = scene_resource_open_memory(x->bytes, n, err, sizeof err);
    if (x->scene == NULL) return 0;
    fx_init(&x->f, 0);
    memset(&x->host, 0, sizeof x->host);
    x->host.kernel = x->f.host;
    x->host.store_world = h_store_world;
    if (with_cell) x->host.scene_cell = h_scene_cell;
    x->b = session_ae0_create(&x->host);
    return x->b != NULL;
}

static void bind_close(Bind *x)
{
    session_ae0_destroy(x->b);
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
        const int rc = session_ae0_handler(x->b, row, &info, &st, &out);
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
    uint32_t ph = 99u, np = 0u;
    int done = -1;
    E0PointerResult p;
    E0RenderPlan plan;
    if (!bind_open(&x, 0)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_ae0_begin_scene(x.b, x.scene) == E0_OK && strcmp(session_ae0_failure(x.b), "none") == 0);
    CHECK(session_ae0_registered(x.b) == 0u && session_ae0_state(x.b)->active == 0u);
    /* a row of another type and an unknown index are not ours */
    {
        SceneActionInfo info, other;
        SceneActionRuntimeState st;
        SceneActionHandlerResult out;
        memset(&st, 0, sizeof st);
        CHECK(scene_resource_action_at(x.scene, 0, &info) == SCENE_RESOURCE_OK);
        CHECK(session_ae0_handler(x.b, 0, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(strcmp(session_ae0_failure(x.b), "keypad-row-not-owned") == 0);
        CHECK(scene_resource_action_at(x.scene, 1, &info) == SCENE_RESOURCE_OK);
        CHECK(session_ae0_handler(x.b, 9, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        x.f.log[0] = '\0';
        CHECK(scene_resource_action_at(x.scene, 0, &other) == SCENE_RESOURCE_OK);
        CHECK(session_ae0_handler(x.b, 1, &other, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_ae0_handler(x.b, 0, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(strcmp(session_ae0_failure(x.b), "keypad-row-not-owned") == 0); /* row 0 is not a keypad row */
        CHECK(x.f.log[0] == '\0');
        CHECK(session_ae0_handler(x.b, 1, NULL, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_ae0_handler(x.b, 1, &info, NULL, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_ae0_handler(x.b, 1, &info, &st, NULL) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_ae0_handler(NULL, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
    }
    /* phase 1 before phase 0 is unsupported; the failure text says why */
    {
        SceneActionInfo info;
        SceneActionRuntimeState st;
        SceneActionHandlerResult out;
        memset(&st, 0, sizeof st);
        st.phase = 1u;
        CHECK(scene_resource_action_at(x.scene, 1, &info) == SCENE_RESOURCE_OK);
        CHECK(session_ae0_handler(x.b, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
        CHECK(strcmp(session_ae0_failure(x.b), "keypad-phase-without-init") == 0);
        st.phase = 2u;
        CHECK(session_ae0_handler(x.b, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    }
    /* pointer, click and plan before the puzzle starts */
    CHECK(session_ae0_pointer_move(x.b, 5, 5, &p) == E0_OK && p.hit == 0u && p.candidate == -1 && p.cursor == 0u);
    CHECK(session_ae0_state(x.b)->hover == -1);
    CHECK(session_ae0_click(x.b, 1u, E0_CANDIDATE_KEY, 1, &np) == E0_OK && np == 1u);
    CHECK(session_ae0_click(x.b, 7u, E0_CANDIDATE_KEY, 1, &np) == E0_OK && np == 7u); /* the row phase passes through */
    CHECK(session_ae0_click(x.b, 1u, E0_CANDIDATE_EXIT, 1, &np) == E0_OK && np == 1u && session_ae0_state(x.b)->exit_asked == 0u);
    memset(&plan, 0x55, sizeof plan);
    CHECK(session_ae0_render_plan(x.b, &plan) == E0_OK && plan.valid == 0u && plan.count == 0);
    CHECK(session_ae0_invalidate(x.b) == E0_OK && x.f.log[0] == '\0');
    /* phase 0 of the raw 0xd6 row */
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u && done == 0);
    CHECK(x.world_stores == 1 && x.world_seen.start_flag_5bb1ca == 1);
    CHECK(session_ae0_registered(x.b) == 1u && session_ae0_state(x.b)->active == 1u && session_ae0_state(x.b)->row == 1);
    CHECK(session_ae0_state(x.b)->flag == 0u && session_ae0_state(x.b)->surface == 0x1234u);
    CHECK(session_ae0_invalidate(x.b) == E0_OK && strstr(x.f.log, "dirty:24:0") != NULL);
    CHECK(session_ae0_render_plan(x.b, &plan) == E0_OK && plan.valid == 1u && plan.surface == 0x1234u && plan.count == 7);
    /* the pointer and click use the body of the active row */
    CHECK(session_ae0_pointer_move(x.b, 5, 5, &p) == E0_OK && p.hit == 1u && p.candidate == E0_CANDIDATE_KEY && p.cursor == E0_CURSOR_PICK);
    CHECK(session_ae0_state(x.b)->hover == 0);
    CHECK(session_ae0_pointer_move(x.b, 305, 205, &p) == E0_OK && p.hit == 1u && p.candidate == E0_CANDIDATE_EXIT && p.cursor == E0_CURSOR_EXIT);
    CHECK(session_ae0_pointer_move(x.b, 5, 5, &p) == E0_OK);
    T(&x.f, 1000u);
    x.f.log[0] = '\0';
    CHECK(session_ae0_click(x.b, 1u, E0_CANDIDATE_KEY, 1, &np) == E0_OK && np == 1u && session_ae0_state(x.b)->lit[0] == 1u);
    CHECK(strstr(x.f.log, "play:5:0") != NULL); /* the click channel of the active row's body */
    CHECK(strcmp(session_ae0_failure(x.b), "none") == 0);
    CHECK(session_ae0_click(x.b, 7u, E0_CANDIDATE_KEY, 1, &np) == E0_OK && np == 7u); /* the row phase passes through */
    /* phase 1 visits write no world and stay pending */
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u && done == 0 && x.world_stores == 1);
    /* exit rectangle: new phase 2, then the finish completes and stores the world */
    CHECK(session_ae0_pointer_move(x.b, 305, 205, &p) == E0_OK);
    CHECK(session_ae0_click(x.b, 1u, p.candidate, 1, &np) == E0_OK && np == 2u);
    x.f.log[0] = '\0';
    CHECK(b_visit(&x, 1, 2u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 2u && done == 1);
    CHECK(x.world_stores == 2 && x.world_seen.start_flag_5bb1ca == 1 && x.world_seen.scene_cell_5bb57b == 50);
    CHECK(session_ae0_state(x.b)->active == 0u && session_ae0_registered(x.b) == 0u);
    CHECK(strstr(x.f.log, "tr:50:") != NULL && strstr(x.f.log, "evflag:8:9") != NULL);
    /* the raw 0xe0 row: its own body (keys at x 300), 4 keys from the grid, zero padded body */
    x.f.log[0] = '\0';
    CHECK(b_visit(&x, 2, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u && done == 0);
    CHECK(session_ae0_state(x.b)->flag == 1u && session_ae0_state(x.b)->row == 2);
    CHECK(session_ae0_pointer_move(x.b, 305, 55, &p) == E0_OK && p.hit == 1u && session_ae0_state(x.b)->hover == 0);
    CHECK(session_ae0_pointer_move(x.b, 5, 5, &p) == E0_OK && p.hit == 0u);
    CHECK(session_ae0_render_plan(x.b, &plan) == E0_OK && plan.valid == 1u && plan.count == 5);
    CHECK(session_ae0_pointer_move(x.b, 305, 205, &p) == E0_OK && p.candidate == E0_CANDIDATE_EXIT);
    CHECK(session_ae0_click(x.b, 1u, p.candidate, 1, &np) == E0_OK && np == 2u);
    CHECK(b_visit(&x, 2, 2u, &ph, &done) == SCENE_ACTION_HANDLER_OK && done == 1 && strstr(x.f.log, "evflag:8:9") != NULL);
    /* a phase beyond 2 is pending and untouched */
    CHECK(b_visit(&x, 1, 5u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 5u && done == 0);
    /* an active puzzle whose row is not a keypad row or lies outside the scene (native guard): every entry point refuses it */
    CHECK(b_visit(&x, 2, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && session_ae0_state(x.b)->active == 1u);
    {
        E0Object *o = (E0Object *)session_ae0_state(x.b);
        static const int16_t bad_rows[] = {0, 4, 99, -1, -7};
        for (size_t i = 0; i < sizeof bad_rows / sizeof bad_rows[0]; ++i) {
            o->row = bad_rows[i];
            o->hover = 3;
            memset(&plan, 0x55, sizeof plan);
            CHECK(session_ae0_pointer_move(x.b, 305, 55, &p) == E0_ERR_ARGUMENT && p.hit == 0u && p.candidate == -1);
            CHECK(session_ae0_click(x.b, 1u, E0_CANDIDATE_EXIT, 1, &np) == E0_ERR_ARGUMENT && np == 1u);
            CHECK(session_ae0_render_plan(x.b, &plan) == E0_ERR_ARGUMENT && plan.valid == 0u && plan.count == 0);
        }
        /* hidden or unregistered: nothing is drawn and the row is not even looked up */
        o->row = -1;
        o->tiles_visible = 0u;
        memset(&plan, 0x55, sizeof plan);
        CHECK(session_ae0_render_plan(x.b, &plan) == E0_OK && plan.valid == 0u && plan.count == 0);
        o->tiles_visible = 1u;
        o->slot = E0_NO_SLOT;
        memset(&plan, 0x55, sizeof plan);
        CHECK(session_ae0_render_plan(x.b, &plan) == E0_OK && plan.valid == 0u && plan.count == 0);
        o->row = 2;
        memset(&plan, 0x55, sizeof plan);
        CHECK(session_ae0_render_plan(x.b, &plan) == E0_OK && plan.valid == 0u && plan.count == 0);
        CHECK(session_ae0_registered(x.b) == 0u);
        o->slot = 24;
        CHECK(session_ae0_registered(x.b) == 1u);
        CHECK(session_ae0_render_plan(x.b, &plan) == E0_OK && plan.valid == 1u);
    }
    /* argument checks */
    CHECK(session_ae0_pointer_move(NULL, 0, 0, &p) == E0_ERR_ARGUMENT);
    CHECK(session_ae0_pointer_move(x.b, 0, 0, NULL) == E0_ERR_ARGUMENT);
    CHECK(session_ae0_click(NULL, 1u, 1, 1, &np) == E0_ERR_ARGUMENT);
    CHECK(session_ae0_click(x.b, 1u, 1, 1, NULL) == E0_ERR_ARGUMENT);
    CHECK(session_ae0_render_plan(NULL, &plan) == E0_ERR_ARGUMENT);
    CHECK(session_ae0_render_plan(x.b, NULL) == E0_ERR_ARGUMENT);
    CHECK(session_ae0_invalidate(NULL) == E0_ERR_ARGUMENT);
    CHECK(session_ae0_begin_scene(NULL, x.scene) == E0_ERR_ARGUMENT);
    CHECK(session_ae0_begin_scene(x.b, NULL) == E0_ERR_ARGUMENT);
    CHECK(session_ae0_registered(NULL) == 0u && session_ae0_state(NULL) == NULL);
    CHECK(strcmp(session_ae0_failure(NULL), "keypad-binding-unbound") == 0);
    CHECK(session_ae0_create(NULL) == NULL);
    session_ae0_destroy(NULL);
    bind_close(&x);
}

static void t_binding_world_and_scene_cell(void)
{
    Bind x;
    uint32_t ph = 0u;
    int done = 0;
    SceneActionInfo info;
    SceneActionRuntimeState st;
    SceneActionHandlerResult out;
    /* a scene whose raw 0xd6 failed block has no scene: without a scene_cell callback the binding keeps its own copy (9999)
     * and nothing is transferred; with the callback the stale cell it reports is used */
    for (int with_cell = 0; with_cell < 2; ++with_cell) {
        const int types[1] = {0xd6};
        const uint8_t *bodies[1];
        size_t lengths[1] = {E0_BODY_BYTES_D6};
        size_t n;
        char err[128] = {0};
        if (!bind_open(&x, with_cell)) {
            CHECK(0 && "scene opens");
            return;
        }
        scene_resource_close(x.scene);
        put16(x.body_d6, 0x97, E0_NO_SCENE);
        bodies[0] = x.body_d6;
        n = build_scene(x.bytes, 1, types, bodies, lengths);
        x.scene = scene_resource_open_memory(x.bytes, n, err, sizeof err);
        CHECK(x.scene != NULL);
        if (x.scene == NULL) return;
        x.cell = 77;
        CHECK(session_ae0_begin_scene(x.b, x.scene) == E0_OK);
        CHECK(b_visit(&x, 0, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
        x.f.log[0] = '\0';
        CHECK(b_visit(&x, 0, 2u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 2u && done == 1);
        if (with_cell) {
            CHECK(strstr(x.f.log, "tr:77:1:2:3") != NULL && x.world_seen.scene_cell_5bb57b == 77);
        } else {
            CHECK(strstr(x.f.log, "tr:") == NULL && x.world_seen.scene_cell_5bb57b == E0_NO_SCENE);
        }
        /* the callback is read for phase 2 only */
        memset(&st, 0, sizeof st);
        st.phase = 0u;
        CHECK(scene_resource_action_at(x.scene, 0, &info) == SCENE_RESOURCE_OK);
        x.cell = 1234;
        CHECK(session_ae0_handler(x.b, 0, &info, &st, &out) == SCENE_ACTION_HANDLER_OK);
        CHECK(x.world_seen.scene_cell_5bb57b != 1234);
        bind_close(&x);
    }
}

static void t_binding_scene_change_clears(void)
{
    Bind x;
    uint32_t ph = 0u, np = 0u;
    int done = 0;
    E0PointerResult p;
    if (!bind_open(&x, 0)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_ae0_begin_scene(x.b, x.scene) == E0_OK);
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    CHECK(session_ae0_state(x.b)->round == 1);
    x.f.log[0] = '\0';
    /* the next scene's clear releases the surface and the slot and resets the round word */
    CHECK(session_ae0_begin_scene(x.b, x.scene) == E0_OK);
    CHECK_LOG(&x.f, "relsurf:4660:0,relslot:24:0");
    CHECK(session_ae0_state(x.b)->active == 0u && session_ae0_registered(x.b) == 0u);
    CHECK(session_ae0_state(x.b)->round == 0 && session_ae0_state(x.b)->word_5957b5 == 0);
    CHECK(session_ae0_pointer_move(x.b, 5, 5, &p) == E0_OK && p.hit == 0u);
    CHECK(session_ae0_click(x.b, 1u, E0_CANDIDATE_EXIT, 1, &np) == E0_OK && np == 1u);
    /* the new scene's rows need their own phase 0 */
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    /* destroy clears too */
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    x.f.log[0] = '\0';
    bind_close(&x);
    CHECK_LOG(&x.f, "relsurf:4660:0,relslot:24:0");
}

static void t_binding_refuses_bad_body(void)
{
    Bind x;
    uint8_t bad[E0_BODY_BYTES_D6];
    const int types[2] = {0xd6, 0xd6};
    const uint8_t *bodies[2];
    size_t lengths[2] = {E0_BODY_BYTES_D6, E0_BODY_BYTES_D6};
    size_t n;
    char err[128] = {0};
    uint32_t ph = 0u;
    int done = 0;
    SceneResource *bad_scene;
    if (!bind_open(&x, 0)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_ae0_begin_scene(x.b, x.scene) == E0_OK);
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    memcpy(bad, x.body_d6, sizeof bad);
    put16(bad, 0x21, 101);
    bodies[0] = x.body_d6;
    bodies[1] = bad;
    n = build_scene(x.bytes, 2, types, bodies, lengths);
    bad_scene = scene_resource_open_memory(x.bytes, n, err, sizeof err);
    CHECK(bad_scene != NULL);
    if (bad_scene != NULL) {
        CHECK(session_ae0_begin_scene(x.b, bad_scene) == E0_ERR_BODY);
        CHECK(strcmp(session_ae0_failure(x.b), "keypad-key-count") == 0);
        /* the refusal comes before the clear: the running puzzle is untouched */
        CHECK(session_ae0_state(x.b)->active == 1u && session_ae0_state(x.b)->round == 1);
        scene_resource_close(bad_scene);
    }
    /* a bad raw 0xe0 body is refused too (the grid product exceeds 100) */
    {
        uint8_t bad_e0[E0_BODY_BYTES_E0];
        const int t2[1] = {0xe0};
        const uint8_t *b2[1];
        size_t l2[1] = {E0_BODY_BYTES_E0};
        memcpy(bad_e0, x.body_e0, sizeof bad_e0);
        put16(bad_e0, 0x10e, 11);
        put16(bad_e0, 0x110, 10);
        b2[0] = bad_e0;
        n = build_scene(x.bytes, 1, t2, b2, l2);
        bad_scene = scene_resource_open_memory(x.bytes, n, err, sizeof err);
        CHECK(bad_scene != NULL);
        if (bad_scene != NULL) {
            CHECK(session_ae0_begin_scene(x.b, bad_scene) == E0_ERR_BODY && strcmp(session_ae0_failure(x.b), "keypad-key-count") == 0);
            scene_resource_close(bad_scene);
        }
    }
    /* a failing release during the next scene's clear is a host error and keeps the old rows */
    x.f.fail_relsurf = 1;
    CHECK(session_ae0_begin_scene(x.b, x.scene) == E0_ERR_HOST && strcmp(session_ae0_failure(x.b), "keypad-scene-clear") == 0);
    CHECK(session_ae0_state(x.b)->active == 1u && session_ae0_state(x.b)->surface == 0x1234u);
    CHECK(session_ae0_state(x.b)->round == 1);
    x.f.fail_relsurf = 0;
    CHECK(session_ae0_begin_scene(x.b, x.scene) == E0_OK && session_ae0_state(x.b)->round == 0);
    CHECK(strcmp(session_ae0_failure(x.b), "none") == 0);
    scene_resource_close(x.scene);
    session_ae0_destroy(x.b);
}

static void t_binding_host_error_maps_to_error(void)
{
    Bind x;
    uint32_t ph = 0u, np = 0u;
    int done = 0;
    E0PointerResult p;
    if (!bind_open(&x, 0)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_ae0_begin_scene(x.b, x.scene) == E0_OK);
    x.f.fail_alloc = 1;
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_ERROR);
    x.f.fail_alloc = 0;
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    x.f.fail_play = 1;
    CHECK(session_ae0_pointer_move(x.b, 5, 5, &p) == E0_OK && p.hit == 1u);
    CHECK(session_ae0_click(x.b, 1u, E0_CANDIDATE_KEY, 1, &np) == E0_ERR_HOST);
    CHECK(strcmp(session_ae0_failure(x.b), "keypad-click") == 0);
    CHECK(session_ae0_state(x.b)->lit[0] == 1u);
    /* the bounds error of a key click without a hover is also reported through the click */
    x.f.fail_play = 0;
    CHECK(session_ae0_pointer_move(x.b, 2000, 2000, &p) == E0_OK && p.hit == 0u);
    CHECK(session_ae0_click(x.b, 1u, E0_CANDIDATE_KEY, 1, &np) == E0_ERR_BOUNDS && strcmp(session_ae0_failure(x.b), "keypad-click") == 0);
    CHECK(session_ae0_click(x.b, 1u, E0_CANDIDATE_EXIT, 1, &np) == E0_OK && strcmp(session_ae0_failure(x.b), "none") == 0);
    /* a host failure in a later phase maps to ERROR, too */
    CHECK(b_visit(&x, 1, 2u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    x.f.fail_transition = 1;
    CHECK(b_visit(&x, 1, 2u, &ph, &done) == SCENE_ACTION_HANDLER_ERROR);
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
    run("validate_common", t_validate_common);
    run("validate_counts", t_validate_counts);
    run("validate_records_and_sets", t_validate_records_and_sets);
    run("object_reset", t_object_reset);
    run("object_pack", t_object_pack);
    run("phase0_d6", t_phase0_d6);
    run("phase0_rounds", t_phase0_rounds);
    run("phase0_surface_and_sound", t_phase0_surface_and_sound);
    run("phase0_e0_layout", t_phase0_e0_layout);
    run("phase0_failures", t_phase0_failures);
    run("incomplete_host", t_incomplete_host);
    run("state0_solved_advance", t_state0_solved_advance);
    run("state0_typed_code", t_state0_typed_code);
    run("state0_ordered_wrap", t_state0_ordered_wrap);
    run("state0_waiting", t_state0_waiting);
    run("state0_exit_pending", t_state0_exit_pending);
    run("state0_code_sets", t_state0_code_sets);
    run("state1", t_state1);
    run("state3_timer_and_blink", t_state3_timer_and_blink);
    run("state3_finish", t_state3_finish);
    run("state4", t_state4);
    run("inert_states", t_inert_states);
    run("phase2_exit_branch", t_phase2_exit_branch);
    run("phase2_sets_branch", t_phase2_sets_branch);
    run("phase2_failed_branch", t_phase2_failed_branch);
    run("phase2_refusals_and_failures", t_phase2_refusals_and_failures);
    run("pointer_keys", t_pointer_keys);
    run("pointer_exit", t_pointer_exit);
    run("pointer_e0", t_pointer_e0);
    run("click_gating", t_click_gating);
    run("click_ordered", t_click_ordered);
    run("click_unordered", t_click_unordered);
    run("click_record_and_sound", t_click_record_and_sound);
    run("click_exit_button", t_click_exit_button);
    run("click_exit_rectangle", t_click_exit_rectangle);
    run("render_plan_d6", t_render_plan_d6);
    run("render_plan_limits", t_render_plan_limits);
    run("invalidate", t_invalidate);
    run("cleanup", t_cleanup);
    run("run_unordered_d6", t_run_unordered_d6);
    run("run_exit_d6", t_run_exit_d6);
    run("run_e0_scene", t_run_e0_scene);
    run("binding_flow", t_binding_flow);
    run("binding_world_and_scene_cell", t_binding_world_and_scene_cell);
    run("binding_scene_change_clears", t_binding_scene_change_clears);
    run("binding_refuses_bad_body", t_binding_refuses_bad_body);
    run("binding_host_error", t_binding_host_error_maps_to_error);
    printf("TOTAL %d FAILED %d\n", g_total, g_failures);
    return g_failures;
}
