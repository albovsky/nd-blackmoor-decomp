/* RT-50 unit tests of the raw 0xd0 Piano Puzzle kernel (src/action_family_d0_runtime.c) and its session binding
 * (src/session_bindings_ad0.c). Prints "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure count.
 * Fixtures are synthetic bodies (no original bytes). tests/test_action_family_d0_runtime.py builds and runs this with and
 * without ASan/UBSan and under source mutations. */
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_d0_runtime.h"
#include "scene_resource.h"
#include "session_bindings_ad0.h"

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

/* Failable host callbacks (the sweep fails the n-th call of any of them). */
enum {
    CB_ALLOC = 1, CB_REGISTER, CB_LOAD, CB_SETSURF, CB_RELSURF, CB_RELSLOT, CB_DIRTY, CB_ORIGIN, CB_CLEARITEM, CB_PREPARE,
    CB_STOP, CB_PLAY, CB_BUSY, CB_LOOKUP, CB_SHOW, CB_TRANSITION, CB_STOREFLAG, CB_LAST = CB_STOREFLAG
};

typedef struct Fx {
    D0Object o;
    D0World world;
    D0Host host;
    uint8_t body[D0_BODY_BYTES];
    char log[8192];
    uint32_t now;
    int32_t busy_value;
    int32_t vx, vy;
    int fail_call, calls, failed_cb, sweep_n;
    unsigned failed_mask;
    size_t long_len;      /* length of the text of text key "T3" */
    char text_buf[D0_TEXT_MAX + 64u];
    char shown[512];
    size_t shown_len;
    int shown_calls, n_prepare, n_stop, n_play, n_dirty, n_origin, n_alloc;
    int16_t dirty_slot;
    int16_t setsurf_slot;
    uint32_t setsurf_surface;
    const uint8_t *prepare_ptr, *stop_ptr;
    char prepare_name[40];
    int16_t played_channel;
    char registered_label[40];
    char loaded_name[40];
    uint32_t phase;
    int completed, initialized;
} Fx;

static void put16(uint8_t *b, size_t off, int v) { b[off] = (uint8_t)v; b[off + 1] = (uint8_t)(v >> 8); }
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

static const char *const effect_names[] = {"?", "active", "start", "clearitem", "slot", "slotreg", "load", "slotsurf",
                                           "phase", "state", "prep", "stop", "play", "busy", "tick", "x57b", "x599",
                                           "x595", "x39ff", "x59b", "x59f", "x5a3", "mode", "evflag", "complete",
                                           "relsurf", "relslot", "tlookup", "tshow", "blit", "solvedchk"};

static void observe(void *c, int e, int32_t a, int32_t b) { logf_((Fx *)c, "%s:%d:%d", effect_names[e], a, b); }

static int fail_hit(Fx *f, int id)
{
    if (++f->calls == f->fail_call) {
        f->failed_cb = id;
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
static int h_load(void *c, const char *name, uint32_t *surface)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_LOAD) || strcmp(name, "PIANO") != 0) return 1;
    snprintf(f->loaded_name, sizeof f->loaded_name, "%s", name);
    *surface = 77u;
    return 0;
}
static int h_setsurf(void *c, int16_t slot, uint32_t s)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_SETSURF)) return 1;
    f->setsurf_slot = slot;
    f->setsurf_surface = s;
    return 0;
}
static int h_relsurf(void *c, uint32_t s) { (void)s; return fail_hit((Fx *)c, CB_RELSURF); }
static int h_relslot(void *c, int16_t slot) { (void)slot; return fail_hit((Fx *)c, CB_RELSLOT); }
static int h_dirty(void *c, int16_t slot)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_DIRTY)) return 1;
    ++f->n_dirty;
    f->dirty_slot = slot;
    return 0;
}
static int h_origin(void *c, int32_t *x, int32_t *y)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_ORIGIN)) return 1;
    ++f->n_origin;
    *x = f->vx;
    *y = f->vy;
    return 0;
}
static int h_clearitem(void *c) { return fail_hit((Fx *)c, CB_CLEARITEM); }
static int h_prepare(void *c, const uint8_t *r)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_PREPARE)) return 1;
    ++f->n_prepare;
    f->prepare_ptr = r;
    snprintf(f->prepare_name, sizeof f->prepare_name, "%s", (const char *)r);
    return 0;
}
static int h_stop(void *c, const uint8_t *r)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_STOP)) return 1;
    ++f->n_stop;
    f->stop_ptr = r;
    return 0;
}
static int h_play(void *c, int16_t ch)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_PLAY)) return 1;
    ++f->n_play;
    f->played_channel = ch;
    return 0;
}
static int h_busy(void *c, int16_t ch, int32_t *r)
{
    Fx *f = (Fx *)c;
    (void)ch;
    if (fail_hit(f, CB_BUSY)) return 1;
    *r = f->busy_value;
    return 0;
}
static uint32_t h_tick(void *c) { return ((Fx *)c)->now; }
/* Text keys: T0 "Do", T1 "Re", T2 none, T3 a string of long_len characters. */
static int h_lookup(void *c, const char *key, const char **text)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_LOOKUP)) return 1;
    *text = NULL;
    if (strcmp(key, "T0") == 0) {
        *text = "Do";
    } else if (strcmp(key, "T1") == 0) {
        *text = "Re";
    } else if (strcmp(key, "T3") == 0) {
        memset(f->text_buf, 'x', f->long_len);
        f->text_buf[f->long_len] = '\0';
        *text = f->text_buf;
    } else if (strcmp(key, "TEMPTY") == 0) {
        *text = "";
    }
    return 0;
}
static int h_show(void *c, const char *text)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_SHOW)) return 1;
    ++f->shown_calls;
    f->shown_len = strlen(text);
    snprintf(f->shown, sizeof f->shown, "%.500s", text);
    return 0;
}
static int h_flag_invalid(void *c, int16_t i) { (void)c; return i < 0 || i >= 100; }
static int h_transition(void *c, const D0Transition *t)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_TRANSITION)) return 1;
    logf_(f, "tr:%d:%d:%d:%d:%d:%d:%d", t->scene, t->word[0], t->word[1], t->word[2], t->dword[0], t->dword[1],
          t->dword[2]);
    return 0;
}
static int h_store_flag(void *c, int16_t i, uint32_t v)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_STOREFLAG)) return 1;
    logf_(f, "sf:%d:%u", i, v);
    return 0;
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

static void set_str(uint8_t *b, size_t off, const char *s) { memcpy(b + off, s, strlen(s) + 1u); }

/* Body: surface "PIANO", N = 4 keys. Key i: hit rectangle x 20i+2..20i+7, y 2..7; key rectangle x 20i..20i+9, y 0..9
 * (view relative); pressed source (100+10i, 200+i, 109+10i, 209+i). Region A (0,0,50,20) kind 3, region B (0,0,70,20) kind 4,
 * so keys 0..2 get kind 3, key 3 kind 4. Solution length 3: keys 2, 0, 1. Key sounds KS0, KS1, KS2, "NO SOUND"; text keys
 * T0..T3 (T2 has no text); sound record C "NO SOUND", channel 5; solved block scene 40 (start word 1, event flag 7 := 3, delay
 * 2 s), win sound "WINSND" channel 9; exit block scene 50 (start word 0, flag 8 := 9), exit rectangle x 100..110, y 50..60. */
static void body_init(uint8_t *b)
{
    memset(b, 0, D0_BODY_BYTES);
    set_str(b, 0, "PIANO");
    put16(b, 0x21, 4);
    for (int i = 0; i < 4; ++i) {
        put_rect(b, 0x23 + 16u * (unsigned)i, 100 + 10 * i, 200 + i, 109 + 10 * i, 209 + i);
        put_rect(b, 0x113 + 16u * (unsigned)i, 20 * i, 0, 20 * i + 9, 9);
        put_rect(b, 0x203 + 16u * (unsigned)i, 20 * i + 2, 2, 20 * i + 7, 7);
    }
    put16(b, 0x2f3, 3);
    put_rect(b, 0x2f5, 0, 0, 50, 20);
    put16(b, 0x305, 4);
    put_rect(b, 0x307, 0, 0, 70, 20);
    put16(b, 0x317, 3);
    put16(b, 0x319, 2);
    put16(b, 0x31b, 0);
    put16(b, 0x31d, 1);
    set_str(b, 0x337 + 0x42u * 0u, "KS0");
    set_str(b, 0x337 + 0x42u * 0u + 0x21u, "T0");
    set_str(b, 0x337 + 0x42u * 1u, "KS1");
    set_str(b, 0x337 + 0x42u * 1u + 0x21u, "T1");
    set_str(b, 0x337 + 0x42u * 2u, "KS2");
    set_str(b, 0x337 + 0x42u * 2u + 0x21u, "T2");
    set_str(b, 0x337 + 0x42u * 3u, "NO SOUND");
    set_str(b, 0x337 + 0x42u * 3u + 0x21u, "T3");
    set_str(b, 0x715, "NO SOUND");
    put16(b, 0x736, 5);
    set_block(b, 0x746, 40, 1, 2, 3, 11, 22, 33, 1, 7, 3);
    put16(b, 0x75f, 2);
    set_str(b, 0x761, "WINSND");
    put16(b, 0x782, 9);
    set_block(b, 0x792, 50, 4, 5, 6, 44, 55, 66, 0, 8, 9);
    put_rect(b, 0x7ab, 100, 50, 110, 60);
}

static void fx_init(Fx *f)
{
    memset(f, 0, sizeof(*f));
    d0_object_reset(&f->o);
    f->host.context = f;
    f->host.alloc_slot = h_alloc;
    f->host.register_slot = h_register;
    f->host.load_surface = h_load;
    f->host.set_slot_surface = h_setsurf;
    f->host.release_surface = h_relsurf;
    f->host.release_slot = h_relslot;
    f->host.mark_dirty = h_dirty;
    f->host.view_origin = h_origin;
    f->host.clear_pending_item = h_clearitem;
    f->host.sound_prepare = h_prepare;
    f->host.sound_stop = h_stop;
    f->host.sound_play = h_play;
    f->host.sound_busy = h_busy;
    f->host.tick = h_tick;
    f->host.text_lookup = h_lookup;
    f->host.text_show = h_show;
    f->host.event_flag_invalid = h_flag_invalid;
    f->host.transition = h_transition;
    f->host.store_event_flag = h_store_flag;
    f->host.observe = observe;
    f->now = 1000u;
    f->vx = 10;
    f->vy = 20;
    f->long_len = 10u;
    body_init(f->body);
}

static int visit_row(Fx *f, int16_t row, uint32_t phase)
{
    D0Result r;
    const char *why = NULL;
    const int rc = d0_step(&f->o, f->body, D0_BODY_BYTES, row, phase, &f->world, &f->host, &r, &why);
    f->phase = r.phase_after;
    f->completed = r.completed;
    f->initialized = r.initialized;
    return rc;
}
static int visit(Fx *f, uint32_t phase) { return visit_row(f, 3, phase); }

/* Phase 0 on row 3, then forget the log. */
static void start(Fx *f)
{
    CHECK(visit(f, 0) == D0_OK && f->phase == 1u);
    f->log[0] = '\0';
}

static int pointer(Fx *f, int32_t x, int32_t y, D0PointerResult *out)
{
    return d0_pointer(&f->o, f->body, D0_BODY_BYTES, x, y, out);
}
static int click(Fx *f, int32_t candidate, int32_t start_flag, D0ClickResult *out)
{
    return d0_click(&f->o, f->body, D0_BODY_BYTES, 1u, candidate, start_flag, &f->host, out);
}
/* Hover key h, then a key click. */
static int press(Fx *f, int16_t h, int32_t start_flag, D0ClickResult *out)
{
    f->o.hover = h;
    return click(f, D0_CANDIDATE_KEY, start_flag, out);
}
static int render(Fx *f, D0RenderResult *out) { return d0_render(&f->o, f->body, D0_BODY_BYTES, &f->host, out); }

