/* RT-59 unit tests of the raw 0xda Bul puzzle kernel (src/action_family_da_runtime.c) and the session binding
 * (src/session_bindings_ada.c). Prints "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure count.
 * Fixtures are synthetic bodies (no original bytes): every rectangle slot of the body holds {off, off + 1, off + 2, off + 3}
 * (its own offset), so a copy of a body rectangle is recognised by the offset it came from. Expected values are written out
 * from the layout in src/action_family_da_runtime.h and the disassembly facts quoted there, not by calling the kernel.
 * Build (host cc, plain and with ASan/UBSan), from outputs/blackmoor-decomp:
 *   cc -std=c11 -Wall -Wextra -Wpedantic -Werror -g [-fsanitize=address,undefined -fno-sanitize-recover=undefined] -Isrc \
 *      src/action_family_da_runtime.c src/session_bindings_ada.c src/scene_resource.c src/hiff.c \
 *      tests/action_family_da_runtime_test.c -o <out> */
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_da_runtime.h"
#include "scene_resource.h"
#include "session_bindings_ada.h"

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
    O_M = 0x21, O_N = 0x23, O_TWO = 0x27, O_SMART = 0x28, O_STARTP = 0x29, O_STARTC = 0x2b, O_ROLLA = 0x2d, O_ROLLB = 0x6d,
    O_POS = 0xad, O_PBARRACK = 0x19d, O_PJAIL = 0x1fd, O_CBARRACK = 0x25d, O_CJAIL = 0x2bd, O_BTN = 0x31d, O_PLIGHT = 0x34d,
    O_CLIGHT = 0x35d, O_WORK = 0x36d, O_MARK = 0x3ed, O_MARK2 = 0x40d, O_PIECE_PB = 0x42d, O_PIECE_CB = 0x43d, O_PIECE_CJ = 0x44d,
    O_PIECE_PJ = 0x45d, O_BTNDOWN = 0x46d, O_PLIGHT_ON = 0x49d, O_CLIGHT_ON = 0x4ad, O_PASS_OFF = 0x4bd, O_SSTEP = 0x4cd,
    O_SBTN = 0x4fe, O_CAP = 0x591, O_ENDED = 0xb49, O_LEFT = 0xb65, O_FINISH = 0xb7e
};
enum { CAP_STRIDE = 0x2dc, NAME_BYTES = 0x21, REC_BYTES = 0x31 };
enum { CH_STEP = 20, CH_BTN0 = 21, CH_BTN1 = 22, CH_BTN2 = 23, CH_CAP0 = 30, CH_CAP1 = 31 };
#define VIEW_X 7
#define VIEW_Y 11
#define SURFACE 77u
#define ROW 3
#define NOW 1000000u

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
static void set_nosound(uint8_t *b, size_t off) { memset(b + off, 0, NAME_BYTES); memcpy(b + off, "NO SOUND", 9u); }
static size_t cap_name(int entry, int i) { return O_CAP + (size_t)entry * CAP_STRIDE + 6u + (size_t)i * NAME_BYTES; }

/* The rectangle a body slot holds in the fixture, and the same shifted by the view origin. */
static BulRect RC(int off)
{
    BulRect r = {off, off + 1, off + 2, off + 3};
    return r;
}
static BulRect RCV(int off)
{
    BulRect r = {off + VIEW_X, off + 1 + VIEW_Y, off + 2 + VIEW_X, off + 3 + VIEW_Y};
    return r;
}
static int rect_eq(const BulRect *a, const BulRect *b)
{
    return a->left == b->left && a->top == b->top && a->right == b->right && a->bottom == b->bottom;
}
#define CHECK_RECT(r, expect)                                                                    \
    do {                                                                                         \
        const BulRect e_ = (expect);                                                             \
        if (!rect_eq(&(r), &e_) && !g_failed) {                                                  \
            g_failed = 1;                                                                        \
            snprintf(g_msg, sizeof g_msg, "line %d: %.60s = {%d,%d,%d,%d}, expected {%d,%d,%d,%d}", __LINE__, #r, \
                     (r).left, (r).top, (r).right, (r).bottom, e_.left, e_.top, e_.right, e_.bottom);   \
        }                                                                                        \
    } while (0)

static void put_block(uint8_t *b, size_t off, int scene, int w1, int w2, int w3, int32_t d1, int32_t d2, int32_t d3, int start,
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

/* M = 6 positions, N = 3 pieces, the player marker on 1 and the computer marker on 6, computer-controlled opponent. */
static void body_default(uint8_t *b)
{
    memset(b, 0, BUL_BODY_BYTES);
    set_str(b, 0, "BULSURF");
    put16(b, O_M, 6);
    put16(b, O_N, 3);
    put16(b, O_STARTP, 1);
    put16(b, O_STARTC, 6);
    for (size_t off = 0x2d; off + 16 <= 0x4cd; off += 16) put_rect(b, off, (int)off, (int)off + 1, (int)off + 2, (int)off + 3);
    put_rect(b, O_BTN, 100, 200, 140, 230);
    put_rect(b, O_BTN + 16, 200, 200, 260, 230);
    put_rect(b, O_BTN + 32, 300, 200, 340, 230);
    put_rect(b, O_FINISH, 400, 400, 440, 430);
    set_str(b, O_SSTEP, "STEP");
    put16(b, O_SSTEP + NAME_BYTES, CH_STEP);
    set_str(b, O_SBTN, "BTN0");
    put16(b, O_SBTN + NAME_BYTES, CH_BTN0);
    set_str(b, O_SBTN + REC_BYTES, "BTN1");
    put16(b, O_SBTN + REC_BYTES + NAME_BYTES, CH_BTN1);
    set_str(b, O_SBTN + 2 * REC_BYTES, "BTN2");
    put16(b, O_SBTN + 2 * REC_BYTES + NAME_BYTES, CH_BTN2);
    for (int e = 0; e < 2; ++e) {
        put16(b, O_CAP + (size_t)e * CAP_STRIDE, CH_CAP0 + e);
        put16(b, O_CAP + (size_t)e * CAP_STRIDE + 2, 70 + e);
        put16(b, O_CAP + (size_t)e * CAP_STRIDE + 4, 90 + e);
        for (int i = 0; i < 22; ++i) {
            char s[16];
            snprintf(s, sizeof s, "C%d_%d", e, i);
            set_str(b, cap_name(e, i), s);
        }
    }
    put_block(b, O_ENDED, 111, 1, 2, 3, 10, 20, 30, 1, 5, 0xaa);
    put16(b, O_ENDED + 25, 6);
    b[O_ENDED + 27] = 0xbb;
    put_block(b, O_LEFT, 222, 4, 5, 6, 40, 50, 60, 0, 7, 0xcc);
}

/* Failable host callbacks (the sweep fails the n-th call of any of them). */
enum {
    CB_ALLOC = 1, CB_REGISTER, CB_LOAD, CB_SETSURF, CB_RELSURF, CB_RELSLOT, CB_DIRTY, CB_VIEW, CB_CLEARITEM, CB_PREPARE, CB_STOP,
    CB_PLAY, CB_SHOW, CB_TRANSITION, CB_STOREFLAG, CB_ENGINEMODE, CB_LAST = CB_ENGINEMODE
};

typedef struct Fx {
    BulObject o;
    BulWorld w;
    BulHost host;
    uint8_t body[BUL_BODY_BYTES];
    char log[65536];
    uint32_t now, tick_step;
    int32_t rand_q[1024];
    int n_rand, i_rand;
    int32_t rand_default;
    int fail_call, calls;
    unsigned failed_mask;
    int n_alloc, n_dirty, n_relsurf, n_relslot, n_load, n_clear, n_engine, n_transition, n_show;
    int16_t dirty_slot, relslot_hist[8];
    int n_relslot_hist;
    uint32_t relsurf_handle, setsurf_surface;
    int16_t setsurf_slot, flag_limit;
    int prep_hist[32], n_prep, stop_hist[16], n_stop, play_hist[64], n_play, flag_hist[8][2], n_flag;
    struct { int16_t slot; int32_t type; int callback; uint32_t surface; char label[40]; } reg[8];
    int n_reg;
    char loaded_name[40];
    char prepared_caption[40];
    char shown[600];
    const char *text;
    char long_text[BUL_CAPTION_LIMIT + 16];
    BulTransition transition;
    int engine_mode;
    int32_t view_x, view_y;
    uint32_t busy_mask;
    uint32_t phase;
    BulResult result;
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
    static const char *const names[] = {"?", "start", "clearitem", "rowphase", "slot", "slotreg", "load", "slotsurf", "prep",
                                        "stop", "busy", "play", "tick", "rand", "captext", "capshow", "x57b", "x599", "x595",
                                        "x39ff", "x59b", "x59f", "x5a3", "mode", "evflag", "complete", "relsurf", "relslot",
                                        "dirty", "blit"};
    return e >= 0 && e <= 29 ? names[e] : "??";
}

static void observe(void *c, int e, int32_t a, int32_t b)
{
    Fx *f = (Fx *)c;
    if (f->observe_on) logf_(f, "%s:%d:%d", effect_name(e), a, b);
}

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
static int h_view(void *c, int32_t *x, int32_t *y)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_VIEW)) return 1;
    *x = f->view_x;
    *y = f->view_y;
    return 0;
}
static int h_clear(void *c)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_CLEARITEM)) return 1;
    ++f->n_clear;
    return 0;
}
static int body_offset(const Fx *f, const uint8_t *r)
{
    return (r >= f->body && r < f->body + BUL_BODY_BYTES) ? (int)(r - f->body) : -1;
}
static int h_prepare(void *c, const uint8_t *r)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_PREPARE)) return 1;
    if (f->n_prep < 32) f->prep_hist[f->n_prep++] = body_offset(f, r);
    if (body_offset(f, r) < 0) snprintf(f->prepared_caption, sizeof f->prepared_caption, "%s", (const char *)r);
    return 0;
}
static int h_stop(void *c, const uint8_t *r)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_STOP)) return 1;
    if (f->n_stop < 16) f->stop_hist[f->n_stop++] = body_offset(f, r);
    return 0;
}
static int h_busy(void *c, int16_t ch)
{
    Fx *f = (Fx *)c;
    return ch >= 0 && ch < 32 && ((f->busy_mask >> ch) & 1u) != 0u;
}
static int h_play(void *c, int16_t ch)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_PLAY)) return 1;
    if (f->n_play < 64) f->play_hist[f->n_play++] = ch;
    return 0;
}
static const char *h_text(void *c, const char *name)
{
    Fx *f = (Fx *)c;
    (void)name;
    return f->text;
}
static int h_show(void *c, const char *text)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_SHOW)) return 1;
    ++f->n_show;
    snprintf(f->shown, sizeof f->shown, "%s", text);
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
static int h_transition(void *c, const BulTransition *t)
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
    f->host.view_origin = h_view;
    f->host.clear_pending_item = h_clear;
    f->host.sound_prepare = h_prepare;
    f->host.sound_stop = h_stop;
    f->host.sound_busy = h_busy;
    f->host.sound_play = h_play;
    f->host.caption_text = h_text;
    f->host.caption_show = h_show;
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
    bul_object_reset(&f->o);
    body_default(f->body);
    fx_host(f);
    f->flag_limit = 4096;
    f->now = NOW;
    f->view_x = VIEW_X;
    f->view_y = VIEW_Y;
    f->text = "Hello";
    f->observe_on = 1;
}

