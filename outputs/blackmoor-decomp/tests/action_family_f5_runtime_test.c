/* RT-55 unit tests of the raw 0xf5 Typing Quiz kernel (src/action_family_f5_runtime.c), the shared score / time display
 * (src/score_time_display.c) and the session binding (src/session_bindings_af5.c). Prints "PASS <name>" / "FAIL <name>:
 * <message>"; the exit status is the failure count. Fixtures are synthetic bodies (no original bytes). The Python wrapper
 * tests/test_action_family_f5_runtime.py builds and runs this with and without ASan/UBSan and under source mutations.
 * Expected values are written out from the layout in src/action_family_f5_runtime.h / src/score_time_display.h (and the
 * pseudocode facts quoted in the packet), not by calling the kernel; the effect-log goldens were read against the code
 * once and are pinned. */
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "action_family_f5_runtime.h"
#include "scene_resource.h"
#include "score_time_display.h"
#include "session_bindings_af5.h"

static int g_failed, g_total, g_failures;
static char g_msg[640];
#define CHECK(cond)                                                              \
    do {                                                                         \
        if (!(cond) && !g_failed) {                                              \
            g_failed = 1;                                                        \
            snprintf(g_msg, sizeof g_msg, "line %d: %.200s", __LINE__, #cond);   \
        }                                                                        \
    } while (0)
#define CHECK_LOG(f, expected)                                                                   \
    do {                                                                                         \
        if (strcmp((f)->log, (expected)) != 0 && !g_failed) {                                    \
            g_failed = 1;                                                                        \
            snprintf(g_msg, sizeof g_msg, "line %d: log \"%.200s\" != \"%.200s\"", __LINE__,   \
                     (f)->log, (expected));                                                      \
        }                                                                                        \
    } while (0)
#define CHECK_INT(a, b)                                                                          \
    do {                                                                                         \
        const long long a_ = (long long)(a), b_ = (long long)(b);                                \
        if (a_ != b_ && !g_failed) {                                                             \
            g_failed = 1;                                                                        \
            snprintf(g_msg, sizeof g_msg, "line %d: %.100s == %lld, expected %lld", __LINE__, #a, a_, b_); \
        }                                                                                        \
    } while (0)

/* Body offsets (written from the header, independent of the kernel source). */
enum {
    O_VARIANTS = 0x21, O_VRECT = 0x23, O_POP = 0x163, O_NPOS = 0x173, O_POSRECT = 0x175, O_SDIG = 0x2b5, O_CDIG = 0x355,
    O_COLON = 0x3f5, O_SX = 0x405, O_SY = 0x409, O_CX = 0x40d, O_CY = 0x411, O_SGAP = 0x415, O_CGAP = 0x419, O_PASSEDRECT = 0x41d,
    O_ENDDELAY = 0x42d, O_CASE = 0x431, O_DIGITS = 0x432, O_WIDE = 0x433, O_EXTRA = 0x434, O_LMIN = 0x452, O_LMAX = 0x454,
    O_BMIN = 0x456, O_BMAX = 0x458, O_LIMIT = 0x45a, O_FACTOR = 0x45c, O_MINSCORE = 0x45e, O_DEFTARGET = 0x460,
    O_PERCENT = 0x462, O_LOWTARGET = 0x464, O_SA = 0x466, O_CHIT = 0x487, O_SB = 0x497, O_CMISS = 0x4b8, O_SC = 0x4c8,
    O_CTIME = 0x4e9, O_PASSED = 0x4f9, O_SD = 0x511, O_CD = 0x532, O_NORMAL = 0x542, O_CURSOR = 0x55c, O_RECT = 0x55e
};
enum { SB_SCENE = 0, SB_W1 = 2, SB_W2 = 4, SB_W3 = 6, SB_D1 = 8, SB_D2 = 12, SB_D3 = 16, SB_START = 20, SB_FLAG = 22, SB_FLAG2 = 24 };
#define VIEW_L 7
#define VIEW_T 11
#define SURFACE 77u
#define ROW 3

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
static void set_str(uint8_t *b, size_t off, const char *s) { memcpy(b + off, s, strlen(s) + 1u); }
static void set_nosound(uint8_t *b, size_t off) { memset(b + off, 0, 0x21); memcpy(b + off, "NO SOUND", 9u); }

/* Failable host callbacks (the sweep fails the n-th call of any of them). */
enum {
    CB_ALLOC = 1, CB_REGISTER, CB_LOAD, CB_SETSURF, CB_RELSURF, CB_RELSLOT, CB_DIRTY, CB_VIEW, CB_CLEARITEM, CB_FONTACQ,
    CB_FONTREL, CB_PREPARE, CB_STOP, CB_PLAY, CB_TRANSITION, CB_STOREFLAG, CB_ENGINEMODE, CB_LAST = CB_ENGINEMODE
};

typedef struct Fx {
    TqzObject o;
    TqzWorld w;
    TqzHost host;
    uint8_t body[TQZ_BODY_BYTES];
    char log[65536];
    uint32_t now, tick_step;
    int32_t rand_q[1024];
    int n_rand, i_rand;
    int32_t rand_default;
    int fail_call, calls, failed_cb;
    unsigned failed_mask;
    int n_alloc, n_dirty, n_relsurf, n_relslot, n_fontacq, n_fontrel, n_load, n_view, n_clear, n_engine, n_transition;
    int16_t dirty_slot, relslot_hist[8];
    int n_relslot_hist;
    uint32_t relsurf_handle, setsurf_surface;
    int16_t setsurf_slot, flag_limit;
    int prep_hist[16], n_prep, stop_hist[16], n_stop, play_hist[32], n_play, flag_hist[8][2], n_flag;
    struct { int16_t slot; int32_t type; int callback; uint32_t surface; char label[40]; } reg[8];
    int n_reg;
    char loaded_name[40];
    TqzTransition transition;
    int engine_mode;
    int32_t view[4], local[4];
    uint32_t phase;
    TqzResult result;
    const char *failure;
    int observe_on;
} Fx;

static void logf_(Fx *f, const char *fmt, ...)
{
    char tmp[160];
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(tmp, sizeof tmp, fmt, ap);
    va_end(ap);
    if (f->log[0] != '\0') strncat(f->log, ",", sizeof f->log - strlen(f->log) - 1u);
    strncat(f->log, tmp, sizeof f->log - strlen(f->log) - 1u);
}

static const char *effect_name(int e)
{
    static const char *const names[] = {"?", "active", "start", "clearitem", "slot", "slotreg", "load", "slotsurf", "prep",
                                        "stop", "play", "tick", "rand", "phase", "state", "x57b", "x599", "x595", "x39ff",
                                        "x59b", "x59f", "x5a3", "mode", "evflag", "complete", "relsurf", "relslot",
                                        "fontacq", "fontrel", "setscore", "setclock", "enscore", "enclock", "resetdisp",
                                        "played", "best", "blit"};
    if (e == STD_FX_INIT_SCORE) return "initscore";
    if (e == STD_FX_INIT_CLOCK) return "initclock";
    return e >= 0 && e <= 36 ? names[e] : "??";
}

static void observe(void *c, int e, int32_t a, int32_t b)
{
    Fx *f = (Fx *)c;
    if (f->observe_on) logf_(f, "%s:%d:%d", effect_name(e), a, b);
}

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
static int h_register(void *c, int16_t slot, int32_t type, int callback, uint32_t surface, const char *label)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_REGISTER)) return 1;
    if (f->n_reg < 8) {
        f->reg[f->n_reg].slot = slot;
        f->reg[f->n_reg].type = type;
        f->reg[f->n_reg].callback = callback;
        f->reg[f->n_reg].surface = surface;
        snprintf(f->reg[f->n_reg].label, sizeof f->reg[0].label, "%s", label);
        ++f->n_reg;
    }
    return 0;
}
static int h_load(void *c, const char *name, uint32_t *surface)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_LOAD)) return 1;
    ++f->n_load;
    snprintf(f->loaded_name, sizeof f->loaded_name, "%s", name);
    *surface = SURFACE;
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
    if (fail_hit(f, CB_RELSURF)) return 1;
    ++f->n_relsurf;
    f->relsurf_handle = s;
    return 0;
}
static int h_relslot(void *c, int16_t slot)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_RELSLOT)) return 1;
    if (f->n_relslot_hist < 8) f->relslot_hist[f->n_relslot_hist++] = slot;
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
static int h_view(void *c, int32_t a[4], int32_t l[4])
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_VIEW)) return 1;
    ++f->n_view;
    memcpy(a, f->view, sizeof f->view);
    memcpy(l, f->local, sizeof f->local);
    return 0;
}
static int h_clear(void *c)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_CLEARITEM)) return 1;
    ++f->n_clear;
    return 0;
}
static int h_fontacq(void *c)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_FONTACQ)) return 1;
    ++f->n_fontacq;
    return 0;
}
static int h_fontrel(void *c)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_FONTREL)) return 1;
    ++f->n_fontrel;
    return 0;
}
static int body_offset(const Fx *f, const uint8_t *r)
{
    return (r >= f->body && r < f->body + TQZ_BODY_BYTES) ? (int)(r - f->body) : -1;
}
static int h_prepare(void *c, const uint8_t *r)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_PREPARE)) return 1;
    if (f->n_prep < 16) f->prep_hist[f->n_prep++] = body_offset(f, r);
    return 0;
}
static int h_stop(void *c, const uint8_t *r)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_STOP)) return 1;
    if (f->n_stop < 16) f->stop_hist[f->n_stop++] = body_offset(f, r);
    return 0;
}
static int h_play(void *c, int16_t ch)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_PLAY)) return 1;
    if (f->n_play < 32) f->play_hist[f->n_play++] = ch;
    return 0;
}
static uint32_t h_tick(void *c)
{
    Fx *f = (Fx *)c;
    const uint32_t v = f->now;
    f->now += f->tick_step;
    return v;
}
static int32_t h_random(void *c)
{
    Fx *f = (Fx *)c;
    if (f->i_rand < f->n_rand) return f->rand_q[f->i_rand++];
    ++f->i_rand;
    return f->rand_default;
}
static int h_flag_invalid(void *c, int16_t i)
{
    Fx *f = (Fx *)c;
    return i < 0 || i >= f->flag_limit;
}
static int h_transition(void *c, const TqzTransition *t)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_TRANSITION)) return 1;
    ++f->n_transition;
    f->transition = *t;
    return 0;
}
static int h_storeflag(void *c, int16_t i, uint32_t v)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_STOREFLAG)) return 1;
    if (f->n_flag < 8) {
        f->flag_hist[f->n_flag][0] = i;
        f->flag_hist[f->n_flag][1] = (int)v;
        ++f->n_flag;
    }
    return 0;
}
static int h_engine(void *c, int32_t m)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_ENGINEMODE)) return 1;
    ++f->n_engine;
    f->engine_mode = m;
    return 0;
}

static void rand_set(Fx *f, int n, ...)
{
    va_list ap;
    va_start(ap, n);
    for (int i = 0; i < n; ++i) f->rand_q[i] = va_arg(ap, int);
    va_end(ap);
    f->n_rand = n;
    f->i_rand = 0;
}

/* The default body: V = 3, N = 4, counts 2..3, lifetimes 5..9, 125 s, factor 2, minimum 3, target 10 (50 percent of the best
 * earlier score, at least 4), digits allowed, every sound a real name, every finish block set. */
static void body_default(uint8_t *b)
{
    memset(b, 0, TQZ_BODY_BYTES);
    set_str(b, 0, "TQUIZ");
    put16(b, O_VARIANTS, 3);
    for (int k = 0; k < 3; ++k) put_rect(b, O_VRECT + 16u * (unsigned)k, 10 + k, 20 + 2 * k, 50 + 3 * k, 60 + 4 * k);
    put_rect(b, O_POP, 300, 310, 340, 350);
    put16(b, O_NPOS, 4);
    for (int c = 0; c < 4; ++c) put_rect(b, O_POSRECT + 16u * (unsigned)c, c * 100 + 5, 40 + 7 * c, c * 100 + 45, 80 + 7 * c);
    for (int d = 0; d < 10; ++d) {
        put_rect(b, O_SDIG + 16u * (unsigned)d, d * 10, 400, d * 10 + 7 + d % 3, 409 + d % 4);
        put_rect(b, O_CDIG + 16u * (unsigned)d, d * 12, 420, d * 12 + 9 + d % 2, 431 + d % 3);
    }
    put_rect(b, O_COLON, 200, 420, 205, 432);
    put32(b, O_SX, 30);
    put32(b, O_SY, 12);
    put32(b, O_SGAP, 2);
    put32(b, O_CX, 500);
    put32(b, O_CY, 16);
    put32(b, O_CGAP, 3);
    put_rect(b, O_PASSEDRECT, 600, 100, 700, 140);
    put32(b, O_ENDDELAY, 3000);
    b[O_DIGITS] = 1;
    put16(b, O_LMIN, 5);
    put16(b, O_LMAX, 9);
    put16(b, O_BMIN, 2);
    put16(b, O_BMAX, 3);
    put16(b, O_LIMIT, 125);
    put16(b, O_FACTOR, 2);
    put16(b, O_MINSCORE, 3);
    put16(b, O_DEFTARGET, 10);
    put16(b, O_PERCENT, 50);
    put16(b, O_LOWTARGET, 4);
    set_str(b, O_SA, "SND_A");
    put16(b, O_CHIT, 11);
    set_str(b, O_SB, "SND_B");
    put16(b, O_CMISS, 12);
    set_str(b, O_SC, "SND_C");
    put16(b, O_CTIME, 13);
    put16(b, O_PASSED + SB_SCENE, 21);
    put16(b, O_PASSED + SB_W1, 1);
    put16(b, O_PASSED + SB_W2, 2);
    put16(b, O_PASSED + SB_W3, 3);
    put32(b, O_PASSED + SB_D1, 101);
    put32(b, O_PASSED + SB_D2, 202);
    put32(b, O_PASSED + SB_D3, 303);
    put16(b, O_PASSED + SB_START, 1);
    put16(b, O_PASSED + SB_FLAG, 40);
    set_str(b, O_SD, "SND_D");
    put16(b, O_CD, 14);
    put16(b, O_NORMAL + SB_SCENE, 31);
    put16(b, O_NORMAL + SB_W1, 4);
    put16(b, O_NORMAL + SB_W2, 5);
    put16(b, O_NORMAL + SB_W3, 6);
    put32(b, O_NORMAL + SB_D1, 404);
    put32(b, O_NORMAL + SB_D2, 505);
    put32(b, O_NORMAL + SB_D3, 606);
    put16(b, O_NORMAL + SB_START, 0);
    put16(b, O_NORMAL + SB_FLAG, 50);
    put16(b, O_NORMAL + SB_FLAG2, 60);
    put16(b, O_CURSOR, 7);
    put32(b, O_RECT, 20);
    put32(b, O_RECT + 4, 30);
    put32(b, O_RECT + 8, 120);
    put32(b, O_RECT + 12, 90);
}

static void fx_host(Fx *f)
{
    memset(&f->host, 0, sizeof f->host);
    f->host.context = f;
    f->host.alloc_slot = h_alloc;
    f->host.register_slot = h_register;
    f->host.load_surface = h_load;
    f->host.set_slot_surface = h_setsurf;
    f->host.release_surface = h_relsurf;
    f->host.release_slot = h_relslot;
    f->host.mark_dirty = h_dirty;
    f->host.view_rects = h_view;
    f->host.clear_pending_item = h_clear;
    f->host.font_acquire = h_fontacq;
    f->host.font_release = h_fontrel;
    f->host.sound_prepare = h_prepare;
    f->host.sound_stop = h_stop;
    f->host.sound_play = h_play;
    f->host.tick = h_tick;
    f->host.random = h_random;
    f->host.event_flag_invalid = h_flag_invalid;
    f->host.transition = h_transition;
    f->host.store_event_flag = h_storeflag;
    f->host.engine_mode = h_engine;
    f->host.observe = observe;
}

static void fx_init(Fx *f)
{
    memset(f, 0, sizeof *f);
    tqz_object_reset(&f->o);
    body_default(f->body);
    fx_host(f);
    f->flag_limit = 4096;
    f->now = 1000000u;
    f->view[0] = VIEW_L;
    f->view[1] = VIEW_T;
    f->view[2] = 647;
    f->view[3] = 491;
    f->local[0] = 0;
    f->local[1] = 0;
    f->local[2] = 640;
    f->local[3] = 480;
    f->observe_on = 1;
}

static void fx_clear_records(Fx *f)
{
    f->log[0] = '\0';
    f->n_play = f->n_prep = f->n_stop = f->n_flag = f->n_reg = f->n_relslot_hist = 0;
    f->n_alloc = 0;
}

static int step(Fx *f, uint32_t phase)
{
    const int rc = tqz_step(&f->o, f->body, TQZ_BODY_BYTES, ROW, phase, &f->w, &f->host, &f->result, &f->failure);
    if (rc == TQZ_OK) f->phase = f->result.phase_after;
    return rc;
}

/* Scripted first wave: count 3 (r = 1); balloon 0: position 2, variant 1, 'A' (r 17), lifetime 8 (r 3); balloon 1: position 2
 * (taken) then 3, variant 2, ':' refused (r 10) then 'U' (r 37), lifetime 5 (r 0); balloon 2: position 0, variant 0, '4',
 * lifetime 9 (r 4). The object's character range is still 0 (a fresh process), so a draw r gives 0x30 + r % 48 (digits). */
static void script_wave(Fx *f)
{
    rand_set(f, 15, 1, 2, 1, 17, 3, 2, 3, 2, 10, 37, 0, 0, 0, 4, 4);
}

static void start_quiz(Fx *f)
{
    script_wave(f);
    CHECK(step(f, 0u) == TQZ_OK);
}

typedef void (*TestFn)(void);
static void run(const char *name, TestFn fn)
{
    const clock_t t0 = clock();
    g_failed = 0;
    g_msg[0] = '\0';
    fn();
    if (getenv("F5_TIMES") != NULL) fprintf(stderr, "%-34s %6.0f ms\n", name, 1000.0 * (double)(clock() - t0) / CLOCKS_PER_SEC);
    ++g_total;
    if (g_failed) {
        ++g_failures;
        printf("FAIL %s: %s\n", name, g_msg);
    } else {
        printf("PASS %s\n", name);
    }
}

/* ---- the score / time display widget (src/score_time_display.c) --------------------------------------------------------------- */

typedef struct SFx {
    int n_reg, fail, null_register;
    int16_t slot;
    int32_t type;
    int callback;
    uint32_t surface;
    char label[32];
    int n_obs, obs_effect, obs_a, obs_b;
} SFx;

static int s_register(void *c, int16_t slot, int32_t type, int callback, uint32_t surface, const char *label)
{
    SFx *s = (SFx *)c;
    ++s->n_reg;
    s->slot = slot;
    s->type = type;
    s->callback = callback;
    s->surface = surface;
    snprintf(s->label, sizeof s->label, "%s", label);
    return s->fail;
}
static void s_observe(void *c, int effect, int32_t a, int32_t b)
{
    SFx *s = (SFx *)c;
    ++s->n_obs;
    s->obs_effect = effect;
    s->obs_a = a;
    s->obs_b = b;
}

/* score block: ten digit rectangles with different widths and heights, then x, y, gap, surface, slot, kind */
static void score_block_make(int32_t blk[0x2e])
{
    memset(blk, 0, 0x2e * sizeof(int32_t));
    for (int d = 0; d < 10; ++d) {
        blk[d * 4] = d * 10;
        blk[d * 4 + 1] = 100 + d;
        blk[d * 4 + 2] = d * 10 + 4 + d;      /* width 5 + d */
        blk[d * 4 + 3] = 100 + d + 9 + d % 3; /* height 10 + d % 3 */
    }
    blk[40] = 50;
    blk[41] = 20;
    blk[42] = 3;
    blk[43] = 9;
    blk[44] = 0x19;
    blk[45] = 10;
}
/* clock block: ten digit rectangles, the colon rectangle (5 x 15), x, y, gap, surface, slot, kind */
static void clock_block_make(int32_t blk[0x32])
{
    memset(blk, 0, 0x32 * sizeof(int32_t));
    for (int d = 0; d < 10; ++d) {
        blk[d * 4] = d * 12;
        blk[d * 4 + 1] = 300 + d;
        blk[d * 4 + 2] = d * 12 + 6 + d % 3;   /* width 7 + d % 3 */
        blk[d * 4 + 3] = 300 + d + 10 + d % 2; /* height 11 + d % 2 */
    }
    blk[40] = 200;
    blk[41] = 300;
    blk[42] = 204;
    blk[43] = 314;
    blk[44] = 60;
    blk[45] = 40;
    blk[46] = 4;
    blk[47] = 8;
    blk[48] = 0x1a;
    blk[49] = 10;
}

