/* RT-58 unit tests of the raw 0x76 PASSWORD puzzle kernel (src/action_family_76_runtime.c) and the session binding
 * (src/session_bindings_a76.c). Prints "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure count. Fixtures are
 * synthetic bodies (no original bytes). The Python wrapper tests/test_action_family_76_runtime.py builds and runs this with and
 * without ASan/UBSan and under source mutations. Expected values are written out from the layout in
 * src/action_family_76_runtime.h (and the facts quoted in the packet), not by calling the kernel; effect-log goldens were derived
 * by hand from the header and pinned. The comparison with the original x86 code is the oracle's job (RT-58 worker B). */
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_76_runtime.h"
#include "scene_resource.h"
#include "session_bindings_a76.h"

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
    O_FONT = 0x000, O_BLINK = 0x002, O_RF1 = 0x004, O_RF2 = 0x014, O_RBG = 0x024, O_CA = 0x034, O_WA = 0x036, O_CB = 0x0db,
    O_WB = 0x0dd, O_OK = 0x182, O_OKSND = 0x19b, O_OKCH = 0x1bc, O_BAD = 0x1cc, O_BADSND = 0x1e5, O_BADCH = 0x206,
    O_CANCEL = 0x216, O_CRECT = 0x22f
};
enum { SB_SCENE = 0, SB_W1 = 2, SB_W2 = 4, SB_W3 = 6, SB_D1 = 8, SB_D2 = 12, SB_D3 = 16, SB_START = 20, SB_FLAG = 22, SB_VALUE = 24 };
#define ROW 3
#define VIEW_X 7
#define VIEW_Y 11
#define CANDIDATE 0x2724

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
static void set_block(uint8_t *b, size_t off, int scene, int w1, int w2, int w3, int32_t d1, int32_t d2, int32_t d3, int start,
                      int flag, int value)
{
    put16(b, off + SB_SCENE, scene);
    put16(b, off + SB_W1, w1);
    put16(b, off + SB_W2, w2);
    put16(b, off + SB_W3, w3);
    put32(b, off + SB_D1, d1);
    put32(b, off + SB_D2, d2);
    put32(b, off + SB_D3, d3);
    put16(b, off + SB_START, start);
    put16(b, off + SB_FLAG, flag);
    b[off + SB_VALUE] = (uint8_t)value;
}

/* The fixture body: font 3, blink 500, field 1 (10,20)-(210,40), field 2 (10,50)-(210,70), background (0,0)-(100,90); field 1
 * accepts "ALPHA" and "beta"; field 2 is off (count 0) with the words "ZZZ", "QQQ" stored behind the count; correct block scene 11,
 * start word 0, event flag 5 value 7; wrong block scene 22, start word 1, no flag; cancel block scene 33, start word 2, flag 9,
 * value 200; success sound "WIN" on channel 4, wrong sound "BUZZ" on channel 6; cancel strip (300,200)-(340,230). */
static void make_body(uint8_t *b)
{
    memset(b, 0, PWD_BODY_BYTES);
    put16(b, O_FONT, 3);
    put16(b, O_BLINK, 500);
    put_rect(b, O_RF1, 10, 20, 210, 40);
    put_rect(b, O_RF2, 10, 50, 210, 70);
    put_rect(b, O_RBG, 0, 0, 100, 90);
    put16(b, O_CA, 2);
    set_str(b, O_WA, "ALPHA");
    set_str(b, O_WA + 0x21, "beta");
    put16(b, O_CB, 0);
    set_str(b, O_WB, "ZZZ");
    set_str(b, O_WB + 0x21, "QQQ");
    set_block(b, O_OK, 11, 1, 2, 3, 4, 5, 6, 0, 5, 7);
    set_str(b, O_OKSND, "WIN");
    put16(b, O_OKCH, 4);
    set_block(b, O_BAD, 22, 9, 8, 7, 10, 11, 12, 1, -1, 0);
    set_str(b, O_BADSND, "BUZZ");
    put16(b, O_BADCH, 6);
    set_block(b, O_CANCEL, 33, 13, 14, 15, 16, 17, 18, 2, 9, 200);
    put_rect(b, O_CRECT, 300, 200, 340, 230);
}

typedef struct Fx {
    PwdHost host;
    uint8_t body[PWD_BODY_BYTES];
    PwdState st;
    char log[4096];
    uint32_t now, step;
    int32_t vx, vy;
    int32_t busy_seq[8];
    int busy_n, busy_i;
    int fail_at, calls;
    int invalid_flag;
    int observe_on;
    int width_per_char;
    uint32_t phase;
    int rc;
    PwdResult res;
    const char *why;
    PwdTransition trans;
    int n_trans, n_store, hook_bad;
    int16_t store_index;
    uint32_t store_value;
    int32_t prep_offset, stop_offset;
    int16_t width_font, play_ch, busy_ch, acq_font, rel_font;
} Fx;

#define FAILABLE(f) (++(f)->calls == (f)->fail_at)

static int cb_view(void *c, int32_t *x, int32_t *y)
{
    Fx *f = (Fx *)c;
    if (FAILABLE(f)) return 1;
    *x = f->vx;
    *y = f->vy;
    return 0;
}
static int cb_acquire(void *c, int16_t font) { Fx *f = (Fx *)c; f->acq_font = font; return FAILABLE(f) ? 1 : 0; }
static int cb_release(void *c, int16_t font) { Fx *f = (Fx *)c; f->rel_font = font; return FAILABLE(f) ? 1 : 0; }
static int cb_width(void *c, int16_t font, const char *text, int16_t *w)
{
    Fx *f = (Fx *)c;
    f->width_font = font;
    if (FAILABLE(f)) return 1;
    *w = (int16_t)(strlen(text) * (size_t)f->width_per_char);
    return 0;
}
static uint32_t cb_tick(void *c)
{
    Fx *f = (Fx *)c;
    const uint32_t t = f->now;
    f->now += f->step;
    return t;
}
static int cb_prepare(void *c, const uint8_t *r) { Fx *f = (Fx *)c; f->prep_offset = (int32_t)(r - f->body); return FAILABLE(f) ? 1 : 0; }
static int cb_stop(void *c, const uint8_t *r) { Fx *f = (Fx *)c; f->stop_offset = (int32_t)(r - f->body); return FAILABLE(f) ? 1 : 0; }
static int cb_play(void *c, int16_t ch) { Fx *f = (Fx *)c; f->play_ch = ch; return FAILABLE(f) ? 1 : 0; }
static int cb_busy(void *c, int16_t ch, int32_t *res)
{
    Fx *f = (Fx *)c;
    f->busy_ch = ch;
    if (FAILABLE(f)) return 1;
    *res = f->busy_i < f->busy_n ? f->busy_seq[f->busy_i++] : 0;
    return 0;
}
static int cb_invalid(void *c, int16_t index) { return index == ((Fx *)c)->invalid_flag; }
static int cb_transition(void *c, const PwdTransition *t)
{
    Fx *f = (Fx *)c;
    if (FAILABLE(f)) return 1;
    f->trans = *t;
    ++f->n_trans;
    return 0;
}
static int cb_store(void *c, int16_t index, uint32_t value)
{
    Fx *f = (Fx *)c;
    if (FAILABLE(f)) return 1;
    f->store_index = index;
    f->store_value = value;
    ++f->n_store;
    return 0;
}
static void cb_observe(void *c, int effect, int32_t a, int32_t b)
{
    Fx *f = (Fx *)c;
    size_t n = strlen(f->log);
    if (f->observe_on) snprintf(f->log + n, sizeof f->log - n, "%d(%d,%d) ", effect, a, b);
}

static void fx_init(Fx *f)
{
    memset(f, 0, sizeof *f);
    make_body(f->body);
    pwd_state_reset(&f->st);
    f->now = 1000;
    f->vx = VIEW_X;
    f->vy = VIEW_Y;
    f->invalid_flag = -2;
    f->observe_on = 1;
    f->width_per_char = 8;
    f->host.context = f;
    f->host.view_origin = cb_view;
    f->host.font_acquire = cb_acquire;
    f->host.font_release = cb_release;
    f->host.text_width = cb_width;
    f->host.tick = cb_tick;
    f->host.sound_prepare = cb_prepare;
    f->host.sound_stop = cb_stop;
    f->host.sound_play = cb_play;
    f->host.sound_busy = cb_busy;
    f->host.event_flag_invalid = cb_invalid;
    f->host.transition = cb_transition;
    f->host.store_event_flag = cb_store;
    f->host.observe = cb_observe;
}

/* One visit with the current phase; the phase advances on success. The log is cleared first. */
static int visit(Fx *f)
{
    f->log[0] = '\0';
    f->why = NULL;
    f->rc = pwd_step(&f->st, f->body, PWD_BODY_BYTES, ROW, f->phase, &f->host, &f->res, &f->why);
    if (f->rc == PWD_OK) f->phase = f->res.phase_after;
    return f->rc;
}
static int visit_phase(Fx *f, uint32_t phase)
{
    f->phase = phase;
    return visit(f);
}
/* phase 0 and the phase it leaves */
static void start(Fx *f)
{
    f->phase = 0;
    (void)visit(f);
}
static int type_char(Fx *f, int8_t ch)
{
    (void)pwd_key(&f->st, ch);
    return visit(f);
}
static void type_str(Fx *f, const char *s)
{
    for (; *s != '\0'; ++s) (void)type_char(f, (int8_t)*s);
}
static const char *field1(const Fx *f) { return (const char *)f->st.b + PWD_S_FIELD1; }
static const char *field2(const Fx *f) { return (const char *)f->st.b + PWD_S_FIELD2; }
static uint32_t st32(const Fx *f, size_t off) { return (uint32_t)pwd_rd32(f->st.b, off); }
static int state_of(const Fx *f) { return (int)st32(f, PWD_S_STATE); }

/* ---- the body check ---------------------------------------------------------------------------------------------------------- */