static void t_validate(void)
{
    uint8_t b[D0_BODY_BYTES + 1];
    const char *why = NULL;
    body_init(b);
    CHECK(d0_validate_body(b, D0_BODY_BYTES, &why) == D0_OK && why == NULL);
    CHECK(d0_validate_body(b, D0_BODY_BYTES, NULL) == D0_OK);
    CHECK(d0_validate_body(NULL, D0_BODY_BYTES, &why) == D0_ERR_BODY && strcmp(why, "0xd0-body-length") == 0);
    CHECK(d0_validate_body(b, D0_BODY_BYTES - 1u, &why) == D0_ERR_BODY && strcmp(why, "0xd0-body-length") == 0);
    CHECK(d0_validate_body(b, D0_BODY_BYTES + 1u, &why) == D0_ERR_BODY && strcmp(why, "0xd0-body-length") == 0);
    CHECK(d0_validate_body(b, 0u, NULL) == D0_ERR_BODY);
    /* name: NUL anywhere in its 0x21 bytes is fine, none is not */
    memset(b, 'A', D0_NAME_BYTES);
    CHECK(d0_validate_body(b, D0_BODY_BYTES, &why) == D0_ERR_BODY && strcmp(why, "0xd0-name-unterminated") == 0);
    put16(b, 0x21, 0); /* N = 0 puts a zero right after the name field: it is not part of the name */
    CHECK(d0_validate_body(b, D0_BODY_BYTES, &why) == D0_ERR_BODY && strcmp(why, "0xd0-name-unterminated") == 0);
    put16(b, 0x21, 4);
    b[D0_NAME_BYTES - 1u] = 0;
    CHECK(d0_validate_body(b, D0_BODY_BYTES, NULL) == D0_OK);
    body_init(b);
    b[0] = 0; /* an empty name means "no surface" and is valid */
    CHECK(d0_validate_body(b, D0_BODY_BYTES, NULL) == D0_OK);
    /* key count 0..15 */
    body_init(b);
    put16(b, 0x21, 16);
    CHECK(d0_validate_body(b, D0_BODY_BYTES, &why) == D0_ERR_BODY && strcmp(why, "0xd0-key-count") == 0);
    put16(b, 0x21, -1);
    CHECK(d0_validate_body(b, D0_BODY_BYTES, &why) == D0_ERR_BODY && strcmp(why, "0xd0-key-count") == 0);
    put16(b, 0x21, 15);
    CHECK(d0_validate_body(b, D0_BODY_BYTES, NULL) == D0_OK);
    put16(b, 0x21, 0);
    CHECK(d0_validate_body(b, D0_BODY_BYTES, NULL) == D0_OK);
    /* solution length 1..15 */
    body_init(b);
    put16(b, 0x317, 0);
    CHECK(d0_validate_body(b, D0_BODY_BYTES, &why) == D0_ERR_BODY && strcmp(why, "0xd0-solution-length") == 0);
    put16(b, 0x317, 16);
    CHECK(d0_validate_body(b, D0_BODY_BYTES, &why) == D0_ERR_BODY && strcmp(why, "0xd0-solution-length") == 0);
    put16(b, 0x317, -3);
    CHECK(d0_validate_body(b, D0_BODY_BYTES, &why) == D0_ERR_BODY && strcmp(why, "0xd0-solution-length") == 0);
    put16(b, 0x317, 1);
    CHECK(d0_validate_body(b, D0_BODY_BYTES, NULL) == D0_OK);
    put16(b, 0x317, 15);
    CHECK(d0_validate_body(b, D0_BODY_BYTES, NULL) == D0_OK);
    /* key records of keys 0..N-1 only */
    body_init(b);
    memset(b + 0x337 + 0x42u * 2u, 'S', 0x21u);
    CHECK(d0_validate_body(b, D0_BODY_BYTES, &why) == D0_ERR_BODY && strcmp(why, "0xd0-key-sound-unterminated") == 0);
    body_init(b);
    memset(b + 0x337 + 0x42u * 3u + 0x21u, 'T', 0x21u);
    CHECK(d0_validate_body(b, D0_BODY_BYTES, &why) == D0_ERR_BODY && strcmp(why, "0xd0-key-text-unterminated") == 0);
    put16(b, 0x21, 3); /* key 3 is not in use any more */
    CHECK(d0_validate_body(b, D0_BODY_BYTES, NULL) == D0_OK);
    /* the sound name of key 0 ends at its last byte (index 0x20) */
    body_init(b);
    memset(b + 0x337, 'S', 0x20u);
    b[0x337 + 0x20u] = 0;
    CHECK(d0_validate_body(b, D0_BODY_BYTES, NULL) == D0_OK);
    b[0x337 + 0x20u] = 'S';
    CHECK(d0_validate_body(b, D0_BODY_BYTES, NULL) == D0_ERR_BODY);
    /* and so does the text key (0x21 bytes from record offset 0x21) */
    body_init(b);
    memset(b + 0x337 + 0x21u, 'T', 0x20u);
    b[0x337 + 0x21u + 0x20u] = 0;
    CHECK(d0_validate_body(b, D0_BODY_BYTES, NULL) == D0_OK);
    b[0x337 + 0x21u + 0x20u] = 'T';
    CHECK(d0_validate_body(b, D0_BODY_BYTES, &why) == D0_ERR_BODY && strcmp(why, "0xd0-key-text-unterminated") == 0);
}

static void t_reset(void)
{
    D0Object o;
    memset(&o, 0xa5, sizeof o);
    d0_object_reset(&o);
    CHECK(o.slot == D0_NO_SLOT && o.row == -1 && o.surface == 0u && o.dirty == 0u && o.check == 0u && o.pressed == 0u);
    CHECK(o.hover == 0 && o.last == 0 && o.state == 0 && o.has_surface == 0 && o.active == 0 && o.exit_taken == 0u);
    CHECK(o.solved == 0u && o.deadline == 0u);
    for (int i = 0; i < D0_MAX_KEYS; ++i) CHECK(o.order[i] == 0);
}

static void t_phase0_surface(void)
{
    Fx f;
    fx_init(&f);
    f.world.start_flag_5bb1ca = 0;
    f.o.exit_taken = 1;
    f.o.solved = 1;
    f.o.pressed = 1;
    f.o.check = 1;
    f.o.dirty = 1;
    f.o.surface = 5u;
    for (int i = 0; i < D0_MAX_KEYS; ++i) f.o.order[i] = 9;
    f.o.order[7] = 0x7777;
    CHECK(visit(&f, 0) == D0_OK && f.phase == 1u && f.initialized == 1 && f.completed == 0);
    CHECK_LOG(&f, "active:1:0,start:1:0,clearitem:0:0,slot:24:0,slotreg:24:0,load:77:0,slotsurf:24:77,state:1:0,phase:1:0");
    CHECK(f.o.active == 1 && f.o.row == 3 && f.o.slot == 24 && f.o.surface == 77u && f.o.has_surface == 1);
    CHECK(f.o.state == D0_STATE_IDLE && f.o.pressed == 0u && f.o.check == 0u && f.o.dirty == 0u);
    CHECK(f.o.exit_taken == 0u && f.o.solved == 0u && f.world.start_flag_5bb1ca == 1);
    /* the first 15 bytes of the order array are cleared (words 0..6 and the low byte of word 7), the rest is kept */
    for (int i = 0; i < 7; ++i) CHECK(f.o.order[i] == 0);
    CHECK(f.o.order[7] == 0x7700);
    for (int i = 8; i < D0_MAX_KEYS; ++i) CHECK(f.o.order[i] == 9);
    CHECK(strcmp(f.registered_label, "PIANO PUZZLE OVERLAYS") == 0 && strcmp(f.loaded_name, "PIANO") == 0);
    CHECK(f.setsurf_slot == 24 && f.setsurf_surface == 77u);
    /* a second phase 0 allocates a fresh slot (the original does not release first) */
    f.log[0] = '\0';
    CHECK(visit(&f, 0) == D0_OK && f.o.slot == 25);
}

static void t_phase0_no_surface(void)
{
    Fx f;
    fx_init(&f);
    f.body[0] = 0;
    CHECK(visit_row(&f, 0, 0) == D0_OK && f.phase == 1u && f.initialized == 1 && f.o.row == 0);
    CHECK_LOG(&f, "active:1:0,start:1:0,clearitem:0:0,state:1:0,phase:1:0");
    CHECK(f.o.has_surface == 0 && f.o.slot == D0_NO_SLOT && f.o.surface == 0u && f.n_alloc == 0);
    CHECK(f.registered_label[0] == '\0' && f.loaded_name[0] == '\0');
}

static void t_step_refusals(void)
{
    Fx f;
    D0Result r;
    const char *why = NULL;
    D0Host broken;
    fx_init(&f);
    CHECK(d0_step(NULL, f.body, D0_BODY_BYTES, 3, 0u, &f.world, &f.host, &r, &why) == D0_ERR_ARGUMENT);
    CHECK(d0_step(&f.o, NULL, D0_BODY_BYTES, 3, 0u, &f.world, &f.host, &r, &why) == D0_ERR_ARGUMENT);
    CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 3, 0u, NULL, &f.host, &r, &why) == D0_ERR_ARGUMENT);
    CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 3, 0u, &f.world, NULL, &r, &why) == D0_ERR_ARGUMENT);
    CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 3, 0u, &f.world, &f.host, NULL, &why) == D0_ERR_ARGUMENT);
    CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 3, 0u, &f.world, &f.host, &r, NULL) == D0_OK);
    CHECK(f.log[0] != '\0');
    fx_init(&f);
    /* every callback but the observer is required */
    {
        void **slots[20];
        size_t n = 0;
        broken = f.host;
        slots[n++] = (void **)&broken.alloc_slot;
        slots[n++] = (void **)&broken.register_slot;
        slots[n++] = (void **)&broken.load_surface;
        slots[n++] = (void **)&broken.set_slot_surface;
        slots[n++] = (void **)&broken.release_surface;
        slots[n++] = (void **)&broken.release_slot;
        slots[n++] = (void **)&broken.mark_dirty;
        slots[n++] = (void **)&broken.view_origin;
        slots[n++] = (void **)&broken.clear_pending_item;
        slots[n++] = (void **)&broken.sound_prepare;
        slots[n++] = (void **)&broken.sound_stop;
        slots[n++] = (void **)&broken.sound_play;
        slots[n++] = (void **)&broken.sound_busy;
        slots[n++] = (void **)&broken.tick;
        slots[n++] = (void **)&broken.text_lookup;
        slots[n++] = (void **)&broken.text_show;
        slots[n++] = (void **)&broken.event_flag_invalid;
        slots[n++] = (void **)&broken.transition;
        slots[n++] = (void **)&broken.store_event_flag;
        CHECK(n == 19u);
        for (size_t i = 0; i < n; ++i) {
            D0ClickResult c;
            D0RenderResult rr;
            void *saved = *slots[i];
            *slots[i] = NULL;
            CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 3, 0u, &f.world, &broken, &r, &why) == D0_ERR_ARGUMENT);
            CHECK(d0_click(&f.o, f.body, D0_BODY_BYTES, 1u, D0_CANDIDATE_EXIT, 1, &broken, &c) == D0_ERR_ARGUMENT);
            CHECK(d0_render(&f.o, f.body, D0_BODY_BYTES, &broken, &rr) == D0_ERR_ARGUMENT);
            *slots[i] = saved;
        }
        CHECK(f.log[0] == '\0');
        broken.observe = NULL; /* the observer is optional */
        CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 3, 0u, &f.world, &broken, &r, &why) == D0_OK);
    }
    /* a negative row is not a row */
    fx_init(&f);
    CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, -1, 0u, &f.world, &f.host, &r, &why) == D0_ERR_ARGUMENT);
    CHECK(strcmp(why, "0xd0-row") == 0 && f.log[0] == '\0');
    /* an invalid body is refused before the first effect, with its reason */
    put16(f.body, 0x317, 0);
    CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 3, 0u, &f.world, &f.host, &r, &why) == D0_ERR_BODY);
    CHECK(strcmp(why, "0xd0-solution-length") == 0 && f.log[0] == '\0' && f.o.active == 0);
    CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES - 1u, 3, 1u, &f.world, &f.host, &r, &why) == D0_ERR_BODY);
    CHECK(strcmp(why, "0xd0-body-length") == 0);
    /* the result is cleared and carries the phase */
    fx_init(&f);
    memset(&r, 0xff, sizeof r);
    CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 3, 7u, &f.world, &f.host, &r, &why) == D0_OK);
    CHECK(r.phase_after == 7u && r.initialized == 0u && r.completed == 0u && f.log[0] == '\0');
}

static void t_phase12_need_phase0(void)
{
    Fx f;
    D0Result r;
    const char *why = NULL;
    fx_init(&f);
    CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 3, 1u, &f.world, &f.host, &r, &why) == D0_ERR_UNSUPPORTED);
    CHECK(strcmp(why, "0xd0-phase-1-without-init") == 0 && f.log[0] == '\0' && r.phase_after == 1u);
    CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 3, 2u, &f.world, &f.host, &r, &why) == D0_ERR_UNSUPPORTED);
    CHECK(strcmp(why, "0xd0-phase-2-without-init") == 0 && f.log[0] == '\0' && r.completed == 0u);
    /* initialised for another row */
    start(&f);
    CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 4, 1u, &f.world, &f.host, &r, &why) == D0_ERR_UNSUPPORTED);
    CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 4, 2u, &f.world, &f.host, &r, &why) == D0_ERR_UNSUPPORTED);
    CHECK(f.log[0] == '\0' && f.o.active == 1);
    /* after the finish the object is idle again */
    CHECK(visit(&f, 2) == D0_OK && f.completed == 1);
    CHECK(visit(&f, 1) == D0_ERR_UNSUPPORTED);
    /* an inactive object, even with the row of the visit */
    start(&f);
    f.o.active = 0;
    CHECK(visit(&f, 1) == D0_ERR_UNSUPPORTED);
    CHECK(visit(&f, 2) == D0_ERR_UNSUPPORTED && f.completed == 0 && f.log[0] == '\0');
    /* other phases do nothing even on a running puzzle whose phase 1 would act */
    start(&f);
    f.o.state = D0_STATE_RELEASE;
    f.o.deadline = 0u;
    f.o.exit_taken = 1;
    CHECK(visit(&f, 3) == D0_OK && f.phase == 3u && f.log[0] == '\0' && f.n_stop == 0 && f.o.state == D0_STATE_RELEASE);
    CHECK(f.o.active == 1);
    /* any other phase falls out of the switch, initialised or not */
    fx_init(&f);
    for (uint32_t p = 3u; p < 6u; ++p) {
        CHECK(visit(&f, p) == D0_OK && f.phase == p && f.log[0] == '\0' && f.completed == 0);
    }
    CHECK(visit(&f, 0xffffffffu) == D0_OK && f.phase == 0xffffffffu);
}