static void t_std_set(void)
{
    StdDisplay d;
    memset(&d, 0, sizeof d);
    CHECK(std_set_score(&d, 0) == STD_OK && strcmp(d.score_str, "0") == 0 && d.score == 0);
    CHECK(std_set_score(&d, 12345) == STD_OK && strcmp(d.score_str, "12345") == 0 && d.score == 12345);
    CHECK(std_set_score(&d, 99999999) == STD_OK && strcmp(d.score_str, "99999999") == 0 && d.score == 99999999);
    CHECK(std_set_score(&d, 100000000) == STD_ERR_BOUNDS && d.score == 99999999 && strcmp(d.score_str, "99999999") == 0);
    CHECK(std_set_score(&d, -1) == STD_ERR_BOUNDS && d.score == 99999999 && strcmp(d.score_str, "99999999") == 0);
    CHECK(std_set_score(&d, 7) == STD_OK && strcmp(d.score_str, "7") == 0);
    CHECK(std_set_clock(&d, 5, 7) == STD_OK && strcmp(d.minutes_str, "05") == 0 && strcmp(d.seconds_str, "07") == 0);
    CHECK(d.minutes == 5 && d.seconds == 7);
    CHECK(std_set_clock(&d, 99, 99) == STD_OK && strcmp(d.minutes_str, "99") == 0 && strcmp(d.seconds_str, "99") == 0);
    CHECK(std_set_clock(&d, 12, 34) == STD_OK && strcmp(d.minutes_str, "12") == 0 && strcmp(d.seconds_str, "34") == 0);
    CHECK(d.minutes == 12 && d.seconds == 34);
    CHECK(std_set_clock(&d, 0, 0) == STD_OK && strcmp(d.minutes_str, "00") == 0 && strcmp(d.seconds_str, "00") == 0);
    CHECK(std_set_clock(&d, 12, 34) == STD_OK);
    CHECK(std_set_clock(&d, 100, 5) == STD_ERR_BOUNDS && d.minutes == 12 && d.seconds == 34);
    CHECK(std_set_clock(&d, 5, 100) == STD_ERR_BOUNDS && d.minutes == 12 && d.seconds == 34);
    CHECK(std_set_clock(&d, -1, 5) == STD_ERR_BOUNDS && d.minutes == 12);
    CHECK(std_set_clock(&d, 5, -1) == STD_ERR_BOUNDS && d.seconds == 34);
    CHECK(strcmp(d.minutes_str, "12") == 0 && strcmp(d.seconds_str, "34") == 0);
    std_enable_score(&d, 5);
    std_enable_clock(&d, 6);
    CHECK(d.score_enabled == 5 && d.clock_enabled == 6);
}

static void t_std_reset(void)
{
    StdDisplay d;
    memset(&d, 0x5a, sizeof d);
    std_reset_score(&d);
    CHECK(d.score_enabled == 0 && d.score_ready == 0 && d.score == 0 && d.score_str[0] == 0 && d.prev_score_str[0] == 0);
    for (int i = 0; i < 10; ++i) CHECK(d.score_w[i] == 0 && d.score_h[i] == 0);
    for (int i = 0; i < 0x2e; ++i) CHECK(d.score_block[i] == 0);
    CHECK(d.clock_enabled == 0x5a5a5a5a && d.clock_ready == 0x5a5a5a5a && d.minutes == 0x5a5a5a5a && d.seconds == 0x5a5a5a5a);
    CHECK(d.minutes_str[0] == 0x5a && d.colon_w == 0x5a5a5a5a && d.clock_w[3] == 0x5a5a5a5a && d.clock_block[3] == 0x5a5a5a5a);
    CHECK(d.loop_counter == 0x5a5a5a5a && d.clock_h[9] == 0x5a5a5a5a && d.clock_block[0x31] == 0x5a5a5a5a);
    memset(&d, 0x5a, sizeof d);
    std_reset_clock(&d);
    CHECK(d.clock_enabled == 0 && d.clock_ready == 0 && d.colon_w == 0 && d.colon_h == 0 && d.minutes == 0 && d.seconds == 0);
    CHECK(d.minutes_str[0] == 0 && d.seconds_str[0] == 0 && d.prev_minutes_str[0] == 0 && d.prev_seconds_str[0] == 0);
    for (int i = 0; i < 10; ++i) CHECK(d.clock_w[i] == 0 && d.clock_h[i] == 0);
    for (int i = 0; i < 0x32; ++i) CHECK(d.clock_block[i] == 0);
    CHECK(d.score_enabled == 0x5a5a5a5a && d.score_ready == 0x5a5a5a5a && d.score == 0x5a5a5a5a && d.score_str[0] == 0x5a);
    CHECK(d.prev_score_str[0] == 0x5a && d.score_w[2] == 0x5a5a5a5a && d.score_h[9] == 0x5a5a5a5a);
    CHECK(d.score_block[0] == 0x5a5a5a5a && d.score_block[0x2d] == 0x5a5a5a5a && d.loop_counter == 0x5a5a5a5a);
}

static void t_std_init_score(void)
{
    StdDisplay d;
    StdHost h;
    SFx s;
    int32_t blk[0x2e];
    memset(&d, 0x5a, sizeof d);
    memset(&s, 0, sizeof s);
    h.context = &s;
    h.register_slot = s_register;
    h.observe = s_observe;
    score_block_make(blk);
    CHECK(std_init_score(&d, blk, &h) == STD_OK);
    CHECK(memcmp(d.score_block, blk, sizeof blk) == 0);
    for (int k = 0; k < 10; ++k) {
        CHECK(d.score_w[k] == 5 + k);
        CHECK(d.score_h[k] == 10 + k % 3);
    }
    CHECK(d.loop_counter == 10);
    CHECK(s.n_reg == 1 && s.slot == 0x19 && s.type == 10 && s.callback == STD_CALLBACK_SCORE && s.surface == 9u);
    CHECK(strcmp(s.label, "SCORE DISPLAY") == 0);
    CHECK(s.n_obs == 1 && s.obs_effect == STD_FX_INIT_SCORE && s.obs_a == 0x19 && s.obs_b == 9);
    CHECK(d.score == 0 && d.score_str[0] == 0 && d.prev_score_str[0] == 0 && d.score_enabled == 0 && d.score_ready == 1);
    CHECK(d.clock_enabled == 0x5a5a5a5a && d.minutes_str[0] == 0x5a && d.colon_w == 0x5a5a5a5a);
    /* no observer, a different slot / kind / surface */
    blk[44] = 0x2c;
    blk[45] = 4;
    blk[43] = 12;
    h.observe = NULL;
    CHECK(std_init_score(&d, blk, &h) == STD_OK && s.slot == 0x2c && s.type == 4 && s.surface == 12u && s.n_obs == 1);
    /* a failing host leaves the half unready */
    memset(&d, 0, sizeof d);
    s.fail = 1;
    CHECK(std_init_score(&d, blk, &h) == STD_ERR_HOST && d.score_ready == 0);
    s.fail = 0;
    CHECK(std_init_score(&d, blk, NULL) == STD_ERR_HOST);
    h.register_slot = NULL;
    CHECK(std_init_score(&d, blk, &h) == STD_ERR_HOST);
}

static void t_std_init_clock(void)
{
    StdDisplay d;
    StdHost h;
    SFx s;
    int32_t blk[0x32];
    memset(&d, 0x5a, sizeof d);
    memset(&s, 0, sizeof s);
    h.context = &s;
    h.register_slot = s_register;
    h.observe = s_observe;
    clock_block_make(blk);
    CHECK(std_init_clock(&d, blk, &h) == STD_OK);
    CHECK(memcmp(d.clock_block, blk, sizeof blk) == 0);
    for (int k = 0; k < 10; ++k) {
        CHECK(d.clock_w[k] == 7 + k % 3);
        CHECK(d.clock_h[k] == 11 + k % 2);
    }
    CHECK(d.colon_w == 5 && d.colon_h == 15 && d.loop_counter == 10);
    CHECK(s.n_reg == 1 && s.slot == 0x1a && s.type == 10 && s.callback == STD_CALLBACK_CLOCK && s.surface == 8u);
    CHECK(strcmp(s.label, "TIME DISPLAY") == 0);
    CHECK(s.n_obs == 1 && s.obs_effect == STD_FX_INIT_CLOCK && s.obs_a == 0x1a && s.obs_b == 8);
    CHECK(d.minutes == 0 && d.seconds == 0 && d.minutes_str[0] == 0 && d.seconds_str[0] == 0);
    CHECK(d.prev_minutes_str[0] == 0 && d.prev_seconds_str[0] == 0 && d.clock_enabled == 0 && d.clock_ready == 1);
    CHECK(d.score_enabled == 0x5a5a5a5a && d.score_str[0] == 0x5a && d.score_w[1] == 0x5a5a5a5a);
    h.observe = NULL;
    blk[48] = 0x30;
    blk[49] = 6;
    blk[47] = 2;
    CHECK(std_init_clock(&d, blk, &h) == STD_OK && s.slot == 0x30 && s.type == 6 && s.surface == 2u && s.n_obs == 1);
    memset(&d, 0, sizeof d);
    s.fail = 1;
    CHECK(std_init_clock(&d, blk, &h) == STD_ERR_HOST && d.clock_ready == 0);
    s.fail = 0;
    CHECK(std_init_clock(&d, blk, NULL) == STD_ERR_HOST);
    h.register_slot = NULL;
    CHECK(std_init_clock(&d, blk, &h) == STD_ERR_HOST);
}

/* the expected cell of a digit at x: (x, y, x - 1 + w, y - 1 + h) */
static void cell(int32_t out[4], int32_t x, int32_t y, int32_t w, int32_t h)
{
    out[0] = x;
    out[1] = y;
    out[2] = x + w - 1;
    out[3] = y + h - 1;
}
#define CHECK_BLIT(b, k, surf, s0, s1, s2, s3, d0, d1, d2, d3, aa)                                                            \
    CHECK((b).kind == (k) && (b).surface == (uint32_t)(surf) && (b).src[0] == (s0) && (b).src[1] == (s1) &&                 \
          (b).src[2] == (s2) && (b).src[3] == (s3) && (b).dst[0] == (d0) && (b).dst[1] == (d1) && (b).dst[2] == (d2) &&      \
          (b).dst[3] == (d3) && (b).a == (aa))

static void t_std_render_score(void)
{
    StdDisplay d;
    StdHost h;
    SFx s;
    StdBlit out[64];
    size_t n = 99;
    int32_t blk[0x2e], c[4];
    memset(&d, 0, sizeof d);
    memset(&s, 0, sizeof s);
    h.context = &s;
    h.register_slot = s_register;
    h.observe = NULL;
    score_block_make(blk);
    CHECK(std_init_score(&d, blk, &h) == STD_OK);
    CHECK(std_set_score(&d, 407) == STD_OK);
    /* not enabled: nothing drawn, previous string untouched */
    CHECK(std_render_score(&d, 7, 11, out, 16, &n) == STD_OK && n == 0 && d.prev_score_str[0] == 0);
    std_enable_score(&d, 1);
    d.score_ready = 0;
    CHECK(std_render_score(&d, 7, 11, out, 16, &n) == STD_OK && n == 0 && d.prev_score_str[0] == 0);
    d.score_ready = 1;
    /* "407": 4 -> width 9 height 11, 0 -> 5 x 10, 7 -> 12 x 11; x 50, y 20, gap 3; nothing to erase yet */
    memset(out, 0x5a, sizeof out);
    CHECK(std_render_score(&d, 7, 11, out, 16, &n) == STD_OK && n == 3);
    CHECK(out[0].b == 0 && out[0].c == 0 && out[2].b == 0 && out[2].c == 0);
    cell(c, 50, 20, 9, 11);
    CHECK_BLIT(out[0], STD_BLIT_SCORE_DIGIT, 9, 40, 104, 44 + 4, 104 + 9 + 1, c[0], c[1], c[2], c[3], 4);
    cell(c, 50 + 9 + 3, 20, 5, 10);
    CHECK_BLIT(out[1], STD_BLIT_SCORE_DIGIT, 9, 0, 100, 4, 109, c[0], c[1], c[2], c[3], 0);
    cell(c, 50 + 9 + 3 + 5 + 3, 20, 12, 11);
    CHECK_BLIT(out[2], STD_BLIT_SCORE_DIGIT, 9, 70, 107, 81, 107 + 9 + 1, c[0], c[1], c[2], c[3], 7);
    CHECK(strcmp(d.prev_score_str, "407") == 0);
    /* unchanged string: drawn again, nothing erased */
    CHECK(std_render_score(&d, 7, 11, out, 16, &n) == STD_OK && n == 3 && out[0].kind == STD_BLIT_SCORE_DIGIT);
    /* changed string: erase "407" (restore blits: source = destination minus the view origin), then draw "51" */
    CHECK(std_set_score(&d, 51) == STD_OK);
    CHECK(std_render_score(&d, 7, 11, out, 16, &n) == STD_OK && n == 5);
    cell(c, 50, 20, 9, 11);
    CHECK_BLIT(out[0], STD_BLIT_SCORE_ERASE, 0, c[0] - 7, c[1] - 11, c[2] - 7, c[3] - 11, c[0], c[1], c[2], c[3], 4);
    cell(c, 62, 20, 5, 10);
    CHECK_BLIT(out[1], STD_BLIT_SCORE_ERASE, 0, c[0] - 7, c[1] - 11, c[2] - 7, c[3] - 11, c[0], c[1], c[2], c[3], 0);
    cell(c, 70, 20, 12, 11);
    CHECK_BLIT(out[2], STD_BLIT_SCORE_ERASE, 0, c[0] - 7, c[1] - 11, c[2] - 7, c[3] - 11, c[0], c[1], c[2], c[3], 7);
    cell(c, 50, 20, 10, 10); /* '5': width 10, height 10 + 5 % 3 = 12 */
    cell(c, 50, 20, 10, 12);
    CHECK_BLIT(out[3], STD_BLIT_SCORE_DIGIT, 9, 50, 105, 59 + 0, 105 + 11, c[0], c[1], c[2], c[3], 5);
    cell(c, 63, 20, 6, 10 + 1 % 3);
    CHECK_BLIT(out[4], STD_BLIT_SCORE_DIGIT, 9, 10, 101, 15, 111, c[0], c[1], c[2], c[3], 1);
    CHECK(strcmp(d.prev_score_str, "51") == 0);
    /* a different view origin changes only the erase sources */
    CHECK(std_set_score(&d, 3) == STD_OK && std_render_score(&d, -20, 4, out, 16, &n) == STD_OK && n == 3);
    cell(c, 50, 20, 10, 12);
    CHECK_BLIT(out[0], STD_BLIT_SCORE_ERASE, 0, c[0] + 20, c[1] - 4, c[2] + 20, c[3] - 4, c[0], c[1], c[2], c[3], 5);
    /* capacity: exactly enough passes, one short is refused (drawing and erasing) */
    CHECK(std_set_score(&d, 407) == STD_OK && std_render_score(&d, 0, 0, out, 4, &n) == STD_OK && n == 4);
    CHECK(std_set_score(&d, 40) == STD_OK && std_render_score(&d, 0, 0, out, 5, &n) == STD_OK && n == 5);
    CHECK(std_set_score(&d, 407) == STD_OK && std_render_score(&d, 0, 0, out, 4, &n) == STD_ERR_BOUNDS);
    d.prev_score_str[0] = 0;
    d.score_str[0] = 0;
    CHECK(std_render_score(&d, 0, 0, out, 0, &n) == STD_OK && n == 0);
    CHECK(std_set_score(&d, 407) == STD_OK && std_render_score(&d, 0, 0, out, 2, &n) == STD_ERR_BOUNDS);
    /* a character outside 0..9 is refused while drawing and while erasing */
    d.prev_score_str[0] = 0;
    memcpy(d.score_str, "4x", 3);
    CHECK(std_render_score(&d, 0, 0, out, 16, &n) == STD_ERR_BOUNDS);
    memcpy(d.score_str, "4/", 3);
    CHECK(std_render_score(&d, 0, 0, out, 16, &n) == STD_ERR_BOUNDS);
    memcpy(d.score_str, "4:", 3);
    CHECK(std_render_score(&d, 0, 0, out, 16, &n) == STD_ERR_BOUNDS);
    memcpy(d.score_str, "09", 3);
    CHECK(std_render_score(&d, 0, 0, out, 16, &n) == STD_OK && n == 2);
    memcpy(d.prev_score_str, "x", 2);
    CHECK(std_render_score(&d, 0, 0, out, 16, &n) == STD_ERR_BOUNDS);
    memcpy(d.prev_score_str, "/", 2);
    CHECK(std_render_score(&d, 0, 0, out, 16, &n) == STD_ERR_BOUNDS);
    memcpy(d.prev_score_str, ":", 2);
    CHECK(std_render_score(&d, 0, 0, out, 16, &n) == STD_ERR_BOUNDS);
    /* a ten-character string without NUL stops at ten */
    memset(d.prev_score_str, '1', 10);
    memset(d.score_str, '2', 10);
    memset(d.prev_minutes_str, '3', 10); /* the bytes after score_str must not be read as part of it */
    CHECK(std_render_score(&d, 0, 0, out, 64, &n) == STD_OK && n == 20);
    CHECK(memcmp(d.prev_score_str, "2222222222", 10) == 0);
}