static void fx_clear_records(Fx *f)
{
    f->log[0] = '\0';
    f->n_play = f->n_prep = f->n_stop = f->n_flag = f->n_reg = f->n_relslot_hist = 0;
    f->n_alloc = f->n_show = 0;
    f->shown[0] = '\0';
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

static int step(Fx *f, uint32_t phase)
{
    const int rc = bul_step(&f->o, f->body, BUL_BODY_BYTES, ROW, phase, &f->w, &f->host, &f->result, &f->failure);
    if (rc == BUL_OK) f->phase = f->result.phase_after;
    return rc;
}

/* Phase 0, then an idle active object (state 0) with the records cleared. */
static void start_game(Fx *f)
{
    CHECK_INT(step(f, 0), BUL_OK);
    f->o.state = BUL_STATE_IDLE;
    f->o.next_state = 0;
    fx_clear_records(f);
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

/* The explicit button rectangles of the fixture, and the same shifted by the view origin. */
static BulRect RB(int k)
{
    static const BulRect r[3] = {{100, 200, 140, 230}, {200, 200, 260, 230}, {300, 200, 340, 230}};
    return r[k];
}
static BulRect RBV(int k)
{
    BulRect r = RB(k);
    r.left += VIEW_X;
    r.right += VIEW_X;
    r.top += VIEW_Y;
    r.bottom += VIEW_Y;
    return r;
}

#define SHOWN_LEN 8 /* "Hello" + "<e>" */

/* ---- body validation and object reset ------------------------------------------------------------------------------------- */

static void t_validate(void)
{
    Fx f;
    const char *why = "x";
    fx_init(&f);
    CHECK(bul_validate_body(f.body, BUL_BODY_BYTES, &why) == BUL_OK && why == NULL);
    CHECK(bul_validate_body(f.body, BUL_BODY_BYTES, NULL) == BUL_OK);
    CHECK(bul_validate_body(NULL, BUL_BODY_BYTES, &why) == BUL_ERR_BODY && strcmp(why, "0xda-body-length") == 0);
    CHECK(bul_validate_body(f.body, BUL_BODY_BYTES - 1u, &why) == BUL_ERR_BODY && strcmp(why, "0xda-body-length") == 0);
    CHECK(bul_validate_body(f.body, BUL_BODY_BYTES + 1u, &why) == BUL_ERR_BODY);
    {
        uint8_t b[BUL_BODY_BYTES];
        memcpy(b, f.body, sizeof b);
        memset(b, 'A', NAME_BYTES);
        CHECK(bul_validate_body(b, sizeof b, &why) == BUL_ERR_BODY && strcmp(why, "0xda-name-unterminated") == 0);
        b[NAME_BYTES - 1] = 0;
        CHECK(bul_validate_body(b, sizeof b, &why) == BUL_OK);
    }
    {
        /* every sound record and caption name needs a NUL inside its 0x21 bytes */
        const size_t offs[] = {O_SSTEP, O_SBTN, O_SBTN + REC_BYTES, O_SBTN + 2 * REC_BYTES, cap_name(0, 0), cap_name(0, 21),
                               cap_name(1, 0), cap_name(1, 21), cap_name(1, 10)};
        for (size_t i = 0; i < sizeof offs / sizeof offs[0]; ++i) {
            uint8_t b[BUL_BODY_BYTES];
            memcpy(b, f.body, sizeof b);
            memset(b + offs[i], 'A', NAME_BYTES);
            CHECK(bul_validate_body(b, sizeof b, &why) == BUL_ERR_BODY && strcmp(why, "0xda-sound-unterminated") == 0);
        }
    }
    {
        const int ms[] = {0, 16, -1}, ns[] = {0, 7, -1};
        for (int i = 0; i < 3; ++i) {
            uint8_t b[BUL_BODY_BYTES];
            memcpy(b, f.body, sizeof b);
            put16(b, O_M, ms[i]);
            CHECK(bul_validate_body(b, sizeof b, &why) == BUL_ERR_BODY && strcmp(why, "0xda-position-count") == 0);
            memcpy(b, f.body, sizeof b);
            put16(b, O_N, ns[i]);
            CHECK(bul_validate_body(b, sizeof b, &why) == BUL_ERR_BODY && strcmp(why, "0xda-piece-count") == 0);
        }
    }
    {
        uint8_t b[BUL_BODY_BYTES];
        memcpy(b, f.body, sizeof b);
        put16(b, O_M, 15);
        put16(b, O_N, 6);
        put16(b, O_STARTP, 15);
        put16(b, O_STARTC, 1);
        CHECK(bul_validate_body(b, sizeof b, &why) == BUL_OK);
        put16(b, O_STARTP, 16);
        CHECK(bul_validate_body(b, sizeof b, &why) == BUL_ERR_BODY && strcmp(why, "0xda-start-position") == 0);
        put16(b, O_STARTP, 0);
        CHECK(bul_validate_body(b, sizeof b, &why) == BUL_ERR_BODY);
        put16(b, O_STARTP, 1);
        put16(b, O_STARTC, 0);
        CHECK(bul_validate_body(b, sizeof b, &why) == BUL_ERR_BODY);
        put16(b, O_STARTC, 16);
        CHECK(bul_validate_body(b, sizeof b, &why) == BUL_ERR_BODY);
    }
}

static void t_reset(void)
{
    Fx f;
    BulObject o;
    fx_init(&f);
    memset(&o, 0xff, sizeof o);
    bul_object_reset(&o);
    CHECK(o.slot == -1 && o.row == -1 && o.surface == 0 && o.active == 0 && o.state == 0 && o.won == 0 && o.finish_kind == 0 &&
          o.anim_active == 0 && o.mode == 0 && o.sound_name[0] == 0);
    /* cleanup of an idle object issues no host call (nothing to release) */
    CHECK(bul_cleanup(&o, &f.host) == BUL_OK && f.log[0] == '\0' && f.n_relsurf == 0 && f.n_relslot == 0);
    o.surface = 55;
    o.slot = 9;
    o.row = 4;
    o.active = 1;
    o.won = 1;
    o.finish_kind = 1;
    o.state = 7;
    CHECK(bul_cleanup(&o, &f.host) == BUL_OK);
    CHECK_LOG(&f, "relsurf:55:0,relslot:9:0");
    CHECK(f.relsurf_handle == 55u && o.surface == 0 && o.slot == -1 && o.row == -1 && o.active == 0 && o.won == 0 &&
          o.finish_kind == 0);
    CHECK(o.state == 7); /* 0x45b3ea does not touch the state */
    CHECK(bul_cleanup(NULL, &f.host) == BUL_ERR_ARGUMENT && bul_cleanup(&o, NULL) == BUL_ERR_ARGUMENT);
    /* surface only / slot only */
    fx_clear_records(&f);
    o.surface = 6;
    CHECK(bul_cleanup(&o, &f.host) == BUL_OK);
    CHECK_LOG(&f, "relsurf:6:0");
    fx_clear_records(&f);
    o.slot = 2;
    CHECK(bul_cleanup(&o, &f.host) == BUL_OK);
    CHECK_LOG(&f, "relslot:2:0");
    /* host failures */
    o.surface = 6;
    o.slot = 2;
    f.calls = 0;
    f.fail_call = 1;
    CHECK(bul_cleanup(&o, &f.host) == BUL_ERR_HOST);
    f.calls = 0;
    f.fail_call = 2;
    o.surface = 6;
    o.slot = 2;
    CHECK(bul_cleanup(&o, &f.host) == BUL_ERR_HOST && o.surface == 0 && o.slot == 2);
}

/* ---- phase 0 -------------------------------------------------------------------------------------------------------------- */

static void t_phase0(void)
{
    Fx f;
    BulObject *o;
    fx_init(&f);
    CHECK_INT(step(&f, 0), BUL_OK);
    o = &f.o;
    CHECK_LOG(&f, "start:1:0,clearitem:0:0,rowphase:1:0,slot:24:0,slotreg:24:0,load:77:0,slotsurf:24:77,prep:1229:0,prep:1278:0,"
                  "prep:1327:0,prep:1376:0,prep:-1:0,play:31:0,captext:1:0,capshow:8:0");
    CHECK(f.result.initialized == 1 && f.result.completed == 0 && f.result.phase_after == 1u && f.phase == 1u);
    CHECK(o->row == ROW && o->active == 1 && o->slot == 0x18 && o->surface == SURFACE && o->state == BUL_STATE_CAPTION_WAIT);
    CHECK(o->next_state == 0 && o->mode == 0 && o->score_player == 0 && o->score_computer == 0 && o->won == 0 &&
          o->finish_kind == 0);
    CHECK(o->pos_player == 1 && o->pos_computer == 6);
    CHECK_RECT(o->cur_player, RC(O_POS));
    CHECK_RECT(o->cur_computer, RC(O_POS + 5 * 16));
    CHECK_RECT(o->image_player, RC(O_MARK));
    CHECK_RECT(o->image_computer, RC(O_MARK + 16));
    for (int i = 0; i < 4; ++i) {
        CHECK_RECT(o->roll_a[i], RC(O_WORK + i * 0x20));
        CHECK_RECT(o->roll_b[i], RC(O_WORK + i * 0x20));
    }
    /* the "clearing out" rectangles: right / bottom replaced by those of the last jail slot */
    {
        const BulRect c0 = {0x1fd, 0x1fe, 0x24f, 0x250}, c1 = {0x2bd, 0x2be, 0x30f, 0x310};
        CHECK_RECT(o->clear[0], c0);
        CHECK_RECT(o->clear[1], c1);
    }
    CHECK(o->moving.right == 0 && o->erase.right == 0 && o->light == 1);
    CHECK(o->anim_active == 0 && o->button_kind == 0 && o->anim_deadline == 0 && o->button_down == 0);
    CHECK(f.w.start_flag_5bb1ca == 1 && f.n_alloc == 1 && f.n_load == 1 && strcmp(f.loaded_name, "BULSURF") == 0 && f.n_clear == 1);
    CHECK(f.n_reg == 1 && f.reg[0].slot == 0x18 && f.reg[0].type == 10 && f.reg[0].callback == BUL_CALLBACK_PUZZLE &&
          f.reg[0].surface == 0u && strcmp(f.reg[0].label, "BUL PUZZLE OVERLAYS") == 0);
    CHECK(f.setsurf_slot == 0x18 && f.setsurf_surface == SURFACE);
    CHECK(f.n_prep == 5 && f.prep_hist[0] == O_SSTEP && f.prep_hist[1] == O_SBTN && f.prep_hist[2] == O_SBTN + REC_BYTES &&
          f.prep_hist[3] == O_SBTN + 2 * REC_BYTES && f.prep_hist[4] == -1 && strcmp(f.prepared_caption, "C1_0") == 0);
    CHECK(f.n_play == 1 && f.play_hist[0] == CH_CAP1 && f.n_show == 1 && strcmp(f.shown, "Hello<e>") == 0);
    /* the caption descriptor of entry 1 */
    CHECK(o->cap_channel == CH_CAP1 && o->cap_1a7 == 2 && o->cap_1a9 == 1 && o->cap_1ab == 1 && o->cap_1ad == 1 &&
          o->cap_1b1 == 71 && o->cap_1b3 == 91);
    CHECK(strcmp((const char *)o->sound_name, "C1_0") == 0);
    /* the light flag is 0 when the light rectangle has no width */
    fx_init(&f);
    put_rect(f.body, O_PLIGHT, 5, 6, 5, 8);
    CHECK_INT(step(&f, 0), BUL_OK);
    CHECK(f.o.light == 0);
}

static void t_phase0_variants(void)
{
    Fx f;
    /* the surface of an earlier game is kept; NO SOUND records are not prepared; NO SOUND greeting is silent */
    fx_init(&f);
    f.o.surface = 88;
    set_nosound(f.body, O_SSTEP);
    set_nosound(f.body, O_SBTN + REC_BYTES);
    set_nosound(f.body, cap_name(1, 0));
    CHECK_INT(step(&f, 0), BUL_OK);
    CHECK_LOG(&f, "start:1:0,clearitem:0:0,rowphase:1:0,slot:24:0,slotreg:24:0,slotsurf:24:88,prep:1278:0,prep:1376:0");
    CHECK(f.n_load == 0 && f.o.surface == 88u && f.setsurf_surface == 88u && f.o.state == BUL_STATE_IDLE && f.n_show == 0);
    CHECK(f.o.cap_channel == CH_CAP1 && f.o.cap_1b1 == 71);
    /* an empty greeting name is not real either */
    fx_init(&f);
    f.body[cap_name(1, 0)] = 0;
    CHECK_INT(step(&f, 0), BUL_OK);
    CHECK(f.n_play == 0 && f.o.state == BUL_STATE_IDLE);
    /* stale fields of an earlier game survive until phase 0 rewrites them */
    fx_init(&f);
    f.o.next_state = 9;
    f.o.mode = 3;
    f.o.score_player = 2;
    f.o.moving = RC(1);
    f.o.erase = RC(1);
    CHECK_INT(step(&f, 0), BUL_OK);
    CHECK(f.o.next_state == 0 && f.o.mode == 0 && f.o.score_player == 0 && f.o.moving.right == 0 && f.o.erase.right == 0);
    /* a slot allocated below zero is refused natively */
    fx_init(&f);
    f.n_alloc = -0x19;
    CHECK(step(&f, 0) == BUL_ERR_HOST && strcmp(f.failure, "0xda-slot") == 0 && f.o.slot == -1);
}

/* ---- the caption picker (through the finish-rectangle click) -------------------------------------------------------------- */

static void click_setup(Fx *f)
{
    start_game(f);
    f->now = 5000;
}

static void t_caption_pick(void)
{
    Fx f;
    BulClickResult r;
    /* found at once: one draw, idx 2 */
    fx_init(&f);
    click_setup(&f);
    rand_set(&f, 1, 2);
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_FINISH, &r) == BUL_OK);
    CHECK_LOG(&f, "rand:2:0,prep:-1:0,play:30:0,captext:1:0,capshow:8:0,tick:5000:0");
    CHECK(r.handled == 1 && r.new_phase == 1u && f.o.state == BUL_STATE_CAPTION_WAIT && f.o.next_state == BUL_STATE_EXIT_DELAY &&
          f.o.deadline_16e == 5800u);
    CHECK(strcmp((const char *)f.o.sound_name, "C0_20") == 0); /* names 0x7e9 = index 18 of entry 0, plus the draw 2 */
    CHECK(f.o.cap_channel == CH_CAP0 && f.o.cap_1b1 == 70 && f.o.cap_1b3 == 90);
    /* the first draw hits a NO SOUND name, the second a real one */
    fx_init(&f);
    click_setup(&f);
    set_nosound(f.body, cap_name(0, 19));
    rand_set(&f, 2, 1, 3);
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_FINISH, &r) == BUL_OK);
    CHECK_LOG(&f, "rand:1:0,rand:3:0,prep:-1:0,play:30:0,captext:1:0,capshow:8:0,tick:5000:0");
    CHECK(strcmp((const char *)f.o.sound_name, "C0_21") == 0);
    /* an empty name counts as not real */
    fx_init(&f);
    click_setup(&f);
    f.body[cap_name(0, 18)] = 0;
    rand_set(&f, 2, 0, 3);
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_FINISH, &r) == BUL_OK);
    CHECK(strcmp((const char *)f.o.sound_name, "C0_21") == 0);
    /* every name NO SOUND: the pick ends once all four indexes were drawn, the click ends the game (phase 2) */
    fx_init(&f);
    click_setup(&f);
    for (int i = 18; i < 22; ++i) set_nosound(f.body, cap_name(0, i));
    rand_set(&f, 5, 0, 1, 1, 2, 3);
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_FINISH, &r) == BUL_OK);
    CHECK_LOG(&f, "rand:0:0,rand:1:0,rand:1:0,rand:2:0,rand:3:0,rowphase:2:0");
    CHECK(r.handled == 1 && r.new_phase == 2u && f.o.state == BUL_STATE_IDLE && f.n_play == 0);
    CHECK(f.o.cap_channel == CH_CAP0 && f.o.cap_1a7 == 2); /* the descriptor is written even when nothing is found */
    /* a draw that never covers all indexes ends with BUL_ERR_STUCK */
    fx_init(&f);
    click_setup(&f);
    for (int i = 18; i < 22; ++i) set_nosound(f.body, cap_name(0, i));
    f.rand_default = 0;
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_FINISH, &r) == BUL_ERR_STUCK);
    /* a random draw outside 0..32767 is a host failure */
    fx_init(&f);
    click_setup(&f);
    rand_set(&f, 1, 32768);
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_FINISH, &r) == BUL_ERR_HOST);
    fx_init(&f);
    click_setup(&f);
    rand_set(&f, 1, -1);
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_FINISH, &r) == BUL_ERR_HOST);
}

static void t_caption_text(void)
{
    Fx f;
    BulClickResult r;
    /* no caption text: the sound plays, nothing is shown, the state is still 10 */
    fx_init(&f);
    click_setup(&f);
    f.text = NULL;
    rand_set(&f, 1, 0);
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_FINISH, &r) == BUL_OK);
    CHECK_LOG(&f, "rand:0:0,prep:-1:0,play:30:0,captext:0:0,tick:5000:0");
    CHECK(f.n_show == 0 && f.o.state == BUL_STATE_CAPTION_WAIT);
    /* a text of 200 bytes is the longest the native buffer takes */
    fx_init(&f);
    click_setup(&f);
    memset(f.long_text, 'x', 200);
    f.long_text[200] = 0;
    f.text = f.long_text;
    rand_set(&f, 1, 0);
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_FINISH, &r) == BUL_OK);
    CHECK(f.n_show == 1 && strlen(f.shown) == 203u && strcmp(f.shown + 200, "<e>") == 0);
    /* 201..0x9c40 bytes: the original smashes its stack buffer, the kernel refuses after 0x423259 was called */
    fx_init(&f);
    click_setup(&f);
    memset(f.long_text, 'x', 201);
    f.long_text[201] = 0;
    f.text = f.long_text;
    rand_set(&f, 1, 0);
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_FINISH, &r) == BUL_ERR_BOUNDS);
    CHECK(f.n_show == 0);
    /* above 0x9c40 bytes the original skips the display */
    fx_init(&f);
    click_setup(&f);
    memset(f.long_text, 'x', BUL_CAPTION_LIMIT + 1u);
    f.long_text[BUL_CAPTION_LIMIT + 1u] = 0;
    f.text = f.long_text;
    rand_set(&f, 1, 0);
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_FINISH, &r) == BUL_OK);
    CHECK(f.n_show == 0 && f.o.state == BUL_STATE_CAPTION_WAIT);
    /* exactly 0x9c40 bytes is still above the native limit */
    fx_init(&f);
    click_setup(&f);
    memset(f.long_text, 'x', BUL_CAPTION_LIMIT);
    f.long_text[BUL_CAPTION_LIMIT] = 0;
    f.text = f.long_text;
    rand_set(&f, 1, 0);
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_FINISH, &r) == BUL_ERR_BOUNDS);
    /* the empty text is shown as the suffix alone */
    fx_init(&f);
    click_setup(&f);
    f.text = "";
    rand_set(&f, 1, 0);
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_FINISH, &r) == BUL_OK);
    CHECK(strcmp(f.shown, "<e>") == 0);
    /* a failing display is a host failure */
    fx_init(&f);
    click_setup(&f);
    rand_set(&f, 1, 0);
    f.calls = 0;
    f.fail_call = 3; /* prepare, play, show */
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_FINISH, &r) == BUL_ERR_HOST);
}

/* ---- pointer and click ---------------------------------------------------------------------------------------------------- */