static void t_state_release(void)
{
    Fx f;
    fx_init(&f);
    start(&f);
    f.o.state = D0_STATE_RELEASE;
    f.o.deadline = 1000u;
    f.o.pressed = 1;
    set_str(f.body, 0x715, "KS1");
    f.now = 999u;
    CHECK(visit(&f, 1) == D0_OK && f.phase == 1u && f.completed == 0);
    CHECK_LOG(&f, "tick:999:0");
    CHECK(f.o.state == D0_STATE_RELEASE && f.o.pressed == 1u && f.o.dirty == 0u && f.o.check == 0u && f.n_stop == 0);
    f.log[0] = '\0';
    f.now = 1000u;
    CHECK(visit(&f, 1) == D0_OK && f.phase == 1u);
    CHECK_LOG(&f, "tick:1000:0,stop:1813:0,state:1:0");
    CHECK(f.o.state == D0_STATE_IDLE && f.o.pressed == 0u && f.o.dirty == 1u && f.o.check == 1u && f.n_stop == 1);
    CHECK(f.stop_ptr == f.body + 0x715);
    /* later visits do nothing in IDLE with a surface */
    f.log[0] = '\0';
    f.now = 5000u;
    CHECK(visit(&f, 1) == D0_OK && f.log[0] == '\0' && f.n_stop == 1);
}

static void set_order(Fx *f, int a, int b, int c)
{
    f->o.order[0] = (int16_t)a;
    f->o.order[1] = (int16_t)b;
    f->o.order[2] = (int16_t)c;
}

static void t_state_idle_solved_check(void)
{
    Fx f;
    fx_init(&f);
    start(&f);
    set_order(&f, 2, 0, 1);
    CHECK(visit(&f, 1) == D0_OK && f.log[0] == '\0' && f.o.solved == 0u); /* the surface owns the check (render) */
    /* without a surface name the handler runs the check itself */
    fx_init(&f);
    f.body[0] = 0;
    start(&f);
    set_order(&f, 2, 0, 9);
    CHECK(visit(&f, 1) == D0_OK && f.phase == 1u);
    CHECK_LOG(&f, "solvedchk:0:0");
    CHECK(f.o.state == D0_STATE_IDLE && f.o.solved == 0u);
    f.log[0] = '\0';
    set_order(&f, 9, 0, 1);
    CHECK(visit(&f, 1) == D0_OK && f.o.solved == 0u);
    set_order(&f, 2, 9, 1);
    CHECK(visit(&f, 1) == D0_OK && f.o.solved == 0u);
    set_order(&f, 2, 0, 1);
    f.o.order[3] = 14; /* only the last L keys count */
    f.log[0] = '\0';
    CHECK(visit(&f, 1) == D0_OK && f.o.solved == 1u && f.o.state == D0_STATE_START_WIN);
    CHECK_LOG(&f, "solvedchk:0:0,state:2:0");
    /* solution length 1 and 15 */
    fx_init(&f);
    f.body[0] = 0;
    put16(f.body, 0x317, 1);
    put16(f.body, 0x319, 5);
    start(&f);
    f.o.order[0] = 4;
    CHECK(visit(&f, 1) == D0_OK && f.o.solved == 0u);
    f.o.order[0] = 5;
    CHECK(visit(&f, 1) == D0_OK && f.o.solved == 1u);
    fx_init(&f);
    f.body[0] = 0;
    put16(f.body, 0x317, 15);
    for (int i = 0; i < 15; ++i) put16(f.body, 0x319 + 2u * (unsigned)i, 100 + i);
    start(&f);
    for (int i = 0; i < 15; ++i) f.o.order[i] = (int16_t)(100 + i);
    f.o.order[14] = 0;
    CHECK(visit(&f, 1) == D0_OK && f.o.solved == 0u);
    f.o.order[14] = 114;
    CHECK(visit(&f, 1) == D0_OK && f.o.solved == 1u);
    /* solution words compare signed */
    fx_init(&f);
    f.body[0] = 0;
    put16(f.body, 0x317, 1);
    put16(f.body, 0x319, -2);
    start(&f);
    f.o.order[0] = -2;
    CHECK(visit(&f, 1) == D0_OK && f.o.solved == 1u);
}

static void t_state_start_win(void)
{
    Fx f;
    fx_init(&f);
    start(&f);
    f.o.state = D0_STATE_START_WIN;
    f.now = 5000u;
    CHECK(visit(&f, 1) == D0_OK && f.phase == 1u);
    CHECK_LOG(&f, "tick:5000:0,state:3:0");
    CHECK(f.o.state == D0_STATE_WAIT_WIN && f.o.deadline == 7000u);
    /* delay 0 and a negative delay (signed word) */
    put16(f.body, 0x75f, 0);
    f.o.state = D0_STATE_START_WIN;
    CHECK(visit(&f, 1) == D0_OK && f.o.deadline == 5000u);
    put16(f.body, 0x75f, -1);
    f.o.state = D0_STATE_START_WIN;
    CHECK(visit(&f, 1) == D0_OK && f.o.deadline == 4000u);
    put16(f.body, 0x75f, 32767);
    f.o.state = D0_STATE_START_WIN;
    CHECK(visit(&f, 1) == D0_OK && f.o.deadline == 5000u + 32767000u);
}

static void t_state_wait_win(void)
{
    Fx f;
    fx_init(&f);
    start(&f);
    f.o.state = D0_STATE_WAIT_WIN;
    f.o.deadline = 7000u;
    f.now = 6999u;
    CHECK(visit(&f, 1) == D0_OK && f.phase == 1u);
    CHECK_LOG(&f, "tick:6999:0");
    CHECK(f.o.state == D0_STATE_WAIT_WIN && f.n_prepare == 0);
    f.log[0] = '\0';
    f.now = 7000u;
    CHECK(visit(&f, 1) == D0_OK && f.phase == 1u && f.completed == 0);
    CHECK_LOG(&f, "tick:7000:0,prep:1889:0,play:9:0,state:4:0");
    CHECK(f.o.state == D0_STATE_WIN_SOUND && f.n_prepare == 1 && f.n_play == 1 && f.played_channel == 9);
    CHECK(f.prepare_ptr == f.body + 0x761 && strcmp(f.prepare_name, "WINSND") == 0);
    /* no win sound: straight to the finish phase */
    fx_init(&f);
    start(&f);
    set_str(f.body, 0x761, "NO SOUND");
    f.o.state = D0_STATE_WAIT_WIN;
    f.o.deadline = 7000u;
    f.now = 8000u;
    CHECK(visit(&f, 1) == D0_OK && f.phase == 2u && f.completed == 0);
    CHECK_LOG(&f, "tick:8000:0,phase:2:0");
    CHECK(f.o.state == D0_STATE_WAIT_WIN && f.n_prepare == 0 && f.n_play == 0);
    /* the "NO SOUND" test compares the 9 bytes including the NUL */
    fx_init(&f);
    start(&f);
    memcpy(f.body + 0x761, "NO SOUND!", 10);
    f.o.state = D0_STATE_WAIT_WIN;
    f.now = 8000u;
    CHECK(visit(&f, 1) == D0_OK && f.phase == 1u && f.n_prepare == 1);
    /* a negative win channel word passes through signed */
    fx_init(&f);
    start(&f);
    put16(f.body, 0x782, -2);
    f.o.state = D0_STATE_WAIT_WIN;
    f.now = 8000u;
    CHECK(visit(&f, 1) == D0_OK && f.played_channel == -2);
}

static void t_state_win_sound(void)
{
    Fx f;
    fx_init(&f);
    start(&f);
    f.o.state = D0_STATE_WIN_SOUND;
    f.busy_value = 1;
    CHECK(visit(&f, 1) == D0_OK && f.phase == 1u);
    CHECK_LOG(&f, "busy:9:1");
    CHECK(f.n_stop == 0 && f.o.state == D0_STATE_WIN_SOUND);
    f.busy_value = 0;
    f.log[0] = '\0';
    CHECK(visit(&f, 1) == D0_OK && f.phase == 2u && f.completed == 0);
    CHECK_LOG(&f, "busy:9:0,stop:1889:0,phase:2:0");
    CHECK(f.n_stop == 1 && f.stop_ptr == f.body + 0x761);
    /* any other state value does nothing */
    f.o.state = 5;
    f.log[0] = '\0';
    CHECK(visit(&f, 1) == D0_OK && f.phase == 1u && f.log[0] == '\0');
    f.o.state = -1;
    CHECK(visit(&f, 1) == D0_OK && f.phase == 1u && f.log[0] == '\0');
}

static void t_phase2_blocks(void)
{
    Fx f;
    /* exit block: start word 0 stores 1, the scene change, the event flag, the generic completion, the cleanup */
    fx_init(&f);
    start(&f);
    f.o.exit_taken = 1;
    f.world.start_flag_5bb1ca = 0;
    CHECK(visit(&f, 2) == D0_OK && f.phase == 0u && f.completed == 1 && f.initialized == 0);
    CHECK_LOG(&f, "start:1:0,tr:50:4:5:6:44:55:66,x57b:50:0,x599:4:0,x595:5:0,x39ff:6:0,x59b:44:0,x59f:55:0,x5a3:66:0,"
                  "start:1:0,mode:4:0,sf:8:9,evflag:8:9,complete:3:0,relsurf:77:0,relslot:24:0");
    CHECK(f.world.start_flag_5bb1ca == 1);
    CHECK(f.o.active == 0 && f.o.slot == D0_NO_SLOT && f.o.row == -1 && f.o.surface == 0u && f.o.exit_taken == 0u);
    /* solved block: start word 1 stores 0 */
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    CHECK(visit(&f, 2) == D0_OK && f.phase == 0u && f.completed == 1);
    CHECK_LOG(&f, "start:1:0,tr:40:1:2:3:11:22:33,x57b:40:0,x599:1:0,x595:2:0,x39ff:3:0,x59b:11:0,x59f:22:0,x5a3:33:0,"
                  "start:0:0,mode:4:0,sf:7:3,evflag:7:3,complete:3:0,relsurf:77:0,relslot:24:0");
    CHECK(f.world.start_flag_5bb1ca == 0 && f.o.solved == 0u);
    /* both: the exit wins */
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    f.o.exit_taken = 1;
    CHECK(visit(&f, 2) == D0_OK && strstr(f.log, "tr:50:") != NULL && strstr(f.log, "tr:40:") == NULL);
    /* start words: only 1 stores 0 */
    for (int sw = -1; sw <= 2; ++sw) {
        fx_init(&f);
        start(&f);
        f.o.solved = 1;
        put16(f.body, 0x75a, sw);
        CHECK(visit(&f, 2) == D0_OK && f.world.start_flag_5bb1ca == (sw == 1 ? 0 : 1));
    }
    /* neither: only the start flag, the completion and the cleanup */
    fx_init(&f);
    start(&f);
    CHECK(visit(&f, 2) == D0_OK && f.phase == 0u && f.completed == 1);
    CHECK_LOG(&f, "start:1:0,complete:3:0,relsurf:77:0,relslot:24:0");
    /* no scene (9999) and no flag (-1): nothing but the start flag */
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    put16(f.body, 0x746, 9999);
    put16(f.body, 0x75c, -1);
    f.world.start_flag_5bb1ca = 7;
    CHECK(visit(&f, 2) == D0_OK);
    CHECK_LOG(&f, "start:1:0,complete:3:0,relsurf:77:0,relslot:24:0");
    CHECK(f.world.start_flag_5bb1ca == 1);
    /* a flag without a scene change, value 255 stored unsigned */
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    put16(f.body, 0x746, 9999);
    f.body[0x75e] = 255;
    CHECK(visit(&f, 2) == D0_OK);
    CHECK_LOG(&f, "start:1:0,sf:7:255,evflag:7:255,complete:3:0,relsurf:77:0,relslot:24:0");
    /* the first event flag index (0) is a flag, not "none" */
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    put16(f.body, 0x75c, 0);
    CHECK(visit(&f, 2) == D0_OK && strstr(f.log, "sf:0:3,evflag:0:3") != NULL);
    /* a scene change without a flag */
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    put16(f.body, 0x75c, -1);
    CHECK(visit(&f, 2) == D0_OK && strstr(f.log, "tr:40:") != NULL && strstr(f.log, "sf:") == NULL);
    /* no surface: nothing to release */
    fx_init(&f);
    f.body[0] = 0;
    start(&f);
    CHECK(visit(&f, 2) == D0_OK);
    CHECK_LOG(&f, "start:1:0,complete:3:0");
    /* scene word is signed: -2 is a scene change, not "none" */
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    put16(f.body, 0x746, -2);
    CHECK(visit(&f, 2) == D0_OK && strstr(f.log, "tr:-2:") != NULL);
}