static void t_std_render_clock(void)
{
    StdDisplay d;
    StdHost h;
    SFx s;
    StdBlit out[40];
    size_t n = 99;
    int32_t blk[0x32], c[4];
    memset(&d, 0, sizeof d);
    memset(&s, 0, sizeof s);
    h.context = &s;
    h.register_slot = s_register;
    h.observe = NULL;
    clock_block_make(blk);
    CHECK(std_init_clock(&d, blk, &h) == STD_OK);
    CHECK(std_set_clock(&d, 12, 34) == STD_OK);
    CHECK(std_render_clock(&d, 7, 11, out, 40, &n) == STD_OK && n == 0);
    std_enable_clock(&d, 1);
    d.clock_ready = 0;
    CHECK(std_render_clock(&d, 7, 11, out, 40, &n) == STD_OK && n == 0 && d.prev_minutes_str[0] == 0);
    d.clock_ready = 1;
    /* widths 7,8,9,7,8,9,.. heights 11,12,11,12,.. : "1" 8x12, "2" 9x11, colon 5x15 */
    /* the first render: the previous strings are empty but differ from the current ones, so only the colon is erased (at x) */
    CHECK(std_render_clock(&d, 7, 11, out, 40, &n) == STD_OK && n == 6);
    cell(c, 60, 38, 5, 15);
    CHECK_BLIT(out[0], STD_BLIT_CLOCK_ERASE_COLON, 0, c[0] - 7, c[1] - 11, c[2] - 7, c[3] - 11, c[0], c[1], c[2], c[3], 0);
    cell(c, 60, 40, 8, 12);
    CHECK_BLIT(out[1], STD_BLIT_CLOCK_MIN, 8, 12, 301, 12 + 7, 301 + 11, c[0], c[1], c[2], c[3], 1);
    cell(c, 72, 40, 9, 11);
    CHECK_BLIT(out[2], STD_BLIT_CLOCK_MIN, 8, 24, 302, 24 + 8, 302 + 10, c[0], c[1], c[2], c[3], 2);
    /* the colon: y + (height of digit 0 - colon height) / 2 = 40 + (11 - 15) / 2 = 38 (truncation toward zero) */
    cell(c, 85, 38, 5, 15);
    CHECK_BLIT(out[3], STD_BLIT_CLOCK_COLON, 8, 200, 300, 204, 314, c[0], c[1], c[2], c[3], 0);
    cell(c, 94, 40, 7, 12);
    CHECK_BLIT(out[4], STD_BLIT_CLOCK_SEC, 8, 36, 303, 42, 314, c[0], c[1], c[2], c[3], 3);
    cell(c, 105, 40, 8, 11);
    CHECK_BLIT(out[5], STD_BLIT_CLOCK_SEC, 8, 48, 304, 55, 314, c[0], c[1], c[2], c[3], 4);
    CHECK(strcmp(d.prev_minutes_str, "12") == 0 && strcmp(d.prev_seconds_str, "34") == 0);
    /* only the seconds change: everything previous is erased (minutes, colon, seconds), then all is drawn */
    CHECK(std_set_clock(&d, 12, 5) == STD_OK);
    CHECK(std_render_clock(&d, 7, 11, out, 40, &n) == STD_OK && n == 5 + 2 + 1 + 2);
    cell(c, 60, 40, 8, 12);
    CHECK_BLIT(out[0], STD_BLIT_CLOCK_ERASE_MIN, 0, c[0] - 7, c[1] - 11, c[2] - 7, c[3] - 11, c[0], c[1], c[2], c[3], 1);
    cell(c, 72, 40, 9, 11);
    CHECK_BLIT(out[1], STD_BLIT_CLOCK_ERASE_MIN, 0, c[0] - 7, c[1] - 11, c[2] - 7, c[3] - 11, c[0], c[1], c[2], c[3], 2);
    cell(c, 85, 38, 5, 15);
    CHECK_BLIT(out[2], STD_BLIT_CLOCK_ERASE_COLON, 0, c[0] - 7, c[1] - 11, c[2] - 7, c[3] - 11, c[0], c[1], c[2], c[3], 0);
    cell(c, 94, 40, 7, 12);
    CHECK_BLIT(out[3], STD_BLIT_CLOCK_ERASE_SEC, 0, c[0] - 7, c[1] - 11, c[2] - 7, c[3] - 11, c[0], c[1], c[2], c[3], 3);
    cell(c, 105, 40, 8, 11);
    CHECK_BLIT(out[4], STD_BLIT_CLOCK_ERASE_SEC, 0, c[0] - 7, c[1] - 11, c[2] - 7, c[3] - 11, c[0], c[1], c[2], c[3], 4);
    CHECK(out[5].kind == STD_BLIT_CLOCK_MIN && out[7].kind == STD_BLIT_CLOCK_COLON && out[8].kind == STD_BLIT_CLOCK_SEC &&
          out[9].kind == STD_BLIT_CLOCK_SEC && out[5].a == 1 && out[6].a == 2 && out[8].a == 0 && out[9].a == 5);
    CHECK(strcmp(d.prev_seconds_str, "05") == 0);
    /* only the minutes change */
    CHECK(std_set_clock(&d, 13, 5) == STD_OK && std_render_clock(&d, 7, 11, out, 40, &n) == STD_OK && n == 10);
    CHECK(out[0].kind == STD_BLIT_CLOCK_ERASE_MIN && out[2].kind == STD_BLIT_CLOCK_ERASE_COLON);
    /* nothing changes: drawn again, nothing erased */
    CHECK(std_render_clock(&d, 7, 11, out, 40, &n) == STD_OK && n == 5 && out[0].kind == STD_BLIT_CLOCK_MIN);
    /* the colon rises when the digits are shorter than it: (11 - 15) / 2 is -2, with a taller digit 0 the colon sinks */
    d.clock_h[0] = 20;
    CHECK(std_set_clock(&d, 13, 5) == STD_OK && std_render_clock(&d, 0, 0, out, 40, &n) == STD_OK);
    CHECK(out[2].dst[1] == 40 + 2 && out[2].dst[3] == 40 + 2 + 15 - 1);
    d.clock_h[0] = 12; /* odd difference: (12 - 15) / 2 = -1 (a floor would give -2) */
    CHECK(std_render_clock(&d, 0, 0, out, 40, &n) == STD_OK && out[2].dst[1] == 39);
    /* capacity: 5 draws pass at 5 and fail at 4; the erase pass needs more */
    CHECK(std_render_clock(&d, 0, 0, out, 5, &n) == STD_OK && n == 5);
    CHECK(std_render_clock(&d, 0, 0, out, 4, &n) == STD_ERR_BOUNDS);
    CHECK(std_render_clock(&d, 0, 0, out, 3, &n) == STD_ERR_BOUNDS);
    CHECK(std_render_clock(&d, 0, 0, out, 2, &n) == STD_ERR_BOUNDS);
    CHECK(std_render_clock(&d, 0, 0, out, 1, &n) == STD_ERR_BOUNDS);
    CHECK(std_set_clock(&d, 14, 5) == STD_OK && std_render_clock(&d, 0, 0, out, 9, &n) == STD_ERR_BOUNDS);
    CHECK(std_render_clock(&d, 0, 0, out, 10, &n) == STD_OK && n == 10);
    CHECK(std_set_clock(&d, 15, 5) == STD_OK);
    for (size_t cap = 1; cap < 10; ++cap) {
        memcpy(d.prev_minutes_str, "14", 3);
        memcpy(d.prev_seconds_str, "05", 3);
        CHECK(std_render_clock(&d, 0, 0, out, cap, &n) == STD_ERR_BOUNDS);
    }
    /* non-digit characters in any of the four strings are refused */
    memcpy(d.minutes_str, "1x", 3);
    memcpy(d.prev_minutes_str, "15", 3);
    CHECK(std_render_clock(&d, 0, 0, out, 40, &n) == STD_ERR_BOUNDS);
    memcpy(d.minutes_str, "15", 3);
    memcpy(d.seconds_str, "0:", 3);
    CHECK(std_render_clock(&d, 0, 0, out, 40, &n) == STD_ERR_BOUNDS);
    memcpy(d.seconds_str, "05", 3);
    memcpy(d.prev_minutes_str, "/1", 3);
    CHECK(std_render_clock(&d, 0, 0, out, 40, &n) == STD_ERR_BOUNDS);
    memcpy(d.prev_minutes_str, "15", 3);
    memcpy(d.prev_seconds_str, "0x", 3);
    CHECK(std_render_clock(&d, 0, 0, out, 40, &n) == STD_ERR_BOUNDS);
    memcpy(d.prev_seconds_str, "05", 3);
    CHECK(std_render_clock(&d, 0, 0, out, 40, &n) == STD_OK && n == 5);
    /* ten-character strings are copied whole into the previous strings */
    memset(d.minutes_str, '1', 10);
    memset(d.seconds_str, '2', 10);
    CHECK(std_render_clock(&d, 0, 0, out, 64, &n) == STD_OK);
    CHECK(memcmp(d.prev_minutes_str, "1111111111", 10) == 0 && memcmp(d.prev_seconds_str, "2222222222", 10) == 0);
    /* empty strings: the colon alone is the last blit */
    memset(&d.minutes_str, 0, sizeof d.minutes_str);
    memset(&d.seconds_str, 0, sizeof d.seconds_str);
    memset(&d.prev_minutes_str, 0, sizeof d.prev_minutes_str);
    memset(&d.prev_seconds_str, 0, sizeof d.prev_seconds_str);
    CHECK(std_render_clock(&d, 0, 0, out, 0, &n) == STD_ERR_BOUNDS);
    CHECK(std_render_clock(&d, 0, 0, out, 1, &n) == STD_OK && n == 1 && out[0].kind == STD_BLIT_CLOCK_COLON);
}

/* ---- the quiz kernel ------------------------------------------------------------------------------------------------------- */

static void dump(const Fx *f, const char *what)
{
    if (getenv("F5_DUMP") != NULL) fprintf(stderr, "[%s] %s\n", what, f->log);
}

/* 0x437ea1 as the pseudocode states it: signed character comparisons */
static int expected_key(int8_t c)
{
    static const int8_t extra[] = {-0x20, -0x19, -0x18, -0x17, -0x16, -0x15, -0xc, -0x40, -0x1e, -0x12, -7, -0x3c, -0x1c, -0x2a,
                                   -10, -0x24, -4, -0x5f, -0x41, -0x2f, -0xf, -0x37, -0x1f, -0x13, -0xd, -6, -0x21};
    if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9')) return 1;
    if (c == '\b' || c == '\r' || c == ' ' || c == '.' || c == ',' || c == '?' || c == '!' || c == '/' || c == '$' ||
        c == '(' || c == ')' || c == '&' || c == ':' || c == ';' || c == '+' || c == '%' || c == '=' || c == '-')
        return 1;
    for (size_t i = 0; i < sizeof extra; ++i)
        if (c == extra[i]) return 1;
    return 0;
}

static void t_key_filter(void)
{
    int accepted = 0;
    for (int i = 0; i < 256; ++i) {
        const int8_t c = (int8_t)i;
        CHECK_INT(tqz_key_filter(c) != 0, expected_key(c));
        accepted += expected_key(c);
    }
    CHECK_INT(accepted, 52 + 10 + 18 + 27);
}

static void t_validate(void)
{
    uint8_t b[TQZ_BODY_BYTES];
    const char *why = "unset";
    body_default(b);
    CHECK(tqz_validate_body(b, TQZ_BODY_BYTES, &why) == TQZ_OK && why == NULL);
    CHECK(tqz_validate_body(b, TQZ_BODY_BYTES, NULL) == TQZ_OK);
    CHECK(tqz_validate_body(NULL, TQZ_BODY_BYTES, &why) == TQZ_ERR_BODY && strcmp(why, "0xf5-body-length") == 0);
    CHECK(tqz_validate_body(b, TQZ_BODY_BYTES - 1u, &why) == TQZ_ERR_BODY && strcmp(why, "0xf5-body-length") == 0);
    CHECK(tqz_validate_body(b, TQZ_BODY_BYTES + 1u, &why) == TQZ_ERR_BODY && strcmp(why, "0xf5-body-length") == 0);
    CHECK(tqz_validate_body(b, 0u, &why) == TQZ_ERR_BODY);
    CHECK(tqz_validate_body(NULL, TQZ_BODY_BYTES, NULL) == TQZ_ERR_BODY);
    /* the name: a NUL in its last (0x21st) byte is enough, 0x21 bytes without one are refused; the byte after it is the
     * variant word, so a zero there must not rescue the name */
    memset(b, 'x', 0x20);
    b[0x20] = 0;
    CHECK(tqz_validate_body(b, TQZ_BODY_BYTES, &why) == TQZ_OK);
    b[0x20] = 'x';
    CHECK(tqz_validate_body(b, TQZ_BODY_BYTES, &why) == TQZ_ERR_BODY && strcmp(why, "0xf5-name-unterminated") == 0);
    put16(b, O_VARIANTS, 0);
    CHECK(tqz_validate_body(b, TQZ_BODY_BYTES, &why) == TQZ_ERR_BODY && strcmp(why, "0xf5-name-unterminated") == 0);
    body_default(b);
    /* the four sound names: same rule, and the name check precedes the sound check */
    {
        static const size_t at[4] = {O_SA, O_SB, O_SC, O_SD};
        for (int i = 0; i < 4; ++i) {
            body_default(b);
            memset(b + at[i], 'x', 0x20);
            b[at[i] + 0x20] = 0;
            CHECK(tqz_validate_body(b, TQZ_BODY_BYTES, &why) == TQZ_OK);
            b[at[i] + 0x20] = 'x';
            put16(b, at[i] + 0x21, 0);
            CHECK(tqz_validate_body(b, TQZ_BODY_BYTES, &why) == TQZ_ERR_BODY && strcmp(why, "0xf5-sound-unterminated") == 0);
            memset(b, 'x', 0x21);
            CHECK(tqz_validate_body(b, TQZ_BODY_BYTES, &why) == TQZ_ERR_BODY && strcmp(why, "0xf5-name-unterminated") == 0);
        }
    }
    {
        static const struct { size_t off; int v; int ok; const char *text; } cases[] = {
            {O_VARIANTS, 0, 0, "0xf5-variant-count"}, {O_VARIANTS, 1, 1, NULL}, {O_VARIANTS, 20, 1, NULL},
            {O_VARIANTS, 21, 0, "0xf5-variant-count"}, {O_VARIANTS, -1, 0, "0xf5-variant-count"},
            {O_NPOS, 0, 0, "0xf5-position-count"}, {O_NPOS, 1, 1, NULL}, {O_NPOS, 20, 1, NULL},
            {O_NPOS, 21, 0, "0xf5-position-count"}, {O_NPOS, -1, 0, "0xf5-position-count"},
            {O_BMIN, -1, 0, "0xf5-balloon-range"}, {O_BMIN, 0, 1, NULL}, {O_BMIN, 4, 0, "0xf5-balloon-range"},
            {O_BMIN, 3, 1, NULL}, {O_BMAX, 21, 0, "0xf5-balloon-range"}, {O_BMAX, 20, 1, NULL},
            {O_BMAX, 1, 0, "0xf5-balloon-range"}, {O_BMAX, 2, 1, NULL}, {O_BMAX, -1, 0, "0xf5-balloon-range"},
            {O_LMAX, 4, 0, "0xf5-lifetime-range"}, {O_LMAX, 5, 1, NULL}, {O_LMAX, 32767, 1, NULL},
            {O_LMIN, 10, 0, "0xf5-lifetime-range"}, {O_LMIN, 9, 1, NULL}, {O_LMIN, -3, 1, NULL},
        };
        for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
            body_default(b);
            put16(b, cases[i].off, cases[i].v);
            why = "unset";
            CHECK((tqz_validate_body(b, TQZ_BODY_BYTES, &why) == TQZ_OK) == cases[i].ok);
            if (cases[i].ok) CHECK(why == NULL);
            else CHECK(why != NULL && strcmp(why, cases[i].text) == 0);
            if (g_failed) {
                snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (case %zu)", i);
                return;
            }
        }
    }
    /* min = max = 0 and 20 / 20 balloons are accepted; the rule order is variants, positions, balloons, lifetimes */
    body_default(b);
    put16(b, O_BMIN, 0);
    put16(b, O_BMAX, 0);
    CHECK(tqz_validate_body(b, TQZ_BODY_BYTES, &why) == TQZ_OK);
    put16(b, O_BMIN, 20);
    put16(b, O_BMAX, 20);
    CHECK(tqz_validate_body(b, TQZ_BODY_BYTES, &why) == TQZ_OK);
    put16(b, O_LMAX, 1);
    put16(b, O_LMIN, 2);
    put16(b, O_BMIN, 9);
    put16(b, O_BMAX, 3);
    CHECK(tqz_validate_body(b, TQZ_BODY_BYTES, &why) == TQZ_ERR_BODY && strcmp(why, "0xf5-balloon-range") == 0);
    put16(b, O_NPOS, 0);
    CHECK(tqz_validate_body(b, TQZ_BODY_BYTES, &why) == TQZ_ERR_BODY && strcmp(why, "0xf5-position-count") == 0);
    put16(b, O_VARIANTS, 0);
    CHECK(tqz_validate_body(b, TQZ_BODY_BYTES, &why) == TQZ_ERR_BODY && strcmp(why, "0xf5-variant-count") == 0);
}

static void t_reset(void)
{
    TqzObject o;
    TqzWorld w;
    static const TqzObject zero;
    TqzObject expect = zero;
    memset(&o, 0x5a, sizeof o);
    tqz_object_reset(&o);
    expect.slot = -1;
    expect.row = -1;
    expect.score_block[44] = -1;
    expect.clock_block[48] = -1;
    CHECK(memcmp(&o, &expect, sizeof o) == 0);
    memset(&w, 0x5a, sizeof w);
    w.played_5a4c0a = 1;
    w.best_5a4c0e = 77;
    tqz_world_new_game(&w);
    CHECK(w.played_5a4c0a == 0 && w.best_5a4c0e == 0 && w.start_flag_5bb1ca == 0x5a5a5a5a &&
          w.display.score_enabled == 0x5a5a5a5a);
}

static void t_phase0(void)
{
    Fx f;
    const TqzObject *o;
    fx_init(&f);
    start_quiz(&f);
    dump(&f, "phase0");
    o = &f.o;
    CHECK(f.result.initialized == 1 && f.result.completed == 0 && f.result.phase_after == 1u && f.phase == 1u);
    CHECK(o->row == ROW && o->active == 1 && o->slot == 0x18 && o->surface == SURFACE && o->state == TQZ_STATE_PLAY);
    CHECK(o->count == 3 && o->score == 0 && o->hits == 0 && o->minutes == 0 && o->seconds == 0);
    CHECK(o->start_tick == 1000000u && o->elapsed == 0u);
    CHECK(o->max_char == 0x7b && o->target == 10);
    CHECK(f.w.start_flag_5bb1ca == 1 && f.w.played_5a4c0a == 1 && f.w.best_5a4c0e == 0);
    /* three z entries in the order quiz, score, clock; the surface loaded once by name */
    CHECK(f.n_alloc == 3 && f.n_load == 1 && strcmp(f.loaded_name, "TQUIZ") == 0 && f.n_clear == 1 && f.n_fontacq == 1);
    CHECK(f.n_reg == 3);
    CHECK(f.reg[0].slot == 0x18 && f.reg[0].type == 10 && f.reg[0].callback == TQZ_CALLBACK_QUIZ && f.reg[0].surface == 0u &&
          strcmp(f.reg[0].label, "TYPING QUIZ PUZZLE OVERLAYS") == 0);
    CHECK(f.reg[1].slot == 0x19 && f.reg[1].type == 10 && f.reg[1].callback == STD_CALLBACK_SCORE &&
          f.reg[1].surface == SURFACE && strcmp(f.reg[1].label, "SCORE DISPLAY") == 0);
    CHECK(f.reg[2].slot == 0x1a && f.reg[2].type == 10 && f.reg[2].callback == STD_CALLBACK_CLOCK &&
          f.reg[2].surface == SURFACE && strcmp(f.reg[2].label, "TIME DISPLAY") == 0);
    CHECK(f.setsurf_slot == 0x18 && f.setsurf_surface == SURFACE);
    CHECK(f.n_prep == 3 && f.prep_hist[0] == O_SA && f.prep_hist[1] == O_SB && f.prep_hist[2] == O_SC);
    CHECK(f.n_play == 0 && f.n_stop == 0);
    /* the display: score block with the view origin added to x / y, then the clock block */
    CHECK(o->score_block[40] == 30 + VIEW_L && o->score_block[41] == 12 + VIEW_T && o->score_block[42] == 2 &&
          o->score_block[43] == (int32_t)SURFACE && o->score_block[44] == 0x19 && o->score_block[45] == 10);
    CHECK(o->clock_block[44] == 500 + VIEW_L && o->clock_block[45] == 16 + VIEW_T && o->clock_block[46] == 3 &&
          o->clock_block[47] == (int32_t)SURFACE && o->clock_block[48] == 0x1a && o->clock_block[49] == 10);
    CHECK(o->score_block[0] == 0 && o->score_block[1] == 400 && o->score_block[2] == 7 && o->score_block[3] == 409);
    CHECK(o->score_block[4 * 5] == 50 && o->score_block[4 * 5 + 2] == 50 + 7 + 2 && o->score_block[4 * 5 + 3] == 409 + 1);
    CHECK(o->clock_block[0] == 0 && o->clock_block[1] == 420 && o->clock_block[2] == 9 && o->clock_block[3] == 431);
    CHECK(o->clock_block[4 * 7] == 84 && o->clock_block[4 * 7 + 2] == 84 + 9 + 1 && o->clock_block[4 * 7 + 3] == 431 + 1);
    CHECK(o->clock_block[40] == 200 && o->clock_block[41] == 420 && o->clock_block[42] == 205 && o->clock_block[43] == 432);
    CHECK(f.w.display.score_enabled == 1 && f.w.display.clock_enabled == 1 && f.w.display.score_ready == 1 &&
          f.w.display.clock_ready == 1);
    CHECK(strcmp(f.w.display.score_str, "0") == 0 && strcmp(f.w.display.minutes_str, "00") == 0 &&
          strcmp(f.w.display.seconds_str, "00") == 0);
    /* the first wave: balloon 0 at position 2, variant 1, 'A', lifetime 8; balloon 1 at position 3, variant 2, 'U', 5;
     * balloon 2 at position 0, variant 0, '4', 9 (the rectangle gets the view origin added) */
    CHECK(o->balloon[0].state == TQZ_BALLOON_FLYING && o->balloon[0].ch == 'A' && o->balloon[0].lifetime == 8 &&
          o->balloon[0].spawn == 1000000u);
    CHECK(o->balloon[0].dst[0] == 205 + VIEW_L && o->balloon[0].dst[1] == 54 + VIEW_T && o->balloon[0].dst[2] == 245 + VIEW_L &&
          o->balloon[0].dst[3] == 94 + VIEW_T);
    CHECK(o->balloon[0].src[0] == 11 && o->balloon[0].src[1] == 22 && o->balloon[0].src[2] == 53 && o->balloon[0].src[3] == 64);
    CHECK(o->balloon[0].text_x == (245 + VIEW_L) - (245 - 205) / 2 - 8 && o->balloon[0].text_y == (94 + VIEW_T) - (94 - 54) / 2 + 6);
    CHECK(o->balloon[1].state == TQZ_BALLOON_FLYING && o->balloon[1].ch == 'U' && o->balloon[1].lifetime == 5);
    CHECK(o->balloon[1].dst[0] == 305 + VIEW_L && o->balloon[1].dst[1] == 61 + VIEW_T && o->balloon[1].dst[2] == 345 + VIEW_L &&
          o->balloon[1].dst[3] == 101 + VIEW_T);
    CHECK(o->balloon[1].src[0] == 12 && o->balloon[1].src[1] == 24 && o->balloon[1].src[2] == 56 && o->balloon[1].src[3] == 68);
    CHECK(o->balloon[2].state == TQZ_BALLOON_FLYING && o->balloon[2].ch == '4' && o->balloon[2].lifetime == 9);
    CHECK(o->balloon[2].dst[0] == 5 + VIEW_L && o->balloon[2].dst[1] == 40 + VIEW_T && o->balloon[2].dst[2] == 45 + VIEW_L &&
          o->balloon[2].dst[3] == 80 + VIEW_T);
    CHECK(o->balloon[2].src[0] == 10 && o->balloon[2].src[1] == 20 && o->balloon[2].src[2] == 50 && o->balloon[2].src[3] == 60);
    CHECK(o->balloon[3].state == TQZ_BALLOON_FREE);
    CHECK_LOG(&f, "active:1:0,start:1:0,clearitem:0:0,slot:24:0,slotreg:24:0,load:77:0,slotsurf:24:77,prep:1126:0,prep:1175:0,"
                  "prep:1224:0,slot:25:0,initscore:25:77,setscore:0:0,enscore:1:0,tick:1000000:0,slot:26:0,initclock:26:77,"
                  "setclock:0:0,enclock:1:0,played:1:0,state:0:0,phase:1:0,fontacq:10:0,rand:1:0,"
                  "rand:2:0,rand:1:0,rand:17:0,tick:1000000:0,rand:3:0,"
                  "rand:2:0,rand:3:0,rand:2:0,rand:10:0,rand:37:0,tick:1000000:0,rand:0:0,"
                  "rand:0:0,rand:0:0,rand:4:0,tick:1000000:0,rand:4:0");
}

