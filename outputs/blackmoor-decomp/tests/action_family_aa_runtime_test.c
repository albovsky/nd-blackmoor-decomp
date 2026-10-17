/* RT-52 unit tests of the raw 0xaa Alarm Clock kernel (src/action_family_aa_runtime.c) and its session binding
 * (src/session_bindings_aaa.c). Prints "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure count.
 * Fixtures are synthetic bodies (no original bytes). tests/test_action_family_aa_runtime.py builds and runs this with and
 * without ASan/UBSan and under source mutations. */
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_aa_runtime.h"
#include "scene_resource.h"
#include "session_bindings_aaa.h"

static int g_failed, g_total, g_failures;
static char g_msg[512];
#define CHECK(cond)                                                        \
    do {                                                                   \
        if (!(cond) && !g_failed) {                                        \
            g_failed = 1;                                                  \
            snprintf(g_msg, sizeof g_msg, "line %d: %.200s", __LINE__, #cond); \
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
    CB_ALLOC = 1, CB_REGISTER, CB_LOAD, CB_SETSURF, CB_RELSURF, CB_RELSLOT, CB_DIRTY, CB_ORIGIN, CB_PREPARE, CB_STOP,
    CB_PLAY, CB_BUSY, CB_IDLE, CB_TRANSITION, CB_STOREFLAG, CB_LAST = CB_STOREFLAG
};

typedef struct Fx {
    AlcObject o;
    AlcWorld world;
    AlcHost host;
    uint8_t body[ALC_BODY_BYTES];
    char log[8192];
    uint32_t now;
    int32_t busy_value;
    int32_t vx, vy;
    int fail_call, calls, failed_cb, sweep_n;
    unsigned failed_mask;
    int n_prepare, n_stop, n_play, n_dirty, n_origin, n_alloc, n_idle, n_relsurf, n_relslot;
    int16_t dirty_slot, setsurf_slot, played_channel;
    uint32_t setsurf_surface;
    const uint8_t *prepare_ptr, *stop_ptr;
    char registered_label[40], loaded_name[40];
    uint32_t phase;
    int completed, initialized;
    const char *failure;
} Fx;

static void put16(uint8_t *b, size_t off, int v) { b[off] = (uint8_t)v; b[off + 1] = (uint8_t)(v >> 8); }
static int32_t rd32(const uint8_t *b, size_t off)
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

static const char *const effect_names[] = {"?", "start", "slot", "slotreg", "load", "slotsurf", "phase", "prep", "stop",
                                           "play", "busy", "tick", "x57b", "x599", "x595", "x39ff", "x59b", "x59f",
                                           "x5a3", "mode", "evflag", "complete", "relsurf", "relslot", "idle",
                                           "hourst", "minst", "blit"};

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
    if (fail_hit(f, CB_LOAD) || strcmp(name, "CLOCK") != 0) return 1;
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
static int h_origin(void *c, int32_t *x, int32_t *y)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_ORIGIN)) return 1;
    ++f->n_origin;
    *x = f->vx;
    *y = f->vy;
    return 0;
}
static int h_prepare(void *c, const uint8_t *r)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_PREPARE)) return 1;
    ++f->n_prepare;
    f->prepare_ptr = r;
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
static int h_idle(void *c)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_IDLE)) return 1;
    ++f->n_idle;
    return 0;
}
static int h_flag_invalid(void *c, int16_t i) { (void)c; return i < 0 || i >= 100; }
static int h_transition(void *c, const AlcTransition *t)
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

/* Body offsets used by the tests (the header describes the layout). */
enum {
    O_MINUTE_DST = 0x21, O_HOUR_DST = 0x31, O_AMPM_DST = 0x41, O_TIME_BTN = 0x51, O_ALARM_BTN = 0x61, O_SET_BTN = 0x71,
    O_CANCEL_BTN = 0x81, O_INCREASE_BTN = 0x91, O_DECREASE_BTN = 0xa1, O_LIGHT_DST = 0xb1, O_MINUTE_SRC = 0xc1,
    O_HOUR_SRC = 0x101, O_AM_SRC = 0x1c1, O_PM_SRC = 0x1d1, O_TIME_DOWN = 0x1e1, O_ALARM_DOWN = 0x1f1, O_SET_DOWN = 0x201,
    O_CANCEL_DOWN = 0x211, O_INCREASE_DOWN = 0x221, O_DECREASE_DOWN = 0x231, O_TIME_LIGHT = 0x241, O_ALARM_LIGHT = 0x251,
    O_DELAY = 0x261, O_CURSOR = 0x263, O_BSOUND = 0x265, O_BCHAN = 0x286, O_SETBLK = 0x296, O_FDELAY = 0x2af,
    O_FSOUND = 0x2b1, O_FCHAN = 0x2d2, O_CANBLK = 0x2e2
};

/* Body: clock image "CLOCK". Geometry (view relative, inclusive): time button (0,0,9,9), alarm button (10,0,19,9), set button
 * (20,0,29,9), cancel button (30,0,39,19), decrease button (40,0,49,9), increase button (50,0,59,9); minute digit destination
 * (0,10,9,19), hour digit destination (10,10,19,19), light destination (20,10,29,19), AM/PM destination (40,10,49,19). The pointer
 * bounds are therefore x 0..59 and y <= 19. Press delay 5 (500 ms), cursor kind 7, button sound "BTNSND" on channel 4; set block
 * scene 40 (start word 1, event flag 7 := 3), delay 2 s, final sound "FINSND" on channel 9; cancel block scene 50 (start word 0,
 * flag 8 := 9). */
static void body_init(uint8_t *b)
{
    memset(b, 0, ALC_BODY_BYTES);
    set_str(b, 0, "CLOCK");
    put_rect(b, O_TIME_BTN, 0, 0, 9, 9);
    put_rect(b, O_ALARM_BTN, 10, 0, 19, 9);
    put_rect(b, O_SET_BTN, 20, 0, 29, 9);
    put_rect(b, O_CANCEL_BTN, 30, 0, 39, 19);
    put_rect(b, O_DECREASE_BTN, 40, 0, 49, 9);
    put_rect(b, O_INCREASE_BTN, 50, 0, 59, 9);
    put_rect(b, O_MINUTE_DST, 0, 10, 9, 19);
    put_rect(b, O_HOUR_DST, 10, 10, 19, 19);
    put_rect(b, O_LIGHT_DST, 20, 10, 29, 19);
    put_rect(b, O_AMPM_DST, 40, 10, 49, 19);
    put16(b, O_DELAY, 5);
    put16(b, O_CURSOR, 7);
    set_str(b, O_BSOUND, "BTNSND");
    put16(b, O_BCHAN, 4);
    set_block(b, O_SETBLK, 40, 1, 2, 3, 11, 22, 33, 1, 7, 3);
    put16(b, O_FDELAY, 2);
    set_str(b, O_FSOUND, "FINSND");
    put16(b, O_FCHAN, 9);
    set_block(b, O_CANBLK, 50, 4, 5, 6, 44, 55, 66, 0, 8, 9);
}

/* Every rectangle of the body (0x21..0x251, 36 of them) gets values that name its offset: (off, off+1000, off+2000, off+3000). */
static void body_stamp(uint8_t *b)
{
    for (int off = 0x21; off <= 0x251; off += 0x10) put_rect(b, (size_t)off, off, off + 1000, off + 2000, off + 3000);
}

static void fx_init(Fx *f)
{
    memset(f, 0, sizeof(*f));
    alc_object_reset(&f->o);
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
    f->host.touch_idle_timer = h_idle;
    f->host.event_flag_invalid = h_flag_invalid;
    f->host.transition = h_transition;
    f->host.store_event_flag = h_store_flag;
    f->host.observe = observe;
    f->now = 1000u;
    f->vx = 10;
    f->vy = 20;
    f->world.hour_585d51 = 10;
    f->world.minute_585d4f = 20;
    body_init(f->body);
}

static int visit(Fx *f, int16_t row, uint32_t phase)
{
    AlcResult r;
    const char *why = "stale"; /* the kernel must clear both */
    int rc;
    memset(&r, 0x5a, sizeof r);
    rc = alc_step(&f->o, f->body, ALC_BODY_BYTES, row, phase, &f->world, &f->host, &r, &why);
    f->phase = r.phase_after;
    f->completed = r.completed;
    f->initialized = r.initialized;
    f->failure = why;
    return rc;
}
static int pointer(Fx *f, int32_t x, int32_t y, AlcPointerResult *p)
{
    return alc_pointer(&f->o, f->body, ALC_BODY_BYTES, x, y, p);
}
static int click(Fx *f, uint32_t row_phase, AlcClickResult *c)
{
    return alc_click(&f->o, f->body, ALC_BODY_BYTES, row_phase, &f->world, &f->host, c);
}
static int render(Fx *f, AlcRenderResult *r) { return alc_render(&f->o, f->body, ALC_BODY_BYTES, &f->host, r); }

/* The object as phase 0 leaves it for row 3, without issuing the effects. */
static void make_active(Fx *f, int16_t row)
{
    f->o.row = row;
    f->o.active = 1;
    f->o.slot = 24;
    f->o.surface = 77u;
}

#define LOGCLR(f) ((f)->log[0] = '\0')

/* ---- body validation ---------------------------------------------------------------------------------------------------- */

static void t_validate(void)
{
    uint8_t b[ALC_BODY_BYTES + 8];
    const char *why = NULL;
    body_init(b);
    CHECK(alc_validate_body(b, ALC_BODY_BYTES, &why) == ALC_OK && why == NULL);
    CHECK(alc_validate_body(b, ALC_BODY_BYTES, NULL) == ALC_OK);
    CHECK(alc_validate_body(NULL, ALC_BODY_BYTES, &why) == ALC_ERR_BODY && strcmp(why, "0xaa-body-length") == 0);
    CHECK(alc_validate_body(b, ALC_BODY_BYTES - 1u, &why) == ALC_ERR_BODY && strcmp(why, "0xaa-body-length") == 0);
    CHECK(alc_validate_body(b, ALC_BODY_BYTES + 1u, &why) == ALC_ERR_BODY && strcmp(why, "0xaa-body-length") == 0);
    CHECK(alc_validate_body(b, 0u, NULL) == ALC_ERR_BODY);
    /* the name: 0x21 bytes, the terminator may be the last one; the byte after it does not count */
    memset(b, 'A', ALC_NAME_BYTES);
    b[ALC_NAME_BYTES] = 0;
    CHECK(alc_validate_body(b, ALC_BODY_BYTES, &why) == ALC_ERR_BODY && strcmp(why, "0xaa-name-unterminated") == 0);
    b[ALC_NAME_BYTES - 1u] = 0;
    CHECK(alc_validate_body(b, ALC_BODY_BYTES, &why) == ALC_OK && why == NULL);
    body_init(b);
    memset(b, 'A', ALC_NAME_BYTES);
    b[ALC_NAME_BYTES] = 'B'; /* nothing terminates the name inside the 0x21 bytes */
    CHECK(alc_validate_body(b, ALC_BODY_BYTES, &why) == ALC_ERR_BODY && strcmp(why, "0xaa-name-unterminated") == 0);
    /* the button sound name at 0x265 */
    body_init(b);
    memset(b + O_BSOUND, 'S', ALC_NAME_BYTES);
    b[O_BSOUND + ALC_NAME_BYTES] = 0;
    CHECK(alc_validate_body(b, ALC_BODY_BYTES, &why) == ALC_ERR_BODY && strcmp(why, "0xaa-button-sound-unterminated") == 0);
    b[O_BSOUND + ALC_NAME_BYTES - 1u] = 0;
    CHECK(alc_validate_body(b, ALC_BODY_BYTES, &why) == ALC_OK);
    /* the final sound name at 0x2b1 */
    body_init(b);
    memset(b + O_FSOUND, 'S', ALC_NAME_BYTES);
    b[O_FSOUND + ALC_NAME_BYTES] = 0;
    CHECK(alc_validate_body(b, ALC_BODY_BYTES, &why) == ALC_ERR_BODY && strcmp(why, "0xaa-final-sound-unterminated") == 0);
    b[O_FSOUND + ALC_NAME_BYTES - 1u] = 0;
    CHECK(alc_validate_body(b, ALC_BODY_BYTES, &why) == ALC_OK);
    /* a bad button sound is reported before a bad final sound; a bad name before both */
    body_init(b);
    memset(b + O_BSOUND, 'S', ALC_NAME_BYTES);
    memset(b + O_FSOUND, 'S', ALC_NAME_BYTES);
    CHECK(alc_validate_body(b, ALC_BODY_BYTES, &why) == ALC_ERR_BODY && strcmp(why, "0xaa-button-sound-unterminated") == 0);
    memset(b, 'A', ALC_NAME_BYTES);
    CHECK(alc_validate_body(b, ALC_BODY_BYTES, &why) == ALC_ERR_BODY && strcmp(why, "0xaa-name-unterminated") == 0);
}

static void t_reset(void)
{
    AlcObject o;
    memset(&o, 0xa5, sizeof o);
    alc_object_reset(&o);
    CHECK(o.slot == -1 && o.row == -1 && o.surface == 0u && o.dirty == 0u && o.active == 0 && o.over == 0 && o.state == 0 &&
          o.button == 0 && o.time_hour == 0 && o.time_quarter == 0 && o.time_am == 0 && o.alarm_hour == 0 &&
          o.alarm_quarter == 0 && o.alarm_am == 0 && o.restore == 0 && o.canceled == 0u && o.set == 0u &&
          o.press_deadline == 0u && o.final_deadline == 0u);
}

/* ---- the displayed time (0x44d711) and the hour step (0x44d8ad) --------------------------------------------------------- */