static void t_phase2_flag_refused(void)
{
    static const int bad[] = {100, 200, -2, -32768, 32767};
    for (size_t i = 0; i < sizeof bad / sizeof bad[0]; ++i) {
        Fx f;
        fx_init(&f);
        start(&f);
        f.o.exit_taken = 1;
        put16(f.body, 0x7a8, bad[i]);
        {
            D0Result r;
            const char *why = NULL;
            CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 3, 2u, &f.world, &f.host, &r, &why) == D0_ERR_BOUNDS);
            CHECK(strcmp(why, "0xd0-event-flag-index") == 0 && f.log[0] == '\0' && r.completed == 0u);
            CHECK(f.o.active == 1 && f.o.slot == 24 && f.o.exit_taken == 1u);
        }
    }
    /* with both blocks taken the exit block (the one phase 2 applies) is the one checked */
    {
        Fx f;
        D0Result r;
        const char *why = NULL;
        fx_init(&f);
        start(&f);
        f.o.solved = 1;
        f.o.exit_taken = 1;
        put16(f.body, 0x7a8, 150);
        CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 3, 2u, &f.world, &f.host, &r, &why) == D0_ERR_BOUNDS && f.log[0] == '\0');
        put16(f.body, 0x7a8, 8);
        put16(f.body, 0x75c, 150);
        CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 3, 2u, &f.world, &f.host, &r, &why) == D0_OK && strstr(f.log, "sf:8:9") != NULL);
    }
    /* the solved block's flag is checked when it is the one taken, and a 99 is the last valid one */
    {
        Fx f;
        D0Result r;
        const char *why = NULL;
        fx_init(&f);
        start(&f);
        f.o.solved = 1;
        put16(f.body, 0x75c, 150);
        CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 3, 2u, &f.world, &f.host, &r, &why) == D0_ERR_BOUNDS);
        put16(f.body, 0x75c, 99);
        CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 3, 2u, &f.world, &f.host, &r, &why) == D0_OK);
        /* the block that is not taken is not looked at */
        fx_init(&f);
        start(&f);
        f.o.solved = 1;
        put16(f.body, 0x7a8, 150);
        CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 3, 2u, &f.world, &f.host, &r, &why) == D0_OK);
        fx_init(&f);
        start(&f);
        f.o.exit_taken = 1;
        put16(f.body, 0x75c, 150);
        CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 3, 2u, &f.world, &f.host, &r, &why) == D0_OK);
        /* neither block taken: nothing to refuse */
        fx_init(&f);
        start(&f);
        put16(f.body, 0x75c, 150);
        put16(f.body, 0x7a8, 150);
        CHECK(d0_step(&f.o, f.body, D0_BODY_BYTES, 3, 2u, &f.world, &f.host, &r, &why) == D0_OK);
    }
}

static void t_pointer_inactive_and_args(void)
{
    Fx f;
    D0PointerResult p;
    fx_init(&f);
    memset(&p, 0x55, sizeof p);
    CHECK(pointer(&f, 5, 5, &p) == D0_OK && p.hit == 0u && p.candidate == -1 && p.cursor_written == 0u);
    CHECK(p.cursor_kind == 0 && p.cursor_sub == 0 && f.o.dirty == 0u && f.o.hover == 0);
    CHECK(d0_pointer(NULL, f.body, D0_BODY_BYTES, 5, 5, &p) == D0_ERR_ARGUMENT);
    CHECK(d0_pointer(&f.o, NULL, D0_BODY_BYTES, 5, 5, &p) == D0_ERR_ARGUMENT);
    CHECK(d0_pointer(&f.o, f.body, D0_BODY_BYTES, 5, 5, NULL) == D0_ERR_ARGUMENT);
    CHECK(d0_pointer(&f.o, f.body, D0_BODY_BYTES - 1u, 5, 5, &p) == D0_ERR_ARGUMENT);
    start(&f);
    put16(f.body, 0x21, 16);
    CHECK(d0_pointer(&f.o, f.body, D0_BODY_BYTES, 5, 5, &p) == D0_ERR_ARGUMENT);
}

static void t_pointer_keys(void)
{
    Fx f;
    D0PointerResult p;
    fx_init(&f);
    start(&f);
    /* inclusive hit rectangle of key 0: x 2..7, y 2..7 */
    static const int inside[][2] = {{2, 2}, {7, 7}, {2, 7}, {7, 2}, {4, 5}};
    static const int outside[][2] = {{1, 2}, {8, 2}, {2, 1}, {2, 8}, {7, 8}, {8, 7}, {0, 0}, {-3, -3}};
    for (size_t i = 0; i < sizeof inside / sizeof inside[0]; ++i) {
        f.o.hover = -1;
        f.o.dirty = 0;
        CHECK(pointer(&f, inside[i][0], inside[i][1], &p) == D0_OK);
        CHECK(p.hit == 1u && p.candidate == D0_CANDIDATE_KEY && p.cursor_written == 1u && p.cursor_kind == 3 &&
              p.cursor_sub == 1);
        CHECK(f.o.hover == 0 && f.o.dirty == 1u);
    }
    for (size_t i = 0; i < sizeof outside / sizeof outside[0]; ++i) {
        f.o.hover = -1;
        f.o.dirty = 0;
        CHECK(pointer(&f, outside[i][0], outside[i][1], &p) == D0_OK);
        CHECK(p.hit == 0u && p.candidate == -1 && p.cursor_written == 0u && p.cursor_kind == 0 && p.cursor_sub == 0);
        CHECK(f.o.hover == -1 && f.o.dirty == 0u);
    }
    /* each key by its own rectangle; cursor kinds from the regions: A for keys 0..2, B for key 3 */
    for (int k = 0; k < 4; ++k) {
        CHECK(pointer(&f, 20 * k + 3, 3, &p) == D0_OK && p.hit == 1u && f.o.hover == k);
        CHECK(p.cursor_kind == (k < 3 ? 3 : 4));
    }
    /* neither region: kind 0 */
    put_rect(f.body, 0x203 + 16u * 3u, 62, 2, 67, 30);
    CHECK(pointer(&f, 63, 3, &p) == D0_OK && p.hit == 1u && p.cursor_kind == 0 && f.o.hover == 3);
    /* regions are inclusive: a hit rectangle equal to region A is inside it */
    put_rect(f.body, 0x2f5, 2, 2, 7, 7);
    CHECK(pointer(&f, 3, 3, &p) == D0_OK && p.cursor_kind == 3);
    put_rect(f.body, 0x2f5, 0, 0, 50, 20);
    /* region A is tested on all four sides (a hit rectangle poking out of A falls through to B or 0) */
    put_rect(f.body, 0x203, 2, 2, 51, 7);   /* right 51 > 50 */
    CHECK(pointer(&f, 3, 3, &p) == D0_OK && p.cursor_kind == 4);
    put_rect(f.body, 0x203, 2, 2, 7, 21);   /* bottom 21 > 20 */
    CHECK(pointer(&f, 3, 3, &p) == D0_OK && p.cursor_kind == 0);
    put_rect(f.body, 0x203, -1, 2, 7, 7);   /* left -1 < 0 */
    CHECK(pointer(&f, 3, 3, &p) == D0_OK && p.cursor_kind == 0);
    put_rect(f.body, 0x203, 2, -1, 7, 7);   /* top -1 < 0 */
    CHECK(pointer(&f, 3, 3, &p) == D0_OK && p.cursor_kind == 0);
    put_rect(f.body, 0x203, 2, 2, 7, 7);
    /* region B on its four sides (A is made to miss) */
    put_rect(f.body, 0x2f5, 100, 100, 200, 200);
    put_rect(f.body, 0x307, 3, 3, 6, 6);
    CHECK(pointer(&f, 3, 3, &p) == D0_OK && p.cursor_kind == 0); /* hit rect 2..7 pokes out of B on every side */
    put_rect(f.body, 0x307, 2, 2, 7, 7);
    CHECK(pointer(&f, 3, 3, &p) == D0_OK && p.cursor_kind == 4);
    put_rect(f.body, 0x307, 3, 2, 7, 7);
    CHECK(pointer(&f, 3, 3, &p) == D0_OK && p.cursor_kind == 0);
    put_rect(f.body, 0x307, 2, 3, 7, 7);
    CHECK(pointer(&f, 3, 3, &p) == D0_OK && p.cursor_kind == 0);
    put_rect(f.body, 0x307, 2, 2, 6, 7);
    CHECK(pointer(&f, 3, 3, &p) == D0_OK && p.cursor_kind == 0);
    put_rect(f.body, 0x307, 2, 2, 7, 6);
    CHECK(pointer(&f, 3, 3, &p) == D0_OK && p.cursor_kind == 0);
    /* the cursor kinds are signed words */
    body_init(f.body);
    put16(f.body, 0x2f3, -5);
    CHECK(pointer(&f, 3, 3, &p) == D0_OK && p.cursor_kind == -5);
}

static void t_pointer_overlap_and_coordinates(void)
{
    Fx f;
    D0PointerResult p;
    fx_init(&f);
    start(&f);
    /* the first key whose rectangle holds the point wins */
    put_rect(f.body, 0x203 + 16u, 2, 2, 7, 7);
    f.o.hover = -1;
    CHECK(pointer(&f, 4, 4, &p) == D0_OK && p.hit == 1u && f.o.hover == 0);
    /* the exit rectangle is tested before the keys while no key is pressed */
    put_rect(f.body, 0x7ab, 2, 2, 7, 7);
    CHECK(pointer(&f, 4, 4, &p) == D0_OK && p.hit == 1u && p.candidate == D0_CANDIDATE_EXIT);
    f.o.pressed = 1;
    f.o.hover = 2;
    CHECK(pointer(&f, 4, 4, &p) == D0_OK && p.hit == 1u && p.candidate == D0_CANDIDATE_KEY);
    CHECK(f.o.hover == 2); /* a pressed key keeps the hover */
    /* the hot spot is truncated to a signed word, as the original's movsx */
    body_init(f.body);
    f.o.pressed = 0;
    CHECK(pointer(&f, 65536 + 3, 3, &p) == D0_OK && p.hit == 1u && f.o.hover == 0);
    CHECK(pointer(&f, 3, -65536 + 3, &p) == D0_OK && p.hit == 1u);
    CHECK(pointer(&f, 32768 + 3, 3, &p) == D0_OK && p.hit == 0u); /* -32765 */
    /* rectangles hold signed dwords */
    put_rect(f.body, 0x203, -5, -5, 5, 5);
    CHECK(pointer(&f, -3, -3, &p) == D0_OK && p.hit == 1u && f.o.hover == 0);
    CHECK(pointer(&f, -6, -3, &p) == D0_OK && p.hit == 0u);
    /* no keys: only the exit */
    put16(f.body, 0x21, 0);
    CHECK(pointer(&f, 3, 3, &p) == D0_OK && p.hit == 0u);
    CHECK(pointer(&f, 105, 55, &p) == D0_OK && p.hit == 1u && p.candidate == D0_CANDIDATE_EXIT);
}

static void t_pointer_exit(void)
{
    Fx f;
    D0PointerResult p;
    fx_init(&f);
    start(&f);
    static const int inside[][2] = {{100, 50}, {110, 60}, {100, 60}, {110, 50}, {105, 55}};
    static const int outside[][2] = {{99, 50}, {111, 50}, {100, 49}, {100, 61}, {111, 61}};
    for (size_t i = 0; i < sizeof inside / sizeof inside[0]; ++i) {
        f.o.hover = 2;
        f.o.dirty = 0;
        CHECK(pointer(&f, inside[i][0], inside[i][1], &p) == D0_OK);
        CHECK(p.hit == 1u && p.candidate == D0_CANDIDATE_EXIT && p.cursor_written == 1u && p.cursor_kind == D0_CURSOR_EXIT &&
              p.cursor_sub == 1);
        CHECK(f.o.hover == -1 && f.o.dirty == 1u);
    }
    for (size_t i = 0; i < sizeof outside / sizeof outside[0]; ++i) {
        f.o.hover = 2;
        CHECK(pointer(&f, outside[i][0], outside[i][1], &p) == D0_OK && p.hit == 0u && p.candidate == -1 && f.o.hover == 2);
    }
    /* a key is pressed: the exit rectangle is ignored */
    f.o.pressed = 1;
    f.o.hover = 1;
    f.o.dirty = 0;
    CHECK(pointer(&f, 105, 55, &p) == D0_OK && p.hit == 0u && p.candidate == -1 && p.cursor_written == 0u);
    CHECK(f.o.dirty == 0u && f.o.hover == 1);
}

static void t_pointer_pressed(void)
{
    Fx f;
    D0PointerResult p;
    fx_init(&f);
    start(&f);
    f.o.pressed = 1;
    f.o.hover = 1;
    /* another key's hit rectangle still claims the pointer; the hover stays on the pressed key */
    CHECK(pointer(&f, 3, 3, &p) == D0_OK && p.hit == 1u && p.candidate == D0_CANDIDATE_KEY && p.cursor_written == 1u);
    CHECK(f.o.hover == 1 && f.o.dirty == 1u && p.cursor_kind == 3);
    /* the pressed key's rectangle outside its hit rectangle asks for a redraw only */
    f.o.dirty = 0;
    CHECK(pointer(&f, 20, 0, &p) == D0_OK && p.hit == 0u && p.candidate == -1 && p.cursor_written == 0u);
    CHECK(f.o.dirty == 1u && f.o.hover == 1);
    f.o.dirty = 0;
    CHECK(pointer(&f, 29, 9, &p) == D0_OK && p.hit == 0u && f.o.dirty == 1u);
    f.o.dirty = 0;
    CHECK(pointer(&f, 30, 9, &p) == D0_OK && p.hit == 0u && f.o.dirty == 0u);
    CHECK(pointer(&f, 29, 10, &p) == D0_OK && f.o.dirty == 0u);
    CHECK(pointer(&f, 19, 0, &p) == D0_OK && f.o.dirty == 0u);
    CHECK(pointer(&f, 20, -1, &p) == D0_OK && f.o.dirty == 0u);
    /* the margin of a key that is not the pressed one does nothing */
    CHECK(pointer(&f, 40, 0, &p) == D0_OK && p.hit == 0u && f.o.dirty == 0u);
    /* not pressed: the margin does nothing either */
    f.o.pressed = 0;
    CHECK(pointer(&f, 20, 0, &p) == D0_OK && p.hit == 0u && f.o.dirty == 0u);
    /* the redraw scan goes on past an overlapping key rectangle that is not the pressed key's */
    f.o.pressed = 1;
    f.o.hover = 1;
    put_rect(f.body, 0x113, 15, 0, 25, 9); /* key 0's rectangle now overlaps key 1's */
    CHECK(pointer(&f, 20, 0, &p) == D0_OK && f.o.dirty == 1u);
}