static void t_validate(void)
{
    uint8_t big[PWD_BODY_BYTES + 64];
    const char *why = "unset";
    make_body(big);
    memset(big + PWD_BODY_BYTES, 0, 64);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, &why) == PWD_OK && why == NULL);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_OK);
    CHECK(pwd_validate_body(NULL, PWD_BODY_BYTES, &why) == PWD_ERR_BODY && why != NULL);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES - 1u, &why) == PWD_ERR_BODY && why != NULL);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES + 1u, &why) == PWD_ERR_BODY);
    CHECK(pwd_validate_body(big, 0u, NULL) == PWD_ERR_BODY);
    make_body(big);
    put16(big, O_FONT, 17);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_OK);
    put16(big, O_FONT, 18);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_ERR_BODY);
    put16(big, O_FONT, -1);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_ERR_BODY);
    put16(big, O_FONT, 0);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_OK);
    make_body(big);
    put16(big, O_CA, 5);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_OK);
    put16(big, O_CA, 6);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_ERR_BODY);
    put16(big, O_CA, -1);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_ERR_BODY);
    make_body(big);
    put16(big, O_CB, 5);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_OK);
    put16(big, O_CB, 6);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_ERR_BODY);
    put16(big, O_CB, -1);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_ERR_BODY);
    /* a word of 32 characters is terminated by the 33rd byte */
    make_body(big);
    memset(big + O_WA, 'X', 0x20);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_OK);
    put16(big, O_CB, 1);
    memset(big + O_WB, 'X', 0x20);
    big[O_WB + 0x20] = 0;
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_OK);
    /* unterminated sound names and accepted words */
    make_body(big);
    memset(big + O_OKSND, 'X', 0x21);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, &why) == PWD_ERR_BODY && why != NULL);
    make_body(big);
    memset(big + O_BADSND, 'X', 0x21);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_ERR_BODY);
    make_body(big);
    memset(big + O_OKSND, 'X', 0x20);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_OK); /* the 0x21st byte is the NUL */
    make_body(big);
    memset(big + O_WA + 0x21, 'X', 0x21);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_ERR_BODY); /* word 1 of field 1, count 2 */
    put16(big, O_CA, 1);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_OK);       /* behind the count: not looked at */
    make_body(big);
    memset(big + O_WA, 'X', 0x21);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_ERR_BODY);
    make_body(big);
    memset(big + O_WB, 'X', 0x21);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_OK);       /* count B is 0 */
    put16(big, O_CB, 1);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_ERR_BODY);
    make_body(big);
    memset(big + O_WB + 0x21, 'X', 0x21);
    put16(big, O_CB, 2);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_ERR_BODY);
    put16(big, O_CB, 1);
    CHECK(pwd_validate_body(big, PWD_BODY_BYTES, NULL) == PWD_OK);
}

static void t_filter(void)
{
    /* The accepted set: letters, digits, " \b\r.,?!/$()&:;+%=-" and the accented letters of the Latin-1 / CP-1252 bytes below. */
    static const uint8_t high[] = {0xe0, 0xe7, 0xe8, 0xe9, 0xea, 0xeb, 0xf4, 0xc0, 0xe2, 0xee, 0xf9, 0xc4, 0xe4, 0xd6, 0xf6, 0xdc,
                                   0xfc, 0xa1, 0xbf, 0xd1, 0xf1, 0xc9, 0xe1, 0xed, 0xf3, 0xfa, 0xdf};
    int accepted = 0;
    for (int i = 0; i < 256; ++i) {
        int expect = (i >= 'A' && i <= 'Z') || (i >= 'a' && i <= 'z') || (i >= '0' && i <= '9') || (i != 0 && strchr("\b\r .,?!/$()&:;+%=-", i) != NULL);
        for (size_t k = 0; k < sizeof high; ++k) expect |= i == high[k];
        if (pwd_char_accepted((int8_t)i) != expect && !g_failed) {
            g_failed = 1;
            snprintf(g_msg, sizeof g_msg, "byte 0x%02x: accepted %d, expected %d", i, pwd_char_accepted((int8_t)i), expect);
        }
        accepted += expect;
    }
    CHECK_INT(accepted, 62 + 18 + (int)sizeof high);
    {
        PwdState s;
        pwd_state_reset(&s);
        CHECK(pwd_key(&s, 'a') == 0 && s.b[PWD_S_KEY_PENDING] == 0);           /* inactive */
        s.b[PWD_S_ACTIVE] = 1;
        CHECK(pwd_key(&s, '#') == 0 && s.b[PWD_S_KEY_PENDING] == 0);           /* refused by the filter */
        CHECK(pwd_key(&s, 'a') == 1 && s.b[PWD_S_KEY_PENDING] == 1 && s.b[PWD_S_KEY] == 'a');
        CHECK(pwd_key(&s, 'b') == 0 && s.b[PWD_S_KEY] == 'a');                 /* a key is pending: the next one is dropped */
        s.b[PWD_S_KEY_PENDING] = 0;
        CHECK(pwd_key(&s, (int8_t)0xe9) == 1 && s.b[PWD_S_KEY] == 0xe9);
        CHECK(pwd_key(NULL, 'a') == 0);
    }
}

/* ---- phase 0 ------------------------------------------------------------------------------------------------------------------ */

static void t_phase0(void)
{
    Fx f;
    fx_init(&f);
    f.phase = 0;
    CHECK(visit(&f) == PWD_OK && f.why == NULL);
    CHECK_LOG(&f, "1(1,0) 2(3,0) 4(1,0) 5(1000,0) 6(1,0) ");
    CHECK(f.acq_font == 3);
    CHECK(f.res.phase_after == 1 && f.res.initialized == 1 && f.res.completed == 0);
    CHECK(f.st.b[PWD_S_ACTIVE] == 1 && f.st.b[PWD_S_CORRECT] == 0 && f.st.b[PWD_S_WRONG] == 0 && f.st.b[PWD_S_CANCEL] == 0);
    CHECK(f.st.b[PWD_S_KEY_PENDING] == 0);
    CHECK(pwd_rd16(f.st.b, PWD_S_ROW) == ROW);
    CHECK(field1(&f)[0] == 0 && field2(&f)[0] == 0);
    CHECK_INT(state_of(&f), 0);
    CHECK_INT(st32(&f, PWD_S_BLINK), 0);
    CHECK_INT(st32(&f, PWD_S_DEADLINE), 1500);
    {
        /* rectangles: background, field 1, field 2, each corner shifted by the view origin (x even words, y odd words) */
        static const int32_t expect[12] = {0 + VIEW_X, 0 + VIEW_Y, 100 + VIEW_X, 90 + VIEW_Y, 10 + VIEW_X, 20 + VIEW_Y,
                                           210 + VIEW_X, 40 + VIEW_Y, 10 + VIEW_X, 50 + VIEW_Y, 210 + VIEW_X, 70 + VIEW_Y};
        for (int i = 0; i < 12; ++i) CHECK_INT(pwd_rd32(f.st.b, PWD_S_RECT_BG + 4u * (unsigned)i), expect[i]);
    }
    /* stale text and a stale key from an earlier run are cleared; the blink period is a signed word; the clock wraps */
    fx_init(&f);
    f.st.b[PWD_S_KEY_PENDING] = 1;
    f.st.b[PWD_S_CANCEL] = 1;
    f.st.b[PWD_S_WRONG] = 1;
    f.st.b[PWD_S_CORRECT] = 1;
    memset(f.st.b + PWD_S_FIELD1, 'x', 0x21);
    memset(f.st.b + PWD_S_FIELD2, 'y', 0x21);
    put16(f.body, O_BLINK, -5);
    f.now = 100;
    start(&f);
    CHECK(f.rc == PWD_OK && f.st.b[PWD_S_KEY_PENDING] == 0 && f.st.b[PWD_S_CANCEL] == 0 && f.st.b[PWD_S_WRONG] == 0 &&
          f.st.b[PWD_S_CORRECT] == 0);
    for (int i = 0; i < 0x21; ++i) CHECK(f.st.b[PWD_S_FIELD1 + i] == 0 && f.st.b[PWD_S_FIELD2 + i] == 0);
    CHECK_INT(st32(&f, PWD_S_DEADLINE), 95);
    fx_init(&f);
    f.now = 0xffffff00u;
    start(&f);
    CHECK_INT(st32(&f, PWD_S_DEADLINE), 0xf4);
    fx_init(&f);
    put16(f.body, O_BLINK, 0);
    start(&f);
    CHECK_INT(st32(&f, PWD_S_DEADLINE), 1000);
    /* the inner state and the blink phase restart; the row is a full word */
    fx_init(&f);
    put32(f.st.b, PWD_S_STATE, 3);
    put32(f.st.b, PWD_S_BLINK, 1);
    start(&f);
    CHECK_INT(state_of(&f), 0);
    CHECK_INT(st32(&f, PWD_S_BLINK), 0);
    fx_init(&f);
    CHECK(pwd_step(&f.st, f.body, PWD_BODY_BYTES, 0x0103, 0u, &f.host, &f.res, &f.why) == PWD_OK);
    CHECK(pwd_rd16(f.st.b, PWD_S_ROW) == 0x0103);
    CHECK(pwd_step(&f.st, f.body, PWD_BODY_BYTES, 0x0103, 1u, &f.host, &f.res, &f.why) == PWD_OK);
    CHECK(pwd_step(&f.st, f.body, PWD_BODY_BYTES, 0x0003, 1u, &f.host, &f.res, &f.why) == PWD_ERR_UNSUPPORTED);
    /* the view origin may be negative */
    fx_init(&f);
    f.vx = -3;
    f.vy = -4;
    start(&f);
    CHECK_INT(pwd_rd32(f.st.b, PWD_S_RECT_BG), -3);
    CHECK_INT(pwd_rd32(f.st.b, PWD_S_RECT_BG + 4), -4);
    CHECK_INT(pwd_rd32(f.st.b, PWD_S_RECT_F2 + 12), 66);
}

/* ---- typing, cursor, backspace, limits ----------------------------------------------------------------------------------------- */