static void t_time_reader(void)
{
    Fx f;
    int checked = 0;
    for (int hour = 0; hour <= 24; ++hour) {
        for (int minute = 0; minute < 60; ++minute) {
            const int idx = (hour + 11) % 12, am = hour < 12 || hour == 24;
            const int q = minute <= 15 ? 0 : (minute <= 30 ? 1 : (minute <= 45 ? 2 : 3));
            int ah = idx, aq = q, aam = am;
            if (q > 0) {
                ah = (idx + 1) % 12;
                aq = 0;
                if (ah == 11) aam = !am;
            }
            fx_init(&f);
            f.o.time_quarter = (int16_t)((q + 2) % 4); /* a minute that no branch matches would keep this wrong value */
            f.world.hour_585d51 = (int16_t)hour;
            f.world.minute_585d4f = (int16_t)minute;
            if (visit(&f, 3, 0u) != ALC_OK) {
                CHECK(0 && "phase 0");
                return;
            }
            if (f.o.time_hour != idx || f.o.time_quarter != q || (f.o.time_am != 0) != am || f.o.alarm_hour != ah ||
                f.o.alarm_quarter != aq || (f.o.alarm_am != 0) != aam) {
                snprintf(g_msg, sizeof g_msg, "time reader differs at %d:%02d", hour, minute);
                g_failed = 1;
                return;
            }
            ++checked;
        }
    }
    CHECK(checked == 25 * 60);
    /* the value stored for AM is 1, for PM 0 */
    fx_init(&f);
    f.world.hour_585d51 = 9;
    CHECK(visit(&f, 3, 0u) == ALC_OK && f.o.time_am == 1 && f.o.alarm_am == 1);
    fx_init(&f);
    f.world.hour_585d51 = 15;
    CHECK(visit(&f, 3, 0u) == ALC_OK && f.o.time_am == 0 && f.o.alarm_am == 0);
    /* a minute outside 0..59 leaves the quarter alone (no branch of 0x44d711 matches) */
    for (int m = -1; m <= 60; m += 61) {
        fx_init(&f);
        f.o.time_quarter = 2;
        f.world.minute_585d4f = (int16_t)m;
        CHECK(visit(&f, 3, 0u) == ALC_OK && f.o.time_quarter == 2);
    }
    /* the word is signed: 0xffff is -1 */
    fx_init(&f);
    f.o.time_quarter = 2;
    f.world.minute_585d4f = (int16_t)0xffff;
    CHECK(visit(&f, 3, 0u) == ALC_OK && f.o.time_quarter == 2);
}

static void t_hour_step(void)
{
    Fx f;
    for (int dir = 0; dir < 2; ++dir) {
        for (int am = 0; am < 2; ++am) {
            for (int h = 0; h < 12; ++h) {
                int nh, nam = am;
                fx_init(&f);
                make_active(&f, 3);
                f.o.state = dir == 0 ? ALC_STATE_INCREASE : ALC_STATE_DECREASE;
                f.o.alarm_hour = (int16_t)h;
                f.o.alarm_am = am;
                f.o.alarm_quarter = 2;
                f.o.dirty = 0;
                if (dir == 0) {
                    nh = (h + 1) % 12;
                    if (h == 10 || h == 11) nam = h == 10 ? !am : am;
                } else {
                    nh = h == 0 ? 11 : h - 1;
                    if (h == 11) nam = !am;
                }
                if (visit(&f, 3, 1u) != ALC_OK || f.o.alarm_hour != nh || (f.o.alarm_am != 0) != nam ||
                    f.o.state != ALC_STATE_ALARM || f.o.dirty != 1u || f.o.alarm_quarter != 2 || f.phase != 1u ||
                    f.log[0] != '\0') {
                    snprintf(g_msg, sizeof g_msg, "hour step dir %d am %d hour %d", dir, am, h);
                    g_failed = 1;
                    return;
                }
            }
        }
    }
}

/* ---- phase 0 ------------------------------------------------------------------------------------------------------------ */

static void t_phase0(void)
{
    Fx f;
    fx_init(&f);
    f.o.dirty = 0;
    f.o.restore = 1;
    f.o.state = 5;
    f.o.over = 1;
    f.o.set = 1;
    f.o.canceled = 1;
    f.world.start_flag_5bb1ca = 0;
    CHECK(visit(&f, 3, 0u) == ALC_OK && f.initialized == 1 && f.completed == 0 && f.phase == 1u);
    CHECK_LOG(&f, "start:1:0,slot:24:0,slotreg:24:0,load:77:0,slotsurf:24:77,prep:613:0,phase:1:0");
    CHECK(f.o.row == 3 && f.o.active == 1 && f.o.dirty == 1u && f.o.restore == 0 && f.o.state == 0 && f.o.over == 0 &&
          f.o.set == 0u && f.o.canceled == 0u && f.o.slot == 24 && f.o.surface == 77u);
    CHECK(f.world.start_flag_5bb1ca == 1);
    CHECK(strcmp(f.registered_label, "ALARM CLOCK OVERLAYS") == 0 && strcmp(f.loaded_name, "CLOCK") == 0);
    CHECK(f.setsurf_slot == 24 && f.setsurf_surface == 77u);
    CHECK(f.prepare_ptr == f.body + O_BSOUND && f.n_prepare == 1);
    CHECK(f.failure == NULL);
    /* an existing surface is not loaded again; the entry gets that handle */
    fx_init(&f);
    f.o.surface = 88u;
    CHECK(visit(&f, 0, 0u) == ALC_OK && f.phase == 1u);
    CHECK_LOG(&f, "start:1:0,slot:24:0,slotreg:24:0,slotsurf:24:88,prep:613:0,phase:1:0");
    CHECK(f.setsurf_surface == 88u && f.o.row == 0 && f.o.surface == 88u);
    /* "NO SOUND" button sound: no prepare; only the first 9 bytes decide */
    fx_init(&f);
    set_str(f.body, O_BSOUND, "NO SOUND");
    CHECK(visit(&f, 3, 0u) == ALC_OK);
    CHECK_LOG(&f, "start:1:0,slot:24:0,slotreg:24:0,load:77:0,slotsurf:24:77,phase:1:0");
    CHECK(f.n_prepare == 0);
    fx_init(&f);
    set_str(f.body, O_BSOUND, "NO SOUNDS");
    CHECK(visit(&f, 3, 0u) == ALC_OK && f.n_prepare == 1);
    fx_init(&f);
    set_str(f.body, O_BSOUND, "NO SOUN");
    CHECK(visit(&f, 3, 0u) == ALC_OK && f.n_prepare == 1);
    fx_init(&f);
    set_str(f.body, O_BSOUND, "no sound");
    CHECK(visit(&f, 3, 0u) == ALC_OK && f.n_prepare == 1);
    /* the surface name is passed as it stands (no empty-name test) */
    fx_init(&f);
    f.body[0] = 0;
    CHECK(visit(&f, 3, 0u) == ALC_ERR_HOST); /* the fixture only loads "CLOCK" */
    CHECK(strcmp(f.failure, "0xaa-host") == 0);
    /* the slot that came back is stored whatever it is */
    fx_init(&f);
    f.n_alloc = 5;
    CHECK(visit(&f, 3, 0u) == ALC_OK && f.o.slot == 0x1d && f.setsurf_slot == 0x1d);
}

static void t_step_args(void)
{
    Fx f;
    AlcResult r;
    const char *why = NULL;
    uint8_t shortbody[ALC_BODY_BYTES];
    memset(shortbody, 0, sizeof shortbody);
    fx_init(&f);
    CHECK(alc_step(NULL, f.body, ALC_BODY_BYTES, 3, 0u, &f.world, &f.host, &r, &why) == ALC_ERR_ARGUMENT);
    CHECK(alc_step(&f.o, NULL, ALC_BODY_BYTES, 3, 0u, &f.world, &f.host, &r, &why) == ALC_ERR_ARGUMENT);
    CHECK(alc_step(&f.o, f.body, ALC_BODY_BYTES, 3, 0u, NULL, &f.host, &r, &why) == ALC_ERR_ARGUMENT);
    CHECK(alc_step(&f.o, f.body, ALC_BODY_BYTES, 3, 0u, &f.world, NULL, &r, &why) == ALC_ERR_ARGUMENT);
    CHECK(alc_step(&f.o, f.body, ALC_BODY_BYTES, 3, 0u, &f.world, &f.host, NULL, &why) == ALC_ERR_ARGUMENT);
    CHECK(alc_step(&f.o, f.body, ALC_BODY_BYTES, 3, 0u, &f.world, &f.host, &r, NULL) == ALC_OK);
    CHECK(strcmp(why, "x") != 0 || 1);
    why = "set";
    CHECK(alc_step(NULL, f.body, ALC_BODY_BYTES, 3, 0u, &f.world, &f.host, &r, &why) == ALC_ERR_ARGUMENT &&
          strcmp(why, "0xaa-argument") == 0);
    CHECK(f.log[0] != '\0'); /* the NULL-failure call above did run phase 0 */
    /* every callback but the observer is required */
    {
        void **slots[17];
        AlcHost h;
        size_t n = 0;
        fx_init(&f);
        h = f.host;
        slots[n++] = (void **)&h.alloc_slot;
        slots[n++] = (void **)&h.register_slot;
        slots[n++] = (void **)&h.load_surface;
        slots[n++] = (void **)&h.set_slot_surface;
        slots[n++] = (void **)&h.release_surface;
        slots[n++] = (void **)&h.release_slot;
        slots[n++] = (void **)&h.mark_dirty;
        slots[n++] = (void **)&h.view_origin;
        slots[n++] = (void **)&h.sound_prepare;
        slots[n++] = (void **)&h.sound_stop;
        slots[n++] = (void **)&h.sound_play;
        slots[n++] = (void **)&h.sound_busy;
        slots[n++] = (void **)&h.tick;
        slots[n++] = (void **)&h.touch_idle_timer;
        slots[n++] = (void **)&h.event_flag_invalid;
        slots[n++] = (void **)&h.transition;
        slots[n++] = (void **)&h.store_event_flag;
        for (size_t i = 0; i < n; ++i) {
            AlcHost copy = f.host;
            AlcClickResult cr;
            AlcRenderResult rr;
            void **slot = (void **)((char *)&copy + ((char *)slots[i] - (char *)&h));
            *slot = NULL;
            make_active(&f, 3);
            LOGCLR(&f);
            CHECK(alc_step(&f.o, f.body, ALC_BODY_BYTES, 3, 0u, &f.world, &copy, &r, &why) == ALC_ERR_ARGUMENT);
            CHECK(alc_click(&f.o, f.body, ALC_BODY_BYTES, 1u, &f.world, &copy, &cr) == ALC_ERR_ARGUMENT);
            CHECK(alc_render(&f.o, f.body, ALC_BODY_BYTES, &copy, &rr) == ALC_ERR_ARGUMENT);
            CHECK(f.log[0] == '\0');
        }
        f.host.observe = NULL; /* the observer is optional */
        CHECK(visit(&f, 3, 0u) == ALC_OK);
    }
    /* a bad body is refused before any effect, in every phase */
    fx_init(&f);
    memset(f.body, 'A', ALC_NAME_BYTES);
    for (uint32_t phase = 0u; phase < 4u; ++phase) {
        CHECK(visit(&f, 3, phase) == ALC_ERR_BODY && strcmp(f.failure, "0xaa-name-unterminated") == 0);
        CHECK(f.log[0] == '\0' && f.phase == phase && f.initialized == 0 && f.completed == 0 && f.o.active == 0);
    }
    fx_init(&f);
    CHECK(alc_step(&f.o, shortbody, ALC_BODY_BYTES - 1u, 3, 0u, &f.world, &f.host, &r, &why) == ALC_ERR_BODY &&
          strcmp(why, "0xaa-body-length") == 0 && r.phase_after == 0u);
    /* a negative row cannot start */
    fx_init(&f);
    CHECK(visit(&f, -1, 0u) == ALC_ERR_ARGUMENT && strcmp(f.failure, "0xaa-row") == 0 && f.log[0] == '\0');
    CHECK(visit(&f, 0, 0u) == ALC_OK && f.o.row == 0);
    /* any other phase does nothing */
    fx_init(&f);
    make_active(&f, 3);
    f.o.state = ALC_STATE_INCREASE;
    CHECK(visit(&f, 3, 3u) == ALC_OK && f.phase == 3u && f.log[0] == '\0' && f.o.state == ALC_STATE_INCREASE);
    CHECK(visit(&f, 3, 0xffffffffu) == ALC_OK && f.phase == 0xffffffffu && f.log[0] == '\0');
    CHECK(f.failure == NULL);
}

static void t_phase12_need_phase0(void)
{
    Fx f;
    for (uint32_t phase = 1u; phase <= 2u; ++phase) {
        const char *want = phase == 1u ? "0xaa-phase-1-without-init" : "0xaa-phase-2-without-init";
        fx_init(&f);
        CHECK(visit(&f, 3, phase) == ALC_ERR_UNSUPPORTED && strcmp(f.failure, want) == 0 && f.log[0] == '\0');
        CHECK(f.phase == phase && f.initialized == 0 && f.completed == 0);
        /* initialised for another row */
        make_active(&f, 4);
        CHECK(visit(&f, 3, phase) == ALC_ERR_UNSUPPORTED && strcmp(f.failure, want) == 0 && f.log[0] == '\0');
        /* the right row but inactive */
        make_active(&f, 3);
        f.o.active = 0;
        CHECK(visit(&f, 3, phase) == ALC_ERR_UNSUPPORTED && f.log[0] == '\0');
        f.o.active = 1;
        CHECK(visit(&f, 3, phase) == ALC_OK);
    }
}

/* ---- phase 1 (the state machine on obj+0x2d) ---------------------------------------------------------------------------- */

static void t_state_cancel_idle(void)
{
    Fx f;
    fx_init(&f);
    make_active(&f, 3);
    f.o.state = ALC_STATE_CANCEL;
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.phase == 2u && f.o.canceled == 1u && f.o.state == ALC_STATE_CANCEL);
    CHECK_LOG(&f, "phase:2:0");
    for (int s = 0; s < 2; ++s) {
        fx_init(&f);
        make_active(&f, 3);
        f.o.state = s;
        f.o.dirty = 0;
        CHECK(visit(&f, 3, 1u) == ALC_OK && f.phase == 1u && f.o.dirty == 1u && f.o.state == s && f.log[0] == '\0');
    }
    /* states above 8 and negative ones do nothing */
    {
        const int32_t odd[] = {9, 10, 100, -1, 0x7fffffff};
        for (size_t i = 0; i < sizeof odd / sizeof odd[0]; ++i) {
            fx_init(&f);
            make_active(&f, 3);
            f.o.state = odd[i];
            f.o.dirty = 0;
            CHECK(visit(&f, 3, 1u) == ALC_OK && f.phase == 1u && f.o.dirty == 0u && f.o.state == odd[i] && f.log[0] == '\0');
            CHECK(f.o.canceled == 0u && f.o.set == 0u && f.o.restore == 0);
        }
    }
}