static void t_click_key(void)
{
    Fx f;
    D0ClickResult c;
    fx_init(&f);
    start(&f);
    f.now = 2000u;
    /* key 1 with the process flag set: busy check, prepare, play, tick, then the text */
    CHECK(press(&f, 1, 1, &c) == D0_OK);
    CHECK_LOG(&f, "busy:5:0,prep:1813:0,play:5:0,tick:2000:0,tlookup:1:1,tshow:5:0");
    CHECK(c.key_pressed == 1u && c.sound_played == 1u && c.text_shown == 1u && c.exit_asked == 0u && c.new_phase == 1u);
    CHECK(f.o.pressed == 1u && f.o.last == 1 && f.o.dirty == 1u && f.o.deadline == 2500u);
    CHECK(f.o.order[0] == 0 && f.o.order[1] == 0 && f.o.order[2] == 1);
    CHECK(strcmp((const char *)f.body + 0x715, "KS1") == 0 && f.prepare_ptr == f.body + 0x715);
    CHECK(strcmp(f.prepare_name, "KS1") == 0 && f.played_channel == 5);
    CHECK(strcmp(f.shown, "Re<e>") == 0 && f.shown_calls == 1);
    CHECK(f.o.state == D0_STATE_IDLE); /* the render callback moves it to RELEASE */
    /* a second key shifts the window */
    f.log[0] = '\0';
    CHECK(press(&f, 2, 1, &c) == D0_OK);
    CHECK(f.o.order[0] == 0 && f.o.order[1] == 1 && f.o.order[2] == 2 && f.o.last == 2);
    CHECK_LOG(&f, "busy:5:0,prep:1813:0,play:5:0,tick:2000:0,tlookup:2:0");
    CHECK(c.text_shown == 0u && f.shown_calls == 1);
    CHECK(press(&f, 0, 1, &c) == D0_OK);
    CHECK(f.o.order[0] == 1 && f.o.order[1] == 2 && f.o.order[2] == 0 && strcmp(f.shown, "Do<e>") == 0);
    /* the sound is busy: no prepare, no play, no deadline, no dirty */
    fx_init(&f);
    start(&f);
    f.busy_value = 1;
    f.o.deadline = 77u;
    CHECK(press(&f, 1, 1, &c) == D0_OK);
    CHECK_LOG(&f, "busy:5:1,tlookup:1:1,tshow:5:0");
    CHECK(c.sound_played == 0u && f.o.dirty == 0u && f.o.deadline == 77u && f.n_prepare == 0 && f.o.pressed == 1u);
    CHECK(strcmp((const char *)f.body + 0x715, "KS1") == 0); /* the record is written anyway */
    /* the process flag is clear: no sound call at all */
    fx_init(&f);
    start(&f);
    CHECK(press(&f, 1, 0, &c) == D0_OK);
    CHECK_LOG(&f, "tlookup:1:1,tshow:5:0");
    CHECK(c.sound_played == 0u && f.o.dirty == 0u && c.key_pressed == 1u);
    /* the flag is any nonzero value */
    CHECK(press(&f, 1, -1, &c) == D0_OK && c.sound_played == 1u);
    /* "NO SOUND" keys: record copied, no sound */
    fx_init(&f);
    start(&f);
    CHECK(press(&f, 0, 1, &c) == D0_OK && c.sound_played == 1u);
    f.log[0] = '\0';
    f.long_len = 3u;
    CHECK(press(&f, 3, 1, &c) == D0_OK);
    CHECK_LOG(&f, "tlookup:3:1,tshow:6:0");
    CHECK(c.sound_played == 0u && strcmp((const char *)f.body + 0x715, "NO SOUND") == 0 && strcmp(f.shown, "xxx<e>") == 0);
    /* the copy is strlen + 1 bytes: the tail of a longer previous record stays behind */
    fx_init(&f);
    start(&f);
    memset(f.body + 0x715, 'Z', 0x20u);
    CHECK(press(&f, 0, 0, &c) == D0_OK);
    CHECK(memcmp(f.body + 0x715, "KS0\0ZZ", 6) == 0);
    /* without a surface the key is not shown pressed */
    fx_init(&f);
    f.body[0] = 0;
    start(&f);
    CHECK(press(&f, 1, 1, &c) == D0_OK && f.o.pressed == 0u && c.key_pressed == 1u && f.o.last == 1);
    /* an empty text is shown as the bare suffix */
    fx_init(&f);
    start(&f);
    set_str(f.body, 0x337 + 0x21u, "TEMPTY");
    CHECK(press(&f, 0, 0, &c) == D0_OK && c.text_shown == 1u && strcmp(f.shown, "<e>") == 0);
    CHECK_LOG(&f, "tlookup:0:1,tshow:3:0");
}

static void t_click_window(void)
{
    Fx f;
    D0ClickResult c;
    fx_init(&f);
    start(&f);
    put16(f.body, 0x317, 5);
    for (int i = 5; i < D0_MAX_KEYS; ++i) f.o.order[i] = (int16_t)(0x50 + i);
    for (int k = 0; k < 8; ++k) CHECK(press(&f, (int16_t)(k % 4), 0, &c) == D0_OK);
    /* keys 0,1,2,3,0,1,2,3: the last five */
    CHECK(f.o.order[0] == 3 && f.o.order[1] == 0 && f.o.order[2] == 1 && f.o.order[3] == 2 && f.o.order[4] == 3);
    for (int i = 5; i < D0_MAX_KEYS; ++i) CHECK(f.o.order[i] == 0x50 + i);
    /* L = 1 keeps only the last key */
    put16(f.body, 0x317, 1);
    CHECK(press(&f, 2, 0, &c) == D0_OK && f.o.order[0] == 2 && f.o.order[1] == 0);
    /* L = 15: the whole array shifts, nothing is written past it */
    put16(f.body, 0x317, 15);
    put16(f.body, 0x21, 15);
    for (int i = 0; i < D0_MAX_KEYS; ++i) f.o.order[i] = (int16_t)(100 + i);
    f.o.hover = 3;
    CHECK(click(&f, D0_CANDIDATE_KEY, 0, &c) == D0_OK);
    for (int i = 0; i < 14; ++i) CHECK(f.o.order[i] == 101 + i);
    CHECK(f.o.order[14] == 3);
    /* three keys fill the window with the solution order */
    fx_init(&f);
    start(&f);
    CHECK(press(&f, 2, 0, &c) == D0_OK && press(&f, 0, 0, &c) == D0_OK && press(&f, 1, 0, &c) == D0_OK);
    CHECK(f.o.order[0] == 2 && f.o.order[1] == 0 && f.o.order[2] == 1);
}

static void t_click_gating(void)
{
    Fx f;
    D0ClickResult c;
    fx_init(&f);
    /* inactive */
    f.o.hover = 1;
    CHECK(click(&f, D0_CANDIDATE_KEY, 1, &c) == D0_OK && c.key_pressed == 0u && c.new_phase == 1u && f.log[0] == '\0');
    CHECK(click(&f, D0_CANDIDATE_EXIT, 1, &c) == D0_OK && c.exit_asked == 0u && f.o.exit_taken == 0u);
    start(&f);
    /* state other than IDLE */
    for (int s = -1; s <= 5; ++s) {
        if (s == D0_STATE_IDLE) continue;
        f.o.state = s;
        f.o.hover = 1;
        CHECK(click(&f, D0_CANDIDATE_KEY, 1, &c) == D0_OK && c.key_pressed == 0u && f.log[0] == '\0' && f.o.pressed == 0u);
        CHECK(click(&f, D0_CANDIDATE_EXIT, 1, &c) == D0_OK && c.exit_asked == 0u && f.o.exit_taken == 0u);
    }
    f.o.state = D0_STATE_IDLE;
    /* row phase other than 1: the result carries it back */
    for (uint32_t p = 0u; p < 4u; ++p) {
        if (p == 1u) continue;
        CHECK(d0_click(&f.o, f.body, D0_BODY_BYTES, p, D0_CANDIDATE_EXIT, 1, &f.host, &c) == D0_OK);
        CHECK(c.exit_asked == 0u && c.new_phase == p && f.o.exit_taken == 0u && f.log[0] == '\0');
        CHECK(d0_click(&f.o, f.body, D0_BODY_BYTES, p, D0_CANDIDATE_KEY, 1, &f.host, &c) == D0_OK && c.key_pressed == 0u);
    }
    /* other candidates do nothing */
    static const int32_t others[] = {-1, 0, 5, 0x2764, 0x2767, 0x2719, 0x271a};
    for (size_t i = 0; i < sizeof others / sizeof others[0]; ++i) {
        CHECK(click(&f, others[i], 1, &c) == D0_OK && c.key_pressed == 0u && c.exit_asked == 0u && c.new_phase == 1u);
    }
    CHECK(f.log[0] == '\0');
    /* the exit */
    CHECK(click(&f, D0_CANDIDATE_EXIT, 1, &c) == D0_OK);
    CHECK(c.exit_asked == 1u && c.new_phase == 2u && c.key_pressed == 0u && f.o.exit_taken == 1u);
    CHECK_LOG(&f, "phase:2:0");
    /* the hover is out of range at a key press: refused before any effect */
    fx_init(&f);
    start(&f);
    for (int h = -2; h <= 5; ++h) {
        if (h >= 0 && h < 4) continue;
        f.o.hover = (int16_t)h;
        f.o.order[2] = 9;
        CHECK(click(&f, D0_CANDIDATE_KEY, 1, &c) == D0_ERR_BOUNDS && f.log[0] == '\0' && f.o.order[2] == 9);
        CHECK(f.o.pressed == 0u && f.o.last == 0 && c.key_pressed == 0u);
    }
    /* argument checks */
    CHECK(d0_click(NULL, f.body, D0_BODY_BYTES, 1u, 1, 1, &f.host, &c) == D0_ERR_ARGUMENT);
    CHECK(d0_click(&f.o, NULL, D0_BODY_BYTES, 1u, 1, 1, &f.host, &c) == D0_ERR_ARGUMENT);
    CHECK(d0_click(&f.o, f.body, D0_BODY_BYTES, 1u, 1, 1, NULL, &c) == D0_ERR_ARGUMENT);
    CHECK(d0_click(&f.o, f.body, D0_BODY_BYTES, 1u, 1, 1, &f.host, NULL) == D0_ERR_ARGUMENT);
    CHECK(d0_click(&f.o, f.body, D0_BODY_BYTES - 1u, 1u, 1, 1, &f.host, &c) == D0_ERR_ARGUMENT);
    put16(f.body, 0x317, 16);
    CHECK(d0_click(&f.o, f.body, D0_BODY_BYTES, 1u, 1, 1, &f.host, &c) == D0_ERR_ARGUMENT);
}

static void t_click_text_limits(void)
{
    Fx f;
    D0ClickResult c;
    /* 199 characters fit the original's buffer with the suffix; 200 overflow it (native refusal, after the sound) */
    fx_init(&f);
    start(&f);
    f.long_len = 199u;
    set_str(f.body, 0x337 + 0x42u * 3u, "KS3");
    CHECK(press(&f, 3, 1, &c) == D0_OK && c.text_shown == 1u && f.shown_len == 202u && f.shown_calls == 1);
    CHECK(strcmp(f.shown + 199, "<e>") == 0);
    CHECK(strstr(f.log, "tshow:202:0") != NULL);
    fx_init(&f);
    start(&f);
    f.long_len = 200u;
    set_str(f.body, 0x337 + 0x42u * 3u, "KS3");
    CHECK(press(&f, 3, 1, &c) == D0_ERR_BOUNDS && f.shown_calls == 0 && c.text_shown == 0u);
    CHECK_LOG(&f, "busy:5:0,prep:1813:0,play:5:0,tick:1000:0,tlookup:3:1");
    CHECK(f.o.pressed == 1u && f.o.order[2] == 3); /* the press itself happened */
    /* the original skips texts longer than 0x9c40 characters and shows nothing */
    fx_init(&f);
    start(&f);
    f.long_len = D0_TEXT_MAX;
    CHECK(press(&f, 3, 0, &c) == D0_ERR_BOUNDS);
    fx_init(&f);
    start(&f);
    f.long_len = D0_TEXT_MAX + 1u;
    CHECK(press(&f, 3, 0, &c) == D0_OK && c.text_shown == 0u && f.shown_calls == 0 && c.key_pressed == 1u);
    CHECK_LOG(&f, "tlookup:3:1");
}