static void t_typing_and_cursor(void)
{
    Fx f;
    fx_init(&f);
    start(&f);
    f.step = 0;
    /* an idle visit shows the cursor in an empty field: the '-' */
    CHECK(visit(&f) == PWD_OK);
    CHECK(strcmp(field1(&f), "-") == 0);
    CHECK_LOG(&f, "5(1000,0) ");
    CHECK(visit(&f) == PWD_OK && strcmp(field1(&f), "-") == 0); /* shown once */
    /* a typed character removes the cursor, is appended, and the cursor follows it */
    CHECK(pwd_key(&f.st, 'a') == 1);
    CHECK(visit(&f) == PWD_OK);
    CHECK(strcmp(field1(&f), "a-") == 0 && f.st.b[PWD_S_KEY_PENDING] == 0);
    CHECK_LOG(&f, "7(0,0) 5(1000,0) "); /* the width of the text without the cursor was asked: "" -> 0 */
    CHECK(f.width_font == 3);
    CHECK(type_char(&f, 'b') == PWD_OK);
    CHECK(strcmp(field1(&f), "ab-") == 0);
    CHECK_LOG(&f, "7(8,0) 5(1000,0) ");
    /* the deadline: one tick before nothing happens, at the deadline the blink phase flips and the deadline moves */
    CHECK_INT(st32(&f, PWD_S_DEADLINE), 1500);
    f.now = 1499;
    CHECK(visit(&f) == PWD_OK && st32(&f, PWD_S_BLINK) == 0 && st32(&f, PWD_S_DEADLINE) == 1500);
    f.now = 1500;
    CHECK(visit(&f) == PWD_OK);
    CHECK_LOG(&f, "5(1500,0) 5(1500,0) ");
    CHECK_INT(st32(&f, PWD_S_BLINK), 1);
    CHECK_INT(st32(&f, PWD_S_DEADLINE), 2000);
    CHECK(strcmp(field1(&f), "ab-") == 0); /* the cursor is hidden by the next visit */
    f.now = 1500;
    CHECK(visit(&f) == PWD_OK);
    CHECK(strcmp(field1(&f), "ab") == 0 && st32(&f, PWD_S_BLINK) == 1);
    CHECK(visit(&f) == PWD_OK && strcmp(field1(&f), "ab") == 0); /* stays hidden */
    f.now = 2000;
    CHECK(visit(&f) == PWD_OK && st32(&f, PWD_S_BLINK) == 0 && st32(&f, PWD_S_DEADLINE) == 2500);
    CHECK(visit(&f) == PWD_OK && strcmp(field1(&f), "ab-") == 0);
    /* a negative period moves the deadline back: the next visit is already due again */
    fx_init(&f);
    put16(f.body, O_BLINK, -5);
    start(&f);
    f.step = 0;
    CHECK(visit(&f) == PWD_OK && st32(&f, PWD_S_BLINK) == 1 && st32(&f, PWD_S_DEADLINE) == 995);
    /* the deadline compare is unsigned (the wrap-around of the 32-bit clock is the oracle's to confirm) */
    fx_init(&f);
    start(&f);
    f.step = 0;
    put32(f.st.b, PWD_S_DEADLINE, 0x7fffffff);
    f.now = 0x80000000u;
    CHECK(visit(&f) == PWD_OK && st32(&f, PWD_S_BLINK) == 1);
    fx_init(&f);
    start(&f);
    f.step = 0;
    put32(f.st.b, PWD_S_DEADLINE, (int32_t)0x80000000u);
    f.now = 0x7fffffffu;
    CHECK(visit(&f) == PWD_OK && st32(&f, PWD_S_BLINK) == 0);
    /* hiding the cursor of an empty field does nothing */
    fx_init(&f);
    start(&f);
    f.st.b[PWD_S_BLINK] = 1;
    CHECK(visit(&f) == PWD_OK && field1(&f)[0] == 0);
    /* the hidden phase removes only a '-' at the end */
    fx_init(&f);
    start(&f);
    f.step = 0;
    type_str(&f, "ab");
    f.st.b[PWD_S_BLINK] = 1;
    CHECK(visit(&f) == PWD_OK && strcmp(field1(&f), "ab") == 0);
    /* Backspace: removes the cursor and then one more character; at an empty field it removes nothing */
    fx_init(&f);
    start(&f);
    f.step = 0;
    type_str(&f, "abc");
    CHECK(strcmp(field1(&f), "abc-") == 0);
    CHECK(type_char(&f, '\b') == PWD_OK && strcmp(field1(&f), "ab-") == 0);
    CHECK(type_char(&f, '\b') == PWD_OK && type_char(&f, '\b') == PWD_OK && strcmp(field1(&f), "-") == 0);
    CHECK(type_char(&f, '\b') == PWD_OK && strcmp(field1(&f), "-") == 0);
    CHECK_LOG(&f, "5(1000,0) "); /* no width query for a control key */
    f.st.b[PWD_S_BLINK] = 1;     /* a hidden cursor: the Backspace removes the last real character */
    f.st.b[PWD_S_FIELD1] = 'q';
    f.st.b[PWD_S_FIELD1 + 1] = 0;
    CHECK(type_char(&f, '\b') == PWD_OK && field1(&f)[0] == 0);
    /* a typed '-' that ends the text looks like the cursor: the next removal takes it */
    fx_init(&f);
    start(&f);
    f.step = 0;
    type_str(&f, "x-");
    CHECK(strcmp(field1(&f), "x-") == 0);
    f.st.b[PWD_S_BLINK] = 1;
    CHECK(visit(&f) == PWD_OK && strcmp(field1(&f), "x") == 0);
    /* a key that is not pending is not consumed */
    fx_init(&f);
    start(&f);
    f.step = 0;
    f.st.b[PWD_S_KEY] = 'z';
    CHECK(visit(&f) == PWD_OK && strcmp(field1(&f), "-") == 0);
}

static void t_limits(void)
{
    Fx f;
    /* width limit: a character is added only while the width of the text so far is below (right - left) - 0x14 = 180 */
    fx_init(&f);
    start(&f);
    f.step = 0;
    for (int i = 0; i < 40; ++i) (void)type_char(&f, 'a');
    CHECK_INT(strlen(field1(&f)), 23 + 1); /* 22 * 8 = 176 < 180 adds the 23rd, 23 * 8 = 184 does not; plus the cursor */
    fx_init(&f);
    f.width_per_char = 9;
    start(&f);
    f.step = 0;
    for (int i = 0; i < 40; ++i) (void)type_char(&f, 'a');
    CHECK_INT(strlen(field1(&f)), 20 + 1); /* 19 * 9 = 171 < 180 adds the 20th, 20 * 9 = 180 is not below the limit */
    fx_init(&f);
    f.width_per_char = 179;
    start(&f);
    f.step = 0;
    for (int i = 0; i < 40; ++i) (void)type_char(&f, 'a');
    CHECK_INT(strlen(field1(&f)), 2 + 1); /* 179 < 180 adds the 2nd, 358 does not */
    /* a rectangle narrower than the margin takes nothing; a reversed one too */
    fx_init(&f);
    put_rect(f.body, O_RF1, 10, 20, 30, 40);
    start(&f);
    f.step = 0;
    (void)type_char(&f, 'a');
    CHECK(strcmp(field1(&f), "-") == 0);
    fx_init(&f);
    put_rect(f.body, O_RF1, 100, 20, 50, 40);
    start(&f);
    f.step = 0;
    (void)type_char(&f, 'a');
    CHECK(strcmp(field1(&f), "-") == 0);
    /* the character limit: a wide field stops at 31 characters (len + 2 < 33), the cursor takes the 32nd place */
    fx_init(&f);
    put_rect(f.body, O_RF1, 0, 20, 4000, 40);
    start(&f);
    f.step = 0;
    for (int i = 0; i < 40; ++i) (void)type_char(&f, 'a');
    CHECK_INT(strlen(field1(&f)), 32);
    CHECK(field1(&f)[31] == '-' && field1(&f)[30] == 'a');
    f.rc = visit(&f);
    CHECK_INT(f.rc, PWD_OK);
    CHECK(f.st.b[PWD_S_FIELD1 + 32] == 0);
    CHECK(f.st.b[PWD_S_FIELD2] == 0);
    /* a refused width query is a host failure */
    fx_init(&f);
    start(&f);
    f.fail_at = f.calls + 1;
    (void)pwd_key(&f.st, 'a');
    CHECK(visit(&f) == PWD_ERR_HOST);
}

/* ---- Enter ---------------------------------------------------------------------------------------------------------------------- */

static void t_enter_single_field(void)
{
    Fx f;
    static const struct { const char *typed; int hit; } cases[] = {
        {"alpha", 1}, {"xxAlPhAxx", 1}, {"ALPHA", 1}, {"beta", 1}, {"my BETA!", 1}, {"alph", 0}, {"gamma", 0}, {"", 0},
        {"alpha beta", 1}, {"bet a", 0}};
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        fx_init(&f);
        start(&f);
        f.step = 0;
        type_str(&f, cases[i].typed);
        (void)type_char(&f, '\r');
        if (cases[i].hit) {
            CHECK(f.st.b[PWD_S_CORRECT] == 1 && f.st.b[PWD_S_WRONG] == 0);
            CHECK_INT(state_of(&f), 5);
        } else {
            CHECK(f.st.b[PWD_S_CORRECT] == 0 && f.st.b[PWD_S_WRONG] == 1);
            CHECK_INT(state_of(&f), 2);
        }
        if (g_failed) {
            snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (typed \"%s\")", cases[i].typed);
            return;
        }
    }
    /* the first accepted word is empty: it is a substring of everything */
    fx_init(&f);
    set_str(f.body, O_WA, "");
    start(&f);
    f.step = 0;
    type_str(&f, "zzz");
    (void)type_char(&f, '\r');
    CHECK(f.st.b[PWD_S_CORRECT] == 1 && state_of(&f) == 5);
    /* lower case accepted words are compared in upper case, a high byte only equals itself */
    fx_init(&f);
    set_str(f.body, O_WA, "caf\xe9");
    start(&f);
    f.step = 0;
    type_str(&f, "CAF");
    (void)pwd_key(&f.st, (int8_t)0xe9);
    (void)visit(&f);
    (void)type_char(&f, '\r');
    CHECK(f.st.b[PWD_S_CORRECT] == 1);
    /* count 0 and count 1: the second word is not looked at */
    fx_init(&f);
    put16(f.body, O_CA, 0);
    start(&f);
    f.step = 0;
    type_str(&f, "alpha");
    (void)type_char(&f, '\r');
    CHECK(f.st.b[PWD_S_CORRECT] == 0 && f.st.b[PWD_S_WRONG] == 1 && state_of(&f) == 2);
    fx_init(&f);
    put16(f.body, O_CA, 1);
    start(&f);
    f.step = 0;
    type_str(&f, "beta");
    (void)type_char(&f, '\r');
    CHECK(f.st.b[PWD_S_CORRECT] == 0 && f.st.b[PWD_S_WRONG] == 1);
    /* a full text of 31 characters is compared whole */
    fx_init(&f);
    put_rect(f.body, O_RF1, 0, 20, 4000, 40);
    start(&f);
    f.step = 0;
    for (int i = 0; i < 26; ++i) (void)type_char(&f, 'x');
    type_str(&f, "alpha");
    CHECK_INT(strlen(field1(&f)), 32);
    (void)type_char(&f, '\r');
    CHECK(f.st.b[PWD_S_CORRECT] == 1);
    /* Enter alone never types a character, and the cursor is gone from the field when the answer is judged */
    fx_init(&f);
    start(&f);
    f.step = 0;
    type_str(&f, "ab");
    (void)type_char(&f, '\r');
    CHECK(strncmp(field1(&f), "ab", 2) == 0 && f.st.b[PWD_S_WRONG] == 1);
    CHECK(visit(&f) == PWD_OK);
}