static void t_pointer(void)
{
    Fx f;
    BulPointerResult p;
    fx_init(&f);
    start_game(&f);
    /* button 0: 5 above / below the rectangle, inclusive */
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 120, 215, &p) == BUL_OK && p.hit == 1 && p.candidate == 0x27ba &&
          p.cursor_kind == 0x16 && p.cursor_sub == 1 && p.cursor_cell == 0x5b18dcu && p.cursor_link == 1 && p.button == 0 &&
          f.o.pending_button == 0);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 100, 195, &p) == BUL_OK && p.hit == 1);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 140, 235, &p) == BUL_OK && p.hit == 1);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 100, 194, &p) == BUL_OK && p.hit == 0 && p.candidate == -1 &&
          p.cursor_kind == 0 && p.cursor_sub == 0 && p.cursor_link == 0 && p.button == -1);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 140, 236, &p) == BUL_OK && p.hit == 0);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 99, 215, &p) == BUL_OK && p.hit == 0);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 141, 215, &p) == BUL_OK && p.hit == 0);
    /* 16-bit truncation of the arguments */
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 0x10000 + 120, 0x20000 + 215, &p) == BUL_OK && p.hit == 1);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, -65536 + 120, 215, &p) == BUL_OK && p.hit == 1);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 120, -1, &p) == BUL_OK && p.hit == 0);
    /* button 1 (pass) answers in modes 1 and 3 only, narrowed by 10 horizontally, moved down by 5 */
    f.o.mode = 0;
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 230, 215, &p) == BUL_OK && p.hit == 0);
    f.o.mode = 1;
    f.o.pending_button = 0;
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 230, 215, &p) == BUL_OK && p.hit == 1 && p.button == 1 &&
          f.o.pending_button == 1);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 210, 205, &p) == BUL_OK && p.hit == 1);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 250, 235, &p) == BUL_OK && p.hit == 1);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 209, 215, &p) == BUL_OK && p.hit == 0);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 251, 215, &p) == BUL_OK && p.hit == 0);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 230, 204, &p) == BUL_OK && p.hit == 0);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 230, 236, &p) == BUL_OK && p.hit == 0);
    f.o.mode = 3;
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 230, 215, &p) == BUL_OK && p.hit == 0); /* the computer's turn */
    f.body[O_TWO] = 1;
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 230, 215, &p) == BUL_OK && p.hit == 1 && p.button == 1);
    f.body[O_TWO] = 0;
    f.o.mode = 1;
    /* button 2 */
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 300, 200, &p) == BUL_OK && p.hit == 1 && p.button == 2 &&
          f.o.pending_button == 2);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 340, 230, &p) == BUL_OK && p.hit == 1);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 341, 230, &p) == BUL_OK && p.hit == 0);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 320, 199, &p) == BUL_OK && p.hit == 0);
    /* the finish rectangle: no button store, cursor 9 */
    f.o.pending_button = 1;
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 420, 410, &p) == BUL_OK && p.hit == 1 && p.candidate == 0x27bb &&
          p.cursor_kind == 9 && p.cursor_sub == 1 && p.cursor_cell == 0x5b173cu && p.cursor_link == 1 && p.button == -1 &&
          f.o.pending_button == 1);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 400, 400, &p) == BUL_OK && p.hit == 1);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 440, 430, &p) == BUL_OK && p.hit == 1);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 441, 430, &p) == BUL_OK && p.hit == 0);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 440, 399, &p) == BUL_OK && p.hit == 0);
    /* gates: the computer's turn (no second player, mode >= 2), the button animation, an inactive object */
    f.o.mode = 2;
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 120, 215, &p) == BUL_OK && p.hit == 0);
    f.body[O_TWO] = 1;
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 120, 215, &p) == BUL_OK && p.hit == 1);
    f.o.anim_active = 1;
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 120, 215, &p) == BUL_OK && p.hit == 0 && p.candidate == -1);
    f.o.anim_active = 0;
    f.o.active = 0;
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 120, 215, &p) == BUL_OK && p.hit == 0);
    f.o.active = 1;
    /* a button wins over the finish rectangle when both are hit */
    put_rect(f.body, O_FINISH, 100, 200, 140, 230);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 120, 215, &p) == BUL_OK && p.candidate == 0x27ba);
    /* arguments */
    CHECK(bul_pointer(NULL, f.body, BUL_BODY_BYTES, 0, 0, &p) == BUL_ERR_ARGUMENT);
    CHECK(bul_pointer(&f.o, NULL, BUL_BODY_BYTES, 0, 0, &p) == BUL_ERR_ARGUMENT);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES - 1u, 0, 0, &p) == BUL_ERR_ARGUMENT);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 0, 0, NULL) == BUL_ERR_ARGUMENT);
}

static void t_click(void)
{
    Fx f;
    BulClickResult r;
    fx_init(&f);
    click_setup(&f);
    /* gates: inactive, won, state != 0, row phase != 1: nothing happens */
    f.o.active = 0;
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_BUTTON, &r) == BUL_OK && r.handled == 0 &&
          r.new_phase == 1u && f.log[0] == '\0');
    f.o.active = 1;
    f.o.won = 1;
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_BUTTON, &r) == BUL_OK && r.handled == 0);
    f.o.won = 0;
    f.o.state = BUL_STATE_MOVING;
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_BUTTON, &r) == BUL_OK && r.handled == 0);
    f.o.state = 0;
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 0u, BUL_CANDIDATE_BUTTON, &r) == BUL_OK && r.handled == 0 &&
          r.new_phase == 0u);
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 2u, BUL_CANDIDATE_BUTTON, &r) == BUL_OK && r.handled == 0 &&
          r.new_phase == 2u);
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, 5, &r) == BUL_OK && r.handled == 0 && f.log[0] == '\0');
    CHECK(f.log[0] == '\0' && f.o.anim_active == 0);
    /* a button click: the animation starts, the button sound plays when the channel is idle */
    f.o.pending_button = 1;
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_BUTTON, &r) == BUL_OK && r.handled == 1 &&
          r.new_phase == 1u);
    CHECK_LOG(&f, "tick:5000:0,busy:22:0,play:22:0");
    CHECK(f.o.anim_active == 1 && f.o.button_kind == 1 && f.o.anim_deadline == 5250u && f.o.button_down == 1);
    /* a busy channel: queried, not played */
    fx_clear_records(&f);
    f.busy_mask = 1u << CH_BTN2;
    f.o.pending_button = 2;
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_BUTTON, &r) == BUL_OK);
    CHECK_LOG(&f, "tick:5000:0,busy:23:1");
    CHECK(f.o.button_kind == 2 && f.n_play == 0);
    /* no sound without the start flag, none for a NO SOUND record */
    fx_clear_records(&f);
    f.w.start_flag_5bb1ca = 0;
    f.o.pending_button = 0;
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_BUTTON, &r) == BUL_OK);
    CHECK_LOG(&f, "tick:5000:0");
    CHECK(f.w.start_flag_5bb1ca == 0); /* the click only reads the cell */
    fx_clear_records(&f);
    f.w.start_flag_5bb1ca = 1;
    set_nosound(f.body, O_SBTN);
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_BUTTON, &r) == BUL_OK);
    CHECK_LOG(&f, "tick:5000:0");
    /* a pending button outside 0..2 is refused before any effect */
    fx_clear_records(&f);
    f.o.anim_active = 0;
    f.o.pending_button = 3;
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_BUTTON, &r) == BUL_ERR_UNSUPPORTED &&
          r.handled == 0 && f.log[0] == '\0' && f.o.anim_active == 0);
    f.o.pending_button = -1;
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, BUL_CANDIDATE_BUTTON, &r) == BUL_ERR_UNSUPPORTED);
    /* arguments */
    CHECK(bul_click(NULL, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, 0, &r) == BUL_ERR_ARGUMENT);
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, NULL, &f.host, 1u, 0, &r) == BUL_ERR_ARGUMENT);
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, 0, NULL) == BUL_ERR_ARGUMENT);
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES - 1u, &f.w, &f.host, 1u, 0, &r) == BUL_ERR_ARGUMENT);
    {
        BulHost bad = f.host;
        bad.caption_show = NULL;
        CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &bad, 1u, 0, &r) == BUL_ERR_ARGUMENT);
    }
}

/* ---- the phase-1 state machine -------------------------------------------------------------------------------------------- */

static void t_idle(void)
{
    Fx f;
    fx_init(&f);
    start_game(&f);
    f.now = 5000;
    /* the player's turn waits for a click; nothing runs */
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.log[0] == '\0' && f.o.anim_active == 0);
    /* a second player waits for a click on mode >= 2 as well */
    f.body[O_TWO] = 1;
    f.o.mode = 2;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.log[0] == '\0' && f.o.anim_active == 0);
    /* the computer rolls (mode 2): button 0 animation, sound */
    f.body[O_TWO] = 0;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:5000:0,busy:21:0,play:21:0");
    CHECK(f.o.anim_active == 1 && f.o.anim_deadline == 5300u && f.o.button_down == 1 && f.o.button_kind == 0);
    /* a visit before the deadline and one on it only read the clock */
    fx_clear_records(&f);
    f.now = 5300;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:5300:0");
    CHECK(f.o.state == BUL_STATE_IDLE && f.o.button_down == 1);
    /* the deadline passed: state 2, down flag cleared, deadline 1000 ms for the computer, tick read twice */
    fx_clear_records(&f);
    f.now = 5301;
    f.tick_step = 10;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:5301:0,tick:5311:0");
    CHECK(f.o.state == BUL_STATE_PICK_MOVES && f.o.button_down == 0 && f.o.deadline_16e == 6311u && f.o.anim_active == 1);
    /* the same for the player: 800 ms */
    f.o.state = 0;
    f.o.mode = 0;
    f.o.anim_active = 1;
    f.o.anim_deadline = 100;
    f.o.button_kind = 0;
    f.o.button_down = 1;
    f.now = 5000;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.state == BUL_STATE_PICK_MOVES && f.o.deadline_16e == 5010u + 800u);
    /* a second player in mode 2 is a player: 800 ms */
    f.o.state = 0;
    f.o.mode = 2;
    f.body[O_TWO] = 1;
    f.o.anim_active = 1;
    f.o.button_kind = 0;
    f.now = 5000;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.deadline_16e == 5010u + 800u);
    f.body[O_TWO] = 0;
    f.tick_step = 0;
    /* smart computer on mode 3: passes when it is far behind in the track, else rolls; no draw */
    {
        const int cases[][4] = {{1, 7, 8, 1}, {1, 6, 8, 0}, {5, 4, 8, 1}, {5, 2, 8, 0}, {7, 1, 8, 0}, {1, 12, 15, 1}, {1, 6, 6, 0}};
        for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
            uint8_t body[BUL_BODY_BYTES];
            memcpy(body, f.body, sizeof body);
            put16(body, O_M, cases[i][2]);
            body[O_SMART] = 1;
            f.o.state = 0;
            f.o.mode = 3;
            f.o.anim_active = 0;
            f.o.pos_player = (int16_t)cases[i][0];
            f.o.pos_computer = (int16_t)cases[i][1];
            fx_clear_records(&f);
            CHECK(bul_step(&f.o, body, BUL_BODY_BYTES, ROW, 1, &f.w, &f.host, &f.result, &f.failure) == BUL_OK);
            CHECK(f.o.anim_active == 1 && f.o.button_kind == cases[i][3]);
            CHECK(strstr(f.log, "rand") == NULL);
            if (cases[i][3] == 1) CHECK(strstr(f.log, "play") == NULL);
        }
    }
    /* without the smart flag the computer on mode 3 flips a coin */
    f.now = 5000;
    f.o.state = 0;
    f.o.mode = 3;
    f.o.anim_active = 0;
    f.o.pos_player = 1;
    f.o.pos_computer = 6;
    rand_set(&f, 1, 3);
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "rand:3:0,tick:5000:0");
    CHECK(f.o.button_kind == 1);
    f.o.anim_active = 0;
    rand_set(&f, 1, 4);
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "rand:4:0,tick:5000:0,busy:21:0,play:21:0");
    CHECK(f.o.button_kind == 0);
    /* no sound without the start flag / with a NO SOUND record / with a busy channel */
    f.o.anim_active = 0;
    f.w.start_flag_5bb1ca = 0;
    f.o.mode = 2;
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:5000:0");
    f.o.anim_active = 0;
    f.w.start_flag_5bb1ca = 1;
    f.busy_mask = 1u << CH_BTN0;
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:5000:0,busy:21:1");
    f.o.anim_active = 0;
    set_nosound(f.body, O_SBTN);
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:5000:0");
}

static void t_idle_button_end(void)
{
    Fx f;
    fx_init(&f);
    start_game(&f);
    f.now = 5000;
    /* pass (kind 1) in mode 1: mode 2, caption of entry 0 name 1, next state 1; the caption set state 10 */
    f.o.anim_active = 1;
    f.o.anim_deadline = 1;
    f.o.button_kind = 1;
    f.o.button_down = 1;
    f.o.mode = 1;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:5000:0,prep:-1:0,play:30:0,captext:1:0,capshow:8:0");
    CHECK(f.o.mode == 2 && f.o.state == BUL_STATE_CAPTION_WAIT && f.o.next_state == 1 && f.o.button_down == 0);
    CHECK(strcmp((const char *)f.o.sound_name, "C0_1") == 0);
    /* the same without a real caption name: state 1 stays */
    f.o.state = 0;
    f.o.anim_active = 1;
    f.o.button_kind = 1;
    f.o.mode = 1;
    f.o.next_state = 7;
    set_nosound(f.body, cap_name(0, 1));
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.mode == 2 && f.o.state == BUL_STATE_CAPTION_PICK && f.o.next_state == 1 && f.n_play == 0);
    /* pass in mode 3: mode 0, caption of entry 1 name 1 */
    f.o.state = 0;
    f.o.anim_active = 1;
    f.o.button_kind = 1;
    f.o.mode = 3;
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:5000:0,prep:-1:0,play:31:0,captext:1:0,capshow:8:0");
    CHECK(f.o.mode == 0 && f.o.state == BUL_STATE_CAPTION_WAIT && f.o.next_state == 1);
    CHECK(strcmp((const char *)f.o.sound_name, "C1_1") == 0);
    /* pass in mode 0 / 2: only the state */
    for (int m = 0; m < 4; m += 2) {
        f.o.state = 0;
        f.o.anim_active = 1;
        f.o.button_kind = 1;
        f.o.mode = (int16_t)m;
        f.o.next_state = 5;
        fx_clear_records(&f);
        CHECK_INT(step(&f, 1), BUL_OK);
        CHECK(f.o.state == BUL_STATE_CAPTION_PICK && f.o.mode == m && f.o.next_state == 5 && f.n_play == 0 + (m == 0 ? 0 : 0));
    }
    /* button 2: the two markers go to the "clearing out" rectangles, state 9 */
    f.o.state = 0;
    f.o.anim_active = 1;
    f.o.button_kind = 2;
    f.o.mode = 0;
    f.o.cur_player = RC(500);
    f.o.cur_computer = RC(600);
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.state == BUL_STATE_RESET_WAIT && f.o.button_down == 0);
    CHECK_RECT(f.o.clear[2], RC(500));
    CHECK_RECT(f.o.clear[3], RC(600));
    /* the roll picks (state 1): mode 0 entry 0, mode 2 entry 1, other modes nothing */
    f.o.state = BUL_STATE_CAPTION_PICK;
    f.o.mode = 0;
    f.o.next_state = 9;
    rand_set(&f, 1, 1);
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "rand:1:0,prep:-1:0,play:30:0,captext:1:0,capshow:8:0");
    CHECK(f.o.state == BUL_STATE_CAPTION_WAIT && f.o.next_state == 0 && strcmp((const char *)f.o.sound_name, "C0_3") == 0);
    f.o.state = BUL_STATE_CAPTION_PICK;
    f.o.mode = 2;
    f.o.next_state = 9;
    rand_set(&f, 1, 2);
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.state == BUL_STATE_CAPTION_WAIT && f.o.next_state == 0 && strcmp((const char *)f.o.sound_name, "C1_4") == 0 &&
          f.o.cap_channel == CH_CAP1);
    for (int m = 1; m < 4; m += 2) {
        f.o.state = BUL_STATE_CAPTION_PICK;
        f.o.mode = (int16_t)m;
        f.o.next_state = 9;
        fx_clear_records(&f);
        CHECK_INT(step(&f, 1), BUL_OK);
        CHECK(f.o.state == BUL_STATE_IDLE && f.o.next_state == 9 && f.log[0] == '\0');
    }
    /* no real name: next_state stays */
    for (int i = 2; i < 6; ++i) set_nosound(f.body, cap_name(0, i));
    f.o.state = BUL_STATE_CAPTION_PICK;
    f.o.mode = 0;
    f.o.next_state = 9;
    rand_set(&f, 4, 0, 1, 2, 3);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.state == BUL_STATE_IDLE && f.o.next_state == 9);
}