static void t_render(void)
{
    Fx f;
    D0RenderResult r;
    D0ClickResult c;
    fx_init(&f);
    /* no slot: nothing */
    CHECK(render(&f, &r) == D0_OK && r.valid == 0u && r.blit == 0u && f.n_origin == 0);
    start(&f);
    CHECK(f.o.slot == 24);
    /* no redraw request */
    CHECK(render(&f, &r) == D0_OK && r.valid == 1u && r.blit == 0u && f.n_origin == 0 && f.log[0] == '\0');
    /* a pressed key: blit 1 from the puzzle surface to the key rectangle plus the view origin, state RELEASE */
    f.o.dirty = 1;
    f.o.pressed = 1;
    f.o.hover = 2;
    f.o.last = 2;
    CHECK(render(&f, &r) == D0_OK && r.valid == 1u && r.blit == 1u && r.key == 2 && r.src_surface == 77u);
    CHECK(r.src[0] == 120 && r.src[1] == 202 && r.src[2] == 129 && r.src[3] == 211);
    CHECK(r.dst[0] == 50 && r.dst[1] == 20 && r.dst[2] == 59 && r.dst[3] == 29 && r.solved_check == 0u);
    CHECK_LOG(&f, "blit:2:1,state:0:0");
    CHECK(f.o.state == D0_STATE_RELEASE && f.o.dirty == 0u && f.n_origin == 1);
    /* the same request again does nothing */
    f.log[0] = '\0';
    CHECK(render(&f, &r) == D0_OK && r.valid == 1u && r.blit == 0u && f.log[0] == '\0');
    /* a negative view origin */
    f.vx = -5;
    f.vy = -7;
    f.o.dirty = 1;
    CHECK(render(&f, &r) == D0_OK && r.blit == 1u && r.dst[0] == 35 && r.dst[1] == -7 && r.dst[2] == 44 && r.dst[3] == 2);
    f.vx = 10;
    f.vy = 20;
    /* pressed beats the check */
    f.o.dirty = 1;
    f.o.check = 1;
    CHECK(render(&f, &r) == D0_OK && r.blit == 1u && f.o.check == 1u);
    /* a released key: blit 2 restores the background (source is the key rectangle itself), then the solved check */
    f.o.pressed = 0;
    f.o.dirty = 1;
    f.o.last = 1;
    set_order(&f, 0, 0, 0);
    f.log[0] = '\0';
    CHECK(render(&f, &r) == D0_OK && r.valid == 1u && r.blit == 2u && r.key == 1 && r.src_surface == 0u);
    CHECK(r.src[0] == 20 && r.src[1] == 0 && r.src[2] == 29 && r.src[3] == 9);
    CHECK(r.dst[0] == 30 && r.dst[1] == 20 && r.dst[2] == 39 && r.dst[3] == 29 && r.solved_check == 1u);
    CHECK_LOG(&f, "blit:1:2,solvedchk:0:0");
    CHECK(f.o.check == 0u && f.o.dirty == 0u && f.o.solved == 0u && f.o.state == D0_STATE_RELEASE);
    /* a solved sequence moves the state to START_WIN */
    f.o.state = D0_STATE_IDLE;
    set_order(&f, 2, 0, 1);
    f.o.dirty = 1;
    f.o.check = 1;
    f.log[0] = '\0';
    CHECK(render(&f, &r) == D0_OK && r.blit == 2u && r.solved_check == 1u);
    CHECK_LOG(&f, "blit:1:2,solvedchk:0:0,state:2:0");
    CHECK(f.o.state == D0_STATE_START_WIN && f.o.solved == 1u);
    /* the hover -1 with a pressed key and a pending check falls through to the restore */
    f.o.dirty = 1;
    f.o.pressed = 1;
    f.o.hover = -1;
    f.o.check = 1;
    f.o.last = 3;
    CHECK(render(&f, &r) == D0_OK && r.blit == 2u && r.key == 3);
    /* nothing to draw: the redraw request is dropped */
    f.o.dirty = 1;
    f.o.pressed = 0;
    f.o.check = 0;
    CHECK(render(&f, &r) == D0_OK && r.valid == 1u && r.blit == 0u && f.o.dirty == 0u);
    f.o.dirty = 1;
    f.o.check = 1;
    f.o.last = -1;
    CHECK(render(&f, &r) == D0_OK && r.blit == 0u && f.o.dirty == 0u && f.o.check == 1u);
    /* the redraw request is ignored without a surface */
    fx_init(&f);
    f.body[0] = 0;
    start(&f);
    f.o.slot = 30;
    f.o.dirty = 1;
    f.o.pressed = 1;
    f.o.hover = 0;
    CHECK(render(&f, &r) == D0_OK && r.valid == 1u && r.blit == 0u && f.n_origin == 0);
    /* keys outside 0..N-1 are refused before any effect */
    fx_init(&f);
    start(&f);
    f.o.dirty = 1;
    f.o.pressed = 1;
    for (int h = 4; h <= 6; ++h) {
        f.o.hover = (int16_t)h;
        CHECK(render(&f, &r) == D0_ERR_BOUNDS && f.log[0] == '\0' && f.n_origin == 0 && f.o.state == D0_STATE_IDLE);
    }
    f.o.hover = -2;
    CHECK(render(&f, &r) == D0_ERR_BOUNDS);
    f.o.pressed = 0;
    f.o.check = 1;
    for (int k = 4; k <= 6; ++k) {
        f.o.last = (int16_t)k;
        CHECK(render(&f, &r) == D0_ERR_BOUNDS && f.log[0] == '\0' && f.o.check == 1u);
    }
    f.o.last = -2;
    CHECK(render(&f, &r) == D0_ERR_BOUNDS);
    /* argument checks */
    CHECK(d0_render(NULL, f.body, D0_BODY_BYTES, &f.host, &r) == D0_ERR_ARGUMENT);
    CHECK(d0_render(&f.o, NULL, D0_BODY_BYTES, &f.host, &r) == D0_ERR_ARGUMENT);
    CHECK(d0_render(&f.o, f.body, D0_BODY_BYTES, NULL, &r) == D0_ERR_ARGUMENT);
    CHECK(d0_render(&f.o, f.body, D0_BODY_BYTES, &f.host, NULL) == D0_ERR_ARGUMENT);
    CHECK(d0_render(&f.o, f.body, D0_BODY_BYTES - 1u, &f.host, &r) == D0_ERR_ARGUMENT);
    (void)c;
}

static void t_invalidate(void)
{
    Fx f;
    fx_init(&f);
    CHECK(d0_invalidate(&f.o, &f.host) == D0_OK && f.n_dirty == 0);
    start(&f);
    CHECK(d0_invalidate(&f.o, &f.host) == D0_OK && f.n_dirty == 1 && f.dirty_slot == 24);
    /* active without a render entry */
    fx_init(&f);
    f.body[0] = 0;
    start(&f);
    CHECK(d0_invalidate(&f.o, &f.host) == D0_OK && f.n_dirty == 0);
    /* a slot of an inactive object is not touched */
    fx_init(&f);
    start(&f);
    f.o.active = 0;
    CHECK(d0_invalidate(&f.o, &f.host) == D0_OK && f.n_dirty == 0);
    CHECK(d0_invalidate(NULL, &f.host) == D0_ERR_ARGUMENT);
    CHECK(d0_invalidate(&f.o, NULL) == D0_ERR_ARGUMENT);
    {
        D0Host h = f.host;
        h.mark_dirty = NULL;
        CHECK(d0_invalidate(&f.o, &h) == D0_ERR_ARGUMENT);
    }
}

static void t_cleanup(void)
{
    Fx f;
    fx_init(&f);
    start(&f);
    f.o.exit_taken = 1;
    f.o.solved = 1;
    CHECK(d0_cleanup(&f.o, &f.host) == D0_OK);
    CHECK_LOG(&f, "relsurf:77:0,relslot:24:0");
    CHECK(f.o.surface == 0u && f.o.slot == D0_NO_SLOT && f.o.row == -1 && f.o.active == 0 && f.o.exit_taken == 0u &&
          f.o.solved == 0u);
    /* idempotent */
    f.log[0] = '\0';
    CHECK(d0_cleanup(&f.o, &f.host) == D0_OK && f.log[0] == '\0');
    /* slot without surface, surface without slot */
    f.o.slot = 30;
    CHECK(d0_cleanup(&f.o, &f.host) == D0_OK);
    CHECK_LOG(&f, "relslot:30:0");
    f.log[0] = '\0';
    f.o.surface = 9u;
    CHECK(d0_cleanup(&f.o, &f.host) == D0_OK);
    CHECK_LOG(&f, "relsurf:9:0");
    /* the reset keeps the rest of the object: only the listed fields change */
    f.o.hover = 2;
    f.o.last = 3;
    f.o.deadline = 5u;
    f.o.state = 3;
    f.o.pressed = 1;
    CHECK(d0_cleanup(&f.o, &f.host) == D0_OK && f.o.hover == 2 && f.o.last == 3 && f.o.deadline == 5u && f.o.state == 3);
    CHECK(d0_cleanup(NULL, &f.host) == D0_ERR_ARGUMENT && d0_cleanup(&f.o, NULL) == D0_ERR_ARGUMENT);
    {
        D0Host h = f.host;
        h.release_slot = NULL;
        CHECK(d0_cleanup(&f.o, &h) == D0_ERR_ARGUMENT);
        h = f.host;
        h.release_surface = NULL;
        CHECK(d0_cleanup(&f.o, &h) == D0_ERR_ARGUMENT);
    }
    /* a failed surface release keeps the object as it was (the session must stop) */
    fx_init(&f);
    start(&f);
    f.calls = 0;
    f.fail_call = 1;
    CHECK(d0_cleanup(&f.o, &f.host) == D0_ERR_HOST && f.o.surface == 77u && f.o.slot == 24 && f.o.active == 1);
}

/* ---- host failure at every callback ------------------------------------------------------------------------------------- */

typedef int (*Scenario)(Fx *f);
static void arm(Fx *f)
{
    f->calls = 0;
    f->fail_call = f->sweep_n;
    f->log[0] = '\0';
}
static int sc_phase0(Fx *f)
{
    arm(f);
    return visit(f, 0);
}
static int sc_click(Fx *f)
{
    D0ClickResult c;
    start(f);
    f->o.hover = 1;
    arm(f);
    return click(f, D0_CANDIDATE_KEY, 1, &c);
}
static int sc_render_pressed(Fx *f)
{
    D0RenderResult r;
    start(f);
    f->o.dirty = 1;
    f->o.pressed = 1;
    f->o.hover = 1;
    arm(f);
    return render(f, &r);
}
static int sc_render_restore(Fx *f)
{
    D0RenderResult r;
    start(f);
    f->o.dirty = 1;
    f->o.check = 1;
    f->o.last = 1;
    arm(f);
    return render(f, &r);
}
static int sc_release(Fx *f)
{
    start(f);
    f->o.state = D0_STATE_RELEASE;
    f->o.deadline = 0u;
    arm(f);
    return visit(f, 1);
}
static int sc_start_win_sound(Fx *f)
{
    start(f);
    f->o.state = D0_STATE_WAIT_WIN;
    arm(f);
    return visit(f, 1);
}
static int sc_win_busy(Fx *f)
{
    start(f);
    f->o.state = D0_STATE_WIN_SOUND;
    arm(f);
    return visit(f, 1);
}
static int sc_finish_solved(Fx *f)
{
    start(f);
    f->o.solved = 1;
    arm(f);
    return visit(f, 2);
}
static int sc_finish_plain(Fx *f)
{
    start(f);
    arm(f);
    return visit(f, 2);
}
static int sc_invalidate(Fx *f)
{
    start(f);
    arm(f);
    return d0_invalidate(&f->o, &f->host);
}

static void t_host_failure_sweep(void)
{
    static const Scenario scenarios[] = {sc_phase0, sc_click, sc_render_pressed, sc_render_restore, sc_release,
                                         sc_start_win_sound, sc_win_busy, sc_finish_solved, sc_finish_plain, sc_invalidate};
    unsigned mask = 0u;
    int failures = 0;
    for (size_t s = 0; s < sizeof scenarios / sizeof scenarios[0]; ++s) {
        int n;
        for (n = 1; n < 40; ++n) {
            Fx f;
            int rc;
            fx_init(&f);
            f.sweep_n = n;
            rc = scenarios[s](&f);
            if (rc == D0_OK) {
                CHECK(f.calls < n);
                break;
            }
            CHECK(rc == D0_ERR_HOST);
            CHECK(f.failed_cb != 0);
            mask |= f.failed_mask;
            ++failures;
        }
        CHECK(n < 40);
    }
    for (int cb = CB_ALLOC; cb <= CB_LAST; ++cb) CHECK((mask & (1u << cb)) != 0u);
    CHECK(failures == 24); /* 5 + 5 + 1 + 1 + 1 + 2 + 2 + 4 + 2 + 1 failure points over the ten scenarios */
}

static void t_host_failure_effects(void)
{
    /* a failed call stops the visit at that point: nothing after it is logged or changed */
    Fx f;
    fx_init(&f);
    f.sweep_n = 3; /* clear-item, alloc, register fails */
    CHECK(sc_phase0(&f) == D0_ERR_HOST && f.failed_cb == CB_REGISTER);
    CHECK_LOG(&f, "active:1:0,start:1:0,clearitem:0:0,slot:24:0");
    CHECK(f.o.slot == 24 && f.o.surface == 0u && f.o.state == 0);
    /* the load failing leaves the surface empty */
    fx_init(&f);
    f.sweep_n = 4;
    CHECK(sc_phase0(&f) == D0_ERR_HOST && f.failed_cb == CB_LOAD && f.o.surface == 0u);
    /* the finish failing at the transition does not complete */
    fx_init(&f);
    f.sweep_n = 1;
    CHECK(sc_finish_solved(&f) == D0_ERR_HOST && f.failed_cb == CB_TRANSITION && f.completed == 0 && f.o.active == 1);
    CHECK_LOG(&f, "start:1:0");
    /* a failing sound play after the prepare ends the key press without the text */
    fx_init(&f);
    f.sweep_n = 3; /* busy, prepare, play */
    CHECK(sc_click(&f) == D0_ERR_HOST && f.failed_cb == CB_PLAY && f.shown_calls == 0);
    /* the scene name of the load is the body's name */
    fx_init(&f);
    set_str(f.body, 0, "OTHER");
    CHECK(visit(&f, 0) == D0_ERR_HOST); /* the fake loads only PIANO */
}