static void t_state_pressed(void)
{
    Fx f;
    const int buttons[] = {0, 1, 3, 4, 6, 8};
    for (size_t i = 0; i < sizeof buttons / sizeof buttons[0]; ++i) {
        fx_init(&f);
        make_active(&f, 3);
        f.o.state = ALC_STATE_PRESSED;
        f.o.button = buttons[i];
        f.o.press_deadline = 5000u;
        f.now = 4999u;
        CHECK(visit(&f, 3, 1u) == ALC_OK && f.o.state == ALC_STATE_PRESSED && f.o.restore == 0 && f.phase == 1u);
        CHECK_LOG(&f, "tick:4999:0");
        LOGCLR(&f);
        f.now = 5000u;
        CHECK(visit(&f, 3, 1u) == ALC_OK && f.o.state == buttons[i] && f.o.restore == 1 && f.phase == 1u);
        CHECK_LOG(&f, "tick:5000:0");
    }
    fx_init(&f);
    make_active(&f, 3);
    f.o.state = ALC_STATE_PRESSED;
    f.o.button = 3;
    f.o.press_deadline = 5000u;
    f.now = 90000u;
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.o.state == 3 && f.o.restore == 1);
    /* unsigned compare: a deadline above 0x80000000 is still in the future for a small tick */
    fx_init(&f);
    make_active(&f, 3);
    f.o.state = ALC_STATE_PRESSED;
    f.o.button = 3;
    f.o.press_deadline = 0x90000000u;
    f.now = 5u;
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.o.state == ALC_STATE_PRESSED);
    f.now = 0x90000000u;
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.o.state == 3);
}

static void t_state_set_and_wait(void)
{
    Fx f;
    int16_t delays[] = {2, 0, -1, 300, 0x7fff};
    for (size_t i = 0; i < sizeof delays / sizeof delays[0]; ++i) {
        fx_init(&f);
        make_active(&f, 3);
        put16(f.body, O_FDELAY, delays[i]);
        f.o.state = ALC_STATE_SET;
        f.now = 10000u;
        CHECK(visit(&f, 3, 1u) == ALC_OK && f.phase == 1u);
        CHECK(f.o.state == ALC_STATE_WAIT_SET && f.o.set == 1u && f.o.canceled == 0u);
        CHECK(f.o.final_deadline == 10000u + (uint32_t)((int32_t)delays[i] * 1000));
        CHECK_LOG(&f, "tick:10000:0");
    }
    /* waiting: before the deadline nothing; at it the final sound is prepared and played on its channel */
    fx_init(&f);
    make_active(&f, 3);
    f.o.state = ALC_STATE_WAIT_SET;
    f.o.set = 1u;
    f.o.final_deadline = 12000u;
    f.now = 11999u;
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.phase == 1u && f.o.state == ALC_STATE_WAIT_SET);
    CHECK_LOG(&f, "tick:11999:0");
    LOGCLR(&f);
    f.now = 12000u;
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.phase == 1u && f.o.state == ALC_STATE_FINAL_SOUND);
    CHECK_LOG(&f, "tick:12000:0,prep:689:0,play:9:0");
    CHECK(f.prepare_ptr == f.body + O_FSOUND && f.played_channel == 9 && f.n_play == 1);
    LOGCLR(&f);
    f.o.state = ALC_STATE_WAIT_SET;
    f.now = 99999u;
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.o.state == ALC_STATE_FINAL_SOUND && f.n_play == 2);
    /* unsigned compare */
    fx_init(&f);
    make_active(&f, 3);
    f.o.state = ALC_STATE_WAIT_SET;
    f.o.final_deadline = 0x90000000u;
    f.now = 5u;
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.o.state == ALC_STATE_WAIT_SET && f.n_play == 0);
    /* no final sound: the wait ends the clock; the state stays */
    fx_init(&f);
    make_active(&f, 3);
    set_str(f.body, O_FSOUND, "NO SOUND");
    f.o.state = ALC_STATE_WAIT_SET;
    f.o.final_deadline = 12000u;
    f.now = 11999u;
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.phase == 1u);
    f.now = 12000u;
    LOGCLR(&f);
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.phase == 2u && f.o.state == ALC_STATE_WAIT_SET && f.n_play == 0 && f.n_prepare == 0);
    CHECK_LOG(&f, "tick:12000:0,phase:2:0");
    /* the same record test only looks at the first 9 bytes */
    fx_init(&f);
    make_active(&f, 3);
    set_str(f.body, O_FSOUND, "NO SOUNDX");
    f.o.state = ALC_STATE_WAIT_SET;
    f.o.final_deadline = 0u;
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.phase == 1u && f.o.state == ALC_STATE_FINAL_SOUND);
}

static void t_state_final_sound(void)
{
    Fx f;
    fx_init(&f);
    make_active(&f, 3);
    f.o.state = ALC_STATE_FINAL_SOUND;
    f.busy_value = 1;
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.phase == 1u && f.n_stop == 0 && f.o.state == ALC_STATE_FINAL_SOUND);
    CHECK_LOG(&f, "busy:9:1");
    f.busy_value = 7;
    LOGCLR(&f);
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.phase == 1u && f.n_stop == 0);
    CHECK_LOG(&f, "busy:9:7");
    f.busy_value = 0;
    LOGCLR(&f);
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.phase == 2u && f.n_stop == 1 && f.stop_ptr == f.body + O_FSOUND);
    CHECK_LOG(&f, "busy:9:0,stop:689:0,phase:2:0");
    CHECK(f.o.state == ALC_STATE_FINAL_SOUND);
}

/* ---- phase 2 ------------------------------------------------------------------------------------------------------------ */

static void t_phase2_cancel(void)
{
    Fx f;
    fx_init(&f);
    make_active(&f, 3);
    f.o.canceled = 1u;
    f.o.state = ALC_STATE_CANCEL;
    f.world.start_flag_5bb1ca = 0;
    CHECK(visit(&f, 3, 2u) == ALC_OK && f.completed == 1 && f.phase == 0u && f.initialized == 0);
    CHECK_LOG(&f, "start:1:0,stop:613:0,tr:50:4:5:6:44:55:66,x57b:50:0,x599:4:0,x595:5:0,x39ff:6:0,x59b:44:0,x59f:55:0,"
                  "x5a3:66:0,start:1:0,mode:4:0,sf:8:9,evflag:8:9,complete:3:0,relsurf:77:0,relslot:24:0,idle:0:0");
    CHECK(f.world.start_flag_5bb1ca == 1 && f.stop_ptr == f.body + O_BSOUND);
    CHECK(f.o.row == -1 && f.o.slot == -1 && f.o.active == 0 && f.o.canceled == 0u && f.o.set == 0u && f.o.surface == 0u);
    CHECK(f.n_relsurf == 1 && f.n_relslot == 1 && f.n_idle == 1);
    /* canceled wins over set: the cancel block alone, and the clock is not written */
    fx_init(&f);
    make_active(&f, 3);
    f.o.canceled = 1u;
    f.o.set = 1u;
    f.o.alarm_hour = 4;
    f.o.alarm_am = 1;
    CHECK(visit(&f, 3, 2u) == ALC_OK && strstr(f.log, "hourst") == NULL && strstr(f.log, "tr:50:") != NULL &&
          strstr(f.log, "tr:40:") == NULL);
    CHECK(f.world.hour_585d51 == 10 && f.world.minute_585d4f == 20);
}

static void t_phase2_set(void)
{
    Fx f;
    fx_init(&f);
    make_active(&f, 3);
    f.o.set = 1u;
    f.o.alarm_hour = 4;
    f.o.alarm_am = 0;
    f.world.start_flag_5bb1ca = 0;
    CHECK(visit(&f, 3, 2u) == ALC_OK && f.completed == 1 && f.phase == 0u);
    CHECK_LOG(&f, "start:1:0,stop:613:0,hourst:17:0,minst:0:0,tr:40:1:2:3:11:22:33,x57b:40:0,x599:1:0,x595:2:0,x39ff:3:0,"
                  "x59b:11:0,x59f:22:0,x5a3:33:0,start:0:0,mode:4:0,sf:7:3,evflag:7:3,complete:3:0,relsurf:77:0,"
                  "relslot:24:0,idle:0:0");
    CHECK(f.world.start_flag_5bb1ca == 0 && f.world.hour_585d51 == 17 && f.world.minute_585d4f == 0);
    /* neither canceled nor set: only the sound stop, the completion and the cleanup */
    fx_init(&f);
    make_active(&f, 3);
    CHECK(visit(&f, 3, 2u) == ALC_OK && f.completed == 1 && f.phase == 0u);
    CHECK_LOG(&f, "start:1:0,stop:613:0,complete:3:0,relsurf:77:0,relslot:24:0,idle:0:0");
    CHECK(f.world.hour_585d51 == 10 && f.world.minute_585d4f == 20);
    /* no button sound: no stop */
    fx_init(&f);
    make_active(&f, 3);
    set_str(f.body, O_BSOUND, "NO SOUND");
    CHECK(visit(&f, 3, 2u) == ALC_OK);
    CHECK_LOG(&f, "start:1:0,complete:3:0,relsurf:77:0,relslot:24:0,idle:0:0");
    CHECK(f.n_stop == 0);
}

static void t_alarm_writer(void)
{
    Fx f;
    for (int am = 0; am < 2; ++am) {
        for (int h = 0; h < 12; ++h) {
            const int n = h + 1, want = (n % 12) + (am ? 0 : 12);
            fx_init(&f);
            make_active(&f, 3);
            f.o.set = 1u;
            f.o.alarm_hour = (int16_t)h;
            f.o.alarm_am = am;
            f.world.minute_585d4f = 33;
            if (visit(&f, 3, 2u) != ALC_OK || f.world.hour_585d51 != want || f.world.minute_585d4f != 0) {
                snprintf(g_msg, sizeof g_msg, "alarm writer am %d hour %d: got %d", am, h, f.world.hour_585d51);
                g_failed = 1;
                return;
            }
            {
                char expect[32];
                snprintf(expect, sizeof expect, "hourst:%d:0,minst:0:0", want);
                if (strstr(f.log, expect) == NULL) {
                    snprintf(g_msg, sizeof g_msg, "alarm writer log am %d hour %d", am, h);
                    g_failed = 1;
                    return;
                }
            }
        }
    }
    /* any alarm AM value other than zero counts as AM */
    fx_init(&f);
    make_active(&f, 3);
    f.o.set = 1u;
    f.o.alarm_hour = 2;
    f.o.alarm_am = 7;
    CHECK(visit(&f, 3, 2u) == ALC_OK && f.world.hour_585d51 == 3);
}

static void t_blocks(void)
{
    Fx f;
    /* scene 9999: no transition, no start flag change; the event flag store still happens */
    fx_init(&f);
    make_active(&f, 3);
    f.o.canceled = 1u;
    put16(f.body, O_CANBLK, 9999);
    f.world.start_flag_5bb1ca = 5;
    CHECK(visit(&f, 3, 2u) == ALC_OK);
    CHECK_LOG(&f, "start:1:0,stop:613:0,sf:8:9,evflag:8:9,complete:3:0,relsurf:77:0,relslot:24:0,idle:0:0");
    CHECK(f.world.start_flag_5bb1ca == 1);
    /* event flag -1: none; scene still transitions */
    fx_init(&f);
    make_active(&f, 3);
    f.o.canceled = 1u;
    put16(f.body, O_CANBLK + 22, -1);
    CHECK(visit(&f, 3, 2u) == ALC_OK && strstr(f.log, "sf:") == NULL && strstr(f.log, "evflag") == NULL);
    CHECK(strstr(f.log, "mode:4:0") != NULL);
    /* flag 0 is a flag; scene 0 is a scene */
    fx_init(&f);
    make_active(&f, 3);
    f.o.canceled = 1u;
    put16(f.body, O_CANBLK + 22, 0);
    put16(f.body, O_CANBLK, 0);
    CHECK(visit(&f, 3, 2u) == ALC_OK && strstr(f.log, "sf:0:9") != NULL && strstr(f.log, "tr:0:4:5:6:44:55:66") != NULL);
    /* negative scene numbers and words keep their sign; dwords too */
    fx_init(&f);
    make_active(&f, 3);
    f.o.canceled = 1u;
    set_block(f.body, O_CANBLK, -7, -1, -2, -3, -100000, 0x7fffffff, (int32_t)0x80000000, 0, 8, 255);
    CHECK(visit(&f, 3, 2u) == ALC_OK);
    CHECK(strstr(f.log, "tr:-7:-1:-2:-3:-100000:2147483647:-2147483648,x57b:-7:0,x599:-1:0,x595:-2:0,x39ff:-3:0,"
                        "x59b:-100000:0,x59f:2147483647:0,x5a3:-2147483648:0") != NULL);
    CHECK(strstr(f.log, "sf:8:255,evflag:8:255") != NULL); /* the value byte is not signed */
    /* the start word: 1 stores 0, everything else stores 1 */
    {
        const int starts[] = {1, 0, 2, -1, 257, 0x7fff};
        for (size_t i = 0; i < sizeof starts / sizeof starts[0]; ++i) {
            fx_init(&f);
            make_active(&f, 3);
            f.o.canceled = 1u;
            put16(f.body, O_CANBLK + 20, starts[i]);
            f.world.start_flag_5bb1ca = 9;
            CHECK(visit(&f, 3, 2u) == ALC_OK);
            CHECK(f.world.start_flag_5bb1ca == (starts[i] == 1 ? 0 : 1));
        }
    }
    /* the set block reads its own offsets */
    fx_init(&f);
    make_active(&f, 3);
    f.o.set = 1u;
    set_block(f.body, O_SETBLK, 12, 13, 14, 15, 16, 17, 18, 5, 33, 77);
    CHECK(visit(&f, 3, 2u) == ALC_OK);
    CHECK(strstr(f.log, "tr:12:13:14:15:16:17:18") != NULL && strstr(f.log, "start:1:0,mode:4:0,sf:33:77") != NULL);
}