static void t_enter_two_fields(void)
{
    Fx f;
    /* field 1 hit with a second field present: go on typing into field 2, nothing is correct yet and no sound starts */
    fx_init(&f);
    put16(f.body, O_CB, 2);
    start(&f);
    f.step = 0;
    type_str(&f, "alpha");
    (void)type_char(&f, '\r');
    CHECK(f.st.b[PWD_S_CORRECT] == 0 && f.st.b[PWD_S_WRONG] == 0);
    CHECK_INT(state_of(&f), 1);
    {
        PwdClickResult c;
        PwdState keep = f.st;
        CHECK(pwd_click(&f.st, CANDIDATE, &c) == PWD_OK && c.fired == 1); /* not correct yet: the cancel strip still works */
        f.st = keep;
    }
    /* field 1 wrong: straight to the wrong sound even with a second field */
    {
        Fx g;
        fx_init(&g);
        put16(g.body, O_CB, 2);
        start(&g);
        g.step = 0;
        type_str(&g, "no");
        (void)type_char(&g, '\r');
        CHECK(g.st.b[PWD_S_WRONG] == 1 && state_of(&g) == 2);
    }
    /* field 2 takes its own text (its width limit, its own rectangle) and shows the cursor, field 1 does not */
    CHECK(strcmp(field1(&f), "alpha") == 0 && field2(&f)[0] == 0);
    CHECK(visit(&f) == PWD_OK && strcmp(field2(&f), "-") == 0 && strcmp(field1(&f), "alpha") == 0);
    type_str(&f, "zzz");
    CHECK(strcmp(field2(&f), "zzz-") == 0);
    CHECK_INT(strncmp(field1(&f), "alpha", 5), 0);
    CHECK(visit(&f) == PWD_OK && strcmp(field2(&f), "zzz-") == 0);
    (void)type_char(&f, '\b');
    CHECK(strcmp(field2(&f), "zz-") == 0);
    (void)type_char(&f, 'z');
    (void)type_char(&f, '\r');
    CHECK(f.st.b[PWD_S_CORRECT] == 1 && f.st.b[PWD_S_WRONG] == 0);
    CHECK_INT(state_of(&f), 5);
    CHECK(strcmp(field2(&f), "zzz") == 0);
    /* the narrow second rectangle limits only field 2 */
    fx_init(&f);
    put16(f.body, O_CB, 2);
    put_rect(f.body, O_RF2, 10, 50, 25, 70);
    start(&f);
    f.step = 0;
    type_str(&f, "alpha");
    (void)type_char(&f, '\r');
    type_str(&f, "zz");
    CHECK(strcmp(field2(&f), "-") == 0);
    /* field 2 miss on every word: wrong, wrong sound */
    fx_init(&f);
    put16(f.body, O_CB, 2);
    start(&f);
    f.step = 0;
    type_str(&f, "alpha");
    (void)type_char(&f, '\r');
    type_str(&f, "abc");
    (void)type_char(&f, '\r');
    CHECK(f.st.b[PWD_S_WRONG] == 1 && state_of(&f) == 2);
    /* miss then hit: the first miss already declared the answer wrong; the hit stores correct and state 5 and the wrong flag stays */
    fx_init(&f);
    put16(f.body, O_CB, 2);
    start(&f);
    f.step = 0;
    type_str(&f, "alpha");
    (void)type_char(&f, '\r');
    type_str(&f, "qqq");
    (void)type_char(&f, '\r');
    CHECK(f.st.b[PWD_S_WRONG] == 1 && f.st.b[PWD_S_CORRECT] == 1);
    CHECK_INT(state_of(&f), 5);
    /* the first word hits: no wrong flag */
    fx_init(&f);
    put16(f.body, O_CB, 1);
    start(&f);
    f.step = 0;
    type_str(&f, "alpha");
    (void)type_char(&f, '\r');
    type_str(&f, "zzz");
    (void)type_char(&f, '\r');
    CHECK(f.st.b[PWD_S_WRONG] == 0 && state_of(&f) == 5);
    /* field 2 with count 0 words cannot happen through state 1, but an empty list there declares nothing */
    fx_init(&f);
    put16(f.body, O_CB, 1);
    start(&f);
    f.step = 0;
    type_str(&f, "alpha");
    (void)type_char(&f, '\r');
    put16(f.body, O_CB, 0);
    (void)type_char(&f, '\r');
    CHECK(f.st.b[PWD_S_WRONG] == 0 && state_of(&f) == 1);
}

/* ---- sounds and the finish --------------------------------------------------------------------------------------------------- */

static void t_sounds_and_finish(void)
{
    Fx f;
    /* success: sound start, wait while busy, stop, phase 2, then the correct block */
    fx_init(&f);
    start(&f);
    f.step = 0;
    type_str(&f, "alpha");
    (void)type_char(&f, '\r');
    f.busy_seq[0] = 1;
    f.busy_seq[1] = 1;
    f.busy_seq[2] = 0;
    f.busy_n = 3;
    CHECK(visit(&f) == PWD_OK);
    CHECK_LOG(&f, "8(411,0) 9(4,0) ");
    CHECK(f.prep_offset == 0x19b && f.phase == 1 && state_of(&f) == 3 && f.play_ch == 4);
    CHECK(visit(&f) == PWD_OK && f.phase == 1);
    CHECK_LOG(&f, "10(4,1) ");
    CHECK(f.busy_ch == 4);
    CHECK(visit(&f) == PWD_OK && f.phase == 1);
    CHECK(visit(&f) == PWD_OK && f.phase == 2);
    CHECK_LOG(&f, "10(4,0) 11(411,0) 6(2,0) ");
    CHECK(f.stop_offset == 0x19b && f.res.completed == 0 && f.res.phase_after == 2);
    CHECK(visit(&f) == PWD_OK);
    CHECK_LOG(&f, "1(1,0) 3(3,0) 4(0,0) 12(11,0) 13(1,0) 14(2,0) 15(3,0) 16(4,0) 17(5,0) 18(6,0) 1(1,0) 19(4,0) 20(5,7) 21(3,0) ");
    CHECK(f.res.completed == 1 && f.res.phase_after == 2 && f.st.b[PWD_S_ACTIVE] == 0 && f.rel_font == 3);
    CHECK(f.n_trans == 1 && f.trans.scene == 11 && f.trans.word[0] == 1 && f.trans.word[1] == 2 && f.trans.word[2] == 3 &&
          f.trans.dword[0] == 4 && f.trans.dword[1] == 5 && f.trans.dword[2] == 6);
    CHECK(f.n_store == 1 && f.store_index == 5 && f.store_value == 7);
    /* wrong: its own sound and channel, then the wrong block (start word 1 stores 0, no event flag) */
    fx_init(&f);
    start(&f);
    f.step = 0;
    type_str(&f, "no");
    (void)type_char(&f, '\r');
    f.busy_seq[0] = 1;
    f.busy_n = 1;
    CHECK(visit(&f) == PWD_OK);
    CHECK_LOG(&f, "8(485,0) 9(6,0) ");
    CHECK(f.prep_offset == 0x1e5 && state_of(&f) == 4 && f.play_ch == 6);
    CHECK(visit(&f) == PWD_OK);
    CHECK_LOG(&f, "10(6,1) ");
    CHECK(f.busy_ch == 6);
    CHECK(visit(&f) == PWD_OK && f.phase == 2);
    CHECK_LOG(&f, "10(6,0) 11(485,0) 6(2,0) ");
    CHECK(f.stop_offset == 0x1e5);
    CHECK(visit(&f) == PWD_OK);
    CHECK_LOG(&f, "1(1,0) 3(3,0) 4(0,0) 12(22,0) 13(9,0) 14(8,0) 15(7,0) 16(10,0) 17(11,0) 18(12,0) 1(0,0) 19(4,0) 21(3,0) ");
    CHECK(f.n_store == 0 && f.trans.scene == 22);
    /* NO SOUND skips the sound (the next visit finishes); a name that only starts like it is a sound */
    fx_init(&f);
    set_str(f.body, O_BADSND, "NO SOUND");
    start(&f);
    f.step = 0;
    type_str(&f, "no");
    (void)type_char(&f, '\r');
    CHECK(visit(&f) == PWD_OK && f.phase == 2);
    CHECK_LOG(&f, "6(2,0) ");
    CHECK(f.prep_offset == 0 && f.n_trans == 0);
    fx_init(&f);
    set_str(f.body, O_OKSND, "NO SOUND");
    start(&f);
    f.step = 0;
    type_str(&f, "alpha");
    (void)type_char(&f, '\r');
    CHECK(visit(&f) == PWD_OK && f.phase == 2);
    CHECK_LOG(&f, "6(2,0) ");
    {
        static const char *const names[] = {"NO SOUNDS", "no sound", "NO SOUN", "NO  SOUND", "NO SOUND "};
        for (size_t i = 0; i < sizeof names / sizeof names[0]; ++i) {
            fx_init(&f);
            set_str(f.body, O_BADSND, names[i]);
            start(&f);
            f.step = 0;
            type_str(&f, "no");
            (void)type_char(&f, '\r');
            CHECK(visit(&f) == PWD_OK && f.phase == 1);
            CHECK_LOG(&f, "8(485,0) 9(6,0) ");
        }
    }
    /* the sound wait is a state of its own: a wrong state value outside 0..5 does nothing */
    fx_init(&f);
    start(&f);
    f.st.b[PWD_S_STATE] = 9;
    CHECK(visit(&f) == PWD_OK && f.log[0] == 0 && f.phase == 1);
}