static void t_pick_moves(void)
{
    Fx f;
    fx_init(&f);
    start_game(&f);
    /* mode 0: set 0; draws (odd bit, row): (1,2) (0,1) (1,3) (0,0) -> 2 moves */
    f.o.state = BUL_STATE_PICK_MOVES;
    f.o.step = 5;
    f.o.anim_active = 1;
    f.o.mode = 0;
    rand_set(&f, 8, 1, 2, 4, 5, 3, 7, 8, 8);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "rand:1:0,rand:2:0,rand:4:0,rand:5:0,rand:3:0,rand:7:0,rand:8:0,rand:8:0");
    CHECK(f.o.moves == 2 && f.o.step == 0 && f.o.anim_active == 0 && f.o.state == BUL_STATE_MOVING);
    CHECK_RECT(f.o.roll_a[0], RC(O_WORK + 2 * 0x20 + 16));
    CHECK_RECT(f.o.roll_a[1], RC(O_WORK + 1 * 0x20));
    CHECK_RECT(f.o.roll_a[2], RC(O_WORK + 3 * 0x20 + 16));
    CHECK_RECT(f.o.roll_a[3], RC(O_WORK));
    CHECK_RECT(f.o.roll_b[0], RC(O_WORK)); /* the other set is untouched */
    /* no odd draw: 5 moves */
    fx_clear_records(&f);
    f.o.state = BUL_STATE_PICK_MOVES;
    rand_set(&f, 8, 2, 0, 4, 1, 6, 2, 8, 3);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.moves == 5);
    CHECK_RECT(f.o.roll_a[3], RC(O_WORK + 3 * 0x20));
    /* one odd draw */
    f.o.state = BUL_STATE_PICK_MOVES;
    rand_set(&f, 8, 2, 0, 4, 1, 6, 2, 9, 3);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.moves == 1);
    CHECK_RECT(f.o.roll_a[3], RC(O_WORK + 3 * 0x20 + 16));
    /* modes 2 and 3 fill the second set; mode 1 the first */
    for (int m = 1; m < 4; ++m) {
        f.o.state = BUL_STATE_PICK_MOVES;
        f.o.mode = (int16_t)m;
        f.o.roll_a[0] = RC(1);
        f.o.roll_b[0] = RC(1);
        rand_set(&f, 8, 1, 1, 1, 1, 1, 1, 1, 1);
        CHECK_INT(step(&f, 1), BUL_OK);
        CHECK(f.o.moves == 4);
        if (m == 1) {
            CHECK_RECT(f.o.roll_a[0], RC(O_WORK + 0x20 + 16));
            CHECK_RECT(f.o.roll_b[0], RC(1));
        } else {
            CHECK_RECT(f.o.roll_b[0], RC(O_WORK + 0x20 + 16));
            CHECK_RECT(f.o.roll_a[0], RC(1));
        }
    }
}

static void t_moving(void)
{
    Fx f;
    fx_init(&f);
    start_game(&f);
    f.now = 5000;
    /* waits for the deadline */
    f.o.state = BUL_STATE_MOVING;
    f.o.moves = 2;
    f.o.step = 0;
    f.o.deadline_16e = 5001;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:5000:0");
    CHECK(f.o.state == BUL_STATE_MOVING && f.o.side == 0 && f.o.step == 0);
    /* a step of the player: forward, sound, deadline 200 ms */
    fx_clear_records(&f);
    f.o.deadline_16e = 5000;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:5000:0,busy:20:0,play:20:0,tick:5000:0");
    CHECK(f.o.side == 0 && f.o.pos_player == 2 && f.o.step == 1 && f.o.state == BUL_STATE_WAIT && f.o.deadline_180 == 5200u);
    CHECK_RECT(f.o.moving, RC(O_POS));
    CHECK_RECT(f.o.cur_player, RC(O_POS + 16));
    CHECK_RECT(f.o.image_player, RC(O_MARK));
    /* state 4: strictly after the deadline */
    fx_clear_records(&f);
    f.now = 5200;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.state == BUL_STATE_WAIT);
    f.now = 5201;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.state == BUL_STATE_MOVING);
    /* the player wraps from M to 1 */
    f.o.pos_player = 6;
    f.o.pos_computer = 3;
    f.o.step = 0;
    f.o.deadline_16e = 0;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.pos_player == 1 && f.o.step == 1);
    CHECK_RECT(f.o.cur_player, RC(O_POS));
    /* the computer walks backwards, 400 ms between steps (one-player game); wraps from 1 to M */
    f.o.state = BUL_STATE_MOVING;
    f.o.mode = 2;
    f.o.pos_player = 2;
    f.o.pos_computer = 5;
    f.o.step = 0;
    f.o.moves = 2;
    f.now = 7000;
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.side == 1 && f.o.pos_computer == 4 && f.o.deadline_180 == 7400u && f.o.state == BUL_STATE_WAIT);
    CHECK_RECT(f.o.moving, RC(O_POS + 5 * 16)); /* the rectangle of the start position 6 */
    CHECK_RECT(f.o.cur_computer, RC(O_POS + 3 * 16));
    CHECK_RECT(f.o.image_computer, RC(O_MARK + 16));
    f.o.state = BUL_STATE_MOVING;
    f.o.mode = 3;
    f.o.pos_computer = 1;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.pos_computer == 6 && f.o.side == 1);
    CHECK_RECT(f.o.cur_computer, RC(O_POS + 5 * 16));
    /* a second player: 200 ms for both sides */
    f.o.state = BUL_STATE_MOVING;
    f.body[O_TWO] = 1;
    f.o.step = 0;
    f.now = 7000;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.deadline_180 == 7200u);
    f.body[O_TWO] = 0;
    /* no step sound for a NO SOUND record; a busy channel is queried only */
    set_nosound(f.body, O_SSTEP);
    f.o.state = BUL_STATE_MOVING;
    f.o.step = 0;
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:7000:0,tick:7000:0");
    set_str(f.body, O_SSTEP, "STEP");
    f.busy_mask = 1u << CH_STEP;
    f.o.state = BUL_STATE_MOVING;
    f.o.step = 0;
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:7000:0,busy:20:1,tick:7000:0");
    f.busy_mask = 0;
}

static void t_move_end(void)
{
    Fx f;
    fx_init(&f);
    start_game(&f);
    f.now = 5000;
    /* the moves are over and the markers are apart: mode 0 -> 1, no caption */
    f.o.state = BUL_STATE_MOVING;
    f.o.moves = 2;
    f.o.step = 2;
    f.o.pos_player = 3;
    f.o.pos_computer = 6;
    f.o.mode = 0;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:5000:0");
    CHECK(f.o.mode == 1 && f.o.state == BUL_STATE_IDLE);
    /* mode 1 -> 2 with the caption of entry 0 (names 0x65d) */
    f.o.state = BUL_STATE_MOVING;
    fx_clear_records(&f);
    rand_set(&f, 1, 2);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:5000:0,rand:2:0,prep:-1:0,play:30:0,captext:1:0,capshow:8:0");
    CHECK(f.o.mode == 2 && f.o.state == BUL_STATE_CAPTION_WAIT && f.o.next_state == 1);
    CHECK(strcmp((const char *)f.o.sound_name, "C0_8") == 0); /* 0x65d = index 6 of entry 0, plus the draw 2 */
    /* no real caption name: state 1 */
    f.o.state = BUL_STATE_MOVING;
    f.o.mode = 1;
    f.o.next_state = 4;
    for (int i = 6; i < 10; ++i) set_nosound(f.body, cap_name(0, i));
    rand_set(&f, 4, 0, 1, 2, 3);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.mode == 2 && f.o.state == BUL_STATE_CAPTION_PICK && f.o.next_state == 4);
    /* mode 2 -> 3 without a caption */
    f.o.state = BUL_STATE_MOVING;
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:5000:0");
    CHECK(f.o.mode == 3 && f.o.state == BUL_STATE_IDLE);
    /* mode 3 -> 0 with the caption of entry 1 (names 0x939) */
    f.o.state = BUL_STATE_MOVING;
    rand_set(&f, 1, 3);
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:5000:0,rand:3:0,prep:-1:0,play:31:0,captext:1:0,capshow:8:0");
    CHECK(f.o.mode == 0 && f.o.state == BUL_STATE_CAPTION_WAIT && f.o.next_state == 1);
    CHECK(strcmp((const char *)f.o.sound_name, "C1_9") == 0); /* 0x939 = index 6 of entry 1, plus the draw 3 */
    f.o.state = BUL_STATE_MOVING;
    f.o.mode = 3;
    for (int i = 6; i < 10; ++i) set_nosound(f.body, cap_name(1, i));
    rand_set(&f, 4, 0, 1, 2, 3);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.mode == 0 && f.o.state == BUL_STATE_CAPTION_PICK);
    /* the markers meet after a player step: caption of entry 0 (0x6e1), state 6, 1200 ms, marker image, score */
    f.o.state = BUL_STATE_MOVING;
    f.o.mode = 1;
    f.o.pos_player = 4;
    f.o.pos_computer = 4;
    f.o.score_player = 1;
    rand_set(&f, 1, 0);
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:5000:0,rand:0:0,prep:-1:0,play:30:0,captext:1:0,capshow:8:0,tick:5000:0");
    CHECK(f.o.state == BUL_STATE_SCORE && f.o.deadline_17c == 6200u && f.o.score_player == 2 && f.o.mode == 1);
    CHECK_RECT(f.o.image_player, RC(O_MARK2));
    CHECK(strcmp((const char *)f.o.sound_name, "C0_10") == 0); /* 0x6e1 = index 10 of entry 0, draw 0 */
    /* the computer meets the player on its step (side 1): entry 1, the computer score */
    f.o.state = BUL_STATE_MOVING;
    f.o.mode = 2;
    rand_set(&f, 1, 1);
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.state == BUL_STATE_SCORE && f.o.score_computer == 1 && f.o.score_player == 2 && f.o.side == 1);
    CHECK_RECT(f.o.image_computer, RC(O_MARK2 + 16));
    CHECK(strcmp((const char *)f.o.sound_name, "C1_11") == 0 && f.o.cap_channel == CH_CAP1);
    /* a caption without a real name still scores */
    f.o.state = BUL_STATE_MOVING;
    f.o.mode = 0;
    for (int i = 10; i < 14; ++i) set_nosound(f.body, cap_name(0, i));
    rand_set(&f, 4, 0, 1, 2, 3);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.state == BUL_STATE_SCORE && f.o.score_player == 3);
}

static void t_score_state(void)
{
    Fx f;
    fx_init(&f);
    start_game(&f);
    f.now = 5000;
    /* before / on the deadline nothing happens */
    f.o.state = BUL_STATE_SCORE;
    f.o.deadline_17c = 5000;
    f.o.score_player = 1;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:5000:0");
    CHECK(f.o.state == BUL_STATE_SCORE);
    /* mode 0 or 1: the computer's marker is the moving piece, the erase rectangle is a computer barrack slot, the game resets */
    for (int m = 0; m < 2; ++m) {
        f.o.state = BUL_STATE_SCORE;
        f.o.deadline_17c = 4999;
        f.o.mode = (int16_t)m;
        f.o.score_player = 1;
        f.o.cur_computer = RC(777);
        f.o.cur_player = RC(888);
        f.o.pos_player = 2;
        f.o.light = 0;
        CHECK_INT(step(&f, 1), BUL_OK);
        CHECK(f.o.state == BUL_STATE_IDLE && f.o.mode == 0 && f.o.pos_player == 1 && f.o.pos_computer == 6);
        CHECK_RECT(f.o.moving, RC(777));
        CHECK_RECT(f.o.erase, RC(O_CBARRACK + 1 * 16));
        CHECK_RECT(f.o.cur_player, RC(O_POS));
        CHECK_RECT(f.o.cur_computer, RC(O_POS + 5 * 16));
        CHECK(f.o.score_player == 1); /* the scores stay */
    }
    /* mode 2 or 3: the player's marker is the moving piece, the erase rectangle a player barrack slot */
    for (int m = 2; m < 4; ++m) {
        f.o.state = BUL_STATE_SCORE;
        f.o.deadline_17c = 4999;
        f.o.mode = (int16_t)m;
        f.o.score_computer = 1;
        f.o.cur_player = RC(888);
        CHECK_INT(step(&f, 1), BUL_OK);
        CHECK(f.o.state == BUL_STATE_IDLE && f.o.mode == 0);
        CHECK_RECT(f.o.moving, RC(888));
        CHECK_RECT(f.o.erase, RC(O_PBARRACK + 1 * 16));
    }
    /* the last piece: win (state 7, won, finish kind 1); the erase index is -1 (the last slot of the previous array) */
    f.o.state = BUL_STATE_SCORE;
    f.o.deadline_17c = 4999;
    f.o.mode = 0;
    f.o.score_player = 3;
    f.o.score_computer = 0;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.state == BUL_STATE_WIN && f.o.won == 1 && f.o.finish_kind == 1);
    CHECK_RECT(f.o.erase, RC(O_CBARRACK - 16));
    /* lose (state 8) */
    f.o.state = BUL_STATE_SCORE;
    f.o.won = 0;
    f.o.finish_kind = 0;
    f.o.mode = 2;
    f.o.score_player = 0;
    f.o.score_computer = 3;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.state == BUL_STATE_LOSE && f.o.won == 0 && f.o.finish_kind == 1);
    CHECK_RECT(f.o.erase, RC(O_PBARRACK - 16));
    /* the player's win is checked first */
    f.o.state = BUL_STATE_SCORE;
    f.o.mode = 0;
    f.o.score_player = 3;
    f.o.score_computer = 3;
    f.o.won = 0;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.state == BUL_STATE_WIN && f.o.won == 1);
}

static void t_end_states(void)
{
    Fx f;
    uint32_t after;
    fx_init(&f);
    start_game(&f);
    f.now = 5000;
    /* state 7: the win caption (entry 0, names 0x765), then the exit delay */
    f.o.state = BUL_STATE_WIN;
    rand_set(&f, 1, 3);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "rand:3:0,prep:-1:0,play:30:0,captext:1:0,capshow:8:0,tick:5000:0");
    CHECK(f.o.state == BUL_STATE_CAPTION_WAIT && f.o.next_state == BUL_STATE_EXIT_DELAY && f.o.deadline_16e == 5500u);
    CHECK(f.phase == 1u);
    CHECK(strcmp((const char *)f.o.sound_name, "C0_17") == 0); /* 0x765 = index 14 of entry 0, draw 3 */
    /* without a caption the game ends at once (phase 2) */
    for (int i = 0; i < 22; ++i) set_nosound(f.body, cap_name(0, i));
    f.o.state = BUL_STATE_WIN;
    rand_set(&f, 4, 0, 1, 2, 3);
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "rand:0:0,rand:1:0,rand:2:0,rand:3:0,rowphase:2:0");
    CHECK(f.phase == 2u && f.o.state == BUL_STATE_WIN);
    /* state 8: entry 1, names 0xa41 */
    f.o.state = BUL_STATE_LOSE;
    rand_set(&f, 1, 0);
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "rand:0:0,prep:-1:0,play:31:0,captext:1:0,capshow:8:0,tick:5000:0");
    CHECK(f.phase == 1u && f.o.next_state == BUL_STATE_EXIT_DELAY && f.o.deadline_16e == 5500u);
    CHECK(strcmp((const char *)f.o.sound_name, "C1_14") == 0); /* 0xa41 = index 14 of entry 1, draw 0 */
    for (int i = 0; i < 22; ++i) set_nosound(f.body, cap_name(1, i));
    f.o.state = BUL_STATE_LOSE;
    rand_set(&f, 4, 0, 1, 2, 3);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.phase == 2u);
    /* state 0xb: the exit delay */
    f.o.state = BUL_STATE_EXIT_DELAY;
    f.o.deadline_16e = 5001;
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:5000:0");
    CHECK(f.phase == 1u);
    f.o.deadline_16e = 5000;
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "tick:5000:0,rowphase:2:0");
    CHECK(f.phase == 2u);
    /* state 9: waits for the third button's sound to finish, then the game is reset */
    f.o.state = BUL_STATE_RESET_WAIT;
    f.o.score_player = 2;
    f.o.score_computer = 1;
    f.o.mode = 3;
    f.o.pos_player = 4;
    f.busy_mask = 1u << CH_BTN2;
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "busy:23:1");
    CHECK(f.o.state == BUL_STATE_RESET_WAIT && f.o.score_player == 2);
    f.busy_mask = 0;
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "busy:23:0");
    CHECK(f.o.state == BUL_STATE_IDLE && f.o.score_player == 0 && f.o.score_computer == 0 && f.o.mode == 0 && f.o.pos_player == 1);
    /* state 10: waits for the caption channel, then continues with the stored next state */
    f.o.state = BUL_STATE_CAPTION_WAIT;
    f.o.cap_channel = CH_CAP1;
    f.o.next_state = BUL_STATE_PICK_MOVES;
    f.busy_mask = 1u << CH_CAP1;
    fx_clear_records(&f);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK_LOG(&f, "busy:31:1");
    CHECK(f.o.state == BUL_STATE_CAPTION_WAIT);
    f.busy_mask = 0;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.state == BUL_STATE_PICK_MOVES);
    /* state 5 and states above 0xb do nothing */
    for (int s = 5; s <= 12; s += 7) {
        f.o.state = s;
        fx_clear_records(&f);
        after = 99;
        CHECK_INT(step(&f, 1), BUL_OK);
        CHECK(f.log[0] == '\0' && f.o.state == s && f.phase == 1u);
        (void)after;
    }
    f.o.state = -1;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.log[0] == '\0');
}