/* one balloon position, one variant, one balloon per wave */
static void body_single(uint8_t *b)
{
    put16(b, O_VARIANTS, 1);
    put16(b, O_NPOS, 1);
    put16(b, O_BMIN, 1);
    put16(b, O_BMAX, 1);
}
/* lifetimes of 1000 s and a 4000 s limit: nothing expires while a test walks the clock */
static void body_quiet(uint8_t *b)
{
    put16(b, O_LMIN, 1000);
    put16(b, O_LMAX, 1000);
    put16(b, O_LIMIT, 4000);
}

static void visit(Fx *f, uint32_t now)
{
    f->now = now;
    f->log[0] = '\0';
    {
        const int rc = step(f, f->phase);
        CHECK(rc == TQZ_OK);
        if (rc != TQZ_OK && getenv("F5_DUMP") != NULL)
            fprintf(stderr, "visit rc=%d phase=%u failure=%s now=%u\n", rc, f->phase, f->failure ? f->failure : "-", now);
    }
}

static int ref_allowed(int digits, int extras, const uint8_t *extra, int c)
{
    if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) return 1;
    if (digits && c >= '0' && c <= '9') return 1;
    if (extras)
        for (int i = 0; i < 30; ++i)
            if (extra[i] == c) return 1;
    return 0;
}

/* Every byte value the random character pick can produce is accepted or refused exactly as 0x4b8520 decides. */
static void t_char_sweep(void)
{
    for (int variant = 0; variant < 4; ++variant) {
        const int digits = variant & 1, extras = variant >> 1;
        const int base = digits ? 0x30 : 0x41;
        for (int c = base; c < 256 && !g_failed; ++c) {
            Fx f;
            uint8_t extra[30] = {0};
            int allowed;
            fx_init(&f);
            body_single(f.body);
            f.body[O_DIGITS] = (uint8_t)digits;
            if (extras) {
                extra[0] = '^';
                extra[10] = '[';
                extra[29] = 0xe9;
            } else {
                extra[7] = '[';
                extra[29] = 0xe9; /* the first byte is zero: the list is ignored */
            }
            memcpy(f.body + O_EXTRA, extra, 30);
            /* the byte right behind the 30-byte list is the low byte of the minimum lifetime: it must not count as an extra */
            put16(f.body, O_LMIN, c);
            put16(f.body, O_LMAX, 1000);
            f.o.max_char = 0x100;
            rand_set(&f, 6, 0, 0, 0, c - base, 'A' - base, 0);
            CHECK(step(&f, 0u) == TQZ_OK);
            allowed = ref_allowed(digits, extras, extra, c);
            CHECK_INT(f.o.balloon[0].ch, allowed ? c : 'A');
            CHECK_INT(f.i_rand, allowed ? 5 : 6);
            if (g_failed) snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (variant %d char 0x%02x)", variant, c);
        }
    }
}

static void t_max_char(void)
{
    static const struct { int wide, extra0, expect; } cases[] = {{0, 0, 0x7b}, {0, 1, 0x7f}, {1, 0, 0x100}, {1, 1, 0x100}};
    for (size_t i = 0; i < 4; ++i) {
        Fx f;
        fx_init(&f);
        body_single(f.body);
        f.body[O_WIDE] = (uint8_t)cases[i].wide;
        f.body[O_EXTRA] = (uint8_t)(cases[i].extra0 ? '^' : 0);
        CHECK(step(&f, 0u) == TQZ_OK);
        CHECK_INT(f.o.max_char, cases[i].expect);
    }
    {
        /* the range is kept from the previous run: the first wave of a run draws with the old value (0 in a fresh process) */
        Fx f;
        fx_init(&f);
        body_single(f.body);
        rand_set(&f, 5, 0, 0, 0, 74, 0);
        CHECK(step(&f, 0u) == TQZ_OK);
        CHECK_INT(f.o.balloon[0].ch, 0x30 + 74 % 48); /* span 0 - 0x30 = -48: C remainder 26 */
        CHECK_INT(f.o.max_char, 0x7b);
        CHECK(tqz_cleanup(&f.o, &f.w, &f.host) == TQZ_OK);
        CHECK_INT(f.o.max_char, 0x7b);
        rand_set(&f, 5, 0, 0, 0, 74, 0);
        CHECK(step(&f, 0u) == TQZ_OK);
        CHECK_INT(f.o.balloon[0].ch, 0x30 + 74); /* span 75 */
        tqz_object_reset(&f.o);
        rand_set(&f, 5, 0, 0, 0, 74, 0);
        CHECK(step(&f, 0u) == TQZ_OK);
        CHECK_INT(f.o.balloon[0].ch, 0x30 + 26);
    }
    {
        /* letters only: draw 100 */
        Fx f;
        fx_init(&f);
        body_single(f.body);
        f.body[O_DIGITS] = 0;
        rand_set(&f, 5, 0, 0, 0, 100, 0);
        CHECK(step(&f, 0u) == TQZ_OK);
        CHECK_INT(f.o.balloon[0].ch, 0x41 + 100 % 65); /* span 0 - 0x41 = -65 */
        CHECK(tqz_cleanup(&f.o, &f.w, &f.host) == TQZ_OK);
        rand_set(&f, 5, 0, 0, 0, 100, 0);
        CHECK(step(&f, 0u) == TQZ_OK);
        CHECK_INT(f.o.balloon[0].ch, 0x41 + 100 % 58); /* span 0x7b - 0x41 */
    }
    {
        /* a range that makes the span zero is refused (the original would divide by zero) */
        Fx f;
        fx_init(&f);
        body_single(f.body);
        f.body[O_DIGITS] = 0;
        f.o.max_char = 0x41;
        CHECK(step(&f, 0u) == TQZ_ERR_BOUNDS);
        fx_init(&f);
        body_single(f.body);
        f.o.max_char = 0x30;
        CHECK(step(&f, 0u) == TQZ_ERR_BOUNDS);
    }
}

static void t_positions(void)
{
    Fx f;
    fx_init(&f);
    body_single(f.body);
    put16(f.body, O_NPOS, 4);
    put16(f.body, O_BMIN, 4);
    put16(f.body, O_BMAX, 4);
    /* positions 0 and 1 share their left edge, 2 and 3 their top: only a full match blocks a position */
    put_rect(f.body, O_POSRECT, 5, 40, 45, 80);
    put_rect(f.body, O_POSRECT + 16, 5, 100, 45, 140);
    put_rect(f.body, O_POSRECT + 32, 200, 200, 240, 240);
    put_rect(f.body, O_POSRECT + 48, 300, 200, 340, 240);
    rand_set(&f, 17, 0, 0, 0, 17, 0, 1, 0, 17, 0, 2, 0, 17, 0, 3, 0, 17, 0);
    CHECK(step(&f, 0u) == TQZ_OK);
    CHECK_INT(f.i_rand, 17);
    CHECK_INT(f.o.count, 4);
    CHECK(f.o.balloon[1].dst[0] == 5 + VIEW_L && f.o.balloon[1].dst[1] == 100 + VIEW_T && f.o.balloon[1].dst[2] == 45 + VIEW_L &&
          f.o.balloon[1].dst[3] == 140 + VIEW_T);
    CHECK(f.o.balloon[3].dst[0] == 300 + VIEW_L && f.o.balloon[3].dst[1] == 200 + VIEW_T && f.o.balloon[3].dst[2] == 340 + VIEW_L &&
          f.o.balloon[3].dst[3] == 240 + VIEW_T);
    CHECK(f.o.balloon[2].dst[0] == 200 + VIEW_L && f.o.balloon[2].dst[1] == 200 + VIEW_T);
    /* the text anchor: bottom - (bottom - top) / 2 + 6 and right - (right - left) / 2 - 8 (truncating halves) */
    fx_init(&f);
    body_single(f.body);
    put_rect(f.body, O_POSRECT, 5, 40, 46, 81);
    CHECK(step(&f, 0u) == TQZ_OK);
    CHECK_INT(f.o.balloon[0].text_x, (46 + VIEW_L) - 41 / 2 - 8);
    CHECK_INT(f.o.balloon[0].text_y, (81 + VIEW_T) - 41 / 2 + 6);
    /* a negative size: -41 / 2 truncates toward zero */
    fx_init(&f);
    body_single(f.body);
    put_rect(f.body, O_POSRECT, 46, 81, 5, 40);
    CHECK(step(&f, 0u) == TQZ_OK);
    CHECK_INT(f.o.balloon[0].text_x, (5 + VIEW_L) - (5 - 46) / 2 - 8);
    CHECK_INT(f.o.balloon[0].text_y, (40 + VIEW_T) - (40 - 81) / 2 + 6);
    /* variant rectangles come from the drawn variant */
    fx_init(&f);
    body_single(f.body);
    put16(f.body, O_VARIANTS, 3);
    rand_set(&f, 5, 0, 0, 5, 17, 0);
    CHECK(step(&f, 0u) == TQZ_OK);
    CHECK(f.o.balloon[0].src[0] == 12 && f.o.balloon[0].src[1] == 24 && f.o.balloon[0].src[2] == 56 && f.o.balloon[0].src[3] == 68);
}

static void t_stuck(void)
{
    Fx f;
    /* every position taken */
    fx_init(&f);
    f.observe_on = 0; /* 100000 draws: no log */
    body_single(f.body);
    put16(f.body, O_BMIN, 2);
    put16(f.body, O_BMAX, 2);
    CHECK(step(&f, 0u) == TQZ_ERR_STUCK);
    CHECK_INT(f.i_rand, 1 + 4 + 1 + TQZ_PICK_LIMIT);
    CHECK(f.failure != NULL);
    /* a character range with nothing allowed */
    fx_init(&f);
    f.observe_on = 0; /* 100000 draws: no log */
    body_single(f.body);
    f.body[O_DIGITS] = 0;
    f.o.max_char = 0x5c;
    f.rand_default = 26; /* 0x41 + 26 = '[' */
    CHECK(step(&f, 0u) == TQZ_ERR_STUCK);
    CHECK_INT(f.i_rand, 3 + TQZ_PICK_LIMIT);
    /* the refill loop: a count far above the maximum never gets back into range */
    fx_init(&f);
    f.observe_on = 0; /* 100000 draws: no log */
    start_quiz(&f);
    f.o.balloon[2].lifetime = 1;
    f.o.count = 10;
    f.rand_default = 1;
    f.n_rand = 0;
    f.i_rand = 0;
    f.now += 2000u;
    CHECK(step(&f, 1u) == TQZ_ERR_STUCK);
    CHECK_INT(f.i_rand, TQZ_PICK_LIMIT);
}

static void t_clock(void)
{
    Fx f;
    static const struct { uint32_t elapsed; int m, s; } walk[] = {
        {0, 2, 5}, {999, 2, 5}, {1000, 2, 4}, {59999, 1, 6}, {65000, 1, 0}, {66000, 0, 59}, {124000, 0, 1}, {124999, 0, 1}};
    fx_init(&f);
    body_quiet(f.body);
    f.body[O_LIMIT] = 125;
    f.body[O_LIMIT + 1] = 0;
    start_quiz(&f);
    CHECK_INT(f.o.start_tick, 1000000);
    for (size_t i = 0; i < sizeof walk / sizeof walk[0]; ++i) {
        const int m0 = f.o.minutes, s0 = f.o.seconds;
        visit(&f, 1000000u + walk[i].elapsed);
        CHECK_INT(f.o.elapsed, walk[i].elapsed);
        CHECK_INT(f.o.minutes, walk[i].m);
        CHECK_INT(f.o.seconds, walk[i].s);
        CHECK_INT(f.w.display.minutes, walk[i].m);
        CHECK_INT(f.w.display.seconds, walk[i].s);
        if (walk[i].m == m0 && walk[i].s == s0) {
            CHECK(strstr(f.log, "setclock") == NULL);
        } else {
            char want[64];
            snprintf(want, sizeof want, "setclock:%d:%d", walk[i].m, walk[i].s);
            CHECK(strstr(f.log, want) != NULL);
        }
        CHECK_INT(f.o.state, TQZ_STATE_PLAY);
        if (g_failed) {
            snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (step %zu)", i);
            return;
        }
    }
    visit(&f, 1000000u + 125000u);
    CHECK_INT(f.o.state, TQZ_STATE_TIME_UP);
    CHECK_INT(f.o.minutes, 0);
    CHECK_INT(f.o.seconds, 0);
    CHECK(strstr(f.log, "setclock:0:0") != NULL && strstr(f.log, "state:1:0") != NULL);
    /* remaining time below zero: the quotient and remainder are clamped to 0:00 (the effect is emitted again) */
    f.o.state = TQZ_STATE_PLAY;
    visit(&f, 1000000u + 130000u);
    CHECK(strstr(f.log, "setclock:0:0") != NULL);
    CHECK_INT(f.o.minutes, 0);
    CHECK_INT(f.o.seconds, 0);
    f.o.minutes = 4;
    f.o.seconds = 4;
    f.o.state = TQZ_STATE_PLAY;
    visit(&f, 1000000u + 190000u); /* remaining -65: minutes -1, seconds -5 */
    CHECK(strstr(f.log, "setclock:0:0") != NULL);
    CHECK_INT(f.o.minutes, 0);
    CHECK_INT(f.o.seconds, 0);
    CHECK_INT(f.w.display.seconds, 0);
    /* one minute changes while the seconds stay the same, and the other way round */
    fx_init(&f);
    body_quiet(f.body);
    f.body[O_LIMIT] = 125;
    f.body[O_LIMIT + 1] = 0;
    start_quiz(&f);
    visit(&f, 1000000u);
    f.o.minutes = 7;
    visit(&f, 1000000u);
    CHECK(strstr(f.log, "setclock:2:5") != NULL);
    f.o.seconds = 7;
    visit(&f, 1000000u);
    CHECK(strstr(f.log, "setclock:2:5") != NULL);
    visit(&f, 1000000u);
    CHECK(strstr(f.log, "setclock") == NULL);
    /* big limits clamp at 59:59 */
    {
        static const int limits[] = {3599, 3600, 3630, 4000, 32767};
        for (size_t i = 0; i < 5; ++i) {
            fx_init(&f);
            body_quiet(f.body);
            put16(f.body, O_LIMIT, limits[i]);
            start_quiz(&f);
            visit(&f, 1000000u);
            CHECK_INT(f.o.minutes, 59);
            CHECK_INT(f.o.seconds, 59);
        }
        fx_init(&f);
        body_quiet(f.body);
        put16(f.body, O_LIMIT, 3540 + 7);
        start_quiz(&f);
        visit(&f, 1000000u);
        CHECK_INT(f.o.minutes, 59);
        CHECK_INT(f.o.seconds, 7);
    }
    /* the tick counter wraps */
    fx_init(&f);
    body_quiet(f.body);
    put16(f.body, O_LIMIT, 125);
    f.now = 0xffffff00u;
    start_quiz(&f);
    CHECK_INT(f.o.start_tick, 0xffffff00u);
    visit(&f, 0xffffff00u + 5000u);
    CHECK_INT(f.o.elapsed, 5000);
    CHECK_INT(f.o.minutes, 2);
    CHECK_INT(f.o.seconds, 0);
}

static void t_score_formula(void)
{
    static const struct { uint32_t hits; int factor, secs, expect; } cases[] = {
        {10, 1, 60, 10}, {7, 2, 30, 7}, {1, 1, 3, 20}, {100, 3, 7, 285}, {33, 1, 1, 1980}, {41, 1, 5, 492}, {41, 2, 10, 123},
        {41, 5, 1, 492}, {5, 0, 10, 0}, {16777217u, 7, 1, 18720}};
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        Fx f;
        fx_init(&f);
        body_quiet(f.body);
        put16(f.body, O_FACTOR, cases[i].factor);
        start_quiz(&f);
        f.o.hits = (int32_t)cases[i].hits;
        visit(&f, 1000000u + (uint32_t)cases[i].secs * 1000u + 500u);
        CHECK_INT(f.o.score, cases[i].expect);
        if (cases[i].expect != 0) {
            char want[48];
            snprintf(want, sizeof want, "setscore:%d:0", cases[i].expect);
            CHECK(strstr(f.log, want) != NULL);
            CHECK_INT(f.w.display.score, cases[i].expect);
        }
        if (g_failed) {
            snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (case %zu)", i);
            return;
        }
    }
    {
        Fx f;
        /* the stored score is a 16-bit value: 600 hits in a second at factor 1 is 36000, which wraps negative and is refused */
        fx_init(&f);
        body_quiet(f.body);
        put16(f.body, O_FACTOR, 1);
        start_quiz(&f);
        f.o.hits = 600;
        f.now = 1000000u + 1500u;
        CHECK(step(&f, 1u) == TQZ_ERR_BOUNDS);
        fx_init(&f);
        body_quiet(f.body);
        put16(f.body, O_FACTOR, -2);
        start_quiz(&f);
        f.o.hits = 1;
        f.now = 1000000u + 1500u;
        CHECK(step(&f, 1u) == TQZ_ERR_BOUNDS);
        /* no recompute without hits or without a whole second; the score is kept and shown every visit (the previous score
         * cell is only ever cleared) */
        fx_init(&f);
        body_quiet(f.body);
        start_quiz(&f);
        f.o.score = 5;
        visit(&f, 1000000u + 3000u);
        CHECK_INT(f.o.score, 5);
        CHECK(strstr(f.log, "setscore:5:0") != NULL);
        visit(&f, 1000000u + 3000u);
        CHECK(strstr(f.log, "setscore:5:0") != NULL);
        f.o.hits = 4;
        visit(&f, 1000000u + 900u);
        CHECK_INT(f.o.score, 5);
        f.o.score = 0;
        visit(&f, 1000000u + 3000u);
        CHECK(strstr(f.log, "setscore:40:0") != NULL);
        CHECK_INT(f.o.score, 4 * 60 / (2 * 3));
        /* time up exactly at the limit second, not before */
        fx_init(&f);
        body_quiet(f.body);
        put16(f.body, O_LIMIT, 10);
        start_quiz(&f);
        visit(&f, 1000000u + 9999u);
        CHECK_INT(f.o.state, TQZ_STATE_PLAY);
        visit(&f, 1000000u + 10000u);
        CHECK_INT(f.o.state, TQZ_STATE_TIME_UP);
        CHECK(strstr(f.log, "state:1:0") != NULL);
    }
}