static void t_phase2_flag_refused(void)
{
    Fx f;
    /* an event flag the host cannot store: refused before any effect */
    for (int block = 0; block < 2; ++block) {
        fx_init(&f);
        make_active(&f, 3);
        if (block == 0)
            f.o.canceled = 1u;
        else
            f.o.set = 1u;
        put16(f.body, block == 0 ? O_CANBLK + 22 : O_SETBLK + 22, 100);
        f.world.start_flag_5bb1ca = 3;
        CHECK(visit(&f, 3, 2u) == ALC_ERR_BOUNDS && strcmp(f.failure, "0xaa-event-flag-index") == 0);
        CHECK(f.log[0] == '\0' && f.completed == 0 && f.phase == 2u && f.o.active == 1 && f.world.start_flag_5bb1ca == 3);
        CHECK(f.o.canceled == (block == 0) && f.o.set == (block == 1) && f.o.surface == 77u);
        put16(f.body, block == 0 ? O_CANBLK + 22 : O_SETBLK + 22, 99); /* the last valid index */
        CHECK(visit(&f, 3, 2u) == ALC_OK);
    }
    /* flag -1 is none and is never asked about */
    fx_init(&f);
    make_active(&f, 3);
    f.o.canceled = 1u;
    put16(f.body, O_CANBLK + 22, -1);
    CHECK(visit(&f, 3, 2u) == ALC_OK);
    /* the block that is taken decides: canceled before set */
    fx_init(&f);
    make_active(&f, 3);
    f.o.canceled = 1u;
    f.o.set = 1u;
    put16(f.body, O_SETBLK + 22, 100); /* invalid, but the set block is not used */
    CHECK(visit(&f, 3, 2u) == ALC_OK);
    fx_init(&f);
    make_active(&f, 3);
    f.o.canceled = 1u;
    f.o.set = 1u;
    put16(f.body, O_CANBLK + 22, 100);
    CHECK(visit(&f, 3, 2u) == ALC_ERR_BOUNDS);
    /* neither block taken: the flags of both blocks are ignored */
    fx_init(&f);
    make_active(&f, 3);
    put16(f.body, O_CANBLK + 22, 100);
    put16(f.body, O_SETBLK + 22, 100);
    CHECK(visit(&f, 3, 2u) == ALC_OK);
}

/* ---- the pointer (0x44d28c / 0x44d597) ---------------------------------------------------------------------------------- */

static void expect_none(AlcPointerResult *p)
{
    CHECK(p->hit == 0u && p->candidate == -1 && p->cursor_written == 0u && p->cursor_kind == 0 && p->cursor_sub == 0);
}

static void t_pointer_basics(void)
{
    Fx f;
    AlcPointerResult p;
    fx_init(&f);
    /* inactive: only the redraw request is cleared */
    f.o.dirty = 1;
    f.o.over = 1;
    memset(&p, 0x55, sizeof p);
    CHECK(pointer(&f, 15, 5, &p) == ALC_OK);
    expect_none(&p);
    CHECK(f.o.dirty == 0u && f.o.over == 1);
    /* argument checks */
    CHECK(alc_pointer(NULL, f.body, ALC_BODY_BYTES, 1, 1, &p) == ALC_ERR_ARGUMENT);
    CHECK(alc_pointer(&f.o, NULL, ALC_BODY_BYTES, 1, 1, &p) == ALC_ERR_ARGUMENT);
    CHECK(alc_pointer(&f.o, f.body, ALC_BODY_BYTES, 1, 1, NULL) == ALC_ERR_ARGUMENT);
    CHECK(alc_pointer(&f.o, f.body, ALC_BODY_BYTES - 1u, 1, 1, &p) == ALC_ERR_ARGUMENT);
    f.body[0] = 0;
    memset(f.body, 'A', ALC_NAME_BYTES);
    CHECK(alc_pointer(&f.o, f.body, ALC_BODY_BYTES, 1, 1, &p) == ALC_ERR_ARGUMENT);
    body_init(f.body);
    /* the press writer: cursor cells, candidate, button */
    make_active(&f, 3);
    f.o.state = ALC_STATE_TIME;
    f.o.dirty = 0;
    memset(&p, 0x55, sizeof p);
    CHECK(pointer(&f, 15, 5, &p) == ALC_OK && p.hit == 1u && p.candidate == 0x276e && p.cursor_written == 1u &&
          p.cursor_kind == 7 && p.cursor_sub == 1);
    CHECK(f.o.button == 1 && f.o.dirty == 1u && f.o.over == 1);
    put16(f.body, O_CURSOR, -3);
    CHECK(pointer(&f, 15, 5, &p) == ALC_OK && p.cursor_kind == -3); /* a signed word */
    put16(f.body, O_CURSOR, 0x1234);
    CHECK(pointer(&f, 15, 5, &p) == ALC_OK && p.cursor_kind == 0x1234);
    /* the hot spot is two signed words: the upper halves are dropped */
    body_init(f.body);
    CHECK(pointer(&f, 0x10000 + 15, 5, &p) == ALC_OK && p.hit == 1u);
    CHECK(pointer(&f, 15, 0x20000 + 5, &p) == ALC_OK && p.hit == 1u);
    CHECK(pointer(&f, 15 - 0x10000, 5, &p) == ALC_OK && p.hit == 1u);
    CHECK(pointer(&f, 0x8000 + 15, 5, &p) == ALC_OK && p.hit == 0u && f.o.over == 0); /* -32753 */
    CHECK(pointer(&f, 15, 0x8000 + 5, &p) == ALC_OK && p.hit == 0u);
    /* the result is cleared on every call */
    CHECK(pointer(&f, 15, 5, &p) == ALC_OK && p.hit == 1u);
    CHECK(pointer(&f, 70, 5, &p) == ALC_OK);
    expect_none(&p);
}

static void t_pointer_bounds(void)
{
    Fx f;
    AlcPointerResult p;
    /* the outer bounds: x from the time button's left to the increase button's right, y down to the cancel button's bottom */
    const struct { int x, y, over; } cases[] = {
        {0, 0, 1}, {59, 19, 1}, {59, 0, 1}, {0, 19, 1}, {-1, 5, 0}, {60, 5, 0}, {5, 20, 0}, {5, -1, 1}, {5, -30000, 1}, {-1, 20, 0},
        {1000, 1000, 0}, {-1000, 5, 0}};
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        fx_init(&f);
        make_active(&f, 3);
        f.o.dirty = 0;
        f.o.over = !cases[i].over;
        CHECK(pointer(&f, cases[i].x, cases[i].y, &p) == ALC_OK);
        CHECK(f.o.over == cases[i].over);
        if (!cases[i].over) {
            expect_none(&p);
            CHECK(f.o.dirty == 1u);
        }
    }
    /* the bound offsets come from the right rectangles: move them */
    fx_init(&f);
    make_active(&f, 3);
    put_rect(f.body, O_INCREASE_BTN, 50, 0, 100, 9);
    CHECK(pointer(&f, 100, 5, &p) == ALC_OK && f.o.over == 1);
    CHECK(pointer(&f, 101, 5, &p) == ALC_OK && f.o.over == 0);
    put_rect(f.body, O_CANCEL_BTN, 30, 0, 39, 40);
    CHECK(pointer(&f, 5, 40, &p) == ALC_OK && f.o.over == 1);
    CHECK(pointer(&f, 5, 41, &p) == ALC_OK && f.o.over == 0);
    put_rect(f.body, O_TIME_BTN, -10, 0, 9, 9);
    CHECK(pointer(&f, -10, 5, &p) == ALC_OK && f.o.over == 1);
    CHECK(pointer(&f, -11, 5, &p) == ALC_OK && f.o.over == 0);
    /* the other edges of those rectangles are not bounds: other buttons may stand left of the time button or below the cancel */
    fx_init(&f);
    make_active(&f, 3);
    put_rect(f.body, O_TIME_BTN, 5, 0, 9, 9);
    put_rect(f.body, O_CANCEL_BTN, 30, 0, 39, 25);
    put_rect(f.body, O_INCREASE_BTN, 50, 0, 70, 9);
    CHECK(pointer(&f, 4, 5, &p) == ALC_OK && f.o.over == 0);
    CHECK(pointer(&f, 70, 25, &p) == ALC_OK && f.o.over == 1);
    CHECK(pointer(&f, 71, 25, &p) == ALC_OK && f.o.over == 0);
}

typedef struct { int x, y; } Pt;
/* A point inside each button, the live set per state and the button number each press yields. */
static void t_pointer_buttons(void)
{
    static const struct { size_t off; Pt in; int button; } btn[6] = {
        {O_TIME_BTN, {4, 4}, 0}, {O_ALARM_BTN, {14, 4}, 1}, {O_SET_BTN, {24, 4}, 6},
        {O_CANCEL_BTN, {34, 14}, 8}, {O_DECREASE_BTN, {44, 4}, 4}, {O_INCREASE_BTN, {54, 4}, 3}};
    Fx f;
    AlcPointerResult p;
    for (int state = 0; state <= 8; ++state) {
        for (int b = 0; b < 6; ++b) {
            int live;
            if (btn[b].button == 8)
                live = 1;
            else if (btn[b].button == 1)
                live = state == ALC_STATE_TIME;
            else
                live = state == ALC_STATE_ALARM;
            fx_init(&f);
            make_active(&f, 3);
            f.o.state = state;
            f.o.dirty = 0;
            f.o.button = 99;
            if (pointer(&f, btn[b].in.x, btn[b].in.y, &p) != ALC_OK || p.hit != (live ? 1u : 0u) ||
                (live && (p.candidate != 0x276e || f.o.button != btn[b].button || f.o.dirty != 1u || p.cursor_kind != 7)) ||
                (!live && (p.candidate != -1 || f.o.button != 99 || p.cursor_written != 0u || f.o.dirty != 0u))) {
                snprintf(g_msg, sizeof g_msg, "pointer state %d button %d (live %d)", state, btn[b].button, live);
                g_failed = 1;
                return;
            }
        }
    }
    /* inclusive edges of each live rectangle: the four corners hit, the pixel beside each edge does not hit that button */
    for (int b = 0; b < 6; ++b) {
        const int state = btn[b].button == 1 ? ALC_STATE_TIME : ALC_STATE_ALARM;
        const int32_t l = rd32(f.body, btn[b].off), t = rd32(f.body, btn[b].off + 4), r = rd32(f.body, btn[b].off + 8),
                      bt = rd32(f.body, btn[b].off + 12);
        const Pt corners[4] = {{l, t}, {r, t}, {l, bt}, {r, bt}};
        const Pt beside[4] = {{l - 1, (t + bt) / 2}, {r + 1, (t + bt) / 2}, {(l + r) / 2, t - 1}, {(l + r) / 2, bt + 1}};
        for (int k = 0; k < 4; ++k) {
            fx_init(&f);
            make_active(&f, 3);
            f.o.state = state;
            CHECK(pointer(&f, corners[k].x, corners[k].y, &p) == ALC_OK && p.hit == 1u && f.o.button == btn[b].button);
            fx_init(&f);
            make_active(&f, 3);
            f.o.state = state;
            f.o.button = 99;
            CHECK(pointer(&f, beside[k].x, beside[k].y, &p) == ALC_OK && !(p.hit == 1u && f.o.button == btn[b].button));
        }
    }
}

/* All six buttons on top of one another: the first live one in the original order wins, then the next once it is moved away. */
static void t_pointer_order(void)
{
    static const size_t order[] = {O_TIME_BTN, O_INCREASE_BTN, O_DECREASE_BTN, O_SET_BTN, O_CANCEL_BTN};
    static const int button[] = {0, 3, 4, 6, 8};
    Fx f;
    AlcPointerResult p;
    /* the time state: the alarm button first, then the cancel button; the others are not live */
    fx_init(&f);
    make_active(&f, 3);
    for (size_t i = 0; i < 5; ++i) put_rect(f.body, order[i], 0, 0, 59, 19);
    put_rect(f.body, O_ALARM_BTN, 0, 0, 59, 19);
    f.o.state = ALC_STATE_TIME;
    CHECK(pointer(&f, 15, 8, &p) == ALC_OK && p.hit == 1u && f.o.button == 1);
    put_rect(f.body, O_ALARM_BTN, 0, 100, 59, 110);
    CHECK(pointer(&f, 15, 8, &p) == ALC_OK && p.hit == 1u && f.o.button == 8);
    /* the alarm state: time, increase, decrease, set, cancel */
    for (size_t i = 0; i < 5; ++i) {
        fx_init(&f);
        make_active(&f, 3);
        for (size_t k = 0; k < 5; ++k) put_rect(f.body, order[k], 0, 0, 59, 19);
        put_rect(f.body, O_ALARM_BTN, 0, 0, 59, 19);
        for (size_t k = 0; k < i; ++k) put_rect(f.body, order[k], 0, 100, 59, 110);
        f.o.state = ALC_STATE_ALARM;
        f.o.button = 99;
        CHECK(pointer(&f, 15, 8, &p) == ALC_OK && p.hit == 1u && f.o.button == button[i]);
    }
}

static void t_pointer_dst_rects(void)
{
    Fx f;
    AlcPointerResult p;
    const Pt dst[3] = {{4, 14}, {14, 14}, {24, 14}}; /* minute, hour, light destinations */
    for (int state = 0; state <= 8; ++state) {
        for (int k = 0; k < 3; ++k) {
            fx_init(&f);
            make_active(&f, 3);
            f.o.state = state;
            f.o.dirty = 0;
            CHECK(pointer(&f, dst[k].x, dst[k].y, &p) == ALC_OK && p.hit == 0u && p.candidate == -1 && f.o.dirty == 1u);
            CHECK(p.cursor_written == 0u);
        }
        /* the AM/PM destination, the gap between them and a point right of every control are not interesting */
        fx_init(&f);
        make_active(&f, 3);
        f.o.state = state;
        f.o.dirty = 1;
        CHECK(pointer(&f, 44, 14, &p) == ALC_OK && p.hit == 0u && f.o.dirty == 0u && f.o.over == 1);
    }
    /* edges of the three destinations, spread out so that no neighbour is near */
    fx_init(&f);
    put_rect(f.body, O_CANCEL_BTN, 30, 0, 39, 60);
    put_rect(f.body, O_MINUTE_DST, 2, 30, 9, 39);
    put_rect(f.body, O_HOUR_DST, 20, 30, 27, 39);
    put_rect(f.body, O_LIGHT_DST, 42, 30, 49, 39);
    make_active(&f, 3);
    {
        const size_t offs[3] = {O_MINUTE_DST, O_HOUR_DST, O_LIGHT_DST};
        for (int k = 0; k < 3; ++k) {
            const int32_t l = rd32(f.body, offs[k]), t = rd32(f.body, offs[k] + 4), r = rd32(f.body, offs[k] + 8),
                          bt = rd32(f.body, offs[k] + 12);
            const Pt in[4] = {{l, t}, {r, t}, {l, bt}, {r, bt}};
            const Pt out[4] = {{l - 1, (t + bt) / 2}, {r + 1, (t + bt) / 2}, {(l + r) / 2, t - 1}, {(l + r) / 2, bt + 1}};
            for (int c = 0; c < 4; ++c) {
                f.o.dirty = 0;
                CHECK(pointer(&f, in[c].x, in[c].y, &p) == ALC_OK && f.o.dirty == 1u);
                f.o.dirty = 1;
                CHECK(pointer(&f, out[c].x, out[c].y, &p) == ALC_OK && f.o.dirty == 0u);
            }
        }
    }
}