static void t_phase2_blocks(void)
{
    Fx f;
    /* nothing taken: no block, but the font, entry and generic completion still run, even for a refused flag index */
    fx_init(&f);
    f.invalid_flag = 5;
    start(&f);
    CHECK(visit_phase(&f, 2) == PWD_OK);
    CHECK_LOG(&f, "1(1,0) 3(3,0) 4(0,0) 21(3,0) ");
    CHECK(f.res.completed == 1 && f.n_trans == 0 && f.n_store == 0 && f.st.b[PWD_S_ACTIVE] == 0);
    /* priority: cancel before wrong before correct */
    fx_init(&f);
    start(&f);
    f.st.b[PWD_S_CORRECT] = 1;
    f.st.b[PWD_S_WRONG] = 1;
    f.st.b[PWD_S_CANCEL] = 1;
    CHECK(visit_phase(&f, 2) == PWD_OK);
    CHECK_LOG(&f, "1(1,0) 3(3,0) 4(0,0) 12(33,0) 13(13,0) 14(14,0) 15(15,0) 16(16,0) 17(17,0) 18(18,0) 1(1,0) 19(4,0) 20(9,200) 21(3,0) ");
    CHECK(f.store_index == 9 && f.store_value == 200);
    fx_init(&f);
    start(&f);
    f.st.b[PWD_S_CORRECT] = 1;
    f.st.b[PWD_S_CANCEL] = 1;
    CHECK(visit_phase(&f, 2) == PWD_OK && f.trans.scene == 33);
    fx_init(&f);
    start(&f);
    f.st.b[PWD_S_CORRECT] = 1;
    f.st.b[PWD_S_WRONG] = 1;
    CHECK(visit_phase(&f, 2) == PWD_OK && f.trans.scene == 22 && f.n_store == 0);
    fx_init(&f);
    start(&f);
    f.st.b[PWD_S_WRONG] = 1;
    f.st.b[PWD_S_CANCEL] = 1;
    CHECK(visit_phase(&f, 2) == PWD_OK && f.trans.scene == 33);
    /* scene 9999: no scene cells, no start flag, no engine mode, the event flag is still stored */
    fx_init(&f);
    put16(f.body, O_OK + SB_SCENE, 9999);
    start(&f);
    f.st.b[PWD_S_CORRECT] = 1;
    CHECK(visit_phase(&f, 2) == PWD_OK);
    CHECK_LOG(&f, "1(1,0) 3(3,0) 4(0,0) 20(5,7) 21(3,0) ");
    CHECK(f.n_trans == 0 && f.n_store == 1);
    /* event flag -1: not stored, not even asked about */
    fx_init(&f);
    put16(f.body, O_OK + SB_FLAG, -1);
    f.invalid_flag = -1;
    start(&f);
    f.st.b[PWD_S_CORRECT] = 1;
    CHECK(visit_phase(&f, 2) == PWD_OK && f.n_store == 0 && f.n_trans == 1);
    /* both absent: only the common part */
    fx_init(&f);
    put16(f.body, O_OK + SB_FLAG, -1);
    put16(f.body, O_OK + SB_SCENE, 9999);
    start(&f);
    f.st.b[PWD_S_CORRECT] = 1;
    CHECK(visit_phase(&f, 2) == PWD_OK);
    CHECK_LOG(&f, "1(1,0) 3(3,0) 4(0,0) 21(3,0) ");
    /* scene 0 and flag 0 are real values */
    fx_init(&f);
    put16(f.body, O_OK + SB_SCENE, 0);
    put16(f.body, O_OK + SB_FLAG, 0);
    start(&f);
    f.st.b[PWD_S_CORRECT] = 1;
    CHECK(visit_phase(&f, 2) == PWD_OK && f.n_trans == 1 && f.n_store == 1 && f.store_index == 0);
    /* start flag word: only the value 1 stores 0 */
    for (int v = -1; v <= 3; ++v) {
        fx_init(&f);
        put16(f.body, O_OK + SB_START, v);
        start(&f);
        f.st.b[PWD_S_CORRECT] = 1;
        (void)visit_phase(&f, 2);
        CHECK(strstr(f.log, v == 1 ? "1(0,0) 19" : "1(1,0) 19") != NULL);
    }
    /* signed words and dwords are sign-extended into the transition */
    fx_init(&f);
    set_block(f.body, O_OK, -7, -1, -2, -3, -4, INT32_MIN, INT32_MAX, 0, 5, 255);
    start(&f);
    f.st.b[PWD_S_CORRECT] = 1;
    (void)visit_phase(&f, 2);
    CHECK(f.trans.scene == -7 && f.trans.word[0] == -1 && f.trans.word[1] == -2 && f.trans.word[2] == -3);
    CHECK(f.trans.dword[0] == -4 && f.trans.dword[1] == INT32_MIN && f.trans.dword[2] == INT32_MAX && f.store_value == 255);
    /* a refused flag index of the block that will run stops before any effect; one of a block that will not run does not */
    fx_init(&f);
    start(&f);
    f.st.b[PWD_S_CORRECT] = 1;
    f.invalid_flag = 5;
    CHECK(visit_phase(&f, 2) == PWD_ERR_UNSUPPORTED && f.log[0] == 0 && f.st.b[PWD_S_ACTIVE] == 1 && f.why != NULL);
    f.invalid_flag = 9;
    CHECK(visit_phase(&f, 2) == PWD_OK && f.n_trans == 1);
    fx_init(&f);
    start(&f);
    f.st.b[PWD_S_CANCEL] = 1;
    f.invalid_flag = 9;
    CHECK(visit_phase(&f, 2) == PWD_ERR_UNSUPPORTED && f.log[0] == 0);
    fx_init(&f);
    start(&f);
    f.st.b[PWD_S_WRONG] = 1;
    f.invalid_flag = 0; /* the wrong block has no flag; the correct and cancel blocks' flags are not looked at */
    CHECK(visit_phase(&f, 2) == PWD_OK);
}

/* ---- refusals, argument checks, host failures ------------------------------------------------------------------------------ */

static void t_refusals(void)
{
    Fx f;
    PwdResult res;
    fx_init(&f);
    /* phase 1 / 2 without phase 0 */
    CHECK(visit_phase(&f, 1) == PWD_ERR_UNSUPPORTED && f.log[0] == 0 && f.why != NULL);
    CHECK(visit_phase(&f, 2) == PWD_ERR_UNSUPPORTED && f.log[0] == 0);
    start(&f);
    /* another row */
    f.log[0] = 0;
    CHECK(pwd_step(&f.st, f.body, PWD_BODY_BYTES, ROW + 1, 1u, &f.host, &res, &f.why) == PWD_ERR_UNSUPPORTED && f.log[0] == 0);
    CHECK(pwd_step(&f.st, f.body, PWD_BODY_BYTES, ROW + 1, 2u, &f.host, &res, &f.why) == PWD_ERR_UNSUPPORTED);
    f.why = NULL;
    CHECK(pwd_step(&f.st, f.body, PWD_BODY_BYTES, ROW, 3u, &f.host, &res, &f.why) == PWD_ERR_UNSUPPORTED && f.why != NULL);
    CHECK(pwd_step(&f.st, f.body, PWD_BODY_BYTES, ROW, 0xffffffffu, &f.host, &res, &f.why) == PWD_ERR_UNSUPPORTED);
    /* phase 0 may start again at any time, also for another row */
    CHECK(pwd_step(&f.st, f.body, PWD_BODY_BYTES, ROW + 1, 0u, &f.host, &res, &f.why) == PWD_OK && res.initialized == 1);
    CHECK(pwd_rd16(f.st.b, PWD_S_ROW) == ROW + 1);
    /* after the scene clear the puzzle is inactive */
    pwd_cleanup(&f.st);
    CHECK(pwd_step(&f.st, f.body, PWD_BODY_BYTES, ROW + 1, 1u, &f.host, &res, &f.why) == PWD_ERR_UNSUPPORTED);
    /* a bad body precedes every effect */
    fx_init(&f);
    put16(f.body, O_FONT, 18);
    CHECK(visit_phase(&f, 0) == PWD_ERR_BODY && f.log[0] == 0 && f.why != NULL && f.st.b[PWD_S_ACTIVE] == 0);
    CHECK(pwd_step(&f.st, f.body, PWD_BODY_BYTES - 1u, ROW, 0u, &f.host, &res, NULL) == PWD_ERR_BODY);
    /* arguments */
    fx_init(&f);
    CHECK(pwd_step(NULL, f.body, PWD_BODY_BYTES, ROW, 0u, &f.host, &res, NULL) == PWD_ERR_ARGUMENT);
    CHECK(pwd_step(&f.st, NULL, PWD_BODY_BYTES, ROW, 0u, &f.host, &res, NULL) == PWD_ERR_ARGUMENT);
    CHECK(pwd_step(&f.st, f.body, PWD_BODY_BYTES, ROW, 0u, NULL, &res, NULL) == PWD_ERR_ARGUMENT);
    CHECK(pwd_step(&f.st, f.body, PWD_BODY_BYTES, ROW, 0u, &f.host, NULL, NULL) == PWD_ERR_ARGUMENT);
    {
        PwdHost h = f.host;
        h.view_origin = NULL;
        CHECK(pwd_step(&f.st, f.body, PWD_BODY_BYTES, ROW, 0u, &h, &res, NULL) == PWD_ERR_ARGUMENT);
        h = f.host;
        h.sound_busy = NULL;
        CHECK(pwd_step(&f.st, f.body, PWD_BODY_BYTES, ROW, 0u, &h, &res, NULL) == PWD_ERR_ARGUMENT);
        h = f.host;
        h.store_event_flag = NULL;
        CHECK(pwd_step(&f.st, f.body, PWD_BODY_BYTES, ROW, 0u, &h, &res, NULL) == PWD_ERR_ARGUMENT);
        for (int i = 0; i < 12; ++i) {
            h = f.host;
            switch (i) {
            case 0: h.view_origin = NULL; break;
            case 1: h.font_acquire = NULL; break;
            case 2: h.font_release = NULL; break;
            case 3: h.text_width = NULL; break;
            case 4: h.tick = NULL; break;
            case 5: h.sound_prepare = NULL; break;
            case 6: h.sound_stop = NULL; break;
            case 7: h.sound_play = NULL; break;
            case 8: h.sound_busy = NULL; break;
            case 9: h.event_flag_invalid = NULL; break;
            case 10: h.transition = NULL; break;
            default: h.store_event_flag = NULL; break;
            }
            CHECK(pwd_step(&f.st, f.body, PWD_BODY_BYTES, ROW, 0u, &h, &res, NULL) == PWD_ERR_ARGUMENT);
        }
        h = f.host;
        h.observe = NULL; /* optional */
        CHECK(pwd_step(&f.st, f.body, PWD_BODY_BYTES, ROW, 0u, &h, &res, NULL) == PWD_OK);
    }
    CHECK(f.log[0] == 0);
}

/* A scenario that makes every failable host call at least once: phase 0, five typed characters (width queries), Enter (hit),
 * sound start, a busy then a free wait, phase 2 (font release, transition, event flag). */
static int run_scenario(Fx *f)
{
    int rc;
    f->phase = 0;
    rc = visit(f);
    if (rc != PWD_OK) return rc;
    for (const char *p = "alpha\r"; *p != '\0'; ++p) {
        rc = type_char(f, (int8_t)*p);
        if (rc != PWD_OK) return rc;
    }
    f->busy_seq[0] = 1;
    f->busy_n = 1;
    f->busy_i = 0;
    for (int i = 0; i < 3; ++i) {
        rc = visit(f); /* sound start, busy, free + stop */
        if (rc != PWD_OK) return rc;
    }
    if (f->phase != 2) return -1;
    return visit(f);
}

static void t_host_failures(void)
{
    Fx f;
    int total;
    fx_init(&f);
    f.step = 0;
    CHECK(run_scenario(&f) == PWD_OK && f.res.completed == 1);
    total = f.calls;
    CHECK_INT(total, 15); /* view 1, acquire 1, width 5, prepare 1, play 1, busy 2, stop 1, release 1, transition 1, store 1 */
    for (int k = 1; k <= total; ++k) {
        fx_init(&f);
        f.step = 0;
        f.fail_at = k;
        if (run_scenario(&f) != PWD_ERR_HOST && !g_failed) {
            g_failed = 1;
            snprintf(g_msg, sizeof g_msg, "failure of host call %d was not reported as PWD_ERR_HOST", k);
        }
    }
}

/* ---- pointer, click, cleanup, render ------------------------------------------------------------------------------------------- */