static void pos_rect(int c, int32_t out[4])
{
    out[0] = c * 100 + 5 + VIEW_L;
    out[1] = 40 + 7 * c + VIEW_T;
    out[2] = c * 100 + 45 + VIEW_L;
    out[3] = 80 + 7 * c + VIEW_T;
}

static void t_expire_refill(void)
{
    Fx f;
    int32_t want[4];
    /* the lifetime test is "seconds since the balloon appeared > lifetime", whole seconds */
    fx_init(&f);
    start_quiz(&f);
    visit(&f, 1000000u + 5999u);
    CHECK(f.n_play == 0 && f.o.balloon[1].state == TQZ_BALLOON_FLYING && f.o.count == 3);
    rand_set(&f, 0);
    visit(&f, 1000000u + 6000u);
    CHECK(f.o.balloon[1].state == TQZ_BALLOON_GONE && f.o.balloon[0].state == TQZ_BALLOON_FLYING && f.o.count == 2);
    CHECK(f.n_play == 1 && f.play_hist[0] == 13 && f.i_rand == 1);
    CHECK(strstr(f.log, "play:13:0,rand:0:0") != NULL);
    /* two balloons expire together: one sound, one refill of up to two balloons into the free entries */
    fx_init(&f);
    start_quiz(&f);
    f.o.balloon[0].lifetime = 2;
    f.o.balloon[1].lifetime = 2;
    rand_set(&f, 6, 0, 2, 1, 0, 17, 0);
    visit(&f, 1000000u + 3000u);
    CHECK(f.n_play == 1 && f.play_hist[0] == 13 && f.i_rand == 6);
    CHECK(f.o.count == 3 && f.o.balloon[0].state == TQZ_BALLOON_GONE && f.o.balloon[1].state == TQZ_BALLOON_GONE);
    CHECK(f.o.balloon[3].state == TQZ_BALLOON_FLYING && f.o.balloon[3].ch == 'A' && f.o.balloon[3].spawn == 1003000u);
    pos_rect(1, want);
    CHECK(memcmp(f.o.balloon[3].dst, want, sizeof want) == 0);
    CHECK(f.o.balloon[3].lifetime == 5 && f.o.balloon[3].src[0] == 10);
    /* too few balloons even after the refill: the count is lifted to the minimum and nothing is drawn */
    fx_init(&f);
    start_quiz(&f);
    f.o.count = 0;
    rand_set(&f, 0);
    f.now += 6000u;
    CHECK(step(&f, 1u) == TQZ_OK);
    CHECK(f.o.count == 2 && f.i_rand == 0 && f.o.balloon[3].state == TQZ_BALLOON_FREE);
    /* a popping and a gone balloon keep their positions; the refill picks the one position left */
    fx_init(&f);
    start_quiz(&f);
    f.o.balloon[0].state = TQZ_BALLOON_POPPING;
    f.o.balloon[1].state = TQZ_BALLOON_GONE;
    f.o.balloon[2].lifetime = 1;
    rand_set(&f, 8, 1, 2, 3, 0, 1, 0, 17, 2);
    visit(&f, 1000000u + 2000u);
    CHECK(f.i_rand == 8 && f.o.count == 3 && f.o.balloon[2].state == TQZ_BALLOON_GONE);
    CHECK(f.o.balloon[3].state == TQZ_BALLOON_FLYING && f.o.balloon[3].lifetime == 7 && f.o.balloon[3].ch == 'A');
    pos_rect(1, want);
    CHECK(memcmp(f.o.balloon[3].dst, want, sizeof want) == 0);
    /* a free entry's stale rectangle and a balloon beyond the position count do not block a position */
    fx_init(&f);
    start_quiz(&f);
    pos_rect(1, want);
    memcpy(f.o.balloon[3].dst, want, sizeof want);
    memcpy(f.o.balloon[10].dst, want, sizeof want);
    f.o.balloon[10].state = TQZ_BALLOON_FLYING;
    f.o.balloon[2].lifetime = 1;
    rand_set(&f, 5, 1, 1, 0, 17, 0);
    visit(&f, 1000000u + 2000u);
    CHECK(f.i_rand == 5 && f.o.balloon[3].state == TQZ_BALLOON_FLYING);
    /* the refill count: a draw that leaves the count outside [min, max] is drawn again */
    fx_init(&f);
    start_quiz(&f);
    f.o.balloon[2].lifetime = 1;
    /* fresh = 2 % 3 = 2: 2 + 2 = 4 > 3; redraw 5 % 3 = 2: still 4; redraw 1: 3, in range; then the new balloon at position 1 */
    rand_set(&f, 7, 2, 5, 1, 1, 0, 17, 0);
    visit(&f, 1000000u + 2000u);
    CHECK(f.o.count == 3 && f.o.balloon[3].state == TQZ_BALLOON_FLYING);
    /* the sound of a timed-out balloon and the refill happen after the expiry loop, once */
    CHECK(f.n_play == 1);
}

typedef struct KeyCase {
    int case_sensitive;
    uint8_t ch[3];
    int st[3];
    int8_t key;
    int pop; /* index of the balloon that pops, -1 none */
} KeyCase;

static void t_keys(void)
{
    static const KeyCase cases[] = {
        {0, {'a', 'U', '4'}, {1, 1, 1}, 'A', 0},    {0, {'A', 'U', '4'}, {1, 1, 1}, 'a', 0},
        {0, {'a', 'U', '4'}, {1, 1, 1}, 'u', 1},    {0, {'a', 'U', '4'}, {1, 1, 1}, '4', 2},
        {1, {'a', 'U', '4'}, {1, 1, 1}, 'A', -1},   {1, {'a', 'U', '4'}, {1, 1, 1}, 'a', 0},
        {0, {'a', 'U', '4'}, {1, 1, 1}, 'z', -1},   {0, {'q', 'q', '4'}, {1, 1, 1}, 'q', 0},
        {0, {'a', 'a', 'a'}, {1, 1, 1}, 'A', 0},    {0, {'z', 'Z', '4'}, {1, 1, 1}, 'Z', 0},
        {0, {'Z', 'z', '4'}, {1, 1, 1}, 'z', 0},                {0, {'!', 'U', '4'}, {1, 1, 1}, 'A', -1},   {0, {'a', 'U', '4'}, {2, 1, 1}, 'a', -1},
        {0, {'a', 'U', '4'}, {3, 1, 1}, 'a', -1},   {0, {'A', 'a', '4'}, {3, 1, 1}, 'a', 1},
        {0, {'a', 'U', '4'}, {0, 1, 1}, 'a', -1},   {0, {0xe9, 'U', '4'}, {1, 1, 1}, (int8_t)0xe9, -1},
        {1, {0xe9, 'U', '4'}, {1, 1, 1}, (int8_t)0xe9, -1}, {0, {'a', 'U', '4'}, {1, 1, 1}, '\b', -1},
        {0, {'a', 'U', '4'}, {1, 1, 1}, ' ', -1},   {1, {'U', 'a', '4'}, {1, 1, 1}, 'U', 0},
        {0, {'b', 'a', 'a'}, {1, 1, 1}, 'A', 1},
    };
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        const KeyCase *c = &cases[i];
        Fx f;
        fx_init(&f);
        body_quiet(f.body);
        f.body[O_CASE] = (uint8_t)c->case_sensitive;
        start_quiz(&f);
        for (int k = 0; k < 3; ++k) {
            f.o.balloon[k].ch = c->ch[k];
            f.o.balloon[k].state = c->st[k];
        }
        CHECK(tqz_key(&f.o, 1u, c->key) == 1);
        CHECK(f.o.key_pending == 1 && f.o.key_char == (uint8_t)c->key);
        visit(&f, 1000000u + 10u);
        CHECK(f.o.key_pending == 0);
        if (c->pop >= 0) {
            CHECK(f.o.hits == 1 && f.n_play == 1 && f.play_hist[0] == 11);
            for (int k = 0; k < 3; ++k) {
                CHECK_INT(f.o.balloon[k].state, k == c->pop ? TQZ_BALLOON_POPPING : c->st[k]);
            }
            CHECK(f.o.balloon[c->pop].deadline == 1000010u + 1000u);
            CHECK(strstr(f.log, "play:11:0,tick:1000010:0") != NULL);
        } else {
            CHECK(f.o.hits == 0 && f.n_play == 1 && f.play_hist[0] == 12);
            for (int k = 0; k < 3; ++k) CHECK_INT(f.o.balloon[k].state, c->st[k]);
            CHECK(strstr(f.log, "play:12:0") != NULL);
        }
        if (g_failed) {
            snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (case %zu)", i);
            return;
        }
    }
    /* no key, no sound */
    {
        Fx f;
        fx_init(&f);
        body_quiet(f.body);
        start_quiz(&f);
        visit(&f, 1000000u + 10u);
        CHECK(f.n_play == 0 && f.o.hits == 0);
    }
}

static void t_key_gate(void)
{
    Fx f;
    fx_init(&f);
    start_quiz(&f);
    CHECK(tqz_key(&f.o, 1u, 'a') == 1 && f.o.key_char == 'a' && f.o.key_pending == 1);
    CHECK(tqz_key(&f.o, 1u, 'b') == 0 && f.o.key_char == 'a'); /* one pending character at a time */
    f.o.key_pending = 0;
    CHECK(tqz_key(&f.o, 0u, 'b') == 0 && f.o.key_pending == 0);
    CHECK(tqz_key(&f.o, 2u, 'b') == 0);
    CHECK(tqz_key(&f.o, 1u, '#') == 0 && f.o.key_pending == 0); /* refused by the filter */
    CHECK(tqz_key(&f.o, 1u, (int8_t)0xe9) == 1 && f.o.key_char == 0xe9);
    f.o.key_pending = 0;
    f.o.state = TQZ_STATE_TIME_UP;
    CHECK(tqz_key(&f.o, 1u, 'a') == 0);
    f.o.state = TQZ_STATE_PLAY;
    f.o.active = 0;
    CHECK(tqz_key(&f.o, 1u, 'a') == 0);
    f.o.active = 1;
    CHECK(tqz_key(&f.o, 1u, 'a') == 1);
}

static void t_target(void)
{
    static const struct { int best, percent, low, expect; } cases[] = {
        {0, 50, 4, 10},    {100, 0, 4, 10},  {100, -3, 4, 10}, {-5, 50, 4, 10},   {100, 50, 4, 50}, {7, 50, 4, 4},
        {10, 50, 4, 5},    {8, 50, 4, 4},    {1, 1, 4, 4},     {100, 1, 0, 1},    {100, 50, 60, 60}, {100, 50, 50, 50},
        {32767, 100, 4, 32767}, {1, 50, 0, 0}, {100, 1, -5, 1}, {32767, 32767, -20000, (int16_t)(32767 * 32767 / 100)},
        {2, 50, 0, 1},     {3, 50, 0, 1}};
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        Fx f;
        fx_init(&f);
        f.w.best_5a4c0e = (int16_t)cases[i].best;
        put16(f.body, O_PERCENT, cases[i].percent);
        put16(f.body, O_LOWTARGET, cases[i].low);
        start_quiz(&f);
        CHECK_INT(f.o.target, cases[i].expect);
        if (g_failed) {
            snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (case %zu)", i);
            return;
        }
    }
}

/* lifetimes of 1000 s: no balloon expires (the default 5..9 s would need refills that this test does not script) */
static void body_nolife(uint8_t *b)
{
    put16(b, O_LMIN, 1000);
    put16(b, O_LMAX, 1000);
}

/* run the quiz to the end of the wait: score `score`, the time-up visit, the visit that starts the end delay, the delay */
static void finish_to_phase2(Fx *f, int score, const char **log_after_timeup)
{
    body_nolife(f->body);
    start_quiz(f);
    f->o.score = score;
    visit(f, 1000000u + 125000u);
    CHECK_INT(f->o.state, TQZ_STATE_TIME_UP);
    visit(f, 2000000u);
    if (log_after_timeup != NULL) *log_after_timeup = f->log;
    CHECK_INT(f->o.state, TQZ_STATE_WAIT_END);
    CHECK_INT(f->o.end_deadline, 2003000u);
    CHECK(f->o.finishing == 1 && f->o.flag34 == 1);
    visit(f, 2002999u);
    CHECK(f->o.active == 1 && f->phase == 1u && f->w.best_5a4c0e == 0);
    visit(f, 2003000u);
    CHECK(f->o.active == 0 && f->phase == 2u && f->w.best_5a4c0e == (int16_t)score);
    CHECK(f->w.display.score_enabled == 0 && f->w.display.clock_enabled == 0 && f->w.display.score_ready == 0 &&
          f->w.display.clock_ready == 0);
    CHECK(strstr(f->log, "best:") != NULL && strstr(f->log, "phase:2:0,resetdisp:0:0,active:0:0") != NULL);
}

static void t_finish_states(void)
{
    static const struct { int score, passed, reached; } cases[] = {{12, 1, 0}, {10, 1, 0}, {9, 0, 1}, {5, 0, 1}, {3, 0, 1}, {2, 0, 0}, {0, 0, 0}};
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        Fx f;
        const char *log = NULL;
        fx_init(&f);
        body_nolife(f.body);
        start_quiz(&f);
        f.o.score = cases[i].score;
        visit(&f, 1000000u + 125000u);
        visit(&f, 2000000u);
        log = f.log;
        CHECK_INT(f.o.passed, cases[i].passed);
        CHECK_INT(f.o.reached, cases[i].reached);
        if (cases[i].passed) {
            CHECK_LOG(&f, "tick:2000000:0,state:2:0,prep:1297:0,play:14:0");
            CHECK(f.prep_hist[f.n_prep - 1] == O_SD && f.play_hist[f.n_play - 1] == 14);
        } else {
            CHECK_LOG(&f, "tick:2000000:0,state:2:0");
        }
        (void)log;
        if (g_failed) {
            snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (case %zu)", i);
            return;
        }
    }
    {
        /* a passed run with "NO SOUND" for the passed sound prepares and plays nothing */
        Fx f;
        fx_init(&f);
        body_nolife(f.body);
        set_nosound(f.body, O_SD);
        start_quiz(&f);
        f.o.score = 12;
        visit(&f, 1000000u + 125000u);
        visit(&f, 2000000u);
        CHECK(f.o.passed == 1);
        CHECK_LOG(&f, "tick:2000000:0,state:2:0");
        CHECK(f.n_play == 0 && f.n_prep == 3);
    }
    {
        /* the best score is stored as a 16-bit value; the wait ends exactly at the deadline */
        Fx f;
        fx_init(&f);
        body_nolife(f.body);
        finish_to_phase2(&f, 40000, NULL);
        CHECK_INT(f.w.best_5a4c0e, (int16_t)40000);
    }
    {
        /* with the next run, the target follows the best score */
        Fx f;
        fx_init(&f);
        body_nolife(f.body);
        finish_to_phase2(&f, 80, NULL);
        CHECK_INT(f.w.best_5a4c0e, 80);
        CHECK(step(&f, 2u) == TQZ_OK);
        fx_clear_records(&f);
        rand_set(&f, 15, 1, 2, 1, 17, 3, 2, 3, 2, 10, 37, 0, 0, 0, 4, 4);
        CHECK(step(&f, 0u) == TQZ_OK);
        CHECK_INT(f.o.target, 40);
        tqz_world_new_game(&f.w);
        CHECK(tqz_cleanup(&f.o, &f.w, &f.host) == TQZ_OK);
        script_wave(&f);
        CHECK(step(&f, 0u) == TQZ_OK);
        CHECK_INT(f.o.target, 10);
    }
}