/* ---- the click (0x44d624) ------------------------------------------------------------------------------------------------- */

static void t_click(void)
{
    Fx f;
    AlcClickResult c;
    /* the guard: active, not canceled, over, row phase 1 */
    for (int bad = 0; bad < 4; ++bad) {
        fx_init(&f);
        make_active(&f, 3);
        f.o.over = 1;
        f.world.start_flag_5bb1ca = 1;
        f.o.state = ALC_STATE_ALARM;
        f.o.dirty = 0;
        if (bad == 0) f.o.active = 0;
        if (bad == 1) f.o.canceled = 1u;
        if (bad == 2) f.o.over = 0;
        memset(&c, 0x55, sizeof c);
        CHECK(click(&f, bad == 3 ? 2u : 1u, &c) == ALC_OK && c.fired == 0u && c.sound_played == 0u);
        CHECK(f.log[0] == '\0' && f.o.state == ALC_STATE_ALARM && f.o.dirty == 0u);
    }
    {
        const uint32_t phases[] = {0u, 2u, 3u, 0x80000001u};
        for (size_t i = 0; i < sizeof phases / sizeof phases[0]; ++i) {
            fx_init(&f);
            make_active(&f, 3);
            f.o.over = 1;
            f.world.start_flag_5bb1ca = 1;
            CHECK(click(&f, phases[i], &c) == ALC_OK && c.fired == 0u && f.log[0] == '\0' && f.o.state == 0);
        }
    }
    /* a click with a sound: busy test on channel B, play, then the press deadline */
    fx_init(&f);
    make_active(&f, 3);
    f.o.over = 1;
    f.o.dirty = 0;
    f.world.start_flag_5bb1ca = 1;
    f.now = 4000u;
    f.busy_value = 0;
    memset(&c, 0x55, sizeof c);
    CHECK(click(&f, 1u, &c) == ALC_OK && c.fired == 1u && c.sound_played == 1u);
    CHECK_LOG(&f, "busy:4:0,play:4:0,tick:4000:0");
    CHECK(f.o.state == ALC_STATE_PRESSED && f.o.press_deadline == 4500u && f.o.dirty == 1u && f.played_channel == 4);
    /* busy: no play, the press still happens */
    fx_init(&f);
    make_active(&f, 3);
    f.o.over = 1;
    f.world.start_flag_5bb1ca = 1;
    f.now = 4000u;
    f.busy_value = 1;
    CHECK(click(&f, 1u, &c) == ALC_OK && c.fired == 1u && c.sound_played == 0u && f.n_play == 0);
    CHECK_LOG(&f, "busy:4:1,tick:4000:0");
    CHECK(f.o.state == ALC_STATE_PRESSED && f.o.press_deadline == 4500u);
    f.busy_value = -1;
    LOGCLR(&f);
    CHECK(click(&f, 1u, &c) == ALC_OK && c.sound_played == 0u && f.n_play == 0);
    /* any nonzero start flag counts */
    {
        const int flags[] = {2, -1, 0x10000};
        for (size_t i = 0; i < sizeof flags / sizeof flags[0]; ++i) {
            fx_init(&f);
            make_active(&f, 3);
            f.o.over = 1;
            f.world.start_flag_5bb1ca = flags[i];
            CHECK(click(&f, 1u, &c) == ALC_OK && c.sound_played == 1u);
        }
    }
    /* start flag 0: no sound is touched */
    fx_init(&f);
    make_active(&f, 3);
    f.o.over = 1;
    f.world.start_flag_5bb1ca = 0;
    f.now = 4000u;
    CHECK(click(&f, 1u, &c) == ALC_OK && c.fired == 1u && c.sound_played == 0u);
    CHECK_LOG(&f, "tick:4000:0");
    /* NO SOUND: no sound is touched */
    fx_init(&f);
    make_active(&f, 3);
    f.o.over = 1;
    f.world.start_flag_5bb1ca = 1;
    set_str(f.body, O_BSOUND, "NO SOUND");
    CHECK(click(&f, 1u, &c) == ALC_OK && c.fired == 1u && c.sound_played == 0u);
    CHECK_LOG(&f, "tick:1000:0");
    /* the press delay is a signed word in units of 100 ms */
    {
        const int16_t delays[] = {5, 0, -1, 300, 0x7fff};
        for (size_t i = 0; i < sizeof delays / sizeof delays[0]; ++i) {
            fx_init(&f);
            make_active(&f, 3);
            f.o.over = 1;
            put16(f.body, O_DELAY, delays[i]);
            f.now = 4000u;
            CHECK(click(&f, 1u, &c) == ALC_OK && f.o.press_deadline == 4000u + (uint32_t)((int32_t)delays[i] * 100));
        }
    }
    /* the click leaves the button, the pointer state and the alarm alone */
    fx_init(&f);
    make_active(&f, 3);
    f.o.over = 1;
    f.o.button = 6;
    f.o.alarm_hour = 3;
    f.o.restore = 1;
    CHECK(click(&f, 1u, &c) == ALC_OK && f.o.button == 6 && f.o.over == 1 && f.o.alarm_hour == 3 && f.o.restore == 1);
    /* arguments */
    CHECK(alc_click(NULL, f.body, ALC_BODY_BYTES, 1u, &f.world, &f.host, &c) == ALC_ERR_ARGUMENT);
    CHECK(alc_click(&f.o, NULL, ALC_BODY_BYTES, 1u, &f.world, &f.host, &c) == ALC_ERR_ARGUMENT);
    CHECK(alc_click(&f.o, f.body, ALC_BODY_BYTES, 1u, NULL, &f.host, &c) == ALC_ERR_ARGUMENT);
    CHECK(alc_click(&f.o, f.body, ALC_BODY_BYTES, 1u, &f.world, NULL, &c) == ALC_ERR_ARGUMENT);
    CHECK(alc_click(&f.o, f.body, ALC_BODY_BYTES, 1u, &f.world, &f.host, NULL) == ALC_ERR_ARGUMENT);
    CHECK(alc_click(&f.o, f.body, ALC_BODY_BYTES - 1u, 1u, &f.world, &f.host, &c) == ALC_ERR_ARGUMENT);
    memset(f.body, 'A', ALC_NAME_BYTES);
    CHECK(alc_click(&f.o, f.body, ALC_BODY_BYTES, 1u, &f.world, &f.host, &c) == ALC_ERR_ARGUMENT);
}

/* ---- invalidate and cleanup ------------------------------------------------------------------------------------------------ */

static void t_invalidate(void)
{
    Fx f;
    fx_init(&f);
    CHECK(alc_invalidate(&f.o, &f.host) == ALC_OK && f.n_dirty == 0);
    make_active(&f, 3);
    CHECK(alc_invalidate(&f.o, &f.host) == ALC_OK && f.n_dirty == 1 && f.dirty_slot == 24);
    f.o.slot = 0; /* slot 0 is a slot */
    CHECK(alc_invalidate(&f.o, &f.host) == ALC_OK && f.n_dirty == 2 && f.dirty_slot == 0);
    f.o.slot = ALC_NO_SLOT;
    CHECK(alc_invalidate(&f.o, &f.host) == ALC_OK && f.n_dirty == 2);
    f.o.slot = 24;
    f.o.active = 0;
    CHECK(alc_invalidate(&f.o, &f.host) == ALC_OK && f.n_dirty == 2);
    f.o.active = 1;
    f.fail_call = 1;
    f.calls = 0;
    CHECK(alc_invalidate(&f.o, &f.host) == ALC_ERR_HOST);
    CHECK(alc_invalidate(NULL, &f.host) == ALC_ERR_ARGUMENT && alc_invalidate(&f.o, NULL) == ALC_ERR_ARGUMENT);
    f.host.mark_dirty = NULL;
    CHECK(alc_invalidate(&f.o, &f.host) == ALC_ERR_ARGUMENT);
}

static void t_cleanup(void)
{
    Fx f;
    fx_init(&f);
    make_active(&f, 3);
    f.o.canceled = 1u;
    f.o.set = 1u;
    f.o.state = 5;
    f.o.dirty = 1;
    f.o.over = 1;
    f.o.button = 3;
    f.o.time_hour = 4;
    f.o.alarm_hour = 6;
    f.o.restore = 1;
    f.o.press_deadline = 9u;
    f.o.final_deadline = 10u;
    CHECK(alc_cleanup(&f.o, &f.host) == ALC_OK);
    CHECK_LOG(&f, "relsurf:77:0,relslot:24:0,idle:0:0");
    CHECK(f.o.surface == 0u && f.o.slot == -1 && f.o.row == -1 && f.o.active == 0 && f.o.canceled == 0u && f.o.set == 0u);
    CHECK(f.o.state == 5 && f.o.dirty == 1u && f.o.over == 1 && f.o.button == 3 && f.o.time_hour == 4 &&
          f.o.alarm_hour == 6 && f.o.restore == 1 && f.o.press_deadline == 9u && f.o.final_deadline == 10u);
    /* idle: only the timer touch */
    LOGCLR(&f);
    CHECK(alc_cleanup(&f.o, &f.host) == ALC_OK);
    CHECK_LOG(&f, "idle:0:0");
    /* slot 0 and a slot without a surface */
    fx_init(&f);
    f.o.slot = 0;
    CHECK(alc_cleanup(&f.o, &f.host) == ALC_OK && f.n_relslot == 1 && f.n_relsurf == 0 && f.o.slot == -1);
    fx_init(&f);
    f.o.surface = 5u;
    CHECK(alc_cleanup(&f.o, &f.host) == ALC_OK && f.n_relslot == 0 && f.n_relsurf == 1 && f.o.surface == 0u);
    CHECK(alc_cleanup(NULL, &f.host) == ALC_ERR_ARGUMENT && alc_cleanup(&f.o, NULL) == ALC_ERR_ARGUMENT);
    f.host.release_surface = NULL;
    CHECK(alc_cleanup(&f.o, &f.host) == ALC_ERR_ARGUMENT);
    f.host.release_surface = h_relsurf;
    f.host.release_slot = NULL;
    CHECK(alc_cleanup(&f.o, &f.host) == ALC_ERR_ARGUMENT);
    f.host.release_slot = h_relslot;
    f.host.touch_idle_timer = NULL;
    CHECK(alc_cleanup(&f.o, &f.host) == ALC_ERR_ARGUMENT);
    /* a failed release stops the cleanup: the object keeps what was not released */
    fx_init(&f);
    make_active(&f, 3);
    f.fail_call = 1;
    CHECK(alc_cleanup(&f.o, &f.host) == ALC_ERR_HOST && f.o.surface == 77u && f.o.slot == 24 && f.o.active == 1);
    fx_init(&f);
    make_active(&f, 3);
    f.fail_call = 2;
    CHECK(alc_cleanup(&f.o, &f.host) == ALC_ERR_HOST && f.o.surface == 0u && f.o.slot == 24 && f.o.active == 1);
    fx_init(&f);
    make_active(&f, 3);
    f.fail_call = 3;
    CHECK(alc_cleanup(&f.o, &f.host) == ALC_ERR_HOST && f.o.surface == 0u && f.o.slot == -1 && f.o.row == -1 && f.o.active == 0);
}

/* ---- the render callback (0x44e035) --------------------------------------------------------------------------------------- */

static int32_t rect_v(size_t off, int k) { return (int32_t)off + 1000 * k; }

/* Blit `i` of `r` must be `kind`, with the given surface, the source rectangle of the body rectangle at src_off and the
 * destination rectangle of the one at dst_off plus the view origin (vx, vy). */
static int blit_is(const AlcRenderResult *r, int i, int kind, uint32_t surface, size_t src_off, size_t dst_off, int vx, int vy)
{
    const AlcBlit *b;
    if (i >= r->count) return 0;
    b = &r->blit[i];
    return b->kind == kind && b->src_surface == surface && b->src[0] == rect_v(src_off, 0) &&
           b->src[1] == rect_v(src_off, 1) && b->src[2] == rect_v(src_off, 2) && b->src[3] == rect_v(src_off, 3) &&
           b->dst[0] == rect_v(dst_off, 0) + vx && b->dst[1] == rect_v(dst_off, 1) + vy &&
           b->dst[2] == rect_v(dst_off, 2) + vx && b->dst[3] == rect_v(dst_off, 3) + vy;
}

static void stamped(Fx *f)
{
    fx_init(f);
    body_stamp(f->body);
    make_active(f, 3);
    f->o.time_hour = 2;
    f->o.time_quarter = 1;
    f->o.time_am = 1;
    f->o.alarm_hour = 7;
    f->o.alarm_quarter = 3;
    f->o.alarm_am = 0;
}