/* ---- phase 2 -------------------------------------------------------------------------------------------------------------- */

static void phase2_setup(Fx *f)
{
    CHECK_INT(step(f, 0), BUL_OK);
    f->o.state = BUL_STATE_EXIT_DELAY;
    fx_clear_records(f);
}

static void t_phase2(void)
{
    Fx f;
    /* a game that was left (finish kind 0): the 0xb65 block */
    fx_init(&f);
    phase2_setup(&f);
    CHECK_INT(step(&f, 2), BUL_OK);
    CHECK_LOG(&f, "start:1:0,stop:1278:0,stop:1327:0,stop:1376:0,x57b:222:0,x599:4:0,x595:5:0,x39ff:6:0,x59b:40:0,x59f:50:0,"
                  "x5a3:60:0,start:1:0,mode:4:0,evflag:7:204,complete:3:0,relsurf:77:0,relslot:24:0");
    CHECK(f.result.completed == 1 && f.result.initialized == 0 && f.result.phase_after == 0u && f.phase == 0u);
    CHECK(f.transition.scene == 222 && f.transition.word[0] == 4 && f.transition.word[1] == 5 && f.transition.word[2] == 6 &&
          f.transition.dword[0] == 40 && f.transition.dword[1] == 50 && f.transition.dword[2] == 60);
    CHECK(f.engine_mode == 4 && f.n_flag == 1 && f.flag_hist[0][0] == 7 && f.flag_hist[0][1] == 0xcc);
    CHECK(f.o.row == -1 && f.o.slot == -1 && f.o.active == 0 && f.o.surface == 0u && f.o.finish_kind == 0 && f.o.won == 0);
    CHECK(f.w.start_flag_5bb1ca == 1);
    /* the start-flag word 1 stores 0 */
    fx_init(&f);
    put16(f.body, O_LEFT + 20, 1);
    phase2_setup(&f);
    CHECK_INT(step(&f, 2), BUL_OK);
    CHECK(f.w.start_flag_5bb1ca == 0);
    /* scene 9999: no transition, no start flag change, no engine mode; the flag is still stored */
    fx_init(&f);
    put16(f.body, O_LEFT, 9999);
    phase2_setup(&f);
    CHECK_INT(step(&f, 2), BUL_OK);
    CHECK_LOG(&f, "start:1:0,stop:1278:0,stop:1327:0,stop:1376:0,evflag:7:204,complete:3:0,relsurf:77:0,relslot:24:0");
    CHECK(f.n_transition == 0 && f.n_engine == 0);
    /* flag -1: nothing is stored */
    put16(f.body, O_LEFT + 22, -1);
    fx_init(&f);
    put16(f.body, O_LEFT + 22, -1);
    phase2_setup(&f);
    CHECK_INT(step(&f, 2), BUL_OK);
    CHECK(f.n_flag == 0 && strstr(f.log, "evflag") == NULL);
    /* the player won: block 0xb49, flag 5 with value 0xaa */
    fx_init(&f);
    phase2_setup(&f);
    f.o.finish_kind = 1;
    f.o.won = 1;
    CHECK_INT(step(&f, 2), BUL_OK);
    CHECK_LOG(&f, "start:1:0,stop:1278:0,stop:1327:0,stop:1376:0,x57b:111:0,x599:1:0,x595:2:0,x39ff:3:0,x59b:10:0,x59f:20:0,"
                  "x5a3:30:0,start:0:0,mode:4:0,evflag:5:170,complete:3:0,relsurf:77:0,relslot:24:0");
    /* the player lost: the second flag word / value of the same block */
    fx_init(&f);
    phase2_setup(&f);
    f.o.finish_kind = 1;
    f.o.won = 0;
    CHECK_INT(step(&f, 2), BUL_OK);
    CHECK(f.n_flag == 1 && f.flag_hist[0][0] == 6 && f.flag_hist[0][1] == 0xbb && f.transition.scene == 111);
    /* flags -1 in the ended block */
    fx_init(&f);
    phase2_setup(&f);
    f.o.finish_kind = 1;
    f.o.won = 1;
    put16(f.body, O_ENDED + 22, -1);
    CHECK_INT(step(&f, 2), BUL_OK);
    CHECK(f.n_flag == 0);
    fx_init(&f);
    phase2_setup(&f);
    f.o.finish_kind = 1;
    put16(f.body, O_ENDED + 25, -1);
    CHECK_INT(step(&f, 2), BUL_OK);
    CHECK(f.n_flag == 0);
    /* NO SOUND records are not stopped */
    fx_init(&f);
    set_nosound(f.body, O_SBTN);
    set_nosound(f.body, O_SBTN + 2 * REC_BYTES);
    phase2_setup(&f);
    CHECK_INT(step(&f, 2), BUL_OK);
    CHECK(f.n_stop == 1 && f.stop_hist[0] == O_SBTN + REC_BYTES);
    /* an invalid event flag index is refused before any effect */
    fx_init(&f);
    phase2_setup(&f);
    f.flag_limit = 7;
    CHECK(step(&f, 2) == BUL_ERR_BOUNDS && strcmp(f.failure, "0xda-event-flag-index") == 0 && f.log[0] == '\0');
    CHECK(f.o.row == ROW && f.o.active == 1);
    f.flag_limit = 8;
    CHECK_INT(step(&f, 2), BUL_OK);
    /* a host failure inside the finish */
    fx_init(&f);
    phase2_setup(&f);
    f.calls = 0;
    f.fail_call = 4; /* the transition: three stops before it */
    CHECK(step(&f, 2) == BUL_ERR_HOST && strcmp(f.failure, "0xda-host") == 0 && f.result.completed == 0);
    /* a failing release is reported after the completion effect */
    fx_init(&f);
    phase2_setup(&f);
    f.calls = 0;
    f.fail_call = 8; /* 3 stops, transition, flag, engine mode, release surface */
    CHECK(step(&f, 2) == BUL_ERR_HOST && f.result.completed == 1);
}

static void t_step_edges(void)
{
    Fx f;
    fx_init(&f);
    /* phase 1 / 2 before phase 0 */
    CHECK(step(&f, 1) == BUL_ERR_UNSUPPORTED && strcmp(f.failure, "0xda-phase-1-without-init") == 0 && f.log[0] == '\0');
    CHECK(step(&f, 2) == BUL_ERR_UNSUPPORTED && strcmp(f.failure, "0xda-phase-2-without-init") == 0 && f.log[0] == '\0');
    /* other phases are ignored */
    CHECK_INT(step(&f, 3), BUL_OK);
    CHECK(f.result.phase_after == 3u && f.result.initialized == 0 && f.result.completed == 0 && f.log[0] == '\0');
    CHECK_INT(step(&f, 0xffffffffu), BUL_OK);
    /* phase 0 needs a row */
    CHECK(bul_step(&f.o, f.body, BUL_BODY_BYTES, -1, 0, &f.w, &f.host, &f.result, &f.failure) == BUL_ERR_ARGUMENT);
    CHECK(strcmp(f.failure, "0xda-row") == 0 && f.log[0] == '\0');
    CHECK(bul_step(&f.o, f.body, BUL_BODY_BYTES, 0, 0, &f.w, &f.host, &f.result, &f.failure) == BUL_OK && f.o.row == 0);
    fx_init(&f);
    start_game(&f);
    /* another row */
    CHECK(bul_step(&f.o, f.body, BUL_BODY_BYTES, ROW + 1, 1, &f.w, &f.host, &f.result, &f.failure) == BUL_ERR_UNSUPPORTED);
    CHECK(bul_step(&f.o, f.body, BUL_BODY_BYTES, ROW + 1, 2, &f.w, &f.host, &f.result, &f.failure) == BUL_ERR_UNSUPPORTED);
    /* inactive object */
    f.o.active = 0;
    CHECK(step(&f, 1) == BUL_ERR_UNSUPPORTED);
    f.o.active = 1;
    /* a body that fails validation is refused before any effect, in every phase */
    f.body[O_M] = 0;
    for (uint32_t ph = 0; ph < 3; ++ph) {
        CHECK(step(&f, ph) == BUL_ERR_BODY && strcmp(f.failure, "0xda-position-count") == 0 && f.log[0] == '\0');
    }
    CHECK(bul_step(&f.o, f.body, BUL_BODY_BYTES - 1u, ROW, 1, &f.w, &f.host, &f.result, &f.failure) == BUL_ERR_BODY);
    f.body[O_M] = 6;
    /* arguments */
    CHECK(bul_step(NULL, f.body, BUL_BODY_BYTES, ROW, 1, &f.w, &f.host, &f.result, &f.failure) == BUL_ERR_ARGUMENT);
    CHECK(bul_step(&f.o, NULL, BUL_BODY_BYTES, ROW, 1, &f.w, &f.host, &f.result, &f.failure) == BUL_ERR_ARGUMENT);
    CHECK(bul_step(&f.o, f.body, BUL_BODY_BYTES, ROW, 1, NULL, &f.host, &f.result, &f.failure) == BUL_ERR_ARGUMENT);
    CHECK(bul_step(&f.o, f.body, BUL_BODY_BYTES, ROW, 1, &f.w, NULL, &f.result, &f.failure) == BUL_ERR_ARGUMENT);
    CHECK(bul_step(&f.o, f.body, BUL_BODY_BYTES, ROW, 1, &f.w, &f.host, NULL, &f.failure) == BUL_ERR_ARGUMENT);
    CHECK(bul_step(&f.o, f.body, BUL_BODY_BYTES, ROW, 1, &f.w, &f.host, &f.result, NULL) == BUL_OK);
    {
        BulHost bad = f.host;
        bad.engine_mode = NULL;
        CHECK(bul_step(&f.o, f.body, BUL_BODY_BYTES, ROW, 1, &f.w, &bad, &f.result, &f.failure) == BUL_ERR_ARGUMENT);
    }
    /* hand-made objects the kernel never builds are refused before any effect */
    {
        struct { int what; } cases[] = {{0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}, {9}};
        for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
            BulObject saved = f.o;
            fx_clear_records(&f);
            switch (cases[i].what) {
            case 0: f.o.mode = 4; break;
            case 1: f.o.mode = -1; break;
            case 2: f.o.score_player = 4; break;
            case 3: f.o.score_computer = -1; break;
            case 4: f.o.pos_player = 0; break;
            case 5: f.o.pos_computer = 7; break;
            case 6: f.o.side = 2; break;
            case 7: f.o.button_kind = 3; break;
            case 8: f.o.score_computer = 4; break;
            default: f.o.pos_player = 7; break;
            }
            CHECK(step(&f, 1) == BUL_ERR_UNSUPPORTED && strcmp(f.failure, "0xda-object-state") == 0 && f.log[0] == '\0');
            f.o = saved;
        }
    }
}

/* ---- render --------------------------------------------------------------------------------------------------------------- */

static int render(Fx *f, BulRenderResult *r)
{
    return bul_render(&f->o, f->body, BUL_BODY_BYTES, &f->host, r);
}

static int kinds_are(const BulRenderResult *r, const int *kinds, size_t n)
{
    if (r->count != n) return 0;
    for (size_t i = 0; i < n; ++i) {
        if (r->blit[i].kind != kinds[i]) return 0;
    }
    return 1;
}

static void t_render_start(void)
{
    Fx f;
    BulRenderResult r;
    fx_init(&f);
    /* inactive object / no z entry: the callback does nothing */
    CHECK(render(&f, &r) == BUL_OK && r.valid == 0 && r.count == 0);
    start_game(&f);
    f.o.slot = -1;
    CHECK(render(&f, &r) == BUL_OK && r.valid == 0 && r.count == 0);
    f.o.slot = 0x18;
    f.o.active = 0;
    CHECK(render(&f, &r) == BUL_OK && r.valid == 0 && r.count == 0);
    f.o.active = 1;
    CHECK(render(&f, &r) == BUL_OK && r.valid == 1);
    {
        const int expect[] = {BUL_BLIT_ROLL_A, BUL_BLIT_ROLL_A, BUL_BLIT_ROLL_A, BUL_BLIT_ROLL_A, BUL_BLIT_ROLL_B, BUL_BLIT_ROLL_B,
                              BUL_BLIT_ROLL_B, BUL_BLIT_ROLL_B, BUL_BLIT_PLAYER_BARRACK, BUL_BLIT_PLAYER_BARRACK,
                              BUL_BLIT_COMPUTER_BARRACK, BUL_BLIT_COMPUTER_BARRACK, BUL_BLIT_PLAYER_LIGHT,
                              BUL_BLIT_COMPUTER_LIGHT_OFF, BUL_BLIT_PASS_DISABLED, BUL_BLIT_PLAYER_PIECE, BUL_BLIT_COMPUTER_PIECE};
        CHECK(kinds_are(&r, expect, sizeof expect / sizeof expect[0]));
    }
    /* the rectangles: sources from the object / body, destinations shifted by the view origin */
    CHECK(r.blit[0].index == 0 && r.blit[0].backdrop == 0);
    CHECK_RECT(r.blit[0].src, RC(O_WORK));
    CHECK_RECT(r.blit[0].dst, RCV(O_ROLLA));
    CHECK_RECT(r.blit[3].dst, RCV(O_ROLLA + 48));
    CHECK_RECT(r.blit[4].dst, RCV(O_ROLLB));
    CHECK(r.blit[9].index == 1);
    CHECK_RECT(r.blit[8].src, RC(O_PIECE_PB));
    CHECK_RECT(r.blit[9].dst, RCV(O_PBARRACK + 16));
    CHECK_RECT(r.blit[10].src, RC(O_PIECE_CB));
    CHECK_RECT(r.blit[11].dst, RCV(O_CBARRACK + 16));
    CHECK(r.blit[12].backdrop == 0 && r.blit[13].backdrop == 1);
    CHECK_RECT(r.blit[12].src, RC(O_PLIGHT_ON));
    CHECK_RECT(r.blit[12].dst, RCV(O_PLIGHT));
    CHECK_RECT(r.blit[13].src, RC(O_CLIGHT));
    CHECK_RECT(r.blit[13].dst, RCV(O_CLIGHT));
    CHECK_RECT(r.blit[14].src, RC(O_PASS_OFF));
    CHECK_RECT(r.blit[14].dst, RBV(1));
    CHECK_RECT(r.blit[15].src, RC(O_MARK));
    CHECK_RECT(r.blit[15].dst, RCV(O_POS));
    CHECK_RECT(r.blit[16].src, RC(O_MARK + 16));
    CHECK_RECT(r.blit[16].dst, RCV(O_POS + 80));
    /* every blit is observed in order */
    CHECK(strstr(f.log, "blit:1:0,blit:1:1") != NULL && strstr(f.log, "blit:18:0") != NULL);
    /* arguments and a host failure */
    CHECK(bul_render(NULL, f.body, BUL_BODY_BYTES, &f.host, &r) == BUL_ERR_ARGUMENT);
    CHECK(bul_render(&f.o, f.body, BUL_BODY_BYTES - 1u, &f.host, &r) == BUL_ERR_ARGUMENT);
    CHECK(bul_render(&f.o, f.body, BUL_BODY_BYTES, &f.host, NULL) == BUL_ERR_ARGUMENT);
    f.calls = 0;
    f.fail_call = 1;
    CHECK(render(&f, &r) == BUL_ERR_HOST && r.valid == 1 && r.count == 0);
    f.fail_call = 0;
    /* a changed view origin moves every destination */
    f.view_x = 100;
    f.view_y = 200;
    CHECK(render(&f, &r) == BUL_OK);
    CHECK(r.blit[0].dst.left == O_ROLLA + 100 && r.blit[0].dst.top == O_ROLLA + 1 + 200);
    CHECK(r.blit[0].src.left == O_WORK); /* the source rectangle is not shifted */
}