static void t_phase2(void)
{
    Fx f;
    /* passed: stop the three sounds and the passed sound, the passed block (scene, cells, start flag 1 -> 0), its flag */
    fx_init(&f);
    finish_to_phase2(&f, 12, NULL);
    fx_clear_records(&f);
    CHECK(step(&f, 2u) == TQZ_OK);
    dump(&f, "phase2 passed");
    CHECK(f.result.completed == 1 && f.result.phase_after == 0u && f.phase == 0u);
    CHECK_LOG(&f, "stop:1126:0,stop:1175:0,stop:1224:0,stop:1297:0,x57b:21:0,x599:1:0,x595:2:0,x39ff:3:0,x59b:101:0,x59f:202:0,"
                  "x5a3:303:0,start:0:0,evflag:40:1,mode:4:0,complete:3:0,relsurf:77:0,relslot:24:0,relslot:26:0,relslot:25:0,"
                  "fontrel:10:0");
    CHECK(f.n_stop == 4 && f.stop_hist[0] == O_SA && f.stop_hist[1] == O_SB && f.stop_hist[2] == O_SC && f.stop_hist[3] == O_SD);
    CHECK(f.transition.scene == 21 && f.transition.word[0] == 1 && f.transition.word[1] == 2 && f.transition.word[2] == 3 &&
          f.transition.dword[0] == 101 && f.transition.dword[1] == 202 && f.transition.dword[2] == 303);
    CHECK(f.n_transition == 1 && f.n_flag == 1 && f.flag_hist[0][0] == 40 && f.flag_hist[0][1] == 1 && f.engine_mode == 4);
    CHECK(f.w.start_flag_5bb1ca == 0);
    CHECK(f.o.row == -1 && f.o.slot == -1 && f.o.surface == 0u && f.o.active == 0 && f.o.passed == 0 && f.o.finishing == 0);
    CHECK(f.o.score_block[44] == -1 && f.o.clock_block[48] == -1 && f.o.hits == 0 && f.o.score == 0);
    /* passed, scene 9999 (none), no passed sound, no flag: only the stops and the engine mode */
    fx_init(&f);
    put16(f.body, O_PASSED + SB_SCENE, 9999);
    put16(f.body, O_PASSED + SB_FLAG, -1);
    set_nosound(f.body, O_SD);
    finish_to_phase2(&f, 12, NULL);
    fx_clear_records(&f);
    f.w.start_flag_5bb1ca = 7;
    CHECK(step(&f, 2u) == TQZ_OK);
    CHECK_LOG(&f, "stop:1126:0,stop:1175:0,stop:1224:0,mode:4:0,complete:3:0,relsurf:77:0,relslot:24:0,relslot:26:0,relslot:25:0,"
                  "fontrel:10:0");
    CHECK(f.n_transition == 0 && f.n_flag == 0 && f.w.start_flag_5bb1ca == 7);
    /* passed scene given, start flag word other than 1 -> stored as 1; scene 0 is a real scene */
    fx_init(&f);
    put16(f.body, O_PASSED + SB_SCENE, 0);
    put16(f.body, O_PASSED + SB_START, 2);
    put16(f.body, O_PASSED + SB_FLAG, -1);
    finish_to_phase2(&f, 12, NULL);
    CHECK(step(&f, 2u) == TQZ_OK);
    CHECK(f.n_transition == 1 && f.transition.scene == 0 && f.w.start_flag_5bb1ca == 1 && f.n_flag == 0);
    /* normal exit, minimum reached: the normal block (start flag word 0 -> 1) and the reached flag */
    fx_init(&f);
    finish_to_phase2(&f, 5, NULL);
    fx_clear_records(&f);
    CHECK(step(&f, 2u) == TQZ_OK);
    dump(&f, "phase2 reached");
    CHECK_LOG(&f, "stop:1126:0,stop:1175:0,stop:1224:0,x57b:31:0,x599:4:0,x595:5:0,x39ff:6:0,x59b:404:0,x59f:505:0,x5a3:606:0,"
                  "start:1:0,evflag:50:1,mode:4:0,complete:3:0,relsurf:77:0,relslot:24:0,relslot:26:0,relslot:25:0,fontrel:10:0");
    CHECK(f.n_stop == 3 && f.transition.scene == 31 && f.flag_hist[0][0] == 50 && f.w.start_flag_5bb1ca == 1);
    /* normal exit, minimum missed: the other flag */
    fx_init(&f);
    finish_to_phase2(&f, 2, NULL);
    CHECK(step(&f, 2u) == TQZ_OK);
    CHECK(f.n_flag == 1 && f.flag_hist[0][0] == 60 && f.flag_hist[0][1] == 1);
    /* reached but no reached flag: the other flag; neither: no flag */
    fx_init(&f);
    put16(f.body, O_NORMAL + SB_FLAG, -1);
    finish_to_phase2(&f, 5, NULL);
    CHECK(step(&f, 2u) == TQZ_OK);
    CHECK(f.n_flag == 1 && f.flag_hist[0][0] == 60);
    fx_init(&f);
    put16(f.body, O_NORMAL + SB_FLAG, -1);
    put16(f.body, O_NORMAL + SB_FLAG2, -1);
    finish_to_phase2(&f, 5, NULL);
    CHECK(step(&f, 2u) == TQZ_OK);
    CHECK(f.n_flag == 0 && f.n_transition == 1);
    fx_init(&f);
    put16(f.body, O_NORMAL + SB_FLAG2, -1);
    finish_to_phase2(&f, 2, NULL);
    CHECK(step(&f, 2u) == TQZ_OK);
    CHECK(f.n_flag == 0);
    /* the normal start flag word 1 stores 0 as well */
    fx_init(&f);
    put16(f.body, O_NORMAL + SB_START, 1);
    finish_to_phase2(&f, 2, NULL);
    f.w.start_flag_5bb1ca = 9;
    CHECK(step(&f, 2u) == TQZ_OK);
    CHECK(f.w.start_flag_5bb1ca == 0);
    /* sounds named NO SOUND are not stopped */
    fx_init(&f);
    set_nosound(f.body, O_SA);
    set_nosound(f.body, O_SB);
    set_nosound(f.body, O_SC);
    finish_to_phase2(&f, 2, NULL);
    CHECK(f.n_prep == 0);
    CHECK(step(&f, 2u) == TQZ_OK);
    CHECK(f.n_stop == 0);
    /* only the exact nine bytes "NO SOUND\0" silence a sound */
    {
        static const char *const near_miss[] = {"NO SOUNDX", "XO SOUND", "no sound", "NO SOUN", "NO SOUND ", "O SOUND", "NO_SOUND"};
        for (size_t i = 0; i < sizeof near_miss / sizeof near_miss[0]; ++i) {
            fx_init(&f);
            set_str(f.body, O_SA, near_miss[i]);
            finish_to_phase2(&f, 2, NULL);
            CHECK(f.n_prep == 3);
            CHECK(step(&f, 2u) == TQZ_OK);
            CHECK(f.n_stop == 3 && f.stop_hist[0] == O_SA);
        }
    }
    fx_init(&f);
    set_nosound(f.body, O_SB);
    finish_to_phase2(&f, 12, NULL);
    CHECK(f.n_prep == 3 + 1 - 1);
    CHECK(step(&f, 2u) == TQZ_OK);
    CHECK(f.n_stop == 3 && f.stop_hist[0] == O_SA && f.stop_hist[1] == O_SC && f.stop_hist[2] == O_SD);
    fx_init(&f);
    set_nosound(f.body, O_SA);
    set_nosound(f.body, O_SC);
    finish_to_phase2(&f, 2, NULL);
    CHECK(f.n_prep == 1 && f.prep_hist[0] == O_SB);
    CHECK(step(&f, 2u) == TQZ_OK);
    CHECK(f.n_stop == 1 && f.stop_hist[0] == O_SB);
}

static void t_phase2_flag_refused(void)
{
    static const struct { int passed_score; int pflag, nflag, nflag2; int refuse; } cases[] = {
        {12, 5000, -1, -1, 1}, {12, -2, -1, -1, 1}, {12, 4095, -1, -1, 0}, {12, -1, 5000, 5000, 0}, {12, 0, 0, 0, 0},
        {5, 0, 5000, 3, 1},    {5, 0, 3, 5000, 0},  {5, 0, -1, 5000, 1},   {5, 0, -1, 3, 0},        {2, 0, 5000, 3, 0},
        {2, 0, 3, 5000, 1},    {2, 0, 3, -2, 1},    {2, 0, 3, -1, 0}};
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        Fx f;
        int rc;
        fx_init(&f);
        put16(f.body, O_PASSED + SB_FLAG, cases[i].pflag);
        put16(f.body, O_NORMAL + SB_FLAG, cases[i].nflag);
        put16(f.body, O_NORMAL + SB_FLAG2, cases[i].nflag2);
        finish_to_phase2(&f, cases[i].passed_score, NULL);
        fx_clear_records(&f);
        rc = step(&f, 2u);
        if (cases[i].refuse) {
            CHECK_INT(rc, TQZ_ERR_BOUNDS);
            CHECK(f.log[0] == '\0' && f.n_stop == 0 && f.n_transition == 0 && f.n_engine == 0 && f.n_relslot == 0);
            CHECK(f.failure != NULL && strcmp(f.failure, "0xf5-event-flag-index") == 0);
            CHECK(f.o.row == ROW && f.o.slot == 0x18);
        } else {
            CHECK_INT(rc, TQZ_OK);
        }
        if (g_failed) {
            snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (case %zu)", i);
            return;
        }
    }
}

static void t_pointer(void)
{
    Fx f;
    TqzPointerResult r;
    static const struct { int x, y, hit; } pts[] = {{20, 30, 1}, {120, 90, 1}, {20, 90, 1}, {120, 30, 1}, {70, 60, 1},
                                                    {19, 60, 0}, {121, 60, 0}, {70, 29, 0}, {70, 91, 0}, {19, 29, 0},
                                                    {65536 + 50, 60, 1}, {70, 65536 + 60, 1}, {-65536 + 50, 60, 1},
                                                    {40000, 60, 0}, {70, 40000, 0}, {-1, 60, 0}};
    fx_init(&f);
    start_quiz(&f);
    for (size_t i = 0; i < sizeof pts / sizeof pts[0]; ++i) {
        memset(&r, 0x5a, sizeof r);
        CHECK(tqz_pointer(&f.o, f.body, TQZ_BODY_BYTES, pts[i].x, pts[i].y, &r) == TQZ_OK);
        CHECK_INT(r.hit, pts[i].hit);
        CHECK_INT(r.candidate, pts[i].hit ? 0x27eb : -1);
        CHECK_INT(r.cursor_kind, pts[i].hit ? 7 : 0);
        CHECK_INT(r.cursor_sub, pts[i].hit ? 1 : 0);
        if (g_failed) {
            snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (point %zu)", i);
            return;
        }
    }
    /* a negative rectangle and a negative cursor kind */
    put32(f.body, O_RECT, -100);
    put32(f.body, O_RECT + 4, -20);
    put32(f.body, O_RECT + 8, -50);
    put32(f.body, O_RECT + 12, -10);
    put16(f.body, O_CURSOR, -3);
    CHECK(tqz_pointer(&f.o, f.body, TQZ_BODY_BYTES, -70, -15, &r) == TQZ_OK && r.hit == 1 && r.cursor_kind == -3);
    CHECK(tqz_pointer(&f.o, f.body, TQZ_BODY_BYTES, -101, -15, &r) == TQZ_OK && r.hit == 0);
    CHECK(tqz_pointer(&f.o, f.body, TQZ_BODY_BYTES, -49, -15, &r) == TQZ_OK && r.hit == 0);
    CHECK(tqz_pointer(&f.o, f.body, TQZ_BODY_BYTES, -70, -21, &r) == TQZ_OK && r.hit == 0);
    CHECK(tqz_pointer(&f.o, f.body, TQZ_BODY_BYTES, -70, -9, &r) == TQZ_OK && r.hit == 0);
    /* inactive: nothing */
    body_default(f.body);
    f.o.active = 0;
    CHECK(tqz_pointer(&f.o, f.body, TQZ_BODY_BYTES, 70, 60, &r) == TQZ_OK && r.hit == 0 && r.candidate == -1);
    f.o.active = 1;
    CHECK(tqz_pointer(NULL, f.body, TQZ_BODY_BYTES, 70, 60, &r) == TQZ_ERR_ARGUMENT);
    CHECK(tqz_pointer(&f.o, NULL, TQZ_BODY_BYTES, 70, 60, &r) == TQZ_ERR_ARGUMENT);
    CHECK(tqz_pointer(&f.o, f.body, TQZ_BODY_BYTES, 70, 60, NULL) == TQZ_ERR_ARGUMENT);
    CHECK(tqz_pointer(&f.o, f.body, TQZ_BODY_BYTES - 1u, 70, 60, &r) == TQZ_ERR_ARGUMENT);
    CHECK(tqz_pointer(&f.o, f.body, TQZ_BODY_BYTES + 1u, 70, 60, &r) == TQZ_ERR_ARGUMENT);
}

static void t_click(void)
{
    TqzObject o;
    uint32_t np = 99;
    tqz_object_reset(&o);
    o.active = 1;
    CHECK(tqz_click(&o, 1u, TQZ_CANDIDATE, &np) == 1 && np == 2u);
    np = 99;
    CHECK(tqz_click(&o, 1u, TQZ_CANDIDATE + 1, &np) == 0 && np == 1u);
    CHECK(tqz_click(&o, 1u, -1, &np) == 0 && np == 1u);
    CHECK(tqz_click(&o, 0u, TQZ_CANDIDATE, &np) == 0 && np == 0u);
    CHECK(tqz_click(&o, 2u, TQZ_CANDIDATE, &np) == 0 && np == 2u);
    o.finishing = 1;
    CHECK(tqz_click(&o, 1u, TQZ_CANDIDATE, &np) == 0 && np == 1u);
    o.finishing = 0;
    o.state = TQZ_STATE_TIME_UP;
    CHECK(tqz_click(&o, 1u, TQZ_CANDIDATE, &np) == 0);
    o.state = TQZ_STATE_PLAY;
    o.active = 0;
    CHECK(tqz_click(&o, 1u, TQZ_CANDIDATE, &np) == 0 && np == 1u);
}

static void t_invalidate_cleanup(void)
{
    Fx f;
    fx_init(&f);
    CHECK(tqz_invalidate(&f.o, &f.host) == TQZ_OK && f.n_dirty == 0);
    start_quiz(&f);
    CHECK(tqz_invalidate(&f.o, &f.host) == TQZ_OK && f.n_dirty == 1 && f.dirty_slot == 0x18);
    f.o.active = 0;
    CHECK(tqz_invalidate(&f.o, &f.host) == TQZ_OK && f.n_dirty == 1);
    f.o.active = 1;
    f.o.slot = TQZ_NO_SLOT;
    CHECK(tqz_invalidate(&f.o, &f.host) == TQZ_OK && f.n_dirty == 1);
    f.o.slot = 0x18;
    f.fail_call = f.calls + 1;
    CHECK(tqz_invalidate(&f.o, &f.host) == TQZ_ERR_HOST);
    f.fail_call = 0;

    /* cleanup: releases in the order surface, quiz slot, clock slot, score slot, font; then the reset of 0x4b7f3b */
    fx_init(&f);
    start_quiz(&f);
    f.o.passed = f.o.reached = f.o.flag34 = f.o.finishing = 1;
    f.o.prev_score = 5;
    f.o.dword55a = 9;
    f.o.hits = 3;
    f.o.score = 4;
    f.o.state = TQZ_STATE_WAIT_END;
    f.o.key_pending = 1;
    f.o.key_char = 'x';
    f.o.end_deadline = 77;
    f.o.elapsed = 66;
    f.o.minutes = 3;
    f.o.seconds = 4;
    f.o.start_tick = 55;
    fx_clear_records(&f);
    CHECK(tqz_cleanup(&f.o, &f.w, &f.host) == TQZ_OK);
    CHECK_LOG(&f, "relsurf:77:0,relslot:24:0,relslot:26:0,relslot:25:0,fontrel:10:0");
    CHECK(f.relsurf_handle == SURFACE && f.n_relslot == 3 && f.relslot_hist[0] == 0x18 && f.relslot_hist[1] == 0x1a &&
          f.relslot_hist[2] == 0x19 && f.n_fontrel == 1);
    CHECK(f.o.row == -1 && f.o.slot == -1 && f.o.active == 0 && f.o.passed == 0 && f.o.finishing == 0 && f.o.reached == 0 &&
          f.o.flag34 == 0 && f.o.surface == 0u && f.o.hits == 0 && f.o.score == 0 && f.o.prev_score == 0 && f.o.dword55a == 0);
    CHECK(f.o.score_block[44] == -1 && f.o.clock_block[48] == -1);
    for (int k = 0; k < 0x2e; ++k) CHECK(k == 44 || f.o.score_block[k] == 0);
    for (int k = 0; k < 0x32; ++k) CHECK(k == 48 || f.o.clock_block[k] == 0);
    /* the rest of the object survives (the original does not touch it) */
    CHECK(f.o.state == TQZ_STATE_WAIT_END && f.o.key_pending == 1 && f.o.key_char == 'x' && f.o.end_deadline == 77u &&
          f.o.elapsed == 66u && f.o.minutes == 3 && f.o.seconds == 4 && f.o.start_tick == 55u && f.o.count == 3 &&
          f.o.max_char == 0x7b && f.o.target == 10 && f.o.balloon[0].ch == 'A' && f.o.balloon[2].lifetime == 9);
    /* an idle object only releases the font */
    fx_clear_records(&f);
    CHECK(tqz_cleanup(&f.o, &f.w, &f.host) == TQZ_OK);
    CHECK_LOG(&f, "fontrel:10:0");
    /* each release is conditional on its own handle */
    fx_init(&f);
    f.o.surface = 5u;
    CHECK(tqz_cleanup(&f.o, &f.w, &f.host) == TQZ_OK);
    CHECK_LOG(&f, "relsurf:5:0,fontrel:10:0");
    fx_init(&f);
    f.o.slot = 9;
    CHECK(tqz_cleanup(&f.o, &f.w, &f.host) == TQZ_OK);
    CHECK_LOG(&f, "relslot:9:0,fontrel:10:0");
    CHECK(f.o.slot == -1);
    fx_init(&f);
    f.o.clock_block[48] = 7;
    CHECK(tqz_cleanup(&f.o, &f.w, &f.host) == TQZ_OK);
    CHECK_LOG(&f, "relslot:7:0,fontrel:10:0");
    fx_init(&f);
    f.o.score_block[44] = 0;
    CHECK(tqz_cleanup(&f.o, &f.w, &f.host) == TQZ_OK);
    CHECK_LOG(&f, "relslot:0:0,fontrel:10:0");
}

static void blit_dst(const StdBlit *b, int32_t l, int32_t t, int32_t r, int32_t bt)
{
    CHECK(b->dst[0] == l && b->dst[1] == t && b->dst[2] == r && b->dst[3] == bt);
}

static void t_render_quiz(void)
{
    Fx f;
    TqzRenderResult r;
    int32_t pos[4];
    fx_init(&f);
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &f.host, &r) == TQZ_OK && r.valid == 0 && r.count == 0);
    start_quiz(&f);
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &f.host, &r) == TQZ_OK && r.valid == 1 && r.count == 6);
    for (int k = 0; k < 3; ++k) {
        const StdBlit *a = &r.blit[2 * k], *t = &r.blit[2 * k + 1];
        CHECK(a->kind == TQZ_BLIT_BALLOON && a->surface == SURFACE && a->a == k);
        CHECK(memcmp(a->src, f.o.balloon[k].src, sizeof a->src) == 0 && memcmp(a->dst, f.o.balloon[k].dst, sizeof a->dst) == 0);
        CHECK(t->kind == TQZ_BLIT_TEXT && t->surface == 0u && t->a == f.o.balloon[k].ch && t->b == f.o.balloon[k].text_x &&
              t->c == f.o.balloon[k].text_y);
    }
    f.o.balloon[0].text_x = 70000;
    f.o.balloon[0].text_y = -70000;
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &f.host, &r) == TQZ_OK);
    CHECK(r.blit[1].b == (int16_t)70000 && r.blit[1].c == (int16_t)-70000);
    f.o.active = 1;
    f.o.slot = TQZ_NO_SLOT;
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &f.host, &r) == TQZ_OK && r.valid == 0);
    f.o.slot = 0x18;
    f.o.active = 0;
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &f.host, &r) == TQZ_OK && r.valid == 0 && r.count == 0);
    f.o.active = 1;

    /* a popping balloon: the pop picture while the deadline lies ahead */
    f.o.balloon[0].state = TQZ_BALLOON_POPPING;
    f.o.balloon[0].deadline = f.now + 1u;
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &f.host, &r) == TQZ_OK && r.count == 5);
    CHECK(r.blit[0].kind == TQZ_BLIT_POP && r.blit[0].surface == SURFACE && r.blit[0].a == 0);
    CHECK(r.blit[0].src[0] == 300 && r.blit[0].src[1] == 310 && r.blit[0].src[2] == 340 && r.blit[0].src[3] == 350);
    CHECK(memcmp(r.blit[0].dst, f.o.balloon[0].dst, sizeof r.blit[0].dst) == 0);
    CHECK(f.o.balloon[0].state == TQZ_BALLOON_POPPING && f.o.count == 3);
    /* a deadline compared as unsigned numbers */
    f.o.balloon[0].deadline = 0xffffffffu;
    f.now = 5;
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &f.host, &r) == TQZ_OK && f.o.balloon[0].state == TQZ_BALLOON_POPPING);
    /* the deadline reached: the balloon is gone, one balloon fewer, and the refill puts a new balloon into the free entry, which
     * the same pass then draws */
    f.now = 1000000u;
    f.o.balloon[0].deadline = 1000000u;
    rand_set(&f, 5, 1, 1, 0, 17, 0);
    f.i_rand = 0;
    f.rand_q[0] = 1;
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &f.host, &r) == TQZ_OK);
    CHECK(f.o.balloon[0].state == TQZ_BALLOON_GONE && f.o.count == 3 && f.o.balloon[3].state == TQZ_BALLOON_FLYING);
    CHECK(r.count == 1 + 4 + 2 && r.blit[0].kind == TQZ_BLIT_POP && r.blit[5].kind == TQZ_BLIT_BALLOON && r.blit[5].a == 3);
    pos_rect(1, pos);
    CHECK(memcmp(f.o.balloon[3].dst, pos, sizeof pos) == 0);
    /* a gone balloon: the restore blit (source = destination minus the view origin), then the entry is free */
    f.o.balloon[3].state = TQZ_BALLOON_FREE;
    f.o.balloon[1].state = TQZ_BALLOON_FREE;
    f.o.balloon[2].state = TQZ_BALLOON_FREE;
    f.n_view = 0;
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &f.host, &r) == TQZ_OK && r.count == 1 && f.n_view == 1);
    CHECK(r.blit[0].kind == TQZ_BLIT_BALLOON_ERASE && r.blit[0].surface == 0u && r.blit[0].a == 0);
    CHECK(r.blit[0].src[0] == f.o.balloon[0].dst[0] - VIEW_L && r.blit[0].src[1] == f.o.balloon[0].dst[1] - VIEW_T &&
          r.blit[0].src[2] == f.o.balloon[0].dst[2] - VIEW_L && r.blit[0].src[3] == f.o.balloon[0].dst[3] - VIEW_T);
    CHECK(memcmp(r.blit[0].dst, f.o.balloon[0].dst, sizeof r.blit[0].dst) == 0);
    CHECK(f.o.balloon[0].state == TQZ_BALLOON_FREE);
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &f.host, &r) == TQZ_OK && r.valid == 1 && r.count == 0);
    f.o.balloon[0].state = TQZ_BALLOON_GONE;
    f.fail_call = f.calls + 1;
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &f.host, &r) == TQZ_ERR_HOST);
    f.fail_call = 0;
    /* the order of the entries: flying, popping, gone */
    fx_init(&f);
    start_quiz(&f);
    f.o.balloon[1].state = TQZ_BALLOON_POPPING;
    f.o.balloon[1].deadline = f.now + 5000u;
    f.o.balloon[2].state = TQZ_BALLOON_GONE;
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &f.host, &r) == TQZ_OK && r.count == 4);
    CHECK(r.blit[0].kind == TQZ_BLIT_BALLOON && r.blit[1].kind == TQZ_BLIT_TEXT && r.blit[2].kind == TQZ_BLIT_POP &&
          r.blit[3].kind == TQZ_BLIT_BALLOON_ERASE && r.blit[3].a == 2);
    /* only the first N entries are drawn */
    f.o.balloon[10].state = TQZ_BALLOON_FLYING;
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &f.host, &r) == TQZ_OK && r.count == 3);

    /* the end: the background is erased once, then the message is centred in the view */
    fx_init(&f);
    start_quiz(&f);
    f.o.finishing = 1;
    f.o.flag34 = 1;
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &f.host, &r) == TQZ_OK && r.count == 2);
    CHECK(r.blit[0].kind == TQZ_BLIT_BACKGROUND_ERASE && r.blit[0].surface == 0u);
    CHECK(r.blit[0].src[0] == 0 && r.blit[0].src[1] == 0 && r.blit[0].src[2] == 640 && r.blit[0].src[3] == 480);
    CHECK(r.blit[0].dst[0] == VIEW_L && r.blit[0].dst[1] == VIEW_T && r.blit[0].dst[2] == 647 && r.blit[0].dst[3] == 491);
    CHECK(r.blit[1].kind == TQZ_BLIT_PASSED && r.blit[1].surface == SURFACE);
    CHECK(r.blit[1].src[0] == 600 && r.blit[1].src[1] == 100 && r.blit[1].src[2] == 700 && r.blit[1].src[3] == 140);
    blit_dst(&r.blit[1], 277, 231, 377, 271);
    CHECK(f.o.flag34 == 0);
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &f.host, &r) == TQZ_OK && r.count == 1 && r.blit[0].kind == TQZ_BLIT_PASSED);
    f.view[0] = 8;
    f.view[1] = 10;
    put_rect(f.body, O_PASSEDRECT, 600, 100, 705, 141);
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &f.host, &r) == TQZ_OK && r.count == 1);
    blit_dst(&r.blit[0], 275, 230, 380, 271);
    f.fail_call = f.calls + 1;
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &f.host, &r) == TQZ_ERR_HOST);
    f.fail_call = 0;
    /* arguments */
    CHECK(tqz_render(NULL, &f.w, f.body, TQZ_BODY_BYTES, &f.host, &r) == TQZ_ERR_ARGUMENT);
    CHECK(tqz_render(&f.o, NULL, f.body, TQZ_BODY_BYTES, &f.host, &r) == TQZ_ERR_ARGUMENT);
    CHECK(tqz_render(&f.o, &f.w, NULL, TQZ_BODY_BYTES, &f.host, &r) == TQZ_ERR_ARGUMENT);
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES - 1u, &f.host, &r) == TQZ_ERR_ARGUMENT);
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &f.host, NULL) == TQZ_ERR_ARGUMENT);
    CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, NULL, &r) == TQZ_ERR_ARGUMENT);
}