static void t_render_basics(void)
{
    Fx f;
    AlcRenderResult r;
    fx_init(&f);
    /* no slot: the callback is never called */
    memset(&r, 0x55, sizeof r);
    CHECK(render(&f, &r) == ALC_OK && r.valid == 0u && r.count == 0u && f.n_origin == 0);
    /* time mode: AM overlay, time light, hour 2, quarter 1 */
    stamped(&f);
    f.o.dirty = 1;
    memset(&r, 0x55, sizeof r);
    CHECK(render(&f, &r) == ALC_OK && r.valid == 1u && r.count == 4u);
    CHECK(blit_is(&r, 0, ALC_BLIT_AM, 77u, O_AM_SRC, O_AMPM_DST, 10, 20));
    CHECK(blit_is(&r, 1, ALC_BLIT_LIGHT_TIME, 77u, O_TIME_LIGHT, O_LIGHT_DST, 10, 20));
    CHECK(blit_is(&r, 2, ALC_BLIT_HOUR, 77u, O_HOUR_SRC + 2 * 16, O_HOUR_DST, 10, 20));
    CHECK(blit_is(&r, 3, ALC_BLIT_MINUTE, 77u, O_MINUTE_SRC + 1 * 16, O_MINUTE_DST, 10, 20));
    CHECK_LOG(&f, "blit:1:0,blit:3:0,blit:5:0,blit:6:0");
    CHECK(f.o.dirty == 0u && f.n_origin == 1 && f.o.restore == 0);
    /* alarm mode: PM overlay, alarm light, hour 7, quarter 3 */
    stamped(&f);
    f.o.state = ALC_STATE_ALARM;
    CHECK(render(&f, &r) == ALC_OK && r.count == 4u);
    CHECK(blit_is(&r, 0, ALC_BLIT_PM, 77u, O_PM_SRC, O_AMPM_DST, 10, 20));
    CHECK(blit_is(&r, 1, ALC_BLIT_LIGHT_ALARM, 77u, O_ALARM_LIGHT, O_LIGHT_DST, 10, 20));
    CHECK(blit_is(&r, 2, ALC_BLIT_HOUR, 77u, O_HOUR_SRC + 7 * 16, O_HOUR_DST, 10, 20));
    CHECK(blit_is(&r, 3, ALC_BLIT_MINUTE, 77u, O_MINUTE_SRC + 3 * 16, O_MINUTE_DST, 10, 20));
    /* the AM value is nonzero for AM whatever it is; the view origin is added to both corners, and may be negative */
    stamped(&f);
    f.o.alarm_am = 5;
    f.o.state = ALC_STATE_ALARM;
    f.vx = -300;
    f.vy = 77;
    CHECK(render(&f, &r) == ALC_OK && blit_is(&r, 0, ALC_BLIT_AM, 77u, O_AM_SRC, O_AMPM_DST, -300, 77));
    CHECK(blit_is(&r, 3, ALC_BLIT_MINUTE, 77u, O_MINUTE_SRC + 3 * 16, O_MINUTE_DST, -300, 77));
    /* the last hour and quarter; the first */
    stamped(&f);
    f.o.time_hour = 11;
    f.o.time_quarter = 3;
    CHECK(render(&f, &r) == ALC_OK && blit_is(&r, 2, ALC_BLIT_HOUR, 77u, O_HOUR_SRC + 11 * 16, O_HOUR_DST, 10, 20) &&
          blit_is(&r, 3, ALC_BLIT_MINUTE, 77u, O_MINUTE_SRC + 3 * 16, O_MINUTE_DST, 10, 20));
    stamped(&f);
    f.o.time_hour = 0;
    f.o.time_quarter = 0;
    CHECK(render(&f, &r) == ALC_OK && blit_is(&r, 2, ALC_BLIT_HOUR, 77u, O_HOUR_SRC, O_HOUR_DST, 10, 20) &&
          blit_is(&r, 3, ALC_BLIT_MINUTE, 77u, O_MINUTE_SRC, O_MINUTE_DST, 10, 20));
    /* arguments */
    CHECK(alc_render(NULL, f.body, ALC_BODY_BYTES, &f.host, &r) == ALC_ERR_ARGUMENT);
    CHECK(alc_render(&f.o, NULL, ALC_BODY_BYTES, &f.host, &r) == ALC_ERR_ARGUMENT);
    CHECK(alc_render(&f.o, f.body, ALC_BODY_BYTES, NULL, &r) == ALC_ERR_ARGUMENT);
    CHECK(alc_render(&f.o, f.body, ALC_BODY_BYTES, &f.host, NULL) == ALC_ERR_ARGUMENT);
    CHECK(alc_render(&f.o, f.body, ALC_BODY_BYTES - 1u, &f.host, &r) == ALC_ERR_ARGUMENT);
    memset(f.body, 'A', ALC_NAME_BYTES);
    CHECK(alc_render(&f.o, f.body, ALC_BODY_BYTES, &f.host, &r) == ALC_ERR_ARGUMENT);
}

/* Which set of digits and which light the state shows. */
static void t_render_modes(void)
{
    Fx f;
    AlcRenderResult r;
    for (int state = 0; state <= 8; ++state) {
        for (int button = -1; button <= 9; ++button) {
            int time_mode = state == 0 || state == 8 || (state == 2 && button == 8);
            if (state != 2 && button != 0) continue;
            stamped(&f);
            f.o.state = state;
            f.o.button = button;
            if (render(&f, &r) != ALC_OK || r.count < 4u ||
                !blit_is(&r, 0, time_mode ? ALC_BLIT_AM : ALC_BLIT_PM, 77u, time_mode ? O_AM_SRC : O_PM_SRC, O_AMPM_DST, 10, 20) ||
                !blit_is(&r, 1, time_mode ? ALC_BLIT_LIGHT_TIME : ALC_BLIT_LIGHT_ALARM, 77u,
                         time_mode ? O_TIME_LIGHT : O_ALARM_LIGHT, O_LIGHT_DST, 10, 20) ||
                !blit_is(&r, 2, ALC_BLIT_HOUR, 77u, O_HOUR_SRC + (time_mode ? 2 : 7) * 16, O_HOUR_DST, 10, 20) ||
                !blit_is(&r, 3, ALC_BLIT_MINUTE, 77u, O_MINUTE_SRC + (time_mode ? 1 : 3) * 16, O_MINUTE_DST, 10, 20)) {
                snprintf(g_msg, sizeof g_msg, "render mode state %d button %d", state, button);
                g_failed = 1;
                return;
            }
        }
    }
}

static void t_render_buttons(void)
{
    static const struct { int button, kind; size_t src, dst; } down[] = {
        {0, ALC_BLIT_DOWN_TIME, O_TIME_DOWN, O_TIME_BTN}, {1, ALC_BLIT_DOWN_ALARM, O_ALARM_DOWN, O_ALARM_BTN},
        {3, ALC_BLIT_DOWN_INCREASE, O_INCREASE_DOWN, O_INCREASE_BTN}, {4, ALC_BLIT_DOWN_DECREASE, O_DECREASE_DOWN, O_DECREASE_BTN},
        {6, ALC_BLIT_DOWN_SET, O_SET_DOWN, O_SET_BTN}, {8, ALC_BLIT_DOWN_CANCEL, O_CANCEL_DOWN, O_CANCEL_BTN}};
    static const struct { int kind; size_t rect; } up[] = {
        {ALC_BLIT_UP_CANCEL, O_CANCEL_BTN}, {ALC_BLIT_UP_ALARM, O_ALARM_BTN}, {ALC_BLIT_UP_TIME, O_TIME_BTN},
        {ALC_BLIT_UP_SET, O_SET_BTN}, {ALC_BLIT_UP_INCREASE, O_INCREASE_BTN}, {ALC_BLIT_UP_DECREASE, O_DECREASE_BTN}};
    Fx f;
    AlcRenderResult r;
    for (int button = -2; button <= 10; ++button) {
        int want = -1;
        for (size_t i = 0; i < 6; ++i)
            if (down[i].button == button) want = (int)i;
        stamped(&f);
        f.o.state = ALC_STATE_PRESSED;
        f.o.button = button;
        f.o.restore = 1; /* a pending restore waits while a button is shown pressed */
        LOGCLR(&f);
        CHECK(render(&f, &r) == ALC_OK);
        if (want < 0) {
            CHECK(r.count == 4u);
        } else {
            CHECK(r.count == 5u && blit_is(&r, 4, down[want].kind, 77u, down[want].src, down[want].dst, 10, 20));
        }
        CHECK(f.o.restore == 1 && f.o.dirty == 0u && f.o.state == ALC_STATE_PRESSED);
    }
    /* the log of a pressed button */
    stamped(&f);
    f.o.state = ALC_STATE_PRESSED;
    f.o.button = 6;
    CHECK(render(&f, &r) == ALC_OK);
    CHECK_LOG(&f, "blit:2:0,blit:4:0,blit:5:0,blit:6:0,blit:9:0");
    /* a pending restore in any other state: six up buttons from the shared surface, then the request is cleared */
    for (int state = 0; state <= 8; ++state) {
        if (state == ALC_STATE_PRESSED) continue;
        stamped(&f);
        f.o.state = state;
        f.o.restore = 1;
        f.o.dirty = 1;
        LOGCLR(&f);
        CHECK(render(&f, &r) == ALC_OK && r.count == 10u);
        for (int i = 0; i < 6; ++i) CHECK(blit_is(&r, 4 + i, up[i].kind, 0u, up[i].rect, up[i].rect, 10, 20));
        CHECK(f.o.restore == 0 && f.o.dirty == 0u);
        CHECK(strstr(f.log, "blit:13:0,blit:14:0,blit:15:0,blit:16:0,blit:17:0,blit:18:0") != NULL);
        CHECK(render(&f, &r) == ALC_OK && r.count == 4u); /* only once */
    }
    /* any nonzero restore value counts */
    stamped(&f);
    f.o.restore = -5;
    CHECK(render(&f, &r) == ALC_OK && r.count == 10u && f.o.restore == 0);
}

static void t_render_bounds(void)
{
    Fx f;
    AlcRenderResult r;
    const int16_t bad_hours[] = {-1, 12, 13, 0x7fff, (int16_t)0x8000};
    const int16_t bad_quarters[] = {-1, 4, 5, 0x7fff, (int16_t)0x8000};
    for (int mode = 0; mode < 2; ++mode) {
        for (size_t i = 0; i < 5; ++i) {
            stamped(&f);
            f.o.state = mode ? ALC_STATE_ALARM : ALC_STATE_TIME;
            f.o.dirty = 1;
            f.o.restore = 1;
            if (mode) f.o.alarm_hour = bad_hours[i]; else f.o.time_hour = bad_hours[i];
            CHECK(render(&f, &r) == ALC_ERR_BOUNDS && r.count == 0u && f.o.dirty == 1u && f.o.restore == 1 && f.n_origin == 0);
            CHECK(f.log[0] == '\0');
            stamped(&f);
            f.o.state = mode ? ALC_STATE_ALARM : ALC_STATE_TIME;
            f.o.dirty = 1;
            if (mode) f.o.alarm_quarter = bad_quarters[i]; else f.o.time_quarter = bad_quarters[i];
            CHECK(render(&f, &r) == ALC_ERR_BOUNDS && r.count == 0u && f.o.dirty == 1u && f.n_origin == 0);
        }
        /* the digits of the other mode are not looked at */
        stamped(&f);
        f.o.state = mode ? ALC_STATE_ALARM : ALC_STATE_TIME;
        if (mode) { f.o.time_hour = 99; f.o.time_quarter = 99; } else { f.o.alarm_hour = 99; f.o.alarm_quarter = 99; }
        CHECK(render(&f, &r) == ALC_OK && r.count == 4u);
    }
    /* the borders themselves are fine */
    stamped(&f);
    f.o.time_hour = 11;
    f.o.time_quarter = 3;
    f.o.state = ALC_STATE_CANCEL;
    CHECK(render(&f, &r) == ALC_OK);
    stamped(&f);
    f.o.time_hour = 0;
    f.o.time_quarter = 0;
    CHECK(render(&f, &r) == ALC_OK);
    /* a pressed cancel button shows the time digits */
    stamped(&f);
    f.o.state = ALC_STATE_PRESSED;
    f.o.button = 8;
    f.o.time_hour = 12;
    CHECK(render(&f, &r) == ALC_ERR_BOUNDS);
}

/* ---- host failures ------------------------------------------------------------------------------------------------------------ */

/* Each scenario runs a short sequence and returns the first non-OK status. */
#define STEP(expr)                          do {                                        const int rc_ = (expr);                 if (rc_ != ALC_OK) return rc_;      } while (0)

static int sc_phase0(Fx *f) { return visit(f, 3, 0u); }
static int sc_final_sound(Fx *f)
{
    make_active(f, 3);
    f->o.state = ALC_STATE_WAIT_SET;
    f->o.final_deadline = 0u;
    f->busy_value = 0;
    STEP(visit(f, 3, 1u));
    STEP(visit(f, 3, 1u));
    return f->phase == 2u ? ALC_OK : ALC_ERR_ARGUMENT;
}
static int sc_cancel(Fx *f)
{
    make_active(f, 3);
    f->o.canceled = 1u;
    return visit(f, 3, 2u);
}
static int sc_set(Fx *f)
{
    make_active(f, 3);
    f->o.set = 1u;
    f->o.alarm_hour = 4;
    return visit(f, 3, 2u);
}
static int sc_click(Fx *f)
{
    AlcClickResult c;
    make_active(f, 3);
    f->o.over = 1;
    f->world.start_flag_5bb1ca = 1;
    f->busy_value = 0;
    return click(f, 1u, &c);
}
static int sc_render(Fx *f)
{
    AlcRenderResult r;
    make_active(f, 3);
    return render(f, &r);
}
static int sc_invalidate(Fx *f)
{
    make_active(f, 3);
    return alc_invalidate(&f->o, &f->host);
}
static int sc_cleanup(Fx *f)
{
    make_active(f, 3);
    return alc_cleanup(&f->o, &f->host);
}

static void t_host_failure_sweep(void)
{
    static int (*const scenarios[])(Fx *) = {sc_phase0, sc_final_sound, sc_cancel, sc_set, sc_click, sc_render, sc_invalidate,
                                             sc_cleanup};
    unsigned mask = 0u;
    for (size_t s = 0; s < sizeof scenarios / sizeof scenarios[0]; ++s) {
        Fx f;
        int total;
        fx_init(&f);
        if (scenarios[s](&f) != ALC_OK) {
            snprintf(g_msg, sizeof g_msg, "scenario %zu does not run clean", s);
            g_failed = 1;
            return;
        }
        total = f.calls;
        for (int n = 1; n <= total; ++n) {
            fx_init(&f);
            f.fail_call = n;
            if (scenarios[s](&f) != ALC_ERR_HOST || f.failed_cb == 0) {
                snprintf(g_msg, sizeof g_msg, "scenario %zu: failing host call %d of %d was not reported", s, n, total);
                g_failed = 1;
                return;
            }
            mask |= f.failed_mask;
        }
    }
    for (int id = 1; id <= CB_LAST; ++id) {
        if ((mask & (1u << id)) == 0u) {
            snprintf(g_msg, sizeof g_msg, "host callback %d was never made to fail", id);
            g_failed = 1;
            return;
        }
    }
}