static void t_pointer_click(void)
{
    Fx f;
    PwdPointerResult p;
    PwdClickResult c;
    fx_init(&f);
    memset(&p, 0x55, sizeof p);
    CHECK(pwd_pointer(&f.st, f.body, PWD_BODY_BYTES, 310, 210, &p) == PWD_OK);
    CHECK(p.hit == 0 && p.candidate == -1 && p.cursor_kind == -1); /* inactive */
    start(&f);
    CHECK(pwd_pointer(&f.st, f.body, PWD_BODY_BYTES, 310, 210, &p) == PWD_OK);
    CHECK(p.hit == 1 && p.candidate == CANDIDATE && p.cursor_kind == 9);
    {
        static const int32_t pts[][3] = {{300, 200, 1}, {340, 230, 1}, {300, 230, 1}, {340, 200, 1}, {299, 210, 0}, {341, 210, 0},
                                         {310, 199, 0}, {310, 231, 0}, {-300, -200, 0}, {0, 0, 0}, {293, 189, 0}, {347, 241, 0},
                                         {INT32_MIN, 210, 0}, {310, INT32_MAX, 0}};
        for (size_t i = 0; i < sizeof pts / sizeof pts[0]; ++i) {
            CHECK(pwd_pointer(&f.st, f.body, PWD_BODY_BYTES, pts[i][0], pts[i][1], &p) == PWD_OK);
            if (p.hit != pts[i][2] && !g_failed) {
                g_failed = 1;
                snprintf(g_msg, sizeof g_msg, "pointer (%d,%d) hit %d, expected %d", (int)pts[i][0], (int)pts[i][1], p.hit, (int)pts[i][2]);
            }
            CHECK(p.hit != 0 || (p.candidate == -1 && p.cursor_kind == -1));
        }
    }
    /* negative rectangle coordinates */
    put_rect(f.body, O_CRECT, -50, -40, -10, -5);
    CHECK(pwd_pointer(&f.st, f.body, PWD_BODY_BYTES, -50, -40, &p) == PWD_OK && p.hit == 1);
    CHECK(pwd_pointer(&f.st, f.body, PWD_BODY_BYTES, -10, -5, &p) == PWD_OK && p.hit == 1);
    CHECK(pwd_pointer(&f.st, f.body, PWD_BODY_BYTES, -51, -40, &p) == PWD_OK && p.hit == 0);
    CHECK(pwd_pointer(&f.st, f.body, PWD_BODY_BYTES, -9, -5, &p) == PWD_OK && p.hit == 0);
    CHECK(pwd_pointer(&f.st, f.body, PWD_BODY_BYTES, -10, -4, &p) == PWD_OK && p.hit == 0);
    CHECK(pwd_pointer(&f.st, f.body, PWD_BODY_BYTES, -10, -41, &p) == PWD_OK && p.hit == 0);
    CHECK(pwd_pointer(&f.st, f.body, PWD_BODY_BYTES - 1u, 310, 210, &p) == PWD_ERR_BODY);
    CHECK(pwd_pointer(NULL, f.body, PWD_BODY_BYTES, 0, 0, &p) == PWD_ERR_ARGUMENT);
    CHECK(pwd_pointer(&f.st, NULL, PWD_BODY_BYTES, 0, 0, &p) == PWD_ERR_ARGUMENT);
    CHECK(pwd_pointer(&f.st, f.body, PWD_BODY_BYTES, 0, 0, NULL) == PWD_ERR_ARGUMENT);
    fx_init(&f);
    CHECK(pwd_pointer(&f.st, f.body, PWD_BODY_BYTES - 1u, 0, 0, &p) == PWD_OK && p.hit == 0); /* inactive: nothing is looked at */
    /* click */
    fx_init(&f);
    memset(&c, 0x55, sizeof c);
    CHECK(pwd_click(&f.st, CANDIDATE, &c) == PWD_OK && c.fired == 0 && c.row == 0 && c.phase == 0); /* inactive */
    CHECK(f.st.b[PWD_S_CANCEL] == 0);
    start(&f);
    memset(&c, 0x55, sizeof c);
    CHECK(pwd_click(&f.st, CANDIDATE + 1, &c) == PWD_OK && c.fired == 0 && c.row == 0 && c.phase == 0);
    CHECK(pwd_click(&f.st, -1, &c) == PWD_OK && c.fired == 0 && f.st.b[PWD_S_CANCEL] == 0);
    f.st.b[PWD_S_CORRECT] = 1;
    CHECK(pwd_click(&f.st, CANDIDATE, &c) == PWD_OK && c.fired == 0 && f.st.b[PWD_S_CANCEL] == 0); /* already correct */
    f.st.b[PWD_S_CORRECT] = 0;
    f.st.b[PWD_S_WRONG] = 1; /* a wrong answer does not stop the cancel strip */
    memset(&c, 0x55, sizeof c);
    CHECK(pwd_click(&f.st, CANDIDATE, &c) == PWD_OK && c.fired == 1 && c.row == ROW && c.phase == 2 && f.st.b[PWD_S_CANCEL] == 1);
    CHECK(pwd_click(NULL, CANDIDATE, &c) == PWD_ERR_ARGUMENT && pwd_click(&f.st, CANDIDATE, NULL) == PWD_ERR_ARGUMENT);
    /* the cancel then leaves through the cancel block */
    CHECK(visit_phase(&f, 2) == PWD_OK && f.trans.scene == 33);
}

static void t_state_cells_and_render(void)
{
    Fx f;
    PwdRenderResult r;
    PwdState before;
    fx_init(&f);
    CHECK(pwd_invalidate(&f.st) == 0 && pwd_invalidate(NULL) == 0);
    start(&f);
    CHECK(pwd_invalidate(&f.st) == 1);
    pwd_cleanup(&f.st);
    CHECK(f.st.b[PWD_S_ACTIVE] == 0 && pwd_invalidate(&f.st) == 0);
    pwd_cleanup(NULL);
    start(&f);
    pwd_new_game(&f.st);
    CHECK(f.st.b[PWD_S_ACTIVE] == 0 && f.st.b[PWD_S_ROW] == ROW); /* only the active flag */
    pwd_new_game(NULL);
    memset(f.st.b, 0xa5, sizeof f.st.b);
    pwd_state_reset(&f.st);
    for (size_t i = 0; i < sizeof f.st.b; ++i) CHECK(f.st.b[i] == 0);
    pwd_state_reset(NULL);
    /* render: the background restore and the first field; the second field only when it holds text */
    fx_init(&f);
    put_rect(f.body, O_RF1, 70000, 20, 70200, 40);
    put_rect(f.body, O_RBG, 1, 2, 3, 4);
    put16(f.body, O_CB, 1);
    start(&f);
    f.step = 0;
    type_str(&f, "ab");
    before = f.st;
    CHECK(pwd_render(&f.st, f.body, PWD_BODY_BYTES, &r) == PWD_OK);
    CHECK(memcmp(&before, &f.st, sizeof before) == 0);
    CHECK_INT(r.count, 2);
    CHECK(r.op[0].kind == PWD_OP_BLIT);
    CHECK(r.op[0].src[0] == 1 && r.op[0].src[1] == 2 && r.op[0].src[2] == 3 && r.op[0].src[3] == 4); /* raw, not shifted */
    CHECK(r.op[0].dst[0] == 1 + VIEW_X && r.op[0].dst[1] == 2 + VIEW_Y && r.op[0].dst[2] == 3 + VIEW_X && r.op[0].dst[3] == 4 + VIEW_Y);
    CHECK(r.op[1].kind == PWD_OP_TEXT && r.op[1].field == 1 && r.op[1].font == 3);
    CHECK_INT(r.op[1].x, (int16_t)(70000 + VIEW_X)); /* truncated to a word */
    CHECK_INT(r.op[1].y, 40 + VIEW_Y);                /* the bottom edge */
    CHECK(strcmp(r.op[1].text, "ab-") == 0);
    type_str(&f, "alpha");
    (void)type_char(&f, '\r');
    type_str(&f, "zz");
    CHECK(pwd_render(&f.st, f.body, PWD_BODY_BYTES, &r) == PWD_OK && r.count == 3);
    CHECK(r.op[2].kind == PWD_OP_TEXT && r.op[2].field == 2 && r.op[2].font == 3 && strcmp(r.op[2].text, "zz-") == 0);
    CHECK_INT(r.op[2].x, 10 + VIEW_X);
    CHECK_INT(r.op[2].y, 70 + VIEW_Y);
    CHECK(strncmp(r.op[1].text, "abalpha", 7) == 0);
    CHECK(pwd_render(&f.st, f.body, PWD_BODY_BYTES - 1u, &r) == PWD_ERR_BODY && r.count == 0);
    CHECK(pwd_render(NULL, f.body, PWD_BODY_BYTES, &r) == PWD_ERR_ARGUMENT);
    CHECK(pwd_render(&f.st, NULL, PWD_BODY_BYTES, &r) == PWD_ERR_ARGUMENT);
    CHECK(pwd_render(&f.st, f.body, PWD_BODY_BYTES, NULL) == PWD_ERR_ARGUMENT);
    /* the 32-character text of a full field is copied whole */
    memset(f.st.b + PWD_S_FIELD1, 'k', 0x21);
    CHECK(pwd_render(&f.st, f.body, PWD_BODY_BYTES, &r) == PWD_OK && strlen(r.op[1].text) == 0x21);
}

static uint32_t g_seed = 12345u;
static uint32_t rnd32(void)
{
    g_seed = g_seed * 1664525u + 1013904223u;
    return g_seed >> 8;
}

static void t_random_smoke(void)
{
    Fx f;
    for (int iter = 0; iter < 300 && !g_failed; ++iter) {
        int rc = PWD_OK;
        fx_init(&f);
        f.observe_on = 0;
        put16(f.body, O_BLINK, (int)(rnd32() % 40u) - 5);
        put16(f.body, O_CA, (int)(rnd32() % 6u));
        put16(f.body, O_CB, (int)(rnd32() % 6u));
        for (int w = 0; w < 5; ++w) {
            const char *words[] = {"A", "AB", "", "ZZZ", "b"};
            set_str(f.body, O_WA + 0x21u * (unsigned)w, words[rnd32() % 5u]);
            set_str(f.body, O_WB + 0x21u * (unsigned)w, words[rnd32() % 5u]);
        }
        put_rect(f.body, O_RF1, (int)(rnd32() % 100u), 0, (int)(rnd32() % 400u), 10);
        put_rect(f.body, O_RF2, (int)(rnd32() % 100u), 0, (int)(rnd32() % 400u), 10);
        set_str(f.body, O_OKSND, (rnd32() & 1u) ? "NO SOUND" : "S");
        set_str(f.body, O_BADSND, (rnd32() & 1u) ? "NO SOUND" : "S");
        put16(f.body, O_OK + SB_FLAG, (rnd32() & 1u) ? -1 : 3);
        f.step = rnd32() % 700u;
        f.width_per_char = (int)(rnd32() % 12u);
        start(&f);
        for (int v = 0; v < 200 && rc == PWD_OK; ++v) {
            if ((rnd32() & 3u) != 0) (void)pwd_key(&f.st, (int8_t)"ab\b\r-zZ A,\xe9#"[rnd32() % 13u]);
            if ((rnd32() & 15u) == 0) f.busy_n = 0;
            rc = visit(&f);
            if (rc == PWD_OK && f.res.completed) break;
        }
        CHECK(rc == PWD_OK || rc == PWD_ERR_UNSUPPORTED);
        CHECK(memchr(f.st.b + PWD_S_FIELD1, 0, 0x21) != NULL && memchr(f.st.b + PWD_S_FIELD2, 0, 0x21) != NULL);
        {
            PwdRenderResult r;
            CHECK(pwd_render(&f.st, f.body, PWD_BODY_BYTES, &r) == PWD_OK);
        }
    }
}

/* ---- the session binding ----------------------------------------------------------------------------------------------------- */

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
    uint8_t tsum[126], act[48 + 2 + PWD_BODY_BYTES];
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