/* ---- whole sequences -------------------------------------------------------------------------------------------------- */

/* One key: pointer at its hit rectangle, accepted release, render, wait out the deadline, release, render. */
static void play_key(Fx *f, int key, int start_flag)
{
    D0PointerResult p;
    D0ClickResult c;
    D0RenderResult r;
    CHECK(pointer(f, 20 * key + 4, 4, &p) == D0_OK && p.hit == 1u && p.candidate == D0_CANDIDATE_KEY);
    CHECK(click(f, p.candidate, start_flag, &c) == D0_OK && c.key_pressed == 1u);
    CHECK(render(f, &r) == D0_OK && r.blit == 1u && r.key == key && f->o.state == D0_STATE_RELEASE);
    f->now += 499u;
    CHECK(visit(f, 1) == D0_OK);
    /* a "NO SOUND" key does not set a new deadline, so the release already happens on the first visit */
    CHECK(f->o.pressed == (key == 3 ? 0u : 1u));
    f->now += 1u;
    CHECK(visit(f, 1) == D0_OK && f->o.pressed == 0u && f->o.state == D0_STATE_IDLE);
    CHECK(render(f, &r) == D0_OK && r.blit == 2u && r.key == key && r.solved_check == 1u);
}

static void t_playthrough_solved(void)
{
    Fx f;
    fx_init(&f);
    start(&f);
    play_key(&f, 2, 1);
    play_key(&f, 0, 1);
    play_key(&f, 3, 1); /* a wrong key in the last place */
    CHECK(f.o.solved == 0u && f.o.state == D0_STATE_IDLE);
    play_key(&f, 2, 1);
    play_key(&f, 0, 1);
    CHECK(f.o.solved == 0u);
    play_key(&f, 1, 1);
    CHECK(f.o.solved == 1u && f.o.state == D0_STATE_START_WIN);
    CHECK(f.n_play == 5 && f.n_stop == 6);
    /* the win sequence: delay 2 s, then the sound, then the finish */
    f.log[0] = '\0';
    f.now = 10000u;
    CHECK(visit(&f, 1) == D0_OK && f.o.state == D0_STATE_WAIT_WIN && f.o.deadline == 12000u);
    f.now = 11999u;
    CHECK(visit(&f, 1) == D0_OK && f.o.state == D0_STATE_WAIT_WIN && f.phase == 1u);
    f.now = 12000u;
    CHECK(visit(&f, 1) == D0_OK && f.o.state == D0_STATE_WIN_SOUND && f.phase == 1u);
    f.busy_value = 1;
    CHECK(visit(&f, 1) == D0_OK && f.phase == 1u);
    f.busy_value = 0;
    CHECK(visit(&f, 1) == D0_OK && f.phase == 2u);
    CHECK(visit(&f, 2) == D0_OK && f.completed == 1 && f.phase == 0u);
    CHECK(strstr(f.log, "tr:40:1:2:3:11:22:33") != NULL && strstr(f.log, "sf:7:3") != NULL);
    CHECK(f.o.active == 0 && f.o.slot == D0_NO_SLOT && f.world.start_flag_5bb1ca == 0);
}

static void t_playthrough_without_surface(void)
{
    Fx f;
    D0PointerResult p;
    D0ClickResult c;
    fx_init(&f);
    f.body[0] = 0;
    start(&f);
    for (int i = 0; i < 3; ++i) {
        static const int keys[3] = {2, 0, 1};
        CHECK(pointer(&f, 20 * keys[i] + 4, 4, &p) == D0_OK && p.hit == 1u);
        CHECK(click(&f, p.candidate, 0, &c) == D0_OK && c.key_pressed == 1u && f.o.pressed == 0u);
        CHECK(visit(&f, 1) == D0_OK); /* the handler's own solved check */
        CHECK(f.o.solved == (i == 2 ? 1u : 0u));
    }
    CHECK(f.o.state == D0_STATE_START_WIN);
    /* the win with no win sound ends in phase 2 after the delay, and the exit block is not used */
    set_str(f.body, 0x761, "NO SOUND");
    f.now = 100u;
    CHECK(visit(&f, 1) == D0_OK && f.o.deadline == 2100u);
    f.now = 2100u;
    CHECK(visit(&f, 1) == D0_OK && f.phase == 2u);
    f.log[0] = '\0';
    CHECK(visit(&f, 2) == D0_OK && f.completed == 1 && strstr(f.log, "tr:40:") != NULL);
    CHECK(f.n_prepare == 0 && f.n_play == 0);
}

static void t_playthrough_exit(void)
{
    Fx f;
    D0PointerResult p;
    D0ClickResult c;
    fx_init(&f);
    start(&f);
    play_key(&f, 1, 1);
    CHECK(pointer(&f, 105, 55, &p) == D0_OK && p.candidate == D0_CANDIDATE_EXIT && p.cursor_kind == D0_CURSOR_EXIT);
    CHECK(click(&f, p.candidate, 1, &c) == D0_OK && c.exit_asked == 1u && c.new_phase == 2u);
    f.log[0] = '\0';
    CHECK(visit(&f, 2) == D0_OK && f.completed == 1 && f.phase == 0u);
    CHECK(strstr(f.log, "tr:50:4:5:6:44:55:66") != NULL && strstr(f.log, "sf:8:9") != NULL);
    CHECK(f.world.start_flag_5bb1ca == 1 && f.o.exit_taken == 0u);
    /* after the finish, the pointer and the click find an idle puzzle */
    CHECK(pointer(&f, 105, 55, &p) == D0_OK && p.hit == 0u);
    CHECK(click(&f, D0_CANDIDATE_EXIT, 1, &c) == D0_OK && c.exit_asked == 0u);
    /* a second round on the same object starts from the beginning */
    f.log[0] = '\0';
    CHECK(visit(&f, 0) == D0_OK && f.phase == 1u && f.o.order[0] == 0 && f.o.order[2] == 0 && f.o.solved == 0u);
}

/* ---- the session binding (src/session_bindings_ad0.c) over a synthetic scene -------------------------------------------- */

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
    uint8_t tsum[126], act[48 + 2 + D0_BODY_BYTES];
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

static int g_world_stores, g_world_value;
static void h_store_world(void *c, const D0World *w)
{
    (void)c;
    ++g_world_stores;
    g_world_value = w->start_flag_5bb1ca;
}

typedef struct Bind {
    Fx f;
    SessionAd0Host host;
    SessionAd0Binding *b;
    SceneResource *scene;
    uint8_t bytes[8192];
    uint8_t bytes_before[8192];
    size_t bytes_len;
    uint8_t body_a[D0_BODY_BYTES], body_b[D0_BODY_BYTES];
} Bind;

static int bind_open(Bind *x)
{
    const int types[3] = {0x70, 0xd0, 0xd0};
    const uint8_t one = 0;
    const uint8_t *bodies[3];
    size_t lengths[3] = {1, D0_BODY_BYTES, D0_BODY_BYTES};
    char err[128] = {0};
    fx_init(&x->f);
    g_world_stores = 0;
    g_world_value = -1;
    memcpy(x->body_a, x->f.body, D0_BODY_BYTES);
    memcpy(x->body_b, x->f.body, D0_BODY_BYTES);
    put_rect(x->body_b, 0x203, 300, 2, 309, 7); /* row 2: key 0 elsewhere */
    put16(x->body_b, 0x7a8, 11);                /* exit flag 11 */
    put_rect(x->body_b, 0x23, 500, 600, 509, 609); /* row 2: key 0 pressed source elsewhere */
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
    x->host.store_world = h_store_world;
    x->b = session_ad0_create(&x->host);
    return x->b != NULL;
}