static void t_host_failure_effects(void)
{
    Fx f;
    /* phase 0 fails at the allocation: the clock is marked active and has read the time, but there is no slot, phase 1 is not reached */
    fx_init(&f);
    f.fail_call = 1;
    CHECK(visit(&f, 3, 0u) == ALC_ERR_HOST && strcmp(f.failure, "0xaa-host") == 0);
    CHECK(f.phase == 0u && f.initialized == 0 && f.completed == 0 && f.o.slot == -1 && f.o.surface == 0u);
    CHECK_LOG(&f, "start:1:0");
    /* a failing finish leaves the clock in phase 2 */
    fx_init(&f);
    make_active(&f, 3);
    f.o.canceled = 1u;
    f.fail_call = 3; /* the stop, the transition... the third host call is the event flag store? count: stop, transition, store */
    CHECK(visit(&f, 3, 2u) == ALC_ERR_HOST && f.phase == 2u && f.completed == 0 && f.o.active == 1);
    CHECK(strstr(f.log, "complete") == NULL && strstr(f.log, "relsurf") == NULL);
    /* a failing cleanup after the completion */
    fx_init(&f);
    make_active(&f, 3);
    f.fail_call = 3; /* stop, release surface, release slot */
    CHECK(visit(&f, 3, 2u) == ALC_ERR_HOST && f.completed == 1 && f.phase == 0u);
    CHECK(strstr(f.log, "complete:3:0,relsurf:77:0") != NULL && strstr(f.log, "idle") == NULL);
}

/* ---- play-throughs ------------------------------------------------------------------------------------------------------------- */

/* One press: the pointer over a button, the accepted release and phase 1 visits until the button state is reached. */
static int press_button(Fx *f, int x, int y, int expect_state)
{
    AlcPointerResult p;
    AlcClickResult c;
    int guard;
    if (pointer(f, x, y, &p) != ALC_OK || p.hit != 1u || p.candidate != 0x276e) return 0;
    if (click(f, f->phase, &c) != ALC_OK || c.fired != 1u || f->o.state != ALC_STATE_PRESSED) return 0;
    for (guard = 0; guard < 4 && f->o.state == ALC_STATE_PRESSED; ++guard) {
        f->now += 150u;
        if (visit(f, 3, f->phase) != ALC_OK) return 0;
    }
    return f->o.state == expect_state && f->o.restore == 1;
}

static void t_playthrough_set(void)
{
    Fx f;
    AlcRenderResult r;
    fx_init(&f);
    f.world.hour_585d51 = 10;
    f.world.minute_585d4f = 20; /* 10:20 AM: alarm offered at 11:00 AM */
    f.world.start_flag_5bb1ca = 0;
    CHECK(visit(&f, 3, 0u) == ALC_OK && f.phase == 1u);
    CHECK(f.o.time_hour == 9 && f.o.time_quarter == 1 && f.o.time_am == 1 && f.o.alarm_hour == 10 && f.o.alarm_am == 1 &&
          f.o.alarm_quarter == 0);
    /* time mode: the alarm button is live, the others are not */
    {
        AlcPointerResult p;
        CHECK(pointer(&f, 54, 4, &p) == ALC_OK && p.hit == 0u); /* increase */
        CHECK(pointer(&f, 4, 4, &p) == ALC_OK && p.hit == 0u);  /* time */
    }
    CHECK(render(&f, &r) == ALC_OK && r.count == 4u && r.blit[1].kind == ALC_BLIT_LIGHT_TIME);
    CHECK(press_button(&f, 14, 4, ALC_STATE_ALARM));
    CHECK(render(&f, &r) == ALC_OK && r.count == 10u && r.blit[1].kind == ALC_BLIT_LIGHT_ALARM && r.blit[2].kind == ALC_BLIT_HOUR);
    /* increase: 11:00 AM -> 12:00 PM (the AM flag flips on reaching hour index 11) */
    CHECK(press_button(&f, 54, 4, ALC_STATE_INCREASE));
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.o.alarm_hour == 11 && f.o.alarm_am == 0 && f.o.state == ALC_STATE_ALARM);
    /* decrease twice: back to 11 AM then 10 AM */
    CHECK(press_button(&f, 44, 4, ALC_STATE_DECREASE));
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.o.alarm_hour == 10 && f.o.alarm_am == 1);
    CHECK(press_button(&f, 44, 4, ALC_STATE_DECREASE));
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.o.alarm_hour == 9 && f.o.alarm_am == 1);
    CHECK(press_button(&f, 54, 4, ALC_STATE_INCREASE));
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.o.alarm_hour == 10);
    /* set */
    LOGCLR(&f);
    CHECK(press_button(&f, 24, 4, ALC_STATE_SET));
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.o.state == ALC_STATE_WAIT_SET && f.o.set == 1u);
    f.now = f.o.final_deadline - 1u;
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.o.state == ALC_STATE_WAIT_SET);
    f.now = f.o.final_deadline;
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.o.state == ALC_STATE_FINAL_SOUND && f.phase == 1u);
    f.busy_value = 1;
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.phase == 1u);
    f.busy_value = 0;
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.phase == 2u);
    CHECK(visit(&f, 3, 2u) == ALC_OK && f.completed == 1 && f.phase == 0u);
    CHECK(f.world.hour_585d51 == 11 && f.world.minute_585d4f == 0 && f.world.start_flag_5bb1ca == 0);
    CHECK(strstr(f.log, "tr:40:1:2:3:11:22:33") != NULL && strstr(f.log, "sf:7:3") != NULL);
    CHECK(f.o.active == 0 && f.o.row == -1 && f.o.slot == -1);
    /* after the finish the pointer and the click find an idle clock */
    {
        AlcPointerResult p;
        AlcClickResult c;
        CHECK(pointer(&f, 14, 4, &p) == ALC_OK && p.hit == 0u);
        CHECK(click(&f, 1u, &c) == ALC_OK && c.fired == 0u);
    }
    /* a second round starts again */
    LOGCLR(&f);
    CHECK(visit(&f, 3, 0u) == ALC_OK && f.phase == 1u && f.o.state == 0 && f.o.set == 0u);
}

static void t_playthrough_cancel(void)
{
    Fx f;
    fx_init(&f);
    CHECK(visit(&f, 3, 0u) == ALC_OK);
    CHECK(press_button(&f, 14, 4, ALC_STATE_ALARM));
    CHECK(press_button(&f, 34, 14, ALC_STATE_CANCEL));
    LOGCLR(&f);
    CHECK(visit(&f, 3, 1u) == ALC_OK && f.phase == 2u && f.o.canceled == 1u);
    {
        AlcClickResult c;
        CHECK(click(&f, 2u, &c) == ALC_OK && c.fired == 0u);
        f.o.over = 1;
        CHECK(click(&f, 1u, &c) == ALC_OK && c.fired == 0u); /* canceled: no further press */
    }
    CHECK(visit(&f, 3, 2u) == ALC_OK && f.completed == 1);
    CHECK(f.world.hour_585d51 == 10 && f.world.minute_585d4f == 20); /* the clock is untouched */
    CHECK(strstr(f.log, "tr:50:4:5:6:44:55:66") != NULL && strstr(f.log, "sf:8:9") != NULL);
    /* cancel straight from time mode */
    fx_init(&f);
    CHECK(visit(&f, 3, 0u) == ALC_OK);
    CHECK(press_button(&f, 34, 14, ALC_STATE_CANCEL));
}

/* ---- the session binding (src/session_bindings_aaa.c) over a synthetic scene -------------------------------------------- */

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
    uint8_t tsum[126], act[48 + 2 + ALC_BODY_BYTES];
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

static int g_loads, g_stores, g_store_start, g_store_hour, g_store_minute;
static AlcWorld g_world_in;
static int g_hook_bad;
static void h_load_world(void *c, AlcWorld *w)
{
    if (c == NULL) ++g_hook_bad;
    ++g_loads;
    *w = g_world_in;
}
static void h_store_world(void *c, const AlcWorld *w)
{
    if (c == NULL) ++g_hook_bad;
    ++g_stores;
    g_store_start = w->start_flag_5bb1ca;
    g_store_hour = w->hour_585d51;
    g_store_minute = w->minute_585d4f;
}

typedef struct Bind {
    Fx f;
    SessionAaaHost host;
    SessionAaaBinding *b;
    SceneResource *scene;
    uint8_t bytes[8192];
    uint8_t bytes_before[8192];
    size_t bytes_len;
    uint8_t body_a[ALC_BODY_BYTES], body_b[ALC_BODY_BYTES];
} Bind;

static int bind_open(Bind *x, int hooks)
{
    const int types[3] = {0x70, 0xaa, 0xaa};
    const uint8_t one = 0;
    const uint8_t *bodies[3];
    size_t lengths[3] = {1, ALC_BODY_BYTES, ALC_BODY_BYTES};
    char err[128] = {0};
    fx_init(&x->f);
    g_loads = g_stores = g_hook_bad = 0;
    g_store_start = g_store_hour = g_store_minute = -1;
    memset(&g_world_in, 0, sizeof g_world_in);
    g_world_in.start_flag_5bb1ca = 4;
    g_world_in.hour_585d51 = 10;
    g_world_in.minute_585d4f = 20;
    memcpy(x->body_a, x->f.body, ALC_BODY_BYTES);
    memcpy(x->body_b, x->f.body, ALC_BODY_BYTES);
    put_rect(x->body_b, O_ALARM_BTN, 300, 0, 309, 9); /* row 2: the alarm button elsewhere */
    put_rect(x->body_b, O_INCREASE_BTN, 300, 0, 399, 9);
    put_rect(x->body_b, O_AM_SRC, 700, 1, 709, 9);    /* row 2: the AM overlay comes from elsewhere */
    set_block(x->body_b, O_SETBLK, 41, 1, 2, 3, 11, 22, 33, 1, 7, 3);
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
    if (hooks) {
        x->host.load_world = h_load_world;
        x->host.store_world = h_store_world;
    }
    x->b = session_aaa_create(&x->host);
    return x->b != NULL;
}