static int g_stores, g_store_start;
static void *g_store_ctx;
static void h_store_world(void *c, int32_t start_flag)
{
    g_store_ctx = c;
    ++g_stores;
    g_store_start = start_flag;
}

typedef struct Bind {
    Fx f;
    SessionA76Host host;
    SessionA76Binding *b;
    SceneResource *scene;
    uint8_t bytes[8192];
    size_t bytes_len;
    uint8_t body_a[PWD_BODY_BYTES], body_b[PWD_BODY_BYTES];
} Bind;

static int bind_open(Bind *x, int hooks)
{
    const int types[3] = {0x70, 0x76, 0x76};
    const uint8_t one = 0;
    const uint8_t *bodies[3];
    size_t lengths[3] = {1, PWD_BODY_BYTES, PWD_BODY_BYTES};
    char err[128] = {0};
    fx_init(&x->f);
    g_stores = 0;
    g_store_start = -1;
    memcpy(x->body_a, x->f.body, PWD_BODY_BYTES);
    memcpy(x->body_b, x->f.body, PWD_BODY_BYTES);
    /* row 2: another font, another word and another cancel strip */
    put16(x->body_b, O_FONT, 5);
    set_str(x->body_b, O_WA, "OMEGA");
    put_rect(x->body_b, O_CRECT, 400, 300, 410, 310);
    put16(x->body_b, O_CANCEL + SB_START, 1); /* its cancel exit stores start flag 0 */
    bodies[0] = &one;
    bodies[1] = x->body_a;
    bodies[2] = x->body_b;
    x->bytes_len = build_scene(x->bytes, 3, types, bodies, lengths);
    x->scene = scene_resource_open_memory(x->bytes, x->bytes_len, err, sizeof err);
    if (x->scene == NULL) return 0;
    memset(&x->host, 0, sizeof x->host);
    x->host.kernel = x->f.host;
    x->host.kernel.context = &x->f;
    if (hooks & 1) x->host.store_world = h_store_world;
    if (hooks & 2) x->host.kernel.observe = NULL;
    x->b = session_a76_create(&x->host);
    return x->b != NULL;
}

static void bind_close(Bind *x)
{
    session_a76_destroy(x->b);
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
    x->f.log[0] = 0;
    if (scene_resource_action_at(x->scene, row, &info) != SCENE_RESOURCE_OK) return -1;
    {
        const int rc = session_a76_handler(x->b, row, &info, &st, &out);
        if (rc == SCENE_ACTION_HANDLER_OK) {
            *phase_after = out.phase;
            *completed = out.disposition == SCENE_ACTION_HANDLER_COMPLETED;
            if (out.disposition != SCENE_ACTION_HANDLER_COMPLETED && out.disposition != SCENE_ACTION_HANDLER_PENDING) return -2;
        }
        return rc;
    }
}

static void t_binding_create(void)
{
    Fx f;
    SessionA76Host h;
    fx_init(&f);
    memset(&h, 0, sizeof h);
    h.kernel = f.host;
    CHECK(session_a76_create(NULL) == NULL);
    {
        SessionA76Binding *b = session_a76_create(&h);
        CHECK(b != NULL && session_a76_registered(b) == 0u && strcmp(session_a76_failure(b), "none") == 0);
        CHECK(session_a76_state(b) != NULL && session_a76_state(b)->b[PWD_S_ACTIVE] == 0 && session_a76_start_flag(b) == 0);
        session_a76_destroy(b);
    }
    /* every callback except the observer is required */
    for (int i = 0; i < 12; ++i) {
        SessionA76Host g = h;
        switch (i) {
        case 0: g.kernel.view_origin = NULL; break;
        case 1: g.kernel.font_acquire = NULL; break;
        case 2: g.kernel.font_release = NULL; break;
        case 3: g.kernel.text_width = NULL; break;
        case 4: g.kernel.tick = NULL; break;
        case 5: g.kernel.sound_prepare = NULL; break;
        case 6: g.kernel.sound_stop = NULL; break;
        case 7: g.kernel.sound_play = NULL; break;
        case 8: g.kernel.sound_busy = NULL; break;
        case 9: g.kernel.event_flag_invalid = NULL; break;
        case 10: g.kernel.transition = NULL; break;
        default: g.kernel.store_event_flag = NULL; break;
        }
        CHECK(session_a76_create(&g) == NULL);
    }
    h.kernel.observe = NULL;
    {
        SessionA76Binding *b = session_a76_create(&h);
        CHECK(b != NULL);
        session_a76_destroy(b);
    }
    session_a76_destroy(NULL);
    CHECK(strcmp(session_a76_failure(NULL), "0x76-binding-unbound") == 0);
    CHECK(session_a76_state(NULL) == NULL && session_a76_registered(NULL) == 0u && session_a76_start_flag(NULL) == 0);
    {
        PwdPointerResult p;
        PwdClickResult c;
        PwdRenderResult r;
        CHECK(session_a76_key(NULL, 'a') == PWD_ERR_ARGUMENT && session_a76_invalidate(NULL) == PWD_ERR_ARGUMENT);
        CHECK(session_a76_pointer_move(NULL, 0, 0, &p) == PWD_ERR_ARGUMENT && session_a76_click(NULL, 1, &c) == PWD_ERR_ARGUMENT);
        CHECK(session_a76_render(NULL, &r) == PWD_ERR_ARGUMENT && session_a76_begin_scene(NULL, NULL) == PWD_ERR_ARGUMENT);
        session_a76_cleanup(NULL);
        session_a76_new_game(NULL);
    }
}