static void t_render_states(void)
{
    Fx f;
    BulRenderResult r;
    fx_init(&f);
    start_game(&f);
    /* scores 1 and 2: jails, barracks; mode 1 with the light on: player light on, pass enabled */
    f.o.score_player = 1;
    f.o.score_computer = 2;
    f.o.mode = 1;
    CHECK(render(&f, &r) == BUL_OK);
    {
        /* player barrack: 3 - 2 - 1 = 0, player jail 1, computer barrack 3 - 1 - 1 = 1, computer jail 2, player jail again 1 */
        const int expect[] = {1, 1, 1, 1, 2, 2, 2, 2, BUL_BLIT_PLAYER_JAIL, BUL_BLIT_COMPUTER_BARRACK, BUL_BLIT_COMPUTER_JAIL,
                              BUL_BLIT_COMPUTER_JAIL, BUL_BLIT_PLAYER_JAIL_AGAIN, BUL_BLIT_PLAYER_LIGHT,
                              BUL_BLIT_COMPUTER_LIGHT_OFF, BUL_BLIT_PASS_ENABLED, BUL_BLIT_PLAYER_PIECE, BUL_BLIT_COMPUTER_PIECE};
        CHECK(kinds_are(&r, expect, sizeof expect / sizeof expect[0]));
    }
    CHECK_RECT(r.blit[8].src, RC(O_PIECE_PJ));
    CHECK_RECT(r.blit[8].dst, RCV(O_PJAIL));
    CHECK_RECT(r.blit[10].src, RC(O_PIECE_CJ));
    CHECK_RECT(r.blit[11].dst, RCV(O_CJAIL + 16));
    CHECK(r.blit[11].index == 1);
    CHECK_RECT(r.blit[15].src, RB(1));
    CHECK(r.blit[15].backdrop == 1);
    /* mode 1 without the light: no light blits */
    f.o.light = 0;
    CHECK(render(&f, &r) == BUL_OK && r.count == 16);
    CHECK(r.blit[13].kind == BUL_BLIT_PASS_ENABLED);
    /* mode 2 / 3 with the light: computer light on, player light off (backdrop) */
    for (int m = 2; m < 4; ++m) {
        f.o.mode = (int16_t)m;
        f.o.light = 1;
        CHECK(render(&f, &r) == BUL_OK);
        CHECK(r.blit[13].kind == BUL_BLIT_COMPUTER_LIGHT && r.blit[13].backdrop == 0 && r.blit[14].kind == BUL_BLIT_PLAYER_LIGHT_OFF &&
              r.blit[14].backdrop == 1);
        CHECK_RECT(r.blit[13].src, RC(O_CLIGHT_ON));
        CHECK_RECT(r.blit[13].dst, RCV(O_CLIGHT));
        CHECK_RECT(r.blit[14].src, RC(O_PLIGHT));
        CHECK(r.blit[15].kind == (m == 2 ? BUL_BLIT_PASS_DISABLED : BUL_BLIT_PASS_ENABLED));
    }
    /* the erase rectangle (valid when right != 0) is restored from the backdrop and cleared */
    f.o.mode = 0;
    f.o.erase = RC(900);
    CHECK(render(&f, &r) == BUL_OK);
    {
        int found = -1;
        for (int i = 0; i < r.count; ++i) {
            if (r.blit[i].kind == BUL_BLIT_ERASE_BARRACK) found = i;
        }
        CHECK(found >= 0 && r.blit[found].backdrop == 1);
        if (found >= 0) {
            CHECK_RECT(r.blit[found].src, RC(900));
            CHECK_RECT(r.blit[found].dst, RCV(900));
            CHECK(r.blit[found - 1].kind == BUL_BLIT_PLAYER_JAIL_AGAIN);
        }
    }
    CHECK(f.o.erase.right == 0 && f.o.erase.left == 0);
    CHECK(render(&f, &r) == BUL_OK && strstr(f.log, "blit:8") != NULL);
    {
        int none = 1;
        for (int i = 0; i < r.count; ++i) none &= r.blit[i].kind != BUL_BLIT_ERASE_BARRACK;
        CHECK(none);
    }
    /* the button animation: pressed image while the down flag is set, then restored and the animation cleared */
    f.o.anim_active = 1;
    f.o.button_kind = 2;
    f.o.button_down = 1;
    CHECK(render(&f, &r) == BUL_OK);
    {
        const BulBlit *b = &r.blit[r.count - 1 - 2]; /* before the two pieces */
        CHECK(b->kind == BUL_BLIT_BUTTON_DOWN && b->index == 2 && b->backdrop == 0);
        CHECK_RECT(b->src, RC(O_BTNDOWN + 32));
        CHECK_RECT(b->dst, RBV(2));
    }
    CHECK(f.o.anim_active == 1);
    f.o.button_down = 0;
    CHECK(render(&f, &r) == BUL_OK);
    {
        const BulBlit *b = &r.blit[r.count - 1 - 2];
        CHECK(b->kind == BUL_BLIT_BUTTON_UP && b->index == 2 && b->backdrop == 1);
        CHECK_RECT(b->src, RB(2));
        CHECK_RECT(b->dst, RBV(2));
    }
    CHECK(f.o.anim_active == 0);
    /* the markers: while the score step runs (state 6) only the side that moved is drawn */
    f.o.state = BUL_STATE_SCORE;
    f.o.side = 0;
    CHECK(render(&f, &r) == BUL_OK);
    CHECK(r.blit[r.count - 1].kind == BUL_BLIT_PLAYER_PIECE && r.blit[r.count - 2].kind != BUL_BLIT_COMPUTER_PIECE);
    f.o.side = 1;
    CHECK(render(&f, &r) == BUL_OK);
    CHECK(r.blit[r.count - 1].kind == BUL_BLIT_COMPUTER_PIECE && r.blit[r.count - 2].kind != BUL_BLIT_PLAYER_PIECE);
    /* a finished game draws no markers */
    f.o.state = BUL_STATE_WIN;
    f.o.finish_kind = 1;
    CHECK(render(&f, &r) == BUL_OK);
    for (int i = 0; i < r.count; ++i) CHECK(r.blit[i].kind != BUL_BLIT_PLAYER_PIECE && r.blit[i].kind != BUL_BLIT_COMPUTER_PIECE);
    f.o.finish_kind = 0;
    /* the moving piece is erased from the backdrop and cleared, after the markers */
    f.o.state = BUL_STATE_WAIT;
    f.o.moving = RC(950);
    CHECK(render(&f, &r) == BUL_OK);
    CHECK(r.blit[r.count - 1].kind == BUL_BLIT_ERASE_MOVING && r.blit[r.count - 1].backdrop == 1 &&
          r.blit[r.count - 2].kind == BUL_BLIT_COMPUTER_PIECE);
    CHECK_RECT(r.blit[r.count - 1].src, RC(950));
    CHECK_RECT(r.blit[r.count - 1].dst, RCV(950));
    CHECK(f.o.moving.right == 0);
    /* state 9: the four clearing rectangles, last */
    f.o.state = BUL_STATE_RESET_WAIT;
    for (int i = 0; i < 4; ++i) f.o.clear[i] = RC(1000 + 10 * i);
    CHECK(render(&f, &r) == BUL_OK);
    for (int i = 0; i < 4; ++i) {
        const BulBlit *b = &r.blit[r.count - 4 + i];
        CHECK(b->kind == BUL_BLIT_CLEAR_PLAYER + i && b->backdrop == 1);
        CHECK_RECT(b->src, RC(1000 + 10 * i));
        CHECK_RECT(b->dst, RCV(1000 + 10 * i));
    }
    /* the largest picture (6 pieces per side) stays inside the blit list */
    {
        Fx g;
        fx_init(&g);
        put16(g.body, O_N, 6);
        start_game(&g);
        g.o.score_player = 6;
        g.o.score_computer = 6;
        g.o.erase = RC(1);
        g.o.moving = RC(1);
        g.o.state = BUL_STATE_RESET_WAIT;
        g.o.anim_active = 1;
        CHECK(render(&g, &r) == BUL_OK && r.count <= BUL_MAX_BLITS);
    }
}

static void t_invalidate(void)
{
    Fx f;
    fx_init(&f);
    CHECK(bul_invalidate(&f.o, &f.host) == BUL_OK && f.n_dirty == 0);
    start_game(&f);
    CHECK(bul_invalidate(&f.o, &f.host) == BUL_OK && f.n_dirty == 1 && f.dirty_slot == 0x18);
    CHECK_LOG(&f, "dirty:24:0");
    f.o.slot = -1;
    CHECK(bul_invalidate(&f.o, &f.host) == BUL_OK && f.n_dirty == 1);
    f.o.slot = 0x18;
    f.o.active = 0;
    CHECK(bul_invalidate(&f.o, &f.host) == BUL_OK && f.n_dirty == 1);
    f.o.active = 1;
    f.calls = 0;
    f.fail_call = 1;
    CHECK(bul_invalidate(&f.o, &f.host) == BUL_ERR_HOST);
    CHECK(bul_invalidate(NULL, &f.host) == BUL_ERR_ARGUMENT && bul_invalidate(&f.o, NULL) == BUL_ERR_ARGUMENT);
}

/* ---- a whole game, step by step ------------------------------------------------------------------------------------------- */

static void t_full_round(void)
{
    Fx f;
    BulPointerResult p;
    BulClickResult c;
    BulRenderResult r;
    fx_init(&f);
    CHECK_INT(step(&f, 0), BUL_OK);
    /* the greeting plays until its channel is free */
    f.busy_mask = 1u << CH_CAP1;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.state == BUL_STATE_CAPTION_WAIT);
    f.busy_mask = 0;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.state == BUL_STATE_IDLE);
    /* the player presses button 0 */
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 120, 215, &p) == BUL_OK && p.candidate == BUL_CANDIDATE_BUTTON);
    f.now = 10000;
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, f.phase, p.candidate, &c) == BUL_OK && c.handled == 1);
    CHECK(f.o.anim_active == 1 && f.o.button_kind == 0 && f.o.anim_deadline == 10250u);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 120, 215, &p) == BUL_OK && p.hit == 0); /* animation running */
    CHECK(render(&f, &r) == BUL_OK);
    CHECK(f.o.anim_active == 1);
    f.now = 10251;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.state == BUL_STATE_PICK_MOVES && f.o.button_down == 0 && f.o.deadline_16e == 11051u);
    CHECK(render(&f, &r) == BUL_OK && f.o.anim_active == 0); /* the restore ends the animation */
    /* three moves: draws odd, odd, odd, even (rows 0) */
    rand_set(&f, 8, 1, 0, 1, 0, 1, 0, 0, 0);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.moves == 3 && f.o.state == BUL_STATE_MOVING);
    f.now = 11051;
    for (int i = 1; i <= 3; ++i) {
        CHECK_INT(step(&f, 1), BUL_OK);
        CHECK(f.o.step == i && f.o.pos_player == 1 + i && f.o.state == BUL_STATE_WAIT);
        f.now += 201;
        CHECK_INT(step(&f, 1), BUL_OK);
        CHECK(f.o.state == BUL_STATE_MOVING);
    }
    /* the player stands on 4, the computer on 6: the move ends, mode 0 -> 1 without a caption */
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.mode == 1 && f.o.state == BUL_STATE_IDLE);
    /* the player passes: button 1 */
    f.o.state = BUL_STATE_IDLE;
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 230, 215, &p) == BUL_OK && p.button == 1);
    f.now = 20000;
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, p.candidate, &c) == BUL_OK && c.handled == 1);
    f.now = 20251;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.mode == 2);
    /* leaving the game: the finish rectangle */
    f.o.state = BUL_STATE_IDLE;
    f.o.anim_active = 0;
    f.o.mode = 0;
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 420, 410, &p) == BUL_OK && p.candidate == BUL_CANDIDATE_FINISH);
    rand_set(&f, 1, 0);
    CHECK(bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, 1u, p.candidate, &c) == BUL_OK && c.handled == 1 && c.new_phase == 1u);
    CHECK(f.o.next_state == BUL_STATE_EXIT_DELAY);
    f.busy_mask = 0;
    CHECK_INT(step(&f, 1), BUL_OK); /* the caption wait ends */
    CHECK(f.o.state == BUL_STATE_EXIT_DELAY);
    f.now = f.o.deadline_16e;
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.phase == 2u);
    CHECK_INT(step(&f, 2), BUL_OK);
    CHECK(f.result.completed == 1 && f.o.row == -1 && f.transition.scene == 222);
    /* the next game can start on the same object */
    CHECK_INT(step(&f, 0), BUL_OK);
    CHECK(f.o.row == ROW && f.o.active == 1 && f.o.surface == SURFACE);
}

/* ---- host failure sweep and fuzz ------------------------------------------------------------------------------------------ */

/* A fixed script through phase 0, a click, a step, a render, an invalidate and phase 2. Returns the first non-OK status. */
static int scenario(Fx *f)
{
    BulClickResult c;
    BulRenderResult r;
    int rc;
    f->w.start_flag_5bb1ca = 1;
    if ((rc = step(f, 0)) != BUL_OK) return rc;
    f->o.state = BUL_STATE_IDLE;
    f->o.pending_button = 0;
    f->now = 5000;
    if ((rc = bul_click(&f->o, f->body, BUL_BODY_BYTES, &f->w, &f->host, 1u, BUL_CANDIDATE_BUTTON, &c)) != BUL_OK) return rc;
    f->now = 6000;
    if ((rc = step(f, 1)) != BUL_OK) return rc; /* button end: state 2 */
    rand_set(f, 8, 1, 0, 1, 0, 1, 0, 1, 0);
    if ((rc = step(f, 1)) != BUL_OK) return rc; /* pick moves */
    f->o.deadline_16e = 0;
    if ((rc = step(f, 1)) != BUL_OK) return rc; /* one step, sound */
    f->o.state = BUL_STATE_MOVING;
    f->o.pos_computer = f->o.pos_player;
    f->o.step = f->o.moves;
    rand_set(f, 1, 0);
    if ((rc = step(f, 1)) != BUL_OK) return rc; /* markers meet: caption */
    if ((rc = render(f, &r)) != BUL_OK) return rc;
    if ((rc = bul_invalidate(&f->o, &f->host)) != BUL_OK) return rc;
    rand_set(f, 1, 0);
    if ((rc = bul_click(&f->o, f->body, BUL_BODY_BYTES, &f->w, &f->host, 1u, BUL_CANDIDATE_FINISH, &c)) != BUL_OK) return rc;
    f->o.state = BUL_STATE_EXIT_DELAY;
    f->o.won = 1;
    f->o.finish_kind = 1;
    return step(f, 2);
}