static void bind_close(Bind *x)
{
    session_aaa_destroy(x->b);
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
        const int rc = session_aaa_handler(x->b, row, &info, &st, &out);
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
    AlcPointerResult p;
    AlcClickResult c;
    AlcRenderResult r;
    if (!bind_open(&x, 1)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_aaa_begin_scene(x.b, x.scene) == ALC_OK && strcmp(session_aaa_failure(x.b), "none") == 0);
    CHECK(session_aaa_registered(x.b) == 0u && session_aaa_object(x.b)->active == 0 && session_aaa_object(x.b)->row == -1);
    LOGCLR(&x.f);
    {
        SceneActionInfo info, other;
        SceneActionRuntimeState st;
        SceneActionHandlerResult out;
        memset(&st, 0, sizeof st);
        CHECK(scene_resource_action_at(x.scene, 0, &info) == SCENE_RESOURCE_OK);
        CHECK(session_aaa_handler(x.b, 0, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(strcmp(session_aaa_failure(x.b), "0xaa-row-not-owned") == 0);
        CHECK(scene_resource_action_at(x.scene, 1, &info) == SCENE_RESOURCE_OK);
        CHECK(session_aaa_handler(x.b, 7, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(strcmp(session_aaa_failure(x.b), "0xaa-row-not-owned") == 0);
        CHECK(session_aaa_handler(x.b, 3, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR); /* one past the last row */
        CHECK(scene_resource_action_at(x.scene, 0, &other) == SCENE_RESOURCE_OK);
        CHECK(session_aaa_handler(x.b, 1, &other, &st, &out) == SCENE_ACTION_HANDLER_ERROR); /* foreign type at our index */
        CHECK(session_aaa_handler(x.b, 0, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);  /* our type at a foreign index */
        CHECK(x.f.log[0] == '\0' && g_loads == 0);
        CHECK(session_aaa_handler(x.b, 1, NULL, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_aaa_handler(x.b, 1, &info, NULL, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_aaa_handler(x.b, 1, &info, &st, NULL) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_aaa_handler(NULL, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        st.phase = 1u;
        CHECK(session_aaa_handler(x.b, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
        CHECK(strcmp(session_aaa_failure(x.b), "0xaa-phase-1-without-init") == 0);
        CHECK(g_loads == 1); /* the world is loaded before the visit that was refused by the kernel */
        g_loads = 0;
    }
    /* pointer, click, render and invalidate before the clock starts */
    memset(&p, 0x55, sizeof p);
    CHECK(session_aaa_pointer_move(x.b, 15, 5, &p) == ALC_OK && p.hit == 0u && p.candidate == -1 && p.cursor_written == 0u);
    memset(&c, 0x55, sizeof c);
    CHECK(session_aaa_click(x.b, 1u, &c) == ALC_OK && c.fired == 0u && c.sound_played == 0u);
    CHECK(session_aaa_click(x.b, 1u, NULL) == ALC_OK);
    memset(&r, 0x55, sizeof r);
    CHECK(session_aaa_render(x.b, &r) == ALC_OK && r.valid == 0u && r.count == 0u);
    CHECK(session_aaa_invalidate(x.b) == ALC_OK && x.f.n_dirty == 0);
    /* phase 0 of row 1: the process cells come from the host */
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u && done == 0);
    CHECK(g_loads == 1 && g_stores == 1 && g_store_start == 1 && g_store_hour == 10 && g_store_minute == 20);
    CHECK(session_aaa_object(x.b)->time_hour == 9 && session_aaa_object(x.b)->alarm_hour == 10);
    CHECK(session_aaa_registered(x.b) == 1u && session_aaa_object(x.b)->active == 1 && session_aaa_object(x.b)->row == 1);
    CHECK(session_aaa_render(x.b, &r) == ALC_OK && r.valid == 1u && r.count == 4u);
    CHECK(session_aaa_invalidate(x.b) == ALC_OK && x.f.n_dirty == 1 && x.f.dirty_slot == 24);
    /* the pointer uses the body of the active row (row 1: the alarm button at x 10..19) */
    CHECK(session_aaa_pointer_move(x.b, 15, 4, &p) == ALC_OK && p.hit == 1u && p.candidate == 0x276e);
    CHECK(session_aaa_pointer_move(x.b, 304, 4, &p) == ALC_OK && p.hit == 0u);
    CHECK(session_aaa_pointer_move(x.b, 15, 4, &p) == ALC_OK && p.hit == 1u);
    /* the click: the start flag is reloaded from the host first (4 = sound on), the scene's bytes do not change */
    x.f.now = 3000u;
    CHECK(session_aaa_click(x.b, 2u, &c) == ALC_OK && c.fired == 0u);
    CHECK(g_loads == 2); /* the click that did not fire loaded the world as well */
    g_world_in.start_flag_5bb1ca = 0;
    CHECK(session_aaa_click(x.b, 1u, &c) == ALC_OK && c.fired == 1u && c.sound_played == 0u);
    CHECK(g_loads == 3);
    g_world_in.start_flag_5bb1ca = 4;
    CHECK(session_aaa_object(x.b)->state == ALC_STATE_PRESSED);
    CHECK(session_aaa_click(x.b, 1u, &c) == ALC_OK && c.fired == 1u && c.sound_played == 1u);
    CHECK(memcmp(x.bytes, x.bytes_before, x.bytes_len) == 0);
    CHECK(session_aaa_render(x.b, &r) == ALC_OK && r.count == 5u && r.blit[4].kind == ALC_BLIT_DOWN_ALARM);
    /* phase 1 visits write no world */
    x.f.now = 3500u;
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u && done == 0 && g_stores == 1);
    CHECK(session_aaa_object(x.b)->state == ALC_STATE_ALARM);
    /* the visit loads the cells it reads */
    CHECK(g_loads == 5);
    /* an increase, a set, the wait and the final sound, then the finish */
    CHECK(session_aaa_pointer_move(x.b, 54, 4, &p) == ALC_OK && p.hit == 1u);
    CHECK(session_aaa_click(x.b, 1u, &c) == ALC_OK && c.fired == 1u);
    x.f.now = 4000u;
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK && session_aaa_object(x.b)->alarm_hour == 11);
    CHECK(session_aaa_pointer_move(x.b, 24, 4, &p) == ALC_OK && p.hit == 1u);
    CHECK(session_aaa_click(x.b, 1u, &c) == ALC_OK && c.fired == 1u);
    x.f.now = 5000u;
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK); /* press ends -> SET */
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK); /* SET -> WAIT_SET */
    x.f.now = 9000u;
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK && session_aaa_object(x.b)->state == ALC_STATE_FINAL_SOUND);
    x.f.busy_value = 0;
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 2u && done == 0 && g_stores == 1);
    g_world_in.hour_585d51 = 3; /* the host's cells are reloaded for the finish; the alarm writes over them */
    CHECK(b_visit(&x, 1, 2u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 0u && done == 1);
    CHECK(g_stores == 2 && g_store_hour == 12 && g_store_minute == 0 && g_store_start == 0);
    CHECK(session_aaa_registered(x.b) == 0u && session_aaa_object(x.b)->active == 0 && session_aaa_object(x.b)->row == -1);
    CHECK(x.f.n_relsurf == 1 && x.f.n_relslot == 1 && x.f.n_idle == 2); /* 2: the scene begin touched the timer too */
    CHECK(strstr(x.f.log, "tr:40:1:2:3:11:22:33") != NULL);
    CHECK(g_hook_bad == 0);
    CHECK(session_aaa_render(x.b, &r) == ALC_OK && r.valid == 0u);
    bind_close(&x);
}

static void t_binding_second_row(void)
{
    Bind x;
    uint32_t ph = 0u;
    int done = 0;
    AlcPointerResult p;
    AlcRenderResult r;
    if (!bind_open(&x, 1)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_aaa_begin_scene(x.b, x.scene) == ALC_OK);
    CHECK(b_visit(&x, 2, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u);
    /* row 2 has its alarm button at x 300..309 and no button at 10..19 */
    CHECK(session_aaa_pointer_move(x.b, 15, 4, &p) == ALC_OK && p.hit == 0u);
    CHECK(session_aaa_pointer_move(x.b, 304, 4, &p) == ALC_OK && p.hit == 1u);
    CHECK(session_aaa_object(x.b)->row == 2);
    /* the render uses row 2's body: 10:20 AM shows the AM overlay, whose source rectangle differs per row */
    CHECK(session_aaa_render(x.b, &r) == ALC_OK && r.count == 4u && r.blit[0].kind == ALC_BLIT_AM && r.blit[0].src[0] == 700 &&
          r.blit[0].src[1] == 1);
    bind_close(&x);
    /* the finish of row 2 uses its own set block (scene 41) */
    CHECK(bind_open(&x, 1));
    CHECK(session_aaa_begin_scene(x.b, x.scene) == ALC_OK);
    CHECK(b_visit(&x, 2, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    {
        AlcObject *o = (AlcObject *)session_aaa_object(x.b); /* a set press is played in the other cases */
        o->set = 1u;
    }
    CHECK(g_hook_bad == 0);
    CHECK(b_visit(&x, 2, 2u, &ph, &done) == SCENE_ACTION_HANDLER_OK && done == 1);
    CHECK(strstr(x.f.log, "tr:41:1:2:3:11:22:33") != NULL && strstr(x.f.log, "tr:40:") == NULL);
    bind_close(&x);
}

static void t_binding_without_hooks(void)
{
    Bind x;
    uint32_t ph = 0u;
    int done = 0;
    AlcClickResult c;
    if (!bind_open(&x, 0)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_aaa_begin_scene(x.b, x.scene) == ALC_OK);
    /* the binding's own cells: hour 0, minute 0, start flag 0 until the handler writes them */
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u);
    CHECK(session_aaa_object(x.b)->time_hour == 11 && session_aaa_object(x.b)->time_am == 1 &&
          session_aaa_object(x.b)->alarm_hour == 11);
    {
        AlcPointerResult p;
        CHECK(session_aaa_pointer_move(x.b, 15, 4, &p) == ALC_OK && p.hit == 1u);
        /* phase 0 stored start flag 1 in the binding's cells, so the click plays its sound */
        CHECK(session_aaa_click(x.b, 1u, &c) == ALC_OK && c.fired == 1u && c.sound_played == 1u);
    }
    CHECK(g_loads == 0 && g_stores == 0);
    bind_close(&x);
}

static void t_binding_scene_change_clears(void)
{
    Bind x;
    uint32_t ph = 0u;
    int done = 0;
    if (!bind_open(&x, 1)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_aaa_begin_scene(x.b, x.scene) == ALC_OK);
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && session_aaa_registered(x.b) == 1u);
    LOGCLR(&x.f);
    /* the next scene's begin runs the previous scene's clear (0x44d154) */
    CHECK(session_aaa_begin_scene(x.b, x.scene) == ALC_OK);
    CHECK_LOG(&x.f, "relsurf:77:0,relslot:24:0,idle:0:0");
    CHECK(session_aaa_registered(x.b) == 0u && session_aaa_object(x.b)->active == 0 && session_aaa_object(x.b)->row == -1);
    /* the rows are the new scene's: the old phase-1 state is gone */
    {
        SceneActionInfo info;
        SceneActionRuntimeState st;
        SceneActionHandlerResult out;
        memset(&st, 0, sizeof st);
        st.phase = 1u;
        CHECK(scene_resource_action_at(x.scene, 1, &info) == SCENE_RESOURCE_OK);
        CHECK(session_aaa_handler(x.b, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    }
    /* a failing clear is reported and keeps the old rows */
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    x.f.fail_call = x.f.calls + 1;
    CHECK(session_aaa_begin_scene(x.b, x.scene) == ALC_ERR_HOST && strcmp(session_aaa_failure(x.b), "0xaa-scene-clear") == 0);
    x.f.fail_call = 0;
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK && session_aaa_registered(x.b) == 1u);
    /* destroying runs the clear as well */
    LOGCLR(&x.f);
    x.f.n_idle = 0;
    session_aaa_destroy(x.b);
    x.b = NULL;
    CHECK(x.f.n_idle == 1);
    scene_resource_close(x.scene);
    CHECK(session_aaa_begin_scene(NULL, NULL) == ALC_ERR_ARGUMENT);
}

static void t_binding_refuses_bad_body(void)
{
    Bind x;
    uint8_t bad[ALC_BODY_BYTES];
    const int types[3] = {0x70, 0xaa, 0xaa};
    const uint8_t one = 0;
    const uint8_t *bodies[3];
    size_t lengths[3] = {1, ALC_BODY_BYTES, ALC_BODY_BYTES};
    char err[128] = {0};
    SceneResource *bad_scene;
    static uint8_t other[8192];
    if (!bind_open(&x, 1)) {
        CHECK(0 && "scene opens");
        return;
    }
    memcpy(bad, x.body_b, ALC_BODY_BYTES);
    memset(bad, 'A', ALC_NAME_BYTES);
    bodies[0] = &one;
    bodies[1] = x.body_a;
    bodies[2] = bad;
    {
        size_t n = build_scene(other, 3, types, bodies, lengths);
        bad_scene = scene_resource_open_memory(other, n, err, sizeof err);
        CHECK(bad_scene != NULL);
        if (bad_scene != NULL) {
            CHECK(session_aaa_begin_scene(x.b, bad_scene) == ALC_ERR_BODY);
            CHECK(strcmp(session_aaa_failure(x.b), "0xaa-name-unterminated") == 0);
            scene_resource_close(bad_scene);
        }
    }
    /* the earlier good rows are not installed by a refused scene */
    {
        SceneActionInfo info;
        SceneActionRuntimeState st;
        SceneActionHandlerResult out;
        memset(&st, 0, sizeof st);
        CHECK(scene_resource_action_at(x.scene, 1, &info) == SCENE_RESOURCE_OK);
        CHECK(session_aaa_handler(x.b, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(strcmp(session_aaa_failure(x.b), "0xaa-row-not-owned") == 0);
    }
    /* rows of other types are not looked at: a 0x70 row with a one byte body was accepted above */
    CHECK(session_aaa_begin_scene(x.b, x.scene) == ALC_OK);
    CHECK(session_aaa_begin_scene(x.b, NULL) == ALC_ERR_ARGUMENT);
    bind_close(&x);
}

static void t_binding_host_error_and_args(void)
{
    Bind x;
    uint32_t ph = 0u;
    int done = 0;
    AlcPointerResult p;
    AlcRenderResult r;
    if (!bind_open(&x, 1)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_aaa_begin_scene(x.b, x.scene) == ALC_OK);
    x.f.calls = 0;
    x.f.fail_call = 1; /* the slot allocation */
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(strcmp(session_aaa_failure(x.b), "0xaa-host") == 0 && g_stores == 0);
    x.f.fail_call = 0;
    /* failed click: the failure text names the click */
    x.f.calls = 0;
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    CHECK(session_aaa_pointer_move(x.b, 15, 4, &p) == ALC_OK);
    x.f.calls = 0;
    x.f.fail_call = 1; /* the busy query */
    CHECK(session_aaa_click(x.b, 1u, NULL) == ALC_ERR_HOST && strcmp(session_aaa_failure(x.b), "0xaa-click") == 0);
    x.f.fail_call = 0;
    CHECK(session_aaa_click(x.b, 1u, NULL) == ALC_OK && strcmp(session_aaa_failure(x.b), "none") == 0);
    x.f.calls = 0;
    x.f.fail_call = 1;
    CHECK(session_aaa_render(x.b, &r) == ALC_ERR_HOST); /* the view origin */
    x.f.fail_call = 0;
    /* NULL arguments */
    CHECK(session_aaa_pointer_move(NULL, 1, 1, &p) == ALC_ERR_ARGUMENT && session_aaa_pointer_move(x.b, 1, 1, NULL) == ALC_ERR_ARGUMENT);
    CHECK(session_aaa_click(NULL, 1u, NULL) == ALC_ERR_ARGUMENT);
    CHECK(session_aaa_render(NULL, &r) == ALC_ERR_ARGUMENT && session_aaa_render(x.b, NULL) == ALC_ERR_ARGUMENT);
    CHECK(session_aaa_invalidate(NULL) == ALC_ERR_ARGUMENT);
    CHECK(session_aaa_registered(NULL) == 0u && session_aaa_object(NULL) == NULL);
    CHECK(strcmp(session_aaa_failure(NULL), "0xaa-binding-unbound") == 0);
    CHECK(session_aaa_create(NULL) == NULL);
    session_aaa_destroy(NULL);
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
    run("time_reader", t_time_reader);
    run("hour_step", t_hour_step);
    run("phase0", t_phase0);
    run("step_args", t_step_args);
    run("phase12_need_phase0", t_phase12_need_phase0);
    run("state_cancel_idle", t_state_cancel_idle);
    run("state_pressed", t_state_pressed);
    run("state_set_and_wait", t_state_set_and_wait);
    run("state_final_sound", t_state_final_sound);
    run("phase2_cancel", t_phase2_cancel);
    run("phase2_set", t_phase2_set);
    run("alarm_writer", t_alarm_writer);
    run("blocks", t_blocks);
    run("phase2_flag_refused", t_phase2_flag_refused);
    run("pointer_basics", t_pointer_basics);
    run("pointer_bounds", t_pointer_bounds);
    run("pointer_buttons", t_pointer_buttons);
    run("pointer_order", t_pointer_order);
    run("pointer_dst_rects", t_pointer_dst_rects);
    run("click", t_click);
    run("invalidate", t_invalidate);
    run("cleanup", t_cleanup);
    run("render_basics", t_render_basics);
    run("render_modes", t_render_modes);
    run("render_buttons", t_render_buttons);
    run("render_bounds", t_render_bounds);
    run("host_failure_sweep", t_host_failure_sweep);
    run("host_failure_effects", t_host_failure_effects);
    run("playthrough_set", t_playthrough_set);
    run("playthrough_cancel", t_playthrough_cancel);
    run("binding_flow", t_binding_flow);
    run("binding_second_row", t_binding_second_row);
    run("binding_without_hooks", t_binding_without_hooks);
    run("binding_scene_change_clears", t_binding_scene_change_clears);
    run("binding_refuses_bad_body", t_binding_refuses_bad_body);
    run("binding_host_error_and_args", t_binding_host_error_and_args);
    printf("TOTAL %d FAILED %d\n", g_total, g_failures);
    return g_failures;
}