static void t_binding_flow(void)
{
    Bind x;
    uint32_t pa = 0;
    int done = 0;
    PwdPointerResult pr;
    PwdClickResult cr;
    PwdRenderResult r;
    CHECK(bind_open(&x, 1));
    if (g_failed) return;
    x.f.step = 0;
    /* before a scene: nothing is owned, everything is inert */
    CHECK(b_visit(&x, 1, 0u, &pa, &done) == SCENE_ACTION_HANDLER_ERROR && strcmp(session_a76_failure(x.b), "0x76-row-not-owned") == 0);
    CHECK(session_a76_render(x.b, &r) == PWD_OK && r.count == 0);
    CHECK(session_a76_pointer_move(x.b, 310, 210, &pr) == PWD_OK && pr.hit == 0 && pr.candidate == -1 && pr.cursor_kind == -1);
    CHECK(session_a76_click(x.b, CANDIDATE, &cr) == PWD_OK && cr.fired == 0);
    CHECK(session_a76_key(x.b, 'a') == 0);
    CHECK(session_a76_invalidate(x.b) == 0);
    CHECK(session_a76_begin_scene(x.b, x.scene) == PWD_OK && strcmp(session_a76_failure(x.b), "none") == 0);
    /* a row of another type and a row index past the scene are not owned */
    CHECK(b_visit(&x, 0, 0u, &pa, &done) == SCENE_ACTION_HANDLER_ERROR && strcmp(session_a76_failure(x.b), "0x76-row-not-owned") == 0);
    {
        SceneActionInfo info;
        SceneActionRuntimeState st;
        SceneActionHandlerResult out;
        memset(&st, 0, sizeof st);
        CHECK(scene_resource_action_at(x.scene, 1, &info) == SCENE_RESOURCE_OK);
        CHECK(session_a76_handler(x.b, 3, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_a76_handler(x.b, 1, NULL, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_a76_handler(x.b, 1, &info, NULL, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_a76_handler(x.b, 1, &info, &st, NULL) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_a76_handler(NULL, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(scene_resource_action_at(x.scene, 0, &info) == SCENE_RESOURCE_OK);
        CHECK(session_a76_handler(x.b, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR); /* the info is of a 0x70 row */
    }
    /* phase 1 without phase 0 is unsupported, not an error */
    CHECK(b_visit(&x, 1, 1u, &pa, &done) == SCENE_ACTION_HANDLER_UNSUPPORTED && x.f.log[0] == 0 && g_stores == 0);
    /* phase 0 */
    CHECK(b_visit(&x, 1, 0u, &pa, &done) == SCENE_ACTION_HANDLER_OK && pa == 1u && done == 0);
    CHECK_LOG(&x.f, "1(1,0) 2(3,0) 4(1,0) 5(1000,0) 6(1,0) "); /* the observer still sees every effect */
    CHECK(g_stores == 1 && g_store_start == 1 && session_a76_start_flag(x.b) == 1 && g_store_ctx == &x.f);
    CHECK(session_a76_registered(x.b) == 1u && session_a76_state(x.b)->b[PWD_S_ACTIVE] == 1);
    /* phase 1 does not publish the start flag */
    CHECK(b_visit(&x, 1, 1u, &pa, &done) == SCENE_ACTION_HANDLER_OK && pa == 1u && done == 0 && g_stores == 1);
    /* keys, pointer, render */
    CHECK(session_a76_key(x.b, 'o') == 1 && session_a76_key(x.b, 'p') == 0 && session_a76_key(x.b, '#') == 0);
    CHECK(b_visit(&x, 1, 1u, &pa, &done) == SCENE_ACTION_HANDLER_OK);
    CHECK(session_a76_render(x.b, &r) == PWD_OK && r.count == 2 && strcmp(r.op[1].text, "o-") == 0 && r.op[1].font == 3);
    CHECK(session_a76_pointer_move(x.b, 310, 210, &pr) == PWD_OK && pr.hit == 1 && pr.candidate == CANDIDATE && pr.cursor_kind == 9);
    CHECK(session_a76_pointer_move(x.b, 410, 310, &pr) == PWD_OK && pr.hit == 0); /* row 2's strip is not row 1's */
    CHECK(session_a76_invalidate(x.b) == 1);
    /* a click on the strip ends the run: the host stores phase 2 for the row; the visit then finishes through the cancel block */
    CHECK(session_a76_click(x.b, CANDIDATE - 1, &cr) == PWD_OK && cr.fired == 0);
    CHECK(session_a76_click(x.b, CANDIDATE, &cr) == PWD_OK && cr.fired == 1 && cr.row == 1 && cr.phase == 2);
    CHECK(b_visit(&x, 1, 2u, &pa, &done) == SCENE_ACTION_HANDLER_OK && pa == 2u && done == 1);
    CHECK_LOG(&x.f, "1(1,0) 3(3,0) 4(0,0) 12(33,0) 13(13,0) 14(14,0) 15(15,0) 16(16,0) 17(17,0) 18(18,0) 1(1,0) 19(4,0) 20(9,200) 21(1,0) ");
    CHECK(g_stores == 2 && g_store_start == 1 && session_a76_start_flag(x.b) == 1);
    CHECK(session_a76_registered(x.b) == 0u && session_a76_state(x.b)->b[PWD_S_ACTIVE] == 0);
    CHECK(session_a76_render(x.b, &r) == PWD_OK && r.count == 0);
    CHECK(session_a76_pointer_move(x.b, 310, 210, &pr) == PWD_OK && pr.hit == 0);
    CHECK(session_a76_invalidate(x.b) == 0 && session_a76_registered(x.b) == 0u);
    CHECK(session_a76_key(x.b, 'a') == 0);
    CHECK(x.f.n_trans == 1 && x.f.n_store == 1 && x.f.store_value == 200);
    /* row 2 (the other body): its own font, strip and word */
    CHECK(b_visit(&x, 2, 0u, &pa, &done) == SCENE_ACTION_HANDLER_OK && pa == 1u);
    CHECK_LOG(&x.f, "1(1,0) 2(5,0) 4(1,0) 5(1000,0) 6(1,0) ");
    CHECK(session_a76_pointer_move(x.b, 405, 305, &pr) == PWD_OK && pr.hit == 1);
    CHECK(session_a76_pointer_move(x.b, 310, 210, &pr) == PWD_OK && pr.hit == 0);
    CHECK(session_a76_click(x.b, CANDIDATE, &cr) == PWD_OK && cr.fired == 1 && cr.row == 2);
    CHECK(session_a76_render(x.b, &r) == PWD_OK && r.count == 2 && r.op[1].font == 5);
    /* its cancel exit stores start flag 0, which the binding reports and publishes */
    CHECK(b_visit(&x, 2, 2u, &pa, &done) == SCENE_ACTION_HANDLER_OK && done == 1);
    CHECK(g_stores == 4 && g_store_start == 0 && session_a76_start_flag(x.b) == 0);
    /* the next scene (or the destroy) clears: inactive, no entry; the start flag stays */
    CHECK(session_a76_begin_scene(x.b, x.scene) == PWD_OK);
    CHECK(session_a76_state(x.b)->b[PWD_S_ACTIVE] == 0 && session_a76_registered(x.b) == 0u && session_a76_start_flag(x.b) == 0);
    CHECK(b_visit(&x, 2, 0u, &pa, &done) == SCENE_ACTION_HANDLER_OK);
    CHECK(session_a76_registered(x.b) == 1u);
    session_a76_cleanup(x.b);
    CHECK(session_a76_registered(x.b) == 0u && session_a76_state(x.b)->b[PWD_S_ACTIVE] == 0);
    CHECK(b_visit(&x, 2, 0u, &pa, &done) == SCENE_ACTION_HANDLER_OK);
    session_a76_new_game(x.b);
    CHECK(session_a76_state(x.b)->b[PWD_S_ACTIVE] == 0 && session_a76_registered(x.b) == 1u); /* the entry flag is not touched */
    bind_close(&x);
}

static void t_binding_results(void)
{
    Bind x;
    uint32_t pa = 0;
    int done = 0;
    CHECK(bind_open(&x, 0));
    if (g_failed) return;
    CHECK(session_a76_begin_scene(x.b, x.scene) == PWD_OK);
    /* no store_world hook is fine */
    CHECK(b_visit(&x, 1, 0u, &pa, &done) == SCENE_ACTION_HANDLER_OK);
    /* an event flag the host refuses */
    x.f.invalid_flag = 5;
    x.f.step = 0;
    (void)session_a76_key(x.b, 'a');
    CHECK(b_visit(&x, 1, 1u, &pa, &done) == SCENE_ACTION_HANDLER_OK);
    {
        PwdState *st = (PwdState *)session_a76_state(x.b); /* force the correct flag, as a hit would */
        st->b[PWD_S_CORRECT] = 1;
    }
    CHECK(b_visit(&x, 1, 2u, &pa, &done) == SCENE_ACTION_HANDLER_UNSUPPORTED && x.f.log[0] == 0);
    CHECK(strcmp(session_a76_failure(x.b), "") != 0 && strcmp(session_a76_failure(x.b), "none") != 0);
    x.f.invalid_flag = -2;
    /* a host failure is an error */
    x.f.calls = 0;
    x.f.fail_at = 1;
    CHECK(b_visit(&x, 1, 2u, &pa, &done) == SCENE_ACTION_HANDLER_ERROR); /* the font release fails */
    x.f.fail_at = 0;
    CHECK(session_a76_failure(x.b) != NULL);
    bind_close(&x);
    /* without an observer of its own the binding still follows the start flag and the entry flag */
    CHECK(bind_open(&x, 2));
    if (g_failed) return;
    CHECK(session_a76_begin_scene(x.b, x.scene) == PWD_OK);
    CHECK(b_visit(&x, 1, 0u, &pa, &done) == SCENE_ACTION_HANDLER_OK);
    CHECK(session_a76_registered(x.b) == 1u && session_a76_start_flag(x.b) == 1 && x.f.log[0] == 0);
    /* a full answer through the binding: the host callbacks receive their own arguments */
    x.f.step = 0;
    x.f.busy_seq[0] = 1;
    x.f.busy_n = 1;
    for (const char *c = "alpha\r"; *c != '\0'; ++c) {
        CHECK(session_a76_key(x.b, (int8_t)*c) == 1);
        CHECK(b_visit(&x, 1, 1u, &pa, &done) == SCENE_ACTION_HANDLER_OK);
    }
    CHECK(x.f.width_font == 3);
    pa = 1u;
    for (int i = 0; i < 3; ++i) CHECK(b_visit(&x, 1, pa, &pa, &done) == SCENE_ACTION_HANDLER_OK); /* sound start, busy, free */
    CHECK(x.f.play_ch == 4 && x.f.busy_ch == 4 && pa == 2u);
    CHECK(b_visit(&x, 1, 2u, &pa, &done) == SCENE_ACTION_HANDLER_OK && done == 1);
    CHECK(session_a76_registered(x.b) == 0u && x.f.rel_font == 3 && x.f.n_store == 1 && x.f.store_index == 5);
    bind_close(&x);
}

static void t_binding_bad_scene(void)
{
    Bind x;
    uint8_t bad[PWD_BODY_BYTES];
    uint8_t bytes[8192];
    const int types[2] = {0x76, 0x76};
    const uint8_t *bodies[2];
    size_t lengths[2] = {PWD_BODY_BYTES, PWD_BODY_BYTES};
    SceneResource *scene;
    char err[128] = {0};
    uint32_t pa = 0;
    int done = 0;
    CHECK(bind_open(&x, 0));
    if (g_failed) return;
    CHECK(session_a76_begin_scene(x.b, x.scene) == PWD_OK);
    CHECK(b_visit(&x, 1, 0u, &pa, &done) == SCENE_ACTION_HANDLER_OK);
    memcpy(bad, x.body_a, sizeof bad);
    put16(bad, O_FONT, 99);
    bodies[0] = x.body_a;
    bodies[1] = bad;
    scene = scene_resource_open_memory(bytes, build_scene(bytes, 2, types, bodies, lengths), err, sizeof err);
    CHECK(scene != NULL);
    if (scene != NULL) {
        /* the invalid body is refused with its reason; the previous scene (rows, active puzzle) stays */
        CHECK(session_a76_begin_scene(x.b, scene) == PWD_ERR_BODY);
        CHECK(strcmp(session_a76_failure(x.b), "none") != 0 && strstr(session_a76_failure(x.b), "font") != NULL);
        CHECK(session_a76_state(x.b)->b[PWD_S_ACTIVE] == 1 && session_a76_registered(x.b) == 1u);
        CHECK(b_visit(&x, 1, 1u, &pa, &done) == SCENE_ACTION_HANDLER_OK);
        CHECK(b_visit(&x, 2, 0u, &pa, &done) == SCENE_ACTION_HANDLER_OK); /* row 2 of the old scene is still there */
        /* an empty scene is a valid scene with no rows */
        scene_resource_close(scene);
    }
    {
        const int none[1] = {0};
        const uint8_t *nb[1] = {NULL};
        const size_t nl[1] = {0};
        scene = scene_resource_open_memory(bytes, build_scene(bytes, 0, none, nb, nl), err, sizeof err);
        CHECK(scene != NULL);
        if (scene != NULL) {
            CHECK(session_a76_begin_scene(x.b, scene) == PWD_OK);
            CHECK(b_visit(&x, 1, 0u, &pa, &done) == SCENE_ACTION_HANDLER_ERROR); /* no such row in the new scene */
            CHECK(session_a76_state(x.b)->b[PWD_S_ACTIVE] == 0);
            scene_resource_close(scene);
        }
    }
    CHECK(session_a76_begin_scene(x.b, NULL) == PWD_ERR_ARGUMENT);
    bind_close(&x);
    /* a puzzle row at index 0 works like any other */
    {
        Bind y;
        PwdPointerResult pr;
        PwdRenderResult rr;
        SceneActionInfo info;
        SceneActionRuntimeState st;
        SceneActionHandlerResult out;
        const int one[1] = {0x76};
        const uint8_t *ob[1];
        const size_t ol[1] = {PWD_BODY_BYTES};
        CHECK(bind_open(&y, 0));
        if (g_failed) return;
        ob[0] = y.body_a;
        scene = scene_resource_open_memory(bytes, build_scene(bytes, 1, one, ob, ol), err, sizeof err);
        CHECK(scene != NULL);
        if (scene != NULL) {
            memset(&st, 0, sizeof st);
            CHECK(session_a76_begin_scene(y.b, scene) == PWD_OK);
            CHECK(scene_resource_action_at(scene, 0, &info) == SCENE_RESOURCE_OK);
            CHECK(session_a76_handler(y.b, 0, &info, &st, &out) == SCENE_ACTION_HANDLER_OK);
            CHECK(session_a76_pointer_move(y.b, 310, 210, &pr) == PWD_OK && pr.hit == 1);
            CHECK(session_a76_render(y.b, &rr) == PWD_OK && rr.count == 2);
            scene_resource_close(scene);
        }
        bind_close(&y);
    }
}

typedef struct Test {
    const char *name;
    void (*fn)(void);
} Test;

static const Test tests[] = {
    {"validate body", t_validate},
    {"character filter and key", t_filter},
    {"phase 0", t_phase0},
    {"typing, cursor and backspace", t_typing_and_cursor},
    {"width and character limits", t_limits},
    {"enter, one field", t_enter_single_field},
    {"enter, two fields", t_enter_two_fields},
    {"sounds and the finish", t_sounds_and_finish},
    {"phase 2 blocks", t_phase2_blocks},
    {"refusals and arguments", t_refusals},
    {"host failures", t_host_failures},
    {"pointer and click", t_pointer_click},
    {"cells, cleanup and render", t_state_cells_and_render},
    {"random smoke", t_random_smoke},
    {"binding create", t_binding_create},
    {"binding flow", t_binding_flow},
    {"binding results", t_binding_results},
    {"binding bad scene", t_binding_bad_scene},
};

int main(void)
{
    for (size_t i = 0; i < sizeof tests / sizeof tests[0]; ++i) {
        g_failed = 0;
        g_msg[0] = '\0';
        tests[i].fn();
        ++g_total;
        if (g_failed) {
            ++g_failures;
            printf("FAIL %s: %s\n", tests[i].name, g_msg);
        } else {
            printf("PASS %s\n", tests[i].name);
        }
    }
    printf("%d of %d passed\n", g_total - g_failures, g_total);
    return g_failures;
}