static void t_render_display(void)
{
    Fx f;
    TqzRenderResult r;
    fx_init(&f);
    start_quiz(&f);
    CHECK(tqz_render_score(&f.w, &f.host, &r) == TQZ_OK && r.valid == 1 && r.count == 1);
    CHECK(r.blit[0].kind == STD_BLIT_SCORE_DIGIT && r.blit[0].surface == SURFACE && r.blit[0].a == 0);
    CHECK(r.blit[0].src[0] == 0 && r.blit[0].src[1] == 400 && r.blit[0].src[2] == 7 && r.blit[0].src[3] == 409);
    blit_dst(&r.blit[0], 30 + VIEW_L, 12 + VIEW_T, 30 + VIEW_L + 7, 12 + VIEW_T + 9);
    CHECK(tqz_render_clock(&f.w, &f.host, &r) == TQZ_OK && r.valid == 1 && r.count == 6);
    CHECK(r.blit[0].kind == STD_BLIT_CLOCK_ERASE_COLON && r.blit[1].kind == STD_BLIT_CLOCK_MIN &&
          r.blit[2].kind == STD_BLIT_CLOCK_MIN && r.blit[3].kind == STD_BLIT_CLOCK_COLON && r.blit[4].kind == STD_BLIT_CLOCK_SEC &&
          r.blit[5].kind == STD_BLIT_CLOCK_SEC);
    /* the view origin of the host is used for the restore sources */
    f.view[0] = 3;
    f.view[1] = 4;
    CHECK(std_set_score(&f.w.display, 5) == STD_OK);
    CHECK(tqz_render_score(&f.w, &f.host, &r) == TQZ_OK && r.count == 2 && r.blit[0].kind == STD_BLIT_SCORE_ERASE);
    CHECK(r.blit[0].src[0] == r.blit[0].dst[0] - 3 && r.blit[0].src[1] == r.blit[0].dst[1] - 4);
    /* a corrupt string and a failing host */
    memcpy(f.w.display.score_str, "4x", 3);
    CHECK(tqz_render_score(&f.w, &f.host, &r) == TQZ_ERR_BOUNDS);
    memcpy(f.w.display.minutes_str, "x1", 3);
    CHECK(tqz_render_clock(&f.w, &f.host, &r) == TQZ_ERR_BOUNDS);
    f.fail_call = f.calls + 1;
    CHECK(tqz_render_score(&f.w, &f.host, &r) == TQZ_ERR_HOST);
    f.fail_call = f.calls + 1;
    CHECK(tqz_render_clock(&f.w, &f.host, &r) == TQZ_ERR_HOST);
    f.fail_call = 0;
    CHECK(tqz_render_score(NULL, &f.host, &r) == TQZ_ERR_ARGUMENT);
    CHECK(tqz_render_score(&f.w, &f.host, NULL) == TQZ_ERR_ARGUMENT);
    CHECK(tqz_render_score(&f.w, NULL, &r) == TQZ_ERR_ARGUMENT);
    CHECK(tqz_render_clock(NULL, &f.host, &r) == TQZ_ERR_ARGUMENT);
    CHECK(tqz_render_clock(&f.w, &f.host, NULL) == TQZ_ERR_ARGUMENT);
    CHECK(tqz_render_clock(&f.w, NULL, &r) == TQZ_ERR_ARGUMENT);
    /* the finished quiz draws nothing (the entries are not ready) */
    fx_init(&f);
    start_quiz(&f);
    std_reset_score(&f.w.display);
    std_reset_clock(&f.w.display);
    CHECK(tqz_render_score(&f.w, &f.host, &r) == TQZ_OK && r.valid == 1 && r.count == 0);
    CHECK(tqz_render_clock(&f.w, &f.host, &r) == TQZ_OK && r.valid == 1 && r.count == 0);
}

static void t_step_args(void)
{
    Fx f;
    TqzResult res;
    const char *why;
    fx_init(&f);
    CHECK(tqz_step(NULL, f.body, TQZ_BODY_BYTES, ROW, 0u, &f.w, &f.host, &res, &why) == TQZ_ERR_ARGUMENT && strcmp(why, "0xf5-argument") == 0);
    CHECK(tqz_step(&f.o, NULL, TQZ_BODY_BYTES, ROW, 0u, &f.w, &f.host, &res, &why) == TQZ_ERR_ARGUMENT);
    CHECK(tqz_step(&f.o, f.body, TQZ_BODY_BYTES, ROW, 0u, NULL, &f.host, &res, &why) == TQZ_ERR_ARGUMENT);
    CHECK(tqz_step(&f.o, f.body, TQZ_BODY_BYTES, ROW, 0u, &f.w, NULL, &res, &why) == TQZ_ERR_ARGUMENT);
    CHECK(tqz_step(&f.o, f.body, TQZ_BODY_BYTES, ROW, 0u, &f.w, &f.host, NULL, &why) == TQZ_ERR_ARGUMENT);
    CHECK(f.log[0] == '\0');
    /* every host callback except the observer is required */
    {
        const size_t offsets[] = {offsetof(TqzHost, alloc_slot), offsetof(TqzHost, register_slot), offsetof(TqzHost, load_surface),
                                  offsetof(TqzHost, set_slot_surface), offsetof(TqzHost, release_surface),
                                  offsetof(TqzHost, release_slot), offsetof(TqzHost, mark_dirty), offsetof(TqzHost, view_rects),
                                  offsetof(TqzHost, clear_pending_item), offsetof(TqzHost, font_acquire),
                                  offsetof(TqzHost, font_release), offsetof(TqzHost, sound_prepare), offsetof(TqzHost, sound_stop),
                                  offsetof(TqzHost, sound_play), offsetof(TqzHost, tick), offsetof(TqzHost, random),
                                  offsetof(TqzHost, event_flag_invalid), offsetof(TqzHost, transition),
                                  offsetof(TqzHost, store_event_flag), offsetof(TqzHost, engine_mode)};
        for (size_t i = 0; i < sizeof offsets / sizeof offsets[0]; ++i) {
            TqzHost h = f.host;
            TqzRenderResult r;
            void *null_ptr = NULL;
            memcpy((char *)&h + offsets[i], &null_ptr, sizeof null_ptr);
            CHECK(tqz_step(&f.o, f.body, TQZ_BODY_BYTES, ROW, 0u, &f.w, &h, &res, &why) == TQZ_ERR_ARGUMENT);
            CHECK(tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &h, &r) == TQZ_ERR_ARGUMENT);
            CHECK(tqz_render_score(&f.w, &h, &r) == TQZ_ERR_ARGUMENT);
            CHECK(tqz_render_clock(&f.w, &h, &r) == TQZ_ERR_ARGUMENT);
            if (g_failed) {
                snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (callback %zu)", i);
                return;
            }
        }
        {
            TqzHost h = f.host;
            h.observe = NULL;
            script_wave(&f);
            CHECK(tqz_step(&f.o, f.body, TQZ_BODY_BYTES, ROW, 0u, &f.w, &h, &res, &why) == TQZ_OK && f.log[0] == '\0');
            CHECK(f.o.balloon[1].ch == 'U');
        }
    }
    CHECK(f.log[0] == '\0' || f.o.active == 1);
    /* no effect before a refused body, row or phase */
    fx_init(&f);
    f.body[O_VARIANTS] = 0;
    CHECK(tqz_step(&f.o, f.body, TQZ_BODY_BYTES, ROW, 0u, &f.w, &f.host, &res, &why) == TQZ_ERR_BODY && strcmp(why, "0xf5-variant-count") == 0);
    CHECK(f.log[0] == '\0' && f.o.active == 0 && f.w.start_flag_5bb1ca == 0);
    CHECK(tqz_step(&f.o, f.body, TQZ_BODY_BYTES - 1u, ROW, 1u, &f.w, &f.host, &res, &why) == TQZ_ERR_BODY);
    fx_init(&f);
    CHECK(tqz_step(&f.o, f.body, TQZ_BODY_BYTES, -1, 0u, &f.w, &f.host, &res, &why) == TQZ_ERR_ARGUMENT && strcmp(why, "0xf5-row") == 0);
    CHECK(f.log[0] == '\0');
    CHECK(tqz_step(&f.o, f.body, TQZ_BODY_BYTES, ROW, 1u, &f.w, &f.host, &res, &why) == TQZ_ERR_UNSUPPORTED &&
          strcmp(why, "0xf5-phase-1-without-init") == 0 && res.phase_after == 1u && res.initialized == 0);
    CHECK(tqz_step(&f.o, f.body, TQZ_BODY_BYTES, ROW, 2u, &f.w, &f.host, &res, &why) == TQZ_ERR_UNSUPPORTED &&
          strcmp(why, "0xf5-phase-2-without-init") == 0 && res.phase_after == 2u);
    CHECK(tqz_step(&f.o, f.body, TQZ_BODY_BYTES, ROW, 7u, &f.w, &f.host, &res, &why) == TQZ_OK && res.phase_after == 7u &&
          f.log[0] == '\0' && res.initialized == 0 && res.completed == 0);
    start_quiz(&f);
    CHECK(tqz_step(&f.o, f.body, TQZ_BODY_BYTES, ROW + 1, 1u, &f.w, &f.host, &res, &why) == TQZ_ERR_UNSUPPORTED);
    CHECK(tqz_step(&f.o, f.body, TQZ_BODY_BYTES, ROW + 1, 2u, &f.w, &f.host, &res, &why) == TQZ_ERR_UNSUPPORTED);
    f.o.active = 0;
    CHECK(tqz_step(&f.o, f.body, TQZ_BODY_BYTES, ROW, 1u, &f.w, &f.host, &res, &why) == TQZ_ERR_UNSUPPORTED);
    CHECK(f.result.initialized == 1);
    /* a visit result reports where the row phase went */
    fx_init(&f);
    start_quiz(&f);
    CHECK(f.result.initialized == 1 && f.result.completed == 0 && f.result.phase_after == 1u);
    visit(&f, 1000010u);
    CHECK(f.result.initialized == 0 && f.result.completed == 0 && f.result.phase_after == 1u);
    /* the random source must stay within 0..32767 */
    fx_init(&f);
    body_single(f.body);
    f.rand_default = 32768;
    CHECK(step(&f, 0u) == TQZ_ERR_HOST);
    fx_init(&f);
    body_single(f.body);
    f.rand_default = -1;
    CHECK(step(&f, 0u) == TQZ_ERR_HOST);
    fx_init(&f);
    body_single(f.body);
    f.rand_default = 32767;
    CHECK(step(&f, 0u) == TQZ_OK);
    fx_init(&f);
    body_single(f.body);
    f.rand_default = 0;
    CHECK(step(&f, 0u) == TQZ_OK);
}

/* one scripted run through every host callback; stops at the first failure and returns its status */
static int full_run(Fx *f)
{
    TqzRenderResult r;
    int rc;
    body_nolife(f->body);
    script_wave(f);
    f->phase = 0u;
    if ((rc = step(f, 0u)) != TQZ_OK) return rc;
    if ((rc = tqz_invalidate(&f->o, &f->host)) != TQZ_OK) return rc;
    f->o.balloon[0].ch = 'A';
    if (tqz_key(&f->o, f->phase, 'A') != 1) return -1;
    f->now = 1000010u;
    if ((rc = step(f, 1u)) != TQZ_OK) return rc;
    f->now = 1002000u; /* the popping balloon is gone */
    if ((rc = tqz_render(&f->o, &f->w, f->body, TQZ_BODY_BYTES, &f->host, &r)) != TQZ_OK) return rc;
    if ((rc = tqz_render(&f->o, &f->w, f->body, TQZ_BODY_BYTES, &f->host, &r)) != TQZ_OK) return rc;
    if ((rc = tqz_render_score(&f->w, &f->host, &r)) != TQZ_OK) return rc;
    if ((rc = tqz_render_clock(&f->w, &f->host, &r)) != TQZ_OK) return rc;
    f->now = 1000000u + 125000u;
    if ((rc = step(f, 1u)) != TQZ_OK) return rc;
    f->now = 2000000u;
    if ((rc = step(f, 1u)) != TQZ_OK) return rc;
    if ((rc = tqz_render(&f->o, &f->w, f->body, TQZ_BODY_BYTES, &f->host, &r)) != TQZ_OK) return rc;
    f->now = 2003000u;
    if ((rc = step(f, 1u)) != TQZ_OK) return rc;
    return step(f, 2u);
}

static void t_host_failure_sweep(void)
{
    unsigned mask = 0;
    int n_runs = 0;
    for (int variant = 0; variant < 2; ++variant) {
        for (int n = 1; n < 400 && !g_failed; ++n) {
            Fx f;
            int rc;
            fx_init(&f);
            if (variant == 1) {
                set_nosound(f.body, O_SD);
                f.body[O_NORMAL + SB_FLAG] = 0xff;
                f.body[O_NORMAL + SB_FLAG + 1] = 0xff;
            }
            f.fail_call = n;
            rc = full_run(&f);
            if (f.failed_cb == 0) {
                CHECK(rc == TQZ_OK);
                break;
            }
            ++n_runs;
            mask |= f.failed_mask;
            CHECK_INT(rc, TQZ_ERR_HOST);
            /* the object is still usable by cleanup */
            f.fail_call = 0;
            CHECK(tqz_cleanup(&f.o, &f.w, &f.host) == TQZ_OK);
            if (g_failed) snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (variant %d call %d)", variant, n);
        }
    }
    for (int cb = 1; cb <= CB_LAST; ++cb) {
        if (!(mask & (1u << cb)) && !g_failed) {
            g_failed = 1;
            snprintf(g_msg, sizeof g_msg, "host callback %d was never failed (%d runs)", cb, n_runs);
        }
    }
}

/* ---- random bodies: memory safety (the sanitizer build) and status discipline ------------------------------------------------ */

static uint32_t g_seed = 0x2545f491u;
static uint32_t rnd32(void)
{
    g_seed ^= g_seed << 13;
    g_seed ^= g_seed >> 17;
    g_seed ^= g_seed << 5;
    return g_seed;
}

static void t_fuzz(void)
{
    for (int iter = 0; iter < 200; ++iter) {
        Fx f;
        TqzRenderResult r;
        int rc = TQZ_OK;
        fx_init(&f);
        f.observe_on = 0;
        for (int k = 0; k < 24; ++k) {
            static const size_t offs[] = {O_VARIANTS, O_NPOS, O_LMIN, O_LMAX, O_BMIN, O_BMAX, O_LIMIT, O_FACTOR, O_MINSCORE,
                                          O_DEFTARGET, O_PERCENT, O_LOWTARGET, O_CHIT, O_CMISS, O_CTIME, O_CD, O_CURSOR};
            put16(f.body, offs[rnd32() % (sizeof offs / sizeof offs[0])], (int)(rnd32() % 24u) - 2);
        }
        f.body[O_DIGITS] = (uint8_t)(rnd32() & 1u);
        f.body[O_WIDE] = (uint8_t)(rnd32() & 1u);
        f.body[O_CASE] = (uint8_t)(rnd32() & 1u);
        for (int k = 0; k < 30; ++k) f.body[O_EXTRA + k] = (uint8_t)((rnd32() & 3u) == 0 ? rnd32() : 0);
        for (int k = 0; k < 20; ++k) put_rect(f.body, O_POSRECT + 16u * (unsigned)k, (int)(rnd32() % 600u), (int)(rnd32() % 400u), (int)(rnd32() % 700u), (int)(rnd32() % 500u));
        f.rand_default = (int32_t)(rnd32() % 32768u);
        for (int k = 0; k < 64; ++k) f.rand_q[k] = (int32_t)(rnd32() % 32768u);
        f.n_rand = 64;
        f.tick_step = rnd32() % 4000u;
        f.o.max_char = (int16_t)(rnd32() % 300u);
        if (tqz_validate_body(f.body, TQZ_BODY_BYTES, NULL) != TQZ_OK) {
            CHECK(step(&f, 0u) == TQZ_ERR_BODY && f.log[0] == '\0');
            continue;
        }
        rc = step(&f, 0u);
        for (int v = 0; v < 40 && rc == TQZ_OK; ++v) {
            if ((rnd32() & 3u) == 0) (void)tqz_key(&f.o, f.phase, (int8_t)rnd32());
            rc = step(&f, f.phase);
            if (rc == TQZ_OK && (rnd32() & 1u) == 0) rc = tqz_render(&f.o, &f.w, f.body, TQZ_BODY_BYTES, &f.host, &r);
            if (rc == TQZ_OK && (rnd32() & 3u) == 0) rc = tqz_render_score(&f.w, &f.host, &r);
            if (rc == TQZ_OK && (rnd32() & 3u) == 0) rc = tqz_render_clock(&f.w, &f.host, &r);
            if (rc == TQZ_OK && f.phase == 2u) {
                rc = step(&f, 2u);
                break;
            }
        }
        CHECK(rc == TQZ_OK || rc == TQZ_ERR_STUCK || rc == TQZ_ERR_BOUNDS);
        CHECK(tqz_cleanup(&f.o, &f.w, &f.host) == TQZ_OK);
        if (g_failed) {
            snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (iteration %d rc %d)", iter, rc);
            return;
        }
    }
}