static void t_host_failure_sweep(void)
{
    unsigned seen = 0;
    int total = 0;
    {
        Fx f;
        fx_init(&f);
        f.observe_on = 0;
        CHECK_INT(scenario(&f), BUL_OK);
        total = f.calls;
    }
    CHECK(total > 25);
    for (int n = 1; n <= total + 2; ++n) {
        Fx f;
        int rc;
        fx_init(&f);
        f.observe_on = 0;
        f.fail_call = n;
        rc = scenario(&f);
        seen |= f.failed_mask;
        if (n <= total) {
            CHECK(rc == BUL_ERR_HOST);
        } else {
            CHECK(rc == BUL_OK);
        }
        if (g_failed) {
            snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (failing call %d rc %d)", n, rc);
            return;
        }
    }
    /* every failable callback failed at least once */
    for (int id = 1; id <= CB_LAST; ++id) {
        if (id == CB_DIRTY || id == CB_CLEARITEM) continue; /* clear-item is in the sweep; dirty has its own test */
        CHECK(((seen >> id) & 1u) != 0u);
    }
    CHECK(((seen >> CB_CLEARITEM) & 1u) != 0u);
}

static uint32_t g_rng = 12345u;
static uint32_t rngu(void)
{
    g_rng ^= g_rng << 13;
    g_rng ^= g_rng >> 17;
    g_rng ^= g_rng << 5;
    return g_rng;
}

static void t_fuzz(void)
{
    Fx f;
    for (int iter = 0; iter < 3000; ++iter) {
        BulRenderResult r;
        BulPointerResult p;
        BulClickResult c;
        int rc;
        fx_init(&f);
        f.observe_on = 0;
        put16(f.body, O_M, 1 + (int)(rngu() % 15));
        put16(f.body, O_N, 1 + (int)(rngu() % 6));
        put16(f.body, O_STARTP, 1 + (int)(rngu() % (uint32_t)(f.body[O_M])));
        put16(f.body, O_STARTC, 1 + (int)(rngu() % (uint32_t)(f.body[O_M])));
        f.body[O_TWO] = (uint8_t)(rngu() & 1u);
        f.body[O_SMART] = (uint8_t)(rngu() & 1u);
        for (int i = 0; i < 4; ++i) {
            if (rngu() % 3 == 0) set_nosound(f.body, O_SSTEP + (size_t)i * REC_BYTES);
        }
        for (int e = 0; e < 2; ++e) {
            for (int i = 0; i < 22; ++i) {
                if (rngu() % 3 == 0) set_nosound(f.body, cap_name(e, i));
            }
        }
        f.text = (rngu() % 4 == 0) ? NULL : "Hi";
        f.rand_default = (int32_t)(rngu() % 32768u);
        f.w.start_flag_5bb1ca = (int32_t)(rngu() & 1u);
        rc = step(&f, 0);
        CHECK(rc == BUL_OK);
        for (int k = 0; k < 60 && rc == BUL_OK; ++k) {
            const uint32_t pick = rngu() % 10u;
            f.now += rngu() % 700u;
            f.busy_mask = rngu();
            if (pick < 6) {
                if (rngu() % 3 == 0) f.o.deadline_16e = f.now - (rngu() % 3u);
                if (rngu() % 4 == 0) f.o.state = (int32_t)(rngu() % 13u);
                rc = step(&f, 1);
                if (rc == BUL_ERR_STUCK) rc = BUL_OK;
            } else if (pick == 6) {
                rc = bul_pointer(&f.o, f.body, BUL_BODY_BYTES, (int32_t)(rngu() % 500u), (int32_t)(rngu() % 500u), &p);
            } else if (pick == 7) {
                rc = bul_click(&f.o, f.body, BUL_BODY_BYTES, &f.w, &f.host, f.phase, (rngu() & 1u) ? BUL_CANDIDATE_BUTTON : BUL_CANDIDATE_FINISH, &c);
                if (rc == BUL_ERR_STUCK) rc = BUL_OK;
                if (c.new_phase == 2u) f.phase = 2u;
            } else if (pick == 8) {
                rc = render(&f, &r);
            } else {
                rc = bul_invalidate(&f.o, &f.host);
            }
            if (f.phase == 2u) {
                rc = step(&f, 2);
                break;
            }
        }
        CHECK(rc == BUL_OK || rc == BUL_ERR_BOUNDS || rc == BUL_ERR_UNSUPPORTED); /* forced states may leave scores out of range */
        CHECK(bul_cleanup(&f.o, &f.host) == BUL_OK);
        if (g_failed) {
            snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (iteration %d rc %d)", iter, rc);
            return;
        }
    }
}

/* ---- the session binding -------------------------------------------------------------------------------------------------- */

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
    uint8_t tsum[126], act[48 + 2 + BUL_BODY_BYTES];
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
static void h_store_world(void *c, const BulWorld *w)
{
    if (c == NULL) ++g_hook_bad;
    ++g_stores;
    g_store_start = w->start_flag_5bb1ca;
}

typedef struct Bind {
    Fx f;
    SessionAdaHost host;
    SessionAdaBinding *b;
    SceneResource *scene;
    uint8_t bytes[3 * (BUL_BODY_BYTES + 128) + 512];
    size_t bytes_len;
    uint8_t body_a[BUL_BODY_BYTES], body_b[BUL_BODY_BYTES];
} Bind;

static int bind_open(Bind *x, int hooks)
{
    const int types[3] = {0x70, 0xda, 0xda};
    const uint8_t one = 0;
    const uint8_t *bodies[3];
    size_t lengths[3] = {1, BUL_BODY_BYTES, BUL_BODY_BYTES};
    char err[128] = {0};
    fx_init(&x->f);
    g_stores = g_store_start = g_hook_bad = 0;
    memcpy(x->body_a, x->f.body, BUL_BODY_BYTES);
    memcpy(x->body_b, x->f.body, BUL_BODY_BYTES);
    /* row 2: another surface and fewer pieces */
    set_str(x->body_b, 0, "OTHER");
    put16(x->body_b, O_N, 2);
    bodies[0] = &one;
    bodies[1] = x->body_a;
    bodies[2] = x->body_b;
    x->bytes_len = build_scene(x->bytes, 3, types, bodies, lengths);
    x->scene = scene_resource_open_memory(x->bytes, x->bytes_len, err, sizeof err);
    if (x->scene == NULL) return 0;
    memset(&x->host, 0, sizeof x->host);
    x->host.kernel = x->f.host;
    x->host.kernel.context = &x->f;
    if (hooks) x->host.store_world = h_store_world;
    x->b = session_ada_create(&x->host);
    return x->b != NULL;
}

static void bind_close(Bind *x)
{
    session_ada_destroy(x->b);
    scene_resource_close(x->scene);
}

/* one handler visit of `row` with the given phase */
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
        const int rc = session_ada_handler(x->b, row, &info, &st, &out);
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
    BulPointerResult pr;
    BulClickResult cr;
    BulRenderResult r;
    CHECK(bind_open(&x, 1));
    CHECK(session_ada_object(x.b)->row == -1 && session_ada_registered(x.b) == 0u && strcmp(session_ada_failure(x.b), "none") == 0);
    CHECK(session_ada_world(x.b)->start_flag_5bb1ca == 0);
    /* nothing runs before the scene is loaded */
    CHECK(b_visit(&x, 1, 0u, &pa, &done) == SCENE_ACTION_HANDLER_ERROR);
    /* an idle puzzle ignores pointer, click, render, invalidate */
    CHECK(session_ada_pointer_move(x.b, 120, 215, &pr) == BUL_OK && pr.hit == 0 && pr.candidate == -1 && pr.button == -1);
    CHECK(session_ada_click(x.b, 1u, BUL_CANDIDATE_BUTTON, &cr) == BUL_OK && cr.handled == 0 && cr.new_phase == 1u);
    CHECK(session_ada_render(x.b, &r) == BUL_OK && r.valid == 0 && r.count == 0);
    CHECK(session_ada_invalidate(x.b) == BUL_OK && x.f.n_dirty == 0);
    CHECK(session_ada_begin_scene(x.b, x.scene) == BUL_OK);
    /* row 0 is another type; row 3 does not exist */
    CHECK(b_visit(&x, 0, 0u, &pa, &done) == SCENE_ACTION_HANDLER_ERROR && strcmp(session_ada_failure(x.b), "0xda-row-not-owned") == 0);
    CHECK(b_visit(&x, 1, 1u, &pa, &done) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    /* phase 0 of row 1 */
    CHECK(b_visit(&x, 1, 0u, &pa, &done) == SCENE_ACTION_HANDLER_OK && pa == 1u && done == 0);
    CHECK(strcmp(x.f.loaded_name, "BULSURF") == 0 && session_ada_object(x.b)->row == 1 && session_ada_registered(x.b) == 1u);
    CHECK(session_ada_world(x.b)->start_flag_5bb1ca == 1 && session_ada_object(x.b)->active == 1);
    CHECK(g_stores == 1 && g_store_start == 1 && g_hook_bad == 0);
    CHECK(strcmp(session_ada_failure(x.b), "none") == 0);
    /* phase 1: the greeting caption ends */
    CHECK(b_visit(&x, 1, 1u, &pa, &done) == SCENE_ACTION_HANDLER_OK && pa == 1u && done == 0);
    CHECK(session_ada_object(x.b)->state == BUL_STATE_IDLE && g_stores == 1);
    CHECK(session_ada_pointer_move(x.b, 120, 215, &pr) == BUL_OK && pr.hit == 1 && pr.candidate == BUL_CANDIDATE_BUTTON &&
          pr.button == 0 && session_ada_object(x.b)->pending_button == 0);
    CHECK(session_ada_pointer_move(x.b, 1, 1, &pr) == BUL_OK && pr.hit == 0 && pr.candidate == -1);
    CHECK(session_ada_invalidate(x.b) == BUL_OK && x.f.n_dirty == 1);
    CHECK(session_ada_render(x.b, &r) == BUL_OK && r.valid == 1 && r.count > 0 && strcmp(session_ada_failure(x.b), "none") == 0);
    x.f.now = 5000;
    CHECK(session_ada_click(x.b, 1u, BUL_CANDIDATE_BUTTON, &cr) == BUL_OK && cr.handled == 1 && cr.new_phase == 1u);
    CHECK(session_ada_object(x.b)->anim_active == 1);
    CHECK(session_ada_click(x.b, 1u, 5, &cr) == BUL_OK && cr.handled == 0);
    /* the finish rectangle ends the game when no caption name is real: the executor stores phase 2 */
    {
        SessionAdaBinding *dummy = x.b;
        (void)dummy;
    }
    ((BulObject *)session_ada_object(x.b))->anim_active = 0;
    for (int i = 17; i < 21; ++i) set_nosound(x.f.body, cap_name(0, i));
    /* (the binding's row copy is its own: the fixture body above is not the one the binding reads) */
    CHECK(session_ada_click(x.b, 1u, BUL_CANDIDATE_FINISH, &cr) == BUL_OK && cr.handled == 1);
    /* phase 2 completes the row and releases the object */
    CHECK(b_visit(&x, 1, 2u, &pa, &done) == SCENE_ACTION_HANDLER_OK && pa == 0u && done == 1);
    CHECK(g_stores == 2 && session_ada_object(x.b)->row == -1 && session_ada_registered(x.b) == 0u);
    CHECK(x.f.engine_mode == 4 && x.f.transition.scene == 222 && x.f.n_relslot == 1);
    CHECK(session_ada_render(x.b, &r) == BUL_OK && r.valid == 0);
    CHECK(session_ada_pointer_move(x.b, 120, 215, &pr) == BUL_OK && pr.hit == 0);
    CHECK(session_ada_click(x.b, 1u, BUL_CANDIDATE_BUTTON, &cr) == BUL_OK && cr.handled == 0);
    /* row 2: another surface, loaded by name */
    CHECK(b_visit(&x, 2, 0u, &pa, &done) == SCENE_ACTION_HANDLER_OK && strcmp(x.f.loaded_name, "OTHER") == 0 &&
          session_ada_object(x.b)->row == 2);
    /* a new scene load clears the object */
    CHECK(session_ada_begin_scene(x.b, x.scene) == BUL_OK && session_ada_object(x.b)->row == -1 && x.f.n_relslot == 2);
    bind_close(&x);
}