static void bind_close(Bind *x)
{
    session_ad0_destroy(x->b);
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
        const int rc = session_ad0_handler(x->b, row, &info, &st, &out);
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
    uint32_t ph = 99u;
    int done = -1;
    D0PointerResult p;
    D0ClickResult c;
    D0RenderResult r;
    if (!bind_open(&x)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_ad0_begin_scene(x.b, x.scene) == D0_OK && strcmp(session_ad0_failure(x.b), "none") == 0);
    CHECK(session_ad0_registered(x.b) == 0u && session_ad0_object(x.b)->active == 0 && session_ad0_object(x.b)->row == -1);
    /* a row of another type, an unknown index and bad arguments are not ours */
    {
        SceneActionInfo info, other;
        SceneActionRuntimeState st;
        SceneActionHandlerResult out;
        memset(&st, 0, sizeof st);
        CHECK(scene_resource_action_at(x.scene, 0, &info) == SCENE_RESOURCE_OK);
        CHECK(session_ad0_handler(x.b, 0, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(strcmp(session_ad0_failure(x.b), "0xd0-row-not-owned") == 0);
        CHECK(scene_resource_action_at(x.scene, 1, &info) == SCENE_RESOURCE_OK);
        CHECK(session_ad0_handler(x.b, 7, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(strcmp(session_ad0_failure(x.b), "0xd0-row-not-owned") == 0);
        CHECK(session_ad0_handler(x.b, 3, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR); /* one past the last row */
        CHECK(strcmp(session_ad0_failure(x.b), "0xd0-row-not-owned") == 0);
        /* a type 0xd0 action at the index of a row that is not ours */
        CHECK(session_ad0_handler(x.b, 0, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(strcmp(session_ad0_failure(x.b), "0xd0-row-not-owned") == 0);
        x.f.log[0] = '\0';
        CHECK(scene_resource_action_at(x.scene, 0, &other) == SCENE_RESOURCE_OK);
        CHECK(session_ad0_handler(x.b, 1, &other, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_ad0_handler(x.b, 0, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(x.f.log[0] == '\0');
        CHECK(session_ad0_handler(x.b, 1, NULL, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_ad0_handler(x.b, 1, &info, NULL, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_ad0_handler(x.b, 1, &info, &st, NULL) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_ad0_handler(NULL, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        /* phase 1 before phase 0 is unsupported; the failure text says why */
        st.phase = 1u;
        CHECK(session_ad0_handler(x.b, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
        CHECK(strcmp(session_ad0_failure(x.b), "0xd0-phase-1-without-init") == 0);
    }
    /* pointer, click and render before the puzzle starts */
    memset(&p, 0x55, sizeof p);
    CHECK(session_ad0_pointer_move(x.b, 5, 5, &p) == D0_OK && p.hit == 0u && p.candidate == -1 && p.cursor_written == 0u);
    memset(&c, 0x55, sizeof c);
    CHECK(session_ad0_click(x.b, 1u, D0_CANDIDATE_EXIT, 1, &c) == D0_OK && c.new_phase == 1u && c.exit_asked == 0u &&
          c.key_pressed == 0u);
    CHECK(session_ad0_click(x.b, 7u, D0_CANDIDATE_KEY, 1, &c) == D0_OK && c.new_phase == 7u);
    memset(&r, 0x55, sizeof r);
    CHECK(session_ad0_render(x.b, &r) == D0_OK && r.valid == 0u && r.blit == 0u);
    CHECK(session_ad0_invalidate(x.b) == D0_OK && x.f.n_dirty == 0);
    /* phase 0 of row 1 */
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u && done == 0);
    CHECK(g_world_stores == 1 && g_world_value == 1);
    CHECK(session_ad0_registered(x.b) == 1u && session_ad0_object(x.b)->active == 1 && session_ad0_object(x.b)->row == 1);
    CHECK(session_ad0_render(x.b, &r) == D0_OK && r.valid == 1u && r.blit == 0u);
    CHECK(session_ad0_invalidate(x.b) == D0_OK && x.f.n_dirty == 1 && x.f.dirty_slot == 24);
    /* the pointer uses the body of the active row (row 1: key 0 at x 2..7) */
    CHECK(session_ad0_pointer_move(x.b, 4, 4, &p) == D0_OK && p.hit == 1u && p.candidate == D0_CANDIDATE_KEY);
    CHECK(session_ad0_object(x.b)->hover == 0);
    CHECK(session_ad0_pointer_move(x.b, 304, 4, &p) == D0_OK && p.hit == 0u);
    /* a key press with sound: the binding's row copy receives the key's sound name, the scene's bytes do not change */
    x.f.now = 3000u;
    CHECK(session_ad0_click(x.b, 1u, D0_CANDIDATE_KEY, 1, &c) == D0_OK && c.key_pressed == 1u && c.sound_played == 1u);
    CHECK(c.text_shown == 1u && c.new_phase == 1u && strcmp(x.f.shown, "Do<e>") == 0);
    CHECK(strcmp(x.f.prepare_name, "KS0") == 0 && x.f.prepare_ptr != NULL && x.f.prepare_ptr != x.body_a);
    CHECK(x.f.prepare_ptr != x.f.body + 0x715 && x.f.prepare_ptr != x.bytes);
    CHECK(memcmp(x.bytes, x.bytes_before, x.bytes_len) == 0);
    CHECK(x.f.stop_ptr == NULL);
    /* the render shows the pressed key, the next phase 1 visit waits for the deadline, the release stops the sound that was started */
    CHECK(session_ad0_render(x.b, &r) == D0_OK && r.blit == 1u && r.key == 0 && r.src_surface == 77u && r.dst[0] == 10);
    x.f.now = 3499u;
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u && done == 0 && x.f.n_stop == 0);
    x.f.now = 3500u;
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK && x.f.n_stop == 1);
    CHECK(x.f.stop_ptr == x.f.prepare_ptr && strcmp((const char *)x.f.stop_ptr, "KS0") == 0); /* the live row body */
    CHECK(g_world_stores == 1); /* phase 1 visits write no world */
    CHECK(session_ad0_render(x.b, &r) == D0_OK && r.blit == 2u && r.solved_check == 1u);
    /* the click arguments of the active puzzle, and a row phase that passes through */
    CHECK(session_ad0_click(x.b, 7u, D0_CANDIDATE_KEY, 1, &c) == D0_OK && c.new_phase == 7u && c.key_pressed == 0u);
    /* exit: new_phase 2, then the finish completes with phase 0 and stores the world */
    CHECK(session_ad0_click(x.b, 1u, D0_CANDIDATE_EXIT, 1, &c) == D0_OK && c.new_phase == 2u && c.exit_asked == 1u);
    CHECK(b_visit(&x, 1, 2u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 0u && done == 1);
    CHECK(g_world_stores == 2 && g_world_value == 1);
    CHECK(session_ad0_object(x.b)->active == 0 && session_ad0_registered(x.b) == 0u);
    CHECK(strstr(x.f.log, "tr:50:") != NULL && strstr(x.f.log, "sf:8:9") != NULL);
    CHECK(session_ad0_render(x.b, &r) == D0_OK && r.valid == 0u);
    /* second row: its own body (key 0 at x 300..309, exit flag 11) */
    x.f.log[0] = '\0';
    CHECK(b_visit(&x, 2, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u);
    CHECK(session_ad0_pointer_move(x.b, 304, 4, &p) == D0_OK && p.hit == 1u && session_ad0_object(x.b)->hover == 0);
    CHECK(session_ad0_click(x.b, 1u, D0_CANDIDATE_KEY, 0, &c) == D0_OK && c.key_pressed == 1u);
    CHECK(session_ad0_render(x.b, &r) == D0_OK && r.blit == 1u && r.src[0] == 500 && r.src[1] == 600 && r.src_surface == 77u);
    CHECK(b_visit(&x, 2, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK && session_ad0_object(x.b)->state == D0_STATE_IDLE); /* released */
    CHECK(session_ad0_pointer_move(x.b, 4, 4, &p) == D0_OK && p.hit == 0u);
    CHECK(session_ad0_click(x.b, 1u, D0_CANDIDATE_EXIT, 1, &c) == D0_OK && c.new_phase == 2u);
    CHECK(b_visit(&x, 2, 2u, &ph, &done) == SCENE_ACTION_HANDLER_OK && done == 1 && strstr(x.f.log, "sf:11:9") != NULL);
    /* a phase beyond 2 is pending and untouched */
    CHECK(b_visit(&x, 1, 5u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 5u && done == 0);
    /* argument checks */
    CHECK(session_ad0_pointer_move(NULL, 0, 0, &p) == D0_ERR_ARGUMENT);
    CHECK(session_ad0_pointer_move(x.b, 0, 0, NULL) == D0_ERR_ARGUMENT);
    CHECK(session_ad0_click(NULL, 1u, 1, 1, &c) == D0_ERR_ARGUMENT);
    CHECK(session_ad0_click(x.b, 1u, 1, 1, NULL) == D0_ERR_ARGUMENT);
    CHECK(session_ad0_render(NULL, &r) == D0_ERR_ARGUMENT);
    CHECK(session_ad0_render(x.b, NULL) == D0_ERR_ARGUMENT);
    CHECK(session_ad0_invalidate(NULL) == D0_ERR_ARGUMENT);
    CHECK(session_ad0_begin_scene(NULL, x.scene) == D0_ERR_ARGUMENT);
    CHECK(session_ad0_begin_scene(x.b, NULL) == D0_ERR_ARGUMENT);
    CHECK(session_ad0_registered(NULL) == 0u && session_ad0_object(NULL) == NULL);
    CHECK(strcmp(session_ad0_failure(NULL), "0xd0-binding-unbound") == 0);
    CHECK(session_ad0_create(NULL) == NULL);
    session_ad0_destroy(NULL);
    bind_close(&x);
}

static void t_binding_solved_by_clicks(void)
{
    Bind x;
    uint32_t ph = 0u;
    int done = 0;
    D0PointerResult p;
    D0ClickResult c;
    D0RenderResult r;
    if (!bind_open(&x)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_ad0_begin_scene(x.b, x.scene) == D0_OK);
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    x.f.now = 100u;
    for (int i = 0; i < 3; ++i) {
        static const int keys[3] = {2, 0, 1};
        CHECK(session_ad0_pointer_move(x.b, 20 * keys[i] + 4, 4, &p) == D0_OK && p.hit == 1u);
        CHECK(session_ad0_click(x.b, 1u, p.candidate, 1, &c) == D0_OK && c.key_pressed == 1u);
        CHECK(session_ad0_render(x.b, &r) == D0_OK && r.blit == 1u);
        x.f.now += 500u;
        CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
        CHECK(session_ad0_render(x.b, &r) == D0_OK && r.blit == 2u);
    }
    CHECK(session_ad0_object(x.b)->solved == 1u && session_ad0_object(x.b)->state == D0_STATE_START_WIN);
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u); /* arms the delay */
    x.f.now += 2000u;
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u); /* win sound */
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 2u && done == 0);
    CHECK(b_visit(&x, 1, 2u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 0u && done == 1);
    CHECK(strstr(x.f.log, "tr:40:1:2:3:11:22:33") != NULL && g_world_value == 0 && g_world_stores == 2);
    bind_close(&x);
}

static void t_binding_scene_change_clears(void)
{
    Bind x;
    uint32_t ph = 0u;
    int done = 0;
    D0PointerResult p;
    D0ClickResult c;
    if (!bind_open(&x)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_ad0_begin_scene(x.b, x.scene) == D0_OK);
    /* the clear runs unconditionally (0x48d09c), and is silent on an idle object */
    CHECK_LOG(&x.f, "");
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    x.f.log[0] = '\0';
    /* the next scene's clear releases the surface and the slot and drops the active flag */
    CHECK(session_ad0_begin_scene(x.b, x.scene) == D0_OK);
    CHECK_LOG(&x.f, "relsurf:77:0,relslot:24:0");
    CHECK(session_ad0_object(x.b)->active == 0 && session_ad0_registered(x.b) == 0u && session_ad0_object(x.b)->row == -1);
    CHECK(session_ad0_pointer_move(x.b, 4, 4, &p) == D0_OK && p.hit == 0u);
    CHECK(session_ad0_click(x.b, 1u, D0_CANDIDATE_EXIT, 1, &c) == D0_OK && c.new_phase == 1u);
    /* the new scene's rows need their own phase 0 */
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    /* the new rows are fresh copies (a press of the old scene's record is gone) */
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    CHECK(session_ad0_pointer_move(x.b, 4, 4, &p) == D0_OK && p.hit == 1u);
    CHECK(session_ad0_click(x.b, 1u, D0_CANDIDATE_KEY, 0, &c) == D0_OK && c.key_pressed == 1u);
    CHECK(session_ad0_begin_scene(x.b, x.scene) == D0_OK);
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    /* destroy clears too */
    x.f.log[0] = '\0';
    bind_close(&x);
    CHECK(strstr(x.f.log, "relsurf:77:0,relslot:") != NULL);
}

static void t_binding_refuses_bad_body(void)
{
    Bind x;
    uint8_t bad[D0_BODY_BYTES];
    const int types[2] = {0xd0, 0xd0};
    const uint8_t *bodies[2];
    size_t lengths[2] = {D0_BODY_BYTES, D0_BODY_BYTES};
    size_t n;
    char err[128] = {0};
    uint32_t ph = 0u;
    int done = 0;
    SceneResource *bad_scene;
    if (!bind_open(&x)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_ad0_begin_scene(x.b, x.scene) == D0_OK);
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    memcpy(bad, x.body_a, sizeof bad);
    put16(bad, 0x317, 17);
    bodies[0] = x.body_a;
    bodies[1] = bad;
    n = build_scene(x.bytes, 2, types, bodies, lengths);
    bad_scene = scene_resource_open_memory(x.bytes, n, err, sizeof err);
    CHECK(bad_scene != NULL);
    if (bad_scene != NULL) {
        CHECK(session_ad0_begin_scene(x.b, bad_scene) == D0_ERR_BODY);
        CHECK(strcmp(session_ad0_failure(x.b), "0xd0-solution-length") == 0);
        /* the refusal comes before the clear: the running puzzle is untouched */
        CHECK(session_ad0_object(x.b)->active == 1);
        scene_resource_close(bad_scene);
    }
    /* a failing release during the next scene's clear is a host error and keeps the old rows */
    x.f.fail_call = 1;
    x.f.calls = 0;
    CHECK(session_ad0_begin_scene(x.b, x.scene) == D0_ERR_HOST && strcmp(session_ad0_failure(x.b), "0xd0-scene-clear") == 0);
    CHECK(session_ad0_object(x.b)->active == 1 && session_ad0_object(x.b)->surface == 77u);
    x.f.fail_call = 0;
    scene_resource_close(x.scene);
    x.f.log[0] = '\0';
    session_ad0_destroy(x.b);
    CHECK(strstr(x.f.log, "relsurf:77:0") != NULL);
}

static void t_binding_host_error_maps_to_error(void)
{
    Bind x;
    uint32_t ph = 0u;
    int done = 0;
    D0ClickResult c;
    D0PointerResult p;
    if (!bind_open(&x)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_ad0_begin_scene(x.b, x.scene) == D0_OK);
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    CHECK(session_ad0_pointer_move(x.b, 4, 4, &p) == D0_OK && p.hit == 1u);
    /* the sound play fails: the click reports it and says so */
    x.f.fail_call = 3;
    x.f.calls = 0;
    CHECK(session_ad0_click(x.b, 1u, D0_CANDIDATE_KEY, 1, &c) == D0_ERR_HOST);
    CHECK(strcmp(session_ad0_failure(x.b), "0xd0-click") == 0);
    CHECK(session_ad0_object(x.b)->pressed == 1u);
    /* the finish fails at its first release: a handler error with the kernel's text, the generic completion is not reported */
    x.f.fail_call = 1;
    x.f.calls = 0;
    CHECK(b_visit(&x, 1, 2u, &ph, &done) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(strcmp(session_ad0_failure(x.b), "0xd0-host") == 0);
    CHECK(session_ad0_object(x.b)->active == 1 && g_world_stores == 1);
    /* a render whose view origin fails is an error, not a blit */
    {
        D0RenderResult r;
        D0Object *o = (D0Object *)session_ad0_object(x.b);
        o->dirty = 1;
        o->pressed = 1;
        o->hover = 1;
        x.f.fail_call = 1;
        x.f.calls = 0;
        CHECK(session_ad0_render(x.b, &r) == D0_ERR_HOST);
        x.f.fail_call = 2;
        x.f.calls = 0;
        CHECK(session_ad0_invalidate(x.b) == D0_OK); /* only one host call: the second would be the failing one */
    }
    x.f.fail_call = 0;
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
    run("object_reset", t_reset);
    run("phase0_surface", t_phase0_surface);
    run("phase0_no_surface", t_phase0_no_surface);
    run("step_refusals", t_step_refusals);
    run("phase12_need_phase0", t_phase12_need_phase0);
    run("state_release", t_state_release);
    run("state_idle_solved_check", t_state_idle_solved_check);
    run("state_start_win", t_state_start_win);
    run("state_wait_win", t_state_wait_win);
    run("state_win_sound", t_state_win_sound);
    run("phase2_blocks", t_phase2_blocks);
    run("phase2_flag_refused", t_phase2_flag_refused);
    run("pointer_inactive_and_args", t_pointer_inactive_and_args);
    run("pointer_keys", t_pointer_keys);
    run("pointer_overlap_and_coordinates", t_pointer_overlap_and_coordinates);
    run("pointer_exit", t_pointer_exit);
    run("pointer_pressed", t_pointer_pressed);
    run("click_key", t_click_key);
    run("click_window", t_click_window);
    run("click_gating", t_click_gating);
    run("click_text_limits", t_click_text_limits);
    run("render", t_render);
    run("invalidate", t_invalidate);
    run("cleanup", t_cleanup);
    run("host_failure_sweep", t_host_failure_sweep);
    run("host_failure_effects", t_host_failure_effects);
    run("playthrough_solved", t_playthrough_solved);
    run("playthrough_without_surface", t_playthrough_without_surface);
    run("playthrough_exit", t_playthrough_exit);
    run("binding_flow", t_binding_flow);
    run("binding_solved_by_clicks", t_binding_solved_by_clicks);
    run("binding_scene_change_clears", t_binding_scene_change_clears);
    run("binding_refuses_bad_body", t_binding_refuses_bad_body);
    run("binding_host_error", t_binding_host_error_maps_to_error);
    printf("TOTAL %d FAILED %d\n", g_total, g_failures);
    return g_failures;
}