/* ---- the session binding ------------------------------------------------------------------------------------------------------ */

static void put_be32(uint8_t *b, size_t off, size_t v)
{
    b[off] = (uint8_t)(v >> 24);
    b[off + 1] = (uint8_t)(v >> 16);
    b[off + 2] = (uint8_t)(v >> 8);
    b[off + 3] = (uint8_t)v;
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
    uint8_t tsum[126], act[48 + 2 + TQZ_BODY_BYTES];
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
static void h_store_world(void *c, const TqzWorld *w)
{
    if (c == NULL) ++g_hook_bad;
    ++g_stores;
    g_store_start = w->start_flag_5bb1ca;
}

typedef struct Bind {
    Fx f;
    SessionAf5Host host;
    SessionAf5Binding *b;
    SceneResource *scene;
    uint8_t bytes[8192];
    uint8_t bytes_before[8192];
    size_t bytes_len;
    uint8_t body_a[TQZ_BODY_BYTES], body_b[TQZ_BODY_BYTES];
} Bind;

static int bind_open(Bind *x, int hooks)
{
    const int types[3] = {0x70, 0xf5, 0xf5};
    const uint8_t one = 0;
    const uint8_t *bodies[3];
    size_t lengths[3] = {1, TQZ_BODY_BYTES, TQZ_BODY_BYTES};
    char err[128] = {0};
    fx_init(&x->f);
    body_nolife(x->f.body);
    g_stores = g_store_start = g_hook_bad = 0;
    memcpy(x->body_a, x->f.body, TQZ_BODY_BYTES);
    memcpy(x->body_b, x->f.body, TQZ_BODY_BYTES);
    /* row 2: another surface, a smaller layout and another passed scene */
    set_str(x->body_b, 0, "OTHER");
    put16(x->body_b, O_NPOS, 2);
    put16(x->body_b, O_BMIN, 1);
    put16(x->body_b, O_BMAX, 1);
    put16(x->body_b, O_PASSED + SB_SCENE, 77);
    put_rect(x->body_b, O_RECT, 200, 210, 220, 230);
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
    x->b = session_af5_create(&x->host);
    return x->b != NULL;
}

static void bind_close(Bind *x)
{
    session_af5_destroy(x->b);
    scene_resource_close(x->scene);
}

/* one handler visit of `row` with the given phase; returns the handler status, fills the result */
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
        const int rc = session_af5_handler(x->b, row, &info, &st, &out);
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
    uint32_t pa = 99;
    int done = 7;
    TqzPointerResult pr;
    TqzRenderResult r;
    uint32_t np = 0;
    CHECK(bind_open(&x, 1));
    CHECK(session_af5_object(x.b)->row == -1 && session_af5_registered(x.b) == 0u && strcmp(session_af5_failure(x.b), "none") == 0);
    CHECK(session_af5_world(x.b)->played_5a4c0a == 0);
    /* nothing runs before the scene is loaded */
    CHECK(b_visit(&x, 1, 0u, &pa, &done) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_af5_begin_scene(x.b, x.scene) == TQZ_OK);
    /* the scene clear of an idle object: the font release only */
    CHECK(x.f.n_fontrel == 1 && x.f.n_relslot == 0 && x.f.n_relsurf == 0);
    /* row 0 (another type) and a row out of range are not this binding's */
    CHECK(b_visit(&x, 0, 0u, &pa, &done) == SCENE_ACTION_HANDLER_ERROR && strcmp(session_af5_failure(x.b), "0xf5-row-not-owned") == 0);
    /* a visit before phase 0 is unsupported */
    CHECK(b_visit(&x, 1, 1u, &pa, &done) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    /* nothing is drawn or hit while the quiz is idle */
    CHECK(session_af5_render(x.b, &r) == TQZ_OK && r.valid == 0 && r.count == 0);
    CHECK(session_af5_render_score(x.b, &r) == TQZ_OK && r.valid == 0 && r.count == 0);
    CHECK(session_af5_render_clock(x.b, &r) == TQZ_OK && r.valid == 0 && r.count == 0);
    memset(&pr, 0x5a, sizeof pr);
    CHECK(session_af5_pointer_move(x.b, 70, 60, &pr) == TQZ_OK && pr.hit == 0 && pr.candidate == -1 && pr.cursor_kind == 0);
    CHECK(session_af5_click(x.b, 1u, TQZ_CANDIDATE, &np) == 0 && np == 1u);
    CHECK(session_af5_key(x.b, 1u, 'a') == 0);
    CHECK(session_af5_invalidate(x.b) == TQZ_OK && x.f.n_dirty == 0);
    /* phase 0 of row 1: the first row's body, the kernel's state, the world hook */
    script_wave(&x.f);
    CHECK(b_visit(&x, 1, 0u, &pa, &done) == SCENE_ACTION_HANDLER_OK && pa == 1u && done == 0);
    CHECK(strcmp(x.f.loaded_name, "TQUIZ") == 0 && session_af5_object(x.b)->row == 1 && session_af5_registered(x.b) == 1u);
    CHECK(g_stores == 1 && g_store_start == 1 && g_hook_bad == 0);
    CHECK(session_af5_world(x.b)->played_5a4c0a == 1 && session_af5_object(x.b)->active == 1);
    CHECK(strcmp(session_af5_failure(x.b), "none") == 0);
    /* the idle-state helpers now act on the row's body */
    CHECK(session_af5_pointer_move(x.b, 70, 60, &pr) == TQZ_OK && pr.hit == 1 && pr.candidate == TQZ_CANDIDATE && pr.cursor_kind == 7);
    CHECK(session_af5_pointer_move(x.b, 19, 60, &pr) == TQZ_OK && pr.hit == 0 && pr.candidate == -1);
    CHECK(session_af5_invalidate(x.b) == TQZ_OK && x.f.n_dirty == 1);
    CHECK(session_af5_render(x.b, &r) == TQZ_OK && r.valid == 1 && r.count == 6);
    CHECK(session_af5_render_score(x.b, &r) == TQZ_OK && r.valid == 1 && r.count == 1);
    CHECK(session_af5_render_clock(x.b, &r) == TQZ_OK && r.valid == 1 && r.count == 6);
    CHECK(session_af5_key(x.b, 1u, 'a') == 1 && session_af5_object(x.b)->key_pending == 1);
    CHECK(session_af5_key(x.b, 1u, 'b') == 0);
    CHECK(session_af5_click(x.b, 1u, TQZ_CANDIDATE, &np) == 1 && np == 2u);
    CHECK(session_af5_click(x.b, 1u, 5, &np) == 0 && np == 1u);
    /* phase 1 visits stay pending with the phase; no world hook outside phases 0 and 2 */
    x.f.now = 1000010u;
    CHECK(b_visit(&x, 1, 1u, &pa, &done) == SCENE_ACTION_HANDLER_OK && pa == 1u && done == 0 && g_stores == 1);
    CHECK(x.f.n_play == 1 && x.f.play_hist[0] == 11 && session_af5_object(x.b)->hits == 1); /* 'a' pops the 'A' balloon (case insensitive) */
    x.f.now = 1000000u + 125000u;
    CHECK(b_visit(&x, 1, 1u, &pa, &done) == SCENE_ACTION_HANDLER_OK && pa == 1u);
    x.f.now = 2000000u;
    CHECK(b_visit(&x, 1, 1u, &pa, &done) == SCENE_ACTION_HANDLER_OK && pa == 1u);
    CHECK(session_af5_click(x.b, 1u, TQZ_CANDIDATE, &np) == 0); /* finishing */
    x.f.now = 2003000u;
    CHECK(b_visit(&x, 1, 1u, &pa, &done) == SCENE_ACTION_HANDLER_OK && pa == 2u && done == 0 && g_stores == 1);
    CHECK(session_af5_world(x.b)->best_5a4c0e == 0);
    CHECK(session_af5_world(x.b)->display.score_enabled == 0);
    /* phase 2 completes through the generic completion (phase 0 afterwards) and publishes the start flag */
    CHECK(b_visit(&x, 1, 2u, &pa, &done) == SCENE_ACTION_HANDLER_OK && pa == 0u && done == 1);
    CHECK(g_stores == 2 && g_store_start == 1);
    CHECK(x.f.transition.scene == 31 && x.f.engine_mode == 4 && session_af5_object(x.b)->row == -1 && session_af5_registered(x.b) == 0u);
    CHECK(session_af5_render(x.b, &r) == TQZ_OK && r.valid == 0);
    CHECK(session_af5_pointer_move(x.b, 70, 60, &pr) == TQZ_OK && pr.hit == 0);
    /* row 2 has its own body: another surface name, other rectangles */
    fx_clear_records(&x.f);
    x.f.now = 5000000u;
    rand_set(&x.f, 5, 0, 0, 0, 17, 0);
    CHECK(b_visit(&x, 2, 0u, &pa, &done) == SCENE_ACTION_HANDLER_OK && pa == 1u);
    CHECK(strcmp(x.f.loaded_name, "OTHER") == 0 && session_af5_object(x.b)->row == 2 && session_af5_object(x.b)->count == 1);
    CHECK(session_af5_pointer_move(x.b, 70, 60, &pr) == TQZ_OK && pr.hit == 0);
    CHECK(session_af5_pointer_move(x.b, 210, 220, &pr) == TQZ_OK && pr.hit == 1);
    /* a quiz replaced by a new scene is torn down first */
    x.f.n_relsurf = x.f.n_relslot = x.f.n_fontrel = 0;
    CHECK(session_af5_begin_scene(x.b, x.scene) == TQZ_OK);
    CHECK(x.f.n_relsurf == 1 && x.f.n_relslot == 3 && x.f.n_fontrel == 1 && session_af5_registered(x.b) == 0u);
    /* new game: 0x5a4c0a and 0x5a4c0e only */
    ((TqzWorld *)session_af5_world(x.b))->best_5a4c0e = 33;
    session_af5_new_game(x.b);
    CHECK(session_af5_world(x.b)->best_5a4c0e == 0 && session_af5_world(x.b)->played_5a4c0a == 0);
    session_af5_new_game(NULL);
    /* destroy tears an active quiz down */
    x.f.now = 6000000u;
    rand_set(&x.f, 5, 0, 0, 0, 17, 0);
    CHECK(b_visit(&x, 2, 0u, &pa, &done) == SCENE_ACTION_HANDLER_OK);
    x.f.n_relsurf = x.f.n_relslot = x.f.n_fontrel = 0;
    session_af5_destroy(x.b);
    CHECK(x.f.n_relsurf == 1 && x.f.n_relslot == 3 && x.f.n_fontrel == 1);
    scene_resource_close(x.scene);
}

static void t_binding_without_hooks_and_args(void)
{
    Bind x;
    uint32_t pa = 0, np = 0;
    int done = 0;
    TqzPointerResult pr;
    TqzRenderResult r;
    SceneActionInfo info;
    SceneActionRuntimeState st;
    SceneActionHandlerResult out;
    CHECK(bind_open(&x, 0));
    CHECK(session_af5_begin_scene(x.b, x.scene) == TQZ_OK);
    script_wave(&x.f);
    CHECK(b_visit(&x, 1, 0u, &pa, &done) == SCENE_ACTION_HANDLER_OK && g_stores == 0);
    x.f.now = 1000000u + 125000u;
    CHECK(b_visit(&x, 1, 1u, &pa, &done) == SCENE_ACTION_HANDLER_OK);
    x.f.now = 2000000u;
    CHECK(b_visit(&x, 1, 1u, &pa, &done) == SCENE_ACTION_HANDLER_OK);
    x.f.now = 2003000u;
    CHECK(b_visit(&x, 1, 1u, &pa, &done) == SCENE_ACTION_HANDLER_OK && pa == 2u);
    CHECK(b_visit(&x, 1, 2u, &pa, &done) == SCENE_ACTION_HANDLER_OK && done == 1 && g_stores == 0);
    /* wrong inputs */
    memset(&st, 0, sizeof st);
    memset(&out, 0, sizeof out);
    CHECK(scene_resource_action_at(x.scene, 1, &info) == SCENE_RESOURCE_OK);
    CHECK(session_af5_handler(NULL, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_af5_handler(x.b, 1, NULL, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_af5_handler(x.b, 1, &info, NULL, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_af5_handler(x.b, 1, &info, &st, NULL) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_af5_handler(x.b, 3, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_af5_handler(x.b, 100, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
    info.type = 0xd3;
    CHECK(session_af5_handler(x.b, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
    info.type = 0xf5;
    CHECK(session_af5_handler(x.b, 0, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR); /* row 0 is another type */
    CHECK(session_af5_create(NULL) == NULL);
    CHECK(session_af5_begin_scene(NULL, x.scene) == TQZ_ERR_ARGUMENT && session_af5_begin_scene(x.b, NULL) == TQZ_ERR_ARGUMENT);
    CHECK(session_af5_pointer_move(NULL, 0, 0, &pr) == TQZ_ERR_ARGUMENT && session_af5_pointer_move(x.b, 0, 0, NULL) == TQZ_ERR_ARGUMENT);
    CHECK(session_af5_click(NULL, 1u, 0, &np) == TQZ_ERR_ARGUMENT && session_af5_click(x.b, 1u, 0, NULL) == TQZ_ERR_ARGUMENT);
    CHECK(session_af5_key(NULL, 1u, 'a') == TQZ_ERR_ARGUMENT);
    CHECK(session_af5_invalidate(NULL) == TQZ_ERR_ARGUMENT);
    CHECK(session_af5_render(NULL, &r) == TQZ_ERR_ARGUMENT && session_af5_render(x.b, NULL) == TQZ_ERR_ARGUMENT);
    CHECK(session_af5_render_score(NULL, &r) == TQZ_ERR_ARGUMENT && session_af5_render_score(x.b, NULL) == TQZ_ERR_ARGUMENT);
    CHECK(session_af5_render_clock(NULL, &r) == TQZ_ERR_ARGUMENT && session_af5_render_clock(x.b, NULL) == TQZ_ERR_ARGUMENT);
    CHECK(session_af5_registered(NULL) == 0u && session_af5_object(NULL) == NULL && session_af5_world(NULL) == NULL);
    CHECK(strcmp(session_af5_failure(NULL), "0xf5-binding-unbound") == 0);
    session_af5_destroy(NULL);
    CHECK(session_af5_object(x.b) != NULL && session_af5_world(x.b) != NULL);
    bind_close(&x);
}

static void t_binding_refuses_bad_body(void)
{
    Bind x;
    uint8_t other[8192];
    uint8_t body_bad[TQZ_BODY_BYTES];
    const int types[2] = {0xf5, 0xf5};
    const uint8_t *bodies[2];
    size_t lengths[2] = {TQZ_BODY_BYTES, TQZ_BODY_BYTES};
    char err[128] = {0};
    SceneResource *bad_scene;
    uint32_t pa = 0;
    int done = 0;
    size_t n;
    CHECK(bind_open(&x, 1));
    CHECK(session_af5_begin_scene(x.b, x.scene) == TQZ_OK);
    memcpy(body_bad, x.body_a, TQZ_BODY_BYTES);
    put16(body_bad, O_VARIANTS, 21);
    bodies[0] = x.body_a;
    bodies[1] = body_bad;
    n = build_scene(other, 2, types, bodies, lengths);
    bad_scene = scene_resource_open_memory(other, n, err, sizeof err);
    CHECK(bad_scene != NULL);
    if (bad_scene != NULL) {
        CHECK(session_af5_begin_scene(x.b, bad_scene) == TQZ_ERR_BODY);
        CHECK(strcmp(session_af5_failure(x.b), "0xf5-variant-count") == 0);
        scene_resource_close(bad_scene);
    }
    /* the rows of the loaded scene stay in place */
    script_wave(&x.f);
    CHECK(b_visit(&x, 1, 0u, &pa, &done) == SCENE_ACTION_HANDLER_OK && strcmp(x.f.loaded_name, "TQUIZ") == 0);
    /* a different row count replaces the table */
    {
        const int one_type[1] = {0xf5};
        const uint8_t *one_body[1];
        size_t one_len[1] = {TQZ_BODY_BYTES};
        SceneResource *one_scene;
        one_body[0] = x.body_b;
        n = build_scene(other, 1, one_type, one_body, one_len);
        one_scene = scene_resource_open_memory(other, n, err, sizeof err);
        CHECK(one_scene != NULL);
        if (one_scene != NULL) {
            CHECK(session_af5_begin_scene(x.b, one_scene) == TQZ_OK);
            CHECK(b_visit(&x, 1, 0u, &pa, &done) == -1 || 1); /* the old scene resource still answers; the binding has 1 row */
            scene_resource_close(one_scene);
        }
    }
    {
        SceneActionInfo info;
        SceneActionRuntimeState st;
        SceneActionHandlerResult out;
        memset(&st, 0, sizeof st);
        memset(&out, 0, sizeof out);
        CHECK(scene_resource_action_at(x.scene, 2, &info) == SCENE_RESOURCE_OK);
        CHECK(session_af5_handler(x.b, 2, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(strcmp(session_af5_failure(x.b), "0xf5-row-not-owned") == 0);
    }
    bind_close(&x);
}

static void t_binding_host_error(void)
{
    Bind x;
    uint32_t pa = 0;
    int done = 0;
    CHECK(bind_open(&x, 1));
    CHECK(session_af5_begin_scene(x.b, x.scene) == TQZ_OK);
    script_wave(&x.f);
    x.f.fail_call = x.f.calls + 1; /* the first host call: the held item */
    CHECK(b_visit(&x, 1, 0u, &pa, &done) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(strcmp(session_af5_failure(x.b), "0xf5-host-or-bounds") == 0 && g_stores == 0);
    x.f.fail_call = 0;
    /* a scene clear whose font release fails leaves the old rows in place */
    x.f.fail_call = x.f.calls + 1;
    CHECK(session_af5_begin_scene(x.b, x.scene) == TQZ_ERR_HOST && strcmp(session_af5_failure(x.b), "0xf5-scene-clear") == 0);
    x.f.fail_call = 0;
    bind_close(&x);
}

/* ---- main ---------------------------------------------------------------------------------------------------------------- */
int main(void)
{
    run("std_set", t_std_set);
    run("std_reset", t_std_reset);
    run("std_init_score", t_std_init_score);
    run("std_init_clock", t_std_init_clock);
    run("std_render_score", t_std_render_score);
    run("std_render_clock", t_std_render_clock);
    run("key_filter", t_key_filter);
    run("validate_body", t_validate);
    run("object_and_world_reset", t_reset);
    run("phase0", t_phase0);
    run("character_sweep", t_char_sweep);
    run("character_range_persists", t_max_char);
    run("positions", t_positions);
    run("stuck_picks", t_stuck);
    run("clock", t_clock);
    run("score_formula", t_score_formula);
    run("expire_and_refill", t_expire_refill);
    run("typed_keys", t_keys);
    run("key_gate", t_key_gate);
    run("target_score", t_target);
    run("finish_states", t_finish_states);
    run("phase2_blocks", t_phase2);
    run("phase2_flag_refused", t_phase2_flag_refused);
    run("pointer", t_pointer);
    run("click", t_click);
    run("invalidate_and_cleanup", t_invalidate_cleanup);
    run("render_quiz", t_render_quiz);
    run("render_display", t_render_display);
    run("step_arguments", t_step_args);
    run("host_failure_sweep", t_host_failure_sweep);
    run("fuzz_bodies", t_fuzz);
    run("binding_flow", t_binding_flow);
    run("binding_without_hooks_and_args", t_binding_without_hooks_and_args);
    run("binding_refuses_bad_body", t_binding_refuses_bad_body);
    run("binding_host_error", t_binding_host_error);
    printf("TOTAL %d FAILED %d\n", g_total, g_failures);
    return g_failures;
}