static void t_binding_without_hooks_and_args(void)
{
    Bind x;
    uint32_t pa = 99;
    int done = 7;
    BulPointerResult pr;
    BulClickResult cr;
    BulRenderResult r;
    SceneActionRuntimeState st;
    SceneActionHandlerResult out;
    SceneActionInfo info;
    CHECK(bind_open(&x, 0));
    CHECK(session_ada_begin_scene(x.b, x.scene) == BUL_OK);
    CHECK(b_visit(&x, 1, 0u, &pa, &done) == SCENE_ACTION_HANDLER_OK && pa == 1u && g_stores == 0);
    CHECK(session_ada_create(NULL) == NULL);
    session_ada_destroy(NULL);
    CHECK(session_ada_begin_scene(NULL, x.scene) == BUL_ERR_ARGUMENT && session_ada_begin_scene(x.b, NULL) == BUL_ERR_ARGUMENT);
    CHECK(session_ada_pointer_move(NULL, 0, 0, &pr) == BUL_ERR_ARGUMENT && session_ada_pointer_move(x.b, 0, 0, NULL) == BUL_ERR_ARGUMENT);
    CHECK(session_ada_click(NULL, 1u, 0, &cr) == BUL_ERR_ARGUMENT && session_ada_click(x.b, 1u, 0, NULL) == BUL_ERR_ARGUMENT);
    CHECK(session_ada_render(NULL, &r) == BUL_ERR_ARGUMENT && session_ada_render(x.b, NULL) == BUL_ERR_ARGUMENT);
    CHECK(session_ada_invalidate(NULL) == BUL_ERR_ARGUMENT);
    CHECK(session_ada_object(NULL) == NULL && session_ada_world(NULL) == NULL && session_ada_registered(NULL) == 0u);
    CHECK(strcmp(session_ada_failure(NULL), "0xda-binding-unbound") == 0);
    CHECK(scene_resource_action_at(x.scene, 1, &info) == SCENE_RESOURCE_OK);
    memset(&st, 0, sizeof st);
    CHECK(session_ada_handler(NULL, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_ada_handler(x.b, 1, NULL, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_ada_handler(x.b, 1, &info, NULL, &out) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_ada_handler(x.b, 1, &info, &st, NULL) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(session_ada_handler(x.b, 7, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
    bind_close(&x);
}

static void t_binding_refuses_bad_body(void)
{
    Bind x;
    uint8_t bytes[2 * (BUL_BODY_BYTES + 128)];
    uint8_t bad[BUL_BODY_BYTES];
    SceneResource *two;
    char err[128] = {0};
    const int types[1] = {0xda};
    const uint8_t *bodies[1];
    size_t lengths[1] = {BUL_BODY_BYTES};
    size_t n;
    CHECK(bind_open(&x, 0));
    memcpy(bad, x.body_a, sizeof bad);
    memset(bad, 'A', NAME_BYTES);
    bodies[0] = bad;
    n = build_scene(bytes, 1, types, bodies, lengths);
    two = scene_resource_open_memory(bytes, n, err, sizeof err);
    CHECK(two != NULL);
    if (two != NULL) {
        CHECK(session_ada_begin_scene(x.b, x.scene) == BUL_OK);
        CHECK(session_ada_begin_scene(x.b, two) == BUL_ERR_BODY && strcmp(session_ada_failure(x.b), "0xda-name-unterminated") == 0);
        /* the earlier scene is still loaded */
        {
            uint32_t pa;
            int done;
            CHECK(b_visit(&x, 1, 0u, &pa, &done) == SCENE_ACTION_HANDLER_OK);
        }
        scene_resource_close(two);
    }
    bind_close(&x);
}

static void t_binding_host_error(void)
{
    Bind x;
    uint32_t pa = 99;
    int done = 7;
    CHECK(bind_open(&x, 1));
    CHECK(session_ada_begin_scene(x.b, x.scene) == BUL_OK);
    x.f.calls = 0;
    x.f.fail_call = 1; /* the slot allocation */
    CHECK(b_visit(&x, 1, 0u, &pa, &done) == SCENE_ACTION_HANDLER_ERROR && strcmp(session_ada_failure(x.b), "0xda-host") == 0);
    CHECK(g_stores == 0);
    x.f.fail_call = 0;
    /* a failing scene clear is reported by begin_scene (the object owns a slot after a successful phase 0) */
    CHECK(session_ada_object(x.b)->slot == -1);
    ((BulObject *)session_ada_object(x.b))->slot = 5;
    x.f.calls = 0;
    x.f.fail_call = 1;
    CHECK(session_ada_begin_scene(x.b, x.scene) == BUL_ERR_HOST && strcmp(session_ada_failure(x.b), "0xda-scene-clear") == 0);
    x.f.fail_call = 0;
    ((BulObject *)session_ada_object(x.b))->slot = -1;
    bind_close(&x);
}

static void t_binding_empty_scene(void)
{
    Bind x;
    uint8_t other[256];
    char err[128] = {0};
    size_t n;
    SceneResource *empty;
    SceneActionInfo info;
    SceneActionRuntimeState st;
    SceneActionHandlerResult out;
    CHECK(bind_open(&x, 0));
    n = build_scene(other, 0, NULL, NULL, NULL);
    empty = scene_resource_open_memory(other, n, err, sizeof err);
    CHECK(empty != NULL);
    if (empty != NULL) {
        CHECK(session_ada_begin_scene(x.b, empty) == BUL_OK && strcmp(session_ada_failure(x.b), "none") == 0);
        scene_resource_close(empty);
    }
    CHECK(session_ada_begin_scene(x.b, x.scene) == BUL_OK);
    memset(&st, 0, sizeof st);
    CHECK(scene_resource_action_at(x.scene, 1, &info) == SCENE_RESOURCE_OK);
    CHECK(session_ada_handler(x.b, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_OK);
    /* an object whose row has no copy in the binding cannot be rendered or pointed at */
    ((BulObject *)session_ada_object(x.b))->row = 9;
    CHECK(session_ada_pointer_move(x.b, 120, 215, (BulPointerResult[1]){{0}}) == BUL_ERR_ARGUMENT);
    {
        BulRenderResult r;
        BulClickResult c;
        CHECK(session_ada_render(x.b, &r) == BUL_ERR_ARGUMENT);
        CHECK(session_ada_click(x.b, 1u, BUL_CANDIDATE_BUTTON, &c) == BUL_ERR_ARGUMENT);
    }
    ((BulObject *)session_ada_object(x.b))->row = 0; /* row 0 is another type: no copy */
    {
        BulRenderResult r;
        CHECK(session_ada_render(x.b, &r) == BUL_ERR_ARGUMENT);
    }
    ((BulObject *)session_ada_object(x.b))->row = 1;
    bind_close(&x);
}

/* ---- cases added by the RT-59 mutation sweep (each pins a boundary or an output the first 28 cases left open) --------------- */

static int h_alloc_zero(void *c, int16_t *slot)
{
    (void)c;
    *slot = 0;
    return 0;
}

static void t_sweep_boundaries(void)
{
    Fx f;
    BulPointerResult p;
    BulRenderResult r;
    const char *why = "x";
    /* _rand = 32767 is a legal draw (the coin of the computer's decision on mode 3) */
    fx_init(&f);
    start_game(&f);
    f.o.mode = 3;
    f.body[O_SMART] = 0;
    rand_set(&f, 1, 32767);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(f.o.button_kind == 1 && f.o.anim_active == 1);
    /* generic z entry 0 is a valid slot (only a negative slot is refused) */
    fx_init(&f);
    f.host.alloc_slot = h_alloc_zero;
    CHECK_INT(step(&f, 0), BUL_OK);
    CHECK_INT(f.o.slot, 0);
    /* a body with no NUL in the bytes that follow the sound records and the name lists still validates */
    fx_init(&f);
    memset(f.body + 0x591, 'A', 0x21);
    f.body[0x5b2] = 0;
    memset(f.body + 0x86d, 'A', 0x21); /* name 22 of entry 0 (the first bytes of entry 1); entry 1's own name 0 ends at 0x88e */
    f.body[0x88e] = 0;
    memset(f.body + 0xb4b, 'A', 0x21);
    CHECK(bul_validate_body(f.body, BUL_BODY_BYTES, &why) == BUL_OK && why == NULL);
    /* a name that only starts like "NO SOUND" is a real sound name (nine bytes are compared) */
    fx_init(&f);
    set_str(f.body, O_SSTEP, "NO SOUND2");
    CHECK_INT(step(&f, 0), BUL_OK);
    CHECK(f.n_prep >= 1 && f.prep_hist[0] == O_SSTEP);
    /* the observer is optional */
    fx_init(&f);
    f.host.observe = NULL;
    CHECK_INT(step(&f, 0), BUL_OK);
    CHECK_INT(step(&f, 1), BUL_OK);
    /* failure texts: cleared on success, set for a bad argument, absent without a failure pointer */
    fx_init(&f);
    why = "x";
    CHECK(bul_step(&f.o, f.body, BUL_BODY_BYTES, ROW, 0, &f.w, &f.host, &f.result, &why) == BUL_OK && why == NULL);
    CHECK(bul_step(NULL, f.body, BUL_BODY_BYTES, ROW, 0, &f.w, &f.host, &f.result, &why) == BUL_ERR_ARGUMENT &&
          strcmp(why, "0xda-argument") == 0);
    CHECK(bul_step(NULL, f.body, BUL_BODY_BYTES, ROW, 0, &f.w, &f.host, &f.result, NULL) == BUL_ERR_ARGUMENT);
    CHECK(bul_step(&f.o, f.body, BUL_BODY_BYTES, ROW, 1, &f.w, &f.host, &f.result, NULL) == BUL_OK);
    /* a stuck name pick draws exactly BUL_PICK_LIMIT times (the log would be quadratic: no observer) */
    fx_init(&f);
    start_game(&f);
    f.host.observe = NULL;
    for (int i = 2; i < 6; ++i) set_str(f.body, cap_name(0, i), "REAL");
    set_nosound(f.body, cap_name(0, 2));
    f.o.state = BUL_STATE_CAPTION_PICK;
    f.o.mode = 0;
    f.rand_default = 0;
    f.i_rand = 0;
    CHECK_INT(step(&f, 1), BUL_ERR_STUCK);
    CHECK_INT(f.i_rand, BUL_PICK_LIMIT);
    CHECK(strcmp(f.failure, "0xda-name-pick-stuck") == 0);
    /* the second player's roll caption draws from four names (a draw of 4 wraps to the first one) */
    fx_init(&f);
    start_game(&f);
    f.o.state = BUL_STATE_CAPTION_PICK;
    f.o.mode = 2;
    set_str(f.body, cap_name(1, 6), "WRONG");
    rand_set(&f, 1, 4);
    CHECK_INT(step(&f, 1), BUL_OK);
    CHECK(strcmp(f.prepared_caption, "C1_2") == 0);
    /* the smart computer on mode 3: equal positions roll; one position behind with 7 positions passes (-1 + 7 > 5); 5 is not > 5 */
    {
        const int cases[][4] = {{3, 3, 8, 0}, {7, 6, 7, 1}, {7, 5, 7, 0}, {7, 4, 7, 0}};
        for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
            fx_init(&f);
            start_game(&f);
            put16(f.body, O_M, cases[i][2]);
            f.body[O_SMART] = 1;
            f.o.mode = 3;
            f.o.pos_player = (int16_t)cases[i][0];
            f.o.pos_computer = (int16_t)cases[i][1];
            CHECK_INT(step(&f, 1), BUL_OK);
            CHECK(f.o.anim_active == 1 && f.o.button_kind == cases[i][3]);
        }
    }
    /* pointer: the bottom edges of button 2 and of the finish rectangle are inclusive */
    fx_init(&f);
    start_game(&f);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 320, 230, &p) == BUL_OK && p.hit == 1 && p.button == 2);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 320, 231, &p) == BUL_OK && p.hit == 0);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 420, 430, &p) == BUL_OK && p.hit == 1 && p.candidate == BUL_CANDIDATE_FINISH);
    CHECK(bul_pointer(&f.o, f.body, BUL_BODY_BYTES, 420, 431, &p) == BUL_OK && p.hit == 0);
    /* render: the second roll set and the enabled pass button (modes 1 and 3), a coordinate with a high byte */
    fx_init(&f);
    start_game(&f);
    put_rect(f.body, O_ROLLA, 0x01020304, 0x05060708, 0x090a0b0c, 0x0d0e0f10);
    f.o.mode = 1;
    f.o.light = 0;
    CHECK(render(&f, &r) == BUL_OK && r.valid == 1);
    CHECK_INT(r.blit[0].dst.left, 0x01020304 + VIEW_X);
    CHECK_INT(r.blit[0].dst.top, 0x05060708 + VIEW_Y);
    for (int i = 0; i < 4; ++i) {
        CHECK_INT(r.blit[4 + i].kind, BUL_BLIT_ROLL_B);
        CHECK_RECT(r.blit[4 + i].dst, RCV(O_ROLLB + 16 * i));
        CHECK_RECT(r.blit[4 + i].src, RC(O_WORK + 0x20 * i));
    }
    {
        int found = -1;
        for (uint16_t i = 0; i < r.count; ++i) {
            if (r.blit[i].kind == BUL_BLIT_PASS_ENABLED) found = i;
        }
        CHECK(found >= 0);
        if (found >= 0) {
            CHECK(r.blit[found].backdrop == 1);
            CHECK_RECT(r.blit[found].src, RB(1));
            CHECK_RECT(r.blit[found].dst, RBV(1));
        }
    }
}

static void t_sweep_failures(void)
{
    Fx f;
    int cleanup_failure_seen = 0;
    /* a host failure while the finish releases the puzzle reports the host reason (the completion was already issued) */
    for (int n = 1; n <= 14; ++n) {
        fx_init(&f);
        phase2_setup(&f);
        f.calls = 0;
        f.fail_call = n;
        if (step(&f, 2) == BUL_ERR_HOST && f.result.completed == 1u) {
            CHECK(strcmp(f.failure, "0xda-host") == 0);
            cleanup_failure_seen = 1;
        }
    }
    CHECK(cleanup_failure_seen);
}

static void t_sweep_binding(void)
{
    Bind x;
    uint32_t pa = 99;
    int done = 7;
    BulPointerResult pr;
    BulClickResult cr;
    BulRenderResult r;
    SceneActionInfo info;
    SceneActionRuntimeState st;
    SceneActionHandlerResult out;
    CHECK(bind_open(&x, 1));
    CHECK(session_ada_begin_scene(x.b, x.scene) == BUL_OK);
    CHECK(b_visit(&x, 1, 0u, &pa, &done) == SCENE_ACTION_HANDLER_OK);
    CHECK(b_visit(&x, 1, 1u, &pa, &done) == SCENE_ACTION_HANDLER_OK);
    CHECK(session_ada_pointer_move(x.b, 120, 215, &pr) == BUL_OK && pr.hit == 1);
    x.f.now = 5000;
    CHECK(session_ada_click(x.b, 1u, BUL_CANDIDATE_BUTTON, &cr) == BUL_OK && strcmp(session_ada_failure(x.b), "none") == 0);
    /* a click the kernel refuses names its reason; a render the host refuses too */
    ((BulObject *)session_ada_object(x.b))->anim_active = 0;
    ((BulObject *)session_ada_object(x.b))->pending_button = 5;
    CHECK(session_ada_click(x.b, 1u, BUL_CANDIDATE_BUTTON, &cr) == BUL_ERR_UNSUPPORTED &&
          strcmp(session_ada_failure(x.b), "0xda-click") == 0);
    x.f.calls = 0;
    x.f.fail_call = 1;
    CHECK(session_ada_render(x.b, &r) == BUL_ERR_HOST && strcmp(session_ada_failure(x.b), "0xda-render") == 0);
    x.f.fail_call = 0;
    /* a handler index one past the rows is refused, and so is a row index equal to the row count */
    CHECK(scene_resource_action_at(x.scene, 1, &info) == SCENE_RESOURCE_OK);
    memset(&st, 0, sizeof st);
    CHECK(session_ada_handler(x.b, 3, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
    ((BulObject *)session_ada_object(x.b))->row = 3;
    CHECK(session_ada_render(x.b, &r) == BUL_ERR_ARGUMENT);
    ((BulObject *)session_ada_object(x.b))->row = -1;
    CHECK(session_ada_render(x.b, &r) == BUL_ERR_ARGUMENT);
    ((BulObject *)session_ada_object(x.b))->row = 1;
    bind_close(&x);
    /* a puzzle row that is the first row of the scene */
    {
        const int types[2] = {0xda, 0x70};
        const uint8_t one = 0;
        const uint8_t *bodies[2];
        size_t lengths[2] = {BUL_BODY_BYTES, 1};
        uint8_t bytes[2 * (BUL_BODY_BYTES + 128) + 512], body[BUL_BODY_BYTES];
        char err[128] = {0};
        SessionAdaHost host;
        SessionAdaBinding *b;
        SceneResource *scene;
        size_t n_bytes;
        fx_init(&x.f);
        body_default(body);
        bodies[0] = body;
        bodies[1] = &one;
        n_bytes = build_scene(bytes, 2, types, bodies, lengths);
        scene = scene_resource_open_memory(bytes, n_bytes, err, sizeof err);
        CHECK(scene != NULL);
        memset(&host, 0, sizeof host);
        host.kernel = x.f.host;
        host.kernel.context = &x.f;
        b = session_ada_create(&host);
        CHECK(b != NULL);
        if (scene != NULL && b != NULL) {
            SceneActionInfo row0;
            CHECK(session_ada_begin_scene(b, scene) == BUL_OK);
            CHECK(scene_resource_action_at(scene, 0, &row0) == SCENE_RESOURCE_OK);
            memset(&st, 0, sizeof st);
            CHECK(session_ada_handler(b, 0, &row0, &st, &out) == SCENE_ACTION_HANDLER_OK && out.phase == 1u);
            CHECK(session_ada_object(b)->row == 0);
            CHECK(session_ada_pointer_move(b, 120, 215, &pr) == BUL_OK && pr.hit == 1);
            CHECK(session_ada_render(b, &r) == BUL_OK && r.valid == 1);
        }
        session_ada_destroy(b);
        scene_resource_close(scene);
    }
}

/* ---- main ---------------------------------------------------------------------------------------------------------------- */
int main(void)
{
    run("validate_body", t_validate);
    run("object_reset_and_cleanup", t_reset);
    run("phase0", t_phase0);
    run("phase0_variants", t_phase0_variants);
    run("caption_pick", t_caption_pick);
    run("caption_text", t_caption_text);
    run("pointer", t_pointer);
    run("click", t_click);
    run("idle_state", t_idle);
    run("button_end_and_caption_states", t_idle_button_end);
    run("pick_moves", t_pick_moves);
    run("moving", t_moving);
    run("move_end_and_step_check", t_move_end);
    run("score_state", t_score_state);
    run("end_states", t_end_states);
    run("phase2", t_phase2);
    run("step_edges", t_step_edges);
    run("render_start", t_render_start);
    run("render_states", t_render_states);
    run("invalidate", t_invalidate);
    run("full_round", t_full_round);
    run("host_failure_sweep", t_host_failure_sweep);
    run("fuzz", t_fuzz);
    run("binding_flow", t_binding_flow);
    run("binding_without_hooks_and_args", t_binding_without_hooks_and_args);
    run("binding_refuses_bad_body", t_binding_refuses_bad_body);
    run("binding_host_error", t_binding_host_error);
    run("binding_empty_scene", t_binding_empty_scene);
    run("sweep_boundaries", t_sweep_boundaries);
    run("sweep_failures", t_sweep_failures);
    run("sweep_binding", t_sweep_binding);
    printf("TOTAL %d FAILED %d\n", g_total, g_failures);
    return g_failures;
}
